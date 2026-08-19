Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29F0AC5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30C696B00B4; Wed, 19 Aug 2026 19:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD876B00B5; Wed, 19 Aug 2026 19:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB3F6B00B6; Wed, 19 Aug 2026 19:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA9F36B00B4
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:11:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 857FF1C1A7C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:18 +0000 (UTC)
X-FDA: 85119567036.09.1FD771F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id C66EAC000D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KF9/ILc2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JF2Cv/1cFUsibF4vKLKqolVzkMLtjHIoXV+phkJR8ho=;
	b=pCTIfOK0DLgOchCvVGh6U+46FyI5myNVZb0QBUSBZbPPRzJvOGsHfLDNaDbRHRZ2iwDlPC
	vLdUNTGhLvjyt+KrpdBZyA4bsCo1XuvnrUkom7acuVxhxJgO5f5jFWzv60h9TMqb4WOe1N
	PTkcqNtisZzVAWZYt+YafbsxKPNdlUo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KF9/ILc2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181076;
	b=fPatfL9NJJDfFInkXEuBNQ1oRzEyFFk8n00ZeJo3GoOQSkwwLwWKrmtYo1AkGA21KtRJXi
	MAheSvfbHIEu/5EJzj/L8tSrxEQZQ0Iaq8UmwYdMEOzs8zwX6avlpywYpY6Rz7EaqrW2LB
	CpfRBZTxLOWDzxGEnmPfQgDeLRlb4rY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FE866187F;
	Wed, 19 Aug 2026 23:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB0F1F00A3F;
	Wed, 19 Aug 2026 23:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181076;
	bh=JF2Cv/1cFUsibF4vKLKqolVzkMLtjHIoXV+phkJR8ho=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KF9/ILc2D0PoNxY2cOsk2dUUA3Zo69sxGjc7MEd/cmiBteotJleRH3pGeUfU9AGsC
	 nVBubLd/AGEayMkQw20+bZqzRFjvmLh4nqthH9pwrx7sLlNchZ1sDxUhMsrfWv/bKq
	 8PQN++OfysKGQR3oz8KrJF8KyV9DwGJLftxbwSNbAdx9AWPjsrvnyCNwRCdubJp+i3
	 uEU586QZ8EjEJGhxoaCWrO4eSOqvuWC/zlWUVDyEI1Gx4td0k7p2/gljBWMCyffecP
	 nMZeMLB2aW0Gge2gDn1liwrI2kJ4vVPW7kJU1XGhH46WScL0CRiEcZ0aUT1GWnRPKN
	 nFygd/fD2EIJw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:31 +0200
Subject: [PATCH v2 14/22] coredump: add COREDUMP_SPARSE to the coredump
 socket protocol
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-14-ba32dd718c51@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3626; i=brauner@kernel.org;
 h=from:subject:message-id; bh=LOn4l248r2Ldl72jQF/dgDVrzs5g3Esgmh1gwmYjZiw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me/fpjv7/p+XG8zq9bpvCk9jm3NGa5+1yeqwI0wVL
 2z8871+d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk/SYjw7N2lSvlBhVeRV4J
 Gvv+tDf7nv3xYK27PH9/V2hM5U6Nfoa/MlXLD9ycEnDse/+16NMiJh3PvgdMEtNgTdDvW6Wa//o
 uPwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: hrd6t9gj8c3ghrt8kq3krb75jjtqwu59
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C66EAC000D
X-HE-Tag: 1787181076-314046
X-HE-Meta: U2FsdGVkX199lYcvN3VUVqiz0wQpsS+ftih1wkR0tLBtwt4o/Iz4PBp7/24nsrzX/NW5aRIL293IEUnmja7T7pujXnU8c7xVq+SjPa3tCzN6z7yp3bMZDQaBbEkNZt22BOlVw+EalecGahklvvCefzr3eR4b0EVefal0/P92W9oyO0WjFGx+4VCr/w/kxD8dXX37NUxvSJvUVXp+rZsbL9ylW+5LNZ+XsR/1a7TyoHiom8JXLDwFvmJ8SlSyeY/7r7FY7ecxPDrV+sKl/T3SVn4RCH8dgRJsE3EpjLgQSy0474WzJQog+0rNLGKZbSDdjeHGuN9BX20zhR/VV+NDDJ/duFPaM719De51mB1gKV4T5J3GPbCKbmGoT3gSlXaGvFtgLZLU1ISPvNUZTCpV6hTI9Th0I6oj1vulkGpZbUibu4JkxNOjFTB3w81mMu8M8gr32DnrOqDS37T41RP2pgPgYkZFNLVfsx/wCK9mKIyyoD1KbBF44M+kz4jFc06OVauTr0xzzVUWtheI4PiRwni+OV5m/BfHhBvlZPT81xAozfsO6jeoQ435SLuu+aePTp8q8BJoveXOxDhfeYTTThOfW1VjpvAx4QL76h1fpWvLYWZWgD6QoNTQzsYpXYhrBcQWXskld2ChfBokK06+GOW3mUpBLM0SECeXGMux4yyOiuIm7MMQ+AI52HThsOwKOZt6VUfJ8HAo2nV5MZd+BgYu0/o58WPD2EnPejs/b1m97FWHtuAllxV2XsUA8nB3fe6ENyM8j0CuDYveNKm0wQLPOn6e5lnWDuK2w9DJMIZqVwyyn7HraEIfdhga9ZObqAUih/YWwNcaDFFxEwK6LkDpUpD8LLBHEO7q+nEOxCtMsUeJRESw30pk2r2dnC6tM4ieTva/NZ8dC2vx2YnB1egPtZFipsc9BdNd1IH1lEKJ5RgdltvMY7AZCKjDhllWcfDF3S0vpVy0bO1R9Z1
 HOx5JDUN
 5gm3FDB16KLg/y8PGVcwGSRRybnaMD9lXJQD3Ph5gHfSQ1NfR39H3YMyHOAm5qpeDkl0qAeilZAi4gcr3oJikGLkGiWQGBFlGJcXWfcb1OvEVU2NrBoA+l7heUp5MXe9DIPe2dNMbH41tA1T96H66TmUKhfHDun8HLYxncIhYhdikGXyxDo6UtJmmFkyAIZkoIJEYuUv+kJIjvWZM0uijQdXXWLfb1Uf3SCiluXYg+GmlAu58Zuk25wkEOtJKqMi78342KvBf4kI7YxZmj5nuyYLGYCAa2lyl+Ppl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A coredump with a lot of unpopulated mappings sends useless amounts of
zero data to userspace. This is nonsensical. While __dump_skip() can
seek over them when the target is a regular file a socket cannot do
this. COREDUMP_RECORDS put the zeroes in records but it didn't get rid
of them.

Add a COREDUMP_SPARSE feature bit and a COREDUMP_RECORD_ZERO record
type. A zero record is a bare header that tells userspace how many zero
bytes were skipped.

So a hole crosses the socket as one header no matter how long it is. The
coredump server can recreate this sparsely. Zero records only exist
inside a record stream. COREDUMP_SPARSE requires COREDUMP_RECORDS.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/uapi/linux/coredump.h | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/coredump.h b/include/uapi/linux/coredump.h
index 0bd5c8662ebe..f3771861ca48 100644
--- a/include/uapi/linux/coredump.h
+++ b/include/uapi/linux/coredump.h
@@ -14,6 +14,8 @@
  * @COREDUMP_RECORDS: send the coredump as a sequence of records instead of
  *                    as a plain byte stream, see struct coredump_record_header;
  *                    requires COREDUMP_KERNEL
+ * @COREDUMP_SPARSE: describe the holes in the coredump as zero records
+ *                   instead of transferring them; requires COREDUMP_RECORDS
  */
 enum {
 	COREDUMP_KERNEL		= (1ULL << 0),
@@ -21,6 +23,7 @@ enum {
 	COREDUMP_REJECT		= (1ULL << 2),
 	COREDUMP_WAIT		= (1ULL << 3),
 	COREDUMP_RECORDS	= (1ULL << 4),
+	COREDUMP_SPARSE		= (1ULL << 5),
 };
 
 /**
@@ -111,11 +114,14 @@ enum coredump_mark {
  * @COREDUMP_RECORD_DATA: the header is followed by ->len bytes of data
  * @COREDUMP_RECORD_END: the coredump ends here, the header is not followed
  *                       by any data and no further record is sent
+ * @COREDUMP_RECORD_ZERO: the header stands for ->len zero bytes and is not
+ *                        followed by any data
  * @__COREDUMP_RECORD_TYPE_MAX: the maximum coredump record type value
  */
 enum coredump_record_type {
 	COREDUMP_RECORD_DATA		= 0U,
 	COREDUMP_RECORD_END		= 1U,
+	COREDUMP_RECORD_ZERO		= 2U,
 	__COREDUMP_RECORD_TYPE_MAX	= (1U << 31),
 };
 
@@ -130,9 +136,11 @@ enum coredump_record_type {
  * If the coredump server raises COREDUMP_RECORDS in coredump_ack->mask
  * the kernel doesn't send the coredump as a plain byte stream. It sends
  * a sequence of records instead. A COREDUMP_RECORD_DATA record is
- * followed by @len bytes of actual coredump data. Records arrive in
- * order and leave no gaps. So @offset is the sum of the @len of all
- * records before it.
+ * followed by @len bytes of actual coredump data. A
+ * COREDUMP_RECORD_ZERO record is followed by nothing and stands for
+ * @len zero bytes. A server that didn't raise COREDUMP_SPARSE never
+ * sees a zero record. Records arrive in order and leave no gaps. So
+ * @offset is the sum of the @len of all records before it.
  *
  * The last record is a COREDUMP_RECORD_END record. It is followed by
  * nothing. Its @len is zero. Its @offset is the size of the coredump.
@@ -153,7 +161,8 @@ enum coredump_record_type {
  * type is raised in coredump_req->mask as a feature of its own. A
  * server only ever sees the types it asked for.
  *
- * COREDUMP_RECORDS must be combined with COREDUMP_KERNEL.
+ * COREDUMP_RECORDS must be combined with COREDUMP_KERNEL, and
+ * COREDUMP_SPARSE with COREDUMP_RECORDS.
  */
 struct coredump_record_header {
 	__u32 size;

-- 
2.53.0


