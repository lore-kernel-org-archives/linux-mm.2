Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A7C607C0B4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lugfFYds
Received: by kanga.kvack.org (Postfix)
	id 0A3726B05EF; Tue, 10 Nov 2026 04:20:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A016B05F0; Tue, 10 Nov 2026 04:20:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2CD6B05F1; Tue, 10 Nov 2026 04:20:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C10A46B05EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:20:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A4CBA056B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:20:13 +0000 (UTC)
X-FDA: 85418663106.04.2B6F087
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A2D3FC0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:20:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lugfFYds;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvcrRKkVitwBIHc8bsc86Ap1TkghVmPhKT6D7YPBbwY=;
	b=gvEhHk1QbT+++w7teQWJTFkFDvusDMNnP8VrbeJ2w1pcVLZHa7HM+DDYZYHyHzYUL3R2pW
	F6HtfgFPeqmdyJmy5urJiXApZAkuOGQ1NyNsjHnuJ2k3YtpuFMqwp2XyUJ6KmahZT3DiAM
	jfsmq7TPKh7UjQQKIppQOFwSUefECuI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302411;
	b=oMjTCtRoN/mSjHpPX5eYtzfvvGC9HA9V5/iJPmHYjBj1GzJPomYfZKN7+l4hsW3GSEve5z
	DSkzFKFVTqhFOmoy29sA8g1fKMvfDSesJoQWuUfUWsL65Cmgtp0QntEPQzZwVekKPPPwxI
	TejZX9sel4rGDTuMxEXxAUV2ChoU7lA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lugfFYds;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 349816381B;
	Tue, 10 Nov 2026 09:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E501F008A1;
	Tue, 10 Nov 2026 09:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302410;
	bh=wvcrRKkVitwBIHc8bsc86Ap1TkghVmPhKT6D7YPBbwY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lugfFYdsp+5acpRZ62DrLNSRpPTqwD6ALObkR4htZDZ7jJ4CwxnL+J31LlzQBLdHg
	 S3Q6wKQ8rLKVDvOjaO/7i9LdpOAAGQkJVKTTZnDkbfMZ0mXM3yVItsw5AH/x4JgMCS
	 r17kh6jTusP0FcEnEBzFzqzJtQ746vPtMKO+E1iLTHLZ7PgzOBIB9SrMppxD4aMf6g
	 ++c6vcWP0wgZ4rHVjr+6Av5KOdeAceVogEGD1LonYdJsm5MlecXYdFkPg3OEFOR0DA
	 l4vCIncvJpwPXykOZGsC4m66wbdnnjiMUoL8mSoluVAzhYGK1Oc9EGsTAAgpOcHIVj
	 fpmwuommLUy7A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:53 +0100
Subject: [PATCH RFC 37/41] target: fileio: refuse files on pseudo
 filesystems as backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-37-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=995; i=brauner@kernel.org;
 h=from:subject:message-id; bh=BDYGZBkzpJOf0luK2Iqx3jSxHLpIeW6e4aOnDtryI1I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDf6mtMEqNwmyJbTeSGX/PXP05KecQy9ejD6kOb9
 /3cf9Hkd0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBETl9m+F99+X7Ky605zSv7
 GErvWk1zaPix/Pxk04Q9+p1/0oTy/pgx/JXbprm34uPtr4v2Ll0y0cL+SOu1/dVOakafmv0qqj/
 fj+YCAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: oke498yunx8uxxkrffbdh81efmpugmfm
X-Rspamd-Queue-Id: A2D3FC0006
X-Rspam-User: 
X-HE-Tag: 1794302411-118983
X-HE-Meta: U2FsdGVkX1/5eio8C1S2QsqXhXWBMnd1kpJ7w5J7pfdDDFeX7wJESMXDglBAyIK8HEEE6flUerudIwTVEFE6ieDuQbLIqWyrk7h99R9BAcTRgvoh8p9J+kZ6q+OiNTdI9mCZzD17WYsWnA8k6Wmuj6aQ+xD3h/jfAbN/qDzO7SCLNf7IE0lgA+YgUYyvdn33MmDep1ioziRlAbGTTNNcmE/fjJd79COfEu8pbs/PXkyLvDYpHmeD3ZjJiXIfXASQa0QY9pULBImgLB2QgtanCatPnVI5VWGM2YXW6tITZkwhTEKLKJW5wpcyI2BPvr+GUmlv83WdQvNMqEcxlqKziE8BBqoXBJx6bbWTyOqX+oJXqcyH6VR3KB4gPwsa8IlemNGv9Kvyeo9T8zIzcBovvFJ8Ofz2aTpho1PL28go54TMU6g168n2+A4d3TTJEEJ730FLtoTKeP8i/97lLKoz6AfgTdrnmaA0O5xA0W3vxzCE5MSVmTKKVKghxRYoK54bY7ReNrui/lzKcl7pzJHzCTap3gPBjOYHg49dj1x4faxnUSlCs+uD97+fXHA7l9ZJG2mo1y95mVMKvCrZIxTg/LLvPd2RvLVay5WC+j3mQGW4IGoVmu2aqVzRzuV9/eDUbdOTyZ7ti5hrttMVW6WJMIjd0LId+MVnF8sPmxBl+Eu3gjqWYJ4EUJcwCrnXAIeCo7h0zlI6PVIV+EMbzs7rtIpq8f0XhEUJkbXg4ONUH6wc+SokFy7uSdR8hRX6ytVBB/72b0kp5EwKJb757XhXJ76RnTOm41h3Cm9FlGIXikQxVAzxlzl1yCaMQMqnmza7NrjDHotrjSXa3SSTRVGmhZUndAMUKGx3jUzx3T3rhsX9KTzlypGtjN3mv7JjfYUdUl5hmc+N1qqCvAI8T7bItQzsNzK55mHvFf6IE1AcsAE1aCmTB1alGIberv2fMqU7ng2bztd4efScBvXlbWr
 Boy9Sat8
 vb7RqgDZf6IgiSs3n/uNXpcVa526E2sTYVwUznx+nqC2/b9//QSFelJzyUUtBG25hb5ihsZUjL9wN+1jhYBbDqRzdWApWRiwvg9RueyIalttvS8GhlI5ET7uJKfHAOSSGuqOsSmvo36uDht4pX8TGlnwi09a+xstkUBMd7yzWotyNwlqw0gP8z38ms4A6IekUSJYbxmXNscR3OXrV/pr0WGJiJYhzVcKKRTwhIez1SX5xN4t0V7eky8+11g==
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
loop does.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/target/target_core_file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index a5391e57e9aa..7a3cf63dc979 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -152,6 +152,13 @@ static int fd_configure_device(struct se_device *dev)
 		goto fail;
 	}
 
+	if (file_is_pseudo(file)) {
+		pr_err("FILEIO: %s is on a pseudo filesystem\n",
+		       fd_dev->fd_dev_name);
+		ret = -EINVAL;
+		goto fail;
+	}
+
 	/*
 	 * If using a block backend with this struct file, we extract
 	 * fd_dev->fd_[block,dev]_size from struct block_device.

-- 
2.53.0


