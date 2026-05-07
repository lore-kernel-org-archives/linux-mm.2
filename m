Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1691ACD37A7
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 23:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE9D6B00F1; Thu,  7 May 2026 19:33:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6966B6B00F3; Thu,  7 May 2026 19:33:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E416B00F5; Thu,  7 May 2026 19:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA346B00F1
	for <linux-mm@kvack.org>; Thu,  7 May 2026 19:33:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00CFE1A065B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:33:06 +0000 (UTC)
X-FDA: 84742226772.06.75CB633
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0575540005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:33:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=SlTS1dl0;
	spf=pass (imf12.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778196785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eikidck90nifjjcTLSu0Ily0Cr9WozMvVmtwFlS/XfE=;
	b=uLvWHoIHHhqpZhOvWQ1E9bgPwvqaHO2JR32O2pCB9BFAPmnLE9+Btt0UVfVy701k2SbVAs
	i0mDKZ0S87igfdluzE4MFjqtAWBtAoG5s0FGBTwJAtgQOyIQuN4MARiZ79Jtw+ht9jIU6B
	G3OQWsR/KBjhfm4WV3pGTj5XxVWogoE=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=SlTS1dl0;
	spf=pass (imf12.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778196785; a=rsa-sha256;
	cv=pass;
	b=H7XcaBSUMlkr9Q40zrruAPGtYkl6y/hvGl2rJK6SWzf4SuJT7lmHLGCQnsMrDacqBmegBj
	DM7JTx3t3Lo79xhY4L/IsCu0UOXrXzXSIvK08hgTCkfnoSXoZpktsSYFjy6nxu8k35bDrN
	o3V8nnckRBxh9x4LyAb/NGBTsZiZln4=
ARC-Seal: i=1; a=rsa-sha256; t=1778196771; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=HlwKowPEyLHd8XTqzn2Hra/vycEJm3d0epn4K8NOHKiAdnoMdKNvPSEF4IMj+dqpad7BeOxB3OSbfT4DEVgIoxNuw3C0e+VstWpMYiUzsEXPYuGiP1fWTxtX5FuUAVOomdNsynFuEJpjDZ+st2eBAoj6OY81SHMlV3Jkv0JuTN0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778196771; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Eikidck90nifjjcTLSu0Ily0Cr9WozMvVmtwFlS/XfE=; 
	b=NgIiyDRryLQjjXpGsy8XWIGG4d+uW1DlhVYwmYDbJKhTKrAgsQK5S5aWvdXZvFW1H1H2CIRVB/G2NqGlm8YEJNTN6oT3KrppejwLt/TWVTPeNLQZPd5jYgTYKDs3eWlBtLFMqOKLF82N44R2XQbaxkxcfP7LcD5h9very+ljirs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778196771;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=Eikidck90nifjjcTLSu0Ily0Cr9WozMvVmtwFlS/XfE=;
	b=SlTS1dl05j3VDQXRC0dQlJ3v3q8pddW2B0URrmT4bZa72U0lsJs8szbTm/VVsEzW
	0DkByIiOuO+a1Wlppa9N0KPx52vVVM1Ly0/gABMuBUcsOYjwGQUxJLyhNBCzrR3CkdA
	RC+RmBKx3W72DHZyHLVWG/OoS1jCYK3Zkg1IXk+s=
Received: by mx.zohomail.com with SMTPS id 1778196769009768.4916995530741;
	Thu, 7 May 2026 16:32:49 -0700 (PDT)
From: Deborah Brouwer <deborah.brouwer@collabora.com>
Date: Thu, 07 May 2026 16:32:43 -0700
Subject: [PATCH 5/7] drm/tyr: add USER register page definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-tyr-mmap-v1-5-eec048a23c25@collabora.com>
References: <20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com>
In-Reply-To: <20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Daniel Almeida <daniel.almeida@collabora.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 boris.brezillon@collabora.com, beata.michalska@arm.com, lyude@redhat.com, 
 acourbot@nvidia.com, work@onurozkan.dev, alvin.sun@linux.dev, 
 Laura Nao <laura.nao@collabora.com>, 
 Deborah Brouwer <deborah.brouwer@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1516;
 i=deborah.brouwer@collabora.com; h=from:subject:message-id;
 bh=scNdSVkRh8cTxN+OO32Yl1fQfHmpAP8i/Mt1ByfYJjw=;
 b=owGbwMvMwCVWuULzOU9c7WvG02pJDJl/FSXjfMxb9z/6d2NBs+UVUTklqaXL3uzsSPx0cdqc2
 d3zXgat7yhlYRDjYpAVU2Q5a2/UI1713kh3/v9mmDmsTCBDGLg4BWAiE+cw/Pc/Eu/an8fzc0qY
 uNJVsc+TNx4SfG7Mtf8tn4y7dN1F+TJGhkYJfV1RjVkvr1lZvjkwSzUh0Hu7ueedcDEjs6gPX5l
 cmAE=
X-Developer-Key: i=deborah.brouwer@collabora.com; a=openpgp;
 fpr=CD3F328C177AEF322D9FFF8379A829E70C5E7DEB
X-Stat-Signature: pnwsn66rfj5yykzac54dwx9keerfaoz1
X-Rspamd-Queue-Id: 0575540005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778196784-149934
X-HE-Meta: U2FsdGVkX1/+mNpK+TnOOZgHvkE0lQTCWg958SWeo1Jc9IPMG32uld2tCTVmw97uJdNAkJZktLBmR9g/Aqr264WOZoHu9wyCvg4PJPKzbsQipufaabmm6bnqi7OCuitdX+6i830DFoCd4XeqhWSZuzLIda2xGNUyIXVoQYLhQvgAlPrBYM8RV4lpO611iyxPNKExlop4HeK5SprnrG90QEPg6UFvtzBQtAdM6z16QRoYYCjq2yPO3U03OKFvVl0K9LDT+2pnGuZ1hOmlHQ6vkmd3JUbAbuZa94fKJewioa2CYUIqjee3LSLTdRoiTx4jpYoNAg691X0NzdU/AZyDOmhE8zcWWtoGSX6wt0XIBw5//7lLpwxRPHp8lvstrqM/5dYCpTZ6nIHz7uOADiix6dbdPj2bIX18vL5pc7Znh0k40PAOhK1ePa9In7zmnI5WgcKDLPs3kzgQlMIC+3AS0teGlACyxe5qauDIX4juJsHCT3CFcYSp2ljxmOG7YqhHZKCLVPUie4P/TTH8VARaQy0ufUNX4pdJBuBDLAqv88xGQeguhvHUZ9n7hMMtO1mnar+rvwPjVQ+ewv3fn5LUNwvh7WaVD2MCZXj1me10ZbPiA6sos+Ni99JMsRfaDoNR+No15DgbfOcs8R18bQnS3+qhvHgVlIGHlumUg+ttJVZLG1FY6QF+r1VzLMuCTEzLu5Lzk6fKJ7UerDZLzXlzH3ZvIs6EDIoSVbHWUgGLpvmVwgTJ1zTgsmDpmKRzRwWSszEz489hKYOB44dOfa79OTFw2U31fllqiBexdAJ6Qx4lre5s81QpSSdyLj0oHe/GAcxiivMdzc7tPb++Bl00GtbIvRK/eBf3bchYpPC/nO+ooqf6xkmUoHY8jgpYMtaOmXc8Luwzru6F+Yqq7Mo2xeK5nvI5FzxeW/1JdZm2hPl07h7SJH/c+1RLQ12Ra98zzwpca/7zvpKjOL9+TwK
 C2jch7Ec
 ZTCUUmdLwi0pjibLOlCQMIqHIxIsFKPwB6EjAgbJqd1p6+wGeCOxDngPsynNl9qsKOeUPTcI93qQsUXflYJi3jJ/QIPF1Cg8S6unMf7Y1aXzNH7OfKGMlA9UawjrbbbPsRJK81PYOht8P1gD+YiK6pMj4YQnUfTqDdqbdxllaKJ8uhY7Uli6ddN0/Bb7rYmPRXdb83Vc9HfoKkK9fsk/kvbrMdb5/P4OYHzRy0kYdvP7FozD50hwpZ6K6zdDTDuwQk4u+Kea+mr5kCOkHIgG2wp+7EB+Rb5YWHdIAOH5wTK9ZDyRtWUlxQu/q4416vhF3Pce/VNfkzFfWts8BQodfTZYVWIrvjhVn431MJyTzyMOnEfQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the USER register page definition and the LATEST_FLUSH register used
to track GPU cache flush completion.

The USER register page is read-only and user-accessible. Tyr will use
these definitions to support the Panthor userspace-MMIO mmap interface,
which exposes the flush tracking register directly to userspace.

Signed-off-by: Deborah Brouwer <deborah.brouwer@collabora.com>
---
 drivers/gpu/drm/tyr/regs.rs | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/tyr/regs.rs b/drivers/gpu/drm/tyr/regs.rs
index 562023e5df2f..98d5625f5bb1 100644
--- a/drivers/gpu/drm/tyr/regs.rs
+++ b/drivers/gpu/drm/tyr/regs.rs
@@ -1633,6 +1633,24 @@ fn from(sh: PtwShareability) -> Self {
     }
 }
 
+/// This register corresponds to the USER register page.
+///
+/// This register page is read-only and user-mode accessible.
+/// It exposes cache flush tracking to userspace.
+pub(crate) mod user {
+    use kernel::register;
+
+    register! {
+        /// Latest flush ID register. Read-only.
+        pub(crate) LATEST_FLUSH(u32) @ 0x10000 {
+            /// Incremented when a full GPU cache clean-and-invalidate completes.
+            23:0    flush_id;
+            /// Indicates that a cache flush operation is currently pending.
+            31:31   active => bool;
+        }
+    }
+}
+
 /// This module corresponds to the DOORBELL_BLOCK_n[0-63] register pages.
 pub(crate) mod doorbell_block {
     use kernel::register;

-- 
2.53.0


