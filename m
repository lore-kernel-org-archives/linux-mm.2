Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB691606A330
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jk6jRpDK
Received: by kanga.kvack.org (Postfix)
	id D49B16B05B7; Fri, 20 Nov 2026 05:28:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9FB6B05BA; Fri, 20 Nov 2026 05:28:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8796B05BB; Fri, 20 Nov 2026 05:28:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9818C6B05B7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:28:15 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2184580ED6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:15 +0000 (UTC)
X-FDA: 85455122550.26.804B51A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4CC4D40007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jk6jRpDK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170493;
	b=1ZED9Sqb6wtH7E8zBIdGdDI66ryVNVb5VQsVsNOkBoC+EzbRxcrPAud3mTW+BsI88gXicT
	+7XUq7Db43vJeSSn5FJqhJ5mMpMt77FQd2L+pIL+nSIeivWW4ckUfikoPQr01IGS6MH7gE
	E4+pQ3yLhl+GdSOfeyNqPgrGdXg0anY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tr/kc6UGkV2CwaZkbx3GCvGJbNycglgiy4h7oaLu2ic=;
	b=3gGZlNlJulHs68R0OgnlZjNFPuaRxPz8o+czhDyTUkg/E1wNtzQFgdlIGknYskinEyNT17
	2SSEKH3c39rTx7/kN5VL2BhMIoJfUbOVlEA++oATNyMjynV0C0VTA/w+caja8cwXFCDHXO
	jKzQokWfF0ueTNxkZV7o5PzF0EZ50zo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jk6jRpDK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93584465A7;
	Fri, 20 Nov 2026 10:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21951F000E1;
	Fri, 20 Nov 2026 10:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170492;
	bh=tr/kc6UGkV2CwaZkbx3GCvGJbNycglgiy4h7oaLu2ic=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jk6jRpDKelDNctWq/slWA2pXbw708YRxXVuoiNwkFJJSN7GyvQRj9/vgJYA00D+aY
	 CE5oDyGxtg0d/GddeBr5ZOQkkDcuXdpeDt/jXdFdpMifRbuHA+83CB8VTb2tUy5CZp
	 699wycxU+oL9UM6/q5UGeKaDhYsNVrTsnQ/GDaWKfcifkAPfN3VvMDyaWnfTbEB5VB
	 mJJALRDe98IboCjWDiP1DD518VqYkxnlodd3BLMO9jf+Q9/b72cbckpQppCA8IRIJY
	 uKW6leVRYwtLUYAgt4VfVtwRc8BzLogaPAe+lp6rqMzqkhkcT0+HHt+AugKVrTrXpF
	 q9qfea0jc2Y2g==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 11:27:02 +0100
Subject: [PATCH 03/11] rust: io: add `SysMem::fill_zero`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-page-shared-v1-3-66f8c4c62822@kernel.org>
References: <20261120-page-shared-v1-0-66f8c4c62822@kernel.org>
In-Reply-To: <20261120-page-shared-v1-0-66f8c4c62822@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Mark Rutland <mark.rutland@arm.com>, Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1305; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=7gZAcIHVpEUXSg+oYUBAk7+IRLdZOswlHSQd1XL1yCE=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrACCE7idfVWKq5Y/yQuJM04kp96BOHWPAgz9Wb
 kVX7WvAopKJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawAghAAKCRD6UCkIqsW9
 0IqvD/4hfhwc3O9l7bqpLf3rswIqamrc1fmvhTqvxiRf+A3GjUyOU54DY18uzztZ0Yc3pVsZ44A
 lky+feEjgINFLSlbm5Wwk+tVevvmA4G0+rrNAtNO9C9kuUi4i4LXp/rFt9Crfr+qsTXhBKePwsq
 bB9RBuaSg1GRziBzCUnqpRN2rQFsEq7IYajcSxF8uE2sPaa3cdvdyS4CJZ+pUdLU1ZTf2uEWw7g
 30V4RG8siYT7+vnJYcc3WmULsw4COn2pRGjtVEPHHcRBlXa4XrleF2hH8H2hVbn8dklC0grAtCr
 2oLBLxiL2elCfN7fkVH3tuUhoJY67Q9zyRnQHRaMiPPjkNevGz6g0u30cI9EgL6RI1Nm0Gxf3OV
 B73QxpmqZJoHHYOOR2JHZypU7XPTYD4I04xChFzQ+Dzz7kLtrgThQ8pH/eEejBSXBgGHkiltn2v
 NDENGuWw1UW3ya9FcmkR7SUINGX3+OptjjvnBGVn436OUcOZ272F99JKRTPK5rh38xqBkaij1wZ
 byHKR2twMgcvNuiCYfL5NOLp8KsNSGcdOuhiOdAtbZkiK3cb0dc+HpXSZ4BeTa11v6q+MVlu6jB
 un6NSiKyk/UEWlvDgRP4zpLDA1qG4pW/1ryxL8ZGGpmtdQY+kw5Bt6E6IVzlvbMZLLjjniaFnEc
 nmd4PtTgYWSJN9g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 4CC4D40007
X-Stat-Signature: 9sjt4ntzudwxmqxzc36cmtj1oiz7muah
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795170493-790144
X-HE-Meta: U2FsdGVkX19AiaWw/EYV+D1/KMQK/MRbmxga8HrXajYnEyztmfra+k8DutZYH9Qa35Dt21DI3aIpDlzk1M6qvlAsFSyBCB9Um1zjts/2sT/a+dG8TKfN2BDS96vTl2pS9t7F9teyw7D4e2GrwHjSTBIXYdnQbHYXT9vHttjR7AZMKZd1pPK3vJH010O/Os1pIhtjYZ2Ukapy8zKzFW4S7XnJWsnIJTrWe74SwyNDySeETkd4naSX/Y7PJNJDuPsfIBfU+pct7MeeACnGb3WuUP7Enp6OL00nvniZwaxB00707mAP/EZBH1KKaJtZca/y1vSNrk4Pfoq8KmK4vpHiXnyrEQnI4+SUEdLdpfDx+ImgNE8ZdG+E2oUv+9a3D4/oF9v3Pbkt15IB+6EwJDO8TJlfRg6sITKzHkSTKYM9123pLnjvgJsiIfCVqHQZYilZkYoZa10ZqWBG56HPigut3mk9zd5meW8ja1OotNfPRC4WmspCrWgx01e8ryNXU6bZyfkg1D0GmzZxMPhMkcWn0vuVHiCV8kGikdjJd7snfPUMftkWksBRbEN+TkgXEvplxI6L5Rt0sIGuOqgTsLZCVnZ+7N/vITckpTukO1TMgACIi7FU0jv2xwPPVkNcsjk4cVyHFvgGjyisQ0Q30UsiURUW5aGDYHRNiM5BsonLXrhsVL1K7+YcC4oySINZgbkJrIgWKL/Od6gYGK1kZln8pWV+Fkgnt93/rE9sgi/ZQcQ8FNPIBWfRdDONDVgD6nINsWgTdyxVqHCBg6vkoSJJD6awYwAgPbCni5sUztTzAGU4MqP6RLu/RaDOYFXuYO/g7aqdpUiEUA/mAzrIyJL7K5dcs4Uy14hxqoFwzLomyNGeFmDbuoSpKys7AwKxVmc36Axb176jAigL0V1u2XzF1zqWzHR2QULQSQCQEC+GXdWOErSCGSSFkYh+zEyFvMcv5HKJqzAM7bVG5kvm83s
 VAW0Rl5n
 ykE3w9pjfRO0oKeCrU/wycoM5oD4rVgGTDVM8OO24Sn6apStRftu6tJ+pIlclF3q3oSLbD3c1gjkT3wb2vFiuqQb8cGezxFUuWTDzo5t/IgBYDweTPbqZvRJ0NRNrK1UNReJS8I7f9FmX3uD9QWaDaPVzm6Lca6SDaljcoTMpcIIU8mEKdFsQAPs4cno/il8oTrAW8fTv4MA47P1Xcs4aXVWThvH28Km9kNMWXk4iCAHvViOlLbOmpwk1iOvu+hkhfqal5XcT7fgbmgiw5tucb+yF+AFLouv1wzrjr7sAjP+S+fbQS1DL9349DzzoRHqnOGpArlOW+21659sJVU12r++Na0encAGpcA+JRNMDV5LJuISBSX3hCowFepC6DpkVSm5ms5aABFv4Q55pO6dDVIna3Njov85hnJs4+n8E9WSyHxVltcaDkTzIYZrQA0KvlmDVcuxix2ZaSmHIXLW05+UIxxMT2L8DW/chLdUJuuGDsvNlfKEBRLpmZVEYd1tOJAe7RYGojeZ/RIqS8FAStiaVv/LEfAqRQ1lwptdWvJIXTn/ojJw82NVLPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a method for zeroing the memory of a `SysMem` byte view. The method
uses `atomic::memset()`, so the memory can be subject to concurrent
accesses.

This is used to zero the data of a page that is mapped to user space or
shared with a device.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/io.rs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
index 76904c63eb0a..33cb5a9fb3a8 100644
--- a/rust/kernel/io.rs
+++ b/rust/kernel/io.rs
@@ -1586,6 +1586,17 @@ unsafe impl<T: ?Sized + Sync> Send for SysMem<'_, T> {}
 // SAFETY: `SysMem<'_, T>` is conceptually `&T`.
 unsafe impl<T: ?Sized + Sync> Sync for SysMem<'_, T> {}
 
+impl SysMem<'_, [u8]> {
+    /// Writes zeroes to all bytes of the view using byte-wise atomic operations.
+    #[inline]
+    pub fn fill_zero(self) {
+        // SAFETY: Per type invariant, `self.ptr` is a valid kernel accessible memory region of
+        // `self.ptr.len()` bytes, and no plain access races with this write, so it is valid for
+        // atomic writes.
+        unsafe { atomic::memset(self.ptr.cast(), 0, self.ptr.len()) };
+    }
+}
+
 impl<'a, T: ?Sized> SysMem<'a, T> {
     /// Create a `SysMem` from a raw pointer.
     ///

-- 
2.54.0



