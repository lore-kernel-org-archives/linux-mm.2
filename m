Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EF27CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 09:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E39D6B008C; Thu, 21 May 2026 05:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB396B0093; Thu, 21 May 2026 05:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498186B0092; Thu, 21 May 2026 05:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3654F6B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:07:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0022B1A02CA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:07:36 +0000 (UTC)
X-FDA: 84790848912.27.FE15F56
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4E3BA18000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:07:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qGfzm4vu;
	spf=pass (imf06.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779354455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6PIi1QDLQ8OiWtIk4Ayg6HwJRAUJXMtOoaQbIBan90=;
	b=o/wxNqZ9o1EOIzXnnspf5C78rVBqtq8WN+fDddnTgAUrUaanymmfT/vU/jynXZl7RANnZ1
	hnx9mpKV7zo971uRFA46na8otOH4D0Xx5zAfceVBotKGJJOHY8th9yrEoWXkWBv8Qh2htr
	SLSbfdezYXj3DHFTmFg9YA8kZXGMLFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779354455; a=rsa-sha256;
	cv=none;
	b=kcFJXE6Wyf+hJnpkzi/EgxOoBX3AgxMMZ+4Zc8s/aKs/NAk/dqACSQ3mtIBw9bMSKLjAGR
	KVe7RU0Yvg85as0/3O3HAaFzuZlqcsP0MCCSp/iSZxK7ZP6Y1riSElHOIlW0WVmoPQHBxX
	WpN3gJbkXOCz2xsEiHRVtelz1KLxXt8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qGfzm4vu;
	spf=pass (imf06.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779354454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q6PIi1QDLQ8OiWtIk4Ayg6HwJRAUJXMtOoaQbIBan90=;
	b=qGfzm4vuEPBnDO187cwa572J3ejFLntC1T/y7X1WjBIPlOg3kHCqJdTijZrXfSErHvbwns
	5Vf3ljA32GuaKOtDg7JLcOPDLwhdgg+C0a4YAmn5OfeMYO487+rkuh++OARMWcqPBM6zW/
	hvOMHpTIA12WgP8Y9knM9oZomCfTa3o=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	David Laight <david.laight.linux@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH v2 2/2] string: use offset_in_page() in sized_strscpy()
Date: Thu, 21 May 2026 11:06:58 +0200
Message-ID: <20260521090655.160282-6-thorsten.blum@linux.dev>
In-Reply-To: <20260521090655.160282-4-thorsten.blum@linux.dev>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=960; i=thorsten.blum@linux.dev; h=from:subject; bh=91QQINpqJQ4LAne0V/WZIX3VWZlJe2bHssd2YEiaLxo=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFl8p81fnDSdb7vixZyanNulm5Xna/Z33i5Y61e++1dBR sO/lTy7O0pZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAiPd8YGf4uahT3FL1nzpNe wzrVcaPbB6/ZepKqMeePsR/nWnJqXw0jw7bW7/MiLqk+VfKXfjiB5bR/4gQnBc9ji7e5mxzadfT rLlYA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4E3BA18000A
X-Rspam-User: 
X-Stat-Signature: sdnrakppohu7ehyacj7b6qxogd7gj41o
X-HE-Tag: 1779354455-776243
X-HE-Meta: U2FsdGVkX18vNMDddpGyhVpCnEDBzpkX1FByt4yaCHNIhx6VsVHurY5+9ArSAQZ78UDTrVRf5Xd/ZQfAYraAHiWNEOxJnff7AfA/HVEEJH1hXg0F2GANif4Rc2/B20jmDliyU3Ay4f8V3S4KqLUvejhMQLo4vfFnDlLPRaov1NMTvgP4NTjj9zp3evg0N1Je2FCs1PWqrJtZ/1++y63YJPfU5ZpLzuHh79vrVSwTxD76RntEMPzyRbwDmW+OsA9rH0mlXtgDNFGin048yLdgxro9FtTs8pw3nqIK/CRA6CYWyTVptrB/UTLWtBWaHDjuw+8Z+8xhWPCPEnSde+NB8ZRqpU1Pi+/Wg6wj6B5uI4o+yRWiVWKozPA3nvtxgr9wf/2vvYZaGTjCgQDg6UkRUf5TbcNk1NiaYOR7lwaYUZzOnu2Fxyd3egEmuc3U5vS05cXAqpvc5dBpnNe7cK0SMX/d2RPIHC1aKAZREDOSnToikvUYvxIcOtVjpc6fykoVj0TK9JdKNTulR/8fEjEv1pljdtAcQp90gBr9lGwGY1R50g3gWz6Fp0pL/0w8KikSqThPHrw2hrtn0O1Q0dcdnoXyxiPdlpZr2yQ5GdyZv/JBeNPO1SPjdlmTOr/az9uVzhZHG1tNRcn5g0sQlqaWIw2RhIUAZ+XcZ2Mc87AsXVbu4qrwHAgeccdYzeBvp1Z3FSPTIwgGJ+TDSJn0Hsc2mh2a41iQx/rF6hnFSEUbmI2APUqv34dQZZibc/VCbl2eS3K6E3SbefH6fZXesod/YurvHQbF3izwrKo9EQlRw/gl9qkWAhzarqLlQUc/PiNniMisrelGDVY9MquV8XrY+FWorN+IiMTgWF9VjaGUIjHyZlC7cOf0/+ttxsL5VYddRZeXxDQeucfWgYapBLIrBhaDuHtMaQOjiILSSDqUeaCgkWtSGEUnWr0HwJWsgfwKyxVdlBL7hbBwFSY8T/+
 +lXof2Hs
 DJ7v7SpmQGVKR3NGd/len1BORcSj+mIeXn5acKWeD9Bbg0pBbzSZNy2RCgKpKb3VLqox9/2SpdFGY4AFJW+rSWX8C1tnd1/oTZdsshk1B/oRrWtAOWZOv6fIUvU74awIUD6B8U1SEr0lmYO2e2kMseyPfawfZxlIN2yGV+9vk+U1tiytatSjmt1ze68bQIsTggos36AId0Hh5KHFPTWxndHB/P5KzKWFBZcl+00UZAMdFq5BVVw0ZDbWDI/7zY9pe3CiZL+Bt0C1H9QdIaRrXztSqfXtOyd11yYes5xWtbS/1qWoxd98RgSS/LCUeHDIrmIZcISqvszRqak2wAtsPGB46LPouYorwsFWG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the open-coded implementation with offset_in_page() to simplify
sized_strscpy().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 lib/string.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/string.c b/lib/string.c
index 1f9297e9776a..7c72adc7377c 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -25,6 +25,7 @@
 #include <linux/stddef.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <vdso/page.h>
 
 #include <asm/page.h>
 #include <asm/rwonce.h>
@@ -127,7 +128,7 @@ ssize_t sized_strscpy(char *dest, const char *src, size_t count)
 	 * since we don't know if the next page is mapped.
 	 */
 	if ((long)src & (sizeof(long) - 1))
-		max = min(PAGE_SIZE - ((long)src & (PAGE_SIZE - 1)), max);
+		max = min(PAGE_SIZE - offset_in_page(src), max);
 #else
 	/* If src or dest is unaligned, don't do word-at-a-time. */
 	if (((long) dest | (long) src) & (sizeof(long) - 1))

