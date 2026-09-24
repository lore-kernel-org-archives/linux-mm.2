Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B9EEC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0FED6B0088; Thu, 24 Sep 2026 14:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2806B008A; Thu, 24 Sep 2026 14:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8036B008C; Thu, 24 Sep 2026 14:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 861FB6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:15:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19563C0465
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:15:13 +0000 (UTC)
X-FDA: 85249457706.03.E2946BD
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf08.hostedemail.com (Postfix) with ESMTP id 64CAC160007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:15:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="OAIh3W t";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790273711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wX8CSj2fNMWwCN/CUlUpxrxanIa2BZUzno2ME71/0zE=;
	b=dzJ6MtX4nZziaMOiqA0nxzme+E/bTg3sr+eIs81jLpqtfwva4K2iiTH6ySYcrumbEs9D5f
	2E2VsLSTLRi/XIFnGzyzyAjcbZDvI+/7IkbWxkJ9rYv5GRaMWRidGn/xdOCn084cv2tXEZ
	s6skiNwhJQe6CsOdUmSi+FAvkKb0b5E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="OAIh3W t";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790273711;
	b=NXzxjm9TmGQwqWvspDaqZ4+sATblIBTPx9f4x/7toWnoNHaQ1Tn4H2+Nv7OdHBdn6PQkMM
	bKZe818Ro3+NTExuUJpEY95Y72VtAHsnK8fHajMBY6vHGp7JkiLziKZmSfYGkIO21zbOPP
	vx8hJTd3ehhgkmTgqGcwSopq8jdy0HQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=wX8CSj2fNMWwCN/CUlUpxrxanIa2BZUzno2ME71/0zE=; b=OAIh3W
	tGD3YH8owDqUp8FviZpRcyXxHQqpTPleog+faXwIQZh19fWn0SW/U5aEYDzlYglaflJbiiF6t1k4m
	bo+fCQ0U0Q2u0m+jicUUH42aRuCUD15VoZfupmNR9d8u1FdUiLCnRKlFLcun1d6znBHhkFXN2lBhP
	TiBv7p9NChjggdQrsD/M/jrX1xnYse8KbIMqauuw+rhFMSAcHD5KnyOlz6L3YYHQNaRLX4pj59uHO
	GRAYtKLvk5mtHCh9uydQQD53zlJ+Vuqv4n7i8XdEEFAfd0maQ1ogkh90OFcOznMeq0pxq5ksBHe7G
	a4XmqjJKjRthdWfxgUF722GpMqHg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x9nvx-00000004TfP-3vhu;
	Thu, 24 Sep 2026 18:12:37 +0000
Message-ID: <7571f005bca65aa4ad5e7ec89e62801ad058b689.camel@surriel.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device
 infrastructure
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, gourry@gourry.net, haowenchao22@gmail.com,
 corbet@lwn.net, 	hughd@google.com, baolin.wang@linux.alibaba.com,
 tj@kernel.org, mkoutny@suse.com, 	skhan@linuxfoundation.org,
 kunwu.chan@linux.dev, kernel-team@meta.com, 	linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Date: Thu, 24 Sep 2026 14:12:36 -0400
In-Reply-To: <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
	 <20260918180241.3424851-2-nphamcs@gmail.com>
	 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Stat-Signature: jhitr4o1sq7wbg777rybqqy1qeynwyqk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 64CAC160007
X-HE-Tag: 1790273710-397859
X-HE-Meta: U2FsdGVkX18jbqqA1ePqIvtVg3DdiBMi1NsS50K57HYqna1CwZWMLJ8JZ+GaACJQ4Winjz4rVMUQjFIhvQlqhuafdyz00pHspkvVpe2CX70JQm4LRDslMyUzAe1MH4q1b0BGgZkGw1m9l66ie+nsbN7xta6ZZ7hhtdl9CALwRGWEXe8gr1qVsee6vVm3HT8O+S71X/JxnykF9s+Eh8D0mCM9+Zk8oPptF+Wbcdm90b6W5++CyIPXdeKFXfKtrqfQY/qUrPPZF5BwCYcezDr/kc+rUlj/yXnvRsWTT+nzsMQFOqn3ouV/ClMsysr5+xYusac0IDPpYN9cZF6hmvVQFI+eASpBQuiO+9qU8BkuRyKB1uZe9BcAwBB6jMoRAY97rQqEpcCNQqaa6PGkxJhGTRtI21zatJHaYrz6yinOPFQXSylUsyf+aEuPa6L2SAqxvhLSP2sieSdEJse/yYs4vTZX/uki+PfCKp1jqRtoXzl8wg9RB5BKEXXJjhjB0+x2v3BJU/R5YwOf5HKalcINpgH/PdoZOQ/0rBlnyYutBsKX37k1f4yFfPw6SG5WqdWQfMTJMXYiMosy6ZlZqMT6kzPD3L6nDTvFbVLi+kGjpvUEuEQsTL3VJ/TLBZFbMOFNCG598fMjratRiASuxPVnypYw79XOlh6GZIb5bGd0NqgINpJUWixU+IThOIl2kSkmBemxu+5k3GHrI7+MuaO+u7LlFbfvFADJsOIXVT00qCOUczNTCSKzLvHoMTSMlZaUOqFpya1gbBultCa90rZNCuR5ngLOgqnwheky4mfBydw6VFmGcv0KMZnyT2vLXui9INryL3m9Vsd2Hxnf5RfytT7qtL95wEXe+M6bHQeXEH+1Xg/11uQpTVKXvCyR7rPamMKQeCQksZXRUh5syz5jvtjFUca4IgBKqWEhxzHGRbyeohQaBqXXNasrEVbsJkNXpegv6FAXUr6DOWCk0BQ
 HAmS+nna
 ciVnUVdssmLLMB2D/loBxNVTjnpH1cQspWQizhqiRLCy8dYKk2+J6cTEM2LEgyUDsqQTHKJSM5ITVgrb5wIeyKVme5JcMBHxaULAIWXW62kYG6Cb1LY4f5gG7o+iRuRZ/B7tWpT3XEQQR5UcQgXNLWn31fhRVuiuoE54ZgiySuHMLeCxnWTdj9tIyeub+6M2ibHjcasMPXS1Bkk/oUxu4cVcoJggnRtPSDx/xVqsrEltaPjpyRKSoz/vKxLH30gl44RVYBMldwVmSBXCSxTFLiIF0XduQwFCqrYKow14AkBYD+37lATxxP+7KHquJlevZ7a9CAcIWJFgR4g8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-09-22 at 23:18 -1000, Chris Li wrote:
> On Fri, Sep 18, 2026 at 1:03=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >=20
> >=20
> > @@ -482,6 +491,11 @@ void swap_read_folio(struct swap_io_ctx *ctx,
> > struct folio *folio)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (zswap_load(folio) !=3D -=
ENOENT)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto finish;
> >=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(swap_is_vswap(sis)))=
 {
>=20
> There are too many swap_is_vswap() in this series. It fragments the
> code path, making things harder to reason about. Esepcially around
> locks. I count 22 in this patch alone.
>=20
> I consider this the biggest drawback of this series. This
> fragmentation of the code path.

Could we avoid that by simply always having everything
go through the vswap abstraction layer?

When everything in vswap, we don't need to test for it.

Handling the details of what's behind the vswap would
be handled one layer down.

Chris, do you think that would be cleaner?

What am I missing?

--=20
All Rights Reversed.

