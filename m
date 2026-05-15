Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50816CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBAC46B0099; Fri, 15 May 2026 08:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65196B009B; Fri, 15 May 2026 08:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7AFE6B009D; Fri, 15 May 2026 08:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93AB86B0099
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:44:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A04AC2453
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:44:08 +0000 (UTC)
X-FDA: 84769621776.10.2D42ECF
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 36ED640002
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:44:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JniicQwH;
	spf=pass (imf04.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778849046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGsm2RDX/XHwWSFmN9sUr/w0dpuR7LKjQt4HIkP8MSc=;
	b=TniuDgoZQXQbn1EHkcJhDv0dUqAfc8i3kmFdjoqRT3vu+8UmKmqEkmKheoO+aGZmR96gM6
	uPiO5f+nXGfv5U04jIlHhx1KQPHt8RhEwyNyjc7K1gS5G5xRaOe2tYVmUnWm1d0lS2XOV7
	YOwN4f2VZg16caLSbzTw1bls1cHjxUI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778849046; a=rsa-sha256;
	cv=none;
	b=opkddhRSSDpe1PTwbCUjNdBops24K9QIWZ0GhxbGGMxVtT6xM5SYOK0Xt4/tKNOC6Coucf
	eibIZVaWMUlyMpDmUL9m9N+AAnGa4P2XEf37CqM7sG2SQFU5O4Nd8+oOV7iSuiDpp789Oz
	5VqgK1wq6G0JuXEjSTJlvTeBjxucdhk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JniicQwH;
	spf=pass (imf04.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4891b0786beso59518085e9.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 05:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778849045; x=1779453845; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UGsm2RDX/XHwWSFmN9sUr/w0dpuR7LKjQt4HIkP8MSc=;
        b=JniicQwHRbFh2kSZIDpGP99WHwGETpKVhul1pQD+nmpB0I2RA2Q+IC8j5f1n+kCJGx
         Z8djYKVm0ZOKcevj33toG9j/9SQFedi+SiWe5dC4u99MzvXo5uCt8TeFXCHL0d2+zis7
         pUq/PIGesA280FE4tYVzwShoLx3f70z2kt6qAk+dJhFRaLeSBbJAutflGL81kmX56Uai
         FP/43Zc/1J9PjJXI4hUssLSfbqkPC3crUC0uNQDHhOVMKWteZ9RdEgB0LPzgBcOa5Qi8
         TUh5dqz6QmUjAAha1Jl82iD0FuCMAm5miT65loMsvsJRVX7tWGpCJeofT2hN2F+Bxu9+
         538w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778849045; x=1779453845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UGsm2RDX/XHwWSFmN9sUr/w0dpuR7LKjQt4HIkP8MSc=;
        b=gs4rmbqKSRBuNvZODKnGR9ipdeZoxoBHKyZcyhSl++jRjTIQy8vpnY8TtbAUvPebLs
         OKuQ5LitwceVxrdbHRT0KYv3pvXgoXT2rWnd2T8ffwVMnL1jMcg3gA+nWa9Nc86xY80i
         xqcHg6sfN6G13mx6GTNaUjMJaGahrzMf1RlNxT5EO3LQZCuRjoyflEDm00jF3GDpi3GQ
         D1KbJc6tKRFm5qy1YPKJFuVyu401wj+rIl4S4/sA+YtysLHivwA3bCBSxOW99Je4y0r7
         WCRoMRKD4v79lXUncUQcFtAWAbJGHF3G3lQZkdXypF5bJpJ83fvb6JVKS2wFCzexDtNM
         DVAQ==
X-Gm-Message-State: AOJu0YxbPtHz6sL93V5ykYsBapA4FBZmoJUAy/ubS4N0y/Nx3nQF7ss8
	2oE/0myrOaIEdCmSMDfYlqPiVcNANxjFr6mUYEjmoF41ubHqtKjvcGzl
X-Gm-Gg: Acq92OE3l46Twwx/fhJLd+pXYVgtRV9Dh01KPCZTs/YBaFR6jxPISB6OkHxJ5fcpixL
	2OYgE1j93mYFdqFQQN9K+VgT4gGT8/7RFNPEGjUXSj8b3CcDX+xpNc2mpzXbhcf49ejaTYarUG9
	2rVB3lF7TGhco+HKyLVcnWvQoskD4RAPisRQZSE6QVVV5zw/qT/YREXpFcA9UWoaf+2xf4Tmt9Z
	tOEwlkl9p17owHsdLKmL/k0lroZpDOC6wIWorwMtbvvUi/SUv826ef2VvZbgzwaPXr2uAMiT2A3
	f/5fn0e84QzUlxjpU7PyKcSNsvum4/Wxb11+lvXkiuupmookeUiugbDDuUszu9mcQfapl9h2tlX
	gCRiuTwT9t0iQAZXTAjFRXRISW0jSF8nNsvsCFvp9f/tTlD8DPCVKiI6GHhe58SdXrWijITaewV
	DFLIprI0vlMsBJeddzkQg=
X-Received: by 2002:a05:600c:3e1b:b0:48d:46a:6e5b with SMTP id 5b1f17b1804b1-48fe60de6b2mr50749185e9.7.1778849044515;
        Fri, 15 May 2026 05:44:04 -0700 (PDT)
Received: from fedora ([156.207.183.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c8344asm100188115e9.1.2026.05.15.05.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 05:44:04 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	avagin@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Ahmed Elaidy <elaidya225@gmail.com>
Subject: [PATCH v4 7/9] tools/testing/vma: add VMA sticky userland tests
Date: Fri, 15 May 2026 15:42:17 +0300
Message-ID: <20260515124218.151966-9-elaidya225@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515124218.151966-2-elaidya225@gmail.com>
References: <20260515124218.151966-2-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 36ED640002
X-Stat-Signature: h7ejpysyhzoi1uehyfa63gm9jnfbtjns
X-Rspam-User: 
X-HE-Tag: 1778849045-828304
X-HE-Meta: U2FsdGVkX1/NVad8oB6JKkvoLdJOhMAqFZ+LBiPatVJt+RTXpGTPK7YIGjdiBW6yXKWhYN4Qo/6guKe5QEX1LOa3d9wl3YRlHGgcst2TNwM025tT4FBCMbIezExvx6uGpUpwF1tm+MV6sYBKzUkKrHQwTFQGKUhuodLFzW5cn0pHeMWcLZerzueknjZ+9U8JbJDGcRLy/azzj3/5i+hp+4pb+rmb8brAXLYbo8PSOINJcYVIBSOgKHdBKsDJUODmc7y159VHyqn85r5sKu4wRRmmQis7Uyh48ennDegJircodgM9rFnuKYnNf1vlt5cy/3sbpAasxvK76SLk6jq/ZyO1UxQmI/lQ934jQqUblP1OVebB3hvjUHaUzm0zqShjrJCjKuI19YagdVRLV56ZOYd57g6ReUxveqnwLhmdYVP88toUacE/UK6bFn0yWuXT9QLIyRsu12bA8yUM4z1WZK+AzmaQ0Mx2j4qjvmAPaFqgULZcEVUg5vGqEuhWNCq/sFmQOYcjEdZs5hZbPUvTLYzIeDHN30yJrU82LF4mgkTTBAWLLRlAJ5reLYfx1nI5PyRpNVUBicx+G7FmmIOg9XVhAPNmlYUHMBWYkDa9ZIIXmi6cmx32kVcXIH6gDY6G9ZRx8v9AH2M+QZHtURz+7beHe9jQFbubpqdD2LnTkAPMG4XiiDtEXPLuSAKxDJrc8TxABFYH1ui9BGJkRk79Gwhh7KCUtjC9vRNjzYHxN7a13ShBjLpGTeriMX0UmqNHIBgNF5BgZkFoe2GYb60AsDSUfafXbNidgoIsCcQSYaFBzyYJbc3UpO/bXE7nrFKQuZd0aFGvZSDMo2m0D6WZkusR9dyr6t57T9ptOVM6AVYXOsgmFltS5MdvMvaV+szYmGlMDHc+SkO4ft5sfZkIMUPpX0qLZ5n3zdQ3nRzeaCiLb1oO25iyXds2ukdwia4FpEkvS9/IQXdqejnn4PD
 fWxro5z0
 +Nc3srzG8VLsPeC1gGFBJRenloHXLUHxNgTs1h9866r3epoZrV7YpXkNrGldD+t5uZDfkexTaxr/HUA44fOasr4L6SN3Ldd4vd+LzQ1iW0tQiMlB/WzAvPnNyar55pTerRzzB9T+7gZhmkmH65MUZivCE3w99NNc09YYdoBXca1q1V7sfT15CCf8gc3dmgoHhO3XqPTlKmzdJTMK7DiD5bmX3tTM/GxWu3DTOsk3n0XY1Pk/3UoS3i0XwGKAOV0xTpiNF3ayST0luBf2fowGiosyj035jmeTTDHgiWkruhcUc8Dmrrm5hw5o6vJRITsqsBaJwHEOCDK6BTYEZpMVSYhccChYrH2+Nkn7VDr6N3OMhSY5ZoZr+TwWeE5FOffyi63hcQvx2ICXGI1/MEZMvFkh+5gQYKKy6PU6eVH6/gU3AqYY8KwihuEYJioMogH8HiqJ77Qk8NGujWjOOQZ10evI+0uNvigDvdbL4tI2tLxqYDriitxUSPZgsFzZv5ZBxKnwXeLj/yxj8ApOLSN0AA6p+pbe8e8DIWdP+RlYDOf3EqfXznwzeq4OmlYGb6fFN0wsL+sV50TR+Jjkl3foHcZW4tEh5RoZkDSOPDdS7yLrUp9i2cNSKMr5MRvIz0vjv0u3PMntPhxdczJ96el/QOwC6Yb2o6hdmDuEoInYMuKR7bjPy+vx3KpQB8AHSWV6Cc9vjBSfIkq0nkSFRYRtim0Rjn7YYx9Wf1Yz45m9iGlS3utlhhTVrbpaztCN8z/k5bo2aca4LuKDEL4MDBNi+xfmKbD8/TKjLEbR+yrWHZAAtbJbighpc2XrXz/KuUP2xhUakmv9eivExBCcL1b53QebHunsQQ4X2zNZ5JiITHgVeBxE9zkfLZiokvC6iUNn9Dt+YOJ/lyu74SajdjyUbwd7B3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Modify existing merge new/existing userland VMA tests to assert that
sticky VMA flags behave as expected.

We do so by generating every possible permutation of VMAs being
manipulated being sticky/not sticky and asserting that VMA flags with this
property retain are retained upon merge.

Link: https://lkml.kernel.org/r/5e2c7244485867befd052f8afc8188be6a4be670.1763460113.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 29bef05e6d90b6123275159b52a1e520722243cb)
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>

Cc: stable@vger.kernel.org # 6.18.x
---
 tools/testing/vma/vma.c | 89 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 79 insertions(+), 10 deletions(-)

diff --git a/tools/testing/vma/vma.c b/tools/testing/vma/vma.c
index fd37ce3b2628..be79ab2ea44b 100644
--- a/tools/testing/vma/vma.c
+++ b/tools/testing/vma/vma.c
@@ -48,6 +48,8 @@ static struct anon_vma dummy_anon_vma;
 #define ASSERT_EQ(_val1, _val2) ASSERT_TRUE((_val1) == (_val2))
 #define ASSERT_NE(_val1, _val2) ASSERT_TRUE((_val1) != (_val2))
 
+#define IS_SET(_val, _flags) ((_val & _flags) == _flags)
+
 static struct task_struct __current;
 
 struct task_struct *get_current(void)
@@ -442,7 +444,7 @@ static bool test_simple_shrink(void)
 	return true;
 }
 
-static bool test_merge_new(void)
+static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky, bool c_is_sticky)
 {
 	vm_flags_t vm_flags = VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE;
 	struct mm_struct mm = {};
@@ -470,23 +472,32 @@ static bool test_merge_new(void)
 	struct vm_area_struct *vma, *vma_a, *vma_b, *vma_c, *vma_d;
 	bool merged;
 
+	if (is_sticky)
+		vm_flags |= VM_STICKY;
+
 	/*
 	 * 0123456789abc
 	 * AA B       CC
 	 */
 	vma_a = alloc_and_link_vma(&mm, 0, 0x2000, 0, vm_flags);
 	ASSERT_NE(vma_a, NULL);
+	if (a_is_sticky)
+		vm_flags_set(vma_a, VM_STICKY);
 	/* We give each VMA a single avc so we can test anon_vma duplication. */
 	INIT_LIST_HEAD(&vma_a->anon_vma_chain);
 	list_add(&dummy_anon_vma_chain_a.same_vma, &vma_a->anon_vma_chain);
 
 	vma_b = alloc_and_link_vma(&mm, 0x3000, 0x4000, 3, vm_flags);
 	ASSERT_NE(vma_b, NULL);
+	if (b_is_sticky)
+		vm_flags_set(vma_b, VM_STICKY);
 	INIT_LIST_HEAD(&vma_b->anon_vma_chain);
 	list_add(&dummy_anon_vma_chain_b.same_vma, &vma_b->anon_vma_chain);
 
 	vma_c = alloc_and_link_vma(&mm, 0xb000, 0xc000, 0xb, vm_flags);
 	ASSERT_NE(vma_c, NULL);
+	if (c_is_sticky)
+		vm_flags_set(vma_c, VM_STICKY);
 	INIT_LIST_HEAD(&vma_c->anon_vma_chain);
 	list_add(&dummy_anon_vma_chain_c.same_vma, &vma_c->anon_vma_chain);
 
@@ -521,6 +532,8 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
+	if (is_sticky || a_is_sticky || b_is_sticky)
+		ASSERT_TRUE(IS_SET(vma->vm_flags, VM_STICKY));
 
 	/*
 	 * Merge to PREVIOUS VMA.
@@ -538,6 +551,8 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
+	if (is_sticky || a_is_sticky)
+		ASSERT_TRUE(IS_SET(vma->vm_flags, VM_STICKY));
 
 	/*
 	 * Merge to NEXT VMA.
@@ -557,6 +572,8 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
+	if (is_sticky) /* D uses is_sticky. */
+		ASSERT_TRUE(IS_SET(vma->vm_flags, VM_STICKY));
 
 	/*
 	 * Merge BOTH sides.
@@ -575,6 +592,8 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
+	if (is_sticky || a_is_sticky)
+		ASSERT_TRUE(IS_SET(vma->vm_flags, VM_STICKY));
 
 	/*
 	 * Merge to NEXT VMA.
@@ -593,6 +612,8 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
+	if (is_sticky || c_is_sticky)
+		ASSERT_TRUE(IS_SET(vma->vm_flags, VM_STICKY));
 
 	/*
 	 * Merge BOTH sides.
@@ -610,6 +631,8 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
+	if (is_sticky || a_is_sticky || c_is_sticky)
+		ASSERT_TRUE(IS_SET(vma->vm_flags, VM_STICKY));
 
 	/*
 	 * Final state.
@@ -638,6 +661,20 @@ static bool test_merge_new(void)
 	return true;
 }
 
+static bool test_merge_new(void)
+{
+	int i, j, k, l;
+
+	/* Generate every possible permutation of sticky flags. */
+	for (i = 0; i < 2; i++)
+		for (j = 0; j < 2; j++)
+			for (k = 0; k < 2; k++)
+				for (l = 0; l < 2; l++)
+					ASSERT_TRUE(__test_merge_new(i, j, k, l));
+
+	return true;
+}
+
 static bool test_vma_merge_special_flags(void)
 {
 	vm_flags_t vm_flags = VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE;
@@ -974,9 +1011,11 @@ static bool test_vma_merge_new_with_close(void)
 	return true;
 }
 
-static bool test_merge_existing(void)
+static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bool next_is_sticky)
 {
 	vm_flags_t vm_flags = VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE;
+	vm_flags_t prev_flags = vm_flags;
+	vm_flags_t next_flags = vm_flags;
 	struct mm_struct mm = {};
 	VMA_ITERATOR(vmi, &mm, 0);
 	struct vm_area_struct *vma, *vma_prev, *vma_next;
@@ -989,6 +1028,13 @@ static bool test_merge_existing(void)
 	};
 	struct anon_vma_chain avc = {};
 
+	if (prev_is_sticky)
+		prev_flags |= VM_STICKY;
+	if (middle_is_sticky)
+		vm_flags |= VM_STICKY;
+	if (next_is_sticky)
+		next_flags |= VM_STICKY;
+
 	/*
 	 * Merge right case - partial span.
 	 *
@@ -1001,7 +1047,7 @@ static bool test_merge_existing(void)
 	 */
 	vma = alloc_and_link_vma(&mm, 0x2000, 0x6000, 2, vm_flags);
 	vma->vm_ops = &vm_ops; /* This should have no impact. */
-	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x9000, 6, vm_flags);
+	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x9000, 6, next_flags);
 	vma_next->vm_ops = &vm_ops; /* This should have no impact. */
 	vmg_set_range_anon_vma(&vmg, 0x3000, 0x6000, 3, vm_flags, &dummy_anon_vma);
 	vmg.middle = vma;
@@ -1019,6 +1065,8 @@ static bool test_merge_existing(void)
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 2);
+	if (middle_is_sticky || next_is_sticky)
+		ASSERT_TRUE(IS_SET(vma_next->vm_flags, VM_STICKY));
 
 	/* Clear down and reset. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 2);
@@ -1034,7 +1082,7 @@ static bool test_merge_existing(void)
 	 *   NNNNNNN
 	 */
 	vma = alloc_and_link_vma(&mm, 0x2000, 0x6000, 2, vm_flags);
-	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x9000, 6, vm_flags);
+	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x9000, 6, next_flags);
 	vma_next->vm_ops = &vm_ops; /* This should have no impact. */
 	vmg_set_range_anon_vma(&vmg, 0x2000, 0x6000, 2, vm_flags, &dummy_anon_vma);
 	vmg.middle = vma;
@@ -1047,6 +1095,8 @@ static bool test_merge_existing(void)
 	ASSERT_EQ(vma_next->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 1);
+	if (middle_is_sticky || next_is_sticky)
+		ASSERT_TRUE(IS_SET(vma_next->vm_flags, VM_STICKY));
 
 	/* Clear down and reset. We should have deleted vma. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 1);
@@ -1061,7 +1111,7 @@ static bool test_merge_existing(void)
 	 * 0123456789
 	 * PPPPPPV
 	 */
-	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, vm_flags);
+	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, prev_flags);
 	vma_prev->vm_ops = &vm_ops; /* This should have no impact. */
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x7000, 3, vm_flags);
 	vma->vm_ops = &vm_ops; /* This should have no impact. */
@@ -1081,6 +1131,8 @@ static bool test_merge_existing(void)
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
+	if (prev_is_sticky || middle_is_sticky)
+		ASSERT_TRUE(IS_SET(vma_prev->vm_flags, VM_STICKY));
 
 	/* Clear down and reset. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 2);
@@ -1095,7 +1147,7 @@ static bool test_merge_existing(void)
 	 * 0123456789
 	 * PPPPPPP
 	 */
-	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, vm_flags);
+	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, prev_flags);
 	vma_prev->vm_ops = &vm_ops; /* This should have no impact. */
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x7000, 3, vm_flags);
 	vmg_set_range_anon_vma(&vmg, 0x3000, 0x7000, 3, vm_flags, &dummy_anon_vma);
@@ -1110,6 +1162,8 @@ static bool test_merge_existing(void)
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_EQ(mm.map_count, 1);
+	if (prev_is_sticky || middle_is_sticky)
+		ASSERT_TRUE(IS_SET(vma_prev->vm_flags, VM_STICKY));
 
 	/* Clear down and reset. We should have deleted vma. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 1);
@@ -1124,10 +1178,10 @@ static bool test_merge_existing(void)
 	 * 0123456789
 	 * PPPPPPPPPP
 	 */
-	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, vm_flags);
+	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, prev_flags);
 	vma_prev->vm_ops = &vm_ops; /* This should have no impact. */
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x7000, 3, vm_flags);
-	vma_next = alloc_and_link_vma(&mm, 0x7000, 0x9000, 7, vm_flags);
+	vma_next = alloc_and_link_vma(&mm, 0x7000, 0x9000, 7, next_flags);
 	vmg_set_range_anon_vma(&vmg, 0x3000, 0x7000, 3, vm_flags, &dummy_anon_vma);
 	vmg.prev = vma_prev;
 	vmg.middle = vma;
@@ -1140,6 +1194,8 @@ static bool test_merge_existing(void)
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_EQ(mm.map_count, 1);
+	if (prev_is_sticky || middle_is_sticky || next_is_sticky)
+		ASSERT_TRUE(IS_SET(vma_prev->vm_flags, VM_STICKY));
 
 	/* Clear down and reset. We should have deleted prev and next. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 1);
@@ -1159,9 +1215,9 @@ static bool test_merge_existing(void)
 	 * PPPVVVVVNNN
 	 */
 
-	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, vm_flags);
+	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, prev_flags);
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x8000, 3, vm_flags);
-	vma_next = alloc_and_link_vma(&mm, 0x8000, 0xa000, 8, vm_flags);
+	vma_next = alloc_and_link_vma(&mm, 0x8000, 0xa000, 8, next_flags);
 
 	vmg_set_range(&vmg, 0x4000, 0x5000, 4, vm_flags);
 	vmg.prev = vma;
@@ -1204,6 +1260,19 @@ static bool test_merge_existing(void)
 	return true;
 }
 
+static bool test_merge_existing(void)
+{
+	int i, j, k;
+
+	/* Generate every possible permutation of sticky flags. */
+	for (i = 0; i < 2; i++)
+		for (j = 0; j < 2; j++)
+			for (k = 0; k < 2; k++)
+				ASSERT_TRUE(__test_merge_existing(i, j, k));
+
+	return true;
+}
+
 static bool test_anon_vma_non_mergeable(void)
 {
 	vm_flags_t vm_flags = VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE;
-- 
2.54.0


