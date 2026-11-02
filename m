Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C19D6070C83
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ReJoE6zf
Received: by kanga.kvack.org (Postfix)
	id 542E96B05C5; Mon,  2 Nov 2026 09:24:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519AB6B05C6; Mon,  2 Nov 2026 09:24:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4301D6B05C7; Mon,  2 Nov 2026 09:24:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25C026B05C5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:24:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE0B58010F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:24:37 +0000 (UTC)
X-FDA: 85390399794.30.9CE2CDB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF87814000F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:24:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ReJoE6zf;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629475;
	b=3oX3q+zmZThlR/cbHkZMXlSZ9vUYXBtpRl7j2w2YzLgk5TYlmuN5+MB7ITnqIoQpCkDFq6
	bVoY4yiMven+HCi+8wnaiAcZuNVzjQ/DzjH4zKH4viTw74gsS0oq/RNvrGFRDAEgmHOJ1W
	GcyshzBtJeGse6uRQ00Nu9j79cbS7mQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ReJoE6zf;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frXlYovGKxKiSN/Oj3/IY9GUET6etUhHzbC1M94LuG8=;
	b=xleB87WOODKzJalBo3T1+9eCPdY/HXyD3PbY8tIIBkepWZX7yrOrdOsGJxAUbHNyQEUoL7
	GvqdpbsnRz9D9/g5Yp4B54hLl2cCqWTR+XFS41TuzMD0Zj53Z6So14sUeoHenWl7wg6NSP
	dbnXSfHYRkiSh0f9yEYkn51uFHdoxFw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 79BE7605C4;
	Mon,  2 Nov 2026 14:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA8A1F00A16;
	Mon,  2 Nov 2026 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629475;
	bh=frXlYovGKxKiSN/Oj3/IY9GUET6etUhHzbC1M94LuG8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ReJoE6zfwlMZdL/D4kBPHthe/7b2K1B/nPEO/E9fDnKPvAkMnG3q8iqFJyxNfgYxT
	 +l0bLxPIHxAyiwwkTWc0uyVHHVBYLTR/rNVKqQ159RwHOdEMgFr70nBybxd8JaVcAZ
	 INkOE+RqOwXO8hKmtfOe3uu52SEXEIDC8EbApa4h43uDc6EQp0NHZaMrKSPGxDLmTa
	 z3JiBZz/mUJm70MBn3REHME7mTQy2jABNt0dk+JRXthyckWXmXkXSvKDQjG8t3ZaWQ
	 U87w9Z+1qwvggD1ALH9JqxHF/VsBzvY+LBC2uMMhSucHH25d+pQJrzTmhyQC9KPZ4G
	 gBzTDPDZGkvzA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:27 +0100
Subject: [PATCH RFC 12/38] wifi: libipw: don't return 0 from writes to
 debug_level
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-12-59422ed3e465@kernel.org>
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
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1059; i=brauner@kernel.org;
 h=from:subject:message-id; bh=PSZyn/5j7f+UAGnOkF9zGJ8rErtLF7uTzeHltQyv5ig=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJNt0aR9f0p/qPzeecf+P/MKzGqZHjSv9nAx10fn5
 wXb57eqdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExE6x4jQyt32MU/mspx/OIz
 9f/2BxhfmF6ZzrB0Ced7yZ3V6unKfxgZbjIUhrXNX37666wNDOpX7329dlJiQe1ekZ5/lQ3MWmr
 ruQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: aagzc1x87hwjarbh18r1nu3qzxtfgn9w
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EF87814000F
X-Rspam-User: 
X-HE-Tag: 1793629475-858448
X-HE-Meta: U2FsdGVkX1+36TOCFBdYC0fMsF365px9KtEKeQJ/B9YwHUmAqc2u+xpJOXOjvIg4NiD2UNq70jJjeXkjYv4MYJhqiwzTfyKuHTzneEdIM6/bEyxqVAi9d7yMoEIwXCQaHKIYXyvk9pAxhMveCyFV1AaLHwjZJjqhQBDA8OD2+H53QTG7NqHXg8cjkhN/Ri/hsI7TrvfnlLjSCN3BplYUJnIFw8rWbJaq574iEHcBCzKuzJ9ir9ZbS/8PVfoDRqEBDqwMsdfxV7iXprO4KUdtZhpRgEjvMfsqZZIaV3kKSBxoN8UD1gLqaIzCxfMXHA+0rd3lwh2zP4qOSyk35e+fEOynkg406MqwfmJFEhcdHONVz3TJ0sIaa62jnKVfDSqqANFdqV8WJsFG9JM4inp25I/RQU8pKnFuc57+QGdL2GFtVYLo1pbBuwdbGIU+FWoWKM/pKXLF5v1zJQnG1zo7WNLfZQqKF3Hx6iuwnlHGck2SboUSg76N3JpBkoAZ5/MJWLzHKi/sxGTVyFWAevLX10aB/AQHBDfHrAJhtBcz5wqA5U48ZP491XFOfgwXXQuocLHrsx1lZgAGMsqkITZbLTMUWyEQcddhjXXs04Rr40QZRYSEkNOY3LlqQ9wLIPQFGcxzJhwwvCF/ZEr3mOJ7YLFzPyifovbeb8Hv27YV/SyQZAflzENtMtWEdr2M8urRpSfQgZIb/dojY90jUP7TOtjVHNVhZt0AV+qqZ4e15s0vlYEHfavMeE2DnM6SzFHetnnsBjNTa7KLy8LlmNdCQNjV2lmJMfgOBVtvy2uGOXWjh+FIBLeXDYMCmmmXPY7pDcodclkDFrtAijjMHJMy0sP4gqA94HzhJPDss7xAx73VxT+4AGUmy9s+YZrs0exPldj3/6bDN5aVde/fUssBSrlVB8rrkYyP+QDZVuEDegJF8j8CGWo2LmURfTMsIv1i9rK5Y3H8eIcNf7qwTJ2
 0xYas/5K
 pZ548dpUJ3uNaFnyL0hMK7Rh8nnn0m68HfbUF0D7TLQ92b2rBGKyqBSMGmVvPXEfUZ3PZPZmQJAn9H+kNjclDob2RDduiqCF6ZR04wxbYknkGpIdRTNxkEsGELRCd4/uMP96kDCvqqPXtfEMqwQ+oxQp/5mOjY21A329Xiuzuom2nVF8vdIE9j8hZDeDAo/iE7uVi3O3vqGH9vNZuZyf7e23JVX5JuxEUxpy+rtMdg9NeGrUYYJZP2dvQfP2H2YW75HDNNsco8OTNWvexcBx81izVjg3n4XEqS4A9Yvx9qf3u0fLEDABXphM+lRA8Ro9k4sDynP97TF2vzhQ=
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


