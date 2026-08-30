Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD949C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 08:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA15C6B0095; Sun, 30 Aug 2026 04:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D520C6B0096; Sun, 30 Aug 2026 04:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40F26B0098; Sun, 30 Aug 2026 04:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CBBA6B0095
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:10:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A79FA1A0278
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:10:55 +0000 (UTC)
X-FDA: 85157214870.07.5A387F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 10A97C0007
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:10:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XoUjINXM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788077454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F0ab/FRyl7xwjV92cpw9DkLnKNb13jgD1FH/6y8ErV4=;
	b=DuGzjttiasQtbSx2SBW13awVDU5kv/LaNjzLSL7CrQnOWqCD2vF5va2LUYlyLYB7+q3Exz
	KGkqYtIOHaCM8AiT1+TKjJjgN+k4qfW6NBOnWV8CCbxZXRz53h9kE55UmVbRTjPZFfPR4l
	A90TjE6fSr/idXVLbXopiYkxqxG+5TA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788077454;
	b=xcZ/LRvFpX9qlpPXgN0ywAdjWBd3xhBjZzN5Jbg1wJzRj9bxNVNsmEDWXhSLx/Db2vWFbd
	dFJbrgu2BeP2vEkoTaW9zdHvisB0Am97Zoj3BEO0XEJw8GuCq46RgaAb9KTuCtNQthVsO8
	6C5Ofg9MNo0GZ2qt3xGadYt6CcPmCL4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XoUjINXM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0604600AE;
	Sun, 30 Aug 2026 08:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D921F000E9;
	Sun, 30 Aug 2026 08:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788077453;
	bh=F0ab/FRyl7xwjV92cpw9DkLnKNb13jgD1FH/6y8ErV4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XoUjINXM1Y4uac2VQ5A3L22S2Gg3pNsrrS2hFECFKPp3OzSpF4FX4Y1BIxnhRO+vG
	 R+V7nVfJB9UZ9GZanBQZNEpqRnktgaXbb+SX+uwrY4+p8tAqOlVX0N3XRFzc0BiV+q
	 HsD2riN4MVuw1fkt0VSmb8AQXGHJ+4/HLFB0KxqkiQhoMjJqm+ZbFQme7ieCYbADx7
	 +j6LQLKllK8zKsroDeAsT6iPmxOYelfZ7z3omirYLGaBFU4o7NAvGiCBSc9/VV9lPq
	 FLftTs4vMlF3P6ufiC8VAjl0zqzx2aFqTvUsHH152ezS4xIvC/Kcux/mIOlobgLypK
	 6b5ATDQZF93OA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 30 Aug 2026 11:10:38 +0300
Subject: [PATCH 2/4] USB: cxacru: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-usb-v1-2-aa349c302246@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 10A97C0007
X-Stat-Signature: rfxuxdn36yrdzmnrr36tpcq1xr9fik5o
X-Rspam-User: 
X-HE-Tag: 1788077453-511503
X-HE-Meta: U2FsdGVkX19P4K0ChRhuJ8rqlhDtYCUD5DrxHRVlfqqnsn+uvNNDZ2iCAKYELFOXmK3ALDGmfbFP6/CrQc51jXEwjlaR4RTOafJvLs+85U/SboVYJ3AQ8ZeBE1ShIDEYd2WfiPClbOlvwi0YEVQeeXFyp6EU+vjLZWl+tGCr8RdGVB799HRU4pHdhVN9aXLG1VOTzOsWLOdGc59j7v3FfZUXpenPJyeKE/fBB7B742md8xGz+w1Sl6fFkb1NT/EEt2QpEpIptsek7mPzDyS2WJO2eRjh9IMburMCumts/z9/0l6LqsfhV6QiP+IM/yLbRF1Fnb9teJMYgTmTlOUYwgiVgozqf+7yiSofD/PbeBFke7eFGTJJ/l8Stqg5tkQ46ggtPMh97vYPNSveExSx8nzXVo+fHIDL8CrnpDY48hKO8V7aPNJiNxeLK2X1FV+Nl6kfIc5cuilAxCwyGqVOA/zmiS4S1OmPfezYQ9/EjxV+LMuURY+VMj4rxueTSipXW4jyPe3vRbeBKDI2r/0T3GxcVb42VGQ7Uld53eLLRwNgOzptNIOV3DCjCYqFiMQBmDlFjm9JqEnxi+MqDcFFWVzZY8MEaC/c/nIbe2FXjZrSp14E4Qp8qJy+3WPud+dCIvgM8KvMXDAhWqO415uARyx7hmuzCJZEa717SGP+/v58EHOfC48Ti6o1nHbEYglt1JaD5Z2y8c6K4ecWCmnkU8lzrLRQNd9jTHkHCRTRoe45S/okRDVBBrKPMSlZxbwBfwHJf3By2pJ1HsYATprA6mPeQgpgwyaGN7Sgl25wCxtudQIvKFu1XhtT6kblHXcwS5JxPxPX23Ce11JM9mkdQFNztzXXO7CaWLtEDgIK2YIPUzEfU5hTj8mhMU1MqaeTX/xt7vX9eHe55mX4vmLCYuObOIAPQltiGMkhHGAl8qrqbIZnS7FpXs/d+k+hzQwZOHKSEFw5jwSKSIpzWpf
 dECaALye
 ObPi1RY0p0c1gxKJNVchwoggPnhefwMR9NT+63CfFntExSwuO6j2cxfcYALTykFPXfgCqtESWG4PjMq5sm/7jeVf9BJFe1szrmbhOfdECEfYSC2JdEFHfpWBPL1+GI6032RRW2fsCI7eMwGbFU7v7RksBYNEngX/28Cze66OcwQjWyJKaSTfNZwlWnDn6aGBC+VRO52Vr2rR0IX/gWJvhjNQ6D1wEfnywd0yOBMHzKtTsTsNvHtIPFtxBzpjKn1TasPtP926vfjLhrc/sQlb+4VBOMW/5hl57k0gs5ZNkqaa+3BxB2TynMmRCSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cxacru_fw() allocates a temporary buffer used to feed the firmware to the
device and cxacru_bind() allocates the transfer buffers for the command
URBs.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

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
 drivers/usb/atm/cxacru.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 636f7886fc26..75d87c31e81f 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -942,7 +942,7 @@ static int cxacru_fw(struct usb_device *usb_dev, enum cxacru_fw_request fw,
 	int offd, offb;
 	const int stride = CMD_PACKET_SIZE - 8;
 
-	buf = (u8 *) __get_free_page(GFP_KERNEL);
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -978,7 +978,7 @@ static int cxacru_fw(struct usb_device *usb_dev, enum cxacru_fw_request fw,
 	ret = 0;
 
 cleanup:
-	free_page((unsigned long) buf);
+	kfree(buf);
 	return ret;
 }
 
@@ -1146,13 +1146,13 @@ static int cxacru_bind(struct usbatm_data *usbatm_instance,
 
 	mutex_init(&instance->adsl_state_serialize);
 
-	instance->rcv_buf = (u8 *) __get_free_page(GFP_KERNEL);
+	instance->rcv_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!instance->rcv_buf) {
 		usb_dbg(usbatm_instance, "cxacru_bind: no memory for rcv_buf\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
-	instance->snd_buf = (u8 *) __get_free_page(GFP_KERNEL);
+	instance->snd_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!instance->snd_buf) {
 		usb_dbg(usbatm_instance, "cxacru_bind: no memory for snd_buf\n");
 		ret = -ENOMEM;
@@ -1220,8 +1220,8 @@ static int cxacru_bind(struct usbatm_data *usbatm_instance,
 	return 0;
 
  fail:
-	free_page((unsigned long) instance->snd_buf);
-	free_page((unsigned long) instance->rcv_buf);
+	kfree(instance->snd_buf);
+	kfree(instance->rcv_buf);
 	usb_free_urb(instance->snd_urb);
 	usb_free_urb(instance->rcv_urb);
 	kfree(instance);
@@ -1254,8 +1254,8 @@ static void cxacru_unbind(struct usbatm_data *usbatm_instance,
 	usb_free_urb(instance->snd_urb);
 	usb_free_urb(instance->rcv_urb);
 
-	free_page((unsigned long) instance->snd_buf);
-	free_page((unsigned long) instance->rcv_buf);
+	kfree(instance->snd_buf);
+	kfree(instance->rcv_buf);
 
 	kfree(instance);
 

-- 
2.53.0


