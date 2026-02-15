Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1345E63F21
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 01:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BFF76B00B4; Sun, 15 Feb 2026 18:44:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075E56B00B5; Sun, 15 Feb 2026 18:44:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2056B00B6; Sun, 15 Feb 2026 18:44:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9A7F6B00B4
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:44:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2AB9A160B0F
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:09 +0000 (UTC)
X-FDA: 84448321818.07.9DDD555
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 76C49C0006
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/cAr2ex";
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/PpZFPvX9pq2JcVnHAu/upUbfRfnV0Ey0xp1nEf14M=;
	b=yxOF7k43qpBWyXr/u6mv1sPVlxNbiv+vAVj0fNNBVO1ThzGYbXMnJNOZzUhsq12i4nwh1e
	V5ujhWIS67IrBBkdgkbLys+0mVechhsu98ZXghet3OVHmTcmJS1860iz2gt7VfWnQHP4+G
	kyrK/TgvK6r/+nOPPGVaneqBUuCi7lk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/cAr2ex";
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199047; a=rsa-sha256;
	cv=none;
	b=CuXRD4JyoeKGfGXxJHUrLa7cM5oaZ6vopSNXoNHcB6rMH3PBwagGIDN60gNQf93DqAvaUk
	Xhgp2ltwRL1Jdlmcx831TyEgQKRzvwyfzT6BahLs+ieGk9vcil0jn/XVM0SmCe4DBz8q0M
	kUumlNmWiS7BgdtNvc60iBUsYnDCAs0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BF6A6013E;
	Sun, 15 Feb 2026 23:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35922C4CEF7;
	Sun, 15 Feb 2026 23:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199046;
	bh=HXXe3ZuaQh0jtawnDxB+W/Q37k4GGbJvn35e1qpXTRo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=X/cAr2exmax8lXA+n5QNdVX/hBbQVn347xBA5DUD43Ygvq790YZfIzSVNXjevosvy
	 5nDZFrviyPAratHgQaIn4vCEBeWKTif9T6X2JcMKahVd2V18L54yXYi75oLxsbBSrP
	 LRGnKMoLmYxBwkVqpgjtEcTNR3LKw6Es2bR7qZAnqxGpzW9s5H9nyAa1UH1xTjJ5NS
	 tb0cBOcjqxT6P8OYpOxQk1Da1x/ZJMh5dvr1W9h6SQvnYIvwOiiUxG7eNB7hS/Fuh1
	 m64m+TGAtJ70wBFw5h8TcbrjNqsai2TZkT0DoYP9dNZEF8RKP+1ilIakmZT3x2gU6r
	 /KX+laZXIZQ3A==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:57 +0100
Subject: [PATCH 70/79] block: rust: add `Request::queue_index`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-70-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1022; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=HXXe3ZuaQh0jtawnDxB+W/Q37k4GGbJvn35e1qpXTRo=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhbvCV/K7QHpAKO17p9tlhElvwrVj3iR8aTO
 xSxbX9mMTyJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYWwAKCRDhuBo+eShj
 d8suD/9uK5x4p4mZa2NHYzVIAjBzj2akl2B5TMECJhzE1rCk8/JBpPTetMD4LGk9ASmRi7Ss2yb
 XVwBn/7/CqdmjvQvolnlPIgr6WxOJ3Ao5tMDZUSdOQd2g9qJVtCpNxVrZa0Xxp1jGhODM7/ONdm
 Euyrcd5g5obOyGTHKfmDOq63E4X5xyMawHVsDq4Mg6tCvs/9vyMBLhICEGfGTQNYyu552AbxTGu
 zWjDlXrTvEnUlU23A5VDDjhOZlbIsUq/jJZYdiO9cI98Ha4xxQm0TLZkkE4pZvi0KI0GvQGz0hL
 F86Fwk6MT0uBkuhU9RaqP5mkugJPZuDgf0p54aCQvKEmzlZ3v9hQFW8H+Wv1HsueHaNxEYYU7Vm
 9Msejz9Ho1DIFwmNj3cSSAKVJGgGR4PDPtpTMaJEVcLoFnaISC0YLCpsZfOHLSNm7L9KS6JfNOF
 TRFYI5QqRgZNmN8VNoE2xbBznLYLwkTkLgTDOyYIATbqwrPAgn6dPG3opCw5htI3mDmpKOo/Q+c
 BL5GCwR13fQ0OhJEWc0S40MSWPRsWx11M9x4kGJ4UpYB7jFUIwFd+PjD7mGpiWlCGYZ8Ug/h0vQ
 XLX0H4zdnBIvqDX2nXLCm/R35mAsWe1U858koRujJFRhUVLyceDIfutFKteIUwCR1YLtXqrQ7Qf
 cFU/nem3vF4xiqw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 76C49C0006
X-Stat-Signature: nn93y5a99j8c4o35dm5k3f13apugomya
X-Rspam-User: 
X-HE-Tag: 1771199047-526451
X-HE-Meta: U2FsdGVkX1+7SG2cU1SHXNLv95o97QR+B6BG47VFrOJRKqEEQ9UUWT4ATUoX8EEKxpYhocIlNAkPMG/2281Nl4mV6oumm54JLzo9LSU4ynUGIA+SRIXzclcAFUgTwLlINcI8+uOYuOoejcheExgGFZyZICjI1l5d7rMSVNcZY/yG8gTPDOyEf9LVWLHaqrrA78dttAtQtdBf95BoLxyO/poFDk44IgZEpkDBS8OXJq6COYRZ6PDPCSi9vgXXJ66G4JVGm/3eyDE5Vqza/lgdIJInYo9F+HOrgetjYno7OW5W1o61pb9bLIuHI+eGupBRh/1aOoV/BNMV2Ug8sMh22/AN8kDnfhQsRkLZ1AiX2o9Yp9WayzqqjEjzmXSQM34kocBEkBB7WJEw/W48/PaTpmGWuYPxSGkaX+qNWO08+wK7Xad7jwC0QaT8jE1RN8YvgN0qvwq4TMVXICVHFWkQb8JP8NfHQNzw13G15gDXelOZn/PbWQ1zp3kq72XciD/Z3fUaOmpt7tgmcOfQWv1lw5HwtUSwkcDNp1/nq56if+qw/Ge5Z6a15eGMKe8uB6M2mkvB+UeX2KuMrl0JaO6eBilotn6M2bvBIxzvqpUcKYUY3/nYCDr6IuXy/iRh8efzo430ah0YQUzDIksSauzZaQYJfxhHb647G8UNpenHLSBdVB57/tUB8YwzHUmUJv46WWg3Iis9CYgaTekst5m4tO9ffu4Ouja6C0mM01TQMyrDGxKPdGXUU5aqBoOgGbGYvxc19RP0VxTCROral7ed4LrfeeE8QOl7pfnhBj9ZGXeuG+T+bmdlx9h5S+jJzcSdIgBU0NoN1ccy2gIKazc5e4TSGVXdV3K7+//rIEKSb8ZKZuIzzOS+STl0TbRjk2bDBqVzpiHWsfG0ChMXwOApQhwyHTtkgRfhGU2lMA/jf8pnxEGWsDLNQiyfKectZjm1pyRNimE4jPaqzjmscxx
 abKqSijV
 bCVd/nNcymUch1t71W+lPbZfGUq2HKnS8mWeJezN75rvMxn8Sj/PyLA6g7BXlNxF/rJQdK3ftMsjrXlczoGbx/PwsgsWyrVMQq1pOmL+RCpl5ELnmgWrNzX3JsENmTaro5jd6cGp1jSr7H1UtO1lAB3Rdnk5v4RhWhnZedAn7K+OY/y1P8snvqCKwRtquADk+M+G27fgjuQGspGK2Nf3OzaimBuwPnD3y+WMnU1oobbypYH16APtI0boCg+wrUFZhc0h/KRfmfa0JotlPDMvJuNmn3CRM5lj1WzQlcS+OxSDA1DQ1jcx54vZMRec05M73k3Hcf4hEWeOxZzoqoILI3Caq5PloBCL+XERWxmONg65Uj3hVAnNcjD94eA/3YeZif1gD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to query a request about the index for the hardware queue
associated with the request.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 9a05bce39c64b..e2fafe7737379 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -166,6 +166,13 @@ pub fn hw_data(&self) -> <T::HwData as ForeignOwnable>::Borrowed<'_> {
         unsafe { T::HwData::borrow((*hctx).driver_data) }
     }
 
+    /// Get the queue index for the hardware queue associated with this request.
+    pub fn queue_index(&self) -> u32 {
+        // SAFETY: The requests is guaranteed to be associated with a hardware
+        // context while we have access to it.
+        unsafe { (*self.hctx_raw()).queue_num }
+    }
+
     pub fn is_poll(&self) -> bool {
         let hctx = self.hctx_raw();
 

-- 
2.51.2



