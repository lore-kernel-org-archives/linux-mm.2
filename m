Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2E4606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=nurJA4ZA
Received: by kanga.kvack.org (Postfix)
	id 42A816B0973; Wed, 28 Oct 2026 00:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B46E6B0975; Wed, 28 Oct 2026 00:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E3F6B0976; Wed, 28 Oct 2026 00:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 004436B0973
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:04:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E822DA0C01
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:04:25 +0000 (UTC)
X-FDA: 85370692890.14.382CF08
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf11.hostedemail.com (Postfix) with ESMTP id B6B9A40005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:04:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=nurJA4ZA;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf11.hostedemail.com: domain of daejun7.park@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=daejun7.park@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793160263;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=s+iZWCpgO+SWu6sydNQvWF6mQUcVR5AF+EnQF8o0seY=;
	b=D0YV8nmvO6khxUwdykRHC1s/5eztT8yFJO9YiVZSi0Bry/VcWmXJFsDeQw/nugv5SNZhyI
	oZi13DoO4cU3o156WAhdsVgJKB5Wbho+urzANRSDyX5F4wsZKmaL+E8fpsh/S4sfzGqch7
	EBBKiea+w3q9/EIhJ+SStzRgH/sEJoY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=nurJA4ZA;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf11.hostedemail.com: domain of daejun7.park@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=daejun7.park@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793160263;
	b=6wp/qCaPnlpNbbfv983IAJXAkZI6+X3M10HF0VgfaqisuBEBPRHQyxy8LN3lM5b4WP+EUx
	01ElEPCjmipSG9ZtKUfhL02FaBNTQk+IQqFJveDzIj2Wi906XngwYWKWA6IY3/JfvXbIcp
	KQaQ4g+FRNgGojHgwdN9lKRQzuUjgxA=
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261028040419epoutp0192461f33003d0fb938c1944b2bbb4fd0~ilcFzDM6h2536725367epoutp01X
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:04:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261028040419epoutp0192461f33003d0fb938c1944b2bbb4fd0~ilcFzDM6h2536725367epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793160259;
	bh=s+iZWCpgO+SWu6sydNQvWF6mQUcVR5AF+EnQF8o0seY=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=nurJA4ZA1svBQxeg9XDU2IjpzLe/OalE7Z2Om7r0tfgeGF8IRySYIMCeweNm84ZX3
	 WikvIHfv5/BWLvSZPnZbjZwgD969WHf6t9Y+DGXIV20FWKKW0Fvkj6T6fah7I32jen
	 p4W23Z87fCyWV4H4cPl+wSzYJhsB3cfDFdmbACgI=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261028040419epcas2p1f7fc59ba2429938da022a301f337fd64~ilcFQaNwF2264722647epcas2p1i;
	Wed, 28 Oct 2026 04:04:19 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.211]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jDtz66Scqz6B9m4; Wed, 28 Oct
	2026 04:04:18 +0000 (GMT)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Subject: Re: [RFC PATCH v1] mm: memcg: skip frozen folios in
 page_cgroup_ino()
Reply-To: daejun7.park@samsung.com
From: Daejun Park <daejun7.park@samsung.com>
To: "escape@deepseek.com" <escape@deepseek.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "mhocko@kernel.org"
	<mhocko@kernel.org>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, "muchun.song@linux.dev"
	<muchun.song@linux.dev>, "david@kernel.org" <david@kernel.org>,
	"ziy@nvidia.com" <ziy@nvidia.com>, "willy@infradead.org"
	<willy@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261028040418epcms2p7ac0f584cdfdc6a0ea9b7f20eadeada3d@epcms2p7>
Date: Wed, 28 Oct 2026 13:04:18 +0900
X-CMS-MailID: 20261028040418epcms2p7ac0f584cdfdc6a0ea9b7f20eadeada3d
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261028040418epcms2p7ac0f584cdfdc6a0ea9b7f20eadeada3d
References: <CGME20261028040418epcms2p7ac0f584cdfdc6a0ea9b7f20eadeada3d@epcms2p7>
X-Rspamd-Queue-Id: B6B9A40005
X-Rspam-User: 
X-Stat-Signature: khpua4strhj3irmoxbcypgg8ma4msi3w
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793160262-690413
X-HE-Meta: U2FsdGVkX19EMeWmHHsVq1aE7XeXBEBG58+c+ygZ/H5yV0sm9tkPbCK0cJJB4wrC0PMrUSnThT+cM1XQEsPt/ptC4rYVtyEtI6DFQ3P26t1QauH+vuoZTw4VX5vqwS4FMpSUXPT9rblEAE1n1niGvxLrmS01K9hi40IR7ZeS+PYMDBUvWt6NbVrUayCSGq6AFmRgV+3Yf6J26uVMkb8+ESrgCisBlqhYQgNxJ0mzlTi5GhEipVez19PqJPMjxjXbHCu2B856yQSgJFdBwXzBEnD1Qi2ijfq22kH5bZvlOcR3lmaQaT3lY3OobvsWQN+U2d14AhQmVYS10LlH9ehUm65gNmP7//bzRR6KTi+SkeHOL87uK2feVKdRC9mkva4y3NCwj8JtOsJOBAj5nBfD85bED5W46mAQSqMMtkfDAmKd0+hOOX0/wWpnDAL4c6FKMcKT/pLt2lGW9bmCXv/oBPdlv+gJarLRiF5OfP4/gn8M4v/aAV0NhsN93Rgxxlba4loPwbbZmoBh67zyFreEHDtGRlt2vlhk6DIQ3ncV4vP0wu6QPyEK7ksi8h/ie5zufpQmmVW2Rr0U0kW+TJS34NkMAVpQ08mEaO10tVM9Gkw41IGN0XyAdIqEX29p2rJZscS4C8iZjj+mUFPdKDzibkD3y2AGEmS8pJKZprt1wrjphi4jqxF6AUOizRUYR17vAq/FNIeZ7cwDdNqWRwbtBR9nMuj3gcw2go+C4n2+8LR8qiAkLxj4Bs/tvUACRgNnv0srl3+2fB2ddAKiEfsliNfMhO8s5RUUQZ898a+34p45xSW9YxFGOHW8NcL9l4kYx9w7M8VeupXIc+2xor85g8+8H4wmTGGrSDGVGysVcPxykA6Sg1eUnWRTnrZc57Nsb8Gk3AOP0ykwS7s4af/otsADFJN7mb8YhckFKKDxx+qbxf5CD3xf+LIqyGXyhjGHKY2YKbbcx3To9rE1PeW
 7LoYtkLb
 x4dlHjvXX8zWHIc9tp9nU9teSYsZUp3FFYulc3Oe5p0fbaRNWTVqBwiIJHbVvx04aAMb3SUPYUuvx10EUFL0tHALrgvNijpgNEU4mrq+FhalWT12kLEgNE3xwJtqk9peAxtVh9O+7Hq7GTKlHPyv6X1QPwVrccwNP31ybCWoy3gbTX0JwUIJHcENWwF0/t2Vi/y2TqslRSiOlDoQ5BL80vaOneLLtZvPujunCrN9osr5bcP/YUukMYJmH9FYGNDIdLZ2IdfZzRoNjcJMK4QbkS8bhLCKNqPkYCjfgEUHKHBWwt9IIw0CMd32vx3tZJF9Dce701T5UjXwcD85ejlewLCSUGGxQwqVwo7/W/BbX6DGktmNuNmEoNOhEP9HxR8LCb9T0Wj1f71Ukz/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Sorry for the new thread, I was not on Cc of the original mail:
https://lore.kernel.org/all/20260907124001.1544655-1-escape@deepseek.com/

On Mon, Sep 07, 2026 at 12:40:00PM +0000, Tao Yi wrote:
> When a large folio is split, __split_folio_to_order() clears PageTail
> before copying the original folio's memcg_data to the new folio.

Thanks for tracking this down. The oops reproduces on 7.3-rc7 here.

I wonder if the fix belongs on the split side instead:

- The window exists because the split makes page 1 a folio before its
  memcg_data is set. Before commit fa23a338de93 ("mm: separate
  folio_split_memcg_refs() from split_page_memcg()"), memcg_data was
  set first.
- A zero refcount does not always mean a split. Large kmalloc pages are
  frozen but charged, so /proc/kpagecgroup would report them as
  uncharged.
- print_page_owner_memcg() reads memcg_data in the same window, and the
  refcount check does not cover it.

Copying memcg_data before the smp_wmb() in __split_folio_to_order(),
with a paired smp_rmb() on the reader side, closes the window for both
readers. The same reproducer ran 300 s without an oops with that change.

Would you consider a v2 along these lines? I am happy to test it.

Daejun

