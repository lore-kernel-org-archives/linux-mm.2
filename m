Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7C86079C0A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bev5vsoQ
Received: by kanga.kvack.org (Postfix)
	id 92D746B05E7; Tue, 10 Nov 2026 04:19:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE066B05E8; Tue, 10 Nov 2026 04:19:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3AC6B05E9; Tue, 10 Nov 2026 04:19:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 592FF6B05E7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:19:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB061A056B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:38 +0000 (UTC)
X-FDA: 85418661636.11.04031FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2CB24C0002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bev5vsoQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6F6bixX9VLJl6u/N0LxDxdpy5DWNAw9MIo1FfuiWwlg=;
	b=apn+rNyKsGOy+vCZ5NGMCjiflCbdh5SpGEchgRPJ2YRHVvSjOB1XPp4TxSn/jHwLhTcf6W
	zFKZI3kjBP3CEbpjNAviq5F3lS/pBrMI2KlTEhT2amAU1f98XffPEyLZfRVAJ/3l2uFh5N
	4mLFbM9Jj1qM4cdwbFioZuNXbW/eNRg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bev5vsoQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302377;
	b=yJGmIY0EpYWy0qfiKS0t4XNbFk98tyHKB59iDECoC+O/1XQ118Kxes7ka2WtaJZQqGgSOa
	ebG/pOWNY7ylR6oVNZnMBofHRrQW9ZG0T9zOOmJoCiLSymPZSt+KUOtovbzoAhGZDYG19d
	fIFQipZat9dPuQge1sa+TLY1MuzHH+o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B8C0063823;
	Tue, 10 Nov 2026 09:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F84A1F008A3;
	Tue, 10 Nov 2026 09:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302376;
	bh=6F6bixX9VLJl6u/N0LxDxdpy5DWNAw9MIo1FfuiWwlg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Bev5vsoQXMD/2z11W7fF7gnr2WOAFCcu91VLKw23i7E0hkqCe1dVrhYy0+KtPJYmF
	 7SwxXGH2SnKEaJ3Gz1JJnuTNJfiSNXCHsVfu0NtJiKPNIwpXKj4acpNvaSgQsC1nOn
	 v9D9W8uBh3avkK864v96nnYuhV8CQ/YD06yiqjObPD/ts1Fa3Yra+s2JNGu1CbzXmf
	 lPoZDKOPKjIY0m0OaT8lZr1lUKx7GexmZFGHwmRV5+QIhPZ8mbIcDCb3vCEt/G7Jt7
	 jjMDsVbCi3OviaEyzsMqCkhdh4WJddoN0LSF4ef8DVIGv0E0SDkQwiCi9hK2AdSt56
	 Gfxo6evUdhVLw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:48 +0100
Subject: [PATCH RFC 32/41] usb: gadget: gadgetfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-32-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=980; i=brauner@kernel.org;
 h=from:subject:message-id; bh=HoqM8TovkVWXxEHW73GnjomtfEF10WO79IJ99ILFhZo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDTyDeb75KLVcD+3CmXFA8amrwrV9AreTDj+7Lby
 8T6ktIfdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkdS8jw7y61UWZSuzH/CUD
 K7cIZcU05XC2Bbk5/nEKXnZy8lbXBob/3nwJfl+n25nnXWg+epP78Jz1HcW8OwRzuVKbKsKnfvB
 hBAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2CB24C0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xjdnqmyentyn6boq175w46o59ge6hs35
X-HE-Tag: 1794302377-663235
X-HE-Meta: U2FsdGVkX1+0qVS+pUAkOtNON5twc3gRORK4KRfZxdAGSiLtey5ygz8YRngvnv0xKoWgoA534Ml32lynDSNDLs77e6bBLHDiwSLDs+FwY1+SHqIetXiqHs65Qj+0SFVUzG1aRqdLA9BsE6hq7lMXoK7CTyBPOXoK0OSWluI/r/t6Kv5G9te7RYUl//97nnbuk2bDJPpFjhUmC/1USlMpwTlw6v9QPH+FXlDkaDMkh9TqeEbC//U7r/SF/r4Efbv20cHT07rO7YtC9RvO8+27VHU1yE/3CkcRNTNsmx79JFt9FMZzInzLt7eKMZcEg44IBzj3Hl70dwzG3Bfkx5Yo3QhV1TvdzB7+I0VuU4RpUhdfGM4yE+yvK/M9AU0oGjHAHQY3D5/tra6v/VtWL/pf+vjDQFYt5egw1jfxJU/tvyTOPs15g6wwj5c4fknln932goQuQybj2sdVAYT+h2vD/7/HT4v9H2SbmdYkdz7qOzFMvs6A8bR3feXKdfavKeMr5uj6Haaf3DElMI8/B4do/T1dt+AvGc0d5lXSIx/vyvWtaZ6lu8Q5LbjxYjW1evtEQe81n5H5IRy6fsqJFN3jub9N5xV2qFtAYLSjhn01mJuzutMhZNBcKdiXEWv/yFELpIfBPbyZjqwvg3LLA3J6rU7Kchj3lEPIS7RsUGyHbcXvtNd3gpXaCGIT6yLfuporYLZMN3eSfnkEd8cRE+FD3VSDGxmvMzvulWOzSGEY88P6HR+cI+nAaImoxg8LyYClBCzyx79bjp1AhERK9icXtWpejyS0Q44tNZZVtI8p5/F2tzL5l+EqCC6sZyEnewuoa3ZMUkhcZ9xlToWJsedeu8Z8wxyBnFLQjtUUnKYbAMxXuB96T2UxOJgPemzTORZV/TO2TbSgslk1Mo35bdbk11fuxz2I+JBl3UNS+5/8VgSGyrgUlUP/S2ytzvpUwfLvnIioR/5sX/Oy+x40LlU
 sBJrpjWP
 MojTFvqAR8kF0aO8lLuHWU3yD/LxNWPXlhLoTiW1BpKqzENjhZZVic1cLKMlExfYHWqNL9bQ4k163f4PSaBoBLHOSqfHYdYBXtfiVdNofEHQG6yshGsQFKaIzI9XOiRRz0n/MPbcXk+sXfGHStwikeLBr00EVpu5ydzg52A/MXvo6UN+y7aDsL6eMBBl8SEDrlIxuLlfo9z2NeaA0aZdvPTnjNKF6DRR1j2ydt7RAvfckDP/QHblmZVmU8IU2w5LID0wkbtNRPxQ7VS4f/63qYSq9HL8jBCSUBcIU9QosJO2THz/0cjg1p0SVTUvdqEDzbI5EDR4AS5irMQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize gadgetfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. gadgetfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/usb/gadget/legacy/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 7f6d8460152f..8490e5d0351e 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/uts.h>
 #include <linux/wait.h>
@@ -2223,6 +2224,7 @@ static const struct fs_context_operations gadgetfs_context_ops = {
 
 static int gadgetfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &gadgetfs_context_ops;
 	return 0;
 }

-- 
2.53.0


