Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD1E7607F29F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oLDqIOTw
Received: by kanga.kvack.org (Postfix)
	id F35256B05E1; Wed,  4 Nov 2026 14:38:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96656B05EA; Wed,  4 Nov 2026 14:38:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60036B05EB; Wed,  4 Nov 2026 14:38:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADAC16B05E1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:38:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 485D4C06B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:38:07 +0000 (UTC)
X-FDA: 85398447414.23.7D38CD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 73F30A0003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:38:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLDqIOTw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K/nPdp0KTrkO/JWfX0DeaffmMq6r1stKUZ+oHzzOxP0=;
	b=p6tIisSByoLFmibK2DIOeQA5ntLUIKNoG6O6weenWzscOR4ZcjTmwKu17Cb5cWpKKn/Uxj
	lUCZzK3u6szfBrB9WxcGiXWaZ6Fi4JPRkGI54mWlYcNNRhNPHf4T9xEfRZQYVXkCS4uoZc
	DPaJmZzorU9CXPBXNEPVlyCTSgYqPPk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLDqIOTw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821085;
	b=LgSWmoyJAdtOGcoc7ucXEWMAty0L5YROvqJW20N9gcj/pUpLLGVJ6EhiA1KLTeMmvKA7Oq
	73U4IUjsBhkclCrtWf3exc9hGlFLvYxsKL5IKTH9Xh7pnsrgane8kh6b2sAViYkzjrRAO2
	IVGwA4duPHzbNBHY+1q9zSy2/YTjE+0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C691C42E5D;
	Wed,  4 Nov 2026 19:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9BF1F00A1B;
	Wed,  4 Nov 2026 19:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821084;
	bh=K/nPdp0KTrkO/JWfX0DeaffmMq6r1stKUZ+oHzzOxP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLDqIOTwTl44qDXUKo0I6FzsXq0+ba0WjB4YCiCZU9JLqh15F/mdEZNy1ACYE+I0B
	 qPq4Ssz+iK/J+eJu6nff/NkdfEp6rYdZwfCVKcczyKz5fHXjpvVlG/Qm/dEw9ZL0xG
	 8PXHN37KmNVPmN5T23ck2GcUncr5vJ52nd5OFcXFUE5Goto+9up/68B7m4SIC6mV83
	 dUnBRd6UMVtOXc059f+OnYX0WXgqO/Uzy4tsZ8wr2OaUSvl2vGEki/eN5mj7meJO8a
	 M72qqDynVfbDFqAmqr+C62uIaJhArxnrmC/9rNVTKL6uBLhc9SJ6BYF+yeJf+SxLKs
	 ki60VRKb9D3jg==
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
Subject: [PATCH RESEND v2 09/23] powerpc/procfs: let procfs copy out reads of /proc/powerpc/systemcfg
Date: Wed,  4 Nov 2026 20:37:50 +0100
Message-ID: <20261104-work-procfs-arch-v2-9-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1293; i=brauner@kernel.org; h=from:subject:message-id; bh=BKyq5EW+jipwXgvVj6hm7sFkYOn+uIZEAZe7arc6MQo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vjOI7W5OU2Ecf0JRpsD2T2N0rxx3fUCk8WEDn860 LbzeX1YRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwERWv2T4Z/np554211z5HPtN Ea8e5coKrXxtW8d48eZXNxb/m5d+8jD8T260OtJsUDiLw3pdFscpPeXZpb3vZ9Y1ll1xmP9kwnc DJgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 73F30A0003
X-Stat-Signature: p1x9rsi3xci8etr59swhs14i6ynce4fx
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821085-371807
X-HE-Meta: U2FsdGVkX1/2p66LjYUlOq/ILmRNu0RCLCMNucAXsVC8wsLoR6DJ0g42Wy4CTO8Dhy1/N8VihA6I6cguXrwniUpu7ss1ZzN2I5KYlRqI6BcHUlkrIvDDx1m6mKTRYIQT52nxrCyHra7K44RKuG4gJVal6aMd8F+/Bw2dXdk2welz7Szi+26HbKdywX5NwtrmgLf+2ZabgVzzFkZhx6SiMJbQPZOOfYVSPh+h/3Vs3d7wII16VuFpN0toH9DpE62bN5q4gvlkht0CTl6gRgQ8mMiu8Yxh9pfcYa2a2HrlNzCtH54T8jLViPqnwCrGtpAP/yRUbgPbZuGHIISgBEMNxh78qGlJ2cjclXdKwYsgngptecg0unzfiUyFpML/Z8ZaR3gXZA+8XRbKNfS5sDTbxI3PcGkdGbVxUoGaHvWrZjF9kMH/4Or72LJ1kLjjNypO0VAooYnbXi1l0mYEtc5rLkM6i70qYI2OMAUD76SFW2Gs3H72+g2Q/3ZQ9JoRzrdzApke8KoLyzxmEET+NJavRnkbqn7rxj4nNxqahIiiQYnVnjhBY4LBxGAuiliwXdXmHy69FZglx2nrFCoY3DwxcQ8TjwXkwD+QzzzV8c+qEhD1L6riNiN5kwo+9Y/IUYaYo4Kzcyz0q0Kr/qRHDkUs204bL55LxTAcvztXhzNdFgyqjzsDv1zN1UqTUawKCTDHB2s13SnaXd64PamHjXVZyj4JsgsejCw7Grj11To5vRQ39swyWIcbmGCUxQ6hS7azqP3YdCeq9tS5FHr2F/YfEDqCuulp9AvI/EZb78oNSiLd5OjyROaUF9yrZ9pmCdcLWWkoM+6CV9NWLnZjMy6MgIChTnu/loWE9cG8FLRH/zzLlDpdu9oSeB+tsKWsNWWm3fkhzsE9qjauQkgSNekpPYVQ9bCg3ysiZ+8Kj+a5wWhXR0hHkII9V3OqTPP2c3bJnOCIKDtOueccYvj+WPr
 qwnL3yex
 0vdBuSuhQog+G8B1uYcq9rH0Z3TH39tSsLLihlF5dkZTv6K16SJe9PhXTrDRwsEvxyplXO4prf9pzCXMOV1ffg7U+urYYqvXKMtEr0DqkW3SJGq1Cc0iNVBKg+rUgl8/dzmvdFR0kWn/hpDtOIs6aO5dGJwg0A91Pqoj59Nv3Aa44isPPBa/P6PfhpNIUoWciwBbgme78G2jJ5mCWBG8ALFIQqXGJ9G7inx8XXBn6I9NLtrIwrBJS9LgCjNrOYEcu5aZRu18f7X/prt2OJnsmQ/jJhGMGkwnB25KH6vSD4ToDGwAUAyaLcPWn13DMjLDARiqFDi98z71ITXovUyK6Vj9oBAyDoYJ2zQnCe4g59G7skpmJ58jcs8KowITlPWf09btEAzKsOW4HAlQzJPhbdWRJUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/proc_powerpc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/proc_powerpc.c b/arch/powerpc/kernel/proc_powerpc.c
index d083b4517065..46bc914d74b9 100644
--- a/arch/powerpc/kernel/proc_powerpc.c
+++ b/arch/powerpc/kernel/proc_powerpc.c
@@ -24,10 +24,10 @@ static loff_t page_map_seek(struct file *file, loff_t off, int whence)
 	return fixed_size_llseek(file, off, whence, PAGE_SIZE);
 }
 
-static ssize_t page_map_read( struct file *file, char __user *buf, size_t nbytes,
+static ssize_t page_map_read( struct file *file, char *buf, size_t nbytes,
 			      loff_t *ppos)
 {
-	return simple_read_from_buffer(buf, nbytes, ppos,
+	return memory_read_from_buffer(buf, nbytes, ppos,
 			pde_data(file_inode(file)), PAGE_SIZE);
 }
 
@@ -43,7 +43,7 @@ static int page_map_mmap( struct file *file, struct vm_area_struct *vma )
 
 static const struct proc_ops page_map_proc_ops = {
 	.proc_lseek	= page_map_seek,
-	.proc_read	= page_map_read,
+	.proc_read_buf	= page_map_read,
 	.proc_mmap	= page_map_mmap,
 };
 

-- 
2.53.0


