Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75F7560A2633
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KpHzZpnF
Received: by kanga.kvack.org (Postfix)
	id 91B106B05B8; Wed,  4 Nov 2026 14:17:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CB3C6B05B9; Wed,  4 Nov 2026 14:17:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7935B6B05BA; Wed,  4 Nov 2026 14:17:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 57DF86B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:17:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EBD3640489
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:17:30 +0000 (UTC)
X-FDA: 85398395460.24.F33CA2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2857740009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:17:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KpHzZpnF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jP/hayhlpAKZdjJKk3r9BHeVVOYyvJcLU3d1z3kH9u8=;
	b=ccQ4aF18yZBWK26bXdy+icwTRrUf7WiiMG70/CYG2FT8HxiT7B+kOGN5ztTbSdoGeC4UUB
	xcxR8VOtCw9ItZN6uIQ8Di2b9MImVWPQAkywkjGKmMKuD8wIdFpKkOSkYgI5fAg/3qC67c
	f53WGAYjmoB5mC6s5dByK7NxuMDNPCw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KpHzZpnF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819849;
	b=x5BmHI0KX6RnkAbttLucO+mB8VUovImuxzxkYXEQ/5xwRlfRDTU7EuqdQ6Q3sMo8J5GbwE
	/76L3qRBeWF7EfyhGhjpV3VleTsx8SaKBO+9jttOpON5F8LpyB/DNEZqdLC+vUO/0rZQ2+
	innL4S0Jwdg6kV7EGngka4Qx2z2gMtg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A72041388;
	Wed,  4 Nov 2026 19:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C9F1F00A24;
	Wed,  4 Nov 2026 19:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819848;
	bh=jP/hayhlpAKZdjJKk3r9BHeVVOYyvJcLU3d1z3kH9u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KpHzZpnFwT6+C0q0yRCi5k/OA66tRS7eBzT8lt1HaWQE8e8svE3VZCRBnfRHdCzx7
	 71y/CPv6HCeTe9zbap2gT5FJuzj5hekBtO1a4cjxKuetzIxGjHALxdRgkDffBvgqoN
	 /aj76OWmFdznND17QWfa+CPtL2LoFKokFbuci0W4IBDDUUsoZwEUSEMsIoP5ROVtaD
	 UYsfpJY8su6lg+vsurlkAT18SVCFHIc8HLWY3wDZz/GvQ7lhgYrpLIwR5WyV8knPdX
	 rwvwNGe1ypF9HhdxdQGkkPDxlpkOU61C82qjywHhkl5yTgB9ONziIAgGKfFuFYu0iv
	 y/71Zwy9XejIg==
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
Subject: [PATCH RESEND v2 05/51] xtensa: simdisk: remove the proc entry before the disk
Date: Wed,  4 Nov 2026 20:17:14 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-5-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1246; i=brauner@kernel.org; h=from:subject:message-id; bh=f7Qg/00vnZM3tuJ138yAFxD6JPv6/GBN+HDx2x0z8gg=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9brxQmmA/984KHvt9Xz1eFefxl8hqpieb9fosObahV 1Ne5l9gRwkLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwERykxj+u2j/eB40M+7p2v17 /GMmXT/na+Ctz77txmH9Sb+NLH5yrWH4HpzAeT45SPnv5UMnF7jMebDmtMJKXyf/NT8uPWe+O7+ RBwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2857740009
X-Stat-Signature: myp1bcdmz4sqoyxj1mo7317z3t6ph7yp
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793819849-13813
X-HE-Meta: U2FsdGVkX18TJPEco19b1U7tYeJ4jvr3vdUI844/8LWNhqPifsssk9EbRd/BDNeyDpbamXRsUc80gbK0YAoa2jUm5g2apD6BkQdVgiDdjKScsrMzZ3llZ1CayzmgKrlHWRmvk/4Qvuyc2lC3Vr6U4IJ5KIYRaZy9dr9p+cFVsFzysgeZAYvO8OcZAxKXcyF5RLvisDHDz53pCG9O4yUwBiRMwO58K0T5/vl+zrJke+vWG3MqgZbC4YBeoolQ//hoAdZhBZxHTdAtiKQN6H8cpzkuyU06p1dTTiBR1FdZDvcCKTKMAvNcc2LSgpJ4C4f9V6fhJfU6nfDhpK7yMmJ6v0vgNL6ECXJZH5N3H9hi7QgABVZFccyaHIDmd7Ynomi2+gVIoKJTy94CTndLjsd80xkK50xBuf8ApyeSIds/agAW7ZoL4rwytb1uECKw5iF9mNZEks2MdtjM0csHj40qiBdUEQkQ384idTJyx72GVxoVJwecyy/H0RKfp0XMxJJ6MfjI4gG+9NRDwmc7DnHmwoyc0QeFDgmLp9bpfA3pC4+sOHegxsOiGHoG8bU+KjAufaCxJvzjJ2ve95GIXXz6eN9F6q7ZmjY9IG5iqaqxwp+GdSvnFzwF0v1oDX/drxffdC3OB+TIZ4FkqiEeE5VfjZDditnAqOq7pb7xaCFA2p5unIfzIj4ue5PwS6+cADEeK7RpbUomE93sIrMWhQMnD7WxeJjZVpu9tMKI60Y+7ljPIFbtN9r/buq5BWornb9SHlcafgojmHY0WOJMQRiXYJKdmvWPDlVQRcvzbQ8Jq1S6lB0aLwsZJYfu5Y6rCxVl05cgJg0pgNGOaBD2fMGaFBwTMCRTPfKQPMfdQz0afh2++Q43BzkqZwB1vuflClWQ3Ktb/S9KaUQ/P3yjgDioIZqU4ZmQORYbFq5GMMF52e3sbmkP7lM2kSrqJTkrkM7dBCqBvAe2/ZDvMyQiVl2
 V1bnHk/j
 v4y9xlSfxtZ3pVxs7VzStIPoCVAotIO9IGZm0XIQRQb38Az4cUQj+e1RrDWWx9tyq/6TuAp9NY1+qWKl81UUPRp13l2+fxPvxlfxU3B6Hu8VJJQh7mwjucFFMR++yAiKhcqtcj9s2YClvLU+RU4oSfo5uIWOYhGO5vzf7CxmR3TrUqQJ2iji00IYc9cecKiYbLWuntXodIXH1DyKLW+0VsoYB48Qse3Fbb8xPFFcf4fY7FjDd6LYXuGvCbhaRYnm+DskVjs3xkVu6ojxHMqRNq2YjNYyCqdb3Nvq8p4+NTlmy9L8YMhMi35sogGVWjCiFkc2paKlT111xbJYxaRhKuiQq3B6nw+akqYw/q+zEdLu37UUBTtFtzshzrbnQEWx8AZwXO1xQaCn0m44FV3P1iu/3Ea7TavqmHfSA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

simdisk_teardown() frees the gendisk and only then removes
/proc/simdisk/<n>. A write to that entry in between attaches the file
that was written to the disk, and simdisk_attach() sets the capacity of
the gendisk that is gone. Remove the entry first, remove_proc_entry()
waits for a writer that is in the middle of that.

Fixes: b6c7e873daf7 ("xtensa: ISS: add host file-based simulated disk")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/xtensa/platforms/iss/simdisk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index a2ddb49c269d..e51edb8cf872 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -379,12 +379,13 @@ static void simdisk_teardown(struct simdisk *dev, int which,
 {
 	char tmp[2] = { '0' + which, 0 };
 
+	/* a write to the entry attaches a file to the disk, so it goes first */
+	remove_proc_entry(tmp, procdir);
 	simdisk_detach(dev);
 	if (dev->gd) {
 		del_gendisk(dev->gd);
 		put_disk(dev->gd);
 	}
-	remove_proc_entry(tmp, procdir);
 }
 
 static void __exit simdisk_exit(void)

-- 
2.53.0


