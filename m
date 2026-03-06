Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C8BFF01815
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 09:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ED7E6B0005; Fri,  6 Mar 2026 04:15:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A526B0089; Fri,  6 Mar 2026 04:15:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3450A6B008A; Fri,  6 Mar 2026 04:15:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 219326B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 04:15:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA4BD8BAA6
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:15:10 +0000 (UTC)
X-FDA: 84515079180.03.8E8795D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id F22B918000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:15:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TyR366hp;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772788509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Khay5Di4gN/G+A9UrPoC+jc9Xk/9Lb4+jkpc4uytkJA=;
	b=M4zESeFMHlQpFu7Q5R7dfQ6Ghc/C71PVH8juKAbFT4mYxwulzUbWNsNoIjqpCY3IVznhxd
	YHSF8SUkQvKvVLsHZ8i0QyArFJtR0hH8zIolefv5IXUkjUgJPUGcyr3qpBAfaBNXqrd0Vp
	T8RZTZmdzyzbfYQ2lWyUddcBa44MTck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772788509; a=rsa-sha256;
	cv=none;
	b=xX0Dvib8fbgcNx4fPXu+4MHrlEibUtZkDaba4AjH35CsKMsOSdqMkC3bjkrtAhlfWIqMKF
	RMyOuCvNrbIneZ0ilROWMyzeJlnfmYVEFEVuIJWlnTw6g/Btx0YJv28W0eEU6sAZn9R1SL
	Zm7QF5OWZqA0AqNtiOseBUdoMTJMqwM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TyR366hp;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DAE616012A;
	Fri,  6 Mar 2026 09:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C425BC4CEF7;
	Fri,  6 Mar 2026 09:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772788507;
	bh=7RvOdnrFs/iEe9G84pPe+q4PLv+gFd3Sa58Nl0eTC8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyR366hpH5SBgvb3stJOO+3+JgB4eyp8Ub6SIcEY5Wv5+DIXq3qwQ1akUuyGzm4GI
	 oVWqv0SYGKFQk/aIJcLbDc3SkZdh03GwnjPJPfc8DHBxnnTk3pTwokbH2aquirHejB
	 nz1gJxpKMhkWSd0cvlbIm12Yo0dUUSzlaMGnA70lo5LCfYmGHYkoB3BEoaWxEw9skO
	 0XSBCv8+kTn/Gf5HrA+24udlPqxoLhC1731SEC00PUdG+t6hKArOjAPEtT/hHxR1LY
	 s+VuE2scXcViJMBvNGcnMzw7bfK0RAeQxP1RLAMHfxMD+S62KQ5DOUo/0QF6h57vkJ
	 rf8R3FiiVNktg==
From: Christian Brauner <brauner@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	fsverity@lists.linux.dev,
	linux-mm@kvack.org,
	netfs@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-nilfs@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	autofs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	codalist@coda.cs.cmu.edu,
	ecryptfs@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	jfs-discussion@lists.sourceforge.net,
	ntfs3@lists.linux.dev,
	ocfs2-devel@lists.linux.dev,
	devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	selinux@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	netdev@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-hams@vger.kernel.org,
	linux-x25@vger.kernel.org,
	audit@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	linux-can@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <sfrench@samba.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	David Sterba <dsterba@suse.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Ian Kent <raven@themaw.net>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>,
	coda@cs.cmu.edu,
	Nicolas Pitre <nico@fluxnic.net>,
	Tyler Hicks <code@tyhicks.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Dave Kleikamp <shaggy@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Anders Larsen <al@alarsen.net>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>,
	Fan Wu <wufan@kernel.org>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Martin Schiller <ms@dev.tdt.de>,
	Eric Paris <eparis@redhat.com>,
	Joerg Reuter <jreuter@yaina.de>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	David Ahern <dsahern@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH v3 00/12] vfs: change inode->i_ino from unsigned long to u64
Date: Fri,  6 Mar 2026 10:09:33 +0100
Message-ID: <20260306-kennen-zubrot-2605fcfd6950@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=2708; i=brauner@kernel.org; h=from:subject:message-id; bh=7RvOdnrFs/iEe9G84pPe+q4PLv+gFd3Sa58Nl0eTC8M=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSumvWu2uNxbBFXikaZQKrMtl0PLj1c+kZGWOrvZiHz/ W/CTGOed5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk4A5GhimT869vPnNH4Vqj t6Tr0fqPLXs3v0g/qbXpwf6o52L5D7YyMnxU+idovG+O5JQe0WVOK45/sI9bw9AjJfah78/izrQ aXg4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3t1jyg9ta4q98j9bwjigby416tq6sptu
X-Rspamd-Queue-Id: F22B918000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1772788508-23847
X-HE-Meta: U2FsdGVkX19BGziPijmaP8U5UpuTQ5fe51HnPuK3WvzGuMq35pHnufHFk59ABq2s0Ysi6XTnZXCQ9B+WtTY+467BDpF6FmfeMMuun1fc19LLGYmGYuJ1EsvXs5j44Cax6ufQQ1Cx59MlbWAjciZ9NulY7pqzO2ahYIBdPsHniQi0bgBXsrm/OBz6QgZyGS6qHdHHeiRfHMgn1kAdNAUbA0X13WXUV2+REPoAKUjW/9labr0rSB2Yt8w+c1QO8T47oQAu+H+zML6rLh1jfbsPTN6AT/pWGtOiytKxiKdINrICa9B+4T8TTkRPLxBjGY7+2RW/g8uVGng0EIdUYNikDk8hSzeZyDo3Mk/cq+VinRwB63W/0x4YPM9G2/n31DugxG+InPpc+zUWWCYnyTvDzzspzCNrL1Iiip0xsDc9/xzmh1M+hVWGp5UV7vGqQ/iRsoWnj7WSZLA6OHd/qMHHHiKkcjWTF4p225quN/TTka5PgcNPk1dBVxpRmIitr33UhbVNsPmdhoIVstWfsXvkSLkZ1PeEGPWZOfO08Q1NIRZAAQ6l8ca3ctCay9+dVeYIhS2L+c0eaykbHcuT+yR0e/oepTCwbPlD7tDnyPZZFgcZuuzecxcMFDjf1adYggjJvOQIJGbvnse6Y2bkiQUJTGSHy0N72WgNIyVnYK4I/KKNaxums97nGWCd6f9QW18bU3fWvr3j+19m/ykzK7HJQ/mxaXek9cWi7aJGmJl2SqdVS/WO1bpV3jrQujCtydDpB6eL0SzW4lHr55QkYeT2jZVXw8H7hJ8pBEZST49ozt+9aI0Y/jDepqTpaYCccLUIBYxk/v5xcCY8Rl5qNjxb+kV63TE7I0rQQnI2rQQeu/O3BR5RzD9ZbtXaIp9vqXHp8H0i8Mu1YJJj3pIszNVV4SAT7s6rwHSJmv7VpR5Bg8v5pzgVLTsNguMClhtYHmtexH2aYX2AgzoLfICqFo0
 p+R1ccM+
 s+X10LIsRE8xhHWEumQxqpWNMeE4FsSiSA6N27KoeY8AFNcCvhXhjExU2sf0JgRaHMRNbfZQElWX/NpX3S3poDk5d6rJ6THy8q1z/zVbqMyQsY/h4U4tlvqVxBbTV0VXI1Mbo6MTYEyKqUZx9oi7QJe5S9VPh1ycYxK5difIqyjGcB2KikLBuu+OEwqX2O31EDNyfL8G14mAistQ3DV7Npa0OEl5GCcoTH9dfCAz2+APO2PGW7jtA/idBGyrq8qXOLTwBe2j3i2uJ5/b6syC3obOS7nX42KAAZOF9xVWl/A/Ryj7srmzzSo0I2aMrN93NlQ4D5ig4HOUEAe53xjuqQALMX9SG1vKPaeYhhnUVziOaal+lnTsgYZa4cQpjLtZbOyXXCbHlHwCBqSqJdkukp8ZyQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 04 Mar 2026 10:32:30 -0500, Jeff Layton wrote:
> Christian said [1] to "just do it" when I proposed this, so here we are!
> 
> For historical reasons, the inode->i_ino field is an unsigned long,
> which means that it's 32 bits on 32 bit architectures. This has caused a
> number of filesystems to implement hacks to hash a 64-bit identifier
> into a 32-bit field, and deprives us of a universal identifier field for
> an inode.
> 
> [...]

This series makes me happy. We've been talking about this conversion for
a while and I'm thankful that you did this work. Without the automation
available this probably wouldn't have happened as quickly as it did now.
Let's see what bits and pieces it missed.

---

Applied to the vfs-7.1.kino branch of the vfs/vfs.git tree.
Patches in the vfs-7.1.kino branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.1.kino

[01/12] vfs: widen inode hash/lookup functions to u64
        https://git.kernel.org/vfs/vfs/c/2412a9fa518a
[02/12] audit: widen ino fields to u64
        https://git.kernel.org/vfs/vfs/c/a5e863be4d02
[03/12] net: change sock.sk_ino and sock_i_ino() to u64
        https://git.kernel.org/vfs/vfs/c/c21144a0a33f
[04/12] vfs: widen trace event i_ino fields to u64
        https://git.kernel.org/vfs/vfs/c/5e5c380870b2
[05/12] cachefiles: widen trace event i_ino fields to u64
        https://git.kernel.org/vfs/vfs/c/25291f67aad7
[06/12] ext2: widen trace event i_ino fields to u64
        https://git.kernel.org/vfs/vfs/c/797d04a355e3
[07/12] hugetlbfs: widen trace event i_ino fields to u64
        https://git.kernel.org/vfs/vfs/c/3c976fb36a9a
[08/12] zonefs: widen trace event i_ino fields to u64
        https://git.kernel.org/vfs/vfs/c/988f68c01b3a
[09/12] ext4: widen trace event i_ino fields to u64
        https://git.kernel.org/vfs/vfs/c/1c1427c79bc2
[10/12] f2fs: widen trace event i_ino fields to u64
        https://git.kernel.org/vfs/vfs/c/6e62bf74bd8a
[11/12] nilfs2: widen trace event i_ino fields to u64
        https://git.kernel.org/vfs/vfs/c/6ce73711525a
[12/12] treewide: change inode->i_ino from unsigned long to u64
        https://git.kernel.org/vfs/vfs/c/af82d143e869

