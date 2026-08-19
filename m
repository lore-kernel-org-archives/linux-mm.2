Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D9AC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974A66B00AF; Wed, 19 Aug 2026 19:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C6E6B00B0; Wed, 19 Aug 2026 19:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 862D86B00B1; Wed, 19 Aug 2026 19:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5296B00AF
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:11:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD2818040E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:59 +0000 (UTC)
X-FDA: 85119566238.25.D9504A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1E7B3C000A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7ly3cBX;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181058;
	b=JmyGzyx6ggoXm6G0i2yWLnlCrGc90bKVO/uWmc+aA3OBz3SiofkJX0ELm6xUQA9f8cGivV
	tERaEQwNOZPCqgfzhR/LgWrvrgn9FIl3375QDqWEH4MrrIA+8DTKadtXl0eriG1202nzJo
	0g9+l09tbJLdxwhlBhzwEZVhmQUeUXI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7ly3cBX;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfXAgoL+9LBeM/3gsj9qXNECM/y7xKAoBOAjrqptYLA=;
	b=BS3dXPeFZKo1H44Tunr9Gsr1QQwK2dPSOeBWQJIyu61aTNv7azAsb8jgyaLV2E2/q0a549
	yhTfJX/3Cf2lzTg3ZjsBDQw1G3absBh6nXUhAy2C/8uYQ+84JTl2j7qnfN97gBdgEY7q5B
	rV5qrJLQuOwBPGLYbXCNeRJyMCHxzks=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CCB6439D9;
	Wed, 19 Aug 2026 23:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17171F00A3D;
	Wed, 19 Aug 2026 23:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181057;
	bh=dfXAgoL+9LBeM/3gsj9qXNECM/y7xKAoBOAjrqptYLA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h7ly3cBXNdZl7hnrgTxPREaO8oFEfhc6DvRM7kPLZVg7S7AYOKvbSlD9lhr61Eply
	 6jOr4ONLrlIllToPvALfSQHXVeXm6QkRDJsyAJAwXh0P5oEm1qTk3f2Ur8CZH0XB31
	 QU++l1mZjfVPwqPjieBgTtwk3lSZCIwowoSOdYaXBlHHSg7sC04B1d8XT23AUS4xlr
	 pg+jQwMlNP1UfKYn/aeN27+I0aDebskxj5YMCLCEG6QgxJeBSAKlu8gf8J/9gscEcQ
	 WfK2J0wv1iUVT5UsUTnDaFTNMGeJE2I63alCUTI+iAxn3wJb323FOgOGRANuP8CQk2
	 RcEKGSk7x5o2A==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:28 +0200
Subject: [PATCH v2 11/22] coredump: always chunk writes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-11-ba32dd718c51@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3072; i=brauner@kernel.org;
 h=from:subject:message-id; bh=6lmk01oIrCpLddgF34l1qNeK7azUHFnu6/y3MNvc9fs=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGqGN7+jKg8nZ84IvdAkuVaAv3pB/3A8P2ohgfbcn0M9u/3qY
 4h1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmqGN78ACgkQkcYbwGV43KIysgD/a+/5
 REHHWLX+2VlcBK70uw4E+bPFY60zOkDXluZRbuoBAKZwJlYA6NSqs/oHBznLIQErTWGeszoobly
 JDQFMN1YJ
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 1E7B3C000A
X-Rspam-User: 
X-Stat-Signature: gop888qr89qoq94bqq4xm7qgrphq1jm1
X-Rspamd-Server: rspam06
X-HE-Tag: 1787181057-337497
X-HE-Meta: U2FsdGVkX19X4u8RqVe8jpeMd0JnaWxyvwVLCjwL1YReLNd9X4uZDt/Appz0sy5lxorAEHORt5FB5jv2iEtqj+aQxykHhtBqrm72kc189gTP8DevWjEoFz4u8pUF9zQwUc2xee3CeIFndFoTMl8tJ9n8JywbnbURQVXhbru9FmSNBBUIN9eq8kRQMrOe2Xgq8uA9V3EAIic9zlOdnDLeF6BYShaGFUec6qOFm5Z8IPi9oZ2/ZglCa8u7DFmcJePbYQ08qUD1ZxoFhnB6C/MPyZ4OZm0SJR2h5UWKoDs+2euUgq1uhwMsB6NJlZcYROZ87hsAICrV9cdPQs/UttHGu4ufEKJ6R0dN1AEikzEAmjctDsaUSuyCqPKkbGYR7I0/2vw5UpEp67yiJW1RjwBzEXfxZyArcAZEHyGcjm8lP1HlFTyl7Qa1Ux4PKWH0uzJDKSpmPtYhZjBco4JHHnzyEKyp8nIDllfj0jWT+HacoPyfuz3pwHU3PSSJ4n8yd1Jurw6RoiSQb2EH0WJ7+YrM+EfAzj9qkxqK4eeMp6zl7EOaP8Qf/f+3xwPatK3JhIob+JnmWBywLlmfZ4dMYg0wciuilhvN+F19FeAnf7VmHOkjmabQKYerEjEbwaRh5+qy9nNB5x+8oofIMf4Cf4Soj3rpTB4IACcBu+rmGl22JHEAtAVPyU7E8dD5KnyIj76vB/JzEJar6T+mHehBodDp2Lib0vtYeGICxoyuVUf0Ry67/0gMOje61CSIfXPNDxDkiv02hIMSgXHP1sxpPu3vUNGjYxN8JThPM+MbZkt0ft2CK3IFlomXmnUPk8pMBLVvvODzIJZFplfzyBnsiHh3Pk8Rnptd+oEM08AeFy2AW6k/kNnIbqdx+LyGyS6MZ3jC5lY+Orvhur1hUYcJbQT36/ktssxwKFQ1dsWmH4cop1Pek4707TVy4BR4qaehKW4P6MgYQGRV9U/5Y9nQMTQ
 9k4sDkWp
 khreyU5Cgcf4XGHSm/EmuZWOJUmrFZDqpn+xs/hwi4ywoR1Dhh9QUM3XXwNZ8SQssEHiOVMArsudH407bMXfZlDwSqZfqKKCwEWCBpEZSkxAp/M21+KajsfcdP4cz1E9qUANMuAwDBNsvV1LWAR3ns2VkhhrRhNfqEdrPoEJCha1aApwyrr5Q55yLzDwpK8izvTCOESXy4iLiVxvTDMG7C6k7JSSy05b6XVTGY4rVARqFPKDIhFFWp7B75g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Right now dump_emit() is the only coredump helper that writes buffers
larger than a page in one call. For elf notes that can easily blow past
PAGE_SIZE. That's annoying because neither pipes nor af_unix sockets
take such writes in one piece.

If a signal arrives while the writer is waiting they drop a short write.
With the coredump records work coming up that means header and its data
are desynchronized. A write that fits in one pipe buffer or one skb
doesn't suffer from this.

So split all writes up, including elf notes, and cap every write at a
page. The coredump socket already raises sk_sndbuf far enough for a page
to fit a single skb and pipes always work that way.

That means dump_interrupted() is now checked once per page. So a large
coredump stops earlier (good). An empty write no longer issues a
zero-length write. The rlimit core check stays where it was. It
continues refusing whole writes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index d837819031ff..d61f36239f91 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1215,19 +1215,21 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
  * do on a core-file: use only these functions to write out all the
  * necessary info.
  */
-static bool __dump_emit(struct coredump_params *cprm, const void *addr, int nr)
+/* One write, never more than a page. See __dump_emit(). */
+static bool dump_emit_chunk(struct coredump_params *cprm, const void *addr,
+			    int nr)
 {
 	struct file *file = cprm->file;
 	loff_t pos = file->f_pos;
 	ssize_t n;
 
-	if (cprm->written + nr > cprm->limit)
-		return false;
 	if (dump_interrupted())
 		return false;
+
 	n = __kernel_write(file, addr, nr, &pos);
 	if (n != nr)
 		return false;
+
 	file->f_pos = pos;
 	cprm->written += n;
 	cprm->pos += n;
@@ -1235,6 +1237,24 @@ static bool __dump_emit(struct coredump_params *cprm, const void *addr, int nr)
 	return true;
 }
 
+static bool __dump_emit(struct coredump_params *cprm, const void *addr, int nr)
+{
+	if (cprm->written + nr > cprm->limit)
+		return false;
+
+	while (nr) {
+		int chunk = min_t(int, nr, PAGE_SIZE);
+
+		if (!dump_emit_chunk(cprm, addr, chunk))
+			return false;
+
+		addr += chunk;
+		nr -= chunk;
+	}
+
+	return true;
+}
+
 static bool __dump_skip(struct coredump_params *cprm, size_t nr)
 {
 	static char zeroes[PAGE_SIZE];
@@ -1247,13 +1267,16 @@ static bool __dump_skip(struct coredump_params *cprm, size_t nr)
 		return true;
 	}
 
-	while (nr > PAGE_SIZE) {
-		if (!__dump_emit(cprm, zeroes, PAGE_SIZE))
+	while (nr) {
+		size_t chunk = min_t(size_t, nr, PAGE_SIZE);
+
+		if (!__dump_emit(cprm, zeroes, chunk))
 			return false;
-		nr -= PAGE_SIZE;
+
+		nr -= chunk;
 	}
 
-	return __dump_emit(cprm, zeroes, nr);
+	return true;
 }
 
 /* Flush the accumulated hole before writing data. */

-- 
2.53.0


