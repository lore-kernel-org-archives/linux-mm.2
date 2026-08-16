Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33911C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0EE96B0893; Sun, 16 Aug 2026 18:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9BB76B0895; Sun, 16 Aug 2026 18:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62316B0896; Sun, 16 Aug 2026 18:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 964196B0893
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E5091A05E0
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:28 +0000 (UTC)
X-FDA: 85108620576.22.08558C7
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf17.hostedemail.com (Postfix) with ESMTP id 29F5640003
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U 8DMpup";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Ne2vpsJ2;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920446;
	b=QfVtlHlB4hNp4DwHexxVwGut+ChJW6oYc3u5tUyo3y3hTRsqZkRYyQ97+XmYmAooTu2oe0
	ooJeratIQjx6jf91jb+6GpjrxJqJn+L5bfNXvzTFhx3wU+joSsHw8rHyxOZ+urBK31fJFE
	f9n8HbVxWjJXjYtDJtvE1ZpHykQadis=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U 8DMpup";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Ne2vpsJ2;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQDVLS5QXQD8PSUIRmPFOeq1RPNNLBEX8FtCDNd5u2M=;
	b=fbJOyrdhkV2v9iaWjX09COOGmr+KD5z8V8ZvkztBnPLzb37x8Mmqg3Z85yExow++omrUFO
	db5xexwqrsq4aSBEdYpI2lCMXTbquE4CHxVIGolYSecwwCY3wi1+Rdo5fkPXKGhc/+lmc4
	cM81tnhqKonQpGVDUTn763+597p+D4E=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id BC2ACEC0245;
	Sun, 16 Aug 2026 18:47:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sun, 16 Aug 2026 18:47:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920445; x=
	1787006845; bh=jQDVLS5QXQD8PSUIRmPFOeq1RPNNLBEX8FtCDNd5u2M=; b=U
	8DMpupRPxqNtjnk8MQ2nr5Tbo5J15VHzqtBgNexbVDLBpQK8kOZV1V9VY+oTuclR
	FQwN1MvWVLuiLmcoyeMjBjAsCK5jQiMnCByX5sgQcVEV08a7dKIl5WJmD167xKsd
	yxQ7OnXROVAGW/6T7F5mwovdCEXMiXGeyCbx0Blytwa7iAXZ9fy4r4TDPHRhwZaH
	vClCvsD2KdWW3DONN2vx+ocz7EhMKeBAZdEmGRcSKeBQrFIA3qDi1+U+CcOSNLE2
	5eDbkp2Q8RBM6gtc1s0Xkg2Edc72+x+DGSpowCNEvZ8LT8Ez3oNUoKYnNGCPP2Hm
	xuahjYF0L026BXVJ9QcSg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920445; x=1787006845; bh=j
	QDVLS5QXQD8PSUIRmPFOeq1RPNNLBEX8FtCDNd5u2M=; b=Ne2vpsJ2pSqH37gTo
	Wmx5ryypkj6OLWQeygS4FAdp8lHexFPq9T6hnhqWd3FFoaJ8/u9jg8aewPXuAWAS
	vfFKx+JtJDAjFXvqvAkkEPEZvhLlVERfDcBvsH4T53nK2mozBL/Cvrt5pq5zfyCl
	A4+EEFq2kfAuNRTDskQydpsx9uP81j30iaWmjmWzj0Kel4UcWCky1aVAOkzvfuXa
	Cl+wdwDq8VFhMsWFJNio4nZN4wuuCYjfQ4iX5XsjVIRHlza3dfHgIMbrxIF7iRC3
	o5N+ta537koNr/JRGVSGrgGX0lKLqtbooNDWYePfkUiDFtW0Wv6uX1IcV369p2qt
	GzBww==
X-ME-Sender: <xms:_T2CasrVW5hajWbLikKl4dLJpd5a9eMTlGeM9lC1yc62Lwqk8W-Guw>
    <xme:_T2Can-42G3Fwi1izl7fzD14uBRCTbRlts_oARlDYR21KfoHOAafPYAGMXvDZwtfg
    TqYXOQUqw_q6mFU8shEp2CluRJHh4Y3gaPPJKGSaXo7Q35qDTQHx5E>
X-ME-Received: <xmr:_T2CatSf6g4kKxV-6xyJXciG5ZvJNI0ybU8Dnndpbqo5YPgEFyPXt5N9lAI>
X-ME-Proxy-Cause: dmFkZTFcTQrb7i2Wnr2aEeZt1aoD7asKutBPdJgU3YSD5OfcfuljRo8Y5zG4WAng55KhcU
    fdYu9dW0n+wtsUDWiYHh8AwjWiiyOeVLRvzra0gUIzgKMFXfu2OsH3wUsDwz3Dpe7vEjB9
    JjBmMfD78Db5X6Vl1RDz8Wz4IQF1tjtPvs8yYIcZ4vdtxAZhotrvrKr9o/e/MWe2qw9p1d
    u/4ngMViLbtWn8zpPvYSIgtjaF8APmxmHCU5Ga5Rd5eIGcQp1MbbGmkchmHrMFMoUd9mrv
    TpVQ9+TKNOdfLLUK+2CPoHpagx885EUQUSZxhSq0AxxU5QJRQ+JA8yzxyjEYMjW1uFFjmi
    LqqoNifkXB79/90TSRF1slcFxxwzddkh5G5bZ3d0l80IbLrRpgBlzopY6EpPfytjdWVjfO
    +DqxD67otuMVUFiKrSCwFY0E3gh/4zA/82p9GG1UXZlq2+64MGfIaNuCFx78ugxlx/Vxd3
    zcra6CnnMWps68YaqKx2D1rCx0QlW0Fe4XYEBXJdYnAr+DVTZT5z4gxDDkKwjNDEjaX1X+
    0qqckODmklZPLQLdNdAJbhiPAlLC0CzYGXGbs8lQ4kjAcpKVSed6BeRd67fF25naIaKKH6
    DYyWnNDoe85We2Xvv2oHM5trVYOLjMtG281TyArJBr7AEnxa79wrFeGYYOLA
X-ME-Proxy: <xmx:_T2CagdoezJWqKxXMydbSbxIDG9lyArj0l7AHk-4SpFKTBHooh1XOg>
    <xmx:_T2CaiLW1lXeF5L1I6jVyK0EIJm0CfzXd9uXG2IEb_SItVwL0Daxzw>
    <xmx:_T2CatHWNIRpSuMZlszw2kT5EhC_rxKl9vmYFA-koz1NgR9zkNOUjw>
    <xmx:_T2Caq6R82YAoFOrIWzhTPEqBgxIZKbIvnGaAaPcd36HNWC7_rI47A>
    <xmx:_T2CajsNeYuv7GPWRAu90uT4Hta4RKVmiOS_7coCKXhLeRfMVvsStC4e>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:25 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 36/57] mm/collapse: report what the scan found
Date: Sun, 16 Aug 2026 23:45:48 +0100
Message-ID: <20260816224609.308019-37-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 29F5640003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: mbq16xzgnjejspcefd37373wxt76gfnj
X-HE-Tag: 1786920446-912059
X-HE-Meta: U2FsdGVkX18z4xyGFsjmb2UtX93L0oVG/88a9kBQUHfmEmfFEZR4N0u0sMFoP2+4HyNpoSyKfz3wMlg1ZnL3Zle9Gr3HtSHWK8FpjmOoBkPQ5NdC0ni3OLciCWmfl95/ylLWqPpCsfzKMGAREHcEgzKBSwfHPBnis75xvtMiTXkirGvXFjZ62pF7dSkZXzA8otB3H6KMG9YCM6V+PF0H8BhuDSCrxm5jzPgtgYrI0Vl5swPnrKyoSDaiasymbdspd53ZqYxNO6udaaieDaLVH+hykGWjKBSAEfsiH08d2T59tDdcowoAMKoYf1HEP+0loLFMoqjlvH9ySltMWO41cO6wMt7uehh3TTGQNb1Bai0ShC1fzvVpZTjCInBzh7kT5qJlBoBp/0bo6dF2dvIWdTJPuCah9JKQqJsCrSEO/oya3B/Bd+JuKUNabXiQ7wClOz9KdDasuEbHUhyzyPmvZYA3U7xtw0LZeu0w8vyJtBoMTVly+p53foj60WCqntW0cMmgTGBXPwvBBYD+Ehu4FE/I4kB1Pbu6AMdrUdIlPqOTjFiR3gHhQPGTN3w0ndEamklffjFsECnlTi/rkV+IiBnymxgo/LvplkiRnT2NX8el7di0Ngq+ucEGadrnafmMZNRyRAtr0O/gqVTosW7e4/IZLGYjcQbImhLkMvp0hoEIrjuDzWusTZuDtRfd8C36F/bfroJ9V6zZb96yiTXr6qL/j4iTTnWsqaOf+d1K/kX1lST0vHiH3mOD6F1CWKdQfVCTtTPMDpNmPbNZfCPREhId7ouGQPD60wquDhK7rrythqAwDR2a7Q2VG3NjS/ZMBZd7fSKJsesLifF199JydoEsf3pUcu7dmLCYpazaae2AOCOi/V7/hJfaZidCOCrLy5WaII30FJ/q8u5z63vMsHPO/1hEy2XbRhfWVT6CrqK/+j3FGsNsywuOYLouBSiUXwswjo587PYgXU4HJDk
 0AYJntWY
 5RChE2okiBmUZg+fhXlOvIIwrmA3b31554YiRJZ9lT6iIosQ/CLWNgQzHuRZonnZXOiLWnDNtRObLEBS9MpbPQFqvSulyFsFCfegCiVFNlXwNgXEsGUFkx2L2HQC9J78/ChtSEZ8Bvco1ndTiAF5fWM1VIW7fv5qPCFSBUojTohvOT+7WFO7tm7sq0A1ti/UPLJMCvgSIeUma4oP0KXWUesOqmu//POvmmzCiv0q7Ub3MIbFguQekV+IqIv2nxyX73cqXgm7RpjdpWC+WFl4bGMPvWkjCAf5r7Te5fRrKo8Db2pQiW6skYuSF7O42Mt7CxCwzcyhnHUbVmRgpeI1r5Gmq71ie4+Uq1m536UAJ2XQ2yws/eOi355/LfyRiow+B1iDNDZPB3FkZUZMf8iVXbYM1WsgJqgFRKC5Iv5YPANcjw29CuweMJCi5Nb+ekvVSBwwHSS9kWKvZ7Jk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The anonymous scan reports nothing, and its verdict decides everything
after it: which orders selection may still try, and whether the table is
refused outright.  The only way to see it was to infer it from what the
candidates did afterwards, or from their absence.

Add mm_collapse_scan: where the table was scanned, how many slots were
holes or the zeropage, how many were swapped out, which orders survived
the scan, and the verdict.

The first two counts are why a table yields a smaller window than
expected.  The third is what a PMD candidate will have to read back.  The
order mask is the scan's whole output to selection in one number: a table
refused as a unit shows an empty mask, which distinguishes it at a glance
from one that merely lost the PMD order.

The file scan already reported through mm_khugepaged_scan_file; this gives
the anonymous side the same.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/trace/events/huge_memory.h | 34 ++++++++++++++++++++++++++++++
 mm/collapse.c                      |  2 ++
 2 files changed, 36 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 86131845b761..573cf5428969 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -126,6 +126,40 @@ TRACE_EVENT(mm_collapse_huge_page,
 		__entry->order)
 );
 
+TRACE_EVENT(mm_collapse_scan,
+
+	TP_PROTO(struct mm_struct *mm, unsigned long addr, int none_or_zero,
+		 int unmapped, unsigned long orders, int result),
+
+	TP_ARGS(mm, addr, none_or_zero, unmapped, orders, result),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long, addr)
+		__field(int, none_or_zero)
+		__field(int, unmapped)
+		__field(unsigned long, orders)
+		__field(int, result)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->addr = addr;
+		__entry->none_or_zero = none_or_zero;
+		__entry->unmapped = unmapped;
+		__entry->orders = orders;
+		__entry->result = result;
+	),
+
+	TP_printk("mm=%p, addr=0x%lx, none_or_zero=%d, unmapped=%d, orders=0x%lx, result=%s",
+		__entry->mm,
+		__entry->addr,
+		__entry->none_or_zero,
+		__entry->unmapped,
+		__entry->orders,
+		__print_symbolic(__entry->result, SCAN_STATUS))
+);
+
 TRACE_EVENT(mm_collapse_candidate,
 
 	TP_PROTO(struct mm_struct *mm, unsigned long addr, unsigned int order,
diff --git a/mm/collapse.c b/mm/collapse.c
index f0d80204c2bd..b750a1fc81a5 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -2097,6 +2097,8 @@ static enum scan_result collapse_scan_table(struct vm_area_struct *vma,
 		cc->select_orders &= ~BIT(HPAGE_PMD_ORDER);
 
 	cc->scan_unmapped = unmapped;
+	trace_mm_collapse_scan(vma->vm_mm, start, none_or_zero, unmapped,
+			       cc->select_orders, result);
 	return result;
 }
 
-- 
2.54.0


