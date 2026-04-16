Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24866F8A171
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 13:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB926B0005; Thu, 16 Apr 2026 09:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58C426B0089; Thu, 16 Apr 2026 09:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47AF26B008A; Thu, 16 Apr 2026 09:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3535C6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:43:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0153E4A26
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:43:21 +0000 (UTC)
X-FDA: 84664535802.27.B6CF13A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4EE6B140002
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:43:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oxq0L3dy;
	spf=pass (imf23.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776346999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/UjitU2IRDQkjyHmpVEhuknZxwT4yOWmcb/zMeZnjE=;
	b=WcOWuODaRPeWIawDVlP11r4BlNwVfQvv5XIfoMRi7bNh4mq9feEI48sdVmsPmU464b0aGH
	UXf9/K8VydwYM60wWeIubX/cJIsLEycWaoKJ70826f+NRk9Qdcri/wI6zcbxF3MY0l9z7s
	uISSiz5uDZl/N8HL/cFCMJjVXRScqPM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oxq0L3dy;
	spf=pass (imf23.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776346999; a=rsa-sha256;
	cv=none;
	b=hXgejM1MQi0QI8JrDa2HmrVyrLCp6gmcgpijrym7XS3vML6xnU8dsFFjBTWHPVmi7/k3O2
	PowNhDgGf4FcpEQ1BrtnR5xZPlhyUELaw/6BQUsNLxdnRgoHVAWCnB2ktidNRFBf940tIk
	Iob1HHH4jzLpX461/0qiMFLBBUY1m50=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G7sGgI1833152;
	Thu, 16 Apr 2026 13:42:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=f/UjitU2IRDQkjyHmpVEhuknZxwT4y
	OWmcb/zMeZnjE=; b=oxq0L3dyylrzBDUlyV4jJBA8jSxvo6zyTFu2eZGBSWIf1F
	0ksXNAaZF1WFKO90vuj3ti8LrXkR4WMFD+veRWCanALiSvqIPx5mj6AiZqVUTeh6
	tnOUDFD8eG7uVm2ujOQXyKpmzLTf5Owa4nae6JyebU1il+cvOG4GPAishf31nirE
	QHj8T3NZ/YPFd6hNRv9PVtfbIxtnQmC5vDBXeXZfk1L1NOqO7IX91VEsi/on5hTf
	swPZjWAsNymtPrfj22h1nP6023klHtGdpOwHkZzHB+qFWDGTjvfilGSiiCmKXonp
	ZKuwp6xlgpdmgU9LP0G+HpY0nEqSmz/YWYI5xffQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89rnpks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 13:42:45 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63GCrstO003393;
	Thu, 16 Apr 2026 13:42:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4djbh94p47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 13:42:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63GDggEf46530868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 13:42:42 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D9BD20040;
	Thu, 16 Apr 2026 13:42:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E411920043;
	Thu, 16 Apr 2026 13:42:41 +0000 (GMT)
Received: from osiris (unknown [9.52.214.206])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 16 Apr 2026 13:42:41 +0000 (GMT)
Date: Thu, 16 Apr 2026 15:42:38 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
        Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
        Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
        David Woodhouse <dwmw2@infradead.org>,
        Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        linux-alpha@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>,
        Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [patch 35/38] s390: Select ARCH_HAS_RANDOM_ENTROPY
Message-ID: <20260416134238.9230Ba6-hca@linux.ibm.com>
References: <20260410120044.031381086@kernel.org>
 <20260410120319.924028412@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410120319.924028412@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDEyNyBTYWx0ZWRfX8JpaMjFpMFNj
 wT/gcAkcZviN6PAKMrtow2zaUGLfcmRJE1Hmlajk6nmzRCOPN3b0RjfUSbBfZ4kcpBQKzFkFpH2
 rBdoNFGP+ENma7o4H4KbJVfdl551lLtrUhXHjq9OwNJzXZ+me9M1v1uiIYgnebcgn173Z5tfoDR
 wlQdz0La24p7XZm2254oSjajXGSASA40rSmgRE/jrWjf8LX+uVSsnpdh3XNIiRv8V/PTkKj6EBp
 iBYTVRyCnznRY5uSBKmAQ36JyfUCJkrEoSNgw47/6thxuZYcD3Vho/t2EjbWxo9/yoIVwBhLMiA
 KDHNz3gXJ52J3z8Lw3ApjdhxznJ9LyQJp5nCQBfITC+W8sZcyql8UU+3NCgtkDEKALiOvDUmzX8
 cTJk9dj+/qvxdwTfyZTWoW7vy+HckV57wQs+QYABEOJZttft9F9OCKr+PfGIpmBZixsJntlLk+Y
 lz3L+7/h8eZbcTrAKmg==
X-Proofpoint-ORIG-GUID: rje87_dJEfU9HQ1lSMRsbGj9D9EjeiT6
X-Proofpoint-GUID: mvWCwZrNw9W7TL82vJ98uT3DrwWfuFPP
X-Authority-Analysis: v=2.4 cv=fYidDUQF c=1 sm=1 tr=0 ts=69e0e756 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=1gfdoSPoDaBUdwTi8XQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1011 malwarescore=0 phishscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160127
X-Stat-Signature: ygeppft3diw355xxuew9seqfhbypiqhm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4EE6B140002
X-HE-Tag: 1776346999-451673
X-HE-Meta: U2FsdGVkX19uBmN2lTOBDv9C34N2/DwRSESLdbLk+IN13HzeQfiVCKmflomG/kJ2V/Pz+4JA4pNI9VvdK1tp6bLiexa3O0j2Go8Gi+Di5JQJNkUrkogGzbSIofUqCGbpkKw2BtKf+yzf+ikqvQbDd+eSsIOlz19q7kW5VTnrNajromFxStaD7X/PRETAm7xrDgzFaJu+dAScckkHNPmScPyqbsahsZ+DB1mVFI+2AbBxD2ccvoaKo3ru877vDSVMrEyrFz4+r6qfFzhYfkiMjs77OuMK5bg6v046g2kpjg1lW2eVVsBgKPicFfTIQv1h14cRxWz0JE/aB0qWcvTTombmuB0x0U0e+09vGj8iLj85zYGIGlaJnI80n3KqsgRmyiV5Zmjsath81PmB1dbXUFcHBcHCPjV5qe6RfSfnr5YjBdg0L78VvVvXpjatAp6envfdI6M4nQAEXUmNxRP0nZRISjDEVdtNTN/ipnoxB/IuMrCUFkm6VXWnc5dI28vaj96diN08Z9+1qsDw6QeOSPWxJ6kS+9qjKkhLF2J4wUBXOJiDziydaFw979WnmLxwtOioOf988GEUzw/4VR+9MbHWPOa2l7eK9rPOi9csHS8gSt9WdW4cvc7JyNihnW+lezoXie5cqCly8oZ6XOUDikQphbyD0jOPFja4kYe0o2gF6VPPzNnuRZkZYXnLBhDCFmTLrxVBrujwLOajT6CrRzzO8Zs//FHp9WosDb8Ch95KbOeOUSeRAEWMBp3FAgALjU29zj8G695Ic/bCMR/wXBGEMOEO1nM3n5UxMqIHQ0OvKhF1AgNxli64CWlIZO3Qu8RePe+ShbKMQgIY1V8XXvVAy/h0xpFzE3Sd3l5FsJrOcy/neneV9wkURacVjpG7TCAtmXhs5zKh7lkucUYVI4h21XmCfur8qYjcTaFjZ3MYepGH2wAaBvI5Mk48dd8MIYH7X+WX+Zn4sbr7dLO
 K5XHi+J0
 dbYwcblIkFHV4WgURf8Ac55iTZrfSMyt8xz1OIyDk3n1IOfdQpfVEKCw3iOZ1VhmeMeUi0o3jCLE69cj6Me8PRGZPiobDwfSChp/ULRkLJ5X9+B0gWE0GAAD66aXAiO+qFocD/dK0TrhhldhXLzQj+BOwUJ4Q7CBfrElaEIfbI4eKdl1RNpoGYDToIsZGf3mKmTwvAdVCqDzqDJ28YOb6LN6XGMctN8k7OWoNc7L44mkmi7wcikE7tsWpUK1xI25sVfNID9tHolRtU0xZrcKbEOOZ1Yfyce75Pro/+DQX6KxwXRov49dXeL+VnTcgcXVuGUolaBxBI1SJRlXBhYVpfp0GLjMSq0zoeqiQKQ7Qy+zY3gIGJu7j2GlABSIUfGdHjPmDdLi1rCVDZHJUFk0/k5CatOyozDTGnm5Nd0mvODgH3rw5sqFjR2YJaRQzaqCfJVwYgngF/qvaBrr5+DK6SkBzVJ5bb1TQwFRF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 02:21:19PM +0200, Thomas Gleixner wrote:
> The only remaining non-architecture usage of get_cycles() is to provide
> random_get_entropy().
> 
> Switch s390 over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY and
> providing random_get_entropy() in asm/random.h.
> 
> Add 'asm/timex.h' includes to the relevant files, so the global include can
> be removed once all architectures are converted over.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: linux-s390@vger.kernel.org
> ---
>  arch/s390/Kconfig              |    1 +
>  arch/s390/include/asm/random.h |   12 ++++++++++++
>  arch/s390/include/asm/timex.h  |    6 ------
>  arch/s390/kernel/time.c        |    1 +
>  arch/s390/kernel/vtime.c       |    1 +
>  5 files changed, 15 insertions(+), 6 deletions(-)

Acked-by: Heiko Carstens <hca@linux.ibm.com>

Thomas, would you mind adding the below as minor improvement to this
series?

From 7072e5d66b99a7fa666d17c6ad8cb254f2d8f473 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <hca@linux.ibm.com>
Date: Thu, 16 Apr 2026 15:08:15 +0200
Subject: [PATCH] s390: Use get_tod_clock_fast() for random_get_entropy()

Use get_tod_clock_fast() instead of get_tod_clock_monotonic() to implement
random_get_entropy().

There is no need for random_get_entropy() to provide monotonic increasing
values, nor is there any need to provide (close to) nanosecond granularity
timestamps by shifting the result.

This slightly reduces the execution time of random_get_entropy() and adds
two bits of randomness.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/random.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/random.h b/arch/s390/include/asm/random.h
index 7daf42dbed32..f6d9312efdbf 100644
--- a/arch/s390/include/asm/random.h
+++ b/arch/s390/include/asm/random.h
@@ -6,7 +6,7 @@
 
 static inline unsigned long random_get_entropy(void)
 {
-	return (unsigned long)get_tod_clock_monotonic() >> 2;
+	return get_tod_clock_fast();
 }
 
 #endif
-- 
2.51.0


