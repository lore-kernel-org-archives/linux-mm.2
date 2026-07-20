Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8FA7C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 17:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 661A16B0092; Mon, 20 Jul 2026 13:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614786B0093; Mon, 20 Jul 2026 13:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501CB6B0095; Mon, 20 Jul 2026 13:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 260DC6B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:35:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E37180251
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:35:14 +0000 (UTC)
X-FDA: 85009856148.28.AFE2292
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id D56BF2000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:35:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Sp87H45c;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784568912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VpgEGbQd7TUjFEcy4MwyOPp2fSwSzsT74h5eZuIrKNc=;
	b=q9OYlaFt+86zJbJdp3A7i5YJ6NdQsapo4Qk+sBFt4vg6ar79qPf9qlOr2Dg3iCsd/EQ++s
	9KyauU+Olyr8/mF2PW78OaVd5L/ElElb7vT166cesogd7Rgb/D7YGndvcnrs1PwaOHAH9d
	BD7YXxF55jy6Jr8Y9MG25W4/aM99bas=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Sp87H45c;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784568912;
	b=VhnsIpm/1+43kkNWaRHWhBubRKuIkcBSKYlhBluc0vuahIbdcOXOeHhSjr7Ra1XZyt0KTm
	2/64TGpHjO4Ts2BI3IPwu5OI793nmgLFxKgN1bSAmOJP4r0+pI6rDk7ADH5g1/Be3wG/NV
	YYtnX4CvS9SH5cG5TdEXia5SLZi5VBQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VpgEGbQd7TUjFEcy4MwyOPp2fSwSzsT74h5eZuIrKNc=; b=Sp87H45crDR89XUlafK04T1y/o
	I/b/2NpEeAeRnQBadvGb72DkxwlguQl6tUofmiDsjeo5mO/LWih1G6hnM7Z+lEARQGQ+RJPXRNdtv
	T+qYaVKqv6P0ymHqoZJxZ2NsfuKXkSGiuEh5FnXzLK6BTcK/6+ozaV+vbG2VIbqZxjMEKEuiUPyaZ
	qfaI2NHjMIz8HQ4xMWNT96PZUDFAGvlnX9dvR9YcBPSbitfgdzv4jTscRR53wthhZTdPUkeCxsK8O
	pZTPHyLxLMiNK5IFk81GPB93l4sWHbvjCVXCuGG+D2uNfCmeXTYdvQ+1xluzEuJq1iZaEc+jTLi5b
	H2ezgwrA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wlrt1-00000000359-185o;
	Mon, 20 Jul 2026 13:34:39 -0400
Message-ID: <51c0025d2eb885ff1f4775e4d9ffcf34f478f378.camel@surriel.com>
Subject: Re: [PATCH RFC v3 2/6] riscv/mm: add untagged_addr_remote_unlocked()
From: Rik van Riel <riel@surriel.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 	kernel-team@meta.com, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes	 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan	 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,  Alexandre Ghiti	
 <alex@ghiti.fr>, linux-riscv@lists.infradead.org
Date: Mon, 20 Jul 2026 13:34:39 -0400
In-Reply-To: <46dc1b58-f2de-492a-9da5-a5c429c19a10@linux.dev>
References: <20260720115741.239657-1-usama.arif@linux.dev>
	 <13ec2603d5cbfdc493939f182b71e5133c26af54.camel@surriel.com>
	 <46dc1b58-f2de-492a-9da5-a5c429c19a10@linux.dev>
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
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D56BF2000D
X-Rspam-User: 
X-Stat-Signature: od761px9kgtig5s93bndhwqh8xjoztwj
X-HE-Tag: 1784568912-977827
X-HE-Meta: U2FsdGVkX1+p3CuKZHHBc6p6nP6aEswJlVAJHAgDf2VjAfT2KPhk9p23M1h1292+xqAVtI8KWdRCm0lCPveyaYGYaiQjCmOjQYFU84FQ5PEt0SugTqSZuqIIuu0NWwOH1CN1jEF0Mw2kJ4LDYfbjF/NtwbHOsOe2Tv7vF8nSkTsWN+i67JmeS1JULYv0jX4i3vOKLDdl6ywD7OCOHyiuAMSZ5f4hnbz7LaL4xKNwvB6C1BOCkEfWcPMi9HyyTuSAhggXT1CWwZbQEv18yfiCOGGC7FqmzsFTqpZRc5jUAAWuPc2J/rGokEdZMcsVGMgm84nDRdeUtWccXUcn5DIK7B960BbSB25+xoEa+if8s62OyknJ9wl0m+ABG2nPA2QoiQxhF0vhiQQvyfrcFZh1jsVVkKLgzMzRqm7QBbTOczAmWPek559Q/KqFSETZj0Q7ZBLCxWcucOsLZptKI79e9NzA09UHAHLPkMPOvc1kQQ1D+C3+Rdxml9pUz9+X12p+7wca5MPZgiDiFdtuE+4LIRCSrYjvURhWlLMBblqzWpTtZis6rQa14/MPsebt6I04NQ0YHlqxh+Sqh7oDjzDt3AMMhcFajn2jK9YWIRq+77tG/Lc2EmtvixzSCl+qKOI0Nbg9Up2NmsLaDNmW1AoAn1ve9rl0TB9X74QUf2A340Od9J4iSUkb0t+HLODoKHOSL9z3VpXccrD2/CeHohQDVBXE+7O83O6fQB5WXCxTJoE7KD99mAVfHpDsnxq0Z+effFauKgMffvgit4bYTff5wHEkF4YGY3DvaWXkEKOaMCXHZT6wEtTwowt/seErT06+bG9+zRR4M6Mtd7pxHj6o3DwThX5kr7q+DyD/T0qpzEnA8Ps16IaJmOW5lKz7VgMLucFYniMcMyznzvmq5J2Uv8Lq5je4zSIhoaYIrno6VdbTC70BmmN/y1xE8OMqR0ZgyUSLgakSdKTNi+Ogter
 6XAbt4Ou
 cN4/Gk6CJOoA22vrG4l0M9rS8LRJ9+ne8z25p9NSEbjxkPEL3FN+x0UHhcqa5qp/q/6KMKNWcNdML13ExCgoerqoHEyoZKLp0yC34VdTdQRV7Ai0QmklSJfOcspc7AsICgHdXk+s+VRZjRW94HGydOdwitsnl0492R9eFwJra2M42TT8zCa3v5rCxc29gxmdvhK3vzTne5UKdv6FD1HVZp8fqLmmyRWgHrJB/uL/FyCsmUZUdjH928QR2CaLYPxlCaExeoncIdGuIwJ0WrV1i8KrCdFOwKp9XLtyw1hN5GorL4QBO6FHdvRl0IjvWbGpwYGQHr/7rB7nCoNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-07-20 at 17:46 +0100, Usama Arif wrote:
>=20
>=20
> On 20/07/2026 16:08, Rik van Riel wrote:
> > On Mon, 2026-07-20 at 04:57 -0700, Usama Arif wrote:
> > > On Fri, 17 Jul 2026 13:00:32 -0400 Rik van Riel
> > > <riel@surriel.com>
> > > wrote:
> > >=20
> > >=20
> > > >=20
> > > > mm->context.pmlen is set only through PR_SET_TAGGED_ADDR_CTRL
> > > > and
> > > > is stable
> > > > afterwards, so it can be read without the mmap lock, as it
> > > > already
> > > > is from
> > > > untagged_addr() and mm_untag_mask().
> > > >=20
> > >=20
> > > I think it might not be stable? set_tagged_addr_ctrl() can change
> > > it
> > > repeatedly until a CLONE_VM operation sets MM_CONTEXT_LOCK_PMLEN.
> >=20
> > You're right, ARM tagged addresses seem to work a
>=20
> ah do you mean RISCV here?

Ugh, I looked at the wrong one.  RISCV is like
x86, with a dynamic (though a limited number
of options?) mask.

Having said that, won't a process have all of
its VMAs in the masked-off area, so coming in
from a remote process to a valid memory address
should already give us a valid address?

--=20
All Rights Reversed.

