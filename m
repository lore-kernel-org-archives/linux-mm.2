Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3DB8606A683
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dl7dlqCu
Received: by kanga.kvack.org (Postfix)
	id 013DD6B05C5; Wed,  4 Nov 2026 12:51:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF1F6B05C6; Wed,  4 Nov 2026 12:51:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D803E6B05C7; Wed,  4 Nov 2026 12:51:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC5676B05C5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:51:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AD881A07E4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:51:15 +0000 (UTC)
X-FDA: 85398178110.08.9F754D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 525D080005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:51:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dl7dlqCu;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRUY7zR2xEebSKJvbp7QJxGSJz7lwz+abCfF6bzfIu4=;
	b=0Pf35fCdtw2nZVPUMfXrVmhSe2Is+NPEDAkhLePu75p+QNJHTaoJyzgqYlCtdsijLHJtZV
	QgkjncrMUHrlwAub+HlI9ugO0UdGTnfaShvkKE5Fsqd2edotsz7Fb/JjSAjm3u+0IViaPl
	g0RfTflto8HUHJ9FyRWxnfyAXg8IXPc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814673;
	b=D3asnxF6+Qt1xERwhEjbfXzD30YLIyOkMAN7u4lZWTIm7C4KVVycUsCeIjBsPvaH2wBmLB
	pFJC6tE2QCZGjYQxKpc7J1UAIlR6piPLZFx36y15EeSilnXuhKsRyMf/3Bb2AXHt0Kjl19
	U5NyQRXvhuk13CVABHm6m/jba1FxZM8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dl7dlqCu;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BDF443420;
	Wed,  4 Nov 2026 17:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87C21F0093A;
	Wed,  4 Nov 2026 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814672;
	bh=bRUY7zR2xEebSKJvbp7QJxGSJz7lwz+abCfF6bzfIu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dl7dlqCuigVtArFtm/v13PbvgoN21cEiJmv94TSdAfPYArcKB6G/oXjD8zdO24lnJ
	 ybF4ni0+zMxMXq66lTdyJm83mF5fI6TixB6jE4f2N9R1sc2LzqOgYA/CX08BrmhHiq
	 h5hWq+Guf6DVaBgNQPt0j0kZIA0xF83tJU/turfMgN1hOL3RG5geYK5UPa02oN+gzo
	 v+gW0NlE7T5ApRB2hs2V3O3dpHprLN/Sb2l6PJxOJgwtefZgJFn/HTsU9hDAnwxif0
	 uHwP71grr1P14LWO0dSiwyCEi1kPf44CFdlCPvbOI6cPhToAbeUH93m6qN8VxQJfEn
	 Hp/uLwaFySsTw==
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
Subject: [PATCH v2 23/51] scsi: BusLogic: don't return 0 from writes to the proc file
Date: Wed,  4 Nov 2026 18:47:09 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-23-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=938; i=brauner@kernel.org; h=from:subject:message-id; bh=7Bhyn2ehZ0sKrsH+Wp9jL6/kN1Jv4nVldfkK6knOcds=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zrudfHff/e+eJxMXl8yZKxXjd1JJhqM6dufPj3/OX 2dK7+SU7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjILROG/zVzphx+JGd7gfnE OQVeVkvb3OYYjch7EkWC4pcW3gmxTWJkmP47ztIzec7OKQ5aW8Xzd+v6Z97cqbrJUdNk4eHpdlN mMgAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 525D080005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: jw3mp3wa9yi1xwawz6ws8pxdd1pa68bs
X-Rspam-User: 
X-HE-Tag: 1793814673-371980
X-HE-Meta: U2FsdGVkX1/6gHTaE3b8505ThJMXtQT+NToVxvoVB5WSAeZSXYBvLRPXHMvvSYUpG1dsydb6NYeXs7/AGLVdvFk6OVk4cCPmbWDuLt68L2ld5/6cJGCnS/0Mp26Gdb7tidsWewlIU4ag9oe6lKayj4eFQmLe5rlwrVfqUNAr173XTy21LMYnF0Bi+v2KcEJWoggZK2MkSQMHQtjVtyebNR/GYxxwe/E68Q17lCkBD+K7X32r6n0k39tlTaw0BKETlpFdPhoD14Ero46vLHHVK1JOkNzwW39iodPmSGsae1zzBdX2++cFKz1Ehy0VZuesU/QMHk/RBMWPTBnm9h93UpvmoiKWRYBbbcr9KIRal8ttaBw9myHd7WTIG5+E7bIBmkdmgV9JbHUGLivNXpl58AvMmmgv1To0wQoHq/3Hwaah2Mk+ljwnnWGp9rGC8SjpDZFgMKXc8Wgh6JVS9cZHhhZrMLiwt1YVSJmIO1D4/MFccLod5yIs/IJ7x5bA25wWroHCZKrJk1dgXCIcESyNgcafkx6ak7Za8SZA/SPtO+uiItkTz4LDYx3tE6eHULAQbaOedphqaLW8HjxEHfaPF3IGOAK+G7+LEyYTImZR0s+EHNMy1wXL49Ms46Mg/LcP5b7PhkISx8CFD+Hwe7Or2Niv7SdQcfC33DI5AIg98egj7/PpS13AJUhrm39KU5eSnS/UdZ8kuBWg9sdLRCADh5womr+vnTXsErWIOFeefR0obD0IropMe2FJd7ugoGnZgCxAuV1EYyFIJQFP+s1ByGNuOqSdqEcv0LdQc837+r4pNw8oXOkrdRTy/wwaFpkce2BQCxKHzu4Zmz5KWC4zi3vq1OhgiHPYOSYYtNuzROAUmb8uDfJuWToYrw6inrRK1r2pYso1kLelInkZ2a0PfqV7N9Y5PHiMmxeaWIqrpj+5ywHXBgL8RZCpjGPXJB/sC0Xe40VNFH4N8cUOuWA
 OrMyHODU
 vQNH1ooDC+sV2X+iocn5bQwoHtp++wov+Qizgm8SJ/8q5OEeWCb897xE1Cch0OcmUURncF6i8d1zjlTNicDJv4jY0DRDfD8J3L50DDIkWN0gAxUCe04AYuqY7buYJXvO0BDF53qG+vxeBt0FGETiXc/KKWBPN05AH3F237ZHSiBmOVAU5qTkaAnvMFdM3ITwyA6SMcv57XXDuS3U6xtEW3shMazGpO2Ku8R/nNrPRLgkwQhwsinOoaMOOMzzStvyTU9Ba78SrEJCa7BTNEuvzaWZgD1Nk0dCjJ3p/2GdaMqVeKGBKyfMpGBDbLxr3iHJO67+IVx6ldByELCAc0LEzKNqLDkh75E7T4mC3OmuBg59yXqwYlrVsLo20ZsMUDyWC1ABWW9sSiOHomgwdppxocDqf3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A write to /proc/scsi/BusLogic/<n> resets the statistics and returns 0.
Writers that use stdio, echo for example, take that as no progress and
retry forever. Return the number of bytes that were written.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/BusLogic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 27b446c0c5d0..7ad814f549ae 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3328,7 +3328,7 @@ static int blogic_write_info(struct Scsi_Host *shost, char *procbuf,
 	adapter->ext_resets = 0;
 	adapter->adapter_intern_errors = 0;
 	memset(tgt_stats, 0, BLOGIC_MAXDEV * sizeof(struct blogic_tgt_stats));
-	return 0;
+	return bytes_avail;
 }
 
 static int blogic_show_info(struct seq_file *m, struct Scsi_Host *shost)

-- 
2.53.0


