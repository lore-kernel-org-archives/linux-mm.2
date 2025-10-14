Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF3ECCD183
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 00:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839348E00B5; Mon, 13 Oct 2025 20:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA208E0024; Mon, 13 Oct 2025 20:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D85F8E00B5; Mon, 13 Oct 2025 20:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55B158E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:01:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E68211AA7D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:01:39 +0000 (UTC)
X-FDA: 83994765918.20.44B4161
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4D49340002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:01:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SmU7VCXj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 34JLtaAYKCAs3plyunrzzrwp.nzxwty58-xxv6lnv.z2r@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=34JLtaAYKCAs3plyunrzzrwp.nzxwty58-xxv6lnv.z2r@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760400097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60W7dGApFCGXHKlXBRGDaLpu3YLgl4WyK3JcN6QaedU=;
	b=2Wtxi9wuZbWGRGfGxJ6HueufgAylo0LXSXz/P8WAqzPzIS7NjDaPLMr7IeXWz7SCxgMp+p
	/qA+PeJ8N7EHVdcOcgeDnNSmVy3Ceo9tnJ/mSMYnCOpH1zxUW3skGhKuaKqyVJeFN8YFUz
	mGYxA2oiag0yhCgsQX68JPHrwf6m10g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760400097; a=rsa-sha256;
	cv=none;
	b=1Emqj+ccY7n2ZAR/TkwnGB3UMlSjBMk06/X4WSotaz07J8Kuz7uJNNMY9/EITfRPIz/l3K
	aMZc2YqPiDqcyLDKT1JMBtpQ1jEMj71CBlqcBe857BkHFoz+zhSvWoaqKZ9WoMXzQHsmp+
	I+R9j15h7rawVmZ8qz/PzKjhYDFrjhY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SmU7VCXj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 34JLtaAYKCAs3plyunrzzrwp.nzxwty58-xxv6lnv.z2r@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=34JLtaAYKCAs3plyunrzzrwp.nzxwty58-xxv6lnv.z2r@flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb18b5659so8431523a91.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760400096; x=1761004896; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=60W7dGApFCGXHKlXBRGDaLpu3YLgl4WyK3JcN6QaedU=;
        b=SmU7VCXjL5N7tEMa84vuze2DbbaO6sLX4QkeODYXQHek0NrHWaLZL1T7JkOxFbN+79
         KnBYAgQX3bpSqhnVi2trFd9gKuvXcMJ0+z3XBHrnqAMQoz85Oo+20mI57kyYlNQlVEUi
         8XOZuCyKpkskqQ9ANI7r3iEue1sj/qEngCrsMBzddlP+Ld5XgX2oZ6QDa0t/LlYTXV5/
         ZwDXaOUe4VvfcJCFrnqA7YWj+KX7qO/3+T/85nCdIZWQ9IvV3S4Yy8/gCexIIB+cMNjE
         E+UPfEIy3uveHe12hxNU0WeYoi462cQiTB3862iCia5FhCu/YA/bHJkXgpHKBa6qCccb
         dajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760400096; x=1761004896;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=60W7dGApFCGXHKlXBRGDaLpu3YLgl4WyK3JcN6QaedU=;
        b=Xk2etlf72xqHkWtbO2tGTrEyi9vXjMTJcveMaAJPNGaiO7XLK0G0PMAL5QL83s06Qo
         19Zc0Orx5nkuATxIJp/K5pEFWov/tURhIkPuA3YU1dYiUDu3UTz5qyOxCictVkJRxsKG
         PvXAZTjaM193wKmWX0NhhuPNMZcjP5h6jyzbf8LR8xtD5ayNp6mElHBGhoHvr/n+t1z0
         PWHOxoPg6HgdsAYXcT48VNp4EII4tOPKuKtzmEyqGLj361Hc9RMGxfya6D4ZA1uzcNo0
         jrfwK/B4uWdUapmQWHiFf0zbM5sI1dwYtgOyL1aonqoKfgqqDPUh0jrtrdl0XpyRYUaw
         D4hw==
X-Forwarded-Encrypted: i=1; AJvYcCU4+T/1PUcJ/qUQSLzdXb35ZZo6vxY4GyXowoZynFoD/78PJLnpeE1LkY1NU4R0pKtde5tdoKJiuA==@kvack.org
X-Gm-Message-State: AOJu0Yzkov4WYo+JsTyL1+zN8eUIO0LGTRa2fqiNMDcitdH9xKYdl7C0
	2D6DHBQd0bEfoPGn7vS9AagWuD0rYtdKJAlbKlSw3JrTpP++L2+yuqLYHvl6mV/FDN6iHWVJfIb
	yigQrow==
X-Google-Smtp-Source: AGHT+IHFYfnmFjxjbFQp7BMqqD83h/lwfyE6WGt5bwyArJ6H0ox9P/tbWn8NIGRGgabEk9PVFSZMkd4SLvs=
X-Received: from pjbbk16.prod.google.com ([2002:a17:90b:810:b0:339:dc19:ae5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38d2:b0:335:2eee:19dc
 with SMTP id 98e67ed59e1d1-33b5138401amr31287086a91.28.1760400096074; Mon, 13
 Oct 2025 17:01:36 -0700 (PDT)
Date: Mon, 13 Oct 2025 17:01:34 -0700
In-Reply-To: <20251010153839.151763-20-vschneid@redhat.com>
Mime-Version: 1.0
References: <20251010153839.151763-1-vschneid@redhat.com> <20251010153839.151763-20-vschneid@redhat.com>
Message-ID: <aO2S3oZwOW_UgAci@google.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D49340002
X-Rspamd-Server: rspam02
X-Stat-Signature: 9m7p5ojhn6gfubwrydhpbzasjec1x3qj
X-HE-Tag: 1760400097-252491
X-HE-Meta: U2FsdGVkX19jD1a2BnbA4NTe87+0i01pRHNByoKlkypYvrdu3M41cuoi/s2wcoWSzcAv3YAV3xOpFpUOYHoIqsH2RqycVqEVMrcgq+YPUuEaLhyiNG7FFU0Q0Ogi11v4VKOTm/lSe9dqpX/yc4Ilm3CLfTsotpFJsixN75GkKoNptEWNiNArrj9oubuPC6fI4W1fHA6DNVk6N7ydbz+zAnQ5EJwdmdVKwVBbjhaNabO2zqyVlH2GbJEB9NYPSf86UmH1Zjez5D6bO4eMj5DqflQYuLY/PBZzvIwYjHyutkXJdpaalabzTSQQRkUzFB2vG5Dr1dIldpuIMUT24jQecSvBU9c8kre3o1GkYdb9VqR+8kNFIc0qsE3Rfzupjysx9xV+IRi5r96npDZC5reBSSf3eTdu3CsnNRM/4Ncx1y5PZ63fzCrqbUQylldRphY4bSlGDhhn95/Qv5VvOEjv5J0dL5AsyAAZ43fMvf82EMNFm/8BA6naT6wtlHovHPGWjcfEg/za0mcftIKLSwMm4xeVUmb04F9ySa43jKyrntacIPlbcxBx7qhJ6Lq5uoFpIFByJGgxPu1TwArXUwcQxgLOj45awPUARmTOhe7mr4BeQrJ8zQkuARMFdyvTUQokj2D4aZBkwhpbDoufsXMEo4rCjVFChd5pi5tEzhalrkj08USh0BHlXUtMXPFflhf96xmtNhHZvLhcIacF8sf6O93z72oCvmKL4yMOTizuqMAyIGompMYkxMbj5lh1K/2xmYVg/1vg4gyaypDUwBr2XLUoTi193FnPhc5SjueD3Hk3TNFiRpAuA0IS4SzMBFQYDnKNyMwRyJcigFKGdBNIq414e9KrtdoEB9RVORIU5WPZZa6Qx5pP+UxBJiXyhZlxpRFChEW51nM+Gf2Pnzkh8Kv5wxIoIhXikKK76wexe1Uo/Zqwb7hmemf413W8CKo5K8yWDo9si7p0Izaa8r7
 ZC0oxPAZ
 15UfleeGA3Jozt6/CPcXJ9Zjg4d73OZsZkVSRFCe0mF8sj9J15fiiENn8RmOAjh2Zt8bCASDwSOK+hKKqCwMImYTZnReRBhsBGGdMjtzv6F4P4rqr8u/p7FOW2XadB2WAQuua3MjosYVQHRBG/zo/GdOclBQCUqT0DgOIt1BP3YlD79pDYbxmH9+Ra2rwL3mPym44NtI7/DB9m6HWewxEeIJ45NjOmmoXtTeH0GzTQldQaLl6N5GMasRPAS2UreHUiFYwyd9/LE2MpkTBNsKxGwEE8HTepj6QudiWqhcAv9GNpM6m92Mah++T7MB2aAhuiL8FraAeTNyB/SqNZGq+MHRrkrnwQLKEENAGJu9r5Z9mX3IhO3C3+NQhsH0DWVAfpe2JpsPJpIYvz+R1Befy0iBQ/+12Y2CX/kw+j52e6w7xHQTMtEJ8824epbaIO9BYY1857P/tmWzvfnJsMiYFZg0UjwqYv8R5q+wWq2iSVeIQy/UClN2lWj8o1MXqz/FxZhxwegKHjXRZ76aRzqzrGrVAFCKDfOGdmLjUt3Wr8X8MX7GOjvTm2fqpzlFCgKDl3qZWZDnnXFU6AGS+8LDmg/kyUD4G9xdfQ9fql6UKw7OQtEDe9Qztj3JmdhQk+xu8gSP5vyd5FWFAi/BwhNjZevANqzEztRsp3fdp0MJDfTS/CuUNUfTYio/Brcg5IIqxFD3LaeGa+HWlU9+oD2VvsLLrDKlL915V2Khb/qdSR6sIYBZnfHC0pm/7d9Xtj40WkRLW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025, Valentin Schneider wrote:
> Later commits will cause objtool to warn about static keys being used in
> .noinstr sections in order to safely defer instruction patching IPIs
> targeted at NOHZ_FULL CPUs.
> 
> These keys are used in .noinstr code, and can be modified at runtime
> (/proc/kernel/vmx* write). However it is not expected that they will be
> flipped during latency-sensitive operations, and thus shouldn't be a source
> of interference wrt the text patching IPI.
>
> Mark it to let objtool know not to warn about it.

Can you elaborate in the changelog on what will happen if the key is toggle?
IIUC, smp_text_poke_batch_finish() will force IPIs if noinstr code is being
patched.  Even just a small footnote like this:

  Note, smp_text_poke_batch_finish() never defers IPIs if noinstr code is
  being patched, i.e. this is purely about silencing objtool warnings.

to make it clear that there's no bug/race being introduced.

> Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index aa157fe5b7b31..dce2bd7375ec8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -204,8 +204,15 @@ module_param(pt_mode, int, S_IRUGO);
>  
>  struct x86_pmu_lbr __ro_after_init vmx_lbr_caps;
>  
> -static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
> -static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
> +/*
> + * Both of these static keys end up being used in .noinstr sections, however
> + * they are only modified:
> + * - at init
> + * - from a /proc/kernel/vmx* write
> + * thus during latency-sensitive operations they should remain stable.
> + */
> +static DEFINE_STATIC_KEY_FALSE_NOINSTR(vmx_l1d_should_flush);
> +static DEFINE_STATIC_KEY_FALSE_NOINSTR(vmx_l1d_flush_cond);
>  static DEFINE_MUTEX(vmx_l1d_flush_mutex);
>  
>  /* Storage for pre module init parameter parsing */
> -- 
> 2.51.0
> 

