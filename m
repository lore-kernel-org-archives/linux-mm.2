Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BACCA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 07:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCEC18E0005; Tue, 19 Aug 2025 03:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57E48E0002; Tue, 19 Aug 2025 03:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F4E8E0005; Tue, 19 Aug 2025 03:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB61A8E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:57:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AAFC1A02B9
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:57:43 +0000 (UTC)
X-FDA: 83792752806.02.7D036C6
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id CE18C20002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:57:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Kq0pIQv9;
	spf=pass (imf13.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755590261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkLhLr/fJDzFBos0ozmWujsjFAp3g6noJWKQ4OpXxSI=;
	b=BiuYVLSzulpiVCYAJuLBKenMLJKZyYQobIhfKBkW/b29sbXkrdSHoLLDjdd/0xdh38PtuV
	UntQnQsw5MvN22JAadgSrxOxJeIs714HpIaSbl4FJZ1Faf8nQRxTHRDeeM2SMft+wByiK3
	q+vQuZrq1PYDz+ztzmhVy8bGsJsJQu0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Kq0pIQv9;
	spf=pass (imf13.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755590261; a=rsa-sha256;
	cv=none;
	b=d5jkMpQlw66neLMyaBGX3J5fUp9P+vRclnveKTpFslCopiauaaaOUD0gbg4WO5+THNq0vb
	h6OQ/hKXIEDShr29MAeJQO5Nngh7V8TvkGjqbHzGbF3f1jxQOFK3XMaVa8gxMw3o1f4Etd
	t74FD+hMMgfUu1ThH8j+v7llnrsM/W0=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IKJOo4016893;
	Tue, 19 Aug 2025 07:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=lkLhLr
	/fJDzFBos0ozmWujsjFAp3g6noJWKQ4OpXxSI=; b=Kq0pIQv94uxnDw/EVbFwpN
	A3j+9lPv3YZCA5NB9xANZXopiG55w4fnsNBMqrO42MWqBv6zdlOhQSB6D1m3QXLd
	j5+p2AcjRfxxOP62Lz6ulrxNhm4Lwv9cN2nGWY2xuVnI9Q4Mrhgo5JrMwjv5GOJ3
	j5nuYhUS5poK8ybU1frD+J0t49DIFBAj3NBmBVDrOercvoRHqBRCOSqZgwwGHrl6
	n8bFwppUifzrC9+Pk0/BYeDfN86VdeyO1XkCmidQBk7ENsK2wqNtnzSpR27imo2M
	zKDB/HVdvQniQrAD6pvsvvV/N2gD3Lg8BaHw2eex3pBSreRK3kxqlUW+ZIf7+9pw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48k60g2f5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 07:57:35 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57J7V2ad005076;
	Tue, 19 Aug 2025 07:57:34 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48k60g2f5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 07:57:34 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57J6WVmF002381;
	Tue, 19 Aug 2025 07:57:33 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48k71311a2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 07:57:33 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57J7vVNY51970316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 07:57:32 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA9AB20043;
	Tue, 19 Aug 2025 07:57:31 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E141420040;
	Tue, 19 Aug 2025 07:57:21 +0000 (GMT)
Received: from aboo.ibm.com (unknown [9.150.8.232])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Aug 2025 07:57:21 +0000 (GMT)
Message-ID: <588d7bc1af412052da01ada1e316dc3452e35435.camel@linux.ibm.com>
Subject: Re: [PATCH v4 4/7] mm/selftests: Fix split_huge_page_test failure
 on systems with 64KB page size
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, shuah@kernel.org,
        pfalcato@suse.de, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        donettom@linux.ibm.com, ritesh.list@gmail.com
Date: Tue, 19 Aug 2025 13:27:19 +0530
In-Reply-To: <20250816143129.u2rdwpwvfhsdptvx@master>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
	 <20250816040113.760010-5-aboorvad@linux.ibm.com>
	 <20250816143129.u2rdwpwvfhsdptvx@master>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Xxo-rqbc7cebc1fPmjZ5ElzwCajbrHcg
X-Authority-Analysis: v=2.4 cv=coObk04i c=1 sm=1 tr=0 ts=68a42e6f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=7CQSdrXTAAAA:8 a=Ikd4Dj_1AAAA:8 a=pGLkceISAAAA:8 a=tHhU2u7-ekzRu8kCQfcA:9
 a=QEXdDO2ut3YA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: oTFYm-c-N6_cjxhC8XgowrRG4DRYlYYk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE3MDAxNiBTYWx0ZWRfX67xGcB4BeSH8
 ulN8vqwFzYGzs6y1LNSMP/C7lfl3OLCfi//7f+YmKUot8z40fD4S8avAa0B8vmyJMIH8R0nDm2/
 6qG7Vx5lr9bEfoK1Iz9UyiAyGDIlKhFyaOyuUTTbq2zpE5YjvEflIW4VHK6gMYpiXVTcgTZKqtu
 LomJoBCnKMG1rPYDMaNG6hAAYbedGJ9WK2tfVkFdS3ID4tSaIOmWQtU8VAplxV8EpktvNBqTxgY
 4Z72ecj+PFZi4ZTJr7m5wly0c724RS2PMlpthVoUYyzKP06tywNEVG+mb5nmfVydNFy1XOWi0Nv
 PmeI2wnnut/LuotJYkau1yVhnUHAJGLlAVCqne+HOBtcmKfcmAas2dmuJI19jjm7dyVCETmrCVO
 dmEP5L6N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 adultscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508170016
X-Stat-Signature: jh9ajxgwz8ucs8xqzkzuyr8uhmeuz566
X-Rspam-User: 
X-Rspamd-Queue-Id: CE18C20002
X-Rspamd-Server: rspam01
X-HE-Tag: 1755590260-645560
X-HE-Meta: U2FsdGVkX18jDOtUuii6og3TATtqx1bD1JbP1qWc3rhE2z7nWMZofa38HB/qXv/uiqqjEIoQgcu0ituj+kJKiLCqQj+hmKmRLx0p31vHj2EcEbBcf/vxchABYkMWBYDQS2V3RDSO3/oSpWh+Kuaavz9SiYgwjJuqtNhLcxqtGhHZ9fRU/DbboHYqLGJAyTfSCRXIDpSW2+9OHxgNpfXmp78bZ2tqBOjsVcl3r/+1UG7znMymU21OILUwz6mSGn+smXdIztkQEznguRX1PaORC82qY3IE+sCAzTBhGy64zbfnTGTneiGZPDYZ9/QocWbFnUMVaCj2f7XM0Tqf6owXGwG8k+Mw8rrz2Gge4EQPkHyIZ4pXDPWDEiAmDbO3vhvItorh2oFJIzQz9Du47IC3J5FpAl0zbuCjyy1edEnCw5VA42rEfp817oDwIDMYoyg1LvZL9JQ9HTECgK9UMvTYM3OtAJpSDVpm1NISrPierRS3dRwI5K2+7rQ1zqv/fht0c1C7A/klhN0orgO42US3AlfZa1+ijN2xLo5JQGjJfspLb2p25WXqSCzBOxp9g6RiieU3iUm4S4uQkmowjH64hGjVAn3w+TqQLCgKUqgmZV2jBdIZrZy8HDJXoD/wThVR71DZX/jnKLV2DxOhV7/QNVoGS1b41bjClbvrhVwE3M2LT0T6YzKh2yNp4E+1xytQKiYBdeEm8KtqWBHBfT1hWVmmKJaA5Y5/We2fx96jUe1DI8eN8wj/ihohy2tLq0zinBVYtGXDuyLkZSC0/R6kbOKDYfSpxGRvHxhAFMP8SY1NeMA1J0YmY5aveNmC5YWIRdpx9GucsecD1lfc+t2UP2nXuZz74S02X1JKp1PC9+2rDvKjsvadM/1Xw8YG06b2oAZYoYXvFXrqkVAyAu0ACmidkF639iUEVc3ZEFBTH23w8BuR31+VMkG5hm3rHi9JJbiEHlM2LdAOk9l06Lb
 eJuyR7Gg
 shdp0vPEV3uKTfvSW+uqHc/SijKz3F28kNyVbZ/pBDTqoPtZrjQof3RZRW30xKMq2e3AD7QC6qYnjtfdTkhNj0umxDcUbx9zmSdICHCJgG3/P5E9S7A7PobDDlT+iHHbAyeO6FDePYRQpK2R2AIC8V7tihqnf7vlcUnbQQUevCFFN2ksn6WZONLm93noLmBs7M6Te8cfEnCCH6r5g8dqVb96ikQ7oGRZLiNk+xUqKQrdshg/Uxln/XfNUdAZ4UhreqpWzdv++LICj5Mcy3e8/SvjhHkMYAcu+MmZjpK+OUdHTx8bEhFqm6AVMhPq/JreSuVPhaZ3rcFPF2QMAN2VEW4w5OifugplQUQfUvbdVHjZEKzxeWyPOW5OfVPPzXtj1zZ87JRYiFr9Pgtmz2KYysThBmO1WJfuVZCwF/U7z6YH9bhJnvnJkadITWOTP0Tnxzfifcxaa5VRho1QqTHSCpxBSBSM7ocjxz2XWVYPgAkq42Fh61opPPYggUvY8/LE8yYGMoOQ0b5lOcxW5hBG+a7vD+BhLH//692mOi1O9x0mat7Ip9Pcn91FzGWeIa/6x5H7RPbeLoerqnAY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2025-08-16 at 14:31 +0000, Wei Yang wrote:
> On Sat, Aug 16, 2025 at 09:31:10AM +0530, Aboorva Devarajan wrote:
> > From: Donet Tom <donettom@linux.ibm.com>
> >=20
> > The split_huge_page_test fails on systems with a 64KB base page
> > size.
> > This is because the order of a 2MB huge page is different:
> >=20
> > On 64KB systems, the order is 5.
> >=20
> > On 4KB systems, it's 9.
> >=20
> > The test currently assumes a maximum huge page order of 9, which is
> > only
> > valid for 4KB base page systems. On systems with 64KB pages,
> > attempting
> > to split huge pages beyond their actual order (5) causes the test
> > to fail.
> >=20
> > In this patch, we calculate the huge page order based on the
> > system's base
> > page size. With this change, the tests now run successfully on both
> > 64KB
> > and 4KB page size systems.
> >=20
> > Fixes: fa6c02315f745 ("mm: huge_memory: a new debugfs interface for
> > splitting THP tests")
> > Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> > Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>=20
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>=20
> Nit below:
>=20
> > ---
> > tools/testing/selftests/mm/cow.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 -----
> > .../selftests/mm/split_huge_page_test.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 22 ++++++++++++----
> > ---
> > tools/testing/selftests/mm/uffd-wp-mremap.c=C2=A0=C2=A0 |=C2=A0 5 -----
> > tools/testing/selftests/mm/vm_util.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 +++++
> > 4 files changed, 19 insertions(+), 18 deletions(-)
> >=20
> > diff --git a/tools/testing/selftests/mm/cow.c
> > b/tools/testing/selftests/mm/cow.c
> > index 90ee5779662f..e742d9313798 100644
> > --- a/tools/testing/selftests/mm/cow.c
> > +++ b/tools/testing/selftests/mm/cow.c
> > @@ -41,11 +41,6 @@ static size_t hugetlbsizes[10];
> > static int gup_fd;
> > static bool has_huge_zeropage;
> >=20
> > -static int sz2ord(size_t size)
> > -{
> > -	return __builtin_ctzll(size / pagesize);
> > -}
> > -
> > static int detect_thp_sizes(size_t sizes[], int max)
> > {
> > 	int count =3D 0;
> > diff --git a/tools/testing/selftests/mm/split_huge_page_test.c
> > b/tools/testing/selftests/mm/split_huge_page_test.c
> > index eadbeb820d71..7cbeaebc9d71 100644
> > --- a/tools/testing/selftests/mm/split_huge_page_test.c
> > +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> > @@ -523,6 +523,9 @@ int main(int argc, char **argv)
> > 	const char *fs_loc;
> > 	bool created_tmp;
> > 	int offset;
> > +	unsigned int max_order;
> > +	unsigned int nr_pages;
> > +	unsigned int tests;
> >=20
> > 	ksft_print_header();
> >=20
> > @@ -534,35 +537,38 @@ int main(int argc, char **argv)
> > 	if (argc > 1)
> > 		optional_xfs_path =3D argv[1];
> >=20
> > -	ksft_set_plan(1+8+1+9+9+8*4+2);
> > -
> > 	pagesize =3D getpagesize();
> > 	pageshift =3D ffs(pagesize) - 1;
> > 	pmd_pagesize =3D read_pmd_pagesize();
> > 	if (!pmd_pagesize)
> > 		ksft_exit_fail_msg("Reading PMD pagesize
> > failed\n");
> >=20
> > +	nr_pages =3D pmd_pagesize / pagesize;
> > +	max_order =3D=C2=A0 sz2ord(pmd_pagesize);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
> 		=C2=A0=C2=A0=C2=A0 extra space here

Hi Wei,

Thanks for the review. I=E2=80=99ve sent a fixup patch for this:
https://lore.kernel.org/all/20250819041239.167537-1-aboorvad@linux.ibm.com/

Andrew,=C2=A0

Could you please apply the above fixup patch?

Regards,
Aboorva

>=20
> > +	tests =3D 2 + (max_order - 1) + (2 * max_order) + (max_order
> > - 1) * 4 + 2;
> > +	ksft_set_plan(tests);
> > +
> > 	fd_size =3D 2 * pmd_pagesize;
> >=20
> > 	split_pmd_zero_pages();
> >=20

