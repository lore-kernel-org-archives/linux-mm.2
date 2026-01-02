Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA8F7FA3751
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 21:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84E6E6B0088; Fri,  2 Jan 2026 16:56:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1E86B0089; Fri,  2 Jan 2026 16:56:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D40F6B008A; Fri,  2 Jan 2026 16:56:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD336B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:56:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A709C140D69
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 21:56:28 +0000 (UTC)
X-FDA: 84288383256.04.3D36C47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3720A80007
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 21:56:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YHhTDL/u";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767390987; a=rsa-sha256;
	cv=none;
	b=dgC+NNsRktu3QupSqOWUV/eWWGJM2yS5gbrTlIUvkwtvmejCFjicV13O0OYdc5HJ933BmT
	16G2mpTbXEXyVXN+gwWtxIkp5Id4ENA0Vou9mk2BTp+0kz3WNn82OjHdgIjZA7T6gq9UEs
	5fUyKLqbribROhcVJgUZ0bVeo8YhlqE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YHhTDL/u";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767390987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yjgVLzkxPuytlM1JOA3GNnK82FCWYA81WMGIYB0Kmuk=;
	b=BKThGjtcmpJOTLhnyfnYOY4qSCl9UyVPNi/Db5PIFvtel9CdNmJSi9mixsGu+aPF+2W2Y6
	2EUwVoA8IzgI0+uOl+8j+hAffWDY7Y4rPVmlUyFMtfMTJ5HpNqzLO9mTOaJQX4VvQgHQXp
	mD2JTe5pa1b6sG+Wj8JvvsqnWYkq+FM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 86D736013C
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 21:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA28C116B1;
	Fri,  2 Jan 2026 21:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767390986;
	bh=zppH1GSQx/tNdznTh//Ks2re2fvotGy+Qeog1ZBigx8=;
	h=From:To:Cc:Subject:Date:From;
	b=YHhTDL/uzpc346i3hxHanQxC60ihe97sWe8b+0kXUvmpHTKPC8Wk1XxjFU1v5rVAg
	 43upO40P6MatG3NYTtPsDsH+VX4nDKkiola9pjGLvYPK/3zGv5/SFiHR6FrGd14IJ7
	 nl9DTCW8C+xcfd+U4CgOBXtylnMmLkrgg3OTOZhJPCF9+QYontU7HyHwRz6vQh1Wlb
	 auGm55oARBPbdJT8N9C9wStwq5+Snl09FYJ0q3akE8k6rXvwc6Yh7HsFwDuYcQ/rAD
	 JxNtrTuuxdeJ+siItPHn/PS6+Ir6wvJxwTo1uogvR/qWSxQKDNcv0zPOoZtjlZEtAZ
	 yRBvgC0d85g6A==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-01-05
Date: Fri,  2 Jan 2026 13:56:21 -0800
Message-ID: <20260102215623.41110-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3720A80007
X-Rspamd-Server: rspam04
X-Stat-Signature: jis6czj1peq8ucywxwnpskuis17eq13m
X-HE-Tag: 1767390987-380258
X-HE-Meta: U2FsdGVkX1+1audmVjdUeNutAp4l1Nk3qQ7avSHx5dAoWUb220nJCXQpptS50cl0AEYJ0Iny6j7/cKuFFyKSn7tEjhOegCdxpp5ikQQwXC8KO6CSAFv5oGHrRpqp8WlnLUj8nQ3B8uix8GSl6QIxQIcOcXjtv0cL9oOhvfdSpwKAzmTnOhyTsMoAc38awAix1Lws5+nFUl4B/4q+gZhtaQ5t9cltEcpUh1NA/B/zuczHKDUcCKXMNeEcRy5noJz2bCTqY69Q/yELMAIKUP7KIeUVRrSBUQorWzidxg9hyXh6vKNZG5MO6U64wvxkMwU7RYVZiSyWmYiHp22aH/+qAwBPd6D48/Xx4jVcTvIJLfmJIFcJLc2Xbc6U2cbDRHuWY3SWlXILnCQ8cXi3tkRWXIel2e2rk9w+48fPFfCXVqMj227qtF6PZmgH3cuuLmv4w248UP0UJNhLtcNlrQS1eV28AYFto4XX7rRuu7wozYqaP38XuoX98t99sAEzquQ7tf8xwkSZSRz9ouyGncymCflV1+bg97aZfWEGSQaBXAe1XmL5hzQs1yb+ND5NyQzC9F7oJCnO2thKy1JABTVXhQ8Ey0kcVGxvjTk0AtcJFHugei2XVoM/1pDkdr4h+ekxFEE8bzsdcga81uop1Zi1djMPuWb73aSxw36n++B02Sihrn9NEGaDs8MWdhcp37+kge+OXPGlXSm43WQMxBWPd/XjZL+JK/JRGUS844Irb2z/uWgbZdhUxuUt4eS8ZHLS+kfRPxm9t+oP3GTOw64lzlsND4bqDneDihGoSMd68EzMcSs0qnMPJCJFc8LRa+2HoRnKvYJBiRUVPIu/oc4MMBkXnd9zaNC4IguTJ/yNGEC/zvJA4P5eT1CNZi5ItmoiO+Oe8DTAHwQIsEKxoqjVCyoA9m+z/EIt1xqnOv4tQbKy+1iYF44jZWc5/1j5KgNfhavB5OKEasso6eCBwGq
 eQCpYpe2
 vXc3e909FJKvZIw7gYGj8hn2BS7vHJiXKtBtp5nj1j+qMzULOH7h/VJfpVyXOc8eZNQad5jVw87JFgGloiP6nHBsHJp5EDenmQI/1Z+tO/a2ljC9plIw1jjnJGRJ3EujnCnYvwasAPC9XGTVws5AUSUz4u4iOIOktUDb7ZwhtpNQxrn8MMv9gG1V93TAKlzfrZLP61b3WJq0yqpbbQnBm7M+G3sRms/z04LcW/CennKjR/bPecIqWusKFKJtTlnlPuTEaQUi0FQQ0jhVD6VlRiX0lmVUwHvoJ7x8+2GIH6NVqgHEowsKPmDFVoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Happy new year, DAMON community!


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-01-05.

As usual, we have two time slots for meetings in the week.  Both slots are not
yet reserved.

Next time slots including six virtual-only ones are as below.

2026-01-05 (Mon) 18:00 PT (not yet reserved)
2026-01-07 (Wed) 09:30 PT (not yet reserved)
2026-01-19 (Mon) 18:00 PT (not yet reserved)
2026-01-21 (Wed) 09:30 PT (not yet reserved)
2026-02-02 (Mon) 18:00 PT (not yet reserved)
2026-02-04 (Wed) 09:30 PT (not yet reserved)

Please reach out to me (sj@kernel.org or whatever) to reserve the
not-yet-reserved time slots for your topics.  The reservation is made in a
First-Come First-Served way, and I will send a Google Meet link to
reservation-confirmed attendees.

Please note that other time slots are also available on demands.

Shared Calendar
---------------

You can get the schedule via this shared Google Calendar:
https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t

You can also get the past and upcoming schedules via
https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing


Thanks,
SJ

