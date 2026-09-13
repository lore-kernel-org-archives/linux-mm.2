Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81DCCC88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 16:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B8A6B0093; Sun, 13 Sep 2026 12:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C956B0095; Sun, 13 Sep 2026 12:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531E36B0096; Sun, 13 Sep 2026 12:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30FD86B0093
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 12:20:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AF33807F8
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:20:56 +0000 (UTC)
X-FDA: 85209252912.09.A47E024
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A3C651C0006
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:20:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oaZICN6v;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789316454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bna+6irtDUV/Y8RIFOQ1soq62qtApDkXVKRGUCXpTqI=;
	b=7EvwXuwJwsuu0s4dVFA2JlBIPWxsNBka96ejPIQgaHl9F5OlBuLu8QYl3tAQUHmX+xcuTj
	3ldnmG4E3ZLOjwNo/OI6vrndvbFTiiFSqxmMfJN0EPxSF3A6VXBG23byIrF4IzVekDxAoI
	x+DZjmr7LN+FakRVcyN/1wXD/QIGG+4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789316454;
	b=o6R8n/x1HZA8Fuf6kUj91cjHgMvpICbn+DsWsFld3/uQAQUomMeqaR9zfWBBp/k3Cl90Bp
	5DSSfpDLJ0760mj88l9pKYxpqJZYzALPq1eVR/+NgvI0b+XXdYRb6YIh3RxF8oiiWv538j
	CrS5hl9wLfiy3YpCcbGj4MoPanJ8Rd4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oaZICN6v;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BAB460E72;
	Sun, 13 Sep 2026 16:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E45C1F000FF;
	Sun, 13 Sep 2026 16:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789316453;
	bh=bna+6irtDUV/Y8RIFOQ1soq62qtApDkXVKRGUCXpTqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oaZICN6vn9gGMqWcc5FMrMZIsAXEqWTfTJbCWoa9uoAbJbDOmu74fhr+YsV+KdZDm
	 QOUmFU+MHW9Db5QF6sHgw11lmYDUg5X4j+F3uwpHKX6pGerHN3YOL/WhY+ukP9cNC2
	 alMfoKC3nGZrb2Y1DCyACtjbVsPCzADmdF5nQlQbYYq5zB0AEZA9hOz3bq6GLNjn5g
	 XN2NRaZL4oG1Uv10eQJmPJUtxxPoriYa/avQPfSj/+AsRNddpnCQFyLXtQRWajhxWP
	 SjKHMrJETXv/q13tpajgJfeN0PvJrvcRrk++p0vrFgGFwwpIhHYO7zCdLmALaY515e
	 PGNnSQYvVknIQ==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: add short circuit for esz<min_region_sz in damos_adjust_quota()
Date: Sun, 13 Sep 2026 09:20:45 -0700
Message-ID: <20260913162046.99109-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913110407.32558-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A3C651C0006
X-Stat-Signature: 8np9d9z5cftu7hxxeiteyiewbjnsfzsd
X-Rspam-User: 
X-HE-Tag: 1789316454-523998
X-HE-Meta: U2FsdGVkX1+RDvsTf5ErNGdS1YEF5PtXnNFyaCUXZtcPklBGU8btk/NfoeRrXG5ss4QvyDozvfobFLvnkzeiFRY0IJz2QgtE6N1RSB+a7rDPfz50Jn9yxH1YBreLMuyB4nxG1RKGdBLTkyvMhOd0rX/nFoy9NQ29yf+XAFf3oafSnOSSNX8x/6g7KcwjlmSfhZuzpMAxoP+mBhFaIXfCoYNJwlgFApObKrwzYGd6xTRgGJkc1urX0t0Ln27VYJXLyk5oxgaxfblKSvr2nb2eA1C1ar//3irZ+Z2dlXeVlszqctX+m4H02wlr1r29T3iW58cnGCYMBKLTRX3cyq5vKgXmfy8RPG50mRzmKjX6yP749CB3q1iYzY7WQiyM3r0WRXbgMD5FIk3XkFTNQ/L2hEKQ0oi0Emvf4eV8GQfmSqX569P8YIT3MNOM/kuE/ves5ReNIxoBzh5oNe70Wj4wpdgEXc4N3pW6jTnNZCYFzulQS436tNlRrXj+IFBJWZvjye4DQa6YepZITDaNvvT1z9thjDvQhYEjdgtqs36rmNW45abDbwlE67cjrHtmYhhnZmTWOVLjCWiH9aANBl6UeMlJJjHb0DMWICJ7Gmw/LVt3yObuk7P01/Y66klIz2yEuXFmeWvGdRj6Np3nE1+RWS2YW4iuIsM0JZMKEjmaPZg3Cdd/z6+sUgJ1ozZlyRBuiPUXLcJnANvo6odIWQjHbmVlTFn9kkmXWf50D4oR+Q6vZr27U9BI6rG22KU1pPesmczZRZmkld1GxSB8DqmYG0+hcxd6YLgKKXu6iHDSL898uOz2ZXcKrI8CBgfxAJJNQC+0LehW0vX6bXVKn/8TilUsOdbi6a/wKrOk8uppyyp5U/w9JNIQoqjevvoWcGPqC1RbYC6LGHO+3221zOyCEOx2lOdd8R9aboWXdgDARX2DTZoLOyNBvI6cmfNsXbUIzbS84mF1B4/UaCHJi8h
 FIcWhE1D
 bRsfTkPCKRX4XhHknLuDyD3kAn2aSrO329HYon3vZEhK7D79wtnowXwnwnsmiUlKchO5KQELOCLLQLYD3Tgu1BTw0BfFN1anrXprCns3M4XHm6RHe0hb8Plx1lpkdJZfPQNxvlGTo9cBUczgdEkDDVvfInLrPaeMUzEX04aK8Pj5b29iAweXsaqpoWYwC75fPZ+JjroSiYs+ji7ySqrjjXIA8mWR9SNBPLOjyfGLd/PXdfX+8IeLrpWCEMyKnRd5cdgi6ljL+wzcC0VTjFEGMXLslHJeA5Fm+llgThxommORwP/YcZB58YKqZ5asoI/m+lHVb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,


From the next time, please complete discussions on the previous version before
posting a new version.  For example, in this case, you could replied to my last
reply to the previous version of this patch saying you will accept my suggested
changes and wait a reasonable time to decide there is no other opinions.

I think the subject is not very clear.  How about something like, "skip quota
score setup when quota is full"?

On Sun, 13 Sep 2026 19:01:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> After damos_set_effective_quota(), the effective size quota may be lower
> than min_region_sz (e.g., when the temporal quota goal is [over-]achieved).

This sounds unnecessarily specific and doesn't cover all the case.  What about

"In damos_adjust_quota(), the quota could already be full."

> 
> In this situation, damos_adjust_quota() will still calculates
> quota->min_score.  However, this min_score will not be used in this
> window, because in damon_do_apply_schemes(), damos_quota_is_full() will
> always returns true, preventing the scheme from being applied to any
> region.
> 
> Therefore, add a short circuit for 'esz < min_region_sz' schemes to
> early return from damos_adjust_quota() before calculating min_score.
> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Assuming you agree to above suggestions,

Reviewed-by: SJ Park <sj@kernel.org>

With the above assumption, I modified this patch with the suggestions and
applied to damon/next [1] tree.  I will repost it for mm.git merge after a
week.  So, if you are ok with the plan, no action from your side is needed.

Please let me know if you have different opinions.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

