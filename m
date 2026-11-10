Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43A4606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 23:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KiYIe2lP
Received: by kanga.kvack.org (Postfix)
	id 8595B6B05B9; Tue, 10 Nov 2026 18:12:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80A6F6B05BB; Tue, 10 Nov 2026 18:12:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A996B05B9; Tue, 10 Nov 2026 18:12:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 500D26B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:12:18 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B73658017B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:17 +0000 (UTC)
X-FDA: 85420759914.23.53944E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1D5EB180002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KiYIe2lP;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794352336;
	b=2gPkeWJ9v4YZE/iQj37bCN9Wu66779w43d5v4fRnsCAJS6FBZ8v5wX0lG6U2YmRLhzUMw5
	SpVIYk2h6qeioCCozHpjmcdO8TNH6qqjur78HhWKampwKOZYwYfsPf/Ys7rxW5ft7NIc+4
	wvof99KQlmnhTjnOth5KX/0piDG+COw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KiYIe2lP;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794352336;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TuC8p3TxE84Yr2Jxn6VGTsLxJysO01UnXYDCapou4SI=;
	b=4BAJAkqPnwb0YviN8BcQ+G7UVyn6vYTtRzgxCf4/D0VsbTOogjiPSaaD9B6PrD2di6tuHf
	6k4WjrKR9MWs5BnzpxvsIFfEPIKCWKef3xMor7FrmtmOEDb4n9vIrWQO7BjHGZYlRh6faf
	BoYqbk6WHVCTDzK7NijLQF4zqbqzU6g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B67FD605D1;
	Tue, 10 Nov 2026 23:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFD61F0093C;
	Tue, 10 Nov 2026 23:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794352335;
	bh=TuC8p3TxE84Yr2Jxn6VGTsLxJysO01UnXYDCapou4SI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KiYIe2lPufimoU/hNp/w4Fc2FqlpBQOhspxImu413Gnmf8r8UPNBduBgPOX78s5OH
	 54qF3KSyRNssrQnFimnUdApl2cXiM8NrRiaEHnBqx3xp8qYd+YC1AiF7hzB2GhUOJO
	 TX07JmH//ex+bKdu+WUTTXRLk+NVcACfZvFuOeaPEbr69J7eoX4k7S1sjoypsd1YX9
	 S2oe9XbLC0kwJFgiRVrnmuTzdQCbHqzmaTRmuLQZtE/L99jZVWiRKV4U7QGIXbIaq1
	 vdWJI5ZxS4KCQq2DAH6ebxrS7dWc/8i/8VZDGoPuE3gNCWnUw9v8K5tryDXMs2ogMz
	 SgDD9P9WbsikA==
Message-ID: <sashiko-outbox-207864@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 09/25] driver core: Add per-device pisa_* sysfs
 attributes for PISA optin
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>, "Joerg
 Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>, "Christoph
 Hellwig" <hch@lst.de>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "David S .
 Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Matthew
 Wilcox" <willy@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Willem
 de Bruijn" <willemb@google.com>, "Kuniyuki Iwashima" <kuniyu@google.com>, "Joshua
 Washington" <joshwash@google.com>, "Harshitha Ramamurthy" <hramamurthy@google.com>, "Alexander
 Lobakin" <aleksander.lobakin@intel.com>, linux-mm@kvack.org
In-Reply-To: <20261109182533.3594984-10-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-10-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 23:12:13 +0000
X-Stat-Signature: 17hj8hh11bqarhba9m6n8r16uodcc4op
X-Rspamd-Queue-Id: 1D5EB180002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794352335-622870
X-HE-Meta: U2FsdGVkX18WS0fZs/wflQQg3CiRZjrLU2iv9Y3diDQELeWHUU3KKT0Ysfrh1Zc420rYNx5SsNOdksDr2SoUMGqV+N+YE259C8+NYTf0ZsmTlW9q09VQtWAwQd84HlzAJQhbXrt1mVSL4h6t53sPSNnHRnFLQHbQzRQ8MFeapLZlPgbHQ4URGRmKaa/TraaLNymZZwApVQM4BflKXDoqqc+I0EEaZU/aoMjhNsD5ICFKdAhTqV6xtxaxQqzKUNvenpO9YOm59Hko9jPDGttoUmwuoTtGAy20Vn/KECjoWz+hG4QIh5QCVUIb9MTkEVrGirRl0D0bUHiFLXfQqj4Mjuju2hehv/PSs1jZ8mJMmz9KF0j3aaPS4bJwVaIXrBo7/j6zSxEYTQn3ec7md7y5lYdzIjiofCrFkHlDvULofVwopCu09IrqIYy+nWps1Mw/IHFHju8BsjzcmDJhFznUC1gOPx2TUfNoQnNKT9VdJLPMGkaXwA+quB/W7HU/17UjUNHBSTGQUKgZUa9Ob+zwcU/9iRz4FTkVp6g91krgW6Pj2Pw+JhGJhskIaoRtfthGM368LoQL06iERongrWYsXXH1H4nST+M+RnZkwlkddODhVcI2VrdE15l2GBP2IFHVVwSxnIXT4e/g5WAi5LPMYL5eVvsZtWfdQFSHhdfUrKIv64qvyad9PPw4DfurkAsp3faEgI7Pz5cBoHPMT7lCJU9UUPONnrHqB2en1r8cRYy19VsDuQy8mzyiSIbJiaVhOk+HZIflikRmNpGDoVzOMF9tD9J/Y8ub82ck89z/8BeZQ+r+RFpeR86NAvuGEmxENyjx5X5BYbucMvU+cpjmqgvj5dr0/NGqsoEQkVg9/f7x+zGE5uN2uEMESXasvEHfyaJhpJFkjYuMKEAvf+3OJJ1VkA+qh7A2H3tYxGYUGfA5fJkilo0FsFehbI77zW4S7R+znbaxPZr8Rclx6le
 2aTEEqlU
 l9Odr3WPnSDtOV0SL0iPssu8LfSLbPXh4DOGv+48MbpeVlLQHTddtYhH+MN9Fmnk9en7ZhbrcGqliA3XJPahYh6ehaR+hXmVQtUrcTkcXuQKaAryLSPFJpux1B3mQ8J3tCuQuo23yyyqjibZCg2H0gUUOGBV508Zqh2aoVW1FN7dlVyM3coT0ua+v6cLnZ61tC4uoMYUuvhznW5QSRR7/OVIdsU1fDBxvc5sNuiiTuJ4uv+WCSonSAFiulrp2FydONRe+oY+pw1yB8X/yaHPmJ0XUsRwDaFZsz81fSzGvTfMWSIKirIPbF/Bjxo19kvF00BcXsmNOGHJq3lk1GpHZeCovOMCzDWqjqKTElVQOSVCsS/nbXkzn4IqKiB0Razv3MbsfXFlvDOGxWrFLjE4V/3NSky+WRvza7GsJ2QHwZfnSCENr7ESyOFZUyrnGZZQJPb1rAcRieus/f5LLT3K6Ab7/jLbnrj3UOjL232sFfIHfDnY4wJ9sFZ0Sf/6bIWBYjrVpxPBsXmMU6+ytYeQ30gprDhzXiJX7Qcc7PXD5zE6Vu276NUEJjJ1p9MsNznc4bR3rkmlezaL2NsWPb90Ok1TvMOY3vjXLY+wsAYIfFxD0ii1Ve9eqiV7kB/e/JhEEhe4cC5OpJIqTwfY6AjqW0CuzrqDWUfRtXM5jLU1aMZKfI/ZcoS6G92wSXjbUB0sI9dI6RBDZiCqTjIGxmtTe+2EhWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] iommu/pisa: missing CONFIG_SYSFS guard in test_dev_pisa_attrs()
--

commit 6fe77bab9a66f127e26564b7f0b1c45730cf6ab8
Author: Luigi Rizzo <lrizzo@google.com>

driver core: Add per-device pisa_* sysfs attributes for PISA optin

This commit adds per-device boolean sysfs attributes (pisa_coherent,
pisa_rx_bufs, pisa_tx_bufs, and pisa_tx_skb_heads) to struct device for
selective PISA opt-in, along with helper functions and a KUnit test.

> diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
> index e16268d55f3de..ab64657ad5c58 100644
> --- a/drivers/iommu/pisa-kunit.c
> +++ b/drivers/iommu/pisa-kunit.c
[ ... ]
> @@ -350,6 +352,70 @@ static void test_map_and_domain_lifecycle(struct kun=
it *test)
>  }
>  #endif /* CONFIG_IOMMU_DMA */
> =20
> +static void kunit_check_pisa_attr(struct kunit *test, struct device *dev,
> +				  const char *name, bool *field)
> +{
> +	const struct sysfs_ops *ops =3D dev->kobj.ktype->sysfs_ops;
> +	struct kernfs_node *kn;
> +	char *buf;
> +
> +	buf =3D (char *)__get_free_page(GFP_KERNEL);
> +	KUNIT_EXPECT_NOT_NULL(test, buf);
> +	if (!buf)
> +		return;
> +	kn =3D kernfs_find_and_get(dev->kobj.sd, name);
> +	KUNIT_EXPECT_NOT_NULL(test, kn);

[Severity: Low]
Should test_dev_pisa_attrs() be guarded by CONFIG_SYSFS?

When CONFIG_SYSFS is disabled, device_register() leaves dev->kobj.sd as
NULL.  Passing NULL to kernfs_find_and_get() causes a NULL pointer
dereference in kernfs_root() when CONFIG_KERNFS=3Dy, or fails the
KUNIT_EXPECT_NOT_NULL(test, kn) assertion when CONFIG_KERNFS=3Dn.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D9

