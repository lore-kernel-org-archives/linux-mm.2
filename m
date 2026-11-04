Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81DC60700F9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iXWQB5YV
Received: by kanga.kvack.org (Postfix)
	id BFBF56B05CA; Wed,  4 Nov 2026 12:31:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BACAA6B05CB; Wed,  4 Nov 2026 12:31:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75BD6B05CC; Wed,  4 Nov 2026 12:31:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 807BB6B05CA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:31:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08254120766
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:31:12 +0000 (UTC)
X-FDA: 85398127584.18.8E03F00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 26A6C40006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:31:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iXWQB5YV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793813470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88D9snc5Fvfzc1+bIGylCXCzBagXIGxBtzK0BL7vNTc=;
	b=krwDoFcSf4PULRqGiRPYd5g0hKhw8WAxDkdxUFwGjeNmglM8EWXKBI0hC1DX7kWlpvLEep
	TZZDqI1nhZ/IXRkY5b2Z4hO5jGEpAb0aYmyQHjdA7jxvrynzwTo7w4oeq+llVe2neAxSZh
	5LY4zTl/lFxIsuSLZKc9agRJfvMpSj4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793813470;
	b=SGS9H0vFQou2hxISHog0ozpggBHerJHw+HUtDt5qW7MAlEqtOLoLa0+UvLMZvExvV515Ko
	4W0B8yTuAGYtuVvwzp5/V+JirB6N1A13JP8hpPPuw751WCFe8hdyYdvL0Mr7n4+N7qA2UR
	qHBcuOTwz66xv1P61y6BO+wK8eDQ25U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iXWQB5YV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80AB641748;
	Wed,  4 Nov 2026 17:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B1D1F00A1A;
	Wed,  4 Nov 2026 17:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793813469;
	bh=88D9snc5Fvfzc1+bIGylCXCzBagXIGxBtzK0BL7vNTc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iXWQB5YV7Kg3RUIa93AFETN1SWavnlv7A2+KZO2N+8yOFr8Nxzd0awnAdzvrIJxvb
	 iwsd7/OXYpIIPoZK/zUDKbVBITgvtCbvRQFx8uTJc/yHlxoEsUDPjmLWXFVoYRwB+8
	 bO30Hh/TGyjWLlo74Zlkba+soU5l3Xz8vC5ijD1rLCYQM6eOaon/FPI6bnSWWK8jej
	 tu9UAUvRhODWIvMSMgtdBEbC7EPtC8P3EjAe6KdJiEatnSukLFtVejwpJye5oyaiRy
	 wq31IKuon20SWlj10PyNweaP+Lu1uhJgSBnAqLcp9bykPHQNRISX1eYd4dr2KLd0HB
	 SFAF9fcqUvWgQ==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 04 Nov 2026 18:27:28 +0100
Subject: [PATCH v2 11/51] sparc: led: consume the whole write
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-work-procfs-bugfixes-v2-11-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1161; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5p0zMz40BbKdivFQo1NNbyIz4tkvEi3yC5tXL4aXaeU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zmaz+l255/dcMbeVTrFanCknSsvkc1YVB3m43Lw5N
 drx0iaxjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkI32BkeHvU6KWe6gWDSokM
 AXPh+UdezXsoZMqyb+L5Puufyec6zBkZ1nYtn1J1+eNm5X8arkoP+O5vXXg4NDqzfr7dM//7HjX
 /+QA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: nfoxjzj7hisbik68713fzjjp8umuytpb
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 26A6C40006
X-HE-Tag: 1793813470-270977
X-HE-Meta: U2FsdGVkX1/BKqGt+tYTstrWK+HQJ54ljA7b6opDUWN4Krds7bSzzskArL7+aE/BlMTasCeZbikmbR66g89Rxlr1w0hWIKNuvtWoaY3Cz2T9ZXuK4JVuWLjI2H3bW3MDYghoMPr+xbgxqvT83YNTRAyKaVjmnIj/UJ6HEgYzOopeBm66iFWc7gdkwpf+LGYU9PSrEiQ/n/6ClsdoRJO83nIPVL6tsrvcURg0QBDeGDDCs0SyVp5E71g8WnL8kLrLJkEPyEttfhe1wc7+RAqwF2DVsdb9/gHUFHTCQMxzVY4inFrA/1gpe2Mqv4VB7SxcOudknhCW97LwU3RJUdMv88HcQiTiBh6pqyqqJfRwc7y1LUquCW1VqL1C1WtrXB2bPunh+Y+zgqTBLYKWt0YjauZNnkAvFW7tTQWZwhV3cPicupjkoJs1TkFN5Yei2F99lDaTu+wwh0uPCJZdEub/jX2x8PQjeWWInntXrJAF1x13Qd6DnQBRC/z3ZIn2w4RciAxiObylOlH3GsAJuVWIPw0sQgVlhr+AYDISouBuZ25HTOoO8la9eW1qPL42JBZ5wyFvBrLk/q8gjV9GFXp053Ne/ZBVbnSPFdjdz/pzSxqcSVF861+DDUjoN+l/ru7grh7ZfjgeqUlChGb/HUvtPKVKvC7k/1yQdaE5+4FqSWqLW3pB3QLQbrp1L7t9VVWsULSM/Cm3Q03JVHgrl9lgs76kXvoW78fPywUlMJ7qEVX2EO30+MhzKotXdpj64QNzQ4yPhF1VNSrsASj1UeLWz3bUtUZ0zb+EPx2jHkKRUZY5K8sJWm98bdCMwEVCynUpnnlnLfu41Q7t7RVfI30fg3JtSe39EBezJ6BdJVvJa/ZgO1KDcWKyOoZTBUSDMB4Jjz5mx0ItUF0/pGmxpMob3RV1HrRq5MnCpbsrUvWHFFj7iTEDj5w22l99WrCbi8PZs/5PMS+/cNLBDj5eu7V
 G7GEKPHx
 kibczdNjanScxvXH/Sb5Gpsy3AxNwDq+Jbz8ckVlkbkL96cUt0VFyaGUfyeq9W3C5wWxw1f2gfsqhT3Va6fN5OzT1BcRf5LnUeGbscv0HhOe6c/s9sfpa/e7eCmX+XEmzT2ChmPOuB0h3ETMPy46EFR3Vpz/U6Vq4BHAF19Y+XB/qPoZ0gKKU2BvUs/WposdncX3e2t+f5lYriAgcQvzVKtE8s12UzPnh7xk/TEMD/8rFik7nA2zgEdMjE0+0QAGjrtMkDUKolqR08ZRhlYxYS8qk1srxkAT1KtL5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

led_proc_write() looks at the first eight bytes of a write and returns
that many, so a writer that loops until everything is written, stdio
does, sends the rest as a second command. That one is unknown and
switches the LED off. Return the whole count, the rest is ignored.

Fixes: ee1858d3122d ("[SPARC]: Add sun4m LED driver.")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/sparc/kernel/led.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/led.c b/arch/sparc/kernel/led.c
index 9b53ac1fe533..a1478de9fe5d 100644
--- a/arch/sparc/kernel/led.c
+++ b/arch/sparc/kernel/led.c
@@ -68,6 +68,7 @@ static int led_proc_open(struct inode *inode, struct file *file)
 static ssize_t led_proc_write(struct file *file, const char __user *buffer,
 			      size_t count, loff_t *ppos)
 {
+	size_t len = count;
 	char *buf = NULL;
 
 	if (count > LED_MAX_LENGTH)
@@ -102,7 +103,7 @@ static ssize_t led_proc_write(struct file *file, const char __user *buffer,
 
 	kfree(buf);
 
-	return count;
+	return len;
 }
 
 static const struct proc_ops led_proc_ops = {

-- 
2.53.0


