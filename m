Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B831FEEF35
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 13:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AE7D6B0098; Tue,  7 Apr 2026 09:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985F66B0099; Tue,  7 Apr 2026 09:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874DF6B009D; Tue,  7 Apr 2026 09:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75E1E6B0098
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:09:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0BA4B5AA0A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:09:22 +0000 (UTC)
X-FDA: 84631790964.16.8BD7D8F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id 90CA61C0008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:09:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EtvohyZF;
	spf=pass (imf20.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775567359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FItEFcj0rTvSsv8dNr4j3B9MFFiOFkMEo1S6fzbKUeY=;
	b=5BhxmcZBTSqpT6++nvWyPqg9tvtDtvTBt8Xf8Fe7DbA/B2M97MUVMTmVTwK+kAb2mWEalU
	hvM4jSfvwEaLgGtPI/oD12yDhPnYiLrCmSR2X2BJITGvGjkDoFIRB8QHeoYEMOTbjzMgk+
	j27aFTDmVGGhJK26LPHFtDo+YcfEoSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775567359; a=rsa-sha256;
	cv=none;
	b=P7YWUVpeu1jtSE93rH0wrOHQ/S5VlVp1RfAJ48sHEFg6Ts7mFi2duE6wM9eA6a/1x5r1Pg
	26etsquOTd1r8JfegM7HsNQlMe4F166/ucT3J6+u8a1c6y+hy9f9DJDsDAwRLGp2ncNc7K
	WkiRnsk/WjN6M6KLE1EH/tzP8euVEpA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EtvohyZF;
	spf=pass (imf20.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 636LmvGM2212549;
	Tue, 7 Apr 2026 13:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FItEFc
	j0rTvSsv8dNr4j3B9MFFiOFkMEo1S6fzbKUeY=; b=EtvohyZFpZqHp5LtqmW+jI
	Rk2YZAqXZ3Ge2dylErZdACDpvwbMur3JhYiZTzozAdClEv8YWexLCXXUneBEWWPT
	ItAzvwcrsfwbu2UeGjndO3S06hbixT49cT5L9UjxwWUH+Gs5MKADxDA69FdphI5S
	tzik5zyq7v8Y3IaVwX/us/jvDdB1aGmVH6ogfZ/IdflSIylQ2rvG5ge5nqBkf8ia
	DIftP86yageKmUAIeMtJL1UdntSkLdYkrMHLjeD5PGJN3bNRpL9ezDPaj5SK9/Cl
	UeLvq9fpM4j//q/AKzMWGwHoneESYbtpeplJXMD/+A3k4wjf7TpQlrWoJds3N+FQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2hasyt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Apr 2026 13:09:05 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 637BQMZM013902;
	Tue, 7 Apr 2026 13:09:05 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcmf438yr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Apr 2026 13:09:05 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 637D94gv8323876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Apr 2026 13:09:05 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD64758055;
	Tue,  7 Apr 2026 13:09:04 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 387D05804B;
	Tue,  7 Apr 2026 13:08:59 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.61.247.154])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  7 Apr 2026 13:08:58 +0000 (GMT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v4 00/15] selftests/mm: fix failures and robustness
 improvements
From: Venkat <venkat88@linux.ibm.com>
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
Date: Tue, 7 Apr 2026 18:38:46 +0530
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2CAD5B1A-7FD2-4C5C-9279-A3131EF60D86@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
To: Sayali Patil <sayalip@linux.ibm.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA3MDEyMCBTYWx0ZWRfX1ak3vKXmOqHg
 g2dbfUiNW5cdhKvh7bMuFP6rK7s65G7isGJ77Uvw+TDXQTVNTIY1t6I3iKoXdI6uCI8iiVNwhpA
 KPJK9PRsu5BWtPLNQ1bWSS8zNe+PBZ7Db/P502/GRaRXn3wqzkWsffFv4Z51rDviyftnwRA6oI9
 5huuHs89lPYdaodJ1rOAUVgI2I2GaJDMB2I0sYWaHisj4bXxmEiAKkdTPG/p039zmITgwXJfAAf
 uwgyzOePSxrwHByR/J7uYr7UturMTUR3pq6P4QWrV2WD9bOr1R6EO0rpp+6ZE9nvQkZEFK6FaMN
 t3JN0BHhe5440zxKU+bmETvrd+bvkDW3RSikAH/spVd74t73RMNg1fK+31/6Gu/34tO9/9NSray
 QRbJ2Yrsyvk3SnE9lBGLGjXyaZOIzN7lyQiPltUZIGYnRO3rd0vQFiHYw7uYEejhOwO6eAm3k2P
 Noz1thdoH0niTjadW2Q==
X-Proofpoint-GUID: 36-U94uf4L4vh9ztE91hE3oUw1FjIAGo
X-Authority-Analysis: v=2.4 cv=a/wAM0SF c=1 sm=1 tr=0 ts=69d501f2 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=UB1gz0I0rgZDmcXxxXkA:9 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10
X-Proofpoint-ORIG-GUID: CvfsEvoqX-LOpTSFK1gUxWWMwfWEeSSw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-07_02,2026-04-07_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1011 spamscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604070120
X-Rspamd-Server: rspam12
X-Stat-Signature: emd79yh9t6k1pjr7ijzhyy16y18gnphs
X-Rspamd-Queue-Id: 90CA61C0008
X-Rspam-User: 
X-HE-Tag: 1775567359-136485
X-HE-Meta: U2FsdGVkX1/aT7DTWIlSONMlIdwMHSEjgR3yZqq0jQm8r4g3vlCqR6KytqSQaD9VYz0iewl3tnKwhkl1f91X+vid1GH7z/9WCctXMJi4sidN3lzaPpSfl73l4hjDHOaVdud7pnCuBQyP5g31xrscq4vlK2VYeu1rFjzyr3qlaaR/6ltH5Y20wpg9nG9ex3UwDRIXYNMjhreWkUUto6vlVQrBfVA3iF40xMbq8/lnReLG30ZtEIRzRNZtGdHu5L/1AzlaFVXC+EvC3gSiAJRLHAL3T/o4AsGcI78zGM/opmSfO28Dm/4jbbhDhPEX+a18iLx9E08tnZdnEifb3MeWYWKhkgKhY3urc0qpY1BZJW3Veu+PTg+G6/zYrFkyXiWsnFQTFsd8scM+D6p3tUj4xLWoTcGdx6xAdDcpHNH6t2B8XzsEkoumTlzmpdj5QwWT9F1LsnBp9uvSFYUC5LhsQCfpo3iI6SqDrE1Yyaywq4IRfuKvX3lmyxgQGS0qwDbxJdPBl+Zdpwn/KzmeRvOpii9urLanhsU7ELJCjVrj4ZNS9hIGVs66U3Bv0pMDRac9/cHmegjKGIGHn9z4K6kDlFmwwvaV5XV8FkyaSMXAHeaUm2enuW19vbVrIjkeh2OG5qfkslLwTpQU6midzzIaq/E0nzr/mXQc2Xmwo6SFRRAhXXnWPNN464/Np3diYD12NaacG/05pJaE+V9AcIavdssMfJorxTLp+b+OPiZd1Yptt3TEDmX+SK4srvTNDkoumytieiP3wuB+9H8+QpJzQrrkTTZBBxQBYaBkXPbbJ8rSSrEUIPZREkqC0lx/MTi4pBv38Cruo0gA6dgZJWiA3p86aIAyPiuNHn28Pz4er8c5sY2e84RfDSeblgRYXtKcQskCWiWUodZo4Wck7J4i7SdNQJSNCw6z0eMMa/TvF3u1B7Y18GH6R6PExQdmI9jpOqVoY9MnOjcPJ/EZ6Qz
 LeXXe+9v
 LIv3KGwIHNZ46ooaDTASQsFovi2qDsjH9RNaMQV6Fue4ZWN4iz0OB2BySM5BstKpLtBvyErWaHmzVYcg9KHl8K971p83wk+LboARoYDuw+XAVAc0liZFkBmqQPN03JMzln2HNugd+HaCDUWOZSz7W6nKBYJUAxFBL4s82XMJcy0H81t1CK+Jm6gkbtV7zKjTf/HLo8PgfBz0VXbqLl3YHgodxtvD4WKAfcHFynRlTo8pqGIU35nWz9eMod7fVJlHkRB/Tm2nueHC7EZgNrbtDC8P/IW9AqIz/8UXbvbNZ2zjG4V/vpxlMAvpy1MDq9PSv4jDJvzdesxdNnxV3qwU06s2Z8RKfZB/G5fkr+ejd8+V3V1o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Sayali,

I tested the full series, and overall it looks good. In particular, the
series resolves the issue reported in v2 [1], and the other patches in
the series behaved as expected during my testing.

[1]: =
https://lore.kernel.org/all/cf815c21-138e-44c8-986d-d8496503ee32@linux.ibm=
.com/

The only concern I observed is specific to patch 15/15. On systems using
1GB huge pages, I noticed below failure.

  ./test_hugetlb_memcg
  # Hugepage size: 1048576 kB
  # memory usage should go back down.
  # expected memory: 4194304
  # actual memory:   8388608
  not ok 1 test_hugetlb_memcg

Apart from this case, the rest of the series tested cleanly for me. =
Based
on that, it seems that dropping patch 15/15 independently makes sense.

Hence for the series,

Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>

Regards,
Venkat

> On 6 Apr 2026, at 2:49=E2=80=AFPM, Sayali Patil =
<sayalip@linux.ibm.com> wrote:
>=20
> Hi all,
>=20
> Powerpc systems with a 64K base page size exposed several issues while
> running mm selftests. Some tests assume specific hugetlb =
configurations,
> use incorrect interfaces, or fail instead of skipping when the =
required
> kernel features are not available.
>=20
> This series fixes these issues and improves test robustness.
>=20
> Please review the patches and provide any feedback or suggestions for
> improvement.
>=20
> Thanks,
> Sayali
>=20
> ---
> v3->v4
>=20
>  - selftests/mm: restore default nr_hugepages value via EXIT
>    trap in charge_reserved_hugetlb.sh:
>    Updated to use an EXIT trap to restore the original nr_hugepages
>    once at script termination, ensuring reliable restoration on all
>    exit paths.
>=20
>  - selftest/mm: fix cgroup task placement and drop memory.current =
checks
>    in hugetlb_reparenting_test.sh:
>    Updated to use a deterministic synchronization method by migrating =
the
>    workload process within a wrapper subshell before calling exec() to=20=

>    ensure correct cgroup accounting.
>=20
>  - selftest/mm: align memory size to huge page size in hugepage-mremap
>    test:
>    Update test code directly to align memory allocations to the =
hugepage
>    size, rather than modifying run_vmtests.sh. This replaces the =
previous
>    commit =E2=80=9Cadjust hugepage-mremap test size for large huge =
pages=E2=80=9D with
>    a cleaner, direct approach in the test itself.
>=20
>  - selftests/mm: ensure destination is hugetlb-backed in =
hugepage-mremap:
>    Updated to remove MAP_POPULATE flag for the mmap call as per review
>    comment.
>=20
>  - selftests/mm: skip uffd-wp-mremap if UFFD write-protect is =
unsupported:
>    Updated as per review comment to initialize features to zero and =
exit
>    on all uffd_get_features() failures, avoiding spurious test errors.
>=20
>  - selftests/mm: move hwpoison setup into run_test() and silence
>    modprobe output for memory-failure category:
>    Declared LOADED_MOD as local variable and avoided a redundant=20
>    skip message when the module is not found.
>    Updated logic to set exitcode to ksft_skip only when no failure has
>    been recorded.
>=20
>  - selftests/cgroup: extend test_hugetlb_memcg.c to support all huge
>    page sizes:
>    Updated to skip on memory constraints instead of returning
>    EXIT_FAILURE.
>    Updated the logic to fully account for the scenario when the
>    per-CPU stock is empty and a refill charges MEMCG_CHARGE_BATCH.=20
>    Updated to avoid overflow on 32-bit systems for memory.max value.
>=20
>  - Included "selftests/mm: restore default nr_hugepages value via
>    EXIT trap in hugetlb_reparenting_test.sh"
>=20
>  - Included "selftests/mm: free dynamically allocated PMD-sized
>    buffers in split_huge_page_test"
>=20
>  - Included "selftests/mm: clarify alternate unmapping in =
compaction_test"
>=20
>  - Dropped "selftests/mm: fix double increment in linked list cleanup =
in
>    compaction_test":
>    The behaviour is intentional.
>=20
> v3: =
https://lore.kernel.org/all/cover.1774591179.git.sayalip@linux.ibm.com/
>=20
> ---
> v2->v3
>  - selftests/mm: skip uffd-wp-mremap if UFFD write-protect is =
unsupported:
>    Rename function to check_uffd_wp_feature_supported() as suggested =
in review.
>  - selftest/mm: fix cgroup task placement and drop memory.current =
checks
>    in hugetlb_reparenting_test.sh:
>    Drop memory.current validation from the hugetlb reparenting test.
>    Keep tolerance at 7MB (reverting earlier increase to 8MB in v1).
>  - Included "selftests/mm: allow PUD-level entries in compound =
testcase of hmm
>    tests" patch:
>    Extend the compound testcase checks to accept PUD-level mappings.
>  - Included "selftests/mm: replace hardcoded THP size with runtime PMD =
page size in
>    hmm tests" patch:
>    Use read_pmd_pagesize() instead of TWOMEG and cap maximum THPs in
>    benchmarks to avoid integer overflow.
>=20
> v2: =
https://lore.kernel.org/all/cover.1773305677.git.sayalip@linux.ibm.com/
>=20
> ---
> v1->v2
>  - For "selftests/mm: ensure destination is hugetlb-backed in =
hugepage-mremap":
>    update FLAGS definition to MAP_HUGETLB | MAP_SHARED | MAP_POPULATE =
and
>    used it for mmap() calls as suggested during review.
>=20
> v1: =
https://lore.kernel.org/all/cover.1773134177.git.sayalip@linux.ibm.com/
> ---
>=20
> Sayali Patil (15):
>  selftests/mm: restore default nr_hugepages value via EXIT trap in
>    charge_reserved_hugetlb.sh
>  selftests/mm: fix hugetlb pathname construction in
>    charge_reserved_hugetlb.sh
>  selftests/mm: restore default nr_hugepages value via EXIT trap in
>    hugetlb_reparenting_test.sh
>  selftests/mm: fix hugetlb pathname construction in
>    hugetlb_reparenting_test.sh
>  selftests/mm: fix cgroup task placement and drop memory.current =
checks
>    in hugetlb_reparenting_test.sh
>  selftests/mm: size tmpfs according to PMD page size in
>    split_huge_page_test
>  selftests/mm: free dynamically allocated PMD-sized buffers in
>    split_huge_page_test
>  selftest/mm: align memory size to huge page size in hugepage-mremap
>    test
>  selftest/mm: register existing mapping with userfaultfd in
>    hugepage-mremap
>  selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap
>  selftests/mm: skip uffd-wp-mremap if UFFD write-protect is =
unsupported
>  selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
>  selftests/mm: move hwpoison setup into run_test() and silence =
modprobe
>    output for memory-failure category
>  selftests/mm: clarify alternate unmapping in compaction_test
>  selftests/cgroup: extend test_hugetlb_memcg.c to support all huge =
page
>    sizes
>=20
> .../selftests/cgroup/test_hugetlb_memcg.c     | 90 ++++++++++++++-----
> .../selftests/mm/charge_reserved_hugetlb.sh   | 45 ++++++----
> tools/testing/selftests/mm/compaction_test.c  |  3 +
> tools/testing/selftests/mm/hugepage-mremap.c  | 42 ++++-----
> .../selftests/mm/hugetlb_reparenting_test.sh  | 59 ++++++------
> tools/testing/selftests/mm/run_vmtests.sh     | 52 +++++++----
> .../selftests/mm/split_huge_page_test.c       | 27 ++++--
> tools/testing/selftests/mm/uffd-stress.c      |  6 +-
> tools/testing/selftests/mm/uffd-wp-mremap.c   | 13 +++
> 9 files changed, 220 insertions(+), 117 deletions(-)
>=20
> --=20
> 2.52.0
>=20


