Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3716EEF8FF8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8996C6B00A8; Wed,  4 Mar 2026 10:35:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D9D6B00AA; Wed,  4 Mar 2026 10:35:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB7D6B00AB; Wed,  4 Mar 2026 10:35:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7EE6B00A8
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:35:57 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C0B71405F8
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:35:57 +0000 (UTC)
X-FDA: 84508781154.19.2B67A3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 253E1C0006
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:35:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jJJZJuOW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772638555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDZuaWPZgFk4tMG1gIyQPKDavgX6Yce7NwF9HB6IFak=;
	b=0Fomtyou3CznDcR/lIi5URGpy/0q2ReAb/8XuI9lbJXh1lUV/EdmjKt/ynlr9IJsmWT8yl
	V0fp/Cda49fQk9HgYcKx1c4Bx8K4mEwf5rEdDN+CqPAikOZtDxqC7sQnA5bPkZ1m7hDLDw
	gC5dyW3P5klhqakrjjRmc0W7VzRawIA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772638555; a=rsa-sha256;
	cv=none;
	b=0GgO98yEe28bBHgkyEg/n2n+57VejC5DWgBq4w/dvb95LTj1nt3eQOQK1K+2MX3R5RS2Rc
	JUt4mCENIW0IxYUfpuvkUqySc6h5YBZSDjHQfvYHU9PgEpn6VLb22Bok1wrulIfgKrS5KJ
	J3eqqk9qrmISfGssD4BoXwIeCnO3yls=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jJJZJuOW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BCD4404D8;
	Wed,  4 Mar 2026 15:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CBEC2BCB2;
	Wed,  4 Mar 2026 15:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772638554;
	bh=HNYyRh7uJihRjIsYnqg9vR2rg+YDBytXVTWJLsChpBg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jJJZJuOWKhzm24HbRxXeYH/65v/yOXd3J5JeaPVpFEFHYCIk+4dI8RfwfOSUGeOWx
	 1wp0BVEDUhdVwfxuISed9ev5wqFzfZBSXvHUDpSQDH7LdZQV8LqsoA3S7HSPWWSIOS
	 q0zFPMue3eMREgGV2olfWoBJ85YhdTD+86QJA4JrqsDAypKCf/Fs0V5KoxG4qVZJty
	 ZHH8tVkHlwp57wEI2ERBSF6F3702iYCYBykR+h4S0T4gaLEOpYVyy5DjwzbNP9mH+m
	 8mdOGnCCkrpD5DzxE3NWsGzH9XNum7DQaX5HC6gb7/ZJs73mWVq/mG/j0amdjIFZjt
	 SfBKgFBpfKv5Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 04 Mar 2026 10:32:41 -0500
Subject: [PATCH v3 11/12] nilfs2: widen trace event i_ino fields to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-iino-u64-v3-11-2257ad83d372@kernel.org>
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
In-Reply-To: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Dan Williams <dan.j.williams@intel.com>, Eric Biggers <ebiggers@kernel.org>, 
 "Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, 
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
 David Sterba <dsterba@suse.com>, Marc Dionne <marc.dionne@auristor.com>, 
 Ian Kent <raven@themaw.net>, Luis de Bethencourt <luisbg@kernel.org>, 
 Salah Triki <salah.triki@gmail.com>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
 Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, 
 Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Yangtao Li <frank.li@vivo.com>, 
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
 David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
 Dave Kleikamp <shaggy@kernel.org>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
 Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, 
 Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>, 
 Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Ondrej Mosnacek <omosnace@redhat.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>, 
 Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, 
 Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, 
 Johan Hedberg <johan.hedberg@gmail.com>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Oliver Hartkopp <socketcan@hartkopp.net>, 
 Marc Kleine-Budde <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>, 
 Neal Cardwell <ncardwell@google.com>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Remi Denis-Courmont <courmisch@gmail.com>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Xin Long <lucien.xin@gmail.com>, 
 Magnus Karlsson <magnus.karlsson@intel.com>, 
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
 fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, 
 v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, 
 ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
 jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, 
 ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
 linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, 
 selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
 linux-x25@vger.kernel.org, audit@vger.kernel.org, 
 linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org, 
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2217; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=HNYyRh7uJihRjIsYnqg9vR2rg+YDBytXVTWJLsChpBg=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpqFCpn4jHLr2TGESURidfEFiRx4u3yOkCGmevg
 z8yGIn0bm2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaahQqQAKCRAADmhBGVaC
 FY3fEADG2lZ27yB2I+X23lq+iIwhnlF7pXPPYkX0oxn/MGtoloSrlLv/JlUE0rFS7OLEDmEFh0v
 7Msy8JGrmfcwp1mYgS9BHGKB08wHoUO+/UBe39k6qMASDJIty5gEZjqBQBWvDq/CBQv2+zbPmja
 v/XxPZ6UwR1/kBugt2FWO2bsX4XYbtCV7/rKeVgXYeVOjSEHUhOidxAg0EliqhPo/X1GMHdDpVh
 hlxhOEt2rn82p4aiYJvdaGZJ+Cvvh8ZHZYedZtBPbh2XLdI+b4HRjxoriFnvYkreDBHrhJaFYQF
 mDP+BJqPcTuoiMXgpEyByaON06H+tY2i2mtFB1ZxI2eel7Kz8SQMKLK4cb8mK7Czlwq/SwLc1m4
 FOICYEN2snlvZbhqRz7dLB00X4MHWwwH50CiofjSP6O3VMhimuiWG/e8wg/4H1gm5sZYTKUCM6/
 hbEME9qYhPsCqNagzgowu9/Ly7cNebcIrg6NuudFPojMAQGNOux1bGLLEuM1D5mPZqi35+BQDqw
 c+9Oomp2LgByVNzze60tZa2PrkudTHPupcbq8j59Kr7wLKoNAwh9vorVNGFsm7R0rW4k8E6YePo
 Tc6AgYvtiUDzFDOeJAt06CCLgph2tznpvQejcnIWoU+6g2Fm9zEw+sUQ8b97rt1cqbxYg6uxck3
 fFrf+jQCmVJvCFQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 253E1C0006
X-Stat-Signature: ww56m6wdzfbkcpy1tgfdssdroxt4sdc9
X-Rspam-User: 
X-HE-Tag: 1772638554-633614
X-HE-Meta: U2FsdGVkX1+pJFicZppzvXVGuIzxrxIalPLphVK4zhvKSAtc2lgxfXifVHz+o1v3Rr3GIqvN7K4W+x5R++85aLnlnBnNb5NZT56RoV4VUAb0YF7QVWkA9qkLFB8dAS1q7zf5nUoqNB/h4QSj7PjS+9ROkxKJ8o0mRoaVX5w4lU1i9116hSo3MWAPe+EUn07CKf835+P/ziN4wQinWiY3iw7jzWmDPPAGKGJT5EyvWPRQT6AeXyCbJlHvCPsAu9C7Q5/kfC6gH4uqs8GJc5DMxp4IEjV89SckgJ99QW43xGmybK9uYPybIocyL6w5Xi7nh5BHDFuq9wh23W/n2gqQS9DwLNt9gMDfmvvHJsrZ/KAK7xxSG3wRaZHPupPU1Kp3tVWpFsTh2K4yFtQWD0dsa2qn6C/E/sFWzq01SEzuspXbsiPRTbXZKUZGv0tqbkP1VXxfNW/PmFN5Wu943EFgjHe/e5rxN/RWvNcrx50mIRR7NYuJsxVliXMorQYitWnd06AlIdZRYQd6guKKmUS1GJTTzNJXUpm4HSxSNxqDXdaBrBvjJRDNPphNZydOreKa6OCYeURNEiMhntuvnMD6FqSY3vZHN/8KCbBW7uBWsj/pziPim27MqyfLjw6RusobEOR5swI4692yY6uiG0eSHM+2pPO8jPiznUIaOPfDMo0iCkziW8qkbWZrOuURzdH7XujbMNAKGAC65infhXDWYNyYjs2+u8pNEWZB+lw4qbeMeOMYLJYj2o6thDXTu0o20L+J1PkxAYnSLC6ZD8oP1Mbdl2YJpfsbvUL9Os0YOVS0lpeX9hoWPav2GnIgrr3IB/ZrhyT6+BEk6IcOJJZb5XeVmz4gM8d2BWK+4HR7DWqLab/hjuubFO8dBHQ07t/R2QEdL/Wjl7YICVP2dsx+NHsIh0Fs4IIbLmvPhMnAQsbZ41Th/Bg7RZxnu9XnXJhioKRBOZl0GfZkPEAIO1A
 hG7jNUyP
 pY+ZM/naSNmNs2LY3B9Al54PtKAru8CwpeObGNcMmL6F/1NYdZlrrrn7kd8cxCSWIW+8mgSNea1Bz82t6XC8CfEi7dyxx6LOQsLA7ygVaCkpk3rpBRdnIbt+PtmySaZfdCbKqh3BsxdIe5AL1O7gt308tY/inj4bXNj7OM8svI18bRlskBJKOpXzZWPVub8qmOf7GwAEMjGnpvlm2/kXkBPGc+X5C/L+8B4p1kl9OzukqNjYbLZN2uDRFBakrMveOpbPiBIpWuTJVjQ41SoN6bO0rCIpo31nNDY3uGqSLt7TyBoR2jy4pjhWPdR2VnCyGjdF2WSYyLHL1CDAW84iHnwvIoZ3rMhguRtHkvdB4iSWkd+AmGhxkx8U9q97+q3kuZGIv1+Ku1DIazZ/mtlecjaDm8RBgkv1K2qQIzKHkNkA9z7q6ZNUEqWX0VFywq1d2DDYDalnBNB1d9fK/QFSLAVbnOZgSM1nZOJA5VIRV6lCU2YwAgkfX+C3Qh1fgtqVojy1f/Ex1ZeQKz8wDGlai9q0siM0zZY/ccpsGUBS7Ke1tsNL8dwqAuuHPvVJLIKSAodVBprbhtWwV+I32dR2RPmGoyWmvdJX2XaWG2MP7ic9DUtykbPg7sO2gxHNEZRVg2XbBMeTVQ54Pup5pJAQ3hpZY9aBKrf0JHyPUKDLcDMyx66ly4m6VQY0VXnZg7LylyRoBcmAOYQ5Dbb8+HJxE9Oy2onuTOqph11K3QaU4xfZo5NWXdWrpTfubIXQuCxpwI5f/U0UQICrhvo0IUjUVu7nzcHv6lZEhSzorEj4AZiq+x81PHmW3qw88Nrfc8e6nyRQm5F0YrU6l+qVWZKPKaBVTEjF3BDoQtGoQqFwgnH+rXGzj3wQc3mb4D/l0dnhH3kA+WCVSrMqVqlOXsMQSzeybHZmlv9YGuiYmnlc4ZsgeeIw3c55BtUtlPuM6s7jBReGPrBwv5HV+dtONp6VLFRj4nysC
 LUcOl056
 SNG2lIuVIxMB3rXAtWB6aK+LsQjTuLWGee+vqrVC3N+isivjXwu5aFlIFsiMbIb4reiOxWZ8fBTt70sX+IXefPGkcOECdKxKvBxez8dNTXfuBi5qb8A5VGFEVsspV+BGhTQj5jRg7SnZ6sbpcVQz2vs5g76X70leFvdypKDWLOwHBY3s20DK3ZgYClS1elJ46K9bO5RIwBqFJMuSq6YUr61WfNUpKqZQ2k0gV6QPS4ryx23+sWgSROyODVsqMwfX+2kFHoo6Q4E1uUGrAFrhyBKg7ggf0BXVy1bXREFHJdqSz0jVjS/LQPRrdndltc5YNGLmO2ob+h0Ka9g19K60Ksukj23FnHLIN4QBqaIHE8i6dFEz64nOQm8QLJK+S+qy6PTpJ6cinzoOAyerSGQJ0MhpxeKJWn57YngTIj/+fu7CcChn1hKzt+952sDxSzk3JFdDm0eOxkq570fX5dE41d9jfHymBydI8EmLk4CNC98W6NbXC55XAT+zidV0G/M2SepVyJS8AeTykMEXL/f3fMeaVLPon5KHk2AbfiyD07NyRGnwhLi4h6Bja8MFPfnQoY4DTGOxN+rKnG7fCEasDpL24TTAO6iNcQGD7WRguzWZlNRz98zDPm+QbIXKE0axU6SIV2ESSxx+lwePr+nTMqEMTHLrHcGbK/IQf2CtijcsDgmHIWm+Zm0V+WDV5XCyFDpy6KQxh73zgL2wOON1grmZaVDdCtiiDjbYaAkFWPdT8V5RsxaJoaXyYreVqrpeUFoStizVQg4RpxCFjv0BwuTAq8hy2a8vAyt4LgPhweK3bDLPLpRfQ4Zp+nyv/wC8uyYg96xYYQqUhzyC6Et6Y179iPKR/3qYAjF0/HjfOPmeKYvD4Qr5xIfsF9qbt4JNWBgoK+mQyQHI6FQnr6eE0UCuSyMCTszSLVlhFuwj/pADrkYdgosPDsTu1LPcxu4e0IViARYRN1JFBNbnJ3L3oYuZmDj/f
 4tr4v3wI
 uYNwXs9CiTwg2KFYD53TD4pnb1lByw4HYmf+I8erY4BKfUoAyhIZ8xjJhil9hxTAwHTZNyQ/Mu4PMr1ydnR2sSNPDxT84adpYSao0kwyQv3HNiqrfklCSlavvWZVR8wskzg/HOBE5G7tn5oXIgf+ch2inP4bKEMj49OnZ0mn6xCxpX+IdQPmFQZmQZqg753e8KykXfxDpP5uTnpIyDJFFY66ak/IqzfxfbH5kGEObOeMwExutwfMIPn0phoQoIY6zbgmh6fMO0HZgHrud0evwiHt+czXvvGUW+fGQYn7a7vBIlfPbZuTQ0aJDzKA8fM7eQtqUpzx0TK/nJjjC3VZ0y+llL4Vr0muRmDR1wyEhk2wRq2pbue6Z2tWi4P3cLyBFpGHQwmxCtW6lLZ1Uvoo/0jZdlU9OAxtcwF9+nrbTtY3Az1QRTIdyZY+wPsaRvfcbXzBWjHuohHncd7tnWhnNQOn2lArNcMpSVVugoeQurW2h1IWL+vy6rg/eUMdXQi0uUhHXW0L6bE9bB8j+ykvAeQ0r+lMcTzJsuYt28OXVbUg/D4XMmho00GEFPMgooG+zTMiLvbZK4cnPhBr3uwOh+3f4VNu7KkCKS68ZVxzcLUPUpcuwTwhWq9Y0ZmTIqOiOlxdRyqIbWse36R/7+gkwgsvlLXBv/OHhsx5gVQvvNeEFXRfWWchbP5RZqWpWdGVLrSMT+iIdBxr4H20IRMS+cslZy5WrngakpH79hfYXjfHYdOvpcddVP4ebmeve+RwU07DxnYXPwFXBnN+HgQRgIvR/tKCj+eCpuPLfrdRJYDyQLXi8OaDvK32OHALBTv5HldN3I2Psoe9NAdvl20w1bqbAogHcizTVUQmLJ7Fb+MLeyqN8hVasIseyq8gl75oHrqIj5iJY4agYi0yV1Xxsv8sMunRRLLG+22x5T91ujW77Cx3DrwH8JTi8+wBRn2wr4XyluBLRxOJQWWb3rKlJI5teYAGQ
 EitZL0ji
 stRNCQPvDJ6NrCt14oJd47vSng+a1vIFCdP/lX3q5oAs4wSPO7EyyVPobs2YK5pl39jgJPljUs6vCcGg8rtldBKNM2UL9S+FY5WLtTjE3T8ruZdAYssU2H7WhI3284tS3jGNdjFq2xXBIhTRRdtqReSS/NnSeMuZG0rpOWYF984e3T4bt7QNBuEuI5S/EKormxMXPqssEJtrY95zSGN/sYT9h+bEC/19eFUJjLgaV7+SV0WJvSuBus539wEz9PzRhaecokwdjXYmhVMRsTeQVxi/WYz6MLmNBZ9nAHM5YpcyJHR0BwNV/mj9Z8xMvVnk+WRTs97Dyr5o43/imMvqcBOgC03Bh7uwCR+85m3yVHGqwveTiqhxjSceZqKTLyTkvMqPfLor1c5/7v64QIVVl/TIwzvnbCCWVAu7waRxxz48Wz4NQtNktCw7Wc8Lryohy+r6eC/t3emZ+g9/Vkhd2oWw1ntMNkzK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In trace events, change __field(unsigned long, ...) to __field(u64, ...)
and update TP_PROTO parameters and TP_printk format strings to match
the widened field type.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/trace/events/nilfs2.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.h
index 8880c11733dd307c223cc62ee34ebeff650ecb12..49efbd209585b294f363e950e8ab266f533a9eb6 100644
--- a/include/trace/events/nilfs2.h
+++ b/include/trace/events/nilfs2.h
@@ -165,14 +165,14 @@ TRACE_EVENT(nilfs2_segment_usage_freed,
 
 TRACE_EVENT(nilfs2_mdt_insert_new_block,
 	    TP_PROTO(struct inode *inode,
-		     unsigned long ino,
+		     u64 ino,
 		     unsigned long block),
 
 	    TP_ARGS(inode, ino, block),
 
 	    TP_STRUCT__entry(
+		    __field(u64, ino)
 		    __field(struct inode *, inode)
-		    __field(unsigned long, ino)
 		    __field(unsigned long, block)
 	    ),
 
@@ -182,7 +182,7 @@ TRACE_EVENT(nilfs2_mdt_insert_new_block,
 		    __entry->block = block;
 		    ),
 
-	    TP_printk("inode = %p ino = %lu block = %lu",
+	    TP_printk("inode = %p ino = %llu block = %lu",
 		      __entry->inode,
 		      __entry->ino,
 		      __entry->block)
@@ -190,15 +190,15 @@ TRACE_EVENT(nilfs2_mdt_insert_new_block,
 
 TRACE_EVENT(nilfs2_mdt_submit_block,
 	    TP_PROTO(struct inode *inode,
-		     unsigned long ino,
+		     u64 ino,
 		     unsigned long blkoff,
 		     enum req_op mode),
 
 	    TP_ARGS(inode, ino, blkoff, mode),
 
 	    TP_STRUCT__entry(
+		    __field(u64, ino)
 		    __field(struct inode *, inode)
-		    __field(unsigned long, ino)
 		    __field(unsigned long, blkoff)
 		    /*
 		     * Use field_struct() to avoid is_signed_type() on the
@@ -214,7 +214,7 @@ TRACE_EVENT(nilfs2_mdt_submit_block,
 		    __entry->mode = mode;
 		    ),
 
-	    TP_printk("inode = %p ino = %lu blkoff = %lu mode = %x",
+	    TP_printk("inode = %p ino = %llu blkoff = %lu mode = %x",
 		      __entry->inode,
 		      __entry->ino,
 		      __entry->blkoff,

-- 
2.53.0


