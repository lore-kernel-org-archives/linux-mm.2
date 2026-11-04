Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6F9606B2C0
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NV/pCHTx
Received: by kanga.kvack.org (Postfix)
	id 59F846B05D0; Wed,  4 Nov 2026 14:21:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576B86B05D1; Wed,  4 Nov 2026 14:21:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 466516B05D2; Wed,  4 Nov 2026 14:21:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE5D6B05D0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:21:38 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D8F6C0766
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:21:37 +0000 (UTC)
X-FDA: 85398405834.14.92A4A9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E499120003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:21:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NV/pCHTx";
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820095;
	b=6PHw+c0wnhxpCUII52H+o2UFOrv2NBLlVTCxKGoSmfWKWb0bT4Kg9Se2zK+UijH+kKMgHU
	tZ0XHhVOoJu4rm197ZslQ2sbnRQQh7qQERMSQxhwSiycEBWJr40hTdPD0JlRrj/PxhFE0M
	oVEA1CFT4ftavjz0NKlhD1YbLTWyenc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NV/pCHTx";
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ih8EKkL3fEFrmnOibnSg6zuDA24U9CpFmMUb1+ThTQI=;
	b=Nu5dMFPGma8eFPuLubZtG9KuXZSO36HVBj/a06K4uNGUyHw0t+3XLRupX7LYvlZ8NB6QOS
	FVY6ZIzpbTgfYIrlmlYVX7Z2kWComltma6K3QS8BULsqRqx1CyEfVwSjidyaSULryW7pNL
	TD1sw0oSxfwj+neXGn5WOPabJ/Vs+rE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D98760609;
	Wed,  4 Nov 2026 19:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDE71F0093A;
	Wed,  4 Nov 2026 19:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820095;
	bh=ih8EKkL3fEFrmnOibnSg6zuDA24U9CpFmMUb1+ThTQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NV/pCHTxChzVH1ioWmq+QeUT+SBXucwSnRPJOdBi/Q2y75DGHw15YBMqYjqgrtt2O
	 VyFPPs8v7zjoqFDFOJ5oAl9YXifHpXNyabEPReJZQwa8XXH4iQGv2Qty9h/jandirD
	 aUMSk23okxfo9KtkbC4/nzn1Iw09lddant5cO9hakE0csEjqm8lPvF90MPEOYpmUAd
	 IMkDVpUwfqgAQLlAK9nXdyRgIdGxWTHDKSyuqOT48xWUvA/iAJk+qPbBXnzRbF0y+d
	 wn/gLZpI4BHKSDGznFL2I2ZF9zF+c1mxFQKqQBN2chjmpu2miV52eKF6iZL2Z2lRgn
	 AL7Cg1xDOYz2Q==
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
Subject: [PATCH RESEND v2 22/51] ALSA: info: don't write past the end of a data entry
Date: Wed,  4 Nov 2026 20:21:20 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-22-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1329; i=brauner@kernel.org; h=from:subject:message-id; bh=/wIh+WZXKaFyyFYwMjXKmLvFs42DoCHjOzS3J0v96D0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bny2zMufh/VIknXNykPasit38Tx6t1dcVkb8Us6vt wpbDDY/7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI8+UM/3Qne19pyPzkZ7uK 4+ps9RZDLa75iTtP5zvl3PvzK0/j/yuGf5bm066vnniBYWL95HgLE52AGfqMMk4eWldmv104x1K Fmw8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E499120003
X-Stat-Signature: k9hbaoqziym1e1t85k3gb1j5pf7a6t1u
X-Rspam-User: 
X-HE-Tag: 1793820095-83793
X-HE-Meta: U2FsdGVkX1+KVyfc/7j+Kpe0Me754TOB6OJgXM0dGGvhTzzWkpDghwocu5/O1AXNQfT7WKQEf34iu0cUJQ3mSAPL8EbAmKcSckK/rzUUygMgeyTs7d6JB3tTbvHVScdiavAzGcsq0EuQOKw/kapWY6bN+OjZ1MxE1rHgP/zMF7DYDo5HjviLkI1ZZWVvdZXMhdN+TlX+YxvDI6qzGo0fZM2/Ar3TajGf87WmZJ7te755Eprb6WmGfJqZ+BFDn25KzIAhSNOnttgGm9Db707zyPae4luz4K6xbZV5OVKTOrSrQWEqiWVBnPNCIonpyWmfyxVRaYG7v1dWt4kVkhNPoYptNRLEAMIgARLHVPPcL6FJlilT4kGHM7hUe+jxep3YGKtNiCX2aWmINgR8v6wY6whPx1x8AjLXTrf7eAMTzYpPFls8L0wQYP2EUibHPQFtIn1zzRFzWkciCIIHY/QIXf5pcSpGuT1cRdUJ4IHJ0j4R6B5oGjvZRrfgmZnKNmgqd3qh1RU+oLMXWHcFa0Qdj+3F+JmZSOk3VDkbLpSyv3Vb4N/uxUUJKD9piX5ayhTSU5Z6cv+TOEb4AISjm+3z+zswUjCV2gEPkG2UheVmixINrvPyg4w9S3ECxZcMIq1nSQoHqzgrmwgDpV6dtohTPaoClewrKj5gLpXf37gNWGlA49/We1aZ/fnI3TNut6aNopC+jpctO1G7EjDvMAPIihJRs0S2A8+Drd3HJZgTpomBQe4z4x2uTBbrBN3Sur5hCC04VeEcBQYL9H7fhWK6QiV7RwUrVGJWJMM0b0LTEIECjuAZueozDggl8im2MI3axkOW2nKWIM8q7e4AR2657XJKXoIcIv/kClwM3r5oH9G6QW3/ua0wBayOi3UZvK93FLtoy8f/NR/nnyNvvVgj6zqijedHYIUpguXkja4aB0hqrpJt0Cv6onSWqXMh1ZkpQNEigtVBQwIBQd3gOhD
 J+iAlr5Y
 CvAegOSR973qwEQOCk4EzBErGxJgcOxgeMXAMfpoSrYlJNDgrgh9xgqso3q+wCCHjSXpUgQ0DzAior2eRP4Kdfc/orwuEgYv4YBytG/jYfOlnJ7a+LMKnZ9MYl+PKAlj2O3IiZpUSgQ+yJBrap3OXHNbj4tUcbqFiUn/WScl1tuOzuo5Fj7/4mC4OwkSvzujeGD20LXy3nnsjyqC4h2qXxZhFE3z3uJugXcuL2pHL1J24otl0i/QqeHxULBTCMjYHpgXzD7PG2Jy92iqKw2+wzWKOro0D8TLAPaeqyGPWEKTO660U+PQs5ZAQarXQx+DYf3lY68AgbYLYqNRLqpsVQJhietoP70HulkDWgExXChzm83djKDlZ5AH0/GXNVI/GOyhtOo81DLVNEq36ApzfyUZLitQvD8PzRlr2tSU8zUhn/Zg0ElpLi2DJDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

snd_info_entry_write() clamps the count to what is left of the entry
by computing entry->size - pos as a size_t. For a position past the end
that wraps and the write goes to the driver unclamped, for opl4 into
sample memory outside of what the entry covers. At the end of the entry
the driver gets a count of 0 and vmalloc(0) warns. Before the clamp
moved into the common code the driver ignored such writes. Fail them
with -ENOSPC instead, like a block device does at the end of the
device. Returning 0 would make writers that use stdio retry forever.

Fixes: d97e1b78239c ("ALSA: info - Check file position validity in common layer")
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 sound/core/info.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/info.c b/sound/core/info.c
index 023b4736aa6d..f608d335b6c9 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -171,6 +171,8 @@ static ssize_t snd_info_entry_write(struct file *file, const char __user *buffer
 	pos = *offset;
 	if (!valid_pos(pos, count))
 		return -EIO;
+	if (pos >= entry->size)
+		return count ? -ENOSPC : 0;
 	if (count > 0) {
 		size_t maxsize = entry->size - pos;
 		count = min(count, maxsize);

-- 
2.53.0


