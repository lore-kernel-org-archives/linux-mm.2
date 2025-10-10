Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A5C7CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 21:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F20A8E0013; Fri, 10 Oct 2025 17:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3618E0002; Fri, 10 Oct 2025 17:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B92E8E0013; Fri, 10 Oct 2025 17:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B5638E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:38:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8A5BC03C5
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 21:38:29 +0000 (UTC)
X-FDA: 83983518738.14.E4C2A49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5715AC0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 21:38:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kLQyJZIo;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760132308; a=rsa-sha256;
	cv=none;
	b=6mgJSLiknmRjLasMda9Dz7A/h2XEbSwQdEjQUgLF7Yo8L6ZXou3G1MI3czQS0T/88dJRU/
	7wmua2iR90Dswc7Lc/UoeNuXw1BGxDz+/vFRTNEFE+0XxbBGgxoGJy0syssUc7C2IGLLYN
	lK+FqF1bBM58YSxxFpEn7GDZpcf8wnY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kLQyJZIo;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760132308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iiMYutGeEFvTM7QHolDvkJTbdkLoWZuMuALDeDAOh7M=;
	b=Jff1D1fQ07slaa4um1UY7fD+X9ASvnysXQRr8RMx+AG7XtIqxK0cUkji6CcA89+qgsiEL9
	bVVRAIyXzKA90NqJkmF4fbfCT7+mUYMwANoWtGvuskqfXbr5owMVuKUwtt9qJCuqrWJBZs
	zMoh2WiC2yxjAErsTwes5HsX9/Ivy5A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 976956275D
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 21:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211E3C4CEF1;
	Fri, 10 Oct 2025 21:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760132307;
	bh=8OpDKQnSM0NrVzRcvtxCdJM6gCY5wpRNmlgvpcWQ47M=;
	h=From:To:Cc:Subject:Date:From;
	b=kLQyJZIoHG2zHO6pSGAjhApaLRjcMyS4i2E3SHmYG1DSKbBK2gwDNosLvHAKyHYO0
	 nYidffdzZWYyG8KgHsPRearYuUiyYhQU8XvUW7fp1lyxcoHJps7zkVwY+YnEsoJcJF
	 bHHNf6oYKgvW1+UK8B3sf5I0FC1fnurGBk569gmYZuIYTMhRitl7hTza4uyn8iItC8
	 Bl3Mx7oJCfEAkqlSsysPl1ubtbJ5r8Rpct/QZqeOTx4abmjfKIjjuMtSKO2hdtmEQ+
	 9UmiiXKqFE/hZDyGECuqDrfMNNyOUuN40j3oRG9hmu3Deh/htdw1g4freUzoQer8y/
	 pw2rf7k4ujIkQ==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2025-10-13
Date: Fri, 10 Oct 2025 14:38:23 -0700
Message-Id: <20251010213823.59564-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mmkmf7nu1nmr9xxmibuefym3qojgfnx7
X-Rspamd-Queue-Id: 5715AC0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1760132308-383007
X-HE-Meta: U2FsdGVkX1/9pujQJX7dIxG29O9+92nOFNoeiPmRsNpa7w2j6GZidViVDo35ZLINh6deOUgKNG50fQR6QSm1z4xUYDKnQdgxwmyrSt64gZX5mqrMxzku6e5doYCTCqVVW3kSibwxWbInTPx29h0LEdBvb71DoaSkhWBDt7EIp2eL46lDhE/HTWhwIHqW8abrl58EJ/AGQ7u7nWZiCQ/qjBPbvSBSd+PLfBbvAhOGDqbuU/eGyyNAC9dJW0crx6C7PjNA+UlwhoLOtt1auXTRmPS6y3+Sk1MR83+DUF92SF6okeioxDolMCou62rYgeY3fD1StihYHXiBBEOLO1j5Kj2mahJKnLUKbWoIBBPVyFU8oASJF58Ks0pZZQdirS1EjDUN4sb3Dfy53gC8kikzIZGWJfSLBRLh//IRKsYUiuu7E9Y07iVOW1wm+RGOLGGPuqWyE2kSHeDqAg/rNh+mDLBcyMsacHFrsNoaVnC0Rz45D+0pJWtqzpHJYcST3ZbsLwNe5qr5APK6NtU8C1oHinlLSCTCR8FHTbJV2hhu2WKe1nWb6IRuR0F7YYrGjzDFtFfmZgWv3TmQ/d/pIkh1L+BnDHosQ9xBzFwbkacQKkHNgJwUHItL5lu5SIou3tFM1SQ4E7bYXecD+9sUMUFuqgQ0xxARqSRqH7HCMXSg4LeBc7P7VuT8Ecdo3lw2s8oUevUi7CNU4asKftzeNIm6K//AbZWWNh33JHFXBBChArtQOvXg0ED+2agnh8syoH0R+OzlwBMvx3RshWYPNuCx1bG01q+cmWB7siyF0lmqzfNes8pO8Pzs6hErky+u2If1v9ROenXNtI2vCTgy3wYUlMe7Xo959YZZMRbR/t+8Azbzd+SW38NNMSWbi5ODUYljuoNGdoyW7djWr2K1YSu87SPriiIXnVOW7A5lWXGJeV9Py1M64uJ3BjRXSnv/A4Du/vLPCiQIMzSoVakJJCS
 XTb3wl+9
 WtT6HEYx59dtFGwpteplLxn/sTaQc6loI2mDbaUcFjKLKk79tMoxGgQFVd5FNcecOknFoUSPA6pj4Dta2NJmm0LXX4nnVFnRdCzXxYMmBi6AoSNcj2OcLM9n4+Dp8SzGbhrR82vCDXHINRXusmEzS03d6xjDPICpN4CZFQcrO1Vr11542gQFRqOt9X8ieopV+Utd/vztsmqDDlex82VVPqnlfEMfzSl/qXy9oZoJT2wYlMM7zX9uQrCjHMBVvHeEtiqMNMFC2nB2S3WhGrOWBROekuUSsFslVbd1M0g14Ry1dFwe4R4MZP175OZ14thIhdHQ2HDqt5hvZ4Wpp887QjB0ZqQ==
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
for the week of 2025-10-13.

We have two time slots for meetings in the week, as usual.

Next six time slots are as below.

2025-10-13 (Mon) 18:00 PT (not yet reserved)
2025-10-15 (Wed) 09:30 PT (not yet reserved)
2025-10-27 (Mon) 18:00 PT (not yet reserved)
2025-10-29 (Wed) 09:30 PT (not yet reserved)
2025-11-10 (Mon) 18:00 PT (not yet reserved)
2025-11-12 (Wed) 09:30 PT (not yet reserved)

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

