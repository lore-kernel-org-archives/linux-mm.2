Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17082606D80E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ME/FJRfX
Received: by kanga.kvack.org (Postfix)
	id 19CA36B05E9; Wed,  4 Nov 2026 14:36:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125506B05EA; Wed,  4 Nov 2026 14:36:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08206B05EB; Wed,  4 Nov 2026 14:36:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C769A6B05E9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:36:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4EB2640839
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:36:09 +0000 (UTC)
X-FDA: 85398442458.16.7BDA03A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 82A1820005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:36:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ME/FJRfX";
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCWYzTdROaZ//Ublq96X/PsjFPNs26aKqDomYMjplOg=;
	b=MlZ2iodTBS7cukrDBm7VJVyFdNH69lkDIyPHCyCCUPkhKUIVBJJmT3CKqsD2fhK65ivg0D
	9XAGlxrHkGbYSFuTKgqyBUVezRfEZ1QKy8hJ1FeNSfDGTUUbhAzy5gDWdMHhrpKtO98EHx
	DSPmc1gmEiwX9DFWiMR5D0/JR+PtOo8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820967;
	b=mWgOUxUL+RJs9kWUbTVo5btzptlHYILQDqEfkzGY2yyaD0LgVTLwbiETYyXEmsQSFjn9N2
	HP26KRi/iXQpJJZ9ouvkLezBgXeME4nz/owUJI8mP5CnL/tIHMlj9SnUZdvWnys0MUzKbo
	YbiLjtiGujCLRJJi6bH5KBdmvMLNtu0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ME/FJRfX";
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B748743B3B;
	Wed,  4 Nov 2026 19:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AA31F000C1;
	Wed,  4 Nov 2026 19:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820966;
	bh=RCWYzTdROaZ//Ublq96X/PsjFPNs26aKqDomYMjplOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ME/FJRfXHJFiJdRPuFY8HbJeu+GJeM1uYMSHhRXC3OyCBFoBbHe/D+KeCbkSHUcc+
	 kLRnw4KPAQXBd/Lm2rxl+osnRqATeVzThclIJcTYxyw83fwPKWjsdttrzz2MJEJ/6F
	 npCV8gjOwaHDC61e0ru1NTfEA8b0b9x7dSf/HzSrhuivx0LurSS5jZoyjtt0F/X5HF
	 VXCm5Gcq8bWGfXJvVTfcnPDEXQVmN0yImiDrAgCIzYQ7ciRBherm+QOR9W6FvpFf9V
	 +E2b6pif2bObHvbMb8emuD8Je5Z+LHQE+m9YVr5ffRfEUXrIRpnoiS5t/MTpZE9nue
	 yYDTpnmmsO8rw==
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
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 01/23] alpha: srm_env: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:35:52 +0100
Message-ID: <20261104-work-procfs-arch-v2-1-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1631; i=brauner@kernel.org; h=from:subject:message-id; bh=ud6jo66qun6GxlQdhdvRvLMRIAP9XF8+raIGbqJmJWQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97ngrnBxmYyak9tmw1FJNeJLkRYtVzupn21htlqi1O tScYHfuKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmMjpJkaGRUtzVix3XJqTVWf1 dU6h87OwGM+PZ2ve597KXb144TfGWIZ/ZoovQk90zVv4S5HDJPnSp5RpZyfb5iyb8PbjaTdr44T nLAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5c7xwcc6howzbetu3ukwy6tjq5w9a7kh
X-Rspamd-Queue-Id: 82A1820005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820967-4753
X-HE-Meta: U2FsdGVkX1/5gDqig+5vYyDSi4e0FI7+PlbECOg6ElpPH7uLzRY7TQZUbhaI0Wv0z+D1XAXB6Wu1TugI1ndZ5xEBsx09zgZTNSFI5M8bNsP91pth45DsTI9365JKcHeW52XOg5P4EQuOsTIRqkVJrxrBQ6Py15t7Clnst3cSuxDK6vFEsol++DYbT0EMl9kQlz+xw7IyKt5v8CR5awGGnYG9/YDukSF/f/YbJpBFm4iRZvtk5NqTQqRbKetfNelYi3HA/a1Zh3L9haZ5Ywr2j7ouOar/4JxpKWCqDM+k/cVLmRmioiBReoX20WdYcYeoplCbP3Hbuqtx222O4yVGOR+23cqQV3IjjYBligQWTl2fLr3T/rUOE+pSmW2PRpdRi2U0qxLeWZEZY+DJqB4lnkwXTnBnzpOqYztKjqL1TIdkwj0lXe7jgRdPglus6drchlcAahI/lLfGwGkLb7FIrTxWx0vmIoxloeGqb8K0qvccD/mNOsC34XLH2+/eoAxgPVNgcl4k3T5LeOemZkOEqe1921IdVHTkMRkxwBS5yaNpNaIFbqlfDUlf7PgEHoKzBITMfqqT0ipYe2OCTwaeWVk+2vzAYnEoT7FLYt+xyi6sQC0/Vk4KWFTqNG1cF7ZwnT/QSerMeBQmlsgf+VNBXZ7ciM16Y0NISO6Z0/2b7t6D6+oCgJyvLI4jMJdnDBU1K/BY5iZ2/yAsuJupgRyLPWxbcK1avzT8Efdkx1ci1KHfDVLw01aM2/VlxcmdrGpqHAJYQU4C8CQVY4J8za9yOfQ6XDh5VcTCwNtxSwRcLxRuJt1P/UpuyfY37B/tKK3WKNS2AW7PZaD4YNJGMobI2aKP1k+Efk4f5dC3YsXTJe7j3hPrOZvNnJgFo+ESlGFZm8fxr1HdowdsNJSRTYIprcuHfTgUFA550kcP/Fnj9fe42cbqXGSHO8vSTJoLjohHs6o1P7tS3lsnn7p7DJZ
 27QBv/b0
 utTXBhvutcRvSuk48DWrzchqzSl/TI89Ouekq+zzJCkCddid23u2Epn9UT9FxVuVMHrRXNlq5Ku8Qrf5EOd0PX0ryjmD97tSlus5l5mahL9ofo1XwTpNQMRBouH0/IWEY1aNx0P9XVEEIropgpKoCRxo0XUGvgaRPUxz6YXxxXVTCqZaluCIKFV5iJzlmKFfn9Odp9edGtcKIP12maMmsjrERsltdDyiXWF5MuVp8T8rLNO9tWy7jp/hDQ2A+gawab8G3zwZLTpeAwrGcVrviKrmN67kOd6F7YeD5/xbxD5qZMqVxmYlp//BghmgIV0+5jZ1Mnjhu3+0ZfB1pvyAXedYBHEq6Paba72apdS7GY9TqGEiopH8p7n+0CKwa0ExcTajvND/LtuQ80bkeQlgV2cxp3KR8uxh/3L+RHgSnY1SLzgmTI6hV6YpUrmOU63SFtVXb
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


