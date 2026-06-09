Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D88CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A7C6B0093; Tue,  9 Jun 2026 15:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701ED6B0095; Tue,  9 Jun 2026 15:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617DF6B0096; Tue,  9 Jun 2026 15:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5309E6B0093
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:10:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24589164F6F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:54 +0000 (UTC)
X-FDA: 84861316428.10.E4E3B02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5A6C5100011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l6D/bcpS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HqbIExdtN+AFhFGHKtY0qW2xobLkHXMaLIXspxSgS8=;
	b=gnPrks+cK/19ezMtKnuTuaiE1G+KVTRLD4lzqmL0VzM6O7CzmtpWSCaWBLfno+jloHo07c
	hrZ0zYEfAEDRgrvtqDCOg88hT2eg4Xox7McPc4OShV/s4F2jNOk8TiMoRBCAFjEuRws/HK
	d6F7qMaxx127knziIZLMgnE78JLGe34=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l6D/bcpS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032252;
	b=pCfdf3xQw0REp35jxckcLK14jyIcyinDRi4VbS4NQrbkV+kEmdYJFOveImvPSahCdELype
	ep/brPavHnnXMRxsc7HzeRJt4nWOmr0rvOdcuqVjmppUwly0/LOmwcHsYqfw+0HV9vTEf7
	t1fZKvoqG+tpBNJz1vmXfh7EHVfU2kU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A42D843C27;
	Tue,  9 Jun 2026 19:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562B01F00898;
	Tue,  9 Jun 2026 19:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032251;
	bh=6HqbIExdtN+AFhFGHKtY0qW2xobLkHXMaLIXspxSgS8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=l6D/bcpSBHJLSkUvVBypuKACqnuIrkZBk+O3bR/NcXh4yg6VprxqYRJdD8mi33lzi
	 uQ2HmLjWQqdo6F5rNTZU+sGh4hTf2xdX8xiX82z9pTwLYFa17wFMl/CfwGTu51KZNu
	 k5EzAHtnLS7/2Na+8Wc30PUDOcGdKvFfIt0YU+ECG8oFIWdIeHzgXhCFy9bfRDBa1A
	 pMN97/jjWoi+KGZv7D1v9lbz/cAaz89L1UgVDxSbNLBo39tLNclsRpF0Vb1OZvqNbE
	 gXo9gX1PS6ug3TwCVOwX5e3ytkJm1EpTQ5EilMEVMW/C6sQSt1kXK+wW/w/WJT+KfZ
	 L4KPp2m0QiRgQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:59 +0200
Subject: [PATCH v2 80/83] block: rust: add `virt_boundary_mask` option to
 `GenDiskBuilder`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-80-82c7404542e2@kernel.org>
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Benno Lossin <lossin@kernel.org>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Boqun Feng <boqun@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Gary Guo <gary@garyguo.net>, 
 Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 rust-for-linux@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1931; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=/gyZSLKa2TzHdBLdP1ZJPQOHQ8gDmiUSAZ/ZBCdP9G0=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGT9TT0R4aUtBtSeuFFz1LbiE1VCD8K7ODM7E
 HRL8FuebEOJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk/QAKCRD6UCkIqsW9
 0AZRD/9o4BTmJllPti16gUC3pq38UjvIoqBZxFPKYSys1RmxO+GlJRTZhPxaMmMvC3xZiw4wO3D
 WoiymkCJM16OQvte0AYdP3F7/GsJBlASsCR26pDFFbbFp8xG1UnwouPXwA/gJjWfQ5IhjA14IC8
 MVjQ8guFgpMDjzcrdOlbrq+x62bDx6Bh3eZImuQnZJ0vRGnFWM5J2H9GTGbSEUJ7cMNxAY7I64A
 hlcjpdPTpTbrEQjf07jqihO+UQ+1TE/45VcWtwdqFzws1IocOuarZVN+UQRjTULDzjh6ZbO8E6G
 QJCxvd7NoofCN7ykAra33D2JQlM9WOK9uRzcM5T3/UJZCGJ/9ddd6QKq7zZqPDWB+uGIbLPpAI8
 vKEaFpCx84GwO4Q6S/z4DIq0AJRwfvCYqzn4YocMN/RSajWK/n4Zsh27llz/xmi8Fwpexy4um1d
 ZfdlHNnc+N9fzzAw7msyM3cM5JcW2hKp7Ld4qtDOxZ3V6EHSGfyIN3wcoYThPZxYOT99SwZF2c7
 cqen7CXW6JUdqbdgpnskGdzXm6b73Jxjozc0Mf+ZGn/un8dkRV7R9dKbyy71NV6rOTrWqusoqxo
 wyU+nt1pe/SKYe1opyuU+H9rGDE4wg7Mo6LH8H0c87jgCScnJ1N+Y8iVSziHlxesRcv52u5Bcqb
 n8L8bBljBkJo53g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A6C5100011
X-Stat-Signature: tn848epoubgm5dycj1mhzfbg4f768kan
X-Rspam-User: 
X-HE-Tag: 1781032252-653124
X-HE-Meta: U2FsdGVkX1+huFPdr8ZX9FelKVaKAGNXZw0rGfa4y0LLVDFLytry/OPna0i75KMbuRTKLG9atsyGVWYB3LnGQV+FFZF/aD/cbzStidVVqs3oLuuHCcNSY0JseXXGcaf4Wdmoc+AhKqBjfjlqCs0IG0ivWZUSaXeZXLjf+xTHHk6Zry/lJYVAhHqs8mPTv7Se6/QXFud2kyZ9bFRwR1ihMR/MRPbhLFPWAvFwMr3jCFGMy+YD8cG2QxAsUMz5rIbB3TZmUwoHO5mq11lp3ZejzvuiJgNdGfDJIULls+kjMQfWCj/z/lUKacX/ES/fomXvNRA8YAqCQAaGFWar0hpY+k9U7ox3z1VUZ830poNnQZNx7LA6UI3sg7+tDkhAzwPMeChxJvWWxrZTSChd9sGY1Vp5FK12sBeJqxx9ncwQCZnpE+NQRedsU5iXyxM+o+a1y9zhtp6U86dNHi/jaTVWbdYa2AcUvkpwNljj+wqkQKP6DMYpzABVA7caQmw/qBWTOh/HeyLS23vvzSpmXWZItv4S35NkqM6MXimcHh1GwlrrT7/skigO2ryAcTJN4OojJsS6UQuqbgimc8BoodbATaztBjWBGdGonwR1iRO79qjEEnhw1xzRymzZoTzAhh+tc9SRc1hUSlZYLs4UZLf5wxLTG0ummutTrYeyXVT6rvVJLTRazjglE5z6OOcK18GrWX/yXOShx5AM7YOds4wBjupJ8MYAX66uXxB72STk0rPZAN+vC4aDt5QUvGazQghEYv7X5XTVV6qJ/bpI0h4aqpGZIHyCjX0oQhZjKh1H/o635JjMHGLGuPdi1UP953u5lwvF67dXZmqn9F8iBiQjLCJqCmXzpJHSIRQ7RRPQxlIpo0KpFdjIBi8yAM6wmyQ8Zi2stO/ZkSLXmtHTuNa3/H+QDIb7j7xtGtkplE0pH22RA5hZWW54SG9uEYgWKXwaSgleFlN6b3qEkZ3dn1R
 hHCO+eIt
 qMWk8EP/9/vLN89oHyg33OnU2BVbZpjqt5ObzsysxdnWJJ7FTixudf9LCG1svw6K2ILmmQUEozSoGJNBj2yqbuK1Ej9sBY1B/lJv85BkdBa97TI9oN85gFzWVGrsLPV6+tE/Twd+fZHpmOVRuwK1cNwu09lcdShVrADmS4S1q4kCSOaaiP7JvKjZNqAFmvCPJEBEdwGzOqtFufSp/dDjatzK13RvqPtMfzzgzFX5yK0Qz7Gl7QCwxodtzYyJ6toist3wI56vtnELoI/3hi8F4A25oleuyvbJn227C2EMu471OTg0TjznZD6rDhX3DA/L4XVE9GUaghO3GC0hFQ3rYM3f3VPuxxrjWmhMiGSZ/66BP1EKv8qrWEbTSDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow Rust device drivers to set the `virt_boundary_mask` property for
block devices.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/gen_disk.rs | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index 6d760dafade5..38057ebc0878 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -59,6 +59,7 @@ pub struct GenDiskBuilder<T> {
     write_cache: bool,
     forced_unit_access: bool,
     max_sectors: u32,
+    virt_boundary_mask: usize,
     _p: PhantomData<T>,
 }
 
@@ -79,6 +80,7 @@ fn default() -> Self {
             write_cache: false,
             forced_unit_access: false,
             max_sectors: 0,
+            virt_boundary_mask: 0,
             _p: PhantomData,
         }
     }
@@ -189,6 +191,15 @@ pub fn max_sectors(mut self, sectors: u32) -> Self {
         self
     }
 
+    /// Set the I/O segment memory alignment mask for the block device. I/O requests to this device
+    /// will be split between segments wherever either the memory address of the end of the previous
+    /// segment or the memory address of the beginning of the current segment is not aligned to
+    /// virt_boundary_mask + 1 bytes.
+    pub fn virt_boundary_mask(mut self, mask: usize) -> Self {
+        self.virt_boundary_mask = mask;
+        self
+    }
+
     /// Build a new `GenDisk` and add it to the VFS.
     pub fn build(
         self,
@@ -208,6 +219,7 @@ pub fn build(
         lim.physical_block_size = self.physical_block_size;
         lim.max_hw_discard_sectors = self.max_hw_discard_sectors;
         lim.max_sectors = self.max_sectors;
+        lim.virt_boundary_mask = self.virt_boundary_mask;
         if self.rotational {
             lim.features = Feature::Rotational.into();
         }

-- 
2.51.2



