Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4BD6083631
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JIdLOXp6
Received: by kanga.kvack.org (Postfix)
	id 106AA6B05BB; Wed,  4 Nov 2026 14:18:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7556B05BC; Wed,  4 Nov 2026 14:18:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC12A6B05BD; Wed,  4 Nov 2026 14:18:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE3BA6B05BB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:18:43 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 607B61207EB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:18:43 +0000 (UTC)
X-FDA: 85398398526.22.ACB31F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B0A78140004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:18:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JIdLOXp6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Di83VHF6QbwHOpQhBimI2/C2To6SvYozNijzJKB62VA=;
	b=U7bdkK89Yy7nJwAC270lFf94gX4FxjHYtxwPIlYznx9jgEdONccm18h8poUzVVJphN2Fr3
	0o0YPCd/rxTMdYXvOiBy9qbDitBa71/SQgsuqmyNk54dU5BnmlyDhco/c3Du6WkfO1U+dC
	C442fdxwjYMNSkyPo4zKAaHfHdH2VpE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JIdLOXp6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819921;
	b=VADnSVkz97EMIwn+NI0mKsbLrKRl90FRt7AUzCXYdZVs+ksfv+knVguRnMIYXJOTOjV89h
	7n2ZX2WYDR8XXjMYDQGluCftOees6sugQik7ilw7A+wGwpbFPotA64K6zC52tbHbCe+PHF
	gBd0P0ohq+j90+DYfq8EnC+gd22J7e0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 437B460D7A;
	Wed,  4 Nov 2026 19:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFA51F00A16;
	Wed,  4 Nov 2026 19:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819921;
	bh=Di83VHF6QbwHOpQhBimI2/C2To6SvYozNijzJKB62VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIdLOXp6sxEmZBJpMlxDZmERDwf9C8sLM/z2dbJBoBY9UBXkGBGAj7Yxhgr3YbwIo
	 WLzNZhjCHsHdhaQxnTFFO0VEGKxMv1vINJffnyQzpOIw9IevG2oqGRabpoxY4U5ohN
	 dsW1/Ep2BQuneanTV1J2VPfld0/EzmI9Txpbh/m9xuzYl3I8AGELsVFoKVbyxoHr4k
	 3c7remBwAQpRVBw2eStXkccOoVSUONc3WQN6TCMP9ZphCN52UWu0ZYRKWjmfYAQkhn
	 K0VZsnobCWkJjfjb7T3ZWzf5xxANP/HeKYAhnhy6yvKDBY5FqItsSBFDLO5ybI5gH0
	 NwA1fy8O+LCSQ==
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
Subject: [PATCH RESEND v2 10/51] zorro: size the proc files like what they serve
Date: Wed,  4 Nov 2026 20:18:26 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=796; i=brauner@kernel.org; h=from:subject:message-id; bh=l/jVDuzMOjj8ie0SJoZ9zbu/qnGtbORxwaULd7yJNic=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bryu4qPpOT1kc4isZaDhv1/bXwk9vbD2UmCm1l1v/ 29zJLs2dpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyk6jwjw6sm06P+wcoHVfTf +okVXHjMEBzWYri1p826+M+MhiW+0owMC9vz1pp/V1r0kenzR652vZM5y5jOqWdbe18R57A5vkq ZEwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B0A78140004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 5q3u3n7s91qetruidxwmwgc7uogiaaqu
X-HE-Tag: 1793819921-719559
X-HE-Meta: U2FsdGVkX19MzdE33ZT/uW9BtdwjHY7eDqEug6wTBsr9kc/kqmY3JmupLUw2jCbNgJI3ZqOwoL0ICjg6QpyCwTzl/X5tHFEPdEovLTZJP/KQRqZrqKLxq7jlq07LFryn4aYcQbtr9U31c/wwIa1ILD+CVwoQ2HKzAXXVyOOCpz2060mF9LI4V+6k0t3PZNlMT5Vs86QNYQjqiBc+AvqH0PEKd/RJKB/h6MByExXwu77f1esYl5thMzRY1hZ0Zkmo7bPKCMGxEFNQ10oZCZEf/6G+shozTSNlbrjYPdjiJsOEYv6qFhjHDH4L2/HN5tuVntQp6xryslPRdHuMhoOucPqLtcA9QAZEkoVIESsmQkY4juEcHKY1ecZ9KWeHLbavyQjyEAJcijisLLqgoa0sS0AnAlY8BEFxkb0fIzvUaWOoDsyznNRzALg9VK/pXYoRRjJ4j617I/qv//B41JSHTAtlLc4CFrBB5aUwpnCWviQ3i8BEfBtABFAy64DdW4mWOPltoq+Gj4ksr3h7tqQdBsmZh6vnWdN+RznGQT3iv4wozHNI4P/kShu5Ae5Umje29fH3HnAxIC0oZgVwuNRVe34sexXkAHBygaHSKRontgSB7BP7gPW/47HRiuJ34qHDXxtt9RC3gGZ8m/88wNsJxyzQJP4jtkl8TLhJmq/Sa9/FBacMRUSrSshwyBOTJdxPx61toimReANfYErw6sIvURcJghUlOCFsFBrUwDlqaa6eoItETL7FcdzJnqvNB2s+ESRtpOXNUlIqlSNk7IBSJMwV9gcDucegHUakeh0Dzc0VF39pFbRI/uhxpJpNC/pJ93ZW20FLk8obOPRpgXQ2+gYs8jIaAaHewm2iaA4CGOISR7s39OuoIDoVL00bDuseFOAfXxVDhrxLUBldu9IksiF5tHeFtUiE7dX1cl/+fCPFNG/ba8F0/V/S1cW3nKbQ9h93Rq4YFvM7Ss0du/m
 iWMDURwq
 H6K7PjB+e5NDdrNe96OsDX3fXKQCvEx94wU7rxm6SPir3c7CVk9NAdlORCKY/2qjpwldgwb/1bESJjhGO+X9dg9gZhYm0Dth5ELuAWZdPCKrYnIsGWLyrTwOl2zTupXMVX2PmNpoVNcTDVES4+1egEgId2/lQw53VSbUB1KypoSr4APnGA2S83J/I/5vndlYxPfxFm9Kq26y1VQ4ZyngxaWGcHuiLINvuuTLk6iSYMEGutbWhdqAAMe6s6hj22mIWpYnWz7zlCj0eJMavHtR+ZQH4jYefD8GfKEAcCKGW/N1fNSQAyphLzOvvewnVrtkrRwiZKErLg32H2VQ4FSfi3mefhembAzsdxCcLn+UfA/RdNA9b02t9IdVNCVhCZeO6nRJgEeJ1bE5eyzANCNnR0PWbZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The files under /proc/bus/zorro hand out a struct ConfigDev and seek
within that, but their size says sizeof(struct zorro_dev). Say
sizeof(struct ConfigDev).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/zorro/proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
index f916bf60b312..4c6f8f1c4d71 100644
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -108,7 +108,7 @@ static int __init zorro_proc_attach_device(unsigned int slot)
 				 &zorro_autocon[slot]);
 	if (!entry)
 		return -ENOMEM;
-	proc_set_size(entry, sizeof(struct zorro_dev));
+	proc_set_size(entry, sizeof(struct ConfigDev));
 	return 0;
 }
 

-- 
2.53.0


