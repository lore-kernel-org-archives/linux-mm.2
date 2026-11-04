Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C4B1606B2D9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BSonnJ4f
Received: by kanga.kvack.org (Postfix)
	id 0246A6B05D4; Wed,  4 Nov 2026 14:23:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3E6B6B05D8; Wed,  4 Nov 2026 14:23:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E55DC6B05D9; Wed,  4 Nov 2026 14:23:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD6D36B05D4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:23:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0811E120807
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:23:08 +0000 (UTC)
X-FDA: 85398409656.05.AB698B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4061B1C0011
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:23:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BSonnJ4f;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LkQzylMBPw/rjuFeKsFyNpbMkN4WRhLixyhJUzJNoRI=;
	b=hEtvgAtpDTukM6EwXfiLiPl8uCy5bD/G4vIFNCyd32m1jCRVfnh7+cXHEHSw5yaPmQ+7aW
	B87Ha7PptZRcFQ9l8h/X2J1DOakdhlVCGwVUQxeaqE9PW6ly6NjLVzRfVCxxPlwEjUf8uy
	+kswg7gDevZrv79mTa+76VMf/E08i/0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820185;
	b=qbazwNqeVt3DK9WmNKPihurbAOBMA9lnrFWkHxUbgZF6MkRJd5mQh3NEwvGgFRE68r+idF
	StcUfX9m54aWxz1FVIWQRegsjfat2Mv5kz+XqkQNomZZogGOriQ8fmfwdhJebicwNqzRVk
	fsIsFvgjaU7B3eem1m25A+UhNMGSv/k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BSonnJ4f;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A854417F8;
	Wed,  4 Nov 2026 19:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF251F000C1;
	Wed,  4 Nov 2026 19:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820184;
	bh=LkQzylMBPw/rjuFeKsFyNpbMkN4WRhLixyhJUzJNoRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSonnJ4f7yMH1lOXY4xKOkMixSuWwienI9M9D7I6GKt/5EQqTgA/iQ2QAehjV234u
	 YFAT2O6XmzTeX9l9nI78c+OuI+vrlyGDMu28/cFZIebS7LVWB5yQYSIHuBROdXKmV/
	 POjWxbi8h52DJlKnFdWShCkvORSC+wER9+m5Nc5I6YVlHAPNaszz5jWURsoc99UxNe
	 HtvfWbnrw5mLr/fLV64EYTb0o/e2FYPIZl4AGyyNRZpEiF3Dc+H3TPm7clGTz3Hei1
	 RJrKLHUu/lKQlBjZQXWIB8Dd4bHzwpk5JakS/D+nuaTqJL6rz4xnryqSZJ8XfbWmNB
	 KVSx5DWPRFPdg==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH RESEND v2 28/51] ntfs3: don't warn when a huge label is written
Date: Wed,  4 Nov 2026 20:22:49 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-28-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1211; i=brauner@kernel.org; h=from:subject:message-id; bh=CQmQXvWqu+qpRxwX3Ai9kAzqqtrenD8xJsc3ckb17sQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bnz7K1goQOfBzlUZyTmXuaJF8js/Rb7//OzHk6rr7 JYtL5/6d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEvIKRYcP67G2i6Wf/B2W2 7txs3neapZ43c+rjv8+u3w5s27n+2X+Gv2LPNsjtr59gXDV90xsjczOOh182+JoIeRm6VIqkhV3 i5wQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ix86sj9czd5yphgywi1owxgj4iesofp
X-Rspamd-Queue-Id: 4061B1C0011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820185-672997
X-HE-Meta: U2FsdGVkX1+y2zYnbXY0EItKxIjdLtSQ/dDU51Rjf3BoqXkZrQI0JW/aP/+fyfn5B3mxWvxrnrsTY8b9qM6nwu094eDgBe4Gvm8sx8QcEByLmhbN7J5wQwYb3TG5mDU6GwmKhL1OIRSLvTcBoIT2BK6T6ZHMkOik/ZwEemaVGdOQCD+jTO/DKrfh4l3rhV6tP2v2qLqIbbMkM6ikuriiqqco0pfZyWlXNJeFtrKyOCDiaja7vhZIfYh04gDVBGxOK0FlfoKOl2/nw2NZ7tjXTXsEuqBHvYohhnv0npHQDEbvdq3WWepwmXUj2XEeM/YkFrwAOxXeJsEl5oaCHcJQPUoesf2FJT/qayOpRje394wVXR8k11Kx1J7jka5E032Gl9ZeQ4bfTD1EeaOC9UI98EjPnL5D3YYfvTs/eXjom0o30cmWivE4qB2HK5o21Dl5IavkpfjrFU5j3ntHOnIArLuFnZZBUineynnBoLMvs0sa2IIPxpfFN3uYd/SnenAO1+mDGOKMS7Cc3JiCucMn/wV4U7zFS0d7fbIJjkkKYA05uPSSyZrFkK7GXv9YVw9pJ8OLVC6vC5WVfVVLz6oVX/uh1LA5qRgkLdERKU7X94vNIKJEK99tE3I9uoR6ohmsUZiw8CVIZZLNma7b4PC0+39f9vYKmtwdqO5xDsRq2oXijUcOVlPhqC7MkWIKQXEMFe2FGzskLoZn/XnEbzLewM7JeFXTK5pWoHT+Kmg2/nCnoeTY8Bj2tRq8atunWGxKJIf4qc45rscenajjWMbCgeWBfUdDPjIReFIt+cLFUY70Q6Vhr3buMc/+Krk/EVTn65xjXaKdalGFde9KPBKV1ZYWB78GTLxVPDQ/0h+qJjZop0uLEwQn1d0MmP8c59TG03n7zFiVtI+YLBTK5PbTPocmLVMjEtZCBoQrLNgnGna4Zt88cj1sohlbPjTfNESH6SkoWxmkqZUQxOu0p6k
 hm+Wwbc0
 ULUdu1uk24Y14OxclCFgkLB2UexuiG88xUvcNBSregJasLx/ShEHiC+FNZvtv+srMTec2y4TN/YCS2hbHcjy/IXfRxkUW8QLrGVi17qd6sa3hNOhBire5rS6qYeqqNl/4hfA3BAOUfCu7KS0cRsO2+l1x9InmNojPmeTGPBEj6Qrs9XOJM6qtCPl4/SZYc68Dv3U7g6ZHOQ4qq94ghIO9yixBG9PZAjHwrQhEy5Cs+WD3Voao1sQ++60/nTz1tl3yvTCemTDQcMfwYObe97BhayBPMCTAQhrRmM19onZVbXvpmz8EPEX+wTB15Y2n7oqmJjdYbKeaEIHVCkDyqZ0q+Zsl17nnGQOaOCNrEMJD1/QU104AZy/ZrkEdRPjYIW+JS0TJ48Tg+Uoad4YNb4SHAZCuGhtpgJDQ0ulf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ntfs3_label_write() allocates as many bytes as are written with plain
kmalloc(). A write that is larger than what kmalloc() can hand out then
trips the page allocator's warning, which panics a panic_on_warn kernel.
Use memdup_user(), which fails such an allocation quietly with -ENOMEM
like before.

Fixes: 7832e123490a ("fs/ntfs3: Add support /proc/fs/ntfs3/<dev>/volinfo and /proc/fs/ntfs3/<dev>/label")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ntfs3/super.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 29aabdc8a801..37e27b73b7a5 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -576,15 +576,10 @@ static ssize_t ntfs3_label_write(struct file *file, const char __user *buffer,
 	if (sb_rdonly(sb))
 		return -EROFS;
 
-	label = kmalloc(count, GFP_NOFS);
+	label = memdup_user(buffer, count);
+	if (IS_ERR(label))
+		return PTR_ERR(label);
 
-	if (!label)
-		return -ENOMEM;
-
-	if (copy_from_user(label, buffer, ret)) {
-		ret = -EFAULT;
-		goto out;
-	}
 	while (ret > 0 && label[ret - 1] == '\n')
 		ret -= 1;
 

-- 
2.53.0


