Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45CCECA9EBD
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 16:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02C8F6B0088; Sun, 11 Oct 2026 12:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8076B008A; Sun, 11 Oct 2026 12:48:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9B686B008C; Sun, 11 Oct 2026 12:48:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B15F46B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 12:48:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23C0EC0757
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 16:48:42 +0000 (UTC)
X-FDA: 85310929284.04.379B527
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8E647180003
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 16:48:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S7oKMIxq;
	spf=pass (imf24.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791737320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jW7ekHnfYentRy+iWHdDXOHQ3Lfex2DwvTOdYJea5T4=;
	b=Pd+krGnutl4bWv0VUzYUfZGDq6nTDOwpdBR+KDDKPS6uRZHiJ6UTskzRTFt7FIvfMQx2a5
	Ep+bWu7i2+LqLaKPsBdSJbcFFmGeJ9R8Hy9EH1D2zT9Jg38R5lkjlwnfpmuhwlQltZARrN
	HRWlcWXyrV8r/ph67qTACXssjze+I2s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S7oKMIxq;
	spf=pass (imf24.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791737320;
	b=WPfY4Dixp8Jpg5E0mRqqRB43xu9oX7j0iLUJkhN/bokpWmFy1aWn3u1YxExvvVKShR4jHv
	oPRv7fRS9xDcblx+pl3Uh72DiESzLGy6JQlgHOn3NXKMdh4wI78OPO5IjdZEEzuWiIbURL
	1wW8FMGulk081RNQTWcSwCJmgnbaPdg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F21F0600E2;
	Sun, 11 Oct 2026 16:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4DA1F0089C;
	Sun, 11 Oct 2026 16:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791737319;
	bh=jW7ekHnfYentRy+iWHdDXOHQ3Lfex2DwvTOdYJea5T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S7oKMIxqxgO1NvQDJIrgT1zfe9UA8DbPt+rRSPKi/kjXaC0yQgkRYbINZyH8E5YGu
	 xColnv/Sj2iYh/bMK/bhPy/ZBGyrIxLBXQJUyctXt7orq6MMrkc31fvvLGZ54URrt6
	 G0x6s1fZMJLJ4gSxjtE+jyEanGuDGpCKyGmGtMj4q1nThdi8Xct2tAG207SRA7YdaB
	 TPUqxolI8c6mVfOS/mS5edu61+emhri6udpTA1LqlW8oq1OAnmX1NzZjCv8C1NspTI
	 1dhE8lK2XD/9k4jB412KLynOOO8lgR8I5Q36nyG8sQ/ILSgmwvyV9tYWUhfkZWQANT
	 xN20NuSo9PoxQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	damon@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.6.y v3 0/2] mm/damon/core: fix last region handling of damos_skip_charged_regions()
Date: Sun, 11 Oct 2026 12:48:16 -0400
Message-ID: <2026-10-11-1-daily-reply-0009-damon-skip-charged-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261009134949.11507-1-sj@kernel.org>
References: <20261009134949.11507-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8E647180003
X-Stat-Signature: pmeaw1nc9cwii3gmi8tufwt1ei35tbpx
X-HE-Tag: 1791737320-889380
X-HE-Meta: U2FsdGVkX18j2vs67HyIh2Yu7GkH2BWctQmc5Nx2iDWZppT2vrn/oqoHxbD40wb5dEb2ALh/n+WrNQMGREf8t5plco9I7ZiXuIe2as0u/vfGyCCkRe6iMYGjNHVdP/DLIJ6uX4b01h0R6kolbnQuQ4lQ8aSx0LT9MTYf39M4PjrKOKRMXnSotADdlETX8P6+38hYYOVHuLa8iRlwMgEv6fWpKLfwwdTpdrjLVHE2AIkpmX0/Sazc9sosKHEVZBqWH3AerzD4zLWZtnp15mrg1dAhZBaeLkOme2WVN6wi4UzC8fimxfbz5ioDiQJZlPcVVuUfFVDtouwEnUioIzRUpG7RfFORGk2LeqpJvEwsSdt85GGZ8AYwLZvcDqAj1/hLf9nWWphNZHbmB/+h0odPYJW42tI48ZiORd1QYXqt8Vv5kdS+E6ss7RnZRs5hHtaeKN2xHSrWMZqkTD9W6idrIb1FPOBvd7I41tuS4QZNh3uw7CEod/F9PQ2nZDUsXva4uqUvPV6CfTw2aFGYLuL40jspuy+W0/ToSZ9GwmPEpYHOaPhoXJuYabPWKC3Rvb6ye5SNJUcv+bn9/y1Bu5UJ7g2RMXAdylezO2lA6DeuBhX6nXrPD56XILN8+wfTtjBbXXTsSrcktqloET5MXH+eQHz3dwL07ORbuGhSnf2KU/Fsiw6FXv77fXuNBx/gtodsmpWzLihkd8Ur7Ksi0BHfxNU0g5bspMh2+TAp2FMg5Ge2Vsx88wNwNrTJLsSYR1k1yl+jNM6oPbgyd9dQ7Nns0Lma/EPoMtvdqEbNO5iDwBz3IpGT8VDK/VCO0j7+glGx/2h6r3naC0uWRwc+nzgcSFFb/SpdFQkI0nezlRK6GneOfrrvwAYJ0BV3U6xDN5Cx0GGGkZjXN9BVE72FnA25p+R7zdfEFlkmxDM/VsdqQWQfH1CcVPwJcCULvydGAp1PcCyhwD62hj9ugbpRSQI
 YvsGp+KG
 xk3xjqq1asLkiQeyctWcFuAH4JjYGTwwWSYCUVcUQ2b5MZJy9f38AmVIHjOdEjEdxB8Gxq+G+UF9Nq46SiczB4rywebL6wrA8UrFHgung2MbDfSJSkSaElgJHwVv+pwt6bHiTB2ts3pTe1MfdmOuM6GgzXMpeVYY/taASQJQuchFN5mCGVZsKdmYFxqFFmq6Vkj8W1vvKGzENUem0i/xiqFt2yfL8sVp0bQ1TrJ67IFZf6jkcspxMm8TNZwmKlk+nP1nC49GfRPDlkG2YsiNJ8UMvpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Patch 1 is a dependency of patch 2.  Without it, patch 2 introduces
> out-of-bounds memory access bug that was found by Sashiko.  Patch 2
> fixes a bug that categorized to be backported to stable@.

Queued the series for 6.6, thanks.

-- 
Thanks,
Sasha

