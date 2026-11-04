Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EDEA606D825
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QsOdg87q
Received: by kanga.kvack.org (Postfix)
	id 95EA26B05B8; Wed,  4 Nov 2026 12:49:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936D36B05B9; Wed,  4 Nov 2026 12:49:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9F46B05BA; Wed,  4 Nov 2026 12:49:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D60D6B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:49:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABAAC1207B9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:49:06 +0000 (UTC)
X-FDA: 85398172692.13.9FDEF92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 048E640003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:49:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsOdg87q;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bK3Qf/Fgrn1kHJyqbDbeKZxjvVolEa0ioklWbWt66po=;
	b=HQdtEt8T//RGXrrVwwkrPSshPGqXcVGNYvB1u4uy+utghnY4DO2Z9o3cKUTVxy/s5ih+Sq
	8TFSiDr94+YzobjZhR0eH0bzX+NcvfNbmumdamSRhJcKG/y7a6NYNZ9lsB5/s3BBqIZ44f
	bHbYy/u4d1BP4e1Tr01YGauKXoDFHhc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814545;
	b=LYR3nM50JOHAINlKf0X3yAzr9RUJn4iMAxZ/GdupZf+EpBDCf0t/R2Jly4LJ5laA5rYnzS
	UHj8yRYUvypwHmM+YlKbzpYmQenZQqdClCwS48p5mJMaZmPRV0ManfEFSZDQb/+eP7GTFO
	B8X3LII2RPxuhqi0OP7XAs/Jh6QW7h8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsOdg87q;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96B28609EB;
	Wed,  4 Nov 2026 17:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4F51F00919;
	Wed,  4 Nov 2026 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814544;
	bh=bK3Qf/Fgrn1kHJyqbDbeKZxjvVolEa0ioklWbWt66po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsOdg87qWEg4aAKfu42To6vm/UZV1yNeYmTYxJ9SEUa/L2vi7OcsNlGlo2QQG2p6e
	 34AxPqlbbt6FZqDFJFIZMQiw2QLV0hsb7qkRHhaUHYG8OhjWZZxNbDfCtYWBXY66dR
	 VwZtDdP5yKhUNn9j7efRMjKG472FghHcQMK4JtIsnl4KhIMc8luozwn9XNgpb/dLym
	 jnqFG/d1QX/MfntKNGND0ysdcv+kpGphBM4Ug63Wx4kZTxmszYwPEvM/O0aBqXbUjj
	 pg9EfmnQMNMIXhEAC2kHoCZcfVdgQDKxuS9t66VW2im/z5SAnSAWeh1gNRAJCCLFig
	 V6dyyYC8gUYnA==
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
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 16/51] PNP: isapnp: don't read past the end of the buffer on a large pread()
Date: Wed,  4 Nov 2026 18:47:02 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-16-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1354; i=brauner@kernel.org; h=from:subject:message-id; bh=PRZX3tU6vm07qtbuZVgSHwh1cNhLueRVjGfMu08d6P4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zrtUYRVq+tJ15s3yZb8YE8ruM70T7nORa7gzVYHp6 IWYiau+dZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkayzDP437H9oT5hamvooK OVxRlmLxXWH+GcXu85dCX7799vrxjHCG/1VvHrytuewz1X2zy+xnicIPZ+XMqNI6IcTmwLa42Wc DJzcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 048E640003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: cmez7jhjs7fad3k6mspxqj98qzdupacp
X-Rspam-User: 
X-HE-Tag: 1793814544-622862
X-HE-Meta: U2FsdGVkX18C7Zh112vh2EykJmNh3LE0iS0Vzww0a6XGZm2ky3//XlpRcdieQRVVDuvO0jNUIPZdXya2iGCuCjHHAkteypCNxYx4MvYsue8B52yKzSH5BXtg7ALCXvuL/bf/MS17gNEs+hUqmhJBhX6Ss09/Ygjb9h2/+3GCBpW6FOqdtAsVAqqGymKvDhk69jWuKFwdHf62l7kbC+sA5VhyPxKUh7w5IJo2mOX5lRAdYCIWv1kSzvzd/vvxPwfUYaeFVhiu45zLex60W2z4E/M+u7h+lWW87i2qCdIOIsytoOcFo7FOkGkUcw4DDjRzpWvwboGmSjazPlsveMoFmBcVd8IsKlm5p5PK4NoT8QZgy60RJ7io6xQ7Bu1by4ke3tws7XFQ1SaXWlsSDpEV34fgWlLm/n5sADKU8jvAY8JtYS1nv+CKmhWtFkbu3e9jyJktwfkTY64bs6leQKCh9o0XmaNmV/+5AnIK4DmbSbastvlAxaAOAtuTGthBxcX67urg842NC2Sq68ah5A2fFKDyl6/wvwTsq5b0E2Z3a2V4X7LFaJFl+DHImcxTGdI4r3JP9Ka9eY5Zmkmk47VFYV7g1QCtk6m268OSd7EHX1rBYD5vXSfZOlFFog7LK0DHp0sNlL+OYWysZtxq/se8Ihz13WIY/Ljibbstkho0wvT/375eyNiAP6Y5uza0xxiQ4df05k/63jw/tGSCXnivOD6BZ3/8BpfOvIwGXoqAteU7CEaBz47SXEPrAPwW0qVyznum45F9Tboa2O/JwS/JVa6HW6NDfhzDFB2rb2vnqrSPFx52Nd9JQlKzbkGJ4HlPS89KacqpZkW9hDeMLCV55/PHqGxTGBwGvNU36BHMk6We7gii7jkqyoXx0LETmNP9EuSrBRD0P3EQDDAis1QeLm1PI8ey9i9j12SmHYD1e6pAM56CW0kqMoLmQ54Y0RjnAyd2X5a0EV36DCSJRJ2
 ypX31zMh
 eEON0mSHF4DTTvIVZX5ofazMMB738fqafea3dQKa+bFs5zo3ks8uZ/17ZoY2TUEzMvRGVdiuyBme5Wlli9WReeAZQTBi5hwUhP3uZpu+o1UtSlTanlSlReLDGzvDwb7wKj0pPET6nDTUdwwyB6AgxgWq2KHrxSbYWGddy+N0r9EK3tDZyC2KUKv/fHLBIKR1lJtWlPPZDCqH68h7h+QgNOge2RwmuFAEnI6Y1MhMNspG6y91RmQVdtqbkiHq8PukMb8UOh25z7WrhG+FqT2PI77ct6pf7DAH9Xldrq5zMEo67sMu6dimJ11FT5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

isapnp_proc_bus_read() truncates the position to an int. A pread() at
an offset like 0xfffffc00 turns it negative, the check against the size
of the configuration space passes, and the loop then puts everything
from that position up to byte 256 into the reader's buffer, no matter
how few bytes were asked for.

Keep the position as a loff_t and clamp the count against what is left
of the configuration space.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/pnp/isapnp/proc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
index b3abab24050b..1829c20d5446 100644
--- a/drivers/pnp/isapnp/proc.c
+++ b/drivers/pnp/isapnp/proc.c
@@ -23,15 +23,13 @@ static ssize_t isapnp_proc_bus_read(struct file *file, char __user * buf,
 				    size_t nbytes, loff_t * ppos)
 {
 	struct pnp_dev *dev = pde_data(file_inode(file));
-	int pos = *ppos;
+	loff_t pos = *ppos;
 	int cnt, size = 256;
 	int ret;
 
 	if (pos >= size)
 		return 0;
-	if (nbytes >= size)
-		nbytes = size;
-	if (pos + nbytes > size)
+	if (nbytes > size - pos)
 		nbytes = size - pos;
 	cnt = nbytes;
 

-- 
2.53.0


