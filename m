Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97301C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 564B06B0092; Sun, 30 Aug 2026 00:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514B76B0096; Sun, 30 Aug 2026 00:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A6C6B0098; Sun, 30 Aug 2026 00:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15B5B6B0092
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:19:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 836A580257
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:19 +0000 (UTC)
X-FDA: 85156631238.12.D408B16
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id D892280002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WlAnPemS;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788063558;
	b=nZ4bUOEHPvBh1u+emA2ZaUs10tvhPR3XX7DKa+Y1Ji1k7BrultEqHWrqr/AkS28Ri4DrmN
	/sNbPdwAxhoFjcYfApzWZgskHp4OJy4DCthX7tTHAQk7pqbYmQE0Uc1BvI/oqPQ6n7+4Qh
	td+fP5EWnN5PcedcaRiOHxSWhR9sVOU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WlAnPemS;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788063558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sAVqQaDD0nzQkp3zhExFeGOqa+2+Hy4Fdk9PRQI1fM0=;
	b=fhsV3XXmpdfq/zvcKf0Liv5qGpRK4S9D2g/CKkTiL2jDs3OzIE3DN6CLHbKf3wXX+riTaO
	9QW6XZGIk30NFwTkwW1WCCd7LAPl/MFrjbt9TfVYLZMKH0NCAoQPpnWGgUv63UF98Qh9R9
	gVxrawnG79E1S6QhP1Gl6peorhlgkJ0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=sAVqQaDD0nzQkp3zhExFeGOqa+2+Hy4Fdk9PRQI1fM0=; b=WlAnPemS/R3wjjMsjkr3aofwS9
	6+ju9+kQC8VWeYQe+2IMhIT2Ko4MIpm9T7B0Lmm4+/Uf13Fwv8n715o7H+hWFddniZcLhAJHjjiiT
	aA/migYecE82jkMkMMno5/JuEXsrfN8WoUpiMiBkPVeWqz6axs0dVwulU9dCBTp+IdoSnPAkf8xcF
	YL0wyjvMwNGrulHZepPot54Pow7G/n21dtGCExy83ftylOY2SG0+rm98uLlu8rzis9gkxjUassWDi
	GOIryltiIV4homH5urnoNY/qK3Nlb1+CoSZyheJTky/4EyXoGDGMC8FQvASOJOANDxQLnuv/J2DyQ
	0jOAQa3g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000hU-1DZI;
	Sun, 30 Aug 2026 04:19:03 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <christian@brauner.io>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Theodore Tso" <tytso@mit.edu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/9] ntfs: Remove FGP_NOFS from __ntfs_inode_resident_attr_pwrite()
Date: Sun, 30 Aug 2026 05:18:52 +0100
Message-ID: <20260830041901.2668-6-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830041901.2668-1-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D892280002
X-Stat-Signature: sq9zx8x53tan5abebpg1ho8nmsz6w1r5
X-Rspam-User: 
X-HE-Tag: 1788063557-637460
X-HE-Meta: U2FsdGVkX1+vfmJBjUvjnn79bnA3KK0k+w1YkfamB1PjM43Q6ZPKhrD8T+ZVYGejhh2MM6iU46l9OrP9xstaVccyeXdW4RKBraAsjaLESnF0VHb8DC6eORftNMJJ/fZn5zhvTTBgbkTX7NQCwHOAVuMJ90VnMtHD/CY0GVjV6kVaka/4hEK3KxOWSv+JKItNaqPSV22wF5jl3bIBNMwYVE78piptZ96B33jHjIoqcuD+n7vmQhXnPkDWVJ3It5x+OPpBQCEwiKL/MHgTa9z15ZGO8fNnat1bY+5Z+l/kSnKvSNzr2yj/SW3qmqFxumZY2k/XQsDvfiUMxOruGUySJrazjTyK1wA+Ns+68xSgwQt7IKspAYmqR5o8nsKZqIs6MSDnkw7s1fbWsgfnxWAA4c2lPEPg7MEBnVxnHwm+d1e0qh8ElWv487PCjt8fJIbfH3Wp9/gPkHD8k/+Ib8L8bfbWbLckX97xqCeQc2Led+bC+Q4MCEJIkrLjqroaahYOfx92V7BvrVpRdzpfVu/ef4UqDomPa91rj9aozssBSSMl45hD57Fd5M9oKODdlmmk4BZqfoK8Cw9aZtZjJXY5bmbE9hHr8dAk4HiQDZ0Z0TOSHwU+kCok6Jx55/UtBCyZVJfUF6IkEMszASJmA5np5UMUiYQJOeO8K0Mp9cnQ87XU7XWa5b34invqZNh1OCtHyvSkKIZcsYIMxLo9B/2zI9ufrP9+3Bjbsf9BeZqsh2ceocvxKZFsY6xcVeE804JulQNKjzgM05jhEEjzdc1fK3SHin08WhS0jY9xALUrN6i4LK8PGna07To5t+FMZ80aru1rY10Q+Ez0J+W8Phk1ZabTNZ+I3v967Nvilx43mAe4KgO/9BrWjsIViMRfY4u1DzG3rX+H91oVyNu7eBdyC+KmnaUm1ChZg0LaR+Jn6JBTQdL8Y7cAEIJdJ4o9KKmhgf64ZPDMEwtiftNeJfC
 ENrxlDRN
 GvphCRpcF3X3E/+cMpzAWPdoeIbqnU5NqOVKCXBT4i4FgS4Whagq1OJL2yWiPlvS9uV2+cwhmv58EMiFdbUa/Rx9iKbpdRjmlX+PhXWy+XpvmWG2bvLaYrSW/pHlVPbsgaJsY4v20XB9oP8NaTYFbn+khTpRZ/NhLKWGvA3Ir0l8Il462RJrB+6l1Z6fl5Nid+0S9MROyvRphByLT3OEWzYGDuZhKdCWPwqUZBuq+qmRcn1pHHKX9aY9eofdtplCMINGVQn0lU+vlpjpjvR1X2/M+zn7DDQLW0M6Ha0mgeTflkSBtD+JkOlzuJL6aejCuZUSmAltaoqZr9msmOw8k9qBApMYCd0kXjhyOKxuDMuWRz3O6f0zt17Y463PEVKNYyHE6CUkr22ddv/dwFtNeqoYgIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I do not believe that FGP_NOFS is needed here.  This function is called
from one place (ntfs_inode_attr_pwrite) which calls either this function
or __ntfs_inode_non_resident_attr_pwrite().  The latter function does not
use FGP_NOFS in its calls to allocate pagecaache memory, so it should not
be needed here either.  If it turns out to be needed by both functions,
then we should use memalloc_nofs_save at a higher level to protect both
of them.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ntfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 32edb4045178..36a0d6b26c02 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -3676,7 +3676,7 @@ static s64 __ntfs_inode_resident_attr_pwrite(struct inode *vi,
 	mark_mft_record_dirty(ctx->ntfs_ino);
 
 	/* Keep the first page clean and uptodate */
-	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
+	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
 				   mapping_gfp_mask(mapping));
 	if (IS_ERR(folio)) {
 		err = PTR_ERR(folio);
-- 
2.47.3


