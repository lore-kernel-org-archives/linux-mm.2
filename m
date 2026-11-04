Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B13606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gx1ml92n
Received: by kanga.kvack.org (Postfix)
	id 798796B05C5; Wed,  4 Nov 2026 14:20:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770136B05C6; Wed,  4 Nov 2026 14:20:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F686B05C7; Wed,  4 Nov 2026 14:20:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 467496B05C5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:20:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E883B1C3CA1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:20:09 +0000 (UTC)
X-FDA: 85398402138.29.7891CE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 21A35100009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:20:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gx1ml92n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bK3Qf/Fgrn1kHJyqbDbeKZxjvVolEa0ioklWbWt66po=;
	b=GRA8cWYZ7u9lsbE6qoO0Jz4AdhsY9tOTDL5BUIUeUE8Ty06KDo89ZQh35kzet1r3dC1K9Z
	SQZfDaL10oCHcK23bcVLNqb3Y0oKLwfFSJ+V9r3QzKa73qIc2Z6hGwC3nYzV2ZhTBoGeBj
	2cqwEFJENJfaAN6XExlE4yetrHujyFc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820008;
	b=ut6GP3HO0wKRrnxNE/slV9AGl1r/9Q7H1DhZs+EUlkd6PNObytsTNCKpOdbsQ6J8Qc2Wwt
	MSwTIZfoirXZ3sIU7sy2VE/Dp+ZEYUiUwe4Lwill+0hnvCvf+xCH2/Ggl4k06pY5QEb5eR
	n6nz7A4IqXd9vj87yqE+RWH8FxtD/ls=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gx1ml92n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 711E44386D;
	Wed,  4 Nov 2026 19:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBF81F00919;
	Wed,  4 Nov 2026 19:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820007;
	bh=bK3Qf/Fgrn1kHJyqbDbeKZxjvVolEa0ioklWbWt66po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gx1ml92nagZ7BrakhHXJtPQ+gcEUXo9KcayoMJOCqeD8l4YNPDO/HrtuxrVu5D/yq
	 AkBUy+fEu7DUS3PpJdPB8rP4qDEH7v+3NmBlnra1bCI78Eid7vxjW2+TTJjKFk1pa7
	 AD/p7tsz2i4zyXv6Wo6PwRfTfO4UBAA/iJgcwnGbIppd57DabriHGLgMEnacFdb1iY
	 GWlISVkMuIM9OcUzNZg45npnuMJt6k2wY5mP16R0b4wLk6SxDPuMPpdKe7JIGFtdcz
	 NWUGr2t2OzbQHDfP3LGVAcsb0fhKK1thVAFYLu2RzFUd22BqXfCyjuiOfZQwNar7gn
	 x0rZz3DaKTIvg==
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
Subject: [PATCH RESEND v2 16/51] PNP: isapnp: don't read past the end of the buffer on a large pread()
Date: Wed,  4 Nov 2026 20:19:53 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-16-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1354; i=brauner@kernel.org; h=from:subject:message-id; bh=PRZX3tU6vm07qtbuZVgSHwh1cNhLueRVjGfMu08d6P4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9brwfzl4y9YPS+9UnzD/xWPz9cFZ3YUK46s/HNev+T X6yzjO1pKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAik/IZGTbFfnLPjP3etuFi 3uYXH/odI/9bLkx7YPeroPeyylQ3HSWGf0oRmziNpv1f8fdY/M9fuwrPnSgJELfs+hiheTJ/BWs JOxMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6dyodxmztw1a71u44risxenf4ypkze4z
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 21A35100009
X-HE-Tag: 1793820007-207436
X-HE-Meta: U2FsdGVkX1+XdbS19/qwR81rkRW7JurJw7Ikkt7nfV/BU+qaGAs5b2/BGky5gAs/K8F8D7qhlZu17x1HvkQVdDf39srsDIeBQ29/0X0gIIPD1J9Ddc5NDVNUh3tA5v6ohICJQxdnayGukTAXR3vB87LqB/YGpm/i5DPSfi3DQ7JIBrChp3nGAM4WDXF7tyiNvaUp6BP9CDSf/dxjFbbdfi9qi7OZ4ALM+B21AdyX4iHfSKSIB5+Fjawt5nPU1Nb2XysJTXrQdN/nHBCKERHe6FQ2E9eoNMNZtmj3cGVNNI2acDSKTKxrNvGvBLA8rnMLnZyAnQMek515v+jBb9gEN7RwnAk5WQspcuAb7ZOFNWNVu2T2zHfl4p8cmlq/u3B3kAHa9zLNvPWD7sSVf7ZOlfyQ/x5HIuP7LyDMJGDVto8mXETlnhehBGbEcZg2PRq9wg0xHA7oncnUGWdGKg8v9q4BBq7UyAbRgSAdIBdx+Efe4Egfzw3e6CayWSYnEuLceZWgexTSiKwrsdLizpeOUrsix3CMnXoDgGQdftp2JR6KFuMbu+e4GU288+dJmTbh49NCIKxEwjdBYvlmfv5+tw9e5KYR3P1r6tZpwIsy3xVA3a5QaTKXaFR4PWgvg/37qIOvGt9JHjTN6BXdFAQCK3n6depmpXVs3mkXAJMQxKM7LTIPOWj/VPQqpPJYS5F7Fl5L8OYsOngu33X7QEivY1m+hrwuZgNpmjvu4SvyJ+ZSRJQKb3LiExgX/9bUk9FXYbu9UWVq5zvzda0TWU8RSEGUQdFOG3tyLcFuCDmjYmydawcwpD4eoj09/k5AC7EW6Sj5MQLszWMBKxIcmHjtvLkdDvxEhQHVXkjLL+F9e6tKdKdM4uFwDWsxybMR9jOz3LlsMLx7hYnJPnDmDber7Yo1id87n4TNasq71GqcCJ5ng1HDKZ4lP354Cyqyce7Qq0HmJ5UWU58wP+G168o
 Q2tMrolM
 ttRlKm3JKnF/SYmPzWJSlcTKGZQ7Y1kN30ANJMw8WrEc+MoXqE4EwPCcEIPGdoC+PbghfKUn8y1MyyB7/oi238kkdbtbzqSzmYyXJqt2MhYv55hLyjcq/rgbkDlDWnDUxhGFg0Lap5idsRa3k4ivlktdM3lzePKK5/FV8+VcU1Spl1kE3bLqBy0VEmIjOOSGguA9ZQlAO1/+/HCuHhI2/B/3Pxh89FJ8s4mqWcm5BwSSSZgQa/9UbzyWpDJ3jWUbay7rUnQ1xQhDZrJMz1W8q0X/OfEN5gYJ5ZhDPhozp2KohfWPXhzqfnpXXLBdSEB9seUIh/O/TXs6nT/YLnxyQYbYMtAhLInH2lZ7HXq5LLlGuu4W/qV+/dv+jEpmS9Yg4CVPYyczdNeEFY+0OI19y52FEsQ+/Bc/084H3I913bEHjJgULboSKjaymRw==
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


