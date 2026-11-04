Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84421606D83B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=omO9IGCx
Received: by kanga.kvack.org (Postfix)
	id 967606B05B5; Wed,  4 Nov 2026 14:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9192C6B05B6; Wed,  4 Nov 2026 14:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1A06B05B7; Wed,  4 Nov 2026 14:17:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46F266B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:17:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B956C8081D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:17:01 +0000 (UTC)
X-FDA: 85398394242.08.C1F92C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1633EC0003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:16:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omO9IGCx;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cbujoj2vf5W42joV5o7W0AvKkij9cCOpaGGghku9+G8=;
	b=uVkdH7TblquF6yz7TnEDG4td1jgI+ar5NYTYS9AozVBYsh8oUz09jHT7i032zL79oigqK4
	gS0FKXMt8SUg7D56jyRZPepIP4QHwxh8qZn21eZ79fD9fQLJdJI7qo6F8cYxlUJo7xMZqx
	5qcbrRYf8qhS/e5POi54Es9kI3KA6P0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819820;
	b=g9Wf7B7K+M6StTXdcJSep8WWAg42ORL2UJaE6fVHHG6jlJ16DU3e8SrHL9N2NK5t7EBfr3
	Cxwu6RMdkPG87QoiH7hMo3WuHGQe/PKfacI//gy8w9XuoyMCfG0fRBiiy3sjo8twMGmqc9
	x6QBacftiqWZ84TUpZs5EloaYkhNHuo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omO9IGCx;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95EAF60A51;
	Wed,  4 Nov 2026 19:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F441F00A02;
	Wed,  4 Nov 2026 19:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819819;
	bh=Cbujoj2vf5W42joV5o7W0AvKkij9cCOpaGGghku9+G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omO9IGCxRyG7KD0kOxfDpDxNQyYIzODWVtRjkLnN3/zFnPKj34X5crXOKucSFkfWr
	 K2vwmPWEfSCfTc7KrJwcOMFunLOjtXDVztdyYUmknteKFz3PelPVAL1UgBnI+tAbd4
	 XF5ErKRbX8bdCtSjgX0zvSFTT6L0PDEOQbHUmwQkI114XRdB8cIfxqGscpwpemafw3
	 K7MJZBUNHbtj7OSLbkije9HCjsdQTGe+6yASXSAIELhzrF5YD6mcuYVUBb8Sm2r2MZ
	 MV/cCX6mrHLPa/XrLIYAdVEN9IQTdCweH82A0WOCV2qCcCupff8Ero6Vt+lk3uRxZE
	 xip5YgJ7X0fVA==
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
Subject: [PATCH RESEND v2 03/51] ALSA: cs46xx: hand the region to the region proc files
Date: Wed,  4 Nov 2026 20:16:45 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-3-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1215; i=brauner@kernel.org; h=from:subject:message-id; bh=Z6ZRkJrhuCU4H5MdQ4cObdjJffW/paOotMbfYVXoKlo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bjy38dymo9fKTmUGbmnq3vJ19u55ybMf3qtLXF/lV 3V+wtzWzx2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQAT+VXCyPDsb6PwnbR1njvC l2SKvFp3T79ebMkTpTsZWRmxsjzl6xoZ/qmcK6g8/p/jzJXZ7Ak/uerEBKe8Z+6ItmpmfjKzNzX 8DSMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1633EC0003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: r53td6s84fonujpgfbn1imi68b711p61
X-Rspam-User: 
X-HE-Tag: 1793819819-269755
X-HE-Meta: U2FsdGVkX1+LnQwUP3B/SpyT7AW3IXx1PHuLLUDM+B1doLUW8aSAiaBNDPoG8B0NSgoYR3e3twdb0wht4TDBFPnHHBkoh6osUA1ioOqh/VckVm73syZrVB9KfxJ+j9qyLfWC49zrQamShLPPCGqeoZhN6MYn+9oNvQZf7Vlz5tLMRfEDGcAGVlyVuL0uvmy7MK2DeB2/bzZioIyasI7re6PxQT3XVS8jEk+z2kIRugZUR+Vnp/i+YOBAosPa2P5bFeq8QgwOcFMfX1cX+6lS7AC4RD9obiGm4dFx6GbL8Mvn7hhnN0XIckUEcWUyQy2RbU8FH4+F9OWhhcvgVruU0WVK6U8DXXptq210vk3uUPq5sBmGGFVRxg5L+WSl+QhRIjCYF3kPjn77lellR8pMG2lsPVwlIL6iSUfAzz1s1wRbSqykjNG+EIf4Ws7xDx5ahfDYIW3FLp8rwtEL8u1T2zY9E4xHUzZa0eXIx8z80GuHzP4r3NicJcJ6AxYqISW1yJg6jGJzZP8/mz3XR4BuFcqXcZ/QvwnGuCcPzi0VtsrwYhr5j0AdDn6mXN9e+PAR8gDKpFZyfNRbdqCED6xBvT5Pokj/toBHcCgwBch1HazJZ8nZWCZFY2B8sHwx5H/EiAwV5pDZZxKjoKDBSLBh4yHwoIGXXOYImhoOEDh6YuAAu/KGuz2dtIEBDUC3bqbUm22sN3SCedNyxvprs7xp5NZZLH927YUfZHVjDTa5KVNpz1kwvjNdI52iiuBmNtTfuJ0ZwJUOVN63ukeCq21DhC8CFwL99gyXiKck04Y7M/FevfLxRBSM5nC8/H/TSAW6+bcZ6OBTd+/qwILwUU10HDLc/lR4lS82d1bA+ltxs0d3Qii7j+ATolLBhxWdCXsz+dvhJV8H2LLEeM7wQoRXaJETg/5rnEKHgj/2/OT2hNQcEj6ALNubH73lLlvdbQSN+TbaYGmdJ/zHfzG2TX7
 5lUXCdOI
 OZzlBE17HM9Ghi/PP7arS67pntDGudUTkZsfws9ygpJvOFvu+BWSI9hBdMZoADjVTHO5iNOj48zFDzfM2vFYZ7dXU8AK7ysGKmMU59+S+yj3oKSQD4UffRcfHot1sD0eRuYF01OMtR2klfH2cb15W0J5ppUsoHrR2LaRTI4Fun/8TBeiWU+QX/X9VJbBEsTm3jr0fqFr4wJlcMPt0zIc7I8MDRPW50oy9fakoLsb7CMZN3x9ugGZUewGsK69QKNTyTFxOROVJcwcaj9R9tLJFftB0p93C+Hz8eTtCF9jg+nBbL7ZYk3hDqI3pB1MB5mA1hNjvTw3iQLSlIxEyEuRzOuQGBK+Uxj5hCT+Ws/Yv/aSlw6IlQM04hQlR06Cv7SZmNhuwoK7aNkz+IjuIrRowq0cZpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

snd_cs46xx_proc_init() stores the chip in the private data of the five
region entries, but snd_cs46xx_io_read() reads that back as the region,
so a read of /proc/asound/cardN/CS46xx_BA0 and friends copies from
whatever sits at the region's offset in struct snd_cs46xx instead of
the mapped registers. Store the region.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 sound/pci/cs46xx/cs46xx_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/cs46xx/cs46xx_lib.c b/sound/pci/cs46xx/cs46xx_lib.c
index 797a5f09cade..efc7df444cb5 100644
--- a/sound/pci/cs46xx/cs46xx_lib.c
+++ b/sound/pci/cs46xx/cs46xx_lib.c
@@ -2764,7 +2764,7 @@ static int snd_cs46xx_proc_init(struct snd_card *card, struct snd_cs46xx *chip)
 		struct snd_cs46xx_region *region = &chip->region.idx[idx];
 		if (! snd_card_proc_new(card, region->name, &entry)) {
 			entry->content = SNDRV_INFO_CONTENT_DATA;
-			entry->private_data = chip;
+			entry->private_data = region;
 			entry->c.ops = &snd_cs46xx_proc_io_ops;
 			entry->size = region->size;
 			entry->mode = S_IFREG | 0400;

-- 
2.53.0


