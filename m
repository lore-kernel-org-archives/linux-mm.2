Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B8BC982D1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 219EE6B00A2; Thu, 17 Sep 2026 09:30:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EA806B00A3; Thu, 17 Sep 2026 09:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8D06B00A4; Thu, 17 Sep 2026 09:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAF506B00A2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:30:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B6631C2377
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:30:02 +0000 (UTC)
X-FDA: 85223337444.17.F15BBE6
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf08.hostedemail.com (Postfix) with ESMTP id A43BF16000F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:30:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b=nQb76i5i;
	spf=pass (imf08.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.140 as permitted sender) smtp.mailfrom=sean@starlabs.systems;
	dmarc=pass (policy=none) header.from=starlabs.systems
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789651800;
	b=L9sLrSXSbw9tkexzvKHCrAZ3rhGK5Q8rhwY9tyRXaJupndqx39BdGYYD+QrDp8FQWHHlTI
	O7PoTUkeke4XNVmCVfgeGadr5ftm4i9bXY9Yv+0Y8UNVUNuWncTRBsO5d9igGJJjOFER8V
	SBZyUaRujJNCmZrqX+8whBZBAheGRw0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b=nQb76i5i;
	spf=pass (imf08.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.140 as permitted sender) smtp.mailfrom=sean@starlabs.systems;
	dmarc=pass (policy=none) header.from=starlabs.systems
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789651800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhZfe7j97gcGMqNS+7HeL0ehn+NCntLK64e5hLR53vg=;
	b=yblyDYq87TtNHEsW76/KmFvSjwsgZjoD6FPJy85pgNbIcJS5PGPIEqjtXvCX7+Y9MheR7d
	Kq/QbhLJI2Rm3VcptrLaReCumjo9FYgkmjooYVLCWtMNbLocQRUIM1kAFpZHJKjpkn0R1Y
	zVZnMCeuv5yD7hVo9x674+Dc/C4XKog=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d37b6so4109045e9.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starlabs-systems.20251104.gappssmtp.com; s=20251104; t=1789651799; x=1790256599; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GhZfe7j97gcGMqNS+7HeL0ehn+NCntLK64e5hLR53vg=;
        b=nQb76i5iIvXenJBgrEhl98cVly+5YPAZbgLnCtJGX4ek44axMcU5Rrz3xWPDZdXDAf
         euf4lguBg1u+F4NdUavXjlq4ziux0hhoB/2bSi0/KdLjwuYFxG2r5MJO2s1cDLXEZk6l
         cK0uo8wXZxFtzqmwmLVLMFm/cAyUdcQM8cVWn813ATxPh7gb0/rz1h56qUED9/p2TfIK
         E7iu2Jf0dqgJ9SsN2yfkrYPUYm7BfrqLE3IzgFAcUq5LLjw5bnUgRj+tfZ7jgXHqowdA
         HV2fybe0ZkIDXoU2droNX2wbEKxxoWh80j0NHPFf9xRXIjFBtk5yu8QBg0U7LQY4sVqP
         lVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789651799; x=1790256599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GhZfe7j97gcGMqNS+7HeL0ehn+NCntLK64e5hLR53vg=;
        b=Sze5LCyT12U7PUYjH66Zop6L1EG9xD70X+akdAGbCL/c7Nz48g2TFam/yDiQwsbDiM
         D5adEdLca+OIMVe2G1F/7XXYqvvQ7K1I87D6qTQaBZdhYLZa+R7hCdEup1uM6CvwQRMu
         5YhvuiU1AWTXyAasfC1MBGJNNwJICYMIpzP8huU18qydYhegSEsHFI+ojIppbdnbx0/8
         BIfBbjmcK705Jsqyzkx1MdclCE98QC0kJuq6AAk8LjPOmI4xI1PBT7j1iS6Q7qI7b4ta
         UI2pKGDhfZ990fg76tSQjt3hMQQxzMpcl/pneHMJobhsHQgQmK/mG+dGe6OJ+LGWR33H
         kCZA==
X-Forwarded-Encrypted: i=1; AKwUvBwRqcdSE9aeH3oKTHn7r9Kgpl4BOhXbHKHpf0z3i4Q5cFpLRnhUAlRz6w1fl1Wab7/RlfS5u82ujQ==@kvack.org
X-Gm-Message-State: AFuF++luqtKis9vIkdT17aBuxgwiZRexAuYtiGap3XMFptRGa6HUALT0
	gi4tC03WYhFNSx44NtYCL3qvYl2K7wrVMjlrc9YEo4LVPpNGKn9aP9iWpbCOc21frg==
X-Gm-Gg: AYBFou2C6h4r+rnFlZH9ibkkl3edrHppWh39iHb8oaafijyE1mnciM9VU5HsBiW5PmH
	wjsEcQO+W0ZQR4rVuqZsNGX3SNgCfLcWoy7Ke20itQQ2bJ9C6jlMi4ptqtX4tCgTnzZZPFVW8I6
	T1t1Y1odbov9aammEN3ecvH85bmse6bGeIbjLZshbfyjhBBkJgOBI74HKj+CV5Jv9/eW4UN3nxV
	rZmjCpBOzAbgsPBwh05Yg3vKa4Tdrj8jdW2c6RMvRAVEPXww/YcgmXaU11kjHgdMlpVuCBzqvdp
	VgGbq4+EjFb8UilTtHiLA58nWD6TfBPPAd04uVdo9BgGSOF/vhSXS9KbQq5vQtu1pHJtcJtRbF8
	hgcVyFkPwCUr74pnldxUSEmVX1fJ5AFHAjym8OIwLZIRri2dSSpBAOaOem6zgsrvgwk+FNexc5l
	P4n1XEw4wpIeIyt/0rFN23s4PC/d4+ft9V+KCDMFTWgh690lNc9PltPi7+b3SJBb6FtZOlHCUzc
	H1DM4+o47DuiucycdGmrib1zQrMqj6lGFtSdg==
X-Received: by 2002:a05:600c:4e91:b0:49d:726:cc9f with SMTP id 5b1f17b1804b1-49eb72f39d7mr156045335e9.5.1789651799329;
        Thu, 17 Sep 2026 06:29:59 -0700 (PDT)
Received: from fighter ([216.128.28.240])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd2356d1sm97548275e9.6.2026.09.17.06.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 06:29:58 -0700 (PDT)
From: Sean Rhodes <sean@starlabs.systems>
To: linux-pm@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Evan Green <evgreen@chromium.org>,
	Sean Rhodes <sean@starlabs.systems>,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>
Subject: [PATCH v3 RESEND 4/4] PM: hibernate: document encrypted snapshot seed ABI
Date: Thu, 17 Sep 2026 14:29:50 +0100
Message-ID: <81c284e9246faa817050f34d46a9fbe558ddba5b.1789651778.git.sean@starlabs.systems>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1789651778.git.sean@starlabs.systems>
References: <cover.1789651778.git.sean@starlabs.systems>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A43BF16000F
X-Stat-Signature: 7137naaixff7wso4dt1jqpn35zhbhb6e
X-Rspam-User: 
X-HE-Tag: 1789651800-559740
X-HE-Meta: U2FsdGVkX1+cm/mSbieCjaXv7dHoxauvmcAvOu+eJ3LGAEmEnVX0Q2bemgRnXP/bnzwtWpelxqo9BOR1ptZU8fSEnklJFi2+JeMXP2G29xAf7zJNijfN3jJ6gQv58V78n6jwRDM2sFb/3H8yX0IvdIwi3Xn/aJIvBmPxYsLBuZGtLD+MsbRCLxe3SUgnfMp2m02ESPQv/d9bSRG86OrBwEzoEmv85FLd291nHIVkUOzAW34eB+lZUacAYyh/rYIyUK6RgDIzaAsfa2B7MjKXYw+TvG/ciSmjuCLsKGiyM/GJ3/5fyflgffsNl6kBY2095pQidIbnss0f0oNjQGBET2hrxKXhGspPDLEgtd53go0kImW/DqSINqKVK8PCY+3SLjPMtuLk5A0oDGJcCRX2x4x1U5apru+x0TfJBFf2EYPMHojrXMsfg6v1XvtMMT0Yb61XgmbYCTJW7fCrIjHivhOqxlCq+kIPEtS2HdbTVBm2EgIktjvHbP9NNKK6VUodjO/5Ii5xe4/F+X0Nb5tpCjpkKMzwMBikss2etcGJ7K4I1OmMZvzcUsXjlYcJBRj7akuuTTtlH6Pfga9rabIXTYvZKvKpvXSYCg6GjI/6Iq1SoVlKSWKWZuv0zg49qa1zyzYA4Q2yTZPkJ8yMsKXycF1a2q7/q94FpXB/YuURsUymCvHjlKUJ69Kk1bZEAdeFaRpDJECvGZOua2ACjbBewNhulPgCmmlrGyIOUyW+8EFjEuFC0NQIICq6Ov2GAlXAYk5VT4NjYxhj6nv5frul6Pu5p8Y9P1F6f8UJVaSNebzw/pXEGw3nJduiwvuY01slts2LxR1MzD94ZgHASODkb3HkjjwO+p/199oiJ9dnkZ0HB7nhwZZhOWZEgT1hGHWvaUOLZUkOpPbPb+BFVzozchyRGtHgnISAbWO0crVkZS890MIHMoPq3iBUFdCGxxOc2mq+0AvSteecN8aGCUD
 NSp+qPAu
 eowMmZy8o69WWbITD72asWsEY4kA4Gs76stsmjB5RCsinZZExACKWqQjEWOFc3k6d3hUpxTNX/2fsnh9Sw1ZKUtshrOpsbmPCv7woccTLHCoGNBeiykvr15HdjdIaTaIgvKazKBpAdb3kTfzk7FST6DY9Ukjht5ERSeepfXnBfRl5alRkwx1T6rNy+ROiuDWYDH9FgxxsseakzPEci9NIwvRwRGcP+QFU7yzi2j7TAGOGd9odU8ywHHY/+2FPkkdBMgUBDBGo6GBxx3aLFJayWUaE5QurixBKums67Po2hCEFNG5LBO8RFONTMDvOUmem0+gI5g2M2G86x08MYMac+0ADfEVvVqsiZ56Jy2vw3N4NgdOf8iAuQtT9c6s+rJ6aovBSFj6H6S2PvD5ovV7CeYNvJtb4iOpfUisp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the write-only snapshot_seed sysfs file and update the userspace
snapshot interface text to describe the opaque wrapped-key flow used by
encrypted hibernation.

Signed-off-by: Sean Rhodes <sean@starlabs.systems>
---
 Documentation/ABI/testing/sysfs-power   | 18 +++++++++++++
 Documentation/power/userland-swsusp.rst | 35 ++++++++++++++++++-------
 2 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-power b/Documentation/ABI/testing/sysfs-power
index d38da077905a..c756712a9df5 100644
--- a/Documentation/ABI/testing/sysfs-power
+++ b/Documentation/ABI/testing/sysfs-power
@@ -470,3 +470,21 @@ Description:
 
                 Minimum value: 1
                 Default value: 3
+
+What:		/sys/power/snapshot_seed
+Date:		July 2026
+Contact:	linux-pm@vger.kernel.org
+Description:
+		Write-only file present when CONFIG_ENCRYPTED_HIBERNATION=y.
+
+		Trusted early userspace writes a 32-byte seed, encoded as
+		64 hexadecimal characters plus an optional newline, before
+		enabling encrypted userspace hibernation snapshots.
+
+		The first successful write locks the seed until the next boot.
+		Writing the same seed again succeeds. Writing a different seed
+		fails with EPERM.
+
+		The kernel does not authenticate the first writer. Trusted early
+		userspace must provision this file before untrusted privileged
+		code can run.
diff --git a/Documentation/power/userland-swsusp.rst b/Documentation/power/userland-swsusp.rst
index 282e01d2fe61..957be396dcf5 100644
--- a/Documentation/power/userland-swsusp.rst
+++ b/Documentation/power/userland-swsusp.rst
@@ -116,20 +116,37 @@ SNAPSHOT_S2RAM
 	its state on the basis of the saved suspend image otherwise)
 
 SNAPSHOT_ENABLE_ENCRYPTION
-	Enables encryption of the hibernate image within the kernel. Upon suspend
-	(ie when the snapshot device was opened for reading), returns a blob
-	representing the random encryption key the kernel created to encrypt the
-	hibernate image with. Upon resume (ie when the snapshot device was opened
-	for writing), receives a blob from usermode containing the key material
-	previously returned during hibernate.
+	Enables encryption of the hibernate image within the kernel. Trusted
+	early userspace must write the 32-byte snapshot encryption seed to
+	/sys/power/snapshot_seed before calling this ioctl. Upon suspend
+	(ie when the snapshot device was opened for reading), this ioctl returns
+	an opaque wrapped key blob and the starting nonce. Upon resume (ie when
+	the snapshot device was opened for writing), this ioctl receives the
+	same blob and nonce from usermode after the same seed has been written
+	to /sys/power/snapshot_seed. The plaintext image key is generated and
+	unwrapped inside the kernel.
+
+	The first successful seed write establishes the wrapping key for that
+	boot. The kernel does not authenticate the writer, the TPM policy used to
+	unseal the seed, or image freshness. Early userspace must provision the
+	seed before untrusted privileged code can run and must enforce any TPM
+	policy and rollback protection.
+
+	Under lockdown, direct block-device write() calls to the active swap
+	backend are restricted to the process which owns the snapshot device and
+	the extents allocated with SNAPSHOT_ALLOC_SWAP_PAGE. These writes must
+	use synchronous buffered I/O (O_DSYNC without O_DIRECT), and cannot
+	exceed the number of pages returned by that ioctl. The swap header may
+	only be written at the offset supplied with SNAPSHOT_SET_SWAP_AREA.
 
 SNAPSHOT_SET_USER_KEY
 	Mixes additional user key material into the data portion of an encrypted
 	hibernate image. The ioctl argument points to struct uswsusp_user_key.
 	key_len must be between 8 and USWSUSP_USER_KEY_SIZE bytes, and reserved
-	must be zero. The kernel writes meta_size with the encrypted metadata
-	size that userspace may transfer before providing the user key during
-	resume.
+	must be zero. During hibernation the kernel writes meta_size with the
+	encrypted metadata size. During resume, userspace passes the saved
+	meta_size back so the kernel can switch keys at the metadata boundary
+	before the snapshot header has been decrypted.
 
 The device's read() operation can be used to transfer the snapshot image from
 the kernel.  It has the following limitations:

