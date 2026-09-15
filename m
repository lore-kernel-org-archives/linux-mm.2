Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EDDAC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5608B6B0092; Tue, 15 Sep 2026 19:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5119C6B0095; Tue, 15 Sep 2026 19:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427A76B0096; Tue, 15 Sep 2026 19:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 197F96B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:53:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 970871C2528
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:53:45 +0000 (UTC)
X-FDA: 85217651610.17.CF82E1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 109A7140003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:53:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PplxQb5n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789516424;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OPWCzUYSAJXN4K++8vT6w9N1hwOvTESTMHXbrKefK4c=;
	b=s0UHnF6dvYwwck3u48oieEx82ZLZKwX6W8lyqd/uHy77XzTdtTRFcXzkKFkZWH/x0vqzrN
	QT6zqLgUZ+JHMSRQdEEH4rUMBuRSqpSLNEUiEm5JR6dFWGcrJIw19BLrQcdRGUeKHwc1Yg
	5xZKZIoImJPTE/E5C8BJkyzRfiN76eA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789516424;
	b=XVyPPzdy9p70E4H7f+Pf3gphDTPnh29bwmm1ncpILX30yhMlPLfOBFXqwjsjC/v6TtiE62
	lEovmEKDTSFQUn7jmmUdAvzZdecrU4roxzStRlX8uRdrrt2DeH+DwOl1EBuS03SDFR+hyi
	uAFVuMr77bvexks0vKoWhTIc8vR7u3c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PplxQb5n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 34E38404F9;
	Tue, 15 Sep 2026 23:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507961F00893;
	Tue, 15 Sep 2026 23:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789516423;
	bh=OPWCzUYSAJXN4K++8vT6w9N1hwOvTESTMHXbrKefK4c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PplxQb5nyQyaZ7w46hyW23hoFg3yKZvpD+woczhTgPfqovvmPhOTEFEJLwmWzc1gk
	 QAACR2sPNCs6atVacLPhG5TcNwXo3GnUk/zXpbCLCC6i/dNCC8v4FBIXpGo+ojwdgK
	 jt4X9lbnN9dEOPib8ge0m2BdeNY4LlmbZ6XI2nRMjzIHLDUF3OBCskvQbmqNp2qmmh
	 lK4IrtmZ81P6GLSolCKauWVvNPjjVnzC+3wmE7hLQtVrtcvR17KT9Q81+K6VP+F2fO
	 SLa9CSCvNFfMPCmkwMDq60hTsEBKdFK8FjyC+CTaT/ZkdbiFLj3CjevYjYGRl0F0n3
	 ln3J6ul31bpCg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] vmcore: convert mmap_vmcore_fault() to use folios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Morton" <akpm@linux-foundation.org>, "Mike Rapoport" <rppt@kernel.org>, "Baoquan
 He" <baoquan.he@linux.dev>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Tal Zussman" <tz2294@columbia.edu>, "Dave
 Young" <ruirui.yang@linux.dev>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, kexec@lists.infradead.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, linux-mm@kvack.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260915-vmcore-fault-folio-v1-1-a0cb6278670f@columbia.edu>
References: <20260915-vmcore-fault-folio-v1-1-a0cb6278670f@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 23:53:41 +0000
Message-Id: <20260915235342.507961F00893@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 109A7140003
X-Stat-Signature: z3eqxgjnu8tzfwgiqo98osawoo3ax9j5
X-HE-Tag: 1789516423-414929
X-HE-Meta: U2FsdGVkX1/9z8N4NP3xblBw7iW1junzAhYQv6fRTUXhN3iq0mu9c1tJ37SKTR4VMpDmYhqLaWmPoHWflL6Gikw2gYoa/YQWlf6fmPkyUbL6Q6ABB1otX7doINH6dUW17kK4LLMvIDTMKPT6m9u0vRt5P2bPEJOyu1/WTxbkYdgbRRewzY7lXfuH57erFLnoek5sU+yKRf1/mwAszh5knPhTxw3S+HfxDyUs+EhUBjt79KGVyLHUSjrIPKS+DKq3UqaPped//RBbFkwuFuYP/gQIQQqLtioL1RkCDgstdcV9XXNBgB2gaQvB+RcJv8kodmu5PQrNka5qAMdL4B8L4yckO+3KhHb4P1g1oz2Y9VHAoF9OB/jYSNiuVrAsEANvcHp6EwfpMfQyRsT0QizWwGpaSVgrEvonKIkVh2W4tT29h0xctqbwYx0M/uoslB29tlvBI4iExy4ufyvHDmIOhUJYjJEaweayThUfRYhhOerO7idQpEqsS7rLuZg16qD/nILnzNySNi1KaROvgNhNPOXQHNSOimOs9Ku+x7N/CJUA/315hgFzL55Rsk9nelmC0l+Xz+LrJFK3oxLVDlOO+/YPqIJq8cpK6jeTmXuHcAYJ3KJlnnx3OGni2HloThpTos0KGiW8VHlLFfF0sBinC8cCw59u8fsUebIH+jCuvYQRZVdc2DX/3fScQ/WV6kgIwlOqpkmLmh5aGicODTsnnOkigUC1Uj4OOuryoxOlcQG7mLLRbrn9AFZcHsA/H60h3kEWIzZRXge0kxFHFpkmYBWBLDgek7MCTs0vYTw1Fvbfke72px1QQIFMuiVEF0tYGNZTvR0dzs6zo2+IcJT9jso9IEBGM+kOqfHzR4yh3Az3sQ2BNilaJCsgxNUmqmSRuWrQiEaVF2lqiYt+bNJ4r5tOIn5uB8+AW9eXkhnmMhH2w6K4Qmd4ZylW8oX51ehhpJbhlISvWLTxLS72Xeg
 1v/y0rwM
 aEcelDsokw+oPld144+n5JXPdqWfi6LaINHL958or8Xdt+VsEZewchtbB8PXzWLs7P0Vv47zjK+3fRnvBXPdqhv+pPjc9iJY0l5BxX3CrQHhPkJMBkjvsBUS3kMG1SFud4jiQP0xw/UO8y+F1hrb6DdkQR+rBmNTNDoHsoQ1GoFonUP0ldKysdL9csyDC0gY1wjAH6+Tx2j+7eXrRYThPxWWQIHfFdgsaXVqTvvvfFVu8I451Ba0/AGXor3ekcvBRVfdknLlQt7NT1nVMDHBEFCiPGlAonelWEjHlE34h9UKKZ3DC/ZE/3XlCXAv3D2WGpqDz9NUYtOuwXdRVstlPAqeOAFqgEQING6eDBCFhC4hPXnwY8KewRZ0f+Wprh6XtjgsbL1ogpdtTO7d2gjuwyVOpy3QupmqmCvHjFrIL4R0/5RI4YcWaPyr9DQSE17PU23mEUDkYKIKftinoXQJpv8uUBUjQarMt+DpFznA89xOfW3alWjr4bfaUKabXtapIGL0AGndDGhgiawrfOdiUtcbVnS998MMdPuY2krvuQWwJHZAud+naSEQ/wEbMqcrzqJFykUC3v1OqPumdkVcfJdB3/Bm3zL+tc47E13hMxRQFepQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Use a folio for the page cache page the s390 fault handler reads the
> old kernel's memory into. This removes four compound_head() calls and
> one of the last callers of find_or_create_page().
>=20
> The vmcore mapping only has order-0 folios, so the logic is unchanged.
>=20
> Compile tested for s390.
>=20
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-vmcore-fau=
lt-folio-v1-1-a0cb6278670f@columbia.edu?part=3D1


