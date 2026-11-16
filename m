Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1AE06071820
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l+BIJEfb
Received: by kanga.kvack.org (Postfix)
	id EA0A66B05FE; Mon, 16 Nov 2026 06:10:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A336B0610; Mon, 16 Nov 2026 06:10:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19206B0611; Mon, 16 Nov 2026 06:10:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A80E56B05FE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:10:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E66A1408B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:42 +0000 (UTC)
X-FDA: 85440714324.11.5AC1AC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5DFC4100003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+BIJEfb;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMBBwOCxq0RbA3xkr3IQCANlyHiMKhXi962Ec8MHN/8=;
	b=ubvz+NFe6/gbCMSncgoRdhtd1fb8MqakUeiA13wU44hy38kYlTY6pmWzlMg/Pp7/jfPjXS
	/0i+MEP+9Yx9ODqJ8jlvoEiLFrcXilwBkfHpvEQhFMnHA2Ho41i5p+UH0W+zOkiwO3HZWa
	0meZgzhfAyVqeIZ4m5ukiYmja2IN0UI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+BIJEfb;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827440;
	b=fYtPd/8Fp7I0eqsIkrtAOJ74pwaBqedPpwW16oFfiY+LtPI706Yxk17sxX1pbPD5PD31Zf
	X2UYHfTwfsW5lNrcrUnbvjAClrzALwhQfXJyYUCdn5N/pJfaiP4+k+A2Bczy9PwTIdQp5v
	mMgd17xGPBgDmqNNk9TjCyu8w2EeI60=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFAFB462F9;
	Mon, 16 Nov 2026 11:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58D71F000C5;
	Mon, 16 Nov 2026 11:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827439;
	bh=TMBBwOCxq0RbA3xkr3IQCANlyHiMKhXi962Ec8MHN/8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=l+BIJEfbLhnCAiQ9KjFFbH+KikDuWf7Rh0M/jNYiYLFM3JBoCkTU1QtWjpGfqyuFA
	 CSiogIgrJTCRIfQqExj48VIInR4+j/p1TBSDSDU3KHVkiSv4VTwVuUQsOXXPwbSjGT
	 3yic+O5L+OrlvIDI19sfN+4rh3qdY6Q1ReyaauwTlqsXASNdOse/Fh7GmwTFTBPEMk
	 V7YwmUvz678MdFDVA72s+VOIEk7DPWPvjqCbYbQRAxRHaDgQOErh9yRIemYiG+jRQ/
	 TEIFcXsS9+XxNmw10KCpA2RC6gwbTOP/zd6mhzzP3q8aoDPq5vCZ1BkJL96CD5g30G
	 1pPnYhru7oOKg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:10 +0100
Subject: [PATCH RFC v3 37/44] zloop: refuse zone files on pseudo
 filesystems
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-37-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1558; i=brauner@kernel.org;
 h=from:subject:message-id; bh=XfUA5+m77vNauXdxpoCEKQvxsNkJs1ZrQCEAfm8XKRY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etzJVXe0X6Zm0vH193d2OB6eMv+pg2Z/9ALRRoMZX
 vcmSG3X6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI+08M/3QZMiNqd39IqXkk
 99PB+YDugQoTg8Xv32en/V7x56/opmMM//NviaY8nxghcZ4/+eSWhcd/HHTXfr+Mf/LvXWXB0xs
 lLRkB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ikj9mpacdd8c399p7wg5at3uqp3mtpyb
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5DFC4100003
X-HE-Tag: 1794827440-903668
X-HE-Meta: U2FsdGVkX18nlSUqbKuF4wZblNMXjlFek3RnGtNNPVjxnoxm3GrWtkVVAFLiCEZtKyN7+40FR+jDoDwvfK2PYUMqWWfxsqolgEcWE3SJHBgapjXzzlg4DiVhax3Hbm//5GLtje0v0ivu3NNIF8yQsZLSZQGl2BhLUcUodPwK75HevupvHZyZtgNXP+Tu/ii/FIIuvY8+EQ87Dvm8KlgE0iaELHZ6JgpsCeAweA2dBCDapSb3vJQ1lgkBHxlVm2Bk1Sxzrj9RjoYPckGfWh6EHVlOuIPIKM2gs/zQkpnv0eSQXy6bZcJcbXGYQaF0W7tSCpp7hn6xTUGWcLgjOmB3fCUikhtj2HHyZk/sDaRXt0lu78DMIDLLUWlSEsmdPZiBJ3k54LUzHggubtVWjoPIgUGhXQAjnFh7IUkyhU+egIsDi0tgGCCDt1uA5ByTwYIQXJDytr+SS8L6LM3+Uz8kMQ51YSRIEIcgcwbKl9WeNuXJyZuHzmnOcXjGtbQ0Fv6yvVIm7Ej3c6VyJ/AG4f1+1ID7pbrJuxX4SLkjsfLP+hj7fPA5vPx8ekJII8BX4A4YGwas9/11e4FPWEm91xom8cdUcme4UrDzE6IBgGSLxI1W8kgy9685NP8rw4BNU20QUOD1wTavlNtkZYcSGo2sGAf/aKiEdpqlvL6ERyPJ+NjFOpuAPZxNMU7S+R8+nuxeZEjzuGDh1y2WqcqpmrQVb/7tBDkrh25mSbT3jmaXzuQK6qzte8Hh+QH24h3wJIMmWHslC64wUiy2Y9nwFKoW6QomGMLt51Sx73PxchHZrvDquhNqlKpxJTeoIhz0Y6t9R2TN2+lEDXV0B/chcdsJzzPrlG8LuCu2iS63OSPWQ0qhbx0c7VlBLnboK+Vsmt2QxkLoPCSCZEzijPwuxVryvLZ5SJobTyzQK62fC759sPgl3B73Dw6KabhSUzOt61S1BpxQp6ACjqV33XhXlrY
 +oiqhTSq
 nCumHMHU7uULIfZFFOqHxo3TdRJVYOspluXb7INZdFZR7hUlxAUTfk3rJDCGjAlWk6+as1BOrE5ZDCRuIVU97cxtup/oHn1lj5j0X0XOA3diWOCDCkFyr+y59EwOe14C3nE4qq0GwWxYz2+yEoYZNXQMpNn1ti9rySMng+Ih6nJJlncskpFjjJB9A3OHTGg/v3pQHFiNVbdQHS2kkEAqXXZrN5Tk3EHrLs9AoC8tuCt4bw8t+Au03jiI/zCP732qlJhkOMheWuTgvUxPie4jD3a1pKI6K5TK1qILdeM73z7G6kOYiD4Gah/m9iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zloop opens its zone files by name below the base directory but a bind
mount can put any file there, including a procfs or sysfs file. Refuse
files on pseudo filesystems as zone files just like loop does by
switching to file_check_backing().

Note that the helper only accepts regular files. So far zloop took
anything with ->read_iter() and ->write_iter() as a zone file. That
includes character devices, FIFOs and block devices if someone put them
where zloop expects a zone file. Zone files are created by zloop itself
and zloop truncates them to size and to reset and finish zones which
only works for regular files. So refuse everything else.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/block/zloop.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 65634a39b0bfc..6f79b9ddbbe00 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1132,10 +1132,9 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 		return PTR_ERR(zone->file);
 	}
 
-	if (!zone->file->f_op->read_iter || !zone->file->f_op->write_iter) {
-		ret = -EINVAL;
+	ret = file_check_backing(zone->file, FMODE_READ | FMODE_WRITE, 0);
+	if (ret)
 		goto out_fput;
-	}
 
 	if (zlo->block_size) {
 		ret = zloop_get_block_size(zlo, zone);

-- 
2.53.0


