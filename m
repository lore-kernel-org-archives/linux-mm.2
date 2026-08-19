Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40E61C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7566B00B6; Wed, 19 Aug 2026 19:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381706B00B7; Wed, 19 Aug 2026 19:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE8E6B00B8; Wed, 19 Aug 2026 19:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F17596B00B6
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:11:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87C7280474
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:24 +0000 (UTC)
X-FDA: 85119567288.18.A3A1135
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A614E40003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RXG/YYTt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Og5LuYw9irwMf4vsrulJiBq5r2ZOIzyhhf4bBsBBJEs=;
	b=KxVvsC17EY6Q+FSRwmNh70aHwfJS+OHv4OC9uuhE+76Jvj6TmKMIiKNhXL1NWlHsp3Y+x7
	86EbTrhZq6CWmQ8GWmz+1bUJ68SGlqYG60VqnezVwZO8uMG3uOM5MItIH6LwKEnomgeHAT
	4rXfKmTyxuciAByfjSC+LqRsWuf+nyg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RXG/YYTt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181082;
	b=GUQ9wqw4ptTygd+ETyauZH4xsBArokeiX1EYDmKqFOWVfZDTsvXYRR5w7ZE9auvM1u9mKx
	EFvMYbySDPG/cjiLTTotMnxUuRXUhIdQbCjWgFZQ6Ph5pHjTTcOlrHPIPPjidKXvkEolQ0
	faMKg8MNKiju3VStZ3s9Y1bRfoHnA6s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0447141846;
	Wed, 19 Aug 2026 23:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2771F000E9;
	Wed, 19 Aug 2026 23:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181081;
	bh=Og5LuYw9irwMf4vsrulJiBq5r2ZOIzyhhf4bBsBBJEs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RXG/YYTt+bkLrUqAYUwB6g56axFgy05P29XBUXezAJtgzZVVyUVZkN36+6yXpX22W
	 I1hQX/T/cq7k1ThGlK+TQDEqeGo76KNdBkw7zPmFtM/3SwSmLbTmmyeKcPvW8TaY3C
	 tANmQUAgDDRN5buaMPKPsD46HQ1g3ozGV8u0jD/Yt+pxvTEMOSJy0WReZ4fr9b+F9B
	 1xQjXQCSfwd3pWM/XS6sUEs4BiUMbvd0Fgju81yx5VAJE++X/XYbKg8P/0ZywvuatM
	 ow+PxpH17Kz3MzgazFkgOpltbBEuBsmT3P4pAQ77fCca/Bag/9t3ODPq29cHfQDTnR
	 Vc8PaEJyHdFqQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:32 +0200
Subject: [PATCH v2 15/22] tools: sync coredump.h header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-15-ba32dd718c51@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5096; i=brauner@kernel.org;
 h=from:subject:message-id; bh=rV3/tTqmZ+vrXAlNo6OCI83xZSMJVfwz+jMpUuBEQ8I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me/fH6RpJn92km/suu9BMR/T81fcapsnKczaEin/v
 +DS7Qn1HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABO5bcXwP/Ts57ZpZ1eZ11W0
 PbOvmZZq3LttW8qp6Q8jl0z+0Vd/0Ifhf3XA92Lb0vvZbd6M6jtSWjL3Msf2vF45tflaa1a1+qo
 LXAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: A614E40003
X-Rspamd-Server: rspam07
X-Stat-Signature: uz7kcq4fima437ku6znpm3pr1g3oi4rr
X-HE-Tag: 1787181082-952538
X-HE-Meta: U2FsdGVkX1+qef3nlP1fK+7XE00ITfOQtWayTPkLL/82efYXuUXdW6d3T2lsXgbunCLtsF0UhM5VJoCm+iO2tBoBvdjEbYdvqdF3LavVP8S62TsseBRckIHpsGMHUKFInSs+1sERlw6ERF+9Zw8JxYORO5Rn7vKff540an5nTFsADd1i+fEz93v3MVKtPeRbf64ShFKAa/g/auVYIxe0JbCpk2kBKUDN5u90XpsQd8eMF731lfyzghkioJN9nu88TIgkfGbkpTjU3S4a+5n43TzbQj7G4R0CuZvhZDzQYgaTNEme9Y7wguKHonOxW61jSpuI4nYrsj7UTgtrLoBFVUB+ssxjeNrlgoQlM5bX9VnVAehBTx2SkI5LVddrPJEHSXDGoSDwntQkAFNAJr9Sg4IwHGxAmtPgb2FEb4X1GD+qg5+pQFuHGDk3CzglTWOtpx4ISliGTZlA2ywslOYKi673y6NRPfdjC5o+WNb1GBZobp6twTzWx9mahlISwtvxllmUTJ68p7MB3ns+0DBZM2NiD8YPv+74xoK6ex0jPDvfQA1FDhu3Ism1gB3/57bAuQtcTgU6HfEuCDoptvEFcJraIASH5FYKwkofPAEHDdnwa46fjVpHHP+w9McD9TONe7hQma5j/Bcmv8EcwIuD3nr3bZIzSoRnbDf3RnbqBOI7e13WpEhoXgVRKTQZnH84Iii2KSTyUnxoAYBLmJokd2Jd8qa0FFYqb7d7KT1VAdnsfVZXKcoSaubp22T4CHvqGt+gT86CnLfdJf3U7Tg/vNmR0BJrhn56eWsrSQ38Nq2dUWQJ/ifJSjCHxBoX7nmxNJqGmgZcPcd88/WH+IrTjg0XouY8XsJ+avBZw5bb5Z/XRyVFVnipORa/IMP6epC0Ysi2orDe0jRqd4nXZIpW5X0Lv/GcQxkyj7LZZUgy3xNwi//lyNok+xocJuX8NRs+F4RzwkbzYVo1161eFub
 nxXJB9fV
 K9JTksK7nOu9SjJ8XqkcuEyufsy64UV4Kl+q8rETZ/D27Ok/VzdyJfSU/UL8TfUbjZWOuKX63dcWMoYWxP3iXElKnA9LuynVKehli6zqv5fgKRx9bxLrizt+rtONStGHP1VP8MOQBTIPWMDyoSUkNsHOODozO5/34fvZ2InvdEiMvttBz9tpIVGLWmdJv4DjZogptJfXw66qNgrkYt0ioTVTtHaL+fYx6qcgZcGboAXVtfNEqLddKr4wuFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sync the headers for the selftests.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/include/uapi/linux/coredump.h | 79 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/linux/coredump.h b/tools/include/uapi/linux/coredump.h
index dc3789b78af0..f3771861ca48 100644
--- a/tools/include/uapi/linux/coredump.h
+++ b/tools/include/uapi/linux/coredump.h
@@ -11,12 +11,19 @@
  * @COREDUMP_USERSPACE: userspace writes coredump
  * @COREDUMP_REJECT: don't generate coredump
  * @COREDUMP_WAIT: wait for coredump server
+ * @COREDUMP_RECORDS: send the coredump as a sequence of records instead of
+ *                    as a plain byte stream, see struct coredump_record_header;
+ *                    requires COREDUMP_KERNEL
+ * @COREDUMP_SPARSE: describe the holes in the coredump as zero records
+ *                   instead of transferring them; requires COREDUMP_RECORDS
  */
 enum {
 	COREDUMP_KERNEL		= (1ULL << 0),
 	COREDUMP_USERSPACE	= (1ULL << 1),
 	COREDUMP_REJECT		= (1ULL << 2),
 	COREDUMP_WAIT		= (1ULL << 3),
+	COREDUMP_RECORDS	= (1ULL << 4),
+	COREDUMP_SPARSE		= (1ULL << 5),
 };
 
 /**
@@ -30,11 +37,11 @@ enum {
  * member is set to the size of struct coredump_req and provides a hint
  * to userspace how much data can be read. Userspace may use MSG_PEEK to
  * peek the size of struct coredump_req and then choose to consume it in
- * one go. Userspace may also simply read a COREDUMP_ACK_SIZE_VER0
+ * one go. Userspace may also simply read a COREDUMP_REQ_SIZE_VER0
  * request. If the size the kernel sends is larger userspace simply
  * discards any remaining data.
  *
- * The coredump_req->mask member is set to the currently know features.
+ * The coredump_req->mask member is set to the currently known features.
  * Userspace may only set coredump_ack->mask to the bits raised by the
  * kernel in coredump_req->mask.
  *
@@ -101,4 +108,72 @@ enum coredump_mark {
 	__COREDUMP_MARK_MAX		= (1U << 31),
 };
 
+/**
+ * enum coredump_record_type - Type of a coredump record
+ *
+ * @COREDUMP_RECORD_DATA: the header is followed by ->len bytes of data
+ * @COREDUMP_RECORD_END: the coredump ends here, the header is not followed
+ *                       by any data and no further record is sent
+ * @COREDUMP_RECORD_ZERO: the header stands for ->len zero bytes and is not
+ *                        followed by any data
+ * @__COREDUMP_RECORD_TYPE_MAX: the maximum coredump record type value
+ */
+enum coredump_record_type {
+	COREDUMP_RECORD_DATA		= 0U,
+	COREDUMP_RECORD_END		= 1U,
+	COREDUMP_RECORD_ZERO		= 2U,
+	__COREDUMP_RECORD_TYPE_MAX	= (1U << 31),
+};
+
+/**
+ * struct coredump_record_header - header of a coredump record
+ * @size: size of struct coredump_record_header
+ * @type: one of enum coredump_record_type
+ * @flags: modifiers for this record
+ * @offset: offset in the coredump this record starts at
+ * @len: number of coredump bytes this record accounts for
+ *
+ * If the coredump server raises COREDUMP_RECORDS in coredump_ack->mask
+ * the kernel doesn't send the coredump as a plain byte stream. It sends
+ * a sequence of records instead. A COREDUMP_RECORD_DATA record is
+ * followed by @len bytes of actual coredump data. A
+ * COREDUMP_RECORD_ZERO record is followed by nothing and stands for
+ * @len zero bytes. A server that didn't raise COREDUMP_SPARSE never
+ * sees a zero record. Records arrive in order and leave no gaps. So
+ * @offset is the sum of the @len of all records before it.
+ *
+ * The last record is a COREDUMP_RECORD_END record. It is followed by
+ * nothing. Its @len is zero. Its @offset is the size of the coredump.
+ * The kernel only sends it once it has written the whole coredump. A
+ * server that hits end-of-file without having seen an end record must
+ * treat the coredump as incomplete.
+ *
+ * The @size member is set to the size of struct coredump_record_header
+ * the kernel knows and lets the header grow later. It comes first so it
+ * can be peeked. Userspace must consume @size bytes and discard
+ * anything beyond what it knows. It must refuse a @size smaller than
+ * COREDUMP_RECORD_HEADER_SIZE_VER0. @size covers the header alone.
+ * @offset and @len count coredump bytes.
+ *
+ * The @flags member carries modifiers that change how the record is to
+ * be interpreted. No flag is defined yet. Userspace must refuse a
+ * record carrying a flag or a type it doesn't know. Every new record
+ * type is raised in coredump_req->mask as a feature of its own. A
+ * server only ever sees the types it asked for.
+ *
+ * COREDUMP_RECORDS must be combined with COREDUMP_KERNEL, and
+ * COREDUMP_SPARSE with COREDUMP_RECORDS.
+ */
+struct coredump_record_header {
+	__u32 size;
+	__u32 type;
+	__u64 flags;
+	__u64 offset;
+	__u64 len;
+};
+
+enum {
+	COREDUMP_RECORD_HEADER_SIZE_VER0 = 32U, /* size of first published struct */
+};
+
 #endif /* _UAPI_LINUX_COREDUMP_H */

-- 
2.53.0


