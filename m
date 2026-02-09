Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31DF8E81BD1
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988886B009D; Mon,  9 Feb 2026 09:39:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93F226B009E; Mon,  9 Feb 2026 09:39:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82B3A6B009F; Mon,  9 Feb 2026 09:39:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9796B009D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:39:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C2B6136DF1
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:25 +0000 (UTC)
X-FDA: 84425176290.12.F0AB07C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 46B73180005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KsCOB8hv;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ideqKXRl+KC8uyTipqZC2c0hD7mkSSa147PGCFe88zQ=;
	b=rIuC2D+rPEGTp1PVG3/3VgwjOm+QpG1dzzv6tlSyuDixcai9kVBVRnhZDoZLyIaGWcS+Hr
	GdA6v5rfmEkpEeO1pvrhtNfYVKhBDuwreMpkdi4yJY2KYzvOzwoG0S1vucvhzQ3JIva8xk
	3FGt4WTG9CSbEIdM63iG8mVX89HzNso=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KsCOB8hv;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647963; a=rsa-sha256;
	cv=none;
	b=um9FziSt4qNIFqmFGaLppXM9r6jdDAxOTSWamRIJlQ1LDJ1Dimml2O8qOlUhSSVEe5j8yO
	5ZDWY7Q44plYQftj6WJaegpM1hEvM/VhPPxeewnqHK0bHRBSH3kcVRtvcyAjpAAY0nR140
	WkuObM+fHRMZof+95ZiMU6v36dwMLq0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C1938600CB;
	Mon,  9 Feb 2026 14:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFB5C16AAE;
	Mon,  9 Feb 2026 14:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770647962;
	bh=QeBXOf7iICj0Ad5qHcIJv0VhQMqjDmVdKEV04oiCJGE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KsCOB8hvj7Gtk4r2EvVikB0I4H7vI12YU2LI1k0BQOQnCeokh6tjUPBHt71Q9pkdZ
	 1lNhcWa9XKHUI8c1dl/BxAg8wdd4stVJralvwL6pR28PRYVYPslxkrZ/GSWS2he9TO
	 3s6rWp7/K3KEbpBykpo4f+sVpz/vyJx3w9VsV81QqTq7sd8QwFVdaTtBKw8OcFuFro
	 SedCpoe7++qniGqyVXi/+cdSI4xr69ogDjCnr0+9dBH4u/ExIVPzBsxc/7HdhrWNOY
	 rNWc5pQf3vpU61ghIg0y8I57IxpcczFGnENVCPWsW+Kt5NmWivpJPsoJbtLRJR2F3a
	 W3gCw7K8boG+g==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 09 Feb 2026 15:38:07 +0100
Subject: [PATCH v3 02/12] rust: xarray: add debug format for `StoreError`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260209-xarray-entry-send-v3-2-f777c65b8ae2@kernel.org>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
In-Reply-To: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1047; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=QeBXOf7iICj0Ad5qHcIJv0VhQMqjDmVdKEV04oiCJGE=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpifFW0J5aHNJu6sg5tbQ2bMQpjZ6diEOzfohIH
 ThYiryfIliJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYnxVgAKCRDhuBo+eShj
 d/aCD/9U7agBCp8sIBnhY4v7lk+rLva9/so2zOxVLJn+Ju2B2HRFE10h0Jx9KyJVbbvbeIcxgJf
 BBq2DOvK+m0c5GSw2uewYmJaqcLA4mxfaOzgtfFsA94TV0MBmp9XydMMTvx4/zRi9BeLIu7Uko3
 thaN5I1xUBYiVkhk3KlJ2BQujOvvZwmKqROn03pXpFBr0cBSKuHmFVVprzMRd7UpSMRqoBEoh60
 9+Qe1KDMDPekp0CezkJurKJK/E5uVbdwSgRRAfXonDulmT2hhARoZBe4sJ1HaUczJUNWYzs2Wjr
 XOJO7pKsDEwGnK86gnShBPj/5VQ5PqicQmpGikFIwUcDDxWSLyA6nREmK8gl+fm0Fj7JQrvX/3O
 lg7dXPMeWFMCbN0aAitSXxaxYDIZf0xaTpeiUebEO+w8BU8zlW7ICOO7UUyhYuonKEg1aLQIiyP
 kTkcIlosy5t3uXD5hYKDLQ/ZnS3GQdxjEiw1uHS3W1Zd/I6P63lvkaPI9RIZbiiD/6kmKsgp1Zm
 wRMVg4srvYx1V2/ZkDxDE4b9qqXT/jxvkzKe5OuVwK4aa/P0kEs5NIO2g2vh4t7SJE7PlHA/eVT
 EW9eLL9eROuQmExyYOAAMvWNTC5fxcPKDH6gZWBkAwjID7zizU2AD1r3Puc1cMN6sBeNrOrr1+7
 HZgrFfLb68bznRQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Stat-Signature: ufkmm9ew6dmunn8ah8hf8ptcq5j74jhx
X-Rspam-User: 
X-Rspamd-Queue-Id: 46B73180005
X-HE-Tag: 1770647963-517307
X-HE-Meta: U2FsdGVkX18Uhjk/kKcjLhiSaVMgEUS518WOy6AWL/VkEB0h9pwesxdn6Vc+lAQFz4pDMvG/Xb8f+0FcNgsFH/Mva0qBUqbXY4EnCkl8eTdqrForFXDmoyj8gQ7cdOz2g1hq1wUbbrouB+ayH8snKtXdyYE3uBvOzJLQ35Z/4yNdshKh4VgS1pPhbMV0vE66UOicOrcev9HPqxzJ/iKcL7xOhrfdIsy9bXmpnsu5Ds8GZ06Ruzu5qn9Fn2hmqaAyScQ38iPZdVQkZP7Ds9dTmoLrWTAb6JgVUw9W/wi3O8jdOT3GnkIfx9RGTzD96GSzV0klIssVW0l0oA4XY2KfooTxj28dW0E1UPNzF5ptgKtWdP9wKFu3tjnjrBSrFHZuBj51pxbqOCWpnFkjzhNwEofYylIdOZz4InAfji8byU40mW5WN2UuvtKQK5JhSMD2R84vmgV1spdmtsb5HT44QwXQYeYrJ/9WDgshdBYbaiDDk89vfbO+9LKUl35qx2fd1uuz4dSsPPwN5d1eim7YR7Tb2P3Ww/9ANgxDfe+QM4IJmYuxzdVUochQFobrLCwkOwXLvGlUUbkfbh1RHJGS2S6PVhs5xnUI++caytuNSm4tcUspRjgSFU1F5wKMQDPgxb4gEO2i8G3U5PO4yMk6fU5uTnu0Ow1p50i7fUdRnA2gePbr+T+mHIAXqEyFulc59KqkAjWtIy8bjoGrr6mLKrQSPrlQgas8tUekNFHj3e1s6IR+mYhLIKpkCPss5B2+pcU/iOQIzi9aZpKIPJSzvxcgOgjLIsepnB+tspGZ2p01d83dPYyZqAHxAyV+IQcUCLDYaKzCY7ApvONR3ALhGzkWb7Sbj/7jUm6VRY0yzEwNFhfB41RFsuvGGVir6xWaNBzj2QPu0U9WRHEwVQKjfoHvacgdokwNLpcFQsq6+6iUcliAV9xRAQJssH0TFi70iIf+8aubXvGW+OPgYH8
 1ctpVQtZ
 AsnuXtOfCDSIDQRvdUV6BB9bXzUkfDM1KqvVlm4ie0vNkuzafbw7xptJKkIx7Cb+/yEZ0hJ5ox/pHxuIdjB1YBlh50xx4shov84737kivr1oSG15sZCHUGtrHQqkBspxYGhreHnAHkMKFGqnDAjnc3CF2bpA93dOXwLVbCz/rSO8DGRmKaarUlcxfQRqk2FIoAym+/bTlt9mwaaj9yLT6KBknHdfYdBxn7xfAjiDPfKhQsFHSUDB65G3lX/QYL7r2EC+/PxQY/G9X722Ptwr0KtLmEuF+S0hsOBNyCZks9VpPYTTDLeSQdXfHUCPDhaKJTrn9ITbx6iCG8aILLErK/oPFRBX3OXfx23hxYYJSYEO5IzNNEp8ByT55FKikM3sFdhtrivX1PSi5qn4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a `Debug` implementation for `StoreError<T>` to enable better error
reporting and debugging. The implementation only displays the `error`
field and omits the `value` field, as `T` may not implement `Debug`.

Reviewed-by: Gary Guo <gary@garyguo.net>
Acked-by: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 88625c9abf4ef..d9762c6bef19c 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -193,6 +193,14 @@ pub struct StoreError<T> {
     pub value: T,
 }
 
+impl<T> core::fmt::Debug for StoreError<T> {
+    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
+        f.debug_struct("StoreError")
+            .field("error", &self.error)
+            .finish()
+    }
+}
+
 impl<T> From<StoreError<T>> for Error {
     fn from(value: StoreError<T>) -> Self {
         value.error

-- 
2.51.2



