Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D0D3EB1052
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29626B00C0; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8C36B00C8; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585446B00C5; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAFC26B00BF
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE19A1BCF5
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
X-FDA: 84529998630.26.665B1B6
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9D6058001B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=PqCygKH8;
	spf=pass (imf30.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZ1R+4oZb1OFARHwN3kW6NWT/McIyfCGe+74kGs96GA=;
	b=zyc+8XtwlB8/TsUF6EVh7X1BWj6OXUF81zDPEJVSD4tszQ23hYwy7vaoKMFzZqqGSyl5rx
	+6yDMc4st3dz66XPEiNFP2r9gDrNPGDQWlNztBPXQDPbJYW3Y2BrIaGS0FRiD8i9sZs2/D
	vF3CJMb6jJl1i04rKG7nB0Z3/i4Jtls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143734; a=rsa-sha256;
	cv=none;
	b=nC2ixjpPutwNqnuNanStv6Z2twL1IZv83PjECqxEvXoWqCjnf8rog+f7BgL2g24hfsRZhk
	zNLuUVce3HrtSyrTuvfuj3uVVi6UaZRS+RD4J5Qlzu/6COVoqwKw04s9jV1x8xnMkoUDQD
	sWZvz7QYeZ2igWyX2lNrsFKuqfvb5c4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=PqCygKH8;
	spf=pass (imf30.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143728; bh=ljsuTOpGREUyGER98xbD6/ci86SD8pohlonTQBpqGIg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PqCygKH8TUTFzdsVoltpS6V+urh3nKuUaWPGyQ9+G5dBBIMLMlSqFUF2pQu2ztCks
	 nKjygDeUmN//qOptE9nqaXpkixC5XmuX8GEDJn5HpI8613PWAZldzQgtG5ilRHjEDe
	 PPv3OqXdqRSmvRO/4sRCoDxU/Kdn2GWugjDbKUbA=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006b0-b734-7f0000032729-7f0000019cb0-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:28 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:28 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:25 +0100
Subject: [PATCH 59/61] debugobjects: Drop likely() around !IS_ERR_OR_NULL()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-59-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1116; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=ljsuTOpGREUyGER98xbD6/ci86SD8pohlonTQBpqGIg=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAafUF4Co3bKHEJh1nSPEbGPanpbmXqLGBVTE
 nsli8aGTIqJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGnwAKCRA0LQZT0ays
 2/eqCACfKEiwIm4grjaffCaqYK9UtMC/I42k93h5L5QQzw4cYMYd8FGhvLp+Ug9Jk9iQltpydL0
 M021kU+8e5LuC9HNGAP+FvXfKicTrLe4WOGLghTKJxJD0Qnwt87qFBwN4C5TgDS7lK8yPptqdRT
 xavsstUunap8iVxwbzeUWdgcTpG4nsY9KAjliWo7xLgVYhCSEWYrkYbks39zWe9p1rptJWM2IT/
 +/O3p9icHSV3twwgGTFQhBYPys+tvE7XNArxXHhB+XYW7AEdqLgSeLiL6ig5y++9xZFwEIcnWi0
 5dJklCZYTethhL0MgTuOAEkoSCl0Bk6MDrD8akTrSRkzdCkv
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143728-7AAFCA3D-1B7F7E41/0/0
X-purgate-type: clean
X-purgate-size: 1118
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Stat-Signature: ttqt4k6sujftqfywu35b69tw46a3wzq4
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D6058001B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773143733-305873
X-HE-Meta: U2FsdGVkX1+9pVqv8w2G9Tyzn3iGNjr78IqQBfFjoMCzH92kmR9da+f7VdkR58Z7jz9mNk4/NICxhsEAYVAFfHiK6OAkEW2enZTnyuYI5A9kT05waMfa6wo8rwKL1iiBghxM+I1RdkvXHfsK2Qk596+3TgJpicxAZ3CM9XcNS01O8EpWRNOjavJizyKc7fLMxBy+kxTIXk6JCilTDWtwslSvzXndh8c5lPo4DpuKaKksQEm9tD1CjgDwgJLbU1pLw4Y19YdBAWdJNuBJBPC70RqPUZ2FRnKnL/tCNETFit3tk37EhoULx1bZ2m/tr6Q3J6emLt0IWyrC6015bea2Bvs58BIxviauyhKMwhDj1WR8b2L+O4l+dqQwolEsu13kXnUfRqG64/tgCEDdAqxnG9r5zlWQaS2SSGsBS21gZ6r71od5mRHo2nNgix1coNLsdEcdppDDfoohjJ4pgt/OWK/YCFeOfDCJ29G3NScMEJOtsdm8U44+f6CXUdCtm5FV+VsEVEHpAdSUSe0VtR/LAiSEBjIcyk4UjL8J1kw1IWnkALceu9NzMQX4DCwEqvnLpC1Lm2nxdHWg9l+xQ3kBtQ0nyW8peMqW1hbFp6D+/Y9g9Lv7Z59cIQRSEb1PqdyPw/qIwwTEh8tPHQ99K8OelFg9rpswy0icvWEYHnMYiRxnepl7MADvsVRqviprZN9mVKj76m6QI+nyKJ7MKv2BLVRLw0vXR7Qz+nWvQtR7H9XNfMSIuMdmkLCszS6H6vXMaGroxEMcMkXN66rTYRmMlKX8DQtYDgl7rp5zH/yqVHT+SP4YIbzavIL+KD6jM5te7dom83WhrRbx8huyT5bEttTuulOpA54xljQG0neceyRGzR3YJRZGKxYwQfNxKWh0HLRZYn9poxf94bOzK2KfnzLY15GGZ3I8Oon2U1yMDDnMs5mZZg3QYbDvHLx3cDrqsAT6us2tc9qjahbcEf8
 u0UPJTDN
 CGQTF+6s6kLN5VDut0xzHsPPPiRwDTkOVX8q3DbCxJmV4LEAL50h7zNxCi8+biJ3mElj5ymKIjh/g4sPVKwtBsu+7DXct67mMUHAdRCLVVYL7auxqnnyX+plUK6B72LmCDOpt8jRGstljqnGpk0h8RgsYq78rrV2ws1e+SFzynZO/G/EKoOlUUaW+HouEj9+yAw0SFOLAnJAnW6o5nbF3uS7seA9t8Lu2NU14qBVYcrVbeCud8D+nmblH6mNQRS/eqv93C8eryCOCUwn4+vYyYuRdY9c5ztaF+NjeK1bUMqLejryelANvIqcg/yYYWb3YzJ9vdA+6jFJBDBjbDNq10+LSkyxsYlWjTsRzjJjM5z6feFXwFGczmhUk9az8Xl3D6EhdoalHCDrznQRDTVnHuIO9P4ShjCjyMHhai5X8jE4faDHexnFL69XjGa+/mQKaYCuyqV9kB8KG9SJu8w+8TksVJDUIiGZzuySxlp6aMFuyiLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

IS_ERR_OR_NULL() already uses likely(!ptr) internally. checkpatch does
not like nesting it:
> WARNING: nested (un)?likely() calls, IS_ERR_OR_NULL already uses
> unlikely() internally
Remove the explicit use of likely().

Change generated with coccinelle.

To: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 lib/debugobjects.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 12f50de85b621a743a5b6f2638a308f6162c6fcc..12e2e42e6a31aa8706e859aca41b81c03889cffe 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -1024,7 +1024,7 @@ void debug_object_assert_init(void *addr, const struct debug_obj_descr *descr)
 	raw_spin_lock_irqsave(&db->lock, flags);
 	obj = lookup_object_or_alloc(addr, db, descr, false, true);
 	raw_spin_unlock_irqrestore(&db->lock, flags);
-	if (likely(!IS_ERR_OR_NULL(obj)))
+	if (!IS_ERR_OR_NULL(obj))
 		return;
 
 	/* If NULL the allocation has hit OOM */

-- 
2.43.0


