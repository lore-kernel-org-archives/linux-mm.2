Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 371EFCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148A66B00A1; Fri, 26 Jun 2026 05:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11F7C6B00A4; Fri, 26 Jun 2026 05:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05C8C6B00A5; Fri, 26 Jun 2026 05:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CED616B00A1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:26:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63CCB1A03CB
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:26:12 +0000 (UTC)
X-FDA: 84921532584.28.88715CA
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id 706FA2000E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:26:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=LS6nu51m;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=tBCXf1Hk;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782465970;
	b=rnfzZycxUlKHsI1l0+b++NrnUEQX3a4XoLu2OfJp9Z8BrQw/QpzdMiWwLyxVyP6DVXTZcn
	Uvnf+46t4w8W+5Ed7WF5tpCLEoMQ5T+7yt3E+JXNHY73JnGys1ImdnuYVKkuPrLGW8+HN0
	4NzLM1tIL1I6yfdQaqC852DCKvT1KI4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782465970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESLUukbTyuXFhgfd0D/+0BdDSoyQJQSXwbpAwcEaCdQ=;
	b=xoA83UGVa4PJiBSRRfvNGL590qRCP9uUvPAQ2Sirsc1OIUZD9T4N1CBL7qnQYl++NvWHJQ
	UlkEV5ZwRcfwaNuoWhDfRlb6Fu7IajJlTfGVeFpYSLiRyiA9dn6STY9M8U2j4TkbvTgU5J
	vwguHlC+C3/Orz5SxZkLVrV99Y9Yy4c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=LS6nu51m;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=tBCXf1Hk;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Fri, 26 Jun 2026 11:26:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782465968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ESLUukbTyuXFhgfd0D/+0BdDSoyQJQSXwbpAwcEaCdQ=;
	b=LS6nu51mQxNJD0vxddn78QN7H3lj1LTRjQW+ORQiyipYcUwrVFwHEkibqkaEULhxParD8/
	iw9QTlFesyAoubBPzc7aRwLJNySviBG8aduI1U9oPb/I3Zj22ljHzgrzS8XKiVgamH6FdH
	6YDdv76Ew69tKZga7l0umA+ayuqnH1QuKvGRLCkMbHpa1vSWYajShZIyQ1ElTGGCKZzrkv
	R2tYve5VPiF6Tyz5SRTXG2EjxNbjZyG/l6+/AeNxusLzbUHX8PO9+B1ZKy833Ar5mPdi9R
	LClabLtuA9IyjYlro5oLQLIWq5T8OArDhTGnjc5FIz3kk8OPewoOC424w01CLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782465968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ESLUukbTyuXFhgfd0D/+0BdDSoyQJQSXwbpAwcEaCdQ=;
	b=tBCXf1HkCRueAn/IedC0QdVKzSvGp657mso2UypEf0p2lW9nxZySEbfa7NtcpMQAUYl6Cv
	Nr5yoNpBzC2jLvDw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, rppt@kernel.org, clrkwllms@kernel.org,
	Alexander.Krabler@kuka.com
Subject: Re: [RFC PATCH 1/3] mm/compaction: skip isolate mlocked folios when
 compact_unevictable_allowed=0
Message-ID: <20260626092606.7BgipTin@linutronix.de>
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
 <20260604023812.3700316-2-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260604023812.3700316-2-chenwandun1@gmail.com>
X-Stat-Signature: nfrdmag4uddyjaq3797w6wxub8gtobyb
X-Rspam-User: 
X-Rspamd-Queue-Id: 706FA2000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1782465970-219742
X-HE-Meta: U2FsdGVkX18BpWozML+Hq5W8mJ7yQ/IPb/WK8yIRD+Cx1nzLp6frxgHxHePqD+oSESEfwStaQMFJ152NHPvM2r/N43EYNaHDfj0wT1Jfpsw0qOzn3f9Yj35mkXP/B2DyJJ+Jr3giEhcpA34E8+sCFH9XE8DqgkqrxOywPHC1oiNnjhO00r/RWUYuMOeWszjLfTsTBeLqMYMAzZ7XuktSPQS4LP8d6j5bWIC8maszilVwIJEa/6Hm6xd6xThq9hU9x+CI0NdQvGYjQa3la58ZW2CaGjPhfyhAi32NIPo0njvovq218LE3uhApqvBhZaSWMQUFpMF3LphRgxm6pijtBnzSb1vzLW1Gl1oWsmoAa6neAy7TMC0MyEyzFSuZHHU+M9rtrESr4sOGeH2jWuLcLfndQYaGsiH7N1beuYt+FllE1H0rrpLzbgNwChqWSX9R06VBJWi79SWu/a4jC2NNiE6PCnw1kzg0M2+dYC7cz06xJ7TN+w57pHZhlf7yRkcA6JNk1/lYets0JHGi1SE84jNeRK4EIeKAc2NnGTY2mTRJ6BeBXIdAe5IKDH+/xh1ikIdWl3T2NS0R7AoJQZHUzwoUyFILdWP5bMqmVe14icfkZ0NScztes9dXTO1jM7uKVVk4YSOqr5pWhDK1zwRiyugsAjqjCxp/GkeDNk9e9DBc85IczLi0XE4d5gjhw23MzyxrAfp1/SlH/Ic+ypBtWEmlh6vjEeRS3NXQ1fZiY3FJEMMOcq6LCQ25Z1W2jULU+QhDXfbs9e4cly2JM9wVAyl1nn/uiqL/NVGpDsqNdiPJ5pYEME1iKdydiZpFwXDFuTqytZW8VgmjJ2iM0S1lIty1BdcDiTqLw+m6ODzHcA9INFarQVq5GqdVvp/EsU/1Vi2lyO2BrPFKvWy8TtCLyAFYdszVDgOPWIouPI6rSvfw/qqGOLgSjML+5J000W1OQI4SdQgwYx+/pm730uX
 1Tx3Y1qm
 C29gHu+FfWFqZWF+9gY/ANNkhGIG4x6O8hCz3kkZ1d4GrNOWBDRT2FLzqWoK658W2AZw0AEls7Ygu+a3nkeb0lNR9kAdRsdarBhCSyg6LaqExUOBlBbBSiiSyS2eF628utrf8Xg7Epn9T1wHt6kCWSPYhNeRbpxKafhNypjYjFkT6E7Z0lWiKz9p54TfPtW0okOizFK0ZQMX9RA+HIRZoDKka6pcEywcq5QGrVXSzUFsa1biuhNEntBhcaKpyi2EIm8OZKZXhox1tvpAUL9Q6Qx6dYV/4kG8XXS2RifK6iYufU7WUoGJ7YUOf1Fa8ZBCKIGBkxWP0KmWrxaSh9ZNl4708mvYh5KCjiwwSIs2l0eYWmm5IkppMkZvzYLi7mEHmns3hbE2l0TTuMD6P9Rw5pNc4OnVywE1D8z+Bf0e8qVeFEA0jJCnrJTnMWWb3QhH7Jpx5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-04 10:38:10 [+0800], Wandun Chen wrote:
=E2=80=A6
> Reported-by: Alexander Krabler <Alexander.Krabler@kuka.com>
> Closes: https://lore.kernel.org/all/DU0PR01MB10385345F7153F33410098188825=
9A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Link: https://lore.kernel.org/all/33275585-f2db-4779-89f0-3ae24b455a67@su=
se.cz/ [1]

Is it possible to get a Fixes tag on the final fix so that it can be
backported stable?

Sebastian

