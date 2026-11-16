Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A936073C41
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NaYwloll
Received: by kanga.kvack.org (Postfix)
	id 3A4D96B05FB; Mon, 16 Nov 2026 06:10:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354996B0610; Mon, 16 Nov 2026 06:10:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243BE6B0611; Mon, 16 Nov 2026 06:10:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F21EA6B05FB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:10:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BB7DC093B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:49 +0000 (UTC)
X-FDA: 85440714618.20.9457571
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7973AC0008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NaYwloll;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zLEVq+Bpv9BnXZuXWTCC/0nvI0V4xS0vAuEcIsGc5V4=;
	b=JLz1FunKUhoYyUVZCOyHqnAQFiDqtcD2DILhrs+hXDW1l7K9y+VUPeKszk8YYReRGOPgIA
	qbZnXnsklQdBZOpmbWnSZvIuJ7CMrUsNN0zMfPmK4OmCqmU0ZEh/GtegLLlXBHisn15yHt
	1zvZQ10yMWv0QfUBpXDBKVs9O3DkYos=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NaYwloll;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827447;
	b=WOZTPM+TIf/rq5wQT5+mUqe7eQmnRTxrkswQxl+TGqcoUBaRBpxLVe3uhwdEAyjD1phjv7
	emyUnIRZjnaqEc0YXw9WWYE+EDym0OtauOCGc6DU301/NxvOG1LNPl9F4RPaNa4mv04lMz
	CR+CYylcIGYIjzRCW8Uu1nyv7M/2qh0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1333A6296B;
	Mon, 16 Nov 2026 11:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C3E1F000C4;
	Mon, 16 Nov 2026 11:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827446;
	bh=zLEVq+Bpv9BnXZuXWTCC/0nvI0V4xS0vAuEcIsGc5V4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NaYwlolld2jESWvGwOaWTxEbVaAHPZNh1LLvFE6S5MpCcqk+cf+N1nQf8Dku2zsdc
	 XyHOtJ8BMGc1mA3Vrxn4Eg8Q093MTrz9Iup09iiuZHg7wX4L2QsIw7SS3rcteqNV4x
	 b2D0jxB3MFKFxVIJVhXxLhRSg7PnHC/W5FlkEc/+kxEk8S4+luBw2VcOlfQxewVtA2
	 Je4f2PghzObAunRtq7HCf0FD4sQiGwd31Mb5U6ODKV2wDoPSHpEqY7liE2IB/srDhO
	 TJV0xsiM7pK3poFBzZlAc0Ax4uP8AaKDIftyXzMvuQ3xcrXUli/E6mrcx/WrTrnOUK
	 ao8EBSnzLQ2lQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:11 +0100
Subject: [PATCH RFC v3 38/44] nvmet: refuse files on pseudo filesystems as
 namespace backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-38-8cbbea1cf34f@kernel.org>
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
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1522; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tRTfMWpi6lEvvGl+lxY+pO25cW/8KtdlIZFwjvLJslM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etxtsODnTr4jerrvH7gkzS+68Piv7P69JfsYWHfKz
 ZL03KHzv6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiu6oZ/nC0OV4+zWbuG5Od
 WKaZOmHv+rI3Rj5uPGlXu0xNsxL5oxgZJuv++PSw7/mNRcX/gqK/z/nk5+TzYvUj1cNC/H+yOEQ
 Y+AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7973AC0008
X-Stat-Signature: w8ernnb97np4dupd7iipyt3te6ngzitk
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794827447-814914
X-HE-Meta: U2FsdGVkX19P/87/ND1YXbxsXDymrqskRtEWAUOntXYx6YXAFXDtc3GwIPCYDGkP0MVlFzO/OkKyDBsHuNpagUpRNJ2+Gdtwf95GBKWJoZEpBBC6F0Co6dsHE7c0GExjx+oDWic6Cn164o7OHGxjR5dEUHmhf7eCfEaR4YvjXmODAxKAZPmC8SU8J6qRveHNv568kN6MRE6HoCPZxD1Fk0d3w3+vNhnQg0onHRq44Bm3d2H1q1GP9sDtNsrafsJXKw0rRSXPNxIshi+mgjgKYvvcVgwDtn74ZBiqF1KSTDsr8cN64zHqGHKBTez33kvnRKgd5RdM0u9/+hwBGMBetTxr+3TferAYOfAJ1dXyCj0uwq8czSUlT00haIeqV+AyqGAa8G7/1b9LnxC5aiVm0LbDfiRJyUylHFpHiPNg8yiGLgtaG9wbSl8LPpZw854NVzMB75GJW6aJyYulNOxHikVSglW5t8EzncSW0iR7wxbe26OtgAw2L2jrCXjK2STKzCqm2imQj3SfDhiAdqKvyP9nUNAZaD8zQoSUOY12CsbM7jL26AF443LBngrSi7rX560TXp8lLhOwIl6hkOoWdNR93VI9dVghEYiMNSO2d3xG1E74JByp3j9AWyCIbARdmnp6zP4Gw1pl7ex+OMpDvpnESLObCSuERxq2kleuKsUNOF2VQmwDbCYQDbEZc0jppW+s1lbsHW0DX0u24eeZhWcfv2oFDRKQhvYBud9NS6LoYUxeaTQivBSMCWLDezxBCilr1Gcrhf1Yz+UQIvyXDh4AV/6fhm/HI3FoNw9BZ7aefWp0Esk50zTF3su1h2ptxc7yCDzAVISFsPXshX0XjvJwELZF0Jz9KDFoW7BOnrCwZ8WAJrim5I+wLtenBbHW6XmvdWBsH66Yki7ocWoXYI4wCpUOa6ZD+gu9MtDKU0EZZFM+h8y5yfCw2DIbk4Z+kuZsjFLF9QYiAXpRbIA
 ai5fand6
 0pCQ4Prr1lWTf0Aq1I90aHN2PF0E2GqHVydYTo4Ny+1HrmrvREKu5dlaZ8qtZO1KnLDrYJJN1fJWUANkroHKFleRjtGxvdLjFPSGdr1J59VGz7IM7KDAP64LGONOTv1lGtQlknmorrBPR/JDrN3/Jh+PkPk6UTms87sSfaxwsZm2Jm7mUVrpVZMCXTlRoL+mGmKpsjteV/ONW8Yavi3hmXdqftQZ0WPykSG2mB1Um/UNFOrT+c4JduD2jfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The file backend takes any file that can be opened for reading and
writing. With buffered_io=1 that includes files on procfs or sysfs which
then get read and written by a kernel worker on behalf of the host.
Refuse files on pseudo filesystems just like loop does by switching to
file_check_backing().

Note that the helper only accepts regular files and block devices. A
block device ends up in the file backend when buffered_io is set. But
so far the file backend also took anything else with ->read_iter() and
->write_iter() such as character devices and FIFOs. The size of the
namespace is the size of the inode which is zero for all of them. So
such a namespace was unusable anyway. Refuse them.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index dfa8aa46188c8..2249ad3bb46d8 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -47,10 +47,9 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 		return ret;
 	}
 
-	if (!ns->file->f_op->read_iter || !ns->file->f_op->write_iter) {
-		ret = -EINVAL;
+	ret = file_check_backing(ns->file, FMODE_READ | FMODE_WRITE, S_IFBLK);
+	if (ret)
 		goto err;
-	}
 
 	nvmet_file_ns_revalidate(ns);
 

-- 
2.53.0


