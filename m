Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8DECC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5F9E6B00C7; Tue, 30 Jun 2026 06:27:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FC26B00C9; Tue, 30 Jun 2026 06:27:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7C26B00C8; Tue, 30 Jun 2026 06:27:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 636EE6B00C6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:27:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D50B0140405
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:27:23 +0000 (UTC)
X-FDA: 84936201966.12.512A321
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 491EF1C0007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:27:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IKOtE0dF;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782815242;
	b=4xkk05v+nst8OOzud8YU04uPu3X8W5rYTCwDJ65vmJ2XWeLbcygo00zZmi09yf2rLvojmJ
	e43pthKUh4W7v8lbeich4knOaDpAXgokNnVpx6GIu4L4QxfWD4tTp1CfuA21quvIumF86T
	1hkzLiA3Si9FW4KgIi3plS+YIh8xMlQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782815242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8xS9p+I1JHNHCRV6gQmZLYib6gO7NPy57088Z5gPbE=;
	b=oKimEXj3O3vNpYbucDs9BIiLJ+LyAop706DgLNXmf9XEepWKgTA2TSRqmZov99PI8t64ho
	vLiavYdn8QRegWk+tJOcG7iH6c3nwqqxeYVcsP4f1TwVmNKVMlEtH9DF4QoRzMb2Jbpx0Q
	I39QQTKSpiMcknMmROnv8VzHzeIvElc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IKOtE0dF;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF445601C4;
	Tue, 30 Jun 2026 10:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2EF1F00A3E;
	Tue, 30 Jun 2026 10:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782815241;
	bh=b8xS9p+I1JHNHCRV6gQmZLYib6gO7NPy57088Z5gPbE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IKOtE0dFqcVWl+QfeWVg9zwJTxWZYLSm+0dPa3/CJFCn58V3Lhe02eHmmfrxVAAeY
	 uwsCse1E9otI041t7CCtDhBkpNo2Uw3HaaNZr/YLbz5677AV5C5muTUJWFPIlpqTDq
	 jIv9iQ8hvzDoltVep4XTSH0LRrasAmk4sv0IEb9bmFS5z+ybRG7Zs5ZVbyfDaneRtv
	 ZplSi6qFdm/apgQ2hXibe6iX/lTb3Dx8QJbsz2fJMOcv4saJYORUpIuKQHcjKRd7aj
	 +wva7G3YUzc5vr9YU4ZCseZmrfjcyoa46oRsCDIM5pPdSNVLKYi+DvNYJN61wPq018
	 nzauUMs1j+pTA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:27:09 +0300
Subject: [PATCH 2/2] usb: core: devices: use kmalloc() to allocate dump
 buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-usb-v1-2-8d547235c374@kernel.org>
References: <20260630-b4-usb-v1-0-8d547235c374@kernel.org>
In-Reply-To: <20260630-b4-usb-v1-0-8d547235c374@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Rapoport <rpppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-usb@vger.kernel.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Stat-Signature: ghuew5qzohu3sc54rxtrqmobcq8a7xw3
X-Rspamd-Queue-Id: 491EF1C0007
X-Rspamd-Server: rspam06
X-HE-Tag: 1782815242-26305
X-HE-Meta: U2FsdGVkX1/ya0Qt9+VMFnPQ1Esq13UDguk7xxK0EjLblp/Yy3ekWEYcmZHLqbWNXYiAnaX1x6wnHJcGBGzaU3nZbRFnKdV8Jn9CKpC1340RiMgwyb6tXpCky4BO0mnRdCXnsa4mW8zC3yO3sPNREeBD7fRdJthSZqQEp3ta9p1FJ62wDISht0oKOrKjrAUyeOaHIbfZugoRGHYtsKFQesx36SprlKbiXiuhmieCNzv4wI7ywn0z3HvEHuCeTA+Q3FXmKRFsYt9N90K25IWf7iLBYbA8k0qRLA1rFmHevKeS1fAhPAFwx1+IfXaC6aRyuZwc8AlIkLGS0khlbs9ly5sg+g4ogpCEU4/Lz09aVEQXrZDGCCuZJsAs70LVo38R4adNAS+hwZt6qzwMEGNEAFgpZTTXx8WbHAgYLTK5llXe+pxiH0nhj6uqENk8/QyMCTQLO+M6Ok+k7CkcoU0paDZMFdmhF5Xdcog0UUi0sJMVY4vL/BmEcAAOYNZRxXmKUqaDKbMCmz2aWkiNgw4qclVbit1YEJorLSPNVNi24ciZ+zY1BjGHoR7l+B1v36xpGTy81Pcrfxhv7aQRNwAfvJNFMPJyJBbwn5Vs9jKB8DrW7904u/NMFt0lEhJK2XHsbmfLzc/0PPJC6SEe2n13rpMvpfb47cQWWilYfrGgBmkmRJ513E/5HW4T/PGdlr6DqnSXpUrEcF6rzyNtQ6TbSpTqnC8hUy4xatkniG1BwpvKgBEhq+UkXSWr88iGhDcuLeDIFfbQrjNiGnBRCOtSMj9iX8GrmegKo5nli29sZ8f0T/uILglIaEu0fTCarjikQb79tF2XWtNC1b58y8uvkcEw9o8TBJCiv2AyAaHS8Lm2y84coRZO3mEAEJW7dfRCQG0zuNtlOiA4zSajia3mLIDUYedoHHXYpuN1MTuWNCtKuW8bIM/bsYz4IwCj/vyzLlqs305WxxK41pxW1Ft
 W4Qk46IW
 pf4nDEDDSRGkC8nZCU+E1kSGcmWBAfxOzNl64xLA1Q2pB6oeGK6g7W2x1tuumXJVscxqA/tgZO3CCa+jR8BsUFjLwI6APG9E3ZKQNkBGG4G+Lg6CMLRQ84bH1vy6Z2J/XCUw7pC32gd+qvyseeIPTv+cjsl8hrv5e9rRpOUvcscJukgQuxhbkqTMYI72hMP4h79Nhog38rSEp1JUiZBsxQeGezP3T8zikTrXdJMcejo8yXGGE7T6w1sSTx3qXcGa+sE0XdtrOnB1e8E0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

usb_device_dump() allocates a buffer for formatting
/proc/bus/usb/devices output text.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_pages() with kmalloc() and free_pages() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/usb/core/devices.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index a247da73f34d..6f0354aba38b 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -37,6 +37,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/gfp.h>
 #include <linux/usb.h>
@@ -408,7 +409,7 @@ static ssize_t usb_device_dump(char __user **buffer, size_t *nbytes,
 		return 0;
 	/* allocate 2^1 pages = 8K (on i386);
 	 * should be more than enough for one device */
-	pages_start = (char *)__get_free_pages(GFP_NOIO, 1);
+	pages_start = kmalloc(PAGE_SIZE << 1, GFP_NOIO);
 	if (!pages_start)
 		return -ENOMEM;
 
@@ -479,7 +480,7 @@ static ssize_t usb_device_dump(char __user **buffer, size_t *nbytes,
 		if (length > *nbytes)
 			length = *nbytes;
 		if (copy_to_user(*buffer, pages_start + *skip_bytes, length)) {
-			free_pages((unsigned long)pages_start, 1);
+			kfree(pages_start);
 			return -EFAULT;
 		}
 		*nbytes -= length;
@@ -490,7 +491,7 @@ static ssize_t usb_device_dump(char __user **buffer, size_t *nbytes,
 	} else
 		*skip_bytes -= length;
 
-	free_pages((unsigned long)pages_start, 1);
+	kfree(pages_start);
 
 	/* Now look at all of this device's children. */
 	usb_hub_for_each_child(usbdev, chix, childdev) {

-- 
2.53.0


