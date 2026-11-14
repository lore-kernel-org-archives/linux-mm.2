Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2317606D291
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ty8/r0So
Received: by kanga.kvack.org (Postfix)
	id C9B386B05F2; Sat, 14 Nov 2026 08:09:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72A06B05F3; Sat, 14 Nov 2026 08:09:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B625D6B05F4; Sat, 14 Nov 2026 08:09:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98AAB6B05F2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:09:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35DC21C0F5A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:57 +0000 (UTC)
X-FDA: 85433757234.09.F7511C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6F727140005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ty8/r0So";
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZyqvTAJYFugTtfLrdTGe2itrOrTKvVMIRQURP2gQHw=;
	b=AqZQTKU18HJTDEbeuklriEAwDkaf0iIZyeldet2wgQQ1es3sQ4b36QYoe9khO/AkbHWPPP
	jlJV2nGmxg6p6UI7ms7nGsjQUy6u3PmYIouR8KViwGJot0TzLXhgwJs6GNAg4FKaaoD7ub
	TLbMfQ+I22BKxxYDVc9yX/2nB+14+nA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661795;
	b=4fX49P9RV79+/Igo6s8syFSJ2pbDcZoBVs2Ycsn/qs6bsk6G2oowJZTijVscgEzcF11qLu
	ZlUeuHgT9aXJfPLpsVeoOhn+wcatTSV3rwWhNJOY2KqfXirMcfouJCFuZMYaIKbdcdgddl
	xqbjmZU4Xz/7XGqgScB6kKm7VmbOVzg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ty8/r0So";
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFD284657C;
	Sat, 14 Nov 2026 13:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE891F000C4;
	Sat, 14 Nov 2026 13:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661794;
	bh=fZyqvTAJYFugTtfLrdTGe2itrOrTKvVMIRQURP2gQHw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ty8/r0SoMUqxO4LrNlfBZ8jM+8/0m/Yce0IMqMBaJmgGc4ZGWPEqHBehqsfDPy+BR
	 7ef+eIqu+WmvEMZfLPmETCepGidhu2UkGPQ0nTWhjjjuRnwcFNiN6JzDR1fRA1/ugZ
	 Sn6LVjLv9jAcLEQBHwoyMpIdcNUEDbbRAZTR3aGQK3rufuCJq/cnndIhDlgUJy9O2f
	 s8N4jEwp0PEH9JhOgls40BEgYiB1OOpcBsPu5jb0Z8jZteTY7OSFJ5bvMKLOtswjjD
	 pCiBAvVrnmgUx9Fr/vgwDkzbuX+HpQAkfTAlSP6UjZymqEm2v8y36GJ4FGcks7sAfP
	 jVvqXF2NJyHKA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:18 +0100
Subject: [PATCH RFC v2 37/42] target: fileio: refuse files on pseudo
 filesystems as backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-37-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2129; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xgyzkhEOeMIb5OW3d10L8uW2mAkBVhLOiqNzKM5XfpI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iJlQ21ua5fP3d++vyX77z2zLm/wtYK6mnmdGnefJJ
 ZPudHDadJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykWJ3hn07xtqPzj9wUZ7vy
 edLyTyHJHLN7PitM3LpayFxXR3yVlz8jQ7//U8b9N/kvXLob3vlgj1P9psj3Uo6hOtH7Hi5Onjd
 1NgsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6F727140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: exw9n9yyj9zg7z11inz3qgxm9xjomemx
X-Rspam-User: 
X-HE-Tag: 1794661795-807597
X-HE-Meta: U2FsdGVkX1+Il1/3N3WR4VTCRz4+m52LGR7fGZP+53AMGARxYRLvl58+Jrbuq6td0Daq2reTUmdaKUqg4QcD2UtwjTva2s6tY1k46HMaUypGf15BgeAnMZkvVGY+kB4K1ObntFXLqGvX4whcIH6jRtfEvFLpM5Q/F/PQFXre079YRI06UlZLPO1/nq9qaZiSKF2apabD4tpHcpfuv17DJ0u8tUTg50Pjipo/nNuE2lrGM8gUoRJw35GWHYMm80HaY29/mbvs7TQdktLaOOuWEGxhmTo/UnPVro7yYH7DCxtD9kvneH5AwbgNuiSXffIa8TqpSFkKMx1UTJZk/H2qYmvd3wRdmzmNdCXHYICvcTFNIXUjmwY51ucwYquh6wUSA3nPZ9zzdtExVr5mQ3S9mK89aDas9KHanPN84CdEo3s++zZIQF/RRFCxp4btdwpMYmwXooxSVPyH4GZSupEOhbHtbcdUxI4WvjG6M27o3oeG4QnmBEX7XnhFQxsN1/PVDEhvnfp0IetmEDi3xX6HuPSlIUtAxBwZt4wydfVRnk7OUUMUqZnmIxitGFq6hThPdZqQwblW64cAsJtXIU1A1TlB/JoJTYgOyqIFgeNm8kE2u/wBBxb9opoHm5owCCBnkS9/NhFplxGSK6AU77Trh2VZ2e+N6gXaQO68/4Dcn9i66u3CsFXrQNIsgl224Lfg4M6bnf4UNFP/NCv3gIMyj8UUlkcC/Izwaq3zkIoE8zNuWlKo3IxkMjT80vI1RvV28KTJ5DdzZaOS8AzfQtR5lJZzS3zJUJre8475PiaDPo7AD0tCiwUPoNnJFNHBPs1W7HaiCSNImyULtT98oQ7/uiqTIy/Fy6wEQnB73qsMe14Hlhw+MxnB4PxONrBnhTHMBz+okhZULWyUsMpK26YOM3p8wydEiFXBeXUotlU/975p63DDQmOY9JASxzusAxbkFPJ7Gn8MrtB/Y4BFnpu
 Ieqwm7/F
 jVvXtXoTfFl+kRX5bf+MjzcPLB9qt6eb4rZrJZpT5mUQIx+pSe+irF080Mum0n/6SzI9FgGRt3p9q/CMJNEZq9YL7jYJ2WlXmGsf3cyPfWe/bWogDg2+pKaVHP8PtqQohGdv8eRVmqTTE43OIg4fXQGuZzoi+WZFovAhUZKeywpXLZhiKyhy0NwQ0n5CkcxTCes9ZcF3UyMhaw/nsjQFtZRYhZ6VZBIepxF+mHNSvbWr1PVRZ21RX0Dou2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fd_dev_name can name any file including files on procfs or sysfs. The
initiator then gets to read and write kernel interfaces through the LUN
with kernel credentials. Refuse files on pseudo filesystems just like
loop does by switching to file_check_backing().

Do the same for the protection file. With DIF protection enabled the
fileio backend keeps the protection information in a second file. It is
named like the backing file with ".protection" appended and
fd_init_prot() opens it by path. Whatever that path leads to was taken
without any checks.

Note that the helper only accepts regular files and block devices as
backing file and only regular files as protection file. So far the
backing file could be anything with ->read_iter() and ->write_iter()
including character devices and FIFOs.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-206765@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/target/target_core_file.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index a5391e57e9aa5..c747cc4a647ff 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -145,8 +145,8 @@ static int fd_configure_device(struct se_device *dev)
 	}
 	fd_dev->fd_file = file;
 
-	if (!file->f_op->read_iter || !file->f_op->write_iter) {
-		pr_err("FILEIO: %s lacks ->read_iter or ->write_iter\n",
+	if (file_check_backing(file, FMODE_READ | FMODE_WRITE, S_IFBLK)) {
+		pr_err("FILEIO: %s can't be used as a backing file\n",
 		       fd_dev->fd_dev_name);
 		ret = -EINVAL;
 		goto fail;
@@ -861,6 +861,12 @@ static int fd_init_prot(struct se_device *dev)
 		ret = PTR_ERR(prot_file);
 		return ret;
 	}
+
+	if (file_check_backing(prot_file, FMODE_READ | FMODE_WRITE, 0)) {
+		pr_err("FILEIO: %s can't be used as a protection file\n", buf);
+		filp_close(prot_file, NULL);
+		return -EINVAL;
+	}
 	fd_dev->fd_prot_file = prot_file;
 
 	return 0;

-- 
2.53.0


