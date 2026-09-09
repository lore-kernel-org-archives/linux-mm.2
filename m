Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08411C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F6B86B008C; Wed,  9 Sep 2026 14:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A87D6B009D; Wed,  9 Sep 2026 14:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8E36B009E; Wed,  9 Sep 2026 14:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D29FF6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:34:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65C31402F4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:34:07 +0000 (UTC)
X-FDA: 85195073334.17.2EB20C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id ADA8080005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:34:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LfsGv/jI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LfsGv/jI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788978845;
	b=xpjrH7I2YN04DW/YSeymKKK8ZUU/bnYCzEr/XjN5ULy42ncuWaZOkq4gSgAJv5sB8rJiSA
	gaWZkFLcmHChxdIhfdvL8zLXpPNefiufxe8UT1zp/2csi6s4bW+s0TwyMuUVQewsZD5FpJ
	YJjAxZtyn1Iab4lu7gDRXtrAlfMiGnY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788978845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycUBO2JELs2fyXN0c+TiX7BOpgFS+f5iaTaMr/XArow=;
	b=mcths1kDTZpXIIAHsqhu+KnB9vcA+BElbRoCODTeGy8Emh0JWc3PF2psKUrFK2QL1asEwQ
	kkzMSXDeMrp06AFC089MJ2jFbwYp1SIx/NbX1qd0yCe10EwKM8FhOr6eZUGVsfP++IaZLu
	sIh0GG6v2lrElIiKPcuG8VXjE4lW26w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9CD943674;
	Wed,  9 Sep 2026 18:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D481F000FF;
	Wed,  9 Sep 2026 18:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788978844;
	bh=ycUBO2JELs2fyXN0c+TiX7BOpgFS+f5iaTaMr/XArow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LfsGv/jIKlqGMGSQAnveeZtabZKMDxdjFdRRCMyG2srtGbX1SzK9q0lYxJX1/KWdL
	 8xQPT/1iez8J9wES7U/22jicz85h+JRc1LLzBaOT+XOqJ3pttR0BEdtAMhzxAySFm/
	 C2ZDfgO3OrbSdBYhTb5hqvIOmeOcJDjDuHlhxa/xgtMnyt5ovscwtU367QIZ8CGO0p
	 1ljSVEja7i8RdYu754Zsha/Nn4tlX/JMH9FGdtSkjXu0EW49uTORl0Qjl1zqtZr/M6
	 V7Qloc6tBlviXS6M/2ejzK81QyBceZVQiUiUkghFfFR5g+SFfY/YA4m18a0o4vb5I+
	 E7MF0TSv3coQA==
Date: Wed, 9 Sep 2026 08:34:03 -1000
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Julian Sun <sunjunchao@bytedance.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk
Subject: Re: [PATCH v3] writeback, memcg: skip foreign dirty tracking for
 bdev inodes
Message-ID: <aqGmmw3rv_2f5Jk4@slm.duckdns.org>
References: <20260909034343.340703-1-sunjunchao@bytedance.com>
 <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
X-Rspam-User: 
X-Rspamd-Queue-Id: ADA8080005
X-Stat-Signature: djnwbhxjzutwb5xg3c97b7zc147md5h1
X-Rspamd-Server: rspam01
X-HE-Tag: 1788978845-288084
X-HE-Meta: U2FsdGVkX1+9uhfwEKTJq0LlqpgeKDzrR07qDp8JeHCQ/XH+SY4bfkrs7sb2m9OIFqF3Gxw4eavzU19PmX8jOg0OIkm3be7Lkm8Fmyj80P2CwK56MROM4BWX+YfXPLpVT+svUDXujVQmMyQM6952iEdpwrYHKQU6TZBe72KmhBgbwqU5XcW/zrtS9M67UUURDr68EG1L02XiwB/pyvC+L+Mnkq2qsukHGL2OyT4gKMplzg6kVIbN9p3MJbIC6q+kjQoSqn4YX22EbjDxXLP4w1K7PURp5yS2muT3p0G242+0DNMSj1qB0Z70damotA9YS8QQwtXsCFu96oa3uIeabunWR+ZrS9fqvLR01iFdNk/4J75XtGJoiBRZyAz1n0t+a6MIkwKWqi4yR8UhnD83kmxhgsDy3wU2BIISFXoO4B9DqIb3LWQ1xvAuRtHcKr8lWBjs8bjBOIR4N1qrBH5hJzpk4kE/tCc1mOjEFJIc3JRsCTFBEm4f9T+Hj92mxSmmS3dGfemTeNeUEbBLcU7MQqN6WWoGLIQR9XvqX7giZILZ2B9rvl3c+FjNm7/OiBJzFc38UToVFvS6IgxB1WqBhIQ7I4f0BdVVCN/cCMzlr69OrvVYPseVYe0+YB1o15B2vWWzMalwwyrVoUPPkXHr6w+kXvbb8nS9fnUYgK5VTWtgovn7Hkkq55J2eSdPgSyDlv9Q0OJvaTaRC3yrGCdpresDQpxlcjOlzJTxst05JbNSLMtJ9mHZuR2A8QsI4U4XjqCumci/eKOS6mPXsHkg23VPo8SKVVybMBAHeKkjCCidkdghkhzonuJv3tPgdNHvvZCAWxQw4dUcU4ctM4GFEEEhwxrw2uY4QI1koZQdqnItLWj14Zxq6lc2BKr/fXHWkzGCpFOWo3VHUt0WFSkcU3R2QL+AbTk/FnO8Lcg1bUMvZLGmvv94HHKYotv4/jeNMjr5nXCxa7i3Hw71h1G
 Ttc6e+TY
 7hD5bu2UIhl+s8MxFdTFkqK6XXnFTXNfhU88ejWnP+BC0GZWbjhGttKJuz2SwTRmw2dLgaemvEF1QQhIqjmYcfzL++bDPslfIx1la2Yot/xYcCds6vZgNCTwnanxj7qk+ep6B9qjvR4DHPS2MdrAKjkAmL8vpLrhQ41ciuGcnk6eDUGkcYMlochgOKYMACleKprutKtGk/Abh+Iu1SDJ1le93b9CxhnMwkBdGLvhfcZXC7CIG7CCqcrecXUPoMrTIPpHZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Sep 09, 2026 at 01:03:27PM +0200, Jan Kara wrote:
> On Wed 09-09-26 11:43:43, Julian Sun wrote:
> > The expectation in wbc_detach_inode() that "concurrent write sharing of an
> > inode is expected to be very rare" does not hold for bdev inodes. On ext4,
> > metadata from many memcgs shares the same bdev inode, so dirty throttling
> > in those memcgs can repeatedly trigger foreign flushes of the owner wb.
> > These flushes can also write ordinary file data, reducing overwrite
> > coalescing under continuous buffered overwrites. The resulting extra I/O
> > leaves less device bandwidth for other workloads.
> 
> Hum. Are you aware of [1]? The guy is from the same company so I was
> assuming you two are working together on the problem :). 
> 
> [1] https://lore.kernel.org/all/cover.1788836830.git.yinxin.x@bytedance.com
> 
> > Skip foreign dirty tracking for bdev inodes. Ordinary writeback and
> > foreign dirty tracking for non-bdev inodes are unchanged.
> 
> Frankly, I'm not yet convinced this is worth the risk of regressions. The
> gains are nice but both the winning and the loosing loads are synthetic and
> none of them is like "this is definitely what most people are going to
> hit".
> 
> I think what [1] is proposing is more in the direction where we might go
> (although the second patch in its current form isn't acceptable to me
> either). But what I miss from both your approaches is the verification that
> the change actually helps your *production* workloads. Unless it is an
> obvious fix (like was the case of patch 1 in the series [1]) I'm very
> reluctant to approve any additional heuristics unless it is proven they
> actually help production loads. These heuristics are never going to be
> perfect so you can always come up with a synthetic load breaking it in one
> way or another. The art is in tuning them so they work for the practical
> cases :)

The original design's assumption was that a single inode being actively
written into by multiple cgroups would be rare and rather silly and all we
need to do when that happens is being able to limp along. So, the trade-offs
were made in favor of lower overhead for the common cases where there can be
a huge number of active inodes. This mostly worked out for normal files.

Here, the situation is very different. The sharing isn't silly and there are
only a handful of these inodes. If this is an actual problem, I don't think
it can be solved by slewing the existing mechanism one way or another. Maybe
it will make some scenarios better but it will worsen others. The existing
mechanism simply doesn't have enough knoweldge to make sensible decisions.

Given that, if this is a real problem, I think the right solution likely is
tracking more states for these cases so that it can actually make sensible
decisions rather than trying to guess blindly.

Thanks.

-- 
tejun

