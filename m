Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D4D3C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72B0F6B00A9; Wed, 19 Aug 2026 19:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704086B00AB; Wed, 19 Aug 2026 19:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618F26B00AC; Wed, 19 Aug 2026 19:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C8DF6B00A9
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:10:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B9BAB80479
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:49 +0000 (UTC)
X-FDA: 85119565818.29.E7907A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D39D340003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=npJLhXeQ;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aXCeFRO1r0hB0+8jo/097AeX5zU9p1RIeHyMY6Gqagw=;
	b=kN5hnpJ+4zLlNAq0DRSq8P8cCP3YJr+VUVau57IutO+cSaNudHl+6g3SdSs30m2iqCnh0Y
	TmPfThn6Jn8UAzUF6w1lRis9jKFpwZSjBOja5NzQKcCNeaMp7KQ4dGQj9AynO3O63kfvLm
	2TOL/Ku3kItKH9fgWMVNrjz99b+NT5U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181045;
	b=vExDt2ULP3PSiSgQFXu1hqU6FveqMqewFD534gOLPNOdJaSJLlxk0rZIYjVwoqfY96uBvX
	mhRoEUvWPb1deHKIfTUahhZXTTE91EVSGvizPlrAr0U8WFNuZN6hYHd5/sZUcuGLUyvBuj
	76z8xdSz0JBuVduM+qAe8RdiDL31A30=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=npJLhXeQ;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BCB361890;
	Wed, 19 Aug 2026 23:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76061F00A3A;
	Wed, 19 Aug 2026 23:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181045;
	bh=aXCeFRO1r0hB0+8jo/097AeX5zU9p1RIeHyMY6Gqagw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=npJLhXeQ/IhG/+xAo/mjKtSc3G9BXlgXjQH4PjRqutdnX5peq2Nb0g350sJgmLW31
	 s7nW1fZTCAWEOV02aDamCCA7OnVHMt3/8PYOv+2ooyKorkp92y3M1IbvY+2VOhnn3c
	 Rql9x/J8AT1PJmW7lYRZFVbrrxMjFU6ss2GHkylFXuw9vHwOhtyccBcOiHWKseSBir
	 bDadGtBVR5S+Y0CToo2UjrcVSJgqPxHoB1NfH4+TIfRbf1uuSnt9x0aJmbxBdMndTY
	 Bdf2XQEqKWgZ/t9qiKUtbN/s0s3uiyg5QyQMLAkfn34/IOWtw3b+svvtxJyFoPE6QJ
	 5WVqP1YzDqhwg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:26 +0200
Subject: [PATCH v2 09/22] coredump: deduplicate the to_skip flush
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-9-ba32dd718c51@kernel.org>
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
In-Reply-To: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1473; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QcTKefttEJ4tcHQFZJxvLhTEIvEaSI31GPP914rVvoI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me/b2di18GR/1eFdZf0CM6pf/jhn7NE3o91oG/ulh
 feNfzwQ6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiI/1WGfyrqXP6z/RRY9dJf
 npzw5vKU39nneQTWthU/DeTov3ansoXhn+LSGdNrfecfqOB3WFNjfEAna8Jk5fzD2TenGXde8Th
 8lR0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: ydfybr7x9rgqri8xxqtc7xw5icjeid6a
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D39D340003
X-HE-Tag: 1787181045-798910
X-HE-Meta: U2FsdGVkX1+wmO2JaM4mdiceuVwzMEXjZcyydcczf8KxOzL1A/U/VCYGj7P0++JlJQrsGsL/DVYx/Xk/YfWUPOxHxyxLA+YsT9lRWF7W1K3/4WdDpRrrmjxX4/hBtA0jf0aki/WiNwVIwgJfgrehC6oOJAXC/v5oP3geu8rQRQeNmkd5pcd8P3ZCYYk9Rd2kZ8w+4h5NadNH7tLibPFKToPI/lnZRQbZ//2i3MulwxrfTT7Cn34rgnhY7iHQBJCS3C6T8Uu/teZWAVSfVQaZtBQodXUmVFeZ5nILh7AV6KXb+N6tyPWKpyucTROn7c5WcUud8lSYXKDxVqZZtKQmVUnf4Z/gfRsNVb4D468WHOljqC6TYmM0ZZ8FcL2qfMo0+qKdOrvE7ly81l4SiyMsOmLlUAjo6QTG21LoJq/bzCNoCT2yJD/j/XgOFO5BEC89xsXizjM0xZ3Tb45J172Yad1Eo2C0XrsG0NyVIPZzNBHumgvIblPv0yUF82H5aeMas/ApD12+7wN+CbvtrUxQDiLDl4AtiOFrWuBPwIOtm0PZlnISiIte4CtHHFGn785uoqvoNhhTZkGVTsobP8J8DojMvo95+8Npae4bDOW/G+HkdgzS5eGVIv5ShBKjGhe4yMxptX5xelscX3K0xLtM2m5wFrK4ZV3AK6l/dAx7sy3J9GnLbVnHeLOl8D6XCHso6k9Odj0p8d5S5qx3UJ2+vk79RgHm96MMmRA/ToWKLrIc28XK205A66JjcqA5+4kDU7w2VnCI4HAyPVbiRP31Dz/uN4tmhQZmHtHlkCXqAEH/IeDQctnvAcNQGtXb0zhicX71K4eXdbDmzC8MqZTUauhKGtpeUz4nz+Uc0gCwchymJbMVHxdv9PC09aCds2PJsPuK3mqj5RQIPCkCbEgfzvTJUPsVizFkluygHF4UG0l9ewAMB9UQpz7GsrMzOkxj328DxClehiPtC6P4kr1
 dQffFrzd
 B1WvezGw7b4xs9qih/zbP7KYKs/YtbfDcpKc20+6xHnGYhq6GIpzyxPX7ZSJQG1oQZRqRS8cgMhiB1LSOB97C7icECI4P6Aj+9cPBXFJ/grt+aD6S96zOPkfmBtQpM8cZrue39rtzf8s+7QrX1WDTfHPc/yEPOQM/D70Z7TFLABmegh0dlNpaJ1zG096m4pNOMKilpG1bKYZegpnSQge2b+6/9y5MpUfdKqG6RFSZsAJnpUQYX8myb0mCYIT/f9rM7mx8Imy6KPADAyIUIz4pmnd5+kiaYJAj6F6u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dump_emit() and dump_emit_page() open-code the same flush of the
accumulated cprm->to_skip. Move it into a helper.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 156688be3df0..cd36a72be445 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1256,13 +1256,21 @@ static int __dump_skip(struct coredump_params *cprm, size_t nr)
 	return __dump_emit(cprm, zeroes, nr);
 }
 
-int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
+/* Flush the accumulated hole before writing data. */
+static int dump_flush_skip(struct coredump_params *cprm)
 {
 	if (cprm->to_skip) {
 		if (!__dump_skip(cprm, cprm->to_skip))
 			return 0;
 		cprm->to_skip = 0;
 	}
+	return 1;
+}
+
+int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
+{
+	if (!dump_flush_skip(cprm))
+		return 0;
 	return __dump_emit(cprm, addr, nr);
 }
 EXPORT_SYMBOL(dump_emit);
@@ -1293,11 +1301,8 @@ static int dump_emit_page(struct coredump_params *cprm, struct page *page)
 	if (!page)
 		return 0;
 
-	if (cprm->to_skip) {
-		if (!__dump_skip(cprm, cprm->to_skip))
-			return 0;
-		cprm->to_skip = 0;
-	}
+	if (!dump_flush_skip(cprm))
+		return 0;
 	if (cprm->written + PAGE_SIZE > cprm->limit)
 		return 0;
 	if (dump_interrupted())

-- 
2.53.0


