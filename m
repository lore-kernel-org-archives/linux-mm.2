Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 454BAF34C49
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:06:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 818066B0089; Mon, 13 Apr 2026 09:06:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1CE6B008A; Mon, 13 Apr 2026 09:06:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669B96B0092; Mon, 13 Apr 2026 09:06:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50F606B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:06:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03C671A0177
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:06:38 +0000 (UTC)
X-FDA: 84653556918.10.51703E9
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC41F100015
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:06:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Giawkkl2;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776085597; a=rsa-sha256;
	cv=none;
	b=0ymmeO+4m5jZMwM4JEwqoluyZzVwXumvJPEpUCwXZAwTDYq0JlpnusKB2NivAxpa2DFgA1
	zVwnKdG/EH7IHyS+y2bW0YErimlmqzjYaiK87aleARBfbQnmbEkk9pZO3uqpBcyDcNnmsH
	ZiOH0wH9lZD1C6mE+taj2L9LQkDcRwU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776085597;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gsK1P1os6YsOme6bbZbfr2u9YSSoYPTr268tXuAFbNY=;
	b=Xx8w2p0+aM0+4QQd2pcu11nUD66VSJwn6PEvfzL0YiEvLr/WQmZPdEMUrhClzrM95EommO
	6kdwfKhJ74dciYl/FSXxY6VUafJl6NJ1LAVGs9+dW8wNXDP5JXl7OdZZB79mlMfJkqshv4
	Qa8y46SAFfoBiZpOG4lH8NIeCk3HwXs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Giawkkl2;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b936331786dso500152566b.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776085595; x=1776690395; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gsK1P1os6YsOme6bbZbfr2u9YSSoYPTr268tXuAFbNY=;
        b=Giawkkl23qTMoW6zsofwnRJkIBSVH04jM8Rqho4u9OyuU2b2NNk33kzr1rgy+awGUC
         cEKaYL4FqsUGdZLQAeu83TqfsdKjMOmI2aWWfsDdWLX2uXyJtxnXYWtf90ZJeIPxoQ5y
         KfVEWhJG5ektbVF+8mtrYMl6x4eZoJLhpHUTV6HGHvUygvbV/o2tnClQrHAmSlz126wE
         b7NIqnVvnVnuj2Bsb6GVUfkgqZx5s3inB6BlSFIba1CUKipVh5mCFophMfWYQZrYtRlg
         VhYHHeqaG5cnmJJIeChs0n1DiEw8ULSyzQeaXI01B+XIF/baGaL+KdNE/sjoFBkYEjV/
         VnYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776085595; x=1776690395;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gsK1P1os6YsOme6bbZbfr2u9YSSoYPTr268tXuAFbNY=;
        b=dwZ7XS2rcCZMMzcTF32HEmFb5Uiw0JlkhZa/pvZwGkPyOJ4NyKj7UBf4IxQSUmCtaY
         ObykZodquTgUeHSDx2HAjxa0Pd+GzWcfMsC58msZxKPRh9i0n6+lJ+lqs7PylgBWmnO7
         GDWPB5uL6RtEbB0/qZEFLR7kOW33REXcIR1Tx0hMDi/viaiFrBr4rCwOGo27opiMurP2
         yhvtOAsgQFPqe8lCB6AP3Cpo1sxFFRnlRCVfdOxfq9WPZMpjTg9qcMwEMDX6n7/pOFxW
         ghL7Fnu30t2emnPnP/NXjLxFU5RtybsPb81WAtGO+58dXmrdtH+bbrZ0+/9SEx6vxn5S
         wnqw==
X-Forwarded-Encrypted: i=1; AFNElJ+w/B//vn3/zlzU2mC95aSPkSbcAwEMCXa/Mdm1HWLUvgE4Yerw6HsvvjX4hucUHaZVelWdmvjyng==@kvack.org
X-Gm-Message-State: AOJu0Yw+hU7Gc2iJ7hQxkRWt0MnKfPcjGBEzZG9/4yOte/0OvMU3lpBJ
	VqfZSy914k7zBo4HtPsLwslsKzmDA4yILoiCamrG3MBfsOp3n96VXb7T
X-Gm-Gg: AeBDievM7exrZZZY1yiN5tEKoNsgK4q/99/TzJvTZNV09oE3PPz/rpM5e09Zel+TEr3
	FF/uYzuyBuaZ+JrHRTziSRkQ2jNiSoCj3m1onRca9d6yxJG4RFg4D7vsIG70ZPiyFmr1VlP2IuV
	7um9vLlezLHlkeCWUrUSyfDWg389FNsdXRkEzjJnnH+jnHjrrfqxFYIszlFRiK4XmVbueIYoZiW
	cGgCGCvDDC2pMcGT9Wq2bOuBmOJDc02QgPROXB7ivu60CelZIlJSRN0cAUtXupGwsq/+cVf72K+
	UgQs25wfVTmPKQNZHKdXQLUBewE3VqUmvk4dTkOgjF0YdIPoqJt/RXlVynz5XCSS3ERBXO0ROv7
	SUuH1yix80srJBTWqQ0dYe/T0swGkFEzVcobAZrWP7S4VK7ZRp+I5qV+JpG0R0gp12EVHF7WbST
	xxTXBUmZWzbxJbIdXwFaol4g==
X-Received: by 2002:a17:906:6a2a:b0:b9d:75d7:fb74 with SMTP id a640c23a62f3a-b9d75d83c4fmr647758966b.20.1776085594797;
        Mon, 13 Apr 2026 06:06:34 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9d6de97e93sm305240866b.9.2026.04.13.06.06.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 Apr 2026 06:06:33 -0700 (PDT)
Date: Mon, 13 Apr 2026 13:06:33 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Message-ID: <20260413130633.knzkliyqvjhuz2kd@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408031615.1831922-1-yuan1.liu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EC41F100015
X-Stat-Signature: as1nnizj5g6h8dqh5phgpm89b3i3sbwy
X-HE-Tag: 1776085596-201972
X-HE-Meta: U2FsdGVkX19KZvPa2FNmuwOBC5ulXFaPpYIB9rJSbLrzPKiAdfMaq4pCFzCPA42x5EeHC+EwpuhOZvsS8lqtmrz3pL4Fwg/YehVTe0KXG6cMa8EndDQtGci1lU76Ddq2uHmsKmnE9a4gCXXSoAeqFJF3Q2Pu8QRXdM8DS6h85vaJFxbSBHVnf9h986avFWz1dKYQtrdqjz8gD2U6Qh2vw5Gpd3+EhbxK8ycnzTGIlga9XZEqDHfePs7cCKf0nvFFeRIN6q91YAPY+oI9HJlglLzdzLBHHie8/+jecpGNrSvRdjaBHWDIvDQQNzPKlyYJQd7z5WAWbqhNsXEnPuQ7C875R7BTsmxtB1tRz3ZaNssPUk5bKojf1rEgA0aKftcPCiqwBPl1taPv1N8Pg75XO35giW943mqRONd/vyhHZzm0574jR8OSpUJqgKJSodeNW/PqA6tMomfWRYEQMOjdSL0fJdhMbXc5rkwNTn8KoyAfge3zwjYDnxvilERKuPqlkPSbU3J0/TnE1t56nk+Nw3lTTRk4pmjKvXhg1sRoLQ9Ng9AWvcqkWZnUcu9ETez2NGZwx5Po26JS+7zlfrpxFIEP6G9Srsf7ekqVvYycZ4NIcQQZbBz8gOtN//fWp//1oXNJkhziqTWHi5soiXRMxcKKusCu2DAqL/KRDd2L3M9HJFhKwfzkQtm9mmqWzoJjxxpaF3ZKCchv0fJEbkBmYadzpuwm6jlbvwEBuY8weQjY8V10OidUyE1XRyxvikf74hlc6TH3bseGJRvQ1pgE79VK9xO9r0WrGsCrrrrsNGBjDMiZKxGCjOYh71cIG+3wKMVeCuXSm+YZF56iD098EYXWVDOb+kl4bl70UNMYYgkIyXUU04+6TTW5t7RAXs58+8802xWqj6W6lSYYJB9kpUbnouNwsICoXapUzNGd/f1iJPCXYMLW01ULYHqvmET6yV4EzT5C7RB/bbe/26u
 Yj3Wke+J
 MskPtNYCKbWC7htiKDVJXDaAG3eqNRLs/WLSmp5NO6W9C44+5DI3Su+9HCaDv1UPC3FJ8TpEnFvPYWWBcjTqHv4abt27DAEJLegENSC5QauP4KmrZVJBL7pZq+zQ144orM6YX6UNdT+zOXprYsJYaEU+TwWTbo30yisX7fyzhFf53ZIWleQqW1r7ZI/0fg5AJJ/iqXMUExZOnsQDDybfhx7XqNy7kGhjgdyHK19dFoiRjljSFOcS0b9PXXBtWcszFABPUVOFUPrRGWiNNGGLTHLgsHPw3p7f6HR6xvOHe2ECXjhpd9oxlOjRDJ4ObqYR7MiZ6OP82IBoW18hnHk/mV95jbLopIpmGLRNHBO6m+YCTZTp3kNBCdT7Z+amLHK8VXhstkpsgN9svNc6+qHFJN2W6El1bTKcfbR8jD1NKxhXx83f+uB5OEevcE+/Fhf4qsyQFViYSuwVIRRVV84cGUvr+5BHMAVSJuv6oZIUwYy1KMdE5ypHl78BkR4SI6C6KhXxy9u3aiJKylzqWXusSs56vtWQXxTNe5NlpagRguJcEJWpebDJIbfFWIT6CBmpTX861h9fLxxg01PclDiXHuyJTSU0T58VKcZduwp3/zqVutl8pW4OpBnzGeLJvv48316luF9e9gM/2PWqD8fvHTEJ8Hybrptq3Ghp6Z20wDK9+S/KZ5nTMd4no1gLz3Ctu5qHeiTINGmovMnU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 11:16:15PM -0400, Yuan Liu wrote:
[...]
> 
>-void set_zone_contiguous(struct zone *zone)
>-{
>-	unsigned long block_start_pfn = zone->zone_start_pfn;
>-	unsigned long block_end_pfn;
>-
>-	block_end_pfn = pageblock_end_pfn(block_start_pfn);
>-	for (; block_start_pfn < zone_end_pfn(zone);
>-			block_start_pfn = block_end_pfn,
>-			 block_end_pfn += pageblock_nr_pages) {
>-
>-		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
>-
>-		if (!__pageblock_pfn_to_page(block_start_pfn,
>-					     block_end_pfn, zone))
>-			return;
>-		cond_resched();
>-	}
>-
>-	/* We confirm that there is no hole */
>-	zone->contiguous = true;
>-}
>-

Hi, 

I may see a behavioral change after this patch.

  * An originally non-contiguous zone would be detected as contiguous after this patch.

My test setup:

  Did test in a qemu with 6G memory with memblock_debug enabled.
  And adjust the /proc/zoneinfo to display zone->contiguous field.

  Originally, memblock_dump shows:

     MEMBLOCK configuration:
      memory size = 0x000000017ff7dc00 reserved size = 0x0000000005a9d9c2
      memory.cnt  = 0x3
      memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x0
      memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x0
  +-  memory[0x2]     [0x0000000100000000-0x00000001bfffffff], 0x00000000c0000000 bytes on node 1 flags: 0x0
    
  And zone range shows:

     Zone ranges:
       DMA      [mem 0x0000000000001000-0x0000000000ffffff]
       DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
       Normal   [mem 0x0000000100000000-0x00000001bfffffff]     <--- entire last memblock region

  With the last memblock region fits in Node 1 Zone Normal. 

  Then I punch a hole in this region with 2M(subsection) size with following
  change, to mimic there is a hole in memory range:

    @@ -1372,5 +1372,8 @@ __init void e820__memblock_setup(void)
            /* Throw away partial pages: */
            memblock_trim_memory(PAGE_SIZE);
     
    +       memblock_remove(0x140000000, 0x200000);
    +
            memblock_dump_all();
     }
    
  Then the memblock dump shows:

     MEMBLOCK configuration:
      memory size = 0x000000017fd7dc00 reserved size = 0x0000000005a97 9c2
      memory.cnt  = 0x4
      memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x0
      memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x0
  +-  memory[0x2]     [0x0000000100000000-0x000000013fffffff], 0x0000000040000000 bytes on node 1 flags: 0x0
  +-  memory[0x3]     [0x0000000140200000-0x00000001bfffffff], 0x000000007fe00000 bytes on node 1 flags: 0x0

  We can see the original one memblock region is divided into two, with a hole
  of 2M in the middle.

  Not sure this is a reasonable mimic of memory hole. Also I tried to
  punch a larger hole, e.g. 10M, still see the behavioral change.

The /proc/zoneinfo result:

    w/o patch

    Node 1, zone   Normal
      pages free     469271
            boost    0
            min      8567
            low      10708
            high     12849
            promo    14990
            spanned  786432
            present  785920
            contigu  0           <--- zone is non-contiguous
            managed  766024
            cma      0
    
    with patch

    Node 1, zone   Normal
      pages free     121098
            boost    0
            min      8665
            low      10831
            high     12997
            promo    15163
            spanned  786432
            present  785920
            contigu  1           <--- zone is contiguous
            managed  773041
            cma      0

  This shows we treat Node 1 Zone Normal as non-contiguous before, but treat
  it a contiguous zone after this patch.

Reason:

  set_zone_contiguous()
      __pageblock_pfn_to_page()
          pfn_to_online_page()
	      pfn_section_valid() <--- check subsection

  When SPARSEMEM_VMEMMEP is set, pfn_section_valid() checks subsection bit to
  decide if it is valid. For a hole, the corresponding bit is not set. So it
  is non-contiguous before the patch.

  After this patch, the memory map in this hole also contributes to
  pages_with_online_memmap, so it is treated as contiguous.

Some question:

  I suspect with !SPARSEMEM_VMEMMEP, we always treat Zone Normal as
  contiguous, because we don't set subsection. So it looks the behavior is
  different from SPARSEMEM_VMEMMEP. But I didn't manage to build kernel with
  !SPARSEMEM_VMEMMEP to verify.

  I see the discussion on defining zone->contiguous as safe to use
  pfn_to_page() for the whole zone. For this purpose, current change looks
  good to me. Since we do allocate and init memory map for holes.

  But pageblock_pfn_to_page() is used for compaction and other. A pfn with
  memory map but no actual memory seems not guarantee to be a usable page. So
  the correct usage of pageblock_pfn_to_page() is after
  pageblock_pfn_to_page() return a page, we should validate each page in the
  range before using? I am a little lost here.


> /*
>  * Check if a PFN range intersects multiple zones on one or more
>  * NUMA nodes. Specify the @nid argument if it is known that this
>-- 
>2.47.3

-- 
Wei Yang
Help you, Help me

