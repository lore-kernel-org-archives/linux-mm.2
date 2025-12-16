Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39672D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57296B0005; Tue, 16 Dec 2025 01:47:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F86C6B0089; Tue, 16 Dec 2025 01:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B056B008A; Tue, 16 Dec 2025 01:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6756B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:47:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C761C04FF
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:47:14 +0000 (UTC)
X-FDA: 84224402388.08.40C4E99
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf26.hostedemail.com (Postfix) with ESMTP id A9435140006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:47:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=bbxLGiXZ;
	spf=pass (imf26.hostedemail.com: domain of 00107082@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765867632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vyO0oppduEkgyqxUeWeOfgKgDxGnIfMor6OnxIu/1ho=;
	b=Hmc+zrBIO9bXroMnW1hD3emXlZwOWyO6SEGMsj1m++ix1e39OLpTIcbtJla9SkCuJ51Lrq
	1R8IZqyBuU+X35EoRyvNXRI3ZtWGDXXn7IEW2ibgCG8K4K2DB6bbWKchSuCyjGXraLVsyd
	dWMbzcOjMMOhPSpomuKl4qwClzbRMT0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=bbxLGiXZ;
	spf=pass (imf26.hostedemail.com: domain of 00107082@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765867632; a=rsa-sha256;
	cv=none;
	b=oiVlfd+Ll2aJtv3xLytKNiI617O3DJcHORQ4fJy/sxOr0tVUp8QVt6rZH/ULlGmvBIBxLN
	kAZAGLGD0A24SEWgy14JpgfaGDpcR+Di/ZkxH4w7r5D+D5mHOCgLJFUFw97kzsMi7P6EDz
	+wJJ1/3Qr+at23RMEMHEgwXrNfLGYOM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=vy
	O0oppduEkgyqxUeWeOfgKgDxGnIfMor6OnxIu/1ho=; b=bbxLGiXZn5yZZSPMvT
	UJ4Jfcs+5+9TVr6BbY1DZesmDSdMcZLKKq6ReBdldFgG8Y6F20iCPztGFGQSvg/x
	BN7dZaMeDpW3YMlCCI0CbqX065YFVHVTFJy63aJkjR+0MWIcWXVEcooHKVMJM2oX
	NyOo7bjQOp/VxvAmiPA7sX6l8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3Xxqp_0Bpf1fCAg--.4065S4;
	Tue, 16 Dec 2025 14:44:07 +0800 (CST)
From: David Wang <00107082@163.com>
To: surenb@google.com,
	kent.overstreet@linux.dev
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	pasha.tatashin@soleen.com,
	souravpanda@google.com,
	vbabka@suse.cz,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Wang <00107082@163.com>
Subject: [PATCH RFC] alloc_tag: add option to pick the first codetag along callchain
Date: Tue, 16 Dec 2025 14:43:49 +0800
Message-ID: <20251216064349.74501-1-00107082@163.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3Xxqp_0Bpf1fCAg--.4065S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr13urW7Xr17ZF4DJrWxXrb_yoW5WryDpa
	n5W3W8GFs5Xw1fGryxCw1xKr1fu3yIkrWYqFWI9w18uFZIyF429r1DKrW2va4DCr4vyF4j
	qrZakrWxKF1DAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piJGYdUUUUU=
X-Originating-IP: [111.35.191.189]
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/xtbCxRiYQ2lA-7h4IQAA3x
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A9435140006
X-Stat-Signature: yiikskynn1rotdyndurjz6dorsetgfgs
X-HE-Tag: 1765867631-176889
X-HE-Meta: U2FsdGVkX1+fvETCRrefJzgfjaXkMDQBHNSCqcKQfAU6btnLr/nG4k2+WhoASMReCGp2O4DQAVtWoyH4yCKUBufqBS1UQSvsRmL9cOAVfLILljFsLQ8EC4NNHh4Bymde1f1hAohuVgEEneTbwwm4qzjWLIU8YNeKKrU8gU4YkjrxYJ8iLzzCV3FXXE2NEtBv2fbgJAff1xhfXBJBJBAMu0ikkW9D9VyG1aPANZ2t7AZyt/s0DTFk2atfPzyJ7fBTvFCosPwL9YQU6Glzym13cdNyxkVaGcPIOPEIddXgMBm4gLJYxIgs/OKoCtgYkF7d/S/PRMCafcj4J/tt4N0aYxpQ/TMIaYPaWDM8U23uU4LVbSxotVODZpQrMvQ9xLbQKJlpywSZutOwKHk+Y6nPoe/0/UeGMYZxpwqVcyYTtLrwsL8WgpQJA1nwBVs1mUFwCTFG4/qqWajNnSTSkhFxr5sy85p58KJvlFsDDXXYaPr2HrRD7hUa9G0dJjBFZS157KyNtbu8EvxCQkYfqWeJH4LHjlNDFwfZ+frEX7oe5AUTtiPEa5sZThExukQD2rua1t2/0UZ2Felsvs+rrSKCTA8bA8mBhjp6o1/O5mGhnTiVitxwmlSvDCQ3uZM3GQQALW3QvorxQLGEd5pR0rar64bxGe+XRQrSDKhp26WJ4fMAaWdynRCNRrU0mVRSRJqrtWPsNJPrAjqoPdAW/SJQklQfLTwbJFLXiSQz7t/eRlMLfr7pBjF7CDpDGFZEv4Elw8KLdhkHAOPpFz0y2e8X8SusNY/nrnvH84gIDgLEddtVi6GYB895eF/a4BQk3vySELgkP08VamPhaNkDfNmgbD8jvJ7lfDHWidMng3LSNwKUKvfewLSUQAO+Mwk6+TgFqbeAUuVrfc1vGg/gwrQtLqJCaC8PzSFTTdPfPh0HeB15m9tJLtAbhh+DyW+wogOsQpMxgdX0ncQ2sYAm6Iq
 nmXVftaa
 OO1gWLCZM4JzXbSO45bGtnK82gB2KRNpsWNvb31FLEFSDC07TE2BLUidTmcdoUzdg4UG8jDzZEW74TDadioWC8YEbPfE1nzC7E+dkZULEWOYt4XBzetoD7TBY8HxCQOxRUSwuDQ7RQM0aBfOsMIU4PWX+ovZVRCntqQ+92HcuWFj3D02l5Ur4htvHAbwmy+RnsyhDCG84rskCGkyCL2nkoxEWCuzJXq1RiFtTe3STJA+WHXZSQIV305PoIWS8S3TsMidyedVxJ4ooJLzLpVgSzs69/Nd+X4R+wPmayEv3RLaAnO6ODZxQw9tNWeQGJaq7+ZHjJYG1luZE4JNlNNzD2mSGH67NqBM/jeV1oW7Lo56U4O+N1im45grA0aQdoVOdJzH4EvddynXbI2KGBvD9ux1v+JOb+4uIpyLl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When tracking memory allocation for some specific function,
picking the first codetag is more desired, because there
is no need to track down all allocation sites in the call
graph and change them to _noprof version, which is quite
inflexible when the call graph is complex.

For example, consider a simple graph:

A ---> B ---> C ===> D
       E ---> C

===> means a call with codetag
---> means a call without codetag

To profiling memory allocation for A, the call graph needs
to be changed to
A ===> B ---> C ---> D
       E ===> C
Three call sites needs to be changed.

But if pick the first codetag, only one change is needed.
A ===> B ---> C ===> D
       E ---> C

The drawback is some accounting for C is splited to A,
making the number not accurate for C. (But the overall
accounting is still the same.)

This is useful when debug memory problems, not meant for
production usage though.

Signed-off-by: David Wang <00107082@163.com>
---
 include/linux/sched.h |  6 ++++++
 lib/Kconfig.debug     | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d395f2810fac..4a4f7000737e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2288,14 +2288,20 @@ extern void sched_set_stop_task(int cpu, struct task_struct *stop);
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 static __always_inline struct alloc_tag *alloc_tag_save(struct alloc_tag *tag)
 {
+#ifdef CONFIG_MEM_ALLOC_PROFILING_PICK_FIRST_CODETAG
+	if (current->alloc_tag)
+		return current->alloc_tag;
+#endif
 	swap(current->alloc_tag, tag);
 	return tag;
 }
 
 static __always_inline void alloc_tag_restore(struct alloc_tag *tag, struct alloc_tag *old)
 {
+#ifndef CONFIG_MEM_ALLOC_PROFILING_PICK_FIRST_CODETAG
 #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
 	WARN(current->alloc_tag != tag, "current->alloc_tag was changed:\n");
+#endif
 #endif
 	current->alloc_tag = old;
 }
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ba36939fda79..6e6f3a12033a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1038,6 +1038,18 @@ config MEM_ALLOC_PROFILING_DEBUG
 	  Adds warnings with helpful error messages for memory allocation
 	  profiling.
 
+config MEM_ALLOC_PROFILING_PICK_FIRST_CODETAG
+	bool "Use the first tag along the call chain"
+	default n
+	depends on MEM_ALLOC_PROFILING
+	select MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
+	help
+	  Make memory allocation profiling store counters to the first
+	  codetag along the call chain. This help profiling memory allocation
+	  for specific function by simply adding codetag to the function,
+	  without clearup all the codetag down the callchain.
+	  It is used for debug purpose.
+
 source "lib/Kconfig.kasan"
 source "lib/Kconfig.kfence"
 source "lib/Kconfig.kmsan"
-- 
2.47.3


