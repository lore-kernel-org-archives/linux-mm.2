Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B2DD29C43
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F6C6B0290; Mon, 19 Jan 2026 11:29:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8FD36B0292; Mon, 19 Jan 2026 11:29:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96AD96B0293; Mon, 19 Jan 2026 11:29:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82A246B0290
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:29:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 422B51AE149
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:31 +0000 (UTC)
X-FDA: 84349248942.24.B299A29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8D315C000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s0+VO6sV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840169; a=rsa-sha256;
	cv=none;
	b=BqE0S9wTcV9vhMlTPSlUVueOiLneQAIq2538bA4lM061oBwzmwYLmUHOmH20pMqP+5+99e
	YXtk9U5zbB4tAhf1yLyoKhIR7L+6XfAjkyVeyc2M4hJQJYNbYOrufabbkoJdI6MPAzt76K
	WfgL+w695ovHV6JoLSsAg+nUVaZj1kA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s0+VO6sV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNRXqgtLINsO2LjaYRvHXTTyfbuwIc2N3jXCIBuI6EY=;
	b=qHbO8y3WcDV8GBFpYj9NTUPaMQznh1vlQCnM9U1HZYBGgWFm6PZohQkymMSCMNfgV8/PeJ
	yFRLQx5ueYALRtr6cvI/GAfFmHP/RNzRhk3fxctdbHg5CPatUZlDO1+1/6DrbKzB8xnpS0
	XYzrMz5ovRpsy5oaUuEKBiIeHSF1xkk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E0BF860140;
	Mon, 19 Jan 2026 16:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DA3C19424;
	Mon, 19 Jan 2026 16:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840168;
	bh=G8L9z3jgn4ZzCiBzdCY6syeE/KUQa76p5EoRG21yt4c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=s0+VO6sV96AAayqW4HXC57FxZusoD4Mr5w8orM2wKOHjCe4I1o88b2JDzVMiBf77Y
	 pDDjACRlbOlveBnJiQcXYVA5qpw+/sU2t9cL+ik+kbcwUdNnDmXocOzTjFulfYcHI2
	 x2A4unujL8OvOlpmgw2+OIu0I9FPLARZ6mdAINLrqA7eln2pZpKV59z8M/E+gT0xkw
	 xUrOTL9ynJB2DvZABkuZtdOF4x5IHc14IzGdRINZFy5mpXXM/x3ukRBMnStp2InutK
	 CQpw9K34gzMddctLV8apZ7g9I5NucGaI5vYJYjUgfl4BotibidZnZ3y8HmNY931YWC
	 N6Dy2SFiZXtTQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:35 -0500
Subject: [PATCH v2 18/31] orangefs: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-18-d93368f903bd@kernel.org>
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
In-Reply-To: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
To: Christian Brauner <brauner@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Tom Talpey <tom@talpey.com>, Amir Goldstein <amir73il@gmail.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, Luis de Bethencourt <luisbg@kernel.org>, 
 Salah Triki <salah.triki@gmail.com>, 
 Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
 Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Dave Kleikamp <shaggy@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
 Andreas Gruenbacher <agruenba@redhat.com>, 
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
 linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
 devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, 
 ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
 gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net, 
 linux-doc@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=801; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=G8L9z3jgn4ZzCiBzdCY6syeE/KUQa76p5EoRG21yt4c=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltdXD5/4/NEvshZqyvt1InnFNA2XQmYrmnTp
 pyWIY7yRpGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXQAKCRAADmhBGVaC
 FcL5EACKAKVsfzFMfTk2Rxl44MOn7Jxmx0HGw2TNaLjhEixH9/SJUnhSyAZxEqPlwKij9mWLRg9
 egLOfPv4xhcGi23lAB865UgUt64WvqFfyfMMdYy71SNI1xeODPqIf3wifOxvwDu9L+U/jmLnQio
 G5WhwpXxYDtE/CTJQQIlFIhjbwxjo1/FLRxETOlt3wlERGLD+guFUoBS51K0YtAjvLB0UHSsQjx
 JLr1J0KKtVdeSSPF5aie8eA7UzNRko1ECjRTHdljrDg+uyV1//gbZ9Is2UZmJyRBbzlfi5/sIGE
 gwjA4Ud0gOkvn9MVFLyc5IXIvO+GkhZJ5oa++NC1hmG1o+rzBleXhb7KyYc6GBC23tJM3YQicN5
 zzau2UUB0ypQ4uefiOj+ilvYE9bQcyjR9dNPSxO3f52aJOYpLd61ADVfJ2hOSylDBWcJrY/qtoh
 xJ4rCxXYQvqZE4cKULYWIt98FrwfMhaLc0pBN0bWK6V8yL6Epj61iw00IWkT8zRPIVrjGCqdHpV
 KoylaD3lxPgCuGO/e0wwO2wU/h2UFpO1o66DZgVouEhyp8OSQtNZIdkFKLVmACRR+k5YCVSDKdT
 I/cC1UslVadh57kMMm+xS1iAZvb9WWuJ2bMgDRybN1wR9LY39O0TPBVl4/YilWCVBRz26kgARRz
 jQUOMwDTLocp+rA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: sprjnyi9tkaade1whpiuo1anucq4rewm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8D315C000B
X-HE-Tag: 1768840169-822171
X-HE-Meta: U2FsdGVkX19ehh7QIqqiTdDcjBbauCxYFofJCyJT+LQXFjg85MqL0UPyrLCu6pa0yLP9390eydx5Re5WnBHtKMFl8ToNa4v04v++VKzC9/DowyEKFn5N9iW6G/j1f2zCJyTPmSqIYVtcrrB4AwBnYR6ldIWG4IsXDKVP0t8lRAx2kUNikR/Ipk6C3cOrUzIBOXyeWUowCgFgLDgjcqjDQPsUfFIZ9hBzHkQ9LcSfoLx/kOSpDkThfFCUaLm8PD4DmMrSSDdzqqex/BOWv9r7/z3eWo2DbHHHMxBCqwa1W9B513iDoR3mldRN1rbrI4hk0TkbRt6PDeUhpluVCXDu9ECtWdpk8CMbWo2wl8B49VzSyCeavJ2iL8PmvTY4lmXgmR5Xl2Lsd4OwIJjkTBbFYJomwDcQPM9qgDzCK4pBqeVvIRj1cN6L5ZmII19JJab2gSVYlYUxH1aVpy7nrsVC+WTw2dOAndGtdc4cdVfW3vC9hH7l1+Is0KYfNYyHopPbJwLpyWd1RYH6csw/OH5HeJUn8UMo9UAnc8PMZyFli5JO04ylGbjmrtM3hoJcN+LmGZmbFYgMClDTQRnZZro1KFWmC8Xly4BS2GHBIjX16ZxCQQ9dwh6KSP7jHQHe/8+ovlTFRD8RtgoUR8NgWef1oWF1OXJUsbTx2AD+BSamgYqqnviIwiH/5bgHfKbrpO773nu6FCCmMt1IrAGWdY3c6Pi4XtJpaxqQWi6Amo78jGAOOLBNHbCUKlIcvbjFb4lSGx9MK4LogalWWxR/2LCJH2Fv7ixLxJoHQd3Uu/CAgQ7u/uBQmrlZumVaFf8aOWKwnPm2ZMNCqfNhaQPCqNx3M2hLQ2+eZEHIWLYtPbeLB5pegCWbSpWEzN3mUmCkAGz/czKozD3/xiRxBx0Qo5yWIa3moba8hfNifOyuwhiDjAA2VjOgDBAvHeLodzixfLSLxNsgY/hho7Q98cbdTar
 +x5+Bpfs
 32pikJz8OglGj1oYycztn3P1v3qK6g/yZQS/vEVcWgyxXiSwuENw3WiIw7we6vUp76cfCeQpY5F9gAJzWLfFosz2W0oHyB8VAPlQ85aAl07sWZG7r6uhZZ0AnsQFuNUctpIYqPoU78cfVbkbawB/SezrWjlgajGCCxSXSFOJofOUewOb0BJECa4v81a1G4PD7To2Tpt6bD6Ei7jKKmZ+1Eq2Sj79NVWSZS9J3hgpzYciuuaDJGZ0mc2s0o35mbW7g/51DOEbs95yLUFXi3w+0bHK0R/OFBjjl9dGHdaIh9qto7vr83iNfFrP/O4m3DMDSVLjNDpQXLPVPv03clQyKh3eeFIjvclZrbjRRsr1ux77fmoxJbORRJshoxuA8L+28En8G7cTEcOal4Qji6h/KIhee2VKAQ98mdSY/F6tbEIGp1bE51L5Dqv4oeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to orangefs export operations to
indicate that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/orangefs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index b46100a4f5293576549300ae9050430c3f07969b..140f27f750939cf5538eb68501dd60012bd2daec 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -377,6 +377,7 @@ static int orangefs_encode_fh(struct inode *inode,
 static const struct export_operations orangefs_export_ops = {
 	.encode_fh = orangefs_encode_fh,
 	.fh_to_dentry = orangefs_fh_to_dentry,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 static int orangefs_unmount(int id, __s32 fs_id, const char *devname)

-- 
2.52.0


