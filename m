Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 639A6CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B24C6B008C; Thu, 28 May 2026 05:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963556B0092; Thu, 28 May 2026 05:16:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851E16B0093; Thu, 28 May 2026 05:16:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 735E36B008C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:16:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 024694077E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:16:14 +0000 (UTC)
X-FDA: 84816272310.11.42CC71D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 38C0740011
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:16:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kjzqMZ0i;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779959773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZS5mdGBUp9CWgagmhtWPpgUc1bksbZ1JeQXfzhQg4/c=;
	b=PGdo4QWVgEpL4/HGUlfWyt5DXQ5VHnlhpHRlOl0HvMffANr07XdTrCIfmG7t1wDinWPdzo
	OAB+lzEjvl5ydB5nPmU7cWwG2LT10dTLvc0kMnS97a5Ah6NnAhCwyNWlNlqVaTXRIjbOyM
	98sxclBm9ShN2nKufAQfBxAGrP8Raus=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kjzqMZ0i;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779959773; a=rsa-sha256;
	cv=none;
	b=b4Lznbc738PkLk4tPRXdUWOR3s3HbwQ0QttO3aYIVWxPKZtnWuhQ8PE0sAuy8khNL3RUWF
	y+17NdD/XGRSILiHHUiAx9VM+QHzpl591WRUGZpvW6Izv8awkqUHlMMBVfrD86EeQ62cE8
	KY6v2K8oGjmmER2DyvDLr1Ns/hEQ8Cc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F68843F75;
	Thu, 28 May 2026 09:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9BF1F000E9;
	Thu, 28 May 2026 09:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779959772;
	bh=ZS5mdGBUp9CWgagmhtWPpgUc1bksbZ1JeQXfzhQg4/c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kjzqMZ0iYUcAMeOp1Hxvzwn3xuYHg95O5ARGQoara35a1RzQsMjBSbwiJ2K/UjBdw
	 W/YWIS1sk4MJzqYPX7OHOzqRWeK+3Oh9yS8tXK5JwtAUsAa+TfZX5LndWVGrLUbn4L
	 FJTqBsU7Ce067NcD14cVHe+6wHnmbZz0H1dgjUwt9zCg1EXGBD02o9TDqbUvJ0CtCR
	 TfC1/sfVcwFzhQzGttl6LMDERb2BPCX/jOweHkTIXtasFj19R3DoxXEyyIWm/69wVn
	 MuRF8BWDOw23MUvbeiAedX20W/xSco9SwAyaUhsMHIee5+7D0OyIAONtf4F1l+yQa8
	 ZFFhr/O5cIz6g==
Message-ID: <bc7e1123-35bd-4bc2-a6e5-39f76d9722b0@kernel.org>
Date: Thu, 28 May 2026 11:16:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: improve the kmem_cache_alloc_bulk API
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20260527070239.2252948-1-hch@lst.de>
 <ee817070-cc7a-40d5-92a4-2bd8e9e65fbe@kernel.org>
 <20260527122148.GA6838@lst.de>
 <482ee03a-c5b3-4873-a550-cc5743068616@kernel.org>
 <20260528090508.GB8376@lst.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260528090508.GB8376@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c4rqrb83jmo7bfiduko3p8mjrxhjzi4d
X-Rspamd-Queue-Id: 38C0740011
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779959773-821865
X-HE-Meta: U2FsdGVkX18WWhaJ384pZitFPIJre5B3XNgqEC1i4lQFNc/DGB8MdVq78CirfC0KoeX0FUl52HeMi4O2GMBrxKaXDfNN7gKBGZFTacTnDjYhm4M2UuNyJ754nkwyMhPVzUNhJk5VyXx6zYJotz4cirhjGD/3+1lC0h9BbP6Rfoq9pTwDFhEz5hHC9JLwq/Xf6W5FAM/A3zYyEUdAS4KrP7OvUeMINW7t+NWiROELFHz27YkTticysWph8FnlUcOzF4IAWNEL2ldDbSEeaYyIGrZhP1Vtk3prXTB/juBmHIeS7Lr8uMqIkj1XswAymSHv4b4l1GPzzlD4zXKL5YnRGUcFhqIAuhcfKKjV3D8WyyWnSZfsBb5WvRSOH7Q98L/O09RPVWnCjx4ltrrGgi8RZmnRYx4cq9lCLmOLPbkFXlOBjN4Spe2xhs7JwLlMH8HOPuh/WivdvZQFWWUupK/HA60NHLjnzw22hzmVetqHzt4G7idih9B/GSHLGxo645hjiVjqJuymDqTxoK3B4T2mZ+9nX8/UzFo9L4RGRT+RlyHovbAXWaxm0PxwrljT499IF7yCvttVXFxjo5lWBUyprLK59uuIRQTYXVCUwD5iaS7gdskSUVfovF2LWYpTd1t2ayob2clvzlmEpP7AP4RYvbRKIUGWIxAXkrhcwsDWFOY6ibE91NPB3mFnDTYJ3nLb5RIJltYFZxaoV5MNzgKk4Mo3tlNlK2UyCqssQfIZqeEM6Mg/ZY6tORb0Gr/A1Z9q0FTf4M6RL/A9evjBeFQlz44GYknGu4hDS7ypQ5wSakFnBLQjMRQWQUtRwwyB9Wm+qirwz28lERLPXS+Cbcfu77HyfNxO0+m3x/ylaf36g/AxfwYVKYkCI9LyEI3k0q/LhOzcvqwzOdQ3ShxBI2ZMTQmuPsGxY18sqOzkcZqAVtwqprmIawr2dz2uqePmphsv1EuI3Noe3oInr+NGsE6
 3FALZZkn
 xB5jeyRdSubWC/+n7DyKZlvoRt5wferBti47GuE5RoUxfctMc2NLWI6eu1435iTies2Qk8T6daa/oJZylf22QFBnKNXmc9Pvb5pdEM8mOftGlPpTlYMkGmjhc2NQO6LQHehA3rx61XKiG8I+GumzSV9obtPqkKESsf+LHpx11fPS008EAzGLbwQsCvnW3hQ1GK9etknJW0c0xRkJsEUhfJOB4R/QifBFuIHeb3KW9NS6rjPZomeTaU1ep6cpl/5cMFEy8bFiM1eAhQSVf1Z7xnZ7p3B+rEf9MlMUXy87cR4zmQbN4T1Fs39L+tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 11:05, Christoph Hellwig wrote:
> On Wed, May 27, 2026 at 04:07:12PM +0200, Vlastimil Babka (SUSE) wrote:
>> commit 46dea1744498 ("slab: refill sheaves from all nodes") from this January.
>> Previously it was just interrupts enabled.
>> 
>> > but by requiring separate functions so I somehow doubt that was meant.
>> 
>> Yeah, it's expressed by the _nolock variants. But slab propagates it internally
>> by the gfp flags, and since 46dea1744498 it affects kmem_cache_alloc_bulk().
> 
> So what are the GFP flags that affect spinning?  I can't find anything
> related to that in either Documentation/core-api/memory-allocation.rst or
> include/linux/gfp_types.h.

See gfpflags_allow_spinning(). The usage by slab and page allocator users
was meant to be via _nolock() variants, not by removing the flags when
calling the normal functions, hence it's not documented. But the abstraction
has now leaked in the kmem_cache_alloc_bulk() case, hm. I think instead of
documenting that, we should adjust the implementation in slab, if possible.
I'll try to look into that.

