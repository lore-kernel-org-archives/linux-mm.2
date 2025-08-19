Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2A8CA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 01:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EA566B00C2; Mon, 18 Aug 2025 21:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2A06B00C3; Mon, 18 Aug 2025 21:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1B76B00C4; Mon, 18 Aug 2025 21:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65A716B00C2
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 21:49:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13852B702F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 01:49:20 +0000 (UTC)
X-FDA: 83791824480.21.E2A0EDC
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id A3903140002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 01:49:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=M0qRF4pt;
	spf=pass (imf23.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755568157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFSwuQq29eL5ikK1atvaaM8p+ErOLs3QagywIH+SJGg=;
	b=3YX5s4cWoy0owAc2WZZ5lGDNfMya95jwAMEIueCZRpoEtxU6uyqQ43/sLZsh4oRg8sK8vB
	htWtPyt6qsXCv/2ZUv/k/NicQBdd2lJs3MKBs651VBO/Ybno+owFqb5BvVu5dbEnUofp0f
	Jccz5mZLWrACJ2omvsA14BGd1oEYjZk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=M0qRF4pt;
	spf=pass (imf23.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755568157; a=rsa-sha256;
	cv=none;
	b=Oc6qmyI5GfpAfnz5QpRnkcF74cSnjoOwJPL1TMUDBq22IJgf6UobYiL30HkMmOcZmyFVbj
	OktfBfaZuWtV7xC0TwRWPD5Bewhyw+Ti2WKLs6lAvSwCSP9TQlnK2ajXZcC2a7LZDSnjNT
	2p6FYH76t1jxvyjC9SJj9hsXNptXofM=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57J11Kdi008759;
	Tue, 19 Aug 2025 01:49:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=mFSwuQ
	q29eL5ikK1atvaaM8p+ErOLs3QagywIH+SJGg=; b=M0qRF4pt/gbcJ3OUhEMZWF
	xAIg3zSAzWwLmksP0WYewuE2mmGWH+RHxRS9FO7RNyYdCEDn3QUUQQz76vKHqwMm
	dSXeO+f5002/G4tN7TYmsQOpATD7YrNGG3oAiNzseXRnkYJT7vcMTwd3mUyTjOPx
	qNxfdlJs+JaU3heFmQOkE+E4WhxrnwxN3E5yiOPyTYirkSbgoVhp+taR0Wjuj2aa
	i0qQUXAdXqzbQd+1Giqz07Qk+aCnLGaEuRe8rDolK/cm2pk8650wF1iXUS+R5wl1
	w8V+01pHh3Haa+421FdW0ymEFeIhO6oT7iCq0ZOGJiYpMwpVyr9h/o/mGrzxqjKg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jge3v2qc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 01:49:11 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57J1nAOs026453;
	Tue, 19 Aug 2025 01:49:10 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jge3v2qa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 01:49:10 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57J10VRA002762;
	Tue, 19 Aug 2025 01:49:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 48k6hm82kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 01:49:09 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57J1n7NJ21954836
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 01:49:08 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D88562004B;
	Tue, 19 Aug 2025 01:49:07 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 06C2320040;
	Tue, 19 Aug 2025 01:48:58 +0000 (GMT)
Received: from aboo.ibm.com (unknown [9.150.8.12])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Aug 2025 01:48:57 +0000 (GMT)
Message-ID: <091c6181643ca4ce7c124fd2380934be6707cbbb.camel@linux.ibm.com>
Subject: Re: [PATCH v4 5/7] selftests/mm: fix child process exit codes in
 ksm_functional_tests
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com
Date: Tue, 19 Aug 2025 07:18:55 +0530
In-Reply-To: <20250816144322.nh7qwwfiuhnjp76g@master>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
		 <20250816040113.760010-6-aboorvad@linux.ibm.com>
		 <20250816144322.nh7qwwfiuhnjp76g@master>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=FcM3xI+6 c=1 sm=1 tr=0 ts=68a3d817 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=pGLkceISAAAA:8 a=yAwLp-9Eto-ypyUmQMwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: yj57Oo9K3_U8fOGNUi5FqhSRHEcwChgs
X-Proofpoint-ORIG-GUID: 8UwoA57xrsbN89v7L5QtWBCKV0vJwOi7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAxMSBTYWx0ZWRfXwLuo5gQIuJdF
 wtIhmfJszCl1cj/LrNH7Xfqk6n5BGbxktCpnW7TRZ/sBm357uaqgneMHFa6lI30pyCwDbsufA5n
 biTDFgNJPQEdseYwxrVJty+0pHQvY50bGoJXuxX/IuYQ3W95La7/+i1/FoXZ4KAokSskcIC1KSp
 +YOBO0gdxmrQqB27gmWT1gsutnuwYArFX4zQ9b41/fumTveuUV3ZCwOz9CTmlcgDGSL+tMpNCAx
 91MNbY+Nl505ZocBVGw0garT3HrKhOcEc/JJvI58qQ45nMf6a+9fUFiEeD9wuNj7BirTprPe+pP
 eSSwsWOSJ7FpnzYekQ+Wcq4bUGQoEWTeqcgy8bBKd18C+wxJKj8X2NISXrIZo7bkf4BbU8a22iw
 nYxq/ZK3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 adultscore=0
 phishscore=0 clxscore=1015 impostorscore=0 spamscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508160011
X-Rspamd-Queue-Id: A3903140002
X-Rspam-User: 
X-Stat-Signature: zy1gmhpewgq1d9g5eujbjy41qhwqgw1w
X-Rspamd-Server: rspam09
X-HE-Tag: 1755568157-463181
X-HE-Meta: U2FsdGVkX19JMVoNitYT5a5nSQPDaJrwrk1HEyPt65HiOSjKeRprBeqPfHHa+r/NZxMa8Yv+QLnFSzWAsdrX+ub7wt2+WAZPQEf/Iy/fpxNCaYXI+LWkuXRxJpH8v4scPQkEAJh8aLl4Rz9RMi1HuqugYLqi3W4Kgil5jlA+btoxoliQRrIGsOBKO2t11VIXSn17vfQp024vGYLSKNLMLvHnlGqEu+jsKSLEdBn3Q1fN/N9GjD2QNJIEL9iR1+JyU/LWjMOqNfnLZL1r3jV7Ch8KPfyrnf46zjCImYVzon+WHXzr2mkmlLeCKO+KfrGuB+UpUfmKaI4xW6zZ1EwIB2D0sX/ZYgrI4ZsBYCXhbuUsNSsuy85QoxYFgwFIcJ500Lzu2/eFOGx5WxyEU70+m6U747OIsyN4T5O4DCtNqScyqvR9z6bgAQ++dncJVnjrHKn+PeGDV9sQARQ+hxKtgl6f8hKmHVS6kxMF1DsInuAFbvJo3KMNoY1hoKxvQrN1YHrsOjTlwApgXLuC23N6XjcneADsxryNyVLjK+r0FOfFOPJzTEE/kVRjw81aciI74mcbkU0ML7sc+0MIGN70+fTWfpdGTOFzFoCEmXWElIjvi4otXXbkmmNRPpUn9adEXI2q4blKe0EJBt4iB2MBBi6QkdmBROW0aPRkflYc32Kb7+2JbOqYwyU/UWQMApFml3Dmas3YXomQnyCwCkxU1/LoVvQ/0y4YRWimhhfSrW2L0ktdew6OALhwHO+piO4BHR5di1fki7GnNxaI6rs/myQpCJOlf0jkdSRHRK8qKvEwZWrRomxPBvGs9Macg/q3FXIVYM+XiCsmkNUIDBlGdXLz2JyjU8y+emxYOljlBytGXLyFnbfl0gGD/6hJP5sy5SRAiGiguLS57hSIfQn/r2fQC7vJz+qKYPbdyGYNggxm7LoQD5avpArvZUfflvsnR5iotrMomrDPQcky8OQ
 64U6lZ9w
 g6lC8+onR3hhbuxA3+JoxGhVpttaLWPOOOFBxXyUK/2qLA0z3xGl2TNBUv1SWplrRdTgtsAjhzyZ7+cFYayJewU1qgMuHNTqS26LKcmH96PNVoEnZWVZlUfo6FJfd+YNApbTD8D8x+KkYjnmfy1Qbc+xI1M1QuQ9wv0dKHNvxG8mFPpQwDpz8ktwi6ITBUCUMC2wO/NSnDPN6L769AG+LtiWw/dmn4MpmdgqiIX/e+qGAmGYWEkVn+rLus4YzdRIR5UstisVhvO15Kvumy0dpVcmMsIIdaRTVNH42F20qIiwx3dA6B3wnbnS2RWigRWtsYxeLNXqprjyN0DNLIrXunTljx6/gy2o2ppVWjTFvrVpfvLkjrFeZKEPoVk54MsHbyxPbnUFwv0q4hYiLGD4atDOXrP7joMSWeypKKcvPwrkNS4fsqpbDwlQU5kX6UpikF3jZdrg8L3e75IP3IncXKlZo+i62IVayWOPtWpww+Xbx28mcYGAU/7QZNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2025-08-16 at 14:43 +0000, Wei Yang wrote:

Hi Wei,

> On Sat, Aug 16, 2025 at 09:31:11AM +0530, Aboorva Devarajan wrote:
> > In ksm_functional_tests, test_child_ksm() returned negative values to
> > indicate errors.=C2=A0 However, when passed to exit(), these were inter=
preted
> > as large unsigned values (e.g, -2 became 254), leading to incorrect
> > handling in the parent process.=C2=A0 As a result, some tests appeared =
to be
> > skipped or silently failed.
>=20
> This is because "the least significant 8 bits" is returned to parent, rig=
ht?
>=20
>=20

Yes, that's right. As per the WEXITSTATUS(wstatus) manual:

WEXITSTATUS: returns the exit status of the child. This consists of the
least significant 8 bits of the status argument that the child
specified in a call to exit(3) or _exit(2) or as the argument for a
return statement in main(). This macro should only be employed if
WIFEXITED returned true.

Since only the least significant 8 bits are preserved, negative return
values can appear as large unsigned codes, so using small positive exit
codes ensures the parent interprets the error code correctly.


> > This patch changes test_child_ksm() to return positive error codes (1, =
2,
> > 3) and updates test_child_ksm_err() to interpret them correctly.
> > Additionally, test_prctl_fork_exec() now uses exit(4) after a failed
> > execv() to clearly signal exec failures.=C2=A0 This ensures the parent
> > accurately detects and reports child process failures.
> >=20
> > --------------
> > Before patch:
> > --------------
> > - [RUN] test_unmerge
> > ok 1 Pages were unmerged
> > ...
> > - [RUN] test_prctl_fork
> > - No pages got merged
> > - [RUN] test_prctl_fork_exec
> > ok 7 PR_SET_MEMORY_MERGE value is inherited
> > ...
> > Bail out! 1 out of 8 tests failed
> > - Planned tests !=3D run tests (9 !=3D 8)
> > - Totals: pass:7 fail:1 xfail:0 xpass:0 skip:0 error:0
> >=20
> > --------------
> > After patch:
> > --------------
> > - [RUN] test_unmerge
> > ok 1 Pages were unmerged
> > ...
> > - [RUN] test_prctl_fork
> > - No pages got merged
> > not ok 7 Merge in child failed
> > - [RUN] test_prctl_fork_exec
> > ok 8 PR_SET_MEMORY_MERGE value is inherited
> > ...
> > Bail out! 2 out of 9 tests failed
> > - Totals: pass:7 fail:2 xfail:0 xpass:0 skip:0 error:0
> >=20
> > Fixes: 6c47de3be3a0 ("selftest/mm: ksm_functional_tests: extend test ca=
se for ksm fork/exec")
> > Co-developed-by: Donet Tom <donettom@linux.ibm.com>
> > Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>=20
> If so:
>=20
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>=20
> Thanks, I am afraid to make the same mistake if you don't point out.

Thanks,
Aboorva
=09

