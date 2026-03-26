Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86B3310AB82B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9786B00D3; Thu, 26 Mar 2026 18:25:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AAAB6B00D5; Thu, 26 Mar 2026 18:25:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 672E36B00D6; Thu, 26 Mar 2026 18:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 516D86B00D3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25186C4626
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:35 +0000 (UTC)
X-FDA: 84589647030.17.561E90D
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 53DAAA000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Fw2P5sG7;
	spf=pass (imf15.hostedemail.com: domain of 3W7LFaQsKCCwIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3W7LFaQsKCCwIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OM6bcucdXi/Ue6i8Gkw8+ejbHTWQvbY6+osZOGX6pUs=;
	b=oN2sWa4Hp6wPg2L5T4cCORiLFtC2cBU7VviZ4mwrpdfOILYYC00ORUFWQ53WZ8SCV1254e
	YQLDpg9/DlaaijYn8lMdDGaGHjaSGhIMPfLF+h7JmX83oER+YLAKLRkDj/WgD/AaGgs2zT
	GipC4eMazl19QhWo5FSfXnsBoC14idg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Fw2P5sG7;
	spf=pass (imf15.hostedemail.com: domain of 3W7LFaQsKCCwIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3W7LFaQsKCCwIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563933; a=rsa-sha256;
	cv=none;
	b=lINSuNtdg5rTm8rk42vyAY3QYc6RwkHlOGb4aNQ9n/r4sZDkGu3Zo4uVCANG20ibdd8h3A
	9V/wWOOlfEGtQ7PTtBuAmLfUXj4BAr1I3QVYEBX0CMXgsGlOXlRBCfTYp9w5o+vtxd3Ts4
	HOjBuRPJUT/yMGmHbgj7Yk2JAW5Q0eQ=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso1827380a91.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563932; x=1775168732; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OM6bcucdXi/Ue6i8Gkw8+ejbHTWQvbY6+osZOGX6pUs=;
        b=Fw2P5sG7ctC5dWiZs+OBCoyWb11bTs+Z5cmEAXDwyPSCLWXzl2hFIuQJ26AWn5lEej
         D+XqoMr9yN6rioKNyDzh1dAMuvtOfw3lTL+EXNCKP23RjUxHJjwjeYlkAvF8oU9yjlW9
         GQJFoG+27oXlxruLggWHe+lyFci/biMc8AXyTTKFChwGOUF3Rpf7BiNe9qV49YlgfKVA
         qZvLo11lq7FtI2CCp+oxvKv4PpjpERr7MwTP+6cS4lx2i7caziOc6+KDFRnxbo59krH8
         olv4wA4rbIFKiOgDzScALUgR7GjL8whLLP54TgCfYbkwltY1bbkh7RRmYARqivi/ZesZ
         7XIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563932; x=1775168732;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OM6bcucdXi/Ue6i8Gkw8+ejbHTWQvbY6+osZOGX6pUs=;
        b=YanQUAbSvDVDqEFZRGba33WfObQ3yuYpDm+DoYC+iPMADs5Uy88lER4Goou/THVzik
         KVgkmjRkhEI5oO6WR+A9CTdFGVGt8T2SZBuWMyd6MWaeCEH2RxmTWpcGWMXyFiw+hLJq
         SnK+Np2uC2uTU/v3/S2I6hIEUAJkcwJIy6hAdbsKTrfRDzpd5J9U8G57RGKlV2xntlpr
         0MYGQR1IFAgwTffj8d/z5S+6q+04Fz7FGxbehV46iHuW0Wjm0SgA97WFAir12O3B+79w
         6e0FsPopFq0gVFeWh4K8V0IdKUzkrmk2VzRqm7nwg3/OeexC40A7mSS1e5WOLSIcozL6
         UjTw==
X-Forwarded-Encrypted: i=1; AJvYcCWPJ+2U9sX4z4yWPXj5C8XdoFhLaSZWz4PddiJVRHN1ZoAfvWQVOhtXJmgTzk5gk9zHVVTgiK3nbg==@kvack.org
X-Gm-Message-State: AOJu0YyIXwCUMYRa2RtXdIT84jmeIwxuuStybrahHH/iX2oq2O/Op4pr
	x5TTm8oCXSGzfSFZ6ShaX9O1M9sgXJDXCwv0xUe+1QP6YnyIDW6R9vebva58tSV0QrkPXUYVgLg
	Pm32Aukghq3nj6VZbKB6mdaruLQ==
X-Received: from pjvg12.prod.google.com ([2002:a17:90a:db0c:b0:35b:963b:d15c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:164a:b0:359:f2e1:5906 with SMTP id 98e67ed59e1d1-35c2ffb6610mr255604a91.4.1774563931699;
 Thu, 26 Mar 2026 15:25:31 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:42 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=1295;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=2ZYGthoKRbcvONZFk1cPKbY2ke749z4V+HjyMMraW/E=; b=VuHoCdb1cXqd/SymNBIuKfRDMf7jBA8kvor2Rc5njfBTsWjLGscdR6iz+qugvp9JbPMpMjCNe
 rHxLUQdCHQNAA95+Me/U0IMElwV2qBwPhOOGr5EKNAKqarJ2Dw0SRzt
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-33-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 33/44] KVM: selftests: Test that conversion to private
 does not support ZERO
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 53DAAA000F
X-Stat-Signature: 8uw9jxoi81jb359methbg8o7igfp9ti6
X-Rspam-User: 
X-HE-Tag: 1774563933-24467
X-HE-Meta: U2FsdGVkX19AOQMabdryI1Hphpdk3479DzxNwYSJkpQlzmO5cPXEjwaSMP4Q39W1dqyTGxc+PkilYBY3FWA8XPbinyIyBwWVk0vwSYMttHb0jOF7f8SzcrPJ6joQ4ZVGPVwvjNdeXVZtNIgfRA8zpH2mP4TPtO5RgVjgdIqx2r/Wn7ESBdb4bfVunBFo/6qrqaWU0tIRv9w1GCLYaVJznB9gRsvshDGyGjrv+o1y5coXtzbFfOivylTccVDE32BCBwH+NAjU120MqFAXeSaMeq3SJ7bcAX1RVX9fi7q2mPybP4MXevP7F5RoJyhQh3Co8oYkJOzN0zJm7BX5Z9BM2pWcwd8h4VrISJ7Ld35THvlQj3yI9weI4FFkOsKhGQ2Syd3BbECVswVcXatCVA23iKVGuJ7LKk/iAE1LCcCfzu2EuSHOVhFNj05VHgxk1ntTGTNHsyQ3kFZY7WqOyGKcL5K4NjGNv2HLysH/i6//jc4MkdNbrbAm0Ygi/j1hlO0wq1lVggJdruN4x6E5n6dAzLC0LS5RGVlxr16sW0jqPz0BmJO/b0iGkwvm3qSxQBlGjNI2GecyxCgEyVJEfk3JqFbKHX3znCqGrN7KESIps5F0clfJBCugmyyaVRs4AfvkoETtZcOOkhXOaMVQmVswLi/RgLbtHtLQdvu7BahMfnKmwRxdgcGYuCZC/mWKmzimoTjY7buegT6IglarfsDemGPPjxxQTG9OouIrPz7c9HVhKEBlUEPxuFvQKxJStIIzGEeyKHGjVXRj3gijSfVcjA/gi5my0JzRkWXEOaZMBsC0m4qsL7Xy3sSOU7+Svg0yui2C0fYvWa9NjvuIM7pA49ZDpt4MozTErzfjfzcM7vz0504RUswod6e2CT5uih9I5yYG0Spm5GAmBufF+QKx42r0471QutI8z6jHZgDwofDiyTMHqGCNtdCCKzcphGQgXDJP7lddpLexqHcwrhy
 S0v/3WP/
 tpp4PlANx4uOnLj6f+NksqUNCykRv6DEpWdllNUz33WeQTejfvbxS03X52A497NMrs1BwhZLhyikTjdS48eE1fKpsr2O8XeaCwwQO2Uwgykx9QWbNgLC6Xw+xk6hDelBd55J0T2HgZEKy5FVHIw6OBffNnYJzwSUBMJxglxQpMlbzLl+TJPZ345YNW2Xlrxw74D2PuKuV0c7g2N4bnl7q72d2sy1wnb3ccRLMwuA50x00nSCe8tBRviJMMXBDMd03C6E63lmWowfn2XZAJD2P+9j1svxkqWeQNPTW4CsbDJ0m+Tw1fQX2dOvX42R85EbAKWyjhrArit2I8niaJwefn/+m+1Unv0AAryx9R7wdKfc0Mm6g+j8q7QJo0q2Rd4Glp5JwbTSBdluCM2a8oLfjqymGaRbDQK4i/F0n51G50GNMCs8Xw0i3U895xCDIAqSa3pORNxRHOijrJnkTkDzI69OJlYSV2cxBCwfyF+q20Z0YK4ewiXml5Qfdet37sjSGYsiU6amLQzPn48g2Fq2BPJoGytH2XS54WCNX/gp+2X+3nIoQLE9SQSLf18c43xSRcLLi8mqBkVahXtsMJwVU+J6ZNCvNLVwpi5nMouhhijABWhCe7odGg2tDONLp1wuZ1QfQWFfu51r6pjjs9VMsER0O8x8+ic8tW5bt/1Cg/RMHyiOJsNLuc3cgvamOgrM1p/le
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test that conversion to private specifying the
KVM_SET_MEMORY_ATTRIBUTES2_ZERO flag returns -1 and sets errno to
EOPNOTSUPP.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../testing/selftests/kvm/guest_memfd_conversions_test.c  | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 4ccd3d515bb26..c0abc69f15332 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -488,6 +488,21 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(elevated_refcount, 4)
 	}
 }
 
+GMEM_CONVERSION_TEST_INIT_SHARED(convert_to_private_does_not_support_zero)
+{
+	const loff_t start_offset = 0;
+	loff_t error_offset = -1ul;
+	int ret;
+
+	ret = __gmem_set_private(t->gmem_fd, start_offset, nr_pages * page_size,
+				 &error_offset,
+				 KVM_SET_MEMORY_ATTRIBUTES2_ZERO);
+
+	TEST_ASSERT_EQ(ret, -1);
+	TEST_ASSERT_EQ(errno, EOPNOTSUPP);
+	TEST_ASSERT_EQ(error_offset, start_offset);
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.53.0.1018.g2bb0e51243-goog


