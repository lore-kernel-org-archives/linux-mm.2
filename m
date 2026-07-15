Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E84B8C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2D86B00B0; Wed, 15 Jul 2026 10:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C406B00B3; Wed, 15 Jul 2026 10:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44086B00B5; Wed, 15 Jul 2026 10:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8991B6B00B0
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:58:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1CE931A01DD
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:58:12 +0000 (UTC)
X-FDA: 84991316424.09.BDD671D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7CCDE10000F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:58:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JbGb75aA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784127490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YFpgyWHs9kn9sVjQ/mwxuF5PU2oG2W0sa64U48Z9bFQ=;
	b=xLiV2IV1jM5MKd/hl6byW+o1I5kcUCSgVXM8jQRDWPCoULqRxr1Pk0qUECkzM5zqzXSndK
	HM0qbkzYPq4l3wCUqH7UzCasyxsXWbijvx+oMRs4U2tdqaNGBmWFkK45dDy4XC4kHWWNH9
	0IzkuQLScqq+vLw8VsYZJm+yPefMkpA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JbGb75aA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784127490;
	b=7kDLNgs9PRYOqouD9XZxq84u7jMfN/OGkYHqKZeEuFIXeMrxaxrs9LyP0T71ngg4gVF4IR
	U2O4aNuO7Znax85/6HFVidwZ+D1FpAgFTE4bXfVyBsHCr4NGdRaNNXnPbhAP8Ovu5AsVsR
	Yr7Rdjp5XV4umdxd9250JcJkQx52t2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F8114039A;
	Wed, 15 Jul 2026 14:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ACB1F000E9;
	Wed, 15 Jul 2026 14:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784127489;
	bh=YFpgyWHs9kn9sVjQ/mwxuF5PU2oG2W0sa64U48Z9bFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JbGb75aAr0mj+X+n+hCLEoLVDMXVr4L3aSdbks4fQSvqKqdcwweNjv1vxnURJcViq
	 IoyGAJfwYaWjTwe4uz3c631hVjBY7ShFGZjwu4WHrDAsVFEKKPz/fxQV3L8x25WW7a
	 fUdzLS1yGAUa140tt8lJ8K6NVr9Tvgzn2bdk4LoGeYtyLAM0qFCjF4/CX31z8gHssp
	 sxaxGbMQW++pn2tXqWWpTmR0V2S0z6Zko9sb5m69v8ACPtQcruBvvf+3IKMH8H/QDj
	 ZBBcx0Nq/WuPutNVCCXl+AAD1b2ARJZTKVRAwU2tzptwKIz9uOZQvaPhzrvI+EN8A5
	 EpAqtYBhMPh3A==
Date: Wed, 15 Jul 2026 17:58:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: disable under HIGHMEM
Message-ID: <alef-_LMykiBQ2qP@kernel.org>
References: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
 <20260704192603.40aa80cf9242b77aa75e8d8d@linux-foundation.org>
 <DJQKSKCN9KIB.25WIOU9KF9CNV@linux.dev>
 <akpBWmnujSnj1ZEE@kernel.org>
 <503aee9e-97fc-4889-a379-3c0a5d140554@kernel.org>
 <DJZ3TQV3GPDO.6AN321FGTTX@linux.dev>
 <aldv8U-lzCn0SCBL@kernel.org>
 <7e7f20de-c43d-40f7-82d3-8d05ceb3656b@kernel.org>
 <aleOvBtB3WCSsqEd@kernel.org>
 <21e7746b-9bc2-4643-b0ca-c59e0c77f810@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21e7746b-9bc2-4643-b0ca-c59e0c77f810@kernel.org>
X-Rspamd-Queue-Id: 7CCDE10000F
X-Stat-Signature: codkwkpzokr8qeh5ceitpj8ibcitxjja
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784127490-610157
X-HE-Meta: U2FsdGVkX19E6j/mS8V9B3W10Gq1pVaWbgE71IebCZah5icQtLMjvqJb94FDptXwverbGCKN7qvC2PrS8rApBu3ovZ8Gxb9EQS7FBNrEOSY7rqU8eu2F9Acs3DPSchRFFT+VtaSHLnj9M05XDqT7ypj3kay4NIaVFmhe/foFjItz74rWimTpepDXLVivlL8ZhgCiGw5BjPmhL6VmccddNipbqNQzJsGqVrHPxEjvGo1npcUk7a7wvjty7gCsoWMHTTtB/Dm8+6zQGyd/lTPAvZlbKGiWNUXe9Me243Gh2VNkbPlyYxbsafT5n5lt4WfsFYajs6GOxVXou6Io7tN/8t3+hKurmoHqGjyenKEvcAPMGNsxd0acsWk4PKV/rIhLN5YqGtBzA14we78ddyynldIawNHLdI8L0GxAr+bkUCiM56/v25bWVSSAYyn/juGkhwHlOXAOTrTubL0E4VBoHerrTB8qS1v9bHk6GKP3GpQoogQ1dld+LW5Kkok660x4QqbkpL5LpBxxs6/pGXXOu8oPdomhuiXKFVjagzNNsQZCB90XpbFdLQicw/K9Eud7h06wCD/z5QKpNXt4+ARjOuoZPxHRK2UlxHH3XKxQhcC/bGlf+vo5VJdsBmdzu+Qp3UZxwfPqNK/h/BleevwEnCDHlbcIssEKvYFCS6ENsH7JgHKt8MotVMnbA1d7Hv8QUCKpy/iLs89NSzuZkLxoNfQ28scuEZaUtHFojnG07AT5GeT5ud11F5Bk2qwppqceFN+svuK4yBa7/tRV/FGPF8RDdGrMeopZ8QY83Lt/nWDDlHpMZZTV5wppwLrgSwcE+aK1eFim0O6PFLtPTllsM1JBXowC3ADD/V21ygwVQK96PAJz7sh9RWh005CclD5ydJyTqVKsyj9kC8GNxULffAjCt5uPXwwjjXzFQPzNFzILUzZHy66yoiuj9VnEvS97+nMaFtwQRT3puEBPWyq
 PLpO1g6B
 nYBlfPowU/cDjGl68FxM3g4UvI2vfSzO1N3DEN9TTHIUrFnTGq/gqj8dVM+Ky7FIIfRhwoEeRUNKhqdIlwORlXN+is/686M6ZdeT322raQtEpBvkLpC3Xy6NFTIQ40Wnz/9BS1zn7FWnUB0e9saUS+lXEDgaSZiHWJn/Mpw63tsNlAWOTPHlTUr9BCM58DzBosO4MX4p6iVC/ZS3M46XfJfM080y6Ak2xGbFFeARR1IzJfeFTWP3ekqVXzX1MVt6JEcoy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 03:49:39PM +0200, David Hildenbrand (Arm) wrote:
> On 7/15/26 15:44, Mike Rapoport wrote:
> > On Wed, Jul 15, 2026 at 02:31:08PM +0200, David Hildenbrand (Arm) wrote:
> >> On 7/15/26 13:33, Mike Rapoport wrote:
> >>>
> >>> Right :)
> >>> Supporting 32-bit without HIGHMEM is easy, so I don't think we should limit
> >>> it to 64BIT at this point.
> >>
> >> You mean
> >>
> >> diff --git a/mm/secretmem.c b/mm/secretmem.c
> >> index 4877c262cb1f6..d29865075b6ea 100644
> >> --- a/mm/secretmem.c
> >> +++ b/mm/secretmem.c
> >> @@ -202,7 +202,7 @@ static struct file *secretmem_file_create(unsigned long flags)
> >>         if (IS_ERR(file))
> >>                 goto err_free_inode;
> >>
> >> -       mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> >> +       mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
> >>         mapping_set_unevictable(inode->i_mapping);
> >>
> >>         inode->i_op = &secretmem_iops;
> >>
> >>
> >> then?
> > 
> > No, I mean what Brendan's patch did:
> > 
> >  config SECRETMEM
> >         default y
> >         bool "Enable memfd_secret() system call" if EXPERT
> > -       depends on ARCH_HAS_SET_DIRECT_MAP
> > +       depends on ARCH_HAS_SET_DIRECT_MAP && !HIGHMEM
> > 
> > We can change gfp_mask as well for the sake of pedancy
> 
> Why not change the gfp mask only then?

Citing myself from a few emails back: 

>> But still with kmap() and friends not being an NOP the promise "kernel does
>> not map this memory" does not hold.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

