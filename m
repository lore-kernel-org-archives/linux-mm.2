Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF06A606A33A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=adc5P9d8
Received: by kanga.kvack.org (Postfix)
	id D8D486B05B3; Wed,  4 Nov 2026 14:16:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0FA66B05B4; Wed,  4 Nov 2026 14:16:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD75D6B05B5; Wed,  4 Nov 2026 14:16:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AAA66B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:16:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1AD82140836
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:16:48 +0000 (UTC)
X-FDA: 85398393696.09.19A44D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A2EAA4000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:16:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=adc5P9d8;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819805;
	b=MloXY74IpqOFWwCGdxpHoZN6rYFiiVMwbEZKkyGYgnVmP5MxtPWOK39HOQpImb5f+tj2YY
	C5ypbj7jzrro+X/Mj8Qg0gnSG9VGhFazgm5FmKqQEWN0mftncLh4lRYJbWr1K8V8s3oDof
	UePWRMQ822sSzaMR64K1nFbd4m06LoI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=adc5P9d8;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iSk3nsArFOOtW91DExIIvIg+E3fTnIkI1uYFn4dT7G8=;
	b=dQDo2989t6Lasu9ef3E5USHC8/e2i/6ShrO5PR/81ElkNIFrxYNLjlQhnLmSoczYHToyVX
	2c4Fb4NLnQGd5LwClAaYDwlhE6QtUMw4zeQJZY1O9iOe5fDYEdXgQxgLVyV9bkNJbqUO16
	YORXr453xmNpowWEMKIlOJFzPOa/rvw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 94D7841890;
	Wed,  4 Nov 2026 19:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406881F000C1;
	Wed,  4 Nov 2026 19:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819804;
	bh=iSk3nsArFOOtW91DExIIvIg+E3fTnIkI1uYFn4dT7G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adc5P9d8MahDP5MWnF8/BQZpdhwQF+Ch+DamqvSkAjn9rCUlBnkqECo/i8i5m6rCU
	 r+0D3t4BrnoadvsSIYVAap135Zl9/uPV+3cWE1MIZO02KbRYUYm6qut6Iw4ZTKqOu/
	 6k7TrsWTmBmMQUM3tHfS92Olrwro6VG7uRQk7JNC9KNK3inBXn1gscAHaKpctq+lkz
	 NHgRnuuGNNngzWx7kkuO/bS69mOTmSTRK/+7SYlvkts5zOYpp6/1gj+SaDwhe5nUBd
	 NQB1zsZF5ExMRUSJm8geywWpAxhsrbuzBIhJsIT/iETtc8kHozEESlyxMXTZO60F+g
	 m408MmhemLThg==
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
Subject: [PATCH RESEND v2 02/51] scsi: esas2r: don't copy kernel pointers out in EXPRESS_IOCTL_GET_MOD_INFO
Date: Wed,  4 Nov 2026 20:16:30 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-2-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1380; i=brauner@kernel.org; h=from:subject:message-id; bh=dmwAod4+27NCncmw2oz8APM07k66EUOhHcJdusbTjjg=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bjzbuC42lkN5rrFaxyvfJQdiNbQZ7W/e2Jquu5RPe /ZM3ftRHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNpfM3wzy5cJTFdotRbNPeq 5U63fQ+S03+85HippbBf44binOdz1BgZPlpuOyXM5rh4Ucv0N+t5PzZYf39meEdz+QFRtsctyxa 1cQAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z9p6e4ej5cmuoeikmeahu94j9dezyp7b
X-Rspamd-Queue-Id: A2EAA4000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793819805-204214
X-HE-Meta: U2FsdGVkX1+IphuSYXY2E1urQsUltZA7A6un8fEzQihzilvoh2AP/SLdxSyv4LZhGnps7owyzizcYyTChSqnx1PbGtC23KaqdeWNzMwmeOiTo5VA4zvQmHEJosm+UyAK+LjdZFmHyp5PkvEDxHyLxEyhx9xPxPoWOuZU+c5Nouw6dEml1OUqKs9P5PuDXQ+RyOkvfbWE2ypz/ujpNY+0iMzeBaW0onAEwi/bGJnpqbPmQLgwOUft1XyssLJpv06DPzLTxSfUj6zM/Stt+TTAl5HCDpkRGfp1a6tcDYlo0bsRiox4p6sAghoulJVL/m+tFMUsfCyFREfLCi4nnCxlRQ7Sonbg+0Mes4cYlMxWqP4l8DkYuyP109Upml5903tvVdT3YV+sVcEb8MxXOyNVN9aFiAfHThHhnf1BEAQ6eTo4ZbFIX13dDcHXTKsKRQgX9IV6efTePOyFfAteoFKGJBJ6JrjVumdXETWrpQzhSZ8sISXcKuo5zrYnEPhcJcWsmdJddc6dOetNsImkxU3cXd4zA+ZD6HYeyuYo5jLjhZkiwZgQuzKXnbfsH1xaU1VJvdQ7jW8XKcDCXNPuGqtoXq37cqEYVYSfsuNNjvTpFMumblqrxsijRtRZA2jfJFBxPC+RyzgT64ARjqjhpBMbdRCl25Vn4663bOZVUy+3COAoOlcfZM6jjO2gGbOeK63xIGsah+Brlw/bVkWBdiIV8P/CgMHX/8vI1h+pDu2Qt5KERcJgKKEn8kpRsMSB9wcEBMP4qGmldPcQYJiz6hkKrMmIGBXcILZRkvn80KBvL2u9k9fY+iLAMI4MV0LHkVyiRXHjYiZI+rvW/l90GBXPwtZW49JWrxj+Wn7VFi4ZVYWeGiHusc3BP0qM8+rPhYZZbNxPG1SukPomTD3QDKQoHRIe1NA1meAlXqS8gN9AYkKT5712R3QG8EeOZcRXC0W29el5DX39hJk4luiNTz4
 l9Cra01Y
 Z07GnPJF18+TRjO46TaC9QcDl+LNKzMS8LNCZ3HkVofrzK+3V995M0yxP+qLwSHNASWdX6Wsc1GWgEeeOhfzsHWHX5RgId2JSV0lb+piKmWc1u6b/HlkYIOEW9nHcboc6Oj9IhwY3Z93k4WxjQjaN8QI++UN2T9nCSiMLtFJ+aTW+IMktkEgp4TRukYQD8Ua1bsHWfWCobTpwvCnNVV8X9zE2DNk4Ho+BUIx6QPEXlkkvj/yE2ggR3GCKDJvjAWSRC2e+H+jThyzhUVkFq3pODzF9iwKzhOVRPGYCWp+SwaN4qRWFbSQfs0hj2Btr29WLNHJu+RHqvE23BhJQftkNOrmB8tJMcfo1W3IHTQ02amVbpKHSRv1tSYfrM8C8z95MCA009B6GqZXzX1NQGdQGwr+uUkoqFa1/6QEfbEYU4ihUklWPwQ5+RNNJv4u8vDWVENb+6RJplN2P2oY=
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


