Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F47CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 21:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627638E0214; Fri, 15 Aug 2025 17:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF8E8E020B; Fri, 15 Aug 2025 17:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5159D8E0214; Fri, 15 Aug 2025 17:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 377088E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:44:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ABED158613
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:44:46 +0000 (UTC)
X-FDA: 83780321772.21.AA590F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 35A8C1C0007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:44:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MvJKmlGo;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755294285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ddej+nWarCGuUCh9onLf7yjqgRc918kPIAdFxdWK8wI=;
	b=SHOH8s2f7Cz1yznCk/7XAxYTFtOXzCCmkmCGlXE7zfm8JeySMpnuunXFCzFEwACM+ZXGiw
	50GGAs6LzGCURIYhgnU1CXIxQ7aSmMlTABwxwXfVVoonmaHPE4aya8O3VvPW0jNr6e+Ndk
	6NMZfmGumcvOtrVBrDCDYlJuPudPuV4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MvJKmlGo;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755294285; a=rsa-sha256;
	cv=none;
	b=fI9PXCXRubvjXtxYiagmaJzc7B7JMlVyC8JfHgaAuHR90U3O2LrN8RuBGI9CWke/Pk634U
	tkVtYLbQsPpQxgEd42w2XiS/1Hj2y9eby3vJLKzslNdfxelCjdZ3otFVZBgFelp0ZEZ2hY
	08SftQbdSgN1xRDfGbCXFfG38joA5QI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 44B2C61164
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4E4C4CEEB;
	Fri, 15 Aug 2025 21:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755294284;
	bh=w8bI3K06v5qE0O96wS27g3AHvYkRCqTbCUA44CgzYFw=;
	h=From:To:Cc:Subject:Date:From;
	b=MvJKmlGoGPC3SoPcH3STEEW7WDVtuMET4SzWHzRaP99yr+4AfL17RZ0G60aMb5OsE
	 COmi1+feMJWR91MG3PCVj/RoGLw7h5HxBcY2QwKWNzxS9SNmq3rPCD60Gdfbfs79L0
	 zzftKzqvFWf3uHcaAchh9zYTpwkr86igzFIXGcMnYU0/ebksTGEkRXPNHeW7Xz6KQC
	 pLu7Jz9xn7602d8cxWvHV6SpVVsdd+J/V1pMw4rfULFicjFLQx9EkodGy+PBFtpH2g
	 zTxZERDHYKcUcu/h0uomK01YAu1Tg5SFX0Z8T4HDy3WjrRW0awlAQc2lFsEPE7n5+u
	 N+TawuTomJMnA==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2025-08-18
Date: Fri, 15 Aug 2025 14:44:40 -0700
Message-Id: <20250815214440.89592-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 35A8C1C0007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: yqkgeqr8ihhxatajiqp77mdt4ni7kade
X-HE-Tag: 1755294285-869910
X-HE-Meta: U2FsdGVkX19l702JjtjERE5tgqyWzp+Xk9UkuNLh5EAQd8qzicwH8w2tMcx9mIk/rwK+wfT0RGBAUG0S+YtsSM89ewA3kqoz/n8wjlzOXhaxO5axIZevg48yBSQjHcFVDLzWYbeXoyEWsV7Q2bFwYVeN7w+6cOJ7sAOqZIB6aLgMHNCsYESI0shPSxHYXPXH8gb9CrdQ2/+5+1DEA0bO7OIzON24AW/cZuJ3O2LgxN0kgcqMdPcotX41XuF66VYHU8PuXMxgFzICDz/KyF32HV7spdN6mWCa4t9/msZKBGtDhU0eeBC8H4TZ/K2Vl764Ex1K4fuztNf794OC1MFYscdS9iGhD2wb5vCK525lw3AhZP32o6U7DK6RTWsaasLoCKuLw3wtUU85jxZ2RLYRxhL78sFsTg6y8tFq0D0r9tgGQdfoqlkfLPGoWpV564JrGKHHFz5Ry9QGt2Sw5lP3UZfuCOuefZsxS4iAQ2/DUx06w6Xu8gbKjc4qKq1oc1Boaw7JlaRER09nBFWjPpBCEopx8yURyKKp4NAfiTZV/szdb08WC209halA14J4vS1SxwcK4399HQe2ZTKuURyDbl/beQBl5P4mGaenoml2ilr3aTFtkAZNLdU/P6Cc5sJBKRCtq3uScfwjpxTbllrhoxJY3XSk4XQwaI302/mAjx8RL0MXGxc4wS2JIWjYbpsAYp3yLK1jIhbgZzQs483ioAg/OZCXygGg5rAHd0Y1uZOTEG6BGIWqU1M0IQ9Hnzp9hTUcRQ4hp0v+cXhEUac2T/y7mB0tVWyHUje990PKzbsKV6HBhpn8OI+tcT5nuw1Dp5cCQazjUwQc1eZIINaKJ645NR2vS3NKZWs98rCQWuM4L0GzFEHX95hE+TkJK3FlGZ+Z9INhoU0hDqp/3R1rS03LHYFixDkq1WBXGWddKvE/F9Mvaydc1ic5zulyzSg5g/ontls5e6LYwkFK/a0
 vl4jVP2S
 TJu/5XcoNEPjg088GUR5PWbYDsWTj4IRwNySwoDHOPH4/FviIvkOydGBXhjhfhznPOfRJwoNln4gcaJ+6BX6juk8n74+mgmBMyqPVBoQCEms83ytFaByQF2aSVdRyYgdhr5bdU3etSwQ0Gn3MIilT+hVa9HLQ3xQhstuMcIBhA5BrVy1MiaJVeDexfEaom4mu6nPVGkxSOvW3Op8E+huE0vl0EuW2T7MvmvLTqKVM9P3Il3RNwteQw2iFri8JRLzxL8YjPe4IMcVn0+16FRlTPck/ZnEr+U2JvbY/BJfhxHnQ09M6MSrfSrBMww==
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
for the week of 2025-08-04.

We have two time slots for meetings in the week, as usual.

I will skip those for weeks of 2025-09-01 and 2025-09-15 since I will have a
travel during the time.  Feel free to reach out in any way as usual, though!

Next six time slots are as below.

2025-08-18 (Mon) 18:00 PT (reserved)
2025-08-20 (Wed) 09:30 PT (not yet reserved)
2025-09-29 (Mon) 18:00 PT (not yet reserved)
2025-10-01 (Wed) 09:30 PT (not yet reserved)
2025-10-13 (Mon) 18:00 PT (not yet reserved)
2025-10-01 (Wed) 09:30 PT (not yet reserved)

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

