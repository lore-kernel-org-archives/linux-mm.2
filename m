Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD837FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B0B6B00C5; Thu, 26 Feb 2026 10:58:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10AF16B00E3; Thu, 26 Feb 2026 10:58:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21EA6B00E5; Thu, 26 Feb 2026 10:58:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB3E06B00C5
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:58:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A755B7BC2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:58:13 +0000 (UTC)
X-FDA: 84487064466.03.DC46769
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B3A1C40009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:58:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tl95cpRH;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jgAvZj06sMP+kfafd+rUi/KM/UcAIqWvgADbdI6e9M=;
	b=Gy+cWSh9EYbG3ada3XGq7Y0IXZcMWtHiKIdcZxiSoqF5Mr378DdmToiNvt5yk33OSWzggE
	odjz7oG3moiy8OlXdlWUgm+RAlUH4z0XUxuZd1JdOHcV70Gj5AzAqqeOh6wGqhHWNJWHBZ
	gmbtyx/6rSasuS2SjywcrwUrko81EbA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tl95cpRH;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121491; a=rsa-sha256;
	cv=none;
	b=XuR4ADVXr1Her3bIe5xnplzuGddQPXdvq+tgJgfxZ/Y6JPhCsTAeAt8Lu71TkBm6JTaU5s
	lM8S5N8XMDCfqk6XBznK4YuTRtOK/WS4MMub9FFFzgYhxMmD0IkXviwB49nhZEkgybVZ/l
	zKg9/g6Gmmd46Ya1HrZ5z4E3vO5tk0U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C66614187B;
	Thu, 26 Feb 2026 15:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D41DC2BCB2;
	Thu, 26 Feb 2026 15:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121490;
	bh=ozE/lysUboEWCQ4+AsDbyvozbN/xqnJrVIKCk8YVbZ8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Tl95cpRHVEy9a69M1dPyVMNrFACinfcHkMSnrsJSJ41F1IPipWKjqo400vZ/NbQmL
	 YUPeHdgF2ouooH4/jZnPdmjQPX2RSD6dAFNXEQ4tMNkFK1U5S52ZKh6MacyqQwTE26
	 wtSaX+iIVp1eFKbZDh7W12pyubn8xXSAdxvT8s1HINUFUGTtKWmViGgo3to2LJ/GNZ
	 x3e9HhxcQyaf3N7GJfprPRO8OPW0OeidM/kJazebnZ1I5YfZCZuocYOM79vYH//gbU
	 evmOTHvoE55jR4g40jSZIXcwGHIK51p3FtqxaWtIEiTLZ9sMRLpKTTeDM+GABiHWej
	 gMu4A7jJHqAHQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:11 -0500
Subject: [PATCH 09/61] nfs: remove nfs_fattr_to_ino_t() and
 nfs_fileid_to_ino_t()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-9-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3123; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=ozE/lysUboEWCQ4+AsDbyvozbN/xqnJrVIKCk8YVbZ8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0GZ9mae1UfEzZjvJD4JiNnRPl5Nhr/tQ1B0
 m90fRG+XeKJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtBgAKCRAADmhBGVaC
 FUNNEACfph9HeCWuD/qrlt/anxXHRLFJ+N55/jO9WUFZDUHVC1uWe/qFGQB4inv5lvQdKqPNVQz
 kLo8M1E4LrqRBj3bgzhpjGtBRtdmYiYiFQt2QN/RTJcbwBIijGa0Lkeld9r6/v0YlyZZAyCJfRD
 NhjnwmW+pXiLmqpSqPxIJDI//+XA3Zd7HZfWNvamWsLP7P6pRi50+mxB4gSwNuE82jNnfysQ4hr
 xNgXlVCvaQVFcnQY4nIFqDesc7HZ3I6HsZs5cugSfIC7YhrAHnHgzUX1X3F1N7EqHIvN/ETvTxT
 5Kb1+IsLgP78RH9rlvcaM4+z6gCKQ4I0LX0nhb1q+nOK0/yF0B5Wj4FIAJRtnNLtUiyUcBn2yDU
 2B1itmjUhIwUONEgxN6+sBxZsrkmEvCoxhWKbIvKEt7ouyoJPHotIkpyi4Fy6G3gVMX+D962p6U
 +MNYPcdKlUz440uTYnQ0WbFTn+gtR9UZa+8V2v+kTpWMFOlvIa5ChRPEGDqjaMEAzTtgIJJigwL
 hAJZyp1hVGDXzIakUmhDjansPNiZV5PNsqjr3VQle3FQeHZ7zFF2ts2dXb0dky9ODuyE8mmPumA
 Sq2urAsWLtVirge+Vok4tOUNhvuZqt+IVPyWX3gk0VwWIFDl/IGHt+VH4jnZFmOmgKOzkMYIVTI
 c26wc1AgzjeJcnA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 75mg8q14qgx4c69aq8xjrq57r79fcso4
X-Rspam-User: 
X-Rspamd-Queue-Id: B3A1C40009
X-Rspamd-Server: rspam01
X-HE-Tag: 1772121491-33654
X-HE-Meta: U2FsdGVkX1/uv7MxYnUK5BKFBCn0B8BcXI4jkh+eQJFJNpqi82AxO8lD2LRryOQVdTsRqoLmiLKEIiQ49WdtI4+YGOYmK5ueQuBxX4HpNVwoNKBZmstbp0rkZlC5UoFjOp9rlKp5KegXsr5Ljc+J5HCQun24mVbyhtRCCaivuigsyPnof0Qjq98HJxyZwtdOR5ZtXNdXsesyXfcENhap+6w/FKd6FcveBJPBLpGHnQNTv73vfamn3VlLrp0Su1f72QEuabifwZWfMcKBN86uihmCa1UChn5iFQV5KNXeorYPybYrbyh8DUH1vXsXn5sKRYyEpV2PB4pmzUFuktqkAUmfAtxNYkwpS4fmLiWFjY574IBBKC4gCQTX2A3luKoaHqAX1xUnh1vrULH4Jl/+9NmAmfWs6KY5yprIC7Kf3fztvHatJn0Ef527jbuLs/UHsWDCZNC7NwG7fQRKCKn6aEJjsn6NAbJ8imEfZTai0SZbKdet7GOE4pGRfhcACkAOi8nnFbVIuFUH00OaV0dj6bpKkJ4dCD814POJ/vdeejrVQeGEzDFD4nn4nzzmSR75QqwTyS1c0/2xez1Imf3p1V2D2x5uFNCJvsewUEQugbBoDbbvHGxTTvtXeGt4OJBshem4lvwvK1/jEGrM1YOQVU4RhuJJO4PPbuUiEtvD5KKXA6n4aUbex7dc2ekjQuMtI7fqvWYzZbx4DjnCBJhEFdK5vx6iANc8S54G6PSJuuj/EsasKPXigOOYLxLh3xYnXyg7qlDe9O3ypiUazkCYkG8lPo5y3GOeF9FxFjqg9H9Gxnc8QM2IYNu7ykAgWgGptnYHLoBYcXO//U9EfJuAACoJnn+hjm7BI0C6I68+L8r0/encDSgHJS14/q3yIgeCpTJ9n82oJmf9TaHJLnITNxni2SWjw5odEQUxbB5f5ujx19nX/hAJNskJ7iDOsDLJwNOZcX7m3aYHppaEqcf
 Zm2cD7XQ
 esanZKdC741ajz5fFVXDL3zEEOXT7McoBxNGn0rn/TPgzeOcTusSD5yf5mxj3DTtA6vxSo4PMn3osw81PiipFf96XVGkixXsfbFSspVPXGvX/59VZTGXvs7+JnQ6K/Y6toD/WkTMLkej4X8/Nxa90/V7hm38G4miRd+ymJ7tZkHoWUsGLCNLyMJ6VqiXRWwIh2eosx5zMxT0B95Lw4RxspUn2ECgTEyPC9pTM2APF5CnGBzzP1Md+k8TVo4Gj5mUx4JLEw4q+AAuOa9n+s6/Bx1tWDdkYVcQo/mNn0UfUzhUXcyi/vn6gfwkYT5oVYszuQJfZCe8LZJ9XhrJRc5URFv20MUGCiREMkW8xC4kG1xN5dYheJqnwaaaTvcUx3WFgWeUqmMLc4DRHK1UyHzJpcnrQxqrghzx68btIVqAGsJ7AK/6U72ZKsuH7zffXCSsD3eJ08lysP1GtY+zhhLNTtmGAsC+aI7jyDtzStHSnce9tPx5e4ILkJM0yoGlumVXKrnRPhwB85ifr8UV/1iq8Pq3YlCrOefNuaFpQ+wZ7iIEjBKR9zSk2wcO2OB1uFzqbHjCs6x6AbFGjRBjlDZtp/mpMtcbBxd7sZMLclZ2gV0DxXEqXmZ2VSmhLnGhfvCOMz7PfkYkQ8iraZ4cMwn24epWhWG6BbCgMJ85U5CKq+ZNlmTYTGIijuQJ8ECekMvHTJd1JXQrIvG+f4dPT/HNxl5IS3RaaCyR27LN6wNeDddO5Ys+kxY/f/ClsIVi+D9T5Esqq6BKjWAa9gb894rF4zbdJgNofXxur9DJz478RYcMx3pCf6x+l68oLmZsF1oVEgGxh8jGyjjyTAlHmj6bxO9ptN9OOmU/lL9eJW63+J6+d1X1NvVoUb5WnwFc6No3VrJU6bZwjmA8+npJpUpuSwpLuFIzuLi31SU8hOjpx5bwFlufX0efhwQO7Fdv3asSCtzBhKpfYDucewW1M++xlEOTGJBis
 TDkowtkj
 GBXFxZjtbo1A/bQuXnrPTko5Q3StARQ64E8vGw7f4TqL9BBxth6n/I3Soyzy3Ueq/e2TzBrjb4IQ85ZrZA8CVKuq/G4pcUr5VtrYK8XK4ifrHYSqOM2bTjN1uoX6Ab2WDPAUUXaTJqb0gHAAJyeU9b4LSzcYCNTchVHvA0ZJB9Cu/kQxxHe0j21w5qeO+CSWyVfAT8+Vl/nezeX2tyq3xMFflLEWKSocWa1XOnDkZ2aJQ8ItuV+iD/nE/HD0UK167IKLeqbtxhi+446v5xvBCSvxiLW6YMb1NFeJttDZHrrdTuvkBgR19UKT0dTbBW4XmxdUCEW6F0NwiNVgKsjlndbKCzcKrF1n4gDjcznJu2KI9Z5YKhdJBF80xYkNOWS9JXRAbsftILIf+GUc5m3KORHuyDM9dQNIy+pTVo4IR9qOF0Ws0tOV3irLHJY+ixYNxzZG2Tghnr2CyX+cUnHL/h9b5qCwAXFVO4x/47phRlVZy0k9VfH7iZgHK4c0xjX/j9gkoWGw01q5fzdPozqS4Vh712qHpJ4FYorBam/oW/kzRDIj5ex6zNYJ4cRhsAxTUbnp+fOwvIFhU3NwOhEUdiKL7FAibvhyO1Op+SB5yOCsfBajfcQ2kr3My8h1AhPle64AOkubSeq478ePNj1dsCbYAixhR9KVOvtbUwfRNEX6ZOxD6XgvU0C6F39NXWIGd74R/0G9EovcXkOVmG8Fwn1noteofuqP0IDFepFmxXFrrDEOc85SpBD/AukDAgLtwO7lKJn3OoOG65DTDuGVZEPa6X4orOwdSCQdVw5E4L4i0kZXocuzBqAVo0wyDwYbfIjQ4jjSyP+EyHXFsBF5zOGaGSn4ejG+rZnQRqaZipMJW4zg4sjAU9lrTmGJI8lMQk2yXGcuGI5tJYfxr5sU+iHWWlPhX1hsu1NxuzfjMeNqdwQvtVNj3HjziLJEWAXv8HE53EMkrn1Bt9KITVd1jmEMDnFRi
 udg/jXj+
 CbG6wcpmu6D14/JglePFaiglUqGSgWfrVIv5Is9ZpEwWf/yVp24ab4OlxabOcYXGsBgVP2Ql61GM8yj/skBZH2LmUcE9tJI4iytYFEYSM9ym7nrJ3zRg9EsfrlPf1A60sQ4Vr99OcCdSKeyqDmfguXDHzFEmG4hP+VPq+6kekBPuqw64REMj7mVJ4UWV5u5t463bFsh5i0Tw4yxGgdyx9VFAp/d0rZfouvOs/IgOAPUZqzQUniXpjOt41yz0H4KKyVtH38Jz2a3yl6tiMhMA1CpPk/scP9jkSs9gUpqEUrfRVQ8evlQWwgtcLQ0nOdl2VQQyjA35A1dreV5nQArElihQekzwpKiqYCGu1AGN5Y5dquS134UoSkUT8CT7FkEzR/djf+YgmszYLukQQpOP57yFyNe4+0xSpYsVL5yAQuEDiIMVS0Pix8cWyIns8c2M3hs718dahb7y4dDKS6CtnDWWkKu7Stwc40HbLSz51YChE+uHmmmDn9AWCQyOJd8MolDteZsPzVg2+4nKfBkhghq1thQnYoHNZSAoIdB+sq9uHSZWYmekFBiMo9AymoRgdKkq6uZgvaIJq1WVRcAZxW+W7q8RF+JOVP6vgEMpcpqFD6gDjBNbLemsxjF+vzYLL3C5XanifGFDifdnJEw5M2xS63EzrLIiI8G7KzpKC20jTOZ0at0X0Onshvhob08E3uif851mex9axgt0O0pbFba62mJk11+/vtAcGXgWnxe3iykmjqWt4pu+sFX5C06UT5FRHFkC9Rrqsmgp1wyYRPkD1TZM7S5/ethFUj/yh8yc3bV1hTqi+5hlLjobqaGn12IAIjvQbQZuuzxLLsb9hXQBPEnkBrhFr7J85x7NSPPagsfOxEvDiFApnlYzz1XR0YeCeY4hZQx5HF/u93HHiJM529fBmmU5gLYoYeVIBGhbEmk9bikUJyfKrKT9VbtNZbmsp2z6bDEwA/92Y9vPTTm8hyMJq
 pG49uYvv
 q4L1mj4n1OT9PoOlTeEi8zO/MuGUUtbVYfs5d8ay/ADRolexM52rQMslNRZRixz/WepdKMI8g9/Bm8pamiVnVPq9CHIAVIeLGTbxmGJuTYTo0MrGwRDhDAUnQAmlNDZBXMeiQnMiPXxtUSll1YJ6R3iDmmjI6Tx7oIIpsw8uXXtuQAwpq/7fPS5DP5ZVN3lKLgGu2AsiLpoiJEMkrSj4mz4ySjatDm7kh9sG7Vj2joi5+NtTgipqObQ14gQGJnndQLoX1XQNV2IRXSvbect4PMLaTzrCyS1fDsFMtzBU2tu4EPR0VVaL/+EadmqvlPpjuVtC4W3OAJiVaL8LkNzdNDu34AJ39DoV1SEa6IHESOqBBkSNwVTuSAxPPXmDkwiUIKkFS8iQXUcjAClTEPPxpAygz0ByCxaIHvIpCW2sCkbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64, these helpers are trivial identity functions that
just return the fileid unchanged. Remove them and use fattr->fileid
directly at the two call sites.

nfs_fileid_to_ino_t() had no callers at all.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nfs/inode.c         | 17 +++--------------
 include/linux/nfs_fs.h |  6 ------
 2 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 38c7b79e76b3f9eb21d325b98708fe67d159076f..d88f5689548bcb4e27d6087a49b525762fbaa9e2 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -66,12 +66,6 @@ static int nfs_update_inode(struct inode *, struct nfs_fattr *);
 
 static struct kmem_cache * nfs_inode_cachep;
 
-static inline u64
-nfs_fattr_to_ino_t(struct nfs_fattr *fattr)
-{
-	return fattr->fileid;
-}
-
 int nfs_wait_bit_killable(struct wait_bit_key *key, int mode)
 {
 	if (unlikely(nfs_current_task_exiting()))
@@ -413,14 +407,12 @@ nfs_ilookup(struct super_block *sb, struct nfs_fattr *fattr, struct nfs_fh *fh)
 		.fattr	= fattr,
 	};
 	struct inode *inode;
-	unsigned long hash;
 
 	if (!(fattr->valid & NFS_ATTR_FATTR_FILEID) ||
 	    !(fattr->valid & NFS_ATTR_FATTR_TYPE))
 		return NULL;
 
-	hash = nfs_fattr_to_ino_t(fattr);
-	inode = ilookup5(sb, hash, nfs_find_actor, &desc);
+	inode = ilookup5(sb, fattr->fileid, nfs_find_actor, &desc);
 
 	dprintk("%s: returning %p\n", __func__, inode);
 	return inode;
@@ -456,7 +448,6 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 	};
 	struct inode *inode = ERR_PTR(-ENOENT);
 	u64 fattr_supported = NFS_SB(sb)->fattr_valid;
-	unsigned long hash;
 
 	nfs_attr_check_mountpoint(sb, fattr);
 
@@ -467,9 +458,7 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 	if ((fattr->valid & NFS_ATTR_FATTR_TYPE) == 0)
 		goto out_no_inode;
 
-	hash = nfs_fattr_to_ino_t(fattr);
-
-	inode = iget5_locked(sb, hash, nfs_find_actor, nfs_init_locked, &desc);
+	inode = iget5_locked(sb, fattr->fileid, nfs_find_actor, nfs_init_locked, &desc);
 	if (inode == NULL) {
 		inode = ERR_PTR(-ENOMEM);
 		goto out_no_inode;
@@ -481,7 +470,7 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 
 		/* We set i_ino for the few things that still rely on it,
 		 * such as stat(2) */
-		inode->i_ino = hash;
+		inode->i_ino = fattr->fileid;
 
 		/* We can't support update_atime(), since the server will reset it */
 		inode->i_flags |= S_NOATIME|S_NOCMTIME;
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 0e6d03c10c3de91cac4cd4d08c961e171cbf9a41..816670562d17b3f46ec2d22d4f9412e42f7e1a3b 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -667,12 +667,6 @@ static inline loff_t nfs_size_to_loff_t(__u64 size)
 	return min_t(u64, size, OFFSET_MAX);
 }
 
-static inline u64
-nfs_fileid_to_ino_t(u64 fileid)
-{
-	return fileid;
-}
-
 static inline void nfs_ooo_clear(struct nfs_inode *nfsi)
 {
 	nfsi->cache_validity &= ~NFS_INO_DATA_INVAL_DEFER;

-- 
2.53.0


