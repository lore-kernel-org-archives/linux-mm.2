Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3DA56082BD5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J5l8Zw0z
Received: by kanga.kvack.org (Postfix)
	id C229F6B05C8; Wed,  4 Nov 2026 12:51:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABDD6B05C9; Wed,  4 Nov 2026 12:51:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9CD36B05CA; Wed,  4 Nov 2026 12:51:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8272D6B05C8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:51:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14C8A140763
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:51:51 +0000 (UTC)
X-FDA: 85398179622.01.3C92DC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4EB262000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:51:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J5l8Zw0z;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814709;
	b=Tobd0TVrMQKLJmzFqa2LHXqoKztE4BycBgwiKyfX9nIa3s6Wiu/teKBik1PBonZFTIGYie
	awbQHU/6XD9BqouQcwub0cdqn7ti0OESuxenfbR6OTBOYTg3Z85bnSAzG4E4rTDtH0gAny
	ytlswIWw87WWhuIgINh9w3X1smfJNCA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J5l8Zw0z;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frXlYovGKxKiSN/Oj3/IY9GUET6etUhHzbC1M94LuG8=;
	b=s7bk9wntNbn+OY7EIFqeyWJzSQzHEAri8LD6ZpqZofWBpk148N8bUu86RFLerh2H32vCkw
	+pHmcNAvtEbmSd48sW9lY9/dTHA3DawGJdmKpsK9C4ZVg19eKpJX9mCXjKiNXgWsMnixGw
	MJQSOE8HgDQJgdukZ3qdk0D+EqM5x3o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A286342D92;
	Wed,  4 Nov 2026 17:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193531F0093A;
	Wed,  4 Nov 2026 17:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814708;
	bh=frXlYovGKxKiSN/Oj3/IY9GUET6etUhHzbC1M94LuG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5l8Zw0z4fZQ9sAGiyuZKFV/4Ks48j+EfxrlJEYi7n7otbyz7JFysKU1tHI5wpj88
	 CpOhI5fgv4CaHLI1k5XmU9YiA46xrA8Q/vpms1IHownsPnCRxeJYtvKMkZ0z9QgNGJ
	 Dt0qEGBEKG5uhOJH57H9KzWgwJVHzqSv2uWCyWP/yhmZTJIZYv4ihYn15949Cj3mSN
	 QjRMpFLnjQyEc/6vhtJSsBrbaSWk3wEW68rnJHO/8rURtjSRpPMZGCFfamkIjqxgLP
	 QLC4T97JjDLFJHcKQFwVspL3aQSwWyfRwRGbw9wXUukNHQZW8xsWkstW7G+uLWK9lD
	 r9NkjTZDIFp9w==
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
Subject: [PATCH v2 25/51] wifi: libipw: don't return 0 from writes to debug_level
Date: Wed,  4 Nov 2026 18:47:11 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-25-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1059; i=brauner@kernel.org; h=from:subject:message-id; bh=PSZyn/5j7f+UAGnOkF9zGJ8rErtLF7uTzeHltQyv5ig=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zrsr82TRXDvnq8eP1Wy9Ln1f/sr/I6YcdTNlV3pEL JFvLsq/01HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRS/sY/ifVcHOsK0nzflX4 5M3zNcdYuHyXx97Te1lgK7btRfzEQgdGhgfMrr8XiR5rdt334XRQxNzpt78YSt3vXc1o/eVkzmm Ve8wA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: show8hg77jyrri9qx37t9dawnyoxjgn4
X-Rspamd-Queue-Id: 4EB262000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793814709-449453
X-HE-Meta: U2FsdGVkX1/uR0Nw7NJZjB58Xa2W4IX2AjUfj8HxdnUWgLIL26IXXWG0V3nfl4l5ZeCvz/dXQ3jVmrNGSczIaAuDHyfg5JN85u7iWwxTRuc/Is1Ud8vS6/hvT8A2OELI9OoAUOSLkLmTQQbAPuIZNi4t2SXYOUK4Wz1DharN207ekbdwdltcgihKYHlllYi8mRUIK+gqljUsQhOZoO+4zfkU6wFWFUW6Nli7NZ8zWmXIA3cZihu5CRSBYIlSgFGD+CZMEF9gDcs6270wzW85BdK2F4WNcv1rQ7cMDYzx9DA21fWxDIWgHvdwqdDPgXlAslduNlMH6icvDntBvbCQyx1Jl5gswGWaH6TrTgkwCZySE+ORknNCdbU9JTbV/W+ckIW8ql249z1pEsJsgwxlBXW+WbkrJwQajUzPBHmZQxYu20UkeoPMJPL+G7jZT1pHQD5zMY0OhBfCcRkJINz8hVV8kWQ3/Po0hW0OrLSeaIBEoTzfWomppxxedrlHX/oo35ahFnkNfOlYAh4AOafcPkebQpbHuGK7o4TQ8w4ATPkDiVWImz8e5rvd4CMKyQ5dLCt+fxxclMUbUrGJil0+J51OpgW0wKp0RKnRs++qIuCu2EQ+m9CyFIAwP+yoo1+ec6Qf+fnkP1AOiNVBHMMTp+owuhfX/KUfQwIV/7E7bFw7Y3twYwKhkzAlsQlqX2BinSw15GnVp+DO89jgLO/LXXkoT2bfCRwv36GgxEBqP8zzsjJrREXQYzgXZj24zRMd/xPa5ndkrgiJ/usCA4EHn0gXMQn4BwXm/TGgmPvAg+hO/Jh60NItltpRTaKtfZjBDnY6B21AWLUde/Zlo3Gw6dje1VP4bIOsU4+skBLYCPxTk4u6ox+NKgh//3z/SlZ/Z87dpZxxBnkA30te5j9RTwjuuIKtfD9EN7D4PuzTRE2sJPiJazxlx0DRJAX9tXifjDWwqt08+Z8HKyHq3Ew
 85IIldyh
 zL/dYWR+d/Tu7ZcUZsehNS8Ie8OSQLWqkFDIqoNNml1HBBiRaV/83iGaP0F3e4LfFT7gNdkd92JTSAc1igi65REVvfQ0eWY522WYDSDFDmVyh5KTunNEf1zru7JEndvPXg55YWuih+54pP7knlJvwacKUPPyzoe9tM8D4XdzvNIwtn/8jJBju9mZbfTireukuDpAgnj98Ul7yjGK/2kODn0RhX2yquIsEr7Trhiop6t6XyNama6pr3k53Tp51yQl6LOJA9FdEHM5UeD+yKsp7Vs/wt9HKG6nxiyEOeNESpqNi+4yxB70ADGvJd0oGkJk+1FGZqRXww2Y122yyLtj5qSgq3h4iW/uKgC3BcJmk/Xv5ytR7dvYxdgzNhcwKtHOZi+Tiz6hwKgCb7ZRt4j708pQ5QZLXSIOL9OYCb6l5kD/p+qDteyXdYobqrWAeyCpyeuSRNdZmUI+by74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

debug_level_proc_write() returns the length of the string it parsed. A
write that starts with a NUL byte thus returns 0 and writers that use
stdio retry it forever. Return the number of bytes that were written
instead, which also stops writes longer than the 11 bytes it looks at
from coming up short.

Fixes: b453872c35cf ("[NET] ieee80211 subsystem")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_module.c b/drivers/net/wireless/intel/ipw2x00/libipw_module.c
index 22358b2c2ecd..552c8ff3928b 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_module.c
@@ -236,7 +236,7 @@ static ssize_t debug_level_proc_write(struct file *file,
 	else
 		libipw_debug_level = val;
 
-	return strnlen(buf, len);
+	return count;
 }
 
 static const struct proc_ops debug_level_proc_ops = {

-- 
2.53.0


