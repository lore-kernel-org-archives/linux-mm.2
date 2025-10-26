Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 906F7CCD193
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 10:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E98EF8E0167; Sun, 26 Oct 2025 06:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48B58E0150; Sun, 26 Oct 2025 06:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9A08E0167; Sun, 26 Oct 2025 06:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B46358E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 06:03:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C2FF1A03A8
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:03:24 +0000 (UTC)
X-FDA: 84039827928.22.9CFB3DC
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6F9D91C000E
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:03:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=daE8WGnf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761473002; a=rsa-sha256;
	cv=none;
	b=FnaGV4ZR9UPvPllXuQJ+LyORIVZj7gdB4cg7eQKl6ppgkAx0w1J2ZbdVHcXMwX0gRXgMgL
	c9GGABXOZ74SpagSLBYVUMbbeL/MvVEUC65CqhzwIxMs8POTOu9kpKs1gx42e4CJOu1p6v
	rn8PZiX7epCVBEllIT17k9jR+y9KVj4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=daE8WGnf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761473002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VTbcM0ayqoWwS8U5wGMUp/PcPN32NyXKHTXTAAB8Oig=;
	b=Q7q7M7VCYETHrJFe39H4en9PiaeKiCodix5EreCokPIBwwkl+dnxtBpQX8dOGBVh62bk5g
	FYDUaixmnAdpZ8VD3Le2TkFdUQjWwJIHL24cSe1JlmV1T0tp55yzuKQjL5ENfOx/A32G+D
	Ml5G9m1tLJEkOQcGBpuDsv9Vs0L7Uws=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-793021f348fso3014610b3a.1
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 03:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761473001; x=1762077801; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VTbcM0ayqoWwS8U5wGMUp/PcPN32NyXKHTXTAAB8Oig=;
        b=daE8WGnfIilTlfvDE0aJrlLBD/1QIfjHj0e3KDwYhAhTbeUHos+wzntLgiXPA/b5fW
         nkTLtyIOpb5v4pJHJPAe5M5ITRWUdLRVkoYtEI48EsJKjZqlCiggk01m0WwoGK3m+j+t
         Db93HyJ2UmxyNePAdrxolznceKI8Bpnctn6UBzai6h6eh7E+JVuhKbCM6hwwobGtzj4Y
         j0NwZZoId01vTNmSOoZhKijQDQlMjtmh/KMfWmNfNtHW/2GeZN8V9C4LwANCkrFcZvLg
         xIvq5u+EuG01YVpvSDdJBB3VujvIzPmvkoFDq8c2649+jOhnIsjMwrTzlNixexetNnkS
         V0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761473001; x=1762077801;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VTbcM0ayqoWwS8U5wGMUp/PcPN32NyXKHTXTAAB8Oig=;
        b=nBQvzzoRcN6+De2Qvh262PPEBUZWvXWla6INdv4qBgBP5/MKuBtpFRrAtT8YWYN4Bu
         CnBo0IWSuweOK7j3VzoPRrLu3iG+/jK8Z851YXcaRlr0JUW4ez3JEt3B/3s65WK241M1
         AvyvLohqW8bLpnFLp8hpwK+oH5UqOZP47HzAW02fyrAxhktH4zBXpu0rtNnFmhmzlQeS
         PRp0ypR8hUbAUVnHPMIVO6BSrZAws6rdvcr9n6AAVwrvMd0FVZsJm7aSZslEUijHXh2s
         iLYngIdVGBvoRJsF5Jwvqb7AirBcoD4pq9JA0wyRXe1uRW+zbm/2ODpxeUM7g7cbLqxF
         JIbA==
X-Forwarded-Encrypted: i=1; AJvYcCX5wtZsBxvoIuQQofhUni1PtymfzCN/irc8p6hmbU3l1Lv5Rs0W/EPwo4q02u8k4Jxf1hsuPR49yg==@kvack.org
X-Gm-Message-State: AOJu0Yz0Zwrn66kaIw2qxH1jDsfrOT/9vlSGTJYPLj4rDTFwe3n7yi7V
	xQDK0LirPs/uA13mRTe2Y/RgvHxk5FsCkcnehCydMJ2X2HZ6LYduva04
X-Gm-Gg: ASbGnctWo5FKp4WYV9wLHuJM0jgq7BuDsbrnk+tUYChHgwg5TzNnTkqq5+CgaclkXrH
	dZpoW4gdLIm5p87HyZZ6sZhWC0Ofxb9A2Xb8RxOa4mn78p81+/gSv5BHvt49s7wAowzw/2x8IE1
	hRwL92JYivTmr35XrB6urYfAJLXyykX0bai8vEFerAyBGnDzygMosnYM8oaXAHpBAZ8I8R5qxqM
	CDahS92UBTIeL1HVH3ymRrM76aYl02rA7yJDLJjUuUvqPHR/mV2Cn2icnB/cx/rJIdlBgqQU4Fj
	jMv9wzD2CIz6vWZAacxznTLZaW2UtJf7DgkCI5ST0TzdB9WJx4z4pzYSg+wDGa/i8AX0U2Dicg3
	1pB90bOebngdmMNgNRKr2vWwRShdG35pcXb9vaDj/FB6kJPRHLxy6QenLRgAVe8MmZk8LCWLWPF
	qEnlEUZAj5RMRE5c8B5x3NiqrAJSe0KTaqOi4=
X-Google-Smtp-Source: AGHT+IHEY8mqdGcAazzp5rPEyr5waMaxx6tTVi2B3EGGTaAB1FjtGvhczK73gV51ecEw4czYNqbexw==
X-Received: by 2002:a05:6a21:3989:b0:342:6c97:3680 with SMTP id adf61e73a8af0-3426c973993mr2025707637.53.1761473001223;
        Sun, 26 Oct 2025 03:03:21 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1a84:d:452e:d344:ffb:662b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7d1fdesm4824966a91.5.2025.10.26.03.03.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Oct 2025 03:03:20 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org,
	clm@meta.com,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v12 mm-new 07/10] Documentation: add BPF THP
Date: Sun, 26 Oct 2025 18:01:56 +0800
Message-Id: <20251026100159.6103-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251026100159.6103-1-laoar.shao@gmail.com>
References: <20251026100159.6103-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: md8rxhytaae8dtmfkrt8psjemy1uftgr
X-Rspamd-Queue-Id: 6F9D91C000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761473002-8970
X-HE-Meta: U2FsdGVkX19vVFthoHwmtTaOJQhoS2e5fW6v8SvB7sGb5NYpENaojiaQfa+KGxnuSpA5Q5wqJNex2GDlBmix+YlSGKv2CqD1N2eAY8m2DeSNn2a3CsTQs6bXqFMbeY7FQZlv0ysfyOcwo+M4Do0sEo6EyjwQCHjuST0hCJMOlR1sAGTv/Wk5A30TqpEOJDriqmq5GhtgyDNiIzZZvA74oDaK6hrLwlaMLLtBxHAzurAd5QDfqb/rv/sNlKU+92l4MXzwZmmDUkf1hgNAbum6Avm/QmyX0H9Y/gLcGKVFjnIdOlxgFrrf6+Qcxs4wJRmTxbkSLcN9FtqfDVKe7u59HMB46kZr0yDTgDvT87q7PpyDQOk5YQ5/vXCGAtTmJeNgvRQW0YLFL9+Tjipnek79IbuH30EP1xXaPFCGFvVlaZWq0tZJx47C2p6McRVMDcog0A1cZ6n1umnxKiblG0d0xQzUoY5Q003cbsk3gdv2TtI5GnQKtDMkfWWLpvm83zyHdQ11ndgH3Hqgkyegvpbcg24TBS2wJet9wQQP9wPYb+RJeF93XFO/ro7B9GuAssy+Q2dIMuve3w/bi+9zqLw6wb5mQ7ZBEShJ/UhaijFu2hm4ifl+WjD/CF0qTm/45m7Ndv/p7qbZT0BgAAHiYrcNF/ddJgtYDN5Dl4QFDe7jTZOFL/fDJbxgbZ6CufFvxQ4yHxfJ1gNx4eJxezVuuj7cC0/EEA0LLd0n7WiYbFSzvXxeSe+wfaMMzqfdtWL4tii9nd0wr6VKSBjiw4Vq59t/guxzxzOxs5ivGAWRDWoUkPHWnGhDXQg8cQRgcGqJJv0Rm0UmhVwbEaF8rTk6vMG7oD+h40FCTCoqzxnIhPuUEzxJsZM5siyxRZ2ezZodY3XxYdy/Lcf0LZhjDMMwyxlQfrkFk6V2XrlZFiQqsVM5A8xRugQdtj/MsB8l/1D+ftXU0iyfAzOxUV652DukEal
 Owimqbg4
 S3cLmXqfwrZOZoDh+12xkFMOQCgalrX8+WOIeNHACpVCutbkJ3t6/qyVSiX8hzOl514OkgmNuONH3gDROp9SrGAzwApjdItdEIVFJWCRUVUX6MF8/RxBhpAo5hpc4SVeuzLFvlA8ixFenTjzVKkuJmMd4H3uzAEk54aj0UDQVIAfTtdiGF9NkqP0U1Rzmc6ruBSfZRT56bzd8t/J3qdXT1C5w4c1LYWt47ZaGxHmFWnSACw4a+tqShbJx4h5Isf/T5XQERXvjSbSLSh17qzlK8oAt8BUII8O3FCK5QRXW6UVCxLfb+uvk3y9tHr8TeJW2Es6cYMlmeU1K+qx2/fJV4/CXsuBnTUvBsdQARgDwYOQ4MI+EccfcFnSzUSxlNvYvYCahN6nTnIHuEYu5CS5l9boUVYK1IMmKoxiTTSpC3fygQfcDY+MaKakOWmxa3ATKzxev4PCfkkPCDyvZmgW50vS4AdUiZkI86cLin3xZJPpytyjt9P6k3nUw714unoeVtEiw3VbRD5OdRGo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the documentation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 113 +++++++++++++++++++++
 mm/Kconfig                                 |   2 +
 2 files changed, 115 insertions(+)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 2569a92fd96c..a85ebcf7e07c 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -776,3 +776,116 @@ support enabled just fine as always. No difference can be noted in
 hugetlbfs other than there will be less overall fragmentation. All
 usual features belonging to hugetlbfs are preserved and
 unaffected. libhugetlbfs will also work fine as usual.
+
+BPF THP
+=======
+
+:Author: Yafang Shao <laoar.shao@gmail.com>
+:Date: October 2025
+
+Overview
+--------
+
+When the system is configured with "always" or "madvise" THP mode, a BPF program
+can be used to adjust THP allocation policies dynamically. This enables
+fine-grained control over THP decisions based on various factors including
+workload identity, allocation context, and system memory pressure.
+
+Program Interface
+-----------------
+
+This feature implements a struct_ops BPF program with the following interface::
+
+    struct bpf_thp_ops {
+        pid_t pid;
+        thp_order_fn_t *thp_get_order;
+    };
+
+Callback Functions
+------------------
+
+thp_get_order()
+~~~~~~~~~~~~~~~
+
+.. code-block:: c
+
+    int thp_get_order(struct vm_area_struct *vma,
+                      enum tva_type type,
+                      unsigned long orders);
+
+Parameters
+^^^^^^^^^^
+
+``vma``
+    ``vm_area_struct`` associated with the THP allocation.
+
+``type``
+    TVA type for the current ``vma``.
+
+``orders``
+    Bitmask of available THP orders for this allocation.
+
+Return value
+^^^^^^^^^^^^
+
+- The suggested THP order for allocation from the BPF program
+- Must be a valid, available order from the provided ``orders`` bitmask
+
+Operation Modes
+---------------
+
+Per Process Mode
+~~~~~~~~~~~~~~~~
+
+When registering a BPF-THP with a specific PID, the program is installed in the
+target task's ``mm_struct``::
+
+    struct mm_struct {
+        struct bpf_thp_ops __rcu *bpf_thp;
+    };
+
+Inheritance Behavior
+^^^^^^^^^^^^^^^^^^^^
+
+- Existing child processes are unaffected
+- Newly forked children inherit the BPF-THP from their parent
+- The BPF-THP persists across execve() calls
+
+Management Rules
+^^^^^^^^^^^^^^^^
+
+- When a BPF-THP instance is unregistered, all managed tasks' ``bpf_thp``
+  pointers are reset to ``NULL``
+- When a BPF-THP instance is updated, all managed tasks' ``bpf_thp`` pointers
+  are automatically updated to the new version
+- Each process can be managed by only one BPF-THP instance at a time
+
+Global Mode
+~~~~~~~~~~~
+
+If no PID is specified during registration, the BPF-THP operates in global mode.
+In this mode, all tasks in the system are managed by the global instance.
+
+Global Mode Precedence
+^^^^^^^^^^^^^^^^^^^^^^
+
+- The global instance takes precedence over all per-process instances
+- All existing per-process instances are disabled when a global instance is
+  registered
+- New per-process registrations are blocked while a global instance is active
+- Existing per-process instances remain registered (no forced unregistration)
+
+Instance Management
+^^^^^^^^^^^^^^^^^^^
+
+- Updates are type-isolated: global instances can only be updated by new global
+  instances, and per-process instances by new per-process instances
+- Only one global BPF-THP can be registered at a time
+- Global instances can be updated dynamically without requiring task restarts
+
+Implementation Notes
+--------------------
+
+- This is currently an experimental feature
+- ``CONFIG_BPF_THP`` must be enabled to use this functionality
+- The feature depends on proper THP configuration ("always" or "madvise" mode)
diff --git a/mm/Kconfig b/mm/Kconfig
index 12a2fbdc0909..c374a0f4acc4 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1476,6 +1476,8 @@ config BPF_THP
 	  Enable dynamic THP policy adjustment using BPF programs. This feature
 	  is currently experimental.
 
+	  See Documentation/admin-guide/mm/transhuge.rst for more information.
+
 	  WARNING: This feature is unstable and may change in future kernel
 endif # BPF_MM
 
-- 
2.47.3


