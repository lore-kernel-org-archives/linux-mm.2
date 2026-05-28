Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1631FCD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5057A6B0088; Thu, 28 May 2026 05:53:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7006B008A; Thu, 28 May 2026 05:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4106B008C; Thu, 28 May 2026 05:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 309096B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:53:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEC7B140782
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:14 +0000 (UTC)
X-FDA: 84816365508.14.4CE80EB
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf28.hostedemail.com (Postfix) with ESMTP id 095D6C0002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ra/Ithy0";
	spf=pass (imf28.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779961993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xx63pevhIvHmAd7I82DAKAH03djxp5+URK5s8BIYmFg=;
	b=OLLFYT7rPrMreo702QuXqXf8TyA9po1HnuGcPTFU+bwjVQNGTmPgM96Rn7bxuVM0Z5rtlo
	YaPA23zyGR2uGte0YgjwB20VThJ0QBKlvm9wYo9qHa++A4a/mPjOS87QPRYBfBtlkFWk9v
	ofCkfv0zPNrAyXquD6WRUcRryNiPW5g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ra/Ithy0";
	spf=pass (imf28.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779961993; a=rsa-sha256;
	cv=none;
	b=3ESQrulRbNiTesL2tdcKfBRxoN3NFPP9aCE0XInMRCIEZ16XNyIH/JRStEXnF8LUtbxSLf
	faVYLVtyExc7QfCyW3BkSHWMuA2s1dBiclDbMPPH/fjsWeA06KSO9IZnxGH17j83LmCgmR
	Cu/dr0+59tSCg0qiF8QcOjcHOAZzpXU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779961991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Xx63pevhIvHmAd7I82DAKAH03djxp5+URK5s8BIYmFg=;
	b=ra/Ithy00r6TNwU5FTp/Bc6N7TJJ4zwPoJ0OOASNlN3w3vqAf7tlS6Ybo8zwpqA7Ks4fl4
	uTIycdD+UIN8iXwk7lgHe0dHKh8BNmh351V7v5Ok0uONwmmY5unLd1JmF5ZMUMCnJlrN1k
	2Ay0OIQ98XfdOBWg3tyBruXtyh5OSLE=
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH v2 0/2] mm/slub: batch partial slab list operations
Date: Thu, 28 May 2026 17:52:42 +0800
Message-ID: <20260528095254.43721-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: aqz5kru6jj47by55j88qug9p6e8pfeur
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 095D6C0002
X-HE-Tag: 1779961992-972452
X-HE-Meta: U2FsdGVkX1+LHkUw5DFahSsdINyo8n5Ab6ljBMTZlj/kBHwRRL1WYwxgMplPgpYHimxVFGfhqtnQqhvwxjufSVNH+/+VBpWnE/f2EvhZyzChS2EcshP7tiouU2u59IAjYXbXlKPI3WIthWtUEtfZxSe+V9aNC0Hk1ox3vQGXCZ5mx2byhVT57SW/RkoSNtFiuQP2XmEhh5tA+/6mHjrXEu/sTDMg2PAti0QffwvvIF9b+z1GcyXMHx96wS0awv5iLZa9ND9Ar5YX4SilmmXOjkrN03eAC/BYDL80B8qpFy7oXHygT0rcL9WTtv4iDJHIpkJipXkMXbcKqyIgg4PbphsQ6Nnupf7dTR31Nx68EyuDRP9z35shrPKaFfhry1Ohd78kH4kUOOS3Cu3gqI732lyIOaIOwu4oH8qAP8eB71n0luhxatti8C6RlLZ3UC7n5OGDcozhImJFeKZFyCDuPEUvA0HH3lUUg8X8b0fVCo6v9rTMMlTSDY4DOZf0VgcY7bnUgOZCiqBflB95zZO0vrBZJFZ4zY8UTN8qWYInuATBbTxSy+I6MWB3o6Qw59f7EDK9WJl6rcjXy7vyCXjtrXh1yem3n6v0yWHqu0lGWfw+vg5Bjr8rve0DuhRfEyDvvlqxXyIXoAQ9aJ24gpU6/hz1ecHxyLkRQbrw3nsEEspJCjxLZeithU8FmWCRmNcgSXlsKG/cB3reVAgGZX0QYdlMhfx2qiRehsKGizks97+5ePQ1e/ajJiPm9U8Uow2+Guu8OcfZuzqZqIRS9dk6yKrfIurzL8dmPzVo/+yoYEiIhYGFiuV4Ew/iE0Kyc3wfA6IwAdOtQvMuFIub+xIgZriYS8N/mnTsohTn3HKkGfegz2W7r/69iMccg3JcWW3dm4aqo6Y6rrp+/lJbY/6FtPYDmc/Ha0d4qQ+BSiVRkAa9+BFpWqJWQyJFY320LGpEQsJFlBn35WERLOWmJNf
 6A0VbMmX
 BN+slTDVClge0JFQZT36M9eQat+ep5udljQ3kcfyJTlUgMnfKJGiG0O4SXtLq2txD7ftXL8Gja+leWLVSbTGnjGRrOIlBPlbMFZB4qEueegbxVjR5mtIBCB82/w7XCHs+HM5uANOKvKlBHVFg470P61hYni1yGbOmOjbaL9Np/gGVD9z12y8F8Nb2QC1Bk3S5vdoX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The loops in get_partial_node_bulk() and __refill_objects_node() perform
individual list operations for each slab. This patchset optimize this.

Patch 1 reduces the number of list operations by processing slabs in
batches, thereby minimizing the time spent inside the critical section.

Patch 2 is a cleanup patch that wraps duplicated code into a helper
function.

Changes in v2:
- Patch 1 apply the same optimization to __refill_objects_node. (Thanks
  Harry and Vlastimil)
- Patch 2 introduce a helper to wraps duplicated code. (Thanks Harry)

Hao Li (2):
  mm/slub: detach and reattach partial slabs in batch
  mm/slub: introduce helper to decrement partial slab count and clear
    flag

 mm/slub.c | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

base-commit: 6b41dc6749232c14f3e069f8115084a7bbeee402
-- 
2.54.0


