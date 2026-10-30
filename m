Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 224F060A260A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IjvECOsR
Received: by kanga.kvack.org (Postfix)
	id DC1516B05BD; Fri, 30 Oct 2026 12:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49846B05BE; Fri, 30 Oct 2026 12:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74F76B05BF; Fri, 30 Oct 2026 12:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 758316B05BD
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:10:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0395A80719
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:10:00 +0000 (UTC)
X-FDA: 85379779002.07.B6A9B1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6428014000A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:09:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IjvECOsR;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376599;
	b=spqWbj38jRLEDmp53th+B1cX6TprYvOfMeD1Vzo3E31u3HC576WAzD3QsPk/evecrC2dGM
	B5ls8c+d3ttQFPbG7XewD5RLDrHrKTalQzzwJsIpmz32Mk02XcEGEB/rWVFbHf25IIP7yX
	fybnUbrsUvO5aN5dUClxrDe3j9FXK2c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IjvECOsR;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376599;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4f6c50MfKRylF6izNPl1SWtjUxb1UX+AC8qxKNq77dA=;
	b=sKHc6df9wLff1bcCm8B0PIGyG7B2Dng0J03wV5JNCzTJvkIGCU8LK0+c65JsYsfn+TSzIy
	ZFTXJb7ROOpFupmOfYiaUTWOdgELASctyh2MXfkDSzt4E3xOKlwtwwSR3AyVJ/52+gPKIg
	wLO89gEbEW9b+PaLEmnEkEww3pWAIv4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1EDB602CA;
	Fri, 30 Oct 2026 16:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166301F00A15;
	Fri, 30 Oct 2026 16:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376598;
	bh=4f6c50MfKRylF6izNPl1SWtjUxb1UX+AC8qxKNq77dA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IjvECOsR6+cnwW+krKeqX6TWhRgnEw9YrQrOV40dgHGPIARR3NcGCDrCO8QmiyCTp
	 NU4YH/77lOTvaxi5pAjiJbATh+MA87TeI//mtDuR3M15qQBq6MLFYWpjzkg7cxNo1F
	 RDP4/uHtg6C/SfjJE5m0lya+LI8G6mipsibVliUbT+rLKJrjEn0q7YFtOAlR/+WNBG
	 gugCjVV7pCiYzTEAEgZfKDnxClW6QVjCbSHi4iZF/94oRuVLUfJlL+fWm3B7TWhHQN
	 3zSPIyAuaDdvu2VVfvm2KPlCyUdQxO973uAa2inK4Tl4yKoomQIlqFcssrisdcSKAH
	 aJMmtl3Xtmedg==
Message-ID: <sashiko-outbox-191230@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/34] hfs: don't set SB_RDONLY after MDB write
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, "Viacheslav
 Dubeyko" <slava@dubeyko.com>, dsterba@suse.cz, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-11-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-11-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:57 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: 6428014000A
X-Stat-Signature: wjixqwd5ewze1rqespxqzsdxj194ro4h
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793376599-335923
X-HE-Meta: U2FsdGVkX1+0gkc6rc7PZ2fyFhtxgtKmewgy1PGpmfrDPL77FYacDvscXtZDghzSfk7AfKl5nZTZ7Atky/TLrihCqfyfN/BugXqxvGyJErw4jTG7kaHrxeQAk2Z7bL8XsRI0nazcDA/0dClRm6yWWoGtkPRMA6Vz2p4FWX7hhDxGw7tioZDtH/ls5InZx0zWlTIKXelQbis8ieoY+tbifIINVOK/7ysa0unxs1rSjsbBjJHrTSkuTTQPMpsXoOLh5bJlYJN2FUBnW3P0dJ8yWeRSj1mXv4SW4bsho4Dl2R+ilVL+StkOy/OcQ4NOpkhQz1WhlT9+9LkPQqkJuuEpHQ3nC0ZtLhRkN9ylFjP4Q+3AFXvYCjoEFneHm6M+FndJ77ITyCWeLju0BhaiIWQyEurYqOuCaZpv5v1OaUqzt8gOROS6obtr0dqJpYHjdYwsw4GhkJvwiMTkU4G4pZr1rB/moArAmaKlQ2eTBYwbA0+/HUIZ4ioWOArOJ+633SRyXbeq5fryLigo2kCsxbu9xcJzH3cuU+UPTF4t7L50pusGzckeaPxIp/eLeJTigaAxigL0bSAWyN/VmYkY+7+VwM3EFt1MGFGK90WMo/3u/EFDH1bYj8U2nIyT8iRtf+h4NPibBGyxCzbnpMgKKRAfag2f4nVqcuGbFkOQzGnaLjF+l6YTca7ILfNk/JQcy4IBAvscowRSkL+yloFE5+ZytbgPq2HzV5/1AbJjW/4tlTIRuIj4rn5Ij7j16qqTyXLMV/E9CfuOygKXlJbX1lv/KFvzEfXlMqV41Jsvwkm+lyFqJaE3GxIPPFcIgld/Wo87HEKD8V9rJAP938+5Z8CP2HqqguYuC+BTHFniTJv3yKcHWm7EjLjiKddFo4R/G8sqUPhQ9h3EpHAZCbiMkqoSNYZL9wKARLzbAl5jW4S5WuSj+e1IfZh+Z8B17+g3m+KO8EvwaiFRDQLnzb4GNWJ
 L1cP0+py
 LUnO7ztdfHogEW7nvVd7kKmHeY+BnlpXapErxW6ErOVqbBZF1kdQu1Ua6dLVdK5rCBOvGdkIZH/F9Z0+zXdlXfOTPRqB7bQEUePe/9jLhb4BQI1MeS0k6ptgdb7YCIjN09hh20PPzS+aPBI3chDpqU1mGvllJaUzttt8pILnhedv+HgNePSmNHqcBz8vvC9Nth4AjhzksBlG81xWkOAUm3c1GQfiYIxDFbOccbZJcEmHHx46kKhP1nB/8OX+QXwAZv8d2hldVTjICxkTo5ieQg6nIaUZI8ovsWolKeKud2Va3z0fcxAQDR4ZjnPiYsXRdQDCoyyQD75NWvyKjbiNxUpB0KjmMjFIVv9wNvCRQm/t8rIgxcThpBHhd8F4c8jFSbZw7tg0yiZjzYEKjLYiLNeoaDayK5FyBoJFA2G34o8YnoljkkVefAAtrE5wsFQSB5Qb2/YTlDll9fq3bWHhXCf0X53BYj6rHBNNLWKiEPdGyjeiBCV9WtuOAKZ+tj5dV9F+WWj8JnMvi6xrJrLm6/R12XIs3xD+Fk8ij0/qRT5LfD/Hunh75Im/osHe07k8COjCwELWwevcijAnzie08Kb3JjSpEQQiJ5Si9F9OgIkV7s0AoaY/31hB9M0lpVdCkk9QB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] hfs: hfs_file_truncate() early return leaves in-memory inode siz=
es inconsistent
--

commit a6e743f06af9edb59d94367cc189bbdb5b8bd883
Author: Christian Brauner <brauner@kernel.org>

hfs: don't set SB_RDONLY after MDB write errors

Instead of setting SB_RDONLY without holding s_umount when an MDB write fai=
ls,
this commit records the error in a new HFS_FLG_EMERGENCY_RO flag and rejects
subsequent filesystem modifications with EROFS.

> diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
> index 26357086517fc..dacf7ce1ffe4a 100644
> --- a/fs/hfs/extent.c
> +++ b/fs/hfs/extent.c

[ ... ]

> @@ -491,6 +494,8 @@ void hfs_file_truncate(struct inode *inode)
>  	hfs_dbg("ino %llu, phys_size %llu -> i_size %llu\n",
>  		inode->i_ino, (long long)HFS_I(inode)->phys_size,
>  		inode->i_size);
> +	if (unlikely(hfs_emergency_ro(sb)))
> +		return;
>  	if (inode->i_size > HFS_I(inode)->phys_size) {
>  		struct address_space *mapping =3D inode->i_mapping;
>  		void *fsdata =3D NULL;

[Severity: Medium]
Can returning at the top of hfs_file_truncate() in fs/hfs/extent.c leave
in-memory inode size metadata inconsistent when HFS_FLG_EMERGENCY_RO (or
SB_STATE_EMERGENCY_RO in the follow-up commit "hfs: use the generic
emergency read-only state") is set concurrently by the mdb_work worker or
sync_fs()?

First, in the expanding truncate path via hfs_inode_setattr() in
fs/hfs/inode.c (or notify_change() in the follow-up commit):

    if ((attr->ia_valid & ATTR_SIZE) &&
        attr->ia_size !=3D i_size_read(inode)) {
            inode_dio_wait(inode);

            error =3D inode_newsize_ok(inode, attr->ia_size);
            if (error)
                    return error;

            truncate_setsize(inode, attr->ia_size);
            hfs_file_truncate(inode);

If HFS_FLG_EMERGENCY_RO is set after the initial read-only check (for
example, while waiting in inode_dio_wait()), truncate_setsize() updates
inode->i_size and then hfs_file_truncate() returns early before reaching
the expansion block:

    if (inode->i_size > HFS_I(inode)->phys_size) {
            ...
            res =3D hfs_write_begin(NULL, mapping, size + 1, 0, &folio,
                            &fsdata);
            ...
            if (res)
                    inode->i_size =3D HFS_I(inode)->phys_size;
            return;
    }

Without the early return, hfs_write_begin() fails with -EROFS and reverts
inode->i_size back to HFS_I(inode)->phys_size. With the early return,
hfs_inode_setattr() succeeds with inode->i_size larger than
HFS_I(inode)->phys_size and HFS_I(inode)->fs_blocks, causing subsequent
buffered reads via hfs_read_folio() -> block_read_full_folio() ->
hfs_get_block() to see unallocated blocks and return zero-filled pages up
to the new inode->i_size.

Second, when an extending write in hfs_write_begin() or hfs_direct_IO()
allocates some blocks via hfs_get_block() (incrementing
HFS_I(inode)->phys_size, HFS_I(inode)->fs_blocks, and inode->i_bytes) and
then hits -EROFS on a subsequent block after HFS_FLG_EMERGENCY_RO is set,
error cleanup calls hfs_write_failed():

    static void hfs_write_failed(struct address_space *mapping, loff_t to)
    {
            struct inode *inode =3D mapping->host;

            if (to > inode->i_size) {
                    truncate_pagecache(inode, inode->i_size);
                    hfs_file_truncate(inode);
            }
    }

Returning early at the top of hfs_file_truncate() skips the out: label
adjustments as well, leaving HFS_I(inode)->phys_size,
HFS_I(inode)->fs_blocks, and the inode byte count inflated past
inode->i_size.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D11

