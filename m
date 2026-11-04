Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CBE606D812
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L4z066t7
Received: by kanga.kvack.org (Postfix)
	id E412B6B05BA; Wed,  4 Nov 2026 12:49:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF18A6B05BB; Wed,  4 Nov 2026 12:49:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C964A6B05BC; Wed,  4 Nov 2026 12:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9706B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:49:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1754E1207AE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:49:25 +0000 (UTC)
X-FDA: 85398173490.11.DDDDBF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 403D6180009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:49:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L4z066t7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDYBcNUn+VWuCpTwTZF6KvGO9475Dcj2RU9o+tvUNt0=;
	b=R/zsIPAlIZSqIyGfgQFxSt+2wu4g+AKSNScXFw1gAez8V0cEKgsfS1wGh7cOQ5m6XXGPnZ
	t4ElmBbb1wJ2ADuNyftgu/iQWArQ393uF2WPBSL2M8g7H31O2s30Q4OJz7XmscLbYFlT/m
	ONMEvV3GIXrZXoPw8WiM8m2oUNSe5PQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814563;
	b=fTuzIbg4Y89LryVw4xNJrwopkCnhLnIg5udj484BZwk7cxqx1v7UJI6BYixRMMxno0pkPe
	lmS5fhq9+jYqpOmIiD7kLwM4UpDDKAO6RR2P4dHNqmm5qj9Q8ZWIFvDU7xNokEoQx1q56j
	zoz2vg8Kj6tLpRKtYw8BJkSJ5njUCOQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L4z066t7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80123401B0;
	Wed,  4 Nov 2026 17:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11ADA1F000C1;
	Wed,  4 Nov 2026 17:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814562;
	bh=bDYBcNUn+VWuCpTwTZF6KvGO9475Dcj2RU9o+tvUNt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4z066t7qk8SNBZ3qr8F1Dv4FM+zeL5UMqbVPpZhgdQRsqgneSAYM0s8mSty+AN6F
	 uOpJwVDXNMcIMJN/l4FNHGQgvK/QCR0cqApE4XNvTdD9heJSFssRxRma5MIWbLp5q7
	 KuStqfVc5Mi7/uCEtKU/XidV25HekngkokdSavKrGmFA9IR6yxAQ/fT2R/UVEXUpOV
	 JshYWFM1jRBiauogMI9LETcKUpSEg7rlt/XCrsDvHcIcKKrKf+Lfu9grpGXEUlOUBw
	 il1cziT3er+LG8IbGUfsHyBhUl9fEmWujhzvys7fEbuJMHuqJFLv3DIRlBTxlslyyu
	 1lR419jEJXKMw==
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
Subject: [PATCH v2 17/51] s390/dasd: don't look in front of the buffer on an empty write
Date: Wed,  4 Nov 2026 18:47:03 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-17-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=952; i=brauner@kernel.org; h=from:subject:message-id; bh=vNxDJDpmoyfXJahneUuQ9vEH9eL70g/8w71rNTJgUxc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zrsssUymaabA31Var5avOM5bfCJp4gvZaynZy78sz mbbvsPjXUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEJKczMuyYrr82Yt6rR8wV ngvXr6z7d1Hu7s13rzfk5t00zdb9H3OckeGStmp/GZ/E1KSXmfqdfP1HWkLun/hu9/dXSsq18Bl 8+mwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bmfyufstokf5kdajq67tbucg3nfej1ti
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 403D6180009
X-HE-Tag: 1793814563-87205
X-HE-Meta: U2FsdGVkX19B9s8qiwbyJp4foYp5fjT/alU3b0vvB0XFpg4gPCw24UxBfS/fg8sSK2ofyT0sx+7L1fZDXGr9vYkRaJjheNvikZMbRs7a1+9ORmZhg/M4BLtnfKj9+PicRMYzhWYOdwve4CcCAi/M35ySCYUvaxVyqgXAoiZ5BKRr6uNx8SGELwQteUEhWmq10XLOwhI1QxoL9/tT0CqL6JOjDN+SX5W8ETBak1YlN+zhbzE9MWtCiP8N2Ds1F/WtDrfWlJnCEU0PpDJwzIsPZ+mvSYjK4Fe6SxpMgvHQ6K3Z6oCA7Mk8LlezwhtsbGBkQS0xskGI0PscWyxGvFbgp6xo41ztVtyEgkJ6QWPX6zsP1DFqUSV+SRStx9DpQY/qYiwvOP3yb0BdBtE6Uiy836JkP6pBZvCUXjIhMzCAHD5KErOjJ0daOe2LwrYmri6/jhcsxxR6yH1PwJ5G7tCy+nWTo2mJWxwNInvZZ0W38LLzPyLpIoFbmKPIFngZacUYiW239O5sdPIKcM1qiZBmYpD/EbXnL/qAWPVX7onhkzGCSK7uBbV6Q5pC2U4KFNP6zxGkDapDGRX0P3cAPopGiwjFtjStLCV1HfGg3AOc17J/CoRqrD3FekBw2JSFtq2i4VgSDV9vGyL49QetQdMJ/B7xWjOt43QOjhQN6+6PsHldauCK641Oz5VB1imDxN5bYHWUSZyTqwq0FCX28IJeGKQJm6tXC+IZEh5c7GxBu63KRwoFeLJrahLvWVDLzZueFcXqsmI/3aRQ+LKni/sT/WGRgQSgu5l8snRB5vQ35ofrWV87318lD+4ptR2bsdI2EWgxXMxGno3XO9oLqookpOpkYUwXXvLwMRptzCZBg+kkqoFi3bUxJtZ/mPE6AOApCG6lMmCihRtnQzFcAzR/5wt4pI/iHWLVkfRIjs7O3PK/cd537aAmLufQWd2Q+5wngERzWc63zAkA+6OfJ4u
 bTlUGx1z
 8qG2lq4YiEFpy6ji7PPFwFvccqL0Ej7fte9er+IITPD+5TXOPeoUkObxQ6tpMvl9zVb2G9dx+gAlUKzuPqeQsjPNGskaUfIWnZqyu4dJuYGrCovi+4V2yntobfG8b1blu6LJZzv61qZaV6zquk690yY78XMAh6pJQHTj8pjTHBOKL5v6hF2bLRd8ggdte5lP3sHPYod7DGKHDamrkyuOVaaJewpLUOXeioQOytEJole1xCdGvjUY8zQc2JpMqBYp5KqBEExiyWfIEdRLa8ieqZfMuOIsnGHFlmSuNdq2JysSg+tplO+b1OD4/eg0EQAAurf+FZ6iFZomUuV7T6H5PuBFKB992/0Y6KIk8WXBAFLJ9vr7EtC0MDNODKFcS6XQxynr1Nqrr5xvSPkcLXJRRJvb5bB+IkZKYBorwap5t7Pb+tQQNEHH/eCKbOg==
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


