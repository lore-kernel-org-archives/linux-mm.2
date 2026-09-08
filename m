Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51811C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7452C6B008A; Tue,  8 Sep 2026 10:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5076B008C; Tue,  8 Sep 2026 10:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3C46B0098; Tue,  8 Sep 2026 10:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5446B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:50:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CEF2E1A064B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:50:45 +0000 (UTC)
X-FDA: 85190881650.06.052D20E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 30E531C0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:50:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aRMevG6J;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788879044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pQNrk3rJgyZaUFqdcMUHuETyCztvxyMaMetlGBU29w=;
	b=mnvO2dJrTQcIfu2EitBqf9bGDbVZ/oKyHOF2LgrU3+6WX26eomC6Dgu+ElGyCvfPn1H/V/
	AGZk1QcALaQntwyQf/9gtxUOrHK7x8sbDI/62N9nQMxqIkbROPb1sJg3xKdNvOUDeNxgRJ
	1Efp4k0frP8D7fpvzAS9tu9K+y0Y2ZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788879044;
	b=8al++NCoYD02lHImYT6exwVj2QsyurhZ6xHahNI7fuA2bW1vBAMPEeZAExbnFOE7Ro8RgQ
	nKtmdrjmtaoiz6tHx61ZaXcC7Y5GJ5Vtrj9kpZJXWw+DiY+qei3k/DhVfmXojfTq4lWUp7
	48T6Icx8bcYhAAlH5Q2oWyy+O2dcN7c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aRMevG6J;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B9D741427;
	Tue,  8 Sep 2026 14:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B191F00A3A;
	Tue,  8 Sep 2026 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788879043;
	bh=1pQNrk3rJgyZaUFqdcMUHuETyCztvxyMaMetlGBU29w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aRMevG6JLVYkL0wBFdrn6ynusrO/tCacdQm5POZg/Xma+pc21b9eOr63hXqZVDX9f
	 9nT477K6WHXvIvUqT6uVuj1B7p3WRGKeVzdI6hs+E0l6jIIrkMF9jHQR070UTCAahJ
	 wZLx0jeH6LJZCeFZUcmwL0l7bnLW53+qLeHyhAUtk8AKUc7c+f9ZzWRSbpWD1g8+Qr
	 YV790KYMzuV2tfcxOxFhTO8ZTE0z+WDRbsvhBlSxJ9exPaUwCLteDLpNsZX2a6J7sN
	 xPU8xSOrnuQ0nySeg5/4X73+ayIqQxsMkHW42K+HrQ/syfaKwYG5fGZ0qKHfcdOlPI
	 PfGAbb4pZTkXQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4] mm/damon/core: allow esz to be set to zero
Date: Tue,  8 Sep 2026 07:50:35 -0700
Message-ID: <20260908145036.104970-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260908135413.97570-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jrgd38aa9zzgdm6r9z65gjjjg3aojf1b
X-Rspamd-Queue-Id: 30E531C0004
X-HE-Tag: 1788879044-226445
X-HE-Meta: U2FsdGVkX1/S4l7V4ntGySWKQ3v/FUSRsM2sYftymH/5m4HuKJ/O8mEC8/TvpDRlpchOIKARZD9kI0iKq/nQfvQZEdxx7cH/f9I3sYzvmEiXewHljQDW/IDaTArgzo2KQ6raD9fUy5090JXSKAYuIYjE6ymV3abjvot+gJG2WFJ9jEw9NOiaEyicpi1/kbbD8G4WxdIoYWb2OSfK0/KydXpKddCVkWC/pDGnwDz5CFWBfIhticY7jd+dxFMoZFWzP5VtCEhNxNLyzEqJ8LcIXX9Las2f3aN1hKIW/kPhE1mgNmRIfmj46j0tZUzcjHfIBGZsJQlrHbsgyf1NULbsBmxxeLA+ob5b2U0FA8eiC2a2sLmkOnUZoRCYmZBdNCe5fA2rHBu8xoV+8wasb5S07WGahgGnaDvBzxSPVXgnp40v905O+FH7D8TC7x4bwm5MPv40RTw1R8jjYnZEOzgc3fDgIMZ4zEYNiqnaPobKf8C4AxyL5/dt3bs/Yw1kSJ1sfJpIv7C5xtJwCPMHcACdv+yByNBP/Z+BDVXGmc5EjnF28ux75XL99nwhlsT2Dlz5UbbLO2Yt6tUV42YY0yQrBIbN+ZvUW+bsFgxhwuTEHu5JqmuqKgjINHSdJ4EEm7tI78Cz+pnY+gOwlLnGvbMpOryn1Cxbi1iBKn1T2gw4c4nX19uVmxUkGHtkEiDEnZF1x33Z3LLnNKX5nIjwDYZfFL+yFNAfknLDayHgabOl5a2M42WyzYeWlmKajK7ZM1ol7dl0zH4VGB7xby/OpGxKq6ZpoumLmrV5QyMYitoiR5SDfGtCqrc16qkFeXI+4bTRDRD3mX3ftt0Z+POcg3M/9HzyEb83itoT9cZEaULrBvK/xMw4xl6q6CdCYYx8QLVlsg+SH2PAiR638G3w1XKX0zOcOWZB7oXfz7nWR1WS8bJHIGpICuZ4L8KaqbI5SEN6F9cU7GbUK1yIH3c3U1k
 SpL+p9zc
 eXUcefm9ySPp4GpmoXdNMTxeLmF1zZGkRnOq9SsfyYGWZ+la9/OHZlNDd8J2sHUgTKamygKvgKQDO2p/Z8AWaGObfbU1oR4bXLDOLSEbUZbln7R1j8iN/rbA3swnJoCt06lNnAzZOaPQrFzjsbKQgsm/mKFOc8LLJRKK6Hd9eOpx9L5glvYehpH69zB4DEw6mjHbgGOaRkl2dyz5r8ZBLW2HN1t1FI6P7krf9/B10Pk24gp9+BiRxEbthE2Jg+zS+Ya3u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  8 Sep 2026 06:54:11 -0700 SJ Park <sj@kernel.org> wrote:

> From: Liew Rui Yan <aethernet65535@gmail.com>
> 
> When the temporal quota goal tuner determines that the goal has been
> achieved (score >= 10000), it sets esz_bp to zero so that the esz
> becomes zero.  However, damos_set_effective_quota() clamps the esz to
> min_region_sz when quota->ms is set.
> 
> This is a minor issue, the main problem is that it doesn't match the
> description in the documentation, which state that if the goal has
> already been [over-]achieved, the quota will be set to zero.
> 
> Fix this by set quota (esz) as minimum as possible.

Sashiko found a few pre-existing issues but no blocker for this patch.


Thanks,
SJ

[...]

