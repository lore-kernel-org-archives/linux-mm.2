Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0C93CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47F496B0088; Tue, 12 May 2026 03:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42FCB6B008A; Tue, 12 May 2026 03:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31E2F6B008C; Tue, 12 May 2026 03:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1176B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:45:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D46C4140406
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:45:19 +0000 (UTC)
X-FDA: 84757982358.01.9246670
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id EC878A000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:45:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dVPusp5i;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778571918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YuUpqcwRSMeMl5pOLaTVyc6TdYwqJl65snzBr5xo1y0=;
	b=bhzPjs80nhoNkqVJklQoVWLTULfnP0FKTOuGJYyDIN4yfnKQ6EzlUnPtFfrbp/f/qF+BEE
	0wz+6nDUHMye2Stjojh4hDLBdfOQNbBBw2LbpijwVKa77cts+LvEfMn/BgUQSvO7/VvVPS
	fkJyUNlm30Zzu3Pob2aWJZMZywLC+CI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778571918; a=rsa-sha256;
	cv=none;
	b=7UkZz+MYwW3/88xCegWf/TnHQ7sR2PKSp7Deo1yUJOYYZp17UdYLK8BxqyEPckkR57vnL+
	DWsQWclfWSGkvXfsmn8sghAlOgyO9APF8z3cQGsqM0cc6gGjQW5pY2ryebkRp+trQ8mYwQ
	qcN1tbBrWdNetiDRMDBAnSJGSC5wGBQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dVPusp5i;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488ba840146so45992495e9.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 00:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778571916; x=1779176716; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YuUpqcwRSMeMl5pOLaTVyc6TdYwqJl65snzBr5xo1y0=;
        b=dVPusp5iPzYssdXYYux06KKXwMzRfvuKVyJkXrOYfu8jHamVmni/3/6RNB45Cj3pt2
         z6EZadqvGF1OqbH2LcS8jSfbG0L5BKVt4z42RvpGASMVd2+7I12RZRSPccRk3m1SA4vR
         iKGms45936KsoTpIfMKQlch5U75WuAZI7NxPm29JxYHS3yniEDWLlni3Vco0SWJZ/ufT
         4r7FL/55IY5CwlsNbXebTHGKEJfs/PNdo6DczuC9ORwWMSs50uDhHAksGyu94mFYot6E
         H/e8CAMwb4XX1ZU4CtDvAZ5/aYzKh5adwsSfgNyPRC8yrx5NslmuC+esBujcuxNscBQ8
         VGrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778571916; x=1779176716;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YuUpqcwRSMeMl5pOLaTVyc6TdYwqJl65snzBr5xo1y0=;
        b=sdo24AhHs2gx+cyCL9O8DUxdVxWb4B11BBNV5DW1pkFKp/mCf50VtFmlan1kfR5Eni
         D9p9tUEiKBudYqW1K0S+RggfFFyw2Tgxakg4gka5gWHPnVBxp47P3sXQoCp0jqFlJQHv
         uu5dpljqPmAufiWeMubfVPLofcDbMSviIWwZH4QfYiUzSSdxfiNx6+xcxJ/ITAj3d9Qr
         +1rDgU1V3ijYoEPdmhT5ftl2NrZUUAK9YTvZNBhD9kIn0OT8QcyuQyRJqJsLw0dnlTxc
         sLogJVzfVfd9K6D+qywNFfuqry/o5hqUVZ09MBGYXmiXjcIp2cWIS7DqEC9dbq25XaoY
         WYlg==
X-Forwarded-Encrypted: i=1; AFNElJ+Vpmq+y3YWnCdi3qbfrZZe9SjQjBjTERNo/0Ps/e0Fe0BXClTgW3xJs5e9AKQ61L0L0wX6jzWnfQ==@kvack.org
X-Gm-Message-State: AOJu0Ywk2HOZrCFqubcH1zijJ+sfPAInPtXTj6gZRvgGSVEyuhYuqd7Y
	zutIFJJzK31lD77CPYR5SCQ6K/09WwFXeNigCCPcGazHPegbUBVKgZTPe/jWe7VNA7OufSrHXOi
	32bjgK2c=
X-Gm-Gg: Acq92OFz483tDTIxbEgcbw40gVhfkMZdlCPFCJ19Zew4MxUQOXMNH5uzWayhKYeKBrs
	fB4sv+qesjXJnlhMx/AcUzKZ/NQohhJbIAwai5rrdj9GihqAZ76CHOv0i5Wiw7hwxztr5khQoKU
	j1BPSJ2vP1qFq5GLKjj2RKYkLtrugkaE0ZRURpYyi1XS9uqKj6k0E1ei+zVNA+upZXp2QcaUJSu
	dxWlfukyzmFJ1+iopFDoDfvgyRQvhMRrNA6BRcs2/2frkbCuzIZUBhtEn5PprPQ0ftJkQpu7KFV
	dk4J05g4WcjiXdD4YyOwjY3EK9T5XlMj5d5zmAkB7vyMT5YCzZhnao2T2BTyrOR9oS9NQYiHk6q
	x1r5UU/EbqxaPkLgjSCCQQ4u1sllD+SyKa6fHr7iPHg+DzsClSX8up7Gefvy5RYhslsH6vcXQx+
	jQ+eFO+ObGuLIRRKOxhRYxNQiJ+yO2sncR44rI
X-Received: by 2002:a05:600c:c058:b0:489:1aed:1658 with SMTP id 5b1f17b1804b1-48e8fe7b8bemr18623855e9.23.1778571916418;
        Tue, 12 May 2026 00:45:16 -0700 (PDT)
Received: from localhost (109-81-80-123.rct.o2.cz. [109.81.80.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8f63beb7sm13428995e9.35.2026.05.12.00.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 00:45:16 -0700 (PDT)
Date: Tue, 12 May 2026 09:45:15 +0200
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 5/8] mm/bootmem_info: stop marking the pgdat as NODE_INFO
Message-ID: <agLai5lr0CQRZLBK@tiehlicka>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-5-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-5-3fb0be6fc688@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EC878A000A
X-Stat-Signature: gz8c75dk3fjtm4h7xt5abjsiher8jizm
X-Rspam-User: 
X-HE-Tag: 1778571917-260570
X-HE-Meta: U2FsdGVkX1/X5mWVCH19wI49pzA9gmfp++/FMqRXZwvDITmP+x4zb/9zjNcqJYfQJVrjJyZqbNX5cL/XCip7InWig3T8KTE78ckzJkn1KAo7mUTMHRuO6XifBW0MpSNH34gCV8qaxDEetDvRcfquTqd6+Y9f6IYIclWy9wk7d7igDUsvXcDl0V+IBYfQB83aK+g41e+ZFNfkLdGmcaJBve6lAyqkGYiBS/Kq2zgnEuLlT6duaopJw3jqgA8A3SZ4/+SENaKD+H2vVllk7I/xLmAk/4TPStPXM6RlgcRW2bKNuTx1xD0YdmF4b6gYI9NgJXM1aX1O4TmCNgv3E6Rj3RF1bQmO3b0UCjTav6gDdKmgT2y6m6rS9+YLKvKSVYweWN56zSUy1VyScB8blqDAH6S0rF7Mho7+rdQymUwPdREv5U83IKgdCzBxyW5TBPyqyzGCZ68aZ5pxsV3hwFcYC2AJ7dNfSOPqpK6nUO6DIRUASyF1cwdG2J/2V/adaV2kylY/7erL4L3bimDr2RwQE31s+2oW6QzTcOkUcVO05exSfccsKm+DvVgR2JVUoxEMTMdy63xV/4sSqYKBUZcNtRcc8mBF0raa1zTmg2etDTCxOJgaB465njpKqkX2lwwvpg+wW5VXCVgiTGVA3f7AvNr+IF+e5R6kCRCjgaHU6WAwV3SFA+omqTAWrQ74/1ZUHjOAaQfFiedvQDr1Hnw3klHACp5XzQu2HUst5yRJ4hHAtpWPfCCMDjPhGm6R08VkPy3ZmQ3ynq+gMH11NR7GNpovwDR82WjlSLlVA+Olr/ggMBFB60oc+eBBUqQ3SgmrCI0uNjaIAGjQkaUVVb35M8CZeVTx9DZ1X5FYp/Cqt74CxR8+9EE1AyoyC+AhC0T+2JMFMWpmuSC5hV/cpr3C0d7IMzcrAyU8atWTMsvePCg60k9sXIo8Lts9/N1oXGmX9exZvAA3VsMVsjpNUKv
 ra4ZB2ba
 jm7yz8SS4eloqDfAMf5Y6d3gY4+UuNQhdibd6RxW/sx6EHbldE+S0VSBxqJVwc7XhoBJZjTkFHlWny8r+s7RpNob9SGLMygikvRjQ4ap+uWT+LDhbMvP/yF404ecqNNZCirGM4j9uL1wJviK50Xft/4Eu9blIimZvzIW9ZsSWLREr5YBFTjjWP5xBolw8ILDvANjaxagmgKBGC78E+7ZwNP7TAowVXAvYhobLofGmpGAbRsnkFEgK12ZVqWfK6Ra/wk2anA3lZ96TQV/f6SpRaWfEzoyj+WTDB9oYin7/5nXAB7GRt2DICI/ov4V7REihd3hPF7F5DWSxdMwOPmANnaMhYmqfI5E6bKLAgZP78+FA3kzmc/zjPxXr7o5ys1QeW2mMt0wL6RLqtGn3szqP7MrT1QMKBmRvDMy9va9+M5GR2HY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 16:05:33, David Hildenbrand wrote:
> We removed the last user of NODE_INFO in commit 119c31caa59e ("mm/sparse:
> remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMORY_HOTPLUG").
> 
> But it really was never used it besides for safety-checks ever since it was
> introduced in commit 04753278769f ("memory hotplug: register section/node
> id to free"), where we had the comment:
> 
> 	5) The node information like pgdat has similar issues. But, this
> 	   will be able to be solved too by this.
> 	   (Not implemented yet, but, remembering node id in the pages.)
> 
> Of course, that never happened, and we are not planning on freeing the
> node data (pgdat/pglist_data), during memory hotunplug.
> 
> So let's just stop marking the pgdat as NODE_INFO.

With the last user, shouldn't we simply drop NODE_INFO?

> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/bootmem_info.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
> index 74c1116626c8..cce1d560f094 100644
> --- a/mm/bootmem_info.c
> +++ b/mm/bootmem_info.c
> @@ -62,15 +62,8 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
>  
>  void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
>  {
> -	unsigned long i, pfn, end_pfn, nr_pages;
> +	unsigned long pfn, end_pfn;
>  	int node = pgdat->node_id;
> -	struct page *page;
> -
> -	nr_pages = PAGE_ALIGN(sizeof(struct pglist_data)) >> PAGE_SHIFT;
> -	page = virt_to_page(pgdat);
> -
> -	for (i = 0; i < nr_pages; i++, page++)
> -		get_page_bootmem(node, page, NODE_INFO);
>  
>  	pfn = pgdat->node_start_pfn;
>  	end_pfn = pgdat_end_pfn(pgdat);
> 
> -- 
> 2.43.0
> 

-- 
Michal Hocko
SUSE Labs

