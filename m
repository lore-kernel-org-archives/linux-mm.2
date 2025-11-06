Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF3B1CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562418E000C; Thu,  6 Nov 2025 11:09:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512108E0002; Thu,  6 Nov 2025 11:09:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA3E8E000C; Thu,  6 Nov 2025 11:09:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 27DE78E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:09:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E9EAF1A0154
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:09:17 +0000 (UTC)
X-FDA: 84080666754.04.DE33E37
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id 83DF18001A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:09:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Zh8XAC1V;
	spf=pass (imf30.hostedemail.com: domain of aleksei.nikiforov@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aleksei.nikiforov@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762445355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjZfltUSwZHxE+uDUdhq3CJlPnh5lohyju6CeAaqcrc=;
	b=wDMv5BiOhl8nI9TSFkpg4tS3eH9v3HOygZ6K6G3Gtbn7wiHbD/nk74L8B1sqWSQ68SImop
	IdxbZmdP8fbY5qGxNGXqiGn2AP2XLOG8bIe1CXEK+WLj0vU42qiwArJElHD3rOgG9otExJ
	vG1ywFOynD/LYyyCbL1It8AeGreXFyU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Zh8XAC1V;
	spf=pass (imf30.hostedemail.com: domain of aleksei.nikiforov@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aleksei.nikiforov@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762445355; a=rsa-sha256;
	cv=none;
	b=mKM5bR029mOaMXmQ4BIB5u9ii7NR4v/ZGzZeShROtBr1jcK1JmaayhvlU/yZQ2SHgu0s4r
	GzoqkqVuZVq7Ly1+SFQGse6C3wegj1SN+eN6t3MSMzVgHi+KAoobnX3LIRNQYYpECA62D4
	Y8PR4bymsjRXuSiViXNZKkZkzJXKSNQ=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A67KHRN023521;
	Thu, 6 Nov 2025 16:09:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=VjZfltUSwZHxE+uDU
	dhq3CJlPnh5lohyju6CeAaqcrc=; b=Zh8XAC1Vits+JI9gf6x+CHzO1+0XGCDCp
	3KuWEq4Z4ahDNljtGdbqv0bvdAoQQziVtUXzepuHoJAG4jfs1x0oKG7WJNMV3xLv
	OM1rQqZM5ZlTVEwzWvmVFInm0ZVPIyt60HDiPeonL8htNsjFecm63ST4Bfn4VQFp
	wYMidBovOdeH9Ig+ygJZIIQTMaxXovabJLNXZhmi+a+EYzFBPX5oF6Q33JhPsNv6
	ybiNE8f709M6jvkP62DwYXB+Z7jZR2pkSuCC9quCGNrUpngyHUZozOAzgXDC2vz2
	H3b5qZecDzAQ1XkXCutJ7BvYqdZlK/0ndUnx60Kj6aIwTc+De3ghA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59q986sk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:09:12 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5A6FxXs0008061;
	Thu, 6 Nov 2025 16:09:12 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59q986sg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:09:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6EwLJB025557;
	Thu, 6 Nov 2025 16:09:11 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5vhsxh26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:09:10 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6G97qS51249586
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:09:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 468EE20040;
	Thu,  6 Nov 2025 16:09:07 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6459120043;
	Thu,  6 Nov 2025 16:09:06 +0000 (GMT)
Received: from li-26e6d1cc-3485-11b2-a85c-83dbc1845c5e.ibm.com.com (unknown [9.111.24.158])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:09:06 +0000 (GMT)
From: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
To: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Subject: [PATCH 1/2] instrumented.h: Add function instrument_write_after
Date: Thu,  6 Nov 2025 17:08:46 +0100
Message-ID: <20251106160845.1334274-4-aleksei.nikiforov@linux.ibm.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20251106160845.1334274-2-aleksei.nikiforov@linux.ibm.com>
References: <20251106160845.1334274-2-aleksei.nikiforov@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=StmdKfO0 c=1 sm=1 tr=0 ts=690cc828 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=KOBABV2IKOkdypTAImUA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: wsqpo0y6lQa7s9mUgKxY6TctUwToHVni
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAxOCBTYWx0ZWRfX7jgjMaG+XyZ8
 mThr2JYAcbWr0jgLh7hdJxD6YOimrAM+XG5dJiU0u4CPphdKdoI7caEJL71U/VpnjotTaZtOnbd
 OcJg9y1xzEnJD+Ehkgrp/+e7d6B/l4RUwFbplfBctghdzgVEFdn+ZjfHnVLWkOpZCoYPeBlVjsA
 UDpfU90jbCNps5+SnuacrBu8RsktfOxDycQidVkiOPOKJR8emqoKBiG4x3cix3ytROGpbJHdaxX
 nJvWGhbiWr6n+zsh3DjqhIxyKwbdxzg5aJG1jHTRy5bC2jjbLexTu4Mmv24mAoQQ1tERVkwtPvD
 bNo7Q4iQr9Cg8DvV+DWYcBNBD2GwjpfwlmykT1WdjoatAzkaddngjw4I1ybTFOiE74ZyJoEPIV/
 EuS2J9r3JLpENr1OdNdyGp+G8o8ypQ==
X-Proofpoint-GUID: RQXdUhJfyyG6VwdC6vI3fgqe0m3GUW_M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010018
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83DF18001A
X-Stat-Signature: 9mxnc9dfrpmom7z3g3hzqpqok1581ki7
X-Rspam-User: 
X-HE-Tag: 1762445355-212528
X-HE-Meta: U2FsdGVkX1+G/23BuEkf9ji1nJ6BemSl1lHnWmfaqHQt09FF4ZXEHPxUDO1Zho31gQjGchcNVgIQBZmF06qd3zJYSVUIXbWINufd6fndXYpaTWUSNelKC9nO4CLEll1KK1MdNbJz2zXs/5PmND4CsZgXLPnzkKCOd5CAPT4k7pnbM/zB6DNYIxVvMDvOCn9Q8/ICRZW9X73U4HSUdsIghcs5wugvWgzC7/wf9DP26FZCIXgTn5BQueYOWetTrsmwN0iiDmaZqwdnjY1QTPPE9ZBLW3YT1dth5yaxMceWeKwDnsp1V7nW+xT3UjK/H7ADxMQyApe68ZBUYQKxyVrtEUQOin2vI4l6zzv3GLrR/8ffGu0mVMUJTqJdKAseNoPaRFskvgi82Fk59WVIZpEmSfL43vAY+gfj21Dpt0VRfDPD6zCRqz40jnIOxI9pl72H9uM7/tRtjszb3uSPykIQbOOstAUtYink20HZXoUxO6fh74rV7L9hxvFoXAkEFJ6p7XJjmGN6hd2yUAm5cCfjag5c4do8xOwz/YF/3TL4cyO8bExitYJVKRWy/hRowXLMVjJIUYmTXv3sBbmI1iBky+8PPJUv9dFJNC1vMT4ojFlydrx3+GUQI3E418BbVAICQqGEE9dGHKwzn3hB9vG1jqObyrZGu70vYzrKZzNvoyw4JXSCFB7qFmcy9Z+Pi7BmduF+pVIKFB1kCMzPt3ZXMj5jTM7JC1wTY3rh9VxzOkVSRd7HQ4qfvcnoHFOur35drQSsiht4mv289H0M0vHSAL2iwUL/cif2KGa7JlOAeRaQoAhHjLJ4DrmyRWaw4SYVPLVVafoDXN56MXi5XHinD85qLaGCEi31F62xsCt8u0IIhtFcPHqSUU05JUzUdt1b9UFWz7dUzCkQ0PxQuq6xBJcePtd7I/v2OPUEey6DOKKxFXs5KMgn19OEhMbeZ1UKGWUWSzpzx2BfQnwFLI+
 szbuYuzg
 Ah/4CEM0KbJbPBBh7hzctg6Fo8RU39jjC6iQkUaDGSXbNIYwaBK9cBwzxOocnk84EJv4wi08Wz18toW13wtZyzzeeoRUKxQqbEQzOua17a1MXhbWjJqivRg5geX04MVzGecoXFMJ7QZg3Yq1fLcxOOIGkHaSUnaalCFYHTQPK5dC9XFIGzv9eEwj5ZFGdCfLNe7vHH3rL+fa0AS6/SONEboL2tAg3ownUoywo1pBO3zyZ/BdQloFk6Ksyd9rNGkQsCEPBe75M+m4Tme+90ThRBvd29RW2JeqBTPGtMLxp5RyeHgnvMR2QKDFKR2SQfNb0CSgnpDEYPOuVY659vU7Ho9HJjAUv64DZTOH+iGlhlezkLFYGqyLaYybRTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

clang generates call to __msan_instrument_asm_store with size calculated
based on inline asm constraints. It looks like there's no way to properly
write constraint for var-size memory write and make clang generate
__msan_instrument_asm_store call based on runtime-obtained size.

Implement instrument_write_after similar to instrument_write and
instrument_copy_from_user_after to manually fix kmsan behaviour
in such cases.

Signed-off-by: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
---
 include/linux/instrumented.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/instrumented.h b/include/linux/instrumented.h
index 711a1f0d1a73..a498d914a8b0 100644
--- a/include/linux/instrumented.h
+++ b/include/linux/instrumented.h
@@ -41,6 +41,20 @@ static __always_inline void instrument_write(const volatile void *v, size_t size
 	kcsan_check_write(v, size);
 }
 
+/**
+ * instrument_write_after - instrument regular write access
+ * @v: address of access
+ * @size: size of access
+ *
+ * Instrument a regular write access. The instrumentation should be inserted
+ * after the actual write happens.
+ */
+static __always_inline void instrument_write_after(const volatile void *v,
+						   size_t size)
+{
+	kmsan_unpoison_memory((const void *)v, size);
+}
+
 /**
  * instrument_read_write - instrument regular read-write access
  * @v: address of access
-- 
2.43.7


