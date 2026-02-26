Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75A8EFD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4FFD6B00D4; Thu, 26 Feb 2026 10:56:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28236B00D5; Thu, 26 Feb 2026 10:56:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2966B00D6; Thu, 26 Feb 2026 10:56:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3E686B00D4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:56:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 401C58AAB7
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:56:32 +0000 (UTC)
X-FDA: 84487060224.29.07F466D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 545D820011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:56:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mIddKBM1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121390; a=rsa-sha256;
	cv=none;
	b=qtThuVbal/A2hSz9inPMVu0ykNxQuticZ1AHw52MW1x9SP3sTg7TKz2fyy3rrADbLNh9mq
	obzATVw605cJ5feqDeFUg8w/xQ5ewlR2h3lvn4cN/2ULDZ5mvWPxOQPSKtST/UNkhkCw2f
	Mpef65fLHLB3/sQLf4qHObXWgEYqNCk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mIddKBM1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PKwW8Yk3DhCcKQMywnvFE2IpOq8a7xJSyQtzlFa0icg=;
	b=Rq/WCiz60YrTcYVq31O2hgBx9rtD+4eLLpn0wwyOnfTXdGIZjToxBRd50X3nlyWViP+IqF
	8dnTl0AsvlI1nq9Hpwt9Z9dE1QXggNasG/0vBdxvVI52zneDp73eAzuPQXC9q71VRLfUhY
	AemdbKpaZIqnpaNNhiuuNtp9M9VjstU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72AE54065B;
	Thu, 26 Feb 2026 15:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E582DC19423;
	Thu, 26 Feb 2026 15:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121389;
	bh=kqyt5CklUcx3SkNzffqb+SP2F4CBWvRae/HkP27yv/M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mIddKBM1XrVR3dLlPcSb0SzyD8tWLh5Lf6oSzm6BRCDz17mcjOiZhnQ+qQOBwwomf
	 ExtmebvGYCHgYem9DeN8g8VYpFY/LC7Yifr6OG9OIMjAcpJy+azMBfheRhVWnwxtuh
	 HrzoGPdExxO26fMdqSOjfBmr6HjAbcR9DVT/dXQ1eSCb399e/h1QVktqrUsZ0ynu6b
	 Mx01BY4S00YiQsquUUBuXdEOJ/qDczdU6y0ESmH1QWEgWe0bRgQtRpOvREvqoRCsHj
	 tIsCl2JNh8Ia6eQlB/TwSG30hC9aP7EpqnLYMuWGx8qctykeBvD7QxRbXV5pVp16F0
	 9v2bf0tfiOBaA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:03 -0500
Subject: [PATCH 01/61] vfs: widen inode hash/lookup functions to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-1-ccceff366db9@kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
In-Reply-To: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Matthew Wilcox <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>, 
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
 Martin Schiller <ms@dev.tdt.de>
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
 linux-x25@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=11878; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=kqyt5CklUcx3SkNzffqb+SP2F4CBWvRae/HkP27yv/M=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0EBBcYmv1G5cCKfo2KCIxJusjNjE3iSeqU8
 ZJnXhKztg+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtBAAKCRAADmhBGVaC
 FXBCD/0fi3a6rxKspBHO06sGtcv25p+qnxMpOWntFE57YxJvYQrXSORyNdKiZpz0qr6XsiSVvKn
 gZ3TcTP5Fr1hqwI/TynEHJjaFjOUbr1zHSQ3OW2jAl2W5tSIsz1s6Nu4GaDr2As3S98IdP2V+R4
 gyyX1q/9H/8necwLN9rdjlwSv3euhg5ZoFknw1aVgvVsWH3urSMf06sm3CuPMJHSVmpPR0AUwHZ
 CqZyrrx3E9uJHbqrxI56QeZhEAplY5jmFgu00qXHY9Tb+ahUL7Zfhqy3MlbqCZyCVNDsEKNh+K0
 HkkBT+GV2G4cpd/vFbwHUPjUvRTbJp9OxTgBMh7oEumvPFvdgG8MD0l+o5DAo5fuJGoGSpTBALI
 9OzP+MrHxQLHxq+jeu4Oue/PrKWscMG0+HaAvE7JkKEj6eRQ0pU2AtrLRl7Ou2nVjSHwQ5rKQSS
 clOkG0rjpbU+lNOh/JdzIAhvUVbiPC8SLW8G7QBZofvxaVBbm8QP+qd0C2EO7ET7sjPqAngcz/B
 chhtxOKLE79PjehJw2dkwP27JXPT7z6OpLIY0cH+nyrNvW3aCvsQxsBv8aerUDYtdv2oftXBn3c
 KzoiPFyEp7ssNRV3Y9vsv1ky1czAJCKZqU7IoeUhsNIJ6i553sM1SmEqWAomzSe2LA9JxXeyz1F
 R+o5dlTMD1TYfGg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 33yphagwdctb8egjpapwt5qwq9htdr7m
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 545D820011
X-HE-Tag: 1772121390-642719
X-HE-Meta: U2FsdGVkX1/RNdnB3zR75NeUDh/rGfBn/+LTWEGusxbd/wig39ERSjY4ImCpISWQA3ImzTmOAUhmpPyZzTurx6wk/oTReU1U9CMV/K39GCddFyhtGXF2LDmV3Qhuc8CfqTNfmnOUKye2KuuGV8D3IKHQKRcz5c/TuJTrMW6AgKPOjb0RNZxR9xcofedvmKnAh4Jx7K8ZkmVYfiQcLY+rND9Fg1LQyoMvQsYWrGM1SBhfLs/9Dd/VxtISygZFJDJmE1QsKHfzWXbU1Ul9n6s9uFJKzhfzsDpud2qaXTziwOOUlpWvYuwGxg0evCoquVdSrV145YT5ESjM4e8ublIQ4fyeKRl7rzIaOt8Ew92LdgTfIJpSt+sjz9pfKgP0YGiScvPzvCg5GCcDEME2q1r6GLux/urpmeBYCPTAjSGFYodDY5bd1VBeZrLi09gt/3FDUHd6YCJdOvfoizK9lDhfWU8KnOf/HInku9/rP2AH+A3ktyruypuWp7u7Z73QLUOrp7QYtoXLDu3gmbHRKo5AJ6+UFHMX61c0Gtup4sdlhZIKTzAoFTxIIuNtVjlBYp8wuMb5AipmrUgvjbG8YH40EWyMnqCsXT9mZvMVpUrbEd5WliM0FfWSzLwuwl7aJ399ryGdGCYTFCNQzrgI6J0ZsIIO/Zj5JtreJUWCzRupJaWwWQwhh4vhKrtW/hpY3q4ZOEsn2jwPP89AhNYg5mQ4uA30LFG/E3AZBEG8eysfACnPEfi9APF40QKRFoxn1r6aod/XKiYrDIe3Xht2WrTJZ8lZEMUpvVRykX+PF2zc5ZTNg9oF9tTWfrcAtW0dSWojfZ5nDx95NLEyC5hYKK6MeggoDbF/rCDS10XTbpaHMze9z38EZv9AYFturUwMbmLPqwDGvOaeUXTEkLEOt3Ja73cRJY5lEt+Fdw879BUrVzLcu+XW5M371x1JBXYTdEmb4gyb2uqoiBNa+lJhKaD
 RZn+fg3o
 puC+KkuU1jU5WD/SKuUDblNC1J0dZj6kHefQE0v20PhV/4qrImsZCeJv8ep7wxWzyrMv1NakfKgLb0lMdIrWC5+1IwyJTqJ7NL8xdwcN738fsmalsYzrlE+2NNv/DVZoeSWXL0BCXd0jMgGEdQ+ySVeEkWIPW6OHo/+R3BM0XNH5gqx8huGrU5A9J9y4BaUqhixa/9xzdomeW7zhaVwJ9t+q6Jq9GQjlej6UdWN2M3gd2kgwt/UV8qyy8R1uOm0ThVGNk/KDmVluMNqlQjReQUACpX/ZQv2vAzYcCgkQaWE0xXjWWL0P/m37JjJdWyIGTebTAyPEV8OG67gN7jyfaLiomaHiqnwKk1F9pVH9GwREKbU/CxrcdbrfYd1CGVlny3KIZuUaL2n//6POLo9JpgKAvJ1RsekkNAC/e1wVmTjKGWDmlY3ca0SSb0k3ywjYwrO/KSoqp8xEyAXHt4kZ3XDTIWtEfZWSOzTt6mmLprsU1R9aPL61f3kkirlir+8nvhYlSiE09Q2HlEmeZjUPFmhpCEn2ydYHADFM4Fwan+TK6xKV70YmY6xk2RUi/pmBNdoi87a+/eoDm2VKUd0/x2ngBbNMosSkPXiJEngmnKYzz2zJi0jXN04jGYhOhQHmRa00lgbO4I031kyrSooc8FFzKsWtOqQVOJHUEd2Ycx/He4lUyWzPd3brKAAVwJ5PUFrfPF5MPa9Q7N9qVO7FuZN3OHMHkt/jbCrNqFessTTV5wuuoxNR1NA0vt6QYtmXCvjWqSRdyuKwak/gKXQdN4VJzma2CKeXl3NYPtmHq0NfNAYqBPidMsi2HjPw8XQfaJRYq0c68ZEtXx+PmvVUNLRrkYdJAU8gxl1JpkU3gULH2QL2WPc0BY7EYjjYiBRnPvpkdDllHFNAQGrvwdgpy46L8rFcl7zKvTW7Y1OzDvkV/CCnZGz/9uwBY1rzZucSdaKvX0iNNIdTMIKjuXFdDpQ2a4+Vk
 as2ng6sQ
 uTYSHmZGnYIf05fpW0UpBtPUv5X1U2eu8XeusBixEj2JjtDS6405RewE48/kLjGS9nyrX2PPiWBv9hj9h5sPS4XCCEUzqXUpOZtuxYxest2iVc+Tj2PIbUU/JOCAHdTp1HihABbDNQ/b00tC/TobD99Y2IQxbLqMxHE0eA1b8FIh4vc78Yxc3XVxnDTEkHidc9ytWNiCN9PMpXhencDfNWc0PuJU5jiliQqhmVoLlBe+wIBDV+j7SGj4/Uulf3nNxPR0rH8KkpRrOdVP8GCZP4+8CoE1KSA/Saxp9Qtw6K1kr2f7YoJySzc2BmSbppSk48NW4CJ1+ZesmA5V+XKwqjP8YlsQbFpoMm7poyZdSPd9YHP1rhXndjgoShObgGJYNyzbRgrkwaixzNLwEbVbwLy7uM75v+s+oA6jIrnNFzGjfU6dbQsj55tbV/36zryqBu5r019Cu7Bu7yZe0g8TXPqoug892vqUPoyWem8XdI/qvHOERmGMx9m6PhFvPkVtHeP+lPcDDVPDBAmb89+AsC/06BGrhBGLHm9vLMiDMbJu0z0eIhvY7x7ReVxgd8ASS+xkEgr0uZU7OvA/SJHwbHaLbaB1dKA9IGZRD4B3GogPxF6o50288Y/M9QibuFdvl5DjeebboJmWnfzfuNMTe8ss6I8o4O+Nf70Y27e8XGJNUaUzU8DZnShcfmvcGAQZ3vvkMCe3ECc4+AwGHL0UWD2o40Q7luuDjfm9elr2ysbrxTWD8UqCU5Lu1kIAABGoxetDFCZeSN9SzJi7dD1m5YUhBce/XT2gvrQLTzpfd/jvKAaRlzLI/QrzdbaQPwSRugWVK5GL+rLcqhdi6CgDWDniM2G66Jw17rUf1LPpt1RS1UW5ZqBUefwW0l/535hQwNRZcD6AhHlPbXupM/Jr9Bb2dWmfGGUNJ1TAeSaKDaI0XIB/TWXq7vcKdGwd3wuD20sU5r+kndmb8L4BkXazjFUqNTYrQ
 067jm36A
 gBaK+civ2irBxAgXUJBjoAZK7LSWn3kpNtbk8Z/fbTBJaZnpwajevSQTenw+Gv2vbqt2WXbqqMe3ZdeZRvTKoCtxoYn10OYQC1fypYUqLwtfUjC9azcXNRspTrrCu6NwcSujAbFm1vWQuxJQsfr8PsaJYwS5bGWhvhGYWDhkW8oUWBiqvK9Qy2GPTt5Ou/5Qu3o5q5xJqlnoidNQ1kZhafpm3kXnzDIWrpa67gSwcnByvW/GXfSalDyddxpfU2lqfMUlCtCyMZM4doZKfn2VLaQD60HJHWwlySmkw+cORdXeyekqbc2JBo+PuF1J1New7jRE3ZxbaUqgIO04YoCWv+uA46z0ed+OBrOQiozXFw056qxc+yRI7s5auy7lrmoFQ6zZeOZadoc3qFkYWFAi75eiFRtxsXinZkwvLioZg39EjZy5jElZxAnwjjTkZevuDyj0NwcJ2BGstNFxqcTu3ugsixpRPz4dWqAa3U7chvCivnkdr/cDb/Q+6CUnQIYgJz1VeYpUIBnHLiAko4keh1CGbt4YetOIhiRhlYBMsjvferJBpLAsoFfdjfUmxKHyqVn7JnTdXtnTBIT+p1yMHYBa5PnVtxqaosOt4wS1AYZndRV5P3Emqqi+jo3Ab/+1jShhfkIrpy8+9agpmk83Oisx714nfo0WFEap+IOuWQpgellydCUGY9n3mR84C75aqIHaPaBM/NKMwkcDtC4BHlScayTuOuAfC6XQXpV9l5wZxMAS8qF3Gf12Fgiyye9eFNza8Ksxh5i8lfw4T/zEVznm7sFe3XkJ/WMnM3JzWfZ+QfAsTxjErxI6pXGCGndTuHcryZWWvvru+8B3DHJ8DqqbjQezCw33LmXvQLahDE3OiADMZSiulu/l0uZ8WrKPYhCUBq1rX6ueC2lLNAQ0LElJCDiCz37+eVsZQTFbg6Z+cKAzMg1Ktb9yNbc7gM3NxXkGnzoTD0XjRC27Y1xPZuJMBVENN
 CO2tyXRl
 Cstfcn4QA17nwb3DaGShRuKPRyV51Jhy1tUYKZDBKQNQDyDGgMcN68sssGOt6iim2AMBJpTkN8bWrj5v18qBbt/OxQvJPtneDlmjBsDtXHVHqFX3CV21VatT1ii7bqyU+Eyk+0IWa73CUEampMy5989J6YrkV3nvvKwg6alX/HxBo7W2etCqDwIL85FbKHV9vOwt7aoa8vhK31nkuA88KHA+axiQtFRGIOYMX+vHNYA7/70YD6bRyGoU5ABPE2qXMAd/2s0yWQd28MhpdgdLRhbahrXtF+SSu7otRzGmNqBKGrYI/KCCUZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change the inode hash/lookup VFS API functions to accept u64 parameters
instead of unsigned long for inode numbers and hash values. This is
preparation for widening i_ino itself to u64, which will allow
filesystems to store full 64-bit inode numbers on 32-bit architectures.

Since unsigned long implicitly widens to u64 on all architectures, this
change is backward-compatible with all existing callers.

Functions updated:
  - hash(), find_inode_fast(), find_inode_by_ino_rcu(), test_inode_iunique()
  - __insert_inode_hash(), iget_locked(), iget5_locked(), iget5_locked_rcu()
  - ilookup(), ilookup5(), ilookup5_nowait()
  - find_inode_nowait(), find_inode_rcu()
  - inode_insert5(), insert_inode_locked4()
  - insert_inode_locked() (local variable)
  - dump_mapping() (local variable and format string)

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/inode.c         | 46 +++++++++++++++++++++++-----------------------
 include/linux/fs.h | 26 +++++++++++++-------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index cc12b68e021b2c97cc88a46ddc736334ecb8edfa..2cabec9043e8176d20aecc5ce7e0f276c114f122 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -672,7 +672,7 @@ static inline void inode_sb_list_del(struct inode *inode)
 	}
 }
 
-static unsigned long hash(struct super_block *sb, unsigned long hashval)
+static unsigned long hash(struct super_block *sb, u64 hashval)
 {
 	unsigned long tmp;
 
@@ -685,12 +685,12 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
 /**
  *	__insert_inode_hash - hash an inode
  *	@inode: unhashed inode
- *	@hashval: unsigned long value used to locate this object in the
+ *	@hashval: u64 value used to locate this object in the
  *		inode_hashtable.
  *
  *	Add an inode to the inode hash for this superblock.
  */
-void __insert_inode_hash(struct inode *inode, unsigned long hashval)
+void __insert_inode_hash(struct inode *inode, u64 hashval)
 {
 	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
 
@@ -726,7 +726,7 @@ void dump_mapping(const struct address_space *mapping)
 	struct dentry *dentry_ptr;
 	struct dentry dentry;
 	char fname[64] = {};
-	unsigned long ino;
+	u64 ino;
 
 	/*
 	 * If mapping is an invalid pointer, we don't want to crash
@@ -750,14 +750,14 @@ void dump_mapping(const struct address_space *mapping)
 	}
 
 	if (!dentry_first) {
-		pr_warn("aops:%ps ino:%lx\n", a_ops, ino);
+		pr_warn("aops:%ps ino:%llx\n", a_ops, ino);
 		return;
 	}
 
 	dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
 	if (get_kernel_nofault(dentry, dentry_ptr) ||
 	    !dentry.d_parent || !dentry.d_name.name) {
-		pr_warn("aops:%ps ino:%lx invalid dentry:%px\n",
+		pr_warn("aops:%ps ino:%llx invalid dentry:%px\n",
 				a_ops, ino, dentry_ptr);
 		return;
 	}
@@ -768,7 +768,7 @@ void dump_mapping(const struct address_space *mapping)
 	 * Even if strncpy_from_kernel_nofault() succeeded,
 	 * the fname could be unreliable
 	 */
-	pr_warn("aops:%ps ino:%lx dentry name(?):\"%s\"\n",
+	pr_warn("aops:%ps ino:%llx dentry name(?):\"%s\"\n",
 		a_ops, ino, fname);
 }
 
@@ -1087,7 +1087,7 @@ static struct inode *find_inode(struct super_block *sb,
  * iget_locked for details.
  */
 static struct inode *find_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino,
+				struct hlist_head *head, u64 ino,
 				bool hash_locked, bool *isnew)
 {
 	struct inode *inode = NULL;
@@ -1301,7 +1301,7 @@ EXPORT_SYMBOL(unlock_two_nondirectories);
  * Note that both @test and @set are called with the inode_hash_lock held, so
  * they can't sleep.
  */
-struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
+struct inode *inode_insert5(struct inode *inode, u64 hashval,
 			    int (*test)(struct inode *, void *),
 			    int (*set)(struct inode *, void *), void *data)
 {
@@ -1378,7 +1378,7 @@ EXPORT_SYMBOL(inode_insert5);
  * Note that both @test and @set are called with the inode_hash_lock held, so
  * they can't sleep.
  */
-struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
+struct inode *iget5_locked(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *), void *data)
 {
@@ -1408,7 +1408,7 @@ EXPORT_SYMBOL(iget5_locked);
  * This is equivalent to iget5_locked, except the @test callback must
  * tolerate the inode not being stable, including being mid-teardown.
  */
-struct inode *iget5_locked_rcu(struct super_block *sb, unsigned long hashval,
+struct inode *iget5_locked_rcu(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *), void *data)
 {
@@ -1455,7 +1455,7 @@ EXPORT_SYMBOL_GPL(iget5_locked_rcu);
  * hashed, and with the I_NEW flag set.  The file system gets to fill it in
  * before unlocking it via unlock_new_inode().
  */
-struct inode *iget_locked(struct super_block *sb, unsigned long ino)
+struct inode *iget_locked(struct super_block *sb, u64 ino)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
@@ -1527,7 +1527,7 @@ EXPORT_SYMBOL(iget_locked);
  *
  * Returns 1 if the inode number is unique, 0 if it is not.
  */
-static int test_inode_iunique(struct super_block *sb, unsigned long ino)
+static int test_inode_iunique(struct super_block *sb, u64 ino)
 {
 	struct hlist_head *b = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
@@ -1616,7 +1616,7 @@ EXPORT_SYMBOL(igrab);
  *
  * Note2: @test is called with the inode_hash_lock held, so can't sleep.
  */
-struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
+struct inode *ilookup5_nowait(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *), void *data, bool *isnew)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
@@ -1647,7 +1647,7 @@ EXPORT_SYMBOL(ilookup5_nowait);
  *
  * Note: @test is called with the inode_hash_lock held, so can't sleep.
  */
-struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
+struct inode *ilookup5(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
 	struct inode *inode;
@@ -1677,7 +1677,7 @@ EXPORT_SYMBOL(ilookup5);
  * Search for the inode @ino in the inode cache, and if the inode is in the
  * cache, the inode is returned with an incremented reference count.
  */
-struct inode *ilookup(struct super_block *sb, unsigned long ino)
+struct inode *ilookup(struct super_block *sb, u64 ino)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
@@ -1726,8 +1726,8 @@ EXPORT_SYMBOL(ilookup);
  * very carefully implemented.
  */
 struct inode *find_inode_nowait(struct super_block *sb,
-				unsigned long hashval,
-				int (*match)(struct inode *, unsigned long,
+				u64 hashval,
+				int (*match)(struct inode *, u64,
 					     void *),
 				void *data)
 {
@@ -1773,7 +1773,7 @@ EXPORT_SYMBOL(find_inode_nowait);
  *
  * The caller must hold the RCU read lock.
  */
-struct inode *find_inode_rcu(struct super_block *sb, unsigned long hashval,
+struct inode *find_inode_rcu(struct super_block *sb, u64 hashval,
 			     int (*test)(struct inode *, void *), void *data)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
@@ -1812,7 +1812,7 @@ EXPORT_SYMBOL(find_inode_rcu);
  * The caller must hold the RCU read lock.
  */
 struct inode *find_inode_by_ino_rcu(struct super_block *sb,
-				    unsigned long ino)
+				    u64 ino)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
@@ -1833,7 +1833,7 @@ EXPORT_SYMBOL(find_inode_by_ino_rcu);
 int insert_inode_locked(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
-	ino_t ino = inode->i_ino;
+	u64 ino = inode->i_ino;
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	bool isnew;
 
@@ -1884,7 +1884,7 @@ int insert_inode_locked(struct inode *inode)
 }
 EXPORT_SYMBOL(insert_inode_locked);
 
-int insert_inode_locked4(struct inode *inode, unsigned long hashval,
+int insert_inode_locked4(struct inode *inode, u64 hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
 	struct inode *old;
@@ -2642,7 +2642,7 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
 		break;
 	default:
 		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o) for"
-				  " inode %s:%lu\n", mode, inode->i_sb->s_id,
+				  " inode %s:%llu\n", mode, inode->i_sb->s_id,
 				  inode->i_ino);
 		break;
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b3dd145b25ec12b00ac1df17a952d9116b88047..dfa1f475b1c480c503ab6f00e891aa9b051607fa 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2935,32 +2935,32 @@ static inline int inode_generic_drop(struct inode *inode)
 extern void d_mark_dontcache(struct inode *inode);
 
 extern struct inode *ilookup5_nowait(struct super_block *sb,
-		unsigned long hashval, int (*test)(struct inode *, void *),
+		u64 hashval, int (*test)(struct inode *, void *),
 		void *data, bool *isnew);
-extern struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
+extern struct inode *ilookup5(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *), void *data);
-extern struct inode *ilookup(struct super_block *sb, unsigned long ino);
+extern struct inode *ilookup(struct super_block *sb, u64 ino);
 
-extern struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
+extern struct inode *inode_insert5(struct inode *inode, u64 hashval,
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *),
 		void *data);
-struct inode *iget5_locked(struct super_block *, unsigned long,
+struct inode *iget5_locked(struct super_block *, u64,
 			   int (*test)(struct inode *, void *),
 			   int (*set)(struct inode *, void *), void *);
-struct inode *iget5_locked_rcu(struct super_block *, unsigned long,
+struct inode *iget5_locked_rcu(struct super_block *, u64,
 			       int (*test)(struct inode *, void *),
 			       int (*set)(struct inode *, void *), void *);
-extern struct inode * iget_locked(struct super_block *, unsigned long);
+extern struct inode *iget_locked(struct super_block *, u64);
 extern struct inode *find_inode_nowait(struct super_block *,
-				       unsigned long,
+				       u64,
 				       int (*match)(struct inode *,
-						    unsigned long, void *),
+						    u64, void *),
 				       void *data);
-extern struct inode *find_inode_rcu(struct super_block *, unsigned long,
+extern struct inode *find_inode_rcu(struct super_block *, u64,
 				    int (*)(struct inode *, void *), void *);
-extern struct inode *find_inode_by_ino_rcu(struct super_block *, unsigned long);
-extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
+extern struct inode *find_inode_by_ino_rcu(struct super_block *, u64);
+extern int insert_inode_locked4(struct inode *, u64, int (*test)(struct inode *, void *), void *);
 extern int insert_inode_locked(struct inode *);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void lockdep_annotate_inode_mutex_key(struct inode *inode);
@@ -3015,7 +3015,7 @@ int setattr_should_drop_sgid(struct mnt_idmap *idmap,
  */
 #define alloc_inode_sb(_sb, _cache, _gfp) kmem_cache_alloc_lru(_cache, &_sb->s_inode_lru, _gfp)
 
-extern void __insert_inode_hash(struct inode *, unsigned long hashval);
+extern void __insert_inode_hash(struct inode *, u64 hashval);
 static inline void insert_inode_hash(struct inode *inode)
 {
 	__insert_inode_hash(inode, inode->i_ino);

-- 
2.53.0


