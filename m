Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A0BBC55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21CAA6B0088; Sun,  2 Aug 2026 12:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD886B007B; Sun,  2 Aug 2026 12:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095D66B0092; Sun,  2 Aug 2026 12:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D89BA6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:20:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C7EE404E5
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:20:59 +0000 (UTC)
X-FDA: 85056843438.11.D9183A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D4FD640008
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:20:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bG91hedU;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785687657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EeL7EexGcxVGO5VVZMxodiz3XY6WPJZIVBQfHZICIwc=;
	b=2ivUupTd8MfVjGgrfKos47sU3+XF382zn45IC2e+4Dq7HjEJUgRFWjoX6njJj7fULXNCea
	dgjNSq5dNNuZ80XPK4fQOFT/D7mm9IqtNmvsZOpSD8Z9YZ5hCiiKsqQT5A4ntM0AD1MI7O
	P2HIHSfG6+SJsenyHeQwQY7B25ZJYUU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bG91hedU;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785687657;
	b=IuikEDzvIBVhKQcpC3MoTiI/JybR0LUqQF1LrNVIa5xddLbAzL2wTtzXBe9vt3FWPa1AHN
	CZySITin760RgGTqEs5cD55f+zxpc1pSqxFZoRQ77P/dInQ56DU4PXgpgvTT4nh3Acttz4
	dnvDla57u5FfjHrbB9RYLeh3sxf6dfw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 74BDE60AA3;
	Sun,  2 Aug 2026 16:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E741A1F000E9;
	Sun,  2 Aug 2026 16:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785687656;
	bh=EeL7EexGcxVGO5VVZMxodiz3XY6WPJZIVBQfHZICIwc=;
	h=From:To:Cc:Subject:Date;
	b=bG91hedURWN2K+cf8RTj9098FPlOiDM3pFA4pF4o9OqjQSzKnJlqpUec9dClXUI7f
	 vz/pbyNwzPuxDMrXz6BWtN/Bt7H6T3z8TITa3iCpAIrzA/yGjfjxHzt4U/etzF+j82
	 8MfyAQ7GROCmZL4KUXISbFvR+4Me9ctLRpYkhRQ8Vvs9T/Nxn1ZgjjdhsOv652G3iI
	 y6gX3Yk1RiI2nzNm+hbakReUPqNT4DBj34Mozabv5WaTj676sIYbDOQJ9A14mCYbnk
	 AE/WG2rjb+Z3e1xgnHKQ0oEQFs02lPT51cmUV3MQfMrNdtnbr5M/2A+idcDFUt/X+J
	 N6JmLNZpHoTgA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Yunjeong Mun <yunjeong.mun@sk.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 0/2] mm/damon: avoid division by zero from damos_quota_score()
Date: Sun,  2 Aug 2026 09:20:47 -0700
Message-ID: <20260802162050.89477-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D4FD640008
X-Rspam-User: 
X-Stat-Signature: d479eud3ah1pj9nh4zfj9na77gkmuoww
X-Rspamd-Server: rspam04
X-HE-Tag: 1785687657-14134
X-HE-Meta: U2FsdGVkX1+MlYD1pU7LbUlSXP3a26MVP1U0SdYFKAgPWaRrrS8zOrMRY+NFhtlPiVjjIks2y6BlckdQ31gLhOiWiTDvOCQDWHsJDRyxzlC0nxDltX590yP2+1iOFf0jSPf5SEbyb54ThqvXHSvqWu5Hr+dx6Kr3SgbqD1HArTmvCxl777YdOtl50gVZ5Qd0CTapZmc0PS7HqW+sGi19W+t08AQHkVYIcqT9KzlloaiBk1lYo6mfwyetlxN7GcMectj6X+gUcN8RLtTdiFV1QBiox/hK5aZOy40Ka8dROCyZI9SSbHjKZHXzMNQM9r+1bbnphwAweWzWEYyM0379DJi6xMcf12MltjXupa4It0FznJd5Fs4eM5Kn4k1wpaLH4OynjHxLm7ycJVQwL3oCZQRDkxN7HlTjEWY3tNhuulv8KCGhvZLaIpYEoN8z7DzJEmDPWRUfkEqmHY6ojCjANDAMzQpHhquMxSnT42IfBVkkgk6IGGrNn6sy+og7uL3OixT3/U7BGgB7qUm+/jFKxMFJ/Skx5PY9Bx7D0wm0VyFUbBbT+kUIVeAuSmaY9F7hAhAIzXuPaPfn6tBYm+Lpq9JfZPJiSL63K2HUPYlwV/0Zm5Da7DGaP+EDhLG4CJISMGODgaXcDU9ANnGpaBnaS0Dm29MHnRaBxrKkkZKFCZIEbRBY2h5sFp2tbSPjUpT2DUyE26LSkv9a3XphHzoPParESVvz3xWM/fDbtTfAcajZ0HjaGMSRqFXef1gw/hLF1zDTyM7JsTa2ppQu2rHbja9oRdCUUKbZy4k/xQi8YWSqz+uhsVzVcvkydzmdPBirDcdZfqVxrLEx2RX302S48hCyLuwEb23FinTJoVyAEwgqTb2wuue0yDf4sAbPimDrucC489ydAN/4vQYPzIyK1ZlkTMSGJci/gDDSRGgCdVY7HifM03xnHdunsxYvKvyB5w09nd8OXAgRT2eDeCL
 ICsOoseW
 EvnUITPrVPsa9QFjRwOHt3vrlNQILxHYkNuiIbfPh5mPok63IvqVcmFDlxOEOuh2CkK7OE5IWFOcj8WiAetjmbwq0qfYpZOeN3WCQbErBfFArse18hOn8ccQ9smwKMvaxJQpxu889JAsIAWEkMCMx63niighaJa8mFP2QXSo4J3pVovJNPBCC8j03u9P9PPaYMzTfQFPsYppQ0p3ASzK3ljF8p65XYSLTE0djAo7HoQt+4WLYe5VI2gf2RMIl0Z0PRjXXNQyv2ErAI6KkR1+knuKW/ZC5AfaJC2dgzP8/a4pXXLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_SAMPLE_MTIER and DAMON_LRU_SORT allow the user to trigger division
by zero in damos_quota_score().  Avoid it by adding parameters
validation checks.

Changes from RFC
- RFC: https://lore.kernel.org/20260801211315.2456-1-sj@kernel.org
- Add a fix for DAMON_LRU_SORT.

SJ Park (2):
  samples/damon/mtier: error out for zero quota goal target values
  mm/damon/lru_sort: error out for >10000 active_mem_bp

 mm/damon/lru_sort.c   | 2 ++
 samples/damon/mtier.c | 3 +++
 2 files changed, 5 insertions(+)


base-commit: 51d61cb34d137b13957ce83455c1f596d39e8cfe
-- 
2.47.3

