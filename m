Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD11606A321
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=JsWJ6Pj4
Received: by kanga.kvack.org (Postfix)
	id 506246B05B6; Fri, 30 Oct 2026 10:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE4F6B05B7; Fri, 30 Oct 2026 10:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD596B05B8; Fri, 30 Oct 2026 10:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 175BD6B05B6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:43:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D7951C40B9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:09 +0000 (UTC)
X-FDA: 85379560098.19.9249302
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 51628C0002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=JsWJ6Pj4;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSW8NWM9gOucFIr1T7wwU0cwLVYpwHF/t22hLvEg2QQ=;
	b=jFP5GNa3FyGIuln7Y4Ttu547i8haAjhXtapxf79LJeP5X2E9rUK0TyUcM2kXO0u0zj+RCU
	Uy7VbJl4hGI2MYDT8O3Xzn+OJHvPTPlSVrHWOPLw2fHeHZr6DQnMNHC+g8GxDb2WY+mOFT
	cs97J7Szr5nBVHhfU0tlT6YrE+tL9PU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=JsWJ6Pj4;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371387;
	b=58mmxopuzzcseybxhrZLr9h1kZ5kOxbK7x79WytWuKq+yTGnuDhinbrSthSG7zY24WeSQn
	LYOIOSOllnl+3w6j8dPqHWKpKATczN8U4KxS32eDkJ0eAvHo279ZopYVDTcOJn87tI8NzU
	IjbzNTHICo9DIwFM7CCKmL811G8f8/g=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a208d93758so8102455e9.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793371386; x=1793976186; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZSW8NWM9gOucFIr1T7wwU0cwLVYpwHF/t22hLvEg2QQ=;
        b=JsWJ6Pj43RAtF/g1YPinXP53hD8jIp0G5xepHQAvO4gKr2D6b7PT6WX0mrxPaPNFtL
         W3FB+E4FuKiip+P4bdEzhmEuAmfst6AwpuhjPUpww/fIdOtXj2eFdW8D2/j6HbNDbfRd
         rNSVB/eu8EFZpWVI63Fmup6sQRmiFYRZXMEiLHBIoPkFO60+1AX5RqYYnciTJuYAu/V8
         Nx/MvG3YGOUeIhBUDYarG8oiZ62fjhQeILY7fuGtBRfu4cwXvNXIk6D9elaEH3Uno6WE
         ENTD+VSmJ4CQvlF9XdChwEn0c1gwaUnvWFIinO74SpZ9vLFC6CZDE3M+l+kPCXAw/thw
         dANQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793371386; x=1793976186;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZSW8NWM9gOucFIr1T7wwU0cwLVYpwHF/t22hLvEg2QQ=;
        b=CFo7AHBdnfHBcI6HjHeUs7rGZcMHDrGSnIvcdiiaTXlYMcof4KHHPqRgrfLNpAMifm
         /JWVN6qRQFLQWhiSmy29NON2FDTBKM84rSNxCa9CeLyhysNw8Ddv2pC3LcWs1niCvDy7
         T8BL9LOceyT27ZYJtL9dKemrBVS3+irFS0ZKAFq0zrv5kcn3q6wyyUWfh5rYVjMr0slK
         Ru8lbylIh7bliuVhoyQ4Doj5AXOgLHw8ROYzE+YUl8Xt4SFfYsAgz1grkhx9iIY++qrr
         L2E6QPylu72gazdssK0+3EdWv8CAs6WOL9WK1Qyy6jq9EMskIPWiF6ns/QHKp4PwvCX2
         t49A==
X-Forwarded-Encrypted: i=1; AKwUvBz0Wfbqfr9nSy6HRbxUDZ/v08wOjND+WmeEhK+UjMTLnM0Wx5kGFxOFVESAh9ZkH2e7+LgLmKJbCw==@kvack.org
X-Gm-Message-State: AFq9FYLjbJ0DVMcP8IBXdtId071pNiVgJIrFNQbDSZVte8Q4yBcvRGlN
	vvbvix/rOLmNMNpnSVJVvoDHh4KlPAJZ5XxJ0dUO1ToljC1E04D4F7/SXc0mQu8toc87vciaxVe
	eWr6X14M=
X-Gm-Gg: AYBFou3Zkvin+SUprZ92DqfB2i0YVB/McbfNrKne5qv6ltiIhcRDGgFPj2J2d3h1vSE
	LIQmMMtUWvw8gmfH1WPrXJB6evMq262S56/n9XAc6qK8iTHikU21EFVDI/WpE+zZWhl9oKnA76f
	/dJ3Rjy+MkdA2PMFevGRt7N29HlWtmPRxWBWs311F7KfoB0r+KE1sJU+D5roq2aB8brCOr56q/+
	/cP7CpdZaN50hvP9Wc6ZSsdfBYAIMGRN1Ya5B3kiA21GVldCyOKau3BPuYENtKW5byNKTG4Hdwh
	QhQQnTAFEyi6bGxXF738++o+784F7Z3lvd/8erWzTFa+NeJKbyoquwRh6Ytgyykq/ickbFAFhd8
	KatVGdVMoO4KtRGUnaDIQsq9NO+8CyhkgDjhljvmljXiMGHNi3IyNYAcAz1dTjxiDa4A83X7EhW
	nsNrsHxXDxu7EdA1234ESHXjGeWKbSJC4DHiL0V4v72LJtXvrgVKoHM+QJsTTH9OoK0fNxzOnYR
	hSX3HhPnOhx678ltMN4A8o0Uc/P4NlSRjuf7YtdTpVfiKKa57ZLSezj+bEP8A5ly4otEf9tr4Y2
	Io10im9fvNZZgpSBYkmxMzq7yeKegXULXEJj9pbMG1DtpkrzqkPC1E+am5yaW72PufyA
X-Received: by 2002:a05:600c:1385:b0:4a3:5991:718 with SMTP id 5b1f17b1804b1-4ac182dc0a1mr60049575e9.16.1793371385879;
        Fri, 30 Oct 2026 07:43:05 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm101763505e9.1.2026.10.30.07.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:43:05 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 30 Oct 2026 14:42:46 +0000
Subject: [PATCH 1/6] mm/mremap: fix hugetlb reservation leak on partial
 move
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-b4-mremap-pre-split-v1-1-c1829811aed0@toxicpanda.com>
References: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
In-Reply-To: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793371378; l=3779;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=727RyBekzd9lpkJV+79/5zYip4JhzFujNChohpvOxOc=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QKbBQKJFRO9eraUD2FoYjwF7jz42WONgsIsbFgra1tdLv93O728OAsAQmmqZtMeD+fhR4JeSkby
 7DwP5nASeUgw=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Queue-Id: 51628C0002
X-Stat-Signature: 6zejt4mb6n5ex4178nweg1hkmheef3zd
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793371387-379988
X-HE-Meta: U2FsdGVkX18RFf88AoXG7ebvjWIPgJcbBR95nMZI3HoIIUxLK4ZscqrLNGBtTVqNc2NXthnYRi911ngV7Z90BAjEtr++0tfX+A8mFVPSAMFzieQNpRVZqSchUvy5PfluzyLEW2Y78HqntoJuqxayiSXzegDB7C3vz0Qdkxc3QJ0dwYhKag33xSIDN/Oo1oy6nHOmK4M5lmJzgIk5ekXtsdVtseSXHGvkdkWFd90K1580ZCT2gQqRNOOI3UUsdN/CEL3hcyU3etb7pweZFjLIcrM5igv080ifyOwXHRLLYHGnzMMEAwCByzWZOg1G21QtpEedCe8oBaWvg8y0Ikaw9Dwgi2LNWx/AcStLxlOftI6w9lUHVu67DrRE2gM6J+g7AbRdT9PokAf99Gj2JyNj3RVUEy2wob+7R6oWMGdGujMWYoiNxEdGDdqMl7nzdX/40xudKfFn/VIwbGx5LhmManGFkzQwpNrDyHLyTpy7+OSkkVFSH8UJixot/Fh/5aZ7ChVaU6SWIFXZ15TaBrLJqYObGr7b8Eg/d6LNpWmUt3RfEXip1fL9mv0NHfFVXf2qprMmiFgwGd3P8+oq4fFoeHB6UfdGYealNjS+R5edO+qWpzYadudOixX4y8uF8DTOs+X82o/Bk+dsB3RhCEybOwFKdFU4Memta8LXwlMdONKIBNloX6Kw8QFF1WRu0eX/vik4vGnkaIJhItjtwyCo13vZCQ5tbetxHRNIOcGGnnYmo+4PxoZkcsnas1auzYdcYCgxIapBI6/L5fu8z/p3QtRD55e2N2nQvTS6I+U9CpUvod2FqDg5QY9uc3XSTTiHULrP/KqYFHYWwaIDJkiF7N6SyUSbK40frPyHSJEUQ4j3hXsh65S/uUIYHldhaWmWjspMcnyRog7pIl6KBc2kGQRX7DRd1rbcvvy/z4nDG4vkRFANfx5Gv5FjeYxTQSaW71WHTVrMbZTg12Z5DAz
 NO6B1UWb
 CiOMpzEA19cyPvr+WFu7u+J/E6vz/FsxZAOTLWTraa+zGgcbvQME9MqSH+jnMEv5hbrmuDIHLBlfrE5yBEP4EruhmxqsyFbqoLYLA1X/hHtFLREIkdrpyjK0kXtAfH53Ev473anvlWzld1f+3yBtgi3NG1qCjjN8B1UJx5dH/6mcfMzDwnMQhAlxrWHZxl6m+H70az5nwlFD7383fplW4DITNvSMs5kfulvVu2UheSG0pcCO5lyd6A4aetwwTukQLpYWIMvPvD4IJNoKD0SHSxppA8Taoo1ASskkDyXvq0PGBvojPXJzFI2FtbaT0aL7FNjtJTQEzBBW6jIQ0EfyDrRXPIgrVnNWgBapWAHc/KuMJezQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Moving a part of a private hugetlb mapping with mremap() leaks the huge
page reservations of the parts that stay. They are not returned when the
mapping is unmapped, when the process exits or when the pool is resized.

fixup_hugetlb_reservations() takes the reservation map away from the old
VMA while that VMA still spans its whole range, because the moved part is
only split off by the unmap at the end of the move. hugetlb_vm_op_close()
then finds no map in the parts that remain and returns nothing for them:

    mmap() of 4 pages, MAP_PRIVATE | MAP_HUGETLB    HugePages_Rsvd: 4
    mremap() of the second page to a new address    HugePages_Rsvd: 4
    munmap() of all of it                           HugePages_Rsvd: 3

The source is unmapped in this case, so the number of VMAs ends up where it
did before and the check against sysctl_max_map_count stays as it is.

Fix by splitting a hugetlb VMA in prep_move_vma() before a part of it is
moved, as commit 597e4b9ab48a ("mm/mremap: fix locked_vm leak by splitting
VMA for MREMAP_DONTUNMAP") does for an mlock()'d VMA. A backport needs that
commit, which is tagged for stable itself.

Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Cc: <stable@vger.kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/mremap.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 0d06d7f37f19..cf746bafdee4 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1038,7 +1038,7 @@ static void vrm_stat_account(struct vma_remap_struct *vrm,
 }
 
 static bool __check_map_count_against_split(struct mm_struct *mm,
-					    bool pre_split,
+					    bool source_stays,
 					    bool before_unmaps)
 {
 	const int sys_map_count = get_sysctl_max_map_count();
@@ -1092,14 +1092,15 @@ static bool __check_map_count_against_split(struct mm_struct *mm,
 	 */
 	map_count += 2;
 
-	/* If pre-split, the -1 observed above doesn't apply. */
-	if (pre_split)
+	/* If the split off source stays, the -1 observed above doesn't apply. */
+	if (source_stays)
 		map_count++;
 
 	return map_count <= sys_map_count;
 }
 
-static bool needs_pre_split(struct vma_remap_struct *vrm)
+/* Is the source range split off its VMA, to then stay mapped? */
+static bool split_source_stays(struct vma_remap_struct *vrm)
 {
 	/*
 	 * An MREMAP_DONTUNMAP of a mlock()'d VMA needs to unlock the
@@ -1109,11 +1110,23 @@ static bool needs_pre_split(struct vma_remap_struct *vrm)
 		vma_test(vrm->vma, VMA_LOCKED_BIT);
 }
 
+static bool needs_pre_split(struct vma_remap_struct *vrm)
+{
+	/*
+	 * fixup_hugetlb_reservations() takes the reservations away from the
+	 * source VMA.  The parts of it that do not move have to keep theirs.
+	 */
+	if (vma_is_hugetlb(vrm->vma))
+		return true;
+
+	return split_source_stays(vrm);
+}
+
 /* Do we violate the map count limit if we split VMAs when moving the VMA? */
 static bool check_map_count_against_split(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
-		needs_pre_split(vrm), /*before_unmaps=*/false);
+		split_source_stays(vrm), /*before_unmaps=*/false);
 }
 
 /* Do we violate the map count limit if we split VMAs prior to early unmaps? */
@@ -1162,10 +1175,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	if (err)
 		return err;
 
-	/*
-	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
-	 * case perform any split ahead of time for an mlock()'d VMA.
-	 */
+	/* Perform any split ahead of time if the source VMA has to be distinct. */
 	if (needs_pre_split(vrm)) {
 		VMA_ITERATOR(vmi, vma->vm_mm, old_addr);
 

-- 
2.55.0


