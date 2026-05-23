Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C09CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 19:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A5A6B0005; Sat, 23 May 2026 15:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3046B0092; Sat, 23 May 2026 15:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20526B0095; Sat, 23 May 2026 15:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A21366B0005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 15:10:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6857161BF1
	for <linux-mm@kvack.org>; Sat, 23 May 2026 19:10:57 +0000 (UTC)
X-FDA: 84799626954.27.6BDF240
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 726DD40004
	for <linux-mm@kvack.org>; Sat, 23 May 2026 19:10:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ovOmJy4l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779563456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZKdNn/A+P+yi+7VAFiqvUap6j4seStUV5OfOCYdtPQg=;
	b=IShlUo+2bdb/oZmHNIxj15aAI/4JnN0cZ0iKIvVTJ/N/WRRqcoHyAyxZpVmZoxxGqpP9fI
	KSY6fxqwInlqUfog1hOsrQVVpzOUVN3EAS8NTsWGiFtOgk/Q5pFTDF6sspkOK6J+7YW2rf
	tzucRwSIufmKV7rEs5C6aNnxtgm+h1M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ovOmJy4l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779563456; a=rsa-sha256;
	cv=none;
	b=Xc9NhjdyjT52PDvlVZLxbUvIz1UGcAwvUw5v+Xq8t8x5ExFYwGG0bYC7PUz/XlUIg0qmCf
	PTQV0mLpZpyCnZqSeSj7v9PlSsiRl6i0CJHEtybglHxo5a+ujd2xfP9vqxzC8fBkn7K5bp
	/wYhDRfxg5lIBmmYtqKq4AFiV1SrowI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D90B960136
	for <linux-mm@kvack.org>; Sat, 23 May 2026 19:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685A31F00A3A;
	Sat, 23 May 2026 19:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779563455;
	bh=ZKdNn/A+P+yi+7VAFiqvUap6j4seStUV5OfOCYdtPQg=;
	h=From:To:Cc:Subject:Date;
	b=ovOmJy4leWcJL1PJ9vMEISg7k2WAY+wx22j9qy65lSwOnlBtFvkpHxXs149/S47hA
	 Un3MfueJ8FDcaANcUUsRrIIV9WxCz4QOAQVKOPrQHPYqjOPds6AdBQ3CIm2d93H4fw
	 cv6sSYt0ZcHcdOY7CH90uonvmG/JIjpZrJBohwJVPw3aEBKqnIxRMZptU1eqmlvwYM
	 ORK2hBNdZu43n9jY30rndw0+V5P+PPqZ6XoENeBAAF7bmz1ah7XjDtV1axESkYG089
	 kXQHXYQ7GOr+9/eRn8TObKQ7/HNja4XdYmUq21kE1Joy3Z8vVsN7GJkty0FertH0eK
	 hvcWVAXti/1YQ==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-05-25
Date: Sat, 23 May 2026 12:10:45 -0700
Message-ID: <20260523191045.91682-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 726DD40004
X-Stat-Signature: r1grr91bqeruoddhi8mr6qzafpk73zw7
X-Rspam-User: 
X-HE-Tag: 1779563456-410506
X-HE-Meta: U2FsdGVkX18Mevcyc3oeBWmjWh8EAiriXUfvyDQwrm4KTxucO4d4T2t5kI/xkQy8WN0W9FIOERNm9RMCYHdvu7JlYc8SLowb7F01cRzOpUWiykXfVAhTZQ56bIO3g6HlJA4TBTLWXRZ9tRdHUdGnNWdaeBW5tKXmPRx+2gT+KKEccUrOyl3K/ct5BhOMyyX48UxeQPtf9DCgzNti9cDW2/MgnqYrpyqOWocRwFru0GuTiJRK9uGoIe71dNkWuS20ER4JOOw9DEvKPaWe/aHToRSNfBQr0W70f6kGYTvfzDyX7TkGsXns2ATd7BiX5sun2TVPFECKLrBUs4Md6UBjUP8erwJR8sEaDtewK8MsjcCgd54gK9Ps2MeR/W8ZNlqJyzN+cNsCwkGOrFjC2Uq/lFCwHXnIY8Nj55fRk/VPszCjq+DKXNgFWW7ypj71TMxIQeUx/cM6iRsdjnEEjLNvrwtBqycdhzaTbk+ln2BB2WuLKXxSMDPdBQdhlZFewsJm4qGKFTE/uG4aVz1A46+CpkZEkNpJSTqdhWLiN4ELTF/nnggQ4IcIbEuEIzuCrdQHEdYrKTqyEqQ1dhaffWRi5dBTKCSc3WDmh8jFDT8CKuuK3B+JnQcIK2gxnjbVzn7oEjxjoCnyQsG+1tCPzZl2zt8uPatEY3RlQDBoK1SAfyKP2XHI7+PeMfaANC4XaEZk5Q6aWYYsKI8xVPQSzmusIVNTUVNbttO1Jmcms2YLwRAb8ZWAMapcWLbd+yKW7dqJBqp2LAsdd9GqhO7wRwJxRTIedB4aem4Rny3vPYd/eTEpqa6NybRsYjBJs+Iqs4bLdqIlyA5uVeNDMT297NXrCdQqh+KzScpjiDCDuOpBI6tTCdZb6IzU7IX2uExc+1y/cKO62kli2gVwV8nJlSJMO27V+04K/ZcwcksZJZcAd0TwsXM6p7Q+AmCCaiuraA+ipIBKNrMWqDwZYZAdd0l
 AMQJ+d/b
 jLLIEvaemFMyzAt6C1xjsrOdyumFT74xUZ/ybxslSuAKyvmBu5S3fcQB4V9/Wp9Fv6tOLVNb6xYxR7ZfM1XyKg0EBCQCiTlwuuXnppfUbsoiv53B9DzuOIEFiRwQq24O3ZyC6IGFuK2mfW4u7faGH7br7L5Vjbrf5+TI2LJHvm0hLFGdYRNTk0JNMBtIhZ2wGByRG++AJqIJekfY2m3YsoNFHMD/c+1fUNYqAwEg3mIEZ9xtuPKBKs0RaymtVwCi6j2NlzwpeklVtn/D0lQdlUssKGtvkF4/uMQJPzq3jNEYjM65VWIiMm6jptBMfoKpvRc41IAPETjTBFhVgQY0z0ABNWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-05-25.

The Monday (2026-05-25) is a holiday in my location, so I moved it to Tuesday,
and it is now reserved.

I also now have conflicts in Wednesday morning.  So moving all Wednesday time
slots to Tuesday.

Next time slots including six virtual-only ones are as below.

2026-05-26 (Tue) 09:30 PT (not yet reserved)
2026-05-26 (Tue) 18:00 PT (reserved)
2026-06-08 (Mon) 18:00 PT (not yet reserved)
2026-06-09 (Tue) 09:30 PT (not yet reserved)
2026-06-22 (Mon) 18:00 PT (not yet reserved)
2026-06-23 (Tue) 09:30 PT (not yet reserved)

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

