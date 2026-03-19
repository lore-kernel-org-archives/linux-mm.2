Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F8B41090231
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3DB16B04CA; Thu, 19 Mar 2026 10:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EEE96B04CC; Thu, 19 Mar 2026 10:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904AD6B04CD; Thu, 19 Mar 2026 10:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F14A6B04CA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:09:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1973613B4B3
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:09:59 +0000 (UTC)
X-FDA: 84562996518.27.739280E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 32DC740006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:09:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=B3FFWUfM;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773929397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=8K7cb6jcdnN45EwJR6egKGW6FfNNB4pfcE4f9HwPKxk=;
	b=VwZdNdKBzdBuGhjco0TJImeuJB08ejB85/c0CvVh0IyABw3IWjhZv2rmKSaYMFCaI3rkiH
	ry43lauOrpM4ZUpNgOEjFqOdlPxLpkpn14vM3SQvNQPxxhFwQQLDTF4+3KwV0wz2XxtB08
	TAPFBQyjv0ijxtMXy3q5W6+5Ct5UpW8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773929397; a=rsa-sha256;
	cv=none;
	b=0bU8Ugdqy7/CmFMxryHJ3hGke0arrXv6MiN+StTSqcrt0utU6xJzLeVa/K4l1bFTbbyobJ
	+0L4B6VSwdtp4WkuMd2433IlH4nxXMFj3KIeImg2mx7Y8Ja6Btf+Eags7Znk53twmWGMZI
	Hu0/qWnFhpBkja+Ucr99LzS3pziT0OY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=B3FFWUfM;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A99D41A53;
	Thu, 19 Mar 2026 14:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4322BC19424;
	Thu, 19 Mar 2026 14:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773929396;
	bh=aSIgDFKLNy0vRYY5xb2iP/Cfq9fmz8HAVtG98Hr5P8Y=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=B3FFWUfMzeKMyo2bp2g+MkXbirASZXpP4bsimN8qJS7kZpyNa8xzwJBS1JNOYgOQw
	 sjLlf6iDbngqOt6bA1obvMecu/yKVKvdgnpgf/QWRs02Zz5+7TtIV2fAXEoedV43Ae
	 QR4/ViOytyTghNMDvOJSJ7lAIcLhYTHha/hQzBmI=
Subject: Patch "mm/mempolicy: fix wrong mmap_read_unlock() in migrate_to_node()" has been added to the 6.6-stable tree
To: Liam.Howlett@Oracle.com,akpm@linux-foundation.org,cl@linux.com,david@kernel.org,gourry@gourry.net,gregkh@linuxfoundation.org,linux-mm@kvack.org,liying3@sungrowpower.com,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 19 Mar 2026 15:09:46 +0100
In-Reply-To: <20260303101245.22290-1-david@kernel.org>
Message-ID: <2026031946-transfer-ranger-7165@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: sqkdq8is9u3pima1qispnh411s1mw5i4
X-Rspam-User: 
X-Rspamd-Queue-Id: 32DC740006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773929396-734922
X-HE-Meta: U2FsdGVkX18wXqExXPK/eDpA88Cvu5ctP6jxNBVNv6FPT4fyBX0IMjyWn25gXx/VLWvDgn5jLlw7VwoHnl8UP1bkcByza6VZf6V/9ESzDR5jOeQ1NB03bIrrcgFDZw34Kyrwku+KTiL1jHyBiL0CvQ9Is7TNz61g4jOs3jk5b/2cgUyxWa0+p3k8kViWHXO9TA0Ogy9fJQeQTYl8EHpiFXMUyeKCFejkqNCTsqV5QXxDzZ7LvLVWG9YzQ/Ni7t2+qsCIdhZb5SdlH7boy4PngvC9bR6rCB9zFj1bYcNBcrBdwi7d7w2zg9rrPPkqaBsTGEsqOjnkEe8eKuASLclESQwrG5epn21l7WAxczvV8TEs7yeEcTNG/cU89KZxUKYqj2kRR9zmenC6xECTWP15ZE7u2+G4Y4qJXUuMQ8Rulcg79XGEZywJXa7AZiv4spg1iVJ0QX4fX4Rx91Lk7du53/8V61olicov0Qkh01PWf6EXh7TDX3Mv+670NPI7aN4oKlE0f+tdV3BqChFGRVEFypaevOmyfrUSDeKdDlqSvechg3JF9efDB7m1j8JJdlaxGPWfo3FQzIH1mJmjaN5G78R4vqO+rM40DQACuZO/Kas77IPf3ShEC4GWPYFM+oK4pIVpRFxmCUcymmLdyfzzsTkC1u2V+W9TB7q+iXULUwyFbJRfpVVLhwR5NNLfZWNRz0wcfuEuIYU+mEWAQKvl4kpqWmWHkrC+8mf4o7ZhyBzwmxsrKgt9H8vjccLyx6I0CTMl+6Lq2O1PW+x9Q/0eUUqKD3c2NGFEBoU1blFJhLxlPeinReyvbkargVCKzSazZ0iE8Hqzi7jkXMDl/uDc2DOgiKiuodSDzGIAe4nluG3w4ufgJwzuJQo3mApXMk9rG7PEefFEKIzXsh8IR/m6mFVN+RVAghjQHIK1Mx13bhcDnRLWQSlmDNhq2wrMDS6/qHO3QcwGZd2Jj3gI+E3
 DkuK81fU
 n+xaF9eNeSjcrSNS/TdD7/7EjA5KqaUqOg/G8J5Z39QE4QmUusuK1kBLJuVqvk0IgabmOQ24x71eURbJMUf94ZI/8oxxogk9CZoUeZDXakDX5nYYK0qY8vls4+x98KBRhK1OfTo8OkTYxiEPTcYCAwoYYgCv0V9oMAQVqDF6oapDjm6FSDNhz5aHX65qEC7nasM7cqFy9OI/+8BMGKVszDOhoVk4F9/4QyUJL4qpH+Hk+KmEHX3w3q3R9O0f6D31hiVXmktxljwC6HwKbkjn8Mv+9TzI60Jf8gclkCxJxf8MAI2q8myjNpcoFQemnPXbLZ9HE51sexWFRhc4uysU9RsGtH4DZpVIaEzcloF0NhtCQrQCUICCXIdpux1lSizXUkqrZ0ggyJsKvuDg8q1538EjmJptWeg7ZOFY6gUnKshxnmlBAzsAjuEGvMSDfKAARNFHS/6f3j7gadHeFPfXMgEL9kjidjpmxEhjL2sgXb77yftDm0F2OngxEIHTLGDchtfV2/JZQVbfqeEhjmX+JumBcjAFvt0UOTjVWZOsZq+fBoSydUULdx/pV+0S2fBMWmF5AKxDvWsGJko80S31UZOmNYmKwUCFVPc+O8JKytOAwx0isIf5KBnE00nYe7vi3h/d2i37OWQ+541Wf3UVzPYz1o1HNYW3ZFBNseZrHoKLyvHb0MiB/v6r1ToKgqy0rKopFmtwSgDfPobPCdV2fzHgPzCNOGBlHB7FLlXI2ctYFUODhFA1fy/jqXV/UfaVoQKEbUZTUqCflba49sRE/BjHxGYbWqZyetfpEr+y3CSm3qk6qLU6afsNWGn9nkvj69d1Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm/mempolicy: fix wrong mmap_read_unlock() in migrate_to_node()

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-mempolicy-fix-wrong-mmap_read_unlock-in-migrate_to_node.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From david@kernel.org  Thu Mar 19 14:49:55 2026
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue,  3 Mar 2026 11:12:45 +0100
Subject: mm/mempolicy: fix wrong mmap_read_unlock() in migrate_to_node()
To: stable@vger.kernel.org
Cc: linux-mm <linux-mm@kvack.org>, "David Hildenbrand (Arm)" <david@kernel.org>, Li Ying <liying3@sungrowpower.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>, "Liam R . Howlett" <Liam.Howlett@Oracle.com>
Message-ID: <20260303101245.22290-1-david@kernel.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

The backport of commit 091c1dd2d4df ("mm/mempolicy: fix migrate_to_node()
assuming there is at least one VMA in a MM") contains an error:
migrate_to_node() does not lock the mmap_lock itself, that is handled by
the caller instead.

So let's drop the wrong mmap_read_unlock(). Fortunately, this path is
very hard to hit in practice.

Fixes: a13b2b9b0b0b ("mm/mempolicy: fix migrate_to_node() assuming there is at least one VMA in a MM")
Reported-by: Li Ying <liying3@sungrowpower.com>
Closes: https://lore.kernel.org/r/aaZgUNxAyKC2IwuG@casper.infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1071,10 +1071,8 @@ static long migrate_to_node(struct mm_st
 
 	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
 	vma = find_vma(mm, 0);
-	if (unlikely(!vma)) {
-		mmap_read_unlock(mm);
+	if (unlikely(!vma))
 		return 0;
-	}
 
 	/*
 	 * This does not migrate the range, but isolates all pages that


Patches currently in stable-queue which might be from david@kernel.org are

queue-6.6/mm-mempolicy-fix-wrong-mmap_read_unlock-in-migrate_to_node.patch
queue-6.6/mm-tracing-rss_stat-ensure-curr-is-false-from-kthread-context.patch

