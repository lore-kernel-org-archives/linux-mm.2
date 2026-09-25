Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7506C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09A96B0092; Fri, 25 Sep 2026 03:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0B06B0093; Fri, 25 Sep 2026 03:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCFD26B0095; Fri, 25 Sep 2026 03:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A52B96B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:03:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F7504053A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:03:20 +0000 (UTC)
X-FDA: 85251393360.14.776C2C1
Received: from mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	by imf31.hostedemail.com (Postfix) with ESMTP id 17F072000C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:03:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oz7kiieG;
	spf=pass (imf31.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.36 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790319798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p3Y5SLwWaRwzKr7uM5/FTBC3hT4eOudf7RhORFDu3PM=;
	b=cebGkUYpxy2nncMG7HA0kUK5JjVi6KhHnMViPt4uiGQTJ/Jxdlm81ZkJ0W0gZLSKF8Rg2t
	QP5+OD6liJl9c/ExSqJU1janFULCAWxHUsvNHoo6N0/HF7sBvmszQ9GEaPvu1d3vLtsCse
	zZOsJ+ulgPxY8U1oyDGMCr6A5dCXwGo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790319798;
	b=7xBcJaHkzxKJS4itjG9JSc4xXYZZIf+29QuAMGpLXmelXeKW2e/rlcP93HsfK5mp40fQXq
	ZZT5TGOOaIA0wsyPmZqcQDZjrkFatAukWAT81FqNC9eTR87K+IV2tUkcSifquzoW4kj4+d
	b+BNvY3tH8nIZoBrApzUntPNdFpCZPk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oz7kiieG;
	spf=pass (imf31.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.36 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kewsY2OluvVAW64X+i+86icUTbgNEdAoaeGfcLyjEu8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790319794; v=1; x=1790924594;
 b=oz7kiieGnfL4paSZwrjaMApP4sKPauioqNRtEnoJAwTp1JzL6M3okTaoGOuTMWtEDL1ABPv0
 cimZpzbW+aksPEzg7XkN6aVpN6mrBD11S5a0zNEUCcg1PLTcrNPqWXnzJ1SaR11SW2BiC773A/Z
 T3uF9Y+Ehto9cv+eSO3elGwE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1628244cb04595ea;
	Fri, 25 Sep 2026 07:03:14 +0000
X-Mizu-Trace-ID: 1628244cb04595ea
X-Migadu-Flow: FLOW_OUT
MIME-Version: 1.0
Date: Fri, 25 Sep 2026 07:03:12 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Ilya Gladyshev" <ilya.gladyshev@linux.dev>
Message-ID: <a1d5881926dbf4b16dc796fb1da939f32dd42f18@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v6 3/3] mm: implement page refcount locking via dedicated
 bit
To: "Zi Yan" <ziy@nvidia.com>, "Linus Torvalds"
 <torvalds@linuxfoundation.org>, "David Hildenbrand  (Arm)"
 <david@kernel.org>
Cc: akpm@linux-foundation.org, andrew+netdev@lunn.ch, apopple@nvidia.com,
 artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, edumazet@google.com, harry.yoo@oracle.com,
 hramamurthy@google.com, ivgorbunov@me.com, joshwash@google.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 pfalcato@suse.de, rppt@kernel.org, surenb@google.com, vbabka@suse.cz,
 willy@infradead.org, yuzhao@google.com
In-Reply-To: <DLO1WIACYFWF.3N01DXYFJLMD0@nvidia.com>
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
 <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
 <DLFJL5U9DI6F.3QJP9YP0KX636@nvidia.com>
 <56e036665dbeb0a8f51d697220d5ed84f210994c@linux.dev>
 <570cf649-a8bf-4073-be71-207fbb2bef40@kernel.org>
 <CAHk-=wh3LLDV2AMZn1PZcU1o3Na-BNcQtP=LPXouLKPZWaiRdQ@mail.gmail.com>
 <DLO1WIACYFWF.3N01DXYFJLMD0@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: unerwrfikae7hxsphmeprkwd7sn7k4x8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 17F072000C
X-HE-Tag: 1790319797-881815
X-HE-Meta: U2FsdGVkX1/3m8ylZppG60lihK9gAQiHkXQ0OBPg7AJhVJkkVkVbwjIOAfbDQGNXh1VYjo90eKeKmelglF9xKG3iXHlAtWB+NsWpE0peWSUSON+WLsFs7WSni+e2/1MeuvEGsC9O+d5OL6NhtsQ30H0jrRh69xvnXlrI/hOMfkotWXG2690+EpUc9qX/29r+o2+4iCBIJuOBLscZ5RHMaC0/2jy0ee7W96bzJsmVxgNU5WibbCX9YrvSB/S79981PoWpcw6zEHqBBactruowQBe2D/wwpd1syNtd6HTpeHXh1J2fokFqOSUp84H3QYv35/cg2DTIY0W63GgAqc/gD7/+H+T/ywzAYCVwoPX0EuhO5FByAlDwWz2vXTEBXXxlKda0XbR8ubqglnv0GuVsi0P8z6GDtTACJ+WnSrGfhyDYJ5lbTxHlFxyZP0Tj41+BAWtRkW3QBDFxl+YwfEMiFP/ydAA5LRFy/N3u32UPmeRmySvEf/ltu5f8pYTDja38HQPe5J98CVcZeCpT93Fjc2LQJw42qq/YM4k8AxK2VxYPn7TugH0jhpinSbqWq+4CWDt/+g9aLu9KugG8IIsVp+V/EUhbFX7dJTIyQuhl+Iwm4myHUMyK/STC6cVUEfaXVtcBsqRaZ16sKUnQvNnmR89B3xb7s6IC1Pp4xb/55vjY923oFi4RE/Jg9tZclhVM98lEb4PLdOXy/4fiUt/hyOitQ0eSCChdFw+ai/IwJK4o20jgyC0VpINASKayy1U/sPa47rT0izuAO6WSwJCBFuUE2lEev+UfoUJsJWqRxV7rmeHZpcvlGto/CBRaEQ59U6zK0WRr97lylcYoymc6lUIIhWwC8wfSC0GnbXl4nzjaUWcfJmkAThPG/k8I4sRD2looreEF02FLfmLQ6lB+xcO9Zx63iXEt0jIsZidU4OrM+NNnZULzb9hIUpnSzwtT5l37OoWOBf5FSvfM7gM
 fFU3qus8
 E9UUZGmyAyHmufdQPEtEZ01Ns95zGM2iCSOWqlpQ0/4lbpynExTCKhnWC6i6jiLM9rQp4gsvlyZXhOFZ4GFuzMA6LWZei1BlAL/Ds20CaEI3blS57/7+5a0M7yAgNAxklh9feWa2S4J5k87TFy+GuuO051aTtRrq49fMoZ0QbzdHBinfSivJBGR0XDBvKULCkWbBcocoFBnRkWJlwtz1+/ASBmZFkLydMw5Xq/3BmqHfyKI9dCHvXxrLHvowq9qe5joUAILikcOwjpulzJG65qUSN8IiBQ0AZkkEImLwIsxSXi+Szkamm3Pe+wcJo7blNPJyb30NPl55zLOYFD6UljC770WSbwyXB9Z/aYPs8yNySPQiBLjpM1gGIhCqoMe/7oDx/1ds9Hb8K3oK3Hqssj1QZBSKDlp2TOg+E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

September 25, 2026 at 5:44 AM, Zi Yan wrote:
>=20
>=20On Thu Sep 24, 2026 at 4:06 PM EDT, Linus Torvalds wrote:
>=20
>=20>=20
>=20> On Thu, 24 Sept 2026 at 11:52, David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
> >=20
>=20> >=20
>=20> > There needs to be a common page freeing function that dipatches s=
tuff.
> > >=20
>=20>  I think this all needs to be entirely generic to all pages. Agreed=
.
> >  Everybody needs to do it right.
> >=20
>=20It assumes all callers of page_ref_dec_and_test() are free page
> functions, but there are two exceptions:
>=20
>=201. compaction_free() uses folio_put_testzero(), which calls
> page_ref_dec_and_test() to put not used migration dst page back to
> isolated freelist instead of freeing them.
>=20
>=202. virtio_mem_fake_offline_going_offline() drops the last reference o=
f
> fake-offline pages, so that they can be offline.
>=20
>=20They will need to be converted to not use page_ref_dec_and_test() in
> addition to a common page freeing function. And any such future use
> needs to be banned.
>=20
>=20>=20
>=20> But I think that in the scenario that Ilya mentioned:
> >=20
>=20>  Refcount operations as follows (FR =3D FROZEN):
> >=20
>=20>  A: DEC 1 -> 0 [ page_ref_dec_and_test() ]
> >  B: INC 0 -> 1 [ folio_try_get() ] =3D> success
> >  B: DEC 1 -> 0 [ page_ref_dec_and_test() ]
> >  B: CAS 0 -> FR [ page_ref_dec_and_test() ]
> >  B: * deallocates via __folio_put() *
> >=20
>=20>  C: * re-allocates page *
> >  C: DEC 1 -> 0 [ page_ref_dec_and_test() ]
> >  A: CAS 0 -> FR [ page_ref_dec_and_test() ] =3D> success
> >  A: * deallocates directly via free_frozen_pages() * =3D> BUG
> >=20
>=20>  the big here is that the de-allocation was done not from the state=
 of
> >  the *page*, but from the state of who finished it off.
> >=20
>=20>  So that
> >=20
>=20>  A: CAS 0 -> FR [ page_ref_dec_and_test() ] =3D> success
> >=20
>=20>  is not a problem per se. It's a fine case of "we had one single un=
ique
> >  final free".
> >=20
>=20>  The failure is that A then goes on to do that
> >=20
>=20>  "deallocates directly via free_frozen_pages"
> >=20
>=20>  because A mis-judged the page as having the old stale state that i=
t
> >  had when *A* was using it.
> >=20
>=20>  IOW, I think the soluition is either:
> >=20
>=20>  (a) every user of put_page_testzero(page) agrees tro do exactly th=
e
> >  same thing and there is no difference between how that final
> >  "0->FROZEN" is dealt with, so it doesn't matter that A is freeing a
> >  page that C allocated for something else
> >=20
>=20>  or
> >=20
>=20>  (b) the CAS 0 -> FR state sequence always looks at the *page* to
> >  decide what to do, never at the caller state (ie A will look at
> >  whatever C wrote when it allocated the page to know how to do that
> >  final free).
> >=20
>=20>  Hmm?
> >=20
>=20Just wonder if we could make 1 -> FROZEN atomic to get rid of the gap=
.

Hmmm, I=E2=80=99m afraid that since you need CAS for a safe 1->FR transit=
ion,
it will result in a CAS loop for the decrement itself (like in
atomic_sub_unless). And this will introduce scalability issues just like
in folio_try_get(), but this time for everyone...

Unless there is a way to change the refcount encoding even further and
fix this gap.

---
Ilya Gladyshev // foxido.dev

