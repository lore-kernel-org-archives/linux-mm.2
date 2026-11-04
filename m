Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D32F606D80F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JXuPQ0ie
Received: by kanga.kvack.org (Postfix)
	id 372146B05CC; Wed,  4 Nov 2026 12:52:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322696B05CD; Wed,  4 Nov 2026 12:52:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F15E6B05CE; Wed,  4 Nov 2026 12:52:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE20D6B05CC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:52:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BFEE807F4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:52:55 +0000 (UTC)
X-FDA: 85398182310.16.96891C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C047D10000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:52:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JXuPQ0ie;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LkQzylMBPw/rjuFeKsFyNpbMkN4WRhLixyhJUzJNoRI=;
	b=7+yDiDbNr0L8Sqv+AQ5ahOKpL9D1I9UwJAE7JdPHGAf3hxcKgaNETU3J6AEeWwzT9U8ec1
	Cf+ii3tISREmWknEAJDaqO5lMWXc9NYUB3F+N/IsUEJpO/H+5sotuAUxzQb54ONgvbSKfu
	k6lmf4d9Y7oCMbXouEWLU2Ya6TOIDwk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JXuPQ0ie;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814773;
	b=Up8r2rG6QWlcPMzjx22TZ3IG9RoZvA+A2KLmM9Q6mu9dfz7/OEn4h4s4u+3jl7HB569wUD
	IMjMsCkmKQ4F1/F4lgxZ1SOsWZYDGezXxASLM9QVjhknE+NqloPvDLL4vHqJ6l+JM8YZOP
	/044KnSSMRgPkDQzlklFReJaF/3X/bE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F25C6022E;
	Wed,  4 Nov 2026 17:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428D51F0093A;
	Wed,  4 Nov 2026 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814772;
	bh=LkQzylMBPw/rjuFeKsFyNpbMkN4WRhLixyhJUzJNoRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXuPQ0ieI1SmEXC52KDOcGy2C42dUQXH2gWt2mtcU1/uOST36dyA2aX/TbZituA2X
	 Uhu3k1qct8vUKtDQH86VU1fhcBrjtbnzssmyZOcNcGl5JFmkchB4Gpruy1pXNgGar2
	 VxVKlSU3xlY2ad6FO1CicLCPJyfh4ydr4gwsesh5g7agPQ4ipkIS7Cs9Wpj/e9EmLS
	 Jm7RvFMHC/cB0vL14NXKg9Z/LHaENtZFhX3CEfJQZj2LcqrxZuIhRnv467SSOX8+tP
	 0daQmY4DIeH2JUseA+pOpqhVDaW3Hc6WCgGMkzhZymUpdndKfNcU8aZ5068txhavYL
	 LTnnyBYHI3CAQ==
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
Subject: [PATCH v2 28/51] ntfs3: don't warn when a huge label is written
Date: Wed,  4 Nov 2026 18:47:14 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-28-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1211; i=brauner@kernel.org; h=from:subject:message-id; bh=CQmQXvWqu+qpRxwX3Ai9kAzqqtrenD8xJsc3ckb17sQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9znv41bfhRbr0hB7+QH1DQe2NteXb2LY+9z1XbHd4a cOjhdu2dJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkohAjw4rCmq+PWwJsL999 t/rf/719dR9cv2g/ad2gpsY5lzHE/RYjw7O2xVsFYh6FLFHbxmXmqiNfEK+8fvH1tXZe9j8O88X sYQIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C047D10000C
X-Stat-Signature: ratxs8e6usoxr5woegbnuzemxgs7kss6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793814773-975229
X-HE-Meta: U2FsdGVkX198AXW0M+30lDk786ii/MXlOtCIRuYkikrOX6ID2JYdsJHoaTDCbk11CfGrGaby+acoIHn2jLNVlXL4Vfw5SxHXzAj408GvX+YOCNPxMF0KA1pxyfdB+TvXtao4mdERVDQE4L+sySLqhynAy5Wi0Zm0eX2W43Ss+1UiE2ymgLWlqY1Cv1FEuXbIxlSfFWa5inP1N17y1mRcl1JMfAqfkA9MpLW/8OvMRlygKjQMwoOo1ewyln04XZxnS9AcBBFkAs2GdSLSaWQIfraYRTa7tsaHlVi9cddJmxU/7NZ6uL1YexMqROMLlO7UtFreh4DJ1BSO5jsDpQ84bV2vjvonVOMSSGlD5+oPpNcF32CIhOY5uMEgy7iXBcS+llhtkL44zOxqAZ8Q7ge0Dz3LY8xyBMpMMzLWDonKz57UwyqPdOwiZvE87yHfsBK9s9B00lsmnXc7PO2gw9/27sab9hcLdJUliJG/9lLXWHz2QI1Yt22B1TQIOxYmPT/ld6V4Ac0HrydpQ49cWxcI4hns0S+chwk6I7Ni98nNfMnJAz9rYORG2K7gT1F4sw1W540G8GGLbVMZPpCYSrMHlMEWDHLfXEHzQlFYzDzCrX+pW+2jQNMya3gD6kKFJAhIzXOS75F+o8lWxzI7jX2rZMq5H49g0fKRO/Dh5h0if3RRRcYi2ETmYRiEU7Hc7PKB0umbU3FAdZ3Zd2BjYrYtukz1qsNFPNuZTk+xjB1qCdEu6HgWMbRmGp1hjkAvM7mXQW7Gn2V7sC9jdOFBXw4w0rmZe7fBOxP0RQK6M+8VMEi54hUoLHYrAIVBHEPcU9PXtK7n05vOpIujddnfWShYMuTRBKQxYMPSUrVgWMH89qslID77+PySwJNIyoXZIKPkdMJqyxiuHJweHOGAtyre1z53BEHgvSzeX3UPxTOG+nyBBG06EQPBO1I8zkYDy2isujhSU2vipj25A27mwix
 8+j0fRVS
 FYCa4zirTCiQ1jnaQbV8mpPyzlJ1OWxRVbb2j3m90cEfg7X319bbzis++ONDWf1BvaQN15WNYCmhu4ylvxeFXNxbQIx2WGSn2IMgtyDQfHnNel+mxzjrwSP4qVFcZXVBG4RCAlGCmJZrgMSKroH8itlcdda8hB3hMkbOvJb/ZSPiWEtO6dqQb1rR8O4ZAz3RPQ7I8AXffus4Cf6OD4YLGMpPjCliPHFEjVIdnC3ekP7qZrJafGD/3JJDypANaISMZ79aX7zMDhvNwrf+IiO2iktptKxtVWR8Ga1cvHTUTihyYMYdUrsM1AWws/w6+OZdpSxAINA+pxLCgJxTYhAQZ75omYUP5wH6JC1C6cbIk5CAn0LoBs/X7AA8/ZxzYUMJi+WCT6lBsRpRiksvJR+GmRGt+MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ntfs3_label_write() allocates as many bytes as are written with plain
kmalloc(). A write that is larger than what kmalloc() can hand out then
trips the page allocator's warning, which panics a panic_on_warn kernel.
Use memdup_user(), which fails such an allocation quietly with -ENOMEM
like before.

Fixes: 7832e123490a ("fs/ntfs3: Add support /proc/fs/ntfs3/<dev>/volinfo and /proc/fs/ntfs3/<dev>/label")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ntfs3/super.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 29aabdc8a801..37e27b73b7a5 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -576,15 +576,10 @@ static ssize_t ntfs3_label_write(struct file *file, const char __user *buffer,
 	if (sb_rdonly(sb))
 		return -EROFS;
 
-	label = kmalloc(count, GFP_NOFS);
+	label = memdup_user(buffer, count);
+	if (IS_ERR(label))
+		return PTR_ERR(label);
 
-	if (!label)
-		return -ENOMEM;
-
-	if (copy_from_user(label, buffer, ret)) {
-		ret = -EFAULT;
-		goto out;
-	}
 	while (ret > 0 && label[ret - 1] == '\n')
 		ret -= 1;
 

-- 
2.53.0


