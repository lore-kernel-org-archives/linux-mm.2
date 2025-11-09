Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63B5FCCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 19:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08978E000C; Sun,  9 Nov 2025 14:49:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF4F8E0002; Sun,  9 Nov 2025 14:49:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACE778E000C; Sun,  9 Nov 2025 14:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9ABC38E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 14:49:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65103C0A4B
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:49:05 +0000 (UTC)
X-FDA: 84092107050.25.26F54FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C2556C0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:49:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="idA/49uo";
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oNxp0bjO;
	spf=pass (imf28.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=reject ("signature check failed: fail, {[1] = sig:alejandro-colomar.es:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762717742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:resent-to:
	 resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=jX8msigRXIApZg9OK2U1b7wFE91+OTEGS3ZaY6JDHQU=;
	b=GUd2V92xar3I1ubaEnFkczTQKRk32eYI+mbCzO7kSgsxlKP+mJsDQsnq6RWIchhUJOp6Ea
	ogQ5ZtAC89RbCBT3MFto0IfEzJKxDcmlpuDPAgSWhOGeI6zhRPKNN1azlDJy2tmbREEAdd
	bKPo4DIDCsGpt89hPlbwiSEATqmrpOk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762717742; a=rsa-sha256;
	cv=fail;
	b=q6hVMVQjzkw8vkVWYW7EKXmRFfaB4K2Q71v1At1PstdLFsRGyzO0NzufQcSotxJDcxxjCa
	QaAvOEztX7ZsReYMzVTf0f7taqUZpyV/UpriV9Ib5+0KsqcDhR6wYoyx/XJU94sL0YZvOo
	0eqH6aK/0IXMTMKC/94DWvma/OHB6Q0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="idA/49uo";
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oNxp0bjO;
	spf=pass (imf28.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=reject ("signature check failed: fail, {[1] = sig:alejandro-colomar.es:reject}")
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EDD660010
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C722C4CEF7;
	Sun,  9 Nov 2025 19:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762717742;
	bh=kaO5/IVrebOzmYLwKVSEsBGlfzzeuU+iOQME8bN/Vgw=;
	h=Resent-From:Resent-Date:Resent-To:Date:From:To:Cc:Subject:
	 References:In-Reply-To:From;
	b=idA/49uoQB1Nz9HG08wqiiSTZCj0qOCZd9J5menFA9tuSL3n9Kcxg2WBjgLzqvm+P
	 UAODqbXd1g44bCNskk9jsIEgb3mnp4vJc97/6JcXi1zMLTxWTmc7A9vrbwRlNnhOT7
	 TJJ0F27Vk7mQrpABr41jWe07fQBOQHCPxnAwFib9GwacMsxcHrPbxq18govUnUw/vl
	 xlnDhwWo97gsZ8HUIfA7SEjXfyDw1U414e8K7ReSAroWmxg32XKxIQtqNkLuvXTdRo
	 bgL9jSe8L8bKZ3iOdyT1Hv62u4fOs4oTqqmtF99Q7z4chylQLkNuYweB3liffo96M0
	 oM+uIuunhVzVA==
Received: from mp0.migadu.com ([2001:41d0:303:e224::])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by ms17.migadu.com with LMTPS
	id CCgvI27vEGmVSAAAqHPOHw:P1
	(envelope-from <alx@kernel.org>)
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:50 +0100
Received: from aspmx1.migadu.com ([2001:41d0:303:e224::])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by mp0.migadu.com with LMTPS
	id CCgvI27vEGmVSAAAqHPOHw
	(envelope-from <alx@kernel.org>)
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:50 +0100
X-Envelope-To: foss@alejandro-colomar.es
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=alejandro-colomar.es; s=key1; t=1762717550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jX8msigRXIApZg9OK2U1b7wFE91+OTEGS3ZaY6JDHQU=;
	b=p6U+Yfpl8BZKqNby9N/fgVhnxR2CT/riJLFPig2hRklY3MfouLHl54o8/kiyahXF308XfY
	hcJ9f4b2jKGRwAgam6R3qqCqsAo1km7MJn/ZNsKp0oqARHRIpH74481+MLJs3iB9QyJE+o
	OrtDRgaxaX/iI7fdoRpfSGkEVovc2k/9VQrOi3xSh73aQUZxnFSCGv6kVLbOKjoxvbjYqM
	Nm88x+0Tz4llMFLMj7qDmTA6vEqSm3GvmdtEXxzTRhuT5SQs7dtE3m3h+5S6LrspoULlDT
	Yhvlv5hr13eVGMkMbFxU6YA0iBC963r1984MEB2z/jO/jhwKUuVXOj8RGKfJaA==
ARC-Authentication-Results: i=1;
	aspmx1.migadu.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oNxp0bjO;
	spf=pass (aspmx1.migadu.com: domain of alx@kernel.org designates 2600:3c04:e001:324:0:1991:8:25 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=key1; d=alejandro-colomar.es; t=1762717550; a=rsa-sha256;
	cv=none;
	b=UyRylDON+FCRJ/M1y/LKNhqS5tuFMuajqMt8hiXajM8UVkigghddvBVrn9K0RzctFHwz9E
	QMcZbfRI60eUtrOaBOaAxNkcgDAPCI1oCAhiW7+QuLi0xZf3zx21F48oR+lBsAMGNr61Ga
	98eFKW7JgeieNBOGWiCJ83X0UxC/DUtZZneVDFHq7aHfhzirR5l/C2MQ0R5OOC4xZosawO
	ozHLOLG1E18mcAX6fgR2X25bCjnCxXE2b19vNqLOSA6g8xijTE0X+lBLgxtjXV7/J6227e
	13G5cYBJnefZAis3GNbgeC7DA4OcHJCt2fVQk4dulmzPx0Bp4cEozJsfAlm0Ug==
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aspmx1.migadu.com (Postfix) with ESMTPS id 3A1A3CF432
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:43 +0100 (CET)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F59760010
	for <foss@alejandro-colomar.es>; Sun,  9 Nov 2025 19:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 06B96C19425; Sun,  9 Nov 2025 19:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E51C4CEF7;
	Sun,  9 Nov 2025 19:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762717528;
	bh=kaO5/IVrebOzmYLwKVSEsBGlfzzeuU+iOQME8bN/Vgw=;
	h=Date:From:Cc:Subject:References:In-Reply-To:From;
	b=oNxp0bjOAvsa0Lb+vuYK5NWUqIHpS+NZERhHFW4TqreExEGs1Ujpc9OzjtRdEqmmd
	 rInqVtxNh824Ho+90BpwQ7jRyghuwrsCK716/xcgXv778eWLNOloPyA4DAoq1eZjQy
	 kPChbSoCfSGIehHd1YysDmf1EkemtwaiuYKUqyxIDEuxMfN4V9WNsbebozayzbkh6T
	 OVUwltoEPQMpphBmIJhI3XiJWWTfo8yAL2EBRyxRHGl4HCLbCMhIa1+3VFkV47eJMa
	 oEgMJNmQ8WNTmSH9wTCUunzXlIsWFVBsKdg5Wl0dFY7qTo6cqkvPneikOpmaowDwbp
	 68YybM6Oh5f5Q==
Date: Sun, 9 Nov 2025 20:45:24 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v4 4/4] mm: Use ARRAY_END() instead of open-coding it
Message-ID: <980c8fe8a6de9409f241334262a08538a39a353f.1762717358.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1762717358.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1758806023.git.alx@kernel.org>
X-Migadu-Flow: FLOW_IN
X-Migadu-Country: SG
X-Migadu-Scanner: mx12.migadu.com
X-Migadu-Spam-Score: -3.12
X-Migadu-Queue-Id: 3A1A3CF432
X-TUID: O4mvHhl2plsn
X-Stat-Signature: pomd31r81m36f3hqy9cp5u1agao3wjx7
X-Rspam-User: 
X-Rspamd-Queue-Id: C2556C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1762717742-674159
X-HE-Meta: U2FsdGVkX1/dCZtNFmeaDXw9oP7ZIgvAGWnpu7AYpznhW/X1Qxs7CFmUAMJsLyrE2TGKWhGcm2D+C/XfiQWSPKFXpFs97MH3qZXY5HkPKZ/yWVp/bZcC4ViPe7OGlrKds5jSNSRLzjAQq5ODRGiZWSJ4lY39YK7zXf8sVeIdCFHNisbvhkVqPZpJk957zgBWxQOvs6UG76C7ztZMRKT3ydykjRjJstOuvrDrletCJPQEbhiAjSU6Jhqh5iNToclXUMgYIq4fOp5LCWb3bjEMS9EK5FF4bD6Kusgvrp13JxPbRezjfffNR3hBmVg49X0mA+6OYv0S3i0ZlkiQjKLVvxngDx84LcaxfRQyPtTi8BRWwVOdbwak69GJhSlmEDgUBl1/Mwn4vjoCmQB/SOdR2kt0SK9fMgA9TXs0L4h6p/k+9oj+vUgnCuxRkcs+YVNvXg/Rd9fQIquBEBLn0vduUji777Yv+Ku/3C+ZpWPgWnl2of7cTGxE3zgpkw8FJ6aG6FstZJIt5YOVEofTlwYmsUZD0Dwg49WvaQh7rQJdiNjHHm48qyIML8wFFmNBb6f+tpXDyVxXT+IIuFzY21ZuEYnggjx/gERSPzeedbZfJ5tdH4+8SEbz5zB/ilYr5yunq+YfIHUAWvqC6GTq70poRrjIrmA8SYweu3xVwWo/VBkuM6Z5BOvT75QYZW+6cjBpMXXE45tX7Y+bk2fMo6E0TZSU2IBznj68d6w06XL6QgwiVyOvsX5sWN04/SbecBh1Qg5qwuxZGDxOiRDQVtLfWYQO9Ra50GJRSNgPZAmYAoz9JGceVmrf8dLm5/Zv0y7bioRAcrgLZvqpczOjfyZMaU9QmGcJBwb0IB4514bAuwIMPKwcLH3hsLgcGv8XEJSMwyHzL4r6A/vRfrKXL/4WFUfjsSATVugoBp10vQ4Z8n5+tNXXDI5AlhCOJDUegn9y5Zp3V46ob6DLRPy/2kg
 uGZz6ZxV
 pNsZcjgIFoQAZduazZ7gOQob1novTWlG9Oc8H579XkIGmj0HlpUctGnFXDIcdzMPkXX+Vm6div9z4BndNkiIoR2FhoQB05k+Zx1c3HKS72pByP5kdSa4ADqZAgtlAooSXTnOLYPkMtQB7WuW5u9ttjpU279XXrO2EjfxoT0PgJsUaRKyicOyLMfKrfKAimpD/lxmypsyEN9HU4x0gml5z6Em8Bq46va+lG7w+NWbgBYnzkBtiN9qzgk4YIE3yhHq9naST4m88sbZYhQ6EuusltsvPD5O0jrwmdWIy5CNvBG2Y1w0l/wZ9rxc0mBB1LU23NyD0GER/uOkJqOcuwNexMx5pzM9Qj5ljj53uHYrveX1K1sfkLFMLx+MTmVVSgEAclUj4KaMVBATbWJulmNj1TyqdB5ZGCJRVAZXDJ5Q+TB/1WD8tY6phzEq5nZ/OmPoa0Pok41Ca0iPmzuuu2oxB+vFDFVFqxJJmTbNJU3pG9mhT4tcFbl2VR01k/DLa3i10gKhHry8IO0XSqtARNnUv6qKsm2rzWg/A/k/OikRopyRxXTObsIfN1VnasrMBCCFy8a16aC/riskJacn5yISIc8rLOdUQ5lqZUPD68iaaO0ET+MU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Alejandro Colomar <alx@kernel.org>
---
 mm/kmemleak.c      | 2 +-
 mm/memcontrol-v1.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 1ac56ceb29b6..fe33f2edfe07 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -510,7 +510,7 @@ static void mem_pool_free(struct kmemleak_object *object)
 {
 	unsigned long flags;
 
-	if (object < mem_pool || object >= mem_pool + ARRAY_SIZE(mem_pool)) {
+	if (object < mem_pool || object >= ARRAY_END(mem_pool)) {
 		kmem_cache_free(object_cache, object);
 		return;
 	}
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff742..b2f37bd939fa 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1794,7 +1794,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 
 	mem_cgroup_flush_stats(memcg);
 
-	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
+	for (stat = stats; stat < ARRAY_END(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
 						   false));
@@ -1805,7 +1805,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 		seq_putc(m, '\n');
 	}
 
-	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
+	for (stat = stats; stat < ARRAY_END(stats); stat++) {
 
 		seq_printf(m, "hierarchical_%s=%lu", stat->name,
 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
-- 
2.51.0


