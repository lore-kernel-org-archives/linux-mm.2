Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EFF5C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121B86B0096; Thu,  3 Sep 2026 09:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2C06B0099; Thu,  3 Sep 2026 09:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B156B009B; Thu,  3 Sep 2026 09:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCED76B0096
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:00:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 566371A053E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:00:22 +0000 (UTC)
X-FDA: 85172459484.16.726B3A3
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 75499140021
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:00:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=efVjB9sf;
	spf=pass (imf23.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788440420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7QKH2r7d66SxSFJm8bjz6ZBcyuRFjzyujOBEDXlc4U=;
	b=HPNnvN04RNKtyM9C8QG9HqF1vIeo7JFMg5vawx0yOCNDVRE7I/9kqQ1ObBRrY+EQy1ma3f
	cgTIGap6KjZF+VxUwIQqKQMp5aamZ0dDiZbMJEqo1vsbwwWhHlxtC6leSLVoTPUdhuootl
	ggCjj6ilrvMEOg4VWReNyi76X/KT+mg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788440420;
	b=omw/QlXiYUiV9CoObZpz+U/kaIJ1c6I7tsFsyya4/HmTcggO26IhsuyuktMSZ3AZlfGkzr
	oOTzD6Uy351oOh3CrGttk7FOOFqxj50ur1FsapGOel1S0yQmsTl08lMyFJguSCKBnMJWyo
	ei3NkAnxAmV6CYaUsTxoRBr3WP6DzLw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=efVjB9sf;
	spf=pass (imf23.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-85339ed040aso1924526b3a.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 06:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788440419; x=1789045219; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A7QKH2r7d66SxSFJm8bjz6ZBcyuRFjzyujOBEDXlc4U=;
        b=efVjB9sfHpSUxzNIh3cg9HhnioSwkOjPOhzYDBUiZRq1yNrBebm1Wh7O5gdCUgld9z
         zlEIOh7QZH2BU0wfKOOvBKRwhKBnVU8KC47a603Z2p+HLPXRWKmIILXvcut9z6zX1njx
         AE1E66w3KWdrUENqR48tCeoY12lp+IbUGIWAo8tqfZO69mcXD4OBqRKfdRQAYqhvm9W7
         pkVGCyT/UJq6xMAB6SnFJRSa36yFAccobjbVDC4hYkMJRoBLAOMvHiJRREnXlzL2WWhY
         DCxc7nD26dSLUzx+V4cyJP1Bdnkt+dc1emiktpNBnI0ntCX+imPGTqvOMzaaaZB6dtBX
         MRqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788440419; x=1789045219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A7QKH2r7d66SxSFJm8bjz6ZBcyuRFjzyujOBEDXlc4U=;
        b=UINXYXSnytp7+hFRQc0/RU4QHT/iMg504jo0NECO9zTjF/igfozWYWXmm4aUdsE2iv
         aSparnnCpk85gnroU+cLhvUXSL+xceJWuuKC49VWn7KbiRgdKEg8qA/xcLfH8PdRMuK3
         OnFDN6TfU3as8qNz7nF5/ZoSyfDZiCudMZLBT2VY9YQhOSdt36jIkEz3g9lQACt6aY0b
         nmSeZt+9X4rmVb6xFvzUUn7sPScn8c7TGf4Sx/n6IPwFzB03laUPZZf2F36YzOc8HVEc
         M0IOUfQxR3oIZybR2+ws/iJ3YZnKJNKTUDsmYuoXJijAj1ACNU5tj0JXbMo8+k60yiHo
         XYHg==
X-Forwarded-Encrypted: i=1; AKwUvBx1+NvfTX3TW0EZl2MNDmX5xiJzFH9iymzA9bDLeC2BDUT94nPu8Z/BOyBG0YIFExEM/1GjGTvbUA==@kvack.org
X-Gm-Message-State: AFuF++l4yRGKCq6LgVVfPbxJM5qZYZiWgi41xqMkasSr1dMEhwlKUQeU
	HZll8rIT8+kgNcw+dOzhxGORJLbGjvievJHzUfRQdwwti/IxxvgHVMXI
X-Gm-Gg: AYBFou2Hfv0YCYvv+/f9XsWk8/UfAhqTJZFsRl8yFh+dwtsy/HzljYfzig5X+wgpV9s
	pnCLkmfDXYRVF5ObzeHnsHYddSCOqAEYbDD41NbTrHS7beJbP2pgKOcVZhAp5iFIB4WcRnUyXEF
	96mfAhLkWqmkvDftrX3hPJ8SxeM2Lx9TXQtTLGZ5g7p4elfbLL2rPAwbznfoDnfT6J48VV0Ro89
	sWGtEj7kgG+LyMduriTBYxMxQZ13R2GU03UUyV4UdMI82LdgSsHQ27IGcB4F8vAeL/RsUGloO8y
	+aQxPj3wBJd8sKM+m4ib+TdSPmN5ygGFtaUA9ILYcVxd2mioqIsDi2QvjyqiwIe+onZ2lG3pd9K
	apRov0meEFa6Wqbd1OtZ9iQP2nX4sIcQ8GmeGfENynTjnO6U0AhUVf6/UjMAALzUcnftQYSd1B/
	i2KW8iAHoIBtIF/bnlo8gj4gXWRZqzaCbhqxFtNpT3rkcV313bvPL+EdoaWmANWS1NtP9EP47cC
	jQtZrO/VpU3zKBiRxu3UEMa
X-Received: by 2002:a05:6a00:1a0d:b0:85f:4255:59a8 with SMTP id d2e1a72fcca58-85f42557303mr14081961b3a.10.1788440419002;
        Thu, 03 Sep 2026 06:00:19 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db23f7bccsm2980946b3a.10.2026.09.03.06.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 06:00:16 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
X-Google-Original-From: Wenjie Qi <qiwenjie@xiaomi.com>
To: jaegeuk@kernel.org,
	chao@kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	jack@suse.cz,
	axboe@kernel.dk,
	tz2294@columbia.edu,
	baohua@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: [PATCH v4 2/2] f2fs: enable buffered RWF_DONTCACHE
Date: Thu,  3 Sep 2026 20:59:53 +0800
Message-ID: <cd5bc4fbb9000e5936dfc96e97ed1e8ab94d0a94.1788438786.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788438786.git.qiwenjie@xiaomi.com>
References: <cover.1788438786.git.qiwenjie@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 75499140021
X-Stat-Signature: wtkqm918z59rr5nd7zwb1ux7wi7dgopc
X-HE-Tag: 1788440420-722484
X-HE-Meta: U2FsdGVkX1+PcsM37eBPhudmHWE9OPBgSBXnADz7JSKeBYAyVZZ2n5Yy4lqx2Glflo0BpqArhhZWAl1/+4nlGJoyOXC9fkD7YPDQC+nBRPd6hqB4PeWg7z24Fqo/8btE1Ry/sOOyUy2+1r/cS1y0ejcD+4tnEfATS8tLD3kDjVgO/ORI+msiDGKirrsjOX/I5UGtKr6F3oe/gY/3QBPNyAenFajhAD33wlkdfkfsEYYvxz46fX+jkMgzANpZ7xRIYZr7gH2iDSnR8dS12rMuWjhc0Vqf0haxeWq8/M7cWWLD2RSPyehH6QWGjWuQF01KUMTiG8ftPibahbGc9Z6JMLRBYtBvgYLUJVl532qGlXUs4+mFpT0psCxSW6jdvMEx3wvPrfh38pA1SSDWR20Pgs5hFvPk1HophqLIfgkZwGpabxrHIUvF6JKnFnyjsGa5CZpfXAXBbIDsOwj0suD2VNAfEXsXv5i2bQk9mCW0ZyfBOJVJxlbaxQ1mNxGT5qC+dSm0oNcYw8Flw9AaPp1BsFzgchF55V5OZ/JeB5ln33vAW543LUA2tJ79vnPEbw+mIMVkDkiFmoy7Ap3d0BrKAOGU2Lbb951kgutxHzf805Cb/goafd3Qds+xLoBVxcYtSmQh2pT19tF5RAFYIn/LH3TYc3/rye4v0dGgdK6RMBh0WnOtgYkZXDOicrtSo24GFzSxyLe+NvBvcQTV05HKRgD/IGh5yXrJNigk6eV5NUhHfgfozkRiCuYFH/ZWus3cZcHNaofkLnQLy/ccdTocmj4T5fJTMhZ34GHze2VghTnXgPOuf6GJqeXm5cGzoyLFqT3yxPvK91aGipWMRfUc9Covh1+3+IFNFFr5NjoRp6CARwfV+xJwHN9tK4I6stExWlVOsWx/QS0mlrrzdz3zXW/9vlMBr6c5ThEncF23GrGjqq/XMnO34mj3Qk44gX+d0IMtP46/NS5yDIGminn
 LG6sQozs
 t93tvI3IYUlmI70sEMCOXGtzFNDd9CMclcKD8iKqtvpVuH6Utt8QnkbyDy6MfceXZovES0lV+umAzkI5kag/VC9C50+ziBubS9rYBT/4HVZnznHNXx7ZAdbTLjTBQKE2DXElkfyReRaANwRD+5fEvaj2tLFVwRIM1dejSy7MPzRdbv0rT9VLWW4zUG4mgGC5xDZzl900JD/rMKWjLiSQZOuCzCVPaHsj65lJ3sIe9YDpywmuF1ihcTaf7l7JFnzsv5mA2uLgtMR5t734IYQ0tUY1a1M/D0GAHr8igPJE751pTNZdwCNMRd6gFeWm0cLwHcGFDfXv0n5GIKFa09932tTZJfr48Tu2nIwTC2PTLzVmyg/eX2FhAWZNh2apLYn1Ht2VF9ivezp/RbJhLBeGB55uHDeWAdEEAsyg9bS52Ljvhs2Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass FGP_DONTCACHE to f2fs_filemap_get_folio() for IOCB_DONTCACHE writes
and advertise FOP_DONTCACHE.

Keep the F2FS-specific lookup because write_begin_get_folio() adds
FGP_STABLE, which can deadlock here.

Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
---
 fs/f2fs/data.c | 9 ++++++---
 fs/f2fs/file.c | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b0fedacfd12..6e816c9349a 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3884,11 +3884,15 @@ static int f2fs_write_begin(const struct kiocb *iocb,
 	struct inode *inode = mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct folio *folio;
+	fgf_t fgp_flags = FGP_LOCK | FGP_WRITE | FGP_CREAT;
 	pgoff_t index = pos >> PAGE_SHIFT;
 	bool need_balance = false;
 	block_t blkaddr = NULL_ADDR;
 	int err = 0;
 
+	if (iocb->ki_flags & IOCB_DONTCACHE)
+		fgp_flags |= FGP_DONTCACHE;
+
 	trace_f2fs_write_begin(inode, pos, len);
 
 	if (!f2fs_is_checkpoint_ready(sbi)) {
@@ -3934,9 +3938,8 @@ static int f2fs_write_begin(const struct kiocb *iocb,
 	 * Do not use FGP_STABLE to avoid deadlock.
 	 * Will wait that below with our IO control.
 	 */
-	folio = f2fs_filemap_get_folio(mapping, index,
-				FGP_LOCK | FGP_WRITE | FGP_CREAT,
-				mapping_gfp_mask(mapping));
+	folio = f2fs_filemap_get_folio(mapping, index, fgp_flags,
+				       mapping_gfp_mask(mapping));
 	if (IS_ERR(folio)) {
 		err = PTR_ERR(folio);
 		goto fail;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index edc352569e8..570244ae4fc 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -5909,6 +5909,6 @@ const struct file_operations f2fs_file_operations = {
 	.splice_read	= f2fs_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fadvise	= f2fs_file_fadvise,
-	.fop_flags	= FOP_BUFFER_RASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
 	.setlease	= generic_setlease,
 };
-- 
2.43.0


