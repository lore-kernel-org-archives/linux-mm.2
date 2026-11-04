Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76FC3606D61B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BpyBwaL0
Received: by kanga.kvack.org (Postfix)
	id 9B18D6B05C7; Wed,  4 Nov 2026 12:30:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961D46B05C8; Wed,  4 Nov 2026 12:30:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850D56B05C9; Wed,  4 Nov 2026 12:30:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 628DE6B05C7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:30:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C22771207A2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:30:45 +0000 (UTC)
X-FDA: 85398126450.11.43C538A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id F25BF120004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:30:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BpyBwaL0;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793813444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axjAzDMxe/T5Kt/VR9558Sdu9PB/HLdF+q053OKTtnM=;
	b=krsuke4qnBljm6SM5KXo40X6+V9f8wZyqL13SUK/74hHARYiWCpRNmM7TibB9JDHv0AZA6
	ffNAxeoaNfTSAP28QZm+VVnlTKdYeL58y5MJe19g3NLuhiObKXgaLkhQt0yozxNqgNG/rD
	wcsjy8L9TCyqZwfyV8eS5JcGdr3f6HY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BpyBwaL0;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793813444;
	b=dK7Zc+HQiub12/XeetIlv3QL0Wx726d+fkY/UdhSTuKuHYYBYJRRky4F0BLRRizmhd7QLw
	PzRNU3X8BhyVa/Hevl63pFctlmvPrIrfZQyITwwNkE7Nlia9PP7xSZDigsjQiY1sznjIFd
	ldJP/TG1T3VSKkfF7Xn3w655nG82MWM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BA3040BCA;
	Wed,  4 Nov 2026 17:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318C11F0093A;
	Wed,  4 Nov 2026 17:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793813443;
	bh=axjAzDMxe/T5Kt/VR9558Sdu9PB/HLdF+q053OKTtnM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BpyBwaL0/aYVXoHwq05IXwkJfbiN+sH/NMlrIciQjG65t4BqcyIJFg2nSk8XDCCkV
	 c7rAC5Gwt0eJ+/2lGcpbp0ALBTDjeOzJXNQqmnuVDle4iduB5dvN2rzhDckY+qtIzb
	 gs1CNuM6mGLr4omD5X5lb2yIJHjoEFVFY17i90YDIqHEiBZHsPoN/pZZJkVTJ0KPFp
	 EUeGwANAMrg4AicMXKhoLnEodEFkU0cutq7m4urrRAjYhUQUJ5q8o2+x5TkfWHjCPD
	 i91uDDI+3s3/ZTdD9a7P2TXIzuGYqpzF7L202zVk0SuzYL1uXQEo7tJ52MN1ssXopq
	 kuzwiBlPYX93w==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 04 Nov 2026 18:27:26 +0100
Subject: [PATCH v2 09/51] profiling: report it when /proc/profile can't be
 created
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-work-procfs-bugfixes-v2-9-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1225; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tYIXM5EjsYRFpz3d9CdZ23LhMvzI2JA5U8qSrxldqzY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zmb5c+HYnPYns6fufFrw5b7Y3/kPP5ytKnep0a7Jn
 RU85ZS3VkcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEDoUzMjw1q1TdWGx2OGny
 nwfxD9yf9a1xbZhUXGz4leXXTAWLvycZ/tmE5T+0eFcqb8S9dXuWRJTqOn+e0/UWz2+d/yn/trX
 0PxsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: k338dwttd6nzx3osryxnz1w8nygqijex
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: F25BF120004
X-HE-Tag: 1793813443-833204
X-HE-Meta: U2FsdGVkX1+un4MfihWcjLma2Xoi2uXeUJ7LBPWYGADQUpjeAuvLnuhkoRmziq/DbpTLnpXVJcXU1DQWjNSvB13cakbzg6x9fIS/E2vh/nHNpwe1VvG3r+VVgWawQck6SZGNXU6ar1rcLopOChHwVhDmqNig8/SAQCGEy9eAeuSbNhXH2EY4kL7+BuztIJPNIHpmnkqoBanKn6yFChd2TDp4/EWx94v0GJcyE20Yw9aDJWTCekfJAOMTbCu2LN1KLjKeX/+AI6htSCVg5YyzEAntGVTdXZYKN0GeIWlKTcWFMq2myaeN6U5TQTCclExy1fIfYnzOUXjzTGe+H8Ap2c5H0EabCojzsXcbjgpcNwil0JlQ9J/KWgMqQ9m2joOwGJJdO4vkhq2rTZBcJSgZ2IrzJJ8DqmAnFEK3168IT8HNHX2yYn4Hz6joTXPoqYfn81j+ejnYI+mnVt6v190edI88jsHCQA2/96XtUyjPU38Py7iCAp59tXjUM+wCkdyNb22AIfCbcQDQQbQb8LecSDWx2VSRk4rXft2kIQI/JD6/6I89kXnp9B8NJntOvfEF9O9K1LNBtSBINlWQaRtDlCiVW8IGIZQ9vA8LyUQ/JFXcxfiNSmbiHVdkJdJuaXd5J050yksMTHj6zowidEiEWr6RCGTvegsQCVkZcfqoumtkcQ/+yWojNa1Z7zMF2f9/qear9ltzmYAFwJzMmN2nrx8agB6QiqUe19Ic2a2W/tRBxCkWK/I14iZR4nIbkapZmNXY7ey/N1jDjwrSdZ0/6AzK4YMYK3ccPTaSOF/kf855VSV7QXfMyMs8s/C39K8xcybB5+A2v8PRToSgb5zFuhij52hlnVx+s2u8m+mPTuZRugQhEQRIhgVFs7A+YwtilJ0GqmDClvld01Pho/+p039S+pQBq21moXSABo8yY8c2EH7yEohvcWyL9Nhy+CT7IcqOOtY/HjqXprgfyrs
 DzBfDaRd
 8UiuNaxzU1C27/iZhswE7aKUIfpghhUHf998dbsPguquH2MGo1t8ukZto0RNRUUlRMOXFr0iCh2tupN2rxGnKd+wsLgyMQ7Nfh5eQ1RoI7SaWSpSFecNkDE+bNjnzxa+w6jV0iOTI+s3EliuryobB1fpu6inSGLibxPLf/LboC2FMGiEosXUQ6DpclYojtjIRpGnzmMkWG1KTpV9LWUZ3ezF52l/z/MUclimQhR6e6R1dBNG+SvO4EwAMmIGdE2aqhBGExIQyQqyVqb9YH8Uq7zq+AXfTqPqv1Iro
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

create_proc_profile() returns 0 whether proc_create() worked or not, so
a write to /sys/kernel/profiling that turned profiling on but didn't
get the file reports success and there is no file to read the profile
from. Return -ENOMEM like the other failures of that write do.

Fixes: 22b8ce94708f ("profiling: dynamically enable readprofile at runtime")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/profile.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index e7defa90a34c..820d5ec909d4 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -216,15 +216,15 @@ static const struct proc_ops profile_proc_ops = {
 int __ref create_proc_profile(void)
 {
 	struct proc_dir_entry *entry;
-	int err = 0;
 
 	if (!prof_on)
 		return 0;
 	entry = proc_create("profile", S_IWUSR | S_IRUGO,
 			    NULL, &profile_proc_ops);
-	if (entry)
-		proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
-	return err;
+	if (!entry)
+		return -ENOMEM;
+	proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
+	return 0;
 }
 subsys_initcall(create_proc_profile);
 #endif /* CONFIG_PROC_FS */

-- 
2.53.0


