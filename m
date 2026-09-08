Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD68C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D116B009B; Tue,  8 Sep 2026 07:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F7A6B009D; Tue,  8 Sep 2026 07:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E346B009E; Tue,  8 Sep 2026 07:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 471366B009B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:25:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93D5C160500
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:25:06 +0000 (UTC)
X-FDA: 85190363412.27.DD40224
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C7BCC180005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:25:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MCMynEAK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788866704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7INaOtP/gm2Q0CwFqGyhMMm+FXe4/enBYyOAMoEMKqg=;
	b=kNKyhNS37tyzfnS5+22OCw3eryfg9sVAwRI2sWdnk/NLAoD4rlvyItKN81aJYSaIwlQ6bP
	kxJOF5YukKm8uKRBkqhU8OPjk//ysnciQro0G/rCy0o+Rq6yxvupSM2UljLW3wb/k3l2TR
	BeM10PwZL4NFcJMRzU+SJnzR11PcH6A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788866704;
	b=j8syJsGQUvHnmTOcZ49La6yA5EQLlWLFP08QzfSK3EAqdU9i356IPyXuKYJMbfRqXFGxKq
	ocGLlKNWV0SIJeTgeJfc7OQ4ditv4W6QPitoNqJHh8Ge1QZfCZBvwuZDN+Joch1E9tQJoG
	MnNHcRnWEmE/3RTz86Gts4LPqxaIBLQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MCMynEAK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AEF743F72;
	Tue,  8 Sep 2026 11:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AD51F00ACA;
	Tue,  8 Sep 2026 11:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788866704;
	bh=7INaOtP/gm2Q0CwFqGyhMMm+FXe4/enBYyOAMoEMKqg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MCMynEAKWBBtZhM3TavPM2jvsMzLi/wfyDztSX3NadK30N7sH/KYNxbJTPna0++4M
	 lE5/YW5SRBTlhkna4Lws5EybILgPvC0mz3bRN3o/XuXaHJSrijVmszq4RtwnMsPVBk
	 tOxdnuRIffeKcofQSiJ2BFhlxP7re6LrwYSQqSruLSMCYgIi7gSFC1fU3mWxbSwn4C
	 2U+Gg1vY0dCzE7kFhijpKTkoX/Y/4vufVgfmUDopjMu7NmDgrK2ifxh9J+NzmNpcQz
	 W22w2Kx727HvIXnbGmnxss/iKzUM2ixk4xg/yUsDdYwCClDW/MQzaRRQij+TWvnTyd
	 xTbP10Rd5uwfA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 12:23:42 +0100
Subject: [PATCH v2 5/6] tools/testing/vma: add test to assert
 MAP_PRIVATE-/dev/zero is anon
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-map-private-dev-zero-v2-5-acc7b5625305@kernel.org>
References: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
In-Reply-To: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1881; i=ljs@kernel.org;
 h=from:subject:message-id; bh=MuW0MgECKFqsgKYanDvHZ2zzAEiQ7iCtWQ9chN/jOZY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLmfyg80KuTMs9Z7srfjee93Bu2eq+dea5h49YnP6/36
 a5/o1EQ3FHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJyGQzMhzsOGP3+heLprbt
 OzWrS8qzdvEn8PpYXC9/MOmUscrVH5sY/udIy2aduTOvet7fSVJMds/c3ydt2yGZ4hOf4VAdVFu
 zjAEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C7BCC180005
X-Stat-Signature: q14swndfbpk48zh7y86nixtegxr8hbjx
X-HE-Tag: 1788866704-29858
X-HE-Meta: U2FsdGVkX18QWNGCtgA/sfMP74tGYeYq+N1IfckapMNH4P2EqSaOibSF+sbO05PHA+Rp/wc6YUCGHyO7Q8A49bqqDhv35vNzAIdcd3LZMvpnLkFzDR6eQOzA4+7X5TLYO9nA6/9CbOJXt3+a8FYLvT8oMxTpgjKTk3PIwBBt8C/FMa756Y+8ibVxIb/R1pEjOIVGUzpgt5/ijO8zk16HeThW44W1uBcF2PLVfazggK4qJRlmrrV8vGXadGsjYdJ/VT7GtpmDk71XRdng+liJf7hYEMPnbjrgJV+6gUH9MGzzUTewCWNUkY5sPnsPGOOFEEtTrECHARcRHgn9so/QapPpdcLYZt2pnfA9ncqPAEMEa8LkHbmBTzYcZJJkyK+GgNM29+pN5UgCeHeUSmwDEiCd/o8p4F48LTGkxWqn/fsLzPz6Fbw0/8OgkjlirlDVGXEFn93Lsxu4/2XPjevbE5Oaj604gm1FwJV7LgNyAoGKW5l+4ZTy4F496Dj0LjVjBlLV0DNvSTBdKJeN84PrmVIIhFfNFyhUwWPVn2s5HWhFieZ9OggUBTeIi62Njc/eudfuf3Pr6WkKBLIMkxkYgrHZYYplKC5CIvRG7jJStAxfm31p5USrCl5dR62o5qgblJNTZgdJBzD2a7OcKtgN+yyOO8yewBrnX6n5dVPwCbXVjGRJyb7aZ8Aq1IIqIlE1LHq/Deb2DkNtFmOKbSuuxKIYcasn77lje5Gfsmj/h8JYhcGhUBLdJB3yc2c7Qn0Ff7vdSfdKNusRl1J0InRI9ZOO+NSGQlCYFyQrlRemQzEE3XO3nzuteM1mjZ/nxYdSRu4BtAIKzu9fExA3aLq2OLWNt998cP8bDSVZdCFDQNz6MTJZTkh4UFhMK2o27jvNGs4oR0m5JjPQmJ2rrVxUSQwXDgo/IKQdIN3a+38ojfjGvO8n+t02b6LhvLV06bDtKkR6Jic0KCf8dIpphub
 vxofKVzg
 A2FOhFk6j7wQResILgTdoCU2ZWKnEhKTlv4ZBQugIh23b1srIWTk8kokgMUKzOs5Xj+2h072/D4fHl1ICG4kzwTV2rO3GwwfDnBG93J34b1nfEmqw6WFsALLtNOBdM9A50AdwrMjViEI0CacttAVwKRupQoLEJXbPmsUViuTFfrc5fblvq4KDuZX6qvdu7+vdYygevKbWW1thR6CYGRhcOdKYEtmdc1BoyP3INz0URYAhi+BCpPCAp380p25FJeBilClC+FwS/8uVMt5fbBv6x/yi7jTksPHf8G2W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we've made MAP_PRIVATE-mapped /dev/zero mappings truly anonymous, add a
VMA userland test to assert that this is the case and everything is as we
would expect for an anonymous mapping.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/vma/tests/mmap.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tools/testing/vma/tests/mmap.c b/tools/testing/vma/tests/mmap.c
index c85bc000d1cb..fa73faff2262 100644
--- a/tools/testing/vma/tests/mmap.c
+++ b/tools/testing/vma/tests/mmap.c
@@ -45,7 +45,44 @@ static bool test_mmap_region_basic(void)
 	return true;
 }
 
+static bool test_pure_anon_dev_zero(void)
+{
+	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT);
+	struct file file = {
+		.f_op = &zero_fops,
+	};
+	struct mm_struct mm = {};
+	struct vm_area_struct *vma;
+	unsigned long addr;
+	VMA_ITERATOR(vmi, &mm, 0);
+
+	current->mm = &mm;
+
+	/*
+	 * Map a MAP_PRIVATE-/dev/zero mapping at address 0x300000 with a page
+	 * offset of 0x10, which we expect to be reset to the anonymous page
+	 * offset.
+	 */
+	addr = __mmap_region(&file, 0x300000, 0x3000, vma_flags, 0x10, NULL);
+	ASSERT_EQ(addr, 0x300000);
+
+	/* Assert that it truly is an anonymous mapping. */
+	vma = vma_lookup(&mm, addr);
+	ASSERT_NE(vma, NULL);
+	ASSERT_TRUE(vma_is_anonymous(vma));
+	ASSERT_EQ(vma->vm_file, NULL);
+	ASSERT_EQ(vma->vm_private_data, NULL);
+	/* Expect anonymous page offsets. */
+	ASSERT_EQ(vma->vm_pgoff, 0x300);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0x300);
+
+	cleanup_mm(&mm, &vmi);
+	return true;
+}
+
 static void run_mmap_tests(int *num_tests, int *num_fail)
 {
 	TEST(mmap_region_basic);
+	TEST(pure_anon_dev_zero);
 }

-- 
2.55.0


