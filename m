Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAA31606CA5F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bKrAUcOe
Received: by kanga.kvack.org (Postfix)
	id 03BC96B05C5; Wed,  4 Nov 2026 12:30:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2FCF6B05C6; Wed,  4 Nov 2026 12:30:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1DA66B05C7; Wed,  4 Nov 2026 12:30:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE2916B05C5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:30:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6014C1C41D4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:30:32 +0000 (UTC)
X-FDA: 85398125904.26.B7403E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 754554000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:30:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bKrAUcOe;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793813430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gnzz2fT926tAung/y7Xzshf60AQanFXIqjFC5KSqJW4=;
	b=bNqxAJYAQGl50lDWrJI64FvBSCENm0Z0qqFKIjWNLKJSHLdXczqpUL2wn6u+C5H9ShmHDH
	tB1jvbZMxtYWQGPgpHF1RKCI+3mAJAdCWalXFnpAZktzGM8jcxG/tFj6XwHOxX6cqKG8gr
	ijtZHI50WP7wWaZ5/92lGRGWjybGcDA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bKrAUcOe;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793813430;
	b=A7+YgPIlTLTRdUeJyfREKbTpu8PB518o/bgeFoW1kxNcI8DgIsnUD0zyAVAfAgIH7bO+ud
	+cM9IOabmYZUoRcgRDPc8YLdn7BI/s5ywO2+7mzEMSEcjevC/gywsyy9wtLghTXYOxD/Q7
	wSP5H0rkTHH747osM7XVKOwHVeO6TiU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00A7260A9D;
	Wed,  4 Nov 2026 17:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D051B1F00A20;
	Wed,  4 Nov 2026 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793813429;
	bh=gnzz2fT926tAung/y7Xzshf60AQanFXIqjFC5KSqJW4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bKrAUcOeVzlg83/euOIHnVFterm+vHdMFNuNi2Dt0LF9VzWRfSHdWlR7H5c2KTzRF
	 naRK5w+k54/QDDCRMfWgLxdTPqv4FCwBsr1kXOzQqhEOlC8vy1IWJ41ODhEZLno2LS
	 jjGH8/XSd1jADyBL1p3Hc3Qgb7ui9/GDGzwbwzjY67qrbN3GQL5NP2Jybx4qUpUZX3
	 CQMNjfOnMG5qtjvL2qoA6KmgJggxXjaC2t2PuKCscK2/RkukWsmgaXtZ0l6oKz5iz+
	 P64zZ0Jt2cdani8OUoo4/+XjtpVm+osPlwpgz43htAz/C7aUhFTjPEXATp/jT4GDYM
	 7OqOzge6sGwYQ==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 04 Nov 2026 18:27:25 +0100
Subject: [PATCH v2 08/51] powerpc/pseries/lparcfg: don't drop the last byte
 of a write
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-work-procfs-bugfixes-v2-8-bbf7d5546809@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1293; i=brauner@kernel.org;
 h=from:subject:message-id; bh=N2rHHHUzfsZsGLUBvdMxa3o2qGAAPzh8wsvUFn8S2uA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zmYqts+f6c771jBc691PB/aNiq5rYmuWq7o9SdKKM
 Ga7qdvUUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJFb8gz/a+f8MlT+0SWxMsTk
 QerGWIU8g/w227Ptd+ManyhO269pzsgwb7VmgtgD7UuXjjF+CvlTU3NkGv8+HhW+PC2DOSyTg2v
 5AQ==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 8bnbka3wpzow8yxkw4i5hhgte7566m8f
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 754554000B
X-HE-Tag: 1793813430-982930
X-HE-Meta: U2FsdGVkX18amC2oOp6bUydMRwVmuqei1giYLwxX1Fb2+GCCJxtE8jiQuOvIkng3SmQTJPiMUxS/YFK1ZR9EJPjNfXAJn2v3f4AgDLOM+wtH7tQR6WuiP9blIYhgWsWWDueADzPnMBYRE8t35Fl/DPPu85XcR/eTVWGNH4sCBmxVakgzMBY7921rLfdptRa88z42iE9lx3RCsvZ+R5Il9e/BObYdx1BHhWg12AfBMKMVPHl4+TjwWunYeqjqZVYWYG0MmwL4cGWeE60aHa+B81SSQ3BId1eJoNAkH7l6CLghPDc7VIq/8oJzaQXGrtsEyCKGV1OLHkS0Dd38pGwTAGU9T+2Pb16G6e3r1WPzGxLm3wQOGWV1kB0yDdP6/FNTzXT+Nu+V8v0rt/ajlh8Yvg3xmJKo8QfDYz0u0FM+ibdT/6cESnRpd3KCrxHz9K89loOxwfOm7eVdcf5JZBTO0v7dS/cwsQ0WtEp2/INwt4Lb3R524AW0TsRjEQet0xZG7Esl2a/UXyysPOMEAhLGqb5uk4V+SdmvMMW63i/kfEG+qjq+Dhzbtmgq7bW0AVBEgmaOZB+ysYyPWFnIcwP2Sw4AAWmg8f5FA9UscpBH1uWjWsBv2c99QF9vnFA3w+w6Qfy1YVtl67Xsm7eX/NG2qj/Y32OCOIx7AKhcftGnZInkDE5Afetd2pNJ1jvvJAbUsPUpkpL0BqBj9RXGkVeVzMrZW4RVPJ6vqztPz+EZ7UYw4k+yUNlrkuh78QcNUf7Vi5v2Ae66SWeAgEqRc5vFGkztC9fyokr3+/SnzpgoqtcVS2PQSxdTfzGVxFqLiAX3gSmQPOmgs/8PyRa35h3YGpWk2eYLcamE8VIrtZsEveTqhOyWTA1D8+VN6533oFKzXIdI6NGi+MQM+03Ug/C2gap6ZmqB5f440lx7m0CAARFNcM05lAuP2JclvICUVD0uKHuJ6DwutBBVgC01Ebz
 OzgPXAGP
 gwH2NKkI4uVaYsaVsajSmDdcHdy01iGuV9bCDItaLCb9wirsRiGhvz5k/+DD9cEjv/XrsBJyFFLHWrswe2UgcriNqloU1y5etf4dCWrU2FgVjHMr5l6UjZhAi2i8Tx+hWBtHd0MZJblFS7WsFO5CpcyTUzt+KCm7Kif8gAET/KBt+n+GPSwBLTgCdkc1p0aIfHupJhKIq4WMmeYjzaLJQDnEo09oDyzlBeSmok+0A1vPOqlVFSQJJ8Hh7zPPsZUeQ7WCka6f/Th+whkXljTwbzg0DjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

lparcfg_write() terminates its copy of the write by overwriting the
last byte, so a write without a trailing newline loses its last
character: "partition_entitled_capacity=5" is parsed as an empty value
and fails with -EINVAL. Terminate behind the copy instead, and refuse a
write that fills the whole buffer, which can't be terminated.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/pseries/lparcfg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index 3280b7968cab..9882f98c0efb 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -699,13 +699,12 @@ static ssize_t lparcfg_write(struct file *file, const char __user * buf,
 	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return -EINVAL;
 
-	if (count == 0 || count > sizeof(kbuf))
+	if (count == 0 || count >= sizeof(kbuf))
 		return -EINVAL;
 
 	if (copy_from_user(kbuf, buf, count))
 		return -EFAULT;
-
-	kbuf[count - 1] = '\0';
+	kbuf[count] = '\0';
 	tmp = strchr(kbuf, '=');
 	if (!tmp)
 		return -EINVAL;

-- 
2.53.0


