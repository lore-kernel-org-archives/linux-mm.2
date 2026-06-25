Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F575CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CE176B00C6; Thu, 25 Jun 2026 06:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6356B00C8; Thu, 25 Jun 2026 06:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFDFF6B00C9; Thu, 25 Jun 2026 06:16:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C35306B00C6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:16:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9F1E140660
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:16:17 +0000 (UTC)
X-FDA: 84918029994.18.17B2D94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1B2AB14000C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:16:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F0CbfPFn;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782382576;
	b=twiCkoGR7Vb62sBSsuhpu5WnIsx2QwV1APfkgZ4A8phpRYUfHwEAuk884c0e63TNxGOfB0
	+SVj4vCAhwWShxmnxyxe87tEau/UMVHCzCbm+H4vRW9xCaxBJLkh7b153hN8SktJ1RRRHI
	IsotUnRyy6I3Jg2UiZX59LI+33q8JzA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782382576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tI6M6Y2nl4r0WViOFml8Atpt2yMNTJUDccu+Knxm3HI=;
	b=FQbD3RU3G9wn01P40AlGRogPzICDxtcW7iHOvOB9wsnn5jWuOWzK2yPg6L7OA33kcAxjbB
	kH5b38GTMjhEIJTYJixFMZ11ahfAl0fpWd5kEA0+tecdGad7I0FWx2+GFQC4gYef51bWj1
	PJTZ32tT2F03tAPpTnQNlC468K/Agu8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F0CbfPFn;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4865600C3;
	Thu, 25 Jun 2026 10:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EA31F000E9;
	Thu, 25 Jun 2026 10:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782382575;
	bh=tI6M6Y2nl4r0WViOFml8Atpt2yMNTJUDccu+Knxm3HI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F0CbfPFnIA0/LErCPW78ronGCivZPYJUOrnX1X9N3idqOK6HdIGJvaQ6bjf2KUURR
	 hSsEUm+0fiScJXyp4uBpuvwDXFpMdqh24tBc9oIjtO36SHR7vlP0tCmBLGe5l+VGS6
	 PPkMRAOEMnqw2fG5khYvUjdiGMk4Ss3jh+rjrcPFhqTh+bwz299cjPPhwNEJjGLJcY
	 7UVbENUhjVHDKx+AN0+10ePMpJa8SAQgxdX6ay7dHdqcR8DrpSTO4dyO1Wcf4fl+yR
	 qAsrckND2AymJnH+1qwutwzxx9lxLeonaC0iLeXXNNa2aLHjFlye990WQcP1bfQ6G1
	 /EnUYhb8vtxLQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 25 Jun 2026 12:15:10 +0200
Subject: [PATCH v18 8/8] rust: page: add `from_raw()`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260625-unique-ref-v18-8-4e06b5896d47@kernel.org>
References: <20260625-unique-ref-v18-0-4e06b5896d47@kernel.org>
In-Reply-To: <20260625-unique-ref-v18-0-4e06b5896d47@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin@linux.dev>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1326; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=IpZr4FT6FvBjQrQQDya19Z/r3yR23B/8jNNyN7AG0Ho=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqPP/EjXMD9Irw6nuJhPFtq2/EhFqdmzJ8hijBj
 IUWa604Ry+JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCajz/xAAKCRD6UCkIqsW9
 0FeBD/4jVYT/NquejgL1Hc9CwBS8FOIsqeR6evr5bHoJDDfcXKDUfyPgkZBBBJzvKPStehWt9Ba
 OxPWNiTmP/Na9xzXVTf4N2NYdp8Gw263w3WUH/KqxsinznoLwIk/t7pOCsli0YTrT3gEVnhvLvM
 lx6XIQxbO9tN5zSa+Cz5ekL5AR9/BVCVtQuvSYwr2yC057sAk3/+pLmI5yuKcdjE7qDEWNMbrz+
 GsbqFp+j/wND47pZgWmWgOVOOB2isuR55+uYVBLNq/ClT4VtBTyaAkoJ/I89ABqI9RaSG+qVyKM
 6C/bWU5Jc8/F3s2a/y6gacqerscAzwzeAC03rj+NXd095srNb1AOzGkU+icZSsHT4j5/MuEe0tD
 VhDdparEYBYjSj5PvlK7Kvq18ivW3lmcu9T3EGIQ4luui8emt9TgaybS2iDLiiSbSH6vG01yDDF
 3gByAhtfowM9L8/A8ntYt9VBdRC3d8E8110+aSCnCp03VHYE2v2R41RKP040igcDgGQ6Qo05WK+
 jjmSW+h7QarnY5cqnTxID2mDe4lkrV1hLRU6L3S/yo4C7CME8q2w+qnfpOXgoekvCdy2s9k9Z3i
 OiQ1Avp2dfEj/2XyGmAadZ0z7PnbBXn774lHjR4vEkXgxeWk0+8Ir0eB2f/cU+/S2SscPAIvNUF
 hB2Z0OACdPe3ruQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1B2AB14000C
X-Rspam-User: 
X-Stat-Signature: 5d1x5j8r9gm4am3jru6n4kx74zps1pyt
X-HE-Tag: 1782382575-8000
X-HE-Meta: U2FsdGVkX1+KVH4Ne4wWhwfNzk3tCKstqXf4LuHDsKX/6G3I5kO21Bz8KIexVQWzbBJn0D1Gl7DxyVaCdzWHSscVoD1DFE5vQ2aQ9HGer8fZQTA79cz5UCLum/X+VSlCsi+bZ3UfclP0SqFS+7cr3tb9lULm4CKoBcEWaorelNdFP3IcAmL7i+R2OrL8/NOROewTqpWBe+GqAPlvO518L41Gtr8bH5bMeH0nOqsVzppsjVCnSglvkKqWaAa8l7xxgdFPW0E20ggIirqlJ8mlPCqS4jBC6XneeDfqrT98DD/UZd/mdWACnJRB5JfQC3hQ+Z/Gyxz3zct1nezY4E1ygHHiomr7/uwiQLaU4UfNtnMN2HaimVklGjfC00CGbANcuBrJrX5zvx+zJnokXpt6n+t1iUCpEvw6YVljsrBp5GlC8Acdu2fg0K/yF0cDRRPyaKxgvVmwYCnMsLlzqp3c/+jTS5d9QZsGZKDx5oC0diDnMI7zW0HsWNxghBKavETeZwhL9n2kGJ2Qvjmt3ztpfBSTbXLn5DhGRW3IPz5sMklGlxp/yOUDdrVQ7RPwueJWLTewQDraTlqhPVDM6f1brCI0oNlES9WtRt7PhkCHMlMY8VAa/21UPqy5Wfm+YOgMMOEWbFxfDRhnD3V1FIL9aIhHcZtd3kDu+N/wR1Q4XWLDcTrfQyWDHtXoVu9cnRgYq6bP9g8/FKPk2M02YHYkzBThfU4SLXyDnJViE7ke+W+RD3bd+2rIBK9Pfnx1pzRC32ygDopZSUj2fQggvUBZAM4aCpfoojyOgj14Wq2z6XVkByjfafAqwfu7Uj1wMEEm7GO1pYoRqcefgBkSwvwjm/b2aveYvHjvapjAVzuq6qnOaQM5BlM8iIYrCi1zZbfTM7PcRTUeA8UrURMCpS8FQi9OCBWYtICu+BxjBFp+ypzoxF+x4mL1NMXmaSBm6xojmgwsUkEQMVFvBUDBWmc
 NOQNpgbE
 Kv0CXdAsQ69D1pIhrlPgsxFsu6hXdgkRcWkeI8sAT0qWL/f+4HxjdKOBmvNhxbOWeNy+7KkY4e0VJx3rTwvqdtXpO+CsZHHU/41m47mf+xEcFNJSS137Ww3DxFRTt/W7vqMEXZjTuZXSlD2cBe7MlM9LTRlNmh0k7Z2pytD7nwE9tJHJM0W2A9OtZ6qPugJAH5PyEUQYAaKNz4C5dR/2pCI5ndZ9r6AtvvZnCLL3hVk0/4M8S61MVBTqhP0daQ64zHEz9YcGg2MzoJKjv2ONYZrGfp6sMUEBDNhTIclouyOGaXG5OWcbVT4zNtnodRWjOQOTm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andreas Hindborg <a.hindborg@samsung.com>

Add a method to `Page` that allows construction of an instance from `struct
page` pointer.

Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Onur Özkan <work@onurozkan.dev>
---
 rust/kernel/page.rs | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 6dc1c2395acaf..c88fda09ead5a 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -143,6 +143,20 @@ pub fn nid(&self) -> i32 {
         unsafe { bindings::page_to_nid(self.as_ptr()) }
     }
 
+    /// Create a `&Page` from a raw `struct page` pointer.
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must be convertible to a shared reference with a lifetime of `'a`.
+    #[inline]
+    pub unsafe fn from_raw<'a>(ptr: *const bindings::page) -> &'a Self {
+        // INVARIANT: By the function safety requirements, `ptr` refers to a valid `struct page`, so
+        // the returned reference upholds the type invariant of `Page`.
+        // SAFETY: By function safety requirements, `ptr` is not null and is convertible to a shared
+        // reference.
+        unsafe { &*ptr.cast() }
+    }
+
     /// Runs a piece of code with this page mapped to an address.
     ///
     /// The page is unmapped when this call returns.

-- 
2.51.2



