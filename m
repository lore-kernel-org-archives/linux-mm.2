Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184C3CFD364
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 08:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 739CF6B002A; Tue, 25 Nov 2025 03:19:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E9306B002B; Tue, 25 Nov 2025 03:19:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FFB06B002C; Tue, 25 Nov 2025 03:19:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47AE96B002A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:19:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF56989FF1
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:19:38 +0000 (UTC)
X-FDA: 84148430436.10.DFC6A31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4A99140003
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:19:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of "SRS0=GMQ1=6B=linux-m68k.org=geert@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=GMQ1=6B=linux-m68k.org=geert@kernel.org"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764058777; a=rsa-sha256;
	cv=none;
	b=f32IjqdyNyZNBFbMWAMkgJtsSXs0GDLXl1LABK0MTXZP3OK4J16wJsZzvvy6bsVcr4lsuQ
	HOOYegM+vdgA8RmX44rw5KNeWm23JfxRL5a0RkGv2uNaRJa/gzrZzOMt1PsvdqH5ueGnmx
	XWd9aTdwdkpWwCiPV8BS4h1n65/blbM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of "SRS0=GMQ1=6B=linux-m68k.org=geert@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=GMQ1=6B=linux-m68k.org=geert@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764058777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=5s5k7UEiXfGAUWhFCU0gZj0SZlElBVuyqeBu5yDHgbw=;
	b=PpDWM0IBuHQ00jnoNNgYwc57V+JjqX7CQHGkCQNCnHGfKfLuXu2HvhPekzm5j/eJWR8LhI
	d+uKMR/Jf9Vt+7qNMczD/YLyXanlcJM4sP+GeEdPQxDcrb4giR6u76kfdPpbLGExNiGsyB
	R70BYU8d8xJxV0TdetrQR8bPfATz3Rc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71D794090B;
	Tue, 25 Nov 2025 08:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BE4C4CEF1;
	Tue, 25 Nov 2025 08:19:33 +0000 (UTC)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kees Cook <kees@kernel.org>,
	Jinbum Park <jinb.park7@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mm: Fix DEBUG_RODATA_TEST indentation in Kconfig
Date: Tue, 25 Nov 2025 09:19:30 +0100
Message-ID: <74f39b1bffc6ed802088cb3e7d17b4c82330e8b3.1764058676.git.geert@linux-m68k.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4A99140003
X-Stat-Signature: jp8wb1cn8d9fgfd54uoh86d5zi5umqoa
X-Rspam-User: 
X-HE-Tag: 1764058777-645560
X-HE-Meta: U2FsdGVkX1/Pe0aIXkKfJHZGoxB5HmDtje3Zaw6LEBWb+5VCweW3AiRhbpWVAahTJ1Xc/wOJB9kP2r93nxMp0Py5+YuZ4ZTU1Am8KXcit+evKEJlisUegayYa7UcAjHBizS3I4PRm+velRKFAFlf2A7rqC6LBF+3+FbEZhhDYBYldVwsm+iR/Rpn5/cDeKyyGvPNvS7TbFNHejvMQPXFAd1DA+CEoqpPWY2Qtb6bzrfdSFid4YlaAif8TsO2ur49W0pS4+KmHIkC4WBeCbMNWYscFmNs3JH0tHIev1UmTVl+4jojsXa224TFNILDsqj7UkTQXEodwJuYtgAz5u5XuaJJCaoCpD/1umCefXDBP7QFrsvI2KJkQz2MQxkSmxHTEwk/0hSy14s/5Tmi8/TJRRqLTzEXJC/rbGKurxoDIFX5WrmaDp/tJTnrrI2siK3h9BwjmhWDrAMZ3fjfJQHyc0wF59N2wAZi1IDuF9FQu431ET5gk38P6/rDaYUpSFKtRZ7JWq0kR1Z2HhOwPqEPirbTdPtc+MGOyJHJoDsjvwRBGEKV+250kXHuzX69B7VRThQpc2gjn/zixpb4ZnBiaxXjaSNoruVB3COsc2KBlYjAIHRMgbYiwsUmzvD+u6/DoM33fjUWVUWqTuiTpdgw5QQCRbMZ1xXgkcupunBtXq0kw+KQ4B/OaDqlgQkJH69+ZAqwDzxo8NFo/tyGA7xmLJyNlv/t7zjpebAKvGBUPRyeaXJbqbYySGv3VV9PxMgWY7Ps/kydVU2I4/zVZxOuiS0/Gx519aDYaYCzqyl5YVlbBKLBrDKOwWL38X3EUEdaxThkxq8+NjbdG39RzU+YDEY/Ks9H8OUkg+K9HFvdHHtpjmZ/NBUg1idFcR1Ywl8r3xdHxPyEtPHX/ffgR+BUavK4fn4ks0Mytah/7YBUKw7jTb0WLZc8Z/RahsFuM0tqAtdgOPxCs2UZnh1UQXU
 0bucoyNi
 Z/2aLJOhaJb8vbe85knOGaLa4jeEiImSsFWSUPvwqbzi5niIGa6FoAfYmvT4bl1JYrknMzTKA052bKJ3Fw6BbzIy1meMk5ssPh1TFNij4TejbY5zVKyvf2lyYaq11//OOxOxbQP9KuEmvs3oEOQfIv+fSwr+t1Cb7lB66Va7qiqGdtG55Yp1ndXbKaJw4uqUPjb6rJOd7t4gBImCt6kZI5kY7Cy41Yb2YlvxQFGuf+tGqbnHZkU/vIXVIUdhpzfC1SGCOk5bU/51CsZIWmtr7vQ9eb/L8b3PT9YQdTgCUylYSvFmQFHo3il59RpBFbKR+8Y7yh/3GvhjqXx8maaReQPuLE8BCjaIkDgFuvuYMckyJnSgkjjWEksCEMF/OmrsOjk4zok0PA2AlrvtRmtkCQ8uAwjkzzeHglbDaqVVAV+f1w78=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Most of the DEBUG_RODATA_TEST section is indented by four spaces instead
of the customary single TAB.

Fixes: 2959a5f726f6510d ("mm: add arch-independent testcases for RODATA")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 mm/Kconfig.debug | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 32b65073d0cccaf5..7638d75b27db8cf1 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -175,10 +175,10 @@ config DEBUG_PAGE_REF
 	  nil until the tracepoints are actually enabled.
 
 config DEBUG_RODATA_TEST
-    bool "Testcase for the marking rodata read-only"
-    depends on STRICT_KERNEL_RWX
+	bool "Testcase for the marking rodata read-only"
+	depends on STRICT_KERNEL_RWX
 	help
-      This option enables a testcase for the setting rodata read-only.
+	  This option enables a testcase for the setting rodata read-only.
 
 config ARCH_HAS_DEBUG_WX
 	bool
-- 
2.43.0


