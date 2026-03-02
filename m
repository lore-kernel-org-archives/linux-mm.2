Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F736EB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8066B00E0; Mon,  2 Mar 2026 15:49:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8C66B014E; Mon,  2 Mar 2026 15:49:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72BF56B0150; Mon,  2 Mar 2026 15:49:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BFFF6B014E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:49:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23F395864D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:49:01 +0000 (UTC)
X-FDA: 84502312482.20.89FC586
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 42385180004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:48:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HAdByGNx;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8ttBZrVSDPEgvD4uacmt5C4eEvNcZtRM6YJVKaZUlY=;
	b=zhjW86dW1lju2HUXfso/fG2I6JB2jFZ9wj1qg1awLwC8tXgXJZbTqQSDYoljckPCQQzR+M
	gX84YC5veBwOEwOWOjSJi8zgpydfqjjIHK/nPQTw1X1ZVuQf1oSOdI1ZhqHcpRluXU5MoP
	bHi579yXLjhxy775lmoODxhH5X49mgc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HAdByGNx;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484539; a=rsa-sha256;
	cv=none;
	b=HClljxJvwFG+fM4fuRZ9L9f6epYwy/zr5X3EQ+4TMwQJpukkWVbdZVRHTd4cOT1CYyejTW
	KskbqFwDpz+ospboICuUYlVzFA7c7N9tOEAIFKwEMP9wjNf6Feah8PiHR6QGLHfY6qAo3x
	zQ+ECMY+KLWgzv19TWFChzPVjoAyaD4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D44542B6B;
	Mon,  2 Mar 2026 20:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC80C2BC87;
	Mon,  2 Mar 2026 20:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484538;
	bh=tg2GBJRcO6vMjzaMBfFcDIy8ZKyDb6aFMJ4tiWotI5c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HAdByGNxmW08C5+Re1Gb5QIfJvh7W3RRSi/6F1cFsEwAggofFwWgUeimzkFbyPUOY
	 BpMrZkgal8HWLqJmZoa4CfJ7QVPUqq7RfD/5KjaGUc9b9JhvdHLpU9OhGpPUoUlJJd
	 SZjhUtdBdArACAUj0Ipa6ewEj9LZrDhEZ9jEQEdzYSV4nQHTDGCXynbDj1OiqZi2Lt
	 4n4XPCp/sOUx4Rd8Ra6SNXwf1wjb9CfGYyrp4A1WIEmsdzPIq1g2oclhZMvtCjNsMw
	 Dg99kikAcdt1Fs2ylLBOi3qRicncT8lP5mr7FE2GkTwVzBq8TP0ONXslliEImrfNkp
	 SXdV/u4Pl4BCA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:24 -0500
Subject: [PATCH v2 100/110] zonefs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-100-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2133; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=tg2GBJRcO6vMjzaMBfFcDIy8ZKyDb6aFMJ4tiWotI5c=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfILBKyvots3fqrnm3b3+1nlzkkUuZL/UNO2s
 Y9u3WybBLWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyCwAKCRAADmhBGVaC
 FaTTEACnI/vvfaLeyQUKf94n7FqC/B/DSywMOa0cw/ECthv67Dj41AVTZCneKCKSRZyANNa0WYm
 l355RIIpHOTBxXnpFXD3lksIkUZGReQER+Kf7NQdgCd8qaVBWaTtN3cWUaCA2OqaFslA4cikPE9
 PgHwcvjs1KYGo5O0LkZdoG30AKyzvktYdZWwJIJ5VkEoXNoG6YDhBMWa6SoJ3k0SAmFODLK9y/8
 85ngFaMnf3d/jFNL119T2Wz5/yPvuuSoxBRVTVL69qYwIvooH70O3tkujVGx30Y1MnoZW4twblY
 QHSNk70vhVl1ErSJapAsovk0wHdpIG08OaSHpvu2Tpk0Zm1z+VdAP5Yv5rsbnZN16MeQ0PqnRNk
 lXmao39Wa1d/LpsrU4m06JV0AwWp01RdNKTDFM+6EuXEjfyA5a+sT19+fZFgcc6mJr1XRaDsOm7
 MuQAqsi5tBg8PRKxpaY0P50OUbiygtpEY6PgdMtoSBKYETXU2hcTGAMnDy8SUMe3x34cQYN7R/L
 dpY7ZOfPKPpdV+otDv9XGmgf1URb1UsAddW1cfbJE1thukY6ybg+Tju8ryqT6GDUFjveLyMt2AC
 YjvAmlVC0KZOohNIMf6SCTK+Xxt3XSL1YACXE2p7jDpiveCgGw3dzRLHVuB0b4Ap3nMAXHZOkfP
 vtZAladjPrF/TCw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 42385180004
X-Stat-Signature: z5dzbddy6tyo3uedymk3phdexg7hj1ax
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772484539-59985
X-HE-Meta: U2FsdGVkX18x7EhrKQcN77pPwwLVY7BIAdjl5PynjHlUarhYgJiW5/i/oUsX2VwIcRNvzuU0I+cPfy2gnoJiGNHMwo2RBI9jMxa8fVAwn4Zt9rrBpVEQ4kURecs7g/RjP1+CLeg3yEfEA8OhsQEn0aRT9wuLRGSZmSpp2DpQCVMKexSLuH9h7Rz7NsKS1Ki3TXweSmo2jaWXd5HLACLUIW5ltqzZ4HVurMprTi592e/ZMKgJ2QUYQSfi5KD1rGzt+ElX+UZvhQjZsD9WOzUpjeZqZ0XLdCIoBZS3TI3ti1vzip1NkcK46z3bYzcZW1Ireq0muvvqT0fmlwv3PFhjDRdtu6ekxKhXjyLKU5um45T2xj12H8ltm88Qg90pCNyU9VEHMFu4f7LxZFfLEvNkke58tSB5HGsgI4E9DgJbx6gXyKwGvCme0LVJowkGD8II+8dgSdDGit5DU0n/sO06A0M37mZdD4/Fm3OnmJVbkCd3qLXpCuQZo79D4cTAyO4bzbv8Tb4RPDPQ476RvbrRxHAKpMlOWiume2Qrr5h9dLfwCHXvzgJPk7dfsdgRXWtOziYGAO0n94AJCawgfeqDm2KMM7qsPyqpSNVLNvCrnB9OcpxlcR1du5havHwv/WkJy8Ic8T/0GIsi+5ZTVl+C0KV8A4omCHa8cCm64C5bvpVuxHp32G16arqV8+XXEMNg+yvBt//1rknyf7tYWABZS3NI37lJZCnEixvpYlT6ZHBsIg5K6HUypqUJc4yk3oinRQ+90a07PsqN9Og+O5VViqeY44zpal+OpYb7RUhvReAEma0INm5HVWRmnY10nejHTkv+hD4k/aLQL2wGZ5QrfRWHvbM8aOS2Vu9qICtNNbiP5jxsqt2fJi8cCHzsRGJxPpk5Bvmd62yn9vb2EXCrKFzrnuqo09zGpYgSpfvzH58O+ivakPXiDQu81P4z6TBmezZS4KshX92x1wgahPX
 VcPCWp8b
 1os9AANcur9yv+ftdZDm1V2b41MpiwLrkK8VpbKAlZWYnrc8gXe6qlgZTyNsQltYVrb2JsXf7aZEXH1o9K8gdsoSqH4DzoTurQJWn9FwzCCe0XwP3rJfx8xCJuyW4PbkVEIAJFNl+TRDYq1JYAnnjbwcGrv5y3X2qNF6c/AkmGyCmO/13tGVjfndH5Yb4vGcEXIOwZyPzsOr0GX3VJh+P/1u+d+cIfQXa7XMLfYMU6S/YOYbUjvWAaXrWNL0FCQefONNSRU6yiUoNo36/z8pEgObT0re691gDKuGVswDzAuAfTJMHd0rqWu2QjLi/i0drdn663wV0VqPQ80F2RE56kZeYLAOoisYhBswXDlVRg/q3IqicwmN48o0ZmubZeIPQF6kdt4O626TotzVJlgtwdb9wTAKrB6mH9Zc0hY1Z/3vEKHXFpe5AM40UTtwS0i0Us2J6z9wcGzGdBqCWKdYNw/N7UchkXqdtHB0Sa8hNH623OiK3J0nHZrIa2oROnXdspEFEIJ8yLnGyM286OU3tFCeYSjBkpKI7FiEZeOGAMNx9qbwDeP/gqzchUQY0r8LdWJQDWUGJsGX5iSp5IfqJVoDXbdb1jypKLNkikbNIn2qQF7gD8zes0tQiX0m0HOFpoF0b2fzBBy1IntB+g0Mm4SOm/2fuFnnEzLC+lX73eKKhUuF7PNiYgsyfcUFCZ2QJTah6OFPemJk4yyA/dvDdZggqTCFNs8/WCHwgIGcgHpMDA2a9qH8FY6StGpEP2FoGXdXn8Mx4Q68Nlur0PVToNtJbxddQOh8vWsbLXD1iOT4XgSMqpDWdM1MS0MPWJx/UnwE2WrMpvFGYKmlNoK6VOJk2gtRZ9vILv+7zo3sMbpVRf5SdvbJJtIbEDdg157wanZkyiCkWApq+11zxyotKf1WF1z7n9+wFpx58GxjZI3gcPYngVGpobVB/wFO6p5ZaedjKAz7+49Ifo+8oIHxvE/V8F+0g
 LWL5AQ6q
 112NGNoT2kBBTJt4eLRyFvcVtUH8OGKPgHPUBdZ10Qu6/G6Fqz+3kh9H67/TpisYHjUHLz7esrB9iHya+IXmbMCS8dCm03K4yQ32fv0jhdS4sX4s+h/AML9PzbEIaxgW7gm69FpzAUJrzKRKVttv56DbqPZ9j0CI0GWI04Sc2Su4WAROCKCvT3EodeFPkVGmPPfbUTl4JBdHz8yXnc8T2Ckjbmmi+J7fcS5h3uM1HCP6wPWXMQqYTAp3kAgeU8Y4LKFGMbUhfiXOROc1JvYsYoTnFQ9zgmKA9JW/V5hTssfEyfFxBg9L6tAMVaBtvpcR9RZJLQihRXLdmjEI40JECqFMg5ZPq/dTSE1iWOHIePDZQdbvw1BDeZxk6Ib115oJKR5UMZRaqPyviTN/Vz78QQr6aLm52o3KsyDE2ohZND6IWi/wMOzPVXhP2t3WweCezl+BbA7PA4pvK60zjApfUsmHBFE7+oZQttjqIO3wylxUmQBVp9acu7Ag2lEK6AYm5h0a+6Iuy09AleYtA6wGvukuPUElPMSCCpxtexe6F+9FOC3zYKDBjkoc8kfT6oHwnqtuF1iK6X30I8+AhmNfKN5LH1tlhp3xWOTqWGT3S+NIozgXoK1Da8Gy2MrA9ZocP+TFBkmTOsH4bmiK5ppLgzmfnpjjXZlaayu37dtPYXunzB0eXZEmmONC98ibcQzAVPnBOfy0KGDfnjtqK3+MgeQ+/ibmjBQ9wnt1IK9g52Ub/u29N6TITiN6rqT1LrBps3CkPGNDHbH3uvrSO9HQM5+cdfLD6tdtARLM7g4P75KH2kDp37Tp0TfGnfXbxBK5T5WCRG9Hliu+rqKmbTe5MlASgAZaCt87xhqlFRf5ZO9UArOKGe/Pv0Mj4kl+VVIntHHgU13R7ZFBxNxqY+r+kt16JFsoH7H+8b98wbPCtKqvAgWcQljuqHZ9eQ29Gfa2lWE4UEXOzfxXl7Wc/SkSNI/w9/MxU
 r9H11wwp
 u4vgtXY0+/cZGcR/Zzhj8BQzAkFmAe9lLiKTHgZYVvGQ/02ajCz8TLpkbX3uWOPI3WKnq4ZsyJxYG00L0+ymm3LVhyyjnm87fD/BeKNuRjMYtd2u23cgyyTypp83o+OmM3v8gfIp8vKvuIbqPCSynxXMU97OE3lPAPf+O45JFUtoWmPbqLglIxmi7NlIGDYvkxW1d3TUtW3ZRD/BQGzwQkCtfWEc4mgK1q0ulO6YYzmZQazrweOxZIVnjtJ/3hUtsPdYQl662FPwlVWL2iEGiGsAQlT+HmvdRTbQBkt9eulATVBxt84mnxmbJXGbxfTV7UIJ9t3RHlUE73rnW4w7rq9PJkGVj4U4Zr4rjLop/ZcMwgqEq/V4OxIGSI1evBTAprYrWkY2BrdwnBZK/w2kex1L4dYT6p5Uks/39MKXXR1zvcrRxRO4xpKPb9h1VuF1AYdwxa/n/y8fhq8rqAKn5lx2H+zczwoYKKFkIu8lKkvAl3URAENykJd/W621OYbHe1blt/yECIMBtsRz/BEhwLj18Cbf9+Xfpx/qnW9KoF4/TpKWtRXrceb6PR15znbDPX4pfCfeA7rge98Wd5hUh3caaHRRZDYLZy0EptFhW79vgazAIc7Eqw8yx8FYEeOuMLDlwzFng7HAX0o0AAyVQVqAUiO/J5l5Ru1laRebLXxJ9lqfYV1Jpgk3+Vv+qv4JYn/2znlomZkd+CWop6rzewqbrMWlef9jUgTBDQ1XB3s6gypurZ9t9nM3MEXLPNFrFeNExwIP/NeWPajUXWmLq+Wvx6Oq9OpRcChUXJFUw/zldl1xxpieuF76Hv2lIuNvx1UB3BC/kSL1zEvxb4gm3yKaxU5McshncKqMhm1feOQsDF+XfOUg7o30lLKdBDI+Rwi/YdfH8JQhjcsrGC0yePdU/MkbB4AgcD9EK0Vkdgm8bMLSIeZOy+hYAHfpwAD4TU45rn/HeUl7tfvPC+VG3Nkb4Rd5g
 +QeCDcXX
 OKPkHwFoQ9LFlch9kS8E0Xe79Zfb2ZSRkhPAh92wLw6qMZJEebz5Geh5KJtdZ1adR3s8gOfDlxPoatjRfBHuc0NqvrKNDC1QB0PEoS9meiyDTfrBLndHqwLT4LIPmfVoERf/mf5KmjIZM+HIrMImZ31W2hrQQrl5mVZ4AqHRSW8jawXjaaUwvZ2vaetedS7CtRIMrKhUTHXtudWK3ux/V1YkrkHhbODcZX6XtsMAoVAHFrbzFcgoh6YqINSe8xSQF4UZp3Je6I3Sob3BHyiWSnIZfCEds0U629+eNIL2jSG//nudtcNXYYGyZWTh5fpB0sZzK+/d08QvWzKBrRbOXjI2yQ5FDLJhU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in zonefs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/zonefs/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index cf084c7905d4d43c0638187a55f3c9af71364f3d..9b646cb5335d0643bc0431aa8efc35a90fbcdac5 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -297,7 +297,7 @@ static void zonefs_handle_io_error(struct inode *inode, struct blk_zone *zone,
 	 */
 	if (isize != data_size)
 		zonefs_warn(sb,
-			    "inode %" PRIino "u: invalid size %lld (should be %lld)\n",
+			    "inode %llu: invalid size %lld (should be %lld)\n",
 			    inode->i_ino, isize, data_size);
 
 	/*
@@ -308,7 +308,7 @@ static void zonefs_handle_io_error(struct inode *inode, struct blk_zone *zone,
 	 */
 	if ((z->z_flags & ZONEFS_ZONE_OFFLINE) ||
 	    (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_ZOL)) {
-		zonefs_warn(sb, "inode %" PRIino "u: read/write access disabled\n",
+		zonefs_warn(sb, "inode %llu: read/write access disabled\n",
 			    inode->i_ino);
 		if (!(z->z_flags & ZONEFS_ZONE_OFFLINE))
 			z->z_flags |= ZONEFS_ZONE_OFFLINE;
@@ -316,7 +316,7 @@ static void zonefs_handle_io_error(struct inode *inode, struct blk_zone *zone,
 		data_size = 0;
 	} else if ((z->z_flags & ZONEFS_ZONE_READONLY) ||
 		   (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_ZRO)) {
-		zonefs_warn(sb, "inode %" PRIino "u: write access disabled\n",
+		zonefs_warn(sb, "inode %llu: write access disabled\n",
 			    inode->i_ino);
 		if (!(z->z_flags & ZONEFS_ZONE_READONLY))
 			z->z_flags |= ZONEFS_ZONE_READONLY;
@@ -402,7 +402,7 @@ void __zonefs_io_error(struct inode *inode, bool write)
 	memalloc_noio_restore(noio_flag);
 
 	if (ret != 1) {
-		zonefs_err(sb, "Get inode %" PRIino "u zone information failed %d\n",
+		zonefs_err(sb, "Get inode %llu zone information failed %d\n",
 			   inode->i_ino, ret);
 		zonefs_warn(sb, "remounting filesystem read-only\n");
 		sb->s_flags |= SB_RDONLY;

-- 
2.53.0


