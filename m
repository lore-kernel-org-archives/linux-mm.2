Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F574CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 17:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E8528E000B; Mon, 15 Sep 2025 13:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BFE08E0001; Mon, 15 Sep 2025 13:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD508E000B; Mon, 15 Sep 2025 13:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA2A8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:13:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B54B140717
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:13:06 +0000 (UTC)
X-FDA: 83892129972.12.7CFC4A8
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6BBE1120006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:13:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=d+im+2UE;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757956384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+giZVYQQyDq7S6qiTsMees2qm3TEERs/CLhWSYHCPyI=;
	b=Wz8ytapVGLPFQlLLjV+0RE0p9QZWfGDOEUUD0oPHCr8KmbB9UfSmFjvcTpcUjx0mh0cbMX
	suYUfGw1AS3UwFhZP2u8KILXN++HfefG7gaJd6FvSfmLjMXGlAgM9OumAQOnyL/C8sEPs5
	/T0TIInw2RNCbu8Y/I/GitkqmcMeXTg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=d+im+2UE;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757956384; a=rsa-sha256;
	cv=none;
	b=MeRp9lTlqeOL3U3y4zkgLHJfGWB0FG2NaxE323XOagLWSWGzWBMT9vlDoieqvgpRWJ+Hqv
	w7974mXZSbNebUiGCesvmM50zVVeI4uut5mdok4ggqxZMeALBM26v/pXyRvdC5gpPqIMGX
	ppwTFJJgJc4zluQduHQ6IOAbsBy5w3E=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b07c081660aso638105266b.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757956383; x=1758561183; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+giZVYQQyDq7S6qiTsMees2qm3TEERs/CLhWSYHCPyI=;
        b=d+im+2UEkvMV6ahVohe39n4Q7yvSWXpozNTBrKn47OTj4Evc72LgOkv5lIzAU1UaMv
         qnd23C4FsVXPD3ZzIXtSpod4Qip62nVmq/scGEx0cPzyRBK1Qq0Y6Ka1Dm6Tt9KRgGAv
         ZI6JlgRqCAy6PBVgPOMj9PFipnDx/API5Mq3t5xL+gEYlam+znJB4Zl8VskQJuZsD9Du
         3Rc0BR1UdhIed5VQOOjzUXDZTHxKEb0nUW88uaymBM7z3tDNZ2f1mfggLGZ8uRphwf8D
         UKQRiVGzn5N7xNpGu22WTCqk3vM9nBs41+Ex3ZFn5dIizkTCzCM+gkOkaLLKR4TljiqM
         8HFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757956383; x=1758561183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+giZVYQQyDq7S6qiTsMees2qm3TEERs/CLhWSYHCPyI=;
        b=KUkdceArqcW4AchmU1xDkMMl01ar/soyPDFdXxSpwQFki8ZEqV9vSNzYX3NOPXUxGM
         6H0oEqfChmymJ2iSrsVaPCRXcMPtDVOHGemy05YLuthzyg2fjb7k/IcgenpLxqWj6rUo
         /lBpmq/6pQkNSXO/VM0KhxS7RduAT+afoxNkjv5omcP9tYslvTR07XoH2CzzjCTMVnP/
         +eTILkpXwAPmiCiGbeHtSWAFHpn7LbXcI72kH56RflpphkAswYy6ZDDuGT9MjdMz6r8t
         H7WUrAw71luSQ2f71uUrgbkgOFd1cTLADYqGyd1s3Cr0XqxSC4I1ObTghaBoH5qSoVXM
         2YOg==
X-Gm-Message-State: AOJu0YzUEVLQcLONhStLV0/OWE46SeqBKuB9+lNKkgqdMgSLG+F99+VK
	YPf28JOkIBbtfwMLCagrvViDp1OfSQpoI1iX+aTUGihI/W6j+YdBgmmpCwf9Xmbj1V+QMxfaiq1
	3eTki
X-Gm-Gg: ASbGncsYJavrsmkbpxgHrwEkVnYWaF/jGwtD7MahBAa0ZgDitMghJalKxQaF1Pmhzuh
	eiwvh8s6LXLr0jsYIhgYdEcgTgPy+B8Gme3Bfd7D7LuzTDtu4cIDr+9Mf9ZEWAhMD7tr3Nn32OM
	f1ttBqowFOKTUerYrR8xGz3ps17ln7C0d34ab/y0PTZAYtgvOz/tL3fmsdzfreg5JZ8QBJ3Qia3
	2l9z+Qbkbg8FIhZ9HpsI/GBlvD3U8kBvGrsqYsWjmpr8StHyVPqv7FJdKxfUP48IgKYpiP6ZhBl
	3n/I94xhvOdAmXiBWkWMjb1lm5tRdYG4oHQIRGjW2VZM3NC52AMXMWAQcMlKoYcnICtQZ/pqx/0
	pNAt1LUG4CAZaKnU7se58WnQsRk14REWUhhujpPsxljsY
X-Google-Smtp-Source: AGHT+IEkYDkSIxnayNFM/ld2w5lh1jPOqBVqFdxEoRu8e2wrG86GBvZnI15upz7LkdeMAopd5zF0XQ==
X-Received: by 2002:a17:907:7fa3:b0:b04:6a58:560b with SMTP id a640c23a62f3a-b07c37fc95fmr1421811466b.39.1757956382708;
        Mon, 15 Sep 2025 10:13:02 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07b3347a4fsm960439566b.103.2025.09.15.10.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 10:13:02 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:13:01 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 10/10] mm/vmalloc: Update __vmalloc_node_range()
 documentation
Message-ID: <aMhJHUfr_PupSZSW@tiehlicka>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-11-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915134041.151462-11-urezki@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6BBE1120006
X-Stat-Signature: ong7ebo7th8f6mmpextyrb68bp6rs1ib
X-HE-Tag: 1757956384-867293
X-HE-Meta: U2FsdGVkX18hge2fifIAyHjYiRLbRg6S7CsXmgf2G9clRpa4arQMf08SSJHYzH9GMU1BLrIxsx3T2O3S4WGSN1kK/mn5AKal+fB34RNPtDhqFey1knGcKq2i86OwxccuNCOzkXn0EarsFWnQErnwBqMl4kfTlUCif1htbHTwPMJW90YAUCqlam6pV1mkycHqhJ0NxnepFT4hoI3zRUcdyoyO5V5t79M2Eh4lc20KXuvl9B353mbIUlq1447VOVBqArYEr7SzfZAZqbXnhTPi5Gt3/nqTBJ4T6DHHrRmbAxnyHzXIfpWjY359jG1kxjmh7Ics75ORbP4+JKjFDRVw99OWEKGQ2KffsUrN7RHiNRDEm2iSEubbLk1U9VSi/ezqdDOpvi7/dLjayBfB+rnsWx/OHSVdQkQ35fgxf7vBi04s+1ckTx38ZvucUCMfSnlZxxjhxfTEAvwwvVze6MLOuzQ8qjHDkyqV4gg++Mo2xQ788ANbLAzE6s0XkfN7URMQROQRGFWr5aWcFUO+eSndNqHkuxdmMIBLTWXvOotONqpHU6rbW4mfF7CK7WgSIisJhJXQwdM/5oyLlEBE7kHKzJuZvhrgJbCgPBV1m0Y8XB99Abu7WjfFv3fvbAuT5TDdnwd37AtoEfnCP6uv7YoLHhjYtlZVZI0nXS9SlU0X6LRq3Thv1IqCeo+llQkMQfKG1dB9PupPY8Lx7IAJlygf1MEtCTwTKkqQoDCcaW3BZ+RqzHXDruwptsQkiLs2TwVvCo2Gr2aAmrGoE1epa2OlzJz+74ZR6+QnJHwToMEzByj3Ylv31vmGN54YTy6AlUA5Yq6KalhHxYGUc6nDzfzVKQ6oZBSELQFhHlzHQX9dTlSrdL+mYYIFgOK4bEYItPKBxlDE4Ky8ydmqqrWAqOsOYP3SzhMq3BonGzU95mZWSOAVIO++07prJ3RBlxls8wOQETY+ylAvA5uze0/X4e9
 wvN+AmCL
 IDwKVGNszVl84MRz7Cr6aWfFxrpwQGu4uP1SEmxSKB3tny9R+B6LNDScPRFox+G7ywqKsncQmanEtAkB3vGuN+J60BqfwiG728PgF2yCYmoNCuohD/yzFZ436GVUm0IB06sfhnMG22pilrr34UPPLF4ijQ5PC6AAe0ez3hueJtIBM9rWfbd2wa3zKTRJKaSZTLenM+Fh2K9u5wCttsTLOLiP9fKD+NQR8s22MKTgMKr0YlKLPU69t/uK+IqaGB41PdJb11Cx/qhLOkAa4hD+2Q4sgk9zAp1WyScuK6o3JBOKwLTE5XlHhHTkAuVdwi/xQFi+n628hrKsz7QTR/a+3hsQ391ex7HCR/PJG/0ULQewKvh9YRaQZYJ9Ubu3kbhvIAnjglDwhweA4gtzWAl2pqCUUHhAljR49nmKrRJblSJCQ5L4E0cwfaea8yvnsahHi4KTA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 15-09-25 15:40:40, Uladzislau Rezki wrote:
> __vmalloc() function now supports non-blocking flags such as
> GFP_ATOMIC and GFP_NOWAIT. Update the documentation accordingly.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

I would just fold this into the patch which adds the support. We also
need kvmalloc doc update.
Anyway
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/vmalloc.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 2d4e22dd04f7..e56d576b46c8 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3880,19 +3880,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>   * @caller:		  caller's return address
>   *
>   * Allocate enough pages to cover @size from the page level
> - * allocator with @gfp_mask flags. Please note that the full set of gfp
> - * flags are not supported. GFP_KERNEL, GFP_NOFS and GFP_NOIO are all
> - * supported.
> - * Zone modifiers are not supported. From the reclaim modifiers
> - * __GFP_DIRECT_RECLAIM is required (aka GFP_NOWAIT is not supported)
> - * and only __GFP_NOFAIL is supported (i.e. __GFP_NORETRY and
> - * __GFP_RETRY_MAYFAIL are not supported).
> + * allocator with @gfp_mask flags and map them into contiguous
> + * virtual range with protection @prot.
>   *
> - * __GFP_NOWARN can be used to suppress failures messages.
> + * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
> + * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
> + * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
> + * by __vmalloc().
> +
> + * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> + * and %__GFP_RETRY_MAYFAIL are not supported.
>   *
> - * Map them into contiguous kernel virtual space, using a pagetable
> - * protection of @prot.
> + * %__GFP_NOWARN can be used to suppress failure messages.
>   *
> + * Can not be called from interrupt nor NMI contexts.
>   * Return: the address of the area or %NULL on failure
>   */
>  void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
> -- 
> 2.47.3

-- 
Michal Hocko
SUSE Labs

