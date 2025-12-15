Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69294D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 03:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9CE6B0006; Sun, 14 Dec 2025 22:19:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A7B6B0007; Sun, 14 Dec 2025 22:19:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B48616B0008; Sun, 14 Dec 2025 22:19:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A31766B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 22:19:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 541741A0BE2
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:19:28 +0000 (UTC)
X-FDA: 84220250016.03.53A9112
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7861B80008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:19:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bzzl8hME;
	spf=pass (imf02.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765768766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/YXTTPHtIe0UtHqkZ3c7FV17qIWhwk7wq4qflyJ8jKo=;
	b=hVaTeZb6ykUlzYdnsJtkH0f+uoE7VP6tA6jQY9Dm7BvOjjBIxlYhip3roEM/Iqh2BepqHc
	aBNZLGHxjpJYl8HwcYieV7a0FyQroHPNYhei5yy6/z3OJqyZnIiTQUv0/YlThE214Df6so
	a8I8l1h143p/1d5yUsljG1QajtdANqE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bzzl8hME;
	spf=pass (imf02.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765768766; a=rsa-sha256;
	cv=none;
	b=qyZFCBPAzRG3H0Eamo9oOFZ2Qs0/hhod7gKqLmsFyVEX7s7sZKcDe4ST2cOWveO5OCzsDH
	wXc2WhaMFuYNSv/jn98+aiTXw59XRNgso/NeDMt4W1xY/6iZj8JWaQbE4v3azLeSqoCA6m
	3yvrwUPo7z3PRefNXYaVozAeII5ZQlM=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7ba55660769so2202534b3a.1
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 19:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765768765; x=1766373565; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/YXTTPHtIe0UtHqkZ3c7FV17qIWhwk7wq4qflyJ8jKo=;
        b=Bzzl8hMEdmciED/Fd4xkqwzlEVB5FD861uqQ4VZgfOSfquCqw6BPpHR4JIfR7Zz9wy
         6uPzMBA0Dsp2L/cB3RJypzECI/KZdnAfDKMYGovqQZJyn242dDC+gHPEouFfHI1b+qjm
         yeT8x8N8JwO5v7tfhOMkI+389M4XXI0+r6MKPmU9OdWukEsnlApCWM+2HH3lB3uitto/
         t0/md7RBlrdNLH4iRBEezu4JowQC2BKSykCGK52/3kS8pdHpGayjWay0XD5VfZ1rF5nq
         EBrGXskzf00XG9GH/FfeZ5+pK/AKzKDIa4oFEIKdihfqrkua3hBj8UgvVksnOS/T3nRL
         xxKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765768765; x=1766373565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/YXTTPHtIe0UtHqkZ3c7FV17qIWhwk7wq4qflyJ8jKo=;
        b=YNhEoBc8/TtqSofOcBqPNBZaJThWbCFPGeJtCxqOUriQtz1Ey887rNf4o5ZICKuZ8u
         hdCfOZgbwSKGdukncSx8DQ+68YCc6UkQlYcslHYCRchj3VDtZmmX2GW/phqhVs/PmyL5
         H6aOYnQn4y/hzu7VulmFk5j/wHbmB2wsq2MZsqZvI5rttppOmGQfxjpRDdd9vwIoDqff
         0YXsIUSFN9+Yz1RvzE7fV6HyZsWil02C301p1LO6BUBuXR15CRHIzRFB+ZtCN0WVCMYf
         f1/i0/yyLBvHFKy8Z2LWrzL6Zaz+e4Z7oip5oCNZ6ii8iN4mY24lEKSN5Mem+qBPESlc
         Aehg==
X-Forwarded-Encrypted: i=1; AJvYcCU4G0vK0Ks5aP2QiIFQVgLL+BAhSS8o4u1EfZ0bZftoGIjmcjanz1V1+PEAxAri1kWV12vtJyKcSA==@kvack.org
X-Gm-Message-State: AOJu0Yyg4oB1HY6sVHO9jSFx4crC9opI2ykmbsGH0Ksx95uvqFND8NY2
	5QC2k6TCiWbmIdCL1J1OZboO4vKcJ/OkdD+c9vmJytQniNEHSIikq7zI
X-Gm-Gg: AY/fxX7M/VK2zLjiIOGDnIhwzJWflX+LqEUPe7lpDPuNm2m6wZDUsaSD40HOvGISaIo
	uNV6/i9S7+lfpzefMKqRvXrh6LBKaAMzHWLWfQN2w5z9lLsDwnEBYIBHhleoJvz2/98Dm+koJBy
	DOVuqonANRtrugwXf1Ci+yqCIKgA+f9GXE4It3CxTF1BoBpQtczEESWme++At+Zi3+JrKpLhPX6
	ZvBXytTWDgkA7/7efHrD0HxpiONq3qJg+JoxpPqM9va2PbVdFeDok8urB8fB+8fsf6z2CScOqah
	ioTEW22nRDGBPwallhNfyU229MBy1rae8UlQxkn1ze4JP4ThEH5lHQIAGpb6iNqM7yrinyGX+Hk
	g9Byg3q40RvxLw+1eqUJQd1MByZ4azBFxSVDVximGEUF1UATYF3I9sWYbKqbZiSvtI7Do8L5gtz
	e0donGGjPoZtXGCEHHFe+BOvbmM8EnNZr/vQ==
X-Google-Smtp-Source: AGHT+IF8svbEI44pN8qFlzx8WfCvjg1BG57kPDXl85wb4l71KAmRnLomkClsZ8cDHi+uuHFpLooA/g==
X-Received: by 2002:a05:6a00:bc90:b0:7e8:4471:8c4 with SMTP id d2e1a72fcca58-7f6694aee9cmr8109762b3a.37.1765768765280;
        Sun, 14 Dec 2025 19:19:25 -0800 (PST)
Received: from localhost.localdomain ([223.70.159.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c2379972sm11090682b3a.9.2025.12.14.19.19.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 14 Dec 2025 19:19:24 -0800 (PST)
From: wang lian <lianux.mm@gmail.com>
To: richard.weiyang@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v2] mm/huge_memory: use end_folio to terminate anonymous folio remapping
Date: Mon, 15 Dec 2025 11:19:09 +0800
Message-ID: <20251215031909.39615-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251215004836.694-1-richard.weiyang@gmail.com>
References: <20251215004836.694-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 3cpkhsgpch7tjjytnqc3cp9ear67gdss
X-Rspam-User: 
X-Rspamd-Queue-Id: 7861B80008
X-HE-Tag: 1765768766-820443
X-HE-Meta: U2FsdGVkX19PBodxK1C8ldkhMtTSF8H96oXJn3pXKBdOwcCQx/D0Jwpm0pSQWPq3d2ZY78sH3Tm6PNd7Ug8woEiVnMrubVWUusFbyJYB4SWLTwSLAJtxlx+sgBy1/c96g7GaqJTMtl2x8YvYlZy2A6D8sEbV3daIwcqWbf01tPkHGVynGuyuNaqKZiQT9spXbhmLbnaPe1sbESP8dWtgVsxebNHb9eHc+RThfPjWbIQjl/BSdHzE+kqlipaWvktOQnNM+ChWkfZsnUEFZHL6NBeEIlRriPZ839pGik3VJ/AgweIdxvICLxiM3epjn0ba7ZytYRq0cUYiI+5S6asARuzDCq4UhgL7J+WFDduF3Y6h4v/6eTqCqUQj9lWw1jqWY5y3ZNmGGGCuKWR8aplO+b1PwMB4TOuu6KooowTLaZe6puDK19fZfy3fG3OvvJ1JcZSll3N5DaAyi/U3WTmOVCb02oeM/1jMs32GeCTEYqAmxkI2BL8hsSNQLgpflaGNkUXn+oGk8DLi6vPSV2H7VPclEN1SzUUYTgKzQGmq5/v/IZ0aO1lkdgEQ257Pj+VLFBEx4ovvswPjxpsmEcqya1ADOEk0861g9YMkyVva4L3fvYQLZ5Q85byzS/oiUO7gd+J96uxjDCQr4bC/+kC0gLndER3N6ZaBKLQHBwIEkCUcqbx/MDNdmyg5/RwAWaRj64BU7PVCwwuPp7xw58LjYezdihwDbjiqpSXxkrusUzT+91ofXPPrNrPhioP9rl5xwuVk8FsBxyahMbk6v0UCF42CVpiVVbOwd1r88j6DKLllxoarnPvfUVk9dPWeqVwLtysSt2eFakcwmhCLAsObYVVPSVaHXSAIhg6M+Oc8xmLaVdAvEOKvQJnIXnI4dsTEAMHjpK5hf0grHh+JHnOETv9zrTXeD4mWsr5SQRMWHYFk69vsurEtXYkxF4sxb1UMYgX3G8VHpduEjEB9cRa
 8B38rpMm
 reSeSzQhabV3obeb0S0FZqneIo80rku9stI/07yhXFaNj17kcphNBcVnpWhUBieLgt07ge817gVDFjItl9fRJSQ9OBywD/keCNuxAv38Ibrjyi6Scey0CZR6boBlQzUPGypYd0ohUxMR1oP8QWd0ZQuI/tVl5XNu+MSkKfhgcXQxR2r3ISmuLMRqsw7poTNWwHlPEzfjUDZXtxfdbv0hya/7RJn+gZY7hXwlnUawWqhZTco3CQMMiHKkWoWt96deFnJ+5B6654W0dNn3OdmlFxyxnTxblZGJDKonZtWPZmma2ek27WmK4YoNhugwJFId6bKeQZHwXVYroDd1LaJDSZLdqrRcVKw+ZGnzEqEIqvHgMBtpMg8wV7p0ur4i+vkWUJWFyqXgcbxbHIXgrMKRjVtNzkWZ4GVZvoKwOlY8Eh5DTBbcwP29tTexx9ds0TE/JQT0dubdn8UrQykjAf7gdTwSHSU9DPC6Vyresl7JHpj0iAhF0ioVidiNmYUz50/ZpaNqnDJJEKcxqWx4/kjWyicu6tOWZmOdVPHy5FcdGPZhr5wQ0wLnD6JPPVrw/hyXeh6h7Tu7WCnq3csi0n8abMZQGXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> After splitting a large folio, it is necessary to remap the resulting
> anonymous folios.
>
> The current implementation determines the end of the remapping process
> by counting the number of pages that have been processed.
>
> Since the final folio in the sequence, end_folio, is already known and
> tracked, this commit refactors the remapping loop to leverage end_folio
> as the termination marker.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
>
> ---
> v2: move folio assignment in loop
> ---
>  mm/huge_memory.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 40cf59301c21..fe812d9c7807 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3423,20 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>         return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>  }
>
> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
> +static void remap_page(struct folio *folio, struct folio *end_folio, int flags)
>  {

Reviewed v1. The end_folio logic in __folio_split is clear,
but I agree with Barry that nr_pages is sufficiently intuitive. :-)

--
Best Regards,
wang lian

