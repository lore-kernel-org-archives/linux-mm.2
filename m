Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79091C2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 01:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5E926B00BE; Sun,  4 Jan 2026 20:48:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0BAD6B00BF; Sun,  4 Jan 2026 20:48:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38656B00C0; Sun,  4 Jan 2026 20:48:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 90BA36B00BE
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 20:48:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 130AAD5FDC
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 01:48:45 +0000 (UTC)
X-FDA: 84296226210.25.A2376EB
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3D1291A0008
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 01:48:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AJwAw27k;
	spf=pass (imf19.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767577723; a=rsa-sha256;
	cv=none;
	b=BpleeD3mju1hkQfAFyaZGMM+QZQUZ9RgI1L8MZRilFhRjZRToEzqdOfsIrjQDljtBZaBc0
	163F1plF7m1OpVfn+WvQWQZfmKAC8mYy6n/D7Af90KGCe4oFDdXgvCz/1hzWw3/FCjtStc
	gxppGyJ5BpyG+MExerTl2e8gYvG3aAI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AJwAw27k;
	spf=pass (imf19.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767577723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2+aQRhSUkFqP2LmTFOubf1LXn/mk66U3B8sFd28M+s=;
	b=So5gzElNBDUXHKCtMG3TFjrg6pS1mfZX+xbHED7byRb+x+AiSQaqEAnelJYAzRo9Reh9eY
	OIDJRYZSFyY6+aCeYjDSyaegkdOQlgIDJx/196l8zctSeOjRnoLZw8Cxd/HdWb4XE4neFA
	j4iXv3gT4UnCU3+KaKZzrwQVDnpgB4M=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7fc0c1d45a4so11950174b3a.0
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 17:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767577722; x=1768182522; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z2+aQRhSUkFqP2LmTFOubf1LXn/mk66U3B8sFd28M+s=;
        b=AJwAw27kArBXaUDc1MwDqWapn66WIj9e/OGOBWWmihy3y8RABpUZaWuMmovrn9XFXx
         6ygdfPclnVuy7oSdq3C7fT3aDZYJ+MkR4dNl3U6CbmD5TxkGoFaNHMdTRJOcxiSLpRVL
         E0mYp/YU/n2Cq0ziYxPuX1FOdGAb5Ti8V9h8+Bkt6cc+cDaf84w9YriypWh9vm2kziQj
         2iBw1zFcQwP/mGhjdSBsTABqf6iFkNIT9z+rCi06Fn/2KyqoKfcFkvnfQIB15vpNkTbS
         LO1ty3Td5W9lexMbrtERe2zP3ygpm4GVbauh+yWUn37TOFkClG53iG4JBgnZ6fezcWl8
         ND0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767577722; x=1768182522;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z2+aQRhSUkFqP2LmTFOubf1LXn/mk66U3B8sFd28M+s=;
        b=H+A3cRw48TEMbgOfxqhmhaoMdjWy/j2tbESl4eP6/SbL96QBvVov4WV4StrWKrGA6v
         6U6e4/7ClAAfnBZlVU/fQIJ22vBvcC4EP6ntPVCDkeTxNaD38AKTTBADiPqK4KVw9k0g
         vk7YHVVmTjxf3VXi3+9lnLsf8UJWlQ5jvPq65ikPc0smTJQwyuBXPgjqjnJEqjZ6AzvX
         VMyYhBpOQoTkULxIDgxA68ujSbJ2hYBEZmgG/HWbSqtVQkVfKS3pjCHD2AocNW+QIF9/
         2Wf9HbNNwzaxnSqoAaQl35qM6bCU38pri86LXmLe7XULD6Og5C6V+qrDUdeaJj37WAEW
         rICg==
X-Forwarded-Encrypted: i=1; AJvYcCW5pkv7gUhfdtJ+MAx2KBD0Q6pZnXLJgczQP4Dg7hboD+5FPqQTC2JjBhYFTehDsE+TnZZ6l2nkWw==@kvack.org
X-Gm-Message-State: AOJu0YyUA8FBwsoAFr8Kal86yu3cCVO5Eng5togmSasjAoEGHV37RZ+V
	w+mWb3qNS59bfD7F1sk0p2zMC/gz/3/AAxBBmN+XBdjlfYtBL4qoR5JPtWwbZ2BKcOo=
X-Gm-Gg: AY/fxX5bnNYzgfjl5St4oz5bD1rnDGTs0RTKmitzZ4LbNIMEG8mJw1FJOPOCHcifXJ2
	V0VjlnsR0+si9KKP7e4pw0mAYvVjzjwpMyRqUAt2G3rT8wZHyDVaZ/xdutNVofAJ71ZSjHG/suY
	Pcl+zJ6Uo8T5PZBK9RmchX2pVjjfxBZbd2O1GvbSLG7rVWs+wfWgEd8bOxDvorq0X2EL7BRWrOC
	qHj+zfEXWRYTy0gRlW6jiQ0iWW654pkG9nGff5UQYXY3KefJUDUU4NsMXH8u46w2yUBboMFRmts
	IpE6K4sVwQ4zfvAT/9VEQGF791x2XWtJkg20CE9I1DDT4PTGRUqKq1C9R+HMpg22NyB5hei4Ox1
	gekzdH+iBktkkYwFEtaSDU2MdmcBAzMpLZ5EnjBKbEXMwZ3hoT7OWLNa19+rNNgr+pjg513pXoK
	pCOOWza/ZU/3RazU3iivKAOtmu6d8LhJYsAw==
X-Google-Smtp-Source: AGHT+IE2iJ8DiNLYNsgNDeO8hqqAj3PiHMcfETlG8kOMzjEDM32HM5zkC9NMI9rCpO25q70zIBJhCA==
X-Received: by 2002:a05:6a00:1d27:b0:7e8:450c:61c1 with SMTP id d2e1a72fcca58-7ff66679547mr39592131b3a.49.1767577721866;
        Sun, 04 Jan 2026 17:48:41 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e0a1a2asm45799049b3a.41.2026.01.04.17.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 17:48:41 -0800 (PST)
Date: Mon, 5 Jan 2026 09:48:32 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, akpm@linux-foundation.org, 
	david@kernel.org
Subject: Re: [PATCH v3 5/6] mm: khugepaged: skip lazy-free folios at scanning
Message-ID: <3lbptab7e2nhqilwnoccq6kxks2r55j3ffqtslt62o2qtgulk5@w4mwglb2kd75>
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-6-yanglincheng@kylinos.cn>
 <9c82ffaa-5f62-4110-80cc-00f0c46e90fb@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c82ffaa-5f62-4110-80cc-00f0c46e90fb@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D1291A0008
X-Rspamd-Server: rspam04
X-Stat-Signature: fzwgxadkf1jpf5gp7oqkaj63ie3sx1hw
X-HE-Tag: 1767577723-791276
X-HE-Meta: U2FsdGVkX1/mTJlMEoZUVHdCQ1WlW1cUG6yfWXxN20iwAf+esfV3kzPGD2bRVllCBqMRGz3PyleYYxFu4mZ/4x1/FGd1AvkTIYpNax/mHNUNKAVH+xPJ893W/dMTzv/oRf/O/yApZDGGHaBWUeUPi0tWyjpfEfDKezXvBVl+6+YY3SFze9apkADdK9jsFDQHQgzbLzUPUhMnbKvRskqb6+k/jrDPGIC1DhrwFl+Ot+bAc7hqP30cZPTrqdZLbnK2Kji/gnYb3gzsrmW0c+oz7DTW1L6eqnznLXt8a3xSThbifUR/UV3tKDb6yYiF/JXFDRsbCssL6sQ8HCZDc7xwJK5/psBL3PAx9Sy/MQlOOv6qvvLjKvuIPKG5ngv3phJmd5bPesvrmvacYVTCTsEpBulzDzgNGux3h+OOlkbuM1f93DC02+8z6S2Fd/64dAvjPncw+2Cgt4yRdTZklgu4TqK+LF+tWHT0Ai2wzJd8giI7etn18FkVnAsgTzxAyajUlLmm99XpTAIBIh48Je2juEtV2V+aZI6TFd3s2t9E6MuWZCEtjRXO0ti041FL2EoheNMRP60Zo3rOi+4JnggyDO8kxqi97y1pSXOkj1Wii2A/lz2AoePJY6TJnmfnYXPk86RXAVR7zdYpF2CmDhovf2tH89bzjqwQpFbe27zz5PC4Pc6hmNLZEbBKOWn3g6crPmBBAqXCO7cemaAe4DRBg+YArSzo5g/VUex8Yelt0vF5MKhfDWkTNLG+wsgjrFUeSxr6dkEVQLzmXBw/vcZK3WK6wxoFCZCehJxpBKvOEu1AdbKC50vNZbCEnebeH55PttANr6waKwMP/3AR+h3xZDMGB4rRd8w4oILZvlMMvnXgo+iv4n/4SfLf5+zlyZf5XURwjs4qXCWs1onTyp1920wf+uAIVrHDsG6cWdJvZaTglaetHXz91ecGPs/9GYTLOpWFrok2C8O/1hk6gdi
 mnhjkuiS
 EsPJv1BIs06I9rsMdfAojVnfuPqCk6kOPRQ8gJaHbgdb0alnHdCxB/pY1Hm3d9E29CVYH25KJKXXptytqS89/9YpaSSY2TQwDgNPi+36WQaKXBO3b81a6BrCAL8a4rxGdcdjx8hxI4J0VJRQbZd/lAy4MLREwKWZlQZjv8+5SYRbdpYUTIrNPL3AvyaaMPrSRRf6KFxHw90OFy1Ors0g1veqGfzdvuoUn9LCbkoiQsd0+QX6GLG9nRGm1zohTrQ8Wrq00j9U4mkqIc4zN+ddEegP1K2oAv1ZCEpIBHvebw9uD8ESzJEHEvITEKFDUCmMPUvwYVBqUTt5G2Q5pwphcK1VmtDlJR3RFqY1VKbjY4zlEa2d8xgJnMqxcslFxsujGQ88YwV6KZgRqOYIxvmvLLkYsfTdcju0VKcthGX8JAyK0e0x72jc0W8kGuAOFfiadumXkKUo8aOQpW8QLHE0etNe1VkMqWKt0hlHOXMnAvjqAZLsQ42nBGPj96AykoTDcameP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 04, 2026 at 08:10:17PM +0800, Lance Yang wrote:
>
>
> On 2026/1/4 13:41, Vernon Yang wrote:
> > For example, create three task: hot1 -> cold -> hot2. After all three
> > task are created, each allocate memory 128MB. the hot1/hot2 task
> > continuously access 128 MB memory, while the cold task only accesses
> > its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
> > still prioritizes scanning the cold task and only scans the hot2 task
> > after completing the scan of the cold task.
> >
> > So if the user has explicitly informed us via MADV_FREE that this memory
> > will be freed, it is appropriate for khugepaged to skip it only, thereby
> > avoiding unnecessary scan and collapse operations to reducing CPU
> > wastage.
> >
> > Here are the performance test results:
> > (Throughput bigger is better, other smaller is better)
> >
> > Testing on x86_64 machine:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> > | cycles per access   |  4.96         |  2.21         | -55.44% |
> > | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> > | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> >
> > Testing on qemu-system-x86_64 -enable-kvm:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> > | cycles per access   |  7.29         |  2.07         | -71.60% |
> > | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> > | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >   include/trace/events/huge_memory.h | 1 +
> >   mm/khugepaged.c                    | 6 ++++++
> >   2 files changed, 7 insertions(+)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > index 01225dd27ad5..e99d5f71f2a4 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -25,6 +25,7 @@
> >   	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
> >   	EM( SCAN_PAGE_LOCK,		"page_locked")			\
> >   	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
> > +	EM( SCAN_PAGE_LAZYFREE,		"page_lazyfree")		\
> >   	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
> >   	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
> >   	EM( SCAN_VMA_NULL,		"vma_null")			\
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 30786c706c4a..1ca034a5f653 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -45,6 +45,7 @@ enum scan_result {
> >   	SCAN_PAGE_LRU,
> >   	SCAN_PAGE_LOCK,
> >   	SCAN_PAGE_ANON,
> > +	SCAN_PAGE_LAZYFREE,
> >   	SCAN_PAGE_COMPOUND,
> >   	SCAN_ANY_PROCESS,
> >   	SCAN_VMA_NULL,
> > @@ -1337,6 +1338,11 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> >   		}
> >   		folio = page_folio(page);
> > +		if (folio_is_lazyfree(folio)) {
> > +			result = SCAN_PAGE_LAZYFREE;
> > +			goto out_unmap;
> > +		}
>
> That's a bit tricky ... I don't think we need to handle MADV_FREE pages
> differently :)
>
> MADV_FREE pages are likely cold memory, but what if there are just
> a few MADV_FREE pages in a hot memory region? Skipping the entire
> region would be unfortunate ...

If there are hot in lazyfree folios, the folio will be set as non-lazyfree
in the memory reclaim path, it is not skipped in the next scan in the
khugepaged.

shrink_folio_list()
  try_to_unmap()
    folio_set_swapbacked()

If there are no hot in lazyfree folios, continuing the collapse would
waste CPU and require a long wait (khugepaged_scan_sleep_millisecs).
Additionally, due to collapse hugepage become non-lazyfree, preventing
the rapid release of lazyfree folios in the memory reclaim path.

So skipping lazy-free folios make sense here for us.

If I missed something, please let me know, thank!

> Also, even if we skip these pages now, after they are reclaimed, they
> become pte_none. Then khugepaged will try to collapse them anyway
> (based on khugepaged_max_ptes_none). So skipping them just delays
> things, it does not really change the final result ;)

This patch just resolve scene for hot1 -> cold -> hot2.

--
Thanks,
Vernon

