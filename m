Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39677CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 03:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6E676B0088; Tue, 23 Jun 2026 23:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20706B008A; Tue, 23 Jun 2026 23:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9616B008C; Tue, 23 Jun 2026 23:37:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95B9A6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:37:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9FA6C10F2
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 03:37:17 +0000 (UTC)
X-FDA: 84913395714.24.A68E989
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7A449180006
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 03:37:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=noeC84Wc;
	spf=pass (imf06.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782272235;
	b=eupLP4pigA1cvAYvUKSn4WRjg8glSWK8058SrVV5iIGEQJLyg94Ip4hokA6iTIGQ8XN8wH
	s2z96ylhfwl6+m3t9yu9KoVSkvA9lPK2y4GoijipXxcZE1YMQZM3nrMGk90fuRdozYhuV8
	xqBta2VswivUggXJg9krw2813WjrDkg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782272235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63Sc0l5i/6qElBY5ztCt9gpTg0pOkkt4ErSNCdlGjKU=;
	b=qBAAsV36lPAovQumnY6kxM1WdvuGezpDWoqn8JLysodEEWT4y5jw1YMLroGUKGBqekBTQn
	CgjXr1h3cm3PrhaooFdCRMJWBOtubmKb9q/MpP9nEmCufVMrttHrR6GN34dmH1FHI44Bb2
	/fnDy6gG2ngkZHRLNque9sw6+E6KVr4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=noeC84Wc;
	spf=pass (imf06.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65O1mHq43795541;
	Wed, 24 Jun 2026 03:34:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=63Sc0l
	5i/6qElBY5ztCt9gpTg0pOkkt4ErSNCdlGjKU=; b=noeC84Wc/ABy8GjePXbent
	UxmyEw53aFlLYsodx70ePxdZ+T1cnFjpCBmB/DAII4kHbePE12tV9Ne9s2I3ZcOn
	tbGv4i/fvW7UnbYq5JrWdyHMqi6WE+yNU+g7yMDuMJwF0I25/2SqQKq0EsnbLZ67
	bz41BrH4o2y3jAOsNXxV00oawBXW3bmekESOnSDb/cJaIvikp/ffsCinv2PPxf5m
	CF+30skTutpUn4OMXwbb4icjtHtHJDwivA9dkOhP5vwE5rL+QajfbO6rQY42UeFg
	bq+Uu37xE0JFQqjUHa07OGBkiRlNxmjw1qia8Bw+V5INoDGxuPZZ417YjAuxvRLw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjc3j57b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jun 2026 03:34:25 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65O3JhWS011946;
	Wed, 24 Jun 2026 03:34:24 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ex6phek39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jun 2026 03:34:23 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65O3YJiS43516404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jun 2026 03:34:20 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C72B520043;
	Wed, 24 Jun 2026 03:34:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 88F0020040;
	Wed, 24 Jun 2026 03:34:14 +0000 (GMT)
Received: from aboo.ibm.com (unknown [9.39.19.145])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Jun 2026 03:34:14 +0000 (GMT)
Message-ID: <67f6be911aba36393327a9e88285e2237d3e6032.camel@linux.ibm.com>
Subject: Re: [PATCH v3 1/3] selftests/mm: allow PUD-level entries in
 compound testcase of hmm tests
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Jason
 Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        David
 Hildenbrand <david@kernel.org>,
        Lorenzo Stoakes	 <ljs@kernel.org>,
        "Liam R
 . Howlett" <liam@infradead.org>,
        Vlastimil Babka	 <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan	 <surenb@google.com>,
        Michal
 Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
        Ralph Campbell
 <rcampbell@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Alistair
 Popple	 <apopple@nvidia.com>,
        Alex Sierra <alex.sierra@amd.com>,
        Matthew
 Wilcox	 <willy@infradead.org>,
        Sayali Patil <sayalip@linux.ibm.com>, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, aboorvad@linux.ibm.com
Date: Wed, 24 Jun 2026 09:04:13 +0530
In-Reply-To: <aivB1jLODH1W_0yt@parvat>
References: <20260611034102.1030738-1-aboorvad@linux.ibm.com>
	 <20260611034102.1030738-2-aboorvad@linux.ibm.com> <aivB1jLODH1W_0yt@parvat>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=X4Ni7mTe c=1 sm=1 tr=0 ts=6a3b5041 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=Wyop5lsuorlMe83hQoQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI0MDAyNSBTYWx0ZWRfX9RgGLbA9Dccc
 f5/iif8qjlwElA8ROthnkHNcGOKruIvI10EeK1pZK72U+Tjz4DOHdR7Z8u4O4fGVMeLKX1DznRy
 RWAKqqdjDJ77u0tOM5zUPYxJLMM5wNg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI0MDAyNSBTYWx0ZWRfX02bQh1+jYxF+
 AAi41vXhMpXNsp9c/J79reJTKeHck2tnvEIOdQ3a3Rd0CIfKxTkWX/jXyx1p34DmeoOr9zY2KXm
 LG9OOVjt66GvCZbu6zCeWmF0GzmphQ1cW2QDkWRnrnHd/FYjGV3LeMakSjbHSKho5QMwja8oU/Q
 J3Bh8lzvCB5DUOF93CErEiHQZuql1jAqERXyobm1YUQaoljDFfcyxk91Stn9CMCzB+pqEJ6AiX8
 LoLRwWNz6spcGt71mhls7NLFjS9JCN4m9BcXL3M7U4BhSVMB16AgDFgwUIEQWRaVZOr0xGz69H5
 7VND1MSbdQupXP7e1E0c9L17G0WsRDCj70pzYisjxT5nWQ+1L8Mi+SBmxJD1i4Gg8q0nA0KhHTO
 ob9lOUpI66ulmyB9OaDN50jPlbkqXg==
X-Proofpoint-ORIG-GUID: pXqvllcblYHJ-VIoONnVIg4_ikWuQb4P
X-Proofpoint-GUID: zwwj86c6l4sSSUImOFuNQTatUl24CtpG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-24_01,2026-06-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc=
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.22.0-2606150000 definitions=main-2606240025
X-Stat-Signature: 1gkn46j9hgptam58ihzjdzw37jrxzewp
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A449180006
X-Rspamd-Server: rspam02
X-HE-Tag: 1782272235-119062
X-HE-Meta: U2FsdGVkX18sxTNSQOSI2KP0YrXY1IEen6euiCFIekdkdwX7V0M2xcgi2RAP2gj6CpsaEUEzHVOTG1P/v+2eeTZDnGqf9/QjixiLj2nAlhVAFq82QnLej3z6B5cG/DEzcdCa34/uPS0pnjI7fAhcGyRViGAIr96w70+NynPo+U1wbAPpc/MgISEAb1dlohmyGV51P1RnZFH8HMmxvqkUU1xe2v8/au5VjZFopAV1RJ32JMVoLVKXZgKjv9vJR2pTO8YIbLI4lL3hO3HoKES1072wVQ8snUtroydORxY5d5I/FexGQQQ3wFmBeoTBMKsbC94FqtP5n6Y/xWBuUbWmNiLlFCqSqh5X4e5OLUaiqdwxHHKPnaQ2gWk9naLrfxJX0SdryuJmKJo1fNzWimXm/3X6ayRLQYAGSG7rXElTTblvdNEu//FoF4f/ok2lbBSIw5oIgrX0hHPZF+Xbg2aGHfQ9PXGMg3QDBX/6HIG4nYl5ngtMQsbX6shhzqxLI7IoXI0XOCZMCNNZOQztIoZ6qBmVlprjCFL7jEvfCpi2mUdqhMNwqHo4jlXN8tXNT2BSklTge09g1rWILJkDTKJe9mzwC0IVaFjCfQcHHeWSYfMu2/MUUFUxwTjp4J7PZ7N+1OTd6uf61ZJyrAi/mRaO6MHKFTKOH4bssDnZ5AX/frCuWKXC2HbFb4ibh8wxiB9IwBAR6lbJi4k6+cOrJcMsAW3hFx1BJ7gAxphEi0mlRvAy+ZhS/U4PiOtrt311icejJVY8U2UWQ7D5YwEK3Im+wCRpRNRQVI9fvIWddcl9CyKpJKeAnuPuVGoznT+ndmRimhXsmjrCY4Ud6nMtvovTCSr51VFp6GTsNP70YFUaGJ5XRBlcyqeKlOTQt4+RD8ct27YHp3r2loEPEd1iRI8MKqEICjjGbkZjd3afuJ2aGWLFIrtEYiegU+/cL59sSYhOkTeZhZ1gi7e22Q/eM1c
 n/+ikmQ1
 q5Bz3t8pU/dCoiiQ6d14AsLYrzdVQbNkcW/iILtrJKAPNjOaYPuapgVJCxptg1yLTZDtuk4zR5H5K/my1O/58SEyv7YYsEJQ5h5KM/Fg8813e5Fk1XtRH/PiQtiKrpOEJRmStw6X3t1gn8Cm6OlE5SVDu70f4+z+EQCr/zlnIB0bngP7pIsGWCZBSkddG9GE15t6VnfNmo9D8oDu03P+MNdawbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-06-15 at 10:16 +1000, Balbir Singh wrote:
> On Thu, Jun 11, 2026 at 09:11:00AM +0530, Aboorva Devarajan wrote:
> > From: Sayali Patil <sayalip@linux.ibm.com>
> >=20
> > The HMM compound testcase currently assumes only PMD-level mappings and
> > fails on systems where default_hugepagesz=3D1G is set, because the regi=
on
> > is then reported by the device at PUD level.
> >=20
> > Determine the mapping level (PMD or PUD) the device reports for the fir=
st
> > page of the range and require every page to match that level exactly vi=
a
> > ASSERT_EQ(). This accepts PUD-level mappings while preserving the
> > expected/observed protection values printed on failure, and rejects a
> > fragmented mapping that mixes PMD- and PUD-level entries within the sam=
e
> > range (which a per-page OR check would have let pass).
> >=20
>=20
> PUD is not supported with zone device private folios, the fix should
> be really around default_huge_page_size(), using the default pmd size.
>=20
> Balbir


Thanks Balbir for the review.

IIUC, PUD not-supported restriction applies to the migration path
(device-private folios top out at PMD), which the migrate_* tests cover but=
 compound
is purely a snapshot of the CPU page tables, where a 1G hugetlb page can
shows up at PUD. I guess HMM_DMIRROR_PROT_PUD was in fact added in e478425b=
ec93
(the same commit this patch Fixes:) to express PUD-sized snapshot entries,
so handling it here is using the bit for its original purpose. I verified t=
he v3 patch
passes on a default_hugepagesz=3D1G boot (m[i] =3D=3D WRITE|PUD), and fails=
 without it.

But if you'd still prefer to keep this test-case strictly PMD-only, please =
let us know.

Regards,
Aboorva

