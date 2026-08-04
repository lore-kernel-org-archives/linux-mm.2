Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97EE5C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD116B00FD; Tue,  4 Aug 2026 12:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9D846B0102; Tue,  4 Aug 2026 12:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3F06B0103; Tue,  4 Aug 2026 12:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 886726B00FD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:36:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0491C1C0543
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:36:05 +0000 (UTC)
X-FDA: 85064139132.18.3500917
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 281AF18000F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:36:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Pt6hwcgG;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785861364;
	b=yNg1AQ0ZAicajydZo4djRpN9ri5w0zlo5dv3CZYqajcV4HeBr7nkLCFwHDKFIaiVax+Tap
	z24RrN9h0Huy+qpjRL0Y1gj/Y7pW9yCD5KDxlh4MRxTS8sOcNQx2lfi71bQMSm3TBi5/df
	qtIOJQqBAb40Z9Q3PcJsj5bYBcXFJ4Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Pt6hwcgG;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785861364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5a+BLaoSLHItF9v1223ZI8dgUJ+oeFH6YBlcTBazBe4=;
	b=Hweq/i/M6uFXPia2qljP4BD+vxAq1cO+wmqDcHE+la0bG216WNSL2i/vLonS9zmMwtTlJ/
	38hkaPMllQrNforXBUoCvktD9hauONfAsZvTqDobK1U8VZn6XZBYFZBVm8bZA7s9kHjWou
	hGovQSLY1VZgtCe4jDNuxoC25Sr7JAs=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-934956bee57so4531285a.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 09:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785861363; x=1786466163; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5a+BLaoSLHItF9v1223ZI8dgUJ+oeFH6YBlcTBazBe4=;
        b=Pt6hwcgGdTU8u2lV4oYvRNU5lLfDyoJL0RjFZoG7QPPZLPOArNiiqtEcZmL/Iv0S13
         8sRpB5Jsas61ml3wcICuHYrtUr4QwdX8MVQJns3JVC1SDtmvo3ARdZ2j2uiuPfGgLJhW
         ovv8BqG0GVCvLH4m22Nbia+GVjvUndhfTr/+Iy03ySlQ+JUZ8JuhGcwTwRtvrh7PTevL
         4FaF2aMppdK4YNbYVLj5mxDcWk7RB2aHbvqESS7Ks6UMtHf2Qt0+3TirbBaQNZWbS1rT
         8JmKyA5buU3Mov/KLPz4zpm4nPFaLRH3C7oEaAdpZxZIyDc/FWduSd9YZKYKbam/2dHG
         cogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785861363; x=1786466163;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5a+BLaoSLHItF9v1223ZI8dgUJ+oeFH6YBlcTBazBe4=;
        b=AmFEUTLRta5l12WTLBom0SCrO94uGWofj/skVdVEzsG1/F63derjoKq33EqIGmXM9X
         X07qoVSZdh/4MjRf8LbmGAzQGiJLm78bjZQe30GEwwitTKNSfrjN4rkZZgDxq2bU+6H0
         6CgwzlIDy3Zw1rPw81MrKGbN8HYpgy4RqbBl3jY6Pyo/T3+08KaPFUtwvJgYgecieg2v
         sRf1vyon7M4Yxqe9oc9DP1fjq3K0gs8m1FSNqbUrZz9DlX1KtqGJnY28CG4H6lioMPGB
         tha5C2T7bEwS8Qot2Hien7WBaot+4BgqZpjXOYsz5dbGxa/dtQBC1IV4Q5eJq9Bx/y8m
         Atjw==
X-Forwarded-Encrypted: i=1; AHgh+RpAWGrRgORkPC9wGac7Cbdyuu4jYpZcdlY7yLICyFEvJO9WF4OOuFQ8cXqCx+3UaN+Qj21mjV0fIA==@kvack.org
X-Gm-Message-State: AOJu0YxMFO+zfJdZW4S72wm9p9Qg55QEOgvBZ/rimKf7FrRQoOPamc8M
	6hZg74F+YAN2Lq0xKwgxZpFDD3FG4NWHGAZJ+H26x0V3eJZOWN4qiBRLB4mQnzaA0lb66+BC81v
	wLMPD
X-Gm-Gg: AR+sD112ebZDYJfCPmkEkvTGzXq2uFYT1l47mxX0xDXqa9BfT3T+Yt22LT5FpRnXFm3
	4iqfyrD1zMW9psZNP2sYOCPJOfB6GUjtUiQDPbSbUTW9DoRr3c57jtkhn4zIc8ftryKlvb2AqBs
	15IN+Y75boBv0Gw2tFfcRm7HFdhUezWNuF6JV0En3Jt9rI8t/zQncSwlGGGmMabYeX2pEfCa9qX
	gYVSue6jhDhmLoVZz3nupl094qJhWhqI02+SPnJQ69OeOZHVriBIwSqxMRVdbpieiZSUq6XZah+
	9hDMGJxCpMPYGSe5Akb6OZAoeO/Us5SzCBS0DcFHMQLlsuLcSSmQO6zABm8Mjp139S3jlRmASm+
	s7Xe8/B+jxvo2NydH42VoflQ0xWqX/5WQVtqmgeysg35N+uS4MgbNgKaW8K8v8OkCVboJvbZGdY
	T2dzcK86uMhPVpEK+5t5DxShdC5+gmYAFCPB63UnBH3byUaG9x2QdmYkDW4/g8TFZZQXh9lWAd9
	A8aEULubjHJil/ihK3043IzlYviemdqdibY51sv7rke
X-Received: by 2002:a05:620a:6504:b0:932:ddff:1241 with SMTP id af79cd13be357-934a093c62fmr2874633085a.26.1785861363074;
        Tue, 04 Aug 2026 09:36:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936418ee312sm115244985a.37.2026.08.04.09.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 09:36:02 -0700 (PDT)
Date: Tue, 4 Aug 2026 12:36:00 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 09/15] mm: Remove locking mf_mutex in
 is_raw_hwpoison_page_in_hugepage()
Message-ID: <anIUe_Zq8bFX0-Dk@gourry-fedora-PF4VCD3F>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-10-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731200802.574821-10-willy@infradead.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 281AF18000F
X-Stat-Signature: 96ifpdirtnzrnhn7yiix3auitatexgmq
X-Rspam-User: 
X-HE-Tag: 1785861364-713122
X-HE-Meta: U2FsdGVkX1/JqVGUL0kgraw93EI4Uqccpg+HlIxNC+KLkhwtX601ieCiU9VbOqB0E8lnc+4obxtiJp2jK5Hd6X5gxfGLWq/NOFsWfeQllfkYAbA283o+MWjqGcpQQ9W9hJxc0hGLCscMR3yt/48gFPmfns/rH6F4ng6CMUcyUYqx7Wot/9VaHrw5QYEs738V70oxIHzJffJcz2JY6PDQ8D6ySqZ1c8z7jlSP7rlLcfsm4FirAEANzOQuEZddEmbPktt/aPEWauoU1RQkfJehQCFVeVtPrFP7OaUUTSrIjcYI6aDymmcPOVYI3R05Hite7YgzTumnCU0mWmMI1hzvBiU2G+i+K5UzUGHYGmrXWc4x/p76I9+Zjw7vDD+TkfFqh3C0PcYZ6tG9l9KddcWzuxweXEzaGQcp1vcohskcRNX6P6tomkDrCpUbGoWzwhtGIM3KVULMFdZv/isE7hJ+BTDEvds8aHlzoz5ZGxKTLU+UTaIx5gyEgdP0GnbFm8NJsHqiOQdgQx3aFSCTg3jDS6qu9tUa5wTvuXzNKOdcLbFT41xDt6M/10DHPLlv2+VZSJH3zm2DRTGAgt264EDDflL5dwcfW3P6XBFVca7Lomw6zt8gZfVyEuKKPwi5Iuq5o+DQcBrKq7Unpx5YAGrxXP04FeQCVb9I3iCQ34KEz12MqZQSmaGzW7f8uT5WbetUlkfonWtz4JpWF0h8mGxr3HeJIs5mlNsBraAWV4kikTlG+x3qYi1/PmUmypGy9ysnlKzsbgxJEd63RvFyxtVRAOcMiU1e4wtcY5KbGutth8VNzw9Buqm8RjxHHOuuV5lZhi4Lgd9BtJw+b5BytzNvlj2258+WiOCvpZngOL05z//60/1NAq2wdyqbk3NCV11+6OMk+tpzZsE5BFFdnbM4UB5YE7eWfL4bOBTyooCVE2lFP14oDmqLtj/Qkg88msaymMxryfq3F+UvZoYGAXE
 9dKUz9RP
 gQe3xEyOK7SWIvDqVD3Q1lLKLvv36tukthiu8NIRRMOJ61DZPCClbXvt3XWRyFSCCc/llzrnF2EWhgsPt5Sli8bQ8Geh1QVJOTkSDE5bfXYF1wG/9iai9DqIhBhsuz/GoW9cmr0a3TrOIwQM509DvIgNv1MGI0+OGa04QQ6/EwjQG2JH9DgH2KfR1RwfDL4aMrCM2LTD1IgSKS80k94tRffVf5S7LL9bIRvlPXR3Vi+BOZ+/I308pjbbL3G92/ijZhPutXNZ9bhFq+xLplh5U7pN5mnHb/W8GXW6S+h9My0yHQCGDw85Xa0/lU7dtYIExpsQdtLFNL78e/97ZEHaqcXaXG4KEZRaX0RdavFmA++IdfRorngmqXFYiUQyxzevbHhy6+jfq/NotwLs22tTZlszjABcY/ihIpSVZMQ99Zh//dbTlyx6T89I9OKJ8tPJjNc5bcjhVYp0y/a4Zm04E9LM3abVtSy7hZmY46yWOi7OSeX86W2hRqwtJaw88GEX1DvpOFp8PzT2k5tr6JMXZdX/jveQ2jWBdPDFILIshO/tCs7CXGhLK06EPXsQHyQBmg+dJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 09:07:54PM +0100, Matthew Wilcox (Oracle) wrote:
> Sleeping in this kind of predicate is unexpected.  Add a new spinlock
> to protect access to the list, and turn it into a normal singly linked
> list now that it doesn't need to be a lockless list.
> 

Out of curiosity, wouldn't sleeping in this context not just be
unexpected but theoretically cause issues? (mid-poison, sleep, scheduled
process generates more poison on the same page...) - at a minimum this
takes a thread out of the future potential poison-generating pool?

I don't see any particular issue with the patch, just curious the
implication of removable sleepability from this context.

> Rename is_raw_hwpoison_page_in_hugepage() to hugetlb_page_hwpoison()
> and make it take the folio (since the callers naturally have the folio).
> Also remove the handling of non-hugetlb folios and make the arguments
> const.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


