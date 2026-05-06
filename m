Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CEFDCD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 18:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492F16B0088; Wed,  6 May 2026 14:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443576B008A; Wed,  6 May 2026 14:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332856B008C; Wed,  6 May 2026 14:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 217756B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:47:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4A7D1402B5
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:47:29 +0000 (UTC)
X-FDA: 84737878218.03.2096D5F
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id C729540009
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:47:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EroS+00v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778093247; a=rsa-sha256;
	cv=none;
	b=kmfDFpzxJTSatSpbhj0NB3RnBWS7/6E7kBqsqLX34cW6LT77AkY0HVK2VFUe//1zv2Zgo5
	H4dbVCE+YtonUZ1UcoahDsfTI7hqBab01xeq9YnBO8nDIh7TqV4u2nCHXKEROPAg/qjXjy
	8GMFuvJWj8TeGgVK4EqlP6K5hCcNs08=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EroS+00v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778093247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iffeP1fxOOkYpaGIpDPtCsG757023DZRgT4MFhCh+5k=;
	b=AI3b5vo7eelbb87TOZZzTd+nUX2Ow5JG6dQPLaVtu+N0/H4W1KtnK3qPDX3ebvzjfmZf6H
	darx8XkdChDi6jraDS7VytEzyKO+353phptjUMg+onN1siAhqRHkdwz9lp25u9YJg/3d20
	OvP0Ck7iL8VEcohEAVvalOmCYD63vbk=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a860667fabso5598985e87.0
        for <linux-mm@kvack.org>; Wed, 06 May 2026 11:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778093246; x=1778698046; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iffeP1fxOOkYpaGIpDPtCsG757023DZRgT4MFhCh+5k=;
        b=EroS+00vBkBtGELvuJT/RjvVj2HejHfXG8VwVldQv/KwZ+qqNs1CgDnAHJ7W0g2vcO
         NqkZjrHm8SYqkoJvAL+K3/5J1YzRhLX1j2zqN3brEzUdbh6iH9XTrC98hi8HWSBGhdI+
         wl7vMqMU+YlxFCOVKxInAI/oHKrZNkN9RAQ+L6YYoKhvPZLKquE674/HkHDX3OPYl3Tj
         De5FEASs6dMp31QQr4PMmJrjkV+SFwDJ8MTiyjjetSnyxvLZnHfZSdZr4O30/jj1Zs49
         BiCgOFapuh4958rLMuzZrxHfDzeVA3SjSypAoFB8GrErn9et5HH6VwLTB05ABHP8DC9s
         qROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778093246; x=1778698046;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iffeP1fxOOkYpaGIpDPtCsG757023DZRgT4MFhCh+5k=;
        b=QJGBl0g0V6sZRW0v9bIXazV/PvUWi2IlI51gbGt2QPEnRskDpvMP+3yy56rCBy4KTc
         R0jSKosAZWlbxIcD5V0pviIT2x3k167L1pjsns2IujbPJmzHNpRHY0Tu4RxRLJZLJPpd
         Lu7ynOz0oUDqGhqNY9JB46J0KK8l8sOMp9ZScA30C3iq3vu9hc0AMs7tRkVA1mRLdyfk
         44wdBv0yOKcLK/YSYGio954SnNFUW8OVKUoUDCLKbOlUHzURl3efp4EAAmc/T0mHit5v
         J8jE2CuuDhjgBHu0WGOTKXLfpxL0KpXOQOW7btjRotfNMtIEhKeBee2i2eWjLCxN3smw
         UFuQ==
X-Forwarded-Encrypted: i=1; AFNElJ8NT29CDLpnVb1GUF9+uh/57OdxOTyRNA0FW08fXOeQJFJ8heAYD+NAIUjx9dpCSWrKZK//AZb9Ow==@kvack.org
X-Gm-Message-State: AOJu0YxLUvFpzUVgHw+rBfO8/m+pOthvBMYkbGA3Y2bV4zQ3mvxr+465
	PTs/uLxgkq0SvcFGth0GJ+hjGM34GQ10XP8bCak4GXF5ctelK842HBj5
X-Gm-Gg: AeBDiesXF+VG7GUocHZ4e8Z00OUZV8QlQAlaxOSZjTefj2ObuAZ+0dTyI3wNsbRJl/c
	XYiqoO8vgQeE1GqLtY4Y1inXhyE3Uy1nbXaTpHG3kftQdGpbCKGrjiDrUUax7Y2WQ02tgO+Qs6n
	Ef0e41kw+OHmPX+rDJfG5XaYAcf0pj/bLBtncj1U1LYiZbHHk+s/IK7UoZQtRI/MG9NaV/s4Ge+
	pzCn7Jn/dn97sHh41Q6Iw7gbIVVlqURFN0g34RqpjMW3EZVn/dRNTKwoFOhyldG7DQgnsBPKDyG
	gf4616ykqd/ulVvaQktk0/y2NVwxed4UOXunL2MDflxClp1LUcpGbtXnMjMmzOiAWjgrxFAtcRI
	RiHROdO9ORHmWHe/dfNsSjCocr10gP5nm6GnA9npGJLK1TRIe6EvgsPmWXDlsu0w3wGNRSASJZi
	vjhFee0NO46oQq89VfzTIDvNHnCDuulQ==
X-Received: by 2002:ac2:53a4:0:b0:5a8:896c:8989 with SMTP id 2adb3069b0e04-5a8896c8bffmr1165595e87.30.1778093245844;
        Wed, 06 May 2026 11:47:25 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500:de96:9acf:5dca:ede4])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a865c8bed6sm4299484e87.31.2026.05.06.11.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 11:47:25 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 6 May 2026 20:47:24 +0200
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v12 2/5] mm/vmalloc: use physical page count for
 vrealloc() grow-in-place check
Message-ID: <afuMvOTfj977Bex5@pc636>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
 <20260428-vmalloc-shrink-v12-2-3c18c9172eb1@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428-vmalloc-shrink-v12-2-3c18c9172eb1@zohomail.in>
X-Stat-Signature: eng4um4hr9ffntgm7edqswstmk6awmur
X-Rspam-User: 
X-Rspamd-Queue-Id: C729540009
X-Rspamd-Server: rspam07
X-HE-Tag: 1778093247-41127
X-HE-Meta: U2FsdGVkX1/Mr+zxmjkNmwOMlFj5Jm9UIBoCECpRhqLPtTlBefnEmTI1lh/Ji7tz0ZotN5m2EG86SXC2kLXR7otuGApuG21qsq5u8k0lgjMGQfEwLDG9G51keB3OujQnuf2xI2yl/WKTHjE8hUF4BxUY0htGbCYTxTW1FDimMxsRX25+6voTaR/IDfAx328IEv5SfSHkg/xyYULYH+ZuSN0AX4HEurMOI90odK+FDRSpFOXdwX+1BA9g+VkUoL4BbDXmVo8YKPLN7xP4+DtoYwS11nlJzkdRwZZeKFQcgaYZ7kWbsQhOCfWPeJV7Gv4Y6jwoBdYfhzT6NKdWgV9wXjNIVntiKSSPMhJcfjOnxrdmQgc2QQEn4GQA9w5vm/xPT2Sl9WjL64GFKxckd2GL82EVwwX8IV9o1eOLajqiEpWp03Gb8UjUNY6L1+wW5EHhX3eXYUSj4wKxkxldAN8rwRjj81zVhY4Y57uhzJImV9opLPLjM3eH1SgSlKELW6VWrrn2nMd4bVgXDDDjKaV+p+MRUw81nACSrTv/KS5f5mK8T6xvqvRupskgdpiWG6hbnnYnpuzLTg8LaQtwgMMxanOk9XSiBpG/ZOn43GWtCKC0dYbSKHqQOPWz1tYUzYm690dOmGlWjT+KIX4YIzcctGOZ0RhjLoXMWLCdkbNe86D9ZYP1oXD4hv46zV4YyDaDRJI4o3ghqS3CiNJJihehZtJQJeT2iIN0+CAcp55eP3Bcq9qqVPxr5D7GrWtsk8nMZFNHFKMI7ObnEseHnLMLwGpquYsEzOSUEkWBXjTO/3tR45Zi/DCSS/7PdwZlFavFa3SB2bDPCEByqj58jaGZIof8LYh02fWzmlRrsQNR91P0+9deK8q/0T9mm3zosQFtpBBzkR5VZo9YVvyJasBDvzxnnTITr/tsfCiv8faL9cCdWxmRUdbgoyRX1P+Uh5JI4O8hgUO8JCD8Mlpjr9C
 7esoJMOE
 kLHfgvo9tjkgxEinrGinikQgyLfjt8GetIbqSLe0/Qb0UwfB8FvZru/h6JKwW9LwvXEoCk7i6Z6bZVP87EcW9keLJSVgF74TUpyrBxRxh2cWeKAMTYNIoqquTY0UFCd7buMUFjXjLQSGnsSFGlZJajoEroYDuajeKT7qnJFZ+haeBQDAlc/QzozxfoGxM1qa1CRs+psTwn1PCnBZJBip4yzmzhRHvdbFG98b0fRLqHjNQleCU9YLBJSmlD/iYxu9IKFmf2Vq+w22YtPm4MbndCHS9fex1bYC09nkmr3J1rl/c8y+0Sh/8cmQVkJh3VACNv/zguuXsE/zYZ5kS9+8b09EdrP5My4g7S8NZeabzSNPwglOtXv0m0Vriv4nozR478Ve35nhLvuPNNKcvPuLT+aMlSQC/QIGF8xHo9xmBE6o90fUoPV8Fii5gFpZEh+txPsyhhgxZWmUfI/17ivVzyhtEKdMM0auaGB0KsN8k5IQMTwo5lfnDoFFzUFqrkqCy4rIwcyViUSfyVR5ne4iY6UBBHTXm6B48kKT1aPMEL1P0fOzSBUKXdho4Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 01:54:17AM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> Update the grow-in-place check in vrealloc() to compare the requested size
> against the actual physical page count (vm->nr_pages) rather than the
> virtual area size (alloced_size, derived from get_vm_area_size()).
> 
> Currently both values are equivalent, but the upcoming vrealloc() shrink
> functionality will free pages without reducing the virtual reservation
> size. After such a shrink, the old alloced_size-based comparison would
> incorrectly allow a grow-in-place operation to succeed and attempt to
> access freed pages. Switch to vm->nr_pages now so the check remains
> correct once shrink support is added.
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 1073abb6094e..9cb3e287a1e8 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4338,6 +4338,12 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  		if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
>  			     nid != page_to_nid(vmalloc_to_page(p)))
>  			goto need_realloc;
> +	} else {
> +		/*
> +		 * If p is NULL, vrealloc behaves exactly like vmalloc.
> +		 * Skip the shrink and in-place grow paths.
> +		 */
> +		goto need_realloc;
>  	}
>  
>  	/*
> @@ -4356,7 +4362,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  	/*
>  	 * We already have the bytes available in the allocation; use them.
>  	 */
> -	if (size <= alloced_size) {
> +	if (size <= vm->nr_pages << PAGE_SHIFT) {
>  		/*
>
Maybe we should consider Fujunjie approach and borrow his idea to shrink VA also?
In that case, we do not need to switch to vm->nr_pages? And we do not
need 

[PATCH v12 3/5] mm/vmalloc: use physical page count in vread_iter()

?

--
Uladzislau Rezki

