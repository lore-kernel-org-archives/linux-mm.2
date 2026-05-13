Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B29CD484C
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140C66B0092; Tue, 12 May 2026 22:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117F86B0093; Tue, 12 May 2026 22:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055A46B0095; Tue, 12 May 2026 22:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE2586B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:21:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94AC41A06B0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:21:48 +0000 (UTC)
X-FDA: 84760795896.28.ABB75F3
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id CC29A40005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:21:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lKyfGeeL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778638907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sX++ejkOPafDrCJ8wkX/GdXVsfydpkaBhchBIQ/8mQo=;
	b=th1YuXV5Af2DM8rcHpgXrWjWyrObvtoLdAvghdujanJhCUXst5gM8MH7jfmm0n24accuLP
	FG/7eG8rtIW1R0K8dI0I/oqU9GCiIAwUCVCtMtquxQl+HhVvyUh2cI8bXbY1As1z1G7R4Z
	gG7NAE19v3BloTitzCtdLO/5Bsk4+qY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778638907; a=rsa-sha256;
	cv=none;
	b=1eST9cyoR+x6OssE4ynA41gN2+miUd4hASHAwg/ItOvV+kbfTKl53/9Q0J6YylXP9mSqpa
	rqMV6tGsoR/rD0o916U9eQMqyYDkkF79KD9Vmh9VppM6uaRRexM1zBOEhlUWFpRqlZC/fH
	rrkiYta7qvi1EL4zOol39ZTyj7B36LA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lKyfGeeL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778638905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sX++ejkOPafDrCJ8wkX/GdXVsfydpkaBhchBIQ/8mQo=;
	b=lKyfGeeLeAoR3RaD4J1Faxo0d5sZrWKlbvE2Tqh5c3icxdhgoWP6cLbCVNu/vv5TFjQogf
	fqtbqt/OainKm6Fo2a9gU+EUJHDVlcE4PYvmzBNRn0GyXvj3GodfXHN62zrKw9jl8u/Cf0
	KTagGTqlCgGUo39xMUc5xne8JBPL99A=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tools/mm/page-types: Fix kpageflags option argument in getopt_long
Date: Wed, 13 May 2026 10:21:18 +0800
Message-ID: <20260513022120.58033-4-ye.liu@linux.dev>
In-Reply-To: <20260513022120.58033-1-ye.liu@linux.dev>
References: <20260513022120.58033-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CC29A40005
X-Stat-Signature: b7mjx11zqu8pnj93kbph5xmjdisjpjoq
X-Rspam-User: 
X-HE-Tag: 1778638906-889453
X-HE-Meta: U2FsdGVkX1+x45y5G1mArExnUzXdM2dDLxDL+aPicdqnq/VXsUlPdhN8t8tJ2fP0ZZGOfkzcEw/etnrBv3XPzToxo5vk+6Rv4U5F9x6hmc9iGggfdZuO9s4fiI5sfd6d7u+hg6sngt3x07k+3u9+00/0augNRKQ/z4EqoW24qrHh1zEj0xWweBv0vJQ0SCw4mpkrRBIMgYwO1YPZMLArM+ZPxbtzUdLgGV2odntl0V38bi87x3hu6Gyw5PefUZjHVW6YtTlBd9UJzINczgeHriCQUObr4hwYYLSfYKiGWZyu9GH/LUwt31jgsCR1Ef4yVsbfXRWoJm7DSa2j8UXEEFBVqEt9ce3QuT2LMt6NsIBRtOZhfqRwNQCuhjBXHYtDBIJOOgExsraiv3vUNacPcCbEH44yxrxXn5/lbzHld/XaXL9tQzSMDPlBVUNJa1uP65DhkCpeYZXb1wE4A5UA1Yf7xPqwLIDZ0HVdWKblwlS3NFTUJDkpOoiQSabbYqAj0XRw4dWDzblg70l497x99ed0JXCqzA/OXHiqwEwhyRyZHflKtBj6oZabApNvPzadYrenv1uGnKHqXp8Pz9uoSxR0rpog2pPNiYZ5gYpUoMsMD5/kjTUnfnHqH71tgsyGkZJV5JJG1lOXy6bAlIdVORudHhXzQKrsqaBL9gsyF2DjQgQw7nRP9qU6O9A9BDbgyhwKXRgqKGDku+xZuXGWwAfYSSDuK7iLtYhhDvi++lM78OG1Pzv7lLw6PG38glCkwWVbvkJi1oI3TK4Nx4JFSSebnRbKNX/NvrM/k4FG19KjkPef5I+F44ao0+94vO0lSL8gvpgvxOllvGiF7FgStTM63uaA//EEqMH/BjNroV9avIyhN2JaZaNaM3neQUa95SSPFiawB9rY3pdF9Cs7W4+wNeApXypuxLHHDGdiiBVGj32l8gxhzAsobDYSz3LsD4j4UWdGkzxoGbuwHzb
 sVhJM2Qr
 CXaAIvWHOObBIU8I0TECOF4+hjeqiVet2zTWXkyQsQHkPL4M0aVO8eCvGU3M6nlMeRc719QhCCiY/PZtlXXfuonS0nUy+byD3aJ9VBtYmHA2eZhdvSpAwOvKJyy9MS9xMZc7ak4WsVPN0NI3T3vdRfLo8fqWSH1i0TMiJETgnbSK6OekmfHITN82TPGX3dBORx8R+EbAx1arTuoqVF8CqeL5Oi4aBVvLET9DShRxX08wrsrIHrKTy49RWcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The --kpageflags option requires an argument to specify the kpageflags
file path, but has_arg was set to 0 (no_argument) in the long options
table. Change it to 1 (required_argument) so getopt_long correctly
parses the argument.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/page-types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
index 66f429f2b698..7fc5a8be5997 100644
--- a/tools/mm/page-types.c
+++ b/tools/mm/page-types.c
@@ -1261,7 +1261,7 @@ static const struct option opts[] = {
 	{ "no-summary", 0, NULL, 'N' },
 	{ "hwpoison"  , 0, NULL, 'X' },
 	{ "unpoison"  , 0, NULL, 'x' },
-	{ "kpageflags", 0, NULL, 'F' },
+	{ "kpageflags", 1, NULL, 'F' },
 	{ "help"      , 0, NULL, 'h' },
 	{ NULL        , 0, NULL, 0 }
 };
-- 
2.43.0


