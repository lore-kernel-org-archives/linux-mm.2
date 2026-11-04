Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B8FA6070423
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L+v8MGUB
Received: by kanga.kvack.org (Postfix)
	id AAB046B05C1; Wed,  4 Nov 2026 14:42:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5B9B6B05C3; Wed,  4 Nov 2026 14:42:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971C16B05C4; Wed,  4 Nov 2026 14:42:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 716146B05C1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:42:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A1C9080861
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:42:58 +0000 (UTC)
X-FDA: 85398459636.13.1D61D49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D97CF180007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:42:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+v8MGUB;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rahx1hspTnUUAQKpjFRic8Zz7t4Brzv8z/TuH1t1gO8=;
	b=smFSUWokTBDahyABBimkngHKr0XaKI6/juL7JYQE9P3yUjpTxCa3d2Ytd2MvUtKPZSOmd/
	wOPr/noi/TuCKwRDWiC4xYZDMQKVoD9eP1F1EIL0HKraCqYkqbWTXrzdMhEN0Wo913aa+C
	j18rf/B0BWxx2IO6H78wUSwjtuLbB/8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821376;
	b=NUpWbsyWOSnlUTOD6kvFZFs2p090zk6jmqDa02sSkSI1K14vzkxarHIjrhqZQHzPNCcnDj
	Gz1LEZSOaIy9UvgT7fulL7TcSDZ5NNQ2DM7hfllPgn4hXOvDvXql04zLX3Mth7mdWh8WwJ
	ho787+aJfEHsanCVfJw3ZxEbGjaxfq8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+v8MGUB;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 686CC60F07;
	Wed,  4 Nov 2026 19:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDECB1F00A1C;
	Wed,  4 Nov 2026 19:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821376;
	bh=rahx1hspTnUUAQKpjFRic8Zz7t4Brzv8z/TuH1t1gO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+v8MGUBoH1X/DvXSD0FceOQi/7/9SNVN/Ty1A0Db3pP2tRHNvduiU+oluwXEpYIv
	 vBloEcY3uuuLcYM/xkh9Q3Ii2iBnjyZbDio64xuo+SFrAPccC7M1STU5AfhNZaWOa5
	 +nP2mu+sMxiVgQETEU4GnEEdQBOVRnqy1LIn5OIvtUx8y3NHNRNYHmSudIvZhlAsk3
	 OeFfLyoqwVLhzDi55Du9gghVSwsVXKB+q9IGj4gdTIup4tw4O6Yjot81gM8SBfXGlP
	 DerjiZ0JrNRX2zN8YxL3cqjnpijuu2TiisPtmqNQmMQzMS3akxk6dzKVcJZYEqbHRC
	 UCnxPV/KjlSKw==
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
Subject: [PATCH RESEND v2 02/26] zorro: let procfs copy out reads
Date: Wed,  4 Nov 2026 20:42:41 +0100
Message-ID: <20261104-work-procfs-drivers-v2-2-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1540; i=brauner@kernel.org; h=from:subject:message-id; bh=dTcni+P8tIxBcivisIxgfSpNG7N2UBKEyjWqJewPrL0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97iqNXrF3deYLX61HjldsFnR/fLzW4ucS7htqmRfnb lp9iV3QsKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiHkkMfziO9O96MiXH7oKe 3ttd/GcsTDguvkv8x6Mk19PlFNXPtoiRYf6v1T5HznUdqLi4/U2FCv/VOxZvpb9rrKvZvX3xnf1 XX/ICAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: y9xmkqksakoru31redd5ckb3ti9pcuzy
X-Rspamd-Queue-Id: D97CF180007
X-Rspam-User: 
X-HE-Tag: 1793821376-873058
X-HE-Meta: U2FsdGVkX18CUu32sNjnRpxCXQTDer8u8eA8j/99Gp/SWy/02ErNz4OgZLTc0vgIZAacKBB3qC9GdCqW0bouM9O56oQVT92WluU5GTiCviFcA4Gb430r99vEJFlpqbyJhOL4xTSlD+Q/5oDa5o3Wqk/syIyqWposXOAHK3SGc8asm8Dnr/KOoXR5Zh5NFxJkXBvLlHCbXWinTRM9M+qS4gm4OkA8IxKTtW5Lsuwi/JmHqtxq6SRJ0bMRjUjST0J7S2E054RNa6pW184EOetWD1qvbp3Ay0O5J2XHWPjBjmnzsnBba7lH5XzDIpCfbbEFZFpGKIGciLFe+LDS/ir1Li7bgA7jgr+12/zPHQo07NQdTfN4UNOZg5H+elLJYJ4LXgn1VP6GpSDAvMMBNeITkCatwWlM+ugy4tqYzYv1QM/MrWix6KhvcuXazRYGuBxlio1GJOAgQ2itbaWJmHh8jPHqMZv4L/ISFt14WtKuIinhBuVKlV0t53f2hbhYIfjbT6zFlPU3ZhpTK8c3qN6BKu1pOcf7BxdlZkqw/tyf86XtFk8izqp+9dVbiPZxxoq9hNwNz1wJLOirHNhFY9EyvNhqzoB/lY0EGcyctK3GI7AxJgKCVPusT9OHPwYvqJu4QlV/ev7JPu9Rf3i7bfLF47cMo3MMrHmEswvgRGHuC9h2R6EYYdBeeGs94s7GSAm2PAVqJWetTy/c5o7U4dHew/DZff4WOSnQFSXmcbkq48wmVEEyvi+QjSJ6Y0x0XVVyKomJ2oW44ZFgrCknnzwaSNmsCKp0bnL848spLkgQkdxm39qATRU56izPsO4rbY0367t3dC3fF1rNzua3YHImt8RKEjunGJkyF328K631UIxoxZZ7iAQkUo8OdAvdM2gwHU0FXwoMcDzSfW+U3g9nQtSeg7yPqEtZ9Sy0msTCE0Q87dpNnyuEOQXGgZUEQPq5lLncKlWsFjQIQb0PQlD
 U0CG06dw
 zVq3WbnXzCoNs8/TV1C5PNfSwxOZ9hq+hwVcgEQIWRvwrrZzHKDowdmEYu85XEtMGegOZ7B9RM7O7bbwGsGUIZdaR4qXq6APTtYLr2ffZwtbIm0u5HJXL9ITwQ5ND9m4f6NvZ4GP6RM74qB966LOUZxLOPgDTgwvd+RG71Sfw54diDV1ZdYpUyzhBAvOxKu/W/+oIDo3hMG9r8U2mO8YvL/vQwpWLGnSDc7QXIEO1pmfumuIvQP7hvmIrAgfe1zwm0wzpfYEkgOvb5LW+4zXcI5EAbRcaji7kTzEEEEgaAjok/WrZAxsZicUwSKrD1vAhGjde8tlKeIMBpn8dKN7xHRIp4K8JlHm/dqIB10GwMUaNs/1LkcsN8ftd6/QVp/wyT2AwyvQUsPU89l6TuzKMpDnqqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read from
/proc/bus/zorro/<slot> to userspace after it unpinned the entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/zorro/proc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
index 4c6f8f1c4d71..99a8b478192d 100644
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -28,7 +28,7 @@ proc_bus_zorro_lseek(struct file *file, loff_t off, int whence)
 }
 
 static ssize_t
-proc_bus_zorro_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+proc_bus_zorro_read(struct file *file, char *buf, size_t nbytes, loff_t *ppos)
 {
 	struct zorro_dev *z = pde_data(file_inode(file));
 	struct ConfigDev cd;
@@ -49,8 +49,7 @@ proc_bus_zorro_read(struct file *file, char __user *buf, size_t nbytes, loff_t *
 	cd.cd_BoardAddr = cpu_to_be32(zorro_resource_start(z));
 	cd.cd_BoardSize = cpu_to_be32(zorro_resource_len(z));
 
-	if (copy_to_user(buf, (void *)&cd + pos, nbytes))
-		return -EFAULT;
+	memcpy(buf, (void *)&cd + pos, nbytes);
 	*ppos += nbytes;
 
 	return nbytes;
@@ -58,7 +57,7 @@ proc_bus_zorro_read(struct file *file, char __user *buf, size_t nbytes, loff_t *
 
 static const struct proc_ops bus_zorro_proc_ops = {
 	.proc_lseek	= proc_bus_zorro_lseek,
-	.proc_read	= proc_bus_zorro_read,
+	.proc_read_buf	= proc_bus_zorro_read,
 };
 
 static void * zorro_seq_start(struct seq_file *m, loff_t *pos)

-- 
2.53.0


