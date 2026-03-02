Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3869EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A4B6B0005; Mon,  2 Mar 2026 14:48:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027D96B0088; Mon,  2 Mar 2026 14:48:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68EF6B0089; Mon,  2 Mar 2026 14:48:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D65CF6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:48:41 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AEB481B7219
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:48:41 +0000 (UTC)
X-FDA: 84502160442.03.D4135FF
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id BBC28100004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:48:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="gxeJppu/";
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772480919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Puy9yrqJbk0e9aaEAb6IkFimwFJOtZJS6lRexavpIMI=;
	b=8PWBHx5BM4c/g3g24pTbkg1dMTuup6Of4CzzrOwJMTa5ATMv4CodN3G3B/IRCtdEI8P3L1
	prWQ8G7rourRlpXFhaCPfmCm3J6uHYYL9YIDVseBJdO4Z0Z6eTVmXGRlYVuLiFBtLsPuTG
	+yunlznkjwLAPauZPL4E/OCzb00pLDI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="gxeJppu/";
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772480919; a=rsa-sha256;
	cv=none;
	b=YGu9QtCg9Lv4HMoN6/g0xN8FIaRKFyRp8M+THRhQU7/Ag016i7C5hVOKPYjQffS5OgOzOO
	yk4brWknBkizEn9I9mqyccwCv62XG1bTj2fhJRX/Y7vm59BEYiLkqdTHuvqiCRxXi912YK
	yG69zZfw30MJNwiLWO3vO2kJVh9C+mw=
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4645dde00a7so6139147b6e.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772480918; x=1773085718; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Puy9yrqJbk0e9aaEAb6IkFimwFJOtZJS6lRexavpIMI=;
        b=gxeJppu/68tgQio8uKEl76MiiKT5kdhtXl6b5LvZFdPa28EM5Cxepo18k7Ye+dG8zD
         DJB2tUP7U/4YMoXLqpSbybalrUq4r7j3FiFhoOO9Oo7QglAvaGCQOD3deRb61Ntb3NJv
         y97x7uq5a7yhbf4VGgqtrEMhxVeGuibUeAQUBFa8tSIe/QGKW84LjhXmES4AKisjsotd
         kzmU8diyjRk2an13TuUhkuNVFCC8rDeWzW1Ek0Po6Hh85uM/Mbv086l9cCF5/7RjjFre
         bU2baaAT7ezRHBA4vv4VkxYJ/bnD9dScCXnQMJarkmWg49TGu/LfxrPsFk8uvRJItP6c
         lZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772480918; x=1773085718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Puy9yrqJbk0e9aaEAb6IkFimwFJOtZJS6lRexavpIMI=;
        b=mZUroWKDaRnrFpceK9ihZpcmcaqxM0TXJhtH7YQTyXj7cOSJVuQNWvhZfCYfQhU8CX
         EURL1ypocIk268WoLNT8+gqjlHOmPxgEj5nqLozpTiKdSHzr1ye76SGmbrQDhXJS/W56
         MoFONQiq3mI90Q8p8kCLCOZs91mIyoAgKDpjm6OrWrNoSX0YGjpRI8GjFACRpp+UT7Zz
         cP0xQ219CiVqaqlkjAvttl6VLcx0GGIFZCVoWTo4JJzwtiH61pfZd08BV140pmTWiJkd
         vGdRLKnvAAKfhREG1ozKMIzAXQGIYNF6SQ2/a4/Rvica1weOYUNiv3orbZLYArtq4/nd
         SP4g==
X-Forwarded-Encrypted: i=1; AJvYcCW6QRgCWMFnFjmlc5jmoQT7xaAs2vKoXQ/JuDZbMqBN6W2AyreZJQZfwSGK/wmnfPgd9d38tsQwjw==@kvack.org
X-Gm-Message-State: AOJu0YzpU3h6qQrlb5deNEYGgWtZCDFZcXcy6xRP8EhripkPfWIh8RBE
	2g6iuMFIXh3YBXkjBk43FInHNMcw8vjjc5+5FlLk/BCCHSHcEZHHVoAf
X-Gm-Gg: ATEYQzzZh7VyJLx/D0omdXkCUzrVmgJNqIzM/l4y9MOLDSFfAy7/cBPJcIgt3lsbwlo
	FMdv/2fmA21Wtyu04giBxKE2/6EGnQyQyxujpAt+I3mDIVbunDgb5oFytDQJ7lFvLepaPFneJpq
	QopLF18kzptsUdXDo8k01l4heEuVmqTIpGJDbKNMawO6PDGeZbWxdrm8Wm+vBcfbUtGDbuwBVl0
	xItWDv6PAlMVC8PN5UJxWLU+MBcP6DIAKY552rNA9TMh0xFBgrSPNJ3A69fXBtoHqp+3PZaw4fr
	1SlgE9FHjSX6t93qxKQq+dnSgrt4LIHxHzrAQ3TWtjL1dRt+HXetHvXuPbk7bKd4HzEVzQSJKaU
	416v7f7rWcMfQ68Zs5+gXTwK0WYe2NNFOioO6Rl5cyL92I5OaJxPXyLf7UHp9CdRocY0CZHGPsH
	kI6809LCKDJM9QqzRqKZN+FQ==
X-Received: by 2002:a05:6808:6601:b0:450:b87b:1ec4 with SMTP id 5614622812f47-464bef0f899mr7178418b6e.15.1772480918630;
        Mon, 02 Mar 2026 11:48:38 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb5da37csm8384121b6e.17.2026.03.02.11.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 11:48:38 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Alexey Suchkov <aleks.koyf@gmail.com>
Cc: akpm@linux-foundation.org,
	dywoq.contact@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] [PATCH v2] mm: initialize 'seq' in gup_fast to remove -Wmaybe-uninitialized warning
Date: Mon,  2 Mar 2026 11:48:35 -0800
Message-ID: <20260302194836.2932150-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260302193405.37961-1-dywoq.contact@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BBC28100004
X-Rspamd-Server: rspam08
X-Stat-Signature: 5myxmw1fdaenoq6n6oqb8nnmw1jgb8eb
X-HE-Tag: 1772480919-302235
X-HE-Meta: U2FsdGVkX1+JxHlbZD46QFMUjhOZkNe08U/dsxHs9zO9uj5ZY4lsHQiRAx7cmYy0mzjZ1hF4+5aCerHamzwppY6CVHAJ8BnEN/vl/hjv4f7sazMJMCu421qqtrqa02SuZqooh3MRH2bGndWqfMq4L1WhHsYGGtXZDdIAfMp9rGKWQr/yjoN6akQivXMZEyEWROFtWtvKXI8+dT9U1SXYj94LWoeAZx1+qyf9TKtjTNdLazs1VUJZELHar8G6VfrL2P07cPulNjIQSIbCThZ+8LTFrkHl7CQCKxOxnKW78NOubELw+uAatkMO9y4jSTPB9/cIwAtJbTtzwuWgze9DI3lGyS/3qms2ye9c5jo3ip7dgFyMi08Rae0kcnlb6sCYTourG/ghccRzhoGcdSZGNMcxD8V8Vnzgv+AGqs1eoevUUvKpajQNq14vl/Wth+EIrj7X/KFl5Npmgb8efbjUpfFlU6s3QyH30Bd+S6nYH5FERL4/AcpyZiavouqkCl7nlZn7PqnArChBfyRF7rylEVgaQTnBsHv5uUgkF9EbRkyg3Z1xQKXRQPHd46wPD1E8ojdbT0ztoCz//y+5nYaa/Ga8HDBl426xbWnVQ90iYtr4YCX2/FUkDs6eZ/MnbEqLaOprIGVZUFx2MtZ+Z96O0/uXKgiwC+3VbOdgkL5wYmLI9AoXCFuiBa6r2btwmWpBLQGOkVuBJTh0IGCTavSOOiVGGgXcCPDciEBTl41J5KhrZxeXCgVVUyq8qnkr1XKgafAFXnak7X2aaGCKkwFQ/jdHJ6ubQbqNF9tW1uR2Q/0trtHUst08R94YiiCSA9cz/v+VOGlZD8FXV64jThRNBm43TZOXEfQVNdFisAlVE4dXzy0DbjqBp1sxijQF3iMe0obyIJYgRImgo9tHF33mZVccA+PPMXmf5DlQ5aZhyfIEIxkNqKI61O5fWUx1yD+Zk3Bi99SyYzrBspn+jdQ
 /3mrzJPJ
 ULaskrZZz0U2JybL6AtbHRbGkAtsqxUQ2b0IU5gspjZ/4Z34VdJg2IqnNicx7M5yMMoHlVG7lk2ML3BxuN0U5iJdMoEe+KbyLDMl5X1pQU6WTawHJ0bjJChhrRvq2rXqIcarURNsojwUnekXyRotwd+nHG+RkGmtKGj0XM6GvVjh9/cegDZV1UeKL7h/R2wpHM4TnjRwxjUddheaUjqTje0ZLeIuxdptucCWMgci58/sn3N8DIco5wR0fm7EQb/0o4rjipLHL5qmMXaW1KnKSbUrJLd4IqxKrcIFJjynkGx+SowMldUPWmupj8MCSKzdw2szuQOKMmkW5e57FonlA0ilHGGtzT5VPmf4VQ/wcbqkYyoqzh0xE8838kO0uxavaNfs4NTORZXlEIxCxD2jVBZDRvDIo7F1YDIMQHJd4nwG37JMR7qhNqPhHvaWVdF3X86ERjeGRgoEsf4r+lWqla/rvUDnP7//m2l62vJe0JyBUWh2fuC1ZhMmhWR/Zjezx2RYzbZJjR1YhERkGbzRW0xGurtTRML7t4Q92N1cXFFBxec3EjLggM+XGK2ktbR3W8ulL37zWzYTvqxvE5IbsGfl4R/rvUxJpFeSSPkP7JP9kP2GYo6XsgOHvRtpLro9Z7PdncDEHoipPvr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  2 Mar 2026 22:34:05 +0300 Alexey Suchkov <aleks.koyf@gmail.com> wrote:

> The local variable 'seq' in gup_fast (mm/gup.c) was declared
> without initialization, which can trigger:
> 
> mm/gup.c:3165:20: warning: ‘seq’ may be used uninitialized [-Wmaybe-uninitialized]
> 
> Initialize 'seq' to 0. This does not change behavior, since
> read_seqcount_retry() always writes to it before use.

Hi Alexey, I hope you're doing well!

Unfortunately I think that this patch is still unneeded. The variable seq is
used in two places, raw_seqcount_try_begin and read_seqcount_retry, and nowhere
else in the function. Both are guarded by if (gup_flags & FOLL_PIN).

raw_seqcount_try_begin is a macro that sets the value of seq.
read_seqcount_retry is a macro that indeed reads the value of seq, but at
that point seq has already been initialized by raw_seqcount_try_begin.

So I am having a hard time seeing where it would ever be used in an
uninitialized context. The compiler should be smart enough to expand the
macro, see that the writer and consumer are under the same if conditions,
and realize that it is always initialized before being used.

I'm curious to know if the compilation warning above is theoretical, or
if you've actually it it during compilation.

Let me know what you think. Have a great day!
Joshua

> Changes since v1:
> - Removes the accidental formatting from v1.
> 
> Signed-off-by: Alexey Suchkov <dywoq.contact@gmail.com>
> ---
>  mm/gup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 8e7dc2c6e..879798de5 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -3131,7 +3131,7 @@ static unsigned long gup_fast(unsigned long start, unsigned long end,
>  {
>  	unsigned long flags;
>  	int nr_pinned = 0;
> -	unsigned seq;
> +	unsigned int seq = 0;
>  
>  	if (!IS_ENABLED(CONFIG_HAVE_GUP_FAST) ||
>  	    !gup_fast_permitted(start, end))
> -- 
> 2.53.0

