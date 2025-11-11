Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69F9BCD1297
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC368E000E; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650468E0026; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47AFD8E0014; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3DA8E000E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7097F1A0419
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.20.27C2F83
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id B885220007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="HiKTZzZ/";
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XM4FZa0do0+xkZhNaAyLfkF8FdfO7rZo+6nC0ji7Cc4=;
	b=3PQWB3xMAN+0pCgfukv7O03jerEk1TPf03/m0//WYEPpEdKV3967yJIaP0FLL0ssxPEaYi
	wZE/i0mQrk6AWYzT43WLAbc2lufwOSLv60GSKHi6Nbi3Cz98Ybu0YxTPhtjUeOrd9kV70i
	R5SR8kpqTS0J8n777qkTn+jgdwAcYCA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="HiKTZzZ/";
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=EjvISzH66BsI3VS8KQjBTqnlGh8SX5dgHbrTAgKBYwfd77d6pfaHmB32+fGqsJ3JACxkrT
	6EOWsARELqjh4h2/d6y4LUkOfMx7vlf5JAtigDTRcozA9tQUSiY/WZ4Ao5VYiByeejRWMg
	raeaLyF5ayRdA2TWqZKvRtMnTyysDm8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XM4FZa0do0+xkZhNaAyLfkF8FdfO7rZo+6nC0ji7Cc4=; b=HiKTZzZ/q4UOe5+JDM6CDFXNw+
	HyDR5VqKNtpjR2amfKboMkRHLZr4PaGe7CCAYJP+76LUWUXz8vpbtEKAIPStBmmhP8Sjxzs+thRRb
	rJWYPOUAtvnPrutA0+F0/TY1GdkWOThpY2oCwiyCD0KsJ/zHRyjJ4bPea0L/z8x5fffm3GVWTUX/F
	C1klgokjca5tCzuxZN45ZPaBHqDRnIqHcrhKNk50YL8SEnnGxVsxtfM/mF0CaVVxuNE6g5P/XIX9V
	OIeVgxtX/90DlBBBiZxd8xJJxrKK6b8c92oeeg8BBKwc8nngThjXp3MfbnCwxU5TS6sArZUNYqKB0
	MGm2kVNA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHj-0000000BwyW-3XSb;
	Tue, 11 Nov 2025 06:55:23 +0000
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
	bpf@vger.kernel.org
Subject: [PATCH v3 17/50] convert fuse_ctl
Date: Tue, 11 Nov 2025 06:54:46 +0000
Message-ID: <20251111065520.2847791-18-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B885220007
X-Stat-Signature: 88nw8ny48yeriadzgm7oruuixm53c1ww
X-Rspam-User: 
X-HE-Tag: 1762844130-618886
X-HE-Meta: U2FsdGVkX1/pRSxL6Bql/uQD/tgMC1+9C/KYhYtpycwBLe17k2zJfx24UoEeDL91xg+OYi2ej82tZnLwlJagwPBbB3EiqQJ5kZ/fwAK3KXzypCIRRL8uMgoN1YfxVaWWD4GWSXMwOWCadmSb9vPSbeVyNNs2lg2JhtD4elkKuROkO2bwVb1lfWnjyqv7U+l/RacGxSDbmeIfgLjN/yEJo7QViCgqYudTeWm8kj6SOKQIhWOB5w5IvuZtlYkEhT87F74gEOsNiIcGQUKOlVJXhke6yweBugK61bKwbB2G+Zd0lCZe1T2wEfbY/aWenAI6usNxAEYDIDEY76LTsQ9lF+5/pYkWX1N1rzwlLS0Kit+85bm25MB+N5vEf7PK3mQP3/PYGEaxBmvBbckL4mJec31ij/Xnx0xf/5eyEnTAueIjrONLUXftYfN+oeLwGz0sndk5Bg0MhB75yIMMIZb8z1RWiakReehRaZk6krAjG58tGsQmfnkxkct4pzllZPtpEumhPnPJTorD4wuKG/O1+avaW3rk9VtMK27f2y9DLX6nwkpElR7ud5vINHh2pfGtNLDQvDZRc0IrDADQQCdlV5WonqEM1uBwp8wwqaZcx28EYuGrzIb741DLH569cXpLG3c1plH1iV1+Jop+9S46/IeJQ2JXy7HbiupoOHUFAvuLhfJFAgNRlYzXqr3o0uVDKy5X4aLRWD6bnZflcHAjJe1MNPUNym9qeZAHIdeM7c5XMr5I7y1diwQL21mn+uQ6hOLu8B0bVxwdMouZy/gHDBusB2frFiCauTjsus13X4ZiXVRjrwvCNByNslHHcjXnzLKCkJIs7PNMoxgjXILBHeG/vyG3pRV6Ww5hunnGziG1zheNQ0zCsJPlkZwuZz/sw0sYqez2xKI85TWP1m1rozvMmSuig8EXOP1JpJHSiE34HzEqIE89rtqnlMQ95GbDWLLnYj+9ehNo+NplucB
 fxYxiLh1
 GVdseHqRXbCjAfukGYmZ0+IbO8EIQ7xiSfTFhmeHIKii7eaYu3huEqJRXIe3sDhcd9brgMS6O/D70oN2c734W7rKKjGiiOfmWFEXkjAciXsG+c3e5xa3CH6+W7exXGIiUJVPgcrKLD+BrFS6ex1a2iwYMeJwnaNn6tzHsWyIf9SSHDbl5n/rGHZoD86q6AvHP64p2Mt95l54f21/gJ54XZe5S+sppINDBkQM5TQBnAMhkhjZkySnld2LQ90Tke7kql7hC+ltcpeuDX1IUkURBn1BplP6KOH+sKSE/6Pu3vaCKdQ88HlaWPWXS6V5R04QLeEFQh90nMseGmwvqqADWJpoA3IWbcXbig9ie44bVDoXpSKnvT3Yk+geqLsrqZ1y0P8CFB7WS+IHCHMkN+lvqLeJgbTwShpXFWWRYzuLYA1sNBgJL7wsLXIBN5zCu6+JCGM2aUSwa+2MnnxjYRu5Yzo1USw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

objects are created in fuse_ctl_add_dentry() by d_alloc_name()+d_add(),
removed by simple_remove_by_name().

What we return is a borrowed reference - it is valid until the call of
fuse_ctl_remove_conn() and we depend upon the exclusion (on fuse_mutex)
for safety.  Return value is used only within the caller
(fuse_ctl_add_conn()).

Replace d_add() with d_make_persistent() + dput().  dput() is paired
with d_alloc_name() and return value is the result of d_make_persistent().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fuse/control.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 3dca752127ff..140bd5730d99 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -236,8 +236,14 @@ static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 		inc_nlink(inode);
 	}
 	inode->i_private = fc;
-	d_add(dentry, inode);
-
+	d_make_persistent(dentry, inode);
+	dput(dentry);
+
+	/*
+	 * We are returning a borrowed reference here - it's only good while
+	 * fuse_mutex is held.  Actually it's d_make_persistent() return
+	 * value...
+	 */
 	return dentry;
 }
 
@@ -346,7 +352,7 @@ static void fuse_ctl_kill_sb(struct super_block *sb)
 	fuse_control_sb = NULL;
 	mutex_unlock(&fuse_mutex);
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 }
 
 static struct file_system_type fuse_ctl_fs_type = {
-- 
2.47.3


