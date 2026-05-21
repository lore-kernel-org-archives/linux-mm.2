Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD30CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713E96B008C; Thu, 21 May 2026 10:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C41F6B0092; Thu, 21 May 2026 10:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D9A6B0093; Thu, 21 May 2026 10:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 479596B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0744E1405E6
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:15 +0000 (UTC)
X-FDA: 84791651910.30.A4723F1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id ABD3318000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cxSEsK2R;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOI+endUXTAW/hiF8xST2Onr+K2NDqLcMTY3E9gHalc=;
	b=boC/x3CvGunLHhOHZ0D+SFa0oK3LphJCJt4D6Q6jzSJ6cl0kgYfisMXZchqehVcp2C6qnj
	DN6x8KVNH+7yn8yiGLQeYTPs5CzX6SeX+0QD+WrWATnn7DBfPTVnRjZ2AtRzjmHv2KF9Bn
	hSQXIPwqmSbSd/03CsaGkh+0rAs3ZE4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373572; a=rsa-sha256;
	cv=none;
	b=2FXyVfV39H+3MbttX01Gpq1cN+hJbSDs8Et9jj+SPvhL5/L1SFEXMjPyd4WTGm+VKDSKnd
	JQ6UgBbayhSgLoe8YVhn7EZs9IMFCRlp0Ve4wOwr8vlu+164E+hVmRdOYqU22Mue2kIz2P
	ApY9N9IvyLn/8DRWXsezBGPkoUGjYgI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cxSEsK2R;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L56Khr069859;
	Thu, 21 May 2026 14:25:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ZOI+endUXTAW/hiF8
	xST2Onr+K2NDqLcMTY3E9gHalc=; b=cxSEsK2Rq8pv0nfKEUhpLknSYTXA+4ddy
	V8+e4s4ccwzeYtjKbBF7YtBNtzaa8lkUrDsynV7JGU6oNX1O5MkysGgp8v2W/MyY
	2qulRMUXTpo3b0DfG8et47Y+opqk9CJC7/o2OpGF3LkgYDBMYQq3McYSqkAvZK0A
	9c/ArtQNA7k/rGp8pB5U13eczh3Cv1ggbpTsAs3JoKfQzUCDKgzBIGtoHoewvBvR
	F1GMVJwh3EtaoOwEIWlypg05LkHMDLGEB46klGIdAzER3LMjvL81xDFcnjQrIqu+
	EFpNKohy1KkrA5nqJS7ew+7SZMCmnoXvXtDQjfw+NqUFL3il5Itnw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8myd9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:57 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO5Oq002166;
	Thu, 21 May 2026 14:25:56 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754gmbhr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPqTC45678874
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B023520049;
	Thu, 21 May 2026 14:25:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5ABBA2004B;
	Thu, 21 May 2026 14:25:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:52 +0000 (GMT)
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
Subject: [PATCH v16 09/20] unwind_user/sframe: Add support for outermost frame indication
Date: Thu, 21 May 2026 16:25:35 +0200
Message-ID: <20260521142546.3908498-10-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 7rCW1Kl3JiSQvbDTjkeDjn_xdyYqbIvC
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0f15f6 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=U72JrVpwKSe1qDC-WCIA:9
X-Proofpoint-ORIG-GUID: 6oi19XfIJtW8o8a5alhlhnDu9LdS-yia
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX+FQqoPmuqXsx
 spCH1rZ3/2BhMfree/aFtSJg3/02POcjFlCrrjiN0okatgPjd28Aeh3lymXLoDeWa+wtRSmOJcM
 I/EtAEa5ooi4R1zT4zKnIraBpiliFKoLGy/ADAq10WPQVulIhzdtF6nNG15bhdcoSk8b9+YLVQE
 Mw9OHusxDuB75oNGcBCOq5cHhmJ1f+VHBh/YhT4g4KLUC9FM7VtUtCkUkKSbQqY9tsl0ZSCKK7f
 xmkI0JOHIlFM2+4pDdULWxFDr2IwGa/FZU6EQotKYZh6+lagDGWe1fm5gfgpqxiROOzTrTXybLJ
 HUzvDUEc+hevIctj4eKTSAp2P1l6GFj8DuHsSm8xh2/4YLrSyPidA3VIG2cg5k3Qitn9nSaCcXG
 jGzkUPOpILjCHE+0QitaRHCBKjMS3jX7yYRgRc36dGgLUx9DjINpAvRtTcsgoWzSq/Mc0tGC9pw
 6AOOqClSEssxylHmfSA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspam-User: 
X-Rspamd-Queue-Id: ABD3318000C
X-Rspamd-Server: rspam04
X-Stat-Signature: xcfkgsat15s1yfdyofrc36k1bf83ixrb
X-HE-Tag: 1779373572-630313
X-HE-Meta: U2FsdGVkX18oCpx7A0FGaOuQEar1ydrF3+MiFMcXtF0iORNkRRrEpScwvglscBsW9Mdaf1ivCtKhBq66VWgBFNJtC4qfalh46OM4Q7N7WOcjkyfV33DkekDnEDLjHknZp3nowsdQNsDEmW+x0LPLQQIjrci6PSSwg1NesMx23GUBOOfpAXR69Di7HnAWFK9cbcN4xDjCpiLVUoSwPsykXoDf2hun5VOo3FGeOys5iy2DhBLePIU1xdvO344Bbg9kKx+dKXK/ocNEuzwOG8mLHvSwake9s+E3bJS35Z3ikmiOMiULuHPynUXbM/rKMjaEXntJvpXjY6eJCKWE47YCTEkEOrwTDMuPjUF8KC/ecubF9BDeuGh+I0QBiaoNy6k31+j6GoaiWf60G9XMC6UztOL3/OCYGLw5klOrRyGJGSk/WXT9N6DaRG3O3QpUZbq2i9e8wGldoQifCfHifG/SrRvAV4mb8YGVdhVSUGlw8jngi1ZlQkeFdtFptcUAKM9chEkai3nA0BipNYIwRM77wl6K44uPVLNaa00A+iNjLh3u+NZFRdCg58WL2viVJABTWQfX6YXwjKn+o8Sah9whb6V/f0iu5cs/QSzHozNkWL0emLPyB+jhQMv9sJytDaxJAjBbwXWBW0ay4l5Ji3CUm3pZF+uWD2L0E95Iss6U7FZ51yxI8lp70248k7fEhbx1/Y32xrWv9YV8ilOXKxOGSK8VsxncxsjKzqvFyAeL6rqSSr1mGGqNqBi58CQVM7uHCXfCfl6LdWIaGcKuucoNUCdpa1YOq1U4V1YO87C87blDvrcSzecyYJPrCrdDVMtqzHP4DWuSxbwje/EKuiHNrxVv3vgvomljfCd6QiiD9se9J9ajz1o/EXcbrDJOvrXZZ+O1D232R+OVkPd56VOQdsKBPtiLd/1lQzAstmDZNJyXj84sK9lKjhYYODVa9M/9JKrcoVRvIxF/rOw1D6i
 XALJ4MW9
 UVb16ziEWEWtasVEkmhKZGICopGJi7oRaTOwAtNFUwOEvS6d5Cp6roLY3mOVyWlD+m2WHi7dDhxSnbO8kAYkO4ScZA6X3L28f6B8vMMKjk7lMWjuI7qF9/AizsZhuZdyowMd/3NNjoApFxirifyHFiCzuUGQWY6A5ktpd8CUVLiMb3BN2F6hjHkdhvul1u0iISbV35Tzi0kK12meaFmUpxp/mTqo6SLW+UwXXbjQAGfPf8d8tIlaAlF1dcNq7Sf907xAf694ONpJgKZIuS4p6RaJ0KeFwq6lDtD224xmwL8LLIr7THrrAR9U2ee75HbL2CEirTkajx+rPb+bWZVYGoyKBD3AzEECnVmvBg0fJOHzm2Mg=
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
index 2de29c836f6b..41ece3ca62a1 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -231,7 +231,7 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	UNSAFE_GET_USER_INC(info, cur, 1, Efault);
 	dataword_count = SFRAME_V3_FRE_DATAWORD_COUNT(info);
 	dataword_size  = dataword_size_enum_to_size(SFRAME_V3_FRE_DATAWORD_SIZE(info));
-	if (!dataword_count || !dataword_size)
+	if (!dataword_size)
 		return -EINVAL;
 	fre_size = addr_size + 1 + (dataword_count * dataword_size);
 
@@ -242,6 +242,17 @@ static __always_inline int __read_fre(struct sframe_section *sec,
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
 
@@ -262,6 +273,7 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	if (dataword_count)
 		return -EINVAL;
 
+done:
 	fre->size	= fre_size;
 	fre->ip_off	= ip_off;
 	fre->cfa_off	= cfa_off;
@@ -328,6 +340,7 @@ static __always_inline int __find_fre(struct sframe_section *sec,
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


