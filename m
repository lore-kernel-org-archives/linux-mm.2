Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80500CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1316B0092; Thu, 21 May 2026 10:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405A16B0093; Thu, 21 May 2026 10:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31B426B0095; Thu, 21 May 2026 10:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21BD96B0092
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8F361C0508
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:15 +0000 (UTC)
X-FDA: 84791651910.12.53D1106
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9380B18000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PzSTxvG+;
	spf=pass (imf16.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvnhYyrYWxk5OBPJwrKrmJeEttrxtHxGpLoGH3hJxZs=;
	b=hm9ODtwU5ZmfcfT+JcCA1leHIzB2sBxMc9X1VrQTN5/s/JQITy06raDIXD69usSYe+KseW
	YU8KaTGBxb9dnenmceDl1fLb8qtATALe3vvyuuEug3KupN3fsHFyLBGfYPRnzicXmyO6ZY
	xjSD1w1oYgNrIMzksoyIJEJczn5to7M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373573; a=rsa-sha256;
	cv=none;
	b=FrRjHOdO+ZJ0Q6k96tjo8UqDtS9FGGV6zGGyxuSGrTcnsDfZdY2b50gWRhDpF4KOdomKG8
	U+tmmxcpYjArwZ/kgG9dgJLf06FwOyLxKH+CyPwi/wOaWXP2FEqZIGMuiGAlAfDuSlirxe
	qqbdkYKoUTDsRfWI3YI+0oNtCOvEdq8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PzSTxvG+;
	spf=pass (imf16.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L1b1mX3214577;
	Thu, 21 May 2026 14:25:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=FvnhYyrYWxk5OBPJw
	rKrmJeEttrxtHxGpLoGH3hJxZs=; b=PzSTxvG+zUJDfQtYO+5eJd2RxQRLxrGHk
	aCqFN8j4BX82bfbkRYglMyk+YSagOt60WoqzGUC+R7JP+3Pf8U8bqc9QadYo8sAJ
	mW3Q8HrDn5VzZHj9THwNzllG5dykmHxRLClGb/k55A4e+CW1SKVNtUX6i5VpSx+8
	6lbuI78S7S1v4/btgl41KYl1WXlWEheHcuZ464UaIY/JHsLdWLFTDhfmE7qMFcKA
	rqkZF7i20Y96TTrB3GNhyDj8RTDRSwSEVRdSymkm/bZZ2G4wlouoOmVQoxQuHoHn
	M4DH5GU2JMbt3bd9w6nY1NrxQ75hyCKlNgXOSV/86slYpxj6+cs3A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hawe824-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO6Om017119;
	Thu, 21 May 2026 14:25:55 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e73wkcjcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPqUR50856384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EEDAA20040;
	Thu, 21 May 2026 14:25:51 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 978382004B;
	Thu, 21 May 2026 14:25:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:51 +0000 (GMT)
From: Jens Remus <jremus@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        x86@kernel.org, Steven Rostedt <rostedt@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dylan Hatch <dylanbhatch@google.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
Cc: Jens Remus <jremus@linux.ibm.com>, bpf@vger.kernel.org, linux-mm@kvack.org,
        Namhyung Kim <namhyung@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Carlos O'Donell" <codonell@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v16 07/20] unwind_user/sframe: Wire up unwind_user to sframe
Date: Thu, 21 May 2026 16:25:33 +0200
Message-ID: <20260521142546.3908498-8-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX5cPz7+SzHrWN
 Nxa7dM704y2kOk5lq7rrcEsCKbESVqbyYtqZpBAu4I8a2PqfJ1uveZNer4IgFy3C0h+3zkBLic0
 p8lh+krGSSDnDYHU59kuRFnpxLjCcrtNVInJYGDD3HEItNGdFjt4V5IO/4OtgnlNqlGiP3d1iID
 WLspnHGIz7PMORn8F+9hLFHglqsBJOCN0qRSbmJjtjLQzL7Nbx+4B3YyqXqzUkFMmighMJU/POf
 O2VGUukVwoWc3HYDQ26DzgKZewmQSoZGwwy4+8dGoP/4MRxfsgjHrMdbjJpMSz4GhHrQNZgmhgG
 sMUT1k5lvwL+62YcMY1ocnxoQanzju/vhcqOghkGFythwnE/oWZV0YizMPWuY/u4qXaE4Afpn3b
 ojK+Ib3/ZdicKajF5ipovweyCo/HgEiZEFikT5JelpoS6ECfcr5WzK5LePSTd75gswl2NMFblOa
 FUxRXHu1nPSeb2Usj8w==
X-Authority-Analysis: v=2.4 cv=Np/htcdJ c=1 sm=1 tr=0 ts=6a0f15f5 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=ItKwCHsCKAUqeRWvWoIA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: erpxgp4-yIAbyBSFs8dWTTSRpqokbHrh
X-Proofpoint-GUID: y6XOmu7WISs7NQ9XdEa_-tlGoDw_v9-g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9380B18000B
X-Rspam-User: 
X-Stat-Signature: 16ith4drmeb3b81embwzpyipujddbuw3
X-HE-Tag: 1779373573-640393
X-HE-Meta: U2FsdGVkX1/y/ezo0Gt+BiyfjZOnVNej8pTYVqLrfWdj/e0dxDk7dmqI8g+tTpHM9QOgu+516pU64rxr/1AIW588iHZaMd4D2IefTatcmnLhkToJFVqkC4o2xUQQcmdn6X2v9eRw8JB0oQ99Rs+Ncf0IYEnv3UhsOeR+JHbEeeiObpTLcmPZzE6f06+7LiBmhRj+fFhGOFrT4DCyWsILYCi4hC+aI3nawxQAF5a/sz23hChSRY9pGuBTS2waMqylm0C9j9Pcd2cRYMx+84a69Uw0jt9osvX50pBjkorQ0bnj1GxdpmRQsfE7cAkLCVGrQjn2IhTuWahWi7bq0ehlp7b5Z0kno2+AKN+FmzNQOLvwfQ5TdCw2RdEsEWV4EASzqCr/nys4H4e4oUekZqjBKRU419QKQrLR0iyx76OGlxr70lMn2QQVFOjx9WzjSwOj81yIfhE3tm5jxLOuqbrDm/pbmoyb5bG5uhavkq8oYdXCdswV9wDuaDG9yULkwZtMLfd1aSclRsq+8OT8gwXd4UQ3bR2E2PS83lObJeCrKPRr93zmhCH3Wut0hEa+Epl31W8I8QGTIemMD+IasJ3YLv+w1Evpb6212cGplPjydUakByOLjDlGHO0wxBgzFqSQYQt4LwxjdS6yJ9C9f1zHSfwgkKMFZBjJbRcfnOEn/7IyhPCGvg3whHJh90LXCA3Zel6Il9Nlax9eRPBo98AX5nMuGaGKdmJ0Ns8lc5n6BQaSgRm7426mJVArjXvYZDs+wwO6TgvEtbmIKpcK9kAVwDpecfvqRiEadqHmzBgDhv6M64REEhm7x3mS6RdRh8Hilra/Wa8NO0qzTkr/KvNAX/n/1dp4KsUv+5GEf4oNIsdMpaNjYCE23tFAuz1DSuCTew5tuF1U9wDsq9G2+euge5fpd9hhs/B70UOLbb7VTYCUKg++iE+VA/XLhX+AyOUTdVuCmZGfvbfAkyMrrRe
 jE7MLkTU
 dMxRvodTa7BBqiEj8awUOoMSc8ULqrFu6HBwTWc9sFJpOPf4A5MElQ18CsBN/NHCztk3H5Jv27IKSkVOAmnmb9QX1co/ymJqdRb0VtJam6q86JsUs7OEDlN0nhLlBjHtNxIGSd7vL/XLPsuYPSh/VFuamw3WxOr0Bi+sh5jfYzq8v4Kgd9UZSWqQtRYLCq4ZFlDB//y7cEW0Y83ApVEkt+BmxXj1nV7kvd61zY15xaE2X0C3gXT+rSWtamPRbXQSqFlNOSGq46f+9T1UUgxDeve13aGhoqmMeUFQLqJ3oqfdqDZ+BPRUKJaRuWFh0yBNznLo5dNO4NXHcqG/JV2aM4Mfxz0u1PFSdKtxJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Now that the sframe infrastructure is fully in place, make it work by
hooking it up to the unwind_user interface.

[ Jens Remus: Remove unused pt_regs from unwind_user_next_common() and
its callers.  Simplify unwind_user_next_sframe(). ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/Kconfig                      |  1 +
 include/linux/unwind_user_types.h |  4 +++-
 kernel/unwind/user.c              | 23 +++++++++++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 94b2d5e8e529..37549832bd1f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -488,6 +488,7 @@ config HAVE_UNWIND_USER_FP
 
 config HAVE_UNWIND_USER_SFRAME
 	bool
+	select UNWIND_USER
 
 config HAVE_PERF_REGS
 	bool
diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index 412729a269bc..43e4b160883f 100644
--- a/include/linux/unwind_user_types.h
+++ b/include/linux/unwind_user_types.h
@@ -9,7 +9,8 @@
  * available.
  */
 enum unwind_user_type_bits {
-	UNWIND_USER_TYPE_FP_BIT =		0,
+	UNWIND_USER_TYPE_SFRAME_BIT =		0,
+	UNWIND_USER_TYPE_FP_BIT =		1,
 
 	NR_UNWIND_USER_TYPE_BITS,
 };
@@ -17,6 +18,7 @@ enum unwind_user_type_bits {
 enum unwind_user_type {
 	/* Type "none" for the start of stack walk iteration. */
 	UNWIND_USER_TYPE_NONE =			0,
+	UNWIND_USER_TYPE_SFRAME =		BIT(UNWIND_USER_TYPE_SFRAME_BIT),
 	UNWIND_USER_TYPE_FP =			BIT(UNWIND_USER_TYPE_FP_BIT),
 };
 
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index 90ab3c1a205e..1fb272419733 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -7,6 +7,7 @@
 #include <linux/sched/task_stack.h>
 #include <linux/unwind_user.h>
 #include <linux/uaccess.h>
+#include <linux/sframe.h>
 
 #define for_each_user_frame(state) \
 	for (unwind_user_start(state); !(state)->done; unwind_user_next(state))
@@ -82,6 +83,16 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 	return unwind_user_next_common(state, &fp_frame);
 }
 
+static int unwind_user_next_sframe(struct unwind_user_state *state)
+{
+	struct unwind_user_frame frame;
+
+	/* sframe expects the frame to be local storage */
+	if (sframe_find(state->ip, &frame))
+		return -ENOENT;
+	return unwind_user_next_common(state, &frame);
+}
+
 static int unwind_user_next(struct unwind_user_state *state)
 {
 	unsigned long iter_mask = state->available_types;
@@ -95,6 +106,16 @@ static int unwind_user_next(struct unwind_user_state *state)
 
 		state->current_type = type;
 		switch (type) {
+		case UNWIND_USER_TYPE_SFRAME:
+			switch (unwind_user_next_sframe(state)) {
+			case 0:
+				return 0;
+			case -ENOENT:
+				continue;	/* Try next method. */
+			default:
+				state->done = true;
+			}
+			break;
 		case UNWIND_USER_TYPE_FP:
 			if (!unwind_user_next_fp(state))
 				return 0;
@@ -123,6 +144,8 @@ static int unwind_user_start(struct unwind_user_state *state)
 		return -EINVAL;
 	}
 
+	if (current_has_sframe())
+		state->available_types |= UNWIND_USER_TYPE_SFRAME;
 	if (IS_ENABLED(CONFIG_HAVE_UNWIND_USER_FP))
 		state->available_types |= UNWIND_USER_TYPE_FP;
 
-- 
2.51.0


