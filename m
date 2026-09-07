Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D9CBC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3BF6B009B; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692B26B0096; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5136B009F; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11EDC6B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9469EA3E84
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:18 +0000 (UTC)
X-FDA: 85187549076.28.D654CBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A48CB1A0009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rbt2fYEQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799696;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XH3G2A7GvTP/8THrs95qFRMJKqXgEWRG0Nu2DxafnUo=;
	b=5pB9ZNoMLh/d4HDi7lkGWPF4RzLWMwNU1uxHZ79RKqoCNPvFG6WUCBCdtUW9HEBwxrV2Pv
	FOPrNCD4/P7vdQtAG1AiUfdB31iG4wdCW555gqn+fHkWECcnFkDRgXnA3kIktEiPq83xuq
	mID5m3ke8kOJ3tFrcR1+lmIWIttOGUE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rbt2fYEQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799696;
	b=CcZgSKzflGt0OrmlFNrJFIknYSZBh8aqGhc7H+vzvyNbk1ibroQEzFCkTH7H7jm2xVli9J
	kV/nDZdgSlybuw66dqKr3YicyALb1nh451Wf4CsXU2oRheMu8+BJu2SuUuHvIeonEhtnO6
	ZwSaCn5MdwlQMoVY/7U9wizNFFccrLU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A5D8D43AE7;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80456C2BD00;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788799695;
	bh=tAJEHSAuTRx0EwppaN+WcZOoNCdsIpUxUwps4sDokJQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Rbt2fYEQSS4C6EkdvC1fCToikE3BnUr2KIjHVVagi9tu7Irden05SaZW0kRUBOYvQ
	 gbHhxXEwSG+UNMcnDcNzxFYCkhREKSXx9jgqjXeVbIK5RwtPT4kxwfw7XAsMed2c1W
	 bWzasx772rdyAZ4tFhzbdhIohLbvZ9qg1f3pmTq8TFjAoVwuiXj6NREZmsUnWElSwc
	 FlSrUHtUlMrBw3NxC4Oftm8StJ2mLAE0WKAKspm9LSOlRPS6rZd89SqxZi7338NBwR
	 CWbJt7CBn5LiprSZE2MG4PImhAVM3oj/6sEREzGKWL+9CUauAAAjtp0AFd0j56bWG2
	 yil5XWrUYSH/A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BF1C79FA7;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 08 Sep 2026 00:47:49 +0800
Subject: [PATCH v2 2/9] rust: mm: add `task_size` helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-tyr-ioctls-v2-2-88bea777df67@kylinos.cn>
References: <20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn>
In-Reply-To: <20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788799692; l=951;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=JO+2MVB8/0ZEX96oFL0eP1mAOKrIibNCaD5F9FcB8NY=;
 b=y55dyR98tdQkyQvRS1h0SbEjSI3cnaIDdg85SX7ZIaWbhXm+f+ZDU47osQZU2PcPwf9rjlhF1
 PmbRd8EcCmSC8RgKm7nNWPDYFWRTaPzPs62nL8aNDxU+XaJ2TT4eU/T
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A48CB1A0009
X-Stat-Signature: 8t5zn3xw579t9bj3hx3tza8dofa9shoa
X-Rspam-User: 
X-HE-Tag: 1788799696-235356
X-HE-Meta: U2FsdGVkX19XNzJodD8Pfa0dZ2WkMmCqWMd8zVeEgcUAeB5ruhqii8RNvlX4A7iwfvHUaTe53pynmiyJrUT/SabQ08OhNW4dlpQAE2vh8/QIKRqYzv0bAk9D0zOEH1alJ1hkdU7yBrWD9MpEnjfmGwBzcCXyeMjLSXRV8FSBU2rCjQ3eIBkPSylolK4VKvxo5wSF7uSy7rmfewTDyvLmJTk9tzkqVP6KKtkAZUHFjaQo+EitXWCXlkaA/fZAKjrNZoy1wyeK5JaRLzzZ0B9MKZ3ybJUhcQCEB6J3PqEBpFanLYUcMi/C7y71ied6Jwo1a/KPXlqx2HufVHkjo14K+zidKrFkRn6N4lT4WGbFqQ4t4M11FBVyqaQiYXNfkdqfwMY7XMO9xr8cWwI/WuZBVUmPZlT3lvcLdS41fyxz88JMNu+bS6U1pzGJ431NrlNPQMAVQ+SyhTWs6lZHg+FNQVNgFxaY5RK/9btMWKG0t71rFQmhgxMFMw5fVRzf2iWif8iemAPbscOK8Eu8rfyoUqd9oESVKrHjR9PpwHCXJw5f83janfDH1/U8Xoc7BT0Le3LibVfEKuuWaMag0p5YxgOunClyto8o86WgjAH6pqUQrs75HJLFf4C8klTybD/lz/vc+eRkeoT8563tdKFI4RAAZSIwE99urJkKMD2/dsplXnqlVg9NNEooFTRGruCdGhhhszgxQPddnR1sva/XDR4lzHzw6YITFJYOn9TxLtGaSZRhXXub5TlVpSqOjx3tHJPwd0YETXXLO4A3lLR17Q9xnzauQTRn7dBG+akND3ENqnDs3qgq7Kbtd2tXFopIBMPsE0gMMQTFivI8k8jsoVw80rSB0ko0o3UHO8vTMzW2ADoef+dVOiq3HSeW9I6rzvpqOTcpfv6W6MkzMmilhb0NEvdbSw27O/6OxShc68lpFSAqtpPmSrfVfqSRBk8HUVuT0Q77frVX1zPePk3
 3AsPaidt
 M2KJMFH8N90lT6BC0FoGnMADmuPSuyqTfvauqgx1+sEaEzitAyxWq8GpOzyh3ucMz/oJbbz6bCuRT2alfuIyb30TeubQCaEX5XvcxrLh/hWKZg7JnOOZNOQaQKYTdvjLORVc5EVzSSTPzfWVCP3r2Oi7FjMqQkUAax5vzLJg0xHn2HOIeDeRUGYLbq/WxO76p55jn8nTqz5Ap1R2y3wTvq73a1FBw+KHxooTmJ7DrEVLJlFqniww7xzVfxRJircUoLekCxsTIJV1ip45DnArI3JFBqJdWtFcbuiH7C92DNMO8q20O1flPCa1D+V6xNAlzf4kDxpb43dZrCmLNqEzrKF3Qn6WBwcZt71Pgu2cf4HKinRlz/GmksUkGBAQk7FVWM1gTse2jmEBrFIBPvq9CbxCkzv7DCrf9dG+3HTr3jBWmSQoR5vHRDiSn9aKWWS4OMqxrZa5TJJ+k1+bgvXenvh9CIvO2B3jtC+fNW940cuYKSnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

Expose the task's address space size. It is used by the Tyr driver
for splitting a VM's GPU address space into user and kernel regions.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
---
 rust/kernel/mm.rs | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
index 4764d7b68f2a7..d2dfbb7d43972 100644
--- a/rust/kernel/mm.rs
+++ b/rust/kernel/mm.rs
@@ -149,6 +149,13 @@ pub fn mmget_not_zero(&self) -> Option<ARef<MmWithUser>> {
             None
         }
     }
+
+    /// The size of the process virtual address space.
+    #[inline]
+    pub fn task_size(&self) -> usize {
+        // SAFETY: `self.as_raw()` is a valid pointer to an `mm_struct` per the type invariants.
+        unsafe { (*self.as_raw()).__bindgen_anon_1.task_size }
+    }
 }
 
 // These methods require `mm_users` to be non-zero.

-- 
2.43.0



