Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6671BC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61AF96B00B3; Wed, 19 Aug 2026 19:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F24F6B00B4; Wed, 19 Aug 2026 19:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5079A6B00B5; Wed, 19 Aug 2026 19:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 225996B00B3
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:11:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A1D721C12A4
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:12 +0000 (UTC)
X-FDA: 85119566784.17.4840FC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id BD8F514000E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQBRGmLy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jCUvWFr7gPW9ynmwtqLqLk7sLgqWKyJVLH5+/uw4b/c=;
	b=l6cKgkLDPGnLQYjPWJNN0F2HQ1WB5RpAveJYqvOkhN3eaMlVuaIwP1IecbcBSdIVpYk9zm
	2gtprlc8ilLOp27gBA+Go7ELt2wTPr7fgk2R3nsmAdK/Jef06rzK+xI98GZUb0dvVQba6F
	8bq3OihQ5d48S75CZaZP1LXYLPd8KKE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQBRGmLy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181070;
	b=lKqMa+0/riWuFNmLwRrx5Z65JglDhnOYlymaGl3cj74iScLYQdIjXGMViWHRa9YJNZnuoQ
	wYfGEMAdnmbtMnK8UbYyluw+QshMAZ1Y4Rg6L+lI46bGHE7AqKnJi6L1QZncxUVf+6FJDS
	Te5VudTsxG2kgR+ZnMRQ1vT5uu5cVQA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7BD243BD1;
	Wed, 19 Aug 2026 23:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECFE1F00A3D;
	Wed, 19 Aug 2026 23:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181069;
	bh=jCUvWFr7gPW9ynmwtqLqLk7sLgqWKyJVLH5+/uw4b/c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XQBRGmLyQq+gFdTAfXJTbo4gh1jXQzfreWedQazCzjs87t7/N+VKU6T9W+qUn38ZR
	 j57ezN5YX/+dNb2pl+ZLvK0Hdx+iF15DU/zpG8wiAXOQBlC5VUuqWfpFZaqn3Uavig
	 dFJnnTLx5cHdFsMpBHg/EKrLaUEvdXMD+LnlttUDvAHHSwaOPpXoX4p9rL+k5CqryN
	 K1hxF94nl58Lx3koPf/d5lzpiQ0UavvwTnwGQwI/mWHjlTQoDQiIY90bXwAIm/oMRB
	 PZ8YYwSWT5U6u+c8KAIOOXLW7rxcDRD04zZ3ZosFQdDTa2c/JZkOxNN0sdcFeWyAX4
	 fTcZUi2YIX2HQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:30 +0200
Subject: [PATCH v2 13/22] coredump: add COREDUMP_RECORDS to the coredump
 socket protocol
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-13-ba32dd718c51@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4628; i=brauner@kernel.org;
 h=from:subject:message-id; bh=r1vIA9hpNEqv9L3LrgExsab6+Vxj9iHA3Av+wMJZgnw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me+P1N8vecCyR3bxmp9b1X6zrvxbmSh4bm2mgIReo
 naBw8+6jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInMfsvwTyvFasLKOTm/GH+9
 r9Sv+/7jzp/yNe7FL798/XCbrSXtFj/D/zyvH2/uzv7MNlW68YuvmZ9eikOUSdCrxb8XTmJ5V7T
 EnBMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: BD8F514000E
X-Rspamd-Server: rspam07
X-Stat-Signature: q1xbjf5gwwbodr4k3g3ruwpqozxagbop
X-HE-Tag: 1787181070-884277
X-HE-Meta: U2FsdGVkX1/xqObjK4uyQe9DMuV6rGP3+pP4sPRcl8fSPT8gyJy5rfi8II57163R4q1ccv+DR0Yt9PZg0gpzBaO0RDZR5BODquwiP87IUg/2g32QaQl6Lg4juNyA+MdTAz2d8/JUbo/TNC6Ut11steynGk4CE8pXt8nfT/lhjQU4WinJPLBgyg8KPGQTlX0FYTLwLKgYULf1t2v5KRfFpsM3Xgg4LSPwO+NDuWmmCp2ETOQ79HFxzPwbkPe7DoGdLwH6MST0YuMAAPZqUsDqkibQLieE89ofsOg+L5mCo3z8vkSaF3iXCVzruKNW7tDnNqmlEhLtCl29XvBtaFm+22TNHBWDDTZdNHz0NFkmFJ6SS1rAPJxFCV20ROJ0J9KZ0qZL7TkzzMfhYZjy5k4IuLKhtM/X+0MfOuoolpUa9FAxPJO15BdSapISz7+V2Jq9gnmWVrtcwfAQpn1PjjUVHAF9ySJzDmeo1fyzb6fE2+RIeqGk4S08yeUii7aK886R79ix1T+I9vQTHaf6MR5oirjnl1ZfJTVF/KkX1mCC8pEm5+1Xb5bOwLaLEKTdAHHVPN5EiQgxSQCBTAG1gaZV/R9K7UM/Z0vG9XQOQi6LA6a7V2d5pORXu8PihS2CF3SN1qQuY3gFbXk6++U1cmxb3Z83BZWj2NsWDw9Y+kh1GM7EJl7lRZWtEIJL52c5fMZcWth8g8cyRI5oV8iOim5ruD4oZyiCXklhGkFidEWcDLoyly1l6zu+l7o/H4rrbzMtM8bgTax49I+ZsXuF1gvH0qY7uMe6CD+8rMA08BUYuomWuFN5IxVtmqMcdOUjBFFevbBN5EhzTLlgS9kap6AB/hYlH+54nt7zILmIF6xbqNiBUz6fQmxMmTUEYe9/mv3FHI/9jYCFwm7c5/AMksI5LnGkhWWkmU9oaVExEsr1iNRXmcWncI9DxC5JvU9L3RRjaLbZN4VEUm1dmjyx442
 YplvNL1t
 shVOEb+oPRbC0ja2XLpwHpNrJqGXXoSY2/uogyWQ0IKaaske+6vPGOmJHwzyYolJPxuLyG00+OZs9mhJlm0MIAEkrqlCAJj5GaBvxgmEi5tE06zz2r7CkE+Hm6pt6UhqnThZcnZRYrshr71l9hllhIBd8XhmZMHaCQEVxjiMwWSbQa2W9r9U13ILxYUK3cfG4ziWj89KjSSE4PGoPlS77AXS05mqyO+sKL4Djk8meZn7aoZu4bRPSPZzyA23Li2NIq5Bz2Fl1E730tMoZgZfcgUkTGQcf4LMkOewNJXgyFFKVrjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently a coredump sent over a socket is raw data. The kernel knows
things about the data it's sending that are useful for a coredump
server. For example, it knows where the unpopulated parts of a mapping
are. We can't communicate this to userspace currently though.

Add a COREDUMP_RECORDS feature bit and a struct coredump_record_header
so userspace can negotiate that feature. Instead of a byte stream it
gets a header plus data. Reassembling the records yields the same
coredump that would have been sent without them.

The record itself is also versioned and thus extensible with the same
protocol as the ack-req sync.

A record stream ends explicitly. A COREDUMP_RECORD_END record closes it,
carries no data and reports the size of the coredump. It is only sent
once the whole coredump has been written. If it's missing the coredump
should be treated as truncated.

This just adds the infrastructure.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/uapi/linux/coredump.h | 66 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/include/uapi/linux/coredump.h b/include/uapi/linux/coredump.h
index 662e0468da6e..0bd5c8662ebe 100644
--- a/include/uapi/linux/coredump.h
+++ b/include/uapi/linux/coredump.h
@@ -11,12 +11,16 @@
  * @COREDUMP_USERSPACE: userspace writes coredump
  * @COREDUMP_REJECT: don't generate coredump
  * @COREDUMP_WAIT: wait for coredump server
+ * @COREDUMP_RECORDS: send the coredump as a sequence of records instead of
+ *                    as a plain byte stream, see struct coredump_record_header;
+ *                    requires COREDUMP_KERNEL
  */
 enum {
 	COREDUMP_KERNEL		= (1ULL << 0),
 	COREDUMP_USERSPACE	= (1ULL << 1),
 	COREDUMP_REJECT		= (1ULL << 2),
 	COREDUMP_WAIT		= (1ULL << 3),
+	COREDUMP_RECORDS	= (1ULL << 4),
 };
 
 /**
@@ -101,4 +105,66 @@ enum coredump_mark {
 	__COREDUMP_MARK_MAX		= (1U << 31),
 };
 
+/**
+ * enum coredump_record_type - Type of a coredump record
+ *
+ * @COREDUMP_RECORD_DATA: the header is followed by ->len bytes of data
+ * @COREDUMP_RECORD_END: the coredump ends here, the header is not followed
+ *                       by any data and no further record is sent
+ * @__COREDUMP_RECORD_TYPE_MAX: the maximum coredump record type value
+ */
+enum coredump_record_type {
+	COREDUMP_RECORD_DATA		= 0U,
+	COREDUMP_RECORD_END		= 1U,
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
+ * followed by @len bytes of actual coredump data. Records arrive in
+ * order and leave no gaps. So @offset is the sum of the @len of all
+ * records before it.
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
+ * COREDUMP_RECORDS must be combined with COREDUMP_KERNEL.
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


