Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93A4DCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 19:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5FB98E00C5; Tue, 14 Oct 2025 15:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0FAC8E0090; Tue, 14 Oct 2025 15:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25E18E00C5; Tue, 14 Oct 2025 15:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA7B8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:06:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4AB70888D4
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:06:37 +0000 (UTC)
X-FDA: 83997651234.07.154AEBF
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 84DAF14000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:06:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l0TW3OCc;
	spf=pass (imf23.hostedemail.com: domain of 3Op_uaAYKCIExjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3Op_uaAYKCIExjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760468795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJxlV+oNDwXk+z+h9rw/7gmtAEVoUIc/lNQpO7FKflY=;
	b=5wTt9RF82nVyl1eE/aAJz9N9efi+xK9s5hsAymt04PBJgeoj6iKSz9fsDFRQRCihyjsK43
	rQNQRW/0o62qJTQdhO9eJRBvGWACUhTuwb/eKQHKfJiCG/MxdelA8Inrjg9X5cKr3HCnqu
	e4HJb8MzhNbS6cngLD3ukdH8zdIFCeQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l0TW3OCc;
	spf=pass (imf23.hostedemail.com: domain of 3Op_uaAYKCIExjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3Op_uaAYKCIExjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760468795; a=rsa-sha256;
	cv=none;
	b=NmPGKFyhBMaAij/LrySkUxybic9uZ6HRwhPrO+unhpMJ6YjqDnbEqbscNDdjoV/qjEdf1r
	W7joyEkgv8JESJBTZmzmg/1qwg5j2fDIDSXm/GVzO/5gm3h2bzL8SlFkWR6ejgIRuAsKOw
	qsLftncexRfauT8nqhzklemwZdSy4Kc=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ee62ed6beso15389545a91.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760468794; x=1761073594; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NJxlV+oNDwXk+z+h9rw/7gmtAEVoUIc/lNQpO7FKflY=;
        b=l0TW3OCcBrlg2xZWcUWIZlU2sryW1f1PYGE2MJ2xeYxQZAJFWhZ8BQNqTRq3FPT1QG
         RKgHS4YA9r9cCTXo7zOCwA37Ye8QnGNGZmfXsLWVSYNqQJ2Jr1YOVOHYXA0rWN76LD3d
         qw9oApCeIUysyvTd09CSVE7NXJfigTlgA7gskMZ6WEF/S+QnGbYduqhMRECzEQc4kMOr
         os43vDoBxMfUV3cQnqWNBHPTXDjC/valvqtGWFCqnmMy9z5HmF2Vi0FGZtLMPcePQNTM
         +bO7T+FfBe8t0sYM8AvEYpdetatGM+lnj3gfhYCzVQvAmcmSFh4Uv0503j4TuxgDwua2
         gXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760468794; x=1761073594;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NJxlV+oNDwXk+z+h9rw/7gmtAEVoUIc/lNQpO7FKflY=;
        b=aN5frjiHiIbf0XGFRJzNXcdq44LOpFrFOwkwNGN/gUZrpXOULUVfYrKOV59WMFdq4c
         FLeMPzf2ntw7ql+KbMMy+/udRFS/MYoO84PZX+5XSTMIKOJulOC+96uHiT0/FEQwyu/j
         hChPHRqJhWk8CmfIeVIoOBxCtpe3uOPJ+yfdNlIHR+29WlUygoZQKCc7DNaVCjLuJicC
         BQE8YHXwzIwHp3KC6GHppg4UmB99JS44ec7Ulrs33/nFKmMVvOfdQpzVDRsH6BC8B0uF
         eoaCDICBiwd6wvIl6JoO8o1LHav8jiuqH3WO3RI5Fv8uoiLyTy79Qn794qaEmgJrRXFA
         7XLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUWUTy7opuryuqCqmtZ+mVTprgBzedG01utDeOZEDJEGlCmuFzsXX+FxB50BqQyFSVTuQ0d6fJLw==@kvack.org
X-Gm-Message-State: AOJu0Yxm+ht70pm/EuFgrGHjNKMZkKzrHh7PgAgmzJElj4TPybfbxLeN
	xSjp1HXWvvssmxVED8/E/LrFIpMB4OwAwpKQaVGCYHTx90VOLmF73xKJGdKYotaQhDce1ppHgf/
	NbaMYVA==
X-Google-Smtp-Source: AGHT+IG9Zd3t+86XRNhfr6MOl3z2x5n36Sr6uReq0nGSm2P7jNviBzkfzWGC0x9bWFlsxNGdGfsNX6JxluA=
X-Received: from pjuj14.prod.google.com ([2002:a17:90a:d00e:b0:32b:95bb:dbc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec5:b0:327:e018:204a
 with SMTP id 98e67ed59e1d1-33b50f85081mr35201870a91.0.1760468794156; Tue, 14
 Oct 2025 12:06:34 -0700 (PDT)
Date: Tue, 14 Oct 2025 12:06:32 -0700
In-Reply-To: <xhsmhwm4xpwyt.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Mime-Version: 1.0
References: <20251010153839.151763-1-vschneid@redhat.com> <20251010153839.151763-20-vschneid@redhat.com>
 <aO2S3oZwOW_UgAci@google.com> <xhsmhwm4xpwyt.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Message-ID: <aO6fOM-XydknM6NJ@google.com>
Subject: Re: [PATCH v6 19/29] KVM: VMX: Mark vmx_l1d_should flush and
 vmx_l1d_flush_cond keys as allowed in .noinstr
From: Sean Christopherson <seanjc@google.com>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org, 
	x86@kernel.org, linux-arm-kernel@lists.infradead.org, 
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org, 
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Frederic Weisbecker <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Jason Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, 
	Yair Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: xqx9k6yhfcioxydjtpbcbd74o18j7pin
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 84DAF14000C
X-HE-Tag: 1760468795-955696
X-HE-Meta: U2FsdGVkX18KXCRaA/oQs2VxjIB0CXdWSePp5cbvb97LpIzMksr783+4PTv5ep4cyGZtuSrqsqN9WEbjX8FF6rH9GgSkxQkay49LtHRGYiuB4oZyKcSLZr//iQWkO2sqTt4RtxhmvJfGsmSkHG2uRmGIScHBAKNLXhYX0FLbqJrQYMm3ddvZkehJNv8dW6FVMUN5TRWS5DPjZiDwljEfpn5i7GVaS5tEsJf7DTPD2ric4dHF26O/zV2X5Th0T12c/51bBeS/lSZeseyp5Tfno9sP9gH0vzxPpSmU9OUWD8xls2LnoZBB0GWlDSb0lVp4mkSvr/QthLL8tdHmVVuf4VXSdl/Np6jIFep9jeLJH9KQMhRo29YsZlkN/54j3TPKSvgUzUGxPHpuqN8M656+YjARDOB50xsEIvZMR50+WWrA+aXg0FMZAC+Mc4I/kcKkpj+sixFUH7x4L4y1bMWX/kfuKS/aMnp/50EH4r/193K5E75a+6yoO9+sFCGw9LuzT96Fp7RPp+bSTne2UtrTHjxtCCrBLMNiSngNZj9vs0k3tbZ+uTQaGlMk2j1v+jU8LjvqWRsuZAsNwIsLJ2aeLKhWtV0OwVJoYR6S4hR7b7eG6AoU3N/BAkjra/S/2oYiv0V06I9Tiw0XfW+AYws2q8h3k2ap9mJZU+nchb7T9ZHgAvcBCPAX14XIY+eVEu5XDOx5uDXS9BOZt+O1JvJ3xT4XvWThL8a3sVxDElhg96YSVpDSlcxo3xgO2nDMa4HGc+1clv7KN0hHsHCPdslY9CkYix9n/LBm/3dX6wMAX2uve1jDOj0DLihkoJNTX2OzcY5i/9qE+Eby2BYlhNLspFh0LRt6+gq935VJJapZzPQT8nxNKumViJqEJGy05L6GJtDSYYxxJNTsJV7vbaRwzeo/lyf/51hZn3mYiu4QpqEfKGDmb9VOXZm9E/F5oaFRX2Q0uEpYV5IPi6CEDwy
 lRqxfYKL
 8rDEM3mQmmWeEGH30gA391NxN530X/z4wQ6cEhnxHgz7HKONK6dC11ogN/ba52weYDH1HbFOtOJxY8nILMzLk+q+vxoXHEVkD6MdtP8gYaBPjHM9V3TpyguoNO3qLE5g2cB7plkWvQwLT2fbrhqnqG8FHk8fcxgldpoZEA2pOoj0oTeXT0TPd38DARC8LfKrTeymtTlvXuCjcyxrt/1qBekn4pn55i4DsouuvaassPPsXlM7C+mDyXoSUeLw08rl2KldImpg0F726Aq7ttyTN8VPmt6UYGV93Fax732NCJgnWWDq9YNdkcpAGHsHXltzPzuNuNoF0pUQg/D9aJPtE7Z9pQJRqiinykOnIUXNDnlFtZyLzkyBXNEjR+nqFfhoobr1wq95c+dPlUNCMu9gLrA0xet9vDakAl3hyeXY2PSHyyQyWoYusjRu3P0m2uTCHNJTfKb7Yf5krpLZZytv6UAnCPPpU4qPX90+48sSMmpi6xscSb5Xf5FgAzZ9axCHEdxOK885D76XyRHR2mf/LMYNjT1LxE3gLx0KZVhxW06dg6Ymvh/hlPo++vQ/bfTDrRaeVzmRyfCfsXog0vQqFlHRgoOXQ8/a5OHJ3QRLsOA7OGanccx6cK8CyH8Z4mBETiPmD8/gZ+bwXVgNCitkuTM6n+BaNxsWEF5Bd8p+41foMb0n5Fqd+LhHnKR7oc6Uk0RS9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025, Valentin Schneider wrote:
> On 13/10/25 17:01, Sean Christopherson wrote:
> > On Fri, Oct 10, 2025, Valentin Schneider wrote:
> >> Later commits will cause objtool to warn about static keys being used in
> >> .noinstr sections in order to safely defer instruction patching IPIs
> >> targeted at NOHZ_FULL CPUs.
> >>
> >> These keys are used in .noinstr code, and can be modified at runtime
> >> (/proc/kernel/vmx* write). However it is not expected that they will be
> >> flipped during latency-sensitive operations, and thus shouldn't be a source
> >> of interference wrt the text patching IPI.
> >>
> >> Mark it to let objtool know not to warn about it.
> >
> > Can you elaborate in the changelog on what will happen if the key is toggle?
> > IIUC, smp_text_poke_batch_finish() will force IPIs if noinstr code is being
> > patched.
> 
> Right!
> 
> > Even just a small footnote like this:
> >
> >   Note, smp_text_poke_batch_finish() never defers IPIs if noinstr code is
> >   being patched, i.e. this is purely about silencing objtool warnings.
> >
> > to make it clear that there's no bug/race being introduced.
> 
> Good point. How about:
> 
> """
> Later commits will cause objtool to warn about static keys being used in
> .noinstr sections in order to safely defer instruction patching IPIs
> targeted at NOHZ_FULL CPUs.
> 
> The VMX keys are used in .noinstr code, and can be modified at runtime
> (/proc/kernel/vmx* write). However it is not expected that they will be
> flipped during latency-sensitive operations, and thus shouldn't be a source
> of interference for NOHZ_FULL CPUs wrt the text patching IPI.
> 
> Note, smp_text_poke_batch_finish() never defers IPIs if noinstr code is
> being patched, i.e. this is purely to tell objtool we're okay with updates
> to that key causing IPIs and to silence the associated objtool warning.
> """

LGTM.  With the updated changelog,

Acked-by: Sean Christopherson <seanjc@google.com>

