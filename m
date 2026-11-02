Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C153606C57D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l/9K700W
Received: by kanga.kvack.org (Postfix)
	id 9F9C26B05B9; Mon,  2 Nov 2026 09:22:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D0F66B05BA; Mon,  2 Nov 2026 09:22:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BFB76B05BB; Mon,  2 Nov 2026 09:22:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70D4F6B05B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:22:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70D7B1C0A98
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:22:47 +0000 (UTC)
X-FDA: 85390395174.20.D30E971
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F99940003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:22:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/9K700W";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDYBcNUn+VWuCpTwTZF6KvGO9475Dcj2RU9o+tvUNt0=;
	b=7KzAjh3E4ZFugW3rqGaOzoW8bQ78j1RR8kCW7gmtMxVLCkHUZfyDhAwFBRcjkCJzUxPoek
	D38fJQysJyIwgd1fMEytzmGmEzoSMcV6N6it2XQGOqY6lhFoRhLfbq5P1rNCVY2SS3zBEn
	ihEahZcd4y2wcakMwBF8YRHmT6tSoxk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/9K700W";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629365;
	b=0uS9vZ298606GPr8LDttX5VkLj9Q2Tji1wSOKtVXfukYXHEqwV9ALlIH0uJ8AjmuE5o9Ge
	dcNW/aVTMjXF4kaVeX13oIUoZqF6syqTSA8olLM1rQETlEJJFsIqdydlVx8TPTR/rYtaCk
	c3bDOpPx0H7mSFYvSALkyER41mTsOdM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 08FF1401FF;
	Mon,  2 Nov 2026 14:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5661F00A18;
	Mon,  2 Nov 2026 14:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629364;
	bh=bDYBcNUn+VWuCpTwTZF6KvGO9475Dcj2RU9o+tvUNt0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=l/9K700WtETbZbiehxECDLdPCEeiiVRA3kxFDmgS/2nKE79+mMwEbcSj3UAdFTEXx
	 6DvGrmpdgDVXnGX30oyGp8h1wecxAk4jKzxRW9aGPBdJy0OisIoFIZFTfdpRhDfBXZ
	 KAYYL329Lr/1W5cMHSII0yRN2tcUg68lTIkupTY2K2vtTItr3nAhe86PuUrEx8QrzH
	 ZRKhA68sEbKxiE5OFQB7qDtLFMKmYizYX4WKQpNV8RKMwbhLf5julp7cLNgPDZarPP
	 /qEweKu2GyB/uW3f9G490N5UiUnYW1jY6yf/ITOz6Ini0L9UMQPzrnkmfsWQJTfyzK
	 rW/DJSvgmGkgg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:19 +0100
Subject: [PATCH RFC 04/38] s390/dasd: don't look in front of the buffer on
 an empty write
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-4-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=952; i=brauner@kernel.org;
 h=from:subject:message-id; bh=vNxDJDpmoyfXJahneUuQ9vEH9eL70g/8w71rNTJgUxc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJM1jeXQ3NW7/xZeaxDpdlGIUkjat+D7tG9pahOcr
 AOsJk6611HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAnCRCYwMn44HG9tefO3daCl/
 zObZjudV2/8stZoz4eUdbl4NjbdfLRkZLu1okv36OdkxUVB7scSNP4VzvOQn7V+ZlPZqvbKOm44
 /IwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9F99940003
X-Stat-Signature: qdcu1e9tzio51tfbks85fiukxkz6rm3i
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793629365-140953
X-HE-Meta: U2FsdGVkX1/5PDeHHC7i7jqeWlCRqYd2+zm7/yhHM2H6DdffyqbMMOjwiC4argHUNILhnrPbFqAgjNrzk/23hCVttWM2wmEY9Lq8pQsebf/0AAuN6ymsYDOFRIPKpsomS+y3tkeBuMTmZAZO+HWHGoP/VoQcbqvMTv6ZGqLMaob/RYGQEsnOHpqpE5Ctj31D/qye6M2wXGfu8hhrmDouk3MjYrah0Spk+lm1+TvEONd5+1SLv00VNHROZtMf7wyXzxWVAle+3+W8Ce1ibRm63hFd1r+IGiTtnyxZxqCPfINeFUga19j0TT9ftn1xrXPoVJJuZbPOE7y8HmJzkUltPWZPeco72Tgm6vHbHntxXxxyajSwken87ckMc8uVhvy3e4cAchpj6PI489vwnfHek5tsgctiGx3Xfc/Jr0uEtfx4uGyDCyn3DD9x2DXtOqNi/MO4+IEO97tpeUnDY8c2KGluH+XKW3yavdK6SQE/DN92eIUlKruyuHzPApbyoVZ3j4FjriUVqejaC+OsIAvuBWaTEzqyTS5vpX/jUlM4+HxMUDijn8JpwZjZPDb2bgK1LvtChs6y/t0zRiGRN1bL882pdpQx8L1SR9TL9OUoWDOa/BwWH5a8uqdiEYlIEhQVUKb0Q0jVy2zi0M/fni1uqNK0W3P7P6SK6rbR+IrQAlDUKcGIJIHYlUkSmtaQZkNVZ07PlMD4RXzQtNGHNtkbYhv63mCwVU8c1bRx1b/Dwa6DhAoKvKXj1ii1j2UZcJwsD7bdUwB3DKp8LSCT74qPIWlWnLKQl5R7hisA1+RBFTW0CSckWNiExVAJg0AyPSEuE7cAJrx7kTZJEkpfsVx+m0V1Eou90tLa68VyrJ20smdiucgM/K6Vvk5drUiod2t/s3SROMCbQ3QAn5sJuolNy+rcg94sdAIWIB29tkrz4678FoD7RBwsLO1wdElZ/EyMPMoAiDQutkpzMOKS0WJ
 XFR9apOG
 ZsXT4HvNNLYClPIjnlC7MdrzM/hDMAwCt6XpcwGY2XrmMTXcbhCFbetkj4NbbVOLQiSUHYGjNkW6Ho0xOPeQdGgNd8ODJyftmPGdNgdWZw14EOXLrbJnLB0ygSsBuf9UknZFD2a4umesUDm/Wt9W9Y3FoSgsJlmQpTk+6sBSTBW+c6coNcrvnJ5BmrnMe3P9kTn62x5UtsHrP5+vQuIoCH5JuZpGS3t3sYKeRsTUmMNSGmp+/ubQY2TH8WdrS+Ijoi4G5QjLUQjQpeQxjU1Eozr3V9+gxhI3l9gNQN5T31mDZSU9xUSruKjbP7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

dasd_get_user_string() strips a trailing newline by looking at the last
byte that was written. For an empty write that's the byte in front of
the buffer it just allocated. Only look if something was written.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/s390/block/dasd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 2ffe404b890f..e97891e58957 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -933,7 +933,7 @@ char *dasd_get_user_string(const char __user *user_buf, size_t user_len)
 		return ERR_PTR(-EFAULT);
 	}
 	/* got the string, now strip linefeed. */
-	if (buffer[user_len - 1] == '\n')
+	if (user_len && buffer[user_len - 1] == '\n')
 		buffer[user_len - 1] = 0;
 	else
 		buffer[user_len] = 0;

-- 
2.53.0


