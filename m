Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90206606A332
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MEOj2YVa
Received: by kanga.kvack.org (Postfix)
	id B35066B05BA; Wed,  4 Nov 2026 12:29:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE5796B05BB; Wed,  4 Nov 2026 12:29:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4AC6B05BC; Wed,  4 Nov 2026 12:29:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CB1B6B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:29:10 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20480806A4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:29:10 +0000 (UTC)
X-FDA: 85398122460.19.6DC1585
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4AA8A14000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:29:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MEOj2YVa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793813348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iSk3nsArFOOtW91DExIIvIg+E3fTnIkI1uYFn4dT7G8=;
	b=ambv1fiX+nw90r7xmXVKBhoEsmER+1kS9AD22dSaiWBjjm/en01kxSp64+WporTh5j5KV5
	nj8kLEnJbsoIG5b03FoxEzVUlw8MTtTbbQBgCZzb/i1JD6r+jAYc0+8O8YspxUxJbvoQoZ
	VzjDruANEkdvbJuVD0mY3ZozGLsbKng=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MEOj2YVa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793813348;
	b=RaM1Uxy0Uao5dBwVOEWHi4NC712v+Cb2jiJVlHHPJ2f2HzIBpARPZ9Uh0QjRzbOl7aKBqn
	KXTBvq7h/DGdoC8Fhha0CMwyM39VICdEw//codsA9aKmygQLVt/6t69tYBSFLws4NODc88
	A+4mBZUMC27vTmrGkxx1pLEOs3EEa+o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C80C43EF4;
	Wed,  4 Nov 2026 17:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A14F1F00A17;
	Wed,  4 Nov 2026 17:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793813347;
	bh=iSk3nsArFOOtW91DExIIvIg+E3fTnIkI1uYFn4dT7G8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MEOj2YVa2iIdpw5z2/NDh/nS5/9YiUTydJpsuXgkbKBwIG8vtJQvRf2LpeGPo4QZ5
	 w29MCiVMYZK7VIp0BshBq/zfoff8EDzOUsrS5HBn5xxq3ltk0oB2hX5ygXPEZjrVf1
	 854j45f/iRAVKq/djckCLygA7FB8p1Zjx7psO38vVVq4bUsY5bxXVg/eXgiknxxWqI
	 hhIFdc2uOWPB7MwA+0cdYVBWRsQi/CpTqM6ZnNZzgzc1bKeu5HnQD/VzYrhxCaOFwx
	 QQbgQRnwMpXNmlsB9GdCiLATFPIHwQAd48vJlnM6Cja1L8MMtttR8X5ndAXXSShUjS
	 FxpuymjfsN7fg==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 04 Nov 2026 18:27:19 +0100
Subject: [PATCH v2 02/51] scsi: esas2r: don't copy kernel pointers out in
 EXPRESS_IOCTL_GET_MOD_INFO
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-work-procfs-bugfixes-v2-2-bbf7d5546809@kernel.org>
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
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1380; i=brauner@kernel.org;
 h=from:subject:message-id; bh=dmwAod4+27NCncmw2oz8APM07k66EUOhHcJdusbTjjg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zvot03G954L932VP36TuXeTVkvctkvdOUEqnB1ulu
 qr1gnT9jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlsecPwz3hDeHERzzPPdYxN
 RjfC3XXUD1tofTqbtTjgpUSw4qvK64wM82LMu/+u3bKn+1TBxf0qvr9PTk2YlzJFZyPv1Nw/lcX
 L+AE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4AA8A14000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: sit4jyibtwtkoadchrubxb6a891ktwxc
X-HE-Tag: 1793813348-702204
X-HE-Meta: U2FsdGVkX19QEBDdiI0yLVw0sEEDzMEBshcrY0YoVRWAJ7fn6M9CMAWmXwy5A+q1XI5ZXfZX6ReNy2RWv2lD/mK4bryQFRoOVO8i0wJSFriAoykbrww+bV7RN3dsW8qwopWOm5wTGAiCeQrw1pX2Le0DButsRvDf3CRvUkMXz4ipPPoj8C2qWfojM/KlSSnNmLSyOBnTMskgFp02Gl1hxSOg/mTRYRNLu8QBPYYtJRrNQbi6SNDjyh626pC3Us97sqXtarY+1XWNRzoOhlZmegOE6YI7htrP/BTgKik1EWvjWV+0z7NjkQ/iqapDM8sRacjvSbNMN6d+i5tNvSRfgD22qUciNv9eIjnNfbMOXI3PfW6A0/0ACHW+ahVeMdctQCaSbXwg7jPuTb/U9VIh3OuTSKVjbrj7P68+609fPzlVD7pEt/3cAvMpFhiFu+6RfTYtTCpNVFkR9pxH0jsSBQUDQo6P0juZOSXcMQ2Oo6cMvC+RDiHgtpirU2OM4O3m6bwH1oyW/ZGXI6USecD5UpjcTG9/b/rPRWmqwJiZIArESP/QPpcBeH0L5Itd/egWG07N7UX2lvcEDYO6Z0oiGOeVzJ5UDgUmmA/XR2lgLVKwdxlgheJRCb/QETbSwPzluz/qCzQO+JGtjD5aLsaCWJdkV5G5HBVjnBN0IPreYhD52KEz4hJqrXtmAmYtXlvd8LHMQTh6gw6lr5CSjqRG7P9pBJ+g33VfqvFDWgCKZQReg2NSLW26Ji8T3UW8tjZJy/xsyUA+7w38vzBjUeoGvWf1HxKREU+4H5PtmsEX4GM2Fg9v/rg7UQr05ihUL1h80z3pTOEe/UE3BRucM4/fj4lGIdqgcVwI2C+rIYBCzUQZTW89S9+TQDv7BqvD5D5NcCKaVD9qZ0YPd5qA0A39NxrgnfUaL8c30F/Vi8SSvMmJWi7i6bOt4WcSEBUq4L66PsxQIpe9KZAK5WMsuP4
 o+nqnYav
 pSKwd4jNZpNlDMBq3W68WJLwxz5gnOMvVkAklnJi01ptBtMI4E3/PSrD7b8OaQP3zjlzyW/XHScOY3w9x+dxaj1ynh8dAkOTTHjFVqoNVEJn0e1eecblyClM1rjVquPIdHBlQkc9YQx9VGkY6yt1V0Qe+LqwpgT+HlK5AxqFsFW51ZYR9GpHLb1AhvtHSGES7yF62uly66itM0jnH+r3f1v3lZZKd64nUz9xkRLjqu9Zw7gN2HH9d+WeyH/6X0XEDZu3C8nxJxhfIxsW7F/psFYLHkFwJsDCBbwY1M6xYJZ7pToOJRgmLs0Z5S54B0/zC/lOVsBtKP46NFSg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

EXPRESS_IOCTL_GET_MOD_INFO fills in the addresses of the adapter, its
pci_dev and its Scsi_Host and copies the whole struct back to userspace.
Nothing in userspace can do anything with those addresses, and the
ioctl is reachable through /proc/scsi/esas2r/ATTONode, which is created
with mode 0444. Only pass the host number.

Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/esas2r/esas2r_ioctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index 3f7c1d131ec3..c93d9265e100 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -1468,9 +1468,10 @@ int esas2r_ioctl_handler(void *hostdata, unsigned int cmd, void __user *arg)
 
 	case EXPRESS_IOCTL_GET_MOD_INFO:
 
-		ioctl->data.modinfo.adapter = a;
-		ioctl->data.modinfo.pci_dev = a->pcid;
-		ioctl->data.modinfo.scsi_host = a->host;
+		/* these are kernel pointers, userspace has no use for them */
+		ioctl->data.modinfo.adapter = NULL;
+		ioctl->data.modinfo.pci_dev = NULL;
+		ioctl->data.modinfo.scsi_host = NULL;
 		ioctl->data.modinfo.host_no = a->host->host_no;
 
 		break;

-- 
2.53.0


