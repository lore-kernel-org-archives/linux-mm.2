Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4FE3C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C04EB6B009D; Wed, 16 Sep 2026 08:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDAEF6B009E; Wed, 16 Sep 2026 08:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19646B009F; Wed, 16 Sep 2026 08:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 92EA26B009D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:58:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15BC7A06E7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:58:44 +0000 (UTC)
X-FDA: 85219629768.09.DF395E1
Received: from mta0.migadu.com (out-59.mta0.migadu.com [91.218.175.59])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2AE8440003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:58:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iYnhF8Km;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.59 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789563522;
	b=KnI/VXQF2BqfvzeRsxECCZ473SD/n67BqDNXxiPRgbY20OoU7mL0F6JCcU0CeKNCe1ywaI
	bR7QmNOXpFli/0meoI0S3uwiFi0KgkDRkOmqOqhnqXmKjESEOAczJZ7QLspPs7I04aO58u
	8C1vbUaG0c+wgMKqjiPP9/Iv6nsy54c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iYnhF8Km;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.59 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789563522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVzD85tW0fgO21RteQQbzdHEsRsdigW4cVMseg4WEFg=;
	b=ZA3uurnfXaEaei3cPgBny2xIXM8M+8GGVIx3djn8bVd5POcJ9awsLs6yO4c0jNakSi40yw
	uOn7wh/nTAU0hWl9ZwjSRvEciKhfV7uRn8euF5o27ChV0QKEfePDzFtfTTcJoisdfQi7l2
	EML+nWLvsg86AjmZtQcaGupXg/y66zo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NqgpLka1U0uH8PVx/qAWnt0LZxjjNxyG5vubBu2izC8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789563521; v=1; x=1790168321;
 b=iYnhF8KmvZRguvgPZf84ZU8GxsIikoL3a9j1/Ou5Ps0gdAck+GnYitPMQMHdJHdHQIpYwLEO
 SxzI+CwHzNMQGQUxk8Kt2m9AxjlpGT4Zul9XFS5mdDPlY80xaOiPyaWOuOExCvQdPxflYy+plVX
 M+JrttAJcDXMheBVWPTjdkg8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b341f15ade355bd8;
	Wed, 16 Sep 2026 12:58:40 +0000
X-Mizu-Trace-ID: b341f15ade355bd8
X-Migadu-Flow: FLOW_OUT
Date: Wed, 16 Sep 2026 20:58:32 +0800
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: harry@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [RFC PATCH 0/2] mm/slub: reduce list_lock contention with slab
 parking
Message-ID: <aqqOk9ULIuV-5mQg@fedora>
References: <20260824122004.3652-1-hao.li@linux.dev>
 <a3e5581a-e039-45bb-b570-a01158b154bb@kernel.org>
 <aqPg5YRKdaZiBj9b@fedora>
 <4d9ebf64-e3b4-4b6c-9576-e8be59193f80@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d9ebf64-e3b4-4b6c-9576-e8be59193f80@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2AE8440003
X-Stat-Signature: dyo8o1j1kbd3qzy8ontsnf9igisucybq
X-HE-Tag: 1789563521-655372
X-HE-Meta: U2FsdGVkX180NfzcjjQX4aEDmZ5b6B3F+umZrAG9NWWt67LL7cleHTeOOVk90ANXY3SbitoCi1c8SP/oLoHF7IxtpTczCoc/GrordL//ouJK9n5rnE0zw+U0ih3vAhJOtbjm3EdkuUlLJiblQHt4BcR/LeytuefO5soIGHwpJk+Qc1Lnn6AC3cmu02Sr3EAMuSFGGg+RpAnBActulQ8jy5BzqIMyDY2VWGaW/fXwYuweICK9Cd+dzl+0JcGnSPR0M/MKXlQShEsXXt0NhlmRajrYZrT/+BSxFL0+Lh3LaMPA567Eg1p64sf9p+pjUNwXjph3j9cexGUcwYl6s9nF8v+0X40udUfgSsDE2qEdNPtGKUPYlHcC+iIbWoIvFGr7TWoZwbzhc5OwoViWK54DOp8YlTm3FuLrhC2Sd7Fz4/F5yywLnFEk8M1miJOYh4nBO107xtqRYB3RVDW2VyaloKuHUSGJB+5KnzRpeoVy7/Qy0enRXUq8k1Zp5qeCt2eWfZnIk38h49XfgKE/KLza8OW85AINVibGA0fDEFbjj2OjKmk/HMQLFPHDICLKD2z5fYYySkiyF6pFOk4uzFuN31QWiyOl0kAyINVhznTYysYRkXfbi9PT6ZlzUpur9LoR1rd7DYbfuU99L2ZWUsI6NBT/JcWmPe0RaGfsb2E1TuTXY//xfmGVJEHNstr2Jt1NkJCStpLOdUqoV5M5xm06E8yRVwBi2WIhTsLAnpy8RNhQEKd1Jq2o9LaZxqE/x2qXDF4k3y5KfING4fJbuyWe00Mte2aMg16cg2SOql0Tasw7ttP9FTPArkAQBn9vBVKsDF+J+G6v1qG+2M1/P5rmmsXUseK6KJ/V4v/fv2mxbLh9Nhv3I3KU6ASHqYx0m/MgpWnwy+UD3tW0e4GJEB+5b0AhCCH0NN0PujABJLoiACwDIl4Beqxdt4TPXYe5JJJT5x4gzJytaGN60avaMcH
 3ERaErmt
 AgQ9dy9z9hfTbNOmfxCEjAiNGj8cpLBxbgN8pe4l/4pmt5v9lTOdbVTUwxHWxATvGzWG+7qV3/gBrjNv44+XioEs3Zd/qBiPj5TmSzMSiiDSqcmpafgWIXKt1NN5Wa8MqoXosW1gJD6xbcebBvK8OGd1vfrS5z61OgF/94U+O+eeNB2cqV+lgQUUr3W5PBjvnkRSddqi0zHNlSogSy2IWiQdwDHjb+6yCYmYjclwG4Xm+iPs7Qqkjd63Z3T/Pv2l9UyEOVXfpkCbFuPYkgN9Jp7IUcdpkqt+nNvT89FYrjh3nvqf84NoL8d3o/pyMbtVhug+l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 09:10:22AM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/11/26 13:24, Hao Li wrote:
> > On Mon, Sep 07, 2026 at 03:44:08PM +0200, Vlastimil Babka (SUSE) wrote:
> >> On 8/24/26 14:19, Hao Li wrote:
> >> > 
> >> > Detailed data
> >> > -------------
> >> > 
> >> > metric                              before             after             delta      change
> >> > ==========================================================================================
> >> > alloc_fastpath                     155,417           168,534            13,117      +8.44%
> >> > alloc_slab                      55,679,646        26,702,510       -28,977,136     -52.04%
> >> 
> >> It's interesting that this is reduced so much. Is it because parked slabs
> >> cause more slabs to stay around for reuse, despite they are unparked
> >> immediately when trying to allocate/refill? That seems odd?
> > 
> > Yeah, it does look counter-intuitive at first glance. My understanding is that
> > the parking mechanism helps by bypassing the partial list spinlock, allowing
> > partial slabs to be parked onto the llist locklessly at any point. Because of
> > this, the refill path gets to see and reuse more partial slabs instead of
> > having to allocate fresh ones so frequently.
> 
> Hmm that's an interesting effect, surprisingly large if true. Because the
> slabs we'd be parking are transitioning from full, there would be most often
> just a single free object to reuse?

That makes sense. That said, it might be more than a single object, since
build_detached_freelist() tries to free objects from the same slab together.

Even though we "park" the parking series for now, I was still curious to
understand the underlying behavior. So I add a counter in
get_partial_node_bulk() to see how many partial slabs it can see.
(counting freed objects directly is tough, so the partial slab count gives us a
rough picture)

Interestingly, each get_partial_node_bulk() on the patched kernel saw about
3-4x more partial slabs on average compared to baseline. This suggest that the
parking mechanism can supply more allocatable objects even under lock
contention, since it can avoid waiting for list lock.

For example, in the baseline kernel, if the lock is held by an allocator, a
freer has to wait on it. Once it's released, the lock might just get grabbed by
yet another allocator, leaving the freer stuck waiting. As a result, the
partial list ends up starved of free objects.


-- 
Thanks,
Hao

