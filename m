Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A035C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6867A6B00A7; Mon, 31 Aug 2026 11:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8D06B00A9; Mon, 31 Aug 2026 11:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6F46B00AA; Mon, 31 Aug 2026 11:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC496B00A7
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:13:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC6C71A017A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:13:14 +0000 (UTC)
X-FDA: 85161907908.24.48B1308
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 208F380003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:13:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EkqpdoSr;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788189193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ualF5+awGlDHLbOLG+wUlZuM4jd8jJfoQcPc7XMxhaI=;
	b=vPU/8/92qDUm5MiNhgWKJZ67ZvHxo2goG/d+Z3hthdHoMjIFo9f8omV4TkPLGJjao/TNlE
	Dmnlr6EoAakcTa/siIMUILkLruQK9hJVwDtlKfYQt1XrJm2NWNJ4dp91Qfbn8cDDk5vWad
	WMWXbluFkWpMEVr6dEl885C7vuKVP2w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788189193;
	b=Ch6YOkrtMjY+pe3Q5RXczn+aFebbTsQXkXRsKQqyHU46eOm11AWAUp5sBDroL7iSD7dNKy
	lETWFh6OyY6/l9rqxBCAVz0X7WyNmJLSikJvQdeUQa2sGypULocN6v2Ek5OrXhwaeheQQ2
	4N1tRo1Y+vrU6OEwFrkSYJCAHg5cN9o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EkqpdoSr;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B514E60120;
	Mon, 31 Aug 2026 15:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363E51F00A3D;
	Mon, 31 Aug 2026 15:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788189192;
	bh=ualF5+awGlDHLbOLG+wUlZuM4jd8jJfoQcPc7XMxhaI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EkqpdoSrLqrqJ+56jtIOkn0qQ5pYUzgkYbPaxtjasLmfcWU1udj5IEWVdg3ZSpHKz
	 /KCIqnl3daGW2Hi603OV1Bf7sifJEDj14cdAgZQ70tYdaPdV9sbHFZzGWdASQFvyHh
	 /qbzX2J379Fh8QCaEsGzunE0L/B7l9DCrMaVs4tuoH77I+l0Dq7B6L9IEAGSOD5uUO
	 Ucbh1XtkiNia6/hmDhMxjLLM06QDEWo2ZzXE3GqWaL9bI4j+TwWHG4gtM4ZVfEv1v5
	 JP09edUxkx6nI9Fg8a6vWVs4v9rlGM+oCg67G+Xga94HFpyFaRiqaN3ZYC80Cz48ml
	 GzqyvjbE0oD3A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 31 Aug 2026 18:13:01 +0300
Subject: [PATCH 1/2] docs/core-api: memory-allocation: add k[mz]alloc_obj()
 and clarify kmalloc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-docs-memalloc-guide-v1-1-547718c274c1@kernel.org>
References: <20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org>
In-Reply-To: <20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 208F380003
X-Stat-Signature: 1imnerpxsmfxs9bsp9f7cghthkg65yz9
X-HE-Tag: 1788189192-933522
X-HE-Meta: U2FsdGVkX1/Nu3CPuFAAhCaM8hObHoNNzhU/akF2pmbqOV0pQE9nWApo69tuC9kEIkYQB1mQuDMgmoVLqy+sMDE0Wfx59FjcqDYV50QY7U7sLwna+bVueZclOZryfkRs64SelkM8gW1zcMOvwv2VDKWuL57A+gqwZYnK+/viKxs9ftgAYvnmOWTY3NlfTirheoSXHXzxqRpkg2EhCVLU/5HEhcwBOENgUG2y3kVEpexZkp4WeRPH/d6i6DyQbdcJCxy5wnZKrPGgX3vX0uJzNv1GISDlPmljSFqM3ULSv8KpwPX8FsJFbFOVr2gZlTUe+13NnoMGo9lbTSpKC8NglzSqTO1UGkvOlrUIBCxpyaGIckIPsO/KV2PhoAHkD3IV6aiYIsTNQHP0j9X0ACmnwtziU12SAr6ivkGo7GJOAzkZBHHWHhJu0vgp84oUO/LhqW86d9PS1thppnxlwYOhkO6GyfZ5O8GwNdsmB0pFd1kOop00WzMrlJJHsH28HhD2wUYN6Etbvp1tvkWYfu4mcteRkUUSJJj2iI4h3Rb9z/XwpNARvDhqaFjyppEaj5kPhUcAyjnlTQ+OIE/ioi7mwsh129ZXnev0UdwssWLTLWRNZe7IU0UpTY8srf5wnM5PEirEK64UxClupbqNu1rwqoM5vP1CmAUMd8R8nD9bvp9p6beYhAFVGum38MJamOpXd6U9rBUk2AZ/NRSRYvkP5YIigRnJ7DGT6+nzhm8GeUYHQvQKs+m0iDRGZ38LX4UERl79kMYuKHzjvnjlasvwG3bHtlkoJ3oyaFpiQ9/V1B4O1KVse6y73gtgg+pvEf6RRpGBTabYhOIqp+fYZuBHQFS+2R92UFKf085Ubzzef/B7uli0WLnZP+XIDHdKuc9nxbvxXtFpWz2Td5kRWOk0fF3Oj8423JkvvKywnRf3D30j6vD9ptq4mHuVNF28yuEpmztH1a77EeT8kMSxPxa
 6yOTxcTS
 FYOGDO20buZ4LCcJ6vEkIa2auyphhvUsKU94SpnUgEp+4RZiWonbtDS4jdMBm03i2GN/fHxcnWbeQNV/II1l+eN8gIN/21cjyf6q/X7Q/b3QMDvlNmTDM46ax8kbI4bfqDT37zTP51omlSK+3BHupMBS+Gz5TuQCC7D3Tbimx1YS5PrMc+DMvTHRcTxDA9iA9CBNq8D2Ey5qblYi6q0JHtk2ZtHpYG4wLZnDzElycVc2uUpJLNg8+gxByt/oFQ8h3PMIXxxuc9upwMJHyKEsbr5nCXxRDBwQrCbx2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since v7.0 the most used memory allocation function is kzalloc_obj().

Update hte memory-allocation guide to describe k[mz]alloc_obj() family
and make kzalloc_obj() the first answer to "How should I allocate
memory?" question.

While on it, clarify description of kmalloc() size limitations.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 Documentation/core-api/memory-allocation.rst | 30 +++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
index 0f19dd5243239..8ecfa4d35f4f5 100644
--- a/Documentation/core-api/memory-allocation.rst
+++ b/Documentation/core-api/memory-allocation.rst
@@ -19,6 +19,12 @@ Diversity of the allocation APIs combined with the numerous GFP flags
 makes the question "How should I allocate memory?" not that easy to
 answer, although very likely you should use
 
+::
+
+  kzalloc_obj(<VAR_OR_TYPE>);
+
+or
+
 ::
 
   kzalloc(<size>, GFP_KERNEL);
@@ -139,10 +145,13 @@ allocate memory for an array, there are kmalloc_array() and kcalloc()
 helpers. The helpers struct_size(), array_size() and array3_size() can
 be used to safely calculate object sizes without overflowing.
 
-The maximal size of a chunk that can be allocated with `kmalloc` is
-limited. The actual limit depends on the hardware and the kernel
-configuration, but it is a good practice to use `kmalloc` for objects
-smaller than page size.
+Since 7.0 there are type aware kmalloc-family helpers that let you safely and
+conveniently allocate a single object or arrays of objects with kzalloc_obj()
+and kmalloc_obj() and their array versions kzalloc_objs() and
+kmalloc_objs(). These helpers only need the type of the object that should be
+allocated and the count of elements in the array for the array versions.
+
+As of v7.2, vast majority of the memory allocations use kzalloc_obj().
 
 The address of a chunk allocated with `kmalloc` is aligned to at least
 ARCH_KMALLOC_MINALIGN bytes. For sizes which are a power of two, the
@@ -154,9 +163,16 @@ Chunks allocated with kmalloc() can be resized with krealloc(). Similarly
 to kmalloc_array(): a helper for resizing arrays is provided in the form of
 krealloc_array().
 
-For large allocations you can use vmalloc() and vzalloc(), or directly
-request pages from the page allocator. The memory allocated by `vmalloc`
-and related functions is not physically contiguous.
+`kmalloc` always allocates physically contiguous memory and the maximal size of
+a chunk that can be allocated with `kmalloc` is limited by `MAX_ORDER`, the
+same limit also applies to the page allocator.
+
+Internally, slab allocator differentiates allocations of different orders and
+delegates larger allocations to the page allocator, but for the users of
+`kmalloc` family it is entirely transparent.
+
+For large allocations that do not require physically contiguous memory you can
+use vmalloc() and vzalloc() family.
 
 If you are not sure whether the allocation size is too large for
 `kmalloc`, it is possible to use kvmalloc() and its derivatives. It will

-- 
2.53.0


