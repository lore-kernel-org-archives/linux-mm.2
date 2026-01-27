Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D75D340AF
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 16:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637CB6B008C; Tue, 27 Jan 2026 11:37:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5A16B0092; Tue, 27 Jan 2026 11:37:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49D1C6B0093; Tue, 27 Jan 2026 11:37:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34F626B008C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 11:37:56 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 013EB8AD0B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:37:55 +0000 (UTC)
X-FDA: 84378300552.12.98D7424
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id A12561A0002
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:37:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pFZvMSDU;
	spf=pass (imf19.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769531872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4adnvlRASqyynXmCGJAHcQWpHowlKMkoygtl7xi1WSs=;
	b=Go/1TVwdjTubqvhQlN5ENjlKLaFSXYrFxa/tzxZh4dxZf10k0LhDAQA5clpAat6jY1tUKt
	lcoLsdnOTmxM+ySSXwdvOBD1wILkkEe5IMcMrRJpDL/T8Ae/SnhP4oyS9prdmyciKsUS62
	uVeuUtmqWo21O6Yz5+3Ly88cEgRoWsw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769531872; a=rsa-sha256;
	cv=none;
	b=iqTshnmPX1tt2gkudaiN4GcW/0u7H4n0YtTUTvodB8mBTHf9MiIQz940JUgVhAYtPl2/gv
	LniqSoJ3SnjNFbMWmhw3FY+aE2jddecUL9O/AApAWuhFsK6ETiYPS0pEoxpgIDqU+3FuxB
	a9ykVyk/ibwzrpCYCX5+P3C0bnPboNQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pFZvMSDU;
	spf=pass (imf19.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60R7XYbd028672;
	Tue, 27 Jan 2026 15:06:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4adnvlRASqyynXmCG
	JAHcQWpHowlKMkoygtl7xi1WSs=; b=pFZvMSDUEUAfP1DmE3zEnX5ZY5VxwCjCN
	3axQRjpXjPru3P/nmqXez27G9kh6xMNRvpp9MKVYSrH6aZ+EECXaWmX6xGIWhQ9f
	VCNzaBhj7VNOtVrBIYUyKb3aPpx29m0TPwuz1pJqx5OBvPfEwfDlzs/HX2h7/FBp
	CKB2a7LSBfgc/CbMuYv846uJvVoVvEK1xhEui2NbwBoM3cpB+F5Zt1lrLgRvIWxE
	s1YWeFvuwkxtdzHer6fQVOYVwZTf1C/6xOioxzNQrJbW09GzHdKHDBiPEFvOQ5h4
	1w+vW6c4JYD98deQXJU6cOoxjzit53NXvH/hQAYdgRcm+FtdHFzsQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvmgfvde9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:04 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60REvWsW005540;
	Tue, 27 Jan 2026 15:06:03 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvmgfvddy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:03 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60REWmD0023635;
	Tue, 27 Jan 2026 15:06:02 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bwamjrwhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:02 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF5w4H62259704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:05:58 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1EE2920040;
	Tue, 27 Jan 2026 15:05:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB6DB2004D;
	Tue, 27 Jan 2026 15:05:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:05:57 +0000 (GMT)
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
Subject: [PATCH v13 03/18] x86/uaccess: Add unsafe_copy_from_user() implementation
Date: Tue, 27 Jan 2026 16:05:38 +0100
Message-ID: <20260127150554.2760964-4-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z4vh3XRA c=1 sm=1 tr=0 ts=6978d45c cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=gpC398cPzQKiNBT45cIA:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-GUID: wWLAwxKLDR56egnD3ibSJEftoBpl7R4C
X-Proofpoint-ORIG-GUID: fPKE0b2Hahn9KHpZXBsmmNBym3BITZQD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfXxpJQvjvhXrz6
 JHEkZjiGQa+4O4Ml6OB4AchVLY0fRaNlYlXGP0hjW9qQyGnt1LONySFIm3bPWtYw+Y11aeHTESB
 /VNubUEMF/CHJc/bRg0uJFR4GUuv2VHZqRZosr/wnLPNR8sdw4E86uEcMAGpTPuxRzxCxvtD921
 6dNDvBmBLpbg8caFX2ujHJgmY38AoPSJbbyDBgeL5X79Rjjp/h2e7Gzw99700SYNeDNMyLvuiEK
 nBMhE6qY8cLqI0A6q6io44czFB73cnxG74IzFJt7fg9tAh2hXDL24NtjIRa/FVSXwve3riwFEd6
 Cdu+gYKQzWgJrVXt8MC3qZboqfRltGdVyb0sHu4lwPvmykEF3aiXI+buYhTbnJNlDfRLlNQwWJi
 Z/6Rh05mx2QnFfRaVPiAZVekS7nSH/dJcqBUOj+UZkZr2rsxtzxSeCwiCkCrXoX3tGg+9/qHrXP
 n62TpMipDO6bKmUNDIA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 clxscore=1011 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2601270121
X-Rspamd-Queue-Id: A12561A0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kegjoqqpxy4mx896sx19yz1i1i4o11b3
X-HE-Tag: 1769531872-275937
X-HE-Meta: U2FsdGVkX18KGvATuLrHGSY4yrmcANwGh2BAtscKg1HrKurkbXIuhg2m1y5wJc5eoxYfL7bASW8UIEz20nheGzuKQTHp6KGXjbmSheExpTGTpb6Q9y5rXgu49F4pfFdjgPygzjsFU9DCTjppiRlzZgcHveQEg++LSD28RGmaXGPyxRjcUCKeyAuPp/qdIWe2BkjE29hJxRxWrxoKxJmyD/NCKb4n7CXzs+AweeQo6eCRQbP/CU9qjGOOuhQFg3z+MWtC+xUYXOBprV7pvJ9NPDhGp3TnokFQUvfLmmsp5T+sFrX1JF0CKx1XpaV/c5c5pPaLRPgtZJX3b7jgNsEp0IgNHrQ0Jz70CnGL7HCsIXF/TzCMhdwMNWQSaU5oJm5toYqDoINo+XplwZp5XauOfnd4MRxVt6CIxzwpXUZlvUmuN/e35kWHAuCmQDZN0K7N1xoJvxGAlcOVOCEhBqfnY8vI6I495IfQ3Dg7T23BsVSREoteWWQ1y+mJ1tqbEO6B4RSBujxlxio61DCO7bsJwsc2fH7qOGkyppRjsSQBI+EHeCOtZp1eYzZEsitvZGrNonkaD86LC98m5uis9zn9OGylxEsrSrCRS4Pbys9No3ug0jlNzupD0JTVLuPrSAK4RH47gcAcdrZu+Xkl+LBnA+1V6ycpEkcdSKyEtCZKQ5F5woZInaGt1vtzjol1Y+fzJWXWCpzFw3Nin3ZH4R2oSnpiboCMAHJEcDyJV0h9FcOKq9RGWY4eyUpuIEAypdoheXbb2/lDN/Kygszn95NtV8N8eGhg7jg0SIahsbGMwJAfQon6im0EAnZkfZ6Fuxs9VZM8EEpkTQ1ECdSCI6/nCyCFUgvaNlVNLwFelqqzRVm04xUhgeMkm9A9mV0ggGxtpKqAXsnMo/5I0dvHCjjmXa8njy2vcIaeEXu6VkcoJEBsfJrBg0XqcJl8Tacw8coh5jlzsUCx8MGE8sJ4o3O
 /d91Afo6
 gBLkTsYmIXSG0lR99JyWLsDdsVbbOtdajNcvIRvnJMnbkOLhuvk1mPJdZg4NzgIeIF5+j4sGTLUQC+wVfUkxBrWzgs/5ooYR6+9JTjPZdjyNA+ePtHhAtCmgCTILXUNmB4b4rMz8vmr43yRfQXs6u1wLLG1Ed0FZ5ibcxuq789BcVritvgf9tOXfHvKnjIHf9WXZsW9G2FcrjHAXdiGsuvn6EKB4spbbDS/5dDdPtt6thJOIbZHnzwYR67R6JYa1kTqtJIzDQ7v/eX2Zqj5XwR2k+KL3jmtmRFuigfnbbbJvFDAcwKXj2oKTpmgH2R4WsmUNN/vfV3C7tgcHuERCYnV5gp9DzvCtA4JfAruIcRs97xmWMMGW9PRA53uU/Zew1V555dmEw5O2zPjnNZ6nacqRQ+jJApMG8gQ6I3VjAdeOHw0SUQyI/Cs6Z/s8G2ImQ2j7WLMOONiysO0JSxiKsr1z/qPiz+CPOKtNQCNDTU7Zf8iNGPVZVG7DT9fMEOgX+pP4j+EiFsoOA4VAV2PHKvs4lxsi8O5PjOb8aaG9VwGiWv0HPALhM2lBmov9OkOUFebw0Bl2Tu0RJ7xCLTOg74haEK5/67Pe4dyl6M9gfOy8wXjQ1o/IjMKCLN3ssCaQXPX/k57n2bjDtBrEFakJAC6yXlI3KcCx7LYaklp9X2d8eDJkkKQfsBomYN7KqeTuP6IcEgvFUP79vfiBsFY8Q0N+u8+JI6hxBsAO/+gJzkSpIEY/pvlukDPv20p38IKm3F3iO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Add an x86 implementation of unsafe_copy_from_user() similar to the
existing unsafe_copy_to_user().

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
 arch/x86/include/asm/uaccess.h | 39 +++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 367297b188c3..dfe143235967 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -598,7 +598,7 @@ _label:									\
  * We want the unsafe accessors to always be inlined and use
  * the error labels - thus the macro games.
  */
-#define unsafe_copy_loop(dst, src, len, type, label)				\
+#define unsafe_copy_to_user_loop(dst, src, len, type, label)			\
 	while (len >= sizeof(type)) {						\
 		unsafe_put_user(*(type *)(src),(type __user *)(dst),label);	\
 		dst += sizeof(type);						\
@@ -606,15 +606,34 @@ _label:									\
 		len -= sizeof(type);						\
 	}
 
-#define unsafe_copy_to_user(_dst,_src,_len,label)			\
-do {									\
-	char __user *__ucu_dst = (_dst);				\
-	const char *__ucu_src = (_src);					\
-	size_t __ucu_len = (_len);					\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
+#define unsafe_copy_to_user(_dst, _src, _len, label)				\
+do {										\
+	void __user *__dst = (_dst);						\
+	const void *__src = (_src);						\
+	size_t __len = (_len);							\
+	unsafe_copy_to_user_loop(__dst, __src, __len, u64, label);		\
+	unsafe_copy_to_user_loop(__dst, __src, __len, u32, label);		\
+	unsafe_copy_to_user_loop(__dst, __src, __len, u16, label);		\
+	unsafe_copy_to_user_loop(__dst, __src, __len, u8,  label);		\
+} while (0)
+
+#define unsafe_copy_from_user_loop(dst, src, len, type, label)			\
+	while (len >= sizeof(type)) {						\
+		unsafe_get_user(*(type *)(dst), (type __user *)(src), label);	\
+		dst += sizeof(type);						\
+		src += sizeof(type);						\
+		len -= sizeof(type);						\
+	}
+
+#define unsafe_copy_from_user(_dst, _src, _len, label)				\
+do {										\
+	void *__dst = (_dst);							\
+	void __user *__src = (_src);						\
+	size_t __len = (_len);							\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u64, label);		\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u32, label);		\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u16, label);		\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u8,  label);		\
 } while (0)
 
 #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
-- 
2.51.0


