Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC20C5DF97
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 00:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87526B0088; Wed, 26 Aug 2026 20:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38C66B008A; Wed, 26 Aug 2026 20:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4FE86B008C; Wed, 26 Aug 2026 20:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7862F6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:44:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E4B678026A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:44:48 +0000 (UTC)
X-FDA: 85145204256.19.28FF839
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4A82240004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:44:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ioYAphxG;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787791487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cT+bFHA2IGIehxSdYCsujzJSXJKR74Lanqfi3RW9l04=;
	b=x550AWPDXvAt7FcCctchUdhd9QjrF2A4f7CeuHyHtQisPHwNnJDk0hnBRsWvQVavR0pPpt
	v6y4RnSpBlUjJoN24ZRtxShJ8HrX4COFeufxMGatfxHLK3p4dRg+iheLTuGftmQUJQsNoh
	HjNjfu1s7V77ug8MhAtK1IvVEpQRN4w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ioYAphxG;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787791487;
	b=YFD1gF59Nks9bl7c5Qo7/AVPBPKvvuoB6Q4mFGwwRWrVoFWvxw8kgZCmJOuHOEle0Xxe9j
	9sdnsnWZdXGsBv5UXFU3IKznxrOPx6epznSomnQFW6WU7wTdzTdy6htdmoeivtrYbXFVGH
	vAzwpi8bk7ZjleG/RgtmaMlpj1veXj8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 197D343CF9;
	Thu, 27 Aug 2026 00:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E151F000E9;
	Thu, 27 Aug 2026 00:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787791486;
	bh=cT+bFHA2IGIehxSdYCsujzJSXJKR74Lanqfi3RW9l04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ioYAphxGg/RgkfSz2okyrbrrruZuqy2+lG/2q/sJh7qBoSoxCPgmI6/CSl5Lc+nfF
	 M+/5yJ2jXXxg8s8B5oU+JUcUwgF+j2SM0hbiDuD3OIfYoiVtWJZH0skzXXA2f4SXZa
	 bzn+qGvtdXYxgHgSpd9NEuLpUV43VGLyUmeL/RVSDrYo4csgg2uWdP3xx8uHHhlnjy
	 zDhWvmfh9VzG1nhiGDfe66ciTyUQcb+BpnxY8gsLLtYeIqf9TqTV9WO8isFann0RBB
	 8H7YMIXUY0APO5bNz8EEzJjH+BxPaX764jMCP4JWeZqcN/rbhdqxFpLR5YH/5Lql/l
	 qiUcYXeFbeMyg==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: fix damos quota walk-position tracking
Date: Wed, 26 Aug 2026 17:44:38 -0700
Message-ID: <20260827004438.82746-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260826140508.74447-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kj4p9e11jh8jaddn18x9zkt9z7ouqjwz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A82240004
X-Rspam-User: 
X-HE-Tag: 1787791487-798548
X-HE-Meta: U2FsdGVkX1+4R3LSHVxCa9FN9kZVq/D2/iPyG3cGIVDfUJfeFVPZ1lvCE05uLXNQGH/4yjA+QqJ1WDJmSj5MGgpHbGSEfWp0iiFrDEGxEKtC309ztEDSmY/rxUVgHJnaa149mOLSswsoSbq398aDxw14wnHe1J8PKV7l0zIvNpcep6FTtRPhtePV+qGomsch1pPwvapSU6ryTDwzv0q95VugvvnaI69tci7fzTO878Fqh08l9WqJS/QcRUHDL/rYlnEQvcLIauyUju3Bgsa+iFUvZBARV6Gpi5sa9v33VpcUCqwY8wsr/6WEg0EUiHe6X/wAbAWfdJ5zbnYxRX3unyXPkj4JSmpJiBw+KwcMA1+O/9Kb3kcJY1szdZdEWQISsoUQ/u0ufTLH5G5TFzfQ79Ujk8RpULeDX0QJF0c2rJQENRe3oKzRarh2CefZbXx1IExW2VmnRjudI0bIXa5C3Vol2oT6IjLhcMIzjBdohrnQE3vYcRFR6Omx9c2rP9Q5hva47Qctlohuurnluw4fN428Nr+TgSJyPCbPXaEjaUhozA1QNylHUmkH8JqVmMM1Qbnb7OS3VGSyTNt7Zizt+7AsUb96meFzeWYK6eYM1lQ2y4+aWt/TdCBZHGs3EstCnhpWCjeAHyOVL0YKt1oo/q2WfM9zZMzTQ10TzoGDhknOZSEr8hUfX2hqmzeoRLhFxEWucD0yuSoJIlpkfJeajR5UmnlzMh3kV5r/McuPo3wyiwFR5AENtM1HQFJjx46rAgQIlgMZfFiOFZp8vo2S98eDacGu6fGHfkXWMX/5tCMUwnAGdnx7Z7fnXNpI2LwO5QCrzJDP9+V5sHWyU/9DKUdQrsS3MaDGyH+dX4eIMIVDz8kGTEO5Fd8ClITGUo76G2ewZobn0FIGggFVow5X2k7nZGxHW8w8dmz3oIiDLq14RBcAXYVb1eveIUUSBha6pq19BP6SoBpFHW7eazv
 Un8kRxAF
 fJrqd5IUG7FaHXka2lS3B8aGXLumDVjPbaOtRlKHvXAUBHq6/KGuMK/T+ksySZJ+KTYZ0j+KaEX4y8nE5pa69lOQlFJwtOZOalQ8z1jOvvaltU4LsTUBV4kQvEE9tPc1E8MklRk2cW1FRh7zbA7Qpm+MAVHoMI4sZXJCppTw0z1pBuixlWgJ8Zu8YwjuwweNQucNC+Ez8GaW+f0Bj18maeFM+r4w/uZ5VSvipdXYsORhhx8CDBTsKMgldWU52lu/wdT38
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026 07:05:08 -0700 SJ Park <sj@kernel.org> wrote:

> On Wed, 26 Aug 2026 18:24:13 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > On Tue, 25 Aug 2026 06:54:57 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> > > On Tue, 25 Aug 2026 20:46:16 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > 
> > > > DAMOS uses charge_target_from/charge_addr_from to remember how far a
> > > > quota-limited walk has progressed.  The current implementation has two
> > > > problems:
> > > > 
> > > > 1. Once set, the cursor unconditionally skips and resets at the last
> > > >    region of the tracked target, so the last region can be skipped even
> > > >    when it has not been processed.
> > > 
> > > I don't fully understand this.  Could you please clarify more?  Maybe adding a
> > > realistic example scenario would be helpful.
> > > 
> > 
> > Problem: Unconditional skip of the last region
> > 
> > In the current damos_skip_charged_region(), there is this logic:
> > 
> >     if (r == damon_last_region(t)) {
> >         quota->charge_target_from = NULL;
> >         quota->charge_addr_from = 0;
> >         return true; /* Skip */
> >     }
> > 
> > Scenario:
> > 1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
> > 
> > 2. Quota is configured to process only 50 bytes per window.
> > 
> > 3. Window 1: Processes R1 (0-50).  Quota is full.  Cursor is saved at
> >    (Target, 50).
> > 
> > 4. Window 2: Skips R1 (0-50).  Processes R1 (50-100).  Quota is full.
> >    Cursor is saved at (Target, 100), which is exactly the start of R2.
> > 
> > 5. Window 3: The loop reaches R2.  Because R2 is damon_last_region(t),
> >    the old code unconditionally returns true, skipping R2 entirely and
> >    resetting the cursor.
> > 
> > Result: R2 is permanently skipped even though it has never been
> > processed.
> 
> Ok, makes sense.  The user impact should be not that big, though.
> 
> > 
> > To fix this, the patch advances the cursor every time a region is
> > walked, regardless of whether it is applied or filtered out.  This
> > allows DAMON to accurately track whether the last region has already
> > been visited, eliminating the need for the unconditional reset.
> 
> Sounds like a big change compared to the problem.  Why we cannot modify the
> last region case?  Have you also considered other possible simpler approaches?

For example,

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2686,14 +2686,15 @@ static bool damos_skip_charged_region(struct damon_target *t,
        if (quota->charge_target_from) {
                if (t != quota->charge_target_from)
                        return true;
-               if (r == damon_last_region(t)) {
-                       quota->charge_target_from = NULL;
-                       quota->charge_addr_from = 0;
-                       return true;
-               }
                if (quota->charge_addr_from &&
-                               r->ar.end <= quota->charge_addr_from)
+                               r->ar.end <= quota->charge_addr_from) {
+                       if (r->ar.end == quota->charge_addr_from ||
+                                       r == damon_last_region(t)) {
+                               quota->charge_target_from = NULL;
+                               quota->charge_addr_from = 0;
+                       }
                        return true;
+               }

                if (quota->charge_addr_from && r->ar.start <
                                quota->charge_addr_from) {
'''

> 
> > 
> > > > 
> > > > 2. The cursor only advances when the quota becomes full.  Regions that
> > > >    are filtered out do not move the cursor, and the scheme can remain
> > > >    stuck on the same regions.
> > > 
> > > I don't fully understand this, either.  Could you pleae clarify more?
> > > 
> > 
> > Problem 2 is a false positive.  As long as the quota is not full, DAMON
> > will continue iterating to find applicable regions.  I mistakenly
> > assumed in the commit message that encountering filtered-out or invalid
> > regions would cause the cursor to stall.
> 
> Thank you for clarifying.  Please try to reduce this kind of false positives
> from the next time.
> 
> > 
> > This patch ensures that every target is traversed sequentially and
> > deterministically, even when the quota is set very low.  I omitted this
> > benefit in the initial problem description.  If you think it is okay, I
> > will add it in the next revision.
> 
> What's the problem and benefit?  I still don't get it.  More clarification
> would be nice.
> 
> 
> Thanks,
> SJ
> 
> [...]


Thanks,
SJ

