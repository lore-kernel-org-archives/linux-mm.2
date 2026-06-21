Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6CDCCD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 21:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280636B0088; Sun, 21 Jun 2026 17:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231766B008A; Sun, 21 Jun 2026 17:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148226B008C; Sun, 21 Jun 2026 17:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD8726B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 17:34:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45E9AC21EC
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:34:59 +0000 (UTC)
X-FDA: 84905225118.04.A9CDDD5
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4CA4720005
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:34:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GXExkcGT;
	spf=pass (imf13.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782077697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+qigLIPdHrFoWDjUFktrl/sfbc2RolswMUSPfU7LxY=;
	b=wUCByNk9e8ruM3Qpj0osfSR5++gOAbhlts6gjrWEEur9GbXd8Uha5PEgF1NN/k6FLzPGsJ
	5PEY/cBCyQSsOxY2wj8AM5fVQRkJlv8UA8ZFE0F82XoL3okJn6tZ/zJEkDBicSvWmkmMJP
	qxUePG0bVA26+JuMIhiQtvTk5nFVnPI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782077697;
	b=q2XrmJo5MvaAq42QPZ6/tatNd/8KAQ2kSoA/ZagXkdeunGKfPDi3ahGkOJgUt1LOkV6071
	sq2Gs7wiXRpkZt2v4c7dJc8qnJD5cepyeYfuM7qoAiLKI4wwaOhjuQTeAMjyJSLv5m89DI
	8rxsuJnwoDbHA2joNXy8z4EZgSnJSd0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GXExkcGT;
	spf=pass (imf13.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782077695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T+qigLIPdHrFoWDjUFktrl/sfbc2RolswMUSPfU7LxY=;
	b=GXExkcGTuOJcnv+ozYRBOM9AYGbahUnecr33XshVJiwNWeE+mKdii1lLEXYc63O5f/Nl+u
	6WhSBwwt+MAk7FyWettP6l3VqNJXZx3dTy61egjU4aTyiqIfABw7B+mG2wY+XCJjCl4u8y
	F0zyDJnEFdsKKAAl7q7JDLIjVYXBork=
Date: Sun, 21 Jun 2026 21:34:47 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Gladyshev Ilya" <ilya.gladyshev@linux.dev>
Message-ID: <839a2ea2755fdddf5af773e006237b07c9e261df@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
To: "Linus Torvalds" <torvalds@linuxfoundation.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, ivgorbunov@me.com,
 Liam.Howlett@oracle.com, apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, david@kernel.org, foxido@foxido.dev,
 harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, vbabka@suse.cz, willy@infradead.org,
 yuzhao@google.com, ziy@nvidia.com, pfalcato@suse.de, kirill@shutemov.name
In-Reply-To: <CAHk-=wjwdbrwUpTiQef5eAd9pfC3bKig9YpXxoHQinssubRh=w@mail.gmail.com>
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
 <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
 <fe53d9a75f776a5e002a3375d086c5714f558547@linux.dev>
 <CAHk-=wjwdbrwUpTiQef5eAd9pfC3bKig9YpXxoHQinssubRh=w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kof7u5zu9uu4ipn7gwijgarmjgsx8ot9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4CA4720005
X-HE-Tag: 1782077697-973876
X-HE-Meta: U2FsdGVkX18C8DxzC/5TNe2OmlqTpUEN730sz7ZXviAMmsCJ8UsjVF8KeoiKSSzstvXakBe2t8v8CRkyG5z9kvn+zeJHBkR/nf4hVL03vsDNBQttc/KHAVt5ZKLIlfXyYx0JVW1VBeQ1D9rNVMQ+kW+UUajO+fxPqxf2ON7sxs0gEOIINfF4EpujYJ0XvIyQJaXjECaS5cNq92JhYnPPR/KRXplfzpo1RVtz2QQUySSyxRSWErd7ojYOX43HlBwqsx6mMYHD9h49hIbocLCD+QK1wqAzMc0hTf6h1MZAEZSDtGQgNqCvFB6SAXbFcM3hj0bqBQ2DOe7+4RWWqz70gVNKBbQGfHMN6qQBCJBikLbL1i9Zt5rX1tXYJQni0xVD/W9HtxgvH6qfJuJMjOH+pco9Qtqzg8QdZ4uNJuh91FYBWxRv+X92VsuksyCKi2bcq+yfYGNKvjgXCuxTeCyboj+RgtNGLcfLCf5k70vOgYktagtXR67Y7ag9qnCRjYFwQimOqLcvQJTXx51eO/9E4thbEr9WA3mh2qEE8jpPIT3M/H4fop/jtTchjS+AmiLd1HKkYEvMMTp1T3uHJuZf380e6RrOEar3skW0XBNgjURswlt04HrM18zKaWF3z78psN+SHf9fc74pdCl7yRTtJjjPbeQvEwWkJhlAJfpMYQhVFt5B12DNbKrw9OGXE2UkHu3fK9jM8KbrIGjfWfNvObE4vzEbTJnb8Q7xUKXTUTnrxUKycLT5XA4U7UnIB9+E0/dmwRZ7vFm6yhYdZf8sO6bqbczf25/iRAu6oF22DFJfv7XSKputoGMo+ozhnJ1A3s7/+9Ll9wT538itM/xaYCoi7j/eDcqgJGO3ALxgP7cNmaOxPbW3yV9VjhnooBGEhQnjGammVYhYDIovCFUlnOHFR56xFfJYH1sZKCUCbsZRC2PRQRorG6bEzI8SCyVz5PykKvt9ULwMC/IggVb
 Ul5QmSJi
 1ifaL2WKC4cykx+JLZI+yd6MlOaUUhFpCUgqQ959BhVas5m3iyom5tfHXMkuCCOGOhMni9rqq+ix4BGURLNfqmWXMI5ZUTXVDMkxYfJEhPHCwBDe1yDY2Fb+ln2SFAAcVO3qtWlFbhcht5f8kHzBZrmaVPn7R7FUvRxsJUw+pwRxy5tiI/wTKbfUgE2M9YCdwJqm+3XbAim2s4dbIal8h15GpBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

June 21, 2026 at 7:46 AM, Linus Torvalds wrote:
>=20
>=20On Sat, 20 Jun 2026 at 11:19, <ilya.gladyshev@linux.dev> wrote:
>=20
>=20>=20
>=20> T2: optimistic get() [0 -> 1]
> > T2: put page back [1 -> 0]
> > T2: calls dtor for type X, returns into the allocator
> >=20
>=20Which optimistic getter does this?

If I understood you correctly, you are talking about the scenario where
an optimistic getter took a refcount on the stolen page, so the validity
check in the XArray will fail. And this scenario does indeed work normall=
y.

This "ABA" happens if the optimistic getter successfully gets a refcount
on a valid page, so the full T2 execution looks like this:

T2: optimistic get() [0 -> 1]
T2: re-checks page [OK]
T2: *normally works with this page*
T2: frees page [1 -> 0 -> FROZEN]
T2: calls dtor for type X, returns into the allocator

... T3 reuses the page, T1 wakes up and conflicts ...

T1 basically needs to sleep for a veeery long time to miss full T2 & T3
execution.=20

>=20I didn't go back and look at the series, but isn't the rule that the =
code does:
>=20
>=20 - optimistic get
>=20
>=20 - then check that the folio is still valid (*not* using the page
> count, but by re-looking it up elsewhere, typically the address space
> mapping)
>=20
>=20 - put the page if it wasn't valid
>=20
>=20 - if it goes to zero, there's no destructor inherent in that
>=20
>=20 - everybody who sees it go to zero - optimistic or not - does the
> "zero to frozen" cmpxchg

The problem is -- the zero you've seen and zero you are trying to CAS
can be different zeros if the page gets reused fast enough.
(Or couldn't and I am just confused :) )

>  - only *one* of those will succeed, and *THAT* triggers the destructor
>
>
> IOW, the transition to zero is not special per se and has no
> destructor. All it triggers is the "now we try to mark it frozen"
> phase.
>=20
>=20At least that was my mental picture.
>=20
>=20Was I wrong? Am I just confused? Wouldn't be the first time.
>=20
>=20 Linus
>

