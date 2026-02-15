Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AAAFE63F2A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54DC86B00C9; Sun, 15 Feb 2026 18:44:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505086B00CA; Sun, 15 Feb 2026 18:44:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424066B00CB; Sun, 15 Feb 2026 18:44:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with SMTP id 16CDF6B00C9
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:44:36 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1492C13C063
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:39 +0000 (UTC)
X-FDA: 84448320558.17.9BA659A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6C077140004
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="no3QM/pF";
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZI9oGX5XrgPDUI7Ezjl0Gjpi+sb7iKzFidpTgzU0gQ=;
	b=i7A0oLVrgrHWyV9MEVZSA/1QyEcjCqsCVcobPa8/tyF/W/DTpG8lZhgpwViZ0FxSVcELHR
	cxMjYFpTpaVtE5GqDkslcSN6Zn7v5t8YSGBmZHpOJAtnw6H1q2uFh5gwjb+7iidkTBjVYx
	+sbzJiP5gNKoUKW6Hfa55jzwWEmfq0s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199017; a=rsa-sha256;
	cv=none;
	b=jts1eP/gQMll/fIOTk/AqFbkejIRfu11frKRF6boLUQgjOhqQqO7yC3lii/oK7fEm91in5
	5K8SxstaTXheylwJzRx3zB9ciRy6FC4jQy0AWdoPkWR1YKd3kyaFH4gi3pU7pHzT6vh8oE
	JJvzPDf4n3L2dP6MNIDQTvymFO68/58=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="no3QM/pF";
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF7816013E;
	Sun, 15 Feb 2026 23:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424BCC4CEF7;
	Sun, 15 Feb 2026 23:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199016;
	bh=c72UaM9t8Nsnn6kAPdjGxkpAM0WUzhWF4XrAzC0RQao=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=no3QM/pFs9zo1QK0k4glZQiApqW0oX1HM3K3pehWTOoTK5+CankPp2HTPq8P+QJZ+
	 I17e+CXbn9dYJlnxN8fCWL1TnXQZZXQwouZxjV3r2Wn+cQzWWKabGQ5p7t986WqRD2
	 NDMgiLh3v+c5dRmsYevQgsCk1VJC2rp7r10RHZB6sQBgTjLRKa9UEPr6ThOJGONVdc
	 dFkJuVEwknzqzZBZFc172OIF1y9A/5EGt4KdPDoabnZ5OCeKoZ+8RoWxaxGXRZ1qNo
	 oUTK9FQ7aoNJSveQ7CDjduiwvsbk+HJmyRmdxAquPdJ+4LmgOuN6UFpSppPaQ2205n
	 P9k3NHHKl6caA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:36:03 +0100
Subject: [PATCH 76/79] block: rust: add `virt_boundary_mask` option to
 `GenDiskBuilder`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-76-de9a7af4b469@kernel.org>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1933; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=c72UaM9t8Nsnn6kAPdjGxkpAM0WUzhWF4XrAzC0RQao=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhgs4wMS8YB3muuW0aSQ3HICO4ZNqX1ZK51R
 3nW17TLDTyJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYYAAKCRDhuBo+eShj
 d8CpEACJwP4yRNF/vxN+0m7tnWXUQpbGdqaRTYay3DIJwmRNjTfNA7gS8JGyX2CboYyVhnlfOXd
 FjSGLFlqVkN3pQXpOwbJaiA8fEqbo0/a60mZW9b7TMJal9zLIjyn+kWTUl+Y5vEsNQt73qrqPGO
 5vsfhqkiGrG3tKZy10A6l2LP+VEr2pIla3wU5Ze14AgIsFUfxCAYrFXYUMwsdmv6LEKL7zKPyU0
 iM6d6XhpXXDMeJpDfX+F58ijvk4e9eNqVZBikMKGvkTDMZAi8moJYOSWmxqETcS/8mm/xW+kgla
 oksaa54icWULPIQPxed8y8yJdx8GWYsSLAGKDuFjZaw29DGI0ZmbVLf0/NaKc2SZE9DTtaqe9H4
 tkO/gfW6QBYKo6H5LK3sxEDslJuwmm4rqiJGW5RJUdsjTBkVUPYbyR19vZbBcLCJzsao9Jng8LX
 TrnnOlh5wBVGRUEmbuQVjz26NFMO3uVUfrmB5+a3dT39tFxhQbi1hs/R0DeouVUFDv4N5iYKpJc
 CEAJyu7bNfnrGL4p2EoIjEkCw3HWLXrAA3Cs4TYuVo9N6ES3vxwhbAy+zrdjpp40k5E9Gc80PEh
 Rq5nV4quXuG0aeW14mY2CfORzn5CxSB4H7jMdFo930kvb5zH7nsKze2ly7FQbQTHmbiQO/lYFmy
 hb9ZpII2eAkHWYQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 6C077140004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ry3dhne33paij9k93dnzpb6ibz8a7bfc
X-HE-Tag: 1771199017-706183
X-HE-Meta: U2FsdGVkX197vTP0GdtMioo1ZBjzNgxYnFoeoRgtpeHruigL+gtJgHBp5udw0C8DRb+UIaxhoYKIWpvZ9OIL2T4KGBc4WDn/fd5LKZ+xkyIn4mnyOnSnWbDzebv3Q+qF2waEV/xwFIHwPXlUlFyjW+Rz961y9TliI5xIeXc6Dh9/IKDc+vN3YnUfbtIETYbIBj+7ZGOyqcV3EgXxbqGSuGuozymthdJJuFPAPLnk41NpKKjXTS6KYW6Nm64Kp1Hmbl0IsIYmcgB9EzQl08y6dSqwoDcVmE3/MJ74LJr/Sq/igpNFWOYD6S8w+8nsdrT9sOpCxrPMNW6DAiX24v19ntVJOdTnijorbIZG8s5vMi1nKk8bGTGIiGzNq0mymWOubiCOtILUKUFj/JOZ+hNu8P7362GkQMwbj0+gbS7JKEEGff+w/zypzImPZrLU1ooXQ7868riA60RGpNw+8iAy9YPLQfC9Q5UJdNqcK0zLyH3VeL5vCtymdw3nJEz4aXFeIDPh2bqjV12gYTUDm1U9a4tA7/lu4K2yo6cm8w5adqmPBm/rVnnch+TmBqMuK6IWcMG4raESeFnT3KcF4eI8UXUqxA7xlt7SN9gAxyTouGIiHaDBdxEImof6uwYdHA5ojHHjffz3K3kKRXpZlaYUMiUfngaRGSe4+39Fcf4+AFlA3mhUz7QbA4HtRD58KJrTnzGY5ynY/T7r9GmANYDcFVNRN4vXf6s07PojcEoM7cHWWkqmCQ5qdSANPuAGSMxYp1GaFj3fA0WfYgp2g+HvW9RoZp6qIzqGONzMkQffsDUj+3oSUcSehkWn2EQYBBSPQ8yodGIYIRECSoRl1iwY4EhzieA0FmXwFt7/kfuHySBKdLxI6globyVP2qdP+pMuhOuo6ERX7DeNHNJ9U39RsBiBnpxtsmipjauTO7R5nOSNOLB95sE/8vyAYrIGzWZgUy7fd2DqikASCG8bV/E
 JJOqDuZr
 9LserK9F+XNe8oDcJbphHp++JFCYfkNHKKJepqJxwmpUGHWust82bt2Py3Wu0oOTZtFy6YFflb0nLvIax+3o8UHoCVcZxD3ZTL8kzk/vy4IxhL3LAzH0hilv/PMrE0NjNtesVYwprbJox1SfpyhHpU7LF5ZtWvshuq7yBiC1vYrtoCkn7htzbL94J+EbFoGuLpRfAUqZcSZcAsjMcbVZVMRrHV4V/M0oTKGVNuzH+9tDBTQfBxzJq1BGOCTAwR+X65BpNuUgnYISTKYzo+9TlcQVJcqPzab/gfEwHF3wO3ymHBejos9bF4Jx/iuExmB+KarUtZjpVGxOx38YAOew+SHTed1jPhCyeip9Xf1KDodBYl1g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index b428e3f4207f4..bf4775dbd6d25 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -37,6 +37,7 @@ pub struct GenDiskBuilder<T> {
     write_cache: bool,
     forced_unit_access: bool,
     max_sectors: u32,
+    virt_boundary_mask: usize,
     _p: PhantomData<T>,
 }
 
@@ -57,6 +58,7 @@ fn default() -> Self {
             write_cache: false,
             forced_unit_access: false,
             max_sectors: 0,
+            virt_boundary_mask: 0,
             _p: PhantomData,
         }
     }
@@ -167,6 +169,15 @@ pub fn max_sectors(mut self, sectors: u32) -> Self {
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
@@ -187,6 +198,7 @@ pub fn build(
         lim.physical_block_size = self.physical_block_size;
         lim.max_hw_discard_sectors = self.max_hw_discard_sectors;
         lim.max_sectors = self.max_sectors;
+        lim.virt_boundary_mask = self.virt_boundary_mask;
         if self.rotational {
             lim.features = Feature::Rotational.into();
         }

-- 
2.51.2



