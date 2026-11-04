Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87AC2606D4DA
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ijnLltQe
Received: by kanga.kvack.org (Postfix)
	id 94D5D6B05BE; Wed,  4 Nov 2026 14:19:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5866B05BF; Wed,  4 Nov 2026 14:19:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE7A6B05C0; Wed,  4 Nov 2026 14:19:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57A2C6B05BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:19:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CEBC11207F2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:19:11 +0000 (UTC)
X-FDA: 85398399702.24.9A764B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 279471C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:19:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ijnLltQe;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819950;
	b=GpSHOjluvVPWrZxoc5fBjGLxDnn2RM+zTeC/N7PU6M6AcOuFd4Q5czhbkORR0/xzzxEsJa
	KDOJhAyJ47HsmYInGdnCzRmDjfx7WuMmBasscP6CDAmF3NQZvjgBk+aqR41RuWSzQYO/Pr
	m4qEfvuPLAfmMdyWSKyBhMLw0jZoE4w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ijnLltQe;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdnthwMs9LvqnLJy6kPpeiwqrlhi6ADC7izliWiN2IE=;
	b=PFW6PGLFtKoVbfleDWCDyfGVHAShUQQdwl2WyfdAnsiZfdybsUFmf7RdY9PTNGsUStk8ZS
	86mhBYDIRJwAwcWCu1N7j0UcS46aRTaOpvcDkcmJ9M7WZOrLzlcN9yx/HfTDZrW/t7QU+y
	pSdEwqPDJEX7U/OJfIu1I7LW9qhMnrg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B8B2660AA2;
	Wed,  4 Nov 2026 19:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86A61F000C1;
	Wed,  4 Nov 2026 19:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819949;
	bh=mdnthwMs9LvqnLJy6kPpeiwqrlhi6ADC7izliWiN2IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijnLltQe5Qk+CqE+VUlDwwHbbObH+9ltW/RmuNk6+QVTedz2m/LYfiuF9co7AFJwE
	 sjrkuOfRO38+K7HcQrICBAwdPPqSWw81opUhQAieZFdKhLDYrT6ksUVuCvctpIzPGG
	 5IfV2bo/AIGZF92z/NIw2/tSYbEzpTKjlj5R/IpCOGOCq9t1qLgWWrxzM1Ldm3iL6v
	 jl4JL0l0pT78R+g4k6uEp1SAko5fY5xHs148DGpmxVJocVPvD8ORDyvyCDVv0yKLOp
	 0BGiObxQ1YUEMDTuDs/OR2Xrm+87BYRn1BsklV+azupKzmP8Z1i0K9CmVfX9sZIjIF
	 wvV04uPKt3MdQ==
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
Subject: [PATCH RESEND v2 12/51] powerpc/rtas: consume the whole write to /proc/powerpc/rtas/progress
Date: Wed,  4 Nov 2026 20:18:55 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-12-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1217; i=brauner@kernel.org; h=from:subject:message-id; bh=uNEn+pHXbIRRMkqtNF6NnFXDW3eMy9Pk3SJ7wJuNwck=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9brzZHzRlctZde+1Go+8eGv7b1+cVSZ7+f//NhYzz+ 8+/DW/t7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhI5ROG/2mHUo8Ur0zzZ3Z9 kx7D/2mua/jtI8eaYjr1fyTPTo02WcfIcOywWBSj5altb2eddZvFnrJ1ZrTjumSG/rNnerMtg50 vcgMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: do6thsj58biuc93hkjdkra9m3mu7ajtf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 279471C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793819950-53564
X-HE-Meta: U2FsdGVkX194GSQrIuSvt69oyfP+WkRbY2nLA+3JQEd046LDuEdq0uUsHUSNrpnrbB5sgWBTnTi2xAqENXHJGEU4+wM8TjH364eGG3+aQ5onx0lvFtVxuoYTA8y39bqmZW5zdBkCZ+thtsUPl6gZ3hj+JKoZ/AS2u8G4no8z0oQ7RXx/98pKDoZiHPpdzAQd8Bi32r87gqdO1N93GBtmWHY4Z3uhEmeazZFBfKp7XXkHm6OMxDf9vBznoEq7f4TrRaiD9M+IzdNfehm7XR7S6CqlOQEJbMoKB6tCxLLcWapkBhqh934Fyfo5wu05qTm6fZP/vEEt+H9N6u8gUXWG7wV8D70GODgzGJuMwDtdPi+AiX5QcoccIBq91Gf5X25tR87ZJhldjP4SmSP8KNBiqIhHTKwHM51S3DSoAj9MlDL3UW3CQJGTDccL/C2Sls2SMUS+sgsN2LwNBzhnUH0M2l9PMHUtySDL8VU/MuL2BC9f7s7aKCZETy92M61/2ro05ig7Sl9/vIbt5btLlhwqaczLQl94v+yf9uZCtlt9b/UC261euVrvWjoduw6imKR3sQZ61fZgy/pXsZA4zz8meVqBbDtUwrZXEv0pZZQ4Q6zp9VnEoLr6qZHWhrFAH1TL1uqBSibVyJuQzxxQV+SivQKIgQhG3b3WrsrPKnm+wnGU7g4wUh1S4ajZ7pChAUS/2QLTw7aRQwcgV9/jbXM/+WNAvk+PVcRFdY3vvpJuYGRN4rgGhmvtSWzXjrqkx4PCgla4iGccRi0+oH/qYOW7PJWMkdqBxQFfmPKjsBagw5hLAMWlbweJJFoEo6CJmcQZrrf4UtKK3oXKmYClMyhsdTQL7WdPUMQjPhqq6kyiQMeHtSVmiu5Ti/cBFCX4zx1GdgG49m7R/97R0Mm/qEaxqLIK6xZxQfYEjr/AV24xq/U6ysk+D8FLymzT1ut3o0HBntEhWpiRBOQBntGjZGV
 SGeBDX4q
 gXSISsChyyLqQYJ2lG8Xv5769cDAsFCFHXuiHSF3Wt2YC7nZH9aVUqrxjDtw/yRDYy2AFzwRK9HifXp6+vkOFcSAP0Ozw7Vj2dOcDyxOz1Sxg1ujUHSMV5TKinUvzjsDRRn/us8yPht2036A1yIPrpFFMjYPHLyM0+/Q/2okKUPfRNubEW5CORipNU3UpaKh4dGg6IpzTEEh6IX6DTQrdBCC8jy640TTIqPhqyxwBnmR4KrC1GfZRRvud3xhr7/lks8U6gmFeTL5NrQV/z6r2qvoTwNOHe2UL+VBhgv/K5qlyHT4TWAg3XIiEUsjng9tWMPcGFwsWaAi4e/9FqIOb5acfD7scTa3mhas329haVNHrvz7+PciVU9Pfaj17V3HohZtBMZWufz3G7mlAiExQIazLyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ppc_rtas_progress_write() shows the first 255 bytes of a write and
returns that many, so a writer that loops until everything is written
shows the rest as a second message. Return the whole count, the rest is
ignored.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/rtas-proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/rtas-proc.c b/arch/powerpc/kernel/rtas-proc.c
index f38df72e64b8..89b165986851 100644
--- a/arch/powerpc/kernel/rtas-proc.c
+++ b/arch/powerpc/kernel/rtas-proc.c
@@ -311,6 +311,7 @@ static int ppc_rtas_poweron_show(struct seq_file *m, void *v)
 static ssize_t ppc_rtas_progress_write(struct file *file,
 		const char __user *buf, size_t count, loff_t *ppos)
 {
+	size_t len = count;
 	unsigned long hex;
 
 	if (count >= MAX_LINELENGTH)
@@ -324,7 +325,7 @@ static ssize_t ppc_rtas_progress_write(struct file *file,
 	hex = simple_strtoul(progress_led, NULL, 10);
 
 	rtas_progress ((char *)progress_led, hex);
-	return count;
+	return len;
 
 	/* clear the line */
 	/* rtas_progress("                   ", 0xffff);*/

-- 
2.53.0


