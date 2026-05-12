Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F283CD37AC
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 04:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B43B6B008C; Tue, 12 May 2026 00:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 965436B0092; Tue, 12 May 2026 00:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D5D6B0093; Tue, 12 May 2026 00:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 695946B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:20:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00E298BFB5
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:20:20 +0000 (UTC)
X-FDA: 84757465842.17.65A6660
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8AE2340009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:20:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=kxoxKVIq;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf11.hostedemail.com: domain of "prvs=35921a2737=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=35921a2737=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778559618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F62riCdP1r2z7EgvCidHPwhrIpCSMkxlGjn8q6NpA/c=;
	b=DGkNaXIacuEYX5dNZuC75p7nsbRVeSl6sze2hK/gvbm0YGun+3vxGQcfI5+dP0S9M35oPp
	Ln0sMiQeO5J1ZA14QTrZuuK32lXriIo1Rz+6nnOEvGbjIW6Vsykb4S/AL7oXBq42YDvIr+
	Y9IKuicelnW2wnFgHUyoK3uhBkdjluE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778559618; a=rsa-sha256;
	cv=fail;
	b=GIxC2k7upFRmX2ZEmnNnO+bVU9t+wBVAYegSEeb8JFJuGuDud30Gw91qmCxfs9qhT5chU0
	n2TVwpIUd9TFuR/QblbBMcPIf5qTIIEnOqsgPA/6RNk7BBweU4i6AVtWRST77yofi0Zn4r
	DHI0gJbkPQdysZSLlg6MuzIrnpsX3m0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=kxoxKVIq;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf11.hostedemail.com: domain of "prvs=35921a2737=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=35921a2737=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64BK8B1m2397735
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:20:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=F62riCdP1r2z7EgvCidH
	PwhrIpCSMkxlGjn8q6NpA/c=; b=kxoxKVIqS9AJ0Voa4xunhpfHGur6H/fTWd/P
	ZTch2fBfiO6g/nbnzWXvkQbXQBjzbNHM5x1LKi95+Ca6gFQT9VrT+Fxvt8YWFRn8
	2ljl6+iO3K0PquYXNGvBvjv/PzLF29gXbRg4sJoE6Ja27varJXAMHv8hU8uCjRyA
	2C7nglgB6QPa/8t8pYwYm29wGj17pI7SHtZrlFV0efXzpDBk5oWvBqTiHQdyMIgJ
	VUbWkVfjQV0T9DdwMlyzk7Mq1QzcbFY+OFykSycY8MUK89qMV0J5XdgdPisSTxV9
	xdP1CgWAQSNMIjmy6aVeq8fZ7yAte0UGsrTN3F6ilnWOGy8ZPg==
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4e3nvqddft-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:20:17 -0700 (PDT)
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3940fc93c77so9771641fa.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 21:20:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778559616; cv=none;
        d=google.com; s=arc-20240605;
        b=C4bcxocvRp+EDLog6HQ8nTCYqHh+4EK4/4fWGQOFf2F1978n4o8/B69ri4rrIIvzYA
         GK7SnYjcC92+vRZM4/cGWmFsONvCNrDXboIEJwRM0IXJBnRlCmRRe+5awKjwZH1HLjOq
         mU/wEWfoX/J80s6z8lmkGKKq3K/hV0NTng0u12rLSa7AAc5+2Qz5LqufdJ67EeUkRnou
         gbCAZaWkU5nifEgTcaYO20+zKPvkqNOTawozStHJoiMZJGVLVUAt5I6jEL1eHCDXOapo
         X21Xi7TDlUClmv6ehIj7jOrbbKWMpjthaetGGOpJ7VWiWE50Av0daZ9fZ3iS8p2AArZr
         EEUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=tNCnMHkiXhsuWSHTnXdlleFksTg2DrkqH2patizaQHU=;
        fh=M3arERVZqSavi2VagcJNiLUu/CVQ/kMwHyh98bZZWYc=;
        b=GPir6bGnRc8X6k3z+aKyG6TcUSCNT79+Ry9Z//1eruwk7dLQgMI+K5BPovkibJfxby
         WKKbZkL4Sb+KEXfBea73zgToVaSwqfIJq2tGOdWtmjTCto8AMJ8I1fR2EMVKIo/T9pOU
         nNi5z2Y8CTNwKh7YGiRI2Z+L3SHD3jYfv01ligpMR0HwWh2Y49qEK1zKpu+9CFOU4yjl
         9bPCS5AgkA0s68PlJzfYHlUfPcwk7ZB3hDPX/8tGwFpj96gi6f11kUHGGeNMGiSZqClr
         Hvmhy3r6bPPnOuMQjWqkUBHs1U9kTSObXqwxAMzE0f7rU++A+jffFpZnHCGRmQespVPM
         MncA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778559616; x=1779164416;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tNCnMHkiXhsuWSHTnXdlleFksTg2DrkqH2patizaQHU=;
        b=jPek4tXe+t3nUzLo2xpFW3BvV8O+82TAsaQjAeeU9+PIt3xr+SdMZ5kx7oSDFXSG7m
         0CCj5nsVuRg16KFjLHTcZpwuRd9hcJ7TeUc4RlCD61++SgOjdoPYzcSGztpWA6i8+ueJ
         cb3Xdv6XcXQcG3ktVF+17cWt2zf/zyBZt0h9g7zmdwIge2D0YhAMXYdYr8N5frXKp3TJ
         pIuwws4MQ58K3UD0Yoi5kVrRaEanm//BoF/gl7IwH4uotOyYYpzdki/vDf/I1AfrWdae
         kpxnAyq6BDv3t9aAV8zAB3LUiL0im10iNGtiCOt5SxoaWQ8qhYkhD1Nvfotxk1oUsyrk
         sNIA==
X-Forwarded-Encrypted: i=1; AFNElJ92GkmjgG/DDRqhqK71STM5vp8B/yk7ir6/DvQMX6pIH3yzd0GC4pW7zvlC/kED7UD3oVkvTEe4Ng==@kvack.org
X-Gm-Message-State: AOJu0Yxw/IH7ho3lGNyCFvKztIXMcC73ZVC26+q3dHYKgwSxstNlWlbF
	oApSjcf6xWCVsZYZxKqkIs0nA+DNsoFW713P4DCQlJ1b8cqSQo2e7Zzz5fAFM7TvL717Q12/TRa
	nhk5Z7B4oWUEUvXj/85izFeJDwakk4hQtguWSPNGNfSP3R8wF83E5CBskD/x2NIGqHfLry7C7GY
	RC/W1yhBYYF/njsP+rGvK3Hr04Vw==
X-Gm-Gg: Acq92OFOlSeQrUkk++9BeUSX9sclGIiWmhN5lkFhTAGbQxYT9PN2ujG0SEIamSrO7ro
	UzsgbdUX7y0MEnZZ/92kwph9tM1pp2scvqQCEEnOjgXYFcSA0AcNoym6IX6q0Klq4qcBxdxtl6Q
	t8hpaJiTbY82/gdXExHbn6SCHVDKFDCej+3MMtlfhfahh3ujCcpyuycLdAX573WFGBM0cBSnjZo
	NHYt05ABFkZhpSqmd4AuOr7wq/M/T5XXH6RUSk=
X-Received: by 2002:a2e:bcce:0:b0:38b:e6c7:2c4d with SMTP id 38308e7fff4ca-39408060bf5mr36952361fa.12.1778559615764;
        Mon, 11 May 2026 21:20:15 -0700 (PDT)
X-Received: by 2002:a2e:bcce:0:b0:38b:e6c7:2c4d with SMTP id
 38308e7fff4ca-39408060bf5mr36952031fa.12.1778559615229; Mon, 11 May 2026
 21:20:15 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
In-Reply-To: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Tue, 12 May 2026 06:20:03 +0200
X-Gm-Features: AVHnY4KWq8FHhUSQWD3q6nbY_RUokvaG-iXEzf5LHdZ92nZyw_XzuPjsyIdRrpQ
Message-ID: <CAEmasaV7ejxqb9-wTT=7xdt+icxj-ZvdSLkSoC6X5i6NMfsKPQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm: support zswap-backed anonymous large folio swapin
To: fujunjie <fujunjie1@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        David Hildenbrand <david@kernel.org>,
        Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chengming Zhou <chengming.zhou@linux.dev>, Baoquan He <bhe@redhat.com>,
        Lorenzo Stoakes <ljs@kernel.org>
Content-Type: multipart/alternative; boundary="00000000000013f55f0651972e3a"
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDAzNyBTYWx0ZWRfXzawlzlMdMby+
 /NoQlwy25+7Iy+CLXOEqHNGLxzAF4i24IaMKg+O/93JwJQAQu8vGrEMl/p5XruwGOHN4IZ0YXuk
 VQdx3nNw3eUjKIAxG2yGuO9vG/mtn7omy20IMlCZlAtNLpP9+/51KOLYE3IXkUy5/Fy1XLEFtCj
 LMQWsyTZ1EaY3uUQ+SoMGtQv+3JimBWtads/A+ixzFTunCZsTDoDj4UhzBebbxBmg22AXEEyP3u
 /Mg7rEfcuIqJJMgez70T0bS9aZW0MYoVIZioT0nRoIz8g+HBdloRphZUaCqmDX35g/lR6smyhVV
 mNKxvy4/9thuognRUqkSiYg+X6OsaTDe+lYHRB/+PXHVBmaGW3FADzcJL3KTDziv5hYU7dNLhRc
 +71b9pPkSTsFkq1F0tPdce05WPoMXc3f09nuhiHioUZZp8mc3+A0Be4b1Sh/GNknW0w92s1NNyK
 ogeOeYqXw0SAm02oLtQ==
X-Authority-Analysis: v=2.4 cv=f4F4wuyM c=1 sm=1 tr=0 ts=6a02aa81 cx=c_pps
 a=7DXwzBV7yB9sQ64fpm0YNw==:117 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=UqCG9HQmAAAA:8 a=dZbOZ2KzAAAA:8 a=vTYp5jYDbz01-3CZViQA:9
 a=QEXdDO2ut3YA:10 a=rN1F6bbcgVQ7gje2excA:9 a=0knPs5ccXtLG-597:21
 a=lqcHg5cX4UMA:10 a=eI3u7fyX2kwyfkukwWva:22
X-Proofpoint-ORIG-GUID: XNw5FrKQc6IeCyPFUYh1gEKvheZUgxK9
X-Proofpoint-GUID: XNw5FrKQc6IeCyPFUYh1gEKvheZUgxK9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Queue-Id: 8AE2340009
X-Rspamd-Server: rspam04
X-Stat-Signature: 16uuw88z9riahc5t89xa7x6sxor9k9p3
X-HE-Tag: 1778559618-297362
X-HE-Meta: U2FsdGVkX1/Iinqk3N2a34TWdCrcF8OIteMmnB0iHIcQcle0Y4qydcQSyS7lS9alAjjJBHgSc3nXmIG1Qs5gd6W9Z1yT1gtHZYdxDM6nKvn0wPXh4eYz8py+8DyBeeqhlSmndVtcsfhMUUSX5KdtZIiSPrZg50koXWKClfOkzLhZW6+2TLH4DSoxBV6p4FL/7+KjYg2bOo/TjuNqFV/sG8tbWw2VychYTEORRRSIaasVXSeFwFObpyqU51rUgcKmhPrh4WCE8OlgqgDkqk1uGNKbHWhm4BAQXNFxXCt8GB3aw8jEA9FxtImbevxY2hEI3P0R2MTbl83yvVB7p1uR50rU0Eaw3xAV5vrpOFk1PiAE9Tq+js5GAr5yiMh57KpDJC76ateURCtwThFDTH2Xxy969Y2PM1FO/QyZzgUHkvLl0cB52RksoUzvI4xVPXe2Z8CAWF4AvP5mMgZgwDvUBhXayND7IE7tee76LjJ/xqZ6w3UsyDBPBA70k1IUW3ns/u2BRTBBZXt2vN6DqeuLiFju7TeR8NIDv99tGIYl7uH+ijw+0WmIKheHKJ1nH4TpqXvFYiGF1544jaiUbhh9BnPTEQe5vs7BJHT6r2ISyCUtFqSvE8H2sOZQHiqmTpNHUPzOloIcbhoIFquzmG+5u6fjJLWQbT+FBvB6pD99F/qtW2GHQcSCpmBIF78UBrDa2DE9W7WpT3KJy1ru+MEKnDWm/Dygs/WDk4YN/fVh2/gPdatOBXui59DqT9mEj06V5UYsRYWxYYtK7gWXdM/SMPrMZFWDMk8ZAGtNxp0XLoBP4ZOMzXFU1ddVlnP3xDp+kBrgIsKXnwr7ufgAMJ6lLUCK0R+HjW0Yx6CFx+NaQagyhCuM+7B1cW4AOuVeUGcIK8WJxwzUXzdBtfai4PNWROPGFvE31ZsjIqNAEXoknqT3FPQNhGjW2lu+HgTN/iQLbwOAeA0GaIZ/1JE3xR4
 ZKmIbLLL
 REi8XkoSSG4NDjmEl9H5k4kdDYn8x1QCxr/Jwxsit7mh8hcVQcIGjR1Z8X3HcEyM6B78MA1V10Nz5358U5F6sjbWq7WrB/7PWf9eB1O/wWVgpEfwMWpJ82z8LEAxs9uH/dRBzWbS9STMQgKTHF4qSgJF6XkWc7PRYtERF3Rr6lA+v+jKruRoEzmyUC03cnfS27XhhCWwPvKDPY6uH/k9HwuURIz2q4HmIlNH10Z//G03g5ZLFi1bg2ijURP/dq/75PPzGzaF/tZktQwLayeVvaWbZdS9zzAm1iX8bu7oe9NP/iPupiezHy/KG+7VWDnYGgYFkIXEeOrkqBd7oqtSnGMWOLll9slJWh9kawEToLkSCo/QGXQ0cTHRNr2lGSKH/aSHMLX+YdasivKU34CqpQlMs+IL0/53YTbKR24OBJMsQ2d7bvPrZH7MLXmUw+nKZUWZOwlrAkcyPdrsfApaPbEmPevnTJ+0Vn+tlhBP9n7Wip5d6DTbqdiqoVZ8UFv1w9Oc4g3jhJek0DHeLRArbGWO4n8gZZ7m8OBhuDZdYzwZ80pv8pG11wCIl+E6pb92Gy1fAufrtwhieRS2RH3puOphIyBcLFeTwdyOTyAvRIiWHxuJ14eGDdFUMLwlTVl4m4BQqGi8LvXAHTR5CeveElmLXfNv7gjn46vuV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000013f55f0651972e3a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, May 8, 2026 at 10:18=E2=80=AFPM fujunjie <fujunjie1@qq.com> wrote:

> >
> Hi,
>
> This RFC explores anonymous large folio swapin when a contiguous swap
> range is backed consistently by zswap.
>
> Large folio swapout to zswap is already supported by storing each base
> page in the folio as a separate zswap entry. The anonymous synchronous
> swapin path has remained order-0 once zswap has ever been enabled:
> zswap_load() rejected large folios, and alloc_swap_folio() avoided large
> folio allocation to protect against mixed backend ranges.
>
> This RFC keeps the scope intentionally conservative. It does not try to
> read one large folio from mixed zswap and disk backends, and it does not
> change shmem swapin. Shmem still has its existing zswap fallback and is
> left for later discussion. For anonymous swapin, the backend rule is made
> explicit:
>
> - a range fully absent from zswap can keep using the disk backend
> - a range fully present in zswap can be decompressed into a large folio
> - a mixed zswap/non-zswap range falls back to order-0 swapin
>
> The series adds a zswap range query helper, teaches zswap_load() to
> decompress all-zswap large folios one base page at a time, accounts mTHP
> swpin for zswap-loaded large folios, retries synchronous large-folio
> insertion races with order-0 swapin, and removes the anonymous
> zswap-never-enabled restriction once mixed ranges are filtered.
>
> I tested the series with a full bzImage build using CONFIG_ZSWAP=3Dy,
> CONFIG_ZRAM=3Dy, CONFIG_MEMCG=3Dy and CONFIG_THP_SWAP=3Dy.
>
> The QEMU/KVM runs covered both the fully-zswap path and the mixed-backend
> fallback path. In the all-zswap run, a 512MiB anonymous mapping was fault=
ed
> as 8192 64KiB groups, reclaimed into zswap, and faulted back. Reclaim
> reported mthp64_zswpout=3D8192 and zswpout=3D131072. Refault then reported
> mthp64_swpin=3D8192 and zswpin=3D131072, and pagemap/kpageflags showed 81=
92
> order-4 THP groups in the mapping.
>
> In the mixed-backend run, the workload used a 64MiB anonymous mapping
> split into 1024 64KiB groups. After shrinker debugfs wrote back exactly
> one zswap base-page entry, refault left 1023 order-4 THP groups and one
> order-0 mixed group. The kernel stats matched that shape:
> mthp64_swpin=3D1023, zswpin=3D16383 and zswpwb=3D1.
>
> CONFIG_SHRINKER_DEBUG is only a test aid for making that one zswap
> writeback deterministic; it is not required by the implementation.
>
> Nhat Pham's active Virtual Swap Space series is adjacent work. It moves
> swap cache and zswap entry state into a virtual swap descriptor, and lists
> mixed backing THP swapin as a future use case. This RFC is independent and
> works with the current swap/zswap infrastructure, but may need rebasing if
> VSS lands first.
>
> Feedback would be especially helpful on:
>
> 1. whether it makes sense to support all-zswap large folio swapin first,
>    while keeping mixed zswap/disk ranges on the order-0 fallback path
> 2. whether a follow-up for mixed zswap/disk large folio swapin would be
>    useful after this RFC
>
> Thanks.
>
> ---
>
> fujunjie (5):
>   mm: zswap: decompress into a folio subpage
>   mm: zswap: add a zswap entry batch helper
>   mm: zswap: load fully stored large folios
>   mm: swap: fall back to order-0 after large swapin races
>   mm: swap: allow zswap-backed large folio swapin
>
>  Documentation/admin-guide/mm/transhuge.rst |   4 +-
>  include/linux/zswap.h                      |   9 ++
>  mm/memory.c                                |  67 ++++++++-----
>  mm/swap_state.c                            |  23 +++--
>  mm/zswap.c                                 | 111 ++++++++++++++++-----
>  5 files changed, 154 insertions(+), 60 deletions(-)
>
>
> base-commit: 917719c412c48687d4a176965d1fa35320ec457c
> --
> 2.34.1
>
>
>
So I have been working on the exact same thing for some weeks now. My work
is based on Usama's series [1].

The problem with large folio swapin is that it can create swap thrashing:
to swap in a large folio, swap out may be necessary, as reported in [2].

I implemented quite a few throttling algorithms on top to try to avoid this
issue and so far, I have had mixed/inconsistent results.

How did you test this series? Did you encounter thrashing? Do you have
performance numbers?

Happy to talk more about this, thanks for your series!

Alex

[1]
https://lore.kernel.org/all/20241018105026.2521366-1-usamaarif642@gmail.com/
[2]
https://lore.kernel.org/all/SJ0PR11MB5678A864244B09FDE4D914EEC9402@SJ0PR11M=
B5678.namprd11.prod.outlook.com/

--00000000000013f55f0651972e3a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr">Hi,</div><br><div class=
=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, May 8, 2026 =
at 10:18=E2=80=AFPM fujunjie &lt;<a href=3D"mailto:fujunjie1@qq.com" target=
=3D"_blank">fujunjie1@qq.com</a>&gt; wrote:<br></div><blockquote class=3D"g=
mail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204=
,204,204);padding-left:1ex"><br>
<br>
Hi,<br>
<br>
This RFC explores anonymous large folio swapin when a contiguous swap<br>
range is backed consistently by zswap.<br>
<br>
Large folio swapout to zswap is already supported by storing each base<br>
page in the folio as a separate zswap entry. The anonymous synchronous<br>
swapin path has remained order-0 once zswap has ever been enabled:<br>
zswap_load() rejected large folios, and alloc_swap_folio() avoided large<br>
folio allocation to protect against mixed backend ranges.<br>
<br>
This RFC keeps the scope intentionally conservative. It does not try to<br>
read one large folio from mixed zswap and disk backends, and it does not<br>
change shmem swapin. Shmem still has its existing zswap fallback and is<br>
left for later discussion. For anonymous swapin, the backend rule is made<b=
r>
explicit:<br>
<br>
- a range fully absent from zswap can keep using the disk backend<br>
- a range fully present in zswap can be decompressed into a large folio<br>
- a mixed zswap/non-zswap range falls back to order-0 swapin<br>
<br>
The series adds a zswap range query helper, teaches zswap_load() to<br>
decompress all-zswap large folios one base page at a time, accounts mTHP<br>
swpin for zswap-loaded large folios, retries synchronous large-folio<br>
insertion races with order-0 swapin, and removes the anonymous<br>
zswap-never-enabled restriction once mixed ranges are filtered.<br>
<br>
I tested the series with a full bzImage build using CONFIG_ZSWAP=3Dy,<br>
CONFIG_ZRAM=3Dy, CONFIG_MEMCG=3Dy and CONFIG_THP_SWAP=3Dy.<br>
<br>
The QEMU/KVM runs covered both the fully-zswap path and the mixed-backend<b=
r>
fallback path. In the all-zswap run, a 512MiB anonymous mapping was faulted=
<br>
as 8192 64KiB groups, reclaimed into zswap, and faulted back. Reclaim<br>
reported mthp64_zswpout=3D8192 and zswpout=3D131072. Refault then reported<=
br>
mthp64_swpin=3D8192 and zswpin=3D131072, and pagemap/kpageflags showed 8192=
<br>
order-4 THP groups in the mapping.<br>
<br>
In the mixed-backend run, the workload used a 64MiB anonymous mapping<br>
split into 1024 64KiB groups. After shrinker debugfs wrote back exactly<br>
one zswap base-page entry, refault left 1023 order-4 THP groups and one<br>
order-0 mixed group. The kernel stats matched that shape:<br>
mthp64_swpin=3D1023, zswpin=3D16383 and zswpwb=3D1.<br>
<br>
CONFIG_SHRINKER_DEBUG is only a test aid for making that one zswap<br>
writeback deterministic; it is not required by the implementation.<br>
<br>
Nhat Pham&#39;s active Virtual Swap Space series is adjacent work. It moves=
<br>
swap cache and zswap entry state into a virtual swap descriptor, and lists<=
br>
mixed backing THP swapin as a future use case. This RFC is independent and<=
br>
works with the current swap/zswap infrastructure, but may need rebasing if<=
br>
VSS lands first.<br>
<br>
Feedback would be especially helpful on:<br>
<br>
1. whether it makes sense to support all-zswap large folio swapin first,<br>
=C2=A0 =C2=A0while keeping mixed zswap/disk ranges on the order-0 fallback =
path<br>
2. whether a follow-up for mixed zswap/disk large folio swapin would be<br>
=C2=A0 =C2=A0useful after this RFC<br>
<br>
Thanks.<br>
<br>
---<br>
<br>
fujunjie (5):<br>
=C2=A0 mm: zswap: decompress into a folio subpage<br>
=C2=A0 mm: zswap: add a zswap entry batch helper<br>
=C2=A0 mm: zswap: load fully stored large folios<br>
=C2=A0 mm: swap: fall back to order-0 after large swapin races<br>
=C2=A0 mm: swap: allow zswap-backed large folio swapin<br>
<br>
=C2=A0Documentation/admin-guide/mm/transhuge.rst |=C2=A0 =C2=A04 +-<br>
=C2=A0include/linux/zswap.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A09 ++<br>
=C2=A0mm/memory.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 67 ++++++++=
-----<br>
=C2=A0mm/swap_state.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 23 +++--<br>
=C2=A0mm/zswap.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 111 ++++++++++=
++++++-----<br>
=C2=A05 files changed, 154 insertions(+), 60 deletions(-)<br>
<br>
<br>
base-commit: 917719c412c48687d4a176965d1fa35320ec457c<br>
-- <br>
2.34.1<br>
<br>
<br></blockquote><div><br></div><div>So I have been working on the exact sa=
me thing for some weeks now. My work is based on Usama&#39;s series [1].</d=
iv><div><br></div><div>The problem with large folio swapin is that it can c=
reate swap thrashing: to swap in a large folio, swap out may be necessary, =
as reported in [2].</div><div><br></div><div>I implemented quite a few thro=
ttling algorithms on top to try to avoid this issue and so far, I have had =
mixed/inconsistent results.=C2=A0</div><div><br></div><div>How did you test=
 this series? Did you encounter thrashing? Do you have performance numbers?=
</div><div><br></div><div>Happy to talk more about this, thanks for your se=
ries!</div><div><br></div><div>Alex</div><div><br></div><div>[1]=C2=A0<a hr=
ef=3D"https://lore.kernel.org/all/20241018105026.2521366-1-usamaarif642@gma=
il.com/">https://lore.kernel.org/all/20241018105026.2521366-1-usamaarif642@=
gmail.com/</a></div><div>[2]=C2=A0<a href=3D"https://lore.kernel.org/all/SJ=
0PR11MB5678A864244B09FDE4D914EEC9402@SJ0PR11MB5678.namprd11.prod.outlook.co=
m/">https://lore.kernel.org/all/SJ0PR11MB5678A864244B09FDE4D914EEC9402@SJ0P=
R11MB5678.namprd11.prod.outlook.com/</a></div></div></div>
</div>

--00000000000013f55f0651972e3a--

