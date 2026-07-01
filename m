Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A7EC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B9396B00AC; Wed,  1 Jul 2026 05:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 242386B00AD; Wed,  1 Jul 2026 05:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E32E6B00AE; Wed,  1 Jul 2026 05:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFE526B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:42:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 650851C1F49
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:42:06 +0000 (UTC)
X-FDA: 84939716652.03.719E9DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BFE9018000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:42:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OIHblCl3;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782898924;
	b=KDs3cP8sYHU3FDo2DqZxzdVFfnXpGGN4Zj3cQVyBCb8vyD13ctQFcZmyd7btnQULtWvveR
	5llZAs8QJEhc13w/NCNvhDSoX4JfWDsM2Ekqpyvri5PgjIY09sxL+cLosNu6ZzBjlQ75kr
	h/n4/KpZgAUH/1isIFjJ4u1epevf+AQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782898924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oofkD0xPKEf9vCnFp/Y6xC9zUcU++9G9r0ci+L1ELF4=;
	b=N/bmw4teVQ+GijehoSGeKI3/KBB15m/HSeQhwnEypasgFJmntWZLB2Lu1CNkXBhD6z0hqu
	dCMu8B6uMCvYlLdLf/r846sux12iiqbRKYPf2xtVRe101ANhN/OHqTUPGTZSw8CyFz5JVH
	NhPh32ceCqrfPi7DANZvtzHgGZN1LcM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OIHblCl3;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B57643DE6;
	Wed,  1 Jul 2026 09:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E68A1F00A3F;
	Wed,  1 Jul 2026 09:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782898923;
	bh=oofkD0xPKEf9vCnFp/Y6xC9zUcU++9G9r0ci+L1ELF4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OIHblCl3HCNczmG+b75ItOq2+mwAyrrJ/gm+hyonolZEUllMNHcUWun1Fn9vBt1Oa
	 bvuhMy8BdS1+TAayGPVntvd8agcnyqcL5HehCJporv52MjaB0B/Bj80+Cx6JMzFy4N
	 d+3YuFXiLEcKsZiJaq2OtbwdGF58sgXZaz1jr1Kmdg8Ez+hrAmtiSvYs1oGadrYmcE
	 PbjHkp3H+F/NKzRhMVMVudHJFu0bxrwsi9kviFxNJbo5J9vFbOTXV4amxQE7+xzjEi
	 st+I3icZd8s+DnofgG136KZ07LueNOA9GLc46GsUtWmaSZHqUGFejrn1aOjzFXuOem
	 we3wjumT1HMfA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 01 Jul 2026 12:41:51 +0300
Subject: [PATCH v2 2/2] usb: core: devices: use kmalloc() to allocate dump
 buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-b4-usb-v2-2-272807df4b64@kernel.org>
References: <20260701-b4-usb-v2-0-272807df4b64@kernel.org>
In-Reply-To: <20260701-b4-usb-v2-0-272807df4b64@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Rapoport <rpppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-usb@vger.kernel.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Stat-Signature: 7ubri6bcyrdwokxq45fxo4jrgg37srga
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BFE9018000A
X-HE-Tag: 1782898924-339661
X-HE-Meta: U2FsdGVkX1/635AbSNWeMQQc/gjEiMPuFYVrqu190yMB5AC//98XdLMOoh1sT/pnzK6wL2oon2YSerKSzLw9N9RmFaqtx9ISZ0ebSLX21FMXW0iWn7O3geNiRRWuCe388yBDKXhtBfX1i/GoTzsnlxtLNVXkR+LnEyy3i0uasJpcRHYLhxm9IuUIEAebalffrY8Sd/eOov0pyc1y/uk4LNCGjprd30B0rBijCmMrQoGF68sKJck4XD4I6NMrhuITesgg6Jy6mOTmBXsSJzkEA5wSDMStyD/7srnQFRs7v4lU3PU7tBS0Qm4y3PawsRnnejs+jyw2CZZrc48684PiFk9PwyrRxKTkxd2K3X/17WUjvGt/Lv+tzcTXbn8tkHJyATR4TqTUmRUyFtefUsAv4JwriRUHeI4rX7lO6E9qW6DeBSwIQ92yGMMyHlglkrur/kBdv4k/TbafMYFkxuDD1rTt8W15htAm/4ALyP+tOOSGXuW9dF+Ccs5VM3XvqrE4+hYFbSBTVxNtHvY0Q1vWprzMahLjVRzoz0x+tyUgKE/GmbRZM1HlwmhEL8+WqMkPG217GzkvAobPnti4cjF1f4M+xAFxq2imjCo6ZiWkgvszm/VnxIijHLZovIwKhnMDMxUBNt/VN/cBhdwIuL+O+UMjctFnmxJtkoy+guYAvk7lZwxjpSp5yewxOrVAOsuKfoFv2oYSpmFlflnVaZ58mw5P78k3af5EyNWT1GpVxZwnFoo5FmDf+MDIfHdEQ26t5AFpMGE5G/vA2HeWW7/qrkvwLcF3JZt0HaoKjIuUaEAbf9xFVeaWP8/DPU91NqRGJuUrkLmpkQQKnKA3KH5K9hYOakAHXj6hrf6sY6a1ZkukWaaitBwORm9X7GsuMVxsBL876NAcZZRTe0/2QNMPerpX36XnhUmXq64c4qulDNxkhMpSF2l06VQ688GhQ53mUiSgrKg8KyLC5NjIxXn
 X8/kKyAu
 vog+ZqDKEI5qYLXrHDFO3ivBftXiKq9wfxYwNCkjmaLcS/AdsPdhxsGLlJ1myJA6lfs0GjkBbyt9Gy9dQfDrDsB6JjWq8IFHFI850Dn+qS5PJ8bAGdbQhbJaeRBGEchKwykzbRfw3x7Xm2Lkw35qR52XXC24miaFWJ60xHJzUfrQSRrJCK7fJqucViRcU8yXzStZ6AO1TFXBLpvDmbl2jNgILgwPMhUdJSUWXH4/4JosqM0W09w5n0kWDM7NJd3hRPXOdFrFxwo4O+bdLVqb4dSyjjNTr9ujVImFes882OdaroSv7Mw/Hf8WFb6KrI8q01D2HL4yEWb/4JBJSVfAb8uIYSZbtSbUcJezYPjrTcnLl7+gzkVRoKBm8x9kjYZHH7x6q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

usb_device_dump() allocates a buffer for formatting
/sys/kernel/debug/usb/devices output text.

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
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
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


