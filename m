Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52186C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A3B56B0098; Fri, 31 Jul 2026 13:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9542B6B0099; Fri, 31 Jul 2026 13:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842976B009B; Fri, 31 Jul 2026 13:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 512666B0098
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:32:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72A621204BC
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:14:06 +0000 (UTC)
X-FDA: 85049719692.06.B09AC7F
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf09.hostedemail.com (Postfix) with ESMTP id 63E1C140003
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:14:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=IYL35imN;
	spf=pass (imf09.hostedemail.com: domain of "prvs=6672d603c8=jalalonde@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=6672d603c8=jalalonde@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785518044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kdeIhjfSOkilQ5v8Y5Sd6MikyWpbswAMtxTRGM2ZTbE=;
	b=HixGx4spqDPDD6DKTUyZEbZUL0teagjF9iK8fgOeAuCMs0Buc0AAcmNpYNQS9KtpOedMGX
	QQeVkRs8biSnzE3AbNItnh0fP8bdqcVqpDdyadhaLpfMme1QPoyIiDRMT1+xHVvtFZva9U
	Qr+u20Lq8gkKpk3C4pL95WkEZYovf20=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=IYL35imN;
	spf=pass (imf09.hostedemail.com: domain of "prvs=6672d603c8=jalalonde@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=6672d603c8=jalalonde@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785518044;
	b=T7iZ7EkXJIj+mzl9JxdAt+qBGnf6eUfa3PEBXk4Wj25BQ0TQk/DmReiDRPjj3J5F7UBxCV
	JQHi1h+OjxOl6L2tF4Oekk297+MgsvWcXeJhAmlcBufFc7JRGkloClRtvsl3LU7CjzyuV/
	zTzoWwdHB4nRpGwGdoFab6CQ9lA58oY=
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 66VGWkwQ1453370;
	Fri, 31 Jul 2026 10:13:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=kdeIhjfSO
	kilQ5v8Y5Sd6MikyWpbswAMtxTRGM2ZTbE=; b=IYL35imN6IguiGsZTDs9vpw8M
	CTZ0KM7ONDj6XGoPHVlv4/3Ps0YUr6+WMMVlZ35sIqth3dTSev7jKW2ELKJCmsRZ
	Il36Y7JibEgNst0xtTZRGJBf/B4kluBqxC1uKa4oq6NIoihiUhh3fyBw7B9DSQwe
	h0QUN0f3mq2Y9KiQ1mNuujV1VxyAMzFc27z8EiWPttTSoB61Bhe2/UqYUKlb90Mo
	6BfGreOAWRUEY3rnlUalvgPOdhwSviv+uxa66CABnLoU87sTM6Rnm/aNxAumyQk/
	48KienAWyFjca4o7+AmxVX1ZmHrpUIBM2lPHg500CZSXK1lHzDTt+kc0Nz8sg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4fqrmdxcky-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 31 Jul 2026 10:13:47 -0700 (PDT)
Received: from localhost (2620:10d:c085:208::7cb7) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.45; Fri, 31 Jul
 2026 17:13:46 +0000
From: Jacob Lalonde <jalalonde@meta.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner
	<brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Lorenzo
 Stoakes" <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        "Vlastimil
 Babka" <vbabka@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Suren
 Baghdasaryan" <surenb@google.com>,
        Michal Hocko <mhocko@suse.com>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: Omar Sandoval <osandov@osandov.com>, Jacob Lalonde <jalalonde@fb.com>
Subject: [PATCH] coredump: add filesz truncation and filter
Date: Fri, 31 Jul 2026 10:13:36 -0700
Message-ID: <20260731171336.2255844-1-jalalonde@meta.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:208::7cb7]
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEzMiBTYWx0ZWRfX4w+XxcM+46Dk
 zGTSWs80hd+P++WHMQhYhYDWV4g3gm9TEhbcaGGIPIKLyjhZo/PT0MLiaKvTd+gxcqnCEMNoTOl
 4rb3z8+tBLPed6wYeqnM1acZpSeogds=
X-Proofpoint-GUID: QgAO7R3JxY9qJrdotLFPqeZMAf55nRd4
X-Authority-Analysis: v=2.4 cv=YK6vDxGx c=1 sm=1 tr=0 ts=6a6cd7cc cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=855S8uPTkML1Oy45N9_h:22 a=FOH2dFAWAAAA:8 a=3_ptNkD2o4TX9xly_T4A:9
X-Proofpoint-ORIG-GUID: QgAO7R3JxY9qJrdotLFPqeZMAf55nRd4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEzMiBTYWx0ZWRfX/oluRmmrt1kW
 jcAO5sVhJytf4812ybpH7wqZKxxpBXcbx1edFNKtTMcnjiGd0aHpy6r5vJWNvlZipZ9T8J/D1pN
 wzG6CKfAaewFtkgd8rZ/SyOK05zZUaDBCqON5CHOAiCQu6fdt7crMKX6P7TQzcrYzmyRR3ReMYt
 pMjrbDUEWntpQx9JKKGDtBU9X/6Lak75MFenP8BF+9HJ2tnXcPiBgUKwPWTihCMGw9TxKwvNPND
 hqVRjQH2+/Cll8eCDXOG6sSuha5He5GTjvd+gyJz38FqnGJAuqchwmf8M+syHTzzibH3hM1ttKv
 KCkFsTCBxdr6pCJf2h2skn2Visl9DqkdfFsT1vKDfmRjd2nPB+vyUrRZrBhJNSVIfZMTfoxszJ/
 iYEQPOAtRjyXmNpH6ZEBb3D7jolzjJvX+DcXZ7R7HjyTduKIUUqHMMNW1LRLCWk0dOahKeOGM0A
 YyJc6cOoWinqAMOUbRw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Queue-Id: 63E1C140003
X-Rspamd-Server: rspam01
X-Stat-Signature: h3pp34aa3yqo8nzs6cdgmz7rwrxc8j8p
X-HE-Tag: 1785518044-199803
X-HE-Meta: U2FsdGVkX1/5zIAhFK9fK763aAd00qLTuIRbaYyYsbru9TwLb++FgMZXphD0MR5QnsVMalUQuuD6dsj8EKKMxBzwmBGnUFVP3ep7daMJBdoD4fWN/ark9JzE9OFnMxoXr/Ju4Me3CyJejE5JHm9sNE5MO39WZUEAF9HRFvms/1El17ifRFANEftntCPMc9kIkv9ly4lr0/JwIAlrbN8VUNRplKG7vZzCHZt94FOt3AewxndzepDiOvFLhQK0JitNdVF45GkZIZcEoGq+cPdiOaeFPVCVXjhWVx0H4A7h/ntFuE4FLb7TPkqIyKr1VGTnx7Vp0jq/Ah7/Yyk7uRs1YERAo9Bssxm2+3B698EH0SfdgMjIEDH6DeR2dMkJHYCaLE8C67ZujO108NEcURXIaeOlLLVtkx5ml50RaG1B2zVe5dHHT2ME99yud5/T1NnmRb1x4BJY+Oi9nawWB/uIgvoaufc257Ddvpe0f/dmpg6rFNsNb11H7QFkGCAMWugYl+wBa+nQJWhiMWp0raLku7xJnmnEC1KTjU0mmDKAp8PyhiK374204kLDVnkyfSlcQSI6TxBPBf20YJNrEzsiSm31g3HjVFdca+zXPmCjckBd32ynAN7FtfypArqvy4ck38bRMmlya63sOZ3q1AmUqcZxgP+sXPTaPRfIHhQUz5ZHCtoJ1CWewWPAmLWgBpe1A137rreJLoM2++ZAnipWJqvu3oakMRh69yfU/QDqsmkx2Cx6FiF/OoPtZmUh9+6WrjGLfiykNs3EWcwiBIjZkw3X+Xes7AAE/reEdxhfFu3dSbEKjatsp49FF0Jv/fb6z26vikA0QP+HJl96FX9dJqzwtBL2ffVhIOBV9c8jBb6v5cYxdBHt6FmDHmiP35YxYELRH5S0Zz/Gh72D90d+brcwHda8D90HvOtl8+6w6cSMSZUgU8KuFMAUTrti7cEBXsWgbO67HBeBGKg7Rma
 6KNi/psD
 Hi5NrJEElF0DhvgWEXzcn9B3BO4jN1YwemypCzm3VbU/wwTMXs9sJTYkDbF9NDeuk/TmsHBPQJwWYDkapo4xbcwKu5jzIP3SDtPGH49/nPQAlGTWmlkRKO9TKrvZEXI+WUnzLg0KNUb8HBRxMV9w/SPEhs+Dyo73dVsTQvHcOn5WgEipOD1Uw9cYt3pLX2SRuPtFI4MDZVw/owM9jBTin20sc9qhouClSqlrj68UE5BEebo+jND2A4kA2Sv04rKLfpilCf8VIZQtYsON+Do8Gt73SOoG2Oal72alIA+lxQkPU7IvvHy42/B+Fy2a5N+5ekXgJpDnYhOPjdUOsCBP6YbaIbTA0ZLCCCA658rBYAYuYQSh+f4el/ZzEF0Ib8zfzBzvLnsTbjqUWZDYLphXe0YkzvBJdIjUv3cQR9Z1USCMIvG5iXWQ587FAWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jacob Lalonde <jalalonde@fb.com>

This adds opt-in truncation of Coredump segments to
`/proc/pid/coredump_filter`. The primary motivation here is to reduce the
number of zero pages written via pipe to a user space coredump process. In
my testing this reduces coredump size, and thus IO by ~40% at Meta. With
some outliers such as PyTorch's TBE weights being loaded in right before a
crash being closer to 99%.

We achieve this by having the Kernel not emit the trailing zeros of any
VMA, resulting in a PT_LOAD with filesz < memsz. I verified that both GDB
from v16 onward and trunk LLDB support loading cores with truncated
sections, however LLDB won't report zeros for the truncated region

I elected to iterate page by page for simplicity, and because we
short-circuit when encountering the first faulted in page, meaning time
spent iterating should directly replace slower copying and pipe IPC.

Below is an example program where the entire 1 GB VMA would be emitted,
where as with the patch only the first page would be written.

int main(void) {
     void *p = mmap(NULL, MMAP_SIZE, PROT_READ | PROT_WRITE,
                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

    int* p2 = (int*)p;
    /* write a sentinel to make sure it's not fully sparse */
    p2[0] = 0xDEADBEEF;

    abort();
}

Signed-off-by: Jacob Lalonde <jalalonde@fb.com>
---
 fs/coredump.c            | 44 +++++++++++++++++++++++++++++++++++++---
 include/linux/mm_types.h |  3 ++-
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index e68a76ff92a3..b6cee412eb99 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1588,6 +1588,42 @@ static bool always_dump_vma(struct vm_area_struct *vma)
 
 #define DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER 1
 
+/*
+ * Truncate the file_sz of the VMA to the last faulted page
+ */
+static unsigned long truncate_vma(struct vm_area_struct *vma)
+{
+	/*
+	 * Same logic as dump_user_range, where we enumerate the pages
+	 * in a VMA, but instead of skipping un-faulted pages, we move the VMA
+	 * end
+	 */
+	struct page *page;
+	unsigned long truncated_end;
+
+	/* We're already under the mmap lock */
+	int locked = 1;
+
+	for (truncated_end = vma->vm_end; truncated_end > vma->vm_start; truncated_end -= PAGE_SIZE) {
+		/*
+		 * Because we're iterating backwards, we need to
+		 * look at the page before the current address
+		 */
+		unsigned long probe_addr = truncated_end - PAGE_SIZE;
+
+		page = get_dump_page(probe_addr, &locked);
+		/*
+		 * We hit a faulted page, exit
+		 */
+		if (page) {
+			put_page(page);
+			break;
+		}
+	}
+
+	return truncated_end - vma->vm_start;
+}
+
 /*
  * Decide how much of @vma's contents should be included in a core dump.
  */
@@ -1662,13 +1698,15 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 		return DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER;
 	}
 
-#undef	FILTER
-
 	return 0;
 
 whole:
-	return vma->vm_end - vma->vm_start;
+	if (FILTER(TRUNCATE_SPARSE_VMAS))
+		return truncate_vma(vma);
+	else
+		return vma->vm_end - vma->vm_start;
 }
+#undef	FILTER
 
 /*
  * Helper function for iterating across a vma list.  It ensures that the caller
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..18cf8304f698 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1932,9 +1932,10 @@ enum {
 #define MMF_DUMP_HUGETLB_SHARED  8
 #define MMF_DUMP_DAX_PRIVATE	9
 #define MMF_DUMP_DAX_SHARED	10
+#define MMF_DUMP_TRUNCATE_SPARSE_VMAS 11
 
 #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
-#define MMF_DUMP_FILTER_BITS	9
+#define MMF_DUMP_FILTER_BITS	10
 #define MMF_DUMP_FILTER_MASK \
 	((BIT(MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
 #define MMF_DUMP_FILTER_DEFAULT \
-- 
2.53.0-Meta


