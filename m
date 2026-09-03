Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3B75C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790636B008C; Thu,  3 Sep 2026 11:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741C56B0092; Thu,  3 Sep 2026 11:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657146B0095; Thu,  3 Sep 2026 11:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE546B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:50:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B130580571
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:50:14 +0000 (UTC)
X-FDA: 85172887548.20.E148717
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id ED3FFA0009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:50:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixu35zh7;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788450613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPNWvkEDUAJw+M0V5DscJNLnjX28HgRup/o43yOuiB8=;
	b=qMFZftMWT91pBxaZsR/5n8uyEUOp0y3k5uFdHixtqDmST7Zj7uy8gtpXW+aWoY94lUGC8v
	XgU1rUBSdJVuYjlKmOb36fe/sHd5d+NzrnHeKT+DNQJyCexB/0yKk5dJvMW0zh0/kKcL7v
	e6ZKH+4Md9bJH+87MSVAEEuPBUbTF4k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788450613;
	b=A/30LQTfkSC9GWV/PLJt+NlL+UrX2zV4zmMRT9W0qAybta468jbGNrqSDqkVxuVx3e0o1i
	yNlpe29t6Qoq3ga3NG7UrtlOqQM2M3LO3rhu8WOsdYFLU8/5TymV5g0CkYVT54dKljLpTu
	Qwi8RcPsWu0IaCZ9h9zqwvzX4RSIOPc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixu35zh7;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D02B43C54;
	Thu,  3 Sep 2026 15:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E674F1F00A3F;
	Thu,  3 Sep 2026 15:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788450612;
	bh=mPNWvkEDUAJw+M0V5DscJNLnjX28HgRup/o43yOuiB8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ixu35zh7QD27Tqvzurmn7hUrdPhUWY2Jj5GPigjtjTOoZHCey3Nrj30X5NcP33ffM
	 6LQBnpbqCxGxH/K3do4zpDhcOz0HNl9Ve6VTX6mH/wHuhgc0LVlx2nFke7S5OX0mGi
	 bUFWVixLPLPPLt/euGwch+HPkxuwsaXIPfGXPjhAmdEtUqeY+fyfpU4NHdIVrbKbBw
	 K62EcK20bSg4RwctzOXE034YpwjdG0eoW3ze4+eopgXxKdO3OH1sbDHGeXzA0JLsRg
	 TCOCZV4zawrC7y+UVeGSUjFwC//xyLvOFJxiKYOSaHeLSXF8ZKSvUGJ37yAnjjBJX1
	 /zNR9364P95Ww==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 03 Sep 2026 18:49:58 +0300
Subject: [PATCH 1/5] mm/execmem: free ROX cache chunks only when they span
 an entire vm area
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-execmem-rox-cache-pmd-v1-v1-1-11beb2a3d249@kernel.org>
References: <20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org>
In-Reply-To: <20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Tissoires <bentiss@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ED3FFA0009
X-Stat-Signature: dkzrbc8jmdnrhduzekfhanpm3t8mec49
X-HE-Tag: 1788450612-455456
X-HE-Meta: U2FsdGVkX1/TusZZEDCIykGWwWE4jT8EW34P/Mlzw8RUimKpedxrIVrkdR1eSUrgjqnZeTtSBrjxoEdkv+bynSgfGfp7uJUk+AV3VE4XIq1OrbqaPpicBiq0pnPdxmf79D0uNI4WG+sRef0/h+0EbRa6J/HsE4ZljVoPUXwA4lFlKECp99LWiGa+P9XsgeW5f6Q09kV92wAulo9fm+FmMVS7xBqoEr16GJiyMvlxuTjPhSchMHI7HE3eCY5JovsXxhqcK80hZwn04IPnavT57L7jy+EgrPr5LQCi/68XDSI8dDpEi8+NDWDRw/izR5IeBO+iMg9ptZV3HPBWVrNwrb3fqyRjMzsBBIJX2aAfeGybwk0MhmagTdx1Zpbu0tJ9XjY2UHZ4UJPa3VRf7S1mz6weH5uTEu4LggVIQ6sVp3U7C6i/PF5j1bPhRm0JZ8KyHMHj2e2PWuiKacMxapnq3DJueC0Eki/P0ZiVvsgWOLBXgTHy7I2tTYrQzolm/xl+DdohtUtZ0Ta+/et/DKia5xwE/EmXDHe2a7juFXI6UOJesXbwqE0ypY0hZUQAdx8oW3F2YcmjeQb7iYVQRQPjd9l4qFyrrzqymsf6O9Z2X5IMl16uBzaGashsbkLy69dz9oMsJfK17TXX3gDHBQ9VZMTs5gCO0cpS7+ocU0SB5VwPlgtceXcX+1dJSJ5wAkvgyWm471R19pOszVg4aZMoCy4V8Tpu9ZUOSug7gX19MCvOOy3UzTd+q7UnBZ5HhUNQVm4jjl35v8u7eeZvH0LdntJFqfn0SXJMouVYFOivMpQdHBLm+Aj4JOLD9XZnwEqLJrpc/qzYRzLFMcfBfRVH4lAJTzjM33vO0LXBcqrxE/VaIjzEs+gHqyfLygiU3X1diDiMrZfBS/aMZxExIJH6uCHEWoxxJsF6amjofj70orWzKUAaY+wo88GVkYOuHthRDHE7uSt/lqjasCEuyiw
 Rfrr1wCY
 +nocxWbNnn7RRZyVoeAkqShFiCL81fRpNOgxALsOWNn4NjHKgHJrd9anvTUnJLE13fmv7+yIisdmJufskfvJsLukZwKYDbDkyHXZ1zwyaYBvD+l3M5of99oHLJbgR0jPANgrSv4o0sqh8YXNeQ0AunZHsGUnglymnL5jCK2yydteQ1dNsjdFjUmjCjl37f7w90T6RTjwgpXDzcVtv31J2IeEt3A9ro2qXhZHLPNkX7iz57A1lpUPg0GS86g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When execmem refills the ROX cache, it vmalloc()s multiples of PMD_SIZE
aligned to PMD_SIZE. For every such allocation vmalloc creates a
vm area.

The first part of the vmalloc()ed chunk is returned to the allocation
that triggered the cache refill and the remaining part is added to the
cache and handed out for subsequent allocations with execmem_alloc().

When only the first part is freed, the entire vm area remains in the ROX
cache and can be handed out again.

In the case when the first allocation is larger than PMD_SIZE and the
second allocation from the freed first part of the chunk is exactly
PMD_SIZE, execmem_cache_clean() will free the entire chunk while part of
it is still in use.

For example:

	/*
	 * vmalloc(4M), return p0 to the caller
	 * add [p0 + 3M, p0 + 4M) to the cache
	 */
	p0 = execmem_alloc(3M);

	/* return p0 + 3M from the cache to the caller */
	p1 = execmem_alloc(1M);

	/* put [p0, p0 + 3M) back into the cache */
	execmem_free(p0);

	/* return p0 from the cache to the caller */
	p2 = execmem_alloc(2M);

	/* return p0 + 2M from the cache to the caller */
	p3 = execmem_alloc(1M);

	/* bah! execmem_cache_clean() frees the entire 4M chunk */
	execmem_free(p2);

Make sure that the ranges that execmem_cache_clean() frees cover the
entire vm area.

Fixes: 2e45474ab14f ("execmem: add support for cache of large ROX pages")
Assisted-by: copilot:claude-opus-5
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: stable@vger.kernel.org
---
 mm/execmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index ad07cae9ed585..ba277790e3132 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -143,9 +143,11 @@ static void execmem_cache_clean(struct work_struct *work)
 
 	mutex_lock(mutex);
 	mas_for_each(&mas, area, ULONG_MAX) {
+		struct vm_struct *vm = find_vm_area(area);
 		size_t size = mas_range_len(&mas);
 
-		if (IS_ALIGNED(size, PMD_SIZE) &&
+		if (vm && get_vm_area_size(vm) == size &&
+		    IS_ALIGNED(size, PMD_SIZE) &&
 		    IS_ALIGNED(mas.index, PMD_SIZE)) {
 			mas_store_gfp(&mas, NULL, GFP_KERNEL);
 			vfree(area);

-- 
2.53.0


