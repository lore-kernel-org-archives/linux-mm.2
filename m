Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6C1D29C40
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DE866B02B5; Mon, 19 Jan 2026 11:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC5B6B02B6; Mon, 19 Jan 2026 11:43:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AECB6B02B7; Mon, 19 Jan 2026 11:43:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6EF6B02B5
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:43:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 156141401BD
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:43:11 +0000 (UTC)
X-FDA: 84349283382.12.033A323
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 28FE814000A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:43:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hdmmh3id;
	spf=pass (imf23.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OP488vxzDs37SDvqB3SvtrET0fHZKVUQCP8+UqFkiUw=;
	b=eeg8OLw5Op45msA2M6Qr6MtK2/Yg+9rLD0XhyeM1L+EMSgVVKBum8C/4irRXaB31Lhkae9
	x9rc/JdpopKJn62hcblbkRJTAX3V1/m3SijBiCO6pHcbLFfk9y+pFBnQsWAT5+eyAONZVc
	JboTBCS+qbfJhqnxFn9F/8TaUddzTpc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hdmmh3id;
	spf=pass (imf23.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840989; a=rsa-sha256;
	cv=none;
	b=Q7ww7Fx81dAPG3Ng0D5H8JBjFcZIx8+vHgmtuomK+Rf6VspzhbMBkuSKb6QpTe6NRfGBMO
	a0YelJd7MjnqGRJ+IWfjWf6W2VHKLi/rshPRiniXZ7ZGjzuqttBOjHE51NzxJ2dr0U65ZW
	WbtFQ3FcjUmRjcQpdoA+sjgDsKrDEXk=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-652fdd043f9so8366846a12.1
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768840987; x=1769445787; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OP488vxzDs37SDvqB3SvtrET0fHZKVUQCP8+UqFkiUw=;
        b=hdmmh3idMDrsKIHwtgleJxTR2HL4JleQhI6UTJlvQsFR1UlzD8iaZzPKA6kV7iP4Kt
         nZX3U2H7XNemC4dNYidSbJ4ZE/k2B77xJuDnoJUapdZa+zNUNtwvMF+BUBv8sxnE1rRH
         YcuHzqwOx7wHw+sxn7XsIBSafIF4tF3GrG5ZcAkVDWC6wl0g1lBK/0BZCxNjb59Zljms
         Ax1Oky62gINOCZvt1Lfu3PnaOM4JYla1m4DLPNGSdR0UlEVKb7MQizy2HNoKtJOs4y9o
         yRX82+8rKejO2lpK1IdyghKdafgtBk+JwC7uofDJcGUGGVLqp8coWyFtNEMwDrYxZ2I7
         LVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768840987; x=1769445787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OP488vxzDs37SDvqB3SvtrET0fHZKVUQCP8+UqFkiUw=;
        b=UMHPtTvSyNEBl8KTibzXoWNXDmpx9InztGqeLvuWbN1w3Ev8MQ6rMDFaIYPKRs2roq
         bEfVuNV7QW7vrY3qW9fnjQQ4xAnjv8HVdg7h1dLOjTWA00yI+xHhr2QsnauDeyQ3S7zp
         v6ji7efD+XwzGIw69g2IpazIfpTVGiXfpDm6PGlHAzkBynUSqUN/HvQM3JuTDR3MPd6y
         Ncyw4zTspH6ZygddfXyi4vm/eYW2LhCpyzKphrM3pdaGSOgmefK1ii6MXAEUKGv8Yzut
         yeeYtRrmmrFRP67rtqyA0vO51z01ku/8rhfon5M7QSKs4O/PgPy884UYPUsS1SYMmVaa
         076g==
X-Forwarded-Encrypted: i=1; AJvYcCW17WfnXQgL9z3yIVbnCcBrtdjcSeeGKAp9jRmfwZO5FPVOdDI2xuguIwRgMOVx9PKzAAoNyL7dAQ==@kvack.org
X-Gm-Message-State: AOJu0YzkCOGMQ27mreDyZh2ziMVX+aV4d3X03uh5fLorvhVE/IHpqK8a
	aaiKBYYFs0l2ABYs87yick52uteiyEC4gzNneSsO1+RJczMeph2VQlfyQH1IFcH/1cpyfXDJlpN
	57SqqRYiiaeZJxeQwSu1wIHpLCmnS354=
X-Gm-Gg: AZuq6aK849F1jI2OcKCppVNAUGQqC12ul/Nrm474eB2uwsP/rZfJ1Yhljx42/Tt2n/J
	AMJ1GAS3daNj3ae0Ns/ihoaTeHNH4vj9nxhOAlaDD+uta0F1aN8yLlNMmljZF2sZNUaZssNzpv2
	4oh8nlqUsnuW50lHeOcA6t5yvIXGVKyOz4zBTza4Yk0/Ar+8svGmKcxtAX4lVBrC2S2oBC3v8NY
	DPIdmmq5oxJBEiD2ODZWHetGVist6MjUiZMFg8Ttd4jEoOZlLbZMFJA07CXCMWJ0QrlzbiCNQyD
	9PVyBKY6Hg4E35CkqeJ7mxptQCz5jg==
X-Received: by 2002:a05:6402:4304:b0:649:b200:afe9 with SMTP id
 4fb4d7f45d1cf-65452cca909mr8384256a12.27.1768840987066; Mon, 19 Jan 2026
 08:43:07 -0800 (PST)
MIME-Version: 1.0
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org> <20260119-exportfs-nfsd-v2-17-d93368f903bd@kernel.org>
In-Reply-To: <20260119-exportfs-nfsd-v2-17-d93368f903bd@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 19 Jan 2026 17:42:54 +0100
X-Gm-Features: AZwV_QiQ9eetgKyRnXUMiKJDXK2vIOYhTLzpDlKP7IN3cG_hSRVA59Z6sNZRsnw
Message-ID: <CAOQ4uxgXovX-rPuAE55D8x4jbNOQdAKJH3O5gpHJDMsT7kNGgw@mail.gmail.com>
Subject: Re: [PATCH v2 17/31] ovl: add EXPORT_OP_STABLE_HANDLES flag to export operations
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	David Laight <david.laight.linux@gmail.com>, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 28FE814000A
X-Stat-Signature: 6o9y4q6f8ti9qtp5u1zimcyxchhmwxfo
X-HE-Tag: 1768840988-514973
X-HE-Meta: U2FsdGVkX18rzwklGkIj3kJ0QKIwscP2Ws+F1qcYDlk22kLUF/2KTRkLk+nlXrVgqEzQL139S34UL91z6O6vXaX9M5wxE5mMZFqAra6cL72K1M+SM5E7p+ST6QWkBW8vUh/E1dfTnEL1BNhZQ/mu+1s200M0BFWm5L2+9dLsSIWG22rWVp41JvX7VxpphoQTRSQoB0rhopBIQE9+FUFL5A7KkGxZO8Wo719d5zC5hHpeI4SZNqVP12d2++xqGtWHVRdqEHmgbepU0Ox7QAfBZwemsJVJGNjMA5u8B4kMHury9Pob0hhqiulm4CuBHalkcA2ERAkFM1duaFJWNcfwSr78hy7Mhxch3Vd4K9pmQb6Yjp6ik6yiARqdMKAMUcpvTPCajnQFxavHkXBWnQH+psNQxihdL0i5fsRTPv0jmklFOd3UzBSjsjMGd/tO16ZoYDv65x61AxZk2P3XcMGVXO/+RE39jvNSYBIts8yrwHIH+IFHfVZ+TQQHL3ih0q2JC8SarpxV+CRnv4iRwdPE62EoE55BToBqHP98Hx7EYGp89YAUlZiJjjnBAfiMQXGfVowQfOw2qmkfVXkBELXNU+nWn1oICd6y/O9dUKbinpxVUfI/a8FIR/kVt6Z+tuECEAV0vMlRSfrMohrWkea4j1ZHSa0YcFiFX8BnHOvLWcodS/nANOokuvYnRFa3Vf2I3GCDhS9sz0GPhW3EdKzFSeZ4W+OuuexHqM/BsqI5ZlHEfXat+MGQF1kYN3EYbcJzFBOiJVpIELDR9EBpKdhW1pROKC6CuM+QsqnSN2jTeMdt6hhybwlTp8/tu9HOND2JynJzRbo+g/ANGrjSB+YuVjJ0koKkW1PkTqysRn1davLpJSnzulJ1TDQjnHwVDfL9vpXdB2XUJFtE0fhDsraRNaK7z5eOzVuSq1DVgOnOEImIlSfpO+pwRMkqvl6lyruYUSmmnMVem2LYn8K+6cq
 cu3NOClK
 KM944ThjdLxkXYIpdWjqkOluq4xpOEC1pYoU0azrd779czfo8bXkvO6CvSGNpUPCTAHJ7fVxOlCR8XIZqY4fB0kYANXVvRIfpWdX2yt7BX5braG58OOWU8HNxpzkuf7d4yoF4NrtmepLy2+H97SgFYhPYVZAFCdLbqF/m5OExoyygqy9/WQ3xK0jJVH3Vk9kgQQu9Ga2jiKs4QwCV6G8Fg193nJIwoANCeYrZX4+2OIlYdRMY7sjJ+WsSeSb9vf2l/AObJZ7n+upfPZY4iiASUje8NjDSv1z5FVegBYCvVxOir5YzYEF4yuP5rv361X3PkhkJ7fH/zUY8/Ad1B4hYjMQeFOWP6uPGzBoLHRzUa5AGmkMmRhEUwj0ed6jUt5bfbGk9KbDuGwpclgZZtpkFbvb9eI8pwIBxFg5mmDBZYEQlDoPsTXTWIxqJl66WihOZZHVG/lGNwilxm5G5gElAtlRnaQPfqxwO4sOUbV/OdtlK/6kbraIdCtkkrkUbn+Xz+7+m+VLDHWM4bPtHKpDN71/uZuBCLGs9Rcf01NutgmAFhIKT+Aa3i1ZwkawxzapDcEAI+laqNVgb70RL+LDhoz4k/cSDp/SfPNesAFaZnTNy1po=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 5:29=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> Add the EXPORT_OP_STABLE_HANDLES flag to overlayfs export operations to
> indicate that this filesystem can be exported via NFS.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/export.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 83f80fdb156749e65a4ea0ab708cbff338dacdad..18c6aee9dd23bb450dadbe8ee=
f9360ea268241ff 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -865,6 +865,7 @@ const struct export_operations ovl_export_operations =
=3D {
>         .fh_to_parent   =3D ovl_fh_to_parent,
>         .get_name       =3D ovl_get_name,
>         .get_parent     =3D ovl_get_parent,
> +       .flags          =3D EXPORT_OP_STABLE_HANDLES,
>  };
>
>  /* encode_fh() encodes non-decodable file handles with nfs_export=3Doff =
*/
>
> --
> 2.52.0
>

