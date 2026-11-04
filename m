Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDB6606D326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rs900pf/
Received: by kanga.kvack.org (Postfix)
	id 4A6466B05C3; Wed,  4 Nov 2026 12:50:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430146B05C4; Wed,  4 Nov 2026 12:50:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FB596B05C5; Wed,  4 Nov 2026 12:50:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05D306B05C3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:50:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 919761607FB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:50:54 +0000 (UTC)
X-FDA: 85398177228.14.A5B7A10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id DF84D4000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:50:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Rs900pf/";
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814652;
	b=EibMEhIID60UddpaKtPS+zJLBWvTA/9W3ExdiuGcP8fxpU8VfEgJGaqYcDiw3D/HuC8Zp5
	4Vdqgjs3UMJBwnMcW3y2C7Yk/uROvJGfFxRmyNS3daXP9BQ1yknFCvk7idScxQuy0g/bgs
	KMpkMXA8UhOyaBUTAv8NKv5BNS8MM+Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Rs900pf/";
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ih8EKkL3fEFrmnOibnSg6zuDA24U9CpFmMUb1+ThTQI=;
	b=8AD+37otmM99BAPRQGMumR9CbRxLOTdTKok7R3OyuV/0NBl2mMnYwSZPp9nYEwRibMEUJ1
	D4y8pRz9t2Bmf2swAcwrVhbw6dsClobUuYBjz2DkpqpobulvHMda9IxqyjrHit4huNmmKL
	ZD0F3LFBguwPysVTM6nQwR6DDDzRA8w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7977560A6B;
	Wed,  4 Nov 2026 17:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A5D1F00919;
	Wed,  4 Nov 2026 17:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814652;
	bh=ih8EKkL3fEFrmnOibnSg6zuDA24U9CpFmMUb1+ThTQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rs900pf/e96en+TLGDsSEaZDMSU5oZQyH5nZF7UwPtKKPbnRGVFWZ00+YoXP6F4Is
	 q0FuLwKaUF4nN3gz2xJIMC1lUGMhu05g4EQmKbrK+q0N8NJzLb9mePMfp7AcDBYc10
	 x61YX33cPuH/8i8ufX0WghhS/B3zq07hwoKbuiqX72KPAMBcVqLQvk07L0+V7P/Tdr
	 40YtyYcMx0U/wZ/Yjv8DvJGoDR8zXAMEeTQuW2MXE0nFHOsHJCtQqwc7JWZq4qZj7/
	 4xvxSNCcWgEK4gFORKmZhaLtRdAL9biaxJIFwBQ3BbvkWhj9sqmIOkeZP6BWLhtYp2
	 6TwkPAQH74hwA==
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
Subject: [PATCH v2 22/51] ALSA: info: don't write past the end of a data entry
Date: Wed,  4 Nov 2026 18:47:08 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-22-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1329; i=brauner@kernel.org; h=from:subject:message-id; bh=/wIh+WZXKaFyyFYwMjXKmLvFs42DoCHjOzS3J0v96D0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zrsptH6O04ab9YvmrtGx55O9VOyReez3z/NfPx/vP bHVeEsQV0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEvhsyMqz6Zx61me86u+1+ Z73TMTGbvt9IUwoxnH1ZvumySeeKiAeMDJPbtrXoiO+Y8M60S/DOI8mwolZ5lkfT2EO5qks1+iT vcwIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1xhbmb5t9iw5r5nijo5mtuyf3swbb51m
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DF84D4000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793814652-998052
X-HE-Meta: U2FsdGVkX18a8I7JpQ0gl4mc2WTpWS5aeXH8JR2I7Z0gi1gfA6wg2QcdI1JkNYNUKvn2Sj6x5XCIWMj2P1p92Z/PQ1+SsTC2YR7dx34TYalG9vdb3SOmo63/yLUSFymYbRS1MO4vLsoJE+oYi2gX9MosGYRuENGn3hjBhThMsAbHY823lEL4YYbAco1SrNhF2QhD80Dxsu2vwhSlwRCj6vWzFlO1eUG6a9JVCWWW8PlguQbc4PnK4K1+SAgFeAbqtGas8N6QmYFluYERVLB7wZP1aokcHpcBS6lJ6q5rASTwJe8wFVWYCaS2yZY5Jprp/bQq2uEehF2j6oGQLaBov8TK/UkoXqc9VGXKctDYaChrUvO05VjVoWgYKcFcjErDgffBtUqBhtbHypxajr9IPwPKAP/lfhZpQbqXlh0No8rB86m9STJhEOkvyY6zcMJlB0P9L/KRrjLHLGd9/26sa0lxtk+2fR/0XugjZqYY5Akd2ditylB42eqS9iKkd5SNkkiNk6aVyiUWqR7xVDKF+0Svsa/Z0Zai3F4VCWGSGgrT9UCEqBJvymPDLOqh4TYpxOjoquah/Yk31kys6JbV4qFRev0304x4lyEEMeHVcCJj5aiXyNhkRI85pEHU3LNG+QEPrIKLKL+F3esZA+NdKA34fZg7mh4GmO+VyjVjQJNxuz0uS350NrbypZuU0OiovzqZ8TnRQBNbt/dDidbLo2IJkQKyYN9CcRV20DD1Uo8TfyeT3Drmnrl6HAUfl0ZB63E0K2CBjgT5JXIDGMIK05R0ulvMWI0hDm0WFDdOxJJ1UyajCmaMvHb07eFouqbOqxVGAQNMqvSUq3vHZI1mCX3FcYVGuz+ZVMaxJtdECRoNsylZXoMzPr3H8zYBpgLmWV3cWvm6FwEhPBR+MzyqpttbiNWUSJ26WZjFdCNW4UZY1UWRklUp4MqRG6Z0dQERpr8EbwrQ8Fv1wriieeN
 TqKNuHRB
 19L1bbej/A4yX+P3ASt6KAtimfb7yZ2I0YW/I3Cels/aFYmcpqcbiuJWhFHK3hOsBJbYc/FJE9hSLMPyp2HZ6gul4q0pjvUijODjbtMt3j2cSqM2atCfbxFpLWxep8iKkHR5JQcPKodQLhNMV8yLhp1PCuMScpWPPSQZQg9Z2czBPq0doggL2M6B/YxuhR/t2qyQ+CSRHLzO/lSQreIlrKdgJ1bor/mUPjeim+pGVOOyvp1KaSkAQSzxLOCreEo/sUiBbAWI7Xbab3rQ9WHTRrfuRbibzJmfx6/E7NnDInw9kOLg21c/0VfWjqfuREqSdUv6xmm1csENIGLmwvGCd57OLBeAjFJuF2NyiQbdtucywQO3Bwwq0AvgAXrLsCVDSDStNWt65YcoSyC0NiQ+ptcCUPZzrIZSuIE6D7BV5nn0jsHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

snd_info_entry_write() clamps the count to what is left of the entry
by computing entry->size - pos as a size_t. For a position past the end
that wraps and the write goes to the driver unclamped, for opl4 into
sample memory outside of what the entry covers. At the end of the entry
the driver gets a count of 0 and vmalloc(0) warns. Before the clamp
moved into the common code the driver ignored such writes. Fail them
with -ENOSPC instead, like a block device does at the end of the
device. Returning 0 would make writers that use stdio retry forever.

Fixes: d97e1b78239c ("ALSA: info - Check file position validity in common layer")
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 sound/core/info.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/info.c b/sound/core/info.c
index 023b4736aa6d..f608d335b6c9 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -171,6 +171,8 @@ static ssize_t snd_info_entry_write(struct file *file, const char __user *buffer
 	pos = *offset;
 	if (!valid_pos(pos, count))
 		return -EIO;
+	if (pos >= entry->size)
+		return count ? -ENOSPC : 0;
 	if (count > 0) {
 		size_t maxsize = entry->size - pos;
 		count = min(count, maxsize);

-- 
2.53.0


