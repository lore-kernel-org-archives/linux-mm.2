Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D471CA9EC5
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 00:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218DA6B0092; Mon, 12 Oct 2026 20:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3E36B0095; Mon, 12 Oct 2026 20:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043746B0096; Mon, 12 Oct 2026 20:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BECCB6B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:27:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C74040B17
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:27:11 +0000 (UTC)
X-FDA: 85315713462.03.B23D667
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf23.hostedemail.com (Postfix) with ESMTP id A7766140002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:27:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf23.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791851228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0mt4b01kOfcXnAz1LUgDmnRLi6Q7TzAhsoplei93UnE=;
	b=AEQM3+xpoz0bXBrBeA6ZUl87mXTQz6JWfAGnqCz7xvUlGxKdc+Mv9ali2+1dQyGG8/5SUc
	Pzlfr8rNJmdbfXgQnyFT9bwj3LfJGCONrzSlEvEJgYBivpwSqUctU7jTu/8CraySp5tGMh
	WgE5YxXJUKhN4kGGsa4MJBrIbxIxeyU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf23.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791851228;
	b=zuEYajfV2d0ajw9yjGx9eEzXOkGe/IcJEzVmiLr3fWkXkFZ7LXj1STsPVl0e4lF3MKQ8eq
	zAkHfzJ4eflOl+MEwuzbIQb1mOOJikALK3/G8wefxUG7kdtQJSFQ/txkngwah45JTMiNVN
	i7jS1mg31mCxwU7Hi1/gvnr9Y6smd/c=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xGQMC-00GgqH-8r;
	Mon, 12 Oct 2026 20:27:04 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1 2/3] ida: free the bitmaps that ida_alloc_range() fails to store
Date: Mon, 12 Oct 2026 20:27:02 -0400
Message-ID: <20261013002703.773923-3-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013002703.773923-1-nickolai@csail.mit.edu>
References: <20261013002703.773923-1-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A7766140002
X-Rspam-User: 
X-Stat-Signature: 34kk4das194qrtjfh44fkh68mh1khj8n
X-HE-Tag: 1791851228-800854
X-HE-Meta: U2FsdGVkX1+3uxD1NxMxnhRwb+/BJE1bJIbh7e1rF3rWSAvtqDHmIxpcxaFbJZz8ScqidLXAocQXS6NLNqBobfCEYE01vlmbtkPYVC6ibxRdmIiljVmeEeKANbaX9QUAOjPD/L2clsso5MRKkC3xXHiTgedwyI8AxAoQe+Gmgu+OOYICyj7tMpZX9lM/KmDVGc9uKgZ9w/D7nD/XWSfQhLfq2T4slPMFvjVk58mzFZz+6lmZy/SxSpPT3OmA7SgEC16vYnohyJKj0810XBCuLbnPeeqfgUW5PWmcMXoxGI3dvc1YcONOfwdsD2matZecNhpKbhKqGQfRx0orGl3Mk3x+ukELNQ+6VU48ojqMVpdfR4LEXil4JDXYKuN0WAM67z/t5hc2GAXK9VpqDW10pe92Sbhz3PQk+JtFQJuIkoneA1338+/nmt1ssBVgP6WkUnUTlJRjWE3IePsX3cdCa+cui1n/BFyh/z6ruHWVKdcHFHdf3rVGfzKQtiNZSmc0hDbnO3XdFfPuFVrt8gzWEpQqMm9uGWBug0q5XshWOC9bErqpMMpHGHdjklGU3rBiCL4p582piZax7IYAUCln2XX37YfzO6+vcZdEvAb868jWuTPLRupIANgT2JI7NnCFULMK/qDSCb7UUoXzAzKWTTGALExQL8W1dldbNFBIjkK4uWGdu1u8e4uyZ4BjtIBtJ05TjphE+lLpJk8vhKLdaQk6nXG8FQA0Ir8tSSw4ayTl/eEf+F2zNXMLtjR3/W0Wp+Xg5JW1iz4fQT6odb6E9NkUT1KNUzEOiEx4cSQS8oN9jBKYaEnkvmcASydP0Btj+lBU4Ta8iurqbU9t3agT+Qmd51igANTgG5jr0SsdwNGYus6M7SZBJOMTXhk3q/nYtCsohuyYFxZeWykzgw5yqu6wUubUBGyEiOqrr+aL1axxRk7sWlD+A2nm5Iyhe0m5oe/CkyG9IVmprofIzZG
 1kNEUKhz
 EQhjeSTE6ekvWCyp4kYYU9j2HPIVH3aYD0nDlBJgMiCQZyyZzVs4pmqZdUIp3r52CpWJf4q78AFwZxFmpZDXlsDPaNVM2utSUDqmKouvV3nb+TrvKx7/q15DPkNnN7tMwj/yCP9vus8j9lshNurD2O9luVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When xas_store() in ida_alloc_range() fails with -ENOMEM, nothing has
been stored, but the function loses the bitmap it was about to store:

 - A bitmap allocated with GFP_NOWAIT under the lock is neither the
   preallocation "alloc" nor stored.  If xas_nomem() fails as well, the
   function returns -ENOMEM and leaks it.  If xas_nomem() succeeds, the
   retry overwrites the only pointer to it and allocates a second one,
   so the call succeeds and still leaks the first bitmap.

 - A preallocated bitmap whose store failed is not freed on the -ENOMEM
   return, because the exit path takes "bitmap == alloc" to mean that
   the preallocation was stored.

 - The value-to-bitmap conversion resets word 0 when its store fails
   and then loses the bitmap in the same two ways.

Each occurrence leaks a 128-byte struct ida_bitmap.  It takes a
GFP_NOWAIT radix_tree_node allocation failing right after a GFP_NOWAIT
kmalloc-128 allocation succeeded, which is what memory pressure looks
like to any ida_alloc_*() caller, such as create_worker() allocating
from worker_ida, get_anon_bdev() or the misc device minors.

Hand a bitmap whose store failed to "alloc", so that the retry reuses it
and the normal exit owns it, and free "alloc" on the error return
whether or not it is the bitmap of the failed store.

This was found while formally verifying ida_alloc_range() against the
kernel binary.  The tools/testing/radix-tree harness cannot fail a
GFP_KERNEL node allocation or let a GFP_NOWAIT kmalloc() succeed, so it
cannot reach these paths; a user-space copy of the function with fault
injection at its four allocation sites leaks one bitmap on each of the
three paths before this change and none after it, with the same return
values.

Fixes: f32f004cddf8 ("ida: Convert to XArray")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 lib/idr.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index f298660f5c80..86c572e60f75 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -424,6 +424,7 @@ int ida_alloc_range(struct ida *ida, unsigned int min, unsigned int max,
 		xas_store(&xas, bitmap);
 		if (xas_error(&xas)) {
 			bitmap->bitmap[0] = 0;
+			alloc = bitmap;
 			goto out;
 		}
 	}
@@ -450,8 +451,10 @@ int ida_alloc_range(struct ida *ida, unsigned int min, unsigned int max,
 			__set_bit(bit, bitmap->bitmap);
 		}
 		xas_store(&xas, bitmap);
-		if (xas_error(&xas) && !xa_is_value(bitmap))
+		if (xas_error(&xas) && !xa_is_value(bitmap)) {
 			__clear_bit(bit, bitmap->bitmap);
+			alloc = bitmap;
+		}
 	}
 out:
 	xas_unlock_irqrestore(&xas, flags);
@@ -460,10 +463,12 @@ int ida_alloc_range(struct ida *ida, unsigned int min, unsigned int max,
 		bit = min % IDA_BITMAP_BITS;
 		goto retry;
 	}
-	if (bitmap != alloc)
+	if (xas_error(&xas)) {
 		kfree(alloc);
-	if (xas_error(&xas))
 		return xas_error(&xas);
+	}
+	if (bitmap != alloc)
+		kfree(alloc);
 	return xas.xa_index * IDA_BITMAP_BITS + bit;
 alloc:
 	xas_unlock_irqrestore(&xas, flags);
-- 
2.53.0


