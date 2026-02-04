Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F03E9537B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A926B00AA; Wed,  4 Feb 2026 06:58:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1257C6B00AB; Wed,  4 Feb 2026 06:58:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0309C6B00AC; Wed,  4 Feb 2026 06:58:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E34376B00AA
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:58:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B31F41B0277
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:58:43 +0000 (UTC)
X-FDA: 84406627326.01.283E68D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DFD9BA0009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:58:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gz7NyLru;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770206322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntJYUYqYp3Gn7FI7pRL2pZqwu0nCn58LEkukXjOhJQ8=;
	b=NGsJ4R5FnHO/bSnP39UKDLtj5XG32eqRnlHPC+L19E4TwLcq+DEDbV1BBmrsEuqLXhIscS
	RKyiBxBwpgrwkaFQJ6O/45ERrmNhRAL3PSEluBTtaORcYRAVtFxSkgwAfMvse4la4EypRr
	kxxJ9mUnUY3QltrIorNv7GILTLY3Z1o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gz7NyLru;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770206322; a=rsa-sha256;
	cv=none;
	b=IumBWPIwLhcysv/9GUPvI8uhBmYYKHPb2djDvzGUipsHNTX7gUU28U6TcBrfCSq5VfPSUW
	VeRwghQwrtsRoRgO2qd+yzmQ+5S+qFBsQ82i5Ly7ygy8gOwCnFjImdEsZViWNEGeyV+GtW
	6It37W1ioKrfRYu/YxJ9nxNX/KFLtjM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1ECFA437CB;
	Wed,  4 Feb 2026 11:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB73C4CEF7;
	Wed,  4 Feb 2026 11:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770206321;
	bh=4kJUgBgTj0V7kRaDlo9MltCBPjRgIT4dj8eMOKXfB5o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Gz7NyLruiwim/m3qBSE5DCyGcBGfDnNAOVb4JpibsYAUsWYSmm1MpCPHgWwtj/fRE
	 e8VUFzL72M3Zx6A1qZzoh/IA8ii2wIC7I4cJhh+uULDLUPyMKnEvCcEKQxVOEmnib9
	 DoSHh3MiiduX7HJcOEoYvDR16yqzuWAG0XdMb3TjJ4hksqK25J8oJA81S9JdyO6hKT
	 KumBA+dRzkFBjLvTQYFQ6GwuEX6rkbvQzlazbWUeATLs2BAmRQQCZoHCpYtJV8wBG0
	 WlW6SNySBC1jA+L56+L0NXtFEY6GCjF7HOrLV7AMDGIWW1Tfv0xJw3TcrW5yiutEIv
	 NrzqX1zgg14vw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 04 Feb 2026 12:56:53 +0100
Subject: [PATCH v14 9/9] rust: page: add `from_raw()`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260204-unique-ref-v14-9-17cb29ebacbb@kernel.org>
References: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
In-Reply-To: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin.linux@gmail.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1098; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=4kJUgBgTj0V7kRaDlo9MltCBPjRgIT4dj8eMOKXfB5o=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpgzQGWPeTkfQ596Yd1NnAfAqNezMquqK4g6o3T
 qdh/ZoqiCOJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYM0BgAKCRDhuBo+eShj
 d4iLD/9Q3u3EUkTrf71/HDEO1t/JE9RtrcE59R/WUUVHVBm36/KFnyuhWlTrS9tw/VZFWtGQ8So
 sTWdaMtJWEC2q3QQRpNIfuFJ+Z/+jGK5LZPDwn9KXSQXO72OFyCHmoxZ8S49BGHkcXC5J36BddJ
 oBhV1NXLnyPAz4PFYpxCpsyaIvY/ndPSnFXUaDUitUS6k8jXTbQnIThXtMjwRQYwvoZ/WV124sk
 UEf0NZdBT/tTHHljmTjmsBsfh/s31GgbOsBRNZlgQbEn1nfIKUv8rkWWsiMc2z5/CrZPZFNLLc2
 dvo/sOb/S1/XSyhIfdqBW5nu6XT3aIsRyQBNla6glkOxnRCPVwGnA0cVqLJSwGDC7HwdjQp8tg3
 6OpsRLLpT8i9c7RUWvazHkNpzYJVUiCdPvQ6bTtgozQcZ3XftPlRnYqaUc0MKuQrDp32ITc1Qpf
 2+NdHl7Ap0HGYUDWUouSvjzXWw3qRpzVu9MDGgzT/Ov44EEz/z8ouTVC8G5/wtYG2DvJ2Vt29g9
 weNYSK06rZyCIJ+f9S4SG6AsSmYmsH717vhWbdgv70nWR1sWbtA2U+0U94cRyNxeQLnmIvuY9CJ
 jUyG0IGKuA+MPWHoxjeNdu0VkFmHoW388Q536eQxeCfpBS7lljXv3TWUIUBmJqIKc7HOg81GZK1
 dE20j3imAjE0sfg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam12
X-Stat-Signature: za3o1qdsfonqzt4g3x77h8rppp6zsfmb
X-Rspamd-Queue-Id: DFD9BA0009
X-Rspam-User: 
X-HE-Tag: 1770206321-167920
X-HE-Meta: U2FsdGVkX195kK90gKFQRoD1Q781F3uQV9FnIzm9XoDcw69hitDRWn4qj+ypuzQQBD9k73fx3HAIzgrbbXDaC6W9bkyrwMkWZlIyjq+jR92NRQbg2vzMcJX8re72oFddKYaECJvPgQ4EyDJ8lLELBQ6R+MeZRhd6F5dOF17JN3ITpzFnttj+QsAFwPFQzExc4ZTneaoLpDUN/PBjau3lktsSUS13NjKbD6u2whIceNtKiXtwU7v58clV60hxLQdMVnli9ARr9yt0w+8ZrztCQ0hSWeYGFTV+xbNzOe6APr9NVEK2jDG8LTj3Rqy7BeBay7JBakyDnRl5PemHLCZz9HlN/LcF/3qN5GkaoJgk+Z/XNzUbekc+/6L3EGiCPpUtXuefS6xLrmrBTTUvQ/V8neUxDY9ieemeu2Dm2sFvp/LHdcw+NbGnW/Hb3AxaNEky+L9fBnXHHem/eh9YPDjKIyur2bvfale9cEUkhuk35XA0T3yaf7t1NqrCS+v54wVgp+o1PMuY0UJ9cao12md0cSn4CXpZnjAJIgD11SW/ZZN58HGVNaCOH/cdWX1WPQIk9aacGb+KJPOR86+SDxABiUPl2mLjrwOmrH7GEc7TXMii7e16w5khahOdCMiMTxv9jDXcNRqU9n291bFB5Tq1t6coDwpq6lNZOXGifS5HTZ8d4SDeKa3FJAGNyHJ4Wjw7nKVeW9eiQKqSDb5DVWTNWy39qSuBMyGkswLmXqVx8H8HCaI3/CguvtOTeu9yB67kf0ZtSzq9ScVHJHpgEbKGME9wQ6o/uxzSjT6Ec1WM4uRLsCrkVb1LN9qHNu4pRolXQhcsQUaw316aBIffwQEvFssMfZSXWK9xjVdTFNlkSs+S1/uIAf9B6pAtClLyEF4tKNyEsbZIf+bGkQmTqZslX2fmbmoyRMw8px5q+kIJo0bmc8O3R6tfdFHrm9SwgkC605DU00CSGoM9KAK+75b
 cr+XqZBS
 dPXFGZbECNHkm6dsrl5Bd9QVgn+H2oDY7WX3UuSKc83yGEvuSj/Ok/8MWWBwzZAAjw03uWH/yn60+AucpOakAjwKhj7v3hEChGqaxxNnMDwAjDMNhZvQGfN7/dZFmfV1ocQvSXzgSK8nhdkQ2r/glgtHB+GgqVmx/YdTvnmi/+JV81Nk+r5pFKMqgs8VQI5A0+DjRItbnZPbATx1B/rw3D5RePUHNdlLFNaWskCjKE1/U3Z5OviW3uFeeqopBmvp3Br1XsXjiCuYtaQQ6NdNwf/Cam8yvqWR/494HNZV7p6yUjIcOPBZR/ADenIeKB4dTSZ5jGc908VvXrTt2cXbRlnV3YCT+PDQOIUu8bkJ15KHJiJg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to `Page` that allows construction of an instance from `struct
page` pointer.

Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
---
 rust/kernel/page.rs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 4591b7b01c3d2..803f3e3d76b22 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -191,6 +191,17 @@ pub fn nid(&self) -> i32 {
         unsafe { bindings::page_to_nid(self.as_ptr()) }
     }
 
+    /// Create a `&Page` from a raw `struct page` pointer
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must be valid for use as a reference for the duration of `'a`.
+    pub unsafe fn from_raw<'a>(ptr: *const bindings::page) -> &'a Self {
+        // SAFETY: By function safety requirements, ptr is not null and is
+        // valid for use as a reference.
+        unsafe { &*Opaque::cast_from(ptr).cast::<Self>() }
+    }
+
     /// Runs a piece of code with this page mapped to an address.
     ///
     /// The page is unmapped when this call returns.

-- 
2.51.2



