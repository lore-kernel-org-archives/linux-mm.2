Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91924CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 22:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9544A8E0003; Fri, 26 Sep 2025 18:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904978E0001; Fri, 26 Sep 2025 18:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81A858E0003; Fri, 26 Sep 2025 18:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3D18E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 18:59:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C053160348
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 22:59:33 +0000 (UTC)
X-FDA: 83932919826.26.4B2EAF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 87EB8140002
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 22:59:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h/pXmYkN";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758927571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Od68dZnYGgqFc8QRdu/J8c+Q6IOUwRhlGn6UkwmsUJ8=;
	b=VPoiq4NCPrO/SuRtCEwLcHe+FEeKOO4hOPl6nyFTjM0stRSSZi9HT5ifBZCKXgubH/UzU/
	apBnnV8eI33R0a65E+pQJGS8m4ppEFYoPiWKOk9ub+LBmP5RjDbYJpnS5c4ca823YtbAdu
	ZGJvrPmRyouqueEkW714QpQoxzMrxss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758927571; a=rsa-sha256;
	cv=none;
	b=etd5j6SOysBDs88tcmFRkYXBQfMJZGo4W+BPTbWI2mSMhvyCRs3mDdgWQrmtF0Y6h+qEOq
	/2LSiQY0ax1/VytUCe9HkU1k+XRmlJD+USSu/8MaUoBJoWNtyPT4aV0MuU1qXCPueK07Am
	NHCB/4yu1WAaNzs1RBkdwW6RmbUEXpQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h/pXmYkN";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BEE461F92
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 22:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F5DC4CEF4;
	Fri, 26 Sep 2025 22:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758927570;
	bh=rjsCkNwhw++qeGlROs/n9+axW5Ybamo2ufu46Xoo3tk=;
	h=From:To:Cc:Subject:Date:From;
	b=h/pXmYkNhdrajnD3SIofJqZXEbNTdA+N9Bw3cEOaqfcHUcpqsPhh5iboRm6jA2WU6
	 6Zv8YsJDYl7Y911cTBV2g7/o5x7saXHu/dtRZN8fvCPrD9RIBVwDQwslun3bZSqaZF
	 8SE31PHvB0WomMbvDYxPUmTcUU5Su4tCxcpwtlyTz2aZsq7Pukfj/QE1e9e99Csk5N
	 eC4k03QQtmSTRfejjedzRFXnEWhkc18vEJ5c+6elMamGEEcZTv8D0HmA5BvrAZF2Zt
	 Dc+iMNE2NiVg7np0U8nB8+G+usBHRNepqV6X+UB3nyB3ErSLnO4AWauFcdGHz5p4ZI
	 f21LZ2EImzVkA==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2025-09-29
Date: Fri, 26 Sep 2025 15:59:27 -0700
Message-Id: <20250926225927.56743-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9eqbmxtk57njrif7yzn7k5i5ej9syny6
X-Rspam-User: 
X-Rspamd-Queue-Id: 87EB8140002
X-Rspamd-Server: rspam10
X-HE-Tag: 1758927571-270673
X-HE-Meta: U2FsdGVkX194ZtN5fb5Axs4yPNfsCHAWngFgZtqQ10XxrHN+7nA+T3+lfTR0R3WOANHbce3o7P96U9szJ5Bn5GUaDTMl6M582RCh3jkGa6gzaGUSx5EbGwRu5zPzeDtr5Nk3BVD0RJQtbBS1mdmkh6lHUwraOo0BHX/DBkt+00zJnuOd3ixHt8cTz2mHHKUPw8FOD+yiSiAKUEd8hN6qPobgG+esWJSjqYc6jQSvgzub6g1FdacXM0CbxlTxxVE13JLjWkOcrV6v+vQYYJcJJp9smhM6ntlheWzGaE6NhtmxUuWcTxsU/rIOdN+Msc4kKPe4W2N1x6tXWEnYdgyyblHftDrzU85qPM9ctSewtipfgLmWeqe57H6ScDkOGmoutDnQCT7dYOLMkES7DqL9hXP1QBJ/68n4OhIPjRGPgqB38xZjG7TZyddI5jXWUUmBOzxMCGur/uYEA4Vy6zAjKJO9nIkIUNDcPTVXSKfItJzKj687H7wkUWqG/vhiugIGHPhu35eI4hp7O07rREnh5Tj39ycjkPguXTd2r9TIAOv0+EzzWsI5CkfHVXXnA/Bb9tojmepphX1anrgNNSJY1/axLYCKS2x3UGgiU0NAhrXVz/V/VyW2vSXVp9e4FVEvdRO39eYmlcwYOCVzWbvk1WZDyR7T4kFJ+9x2C1kw87bTfPk2jA8wepiBRApfjCL9BgIRMqANw6Fxa+8g4NYby5bxvFXx15FuDVHG4kV6grWXZPJ8xi8ylE+2+c8vsqN0EPtvwrF9Tkrbf0LzX8P1xGRpWi6ChBZkRvXZ9jbZGG1J8hWRstgee6XTLGQCi33MHIrxSWTUpPjuqvPJ2m2HFoVo6efthvSv/RDL8Eo6pqSBxmy0gaLlYGi5y1wFkMTTEbVhU948fstq5vuUTEj8Rzr6xQEaEh5q+d70fDst2qASldCSYZ2dndXySaGkxutKTddgy8f1HpWG/5cV044
 9RPj+oxc
 3Il+fdzkeLlYBFqRSuc4dQTksvSDJYi01zq4DI9Eyt7DG1bvnd5JeY9vHF8Gr3gu3wIYSK91e6BPYc/Z81fxW9IJKXZrf+BhLd7P2VK7pnpFeu9SKclLSR5cFJPFeTsUJSuP3LpUBF5S4RjbZyGgeKRjSJVC1/j8T/o1vcBmF0wEIB1ImT7lMpllvyVop1wrSx+d0S5fj5Xt9y8Our+Az1bLcLl5iOs86cUI7mw5qeWLCq9ZPMtUmNG4wFiVwd9vBB7vu0KnWLQftq8+KmSOxZ98aK/Xkfmxg9TmIZaZAgHe7eLBY+Jlv5Ghcphz5nPT+CA4rOS8wt0LPiLY+JaeKz2VX9A==
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
for the week of 2025-09-29.

We have two time slots for meetings in the week, as usual.

Next six time slots are as below.

2025-09-29 (Mon) 18:00 PT (not yet reserved)
2025-10-01 (Wed) 09:30 PT (not yet reserved)
2025-10-13 (Mon) 18:00 PT (not yet reserved)
2025-10-15 (Wed) 09:30 PT (not yet reserved)
2025-10-27 (Mon) 18:00 PT (not yet reserved)
2025-10-29 (Wed) 09:30 PT (not yet reserved)

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

