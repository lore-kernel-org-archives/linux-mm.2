Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C078AC982F2
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 18:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233CB6B0005; Fri, 16 Jan 2026 13:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2046B0088; Fri, 16 Jan 2026 13:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED7C6B0089; Fri, 16 Jan 2026 13:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F1E476B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:53:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A32E8D19A5
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:53:38 +0000 (UTC)
X-FDA: 84338725716.03.07DD26A
Received: from mail-106119.protonmail.ch (mail-106119.protonmail.ch [79.135.106.119])
	by imf09.hostedemail.com (Postfix) with ESMTP id BE78A140006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:53:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=bisfo0ae;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf09.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.119 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768589617; a=rsa-sha256;
	cv=none;
	b=aUvcWb5hBMQexUxNXuco/3FufPUCiMYH6WPTB9HNe73Sz/3brJB/g+wwW4Gx3ocV5GrOrG
	rceEloVTA/MCOZIr7VmEZTcpQYlWTwNAtxE+FC90FawqZLtTuLmoDEjgpBYbKQ25aUFekt
	7ZDfVrNcWAWCBRVgNmSWa7dh/Rnu4rc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=bisfo0ae;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf09.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.119 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768589617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Vb5KvAHg8eYsrtAoPd2yZc38LdM5JAqjNAqcpLPBhw=;
	b=LgWUnrUKc7NzU5nUKDaRfss0hbKjMj0Gf1rvWUh/aUZVhbTIlrE9AU07CdPVWFLxblzt4t
	Jn7NGyzr5N6ZWdxMlItE4vLjTuUmOHD5bJY7ASkdBs0Y24eW8pDe239DaDTw0qtIeh4Kzv
	BMldyVrV6oHJ7CNSAD1ilw8+rqLx0/g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768589612; x=1768848812;
	bh=8Vb5KvAHg8eYsrtAoPd2yZc38LdM5JAqjNAqcpLPBhw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=bisfo0aeOlQ7vEW9B+o6cx6XSa9IyHrj80FqUYv+TkjP2rof64WQlgeIqSdKHkCak
	 n0bcaydEePw+HLHbJB1MkSCANEmr5J1jgiF5VJCoWOd/ZI9e9ihLeV99YHFVjvVK0t
	 dAOP0q1Mt1KUuBlnLk2d9d2dh/Uvds/MVNJYhZUmV1ywEAFF/vsdUQNXUMoykV/pUy
	 Ob6GPrQmkdYlbhpmpxEkQoxzkLOhRfGk1JF2Ftw2d4EFEZXMlO8O+VlI/ZAtUpbpmJ
	 IB3r1ePTfCizGS0r52saW8O6e16OUnGBE62wWTSA9XQJrUtDj49rVu+5BQs3ivMdUH
	 /uAy6z7mdu00Q==
Date: Fri, 16 Jan 2026 18:53:28 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrew Morton <akpm@linux-foundation.org>, =?utf-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix
Message-ID: <aWqIYkx-jrjbIXeS@wieczorr-mobl1.localdomain>
In-Reply-To: <20260116132822.22227-1-ryabinin.a.a@gmail.com>
References: <CA+fCnZeHdUiQ-k=Cy4bY-DKa7pFow6GfkTsCa2rsYTJNSXYGhw@mail.gmail.com> <20260116132822.22227-1-ryabinin.a.a@gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 3874665bea8ab7c2cb4599aaf8b989a7f96e26d8
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BE78A140006
X-Rspamd-Server: rspam06
X-Stat-Signature: 57ry9rpc8kju8gkyr33kyopcupsqotgf
X-Rspam-User: 
X-HE-Tag: 1768589616-981317
X-HE-Meta: U2FsdGVkX18WhEvoWsGG9lKs9y1g1OczcK1/vds8bbb1p4XP+B/Wt+/+cxAtdLX8JD5qBXQJKdjAplQaFMsjDPY9gKoDIcqiVXvc46kduu8wZyCPxkjynodPJsQUAjl+LzU9R3gHYUwRT9BULQWJMEylqmrSfVBHfVo3LfGETnhRVkrXjQGFx66djE3Dejx8EvP6dg3iRczgYvnDs7yUKg0pcZL6akwRAYuToC4jvoVNGz90cFdHdTY2INkkEXbXhaK74VmFAM7EQ/kG1ewtJyUeUWdgZhctbb/k+lHD18a6ENZULVEAldPsloay5OBcy9OhlZUiJft8kVTwalbHZxrZspC1RsxyavmegaAK3Jxl+4guIk7uZeNq1nHH64XnkqrNH8Rw3/LuhvoDx1IYfRKRHz36GRv9fo9wtdkgw+uvX/PgW6v9Ck7qOIjfqADcZ/7ISaZH6vWXGRMTEJftio1KLhrTkqDhiQPa/eg6+n3/ZJ0hNZqUZ5nrQ3w5Bd66eHsitvclsi+twSB6ycuu2goYIuEEn7edJK1isqeEhhMGMlRUdtdcLdwCsE0qd/9hmL9KVhJfcgCAGUg/p8YK+3kLRNWA2IDW6aRGS6nhYkZpqF89QHs5+N8xvUESXBvaleg288FAA0KeIt3UrEXHomFo2WUs2gCPNcplv5Ihp5mqeRAU2QkoT/BzIIirLifgqMSMB/1GmsbYkXe9vXeKzk+YiPyjwN8Po208auZZW0HaM0LGyT84PcW6uhsJs3t50C3mPKhkeqBl2YmpO0R/ZIxhuM3sg9Bi0CzgFfoazHAo+e66IGBXCRW+vOrr6h7kRpOTizDiSEGyOUB72GG/yIs02NULem4Te/rs58YDZVKXir5m3tpos+npSE4d2JszT8XKJrkCJHZZPB+n8zRUqlkAWHWM+RtzkdqBnlb/wEYMAuHbfxj+Ed00W98SOXG4yNDmd8mdv/jvyvJez2e
 hpESDIeG
 4ze1qZTlzaS+fpK9K0Q44PtEB6rherAyLJ9sdlD2vkClOAkU2NkxJzJfZv6dBADw27COnWr6v0GQYnml94F5P/0MgO+HucIfLmQwYmLWc2OuuEzioEX/3HCmEixN750SDS/vLCIMOnyVaRgA37ytMnjOcjDtkQwc1ps6QevVsmJe+4E2xAX2ZIY835M729HPdpGm1Z3X1YRVUtdY9hxm5iVJJj3JoJ012zyc+FEnUBRlU1skOGXcY15dXKy4jbnuu3V6J0g4ihwSr1A/ShraJ0TjPnaKYQNEa1AVi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tested on a Sierra Forest server this time, still no issues both on generic=
 and
sw_tags.

Tested-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

On 2026-01-16 at 14:28:22 +0100, Andrey Ryabinin wrote:
>Adjust vrealloc() size to verify full-granule poisoning/unpoisoning
>in tag-based modes.
>
>Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
>Cc: Andrey Konovalov <andreyknvl@gmail.com>
>---
> mm/kasan/kasan_test_c.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
>index cc8fc479e13a..b4d157962121 100644
>--- a/mm/kasan/kasan_test_c.c
>+++ b/mm/kasan/kasan_test_c.c
>@@ -1881,7 +1881,7 @@ static void vmalloc_oob(struct kunit *test)
>=20
> =09vmalloc_oob_helper(test, v_ptr, size);
>=20
>-=09size--;
>+=09size -=3D KASAN_GRANULE_SIZE + 1;
> =09v_ptr =3D vrealloc(v_ptr, size, GFP_KERNEL);
> =09KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
>=20
>@@ -1889,7 +1889,7 @@ static void vmalloc_oob(struct kunit *test)
>=20
> =09vmalloc_oob_helper(test, v_ptr, size);
>=20
>-=09size +=3D 2;
>+=09size +=3D 2 * KASAN_GRANULE_SIZE + 2;
> =09v_ptr =3D vrealloc(v_ptr, size, GFP_KERNEL);
> =09KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
>=20
>--=20
>2.52.0
>
>

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


