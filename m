Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 093126070B24
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mf50A7c4
Received: by kanga.kvack.org (Postfix)
	id 2FC066B05CA; Wed,  4 Nov 2026 12:52:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 285516B05CB; Wed,  4 Nov 2026 12:52:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1509D6B05CC; Wed,  4 Nov 2026 12:52:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E60316B05CA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:52:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 891AC8080A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:52:09 +0000 (UTC)
X-FDA: 85398180378.27.D4FF2C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BC0DF40008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:52:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mf50A7c4;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8IXtzTL1USde6aV/lVKsFPWulIUW0ciUvC5Tm4lMm4=;
	b=cuTZ029hiQc0LHvEJhPuMhBGfoTMpbMJpUxiahB3wxczN4oJqlMc4snnsXxF4cvlCXmZ0G
	Ota5nTbYWwtXiZYasi6UB7/Wdu2xBytqIhlJWcIzrrsqw9O1Rpy6icnkpg7cKr1mBVLX2M
	IYHtZoJeakyNsLDEkCdJlDxX2Yoied4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814727;
	b=tn90AcKzKQwOGaZ2O+hsX5Cs+89ZEYVr5lhJlmMP6Us95EXef/s99bQLjb9Ue293mC2vAS
	GDb/d2Xb/XHEBPzjTEYR1bX24aNA74Z2ih3qRVLdRwDuHFTPogg6jF3b+RMHkQWP1+i2+d
	qil2qiemqZM+/JcCc6Czgf9yTKg9m8g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mf50A7c4;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 326754075E;
	Wed,  4 Nov 2026 17:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A12B1F00A15;
	Wed,  4 Nov 2026 17:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814727;
	bh=S8IXtzTL1USde6aV/lVKsFPWulIUW0ciUvC5Tm4lMm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mf50A7c4fpaWARlrfltAJNXBhTSZuGrfKtFtGImZQJqXW3N9v7Y1OQFxFmkFkK5Ct
	 bapsswn/j1rtyZQs4yPKDUvsPIf5PDmdksaztU62PPad3Jkbs8dRzSiZVJ+Ai4/9A7
	 TOu/Cu4dvVAHo5CKEYiXGvTJnnQShxT00W42Aojf1ls84KBw0r2BVE/YpDekWmtN8L
	 TKNaSWXmrlOTNpBzznkpl/BqVQ3rVQSmt0pyyR+1Vz/bjCdzyITaMgfaSUm99mamzI
	 je3hQ99LqYBMj8gFmNEHVbqfHXEiVCfrmKNAjKbdNUHX9zYW2a8uoSL2qV2eT6wKro
	 prddoqpdnGVCA==
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
Subject: [PATCH v2 26/51] scsi: core: NUL-terminate what is written to the host proc files
Date: Wed,  4 Nov 2026 18:47:12 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-26-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1011; i=brauner@kernel.org; h=from:subject:message-id; bh=jBwXVCCRpDjmnAajxR/zAvEvmAtZKAE0jCj6+Cnx3v0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zrv3a4XNr8e6d1tDr0b7KBzIWafbojAr+fDFhXfE9 vg02md3dpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk4g5Ghh8f/uzl4px+y8Ir 7Jr5ATWGvLtVV5S3nzBgvC4T9mgf8xtGhl0p83Un1Eie5LavWZ4U5lee5LyI7VCWQtVx3w8B4jw qjAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fopi55eekeodbn65zkmuehtjktehozsq
X-Rspamd-Queue-Id: BC0DF40008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793814727-244875
X-HE-Meta: U2FsdGVkX18y6jilaHOr+Ve48u1Zl+MqUtykTb/aiZey/yuO38nA2RHP6jf8YF8vmLjep4aiTUOwyiovKYRbo+sGcLFLhvhzZudEWAD2XZLEIKp0nQ9dz7ncIir9rzNvxwb6j1i9LvF+TvGA+hX02dZOIvOsoa0DEct0tFA4oPrms2+q5pb3ebZWkZLy0s3POHwZI2tEWmKhw3U2RYAj8xj85QKUOQ76edOZl07IXiQ7KqH1vERkaaEmbsKoLTBUhSL3dpAtepNZyPinSN8AUmcakac9edV2JLXOSsg7eWQ3D03OOP98Z99Db+9+7VjSkGOekFfEIZa1aWyPUpwMt4BQT2dWCv8nV1t9ZDjXfkioAX4nJ9VoNGPGHXJ/leNxmOQnwAbJRijogc2LLjkUhLEvEeIT5hhi/xfIHSvRU6HoarZOt2UadKOQEXwkEM9tfYMfqXMrtCNw9BatRBLVLdqMbrM+JykPwpLuy+yoyqg4HyoE2aWmwlmTfp6NTCxNXBrpQY6PVxAbsXyQusyWij2ERIAubFpHb99s/+2qcEKYsDV+qsUk9SW0V3Oye2H9yCN4J+PcNUvwxl9q5EzFr7uC94cVcs54fOKp+PcdxSQgSK50lB++UemZEqlsgGXxO0mOH0qZ19nLTqV/QDUKH0pFwIPTZ4iKiM+TAvtJt1z3/ClQ1Tgk1D5CqUa3pLBiU3DxETpOGTX+6tiH4O5W/DBOLC13kUS15DiP78dpGOhnaJS/nOonDgmks9/58XRToRkMnZBfCZyMWIAXkvMebnZK2BbjYZpMPoXr3ItzhoY7vcMzEVry66H0dMVM8AWjRgN2ugPuWhmO1oAJWfzxbjuZb3/jryllMpfC+QNL9aMcYjtTQgC7X9e5Nk8o37ed6+Mb8V0s3ulsPaC2SEv9xnkb5VZNFQWWh+P7+eV4mmFi3125LLIHrPNbNR60UjW2B7IZe5lwcblQiww8LIQ
 g8hmWyYi
 J9rSxnn8LpxNPsjBuFyrOmZEi2zg1C/uJ2xRPHAfMeKIEBtaddNlcZuRgaIBFc4FqSZpU7rdapguLZVDsv42bd5fvAu4Cixw1xjo1/w7JmZy7U1448ZLN0hpMono4POSR+0ItdXm/6L/CSDevAfjRsZ++/jAFYtKBJBfi9a1/jE+xQyIKEqZSEAZn6OkUD05T+EaTiN1lP92tZZ68Q/zQBrH8fOuYKhJSiQL6EpSt+KS3nS3BZ8mpm+qbAkDCFqFOhQIHxSOx54I1aw0rTUWNBEstegfSkcsfoLXLmyirP4PGsroPItN8haHkHYVd23Uw4BzqpEcL+CVwBy2I/scuy5kFSii+O6eOS5FO0tpbmCNr0GzkIpjRM7dB7GQW1GQ3qwgr6h9XcwKBpN8bT3OHWJD8HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_scsi_host_write() copies what is written into a page and hands it
to ->write_info() without terminating it. ppa and imm parse it with
strncmp() and simple_strtoul(), which read on past what was written into
whatever the page held before. Terminate the copy. A write is at most
PROC_BLOCK_SIZE bytes, so the page always has room for that.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/scsi_proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index fdc355d783da..dbd03360b5a4 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -80,6 +80,7 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
 		ret = -EFAULT;
 		if (copy_from_user(page, buf, count))
 			goto out;
+		page[count] = '\0';
 		ret = shost->hostt->write_info(shost, page, count);
 	}
 out:

-- 
2.53.0


