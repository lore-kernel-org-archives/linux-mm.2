Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C116CD232EF
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 08:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E7D6B0089; Fri,  9 Jan 2026 03:49:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1664C6B008A; Fri,  9 Jan 2026 03:49:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F1C6B008C; Fri,  9 Jan 2026 03:49:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E58836B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:49:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D06B1AB43B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:49:36 +0000 (UTC)
X-FDA: 84311801952.23.A46F1F1
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	by imf08.hostedemail.com (Postfix) with ESMTP id 69FA1160009
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:49:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767948574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N/41tXXyY58j/0Q0aF6dwot8qrNnnx5K4/PUFO5dd2g=;
	b=R1u0RoNTosRTLBhtsx3RkaJ0TTWZtWliCPQiJ9OhFk9XbxaoNDqK9errC0mUoWLpFXQaXp
	36d3CE9v+MJKH6B/V+JVM8xlT5tJdr+Z4qoL04EtHWpt9wiqkyHII0OqXqS8JUJc2fddcw
	DsHvDgkdRjjxKf4gjJ4NtSqRtY1b7UU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767948574; a=rsa-sha256;
	cv=none;
	b=YMquUT4EmXeT7n/MwDLcNlol4Zk86IoBlV02Zx5A0vwIi16g4P6Gf19WcBOqJrkk64AXGq
	NfCRXprkcaapB59xF+Nh0Ix/pMULZglu8iVFRa3HTziEBKxflcIYTQhVI41KKiSmjde9ct
	jCkoM+z8+LzepgsZBEAiiGtJFQkiwCA=
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 13ABC29ABD6;
	Fri,  9 Jan 2026 09:49:33 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id ATPC6i9pWXNZ; Fri,  9 Jan 2026 09:49:32 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id A870929ABDC;
	Fri,  9 Jan 2026 09:49:32 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 50WQivczX82j; Fri,  9 Jan 2026 09:49:32 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id 2BED829ABCA;
	Fri,  9 Jan 2026 09:49:32 +0100 (CET)
Date: Fri, 9 Jan 2026 09:49:32 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Nicolas Pitre <nico@fluxnic.net>, 
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
	Anders Larsen <al@alarsen.net>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, 
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Jan Kara <jack@suse.com>, tytso <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, 
	Dave Kleikamp <shaggy@kernel.org>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, 
	Carlos Maiolino <cem@kernel.org>, hughd <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, 
	chuck lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, 
	Matthew Wilcox <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, anna <anna@kernel.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, 
	Hans de Goede <hansg@kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-btrfs <linux-btrfs@vger.kernel.org>, 
	linux-erofs <linux-erofs@lists.ozlabs.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>, 
	linux-mtd <linux-mtd@lists.infradead.org>, 
	jfs-discussion <jfs-discussion@lists.sourceforge.net>, 
	linux-nilfs <linux-nilfs@vger.kernel.org>, 
	ntfs3 <ntfs3@lists.linux.dev>, 
	ocfs2-devel <ocfs2-devel@lists.linux.dev>, 
	devel <devel@lists.orangefs.org>, 
	linux-unionfs <linux-unionfs@vger.kernel.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	gfs2 <gfs2@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>, 
	v9fs <v9fs@lists.linux.dev>, ceph-devel <ceph-devel@vger.kernel.org>, 
	linux-nfs <linux-nfs@vger.kernel.org>, 
	linux-cifs <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Message-ID: <235309114.88543.1767948572101.JavaMail.zimbra@nod.at>
In-Reply-To: <20260108-setlease-6-20-v1-11-ea4dec9b67fa@kernel.org>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org> <20260108-setlease-6-20-v1-11-ea4dec9b67fa@kernel.org>
Subject: Re: [PATCH 11/24] jffs2: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF146 (Linux)/8.8.12_GA_3809)
Thread-Topic: jffs2: add setlease file operation
Thread-Index: 1XfajkHy73ekR8RzfIWJ5jINW3wE1g==
X-Stat-Signature: y8yb9s8suhz1uex3mmwhw7o3eerzg7sw
X-Rspamd-Queue-Id: 69FA1160009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767948574-178660
X-HE-Meta: U2FsdGVkX18ADyN/QZuzGIwDOnDi3z6ZHhdE4wK9hqI0c4bhyVp5ImDBJyJcYETE4Y2SxCn8TViFGwcrsgjdgLNLUFIhvupmYpoXkYTzjt5UrfLSS7GHMcDx6jmIZKyWVrKm6wpphKJ9xofjGThuH7DtjYz3Z/Y2abbTv7wJq1norFCkbRHtQMpnWiEnzaQ9elDrPhc++dol7FcYDDfakHE8Wkdppd3sRL36Nf78uBwmPH6bKspkwscTfVnf5jBTR6O6viyCJZqItLOch0gDzL+UjzJkPCRDgZtpn14RGWS/DKb7bgmfWPAHYTWZTMy7XjDTejq+CmbgZqTEqnHqOh/l7vq/CyGGWVLqfUorQPWiQItpkSrs9EGfDSJKhqiXa7jdW8V9Y90VdpG1vMbl4DWhLwWCCoYZhQi5ltBXZsq4NbzDcD6kP8V87oEvYD3yCrof/qArGheay4FJV56qMHgdJ6R2lAtsI04Ji/QU8DanolbArDUOgit3f2AugdcoK3F17U4k+3Mrc6MBVdtwmZdt6iqJJMT+lTTJe7qNKHMykDAWJGnP9+E8OQ4Zuf2tuIt0lYgXBIlyHd5CafNRAbDidLmHzChhN5LBVYnSb8b2OsA4ZZn4SVpQfGSo7IX/TnmJsNH7e9vZCzHPmm5dlb8Gm54+8jF6BBQ2SJm7XTxIi4p58V7Xt0Z9W1is2nJghAJ2U2+GqqzETu0h4Ojrq8iuJ1UzVtX3XREglhVJkM5kanp5buSaVu+XE7g4kAr8yRTox6yAa+2Qh8K+vLSTnSkeGmDRpu5dzUab1Gp2htUmMh6wn5KyfOx5A3G7xj04tEg/4t8Ze31etP+VntnFKIHfiyVPM9ODxnV1stiaMrgYehv0zkQGnlJdyZtnAtexRkGngHmCCkzki8BRy9mLyfzUFPFYC5Llc9iUI4YXR2mUSC8MDzNEYy6/d5QWMiCkbyrTKe+f+olraQxECpk
 XEm+s1Ao
 n+sJq+wp3g5uAbXD/94/6Wcz+sOOTdGRPjWJKQEPSnKevfxsyDftS2QMSBE8LjlfaD8ta9Fl/h0WwOTC34dwNGFzgjUxlIneTTJOxAweT71AVctgKyBYo2OWg18+nrO2PW1sM157HVYlgGDAdLYrQGqcvJptAamgw6kk2WtX+8TseXLEfSFxTVVWCn7B/n8ejYFSp0K7tgnIDb2hbJVQmTNScjVZ5x2mXuXuaZbxHTyf89/GvqiLrH2wmHHjl3aQuj4sm1LDpXZXUj5CnLkHTvOfACyLwCdx5Nxr/M6idEVZCQulUve+dlDmnqZ04wO+p5q0fm8VbP0Z+uq59ydEpBP9ZpNeopyFw4OgN+uwzFsx6vauMS8BrEa3v2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----- Urspr=C3=BCngliche Mail -----
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> fs/jffs2/dir.c  | 2 ++
> fs/jffs2/file.c | 2 ++
> 2 files changed, 4 insertions(+)

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard

