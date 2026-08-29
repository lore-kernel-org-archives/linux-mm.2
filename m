Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F060C61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 19:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4956B008A; Sat, 29 Aug 2026 15:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065EC6B008C; Sat, 29 Aug 2026 15:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBE016B0092; Sat, 29 Aug 2026 15:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC7956B008A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:06:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48A341601B8
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:06:44 +0000 (UTC)
X-FDA: 85155238728.28.57702A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id BB33C120004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:06:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YSw4cO7J;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788030402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tb1BLYUfh/d3GZ4bIUl8P87FLYmUhsHXohmvEC9YFSs=;
	b=FSd9UHGtMTUodszIpO8ZzrmjN1GY+Xl6Z633col0QPVOI9kWjuBqhPqW+FJCaKMQzi+jGD
	qj/+rHhuDaDxL8+u08MO/z8kvoVkRBsng+gvO+99ps1CHth0gNAK4N1sNKYZEkOR67Lqy9
	z4YFzj9fi6tJfi32Pt+5lzNBpRMFKDs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788030402;
	b=mrjHV70B+0eHSOCmywkFX5/R+IZSegGE+Ju50aMCMCtj9RjlG40ZiosomdfP79GltkR28n
	xw6+iTXKGRoZcNCm/yJSrKTqqEHWDdNqsKQBoymrE7oTmgGpDwajI0gsL2k13+EG27oRVk
	KwUB6tSRmo3697L1wgNUIjC7WkBR5D4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YSw4cO7J;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 831CA600AD;
	Sat, 29 Aug 2026 19:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033D31F000E9;
	Sat, 29 Aug 2026 19:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788030401;
	bh=Tb1BLYUfh/d3GZ4bIUl8P87FLYmUhsHXohmvEC9YFSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSw4cO7Ju5ggo2YsaA4EZbDOYr21Q5mzK/WESAQASnlugKdSrCSYr6DqHvqud4k5g
	 zmfgdG56YuKAfpXaNSaQGZ2yLCPEFYb8fFqqi17d0B3BGUH2nfTT7wwTMDppLo0AcV
	 W4QjjdhH5ONSE9O+ceOL7Q2lDd6Nl4hwGZTjgQYxpruQY+6QdOdIdPnN1HiioTxp/V
	 0Nn03Y4x8h0bPIQueuhCcnVQJfUUSZwIa5/xRvu8pIlMmwJmeZjjax6xooOROdqSd7
	 IrrTOfd6lB3v1mU2wIuiIwHLxVN2tmVFCOEhDUzJwYkSPEQVwSb/F2wC5R6svX4rnm
	 87eFjlt43aA0w==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon: fix unconditionally skip last region
Date: Sat, 29 Aug 2026 12:06:32 -0700
Message-ID: <20260829190633.4576-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260829190327.17400-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BB33C120004
X-Stat-Signature: zit5g1t1q7yh56gdbqyexchis5bd8rh4
X-HE-Tag: 1788030402-313748
X-HE-Meta: U2FsdGVkX19GzBmnr0NODBdbHJ2zEo5nYD11tQdcFSMO1MteY7JZ7Sk3sFe7EyPU5ydZF+18heA2Rexa4uWMQR9jWFA/NuDDgo0FG7UrSVAZgH84LBLrO/DfLECqd2p7s6/lCusSvJg8n2dlhkv9efQdCmXXDVUaGPpmCH9mzvI5qcuBP3OUHKJljRU6zZOX7mfsp4FzacX27foerDtJhOgINliUpl0pHR2Ak6A/WRqrE7z2lx/WheCLR6+G4dx5uf6UdOI8Fcmgc3CZzMXObfxcV8cWJy+eEhOcKqAxHsbbMV3eZvVtVo2bB7/vSTmi7E9LW3+IVuvOVUr22pRXRA2+MRvWpk3n6QcwFQI+GAxSosKUzTO+DUmtgyEE2wi+LEzJXb7PZXPXqDkYkuT33H29at+67KzGXm4jZehakSEQIN587z/QBALtQ90cwK3tu9Rn7qdR4/eigyzin5ng0fJRfx80TP77EYoVYF8FbnXZQgM7fauBR7thC17GWk2lEvTZzsBV1cynsiOqmTCf/HDBQdOeGdNg+k1gmVJMWGJRO5MeG6QuTM+PWxlA1k3xlCvRNbUn9NSztOA8/8Ayd0uT7twknnTL8tUTPZ42ik1E71qvdZ6zEaUh/Lhq47UEc6l2Bt4yoX9TAKsUokndP6rofbmE7W8ykfPsgfa1qbRgQ9SHCAQm3MJ6AKfAe76wwe4pu4MEubLaZmXohLkNbUhbEXYMPQEkb0SPHUz9tVhlFNqcm0qkbF4jMCh6JpKZVdrhiMm7L/Z4okpK7g15tYNvaOxj5XRm+CxebjMy+jFSc3vK87RIQw3sr3rbJf2Y8Iw7plfWiBL8fvAsb1dUDy3pZah4W2bMDrdaZgulOFkzxVK20tgYxw2n3jD1/LtLv2taA4qlkHYTAX37c3ruqxtFgpa1e24UxUR7Kf7VbUn152a0E8VaaxM8tDa8idI9e+54syxZJNRID5t5v5r
 H0yThlKN
 k4o9CcGS7gDJtBGXXDJ+FLEDH1iWdEC4dsYpJchkxaUMmTGlVzgq/n5dbhzI3n9AQEFbnuWoJqoEIy7HuEMsmk8HHNFjtC27WHHnhwUMfXRYltZHQ8X+UDqr0qQcEXoYqJcz6qHfkhIQnrUUyBq7KJjqv5A+67IKQ9jIpttGfCnaP6iMKP43cmoT6YL3iHpl3y4Ex0f2nMjbcD+2U259ihZrjy1hZk8W2u+yUAA+RKgoK/xnpLdIATSKjEgBdX30u9gCG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 30 Aug 2026 03:03:27 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Sat, 29 Aug 2026 09:15:08 -0700 SJ Park <sj@kernel.org> wrote:
> 
[...]
> > Let's not add new topics.  We can discuss this on your kunit patch.  Please
> > ensure it covers at least the corner case this patch is trying to fix.
> 
> Okay, I will ensure that.  Should the test be sent along with this
> patch (as part of the same series), or should they be sent separately?

Please do separately.


Thanks,
SJ

[...]

