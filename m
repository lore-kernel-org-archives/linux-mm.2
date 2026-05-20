Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E50BDCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381896B00E0; Wed, 20 May 2026 11:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BBC86B00E4; Wed, 20 May 2026 11:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D435F6B00E6; Wed, 20 May 2026 11:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4BC06B00E0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6826E8D070
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:45 +0000 (UTC)
X-FDA: 84788210850.30.1739312
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0C86D14000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sR1Hu+xN;
	spf=pass (imf26.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YhmEJz3THPGCV6XHth7RTi4iJUGf4vityHFxauJl+s=;
	b=1HIGaxGiUiibStrzAhSHgqjgQtB8++4vcRTuLuaAWDStWVq7GEhk6SXGMZt3GWcKdE3iYa
	WEw4/lCfnPG7cfTDwlnmhi6O2GriteZnaPG64m0KiHpcyWHvwL5brZJTl7UiL+OGPtmbeo
	ZkFFAR8LqU/b2VBz9t58YZ9MsKxi6fQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291643; a=rsa-sha256;
	cv=none;
	b=OWqxTCgSuBOJ0WszK9VcQyGUdxRGkThoPe64u9QSrRT3plk9tqhwNp05X3uK2N7FIBENef
	+CSTQVyKa7HTNS0XtMdd5GD7qaxmMzNnccaTp0OWpaJ7w922STrQ6Kf+OpH6RdMiqFLKqi
	NDH2fdB7jMrKqBrdvbiZFY2IW4usvVQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sR1Hu+xN;
	spf=pass (imf26.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64K6k2lC513145;
	Wed, 20 May 2026 15:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=3YhmEJz3THPGCV6XH
	th7RTi4iJUGf4vityHFxauJl+s=; b=sR1Hu+xNh4YACGGV7nHrOpZXgZz7O+vAY
	mpIi+00bAC4VU3SrITbC7Cukx9zKihiRCBj/WuMlkJKuG9on1yCObLL455RHUunR
	h573/vwOutrA2C2B+JOuWBxwHpWooBpaNJQCPk2wL9byoNeGMUul0LSAHtzGHICs
	8Y005F+le0G05mbtdmMXXDoHgfVf0xYbIexcVqU37aSlj+WiNaJpFyzJCWGAyyb6
	fCE+x62HXE/UyVdMBAOMPESuEK3fjulxvLtwiSPh5mKCO4KQaouyQgwJTqV0nywy
	4Y0UNDLr8mUJ36v3Iql3sYhRjRSyAp/7uZKBLCwGdGgDdzepqTc8g==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h752ta3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:17 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFd6Vx026083;
	Wed, 20 May 2026 15:40:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e75ky7q66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:16 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFeC8R62063014
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:12 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BDDD20043;
	Wed, 20 May 2026 15:40:12 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CFA42004B;
	Wed, 20 May 2026 15:40:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:11 +0000 (GMT)
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
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v15 09/20] unwind_user/sframe: Add support for outermost frame indication
Date: Wed, 20 May 2026 17:39:53 +0200
Message-ID: <20260520154004.3845823-10-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=ffCdDUQF c=1 sm=1 tr=0 ts=6a0dd5e1 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=U72JrVpwKSe1qDC-WCIA:9
X-Proofpoint-ORIG-GUID: RutorrHK_Yh961JRGNUS1hvnwjZkw88C
X-Proofpoint-GUID: XnZrEE4_Iky6X02Y2pC9TJ5PPqyzpqIn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfX1OqTSBjg6JuQ
 3CYMiUWNmccKjjzBUq2FHOZJTDO7VV9RUQtDZ/UosD6cXC4wirTJjKWlbMgrl57yNKjZx4nqukq
 CUEyyWpoI+g96MdSRvblOL3fNjCPUGmjXY8swPhuIFkQLVXheAquLoSsWfWMx3R6TTOvnx3HXEi
 gTK2ZGHp2EO4VVybVguhAvAOyiXxbjjRblupu5eGISleIYUFA8D+1pMybPtQ7IOkPP/lVSPpBJ+
 KdgYqWAWsxR62CmXaPjcU7qj0KlR791ABFSU5jlans+thlIpN2KGruDpNnwhNS4C5i4fU2fxluh
 hmge4nC/w4oV7pFW7faXGslWKLCMvhTmSL8q5nnhRvinUilCZYfHgBCDucTfgEKIMiDgejCKPP7
 njDNzY36T8g9hnYZU71eXoCzez16WpGBrTeb5i8io6vVApLmm8HCKExgY84mMF4IT50TmosB2E/
 C5c1EoJcDHhQugNIg7w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0 adultscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0C86D14000E
X-Rspam-User: 
X-Stat-Signature: t8gyk6oarm5ustujgsdxbzbn3oudqezd
X-HE-Tag: 1779291642-961402
X-HE-Meta: U2FsdGVkX1+eR2Vgi9tlB3cCr0wZk2l/o8dG2MCxaEotXzcfm4g+/QO+ZW3OMcq9IcjlFO2CQsrdGZ5UpOGz8E6D/oV2EngqtgfzxVGKNzT+6gTw731dKQ3K8UsxnCCoOpVbC4YMMpH3xBjAoZRLWh4n1EFbP8raCj6cMAbvV34wRORZ++GZU/CZEZYNVNWyrvhHOSKkZlpiTEtXLMkEDQJhsX2uPETirAbwW+MoNzSR65p5nwRNe0152AudtJtWVk7T8t0F9gudSZhPCskoswf1ipzI94GpLk6FxYLTbkwEMMpKxBPUHvhRhxAflUJq+hn1dvE+7q0B/EoXKLWWgxTMkiwyTiLYPonMT6PlfB4aHLhrj5vg5MRr2b++xYHKbbvLSozOw8F21N+64qC6bF11ZUSSwGYyCOl2394oynyjORBIKfrikO7P/2e1F5dwPz+SLg9Ay1aj7s/1LbKvZODUeaL+kffAIoaJy0G2gzKEDnHlAuoQYImRAcLhUzomkTgh128pUzxPedm+KWtaeJmSlWg4qIHL5rhAqB1R0RFCgsU0KnVKGCvIKmony7k+LvADPtKfbcg69b2EYPZe82dh8VIF17SROJE6ePCw9C6ePBxsFUQFSk6hFc+Y5LzwPPXLig5mXyYoIcoCUiOlLO+AY01/34JlM7Vvjvw9nb1pw1cTo1wKwpFmjNGMhSHLgfdHQVkLn+aCYtYD7VBWbROegC84zkPhBm5Tp/ly05kP98lc1yN7qXbLG8ZlZqK9BSwBy2jSaLCmPCr03fiKRthBL9jkdaMrDJAeo/Gj9b4SZu7vGZJtD+PIMwAaz+PzsV3tilEqS2lBrd20cVYZqjKUQaUnzvLMqCLkyNzPB2YKrk5gSCzisBmLCssgkH4y0d6A1L1VGRqlljimtKysjA9KANA3HMsjL6b0u7OutTvGLTeAeWSTesbosFZUuK+bIyB97DmbFkeY+OwEEMO
 gwW3oOmR
 yefKj5+X0ksdLmVUDZJ1OBNRQhftHv4MUPjqTfjzaCJUDL9uCFwAHRKjMjztrSiKlzw4Xsw6HTeGo9Ezks71CFTlZDuo+m327hZL5toADhktVCOAwhwHqcxpC7JUjuYDx0cSxjGamGNi552MdHH/XhqQ5SumkiFzhwhz9MMuTLm/TVbqd7P8ogMrHFqJzG8rOwvCaaJ5YEGGKuiWfe1YXW84yGPuIkT9BQl91eUClo3UUuE9u86c5tfZmUs+AIQOcSsQpZfFlem3qWYRchCA2mVPBaC7zXAamOrvJ5+AFyMMnzXavIEGPJGZ/KKxZ4/g7LX7jHF3gBrcDI1zUyyzk0RNZ6pLZKIObppBrhxcnOcMIX0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SFrame may represent an undefined return address (RA) as SFrame FRE
without any offsets as indication for an outermost frame.

Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 kernel/unwind/sframe.c | 15 ++++++++++++++-
 kernel/unwind/sframe.h |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index a38f50a36363..f723c1a32f90 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -230,7 +230,7 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	UNSAFE_GET_USER_INC(info, cur, 1, Efault);
 	dataword_count = SFRAME_V3_FRE_DATAWORD_COUNT(info);
 	dataword_size  = dataword_size_enum_to_size(SFRAME_V3_FRE_DATAWORD_SIZE(info));
-	if (!dataword_count || !dataword_size)
+	if (!dataword_size)
 		return -EINVAL;
 
 	if (cur + (dataword_count * dataword_size) > sec->fres_end)
@@ -240,6 +240,17 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	if (fde_type != SFRAME_FDE_TYPE_DEFAULT)
 		return -EINVAL;
 
+	if (!dataword_count) {
+		/*
+		 * A FRE without data words indicates RA undefined /
+		 * outermost frame.
+		 */
+		cfa_off	= 0;
+		ra_off	= 0;
+		fp_off	= 0;
+		goto done;
+	}
+
 	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
 	dataword_count--;
 
@@ -260,6 +271,7 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	if (dataword_count)
 		return -EINVAL;
 
+done:
 	fre->size	= addr_size + 1 + (dataword_count * dataword_size);
 	fre->ip_off	= ip_off;
 	fre->cfa_off	= cfa_off;
@@ -326,6 +338,7 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	frame->ra_off  = fre->ra_off;
 	frame->fp_off  = fre->fp_off;
 	frame->use_fp  = SFRAME_V3_FRE_CFA_BASE_REG_ID(fre->info) == SFRAME_BASE_REG_FP;
+	frame->outermost = SFRAME_V3_FRE_RA_UNDEFINED_P(fre->info);
 
 	return 0;
 }
diff --git a/kernel/unwind/sframe.h b/kernel/unwind/sframe.h
index fc2908e92c7b..ed111fd0d702 100644
--- a/kernel/unwind/sframe.h
+++ b/kernel/unwind/sframe.h
@@ -77,5 +77,6 @@ struct sframe_fda_v3 {
 #define SFRAME_V3_FRE_DATAWORD_COUNT(info)		(((info) >> 1) & 0xf)
 #define SFRAME_V3_FRE_DATAWORD_SIZE(info)		(((info) >> 5) & 0x3)
 #define SFRAME_V3_AARCH64_FRE_MANGLED_RA_P(info)	(((info) >> 7) & 0x1)
+#define SFRAME_V3_FRE_RA_UNDEFINED_P(info)		(SFRAME_V3_FRE_DATAWORD_COUNT(info) == 0)
 
 #endif /* _SFRAME_H */
-- 
2.51.0


