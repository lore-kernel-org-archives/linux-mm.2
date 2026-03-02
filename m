Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A95E8EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18A676B009D; Mon,  2 Mar 2026 15:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148896B009F; Mon,  2 Mar 2026 15:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2EA46B00A0; Mon,  2 Mar 2026 15:26:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DFE126B009D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:26:58 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A7E11C303
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:26:58 +0000 (UTC)
X-FDA: 84502256916.07.A21E440
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B7BA61C0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:26:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9FUmhbp;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uE7W9E1GejGv1NEga+gHi6hXa4K/yHU62vCXmW06eoc=;
	b=faXaFeZoZjlzIO5jbKjJFP3oV74nf4jjASa0VGww4bcaruUqnpfbQbBjiU9W8YBV/+Wzxd
	85PeFqfk03YpsIWTjvn12YxsNC/LjEB2YXeYvdPF7+vXhPZGhsKMAs0Z9i0DGICD76RdLW
	KgEfOi8wZxmS36+nBifjXQL93FUvwI8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483216; a=rsa-sha256;
	cv=none;
	b=T6hGLqiJwlRkOgQcrlFWg8EkcoWURr6QFWIh5Hbqc3ijSqLP6FTPfUZPF2AdopJSn8k2GP
	2cjKZolBn4urxKG/f/g4+WQd41wTE/hPvYoHRIgv0C8H2zJ6hFktH2GuLaTgIOJCEMGRNV
	1bcLTVL7g2tp3NFDNBh6UWkmRgrnDu0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9FUmhbp;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CB5B6013F;
	Mon,  2 Mar 2026 20:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9405BC2BCB7;
	Mon,  2 Mar 2026 20:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483215;
	bh=pcuSLYfmNOsFzvDXp96caWKHF9+QhaBN4U2v/FyzFxs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=k9FUmhbphE7ZlYt9YsmEPGkz0bU4CWVQDwqgS8f1QOPvTvkN4sazSJkbMmCP63dNF
	 YDWhfNWdsTXXRWKxduxCIzNnD/30dO/SlLblszs9hL0cVyYgDpoBwgJMZUPo6VqZw2
	 UNeNfu5QfVNFa1mNd/98D6Zm2FhNNY2EZFtScgTzYFYM8kNxkH202f1DekWcztx7n6
	 2RrfFt5CKFeNDgoNyMFJgb4HCTqyblxAihCVC73XM0LuNnmTHQKKmG7FkR078S4K9g
	 cBflBedTRNNfKBTpPccxkB61O/hQ1DW/e/TQJkByiTe4HPgh5SfBNg2o61JrTJrz1b
	 ZB2gvbI8mQfDQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:23:52 -0500
Subject: [PATCH v2 008/110] jbd2: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-8-e5388800dae0@kernel.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2010; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=pcuSLYfmNOsFzvDXp96caWKHF9+QhaBN4U2v/FyzFxs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfHxzbZh8N1PXHeUBwZSAEp948ZGgaO5osN8G
 KKuuuuMwiiJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx8QAKCRAADmhBGVaC
 FW+7D/9wm3WjzYIdQjdh6bRjyfST5jzgYMO6C4GT6br3r886vIXvEwuSBzKsu5MNqNnbUOePAin
 F4OhvPc5X9XWEcCtW4ZcSVXPsmyDEnv0iIlw/dkT99Q3OyQTEJjAofAGXWTsw2h2lnh3n5Az00a
 72EQC65sZ/my3/miAQof2H3PLQjSsNBnuS5BxEMKMei2RDpD0mFm7NPZ5zIclcC+WDdCHE0Mv3G
 2MW9YDA5TPZdsFf4Jx2b/cFA4yw3FlFtKR0IiVN7nbc8mHHmiZHJWlRUQBFNWkfkqQ9mVB3PfD/
 82n4staT0LseRTL/IjHtx24Be6yUHaUrvKLFqnZdkMg+Xo+ioWXRY/KKp3WVNfR1R9slrMHVKy/
 35cg6s1++v5FWGc+cjkk32jE9197PBDdI1bs3pMbI6safkGOwFaeb/lpIF8kvx1YYXsIZQTEbmy
 a2rHgBA+RtXvuPYbH1rNZjERAL1VaIac1jxTQQKrPpD0uhIuYB+Cn25tYwNtLmFUdd1jW4kez3J
 dk0KfWcs8maf5L5MRle7/BQcaV9Ofv22UgP1byPmvcIlUeE7wi4HyFrw+k/fi6Ci8BSIXswcad8
 hJZPR3RugQCPQKA+zn/zagmRAlvKJvFxfU55BS0PuvHH8DPcWWDwddgAutJSX43+fALihnm58BU
 LsYBmgZaysVaI+Q==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: kun65o6em9epzmikd4hsank8rs18po1i
X-Rspam-User: 
X-Rspamd-Queue-Id: B7BA61C0005
X-Rspamd-Server: rspam12
X-HE-Tag: 1772483216-78155
X-HE-Meta: U2FsdGVkX1+ygdptnD+pdV43uKbvlfAzkI9SFRsyqrKkAETFS+24gVo8WZ/Y7q8j88OtowWNMgVHhuhXzIEcE3xuT5es39Ah4Ocr5HnuAxNWbnncRiY54iLWESixKL/a9jGqFYv6lplAP3PXJYSZMNZ2zxzI7UZWkLjSNThMs7GUh3yeUbjorlNRwoH/FrzNyBoBFFIv7uY/XKd9JyKrpxn91Ok90EBmIhYh8BfvOwj3DSYzb6YrhEWDfM3OoKPVRCDiBczrHan7HzkXDIzOB+djedJZ9R6CHKGpMwjk7sAIeZEnmn+tKZWTacAXxear9OLOslhhx/gMNYkqiEfHakFQx0SMaXMiymk3SxrpLtWVSjHzUUK5469KdXZVKczRuxeXVPCsmtDygFQb8wFrTOLRKQn9mBNlT+AsmJ6Lv5zLZWH6/PRWOyuuQMNgh2b1QDn3JTsem0TLO/+bewa9121gleHo3WqUt5y5i/aqKpFePRH18fY869PUg2F0V8hoUcwnje8cCmH2c9YbjKoq2c2I9uBAhACSg7GsBUrUtFHvms8vvqcNfRjCvrkQv+eyerN3JPq2iiFBPIFhQxBbU7fkDIV2tC8j+twmIxl8H5S6A5OmUNsmYSnyWRRQILRxVWa47uElvgcWCNRv7Q9PEN4lu/SuXo+VQZ9DSe3lU+JUeTz+4jkWmO2v3y7fYH3CiI8mc3AKcEgIdvT6QT8M975dZAVGhn5AwA0WDEKCxgjGCo9Bo7EKYHIqKgma+fng+iUqPsQMoI5C2TDYUiJrUhhnl0JdHlgC2SPuY+UEfBpq7GZIqQhfyA5rIqSm8wdiWx0u7x4C1V4vxxQKzEIBOg8O/Vq7hUoaNDcbN2VgJpus6IdI53OWsN8zAxKdysvQ0Mln0BBFlQwoT/Sz4+OCpQJzXp5aGfercmUX4ZqNUqjvawJqiXlzzzOq8NJnqHmvc7MVbLTs+VR579ala55
 u4arJDIH
 9+dAqURPP8bDaYfKyWUqeaID/a3SAQcDUYlxo4PRVUvlezoAeHuX3HiOXK+ClhIs0DUxsJ8R5GA70r/DNr92UQT/zHEGKUPMhhYSr6awH9TwP+LKhuNhC083XdxuYOgQ9LCD+bcB72B4seO6opElnFcixby+RKrr/kAfoKn8bAJT4/IdFHL3XiwY2TZw+Es5kccZaXufrlyG9b0D2EOeBLjhJ50UPb6Ou2YU/ZV3Gl27OXyLpgk4hLuMxTfyDLqnubLgKuZH0dlE3zHU8qbBpLUWs4Y/Iq+VyFMtarhEHfUcXFwL3KH6BuAcMrwSW5NCuOB59iGyODjFuStVN/UrhkYXUWIjG7wBpehtvzaa+jUctPBYJ0wvXT0osIIYSp1RV+PFQB4kK3ywSht63ZfTu3DqBSPRwoprZQK5AFoQpBhvwMMyLPfkNWbist20FW3/gbAl/69GmYgSa9lam4cUxOrUBGUGPhYJa505AYXe/GqExAAbimCihGV3E4tmJiVVniul8Y9/JTmE0RiiMp+9QeU3ENU97AELagyAt9gCaeo+6zFr+LeeVfrzAkZMSiAwA36CWJAFa2bnYUg1vTZ6B1KhKC99Wg5xSOmUxbqVljBWlMiVx+LBZqyaQoYDb5TZsGoVC289j9lIFohD9/2B1eBvzWYPI59HFWDkfwaChQtbasz3OJiFmNpum/qZxPh+JNZwg0W7PMiCAM6ym3Sd7TTzG7hf2QIv0JfCwyTQ6xPJt5xLk6L1OSZDx3QmML8Kuq3J5W7DarWo1VMgAdjGrtKE+viXF2LXMsm3JJYCowGl2llcqz8KKABjhrgTkU25GkMXLB0jfAeuikFWOjahJ1PfV7gsVr8RysnyYCyctuQ9/aXwbIS8FSQkQFkJ8uU0C4El39NsvjG7WwObXItZs0A3NiPYGYCv9gIPM3yjqjR7gG/D5eHhtcckkCpGRn4wHOo2dTUH4PbrytXQ4zKdQOPOBPw1M
 qsudmsBt
 iXVz3gMmAASxb/LO9SF0xozzu/7Hkg1vDC/YpwLyVo502vqFetsO2Ma8GDJK5kGpcWWAu02gUDOiDWCPfkPnoTqjLqToH0shQ8j/b8EoUtpdyBCBaFiy1O+n2/z1iDlcmWua5DrzFyUCYA2mrXoM9t8BPP6aAHravGlGWg/ZvA7OXp0elmfyqFHhkZkTaPyt4vjgEdgWyJ9+hBeZvyQ39b376+mTkm6TF6xBAxa6ONgPNI4XJ5NM5tIkwrs2eGw0Q/Cs+KHAkG4Po2xj7m4hyORXRIK+OQUj3hducCejpE9YjzDhGi8o17wrisjPkYFQVrM8wjQtJaukZSpJoSk2B1uq1rCsWzx8e3spCgNmbQWG3CCZ+KjO6y4hLvDV51JGOvlKZghqyjPli5xeWCKQ7m7qylY1mT8hSD9o3VmrofsYiTZovvTkoXJVi05YPvORY2CwBGMxYqUfmjB+Ljev00DtKU4hQ9KwQ41mw7FD7uoEgUv7UE9l3CFrLwUHoKMqD2AZRVWyT37eMx9R4Gj7hIOiC19ZTOyNq4+JU4IHsw76PnUMPlE7ppKYg832EyxcoUnJcmBmVSzit05GDvlK9gR5Hj5rx8cBS3fyIRDAfOBxa4mCfzuSVbgGSOYRpz7N3md8E5CxzLZFAZ9oyiu+8qOVAkzlzXU/dZiHdc+Cztmlq8dZcwWFibX6ZCzUiUB2PkvuFYpHPMQ2lUIF0FaqJZPvRVt9g1Jhq9GYBpwrZA31KdeYYrSZUvNIeLlKGobFOu6T6yh4o5EBJRVyapFe9ZgmtuoWEJr7AbIa0SWAVdyzngomjHQ738Ee77njlsxJ8g6MRKPomWWCCeOvVOayrmSX7kQosoHUcZUidFCCZua1FC5mLsNSR+Kfl/LsaymLuLcVQZ3FlLl+kiYth/hwPhcHlt5idME3f/fnmb4+zA+iGyED5Aubjh4BbehRizys5IL+C9H6YbiqEwEBlFpxy4A+okDZA
 D81aFR5o
 TuIPfm4zAViDZSGZ6DidkLKEl66cedOvrTqVXKv34y+7S4DkQf9a4HY0auTiTEu4Q8Hu2QDcNm3AiqfkODdiIx2Pd4fRRXY5CcWVXpWrecdfV6WYmpf1D8hFu7B/STHcDd+Z/TADj6dsXRBVCATs9d9cTubovtX8tt4tt5eTwa6lFtwlYX8zFAb5bVyIGsOvIeIHj7dMSKhsMn8Q6Nw28RKgzS79/s/zVnk99i/eYR1jKy4YYcGAng6fxHhcyzgazpd18ZkD18Ze4tUA0MQIxVBE/SMtu5TKvdp0zzpHiDPYVq0Cdl6eD7LoRohTKBswc53rta7SK4fEFcwgTGhrt+ju2A5RD4GAumiYY6aO5fYgfncUEashvaVZlybb6kKPtFeZ2CE9Rr3U3AQq5P9+RVf1CZ2Hy2INc/b2Frw8rMx8fv6JJsyDyzl6XXZbNlra4ip86voi132SMZgBaNBmIQelz9zx507KlxzS2i514+pG39xPtNCHi4DYZFpoZK6dNrJdi7cSg3veVyE+6t1DaFOAuNrCP8slL5o4DjCFh6rnbfg1fL/RElBFIb40HG2IjsORmMqfWCQSeUahwvWaFOVMiJ6ccTpLELNuQorLdB3WEopVvF7CN1u5tXEGU3T5n+g6gH0NIU3aPm3cdbGSTItk4sRxllkFueMIgKURP/oOBCTmIwYAJ715bKY08L/rIbcpdsaCh8Izapfb/ToqCLBt+KaogPO9U9xF7mJtqqYsQi++/RJtRf5LC71abjm6+vT35pKZbuR2A+l/hfI2VzReJDAXEOmp1QxJE8AVb1hLrNyyM3cUrQFoQlcQHz3IkLHTVlaosBFa5/OTTVShPcMNVmoeOmQtSEvQCnq0pV2A3j47XozaRuvGDIyXJDHnur0FK6qfzFGD5nfR7xTXBMtaatBr/H+XQg9h9a2YPjQ6fKZA9dRkk9U2qhDeY1smouLnbRDGkzdaCwcbNqYz28sJ/5G/e
 4YJsXUMm
 jjSsM4c1M0v1ARfXIvRRNQpXD9eD0JQkPNzVK6+DelwkUN5yY7w00KccmZY8AocEvXdQYGH2W0yJA1arvFcrmyMMBw6FxqlUgVDudxtCcESzPTSpkHAp4Lna8JrMbV533aBVmiBJ110Tf19ZZtVdbKSc4NHG7SKHtjGXQmcazBdGaXQHeNap5MYgOlwFxPjgKQdvhSgYLKjGuRWb7BOEoTS2e01GZlo49O4gsNhbP/q6MWI1k1dYd8gH6c4sPLFQykIJw2oGFMA1TEMeqEj9kIsfe7AlsHR9kOTrGKrX0sScVKnR1LwNCD+o26ZCXWo49ZEnlgA6Yhen0VTFFCItppyEL/ak8MQ7A5vqXK1X72vf/cChBR0LyPMGijL7PHzFT3PbrFxY7+KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert jbd2 i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jbd2/journal.c     | 4 ++--
 fs/jbd2/transaction.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index cb2c529a8f1bea33df6d4135e5782b9a77792732..9df937f0e15c71028038e1c0c12159421a2444b4 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1677,7 +1677,7 @@ journal_t *jbd2_journal_init_inode(struct inode *inode)
 		return err ? ERR_PTR(err) : ERR_PTR(-EINVAL);
 	}
 
-	jbd2_debug(1, "JBD2: inode %s/%ld, size %lld, bits %d, blksize %ld\n",
+	jbd2_debug(1, "JBD2: inode %s/%" PRIino "u, size %lld, bits %d, blksize %ld\n",
 		  inode->i_sb->s_id, inode->i_ino, (long long) inode->i_size,
 		  inode->i_sb->s_blocksize_bits, inode->i_sb->s_blocksize);
 
@@ -1689,7 +1689,7 @@ journal_t *jbd2_journal_init_inode(struct inode *inode)
 
 	journal->j_inode = inode;
 	snprintf(journal->j_devname, sizeof(journal->j_devname),
-		 "%pg-%lu", journal->j_dev, journal->j_inode->i_ino);
+		 "%pg-%" PRIino "u", journal->j_dev, journal->j_inode->i_ino);
 	strreplace(journal->j_devname, '/', '!');
 	jbd2_stats_proc_init(journal);
 
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index dca4b5d8aaaa3e1505b09fab42eb45bb201a8db8..2a03d4eafdee95e5caa8dbd0afe4e32ef4104378 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2651,7 +2651,7 @@ static int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode,
 		return -EROFS;
 	journal = transaction->t_journal;
 
-	jbd2_debug(4, "Adding inode %lu, tid:%d\n", jinode->i_vfs_inode->i_ino,
+	jbd2_debug(4, "Adding inode %" PRIino "u, tid:%d\n", jinode->i_vfs_inode->i_ino,
 			transaction->t_tid);
 
 	spin_lock(&journal->j_list_lock);

-- 
2.53.0


