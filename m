Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A003ECA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81628E0011; Mon,  1 Sep 2025 05:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30D28E0002; Mon,  1 Sep 2025 05:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7E68E0011; Mon,  1 Sep 2025 05:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A660F8E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:19:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63F8685DA9
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:29 +0000 (UTC)
X-FDA: 83840133258.16.B024E38
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 81821120003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=DRc8mXS4;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsR/STrnydl4a6f2Yv7mj4KlfpOG0wbJ52LB7E1pZ7E=;
	b=Igeq8rkGzte5+sDJxrzROkX/Pd8XfmbIeEXGC92+Alc8xeEjy5DR+PsugVmb0gEku+YmIw
	g4jKh/OP96vQ9wXeUgy+NHCvCrxKjOdX/OIG3MSw6nXCCDEAV74OwvB7VOKBgvwAFzxUot
	hNQU2kAhw+j7m/OrMy3Tq+vYkQx2TCs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=DRc8mXS4;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718367; a=rsa-sha256;
	cv=none;
	b=kG6BNnNUgB2ccVvD8yEMLBe8J4Ann22ejxQkAhtmSubMdpLm95sns7X7TQOQa0AJX1MT8w
	6n2zzaeJ8LaoB0g/UgJOomE16veSScmzY74s5wRjFTytWs6TsfVuWl8oI2DEWfVJ7h5OeU
	+fddY5L+uHgHV3qOzt8QJrVDs1YcGjo=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b03fa5c5a89so214518366b.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718366; x=1757323166; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lsR/STrnydl4a6f2Yv7mj4KlfpOG0wbJ52LB7E1pZ7E=;
        b=DRc8mXS450ilI2Eg1BQNaLcgxd5RalJncTS5ynV4gsg8So4QOcTzqArkTlXc8FFxqd
         ktg1+n+NuM98L/qCv69hJwV3aLyw0csBOpQc2uFnrA83612Weofwe6tC6phGsOe/P2RB
         ZEHsvdmo2Eyj+G8siGN2WFaHxrx6pKlXmqg8abe4fOsFJVyca7qDZrZbVZ8VFzw9GJfT
         k5FjihZKCk3cEMmJz4JXZpw9oKTPjHKrHAHwv7hYpUMawQfBplswdi2JVmdA+IbG/Qcw
         IMcnSSGzpH5gtd7LrFptgyed5dYgThgpoJ3nHAEp+kjTgWqn5YNpLBupwgXGxpmHbjXi
         8rrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718366; x=1757323166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lsR/STrnydl4a6f2Yv7mj4KlfpOG0wbJ52LB7E1pZ7E=;
        b=Wwl9BsXk8V5fYdbtGUjDnVRzTx9EvU36Z3QbTbwyr/NUft02rtgRVUmcVGZnVx4ggL
         C7i0dE/4BIdWzdi5P6YU2+VLd77K3lCIq7h8RNY40Aqj78PTaDXWu52mFym+E1O/aJXi
         ivnyB5EemDweKYauqKrCA9IfKHSLrt72wQTl3OLQMw7rgG9ADrJWdbyEUehsHZYBctBJ
         c2sF5qsM4UiLqqCIP1sAKQ8BdAwz+CqOerO+iGeNjJJPwGpXBmnknhDFJQSFfHqEKD66
         e8yPdzotVf9uHOvmq/ZGU6+i/4qaRayTc/EbB/howkA672LcyKu4d+TG+Kjn13hmR4lo
         tmLA==
X-Forwarded-Encrypted: i=1; AJvYcCWd5hTZb1hjHU+2pKZa8R6FMIIvWox3yxBwoPWtInJWyVDlWFKFoKOwdidv0PHkY7/OQAHBb5C7rA==@kvack.org
X-Gm-Message-State: AOJu0YwyKCd+SUZiJm++Zqt5P1iKdgYlc+lUy9mZyo8WmX0mxnNvSrEK
	dTsjrXdJ8TpJO68N5S4iQGX6qFS+EyUU+YXOslVPwIIu/JZJ12b8UaJnG48dxXv1jkY=
X-Gm-Gg: ASbGncsD9m/u2nlyVEhJIicsXgLT4u5GsFLdBFSTT4r8YHR/tg24/aiKnWpSetZVf+9
	ne77eEaPpR14IcQRnobKj9ub0iSUziVy/sxN1kkhFUb6rHBqVQOEXO4x6UiGpq1Q5xR2H0J4zXn
	roAJlsOmYpeDTKlO7vZEAdyhDGFFxI+UmJ1R11t4JaucI2YWJb80TAWs4GibEoUIsWhBj6oX1Uk
	ZAtSBvBscxh5f67pwDVcXUWFowvNfDOvWjEgQLpCP2PRahy71RKraOktGxQd/J3jmZ3kRfqfF7d
	w+bBNQTAFnwRXXGO8ZjpMk8A0NXnbu2/FVVNTi+WCJfe1l/MLdi01EI6x/nj3/FnxDiy3SlUHfc
	+H9+UCLIVaGu2MCwOcazOQj/mDPkBs62jBcTpUz9ZDkTRH/VyWQBccYdt4bWKAKd5eA+DLEj6iL
	twlwFHFB1P9Rt5L2jbQagcSpjaOShPCJxe
X-Google-Smtp-Source: AGHT+IGLx5jJD5g8VFu3vDjbftCHYb2Ijzb40t+FBcgd7shPE2wS/JLAjEdNECBMIdCPyPMz8moKGA==
X-Received: by 2002:a17:906:c10b:b0:afe:954b:25b2 with SMTP id a640c23a62f3a-b01d8a26dcbmr694211066b.12.1756718365873;
        Mon, 01 Sep 2025 02:19:25 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm541005766b.12.2025.09.01.02.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 02:19:25 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 01/12] mm/shmem: add `const` to pointer parameters for improved const-correctness
Date: Mon,  1 Sep 2025 11:19:04 +0200
Message-ID: <20250901091916.3002082-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901091916.3002082-1-max.kellermann@ionos.com>
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 81821120003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1k1q6bp1g754fwz1e47gu46iurnfsfes
X-HE-Tag: 1756718367-437983
X-HE-Meta: U2FsdGVkX1+ivlpa3gH0h4TOLfDHbn+E73ZuBhnBvNV2QF4TlSP3dT7DSqU5jS6JT97HnACakNpHINTaNoXHRBJ/hreHBouC/dOfXqW+EaJwcpf5vHOq0kwocqiZH9Cejjo3nWXWT7JWAYIEMlzQpe36DkHtiOe3E8EY6vlOPuhgGYcu93DDm3t7zSzGyViAvTI/e4xRp3HJ9ea+r3ko0WLmuBJ3lUuPZ/4Leu49sgob3HvZmsyk02gd1D22KWgxeWjRQKIMyHR+bI3VQIgen8ylgIzqavwbjZT+G2JDpvYliOGjwhMNbu5d//iUMzA50TiBCrGKiwY9ArN2Ac14txSf25lhcaHCgeMF5yHXtwvWuwvZd0fJpc1JASz58M3lRk5R4azeTk5GLnbrgBzaKnBm+kTHciEAe05gTHTmq7N+dqEzv2Aqr5NnBTLe6rxQinOZf4GwV9eOWxO8RSe8rr6GWINjTVTM230rQdWqhulIBkEDSIdb3+uLK4YUIzdRk5elDz6EDQBqx8kSHbRlUqOjhhFbJ/lfoG4bkikegnjxeD6XF/6L9RioVuhgInb1KWE71CSkFFufAS+3ek1pbsjvjKvMZb2s7jM4G+wIXgA1DuyFeFAbV+qvhtZFr8No2GvlWniBbNLI3lSCRvlkEEA3JMoxkIF2JbXJ9Ii2xVSI68IFSRVYoQSH3Or8y2KNFn4kKxSN1JrZstoZ4lyzM0/Ww7yCF1eXbvMJQcsYOQvUJ+NpTGv0Nhjwnw0j8RgoReIF3PyBy1os9nUjV4aV8lfIG2tMvtkRNFfQXxO1pFmhwJEse/H2qMBYET9hgLh3v1bnj1XukDS4pgGHVjPYWocBLKXe+l1w9UXXOI7iZ9xQfsjEYxwmpBUHgbPXhbu9FXnZ5DXgBFl1fLL1GmgnEQdcqI5aaIgLLaCIccjhwH98aqsgz2umBfvav6o0fauzBCt8ngfdlrefYlLtc6g
 0hsIfS/V
 v4uJqDlb8r+doYLmAgmv8iDQUnBDYBzMNnStto+/WA6PtGIsxe5iGfoM7UDtHqOBhM6lQdovGggoESZ0NuMLsDpmLUokH/egwf6uNbHpsFl9Tn4KEi2P1o2Z+Oa4gOZrKqzU6FjL56vatMR4AhydSh2F7jk9o9aZMUFQOwQtqMA21OyZ4geBPtpUJ+oNDFHX482q3+yyYQZ/mTiDfy2U+xP8cpwAj36+zDBEMbmlNRJydxWJf0a59f15RXLurEc0breFDprrO8R70iGGOhQzfhqnIbUweFTY8na72MihD9Q/2YUagp8+QadCPEVS5G0fyoOC0XlHb5VF89CyAHwPfY2Z9iULTT482mYLCbBaUdj9zWeMXZQgn1zojfYZ+7+kADtwQ1sQ2NAlZ+/B6Fw5LpIZ+CgyrVJQksi5JG3CAyBGmHsGiHFD3jVCShH+QOj9RmoIXuaFDyP9tKhM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory management (mm) subsystem is a fundamental low-level component
of the Linux kernel. Establishing const-correctness at this foundational
level enables higher-level subsystems, such as filesystems and drivers,
to also adopt const-correctness in their interfaces. This patch lays
the groundwork for broader const-correctness throughout the kernel
by starting with the core mm subsystem.

This patch adds const qualifiers to vm_area_struct and address_space
pointer parameters in shmem functions that do not modify the referenced
memory, improving type safety and enabling compiler optimizations.

Functions improved:
- vma_is_shmem()
- vma_is_anon_shmem()
- shmem_mapping()

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mm.h       | 8 ++++----
 include/linux/shmem_fs.h | 4 ++--
 mm/shmem.c               | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cd14298bb958..18deb14cb1f5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -979,11 +979,11 @@ static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
  * The vma_is_shmem is not inline because it is used only by slow
  * paths in userfault.
  */
-bool vma_is_shmem(struct vm_area_struct *vma);
-bool vma_is_anon_shmem(struct vm_area_struct *vma);
+bool vma_is_shmem(const struct vm_area_struct *vma);
+bool vma_is_anon_shmem(const struct vm_area_struct *vma);
 #else
-static inline bool vma_is_shmem(struct vm_area_struct *vma) { return false; }
-static inline bool vma_is_anon_shmem(struct vm_area_struct *vma) { return false; }
+static inline bool vma_is_shmem(const struct vm_area_struct *vma) { return false; }
+static inline bool vma_is_anon_shmem(const struct vm_area_struct *vma) { return false; }
 #endif
 
 int vma_is_stack_for_current(struct vm_area_struct *vma);
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 6d0f9c599ff7..0e47465ef0fd 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -99,9 +99,9 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
-bool shmem_mapping(struct address_space *mapping);
+bool shmem_mapping(const struct address_space *mapping);
 #else
-static inline bool shmem_mapping(struct address_space *mapping)
+static inline bool shmem_mapping(const struct address_space *mapping)
 {
 	return false;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 640fecc42f60..d55bceaa1c80 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -275,18 +275,18 @@ static const struct vm_operations_struct shmem_vm_ops;
 static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
-bool shmem_mapping(struct address_space *mapping)
+bool shmem_mapping(const struct address_space *const mapping)
 {
 	return mapping->a_ops == &shmem_aops;
 }
 EXPORT_SYMBOL_GPL(shmem_mapping);
 
-bool vma_is_anon_shmem(struct vm_area_struct *vma)
+bool vma_is_anon_shmem(const struct vm_area_struct *const vma)
 {
 	return vma->vm_ops == &shmem_anon_vm_ops;
 }
 
-bool vma_is_shmem(struct vm_area_struct *vma)
+bool vma_is_shmem(const struct vm_area_struct *const vma)
 {
 	return vma_is_anon_shmem(vma) || vma->vm_ops == &shmem_vm_ops;
 }
-- 
2.47.2


