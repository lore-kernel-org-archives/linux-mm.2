Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38888C98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C37F6B00A2; Sat, 26 Sep 2026 05:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473836B00A4; Sat, 26 Sep 2026 05:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B01E6B00A5; Sat, 26 Sep 2026 05:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1824F6B00A2
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:29:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F8F1160625
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:29:51 +0000 (UTC)
X-FDA: 85255391382.07.84ACDA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 07984140003
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:29:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MkJMrAH6;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790414990;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=crboOxvrJ8lPbqxWIICzX00men9f9+ZB4s2xBH/JEm0=;
	b=1eDXP8+01zMdTO0oKOchCETb9S5WpxFA/EBI1MmoxEguV55ttkD5ENO1mz6MfD2wrG66pF
	fH0bv7b/APsfvi2HrZecg9QSGoeVsgE/PBVHnr4weKVZiH4hyZ9ll85L9uDOTSZ1g8Z09Z
	tL7Or8uSwM3ES6Q9XxdbjJnGMI9KQlc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MkJMrAH6;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790414990;
	b=qTapS6T+miYpVYL4CXYHxZGSkaeKyD47LgmZ7AkXsytUPBZ9K809Eco7QIdyiggUG5zo/h
	huO7LMdAIeDBg8AbrU4v/nrkA7zfGnc02EnhNuh8tL3mgzUSQv525DRXUc+9oV7ciQDGoX
	4zu9HpsCYGFW/4Hqe04CbKn6YohRpu4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3339C43E30;
	Sat, 26 Sep 2026 09:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D311F000FF;
	Sat, 26 Sep 2026 09:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790414989;
	bh=crboOxvrJ8lPbqxWIICzX00men9f9+ZB4s2xBH/JEm0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MkJMrAH6xEt8MuQePzaeyrvnwAl+wKF6FcLv8A20eC9plGEce3O1epmIsMmNDn5HW
	 mOCiZkCvwX7EmXeMmedV/azMVpo1Z0VBupX+HLvk/cM9uCAKqndOI26sexDbR3z94W
	 t6B0UgcrCzFGrohptYFe+0OHcoCrqwN7sUdjO/pVmIsU5tLRJpx4CHVOhx3cDZZOqs
	 t3SuWXug9kvVE5w30nBv0l789F6wATP1/VMYOwOsnL8Uaw3KWAVhAnV8OjsoBEBDZu
	 Ktu6dTqAxchupgFxxkLjpzTWIh909uR32z5iQm9JCxn+0Ux3PErPF/OiefFzYOmSN6
	 3uaHrPk7EsRtw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] memblock: drop for_each_memblock_type() and open
 code its users
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, dmatlack@google.com, "Mike
 Rapoport" <rppt@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, dev.jain@arm.com, "Pratyush Yadav" <pratyush@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260926092448.4090401-1-tarunsahu@google.com>
References: <20260926092448.4090401-1-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 09:29:48 +0000
Message-Id: <20260926092948.90D311F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 07984140003
X-Stat-Signature: kjod41g1uo6fizkn8k7o7o644uj1fhfj
X-HE-Tag: 1790414989-594525
X-HE-Meta: U2FsdGVkX19m05ToYC2tah9grPQFUGURkTSlXEznIj49Cilf3iL+icyuffEXI2od4LBSX8F84/QyBKda+ibPQlvAHrLhsInpbfsDhBzTUm3OlXoRGApLWngasPtlvIfM4A71W2CdUpLCiJvdwPaRNXjMDKwvlcw/OXSvZpvzMevO2QnQfxcCHl1gnzG/pXSUkaNv0zJ/ARPB2+CaajX4wHINY3Cmxkv2dSR0Is87QhBJZrY+lnW0pteFbGCu096F+yJ6UT69B9RCBOR3mYSMBQdpNhKrUmX7ayB+bsuBe3BkQQA5hLCpSIgXhVW5clenE/xvYVyKzXdfIUOD8iWbjBJAf8563L4C4KdqhR1B+RyEZcHUrIxqZeO6QeUPBk4b6hcEtOMpXKfUJGxBON70LzKK0a6O5OQn3tGsaebwmv231Dur7XNYyxeMYoUj1+0CfUFevlr1LOh8Pf8DAT1axQaCyEq3fW4+QqBhmi7KYMwWVFxWK+Lf44PWqh/7BZKCJmfIizbfu+IXk3vehmHRX6Zch9JF5MdCp+OTbH1EGbeBeIFhO00dgNHsdt7QoG3m0AsFeJCO+g4jFKIp6f7jJYO7HmqVYEo+41rQtm+yXg+cDsoUys5PC3d8pkm6ZaJ/eXw980pihde6b8m8aXFQJtHV74wajfpxsiS7CZj3nUj/0lU9nTRotz3RsG8tXo0gBjXGDq1qxTyavW1hOGd5jXGPqMHDUjm0JCzdru03uwlFZbIVQ8jhKGjpIePXUkkhnfkj96rcGI9IziMWSF6uM0OhQQg71+cXOn4kHnOrwLty+EbKRJbkcVgs1ErZG32yb2BMcpwYZW/6IJ9mf0zdWlG+/euQys8vJ3NmV0CuVLAmyG/IjyK/1unSJjCUyyvWzSwxdpIqg2ssJJYZiOWneRDCSXG3Pg+ax+ZW5Gs5HQHQE1/oztH+l+wuEB7yS1NSO49OugBPcLqz6w+wUIa
 lNxVi4O7
 tJ8NaF6hqoiMVcoauBwTfgeWx8eWVEOQbtWKwFTS4UQc13DELpbrCh7LZrGmPMf6SZY2mU0/CjHxOyiyNXk5V2obtvYyi9ajkLr03X2pQrfql2yB7S0l3P/seZ5kDuPSqFWwVySlQMYO4fuFwbEsdcoWWM+6EmfCzIn2WbY+N5D2g1p985pYA1l4AV5oNxATh5GcvKsFZBW0f3MDh7Hp44ZYZ7eSQnz6yGlsoYe3sBquaXwRQni6v0aAPFSXfq3O8S+vm1xM7R0trDtxd45DtWZZI45M7T3m/UuutsNcFJL48B4AIV8dMJ/prtN6SwvNAjat1yjpS4R493q+fx+vUMbpX4YMYAvdYf7BKRHk91NONTNPug6Vc9CG8TvMAFOTf4ZAyEACoDEvXnbcmYV4XDOJmcU11NKGBTL3PSH1QjiEMm/uFATIUY0fFtvs81pEUJ0VBzdhnz+JHEuGSd8eFLNrXTOc/802oBDoqAIxom8OBl1dkakp0Zc15eg/7NIOxTwW7k75TZQRqby58/3duTtguAyoZ+BsAvZ8wUngftIC001V1lj41fs9+uimXgzh8Ka5p9AJAjpaBoG3Zp2skjpi6Qt57cd2uuIRp/HfqAybCgyeOvdQsMl0w8vmh8kBmPiS2MypogP8b8AyFiyqz1ND75wlABHwHyCLe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> for_each_memblock_type() always starts the iteration at index 0 and its
> body is a trivial 'for' loop, so it hides very little. It also gets in
> the way of iterating from an arbitrary index, which the next patch
> needs.
>=20
> Remove the macro and open code its three users: memblock_add_range(),
> memblock_isolate_range() and memblock_dump(). While at it, move the
> region pointer into the loop body scope.
>=20
> No functional change.
>=20
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260926092448.4090=
401-1-tarunsahu@google.com?part=3D1


