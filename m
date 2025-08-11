Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 824DECA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 19:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFB018E009D; Mon, 11 Aug 2025 15:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED33C8E0093; Mon, 11 Aug 2025 15:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9378E009D; Mon, 11 Aug 2025 15:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCDF98E0093
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:18:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 822E4B7687
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 19:18:32 +0000 (UTC)
X-FDA: 83765438064.18.7F52F5E
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id C4EFB4000F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 19:18:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MYxsifXJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754939910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+y9z0wbb7UZ5PYTp6B+LzKdJrgF2sCfiImrK7E1sdo=;
	b=WT5hGQI060sCedA++3fleXzp/jLx9kpdsVw00AZ9DsyEGc9yig12W5z6zMfcgWBT19ihv7
	b229XzWWuSpyNeUtRKM8cQvsVbyquLr2qGeIKU4DZ86G3eQ2OMushnEZieQjr21ovK7b0j
	v8V/F/0+94DMcYCAA2NNmpk9ruzudoU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754939910; a=rsa-sha256;
	cv=none;
	b=XmgDGpjAXvqtflTAwPNg7D/hldN4x31SYhPmmx3Cl+5VTgCeGzk3AFWlGC0bNcRumk9oAD
	Wz1og73WbbPjDMGOTRQJ33u/F1d4nxvQkbw78zHuxTT/UTPEgChyxKrzSmy8tIJihoRFXa
	lmF+jtmKd0/mjfpEzLDBbTjFHXdOcNQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MYxsifXJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3214762071bso5761876a91.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754939909; x=1755544709; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C+y9z0wbb7UZ5PYTp6B+LzKdJrgF2sCfiImrK7E1sdo=;
        b=MYxsifXJsy9jxp2Z24jLmwLkt1RqWq9+cBkcfcAo4kSVfaBYbXZEbUIEcMILxnCgfx
         hj33N6QCM+ec8bCnL/kTKvenN/+0lgzoQMi5Lhz3WCAeAUQ0kXk8k/qmRwQtEc8hRgWL
         dr/P6S0A1GLrnAY3NAMDv/wKprqxlAPOEb1kFYK55T6VybDTauLcpuDZXzEGqFQfxfDF
         RaGzYphFzY5qWyB0ZfDxbf5ciYs0VcxA2Jmz7AxOa40hcSUaytBZLwjVXq8wSbYUtXIh
         LMJhNHbTS/50LclRsnWxefz/11SR8BjoaklMwgM122TJUutcCGFsUCJb0XYAo345j7Zy
         zSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754939909; x=1755544709;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C+y9z0wbb7UZ5PYTp6B+LzKdJrgF2sCfiImrK7E1sdo=;
        b=U4kDXUzxQAPkeRfXVABZ8MAlK3hA7BHUluAWNjALshDJEbtEUQ0nbg1oNlKpLDLZbM
         BLfpzGinDZ3nzf11PjtOsQHE2vhFuSc6AsLAx0ZNWE/LpsDx7cbv60bnmm56tNBta1Ir
         MlJruMago26YAHthOSstLeJ2au+WP/IaRBpD/cMVuOlTJKr2/opTr/omMhpU8vXfRVW9
         cLrvlKJ+gSKGwUs3JOsJY0y5qQaDuvv8GuWsQpVDEaDoLJryJeFp/KMqcnOdTJBrXPZs
         NmXJTI3bSPfihy2g/z8IBOUmaWTZAVVJssZmGUjjauBNkIew/H3FBjFLdfHOx8inxtrI
         wAJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjZ1qeiEME+IDiJHSCIW1gEMCDPQ1QSu1GPlA2uZR+92GG0xZEdugTqdx4LuxQ8bosuGfbMZR+6A==@kvack.org
X-Gm-Message-State: AOJu0Yx0PnbXbmgjvqmARxzc/N54g8Aite6SWDbydaKuivznV8KuFD+T
	iwO+PCPsNxaUauqi2ujoDkZAFQ2CWrM10Ec/Zt6oddTt0CIw99YsILGh
X-Gm-Gg: ASbGncvRuRa1fvTl6y1PjL7atwOPjd+MLxKorGKerBaxwBc+LyNhsHfGPQqcJLtG8yw
	qF2q55ddyXol707mDcepJ8x54dDITTzb4zuQoSgN4gCFMmgtgaI1edId8F0df8imPNrLbFHZSfl
	dJrCcFyBsngB9nEonmJnqLOuKvZBTrzOiNsIfGpdVQE9D6P21Ef5Tqm3O0fD6TET9OrQ2X5W0AP
	513qbbBQ/quWD+yupixfGKmFys1zduLk6yk+DCtFg4qi8ALFCxBCXPDm07xKvQjXVDvw4ABGz5o
	9oaT4Wa+deW6qZ18k4yqKit4a9ZeXWom4x7wPcKvjJhkIpjC12EasXp7HJYLAz8nt52xS95ndji
	ECYSQ4oAN+onxYlXDafjKnuseIPgdjQeCT/gOC1I129i113iUF3S7Uw==
X-Google-Smtp-Source: AGHT+IGrT3Iq/yNt1IOa/hXKnvcE2sGXzFXA7QFiniXSckk6w3tjG0VIizmC6LR3GRwM0xAh5JgKJw==
X-Received: by 2002:a17:90b:58cd:b0:312:ea46:3e66 with SMTP id 98e67ed59e1d1-321c0aa6dffmr950367a91.21.1754939909511;
        Mon, 11 Aug 2025 12:18:29 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b422bacbb74sm23639347a12.42.2025.08.11.12.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 12:18:28 -0700 (PDT)
Date: Mon, 11 Aug 2025 12:18:25 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Xichao Zhao <zhao.xichao@vivo.com>
Cc: ryabinin.a.a@gmail.com, akpm@linux-foundation.org, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove unnecessary pointer variables
Message-ID: <aJpCATXWQx1hEyta@fedora>
References: <20250811034257.154862-1-zhao.xichao@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811034257.154862-1-zhao.xichao@vivo.com>
X-Stat-Signature: j5gnf11xiqpz69ej4f563tqae6njqiuw
X-Rspamd-Queue-Id: C4EFB4000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754939910-545923
X-HE-Meta: U2FsdGVkX197aTNgc2DjvpaziHt/iUCCISy5YcBj+vaBVWKgcTIYYvU9g+koB46vVpca8Lik5nvpTpFqB7Y9drN+B3bPo2DBJImHcoutvKUIXFjweszA2KZ9SPjdfziaBi6S+wTn02Y5+vA/pctEPikQuofa03Gj9EA7iE8hEA+rlxcAnHY4RfJtSJ+NkcQJbUOiwBFNn53EZ360Md9AMkxoCbdTztCgQDDj/iVsjWAwnrp6YlRen56FTMMhAiT6evz9TBOUZfI0uU48KNgrNUBodZLrXWEkmlcXenphqjEN18Jt2eaRobRXmv4/y27z/tp9/HC3P7/8qxKA0B4sFYpx/YbTXoF2VbOjKaTkTMxQ6q09JweFTeninIAeQZS4QKjG5GWYcykZ6X2xErKFIC+IJ9NfAAIWRaEEeXIE9jcfZVDH8ViO+su/AyFJoqPXAI/U5nwKeEsh5fKdSf48QmsSvJTswI2NOqRYYcrp2kYKrASY2eYhkZu6qDNSoBG9JUWwG0WetOnvipmD31fdPui7aTfYzmeEunY6kTTVSd9L48mWtyRwVel0ajFb7qLFXsTZux4E33ELsA/TbT9zkz8MWCcq9k7g2wOcFCrRey3Sd6wcUlV9m/0rtacx9zE0VCtpGwVv6NmCxl8kwsXfWX/Lq30vbDfWckdv5t5LkwZuVXnNQQTnZvG4Gda0meurjQbt8FKvw7N6ZzYhhnZdNbGJFEFyRxR8b0rEycQSY8R29+rLWyQewFmKj/PF/gzkhZCnC2pmSaK9dNJm+hQcgiMKz2A4KkcOGo0qfv1sjWraRIILJunZQTVKGBIfjlWrbjiwNm4/wNlPfEzW7GxdFYLB/IEC+riyBrPhC7e8BQAx7dCsV5u+YncFF9d0vS6rH8p1ddx5iqd8/e8Ath4U+JxuglA5fOtK0D9IdESvks/oT6SeRKfwvz9rA2aUyRXIColnumoWzk3GwfCGpsh
 8RLqZbms
 UcpAZT9hvf6hLRy/p5Ve0Y/brOFRZ6Kn5pjfS6UENMZObASIHjfjqKfv3/cYg64PJRkp9/vwliXJ1SPzNUlAbkxuXrwiXckOPulRRqYaKdP9fgdOKMQ/b7C2BN3r6Cjrj1DXCBaGzxOCEIXBSweSboBBb9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 11:42:57AM +0800, Xichao Zhao wrote:
> Simplify the code to enhance readability and maintain a consistent
> coding style.
> 
> Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
> ---
>  mm/kasan/init.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/kasan/init.c b/mm/kasan/init.c
> index ced6b29fcf76..e5810134813c 100644
> --- a/mm/kasan/init.c
> +++ b/mm/kasan/init.c
> @@ -266,11 +266,9 @@ int __ref kasan_populate_early_shadow(const void *shadow_start,
>  		}
>  
>  		if (pgd_none(*pgd)) {
> -			p4d_t *p;
>

Nit - Get rid of the empty line between the if statements.

Aside from that, LGTM.
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

>  			if (slab_is_available()) {
> -				p = p4d_alloc(&init_mm, pgd, addr);
> -				if (!p)
> +				if (!p4d_alloc(&init_mm, pgd, addr))
>  					return -ENOMEM;
>  			} else {
>  				pgd_populate(&init_mm, pgd,
> -- 
> 2.34.1
> 

