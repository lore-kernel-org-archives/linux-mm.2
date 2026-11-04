Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8959606A331
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IUyU/T8J
Received: by kanga.kvack.org (Postfix)
	id 07FA86B00EF; Wed,  4 Nov 2026 12:46:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030656B05B1; Wed,  4 Nov 2026 12:46:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E64406B05B2; Wed,  4 Nov 2026 12:46:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C488C6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:46:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55F6A1A06AF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:46:23 +0000 (UTC)
X-FDA: 85398165846.16.034319C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 68B221A0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:46:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IUyU/T8J";
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814381;
	b=SOuJx6BNhRfCqP8/ZhYTyPM2BzNu+tuAeFv5sN2LCw724mntYd/ml8Gtpf7e+MgzJ6KDs6
	/QaBymNtJtvjCo72ERoD0Rxs338d77V2PRxaWL9iICnBkOF7OENZyjt7b8nkafRNB+5bIW
	0KfBaxWi64J7tykZpy4SJkc6w9rb5Vo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IUyU/T8J";
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdnthwMs9LvqnLJy6kPpeiwqrlhi6ADC7izliWiN2IE=;
	b=U2wLqvGNJqL6rg+pkMIz/SGlqxnx6gnenttp2Fhes8VtZCipBNYa2c9zyRoCAx3bHTxfmK
	l2H3JPDLyQYmKv4O7IooGFZi51V8ABFS8xAffyZ71EuTZNCuwpGHEKAIsx1LP+kc9I3VVw
	VvxGoO3xh2NQIG/fhzyqWSkQiaGOv3s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A04443C8C;
	Wed,  4 Nov 2026 17:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0831F00919;
	Wed,  4 Nov 2026 17:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814380;
	bh=mdnthwMs9LvqnLJy6kPpeiwqrlhi6ADC7izliWiN2IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUyU/T8JanEUeWb8OLvnBOF7mcsDaYX0yn50MMyhywpzR+Xd73lI68b+Z0EjhqK7z
	 bkEkttde6fJvRPVGGA2MZkA0GbASE8FC1nT+84ODvZFzTbBCjYw8IWtatNsrtMoyrH
	 KXUF53QFRfDUagwA56DH/VxXp+wT5/pJfjV3gzlKef2KUiN1HSYpnfrnWdn1nbnNKf
	 O/7xCRN+TNpny8Le4H87j8uBb2tQPjPggOwQvaiPHTFrUkQgsfx/jAR3vQ6vrxrWe7
	 JaBxG35YdcKRtCdLtOxgMygQkmiRV8AYLKhLlP/iKh/wi1njtDUmOUna6ss0EP8ecg
	 vvOH1vOWWni9g==
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
Subject: [PATCH v2 12/51] powerpc/rtas: consume the whole write to /proc/powerpc/rtas/progress
Date: Wed,  4 Nov 2026 18:45:55 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-12-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1217; i=brauner@kernel.org; h=from:subject:message-id; bh=uNEn+pHXbIRRMkqtNF6NnFXDW3eMy9Pk3SJ7wJuNwck=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zjsreObfmrOX1obn3tw0N6WpU3RvwOStvn2i0U5yp rEGLx+odpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk8Agjw1Z5rj/rEq/Xb9Zi nJlScTdg1ruoGZHGhW11TVmdwqnc0xgZOpo+NM6qs41edOyOUPc3kzd2G/9GyxwJqc6SeXR2q9J OfgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 68B221A0002
X-Stat-Signature: gj9zy7ue87gnru5x96mzb13pha45t447
X-Rspam-User: 
X-HE-Tag: 1793814381-193282
X-HE-Meta: U2FsdGVkX1+jMZHTUVV35k7YuO0hWZpi4EQQwBZASogSGbrgZH7ZHW1/1pZ5OFwibH+lK+1NHFjTfZHEwjb2/Ax8iCcRsWgsllQHP4jCHEj+i9HzqD89nVoMnlI8YX4vktXDdWN6TvNaG3i2Z9ZMxILIUcDVOvKLUWD6Ijv9OBKvvjaUsB9NG0siILLMWjD+7bkZy1+Yz4xOe5ycZt8EQom+hoTnPNnO/T0JLp9+Mv0UXDbjti1OcYgK+gweoX9B4BrELzCgBxdpFmMxcpyaX+FKq0GwNn1/UgvogM7Pdw0rqBcVUFGtW1xmHXmZcCyT+Iw0kckLmtyF4wD3muAFatleN7m5kORdxXChXniWAdWMeUWj87Q9/hWa7G5vhuJjodfYgOKG5UXZK14rzOH9nnLSrMmthSWBmoH0m6+lPTkjoERhlt2y1fALMkkhH65slmtSs4IQSAV59OpJGtWbRB+XLKvqk2Js96dlrUp26hSQVAIngWsi5mhHT2z6bE7kFrRRjW7FU7NfIARRyrICBBk6Ol+lQexqwH0/CAuo6LYPlBamCAP/LG9Uq7wB9lgq789gjNFDlJnKeZxuwuiKsJn8HdXqgAjJxBWsWqFxkWEhkyJlh0Fjgb89Q9vpUTUaSFQm+BcYKjEZz+muSnUlNY/uZ/c/woSrZbU8FZNEzEeHxlHL42N6sNOPrnNjTqaVFt4NBe41Bt3mqDfq3kYA3Ml+xPdVkd/hL8xGfvyKVZwOiQgGM03eewjwvmQtvygcHxNW9YqVA7orfXX1unO6m7Vap/tREJvPJaZPoQWKIHY9uJXg5Aa6jGeuj+mx0AlQRUH1/5ywjpvA8xKAcwAPJHAyUkW1NfYI4QlqykuKfaLVtORuz+/lMOTRy3qkJ2KRSSulqgUo7PQu2hpGW1jvHS4xmVlX5zwxEL3K0ZKTucNE3MNtvidi7efwlQ50y+GzNdHXa2x3+ijhdSk3eSF
 BxHKcDsK
 Y/5qfgKWZciIFjUPPrgQcFpBHOKPAodGaRABCHnPdHiNco2k8KU5LUWEwuj3QUl5U5IfLk0BKjuSgjh0RicR8Nr6sp5qApYJO1SFBAeLAbC1UI93XayGFRNHGOlOfoL9t+SL8W1LPDrdowjNsA6gV6L3JPVY47unUu3Tf4IiRAhtJW0XmrmhX1YWRlH2gsTv8wXG9NG2JKs+suJjxS2PNKK6y5PQHN15PGE+I2R/Tx0n8kkYrc0iRVLX15HBiRZKoENGIVn7ucYLz2ns4qRt4Gf6M+ACuK1KWQEep
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


