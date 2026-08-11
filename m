Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF839C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C15D26B00A3; Tue, 11 Aug 2026 11:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED8F6B00A4; Tue, 11 Aug 2026 11:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B03256B00A5; Tue, 11 Aug 2026 11:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7526B00A3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:28:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A0A4A284A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:28:04 +0000 (UTC)
X-FDA: 85089369288.16.26AA403
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 62968120004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:28:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K/KBwQ1I";
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/2uicMp+SuinB5ktmPhmPvncPAci8v0nQIiqA6W9Fok=;
	b=28PGg5Q89+p47JNyseQF88Dl5W1NUaZBYYQx+qHw+uuKv1BREEvcjym7lb2C1xAOfE6lrb
	OMYi9cqqB0H6QL45W2CgG0XYL2fGqRml+u08cP3x6BNOmLpmba7OSW441rvEmnAaEuBSjH
	3BsU6chb8X1Coeeu7AxPF3oS3J7af3c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462082;
	b=n5X8l3kKLBPc7ESZF0Zct800mk/hxyjZyuiyXFIim6csBN+8lwbE3ynuTNofxxDacVbtiJ
	Qbf9dvhfIv+B+2SiZGkXlCYz+U2N2EBIVwOeBc4RqiK+SHtrXxO4RucRpjmdaewzTTjMeB
	QqCK5E758N+8uhvVLgweEt8r1C8hdL8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K/KBwQ1I";
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 035186011F;
	Tue, 11 Aug 2026 15:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987271F00A3E;
	Tue, 11 Aug 2026 15:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462081;
	bh=/2uicMp+SuinB5ktmPhmPvncPAci8v0nQIiqA6W9Fok=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K/KBwQ1IHDI1MDYbS7fTsikWbe5KElyxN/AOhZjB5jkNBJTG70ZUanaSe8f+D+AeE
	 N6IKOnLUHHMI54GonNTKAyrWgAlqa6UI0MNe3OwL7GXH+7UrZi8FL8C/JxTP98qeZ3
	 P/hjhDhdyLH0DO/j9njjDI47FbiDrexz407HbGf0WfRTgR2jHrAzZNFjWLo9vmPQP2
	 4AHPVTdesd58QdKSTnuWIzPnAQhxI5FS4OPrgZMg8ohXAhHrioU7+nWPf1+XM6FReW
	 y83+xskJ48xIhl4L4mU6138/NG4e/goXvR9nvqU3of/Pchf/EuFjK9THikQsZU50B4
	 OAIXpFzja6ZcQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Aug 2026 17:27:27 +0200
Subject: [PATCH 06/11] coredump: add COREDUMP_HEADER to the coredump socket
 protocol
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-work-coredump-sparse-v1-6-cd3e8b1e356d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3783; i=brauner@kernel.org;
 h=from:subject:message-id; bh=4FXENe5nZxm7CHrTOSbNbye686t9axb9imZneIuX9U8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRV2yf0HnkQcXbK/a87tu556aPKp3xmncz5ap7feTlT/
 2x6/qrTqqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi9YUM/yNC4s4dnV+zc/qq
 Tqb1J9e7VuvNM9zOq+t/7+JdEellDzcy/JUVU40XFa5cXPSh9oT/9bi7AVusjpifVM+5/H6OkzF
 /NSsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 62968120004
X-Stat-Signature: 11nenp5yga6tkbgzcgkas7ab1pw3dswi
X-Rspam-User: 
X-HE-Tag: 1786462082-919692
X-HE-Meta: U2FsdGVkX1++vc92VKcRayEm4OdbE3E5sMvSI9WElxiSwYjiUAy1P26g5UtqlY8WpeR4LgUmjSApAWRS0Qa079DSQAgA3lklYpqfuGrhiwqU96PA1hSXja/GIQ59VDjScsnQJeAxIG7eihf+ZuUngPSHY8CtVqhnwnu6wZCki/zkB/OvPS39rg7Ru/Y6YRweEk/x1wrU2ZYXrRyOEjj1sbC3YhjoFS3yd3i9SEAkpC0M+FFEuzY486DsFyh4H8HKvzUYVfMW/cREPV/Uk75fxDzMvUzi+NmSQxwIakOgKsXSZ4itM3atDtnnt7QxS8rR7iQ2NewP0iftAxrorZSz8VHr4eZULIpwdWDJf7DPBgpmcbhjQ1ILUPOoGZru/Hdyl3x0XI03XYyXY+zUTu0Plm2gMY7R6+C+II7LpOSwe2FZPV7hwFaGOOA3QcP54HMA1bq9K9fB+W13trmBEF+eilQTzx5JBdnzOP4xITwu+wNq/D0xzL/n+wVO+buM+bhr8NgiTGd70amDm2r2vSgbuWlA3anbT+4m13FtoIWwXtmE7EAXBrTpChpEvkMy3SmkddextQZLE9YFp1eq7YngjtevoH0u/gR8vEGy8f2gBO24A0PiuM0F0s9tpEYHny9kQx3wtCAggnN0vj/OEda854YTmlEj4Ei/jrTFbmVyC7IG7Mw6qASKT3OozwXdlfcu7fxE8SPDrkMLwYfDbwuwdtZQqy5wdl6VsYc02JuoKZTCatY5bYUjZpD1wtBN23KXkkuCWd6Tm/W3vUm9bPP1Cp4TUhPwxwqw7kvx5caYb1kDj0g4R7fj+PEXxw1kvlR3VjmHlY+qaNYQIABxpx2AEwYUr3zLUxv3d+OuT2IWFYhVPKhHWLuFkSUTob+1kJVxJTcQr/GPf+J+/TKs5zuCso+1rob7C5qctrJ/ymZ7TA097eyH8KsarCPVnrz0iCfwYPusjwVCQBHopg1ymVI
 bnP4nBo0
 vd4/tqD8JLfxLWI4WsKIc4YmmmKNdSYJ1dlS13VDKqgf8Y+eIUHk1jiLpZx/hXxvdp6j/IwDzo4J3aB2pTsmJKEH1s2b9tNLqJNmwrMjqbg3MM/sgVGihPC0PZtdcYC+yWUpVsfYm/0guuqFal/6sg9cn8UfrNsy7ymIe2CkcZCGJXmVRVejXAwuXHRnWpYjgEFlvYXY8HlQeGxxCYz9gMq2a1IyZ6ziPRPOJ2zCotdD02xNGQ87edUBtEq6q0f++vZpz2q+Pb1hUxg8UEAw2/lODUSEtYDGOiQU0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A coredump sent over a socket is a plain byte stream. The kernel knows
things about the bytes it is sending that a server might care about. For
example, it knows where the unpopulated parts of a mapping are. We can't
communicate this to userspace currently though.

Add a COREDUMP_HEADER feature bit and a struct coredump_frame_header.
Userspace can negotiate that feature. Instead of a byte stream it gets a
header plus data. Reassembling the frames yields the same coredump that
would have been sent without them. The next patch will introduce a first
feature.

The frame itself is also versioned and thus extensible with the same
protocol as the ack-req sync.

A kernel that doesn't know the bit doesn't raise it in
coredump_req->mask and a server may not raise a bit the kernel didn't
advertise. A server that doesn't know the bit never raises it and gets a
plain byte stream.

This just adds the infrastructure.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/uapi/linux/coredump.h | 52 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/include/uapi/linux/coredump.h b/include/uapi/linux/coredump.h
index 662e0468da6e..5252480d3eec 100644
--- a/include/uapi/linux/coredump.h
+++ b/include/uapi/linux/coredump.h
@@ -11,12 +11,16 @@
  * @COREDUMP_USERSPACE: userspace writes coredump
  * @COREDUMP_REJECT: don't generate coredump
  * @COREDUMP_WAIT: wait for coredump server
+ * @COREDUMP_HEADER: send the coredump as a sequence of frames instead of
+ *                   as a plain byte stream, see struct coredump_frame_header;
+ *                   requires COREDUMP_KERNEL
  */
 enum {
 	COREDUMP_KERNEL		= (1ULL << 0),
 	COREDUMP_USERSPACE	= (1ULL << 1),
 	COREDUMP_REJECT		= (1ULL << 2),
 	COREDUMP_WAIT		= (1ULL << 3),
+	COREDUMP_HEADER		= (1ULL << 4),
 };
 
 /**
@@ -101,4 +105,52 @@ enum coredump_mark {
 	__COREDUMP_MARK_MAX		= (1U << 31),
 };
 
+/**
+ * enum coredump_frame_type - Type of a coredump frame
+ *
+ * @COREDUMP_FRAME_DATA: the header is followed by ->len bytes of data
+ * @__COREDUMP_FRAME_MAX: the maximum coredump frame type value
+ */
+enum coredump_frame_type {
+	COREDUMP_FRAME_DATA	= 0U,
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
+ * sequence of frames instead. A struct coredump_frame_header is followed by
+ * @len bytes of actual coredump data.
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
+ * COREDUMP_HEADER must be combined with COREDUMP_KERNEL.
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


