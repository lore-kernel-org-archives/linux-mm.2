Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A36E6084437
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bEpjay2C
Received: by kanga.kvack.org (Postfix)
	id AEC3E6B0628; Mon,  2 Nov 2026 10:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4EE6B0629; Mon,  2 Nov 2026 10:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00E46B062A; Mon,  2 Nov 2026 10:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82DA76B0628
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:29:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DD4B160171
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:29:26 +0000 (UTC)
X-FDA: 85390563132.22.A8AF406
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5EA5540002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:29:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bEpjay2C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhlUxShJ2PAnaFYEGZj/acNyvX4jU2/JMVjl8Ac9zMQ=;
	b=PHBhTnVb6tkeSyx9FFBPW2mCvS1Pb8H7HbPF2UOdjFC8vW3JPMJUYi8im3lGElEOqvptws
	kIpfX3atHn2BGqG9qonEMOTCK9s0W4cGVjTHnhdHZ4C4fc+3+zbuc6V+zxRG/CNSm0rPsY
	Is3QdqCQc3Jhu3jSVjtwJjrlMV4B7aY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bEpjay2C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633364;
	b=IAyacKwOa4Fyygh8iTnB68zcyT85GXposXbYb7Rd0b0CKivYataMJ0PID4YTXcFndwg+D7
	mIZVkFixmQ5Z2xFiwCekpmjhJ6wzy7KBFB0tdGPcg8Vk0raYqRp5efv93pECLhxBkqwndW
	x7nJeOnGSKlA0Qs4NHLouAf6y7K3t6Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F221760A60;
	Mon,  2 Nov 2026 15:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8429A1F00A17;
	Mon,  2 Nov 2026 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633363;
	bh=jhlUxShJ2PAnaFYEGZj/acNyvX4jU2/JMVjl8Ac9zMQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bEpjay2CbnfGJBHly978mQVKfOK9NOWk818hauqaL6bJ1R9S6y4K750VMrYinkjRZ
	 UJYMQ5lPJt9EqbCkMQJHIEzuAVhA0uBBsY3SQ52htvtKFFvqoAARzwAqIQhqo0yDks
	 27SjH2upRcJP3c6/Pe085axMXe6Pi9Arnrh7pZAVs3x5e/XE9jaVeyQ0qsr8Qkyfkq
	 yc1WiGpYMVgd0fNpip1lkFOhbQga6TG73wT6BHy5m4PYoCpETxzGPsM53biago4TWh
	 aXiE38bqIKzr3MTvUNm540DqItq0eT865nVxWPsH4BWXKPHJwP7owlsDAuHhhrBWTO
	 HoE9gxpbWNrtQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:36 +0100
Subject: [PATCH RFC 26/27] kernel/configs: let procfs copy out reads of
 /proc/config.gz
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-26-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
In-Reply-To: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1297; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IZ5Jauw3jeCJbbKJV7DoExBPgNJSSia5o6c0KJSA0oY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG68W/dM+SnW3p+PHz9Nr9SdtujbqdmGuR8kWUNv6
 Ra5lWq6dpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk9kRGhpbCF9v7uDqqLS5v
 Fwy4tydWj4HvRde9J5lu+/I9+Jmacxj+ijqWtebXBD78UxAm+sZz3pqzV2uF96jusDvBcuLcpOk
 H+QA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 5EA5540002
X-Stat-Signature: uczip8q1bkr6bx1cit4opgkkq5mkkjdm
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633364-332483
X-HE-Meta: U2FsdGVkX1+VWC5UwwN/foLGXwJbZETDCiORPzGQKYsoi1ULEXhTrcrnnTJfQnYWEfHs+HIPA+vNl9Pmcq/gLOITcv6ZfbEAEHHm90QLbW7f8YynpfW81LZE6xSOeC4bXNMSuJ9cM9uHos993a2dFurfpzJBD91VrJ4UZiQMnp2zdq9WK3pwCfDzWhpqsS8Qwc44nWyjvTUzVuR9Nhk6GgyML1PSW4042880y97OHvAjjAahR80yuGH+Z0MLul/Sxvj1myTSbQWcrc2kSKhgQjWybOmCTMMsWaek+pufEGDo1IvM/E8A6J3XHXGKJJ7+MQxHfVOLCbL+g5OKJHFgmVDk0aeTv7SPtYjzNZj/Q4tzUC37y+T0Cz9ijQA5FA3rfgfENaTuZEqHp3J6V65J5JBdoyAfSYHT1N1JfknSZKssYrasweUW3Z3u5XOx9Jhh11jKcSFUCbtFWXuNHQiFkmRd8AMQHtc54WYpWXuI+g4+WbMTOkCLZ+GAOBUcf0gPfxqcUpMm1S1a28C8FhRorv5EkMcO1z50/MXUne9PGwQ1T4NiuqsqSQIahDGTxFjcehWnMdfT6CVOGiio9TWbe7hEflarLtgA63ravx1/t1xRin1Zt3FTb6KbQyoJngrpORNsJw0Keq6W6LJMdvutYWL6bWBZQG8UUJobRnVYr279W8miWacoHT6glXj+kk0nZjLktB/xuiAHS07rCNIZ2iWjul93EtsCul8cV6q2ibTJeUiLb9I3eIj4qfGTg7wxfhCb8NDrjx2kD6WQEC0Cki7koSNqealk/ZJ6ZwSiDNCFm5KPev5JjXfehhBpCDsYG+UEouKdUZsrQGNTP5+9MEbmNCXU2oj8zjhN3kUbF1Xby3GSxlmrLUBF4H+4i6yIJ7F0/0TKLHr3jalTLuwxfS5pwhwQa6PgXHuOzgbWZKLJUJupWRvP6u8Yvg7eHG3jRl8o+fvwXCAqKJjVRLZ
 dqEDRiiz
 Ks6vglqCT/tL1qspAI9knXLaJqjnKdcysPwY6n9lj1XzEsyOur8JqsPWjMoXbsev6BkzAx9HBns9kMSG12MPF1RRz80n46GQ8bxDkCBafe191qqPvy7skjLFdVhQzsPUX7S0gD40IUjjaz/twPLPBH40NtR9fBZubtx87/Yv4B3EfOD1KuD2TloEK5gWXxJeJDnyBqYv2BDam4u8bKjqqOniiIboVvTiVA2WHpRNcjoTVArf8KGrD2nqTzA07YuvCyKJuDyA9vhg5rsxrr1Q5sIeCaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry. Unloading configs.ko then no longer waits
for a reader that faults on its buffer. /proc/config.gz asks for
PROC_ENTRY_FULL_READS so that reading all of it at once keeps working.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/configs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/configs.c b/kernel/configs.c
index a28c79c5f713..05b12c440168 100644
--- a/kernel/configs.c
+++ b/kernel/configs.c
@@ -38,17 +38,18 @@ extern char kernel_config_data;
 extern char kernel_config_data_end;
 
 static ssize_t
-ikconfig_read_current(struct file *file, char __user *buf,
+ikconfig_read_current(struct file *file, char *buf,
 		      size_t len, loff_t * offset)
 {
-	return simple_read_from_buffer(buf, len, offset,
+	return memory_read_from_buffer(buf, len, offset,
 				       &kernel_config_data,
 				       &kernel_config_data_end -
 				       &kernel_config_data);
 }
 
 static const struct proc_ops config_gz_proc_ops = {
-	.proc_read	= ikconfig_read_current,
+	.proc_flags	= PROC_ENTRY_FULL_READS,
+	.proc_read_buf	= ikconfig_read_current,
 	.proc_lseek	= default_llseek,
 };
 

-- 
2.53.0


