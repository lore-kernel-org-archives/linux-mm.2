Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6ACA606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z7eNSc/k
Received: by kanga.kvack.org (Postfix)
	id 0D64E6B05BC; Wed,  4 Nov 2026 12:29:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0863B6B05BD; Wed,  4 Nov 2026 12:29:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6FB6B05BE; Wed,  4 Nov 2026 12:29:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C75026B05BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:29:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56D01A07FB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:29:23 +0000 (UTC)
X-FDA: 85398123006.10.DDF39CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A1F6FC000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:29:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z7eNSc/k";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793813361;
	b=lHQXunKirYw0fKpDoBQMGnjvXkNWTboBvO2PLqQqG2u0nzhyMe1zJKybbEI9mB15DCx2mq
	ZUwOd/CjXEg9DnDSjaRP14LYUiBTCvx0Tb0APLjfQZleMZqE0iJg/urdPJiCwHPiSmM6Xn
	17hv58sCvWLwdALuj61dPRZiVuN9ROM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z7eNSc/k";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793813361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cbujoj2vf5W42joV5o7W0AvKkij9cCOpaGGghku9+G8=;
	b=hBGadZeJbkn3RQRWope/OVhW2Mk3sDGlFXiE9cZ+/TkRcOVT+rT7+3VIvM76oLmMEHxB21
	cdvDBCcikXt+Bo742ozpsW8Q7HvaL+RKRTtz1MV5zGvHZ3x4Ls8cHstAwe0pn5cWLO9Rjr
	XSRwKbQRyT+EggYbaRQ1vl2cfmGRnZc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3353560A70;
	Wed,  4 Nov 2026 17:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB89C1F00A02;
	Wed,  4 Nov 2026 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793813360;
	bh=Cbujoj2vf5W42joV5o7W0AvKkij9cCOpaGGghku9+G8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Z7eNSc/k4A3ciQiMKYVuHgvIuitZuUBG1LsDDKn2PGqkyeTI60C2aGeIX/gOrwywh
	 xtfTPVHdVi6oqn1gTkn9QtwCdpb9vO92jUAd8quwbbgGzLCmHr2yCQVt+CNwsUokAf
	 3PdNxsqj0EooTVaHTwU9Byq22F9nTmWr9AhaMKmjfOIuszcJH2mYIrP4Rr4AnPpZkH
	 h+7C63tA9sMWXTQV0Do399ArkxTfLMrSAloe1ryjs6twcaS2ODw+QTAKVaUx5fGvQN
	 pG82LTMb3cdXiyyhejWUAX1q+C1HwuXnFf38S34Yh0i88ZGrZX053f2X4mX3pSqwVw
	 kTy4TQ+sMGDOw==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 04 Nov 2026 18:27:20 +0100
Subject: [PATCH v2 03/51] ALSA: cs46xx: hand the region to the region proc
 files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-work-procfs-bugfixes-v2-3-bbf7d5546809@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1215; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Z6ZRkJrhuCU4H5MdQ4cObdjJffW/paOotMbfYVXoKlo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zvpj7yWamixwZtfSkBurLcoYw1rMGKfuu3YuiV09R
 c7uw2HtjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImc3c3wT+Hkjp3MZso6HVei
 D0VKbZS5oKGx7I6p6Yuo7iatL+17dRkZfi8SqbU+57c5383JSH9+xYYuliMbRHb8cOA9JBYQHeL
 GDQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A1F6FC000A
X-Stat-Signature: ixgo6f7k1is6ijgzxp1tmiwijzqj9pfg
X-Rspam-User: 
X-HE-Tag: 1793813361-119807
X-HE-Meta: U2FsdGVkX19eMpLeiWW4dul0d2cG0xVrJ1+daux6IAVlamsd6rhJCcetYyT6yJJVVpscGxGW4XlXJBB8wG2IQz3EytiG8hkLzuXBpWlkm4g2vtj9mlUo7hakVL0K9Al9qTb31HaRw33uK7Hod+khwSCEmXX9BBVF4+8Kl1AhNfXY/OeGd/Lo6mqAd3eKQs8jc0avtOODcbr1ZEFNnCjtWhQ1c4BtS2vI46avtUw3GFuh5WrBOXvNgFVeKYOGZJHLJERSSb9d0iko4aw31HA4ob0VKdVrBzowoJDKBtjykoZ7pZGyZBQPjtDvVTtH/EkrX+7iu7KjFpdN+n6PFt70BNx/zMnW2OGbbY+mFGgAmB3W9Db/Eeb2TeXGzJgO07RUsq9hynzLPOa1wKVZdYWNWrYyhsYMtkFv5JpvFy1tVwdYhycqbDHd0kzPAx4xcIT81kpKZKSEoG/Vq0YCXlpnHoNWp9IlKkMxOOs0SOzZNFIGlpjb+xD3p8SUaTvHojE+knl77+NLaxB2g2SYvIO5b8wgsLS17k1MFjxWuFw09VVSROACtC5Nq3lE4mQ3RYFTx8z3svA+ykYt4WnXaPUQ85OAgazosx+QJCefyui8vqwoNuP5FjUNNJPpQoSMjFbJJkgyAgmTTy2KOFYMRBWiEavseJ30D/T9RuB3G24yyXuU7Rm/U5D8LcveWITHVtrQroDoxzQ1U3TTdxKGE7b6yZIbKDz0+dxTBfrRTomd2MoRr/CgGkF86Yo5EsYTStx4dfupJ7Ni4Dbrmbk3n7InKVc6C+WDFp3hDXc3RAUVH5WFLkCwBOr4gl5JKoMnXdGO9Pt46x21U/gaTlzIHPAODwbf6/H7ArW+gfAT5QfmBtx+A8fltbb5s7F4zRKaygAYmUQtfzZ1KIdON9neg3n46mpskEu0/4sKR2XYyD6x1z8DNzHf6oCOeZ459QZMBWh57spN3UAHv0th9XeY/Ay
 0Vke/+V8
 wELtGMBeNA8/tw1T4xhhodb8hJqv9fbRdyBayJLr+o3oNM54iDYXzrWBlNfj74/7Wmt9x11eALpOKBUd2iUO9m/+pDjfJwprkktElHX2jJZ/SeoKkVKZ6ReNJcd3pqb0MCBMg35BdcxQTkX5g5pIh/WqAW6Mx04ouzNL7taKTUpI7Dv1byHzc3rJSrtNnC9h6d3EIkz7xMeGz7hQkdeOx3BFlY0UfVt0u/s+iIR58LUT9uWNwzJJPctnQ/lXuVCIfmkKciNgxyMqJEB1rWynGe1bBGg==
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


