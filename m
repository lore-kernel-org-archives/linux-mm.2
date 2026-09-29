Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4B4CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBEE66B009E; Mon, 28 Sep 2026 22:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6F906B009F; Mon, 28 Sep 2026 22:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC13D6B00A2; Mon, 28 Sep 2026 22:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 722A86B009F
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:16:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA7ED1403B9
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:15:59 +0000 (UTC)
X-FDA: 85265184438.14.ECB50BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E7FE520008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:15:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OUntmLjX;
	spf=pass (imf13.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790648158;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XH3G2A7GvTP/8THrs95qFRMJKqXgEWRG0Nu2DxafnUo=;
	b=NwtXF+jUi/SydyPgA/cq8PILwzmizZte/KSWyshCKO/Y1uMzjmNnisgAIZ9mdbuSpIC8d6
	+26jWMut91Nl8nMclnd+7x25wmKtoxY7uORYlEsfW4dUBLfUgHmTWEMmWAeVseX31+fH0T
	2tjhE3aTgGtWpRK1u6kxcndXiiBnre4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OUntmLjX;
	spf=pass (imf13.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790648158;
	b=tDCzkAJwDT1E9dxEyhIGkrJQlqUnKgXKk95pGfNzpZ3G9P59JB4LKat7n/9rqV1QRwuuH0
	iGN5vEHN/wliAh2HSrvKIRTlvBhdDyJbSx4eCGRlW7+bXRwlTiZHUOqZ8EyJy0aAcT/cb5
	SETl5wtbJUpwZq+iojsz03eHDz68Qik=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71C12440B8;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41C2EC2BCC7;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790648156;
	bh=tAJEHSAuTRx0EwppaN+WcZOoNCdsIpUxUwps4sDokJQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OUntmLjXkQkD5gqD/fAnaZhEjU35i3NdeD0MDKAt5qMfvjV8dgzKTn9oIERB2ri1w
	 T2TRxaOaxqM7EjMJ8UCcBzqirn2hhBT3nO9P54VKxxnMgFcXcU4NtHfEWmoGtvQuAc
	 kTgHXBPwIDkObGcAtgBPsOOEQiKyj65zPCEzAwNZF5fLbFzlH8D2y3SRnE1pSt2BGP
	 uYfWcF9ZwzcGo2B6z/ZfTg0VtJziwq4RIoQiS2MMLHGYfdWpscZ1AuB1KpKFaaCHX/
	 SpXlzsWg7KY5lJC6HpZFQ/aQh3tORGPFPAJi/cHpI5JYirQOGWwZL9e47Mwi5bhEo5
	 bQblDfhWr2YOw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2096DCA5FA1;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 29 Sep 2026 10:15:52 +0800
Subject: [PATCH v3 02/11] rust: mm: add `task_size` helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-tyr-ioctls-v3-2-26955fb111d5@kylinos.cn>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
In-Reply-To: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
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
 Simona Vetter <simona@ffwll.ch>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 driver-core@lists.linux.dev, Ke Sun <sunke@kylinos.cn>, 
 Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790648153; l=951;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=JO+2MVB8/0ZEX96oFL0eP1mAOKrIibNCaD5F9FcB8NY=;
 b=4hJQWHlONdWWEYIBfTzQKm2FojtHl4B5GKRGXQ2cctUARsgYvoM5Bxw0nyFeRQMcltOUvr9di
 VOrWnAmOxmNBqTQMrnCvfAvmWk2XdvzQ4gQZIJzQ/NQjBo78LbPkID2
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E7FE520008
X-Rspam-User: 
X-Stat-Signature: ebwps1sxxiungr7o19prbfksd3znjj5b
X-HE-Tag: 1790648157-553684
X-HE-Meta: U2FsdGVkX18Xy7LJEjwihKKh8JXH6TCue+7tIQGtjfal1OIT4Zm7KshACHrLm0JCdkGiWpGGQ1Um1AEyQvQPTKsFaRQdS7RcXvR9ncPaXeR2y8L2js/mRHPCsBM6Cbxhol1Jht6TXoV+Zwh0zZCwmI9sokMmAVGbSlPzYHXqippNQ7BIltaQC4VUTPapwitjVRORdwR0zwCTdbvcz+zGggFvyA+HULoLZpYWIVXCYNVThX8iN665FTZG7NAL1hHy1tOuc39Xv+1rQfTOW1+ShP/0CIEhoOHXONKlpQg6XRRyBesdpaFRdRsuN92Ig2+8iueKy39Lw8Tu59QHxo35UjZ44DWZJtRxYCqjCFHonVsGkTGiByPMl3mWs/yOMAuoSnbf9rZiFCbLo8FzqK7f/QqysDpR3v+CYtmehsJ+b0ZXaWWc6DhXyv9QgmJ7l/bnN9I4IBoVB5nonsTmDMkuAZyrNI2VqfA5R7HjSrytGhHhNJaOTmn55VLDOQrSMESXxv+WLDIaq+SgRJZL27ZyysQ88O/Wvi0b7xmFZhqfKubFpjemOj3qJ4WOeKFFyCqDKMwq1mWiTs6rmDy2N04x+5wvtHBxu+lnDhCHwKkE3vKEy+75Mj8o1bjDpkxFCtnvWYE0MdOrQh+0LYHprJexRsBioIgq1uscCPDFj5rsn2bjkMeoKLpPqw0Vh6yLMC9u8LWyGgbDOjGE1to8ZpBMrWcptDPZLvmJ+77bs/g/vJ8iSHR90kEO3NSXh6vLdIE9L8F0ZQUFAvHzrS8zHhih/a+wq0ZH6XMIZMpC2w7xi01fES+qYgNCGUKAU5S90Jc6rxdswghZbsjDJeN1N/LKU50o5jrErM7E2HDyTsw0sKWUs0etNUp9Ae4Rk1iLjbMgyJ4LNR/GPnvT7NpwPiq+1+EkBubHFyS7pilRC97Pn6AZqetqXXgHHftZl0poKWdMwwV7k+OX9g15gCfybzC
 tVBQOhqg
 6RoNCi2im/x4sPE6umO6BdF+MtT2fTwY7CQ2RqVfm1jXKr14H60z9ZBYVytfM/VUOEUQqTkHkgVJTehnbgKFEEPqmmlHJvXpI7GnZxWx6XqCzDoYMnbOOvBWkjuz239tejgPkiWcOfhagnhkUr561FXwYujoibyPj0fL05zDeAf+Nr+B+mO0oCsDTpHjS2P7a2wYkghZgr9B/cujw3H7VjwvzWobmcPmMFo/Bm3EdCo/y7q+aUeFty6a7G/ASkwgQSaOeWIz7sUDTQREwexnGemQpVzcyUEJeN2NP59CzpB7OhL1GNPRFoU9gq7juhOG3gSXubRLLuNAOR5fSVOwxRKLxAD/SJ97piAGnLPoXHnX6hei9fsatdFGeQoOIzGjRgHg1bwyOLLTgFy5n6VpgXPQp0NKs/P0BmCd6LXtFbikT6VMYecnk1SKFN5V/QT/lk0N2LnnM2xeFoRh2oyhMPvCvHIuSqmMttehEP2g2YgCrOWA=
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



