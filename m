Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC07ECCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35AAE8E0079; Wed, 29 Oct 2025 10:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A968E0045; Wed, 29 Oct 2025 10:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3178E0079; Wed, 29 Oct 2025 10:46:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07B648E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:46:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1197BAB7F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:46:45 +0000 (UTC)
X-FDA: 84051428370.29.6B55DD7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 15FCF40009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:46:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jLqHMZzF;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761749203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0UMaue7ZWsmO4c8GIY3dOOqsOMrx53MQtm1wLx6Olz8=;
	b=5D9FS2YKpQpo9aPGHplk5EPt5cAzaI5lX7ReUlitpY2W9TQB7Y/WPjOrVYAnGZFIlMFmFc
	37az3qcrYcah0kJNVXMd+LE+hY6ipvZV+TXh4iAfykQ28vY10P+htPBBrcaZYDOCOdzoud
	FRoA3pp2CRNtxA1OIY8LoSSvnzNrKxY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jLqHMZzF;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761749203; a=rsa-sha256;
	cv=none;
	b=mJbNyLH3AzHZei8qpOuD5EemFVG3/Occs8p7RK4po3x002r+umRrByA3R+tA7V/zdQX+OZ
	FiQDhO6LrJ48zegXMa4zBeobPCOaE1rXKrjTV5R0ks0FYl4aqhXre/oh3+8wuAkCyRidDl
	iV6oiwhprgWmDvdjMMIspgiaFLpMTH0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761749202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0UMaue7ZWsmO4c8GIY3dOOqsOMrx53MQtm1wLx6Olz8=;
	b=jLqHMZzFb8LY8/7u6onRDHH2auErq71fe4hYAg3smAT2NRmUKLKchj0mhJm9t5qy0UkpCQ
	iZ1lnQgibuXqenJ+zlnUL1qwHESzqXPGmI1VMi/lscjvkq/m8HhtZapH2pHWHmA9jkNDD7
	ZxdPD2Y+ZQUqwHz17V4I0+yR+b2hkw8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-aM5kSBU9PtG5vJoPZu-R8A-1; Wed, 29 Oct 2025 10:46:39 -0400
X-MC-Unique: aM5kSBU9PtG5vJoPZu-R8A-1
X-Mimecast-MFC-AGG-ID: aM5kSBU9PtG5vJoPZu-R8A_1761749198
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-471001b980eso47069085e9.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761749198; x=1762353998;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0UMaue7ZWsmO4c8GIY3dOOqsOMrx53MQtm1wLx6Olz8=;
        b=NQP41WmIndH9XCPSwsvJF3qb/Cyv+JHyM7ys0pXZeAlwdBAokR48lBhSMexPZE97FJ
         UJu0czBqH92uTfDs+QFZJumebr0hbin9srg8h4QMXKXtaXT2L3gHTG7kmeNdIfGQ+1aU
         l1jz0Lax6UaXDlW2C0PWNghcNnGBq/zz4bOZba6z9Z5De95KOchZqcDTVToSo7R1BFyv
         g295i9Lce7Y24+KFQevgaESMFzjL8XqnfkeTlielFRl+VGsPQUmbOufVmB+4fJAyi+59
         qPDgo/MJfmRTo9WrPACCjMJ5aabnPHMtuTvG0uJpiHx5zRFt3v0E6YRdia9G32Xedz88
         VFcg==
X-Forwarded-Encrypted: i=1; AJvYcCUFW87GnfqHBmlf0Pn307ChqoJ1p3XoAT1ynSQu2zNwBr0sKRTeAnimAy4kAVsihZACJo2ePAP+sQ==@kvack.org
X-Gm-Message-State: AOJu0YzC/v3WxAt3sMqaw2c3TiCwpK6Yigg4/PhXawfUPQxQFlUo07Lb
	QKQd2aXQqqiW/27ffkKrFft1se9x7vi5sQPDfVy7unfhq2Ty/ndKiD87f5ni7gnoyS3GezP2XaP
	xXvrcoruOcLYY+K7CZie7rCASHDNsrD8F93eL63s3HyW7fGe5JoWg
X-Gm-Gg: ASbGncvUIiRTkRknFrKEUuFcmeHhbvWzUZVTjHmN1LFpTc1ZgN8W0fj4XJL9DSx6hNv
	pOyIdUjSgDHQAS1omdCjywPvNlOc21lir+Z5Pz1Vlexb0l3Jl7R0je6I4IMC5t+Wdflp80k6eW9
	vIlu+dRSfA2NHU4nQwu0aPxqP5vlC0W7v82G8f9gMFmgfRGbsDsty7/riojNTORWHQWoxplBxd1
	cxFMVXIKj8B7SyMIixO45HE7XWUY6j4ygaXjqh/2B+Vc4L71mFhIY8pezFBYrk7GW0Wam2g8L1x
	zkTk3RLUjwtLugCEO50ZObwB+/g6vTCGJpRH0Thb00xp9XaUeClGle/EjHdX16ZrrsIr1afRg3j
	gEdhF+xTw6MmfQ5cf2xMofg==
X-Received: by 2002:a05:600c:310f:b0:475:daba:d03c with SMTP id 5b1f17b1804b1-4771e3339c3mr25597105e9.13.1761749197885;
        Wed, 29 Oct 2025 07:46:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHC/uqBFlcpoKMKVxXecJEcdSWvlKWsvzAMYUZrCn2DWBPHz0hPHUqc+lQGAFumQQDc8STQhQ==
X-Received: by 2002:a05:600c:310f:b0:475:daba:d03c with SMTP id 5b1f17b1804b1-4771e3339c3mr25596875e9.13.1761749197361;
        Wed, 29 Oct 2025 07:46:37 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771e12cb2asm52407195e9.0.2025.10.29.07.46.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 07:46:36 -0700 (PDT)
Message-ID: <bf832253-0052-4ab2-b664-33bec3837c23@redhat.com>
Date: Wed, 29 Oct 2025 15:46:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] ksm: replace function unmerge_ksm_pages with
 break_ksm
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251028131945.26445-1-pedrodemargomes@gmail.com>
 <20251028131945.26445-4-pedrodemargomes@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251028131945.26445-4-pedrodemargomes@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -wLPX9HLfUwKAd_cDdZ6yNgfJtIpKZ79zxUhPkyhIkc_1761749198
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wsamppyshamyyao89kthqfrnme7hh8iu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 15FCF40009
X-HE-Tag: 1761749202-909655
X-HE-Meta: U2FsdGVkX19KhJBilpqs/zsAINqsfikBE2Q0wbR7ruqXzmF3g4dKMg7/n1SQjfzIb2cggs4QPEQ9anRwa3e83KpvJ1+QfyB5ayhfpNzIlMaOx+T/Biujz2pV/wFW+aTRJytCpmB/6xcKWglO9rjN7NcxMNSA1QHU6StfsSkcZiGmWjkLT0/LxLsGGhEJSj8WauHnLgksLctotMURZXCy+t8Hzg4uevAqYhRw8oDsQAJYWAXRto1es3T3uPkAXanUoSPyaKXpfEOV9bWapCiHiubRDAjkgmdHInjy+NdI1WgkUtjUoxMqP/U5lWQ7HtJBifdCz9hadVW34H4ZmxJX9LSHAo8EsTrNLpivDVzblHzd76SA2A6JHItGmMe5IF7pEBb5+QF5J3vTU7Ph+IablFpAOqmyjlc0kX8BkhwJlh5iLr6QUJ5RFhUPOPGDsVRR5xOEE4HiJuHdlKIyFdxJsW69XE1qLEJ6wSqg85eSpwTal7Me04u0yfNSUpFFjhTEDQlNTj70Q1SlX/MXqYtwHjMhRiOdJPOVQwY5qqADNsKsbyN0RHhsDyj+yJ4aX/oJOvbPkT1RyDnRS68nERE8MGmNE6XTgRcPx6E8s99e6TZJNMSmKh2WnDEQhF4z8aDRggIs2Oo6taHqnM9Pn6MlGHOn0tSOoKj0TT4tvGBDv+K/zZFtUQ9LYfcE60Yp6h3y0nlN5awvD/mrd7BzAHf5o0Y78hqoFbOUepkNZHzxdW4TD34OkqxHs+6huDErvwFyp/LXSN2rtj3saMrR1vn4FZz9IK5HrVEPH/GtoKHRTkeRQYTt/yQI15EW7G4ZOTVZ5zKrxZP/+StjpOVyHBtt9d7BRN14A7x0PR4sGGA9OxOQj5KSJOqXUpHNISayiQ63nx55i043QWrddRr0JmZfwrBig6pePEEEcHTThQ3McTxo4BuED5ZU00tzxHT89VckzpJ7T6I5b+x5YHhiHhz
 iT/HvfZs
 VoqrdBUeK9MofGv29bblAMq23JawnCLgerlagVHML2EmUSa89jJ2A5cdNeMb+VuwhY3Wdez+dGxH1BOe0f1YDhaTDFLtgtdsqw6EfOwI9AGchjAHwx6WPcx1kYj/KP9Jx53e1Qj4ONfojaFgaqK7mnF54VwlHWUu4aNrpA1vA0UsADAMJD1EG1rkSDwrHBSminVogZmcF7qejJ5ccQV79WKh2Y2odMWIXIIv+trndo+o3ZXDwq5r9BSmibNXA9FA77wfdSaW9YzfiLloQwbTcm4x7uaoez9Yn/kEh3ZtILVB6rgAOEUzNdzPBFGE4iScW17qLZ6srEBaODaHMU0TF33tYC0WRcBadmw4MaNAMO+Vf3heGAB7TTooUjZfrNFM8Wl4cO61ZTVlu44sqfOEnNVnq7xrm3YeGupbRCxpGQ8JH4YfbYV7Ao4bed/qULwfrfFVbMHo+AzLxf26J63ja8lrBh7pW4zBD89NF306bJsMO/hckvbLAJgOojgS3EpV+vO5p+bYKIS12qMcVFi8LP+IXtUKCyFQThVYyyQteCR6qtEXkEkddWYU5b0PdjGsTExjRF9piPxa7rt229uMqxBxsGwlUanPvRKqn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.10.25 14:19, Pedro Demarchi Gomes wrote:
> Function unmerge_ksm_pages() is unnecessary since now break_ksm() walks
> an address range. So replace it with break_ksm().
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---
>   mm/ksm.c | 39 ++++++++++++++++-----------------------
>   1 file changed, 16 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 1d1ef0554c7c..18c9e3bda285 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -669,6 +669,18 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
>   };
>   
>   /*
> + * Though it's very tempting to unmerge rmap_items from stable tree rather
> + * than check every pte of a given vma, the locking doesn't quite work for
> + * that - an rmap_item is assigned to the stable tree after inserting ksm
> + * page and upping mmap_lock.  Nor does it fit with the way we skip dup'ing
> + * rmap_items from parent to child at fork time (so as not to waste time
> + * if exit comes before the next scan reaches it).
> + *
> + * Similarly, although we'd like to remove rmap_items (so updating counts
> + * and freeing memory) when unmerging an area, it's easier to leave that
> + * to the next pass of ksmd - consider, for example, how ksmd might be
> + * in cmp_and_merge_page on one of the rmap_items we would be removing.
> + *
>    * We use break_ksm to break COW on a ksm page by triggering unsharing,
>    * such that the ksm page will get replaced by an exclusive anonymous page.
>    *
> @@ -1077,25 +1089,6 @@ static void remove_trailing_rmap_items(struct ksm_rmap_item **rmap_list)
>   	}
>   }
>   
> -/*
> - * Though it's very tempting to unmerge rmap_items from stable tree rather
> - * than check every pte of a given vma, the locking doesn't quite work for
> - * that - an rmap_item is assigned to the stable tree after inserting ksm
> - * page and upping mmap_lock.  Nor does it fit with the way we skip dup'ing
> - * rmap_items from parent to child at fork time (so as not to waste time
> - * if exit comes before the next scan reaches it).
> - *
> - * Similarly, although we'd like to remove rmap_items (so updating counts
> - * and freeing memory) when unmerging an area, it's easier to leave that
> - * to the next pass of ksmd - consider, for example, how ksmd might be
> - * in cmp_and_merge_page on one of the rmap_items we would be removing.
> - */
> -static int unmerge_ksm_pages(struct vm_area_struct *vma,
> -			     unsigned long start, unsigned long end, bool lock_vma)
> -{
> -	return break_ksm(vma, start, end, lock_vma);
> -}
> -
>   static inline
>   struct ksm_stable_node *folio_stable_node(const struct folio *folio)
>   {
> @@ -1233,7 +1226,7 @@ static int unmerge_and_remove_all_rmap_items(void)
>   		for_each_vma(vmi, vma) {
>   			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
>   				continue;
> -			err = unmerge_ksm_pages(vma,
> +			err = break_ksm(vma,
>   						vma->vm_start, vma->vm_end, false);

Move that all into a single line.


With that

Acked-by: David Hildenbrand <david@redhat.com>

Thanks for tackling this!

-- 
Cheers

David / dhildenb


