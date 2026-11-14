Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E26606A336
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=facCz0qq
Received: by kanga.kvack.org (Postfix)
	id EBD336B05B7; Sat, 14 Nov 2026 07:03:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45DB6B05B8; Sat, 14 Nov 2026 07:03:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF576B05B9; Sat, 14 Nov 2026 07:03:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACFF46B05B7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:03:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 307E41C1BF5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:36 +0000 (UTC)
X-FDA: 85433590032.15.7DD4CBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6BBC42000F
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=facCz0qq;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794657814;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wv8I5sT0IlSg6c2AVaztBfZxjeSqbtwOh/i1U+WLAMs=;
	b=HBeRjNXPgzsTJrR+QBO2FLncmD13pfENZOoWqfps4D327KFnsTfM2qbuRUBJyaBqQN9P/s
	+vPtyj43Pb648I95lyxxQmq4LVyXE3C4nu7AbpqfoiRPGLya3MQYNS19glwZPlggG7sWAj
	gIaUJg+PGPLZaLWwT+8ZssTfVQ14EvE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=facCz0qq;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794657814;
	b=sJCjwJCQ0nyHTjNadxuVwdCQVgUBa9wOEMzlPKEEBue1UH8J+0EofhjAbk2e4a0kmPAkkd
	2pTiWdM2IAvv43sOHlMjCGzUxK+euJsdvx83hNnv/93qS5KzRlHO0TrVRJauCQv5n0JG7n
	94zyzolbsqoRHf4uU6gyEFw55oDRb2g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D61145D3C;
	Sat, 14 Nov 2026 12:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A9B1F000C5;
	Sat, 14 Nov 2026 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657813;
	bh=Wv8I5sT0IlSg6c2AVaztBfZxjeSqbtwOh/i1U+WLAMs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=facCz0qqs9QrwkdnVkScfrWc4RWGu0fgu+gPH1rhfIGd2cxJQ2KSJ/ctGaPNos2xi
	 yWhxu7QJ0i6YpbkN1Wc7D2N4KWL4torud90tRKqnT6ebGmQdOGnRAv7l3HnBZhDBeD
	 dTbRGlUT6jWcK5MpPZwGqYZCs6bj2fMnoEOWDQ+NoPZXgiTSdKMWs2m4EXF8YJ6NhV
	 r/j2o+eDJOR6wn2tJuY5RiKieaDzELDUnGuzt4memBBwaPzmLhfkDG/rL/Smd3sOZ3
	 mZ+VG+Xng4Jy/xzTFLsbuNEpb29N0PWcpdH+7/NnfZ0DANXp4W53CWW62b9PrVL4Ef
	 KXJ02F5rI1Fnw==
Message-ID: <sashiko-outbox-214464@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 13/33] hfs: don't set SB_RDONLY after MDB write
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, "Viacheslav
 Dubeyko" <slava@dubeyko.com>, dsterba@suse.cz, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-13-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-13-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:32 +0000
X-Stat-Signature: x76ncsnpyuq1yoh9qzc5dym5wpoinqos
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6BBC42000F
X-HE-Tag: 1794657814-683926
X-HE-Meta: U2FsdGVkX1+hcPlocwHPghVXlZnECqTLb+PfkgDLmVT9FPU+osqvGpnCPwrbbePkqD+W+OCVWNjvpGG7WmMlDtvpj7GX3WisnenbENn4uklVx/ZNxVek5F0i5Wlt36Keda9+zwCt1eSnE9hu14yCmi6yntBrjG4vLMimQCE5k75BDNDiFXjwN/sT9wGf83ST699vIGYlDT1+T/Pde0s/WIWQ6vHxtL6DU8K8zjWnT6qMTdkLiHNuz4woi3vTOcPMonIa/so/lsXVYbgCQoDEa6rRqbRCGlLSswdWQskAOo2eSRxXmwEfUTU0V3N31GMqrvfFZx7toggJQrEYTsYYdcCbXHmiToX82KrNtmOoXpuU/BMjlF2w9lL/lIqZvvh42ikBjgQArp6HseXgFV/1pWybNQOUY4IjLPun54Qz0sL2Fv1anAz4zXwo0BmiuZSZX9y1xFAsffJgYgEP24tNUS4qhkAOO2rQy9xsre/tKgkB4BPUrmm1jAmQQbMpoVCnB3Cm3SHnyS6wEohyAfVjrcDOJlCsjPgzglBv+bu969dd+05aciOqa8EQSf4z8qF3L7MvHrhnmTsZKvSK9vp2PdFnOF8iLN+3tYIo27brgKVcRQbl/BMKdtr6EHIwnn3VNx6VZ4HGZwpgIspWfEtRv4iwNG0il5Rqbe9irwCByjZCm9Bqp9HaaVVkpUt6xuRICeT9gSucgE+6sMJU5eiBKFzwUnAsgyotpvwGdYUL41vMltIgXvwInOJrUHEdwwnCgYRDHb5fak07QDkcD2DA5zpnGCjY4br4eo8riPF71whmlpfvGFO1DfvSJo17f5WXpnzva9JNU9xL9P/7DPWxDjqUhT+0IqL6idHw6wkIoG3sZW9/X2O08SvPeUnjIgnMf74d0tAwtowc5l1TF6pKpslRaeRcWeZJ4FCtAnWSaGePCb2V7OKXYe958lxKJ0RyjwVtM3ZFLqwYw/hHDzc
 PawM9SaA
 g+s+1Pqd2I98SBo3R/N9kv86LuQpR05uaxN3gaMJij/H5uUC3y4f6FfkkdnozYF11pI2qs3LAOZoPb/TLXKLMIU198xLeSM+MG91wIHcZ0GBwLA87JilEqKFPyxXUpVYKcq0SLAokKPjGxh3EVHfMKIQzipveVeS3W68wfyiOQmL3eRVXqBsKGolXrJMxxCXX1+NAenjHa6UP8gPHTFsBgdkjQ9TEA3r7nJPoe0Kx874NMk2YpfyYLBE3+xCzjIJiRwRyNghnNxmlOBlQF7iGp377Jwel79aagd8hhuH9jlupZR65MnDdajqKYsoaIvh0+FJg0JP6elZC7aYQ3F8h56hOmtvBvtyNdXk47US2GOzDPka3grvjeWQYmgC+3uBdHrAOx5lF//iFHpCkbsOMqw3Epf5hljfPqG0kbKIPzvIJvefMoc2SehoK9BdFugjGNHbZZWvP2w3M/sxAiLeo2+dF6gxvvO6CzcQ9SsAEQOdjkfq4BUM+3KL5qq74dO2D5tjsulixG+L/C6yQS7Rhmydzx9OVgG+UFy3Wb8iaFLfVwYsNrViTMNmhwxubtxO09Z+wO3jq/qde6sYh5O2D2LRG4RhnctUoGDZmEtCy0OC8NdT9wiohI88ASm4lAFdScF+ljwy/1M5mqgw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] hfs: early return in hfs_file_truncate() corrupts inode and
  catalog sizes
--

commit bfa80e19c6c9ea6b12943abb2839781be7835d98
Author: Christian Brauner <brauner@kernel.org>

hfs: don't set SB_RDONLY after MDB write errors

Instead of setting SB_RDONLY without holding s_umount when an MDB write
fails, this commit introduces HFS_FLG_EMERGENCY_RO and rejects filesystem
modifications with -EROFS once the flag is set.

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
Can returning at the top of hfs_file_truncate() leave inode->i_size out
of sync with HFS_I(inode)->phys_size and HFS_I(inode)->alloc_blocks?

CPU0                                  CPU1
hfs_inode_setattr()
  hfs_emergency_ro(sb) -> false
  inode_dio_wait(inode)
                                      hfs_mdb_commit()
                                        set_bit(HFS_FLG_EMERGENCY_RO, ...)
  truncate_setsize(inode, ia_size)
  hfs_file_truncate(inode)
    if (hfs_emergency_ro(sb))
      return;  <-- skips i_size rollback
  mark_inode_dirty(inode)

When an expanding truncate hits -EROFS in hfs_write_begin(), the
inode->i_size > HFS_I(inode)->phys_size branch normally resets
inode->i_size =3D HFS_I(inode)->phys_size.  Returning before that branch
leaves inode->i_size expanded without allocated blocks, and because
hfs_write_inode() still runs after an MDB error, writeback persists
LgLen > PyLen into the catalog B-tree record via hfs_inode_write_fork().

Similarly, if an extending write allocates blocks in hfs_get_block() and
then fails a later block allocation after HFS_FLG_EMERGENCY_RO is set,
hfs_write_failed() -> hfs_file_truncate() returns before the out: label
resets phys_size, fs_blocks, and the inode byte count back to
inode->i_size.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D13

