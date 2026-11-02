Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0950606B0E2
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kIoUwWZI
Received: by kanga.kvack.org (Postfix)
	id C982D6B05D5; Mon,  2 Nov 2026 10:07:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6F2A6B05D6; Mon,  2 Nov 2026 10:07:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC976B05D7; Mon,  2 Nov 2026 10:07:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A09356B05D5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:07:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33E9B16016F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:07:52 +0000 (UTC)
X-FDA: 85390508784.01.3CD563B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6E829A0011
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:07:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kIoUwWZI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzi0v2Iw6r5Nf2GLOsMSQBwdPNX93e2TzGzGfD3oQvk=;
	b=TxVDMrcswEBFDZG5Zw3h4X6gz0wzaor0BzTpToJoyPTqxpT4tqP21QPrQxu6YF0Uv0Fkeo
	2x3+oOdLVescAw4TLe8Yt9WI+DuBHRrdIsgq4MFk3f4KbDdbbl/GQwYyt0i9ts5lTqqxBF
	uEe6jM8InbSYWqj6jw5O0Rpk3XZsPRo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kIoUwWZI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632070;
	b=FvU0uZOqSfG+H3HU0Y7vcYujxlt7ALdwc+Kx0XryJbVImRyqWsrZiUgpb7wrPBQU0sW66p
	LiKLeAokDW8wxq8zBQKF9Ox368uLcQRhFpjfDmGoAzNPwhOky13jb9P/TWTc5dT6TVjSjK
	QrPKQ+PBo07lNnCGnXha8FJ1+6gsLq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1FD84378E;
	Mon,  2 Nov 2026 15:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6921F00A18;
	Mon,  2 Nov 2026 15:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632069;
	bh=lzi0v2Iw6r5Nf2GLOsMSQBwdPNX93e2TzGzGfD3oQvk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kIoUwWZIZJmPIDGcbCqUMn+ysgkkYH4B9KIOKwQcxHvHBenqGMDwfSExIyruQhbFw
	 GSvSuGXqLlsS/+2bX4zY15r68FSJdvY7PhgxxV9bnP9Q3PrAcl12NmKthDnezkWdzA
	 YQcdsHreaTBVFGkt5/ixU0O685iwRTrAmT2xH295OHXHJaGkHJFEIXEMqGqXCeqbKp
	 nkpHGaPfZ7GY12qU7tMKJN88syBFW289W+duXDc1qru1IIyFkTan4orRc22NIVl3pP
	 G9JHqYUFv0jVxFqVlQXSQgnsHBo0FeNBeFWC+sINyeJMsGIfziINB34GYCGOVyuJWO
	 tkxpbHP0pDc6g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:45 +0100
Subject: [PATCH RFC 18/22] macintosh/via-pmu: let procfs copy in writes to
 the options file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-18-c9492ab08480@kernel.org>
References: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
In-Reply-To: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
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
X-Rspamd-Queue-Id: 6E829A0011
X-Rspam-User: 
X-Stat-Signature: 9kmiad81nz9ckx8jsagz4e4seirc3kk4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793632070-899095
X-HE-Meta: U2FsdGVkX1+daXWcX8onjBQg/FH4LA+ic6fU7DUNlLwl3tm4hM+ak+wMWZNCRnj/QJzKdvQqywecsTxziy/8Ond2BGSOAVJTS1W2UzfYO0v0mVK3enPKdm9+7WbPXKPqRIZbKfK9U/2JIPFDhyIUyS0D62PoFNEgTUEID4/jh/kwNMFhVZasnhRmPw6NrgCfM33OF+k7cVfqlrE6UHwNLe0tZIb/hmADc3mDFWRoPpvs/wiiOaCzZKFlJaKo2REoOcssa//80JO9O+/bXs+Qk42c/RGGuYPWFFRi+mxDF3yvM7gX6Ft6d/GJS/D5cR/baq/v6YMrT9KDrWnerO5JXPZEcy2Jt11xwYLCXC7sqBtRj4D6Yi3J5O5v6Yeir+e1QzkoIq40iHLznGRR8594qWmNp2hgxTA8au16Aa6S4CvLU0T+Qx6cp9s8feL8Kbw/5Z6uxIuxg2HYVE2WhpYQw/52FdsKsDm57BAir+gKFYJHx61ftcJE4J8mPsrs5kvZaVyy5pkL0NhaExd0xAawmxD0uKBfXlh2rHpe1pyW/BdmYkJYLipVpx2fsIbwUPqC2FidSH0ch0jqwCiKiP9hjAPmWsK7+Sp5BZvxry7DpPzIBJdHrO/h/MXXdGioX98kfLF1fK7k26cokgfZLc0FYyMLyoBXx7h5navWZpW53MON9Y72YZm80M+ZJrEtVT69IYz23QUZK+5ZgKHq6OWGPwUNkAWTrxQkA+OS/ittQBPGFiyGG1UltEBqmeYIMY+EgQGviT5Ob4eGBeWK6ygJSD57l4e1NodbdNrZDThl6Cp5vbnX8VMCiu3IaAhC92wj8XP+dVVxKJ62hrgxmW9W5mI666A2rCiXclAFq0DY4fVJDtWXVBuFv8XcA+26F+Dv3QwZpOYRKS1enECsNPZnK28kXpoiUVn61V2rv+UdZCmxdQBJGA0B7BtNpd1TU+/lPMdHlHmULujIjn77rSK
 7gMZjR5Y
 tj+2KX2GZa6FYAk1LwIjMtFXpQfef2oM3ZBKa29M+oPqEHyWmkPfn8+XafxhIF4eaL/4p7+jFiyXbb2avxb5OFFtpTY2InhShN453eFDoPm5M8dAijBOkhz2Lgwtsyj+7MGD0SujuWzcFyziFhGydLL+SIpE8TV+SyeXSoGRo6qOIk6Rp85sbDE3fFjgLxY7+eFYXPLDyHQGK1r6j/bunB+yU66vowwZObK8ORQCO075aYPgztweiHdOWncLokbWF3apX5ZLX3gMvEmNJzTgDGkzqpDnkam/5onU1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and parse the option from that copy. Writes larger
than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/macintosh/via-pmu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 49f929ae10e4..079c085be5d2 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -913,7 +913,7 @@ static int pmu_options_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t pmu_options_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *pos)
+		char *buffer, size_t count, loff_t *pos)
 {
 	char tmp[33];
 	char *label, *val;
@@ -923,8 +923,7 @@ static ssize_t pmu_options_proc_write(struct file *file,
 		return -EINVAL;
 	if (count > 32)
 		count = 32;
-	if (copy_from_user(tmp, buffer, count))
-		return -EFAULT;
+	memcpy(tmp, buffer, count);
 	tmp[count] = 0;
 
 	label = tmp;
@@ -958,7 +957,7 @@ static ssize_t pmu_options_proc_write(struct file *file,
 
 static const struct proc_ops pmu_options_proc_ops = {
 	.proc_show	= pmu_options_proc_show,
-	.proc_write	= pmu_options_proc_write,
+	.proc_write_buf	= pmu_options_proc_write,
 };
 #endif
 

-- 
2.53.0


