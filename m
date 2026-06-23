Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D19CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 21:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00E486B0088; Tue, 23 Jun 2026 17:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01576B008A; Tue, 23 Jun 2026 17:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCAFF6B008C; Tue, 23 Jun 2026 17:23:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA9E26B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:23:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BF6C165DDA
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 21:23:42 +0000 (UTC)
X-FDA: 84912454284.15.AE7F85F
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf25.hostedemail.com (Postfix) with ESMTP id 278BAA0005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 21:23:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Qx9Lc2W/";
	spf=pass (imf25.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782249820;
	b=MbOTZF9OpxAf0BD7SeBhRaK+DujcIZquvlsJAPwCmoQnwwB3Mkb6uEk7/hUqp+JYn6Q532
	J/K91UBp0NoJfcvMO1uCUzI9Ye3FTW+cDjptNStsMSRpA5F2N2eQbUzpl9+XF0rM7/Cxt4
	NDwoyTdko1qO5MB1wCY2i4wyXgc0as0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782249820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbQMjijENoTwEtXKCq9SMLmcNPckarSV38WOLjqdRT0=;
	b=YaMAk4UTSi2N6JAZNaRartfXlTIIiFGYamjxhVxfN3OcAf2tDctnbhadMzevUPJWG5NHvK
	TQ9zD11613dw7iJqak1Y3PGWm3fOtK2XPk535ISL+Db8hy42zRa3pLZl3KmqaGpBnDb60P
	cHYmVQUFN/yspwxVBhhHGVK7StZQ7bE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Qx9Lc2W/";
	spf=pass (imf25.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782249818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NbQMjijENoTwEtXKCq9SMLmcNPckarSV38WOLjqdRT0=;
	b=Qx9Lc2W/LK1IuYN7D+Z3isSkqKf5m9WtBOL6EmqBC18yWkr0CfJ05cIEFEgnhnOl4RS5eP
	+E+hOV72cwN8LISB80FRlOKNG8kkI314rx3YGKIscxGF0KtoQh3X4/AALNEVFLlp/q63jt
	WzVQU6sfUK5iDIPJiI1Jj56nzj7lrEs=
Date: Tue, 23 Jun 2026 21:23:32 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Ilya Gladyshev" <ilya.gladyshev@linux.dev>
Message-ID: <b8b444637f51df57762ddebf8ac3c515d3ba2262@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
To: "Matthew Wilcox" <willy@infradead.org>
Cc: "Linus Torvalds" <torvalds@linuxfoundation.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, ivgorbunov@me.com, Liam.Howlett@oracle.com,
 apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, david@kernel.org, foxido@foxido.dev,
 harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, vbabka@suse.cz, yuzhao@google.com,
 ziy@nvidia.com, pfalcato@suse.de, kirill@shutemov.name
In-Reply-To: <ajhcia0BKmTS6FQG@casper.infradead.org>
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
 <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
 <fe53d9a75f776a5e002a3375d086c5714f558547@linux.dev>
 <CAHk-=wjwdbrwUpTiQef5eAd9pfC3bKig9YpXxoHQinssubRh=w@mail.gmail.com>
 <839a2ea2755fdddf5af773e006237b07c9e261df@linux.dev>
 <ajhcia0BKmTS6FQG@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: jmsj68m7154uer54xjt8ojzgfnm8535z
X-Rspamd-Queue-Id: 278BAA0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782249819-17023
X-HE-Meta: U2FsdGVkX18U7LGXeKu+AXgyJhn4Ft8IWqIrpoKelPot5IiV2lNMVlMKBbl0oBxNL5BuwLRcvnN+7OgTtyePBY6NXqxlhnneSh4UDPS6sKfWD2HuCfwIMIpC8r3CQskBRkDpX75fwVm8Q8diC19e8st1Jk7+MJdJVdpO4KJDFMwquQTda0GMY7/eu5ejOYhLOF6NlSsL+1djJOzMxF3oUkmvO98L4AsfXw8OqxudcmhwdiEthhs2bhre0hjQCrJf+zVNPOxeKGMmsi2FbDuEovzqMv3XSVoq9NapTiOWSkXnjDnLbEiMz16s9tdXGUGkWzrb71bzA/dZ+NsWTXI1riUt+1ekJQl5SmloeuvgLJuSTDLIRcGRHkpb/tYaNKn52CYQ9BNkKvPrC5e9sjNY4ImdBb5h8JmnA1QRkj0xMhiBf2EvvJhb6DtSDXD21J7E8Pih/B59Au81m+LGA7cBBy/GvEUs5KuL0PWkos67OF/0vHREdeh5nSzKch+Wdnzvls3Ip9zBLRi0a/cLGLKH1qjfoOQxLOWa6y+oV3HMCJ/ny6duTUj5tlmHyuVomANhY4Kp7Oi3VpPKbGml2YoaZeJYKiB7neQ8Q6KMto6y4UPp5fznOi2x2o7HQTkGpPwO1HXTnn2bPdataXVBBApj6JpEbFnX4Eg9AlV7iOh+EfeDpNf9212GwY3x85kEfuR+EbvsuEY5dYkY7RjfBVhznd+SqwqXIircDjkinnmjc9uCxVO0X3cdXXPejdjJwbr0I9FYBlNsWnXbMu2UpOTuYjQeNboHyHQJ5HyU64vO8v1YjIdHASwiT826yRwzRL4YGo60axqHNV4X0kokFYUrRZVqlAuupr3GCM5KY9ysYVc4aOCmSGEzJ28OGcrt7Oau3Zwjq8EXwsAg22I8y513OtbaiJW6dCcVXo9N5ucVPqg4ezI0vRn9+Xpt5aHpwG79LqsM9cAQwrsK5ccPloW
 RnD9n5vZ
 iZjfSxgiVOvE5OdHc10K0Ave+GXDvIhoPCDTtiDDi8STMEWtsszOghp/Xi6vqMkw51UGpiRot9LWMB3ODLKL4YH7lAvgikc25Sk/+k2g+QiDmldM3e76rqxB0OBUpobRvaDPic7Od4olBLEgumNaPwb2QBvdrqK+f2jT4D2w3TT05zMebuOpo/qWHPcFTNZ4ERYSdFIOOzhREWWlm8oPIbqya9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Sun, Jun 21, 2026 at 09:34:47PM +0000, Gladyshev Ilya wrote:
>=20
>=20>=20
>=20> June 21, 2026 at 7:46 AM, Linus Torvalds wrote:
> >=20=20
>=20>  On Sat, 20 Jun 2026 at 11:19, <ilya.gladyshev@linux.dev> wrote:
> >=20=20
>=20>  >=20
>=20>  > T2: optimistic get() [0 -> 1]
> >  > T2: put page back [1 -> 0]
> >  > T2: calls dtor for type X, returns into the allocator
> >  >=20
>=20>  Which optimistic getter does this?
> >=20=20
>=20>  If I understood you correctly, you are talking about the scenario =
where
> >  an optimistic getter took a refcount on the stolen page, so the vali=
dity
> >  check in the XArray will fail. And this scenario does indeed work no=
rmally.
> >=20=20
>=20>  This "ABA" happens if the optimistic getter successfully gets a re=
fcount
> >  on a valid page, so the full T2 execution looks like this:
> >=20=20
>=20>  T2: optimistic get() [0 -> 1]
> >  T2: re-checks page [OK]
> >=20
>=20I don't think that can happen. Or maybe it can and we need to add
> some barriers. The page is always removed from visibility (whether
> we're talking about a page cache lookup or a page table lookup), then
> the refcount is decremented. I hope we have enough barriers in place
> to ensure that the refcount decrement is observed after the removal of
> the PTE entry or the XArray entry.
>=20
>=20But I'm not sure why the folio_put() after a speculative get avoids t=
his
> problem; why do we need the recheck to be successful to hit this race?

After additional thought, this race doesn't require speculative gets at a=
ll
and is more about two parallel `folio_puts()`: one successfully deallocat=
es
the page, and one sleeps for a long time and then calls __folio_put() on =
a
"logically new" page.

And as everybody pointed out, this race isn't something specific to this =
patch.
So folio_put() was always ready to be called on non-folio objects due to
optimistic try_get() + put() in the filecache. We only care about calling
folio_put() once, and nothing breaks with this patch.

So thanks to you, Linus, and David, for helping to clarify this :) I'll p=
ost
v5 with more or less cosmetic fixes from the AI review then.

