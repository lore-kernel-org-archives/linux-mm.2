Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FEFEC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34D126B0098; Thu, 10 Sep 2026 19:47:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282D46B0099; Thu, 10 Sep 2026 19:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FB726B009B; Thu, 10 Sep 2026 19:47:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C36B26B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:47:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66863C0666
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:52 +0000 (UTC)
X-FDA: 85199492784.05.DEFA3B9
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf17.hostedemail.com (Postfix) with ESMTP id B0E1840003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JbgFE9mM;
	spf=pass (imf17.hostedemail.com: domain of 3pUGjagYKCBIAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3pUGjagYKCBIAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084070;
	b=tsH8vgkq9gLMTCNxcD5sSz6GGgkW4TnS7QvN6+hIJbuT6lSoF7DIj2Ni1dOrdWAipkwNgy
	X1ayBarseZh5f0HewCTEBLsj6arlCJY8cABu5OOlqph13wXg4N+t88GbfiRoff8/IZPmYc
	NWBwyqilf3Kv6Y7La5ICog7XL9scxjo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JbgFE9mM;
	spf=pass (imf17.hostedemail.com: domain of 3pUGjagYKCBIAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3pUGjagYKCBIAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GmwxGnSxtyc3MMcZyUdMtOHBijNkoyl6C3OnmMdL/s=;
	b=yylbwEN5F5YGiZr+9p8CABu2zjIpo1yP9NZ8KNMdwUyKSQPf/WaGiThTFPVjy5WikrcYPN
	CWUK4j6mQP0KIb95x7oRYwHErA+Mr/wxDcAOf7im1eVK7f+EwhwyoIaa3CMSGPcxb3gB4o
	nLThse45wn9uoP2JV8eJPM1UJXcmPvM=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39512608fb1so671631a91.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789084069; x=1789688869; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9GmwxGnSxtyc3MMcZyUdMtOHBijNkoyl6C3OnmMdL/s=;
        b=JbgFE9mMyXqwCUBQuwCGovfVWKQ3xSMgYkiE0+JxxZrEyPfQxcBpDCRDN2JHGptL6y
         gNDj/DlBABcaa64lE2k1Vv31uzO6Joo8toq5heH2LQYvMZrHVwyOpMWk2sery1RLBodW
         zEbIW6znOBfb/KnMjRs6dqV0ETkTwMjx77f9f3ODeoDsWPHDB8mvyyBs9LKdlaEd5qZI
         KCcbhxs8Tqb6BjI2df7bquoSQMa8iZwwDKbVJ7lrUYrtl0NbLry2Ia2pzELp6l3TWFKe
         sWzQnh4A0DHIrg5aT8muUH40skyMprWKMoYwGn4Pqh6j8lATL7oTl4SAO8QyCVY1UZG/
         /HAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789084069; x=1789688869;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9GmwxGnSxtyc3MMcZyUdMtOHBijNkoyl6C3OnmMdL/s=;
        b=FFBwgwWtpJaJZ0/JJfcJe8cXiA6SFw8Y5ykzsAEm59Bai2zV/5i83MS1enNdXuJ7Nj
         LnVRGXj8P/PBMVjCnK7zCpcqwg4EKRfQPeTbqcrbNkRyUKveRTQKloktnk8Ojlyzn79P
         m5QPamkLjzkIYfYSkNfLz6lJCuWhCODc/hJttWMda6XIywT8mQPNrP1WEGmIJlcB3wFK
         /rK/uh1tRfAfpP0ebuuxZbScQ58a2lt0TCcG99/3OdSRwSm8Q+As4abRLMe6exJCnI0/
         wSAOgmhSxBu61MTE9fpW4X/r8tgfs8Yizmz2iyuaT70FgCR9/u2PxfskxqEPjOUfQMo2
         pGWw==
X-Forwarded-Encrypted: i=1; AKwUvBxyEjavP244sOFDxsBG+WAxwDd1w8TvuSYKeZ6FByksv+Q511otkffuLXvnEBp+QXIOYApJgyhBNg==@kvack.org
X-Gm-Message-State: AFuF++nYiGPUKF7EtD8dlLDkU8UYjsF8OY/eQXh8Y+QVtoshIoGwX6In
	lA7MkS7vBwvwOsmKT3/Ld8AEQtFii0hN/J0Tn7M0xPobFVwOmuZQ8FD3DAqbGZ+0UH0mY5O7mrC
	H8gVlkg==
X-Received: from dlbek20.prod.google.com ([2002:a05:7022:c94:b0:141:4abc:f12d])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4990:b0:396:4cbf:45a2
 with SMTP id 98e67ed59e1d1-39d9c0acc23mr1884695a91.14.1789084069193; Thu, 10
 Sep 2026 16:47:49 -0700 (PDT)
Date: Thu, 10 Sep 2026 16:47:33 -0700
In-Reply-To: <20260910234737.1340642-1-surenb@google.com>
Mime-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910234737.1340642-4-surenb@google.com>
Subject: [PATCH v3 3/7] proc/task_mmu: clarify shmem mapping walk conditions
 in smap_gather_stats()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B0E1840003
X-Stat-Signature: yjdxrfrkqn3rc3kxow6ep3f5jq3o47jy
X-HE-Tag: 1789084070-390954
X-HE-Meta: U2FsdGVkX18QKsm+1FncsuG4MKr7fuLpN5/QffoiNb5IWzfyOls+sTjIp9+imv2dJgwmn9E+bRDOaaeOEEk1CYrgrL15k1ZiN/DcHYNL/TcY2j7UrnUHOWZiJChnfbKIukr4Pt2ODvMiJkBD9Cdig+NuhUtw/dgxgcF91lonZycwqfUhlR/ipWA1V9yKuYTs713SZSSG8c2YIP0ZfWy9YQKhWISZJA4q1SB8YscfvuTGBwv6o4pjCNJ07atVJ/Ppjv5VjoRcVrAwRaw9t7nTZjWkaSx/Ts8/H1rCsQRmvrQqdw+Y/k00uu8TrV6HG8waMKjHKb2YNgP+tdiNMvK8rJCuPgeTuXJwXYf8/MapoAz5WKarJgPFDDndHZkDUXn67KNu7/0GH6e7WHe9Z/NTmYJQa2lXvoWii7X1Hdrh5UvF6ZHwhXj4eMROK9hg7QGsO9Gl2ziBLG4rZmhD3NEdT3FYzu5zo8ZhylDutLSQIRkUcvHPDxeqJd2dsGckr0STUUHVby0V5z7C7hZJvln3jqacLOj7Z7Pw1OQRts9gyVf1nSSD27jxwFfXqZKqpv7M/nJOVA7lHDQlR9Lf06hJn1uQgGq+U0w5BWDyfMD/DcsnKcUwMFnk3JFc4F+0nCbm0wYPyhFCxlvXOrvoEpTnoDdUOaVLP9wtVH/Jy/tQ/CAMDHcx9mD1IwQglYevNDHPfQCFka/OGstDYF/zPWOlCUkNivbIPVidrzcng16doXPgQqml8H2/0qqGsaoyhu5S9QT8q2wAEy3Xx8URkOzOnUVPjt9sVZm/1ed8Ta/HVfMlu2ksBfToYcN4NTfIMAz9h5YV3zGI25r0m/bxrAJJoQFRg6sdPriWwsvgq2y00xtQ1cYcVFcLdU/w/n1IgEWvHotZ2o6TtWlvxZ3XwLsNri16zDjJZVnBBij4x/AA5hHI71/CqNpAE4APRqZs94shrLqN93faPofIySOTgxb
 FQSVNAtU
 oFTCAlJBic5yV0JiYV035bYEI++8eQhnBsPVocTRIpmcR7/uxLP0ptTJwNydRJ/lAFeNBiwsVV40XbvmK9fAvwP6XW5SvMJ49jBf944l5BsZGQnU4uqJ7rv7moOsS9WB8YB+CTJ/4IaPneRls9KEMvp1wTcBc2Lk2OInfTKASwAln/f5Ggg2k1WPbf4rFZ4VM1xC85zoFeD5ZhI0QuyOet3Ivuo2QByTgch0/fADg76YnQ3rSdcyi5rT3AWzLNOGhi9zp5hR2qsRSXlKnxpIXAPp4qPK1HqaJkV7HHTXVTRNxNj/nmEd2WArYVsvx4NJOfF4NYNc2tBz2X3u813D3dKzT/FldakL5m9laqxgVP/Zd50+2YSLBdzDdTgo1tVoQ6lzSBcBQCQZlDwfBtKBc7femGTizmdOewu6veQMHhDlfvlCuci18cnKGmDNcjcAR6DnQRmwdVyzAjUGs7zB1e1wE6yJvAq/mOEzgnfRM0RqoWT4M28sU9drFSsAr5w/cWehyxfPUe1gox2Chi0wC2s0MkEfNgH2i7eAHb5h+wTfFbPi0Xyp6vTECXGXD3taV4NwjM8Ji0+222+6orbbA2hILOAjMcFYqRFDmHnoxu8439VYq4ulgPl+Ukxtcgel3FuxysM6q+XtoUocOs/mj2bu4nCL9kIeMjorGMm5y/t7xXgDe44c8VJZMcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

smap_gather_stats() optimizes stats gathering by skipping the walk for
shmem mappings in certain conditions. Update the comment to clarify
these conditions and use vma_is_cow_mapping() for COW identification
instead of open-coding it.
Instead of using (start != 0) condition to identify partial walks, use
more semantically correct (start > vma->vm_start) check.

No functional change intended.

Suggested by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index cfc7af1b551d..3c40c9cbb9c9 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1257,6 +1257,7 @@ static void smap_gather_stats(struct proc_maps_private *priv,
 			      struct mem_size_stats *mss, unsigned long start)
 {
 	const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
+	const bool is_partial = start > vma->vm_start;
 
 	/* Invalid start */
 	if (start >= vma->vm_end)
@@ -1270,23 +1271,18 @@ static void smap_gather_stats(struct proc_maps_private *priv,
 
 	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
 		/*
-		 * For shared or readonly shmem mappings we know that all
-		 * swapped out pages belong to the shmem object, and we can
-		 * obtain the swap value much more efficiently. For private
-		 * writable mappings, we might have COW pages that are
-		 * not affected by the parent swapped out pages of the shmem
-		 * object, so we have to distinguish them during the page walk.
-		 * Unless we know that the shmem object (or the part mapped by
-		 * our VMA) has no swapped out pages at all.
+		 * CoW mappings might map anon folios that do not belong to
+		 * shmem. Perform a less efficient page table walk in this
+		 * situation, unless we know that the shmem object (or the
+		 * part mapped by our VMA) has no swapped out pages at all.
 		 */
-		unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const bool is_cow = vma_is_cow_mapping(vma);
 
-		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
-					!(vma->vm_flags & VM_WRITE))) {
-			mss->swap += shmem_swapped;
-		} else {
+		if (is_partial || (shmem_swapped && is_cow))
 			ops = get_smaps_shmem_walk_ops(priv);
-		}
+		else
+			mss->swap += shmem_swapped;
 	}
 
 	if (!start)
-- 
2.55.0.1007.g17ff1f9808-goog


