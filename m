Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 459DCCD5BD2
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 01:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828AE6B0005; Tue, 26 May 2026 21:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2276B008A; Tue, 26 May 2026 21:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679FB6B008C; Tue, 26 May 2026 21:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 500506B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 21:35:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D844116182E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:35:10 +0000 (UTC)
X-FDA: 84811481580.22.D99BF37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 14729C000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:35:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="0L/kdSWB";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779845709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PlzXhBRFlrMP151Oza2Y7Y0Le2JN2FjXR+/MOJ5XhuY=;
	b=kEY5BguSb4h3HRPgYg2HD6rM2jVVDWkXUYvy/sNP+lQERgSvYYiRnaBVyC2FNPPtcjgos7
	V+km5F8NMK3O8vusHJJL+LBwVpv7mPpVqil/MgRlRdoMVKy0k5VGZ+6zsyG9kfnpZQ+Dhf
	SPRGQjH67a2wJsZ60enr8c4xRUkAH4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779845709; a=rsa-sha256;
	cv=none;
	b=XKVuUSHxvnmhE+3BrreS1CQvHRQh5wB6ivgmOzLLEB+TmRerWrxmymVSnMQgk32bJNe5bV
	ki9YwPB+i0GZqET/tjYv5hhFglpv4r83zkycZm4obag6xVu2D6k5fauLtz6mO4FbpV823c
	nY7x02t+h2V8oLFPy+NgSQoBwTf31oQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="0L/kdSWB";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4FE1432AF;
	Wed, 27 May 2026 01:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067AE1F000E9;
	Wed, 27 May 2026 01:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779845707;
	bh=PlzXhBRFlrMP151Oza2Y7Y0Le2JN2FjXR+/MOJ5XhuY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0L/kdSWBIye/7sTOcHhl/zqbzqt8cQkGPcU+G4H0wDSLXyIdW95N0/5N0aS3x6OI1
	 uUZhWOUr239RIxYqDLFCIjWtSFfko2pgIFA394QdER4ZUdy7aZWx2jv/UnlgwDJiGr
	 sqSSNrlBN66Hrk6R2CLp5eSw1wtQvO0TqVzezJzQ=
Date: Tue, 26 May 2026 18:35:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, David
 Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens
 <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, Leno Hou
 <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao
 <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, Qi Zheng
 <qi.zheng@linux.dev>
Subject: Re: [PATCH v7 00/15] mm/mglru: improve reclaim loop and dirty folio
 handling
Message-Id: <20260526183506.ffb1bbe41043c6247557caa1@linux-foundation.org>
In-Reply-To: <agK-rkIIZlwBiMsv@linux.dev>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
	<agH7qYcyFgRzkQDB@linux.dev>
	<CAMgjq7BzQAPp8u_3-9e3ueXmRCoW=2sydok0hFM=MYL7VC1YYg@mail.gmail.com>
	<agK-rkIIZlwBiMsv@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: c4jhn4jf76gfm8nij3rtz4sn6kjrnsxu
X-Rspamd-Queue-Id: 14729C000A
X-Rspam-User: 
X-HE-Tag: 1779845708-697970
X-HE-Meta: U2FsdGVkX1/MzBVHRsxMDtP8d/Rxtyvk5HBlI5JR0uKa62HgCYHaZ/0nKqZ47/1AVXFev9S2JDwTFo2BEQUSWhh8DtKywwLxiRVxHcyfa6ONnUQJBxwq5mewMC4cqsHkofzotR6GMszUB7lMOQUBxeEiIKsmqe2Z4djePhaepSL4sLvogwhPnkvq6aqCNgfQaO5lA0CjdZKl3XKhqwmbQq2r7shtIe/JNBDoVTW8/HOgvQNAusTn6bLDASfP0uVg8/iI/CPkn4Hhl4DMsfDiVbyta0/Yxgbh7XkXk9QEranA+pW5jr79Y8DzuxsFikDRtzeY/H8t6HbUTlv8Z0bIbYuzR9XGYgPAHmJg909WC8gmjX0I7QE+JisKRu5gOP0Z2yQTlddzLiG9/KULAdTdkPXDhPrmPl183Pc3H86RtjKPf0xu2ersf+E/gipGT1R4bdBzYHZJs6NfHT6z91cXZSd4hRL7FgTODSgdi36ASM7bioIHZqtyqG09zE34dkIhcdKosv9TPY5wxUI5ymSFK4F3lWrojOy51ZPWWTkgnugkU7YtXIMqY41aWgPDviMte8TfU5nEmfI8clCvO8oLaoTLqlEAeTcuYK02nWlqkj2sas5kfJpdiBb0chd7H40JNDGo65hpRd5ugJBj9o6H/mgwzPKYz6BHbyiXF2HZetKiilEKsNuxQfUtpeWB7E8pbSxAhnPrVtzmyo0YIzYzAsZqRylhRzZRC4KsEJNkfKKEwCXmbB7uhqiSPQxMTH9DwkNskgtckJGbd5rzxUlY2axaNlwhNMvJeNBU9aKCwHTUoRn7OtMu+Mm4PM42GORya9vg26fkgT+Gzf1b5gJR3utIWg5oBdF53j8F30TtZQg9Zhsv8+Oh493CLQxIVR0ktar5sJWzmL7U5pgJbhGsqG0S5Hw5ZgmsL+brTnnA3O/sF7FeCaM1u0l06UwxHzWrGx3mypbK8C8xMF6U9hl
 TfW9R2VQ
 ZKW6/0UpMJ5CXrvOGQYZpvO41VDTF6yG/pbUH+nzOUzE4HwAnYm0NKeuIuhlP7MyBGs4Hwed15ZuqpIkCc74h4RZ2CseVpuZNacon5c7rSZzz7sHbENtWuhHE7ioOEyE/Y31kNiLxrT9czHLGJ/tn77TLz9B1zbGNeT1Xg9sIOVRmkQbhYlf6253uau8h2NX9LzcOlVXQCaAxMVJNvg1sloDnchHxDF+8/LG0HLrlFJAb5o7B7LzVJEovT4U+ezvB/S7VT8st/xNt42ceci/1y2dd01DKWbQF/k40kvC1Uv5uSCVccq2L4Mzr8uD+xyxwYSIn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 May 2026 22:56:21 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> > > Please include traditional LRU results for all of the following experiments as
> > > well (where it makes sense).
> > 
> > Sure, I've spawn a few test instances, was busy travelling last week.
> > That specific test machine is occupied so it might take a while.
> > 
> > A systematic test run takes roughly one or two days to complete for
> > one kernel version or config, e.g. the JS test takes at least 2 hours
> > to finish. Comparing versions/setups takes more time.
> > 
> 
> No worries, we have couple of weeks before the next merge window, so no urgency.

Well, no, not really.  Some schmuck wants to get our
stable-non-rebasing branch into upstreamable shape well before the next
merge window.

This series was issued a month ago!

Sorry to crack the whip, but let's please all be aware or our
upstreaming timing.

> I will go through the series in depth, hopefully there will not be a need for
> next version and in that case, please just resend the cover letter with the
> information you provided below and don't worry about the length of the cover
> letter.

That's a plan.

Happily, MGRLU changes are well-isolated so I was able to trivially
move this series to the tail of mm-unstable.

It isn't a problem at all for me to defer this until the next cycle -
please let me know.

I'd like to know this as early as possible so I can hide the series
until after -rc1.  We shouldn't have "not for next merge window"
material in there possibly invalidating our ongoing testing.

