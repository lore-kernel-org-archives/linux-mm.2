Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EAFACCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7F08E0008; Wed, 22 Oct 2025 10:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31DA8E0002; Wed, 22 Oct 2025 10:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA908E0008; Wed, 22 Oct 2025 10:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE5C8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:44:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 588DC48875
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:05 +0000 (UTC)
X-FDA: 84026020050.21.4504365
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 015D3C000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="M+pYsQ2/";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761144243; a=rsa-sha256;
	cv=none;
	b=4CdJ0cKaajDf8jOXavx6TcRWsRzye7NPuo1VA81dYhT3TydWKW1yw2k0tpNs80DSDoj1wf
	D6DljbR9jKKF/QdMAdrYSrBsf8Cc0UzVggSLzkIAks2yR7SIp6F0B4Ktd4t7H8EPkUBzLa
	pTvLPuNMEOSW8sFjCI9Clj0Q3H9sgvo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="M+pYsQ2/";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761144243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYdVG1t1tt/Dxbg/e8fHwqU+ZHySAtpeMBUdGiGU6Q4=;
	b=KIOgTTzxhzfOEmViaBH9TXrvI2eqZx9viXpCKQrB5BQdvkzhUlZWaTvHFm90ABQooVOx+g
	78qN9su6IjDffTSjGjmlARhXoxAqtkzs0aIbgSYHU2ULb+nm4FHEN19CcxfRQwqDZg9sxt
	1TapvIkiRM+ADMz0VKVO7wayQeDkUdI=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M7WQ4M013165;
	Wed, 22 Oct 2025 14:43:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=pYdVG1t1tt/Dxbg/e
	8fHwqU+ZHySAtpeMBUdGiGU6Q4=; b=M+pYsQ2/YhROcfdUSaoIm2lW6ZA+EG4jg
	teXknGaoArJVhxWkQKWqOeZPAaiWocQ36Zt980rRL8iTxW5edw1OvZUQfAjt+ubz
	Wq4fQNzVkW9/AgjRFkp+FgI6WHINDVLpcQPQuZoEQdLS38UYysGNZJxmrgC4dLvP
	1iehLRbwbjLCqY/fzL0nD1RgLqiuPTbvGZmCEhDDgycidH2IZ7264YtczayaIwwD
	ST8vlS3FluLL5moqWptI757SxgQ7FABozdrJ1umE5gShQxYRNECspzsi1wXIPuFm
	YH/oRRAyerls/jqNj09/Xl9pKUmpbUm+zn/WoviuFyoyLB9xzQ/uQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31cbxkm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:39 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEhcRZ006768;
	Wed, 22 Oct 2025 14:43:38 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31cbxkh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:38 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59MEOv7N002926;
	Wed, 22 Oct 2025 14:43:36 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqejgnrm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:36 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEhX3o37028320
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:43:33 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9E3820040;
	Wed, 22 Oct 2025 14:43:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83A6E2004B;
	Wed, 22 Oct 2025 14:43:32 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Oct 2025 14:43:32 +0000 (GMT)
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
Subject: [PATCH v11 10/15] unwind_user/sframe: Add support for outermost frame indication
Date: Wed, 22 Oct 2025 16:43:21 +0200
Message-ID: <20251022144326.4082059-11-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BRfWPx8QpkOpLG-aZRCA8NkTlnPIHAYu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX0vSzKkDt73cM
 3rLWH8RLkV7JHq4JXE+T653nLHx73jTvYwfVYtsKYV12ix9McS9Wf0jnwBg0tcNvV3/G/XKiOyK
 1v7iXrlYUQ8RCah8QoxYReRaHZ3jAkbiB8mvA1wPqBNl+1ibIUXu0PeSySgplUJ7LMpssNZA2iW
 yqYnt5EUKSdT79kZ5tf2p41NxgFdMI90hW8ngYzBbMK7rN4W8qVuL7yFvHWMcKScgR74mIXcVfg
 JYzfsmEo8V7vdj7U4B2AGeewXng5iORiFzE60dWEBgUbDKq0QzrqAqh1lu1T/v7xoJ+mOZXM2va
 isN5F/b1qJyi8+qoQSBJGsXr83v4v2CNsmXeVnj7PEQWXYwZ5QaJoPS9HsqIPiPyL+G44Jiwux6
 in+Su6An+kB17bcHLzp/dRlGyWHm3g==
X-Proofpoint-GUID: o_CQcPWl_RPECQVJiKg9vKYUToiB23rx
X-Authority-Analysis: v=2.4 cv=SKNPlevH c=1 sm=1 tr=0 ts=68f8ed9b cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=mFg4y33aAicYmUfzDuoA:9 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19
 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22
 a=wa9RWnbW_A1YIeRBVszw:22 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 015D3C000F
X-Stat-Signature: 4hspbaawfxmm6rtztmmsoifajapmcy31
X-HE-Tag: 1761144242-145831
X-HE-Meta: U2FsdGVkX1++VDa7bPRON1x43NJP2Ektravw9MP5e3r21QGLL3p5tkUqZI3kb2hDQ6K7jXlP6BfPXwck2vaEgMA/DHQ2h710a1dZB3IV+YAnmv5pMmWyQN8OjPVbYRQDOMuCEuj+cwSm96OOVKoaJWcekL/YRmSFhsdKtqxmdMKXPIFlhCkIMZYs+/4nUgb8r5rwHBVkUgNUkxZn/sWjEw5/181ueHxWDsYHNYQ/7kziKtIjOisllA47C2M5XyGFLjvNKOwutQH5WHuvX7/swPese4b0u9xbu9yorvAbp8m09vYLDiJyRI5z5hdNsjQs4v2BCZSbrf2j6f9Q7mAxbL275DVOJV1ir4Lj1wD7ASYm0mC/bu8BX2pEld0OsQn1XfW3WQIonoA3Cbwss7SYVLxhCqEYsje0ssFkeHTzSL2NZ//VCF13Prrn+VkO6d7uDwh5ms9fc35XsprmFFZmbJrMIHX0xjF2w3sHItemEvSL1hbLhXjMkT6dhkUrL4cr4/6NcZwUOp0d8yPLlpyAWzlxb3qd4IRP1+fexI9AcBvHmtJCoAoYvDc6zd4nZ9+VlPJAyCQbShB558BGQHNM14cmFJlBcMnsS1UXb7P/nzfV4iCPGrUxpa5pyKweitPExfOcF8Pxn2QDO6oEgeKj7uLvK7Bo8gNpqOyq13wrxiuMiFZDOz+sKn1El5/N4cAVhHgNWHVDMtzDSSu0tXOhFdl6/m73Qsvclwu8Qe9IvYd5vgdumblLqOUE90tnoHK8f0CyadJ1Rosoi4bRKEaXkxa50GTK4VDtdz/L0Xxvq6AbFTA1zZrcHklwr9QPk+0Fd8nwel/OHXLZmoR7FOUI2FefXcy6FomtL3HJgjHrTG5/+gPdJVawz4MxIfVTgziDyvHgQ4sekBg9YVnWpcvc6zc3aI0HX/6T/QdyQzMswuMHg+/bpratICExaZ3hRvaw9C8kMUwNchx7Lpm/zPz
 V5OSsz/6
 1FqLXjL3B4BO96xwnMcMTvWAoKSPT2EZExbdLK2kk9hUh7O2YUDNNuE1inMNh9as8LrrwA5o5WT6TS9SViprMx2WRkjCRW68+hhhSfhA9C/1TxSdrefYm++gGaAQrW/gpE0eYh0M7lzUTG8+B4lMu1HJZyv7WhRI+7Xr1wmFeWHonklyUVbw8tVYAq7RAntVW7eEPB/SX+/uPtOh4bCuR0nB6CYqntssUBB3NgRiEdBkHS0M9czSJ1ZXwjdgHtYj40io9fjS9Cw+tV38s46VDGOpqzvyBRfIk6jLt3viAlnJEnhWqR3ZLmTnz227HbZxOMnWo8yjV9v8e2ELE0AXF9W3sgLYo6lV88se0If6H4J7V9elYgC8HRKCVibEFRbmiUJMsLPUo4ccUv+wZxgpkWqO27yP21Rs5cYb99w74jaSVNRZ5twUW0iQzu+PTMAe1Y4kwXkufJxsSaLSOkF9148zt+mxMHekf8TtVe9a63bm9q4fm3BvQ35QsSjQkELaqHyqDVnvIhibDKu4tvnqAKGNGBNoZibfoWQIKq4a3bysJZW2G6JpAbx0Lw+74xkrMdAq7MqY3tp8FQ4IcwL209xWSPw2v4QsYuRatB4hAi11WY7wnmkhbkdjH+BGVb0Lj+ERyR9j7izkic8RQFfCLVgHw3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SFrame may represent an undefined return address (RA) as SFrame FRE
without any offsets as indication for an outermost frame.

Cc: Steven Rostedt <rostedt@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>
Cc: "Jose E. Marchesi" <jemarch@gnu.org>
Cc: Beau Belgrave <beaub@linux.microsoft.com>
Cc: Jens Remus <jremus@linux.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Sam James <sam@gentoo.org>
Cc: Kees Cook <kees@kernel.org>
Cc: "Carlos O'Donell" <codonell@redhat.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v11:
    - New patch. (Jens)

 kernel/unwind/sframe.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 5536374e2a22..bc3e2eb00325 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -24,6 +24,7 @@ struct sframe_fre {
 	s32		ra_off;
 	s32		fp_off;
 	u8		info;
+	bool		ra_undefined;
 };
 
 DEFINE_STATIC_SRCU(sframe_srcu);
@@ -173,6 +174,7 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	unsigned char offset_count, offset_size;
 	s32 cfa_off, ra_off, fp_off;
 	unsigned long cur = fre_addr;
+	bool ra_undefined = false;
 	unsigned char addr_size;
 	u32 ip_off;
 	u8 info;
@@ -191,7 +193,7 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	UNSAFE_GET_USER_INC(info, cur, 1, Efault);
 	offset_count = SFRAME_FRE_OFFSET_COUNT(info);
 	offset_size  = offset_size_enum_to_size(SFRAME_FRE_OFFSET_SIZE(info));
-	if (!offset_count || !offset_size)
+	if (!offset_size)
 		return -EFAULT;
 
 	if (cur + (offset_count * offset_size) > sec->fres_end)
@@ -199,6 +201,14 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 
 	fre->size = addr_size + 1 + (offset_count * offset_size);
 
+	if (!offset_count) {
+		cfa_off		= 0;
+		ra_off		= 0;
+		fp_off		= 0;
+		ra_undefined	= true;
+		goto done;
+	}
+
 	UNSAFE_GET_USER_INC(cfa_off, cur, offset_size, Efault);
 	offset_count--;
 
@@ -219,11 +229,13 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	if (offset_count)
 		return -EFAULT;
 
+done:
 	fre->ip_off		= ip_off;
 	fre->cfa_off		= cfa_off;
 	fre->ra_off		= ra_off;
 	fre->fp_off		= fp_off;
 	fre->info		= info;
+	fre->ra_undefined	= ra_undefined;
 
 	return 0;
 
@@ -285,6 +297,7 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	frame->ra_off  = fre->ra_off;
 	frame->fp_off  = fre->fp_off;
 	frame->use_fp  = SFRAME_FRE_CFA_BASE_REG_ID(fre->info) == SFRAME_BASE_REG_FP;
+	frame->outermost = fre->ra_undefined;
 
 	return 0;
 }
-- 
2.48.1


