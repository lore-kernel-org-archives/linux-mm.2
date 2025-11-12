Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18852CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 11:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52AA08E0005; Wed, 12 Nov 2025 06:27:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA0C8E0003; Wed, 12 Nov 2025 06:27:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C93D8E0005; Wed, 12 Nov 2025 06:27:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 276C28E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:27:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE3441A0469
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:27:43 +0000 (UTC)
X-FDA: 84101730006.06.7CF4EC8
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id C81761C0005
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:27:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BojgIns0;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762946861;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSggrV2YcA4TKtSlET7nAH0RSJcTHMLZHoulBnAhgsM=;
	b=5dZujjRtsG83nMomLyQZ0UQPZVhMQfpAvhqqzHWKz/zwk5fDMFeHKqJCF9vdLC49EaWRDs
	pt7RcT2t1+i0s/wm0PVCXubfGTGDfZgqCCB0WcWAGr1uWp3aTRE2LV4MDizEKKS7cV7dlp
	RTMlSxqgat0U9Z8pk2KzLlb3aIEVIr8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BojgIns0;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762946861; a=rsa-sha256;
	cv=none;
	b=zhLwNXmNSKnwpjIVOtyawNQI0WQc4QjxWAoWY9/HZuPzGvJgGYLvudWDXZJqqwUNw3A4P7
	DpDUx5JGhEvhMlvycW4ekyHWSsEB5OXBGbnxjrOqe8KSuvq5+nmtrXBbALTYFM0gZRj3oz
	22jS4l0VhXNdu/ehSIi0d91BghU0lCo=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b72dad1b713so120148366b.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 03:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762946860; x=1763551660; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSggrV2YcA4TKtSlET7nAH0RSJcTHMLZHoulBnAhgsM=;
        b=BojgIns05ppkguUcNl+j1R8S8cJbauPqqEII7kLLSz0rcgwegv/gvmi4BoUBsOc8XZ
         blep/B4ZejVyyIQrV4piL8tuq9IYHxy+0c4UVRfjIt/d8Se6GEBXkraNfX7qpNCZZLpg
         uYOC8fSH/hOrD7mQGz8X2y9snZz8HMhAf5IAP7DA488ghqDXaqvT2UVFk/qqsHYz0nPz
         YGdh5gu8XPEe6ixcUNwlJJMXWyRwMfmr9+NaKYyjMKtksLmaRDQEfuYFNgUXroLDV65P
         B7iOO2BiB1o52zNqUEXleWw3AA8v5utWaXY55yj5CO9W+/3sQM5w2fHGIBW1no+IbssR
         CnsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762946860; x=1763551660;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mSggrV2YcA4TKtSlET7nAH0RSJcTHMLZHoulBnAhgsM=;
        b=X1Hm8tWy5Ivw9qnzxKkZj+j5r1Kcd4ZJL8eUzWWauF1a8mdIVBvIU076FMN67darTl
         UtFXmV6a82cSdMPqiDUgoK7wxSavjZmQLU71Y3CUDDiTlCJUv/6w3t2hVfL2Albj35I8
         2PJ8HefE9Spi7qReSpvOBg5XtX5ZXDtiQNjimesz4b4oJVnhrTAah2RMLUcscWkcxmtJ
         GNA5EGFyIbW+kRfujDwMCD4mCjuIE1gxviyw+d4n6vgm+z4sJ4HR+K8fEmv+ivRrIZpx
         iW260x0zBHbb2gyTUjdiChdbmFroFGUbRmPK24KIGwSeklsLJj9V66vneqBEWOhKDD6q
         Gnlg==
X-Forwarded-Encrypted: i=1; AJvYcCVQbzII2u9rn3U3d25UpoicaS6tu1rz8dG8NlLhd4ylYu3ljKVJA35BliegvtVMB58ulqRoe4kDxQ==@kvack.org
X-Gm-Message-State: AOJu0Yyd5jtuQUpCphZ3Z5lAlmhRkpskQXT4vhJl2GTeX2kIkRSjrgcA
	LisQ5WYj+SrdAvA1UW6KsAGhjbt4wIb06SisWi2PghxOFbhWtDRsk50Y
X-Gm-Gg: ASbGnctuAieAfhzP3WFYup0EpxWOpqXCwj2opu1hjJoc5NUIitFfjY8a+sCCse8E4Ho
	1azrTz+QGZx/l8GkuOf3VHFabi7ij7CypubArR5dWaHgoOfXEq12FP+1BpvH1riSbKqU/TNUqYU
	UECjDB5ZqJNnEQSkH9wIA7OTpSJqqbE0pzWdRKbX6gPkSwkGG+XoR2LNLa5x7f8jIehpRBtCjj5
	TfeTo/S4em2lT4zocdIdlm7fMCc5LTZv3tY+r/p7RIufNKUNkWSWpdrJsUwIzldJJMsahTeMtE4
	45yi47+X19NVj+3Agj8dxCrWm3NNKL7kwu4A941UbIi97X/QavRjNbbHrvOtN7TJkomYignimCF
	Wolv7Q9pE/tHsHAKeQqAYOZnr6gLb+QmPzsIeqrXqz2/gHt7wcP7cirsBX02/DDA9wwamsYDavY
	nox4c=
X-Google-Smtp-Source: AGHT+IHxsEbDL/xR6asnje5N/8XvSb1PFXnD0OexsWPMH9qsWk6egjjw6yQMK73NXnJS1h0nzqOjxQ==
X-Received: by 2002:a17:907:c1f:b0:b6d:6ae2:b85 with SMTP id a640c23a62f3a-b7331996fecmr272943766b.20.1762946859972;
        Wed, 12 Nov 2025 03:27:39 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf97e54asm1573045966b.34.2025.11.12.03.27.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 12 Nov 2025 03:27:39 -0800 (PST)
Date: Wed, 12 Nov 2025 11:27:39 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: continue to collapse on SCAN_PMD_NONE
Message-ID: <20251112112739.ovfkj6zy7kqcervv@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251112020031.25350-1-richard.weiyang@gmail.com>
 <04e8e813-b43b-423e-8ad9-fb13ac953055@kernel.org>
 <d4e055dc-be45-4ced-870b-2b62f3507c71@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4e055dc-be45-4ced-870b-2b62f3507c71@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C81761C0005
X-Stat-Signature: qiwfdu69qmbbszre5agfm9zmabxddys7
X-Rspam-User: 
X-HE-Tag: 1762946861-588491
X-HE-Meta: U2FsdGVkX18gn1e6nun91VF3d1ad5TSBptoi6D4+HNLheq0q9gdv2Jomlxx6Vwrl0v5rpNHoE09aXfRo2oABFQBeDJhSV6GPFamVo6QLIExI83f/Y2JkQVjDSmM5zVSflduIpplaheoJDAqGu4+Kh9yMA7J3FTfJbuKVG0F/KSNyFoaqkLr0zb+pffVcpSH5P/xFpzNZf7TIRYsh8aAtM3IoGXfqppP4n9vcJcJqddyStm15zovAqPyufCu9VfEmj+Rg+BDgxzCjh4Z+4tJBdQdLbQdwid0vidvxXpRkrndTC92dPSQ0vJjqmsgekaFczLJCUpXhBs1yUCVGzZ9Zc6GMmBwLg6xWXvl35Kg8xoo/HhrsD6UXWrQ2x8crvgZGsc83c/TX3v5QhTHfjfY/vVZmt0HAFHrX4ysw3dLOIFSnGX6al5fM9waC8lZ/39qujLTc73i0kjr3vFf8Llu17EB1FDHJr2+rtbpTsbxLU9OH7woY+LZ6vgDV8W3SAOzGmaFzyqxm/o7vwGAJ04yg4bmg9Di9b+T9h5As//iiR38UrbJFSeKBJr9SLezpWkvjhOqoU4C0T7NL7hudIVMnsNxwdbZgSN9iHqc8PXlorzyANV+BzAaPBuE14wO3upOuKbs4pP5i1/alQss0dTOzLwEY5r8yeRdw+ZwgGklXtLBgfb5M6bqJcxjgkQQ57CCGtkd6v4Uo2TzFxe4hNYEnt+/9XAofvasleF/3zDNkbbZ91+q8g+GpGS5ZZ9VcjcP4J2J65DbDvcPSWyNMdGg5I56LGCl44uocOjLDqUvdOiRtwUhlVMBvPooXW3OHg7oQcG00S9PuFRu5j4IjSKZYE8xt1bEg29XfmH8IaA2jv2bGKetzgJgRlYMKLd3L6uJv+k+o4X6r1xRzXuBUx5L25aBv+9wtmmbwf2lkF16nikN++KZlCbyEsM1MppHozqC6L7u89uX1W3G7wNemQ8k
 YwZ90auN
 9m6D3bDvI7XEjyG1bm+IjC2ggZ790rW1gP0wUOIYmRpA56y+JcCwCBruLYDaAfSFQfuuuPmbwXb6ppp/falIuBfrosrTLTOvMr7mJ5tCk3ZXOj6FUYKdfjp4g46PxoagcBrgmFCIoQOt0sYTmgC6sasCYn48l9crqucJIXQ6gEGRN9+SvD1BOcvLsAug8BtOHkmzLjAP5rdIjQRCroLsnI6pd5sOCi6q3OEMmOeu4qX9VQirJCTGlT+t34d+2/LYVdgUFy/lEO+azHEDdvoss0ORmRpDBoGaPrDRzM3YsENJvhLp5os9D5oYVHJAdZkgN9i+4UJXmLRKfBRWEFtItm5bJkrxwNpoApqzfKmKoUqVL+73umjaU1awa7Ni75x+lwdTayvpbxbrF02HtZDKeh+s7BDAaNU2xCMYW9F0qkil7gFC+sxgxieoXbAHY6tRuOgqqcVItMuy5vBizLytayg06QHSV35ObAHDxHQjlvJOOSfjRjYg2ZC480QHI/b55KLk4YedDa2mespfDPpgbIX+bKL0WACu8C417B8ihx3UT16ei6ZvdBKh+BfxJZ8CppvmJKD93dvSKuFNhmDIjwa4quv8RdLt0h//f//JWxeyjKmzz5MaHOX/7Co0G2V2Pz/zhkx9yjpH2ubrXdz9nSQHYDbLBM7+NCJyHm4VM7NF+gSQKHBRc9NLtUkq91W2t3YsZyEvNNeM+avT2eIY636wLCe95edxaPMSsO+SNCVoSL7RmZ1Lm02WPYoJ+/swKtUqXQ7QMHPpA+UNb5mOveFLGVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 10:51:43AM +0100, David Hildenbrand (Red Hat) wrote:
>On 12.11.25 10:51, David Hildenbrand (Red Hat) wrote:
>> On 12.11.25 03:00, Wei Yang wrote:
>> > SCAN_PMD_NONE means current pmd is empty, but we can still continue
>> > collapse next pmd range.
>> > 
>> > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > ---
>> >    mm/khugepaged.c | 1 +
>> >    1 file changed, 1 insertion(+)
>> > 
>> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> > index 7e8cb181d5bd..4c2217076ad3 100644
>> > --- a/mm/khugepaged.c
>> > +++ b/mm/khugepaged.c
>> > @@ -2835,6 +2835,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>> >    			goto handle_result;
>> >    		/* Whitelisted set of results where continuing OK */
>> >    		case SCAN_PMD_NULL:
>> > +		case SCAN_PMD_NONE:
>> >    		case SCAN_PTE_NON_PRESENT:
>> >    		case SCAN_PTE_UFFD_WP:
>> >    		case SCAN_LACK_REFERENCED_PAGE:
>> 
>> Looks ok to me.
>> 
>> I am really confused about PMD_NONE vs. PMD_NULL.
>> 
>> Is my understanding correct, hat with your patch we can just merge both
>> into a single NO_PMD_TABLE or sth. like that?
>
>NO_PTE_TABLE, actually
>

I am thinking about this too.

If no other objections, I will prepare a v2 with this.

BTW, you prefer merge them directly, or merge on top of this change?

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

