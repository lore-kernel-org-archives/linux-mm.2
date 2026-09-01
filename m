Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D80FFC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFDD76B0296; Tue,  1 Sep 2026 12:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84676B0298; Tue,  1 Sep 2026 12:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAFCA6B0296; Tue,  1 Sep 2026 12:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8E366B0292
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:09:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BA6840472
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:21 +0000 (UTC)
X-FDA: 85165678122.01.2B6F4C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 44CBB4000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PoHyfItD;
	spf=pass (imf01.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788278958;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7ACu2XJEsSZAAxqJVx917CopAXQKREsyP9AUqL+5KI=;
	b=AVZSQMIM9dKpPBOsaQNVJzOV3uPEJRj1HWKLY2pbrRjE85v8Yuc7957/sua357tT+MpeFt
	qimS7uS6NfqT8X+hT5pVcim8dp/QkvndKj/rE+eRgjqGx54+Y8m8nSLEGs3z/ktmulsXEN
	EnmeCMCOL2taeE6YS957MnkiVH8si/g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788278958;
	b=FAorn4uHjVTS4YDvmPxl/3eAxwatV8UK+O0XyWQbfa+QLOX2v7CGPvIehKvOJj5Mn+HEpl
	3uZNCwCwM3N01RHNyIByVJ7tBhCZl1HEq/TW7TyagcIZEvezonKaWCXGLHYx/zwgqf6BDj
	iT/1NrCcC5B6R6HEJVhqI+G7k/x12VY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PoHyfItD;
	spf=pass (imf01.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C89D660267;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62C3CC2BCFA;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788278956;
	bh=Wt41fk7XzYRzVaO2AD9iXe5dEZ1C2sk1KBdtD95Axko=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PoHyfItDv/cQMIf8jK0VhNkZYeFYGxny7MAWnM8rUzJjgoaRjj2fQtON9uWac2CBj
	 PWYHpv37no8yuoRQ1eLjxPlaYw6MYUtaKTBzoT/Ftq2Tx2JYCpnaXWaHO5RbUcyXHk
	 9tDk/aVmGdTf0kXSQ0xfh56ywP+yODcNuPWQ77Y3UXo0TM69gcA90JEKisNdG0PpYc
	 OgexZXVp+JLqfIWXY86cvSX6fEhGixJOnKCWa8uOpVlV4NH+JpIONdNDnZDOmgIJoz
	 UBmZlqPigqzooGA5gmlVY/Hq5TYh/ED2NIA1OKxG+EPFyUDxEYQ3CyoJZ0WRi9aiAH
	 Rcv1BWNqOSEoQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44897C624D5;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Wed, 02 Sep 2026 00:09:01 +0800
Subject: [PATCH 2/9] rust: mm: add `task_size` helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-tyr-ioctls-v1-2-e0fdbf8bd108@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788278954; l=891;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=qqWFYnkUdOvaxzK249OpGaOu6UGHYSzktFTqj4uM+pI=;
 b=oHWDNasF+q42cZjuP7Vyzw0DKfYfsrBz1qiLDguWG+DGqzqQ2c8I3XwHLkj5Nv7tFARXpDbIw
 aU+eSOJuPDQDe41AF9ZIFWnYyr5WukFdVIFMSsNJps+nQQeVcfZydmr
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 44CBB4000E
X-Stat-Signature: sdeigiyewtd3t94mqnmz3wkfztan3pan
X-HE-Tag: 1788278958-142141
X-HE-Meta: U2FsdGVkX19GgtuoWKgIKjw7TLAnmb9hPm015ARavMXsUuMMjkIzXGtA4nlx8etcoWo09Dq2CUN4mo5oCIuKJLs4w1rEBxNHDdS/nt8Ugcak3WhaRce9ViJGAgRvsWvZ9oyjV2tgA/Mp9avZzHmXPHjTKA2VkLmkOXczc0a0MhZjhFr3Xodsh/KH3NgPnF/Z1JBoYz21OcITl+3KHU0tq811DSdw04LYMu/eviXT33rLPgOck5kpU1E05JvNBD8AW49mw6Qq/ivZxdMyHgeX2o3ESKfD46l3T8sX+udSjJoCCHXm9Gbf35eahenyZpUoVOxX8w8ZQ5Vvkufubb9DkimZbu8zsE5cj9QK29qfi75qvXIsTjOZjp+ObDwH7AwLObqfiq2LmNYbhCj2SYsVxMn3ZvdK08mtMuvpPiEUICMZQUsILA+2ijpKYMsqwZzCMEWfwaVIlukLcHR8ZGPFkCEcFw6/RfJWj7UFjkP0fsAKyn9GF3oo8Yr93dV87+wCWZTwz0l3OMkyVEyJkQcTvr9Jpgk+GxmsubnqrDxmGKNm7ci9ZZQVzatkMQIMDA2GH21VproMcT8k2RqU/H3AAZHijyAIQ1pyw48jy1Gv+2mmJAY2iKTye36Tun0hFwXKOlikAkB9qg2be+UELf+O+zzJ1DTZjlMcF57JXlKccr77ovgkm7d/H+xbwYsuHDaPSPpXa4jtcp/tjFhabw9qkjuby4H5tfblr7RYImTHzJH7k5iIQk3Oy+3N8kuoe0QkXu/8PLmIH+93CsTl/Ors2Da64Y0Sm/Ptj1ohDSLHnSSx9r6zWr5LURRNT47uK9tSxrmQnILsHSWAIqDYapmiXoRrC3lfopyKfX9A7+d/5de7FNoto2XZstwAE9N+K/nsp97W6ynJI3T8k8V8k/e2BNO+Fv670eSad/5MYJSbjMHOEanxOFcQI7ztilhjD2D3wEGgp8QCQpcOeTV/RWs
 Wcpi9bEw
 bKVi1V+3uEQUEowWcVFIDpzG5YCNCd3XwiJPm3P8X/7sTbZlsywR6cRc7WoTfdasvBR/llDk/ACJd9WuDhFNh+8Ru0/NQiABTSFqKHOJMbWiXtKW0rhpbxJIITdRPwOIVmSNtjCtYe6/dNim2FRwc9Mnxi8EwDH2+xU4BDtYTZTQG3pPUlpzhv+cEO02JIXtjUNU3Uvek5JBkjU1v6kc2MgET3aQnM22fD2hxE8/opRkvsYckhJ6tfaF0bgIjDKlYYGw1iAmcg+JxKfQR5I901f65skscbmzUudXUw+nP27XF1l3DnjlVzMvzGpZ8+i5ur+Qg8ShalUqXiq9CaW+f9R2YZImdsnWVpAWGuj6mDmonqsEj7slx3nRu9/mmHZ55RA1QWQbHCcBItpduohEqHszS9YXoaAyjUXYFLR+SVD8D/u0=
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



