Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11FE6CCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 03:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B7998E000B; Sun, 19 Oct 2025 23:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6678D8E0002; Sun, 19 Oct 2025 23:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 508F88E000B; Sun, 19 Oct 2025 23:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A76F8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 23:17:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD4C5140720
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:17:30 +0000 (UTC)
X-FDA: 84017032260.05.8FD80D1
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id F3528C0006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:17:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fpaoyaqk;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760930249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgY8zZ+/XYQ7X1ie6Z77HlsEOZA2/cqevW2Opv26tkA=;
	b=D62+3kc49Gm0xyqge6oRmJIOzDwe9nGpiqqy5E38tGya+UAnQgnh29gwo50LQ/pNqQ5gI/
	zBtVGpzzCe230PKV/lmdXbFFK4uOIsBfNa52VFLo0DXPNYZDKDuUMkAae6k3f4So008RJc
	UsZFPWPGXYHAubZgOVfSbNhdFSYgF7k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fpaoyaqk;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760930249; a=rsa-sha256;
	cv=none;
	b=U+FjBhAbVDDuJvph7L88+femDri10g7RCJWvQbzcOB/tlUxdVEIU/TyN2dKeIh4u1McZwK
	/IajjG1xkgO3cj/LaUsbeQySB5P/MqWLyzz6frFqo/7CqoFqtu7tfYqZU7in2E7b2oK49+
	LzpK+0XbfqCn7ka7SXI7L4A8VaCfB1M=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b60971c17acso3177158a12.3
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760930248; x=1761535048; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kgY8zZ+/XYQ7X1ie6Z77HlsEOZA2/cqevW2Opv26tkA=;
        b=FpaoyaqkjKQQBDfrWViQKMnasR3LLAHQkD40WX1DHhdg+HVUr7MOHPF3qbD1nwAvvc
         34wVzNAPyd5akicplyo4w5qVHJCZG0NNDM4HSD8gD+ylu+duasFy998aQBIVDuLmrGNh
         DmDfVyni5Fegzyr4dnF9IbjMXULTErDrCUn1RWQXQZccqx1TQTcmfaVBOSQC9HjT9vmP
         dG3tmQd/HWeZtn1OGezuPzCW9dGC+4oqstJ7WM+OH5hCgQ82fZnBnhBIt2L0XTgOffI9
         mEvJpb/lgIOpHQT17pFNiekZPRcm9jIrarQG07aySVaz6xFKrn0obx0ElJMvgiGn2p5t
         zWPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760930248; x=1761535048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kgY8zZ+/XYQ7X1ie6Z77HlsEOZA2/cqevW2Opv26tkA=;
        b=e5yUBW1HTvxobyVWLgC0hnE/VU9YrbkicOwaVosMS2B6aNm0+hBUTVPdtvoxSzRGp+
         YkQqgR6SeQN9ivFgobPlNpul4sUOpM3DjxJMri76p+Xo6N5rSl5FIcWoR7/H0AoklPS8
         hd1UVhPPkQT5TCEJojkPtw8yZaPn0t8ESTir/gKlXmRuX17b5HtHyssLGa5Qff8tK3Gd
         GvTTXSsXlLxSrEp7i29bxtqIvhoyG7JimhUqm2iKYfbbgoI1TeTXkSj0qIJLZthKMexi
         CtxY8QK6Id1zNoZdgoGQf8hlVvQYsMcfeGhOZiewCgEU1xeBwACGyb25FIn3YX7sDzrN
         tsYQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0sfPyIn3KkKqbr7Ook3VlX+szW+q3tpDMyhvDb4SDcbBC2IGTFJrmwtB/awCyXJ1IV+1tXXSv8A==@kvack.org
X-Gm-Message-State: AOJu0YxXUXZTdn/0GsKC/yAoVa8oikCI1tNaNJ9sPCaUGyI4pcU+og2H
	7NMHjc1mlBHEHbT8+KDra1IlPap6/P+89zzLIurA4oIBLSi0k+bTHuAn
X-Gm-Gg: ASbGncuUWSsYB64uuIAwNNEChCr316ciD6BIjUukC5zy9WtrBgNKwJQNixjAPpwwyXl
	E3Y+PcoaBVqDRPz4Etp6jeV9Pan5jaN1CHwtrQiKjJpNKbl+u1aBeHWR/GYLGbEiYm67kjtYlTt
	o0btnLChraRuiarcfi1PvwsGT5ls27dG7yhIwUGKTjExlt6t71a5VPskyQwLg80995qm11qQsWk
	u8pMfvosp6AWNwSjEF6mGukOfrn+3CoHwQxD3ko7jqw+VAExTqruRZ5psFX26kl5f6epkAKupZy
	Vu5YNUgbRMf6HldRpexdwIV52iCxYjghCppoh7Jusr5Y89Ta3SlGGHEby9dQMhMPE0ZUWJJFb9w
	ZyaviAJf7REJSB6vQGiNJcM6lZO9Anz2PGfOUSgIXJFA+tlbt9VRvkJflEeLevdKQJS3Ee2U67A
	BRPqZE/DLwhtOXMoMbpkoNrBcmc/O7k6Z9Wfg6DWABUOJwmA==
X-Google-Smtp-Source: AGHT+IHVM+3Yo7hTmlmKN8A82OrKb4FDTGmFMRc6s6X9qctctr9R21jaCigysyc8KxazAaAwSj+mYg==
X-Received: by 2002:a17:902:ce07:b0:290:a3b9:d4c7 with SMTP id d9443c01a7336-290ca121944mr137614825ad.30.1760930247823;
        Sun, 19 Oct 2025 20:17:27 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1da1:a41d:3815:5989:6e28:9b6d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471fddfesm66373435ad.88.2025.10.19.20.17.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 20:17:27 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	david@redhat.com,
	ziy@nvidia.com,
	lorenzo.stoakes@oracle.com,
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
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v11 mm-new 07/10] Documentation: add BPF THP
Date: Mon, 20 Oct 2025 11:16:52 +0800
Message-Id: <20251020031655.1093-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251020031655.1093-1-laoar.shao@gmail.com>
References: <20251020031655.1093-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g6hwdjudpeumz5kio6gs7stagyedimda
X-Rspamd-Queue-Id: F3528C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760930248-110961
X-HE-Meta: U2FsdGVkX1/rnY0E1YSB4cCQjQAMIpFDbBgI6So+x5bRbuLp+0chw3QtiacUebfs5+KKq4LO/DBaMmVB6pRRUYYbFBlcVL6jhLcGZrJ4LyZJN+Xy2iWNYvWU48moOZqiEuHpjMTcmxBJsraqDmvw5iOhI9++BZrQSEyHm3BEEZXeRqNumBDhdwD1c9WcrEzFwfHqc2O6CSAZjb7WxYhozfSnezql3L78R0q/kOQCGCXRQxH6bu46KCbNb3WqV1Rys4Jk3JE3vV/es53pJMkWD+REdtBFHnsO8GI5Ur3R0iGlprhvjwWFFVzpz/FmI2/b2DKWX619JOCocgBoGB6X5QEgsrwb4e+6vZsnbzzaki63x+OS3YmCbXxn4uxIxR6JtwA9GxnOE85ZXNWmj/XQ2Bd0bpd9ptGHNBqXRk03VnLQVYsr0cvGaKKenygL57Ky47UqVJob6TeLcbRVRcCXJ/sTcNrgFn9bIVUZcoTy3IQSAKh5IpAK2ewmU2sVGQT4fXDnL47cbbhIbngiiRe+BFILT2GlGVF4G9oAhu0QRDOASwjIb7BFsQH2CQIjKMDvqLdHrXWsLk9zI2ru/AUFvTysp51hC+W0IFmGj/nS0BE6dOJMIVjB3zMQh8coW59aw1unhooq1YZAlb9t8cYPvyCrqIHV87GgMnrLOug3e0wEXbDwHelFWgnmM/ZjyKvTogrTVNnMyzRIXwEreOaIVW6HZ9zFCcY6otF468UpaEIQMMizBiBMF8EFO4RhKfR0mzaABBTqtRSAmaS1AE9Fb5EYs/ORx9Kn8UiYIFa0vhkihXRZK1b45/vtYTQpfOdyNWE2uQIxU8uJf5C2qKol/uYpR8+1/p2+/2eIhY8YLj63Bh3fawVTMW/kuZTkqXIsGIQK5d/FspGAyIHg3GbJO22waFU+4Wfw3BA/A4O6K/4cKIEqOvGCmzN6CyeG+5Ao63FFkIXvM6i3Y75wmKE
 QgpbJPD8
 7NLl7YBlXosIiJwpT8l8amIIserv1uMJcYgxmtMSnxI6ghX+A19gtWCeFj9/C/OX8HXOGC2x1flu/LE8A//hBZG4EgwnohP5da8pjyK5PqRCU+MyqTuyU05AbOSEVywn1udQVay2HO30bSxLtueVGd2kPlyPJI8m4wM+qWht1pqH5rolNjRTaoQgAMfnN+2IUVqgkRP//tGh7xOpKGxfk07XoeKKKvV30NuAdcCn2RQCiGZ+E963Fjouch2JWPd1WZc610Jl/9lBjYMtovcxeVphFr+x2nDfZIrl+X0TPNwMOG63z3GbkcHw3OIPPYqnFXvny9ZFSyw3xNwWtMB2ooudKQOGtKu18U5RBGmCMeNHtQSfQZqn0YpRsLHPV3ScEQf8EpgMiwr9Bthk3KZZ+3i4RtnRH3L14k8D2cB0v6Xuah6yVJ7QmtVT8mHouONDix2EoREBr5vLs5S3ffJw9GCIK8xmAWrE8/+Sh7PUurdclV4lTX5n4MkxJxcRgj2WbIlSk6u3TQUAkz7A=
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
 1 file changed, 113 insertions(+)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 1654211cc6cf..4d2941158f09 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -738,3 +738,116 @@ support enabled just fine as always. No difference can be noted in
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
-- 
2.47.3


