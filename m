Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A532C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 20:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C077F6B0088; Wed,  8 Jul 2026 16:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8506B008A; Wed,  8 Jul 2026 16:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83106B008C; Wed,  8 Jul 2026 16:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 73D306B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:30:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07E2812028F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:30:12 +0000 (UTC)
X-FDA: 84966751464.27.21FD0E0
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id 945BA120006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:30:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fUpaszc8;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783542609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBvW09pndD+v2Xf3j/lga1/HggWzUTjZnnKR7RyZuhQ=;
	b=ZfqtOPXGV9zSMGf7zWv5qEnmkjGvDNiDhfGOGUD/HTp3Y6QWTYr8UQImPmRBIZ8PiVvZ6J
	fMV1RNHLQ5F//AvNZJs/vSTXxH2hIh63LjJwdLKL1zSZflgXqF6Aw5cIuOJlxLfmsXnybH
	54rbGkvIUrNv0fpXegF8b7pnogCUHN8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fUpaszc8;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783542609;
	b=N2UccYK8w/HtRlr0yq2F+kSSi8m1t2U1Yzbyu7gJ62x53pMkhra44AumR8pmwPbHgGe/yX
	0QsPnoaGhrYyVjJEw7r+LcVeXRIZ0urT+qonh+Es36i0LxCokXuWPQu+6jEVBR9BLc6HhC
	UOxbGUnuDGAAMqOWXL+Mw9YSdLTKXmY=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 668KID6p139878;
	Wed, 8 Jul 2026 20:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LBvW09
	pndD+v2Xf3j/lga1/HggWzUTjZnnKR7RyZuhQ=; b=fUpaszc8skPFozdm7O4c1A
	mKnzKLlvY3jPdh43eaem5TpeOoSUTlOJjTY7YcZtcYKUU39+grefuEbyAOEUqih2
	InnXEPMifzqs651eU3rTI4SNQsst+6I4d9ZuS9/reBY7KnNkiftz8NK/hgNXinBk
	T0jOaIslVJiYxi0VRPbb3QGZkxl3NW2SlBlJfWejem2herPNNYr8ZDfksZQKcDkS
	bF5Q4SwEv9ZspNViWGpJeRchDf8cC3kM6XbyXuiDBbGRiqZw1q4o3IQur+ZIkNFm
	Ssf9gfwp9RpI2LTNW3TeSxE9EM9Lzhic4PGRhWYmDuCtL6sJqxU6W39xcna261HQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f6sp3xbrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jul 2026 20:29:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 668KJmMK011258;
	Wed, 8 Jul 2026 20:29:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4f7cvw9yxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jul 2026 20:29:46 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 668KTgwd51380608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jul 2026 20:29:42 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BA3F20040;
	Wed,  8 Jul 2026 20:29:42 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 93A4520043;
	Wed,  8 Jul 2026 20:29:38 +0000 (GMT)
Received: from aboo.ibm.com (unknown [9.39.25.152])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jul 2026 20:29:38 +0000 (GMT)
Message-ID: <c6f02ca750ee298179271bdd3a18819b882cfd94.camel@linux.ibm.com>
Subject: Re: [PATCH] mm/util: don't read __page_2 for order-1 folios in
 snapshot_page()
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Lorenzo Stoakes <ljs@kernel.org>,
        "David Hildenbrand (Arm)"
	 <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett"
	 <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	 <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Michal Hocko
	 <mhocko@suse.com>, Luiz Capitulino <luizcap@redhat.com>,
        Sourabh Jain
	 <sourabhjain@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        aboorvad@linux.ibm.com
Date: Thu, 09 Jul 2026 01:59:37 +0530
In-Reply-To: <ak4KweoRcwnxZC-5@lucifer>
References: <20260708015252.296103-1-aboorvad@linux.ibm.com>
	 <6fec660b-7c6b-44b1-a7bc-f4687cda734a@kernel.org>
	 <ak4KweoRcwnxZC-5@lucifer>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=KsJ9H2WN c=1 sm=1 tr=0 ts=6a4eb33b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=2rC0dEjZ3C1FtDirmhAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDE5OSBTYWx0ZWRfX2xnYgENF61hJ
 +nT2BklHoOuSCCIDiQXgBa/q0QCRR/S+GcVYxefTX2PT3ZfHfpQKE+2bEwdLgJ6p7petqMMxarx
 tUX3biHnXl/mEprx7dLo3jLOa+bc//k=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDE5OSBTYWx0ZWRfXyDL3OUgW03hj
 LzcA5SVmsVttWYSOjVCq5uCNmDoenBaHsOCOqBg46rdAF4x5U1vEEGcSqFariDDZXqWvQHaXuHX
 +8EmI9CXePGylu9+E4dCFwoPpK8tDIXYJsk5PF2nxBGc+bgsf8LPe8gZ6n0RAZTAtCk7RsBa/7k
 QR9TDw/b65ydjF4FnhSi1+bFvmNDnqYX16nChJuI0Fy0FbigCXiVKKjVPDPCVJ630eZQLBknnoo
 bA1tZG2OvW9t0aPCThl9MbAKhxmOt6tfUDvi4xRGAgd46Pt4KPczcAnhWZqFyh9QtRgzDuSdEri
 l89xS6kLUMtyrYVFkAbJ7+HiH/u9yK7Blfsk7nqiBtVgykIao/TYVWwVbvKQzCluZw2volcWCMC
 CjM56sefYjePmt2On4vykz+sc+NuAr9BKkYVyWp12NI9XgAIKjWyykPca0/dracECq9SAbYjtnY
 C57GRgoN7bYspjDEDzw==
X-Proofpoint-ORIG-GUID: muTjkVzEnQzSsoTgfL-Y9JALY6O0jrR7
X-Proofpoint-GUID: F31oZto7oACoYbs2oqwCuUGbA0-lUlfn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-08_04,2026-07-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 spamscore=0 adultscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080199
X-Stat-Signature: 3dd9a9a7yaccsu6czyhck1eipy4cwc5x
X-Rspamd-Queue-Id: 945BA120006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783542609-583874
X-HE-Meta: U2FsdGVkX1++t8JCm0MoIYmUeVuM0HNac1nKn4nzQby7Dx+ntbVL/bzbBFtWqTsDBLQg13U12Q20NbI/pLZTf22tJwiuMJLs4FxYs3I6c/d1dXFbJLB2S3l6zCHSEqQqNzAxbeuAT+pwbEFDw+UHX6UojiN9lE0BG2HFLmzdeB+n9QPvnB1o6igMy5jx5fQJYvcSiUEMAzNs/4IiNBTW7PM8MAKPnxqruOU/42cR+Iv2mUbR34W9YwdZYIxZSVc5t/MDVh+ZRZwXcAvW8YyUtR1zSFtoAPpTf8FOm3pdvyw3jplofVrDZ1gTeZWIt8kpwheLp+zkmFBRIpkznRNLpGoeMX9DStgdR4FUIP1c4XSIB8IfLyquWjR/DcPbge3paWBJBDJylyVPKiRpQ2K3/yxRRv/ogwx5i6veBP7U70fgZEadLUTSpIP9lN2lYrw2KZp7sxMYC8ZIeIah7mRN43U3cXNjjnE+BtX+5EjqiEi2FRWruY4pkjtaEQSgreI+emy9P7HtE5S095lPkr55L+LHwgmWTfuIBfDhGlC15Ynm3wSHr0ZLdNOfiyJ6oiHX+kDuYCOk9tcxlnt7DodCpPhPuHbk5E3HXtEYPBrZALyzVpcDSu5wLu2XmQ6B17y8YmQXofNsXdYjxmMyrUEwg5gYq59Pf7gyusM4faDUhU60KfFcrSK7ow6XnUC2Ux3EcYU8s2UOtxjcih3v8Z+4HYviLFkPa769adXoXbisLqf/fGPshiokj0rfHLJiM5Jy0ZLOYsZe9wVt3TtMvjVjIIElFHq+gCG7IdQtTgVNW/ugfH8v6hD67GC75qdWsuiAH2EhrqOCrEyJd3ABB/Fqfl1/evswnhtu2RkS7Bt1fT/AeZhYD+FeMsKJXlKLxkjBZXzZa0bZjc2jDHdZ7cmGE02LlS62qlly10Bqkj5pAw/W5v3bXzQOP9qKLw4vx6V022yvwpgxsVkpgHs667v
 ZrN58FG3
 PmFcTwpLQOovo+EIIT+h+uhwE81MlxkmZzHpX9hLpaqnJCbl+WJMXbJ+izGxhmeHBNW4LLVPq+D+aTm0PsHZODPbsQVSQWIoTU9rvN/LtyuwIq5p51B+5Pb3Ejx2S84v2ArEmZjODNRSO+ykUgXELd+uxPDwAWENIugUo60CNNQbJLYAUdYxrTFhf4EZZiL0S0VZmvtnxqqKZbAZM6zUghalh5JYQ62tmrvxpUaftF9zCZZozVOpdIfhwM2aP11MP08zfKoatXpK0OH3TSsQbKW4Cr7T++YqPHFfTovwaxinBHlIu37r5SMH3gqwus+MinciRa4vdmP+SjoLf+1qVpbRc1w89lSIphfZpvrm+q+LEeac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-07-08 at 09:31 +0100, Lorenzo Stoakes wrote:
> On Wed, Jul 08, 2026 at 10:10:33AM +0200, David Hildenbrand (Arm) wrote:
> > On 7/8/26 03:52, Aboorva Devarajan wrote:
> > > snapshot_page() reconstructs a folio from a struct page.=C2=A0 After =
copying
> > > the head and __page_1 it reads __page_2 whenever the folio has more t=
han
> > > one page:
> > >=20
> > > 	if (nr_pages > 1)
> > > 		memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
> > > 		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(struct page));
> > >=20
> > > __page_2 is the folio's third struct page, so it is part of the folio
> > > only for order >=3D 2 (nr_pages > 2).=C2=A0 For an order-1 folio (exa=
ctly two
> > > pages) __page_2 is not part of the folio at all, it is the struct pag=
e
> > > of the following pfn.
> > >=20
> > > When such an order-1 head sits in the last struct page slots of a
> > > populated section whose neighbouring section is absent (a memory hole=
),
> > > __page_2 falls into the next section's unpopulated vmemmap and the
> > > read oopses.
> > >=20
> > > Observed on a 22 TB ppc64le LPAR during DLPAR memory remove, on the p=
age
> > > isolation dump path:
> > >=20
> > > 	offline_pages -> start_isolate_page_range -> isolate_single_pagebloc=
k
> > > 	=C2=A0 -> set_migratetype_isolate -> dump_page -> __dump_page -> sna=
pshot_page
> > >=20
> > > 	NIP=C2=A0=C2=A0 =3D snapshot_page+264=C2=A0 (ld of __page_2)
> > > 	r4=C2=A0=C2=A0=C2=A0 =3D foliop =3D head =3D 0xc00c0005a03fff80
> > > 	DAR=C2=A0=C2=A0 =3D r4 + 0x88=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0xc00c0005=
a0400008=C2=A0=C2=A0 (unmapped)
> > > 	DSISR =3D 0x40000000=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (no translation)
> > >=20
> > > The faulting head was a free page that still carried PG_head with
> > > _nr_pages =3D=3D 2; its __page_2 is the first entry of the absent sec=
tion.
> > >=20
> > > It is also reproducible deterministically in a VM by placing an order=
-1
> > > folio in the last slots of a populated section adjacent to a hole
> > > (memmap=3DnnM$ssM) and calling dump_page() on it.
> > >=20
> > > Only read __page_2 for order >=3D 2 folios (nr_pages > 2).
> >=20
> > Hi!
> >=20
> > Can you shorten that a bit? It's rather trivial, really.
> >=20
> > "snapshot_page() currently reads __page_2 after checking nr_pages > 1, =
whereby
> > we really should only do so for nr_pages > 2. Let's fix that to avoid r=
eading
> > memmap that doesn't exist (e.g., vmemmap hole)
> >=20
> >=20
> > Observed on a 22 TB ppc64le LPAR during DLPAR memory remove ...
> > "
> >=20
> > >=20
> > > Fixes: 31a31da8a618 ("mm: move _pincount in folio to page[2] on 32bit=
")
> > > Cc: stable@vger.kernel.org=C2=A0# v6.15+
> > > Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> > > Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> > > ---
> > > =C2=A0mm/util.c | 8 +++++++-
> > > =C2=A01 file changed, 7 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/mm/util.c b/mm/util.c
> > > index af2c2103f0d95..b3d48a05e6d82 100644
> > > --- a/mm/util.c
> > > +++ b/mm/util.c
> > > @@ -1353,7 +1353,13 @@ void snapshot_page(struct page_snapshot *ps, c=
onst struct page *page)
> > > =C2=A0	if (ps->idx < MAX_FOLIO_NR_PAGES) {
> > > =C2=A0		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
> > > =C2=A0		nr_pages =3D folio_nr_pages(&ps->folio_snapshot);
> > > -		if (nr_pages > 1)
> > > +		/*
> > > +		 * __page_2 is the folio's third struct page and is part of the
> > > +		 * folio only for order >=3D 2 (nr_pages > 2).=C2=A0 For an order-=
1
> > > +		 * folio it is not part of the folio and may fall into an
> > > +		 * adjacent, possibly absent, section.
> > > +		 */
> >=20
> > No need for the comment, really, this is rather trivial.
> >=20
> > > +		if (nr_pages > 2)
> > > =C2=A0			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
> > > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(struct page));
> > > =C2=A0		set_ps_flags(ps, foliop, page);
> >=20
> >=20
> > With a condensed patch description and the comment dropped
> >=20
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> >=20
> > Thanks!
> >=20
> > --
> > Cheers,
> >=20
> > David
>=20
> Agree with everything David said :)
>=20
> Patch looks good with changes David suggested applied, so feel free to ad=
d my
> tag to v2 alongside David's:
>=20
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>=20
> Cheers, Lorenzo


Hi David, Lorenzo,

Thanks for the review.

I've incorporated the suggested changes in v2:
https://lore.kernel.org/all/20260708201954.686111-1-aboorvad@linux.ibm.com/

Regards,
Aboorva

