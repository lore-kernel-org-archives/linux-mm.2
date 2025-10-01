Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7020CCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 04:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70918E000C; Wed,  1 Oct 2025 00:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48898E0002; Wed,  1 Oct 2025 00:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85478E000C; Wed,  1 Oct 2025 00:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 929098E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 00:46:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EC6611B0DE
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:46:25 +0000 (UTC)
X-FDA: 83948309130.29.FEEC0DB
Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	by imf06.hostedemail.com (Postfix) with ESMTP id 69340180007
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:46:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=elijahs.space header.s=purelymail3 header.b=BVY13p2N;
	dkim=pass header.d=purelymail.com header.s=purelymail3 header.b=sbFVLOys;
	spf=pass (imf06.hostedemail.com: domain of git@elijahs.space designates 34.202.193.197 as permitted sender) smtp.mailfrom=git@elijahs.space;
	dmarc=pass (policy=reject) header.from=elijahs.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759293983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sfrZW6AR35r6CkC58CZBqPk7K4vhTSoVPBNTGOk/rRI=;
	b=r7opNZqnl5x2bkzy6K9tiSFC+37/sLdpxnXZ+/kFD+b/TKN0sBd2jLMX38TICLn51l+OYg
	r4Q8PV5cU+lFw9PhPYoHjQATfanqk7D4yollj7r0yAWsinGBTKiYiv5vr9VAm/ZO//J61+
	S2Wz6Wysn+YOljISzOWe2dKsDm3g0W0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759293983; a=rsa-sha256;
	cv=none;
	b=RHiizfgL1zRCfnmMFFJGKKChTnk+Ojc/ep5zGl7BCyqUur2GjSWBcscWtRiG7Mqw8RE0Yi
	iHHCMEKLKv8giljcchcFSMU6RSIiHOFhuWPWGpPaPgxVSrpyIbMvhhp34fFWb3YOMbwUwo
	Ekoxqoagv6MbIY1NV61d+WffCtQU0c8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=elijahs.space header.s=purelymail3 header.b=BVY13p2N;
	dkim=pass header.d=purelymail.com header.s=purelymail3 header.b=sbFVLOys;
	spf=pass (imf06.hostedemail.com: domain of git@elijahs.space designates 34.202.193.197 as permitted sender) smtp.mailfrom=git@elijahs.space;
	dmarc=pass (policy=reject) header.from=elijahs.space
DKIM-Signature: a=rsa-sha256; b=BVY13p2N/J3gxB4vcQ9vaRwkpICVSGS0Wg6rMVgrnHn43OzsTUq8aa3vKO4E1Q98CwPKLz42Sh3UlxbgS6E2dqKO0d1JXhlWPLQ4wP/etM5iRzgY1yNKpg86ZWDL98DD2yiHNUZH7y1MvCXtBOxgpS/Cg90xqMAZg5lyTCs2+B0Eac0ZW9Tt9hgWmGY6hRRn6GOr+LzuuAQQMZyoiLNlOIhEVekzBTi1bz0j3GoYilS4+dBqqVYjvqfTtJX5muWc2RpD0cqeZ6nZS9JtE8kD6WqmKoDpLigTN8ZshnQ0YMZEvH2isqhGYJErXJHCNjxD72gUJKXm8GYmYlHoF8Ro/g==; s=purelymail3; d=elijahs.space; v=1; bh=W9aE/h0MCF2uj9dBQXAmWE6NxDahP+VqHyrnxKfSqKI=; h=Received:From:To:Subject:Date;
DKIM-Signature: a=rsa-sha256; b=sbFVLOysOH+HRfWWENrNx001woaBDpzpoQnXyPe7Dm5sNgrt5iTQaULT8fqQbLwmp7xE5BVFTnX9JdbZcwfvZlgTg+ZpuuxaXIcaCEw72xMz135jxKjj3rEIIbAuvvk8DTdakrD4i33EcifpCrYrwdqE7ohadn0dKwCaYRSbMr3c5Rj+aO2gjD3cLSFLqfm2zgT2lzeF2LMGfnR2e5CST0hw9XDh/V2zYHBCtO6GFWIMD0b5cpuK4uz8FDPLCFWMI/0DA7vf6hCUc9RdzX2IL5GTxR0xannQyrn7xEcKE7XU4uTjVICThplaIy9l5wpV59gc8jQyxGjmTz3eqeBVEw==; s=purelymail3; d=purelymail.com; v=1; bh=W9aE/h0MCF2uj9dBQXAmWE6NxDahP+VqHyrnxKfSqKI=; h=Feedback-ID:Received:From:To:Subject:Date;
Feedback-ID: 147366:4866:null:purelymail
X-Pm-Original-To: linux-mm@kvack.org
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id -1637358726;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Wed, 01 Oct 2025 04:45:34 +0000 (UTC)
From: Elijah Wright <git@elijahs.space>
To: Elijah Wright <git@elijahs.space>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-mm@kvack.org
Subject: [PATCH v2] rust: slab: add basic slab module
Date: Tue, 30 Sep 2025 21:44:21 -0700
Message-ID: <20251001044508.23126-1-git@elijahs.space>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250924193643.4001-1-git@elijahs.space>
References: <20250924193643.4001-1-git@elijahs.space>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by Purelymail
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: qdgknfu7wb4m97kqqq59xidjpxz9q8uj
X-Rspamd-Queue-Id: 69340180007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759293983-780803
X-HE-Meta: U2FsdGVkX18R3cOYhFpO/SsmMo6Nf9VwBaz73FF9/ZemKgJ5P1yKQh9WHfVbH2UjKLXHEvIDrhP4YVifPlIeXw7rwaQ8i6XU4SNTJ+uu0UKpk1Yw5s50Ugc/9Jdkl5udVRlxRTKzuwgDauo83EtbUHzsr0wk0nh6A6Y8kDrkikD8ospHLBis9yA6n7Nf3+Hr/ACuduqgQ5RXibpvZz9Tc85NsTHOSu4JZCFEX2QaASlRGHrLBulcgDqeWYs+eRmXBEn6w5gDELWYy5tVCFLnYO+tZ9qMKHTDuNCvPoAGqlT62dB672VU8GMOwe/SlnrLDaP551gWs7Glxo6oE/4pLcSJ+GG4xpGka0v4Pd0xz005TnUp3B2x63JZdwyLny4gtvj6dN3fLAz4kYBkyFdd4fYCklM46UoemLRWUulJz1snWwgHDZpQhKnCePBjO4Lq3MtN6r5Y8jJRUEMEEHJm1bEdFtqZdKhWrbJap6v5QoHhO29gzukwa8/qCh4SFrqXQihbD3NU719OCYv4R+hGCBrJACyW7kfpINHYRC71b3/AwuZo1V047DUnqU/zvNLxfc+rFj9xNHS05XaDjKCBofH+GneYky2LibjgfJuGRelrNDBHC3cOFMohDof/C0vzsGyz14jEk/5lrRfPL/BMe0dTgt6NKN1V61UooGv8djEpaimUfdYGgFI3vkdIrsPojqDCZda40H5vqWIosehNYAm3TkO831qXM98g9axbv3kLQL5cjHA99IxMEyBB57+RvOQb9b9T/veH1Mc8JungOfHalVuLfgTSOSCYsphOWXKJrvNLOqonF2PGEud3LIsfcmY2E5RdDEacp4PhCXAs4FP555gtvUdfUvOTe0ae8l3JrOrktLtq/zwaJkQUFsEYdcJerS2q76y1CCCgm0VPmmeXFSjrhCqpJBla2irxsLCdrSIBPapS7fjlMn6KjFIxfHVhY//a/nA7RXSKV3x
 cmaGmKsg
 n9T29uce0zaOw3cR24YnLCvyJQSs/pLWiQAfyxyteqxzg+7yvhW6x8HArAZILN+87NOTZ1gy7YHCd4/s6xn8WVzJ/4ROiMuohSBUqCq1pdX/3V04gt5nuF1fxHIjcJHhdpSTbxDPk75DeCUHfRJEqpMJ/HBGDYvZgO7ioSCDJCBn5Mb86LrV6bwxB2UkELnyWqk9wRHKdLZiYVVkg6ACBNLxGj7wGyHE2QH7uV9POwJCtnTerAHpbV8nj5jiNIPhJh6Y3sFR2JroERP1C/tbNVRQKxfDouoBzGJXCYY4oi14VxUuV46WbnyDA/tlX+Bef38xLKqeA00/tq200TQZw7u23kwkdah9xPMEaYCo3gDHeGa5NLcelxe1Xtxdueptg+zfa8yGJkkLgeGyUbajPhWfwbUglIAI14n2jTrrgro3wzyg1tV1+hexGBHohTpUN1BujR+2IjLdl8DQCEWi5ejFNOMx1x2EsJatWPuBXl15J1Rx6UtlXodwVR7lQH/t3JKMLv+CEc4neNZkeBuqs/z/miZ8YMr9GJORvDcyrLShvmUIdBwlL5mkM7hXka6zaTRsYANWvTamgoL0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

this revision adds gen_kmem_cache_allocator, a macro that implements
Allocator::realloc for kmem_cache. the one concern that I did have was real=
loc()
for resizing, since that obviously isn't possible for slab

Signed-off-by: Elijah Wright <git@elijahs.space>
---
 rust/kernel/slab.rs | 52 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/rust/kernel/slab.rs b/rust/kernel/slab.rs
index 8b418f9db7cb..3f1310f309c5 100644
--- a/rust/kernel/slab.rs
+++ b/rust/kernel/slab.rs
@@ -83,3 +83,55 @@ fn drop(&mut self) {
         unsafe { bindings::kmem_cache_destroy(self.cache.as_ptr()) };
     }
 }
+
+// SAFETY: The pointer does not change after creation, so `Slab<T>` may
+// be used from multiple threads.
+unsafe impl<T> Send for Slab<T> {}
+unsafe impl<T> Sync for Slab<T> {}
+
+/// Generates a zero-sized allocator type that allocates from a given
+/// `Slab<T>`.
+#[macro_export]
+macro_rules! gen_kmem_cache_allocator {
+    (struct $name:ident for $cache:expr $(,)?) =3D> {
+        #[derive(Clone, Copy, Default)]
+        pub struct $name;
+
+        // SAFETY: Allocation and free happen through kernel APIs which
+        // provide guarantees. The ZST carries no state, so it can be
+        // duplicated freely.
+        unsafe impl $crate::alloc::Allocator for $name {
+            #[inline]
+            unsafe fn realloc(
+                ptr: Option::<::core::ptr::NonNull<u8>>,
+                layout: ::core::alloc::Layout,
+                old_layout: ::core::alloc::Layout,
+                flags: $crate::alloc::Flags,
+            ) -> ::core::result::Result<::core::ptr::NonNull<[u8]>, $crate=
::alloc::AllocError> {
+                if layout.size() =3D=3D 0 {
+                    if let Some(p) =3D ptr {
+                        // SAFETY: Caller promises `p` came from this allo=
cator.
+                        unsafe {
+                            $crate::bindings::kmem_cache_free($cache.as_pt=
r(), p.as_ptr().cast());
+                        }
+                    }
+                    let dang =3D $crate::alloc::dangling_from_layout(layou=
t);
+                    let slice =3D ::core::ptr::NonNull::slice_from_raw_par=
ts(dang, 0);
+                    return Ok(slice);
+                }
+
+                if ptr.is_some() {
+                    return Err($crate::alloc::AllocError);
+                }
+
+                let raw_ptr =3D unsafe {
+                    $crate::bindings::kmem_cache_alloc($cache.as_ptr(), fl=
ags.as_raw())
+                };
+                let nn =3D ::core::ptr::NonNull::new(raw_ptr.cast())
+                    .ok_or($crate::alloc::AllocError)?;
+                let slice =3D ::core::ptr::NonNull::slice_from_raw_parts(n=
n.cast::<u8>(), layout.size());
+                Ok(slice)
+            }
+        }
+    };
+}
\ No newline at end of file
--=20
2.49.1


