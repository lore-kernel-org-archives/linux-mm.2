Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF145CFD36B
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 01:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085126B0007; Mon, 24 Nov 2025 20:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034FA6B000D; Mon, 24 Nov 2025 20:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D256B0031; Mon, 24 Nov 2025 20:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D35E36B0007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:58:51 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6A4C1A034F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:58:48 +0000 (UTC)
X-FDA: 84147470736.20.7413ECC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7AF11C0003
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:58:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vMo39SHv;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764035927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w8eg3wE+LPPi+ey7CnR3VfCjgfbzBq0jaNgjJd0OWvU=;
	b=H032Gm7c8FmmGi+7I3xvzUwgTP8vc7RqmCznDIr8C4DQMF9bvTS8D8rXApTDLnGUmWdov9
	k20goL4bY7xwRUk/sPqK0t6Fm6r/Sv/SK09SWq49MU69grlypQ+/WORxLzjcCC6frfSFRe
	WW1s9+44a0ZCZNDO9GiPjkrEreieLjo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vMo39SHv;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764035927; a=rsa-sha256;
	cv=none;
	b=3+JSL8AULUowlxa74O4/ErnK2vFOFnRTySP7FxrixAPbAKyT0FTDr10leUhEc58/gscffS
	++PSeXhRGPOEpMFxbSJnjcHagSwuaE5+tbmciQVpYWz5r/onOdSZ/zLGE5nJKm1CNeM+XK
	UvmNpMKMkCnGT4nJuBBPtZ2utTGWORA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC19760010
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A549C4CEF1;
	Tue, 25 Nov 2025 01:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764035926;
	bh=KfSY+SI7u9T/97OGhQGRlPqnpjzp2fBwvnyuyEWMjRg=;
	h=From:To:Cc:Subject:Date:From;
	b=vMo39SHvEcZ43ixDJuff8ONMSi1dMFAlDsIXAnX1G3xynanoz4op6wQQgj8M0v+k4
	 uNSlZ780uqpyv4m8HlhtH0D+LtbnAEmRsfit4rzOHU0TJpUaXSlN0E9BcqoOb1Sqe3
	 sHuJC/dtdnstG3Ol+fwtjJju4EKZMKUUZac0BZv+eibei+mg6itoUdE/TlcPFTdqmR
	 XbrXscxnJ3V0jSziw6gI9NEAt3mAVeWMoMx6MR5CzXt21p3gt3MaLV/8M/faL7GxDg
	 RLvV5pSfYegx1DHsTo332nZoQUK+gey5RVVby8VA0oZCHp3YMQfyxx/XRSgYDsdbUQ
	 wmbxuoNYt1hoA==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2025-11-24
Date: Mon, 24 Nov 2025 17:58:41 -0800
Message-ID: <20251125015841.76180-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7AF11C0003
X-Stat-Signature: sk75bjo7gnjtibno6iwi5fortpxnf8cu
X-Rspam-User: 
X-HE-Tag: 1764035927-917019
X-HE-Meta: U2FsdGVkX1++BDjv9HNzqFq23F/khy6uglvTRjmC6WSF+ypeZ3HGV4U+D0kPyRRw+5eFqxvYtJjeXVqrAzX+ObIqLkgh8JVUlzU8D3PK9LI21bLyqd8sh9Vj74DGfDPZJlXpd/TqKOvHS6C3O+mpWF4X+tY1HQRi0psIP4oYvBPwY08Jpz7rydEIJPnM/nGZMXkgOOjMqFzbVu1JFS2Imut4H5gsloZ+LYdgB7YsWtB2JKZ14JSmZvVdK+3xGKANTZ36Jht04pES4KGTt15As63r3UL9DtU/FNYJvuvEleMl1WACtaSr6jD02LglQBgtqEJ1ew4C2pYTJvlKfgQ63kdF396qVm3Muz2HFkBk+5X+ejYnyhf3SN2WSNRc3xjgiqF3/QV5K5fELOarrQQd7L6z5FJMSToERww6LKfq5VKbWxDE7CQ4SjaNylh8xvjzZNraNhKpp9nn6jP/fktRgp/um4NTZqsEwj95FP2g9hKU+VbumkPZDZZQPmqsfRhQxVszumbclmvySQxilmKNtVCnd4f3/oLiVEhAHeWyB5XXiG1S+fDyLwTVt6IvBdOvG60kKpsBi/WI8XTrzzbvIJer2b3tcSb6PLyQNm1zztUdt1Odov1SbMnOngyvoIP8Th6R9HnIXr2VicYGuHqtxvWSW4MwvYjBHUdmqe6swJzubSKTqNl2I7M3O3iQXmRk5uTc0PbygKRXuZdggPp7mCWEVPSFITGRtH20oRTehXO9bFb/r9nna2FBA4vB2lk3oJFMbT9QwYkqOSjym33fGQzYiruLe/DVoavDLiJy0h1N2qrkuaVUaWzQRw02mTDjja3TU/62lvXMNL5qBfjDZcKwgTUo/7O8ldcNdj/UmLiqpDIQztOklKF6gOZTpOwTWtbAtrGslJBFk+va+4DQEWCb7q6z/YgjkEFDn4J8pTqLCbMPMbXCxFFnr/SGPO638reRInULIXr10MG5nmb
 mugSxXXc
 mHNoPQu9bFXeDPWSGPkI5pPLXLvDsRCTIXxntIQ8bnL9aild/KdHNnk5lkKA9Ubrcbuuwve6TDmaBvtaeDrv0I+qf5N9cR0Sm0Es4CjRJpxYCX7w6OsbfHWlp7d8V2pxKlr09CxqjIpIY/YNmv3SRB8jq0/c5I5HLcju55BOXTQhPhWLihPOG9SYWeQ1bloi/X6hnkUVuD+vylPBe7MP5CcsI66c39VZEUfqAsy+xsvhRNUq8F/WvYBevoMgq4Ds3sqr5fbXg0wk7+fHiIXjcXrcHxI9iLWWj2O+L9LnAM+9W7vkNlbT3D/ISXA==
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
for the week of 2025-11-24.

Yes, Today is 2025-11-24.  I should have sent this reminder last Friday, but I
somehow forgot it.  Sorry about that.  But now is the fastest, so sending this
reminder.

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

2025-11-24 (Mon) 18:00 PT (not yet reserved)
2025-11-26 (Wed) 09:30 PT (reserved)
(week of 2025-12-08 is all reserved for virtual and/or in-person chats in
Tokyo, Japan)
2025-12-22 (Mon) 18:00 PT (not yet reserved)
2025-12-24 (Wed) 09:30 PT (not yet reserved)
2026-01-05 (Mon) 18:00 PT (not yet reserved)
2026-01-07 (Wed) 09:30 PT (not yet reserved)

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

