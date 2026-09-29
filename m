Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D1E6CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397366B00A4; Mon, 28 Sep 2026 22:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322686B00AC; Mon, 28 Sep 2026 22:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E516B00AB; Mon, 28 Sep 2026 22:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E12A36B00A5
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:16:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 711401403B8
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:16:02 +0000 (UTC)
X-FDA: 85265184564.01.4A78867
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7E0FF100003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:16:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nAeARBmw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790648160;
	b=rZhmTehXSZkm3RuGuEI6rQTHMOxAB2HVWDEAkhUbDSYFl3RMWzc2eLnRWxg1Qoa36JOY8L
	kQCjwsZmjPwvklAWtOqY9IH6THjzzQyg3tyMnXcEcl1oIWGa/4Yqe5X2/40TYhIQTo/i7S
	aVYwT32r05Am7IxWmWu5TeuEbhb8/VY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nAeARBmw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790648160;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ydcpE6RkWOfCMJJ3NwCWE6J6D/QMeF5iVEGBlh1hEA=;
	b=MYhT07TMYD3pT+CzKoam+iQClO1QbYuHANmpJSBOFNe6BloatI8hrmYOricQrXta7vtIVG
	oYTb2HOGjpmQp/4h/ZEIWeXl5y7fXcn1sNIy2srBOyF53SWeRoRIbJgFaktsLSOB6/f7t2
	T7vtc42k+l2QI7vgSusGo/fizlTb/cE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D7C7E43DEC;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4C22C2BCB3;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790648156;
	bh=GGbamOQ+HlpG790iODVm8xKYRwitufeQaNNIdHIRajA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nAeARBmwf6BKNwvkkTYayaq9BwggQKMRFuadBGBocmwL6FwmQuGWcTt/ygj7KXhU3
	 2IYmQJJfZyfSyZ2WSAXox7nGi3yKdFf4Ddm7G0y0XWmsA1+im5fftaHEp6uZDn9D2j
	 8iuoo2jaKQAI227PORBCkKAdxizwMXmjT61/Lol7/+apYKlhXZ1DmkhKu8AenwMQUK
	 lK30tiuOOgDX+K47wm+ZPD8nc77tNU6N3HwgifaTWa9vX1d0AAnAa2nU6LyKkKoVLY
	 mVfJYN0wTXR9XwnI9hGxKtLY7E17RUvF+0xZDlTBcjLP0u+yPiq+P6K+XWdnPDroD1
	 vKpF4yf+A1smQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB00CA5FA5;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 29 Sep 2026 10:15:59 +0800
Subject: [PATCH v3 09/11] rust: device: expose dma_coherent()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-tyr-ioctls-v3-9-26955fb111d5@kylinos.cn>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
In-Reply-To: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 driver-core@lists.linux.dev, Ke Sun <sunke@kylinos.cn>, 
 Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790648153; l=1677;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=XfO2LPkTwSiEqM7hoqHCFQ6seVfT+uG3TPffKXpZyws=;
 b=dlpNSCMDn8r/2tfOALYXZiv/AaY/jqC+xKDE9iLPr5YqZoce/oETuwi7HSo5W03jtXpN3XtbH
 Km/IKZIqgLWBW2YiTLEF/VwGN4M6hFlGcgepPAdJlqvcXNJoV3Hp+Hu
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam06
X-Stat-Signature: hhyex9ckt83f7k4ji7n1ah4tnzsuadem
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E0FF100003
X-HE-Tag: 1790648160-542581
X-HE-Meta: U2FsdGVkX18vnyu37tyLq2+CTQVY2oXAn5bm8Ps7BOOsasg+pskfc/wW6XpBC2wQu5ALVTUCjCQbAT5iCYBlOEmJwYwiLcLzcCUZFDw8P+pHyhrcD3zoN2hGNzxa5J5T4U6mkTbh4YhWMNR3B3eexqyE5uV1AQYJoAI436Xh40ao/ocYEvG547fqem2BuLHj321vCn0cW8J8EUTsZet+wCrilL/yANcZLlwLUeC+V2tknLu8qGxNdygSk5KEEBxU5ynDY/6DtGDoOENnNO2pPeAPP7OjdEALYme8g6MkBmugMhyXpmuMgSDdl0pfP/+anlPjNaaFY4OvJgr7InXUpBSL8GyoGH3ubdtgnSFPI/SNEildnCDePVvWxjWWf94eiPnLboUHtpErKLNbzcqk33heSu9pzAV8Cm/1BmKr3AU4Xtkx/EfjqxXJGmY/9BzZ9wiuuWSqXZ25YwjJJxJ0+qHxRMeLX6wzU2msWOapjqke6RXCSHIV8K7HsNoXVjm66jPq8RvMwMLq7YdbWWYc9dpsuiNL4m8u9Vnf8eGTlec43nVpZeDlEwmTDhOjOAjTgB4kuB3gOVDy+n/px0O6G5/gDSDwVu4mkYKrXIGdmAp9VRzVr+D5IBhS6f1R9xEAt6fVYGRAopcwiBkX3XUmgMiz6bFNdph+0tTX9Ah19ku9b1LjR4yJtVQm5P1b1etpvtlJXQHGAabe6l73Qo5GH9i4jWFtyvhH/vbuMmp/3X9SFF9OnfTZEGPrcYK0fwAZX10o72kUUyQyLPwFS8iVYXulz9Au7sRJJfPlLcdx2+IMDGwCzo4snNsovhy1I5r5N+m933MVs+YApqGmBgAMwlrrEfeEQdBtZPuRWtbji1oNdBq+Ls3v+cp0mkYRQasEW2DfBvws4aB7udw32KxkbR642nKxCyYIiGTVGQ0jptIV1lI2lEFsZLYnobnkqkImIv0yjAGaOaEJy3utvME
 QcCMzNIX
 xo/wESjXgjpA8ZwlZaNE3JfBTYXTosPScbzDK3Z2DNYaTRGEIdWXBrPuV2umsASV9uNSK0LecXzwWR2wvYcVRQ0TGw6C/uCGlyWew3u+6AwjFBoN09Eea+RDIfHXZDOve/7RqKF2/Lpr7QUhh9YZjfQG7Zr9XCT8YUTf7ZhONEZlow8vPSIDOZRwIdE73qP8fSA0ztajMvESvvz/VXPlQAMoIr9p/A1Z381u69UAkaU15I2ffHgeE2aI82KX+GSOwp42kEx5Z5/mebMSO4nETPmchVMCieC5fnJRP1z/QfhyiRXQTLmW50v3yc7kOT33tUYPr115S45AEX6Dll0wQGYXDaAMYcyCAkJNzuwSLG+uYTcdSN2U1w/eVbQ0BdOf7cZBBymHJV4yBnaHi1lvShXGwDTIHzMtxNi4+0uU9Lgl8NvNUGCdl967xvp7g+m/fE/5jxeQnofMffmMbzv+cCEnRfHSuWC9qbQCwHqRkeKDRLDc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sami Tolvanen <samitolvanen@google.com>

A driver may need to know whether its device is DMA-coherent, but
rust/kernel exposes no accessor for the attribute today.

Add a thin accessor on Device<Bound> that wraps device_get_dma_attr()
and returns true only for DEV_DMA_COHERENT. The other attribute values
(unset, non-coherent) are treated as non-coherent.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 rust/kernel/device.rs | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/rust/kernel/device.rs b/rust/kernel/device.rs
index 2291d85b6849e..57950aa71f33e 100644
--- a/rust/kernel/device.rs
+++ b/rust/kernel/device.rs
@@ -260,6 +260,22 @@ pub unsafe fn drvdata_borrow<T>(&self) -> Pin<&T> {
     }
 }
 
+impl Device<Bound> {
+    /// Returns `true` if the device is reported as DMA-coherent by firmware.
+    ///
+    /// This wraps `device_get_dma_attr()` and only returns `true` for the
+    /// `DEV_DMA_COHERENT` attribute. Devices for which no DMA attribute is
+    /// reported (`DEV_DMA_NOT_SUPPORTED`) or which are explicitly flagged as
+    /// non-coherent (`DEV_DMA_NON_COHERENT`) are treated as non-coherent.
+    #[inline]
+    pub fn dma_coherent(&self) -> bool {
+        // SAFETY: By the type invariants, `self.as_raw()` is a valid pointer
+        // to a `struct device`.
+        let attr = unsafe { bindings::device_get_dma_attr(self.as_raw()) };
+        attr == bindings::dev_dma_attr_DEV_DMA_COHERENT
+    }
+}
+
 impl<Ctx: DeviceContext> Device<Ctx> {
     /// Obtain the raw `struct device *`.
     pub(crate) fn as_raw(&self) -> *mut bindings::device {

-- 
2.43.0



