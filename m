Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE61CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 21:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872C06B00AF; Wed,  3 Jun 2026 17:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823416B00B0; Wed,  3 Jun 2026 17:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739266B00B1; Wed,  3 Jun 2026 17:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F9036B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:01:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 096AAC1E03
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:01:11 +0000 (UTC)
X-FDA: 84839821542.07.038069F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7B65080014
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:01:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VBO6u+S5;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780520469;
	b=sd/xKdgVot9v2mCmTHMRm79pnjhSKLOqu0k6rzBotJjPhr0UjkWPtvUHTGwTfi5OkFMMZC
	Xa6MRwsiij8JyryZCcI4JO0SjAH50blq4LQh49jZ0mU6+ikv9c3x/8dfXtoxP0XmqOYNhy
	9VS3eXWJ4V2p1OtYPEIRPWnIyl8PASM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VBO6u+S5;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780520469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kGZJGw424yME+fD2arJBJd0mBfOG7n7nCcKH5ittnhA=;
	b=y0Sde2HQLUdHxtZ21CWMmWzFZYwrHQgsCtLln2OeVyG34COlv8As63+lCtIdWoDDfvUidP
	E9aAWuBofIOWNhnWjmo5JiUUwf4C1Vs0WZUJh9+vERE0aCtq27sNPrKbPpvgNeJ0XBZvSN
	4hLle51HB4h5hXZPokqcM3p4wMKdNIA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA8206008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B02D1F00893;
	Wed,  3 Jun 2026 21:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780520468;
	bh=kGZJGw424yME+fD2arJBJd0mBfOG7n7nCcKH5ittnhA=;
	h=From:To:Cc:Subject:Date;
	b=VBO6u+S5IYaefjUFI1pd9/q5UbuO892Qmaw5jgN+uo9Asfy2mcASp624cd+BN8OAc
	 xHNhdiCvOqr7VrD5Su6/nGnBzosBA4v6NOQG8xPqt2mwr0vP4HSoKsIqPVaWofUqsm
	 RDkTFm+2fpfQq8RuTkKCNBnKSlgUH3LToZk2qhW7HLjgRDMjoKjlhiJtDhGnaAM3IX
	 gwGSUQ5yeu1wqMXPVkkm1kqEaedvj3GS3AOR/U/dtz1Q/9UUywSgRNLOuji5oy/8E/
	 R2qp7PogBIFLuB6GyMbzEPTzluNi4i9jsv1TkDXgPXZXfyHXFPRhonSwVlpdhK83qP
	 OYarOGopxLsqg==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-06-08
Date: Wed,  3 Jun 2026 14:01:05 -0700
Message-ID: <20260603210106.14684-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7B65080014
X-Stat-Signature: bzc4kma5juc7c7bfz5ifwgspgrtox5yr
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780520469-701909
X-HE-Meta: U2FsdGVkX1+kuBjJCpekF8yHif8u7iWcOnYIANgwlp3rs8I/bt0DeX8AxbnAMYJJKGiuda7m7MAByBmeB004PINFeg2NiWbALjTlbb++jwSdHr0aW+qB9EEfs4fhHvK7g2tzDIXOVJGRBe9PoVwiY97ave1wp0+OFNrCFXeEc0o0CKt3mkuZzK1f5ZyNqAfGqlrjn4LTWKX41LKWXGO763QHTtN+uT6CWWDwxy1UiYAkkTS0Ru5a+iVzewW9DQHpmVQUUt/uiZhMJbCz8QQYRVqGO4iz1c8qKKNHHkUOzUi4lziglKDNm6wuxLeeGxiCLVzLlJmtF5SoXEsIqg1kVxYz9sV1a+6wO5otSbQczVBkETJrxzi1eJpkfvFgA+vxI65Gn1B6KoPWZOUPQO2T00x/TSELhi2XRceE+UlQhAPAQbV9oxAAWWJbZ1+h6QK3I0x662Q5W2baC9iGCqSX2ciDRbcAsrNEc+jjP03AASOHwEfcHOXhE+ElbHsAGrluZnukLHmVmK7K9McDaSLQ9PTt1Yo5dOgNTyg6lGbf41SYW5xqxZcRRZwsDXYno07v+iWF8l0++sLJqlR0juFxO0IoPZfWHt2YSwHXet+2zPBmdh6qyWyDxv1Zn6fAe4oimyqkgWlwJklitx9ktYvaXvPCMlPc0zwMBeh11aRS5QwVc/1IwA9ftmhX7WDh24m3DO/ZmFLNxvTo5aRgWeiSemYMXqzI1XzKUaxry6l/lCB4T85ibqNxhWv8anc2rQOAKOgSJPKWAALZmM8xoODTyu3y/6Fg8fAmd43bS+A3OPN1JTHWg41FHsaps8BsCp6LXSgkaQJOHkBZhLp2RnEdZq+zaLGyLmzc0zRdD+N6ZN8/QQcICVyWbXzZZ7oOZwiuatajbHZrRQaSJNI6/eHavuS/xsDSVogN9c6KfT1sf3k/u/aMKjpEaOHjdgeAJIbMX5068qSOYCVtVp3wCPj
 d85arPBN
 DG0pbAC8gHAEc8IPz3o6dTfu4NQCTmQOYEvXdFA0ATy391l8EDWHT4hM8Nwzuo7+uPT8XXdupibn+7nB1aXxSAtuT0EEtyFRv5K4qKgODGd33mkFmpb0Wzp1RUHZdSC1YTL4kGWcJsarytFKghInzl1D2l+xZ3SDtufW2SWl/H4ccfahqaeRLtGqokuPyOkvpro+AH/y7okAigizRNs2S2vHT1Fcado3a5czjIYT8pspKewTPUCVOK7p0rZzGp7TseVigpO781QaBkFGrLoDkwFNiJwvAXDOnxWvr2D1abpolPP0+DF8zo0nDVJQogzIQcWnjpU5XxHzjn4ynFYdhhwfqwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-06-08.

As usual, we have two time slots for meetings in the week.  The one for the
Monday is already reserved.

Next time slots including six virtual-only ones are as below.

2026-06-08 (Mon) 18:00 PT (reserved)
2026-06-09 (Tue) 09:30 PT (not yet reserved)
2026-06-22 (Mon) 18:00 PT (not yet reserved)
2026-06-23 (Tue) 09:30 PT (not yet reserved)
2026-07-06 (Mon) 18:00 PT (not yet reserved)
2026-07-07 (Tue) 09:30 PT (not yet reserved)

Please reach out to me (sj@kernel.org or whatever) to reserve the
not-yet-reserved time slots for your topics.  The reservation is made in a
First-Come First-Served way, and I will send a Google Meet link to
reservation-confirmed attendees.

Please note that other time slots are also available on demands.

Shared Calendar
---------------

You can get the schedule via this shared Google Calendar:
https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t


Thanks,
SJ

