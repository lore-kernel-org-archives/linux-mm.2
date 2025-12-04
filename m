Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38515D206A9
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D6D6B0006; Thu,  4 Dec 2025 09:26:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E286B0029; Thu,  4 Dec 2025 09:26:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B466B00A3; Thu,  4 Dec 2025 09:26:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 774226B0006
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:26:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A606131964
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:26:56 +0000 (UTC)
X-FDA: 84182015232.14.B2E6E07
Received: from sender3-of-o55.zoho.com (sender3-of-o55.zoho.com [136.143.184.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6019314001C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:26:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=WCjS6MFX;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf26.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.184.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764858414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vwd613HLQXIyOP+YbNB/nPdle55ky5l9YRnVAz5wTxM=;
	b=8VnVqPsYGvLHxi+gdOj8KYygenMX92Ppo61WxKsveGpnNylzBpnD+fy6tKT6sGCTgVtyFD
	de/ZcSBWjagRuq2vv9EH6qg1sDwF+sMOGTYGgALjM1b27tiqT6pj0QBBC3NFuG+eTL4pix
	Ts6ab0g2Xkfk0YMUBKgjeWR7ZtQxZFU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764858414; a=rsa-sha256;
	cv=pass;
	b=bn/Ew2PS7LBZlTz9aA6CfWFqOiF+RJAWSaOJasxBzNj+aZUZYtu+fLsYAeGEy3jrhgV5aX
	y2+c2Hq9GW+9H/I+DAbVUc4D2do17hz0USggU2eahDHiEocONoQzoKQp/EkRSQWeP7xANL
	B/3yItQ86GuWquyMwSguzSeDrqcwUvg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=WCjS6MFX;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf26.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.184.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com
ARC-Seal: i=1; a=rsa-sha256; t=1764858403; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=TTQgZYZz/WhyLTUquTxhTANp/z34+MLx25M9GEfDYH7mJ5eZxtKUTZzMRYXFDMvkWJF5YActSjZ/ExiwhYO0OFiqTBlbppKOahlXzpz7skiHkudg9xnIxMF7kZpLg8VCsv/IP8BortDp5KunJYKwT6A0ULkZ1lxNI9Uj3fe4GL8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1764858403; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vwd613HLQXIyOP+YbNB/nPdle55ky5l9YRnVAz5wTxM=; 
	b=V3zxTrrfa1I9dHIyC0Yi0Xg1/9Ro1JDMFPCHvw6AgOMCrVwkgjWj1pMOa7QW/iuBgvEQU/GlqUvjWThbNYKfLWJ8lp65HuWyoIoQjBwA13CBr+ns25J2X/bIAYWol4sPdJhIwicZ7XmSnVPiJjT6NA49JiOsZRpKPZsQaHL8mUI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=mpiricsoftware.com;
	spf=pass  smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass header.from=<shardul.b@mpiricsoftware.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1764858403;
	s=mpiric; d=mpiricsoftware.com; i=shardul.b@mpiricsoftware.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=vwd613HLQXIyOP+YbNB/nPdle55ky5l9YRnVAz5wTxM=;
	b=WCjS6MFXQVRZZWATobxQyrmOQYFdqIWJ5xiw22MmXdLGIuMcRgJ4LyXrW7H3Pse6
	btQ6Df6IjMyvS9G4X/81wzrhhjE+kOfQ+iRnWdIbpS7TPWqiDWEhDFnxds3oIu9HVW3
	6ekPCO0+f8MS0mjx4ROsWo26IbBMjERkmK3UCSRE=
Received: by mx.zohomail.com with SMTPS id 1764858402454442.7495368017717;
	Thu, 4 Dec 2025 06:26:42 -0800 (PST)
From: Shardul Bankar <shardul.b@mpiricsoftware.com>
To: willy@infradead.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dev.jain@arm.com,
	david@kernel.org,
	shardulsb08@gmail.com,
	janak@mpiricsoftware.com,
	Shardul Bankar <shardul.b@mpiricsoftware.com>
Subject: [PATCH v4] lib: xarray: free unused spare node in xas_create_range()
Date: Thu,  4 Dec 2025 19:56:25 +0530
Message-Id: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6019314001C
X-Stat-Signature: anyk4t9pwp6iky75umq6kr836kxz685s
X-Rspam-User: 
X-HE-Tag: 1764858414-920952
X-HE-Meta: U2FsdGVkX19WjoSvzHcP98K1Ad9wCzrg83JrTXDVwb4bw/PWnc4s9KPKnpJPHNu1Sj7D3iqgOyYYS1xYDC4twKLsEYvucBcZMD9XMyNaEWzpqG0MrugQHhx/2tjkZPeBAve6RG2unspwEccan6B4K66Rkuu4d712MjS1BAd/floOySqoWgh6s4bYzmwkdQpeV6f8gqJE5W2ucUnwCxb5QcdrHNdXe7JiL82yYuB536DsyJfHEqQVbMbFCrH9QZ+CL97LoiXuI2z7cCuqR5mfnn95oZ6v0u1hOvzXhUXp0s4hKU1VXMhRdh2bzE7Svw9C+Lbyk/vfX+vnOaq3qA+YhgSMty5AYsQGKOE3iaoDBwsolFMr7huuaTkHOahSGMQFkuVzOVb9J+8OrOy3nhbWiqdEB0hOlDDX7VJNQBrWEpprsClXehZ41l0SGVgPEk5yxX6NOJ9EmUr9X4/9YP37435Ba0wmvLtwGsX7N6HADra5QP3zD/vjxPun3yp8paLtnpFolMq+0KrgDMKdwsiPoWfuzala5qISNopZ8Rd1Z2wSWMs3nykqD8MBCY5UGU2Rm8EXP7g7ODKf7NNAH3N1SZtnwCkyC29GZh7Q4UOvK91U8RMRYd1vNisPBQl2mB0Llw4VFYJV/AdTOEdq1Suvt3TkD+Zruam/VEKqe+B/j6VvA/p9e47Qu4NaX5Io8aZe/Zn2qLwvE6HSYNHoTJi/R9jZg+GJ1uQsvM5jfDnnYJrCKaYmyX2LnWjnGkxiimVoIl2jt8jAqtUF4esBiN/vgDaNYnfei1L1mlB1UcQzWBZkRAWPio20VHjJgWuv0pLTMNPBtFcUya9CzmDZCi5GpX5c9rX8uNn0SLkhcY6XoljO+yDmWTnziCWawlb4b6f4wXA9PzND7lEF93m12+WMte51TogyxAHaDp8yWUTtXQxZLEFSLJptph0shhpCT/7rmNyhJMDi2gbL/NMPeMq
 g9R2VXZb
 1oYBhLl6qEawuuFn4blsVx2v+Noy+G9xJo2d1PEISEWUd1h4+RiCgf57hLMBgcJlP2v87LNJElvxLUJ8K+OoMNlPqp1buUSUi3ru3G1GcPpa8L9M9/aTlDnvigocUSfCSUgzJ/wrzmo/DZeQsjrncElpDz8Q1AHM7UYlGdNX6Zmt7R3NuU/9HdetHftUIkB8bWPnLAnP3Etw6QZMaWGnK2miMKTH3NWRyRlWpv3rUEQrR7X14WyOWpxgshZsGpHOi5OyLYNLM5+V8mcfIklwavJm9Dr/7vSUbtN1Xi1b7c7dLNtHAgdl5tMdpewM1o159CAfMH/X4Bb+1zlc0gZZQLyH5Ja76ozNWO6SoayWRAXyLLUdE0cYoN444Nfp1B2v0DxluKGZmqtS94juq8Zcjc3yLCjwzI0FZNNOZPo3BG5S6pbZLPsYdwmnNTZ9UEv+kRc9UnDo8gGOT4gceCcPTq//3jfgXeIKxFq/1IH00Fit6sg9p5LIMiVWZFdJSd5IMa5fP5bHJ3ta9X/InPemp1sN+opkkwM/Q4QdL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xas_create_range() is typically called in a retry loop that uses
xas_nomem() to handle -ENOMEM errors. xas_nomem() may allocate a spare
xa_node and store it in xas->xa_alloc for use in the retry.

If the lock is dropped after xas_nomem(), another thread can expand the
xarray tree in the meantime. On the next retry, xas_create_range() can
then succeed without consuming the spare node stored in xas->xa_alloc.
If the function returns without freeing this spare node, it leaks.

xas_create_range() calls xas_create() multiple times in a loop for
different index ranges. A spare node that isn't needed for one range
iteration might be needed for the next, so we cannot free it after each
xas_create() call. We can only safely free it after xas_create_range()
completes.

Fix this by calling xas_destroy() at the end of xas_create_range() to
free any unused spare node. This makes the API safer by default and
prevents callers from needing to remember cleanup.

This fixes a memory leak in mm/khugepaged.c and potentially other
callers that use xas_nomem() with xas_create_range().

Link: https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
Link: https://lore.kernel.org/all/20251201074540.3576327-1-shardul.b@mpiricsoftware.com/ ("v3")
Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
---
 v4:
 - Drop redundant `if (xa_alloc)` around xas_destroy(), as xas_destroy()
   already checks xa_alloc internally.
 v3:
 - Move fix from collapse_file() to xas_create_range() as suggested by Matthew Wilcox
 - Fix in library function makes API safer by default, preventing callers from needing
   to remember cleanup
 - Use shared cleanup label that both restore: and success: paths jump to
 - Clean up unused spare node on both success and error exit paths
 v2:
 - Call xas_destroy() on both success and failure
 - Explained retry semantics and xa_alloc / concurrency risk
 - Dropped cleanup_empty_nodes from previous proposal

 lib/xarray.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b4916540c..f49ccfa5f57d 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -744,11 +744,16 @@ void xas_create_range(struct xa_state *xas)
 	xas->xa_shift = shift;
 	xas->xa_sibs = sibs;
 	xas->xa_index = index;
-	return;
+	goto cleanup;
+
 success:
 	xas->xa_index = index;
 	if (xas->xa_node)
 		xas_set_offset(xas);
+
+cleanup:
+	/* Free any unused spare node from xas_nomem() */
+	xas_destroy(xas);
 }
 EXPORT_SYMBOL_GPL(xas_create_range);
 
-- 
2.34.1


