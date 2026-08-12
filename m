Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C2DC5CFC1
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 03:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAB4C6B0095; Tue, 11 Aug 2026 23:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84A16B0096; Tue, 11 Aug 2026 23:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7506B0098; Tue, 11 Aug 2026 23:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 978C56B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:11:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20A7C1401DC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:11:40 +0000 (UTC)
X-FDA: 85091142360.07.8CF0A21
Received: from mta0.migadu.com (out-216.mta0.migadu.com [91.218.175.216])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9D73D140006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:11:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a8i42++q;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786504298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/UzIDcAeVC7lvcPSEkeHrtgSf1XkfFAZbNuK3eaiWD8=;
	b=XkXYu3FRGhzJ/dNS2TAeUxhxTQ73GAFQWT5AZr5c6oNBE2y9vb2b2jpQ1Fm9m9yycyVgMx
	DczrQQmzGurlQ6qtsv0LCeBNbPHraOy3cm1zDD7GC4WEdFOGBEkVkUTEfWGFPoM0JlsGt8
	VZeWTbeLeGlH6USiZhlp0XL1/qwa/Fo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786504298;
	b=zk2zw99YB7ednJawWTWJdWvS/vExPQejyVPFSqDCUALoNhhehM8EnPzRbMef+q5i/I6JZJ
	K1+1qnj7DZn4q53Zrtxg4hl2XGFtQD2EYyyPeHKaB8E0ytzHMikBl2WeDi8NrBBCe30t+c
	HVAbZQpJqHExgwKq6hnPl+LJaBWUGfI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a8i42++q;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=t86JxHziNoCkZyq9Kev8+A/YFqRdo1YCTbOIRVlOfTk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786504295; v=1; x=1787109095;
 b=a8i42++q6uToawNvM+PY+NuMQIQX31H/wPyF9Kh9jXVzmmtPqtRfVFFpZtccLp0zoA70A7p2
 bnbNYUQZbxWI1Ia/dkUgWz9OlIdmZ+zSMWC1MI+i32A2lfdFOumHxIBze4oBimzSExCAevGe6QA
 Qp9B4JLJq9g62xPLGBJzKusg=
X-Envelope-To: linux-mm@kvack.org
Received: from webmail.migadu.com (2001:41d0:303:fc7a::)
	by mta10.migadu.com with ESMTPS id 38281a8b4824b520;
	Wed, 12 Aug 2026 03:11:35 +0000
X-Migadu-Scanner: mta10.migadu.com
MIME-Version: 1.0
Date: Wed, 12 Aug 2026 03:11:27 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Hui Zhu" <hui.zhu@linux.dev>
Message-ID: <e0a9a4d24a5a667c94b9cdc79a268b624414c6bc@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] mm/vmscan: fix missing NR_ISOLATED counter update in
 MGLRU reclaim path
To: "Kairui Song" <ryncsn@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Kairui Song"
 <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Barry Song" <baohua@kernel.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie"
 <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "David Hildenbrand" <david@kernel.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Hui Zhu"
 <zhuhui@kylinos.cn>
In-Reply-To: <anrPeDFIs6JoPqhj@KASONG-MC4>
References: <20260811071703.425097-1-hui.zhu@linux.dev>
 <anrPeDFIs6JoPqhj@KASONG-MC4>
X-Rspam-User: 
X-Stat-Signature: ko49qmteea4esrmf8i8qx8immoqiouen
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D73D140006
X-HE-Tag: 1786504297-414161
X-HE-Meta: U2FsdGVkX18v3GaFjoSICCJFClgsjjcX062sIiqlbDEvvLWMPZz0Wmpk54rZAMsFnji9xQLFNdnICIEvkxKYCEfGvfun/mQ+kxLoI120F1eRqDq5wMzkCgxw15hT9QWTKIb4JNmC7Iv5ESmG4Cswe2+CfJwbPSRzKUs/2Hi7zI+lmcKJpIGZbzxnFwxPSEmMXJCQhTq8eHCJk8551QoWL+aQzckapCLt1No79ORu/zLvlnIrsc1U65YiQy3vFtu+xVNfDQYv8+N2ffC2lAxpMQlNcnIWifmWmFRxXqqGPFOrKlrPr20ADjdW80T0hjzlva5rkyDkFQR8MB2g7G7VXyA+frH18BQE6Q8cS1ad4cqHSfMaKipOzSMDaNEQ2JfIUj8rb24Ul2SfOd9soqLDoaE2aTknWT72yDUX8J6u86utOYtKhMLZTD0q7kZIKAfkgm2kYjm7wdKsfdwmXN80/733KpXwqUxwoDwrlLBMbG7QEIL8vAcYNyHXpc/546A0WZhOOaIalv8tMNya6dRBliZvvJX5IY+1CwpfnX7Xgrmdf+bGfl+BABbMiVFl52d0YAuhLh0VJwuP5ZxNQNUYi6/7oqt4CqOFfNZYUxB9O3IlTlvm5D5hcBXxqWfMUrb2ewCefk62Le9zjGnR433sV4dUzL3CpS+d7sOml9QcatEXIIL66i88h3a3Bpo9Wsn5DCIhEUPHri/qRxw9x2PVNBcQkFH/lJfCZMdOoIsHUr+KuhHxT4Gu99JLXP38+AawJhAGTmcXQn6LEszn//pS1i8R9OgdO4wgc7pE4vuHZrZpKuDOoXgf+Hgg9BGsGit9oLHUKL8F/RKXwh8Acm3JI7IRChiy9YVQcemJiwLSxVu8yPhczR22pNl17ub2y6EclY/kVQUJHQDCMzLa07dqpZUP9BJ0lktKGVSFTwPwSa2Ngyu++f0OzJmYrEhzkoDxgsNZxW7utzATXQbLZIk
 sneHF8dP
 BlAVcNfTRRimbD5Sv/9Kbp+NqbyUtZiZ7/1U7QXddxWUVa5Kvj0EGIYum2k5ZLCpx/gIosdF7EqrWN+BLwE0Bfky/HX4MqeemqMNW+a+U8xCuhzKFPJNmQjwZXEq+HRVfirnbH2/2SVytYxks8Nu3AMMRU4hKAzvF8ABB1wRVgykat+nOOHLUNBWtXUXv6SEXjGnlKkS1wjAmTpFj+FXKzkO3qONO1dvtcwKtoDr3GcF60FKtVuEOwrnxgh6DMrDwFOXdy55d9rsVCPtTfEnCUyeZ2I+mgSp0qZfk3MzgMZM2PBOUh8j7JXThyhheMcY7KWow
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Tue, Aug 11, 2026 at 03:17:03PM +0800, Hui Zhu wrote:
>=20
>=20>=20
>=20> From: Hui Zhu <zhuhui@kylinos.cn>
> >=20=20
>=20>  The MGLRU evict_folios() isolates folios from the LRU without upda=
ting
> >  NR_ISOLATED_ANON/FILE counters, unlike the legacy shrink_inactive_li=
st()
> >  path.
> >  This causes compaction's too_many_isolated() check and the OOMkiller=
 to
> >  under-count isolated pages when MGLRU reclaim is active, potentially
> >  leading to unnecessary compaction attempts or incorrect OOM decision=
s
> >  under memory pressure.
> >=20
>=20This patch still doesn't cover the OOM problem, too_many_isolated is =
not
> used for MGLRU. I prefer to keep unifying them like what we did previou=
sly
> with writeback.

I will address this in the v2.

>=20
>=20It might work for compaction though, did you test it?

I didn't test it, I just came to the conclusion through code analysis.
isolate_migratepages_block() calls too_many_isolated()
which reads NR_ISOLATED counters, and since MGLRU doesn't update them, th=
e
check may under-count isolated pages and fail to throttle when it should.


>=20
>=20>=20
>=20> Add NR_ISOLATED counter updates in evict_folios(): increment after
> >  isolate_folios() and decrement after all retry passes complete, usin=
g
> >  the original isolated count saved before retry.


The current patch is based on mm-stable. I will rebase on mm-unstable
and use the existing nr_isolated variable.

Best,
Hui

> >=20=20
>=20>  Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> >  ---
> >  mm/vmscan.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >=20=20
>=20>  diff --git a/mm/vmscan.c b/mm/vmscan.c
> >  index bc324e37c5f1..723b513574b3 100644
> >  --- a/mm/vmscan.c
> >  +++ b/mm/vmscan.c
> >  @@ -4817,6 +4817,7 @@ static int evict_folios(unsigned long nr_to_sc=
an, struct lruvec *lruvec,
> >  struct lru_gen_mm_walk *walk;
> >  int scanned, reclaimed;
> >  int isolated =3D 0, type, type_scanned;
> >  + int isolated_orig =3D 0;
> >=20
>=20The variable name looks a bit confusing, and what is your based commi=
t?
> In latest mm-unstable there is already a nr_isolated you can use.
>

