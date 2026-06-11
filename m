Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D1ADCD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E5416B0093; Wed, 10 Jun 2026 23:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9968C6B008C; Wed, 10 Jun 2026 23:41:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863776B0092; Wed, 10 Jun 2026 23:41:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7215B6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:41:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14730164FE2
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:41:37 +0000 (UTC)
X-FDA: 84866232234.15.08058DC
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3283D100004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:41:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YrzZrABd;
	spf=pass (imf14.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781149294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y0/G7y6HjmKYou0RghAqp0snLCOrcWkAONdunbULCwE=;
	b=GMRcxO4wFEzfgEyuCuc8wmGxAFo/mGnbl6Mxp7xNvy1yv8xBujexrSujCmEJ/yXYRX/bog
	n8xnvWzg416WEmnDL7vUVmQOFi5OenTpUWHiqNH5S28TskhS5JVCz3hL6g61LfJzwUDeIU
	AyM+iv6MvavTzkJ+7lu/Dwh55VJw65A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YrzZrABd;
	spf=pass (imf14.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781149294;
	b=XhQgxZ2OOxpHL8OMMQB9mcMdhl8uYUG2Xw81pcSvA+tggFY2FSAMsbDEQM/3L3re9HR2GE
	hdC56mnnt7I8Pd8s/SpGUwoNei8S9gRDgFaQpxkSgSqZztbV2BLfvu5LdAnTF8DcCtoMlu
	APP5HW+djoDjRFdyrwwBS/o9Up4OiF8=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65AJu40a4146513;
	Thu, 11 Jun 2026 03:41:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Y0/G7y6HjmKYou0RghAqp0snLCOrcWkAONdunbULC
	wE=; b=YrzZrABd5k92FeXsmeuix8MMgDfOGWOZo+vCT61fexToTnJG0NKtutaK+
	drkrwWGBkNdTeamoSHkwspxzQ3Wj0SL0K3FS9ncDCThO5e5NGCqHH1wMNeOwQHLr
	/O5Rx221zYtfGQ3gbov7Qy5L3hLUv7/CNYevnjt/9IxGQeOOd1j49wEzvKyR0hap
	vAF6limJNQmlYiW6sY2YsfhQwkdXXHR8BF/SvZc0JEQGoCImuMNAEXGIfm6Ywkp4
	HkV0nuyWnMaUWKfsie4svONWhGaGuL9TWn1JTltzz/Fv3PnVFpPX4QsPsvzslWBO
	QIqHFmq7eTbEmxgEve1PTUvW2gtag==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eqe8c18wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 03:41:16 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65B3Ybuf009495;
	Thu, 11 Jun 2026 03:41:15 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4eqe08sfax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 03:41:15 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65B3fBGW45875570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jun 2026 03:41:11 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 907E320040;
	Thu, 11 Jun 2026 03:41:11 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C1832004E;
	Thu, 11 Jun 2026 03:41:04 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.39.27.36])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jun 2026 03:41:04 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R . Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Balbir Singh <balbirs@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Alex Sierra <alex.sierra@amd.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sayali Patil <sayalip@linux.ibm.com>, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v3 0/3] selftests/mm: assorted fixes for hmm-tests
Date: Thu, 11 Jun 2026 09:10:59 +0530
Message-ID: <20260611034102.1030738-1-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDAzMiBTYWx0ZWRfX33cLrJmY9dIL
 kF0N0bHQ9VM4NKCR3g/A6IOfci13Z0c5mkLEFwf0uLCkwAb4pVoK5nRsRDb41XTUqY6SM4e/2HL
 jYz43BSCzUxJWjZJP9bBqQ8TEUb9694=
X-Authority-Analysis: v=2.4 cv=AYCB2XXG c=1 sm=1 tr=0 ts=6a2a2e5d cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=fsPjIq3vPFagtXREB8kA:9
X-Proofpoint-GUID: naBpAaJcwPSnvDYDmdBpIrHgrXyzYpME
X-Proofpoint-ORIG-GUID: Tp18Vn8KOllkXEz0SE-xkHUgxLzRu0OH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDAzMiBTYWx0ZWRfX9vBvpXKNlHce
 cDEIQotyBFi2K5p2SnRlZEcA1yyIOgkOUh8jmGAMU2fk69BJFizQcAYM7ZqIVvQZotjkJ5MUY1f
 dKpX6X4aGeQHWF003684hPU6Y5k1noIsDlHQjIO+5PvFQpmQpPkAJzbmhEQDqjjtsfCU56h+ujN
 bt8Qe7eRCHNU6BLGzJPvH9/RD55tHtK3ShlBuwY63SEQiMzdW1IGYADe2DoyrCVkB6ZJDvDEaN0
 NT2vhomgAPoRQx8E1WzlotWvhETK96WJ25a58CBbn3i8NbRZ71nTq5cbzUD0uHM2B3bMHvnRscQ
 2AMpMz4D4uqk9c4KQQ5gKhmiDQARP7hCRWCDqfxpMD1+H9FpUUNIlLZMsWtSxQ7avkWUAJS2umM
 nrw10I+TqZ8iEK9QxtugasHs4XNTZbrxlQtdQppOl+uO+Vv1iIRCtB7wr+9MNF9uEKAO87Gpmoy
 D2He+3hpT7UeyLlONdg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110032
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3283D100004
X-Stat-Signature: wexfwr4oybstucdg4zo9e37dgx4jb4a6
X-Rspam-User: 
X-HE-Tag: 1781149293-614662
X-HE-Meta: U2FsdGVkX1/jGaaob3x1033t2Y3pITLKTVb99oO4gmcms8l97GGMNp/EXNFxc6CGL/mfr3kW4Xs3i9XvggnQmL8G6RBkn/wLViAQozJfL2+rnX+m430EEw6LXvh1W4flmp87bxlbO+k48AgaSyijbygRjkZOq1EzO7IAxFwpyHc/MQAZLWTKudzUk5+PyR/oKN7yhpHe2HhRftpx7HGhZ97uYkt+xywnzFJFBnJdKS3nSD0XlgVgb8SatYxGFdSCrPImDSwTEfvaG7xTXnLJ39X2zXOLsRnqPZJXPVXxVOddGERNp3HUPyPR+2PuNdqiNgpzY8aWFYgCbeIFTgWH3sFAOxLQ6J+8+qIpHoX4l82Zgl7QrIaYgBFh+r4qqmWR/15V1RmjWIy34dF2/0w5AqrD9QcMgJqrOKdWqRFk256EH0xp34q+ujFg9C85noNYtOwiwD5fSz5fcLk6C6ymn5e+ACkWqI3JQ5cPh5SfAzwB7ouXr1nHTPLatWPcn+PIwW/hg2fZAR2zke8FTVh/QAGw7Bb1NhI4yCUESR3BiN49DG5l7kWMi9/XPFUimdy3rQQhgSjMK3/7oJ69ONJpSl+Xpf8Q4ywIGqUaA3SpfL4r/gKgKO4LeZraIp3gTp7B/ey16MWcz03mQvw/PZRUZDtrJMN7JH5fNEHbo4M6iQ8O6eoCn6AlTa/thkKkMyjIoYIEXaoLKQd2qR5t9uAFMZVbdAYa/1pCgO6+Fvzt2X938n57FEOdMZjvmO/fW/scE2EZMJHptneVGiHeIv0jRVLCnJr1f+v0l0r0gas/o67wnBz69e/s+3Fp+jcc4Ywcd0puPCRTwFtgv7sNA/fg1/D2GoctU2jR5tR3N8l1cFrZuK2xXyDFKQZSck+6s5Z9T5C2H+j+xjhAdyx7EezUSmXF50dfJ2r0cA5K7FvHRbrHkAop+r9yGlYtMGQEU1hH2bl26LjFoeRKhZC1ZXu
 Y2mqIm7A
 DFx96LZo14oZQJsC9c1ogNgLk15uMFMHCf3q7Ai5xgRbstZ/d5mBOBJFlBoNjV7kZKHx8IPdC1vlKmJH3B27tFIzCv27wpCHvZs3d2iR4GT7nXOtoVCO8bZsDkE8bbRPGnI6EtAG14FIsVNf0arZ9LqL3086mMKzuyfE/4O1o+sYCFamGWcxyX4uu6oCpxHtFukV2dnqBw79St0r4JdCD7L3F9LVUQsItNRHH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series fixes a few issues in hmm-tests that show up when
page-size and huge-page configuration differ from the hardcoded
assumptions the tests were written for (PMD/THP sizing, default
hugepage size, and related cases).

It also includes a fix to exclusive_cow: the test ignored the return
value of fork(), so both parent and child ran the same teardown path.

Changes in v3:
- Rebased onto current mm-new.
- Patch 1: reworked the compound testcase check in response to the
  Shashiko review. Instead of an ASSERT_TRUE() that ORs the PMD and
  PUD cases on every page (which loses the expected/observed values on
  failure and would let a fragmented PMD+PUD mapping pass), determine
  the mapping level once from the first page and then enforce that every
  page matches it exactly with ASSERT_EQ().
- Patch 2: Unchanged from v2.
- Patch 3: No functional change from v2.


v1: https://lore.kernel.org/all/cover.1777870179.git.aboorvad@linux.ibm.com/
v2: https://lore.kernel.org/all/cover.1779090293.git.aboorvad@linux.ibm.com/

Please let us know if you have any comments.

Thanks,
Aboorva

Aboorva Devarajan (1):
  selftests/mm: fix exclusive_cow test fork() handling

Sayali Patil (2):
  selftests/mm: allow PUD-level entries in compound testcase of hmm
    tests
  selftests/mm: remove hardcoded THP sizing assumptions in hmm tests

 tools/testing/selftests/mm/hmm-tests.c | 125 +++++++++++++++++++------
 1 file changed, 95 insertions(+), 30 deletions(-)


base-commit: 801c5efa788952095586d076fed1ea4902facff8
--
2.54.0

