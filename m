Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97F23606A920
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GZiOx3qz
Received: by kanga.kvack.org (Postfix)
	id BF9AF6B05C8; Mon,  2 Nov 2026 09:25:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD19C6B05C9; Mon,  2 Nov 2026 09:25:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E286B05CA; Mon,  2 Nov 2026 09:25:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 947736B05C8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:25:06 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F433120136
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:25:06 +0000 (UTC)
X-FDA: 85390401012.27.13A3E14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5A6AE100006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:25:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZiOx3qz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yb3WLcVokXU6BuV8DQIS3cnoxrtkXR+HXTNSt4lhnr4=;
	b=sHBqtV6mtbqoslloKdq0Qbq+2Iwhrf0Sqh8MSSB7pX6E0OgDpeXFJVTBGtCbdb3GHGt+CD
	6SXXPGsnd7VWY5miiEdNusqZjCbKKEnDWsHtg7XcxMBQbIZyYz2qL1LMTOMQykvI5TkGhl
	ggK6M4SAS+1Ffn4jWI1LgkTl/meMQCE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZiOx3qz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629504;
	b=8CBqPow275RBl+83Hfgn/3bnCTnkqHCEEC1cW6S3/4yhkiAsguxe+dlDD2miJH9RLzGKfG
	V4A4OmAtj1jgTgGzYPU9neNwmuipSVkKn4gxUbZnhmUm1KFNeOtm2lKeGpKla9E0n/NAhI
	+1AvweTchIwa0U5tRc9kZcIvc924NtQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 988FC41838;
	Mon,  2 Nov 2026 14:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514531F00A16;
	Mon,  2 Nov 2026 14:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629503;
	bh=yb3WLcVokXU6BuV8DQIS3cnoxrtkXR+HXTNSt4lhnr4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GZiOx3qz574i7G4sq7Qj5FW+poGzHx4xdod9v+c0wQs044ndbo8YtJuzjzz+Le7ql
	 5cTxXE9CzWg6EPV4MxszbcLp2C6ZsWzp9oeVP6uoHj7upUPwwroLqNsh41Sz3JVXM5
	 yckoX19xo0T3oBfUMO+m7+UdClsC4AicPeSVsnbkVWlzvS64GY4fx7NtE/3cBm/jGz
	 ZM9+DG2Es/IdFoi9n/atozhLfqSzs42elqcEif/j8WN8Ox6UI8UdLXG/RdqSvOSB81
	 382CcANAMk/or+82KJJBXqoD4yYyV3R1x7/mjd7dPFt85mMcg0lpgdBZ0yY6v8VJOz
	 OgF1Yl254onGQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:29 +0100
Subject: [PATCH RFC 14/38] um: NUL-terminate what is written to
 /proc/exitcode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-14-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
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
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1042; i=brauner@kernel.org;
 h=from:subject:message-id; bh=wRElBRQ5ywf1BhvCA77KtICLks8yyr6GFoKnZLCCyMo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJOdsKVmvtvqn+l+CqJcqhVTz8/M753i1MLdtPdJz
 RS2GwlqHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5E8LI8LBw7tKUPiXhmasU
 BGdI++krPrfymz85hq3qxbk0wQO2RowMt9ZWzojz1tO+4XPUNkxeX7nqYWvpvKrUmfx7rnks+Nv
 HBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 5A6AE100006
X-Stat-Signature: kty6ysbhuqd8j7g1861tqchzjabg3ir3
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793629504-149361
X-HE-Meta: U2FsdGVkX18mS06QmCmKM5HziAYwjZktWFLDRAOXrOeO+nBm7ze7WORx3Y0mcbJmHH6Z8aV+schsc1LfCFkyKFJ4HuJ6CRy1NZFF9ANY9ea94mQkhjRJ/RECqesWmS+hAaa6VDeKWb+OEaUDEgq/WSEV+fCNfLBRNiFU3lTvyrzt4eAc0cqZ8CVbTgGmp5MS302vgeYj6NXMGqRT9rLVAKAVxNJnjVRDdUVzRYSnl+2cNkI3zr9l1PBuJ6jzCXla2LzL3Zx8rpu3gUztsHpvhsXJIYlIQGKdgz6BWtvGOxR2WZwKjQEkVy5AlmKX/djaP2SfxIlvPmbsKguL5zzltamDF91mc6bwjpzEjiY4jKmeGU8GaNJlx0wGeCM9qt1Lgk9wPLm6A60Wut1HoorUWeyKwLljbKoPvEvbf068Z2XzQ9Qur0j2EwO7H4ZUuodn7P4Rag7CYv+eJtR/jvsBeW4i8lBeNN0lGrA/qkCgxRwdNWLfoCcvep2Z11lJBtgB/Hc8W78RHMr4xGIOcfY2trYoJpvba+A0zdg2hvWp6Lxcrf0ehW6VUezLQwW9nRWhRJZeTYhBO/Zm6VGt8JqqPx9QRUmTfxqILpXqxTW7oXL4fgoy0CEVBexyKUpCvsi7BtU97gwFjTFcuYK7n3KGD+zDquc1FQhpvPAm7CG6ilFj7WGihE8MZFZQHFuKT8jJ8/eNF/RGB9XaTPOQlUH5nKb1owACAWZ3LRWtaa5DrNkpootqGm9LrhQ2HDFKhanzXMXxTuw4CK6whNizsU9fJqhF+aOmh8I/CrZZRXJf1nK43pmKtk+h+H5bOcPnUyV5M/Smo/eq4qBr8jHGaOVvaUN4W3llWfQLBAASaf5KLoTXE9D9PwZTaqZCrQ2z+tQtHJpvEZfaeruJ6Kat/cbKLZOlqTYZxwIYu0rqvq0GYzqLE36NvAHdtT5sZ1gQLjZ5lQvE+0anXZWQ079d6mp
 SETwKtvZ
 LdbNrMDYugHJ2YZ9PCBPkWnJdVsKro/5uVRwm/ObzzG0MDLp0X6Lguw9U+jenn7oBbJ/8LACJpKvzNz7+bkrolWj57fUqPvqjNdxGPnk84NdAiU6zJJMtr6G3tzqQLuX65Ju2dvrgbtiix5pRGUWMHhAGcMzdFqlLU/EIVPjua5rd2z5PMY2rjfVwUIm9VXFdKozTEimfVKllAau7P5JzQ1Jn2mBoHRWH2cDltC47d9hmdr77m3W7L6XT9RGfHZgdGJi/ZvWWMIPFIaxAi8YmxsMUAy6sF5WA0RFF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

exitcode_proc_write() copies up to sizeof(buf) bytes of the write into
buf and hands it to simple_strtol() without terminating it. So
"echo -n 5" parses whatever the stack held after the '5', and a write of
seven bytes or more reads past the end of buf. Terminate the copy.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/um/kernel/exitcode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/exitcode.c b/arch/um/kernel/exitcode.c
index 43edc2aa57e4..0230354f4812 100644
--- a/arch/um/kernel/exitcode.c
+++ b/arch/um/kernel/exitcode.c
@@ -43,9 +43,10 @@ static ssize_t exitcode_proc_write(struct file *file,
 	size_t size;
 	int tmp;
 
-	size = min(count, sizeof(buf));
+	size = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, buffer, size))
 		return -EFAULT;
+	buf[size] = '\0';
 
 	tmp = simple_strtol(buf, &end, 0);
 	if ((*end != '\0') && !isspace(*end))

-- 
2.53.0


