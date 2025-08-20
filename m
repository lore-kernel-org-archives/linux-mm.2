Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3609CA0EE6
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C736B00C7; Tue, 19 Aug 2025 21:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E656B00C8; Tue, 19 Aug 2025 21:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D15D16B00C9; Tue, 19 Aug 2025 21:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B948F6B00C7
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BE4C16017F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:28 +0000 (UTC)
X-FDA: 83795342736.06.D98A694
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7F8BE140004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=chnHnyYj;
	spf=pass (imf09.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GQmlN9LOVzic9ck/xp65PGIqSqPMNjfJbjfxs1Golw=;
	b=AM4uVDs8grcfoponRjSt3hU1GmK6ciKJptrEVYlq76j+rylG5sC8e+mURWgtGyrhgZo86M
	3s1HY/m166xo8ePKxpuWxY2dICpSA/pIV8HIwmJTQnYkPecP1zMsFx7W4UTVv+EJLFOlAK
	1Wby3eeKAKuDhARUTS/S/oSr5cEDArM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=chnHnyYj;
	spf=pass (imf09.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651926; a=rsa-sha256;
	cv=none;
	b=JsGzNJrh0fgYnlGU7jhPT597J8qr9I3/oLaPg6w905fCeHvl+L/VPIru41aMyAPDJUEvcu
	V/HGSlFY3EKFNNvkW9IgHeTWSyttHBYvuITmagv3hXpkRMR0nduecAk4QG39zJOgrgPr+j
	+Gm5jvngyCVEuigp0OewxFZcY6dQtUk=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBnPa004722;
	Wed, 20 Aug 2025 01:05:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=1GQml
	N9LOVzic9ck/xp65PGIqSqPMNjfJbjfxs1Golw=; b=chnHnyYjWp3wkGD/CgOcz
	HpMSyBe+D8D4mAl/U+Okemx3m4NJsii48co+UswncZILIkGBCJAJn+dL4YDQuLJX
	K34CQ7OAEt2ZeJdpDfqttt1n5G8n/ACBg6+1xxfj/2XvZTdTFoGeQ0IP7MJ0vBOG
	bkypU4RjidEKGQsRZEs35DkR71C0IU5b95FENFjQw3R/eHx1HdSiuDa5NCZutCCc
	VXPdFSrabZc/k3nN96p+9InV+33tItDwMhW0IrX41SVR0dLBYw5KME2ic042jQEq
	kRXexCsjU0a/DYjnSw/hZEgws4ec1kw7rE0Bqc1bkhAuyUn/p91h9TLmwi2VI4zj
	A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tqr8b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNWYJX007314;
	Wed, 20 Aug 2025 01:05:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q2a20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:01 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14NdW011685;
	Wed, 20 Aug 2025 01:05:00 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-15;
	Wed, 20 Aug 2025 01:05:00 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
        bp@alien8.de, brauner@kernel.org, bsegall@google.com, corbet@lwn.net,
        dave.hansen@linux.intel.com, david@redhat.com,
        dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com,
        jakub.wartak@mailbox.org, jannh@google.com, juri.lelli@redhat.com,
        khalid@kernel.org, liam.howlett@oracle.com, linyongting@bytedance.com,
        lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
        maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
        mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de,
        osalvador@suse.de, pcc@google.com, peterz@infradead.org,
        pfalcato@suse.de, rostedt@goodmis.org, rppt@kernel.org,
        shakeel.butt@linux.dev, surenb@google.com, tglx@linutronix.de,
        vasily.averin@linux.dev, vbabka@suse.cz, vincent.guittot@linaro.org,
        viro@zeniv.linux.org.uk, vschneid@redhat.com, willy@infradead.org,
        x86@kernel.org, xhao@linux.alibaba.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH v3 14/22] x86/mm: enable page table sharing
Date: Tue, 19 Aug 2025 18:04:07 -0700
Message-ID: <20250820010415.699353-15-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250820010415.699353-1-anthony.yznaga@oracle.com>
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_04,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200007
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXxdI9l8NKIh8B
 mJjG4HXLfqqFSvIWISLSu1cTPVGpy6ji5M8+A4xbOEXv5aL/rW8vKlN8CEnBcxOihMsWKnPvqyB
 ylOR9qePixVQGRrdHcgkCYEHggTsh+zrdXo//cv4ctsTGP9nZYBwonptZHHskbQHJNiQl2+xrJW
 bDhg6SSZmFhoDdB5NfKy6bN5oWd3F4drhrDhneMKS2LOOTSVmbbu+rxjFolTv/7e4Z4/rdUNW9z
 0uREjatAweDePwVOuGMaZgzFin8b7bnAFKMBzHzzR3l5Esrz4Qegf/wYm7Gkg8JVSSveeufgMSR
 MJ3e5inmMBZcYPUfWKES0bNsHknLdNwm02b9ualxapGaDbpHvbvpc1sdLI1XVRrX+eS8V1Qj96A
 og3snhv4YHTn3vfm3uLGvloRzpBRcA==
X-Proofpoint-ORIG-GUID: YSu3qm5PcULgkW0gS9e9Y7497HnEs1OT
X-Proofpoint-GUID: YSu3qm5PcULgkW0gS9e9Y7497HnEs1OT
X-Authority-Analysis: v=2.4 cv=K/p73yWI c=1 sm=1 tr=0 ts=68a51f3f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=yPCof4ZbAAAA:8 a=H1hRpGHkK2FX5b2Ra40A:9
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Queue-Id: 7F8BE140004
X-Rspam-User: 
X-Stat-Signature: j5wuohhbkddhutybyn89cjtt4drkn7pk
X-Rspamd-Server: rspam09
X-HE-Tag: 1755651926-509455
X-HE-Meta: U2FsdGVkX1+8LKFx5KQt2bUFqlUUO/mjg0LbtcslNDvhBWdKCiZE2T6vGODQfMn2phAvRDFkEiMPiqvF0kIqsAjVAiCCMCwkPyiKdVFCHqIqTp7/SCzyIA3/LcWTJOPUKafcpfvtTTdd8h3QPbZEfFSS8lhK0bbLhUxqHJuYTg8zxSdnIcrlHKynZFDUDQBq8lWKIx73SuVs6It/pWHgfZ47nrgy5I62T76zdSBXcjHRq8R4LjRbara6DjZHEqf21+w37dDPvR9GvPrY6NWY7o2f2i0koL5h3YsjASu6xyOypiDjKXFMWd6mhrVdkoLziRmdtagUCMSq5Dy1qbMHcbRgDAbCc9ZZYYATXn0E5Y2CA9ulDIXFtMmoWzWxGRuJFzL/oCjy3mbySaACEbtyEHcwiXrhTplWu2z2JGrOIQBGHAfl+c1RR6JN1VOsEEN61zuyMEGxGk3folOfA+XwjLWUBFldMxo/A+53jZayuSA0OTDyPUcJ35mqRgeIa9IgjFmTHQuMK8WnMUCchmdu+aenT4OnO2Zmgs7q+gABg+N5w2tEXguhdK2jZU2bgVxE5JJpJs3SiDgrKuw4Xey6bS0XKOnyGU9zC24t1SsCA7B7lq8SEaU452vKDmoGE/Gt73OWdDeNZKJ/i7sXMKsWgC+/bT0oxkzoIa6EN44twrhCt9kLeMjmSbYIy7+n/llacB2zkaSiQCTq9MtSZMe9SO0JnzP3Ep1bf52BWC4DU/7TJcuxGfCsD1N4xpbr9cVnhdwCL+XeB1WDYLZKvy2AvcYy+IIsvFcWA8GZ60Zanfb2R6Vq5d6EiWglg6weodXekkCd6TfTFZFnbFZ333KY+7jY5j40s7nMsYMXFw/fVVD1bfXYHdr23YAG/SA5fSUROpPesRsbbdx4elWUT2O1NFJu1rqs/tnsxyWkGqY+PFAs2bU9HGPlPAE7/Av8FyFNPDwFKd+wb8I5NH0f0fh
 1o1TqXJ8
 /kkDSoTtufo/KHISsiVO496RtwDYt3u+ADlHUI/PYBhH7CK8g/RgQHlRURrpFOWmxY1Owiy0ICmipvDCPwBEBeIyMIay31b/wlcA58gzA0h+GwdX4bAucP7eib+CRagTb7ocqG3WwJ4mnk1ndafZYYGcQJoUFqDMup3D6ttrmwHwCcY7a6pG8uOgsfh7my5U7BYsVJeaS0m8+OGmrAKBUW640NA2JXqFhAAbfli5JOKBR+EE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable x86 support for handling page faults in an mshare region by
redirecting page faults to operate on the mshare mm_struct and vmas
contained in it.
Some permissions checks are done using vma flags in architecture-specfic
fault handling code so the actual vma needed to complete the handling
is acquired before calling handle_mm_fault(). Because of this an
ARCH_SUPPORTS_MSHARE config option is added.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 arch/Kconfig        |  3 +++
 arch/x86/Kconfig    |  1 +
 arch/x86/mm/fault.c | 40 +++++++++++++++++++++++++++++++++++++++-
 mm/Kconfig          |  2 +-
 4 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index d1b4ffd6e085..2e10a11fc442 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1676,6 +1676,9 @@ config HAVE_ARCH_PFN_VALID
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	bool
 
+config ARCH_SUPPORTS_MSHARE
+	bool
+
 config ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58d890fe2100..1ad252eec417 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -124,6 +124,7 @@ config X86
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select ARCH_SUPPORTS_HUGETLBFS
+	select ARCH_SUPPORTS_MSHARE		if X86_64
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if X86_64
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
 	select ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP	if NR_CPUS <= 4096
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 998bd807fc7b..2a7df3aa13b4 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1215,6 +1215,8 @@ void do_user_addr_fault(struct pt_regs *regs,
 	struct mm_struct *mm;
 	vm_fault_t fault;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
+	bool is_shared_vma;
+	unsigned long addr;
 
 	tsk = current;
 	mm = tsk->mm;
@@ -1328,6 +1330,12 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (!vma)
 		goto lock_mmap;
 
+	/* mshare does not support per-VMA locks yet */
+	if (vma_is_mshare(vma)) {
+		vma_end_read(vma);
+		goto lock_mmap;
+	}
+
 	if (unlikely(access_error(error_code, vma))) {
 		bad_area_access_error(regs, error_code, address, NULL, vma);
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
@@ -1356,17 +1364,38 @@ void do_user_addr_fault(struct pt_regs *regs,
 lock_mmap:
 
 retry:
+	addr = address;
+	is_shared_vma = false;
 	vma = lock_mm_and_find_vma(mm, address, regs);
 	if (unlikely(!vma)) {
 		bad_area_nosemaphore(regs, error_code, address);
 		return;
 	}
 
+	if (unlikely(vma_is_mshare(vma))) {
+		fault = find_shared_vma(&vma, &addr);
+
+		if (fault) {
+			mmap_read_unlock(mm);
+			goto done;
+		}
+
+		if (!vma) {
+			mmap_read_unlock(mm);
+			bad_area_nosemaphore(regs, error_code, address);
+			return;
+		}
+
+		is_shared_vma = true;
+	}
+
 	/*
 	 * Ok, we have a good vm_area for this memory access, so
 	 * we can handle it..
 	 */
 	if (unlikely(access_error(error_code, vma))) {
+		if (unlikely(is_shared_vma))
+			mmap_read_unlock(vma->vm_mm);
 		bad_area_access_error(regs, error_code, address, mm, vma);
 		return;
 	}
@@ -1384,7 +1413,14 @@ void do_user_addr_fault(struct pt_regs *regs,
 	 * userland). The return to userland is identified whenever
 	 * FAULT_FLAG_USER|FAULT_FLAG_KILLABLE are both set in flags.
 	 */
-	fault = handle_mm_fault(vma, address, flags, regs);
+	fault = handle_mm_fault(vma, addr, flags, regs);
+
+	/*
+	 * If the lock on the shared mm has been released, release the lock
+	 * on the task's mm now.
+	 */
+	if (unlikely(is_shared_vma) && (fault & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)))
+		mmap_read_unlock(mm);
 
 	if (fault_signal_pending(fault, regs)) {
 		/*
@@ -1412,6 +1448,8 @@ void do_user_addr_fault(struct pt_regs *regs,
 		goto retry;
 	}
 
+	if (unlikely(is_shared_vma))
+		mmap_read_unlock(vma->vm_mm);
 	mmap_read_unlock(mm);
 done:
 	if (likely(!(fault & VM_FAULT_ERROR)))
diff --git a/mm/Kconfig b/mm/Kconfig
index 8b50e9785729..824da2a481f9 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1402,7 +1402,7 @@ config FIND_NORMAL_PAGE
 
 config MSHARE
 	bool "Mshare"
-	depends on MMU
+	depends on MMU && ARCH_SUPPORTS_MSHARE
 	help
 	  Enable msharefs: A pseudo filesystem that allows multiple processes
 	  to share kernel resources for mapping shared pages. A file created on
-- 
2.47.1


