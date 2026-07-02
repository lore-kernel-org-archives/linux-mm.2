Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87D08C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68F196B00CA; Thu,  2 Jul 2026 20:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621D86B00CC; Thu,  2 Jul 2026 20:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C2B6B00CD; Thu,  2 Jul 2026 20:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 150C96B00CA
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:28:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACB634017A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:11:01 +0000 (UTC)
X-FDA: 84944325522.11.38BE05F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 16E9416001F
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:10:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lpDOoDLy;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783008660;
	b=6pLbu2ZnupCww2xaS4RddtUIMjK84YQh8hXWiD2wuzY8Uly9DXZq449RNB7sRC2wmHJB0u
	2x8NWYtT+y+C3LEAXausNQZ/bNOOfZvxq9KEp8DgxMvRQkooi6YtQhmfFoJreQrMqysGvJ
	12PZR3jS8/y2Sz6zrCNCy81+sBHYfCo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783008660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YfVzEcUkg829B5uyfjxZ2w2e7Qcu1+uMV+pJJ7jiGg=;
	b=AVgJXOvtK5atkmUu/2+J/69g4RC48ATMAOTsHkkqMQcRx0bY7kIthW9n+BSdFtPVuW71Py
	OdIJcCsdS425OyZYoMtSUm9I2RVuJY3mFW2V3/hIdqJtYfgC3YTlhFoevmUyfkng6zhrpd
	NHQPLxKPoT/TrrPgePbdNSzAkvVia28=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lpDOoDLy;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F50A42AE7;
	Thu,  2 Jul 2026 16:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84D11F000E9;
	Thu,  2 Jul 2026 16:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008659;
	bh=3YfVzEcUkg829B5uyfjxZ2w2e7Qcu1+uMV+pJJ7jiGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpDOoDLy1aaUtY2ZdMR3wKk1uaopv6Mu+Ue0/vIn9Iydk4MSKPPRmiZVd68G3pYXK
	 1QM9qI/Z4zE1kRZ+t/IG6a7Wz2e7oKa+S9jXc7nR6Cu627ohbHFtnJupyZ/3yaYINS
	 1zmEq7CP1uaZdYmgo7fXJU2/CJHJ1pfHaj2uynyvUKX9i9tk2014iyjMwsB7haqKp2
	 FyAvarRUEEBEYZy1nkaicCOfW/57SrZHOh/9McjWEd15KpJ3c83XZj9DUPiW102xdb
	 LsfJVphEhI4iHd3m4wuvwwNAYL3A8h9IvwAAsVJQ2Wa94g3leU0Vozdq513zMIbAWW
	 dzAL1ZaTg2WVA==
From: SJ Park <sj@kernel.org>
To: wang lian <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	daichaobing@sangfor.com.cn
Subject: Re: [PATCH v2 0/5] mm/damon: add mTHP collapse and split actions
Date: Thu,  2 Jul 2026 09:10:48 -0700
Message-ID: <20260702161049.86172-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702065244.70360-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: dm5ty76whyobybro3c64boizze8fw43t
X-Rspamd-Queue-Id: 16E9416001F
X-HE-Tag: 1783008659-444327
X-HE-Meta: U2FsdGVkX1+iqXw862HqHjn7/xRePGEUwFbUWKChg3+lYmU4S+otkGWazfZN6C9EeAhJN41jIohsvflOPoUaXO9w1newH2gKUypv0tl/OGQsk0fuOp5mgGD/TUHsLHi4U1D5RuJofPuV+unoAnUfWcvJqcWNVlh7ZreQrN2gh0kd5Dkdjou0Mg88X+6jdpNj8im0zxaRYCi10Xfb1sPO1fHDNN1ihOlFuvb5iGf2EBK8GfW9+bxPuDBgbF3w+RoCKcBYf3iTHg7mKfvGFoFNOj+OuluCo7S7Xf8qVDZMF4dBEdjNhXtvM5DLirzI1czsdQ2Ofzz6bIeKtOqe6F4uueDWC1j0BWBNTi0W3b3Zfd4GQhNi8duvf48k27LHdeMlIP6sp6pT/TbFM8YeaC7iYD7AhrQzTkwlLOagGM5ihKZR4TI1MXf3sXDg+pWwLa/0bDboOysNf60DTugFPO3z6i4zbPj1wtJ8lz2AGpewRqSouXagat2ViN5BAwQcOXus+cXz/bFGxyM9jlL3UMcJH38q9NPXXQieJY5MbcX2vpAdqSBAiVOWKwoNPPhB+DHdnp7z0qCFXYEiLTtlsCrNqHY2jlkTG1A1xkH2kJYX9xIWvdpq0YzwRUPY4c2hOQIaMIurPrHxRfjeWBw7hkRGMz2g3jxvm/GOXj9qvCOtkX4OEvg5FKfI+vEB1zkq5VAtqceiwgnGOqrUiZKtHo7Xp+AGY0mcG9WXo3U6Qr69zGy2fDMxQKl9uFieBO9Ypx7tky6Yls69KoSxuN2IB07FrESPjp8C/mVeDTtil5PbL5Ak5WLXt3cDNoXFAbGy/oAWNnN3hvnuei97+cIqPZ21mxfXenTRsxHfYfcBJee2Jc2rHuQ8KZaF19iuSUdHd0p2mWhh6jxqEbnJWmyCWJUDYkLPLWYuDc+CLHff0d/TJ4tw2M/40OSeZiqcWN1EOCx0JSoh510Dn8JTJ3fLjVk
 sopy5QGR
 k9dmGseuje1gUdBks7GKDnQZI+J5xv0DEkZ5kYcbQzVNqnAVpTNXd1DzPVRO5rd2Pm1aGHwEkcz0SqASMxMifDSOisnoIGod/DgDT+IQyXWXsYpxA8CiUk6AP+Y7F7uvrLFYU/1YjOgVYDC2tQOZCtEuWooKnBFDl3EOAvuXy4Ke6+yuE9hUQsotwq3PfDmJK/sA325Am/oIhqQYKkC+GojQlNwcCGS/M/j2Avc9JjTmSoRnfJauqp6s5h3c/nk1ckacJybgTiYQmU8o97LaUTRuUlfLDcSrcw16FtjzvdUdRJ0BUYiM7PbL7rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 14:52:44 +0800 wang lian <lianux.mm@gmail.com> wrote:

> From: Wang Lian <lianux.mm@gmail.com>
> 
> Hi SJ,
> 
> Thank you for correcting my misunderstanding of the versioning rules.
> This was indeed a mistake on my part, and I apologize for the confusion.
> 
> I did not intend to claim that this series is ready to be merged as-is in its current state.
> I fully expected to send this iteration as an "RFC v2" to continue our high-level architectural
> discussion, especially given the major structural pivots we made from v1
> (dropping the debugfs pipeline and shifting the telemetry to user space).
> I mistakenly incremented the version number to [PATCH v2] while
> prematurely dropping the RFC tag.

No worry, thank you for clarifying!

> 
> Since my true intention is to gather feedback on this new user-space control
> plane approach before any final merge integration, I would like to fix this immediately.
> 
> I will re-send this exact series right away with the correct tag:
> [RFC PATCH v2 0/5], following the versioning pipeline you suggested.
> 
> Please hold off on reviewing this "PATCH v2" thread;
> I will get the proper "RFC v2" into your inbox in a moment.

I got it.  I will review it soon.


Thanks,
SJ

[...]

