Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BB8FEC1426
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11F86B008A; Tue,  3 Mar 2026 05:35:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1FF6B00F5; Tue,  3 Mar 2026 05:35:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B406B00FA; Tue,  3 Mar 2026 05:35:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 932BB6B008A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 556811B7B77
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:02 +0000 (UTC)
X-FDA: 84504394044.25.5107BC7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2EB2B1A000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=cw+6ngnFUgJ4De50pxlimiOJPmgzcRpTUyzgRPMVl61tK3UOzVJn37zWVApUI6mWi+oKAf
	+06Fam03OuseOGuD6EhMUDgQ4fisYrN8euM1D3y3R2OafSN8hYryJ4pkxdMy/EIV8WkcPh
	VUMYs7+LTqPGKC1t+NBTFqcDqnPK2s0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534100; a=rsa-sha256;
	cv=none;
	b=GpuCrU/hNNge3aZF/0khYNUGUZuexMVGdIvEDNvC1+T3e6AtZqcH3FhzdM8oPQU6x4dvEl
	0rZH1sVMrtZI5/kRa8G06y/17u/mvCCl1NQgCg3276cXF7eOZycoHVswRzL8KynwvLdc2u
	Mqg3Ns5pqWCu3T5d48nPSyTWqK1nZsw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0350F5BE05;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E95B63EA6F;
	Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PDP4OES5pmltFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 88128A0B3A; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 08/32] affs: Sync and invalidate metadata buffers from affs_evict_inode()
Date: Tue,  3 Mar 2026 11:33:57 +0100
Message-ID: <20260303103406.4355-40-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=759; i=jack@suse.cz; h=from:subject; bh=NDPLTZYpyB8AvjWnfTi4NCpTDfiFBgirFbbT2/Tf5G4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkk8HckfhJ1pkI9JwuC2AULW5aPa2lEuXAbV pQDis2S6F+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5JAAKCRCcnaoHP2RA 2VFcB/41q8HZKDIyAi9JxfZV2iGf/oWzNNQqiIJu/TgJ83dhPE9JdflB+QrDuZ5WfWU2+g6BnDd 6TbFhNQ7N/GBBAW7OF8mCHQ3CwOAQf+zGJF4sm87/0Um7Cn/fpIOecJsKuVVQZrn7h4roCLAj/b J9WZceJCnZUkZoWPbl6JWLzlCtCnhCVDfHBinSApEgSuDp7g08pLQ+GLT5e+71QrF8saJqnQo5p oUJurV3B9ZeYu3k5S3HIB3JuuoPuuXCwEstfzcII5Fjo5kh+t+jb0bOPZjY0U/c9Wj3DtTung41 IQFDRdiyX/bQtHRK/mcCv1Q2ScIF+tm3tT/3K7+DEDeEsd0z
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: xfw54g3ryahr57ca9qqfru33iqy5aoeg
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EB2B1A000B
X-HE-Tag: 1772534099-587147
X-HE-Meta: U2FsdGVkX1/ulkjp/uIvgaIxf5VBjldYVHy5YoGgRCIXKMtZSPagkAtZUrz05C006bzwbb0mEIH/fWJGAQG73MPAxXRO85bO3vTWpKUl8naXs3gyaDjL35674h4LQZjAvt9PBfVfk5W0Jve+mO0X89pSwtRSTHjLW5yK2TcahbeE2BnnYiE3Aj+NdzuzLHuK/MIf1ZH+qfTamnt4M6sbH+IMhjJshNNC2RL0Z8NzRnc2zJJ2o1pyTRKQRuHpho8YmXojN1Xg0SPHle37kdn5EZ2ZfGELFWfaM2glrHSareL8jBytNkls12nvPgHlSWJKTnKT8XQHgysRjvvmK5aTRrc7hGPg20qeE7h9L4jH6avsylAIv1rFDxWAD0kJxnyxCD+BSTjWeKdFUE0UiE+AyhTyxPpGvWRnodTbFq38FcNjRX9g9ldwsxLzwazwvB3WKFOeVVmC577UAxfNeO+vfRly5kv0x9L4zmloWHTxaPu3QhlW0nZ9yrspZTh5VmGK4ILwcav7S5IXpx/OIccWA14UsUvEYATrZeGdxE0Hpfh0GrP0wmjRInN89QExLwE9Jith1vNdZGvTOrUmR58pVgKHetiaxmyJRiTrpWwsFjpWjuh1sscBF4Z4TXddX3CGT/YdFsG3xjyWzMN45Ss3ywR682KtxoRXpYmQI364dOgRJ4gSsMYeQ/kf+11IbUuJZEZ8nBOjbqWGXepPU87S6rg34ll5GHQgTtzb0lLM/jnL7PxTm/9EAejVDu17ErSc+IuWeJi+9ZFY5yr3J9ADZtWt+bhQD9mkKZa/4N55ovyrE6fn/YHpNI25WHWVbEEGUSAIa943wqdKUWWl2zhoSvgOIaPFKGiXtlhGdUxpT/0zfxsP5zwR+FuJj+6KVlT5rWzKpyPHuhgoiVAZMzcArqEBBuuFf6zuOzLFTAHhuBwpHVo9ONsig3LHn8r5MwxYbJBjYYpub72AVn7nxKD
 t4E9WgMv
 P3X2WWhXQrEwjhAW4/BJP81mTJ4w2Mi6FQ92UHy6lL9RXxqqByL73xmIui1kauyGGbc5HHqdyOeYoWpy1qh/muvzvnbDSjafe/7dabgwEHbwVs3SrR0FNteREhCL27bhZULzVebdHD5i7X3OW+q+1qyeLiEyW/I5B6vznR+0Z3rOzLAk8CRIwCjkFyb+sA9EEhdee
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/affs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 0bfc7d151dcd..84afa862f220 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -267,6 +267,8 @@ affs_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		affs_truncate(inode);
+	} else {
+		sync_mapping_buffers(&inode->i_data);
 	}
 
 	invalidate_inode_buffers(inode);
-- 
2.51.0


