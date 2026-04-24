Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72595FF8851
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE5946B0099; Fri, 24 Apr 2026 17:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBDBE6B009B; Fri, 24 Apr 2026 17:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3A66B009D; Fri, 24 Apr 2026 17:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBF6D6B0099
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:13:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61562A0011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:55 +0000 (UTC)
X-FDA: 84694701630.03.B9E07D2
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 84953120010
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UjpOzN1c;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777065233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yH4D3KJ1uR7ePvwBlIBXZU5OUty06kk4V5FneHmkobs=;
	b=caPxetxJaCrDsEXhJvfbbbm8WfsCb/fZoAZyBUCXcvd5U51Onfu2WupSjN4p/FMRRIyQy/
	afgdCMSra9cJsdImrqKpw5x8wzPO7Ph09yT0d36kO1MMZ1z5r+cvTEJsJPxLXD6QNV4mcN
	MAO1DLb9LeBm8EScONFGX1HlUyYVzBA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777065233; a=rsa-sha256;
	cv=none;
	b=ns0qnVCe+H3E+Ikp9vxVBPI+AjaxWH/rwaciUE/Lj5gX6ZkHI0vaEXsjizV5WaaJaG/PCo
	Xy2F8rIa0H1HCdS/5ED0qKraJh9jhnfMQv/tS3PLb50125WNDFSU9WwVARctS+BCaqFoE9
	3w67fm4V0k3EdOv7RyCKRF0JZH8OL8w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UjpOzN1c;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so92010935e9.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777065232; x=1777670032; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yH4D3KJ1uR7ePvwBlIBXZU5OUty06kk4V5FneHmkobs=;
        b=UjpOzN1cf2o2UKnOS32Y9hk5IAEwcB/Ozdup4wRwdqhV5JfQ5n3GyugsevBxTehIp8
         RexSZjYJ9g4Lw8Z43XWs5sGd9CIlslFZmTkpRrjSIQeKqHI11Z1blPfh/y2GC/t95XGe
         tOS9FE5rEJCF8eb0k5h3NioO8aWCwP4EGEEea0Tsrw2E8IGewaAxp4NdkrLh16whgrij
         GL70fczpppu91z9y9xiu0GqgJ19AgQho8FW2cuREeUm7lHCpWZY9Is11xMeaExFItk1x
         kxzhC5ITd5HlN0AmtRk/5L8oxxnWFn3qhXuSHYKL3tLjWLIXF5ZmBPP2JYmNgj2dVola
         h8Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777065232; x=1777670032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yH4D3KJ1uR7ePvwBlIBXZU5OUty06kk4V5FneHmkobs=;
        b=IYKGFNMg9ZF2CKDzSEL74eoDVagO23oLzGe7k3le2owwaikaEmPbs229xkbHHUI0YW
         BP9TqmUFrOdo2gJ15kjI1SAKMIfU5yUXh6xeDjs5+zm8fbHPx7PPkrSY/MUolzkeiYzZ
         Utyc42BAfjSgJxxIjMMTyfvuB9+BzM3ZOT3tLHmfGZUHF0ksIadetwnxFAMPXM9xSSl7
         6CnVODQtRYZnw4kimZFEWnDEoK04wuAlvITnREsjeIBHLuSglJ4VSfkjTT6GlAoZxfQI
         XXB3SIaGPiqR/Yg3/ZJ7UsbfYbp2WULQ8QaK0SmF4w+zqZqgrz+0Tjwg69dwJrECsH1b
         aTlA==
X-Gm-Message-State: AOJu0YyPaMPXG2VAtxXXt4r+DCwmiehA2fDLpqbQFTNvjcFr26bt/PQL
	buY/qFiZ3DreyWFdq0hPDa+0Jt+qGRKkuTTxyzc3aKxnvzf0VN2eU4C2
X-Gm-Gg: AeBDieuZdOxhR2h8N8Se7W6n03Tt6NqglrRFTWSu6sVRnEiOe+ZoiIBxGcnq/Deq1e9
	MVP4AeTLl/kv3akfU1ozeLhr428k0kGQy7ktJU6sANICczyPgAvOBTJScRQ/TFm4+ZMxgSJ+OsG
	7OPdnvsla2OPDLAzJbMnu4Vh9M5GOgN2/HGGeyOBFYvt9Fh93c8QSMORQUwRd5WMXo8h/LmnUuV
	/eQgVaCs+zhFQybIjcEksnHUHkuDlExlomS4C5x95Zs9FRWErTseTfqDoaLHnVQ9r7xed3Py/yx
	CLEdq6odTiJCcZ3zmlWHMK2QXFeCSEFR0fNXlVR9sRqj7L8SVw3r3QgcOg+NtsNqsTtgz4LYDtz
	67DlYiQaSgVfR2kI3q6yFonPDfX1WY1Omqb3K7nOsl7D+Etk8pbzc+fmvb/aU9t2LrpxoSMYMxV
	6d70ExX3ZvfnnTvG4AbS/zoGGYfKsHmw==
X-Received: by 2002:a05:6000:144c:b0:43d:6a0c:9571 with SMTP id ffacd0b85a97d-43fe3dd339emr51622902f8f.11.1777065232001;
        Fri, 24 Apr 2026 14:13:52 -0700 (PDT)
Received: from fedora ([156.207.128.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1176sm63845677f8f.3.2026.04.24.14.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 14:13:51 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	avagin@gmail.com,
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
Subject: [PATCH v1 7/9] tools/testing/vma: add VMA sticky userland tests
Date: Sat, 25 Apr 2026 00:12:41 +0300
Message-ID: <20260424211315.1072123-8-elaidya225@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424211315.1072123-1-elaidya225@gmail.com>
References: <20260424211315.1072123-1-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 84953120010
X-Stat-Signature: f5yw7kcrp3xbhjp3xf9ybekm417hndmp
X-Rspam-User: 
X-HE-Tag: 1777065233-742765
X-HE-Meta: U2FsdGVkX19mXk+0NrDI40kGHkr/yChj2vEr3QSJNXbPzbXLzUkSE+XBaWB7ZjJhxbPwlLBW4+EFf/FbbPejH73AoSPDMXIgcbbpRcxLxi1F8PEeBIGuQ+P7keNNyD7fvP+idONIlOgab+q1pu6qma2C3mT/LDQ9crGfw4EHY2H74Bc0qipzdniaoHhjAwYyHlE8cg2fnaFVxwwX3pb5479NYicCcVxyuWAIa2nn6rV8OFD+mbTWfOu+294Di3Jx+ziWlyXEfevNvwe7wshzkzH3Aq/jUFvunqYGN1qCQbATaXVdXAh+Dw41FDHgTjhQEvD0MujxTmaHHaJMK6X9zdJnOqLRfY9giN4F6xObovdlwgrdaGuZLnu1W3heTtZ1ECcPlj1Ftu9P+I+yzUky0WGmCYeK/AdAw1kOFo5VWYNCx2hCGpg99cUQBM88Dcqm+YdNpCX1eSBZjJ7jBtsNlRd2r8354QunCoty/THt+UuJz1L4192fzVfQecGZUP0rxydKQYB0ZOtjlrqwJMwJl54YTKCkZciuhlnCoMquHBNni/N640CHjx4xiZ6icBB09y1cAbOdcRO5GjnSjLYZtQZc1XB7cYT/A/P6ihS/w2qsA2mgZUXdGQSsrmqSW4Pzn2nkPuBCDm/1nDF4+Ezo0LCcxrjWcsOvsjhJ0lzXusMQUFqpKpHlWWbNuZMtnzeGkBszrenXW0OxSa5ZGfp0J9anKzZNKf8v0Q1hdo4lw4ObvLUgSGlYn4fNiebYrgRN/x3wFhTYWsMlg7LXW9na9Ad6XR+M8IaPWHf7E1E9Vv82p1t01CRApjHslvMNfDJisg4K45lhbbkFkLiSAoFaYytwFdEQdOPprWQFqoiRMik0u8FgU02r7UxlrjJR5TlqoVP1IUsgaywOaLASWxsw/JDCoT1r8tAlqHTFMhOaq9LPObDJQZ8QqaduLIdRA5WCQHA7bqzIDINRuIulfes
 CXo6kmiq
 0dhcGVTvXw6fjV/xZM5jVtgWImzRWEYo8J4Q+CPSLrYlUEXqW+bc2DM3u8F2Bs5DDmUVorchNIj6V5YmBWYBpLlfItG5Zeej0cZyJ5qncDE7TfrRHQnRUMsRqj+k0QHopN8L6CXMOpoVS4gRZCg6iLVLj6SHPs0EvazEgXtnG1XTTM/xsC9f0wGXpAmUEXloy/RR8btg6WAQZw+JjZ4b4pxj3mjmw2BaBkxVtV36JTXSwN3MNQfDS6WOc7CZktjAzwSvhrrgSqwMk8AQXt+Vtdpj14To7Sq6JCcudDYKyb+9Z1fXrg7pPE5VvWp9Y2fZ+p/YWtynHu+v97T0LQsTFBzmI17OPQwfue6iD6pFA3U9mXydchRMcIhHP8RMiuIpWEqL0BEuQ3RtDgTBQ/hUBQeVBtn0UGmSsRFRG98Ldo3gn+vS4RxisMCqmz7ZoiL9qEqhgm1iUpzydxYKKYaMn/kQwajcH4Ft818KxlhNK6lyBVpEvMkagBHh3Vw4CGxQeVVSbnS68jvP/bKbIaXZibNlyjfdBV7uCmf3mo8ptUb6miNqQrmdqdkpYfl5r4tLwsj95LBSuicbGmP8xzSNOuOsUqKV9y/AbB7pV90Fagw76I9rFGWuCPXA4aJikAfwscPQuoEB6DUU6GWaAs7TgxaXW9cd6hzwMXrHNeKzWHx/5LgK8OMrqbcFhW4zbNAr+l3vK8jP5RaLLEyWr5OBsDv6LPpgostMJ7bt35C2GNQOX4RaMgrJOyyDq+7I+kNDNweMxJl5qLs6UvEgV5FxD/0xaaewP9ggpj75Pp+CEVVlXrIAM+SZWV8jDpoINn0ouiRxpOGo+A03fVr+22DqnYYXCNAW9mmluAiTpWhXuaI0Y0siaq2ZEGQX3yZu2MxX+VrInvrDHuPZwlpPo7/UoQCK/r9BVg/+P7AHSDTOafoiMjSQH4OEF4qOUHq2T+Cv+ud4/UK+Hbw5Cc78sudsgwYtu1wkZ
 yasnYguI
 aR5jelaJVJM=
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

Link: https://lkml.kernel.org/r/5e2c7244485867befd052f8afc8188be6a4be670.1763460113.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
2.53.0


