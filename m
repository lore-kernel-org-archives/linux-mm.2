Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EBD2C44520
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 01:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172D26B0116; Fri, 17 Jul 2026 21:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1240D6B0117; Fri, 17 Jul 2026 21:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039936B0118; Fri, 17 Jul 2026 21:16:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4D5F6B0116
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:16:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6204F1A02EB
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:16:44 +0000 (UTC)
X-FDA: 85000132728.06.756C8EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CF12F180005
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:16:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTm0b95q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784337402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48yTB0Lmrlpk8mR2lJ0g6c6+HUj48QmCvaO5G2InBZY=;
	b=Um9q21RvDHMVcF15Rz7rsQjXOrpbpU7Q3hI/af/G6DdK4gWmez2zu3/ehUYAne2c+jlGLc
	ZXFSID610WqUqNHqFkx/cGrZ/gn/rjxxSC+Else1XOSOqsKnJUwleH9pqvg0MM3QVcbuWJ
	DMbE8BHYn6cJEfgaFlYBxBLKDYlkPu0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTm0b95q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784337402;
	b=XRe8m+SM0e66xUfgrZ944tf2uACKDbb7BE0fDfgaelcAnKgE5j41UTST38ZKHwxyw+eYLn
	kNGrO353JfPp9hO6/J6KoGXGTr2zFgKFBZetvLg5BCFBWeFFYV9JwcbUZ68I9kMgJWO74z
	uZZy4/SXZJyKfcGnA3CDR5ZEdJ3Quy0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C63460A7F;
	Sat, 18 Jul 2026 01:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CCE1F00A3A;
	Sat, 18 Jul 2026 01:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784337402;
	bh=48yTB0Lmrlpk8mR2lJ0g6c6+HUj48QmCvaO5G2InBZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTm0b95qgrff+QxYQfesDPwKrrL3LF3vu3i5qbdg3GgNN5ixfYjsTPZ7bC+Uu9Jjl
	 ex84bPnshtoXqo/05QEzk42b9UCM4g+JX6C3lvBV1AeIwG8B7pflym4wCUF0DOBQkc
	 j8LcG+sklUYJ6v3qnwIkZWJM6VYZ051BddzuzKjGVQPWbf+RmQS/zvJcMttMeJyHVo
	 psdeX80RhJcBO7i93RIsZAG1OfAeE4C2uiPMSRs6iyt4XixqiNVzE4ZTUFOlt863xp
	 FEStjzTBRyEl8oeYSr47E8VOFH1XRqNypGOrJQt7SOTwS5i24EP2mknqueMLxLPnCu
	 q/v/ycrABYj2A==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/core: handle region split failure in apply_min_nr_regions()
Date: Fri, 17 Jul 2026 18:16:34 -0700
Message-ID: <20260718011634.94132-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718010312.90397-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CF12F180005
X-Stat-Signature: jcphe37b7hsgb8xjxgztxy9xr9zbkqxt
X-HE-Tag: 1784337402-349759
X-HE-Meta: U2FsdGVkX18qBkmJ+j3gfydualMRxVD6ct46W9dMrrTIVTke7KkQL6XNVvIXAtDxWgESle2+z1d9lwQIra3rt9vFo7uomdipMJc45aIQ1+dQtlIpfDFxqmUyBWqtks1nNRqRfZunk4OuUDlMmYk+KXSPSCjlvs6WGr4tRyQ0emNfGtOIizuht7c1sKkhGiVzuXS9YYpbleWmnTJ3PvckvY8L/p1xKhYO8Jdt9KUX4D4NuMa+i5ktf3m873YF75VRIL7tj9hpPBKENRIxT7KSUmMIP8GjQf/BBqtcUVwSzMSgjUE0ZTV4Nh+Vfx+5AW+iJC9eZDyxhUR/YUIsRbX8P1C6+P8gsgJoPqwx/XGDRm2gB4rnJakg3AWMMzFFQ/dW/mJn70Oakv0ua+wm3pjGurAjqXn56nAtEK3KfHr14C2egDWSyBvtu1zC8pLrcgukc2hEZj8ETfcOytyow6in8XNabUvz1z68R7SgQonWSJLdqlIOCT7MskLQdLV251Xee3W+VZGu6zb9jUdifnm4Zb0WqdXzTky3B6PA4j55SwRMY8RpGZF3Uv78FNO2hjV9VYNEAArqyUT2yqeV+07YrCx3U055Db8pR+2Elyi/c8YxHXn+nlorQMfbI6j3TeM41PFv00pBGHM42MwWAO3Wj8/QjG91hCr4r3ivu+bWOWMz2HVl4QcU5SM52MBj2Ix70/xLYb5pf4ilyUVy/DYUINT6EmGJAhHQAwR0PB0ayJ8eBt2CnsRpSPvb0g9D4UBZYqT8/nS5UGrDg3pmnhKcEKFl/0OKn3KoM/nSbH7+lqWGq6ASR1F2qbGH9dLLMYpZcZO9+vp7mQHDaiGQ6/PrYCI6OaX6dcEVErsTi0XLqA2Wtas2baJcOtq273k6bAWZ0gYuyDGXaxLEIxsMvxAJHZvi7N85X82qhde4u+A56iAsiq9rsZyV6IqxTAVSs/ouwOzd1aQWKRYZwH9gHTS
 5zvjrEc/
 GOa4WFk+PlucDqhkAGUpLmZxJmtB7WxFiwPhNZo5Ru2WpeKFqi1Yo7gY4Ax++4Ouv0jDKfJIsMDkO+mpksEkff2d+jhG0CoveakECc9N7ppkKqlwlpMHTViq7IhE1xg+ODyeERuP5lQMRHaTp5dxYH89CiVAnD7uWPw67swhK6XSHeolvyp193391Baar+4er3r5GTE+ajf1wBSoeiQtvYVqSl73/k6hSAlwVu+YD6dCcNNHJ007+ZAYJzqOS9OX+SIZeEpNnNPGd18ZTX1uQCJmS0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 18:03:12 -0700 SJ Park <sj@kernel.org> wrote:

> On Fri, 17 Jul 2026 17:43:00 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > damon_apply_min_nr_regions() repeatedly split each region until its size
> > becomes small enough to meet the user-defined low limit of the number of
> > regions.  The loop assumes the split operation (damon_split_region_at())
> > will always succeed and create the new region.  But the operation could
> > silently fail for memory allocation failures, for example.  If such
> > failure happens and the region was the last region, the linked
> > list-based next region fetching returns invalid pointer.  As a result,
> > invalid memory dereference and corruption could happen.  Fix by breaking
> > the loop in the corner case.
> 
> Sashiko found no blocker for this series.  Sashiko sent findings to damon@
> mailing list [1], and I replied to all the comments.  Please read those for
> details.

My intention was to add this reply to other mail[1] but I only mistakenly
replied here.

This is true, though.  Sashiko found no issue in this patch.  But that means
nothing since this is an RFC.  I will repost this patch after dropping the RFC
and rebasing to latest mm-new, tomorrow.

[1] https://lore.kernel.org/20260718011322.94001-1-sj@kernel.org

> 
> [1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

