Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94BF4CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 21:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5FE6B0032; Thu, 27 Nov 2025 16:52:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7DBF6B0062; Thu, 27 Nov 2025 16:52:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA426B0088; Thu, 27 Nov 2025 16:52:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB1546B0032
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:52:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F8CE1602E8
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:52:55 +0000 (UTC)
X-FDA: 84157737510.12.1686879
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id 874CB1C0007
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:52:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WEArgUL4;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764280373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jttLJ8TWGePu+ngSo1n4o5hp2pzXFGAv2t0XowsTZMg=;
	b=sDkYomXlbJds3VBjQOSRAbhldFWAX8VUhUoIbeci6Rk0ehBai3QSb3OR743H/+2dtNa4di
	bAMlbLu/J5cUZmnln4ItY/ri0qOWjpCkRSjJLko/lLlkQWyhcOPVqQYRhzGur9DMfhJ1iE
	M3GJkQVcSo5F1PGe2L+Za9S6YX9tHkU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WEArgUL4;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764280373; a=rsa-sha256;
	cv=none;
	b=qUdYUdXaitmO4BM6MFfKUQ3bfaIQyJJr/2TUS7VdgvOm476xcN7yv1L2Kr4OgdjF58TDm5
	Ej1CzuBs/QBV41+MQGqWB4TD1IkL8o7Z9Da5w6EEjrPY7vqUQ3W76tDFcoN7LhDKiGOOFx
	5Kbfj8a/PJoL2erHSCuW1ioR/I/qdtM=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8845498be17so14939396d6.3
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 13:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764280372; x=1764885172; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jttLJ8TWGePu+ngSo1n4o5hp2pzXFGAv2t0XowsTZMg=;
        b=WEArgUL44fAmLat/XKRWaFNXKQA/piqZoolTFtb13CfTx74gqxxA7IXMFo1u62fPQ0
         WOoYg7Gz4vYk2tO93EJzWdip043u1pi4PtuOJy7/T+E5G6M9r3rB5utRixpn2hrPMUOQ
         OvSMpDeJdjmZk/Zcc0Pt9KAmniCGlCT3Cm+7v9eS5DCcK5725qG7Glyt4KSk4dPgNc69
         iZwe8oOZhPtqT8YqMVHW20tTbQVBqXw1IXuq/926gTWQKok2tYxgd63ADj5CWUbweY9N
         L+IchKRcRtfLra2y5J3Hac/5Anu6z+t6UT1viaS0c7vM1EYJxZ4E5VNq63IAm1KCotQo
         5bZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764280372; x=1764885172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jttLJ8TWGePu+ngSo1n4o5hp2pzXFGAv2t0XowsTZMg=;
        b=HWI5z1G2QrttyN3e7hFZCwuCurKb6TSw923AMCvEVSRx5KLlQVKy81SYrfbG3YoY/X
         hw02UOXraQTukkLvI0Jhf87aDeMITR8oM2vkZndXLTWMJbQcuwROK/CnWo38oFb+ndC2
         QHdYZ4Er3rcLFTcVH6UTnmVwLKq4TrGdqozUz234P8MoCvtPgZH07unsFLotYsvi7sRC
         FcRHChBOMus91HATWTiRD3bs7aTyrdIkPx30UesEzfzgSZyN1rD5+jtMHDH/9jT2QP68
         Zd/s31DP0PZujI2DR2R1My1qXNgOU9TiQPNk+v+OAyuB0m3aU0CCAgNICSfsbjaSclcH
         nUmw==
X-Forwarded-Encrypted: i=1; AJvYcCUoBbRJlPLWrdKgqLWlEZWag9yYB0W18ySnng+lVPS8uEmcGybgrmNzAsy9lQR1vf6T4/0Ccalhdw==@kvack.org
X-Gm-Message-State: AOJu0YwqZGPD0J4OURyjxruN4pP1NLRKD1V04qpZ5phryJtKdVofQjt3
	IeyiJEuS8SzCO/To+0F2t7tAg7RYb9E73erP5VyUHrhqazIrU84mdiQxNErePdFzVFEut9n+Q07
	rd5/V3dRcQUaZmF+473bac4xc4f6qpBk=
X-Gm-Gg: ASbGncujDxWRaoFmWY1sZmpW59RJmaHgA7SqixbT9kbWgha695Kv3GtCNaFy30D0TT3
	sOORjor9kRxNTq0pRQotsTJ0QW7RbR4OyJucgXpaOnqDB+P2vBMYu1+hxQqjkDBo4O5HoKvC7Xk
	DJr0pi11qSiq9/mu8QU6GpB5Skl45N7eSPNvsNkJJDzFGDGNy1wTI2L2f3BQXJKUTXNEPFlbodh
	TKMhQzMGy67ecVfHoIcNLsKb+MDmU1rwvSRl73h/K6yybnJgUsLlNbB60IC1yNVdUGJrQ==
X-Google-Smtp-Source: AGHT+IGi53ssJfVFEVeCKpbOH4PM/Uba/gyP2VL/mpIj2xLrn6No0jDJl3wOawm61ht0VMTz1HcUV32B95MPtil1ISg=
X-Received: by 2002:a05:6214:19c9:b0:880:49bd:e217 with SMTP id
 6a1803df08f44-8847c486a0bmr364162506d6.10.1764280372486; Thu, 27 Nov 2025
 13:52:52 -0800 (PST)
MIME-Version: 1.0
References: <20251127011438.6918-1-21cnbao@gmail.com> <aSfO7fA-04SBtTug@casper.infradead.org>
 <CAGsJ_4zyZeLtxVe56OSYQx0OcjETw2ru1FjZjBOnTszMe_MW2g@mail.gmail.com>
 <aSip2mWX13sqPW_l@casper.infradead.org> <CAGsJ_4zWGYiu1wv=D7bV5zd0h8TEHTCARhyu_9_gL36PiNvbHQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zWGYiu1wv=D7bV5zd0h8TEHTCARhyu_9_gL36PiNvbHQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 28 Nov 2025 05:52:40 +0800
X-Gm-Features: AWmQ_blYpw-GPSWAvHSSwIXD1PKL1aIx4iCUo78DT2gXpdF1CZ018OhwLE5_XJY
Message-ID: <CAGsJ_4wvaieWtTrK+koM3SFu9rDExkVHX5eUwYiEotVqP-ndEQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: continue using per-VMA lock when retrying
 page faults after I/O
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 874CB1C0007
X-Rspamd-Server: rspam02
X-Stat-Signature: 8wfzs4ktjteck5z3gjqooseayrwucqmt
X-Rspam-User: 
X-HE-Tag: 1764280373-962048
X-HE-Meta: U2FsdGVkX18t8WKREWhRON2C8vTOi/HBOCHa/hf0t8U3sTQsLRNK7fJIAohDbYXgmeW0FHWl9WBE9X0w8WkFMR4JrFUFE3VpMbxgqtgMC2F2RSqkB4m7nMena1lGsUVs3pquUp7aeKGQF5gIe5Hmr+kYkcQ8y184tdnEnd4I91eEJ/AsAIqlwNkNw2TOwkJNlkw+qtGoEP+mRDLSVeNP3DWFk6gvsrU1PSbVo3xqWdm1xQG7CPrdOlvkcR1Iv4dPii1F8ohUdHAEb/VaYVlR32tI0518WmLq7/D9XJzD0kH3ySMCEJd8DsYTewYSbz+6IzRoXOQbUc5jWJAoU2tcTBZPN4Oo0LTVHZ7XRurxs0UPeK9NFwVxfoeyvnHVQUJUsr7L3CfU41Btq+N3T+erX7ww/BlJiefecXmVhkPDLIpNR+0uMscpx0WXQpoEKjiG48odexzf27d9v0BWFvVGFT0ELPw5Fv71RJdu9lKoDoydhw0ocYAwv5VI82aU/BK08rVkqG9IekWFoD413IlnyE0PjAgX4sX3ukMki+l0rtlOGZxdqahljXDN9FMLGqMqAVDi/zmsDAcM9LSaqrorMed4BB25G7TgB0/ftFvFfvRKQ5tg15cwzIM4xdAI3OAnXIVps2KBdtEn0MpP2zU7i0OG53yO+mbbIG01lKvzQhZKU1TSVBzRzwfuKS89aJbin8dhnKg3I/QoS3w32Kdu+IA4R9gnV/lsDsd7Xx5Psu39Nj+kgMe2/rC6jeiI4tUCQcRtjj2NAkAKxUFz81Y0uqMyn8HFw95ZpDtP0ymgMgz+vCCUubpSKEUpHdCVtCJKrXw04lzDg32JdRfCUPv7a07woHLMtbA+uDS9S85pZYpUPaAMdfos5CddBjRdKlwWBQNHtIEzKuvl16BQ9zYsLDocNAg7+rLEKbRDdF+4TpFiPDXCbS1bZOdJfOjMg6JsM6YUsJ6xSD9t3uNDQdz
 xFY44uHJ
 YHzHBG01X47n3/HYDM7TtB5z8qW98UUC6/4Pa4PSNfBIE7Z0tQL8zSXW0Lb9RzT05VlMrIuS1yPTSbd76sbIIx81LXObq2F+2rqH+NLHzEyQprQyuMGx7oOP6JLNhgpVkKT/EMpxVnhuProVtk/7htYFzffUOoZKZB6zlq+8Re2Hkv4pc1e8s/tVmC9pWcSGSodoCwihCTpw16SaxomutDmuDFzZfWwUZ4bhCyZWrBklH+GWHvX4zcHWa9kHqDG7JIe8GXvSuHLpXsq1FyWmw5tzKCIY6pFs/XGDdYBNZMseEh3unemmP+qlI1Nb8BEq4KB20hYH3rf/gyGAJaP4G6XErEvVQHZ6lko9SuY9RSHLUc0rcGlmuM6ejuuyv2zSBfH8G3h1lztWF34f5uBeCMaL8aBQ94dTp50GHUB/8CFE2qPJvS/iFlpz7kg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 4:29=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Fri, Nov 28, 2025 at 3:43=E2=80=AFAM Matthew Wilcox <willy@infradead.o=
rg> wrote:
> >
> > [dropping individuals, leaving only mailing lists.  please don't send
> > this kind of thing to so many people in future]

Apologies, I missed this one.

The output comes from ./scripts/get_maintainer.pl. If you think the group i=
s
too large, I guess we should at least include Suren, Lorenzo, David, and
a few others in the discussion?

[...]

>
> >
> > This use case also manages to get utterly hung-up trying to do reclaim
> > today with the mmap_lock held.  SO it manifests somewhat similarly to
> > your problem (everybody ends up blocked on mmap_lock) but it has a
> > rather different root cause.

If I understand the use case correctly, I believe retrying with the per-VMA
lock would also be very helpful. Previously, we always retried using
mmap_lock, which can be difficult to acquire under heavy contention, leadin=
g
to long latency while the pages might be reclaimed. With the per-VMA lock, =
it
is much easier to hold and proceed with the work.

Thanks
Barry

