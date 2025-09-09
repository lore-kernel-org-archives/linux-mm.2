Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF0BCAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764E68E001E; Tue,  9 Sep 2025 05:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715458E0020; Tue,  9 Sep 2025 05:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42FAA8E001E; Tue,  9 Sep 2025 05:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25BC28E001E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:15:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF2A11603D4
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:31 +0000 (UTC)
X-FDA: 83869153662.14.D0C37F6
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id B83C840003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jXkJo6zY;
	spf=pass (imf12.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8EealqgrpCzZz7qOCOIQ+4P/4Y4XtWwcjzoer4drJU=;
	b=S23xavbefUufsu8wqCiwvQh7pLh+VGFej4GC+Tvm5SKWVldb17xwG+E/AI7QkQ5l8SwNos
	o4E1EBZB08U61gAghU/bBwhN8PTvDjyYsfZjj5WE/tCPTFZtgXxtSzW/h24ej3KD5A/hYs
	ZrIIyKGxBaYwNHGQ/C8Bk59OB117+Gw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409329; a=rsa-sha256;
	cv=none;
	b=n9xjX8nDvEdEx4zQ1QGJMxqiHm+DpzCI3wgIQ9Y4KXQPO5dQVX4+oe5e3HyVxu0NiL5ojY
	uGXzMCxzGf1obBavQ7AE7D9AhlUEYGZ4F/yUeFh4cljWwdbW81p4nCTJiJtCkca06mxrTQ
	16VQZOYLMjWOuBv8dDcCejpeq51iiOk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jXkJo6zY;
	spf=pass (imf12.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5896MAwd024164;
	Tue, 9 Sep 2025 09:15:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=N8EealqgrpCzZz7qO
	COIQ+4P/4Y4XtWwcjzoer4drJU=; b=jXkJo6zY/xPfZ7kUBjK+/42+5GgfOCDBs
	YbiJsn72dYagjfrullVNcHKr7lWiThgeuhEdLTN3H5tE/9tLeSrDtlaBXAdt32go
	sz+fGgE++l79hGO10WAHUhnQg9wOZEG9S5ZifVcNc6hlsl8NQ1BOFNEJxkeD4hmv
	9r2AdOR6tj8HRwv6hqIaaGf0dsG/XRxMyzlEQgIVFsm0Lm0mgyJaMaToh8fJN/HN
	QouvFVjVgOQBP05zCcoxKFReRAmUxYm9d7Qtiy57sR9zCEX0Lty9aODgzbegArT4
	Sk80u3PLqQZVU7QBmCvrYIjtwMOW1bZS1rlN3uWpkUmgVF4JIfFdg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcspgy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:15:24 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5896nDeV010666;
	Tue, 9 Sep 2025 09:15:23 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910smt9qk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:15:23 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5899FMQ731785654
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 09:15:22 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D15958043;
	Tue,  9 Sep 2025 09:15:22 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B13EE5805E;
	Tue,  9 Sep 2025 09:15:16 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.2.198])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 09:15:16 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com, Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH v17 10/12] powerpc: mm: Implement *_user_accessible_page() for ptes
Date: Tue,  9 Sep 2025 19:13:33 +1000
Message-ID: <20250909091335.183439-11-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909091335.183439-1-ajd@linux.ibm.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfX2FBiHo7uUFP7
 5z0hL8pcUkziaGtBtP8TW2gXO9LmWpZpxofnp7QPVpI0a24zlAYmnDchlSKfSw7owvrhJR2cD9y
 GbK6NBo6L23LNZ81GpdqascUBOiLf/NJf7p8CsoSuwh67cQuh6FmpJePaMNDTnaLhZdG24JXp5z
 oXP7Ku7mh60Y8/zZuJGfuX+nOOX2xbYTmSlj8o7TVwFfNwUnNY3jeWxGTSjUD00amn/LR7XwDQE
 Ck3Nlp2LiAyOKtZzjV6644Yj+irpUyrBTaCstYJwGlqBRSzjV9ZiGyxxzzuPpE12k8ByUrQtGyC
 HhhJfmVzA3dNbNvYVHxjfzByCEH/PepH/vqbKwdYf4R8A8t52LsHotVNY6Dg4AWyVQ7mR3AIi+/
 ccsTaTim
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68bff02c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=a65a1E2n8xkc5m_RgcEA:9
 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-GUID: TM3YhvqpwbcLDevaIpBzNiayhoybwUdn
X-Proofpoint-ORIG-GUID: TM3YhvqpwbcLDevaIpBzNiayhoybwUdn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010
X-Stat-Signature: d9w31we8bdcy1jtgsg377gycsicsfes7
X-Rspam-User: 
X-Rspamd-Queue-Id: B83C840003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757409329-76406
X-HE-Meta: U2FsdGVkX1+iTn9nflEOjuVAkkQisjNDj1OnH5PwF0MZTSmOZLfF4ECRHDMdgx0ampSoE/6PRmmAPhv1Auxj/czoZSrVOtOlLo1MoAdeYasDwpPjxMEEnwN/pFyOWeo7NnPGghkRo8Y+HhTCPoS0psPuXd8iDzd74gMHmygfRCJy9X2bjnisXTq2eIZ+Exf9E5FnKwUNgku1o6CElAPxSJ0yDHmQnpVhWd/Rx1dmWRMxJKtnBG44py7IClt6WMRw6HcE+ILsPyrPKJz7YgS9V4h0rYFG+sHWsvs3CSOW6DYf0JTi4Ej+p90DjSZx6/TZzL8XQK3Yu1aWya9OClh5pLmXRQAUNBU5+B/en2QmD/1r3ghtJAUZZqdpcAt+0xPQB9v10448ISijzzpdes19L4f/Bfwwmk9dTQF0i1IKhxMzI+t6Qnao3zUwM5zZHytNgprRmKAx3oJG00xepg1jkfkl2nuycSw8lGkMloiDgRvo8lnw7n5XoHDgg/8CHtvQc0WeXYAwrJwarDUTSVcXr2ylV2W/lwWSsLPiRnAv1ACnqSxuCP4yTdso6ItpiZjscMXSw9Pu8kIkmh8iEZ2+jGW7N+4+7Wy/g/+Kc6XhXu6Lz56K803CQwJ8Bx5KtQDdXMcgRby8gQY50twA94o9jVG0l8sXhWPUjD5vfTCBAFbUothNPG+v3N6NtofWMUxv2yB+WTUlOMF3p208ajgpFh/n5/M1G7LZWhuQb5CyWKPia8U8i193Bcmt/DleW6O3IthyN783px14U52EdfzP+R4GxJDxrd8ErDQz+TMe9csHkB4u4I0ttZT8mUnNUxtf6NXY9crrD4F/c1bQc060kSUOHXAVZiqY4gOLloYk5CmjRlIR6gdLy+9tI39TmQTHbnKiMEP8lmKflYs9UsR5IwhjyPgnIMC85yURyNdrNOgoUB01uLhS+jwgv8lZDF/1MFWunpy3kep16A7v6+W
 PJcsxta7
 cYABGOh55QoBLlQkaSukshe9bPrUzokLUTXFcE0Zj6/938H+6GtWZ8rC0eLz4fzLiaD2nY27vfsyR74VTccNpMNjrgCqci5/elldTU/a4OMjgEFubPEXTdufWqCkiRVw7uGg29fuE/l78FNc5Uv7LqEfbwLFJ7okQis5GN+PBp5iYFokRwiZv/tMXLL0V7adkkNIO1MdSdO84y3wHOtmFPYx4YjNqlly/EbJaIgBxyCRx8VBnw9uDQvIg8jY2qvlpU6XyQHTdXwD7nRM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

Page table checking depends on architectures providing an
implementation of p{te,md,ud}_user_accessible_page. With
refactorisations made on powerpc/mm, the pte_access_permitted() and
similar methods verify whether a userland page is accessible with the
required permissions.

Since page table checking is the only user of
p{te,md,ud}_user_accessible_page(), implement these for all platforms,
using some of the same preliminary checks taken by pte_access_permitted()
on that platform.

Since commit 8e9bd41e4ce1 ("powerpc/nohash: Replace pte_user() by pte_read()")
pte_user() is no longer required to be present on all platforms as it
may be equivalent to or implied by pte_read(). Hence implementations of
pte_user_accessible_page() are specialised.

[ajd@linux.ibm.com: rebase and fix commit message]
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
---
 arch/powerpc/include/asm/book3s/32/pgtable.h |  5 +++++
 arch/powerpc/include/asm/book3s/64/pgtable.h | 17 +++++++++++++++++
 arch/powerpc/include/asm/nohash/pgtable.h    |  5 +++++
 arch/powerpc/include/asm/pgtable.h           |  8 ++++++++
 4 files changed, 35 insertions(+)

diff --git a/arch/powerpc/include/asm/book3s/32/pgtable.h b/arch/powerpc/include/asm/book3s/32/pgtable.h
index 92d21c6faf1e..b225967f85ea 100644
--- a/arch/powerpc/include/asm/book3s/32/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -437,6 +437,11 @@ static inline bool pte_access_permitted(pte_t pte, bool write)
 	return true;
 }
 
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
+{
+	return pte_present(pte) && !is_kernel_addr(addr);
+}
+
 /* Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  *
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index c19800365315..48f3a41317dd 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -539,6 +539,11 @@ static inline bool pte_access_permitted(pte_t pte, bool write)
 	return arch_pte_access_permitted(pte_val(pte), write, 0);
 }
 
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
+{
+	return pte_present(pte) && pte_user(pte);
+}
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
@@ -1381,5 +1386,17 @@ static inline bool is_pte_rw_upgrade(unsigned long old_val, unsigned long new_va
 	return false;
 }
 
+#define pmd_user_accessible_page pmd_user_accessible_page
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
+{
+	return pmd_leaf(pmd) && pte_user_accessible_page(pmd_pte(pmd), addr);
+}
+
+#define pud_user_accessible_page pud_user_accessible_page
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
+{
+	return pud_leaf(pud) && pte_user_accessible_page(pud_pte(pud), addr);
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_POWERPC_BOOK3S_64_PGTABLE_H_ */
diff --git a/arch/powerpc/include/asm/nohash/pgtable.h b/arch/powerpc/include/asm/nohash/pgtable.h
index 7d6b9e5b286e..a8bc4f24beb1 100644
--- a/arch/powerpc/include/asm/nohash/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/pgtable.h
@@ -243,6 +243,11 @@ static inline bool pte_access_permitted(pte_t pte, bool write)
 	return true;
 }
 
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
+{
+	return pte_present(pte) && !is_kernel_addr(addr);
+}
+
 /* Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  *
diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index d8f944a5a037..fa43f663e615 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -202,6 +202,14 @@ static inline bool arch_supports_memmap_on_memory(unsigned long vmemmap_size)
 
 #endif /* CONFIG_PPC64 */
 
+#ifndef pmd_user_accessible_page
+#define pmd_user_accessible_page(pmd, addr)	false
+#endif
+
+#ifndef pud_user_accessible_page
+#define pud_user_accessible_page(pud, addr)	false
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_PGTABLE_H */
-- 
2.51.0


