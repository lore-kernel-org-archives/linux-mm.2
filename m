Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29CA2E63F2D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071266B00B3; Sun, 15 Feb 2026 18:45:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F036B00CA; Sun, 15 Feb 2026 18:45:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2036B00D2; Sun, 15 Feb 2026 18:45:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED616B00B3
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:45:14 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D27C5140B66
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:13 +0000 (UTC)
X-FDA: 84448324506.22.93FBB88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E99D81A0002
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=soe8zXn6;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdhM42tY23lYgQKtp0DQ2W48VnmMI5VpzcYgQS46sfY=;
	b=GKNzRmwag8eeHwQLFAd8UJupFcx2/9FjXLkjpTEPrhtLX52rD+8srGz16gkTqIaIKjx0wV
	2df1JXT69SQPOd4jgdd1VfC2pj2Ug5PKYfoHa8DZCHrkGlw54nUkzklASOhZBKO7oV0Ms8
	fyKrfy9BlAh44jprniUupE0+bEre7ZA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=soe8zXn6;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199112; a=rsa-sha256;
	cv=none;
	b=2D88uJWLZFzsqkgeKhYjw9jBcSOQbgTNhQ5p495jS8B0AdAb3SDFzueHfrEnlgt8/K9zjA
	29waFPlmbJdppJsyJ9ZFFsvoSBot5WKQMEblylsi92ViTJeUVkA8OexPkTuCBWHOVB4QxZ
	6SSfso+hQ2YqLJDUiDAzKRJGGQH6YVw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3175D4163F;
	Sun, 15 Feb 2026 23:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DB3C4CEF7;
	Sun, 15 Feb 2026 23:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199111;
	bh=FcDAFyIoSJaDhVyJTabIlJqI1bmrr6zZRJxwKKNDg40=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=soe8zXn679EKVPAfQOboI9UKqjiwgKHFnpwMsPiql3Z0Cp4uolzIcGA63n0dWlUni
	 v+qPLX6rDHuSPYzKLN3fyKIJ84tjBld/cc7zxKlQUZnBU1YaAWfU6xW21PSXjNEkWR
	 PKyKHPwVvd3aL/KN+5GzarN2RqK8ZMDL9L/O7E/AJywo2HxXD4veGhulcUU7kSE7HQ
	 Jj2dLopuXrIhd/VpyZSA3vPRx3z817oU/sYeLCUI4MNX1jZtVq5TU1FV1zTOmFPYUX
	 EdF6XVVdzjSZ98ZZZvysqIfKodNx5FnnQ3YSREKCwLDg85oSBi9HbX8aViHSXnszbH
	 IaTsNTXXn5TvA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:05 +0100
Subject: [PATCH 18/79] block: rust: add Request::sectors() method
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-18-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=982; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=FcDAFyIoSJaDhVyJTabIlJqI1bmrr6zZRJxwKKNDg40=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgsVbgdhxlxk0yDLpeTpv4EyLGu60tCgyVLJ
 RCBjzOxsoaJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYLAAKCRDhuBo+eShj
 d1DgD/9LxN6RNRd1ZiyiLppcowV7i8sFKLIcLYPN0DyIf83awn5nqKner8IfCM070jzWJD+F3ET
 /AOVeXvIlsEuWxVewLuBSAOVLqSD79pFy2WwJHGIHxqDhnnI274ky8vEQ5PtuGDsdX+2luQPsB1
 vlVkNT6W7n2PShGMSGwr79Zo/wOpki+BvZWcdSR8lCaZcx0NyRkfTXasZ+e92N+p4yAlKGBzU62
 Od2r7Y5Cb9sEX6gL9LYCfryExzrBI0dthwX/SFDoginP1MTOv6l5kaVZprm8rAdZK8iILchC6kE
 QuJQLLEQr57MHeJ7pya234ViDpfixkQxKx7TQOp3mF7EjuyrD8x0P7aUMZVraD4F9uKI37DgRr8
 pqxz6cwV4s2QFOUj2+Ta1GhAXIJvFG7WbDrLLftihFJmFyqP8EsVODQHnRkEuLtsnMvo1B2qTRO
 PXAlfOVUuLOyq2gWoUZIzIYmHy7x0hXnK3h7UFiWI+BqkOHk5LHzh9EHf/UVKGdOeA5k3pvkoNr
 cPHV/K2fn9jhs7Co1fIZ5S3N/Z8/4UDU2gHnSR+Z8aWs6UbdQEwbpgja+WzVrNfWNRqKhc5XRD/
 wsHSZPMm4RR0SQdt/bjiCyqE7epA/R2/icuO7IxzjriDu/XqtzVVojq9x/qe+m3sv3nTHrnmQga
 BCRJn7OhpUjcHTQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam12
X-Stat-Signature: rai11779amcfsnmsxouentza1cp5zwq6
X-Rspamd-Queue-Id: E99D81A0002
X-Rspam-User: 
X-HE-Tag: 1771199111-304922
X-HE-Meta: U2FsdGVkX1+dL78K3V2YGBjvvgrqgw3Q7b8ZnPQdBuGqHubLAzvt9Zf8pFy25ac9Ji1oLUIpOIPDaDVcoz8ESfz5MiNL2C+bS3ps4D8mcBz/eDM9W91e47WxOmBpy2WI6A/hRZNLGPLcMHIBpCl6JzxwgZW/y1a/YxCOScSwX755tygSeb/MpDUy89t63ltlGVRSAYjfEXAceVP8tQX/GyDreHFMeZo105AtHSiQeHTEn3xh8vu4aur8832u9GgtdJFtztD+++ov8MLojPmkGVC+e3skHCorEsjpHrb9RrATjiSwWE+qVnqwOK1IHcoBHJC0alG2eUeAVqoZQwg6ExNs9Cck46br7YIL7wXsvHHfNgjld/Dsv8f4YTh7Bc0Z309LY0T2qdSzRgMuO/iZEKUlEJApCD6bwqpcjY1RZteVCixhei1zYghDFLZIxZAxJLyzsRPqQIsYo2qNlK10U2xC1cblNk9qO9fvI9MTOv9pG0S3CnhaIyjOCglgwEf/fGsw5IXVEtXqy/kQwRUQRf3YPSMs4m3vsuafNiZluFLi7nuDxbNIxm3t/qc0g+OydW+i1kvF24ZDREeWElTuXngvf/lF76o6Tm2H1kYQJDn8FMkbZo2eJvxMcb3TZuPSFdkg1mlPLQ+SLxq3fNGMYPuJr07Owg6atatBDlo8VkyiPkNDOXxRfqgd6rOFuNN640nlgS5Mi7aMoRxl5UCm3BvjYVnB9O5PNCxcs0VZqM7MdnGt3kSo7l6MrnTAa6dt1Hlq20vU7279SoVUk1L4sdUu+76g7DMXD7POqI48MP2gEQqXgEP0t7rCP9rB+qAJGpHymRY7ZBfqetkpgFtkibPHwUIpgsrYP+zdMuLZvsAUyujOQyEhXlkoaRPc2B7TB0ky7qzoBj91HGa04LkkrhIFfxlJksd/aiI9iYeifWE/x/VxaeiBLyDvG6j09fjem0KsnLNb9YXV1a8zMPi
 +0CLngMJ
 lv+6iG0CyRKxIKVT6pK9jyJ1+M+23q8oGOSsKCc7Jyo+tvz3HBgiQg6VwHKV4ueoQGzr1BFogm/++km0xx2thh3XIeVd0aWiV5x/MjsMg5z2jWyW8EfFflOotRd93Qsi7y9MQ7uMjQjXZd6RLQaaHXayGo+ryEZJtKl6uiRED22cxr54aZ8/mZXOE5Ulnv5K9YZRCD7YGpJcEO2IRzaKKVGk0q2Ycce10RkNcvJDy1JucN7GgGEz09cFChKf/9Iytq+20NbcW1JNPn6w9Az8ly42iMzy/iCK1hn3Vdchexg7onMwuuQ7DbiNHPU8fj619Qx1H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new method to get the size of a request in number of sectors.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 0dd329ae93dfc..9d11ae5651983 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -144,6 +144,13 @@ pub fn sector(&self) -> usize {
         unsafe { (*self.0.get()).__sector as usize }
     }
 
+    /// Get the size of the request in number of sectors.
+    #[inline(always)]
+    pub fn sectors(&self) -> usize {
+        // SAFETY: By type invariant of `Self`, `self.0` is valid and live.
+        (unsafe { (*self.0.get()).__data_len as usize }) >> crate::block::SECTOR_SHIFT
+    }
+
     /// Return a pointer to the [`RequestDataWrapper`] stored in the private area
     /// of the request structure.
     ///

-- 
2.51.2



