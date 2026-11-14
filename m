Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B986F606D2A9
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RV9gmw/I
Received: by kanga.kvack.org (Postfix)
	id DFB006B05F5; Sat, 14 Nov 2026 08:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2826B05F6; Sat, 14 Nov 2026 08:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC1906B05F7; Sat, 14 Nov 2026 08:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC0DA6B05F5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:10:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 555951603CE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:10:10 +0000 (UTC)
X-FDA: 85433757780.27.338CC53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9312A1A0004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:10:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RV9gmw/I";
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661808;
	b=w3PUX9O2+HF/FNSVN4/zhL6weETtmRxxe30nquzfPLyWNsQFXiRpGCeL0rVkPyKjU+yjEE
	Ej949j9IGvUIdpRXrvh7bvloN/fcwmPZWF2B6gcXamyHwmOpenRfCUAKLThiQmd0QsHnm0
	k/m7nMlKi7Kwjhg+FFTRbkZfDVw1J3A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RV9gmw/I";
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSBUELtQKf2EG5AQcZbSbpFUNRQ3ThMifteDUnUw1To=;
	b=1RLHsJuD7kg/aCokngz38cEO27VZxf8tWQ++J1onYRP8WlEo7B3T1O9UKY2Nl3wHKoof5y
	JBGm8pZ/2L9FVRP8uzCIbjJ4RocU1OUXyWhshJeXcpp0z7/ZlsqmRcGPn3tsCjUYGv/2VZ
	IgVyCx7WPHsLW4b8incmhHyibvNi/sM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E86AE435FE;
	Sat, 14 Nov 2026 13:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F8C1F000C5;
	Sat, 14 Nov 2026 13:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661807;
	bh=CSBUELtQKf2EG5AQcZbSbpFUNRQ3ThMifteDUnUw1To=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RV9gmw/IAOoiKg4/iNqtweBRGlddT1o/Yqe6wuzCyD8VZR+CWkIVawaw49hfqSOgZ
	 LctRgRWk47GTCBDiGaQYXyx3osf9jFCWVX6/4A243zHKRAFMEnHt6oSDZPt1Q3OYJI
	 xwKdwDdCk5AwpGruPZr1Wf6+rhKPq/Z1HobRzMCY/khSkDIxOYcv9lqM943DQjUUM8
	 lWTa+bTex+LmfRUrVehDn39PrMRQDaO+u0L/y3vRLKndUFxbnRtH82CVr7tByoSsCi
	 Y0BYSO/bZGoiFG49r3hOvHcCTFZi1rD/XiyUYUN+nayOXVbZE4ZmNi6jzymzv9U5rG
	 8O5DHkba2DaXA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:20 +0100
Subject: [PATCH RFC v2 39/42] usb: gadget: f_mass_storage: refuse files on
 pseudo filesystems
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-39-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2103; i=brauner@kernel.org;
 h=from:subject:message-id; bh=p2zQzeeQYbSmjPnrcL8CGIlIEeUTXjBe/VYk5piLT0g=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iJl8gOHaSbHg71O3XtvEHKC99CeXwV5LY9vXtX6Hy
 0KahV4t6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIzxKG/wUnFu/4dONOSFWW
 9v51fvWagq8WCV5ltWn4+rNn0faMRVaMDKtNI9Ywyv1ozvo9gdHGVF3Q3tJHcOL89Ukvd63+Yhe
 QzQ8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 8n4bhjc8ohmucegfw4ugdb6pcwci5mkd
X-Rspamd-Queue-Id: 9312A1A0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661808-582456
X-HE-Meta: U2FsdGVkX1+vmuIKHgPrTL4/78NkPNO8blJq3z7IrXTj7kJ/UcIsW2Zr3HTFagkaM9nqOrhkWaR20UkeXnVWPj+GzZuaFGZXEQQjGdPjHBEhodchejIhe27EvpcKAp/fjEFmrT6/9SfMug/SoKnT3KFEJm2qc4sy2g9T7tzYNGnH9T9klv1FFz3eYWl9tyqhNPl9ofbrvLr0GGcg6LPFeI8mNHLzvalLBSX9z5XH5bVFLH05OUQNmIM2O+m/mQWd8t66DeOUPB/Nw5T0MK+T08+AnqBxUEZut334cXaxq0cOB/3k4mSDNJ7Afj4F43Ztndie+6kng9fBeXLCYa1AyMDzx1W5NWR8v/dPEuFZzjGkkgR8+iGWYTBaL1ukKUL/2ynvx7lMR5wQjpc2uCJf0UXWLQUI3Onu/apA0Y21WBKr/oA9eg6OEjYF9jthhg/vYfZTNC7TOJaLbrxd8UOnFtNjxSIEI3f7Cn/48zM0iwBDw/nImkSlcIr4++hOQT0BlZ3R9XLeWG7F1GrcUbz/YhgD3XjPJSx0zuEJmte6ac8rvkCJfDxmEQt9CeCfLRm0C42Ft3oKEt6A7avtEv0L/4nx2SclugzId6+B7Zv3X/5BKBsePmmgyVwDHD484y77YZYk+tTq5VlEdmbOQnt+viX8Elt+YnzaVEz5PW6cU2uhgpvLhTxVhDPItpPWwM2+b+fCiMfRCX+w+ocIQmKXJNr+OYj73dBV7uAQe8ygWCB4t18zLavm6QXSc1UqLE0O6rnH3WSPspoCSPbt0iboQbOIySBVKWUGR+e3BWoJ96s+Kvrra4+U2xie/TfJYmOEbrhFgRDtKDsQpigQPhhKyfDJkJZHwoEJBnJsmiuQedCd3dBp6Cif1XbCpjmOQeHav5wB2DlSlHRg9TM9hIl3wK1bLbNrd4Xlv0wpk30JgKR1Id93uno109YMtSt30V+R2/mZMqZQdlZfL1Gs1eI
 dFndQPNu
 pEtejyClAMj8jMpvCL1l3oFUgbF4oy5AvggZEOyDPlIhzqb7oJgyrovqFP2tpKOo7DkewFkMCp/bqDr3A7sgiHgc5vrtE5tXJYsS9F9iHAqcPSlBQr/ybjA23zP7nABsKjK8EdaRMbB2uwY2uSvDrqUSIFsKn9Hfb8SIh3UDMRR+rNO73QPevn1k7+Ekfxr7i4dlOk55inEojj29R6UckkpYRn1FQ3QDv3/hafxAbaKO9fmcHItOT93a7sS4TqwjY8WvRQIeNC8Se120H1fgsWl+BEopqmALe3ywD
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


