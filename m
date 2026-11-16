Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C15D606A880
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=RmszHc0C
Received: by kanga.kvack.org (Postfix)
	id 35C8B6B05B4; Mon, 16 Nov 2026 18:02:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30DD26B05B5; Mon, 16 Nov 2026 18:02:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FD146B05B6; Mon, 16 Nov 2026 18:02:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFEF86B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:02:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 677451C2F8B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:02:31 +0000 (UTC)
X-FDA: 85442508102.26.E6D9D19
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id C560D10000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:02:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="RmszHc 0";
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WThR+UqE34o3lpC1ytNuiTjImnwIUnQa1repMccPxg=;
	b=4sAgi137+TvZtCl07asxk0bKGxwc4dTiY0cQS/vzGoYz5oVZaiZan+xeJok5UEa6X+OBAa
	oSqkUNPjKRj6eOHPNGFyFPmduGyfHPuMKFgg6eiM02I1jk6ycGFHu7oQ4l1/ySesoyIKTK
	vHUr9V6rZFFv4M6i5o0zF3DKuunGc9M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870149;
	b=U2Y91LG92QgId6IRKwJjzwbaRsUvoewBEscpEUWYJaiGuQCRamPhTE+HhF7tUVQqwoSm5V
	0Hu9Xqm7hULJftzcAEpssnM8+dd8ya4RgumtFAJkCnBVON8TGQECaxgCvQeBSCQaFcAagw
	gGEJpAXK8t4z+JulGIvPXzf+PvsljlM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="RmszHc 0";
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=5WThR+UqE34o3lpC1ytNuiTjImnwIUnQa1repMccPxg=; b=RmszHc
	0CnOPJyqg+tKPcBjBhz42YOx3X1P8KCM7qlREN/a2q0VePJ6bbwZ1XDxOMA+O3vEMeR5SpSV57ef0
	rQ+EoIPicylm5jWyeIlqJWCrf1koFnPGUflTUl2VxKWaaXokosqmEamc85QY5RMdjkXoaY9LN77Gh
	EZzUnQFmYrfzWalegBAAo3FNepH1iapFTh+8StCMtGkWYiRLlLlR5+xpqJYjFmqWnQHUQ2aell1PX
	yxs95QLzbQofCYE0Uw54aJpcA6padqu7/yqPdz6LHSCbXxwd9jIesHqHgCoWykqOA8e1fqmLyBeeK
	7daeliVGFLW0sTbeXP3XtYph3cBg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xT57N-00000007mDE-0p4b;
	Mon, 16 Nov 2026 22:24:05 +0000
Message-ID: <b2262da0652b467673109d12b5e244c15255a925.camel@surriel.com>
Subject: Re: [PATCH v2 02/15] mm/hugetlb: compare against persistent count
 when freeing lowmem folios
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Muchun Song	
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Naoya
 Horiguchi	 <nao.horiguchi@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, Andy Whitcroft
 <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>,  Michal Hocko
 <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Dave Airlie <airlied@redhat.com>, Jason
 Gunthorpe <jgg@ziepe.ca>,  Lorenzo Stoakes	 <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan	 <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu	 <peterx@redhat.com>, Breno
 Leitao <leitao@debian.org>, Will Deacon	 <will@kernel.org>, "Aneesh Kumar
 K.V" <aneesh.kumar@kernel.org>, Nick Piggin	 <npiggin@gmail.com>, Peter
 Zijlstra <peterz@infradead.org>, Heiko Carstens	 <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev	
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>,  Sven Schnelle <svens@linux.ibm.com>, Arnd
 Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Gerd Hoffmann	
 <kraxel@redhat.com>, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org,
 	linux-s390@vger.kernel.org, stable@kernel.org
Date: Mon, 16 Nov 2026 17:24:04 -0500
In-Reply-To: <20261116-fixes_hugetlb-v2-2-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
	 <20261116-fixes_hugetlb-v2-2-4dd9e94ea9ac@kernel.org>
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
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: xzsdc8w1ig5djaqm4bajg43jz4bgq1wy
X-Rspam-User: 
X-Rspamd-Queue-Id: C560D10000B
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794870149-751988
X-HE-Meta: U2FsdGVkX19BkbKb3O82znMv4fyUgF+OGSX09qybJuhXd66a/GyDwDaX89C+JpUeWeXiyA6QzXh7gz3d6jA2uRI4RTyqJ6sDD+0iIx9Wf7y6qassWnB4oLtCQcQmmjSSXCKSKWx7XNFmN4IZS+70afJza3qrERZQDbrrT9JndjLRHtpaNb0i0y/hVXNOR0FL4mKPQNsihFg408fw5zPlAyH8V0jfsYkBoPDuMXriL1pTeWGxtgEiWB9+8xKENS3gAnFF9ui6Sxd/mw4l845MEMkqBLd0ryE/Z8ozZB2MgQwaOTTtTQiFQgMbhxJYM25iRqYAtTlCP0/CRTHUaISeoUGJyOJ+FumOx7eyBGjQZVgGT6j5Kv7iolBXyZbdXQtZn9HeE+Gwo1yA96S9PCyPohBUjsyillhcFYyVq0JAtOnuA74ve2rWBgNTtSbFL4OFL7ZWJ0yXSjnfK10/sdfn4u6WigghdO2873TbL7G+qrdqr6t5CmAmmh3yxS3kGfI6eRQ1HINE66tryPBHfirKYO1xkwepf+0qfQ9g5ugdhQnZ9nDbbETDc0Hr4/GsUxSmzb+OpHEwQQV/7nie4UPCuuoxu/e/KYi8r+18AvnRVcAnBXGcmnOFGS5yFvdwvjSVMWP5C/BgSLZ+hKCUbhcSFXY5+kY3YBhy8oYMDDuax9lHBBKIJRHevyCx/rrEwfmpnZ+6U1ZWT5x7v4MQf/0jIJMv1TtwfNytooCYX/NwHl10fstUOJ9hcL/9m9IKkz+JUHAZwzRPGxpwhYveBoFz4uhb9kTxJm72JwWbN3Kt3ISOXr4kBYwrC4CTQztCncUQa1xP4ZCNQFgwpZT8d8gzMKSeWEcfcOEYxm7TgE/GUYbrc9+qbl9JfmYbc50I2e7qoJVQkS2FRN1ww4g0FuzaoauaRLni8uPFaJaSb53Jod2texG63RCmVRI4WjB/XHNb0odXPxQLB6HdSphXi0T
 xN8XcQN0
 LObvD/CqtjypMMDR4vZQ5LZcnImEvKI33NX+ZnQiac/sbRDFPUAMPB3Dp4BWi49VuYlxp4M3gjikh3keCdt1B71aB+ijJ8ix37jEk5PjnVRVUtWaIX+JLfDq+X2ERYx8QiQM8i6zHMs3Zg/TjiVYsb5oUZvXbfBXaTaH9botw2UijqUrg2KuoiUH1HQcSmTMwKUCmU6NIH8BJw/CjWtGpiwd9NuMcHe0jKG0pLsGHjoi76Ur3JFfJCsEdsQvYThNs+nLOWxvTTrORjmJwe2zqVZhuoKSzv2W+MmeB9AMkyVvlgjgfTYSD7fig2SQyRNAFyzyNnelfvlPNjcoyI1XEdC2Qp+4trH2aq3ezy6qf/92VxshgzF2DTuvEmp5UljgfDSf2q1Re8Z1P4M4WRmglr2yVNi/T9s3EaERt20NnZagVmqqu++6V8TpiiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 19:29 +0100, David Hildenbrand (Arm) wrote:
> try_to_free_low() gets a target number of persistent folios, but
> compares it with "nr_huge_pages", which includes surplus folios. As a
> result, it can free lowmem folios below that target.
>=20
> For example, with two persistent folios and one surplus folio, a
> target
> of two can still end up freeing one persistent folio.
>=20
> Compare against persistent_huge_pages() instead. Convert the macro to
> a
> helper function and place it before try_to_free_low().
>=20
> Fixes: 7893d1d505d5 ("hugetlb: Try to grow hugetlb pool for
> MAP_PRIVATE mappings")
> Cc: stable@kernel.org
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

