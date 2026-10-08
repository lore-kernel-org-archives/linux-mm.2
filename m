Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D7BACA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 11:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5566B6B0093; Thu,  8 Oct 2026 07:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507516B0095; Thu,  8 Oct 2026 07:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41D306B0096; Thu,  8 Oct 2026 07:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 286086B0093
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:22:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB272C0205
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:22:21 +0000 (UTC)
X-FDA: 85299220482.04.09B3B4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 299B140009
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:22:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O1Hp/Uhv";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791458540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03ckZm2pi2++eResCYDaZn7t99v+mDgxPpO0qsFG5T4=;
	b=mIj0NkeInAfssmCw+7x4EMKI/6k8B37DBnld0aZglaGtncw/8sHwO1w9ybj27oqQb1nfIM
	ccyWiq+PAfaeuU3tMDr15D+bllkeEkkAa3tDM07kMWpK63N4Z1LQWW/wFviTZPbIgFhNsJ
	6X7oyj9yeiyv5+DzVGwuLdctmjRznvs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791458540;
	b=OW4TqdirzrWDkcOc1Ya/JWaxht4qiYcf0GBOpJhuAUnxNLeEYG0JpTY9LLN1uznj8NRolO
	CrD5/sge4+VznKs+yLxLjAz5SSKUKr3GyBWmCeUIuxKnk328hVnTNRRq6eX5R7ftuj5HuG
	rzcfLHce72v2vSnv9olxFcrSOFkDupo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O1Hp/Uhv";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B32C6601F9;
	Thu,  8 Oct 2026 11:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50C61F00893;
	Thu,  8 Oct 2026 11:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791458539;
	bh=03ckZm2pi2++eResCYDaZn7t99v+mDgxPpO0qsFG5T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1Hp/Uhv/joP8NbSyvph6SVo6Tnxzy5B5osUSyhezFS6yhfCAuqe5RsTowi1oAYJ4
	 1ACZegfMaTSPZdrjXJgnIctJWh2KmQn/QivxGI1be5MH76jK3+wj6X5sehiPc8zZHw
	 hZ1vS0sA24LesKAyKaw7zEMt+BA2uaj46j7cVYt16dPgzN0ISVlYSbVuzeCuZILx34
	 njoJNaihYOgiHRML0AErlwYFA7uyrFz0j9e2E4ZbMb37lK1NePrts6oiVY3lXHp4qj
	 JZ5CK5G1N2rzGnF6F+JPVcroh1yv794sh6PocCK9TL6SI7qZRCmCbyUiYQ0MmjC4Qe
	 sKRSi6sf6DUgQ==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH] mm/hugetlb_cma: remove two unused include files
Date: Thu,  8 Oct 2026 04:22:14 -0700
Message-ID: <20261008112215.43826-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261005142040.675204-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 299B140009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 57mj4npfiys8n35qbf3bimc51gqzmhsg
X-HE-Tag: 1791458540-137276
X-HE-Meta: U2FsdGVkX1+B48A99cij4EY37s3x2/jc4bua2EpK0FAyCe0GcBMjDmvCekvFmxz5ZV1hdIDpoMKjjugoAtmDla9sWNQiJ5UjuYoSJP7xl3YJYHNjQcvMsBpcejZIWOR5d8GZ3vYMXiQPXqOWXKc2cZDY5gvUV80iGOlEMRQaS51WxrsHLIRlej0mdJIS45JKeEoCDImL0A/ndC14W99Et1CLZEUe4DSujT+wvpYe5phjImKl1X7kooz577U+VF2v93lFEgLHNyFvLgvw5+oIWS+xoKIOzLccm3+lKpJAwK2Xl4lMoP0Nl1Ia7SiIymU+S5of8OAP2KHRJjADilxnpPcp1Dlx20uqmVHYk/uLNjFZnosCuOBC66QwQKgi1q1rOhmrVFAP//ADfaw0CVBbsG/r6gO37xYWSdahHm40rqJYaIuhlnoblVf8XAGOhCMSJ2+Or3W5GTERH0XC64k0Xj55Orfc9/VnA2k/Emuehq/32izHAbehJKJsvSWeq+MRPubZaUn8sQHgVs+T3GDLxexB1ZTDojjI50qnirxF4n/hg8G54EkA5XLRnb5jscoUWtKbWgCJS/OEp2v/mdrt/M9aFxvJZA4VI1knVwAlzXJORBV7Zl1pReuPu4f8hfxthJr/HCiqlkvjI93/B8JibQBTcZidvr03UtJupc2FmDFqUX8WcQ2E5pm0KSj53mp0yj9Xm97JeI9A8e4QHVBmycyVHj1pfBPFKqdMlawiWjKd9zB2fhb1j33GZQxzN4Lr08V4CeotRSm99Bnhk7dbIcsn0lkOpzQRtq7b5fGIYD9CVwUMCxvr1+Qn2EzbtlgVdWqUyQ3w5hfSGla1EEw7ah49zZwOVA+WOG7msvbSOM5aR9CPLqf+s4gMch3dXGO+yFxvqRk8dHgo4DVwx6x61udVGeOpuYkg/V3fLJC8RD9jHm0fQdWkDjxUZPsTm9+4rwp4XelwJfts/mURBU0
 twN7gfaK
 mcDrTFBMzd496BmsOqrp24swdhm9wrQETL+9stBeSxPkO1xWQjvcrYQBRT68Zgdj2xcEH8My20UtpzDLj7RgKPAz/3Wm3t3kto7qKxYdG6AtTYZIJHye2K6NvURRT8EIDiWcAdbiz20EqjxvXzgJGP4GRtFWlkUuuUCI2IBdU2EIxGTK+pNUMw2ccgVu8HRFmH4qJuGRbKpXZk3rpC75e6eYxyaiu3EyDUGdvcqFvta7UJUE0tKC3d9Ss6lsOqPpXY2xpaaUiM8xDB2V9KG3FdKCKV8vznhGLZBkT1GmngxLFtUH0gS/Uk/G2aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  5 Oct 2026 22:20:40 +0800 Enze Li <lienze@kylinos.cn> wrote:

> hugetlb_cma.c includes <linux/mm_inline.h> and <asm/setup.h> but never
> uses anything from them, so they can be dropped.

Makes sense to me.

> 
> Found with clang-tidy (misc-include-cleaner).  This holds regardless of
> config: the file's only #ifdef is CONFIG_NUMA, and it only touches memblock
> helpers, so removing these is safe on all arches.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

