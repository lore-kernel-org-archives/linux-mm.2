Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C18E9D1269A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 10:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5086B002F; Wed,  3 Dec 2025 05:19:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75236B0030; Wed,  3 Dec 2025 05:19:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3D1B6B0032; Wed,  3 Dec 2025 05:19:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF766B002F
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 05:19:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4824C59724
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 10:19:14 +0000 (UTC)
X-FDA: 84177762228.11.17C8EB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 73DB51A0013
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 10:19:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sia1MYIL;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764757152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9QD6HVcKhaudvgQUmcrPWxae5Gbkj5XejxdA7YCuNM=;
	b=fhdYJyiZ5DHUgAjBu6SVWeLhz9+SmXXohbIU8SnxbkjEuf01KjTT/PVKKmBjouZsseiP8d
	dFsuAU2A2Dh0N2MRd28hjVclKI30nY1vQ0gNBMnH568ozamzousyF45LXyWu1Jo0xBc1pI
	2fSN/AjD/bKXBXF9AW9qsi15iWSNamo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764757152; a=rsa-sha256;
	cv=none;
	b=E4uaXTXnr7MThd/2LOoPUVWy4SKUSnf2G2TfhhSVufBi81V1sdA1D8kNe9K4GgaSUfPYw5
	HTvkkLtAFVe5BrmjRoKaqzltwjApwfOMKHut1vLad+cMUBpr97RySg5hOVuLbVAar2UQ6X
	xHV0BdXjAqCFuRBuX28Kn9azPrWj3/0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sia1MYIL;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE02C40235;
	Wed,  3 Dec 2025 10:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25361C113D0;
	Wed,  3 Dec 2025 10:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764757150;
	bh=1ALGFmGlgOHY6f+bdLdgKebsX+au1yQ5dTRhimTaFoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sia1MYILwN3OHyU8vJVbFzEbPmh+E9Rkdc13NmENJiNAQwujMzrx7aLJDYQwnRJH2
	 icv0Cs7+2DiJlUtJrJ3jFjsxz5e5SC+H4b4cDPm/4/s+aTZepyO4AvrHMcRjPs8po7
	 P0lAluHlqilBXk1Sh/B/XN0TZMdipTL7EolZ0FehsZ8XGO0/aidHMHK8ayQiiiT5TA
	 U6OOgYna9Ec2DgYD68Hcv9/StfMLZVIApf1YAZumWdYivMJy+S1b4NF19fKc5R60wD
	 vv/cJLS0nI7ttPeXB8OyKOFM1iSYjxfn/4avfs6o2Xu7czGUpIFQziUIbMv79dw+WM
	 YExRE41C2xh0g==
From: Christian Brauner <brauner@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	NeilBrown <neilb@ownmail.net>,
	linux-kernel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	codalist@coda.cs.cmu.edu,
	ecryptfs@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	gfs2@lists.linux.dev,
	linux-um@lists.infradead.org,
	linux-mm@kvack.org,
	linux-mtd@lists.infradead.org,
	jfs-discussion@lists.sourceforge.net,
	linux-nfs@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	ntfs3@lists.linux.dev,
	ocfs2-devel@lists.linux.dev,
	linux-karma-devel@lists.sourceforge.net,
	devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	David Sterba <dsterba@suse.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Chris Mason <clm@fb.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>,
	coda@cs.cmu.edu,
	Tyler Hicks <code@tyhicks.com>,
	Jeremy Kerr <jk@ozlabs.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Dave Kleikamp <shaggy@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Bob Copeland <me@bobcopeland.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Hans de Goede <hansg@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH RESEND v3] vfs: remove the excl argument from the ->create() inode_operation
Date: Wed,  3 Dec 2025 11:18:32 +0100
Message-ID: <20251203-sechzehn-lethargisch-cd739d4ff49a@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251201-create-excl-v3-1-8933a444b046@kernel.org>
References: <20251201-create-excl-v3-1-8933a444b046@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1370; i=brauner@kernel.org; h=from:subject:message-id; bh=1ALGFmGlgOHY6f+bdLdgKebsX+au1yQ5dTRhimTaFoA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQa8NXdfyOWEe7C1j7j3H39MtmOfckhfYU3uPbO3GJ5W X9idSdfRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwER6JjEyXElxiNLjXsTcG/zF veHQZtE3X3LuXMnZx/2vIaPja/5RBYb/9Vo7JnHefOS2MX2Dr5zm5id7fnmJz3GXVk7n4Wu5Kpf KBAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 73DB51A0013
X-Stat-Signature: xo5xknrucftkmq5xqdnkj7jpy9tnswjp
X-HE-Tag: 1764757152-615706
X-HE-Meta: U2FsdGVkX1/5F+601AyxRdOVy8MBoUEoiK7NbSBLJEnnUXe6UTb1g8lCFt7tyz0QCNTHQbe/Rp4phxBYgQlaoLl6F5pgt81Yi5xDvGou3zDJ/x77rsq47qwzMX7xUogmlxss069gBhzuEMAhlUy2yVK+poBHySkKhHQZz8sZoIIUMbec2x8R3Yn5ngabDIJv5qgK27yjx6eKYOylFhYL6tS61QnzcJB9Rn262OxFRMc0HtpY3kqnO1WqleB+kXbzricjxY4kmmN20Y9EyEP/HNR+fVuPPSNK3efDoTBdh02BPCfSIx2/CRRgoSIBDWXylkEnfZtkcLg3moX92tDPua8IgI058hwRPkV63vmhi440bxgqIdTP0pwUv9SqIoecQRYRuk7EyQjN/PG66FF6DuSc1jIJuzz2qtiR+o5FpHsRdQwypgFvHmkWj0xRruFN/om4wOqdjsufAFjml/ffH0GfmZ8ORx//CIrwjuqjTt7xM36M3zbVR++qtQFNTQujQTsb8VDsY58n0SN5JbyWDmSZuXLC//8+wBCdspmUstnwKeXms4A8o04sja4IL9psvDDHsg152L2SwdiSn98Y7VFy+xvjR2WE5quAzDLLe2XpqDUkajp5llv3PPCzE0faoQx4eX7ItoHgFqrC75+z02D+XZgmhaqrQAoc8nWB/IXBPSINqmf3vI6n98Z8TH2B60k9GL0dTGPLJuiKrOP4LabaDUlXR4EV27llt5jSfTj2CwQgo9kdnXUmSZJ/XKtqevI2vwWs1C6lvMZxaya0yR1+8v8ZqbgQHD6dOBoQIJfJQXRB/ilkWTj8Nz0S36G2pBtCF8KeZhe16IHGCdJ27kltcPT2cUHwafpwAwjYDjdNgb2PLi2oknnEgVDRfCJlfO76F6epJ8g0KRCjwfvyHxkTpS9YUaLqy7JfCaoV/vW+OivyiR3GlIwybVs+bc1aODcw47KCy0oLJkOyC/y
 hW3f2S8A
 fKPZUAlXtOCRnJSKRrt9cp1UCppqDxJVnmltKNlfv1R93BysTB2MUpIaTpO95s/ETf7ah+CCX4keaPv2wljg3nrpdu5JOUelzj/9932zN+NTjKQ2FAhKztzEtnfRGYyzg991j02IVSG5NfcT32C2j2QdYPSuYUUNhyAYQCIkt+jvODfmP/KlWCQNIhXmVJwJ84GM/DLVA8q/jK279u/f4WEpu/X2yCaXy7BQ/MUy9boXhG8dqQEjAtArGkBOLLcqgd7gQnjzfq1HGPpiF84VO0wdKSeV/vfQnNRJmlMcAbracWtCkm+gqGV9tfxHgYUbGwjTeLEZj/kvy5M9x7y0yAqlp+Fz4qNi7A/Oo3wnV45b2S919egBUxgOPNJ6i6bufeuxCt/hDDQyWepwLMJHT0knZQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 01 Dec 2025 08:11:42 -0500, Jeff Layton wrote:
> With three exceptions, ->create() methods provided by filesystems ignore
> the "excl" flag.  Those exception are NFS, GFS2 and vboxsf which all also
> provide ->atomic_open.
> 
> Since ce8644fcadc5 ("lookup_open(): expand the call of vfs_create()"),
> the "excl" argument to the ->create() inode_operation is always set to
> true in vfs_create(). The ->create() call in lookup_open() sets it
> according to the O_EXCL open flag, but is never called if the filesystem
> provides ->atomic_open().
> 
> [...]

Applied to the vfs-6.20.mkdir branch of the vfs/vfs.git tree.
Patches in the vfs-6.20.mkdir branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-6.20.mkdir

[1/1] vfs: remove the excl argument from the ->create() inode_operation
      https://git.kernel.org/vfs/vfs/c/7d91315b4335

