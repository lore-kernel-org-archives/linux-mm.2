Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBDC410F2861
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 17:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07F5D6B008C; Fri, 27 Mar 2026 13:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030796B0095; Fri, 27 Mar 2026 13:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF516B0096; Fri, 27 Mar 2026 13:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD3376B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:31:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67B40C2B05
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:31:12 +0000 (UTC)
X-FDA: 84592533984.28.1284533
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id DE65A4000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:31:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ka0q+dmy;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774632670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MFMpAicAVLdgCnDAgidTPnkm3XzHjUsQJ0EYM62DzkQ=;
	b=hldl7nPFq0U9Q1fI/hksbZ9LV/Mz1KJrLiYkXAZJrmJXPq7PkDWfS9AztPSS2qosLC6ZAA
	U+Srnbd/s79R1yOv+hhL36GMNM/Q5VX7RrHLSprzVg4Zo1u+y1DcDraWnjCQCKSAFVNGZ2
	VcVXJB4TVR+h0C07uqQ/KyFd0rMM8/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774632670; a=rsa-sha256;
	cv=none;
	b=a7qCPnlpt01TKwzAlcCpdZf+Ow4U/lnfI6tTA7nccOyPfoH3qo7GZoaKSTmVv/8EdCNU9M
	gEI6iD62EMGkzZsyL+iXbGCmcJ9WYcQClXCNFV8tu8pw4qvlDTbftsJTa6CUYKjnfVut08
	qL1/JxtcxLe2UqiI8+I47mN1peh1k+s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ka0q+dmy;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4331060054;
	Fri, 27 Mar 2026 17:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68847C19424;
	Fri, 27 Mar 2026 17:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774632670;
	bh=p3g0vEQcyfOPNCZMkuXocGJTkoIrWs8g+Y1TUEvRRNA=;
	h=From:To:Cc:Subject:Date:From;
	b=ka0q+dmyYtvY1eD0U6G9pGNzNpUQQA2+tuOlKGZE0rdgAEiDPeKJpS8jkjzgNG3g1
	 2gkJKAtjt2BgjR+y9S/xgDH8Ji2qVwS2OHshgKN/qH5OzM01MmrQ2gQ7eyi23GW597
	 /ImPgkEL27g4MVoNvcOb6AebDkY45rtXxTGIJcJ8XjhWfl19N5bCgXwO71V/zpdjrm
	 b8MLdNhy/72pu84JtOnnr6U6LwYN+VoHc42ehGdpGXIUk0eqcRwTDp/HkpZ0JDWgIu
	 nG6F4hi0/Cdpi8rK6yzbCjqFIkuBR7qzbwf/nXtR9CP0XmqcBFrfaP3LVp/Clstuht
	 R7AWZRw7jqIsg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Jeff Xu <jeffxu@chromium.org>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	antonius <bluedragonsec2023@gmail.com>
Subject: [PATCH v2] mm/mseal: update VMA end correctly on merge
Date: Fri, 27 Mar 2026 17:31:04 +0000
Message-ID: <20260327173104.322405-1-ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: djenytwbiuft5szpgwcm46j9aa9d76a3
X-Rspamd-Queue-Id: DE65A4000B
X-Rspam-User: 
X-HE-Tag: 1774632670-872792
X-HE-Meta: U2FsdGVkX1+I7S05E43xXalp2Nn9tNS8AjNH75F8ds1YvY0WlJwxPWg/GmazzJxlj9zcRh4sTcBya3MeFb+WbpPDPYuG69k7ImG+k/OAG6hyMSFCUXLgJUXTFOHf7PreFJx25YlXa+BEyQXoUWywb8wXmFHAUt75I5YUzJ3OGWFK/ewD+2v7QYtdPcqrPd3d3mNXRwgfZ+m2gXr1AEWmj4pNXXvT3JqmOPfyJyfNsOawnN8HY/IA8CKHmyWbjhY/1TnnKzm3kH8sdS40hBk+hvZisNq/4SkHzbsosaXM2bv1HKCiHsjYrPTnlRKikEBIptrRXpkt/WOufjbGTEBdFHVn9MYg9NYOIevIpllBr9YUQgiOyU3737wyvPIZTo72SSb9fNlmKPgNxIcV7tQ1bnKDK7b915V7QPInPyN1qZTDKK1QvadpQuDYZLj/BKpnhiZhVJz0wwuoXe/zvqdthTwmB6D8mLDtEbIlq4CY48OaFfRxMM9JzGU7BwqnHWyoCTwWbkMcmrsfAfYDb7vR6Vn5jPo9QOgJQq9oVhXo350jw0uLq731odlEAebPo96nkLarcQwPTcOsXx1gFpZ6npufU+SyIS2uoli3dbOmT7G8jpuevGRawLatw/XWlU+wzMPAb0+duP3MxFZYs3zVCf9v5o5EphaCEb9QPirHC08azLJJbL/vANwTv9vYJNnHqUTS2k8st/+AZywE4UMDRxo+x/yy9nNblkKso/4FqoQvkgKR/O3Bjz//fn5dz7Xy+uplnOJZm8xuLaUxs6lH+Y40kQhhZtWDBavD36gDPYVIoRsCdIhHqTpx1wHfQRAaB/nb1roISraIslxiCWU94hqDGSLcNHcYh+ivhMsiVWZ2zrCA+jvfQ7pA+dJaHl4QnVmRjrS+BzPGIVgfw4VI2pvVNQiHIOnhDWDAVyE63ZezjFBGr3klWUozbmlLgXzuvpp4NgGIflvks6shCyf
 M6c6I11Z
 TSNfOHsKLDzczkcD4H5YSMSFNGytbh8SdWGqQrqi5FRKRWhdjIQ93Gs2NujX7rPZvwabsW2P4WNgon/KioVXD2XYKJu45/wnjsPa0FtC8QWe8zWBbddW/2AzGQxPZe7OpxsBWSSBZ7tXDgcQcuPTFE8mY5tZsTNDQWrBxNetyb/N2IO0xu8zNguih6TyGjAi3Jvws+YKq5rgA6VCg6FK0QXCynkr18noI7EOfJ+GHW7VAEp+sitAqssAPDLwcxYSodMazfanab9Xf1wTdFc3LCymc58i/VmrPrGO1U7fqZQyb2s4ToqVzPYoXIpqrAbd/vcVqf9qbjk5KChgAmkMk+lJsZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously we stored the end of the current VMA in curr_end, and then upon
iterating to the next VMA updated curr_start to curr_end to advance to the
next VMA.

However, this doesn't take into account the fact that a VMA might be
updated due to a merge by vma_modify_flags(), which can result in curr_end
being stale and thus, upon setting curr_start to curr_end, ending up with
an incorrect curr_start on the next iteration.

Resolve the issue by setting curr_end to vma->vm_end unconditionally to
ensure this value remains updated should this occur.

While we're here, eliminate this entire class of bug by simply setting
const curr_[start/end] to be clamped to the input range and VMAs, which
also happens to simplify the logic.

Reported-by: Antonius <antonius@bluedragonsec.com>
Closes: https://lore.kernel.org/linux-mm/CAK8a0jwWGj9-SgFk0yKFh7i8jMkwKm5b0ao9=kmXWjO54veX2g@mail.gmail.com/
Suggested-by: David Hildenbrand (ARM) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Fixes: 6c2da14ae1e0 ("mm/mseal: rework mseal apply logic")
Cc: <stable@vger.kernel.org>
---
v2:
* Correct Closes: tag
* Use David's excellent idea to improve the patch

v1:
https://lore.kernel.org/all/20260327090640.146308-1-ljs@kernel.org/

 mm/mseal.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mseal.c b/mm/mseal.c
index 316b5e1dec78..ac58643181f7 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -56,7 +56,6 @@ static int mseal_apply(struct mm_struct *mm,
 		unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *vma, *prev;
-	unsigned long curr_start = start;
 	VMA_ITERATOR(vmi, mm, start);

 	/* We know there are no gaps so this will be non-NULL. */
@@ -66,6 +65,7 @@ static int mseal_apply(struct mm_struct *mm,
 		prev = vma;

 	for_each_vma_range(vmi, vma, end) {
+		const unsigned long curr_start = MAX(vma->vm_start, start);
 		const unsigned long curr_end = MIN(vma->vm_end, end);

 		if (!(vma->vm_flags & VM_SEALED)) {
@@ -79,7 +79,6 @@ static int mseal_apply(struct mm_struct *mm,
 		}

 		prev = vma;
-		curr_start = curr_end;
 	}

 	return 0;
--
2.53.0

