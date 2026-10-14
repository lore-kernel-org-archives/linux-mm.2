Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578CECC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 07:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B636B0092; Wed, 14 Oct 2026 03:04:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD936B0095; Wed, 14 Oct 2026 03:04:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EC566B0096; Wed, 14 Oct 2026 03:04:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 62BEC6B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:04:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8662A046E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:04:50 +0000 (UTC)
X-FDA: 85320344340.18.468F6A8
Received: from mta1.migadu.com (out-205.mta1.migadu.com [95.215.58.205])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8BD03A0004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:04:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ra8dCi7Z;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.205 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791961488;
	b=ymPuvy8504bcJk0ZBoNDutLKzFQE/DZCgHr3LNIEkr02LmDPb5SAcfN1B36Kighkz//po4
	Pw6RBtDJfC1AcXFDkvI9tVCYPyG8jlsNYdyWSgheytzG+NP/WItR7iV9CseessmbgNhCTg
	HkP4Cu83/x8COAzGLk3JL9GX8UAgUbM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ra8dCi7Z;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.205 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791961488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B4iINhr/fa6E/H7Ed+srDK2oaltaOpyuak9IEZ6VKNI=;
	b=wclt5SAYWSoFKvUVun8Fme+evTCyRvkGXSeLkBYJFGh6hft/MidWzcYlo7jRGzY+Fra8oP
	8npOYcxFEjsD2pm51MQg4uHEBJjTNQ2II/OYm8KjWX5l26hEeWPhF6ylSC/EWoPCmkR1zA
	cOBd9N2Gdqo6ed05OzTwepAcnEQrd1o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=O5KAl1QIwFpmtS13iXGYwnjfmOpnWs/eRpvfDXQ+vk8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791961487; v=1; x=1792566287;
 b=ra8dCi7ZPYrlpf0ZGT4M6s5BessyG3EMwJRSkca4FneIyRVZH5d6TFsDNwjy7SGBb7VreTEK
 yJTOCu31a4IsrxUCxqKqsqga19xqjmLQhSxl3ighoXU0C6qry6KRzvUrv2hRqI7PKViob04Zz+U
 WnfLmCErPkKr4gA3r/BsiZjY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1490cbe7552e56db;
	Wed, 14 Oct 2026 07:04:47 +0000
X-Mizu-Trace-ID: 1490cbe7552e56db
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Wed, 14 Oct 2026 15:04:30 +0800
Subject: [PATCH 3/3] tools/mm: add VMA flags decoding and name display to
 show_page_info.py
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-show_page_info-v1-3-7a68aee0114a@linux.dev>
References: <20261014-show_page_info-v1-0-7a68aee0114a@linux.dev>
In-Reply-To: <20261014-show_page_info-v1-0-7a68aee0114a@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.17-dev-39d60
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8BD03A0004
X-Rspam-User: 
X-Stat-Signature: bx4i7mtfxhaixdxwzs3yfasbpd7pkfzd
X-HE-Tag: 1791961488-226588
X-HE-Meta: U2FsdGVkX1+ZDsbK9YyJZr8CmlW5wrXJ8RPFIZyB18cjpbJCRsn5VWdCErJDjhS2S5SRzNSmdPU2pIJv/Nuof5JUZWOiIZ5gGgD8uUPNQ+OcMvG1rTZk+upMEjLVI/xV3i1iQtHPK4JkgigMNoBjT641GYmPPHCTq/f0pPIC1uWwlNQ72GenUXUsrJQTo77X+3/LwaejlOAlK1qYAcK1Jrni7QeXn4ujTpc1cKlMHTex4ZnIv/F1NzVyH6QBB3BFbfr+pI3KjX68Vqz0QpDX9rkUB8KQ/wakrau3TbzBcEeVwIBYF7aS0vkaI/DtNISHLcizz1McuYE706v4W4m8+JYmqy5dx4vXq+CkEQSlU+niovy7lkYdLR62P68EcOzuwYqK+hOiU3Zfe24/PFAMfvYYHe/ybQmMNetZPH8X9LCgRHa0n4ZOQnqP0ojtEyOLb21jf0lwh55pwTs/axyhKiXPCNr5LXRH7I1Evnk9FMclXP0oPQfkaiYaomgjHc6krBeun3EqniEhVTs+cSmTp+azAh2TFUMP8qHus1S5oaqWWrS+NFQv23QLVwh2VBC9Q5M4XxovNkfndsew7YF8/1tBwK7BrNAqGOh0J6ZxE4TushxCgnlJFeKHfKzslZtJvvjQfR5or2QQQDphVjzlPfmZnyW9mH5EBir3eeGH9BZK22Lv3XPS/c6m6HdcBpAHZ5KP87m0jEl1xynTmGlPgXJA8J+9eiRXy3dUOCICaxqtjR8rTsivpQTNbesR3KVkdMd2PNbOPC3KMtxBygb+dD03HsdcMITJrjPYF4k2YCwNFmE3UgTo2cdSCQ4SStglexWJz5V3xa7xPyBmlSNBjw3jfbWifOSM8LzeW3rsF3EQHuf4btBpcBMls7+BKasl8DdN7tPYxIyU3POSdx/tR9kyMto40eVwmjULhOe6NdYAmtBDfRJCcc5PPecc5YSC988aiRQgZSlSLzN76Ud
 gxAfeK8k
 XMfEzYWLFcWI6SLaXIz4VpdljyLKFA14779jumDaBkKn6Ri5quBfzy77rTN+IO7n0Y0IY9ndhyAor25XIclQrjb3uAK3jakrir8cH3KYQ5lxgSytHVPPvGbBidoQCtELeqL0cd8wc1OBTlgmKhCLu1NvGbyZ070IfZxbi8RIKJ61Y6paHVRlcdDaxg2B2uGdYV7rr3Glai5FgsIsYIMmBDCx2KIqid8WiAd0M7QN0XJvAhJk31qmkRinXy7R0zk4mfLqM3SxBly3bPRrpCo5ykttwxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Add support for decoding VMA flags into human-readable format and
displaying VMA names. This provides more detailed information about
the virtual memory area containing the page.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/show_page_info.py | 54 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/tools/mm/show_page_info.py b/tools/mm/show_page_info.py
index 1fbef3889e91..9dc65b4d2b29 100644
--- a/tools/mm/show_page_info.py
+++ b/tools/mm/show_page_info.py
@@ -7,10 +7,11 @@ import sys
 from drgn import Object, FaultError, PlatformFlags, cast
 from drgn.helpers.linux import find_task, follow_page, page_size
 from drgn.helpers.linux.mm import (
-    decode_page_flags, page_to_pfn, page_to_phys, page_to_virt, vma_find,
+    decode_page_flags, page_to_pfn, page_to_phys, page_to_virt, vma_find, vma_name,
     PageSlab, PageCompound, PageHead, PageTail, compound_head, compound_order, compound_nr
 )
 from drgn.helpers.linux.cgroup import cgroup_name, cgroup_path
+from drgn.helpers.common.format import decode_flags
 
 DESC = """
 This is a drgn script to show the page state.
@@ -75,6 +76,52 @@ def get_memcg_info(page):
     except Exception as e:
         return "unknown", f"Unexpected error: {e}"
 
+def format_vma_flags(flags: int) -> str:
+    """
+    Format VMA flags into a human-readable string.
+
+    :param flags: The VMA flags as an integer.
+    :return: A string representation of the flags.
+    """
+    # VM flags from include/uapi/linux/mm.h
+    # Since Linux 6.19 (commit 2b6a3f061f11), VMA flag bit numbers are defined
+    # in an anonymous enum. For older kernels, we hard-code them.
+    VM_FLAGS = [
+        ("READ", 0x00000001),
+        ("WRITE", 0x00000002),
+        ("EXEC", 0x00000004),
+        ("SHARED", 0x00000008),
+        ("MAYREAD", 0x00000010),
+        ("MAYWRITE", 0x00000020),
+        ("MAYEXEC", 0x00000040),
+        ("MAYSHARE", 0x00000080),
+        ("GROWSDOWN", 0x00000100),
+        ("UFFD_MISSING", 0x00000200),
+        ("PFNMAP", 0x00000400),
+        ("DENYWRITE", 0x00000800),
+        ("EXECUTABLE", 0x00001000),
+        ("LOCKED", 0x00002000),
+        ("IO", 0x00004000),
+        ("SEQ_READ", 0x00008000),
+        ("RAND_READ", 0x00010000),
+        ("DONTCOPY", 0x00020000),
+        ("DONTEXPAND", 0x00040000),
+        ("LOCKONFAULT", 0x00080000),
+        ("ACCOUNT", 0x00100000),
+        ("NORESERVE", 0x00200000),
+        ("HUGETLB", 0x00400000),
+        ("SYNC", 0x00800000),
+        ("ARCH_1", 0x01000000),
+        ("WIPEONFORK", 0x02000000),
+        ("DONTDUMP", 0x04000000),
+        ("SOFTDIRTY", 0x08000000),
+        ("MIXEDMAP", 0x10000000),
+        ("HUGEPAGE", 0x20000000),
+        ("NOHUGEPAGE", 0x40000000),
+        ("MERGEABLE", 0x80000000),
+    ]
+    return decode_flags(flags, VM_FLAGS, bit_numbers=False)
+
 def show_page_state(page, addr, mm, pid, task):
     """Display detailed information about a page."""
     try:
@@ -106,10 +153,15 @@ def show_page_state(page, addr, mm, pid, task):
             fields["Page VMA"] = hex(vma.value_())
             fields["VMA Start"] = hex(vma.vm_start.value_())
             fields["VMA End"] = hex(vma.vm_end.value_())
+            vma_flags_hex = hex(vma.vm_flags.value_())
+            vma_flags_readable = format_vma_flags(vma.vm_flags.value_())
+            fields["VMA Flags"] = f"{vma_flags_hex} ({vma_flags_readable})"
+            fields["VMA Name"] = vma_name(vma).decode()
         except FaultError as e:
             fields["Page VMA"] = "Unavailable"
             fields["VMA Start"] = "Unavailable"
             fields["VMA End"] = "Unavailable"
+            fields["VMA Flags"] = "Unavailable"
             print(f"Error retrieving VMA information: {e}")
 
         # Calculate the maximum field name length for alignment

-- 
2.43.0


