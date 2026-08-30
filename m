Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA3AC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22736B00A0; Sun, 30 Aug 2026 03:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA426B00A1; Sun, 30 Aug 2026 03:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0FB56B00A2; Sun, 30 Aug 2026 03:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95D186B00A0
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:48:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21058A3A29
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:23 +0000 (UTC)
X-FDA: 85157158086.02.CBFE5BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 86ED720003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j4ktx4jy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788076101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPiSY9Bg2IUmtzWz3D0CJ/RjIxKOrrK01Vto+HJVySQ=;
	b=0eUJlvTuQQ5FKKcep3RkxIoOU8gp5Bjnu2qiYSMmQKvZTVNDqWA8ReTjD2q7olNTRIeUmH
	wH8tbAd2KGADpcDxslM3/4LRmLNLIOGkzLzc5fnJY/lqDSnnZ06ErhrU9L0vGAMZ/CiIDc
	leQlg8NKXzoJX/xx5S36EzszWKAXBG0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j4ktx4jy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788076101;
	b=SSI9egYD2mIhsTDY2BUdfJf6ECk2zSdbd4YA1jZch04T5wKOww9T3RgmyjYZ1TgmgRcPgk
	giHRHVRVR6MbHvjp5Prt8JShSbbGQnr3KSG9Pg0QChO+iIgy1tBbTAFFXzT83orq3aNxJC
	Zl4gywTDO8ZqtS1mQlkrbKGc2qdUxow=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18CFD600AE;
	Sun, 30 Aug 2026 07:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE301F000E9;
	Sun, 30 Aug 2026 07:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788076100;
	bh=XPiSY9Bg2IUmtzWz3D0CJ/RjIxKOrrK01Vto+HJVySQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=j4ktx4jyXz/KrmL0BMXIAcnNMVGRcpncozoVazBsVEq0DQ1QMoznmPt00il0SqMro
	 arr9cHkcyoymqcJ7BKnbvNLt/5eB9ELfo9e1chMcnXFryp65iza5Vr36r/p7nGHSUd
	 E1W/jtNNZ/nDz3QsyrEGQkBzP3ex3xlnQeNx4MoAQ+bVpj1m+WnjY8aeTQ4VwF705C
	 b/zq9GLiTWwMg+cW5bKsBjq409aTTR2X0/KHXY2j/rMvJ1g9dKJbnJtfzGB1f+77c2
	 PMBlzPeOA/s/3CQAtDVgX9FJpYyLHYQqzq5DVfe2ALOw7yBY7XaFnzqkmYro7l04Gv
	 kWPhAqASy764g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 30 Aug 2026 10:48:01 +0300
Subject: [PATCH 4/4] platform: goldfish: pipe: replace __get_free_page()
 with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-char-misc-v1-4-05e2ce44f291@kernel.org>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
In-Reply-To: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>, 
 Eli Billauer <eli.billauer@gmail.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 86ED720003
X-Stat-Signature: wjpymug8drcmoi4py6tz35jnesryquom
X-Rspam-User: 
X-HE-Tag: 1788076101-477740
X-HE-Meta: U2FsdGVkX1+wnkfqFwPe5s3PH7npWwj9VbrvtyChKYukwtwb+Mx4WvWiFtcayiOH2nmhH2MTzsnypNhbY/RFiZ8hYucwXhGqAn++fTl/O6tIM/yzzqZ2YQGd4uvW4yPxCClS1e5N/EkKLhPNWKXx/Yqkdd21NjxsHG1FL5+Y2aYmn967dwe5V4CFdfjijWcm68+Vj5KyKr1lSTzXAcU71WWYiGb3QR4Di62e0YRKbWNmBVBmR8HzuIEcGfuvuQuO752Va/yUG0jnTqFIDYOt5GYYVWNP+gV85eYza6IKY32/GL8/r+g+MGRSQ6bCLXW6bhGc+fULpurYM84g79DDe6lAW1FBFRJHlYnfArDFjm6DyGde1sENK8m5a3C2Kb4844FfLz4PXVlKGliSTlejr/01mioJA+SGcnV33HMFR3pGOB7HI8t7HISpWe03Bbg/p9yjokjGHQv8fDdhLjypt7LijOM6p599mTKjCWHTL9jnLf3p5RBZUhFidwDSq/7814MSZHi/sz6LACxOsQnl0gyKcG6zbWOfKUsfklrocuPnBq2DDSZ1Ltz47AtzPLpAvZvXzjpcoZxOUPcmmCG5bgyv1BNRraFfGTqKPyGUH9hCsJPDZ0Q9zjgLuOv/dZNH4EcQyQGxN01FVam/ehA8SRhP1ngvBpn+y0KtdNa85pmUwWOnpLY6kDRtWZV3cEAsp6gAU2MWdmfKFflI1bEiuvEG1NJaAeoPGg4ywtkgGQ8NRBFzEIy9HD5dSjIb3A7GRR/dQNHmJY0hgq59WpG76TcA8dwnA3aS9qwfZ4it+l7x+1rFYm2YuING9rg+3dlfFgLycF126Mx88KSofQup8dW2/mWXgxZSTE0pkS/picoLEBY0tlwom7q5Dvl0KCMjPBrNCIAki2Cf9dLqGE3JfH+5JJuc7g6WmH/6thqzbKwlctQYgpfCCijp8wfooBHZUXp5eFxTJmBXAZbQchq
 i08lM6zM
 +BNKunHkXVYU6FNk2JZ0iKglWBgkUMa9eG47Abl+VxyKUzDcP01Rpmi25jbQz9KMD6D3UwMfPCnC03j5WCCnPHxPXC4c3k7kA728+mOVt9KB5/kFv+5N5x009AzfZ67Qnd4aVmtufKYn9tbcuuBvlY9n0MYiJrsSXv13mTCPWEohFvbeSRO/uhCvm//HbAS40UHWYXcr7VCDvC1PyiSWSI1fTLT/iRUZZPX7eVCsd9S+92KwLIk/ByidyE+L00091LixiJ+Mvk0PmIPLve9AW3KEx3uTkmWrBtZZoVuseRUMEv0pqMGm71NWziyrd4pKcMYvH9pEKUtG40nxNScmL9PIoI3g8ZY/RJgkx1hWmHwoYIGd+5VZVQkoFixsnaQSoJaTx1pBA3x1+cFM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

goldfish_pipe_open() allocates the per-pipe command buffer and
goldfish_pipe_device_init() allocates the buffers the device shares with
the host. Both are passed to the host as physical addresses and must be
physically contiguous, which kmalloc() guarantees.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

While on it, size both allocations after the structures they hold instead
of always taking a full page.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/platform/goldfish/goldfish_pipe.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
index fa241ca8feb0..3f34db896ece 100644
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -708,12 +708,11 @@ static int goldfish_pipe_open(struct inode *inode, struct file *file)
 	init_waitqueue_head(&pipe->wake_queue);
 
 	/*
-	 * Command buffer needs to be allocated on its own page to make sure
-	 * it is physically contiguous in host's address space.
+	 * The command buffer is passed to the host as a physical address, so
+	 * it must be physically contiguous, which kmalloc() guarantees.
 	 */
 	BUILD_BUG_ON(sizeof(struct goldfish_pipe_command) > PAGE_SIZE);
-	pipe->command_buffer =
-		(struct goldfish_pipe_command *)__get_free_page(GFP_KERNEL);
+	pipe->command_buffer = kmalloc_obj(*pipe->command_buffer);
 	if (!pipe->command_buffer) {
 		status = -ENOMEM;
 		goto err_pipe;
@@ -749,7 +748,7 @@ static int goldfish_pipe_open(struct inode *inode, struct file *file)
 	dev->pipes[id] = NULL;
 err_id_locked:
 	spin_unlock_irqrestore(&dev->lock, flags);
-	free_page((unsigned long)pipe->command_buffer);
+	kfree(pipe->command_buffer);
 err_pipe:
 	kfree(pipe);
 	return status;
@@ -770,7 +769,7 @@ static int goldfish_pipe_release(struct inode *inode, struct file *filp)
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	filp->private_data = NULL;
-	free_page((unsigned long)pipe->command_buffer);
+	kfree(pipe->command_buffer);
 	kfree(pipe);
 	return 0;
 }
@@ -833,13 +832,12 @@ static int goldfish_pipe_device_init(struct platform_device *pdev,
 
 	/*
 	 * We're going to pass two buffers, open_command_params and
-	 * signalled_pipe_buffers, to the host. This means each of those buffers
-	 * needs to be contained in a single physical page. The easiest choice
-	 * is to just allocate a page and place the buffers in it.
+	 * signalled_pipe_buffers, to the host as physical addresses. This means
+	 * each of those buffers needs to be physically contiguous, which
+	 * kmalloc() guarantees.
 	 */
 	BUILD_BUG_ON(sizeof(struct goldfish_pipe_dev_buffers) > PAGE_SIZE);
-	dev->buffers = (struct goldfish_pipe_dev_buffers *)
-		__get_free_page(GFP_KERNEL);
+	dev->buffers = kmalloc_obj(*dev->buffers);
 	if (!dev->buffers) {
 		kfree(dev->pipes);
 		misc_deregister(&dev->miscdev);
@@ -867,7 +865,7 @@ static void goldfish_pipe_device_deinit(struct platform_device *pdev,
 {
 	misc_deregister(&dev->miscdev);
 	kfree(dev->pipes);
-	free_page((unsigned long)dev->buffers);
+	kfree(dev->buffers);
 }
 
 static int goldfish_pipe_probe(struct platform_device *pdev)

-- 
2.53.0


