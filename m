Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B73CD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F716B0005; Mon,  4 May 2026 05:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EFFE6B008A; Mon,  4 May 2026 05:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DEE36B008C; Mon,  4 May 2026 05:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A64D6B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:11:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31CAC1C00ED
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:11:21 +0000 (UTC)
X-FDA: 84729168762.25.922D60E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0C090140010
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:11:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=AJVpEaBh;
	spf=pass (imf23.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777885879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9wiDU/yHrm108gVQhopEZG7BPuvKV+l2/i7eawOnq/U=;
	b=q6liy9MIY2TDYOQRQoBvT0QC/QmUWe8sdfZrAsmZSd/aLL0cYdxy5sJYFgJ1W3reflt0vw
	7mnXkGnosXEWy6wpwmZ+jZL1F4LAyIfORkvZ6IWNGmLT2OMTSo3yA3pLmfRh6jSYQNz1aJ
	2nO5aI9o9sEuaJIYNxoSM01JOjrRrkg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777885879; a=rsa-sha256;
	cv=none;
	b=tYkJye9bDCl/ZQnESllwIX8TBwOW4958EhxIl3YEp1GdyWrzEIGfn/KTHunx8VBXb/406b
	5uCPaM+hh9war/fLajl2FFwRlpcmgN1TQeVRzESAXUtQtWg/2ubji1DoSL3IzzZLAiq83D
	YjjI0NiFL7Etl3pbcCcgVDdNzNHsvhg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=AJVpEaBh;
	spf=pass (imf23.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64484Ibf1010395;
	Mon, 4 May 2026 09:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=9wiDU/yHrm108gVQhopEZG7BPuvKV+l2/i7eawOnq
	/U=; b=AJVpEaBhf/zjq5DjxxcVADM4SD/ze/ibqu89AVSBkknH8S7z9uQJW/DjR
	Ic49GEV09XsHS8wKlW1ftuY6YbqvAmGDHBUZWDud2a/wuOoQHiAojKRJJAG4119z
	r+bpPS3bHdlGM8UKJjMGO4h021XMw66fEewzxKjojOsESYh6Mem9ayREutciaE0u
	Sx4lEem23LM4FqosElVNBhPQcseebWSO9BZc/JzkcocooG2gAKdeV1qSTU7aIjRd
	YsNmSa/8yyyGkEtKvxgUrztH4FctWUJ/ChorTWw7MN5i5bfiocE8TpzhVoEPAGNZ
	SE0aeGVVSFBQCLptfmnsjBdtmK1rw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y4e2y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 09:11:16 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64499Rwp005941;
	Mon, 4 May 2026 09:11:15 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dww3gvcq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 09:11:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6449BBP434931018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 09:11:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5ECB920043;
	Mon,  4 May 2026 09:11:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9BD320040;
	Mon,  4 May 2026 09:11:09 +0000 (GMT)
Received: from aboo.bl1-in.ibm.com (unknown [9.123.14.187])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 09:11:09 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: Sayali Patil <sayalip@linux.ibm.com>, linux-kernel@vger.kernel.org,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH 0/3] selftests/mm: assorted fixes for hmm-tests
Date: Mon,  4 May 2026 14:41:05 +0530
Message-ID: <cover.1777870179.git.aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA5NyBTYWx0ZWRfX+eWJQ6jZGvm/
 ZpdGNbxPlLKY7tYyz3LRHCNBSN0r7Yqp4AFAGX1dKnyjHrXk29V5QqPRvB86unnxd6f2wi2qwKh
 IGPaO6pj0K5KVv1pBvnnSaQn61EyazfFonmUEg+nyvaoSPzBPFYsDP4VRZr7K26BIFEzmVbmQBg
 HsNamw5uq+VJSmHI+ZcJaDL/CSU5Pj7rnblmq9YggRfz1fCn43m8B2TIpA01J7qpoNIDoJW4Cfy
 Z7pwiKp7u1USmJsFJOgiCJDgXKlwK++cFgb8EPAj0LoBabwmr71LpbN7E61Coo8NttvwnHkz6Y2
 aJRCvHLmr4pSNGs2QGOhF3KpLsyX0jZ8Idr+XmKMtAOz9rnHjnVLFJYOcRKWYfc/wHtP7h+vHiW
 vlkTJuBpqNsI0JAOJv7MlO2jHBDj4maJmFbwE+uucnhw2PLhZ6QE1cuNvSCh477ArLFnWP46B+L
 JhKz4kB0Zko0ZKqR98A==
X-Authority-Analysis: v=2.4 cv=J4GaKgnS c=1 sm=1 tr=0 ts=69f862b4 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=M2d22ONcT9KgptbevxoA:9
X-Proofpoint-GUID: uV2WjqPChciwyHDFa1D9KT7BjH_8Hqr0
X-Proofpoint-ORIG-GUID: uV2WjqPChciwyHDFa1D9KT7BjH_8Hqr0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 malwarescore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040097
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0C090140010
X-Rspam-User: 
X-Stat-Signature: 7mzgkmiar67kyw981whstxafb3szdrip
X-HE-Tag: 1777885878-658627
X-HE-Meta: U2FsdGVkX18xD06XSWh2iqT2X9mb321xpeFIF44xjAwRe4WjbYDVaDctWxBeDw4xOq4zy3YzbJ+IKhmIYBjYWMU2Gb934FIUyhuy8wOeW46BQn14kayU1lP65PRcVh+5Ol6R4MrY3RyBQlUXsY1YmjsLIfbHdhLAJLQP0OF4FjZmpI8NpUNsNz5LTI7rLcBUH3wuFUk+rECFs+flZyYdqJm3RbIvpXXEeMFJGKbkHXZbtK87WRrt5V3NgInIKOnU+nKbgd6LvYFLnhtvVGU6AwsQBsJ9vDl2zCeOa6wO4Q9TVNSd/+1qHOPfXmsa2MURlbxbLFehqtEdwIF/JVJzOCZOtED4f1ED4wcMeC5JqrnYx8GX8z/qn3hYav8qY/edDewYmpcMcOItwR1XBNuDk2EWReq2ekSztFTuJqN5EEjaTy1RlEdC8a9pcq6LFrBLe4wJ/JmvbK+W7W9EZ2qa3prgf9RShNseDQrrXiWluKJycXqDiuqgkLNYUMzuM+JdnTEHlfPXnB1XXmydhCFcdUaH5M/pB/op6UAXd2HrainvaxbkXlkiwv/mV8O5ufzt3A6eQ1c0cQMAaQqyuHhVR4OMFGb1KDQYxULMiyaTcauR5KP23nboegAwAFLAm2+wgUkpDptiFjue0fg/20nsNmya3Cx2yXGzjPEUC5hoG9IlpJ/xza85VaDMo9iWBH1b9FlX51hQ3hWErP4Oaouyx3O01PEi3kQTNbn4w61eNbKi4sBWOrUhKmeHQsTw1TVXbL64i37KEpcbdDrtm589ZquTUcZ6KyyxhzfwtC9SBdj4oCe267V34pFcvGu0W5/+hWNGehee0vvp7LGnLclywN8XY1zfEl9poWpBH+xjIn0FygNhmi66sILFg5ZU3RY064TvOjJ6OclqYNsa02djt6s/E8Rj1ohySnVguFitFk/zVe41GtgFWUNEl2z9X2tr5yKve19mLGzsyKmCORE
 pm8v4irL
 ZQkKK2Yme6mdTPHHHXjPBJETbRCNKzma9x+krcirConmiwpst0iQkNvKHLlKlZIrVE0it/xi7hJHWuSnU5MVRYL9yN6Lv38ItB2s1cPvbrbu/oidZe4bJ0FFOE36mo/tjrGpNOagML1kzWhzyFbICcVLRDCZ5hbKENTmSXEcvKUFvd5U=
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

It also includes a minor fix to exclusive_cow: the test ignored the
return value of fork(), so both parent and child ran the same teardown
path.

Please let us know if you have any comments.

Thanks,
Aboorva

Aboorva Devarajan (1):
  selftests/mm: fix exclusive_cow test fork() handling

Sayali Patil (2):
  selftests/mm: allow PUD-level entries in compound testcase of hmm
    tests
  selftests/mm: remove hardcoded THP sizing assumptions in hmm tests

 tools/testing/selftests/mm/hmm-tests.c | 86 +++++++++++++++++---------
 1 file changed, 58 insertions(+), 28 deletions(-)

-- 
2.54.0


