Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EF8CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 07:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ADBA8E001A; Tue, 19 Aug 2025 03:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E1F8E0002; Tue, 19 Aug 2025 03:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67D68E001A; Tue, 19 Aug 2025 03:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0DDC8E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:39:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5761A82DE4
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:39:43 +0000 (UTC)
X-FDA: 83792707446.05.5515987
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id 02D42180002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:39:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QkI5CVka;
	spf=pass (imf24.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755589181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fMT89F0BR3wH3h7MhslCxoheegXP+7FD4CxweXIXOI=;
	b=yE8jjxlC0PiYWAxZ/26uCsiWeFr6nuvZp9ljf4vezrQBlerlVeJNHd+fde1Xiz8qyqp/7P
	oqGZgyL1UURpTIrjdn2b1rbhNCu06I2HnpGPXkPFcOavyySUVtYyDfYlJnvLHO6ShAGuhd
	xy2aOOhqLyub7+Ra1B2p5TzMMUIWSzs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QkI5CVka;
	spf=pass (imf24.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755589181; a=rsa-sha256;
	cv=none;
	b=Gln78ODoMR8qAq3U7MFoMGIndS8yQcGWp4JSgzHN4gN6eFjtPZL05zV72zn9lpenmkz+hZ
	ENDGoW3VH06p53PJL1Zz31ERqps9JG1mck1XAaylLsxgSAv1YonmVTe9WBQHfJnc3rs0/n
	mczMxTpNB/+RCiM0/d58AkPxFXsBmKo=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57J5D69Y012840;
	Tue, 19 Aug 2025 07:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2fMT89
	F0BR3wH3h7MhslCxoheegXP+7FD4CxweXIXOI=; b=QkI5CVkawkaIOpfz9UseLj
	uKF8kQqQqrK7w3N9SfZWaTUd5jzsZhG59yVSKUEMMfNLiNMops4pUUsfTCgY1dd2
	xSprP7vP1GCZJmMcdWHNoB57M/GyNnTUbVErN06+U1yAySTtECc5abs7PqMT/3be
	i8tbQ3MROhcly+ygLlyHzLjI3F/4Ww0rIkETBjZQs1KpkBekvb49JvEtvfTmaKBl
	8bF7rXbKmLViCgcHrs8ApD9+hlh8lstCeRKIgfykUn+FuNZAcL/VRdYXeTfJh5Lr
	RniNOMdrRegLaq4uskvz2aBzQ+C/C0FzFNQdxQ/hPyL49tM8RMFyeJAbsOWryfpA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhn3w48c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 07:39:35 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57J7dZtZ015939;
	Tue, 19 Aug 2025 07:39:35 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhn3w488-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 07:39:35 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57J6Vx4j002213;
	Tue, 19 Aug 2025 07:39:34 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48k7130yx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 07:39:34 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57J7dWZD30540240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 07:39:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C0E020043;
	Tue, 19 Aug 2025 07:39:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89B1620040;
	Tue, 19 Aug 2025 07:39:22 +0000 (GMT)
Received: from aboo.ibm.com (unknown [9.150.10.135])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Aug 2025 07:39:22 +0000 (GMT)
Message-ID: <23fe7e2a5343090f387c15d70b95b13029f523e0.camel@linux.ibm.com>
Subject: Re: [Fixup PATCH] mm/selftests: Fix formattig in
 split_huge_page_test
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, shuah@kernel.org,
        pfalcato@suse.de, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        donettom@linux.ibm.com, ritesh.list@gmail.com
Date: Tue, 19 Aug 2025 13:09:20 +0530
In-Reply-To: <38734ae6-012d-4630-8bf3-efefb65f0d23@redhat.com>
References: <20250816040113.760010-5-aboorvad@linux.ibm.com>
	 <20250819041239.167537-1-aboorvad@linux.ibm.com>
	 <8142d36d-2a0e-476c-8250-1a69c1f92913@redhat.com>
	 <38734ae6-012d-4630-8bf3-efefb65f0d23@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kldq267UTVqJ9C8Sml23beZipPKunToR
X-Authority-Analysis: v=2.4 cv=L6wdQ/T8 c=1 sm=1 tr=0 ts=68a42a37 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=Usu2G-oJ_OItclc4WmIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: azXWxStmn-7-WbVHLx7lZgRm3YkxeGHa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAyNyBTYWx0ZWRfXxboAV/ekxxSU
 TyKCUHpeqzG8mRxw4KAj8bza9YhUDdi6AjptGmFrS3BvCvk+l0D4THv3A0hoxc4jfJyr+mRDfw3
 fO4MKWsM6YBYhWXNBlciRIz3jipyGhciwO7aqWu30i6Od1QwdTZa46BlJQ1mwBRKxybO+Q7gS9K
 Ifu+Jgdae4+OR4IH+Te7snGp/ULKKgq2a0X3rd0jele9PVofbv6tcyiwYC2zgtIzhNG2KII6Q0T
 UBTwubX6Q0YLhAqjYr9NE7Xh/4YEa+omCNO/5vMZmi/jilN8BwS47q6MFw4pKwrFKMgipIA1YL0
 9XzvCmKBYgYnSDsFRv031z7kl7sztTrTWC+W7F3hJ/DpYqaxlAbPN5qVawyD9mCUYDdbYCTBvv2
 +d02dbNk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508160027
X-Rspamd-Queue-Id: 02D42180002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: panzueasqf37e1f3jo3r1hfsi1zfqwco
X-HE-Tag: 1755589180-383686
X-HE-Meta: U2FsdGVkX1+8TFPeS+NpOyGQukcZBqw7utB7A7QyyF+e9BHKrFbYvSuMprBo7hXQxOSwW5eYWeFnlmSdxT7FNXx3emj/8xPcHOBYlPmV0XJG0w1HKbqclKipAZsPYt3ZlIn8532k+TTwP4Sh2tLUchkapXvVvzQkrcobP/oWrEw0iveytQR6btTaLOACRa2uAako4dm9iojMdOMcZtOBcmSQO9wm9TBbKMrdYJu0fIBgDMadi1hYQinl74m2A3kg+KRywv3vmeRt0FuaN76yofBWH0+CZWkgMWKOQ7DwENfXEqIERTAt5HHAdngWhSk2noJbB81ZiQN6tZrb8VNz484fd5c5MLviw6nBrx1VbWHK6ZHZ5xha2S6I5r/jjZ2WqFMll1b90CaZjSVkValCX1pO8iPfofBs/a7hoqUCS2D76NLZQoOhQmk+u5mdR61MjlcegtcJskjMhb6w3Oxxhpi9ZHM8O/M4a24azBa2PcmVd1/kSKPCnYrU0QQKkEQe69TBpmi7IKLeevcV9Tgd8iQjSdeoLBVPuZAqxziR1KAvQ5d5eLfOyWO8+om9Ou3XjVEQV/9Ur6b+4iF8d4FF/WGFMWVHmGKlM75B5aQ7kXgq1eCZ/GcJETlEzsIJn1Hw1kJ6HBAJ9d58siRv09lm6Qnbzhly6CAMEc2AOWQs6/so5XAGMC82+3UiWqtGRiq0jARBwUR9z0gMdHpwjRVhdPLy7kh1aBXR7QrE1MGib2x+Gj4DkzovGuOCK2fnbcOWPLpS+LTEDYmLVuUjkHJmtzNjPa03FzV+KlHxY5lJki0mFm9jXk8fbQ4cwCaEmtwcmwL+Lj2cqdxftszyQf+w2dNeXMOola2dU33quaNt5OhryNW0xAJR8rCXn6Su2comfK3CoEKhWTRkW365k6J13Ewndv/QBqXNr9Q/TBtHzUuQfEBvwuWMcjvybofI1OD6C0HL5XZY8/LC74/zJcm
 4amiveHe
 n+YH+0ZqyqEWODJxidRXF+pL/yBzfVmU2XAaLRAFCpPcAuQE6IgJ9S3j65sEXBnEo92QmM9HxPXyhmqXQ4DWp4gCyVM2MPIuKKMM9D4HVDYnXRStfCX0l4k6+TXOEHp4iahzV860IpymLMgr1uMFjwS8mRkMwjKXWfAyEr/TeIcUY011H5OLN4xUfBafzKR8NcYB5fBJs4xxCMRK1mhluH6d/EXf8Qvw6IFQ+0Pf6XbksFAvC/TJtbDnp1DT3S1u19oplfR0jRaqvnw86VKTm1sSlSXa7vm8wk3mydpuWELSeKSGWX4XnoezGPRXrr9NjPe7UN1SSlAFVAUT6Tgo2H8IhIqUR/CKs9Gv+qOT6L7qrS+5wj7NawYTnhejBJDCvdDTeLMf0v+srwi5w2qYSHTqQSmNbAgTTwhhNcE4x4cK7qLHXmVd8jrGzWQBFNB6H/XACbJz6B6HmCO2y7B0R7w6WvPw+hdCO3RHosQz8Ei/K5qudNLZNDw5H6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2025-08-19 at 09:28 +0200, David Hildenbrand wrote:
> On 19.08.25 09:25, David Hildenbrand wrote:
> > On 19.08.25 06:12, Aboorva Devarajan wrote:
> > > Removed an extra space in split_huge_page_test that was introduced
> > > by commit 4b76e221794b ("mm/selftests: fix split_huge_page_test
> > > failure on systems with 64KB page size").
> > >=20
> > > Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> > > ---
> > > =C2=A0=C2=A0 tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
> > > =C2=A0=C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tool=
s/testing/selftests/mm/split_huge_page_test.c
> > > index 54e86f00aabc..faf7e1f88743 100644
> > > --- a/tools/testing/selftests/mm/split_huge_page_test.c
> > > +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> > > @@ -544,7 +544,7 @@ int main(int argc, char **argv)
> > > =C2=A0=C2=A0=C2=A0		ksft_exit_fail_msg("Reading PMD pagesize failed\n=
");
> > > =C2=A0=C2=A0=20
> > > =C2=A0=C2=A0=C2=A0	nr_pages =3D pmd_pagesize / pagesize;
> > > -	max_order =3D=C2=A0 sz2ord(pmd_pagesize, pagesize);
> > > +	max_order =3D sz2ord(pmd_pagesize, pagesize);
> > > =C2=A0=C2=A0=C2=A0	tests =3D 2 + (max_order - 1) + (2 * max_order) + =
(max_order - 1) * 4 + 2;
> > > =C2=A0=C2=A0=C2=A0	ksft_set_plan(tests);
> > > =C2=A0=C2=A0=20
> >=20
> > Please just comment next time one the respective patch as review commen=
t.
> >=20
>=20
> To clarify what I mean is something like this:
>=20
> https://lkml.kernel.org/r/3dca2de4-9a6a-4efe-a86c-83f9509831fc@gmail.com
>=20
> Gives more context when the subject directly highlights to which patch=
=20
> you are replying.

Hi David,

Thanks for pointing this out. I=E2=80=99ll make sure to follow this.

Regards,
Aboorva

