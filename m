Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCCD4D3748A
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6496B02B9; Fri,  5 Dec 2025 14:35:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067756B02BB; Fri,  5 Dec 2025 14:35:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5B76B02BC; Fri,  5 Dec 2025 14:35:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA2F76B02B9
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:35:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEF0AC02F6
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:35:57 +0000 (UTC)
X-FDA: 84186422754.25.39EFCC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2A5E340014
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:35:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X2q1VX+f;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jYMIlr5sZlLtMHMecqz1/Hy+Y9yUyCbq7gJT/lE17rU=;
	b=ulygfRU3kX6/8H4UiWJnWktkJSvnuheOCtCSQYdN6eX4LkxgVpIiv0ml+ZkwcpvGlrP7yr
	AAZjqV+tJauIV0+VDlwkyxRs2SLNRsNFmuu2OuRkM8+vRiDckzIrq9V5h/4/f2vL0ZRbJm
	CVco6CKe1zaMUIC4M2vgHbRp66JJbgY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X2q1VX+f;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963356; a=rsa-sha256;
	cv=none;
	b=1rcnD50C80L7m1j6gkNhpb7YzCeXAm/Rn8iDc6XBMPO2jhSqAhnShj2UYo8Yj1eJmZlUeW
	s5nJZkYHexo03QtYQKGjI3J6hpaN+9u0RjZQ+EHoD5sIBNOTe65NJy+oBR/mpNZ0XRETex
	aQIry7k0ZjlUvgxurdRC1PANQW5nENk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8787A60122
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1E9C4CEF1;
	Fri,  5 Dec 2025 19:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963355;
	bh=Jo4zjCKoG72AfS5e5YfO2hAlRtFfxB493GBbVpdnDZI=;
	h=From:To:Cc:Subject:Date:From;
	b=X2q1VX+fPSakm2kn9lOkU7VM3+bYchl6VDy99IAV7b8yB95z6MriO7Qs46gLDOqHo
	 oVrmeZK9xba0I/uQn8CnDddO0nr3aolWK+w4C4XbWCrsLyGhLqu7HQeDK3EuVU32lA
	 Y7zp7m8oMQfT9XiIjV6788caylne2dgns3SNRxpU3dA1ot3uJBixNour2ORLUiRWM0
	 24DkMadpERWJghahN2fWVcn25wDsAabQCp/G2bXCEVJ8swbuRjeQ+Hwj/vM4CY/m88
	 /MyyYtHohUGvElnGU5d+r216P2lRT5wM9LilhOjAvnmJGxCoHL3ZPFcgMBX8uOgQAY
	 2QYxp88BIquNA==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2025-12-06
Date: Fri,  5 Dec 2025 11:35:39 -0800
Message-ID: <20251205193540.75695-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: puftr8pqqqznwf5o9uehojxod9dq9joe
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2A5E340014
X-HE-Tag: 1764963356-862799
X-HE-Meta: U2FsdGVkX19QLltvbtJ7HgFSmRge38du9bqrHNyOfYfFdFhEemO+7rNuLtJwlo6uebcYQC98Knqi3nDGgWLfsDLCNPzLfCn5gJqJluPhZ7tTrw8n+PEBBZ1u3Kvmbms1amfW6CKMT0yRQhjWVtEyUvOp9sQqZEbeo3U4BIuBOmaWxctk4vci+2a02Dg6dY5WKNFoO6rRjPVSuS56acohAIAqifYMy76ffjOarY9Ro+WeqKue8VxsTgal0qGrtbJTWH43w0w36qrQ1DjQY8ranpYTDnoPPS9qZwm9JK5VH8R+9zRctOmlBD71BsB7TJALJT3XXg5spUYDFlqs4Eg5odgbudFriNnYLSPj3IxQ10q/7aFglnQzAbusC9hp2b9mqeeG6aj6GO95clA7sLHPJjCla0c9hXNX+mNpCWFC5a4I4NaE+e3nYw3y/3hzFtiw18xY0C7MZn+SbBAYIXJkVGYLj8T2+eSlv0+KZ9svFSbVyuse9M55mToxVogdS80u2GMFH8gL1STYuwa/wfZXb7O5jVr78GySDMZ65/jHRjuu4UNZD/0GWfHNRtcgElD/q1wEtgEtqHfi4kAQFQDJLRGCYVD7wpW4gebYrqFpa5gIEbeewxd8QX/XEu0oClUIaIh9bkf4hZgVftqYR0AEjajspZrwyaTCEzHi0HHiOKdJkHIv9HJC0jWxJhwOb9BTojJxLAa54m9aUeB21yBnDNauuo8FwuCdL4QErnbpoUfh/wVgS/6uICn/YG5pTrmO80dojJrBw3Xl5G0837YJWP2TJp3E+aTf/RxYahPbfm0Z58L0NS6Kw5vh3WpFdstbbKEs11AMzR2HPkh2/K+Klhwqntdlq0g9cYya/xtfvgOAF72dCQjZxm5C5zmVlH6U1q9CoIcu4APSPWmk83AcY7Ch085EbT/4ufV0EwXwp+8VhzXhD1Gr4WtnMzJl8NQLALhL/jcA7elpEHUSWil
 y595N2Q4
 YO5uhs0HQR6l56pAStfv8rmNVcesMAgRUF4PgPQX7jjMeAzbMY+whLEbdQf1YZzbWqxA4GvLt4O38MbN2Hvnc2sVFD91xqftB2XME8u9h+T2Rt9Dix47Fq39OeNY0uwsWMxWR0RRAhBtPrhdKg6wfVCskszmltiXAqg1WYHa+9Zy5JV/j5L23AMSdcFUq/9POUiaHyTtMsQow/xSRAOkF+wH1NEljOpYP/D1gxMg0Af1eNY8vtdh+9ZQP4QnohJ8b0xi3bLMxh3YIxbs/kyRp7EXZUh0QbH9P3o9iv0qcaQ+Ocsdb+18vGk2PSg==
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
for the week of 2025-12-08.

On the week of 2025-12-08, I will travel Japan for OSSummit Japan and LPC.
Attending video calls on the usual Pacific time-optimized time slot during the
week will be challenging for me.  So let's do the chats for the week without
the pre-booked time slots, but as an unlimited and possibly in-person version.
That is, let's make it can happen at any time and any place (not only Google
Meet but also somewhere in Tokyo, Japan) as long as we can.

If you have any DAMON topic that you want to discuss with me during the week,
send an email to sj@kernel.org saying you have a topic to discuss, with
when/where you want to meet.  Then we can further adjust our schedule.  If you
also attend OSSummit Japan or LPC in person, you are also very welcome to just
reach out to me in person at any time/place without making appointment.  Then,
we can have an instant in-person DAMON Beer/Coffee/Tea chat.

So next time slots including six virtual-only ones are as below.

(week of 2025-12-08 is all reservable for virtual and/or in-person chats in
Tokyo, Japan)
2025-12-22 (Mon) 18:00 PT (not yet reserved)
2025-12-24 (Wed) 09:30 PT (not yet reserved)
2026-01-05 (Mon) 18:00 PT (not yet reserved)
2026-01-07 (Wed) 09:30 PT (not yet reserved)
2026-01-19 (Mon) 18:00 PT (not yet reserved)
2026-01-21 (Wed) 09:30 PT (not yet reserved)

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

