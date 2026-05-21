Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B96FCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCAC76B0093; Thu, 21 May 2026 10:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7AE16B0095; Thu, 21 May 2026 10:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C206B0096; Thu, 21 May 2026 10:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE1116B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71531A05FB
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:16 +0000 (UTC)
X-FDA: 84791651952.04.7EC5187
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id 30AFF16000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=KXiwd8eI;
	spf=pass (imf08.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jllwd3IYu88g5M0bXd8eQQThFlgyU/4CLxomaWScev4=;
	b=jEbcg2zMlTTCL58MCBtbVmc4YVMOnMaxv6DqN3PE5gfOdQ4mYN/WJvhLR5Z8RCR2P1hiS6
	T8SEM2LjTcACMnN0+NnnNPf0qDCyJXl8T8Fz7+5lHvXjbYWguJ8dWKgaEQecZ26IQktaos
	NYDnp4CEJSz/8+3VKFDzn4MFY+4VYQ4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=KXiwd8eI;
	spf=pass (imf08.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373574; a=rsa-sha256;
	cv=none;
	b=xmcZbRxRlry/FlKxG8SDPRPhW1ztATHjHf3sVXaeug6T4tEm4a7JuKLhLAjOfcMToLGu4D
	PabmsRSuELdpq3HszY0/I3rLjuW64KSwfy8SeUIT9WDjHPnT59UQCon5vGxfHyLkPOiF/W
	79ijQLDFZgTA2r/S/iO5yfWw6NZV3oY=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L3Sedp3907161;
	Thu, 21 May 2026 14:25:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Jllwd3IYu88g5M0bX
	d8eQQThFlgyU/4CLxomaWScev4=; b=KXiwd8eIpi+PCPdzIKhYx1dhvbjNizdNs
	j2PtIbsXFMXpibMHMcXUcodPo4AwZ6hH7mg4UIZDjjBqNmIhZVlb+jAwgdoHLAlx
	nHHw15HDLkGzRs+s79+oA3+c8lyGr9mdiWKjRCG/Uy01N5kjcFr2ve3QwXk3ShLu
	jNllobYArrhrkv3dMDQUuWptZmxqtcEuiqPKxYAbmeIBYh05OXXazEJWLqz0th+o
	Iw9C/QofyE5oI7bkBMicamLYunfDtxmFOqj1/RBMMcCdyjRfHmfGLuIippOlGocJ
	kkHgNQGX3S1yQ3NfvneHdurDgzdnWx51vpCrxckA0uwoZESlKMcTg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hb8p5ry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEODcN027545;
	Thu, 21 May 2026 14:25:56 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739w4pey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPrrM57278946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:53 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18FF120049;
	Thu, 21 May 2026 14:25:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B586120040;
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
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v16 10/20] unwind_user/sframe: Remove .sframe section on detected corruption
Date: Thu, 21 May 2026 16:25:36 +0200
Message-ID: <20260521142546.3908498-11-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX5Cb9SNjh14zV
 CLa3w/v/zIcsC358NYpHV7oe41D+S35qEgs/fiIYo7k3IxWQQD3j+Nb56SExE/70gCmw6AIRrvK
 sBXLd3/Oup55nFRYOQ5rz9fEfCCds3b1+NSk6UXvwuPy/t5KO1qan2jOYXpc5yaBzxWBF7jmbl2
 rit11+e4j8jSDSZAl5vVnldt5Q9yX5FvWZV+RW1vtQy5i72HrCtzlaf9XP1ESoKqbLUdWgq4r9g
 u/d7fPKXnGzDF+Ql3IgLdWCM1nD+qqMCCBTEkRrdOOHYQOeC1j/x/KQMjpRms2lWhKUVycAquqp
 53XF2HZ3mtlMViozEINL9rG2nEuCrJt9OhZpC27FAsoqi8wUCyU9mkgGEl0kiwmHPUwvyZAz2m+
 FPH1KwpW2IT2pOXJ/fXnkwC0Vy+uJtw2Z8AeTBWVCa+xRIjl7tV9ouqET1wLYvVIvMlUiVoREi+
 zXY88qfywmdsoq07W5A==
X-Proofpoint-GUID: Fx4VTBMqCayqEJuwq0j-4rAKT7n5LpoY
X-Proofpoint-ORIG-GUID: Q54U5td7LPxOfnBGczdYla305bi7dNFy
X-Authority-Analysis: v=2.4 cv=aYBRWxot c=1 sm=1 tr=0 ts=6a0f15f6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=yLRsOmMQGpVHI0ogWx0A:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspamd-Queue-Id: 30AFF16000B
X-Stat-Signature: 4e4aqf559ujue7pdyt71u3cjwwx1mx6z
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779373574-63433
X-HE-Meta: U2FsdGVkX19J+ICXX9lcICZ4FAy7YIFOv+NI4QTdWMha7q9xStc315A9DuyRDqzBVhn6+rJyZ6TYYxLUQycNOwokNi2mDIMrBOklLK7BhSjrbTlkIdxF255jAbb6T1+FX28+w/q0wOQVwZyw2htacdiFaAMqjTuv2eiGJ2iLm7ddRgtdqEPvEI+Z0X/KvEbhOXaaEsVjkczcyKK8C80ic3ObhLE2XoKo0m76ONm28hGRb+iWqaWIeZvw/N07lYEz1O9tdNf4cTqT0r1dzf+hiFnRhL9QPoupPqTY4cnxQqT8h6w21AotABaaSGdVpRjO95oU8rF1nqC9HfIoJyrIvO2Z2y2khC7zacWfjtLjQOWkm+vqP3gIBHPbreW6FGBEDzP/GWOuKvxaD4K0pUfXZ6kBiFGoGxf8heAoSzH6+ccsjPV5fmZXVVPgPN8biSNunJNvks0+cSPNmmkaiIo6XYIdWtwxgfOfoWZnHKndCYQj1e3XxWl1G0dAWr2usGHNM0SDo6QOiNREeyJ8FeccBB5Vr9p+d1wEtGm7uAyvSpbX3SwtpWri24sOQVrpeRmwvMiSGSeB9P5gv6LiGJ1xzMlPGTTrI7gY1MmxBPDWHunh8dUGvn+4bgtL/ocB6hX0gugDAY8MRqJapS9jHy+5Nd/wejk1uq5nbY79galXcvHDgnTIT3mMw5RhZ+DHF6GE8BfCf5jw1Gvvvy3ig2qMf0YPvqCeLz0RLg9YASMU+aql/cVZkD78vm6tGwMgyd2BgaF1SCYKtDtyZ7aA2hXJVqXq1ijMWekIx0+jBHXXY6Ar80twVAHDewxS8CHI8aGkQ5rHZ67q+sQaaojJhAW9mHO8kbpebdDycXtU58RySr7LDNoNk57G3ATPkR/oMGT7nRivrs92cLGqEBWucNPKJj1aSoeeL1j3lJGdE9GvofvjbL+3PIFfy9P0fg6fDnHUmAY73DlQpVyeoTooROV
 7TV1rRj0
 IUtAR4bAeeqKETfL6+4FDy/4GqFoXkejn+SrXa3oFYYlq8dO7ftbH3Mmm1GQLSHl92A6i3UL8JLIa0mEIZWoxYObTLamaqKfRCNMVCU46QOsBS4wlkpgajba1tGBVv8OIdOwg0IbrfBpZZ67VuWNI5oiJEgbop9VRf/glI5lOVuZ1r1Oa9CXI9WIcFjiL0FKWO8oEcOZAxOuCjTNaXFMHLCgEVJ7VylWXqwSquttSaHGDJZaL6rnZaaU/3LhNh5cBOOYvGb/5tiv3aFVba6OR8gZj39grbEJOK6i6G+WcJhwyn0W51A24SB4srLwI8fhQ+YAR
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

Notes (jremus):
    Changes in v15:
    - sframe_find(): Align to normalized error code usage and remove .sframe
      for all but ENOENT.  Also remove if user_read_access_begin() fails.

 kernel/unwind/sframe.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 41ece3ca62a1..e0eb2adf5a07 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -371,10 +371,15 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 			ret = __find_fre(sec, &fde, ip, frame);
 	}
 
+end:
+	if (ret && ret != -ENOENT)
+		WARN_ON_ONCE(sframe_remove_section(sec->sframe_start));
+
 	return ret;
 
 Efault:
-	return -EFAULT;
+	ret = -EFAULT;
+	goto end;
 }
 
 static void free_section(struct sframe_section *sec)
-- 
2.51.0


