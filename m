Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF5D5C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59A8E6B00A5; Tue, 22 Sep 2026 02:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B3B6B00A7; Tue, 22 Sep 2026 02:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487C96B00A9; Tue, 22 Sep 2026 02:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2835F6B00A5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:42:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23D491C2733
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:42:23 +0000 (UTC)
X-FDA: 85240454166.03.CABFAFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8A47040008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:42:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HqYXHhid;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HqYXHhid;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790059341;
	b=jtEFPj6Bw5SUTtSyHSmAFct0rVA2qRI9BXX9pV+V3kSoHHgU0kwUPjRFfIZAMrnsmUXyEH
	JwfX21tfL8J/90xE9UZuuKC/LZVNAGcnNmfdMGZzMfANRYHMAGoBtC5erz1IB8bLX3PgXr
	7B983O6mtF71hI5BUwC2nRoA2F8x+18=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790059341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72H2Bkb5mUqaSJjeGrEpofY5BjystviOexJPm4F/szs=;
	b=MoDVlorc0rqTRJXrEljmBnZfocroMoEjcTHHAPxmTPLs3sPyAcf04ALtMm2+9OI2jf5jct
	pcDI4Owjb58QS0WcQiJVjhecJS5SO2fT98CvnCtQpZEV9+S5EYO9Sf4KrVyicihJOm+sX7
	h8g0FZnLIebdXfh14VQoBX2YLWVaD7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEB7843C1E;
	Tue, 22 Sep 2026 06:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA8B1F000FF;
	Tue, 22 Sep 2026 06:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790059340;
	bh=72H2Bkb5mUqaSJjeGrEpofY5BjystviOexJPm4F/szs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HqYXHhidXFx7y5MntdUqFH+xU4Aw4aZkMmgOQpBuiNXHaSLERGIsW2weQZ7UyZUfS
	 wrgtp2bqYW/8XpUQbrbbk9O91DCc4Id5BvhPLTm7CHlYdMgA8RPHusNn13bsLoO+e1
	 bJdLiSCWrJR4zdWLQ04iU0VwjtxsXNhtP46JxdbJXhZfxJZdBnclU/CE9naOQAiS1n
	 lOFTd2/9FWxa3cY84wowbnJrfsDs4Kvhr3aN1SLkupjHDyrxNKZJWKqUaBqcadfEY8
	 IUGrog+BGh6Mxh/VjtXchvGOhyroYR9MxQM0f5FFTrowfc38MItVe4S5PJWQ7tMUAC
	 +413mYZWdHErg==
From: SJ Park <sj@kernel.org>
To: Zhijian Han <hanzhijian1991@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj38.park@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: fix typos in comments
Date: Mon, 21 Sep 2026 23:42:15 -0700
Message-ID: <20260922064216.43053-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260922033618.2862687-1-hanzhijian1991@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A47040008
X-Stat-Signature: we1zcx5ui9dwcyn1wbm67xdq1qfw1rpj
X-Rspamd-Server: rspam01
X-HE-Tag: 1790059341-408197
X-HE-Meta: U2FsdGVkX1/GglHtS6hxcp+VDRaN40hkKvQGMf4wwXgfh3kHV7xUQ1nsK7Ht1q28queSfBfgMiN0oyrEhR2YuMRDImi0uubcZtv2ZQKz8wrluiQCj6jF/CQGBeCgIDgCiuvIuvG9NoatoyAwKW+wrqzDh1b/HwfkuvBLnT7hEVXUdtBLLRv+P0O2vPG23nEW2WuXp2d+ziAMlP1IVUtqE061Da0NID4eBodsRlbjGo26vp1CDfhpndbVcEpgpNJZieA7XqZ9rQEIeTPwOGcvCEb737Zv1Ef0wRDJLDH7AKsXHbMtexpFnBzPRwePCDJYckpX9Q4kcZd0prczE4PlPz5qWeX1zeUG2vKjglm+taqIu89wr2ZxjXjv5ivvzCbnNhmCTGxTtV/lNs9bnD8cnMiRn89AuoGuKHoLO/GQwiPARl02dgIU5tGS88ha4Xb7Oj8FFaobQtBKdsLJ9MSZTJblnOmpdhphvEA5OoEDJXHg0g+76JNXZ9SX0M+q+q3T8cL9KpCgltCfrG4WH1Kvb8PIY/m8HFSG1IXota6SD9mAdW4z4CK0+JcwJg1Kiti/GBffZmULR26fQGouJWxKagWRDTPfCsQhd6YVQO4zjDEB0wPUuK/JvWhobkllcncKkAoJi+/EVbObURcit9e4RhbhmGFf17ZMZRpp35mYuMSc8o7SX5GwBOmeGsAKDNlYHCxzhRq1nqBvMyoJftyoBaScgUAXXsj4XfHoLsazdKbyFDo+jLeTKCV1Y/clcQKAGL3HSSxo4o2cJ9YySX5QWEOpM+Hr16MHjz/JehyPa3JnEJzJFU43qW7ZCLdZsfA53/4D6eKjfIy/yrKLc30qA7I+fa/xqEAMhLPhuMT1PYjbrG3LQvIkI5qsu3UiPdZFia+csaDh71iZEsUsScncvEkYFuEuJcBhss32vdUShJ/iWPkF6y+jx/p09yJmgeOIu0ea6VNsMxQpzHGg2im
 xFyhluam
 FL3wy/AyQZ/R0E5vb+ZeoHdqY2vEq/1zraKTWlz7vBhhSon3Sh3kHM+i6FpQo3p2bi4VAfpx84PTeH34DrVOygFBtivv86rwSKaEi8HqzJbz4o7sckiIn+07dqcbaQIFzKp5W3T5nkKXJlfDmUvowzwaitpTGyBjnJZTjKoP7ECzxB2G9lndp5DL9xjl34PqKXUGao7mEEVsMTIaVh294gWei4r2strPZDiCwKm26RbwO2dh3LF4zTkl5vmDI9nwRXVGljPwOberH//8hyuBL2A9wBYeMVvB7c7JveAfFViJnPm0NGZRlYtrmBhfLP2q16yJ+pHegvJCIysTpqkQ8QoO3sTWz+Q0xuT+6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zhijian,

On Tue, 22 Sep 2026 11:36:18 +0800 Zhijian Han <hanzhijian1991@gmail.com> wrote:

> Fix spelling errors found by codespell in mm/damon/core.c:
> 
> - "widnow" -> "window"
> - "makrs" -> "marks"
> 
> No functional changes.

Thank you for sharing this patch.  However, same fix is already posted by
Adrian already [1] and accepted.  So unfortunately we cannot accept this patch.
Please set the baseline of your work with recommended ones [2] from the next
time.

I also found that you posted another bigger typos fix patch [3] that contains
this patch's change.  That's confusing.  Please post only the bigger one or a
series of smaller ones from the next time.

[1] https://lore.kernel.org/20260921151547.78472-4-sj@kernel.org
[2] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees
[2] https://lore.kernel.org/20260922031843.2857104-1-hanzhijian1991@gmail.com


Thanks,
SJ

[...]

