Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99220CCFA05
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 04:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEAF08E0013; Fri,  7 Nov 2025 23:07:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B2E8E0003; Fri,  7 Nov 2025 23:07:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7648E0013; Fri,  7 Nov 2025 23:07:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 834178E0003
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 23:07:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 043F412CECB
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 04:07:46 +0000 (UTC)
X-FDA: 84086106174.26.1B56CA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5BA3B180002
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 04:07:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZVEGeBBt;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762574865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6lVNlrFEMyk2oD0IZNIfBtL2xhDMhqqTHt5qH7bVrjw=;
	b=X+9iGwRrWIWHQPf9hAU84MbUhkSVVPYffQsxq+oUPen1y1xamuWw0tYVsIyihr6K7dua4N
	sOxJNmOawbKsSDOYeUcN43LDr6VYrDO9SrqsRnbMSx0kAjZ7SbK0ATV9tw7Gsb/VjckItU
	qIxa1IA5KPsnbhLjmio2L6sOkbX5MZ4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZVEGeBBt;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762574865; a=rsa-sha256;
	cv=none;
	b=hXLyUt9pLigscwzzS2q+WMJfGROJEQ25+xAtrnxpART5LWsMeg1o0yqfg4q43jzEcU6a/e
	i92HHc+0SeJEDEDvzCUmXGEguPmJrhbHh05a2bBEOGeSznuHKqE+TtaPGBCNqvgiVQnFTI
	UctTiA8ve4I0kbLXxP8HWIk9TmK5g2s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A0A84078E
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 04:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BC9C4CEF5;
	Sat,  8 Nov 2025 04:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762574864;
	bh=bVWG8OxlLnY/I8fRElck+WGWHUB5rw/YbxUK/Sy7zcA=;
	h=From:To:Cc:Subject:Date:From;
	b=ZVEGeBBtpfYWfmsA438IAWqCDjX4YFjEokYYn1hoL7NpL4H+OsDoRIXCYETDTnHc4
	 aYgRFSdgQqc5Cp1ZMvdZcZQ/Fo7Pn9zys/WnkTLaOHMiO0+ZHuCG5tue1IQznF0JQu
	 DWFRroKFPNUPao2Xssxr4CBmy3j4TJ/9yEuwVffezUHXigTyjm2u9WACfXytoLp9hv
	 M2GLiczPo3PmH1s/gjmEFNOUw8sAKQLd4k5+1qwDcwfqB0yhKzsLnZW/zHDBGmBwVy
	 LBa5qPyvpgzMNocRIekCzq6zBnb8IhvOaFAG8llEBPPKX0dmzDX8JdPQrzmk9k71/y
	 CchGM8EeVn5rg==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2025-11-10
Date: Fri,  7 Nov 2025 20:07:35 -0800
Message-ID: <20251108040736.74312-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5BA3B180002
X-Stat-Signature: aiae3jsxtn1q4j7cib55p5ydo7mfpkww
X-Rspam-User: 
X-HE-Tag: 1762574865-695986
X-HE-Meta: U2FsdGVkX18N61HKEQq0ilMJwpgyGlmvxapL/u1cWC6NWpOVDla4np9YRsMI3rfgr0n7te57PhMT6tdbKRVeZNZ83R0b+HY/dv34O/aJ3B8rsSS7oaFeaj+I+wX7x9kHBtdpMIbPuCbGyhe6gag26WO5ysHo7cwUpnBT54slef7sfPd+PR35IdRJZWt+amGMAuBUcixqdgket4NcgOavplveJoQ+3KDqP5mytJ+zD0hyo6JyJzO7mWXA0O6gfqgoHfAejJVzZcQzQPtwfII8KvVsK8B0HKJZ9xepNDR1u/Thr8PAWu+VmEk9azzJgReYaBD7WOyb360VvJn6YMMKMzMfjBli0sHq3OWEdUBBPoQxvboA+/AyQbq3QpUwwwAVVXfsKkuxb3XpQa8pFB6rC2XsEnFiDO+66fb5rIgDJvR4Z2rl7QrnpVEKMKAj0gZcEQ2GCQRivC+ioBuBFx5VYpIXmdojLjNW3UT2A9lHqpHz5lTrJj4btXrR1VAfvLwAJfFDlglc/GtBhpv8UHGeOkHIJT7A3+rWjay/lZVn/a9riJgzrk8l0RiDJdN518OMfIrx+FbyscG+5sx6FRGGvqtqHF+mLi43qQetfCM4dtRk8Gtz4l/5Ni4WYL/EkpXx2mGsvCoghwdxDJ9x6V4HQfdDATAxfpPM3a5Bu1B8mDg4gY1dl94tciAjAfNcHnuSiEPuN3Y9xXnWtbMphENqtQntvHtKe6RzJtojC9/ljN8MEXLZFg5pv6LTBUCutlomH+tAwWIXR/vFKGQ64nAT+LX/6CZZUW66usS59xzH3LaroGUqe8fL9t2AvKNV8TpkG/Lui1JalipZ7dARJnpUnVM3a954l7mhOkNVK6+/LogmcnvU3xADlBRzOOOXMdLDLF+whOKa8jhfMBSQMkAKBBu/FU361xaGxmhZc/Ie3OhIM7MAUDnTX0Mypk6plF39fJZs5u+zAZ3zq29sQZM
 DrA0VZ7w
 uQgutMgKUt5Re5gEe0pC71XLNhnNxoH+3BB6/ObfCf7VoL9EOWEW7CLYTzT4zqeGHNyqyUGpU162oq0bZluHEEE7e4hmbUiiysBBy1tb2r4rvJ97A4HTQ8JUG2y8IbTdqYYDOOhoqfGib5XwkYHJy2TBLDGBNeUNvrja2mts9Wl1LyKHsATFQwiFnG7cGKGvtYjqIotrVaSitmwqXBm3qhhYj89owFwN23cuq+KRKK45Y52EJQ91P7ri/X1bPCHl5x9/Rg0redYVvfAMNNrzhsV9j+r56B67o/RJF4gAH8w6qfSGNcUsXWIYk3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2025-11-10.

We have two time slots for meetings in the week, as usual.  The one for
Wednesday is already reserved.

On the week of 2025-12-08, I will travel Japan for OSSummit Japan and LPC.
Attending video calls on the time slots during the week will be challenging for
me.  So let's do the chats for the week without the pre-booked time slots, but
as an unlimited and possibly in-person version.  That is, let's make it can
happen at any time and any place (not only Google Meet but also somewhere in
Tokyo, Japan) as long as we can.

If you have any DAMON topic that you want to discuss with me during the week,
send an email to sj@kernel.org saying you have a topic to discuss, with
when/where you want to meet.  Then we can further adjust our schedule.  If you
also attend OSSummit Japan or LPC in person, you are also very welcome to just
reach out to me in person at any time/place without making appointment.  Then,
we can have an instant in-person DAMON Beer/Coffee/Tea chat.

So next time slots including six virtual-only ones are as below.

2025-11-10 (Mon) 18:00 PT (not yet reserved)
2025-11-12 (Wed) 09:30 PT (reserved)
2025-11-24 (Mon) 18:00 PT (not yet reserved)
2025-11-26 (Wed) 09:30 PT (not yet reserved)
(week of 2025-12-08 is all reserved for virtual and/or in-person chats in
Tokyo, Japan)
2025-12-22 (Mon) 18:00 PT (not yet reserved)
2025-12-24 (Wed) 09:30 PT (not yet reserved)

Please reach out to me (sj@kernel.org or whatever) to reserve the
not-yet-reserved time slots for your topics.  The reservation is made in a
First-Come First-Served way, and I will send a Google Meet link to
reservation-confirmed attendees.

Please note that other time slots are also available on demands.

Shared Calendar
---------------

You can get the schedule via this shared Google Calendar:
https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t

You can also get the past and upcoming schedules via
https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing


Thanks,
SJ

