Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9179CCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 17:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFC148E005B; Wed, 15 Oct 2025 13:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4148E0005; Wed, 15 Oct 2025 13:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10728E005B; Wed, 15 Oct 2025 13:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF8878E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:10:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 64EAF1A025C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:10:57 +0000 (UTC)
X-FDA: 84000988554.24.3AB7F82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A0F0F40016
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:10:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mtOrVBG6;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760548255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOM08MgplBaX0nbZSw3Y5E9OxQUTKUeguX0q8zY5vVU=;
	b=u7CqeqPRx59/5WVS8DS2+t2o8trJRHfNBloTaLEeqNw2Wb58ovqGJenVhFZQVaiFSJ05Sl
	vbdW5VlbyrO16NYsHZ5Xp2a5NDPBAymih48USvw5T0zVYZNd3YrHNFv6G/Dp+ucWbcRWFP
	X+mSlFiUkQaeQPmubuZNjtEXJMczFNs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mtOrVBG6;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760548255; a=rsa-sha256;
	cv=none;
	b=VP+gsiuOFIl+GTq76X11dmUnUWz5gUZ1B1mUIKY86anO1Y8ibhe6gMuQtWb8z0qLKOrs7i
	uA5ORB1xE+M5QqFWQBhtybYjD37YAwx4p4440keMLzcHpAF5Lj6fp2YsJhP2JrzrbkQKS2
	k+5rrOvrjf2o5gox7CEbZlvFmsGYG2A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B4B444080;
	Wed, 15 Oct 2025 17:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A15C4CEF8;
	Wed, 15 Oct 2025 17:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760548254;
	bh=6lrvUB045PTLgH5UIyEfsTNuiOjA8cUHNctXDeAItWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtOrVBG6Z0sgCRlPwkTylhWK1IZrJ69hezqzmetoSw+Bo0WqRWiXFRnjbG4BaydR8
	 UL3HFvVQmEcq1pfCyWkOOwYe+Bf5Iss+TycMJ5IIO9ceBDHE7s4IPpOFvELoYBAToj
	 bdFZUSqe7IbB10cH9GxKOzBt+Dgw8rijQh/84Z+irup1T7poBO33mi4u6BEHag0omX
	 krdEJ+yL4cTe01H/pinOfA3xCpvic9vBqdqExQIt/ctpnOhZeyKnrlKLKVZE8RtYKC
	 veXTGgrB2iCY3V+etcCoYUYxjk//dwqVfHSIplviO+UhX8nludNyGtd7IQ9IpsOTdT
	 jVvz6ad3Bls8g==
From: SeongJae Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/mm: use <stdbool.h> in page_owner_sort.c
Date: Wed, 15 Oct 2025 10:10:46 -0700
Message-ID: <20251015171046.69535-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015093851.109663-1-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A0F0F40016
X-Stat-Signature: ydn5cyys1hrc46o3ydq66ggoxp69nwiy
X-Rspam-User: 
X-HE-Tag: 1760548255-882867
X-HE-Meta: U2FsdGVkX19tvcVh4NAG1skcSq5SO9b/bU47wzAWSp/7zKCCtE3FWutPt3ul3RS1y9PeXlQkLXY9UH9To6KlYOR/Rbn4hE5ofDyIfwT2C25lxrHSt+KLkNMgJOlp2oYcs+uvS3iZBSUUeB/B70V7MsFd5IX68lLumbSXJqfMSrfgJLtF1dVLp+BFBq3lGSIvkggYUzUkh91BuBfrvSK+fxk1YABgEAa4kYg07WOlFj+Z5/QsoThXz9Qd2I41NH8p6auLsUNNx0ApkbUJfsyVGMwCCsOt50gmw8AXHqfS2SRdqpDFhw7HHu5riQrJpw7mnp6mg5+Fc2i1YOnxKSR7EEzspmfLKLFooSiUNnfb91p96P616gPZD8xfgpDj+k6VOHZ/SBki5OSSAU+2MreafMC09HoGZi4dPp0iMvBB1p2vWuJd4yiTTLBguPn+DJKVPxkUEn36QMSEwRPk4UkVVscryla4kDOHYZK/pkJMl4lxYPAgzCsx+HaiHQxRmjlpJFCBtpEAUBUc7/xuYE2Rj8GByMZGYcw42H8XLMgnZEFrFiraTYw/7j7d2xSQ524n8Ew/EQdzmz0/bvXf5euEnLyxoSVzrmBXVFXRT5ekW2h855QT74XG87TIw7PRfxXHKI5+EkgvKvhSanU9GxswA3kTpipslPpHLRjvk3BQ9rEPkZpXTXT7HuiG7QlOfHpo9k22K5hCsfW/vvPo/JNzRr6nNhJ5xt5JDlBEVXhwz51OGK63kebX/+WXklNvOztCEBO4lFXzkhCKkMD6K6adVGjwoCqH1nk/FBvKL6cjwVKqP9qJYmntmggW8drLzaCtehmyMNNDq7OvoOJATC1Jy9eOGlPLBnIwgGM1xveBw3yZsHcJMQDFHgHwSBn7e/LJ9xncIc13xjpXA1SMpzF6Qss17YcNUr+nAE9Bsq6P74YY0c8KCxfzgkTgP1gDfyPl+2YjYdOjxHC3juk+Z9S
 qLHgrtDQ
 S/4OXqMBWAZgt4TteXdSWIcQ6T9BHK6gCeG5FMjqYO2nsS2DwZLCXydblstfL4AzLQxbFSoRXHF+04lXwoWxu3TrLSXazVKRTD2Bcpu8B/FL6pMxq+4wL9RSlPtbLasWSYWW4g4rdvhqHo+WH26ntPooO8fm5itVXaoXk2a455Z205XQaPe2bunsI7658RCC8kJ6wtaVRVf/Ix8NBtFdY0LbtdizXajVk0XtM9AsdVnIYstXzhl+QBoJmBsge5vFs2rGLTKAKx70yTX6TINxV8/4ynbv5nty8xtj6md+UcC1/2nNrI3oPFyk+TywcrVGy3WIcK/tyJ2y1A4dwSMUceLzTywEWTMloF/k3GNJOfwPpqMZ0sGS/sLCu6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Oct 2025 17:38:50 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Use standard <stdbool.h> instead of manually defining bool, true and false.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

