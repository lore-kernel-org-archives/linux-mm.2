Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C1FCCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 12:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F380A8E0069; Mon,  3 Nov 2025 07:26:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0FBB8E002A; Mon,  3 Nov 2025 07:26:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25F88E0069; Mon,  3 Nov 2025 07:26:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D17AB8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:26:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 372EC129639
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:26:11 +0000 (UTC)
X-FDA: 84069218142.11.48A7A63
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id A71E0100003
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:26:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BHLvQob/";
	spf=pass (imf14.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762172769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g11uOENAhXF6Lz2FLzv66IHWNpx+JPxP5XeReK+9A1c=;
	b=W19eCL9vQ73wjS8Mb4gU/mVZRgxlYToMJiXrY7ev5otyPi3KAK4kK+IRkZ+cMvbvzTQ30U
	azBKxHiJXYMxNTH1st/WYpgkzgq8mtEqhRdxpNiFfDD/cHK8PYPnNLXYWoa1zkfEEYpI12
	k5wFTdXRDeHmA2C1Uv5dceh0z1VgUBs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BHLvQob/";
	spf=pass (imf14.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762172769; a=rsa-sha256;
	cv=none;
	b=0Dduq5RS//m6dow2PQILUOhSz+78HIg+E2S8SyF18LstKx2kD4k78Fi1Yr9gKnIzr1X9cx
	NQDcEtmLNdbhHmwLj6Q/QqUmaeaqk1qw9YY34e5ou4fM3lc/SwJ4rsKvui2JGDo8mUBTGu
	Uarl3MVEi0vTxhS9eFxphcn+rGUmBbE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762172768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g11uOENAhXF6Lz2FLzv66IHWNpx+JPxP5XeReK+9A1c=;
	b=BHLvQob/Dz1xkxOMytKMAUV6aGT1X1fS8sERy9GIvGdx5wjWgrpft/7tdZCPJgEzU3VZ+U
	y+qAobVp0waatrIOkALPQMED9Y0GWdCjRCEIcwaw3td+5c657QVJotvXo85AmPzVQJvK0g
	u4tcGT9vYnFMiGZc7mwD2JSbzAS1e3Q=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-vftbomCFNRGeqHXBllxTUg-1; Mon, 03 Nov 2025 07:26:04 -0500
X-MC-Unique: vftbomCFNRGeqHXBllxTUg-1
X-Mimecast-MFC-AGG-ID: vftbomCFNRGeqHXBllxTUg_1762172764
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b5a8827e692so316880466b.2
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 04:26:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762172764; x=1762777564;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g11uOENAhXF6Lz2FLzv66IHWNpx+JPxP5XeReK+9A1c=;
        b=m5kr0abFtHNyORAmi+/874hzZnuEKwIxyzbgEBbSYpBDqTOibUv0btZp5S9ZHwmVaG
         yLx6YpGr7sFSUbwXe422a9gjvG2smHYZ+88acbRp2Ri2V/BaP0L0R3ZsM3tNOP+84kn4
         d9Vs01NHYKOPkxkcg0JEvpYhK6bXZgMC3RLg4yKuqZh7btOH39quaSR23RpyGiWOF+b+
         q9yhodfuzOcrTNyr7gVUVdj2lmcY1rpefBv8x039YDziYZA4koSUP9YprngJekMUSPsu
         WWEa/h/WqYed+u5qoyIWFBrseBfYVfS1G/QO4g4K6CJkzlcbkZNfkDpXAQ+hxUvP58AK
         L10w==
X-Forwarded-Encrypted: i=1; AJvYcCXci3lMPu/cxfOrgIXz9xz2C/MHzY/UCX32mFXS6Jg06aYcvzO6aVFvqCXO4B4sc6NYi/ZqjaKUzw==@kvack.org
X-Gm-Message-State: AOJu0Yw8nZ3A0F3yEckFivdNuZ6c6A2uofJg2lZ8GUTPKRpr3uP5Trvl
	VdkMsv+A68BSiF+KLKbOgNDn87kgjEezBapE3X3ivqLKeO7z/iv8+K/Er77jZbMWQLgyBpEOHzS
	HhxD1xas1lm++WYiAMYyx659mU4Cnu2gKoCWtqCB2yCVUk1RVvZzL
X-Gm-Gg: ASbGncs6XJkLtvB7bmjD73uS93rjo9SS3/mA5BR/xXgmJBH2p+cWu8MCT6nELMS6c8C
	rIjkSCLf+wiapTLCdf7YeGIrGhZ5jw4ZpL05ZFG6JCF3YH3rjRYVqV1n+jKiTq7d6J/E7t7Xd4i
	FQtPkgVAmoK/qyUvIiXdtfzkEwN0nrAqW3aDU1cwHuxF60P1C7RR8nNgcbMuMhvnDK6O1GP5rkP
	ivffWQRTE2qAr/Kkrj5uyQ2SME+vQ1RLLyb6epD/RZhDM2VqPMe/HggD5VWDhxK4+3k+sc1c/3T
	iO77siH0ISHpq1V89YwkBd9Aw6Q8W00TR4vyveMtToGf1H1HAYOFyTW1pMSInE8G1aTmW8nQedd
	QsyW3mSMpK66NTg/XboInYe4=
X-Received: by 2002:a17:907:2d90:b0:b54:25dc:a644 with SMTP id a640c23a62f3a-b707088d70cmr1143618266b.60.1762172763664;
        Mon, 03 Nov 2025 04:26:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGGDSUZroE2R0agAHuAggyj7GFeJpoD3zlqyuRNs//UwQQu1Iz9F3y2cjiJMrJtGK3MF6tN8A==
X-Received: by 2002:a17:907:2d90:b0:b54:25dc:a644 with SMTP id a640c23a62f3a-b707088d70cmr1143613966b.60.1762172763188;
        Mon, 03 Nov 2025 04:26:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7077975d24sm1032752266b.1.2025.11.03.04.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 04:26:02 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id DCD6D328450; Mon, 03 Nov 2025 13:26:01 +0100 (CET)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 willy@infradead.org, brauner@kernel.org, kas@kernel.org,
 yuzhao@google.com, usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, asml.silence@gmail.com, bpf@vger.kernel.org,
 linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk,
 ap420073@gmail.com, dtatulea@nvidia.com
Subject: Re: [RFC mm v5 2/2] mm: introduce a new page type for page pool in
 page type
In-Reply-To: <20251103075108.26437-3-byungchul@sk.com>
References: <20251103075108.26437-1-byungchul@sk.com>
 <20251103075108.26437-3-byungchul@sk.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Mon, 03 Nov 2025 13:26:01 +0100
Message-ID: <87jz07pajq.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eEcleGB6Zo45udaJuF5H45vhwZW98JjOhEhf5XAhvx8_1762172764
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: oj7norhd3d8zyamcwsizywn1sj99qnne
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A71E0100003
X-HE-Tag: 1762172768-76049
X-HE-Meta: U2FsdGVkX1+o0uarIwIEYEYLsNlmuf5ca8xZNrDiqMk1AaHkk3u5fyZqsZi2QYi1i+g1D/1nYYHMK6K1xHRvjOpfZ3oT2j4F94kcGGMFI33B0mcqAsqkpJ5OxlCNOd4u+BPYFBPgfkHnwZ8YB8XK1PnJ6NzqUlmuDc+JvwOF0OCIeqh0iZPWUXsZAMD6jWVDYFKJngtqZW6Ldh+oAkjBlfkhG+JuymyuzkomvnSa0FfdNCToHe5tSt/5tAmPo/m3ECDuti6K1UJpBItCkvOjc4Bw9jEjhir3xr2GiI7BCEfyyG45s1JZ5DQGoWlUgYxTFtSJr+eB/PqFfh8Nj1PwySbiQqVshJWC5/psk/CuptSzbuU4FmTzEBaJpPVt0CkvqP9PxgQt3NgnMotaeg/Ovhk7Me791JmWU8OxnKSqLrPrDvqEyK1qaV+TvVwZjkHXt7p7Pn0UqWFuizxCXMdL21poB4300cCD3/CyAA6LWXtek1w8Dk+X1+tBUQuv+TjOl3VPkrqb4Ll3w8eWO35U7O1tAcFv9yRDnGdDWE8fcIc9ijA01aF37tF6oymgvCgRBed4PHX6yDxhnYhS8zsjAmW6VsUUVtUpq2sADs49jPlH23MRdLMtS1SYuYZ841XqtMbfZ4CKbAs9AJECtm8JXUOGmUEXXJOVfOxrT6MAorPRUE6Va9wHNWPsBSij4THzN/iLoLT8MOCMdiWW1XtyhhGBgGw460zQTWLQ6V7jvifCLH2MTyNkZYqjii7HKwL+hIzJ0tQ6840pgvkvNIjiGid0nWOPnbBHJboplXguRaCyAzPKPptgnCYSyKYqk0w6m4JBBBdSZ/eMnAN6YF5YOZNF9NCjASo85RHLnOx0nVlo9OnVoDbjptPx212j9mE+Ch/yZ/9GsGysCC/pQVATz3KrfV+jYD+FG3Ed9YYMfU68qd6ACXnuUl+8h7/iZjsHVgw1wLliTB549l6eQaD
 1Erh4Nvd
 yo1UmGAKShRCPej5/kg1S2GRnH28bJO097pYrdouXJ5TKQZRTV5vZ5xvXU8noRcPPHRZVvJ3Os1WTRDlr5Kg0qBh6kSMw7gOwkN01OJnogTyyp93gktobPOh9WpNhBgONd/bq99DGAKL3qUmSRYHBUVDJaRCXM6Ebmau1TO89/olHVUbcZY7T7Igv/A6x5fYO+1fEnhr8P0GIudf3l2pPenFodXftOcj/vy9kxqB80Hi+2v2V/1NtT5YS0syQw9heSuZZy/++z0Ta2u2L9yNhJiDHpwU5GzfPEB4FHXnHCtfhhtlwZTDZ2T0ynlPpHqphrw5a2w12tsGjVKR+FEDQTFZtZ4ZCV3BHIl8TPCRiH+LMFqtLCm08Cf6Vl8ZbSUNxwIZyDCovryYUkBFmoNkkvdszXtssqlBvdq8H9R8QEKYoPgjNNzT1XiiM4neXW8XJbsKpv9u/mQb333mthUEsNyGdQ3i6+/vECttR1V7e52OkCxdOXL5LR7+jB2H549g9wmkjxHUQv7tuC5mluPuzpF1KGQ2vvArg9Va2Z5et9YFtcmrAOP0Rd3j+Icqq2ObQ6tHaRXtAq+p+95+VnSViOWUtKIr1yWQbBhSCqqH/pRK+ZZE8iF2diA73B5NNK7xXAeA6OEe1IXiQIXdAytrBI1xL2NJDAtZRuhMaZvUHea1nE9HYYH0C5g3egV6Qc9k7gdjV6Sj/Yn5VzGh+WfXmGY4WMwVflLDXMJ7KbpHN+DZozHI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Byungchul Park <byungchul@sk.com> writes:

> Currently, the condition 'page->pp_magic =3D=3D PP_SIGNATURE' is used to
> determine if a page belongs to a page pool.  However, with the planned
> removal of ->pp_magic, we should instead leverage the page_type in
> struct page, such as PGTY_netpp, for this purpose.
>
> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> ->pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> netmem_clear_pp_magic().
>
> This work was inspired by the following link:
>
> [1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmai=
l.com/
>
> While at it, move the sanity check for page pool to on free.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Mina Almasry <almasrymina@google.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

IIUC, this will allow us to move the PP-specific fields out of struct
page entirely at some point, right? What are the steps needed to get to
that point after this?

-Toke


