Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3905AC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F4596B008A; Fri, 18 Sep 2026 11:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4BC6B008C; Fri, 18 Sep 2026 11:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BAFB6B0092; Fri, 18 Sep 2026 11:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC8C36B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:06:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C08A1606A4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:06:36 +0000 (UTC)
X-FDA: 85227209592.29.1A8E3D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9386C18000E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:06:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1ZbxweF;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789743994;
	b=fCiPsYt2iiqwFsNtOraSVBGV5qJgQ4eo2aBH0Y5VV1LBeRtSHXsP9Lk5kPUItM9Kt1aXyj
	MWmD8VC3lrIFylEhNT1ormgefDvfD7fo2lMKG3O4tJpIJFHGJ0qW4Gs9gFhsExqnEe7MJ8
	bodxcwlW+0rb2QD2esoaibFPD38/Ezs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1ZbxweF;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789743994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9cktvIVfrWuCcGGi89dQHWVm/YZCSacNyQ6KdAlOEA=;
	b=ylwpEKUm2KaiIO+eXbzrC/VWbXy7UCbXudK7tfSFm44gxvuqLvf5LV9bF7U3dwxi/CLo4g
	fpswWSFgkC91ow+iGk2BDs4TFR9uER0/HhPN1Obg3SbnNPNAcFpUaiUInrskcZ/QdOSSXS
	S+cqzitefCGjAzk3EIGjS134rQ1nCDI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C90643900;
	Fri, 18 Sep 2026 15:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930451F000FF;
	Fri, 18 Sep 2026 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789743993;
	bh=p9cktvIVfrWuCcGGi89dQHWVm/YZCSacNyQ6KdAlOEA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d1ZbxweFS+tO6FC/DrHAuY6SY/g1m/h0JdmsPGXjGlJzavJ5MIa+Hl8Rr2b6exhXS
	 CcMWVNtt4f+mNWp9grLhfX+DIAXKkpKMLWcWBZnKL1nEuxCQQw4bqo0HCYtfBLLWKc
	 HVJTybDRthcujELXlekp6wclJQk0x3Avx96fTHbbGHtjExItsWNkkya8XFvehNJgaH
	 ++pSwtcqM9w6z7kbhkITwYkp0MfIcjZxBli2VDySWX7wnA3chJcq2QKsbMUxdwBx/C
	 mi/1LfJMvauGhwbWd/68kb9rTwmsyBPNAKkfirDY6KiWJN/OEY6Jcu6aICL/sS96gn
	 ih3fUCFqwkDtg==
Date: Fri, 18 Sep 2026 16:06:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, david@kernel.org, 
	surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, 
	ziy@nvidia.com, liam@infradead.org, rppt@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, zhaonanzhe@xiaomi.com, 
	lipengfei28@xiaomi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: Re: [RFC PATCH 0/4] mm: compaction: mTHP-friendly memory compaction
Message-ID: <aq1SrcniIRU-8f2W@gremlin>
References: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9386C18000E
X-Stat-Signature: w1s4iei3z5fmc7mggwtys7jhmh6ms5d7
X-HE-Tag: 1789743994-545895
X-HE-Meta: U2FsdGVkX18AfCf275QRWQNhs/ajpGUoR+bI5n6JJdvoBrYr5yi+lsIO9mM43d1cRIML54s4KOnSUuLOjVmyxowq1l1f6nUPm2QXhLbh8JvUgKU4QOukXsvjhM16YixZaAw7yIQp1WFdYl+ErWSnNGXBSYLW818QbRNRgPshsOXiEqJRLSLqyukzIu6AcUNFo0sI4ZBsyGxJ+WZo2NUgbKbttFAb1cpmbD/zr4Rr47qP4VG5m0+eAg6XNnwGfmdGV5ctx2yMPpC9NQiS4x6nC3b6aGDvcp+jgiFhqqLjnMF7W26gu8jIz2+eKPDpp9xGnBhegYJYi61PG/Lg08hzAghSCBxbWp9/oknt/Xs325DnTcgQjlzpWfu6ODqoCvsRCWwcHUggeyLik9L0TVL4olsR7LrvMS3c5jbgECqQn4EnPwI4ky4zIvGu0EQbQS7BQ8WtGDbqy6twZ5XmwB+KLqfQqsk5r4/+VR5Hz8oJjtrVrGoZVt6JSxKRNR+NUh4bneUqYAyDHWssVuo7LztHGRg0CUJahuJTOe81AbUZREVs4JzLR+M3lstB6GmIXcr7Jt7YV8L1XI0o9Z3oZcvR71dwqWmTKSsMe7m88OauxAtPq5nXlKqoKsv2OH1xu7T4fLPKZpPM7DvY3V3SH7BL2xaE0spryNururBMwROemSPulod2I7Pa6cogq5phfmd6un497D+mhs9kEXMTgrnSmSkOiDbBHHi5o2OVLT++6HoDIT92leZYrsEp/S7jZ0ye+pB85J97WIfDdCS9dYVWtGVso5OC5ZDNj1yfQvrDUMiX3EHSLVmnnZV4Jd4FFVBofHilYJPbAq148IljeGIjOoA5jYmvpZ73EgtDZ7yQTXHarYhs2Fw7DBEtHG528jKLCA8/QBbopRiM3x8CvE0MvYZ6r26vty08OqBzzV3EmLDDoY9dBamL22lfjl/1rL7kJI87ENq2zfS4zsNCmtF
 mY57W2YX
 /IbM2YKUFhZlgP9U8ilb6v6RdOtaSa5cuXH/qewlX0eiKzz3tdHaJ1y9skC81876hmin+zoLq2va+gNO931uSI7ySR8Ugc4qvmtaGITQA7bn1LV8TwUjfNCoaKr41nICmK+gIQcaHYXoFwVnvNqBHCIWCfkNlBvI6VBIBu0sFgthVJLsJxzXA33GH7mQp7oWZFgTr9W9zUwrSSnRpTyhynrZeV/A2DM3JgLTU+2yG65J/dFGuNPV4ja6KzPB+89937PutBNtIbfayXdUKhHT1igtXZ89zFE4+z1AypPTsmVIxF1iVcmkZ8bKavT8D1jw9LUjttsB2YPT+daY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is the friendly patch-bot of Lorenzo Stoakes.

You have sent him a patch/series that has triggered this response.

He used to manually respond to these common problems, but in order to save
his sanity (he kept writing the same thing over and over, yet to different
people), I was created.

Hopefully you will not take offence and will fix the problem in your patch
and resubmit it so that it can be accepted into the Linux kernel tree.

When sending emails to mm:

For one of several possible reasons this mail has triggered an AI
detector script.

Note that, while we are fine with AI assistance, it is kernel
policy that you must disclose this with an Assisted-by tag like:

Assisted-by: LLM

See https://docs.kernel.org/process/coding-assistants.html

It is also kernel policy that you must fully understand and take
responsibility for every patch that you send.

See https://docs.kernel.org/process/generated-content.html most
notably:

        If tools permit you to generate a contribution automatically, expect
        additional scrutiny in proportion to how much of it was generated.

        As with the output of any tooling, the result may be incorrect or
        inappropriate. You are expected to understand and to be able to
        defend everything you submit. If you are unable to do so, then do
        not submit the resulting changes.

        If you do so anyway, maintainers are entitled to reject your series
        without detailed review.

In general, if you are a newcomer to mm, we expect you to do smaller work
before moving on to larger changes, so you build understanding of both the
technical aspects of mm and how we do things.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Lorenzo will reply once he has dug out from the pending patches received
from other developers.

thanks,

Lorenzo's patch email bot

[ Idea shamelessly stolen from greg-kh ]

-- 
Cheers, Lorenzo

