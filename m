Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 750EBCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCA86B03D7; Tue,  2 Jun 2026 07:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D8D6B03DA; Tue,  2 Jun 2026 07:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B556E6B03DC; Tue,  2 Jun 2026 07:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3096B03D7
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:06:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D25E1C1DCF
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:06:44 +0000 (UTC)
X-FDA: 84834694728.12.3CF6816
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A94031C0006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:06:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bJutkObC;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780398402;
	b=yc6OzyjENzLL3a7JU8Z6HB+iYQui9kW+Wb+V6+HkaACByN8kO0t0e1IcHdMckvA8r9rJDI
	WINWYkSCsdEYRgtKBZqFg0inYz8N2FKA23TWbLT9PpO2A/oT0dvGOlsQ9bzxBMe53cX1Mq
	NdAKNXRfTGRkSt2SZVlMG2RYq4welY8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bJutkObC;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780398402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RDbr0381BRy8zwWOC6o0iLlxNMOQ3y9mZNJBCj9lknk=;
	b=m8lQhdpDBdcxFS93CndlClLvi9hoYr+5dHHw2QrIcrrzmYuAqNaJH0zD2r8QgikjpGHkyH
	JUPzIuy2QR530b7Zh2VgHUoya0tEbXjdHveDmM6E4JikcApV+DcKFLYX5w9Zs3EJIt2L//
	5KUv/4/0S7Uaz0bjubuYEWEBlC6a+bM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D420F40446;
	Tue,  2 Jun 2026 11:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CDD1F00898;
	Tue,  2 Jun 2026 11:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780398401;
	bh=RDbr0381BRy8zwWOC6o0iLlxNMOQ3y9mZNJBCj9lknk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJutkObCCB7dbwzH+nmbp+9/fDeqAqs1G+pqV/651Br86DAHsBVDaO2fRhjPGNqII
	 EJY/iPr0YV8u7ko9Btc8J2X5LMkomEPSt6m+Y4HuF5tJ7WFmpDveHVQtc9xegh10Rn
	 TYe3Ly0RTOPhUXWm1gjp/LEz0gIitCxhuXqYdeyIj4SsaMeRiOtx733jk5KzpK7Gi6
	 FVuaN2c+t45aNzgtfM763kE1AfG3XzAkb9Ndi2oyvAKb46u5r9dpjOR9WQJZWE4YUf
	 jsG5z0nOCH3JWX6F/QefKZxU5WwKDMUEK115a+qLsLJhgFNmzwtCpMwb+PZEOivPN9
	 bTRKg1p3dOMQw==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/3] mm/vma: remove mmap_action->success_hook
Date: Tue,  2 Jun 2026 12:06:26 +0100
Message-ID: <f79434e6d30af6d92999be6b76e197f1847105fa.1780397980.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780397980.git.ljs@kernel.org>
References: <cover.1780397980.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A94031C0006
X-Stat-Signature: j1dfcjw3h1j96ws9sqbbyfuzasmunyf8
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780398402-227078
X-HE-Meta: U2FsdGVkX1/+lR42rdg/4ueF7hE5SnZq+fqAMKsQMUujoBup15F/hFTqvsHQaxfoqm0761Ne2wBKAQL9z2TGJY4AnNE0UMXEytSTC+XlX6TW6IY7RBTYVBTc8Uqm8G4izHj6fl6Wa9DhqHkknCt/8mNpvUzbe3ZBq8Kr6AIzKG2W5TD883hfkhNWNgPJvcY2OYFptU9PYWPEXA4Ejydt4kPFKoo0UEnqkH96MLbhzwq5Dn4xv78jJN1Upj1AUe0nzrAsj8zcopD1R3K/xHNyLqhi1khpF67lcX8UguZIHFNkUGZnsrlN9VpyiPO0zTdh7Uxko89RtEETCU6MXYgPzOQef/NnU+TrsjS6amkWmSm4fZwmPbYytRaIO+fbDiVI7Gi2+2+JrKo4NkjYp81Nc7y0hcJYWPL2Wea9Q+hG1ULCkNKA7VpgUuTwwxnxv+PaggmVMRED2wEO3ZxthJTeNI8tD9iaIbz8vERH2eUKd8jQcnuJvdx7fiqufoPzFdubOmPB+3fY4Je+6KrBGgw91OIFqlzqVM8g+cevVuIs9U/iCaTR3oA4HEHtoQh3SPISU6HoFByMD22Ov20Xe1Js7hEXoLLs9l+QmzdtAqweuaV0L5TPiFQ+7mj+ZNxSr6dapBakmhBY1gXCB792Y82ZesHw+6IQ6MU/psTHfJSMma2TRN4hxQEOuAJf5QQjNNPbQYscekxWA4HcCl0G2k1lB6TrjOMrjqz+gSr9Zc+7iW/efFycEgG5D7egL130pX71xKaj0z/o4Lviqvbib0WVEVtvTE4N/C8MIuU30vudi16rQGk6hX31LXjZeZoJiG4K0wWbyAdH72mVUmXo6qhJVm78CgPnj5dkgbIG6qjvxmr6S8ORPMIZrN7TmMreEV9Ai9TpPl/VQG9Doit0VWOuFGYAnaaQEfKVnTF06cUv9PcHyh++JGAUzAM8KpOlJz+dhDqcHkE77LXeO8s2VEQ
 BoMBvwwb
 VhUz8iHosNoenT/9dOoKdsAmWF3rsXRmqcaNFsjum+7u2PESbrtSlRb0WnR8ln2FV46BIMsk5Lyy5pu4B235NUq9+atQ1coW5cR5LWShmVCxX31XGraXJBiad+ZBY5JKsmC7av1nmQHhUI2A8pSO/nkpL+bzHgyn4/Gyglp0+WZN4EPIyI21VwOOLfUYqg8WaPZh0nICQCyodOe0Dte/FhrqTD4XDzG+5ge0nOH2BXErEaPGb2W6wbGPE41chF9TPmDGUEv/qqdw+nLNiMaDL4GKJnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This hook was introduced to work around code that seemed to absolutely
require access to a VMA pointer upon mmap().

However, providing this hook leaves a backdoor to drivers getting access
to the very thing mmap_prepare eliminates - a pointer to the VMA.

Let's solve this contradiction by removing it.  The key intended user was
hugetlb, however it seems that the best course now is to avoid allowing
all drivers the ability to work around mmap_prepare, and find a different
solution there.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm_types.h        | 10 ----------
 mm/util.c                       |  2 --
 tools/testing/vma/include/dup.h | 10 ----------
 3 files changed, 22 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..945c0a5386d6 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -843,16 +843,6 @@ struct mmap_action {
 	};
 	enum mmap_action_type type;
 
-	/*
-	 * If specified, this hook is invoked after the selected action has been
-	 * successfully completed. Note that the VMA write lock still held.
-	 *
-	 * The absolute minimum ought to be done here.
-	 *
-	 * Returns 0 on success, or an error code.
-	 */
-	int (*success_hook)(const struct vm_area_struct *vma);
-
 	/*
 	 * If specified, this hook is invoked when an error occurred when
 	 * attempting the selected action.
diff --git a/mm/util.c b/mm/util.c
index 2b2a9df689d7..4e172990afcd 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1397,8 +1397,6 @@ static int mmap_action_finish(struct vm_area_struct *vma,
 
 	if (!err)
 		err = call_vma_mapped(vma);
-	if (!err && action->success_hook)
-		err = action->success_hook(vma);
 
 	/* do_munmap() might take rmap lock, so release if held. */
 	maybe_rmap_unlock_action(vma, action);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 306171d061e7..fddfd1b57c09 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -482,16 +482,6 @@ struct mmap_action {
 	};
 	enum mmap_action_type type;
 
-	/*
-	 * If specified, this hook is invoked after the selected action has been
-	 * successfully completed. Note that the VMA write lock still held.
-	 *
-	 * The absolute minimum ought to be done here.
-	 *
-	 * Returns 0 on success, or an error code.
-	 */
-	int (*success_hook)(const struct vm_area_struct *vma);
-
 	/*
 	 * If specified, this hook is invoked when an error occurred when
 	 * attempting the selection action.
-- 
2.54.0


