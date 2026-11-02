Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79046070CA7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g7GASIyP
Received: by kanga.kvack.org (Postfix)
	id D01B96B05B8; Mon,  2 Nov 2026 10:02:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2786B05BC; Mon,  2 Nov 2026 10:02:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8F26B05BE; Mon,  2 Nov 2026 10:02:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8196B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:02:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28965A6CA8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:02:12 +0000 (UTC)
X-FDA: 85390494504.07.73A6663
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 61C391C000E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:02:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g7GASIyP;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631730;
	b=uug96TXbCqPNyYVvp4BwlsbwFZAGeAS2eMJpMSK8BlptYP6ExVnu8zgbqCxGjqivndyAH3
	M21z5rz4BKTT3TARlraWHZo9QMxhBZSgEl3jHMPebl+VQqioEo52UCXXYtmTaRRALfczye
	HCscsnJK3L3NpdmJQq+qNvTPy7sL/zQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g7GASIyP;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCWYzTdROaZ//Ublq96X/PsjFPNs26aKqDomYMjplOg=;
	b=Shk0XJ5ifYVvjTkB8AwO3v+O0sjXGsI3+bjIl3gE2yxa1tT2Gq28fayAGH373n46a8BscI
	DskeEP7EutVTC7eB4sQ3jFaS5hLz4CTHR1Es+Eg9EXLUCEMD65UEApFB1gpvYyHe77ZN9+
	Y6uZJAB49uvUYRm0l0igRLe7NJWKjbg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ACB6443EE2;
	Mon,  2 Nov 2026 15:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB381F00A1C;
	Mon,  2 Nov 2026 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631729;
	bh=RCWYzTdROaZ//Ublq96X/PsjFPNs26aKqDomYMjplOg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=g7GASIyP66iaHneT0IXLyxGE3Gv8uk+u36p3s2m270MYuKSf/lxqLAMSRJOW/mN5b
	 cqw43daYhwXjGaH+bT+uzWlv1RtJgVmK1pKNWgKadSoQ4YP7xysJZZNazw538Ya2w8
	 aQyWb7PBw6LuxEkCbQCuHEsb1KvYSgmQDTGlChVmndzt2sLknpmWaqisu0NyUvlM/y
	 hG208gvk6GSsXAzvoi3yhFcxnrvr/4f9iVDAGppDZvhr/8T+2kNPcVMo4GJLXJAgLG
	 J6pV+INZeS4SdtLtP2ZjONMRNNmVsgjQI6Fx9jjazJ3kAgIbreGUlE2x6BQYTDKlDz
	 uF54rLOl1jq1A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:28 +0100
Subject: [PATCH RFC 01/22] alpha: srm_env: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-1-c9492ab08480@kernel.org>
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
X-Rspamd-Queue-Id: 61C391C000E
X-Stat-Signature: 5rmyud53gtht5cp79hxxsbgmuu15oa86
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631730-670609
X-HE-Meta: U2FsdGVkX186S32elL/4Ysoe6oDi6r49uqSGix/a+dll9r73+Ixk0NMq4TuKYTa7a0LcvS/2109IpE5KS8B81IN8iMNkI6/vcgLDv6M2dFKYJV47XkALAD1+KsdQc+02SSKWpwH55ldWxtBeTDxV8O3v9001jLGl1aHMoB6UJ207DrUot6qOKfWtyHSeQ85h/y6pGhjmobMqDfwDBZQZkMCgw75D+UByQA4mUZRNJ/N6bXzbKCjqnH70IR6hQW/Wgomw+ZoqPpl0UvQLKpIcEUGOTl7dvFjxsi35Gu1kjayGLVzyYzcUfPsUTE6nC+zQRRThWCp+eGCTAMy0HNyTSp2tTBhlNZtYqN+TiXniaLpoi+MUZJ0Q8akyBToRjMqFA8uCXshSO9XY9l6Vr1xIAMnqE9xPCqTK50h78QyWlsOeyVd4PI8rHRB4vbAt6Dl+9FFxdkRMPcErFXQoLfLbp9QR0bkx92wpWrhhztcfXVRE79SshSPrwugJ3bKUU0XsXB0XVwnhjVViCIhvfffSYF8LCb6IxbM66fvsglHhCiWsmLue3SzpBF+KELK6pFz+ByoSRxjpdPaj52aNCEXXHmH7/aOuZTK29bQXPAIFsHjKWujMSDO7aIkYSZOTzkN+eL4gt6V3i2HNqo8GoCBClo40DsrNgUMBCf7SweQj+jCX0vDnHSQulOX8le0vHbydK3B3LKw8yfUhwRZ3dnVTc2uHFVerAJV1B3bzkSyuRq1Cono4Nae/eMktXo3chpAz+cV5E8VN1RpmqtE/IjOKEgoan+2r1jgOKbWisdspaRrYB6by4gqgKzuZwacYd97xtA0hIFWs/dH0I8/ktrn7PquoncUQR8b7hzriHyRQTiMdhvyoik3lt8UQ3a72Zk92G5tmSkDCLWY56axdkTObm2Uz1NdD+OJntdwOPEkMVveUaNqTpRse0G4tbuR5U1soXFL42bGf0hpZQg20q14
 2PiRsi7Y
 CWqEZJY8Wa5hn9XLVzwmnG4mmthJDVnucEzm+0Kw5YXe7PNTDbiYRZkrsCmdXtqhX9GdT+OKV7R8f6FYyxXVowVaV9r/cp/oW8mbgOqWyreB5IfFDWwGwVy/niEUhCQgyCujjzQEXL7NEx2dq8iFjBW4tgP0tL33Vk+p/XWDwXiVpPkGc1lYOJYT3ePKA+ordoytE9LmfF01OThz4lEza2gCf549vkQBgbtmMWypYnBr7SVc9mTCQYiMysbpCgEMVMyXdLYmISD9ECVK+UyCiEdLiUJ8rfLFHU6fvX1ItRDNIjrTDZwf+gsUjs2kg58jIs9i4ktjCx1k3Wd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to
/proc/srm_environment/* before it pins the entry, and hand that copy to
the console callback through the page it used before.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/alpha/kernel/srm_env.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/alpha/kernel/srm_env.c b/arch/alpha/kernel/srm_env.c
index faafc2df7886..6a1742b09a82 100644
--- a/arch/alpha/kernel/srm_env.c
+++ b/arch/alpha/kernel/srm_env.c
@@ -81,7 +81,7 @@ static int srm_env_proc_show(struct seq_file *m, void *v)
 	return ret;
 }
 
-static ssize_t srm_env_proc_write(struct file *file, const char __user *buffer,
+static ssize_t srm_env_proc_write(struct file *file, char *buffer,
 				  size_t count, loff_t *pos)
 {
 	int res;
@@ -92,13 +92,8 @@ static ssize_t srm_env_proc_write(struct file *file, const char __user *buffer,
 	if (!buf)
 		return -ENOMEM;
 
-	res = -EINVAL;
-	if (count >= PAGE_SIZE)
-		goto out;
-
 	res = -EFAULT;
-	if (copy_from_user(buf, buffer, count))
-		goto out;
+	memcpy(buf, buffer, count);
 	buf[count] = '\0';
 
 	ret1 = callback_setenv(id, buf, count);
@@ -109,14 +104,13 @@ static ssize_t srm_env_proc_write(struct file *file, const char __user *buffer,
 		res = (int) ret1;
 	}
 
- out:
 	free_page((unsigned long)buf);
 	return res;
 }
 
 static const struct proc_ops srm_env_proc_ops = {
 	.proc_show	= srm_env_proc_show,
-	.proc_write	= srm_env_proc_write,
+	.proc_write_buf	= srm_env_proc_write,
 };
 
 static int __init

-- 
2.53.0


