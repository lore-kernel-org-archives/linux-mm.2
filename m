Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E92C6CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 17:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 239B08E0005; Wed,  1 Oct 2025 13:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EA998E0002; Wed,  1 Oct 2025 13:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1007F8E0005; Wed,  1 Oct 2025 13:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F118A8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:37:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 676A11DD597
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:37:53 +0000 (UTC)
X-FDA: 83950253226.10.28B65FD
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2CFC340013
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:37:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=CzkyLBWB;
	spf=pass (imf17.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759340271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RLQF7hlwLiNbgD0/kLpi7LFdq0EzdBt4j9S3ZW5Beyg=;
	b=qn35e8766H5OvSp0wUvHPOkx6KQ4VpbipsR3vT64wSIU0dExJvQribt7G4GpNbXK7t9Ls+
	cAfYE8s1qviJbf2awLAsgb8ZGhvSDMrIJb4iZMzIi30+pIWQxqh9AGHZHaVnDSAT6Q6R3q
	6Yra9u/hWLHRx+HekBrsew4I1TpxPjY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=CzkyLBWB;
	spf=pass (imf17.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759340271; a=rsa-sha256;
	cv=none;
	b=S4wrfujMHGQFdAkPUmATPSdDjPxSxH5o8jhnFY/VmGeDJrTVvFmPug57jP8+RO3pDRxhxw
	e7sCLUWmhXb4YxvVvqNzahM/ilShvI9Q4szpLixXduhAvsvBULPbFmHKazJAm6t5e+PDst
	Oh0b/fVYWor2wI/QtUPptgfMwgvm35s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
	In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RLQF7hlwLiNbgD0/kLpi7LFdq0EzdBt4j9S3ZW5Beyg=; b=CzkyLBWBo+F09mIBNDjONPJ19f
	j2/0o2OpjS4uXs4dqolkJmAAAVEiB2z247jc5yGRZm/tbqXoz9UG28XhzMOedeuke0fRlknifHwSB
	AnlQ/9o13cKW9Qj4LgMuJHNZSppeP8dQV3O2r8UaNWQk8Qfis4Dn+yhfYn8VeT34tSHxjZMO2hzNT
	5TuDj10FNtqdup2Wtk259FYAEO79+LGO8z62UVPi9XkdS9ZPuXS4iXVqyvMf+1FH6LEv9B0vi1Sp/
	0CHNJd2kbRVo/BnOAloVMNrC3SLi927Iq8SgOxiWc0Bstexy1GSxdtJbqBaMqlhL8Nt/SdPOvsVjz
	xddHSs5g==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v40lq-002x6u-Rf; Wed, 01 Oct 2025 19:37:42 +0200
Received: from webmail.service.igalia.com ([192.168.21.45])
	by mail.igalia.com with esmtp (Exim)
	id 1v40lo-003D1w-Mq; Wed, 01 Oct 2025 19:37:42 +0200
Received: from localhost ([127.0.0.1] helo=webmail.igalia.com)
	by webmail with esmtp (Exim 4.96)
	(envelope-from <mfo@igalia.com>)
	id 1v40lo-00Cxj4-0O;
	Wed, 01 Oct 2025 19:37:40 +0200
MIME-Version: 1.0
Date: Wed, 01 Oct 2025 14:37:40 -0300
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>, Andrew Morton
 <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, Suren
 Baghdasaryan <surenb@google.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-dev@igalia.com
Subject: Re: [PATCH 0/3] mm/page_owner: add options 'print_handle' and
 'print_stack' for 'show_stacks'
In-Reply-To: <602271e2-86c9-4a63-845a-b84407d3aa51@suse.cz>
References: <20250924174023.261125-1-mfo@igalia.com>
 <aNVpFn9W0jYYr9vs@tiehlicka> <4c2a467113efd085530eb055e4a4e1fe@igalia.com>
 <aNY49sdoFVe03m_Y@tiehlicka> <d9af42d5cb9d427632087c5f51e50501@igalia.com>
 <aNvjDsBuw3hqwy31@tiehlicka> <602271e2-86c9-4a63-845a-b84407d3aa51@suse.cz>
Message-ID: <370b7e1d29a382471db93475f4419f22@igalia.com>
X-Sender: mfo@igalia.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2CFC340013
X-Stat-Signature: 77cf193dsquaq1wajt1m34y91tt8p5hw
X-HE-Tag: 1759340270-463440
X-HE-Meta: U2FsdGVkX1+yj0xZQMkYB6hhHf1Q/YuRPmgLtTKsE9/GfK+BNieLZU23pj0wRKsHOp5UVgWdw/Sct/wFUJNN+FBSOSmtogfK6s3JP86E9OQkHPERs8Hs6YQepkaqyTpkKNTxSreN70y84LlTTb5edRR7yCoMpsbBmZ/q34GQix8iWaLw8WJcZbZJFP0tCCJSLDN3LAvevRV476hYBdIt2/1q/p3SkPtHA0eSpQ7jn5LH2uHbtZ6r51o506YtZQnmkv9/LAK9saE0YV6qQOYTUKnurCB1PPK+ieiEPm1fYbasfTTLhgedsqBu51PZHOIYGaSD5ftn3vNo4dCIvIDSYF1JHLmCx2kJaN68gfpu7xxO311yakZ7Kgz1bfT1z4LmS2ptnFWmitmeY4axNFGWH0HCzalOMzNEfqQoruciWegUaBDYU4uryGE6LoPqBisI1ezgXORK+6YTac4NFTNAarKrAAqZXagQE6QRrnWLvnwciuCZ+Yp1XBN3QsTV+nWwrSX5oqEIdirIkzOUZOYQnUutW1pUZB48r5oMIGf6HIBxNYXPYYGgFm2FET0LcbzFQUS0RNXwUNXjG/swoA8SEn/zg7mR0SrExn1qRkQ4NddD2zrpRtQ8g3YSPEoaAwklRstvbfzR9J6qrEc99gW1hYGZ6Gpl62O2zHp61HuE1Q5TE8iZLAWPPlOxOLRLtVVWrwqUpe3GKou0Y7Bz2yjwl4PTPDuwUudb/tnUUegYGRnA4xJxfa6daNQdEbJ4hRcV0kbeKhpqfQOssfDMJKtTCnKI1qfkD05hMaasx82/cEDB2jEMlaFlVai36r8xbh8tHtnQPGdltlRCFYCUE8Y8PWoRxByP8W88E0OkRoZWEwYMrbCIPZDR3dtHLqMUXcmBjW8QJruzCrNTM/Csmi5ul0O9XQVf+zqVqePXI4dqJxyQJunSn/5WVxXC99zb+5DXvGHL7oQZw/SMrIJv+i/
 nt31zqkZ
 82rNZ52NG3zRwPxwe1kujgjiB6bIhUvxSAs7gXavtXHuEVrYU8PjA8Ls1OJFKJfCDCZ+b5Ipu6uk8UIfn1U+zWOlPMiZnJK4IeUEDzDvxDCxHTxrGkNw4wtMw1cpTcvu5HUvIN+f1qkLHXf7iUhzHCQNqZAb3qLb5E+bG7GK7fy6jFM9ffZXuHBT7rC37kF2PMIbhBeSYpmDXTzmi7uc0r45pnUkzR5gmoTAcst+5cx3ag/+7J4zKMX0Sf5KuUn4ANqDo+Xb/4J+AXhTp1q4ebTfiVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-01 07:58, Vlastimil Babka wrote:
> On 9/30/25 4:02 PM, Michal Hocko wrote:
>> On Fri 26-09-25 13:47:15, Mauricio Faria de Oliveira wrote:
>>>> My main question is whether this should squashed into the existing file
>>>> with a rather strange semantic of controling the file content depending
>>>> on a different file content. Instead, would it make more sense to add
>>>> two more files, one to display your requested key:value data and another
>>>> to resolve key -> stack trace?
>>>
>>> I see your point. Either way works for me, honestly.
>>> Let me justify the current way, but it's certainly OK to change it, if
>>> that is preferred.
>>>
>>> The use of option files has precedents in page_owner itself
>>> (count_threshould) and ftrace (/sys/kernel/debug/trace/options/*).
>>>
>>> The use of output files needs more code/complexity for a similar result,
>>> AFAICT (I actually started it this way, but changed it to minimize
>>> changes). 
>>> The reason is debugfs_create_bool() is more specialized/simpler to
>>> handle than debugfs_create_file().
>>>
>>> It ends up with a similar pattern in a common "__stack_print()" to avoid
>>> duplicate code (conditions on parameters to configure the output), and
>>> it adds:
>>> - 2 ops structs per file (file_operations and seq_operations, as in
>>> 'show_stacks'), for plumbing different behaviors down to different
>>> functions, to call the common function with different parameters.
>>> - It should be possible to reduce it with private fields (from
>>> debugfs_create_file(data) to seq_file.private), however, since
>>> seq_file.private is used (iterator in stack_start|next()), this needs
>>> more code: a new struct for the private field (to store the current
>>> iterator and add the new parameters).
>>>
>>> So, I went for the (IMHO) simpler and smaller implementation with option
>>> files instead of output files.
>>>
>>> Please let me know which way is preferred, and I'll send v2 with that
>>> (in addition to the changelog suggestions).
>> 
>> Sure, I see. The main problem with the option file is that it is
>> inherently suited for a single consumer which is a hard assumption to
>> make at this stage. So I think it is worth having a separate 2 files
>> which provide the missing functionality.
> 
> Agreed, we should prioritize a better userspace API over having simpler
> kernel implementation.

Just to clarify, I agree. I personally considered option files a good
userspace API for this, but later realized the different perspective
above.

> Will count_threshold apply the same to the new file that prints only
> handles? I guess it will?

Yes. The new file that prints only handles should only differ in format,
not behavior.

This is different for the file that translates handles to stacks,
though. For that, count_threshould does not apply, as a previously
reported handle may have less pages and not make it, which would not
allow it to be resolved to a stack trace.

> Also the handles to stack translation file could perhaps support
> "seeking" to a specific handle if you're interested in only a few
> handles. Perhaps not necessary though if you plan to read it all just once.

That sounds cool. For the current usecase, it only needs to read it all
just once, indeed. I'd be happy to revisit this later, if needed.

Let's see how v2 goes; sending it out.

Thanks!

-- 
Mauricio

