Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91B12D0E6C5
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 11:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72076B002F; Tue, 25 Nov 2025 06:09:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21DA6B0030; Tue, 25 Nov 2025 06:09:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5ED16B0031; Tue, 25 Nov 2025 06:09:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B25096B002F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 06:09:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B1A25B6F5
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:09:28 +0000 (UTC)
X-FDA: 84148858416.19.19674A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B12181A000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:09:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VbnlXt4v;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764068966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLudhvToMeKdi9ZoJPE+kAOPQdbLossQ5hWDi0Y+cLA=;
	b=lwRfdKhZHMoE2ta1v0J0NtRk8FFE9uAzv/iY1lzV7ZpKpNLwx8GUJkGXd+RIgklC0nwMke
	GrHAJPKNrQYXouOKK4NGdWu1UC1xDDMwBSMMgs/vGdfMOWELLH+ZA9dIno3UJO0acEjd4W
	6q1cemyn+q5i/lpeeh95DUg/38N4o+0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VbnlXt4v;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764068966; a=rsa-sha256;
	cv=none;
	b=aJRlnz86TPyrn2IXqHDox66WdJih4zO5pO9Ae/AdeUJ/p+y5bsYUAtRWGuX+PxExXsJ62Y
	WkZwUfdEalfU8FwitayzyIJTccAhXfRq2xQPl2YgGfWY9MFRyZ9Y0zP6zycm6jNyzu3rHt
	bRsiKcbEvAwtfDukU5J9ClkXNj5UAIQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E7F96018C;
	Tue, 25 Nov 2025 11:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5D3C116B1;
	Tue, 25 Nov 2025 11:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764068965;
	bh=tl0WK0vKXJu7BGS4fSCa6MdaVgIDRX4gqgHFUZ7FCvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbnlXt4vHwhp3etx/I2CyBGBAEisjkzEBHPcohG60xGiIC2LCcCaadt9eBE5cTRuQ
	 IH8TsX9arsUjYD7UGW81qx/k5gn+ElbZ2oOta0wgR7UasVfPoXTs4M+2IbevAwTGL2
	 vD6tuNrdOEWObS30ep/vIBJSSZtytYYFm4poTr71FvNMwxHJr8vk1m7AQxpzda4eIX
	 1zQBl3vcEjdiqCjairTRFNGZXKNel9ojJ7dDIelhQ37jOwDq916GlbdDc35oUbppWx
	 e6EzScsu+5yFNTNhF/1M0CpKcUa9XG7P1PvND4uQtVtWo1hs0jXm50lrFblQKlUOod
	 h9TFZXswX5hWg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kho: kho_restore_vmalloc: fix initialization of pages array
Date: Tue, 25 Nov 2025 13:09:16 +0200
Message-ID: <20251125110917.843744-2-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251125110917.843744-1-rppt@kernel.org>
References: <20251125110917.843744-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B12181A000D
X-Stat-Signature: xh8y877c74a8u4j9t46ewphukg7i3jzr
X-Rspam-User: 
X-HE-Tag: 1764068966-639051
X-HE-Meta: U2FsdGVkX1+2xWxlW5o8esR0AJQlmgonHtQQnFLUpndSLMmLrSk11R3W3+pdwgUx4/z+d92bIRJNBii0ewENUwvdd1h91I0dFllto5/WJxdQGq+ZivvGYSC3NjU89bT4v4nSHOfvNl0tcXYX7Lxh9WhtYzX/gY3WZeoboEl3BqVSzpE0X5YuArT3kAmXAUc14T0eVx8mvsMkH1ArrdzVyni+WAw9871w/J/LoCeRp/fLQsQCeWSrfy2BDTSXmA0fjYz1TLf0OznaUsFegOX/V56FXDvFeI/d+HGZSeCCOfSMaho5RDluXkcWk9cGyLjFe5LIgcWUPsIXoxKUk+FlYva1jjhyIiIBFy5Kop05zq5XOaG62SmfAjkMz6cst/p7CLrVAGjbpXUOjLc2KLGlk7jL6p6HamczKp23I44QzENpSNrwBuQAXFxXn2KtolNtUK/eEPrgM0CCfSpbKkUw2wKrlvwOvlmAy+PrQIgLUS1z8aKzwEu/QU99z7WU3gB1SjLiAiu7ElXrIqsQG2WqsPwSsFqRrCRsW/v4k5f83HR6yOF2xI5usPFeCUTj6u+8QjQ6UhEFaj2PZJiUXrf9Ba/hVvkLNvkgd+A1xep5Dld3ZEsUnRINVMnbn2hbX5flk3GShQh6iR8KkOvvZKuyKX+rWMIn82I6iyDSxEZQbLMMsM5SaWV3ADASP+ukwR6NbmOBFL3k+mKQ84zYgXRt9ZBVbKjfb0vFvw5MIwne5nTx0Ee99O7xIfv6Wnx6sdOHUgCAFfJfGLwnUPprbxOLnxQqgRtQGGhLENvOhofPCkVEqLQKjHUmCsHxNySJJHuRzybpyMM8KQEhmE8KMKqB/z8Ol2FuLRutlwV4Tof9PgpyC9TkG7ySnaimg6ORGQWruOYZMBpQFa5gFWFu9I68elUBPpZYW/kr1MPE7yC/Dvjv4eFwX8/BLTnOk/s0jvhDydRgLN7qx9/Ks3IDk4m
 YpC3DQp3
 dYCFPKCYzgcOGELZH8vQGe8GxraP+cZxSDfTUFOmEJiveci8cS8u0xQKWwDucb4hdlC3INk5B/LljWo5S5+FJR/15ZVb4r1dU9egmM2xLDVCFGByvKKNFxfgcv6Se0eEkK3+deT+smKsUaPySmf4m243iINV19lukeJ9rQPmrNyjQJuWWPyGPSQka5BojvRgfrQvKnf060NsM5w2VYt1bUBmfYryWulxX+G4HJNVE4Ti9Y7e9iufGnD9u2I4ib0+Z+dlnF+OMQL1vf8+291v6c2SEPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

In case a preserved vmalloc allocation was using huge pages, all pages in
the array of pages added to vm_struct during kho_restore_vmalloc() are
wrongly set to the same page.

Fix the indexing when assigning pages to that array.

Fixes: a667300bd53f ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 5809c6fe331c..e64ee87fa62a 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1096,7 +1096,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 				goto err_free_pages_array;
 
 			for (int j = 0; j < contig_pages; j++)
-				pages[idx++] = page;
+				pages[idx++] = page + j;
 
 			phys += contig_pages * PAGE_SIZE;
 		}
-- 
2.50.1


