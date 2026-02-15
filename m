Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A2BE63F2D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68896B0116; Sun, 15 Feb 2026 18:56:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C377E6B0118; Sun, 15 Feb 2026 18:56:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3E4F6B0119; Sun, 15 Feb 2026 18:56:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB98C6B0116
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:56:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 418741A0B90
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:08 +0000 (UTC)
X-FDA: 84448326816.11.221CECB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8BA16100003
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QNs6Vzaa;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvwGuG76ZM6JegChH/hUyarbbyyQrlozQx32l7RJsPs=;
	b=IXUTUQGa2y1nafMnlYZ6cSE4m5VvRnrRcNw+xODkVrUlx7Db++/nVO55EbAI6xz1Y/u4sc
	H8v2Um8cTXtahIxxcetXe+gc5yNKilXv8hFOY8V9Xd9dnruGzTv9mc2HOtExMp5OLYefmX
	BGz42UqtdKsSxQqggJmIM+f9w3I9gu0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QNs6Vzaa;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199166; a=rsa-sha256;
	cv=none;
	b=wVKiPHYcXCnlA3smGlzRw1dd4g7Cig4hUrKqzL+Ez3CWoeBIx98CiCfgTE8PGC4alSkXVF
	hY7wXHRLr0MH3zcvmgkER793mVkY4Z7XeLFdXtPMnVttV7GwQsQTRjoVwoKBjW8T/zDTvA
	3zOrf2dUGJ/b0ZHxlysXwxojWaGtwsY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E7336013F;
	Sun, 15 Feb 2026 23:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E2AC4CEF7;
	Sun, 15 Feb 2026 23:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199165;
	bh=d7t58iATi7q3gu1CIeU43zy0p2OHAVGfrGhGT4Ou8wc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QNs6VzaaFLyKJhPXIQdsggC53pnifRgZLsxpkhFb6o286GjvGptAscqI/NtLH4UYr
	 GHHIL0PB8AEJlm67qADR7pm/UBa7E0bZzBoUNgOqp4xbvzqwsuxhz71wZZNsTjkzEv
	 qZjhXahjBCpB/FpSb0UQ6MzlZlxn4sp2JXCs0HfuCB/DzujSn3grK08XZuukB3Aa3M
	 jQH5oO1urrpJ8uljWOOpTS4v1DGLqpvDOqOZJ9DGyFILQpbihqdtGRIJDzNYtuPYOz
	 HDZqZdm8rooc8Rn+WGJA5t8O24GN3LBZTW+ZuCPrTEN8gjmzETH6w4bNwK05GEFX9C
	 qqrAm6/aciFBQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:10 +0100
Subject: [PATCH 23/79] block: rust: change sector type from usize to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-23-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7730; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=d7t58iATi7q3gu1CIeU43zy0p2OHAVGfrGhGT4Ou8wc=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgwpp8ZG5eDYSzUchwIhxResrdcGVcsXmZyl
 g7CFHdwpJmJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYMAAKCRDhuBo+eShj
 dxV/D/kBcn108tJZUmshMYdi+NPSO3TZh9Irp94K2/f4Qe38WzevDLs2Aru5wDcx8XvSPqD3LeM
 uo18tQAhdWdBSigEK4JNxHJD8Bt5v/b8/9YnvxODXyMENZPx+mAY0YrDK8lM9/I7jHNgKqTAqGQ
 nsT2nJLfAYDtLhsZQ5SCxOZqtSF7KNCgYZkeuV5Bfk9kUIWIy8xeNVXyHlNvMjktBXNDpMHmpni
 mJZrAZonvjhSEaxiKJh6EYphfIptIDQUzKk/6scxinpgUaK+fvQPcoajU86eTPNtZU89htVKkIx
 9pQ/YBWCI3tI2r4ESji3ikU8uMgMZzmtGgxBWg85GsMHEi4J5cB8vo1s9bfa5a54Hg/37Ck8jL0
 V0lPA+79zKDGxaPs2ncIF+D5Bfk2uZxS+UqMTwf1QIEwfIzpUOnGGEVrTaq7n+p/XKvO7O6Jg9D
 UMnR2toQqstUM1xH79NAOukAp9569AqZuiFEtDONgJwVBzeA6/NoYp3YMHgIJ/cj+2x9Hg5lupa
 OBYvCYQeaRmbkHvFNJMMiMAWxcB/zL+Wcg4M3MsqW2bTApybWA5+mNHwxt6Z1ZGLAVsYyF/G1iv
 LZE0+bKDZTUws8BP8Ks2D7QhClalfiwAT9M0jDRaQm8+sZ6kBMyWpJ3YVCPS+CTjQi8xRvLaAh8
 +X0suhCT07dImyg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: csadxnd61qp9pm87kc14ykd1f13hamf9
X-Rspamd-Queue-Id: 8BA16100003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771199166-358285
X-HE-Meta: U2FsdGVkX18+RzJwu8hY0jW1yhttK0sk8Vt/9jzyfEPYyVt4Ji6MpJ3K/zPBYSxzF7vlqFPaIyTHQvdsTUo3UT/5bQZxUm5tzmfYW8VTVh8MO2/DY6R5QaOtC00RrenJYv0WUj0NNmII9JFwUV9sMzO0yagAUge0R8GxZny4Yqu/5IfQ80JdGaAIdurFVtVJAmoO1e0grJQpmv0qW9N59GN4pQ8Wz/xERY68Dvoi1kyfLfQIQT5wGMJVY0AsAu2PJCtqIu6AkxjwRwyh58CgV0ch9M4l0swaQL6a4Y910GCqozDsCFtxlaLGQHQqGA+0uIPNzg1yiIQs5OcGx3NFu1UaAXHbiJNYczq2pfQYPRN96yISbjbZ9SOFUbDlV374aSQX89hal1YKAjOMtsJIhhXt6FpwSf+ZWL0r/3oQjh7pBJ3No5KUtJslK21PGcAft3UPihlO4rlDH9tfeZYEWZF4u2eswRcLkYOcJG8rAblUKjIeZJi0h5U5cHGApcEfsmi2jTh/kmfClr+4i3txvOrVvLvSIKBdUunB/UoZhOmbsnHZf/w7N01uihtEvNkp+XlxJokorlRCbvCXRAyln9zc0dgNLjWIy16tspggCXHsGNJ+30V5JHi47dKYeEMsSXaJzIhoCBsCzrmeSbfs8k97rieN+APAUcZvrpcG7yamr/L5D63077AxrJX4fK0nXzz/WonDRkNulckRMR40APT1eSSz/of81q+J1PwfvyMMwD1j9V6hsj7q80XJ0xMCs24kdbjS00CaueNlJ6vx5do0uDl5tihFqEvg1YR4TiadEMYy8jT7LqHJoYbqOG8RE3VnjFlBLT+XEhRcjFsfmoUdRhxGUlopqDa82u0lkDUNHT8rzqYTNndOFxpdLr9rKa/LDsWo6QydiiZk2FvBLf/6/iML+GTWUyBKu6Rb6JSgQ3tuBmRRJTRaafPCS27+k3fILS8Nc8IHYnaOUb6
 PvNKVY9m
 ut2uiAYyX0HrdtFvzgERhtV5HQx47N9b5Glc/H1K3vxIfwt4fv18BucC9lttnwSV2oMzXi4m0PTNn4aPVFU+p8ze/jiUeD877v23SDM5a5cT76bB/OkETCky9OgdYd4RFJFJzfiEDvNcbtmVrrEYr0PeplhBA+Wc0CelJZxvMKL41DG+4qIYz8LfojL8WzPLf9RIRJiEmzutZ8S+xAFUGn5rKvbSRHqzh9tJ45dtZbXL7VPGfsyezrIA3/J69+SQqBNGVSMyd/lLp+mlBYOOzsWOOI2rOe5qn3U6HmkWPPSp3LKSnA+Lc7UWyWI48LPzm/31u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change the `sector()` and `sectors()` methods in `Request` to return
`u64` and `u32` respectively instead of `usize`. This matches the
underlying kernel types.

Update rnull driver to handle the new sector types with appropriate
casting throughout the read, write, and discard operations.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs    | 49 +++++++++++++++++++++--------------------
 rust/kernel/block/mq/request.rs |  8 +++----
 2 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 9a301b06fc5e0..b0008e2f9c398 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -225,7 +225,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
                 irq_mode,
                 completion_time,
                 memory_backed,
-                block_size: block_size as usize,
+                block_size: block_size.into(),
             }),
             GFP_KERNEL,
         )?;
@@ -246,54 +246,55 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
     }
 
     #[inline(always)]
-    fn write(tree: &Tree, mut sector: usize, mut segment: Segment<'_>) -> Result {
+    fn write(tree: &Tree, mut sector: u64, mut segment: Segment<'_>) -> Result {
         while !segment.is_empty() {
             let page = NullBlockPage::new()?;
             let mut tree = tree.lock();
 
             let page_idx = sector >> block::PAGE_SECTORS_SHIFT;
 
-            let page = if let Some(page) = tree.get_mut(page_idx) {
+            let page = if let Some(page) = tree.get_mut(page_idx as usize) {
                 page
             } else {
-                tree.store(page_idx, page, GFP_NOIO)?;
-                tree.get_mut(page_idx).unwrap()
+                tree.store(page_idx as usize, page, GFP_NOIO)?;
+                tree.get_mut(page_idx as usize).unwrap()
             };
 
             page.set_occupied(sector);
-            let page_offset = (sector & block::SECTOR_MASK as usize) << block::SECTOR_SHIFT;
-            sector +=
-                segment.copy_to_page(page.page.get_pin_mut(), page_offset) >> block::SECTOR_SHIFT;
+            let page_offset = (sector & u64::from(block::SECTOR_MASK)) << block::SECTOR_SHIFT;
+            sector += segment.copy_to_page(page.page.get_pin_mut(), page_offset as usize) as u64
+                >> block::SECTOR_SHIFT;
         }
         Ok(())
     }
 
     #[inline(always)]
-    fn read(tree: &Tree, mut sector: usize, mut segment: Segment<'_>) -> Result {
+    fn read(tree: &Tree, mut sector: u64, mut segment: Segment<'_>) -> Result {
         let tree = tree.lock();
 
         while !segment.is_empty() {
             let idx = sector >> block::PAGE_SECTORS_SHIFT;
 
-            if let Some(page) = tree.get(idx) {
-                let page_offset = (sector & block::SECTOR_MASK as usize) << block::SECTOR_SHIFT;
-                sector += segment.copy_from_page(&page.page, page_offset) >> block::SECTOR_SHIFT;
+            if let Some(page) = tree.get(idx as usize) {
+                let page_offset = (sector & u64::from(block::SECTOR_MASK)) << block::SECTOR_SHIFT;
+                sector += segment.copy_from_page(&page.page, page_offset as usize) as u64
+                    >> block::SECTOR_SHIFT;
             } else {
-                sector += segment.zero_page() >> block::SECTOR_SHIFT;
+                sector += segment.zero_page() as u64 >> block::SECTOR_SHIFT;
             }
         }
 
         Ok(())
     }
 
-    fn discard(tree: &Tree, mut sector: usize, sectors: usize, block_size: usize) -> Result {
+    fn discard(tree: &Tree, mut sector: u64, sectors: u64, block_size: u64) -> Result {
         let mut remaining_bytes = sectors << SECTOR_SHIFT;
         let mut tree = tree.lock();
 
         while remaining_bytes > 0 {
             let page_idx = sector >> block::PAGE_SECTORS_SHIFT;
             let mut remove = false;
-            if let Some(page) = tree.get_mut(page_idx) {
+            if let Some(page) = tree.get_mut(page_idx as usize) {
                 page.set_free(sector);
                 if page.is_empty() {
                     remove = true;
@@ -301,7 +302,7 @@ fn discard(tree: &Tree, mut sector: usize, sectors: usize, block_size: usize) ->
             }
 
             if remove {
-                drop(tree.remove(page_idx))
+                drop(tree.remove(page_idx as usize))
             }
 
             let processed = remaining_bytes.min(block_size);
@@ -316,7 +317,7 @@ fn discard(tree: &Tree, mut sector: usize, sectors: usize, block_size: usize) ->
     fn transfer(
         command: bindings::req_op,
         tree: &Tree,
-        sector: usize,
+        sector: u64,
         segment: Segment<'_>,
     ) -> Result {
         match command {
@@ -346,13 +347,13 @@ fn new() -> Result<KBox<Self>> {
         )?)
     }
 
-    fn set_occupied(&mut self, sector: usize) {
-        let idx = sector & SECTOR_MASK as usize;
+    fn set_occupied(&mut self, sector: u64) {
+        let idx = sector & u64::from(SECTOR_MASK);
         self.status |= 1 << idx;
     }
 
-    fn set_free(&mut self, sector: usize) {
-        let idx = sector & SECTOR_MASK as usize;
+    fn set_free(&mut self, sector: u64) {
+        let idx = sector & u64::from(SECTOR_MASK);
         self.status &= !(1 << idx);
     }
 
@@ -371,7 +372,7 @@ struct QueueData {
     irq_mode: IRQMode,
     completion_time: Delta,
     memory_backed: bool,
-    block_size: usize,
+    block_size: u64,
 }
 
 #[pin_data]
@@ -422,14 +423,14 @@ fn queue_rq(
             let mut sector = rq.sector();
 
             if command == bindings::req_op_REQ_OP_DISCARD {
-                Self::discard(tree, sector, rq.sectors(), queue_data.block_size)?;
+                Self::discard(tree, sector, rq.sectors().into(), queue_data.block_size)?;
             } else {
                 for bio in rq.bio_iter_mut() {
                     let segment_iter = bio.segment_iter();
                     for segment in segment_iter {
                         let length = segment.len();
                         Self::transfer(command, tree, sector, segment)?;
-                        sector += length as usize >> block::SECTOR_SHIFT;
+                        sector += u64::from(length) >> block::SECTOR_SHIFT;
                     }
                 }
             }
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 9d11ae5651983..8fe7e126c522a 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -139,16 +139,16 @@ pub fn bio_iter_mut<'a>(self: &'a mut Owned<Self>) -> BioIterator<'a> {
 
     /// Get the target sector for the request.
     #[inline(always)]
-    pub fn sector(&self) -> usize {
+    pub fn sector(&self) -> u64 {
         // SAFETY: By type invariant of `Self`, `self.0` is valid and live.
-        unsafe { (*self.0.get()).__sector as usize }
+        unsafe { (*self.0.get()).__sector }
     }
 
     /// Get the size of the request in number of sectors.
     #[inline(always)]
-    pub fn sectors(&self) -> usize {
+    pub fn sectors(&self) -> u32 {
         // SAFETY: By type invariant of `Self`, `self.0` is valid and live.
-        (unsafe { (*self.0.get()).__data_len as usize }) >> crate::block::SECTOR_SHIFT
+        (unsafe { (*self.0.get()).__data_len }) >> crate::block::SECTOR_SHIFT
     }
 
     /// Return a pointer to the [`RequestDataWrapper`] stored in the private area

-- 
2.51.2



