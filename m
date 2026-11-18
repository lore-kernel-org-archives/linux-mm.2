Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89940606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=EdNgB13D
Received: by kanga.kvack.org (Postfix)
	id B9B866B05BD; Wed, 18 Nov 2026 12:01:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4DF66B05BE; Wed, 18 Nov 2026 12:01:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3C256B05BF; Wed, 18 Nov 2026 12:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 769376B05BD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:01:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2249407F8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:01:06 +0000 (UTC)
X-FDA: 85448854932.14.041AF42
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id C73B81C0021
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:01:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=EdNgB13D;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B5F2bDKqWiux+azJSVD944tOanf4YlpNfsvAbWQD5XM=;
	b=EV2npF3Fv+nFifPiw5fDuSpM12GdmOhMP+QTwyAym+NglgLloyc6aRJppuY0CeHdR0gh56
	eX+LDudUyouzTM9oGW9PkbDVOiYojy3OpwAxpcB2+B/w2f1qeCoivIP2qci4HDRE3MHAjy
	ub0oCGcvB6xuwy8sVyPXFJ7CbX9F2oo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=EdNgB13D;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795021264;
	b=pfehwByBKpWhFr8rfcom9rrXihl/CraGq/AflHG/nUo9JU/VHyxxYnOM3UxyK4RPseqCi6
	dZrnojFKGXSrCxI9C90AnKIUNra+76Mhz+H6CAcjAQL6fbKQttQA03CtCshe+sPdY9Sczw
	KKfUds3fW0If/OxY8RamwxJadYEvISM=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91ebf4cd218so4940556d6.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795021264; x=1795626064; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B5F2bDKqWiux+azJSVD944tOanf4YlpNfsvAbWQD5XM=;
        b=EdNgB13Dj+iuZnpPpbykP5MrpPNjq97OjVOqdJujiiUF7rSFZqorgDMg0HC3qyRg0Z
         gymMyKWU1kXp8j4bZXyQDdGVxP2XRFI6nuV2+OIPgjytctTJpzrO4uwDayIMCHJn4GRF
         XW3jUdJmRRiWmDhx5j7/K2h5dP9MinslZgL/nCY/7chVMnIa6z6TA8/QtXAeTvH9lBe/
         ERha4iLCvfZjPfMyutIRjA0MtX2NZlG1ipyoaq4JbAmZrQbF3UH/zWDZ8mtB9qgRP08j
         A7MxP5nCfJf+IsAKRhHoMJQdA6VX0SfsZ455T1IWPIk080A6CG/Zbz4wlhDg2otGpUQ7
         C27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021264; x=1795626064;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B5F2bDKqWiux+azJSVD944tOanf4YlpNfsvAbWQD5XM=;
        b=sauJ4GvIp+LCHSxH/oCUFLtcQwRz4F0KCDBr5NAa5FJwl1bxOotX24c9urWp0f8gNR
         3+24c5jsdvLATewhUbrbm/Jdtxjz8EuH3UWzojR5kNEirvpwtsDFg387KL/ENo5OHzMV
         NeRHAIGOISxTQv8BqRDidIm+ptJDKnF9Cd440CP2xTA8vwzB1KJucBQwSlRM9FAxLOW5
         b+IoVWKFkiifkXQA+p9WN9DhblVDhTpBDRREMnbOgsT7FpOy0SaHrKT/LxlGRru4Gg6b
         asKWIZ2C1wzIkPMrSxYhjjFkGysB1+N6WkB3Io2Wc9Quj5vUOlUGzX6nimrPtHI1tdRw
         cBnA==
X-Forwarded-Encrypted: i=1; AL+hErF3CRxBE/R382PqXB56PYVPZCBGKOzxerVIbBW3zDavDfv4sbjR3Byhlfm3Aaa00fDAznNPS1GQJA==@kvack.org
X-Gm-Message-State: APuU4Z+aa3l2RPl+TYsQWSsmMLSkwmZFzaFVGBdaawaISBO5UgcPTPbH
	S8CNsJPSQ3svmxvbFxuVFqoPLm8/SIuyaTY6q82pA7WOhKo4aJvNs+jvGq0oBwqz+7o=
X-Gm-Gg: AZFdTZdnSUydhDBtUCfG4uS5Jc93uk7UgVzJUks2PN2juhkLrbV3AlId08iV7ekPdcu
	jpqLf0BrWi9aiH6hAMx6wZIAiwBN1u14wTWVIen3XNWYax25MkoS+c63xQT57Er/o84LfWVnsjY
	9qO3PFtH7ODZN+YbMS7Pea7MJoEOtBemzzFoYDgzwMQmvSd9T6naAfNsS1RO5CEqDnABs1hBUZI
	ZBN0u47moIJEMFersN1bPep7OKtFgax9b7hzxCrU1iv78TRpth4UHheEnyz5OE+LwghrH9Ny3Gi
	gIyKcmFWpdwh2PyyfjDOZHjgkOjfo+baUR7OKwISE2RzgcvXyIT71kW4tRj0bLKWQuHekPPP/D8
	mIniiXL/kPtIbwPenTRBQhCcrAkfjopeYYyRyJL9vssZx1pedPpC7cbp2KNLcgmj7N1vj+lvG5L
	gfaHDXXfWHTq0Qrn0nZoOyNz9+HvnUby7owX3AfoA3+SHZJdjsIwOz+RGLHO3KxLYhiqGMf3bOD
	0rFpzcVebLS2ZkUi4ewHiGHX+SJX+0dXJvOfixBoa0xYHWJLUGCQhqJPDtMQIvESUlKmhloelTH
	6tV422+0Fb17A5KsZR91/rmjldvecoGZSVNK+2feTyf/yw==
X-Received: by 2002:a05:6214:5d88:b0:920:fd9e:f141 with SMTP id 6a1803df08f44-92114ea60b3mr43050156d6.46.1795021261259;
        Wed, 18 Nov 2026 09:01:01 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.249])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92114d5fc8csm26302856d6.27.2026.11.18.09.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:01:00 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 18 Nov 2026 17:00:39 +0000
Subject: [PATCH RFC 7/7] tools/testing/vma: test a failing vm_ops->open()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-b4-vma-open-fail-v1-7-c8b0209f2700@toxicpanda.com>
References: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
In-Reply-To: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795021242; l=3477;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=FkscArGKPLBYOjy2qlvxmc/uyX1siFCpjkS6HtWuzyo=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QAAwQQhWRvU/3KMDT4h0C4luJnD6i6XuMnBCaBECPP3+XP2KWtnCOp+kYudRXVIKcPWqRbzyxnZ
 Fd/PNW0iG1Q4=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Queue-Id: C73B81C0021
X-Stat-Signature: kf3rnpg4zgwwg1snny9r5q6kn34s3689
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795021264-301783
X-HE-Meta: U2FsdGVkX1+eBdBmW9kJ3odPKMOMRPqdFboeDi1ZH9+grw1nb1wyHdUws7ar0x/+gOBjhOtiCV1qeRL4daGxiOccMLmLzP4kTYF6PdGBeJ1slzyK5fzcQJbueQYxayfzSpsz5KZfZUXj5uw2IKx2RYlR/DU1/uJJd8gf5hamncdginH5NnNCEEj+xEiy6NuDjM7pAm8vPMeBHuNk6w72TelcO75F/9y2GMwrKHKMEHWS5svOjXCCVD6vdr2pjd0xmXFkPw6MsBTVfLbJJkuVk2J4JZaVks6TptQ6xmzJprZMRg3syAtWYbNty6wz7NFP8+uKPPw79IKbWs2qaNxuWz/fkUZ2Dz9Tx/Z8BV21F3ruWwv1L+8S2X3z45UPB1+uNMLm9CqfpdSLE9R/eIwTFqK04kdQ7fGud26SnSgrSwPFdN76JgsN/PiTKgAsDxftF7AyLsgEQdCrCsAc++jUI7O6/4vXt2VWKEJhykQ94zFVtrsW3vXCnSQn/3TwhVwAwZZWWWt8ARa4JuYS4Gues0f6HW9ud5sSjNq2ZDHkkpRLYJ7GrknnQmxZeyijJPvZgkjrM8Px86sxxM67RNndDJobxT9F2QtS09pCdYoLbz+B/OFC5z81v1i9F97aiSMfH9rnIClLaagiSwHWz/TOy2hHGm5H6Jnmic/dUfiA6/421OfY1IeQyDJJI/MD7ptzDccI/EDnLOFU4lFN3GQ0se+qnUZIqFvNpHWIt8UFADz9eTRk2Z048ScGTeWL+yi6m4fnV+YcOzqELzRn7+AXxPXDQBS2kFNpmByyw3ZR/yOXX5Y0Pkpb78IqhqLCEG2Ffsh6JN1dktnEl8wxx8/RxCjh7RHviGt9iPKFJi4WYROptE9FEexQyulB/FfPtMbdBYoHKcRAwPay2IYl4tYevHft4bGUigM4RRPVDAWSZQtdpG+lf9LJLrQRk5GL+A2At0oiPgG54uDykUtqvBd
 jphwOlA4
 RdbbHZJhyMAoHD0tIxlzH43JiETL7DBaPQ0QCCcIKtIrZyXxzMwo3Ryb6mcJNJkgFITXCalbLqOSsRjkYH+j59QfD5f6vvFz3uBGarXWwnpVFxQvdgyULDQ3lLiZzfyMLs5uL9ZPxOxg8tPj12w2mqADh+uZ/bJeTPNZSC/xCPEnqsNB0XqUaAZBqQ9kclX9O4GHKX37EYN3L7S1/yzGfTNELJiLpnBm77j1rfjiYN4k5P0Q2DQmK2Q85JRpDq6s3XarmwvlNwB54a4hGlKyliKGqzWGYK6q6rpXSLh++89N0UeD9NMRzj2ZTPYRApcRSQq9eo2/car1l8SHnt36zY5Hx7kqpJzMhVpfZMod3dJ8JH6l/4TKq0+Mpjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nothing in the VMA tests has a vm_ops->open() that fails.  Check that a
split and copy_vma() fail cleanly when it does: the callback ran once, the
clone of the anon_vma was undone, and the original VMA is as it was with
nothing new in the tree.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 tools/testing/vma/tests/merge.c | 81 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index b26f1a66a170..027ceedb447d 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -248,6 +248,85 @@ static bool test_simple_shrink(void)
 	return true;
 }
 
+static int failing_open_calls;
+
+static int failing_open(struct vm_area_struct *vma)
+{
+	failing_open_calls++;
+	return -ENOMEM;
+}
+
+static const struct vm_operations_struct failing_open_ops = {
+	.open = failing_open,
+};
+
+static bool test_split_open_fails(void)
+{
+	vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_MAYREAD_BIT,
+					     VMA_MAYWRITE_BIT);
+	struct mm_struct mm = {};
+	struct vm_area_struct *vma = alloc_vma(&mm, 0, 0x3000, 0, vma_flags);
+	VMA_ITERATOR(vmi, &mm, 0x1000);
+
+	vma->vm_ops = &failing_open_ops;
+	vma->anon_vma = &dummy_anon_vma;
+	failing_open_calls = 0;
+	reset_dummy_anon_vma();
+	ASSERT_FALSE(attach_vma(&mm, vma));
+
+	ASSERT_EQ(__split_vma(&vmi, vma, 0x1000, 0), -ENOMEM);
+
+	/* It failed in vm_ops->open() and undid the clone of the anon_vma. */
+	ASSERT_EQ(failing_open_calls, 1);
+	ASSERT_TRUE(dummy_anon_vma.was_cloned);
+	ASSERT_TRUE(dummy_anon_vma.was_unlinked);
+
+	/* The VMA is as it was and there's nothing else in the tree. */
+	ASSERT_EQ(vma->vm_start, 0);
+	ASSERT_EQ(vma->vm_end, 0x3000);
+	vma_iter_set(&vmi, 0);
+	ASSERT_EQ(vma_next(&vmi), vma);
+	ASSERT_EQ(vma_next(&vmi), NULL);
+
+	detach_free_vma(vma);
+	mtree_destroy(&mm.mm_mt);
+
+	return true;
+}
+
+static bool test_copy_vma_open_fails(void)
+{
+	vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_MAYREAD_BIT,
+					     VMA_MAYWRITE_BIT);
+	struct mm_struct mm = {};
+	struct vm_area_struct *vma = alloc_vma(&mm, 0, 0x1000, 0, vma_flags);
+	struct vm_area_struct *src = vma;
+	VMA_ITERATOR(vmi, &mm, 0);
+	bool need_locks = false;
+
+	vma->vm_ops = &failing_open_ops;
+	vma->anon_vma = &dummy_anon_vma;
+	failing_open_calls = 0;
+	reset_dummy_anon_vma();
+	ASSERT_FALSE(attach_vma(&mm, vma));
+
+	ASSERT_EQ(copy_vma(&src, 0x10000, 0x1000, 0x10, 0x10, &need_locks, false), NULL);
+
+	/* It failed in vm_ops->open() and undid the clone of the anon_vma. */
+	ASSERT_EQ(failing_open_calls, 1);
+	ASSERT_TRUE(dummy_anon_vma.was_cloned);
+	ASSERT_TRUE(dummy_anon_vma.was_unlinked);
+
+	/* Only the source VMA is in the tree. */
+	ASSERT_EQ(vma_next(&vmi), vma);
+	ASSERT_EQ(vma_next(&vmi), NULL);
+
+	detach_free_vma(vma);
+	mtree_destroy(&mm.mm_mt);
+
+	return true;
+}
+
 static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky, bool c_is_sticky)
 {
 	vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
@@ -1495,6 +1574,8 @@ static void run_merge_tests(int *num_tests, int *num_fail)
 	TEST(simple_modify);
 	TEST(simple_expand);
 	TEST(simple_shrink);
+	TEST(split_open_fails);
+	TEST(copy_vma_open_fails);
 
 	TEST(merge_new);
 	TEST(vma_merge_special_flags);

-- 
2.55.0


