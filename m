Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FF72C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02AB56B00A9; Wed,  1 Jul 2026 10:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0022C6B00AB; Wed,  1 Jul 2026 10:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E834D6B00AC; Wed,  1 Jul 2026 10:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B79A66B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:18:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27677168202
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:18:19 +0000 (UTC)
X-FDA: 84940412718.06.B731693
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 49CDF140012
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:18:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=sp7ngvxt;
	spf=pass (imf23.hostedemail.com: domain of hsj0512@snu.ac.kr designates 209.85.214.173 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782915497;
	b=BSL2/IIEAW9/eDYpLg4XvWxEuuFRZaNNROwwv6AEmmCRecdtrbYKRqUa6Z4J49K2UuxOIB
	T242iKTCx4vFm+5KMXJ7yfnSQz8scj2tpCnE8G/Cx0diFGsVagqa70z6ANV5NDhG/fhLYj
	hSLMjrpOx0uzZGss/IokG7W1bQ9ytcM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782915497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=d1+h+rP9Cy+2+urt39ChSGhrhtQb1acD3XumdB+25eg=;
	b=KbhM/welGfFFQRJs/q7FNg/MsflVKrf7+pXysyN+DCoeRyuArZNHobBymfrfOplHvT41mS
	1ooXo9gtc16OdwL9Z0pq/+kLHxOqJWqH/gXGkEWAtn9i9iRZAaCkxcvFBmEEdy0ScMxZIR
	6zbqrh2pT++zZVnhGzMxDL701MyngQ0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=sp7ngvxt;
	spf=pass (imf23.hostedemail.com: domain of hsj0512@snu.ac.kr designates 209.85.214.173 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c7c61b5292so6861765ad.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 07:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1782915495; x=1783520295; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d1+h+rP9Cy+2+urt39ChSGhrhtQb1acD3XumdB+25eg=;
        b=sp7ngvxtCLYWOwtSIiVD8bvU67WLYckJFjqsI3wkUpqbP0gRXbu/banD9qYni26AxX
         X1FJ894V8SI63CpdyxCTDStG5Mq25z/0sw65iC/xppYsAqf9QD9moD9jCh0NZNpPt/UB
         EeCMR8sKxUewukmUgGiKas34ogYvf0vAZuLHw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782915495; x=1783520295;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1+h+rP9Cy+2+urt39ChSGhrhtQb1acD3XumdB+25eg=;
        b=SGRJXEmpel/pfB8Gic1ax50LTL/XRvR1Ky1nVqRDRYZq6t0wq6YsoNgJLguL58U7/4
         Jemh8thUZU6n36xqu7B1SPEuhZrXfcP/2Rvi3UO0812YcZ9ESW/RbsoalccPYW2XVh1o
         vuMq7g2Nf5Wk5/DcPezZq7Nd7eOyU14CRzcJ34S/NeqxcgEOjebPdxb6BSRZYqgwtgJt
         re+lMO2Q4DZOMIozKNMYfs/iblrGSwB0MzZpDc6XAnxirMMrctI9d4pX+KUsclaczsS3
         ekNEFqPWp1YQ9uWFj6Pk2U7pJIWcTwgG2a5ZExcERzyaVgaHvjhdcZRwm2jDtQOnf15u
         2DHg==
X-Gm-Message-State: AOJu0YwDVZClhrIaMPzRPSFy1ehAuuVQZeCOtwhJv8GA2l4evYQpfZhz
	nhp5YQKK56O0ZYF4XPGQOeKtoM49nLwmh/7dP5go1/2ouQu6qaCMbysbE/tHSSyfcaKyppy76bl
	a8kghLAsnUw==
X-Gm-Gg: AfdE7clOlrVpTqkJDu2UN5sFuc7++g8Pwd9eLNdp3nhXtNXR3l4J6GE92AWvZiUXVpu
	Fr9RZxUnhKmC8bBYcL/Nu/dW9uAuFC8MXoucGU0h/60oE08EKfvPsmkIIkQflbyn0JE4gY3XOfk
	JTrD1PO/oT+AjdH4LVUVcY6w96RMqVrIfU3K14VGDdiNuE2pX8SrfngZTqN4NOyYDIJ07GFYo6H
	0hcQrtZCW17o44JkAAXsf+wymWTkllF/jyTr11ETh6wiMt5OUQlCkVQZbkF0JAzWOMwAXILXAXo
	GzrW4dkbEFRpv/vYIghG1oPTzjJqLstpyFIL6/bGkU/SAlglsDeGqJLfBcWhByPrOG1wVycjDhR
	/ERXxpDLMzubAJCBibHvQVY0tTSuxRGtuAX1fduhvGU7IJHQjH3FWS4k+FMP2h3w6Cuq7KZna6Y
	2NSu6HqdwHk5phPTjDJzRfRmHcb4UbXkAA1p4=
X-Received: by 2002:a17:903:3848:b0:2c9:c46b:1286 with SMTP id d9443c01a7336-2ca912002fbmr8642185ad.34.1782915495058;
        Wed, 01 Jul 2026 07:18:15 -0700 (PDT)
Received: from localhost.localdomain ([59.29.41.108])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca3828c8f3sm33109975ad.41.2026.07.01.07.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 07:18:13 -0700 (PDT)
From: Seongjun Hong <hsj0512@snu.ac.kr>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Seongjun Hong <hsj0512@snu.ac.kr>
Subject: [PATCH] docs: ABI: sysfs-kernel-slab: mark cpu_partial attributes deprecated
Date: Wed,  1 Jul 2026 14:17:46 +0000
Message-ID: <20260701141755.85119-1-hsj0512@snu.ac.kr>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ebf6oq7jxbg3qyc1p7wt14icr7p58owo
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 49CDF140012
X-HE-Tag: 1782915496-808793
X-HE-Meta: U2FsdGVkX1+jNn8+SEzuYmKbjdJH3rsPKh5Xts0sCwYgtNk0PeWeLMZ99+48n7hd2R8e8WMWTXm63xfR5rfDfGE91lPYVdB3GLaPC2zUZuA37qBRtudIwEeDRzNvByJhxxyrg7vVBsq6evUY0FdBSkHOz1iGg4o+ayouMhHkS35qkDVZ+ycKH5iMoIXxPYCR7F+Xjk7zyBl5OWRKWxoLIsY2odyqMpZ33eDhLffVFhR9x3MO4kl66LoM6t8WHMVnZ/iaiAyWWA33wmZM6CwHHqiD4RafT+D64Cgy2+Y5c+KZwiGujur2tPeOXDolsW9JOeoKxkc6sVZ/JV+7csVvFN3NKEJJGZILS2UQD3+T9s3LZH0mv8Iu/ZpgDKJ7HSBVY2ewGOksGdkXGKkae4c+7AfyRKK83D9CqCa3/eBvR0ZLginnud1+VMoanq8vChEvLwFg+QQHuJVYcAGuEULnww47Je3ZElhPCMFgCHwEqySBgKAtx9rr7RH0wzD/OBJm5qpcD6V/nJ4KSnSMUz0/JPuk6G9DEwldOCu25A4n3r5sIkBA7/w4peYlR60AGpfSpXKNcPH157JvuAKEA0ecMrJcrp14l6bym8kVILEqUd4xlC9znNcF7F7+14mTgC+YiuJ/YJcUqFhMtedcpNylzK2j+IjbbGrmPvaHGmnQdL6ml0CtxpaTc1JtTchpCvlkXKzSN1ugM7PDfWK1gWx8MxVUc03B77Fg2CQlLWW1wFMrCikHKYzVkWinqcMLjDnUZTTqbXW0/TaxCAEIF+RRAypZVfB6f5wBDH8nnwpeiqYWPCEj/y8+ZjaN8QqsrHGLlZKXXiXZI7sVCSBFIQmIEd4gFWdxnQzH+2gngyPgZ6qcW/UpBDb91Wv2CG8r1PDpEeMoP4mwkgaS4D7hO1TTXQNadmZFsGvKgT0uLLievEF+KrrCvZ3Fk51X6nqnbgR1WbOZ99f6QAXvvSqkC9V
 dwUbZrfb
 EWykE+D1p3cKvqjYdzjXf3D50WDC73HFfpWPJOlYEJktfxqA6ynvWZSCGAvnr0kGxFyY+POfIHl/BzFi3SmvZiouWCxWQvSGsJ+CLacN8lVsMLgDXgKDhflS0sPVTzjdo2dhYNraKpcJBBpU4BdFrr2UVSu51BTYYnkiQFRGdGhZ1hUsFtieDXQ3VeQN201U52gfzqROx24cvDXTfiN4yL9RWcZKaMY6JzxjyQZCtbPkup+fJE1x4Jb+eGCX8HlhxhyoysrHd23FoLWnJHZdvpAhiVgnPLp6Yw9EAF44eR3wLhH1/krth/wRZoAzgAI4YyFuX/urzfRYyO81oZldYZTm7v+G8q5DZUJXyjBoWsjSM1+lZh/Zuu5bJV4Eby18z+tdObOBSe2+BImcfCg+ey9vHdTuHDAvz7ErLCioa8l++rztrOtIa82eHgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The per-cpu slab and per-cpu partial slab mechanisms were removed when
SLUB was converted to per-cpu sheaves in Linux 7.0. The cpu_slabs,
slabs_cpu_partial and cpu_partial sysfs attributes were kept as stubs
that always return 0 for backwards compatibility, but their
documentation still described them as if they were functional.

Update the three descriptions to state that the attributes are
deprecated and always read 0, and note that they are retained only for
compatibility. While here, fix a "partialli" typo in the
slabs_cpu_partial description.

Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
---
 Documentation/ABI/testing/sysfs-kernel-slab | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-slab b/Documentation/ABI/testing/sysfs-kernel-slab
index b26e4299f822..9b0085b86309 100644
--- a/Documentation/ABI/testing/sysfs-kernel-slab
+++ b/Documentation/ABI/testing/sysfs-kernel-slab
@@ -113,8 +113,10 @@ KernelVersion:	2.6.22
 Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
 		Christoph Lameter <cl@gentwo.org>
 Description:
-		The cpu_slabs file is read-only and displays how many cpu slabs
-		are active and their NUMA locality.
+		The cpu_slabs file is read-only. It is deprecated and always
+		reads "0" since the removal of per-cpu slabs in Linux 7.0. It
+		previously displayed how many cpu slabs were active and their
+		NUMA locality. The file is kept for backwards compatibility.
 
 What:		/sys/kernel/slab/<cache>/cpuslab_flush
 Date:		April 2009
@@ -509,12 +511,16 @@ What:		/sys/kernel/slab/<cache>/slabs_cpu_partial
 Date:		Aug 2011
 Contact:	Christoph Lameter <cl@gentwo.org>
 Description:
-		This read-only file shows the number of partialli allocated
-		frozen slabs.
+		This read-only file is deprecated and always reads "0(0)" since
+		the removal of per-cpu partial slabs in Linux 7.0. It previously
+		showed the number of partially allocated frozen slabs. The file
+		is kept for backwards compatibility.
 
 What:		/sys/kernel/slab/<cache>/cpu_partial
 Date:		Aug 2011
 Contact:	Christoph Lameter <cl@gentwo.org>
 Description:
-		This read-only file shows the number of per cpu partial
-		pages to keep around.
+		This file is deprecated and always reads "0" since the removal of
+		per-cpu partial slabs in Linux 7.0. It previously showed the
+		number of per-cpu partial pages to keep around. The file is kept
+		for backwards compatibility.
-- 
2.43.0


