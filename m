Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47604C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED4E6B002C; Fri, 29 Aug 2025 03:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4E76B002D; Fri, 29 Aug 2025 03:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802866B002E; Fri, 29 Aug 2025 03:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 711DB6B002C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:18:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16CE213A311
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:18:23 +0000 (UTC)
X-FDA: 83828941686.19.CA0D176
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4F3A840003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:18:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=apDgEv3l;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=cXOKDVYl
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756451901; a=rsa-sha256;
	cv=none;
	b=eH6Wjxa1+4n9qlWBRBCyxkr6AmHRhAiPhFxz7ygEqvxWhpd60HyiTGCMdSZjTEYleFmlS5
	HuWkF3AXL0WRO7QJZx2L2+rGVLHfR+KHM1Kyd2GvZstpv0qWTu4R89GuVWMRWvlREudLDA
	IzK/qSM1n/GSlWAy96sA9F5WSiMYwfo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=apDgEv3l;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=cXOKDVYl;
	spf=none (imf04.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756451901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JIj8SIbtAgtpy0p9VklqThtQxV6/s8k0YSWKmDTTMMA=;
	b=G9IDaodkY0k+BOtX5l9gXXk2Wq2D7rjQHGs1bn5JRJs/kfcHiPmsoQKgdVZYJvIDP4uO4W
	8qNx39Ls220F7lQe6l5FTV/Bv3f4dAhKjxGTW8yYMMDBAyIPfbMIt1HYYZPTPTWai5nXHf
	1qsUPpcHIZdhgKnpzOstzfCLSXCNbK8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1756451900; x=1757056700;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=JIj8SIbtAgtpy0p9VklqThtQxV6/s8k0YSWKmDTTMMA=;
	b=apDgEv3lhMuPlcRQ1NhVoYp8wX175iTZBNHvVtxmNQOLwePO8EppFq1p+eu/Ig3v8bKtBWAaI8djc
	 v4zB2A6Uzfq2mzyqhosRL+SR/NSqRqiT8CNVD0xnucex8oILQNpB25mI3tuxpf2DDESNCZ5xGdYQ6i
	 kgqzV9pObhLI759vb1SDzLUBGA9VIwjrVR74o4dDg4AFXeZW43UO53KKb2DBuYnn0lX/fia2vXGV/I
	 d42L3mfagyX4OHHpdqdq6dP+OaAQ/gpYZWjBQP/3BcGY2A1EYwydiWTzqHcZKNf8DuMb9+5AJ62Ntu
	 EdZM7OS3FAlxM52jnzMR6pwZ7+JGMJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1756451900; x=1757056700;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=JIj8SIbtAgtpy0p9VklqThtQxV6/s8k0YSWKmDTTMMA=;
	b=cXOKDVYlm/PRDmxYuD+0ykRgCvcBbCb/JB7u4uqebxbesDEr/Cuid7qmtMDVZ5CS5yIZagW19rypJ
	 EoDdWbCCg==
X-HalOne-ID: 5560e6fc-84a8-11f0-8d86-fb5fec76084d
Received: from localhost.localdomain (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay3.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 5560e6fc-84a8-11f0-8d86-fb5fec76084d;
	Fri, 29 Aug 2025 07:18:19 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	linux-mm@kvack.org,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH v5 1/2] rust: alloc: add from_raw method to Flags
Date: Fri, 29 Aug 2025 09:18:14 +0200
Message-Id: <20250829071814.1973188-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250829071709.1973086-1-vitaly.wool@konsulko.se>
References: <20250829071709.1973086-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4F3A840003
X-Stat-Signature: wojjsjh9yjyuyt6i1r9byicpognfhw9y
X-Rspam-User: 
X-HE-Tag: 1756451901-448119
X-HE-Meta: U2FsdGVkX1/0jfVm2jBwcSmRTjBzSxuGhmJ02edyqD7SeQsqrO5OpICgetzrkiF2TKWltfr3HC7Oztu05mCuIOY6eoHEFJjoxi9NcHZJbDyNYwpD3nE973smP0eNupdkXhDPd5ulbLQktfyzVz8240wqVYyw021Y8InZDOr/DLBAXVU/LXnDmSEJmLajPlgwV0zyWJYlhGkKih8D3Uz94pD5zK/lUgpxQ3VB1Dxa4apiO+MGyBdKDTWst+KMP+XIlga8TJCGl88p5wsiklxrYDctw00Gzx0R9c3LP1i6pLhRET9huiku2RWki7Cf4cdFciaId3LgumeQz6wSjjuw33H7VU2Q7gwBFsZl7gOSOwVIb3ayWbvvit9xK0ccnJV8Yt0eKHd6H690j2Wx9+zQnkxcL/Dc5Cm1qZT6ePgvbXMO1tklb5caCaHcZyS30TH3YDahRRB9GPahPqniwC/kb4uHoGBlwe2rA8jhfve61qIf0LG5+dhC6dXBt20FiS52heP1jhMJX3ABk/nr9/PYRzMEvtDHOAvci1c0JAqRL/Go5DbcJj8ZrTxqaNwewhpjNeURabYnu3e1CBO58hTg+ExRYBu3mhLwE+a8XfimqIsiZihEMDBOBns1x/lglsj/NGOHR7tMIBZOrJ4ZpX1CLc0draLzwlpE6pV3IgksWbmPYI1MkWSpVSd/j+qKNr1hfXfD3Z8EpMicx5dSTwr57Lk/gEj94tt99HVsLJm0FLppb4HqnIuT+j4hZJFCTcW3ET9Yez2nvP12n7hcsKdOY/WPv73NSl3A7fZRS0pcRnXd3i9vROhCAdi8FNT6MV97tC1x/o3sNQvOgqSxAfmsuSVV8XFJtgqbtvRBUWgBsscbpZjQ51ZzKwGuktSGWnlnae7burzKxCQ9rMIKfHLanNm4pbs3yh9/UxWgEEsiHGzfDplZvu4ES8WW/62bqKQhK6TvXOHJngvX88aRHnr
 gRiYmKvX
 cJeR8c1gf68KHeWBz6/cr2UYSzk7WqSITIpsgu3CukVm2aYz8CgH80PUBRalzinc5G/9lct8wMq/SC5DBpCP59fPXIDSaxwv0DQSeFILUtn6UAjI7Hr68+Linz7lRM5oPIsUZP8ritIx1GgY2qGdLJcfH/jX0KsOC0Wx5tGyLKmcR94eB1yeZjYOcPJnGhn+slTU6wXWcgd2rGxCvBFUpxxOFu0XNr93uDRw+zIzl1MgRUwxl65rfWjjPFHMMfueiNkgh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We need to be able to create Flags from its raw representation as u32
to properly map zpool C API into Rust. This patch adds from_raw method
to Flags and makes it crate private.

Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
---
 rust/kernel/alloc.rs | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index b39c279236f5..0c839813a15d 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -41,6 +41,13 @@
 pub struct Flags(u32);
 
 impl Flags {
+    /// Create `Flags` from the raw representation.
+    ///
+    /// `f` must be a valid combination of GFP flags.
+    pub(crate) fn from_raw(f: u32) -> Self {
+        Self(f)
+    }
+
     /// Get the raw representation of this flag.
     pub(crate) fn as_raw(self) -> u32 {
         self.0
-- 
2.39.2


