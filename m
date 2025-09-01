Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CE87CA1005
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEBD98E003A; Mon,  1 Sep 2025 07:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4398E000B; Mon,  1 Sep 2025 07:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD97B8E003A; Mon,  1 Sep 2025 07:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CFD118E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:09:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BFF91A07D1
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:09 +0000 (UTC)
X-FDA: 83840409618.17.B909DDE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 528E7A0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AaRMkOJh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="F5uB/8aw";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AaRMkOJh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="F5uB/8aw";
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJhUfBeZeLxh7W8CevHKP2oQFWa3IdvgSf/9qDFU160=;
	b=wph3cEWCanUycGLNrVA/J40uoqIX7arZ+NWVZ0d2T/u9N16NyeSBAJd+2/VsEpyhF8KrhY
	QQvg0lK2KF9YsI4ngxNa1PO9XG875z4swdCzZaDxuMnVxHZo4ZAN6vPKL6C/71QcRxm5VN
	CCjwJIe6gIBLPsW1i+bSJzL00LDRneQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AaRMkOJh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="F5uB/8aw";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AaRMkOJh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="F5uB/8aw";
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724947; a=rsa-sha256;
	cv=none;
	b=c2ZM6loeQTidAXYGxIJ+T4dgALIuIs/lOsVbAy5nBrOr3gWJFVhA4TCBAg7+4qXMRX2vN/
	05F9A/SPgTC4oP9TMLHrhqUNbbEoUgsanQOMZS6H7iKV6x6QdF8S+h8ZFF8eas5CY5fhgs
	iCa+c2J1/k8TPuFiFP5Q4NJ5AwBxMaE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 82CC821172;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tJhUfBeZeLxh7W8CevHKP2oQFWa3IdvgSf/9qDFU160=;
	b=AaRMkOJhu2G5Ls8tX/3MWoxgZt1PtPRcguBY8N//JqYZ4b5ssCrQ7CkrPGE8M2fnw3cYIE
	AcogPqeQ9eZ93prsKeyYgkmeNJ0ObBj4A401051acjh2Be5ftir19Mas7UUVzUxkrBW5zY
	EGA6Uc7Lu4NsmcTI7+JnpTP/EhpfR10=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tJhUfBeZeLxh7W8CevHKP2oQFWa3IdvgSf/9qDFU160=;
	b=F5uB/8aw/r1QgzBsKcDoocYUNgdj+8Tn+5/lLVpwTQ7Cz4iLT3gcTLOiW25VF5wn8P+QFp
	9Ta5H7PcmlpRDZAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tJhUfBeZeLxh7W8CevHKP2oQFWa3IdvgSf/9qDFU160=;
	b=AaRMkOJhu2G5Ls8tX/3MWoxgZt1PtPRcguBY8N//JqYZ4b5ssCrQ7CkrPGE8M2fnw3cYIE
	AcogPqeQ9eZ93prsKeyYgkmeNJ0ObBj4A401051acjh2Be5ftir19Mas7UUVzUxkrBW5zY
	EGA6Uc7Lu4NsmcTI7+JnpTP/EhpfR10=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tJhUfBeZeLxh7W8CevHKP2oQFWa3IdvgSf/9qDFU160=;
	b=F5uB/8aw/r1QgzBsKcDoocYUNgdj+8Tn+5/lLVpwTQ7Cz4iLT3gcTLOiW25VF5wn8P+QFp
	9Ta5H7PcmlpRDZAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DDDC13ABA;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aOeZFsV+tWjtDgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 11:08:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 01 Sep 2025 13:08:54 +0200
Subject: [PATCH 04/12] tools/testing: include maple-shared.h in maple.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-maple-sheaves-v1-4-d6a1166b53f2@suse.cz>
References: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
In-Reply-To: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
 Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 528E7A0009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3545z7ruouqhxes3w1hb6d51hwh3kfe7
X-HE-Tag: 1756724947-56692
X-HE-Meta: U2FsdGVkX1+wpo3pUtWLNruaWc0LYp0StT7YWLtB+Ot1StPk/T5QGboTLb30uXC+MW4zp4SWsCSXsdKCXlPThrI2cWj0nVgtNQPS2e8ArVlNJ8Tf6HyWTosLuT9ALoWI7rHDi1AcVp+IMNpBeOQh7Soxh+719qIM5DXKv/Er5bqIUmdDl4Th5PHl1Sizb1jyiOmDT2zShN+V215ANrD/RDtTsWEjDuyefs4jOM4QuBLqU0x8zuMp8lFeTq3XGQp1nYPOATL1ie81aQuHI/5VjHcIY5XHLRICJHNganDsovZY86I66Z/vW1SLCzCGruJWZlAbez6L37rgEzpp8i46o/cAEnEfhh7ovHsguvOWJkEgBKJm2HLt3porqNomcILFQv7EqJLyiraxyGVSC+ORdMrmLgcUZTISl7bR+nuZweaUiLSDYebhxF0TR5ycbNoCY2LCw2faCwULbN12R5QkoIiwUflHhqHrO8qbjg1a8hIbK9jpiJ2VrKGYa6S9Jx4fcPavZbhTlsJK+CTwYNACtflNFg9fOkvlhSyL7zCuz6WIAIoHUuiAyEavXlwdfygUGUH/H5sprS6zv6R7kgkIsySjsHwNDD9v/cnMo+DRfanpFmggtnFfL5hMUMHK3OYYmPxmPzoNioS8eBnk6Tyt9CVWoe0AU321m8G68XCd1q978iLS2byMP5K18mDJ/3/4snlYn0PQL4pkm7LaZdH7iqZDjhb87TMJ+9/VwD3FxSceAhqIaCKKkBiBiwnLpedatb4xoH4QaCjvk7OECUyWkJ11JAmXvbHZd/zf7Ua9wz6TJeixRkVsBZMPifLNFjTFq0t7MCtlommtYi9tX7cC/zXCk9e/oWATcJvya5bHRdn6jsARmfnX0biQ5KU1ujT7fs1XgJqBEUbSD/YEKGq2/xXoRFMcqNLYiWFOtHiu6n0L3Jdol+3FaP6kiIdPLpgZO7dNYAKcPfgTSn1UZ7r
 ekOcc/XT
 eLPi3WGMXOjXr7FRaTmRjHHZxiWmyKfDUoeG+9K0LY2n9vhr0f0MKwbZqYPZDeFjgJJP0PpsWSEnnp4+OnYzSFYAiic3yL+1ovkxckwt6M3CTdURP3rJzMF7RoE+rAeLTp7+KhddX2K5ra1YS6wNWz5vIJBsE/uIp+atvaX9zd1wogsZupynDR5yYQNIbe7MwuqmtwBm6WSGvvIyzwaulBOfm+ewN+pNTdOLN9R8L4enRi7ePynAjrhSB9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's code duplication and we are about to add more functionality in
maple-shared.h that we will need in userspace maple test to be
available.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/testing/radix-tree/maple.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 159d5307b30a4b37e6cf2941848b8718e1b891d9..18db97a916f039bf72046c3ec3e7faffaeb5b755 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -8,14 +8,6 @@
  * difficult to handle in kernel tests.
  */
 
-#define CONFIG_DEBUG_MAPLE_TREE
-#define CONFIG_MAPLE_SEARCH
-#define MAPLE_32BIT (MAPLE_NODE_SLOTS > 31)
-#include "test.h"
-#include <stdlib.h>
-#include <time.h>
-#include <linux/init.h>
-
 #define module_init(x)
 #define module_exit(x)
 #define MODULE_AUTHOR(x)
@@ -23,6 +15,9 @@
 #define MODULE_LICENSE(x)
 #define dump_stack()	assert(0)
 
+#include "maple-shared.h"
+#include "test.h"
+
 #include "../../../lib/maple_tree.c"
 #include "../../../lib/test_maple_tree.c"
 

-- 
2.51.0


