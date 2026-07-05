Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 835D0C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 19:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336846B009E; Sun,  5 Jul 2026 15:10:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E7136B00A0; Sun,  5 Jul 2026 15:10:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE866B00A1; Sun,  5 Jul 2026 15:10:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E144D6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:10:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50F7D167BD1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:10:06 +0000 (UTC)
X-FDA: 84955663212.23.43BD1A8
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id 97B9D180006
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:10:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=O4IFuFM1;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783278604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROhFDZ+3lqXGglJpqpPFlJTt/eEbN4Pev0D0a54+GdQ=;
	b=grDniYqErzkGB0AyUC7tF4BuC8G7VL7hv4uxKX6fSGMcPQMl+vB1QWhwpEhZMzOrwQZe1A
	lLJDG8WhPnYjq2qNHanvt/edJXJDwZzYxfVGEvO7FRUJE7m+LNv8b45tjwlISB83QY9pKW
	wARSo0bpX/hoYzcTCehshY6wWNI0edo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=O4IFuFM1;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783278604;
	b=mTqzl3sJ/BQwEG6rzAzt8474XS0AaSNKF7UO8MbrJQBk4M1RC+6u8pQhryH3OS84ncx/x7
	pyeVoAIvh5pphAiWolWBdE7boUGcc/cM6VdcN1BNzoastG/OrjPHR9BtilbWnsh1Z8XDAj
	DGr40Dbsvp11IgqP1sKxWubOQhvoRiE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ROhFDZ+3lqXGglJpqpPFlJTt/eEbN4Pev0D0a54+GdQ=; b=O4IFuFM1wBnG5IoIRjgNYn5M8R
	yzQ17YZVu+DTTQqp2TG3tqXwJHa9zOWkzLPh3kiTbeewYVLkWcaLQD9CuP5awSpvhywIBxQI6I5hK
	OdiA4fEHX49T8jROdHejMOhNVLnmwqP9X4nLNK8CySsZ2TpYW2y99Q5UOp+SjmO/4gisRzsg6yJj4
	iAj50RyXvwHGwsB8JB8fIDq4HikVtu1//Hp9OwYv6DgUuLMsg/a1RuHzprfnwqJmCD2Mu012rT0IV
	JM7wFdfSrm1shFJgBTyXp9vHlxU0S0/rx69AwQ6wflsxB6LXcgUIaF11MQL1sCqqd7f11/ad6TbHe
	2SktyLhw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wgSD3-000000004CM-0Hzy;
	Sun, 05 Jul 2026 15:08:57 -0400
Message-ID: <06bc706b4f7ed59950915c6c5f6e9752b6e85216.camel@surriel.com>
Subject: Re: [PATCH] userfaultfd: wait on source PMD during UFFDIO_MOVE
From: Rik van Riel <riel@surriel.com>
To: Usama Arif <usama.arif@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, 	baohua@kernel.org,
 baolin.wang@linux.alibaba.com, david@kernel.org, 	dev.jain@arm.com,
 lance.yang@linux.dev, liam@infradead.org, 	linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, 	npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, aarcange@redhat.com, 
	shakeel.butt@linux.dev, hannes@cmpxchg.org, kernel-team@meta.com
Cc: sashiko-bot <sashiko-bot@kernel.org>
Date: Sun, 05 Jul 2026 15:08:56 -0400
In-Reply-To: <20260705131231.1499198-1-usama.arif@linux.dev>
References: <20260705131231.1499198-1-usama.arif@linux.dev>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 97B9D180006
X-Stat-Signature: b1ozuzbpxosm441hhpzrygdijwzj1xte
X-HE-Tag: 1783278604-460610
X-HE-Meta: U2FsdGVkX1+ZN9AumWOW4l66zaSPyVxO85G6N6nb+wdJCnZKcyvffeMfuYv4dvIi5iMH8Pb8FleiZP6MFTd6cVmUCDPoQclwQj4QRsemjQghP4RReYf6si6uogF3ZcQT91nhqiR6m0WYGm2yeFNMGwep6naPQM0B8dynd3rJ0QF/6/AnD0vlcXjyynGYJbaYq0RfoZdr0cjMxwxhtJcAoUAs5M5Uv/ZWzoSyfDe+MZUxtcY8dhRp0dnhT5Sngh3gzqFZq+deKLU5UtUsV2c/znfINC3ZPt14H2lKoaTMK6HpsmkjNSybwHPpCY+W0Fpiqxk7catJo55048VoNTDGPwBLq58Pnb5OZsv1Sx4920yCeYFY04vEMNqZIkelITS48nCst+BSsv0OzLKFeaLEg+3zCN7d01XUzoKk3nA2poKpHj5L9B32PW5U7Bgexpm2sLtHS/GN/mZ3otAWo4biVY/fDriBMEg9ZJGOHLUDd2BM2ycYKy6N66xr+0p8NsW/ckIU7PRoewmSBRWAZ43ydQMz83Jhj7wczAQ1U9tBOm8RVa4KCsVZLUiF+4HZDUuqyvfIbzrnghbjr8zh6FfJzZWH7eJnm7gvphaV/JDYIZrNmJ2hIljMlSJd8Dtxdn2snUlC7c/gHE4cWMVe0dVq5v7TxxtauRwsEXFmgc0/htZzKx7DwB/Pp0hdebhpvrO0JbB3P7iZXGIuZWwHKJih33jOj5+odFVM78Gj49PYpy5OAe1ZpeKfd458L5hn3NCzsJuJgkdtOHQzHOxWXmmscO/5sEPLy0VmPWlDtXNhDOjAws8YJwhWZZ2gQUk3kWyiDuOJHoCTHdi2i1wnVZkYxiqAz8pZ61krOfmRpW8O/b/kYWYnaqHz+2P1nRLAA95Tx+QIbsrzoOS+/jJnGqlyQ7a+EmBMI5dHSylNpIUmwpKrkglMn5F8siZ5YsNi9WLhwy4T4XKLyB9Lxzlwk0i
 Oa68gYKL
 BxiKUqvHG326p+10xizKn3OznVqS0vdGlcH/QKbFbqRMtUbMpNtN7tHdZx/eYxAFzMHQA6dsk0q3iLyKd3zFMZxmNJZ+ZMoOxCmNm7XYHwXjoCS6R2aQ55vqiLCyHN0uU2Nru/75OeiR8eXu7SHf3Al9cD3NzJIceug8ohySvMB24lV3iZ9HCHVRB4GJkUd5h4XMpQx6REwVbBTNvMKSEnn8nX9fPIllxhSyVBf9B9Zf7BuRINcgYOU5SxmVdOozj7FsbtgqgenCokJqfVBFpEwIFBRWZhlRqm8FeXMuG/m9gtpcc9rjDlUjwQn+NGZ7sK5b9Rj0cENIY6m63jS2CkxsRSfSoDB8da0oMVmL6aRMT4gBL69L0D2E0VOivxb+VHpnzNs7G1Ws0kwcCXpqkZUyWjHoNF/wT1cFU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-07-05 at 06:12 -0700, Usama Arif wrote:
> move_pages_huge_pmd() snapshots src_pmdval under src_ptl, drops the
> lock,
> and, for migration entries, waits with pmd_migration_entry_wait().
>=20
> Passing &src_pmdval is wrong. pmd_migration_entry_wait() must lock
> and
> re-read the real page-table PMD; on split-PMD-lock kernels, a stack
> address also resolves to the wrong lock.
> softleaf_entry_wait_on_locked()
> then waits without a folio reference, which is safe only while
> serialized
> against migration-entry removal by the real PT lock.
>=20
> Pass src_pmd, matching __handle_mm_fault() and hmm_vma_walk_pmd().
>=20
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link:
> https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linu=
x.dev?part=3D8
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

