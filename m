Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59EF1CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBFFB8E0002; Thu, 23 Oct 2025 12:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97EB8E000D; Thu, 23 Oct 2025 12:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85F88E0002; Thu, 23 Oct 2025 12:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A02F8E000D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:06:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67C9A49330
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:06:21 +0000 (UTC)
X-FDA: 84029856162.20.CD16852
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id 94DA44001B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:06:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WoCuBe3c;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761235579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=la21jHGyplFfY/WqI0NwB81QN3IoQrvAGwqFdZz19w8=;
	b=Gz81EkV6sQ6JzAUDrOn0k4+JA1Dx6C4+D+tCnB6gFfjwGRYBPyehT9bgmcIzFkFK3ht47J
	U67omsAw5WMdOEE2e9GTO+JkxuxPtI9F2rtHcv5P0LBY92Q6Xyyb6OTSadAHX0bx4F1B4I
	UHTOlTUVn4UH1OV2Q1KkK0yUra1FFZk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WoCuBe3c;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761235579; a=rsa-sha256;
	cv=none;
	b=hPkztC6Wwq+Rq8MDWaNUPcz78bzndkh/cbqnC9+8AxPQM94Vk4Jv4RhE+EG5Y+8LMEIJ+S
	yLunRKetBdtDizanC7XiiUnzcZC6lS+FOjspmMJ9kt+IrHDTBLJg15kDQk6MqJMMCkb738
	OlbH+34AvO/7/P1LZ+ct1Ebi5e0jLYE=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59N8ag5n019834;
	Thu, 23 Oct 2025 16:05:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=la21jHGyplFfY/WqI
	0NwB81QN3IoQrvAGwqFdZz19w8=; b=WoCuBe3cdpv0Qp/Cy8XFOGFDzkt0Ykuu3
	OZAzckUuuLSXH55hSI4ITdUli115G20GWbopyDB6DB+Zyodyx8D4aXrnMStNwf/8
	aSdVJn+/LZmA3VxcpdhdqeOHQ9RZBwWkMe8v5KFxOlTQuFAzed3B+t98WBBs17v4
	UkIOO83VkJ9i7b/bsebptCI1AysbQHJd0mEcBbWVRSzlHdO/qptf+p+KI5tKIHju
	US10jWpxJ05AyvBpSuuCPkMATSISNnBmunkw2WR+FV0OMBxq8iN4AAU+hEybUaLH
	Ax7j9iy+5faC221/iWcCt60nuZYsVCTrqf/38lxMuZxEHW3lHIDtQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v32737m0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Oct 2025 16:05:55 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59NFquOD015411;
	Thu, 23 Oct 2025 16:05:54 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v32737kx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Oct 2025 16:05:54 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59NEZr49011075;
	Thu, 23 Oct 2025 16:05:53 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqx1ebh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Oct 2025 16:05:52 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59NG5nBC41943430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 16:05:49 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA21C2004B;
	Thu, 23 Oct 2025 16:05:48 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 650F520043;
	Thu, 23 Oct 2025 16:05:48 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Oct 2025 16:05:48 +0000 (GMT)
From: Jens Remus <jremus@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>
Cc: Jens Remus <jremus@linux.ibm.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
        "Carlos O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [RFC PATCH 1/2] fixup! unwind_user/sframe: Add support for reading .sframe contents
Date: Thu, 23 Oct 2025 18:05:44 +0200
Message-ID: <20251023160545.549532-1-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=EJELElZC c=1 sm=1 tr=0 ts=68fa5263 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=-WfIxybQAAAA:8
 a=X3WeMxAik4tzwCrV5JEA:9 a=KbVuYVxSu7xg536452LQ:22 a=DXsff8QfwkrTrK3sU8N1:22
 a=poXaRoVlC6wW9_mwW8W4:22 a=p-dnK0njbqwfn1k4-x12:22 a=7aar8cbMflRChVwg8ngv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX1kKTN45NkES8
 O7kLYBREj69VgRgaSEQYHdwjj+Jj2/EzbR3pKk+u6gXqxZJVO/BP91uvQeTMR4GCD+n8V5A5zOP
 Fovn+aZWpS6YQvUB3p57rWoGV1DQIsAkEworIw8+9UfKei7W0N2Jyw/kxaYUsXsk1YBK5VXxb9P
 LOcius+HLl3TvCRHrQQduRJ9n6Mo5gxKJd4yRTXXMaScibLf0ZoHA6YCuuD8mQm0l7wZgXRYG3F
 DBy/CmgR68z+gM3ZrKladsBtiP/G5ilNO0iBpPUNI2xAFOdc9kwNDkYaMZIDiy9aoB9YDk8vX0Z
 mhaQNk5zrbeTmJKh4axANfMGx/YSgYqYI9DjQ9dWQx7jvpyyB66KwKLo5BOXUWkBOEKI0g65vDw
 lyEXlZKBsNM1NwTAuZIBk5jOxU9wsg==
X-Proofpoint-GUID: 9Msq37G1ETcHHt-9gnjmOS_imd65E8Mg
X-Proofpoint-ORIG-GUID: LQ1J1-wRJ1EQj61I8t4Ke7MvJqOSujkD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_01,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspam-User: 
X-Rspamd-Queue-Id: 94DA44001B
X-Rspamd-Server: rspam03
X-Stat-Signature: 9zgjs69y6si3zui1j9pcxdnghphfpdwp
X-HE-Tag: 1761235578-468770
X-HE-Meta: U2FsdGVkX1+Tq60xHoolYtU5Vgm5au5Al7/gTXmd9LpS5uJ6Rml1cS7bVAwzADMgez8GsCKWqnLD1Q/Kj1Scam81hLaH9/Sq7CxAeZmg1W0Opx9iNsYiWRqfr7CNIulfP0rzKGb2KjLEtRQx67TUChSYaaBqL2LhoS2Qguxl670h3Z0mx5phu1DmRuzha2dSO2d+C8HyBLbewRpW8xODmQbfGVRjggEhgiS23MdGmwSmUTHGKIzYL4Q8awZ8t9smbYqfjQhw70eQWYSr2VJxwXJ8/meT4zlv3Qjdrjw456+f/mUMFO7ak+MONmvGrRZtd8efnkVOXm/nMSlvszMl8RwyFuvXi2Ga2UE9AwUfFYk6YDA+95ShWrRJ4vIgGLOKh7DQ06elD9aH8zzg5to6UOdgHOxh5EM/JCWtfp7uHEbtDt41YkqW1HZ2z1ZHtLGndhNvQVe0yEnRjmAk1H23gUnPzRDu1cVV5EkG5yAdCnTMAYws/U3RxSPhx9I3PDXJqYDNWLQFGMDuWQ5FUGDV0TwrOahIu8XjNmTwoIRImnVVvF3KUiTAqsRFkT2kM8a0F5Dtzjl4TXtCkTBRCFIfX8/2dmH9cPTSvL2FGxsYal0jgK6yf3oFObaMWIVIBbMVhNMLXuoLo3RV6vGGmlsWF55w6mF93bSeA/tg7KGQlVnW2xFRns8GSAgIDf93J4ZseTaqylODa7XGe8t1iDdwESb4TlV8Wh9feE0FkIL0AJtLZTWZCFtFJvqa70J5fG2qiIElg3TYa3xLKEVutoWUk/PM8h60D16Z/l4dbGr51loP4Go6iTmENxvCCzL0HSAetO99XuIZwxtu06Cm4yIoEMCEIj+9Jpv4CZbqoLDQZWATxDoQ3Kd4u5/Ge1ZsNsGj0d6xmwkyIfYgbt0RpzjvRC3Lql9Sdihgl5KH6yXK1h2SQLT3lN4GvgZ0VoeLcjAJa5IwxgoZ4FdYPhGKNW6
 XKq7RbIa
 yL9MNX1RwnZAW1awi/e+lREtUaNZOcg1OcjuBCMeDtUT4ElCrbMi5b1MsqTZBquedYp3BKnsqzsIYMchIsHwXJ8eQV5jXh9UGRA81J/kPWW7ytcT/BUIZ3YBr5iCRBWIbh/aedcg4DoYabl7yCdEtRaQHDKodgPdRlcqoIehVqu5f6GP9xwTo1TdZDJrOaO5CLbeVfLZ67WrEifknqkNe70X7bShBGxmYplJb23Ah+jjgDzfIkOfjs+DhDfWgEP9EhGe0BnCK4d4CGLXlP5j+vFohu3hkvAbj6rhF2cymocfEWzqhx2ngJ4NY4GetFEFodK5Gwyrq56mRyLzC7BO12N7b67xvbFoYN6JXpnNvIbjB8wwSLmdKu+8pfVaiEay8fFRNUeziqOU9RTO79UslhYArUhWfcC6LsI6DZu4RvLouBK/m/jC+yF4Qeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This RFC fixup is POC to demonstrate how the SFrame reading code
could benefit from introducing an internal FDE representation (struct
sframe_fde_internal) similar to the used internal FRE representation
(struct sframe_fre).  The goal is to eliminate the passing through of
fde_start_base in many places as well as the various computations of the
effective function start address (= *fde_start_base + fde->start_addr)
throughout this module.  The internal FDE representation simply conveys
the effective function start address via the "unsigned long
func_start_addr" field.

Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 kernel/unwind/sframe.c | 52 ++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 3d7ac4eaa8b7..f88fc2c92c58 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -17,6 +17,15 @@
 #include "sframe.h"
 #include "sframe_debug.h"
 
+struct sframe_fde_internal {
+	unsigned long	func_start_addr;
+	u32		func_size;
+	u32		fres_off;
+	u32		fres_num;
+	u8		info;
+	u8		rep_size;
+};
+
 struct sframe_fre {
 	unsigned int	size;
 	u32		ip_off;
@@ -45,20 +54,26 @@ static __always_inline unsigned char offset_size_enum_to_size(unsigned char off_
 
 static __always_inline int __read_fde(struct sframe_section *sec,
 				      unsigned int fde_num,
-				      struct sframe_fde *fde,
-				      unsigned long *fde_start_base)
+				      struct sframe_fde_internal *fde)
 {
-	unsigned long fde_addr, ip;
+	unsigned long fde_addr, func_addr;
+	struct sframe_fde _fde;
 
 	fde_addr = sec->fdes_start + (fde_num * sizeof(struct sframe_fde));
-	unsafe_copy_from_user(fde, (void __user *)fde_addr,
+	unsafe_copy_from_user(&_fde, (void __user *)fde_addr,
 			      sizeof(struct sframe_fde), Efault);
 
-	ip = fde_addr + fde->start_addr;
-	if (ip < sec->text_start || ip > sec->text_end)
+	func_addr = fde_addr + _fde.start_addr;
+	if (func_addr < sec->text_start || func_addr > sec->text_end)
 		return -EINVAL;
 
-	*fde_start_base = fde_addr;
+	fde->func_start_addr	= func_addr;
+	fde->func_size		= _fde.func_size;
+	fde->fres_off		= _fde.fres_off;
+	fde->fres_num		= _fde.fres_num;
+	fde->info		= _fde.info;
+	fde->rep_size		= _fde.rep_size;
+
 	return 0;
 
 Efault:
@@ -67,8 +82,7 @@ static __always_inline int __read_fde(struct sframe_section *sec,
 
 static __always_inline int __find_fde(struct sframe_section *sec,
 				      unsigned long ip,
-				      struct sframe_fde *fde,
-				      unsigned long *fde_start_base)
+				      struct sframe_fde_internal *fde)
 {
 	unsigned long func_addr_low = 0, func_addr_high = ULONG_MAX;
 	struct sframe_fde __user *first, *low, *high, *found = NULL;
@@ -109,13 +123,13 @@ static __always_inline int __find_fde(struct sframe_section *sec,
 	if (!found)
 		return -EINVAL;
 
-	ret = __read_fde(sec, found - first, fde, fde_start_base);
+	ret = __read_fde(sec, found - first, fde);
 	if (ret)
 		return ret;
 
 	/* make sure it's not in a gap */
-	if (ip < *fde_start_base + fde->start_addr ||
-	    ip >= *fde_start_base + fde->start_addr + fde->func_size)
+	if (ip < fde->func_start_addr ||
+	    ip >= fde->func_start_addr + fde->func_size)
 		return -EINVAL;
 
 	return 0;
@@ -165,7 +179,7 @@ static __always_inline int __find_fde(struct sframe_section *sec,
 		 s32:	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label))
 
 static __always_inline int __read_fre(struct sframe_section *sec,
-				      struct sframe_fde *fde,
+				      struct sframe_fde_internal *fde,
 				      unsigned long fre_addr,
 				      struct sframe_fre *fre)
 {
@@ -244,8 +258,7 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 }
 
 static __always_inline int __find_fre(struct sframe_section *sec,
-				      struct sframe_fde *fde,
-				      unsigned long fde_start_base,
+				      struct sframe_fde_internal *fde,
 				      unsigned long ip,
 				      struct unwind_user_frame *frame)
 {
@@ -257,7 +270,7 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	unsigned int i;
 	u32 ip_off;
 
-	ip_off = ip - (fde_start_base + fde->start_addr);
+	ip_off = ip - fde->func_start_addr;
 
 	if (fde_type == SFRAME_FDE_TYPE_PCMASK)
 		ip_off %= fde->rep_size;
@@ -306,8 +319,7 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 {
 	struct mm_struct *mm = current->mm;
 	struct sframe_section *sec;
-	struct sframe_fde fde;
-	unsigned long fde_start_base;
+	struct sframe_fde_internal fde;
 	int ret;
 
 	if (!mm)
@@ -323,11 +335,11 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 				    sec->sframe_end - sec->sframe_start))
 		return -EFAULT;
 
-	ret = __find_fde(sec, ip, &fde, &fde_start_base);
+	ret = __find_fde(sec, ip, &fde);
 	if (ret)
 		goto end;
 
-	ret = __find_fre(sec, &fde, fde_start_base, ip, frame);
+	ret = __find_fre(sec, &fde, ip, frame);
 end:
 	user_read_access_end();
 
-- 
2.48.1


