Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8711E606A31D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 00:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ZJ8v7qQv
Received: by kanga.kvack.org (Postfix)
	id 9B85B6B00EF; Sat, 31 Oct 2026 20:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942816B05B1; Sat, 31 Oct 2026 20:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E38E6B05B2; Sat, 31 Oct 2026 20:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4691E6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:33:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A9FB94079F
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 00:33:43 +0000 (UTC)
X-FDA: 85384677126.05.717272C
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id AC1F6180005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 00:33:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=dubeyko-com.20260707.gappssmtp.com header.s=20260707 header.b=ZJ8v7qQv;
	spf=pass (imf24.hostedemail.com: domain of slava@dubeyko.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=slava@dubeyko.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793493221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/OyNuE+u9LVqbLjPn4c642Wjld5y0QKeGGJuFQ0QfKY=;
	b=8dzCVKu1y7nU/rPOKhKjoE/PBcRfhhe5ctGJPv2Z8VeREIFk2IGVjz1BsJRl29IGGZqhha
	DtjY0+JGoC08Un9E89MjmPgS3qnarUlbjEThp06vDMX28DWm21+gh/absJY4mGGyXm74OR
	JDP7vLU5Wb8fapa9Pc3JEcqR+bDvTg8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793493221;
	b=QRPzsxut6waWB3rARPWYovz8Wmj5m+hnZUZBXQCMHaZVClJAPn0ctIOxaA7CN5GwOEhVj/
	h1DPJ3ghUttaeNyUDC9tK08vh1DdUIMBOBhiV1n9SePvg5toCQqZrIUokiBbWkgBWT0qyY
	JeE992QZHB80bTEVMNRtfKBegpFgFts=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=dubeyko-com.20260707.gappssmtp.com header.s=20260707 header.b=ZJ8v7qQv;
	spf=pass (imf24.hostedemail.com: domain of slava@dubeyko.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=slava@dubeyko.com;
	dmarc=none
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-677bc4704cbso1601755d50.0
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20260707.gappssmtp.com; s=20260707; t=1793493221; x=1794098021; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/OyNuE+u9LVqbLjPn4c642Wjld5y0QKeGGJuFQ0QfKY=;
        b=ZJ8v7qQv4CB+Wl1eyLU0FG4Wd0l94ZH1BqRSG+areRTfyfEJ/2eBFMQLc+aWboybq0
         0VdxyfYdQWiRfimtc/492svhSjiLDl44HumynbYI3ay0NWqVju7RSxbls6l1ApYRfpS8
         g40ea40MEJloj4OlNS91Kd2TSCMvoPkRpuoQ10Bb8x2D6suhnhHMTN9V885IZFWe75rc
         rlY0+Z8kii81DQN10KYe0jw/96SiApJykmd74J1iheIIB++zX8kEl8RhjJkxZXNurTZ+
         NZW5dNIuSvTjZXKZ9glkGAgHc8rthymhzep/Gus/UGbbjRuvEZwSQ+IPx14qQP+XFtMu
         FFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793493221; x=1794098021;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/OyNuE+u9LVqbLjPn4c642Wjld5y0QKeGGJuFQ0QfKY=;
        b=F2E7BlR9r6UPQwAz4KKB3UO2NU4MJixXFzD0TiWUz4oFxL/lCXyBZFxBD8D7cQYN/F
         P0bsASwKnwjnijVVyEB7NRp0bRyd9TvPBxcbh2FZU6IPp86MEZdgwHlYyQCtC7qCtrKX
         jS7iOl92yalx0vNEkXPl5ukpj8F+BIZL5Jj23ru2AEVHWf535o5y6nmmDntfZq4p2zSj
         yWE//tekwG28yd/66K0OZXg39FuXM9owXF8fqHsxNjw6fW+2/WN/gydUhPfykZv0DTrn
         mINjb6uYjoH/lczSZ1Zf3k0w4EDpX7yRbckyg+bPj0vxSh4Yn3V+iQiYdZljbbMDmv7Z
         68SA==
X-Forwarded-Encrypted: i=1; AKwUvByJazrsOChUbGVdj9m2+c535oTT6RUj0hgIsiTpm7rtdALV0XwhTKZfLr05b4Q+wXzNzOBq+IG9AA==@kvack.org
X-Gm-Message-State: APuU4Z8GEzbHdYGuXqdIOFlWckgHKCPyoX/HcTK+DazgyEQIwaqNtYd4
	rMCcqrfuc8JRnDebR7T7CHxjlj2S7R3aEAyuyqz2KOwL0VTl3v6FZIbCH5k5Z86qiho=
X-Gm-Gg: AYBFou2dGEs1SLH10clB1Cwr5OAHD1k1NAvUSMFkA4JPRNV7N15fqepdFuRvne3MuiC
	ZX/7W+u/PPJ6z5ozgVwWUXb1ld1GanF+Efhu3va/CreHhdtsBqipKk3+E59HuMvgS+7toZTI9gW
	SmWyUYUbL7pgH1XJBvdH1LAqvSSU805qSjaXx4TjZHD8NbcE8kq+1VQu91qmhHPcfjYEM9f54mA
	o4SxjjIdp/Py9jdyyH8HlTAo9ZFdFCwd51roIm2sK6tH9aRNjf3K8QrU/YMlCfSEqdfEYga0MSW
	8YxvhKU5C/r7OzbiM+PGixAEYvrFLrMp7OYO9ioOrOXXWlRt59mExpxUXX5JpA5SNo/5qpGnKqu
	iJI540JR9PXoMiNylusvRGZnJ8V6ZOmP0VP3tFwBnEjc1Q+mM+NmwfWyrA85rmohvXrBRJgMN1y
	Z4ik3MfTpbf8gtHn/EqWX+QcaAWSreIUkj2jjHT2IXTnxmA+oUpvNDSR0OeHbhyG6VdZwKwlxZP
	mVWixAmrfRfp7vlboJXvIDPed2SGMe9Lv8Nd7W3BjlXe5GaSJ1GavgMI6pVr5rIyXHgKjI05MMG
	a7lTOlXEhYTyIOj3kOgK16hJQq2S+//q9z2Ml3DdyxGYABOnF+WryzdG6/UQ3gM5QeNTj6P7uI+
	E+OWcEwiKzeJEUWKTTA72xdttUEux5evRvgrSwbV7tQ8GNR5sMFKSe61s3bkAeQJg5wsheCFM/+
	V4x8xAzuMGz0B2rJqK9CA=
X-Received: by 2002:a05:690e:140e:b0:675:3d40:3c34 with SMTP id 956f58d0204a3-67bb3041657mr1552875d50.68.1793493220725;
        Sat, 31 Oct 2026 17:33:40 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:6f84:fe3e:51d2:f3cd? ([2600:1700:6476:1430:6f84:fe3e:51d2:f3cd])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b7198c65sm28593177b3.36.2026.10.31.17.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 17:33:39 -0700 (PDT)
Message-ID: <39d08fa0b0e45c61dbb4f57ccc911d1235ff9b5f.camel@dubeyko.com>
Subject: Re: [PATCH v2 13/34] hfsplus: don't set SB_RDONLY when creating the
 attributes tree
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
	ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, 	gfs2@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-xfs@vger.kernel.org
Date: Sat, 31 Oct 2026 17:33:37 -0700
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-13-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
	 <20261029-work-fs-sb_rdonly-v2-13-2f44f64f0b66@kernel.org>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC1F6180005
X-Stat-Signature: t13eo9y89xr9koxsapynz5zx7tqt4exz
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793493221-566118
X-HE-Meta: U2FsdGVkX1+wOlKQtF0zUv5xiTKM6lZ0rJv3YTYEz0aX1yZUMHfvVnPppr1AkiZ8Wzmo+UZ1OcRhCSnDDU6NjKU929VurKvGoGpkBP0Kav7YjDtsDlRyF6xn4N6lFDpsM/pPYCAOR/oHl2MMDgEUFQ23bP/I2GAeeR7fjbt4Ry9vMnccJnSY+9ckUmX2B86wnzGJGO0j6+nv/YBFlmGiqC05ijEjN91/sihGahqaEhK01g4/WmhXZ4XZ7O+WCJOL1UgqHB8GgLjDJwYH8PbE/lvSRLuH8W6Iv+vgr8GZgwjQHtYL6m20sOU0LffugGoaBzFZdwyZU9J8iTHwR08rpQWKJ5HxBmNYSVZQQp48mFlYLOdMsGcL3cNMuqaka6XVVarNNMXJ7C0WFhov+SMP1qIxs7pkIY6FnlD3ZCMCElm1QKgeXnZEYFU5mzQqJvB/xmVBVwxaAnoS36ryeKDmiIOC0HtVh04O0Z5m6lKpU1JdHukaFPOCUlts5XOWjpBG6ghOpvIP309tGTpN269vUY1wroAGluCX238z3dPYI1YGjkNu+Kb7Sa5T38NT0ZM/cylpirIaK3LxWbTTGXQgt6OktXtxwP6jL+u/Z3GQnTWHI0cX2XigVAJtV6Fg9h3PInhwxkM7zZQSjeKOEckuHjccgCpbmqNpgyocpKjU22RWyjjgVX4zxgiqN9kJA5iEhzx4i/LpU955NXHhVmjOWu77aDdfvg3hw7I6QddcXlvEE8MXu28aYI2/9WpMeB+fJIacQ5+mYRLzc5EYFQQdtuU+SU4dHdjaZt89rR2EFrH7Hn2G0f5SQfkqj3hqUZDiTyCQ7ffchpcUubdiJAWqwsLwGse5c2oePTcgG+cqYh6clsprWFbvqyKqFsE35qpzn3hrAhsJL/4EYciiAmhpIzeXoK2CE81chULAIoD5qkPjrPGDuwGy+7sBg+xcl4GNZr52Z20UhGeLLc708m7
 5BUu9duT
 vAwJTNaIXxNEPog+r7NRcxoMfVTiwxDB+4CW0w0h+LxtEjlPxEvwhA+7SbnckW9lakAQnL44g18bX+ceXX073SUYIjlakrXSMwgZTuYo30NLfIghIU3x6vliQJgLB2j698YyPWOxdk72YbWFwCHxZ7B08/Zd4ONVV00h++mQEathSGCg+ydMkOSpqM4QDxbVvODCxbIyDIRQLRb7rl0TEcjZ9yJqzmNWayxcT1cC2Jwn0uu57iPb7VCzIX+sbDblDO3tTP+ps7hjcTZLp/Iu00AaQk6txOuD2eBJ3jQleexz9zc9sRiamlwmx/iKtxYUzGPAHwhdNVhp9ni8QGpDJhfqThA/cedP4AAORozGIHo+xrqHXDIRv2Pt5Opvg5fwKKp5ITJoo0WQostXjrPqoy0Ieq6YIbM+71BLqgDe3XDZRoB5GbM3Y+1TFNsb/yok65YTaNN3U79WJChn2E6tg+SQ8lYJPHujamS9advaHy4zoPoENcIegSDXLS2XCq0CbtU1KP5Y9o8I/NfIRS0j4nK2f9UAK/PZu1B12SSPrdydc4piGCkFupZzTGWCEUY+r4BLT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 2026-10-29 at 17:07 +0100, Christian Brauner wrote:
> hfs_btree_open() sets SB_RDONLY when the map record of a b-tree
> doesn't
> mark the header node as used. That's fine while mounting. But
> hfsplus_create_attributes_file() calls it too when the first extended
> attribute is set on a filesystem that has no attributes file yet.
> That
> runs on the live filesystem without s_umount and a filesystem must
> not
> change SB_RDONLY behind the VFS' back.
>=20
> hfsplus_create_attributes_file() opens a tree it has just created
> itself
> with the header node marked as used, so there's nothing to check
> there.
> Move the check into hfsplus_fill_super() and do it for every tree it
> opens. No functional changes.
>=20
> Suggested-by: Viacheslav Dubeyko <slava@dubeyko.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/hfsplus/btree.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 42 +++++++++++++=
+++++++++++++++-----------
> ---
> =C2=A0fs/hfsplus/hfsplus_fs.h |=C2=A0 1 +
> =C2=A0fs/hfsplus/super.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 +++++
> =C2=A03 files changed, 34 insertions(+), 14 deletions(-)
>=20
> diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
> index bd4dbdbc8f98..4a67569050e3 100644
> --- a/fs/hfsplus/btree.c
> +++ b/fs/hfsplus/btree.c
> @@ -270,7 +270,6 @@ struct hfs_btree *hfs_btree_open(struct
> super_block *sb, u32 id)
> =C2=A0	struct hfs_btree *tree;
> =C2=A0	struct hfs_btree_header_rec *head;
> =C2=A0	struct address_space *mapping;
> -	struct hfs_bnode *node;
> =C2=A0	struct inode *inode;
> =C2=A0	struct page *page;
> =C2=A0	unsigned int size;
> @@ -381,19 +380,6 @@ struct hfs_btree *hfs_btree_open(struct
> super_block *sb, u32 id)
> =C2=A0	kunmap_local(head);
> =C2=A0	put_page(page);
> =C2=A0
> -	node =3D hfs_bnode_find(tree, HFSPLUS_TREE_HEAD);
> -	if (IS_ERR(node))
> -		goto free_inode;
> -
> -	if (!hfs_bmap_test_bit(node, 0)) {
> -		pr_warn("(%s): %s (cnid 0x%x) map record invalid or
> bitmap corruption detected, forcing read-only.\n",
> -				sb->s_id, hfs_btree_name(id), id);
> -		pr_warn("Run fsck.hfsplus to repair.\n");
> -		sb->s_flags |=3D SB_RDONLY;
> -	}
> -
> -	hfs_bnode_put(node);
> -
> =C2=A0	return tree;
> =C2=A0
> =C2=A0 fail_page:
> @@ -407,6 +393,34 @@ struct hfs_btree *hfs_btree_open(struct
> super_block *sb, u32 id)
> =C2=A0	return NULL;
> =C2=A0}
> =C2=A0
> +/*
> + * Check the map record of a b-tree at mount. hfs_btree_open() can't
> do it
> + * because hfsplus_create_attributes_file() calls it on the live
> filesystem
> + * where SB_RDONLY must not be set.
> + */
> +int hfsplus_btree_check_map(struct hfs_btree *tree)
> +{
> +	struct super_block *sb =3D tree->sb;
> +	struct hfs_bnode *node;
> +
> +	node =3D hfs_bnode_find(tree, HFSPLUS_TREE_HEAD);
> +	if (IS_ERR(node)) {
> +		pr_err("failed to load %s header node\n",
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hfs_btree_name(tree->cnid));
> +		return PTR_ERR(node);
> +	}
> +
> +	if (!hfs_bmap_test_bit(node, 0)) {
> +		pr_warn("(%s): %s (cnid 0x%x) map record invalid or
> bitmap corruption detected, forcing read-only.\n",
> +				sb->s_id, hfs_btree_name(tree-
> >cnid), tree->cnid);
> +		pr_warn("Run fsck.hfsplus to repair.\n");
> +		sb->s_flags |=3D SB_RDONLY;
> +	}
> +
> +	hfs_bnode_put(node);
> +	return 0;
> +}
> +
> =C2=A0/* Release resources used by a btree */
> =C2=A0void hfs_btree_close(struct hfs_btree *tree)
> =C2=A0{
> diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
> index 6f240f87f8ff..58c780b09b6f 100644
> --- a/fs/hfsplus/hfsplus_fs.h
> +++ b/fs/hfsplus/hfsplus_fs.h
> @@ -362,6 +362,7 @@ int hfsplus_block_free(struct super_block *sb,
> u32 offset, u32 count);
> =C2=A0u32 hfsplus_calc_btree_clump_size(u32 block_size, u32 node_size, u6=
4
> sectors,
> =C2=A0				=C2=A0 int file_id);
> =C2=A0struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id);
> +int hfsplus_btree_check_map(struct hfs_btree *tree);
> =C2=A0void hfs_btree_close(struct hfs_btree *tree);
> =C2=A0int hfs_btree_write(struct hfs_btree *tree);
> =C2=A0int hfs_bmap_reserve(struct hfs_btree *tree, u32 rsvd_nodes);
> diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
> index ff7d6b3336a6..532f23502df3 100644
> --- a/fs/hfsplus/super.c
> +++ b/fs/hfsplus/super.c
> @@ -564,6 +564,11 @@ static int hfsplus_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	}
> =C2=A0	sb->s_xattr =3D hfsplus_xattr_handlers;
> =C2=A0
> +	if (hfsplus_btree_check_map(sbi->ext_tree) ||
> +	=C2=A0=C2=A0=C2=A0 hfsplus_btree_check_map(sbi->cat_tree) ||
> +	=C2=A0=C2=A0=C2=A0 (sbi->attr_tree && hfsplus_btree_check_map(sbi-
> >attr_tree)))
> +		goto out_close_attr_tree;
> +
> =C2=A0	inode =3D hfsplus_iget(sb, HFSPLUS_ALLOC_CNID);
> =C2=A0	if (IS_ERR(inode)) {
> =C2=A0		pr_err("failed to load allocation file\n");


Looks good.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Slava.

