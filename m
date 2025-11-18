Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFBF9CED243
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA41D8E0027; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDECB8E0031; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B83E8E0025; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2448E0035
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B07CC038A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:16 +0000 (UTC)
X-FDA: 84122566752.28.4C0517C
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6441B140004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=BapOXWjG;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4iwuLyMN17JmghA7oE4FXYqqV44QgzYixBKeo+FLe7E=;
	b=QS/Q3tP4dSJw+RID0FPXpCeRzX8lvKPd2KE1/g6sbtnwwvYVXapuyh2Wv6GHEkbSTJtPgO
	TdtTlSHKlfsB54t59TnRIH7uucw5xGcWBLQRUC99sY3uUL1Ly6gMq0u/PTtRHvXY+qF4rL
	18EZrAzkf5swRk+TItsHkGJwO+iXglc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=BapOXWjG;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=3wjjXZSA3ktdrrsnFQhl1h4+LO6y5f7KG/0O+afLkudP87b1jZPz0xPVu4CGHx1zr5yEju
	LIMwOpf5mpENIolWG7ih3ebnZ6JAX7TkqXBdMbDZ5/jXmoKGRvf1d0OYePe1IIRvU0Zy8k
	VIN62Cpfmb+u3EdHpv4TMNg7oHqkSL4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4iwuLyMN17JmghA7oE4FXYqqV44QgzYixBKeo+FLe7E=; b=BapOXWjGs2VkVmavXIaruV9LIv
	fif5sNmvyXkkdrDgGBqvJe+gDqebM9jIRxp8VYwkQif2zT7dd60tH6gnsbnKJeM80HoeSo8cV3S/J
	7cvPXxsjHToUl2jyND5pdDnRqaqtmtee59nhp5aprgpMxQ49CNkCGicip3k3PR8jUsIkblO/bI4AM
	FcZG/9n0w2l0fF1uIyvfPbBmcvlR1gvM0n4aSfF2z+EJTtM5gBvSDcBVlz+eaYrnZbMLIYqc+tCHW
	WlzE5x5ZPhulvSTyNPvpiHrztKiIo4U5K/NsolyfyXElZgmK57FrofPikDQX4EEONIKZdExG+oCeI
	/m1h14/A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4X-0000000GETR-0lJW;
	Tue, 18 Nov 2025 05:16:09 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org,
	clm@meta.com
Subject: [PATCH v4 38/54] functionfs: need to cancel ->reset_work in ->kill_sb()
Date: Tue, 18 Nov 2025 05:15:47 +0000
Message-ID: <20251118051604.3868588-39-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6441B140004
X-Stat-Signature: 7i6pzjb599yufs711mfdcpsk36sgcqnp
X-Rspam-User: 
X-HE-Tag: 1763442974-525615
X-HE-Meta: U2FsdGVkX1/raQWCUDiinfMTBEq4xsnudJzq+/uBbyM3dTqeQBsZUMW9OnkztF/e6zLh+m8l1xu7RgcgTzkMpJePOnBPS/88qajIDtQ5QTP2MtEJ1KdhYP9q5Hak7YnQkPwiwynYOsaosxajf+F/Cjm7uBurulNc2KUJsH+QMATXg2zHSqOh439vjnphs92/+A7eHulIF3fcW1us1p5nhbCKW3+K9i00HspRANooX+vvdmhPfrWkIRkldI5wjY4mAvhlOA0rUx4UUdeEjRmM1pWsNYDLABXw/w4pbVL4TS8pbPNUjJCOQtorBaDQehK3nDTNHrEsSDe/v34/SWlwi6VrQPUtM5p7yEymGwoU+q4prWwfqeZkESXChyup2GQ4iQoZG1eDCZWTczMt8eYTjzSyIAsd0DAe3qmg5LaBo1a8O06jRCDrqqK+lHjqH9PLnw2q6rdIVE5oiWai1j3JN5ra3HQt6wNh/ZgopP/92Ayl6vO7p7qQNst+twqif5o5OafFmHFWRxUH9fHPPUlpAasPuH3uwSlFc/3Y1nlaDiz2DfgZlgj5ciazDXYPujDpMVjmVr9WG5ynbrWT19WxEmKuBmZpnaWU2euCZvx69n4dt3mlN5wTGaNCN39goFy6qlQt2o/Xocq9p2sy0ygcZ4WIWqfAYBA0g3dvYqPy/B0cRCX0hhpj/7WhiAJmJL45aztvTcEQjrtKZLU6VuQDSNWW2qA2JbM2wUu5fnmFpgpozBxXRJ5qOCEeNea2nKEyyTJPH5een4LvkRPhFgBAqvDfiK4zA9W7eHDT0wfkl90i7pAWdu96oUJKx+bB9OcEu/61HZq6USOMT+WVWcup9Nge++B2totKZOvia/PKcLLJ+GkH2YMwxNz8AIlbtHq7geUyQmyRwy4RsVs5HJVs8I5Re1b6g63p3XnVSBB1FXAT4/Yr72Z6zeO7DTTtcY0uRP3Z6dXq1cXTr+h+5Vn
 2dgcAZc+
 I2wgpZR9ITsdtQe3aBd5hxr4d1pXP5P9Y83ICMXdOQKLMYj5NDxff/srl+A9GTLHGJ92dbIFInkqOz/soGWeEdymUPCj6afINJywuB/NlgOPMhJpY8gYzDChIO/6bqExyftHALVOMUIcJsVx95wdpSk9GdVY4aVhmMvtdrmafRnjVfeaMgS34OFmd0TAUh0387B7M+f8A18f9xX8W7dIpkBh81GSyVfCX9WT0Ox87v89dZW/7yx+9Ira5gUW0/p1noP930poiGGRJyZyPDVe4GdIKK//Ndo1ODP/l3/Xe9vGm6gR00VZOasvPeWX0mxuldWCdDZlVbpmuoP6XJqVxGFH2zbs860xI3kVorjG8nvU5fNsw+hZXFiZZeqh9YCdKH5W/I2XAsZ3z+XKj2qT6Dnf01eeR4UflQrBGrpxwPlUdHAUJ9fzqPyZos9eQXwoX27UJ628Bm3UkoVW+adPEK/Kmo3IcdglGGHIkzhmA8pa6zUiKkOthtfXpNP5cxbPglyRhK5MstU+k4098emveg0I+1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

... otherwise we just might free ffs with ffs->reset_work
still on queue.  That needs to be done after ffs_data_reset() -
that's the cutoff point for configfs accesses (serialized
on gadget_info->lock), which is where the schedule_work()
would come from.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/function/f_fs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 0bcff49e1f11..27860fc0fd7d 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2081,6 +2081,9 @@ ffs_fs_kill_sb(struct super_block *sb)
 		struct ffs_data *ffs = sb->s_fs_info;
 		ffs->state = FFS_CLOSING;
 		ffs_data_reset(ffs);
+		// no configfs accesses from that point on,
+		// so no further schedule_work() is possible
+		cancel_work_sync(&ffs->reset_work);
 		ffs_data_put(ffs);
 	}
 }
-- 
2.47.3


