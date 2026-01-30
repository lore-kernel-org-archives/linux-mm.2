Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BA02E6BF3F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 22:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B98D6B0088; Fri, 30 Jan 2026 17:53:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667B76B0089; Fri, 30 Jan 2026 17:53:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573416B008A; Fri, 30 Jan 2026 17:53:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45E9B6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:53:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0618C1A3D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 22:53:11 +0000 (UTC)
X-FDA: 84390132582.21.472767F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 286371A0002
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 22:53:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YqlrB4oL;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769813590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zY6+VaZuI66dwdfp1oZ+q31I6X52JF2iIKcjpVLjjJA=;
	b=e5Ze9ltuDQ2gmC6Fhs2YG5TkaQ1/iTkJBcNxQqgtoVrvpuMeX6tqQxASFdl8Yf9QspqpMi
	6929KkMW7aT7GTeDJKBJfdOeV7GwZPDCvx2LeQ3TpWcd7eOrY7k4WvLMCv1NKOOVy6m3Wz
	g9s4UBW4YbzH1Zz23/zYTS3K6guLA2A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YqlrB4oL;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769813590; a=rsa-sha256;
	cv=none;
	b=2AuFYNiXadnuD2ewX+zf//fIHGUIxXmCNv8hXkbUhA1C5FWGRsec88yfxB9Se6pv8f2Oql
	Jhu5xQz1Z9xiTnM93ujdlyZ2pHCwro+6GRLiRupZcTpfJ13yr6juAerwQFVmd1Go1gW6C/
	NIdRVybYd+8F25cP+To972jsYvF8+Ag=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48A9560008
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 22:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1148C4CEF7;
	Fri, 30 Jan 2026 22:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769813589;
	bh=k8GNiLu9t6lAJMzr5pd4SlKRmsP75pqFQ7wO4JB6poA=;
	h=From:To:Cc:Subject:Date:From;
	b=YqlrB4oLJomRX+XETNSkfX02HMmScN9HaJk1KV6EXrcLiQhvC0eezZkFbNEslCyJO
	 KIf3IDXPl83ddjzrtbuW85ZPhzQXNWwrMMESkE9aMPeE7rz4CqKhiFfZfu6ZZg/yzA
	 fiaqOWQsU5y8Pn6OPXqDEcKDJbtOGru2OOwlCvIbFVF0SDam4OzzphNErSPuG7466c
	 y+hNH1M329NhQ22XrmHarSXissz1tK3VTG2cM/MW/8qjEDCfYCyrPxPg65+6sMJriQ
	 6nR4h1ULOXESem90Cu6Q6w1bXDVQ8jMDvYGVU63D8bwXVFtX2RF4fAitooxz8MRGRi
	 N2lis/FnrXKwQ==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-02-02
Date: Fri, 30 Jan 2026 14:53:06 -0800
Message-ID: <20260130225307.43208-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wnfsjrfng988ne5ndwu5ria73seg4unr
X-Rspamd-Queue-Id: 286371A0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769813589-397145
X-HE-Meta: U2FsdGVkX191P7A/jgkKTLAvxE/bkz03TJSThDhsPg1K9063bHFulZpy2XqoJzgZrbFPqt130ocZT+ib1bS/bLPsTHOb9/zhQDD39Vi7mIMXo8IsBUczwkYn41HaYEE0jumKUvj7P1UHgtjDOln5EkC5JOGgNv3dZAlFkgP7F7LpiXYhvGYYPmGN8LaIUnXrff7wlKkJ8asDWrYw41TFv4YeOtm70Yv0zfOlVOlfj5sr/viRyU5mrfJc2m8UxT9pYISCMrczgR9G545uJQxsDXlAZAYq4HnvuAKfXDpnHSRBNdCvzR4byEjUEUUWpwoOUzh1CKfoKna+u82EJruqsK6S5TNQF6JxGoEiZwIZhT0ZH1dQ1jayCgTR/6IjykvQwAvG+qBz10rVd/ryfY9QPAgeNo5kmFzkFwrs/o+uxZi4M52KfEjftSWYHkruJyn72l6CK8iiDqtqABmtgHktPsfY12JDy6MgMaI/+0DUh3lONvicKw6vyPNvmf2J4gNGc79nrj+DJc3l1BNekAg0hyaaaZyPE/t+y375hfsrQz2tW++u9pNUivT+FBjnXD9zQjdBQLDaLEpz1K7TH6WGdabYwQozAvxFWeJjWi9Mf0IysY7o+lQRLa1WwwZM6UcANvsiuhjMfKtV2s+XXONHnSnDTjXLD8BDl1BQzdjCu3rnCzj4fApPLeM9CM0Q1jXyFMjcNsi7yT63UzFXp/t+gkeOOTjMHWeocEGwn1uAn9vMIFqhTCOFyGWWL9bpLfAwQNXkGws+5SPKAhL0ssP3UyAKXNVKF03CiBTsv11Vp01gM4Ayid+5qY0muBLNFg/hYYSaIEPAS5fmgs3fqEFmyzc80rfpNYjDslYlYCKKqNGs+YhVP8IrJ6CJryCGgH78IErDR3dMoKXKlM7zQHdlQHtI4JlvlV3BzLHnDH4+kZ1i9duDvXOxfI95Tq01DqBpibvybhrFDyDOV8ySsT9
 00i9x5nc
 yeXA5lGw3PB8O8QPb4L7Y3osGIq+r/lHKr3RdpbtBbTj7e2Gb7R681oc+GNIhNbICzSyebbqyUXo7xX9uUS8jwocJloKgEwnakzT3IVmtOvLqoRbltQ9USA/zEp1JKFuoeMJLCsfswwYpUoB5cTacp+diJaBj/YjGy/eTo4uC8PtuWkNL8cJ7tJlSPTGq+soGK1d0Q10xTuLxqZ3xcI6UrEsqZ9WwpC9j9YcsL6VwK4ADfZTq7rQtzYwNsyTgshDBUM+hoOXuEddo9c/pIV3UIyqIRuAoEhKwyJ3LQxCWNyBQ8GAVAQjW4CKY3RuN/U1I4Ie+lba3dIwrQyA5P/gU6JXLqo3FCvmSNGqc8zTcUNDyRJzWoIww3NrZRuCRbrcqWfbh
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
for the week of 2026-02-02.

As usual, we have two time slots for meetings in the week.

Next time slots including six virtual-only ones are as below.

2026-02-02 (Mon) 18:00 PT (not yet reserved)
2026-02-04 (Wed) 09:30 PT (not yet reserved)
2026-02-16 (Mon) 18:00 PT (not yet reserved)
2026-02-18 (Wed) 09:30 PT (not yet reserved)
2026-03-02 (Mon) 18:00 PT (not yet reserved)
2026-03-04 (Wed) 09:30 PT (not yet reserved)

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

