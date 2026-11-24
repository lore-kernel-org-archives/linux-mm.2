Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012B960A6F78
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmOjMgq1
Received: by kanga.kvack.org (Postfix)
	id 218AE6B0711; Tue, 24 Nov 2026 09:04:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0536B0713; Tue, 24 Nov 2026 09:04:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105D56B0714; Tue, 24 Nov 2026 09:04:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB1506B0711
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:04:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C02C140BF3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:04:44 +0000 (UTC)
X-FDA: 85470183288.19.91EC488
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8EB2DA0012
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:04:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmOjMgq1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529082;
	b=6N5scGxOtLz2js4ny0AdFISBP7zegpMldJBggnAoCDAIMZZAA0vJItiXHjpwFGikBFJd7Q
	8RWdfy0YG1tZtxaSRkRXZMlcBvcfvkrXvBlo6QZqe0EuZrDygfO/Olfje/wvhlBeu+HT1c
	CLxSborG1sb0h1wdc4c7jNCzEn/Cz7o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BK9UkUpVXySdPSUWL4MtzIhDYD5JibSz3LW4sTSavdk=;
	b=YiSLJTcSY2UJ6YZjaBYANAZSuA61zQOwgMU+iesWelgGdANhaJlx93/OTQodb3d7JbsfXS
	VuB80bsyA1MJMnoY87wvVT2Un9y8UTIh18EO3feAYh0VeGTIFU1k33IxEWdzKQoMsUK0wt
	qwZBM3+Tr1vX22gSbwE+klDqnbplQPo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmOjMgq1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF00344E7A;
	Tue, 24 Nov 2026 14:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729F81F000E6;
	Tue, 24 Nov 2026 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529081;
	bh=BK9UkUpVXySdPSUWL4MtzIhDYD5JibSz3LW4sTSavdk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dmOjMgq1AGHQhoPvgdNne8I7eN2qrY76RiZVstLKlFppxRHabagSB9sep/9K9mZdE
	 nLLP7Q1FHCs2qRhYXPNt7ChclwrhqGsgnsOq1hYmbff+3OXzpBVOP4lsBE/sUuHUR5
	 uirkuvsCi7X4GqoSdB+en4U8Sy13oV7G+ueSmZOKRFtSyxsrhQTzXalDfjoMEQzpYq
	 3CRMtpauYGtg1jGfdjwxhVQCpbVNX0J90S++nN1X0ja0iCJE8Ir4ZdH7W3hfRB3z0g
	 WN+4j5cGNwx6NimhARjK2ljToDaJ5E58eXVt1V8hwmzVZxRVA45LfwYQ3rGzZq7dyN
	 LSyPS1qyImMjg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:48 +0000
Subject: [PATCH v2 05/13] udf: convert mmap hook to mmap_prepare
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-5-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowangio@gmail.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
 Ryan Chen <ryan_chen@aspeedtech.com>, 
 Billy Tsai <billy_tsai@aspeedtech.com>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 Scott Branden <scott.branden@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Richard Cochran <richardcochran@gmail.com>, 
 David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: ljs@kernel.org, xen-devel@lists.xenproject.org, 
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 virtualization@lists.linux.dev, linux-sgx@vger.kernel.org, 
 selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-aspeed@lists.ozlabs.org, linux-arm-msm@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, netdev@vger.kernel.org, 
 linux-mm@kvack.org, Jan Kara <jack@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1204; i=ljs@kernel.org;
 h=from:subject:message-id; bh=URnAKhKjrnC9kDrA9QpmKilue78LSAEztCmpaQ/lqmk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4r3PzDca7/h2XGXyeIC/WJhW86nv0u95Kgds8nDO
 kLC/vOzjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEyEI5nhF/P+cqnP57MPb+5/
 5XUkdfMc4d8ZmdM+TvrjEm8uylFV3snwP8qi/v/7juApxftyPktMul/zaIXBPPuQggQu3009C++
 YswIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: mac5xcfkbuyyexcpz6nzfrybimd9opte
X-Rspamd-Queue-Id: 8EB2DA0012
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795529082-870307
X-HE-Meta: U2FsdGVkX18IuYCcC8XA87s4e9k44hM/GSgIQ0RB/qhYV1z64XtuU09AcYTdgiHLHXEA9tmM6+PfVIHX2y9R+s8F+nMwpRNNnpWGZiQudBxH/qrGIJxAEn0La0zqUdncC34rUVP9LtLDDBpO+mHX3NORQTFoqJRgCCzdi5eXCBzzv8CtkB/Bu+1LCW3XDnLgiYpoJD4t6oPGr0dCDneSGsdlOtdGLP9m7M3CwEIfZ6yB6oFqy5HXvkNVcdMEGqYav3CIDxc8/DYq4haFGGRoAATTsu0zlN7LDBnH8Vnzkw3lI8+RA6GUfQuAJxJZNarnE/wD//xYmfuAuI1KOU0ltrr5GgVRkxrIcJoi2Q+lEKZWYPQsEM26kHwvOl5gpUCkBd9Favu7XkiC9FQgj9rChWdWeSPWNFBIl1KeMopJI8Q6m3L0x+Phg+66L6YEi6kh5uqcIkHVu5BXLsmuxtT009kZfmCA9fOx9Unee5zG7y9ixiKKw7or6RHSSerZ87joJ3wUOERcRRF1+k2tvSXW3BG8tQoOqXbT8FUFgaFWZL1Ngh40RbkO0UIUsaZVzX0z6W6UQ/iL1arWi/EOxucILZhaPtHlBqAhXRdVVQCJFOVhGKJd+JnBg2zYrXkPrwg695kCY9w9tlzMBq7eN3LseFmfTm5dD/yYDRAMgHh1+SBRuisGw54XAREViRFDcfpnVdsCVbSTUD8nGgiWZtr3abeAMDsL33jnc7ZVyMaciUOBD9OX4iJU+faewhsWYp/SysD3lC+ky4BguHREfmgpqB9PfFXzewVLQ7G8BVbxhOY77jOBP101iv9YdNgHfOfxASdYrtrjMsAJxPKVdRpBEW4469KHUPniUV0HxoEpwtJWg0SyPmE2tGmmjYip6bCFa5W1Z3BDkopqpF7by73Ag7dTR0Rl5pkbRecB78b8QhpDlzS3xnl/Rrdvj/wVUIpwlVm29O7mAhU2EwQiKdb
 9qXeh3gL
 7FMheTTAhXgEM8Nbucz4DzQehmr4K6uNhBsaGfgbTKE8FTmacNoA19BI2kwR6OPZNLu65rEXC7Wx9Y5oBKfJaWumeJxp7m/Ll5QUE5sEM+Fji/JiZ0OHU50DflPmytqj03565f3RJFdxgB3nRnpnqmZaxlkYMMDAj8Rj+zJ0UPaf2n/IVbBTNspoAEoy4aXHcTBk2DL6PuC31L2a4wd1ajz1DRXDHVqGi0C0ocCWRUIp8mEFc7lVyt+sDLOWaldgU7BwrXCpSFk1piyknTEElWKtZp3sx+RKbsskmAgdOFoUMNr/oUtnm/PXFTe4EDe4DZkJYN6hG96zPGZIHjGZdYM+eNjF+woGcev+Q/Ju0aiJdwP8g0SqbncVbfltLF6hWoYWvThP3rfHNXc0EeyUx2q4cBDVg72/oGoBIKQ0rfr7bOw4vIYrzjKHdB7b0TFd9leX/xPuR1mB3PNPhcnTddPWxxliuY0MGjvp11sGmdiL73ovLs1RLppbmmvojDkOhywgz9SZ84Ms9Br/Ad8MhfHLbgA30oYOGEqhLdfmLg9xXRGRglwvnaXLNjo+SFjswT1FebzeV5Ohih4+Ih1sRt8fmM+SE+gH9rUfomaDoPFaTWcYgVa8EB1bYjxSf3/ILqJXt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move from the deprecated mmap hook to the new mmap_prepare hook. The hook
only updates the access time and sets the VMA operations.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/udf/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 02e9314818dc..d5e80c6cae96 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -190,10 +190,10 @@ static int udf_release_file(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static int udf_file_mmap(struct file *file, struct vm_area_struct *vma)
+static int udf_file_mmap_prepare(struct vm_area_desc *desc)
 {
-	file_accessed(file);
-	vma->vm_ops = &udf_file_vm_ops;
+	file_accessed(desc->file);
+	desc->vm_ops = &udf_file_vm_ops;
 
 	return 0;
 }
@@ -202,7 +202,7 @@ const struct file_operations udf_file_operations = {
 	.read_iter		= generic_file_read_iter,
 	.unlocked_ioctl		= udf_ioctl,
 	.open			= generic_file_open,
-	.mmap			= udf_file_mmap,
+	.mmap_prepare		= udf_file_mmap_prepare,
 	.write_iter		= udf_file_write_iter,
 	.release		= udf_release_file,
 	.fsync			= simple_fsync,

-- 
2.56.1


