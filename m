Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95105E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCE26B0109; Sun, 15 Feb 2026 18:52:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1306B010A; Sun, 15 Feb 2026 18:52:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3476B010C; Sun, 15 Feb 2026 18:52:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A87796B0109
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:52:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E931E5BC50
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:14 +0000 (UTC)
X-FDA: 84448319508.01.6188911
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 22EC440004
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D0O2olDr;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=do5fe0I7LzVAyUSqQJriKdkzltxf5q8zfkP49GHwGG8=;
	b=Eblg/jat7KT4Czq3Jz8iBU+tiUr9Mr04n+sEDR8bgSoHYzvoQCZOEQ/AUGPmsi1YayoGuS
	+0P2mb5ignjMTvTL91/zun1SPX5BQ4Jr8fqytr/FXwLGAsR5wwN3IOyzy94iZQ+VVZlE9b
	DU0NucwBwD/xtALVVEGT68PUXxijifY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D0O2olDr;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198993; a=rsa-sha256;
	cv=none;
	b=CZta6Nl7PUVsCTudC+1pq0rFUkc+kNHoexo0GPBenCDHY6yu/qrP1NnGmesiCdeSgAyZ2H
	/IKynJaurPbCYy1T0QhkuN3BbdvnoUu0Ak7TmVeifqy6xYT308glLBpUtgH5DOLQ4xxHtw
	r+LUDaM7MoZ40YOFFR4dzR4rD1kU3uM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5334D41741;
	Sun, 15 Feb 2026 23:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B767EC4CEF7;
	Sun, 15 Feb 2026 23:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198992;
	bh=uZ4trczFY+LKih7mhcNOBkSAbmZSPt6rd19ccjIIzfA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=D0O2olDrQqf3mr+n0B/sizmoyVYotgDI8QW2d+giikDSGklyaqt66EKQtPxwQIHK/
	 /+eyggsDhpVYkE72Jwu4mAsgs4zHHlNPa1861MK9HOJ1iwhcjMHCrLJMeMYNvSRw2W
	 OOLrdq3ip4v/UEcJRCLuAyUQacedRcmMzdJtcdXWC87OxZOrpFkg9TVuD7sKdFVGii
	 AcqxnDafvoCAt9hPcxtgYbwpS1W/0ahnc7KKXnl8HywgFP8pJ3/0R7IZnNjR/usFXg
	 8dLovfmM0CXcU6Y7KCfp9NiSNFzMGU6GofcyjKUnz1W8vPas/jJuv4/FTg0Mp9H9mR
	 hzysrmKtP6VHQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:12 +0100
Subject: [PATCH 25/79] block: rust: mq: add Request::end() method for
 custom status codes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-25-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1367; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=uZ4trczFY+LKih7mhcNOBkSAbmZSPt6rd19ccjIIzfA=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgyY61m40HV541SUFIPkQbPNupRrSnrD107/
 ev7FWE4kAWJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYMgAKCRDhuBo+eShj
 d8J6EADFFGcykNftC/0A3bvASuRhPdNg8UE92icnkqqo0iumqG8bAA2yHrZF63Go/+zkqglK3R3
 l/mR8piOTJFTaKLIbzeQ+Mlo1gKcErgI4mXi8hY+3UVPfaywVmNojac9uq3zeLgT74ZvJV2BcIt
 PoryU4zS55f7EaVjqCtpgMpQjiWMNu4RQ+tYSczZmLC3EQlt7GDw+q8bxW0uT7LTDBfkNpFqlB7
 uQt3HWq0k4k9+cGZg7jWMla1dEiZ7tvnexQPWqfogiWAA4YDsiq/EPsbZXjCipB9jjM7qv8Zaev
 1KVsjOtOFpH09C1G6bbEYV/yJNkxKbqbY2yEhjlTt1l+Gc6N934CuuHoTKFY/iAgcMvSfmFT3E5
 K5tK+mPp/R7dcoh7/x7oOmJ12nETq2fQ+iPI9JwiaHuo+gKBrLzAGzLKtQdjOI5tBJK8LEHrMne
 EQ99RA6D8TAzgTufRXWNCZkfwNTs4lYrWHGUe3P3aoKAqNjqu196xvKG0vSJU1DjJtdS5Tq6FeC
 ZhyfWV50Q64PNQwYpqX3ivNHlfq4Bv3te2MrSUeAhjMNhySjA+XLzBiDOPWvd2OoncP9ynftR8X
 RUV+E457grGB/zBi/HAkuzdrb8RCb1OzjWCaaWBE7WkG/VTILheDTq4Ayf+O3aP1uspkMNT3Vc5
 KHc8UW1mp+karKQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Stat-Signature: rmwycdduhox3hms9s5xmyapfypcebb6x
X-Rspam-User: 
X-Rspamd-Queue-Id: 22EC440004
X-HE-Tag: 1771198992-846827
X-HE-Meta: U2FsdGVkX18BZv1Xt8GSKJ8bp2IT4bMdCC+MKrHqC6rQv2Gu30w5MX62rKTj/LPX1BxloQ5mtX0R/8yceLcDOE2ERQjIA2w5ihl4IFX1SeaDeI9mDPQJ46fImWH27sWTx82f0En7fUWyTjN6iKmlUGpAD8iEXysJAs/mOab6/wHeSNBMvgXizpCg7TRdbVTWRW7uuqJSMCdmmO+OUhCle3esCSHicog644fcGb8TKOhHirNV2Uoh5+cUec82wUMxo5wL9hZCcQjXTJ1TpnqjgTYPgCDvLnuqfB/7diMw+nwkuagQAJVwQRzhpCIfr5pEi9OHYCWKyjLzyLIvdCzVcf8p90SnCIU+VPJPrBy07TTmXIKtjhG1vn2Hl3Y88KBmwQm8dCOVxT54U7wD6Fnv31/EbYD82XbtsgFTbf+fYzJEd2tFV8NCECABZor1jmkiYri1/Bzb+aBVoNlYtz3zQ0y7PNhJM6jBWh3NBJ7vS5k0PS6VTTHEhtPMD3dr3Cbrmd0CE2XdH+z+Jng/ODyF3/QOcbve27E47fJpZ73kyJFSz7kamPjb1r3t5rcDOfcwTFcrkYKXPusURPjs6EULLQJ3MMIzqBh9zmG5vl1qomICwqy1sXcy5DkgnwAXd09UBKq+neuSMEsaLCi18HLmQy+ns7qdflgptIy1tIirZ5BgOa8OeSKdfrJeaLrT9EC3eSaxA4f+1A6uA60+U47+DTKhvXIUi+6GKbzKuV+geEEkFtxtkEchRG04LfdqI3Ok5zpiRop/Yv4lUhNEYdWBJCrQce6MGjgVMcPrTVPKBWaz6d+fIoTpIhvbhfTHxwlrnC7ZpE6ZrNQwdYZCZrscnY3CwC1a0VRcDbJj7RMvRMYk4BXr3PrF60kXZ+P+WpTXIZ9nAmkh9j0iVYFannluxxSW4is05wkmoDZwLtbsqyLEH4P6ZJuzTfnjAnfVGzZZ4Hoi0f/DpsSVvILKBuy
 C6OekF15
 Xtl64om2j4jHx3ubj4QzuxSTPgq2EqA+u49ixYKRvsxY/DMMwOhpduFQtYuM20/fHLqRi76YZokilXdqRYoQLCzGmPpyoU6ZxyRKphdimre/Gzq2Z3OjSdniEBGYVOsRLM8ffn6gwQdX3K33ZDd/HvudMFfIdmn1r6WZhNMqbQzKg3lFB6nzBVutAlYBNAYJdvyEujM4FlrDS0daR/c9vCSuIWjzj0xRBpuPU2Pe3YfL4UHQNvGdBfLRadFTYkWeX1kX+6oylC6BZYg/bRdxfxJQ1XiLIGgM+7w3aYcNzG2oMvx/kVP1isxyzmDi/l9Hc6mFd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add end() method to Request that accepts a custom status code parameter,
refactoring end_ok() to use it with BLK_STS_OK.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 8fe7e126c522a..38289b9f966fa 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -297,13 +297,18 @@ pub(crate) unsafe fn start_unchecked(&mut self) {
 
     /// Notify the block layer that the request has been completed without errors.
     pub fn end_ok(self) {
+        self.end(bindings::BLK_STS_OK)
+    }
+
+    /// Notify the block layer that the request has been completed.
+    pub fn end(self, status: u8) {
         let request_ptr = self.0.get().cast();
         core::mem::forget(self);
         // SAFETY: By type invariant, `this.0` was a valid `struct request`. The
         // existence of `self` guarantees that there are no `ARef`s pointing to
         // this request. Therefore it is safe to hand it back to the block
         // layer.
-        unsafe { bindings::blk_mq_end_request(request_ptr, bindings::BLK_STS_OK) };
+        unsafe { bindings::blk_mq_end_request(request_ptr, status) };
     }
 }
 

-- 
2.51.2



