Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D03CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE88A8E00C4; Mon,  3 Nov 2025 13:53:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D981D8E00C2; Mon,  3 Nov 2025 13:53:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5FF8E00C4; Mon,  3 Nov 2025 13:53:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBB298E00C2
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:53:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7EE7B1402A1
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:53:44 +0000 (UTC)
X-FDA: 84070194768.22.E14F959
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9E5F14000C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:53:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sH8pxKgG;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762196022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+p1cc2kpsSMEbK2OBmytvAkUeoOuIjYdZDJv5zJiQs=;
	b=M9cYsmX8xmw6qkcT/wcG0DWhpLJWVfQCjaeF0xmfymhhhzPDrYjYUMC8MmthDLCuzoCtTN
	PqEMNCPJNbg3M9eQr4zEgP5gZE2kKw8hrJLRfMMmEnrfiP2Z5EJ9+5K2VUO5yid+CD9mq7
	ZUbYOghM6n0Q8Jkk7X2BdA0XjcKtEIQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sH8pxKgG;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762196022; a=rsa-sha256;
	cv=none;
	b=xCDBDUcw7V+vQlFj/014ETxMaJeZW8KIS+rmNjfGvqRJNddzn1zfFce7b7wdGL5GXDJQDi
	UubDhHc4E9t45N8AB9rfoSSkgq6/OW8UMyeB9g5DO6HW39Xu3l40E4Jx90cstMQzXzySQH
	QBVUuo2FG+r2WIyD+/ma5CRwBjiC2Io=
Date: Mon, 3 Nov 2025 10:53:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762196020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m+p1cc2kpsSMEbK2OBmytvAkUeoOuIjYdZDJv5zJiQs=;
	b=sH8pxKgGau2JN3Dp0CKtjA+cZMtGdONn4EOlcLNyISiaWnG4rGH1hmAMbyj2rtnendAaOl
	IyZapzwUhzw22+5pIFUtguHrorx9FvGQBOGwBPx8436eIVuAaqsbjPUTTku+5qKMKk0tYD
	5VAdmQasYHaPwfcvgwgVR1CrXGufV/k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>, libaokun@huaweicloud.com, 
	linux-mm@kvack.org, akpm@linux-foundation.org, surenb@google.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, jack@suse.cz, 
	yi.zhang@huawei.com, yangerkun@huawei.com, libaokun1@huawei.com
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Message-ID: <24zb7flklxpwhy7isj32x47gemcto3x2qg4bc3dx3tavjcf4nz@2xyn6sbxbmvm>
References: <aQRkTKTm08lSJZZi@tiehlicka>
 <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
 <aQTHMI3t5mNXp0M1@casper.infradead.org>
 <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
 <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
 <aQTb0NdyN3tU50ss@casper.infradead.org>
 <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
 <aQTqELGGKCN3JTIm@casper.infradead.org>
 <aQhf5LJJMlvT-rrE@tiehlicka>
 <9d5790f0-4a07-4cca-9f94-de101084a7e6@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d5790f0-4a07-4cca-9f94-de101084a7e6@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9E5F14000C
X-Stat-Signature: w3cfxwyc3okt4144ummkdoxuc3gfftxi
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762196022-11659
X-HE-Meta: U2FsdGVkX188mgcLuKqcNprQ86Ndl9Bk76jS01uMK1bZg9eU9mFxvteI7aFGg3tJ1ZPQVkcxtHHUNwqFUAVoODSye52WEMSx9EzMq7BcfpW5MeTmOGKWeA9QCDSpLAsPUj1JTJyjAvhsPPga9JUoba+51ChOxp9C8eISzv9fiAApqX3HbUW3/tq3Sn035NPXugklAwkpQMMz2PdvqG30IzQnqpC3nGf4gj2GLoozYnxbpP+S91uajfTQBoAZzerF0IELo/2Whe4l6BywuNtAiRBWp0ajid5E0y0VTFNmzXbquAMopAnwClBDNA7fImi52iXesU7ldRH7YxsZVlozuvo/LbFCXwZeDbOIe/qc6tbnHlUFLu36tRJ1KHRpWHk8eMbozwR4UsTlUPO5JaNDDx3Dgw5LbzgwAxyEfjw9kS+LMleQHduVjVXInCnVOdPnixtPVNOP4FlaHCOlJIGsHGz7uSDmhp8DQhKfc1ORpXYr3oaBOhQVtaDgguyps+Urb52bodhC+kBRy1BgemVIC17l9LGUUnVIF5FBE5FO2RnRr3VxKxRtQ/O79ghTa4lwZGLhA21tpPBloezwpzgdAzs3eoHfE2Zj70tN6REheD8pSc3PNaZvWgEi+B1qgIbpRdHnALnHFoGbZeiQ90yRAbbYLMCdg7ydlCcAShvVxBNWvGj0tRYSaSiCjMzscntt6waRSvtn+e/Ft3PxHhMIREh9S5HZNAERdoYJ8WfcH/KjS/FlhBjxJhQj70so6ULTlN3YUIEwzK80jye6mlG0VXTk3zn+YwwrXYJJub2pfbD1V6Y2Kj/G1XxFUSDzRVW+dDGTNGbtoh3CL73q+wexdDWPnbZjmw30yXZNjQSQGQI55JXJjmutWWw/5+WE95ReWRpwC2dFWdQNZJAKhmXa1ptT5NarFzOldGKHHx1HL8E5Ol8TOVCOyU6FZ1wrbVWzQ/Og9r4Hwu930cDsix3
 s8f/+E+H
 EPBDt5erO3pORSIfjF81+xSHgq73t45stKv0JATm4GSRlwzNa3MmBVPmdApLjD2bzcdLsOAOfIxYq1grEP4za/dquaNfnH0e66sMN6S+IIrKNtk/y9Nz5dWNLs8T/Sr7vCv//UIsb2u3ZyrK2iJA1V0SgOuk5xYw8m4f1KN78PTQnytc0JW1s35Qh0S8hhIvq26/HiXKvIL/AB1GKWQdfk87Mvb0pYIOhBvtNXObgb/IujxKIGbI7SgV63lJY+n/nWJ8a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 10:01:54AM +0100, Vlastimil Babka wrote:
> On 11/3/25 08:55, Michal Hocko wrote:
> > On Fri 31-10-25 16:55:44, Matthew Wilcox wrote:
> >> On Fri, Oct 31, 2025 at 09:46:17AM -0700, Shakeel Butt wrote:
> >> > Now for the interface to allow NOFS+NOFAIL+higher_order, I think a new
> >> > (FS specific) gfp is fine but will require some maintenance to avoid
> >> > abuse.
> >> 
> >> I don't think a new GFP flag is the answer.  GFP_TRUST_ME_BRO just
> >> doesn't feel right.
> > 
> > Yeah, as usual a new gfp flag seems convenient except history has taught 
> > us this rarely works.

Point taken and let me discuss below if any interface for such
allocation requeat makes sense or not.

> > 
> >> > I am more interested in how to codify "you can reclaim one I've already
> >> > allocated". I have a different scenario where network stack keep
> >> > stealing memory from direct reclaimers and keeping them in reclaim for
> >> > long time. If we have some mechanism to allow reclaimers to get the
> >> > memory they have reclaimed (at least for some cases), I think that can
> >> > be used in both cases.
> >> 
> >> The only thing that comes to mind is putting pages freed by reclaim on
> >> a list in task_struct instead of sending them back to the allocator.
> >> Then the task can allocate from there and free up anything else it's
> >> reclaimed at some later point.  I don't think this is a good idea,
> >> but it's the only idea that comes to mind.
> > 
> > I have played with that idea years ago. Mostly to deal with direct
> > reclaim unfairness when some reclaimers were doing a lot of work on
> > behalf of everybody else. IIRC I have hit into different problems, like
> > reclaim throttling and over-reclaim.
> 
> Btw, meanwhile we got this implemented in compaction, see
> compaction_capture(). As the hook is in __free_one_page() it should now be
> straightforward to arm it also for direct reclaim of e.g. __GFP_NOFAIL
> costly order allocations. It probably wouldn't make sense for non-costly
> orders because they are freed to the pcplists and we wouldn't want to make
> those more expensive by adding the hook there too.
> 
> It's likely the hook in compaction already helps such allocations. But if
> you expect the order-4 pages reclaim to be common thanks to the large
> blocks, it could maybe help if capture was done in reclaim too.

Thanks for the pointer, I didn't know about this mechanism. I think we
can expand the scope of this mechanism to whole __alloc_pages_slowpath()
which calls both reclaim and compaction. Currently free hook is only
triggered when compaction causes free but with larger scope reclaim can
trigger it as well. Now there are couple of open questions:

1. Should we differentiate and prioritize between different allocators?
   That is allocators with NOFS+NOFAIL get preference as they might be
   holding locks and might be impacting concurrent allocators or maybe
   prefer allocators which will release memory in near future.

2. At the moment, we do expect allocators in slow path to work for the
   betterment of the whole system. So, should we use this mechanism in
   not the first (or couple of) iterations of slowpath but during later
   iterations.

3. This mechanism still does not capture "reclaim from me" which was
   Willy's original point. "Reclaim from me" seems more involved as I
   can see reclaim in general prefers to reclaim cold memory. In
   addition there are memcg protections (low/min). So, reclaim
   algo/heuristics may decide you are not reclaimable. Not sure if it is
   still worth trying the "reclaim from me" option.

Anyways at the moment I think if we go with this mechanism, we might
really need an explicit interface. We may in future if we try to be more
fancy.

thanks,
Shakeel

