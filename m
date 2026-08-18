Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A292EC5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EE116B0269; Tue, 18 Aug 2026 06:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C63A6B026E; Tue, 18 Aug 2026 06:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4BB6B027E; Tue, 18 Aug 2026 06:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8506B0269
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:57:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4EC0A38FC
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:57:29 +0000 (UTC)
X-FDA: 85114089018.28.610510B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id A8463180008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:57:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Zjb40BHd;
	spf=pass (imf16.hostedemail.com: domain of partha.satapathy@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=partha.satapathy@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787050647;
	b=8dX69xp//Q5j8ztt7lKwN2UXsyma1bFy/h/oXql2WCMxk5HpFnOCa5MO9sOJqz4UkpvE1e
	E44dP0kp2RzH3NnTe0NvocTAOkpqM4y0GQGjsKuhyQwHmbTVUfsZlSC91wCxn3u2hqNAVT
	ZTs1Ny38nsXJ5wyhNv+2T5AcCWOI+qk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Zjb40BHd;
	spf=pass (imf16.hostedemail.com: domain of partha.satapathy@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=partha.satapathy@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787050647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0nK619oH055xfiFRv0DZruv2pXYKbGXNEKIYYCpmElw=;
	b=f8f5eSh0qdUqVeIKOa5tV2lrrOG9OObhPogEQbsLwaIEB/V1yjwkYZ4GkEE3bs7VSiVICO
	Qx+aHFxGJ2iJ+hYT3JnwJv7HD2oBS4nY4cgs0t18UJfB4IKRqQVgkmJHwFOQJN/mODc1aJ
	q1CHdklXjGzZhYNuiOOcz4ISO+AP0IY=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67I9gAsB1893430;
	Tue, 18 Aug 2026 10:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=0nK619oH055xfiFRv0DZruv2pXYKb
	GXNEKIYYCpmElw=; b=Zjb40BHdWbVKV8FIqjqiDAP1uS66tjX/k+RWRVDj77DwZ
	GkbzG3+8HeFfy6+NdOgS4mIyaHePSHH5Hkfv41hBuzIb+c6XjdxVHs9wPXgvGYQX
	7jr8Y5n5P4ALlPmVP6o5gGrORafjPnSiyjO8wHZ9Q63vLSo/W06l1/cLiEsWjsTg
	6x3k4aio5pM/EjaPUAdTXsi2N7oIkW2tFlYQnLNU8qSsPAfDGge5/f9lYeDA7B/3
	iKcatkH13Hct+c8Ig13MQLHWsrAsfOOi+Lkth6aeeextXoaSKimODILpjdRInMsC
	wIl9OnMYp7N/6foq3W5FheOhKmX+gRGYbz5Y6FJ8Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2f1bvm3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 10:57:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67IAtcVo005487;
	Tue, 18 Aug 2026 10:57:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejqgupm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 10:57:14 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 67IAvDKL014439;
	Tue, 18 Aug 2026 10:57:14 GMT
Received: from pssatapa-ol8-test.osdevelopmeniad.oraclevcn.com (pssatapa-ol8-test.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.253.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4g2ejqgupa-1;
	Tue, 18 Aug 2026 10:57:13 +0000 (GMT)
From: Partha Satapathy <partha.satapathy@oracle.com>
To: linux-mm@kvack.org, x86@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kees@kernel.org, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, partha.satapathy@oracle.com
Subject: Question: can normal mmap placement leave a small grow-down stack gap?
Date: Tue, 18 Aug 2026 10:56:55 +0000
Message-ID: <20260818105655.798233-1-partha.satapathy@oracle.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-18_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608180080
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDA4MCBTYWx0ZWRfX/t5NFDUYajyJ
 zmuWMqwmb2oDcbZaua1CSaR8n5JGyY8un1EX/gVVWPMzKgl179dsE8QIHxp5/TEW2n1BNbKSiXw
 agVTTyXhLPOqT06fV/NJ0q5H3zxdsiaBwzzLVfm/gYOd7n2eB5XJqL3LCXPVPbEcaWtelJ0/LdS
 aLDjZbjvGXbHAi5FQR2/3sFciDa2GPdCBu9fZRjzAnLEl3S006EWuqPR9IZB1AfprOr8uD4NPVx
 Fa29bpGcu/0s0sOsKEAdIVa5vyXXK37m/My807jtgGSsyBeDt91Fg+Esz9gqXju5h4ER051+uIG
 55lNSnYYwJ75k2pAaCU5iC7LPc+1HvEPsMAWnmMHob4Pv1HUViDuG4Ks/oBi+6bZC6p8SMHefII
 Fqq7tswlZPLKwJ3WF/6Q8nV5ZIN9+tAeZdK1Jkr8GfczohiQzjJXtPgRbxYXgvieRrLHMecjCuu
 LcnKk8C6NJD6CwKkqcjpMv3/3ERZ0kWtMPGn5QVE=
X-Authority-Analysis: v=2.4 cv=D/937PRj c=1 sm=1 tr=0 ts=6a843a8b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=KULDcwzBvU2pphWSv1cA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13509
X-Proofpoint-ORIG-GUID: DxqThsgD-F7JQ34ah5GU2opNZJB8CA9-
X-Proofpoint-GUID: DxqThsgD-F7JQ34ah5GU2opNZJB8CA9-
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDA4MCBTYWx0ZWRfX/R0a2bWQ/sy5
 DPG7rgC8yrGOtUmWgarR0IQo5VDw/FkR02l80wjlp/WlznIRFv/sRTdvmr+YCWQxhusqCircRyc
 hS6m+gHI36FKsm+yY9pF9twKsKNFY5BZLmeiVj3xeY52haupcEwr
X-Rspamd-Queue-Id: A8463180008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: acdo4bzdyzxb9ht1ds4qyaraiizbkti7
X-HE-Tag: 1787050647-161457
X-HE-Meta: U2FsdGVkX183ZqU05t0Ip1+RD5WJg1zbIUX2rYCngGOvd8pzp25XRL1MCXBHRmxPo5RBVx2oZk4ZQhj9vi3Z9v6uXkCUJG2bjjaTPIc2c9t8tDlZ1kbfdcf59fmPm11a2qFNT7+l7fmb7KApY8zT5VMX7MM4C8ZXhMSA9q2TRrtjSSe0Qna8sj6md+o3umfauNXHXutLphSxs5T0nId7+65JiOLVt+JuuKljduxfaxP5ojR410Wils0ryh72TNt8rtzcR6ECL92Fa2QGqvDpGv+/YihzpqBtI2HATDRlfes0Gn/ai+wWGD6tEcnOkZ13uJ8z0NcIDdM1tmlSthjdKqdP1eBnV9Q13nyro0tbzzYDzJLFjxKnXCFEBY0tibylQRUn0bL5XlJqZPzRWIbq/oG/5KYaY3usG3MaUBsssUVrT6L1Khe7CqSQ1K44t4Au4rmADH5ZafGcZItL+CVfVq40KtslQYBCMRXPYVCgRWw5LIQCivTnA83wBlchKSmxe53H3boZRbm/TUhA5MZJWRtyGhcUBmNkEtwZO+m6MokaJrKNBMNUh7NOXU2IHPoC2CuPAAT54eTiwUEuszYMJiKr0IIJdoWVeYl3k14gaBZBp/QemNAxOuhSdwLYAZw+XYRl0eyaVposx1t5g3xnFT10faflqscHofG7dTtTh6nGJQhmUEbv1sSxh/pV6Xd2yVkkj9NCP9c0FbZepegq5RnfsbgfX2cbHzbJw5tjEHcYFZhPAbnohrhfri8yq0RjTW81ajtlzlsdJltBKFmlNGOYm+9Hs7AEWJwrgFYA+tyyWHekEmK7hNDOWDztgn5BsvZ4cWXdeDlo2UfvTy4a1ufOzPWqVjqaJPMeCOb0eudQ/a59w+sREyVuiF9q2SQz+t8jlQIPerut2cS+e9xgIKsP07p/34hdqltRYTLt74cTMd9YGxYMguiz4gHfoPMt6k30ySwdW9JOpendzCb
 epbyrvD6
 sMzouFtkECrJvj6PDKrGjTOU6dWJuu+vBv+LNRr2ERvStIGkcPaFCBjsovDjgbl+fYq4lGlXQxm0pW1mGVfzEYXZ6IK5LCkoxd1XLp71XPCvbHCq3aDVG+VBuR9RG4t9HSX5JlzvJ4xozIcE1t1Olv14AMyhvKoHTkeQs+jONl5pydMAxLrVgA96so0DyXJnrvkPbA/WmF9xcgRKnh1AOIqsb8l+FNfjMqzY+AQw7lhhvGJSS5wmu3p1C+6+5V8vwDwhMuG20s9ywS0F1d3OkvkLAnfZ9ppO+FaeqvBf5C3GqvKkByqCi0BFU72iqg21cuGo6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

We are investigating intermittent user-space SIGSEGVs on Oracle Linux 8 UEK:

  5.15.0-322.203.3.2.el8uek.x86_64

We realize this is a downstream kernel. We are asking for guidance on the
expected mmap/stack-layout behavior and on a small standalone testcase that
could be run on an equivalent system and on current mainline.

The affected process had:

  kernel.randomize_va_space = 2
  vm.legacy_va_layout = 0
  vm.mmap_rnd_bits = 28
  RLIMIT_STACK soft/hard = 32 MiB / 32 MiB

There were no boot parameters disabling ASLR or selecting a special mmap or
stack layout. The process personality was not captured during the incident.

In one failing process, the last librt VMA ended only 308 KiB below the
initial grow-down main-stack VMA:

  7ffc2e5fa000-7ffc2e5fb000 r-xp 00208000 fc:07 1572970
  /usr/lib64/librt-2.28.so
  7ffc2e648000-7ffc2e669000 rw-p 00000000 00:00 0 [stack]

That is:

  stack start:            0x7ffc2e648000
  librt end:              0x7ffc2e5fb000
  gap:                    0x4d000 (315,392 bytes; 308 KiB)
  fault address:          0x7ffc2e6472a0
  %rsp:                   0x7ffc2e6472a0
  %rbp:                   0x7ffc2e649320
  fault below stack:      3,424 bytes
  szingroup frame setup:  sub $0x2058,%rsp
  faulting store:         mov %rdi,-0x2080(%rbp)

The fault occurs during setup/use of an approximately 8 KiB stack frame, on
an access below the current stack VMA.

We understand that RLIMIT_STACK is a stack-growth limit; it does not reserve
an unmapped 32 MiB range below [stack].

We are also aware that the initial [stack] VMA is not expected to be 32 MiB.
For these processes it is initially about 132 KiB, which is normal: the
kernel expands the grow-down stack on demand, subject to RLIMIT_STACK and
the applicable guard/growth constraints. The concern is not the initial
132 KiB mapping size, but the unusually small gap to the adjacent library
mapping.

In the affected UEK source, stack_guard_gap is initialized as
256UL << PAGE_SHIFT. On this x86-64 system this is 1 MiB, and no
stack_guard_gap= boot override was present. One hypothesis is that the
faulting access required expansion of the grow-down VMA and that expansion
was rejected because the preceding VMA was already within the applicable
stack guard gap.

We do not have a reliable reproducer. We also cannot obtain an exec-time
strace or otherwise instrument the production launcher: the issue is
intermittent and occurs in customer environments. Therefore, we cannot yet
determine how the affected shared object's overall load address was selected:
ordinary non-fixed address selection by the dynamic loader, an address hint,
an earlier reservation followed by MAP_FIXED segment mappings, or some
process-specific personality/launcher action.

We understand that MAP_FIXED calls used by the dynamic loader can be normal
internal ELF-segment construction after an initial reservation. A testcase
that deliberately creates a VMA near [stack] using MAP_FIXED would demonstrate
the expected stack-growth failure, but would not explain how the library
mapping reached that location.

Could maintainers please advise:

  1. With the settings above, should the ordinary mmap(NULL, ...) /
     get_unmapped_area() path exclude the effective guard-gap region below a
     VM_GROWSDOWN main-stack VMA?

  2. Are there known mmap-layout, exec, ELF-loader, or personality paths that
     could produce a library VMA substantially less than the 1 MiB guard gap
     below [stack] without an explicit fixed mapping or address hint?

  3. Can you suggest a small self-contained testcase that repeatedly execs a
     dynamically linked program with RLIMIT_STACK=32 MiB and detects whether
     normal loader/library mappings can be placed unusually close to [stack]?
     A test based on MAP_FIXED alone would not answer this question.

Thanks,

Partha Sarathi Satapathy
partha.satapathy@oracle.com

