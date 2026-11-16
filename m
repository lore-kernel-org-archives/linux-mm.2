Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0D476071B10
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b8+ShhPz
Received: by kanga.kvack.org (Postfix)
	id B94D06B0614; Mon, 16 Nov 2026 06:11:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1DA66B0615; Mon, 16 Nov 2026 06:11:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5A06B0616; Mon, 16 Nov 2026 06:11:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73D6F6B0614
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:11:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1133880519
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:11:11 +0000 (UTC)
X-FDA: 85440715542.07.72D7054
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 48EB540006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:11:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8+ShhPz;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827469;
	b=ClM/n5DfdpVMIQ7XW/NznwngZwXZrzEN28wf2TuW//BfrUCnBY+8scGLJzUL676+VaKNTE
	BjLdSJLkR4OzSjaMyKLbB+Jr8mGR6qPMEDrYjYvXb5v3Bx4aDL50Y2Na6ekpmHhjwElfw1
	pUqYlyPRsjPUekJdAPuz1tP9OvPAexE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8+ShhPz;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OTEjlmIJyKpC5NfEWKTxGQBI4o98SYAhIwo6Ai+LDGM=;
	b=TLX7PlfhR7CNmuuEj4V4weFfXJ6sGZzCiLUVr+R+Pt4VXD/aDKM6SFhjJo1ze6IBvnWBgc
	r2QHyr5JTZ8VJRoakN8ZqgA8rOCKpSSzBkjd8Ytva8M1mRrle1j7XFeuQYv9LUstyD95oi
	+aqbqKRO3p9i6acyOyqU4ShUQmXaxvk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0A6F62964;
	Mon, 16 Nov 2026 11:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90BD1F000C4;
	Mon, 16 Nov 2026 11:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827468;
	bh=OTEjlmIJyKpC5NfEWKTxGQBI4o98SYAhIwo6Ai+LDGM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=b8+ShhPzXQ5lKArD/6+ZRe9DOjMyoKKAtnYUlLtEIbco9DLALBR0Fd2WDzfzWc/xq
	 +KykUFg8yMY6Kd78+glVS3d4yeckJ0NZgym4qTmABG1DSqtV08TKvEgKTSRPYYc8FP
	 3A/zUYyTBLJdxk3fLBWngqH38gEefnGvMYwPDcaoLTEerXzCHabY1vE4quu1HkYEqI
	 xK7UXhuJplVmiu7BnozU6NuKxVhigBCbUzntJkdDKhMU1U4LXEjJVGGRKv6uioBtRs
	 sd3pKHijxRAVRCt9esuvtmGbmGhGQspe3OfnCiNM1Ut6Q2kagZYzQsqGYzonRHSJSV
	 uP0mNwhmOYf2A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:14 +0100
Subject: [PATCH RFC v3 41/44] usb: gadget: f_mass_storage: refuse files on
 pseudo filesystems
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-41-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2207; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9yOpMEvSpwTZ88CI4cJoJKFDpbu7ZmjHFE7v8Gz8hhc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etynd0NX1vPeFOdEtq9nL7ydJOxr3SZTcqJWrC/8P
 8+eTSY8HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNpsmJk2P/2xMUG9fKOCS+q
 pmtt5+OefHRG0P2je5ZsqZU7vHHpSW+GvxKn1gcduJD7d9+yy53iOseiZErr8u6GsuasXRM//eL
 OvXwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48EB540006
X-Stat-Signature: bfqzcqfg6aasxn4pwgaeyyutm1e43euw
X-Rspam-User: 
X-HE-Tag: 1794827469-453386
X-HE-Meta: U2FsdGVkX1+fxr1quqsq1GCbJVpG77hCvYVW249MK/Pq67K4gm87dFj4pB7w5kK31JNUuyqZqCwKK07rnMtD6DHKprvCgqMo1aIxcFjSjK7xJbqP/yGqOBejvopLOSJHkciv/RrhPa2sGUqaPcGSR+amgzdzKNjBrLoZk/SQFzv67A0Ok2Pz4jXQHEE+OuLmFXYwsIzXNMwaO/+kwEmxB6vmbKyHpqSmTjQRpiSZiW7A4F6O7Z69cKMKYCbyPhWGE1ulFxiqLx81RggpSrAOMw3GyeZ+ScrjyetFpP0goovRcD4EnBnB4iZQjnIeW1jle+r6q7d7p8MKLhxCQy/j+nK0X50hb0ZPgxgLSzMGUbNwkdt9kLTpV+ULdSwqYvUetj0t/6pAVeZf9nJemAetEwTzuvTgZx3qZOqz1WLwcKvfKE+my+59qV5hgsU9FMV50IxDJ3xTm/tlxIhSzDZfHbpjPPoHjcqI/JXpmuZHF8IcxwnCDzy9gAswieYcLPiahPY0/ssBHKxyYUit0xupGPVCbCE9d70EKB50JdihueQMMWq6NynjbscEhZhvgd5t5fBFkRhtqwfv5QJxg50lzK+yfgXwo2mMCyI/DWaLIaXfng7hzWZNKpeoFgOjxmRL18N9hsIZA02wZ43U2a3h384tbcQnAwND64/KY6JGHhMlXJOf7azjeWN4yX81buOQibrfd7QKkEyeakxpWSws4vpwxfg0iPPjGb8vk5ndTQk+7MPAguI+9gA7c0K0i46aKOR3nZy0/4VtbiSD1Vz8xL8VnSRz3MaENCXa9LKtQBXMBwl/MOVHDR39iyDX0mY01gniFzSAE3j3DiO0ZOGZVZUMDKfypIXh4hfQ7WZLu1Bzu6cIw/lFBHkXsOzVr6u7CKMrw36TxhwpQC3DfHsO5+F237nkRIE2E/NdC2YlIm8a9ZK29x06G/lEdpNDPO5I2grIOEnaeXqogxFfb8L
 aOzZtEOi
 ONj1crQDIYS9+AO5hqdTWyXD1OwZYRSLJNft0q6OARfY8BcTelYM4YIUk5zLEHS1wkzqGIbQVJNoLaHcm64I7L3zx9ykLpFWZIUP7adCrXR1ypQ3EgQVX56s7K62FeliPLVhH5fHdptB0+dy/C1ZXm0LTwMq/3tjMGyM/FqrlBEvQBq7Vho7fXfK5WLipvAlfMf+vAubMClQf89NQ6SdgOzlShpOMrj9NKJHAZX9KpqxlekPY1+gP1eXmMhIvNlz2nlLWUNUnv1JGkDLOwQD+evwqNAZE5gCrOofXTAjXv6JhumuNGTHoe7ddVCRCdv5W2sb0rg2WEdwdOM4AY8fi2DXQU21s1Vd1y8xB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fsg_lun_open() takes any regular file as the backing file of a LUN. The
file-storage kthread then reads and writes it with kernel_read() and
kernel_write() on behalf of the USB host. With a procfs or sysfs file
behind a LUN the host gets to read and write kernel interfaces with
kernel credentials. Refuse files on pseudo filesystems just like loop
does by switching to file_check_backing().

The helper also does the file type and readability checks. So the
messages for an unsuitable backing file become one. It looks at the
inode of the file instead of the host of ->f_mapping. For regular files
and block devices both have the same type. It also wants ->read_iter()
where FMODE_CAN_READ was enough so far. But kernel_read() never worked
without ->read_iter() anyway.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/usb/gadget/function/storage_common.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/storage_common.c b/drivers/usb/gadget/function/storage_common.c
index 75831f2c7abeb..af0c37a9fe029 100644
--- a/drivers/usb/gadget/function/storage_common.c
+++ b/drivers/usb/gadget/function/storage_common.c
@@ -205,23 +205,18 @@ int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 	if (!(filp->f_mode & FMODE_WRITE))
 		ro = 1;
 
-	inode = filp->f_mapping->host;
-	if ((!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))) {
-		LINFO(curlun, "invalid file type: %s\n", filename);
-		goto out;
-	}
-
 	/*
 	 * If we can't read the file, it's no good.
 	 * If we can't write the file, use it read-only.
 	 */
-	if (!(filp->f_mode & FMODE_CAN_READ)) {
-		LINFO(curlun, "file not readable: %s\n", filename);
+	if (file_check_backing(filp, FMODE_READ, S_IFBLK)) {
+		LINFO(curlun, "invalid backing file: %s\n", filename);
 		goto out;
 	}
 	if (!(filp->f_mode & FMODE_CAN_WRITE))
 		ro = 1;
 
+	inode = filp->f_mapping->host;
 	size = i_size_read(inode);
 	if (size < 0) {
 		LINFO(curlun, "unable to find file size: %s\n", filename);

-- 
2.53.0


