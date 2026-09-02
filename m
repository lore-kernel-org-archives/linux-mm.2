Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B532FC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F7C6B00C7; Wed,  2 Sep 2026 09:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66756B00CB; Wed,  2 Sep 2026 09:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0E86B00CC; Wed,  2 Sep 2026 09:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 735496B00C7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:27:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F085812020B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:54 +0000 (UTC)
X-FDA: 85168900068.02.F2DD910
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 40E331C0006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k+7PMWtr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmjpEvPISZ+t3PGfRKTnDAOa6lOnl7cuFJjli1+tyLs=;
	b=TOy6Y2XAUCwmy/i1HHXEP5uBjOVBIFqjsiXD0TwPJ1pDNN27Xzwtz9x4wNPMxjV211+M8b
	3jz0ZK+BhN2X7XDjM/EIbGbuPsgIGYtH0YJaP4vFPKAFIj34fgA0YQwNGxCmM68ILCKCgE
	Nkffz/HHBNh7nWmWgZcNzDcYE/OZd6w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k+7PMWtr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355673;
	b=K4P6nRDITfulY/K5WwMK+DH1Y+YjAIjTmQbnJHFRHsgiMlJ1tky0jgff0ga644VMAYkLUU
	bJEuo3V5YpSfupPJgdOBsSBsfZZSgJei3GB9xvQC4Qg0yNqQw69s7SX8ZaGuAlKmDbQtTK
	gt18QZo2hGh/wMApavxoNUj7WH5WN1M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D1C6E602C4;
	Wed,  2 Sep 2026 13:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED25D1F00A3F;
	Wed,  2 Sep 2026 13:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355672;
	bh=rmjpEvPISZ+t3PGfRKTnDAOa6lOnl7cuFJjli1+tyLs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k+7PMWtrOSFTyQ9F5g7M7pAPrvsEadjDIxkAlifrK3tS7HWsm2efcg1GN0UE8dXi/
	 J8nmGfqbi4ZBMR/I5JaAo/uWxbElKXGEmWPWvW2MDhPgO8jexUfhVlFda5mKtUwWhs
	 btH5gqf8Z+qJ3mDS225R6aLd0Cs5RugRuIiASI+AdyQR3ySMWW42UQe1M48jeAzS/o
	 fB6q2i/ah5Rfh9e6YzYh7jtevdOucodmF+3AKJ6Vc20FQWpSWmPwQyvYQ3PlpcrWTw
	 1iJD6F9WyYK1tvLap+od60/zIkt7WXHWYjJX1XJLoi4Ne9f6YvDoO0SsQ8tz6DQXtc
	 CCydLNfXcKkLA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 02 Sep 2026 15:26:06 +0200
Subject: [PATCH v5 10/12] xarray, radix-tree: enable sheaf support for
 kmem_cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-xarray-entry-send-v5-10-d18adae40708@kernel.org>
References: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
In-Reply-To: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1261; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=IJL8sHLJzETBX5EUCq0+XoQYAigxpIcbmnUp4kDolk0=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqmCQiFeVnhwTDdQFJRjCYOO1PxQcejmTfYtGJX
 zaKc7loM6SJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCapgkIgAKCRD6UCkIqsW9
 0AS4D/4mR4N32k1U3pAh2rJfK5jfyROypSsF3fJL4XksWWspR996nY603YS/pWVLIEy1IvXUWiG
 zqBNIfTISK+5Gx4Zb1jq+4DqRo0sq1xW2/UYQyFZYdUXfAZ5LZQTcZa9CTnZmDTqKXZLb6nZ0MI
 cXa5QRrjyQluHCkg5ZWkVZ52B5rdcJZdknWPvvFNd73JOGc7bUNfxHvUC1W8x2nx86MTv0rePvL
 bbMOofBww0Ps/BY5MW+snKMunRkCvVyn3nr3+yYzLBkC9mCj76NoXooxUafImT2SMhTS+j/KkV8
 gr5BizGqw4DTv9N/O8hzxe0raN/NkIdnAmUtXONK/DmjRBDL1dkl1xlHeFix6R6MWJjFcSK9SdC
 i6AV4GeoM7//WiIye3g5JDS22RbYfF3go+/RiKCgEgSTLZA6NkI6b/159rmlcPGZMmk6VEzcADO
 KmeclUmPOi6HKrWMP+NOymfrt04o0ji7XvH1qJ4ma3lITbaBkU8m7EafGDO0omxGmFCCr5eIzzi
 RrkCMszJ71vAm8fOhGeCYJnKFMtnWkjJJNyLwj/qmTOC6ZD5lDmcTd9b4yNcVuUjQLRMSJUZ6P3
 QsXVwKBoA8ADBipBkSodYaBfCwnJRH9UGwYkK0x4jHKlUIYl6ScJzFxNrSttLGjX4q9XzoCB1jH
 m32JydtEphMt1uA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 40E331C0006
X-Stat-Signature: bdu1go6ek49d4c7g64z9ot91rukxkg8s
X-Rspam-User: 
X-HE-Tag: 1788355673-255779
X-HE-Meta: U2FsdGVkX196zymzTT/r/FzfxXq9DobxGQUlYzIMD28LK2ep7MAqR2cWeRFIWNIjtOHPN0xt3qNxiVE8ufO26obvMFKr92n65oYdF7YyHPPl01LCiDDjxoOInqZ4oqkEWWxE8GjjMvyZsMLJwTdq7WRbHBUlkeW8xDDTesSzLOTEvPgwJTTDrNketPAWTJhrxnQ7sqzFw7VKp7VYcbNlxv3bej2/jj3ETTxrz/JOxiD3eISephHO/8lVxyBNbq06vYCaz0o+sJfRQMbQ5v3P1px9mdMsxK9OkrzrmqXugi04YTC5ooOaXfQAy0J02ZWatRw7faG9cPeJqsgpG4Nj1rLuhUsmSudTcZARVCIJEGOtD/RRXbtvTCPhR+W1j9SC+oc7ZQNTl9A8ETzkt7GvjQdORj7R8lzpTpiDXYHK0oRctW3a+ornwhuAlLjO5LoJj1147Q6x+uclSW+e+cQuDGEg2+6arBgEmJ0Tj6rDLIXJXU59OzdjOhf9ppxrFkDzBD9HP835LgiDMFQI4K/FicNmDRrQmgYwRi90HPDv5UWoho5tg5sTePINxcZIXjElfqiShFeS1ETRZdEwz6VPfhiHX9AOyGmSN3OzHoKroZC09Xz7Nys0v1O8xSEMGG4Cy6LaP+gjfvA+FFNU0Ic+eXKMx5etH+P3mnuMK9lJyWdJufNVLLIFAaFAkAYDSLoVsDapXCAdlKf4hr9SfSJGehMDCg3hFGG4NUmcunr8pW2DUzy31xnlJw1RvW9yi20D2CVxRTpajq21wy5RXIQ+UShRRHIniWWNQ7tRpv9dVkGrEQxmxfhuZVRKZfHK9RNCQjmLkbNN3j1jUtul2QoP3XhkeAOhNQoLYagUaTcWJB2UduxnUkXEZDa0GCPJxQ/mIvc11dRT7q5eFW4X/9JmPQDiJSwnM0Mdu1DOKwi/bvpGwxGVi918thlb3p+7ILJ9agEf7XpqMdWuOkF8z6A
 kzHAkLBh
 HR/moKNml39LxzCQNQxFhcD5eyaCUUT5LWcVKgUbtZDIJUkQNd35tfqxLgbLbWGlnLb39gO86QRgoxTDCOdQWHS6z1jymCe9mK8ME63OXe4HrYLyY9FCpf7i6Wj6SQ07ojrSYF9ogbk9kC977qXJKNAeid5/w7Q59lgO7vi1HUnYcW01hVMIqz+F99flpZFVqxaDdUbXyDSIUohvYEwSgn6Uqu1BtZvSfAANmqxlNZ0pWeJrWrzYO0YbZvNGOI3MNl5BhrsupxcLw5nv/Mx+ZWA1otjy4YL2i9v09Vi5jRSv5irTkWn92UYW7SAfcwNou4ZrWXexVkzb1WqkvA+5SdXNOYxeXXalb4Oje
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The rust null block driver plans to rely on preloading xarray nodes from
the radix_tree_node_cachep kmem_cache.

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 lib/radix-tree.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 976b9bd02a1b5..1cf0012b15ade 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1598,10 +1598,16 @@ void __init radix_tree_init(void)
 	BUILD_BUG_ON(RADIX_TREE_MAX_TAGS + __GFP_BITS_SHIFT > 32);
 	BUILD_BUG_ON(ROOT_IS_IDR & ~GFP_ZONEMASK);
 	BUILD_BUG_ON(XA_CHUNK_SIZE > 255);
-	radix_tree_node_cachep = kmem_cache_create("radix_tree_node",
-			sizeof(struct radix_tree_node), 0,
-			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
-			radix_tree_node_ctor);
+
+	struct kmem_cache_args args = {
+		.ctor = radix_tree_node_ctor,
+		.sheaf_capacity = 64,
+	};
+
+	radix_tree_node_cachep = kmem_cache_create(
+		"radix_tree_node", sizeof(struct radix_tree_node), &args,
+		SLAB_PANIC | SLAB_RECLAIM_ACCOUNT);
+
 	ret = cpuhp_setup_state_nocalls(CPUHP_RADIX_DEAD, "lib/radix:dead",
 					NULL, radix_tree_cpu_dead);
 	WARN_ON(ret < 0);

-- 
2.51.2



