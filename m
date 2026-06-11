Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D1E4CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C853D6B0088; Wed, 10 Jun 2026 23:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D116B0093; Wed, 10 Jun 2026 23:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B73BF6B0099; Wed, 10 Jun 2026 23:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9AE66B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:47:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E38ED8DFBA
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:47:04 +0000 (UTC)
X-FDA: 84866245968.29.858A2FE
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id 71E2CC0008
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:47:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RRYTuPif;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781149622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R349Y4OZKVnZ7U+T/Lo1jNsWcJHNHRIJpzEJYqQyySQ=;
	b=Ky3+WBZis5B2LMb5jb5u3lgRXIjSHeu+69I/6bj4HfbdrsMGCFOmv18v+ql4fjXaEyEerv
	KbzABq2GTqEkGkNaEU+QCrquvts6151oP6c5+reS7mTne4TMKeypUYeRl3E5aokm1qi+TN
	F6pc1foKO4uxyapcB//B7wsJMkmSaro=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RRYTuPif;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781149622;
	b=L+4D78pCQZeS7+1DuIqZotAH1vaAhX6MdKCKjzAX75OUpfcOsyP7O0g8wYpDJpkagWtXbw
	c7YzHbjM8cr9IqMBnNq3H7kRA+7E3CaeqYkTGfYPcmrUi/QHHd3BmK709uxm8t0TbX90U+
	QAZHkkYFnNg2F9ysbqJl5TDrIGvAQCQ=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65AJu7n9722324;
	Thu, 11 Jun 2026 03:47:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=R349Y4
	OZKVnZ7U+T/Lo1jNsWcJHNHRIJpzEJYqQyySQ=; b=RRYTuPifmnuWKNV9T2UVkz
	sI/82h9jQPTQGCHGS408pnod0n0Woc4KKf1XqCA6dEoOH/DZDFdgylNjm45BJt5q
	S0aO152/OwT4Hgez8onGAxS8pRauvzolcVFZgRyv9xF64UKyhT7rxEQhX5rSGfF7
	Ew2msQ5cYIT9aQDqZ+qQXrZHgPebeV2INFnPgHoCXpyIStn39MGw/qmQ7V64izSI
	0ZE2nQvrU+RwqjFwrb1OvTyK30KeggFjro/JYeShlp3u4zrMa63veCJMuGeDga2I
	2F8pPBvrTvlCZXE3lDNrJcrzoknby7GY/L9EtjID7vNC8eZsTfKGfiInoIGcyLxQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eqe8d99hk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 03:46:59 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65B3dAkN001974;
	Thu, 11 Jun 2026 03:46:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4eqe09hfm0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 03:46:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65B3kvQG47841748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jun 2026 03:46:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D9EC20040;
	Thu, 11 Jun 2026 03:46:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AE3F20043;
	Thu, 11 Jun 2026 03:46:55 +0000 (GMT)
Received: from aboo.ibm.com (unknown [9.39.27.36])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jun 2026 03:46:54 +0000 (GMT)
Message-ID: <3ba15b67e9e055f9370b34827bfc5976bdd4f41f.camel@linux.ibm.com>
Subject: Re: [PATCH v2 0/3] selftests/mm: assorted fixes for hmm-tests
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 11 Jun 2026 09:16:53 +0530
In-Reply-To: <20260519114423.cf0ff77b970b92e8377cf5cc@linux-foundation.org>
References: <cover.1779090293.git.aboorvad@linux.ibm.com>
	 <20260519114423.cf0ff77b970b92e8377cf5cc@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDAzMiBTYWx0ZWRfXyTDasr7PzfDf
 QkyvBk/rzqr9XoJtEFqPz5uuDWuDW9yH6/xluIglLtCE0+rAsPqLrUjW4etzauMU9OXLiH0yO9D
 d0xRMXec+BqECUA7vfOxIiwUkWjgG60=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDAzMiBTYWx0ZWRfXznFy9P57glMi
 JW4CFHYdbgnV8kPs7AdBtc9GTeGlpidUqb2ctgPAEq3UL4P79cwSVuJ4aRYBe18Hd2Qxzc0+HAs
 6IZy85qjDHghc6/v16zF/NIaWliRtT7q+z8H8z7zPhaH/Iek5hHjK5SkfIHwssfE6i0Vl0I5MnU
 gu+OFkLVQZNBKzSB62HK9dcs076yb+m0fr02HIUVcXv4+GyzGotrcQR8odWFzI3Db8QzoAosNfj
 y6enOSsb7juCkqh5P7mjMeBE/MT9B5bH9gcEZhQGebtkgfvGMxsasQtJSd/k3EhsrhehE6L2ugr
 7Sqzdk/yQ21R0I1innG2CU1QIGEDSsuuZDG7HbQTOuMfpGPkSq0R6fBq1rJBeKD7KkHPZMEg7hn
 ibBLw2Gn3bHo4/P62680eLAs4L9HA68ubhnMxmlkFcJLFNZxtI2FoMUREkVWeN0z/PKYxUO+FBF
 ANil7n2AN9ADJDwHS0w==
X-Proofpoint-ORIG-GUID: gTrfT3qCNNyKusJFSPmN8PLBDswF7I51
X-Authority-Analysis: v=2.4 cv=GIM41ONK c=1 sm=1 tr=0 ts=6a2a2fb4 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=c92rfblmAAAA:8
 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=9jRdOu3wAAAA:8 a=Z4Rwk6OoAAAA:8
 a=JfrnYn6hAAAA:8 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8 a=-ZcQxMazlnUaXzOcXCsA:9
 a=QEXdDO2ut3YA:10 a=GvGzcOZaWPEFPQC_NcjD:22 a=ZE6KLimJVUuLrTuGpvhn:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=1CNFftbPRP8L7MoqJWF3:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-GUID: gTrfT3qCNNyKusJFSPmN8PLBDswF7I51
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 spamscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110032
X-Rspamd-Queue-Id: 71E2CC0008
X-Rspam-User: 
X-Stat-Signature: q5zcopdeqppyxq76zod3guzpc9hp9136
X-Rspamd-Server: rspam09
X-HE-Tag: 1781149622-885445
X-HE-Meta: U2FsdGVkX19k4IobclAjgtr+xgoAcKePNR1cllyNDJm4pzomd4pGAD4HMmXnSlN9RAiju4cE5JgU5XC96vs2n0jigp1p7utm6FxKvLpwYd8r1tqAnIU4erXoace9Kk7SMgEdaZ/gvhK5UwmA/uoKydRo7gS5X6hSM7CjJIt9kEgByZYKv0HTh5Z9BFpdqmVXlyyqSXeo8P+/05mDVFdM4xUR1YChvOlW3or+gwfCTj5v2eqAWu+8SiJSOnqQSpfIIKJolJDdCN8mr6f5Asa8jLZlaSf1q2m5pWKVqYCPHmCb0IV0Ma/yuxOEcG+4mzFlSofMcv1Y0ZgtmWVGQX9etKJ2oNnJOScI27lrAZPIb8COaTLtRDlKvwHOwJ1wQQm8OnL61KXrUU2IFsQ8naEf6Dvc5nMuGBLKcqf0eB5ZfJ/IswTU4SKVtMLnlE3HVdD2Y6ztvHZ2jDbbyP5bu9GTgOl6MTfHQh9J3CzjqQoxHC6sFXGrCgsCOpFVzBr9ze0ta+/o/TG2RqiMgcs1fG5JXSHJIN6yuO5TtO6X2wme+xYZUWFyiPe1nFSIKSI87t7o49PDljzpnjvkjMtVsCFxxK+ljEvkdid7X5pqhpCvKq5r+TBf1DyqNEF/I2HbDIWIbl3cQZQIuAyXOyhT8023Nv2F75fvKauk9rlbhcMlify4P8PMDQKQch8Oux6C8y7mXrM2i1OCML/YOWVGiJNFtQnV7TxF0n5q8BiDARnoHP3Ix1Ocu9GAqboYFZ7f+6hW3RPje3l6qpXV5P4xFpbUwE9ze6OXT0nf95wsSQO0QXps63O70+woYiDMPqs6Q0EQkiw/M3M05ezypb6vuGUlfpu0NGjW/s2GEI8Evh7AjLRNiUNhkUm8fc84NrUs7AYyuLe5lbgX0Uyk6+NirR2ijLoYgdqgcnm03SHGgehbxWcE/14UZY3sMjNTuK2inRVu89tfQGzl0/v0MiqZbXj
 5pRXUFxf
 DjUUJlNmu+tiOviDRa1P8ULI6AmgeG6N8n1ZWu/7IAcoQwj2B4q/xBVUwDERxwFYB1UsStmus5fRMUF2TYjh73uzWSccfk31rEvjE1Y3SHLSVjSXF8tDpWSFcdZVYBYIkH/y2sejx62GGlCCQ5V/AzhEDos3hMw99yym1I1UPXAU5PBX4NkCKoOclhwH0+XWTFrFnNqHaLfHfLy/AYqo7RVvPYf03256PSw++NqkEgj3xvA/2K6M2fwFpvQubIgWIQ9mhI0MgTD+TkNRAFTtTBe021JfZ0zfNGxnJqQA/+Twlwp5PhCRogcqkJDiFkKTs2KOtyZ2QedHrioi+AJG6G/t61sHDcJL6aFZDqmj3qblpfN5SbBByMbYS/sBIndkIJpFRYUrkVUWL6dz+SOcaCxHjmhgDI3BQQXE3STTTO+l7WVXGLjmRYsbeM1/QzO2QBlWnrq13fy7adyb4DFh7ffRCBTOHBgM7seiXTh6M9cj58Drs0R09rt+N5rs0twtF9kHPOABRy/yXbpuC0ZXgJwdT5xs0mUctC+9CKghukcrOlpcZts0A4mThePvxkwzGq2xdkilZbfPPB4SdCSx4O2Uk0452zJlzvlNWhpwzwvgEZveqzIeEuB6muAUOzwBcCCePBLkk/masVZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-05-19 at 11:44 -0700, Andrew Morton wrote:
> On Tue, 19 May 2026 09:36:21 +0530 Aboorva Devarajan <aboorvad@linux.ibm.=
com> wrote:
>=20
> > This series fixes a few issues in hmm-tests that show up when
> > page-size and huge-page configuration differ from the hardcoded
> > assumptions the tests were written for (PMD/THP sizing, default
> > hugepage size, and related cases).
> >=20
> > It also includes a fix to exclusive_cow: the test ignored the return
> > value of fork(), so both parent and child ran the same teardown path.
>=20
> Thanks.
>=20
> A lot of people weren't cc'ed.=C2=A0 get_maintainer tells me
>=20
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Shuah Khan <shuah@kernel.org>
>=20
> Jason and Leon, particularly.
>=20
> Also, get_maintainer isn't super precise.=C2=A0 A scan of the `git blame'
> output indicates that Ralph, Balbir, Alex, Matthew and Alistair might
> appreciate a cc.
>=20
> AI review asked one question:
> 	https://sashiko.dev/#/patchset/cover.1779090293.git.aboorvad@linux.ibm.c=
om
>=20

Hi Andrew,=20

Thanks for the feedback,

We have addressed the AI review comments and sent a v3 expanding the CC lis=
t.
https://lore.kernel.org/all/20260611034102.1030738-1-aboorvad@linux.ibm.com=
/

Thanks,
Aboorva

