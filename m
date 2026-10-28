Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53BB7606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 07:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmS9UWEv
Received: by kanga.kvack.org (Postfix)
	id DAE446B05B1; Wed, 28 Oct 2026 03:36:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38C56B05B2; Wed, 28 Oct 2026 03:36:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD90E6B05B3; Wed, 28 Oct 2026 03:36:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92E6B6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:36:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3751B140BD1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:36:28 +0000 (UTC)
X-FDA: 85371227256.29.716A8BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9DF9C40004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:36:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmS9UWEv;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793172985;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYM5ZnVnW4zp8XN25vm2v57feJtVQsrPZ5q7z6Kl7Vc=;
	b=mt0LeZw/AozwCvpdshs3tU/JdI1Wp/V6EBrIS05H4e739KKN13+JaQ3PpWkm9yMX4QmKcn
	Lx0qIQhq62/deJFULTr1JMGuEmzdb9OgbmcLkUFCK7MKcBUg9aUfxVaaa7MOqkxvRjjRc+
	sEFEkKWE2hxkxBEaQtbp/LR8dH5yUUc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793172985;
	b=RU1EtKTpAxsaBj+wpylwmWJjuLdxm6W+5HYZN9cxq61RKTlcMjmWhawjXPZKwzsIXA0seN
	1R5yjRFKZL69fHDzqG1RTm0bLflJKrMPzH0cHZW5hLbFVKDR5e9CvdfVrk8xUpGJHRXmrm
	ArPzfmerZWUSVr3dGZN+UNsFtkqKTUg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmS9UWEv;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E0D060136;
	Wed, 28 Oct 2026 07:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D2F1F01825;
	Wed, 28 Oct 2026 07:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793172984;
	bh=qYM5ZnVnW4zp8XN25vm2v57feJtVQsrPZ5q7z6Kl7Vc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dmS9UWEvZtwOjh6Cj9J0+S5wyREET2QZlvhzRgsf1tn+OOOMVCSSkMmwFl9qPUpXU
	 q1dFE4mFep7Np13D3nvb5lmIQp5G53m6uGdahktPtn/nsUj8WEBen6qnaGeCPK0aY+
	 FkrUNJ8gvJelpjeuNa0PcRaikGI9iNPm/YNFqf31OcXhkkLZHoYuSosaUeURBxQP1y
	 g6msZASA/kjZizQIOxH4xZmvsIZRDIPaueL911cRX2iap6JEWGHxOhjUQPHig44Q2t
	 gc0w5vOkMrMoAGff/CEAV9iRyl7nI6Y4TWXXENQ1E3YNvUiQIlqfsdT7QNTOTYH5i4
	 98dWHuJaZgsmA==
Message-ID: <sashiko-outbox-187586@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/8] slub_kunit: Add a test for the slab_buckets boot
 parameter
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Down" <chris@chrisdown.name>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Kees
 Cook" <kees@kernel.org>, "Marco Elver" <elver@google.com>, "GONG Ruiqi" <gongruiqi@huaweicloud.com>, "Jan
 Kiszka" <jan.kiszka@siemens.com>, "Kieran Bingham" <kbingham@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <92d3b7ad95c9b7cdc76eb8f361cc2b374c018edb.1793086056.git.chris@chrisdown.name>
References: <cover.1793086056.git.chris@chrisdown.name>
 <92d3b7ad95c9b7cdc76eb8f361cc2b374c018edb.1793086056.git.chris@chrisdown.name>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 07:36:23 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9DF9C40004
X-Stat-Signature: cjb1wew5pd3hrwquinp3mrmuu481tsyj
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793172985-929715
X-HE-Meta: U2FsdGVkX1+afsUcY2549CKaLVV7dsM4kEcAAkAaO1hl96pIKtv4KAzJQT0pjHTU2y+56mS9IwVg14NNJGwmdyJdSoNjTvqvRWShhAMO11uanAWxwu2LFYD1HNL7tm5IRJG297FPEBJ/znNk6Bj6nzwnRsgo8wE251dqBiUCtb4HMAVWZzZl8QUB3XoIydqkglqHgqNK6uww1itaoC+HoEjc2mTTH9SJZH8YpjI+b4PHp1RdN/i0sVCuWOqiIeK8d2+Jnocr/7ivm+5NQNn6l/OZx0Pl5QmDwmmaynK71VxG/xDyjq3UXtJT8RHeuC+kQo+laKvw6ql9bwNm2V3GyjUYViYuEKbk/ENXHu4Dk0en0rNNWyrpSjjMnNTfFl/Tj4c7mUlFtxd2ZwDwqJwT/TdrvFfkff6QzUaOZ9Ae4Z/dt3OY6TI44oVh5jwmi+wAjgb0K+vuzrZoy8zIyijLFaSvPQSOSOyrKWxRq4d5OqDwcXyS18vsLfdlVqjSsdqItUm+cFv9O7Kp/WaEE9aPZvGXEgu3GmCf+v7FtxlclQHM08PTj6jZpeKpzcssKgCy+J74Rgo9r/2dkd/taOY7XlBB0GzGDXpxJ4i17Qu5pdB9z8oQIUtqu1yDyijYkDW2j4cdWUq5WYRdVdOrkQ/dLghuz2CnR18ob5kh9f8Wawkkem7JDUC5yjlBlpBFMoMtPnAL7/TB6I/ay77PzTH/SuwCaruXpJTN3tL/EBT1ghyw1CelROTXayTxLyW5VLYEjFCP+eH2BIt5SVlKtHPS5IhwGkvOssOdob38ACb70I/rtaWdpgZCPVUbOsnLs0RoYMm2F9CkhO+Nlrao5O7C971RtfSuotx6T1vGcsUL64Vmz/BEphD9F2OpK7zjy5IF4I/5iISgMy7nEy3wRkB3E056vrZNZye5rgDBMQEj3Jg6Z1C9OQLdEYbjp1M0JNg/Fl6vuPFQlPkx+mtX5rb
 ul6NIXyC
 ZjBGOVsmNNyrFqJCSfSYWCw6f5I2ViNyYXWhV037pRUMdCWJ6eRhVZmagrmW0jiP3C0U3aNIi8/6j4ERmC4RnJSDgiIradWFGtapVwyvqDoyOUT9/tYmwnFmEIXjfB/wYCAdNi87Nt8ajl0e9X7MTYHuVNdBfNdHYqW8ZcGsLn+mmT1K9LbhFuPvlD4XZeLs+CVNsYEtot0aQH7Agwrd+RvZYUutHJuRdYiGPGTtYMai2V+5hmti1vkOLIyRBPaQnZf+AqDpDzpJtQVZqG/rO7GxXzEgg1dTBhfzMdBuy3e7HnaXdsnDZn6zt7hEahvQQ2NQOIFIqeqG5WxbdM1SmioQz/LTWPEdgp/4/GEt6ez5Sar65t9hz7MYpi4WfEGoL6VFzGC3oM37Eih8zUdHbzkz4KmmJ0imQNrLBmI0+4oJFxm/VVsOujxLp3Quv4TO9/yIVRVYLMnXbloVF53630iMQ8SVdsXTgnh/yFd2UVZ1KBrq/EthxWHQOKkCK4UIbpL7Sbw8Zp9PqXAR2u41ehrlZyqjfRLGrTt09rz6PwibSim25VpmOAToWDeI75flYTsefnPIyD+naaTZaQKra8G0lRDN443TbCox4FQYdY940r5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: slub_kunit: test_slab_buckets() fails on !CONFIG_MMU systems
--

commit 4bcb44da46a191f12f48d8ca5b203a12aabf1dc9
Author: Chris Down <chris@chrisdown.name>

slub_kunit: Add a test for the slab_buckets boot parameter

This commit exposes slab_buckets_enabled to KUnit tests and adds a
test_slab_buckets() test case in lib/tests/slub_kunit.c to verify that
kmem_buckets_create() and memdup_user() behave as expected based on
whether slab_buckets is enabled.

> diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
> index 49b9942bc564e..646596663b33e 100644
> --- a/lib/tests/slub_kunit.c
> +++ b/lib/tests/slub_kunit.c
[ ... ]
> @@ -396,6 +398,38 @@ static void test_krealloc_redzone_zeroing(struct kun=
it *test)
>  	kmem_cache_destroy(s);
>  }
> =20
> +#ifdef CONFIG_SLAB_BUCKETS
> +static void test_slab_buckets(struct kunit *test)
> +{
> +	unsigned long user_addr;
> +	const char *name;
> +	void *p;
> +
> +	if (!slab_buckets_enabled)
> +		KUNIT_EXPECT_NULL(test, kmem_buckets_create("TestSlub_buckets",
> +							    0, 0, INT_MAX, NULL));
> +
> +	user_addr =3D kunit_vm_mmap(test, NULL, 0, PAGE_SIZE,
> +				  PROT_READ | PROT_WRITE,
> +				  MAP_ANONYMOUS | MAP_PRIVATE, 0);
> +	KUNIT_ASSERT_NE_MSG(test, user_addr, 0, "Could not create userspace mm"=
);

[Severity: Medium]
Will test_slab_buckets() unconditionally fail on !CONFIG_MMU systems?

Neither CONFIG_SLUB_KUNIT_TEST nor CONFIG_SLAB_BUCKETS depends on
CONFIG_MMU. When test_slab_buckets() runs in a KUnit kthread,
kunit_vm_mmap() calls kunit_vm_mmap_init() -> kunit_attach_mm() in
lib/kunit/user_alloc.c:

	/* arch_pick_mmap_layout() is only sane with MMU systems. */
	if (!IS_ENABLED(CONFIG_MMU))
		return -EINVAL;

On !CONFIG_MMU builds, kunit_vm_mmap() returns 0 and triggers
KUNIT_ASSERT_NE_MSG(test, user_addr, 0, "Could not create userspace mm").

Should test_slab_buckets() check !IS_ENABLED(CONFIG_MMU) and skip the
userspace allocation part of the test with kunit_skip() (similar to
usercopy_test_init() in lib/tests/usercopy_kunit.c)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793086056.gi=
t.chris@chrisdown.name?part=3D6

