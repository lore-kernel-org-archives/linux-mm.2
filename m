Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17EE7606A321
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=V8jE+xlT
Received: by kanga.kvack.org (Postfix)
	id 1B37E6B0AAD; Thu, 22 Oct 2026 22:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C056B0AAE; Thu, 22 Oct 2026 22:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C9E6B0AAF; Thu, 22 Oct 2026 22:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D4CF26B0AAD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:31:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 547B1120119
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:31:25 +0000 (UTC)
X-FDA: 85352314530.19.80A8E78
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 55D3C20009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:31:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V8jE+xlT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792722683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HZzC1723EY2w+cC5K2qlsvEI7wuY7VANYPe4uNl7HOk=;
	b=xVTXBX7EhYa1utU91WPOmaLDK52vjVfUrzBXmvAC+lbbIBhFVEQlw5TJxe0NwT9v9E917o
	S6qS2tcwI+dFBUi+LMSCHNOxu8LTKsO2B62LAGia9wzJcwPhQKi03oU3kJdtzk2ovs4Qnh
	FPxkqn8EoP6fZGH4XZRqOUN93jRXtBw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V8jE+xlT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792722683;
	b=3TFS2chiBCSLFDEyf1ZU5WOFJN0x0KNMQV65oAP+p4zyCkuNmkEcR1iT4unsEePenWg2xr
	u1r8QEhjodEWA8jA6fRrh6XmmPtypxO+eT5amcJWqees/VyiVFywgNI+/VZjd7PZSz1rSc
	zlYfKHJ7UsLTidwD3y4hoirQZTRxQqE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792722682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HZzC1723EY2w+cC5K2qlsvEI7wuY7VANYPe4uNl7HOk=;
	b=V8jE+xlTyfC6TG0rUMXTk1D90yJ9k9Oin/U5ihsqTirBxrdvGVLV/JyW4LK2x4k4/lTBER
	RPe5rQ2NMlVpQ0du7o+JcUu4p9WV1jGe9qIq7tFwXvkIPEgWqgWa5wKB3WY4dyC747ev+r
	E0ON4E/sb+n9LcqhliTs9wUNnqUUtaw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-32-ihdDI37kMBSM249ZqvrqQA-1; Thu,
 22 Oct 2026 22:31:19 -0400
X-MC-Unique: ihdDI37kMBSM249ZqvrqQA-1
X-Mimecast-MFC-AGG-ID: ihdDI37kMBSM249ZqvrqQA_1792722677
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E27281800631;
	Fri, 23 Oct 2026 02:31:16 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 811127DF;
	Fri, 23 Oct 2026 02:31:14 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Jakub Matena <matenajakub@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [REGRESSION] mremap() fails VMA expansion when VM_MIXEDMAP is set
Date: Thu, 22 Oct 2026 22:31:06 -0400
Message-ID: <20261023023106.515365-1-luizcap@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: wKywrlL4UI-2_MZBj6V-3mRVrIAQ7eNRv47u6zE0W6E_1792722677
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 55D3C20009
X-Stat-Signature: do43x5bgh4c4gc6edhiema16p4yyz5u3
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792722683-56
X-HE-Meta: U2FsdGVkX1+P/sx6by6p/jwuR/UE4Lf15CT8xkMz5MDK0Y1JeqAQmKh37EP1FbPfE6ET6HTOiKgkupX7vOqB/Ovu9rWuFPJlxKe/kujrAUE6EJsp023SsAFmgMLWlbil0z5LBbBLGuA585geMPpkXGJPrWXPvqxMN94xw/ePWlN06rR85TqBIRRlb+asnfhDzfT9DSrR+j4u7eRfYdFcHmx7pilqnBEWCb1LYgYA99t6iXCgkNXJ7SOoywSXs+QEMQaFcyH3dqijP7FwY67jKzh51Xp6q+jZGWv3P1Vq1xlZQvZ5RLNuvLHiLsvIeJXDBvQstknBFmzsKMOCzZ5rrrFZFSvZuv0zP1rdf9k412Z1lQ4y2lW1wmzb+ilZNYowB4DdAFhBpC7FtdKDM57yTmmGCc4w6PHn+8Jz4eMlXtJi9oseHItgREk/mSZfLegst6cw0LIxZv0j7H9wDAcLA6uH83t86ir0raZkZ3WxCSjRESZ7Wdtj+cz1M5AC9L+lBi5qBDvAnl0mLekWNNJkE4hYCiaDOzklJL4lZAfpkS/HdK/Cb1HSRH+vCpo/qoDGL25SgJcgZLZErQtOwRAWiRHThQUBCTXIb61sV+dWZa+pks+cc/sAkn8HiazERZYIu1D2yhf1QBVhyi/qvG+hwwKAWSo/CCjKSU1YD/smENd7y31aYnMwZHctUu20JyULJ+jwmUFLseYD3aw1PopI89USgGijYDSkzWPRe7IZVczYmBHxjNKPiY5iTotuEIFAajQwtxfsQbuT42Vjp9t08uJvyy1vV8fftAVaqEsltswtw1WAAdf8e0EdQnPGEyfxGdDnwmdCGbwV+7x5+5duMfnoy6LvVB4816XRuSHy/ZCY3rGyrkiiB2Gx7lIfen3d6XvC7SbgvGbinb99JRehqk750ZA7eDbTU5pSjemP3w6bT8Ux/uNNSC7BbrTAyiAnyVFBnjNeDV/pBf5OTHJ
 fes1kaLo
 oGPgQ1Z9mEOmyi+nc6diPPUPonN/L9ArrKbLST+CfYvL3iUYep5jHiccH/aIkLy88EZQvYFfRkk9pqjmgew1hXxA52WIksN0JsyNIdvmTz/Mx/21GP76GDunTt0aSWTEHbV9oc60GFsC7T3I3FKvVE3+rHPZV3M0Ega7K8a6yf/I+9y2knrGqZPZBoPjaqPnFSMyeFhva2ArFl6K5PhpYvI3ME/guAgIjfWeMu/zc95inhrlSYsjxMhnbMsm3tM654yHlFCzQTGEKs73EU9Eyi1gc1LjiwTOHMMmOdicBnfCXtQ56je3uv26QkGKpCFjVZihhqoDs9DRKUP1347U+LlWimtAQL+VeuIj6zMo/5bdSr+I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Growing a VM_MIXEDMAP VMA with mremap(), with or without MREMAP_MAYMOVE, fails
with -ENOMEM when the address range after the VMA is free.

This regression was introduced in v6.1 by commit ca3d76b0aa80 ("mm: add merging
after mremap resize"). This commit changed mremap() to use vma_merge() instead
of vma_adjust() for the expansion case. However, vma_merge() returns NULL for
a VMA that has any of the VM_SPECIAL flags set.

The issue is also present in latest Linus tree, except that the code has been
refactored. In the current tree, the path now is expand_vma_in_place() ->
vma_merge_extend() -> vma_merge_new_range(), which performs the check:

	/* Special VMAs are unmergeable, also if no prev/next. */
	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
	    (!prev && !next))
		return NULL;

This issue was originally reproduced with an external module that sets
VM_MIXEDMAP on a VMA because it wants to insert pages with vm_insert_page().
However, there's at least one in-tree reproducer: tcp_mmap().

Note that commit ca3d76b0aa80 introduced other VMA expansion regressions,
but they were caught and fixed early:

- 6f12be792fde ("mm, mremap: fix mremap() expanding vma with addr inside vma")
- d014cd7c1c35 ("mm, mremap: fix mremap() expanding for vma's with vm_ops->close()")

Below you'll find a reproducer and an attempted fix.

Reproducer
==========

This reproducer was written by an LLM and uses tcp_mmap(). It reproduces
against v6.1 and latest Linus tree (2a08195e4db5). The issue is not
reproduced on v6.0.

#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/socket.h>

int main(void)
{
        int fd, pagesize;
        void *p, *ret;

        fd = socket(AF_INET, SOCK_STREAM, 0);
        if (fd < 0) {
                perror("socket");
                return 1;
        }

        pagesize = getpagesize();

        /* tcp_mmap() sets VM_MIXEDMAP on this vma. */
        p = mmap(NULL, 2 * pagesize, PROT_READ, MAP_SHARED, fd, 0);
        if (p == MAP_FAILED) {
                perror("mmap");
                return 1;
        }

        /* Drop the upper half, so growing back into it can happen in place. */
        if (munmap((char *)p + pagesize, pagesize)) {
                perror("munmap");
                return 1;
        }

        errno = 0;
        ret = mremap(p, pagesize, 2 * pagesize, MREMAP_MAYMOVE);
        if (ret == MAP_FAILED) {
                printf("BUG REPRODUCED errno=%d\n", errno);
                return 1;
        }

        printf("NOT REPRODUCED\n");

        return 0;
}

Sketch fix
==========

In the fix below, I started with the same idea as d014cd7c1c35: on v6.1 I
made mremap() expand VM_MIXEDMAP VMAs the same way that commit did for 
VMAs with vm_ops->close(). Then I adapted it to the current tree. It fixes
the reproducer and I didn't get regressions in MM kselftests nor the
tools/testing/vma test.

However, I'm not posting this as a fix because I'm unfamiliar with the VMA
code so I'm not confident this is the right approach.

I really don't mind someone more familiar with the code taking this over.

diff --git a/mm/vma.c b/mm/vma.c
index 6c35f0d775ab..ac9a0a8a4be9 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -851,9 +851,15 @@ static int commit_merge(struct vma_merge_struct *vmg)
 	return 0;
 }
 
-/* We can only remove VMAs when merging if they do not have a close hook. */
 static bool can_merge_remove_vma(struct vm_area_struct *vma)
 {
+	if (vma_flags_test(&vma->flags, VMA_MIXEDMAP_BIT))
+		return false;
+
+	/*
+	 * We can only remove VMAs when merging if they do not have a
+	 * close hook.
+	 */
 	return !vma->vm_ops || !vma->vm_ops->close;
 }
 
@@ -1093,6 +1099,20 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	return NULL;
 }
 
+static bool can_merge_vma(const struct vma_merge_struct *vmg)
+{
+	/* VMAs without prev/next are unmergeable */
+	if (!vmg->prev && !vmg->next)
+		return false;
+
+	/* We can't merge VMA_IO, VMA_DONTEXPAND or VMA_PFNMAP */
+	if (vma_flags_test_any(&vmg->vma_flags, VMA_IO_BIT, VMA_DONTEXPAND_BIT,
+			       VMA_PFNMAP_BIT))
+		return false;
+
+	return true;
+}
+
 /*
  * vma_merge_new_range - Attempt to merge a new VMA into address space
  *
@@ -1152,9 +1172,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
-	/* Special VMAs are unmergeable, also if no prev/next. */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!prev && !next))
+	if (!can_merge_vma(vmg))
 		return NULL;
 
 	can_merge_left = can_vma_merge_left(vmg);


