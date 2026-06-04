Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92770CD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 12:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 046936B008A; Thu,  4 Jun 2026 08:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F125A6B008C; Thu,  4 Jun 2026 08:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA396B0092; Thu,  4 Jun 2026 08:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7F8B6B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:48:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7ACD98F36C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:48:09 +0000 (UTC)
X-FDA: 84842207898.05.009665D
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7320A140011
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:48:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l4Bdpw3R;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780577287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uO6E5r3K1wR5HuZ7FR4dwiQlznCkNkhdvy8XPywIrCs=;
	b=cbuonmw42y3/FRg1/Fc/cAJ8lGP5B62DLl7ZH87NAKYJjv0cN1VT0M0svMOb9Gy38ydD9L
	x3uMI76fjb2PvGEm23Lg6Cpe4osOAkEGtf/glqlh6nFrsC4kaFBC5sVTneVSViigJUYuWF
	SsupKpCiMryXB2dSCMnDbIlrusJ8VkM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l4Bdpw3R;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780577287;
	b=oI+78MNJe737HPg2OfeKVxj+U8MDDhR7EcXrNAww4u208hHsokfrjunakxPYj6nMnP2SNe
	39Rsb9YkYE2P2HJoYf/nM6XtfNQzoDqrC1UJymR0UWDEbm6n3oRwMET6QXmz2NaQYvynkE
	WcgSP7taKKM9IFpjOcXrZZ2iD6XTY8M=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780577275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uO6E5r3K1wR5HuZ7FR4dwiQlznCkNkhdvy8XPywIrCs=;
	b=l4Bdpw3R+NXNwi7a7a3iwPUoM25HbvBYR4G3wJPJVxGTRoSign06+gp0BqljYQ9vcNR0ke
	AyWHPw2wBgjLOQ8Qx/o9IyBY8HW6xCRsi/hd0hF7q8Jj3pSrzQ89G+n3XJHXQYFJQNrQ17
	ycDGG/R8qe7MgHxwe6l1Voz1YaL8za4=
Date: Thu, 04 Jun 2026 12:47:49 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ilya.gladyshev@linux.dev
Message-ID: <431c8a974d685d547b0ba1ebe887ce200291e044@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 1/2] mm: drop page refcount zero state semantics
To: "Kiryl Shutsemau" <kirill@shutemov.name>
Cc: ivgorbunov@me.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, david@kernel.org, foxido@foxido.dev,
 harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, torvalds@linuxfoundation.org,
 vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, ziy@nvidia.com,
 pfalcato@suse.de
In-Reply-To: <aiFZ57eRrCcWmS6E@thinkstation>
References: <5dabf3a748fee0c7b142c74367e7586f5db1ed1e@linux.dev>
 <7c28d766b007345f5f31ba9a086a3bffe95a013d@linux.dev>
 <aiFZ57eRrCcWmS6E@thinkstation>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7320A140011
X-Stat-Signature: f6wqrzhfsq9nqibwrcb1qecu1u935br5
X-Rspam-User: 
X-HE-Tag: 1780577287-842025
X-HE-Meta: U2FsdGVkX18krCLqyP3lC1l+7JGB21PsNon5uDXfUd/H/78nyWrB0rVMCeghfByUJR8hCoAOix6oB3vb/P204Qadu+uxREmVoKPH5s3J1kdrufQvpJFfq8bFlyLamBh+xFyU+s2SPCmzhYcny9QijTHqOYikk0jJTMkWkVxEPCCaFsY1KdCwj2yetoZnDBq47ogApZjaBX5udOI+CiVhDLrWlQcWrYu1igbXNeNaf8tPd0eA6RlOAEj5XFBqXKvys0uNcvMVfLV5NkdY4+Ellt6KMbg5ypeNVKQWJEcIhdA6rWD6m74E5hY3Z8YXwzla52OGC5O2tixIPNxKqVztR6VqdElUh6u8bd1tb4C2dxNgSkKSEVhboK4mL/qRHb7p5RDU/rlCBinKOSB9NhgyGnF8RDLhnIJnBQEa+UI/WmdNxHrfz+71VthF4d/LuzpljnH8OjwQML8KNQP5FVGRx5VJaFMuECOTuWesWWJBVmrDOT47aOOGV1iMc98BliIy0Je68/WXYpXQMOLbwuPD5tXeZXpn8zlOTrMRmuqGbDzzO1gqg3s8qpwl1ktc7t8id4+8dP6JG6GpTBtjNTmDRwrE4aEEdzLamGQ0rrUnQ+oHXSp/MM+iQ79pZUjrdubqb7uh6FW0FvmwsRsrGQvMmrKsw3t7H8TOxRLFF1MNlwV3tsDRDGAMu6MX0BKETCZ0rVfoZPs+d7uUSfiL5Hg8moPVEfETFUMC2vokiW928zhnmFuw6rzx3ulaU8C43wFB7WBu/O6ZnQtjCcywYM6YDplNBfaem3Z5L9RL2pcbw8sSJIzRxSugKCQ2aRRJ5WMlRg0DJISVxb3S3LFZNkkI9VcAk4kbGNDnvKtoh5IvCyTnu075z/1i5pY+gOTrUT9/V/gkWsGOsb5S8EaAYnoMPqN/ktdWIuLL0kin98zaZ7EyACbXiHzQVR1Oqht3iwJPUV3Blj/xO5yyGDc0PT0
 C3idwY51
 1ASxL8OHTYUxUFMoTEMy7fGXewPMu2mZ4SauI+DEyK2ZhPD4dOCItgUZ5Y/uPftyPUM2j80ik6WpZ5XqBf4DkXO/eOf79fKrnKRjbFNUi5G+C4If0/ZTsrZhFR1hTOCBnAQU8uOUnoC7Ur7V7BgWZvdVaS7aKOqJfsuX2929FxEeZI6UsXrprT+D6QS9iTNhNnhtTW8xBxarHxN13RHY5mny9uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Thu, Jun 04, 2026 at 10:15:12AM +0000, ilya.gladyshev@linux.dev wr=
ote:
>=20
>=20>=20
>=20> @@ -115,8 +120,14 @@ static inline void init_page_count(struct page=
 *page)
> >  set_page_count(page, 1);
> >  }
> >=20=20
>=20>  +static inline void set_page_count_as_frozen(struct page *page)
> >  +{
> >  + set_page_count(page, 0);
> >  +}
> >  +
> >=20
>=20This name is strange. Maybe something like init_page_count_frozen()?

TBH I slightly dislike "init" in this naming, but it's probably better
than our proposal. Maybe set_page_count_frozen()?

> And don't you want to update it in patch 2 to set the bit?

My bad, apologies. Don't even know how it passed stress-tests...

> >=20
>=20> static inline void page_ref_add(struct page *page, int nr)
> >  {
> >  + VM_BUG_ON(__page_count_is_frozen(page_count(page)));
> >=20
>=20Hm. These VM_BUG_ONs are useless after patch 2.
>=20
>=20In patch 2, you make __page_count_is_frozen() check the frozen bit an=
d
> page_count() masks out frozen bit.
>=20
>=20I guess you want to read raw ref number here, no?

Yes, indeed. I will rewrite with __page_count_is_frozen(struct page *)

> And why not VM_BUG_ON_PAGE/FOLIO()?

Will change to those

> >=20
>=20> atomic_add(nr, &page->_refcount);
> >  if (page_ref_tracepoint_active(page_ref_mod))
> >  __page_ref_mod(page, nr);
> >=20
>=20--=20
>=20 Kiryl Shutsemau / Kirill A. Shutemov
>

