Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052DFD2F033
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7BFB6B008A; Tue, 27 Jan 2026 10:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05A56B008C; Tue, 27 Jan 2026 10:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20AB6B0092; Tue, 27 Jan 2026 10:06:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F72A6B008A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:06:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5044F160224
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:33 +0000 (UTC)
X-FDA: 84378070266.15.651F95E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id E88E61A000B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fQGUKr3P;
	spf=pass (imf19.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769526391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqoUo0wq/xUVQ08wQS3GDigATks54kCDHtiMA4j3FTs=;
	b=MmNgnETJ/GWshoesMSbiYMCycxEYLNgcZb0w0plLekIlip0LI89DJTYrN20SiDpmCeke2v
	jDFdrZHn+WJvAQ4luktumwNxFKMYXYa2CzrWXrW3ZLzszT+xOBi1n+kEHkn1n1+6ABtlFe
	JMGbTmX7/Hl/6IYyNGW9qEau31ALIlU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fQGUKr3P;
	spf=pass (imf19.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769526391; a=rsa-sha256;
	cv=none;
	b=ZN6YmtJlVMx1gIeLFD5jmeq5GDDlgZEEcqJT1jaJtGZ5S6Duub3fbeFL0NfrJvPp/HhuCA
	YtB0dIRuuE+SpqsVYr7oNwvqpvbqwnxsSejflhhR7YYS/TS/+WSwbZiuf0ymi2z/VgaqnO
	442lTJANMUy19eVcrrGevJrlUmX6sHs=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60R7SZHb002736;
	Tue, 27 Jan 2026 15:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=BqoUo0wq/xUVQ08wQ
	S3GDigATks54kCDHtiMA4j3FTs=; b=fQGUKr3PKkcBFYy4Zp7gCNwieS5UthKrB
	oYXEYeDPH+6+qHswUVowhRZWM/NM7kKVBh45j6cCHcM0dtyYMdGkjz4Yr059yk9r
	EACsLP0BKQLO/Qm9hxc0QPvjfChyB0I+BcISVT2ZkNy9viKjSpHKm2iyBSImC9Cl
	6jv20HMuc454KUkVqdEhpRgUTQ2dEcunfSZI7XkhiTz/zmYTsq4SmqHKUMDb3t6r
	dhAQJIzOERq9+Xgb11lAjcZbUrNU0+tGpgXH4cqTUtOgbmRi1Z/463c2xvy+JFno
	DpR06T3u4AtlFXib9EFPpL1y6q7ta8xzWueSIUNR4C+2PRgKHjqWQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnr646qw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:06 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60REhpsY020393;
	Tue, 27 Jan 2026 15:06:05 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnr646qs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:05 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60RDEoLv031044;
	Tue, 27 Jan 2026 15:06:04 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bw8dsh6cj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF60Iu39191036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:06:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83F4520040;
	Tue, 27 Jan 2026 15:06:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B0DB20049;
	Tue, 27 Jan 2026 15:06:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:06:00 +0000 (GMT)
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
        Dylan Hatch <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v13 09/18] unwind_user/sframe: Remove .sframe section on detected corruption
Date: Tue, 27 Jan 2026 16:05:44 +0100
Message-ID: <20260127150554.2760964-10-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfX9dtk6uVtCdRH
 tId1yvkI/H1UbXz8xpStDEIEFjEeDs3gX4Cjmp1gwSeJXDevIO7Q5AvsjrI0jrVqaNT5MxBciba
 kG7KAPlvsNLuDOqiNAymSs6nn6sk3PsRsBPh2sM2FOGSP6h+JatzEodqXGtSiJk/7Sgdr0Xn4np
 xr6DcR75zPNll8nF9sG0qL7zyfxKmq1kb37+3/bbyMTHJmfDhPEnmlI4qe0o1x8ERGNK9YYJDuN
 uNwfS0y4tWbDRv97l5Uti//o/gXaLQ4OcDSmyt77bqCP/ppfNVHlcPHF40JV1uMkK7btskDJi6C
 yHWrRetluRtVzj1Rgv+xC2SUigjUuckoGQP8weTOtY8RxkDjyqJFEUIC+Xh3oNJAJuhRfkK4F+I
 ccVrRHGErH2WtobWDmGe1YoJJoM70hWn9WR+Bgv7V6n6qSgvzWng4q5w0mTA+Sbo82gAvqAcS2e
 NY5o8zkeQGH2vIbR7Rw==
X-Proofpoint-GUID: 5XHuKtAdbWHV3NOc049IMGl0YAFe-Nfy
X-Proofpoint-ORIG-GUID: OjNNiXWl2C9A79lDqi2h7zSLQYwtqHvm
X-Authority-Analysis: v=2.4 cv=X+Vf6WTe c=1 sm=1 tr=0 ts=6978d45e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=UW-gzNxWWvgdzlWFvSoA:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601270121
X-Rspamd-Server: rspam11
X-Stat-Signature: pr3m11n8pb7nwaaqf9ysk6p6of6oqamg
X-Rspam-User: 
X-Rspamd-Queue-Id: E88E61A000B
X-HE-Tag: 1769526390-355390
X-HE-Meta: U2FsdGVkX1/1sbRe23U7kieTbn9f2zw5/jl994vpVUkIo6wzRB3VH6raB5K4X2k8Do1SJ7j/fN+GPtWU7C6hMwPEPja9ZtAtcFX+NEHa5k5224w7G3rOJkT8GGdY0uG/LkkrWkBx1Pzn5ZdPTjh7wBicVl7wY6iAwVpZn6M/jqhq6RWGuItLkcsurcPFO3TddFEZoDAqwkhDYhp2wW6IX76gTC3s1a2unr40pnNAa7SSaayn0hqK2KrUxbCgxOmAahzq+YuJE+STZe6DD+esm+dUMl3lSFcBX3Ln5KcCXko1c6FhEUMGYUuwqbVqB1i2d21XGUgfXYMpxDgn8BrUjJyYdfCqn8PiS/70C3xHcKGnDiQF3RJuxvBfSj9/+vb5ovJYkvELjZ4W2bxEmtCkn75mMFuIyHW7fxYOFEczQYa0FWJdKYkZjaXjPkrsfStKRTRfFWxRP+0zVDXxMvd+nevsAeMM5J+D98NfFpr27IWtEG+YKUbeS6Sz6UcTKPxbqSZ57BxLpt95e1D5X335kTRChMhQZ4iBRHSqJoM3txiPH9S1u1Rt2myr0nFpmv5XXcgKbV0dzJKGnAfWBPFvTMai22DyAxgKS7nDJMVTCBw4cUpXq+jbPL+YP+RRPbC/GljvGf6D0dYuaUaIDfPuEat7XuB5/KgtrJviM4j4O8GZH/2R9JM//+O9N9L1r0ASl31EfejXX9CMPfyfUPaO+DSF/F82RDvRTE0PoIRYSP5K0BoYydqeAvgA3cGGlGs5MUOFO25o+zsOpxpG+TDI68ffAiWZDAsionA5yDpFrX3lfQ8hJKpqGcLk2bDuxBfM4SsYsiwth13obHvBr3U7PJKnuFcOe/9eWlWcb7HDtq3TczkjP3JP7JQ+18wieYXQjgC+Qabkg2SeabzXuiTzLqFRKe9CnK5ShYx9C58tRSdJBp6/ZsNpa6gsaocMgS+oGzCFM/5PcKywiAorxFH
 uJSqC6R9
 Fmom2q3B/JsVLl9LDzOvJVBXYbuYvj1+jTq3XvnovsGv76dd0ku7H3j3uNSdoWruJTG8+ft5CO7YtXM1nOGJ13/quV4F3uKehHR0nMFcxb6vJOooLLBJmBb9zH9wtdVrQ2QkWmGOVUIDL09qI8I2Ra6UmMErdPJtt2XkHJOD5mvDGPp1ICWxP8mIbiUWtUb0xqRTAvDV/e4lJlVt2PYPycyzMScK+FbnEHDA/AarepNNi1wV0oAtoFobOgnM0M4JOikanCyAfe31JeARo1k/LJSBTiQeaIT9dmFqI1XFilBUA1U+PMz2FAotAIfbKril1SZcLwJ44gURwdnt0nTHgJ3dln/tPTZgycTa59BFKm8lni84SrMSk4Nvj26CuyHTxMbVA8Z5K+bpvAFeKuQDfO1oWi+iYPZT8qdMfNGA4dgz26iDvXQN4Eal4/vwyrft7nCYkNCRDDnyATZRmkb+PHlJOL8RvHrR0Arzpr40exETDS+vYk8G9wPO6BGxufn2PVlmfYBLd03JIMUgG6TMyNnaqxA7ME2tilskU8zabl+l5aiYHdO+4mCkYsq6VI/o49i8th9uGO1/COOv+ONuPLPtMK2apR7JX+HEO5apAoWev3XN/yk+LqShHLKVj/8FOelqtAlU5QLcKTH87qToAiD8zlFGJKiuVBWzg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

To avoid continued attempted use of a bad .sframe section, remove it
on demand when the first sign of corruption is detected.

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
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 kernel/unwind/sframe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 6004b43aac34..9a63f8828593 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -358,6 +358,10 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 	ret = __find_fre(sec, &fde, ip, frame);
 end:
 	user_read_access_end();
+
+	if (ret == -EFAULT)
+		WARN_ON_ONCE(sframe_remove_section(sec->sframe_start));
+
 	return ret;
 }
 
-- 
2.51.0


