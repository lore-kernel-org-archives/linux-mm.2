Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4589960A3833
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B3k5bbEA
Received: by kanga.kvack.org (Postfix)
	id 44A426B05B5; Tue, 10 Nov 2026 04:16:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE176B05B6; Tue, 10 Nov 2026 04:16:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295EE6B05B7; Tue, 10 Nov 2026 04:16:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F377E6B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:16:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DC381606F5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:14 +0000 (UTC)
X-FDA: 85418653068.27.1B32F3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4866340007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B3k5bbEA;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302172;
	b=ukibgSN407HseEAMPETjs+g0QrBbeIeEdvTqLShmxYYTKMDhLczMGEeJ491m2DIRBWWbFG
	kwPI7kYTUT8cG8y6a4wvJiFXDNN6k1Y4sJxzaYYVOf88OMKvjAlV2/PzoIu+GVq7Pzvg0v
	+yorHJt+vZ2crH6yR6H4Rze9UHAa/uM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B3k5bbEA;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48wS641dZNlMgTbgKHYJJRZjCIIpBYSCk6vN7nPVst0=;
	b=BmCrOm0pgYwiXpbE3iccuJ5EggY8JYFHtgObVxd1Y/QRkpUORksoKjBD7nlKk7dIf/2tRo
	7e05eEi7m4mgjbQnjeFrg/1+BxJLX1gDIAhDQm6KYLMRJdvQzp8mCrDV/98e32gheuEW5t
	3gmEgJZTrvHSiA/h0F9Qs3r4FL3X50Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CB1744729;
	Tue, 10 Nov 2026 09:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7381F0089F;
	Tue, 10 Nov 2026 09:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302171;
	bh=48wS641dZNlMgTbgKHYJJRZjCIIpBYSCk6vN7nPVst0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B3k5bbEAWfpJtZp1vzeXux0KzrY0ieZxwUJi/83P+f7eKHCKBYc9mkYVfNK2b/51Z
	 IE7odp0lQqQ7mwusK6pgB1WlHVkO/UlsckyLpTfE8Yp89sMOk+QjYT1he8sjTHJobl
	 zbSxv5PQZ8XY+Ts/6iaugpn66hCj3rJCosVRpDg0+EuqU7+TpcsCN1TcwITx1L6QCL
	 1C6NNljvCVnJ+dNekIZ/1LCG3UXVW6y81kv+eHD0umTjqyrBp3lV94BaeU5UIyHZKc
	 zDKybfsspnrP1qhiqd+dsnxznVfYXFvZSeoRYSBElTyxocH2QJC3b5d8zXbtpIhziF
	 ygU0pzxGVue5w==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:18 +0100
Subject: [PATCH RFC 02/41] nvmet: check that the file backend supports
 ->{read,write}_iter
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-2-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1206; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9rTO3vQgbbKMLgtf9DhInii/7oHGTrugRkWUh4dwMMs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejBtltmGmxnek3mf9QvZzp8xjWWx5Y+Awzls7lyHP
 /4+2Dk3oqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAivzwZGU4478oq2RB1Nuut
 48Jj7Tu4n8+545UyJdpwumO4VdS2g7kM/9TW5p9ep3/AsD+mInRXw3I+rR/SC0xnPXVmN7wifGZ
 vBB8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 45jwqox1ae8tjqmtskitky7u6j78wwkp
X-Rspamd-Queue-Id: 4866340007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302172-33123
X-HE-Meta: U2FsdGVkX1+WUBJNiHohf2TrWu9IkWocH1H50Lh4EoaabfF33RFO7d3mqTxhJI4rTXbDSliZGMMJu4Rk8FLvyPIjQfMW3BYUcoVrTtxtyaSpGEFHoX4tEd4680MC0T5pD6F5fDO8Bp4ka1Wnk/5crJ/IFf+H3yRlr/WET6xYF3nERCs3K6EEijmm4pgA8AL8iDC5TwwWMaLWO+mEEapYuY3GiVIcWorMTW1CNUTo8AL0/zEdXKv0qwFvBHeEb5CE919cTehOlKILmeFI9p6SjHKeSgU9Wdm5JJ8vgIiMs/js8oq7sQc6oKa6rAyxT8D0K63u51LyDIjGV5p7AQ7KYNsYxRt43V8YIoGbN5oOWS3f5pZpj3v2k7P8v5nAtSgYfKeV7774R1vrepoDg80dnODmE0s1oBtJwf7kQzaY7IvMHFZKmLAqnCk/KvL0hzAf9wtUDAnsUVh/gG3901OmYccvhi7Wsiomkdi5mHKcYGuZVbSpUJbemASGwg7ilvmbOFBlNMOCOxQgBH8crD/2G7zzZSxjY4V2Zh5uQgBTJ19f8hNs613kO6YnDMYd2WCS7lwd/Kg6Ecm5V7WY6bNuGkEGVpc0bQbZDrHN36xGa75lSwlwFJyEA8MomgKpXR1cweWI1IknwoIWlMiplTmunPdqLTAEjA6cQgd9X6KeiVBHTKw6MPr4bY4zl+hICdVMHYkwRrT7qQQNINAjuIidcBtDQ0qBRqcJ3FSQrq/YbqzpNQNKi5ElQYUrImEt7OKhZ5JcM5sLl5tNQ/sQF0qeBld+jq+42DPHR9IwCQU3dN6qxFDhGLaTlUuVKxWQYegVRpbV2RY4Dz2Dol+9r+tLC/W65wa3OGK181ziCXBDi5w20giD3a6nycKaSEf/HCuFw/z0jM3PYjtdqjMXLY3in13D707XU7Cd89R4M3bYXSLx4f1rlGEGJ+OI1OD6iPV8TI271aOqeG9mqpuJhLl
 FRbAUVGq
 fKqf1n4iTYHn8SCFL9cVkGdbf631/6txb+iV7eWnsn7rlQf5LrzWjmLJeYwcE56ZCCMa4FxKBuwdoOnb4ubcqAfWVnSCWNM1EcEEn0kqJmC/v3Y+cOITG0vzE0Xtujtw0ZJHiEuIhg4S5J3XzKDUQ1ZQuZUjFMyIDaEfPoBD8XTTpCUCDZ0BGp0+waVgDtSI4D0WOBNzHUYsXVJb6myKq3c65hF6d9HoW62XlSLxQ28WDBfCtQSvknikULb14clvzK02ZOxVc5kCYl77lJU2/qNp4+4CQQVjKLQbL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The file backend calls ->read_iter() and ->write_iter() of the backing
file directly but never checks that they exist. Everything that isn't a
block device ends up in the file backend. So a namespace pointing to a
file without them calls a NULL pointer on its first I/O. Only
buffered_io=1 gets that far as the O_DIRECT open fails for such files.

Refuse them when the namespace is enabled the same way zloop does since
commit 0c10f8a1a7ae ("zloop: check that the zone backing file support
->{read,write}_iter").

Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 695963dd932e..dfa8aa46188c 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -47,6 +47,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 		return ret;
 	}
 
+	if (!ns->file->f_op->read_iter || !ns->file->f_op->write_iter) {
+		ret = -EINVAL;
+		goto err;
+	}
+
 	nvmet_file_ns_revalidate(ns);
 
 	/*

-- 
2.53.0


