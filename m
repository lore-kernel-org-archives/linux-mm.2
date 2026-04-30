Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 866DCFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 13:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C4D6B008C; Thu, 30 Apr 2026 09:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3946B0092; Thu, 30 Apr 2026 09:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B1A6B0093; Thu, 30 Apr 2026 09:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93E7C6B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:17:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FB2C12015A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:15:31 +0000 (UTC)
X-FDA: 84715268862.27.9C25A56
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A24540025
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:15:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jGYIK58b;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777554929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OStTXxZ3sXqnVM84IClp2Y9AcAptag/K56TyWWXj3A=;
	b=iH6zlofEtD1pkUJZM7KLx2HiUc/oYQElY8D75u7JGtaKgYny2431JzBoXSlMWtN347v/X2
	KBVLCkYzGQF4B6Lh7IJS36O7ov5ZZ3PStrtJyttRr4TN9wYPlQ59d9sXmnFiWXrGd6a5fo
	3PVoT2aSvHe4bQl2dEsndHf4OvHBySI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777554929; a=rsa-sha256;
	cv=none;
	b=8q2e2imNbvQ8QQsWMwlWrH0v2eZIpPxDTfSZC1w1M7bTTcnuq2Iu1utcc0+uSHnU96QIvY
	IYAwIEh2rsXXw7BvO8iONwwBAJQ65xWRH6u0dMc8HCrkZlmDLO3wAH94dqsdAd//6r2qaq
	kdhrOj0n1uwThPvjQqy7yp6RZGgzNr0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jGYIK58b;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5OStTXxZ3sXqnVM84IClp2Y9AcAptag/K56TyWWXj3A=; b=jGYIK58bhLYx15PGi+dd/fQtRZ
	SQuzzxWWZqGg233kNQ1XAojs6Jnrkp/3L+TjH6d/BsJEAi8gBxgRI6uAWd3ZP2LFNpwqI4nR4s5ld
	FVACz28JCThhfr0VsLdZMXielmghJmnuEIeAZd3ClndZrvEr1wzzopyDeNujSSQWletH+loxtdZAK
	Vh4ue6x9fhO4TjaYxV7HrFKxiV1B3Nj1jYSdPvlA3Rc139u7hQJcw02tj5/CJ5zTBCmyR+/T3rUOh
	o8+A5YJjuxNEc7GMbVSiTHsH61mCcNwxbqck3ssRvfe4y15ruubnu6tAp5/SJB8KltE3qs7X5TRlI
	3SfAfiIw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIREe-00000007GsL-0T9w;
	Thu, 30 Apr 2026 13:15:20 +0000
Date: Thu, 30 Apr 2026 14:15:19 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	lsf-pc <lsf-pc@lists.linux-foundation.org>,
	Gregory Price <gourry@gourry.net>, Bharata B Rao <bharata@amd.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [LSF/MM/BPF BoF Session] Numa-Aware Placement for Page Cache
 Pages
Message-ID: <afNV5wbhsFQJLzxi@casper.infradead.org>
References: <h5ossmwe.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h5ossmwe.ritesh.list@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2A24540025
X-Stat-Signature: eb6phdjrisd4y7itq8ix7cc4oa76598c
X-Rspam-User: 
X-HE-Tag: 1777554928-386186
X-HE-Meta: U2FsdGVkX1+jWz9mLMyM0FUCqfzGQzBI/DgHIOIbdoGcSQm4saRBgRFSHIKc6LVEPWFue4AdsrEXl+3dHgH7t+2s74ETDoGZ5jKc7bpRCOa2LHPg9a71z/elPVprM6OHds4oFjvcLY6f/BtPZcuT7PsVhZlgXZZNHpRUSMW/rMTnGPwNnAA2FAe61t7VRSd4wk+KQS+9170Te9MTaNYzwW1IlFYUII0tTdTq4ZEkh+ruEDTm1ESnD0C6Ay18yN2FoWnwokFSsWRv8Vd4OSf3fogth08Q2BsmaOaUZc+nHiZFU90iclRbjtyzVF9wZD4PNHIUl6NajK4+3LLtFdF5ok27t5ErDEfo7mddjFBtyFrdTkBX6MQXigUZq7WFXFReExDqH6jJtwVSEcGqAO0jwR57zrr8Ckz70nw0mFue6UknykXvn8sHpnq2Z8v7gC3CIaSRYuBLGEpZB3v7+4Z6KoYG00yZCBDiumNlzNMM+SrTUazAG9MdevbMBXIOEM5ji3IeT5lVGQTGDT1IvGIBfe8sTostfK7DqweT7j8pAz93+fhBdedtGqcDnF9b89TrOayl3JfSCm1a+hDbB2bLmkvQHRsHNdtMKoOK3ewAAd4G96pGXZndGQFjOW/f5YNDInmhkrboY+bo+MDMiSyusx8+qPNhrCfG/PchVDaqV+hoAS/bzs3tgR14H8RlTDil+ufBc3oC9eGukku11NbSr9XdyUhLSEtZFU2+/s6vIHWSP8yNBPCAPqCOfOPgg0haL1gD+FLOx0+19oTvVFDLF0CpMLFSNIj5jdsPGMSIDW3BzcW5dqf5NsILPyu4fwS45L91KWdxtVxR7rJm8RFHbXOBduoK+N3g4AloNfD4AQR2pv/HKb3UL1WODNTyjrl0esYJnRYCQML2PlXuTH3yTL/8V2BODDSNQyKtbgMagbewanV47xK08n39e3tkENFyj+g6Nu8bu6q2VO8yjC2
 gcQKU2RA
 YXJ3xmgLtRlM/endcuvI9fIaKaiiexabn44QWFiK/YzpHyuet2sJdqqIYtvJ35vEXuJ6uMEeQz0ETZbthdX2D5wT2nEsr740GExBoFkPp5tD4OoxZlNCrgxGTHXwicouAelpDNxXGq6HQcik74+j4D52NmylAY4MJpGODOxbz84N5UGkbN24ulePKOH6KOCIt1KxI4bDDf54F0KsYvO7KssGn6hZAKEG7Gj4t2SY5danDBrZzMtoep7Ira0ubDX8a4Wd/4CX3gCft/7vKL3Xj2h+DBq0mLcApKOY1kWvngexGJAgIQbLVRzN66wyOdLiPh730
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 05:03:37PM +0530, Ritesh Harjani (IBM) wrote:
> Linux already supports memory tiers and there are ongoing discussions around
> promotion of unmapped page cache pages, which lets kernel do the right thing
> for userspace page cache pages on a tiered system.

Well, you know my opinion of that idea ...

> So the question is:
> Do we need a userspace interface for the placement policy of page cache pages on a per file basis?

What do we do if two tasks both "know" the right NUMA placement for the
inode's data, and they disagree?

> 1. Is there a need for an interface that allows userspace to do per-fd page
>    placement and maybe per-fd page migration?

Ideally, no, the kernel should observe the task and get it right.

By the way, you're familiar with how filemap_alloc_folio_noprof()
works today, right?  I forget whether cpuset_do_page_mem_spread
is on or off by default.

> Let me know if people think that this discussion qualifies for a BoF discussion at LSFMM?
> Or do you think it's a bad idea altogether, if that is the case - Then
> please help me understand, why so?
> Before starting to jump on the implemention of any of this - I would
> like to gather feedback on what do others think?

I'm just concerned about what other session i'll have to miss to attend
this instead ;-)

