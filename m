Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C1A210F9969
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 18:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC21E6B008A; Wed,  8 Apr 2026 14:46:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C2B6B008C; Wed,  8 Apr 2026 14:46:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B136A6B0092; Wed,  8 Apr 2026 14:46:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 970116B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:46:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BBB457B09
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:46:15 +0000 (UTC)
X-FDA: 84636268710.01.135AB1A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id C16A8140016
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:46:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=AikgsgzC;
	spf=pass (imf26.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775673973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OkQDQ8Kz4XxAT/k9Gg0z16gyyKHE1DYNIh1KoIOC7I0=;
	b=c4PLtcNsyolSAyJEikBwGMkybiHlAdp7bBV5XwQAYNQ9VKU/gfEc1/E1sugczcPxiexMrB
	LNXmKtNi/IM6up2T3wGZ2nC+oXrph0AP9TKk+gQ5V7ppPAw6nj7kPDwbEkIIeZEHslyHGW
	YBSfvWmUeiyiEr8t6ERb24Op2tQ063A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=AikgsgzC;
	spf=pass (imf26.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775673973; a=rsa-sha256;
	cv=none;
	b=tuK1MCWS6ZS3tV/XfWM/gpkhZ8eZcLoNEeaNdAsLOmU4PulNTQzdf5KSg9oxSIbyb8dcA+
	hivyy8rxPo4o5gx7sVM9Tl49mt0I+2katYiDZfpiorsooR4oPdn9u8kGZ/bk5tbdKSRVP8
	fr64A03+TKYAcQHF6cad6d2MY4JHf+I=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6386iS4j2302360;
	Wed, 8 Apr 2026 18:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=OkQDQ8Kz4XxAT/k9Gg0z16gyyKHE1DYNIh1KoIOC7
	I0=; b=AikgsgzCs3pNvvEc54N+DC5tsqIHsmUrHHm0/Ads7OuhaZWw8TC5rF0eO
	04q/nf2B61GVcTFGvZjH/rpdUiFOfrR0WgchdqAcXAf7J9UGqMxV8eQlMkmcVMM3
	p5kV6txLxMxldEgdvkvOfkZp4EHBrqq42Cqs5uAopsSNx4qQ749voGisjGGpt+jX
	5hOxo6tqdZz3g0S0mhRiC6yFTZxmDi3NCWXd3GG1DbPOOgbs4/+ryDxP3bc8EBaV
	pqZUGt3lKA/6ezIf336pmpd3j9CFDiFIPy8kHr72nrnw28uc65kXhdBOeMVUNvWg
	8JN8CPxhQKnWc6int2KDGfKILrskA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2fhhx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:45:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 638GDEJh026646;
	Wed, 8 Apr 2026 18:45:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcmg80jdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:45:58 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 638IjuQ843319806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Apr 2026 18:45:56 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5EA2A20040;
	Wed,  8 Apr 2026 18:45:56 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F0F020043;
	Wed,  8 Apr 2026 18:45:48 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.212.72])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Apr 2026 18:45:47 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC PATCH v2 0/5] Add buffered write-through support to iomap & xfs
Date: Thu,  9 Apr 2026 00:15:41 +0530
Message-ID: <cover.1775658795.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE3MCBTYWx0ZWRfX9WI93fdiH3QZ
 yGonju9BaiXcadgeNZqJuu32AiWXoQJmKj+aERWkZza/V/lrEsybcCpKXcu3cWQkKwaRckI9mhQ
 TVUZhubOYm5ELuLR+1UZ79DVSjbvzzFQGPqwtb3vsjOoKFCJKqAdKJizFTSXC9H2c4Fss9uqHq/
 lZ34LczN5f85CREyV3gjtvll2EGco6tx4EZ9J6L8QCxB1zR12BBdKe7cQKOx3Wt/LXASO2XoEWy
 vmfIKkJrr0tdM7e8FlBsC9tXnhcdf66m0I7bMVqx5MXskM0p9tUz5BNDr7A2ysJ+UCxkVWo+C5U
 o1ON1SXTv2z+5aXGI0m0Ben0K2Nw4HQS+ykKjCRynQhZB5+RNJZbyge7uX1MbbRaIqqAe/0fufd
 nZs4700j6YB2Xbjiq6XvCvOdjCOA6d7tKzevNt1LTyBaoGsRWybcDdg9Kl5N8TXNUhyH4OQt6JQ
 3OMWsPAqxqCccYX/LJg==
X-Authority-Analysis: v=2.4 cv=FsY1OWrq c=1 sm=1 tr=0 ts=69d6a267 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=k-kWuyQ5Gaapq7rbvwgA:9
X-Proofpoint-ORIG-GUID: UDiIZQ3Ml5oN0Dzje_dxtik_g9jHB07q
X-Proofpoint-GUID: VhKCnVZ5WqJ4rBEdff4GG8b65jCrFBK-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_05,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080170
X-Rspamd-Queue-Id: C16A8140016
X-Stat-Signature: epon3qssop1gc9aj1ybt9165sf14f6fd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775673972-935309
X-HE-Meta: U2FsdGVkX1/nj8n0csACIOnKJCtL38uZIxQSOvQ70oimpScUZfiK4/k/ddVR8bkzbWeJlO/85Wh6p5UwTzqMe6GOFZTZfLIQeF7oyRqLnOLi+ZRTiFfsv9EoxyEEhBtoVpyp+zH+hYKAdAo0IKvgeLmoYH4nLNDJVHoZWQ8GX0M+YoVzOzqrE0VhsQ3JMbSHrn1yTpkN9PosY2Z8y2sIeH+bowhQGZrTt7pUEonSdCwRhNMcpQzwK8R/rvwdpM7EiRNEElTHCx3PWilD5YoUDbPx4mB+6pFnKGO6iW/0B0fPiPM9+V+TmZ8cHx6DoCrydwoIlWf+AA4fvlOC9HPVQ7eSGvUqM13JvPdFXjzGUwh3zo/vPAH17j7sERYOs4/vWb57uuF57QxVJumpZHYblsi5fnK63uPHj+O/fpvXT5iytz5mCQNVhtZMgmAT/jRc6mZiJlUyqHulD2QDchUfgiJUQiSMc3lTrYq+0ZXCdPw6hK6ZcDo0v/VEM15UnXyRqaLnZHEr6Hx21nqzzOQbsDoxY1b7qX8UAIaMnKTAw5CPTxEYtjf9SRTsMpqSk8wdYpje+5h+B6iTAKu/2vxmXQhy0xsGJ4iSxCVn4mFmoE67KmsmH1FYruqvqMk9HsjCYemGVsbF7BevFnsAsf/GTkqtKtjpeXG2P8Hyz0cGCuoU2GwsTfJNK4uv1+reH4R4Yl+4vUd/ru1hvs5Pmhyt0Kqp3N50bx6I/SvuBiwlhCsqf2LWZO7CV6R4sl4cp8+LwhXY820eKaX8QAjjsbQAPZ+2cPTMmoybqr6PmB0F7L3vWynlh6hImmlyq6IGP58C4pW+KZRRbr00fqjSTKX6bNKY0cF9jYSg/+EDeQO+BCaslS+TeQuUZxxo5kK13cL/hAcudSNg7mydUmhrGObuaPHHZyErv0Oysc1F18M47BeAQ0ZZjMpXOtYHjCB5aizkcWiQc3bdAvBMoe59oWz
 3YujUD3D
 2op5MD1DW5QiECUNirkcN5QE8cilSv08w1qsmdXoQ8A4g4ISutQiSfiYxqoPzSNBodA6OqqF6QPwY92xNt/E7s/kRkm2wspOVJcnjcO2UI02eHyrUuRIXVdXfYYR7tTcCul0Z4Gs4kZoqJmf3wJvb50sJ8I3Dpil2WdVEdcNvYRavXwFHjsXrY2fV4xMRNFuOl8ovfcN1OKgoy2sMiZh+wNwsq4Ui1B7CKTqU8HhF1rmPDrBKWtimU9VyLQhcMkrDTvIdPqpHFqEfpEpom5nsiKa91oOWDBWOvp5pZtuyKVVqwudqe9f2FCwTf47jDoX+UMxvpQeH0Y0QcL6IgDe0psvRLm9HQf9IPg7huswrXval/+xop88LYDBPEH3qdeJ1pnQy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This is the v2 RFC to add buffered writethrough support to iomap and
xfs. The changes made are mostly to get the writethrough implementation
more inline with how dio handles writes. 

** Changes since RFC v1 [3] **

1. In v1, even the non-aio writethrough syscall returned after IO submission
but before waiting for IO to be finished. However, upon revisiting some of the
discussions, we feel that it's more cleaner to keep the behavior similar to dio
ie non-aio variant should only return after the IO completes and report any
issues upon return. Hence v2 now follows the exact pattern of dio where
non-aio writethrough waits for write to finish whereas aio writethrough returns
after submission. This is inline with the discussion here [2].

2. Instead of submitting a bio per folio, we now submit a bio per iomap.
Only once all IO are complete, we call the completion function to invoke
FS specific ->end_io()

3. Instead of reusing dio code, we have open coded the IO submission and
completion. Althrough this is heavily inspired by dio, trying to hammer 
buffered writethrough handling in iomap_dio_rw() was resulting in ugly 
if elses and hard to follow code. The open coded variant is clean and
easier to follow however ideally we should try to factor out common
parts of dio code to have a cleaner interface.

4. Support for aio and DSYNC writethrough is added, which utilizes FUA
optimizations if available.

5. Added a new ->writethrough_submit() operation which allows FSes to
perform tasks before IO submission. Like converting COW mappins to written.
The motivation is explained in patch 3

6. Refactored folio_clear_dirty_for_io() so it can be reused without
having to call folio_mkclean(). This is because writethrough mkcleans
the folio in all the cases but only clears dirty bit if the whole folio
is about to become clean.

[2] https://lore.kernel.org/all/aZUQKx_C3-qyU4PJ@dread/
[3] https://lore.kernel.org/linux-xfs/cover.1773076216.git.ojaswin@linux.ibm.com/

*** Original Cover ***

Hi all,

This patchset implements an early design prototype of buffered I/O
write-through semantics in linux.
 
This idea mainly picked up traction to enable RWF_ATOMIC buffered IO [1],
however write-through path can have many use cases beyond atomic writes, 
- such as enabling truly async AIO buffered I/O when issued with O_DSYNC   
- better scalability for buffered I/O

The implementation of write-through combines the buffered IO frontend
with dio backend, which leads to some interesting interactions.
I've added most of the design notes in respective patches. Please note
that this is an initial RFC to iron out any early design issues. This is
largely based on suggestions from Dave an Jan in [1] so thanks for the
pointers!


* Testing Notes (UPDATED) *

- I've added support for RWF_WRITETHROUGH to fsx and fsstress in
  xfstests and these patches survive fsx with integrity verification as
  well as fsstress parallel stressing.
- -g quick with blocks size == page size and blocksize < pagesize shows
  no new regressions.


* Design TODOs (UPDATED) *

- Evaluate if we need to tag page cache dirty bit in xarray, since 
  PG_Writeback is already set on the folio.
- Look into a better way to refactor writethrough path by reusing common
  parts of dio code.

* Future work (once design is finalized) (UPDATED) *

- Add RWF_ATOMIC support for buffered IO via write-through path
- Add support of other RWF_ flags for write-through buffered I/O path 
- Benchmarking numbers and more thorough testing needed.
- ext4 support for writethrough
- Utilize writethrough for normal buffered DSYNC path to get truly async
  semantincs for DSYNC
- Look into folio batching support.

As usual, thoughts and suggestions are welcome.

[1] https://lore.kernel.org/all/d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev/

Regards,
ojaswin

Ojaswin Mujoo (5):
  mm: Refactor folio_clear_dirty_for_io()
  iomap: Add initial support for buffered RWF_WRITETHROUGH
  xfs: Add RWF_WRITETHROUGH support to xfs
  iomap: Add aio support to RWF_WRITETHROUGH
  iomap: Add DSYNC support to writethrough

 fs/iomap/buffered-io.c  | 420 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_file.c       |  53 ++++-
 include/linux/fs.h      |   7 +
 include/linux/iomap.h   |  45 +++++
 include/linux/pagemap.h |   1 +
 include/uapi/linux/fs.h |   5 +-
 mm/page-writeback.c     |  18 +-
 7 files changed, 540 insertions(+), 9 deletions(-)

-- 
2.53.0


