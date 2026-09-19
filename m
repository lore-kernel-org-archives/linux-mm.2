Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692CBC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 16:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343496B0088; Sat, 19 Sep 2026 12:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3D26B008A; Sat, 19 Sep 2026 12:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5946B008C; Sat, 19 Sep 2026 12:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E085C6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 12:22:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E122014024F
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:22:46 +0000 (UTC)
X-FDA: 85231030332.16.DA8268D
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id 896C7180004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:22:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="arcLEb 2";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789834965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oe3N+uS0QPFJ/FFJyoZURZ9yar/4u8esXnbjRjNR7NI=;
	b=fRreg2DbLLGmwUvqGIMA+IGML7Zr8RR9AP7Sih8XsiNSrwVaOUix7G5ZK+Cg3aZh6HWE1J
	51aOY+n536lOK3anCYqN7icQ2iRYXCQWuhOboauYFhuGtjx9oGx1qrhW0ethl1bCJAy3Bh
	HjBsOuyRgP2doEEbNkqdnjH/KntWHkY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789834965;
	b=xmKe/Uo9vs/mWH4co+s6LShylJDvNGiIUPyi58DMHUk5+Rr5gi6yBtoNgz50WQQNO/7vYP
	9t93F9BWnkqpCu7mVAL0y7DzgqPboReYusjT7dKghJnkmRDIxypdVy9WR1orbreg3I0poB
	BoJDeq3QQnUF7WZ8q6pw/7MyhqYyf3k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="arcLEb 2";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=Oe3N+uS0QPFJ/FFJyoZURZ9yar/4u8esXnbjRjNR7NI=; b=arcLEb
	2CeUUpzCxBoMZbPq+6APyrTcjBmjWSdDoMptbEDMAUYH5nO3Ps7esFPKfvynXY8q/B2PY1vs7BQFh
	x6cWtTCbVAMhocYl9K+/oaS22wp7w4Gi3ZxhioGDvwv3mWKOdJ9kNnfBPVTu6qfnQUk4ewadO4GI2
	XreMzsokA78ZVO32BkujrFWECY/RJLt6Ll9mtePsMqLWpmqiePaYmMSmU4r4GCSERTMEoQaLWZ5Ve
	zpP6cNBJkB4WEacr4ebnSJFkGFAg8TUEn7NKJ+4vc2LhXMmx42HyGl8kf707O3wY5JBgX/lbmKm11
	IH/9e0V+V7zPwfcu7/BPIMrCHwbg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x7xjJ-0000000CHJQ-2RY1;
	Sat, 19 Sep 2026 16:15:57 +0000
Message-ID: <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,  Roman Gushchin
 <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, David
 Hildenbrand <david@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
 YoungJun Park <youngjun.park@lge.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)"	 <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 =?UTF-8?Q?Baghdasaryan=EF=BF=BC?=	 <surenb@google.com>, Qi Zheng
 <qi.zheng@linux.dev>, Axel Rasmussen	 <axelrasmussen@google.com>, Yuanchu
 Xie <yuanchu@google.com>, Wei Xu	 <weixugc@google.com>, Gregory Price
 <gourry@gourry.net>, Wenchao Hao	 <haowenchao22@gmail.com>, Jonathan Corbet
 <corbet@lwn.net>, Hugh Dickins	 <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Tejun Heo	 <tj@kernel.org>, Michal
 =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, Meta kernel
 team	 <kernel-team@meta.com>, Linux Memory Management List
 <linux-mm@kvack.org>,  Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <ryncsn@gmail.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Sat, 19 Sep 2026 12:15:57 -0400
In-Reply-To: <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
References: 
	<CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
	 <aqJXx2vtbKaRLt3x@fedora> <aqLZ5TVDAqEbIeMN@linux.dev>
	 <aqP81aqNbwAbs2P0@fedora> <aqQrPLPXHXiuKup0@linux.dev>
	 <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
	 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 896C7180004
X-Stat-Signature: hjx13jf6dmh5ktd4zso5f8hxtu6zdobj
X-HE-Tag: 1789834963-407662
X-HE-Meta: U2FsdGVkX1+4SXbiyZiZ+DU/h6Wrx5xS9BgYl+7roAt/qWqknAdZsdIAVDitKDyOhRRi/3g/BJSqBeH4NupR+/KrReo+c0u0VTvp1KNgINCIw3+p4yTfl+fjyPRkIRL+EZCiMX5agJ1Md6KKbjEi6sMWR8cjU7EExiTRp65NXjkQbRGTohpgo7bTsNO2bE6juXEGbk5EVUBpu85Hb825VFdpS9gFu8OPPhwdp6M1NfGUuHgeVOcbIVFF91OrjlMMLWNnISEdH4XZMGwf0igYhhTbCiViGVccop7JWiJ7mTkG2tQZzX32nVURnfYwS/q8plHBSwZz7vqdTB+8uG8E2/OvVGxG0dFpeVO53UH/+f7aZcxjCGpDXloXieAt0ocY9BpuEwP/EnMEKucRPXRueLI8/aUODctSOXL6EzL+HJQROEw6tBfLZZuKnBs1PmOMrtckLRbBhcvFadz8YlZBDKjWUBtWF4WDF8EDUyuXhzaEoWjH2RtP9/JMd3YwcU6+GTFmL/62iYMn9otd70QF23hc7xxXqr2QDVyOBTjUnvfktFTg8xWsRwIofwqRLVvuSeGqJ8z2/DH5Bn+6+pNK3CCx27uQiD4G6m9ltVInyfz4lGks84Y+IKvyOOE8rh3UOJxLbMJU3pyoG+Zb6ivjWcmaEKylHbqK97ZPd4pV1HKg3zkcsn/F8xuafSAz4erHv9ds1WKvGDwUvw+lPD6Z1K4LQPS8bGuYJ9OUfUj8WTvotC/gNhEv7K39KOD30wWZkX8wfkA/Z1J/ArKpSJVIGeSG6kXsiNIS5Zv+CF0DmZr5D/4STQlxUNatX03LLqd7nxZSZjuBRZ4zvoHIDpCE7zjVo3W1CspyaQYLmRwxBxRREkEk8IHNmiUfBv3zTEmddz5cHHPbpE9d6AS/diZ3GyBXqwWbEnd4jImxnDnYflUGeBwCi1oJe8CZA2m3zmAvPL8BQNK7qoEnCVMeeKO
 6xZ9l/w8
 0AXL2FFzyZmb9oBCuZ5eptCTAaUZ0qkduyLythqe2ykzyn0K5blz8yGPVUHuitSQmiJlrAFsMoI6BCpK4cFouqI78i0Wb9HPAvUxP1jA/+UIsJ/12dVkZ17IgyLsfOUg7YAML3PkQjZHWKE3i6iaRre5pruUqcDksugn+4RR01WN8Uhc8qV4u9OhrNCeHxYN1L17xqsKr50S7zqfktYnkmgvtwlRh/uxruLmoRLDVWP+Ulm6QqRMO57G5BPpiZ6kkwEeDp1/hVsqZWYfCUKPsD5RQrnbBwrfCSjaANiPH95TfcDZPqTHErsQhqwe8x+chdLtD87XLCdsh+V5c9ekB6XNV/jBSF1f3lQRMFOpGb8xR9J2GLvNp8MbfGifgulDn/kPhCWPUKwp6hXd5AANfU978Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-09-19 at 01:55 -0500, Chris Li wrote:
>=20
> We don't have to address all issues in one series. I actually advise
> against lump too many patches into one series.
>=20
There are two things here.

I totally agree that we can merge things piecemeal,
and not aim for perfection at the start.

However, I believe we do need to take care that
whatever design we go with is actually able to
support the end user functionality we want.

We have to make sure that the path we pick does
allow us to very easily add the user visible
functionality that people need.

We can always swap out technical details behind
the scenes later, but user interfaces are supposed
to be stable.

--=20
All Rights Reversed.

