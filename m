Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC93C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D74646B029C; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDF946B029E; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C131F6B029D; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A09166B0295
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E6808049A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:22 +0000 (UTC)
X-FDA: 85165678164.30.644FF49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 290511C0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uskcNA54;
	spf=pass (imf18.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788278960;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fo46M5lOhRXCyOMZRhNjQcuNwgYvfdhAtwpLKHtX+nU=;
	b=VvHbYtJagLILqpEAJExcnrfaqkcVXBgrYZLs6oSdjI7esCH/1MulUGMEFhPLqWC30PIEFg
	23Di57k8XMTIq37skvkb6zSBF+g6L7o9Z15YzLK5icfmN0uWN4MwWUs7kEXO+bBa3QyGm7
	W2/g7uCTSzbOZkoGMp6O32AVz0Bfzt8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788278960;
	b=KkJoNpwdV1xTY2Vo26fmaQeH+UmFVeMSEB4MJO46ZitZnt0DZxXbW/fIwedpVOqGZwa1mu
	Lf0BXYpOmOtQ1lolTU942MHlSNmrmaGEJn1C1aga1gqpEP8vQm9gvVGa4DyLpFUpTxG522
	PWwco8neXkzV+YVy1J+fZ1gxM7uVrOI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uskcNA54;
	spf=pass (imf18.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF2C5435D8;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9130C2BCFD;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788278956;
	bh=tGulbdEu3dRFWulYij37FRo+LIbl4tpCnnrPz5XH21w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uskcNA54RBdpVd3VvbmnwJbbOtPvcMgEFDpY+U8yPaqk6VL9D35lb95YcI7duvTl1
	 XrLvSmxZ4znTOKl85rwaB7ZCu766PJvjMm/2iUpUZzgZk4lE0cL6HVVSoOWlfyuIwH
	 8ox6RK4+ktlE+2el2EjE8p6SoauF+nh1V29Hg4QWE/qecJdf7IW+slxHFOKCrGOF/g
	 mNTzW7UNmTGOQLejvZoZ8VzUiD6lJhomXgBFdX44df4JJ1OOgk6lI55017I4Rnca03
	 sWCgTmVGtNSWZUl2Vl1Vehgsi/RqyyCU1B/9YjBPUGLJbuUmXkF6GtHX8fHiF0Wayi
	 o34vIcilV2igg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962C2C61DD3;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Wed, 02 Sep 2026 00:09:06 +0800
Subject: [PATCH 7/9] drm/tyr: refactor new_dummy_object to use new_object
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-tyr-ioctls-v1-7-e0fdbf8bd108@kylinos.cn>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
In-Reply-To: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
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
 Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 Ke Sun <sunke@kylinos.cn>, Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788278954; l=1139;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=Ej92qQwFTpPtrIg4SAbvIlKuALoNm6gS9q8GLNp1YDQ=;
 b=+rvDr8eIgCszYK0KN0VFmkfXWahqtsVwtgx8CXqR+iJjCYkPEJsiRv5hYWJIDWEiIAxxnCCeq
 Wc/8K2eTe6EDzkVKNm6yRvYo252RjG/JDEoeTp/q173HXGhHdq/SF6K
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 290511C0007
X-Stat-Signature: sewe4qeji836uti5ifyfhhbotjucbya5
X-HE-Tag: 1788278960-761822
X-HE-Meta: U2FsdGVkX19o1Ry1vyd4VZI/vDSahj2SKinoyuIZfFmE6WtR9bkmZXX1tVDw7ZpcymKOipaWwRMluhsgBS9qsYBwd4xRR/C9UPw36mRvUIv9dbRaWVzRdLz2q3L8FkN4wUpq+cy45mXX6uq88WRYx5E6Cd/57+ofHSkVhgdkkEcbrt2zIu37GQZeoXi4ElBuYjYmSd2S4lmuUQlmC6Ye2QZHUb4jpLvXb14Y06W/9/1ErlXopheso1O+aEqrymft2fJ2vAjYRu6KG8ef+a77l7O9HKFiPLEOVNHJom44Hth8k8nECcNAjmIg471sDtNjta2yN7xE93S6A2BSjCwbUxUzaVjZr9MsxJamlf4fGVHYtw3ANYkt68SLnyh/+4A7zgUJfKzaRwUfRxbThWx+O1AV7DFtTNjMVBtDiVJTk8+eIk0/529uVbrxh749+q+IJed/uwMsHAoJ3vZnxYB6VH50z8D6aHejQGDkZQj9jjXQlkyxlA7M6+++SWm3nYginVO3jHoBbxMntUZAU53V16Dp1rW1QL7/8Gl1n5dnBDcpwLx3nWtosS18/RLm/yMnzNgzIhbQaYAd25bBrbTDC4dW3pwtcO9cLNnpo9nfcmDesHSCUAEaTa0YwZKsmnW9vfh0QoS9A4rpHnpIKS5qolHFzYUby4DN4Ja6ulEeQA4jhwbkri4X6yVAeVBx/ZY3Yuos+I39Ymn3Rsjh/g8KFEqAcXMEfTTYhkh3BLOyz3znF9PugSbWftmkV6m3GhPsPnt3dGE09znqh65IoH3nm27KTzy1KDgo1BJQkjiBoAakXpXpO7XSnIiZgneT1kZnPjiy8R5BThwLfFbxoxQ9JW5LdKIkyubK8WVRyhKtnr7W2Rnsp9RgfnvB/P0FSoXfYsgELR7DkrakMwKE+EgyPsOr/3EyljKt38Q10SoFxmgGXnJ9XlYGdZqrny+QI02KK6NMKH6+P3X81GS9hVH
 ltPa2sHy
 mQaaKlJop60BgIAzdtUH7mW9Cl1Kg/yREuQgtil04dDE+LvlH2y/w0VjNwb62zZSFIg+ikxdsq05BQjyWR4b4WwMs46syPAqMNJMERVG4VuJrdj6F/i64mmFMYs6oS7VHv/qgRFIG5KKP/Y6i6htbqojqFJgjTTpSZ+mmEuHHgBOfKWSNyO2l1BOFHIAGToUdzUk7NxuBL0APFcip3VOnj+/z7eLQ4ologehegX9FW0CxTx5Q1XYS9P6b8j6ASwtU5KtkbsOllxeX5ecKqV8TWhJNmm6FrQcSqdMvT6ZvQt/tfXfo2q3jkI2Ju9Aa2QULkBIEDQGCjA6FbnI9R7xSWOQKSfLrqQD4f2IXFsw8kDduGaDBOQ0JEx07GxfusTZfJW2eR6e78cydjWF7Utix3VjoLwjYXYiF/MZby1VicAEDCU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

new_dummy_object() duplicated the BO creation code that new_object()
now provides; call new_object() instead.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/gem.rs | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
index be1affe80db1a..d9ddcb287f52b 100644
--- a/drivers/gpu/drm/tyr/gem.rs
+++ b/drivers/gpu/drm/tyr/gem.rs
@@ -82,17 +82,8 @@ pub(crate) fn lookup_handle(file: &TyrDrmFile, handle: u32) -> Result<ARef<Bo>>
 
 /// Creates a dummy GEM object to serve as the root of a GPUVM.
 pub(crate) fn new_dummy_object(ddev: &TyrDrmDevice) -> Result<ARef<Bo>> {
-    let bo = Bo::new(
-        ddev,
-        4096,
-        shmem::ObjectConfig {
-            map_wc: true,
-            parent_resv_obj: None,
-        },
-        BoCreateArgs { flags: 0 },
-    )?;
-
-    Ok(bo)
+    // FIXME: use a Rust resv-object abstraction once available, rather than a real BO.
+    new_object(ddev, 4096, 0)
 }
 
 /// Specifies how to choose a GPU virtual address for a [`KernelBo`].

-- 
2.43.0



