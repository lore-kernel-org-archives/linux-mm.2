Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5DF4CD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 19:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2C16B0088; Wed, 17 Jun 2026 15:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8CE76B008C; Wed, 17 Jun 2026 15:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953FF6B0092; Wed, 17 Jun 2026 15:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BB016B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:41:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF366166533
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 19:41:08 +0000 (UTC)
X-FDA: 84890423016.06.94B89CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 25B2720011
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 19:41:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWDvejAF;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781725267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SOS1yGkhDPya+/uAhiZ1+Rq+6pspSgmQL30KoFCQaE4=;
	b=USY3wQ2mphA+WoC8n90xheOw2fuoLyellEkT1yvAaVifx3dj4d0+NQtvhwkIwxo/TOIlrd
	JOK40oQD5WDa34Ct6XSppXP3ja80aZS6hEFgWkpUDaE6JEm8FauRAK6HhEGuuZDbx0dNPo
	iPFxynwFgkUnlz34giL+87KDoM2zobI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781725267;
	b=x9dx013dH1FdQfAzkgqfJFaTtZueO0JNKzHLKafszIEd9WMwkyZJyijEJf7yArtBRiKVjb
	UxOacLVso5Bf5+0Di2NyGTkdeYzxEgG3dVjSvChWhuikHwjeayszi+PFwERP1u/ZZVCL5O
	Y0fBqe2XFH4SoXTzoJ2IDkI0YEe/IFk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWDvejAF;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B4816001D;
	Wed, 17 Jun 2026 19:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA611F000E9;
	Wed, 17 Jun 2026 19:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781725266;
	bh=SOS1yGkhDPya+/uAhiZ1+Rq+6pspSgmQL30KoFCQaE4=;
	h=From:To:Cc:Subject:Date;
	b=gWDvejAFGLUPpouhULsa6FkMZlkYa1bbkiKWcOYyc6h8izFiTlHGQdTDxmdzm7Av6
	 6FVUbO3pIohmkRkC3dW+mxqY6hY5i0HYWosv43Bdh6bQx/0O8W9aEJir4BPzJ7nRW+
	 IKxlIkkG5tBeN6ghY8lO0i0Pn8ZnESPASKjFV0Tfrvx5V6bFxOuu+dY+d3olggfwNT
	 a8Ukf+1UizEgbleF2FM7sVEu2QSSP5Cpws5MK2IYnhiO0azQ5Ao4zFECcrblB1SO7f
	 7NwIhJHk1LxugF7QS4kxIFPtZDvY6tftOGGZ4SrlSnBBabqHbZNpcJxpCwSuUjm7+K
	 Wlxfi4YwIPNQQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	vova tokarev <vladimirelitokarev@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH] userfaultfd: prevent registration of special VMAs
Date: Wed, 17 Jun 2026 22:40:59 +0300
Message-ID: <20260617194059.2529406-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 25B2720011
X-Rspam-User: 
X-Stat-Signature: wp1fu9hp17e5nke9osg7hmokiuqpx8tt
X-Rspamd-Server: rspam08
X-HE-Tag: 1781725267-469674
X-HE-Meta: U2FsdGVkX18VqBF0qvik3/G8wXPJWzmcG8tBx1ZOXkbdEyW/mWhsp39nbkTZHqDSDBYdhrIWiKfpqP/kohH9EnZ6TyjRBFFHh2jMaW/UekfWNh43o4NYls3CJUwR3YR3Ps9KHKHPzkIc++Jd2+x1rn4JSFSKqLnFtMaTTGzJ7fSsjDKLZiHC4XaVs1NumXdGJ6kXcZydhG0Snm8LjmG9ybbQ3W2xiqnqtMALL+Ota9RMHKTihpuxUjV/4IP6cgrZm9n4CXnP2CDzbKJ/DbgDXz3txCmFS19wV6F5tinu4V5QwsgYBhyt6weDW3TV8FlQrL1CnPQuxDdzXwfnRuvUBtbl/jJ7gRsHACuUNUtduzvn6dDQP6efBG/7eCnyLuiGDvnJkJK569vnK5yZJLBTfHdsnA4KkzDcJS9VsZq20g89UEINHnPveHGyr4t3BcQMDYgEI4dLghifPlf0dKwGGGXucJ6OpGXzofyVw0Qqu1/cNWYgGO5QySE9ZLYKOlVVvP0A4cob7VVHIk0c3ntWaXDod7bbZUqFv5PfarvByUPrwgH6HHbipI4tYu5UrH4J/7jXUIPcJlCvvfcNez2RxnnQiJkUBiWxTZ/b1Jg06BIKUbo82f7GLlKnIPnXYAdcc09xf7RycQbrq0PFsZfVTNEY+JNNC5ddiaHnsY5A/1mVkiZ2cNa+GXv9o1k0DWgXkXWcXmE4OTEUKIv+xjm3fcus/yJPezCpQ4J+1zyXw/HP5zQQRq56heAvoD2sRqg8d69CXz9j5oVQ9Mp5oG4FRVNtpaInVNXAz1mSn24a8Cp/HHYXZVgK+POrru80tSQDV9Z4NodjL8nyqBjnNAIp496HDC6ohCkm3pFG9IEQAFS08KlAw3XDSU4mbyCWt+wZw5K2k8zJvCOlAyKZfTcfkaau/1BxJmW04hcytAOshT8uFnMMxfJprD374zhzZURnAyatm44PcpIXEzj/lK6
 1kQrtB0/
 J+AUmOHzdpgLDAaLe5euffMIJRFYbgDB9NLRCk9ZmFHeEbnC3eQ+lDgu0CkZFNbaNxj6AraCEwLt+AiKawxDh4AX2T9kPuZJwq8QH/jdxSl/4ekhVi+d16Dx+jAn2JJiS7F7z2KhidjGM5WoP8k/T+kDckiwdV0XAWAAs+PnaPL0t51FhQczh0GAIipUkDdKYWGKAeOl5ROq0FZ9sS3m1NyzVuxn/oKwTSIl/bjdqdNkf3MaedjMgURFtFFGRAlFacQWy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Vova Tokarev says:

  userfaultfd allows registration on shadow stack VMAs.  With userfaultfd
  access, you can register on the shadow stack, discard a page ... and
  inject a page with chosen return addresses via UFFDIO_COPY.

Update vma_can_userfault() to reject VM_SHADOW_STACK.

While on it, also reject VM_IO, VM_MIXEDMAP and VM_PFNMAP so that if a
driver would implement vm_uffd_ops, it wouldn't be possible to register
special VMAs with userfaultfd.

Reported-by: vova tokarev <vladimirelitokarev@gmail.com>
Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 246af12bf801..b8d2d87ce8d7 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2111,7 +2111,8 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & VM_DROPPABLE)
+	if (vma->vm_flags & (VM_DROPPABLE | VM_IO | VM_MIXEDMAP | VM_PFNMAP |
+			     VM_SHADOW_STACK))
 		return false;
 
 	vm_flags &= __VM_UFFD_FLAGS;

base-commit: e3d8707358ea76b78bdec9928937bb9a797f2c8f
-- 
2.53.0


