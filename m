Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22B88CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2988E00CB; Tue, 14 Oct 2025 07:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7534C8E000D; Tue, 14 Oct 2025 07:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61B1F8E00CB; Tue, 14 Oct 2025 07:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 484728E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:03:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED7AA11AFCA
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:02:59 +0000 (UTC)
X-FDA: 83996432478.08.2B1913E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id DE645A001B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:02:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e83mDdrq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760439778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s2r/L8/q4C9e2I164NDxUGdYhK/0nvlG6dMGzaNBqVg=;
	b=xoZFjVP+D+OB/EZbXTAYMEqbvG8teGZLDaakJC+RVawKeusDMf8o9/lN7YrTvXoMNLPtyN
	qgCStEMTJ0Bhqupru0Cv1aQyNINSHF0O5Ta7QCOtXJDdm8wPISjFeqDgmxVKf7qxgAbkyA
	0kZXTGagKancBFReotXVhIDLYVmrm4k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e83mDdrq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760439778; a=rsa-sha256;
	cv=none;
	b=tvxaJNZtgpjmi/Vvh0dcfW7ECYAGdHgGdEDsXRkFhL95gQZt0QUsLdIsItciZLcXm7+oTQ
	Ta+lIEiTKuEDV7sO58FkLTYxJ1BXS3DQZOuP0jprcfZUkAa3ASX51IyVVBp88YqAt3bBrk
	63ls7IiAzj9pBc2tmGkMRE91EnmVim8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760439777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s2r/L8/q4C9e2I164NDxUGdYhK/0nvlG6dMGzaNBqVg=;
	b=e83mDdrqUjDTuwZOBUhrBr3TEQ/TkIV8qTEniGUfnpBREMz0qkkI/uMbWOP4Dgm+hIdaNX
	3moPEZQkkSVDIOsXJulDC95g9GeF0uOMCE/NtlX2T1xrFCJhz6UsRK8B9MFTOQy6Nw9qvD
	X4lXGxiqvUIynZmtSwM0Hy9XFEWA4EI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-5qbEFNGROVyu6qf5HAUaKg-1; Tue, 14 Oct 2025 07:02:56 -0400
X-MC-Unique: 5qbEFNGROVyu6qf5HAUaKg-1
X-Mimecast-MFC-AGG-ID: 5qbEFNGROVyu6qf5HAUaKg_1760439775
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e41c32209so30122755e9.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760439775; x=1761044575;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s2r/L8/q4C9e2I164NDxUGdYhK/0nvlG6dMGzaNBqVg=;
        b=EFgVUWtFxeWKnBd+LIfnZcFFBccePdX+xUexm2/hjLNS4N1IEcKLkbL0ps1c5s5+yU
         KwJNO7b6sAvyizJDE7lFkZGxkvoTmyX6z8jwGOx6DqZpW2ToVKEPuh1Jh8VLFTZnMwwa
         o4hV+qeTYAZH1jPAj49QO0IA+CLvJvAbnA3Aq2VvJ6BDAckEGsxfVKOg5j7hTg3RT+SI
         tjsEjl1XNBz9U7zMrgebm8sYbx/3l6eVxmaFufPE7sRjhBCc466XhVgWSck8mXy2P3LL
         5rIS/QOM/Y0/PXS09Y9ouRH+F7wxchrUonYXl6aupBcfcfupBXpIf0NxW8XRHydZMAYC
         K97A==
X-Forwarded-Encrypted: i=1; AJvYcCUgkveiLwzYCE2rI3JhrL9HWj69cv/ZJBw+sqhBIvNaQou9NYDN9MowD2tINFoEr/FSG2xEgUWxMQ==@kvack.org
X-Gm-Message-State: AOJu0Ywe5EdlFyT5swrwvnr+W02Cu5ybJAtRTrOoLT+zvinJnQKckHKg
	7GVHG2pStiumUe02aX+chxNzCwRyw3XX26ufwAPyiRJvld9S96wPI2lTSGXtlgMfwfaPOrm9PxI
	4iSlQEMdZhFcvIX0jVjRQXPjz27D8i218lPQUFrF5VMoWa42Fuddg
X-Gm-Gg: ASbGnctYEP1svP3nbOOLnW4S9OyRVBbdO8tNDncmQcZxOM+6oaDrHZ4ZGyL+xNL6pqg
	fnnzvx85O3QbtuuF47RorFp4N1HqpwK+sJYRiS78kGadobqOQu0S6GNyL8GEhIPXuvsKMu/Mdtm
	VcAO0udPoNG9pJpMmjx5feORMUoL1xvlmxTZtsg2Y5VGjfeoIEyxwaNGx7UW3sqpUf7WpibAOkp
	k8fS/AF6j5KSSxDw/xen573FAwh0FIxs9iY1Kt0z4nrGo3niG0JkWCzNcwRl/VOQxKSWGbSx8l9
	GPPouiUdWP4hor2SGyfb/jiqdeErFnQLKWVC2I+P1v5bPaRJV2RQNA/gqLDktpouyktgpZ5+SCT
	G3wGOq565uqXTC4HXaugtyO5EYA==
X-Received: by 2002:a05:600c:4752:b0:46e:3dad:31ea with SMTP id 5b1f17b1804b1-46fa9af8fb0mr181929415e9.17.1760439774567;
        Tue, 14 Oct 2025 04:02:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCodl08uTX0ubswP5nTiGxebtIpD1Qw4JnrqS3e+W7M5qhx4w6eQs0AuIjitoXX5t0l6/vwQ==
X-Received: by 2002:a05:600c:4752:b0:46e:3dad:31ea with SMTP id 5b1f17b1804b1-46fa9af8fb0mr181928825e9.17.1760439774097;
        Tue, 14 Oct 2025 04:02:54 -0700 (PDT)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426f2f72e18sm1737515f8f.0.2025.10.14.04.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 04:02:52 -0700 (PDT)
From: Valentin Schneider <vschneid@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, Josh
 Poimboeuf <jpoimboe@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker
 <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, Jason
 Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard
 Biesheuvel <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 "David S. Miller" <davem@davemloft.net>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>, Andrew
 Morton <akpm@linux-foundation.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Han Shen <shenhan@google.com>, Rik van Riel
 <riel@surriel.com>, Jann Horn <jannh@google.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Yair
 Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [PATCH v6 19/29] KVM: VMX: Mark vmx_l1d_should flush and
 vmx_l1d_flush_cond keys as allowed in .noinstr
In-Reply-To: <aO2S3oZwOW_UgAci@google.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-20-vschneid@redhat.com>
 <aO2S3oZwOW_UgAci@google.com>
Date: Tue, 14 Oct 2025 13:02:50 +0200
Message-ID: <xhsmhwm4xpwyt.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GaIRNbrcQd9BJo9byqE2XKKZdfKLf1TXgc_5vZEErF8_1760439775
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: DE645A001B
X-Rspamd-Server: rspam03
X-Stat-Signature: ebx7d58gntea4ppuaqdib53ksbp8dgjq
X-HE-Tag: 1760439777-305085
X-HE-Meta: U2FsdGVkX18L72yCutB37aNZgmtVwLmFOaHzmS8XJ1VUFsnVivkh63OYK9HhPoDeTGP10epHM2otXnL9EAFiqo+oLZc895xt8MqaDYaCgopblp9IqFOMLB6+XBYAGAcCdMUiLAXDkhovDDPmJ9XCeLh82oFjjwY3qKPfHHI0cf2hBFZBy2rzvD/FBc5IBglYDOFq3/ZaF+MERiiCLrx/bEwF7CA/t3azafIFwQg8AESTgQjZO4opLxGic5DvHDxjkBdaFvsoBFryR5sSXIUzwZK/B4IatgTa2NhTOKm9Y2qZ4d8pgtRDV+zD+aOwCncr1SHQv/uWBfuJIyaoYgsPmXT2rCMHHX5dS5xWK9ecseTp+QFGWJTUprfNT5CEDJWrUAEgFblvz1eptJQGSID52FnM1x4X7Mt9bwISvbW0cO4pskDzIvqcciGj+jLKS4U47xHFrg1ThiY7INW6409yfd0GIcy1eG45s+V5WuOSJHg2LLpcT8F1VNE7QMwCbKzSAEZGnevF13J2Zx+FBGgHZk4y4lY8gqoHIPBbIqnFTaKtHtZNSH4FnTZn8L3JsheUIieEqod94kbNbzlm58+e50o81ptXFaLSXZ45Hx6QOv34aArC7hpxmxaxAiYmyl6UD0iy268VicqwybyMugwGm0pMx0I68RLRdUYYVrrg2Ywo+JDoZ6WJddaUrOGSNMy75xfymzao5oZDqIq8OH9u38mVNV3jZ6o2GE98Wl4k5GjCqGdbh7eqPvceE9AS288LIAENvb9T9Dv+jq7azLU4u8JBpEIjfyGsOyOYIySP2J/eoh9cfoi2bu2b2OhsJrf2LYv5ZeZO8t+PrwwFDrWGsi9IcOEYaNyDV3HOlB58UX3FPnivy5OwEinO3zoCHXUlYSytZCXbS/mGNgtLAHn1U8pVJopxYtr8IZ59N6J8NYC3bHPY8gSsVZt4W5oP76HUgIphkLI2o5Fd0/Q0Kcf
 LdEDsZeM
 kyr7Z4B3jIeRCXoDSSAnheJRocGfkhVfr4fzhY9wcCmI8NPeVx9m2ngd/HTq5oFWqO3DhToXSvLdNojeJYtt4IooGecsCmWksApzflvURva5XqY+I8mbbyREW7yoftWEJxwwRN5l+QcnsIeR9pD9vr9dkOhhfUhHYVkK5bBXPcYGibHp5TSAqsOeqn4RwscZdcUNTAnic/NH+18+hdfjkG/LVWz9JwY/gTyDcTJhBJHnwIXA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/10/25 17:01, Sean Christopherson wrote:
> On Fri, Oct 10, 2025, Valentin Schneider wrote:
>> Later commits will cause objtool to warn about static keys being used in
>> .noinstr sections in order to safely defer instruction patching IPIs
>> targeted at NOHZ_FULL CPUs.
>>
>> These keys are used in .noinstr code, and can be modified at runtime
>> (/proc/kernel/vmx* write). However it is not expected that they will be
>> flipped during latency-sensitive operations, and thus shouldn't be a source
>> of interference wrt the text patching IPI.
>>
>> Mark it to let objtool know not to warn about it.
>
> Can you elaborate in the changelog on what will happen if the key is toggle?
> IIUC, smp_text_poke_batch_finish() will force IPIs if noinstr code is being
> patched.

Right!

> Even just a small footnote like this:
>
>   Note, smp_text_poke_batch_finish() never defers IPIs if noinstr code is
>   being patched, i.e. this is purely about silencing objtool warnings.
>
> to make it clear that there's no bug/race being introduced.

Good point. How about:

"""
Later commits will cause objtool to warn about static keys being used in
.noinstr sections in order to safely defer instruction patching IPIs
targeted at NOHZ_FULL CPUs.

The VMX keys are used in .noinstr code, and can be modified at runtime
(/proc/kernel/vmx* write). However it is not expected that they will be
flipped during latency-sensitive operations, and thus shouldn't be a source
of interference for NOHZ_FULL CPUs wrt the text patching IPI.

Note, smp_text_poke_batch_finish() never defers IPIs if noinstr code is
being patched, i.e. this is purely to tell objtool we're okay with updates
to that key causing IPIs and to silence the associated objtool warning.
"""


