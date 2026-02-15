Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B791E63F1F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 23:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52006B0099; Sun, 15 Feb 2026 18:41:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26256B00A0; Sun, 15 Feb 2026 18:41:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C566C6B00A1; Sun, 15 Feb 2026 18:41:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49A136B0099
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:41:13 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56D858C0C9
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:40:52 +0000 (UTC)
X-FDA: 84448313544.28.8522943
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A7484C0004
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:40:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OOJUz8jH;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFVgpkRy+Tw8lxFCcMb2vttYhFR7XmqqG8IxbTcEF10=;
	b=r8VRMfdZm/sz34aMzH+GYUX2ZCM3It1vVyaHl4Pfizl8q/XoeF/7HIbVdysjixsM9bcBeS
	eHnUpmdifHWli+7Mu7QC/NynBaGquddm7nmDMbGSG03hLzVidQZZJHaqaWyJTCOqtNDsVN
	wqXbVWu4qMhU7T5rNNDAf6nx6H/H67g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OOJUz8jH;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198850; a=rsa-sha256;
	cv=none;
	b=P/yCWSRJ4Ce+suP5oZeGPq/AC7xFanopmktqTpS40t73vXJf/w2JMhTtkA4L2Lral3kOLT
	MyoiDSHAZC3MV2GQNy/CLksr2wDoK5SZ23M5Rl79sLnLAAZjg/vSIlddU/DgbrGE5nR8Z+
	1Hdt2SnLkhoM8DouYfQVDERXYxqZZ2E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D623F401E0;
	Sun, 15 Feb 2026 23:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D25C4CEF7;
	Sun, 15 Feb 2026 23:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198849;
	bh=jDbHu1Zje3UqoEo8ZzyBlnA9FXargy0KlZo0vzXHkD8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OOJUz8jHaC7LP3EtCPD65pnV+OuuUHg0BfVaV60OFiuMPeM7rly6GhALuF7lje2WE
	 iVrI4rr2Vz940v56ePbsz1FEK5OVUdh3FF9wwxV1wTkWj2NAygLoyr4CWMomQIjnMh
	 Rj82CkavoBwm/WoQPLybya11197FGj4lR8QIRRtdma1KUCqceLm0vZ9dil4TWYorw1
	 /yTkq7IdNoMo69hqDeiunR+YRM5gNd1MkqAfztRamRz/4iJcK3jF21ZmfTxqlmNckg
	 H7tpk+5FJbpAKhphMWEOebbbGY5Hs0H6S/bhrHYtVfhHhyCnINeGvDral+4gSo49oY
	 7uVPpXwDvEtaQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:36:01 +0100
Subject: [PATCH 74/79] block: rust: add max_sectors option to
 `GenDiskBuilder`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-74-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1622; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=jDbHu1Zje3UqoEo8ZzyBlnA9FXargy0KlZo0vzXHkD8=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklheeOWsZ5urW4C1UgIxuTPpIyyfBrdvCKsur
 KSUpEKcmhiJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYXgAKCRDhuBo+eShj
 dydFEAC1bjAjzG0WwgcS1zrXw0+2c39sfZ4Y4rB+xPXYebButMnzTSTL4dU+tGbyFFq5x4d0g90
 j3OCa2gMD8rbHleMZ9yo5J1XCRE/GWd5vhplDWCPHVOcLQaCFzwL4tw90z/FgQ5J0nswbXtg0Su
 NgHGvdb2an2pEy+z+tYNqQoP3cYGmGUyFXzXHI6iAERegmXrj959KcIKctyA14K2dAxK5EPi3IU
 FnFqin4bCemG/IK516tUXoZ9Z0N1tV/VzoLHVoc6Es9cEO16U7RzWjrdQPWTZGBo28n0upPGovT
 42SPvlzRwb83Btcumna2P4wGLc6yAV7Mu+eafxLfUeZFadRKK3qD2J+06pjJsixpUeItZPiVETe
 U8it+EgneiTQVhq4WWit6YWSUYhrWZsN6ICUtfKwX0s2PYgjsHfTnBStUd6IteSPR4zi1jw0Z06
 W73zvD84pdQ6PxRJphLZm/5LopyrH7MzlvOrBIR+7uwtG80iX9aqC1SRJWy7kltk2HPD+caXBm2
 J4plRlTJtkk9avoDHBlpm7+7MiUkzz9RZJIXqVveyHqCJrY5tC4SMHSaX2+S9V5wnoh/c3684OB
 pQ1sRV/jGYFJ7K5I3ZWZzMeN9BPWcTmZkhbO3kYcsOB+Og/RxCRqAqmBlbziBl3ytAw0XluMvaK
 NLxY6LENQoYm94w==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A7484C0004
X-Stat-Signature: 8rao5akhdakzxg8fxb6georj6uop1oz7
X-Rspam-User: 
X-HE-Tag: 1771198850-90820
X-HE-Meta: U2FsdGVkX18RzTzW4eiz/ZQyQ4pkazXlE1wIHnkH2VPpRcqHOJ+Se4bbeSJyjqviMK9Hqpsei/0EtBrAoSrOmUYGQZlSVavEmFjUl5ScX1hDzbXOgWn1/t7lzNCd93uu6b7822BzN39FDPYO2P7u4moY65ScxUe7l6QlLz0LOzzbAeNTbGLmajsT1GQ6x2S5Li1j9JNMaWoNQNg2mchQnEE/AMeNBbaCzpBKqW4mxneA6HEs7I2PtllVao6lDIzMs/mfgCv7HDag8O/tlpM1PY9pf1csOceAtyESAx3tehnlz4oEJwyPJy2Oek1CTJK2PPPK0Euzj6GO1EkGj25Hnf2VmdLXocDa570WzjgCQlancv5jBkbCFENi8bVXcnc5XdwszoYio+ZSSXmYZF1dTpm54QJVva+M/iZZMVOWSQvB7uLpklJD1ZKbN7dN1RZah6sgddGAEeMi6/68H+zcDztAczm4I9OLNJObHaA4fctEJTyp5cvIYnnuQWi3031/gwH6cRtMk6YkKReEUbfiRO6xb68N5yaSbWPeJe8it4ceclGToaB4aawq6a/DfO1k5z1XMIQ7VMkKSVXE1Lu+5bYvb0v2jQ3bRm0GA72FkZG/zxzBAl4PlppdSlceW6s4wVRDQh7oU/yY5hFRTHFS6uri2WS5XwIHg0dhXwA0/P2wC0WQTYIBHBqkdfj94YqGTQCvstltc7t6E5EdZY3wk5+G0GcUIa4GROLdOuV6S/Xkaj/kV0ktfkTSraAKWs6bmuiFvgWJbtQRB3twrT46TMAXlf0x8UuP3z5haByL7owo6HtO/oM17C5vhPmRQuJf/o38pxzCGwHqbBMvsIVTXDaN+Pc0AucM+LmK/eYQfmWCjEiw3HsRy35YjoV9uxHfB/dY69YwRvYHMMCq0y8ZH+IEqO/MDzmV0XX9cyEOixZBw9sbf+CoWabZKNuYV6R1UM7g6dP+v2RymGFT5hd
 N6UEiLjc
 FfgE7aRmUVXdhnkTiK6U0zyUdq/MartmqCKCPEjmd1NgUwEo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow drivers to set the maximum I/O size when building a `GenDisk`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/gen_disk.rs | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index b5291bc3e051d..b428e3f4207f4 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -36,6 +36,7 @@ pub struct GenDiskBuilder<T> {
     zone_append_max_sectors: u32,
     write_cache: bool,
     forced_unit_access: bool,
+    max_sectors: u32,
     _p: PhantomData<T>,
 }
 
@@ -55,6 +56,7 @@ fn default() -> Self {
             zone_append_max_sectors: 0,
             write_cache: false,
             forced_unit_access: false,
+            max_sectors: 0,
             _p: PhantomData,
         }
     }
@@ -159,6 +161,12 @@ pub fn write_cache(mut self, enable: bool) -> Self {
         self
     }
 
+    /// Maximum size of a command in 512 byte sectors.
+    pub fn max_sectors(mut self, sectors: u32) -> Self {
+        self.max_sectors = sectors;
+        self
+    }
+
     /// Build a new `GenDisk` and add it to the VFS.
     pub fn build(
         self,
@@ -178,6 +186,7 @@ pub fn build(
         lim.logical_block_size = self.logical_block_size;
         lim.physical_block_size = self.physical_block_size;
         lim.max_hw_discard_sectors = self.max_hw_discard_sectors;
+        lim.max_sectors = self.max_sectors;
         if self.rotational {
             lim.features = Feature::Rotational.into();
         }

-- 
2.51.2



