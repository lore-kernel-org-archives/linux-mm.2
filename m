Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF04606A330
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bCicIYV1
Received: by kanga.kvack.org (Postfix)
	id EF9B16B06B4; Tue, 27 Oct 2026 07:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED13A6B06B5; Tue, 27 Oct 2026 07:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E686B06B6; Tue, 27 Oct 2026 07:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA9896B06B4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:25:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2DF9409C4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:25:32 +0000 (UTC)
X-FDA: 85368175704.21.7E046DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id F39CAC0003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:25:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bCicIYV1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793100331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U3Yz6H0MBaIRh93vJ8ttjk8w2r8qCoWEwM9mVP5l9lY=;
	b=oIPgXzn8PH+1nhhc6rOXc5C+nmGsFqA+MsJ7axwCV01qDviRctV7llPqHBtFMuUJBXw0kt
	ZMSzuoImv4XiyXM0jKSRbKXB78Pcv24gBvz3Ggqb0SVSt//RyNE4PpXxvEnAvpHY645Bel
	K1lg31Td1HB2G8uqQ2jzuQF2yyDS+IY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bCicIYV1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793100331;
	b=EjYp16ObgjgLYq2RoBXxL9CALEZn4M2KSKb6xsq97D4kXQPck0ZqmnzZhJn/FfGcNPWaUz
	NloOS49eJloefMYJC3fMnKr7aC1vvNGfft5SujbYHmgaLQPvjpAdObvhvdTQ8xvlUMa+6i
	6q0zq92YMxq61uIU7df3Y8jRCfhE/mg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EAA2641E8E;
	Tue, 27 Oct 2026 11:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A019E1F01828;
	Tue, 27 Oct 2026 11:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793100329;
	bh=U3Yz6H0MBaIRh93vJ8ttjk8w2r8qCoWEwM9mVP5l9lY=;
	h=From:Date:Subject:To:Cc;
	b=bCicIYV1dNM+LwDqWYdCrKP8na9i9j7FQUeDUNpdq5dQYKjxUppB2ElkbddviJQxb
	 bhoDnxmgS5hgyG7Eg13CsJt/Q84rV6sh/DWSWiVZ8/UCrkawI/xT/9ghdbQFApiuyO
	 kAyBp+WzyG/rb7c7clq3f8V+LvP2SDBl6Bgs+AHuUnScw4kR1g4ndY1dy22XkakoGc
	 vWZj7r1frbH1W7q4J9HmtrH152HR+f0CCuzw7tGpZXTP1aaozQ7sNbAhb/tj+cWT0x
	 HBOWapJYvksvgLRsEPO7eRjzUxrrSjF7x2GF2w/Ly4DjgyKaLbY5zSPtXN9AC1Ow9c
	 Gc4uuHBxxZunA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 27 Oct 2026 11:25:20 +0000
Subject: [PATCH] mm/vma: update VMA iterator state on error in new VMA
 merge
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fix-new-merge-bug-v1-1-7023a787e6b9@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MSwqAMAwFryJZG0iDWPAq4sJPrFlYpcUPiHc3u
 BzevHkgS1LJ0BQPJDk16xYNXFnAuPQxCOpkDExcO2KPs94Y5cJVko3DEdC7kZloqmgewH57EpP
 +Ztu97wdzNV0yYwAAAA==
X-Change-ID: 20261027-fix-new-merge-bug-71c2200d40fb
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
 stable@vger.kernel.org, Li Jinyue <jinyue.li@linux.alibaba.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3975; i=ljs@kernel.org;
 h=from:subject:message-id; bh=enOY1tlL9CmXRwkEJ9MaAJA03UHuIoy8wDncUU+/XGU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIedKmus5wfVc/+rk1RZ2KZ9tLrZzXWukkEtU9IE7nzr
 qdRNTKxo5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABMx3MTIcLn9u6CxqhFfyS1d
 W1ZT17zCY1MNmRxDmg4preDbkLe/nZHhv9Vy761f0x99eB5u+/3mx9+y01Wv2r2ZOl3HPaNad4M
 pAwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F39CAC0003
X-Stat-Signature: qrsoz8ryjbhreg3666tmoy5u9yxox1b5
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793100330-943568
X-HE-Meta: U2FsdGVkX1+f8iYWHJrA1RIgxyHa6Ggtkz8U+SckctiqetPNkqD2FucXest1DIt89BchkcLGOnn3FJ4nuJ6aKJfC8gL72dNE2Q+w2UvaeMAesIl5cHDnQtgPIHBWtc4NZoA1paTwr77Gsb36BirR8b57/68IMmkBWHU6to6felLNnWyPk41dh3zyKJvdQtEbPuoqWB4bG73FINAv24XL2zN9PDggWxmRodllyx0J6xYjtJGP59p2vTIpWv5xgZRuBI3bK9ix1TukfINfEkDLKwXMQ8jTl0QqFRr8nyrIO7TlIUqu4NKGRLD91OhWAJuTanlxa4N5cxGHI+rESog2CPPfpwbsIkKQHTQbUhUG0Qw8CzSySkmVwu7nO99TLFhn+OtjVBKEwcTJK8zckk4ArZQJzidU3uW2u3TXGk7uKQWMHqqf1MjGEzIZMuzCDODQTR8seQ93cAxLsvGBA8c7uJPP7MQ1bG3uWi8jom3/DBFTxCak3GXug1edhrQ0GaccufouC2sAy69qcXPDLoLnrOVWftTAeyC4m+8WVht4fsXCcqhtsFl+sO2y5955b7SArqhatqqTB6DBccMzojHkM6wLO+gx/VZZakg6cmVWh0c/V81wZwgVeORJsevzTwEFykUMiPix/SIL4ZyTwmQ2FoLdGjatH782bWBOECN+aWdsNjJTlQn8k1zDShzpfAMlhhFyYFLUq7UeF0PrEw1NHRAef1EojD7Rol/DSn6TrBl0F2cJi76dv+1k9aJ0uC2MkcwFZXf7UdD6Uef1RLHRwQRJ4nSZJn0nvCbNqj5RcpL3tlD85/+1LIcEGmuyMimSKSEYJhjzzX+NnCLL2mxIvnqHJy4zxhOJ2GDYtdEyHBRRoipSthRA6RBMKPFjjDJfe/XIw2Hd50XDAi2cja0WEgK1Ll86U0W7GKD8M+Feyn4iD6ep3mgsbD9AoTA2uI7ngNMJX/0/+qx0RtT0heZ
 QmB9d+fO
 orrw/r8FCKmn5gFBzQzitnmXwnyfTCIzIRCfX7txV1EYNL6/zcfGzLoxG4t8g03i+vCwmPQqvo1G+WHNVpnV04bEGdRe1y7ltm09mTR8OwTqOrICSj9TZSefbB0/yZBqZoFknQBWpWgR+h/sJAn3BAHXAEq4i1sohu+UN/WwNOGQ97eZJs6Es+V3pzG2gELiTsoCrLrmjs+zPZYLVBpEFaTv2wZfYNikG9SKK5aARNcUwL67wlb4fgkoQcy2IIEjEaDTrVgum/2jgqyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit cacded5e42b9 ("mm: avoid using vma_merge() for new VMAs") shared
code between vma_merge_new_range() and vma_expand().

However in doing so, it failed to correctly restore the VMA iterator when
vma_expand() errors out.

This is a problem when the immediately preceding VMA is mergeable and
vmg->just_expand isn't specified, at which point the VMA iterator is moved
to the previous VMA.

(Note that vmg->just_expand is a special case for brk(), where the
iterator will already be positioned at the VMA to be expanded.)

Resolve things by restoring the VMA iterator on error. Use
vma_iter_next_range() to do this, so it will correctly stop on the gap
after the previous VMA, rather than skip to the next VMA after it (this is
a new VMA merge, so is being applied at a gap).

To isolate the error handling, return early when a merge isn't
possible (what the vmg->target check was doing before), then handle the
merge success/failure case explicitly.

While here, update vma_expand() to jump to the nomem case when
dup_anon_vma() fails, so vmg->state is correctly updated.

This doesn't impact anything in practice, but is the correct course and
since it's part of the error path that this patch addresses, it makes sense
to update it also.

Users are very unlikely to have observed the issue this patch addresses in
practice, as it is near-impossible to fail an allocation for an anon_vma,
but a process under memory pressure that receives a fatal signal could
trigger it.

This issue was originally reported by Li Jinyue for which I am grateful. He
indicated this was uncovered by a private syzkaller instance.

Fixes: cacded5e42b9 ("mm: avoid using vma_merge() for new VMAs")
Cc: stable@vger.kernel.org
Reported-by: Li Jinyue <jinyue.li@linux.alibaba.com>
Closes: https://lore.kernel.org/all/20261025093921.1011927-1-jinyue.li@linux.alibaba.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index af8e65ada23b..d416ba58eb4c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1141,6 +1141,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 	struct vm_area_struct *next = vmg->next;
 	unsigned long end = vmg->end;
 	bool can_merge_left, can_merge_right;
+	bool move_iter_back = false;
 
 	mmap_assert_write_locked(vmg->mm);
 	VM_WARN_ON_VMG(vmg->middle, vmg);
@@ -1182,23 +1183,30 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 			vmg->end = end;
 
 		/* In expand-only case we are already positioned at prev. */
-		if (!vmg->just_expand) {
-			/* Equivalent to going to the previous range. */
-			vma_prev(vmg->vmi);
-		}
+		if (!vmg->just_expand)
+			move_iter_back = true;
 	}
 
+	if (!can_merge_left && !can_merge_right)
+		return NULL;
+
+	if (move_iter_back)
+		vma_prev(vmg->vmi);
+
 	/*
 	 * Now try to expand adjacent VMA(s). This takes care of removing the
 	 * following VMA if we have VMAs on both sides.
 	 */
-	if (vmg->target && !vma_expand(vmg)) {
-		khugepaged_enter_vma(vmg->target, vmg->vm_flags);
-		vmg->state = VMA_MERGE_SUCCESS;
-		return vmg->target;
+	if (vma_expand(vmg)) {
+		/* Error occurred, restore iterator. */
+		if (move_iter_back)
+			vma_iter_next_range(vmg->vmi);
+		return NULL;
 	}
 
-	return NULL;
+	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
+	vmg->state = VMA_MERGE_SUCCESS;
+	return vmg->target;
 }
 
 /*
@@ -1288,7 +1296,7 @@ int vma_expand(struct vma_merge_struct *vmg)
 	if (!ret && vmg->copied_from)
 		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
 	if (ret)
-		return ret;
+		goto nomem;
 
 	if (remove_next) {
 		vma_start_write(next);

---
base-commit: 1eb36316305767b54fac2cd40b88b3499791bdf2
change-id: 20261027-fix-new-merge-bug-71c2200d40fb

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


