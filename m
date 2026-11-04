Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 450FB6081743
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EkijSZeV
Received: by kanga.kvack.org (Postfix)
	id 4FED66B05CC; Wed,  4 Nov 2026 14:39:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ADC26B05CD; Wed,  4 Nov 2026 14:39:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0076B05D4; Wed,  4 Nov 2026 14:39:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5186B05CC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:39:07 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AFD261407F8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:39:06 +0000 (UTC)
X-FDA: 85398449892.19.9D215DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id CDA5B8000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:39:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EkijSZeV;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GaZul5nsAkiA2gFzaNhtmiz6cl7FK3FoYt1S3NMwg0=;
	b=GpQkTyfeVADFfDnIaZCsDV6Zm2Lc2TmuqzQpdsjiZ1Ll5hLKqY7qm/ofSTO5rTGnsnt04L
	8AwuEJWjhGJibiTYO7+YYs0vJbEcJ1sunUBf00Gvg9a56GAsvEyimIQJcqeOT213AdiqeL
	meh3nY2Jmkkfe9rdZzBhfs2H/3iteiI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EkijSZeV;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821145;
	b=3+x6QbMYvvkv0iTci7vXrbJYaURZO85bH7YsQhrQshvZKvP2VyhQaAN82IysJ6mLEWkGds
	y7fYyD5XgW0+gz6GuzrTf95DGQwtJA/Fv+b/9+6+hQ7up8N6v5GbB5afrgELME2d+M2OQ/
	tuiyKADYbYJgHbjbRX1uomWyk7+xcyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 203E742ADC;
	Wed,  4 Nov 2026 19:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9AA1F00919;
	Wed,  4 Nov 2026 19:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821144;
	bh=2GaZul5nsAkiA2gFzaNhtmiz6cl7FK3FoYt1S3NMwg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EkijSZeVjK/rxqWkFZ0OqjZPZ2MuDjt77EIGi3oeRCPyvddqFu9s+uEMPbZyav6JU
	 wR/usgrscOo+Xc/2BlwsQalbhrpqMfSzzRqIgv3T6yJ6Su3/KnDPj8UujUmSRlInc2
	 OA+qa1pxZU+tpV0mOirJD8BdIgxcL9++M7vpMuIqy3oTTRQjm4+QyaGOZOJJljVRFM
	 978mJ2y34/rrUxqJu2rf6osm9UbeqCNqVT1ww1vX9zJuceB82ZbPSNli3Pn90tp1pC
	 vGmWMHMmL/iqTgm2FqrZJJMi0EDtSQb0qpfJ2D2g7q68SgWPBjHVtue51SAG0k/VAQ
	 m6xHCkuZygl4A==
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
Subject: [PATCH RESEND v2 13/23] x86/mtrr: let procfs own the seq_file of /proc/mtrr
Date: Wed,  4 Nov 2026 20:38:49 +0100
Message-ID: <20261104-work-procfs-arch-v2-13-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1271; i=brauner@kernel.org; h=from:subject:message-id; bh=JKCg0Vsec4l/XR03sLy8l8PQ6sAjtJH7fHwWHPLe1EE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vjDc7H1uCrz7Lca1inL3TMkhJlv3fnENrvceu2S/ ReZTC3Od5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk+F6G/2VugSv8pq08ZPfu Tmr9gR2hu+24ZwgWX2kN2zjp1ecfLS8YGa7UCoX+OCF32/XDAz/vezHLIq7fqM/cGxRkcUSq91z LXx4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5km57yomnxok3ergnrh7wgkzot3bzc8f
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: CDA5B8000B
X-HE-Tag: 1793821144-927571
X-HE-Meta: U2FsdGVkX19d6OfvchqMisR68G7oV4pYbLNojDJrDxLcM+yrCPt/I4UdsIqSa5EXKOPe8p02KDj/1sa21G5P3itVVlLPwlOlyM3w7mH08R1sVLGLIzisd2PixzYulDr2/cdLOmWg0hFf0i4ruslixDuF2jzSZ8vCM2QKkc3H2cW+TBKj4DHr1SSd1EcQbWf/OfzxAfskdsnOKdEhyFYgPN7kJAi5QjBAvNe6T+dE1bGd58xSQhd3uT9Ro8ImAwUC1EK5RJINlJ08wkPonIyD6YUnXCiQPtBFH1FlitzfOoFD5N34bevg/EE2XUEkwvXjQObhZeYRa/apWZ2vJcBTOft3JGCCESQgMnQ0Od7xk8B2Brd0oUb5Xr7b4aVL++MyFofTTSS7JvZEm0FAyt4isACl5qHsVEMqZnfTkBg9OIVkLWyyXnBIs8bzUQU7gOvT4TarR/9NUvyLwmuRJgbzAtGhyoGZSSHSKYXShhut0QaDj7K+1thiItM6rGez4LtBUmarIBoTW1GSIKTjak31nbdaMuS04KRajbx5puloklDgC4swOLFCtGLka9ya2GqjHvdCc6nY/Z6y6QqTvvqMeu+yaviwGtUmuq19shHmix7rqnv37qVgka5dXi68vVzg0kL6coxJc8lJANypnl0QreRw9pWDNcgdE+al82jGiq6TqliBwYKrGOAfE3ySeaUWJbDiUwXLsPOnAHzkXENSJkJ97WDFEN2XeDH0EPq2kuzXIB9WndstebLsTnIpDvZui/uq8t82DXIv9tGb8oiBd0HTsTX+tFLdS3ojxpKpNWlD6s+xMyfeeDQzmg5wvM48gJyW3D/ApRUn3gew9A+LS6uQExVhZ1um6cETcpPyRZLjFI5A/ZRr1Bjr+3ov+qrjk6/tAdKWqYAvMKOkvwXDtsUIabM93raUaYFuPJt3qTacO3brBZ87qPFWqRslvsiFJ/bdkcEX1qVV+5f0tob
 E9eaMggf
 iaFfln3yyqJhc5yS/syRaKOsvVUPBpwnLIYyYle4rWf4h/AOvcg1tg29LjATPzWwUQke0OACBXPKo+somhfsnPmlEWADXE9cAoDwHw2C4CTLq3a/rVZWme2m4YzZFGhjcz9tOzZc6mtyDq8SO/alaETd/n+o18UOrLYz74CY/zVTAcWB1spwRYrkyTTmd8M1eCnQ+WSXvRRV4NANMgtxFf0tEOGQe+doBEwghE19w7KWySl5kXMvjZw+e7+/1PewipmVVY7se61ucWAGg0CsInbgtfs0lzLM/jYsNQvkM7fQqwhBAevmPhomFgN7trmX9p8nNfHpPgO+TIWa+E1kl/QkWSwgmfZ2BgR3kZ4zkoKhRG+SDO3rtA6civ6o6Zqob+HKuo3LP80qlVXx1LeXh0h0cTAQ0etskz/vIFcJ5/HzyHaa1Vr3G/1pGEKUn4Q7ijENs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the show function and let procfs open and free the seq_file.
->proc_open() only does the checks now and ->proc_release() only drops
the MTRRs the file added.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/x86/kernel/cpu/mtrr/if.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 4049235b1bfe..9510e01d5103 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -349,7 +349,7 @@ static int mtrr_close(struct inode *ino, struct file *file)
 		kfree(fcount);
 		FILE_FCOUNT(file) = NULL;
 	}
-	return single_release(ino, file);
+	return 0;
 }
 
 static int mtrr_seq_show(struct seq_file *seq, void *offset)
@@ -391,13 +391,12 @@ static int mtrr_open(struct inode *inode, struct file *file)
 		return -ENXIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	return single_open(file, mtrr_seq_show, NULL);
+	return 0;
 }
 
 static const struct proc_ops mtrr_proc_ops = {
+	.proc_show		= mtrr_seq_show,
 	.proc_open		= mtrr_open,
-	.proc_read		= seq_read,
-	.proc_lseek		= seq_lseek,
 	.proc_write		= mtrr_write,
 	.proc_ioctl		= mtrr_ioctl,
 #ifdef CONFIG_COMPAT

-- 
2.53.0


