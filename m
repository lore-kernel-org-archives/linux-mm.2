Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7F4EF99E9
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 23:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AF1D6B0005; Fri, 13 Feb 2026 18:38:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833346B0088; Fri, 13 Feb 2026 18:38:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73E8E6B008A; Fri, 13 Feb 2026 18:38:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 640576B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 18:38:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 057CD8C20E
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 23:38:11 +0000 (UTC)
X-FDA: 84441049182.22.1568B8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6339C140002
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 23:38:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ISOikdQ8;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771025889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=55nhgH1HuuMa+Qr2Tmdur8B3SlOPrWQR3QC4xL6LTG0=;
	b=aH5E67feKBYJhRYKYbykeGmEaT67KulpsJCn7i0P8xaDn1tCR9rudYOX/oGcACFggsdomN
	xREaxp7rSgXQGbv4flnUPhqAvt15Jr0tgTuzVQLkZVdqm9Ge2h0ibKBk2cx4e44EFrF3/s
	SNA1wV/eCPJ+MKEV6k4Oxci6eFz3mlA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ISOikdQ8;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771025889; a=rsa-sha256;
	cv=none;
	b=zNfF30JF5GxnScsjI5LnVUQLqoEpUYcoitsDIabSJEZ+0OWJeuN0KUnrZ5SBIUOyo51X3a
	quMYn7Fo9alUMwg5GuldL14nMSg4RDV9n0dnYQ49wOOmNJbjADe70wJwvgcf0ZJRa8YjNM
	E+TrFWFmz1xgNJDVuMKDg7b12IwJEI0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29646429CA
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 23:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4945C116C6;
	Fri, 13 Feb 2026 23:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771025888;
	bh=CpF3TGy6lubjr9awkXLTeq4aj0LPX2b/2Yx/UJuhsK0=;
	h=From:To:Cc:Subject:Date:From;
	b=ISOikdQ88tJxqrgnLbczK8XQmzR26o/3NJwuu4TYd7el6YEkms5Q37nK7GFa4XwnM
	 pTRiTR0lICJC53jgPf3sbADYS7uhiXze1pvgiuQT53DPA/t9DTVe+VJEteycEyqPNV
	 d0NxMGPZfVdkUzpxlLBudqtdl8Bbj/jtu8Lin6thphs0uai3LTtymEafbbd8HvDdds
	 DFkXg7tw8Zbqaplbrsn63mE5RrBt4JakLcpKzDbysq+M/wP0l9spXd/nQgCkHL3WsC
	 0R5UY/BwSOdE6WK6FI1NgxP5EFcc+av5BM0X2TdhRftaCEdvKRxq3LDQfCuE0dXcSY
	 OUTnI4umL6ZQA==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-02-16
Date: Fri, 13 Feb 2026 15:38:03 -0800
Message-ID: <20260213233804.62895-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ndephekwxkzxghpp7ruca7ijfstxk8xr
X-Rspamd-Queue-Id: 6339C140002
X-Rspam-User: 
X-HE-Tag: 1771025889-531274
X-HE-Meta: U2FsdGVkX1/GJ91TPfmV4rzj5XuD0nYkpI3XsuC9+NRg8UaN+54j9mETplaipZYAp1AOr1CW0CBiaFyA37sEciGpOGJLx2oJC3eSFYNhE346CiPQtKI1cH1zGjaW30u9eEzXAr9lShj7G7AOIO7ffTlD/JT/umlQPlzvEEZwzFinvAWQDv+Np+REERaKegRQeS+aD96LOXOKMOmjrpvldrUXXWNixk3nfaT5+O1AFR3xHki2D7/qlQV4b1mSlh5QkqBEcLCVoetZlUtkdr8FiNsEi5MZq3cdKDn3Ama33I+Gq40T5oJm26Gwe/Vx9Y31NVwc5AaJlCGuPx3E8Ki3/I13ddF2HQEqu9EKmp4S0/cW/njemtbQHQ8qEK7LWyFJfCaOUe1eWVMb/loDnGH7PcAqkd6A/kge9C32WIEEim8OfClmWdHTHg0Ya0iC0fhirVhIDGHT6PQ+0lgGHuG5ic+7+ZAETX7EGDLmQmtYWZL2EOn0sqP9QLbff4A3KGHB1lsWkc7fzWdMERpCQrqIgP4aVmtFCqPxwL2ScGEEl3pWcNwtejbY50/mukdJT9epaGnRKA52zqqhL1+SjqYYHmI23OwDSqJ400iG0H10krKjh8iJVnqNC/xYeYawqwrvAXex0dyA+L3SBr+NmcJNmtdijf3eMfWYxu18WWxyZ/DmW47ruyLBk9/P8SrvH6Baelo/SG0z/Mh+2aPulzIH2BT8QeT43X8ycqJgKmk4XUmZUD9ABUFmzzonZjeHnGT1JDUzVILDNksmGeMIqIvPSKbnZeYO3vRDA3hq48wnLF6FuRjKqcBGxNkvg7wQB7AIgcuB5MFklSEhoM7QAXShGQDBCw2FMWzbNeIxiHDQqvrOQaQy1C7e2Vmz9Bw547zqysierhyuJa5JlrhGP0oE1mMzGhP+j14u29vul12CpkmcTqhJKT136txPJIcCQFltz56bnCAgdg+S5O1suzf
 /JaSnXl6
 p6gznTAmzL3UgIxws97uYMgjE3cVjARJTM/Tijfz9p4pNXQzvFECGXhqlbMhNx+59JjxitW9OhfmoPVliDUPQ9czC+mjNeGlV0HTbHjaT0K+hBvmd7p1ezhLcamytLuivn64RHxKTHNRggJkFQRdOINiOPPrCgWbMXOfqm2bjZ3u2UoJlIZSGcO8pYYM+cmVbfh+n38PqrLdXEuwQFBM9Y1iXKYw/HKQwwNE9nQBRdAni85iinqNf4D9qjRNF/VctDmISkydlnXjfSaygzdmnRrUgyJX95Vs3U7tuz6xnH+AXX4kGvhQTHqdMHkSsm+Dyynplx0nkpPYKfPqHzMzrIzuGWA==
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
for the week of 2026-02-16.

As usual, we have two time slots for meetings in the week.

Next time slots including six virtual-only ones are as below.

2026-02-16 (Mon) 18:00 PT (not yet reserved)
2026-02-18 (Wed) 09:30 PT (not yet reserved)
2026-03-02 (Mon) 18:00 PT (not yet reserved)
2026-03-04 (Wed) 09:30 PT (not yet reserved)
2026-03-16 (Mon) 18:00 PT (not yet reserved)
2026-03-18 (Wed) 09:30 PT (not yet reserved)

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

