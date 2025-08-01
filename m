Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CECC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 21:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5366B007B; Fri,  1 Aug 2025 17:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85B36B0089; Fri,  1 Aug 2025 17:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC28B6B008A; Fri,  1 Aug 2025 17:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCC5A6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:01:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F4BE1DA830
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 21:01:48 +0000 (UTC)
X-FDA: 83729410296.15.96C6FF7
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf03.hostedemail.com (Postfix) with ESMTP id AEADF20009
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 21:01:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ntW0V/Mk";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754082106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=siNyzVOwgAuW+/GSDs9kBkFI43uRTOOa0hwMs2ubnSM=;
	b=3o1ODz/MgNswGGHOXa3Ecy4BvdQ4VuZspYCHZxe62BWcaSx6xm+D04/LPhuiTU92bMSlTY
	E3qGNqBySzoAmkx0Nz7sr2Zw4r3D4yBdByCfr+3MT0LQrtjQKYF3UxohTI40jRzL5xY/xm
	gh1KB7JrkQTg+kg0X4yWuACguECaVIc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754082106; a=rsa-sha256;
	cv=none;
	b=vb9zCMO4HuFm/UJ3COw72SEwMobNjDfqc5xcnsxarv5LfvRZqrme8+x1m0yhrY8w4shi/O
	riR9gx8Zza8I+nc1Yn0IhmQiXFvyghY6LVp/3MvIwSs4Zj0bQvQFn8Bhwm+Uvscvtagezb
	/wcgHDPNmwQmZgcMB58WmxeIql6u0RA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ntW0V/Mk";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 1087EA559A1
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 21:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D950C4CEE7;
	Fri,  1 Aug 2025 21:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754082105;
	bh=eYn24Df2DPfktFg3q3iAncFfxzsR6pbSbJtejQ6BcTA=;
	h=From:To:Cc:Subject:Date:From;
	b=ntW0V/Mke++hBis9S+ymDYqKcsySZKDRLd8xnQmQkmZhZjdpADMWV2hutrQmSN0OC
	 UKEGoz2lRSOLo74exG2gSDM9SSeDcF5vt7iu/FUbnKfWMmvhfOOUclUzgw0UjM6oUr
	 en5SzkaEt2FPUlhTZQZFK1VpP2Dl4QNc0mJTOcZruiR55ACtyf3WP8ttlxJZntmQL+
	 HlZpoo2/ZLk4DKeTKfd1TCVMjFpdwLkgW9KS1OKtIL9gpeRooV66B8ZWRo93RcoQv3
	 gKOhYWNYPP3qY8036i+yrxyIjggotyzu50Kl2lgFXIW6VXny+2+U3RWBxiYx/qm3jh
	 xXaZA9w1DXa8A==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2025-08-04
Date: Fri,  1 Aug 2025 14:01:42 -0700
Message-Id: <20250801210142.1858-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AEADF20009
X-Stat-Signature: s5cb1whza1mmfz6ye7gxhzne5h3xcumk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754082106-552471
X-HE-Meta: U2FsdGVkX18jjhvbNo0ezPiRr6SZs1ZorGgmrWGmPW0eQSfMDWLlEsFlttf3EZe/5ARY68Gyzgw/493l7ZxQQMMa570MapsI3mfD0crW7HDOPuP48116jbTDRPpTNZKooubM4PD690nFsWUh9orML31+gLgLOC5+IFAs6JLv38xJOXm4QukrT3NVhsLIj9xCI3nomBIASsXqmHv0Ueq/bpDUQYvCLGVrsWvUJ45ZsO1DwY/MJeOdAtao95kf0CBS+NLy0+g/goG2NqojeiouoXB16Q78DVSJtbfWQY/IIV10XfgYax8AsZqudP6zBN7tHy/XtVHoeEgZfswISjaLlwO2+gWGm470u9wUfQBUWaFQiTdWFeURUCAI3RjzZPH0QX8bpjK05tqbAzpzgZHr5DI6mNRXb9FnKWoLpdX6vWQJAfnITZ4pzLZxI+Y6zDMgVx1J4OKRQkcpXIFZCBRQ/B63+1zzRho4PV4lLMUf3Np9BRWH/JdpawlNn7vGAQrlLqobDXhsruMBgl5x7qbygW2Qtn7rhDAbfOeit52yMKWO0B0E7CVzONNZgLzxLrvcqToX/B1V0OJObYVYlCCO59J6Qc6fMVduf4ngapU3qlPw9Ogm+9jg5v/EFdXh6MJ9vEfbHO7lE8NtxixHrXHGBpaSTfFy3zQuXKCtzRfoC663x4vX9Ht7s2UBhLbcBEKx7ayQ8ZaX60tV7aOReSGXzAvKTTCuBagrzCsjZS3GgzrHhT6LDb+IDjfYOaTdMYdNXnDC1eGmxbz1xTX/oHncxkPdqXJ6WLgfGtV2it1ZfxxzmbiV/OPwsNoBus0YFpmlK+57So7cRK28k1dnQF4ue+J7z8dO88azANoF5dt7WlQdZhxxN90Ehnpyc+C0jLTPjnK6+d4yS06FAxPZHueyK98wY8GiF3JLDCEfPmfSaMmXgwkHBQ4F3idDZdPzh/jLUpkL3174Yc5GuADABwj
 CYBdH66B
 u3VO1v2pLQ9Knr4nRg4Zfh78kM655cAwbwT4eLDOuU6B72LYMwRXd29SZUkEHLC6fWl3uA0W5N855BaOaQ/x3RCXrzH9rf/4r+SRH6XvWMMJmtLsfL469/DluCaamLWG5Q63lloxIQw4nJzQyCQ04vn/XrMzLbQ+YCiPFa+hrcDti5Ig/htgDcE5b+dKigUmcCMi590QfumNOt/NWhlDG3Psf8dE0DRnFqdt7N1nQ8JOIRH1Mk13JlvH2sB6QQ/qm9cF52rKC/tOifRVGxlEDDXCdpAp80AH8F4zF/IytRAUAdtbRc3eyPo04rw==
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

We have two reserved time slots for meetings in the week, as usual.

I will skip those for weeks of 2025-09-01 and 2025-09-15 since I will have a
travel during the time.  Feel free to reach out in any way as usual, though!

Next six time slots that I reserved in advance are as below.

2025-08-04 (Mon) 18:00 PT (not yet reserved)
2025-08-06 (Wed) 09:30 PT (not yet reserved)
2025-08-18 (Mon) 18:00 PT (not yet reserved)
2025-08-20 (Wed) 09:30 PT (not yet reserved)
2025-09-29 (Mon) 18:00 PT (not yet reserved)
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

