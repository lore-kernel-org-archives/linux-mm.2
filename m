Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE37D606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 00:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h7rOTNav
Received: by kanga.kvack.org (Postfix)
	id C163E6B05B1; Mon, 26 Oct 2026 20:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6C66B05B2; Mon, 26 Oct 2026 20:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADBAF6B05B3; Mon, 26 Oct 2026 20:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 878446B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:01:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20BCBA7E52
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:01:36 +0000 (UTC)
X-FDA: 85366452192.19.9EECFAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7468940011
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:01:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7rOTNav;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793059294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Ah8BrrnLsu2f3h+SZaSrIJTZykx5ndF54DrtT2Sjfk=;
	b=Gsh98pQv/GDHTRfoHZzg0PMj1c6oS7MvQpdTrh8D+9hDTumGyZ96P6G59JMTUwgNiDoL71
	MVesHkUIIUEpdbvnEV9U0ePvWXG9bAkiC4Jf0yJaGxIUslpon+J1ro3xiqfl54FUjbyynZ
	BRjA9o5unQOIROpGyxHn/en3K1yYmzk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7rOTNav;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793059294;
	b=pq3/mXYvaabHG81kQ0ytsuYuv+iGIanhkW1ml7wZk1oAoYJJSbDy3uvcoSGqdgToBmB5Oy
	69WgNuVatBdvH70QZE6RCaMeOCAZ9uLHHKSm5qwH0N6pwGorEFJIlh1IeJfiEJeIT6N2tX
	CpH7Of5+Bib0H/EvXWJ3dQXaQftW6UY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AEB4D6020C;
	Tue, 27 Oct 2026 00:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264521F01825;
	Tue, 27 Oct 2026 00:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793059293;
	bh=1Ah8BrrnLsu2f3h+SZaSrIJTZykx5ndF54DrtT2Sjfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7rOTNavWHvnY0UaYjX9CW/w7w1qHLGHcxMxhQWYFvyVaApX37ziE1Y2163AzbFeG
	 9YTONgGt3YpegrQqQ7/z+/x2SXLN5K6S9RFe5Cl3+4upqHoLqmoMcSyjOUV2Dt6wKg
	 Eg7eISzf1aIfybVMg+hsdujCTSaRULl6jfbD1Nw3lZJtzw+/9S4fVNxmsc59XScJN9
	 hxHvGp6FcWNwlZgNHB5Wnbyrxof/KlFPNGBREaWeNZNlME2p+7GrBoIsZWUgmbXpJg
	 FsB/b5aZkWQol1GdDcQblZkHQSCB+aExQ8u/Bcsm3vjhp0FxlfDxeT7GiwK/8s1h7W
	 l3iw/RQRlnHYg==
From: SJ Park <sj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH 6.12.y v2] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Mon, 26 Oct 2026 17:01:20 -0700
Message-ID: <20261027000120.156623-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2026-10-26-1-daily-reply-0007-damon-zero-target-value-6-12@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7468940011
X-Stat-Signature: fc96iatz1kej4hxsfuzaszus88anrfp4
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793059294-562086
X-HE-Meta: U2FsdGVkX18JTXBhQjdPbTrV1LGw+FZmzaP1NMXqpED8qhJMOdfK63jMsLAYmAatwLxtFP0ugllF74s0koi8Hu2MCB9baVlTmFSb2Lxkj9GvlGXs7rOKpD1S3B8QjVtMGFid1oEECYYHmxyNhzESO5DCGHG0Hm4DNHETJyDbVGHNY77HgB0j4gbSvVjXS0OIfQQ2uRpv9m/61dpYWHjaRILiAtvU/QeozA6FIzRO06L82WmW+aL23O3f3EfoJfY6fvRckhhEIiXuD2SHlRSwIr0e6PGuUJ9pKdgHqadZLn+PCkxcb1KpXk6TfQkEK4Mlx5PAYVTroGykaq3Qp2jYzA/qZwzCMPOvYwQk/P2MdrNGLpzw+8pPKcE/UN+sIDEX+gk9iNM86bcXOzKQCovaXfi52hhcTs46OiVrADsDQbE8d6rAW+zYoXIgahDH4qCVkZ8iYvxjAZXuHeKQmDD02SKQKsEfZA8Cj6QUCCsedpqJDYSRlJBOeGGTIjjhpqIuwXcZ+x9b0Ln1yJa+3+ynb/m7MgscNz44dqUDEYZlrbbj1rqHmG35hamzzM8UsZjNJGg/031bH/z8AJx/1W3lyZpqM03s/pkfQ5KK4ItjPiR721LsN6VgHdEjF4xctjdNLa0s9P9WlRxhSZDcrVuHlULKxssmelko3OzZkdATBMy+6RR27cYfEl9qe8HhuMyj57PWwNSP3tAGIGohnIZTgYOpaxz6NmvNPyFH4DTXNkDmlYVilTH1cyLxZWXXT0jsNWvzmUjR8TWdHyC0ZrEVtBlpxyJ/ayrifYsqUwjXeJncMEYiEZk1DBrv33AE8GPH7XsIMSyhKnio0McBOo6CcwTlj4Eh2Kd+z1+MXaxM8f+0Pxio6iRUQUuFjjm+rAGIrwklWVuIPxiHCB+w2DZGZkL/VaQQq5HXzXetZ4AyiHV8BpsyS66tav/4gWSyP8sc/BZs+gHklmZ+rq4EfJs
 dfQMOumE
 pB9+lJD3DR7cFsKSe3FQSQm2aqg0oEe/tW9T0XOlJ2VgXOh3cCkNesqfZzA9ATdJsKNRUrwM8aV16usVhtqJlqgvuA9I66NcJb/co1toOdOhhOyjycZ7QtSl2+dUASpajtONSg+Xb8iJKb0qkrP/zKrfs23LiVJbOv8DGVUxLYs0qQpQiY75BYm5fLwO3cGRAgTbHMFgH1n5l8jkzhxFO+k3OXLd0c6PxcV2KpBZJcvt398P8yM02yI8iNPh5GYeQXQ8va0wztkj4/JId8MP5dmDPaYc4Y2E35KY1oZkESu+TW7A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Sasha,

On Mon, 26 Oct 2026 18:55:58 -0400 Sasha Levin <sashal@kernel.org> wrote:

> > Also, the upstream commit on this stable kernel can fix the issue for
> > parameters commit paths but DAMON start path.  That's because DAMON
> > start path does not invoke damon_commit_quota_goals().  To fix the path
> > with minimum change, add a new small validation of quota goal target
> > value before damon_start() call.
> 
> Queued for 6.12, thanks.

I'm sorry but could you please unqueue?  Sashiko found [1] a bug that can leak
pids.

Also, could we avoid queueing DAMON patches that marked as RFC in general?

[1] https://lore.kernel.org/20261026150825.152576-1-sj@kernel.org


Thanks,
SJ

[...]

