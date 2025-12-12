Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02ADED49220
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 12:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2677D6B0005; Fri, 12 Dec 2025 07:46:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218376B0006; Fri, 12 Dec 2025 07:46:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E5E6B0007; Fri, 12 Dec 2025 07:46:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 011AB6B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:46:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6041A1384CC
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 12:46:17 +0000 (UTC)
X-FDA: 84210791994.06.D7AD716
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8A9D580006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 12:46:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UF3MsyDF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765543575; a=rsa-sha256;
	cv=none;
	b=Jy8OTCT0hH8M1j3A11ldBjxeM4VRdu3W7xAzIw72ymBfG+Gl/IXrCMEBLt71KaFHn8BdW4
	K2nJFQx9vPqFfe4AnWASQcw/Zer4imI3kKEAm0LPRQkiz0Qb43sTfKhOxojWUfaOq3Myaw
	MSZ5zMe1tUvi9X0Be2lGxL/AdI0Wv8Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UF3MsyDF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765543575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nA7IxAffT0jShcW8gwjmTQr11pMi+BjOFiGJxDMKjNo=;
	b=m20MTpYTqLezoXzBb12VSYOTyynNIPuGztrdpuvNvsxAKdoqKxsVTDxTjz0UfXHruYBMZ9
	vjvFypi3VOldLN3XMiMfSg6ZiQYgzvIu5xZOwjIOpwg3Ac6DHpu7Frl4rukMOkYq+OXZzb
	GWzNLYtUwF/Vb+eUJIJKqwLxme20770=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-78d6eb6956cso11154767b3.3
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765543574; x=1766148374; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nA7IxAffT0jShcW8gwjmTQr11pMi+BjOFiGJxDMKjNo=;
        b=UF3MsyDFSWAOziLO8u7zEMmnTXU52UfHUI9BKP9sLziePj2UxxYgObWOueXqN8W4h7
         ixaUKpVsiHsBc1fRrnUO/crfef07tZKK9nDSJjBU5miqDF7u+jvJuh5s9oAzYEgEFvvQ
         xR5l9O1nRhHEMeyT6JHkXr3Fb+QyjBPHLDTDo+bQBfRJ/L2pALV91NXTy5yB9wq41PlE
         3Kp/ABAIvtRIibjjd84/sSvaBoop4xFAIrqMXmvmvZpk5HUs0+Hhr2EH1VKRXYVZeOWG
         dQ/+/H7amPPM3rAT0zrXjoEEctaBTbBAMI7ivYhwwIn3xz8LQ0IGbWRw7M94czYMTpXC
         EdMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765543574; x=1766148374;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nA7IxAffT0jShcW8gwjmTQr11pMi+BjOFiGJxDMKjNo=;
        b=Qt37itm3cW2unYo3UP4MUNVRi4fNrgbjeYZbwt75hwKZ1RgYdJUrFPZ0h/YqRnldqU
         ScYV6876H9mVqxpiV32DLyayDCAg6NqtH0sZPJajvS3/oLji7MCR0AZ2zC53FGp8EUML
         YjJ8TvOEnLiw0cc76OweFP7T4vPFodyvif6FJGudda+6hgcTmu6XLvUVHu9FHd9oylTR
         AOMrxSb61WcnVO/lfvrWtbZXfbuuJMYVf9F5Oh2m1QTo+BqvNYQ+AB8AKpnBkzMMeL3S
         tHpSXcAvYNXf0RpFXrys2jllGLKLKr510lhwUsxY42Ss+hSXVNz4lNaGKNV2rY4O0H0h
         R9jA==
X-Forwarded-Encrypted: i=1; AJvYcCV8SKexqsmbcHWio3irl8le2I7bCOlGdCdmlBLwCP/MZRS0Xu373YOKSQPoyIZgKoIr+YoiMefTtA==@kvack.org
X-Gm-Message-State: AOJu0YzdMnPsld5dXJa76sFbQhFcMaE0R2/8xpV4lV4ICMBCHWr828+J
	v6yrzvlC0CvzQsubARDtGcN/FvvRlTcxXTgdg0fLOTPRiN/r1R5vyy2aTP5Js5E07MH9u3JYONi
	gYOoM1oYOs/PdCf0Cs35GwlzxQK0m9r0=
X-Gm-Gg: AY/fxX64W4Qx5SVFezP0Su1kPgAbIVY1bOYEbLkIDpxJlqi80/iOnyjTjA4ZW+Vqdxq
	bdf1fxlomEHXIKYtAYk3HYYQsmZcoNZcjg3UivBpA3gvIsFqOctyaLWqIKa5IERnasqZwWJAcDA
	QHUdE7FPnvLuoomuCeghXZGnn3a4MzxTv0omxaN2cNg503ytfb1/Aja3AVo6KS6NmQyovcJ0chK
	P1prUd5kh2hyLQURD3+GcrgQpHWAhZ8NW93zfgkJ1YezycfnokIH/AI9sDrqe1c4LmYykTO
X-Google-Smtp-Source: AGHT+IHz3KgQ+bSNndy9mQEOrCQS3hjN2SHmQrqtmhCRSLsPMmyLQIeagCd7ClGGQ0WC1mwsePEjbW190wH0H0L6KUc=
X-Received: by 2002:a05:690c:4b0e:b0:786:5be2:d467 with SMTP id
 00721157ae682-78e66d45ca3mr15244917b3.3.1765543574467; Fri, 12 Dec 2025
 04:46:14 -0800 (PST)
MIME-Version: 1.0
References: <20251208062943.68824-1-sj@kernel.org> <20251208062943.68824-5-sj@kernel.org>
In-Reply-To: <20251208062943.68824-5-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Fri, 12 Dec 2025 21:46:03 +0900
X-Gm-Features: AQt7F2owg67X9ZNKOIXuzDIfqmLKkjj8_msgVF95SsQ8FgSGWYFqbNql5MoYxeE
Message-ID: <CAHOvCC6B1q+1TLEw5WAQM+E_L2tQQArgq=Hy5JZ35m4_H7s_5Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 04/37] mm/damon/core: implement damon_report_page_fault()
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8A9D580006
X-Stat-Signature: 9ra59kbqg4spds4xqwdnc9fzodetyt1e
X-Rspam-User: 
X-HE-Tag: 1765543575-89324
X-HE-Meta: U2FsdGVkX1/FylYNZGCKnjHomXpQfM1MdciCTnMl7ADaGbcijiMs5Ur+Hq0P2vsk6XIpmTLTTEw/w8ekWUIUtUZwAQJMH3R9DbLjF1SarWOVjCQCBwL30xttZn5E2JrpeKLDsNE1fJrvyoZTInQ+MNnVSm8KybC1zPI2BwTrRVSWd0UCAQVH2wvhxFYM3LhgzfhgBtsNC0/RuittXA7SkA7mCGOmSVH/S3Rf00Epsk9FjQJRe2wjAB7PqycMsDJeEp9bDWlyTk0q+7DTvbBDQaEUYHRKuIqIYvuYnAKvqpZJ4+oMfwFIIhu/mtoiI//YmI4372C2ZDETrm2+e/bPzGBBs/F/sobCvD9mLLNOW99qSJqAlIXCxvjtrHRahb13o42F8NQm7ALh5ZMlhFv0dcbjwnHRKHM9/0y+iso7q0zjE9Vr+NBMQXqX6vyM/3jdw+qONwBX1NvlOhZfNcSzOayawZBmGywqTUTMTKftYbVWMy9pJshDqLpjB96gsmFhTKM9KC3/RFfzazRLJtX/9O36MZiwCN17EEv36ulJUuLmnwkpCLg2uII/29b4PHREGCDwWwI+i0JEozU01R4sSRcljlhFFSpnyJhrOHGETu2jWTatl1NDmH0Axl61RdLsIkwiinZkRiMzwQCKitOFXbaZpxod0snenUyFN2IuChM7DKmL6IDqOG/7SQDBHRNnH2Xa+agQa2stAj2ARYil3TmxK8QRf8Odj3LoH/eq3kUu9hS5FaxjnlLe8kw+OsA4IqMo8yj2GlrFr60zt4hDPZs3vZBaHeTFse9oNLs/9Dnl26BcSosT+RRLO34k/Hgp7MChLGcTJckl5JkUmB6EaYtNpyC9F+t5SpaDDbsbaQm1mjpTFBWGqG2SiFbC4J7nYVjKrUBRoligqdLwwgj/JCsZ+r11AFDHz+HOWhyYPlRaCXBlXCGOFYln6FXDS/KdW2UcMgPBGyy9+54WGxR
 5JU+GCkJ
 AB2IARacFC18MoRPDMbpzvJI2XEIAkA0x0sJTa/heS9k1QE5Ye8mP4verPnF4NyUWW9958EKmb2igxFfMuHM8fmsvATqvmmqi3Wp1RzeRLenEYvHn6DRazk0oKlNOD6DtagaThG473ImsaWI5GOj0zCKl30xkMa+Nsmw4dDdlReHHgYL4zA00L5KJc9q7otyIOB0lwi4NMYfbBzXsW9kthQAtajio7BE8Zhl7GwiXQA/BI2bGo9D9LVyJw20j/pts0VEW4pJzsNgo/g/vbyHa/+rtU5Q0Yjcy4TIMPFoNfquqbP0frcSdqNYv2RQsvIoLlEEYrAUupjLLWiWM1M+NOv00w3A2jxYMsu+R6/A/npzrcMQCvvI1OKWUCofAfCiZFnCUh0IWKZHaqP49EGWS9KbxYpiYg45lhQSWfaf/arHPoojAcuonQs596Z000wovFURfshl9DxpE774=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Dec 2025 at 15:33, SeongJae Park <sj@kernel.org> wrote:
>
> Implement a DAMON core API for reporting page fault events to DAMON.  It
> is a wrapper of damon_report_access().
>
> This is a temporal hack.  In future versions that will have no RFC tag,
> only damon_report_access() may be used.

It's a minor, but git am throws an error when applying the [RFC PATCH v3 04/37]
patch file.  I am testing it by modifying it as follows.
damon_report_access() is
called by damon_report_page_fault(), so they depend on each other.

#ifdef CONFIG_MMU
void damon_report_access(struct damon_access_report *report);
void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd);
#else
static inline void damon_report_access(struct damon_access_report *report)
{
}
static inline void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
{
}
#endif

Thanks,
JaeJoon

>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 10 ++++++++++
>  mm/damon/core.c       | 17 +++++++++++++++++
>  2 files changed, 27 insertions(+)
>
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index b9359c76a6f1..b8ebb2aa02c8 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -1017,6 +1017,13 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
>  int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
>
>  void damon_report_access(struct damon_access_report *report);
> +#ifdef CONFIG_MMU
> +void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd);
> +#else
> +static inline void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
> +{
> +}
> +#endif
>
>  int damon_set_region_biggest_system_ram_default(struct damon_target *t,
>                                 unsigned long *start, unsigned long *end,
> @@ -1027,6 +1034,9 @@ int damon_set_region_biggest_system_ram_default(struct damon_target *t,
>  static inline void damon_report_access(struct damon_access_report *report)
>  {
>  }
> +static inline void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
> +{
> +}
>
>  #endif /* CONFIG_DAMON */
>
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 89305d42e116..296117d5e7f7 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1579,6 +1579,23 @@ void damon_report_access(struct damon_access_report *report)
>         mutex_unlock(&damon_access_reports_lock);
>  }
>
> +#ifdef CONFIG_MMU
> +void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
> +{
> +       struct damon_access_report access_report = {
> +               .size = 1,      /* todo: set appripriately */
> +       };
> +
> +       if (huge_pmd)
> +               access_report.addr = PFN_PHYS(pmd_pfn(vmf->orig_pmd));
> +       else
> +               access_report.addr = PFN_PHYS(pte_pfn(vmf->orig_pte));
> +       /* todo: report vmf->address as virtual address */
> +
> +       damon_report_access(&access_report);
> +}
> +#endif
> +
>  /*
>   * Warn and fix corrupted ->nr_accesses[_bp] for investigations and preventing
>   * the problem being propagated.
> --
> 2.47.3
>

