Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05F1CCCF2C5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 08:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BD326B013A; Mon, 19 Jan 2026 03:40:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A0E6B013B; Mon, 19 Jan 2026 03:40:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469296B013C; Mon, 19 Jan 2026 03:40:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35F776B013A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:40:19 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C157DBA910
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:40:18 +0000 (UTC)
X-FDA: 84348066516.29.A50B582
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id C988B40003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:40:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YsuFsVdt;
	spf=pass (imf07.hostedemail.com: domain of konishi.ryusuke@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=konishi.ryusuke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768812016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJoYOa5K18nqNKCWxkYAOdRPH4EyPY3p5tSvazTt+nc=;
	b=SMhHOPDX4hiCz6j2js0F14keuNcXrV6oCHIfj8MqiD2C14mz+xGpfLOfuq7X+I8djdCVEm
	2qe4HIo2XVb69jL5hIdXX+lVp74XFycRAvr/xdLwBKn7W85JsfFhWWkZiJ0GwGmuNS1zV7
	LFMbviM0Wkk+yzdIQRc83G9SKYaU8nI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YsuFsVdt;
	spf=pass (imf07.hostedemail.com: domain of konishi.ryusuke@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=konishi.ryusuke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768812016; a=rsa-sha256;
	cv=none;
	b=xjo55L/fQK533Z7T1Sq8QRruJR/62MvI1GOUZyhnlj0ISwCDrHI/7U4VCevdmm7DWgm1nq
	3gAQVGW4kJBS0ErUv5wdqysFfjiHGjXf+wF5Pfzq1LS80G+J5Fdl1yv59xpah7aV8T6T7x
	sir4Wk8g7w6FoDHDr3/PVk4l0B8TsZA=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-382fd6cbae1so34474681fa.3
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 00:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768812015; x=1769416815; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KJoYOa5K18nqNKCWxkYAOdRPH4EyPY3p5tSvazTt+nc=;
        b=YsuFsVdteq4nvmuTYg4zLgY9VBym3QxQzYBTfq5KHI8Beq5tEMy+Yq7YM7rmT/W0e7
         8qgC7bvErRk6VCNxlmOy6LHXtiplKsaieZKmgkYQQGLPSWfzSlwqKbHJVTjrce05zxav
         mtEKaJPfe+OCTUDAmVwbKccCaQFPoWpQdzWL42P+FSKcdjy/OZVme01z+UYF3M7L1el5
         PZglVdxmKVoBEJBltY8p4RtdNXbKJkdH4zMk1hKO+Fnx+wXgeEB8CBMvcVy3jzOwTIa3
         doDo6Yt4C7G2AbtIjBPnr4lPH4g98T33cXI35qLiHB+E/bCRUVH+XOo6sixFo431D4hX
         ayeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768812015; x=1769416815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KJoYOa5K18nqNKCWxkYAOdRPH4EyPY3p5tSvazTt+nc=;
        b=NM+kyA0tjDt9cy7Z+E/b3N10T9vmhoyhyuBzy6j7eabv+6UvAO8sjrgI7j03A9vX7h
         QVUMMktYIbfF6G2QPWdG8VVriegy/ZMQ+fsJbSjnNZj4KyEuf60AzUVYwmEjr613FO8e
         mQP6wq4mafXYy7HWghlaF+41ufYxPe5arGF9uqLybpasA8CB9HXJv5bFg/1ELKnguNqk
         RboiaJKuE0ohSUdeqH+oI/9Nfnw10KLeZ922FesuiQyfYNRfr/8TwGCcWRJMnD21/g70
         ouw25zrIs8OXR10a4qHfAMXv82fv/RDv11fTd/sFuzSCjH/2LkIiHoOPTU+jI7hTWPQw
         LHtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtkpRnOxdy9KA4LIh2CfUDgGYJtzOu36/DRnThFgOaZrz8bFHm1cs7XLNR4SAXGRJYH5KoyB/xOA==@kvack.org
X-Gm-Message-State: AOJu0YxOj2qfxol2mfJQ9mfXmoGUUdcUoXO1ByTuI7fFI7yYjhFId3AG
	MKq/Ueh/zQeZu7R78DNi/3Zd1Ay2vawd6vVYlkvfq2t/aebrj1Wohsyk02/Pkd7pJAImf72VPwR
	64a8tYLDeu0As2FOGlK/DTENVJPPpXbA=
X-Gm-Gg: AY/fxX4GyAQoz0fOfWlS1ISXlU1NRDVmbD/PMn5f1tWkU7emnWoXxyoZKX9Lua2dfsH
	unYVwQwVDqb0N3jnOTYoEy8/5yghv7wB6EnAoicy2njH/9OPGA6JDa8s6MXv0cIE+Wj+vQmJH+9
	WtCwILZJSWwIECPkzz7rUGre3cSZ6Sm3EfzFLjO6knjL8LzVzu5mNGWVttb4pw1jE26oNjgbq2t
	TPgn32iVQQmPtyze3XSzN1VONDJFbj7TKNITVPpIDx8gZxV4Xb5mxrtV/Lpo6+3SAZzQPq6
X-Received: by 2002:a05:651c:31d3:b0:37b:9ab6:a071 with SMTP id
 38308e7fff4ca-383842a1f56mr38777111fa.28.1768812014411; Mon, 19 Jan 2026
 00:40:14 -0800 (PST)
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org> <20260115-exportfs-nfsd-v1-20-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-20-8e80160e3c0c@kernel.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 19 Jan 2026 17:39:57 +0900
X-Gm-Features: AZwV_QgvoiJk-4c_7XszNQLNhAbjR94vrEkk8toY4eDKXl6u9TqMllUY3n06aqo
Message-ID: <CAKFNMomS-8MMAjy8yuFwzuLBuQQA8r7gPJeJh1ci6RvVc9u4EA@mail.gmail.com>
Subject: Re: [PATCH 20/29] nilfs2: add EXPORT_OP_STABLE_HANDLES flag to export operations
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Amir Goldstein <amir73il@gmail.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
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
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C988B40003
X-Stat-Signature: gdpf93yq4u65d6xauhpk7xfyccmdc91p
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768812016-169634
X-HE-Meta: U2FsdGVkX1/dq9XcIQeW2hZpKfnoCI60M9BnWRaiqB2f1lkNU4f6ZQGidMm/U+03UKrd8QvaRN0TZkVL0Ry26cUcJYroOz/ArTr2w/PnShoC33FAJ+fmS3A4czjba10m3bzRSgn4devEpBLmcggB4HuVvpjuC2IZsfNF/UcDi592WyeDC21L5pbTsvTOHzYy4aAkJ9AOxG9kTudQOQijd5G9FlnCydlvhRsVZXxh9HvcEu7EXc85+b6Rv1E9YLBiF3nuWTKFyZyg701VZnEjaW+ZpkHTBGROuSuHgxqraxMhk0sdd9rMTm17FpZIoFHBJTJEwol8XN0dtWvtGHKb/SC0bz//pVKDwPaVNSlxv2+SNQd9x4kRMIRb7KK+FfYyWyMwG2S8ePBnPrjM5683AOXx71tvifiXWMgBsXQH/iY1yk+p78b2KE53sKDUxHeOQyKUCdsZkvGdUrteUZVPkp3E/VVpkF6921YZLYzS4+Ap7AmX89N02fLxqtsZsBXNkhaJTuTWxKwZXs4YGM5XC5fRrLkKkIzgUGXE8upZCYwdTtJSwnjs4i+bSamb2+8x+9o9ygheI6/9AjXNGcS19eNvt440X6KgwmC2Ctk6RzcmDkK9x0Q6GEwzbLC8l40NgTuNf7ajN7NVR9UFzZg7RMCsvgha2YFVxVJQzM/Id1TFoDRbDwOAR+fQm3Y0UXyExGf/5Z1shZxWrgj9XmLlIRKenP0vUxo8BpnSEQQGOsbYVjb3/AmSadHO36eyBnbANKQk5vLKIAtk9ppV9DGCrdPGPjaRCLAA0JlXFlH6G3Ilo9zWwMDB+UCt3WDnnH2YPf3qJQgP6zQ1oomqZsBD+DO7oITqOg1JCNhk8AaZ8DMRSLVF/SqbfqmXS56zDPa89xxL6fpQ2ckHX97ukaI0gI+gd2ZrhLrhWtz4AWSMXL3azqwZgydZQlLtk0i3+pvC/JWXKxo0invOi0yeuLV
 96Fqb/Io
 BRXcyGRHWo50EpbIu9/TUPwKra6NSkoxiQp62YsFyVFWH+0oO+SQ7FfcIZkxVpNcw3J1pdOvEgLXt1l7ouzjiBg3VqWo5r2gVX9dMkMb2Os5Ya+xl/LFKQMwh3RjGTeJilkugYs994LeNzNmA2GjIi0/2Yn3ObLDDMK2fdsDvcLA3U7yoIPchvM4lkdW5Ri+oQNe57XceMm6AcRCMU1hnjl60/4K31XwsRifaRg+05d9uAni8XIu58NNMDfMKcvreOJ481Gv85DBooE2Anft8RXrkKhpYpwtG45/2U7mHfFfod4ATX05lo12hHLIdbwhu88CCkift8wNARUQkHhRWJgtAvg8/tp73d4LY06Q7gKP9AEWzbQ7cBAPB/lcLyPFEIPav3bMf9HUgAUgJ7T40xC0dCgw7WovtTb0U7rxqflSqXotAbjfdW1bG7TLz+dR/0q4mPiMLpvep2Loh2+FVRW8UNJev+0QKKgjznEXIHpei2h7CR31ucJoyGdNr/PkkYzV9Pt+X7nM5Gj/wqwsxBfvMYlO1B9VQUrXkUrGXDocz27E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 2:50=E2=80=AFAM Jeff Layton wrote:
>
> Add the EXPORT_OP_STABLE_HANDLES flag to nilfs2 export operations to indi=
cate
> that this filesystem can be exported via NFS.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi

