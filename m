Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1780FCD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814B06B0088; Wed, 20 May 2026 04:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4FC6B008A; Wed, 20 May 2026 04:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703186B008C; Wed, 20 May 2026 04:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB436B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:18:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 226C8140125
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:18:17 +0000 (UTC)
X-FDA: 84787095834.26.A377AC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7428B1A0002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:18:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KRc9V5gz;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779265095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVhmFVQ+VeHD9Mhthtt+R9jKuKGcX+eKn8UdrkQekrc=;
	b=CWwKDeO4rL8r+O0Uml2jthzxW1FRHraU6JybTWhkAmqWGFcP8MOyp06+DlDGTof68RG/pK
	rdy7l0mBZn0FbTWrWtaeDKUrNmLKJGHAGE/xG4+8H9GDD+qv4zv8PyYaWDdy0iwZ4ZUb3+
	DJSTIc+c0SiXmEPho69T9x69vPC2fs0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779265095; a=rsa-sha256;
	cv=none;
	b=dwN9rWutW1hVdFEXyow06fXRDb0e1vcXoozP9DHJ2kFbt85+bK8jugoGhINcubfVOOh/7P
	Hi7iLjXOiOwcfo6WolgNuHtrUkw1jp0nZfuHiwQhvsMqQ+FmsUafcubSV/AAE6y28EZqVG
	YLUzUSUAJdMAoUuXLFShFARRz4fmXnY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KRc9V5gz;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE191600CB;
	Wed, 20 May 2026 08:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED581F00893;
	Wed, 20 May 2026 08:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779265094;
	bh=KVhmFVQ+VeHD9Mhthtt+R9jKuKGcX+eKn8UdrkQekrc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KRc9V5gz/4zLGhneV/L9/0Nr5pQftNbWvQkuDBDfuA2LLPSvFpQw4iWEtoztFwy1d
	 2sKHRVQac9oRTWv4nvlW04KT+PZfiRPOV5P9oM6Gr8H2X1p5lkeIk3bTIFy/RVsiIe
	 G3ri27Up+eJss9Amuy1kxaYpQgSV79+o+cTEvcjA//XjBkhAGb+aWjGUiqdHRHorc9
	 t0K9NG6z8R9K2ul2z3FffIdW9pc+6W5v5zp15X+vP9A2BSMbbIR3oS6mJFDJuJJxF7
	 4eEWge2JAk0jW5paGlKp1P6agXlyt0LTgy0zh1eBcSRHB3R4sSRqjn+wWzCOPDImb3
	 fx/igN9m/KCLg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 20 May 2026 11:17:51 +0300
Subject: [PATCH 1/2] lib/raid: use kmalloc() in calibrate_xor_blocks()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-lib-v1-1-cb3045bef2d8@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
In-Reply-To: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 Li Nan <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1498; i=rppt@kernel.org;
 h=from:subject:message-id; bh=KJAXU5mOv5CPom1VzUfgV8OYGplwFlepp+4o2eZA+P4=;
 b=owEBbQGS/pANAwAKATkDhibLDv2RAcsmYgBqDW47MV87uO+B/bp1693WxM1CGNkAUmHMa1i6U
 EEL3lQU9t6JATMEAAEKAB0WIQR45VhVpZkvn3TRr+k5A4Ymyw79kQUCag1uOwAKCRA5A4Ymyw79
 kV24B/45axPy5o8zh7l/vNdFFfw5H/PrwPWpHsCU1CwDC9J5wgW0dExMMpkXTernBctaYWzIR8n
 ViLBNu7MFva22LD+WDscfKxRRpUOpZiNUq6nMzK6RW3B4DbKzGIu2ZlMuqkuxp7IJ8eNMwn17gg
 dwoU8ebvXNZhdhCDEb1lGyWp/YvU3lJo+9kVmas87pTKolroWdfgozYDW9tyRIJTrQGSl4ouF4x
 YVGh0856B/QvqdSaQf6r02QbZUBpoBBlcyJ4G2AgpUMOWQ2zCa3sibeUynR9cO7sQVrsbIlQyV6
 +tCVUS0Id5dZuZAIeSL8KxEn4suDWkpfobOs8kIaX59lb543
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7428B1A0002
X-Rspam-User: 
X-Stat-Signature: pydbzh9zcnd6qww4upkxwmo1wwetm9rz
X-HE-Tag: 1779265095-982579
X-HE-Meta: U2FsdGVkX18H5loc9RQ/8RjLbrQLC3Ug34afpQYb4X8TpoYhjKLqzG/bDN1CHAPiuEoi7EI+cojpDAjjE/JDxy0lZfRoxTKFP1dSUkqMTwWDljgLIoJwfahetOUlh131hHuU3VI+1zfk2Siz/LVN84WGfUHPGt7pkJJK78l6gm42aMp1S0TlawAMYK3QRdnmsMIdPV4eVArQd2QY7G8sJEgI/o97COFT8O8ggUoTLJwcehNCOjjAfQLr8z95clf76PphmtV6eN275q9eULY3QLNtwT1I9uguz2igGBHS1O+q67qfAxexlSeJ5o8C3+HpRiZyeQyCJn5s7080I2HP6kp2ZztpP7tANrn5gUpBTHl+Dmbf/9EV4O3eYuUiWOzS4dmF84Ytemkh2fmGbicmSkJr4nau0W98yJIMc9uznLtI59MgOZU92QVthK0YlinuA78aHvI5itaZK6mmEh/F5AaiuvBZ+LPEY8iSTSOiiCd86/IIRliAHzwhAXvvqyKxlBHW4vWs01IEMi0BsGxEdJQF4c0TvIFRkCVsbYweWr4qpqHymt2DKZqzn6HbaZjZXkdbTeTeTFNP3kQM2ySnxMGqT6GpRREloGwMp1gKTL948JDu5hoTYCEqpQdthChxYdrt43w9/Ylq3cRi1gio/dViarhAYvUCrvcAVZ/E4lQPP5IBJRnl3gxaqDoNpgidqgr+Hw9cujQsPENyjLiISeOfFNpD+PExTLNrz5EEX1Ol/CeGCWyYdTcvhJp8gIo1oss16eIO83uAdljNxHwhi2tTvWuIrkPvTXWF44MXW2iEAM0u862ZNAvR9f9PduU6ItJ+AfEvSamy9+joxP4vEYTouNAEiQyLKZbP9IvjO+vux9xVLa9Hz4b+SV7o6Igm31PYPhzOaVKnNwsmfYlMEbm9rrZ3JNb4QAM3nR1TAS0uutCwAg95+ibza+eVFg+hk+TmMLYYw8hog+qRQJE
 bF78QMBR
 Ec/6Xad21u8SesmS5bV9A7H/gmOk6WNOJJrPHrPPcxTOzNBZAI+9408ZjS2QXe6Oiapgs+zp/ZrQe/KLdS0Qhcxs3LSr0M8lRwzemdXVBpStvjcpfU4UKaCQbEjDcvGS+QhmN9Ocu5trQPBecUwDaaEegs8/SFCm66fApjOtbd+H7Oxn2MUFOhUkywZR2pmX4APv5STPsMi8AFgAdJLrWLSH9Ea8uqGcxX5tPXW3LLN2F4Qb/8uDeDArqt+7meD+ymmG2/PTy3BDGVG8UTOEkTeVycZFNBTcoJu9Dk0g/xnfmUkUJ2SZkveCCpqeHRA/S48D+dcy+HTRxNwXmc03MmEH/5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The xor benchmark allocates an order 2 (4 pages) scratch buffer that is
used purely as a CPU-only XOR working area.

For such large allocations kmalloc() would fall back to alloc_pages() but
still kmalloc() is a better API as it does not require unnecessary
castings and may provide more debugging possibilities.

Replace __get_free_pages() call with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 lib/raid/xor/xor-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
index bd4e6e434418..50931fbf0324 100644
--- a/lib/raid/xor/xor-core.c
+++ b/lib/raid/xor/xor-core.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <linux/raid/xor.h>
 #include <linux/jiffies.h>
 #include <linux/preempt.h>
@@ -114,7 +115,7 @@ static int __init calibrate_xor_blocks(void)
 	if (forced_template)
 		return 0;
 
-	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
+	b1 = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
 	if (!b1) {
 		pr_warn("xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -132,7 +133,7 @@ static int __init calibrate_xor_blocks(void)
 	pr_info("xor: using function: %s (%d MB/sec)\n",
 	       fastest->name, fastest->speed);
 
-	free_pages((unsigned long)b1, 2);
+	kfree(b1);
 	return 0;
 }
 

-- 
2.53.0


