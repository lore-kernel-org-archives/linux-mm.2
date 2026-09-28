Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0837BCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1772E6B00AE; Mon, 28 Sep 2026 13:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2B26B00AF; Mon, 28 Sep 2026 13:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC1A6B00B1; Mon, 28 Sep 2026 13:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFAFC6B00AE
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:42:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3195B14020C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:03 +0000 (UTC)
X-FDA: 85263889326.22.EBC4908
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf20.hostedemail.com (Postfix) with ESMTP id 65F771C0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lB+nlA6N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 356a6aggKCHwxrtxyfkflttlqj.htrqnsz2-rrp0fhp.twl@flex--smostafa.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=356a6aggKCHwxrtxyfkflttlqj.htrqnsz2-rrp0fhp.twl@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7XOG6J7aO3z9jj4htZ8vsmTX5Bj+aw1I6NLY6zP7oo=;
	b=uedBJTeTzj5M9BPeT+IBN0xwXFLPY3S+Zfd33azwfOUPRqE9rqn/yAA55QbFOwYLWahqv7
	L5hpggidR7xLGO33tHOJJn5/nEAcSA+WZofOK2SPrpRad52PqkaDggwc+DDfo8HCx+FImJ
	xpJfnBKjp3sk5RTVWoFJbTCQ4cNbVJ8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lB+nlA6N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 356a6aggKCHwxrtxyfkflttlqj.htrqnsz2-rrp0fhp.twl@flex--smostafa.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=356a6aggKCHwxrtxyfkflttlqj.htrqnsz2-rrp0fhp.twl@flex--smostafa.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617321;
	b=Pa9IVIxmz5MJMYD7KvW9ylweGlXvMZTBjYBBTESdlqOc3wEADm9EJFffuqe0NRQGjlxd77
	MlmI6vknarOXROOW1cNncOTecFZOXIRRX9fgOeNbUGI9znRJ++32P/PKDu5nT6X0JDwBnt
	e3O5uNahQERU4+bROuyUXi4Pu7iZUjg=
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49e735659b7so24431185e9.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617320; x=1791222120; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M7XOG6J7aO3z9jj4htZ8vsmTX5Bj+aw1I6NLY6zP7oo=;
        b=lB+nlA6NWmYfHDiIHNooC5/pR0EGTLOuRWA59Rk/+T/0lwhRaYlrEIdDZCZNylnW1Y
         Ec57uiFtsmpdn4iipt4VU4e92UPbW5zygjBSLJzcUWT/uBOWQMS1YecY+w/3xqiW1f3z
         BUwe4YNIsX3P18ENV6l3ON7u8LKpNnU9Xea3YCAcvqXAi+0OJfqFH2p5pnaKI5fWBTTv
         stdJBB8ACrMHx/bYTmJnIZbaR/dCr4Z1EkYS/vYnoRqG2nBIpCjyx/ZiiZ0sorsdl6fM
         DUOZ2ZmWyV30cJW4kYmF3aRNLpFdZysUucV2hVtlg1I+jTh71jEKoUBafdF/AKRKKqBW
         VW8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617320; x=1791222120;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M7XOG6J7aO3z9jj4htZ8vsmTX5Bj+aw1I6NLY6zP7oo=;
        b=o1myqTu2xxrvnLKacQf0Hujsl6LzmjFBcxMnOD745a3l2UwNhobDK4BTL6KTMb7JrG
         E0biMfngAR8T8gMeFRT6U34OStce7RXqlvllFmxvMuhnKT22s0UoQ4EDfgkKPpTs/1mR
         IB0pFQA7Lrwows3LfQvR+S6oNjwNx77NyMS9tpU/PJkSETSQdnWRuIMM6T0UI2ojcvg4
         u/AWVp3tYxT8iwn5GwNrdGAElM7U2kx0PYlGXxJCX/asNlyTSkq9rMbxCllIKjWJuzfJ
         On4ArnUGsgStIOdA1lJDsNTTT576nclv50yy5YHjsaHNJX5uuzvvGHwKdXpeicOVoeta
         ioog==
X-Forwarded-Encrypted: i=1; AKwUvBxDv410zRmJN8aDuetnRc2TT1yIdFYyj9KVRuBGvL+UamBqvRgQSp6kooUkJtjBvKUp7jbfFSUzqw==@kvack.org
X-Gm-Message-State: AFuF++m1U8AjtvDGwNrHldVrrulmqXTKFJWH4T40yujLOXmWiF8ylTyS
	Ze0yEsTNFUUBv2IM9TG+Qe07PAFSoB5x5tnJFTp751ezXDXl4lzR2F7rLNhTqW1dvOpcPL1pvUZ
	9DM+/UAgQhbiX3Q==
X-Received: from wmpj18.prod.google.com ([2002:a05:600c:4892:b0:4a0:264:76ac])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6388:b0:4a0:1d2:1a8a with SMTP id 5b1f17b1804b1-4a001d21b90mr75432355e9.16.1790617319925;
 Mon, 28 Sep 2026 10:41:59 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:17 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-11-smostafa@google.com>
Subject: [RFC PATCH 10/15] mm/vmalloc: Add a get_vm_area_node()
From: Mostafa Saleh <smostafa@google.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	akpm@linux-foundation.org, urezki@gmail.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	David Stevens <stevensd@google.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 65F771C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9e9xsobe97816wfd6thnmz4p9cy4sng9
X-HE-Tag: 1790617321-622754
X-HE-Meta: U2FsdGVkX18BF0yVaIwP5sQzS3vgQ+alSnLoW3gFoPKxTNPn02x3Sbq33uBEXeaeNX5B6xbQm8DAf6rczuypHpYujrn1CKXlad+NP5rXbjgzWr7bcYFIpwgqcFxtCmfy+u9/4f0qGdn4Xpz+1xhOL0YBMyiX6Vz07ZwyMwmbw0uBSZDl/qKaTl6IIYQlMsYdRJEvPvO6ZugHE5etM6I4Fofb72MXin2jkHcCslG8IzzHmSeA7ENX2qjCTzwMsh9nzedf74giN0X4G1/43OWE2gq4grvaJCcH/akrzejHgJh5zDsSFHLTabNExUSmvPDAgy5vuyDpSf8sQMgP1g6iElZdIfS/iKub4kc8UWF6A00AlHWowiNALkCdDeUx796vr997HroJ9/UO8tMJXxYeDWE9mmXGD5lrGd0YJqKlR6Dt/LUB98M5LsTDLRSxZdhXXvrReEWaFu345mMiBAo5F8nSwDhBeuOddMUfRw/sQJgEbmT4PR2d42/VUqx1qG23dr6ZXryqt1hsP3xxDr0Omyk80t6jJ129vCKm+jInacbOsQOwTBc5GmmJcf2bpk32Z8kzVf/FBVrx4eFlhhrjvYBKv7DDBlaBlpvBeR+L9Mvk0G72kg+ieiXyRLPa7QC0A8eO2U3JX9FvE1sF1yh4oPWxCRABY6kQd3HfTrr2ACqU4amxXpJ2XVpVk1UeybhgJASvSofs240hBkKsVIrVpmCokHyvPYshdzOeepeSDOjgCynAliMMliqirG75DQVrY+Bw2wyL3AxKX6mk3DUerR9UxppylP0Wy6UetjpJHUWUHqYhzHbNWn7iGG3AAYH9VdwbKPWXau5Lmcbv6mrVDdzkttvBnklGS5LFeds11sAqHubhAPkCoalA0nLBRmr8FLpDDYvfb45PwT9euJUCMo1Hk0/iBSFvl6jVpcdEPE8Fu+VBDhtA0Qaq2OBdhahHk5oGSsjK+Xoz/IcxwIy
 /31JohgA
 c22BOmkJG+ppqTTPxGbbOfMRpk5of2QWf4ko3f0nNfZnB/Jx9zDKlo150ydw+Y2K9lkkBH4huKCVCl3O1N/nXsbY4vLd+DEjbEV9p0P2O1tRYU3J08GRS6EAOcNqoeg/toxfuACPFjVxoClHHBmQzWfaaVvMNNXb/deJKzOF4/uCiFW97I0WHG4PEfO8WQlK4HHLWy1gZXHRU3xQ79htnkGekMSxf3Q5J92+7Jmv+ZDsaEsrAaxq6laC07uGeN0NaEZHHLySQLYsYnj0C+cYKcd4lbAK0Tmuhk1SHWhjOYBTpOuQK2WoxMiEc8hVX+JP099SdjZAUfCzClrDVyeBe2XTgtR+U7lumo9178QigjqBKlbnrjQ5AETe586rEJ3en81DrOX9TuL/3UGeOyEy/iDt9sKGUXpUM/q8VOl5XGfo9DMZW8LjhQvyl+Nz7vcl/H2SO0/eYwm3Xme58Jd2Rwq3kkpnoiub5lQsNHxPtVldZRdw5XBOebloCuEJHInQ9Atf45keUHzq9qlnAOZwsvKQLp8mYNdWGR6gC5YzVFdaTtxjaJS/I2IpD5hlaDEEFP1v0BsDHCobBnAHI8BHD4sgs47L3LfXKQSYhYib4F0iCGAKLEmPgUyDFmg9ISvrZd48eoaanFDISHekM1UVtDf9AU73dSSsic+m7Bq5iaqsj/qHctjz6aHBK1BjESFiNMlrb4eq4IqunIIQqSDIiVbhK4ApTXx2orgPmOHTq3ZykwE9kI3ryTStyZCysTRAEANds
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

get_vm_area_node()
Unlike the other public get_vm_area_* variants, this one accepts node
from which to allocate data structure, and also the align, which allows
to create vm area with a specific alignment.

This call is going to be used by partially populated stacks in order
to allocate the VA space for the kernel stacks that might be larger
than the memory mapped behind it.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[Switched to vmap_pages_range instead of noflush variant, fix typos]
Signed-off-by: David Stevens <stevensd@google.com>
[vmap_pages_range() already in the header, and remove the export as it
 was not needed, update commit msg]
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 include/linux/vmalloc.h |  3 +++
 mm/vmalloc.c            | 24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index aed121d729b0..e6a9c1bbe789 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -250,6 +250,9 @@ extern struct vm_struct *__get_vm_area_caller(unsigned long size,
 					unsigned long flags,
 					unsigned long start, unsigned long end,
 					const void *caller);
+struct vm_struct *get_vm_area_node(unsigned long size, unsigned long align,
+				   unsigned long flags, int node, gfp_t gfp,
+				   const void *caller);
 void free_vm_area(struct vm_struct *area);
 extern struct vm_struct *remove_vm_area(const void *addr);
 extern struct vm_struct *find_vm_area(const void *addr);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e7..9f4634c7977e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3301,6 +3301,30 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				  NUMA_NO_NODE, GFP_KERNEL, caller);
 }
 
+/**
+ * get_vm_area_node - reserve a contiguous and aligned kernel virtual area
+ * @size:	 size of the area
+ * @align:	 alignment of the start address of the area
+ * @flags:	 %VM_IOREMAP for I/O mappings
+ * @node:	 NUMA node from which to allocate the area data structure
+ * @gfp:	 Flags to pass to the allocator
+ * @caller:	 Caller to be stored in the vm area data structure
+ *
+ * Search for an area of @size/align in the kernel virtual mapping area and
+ * reserve it for our purposes. Returns the area descriptor on success or %NULL
+ * on failure.
+ *
+ * Return: the area descriptor on success or %NULL on failure.
+ */
+struct vm_struct *get_vm_area_node(unsigned long size, unsigned long align,
+				   unsigned long flags, int node, gfp_t gfp,
+				   const void *caller)
+{
+	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
+				  VMALLOC_START, VMALLOC_END,
+				  node, gfp, caller);
+}
+
 /**
  * find_vm_area - find a continuous kernel virtual area
  * @addr:	  base address
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


