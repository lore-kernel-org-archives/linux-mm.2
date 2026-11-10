Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88328607FB5F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eIJ0bZ6Y
Received: by kanga.kvack.org (Postfix)
	id AB4DE6B05F2; Tue, 10 Nov 2026 04:20:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8C2C6B05F3; Tue, 10 Nov 2026 04:20:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3256B05F4; Tue, 10 Nov 2026 04:20:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A83E6B05F2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:20:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 184D980334
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:20:27 +0000 (UTC)
X-FDA: 85418663694.24.2411195
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5A7DE160004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:20:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIJ0bZ6Y;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5v6oTkZQz6qlfBhdJSuXnvnO8rYqx/rzC+7+Nl5/OGM=;
	b=MsZjWW307Mi/EWZoqQgmOVtZGsFq1xWy+6LmvmYeOjJyN/UfZ6fGMdmnfK9I+bptcy1w/1
	7RGxaAOYORTcWW3pFlz1yfvKBH/9cvqkeX7T/WR6NE5+hR0OvqmgByZKLWLiaPnMVNka4E
	ukQ8DSpbeUR98fAZuSNPAnWb5aTxtH8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302425;
	b=qPzJZvdGAHFGFUg/gFP6ImNNnBIJUWLBZL/bPggKaTWdQCAgErsrlbPXjwl3lAH4a/L1bJ
	EVfM7ffPulcDgPgJctyZxT+EQf/U2NaQ4Foh41FhkczbChCtJ/N8lKj1I4fonyBNoXoDpl
	CKGZnMS0iXa542LnVOOeP5Aq3Dgqqa0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIJ0bZ6Y;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF33663821;
	Tue, 10 Nov 2026 09:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515E81F0089F;
	Tue, 10 Nov 2026 09:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302424;
	bh=5v6oTkZQz6qlfBhdJSuXnvnO8rYqx/rzC+7+Nl5/OGM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eIJ0bZ6YykzyfYaq0uQnsLuPNj+m0vg4MOIRUUV7WyIHrzOWlMn5BpzKyvQO1xQnK
	 lIgHxLYXr0xM6gXAPduca8fCpGnrbXmRu3n7sX++lmrPokRdnMxOQCvAaieuNDey1/
	 rDMY2lnbcyTg88AQ5EnW+l0uOlH6KcCfGavMFZPvkrzrCwVDMo4o1H9usL4RbMeid9
	 8ju7v6AtrNpyzqVV8uy5DYhL2Vr+eLE/ymRsWc8pcaS97R4A8Z95dfIgLeSJCXVpWi
	 mDeT0clD8WfcFmQfLKdl3Rcurbo/W+eyqIPzNmzhefzjE4bnqF8y5kxjx80v9c4Gko
	 v/as+SN9c7AFA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:55 +0100
Subject: [PATCH RFC 39/41] usb: gadget: f_mass_storage: refuse files on
 pseudo filesystems
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1124; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5CZmEVUvUM8phb7GCUC0PbdIONUtutPPh5jN88b8MUg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9enDwpOymfbk/lix9c8OUO8H7nMDJjqNuYfXt8RN5b
 SZ7VM/p6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIsgXDP81qmQUMxt7JIhtj
 H769H+D76yOfp7vrv8Uv+XNqFL+3cjL8szGK7szT6zNcPi0pgC3zv/C19XHNGld3L/vwMHyKxLW
 bjAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ygkwby15r7o1ks1kjpsfscup3x68apti
X-Rspamd-Queue-Id: 5A7DE160004
X-Rspam-User: 
X-HE-Tag: 1794302425-867888
X-HE-Meta: U2FsdGVkX1/1yiBC1P2m3UxfJ0U7dFRuNw3DOnH5dJfERb43z161vc0mh3HJqxPgh+fG+QY9oPipNmKZRV2LG777Ae7tPcS91W9AOYzcoVUicCB/czeCADqlijiUeS6Svv7mIEQd/U/aUwlfc4ks840G+lt5S/bC1V+FCNzEiA06ZVRsp3faICHs6J2wpiQKH9dzoJ3dz3JDiADLbiNe4V9wSbF+d/4xSrt0lNjW0rwyNTdf65qp8Y2SJX1SwA+wUZLLxgj1IJ+klvnyVNP0zW8uFiytoheLXWZzG+/THjTsUPP+bbT0r1gUl1PeevtkHyduK88QzAQMNk3Dx/VOiwIloU5x8ZdSgSBhxQUH2QQyzyJU+Kb6Pjr9WLYj2obF8C3yoROl9eB5WVEPuI2kPP8IcGHIc0Sa6bRe71L2PtBqjF07WvTsGWTZ2tYnEl10qvF7Nv76bLj/kjdTVlrICBYBZnPR5Dx1d0ivX/sxT9g6NME7mS6yNPUScDesFSDb02Oj2fZGqzicMQ80E0cpq41erm02pJ00TdV08JS+8fLNdYh+fthCD9UhRyUyFErw/tych0qwooukwhZIgesmHla0+OWFmaIj/0S8Bt24tI7i7Xc6PmqzV0szOGzqEspcKah9xj+eT8djVg8xhnpER2NagivMDCEhI2deGk6J6af1izUU+AnYZo25yuyuDJaDgNwBkSgbp/7RGJ0VLgOOECrtMMsW1qVL6e3vtBLKVK85WXqPGkYS6ylz9MAzhPEPXmq66i8m3q12MeCFa+uA6jf2h0t8XXByW0sorBFl563pNHvPDVo0hv20USRtGSyR+WhJfuc32LvPFuc7ccWRnyUDhyGgGApNrDcdqtLlVnxoTOAPOM/ByRe3HpWzSirR3sBTbC6UWzm1uab0f+EOJl+EuPgwMF4tI0Dpkn0yM/1pR5tKyE7zwaR5lJjrXNtpXm8yTrjxh3JQiWqkZcw
 8tSve+61
 7xpHf8s995MiY0A2humO6UfoMmc/YVkRRE/Y8ODVGfGu5l+zb7HeR8Xn+h5wObeuRRGuX2RUPo2HeK4z+f0VkAFAlXCCitnFan3cG84aTLV1DZcALWr222G6VCW5xVc4HZ8LmPt/tRtFDAQ5Vwh0GnQL0z42C1Y7YQSG/wCrmfN4I7gZvr/QyIurlItWFmhpMwOq0uzycNtLp+yad8Ky7bhuUinOpL49ZMxFCP2wXl6TDjSkrn4eLHQ//iOaCae0sq6nw1YzUlXJJaZjAYC6v4P/GtAUuBXX402Dq
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
does.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/usb/gadget/function/storage_common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/gadget/function/storage_common.c b/drivers/usb/gadget/function/storage_common.c
index 75831f2c7abe..83683ade20c2 100644
--- a/drivers/usb/gadget/function/storage_common.c
+++ b/drivers/usb/gadget/function/storage_common.c
@@ -211,6 +211,11 @@ int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 		goto out;
 	}
 
+	if (file_is_pseudo(filp)) {
+		LINFO(curlun, "file on a pseudo filesystem: %s\n", filename);
+		goto out;
+	}
+
 	/*
 	 * If we can't read the file, it's no good.
 	 * If we can't write the file, use it read-only.

-- 
2.53.0


