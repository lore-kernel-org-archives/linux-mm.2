Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DD46606B0D6
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=htIvLzE5
Received: by kanga.kvack.org (Postfix)
	id 6F1EE6B00EF; Mon,  2 Nov 2026 10:07:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C93B6B05D5; Mon,  2 Nov 2026 10:07:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 606336B05D6; Mon,  2 Nov 2026 10:07:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4207A6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:07:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D62348016F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:07:35 +0000 (UTC)
X-FDA: 85390508070.14.78F55EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1482FC0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:07:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=htIvLzE5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jqve5dom8G0YagWg0DUi21Qt2CUJnz11dMCfHhOCDkM=;
	b=tRkoX08Wkw89HeCeIYMmbubVgzKy7Cy8R9IWNfm5/5Bk5xwRNudi3F4ACpNu0cgdeS7nUX
	WMJBrhdBerU+X4vwJ8lWpWcEuB0gl3mxIO6ATwGubuRQEf9wkfd7FsgFqLqoYUzSuCV3JM
	97wnmwSzx3QRRb2JGwa1NyH9lue/UJw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=htIvLzE5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632054;
	b=S5tsLJl/GXLQc49q9jq2kTW7rgRYNA00R8qADt4IknWwhFPyOahJuH7M8hBIZwc+J4iCE6
	hAkE8jahWoKtTy7z2YRcmYdcTTPtIPrbi8hrE+vAP7pGadN2NXcm534WtFiupO3Wpdo7VJ
	CynKv/GWV2G92NGh2l6LMqWQWob8UWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44AD541132;
	Mon,  2 Nov 2026 15:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC3F1F00A16;
	Mon,  2 Nov 2026 15:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632053;
	bh=Jqve5dom8G0YagWg0DUi21Qt2CUJnz11dMCfHhOCDkM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=htIvLzE5mRDE3y0tqv1kyv8W5k1g/Ii7ANwuWhratSAOFS7tbxL3BToIPDpZE85DE
	 FNEsXXzLmfR4qQugMxmA9eyhIHm6Q6dJAmTZKLeIUK1bHgaHB6rg72WkRZftlCgoe6
	 E2QfeUCqIA0Nboam57Dh1SlJUtOEamqW0FpuXdYHq09VCiD2DRiKvdUgmVI6MwZESI
	 HWhsjmhK16tI0mtjDz6fsLrdm37sQrZUo7icVQ6YX0Qr2rzi5YjsmWINl56IQd0nMx
	 zqjv85Bp1EemyFNq5w6kuaSNgOUZ321NOGqFqL1mOki6ZfyR8nruUh1khBiylH7rMN
	 bCkpWmWU3eNXw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:44 +0100
Subject: [PATCH RFC 17/22] ACPI: proc: let procfs copy in writes to
 /proc/acpi/wakeup
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-17-c9492ab08480@kernel.org>
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
X-Rspamd-Queue-Id: 1482FC0005
X-Stat-Signature: dhdiii5bbjwqmndyzfdcrxjrhyy91j1r
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632053-147351
X-HE-Meta: U2FsdGVkX1+JLs54FG66ucBzoiyE+OEx3WXXCgr9MgD6X0KVlWsqiMn6RrzNT3btPiBo53JOFrTFWKDVuJ/EXsQkpLZhpa+phnibbthkG4zf855gJRkxP27u0P+FSTdc49HEJQAXcTwA0EpLGxVDMGvfvvv6GFiP8JE9tp+aSvakMJhe6+Z4mBJ5TqvCZLgeRF9LGgDjxO68R9mBZvnX/0cM0ZuvQ5ON+vNQFMy+WgEZT4e0wfFhpGLOi5eEFbbpu0NQR207TWn/ggxOh1Q/SdwBlS5QPg0gsgxyoZdQzbNIvH6zARHIiVdt+KKJydk7J29raVuIWb/CzB2Yjqb6dua80E9ybU10doJfV7mXdZmtiw0cgD3r0nz50y9Ezzz3IIEJ9YlkZfuMyqp3EZQG/2S+nhSwMC+UsZRy/GnF5qkjaIU+TH4CR27AfjrvdOBLWT4WvNPQPq3Ux4rRjSdzBCchWM3+g0LP2ERNga/BBaQA2XONHp8ueDV8G0oZ7PH4LCaF82LNqEkT2porvhDxoVJhXZX2qBL4q/Szdx6OA8IQF2UoLWtuDv9f2yYTX4S6kwc/JDO8i95FFIBZdtHwMYw/JdZDHVlrhY0dOkt/e8A+c7USiS2ZtmbUZpns2s9CfCgRPvhQ+5E4BjEgTfziJi1Ckvu99B2iEYKDvzV4UQ02mAbX++4ujmH6Lk2jjNJvtifuOYpuVyhoNyAbefxu3CWPKCs0liKMvNjrFXL7zouq3SQPi2uJNoJoBMdKE3ChEEqpo9HGigm58AA183RA6v3kd+e/w9woDztFCcL3y7eZtDY6pSKJyscZnISHfnOuAoGT8IGFGtwfYkMH8bgiVOZFdPtU8ToYNeXQqePYQPrgR0yL//v94BENcJ4dLjmsz7pdVk0t/HhCsh9OOmN96Ouo8qaVtDgzCjSqIssGLRc/EqqM2Qla+vAMElwDaclAqN+vCuanWAhyt8glrbT
 RZTHt9fz
 nvJBv3t4t1rVS/hwVVRbrc+kV2MsAR7bxTSIo3wBlLycCbkrhOU8RIL9abJhXmr4J2nENT/bm0Jv/zby5QmjKPDq8MAAQkIBbn6+UkC5KNmM/jKO+q0TKA/sNuyfj3UqW+b7NcDcIeY847WGByI8wCFfaj3I/zhm3BWuSgWKtWZmQh8UmE4NWJu+awK/Y0q5Dbru+pX+hI3lNAa6a1DX+o7vwk4BczfT2xqolejiKhVamCSLwcgwIBTMlVfeKSaXrBPqRNKZZcnQyPO6C2pDYgf9vGmSF9CHqpCHT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and take the device name from that copy. Writes
larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/acpi/proc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
index b8a0bd4580e0..feb8283fd855 100644
--- a/drivers/acpi/proc.c
+++ b/drivers/acpi/proc.c
@@ -86,7 +86,7 @@ static void physical_device_enable_wakeup(struct acpi_device *adev)
 
 static ssize_t
 acpi_system_write_wakeup_device(struct file *file,
-				const char __user * buffer,
+				char *buffer,
 				size_t count, loff_t * ppos)
 {
 	struct acpi_device *dev, *tmp;
@@ -96,8 +96,7 @@ acpi_system_write_wakeup_device(struct file *file,
 	if (count > 4)
 		count = 4;
 
-	if (copy_from_user(strbuf, buffer, count))
-		return -EFAULT;
+	memcpy(strbuf, buffer, count);
 	strbuf[count] = '\0';
 	sscanf(strbuf, "%s", str);
 
@@ -123,7 +122,7 @@ acpi_system_write_wakeup_device(struct file *file,
 
 static const struct proc_ops acpi_system_wakeup_device_proc_ops = {
 	.proc_show	= acpi_system_wakeup_device_seq_show,
-	.proc_write	= acpi_system_write_wakeup_device,
+	.proc_write_buf	= acpi_system_write_wakeup_device,
 };
 
 void __init acpi_sleep_proc_init(void)

-- 
2.53.0


