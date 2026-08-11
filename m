Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B82C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD226B00A9; Tue, 11 Aug 2026 11:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50EF66B00AA; Tue, 11 Aug 2026 11:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE596B00AB; Tue, 11 Aug 2026 11:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 086C06B00A9
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:28:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74BAF804AF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:28:13 +0000 (UTC)
X-FDA: 85089369666.22.8F17DCB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A56764000A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:28:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JyURzhn3;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aiM9rGr2K/f+tuwhqreFuuJ12f+/3ydkN5JIi9mR514=;
	b=jMJkWmhkQKaQKqlbUVx7SBxzGQmm+kfdJaECS47fbH3iNK16cqGTndFUo8/s728ddtb8KH
	4eLjYHiGVQG5q+nFQwQH5xA7/0le0z87xaXGNoNqXpZftb+7/BMsBCzxwKPggYjj5EAEsk
	qyEA2hGeJ7pBgcjhug+GzVhvzLgFU1A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462091;
	b=nwlmNtQI+Zu73QTTeQgUN4gxhRr98o4Zi0teVkzlcncvhh3YbES0M6EVpZApSy/0tby+Ke
	R3o0S8H5Ddxftz7TtRTC47vfH7D1x00e/4LdxfqqLMAsyc4ZmfE0GBaiB+K5niHMhrCkBu
	80ywipe4mwvlklfrN/Dsasxa4l4ILAk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JyURzhn3;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47042600AE;
	Tue, 11 Aug 2026 15:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2261F00A3A;
	Tue, 11 Aug 2026 15:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462091;
	bh=aiM9rGr2K/f+tuwhqreFuuJ12f+/3ydkN5JIi9mR514=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JyURzhn3XjAcnWiEScQi8/UqT34v+EtK9PIWO1aL/xbGqrmROWJlxuawQ0zj2TNIn
	 mdSc/wJ8OfTYPzeqYptne3SwXSLchu3RUnzvlPpxTDzkn1muQi4ffyTX7rOiKYjPdK
	 s17oHqviPs0IapHVaa8XZjLwVrSi9i1FoQDiB4AZeUOQ9vf74614K2symcIzZlpP7g
	 FNAZX2gF7zep15hvcFXHH+B9mcGI6kfqkw3pyoAvFHtWRH6cXK0VOhNzyHgvwfle76
	 z0Duap9AF7aGLxHPkFsLFaGcmL57DPfm16fPErIvs1fgAps8Cm5CteE7lZkR85em5O
	 YkNO1IPzzTU2g==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Aug 2026 17:27:29 +0200
Subject: [PATCH 08/11] tools: sync coredump.h header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-work-coredump-sparse-v1-8-cd3e8b1e356d@kernel.org>
References: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
In-Reply-To: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
To: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4229; i=brauner@kernel.org;
 h=from:subject:message-id; bh=J+PQgfbapuFtQu/lpytQUE+OgnnVZmVmxqMxiZbP+d8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRV2yesOSn0Wr63ryk1puDd6yP8mddjJDheC4Qf0VYQe
 z1XPrS8o5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCIpkYwM2zq2Spb08z2P36Nc
 38D3QKY95OoHz9b5UZqKne8vvJr3jJFhtXfQFe6LqywULm2aulx9YkT3orcy5pd/R6TcOaiZdvo
 QDwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A56764000A
X-Stat-Signature: p1gkt48h9mqk9kc9crbn47h3zztb74ti
X-HE-Tag: 1786462091-569057
X-HE-Meta: U2FsdGVkX180m6B5CKotfYOIUFZ9oSAPnKOAUZK8iyWMhWblSzhsePWvXARsnB9MXajMRFN6e59JMF0mOa/Wvtw7lyD2kdfJD4o6rAyskLmWQtu91iRaJaTX3x1r87YWHUJDlpNg8vXJw1vFIyzAtDBa6d4rrKD1/cPXlueBGZEfpiSAEBOX27+DGZ7yJ3I1lfCmVTxpUUzD6OGqfbUv7Y9caM4T+MbdIyV/q5u2yj+vrKIEjgAvO5Bw5SQ5VXjaG5weabdDcwu8taovjWPY5uKo1IRWe96AzP994o6LurBZ+NbKsOQVRwocyJ2inriSAuk5ITP2jHWDpOff/f8xaKuFHR+sKlM4JkF/ABz61EaOHCHPH2AK4uHXEmkRLMsLB3ObCsnXz73B3r5I+5+Pilz4IjABD+5wAyWrr6n2ps3/Hh+KrhcCqDZZrZ4wF9cMZ8dP8NQNbXmok+B7p1PMLfI9edG5TKaJJCJNxXMh34nKjJkpSH35Z7fnf3j/gqRbBtVHgNUuTcT3s5Sm45/XVVnpyvjSVy1gL6jk/wXm5lYD8ClMDuVjaRhPDAHc2fVpLJDa3BHmZ1vpjW+oPfDoctg7JGvZ8BrTD75PNHCs1HGpAsO/DOlBP669Q1le+PNkqTKImFBqdvwbKEZykCV2Oj1Sc02TJCtcFaid24CYytV6U6LANu/E6mGOYpzzMqTRdCDTh/spc+r8cTjYI+WYNhcYgaZkij9V2PryqDPGtdznsX8O9Fv9GbRN1jJB3++C93Q4JmVeVN17EzydW1i88Rl2y0uTWQs8NqYP6AAn3TGGM2TzMQg/JpG95S6n16UxBuLy2a4slXPrhBJ8J5J42YM1R/CohPf9qCwnmjKjwb277vgP8EDD2Bf4hSMhgr6HFyLmDlQ4BeW+X3piSfPZ66eg2u8sFzqF4mcYbUmcK8EH3pSYIO68N7/epjEsHA7RzO9Hmbhjxb5ijY/kDdY
 CpDdPpzE
 oO9v7zGgICpyv/Nunz6LPbDt6gUaub3DbkKpSx568yHruy6n3uyIaARBuwqjCOZN0Lj87oXIs/9k055Mo6KW3WWQLu3tI66c3E4wR4Koanrkpx+5+lYQnpUwq0hCdmxMUhHKh+U0wx001x45qbss68zWqqLqYL9E0CTZlIpGsbt14SnvtANEfJiGHZOCkJJmMFk6q/FoyI1r+k6dlribPa9mv8Id396Ay1tVG+1p9M6VgunTQR/sen//7tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sync the headers for the selftests.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/include/uapi/linux/coredump.h | 65 +++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/linux/coredump.h b/tools/include/uapi/linux/coredump.h
index dc3789b78af0..312bafabb467 100644
--- a/tools/include/uapi/linux/coredump.h
+++ b/tools/include/uapi/linux/coredump.h
@@ -11,12 +11,19 @@
  * @COREDUMP_USERSPACE: userspace writes coredump
  * @COREDUMP_REJECT: don't generate coredump
  * @COREDUMP_WAIT: wait for coredump server
+ * @COREDUMP_HEADER: send the coredump as a sequence of frames instead of
+ *                   as a plain byte stream, see struct coredump_frame_header;
+ *                   requires COREDUMP_KERNEL
+ * @COREDUMP_SPARSE: describe the holes in the coredump as zero frames
+ *                   instead of transferring them; requires COREDUMP_HEADER
  */
 enum {
 	COREDUMP_KERNEL		= (1ULL << 0),
 	COREDUMP_USERSPACE	= (1ULL << 1),
 	COREDUMP_REJECT		= (1ULL << 2),
 	COREDUMP_WAIT		= (1ULL << 3),
+	COREDUMP_HEADER		= (1ULL << 4),
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
@@ -101,4 +108,58 @@ enum coredump_mark {
 	__COREDUMP_MARK_MAX		= (1U << 31),
 };
 
+/**
+ * enum coredump_frame_type - Type of a coredump frame
+ *
+ * @COREDUMP_FRAME_DATA: the header is followed by ->len bytes of data
+ * @COREDUMP_FRAME_ZERO: the header stands for ->len zero bytes and is not
+ *                       followed by any data
+ * @__COREDUMP_FRAME_MAX: the maximum coredump frame type value
+ */
+enum coredump_frame_type {
+	COREDUMP_FRAME_DATA	= 0U,
+	COREDUMP_FRAME_ZERO	= 1U,
+	__COREDUMP_FRAME_MAX	= (1U << 31),
+};
+
+/**
+ * struct coredump_frame_header - header of a coredump frame
+ * @size: size of struct coredump_frame_header
+ * @type: one of enum coredump_frame_type
+ * @flags: modifiers for this frame
+ * @offset: offset of this frame in the coredump
+ * @len: length of this frame in the coredump
+ *
+ * If the coredump server raises COREDUMP_HEADER in coredump_ack->mask the
+ * kernel doesn't send the coredump as a plain byte stream. It sends a
+ * sequence of frames instead. A COREDUMP_FRAME_DATA frame is followed by
+ * @len bytes of actual coredump data. A COREDUMP_FRAME_ZERO frame is
+ * followed by nothing and stands for @len zero bytes. A server that didn't
+ * raise COREDUMP_SPARSE never sees a zero frame.
+ *
+ * The @size member is set to the size of struct coredump_frame_header the
+ * kernel knows and lets the header grow later. It comes first so it can be
+ * peeked. Userspace must consume @size bytes and discard anything beyond
+ * what it knows. The same way it deals with struct coredump_req. It must
+ * refuse a @size smaller than COREDUMP_FRAME_HEADER_SIZE_VER0.
+ *
+ * The @flags member carries modifiers that change how the frame is to be
+ * interpreted. No flags are defined yet. Userspace must refuse a frame
+ * carrying a flag it doesn't know.
+ *
+ * COREDUMP_HEADER must be combined with COREDUMP_KERNEL, and
+ * COREDUMP_SPARSE with COREDUMP_HEADER.
+ */
+struct coredump_frame_header {
+	__u32 size;
+	__u32 type;
+	__u64 flags;
+	__u64 offset;
+	__u64 len;
+};
+
+enum {
+	COREDUMP_FRAME_HEADER_SIZE_VER0 = 32U, /* size of first published struct */
+};
+
 #endif /* _UAPI_LINUX_COREDUMP_H */

-- 
2.53.0


