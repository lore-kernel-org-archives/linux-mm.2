Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39608C61DE2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 08:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5F36B0096; Sun, 30 Aug 2026 04:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D966B0098; Sun, 30 Aug 2026 04:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA166B0099; Sun, 30 Aug 2026 04:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7EC06B0096
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:10:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C73B4026D
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:10:59 +0000 (UTC)
X-FDA: 85157215038.27.726F809
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B81D91C0004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:10:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lIROzJlE;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788077457;
	b=g+qcCheR46P/bgJcFkctdmUdzknuXSDRQHAB860IDQdvkSK1m8tTrFcGPNgKQCh/gdF5dL
	rdZGwcVHi61LwGCl8CPh2Y1HVuof6xwbISN9q4PWL2TN9qGgKkbKXbvKL8Rerr/fWml94M
	vD+/HxGZIn8FMfw130hiE6qFA/8zvCE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788077457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nOm9eBZiZjf8UMoAxzpiMIxa0Bir8gKmGDsW4008HnU=;
	b=rhPijciaoe/piD/bACB8Do20UeOjdPrjdXCOrzV3X7R/lUVSYePXpTh4YHaO5LS88Y17qq
	5UWJs5WrWWxy9GZ+Y5BqJg6r2AidqJzt3W6nqwDAUa5pVNkYU5h8Hd+7SJ7TixFiOu1bub
	KBGhDbHekxK5qRlQnDQMXczyTuvvL+E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lIROzJlE;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 54D22600E2;
	Sun, 30 Aug 2026 08:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F3E1F00A3D;
	Sun, 30 Aug 2026 08:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788077457;
	bh=nOm9eBZiZjf8UMoAxzpiMIxa0Bir8gKmGDsW4008HnU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lIROzJlEfhe9fXXQpOEPInD3L5t2aTRzsfV9UdXXzCDPi7W2cE8UBPf37fFvWjYQk
	 rCrWVvOSWFf1MGY+NG2XsmSU2+4zrmFZy5rS0+NKX3id4dcLkaRlhkC0G6NVYc5IrR
	 X3kCd0YHNLYFzhlJ4Hbny1wOWbDi/TPHNbWoaaJ/8RArHJbyjT24E2QQ+KMa3ItzQK
	 QdVfGyePaxH3c/pt9RxT2iVoXIFkX9DF0GQLhVvrRLgRPgoCwX9N0V1oPug2oha87a
	 l5r92IFro7ZgEnUErpB3y45+eNIVtSfjOB/WNOuWl1by5KYRgXIYnwtgQvqHnl29YQ
	 +ovxDN+LpS1gA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 30 Aug 2026 11:10:39 +0300
Subject: [PATCH 3/4] USB: speedtch: replace __get_free_page() with
 kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-usb-v1-3-aa349c302246@kernel.org>
References: <20260830-usb-v1-0-aa349c302246@kernel.org>
In-Reply-To: <20260830-usb-v1-0-aa349c302246@kernel.org>
To: Chas Williams <3chas3@gmail.com>, Duncan Sands <duncan.sands@free.fr>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Johan Hovold <johan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 accessrunner-general@lists.sourceforge.net, 
 linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B81D91C0004
X-Stat-Signature: idjjbg58bftq3oew4d614cqxgbcrs4wf
X-HE-Tag: 1788077457-711372
X-HE-Meta: U2FsdGVkX18PolLdKp5d/G1Un/iYDG7BDfWA4ZxNZ4700qS8d66NVcQcektDriX4Y27/ZoR524HvkpCiVHP2hBmsd2+VUNjK8iJ7y5gpGGThBENP7ZI5ExYIVDTXHXiyWKOb2tCSlemHx57Yqlkpml0NiHgwkAPIRtIUQqNdgIAxuR16QHeZzCzXiL5P5r72Dalrcla8i2brQftR4DUS82HSF21qxkGU6cklRrul3Ty879n5PunjR6vGrWoIBXy1Uo3hbaAmKGfmJ4YhUdmeJB9VilOmwhN4BckpCdWnLAw8gNopAwWfTtgbnanJhhVOhbgaJMajRRmBibWewxdAjSz9x+4TpZleiGcWEjwW2DlQUlWjyHopxTd/s5iFKE8osc1OyoGTeDJg/NPHKQ7CAe93MbSGXHmHPZkhP7D31gtgMQvgbP7Cu7Dx7y418fNidjemknD0utV8qcrD5nEWJ+2iZ4Ttpyvq+b+kV6WuAtr90aWhnNJoBB8k45wdfNxSU8FuXV8KgK2P8zKlZtqo5j4JHKklEuJCAd3ycg2v09yHS/Dvra4tPeWwcSnAWq35yvaIOuhKsNlInp/unjkpuGi8dz8gX176SOtwrPNPzpiUKFlQuzRcCJufWfe36hwTZ21vzetHFbwwlV2C+kqo5V3HcvdPBvd6zKFqspWCNdhK7WOETltczTpA0Sr78ajICCilSiWt54jxSADv5i2EaHhAU7TBGv89Hf/iTpiZaif1+9IbZHJbp4iZlVmNkTl3jdU2dTwPDCW2j6p/IKyXJD39q47sMKAT6LduRxRLgodtr4Qi7cwYIh1g+KOkxJtAaVYgHwxxv+vSgp1NhX7uF0W+wHx/nlMktLwsx1f3uYkswk9xrJU5FIWlMO1SDay0kApOP7wcqRhBKF2xC9CYUBcS9voCqV5qx5ibKkpKYmo6qLWgWeROgD1tAqoFoc7sfgCh/X32P6SuXjDxku2
 qH60diFx
 8+6mrVN3yBN6EjanHOMWy/a4xavc3fx9nps0YQLYjoQi365D1wDuJtIK2FcwTy+WE7Ktdpsvy5DYi+lzUig8mqcccquNCjh8Q3iNIcxXE8rl1ox9/+gO94yXomvyCfGir1agLOH+jPc5dPT6qQAP+2su6Pa6W0rp8Pf4A0NTEqaaDIWHAGRV7ezUpuciivZHBlfpWDyhopbqG7pr6s+NFyGl7FYFPMOlkL3KOXT661GH20KGh0hhFO1K4mPV65dLu3jkwITrPOaK79buPcxH1e97G/fxkqPtUOKCrcbvHqo0ahZxSsgAPQVGScw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

speedtch_upload_firmware() allocates a temporary buffer used to feed the
firmware to the device.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/usb/atm/speedtch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 9d28c652bcd8..e5e021aafbd3 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -241,7 +241,7 @@ static int speedtch_upload_firmware(struct speedtch_instance_data *instance,
 
 	usb_dbg(usbatm, "%s entered\n", __func__);
 
-	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buffer) {
 		ret = -ENOMEM;
 		usb_dbg(usbatm, "%s: no memory for buffer!\n", __func__);
@@ -340,7 +340,7 @@ static int speedtch_upload_firmware(struct speedtch_instance_data *instance,
 	ret = 0;
 
 out_free:
-	free_page((unsigned long)buffer);
+	kfree(buffer);
 out:
 	return ret;
 }

-- 
2.53.0


