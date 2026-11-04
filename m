Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E33A606C922
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GmEE1dbl
Received: by kanga.kvack.org (Postfix)
	id 748BF6B05BD; Wed,  4 Nov 2026 14:18:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9006B05BE; Wed,  4 Nov 2026 14:18:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB756B05BF; Wed,  4 Nov 2026 14:18:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3456B05BD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:18:58 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC2BA40825
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:18:57 +0000 (UTC)
X-FDA: 85398399114.09.AEA479E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 00C151A000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:18:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GmEE1dbl;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88D9snc5Fvfzc1+bIGylCXCzBagXIGxBtzK0BL7vNTc=;
	b=lW0puPsVne610plShF4RXyLYWULgTP3ZeMW6G+IrL4p2WEiiCncFGejnVmmcw0G+o3Wn2k
	uGGbE1fZTCAP8LSeBaRsHKybEljKL5Er2Ia5IggFjCUO7/NhCvsf1lvJaHgVgAVFkVS7Gw
	+B+cfFUXvJqPe2yYLRuPmCAYLEnbmFo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GmEE1dbl;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819936;
	b=p95w6h82OZypEOoVdXjAoOSaJiBRfuOEzC6y1TLx7agiMdYMT3ivXpYR/MxWm1aESa6een
	+lNcDjeE5IwpPEkuFl+ZQvANYnBtC8jNooAd13PHm+tj1r8XVJpkXua4Afx3VipCtCrlZp
	fZsZa7mdfUGRAltxh7C7xxS1c62g0eo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 540EC43AE6;
	Wed,  4 Nov 2026 19:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB631F000C1;
	Wed,  4 Nov 2026 19:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819935;
	bh=88D9snc5Fvfzc1+bIGylCXCzBagXIGxBtzK0BL7vNTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GmEE1dblrL6P3slUDpoeGQBfKRlZceqbttyL3CdBYJ2HAmZ9lajl7o6aomohjTG+O
	 JTa2xT0UeQwIgbWO0as8ILC2qonsH/MA+HbfcPcLDu6enbEF3xp9x5MarktZI1cLNN
	 p49gpXsJRwhljLb1NoANyo0ZebStjoK1MQAOZ8SsuOmEWt9/Va7qy18DmNx/CKuVDD
	 F61rqLrBCLbspjHBFEQrO4v5WSYQC3TxQQVgqakQ7sCvVAsMm5tshbmCStW23Fb73C
	 HKw2C65QpNc+TsBCBKm/WrFquDZj8ghfTEOupR23/RjXQvAJZnpFNNP1XldO5G4qvo
	 qTnFbXsGFvmcw==
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
Subject: [PATCH RESEND v2 11/51] sparc: led: consume the whole write
Date: Wed,  4 Nov 2026 20:18:41 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-11-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1161; i=brauner@kernel.org; h=from:subject:message-id; bh=5p0zMz40BbKdivFQo1NNbyIz4tkvEi3yC5tXL4aXaeU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bryxTr/f46JN2aT7fqoMIobterOLr517VZK2/eVbF pMTq1cadJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExk6Q5GhpeRX3yP6jdm/nBn TDpmVrDk42u3AsOCWcVRi54YHnqrX8zIcGmRdthP9Rql7VIfc5K5Jlq/vCTExLioUWxJ93Lnjfk ujAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iaebijepo7tnwci1n4quuexmmefdhf7w
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 00C151A000D
X-HE-Tag: 1793819935-596518
X-HE-Meta: U2FsdGVkX181TDRn6lZqbiTy90HHUkwVQ4Kusm31L3YKwCFWT5cCA/TIpaqDkAOeVgVorGYdJOhC1B70tq3rLHgAxk2jmIzSrAmtatylwo+zp3SldlRUF6ME3IiGMOWJl3f1PGxtEf0keX5zY499UL2PRbr9CL7GlyCCnB02ezxFoWKN2uBYoz14TXn3MUxf95W3vpr8+J2Tn/zw1z1TnwsbiAtl+y08zqrvs21M6KbSpwULktq/jUsDSWMyRZf160yxQCUdKUf3sT8ymgbvGAxS7q00a4tUjIK8sjNSpihQtGW+LtXCw5c8zGGYwv5AO9zRzg0gfyBHWOiKTwPe/6e9tNdYDsPeWf2AVM1psSAYerWoQ1M8No5x9kbslLbL9BmRSwQG9VQ/ZlhvQ/qE86+k3yA7K59pdRr9suUUPhii97c+LbTOjPsFHyxRFEWbsPYPbj9988yXYxX6qQCKPbiMeIOXcnDIYEiPmhzoLgumV4G0cBCpWT1dlC3H0U73wBEEcrKP+XPzdSp3rtPrlB8huqbPPEwjcwIHvsiYNm3LnXVM10O4WgK4YoV4xhgtqGCGcV3/K1Zhk6NU5N7RLH+td9kgQPh74EeXuCoEHraBiBB5AtuU5qeooxGGu7P0/fJnz2wVYYIaS6ISlaiY0cFT8bHCuBSZFXIlFnuLHMlx2CEHRci4X5AY6iBYIUKDfcTudd9CC7EEFcaXatx9jvSmjtyMVQPeJelFpqyaUXoD/LqanH6FHUJRYx4c6VolkNfZpvMpbXJO3Z6BjBl3VZExRRU3wwMO+CtA/uFVx1rr4VEBYwvPOlgaLK1hIFq9HfcgqTUX7e1a77JFcyRMu9ds1DyOAUcfzSSuKO1cnhm5X/a3EHH4VWT5FrEU9rANBS+qVEewqyqwvNnLzpUfkH7jp9OJJqUnE8r5Kj4okczczE7E0NC6yFHgYfgmXinylqOjBbrVEnKy5eH+Mi6
 buS5JuM9
 GpyZjnlNYc8jQsjLIfWSQoP0b0UKkJDgLC+DUy1ZnchXq2BriQDMDGIjGV8Sr8KRynpYNAyVv3tIjwqfj1c1GuPGHKXMBMqtFFJx4YeNXb/+0d71lnHO0LeYOKkaqyLngmcLcWUXJ5EU0rHDcO9m5qp8fyMRxhvKlXrtnNbEMV7i6H4NY5d9iRFLYN/+EKqUK9nIYSAPKo0Mbnd4DV5GOf1BHWd/PPKokF47OTbS+tq54oCj1HKptAWOGrRLnUPXsuIB218QPuwClJKKCsz/9x8yGY3yemTFU5aCIlRcBRaXVwsKxQ+y2w1VNF1y7Pl7pvPVf93Zzn79ggo5uzYao3WdnRqLvFUa9Hq3Bxwf3QwKVdWiIw06p4YDbNWYEaOsHjGlnF6RXcQ+DzaDjToF8EBWU3e6xepK92/ue
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


