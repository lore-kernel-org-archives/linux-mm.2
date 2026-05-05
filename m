Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8EECCD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1E1A6B0092; Tue,  5 May 2026 08:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3C36B0095; Tue,  5 May 2026 08:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96AF46B0093; Tue,  5 May 2026 08:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 799596B0088
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 329B48C6F0
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:12 +0000 (UTC)
X-FDA: 84733268424.10.7D5DB89
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id AB06B180006
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kNLQOMGT;
	spf=pass (imf24.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNs3Y5ZU0LMKYw7ivfoZwS9abNt5pBN18h3+cHfz8vo=;
	b=LG6vhgS09/MUMYXjakHoaRxBznBWvldmVLeiIoIHYdqxn/jPgg6bjinFAqTb+7YKt6ifqQ
	RIUIjmpbqEplO3JqgPv82UwUSk3KkGVYVFQkCr87OEAwQcm9f7lruDFT8MWwEqweTqHYZo
	oRy82w/lgwDhSRjjzkf//Pgx2ii97uk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983489; a=rsa-sha256;
	cv=none;
	b=M+anxSaYbSSGuxrYZZyYCc1rhdjiSxnm12d6KdZahmD8FU3B2FPO1xDvA2yq8ipH0azrHL
	xUp9delDbEPwnQeY5hLT+NazXtKpnYsPUKsf4PATPL5KD9Mcs0AfTrLxA6PvZ4v6WqPcgt
	BFn4OsuBs126FFNs7HjbIwRkU+oTHT4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kNLQOMGT;
	spf=pass (imf24.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6457t57h3129134;
	Tue, 5 May 2026 12:17:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=iNs3Y5ZU0LMKYw7iv
	foZwS9abNt5pBN18h3+cHfz8vo=; b=kNLQOMGT45sNJUKfCx5DazoFMR5iaKEya
	f7AJC1kHFgwx24Cq8Qr+5bGh30z1hgRXDyzzivPb3M9A1XgPQNOTQ5CyH/jTdGJc
	fkniqWMHy22GoDb8MPSGBsyXPlDMRcFTm0Jceyy/TEh5Evl+/81CeU7Iu/tH+W2A
	wSCNZy6VtG31DEqNaz0SoFzF8EOy9bwo7BvEB9mAjvYLMcoSgRtNdPbmgCWuOkbr
	DJt3r7dCNmyLrT2X/g8UOVGoT1zwyT6R4apya69zVxsSmt83ksJl2wNstv/gwHTl
	ZkD008BkZ/l/3SUq4GPNaPsib1Ze7CMdZ+nCUnSdWJHXEPFqGKskQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9x4kg68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:30 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9cRH029301;
	Tue, 5 May 2026 12:17:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwwtg9bmc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:29 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHPJ362718426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9877E2004B;
	Tue,  5 May 2026 12:17:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 375382004F;
	Tue,  5 May 2026 12:17:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:25 +0000 (GMT)
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
Subject: [PATCH v14 10/19] unwind_user/sframe: Remove .sframe section on detected corruption
Date: Tue,  5 May 2026 14:17:09 +0200
Message-ID: <20260505121718.3572346-11-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX6xUgbgTo4ceS
 ogZQAdgcIJIxxAM+lzBqmWsNXHd2tIdvRpsDN+Y31Ido5wd68n1WDlJruNNeSZUOEHqYFhMl5Hj
 sjPQllmx0M8dL11QbRovN10WbQwsUTHPyHGk/7FfBEHQ5YF3UITY8M87rG3sPebNJVuAQ/B+TRZ
 Tc5mjq1sUTICz70+2sYaZ0tFOdnXF6W4iET8DVRqXQbOkIXNFKr5QqxWivNbQf1pRxtljjubtjA
 H3P9bzHgjYBZ9MClRH2HN2JzEnKK5fVcttL7M/hhO5+d8b6zuOB8hwCB57SuC1e5d+ad/W0pVcq
 JFruxSg1dI6fmh1Tm6K3mQHuO/h097JMzGri0AiBn477WdIpmnBgJ0DoEukZdwMmiTib1yjqrBI
 fAHn80dtnB5hcsdAOilefvyqg1apcVRz3SVrQJKC2F0bpj5SOT5DC/GGHE+9nV8ti4iHa+lsWao
 lbIE2SxdCiWn9G0h4QA==
X-Proofpoint-ORIG-GUID: ESkL7T1J9FVU0MH5Wd6VBq7slO6ISNoe
X-Proofpoint-GUID: EITj1tVrY_lYmK7h90v0ZPscXET4p3YI
X-Authority-Analysis: v=2.4 cv=W7UIkxWk c=1 sm=1 tr=0 ts=69f9dfda cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=QUyUFLFTtUP4SZQqb90A:9 a=zZCYzV9kfG8A:10
 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605050114
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AB06B180006
X-Stat-Signature: 46fq4utrmixubfjsqmfowpt19iihoby4
X-Rspam-User: 
X-HE-Tag: 1777983489-207876
X-HE-Meta: U2FsdGVkX197hsKtP61RpgTb+3uGAnWiTqF/rmxEJOJHYrEDiDWk6sEvmEU3Hk0m50gtaBokMiO1QnXw5HxEYQCXY3BkhMhKJopHtdTMmNm+semviE4sX3COj7nUoOuRqCvO3Z2fqg/GVd1s/afFoJ0wO5DUWQA5nIeoG8JelvBILNCOqDgGpWKfS1W8eDPNgx6FFjs/Csom+m04IWC5cHy1VagAtLVFCnFunFm6UcyMlMDd7dQCWIJdWawub9CX/oeWGz1QHdP1RcF/Wjbm/c+0LtHA1ApH7vIJjSxC8D5eVPftesw5rE4C5fbTPOww8CQ0fvcf+8cURSj2ftYkJwx70YvNOIoIFy2ZOUXcXhKw7vkWDxVT3PQxwLXGNg6r2GKPXRYd1BDN0BceONkpQ0yxEIj/9rDCMU5yU7hNHaH516UnfcVISsk040CGuztkMG380d2nnAvmsxfUgROdHgVjuxYYiacmKM981UZ38gN+MmVDDqhP+v5Vl3TabOJ50yPE4Z6GBk97Zt/70/TVpd/g/J2l1dvVmYMfZnjjNDzwGJO/KCw1duZPXWzUOJp6j32KlOGRxvTH2pu4LvpLZtOaqkcY/tdAM+wA5LO1t8TTDhb9+wKCl7bY2vYYOBOjP7c/pNbx2DayIJQ7xW1GRU6v3Te7KftPFpG+E/OW9JUV9VSZrtjz+bSJqQ8GxM0ZSdt3sSVedVN59UwsLJFKjkcFnCqRjeDCSJlBhujmGg5LjE5piXDJNP0mn+Wl3OYB8uM8/b+bWhPUx2LyGvZoLG+SuLqaaZVk73svoc5oBc3xa2ypC4nnCWhwXr2RayMW5912VeB7rAG5SAkJSy0YE9Zn20tOGaK8eX+TYXSrrFokqqkDLRhnSKRj81UduGfyeEoKWC+jT2lOyM8iPSqeHcwa0r2WrA4GSK2L1CWK7F9/f9dS+7a6wWM5s7hPXyFNdTRUC9uArhRAGhdU9Xk
 tXn7TlOX
 q5LjVqoVw7DZ0bfN0Lw2oQsAkx/6lg8hrA08c2HpsJrgGRUuw/w3HiNvPXKzZ6gfV4Q66CMU4Y/idL0hMltLvz08nAXPcoLbs53y2QhTvY8WoqlIuRvr+AxwMWFbiL240+1e1fQv89m3Ozee/jeLeJRJuRMrRKZVotvvysm7zm5G0ETXbzMiPUYZdbaMse8Dpsfn+egVgPZvDwz+crC0f0Sly3+FyqRpyoEKGANfFwW7gyXCOzSlPIG0UYrgK1saGPsy8cUM809PrNewtSp0CDER8nGP/TRJ7JHDG9xMXfRTOGDmkKnCYq5iNxJMxea3/p7hHt/FX6/59yp0UV4U8Kx6dNSRs5krebbP9L1GzcuVktZSnb6HYfeM6nDUNCJRMHdriLdXQ4B42W4x7C6KIZY634G0CrLcWnEVYt1alTkljziuJ2vujirvIG2CY8A1RTTLJzif3DZljNgpMpPZZOiVIKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

To avoid continued attempted use of a bad .sframe section, remove it
on demand when the first sign of corruption is detected.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 kernel/unwind/sframe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 9c755965ab83..8eed6a7d9625 100644
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


