Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A930F60824FB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ht8IvPAW
Received: by kanga.kvack.org (Postfix)
	id C8F116B05C6; Mon,  2 Nov 2026 10:03:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66246B05C7; Mon,  2 Nov 2026 10:03:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B7C6B05C8; Mon,  2 Nov 2026 10:03:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99DA16B05C6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 332C74015B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:03:02 +0000 (UTC)
X-FDA: 85390496604.14.25646B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83B97C000E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:03:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ht8IvPAW;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631780;
	b=JJtE+VgDU77cDS86m2mPvqlzncIfAulKmLre8HCtuG7M3DmljW+FqZlozqA8g0QCkRfTIV
	EzaIuUjd8BxJMb91COg2/byHmgKjdRTZYkQ+5PUS5gnV0ShdKXiGtxfMm8HBK98DTKHVOf
	6I5mrWx3dd8K1qB8V1AGNEI1exZpRH0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ht8IvPAW;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wEPnWAoxjJOkMqmLZaf/U9t0SZ8y5Jr9Z0MZeAu0+Kc=;
	b=jGax7LrLUs6k8DBKocjdQlGXi5DpKnJaYa9k+tGy1ZsxLH8TVZgETVIy9M7hcKyuqICg/k
	BbS5wKDrby8tHCa+oJxKDYe4BxJEEyHsYtrzvT5ZAawrWiuUCJF5ztSXgqgKuYJoehjnM7
	6cPpNEO4MrPlAqfmjww/8P1Cm2rXZyU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 09B946022F;
	Mon,  2 Nov 2026 15:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993D81F00A1C;
	Mon,  2 Nov 2026 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631779;
	bh=wEPnWAoxjJOkMqmLZaf/U9t0SZ8y5Jr9Z0MZeAu0+Kc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ht8IvPAW4mof6T3nGFwGbeVcaglGOl5mlj1CVqepMvEvFGz+8PKgoWLHL9+bJs9L7
	 53v2AQN+tBMkiLzgkeml7gGU+OB8Qm2CYhl3PTcPVXGN5OADSQkZJx/YRkKTS8i052
	 B5XpuKPR4lfAkar6kmgYTuxdr92sz56IZFvIKuF1+wppZQEyaU5GTMiW0VyOvuqR23
	 IRN/l76vPa7aqwWxy1j21njn6oagnIsGH3fmLYqTV/WDWTC2VC/h/xgzC3mEcucqJ4
	 Ga/T8yFZ4NOj4fhKsZdAeiJjq2g3w2I4SHbAhfhyRvJrP9tLFJXFNtfFbKv/jX0P31
	 EU9eTVpIjSIzQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:31 +0100
Subject: [PATCH RFC 04/22] m68k/bootinfo: let procfs copy out reads of
 /proc/bootinfo
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-4-c9492ab08480@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 83B97C000E
X-Stat-Signature: sih7zskbpcnepw5y5hu3chp5ab6j65sc
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631780-467613
X-HE-Meta: U2FsdGVkX19akrS3ClhYmyKa6A0LXAMDvb70Hpj6PFcYct647t7WSEZs/y5t+WFcKRMRBdoB5rjRf0eRpi4PsibBsumVBNVVKOb9rXjrvvSses7XmKELez3VwRk8WxVKQIhzSN/Cb3MnQF9D+GMAAQyf2o316NfTGUmGzhhYXxEi8LOf4meqhES2cV1dZ9qZ5KF6uGBgiImnrnwHLfUhc7fP5FKB55cqSV7kgd9/oG/Q3joZNlw+oO42sVeozZHOWovoLb3vH8ddNiCf7fuGHR8w4SaNMQ7RiEi7pCI0pouK8TUesignKT4ENGP0C+Lpa9n0qxFVdocgvmIvgZaz1vyiXlAZCfb8YYQqD61KlOAzoK5uWEtdvSFmkGEdd3YmLwUwb3m8YOb0rLKOkd9o0YjslzNvmrN0N9a1vGSH/m/QSM3sDN7Bw9gfCD6V+GNkW8lcHIrw1KNG8kI7pdkOHBwz2wN4zDI/hkkr0VmJoc3F5FE57aH2UZj6cvSmVrY8ISJdMoS+4eX9XIIg22/5OtX9Jd1UjOc8oFsiXgIRTRVjYwx0TE6YZ2fsQ8N/kG2lBlKoxk2w4RhTmajY1VjKMYaVOem13Y2aQkSJtp40dRi2r1NnoU1O/y8CABCtFU+gOXMpj7QsfmCzbi9OyAZo8GxYBqslJ5nUHLHQQ20qVbGAnxbJ5JWMiHVaHmh7f3xv5wQZt+5wiPQ3za58IzuVR9YBAu4F6xEWQ0sgOlNNJ2b9sy4sqORSbnxaE4kBIHnb0UQkdEJvMQaXFIz6bB4sAmehwA9enDJ+46yUbSHs1cYKwsavZFzW3XZWfIbX9VOC+rvJ7BBBKdZaAx9hZb6cxrFeYGMCYmz8NiVCtWy99AvPPVgmNvl1OraBFZUVlgwq2JqxOFMhgmxE0f7jAimf9SFjcYyzePzO/3dIRvuZe1QPUxnGbqseiWtlV3O++37/P3cYw9QC2fi5W/0FiHb
 fDq1iIyw
 2nexuTQs/gnnD51Y1oWiV7UQI1sPSWi17OIoHkfgW7FeC0j2pAjkVM44aPrz+sJrpbXU5f7+cWb2AcZJ/6TYSO+kY88cUVr46jYd4WphuVQ/xotI+svtI8HaxIf6bYIb5xGITiptZvi4K9sKgiFdwSDCf+WaN018AfnTfsS5gnvSR6RH0KE/2LgT1dzfUSQd+637QprHRqhAnmvjYG5Wk9LR5aYXdtuvvqbCso43HUrY7scb56YKTqb7gKSEoePS/A2etJgi8NvMVsWSwuth8Z5Gsig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/m68k/kernel/bootinfo_proc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/kernel/bootinfo_proc.c b/arch/m68k/kernel/bootinfo_proc.c
index 857fa2aaa748..4936cf44e86a 100644
--- a/arch/m68k/kernel/bootinfo_proc.c
+++ b/arch/m68k/kernel/bootinfo_proc.c
@@ -19,15 +19,15 @@ static char bootinfo_tmp[1536] __initdata;
 static void *bootinfo_copy;
 static size_t bootinfo_size;
 
-static ssize_t bootinfo_read(struct file *file, char __user *buf,
+static ssize_t bootinfo_read(struct file *file, char *buf,
 			  size_t count, loff_t *ppos)
 {
-	return simple_read_from_buffer(buf, count, ppos, bootinfo_copy,
+	return memory_read_from_buffer(buf, count, ppos, bootinfo_copy,
 				       bootinfo_size);
 }
 
 static const struct proc_ops bootinfo_proc_ops = {
-	.proc_read	= bootinfo_read,
+	.proc_read_buf	= bootinfo_read,
 	.proc_lseek	= default_llseek,
 };
 

-- 
2.53.0


