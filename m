Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 462EACA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 11:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412FB6B008A; Thu,  8 Oct 2026 07:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4236B008C; Thu,  8 Oct 2026 07:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9EB6B0092; Thu,  8 Oct 2026 07:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1F86B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:17:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E0BB140146
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:17:05 +0000 (UTC)
X-FDA: 85299207210.27.6AB4F2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1F1204000A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:17:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ffnm6R14;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791458224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eRfplKRiHdz7gMgIh0TjaeCLxu6xLWkA65cW/q3IdPE=;
	b=aGp3Pkte9XLhSHOUIzeVOOLTRUDerTEnMFrPPyvsHPVRTMWcqRttYBtPPBz1K6JqeIeql4
	+y8VtFEPODWrJHZLIbn+4XKpCd7lhNkx9qko5iSN0jPZ6Uc0nqu95LGmn55XljVH7DSnDy
	lbe66apysn5LGpFx26xaaRUKfaEzIbo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791458224;
	b=PjD5kWIbrGTKv1m/bWhemvG8uwXSs28K/hgXiOGOcupC+bZ5fc3YcxStHZAJheeEEbdTWU
	xY2NKKGmgVe0nGCC+3ZbsA2dDeGV45GJluLx/2D+h58nbGcHFXfgBhyKH3MOz9u3WY0T+P
	Q+D0j15G7NjCKTOGOTmFUub9fyPsKkM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ffnm6R14;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EDB7601DB
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C36D1F000FF;
	Thu,  8 Oct 2026 11:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791458223;
	bh=eRfplKRiHdz7gMgIh0TjaeCLxu6xLWkA65cW/q3IdPE=;
	h=From:To:Cc:Subject:Date;
	b=ffnm6R14JjZobeb6o4xC35qwqQdnDuJwvl+gxSq+QSf/Ia7TOXp7LMzoH3wpJK2ZK
	 BKMOES8seICSinxSNq2te9Ok+6sjF9qfbWWyiUN/mME1edMuElY5Xg5Ac8u5H8C33n
	 lJUAtIIulk4cst0BJGN9753F3cdCGUfyjEAooxJ0/szsFptIG3a550uV9yRqyKQ3tT
	 4CKeDzL78QRym12xBu0A5jlwtEBBkbokfiuA1GfqK9Cq3oVRNUlJB9ncANTNxQfxNf
	 nE1KSCjk89v6iTWnWN56wP4p6mBT/Rjaujxv2c2bRWuyQk0ERIbR8a5RhT/WQ528P5
	 uCRZr9YCn5mFg==
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-10-12
Date: Thu,  8 Oct 2026 04:16:58 -0700
Message-ID: <20261008111659.42463-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F1204000A
X-Rspam-User: 
X-Stat-Signature: q9pje1kpwk6kqzqi3gubcfx3wxm1t1sk
X-HE-Tag: 1791458223-788586
X-HE-Meta: U2FsdGVkX19NX4+PPHz9UyQMolINfeEfc2oDMRqZNoo/JbhWFRlE97KHhcrYmqUyQPnh5s5GrbRpYHxsKLUhK82wmhJnT7P5aPWRUIztsSOndaJYJEntpRBOHbxk25VHXKVVDOzs6kFj++Sd0o1JHsKB6rglCYEafJUztytojVsiRyApH7+i7wcjavwImVRbPYp5XiVJiel9qjcRJ5D8t7qFxg1Pq5X9XZYHcCWxFMiVB5wPd7swqq6mVnHoxzNFUrGvD2viYXOU7Ov/7/ikhFWEG6IP+R8jxGEZ8dUUo1lMM+gaZa72uvhcL8gg28I1d2MkqMDtIs3tQW+T3ThaWuQYuKDMtc727kCvYrfwKTI9XNMJtI9fzz52E2x1hTuOFlQsRsb37Sa8oY7ybDQ+PlCWkZy4eb6/6NXB6H93CgUeG+j+lQSmcj7elkpzmxe7+aoqpx0eGaNF5rt7GtFWFZ7CRMVtqvA1X0jxG8NVEQmp8nV8WSplCVWGI/6MmAo2FUFbAbUPjJPGCuKQee6JSjmHjxSefL7UAIY/12x32AWZni1iCjmjnylVBjQRuKlR+NUarPQHdTxwSgHWcOdRpCFaO2jgjseFd0YdWcF18y5R07YxS6coqxgIQdIAIhnoGkkIOZNVb2fR9s9f2q3O0Hg1T4VhBRToXGvd+AfUGmhrCkMBO0OqT1utAzL/K3txcpuYapAUtgX2PwZlRpadBlTJSNsiubgxIqj9GDfQ+NPGhe1/Lp4XRm7RqJc+RHNu1iJEcf9odccs9aMsYzOTWHUi0Fi7ClnZZY4PxaR3RuUvCVL3Ge5iOBA48CN7Ojtm6A7Gv6O/BL/ia71BmUa1pbQBfsQV3IMTValORqxqIHKB56lfQCQvAfAD7p3tkSdqFT3m4NNF93URb/g+EJZk5bBqfZuAQCap2CiPEf7yn82WROAoKQHvfrF0EHK807f4s8qxv3wKciyLevp0UvS
 DiLl94JU
 hEPvg7qJvN1cbW086vzZ2GebyvqCBP+RQtbHOLNIG9wrRJpVTpCxyfv9W0gX7z2tE2qmddIGy8lg7BBDnD1xtrntm/MEcd+MnVA6l4xf7TcQahVqBzqOEBUy9HvDJvJ72Jraz13iz1dBWGLSTMGXB4CV3BJKkYyXwQkvXdF/gEzepmFZB6dmsTmVA4bl1DDR6QokQeExilst5h0t2MBNSf03GajA52N+Ogeilb/hLNT6Jy+OSOXAlscYaI0Kt7Z26g1uO9pNxq904a7q/jPSt+cYgbWjC8jYgqVnjvEuJ7Xep6aSFHfBEZciaDk4jQ52aM09ZuftI7t49ojv5mpyb+8s9Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-10-12.

As usual, we have two time slots for meetings in the week.  Next six time slots
are as below.

2026-10-12 (Mon) 18:00 PT (not yet reserved)
2026-10-13 (Tue) 09:30 PT (not yet reserved)
2026-10-26 (Mon) 18:00 PT (not yet reserved)
2026-10-27 (Tue) 09:30 PT (not yet reserved)
2026-11-09 (Mon) 18:00 PT (not yet reserved)
2026-11-10 (Tue) 09:30 PT (not yet reserved)

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

