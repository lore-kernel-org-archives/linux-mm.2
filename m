Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1B66C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B79D06B00A5; Tue, 11 Aug 2026 11:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B513F6B00A6; Tue, 11 Aug 2026 11:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8ED86B00A7; Tue, 11 Aug 2026 11:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD526B00A5
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:28:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3C36140481
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:28:08 +0000 (UTC)
X-FDA: 85089369456.21.F5D44E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3767BA000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:28:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNbl9TI+;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCoOreTJ2X/U61okovu+QNFm+oz9E14qwVyjp1SenYU=;
	b=ciAbSytCXvezOjfRRVksJIxN78tCzhm8Ah1DG3ZLBo5xt5kUGGZ8yDpkOyP5J0zcUgTQEb
	S4oK++XwNn/9CuC0WRGMqn22Y87vkCRS1HaUKw1fmhopquty0dKqgHbBa8UfH6y8eIto56
	LpR2LL/Osh1a1L4Lk9hXoUimatNxAQs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462087;
	b=P1A5tqW6ydj3GaM7UzosFUVcgKdgavflAebvSzYTw8bNwDFyYWlLT4DVtG3c+pAnMc/8GE
	89/kbXd8tlq0WSN27WbnVdzgZPiWxl0AKpz1EkRBTfnyvpKRtJqjCug4j1GCDwV0g5ESAc
	8Gm3IRX+6NJJSd4uKMW40UyqSJGcOOs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNbl9TI+;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86D8643F81;
	Tue, 11 Aug 2026 15:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400961F000E9;
	Tue, 11 Aug 2026 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462086;
	bh=sCoOreTJ2X/U61okovu+QNFm+oz9E14qwVyjp1SenYU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eNbl9TI+d6Es9bc/AmTgJ67rm9UG7VS/zO+HHdhXLVol8SmFRI47CW0i13SWMZym/
	 vePrh2c62xPxDOxkwoTu4jAO9P+Zgd+FeZgsvfV537P7hC4XaKsV/AN/EGkfHmc3tC
	 sF3jx+JRyhJroiIU18oQaqIkABgUW8X3opwfY1YnylUO0lFoHUfvB/YChdsG7w3Bow
	 4dOlvRGU2Lk7+MVqdjht4kTqujXmvRhIUILx76jTqmyZmB8F7mR6hZO3oXgT0kgESI
	 wD4qtuIgd6al2df5xUQGPK7RpYtcCc9Z0oddjUuKMYPArBgws7dLcGGsQeOh8FMkh1
	 by7tNafbgiprw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Aug 2026 17:27:28 +0200
Subject: [PATCH 07/11] coredump: add COREDUMP_SPARSE to the coredump socket
 protocol
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-work-coredump-sparse-v1-7-cd3e8b1e356d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3305; i=brauner@kernel.org;
 h=from:subject:message-id; bh=uBST1XLQTUf+x0hFBtk8wUBZ/6YyWD5sMLzaZ6j7wCs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRV2yfsV7+0jE90UseLxdeWPnmcv/RASONqk85bkzbMe
 Mrd1N6/raOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAix+UZGZpz2R8uEL4yI//y
 rQ+5MlV69T2bTR5ksS7sFFVrMdjW2M/w31dBU37BJv7/Z34LL774sKnBTFuTe+tH2fj414HfJOy
 D+QE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3767BA000F
X-Stat-Signature: 9p5w5mcssyyaxib9ez8r7m3ab9be8qcw
X-Rspam-User: 
X-HE-Tag: 1786462087-520369
X-HE-Meta: U2FsdGVkX18aYivqY9p6ZQ8VHAkrowC8yFYLwR2uYjekOctCJ8cdfJ9LLVRiHs3nYU4msh2SkrRlCZq5XmfcSbe6XyZYmY9D0n0lSaDdIAKZA7vDiI299lcHeGYi1CHIiOSbG/GQNRshySABqCm51nvTZz3nInE3AXGo0QOC5Ce4ev5i+AmRKcyWbswDfFpZVLXhmnf4TQt2zGU0zfT5soWv7r5n/Mqwagaw1FmNY3JSIZphmKoqDrc21GLrxyIIp4vr1YkuLZJisszFHxoAWtYGNchTfteeqCinwv+rdGBDU9kEdmO6e4DtvZCpQ4gIHm498EzhFqSEx7WBSa24dT0eyIwF5Dp9mfq07e34qy2+AYuT5zCOBnhUgoLWBTK1dM5k20q5dHEROIpwwoLroj7DaGRfEw9yxbmpIcLQHbhxIwEbADWFU2IFRjPR1IfEZuXViiSs0tcDH6yTHxNc4AhPzGaNs70RTrc8a99mq/TdiWXdH8S9jA9/QUgBs1mYEq+7uw0evaUp4wl4k7nqao21h2LbCthc+39c4+5Be3hmDWr+JY6eoTyjjRb4lyHDOgwuLfZp6xbMo4fF0l4ruSuIoKW83SuEKThZNQBl1Rr0jeGMKleGCXAigGN6HY7HBGGf1i1PHl300HZJNd7IVoMbqYL+jFoptcHVOy4C+nahwrLivUvrnsn7xMKCIs6DQRqHSkSyvAckjDnd1dlmpy2h0E+4hlgLWTmAY+yfg1EEG4Fa9Yen9Q3KIak8knHv4IB0RGZ149eO3CIeSjQ52lw/B8fzVzBwBmyp6ymwbgkBI2lQIrDCkhyTW3s+StfxL//RhOvDBBcnqYJVLM2fmdrU1Q3yAnkMUrYPrnfR6zPKg+m7fxzpmd5Ginp086sqAGZePXlPj3JrN6nZnYdtr/90e+HTelVzz/sG7Pq4LNKd1gblORu0d91AUiKc6dwgXjiZAJz9TJ2OvMhd/cm
 iCUCam8H
 DMKG+IrvZZW92lMxBz3x8NeeAdeuvIajME6DBuJgiF7t+dFo/OUmsGlQzOW0aj5YkFHGOM9puu7yAWDIVF0e1F7JQJRhyHvWBddY9h5X/WTZbUWVkyOOBBlBj4ZBsEgXJHXJlPkhbcaJ/1m1kcJNz804BACFCoxy6LCf4DpSP8EU6iuSNuzEnYwSLTHZrgpNuhtGHlHsa6CUpdJtaoIKR0HLEH3j3cGm2CinX37k90syzLgvLHOgIiu+gfkOQZQwn2I2n32X4Y5DaMsxYJd+Kok1/qiC/kywcCSPry2XGyyb+1rs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A coredump with a lot of unpopulated mappings sends endless amounts of
zero data to userspace. This is nonsensical. While __dump_skip() can
seek over them when the target is a regular file a socket cannot do
this. COREDUMP_HEADER framed the zeroes but it didn't get rid of them.

Add a COREDUMP_SPARSE feature bit and a COREDUMP_FRAME_ZERO frame type.
A zero frame is a bare header that tells userspace how many zero bytes
where skipped.

So a hole crosses the socket as one header no matter how long it is. The
coredump server can recreate this sparsely. Zero frames only exist
inside a framed stream. So COREDUMP_SPARSE requires COREDUMP_HEADER.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/uapi/linux/coredump.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/coredump.h b/include/uapi/linux/coredump.h
index 5252480d3eec..312bafabb467 100644
--- a/include/uapi/linux/coredump.h
+++ b/include/uapi/linux/coredump.h
@@ -14,6 +14,8 @@
  * @COREDUMP_HEADER: send the coredump as a sequence of frames instead of
  *                   as a plain byte stream, see struct coredump_frame_header;
  *                   requires COREDUMP_KERNEL
+ * @COREDUMP_SPARSE: describe the holes in the coredump as zero frames
+ *                   instead of transferring them; requires COREDUMP_HEADER
  */
 enum {
 	COREDUMP_KERNEL		= (1ULL << 0),
@@ -21,6 +23,7 @@ enum {
 	COREDUMP_REJECT		= (1ULL << 2),
 	COREDUMP_WAIT		= (1ULL << 3),
 	COREDUMP_HEADER		= (1ULL << 4),
+	COREDUMP_SPARSE		= (1ULL << 5),
 };
 
 /**
@@ -109,10 +112,13 @@ enum coredump_mark {
  * enum coredump_frame_type - Type of a coredump frame
  *
  * @COREDUMP_FRAME_DATA: the header is followed by ->len bytes of data
+ * @COREDUMP_FRAME_ZERO: the header stands for ->len zero bytes and is not
+ *                       followed by any data
  * @__COREDUMP_FRAME_MAX: the maximum coredump frame type value
  */
 enum coredump_frame_type {
 	COREDUMP_FRAME_DATA	= 0U,
+	COREDUMP_FRAME_ZERO	= 1U,
 	__COREDUMP_FRAME_MAX	= (1U << 31),
 };
 
@@ -126,8 +132,10 @@ enum coredump_frame_type {
  *
  * If the coredump server raises COREDUMP_HEADER in coredump_ack->mask the
  * kernel doesn't send the coredump as a plain byte stream. It sends a
- * sequence of frames instead. A struct coredump_frame_header is followed by
- * @len bytes of actual coredump data.
+ * sequence of frames instead. A COREDUMP_FRAME_DATA frame is followed by
+ * @len bytes of actual coredump data. A COREDUMP_FRAME_ZERO frame is
+ * followed by nothing and stands for @len zero bytes. A server that didn't
+ * raise COREDUMP_SPARSE never sees a zero frame.
  *
  * The @size member is set to the size of struct coredump_frame_header the
  * kernel knows and lets the header grow later. It comes first so it can be
@@ -139,7 +147,8 @@ enum coredump_frame_type {
  * interpreted. No flags are defined yet. Userspace must refuse a frame
  * carrying a flag it doesn't know.
  *
- * COREDUMP_HEADER must be combined with COREDUMP_KERNEL.
+ * COREDUMP_HEADER must be combined with COREDUMP_KERNEL, and
+ * COREDUMP_SPARSE with COREDUMP_HEADER.
  */
 struct coredump_frame_header {
 	__u32 size;

-- 
2.53.0


