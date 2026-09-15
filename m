Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFA60C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51F46B0092; Tue, 15 Sep 2026 06:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DAEC6B0093; Tue, 15 Sep 2026 06:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1986B0095; Tue, 15 Sep 2026 06:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64DF06B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:22:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6153403A1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:39 +0000 (UTC)
X-FDA: 85215607638.03.AF93BB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 346CF40005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZfIkvoHu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789467758;
	b=yOxxOsSZmzNwYsoQQJbzNCpgKUQwJjO47A15l3dOWRND5lL7BR5ALZ/sAO/3xNMgfuTUkX
	dkOleG+JZtzdkW+ugKWO2wgfpSlb23QQ+FY0KdXBGIYGO6XA5jWPax2monJdvCT/clnTPR
	59Bi3uOvmT6InEmshUxNlPpBdb2Uqv8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZfIkvoHu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789467758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4wyAN/shpVet1S7FZt5snhxeSjOLcT30h3RcCDyECW8=;
	b=mlNMufuTn1qe8QiiDzryi9r47KfjeNBmbNXjXWo3WR8J2SgJNHywX/PQ/c949seMiEBqMg
	CsN7f3dE22Nt+IxXtafJrJfe+B7gvhDbtZB44mMulO5OWHFlERam6mMFoYHfg6C9/M2kaK
	FTJWG45gMY+ZdKqgk7hIABCQqvhE080=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C96FE602BA;
	Tue, 15 Sep 2026 10:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5D31F000FF;
	Tue, 15 Sep 2026 10:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789467757;
	bh=4wyAN/shpVet1S7FZt5snhxeSjOLcT30h3RcCDyECW8=;
	h=From:Subject:Date:To:Cc;
	b=ZfIkvoHuyoWfLphJF9Ux/OT4dkN+zFZQjaLlXaS7GZfJGOmGzf8lg8h+Y74WUt5/e
	 /BiOGflsUMFI0uhczf1E+CDDNEGIpg2rwutvXVQIErFAYQXheRrIn4OsVfapPO/EFQ
	 WAfh6gZSe10k4LqAeeZbC+VmbTj7mdl9Hac/TWj+QeSqOOxeiSOxH2zLnvOmRHt/PN
	 cpE30FHNm/x+Em13Jvt760nDmFNjxbpiIQ/ntoccCY02TX5A3PNPXT/WuBEtn7odIJ
	 /p1ejqDKWjRRK5WrmqLZF7f9snnNTXxYf1MpylBkFfcQCj6IkjV0KYuXfggss/vOIh
	 d5xojTxLi9CIA==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/6] coredump & signals: an impossible affair
Date: Tue, 15 Sep 2026 12:22:15 +0200
Message-Id: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/zWMSw7CMAwFr1J5jaO0EpByFcQiH4cGRFrZFJCq3
 p2kiOXYb2YBIU4kcGoWYHolSWMu0O4a8IPNV8IUCkOnu4Pu2z2+R76jH5nC/Jgwpg8JUoi98UZ
 HOhoo5sS0PYp4vvxYZncj/6ypunBWCB3b7Id6qlH1j6rNVXUC6/oFe3/HSqIAAAA=
X-Change-ID: 20260915-work-coredump-fixes-edf98c80fe78
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
 io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1431; i=brauner@kernel.org;
 h=from:subject:message-id; bh=hiV/G4OIpnMoj2ZHNIQVD88dPVpXmhWYk6cNSZeoQ5Y=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStlMmI2DN5t9OqdXZvGF6dytFdOf3BmmtVlav9lepWN
 n7Y2PHjVkcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBENO4yMpwremp0rWHm9Fim
 ry3/o27Z/L70YHK4ftcczW3PkudM2HyAkaHrn9zNuxfNMva9e8Mcdj2V3TZQIfnoEu2jE7jKGPJ
 ZvzEBAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 346CF40005
X-Stat-Signature: c549f3yjs4hancheitqfx7edx4epcnht
X-HE-Tag: 1789467758-192609
X-HE-Meta: U2FsdGVkX1+JCzC6q0nI99WHgwUcn7abhmRvhR8UqGoRotUNMYIMgnXbo+PrEtNUZ1Zhm0ZaLNAYhz2CDFwkIBlYNiBpE/JaOnSiyPkFDpPovgarreyz9jKcesZy/mMUQHX4X8n4ihXwiZAl3xKw/iPXh2XrurUgJw7sU8w5iHLSMbxui50HcayQYw1KBY7zPz0NCvvBazJSBgXPfcRmd8Trk2l7Qzwbl1ld/L9tXAHwTTMPK77OeeS720ttesWxt0s0okvODyJNQ+FzTvc1GIe9wciOkUrdETa7d5EpPg6i9wvXNBYU4QXekZhUbfwrHEbIqBQBQcxNYL/His/Zka/nQp7zZmsLZVBCX7ABL45H07r3ZQKjV1vdRuUBgEQ2TqxcBR2lXFsRipTwOYv1xWIJ4KCvrs1DifuF3xw1JaZqn+zbJfXZMNmldCf15tarHjofvmIy56TbsL1v30q6SJ94sg9Rj7G2jHsrV6z+SPtHxoDwm8Sp13hsRyh/5JQs5tVXNdhOsRBVv6+hauL+L/cL7j8BAbgbdmNtLdN0wNmVWHJANkLuNnGlV7DAGST1AZQZWNxxPyP4b9D0RaR5Qe2w+Q5TWxWzPnDBgnfbH9kUpIyQ1iVpnAjqM9rGz0yvorEoZgk9rsmV4G8/ILcvNXa07YSVn4DCZllLyvOW2yV78uorVqcr8iSEP4rqdi/XM93Qkn4DtqtAjnrNap6Ly3A/fGnkF9eEb5cFZj8fklPGQbqLc3m/hQM6QCVTbB/R5b+xNOjBARbaEX5DJRvaFpLir2s0mCxAimGvgnKKSAM1q4pxBfkFgcmFJTtfzI400M5NgJjN2z/8mV1gwpcBdIkJoSQRCf8wGvlYqeNhVU+O7FSRCSPQjJtFuRfLLjMzpaFQLnXAEceDjFYNVcY28MQuJ2jX9EyUfvEBUQQRs42SeMbMnVL5uF24RWyXt47eAa8q0YtawWw1xVfAfWS
 wUf1LvDZ
 RuJC+nH+4/buxbNAZEMWh9LDTMWEBQ0Sq8tB62uLISqUeLMYdk6aYzCStx0qHZURi3Pi2WoBle6s2imtFUjYrxM/7EM10FRim4GYgfwD+Ys9oqwy54FJoAeCvS9HOoRniFdWsxOrlL781G/RmEQ/yKiFUPNIUcWexmIFSERij1I6dd7Kmmaqu7M9P05aJNGail/GTrlW5FdYPq7MaIlyoF9IzAviMpnEk2H1jjw0srhsCX5NOQkXko7ahQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

I asked Chris (Mason) to look at some of the coredump code with kres and
he found a couple of things. Some of them I had already found and fixed
but there's some good stuff in here.

@Jens, please take a look whether the io_uring fix makes sense. That
kres thing added some patches but I found them all not very good and so
came up with other fixes mostly.

@Oleg, I'm unsure about the freezer and coredump interaction with cgroup
v2 and specifically fixing it in signal_pending(). Maybe you have a
clearer picture.

Other parts should be more straightforward (hopefully...).

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (6):
      coredump: don't switch a dumper that has no files table
      fork: refuse new threads while a coredump is in progress
      coredump: hold RCU while releasing parked threads
      signal: only SIGKILL interrupts a coredumping task
      coredump: parse a snapshot of core_pattern
      io-wq: order the exit bit against worker creation task work

 fs/coredump.c                | 66 +++++++++++++++++++++++++++++---------------
 include/linux/sched/signal.h | 17 ++++++++----
 io_uring/io-wq.c             |  2 ++
 kernel/fork.c                |  4 +--
 4 files changed, 58 insertions(+), 31 deletions(-)
---
base-commit: b813a7ec026ca59a444ba0a36c2e17ac823eeed0
change-id: 20260915-work-coredump-fixes-edf98c80fe78


