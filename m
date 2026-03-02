Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1BB8EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667B36B00F5; Mon,  2 Mar 2026 15:38:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632796B00F7; Mon,  2 Mar 2026 15:38:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DD356B00F8; Mon,  2 Mar 2026 15:38:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC0B6B00F5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:38:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E28628B304
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:37:59 +0000 (UTC)
X-FDA: 84502284678.08.C33DFA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0B3C4180004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:37:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mNDFEFT9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LTqeeFUd61+lrO9l0nq6gMo2L9c6mS8OWVT22x6xoE=;
	b=HAv+Oc5PwZiqVEm18LbKcx08OYsr0WDtV/c79wbrQbHXTgBamsrIk5zVuj2bZNdKTUKuK6
	fTNIMEgGP2/PueOLqBD5Sw8h3w78d43rf3+0fc2opYr3a//nIa27ERQEgN059d/te40Z3Y
	c8m+ING68AJRaSv2ibzepiTHM53OjOM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483878; a=rsa-sha256;
	cv=none;
	b=wasNkywjwCz5VdG/r/u6WIpTdv9ko7K6SHrJY2pPVoDdouZRn3BFVXPG3lQBv7l0h/Qa59
	it6d0EcxXo8LkDhxpr+rmn8hyri9zt/hkf1xkM7qGHyQ1utlTC0CHDsA6xgInQFj902X/m
	KXZPTP4DQ1wvWrhcxdKkzAJEmmGnq5A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mNDFEFT9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BA7144124;
	Mon,  2 Mar 2026 20:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFCDC2BCB4;
	Mon,  2 Mar 2026 20:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483877;
	bh=Nz8fQjJTCJN20xaj4BH85hAY+rgkCX0BBS9mfGTzSMw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mNDFEFT9Z/GA77hYI3dIcJpOcgD1X3+xriGLYx4It3nVh+5wJhETA9zsYrLCw55xT
	 kcAI7P9k7qiKZIbXctSPb6gOMjsEujfypmySFrGyHGHPGyX9OkPgSNjFnvmBCzLPZa
	 U0SnaqmkK/SuZjVJ3t6TR6f/zW5uywWH0XFxKUrFOPs7deGy4MPrCVqNdO2EfAPEsh
	 4sDiX2tMjdVPc+VBqlCe/xvEYjd8A/gaMhWRqMUAUe4zV5w3cqnav0+yVRGW7t35UG
	 ZiHqzjyvzSTNnQfpcxW2ZzaAqI9w8j6+fWkEUK4/fzOjtv9i8M6gdTxz+8/+uQHY86
	 3BS18Qd/zH+9g==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:38 -0500
Subject: [PATCH v2 054/110] dma-buf: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-54-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=881; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Nz8fQjJTCJN20xaj4BH85hAY+rgkCX0BBS9mfGTzSMw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH9THKmmdBYv8h1UCKPbtsRiK2kKRoGLSlaX
 BQ0ntN/1siJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx/QAKCRAADmhBGVaC
 FeiRD/9N6tOHt1cCBgEmdLfEBdt8lU1jUCAy5oPHYeRypyGG1ydmbUXFCNxzhtN1rcdsScdHrMN
 0BsxD385/n8zHDga/rGkZRuNDTozgOH9uFiVQpkMPJEJ8B1HahUMgNb2feHKqFDT9Y+8+nwo0wn
 pGP3pu3QBnze6tJFc8rh9XJvVGjqXPtgwxasmVu6ieCIsz0lADGJ+bNVwFvuEjBOiY2YNrqiihx
 J40swD5TtpLeS69ocN7UJ0faXDOzXNbnkRVig2+OJouwRide/OFPtJskG0wgYVF7dWJlp8wSbkm
 2ei2dW9VBYks4ulvd4ROhqBkdMJ/rXGnLoBkUqBSja2/046XeKpvCusFzu+RQqqjwCgjH3cqgIb
 ejg0qq0hcHqs/Ak1HRx93Xd9JGGeObkx2P3Zz4ffi1o+aSJKtAJizX/S+N4AV0fWWC4qP46Djpm
 sOdkYRYmODtNMbnuZ/rCDqYfmQFUgSoE1NXx9pBeQvARwGwyQO+yAgU8yVsX5o6Pxgi/0IyWfHw
 l3iwvU+FiJMt34M0sBpKdT3FWLrYaJlIWPdfwV6D6uucudL0N4pTN+iEaP2c2PdtPhUH3yvPVV/
 vkNk/lfh/nIepKWIf3kJ4ECeUcJ+ZqAgDTRuTm8A9KM4Cq76mBb1xEvKRNdFrww0u9CAR8S1Svm
 QstaSnxdifYCv6g==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0B3C4180004
X-Stat-Signature: wa94smjnda8tc966qbxr44zong1m3if8
X-Rspam-User: 
X-HE-Tag: 1772483877-369138
X-HE-Meta: U2FsdGVkX18kvkdAVEjzNBV3SUqclw53Ut8iPntw351oDtOkt+esJqLBw4MMtaapeYE40UV5Vr5z78WaA3WFQJzAe7YSQMjU/8Bn3UWyMWARaNtKlczViAzsnvvJuPxHancNCj/oATdFMZ7vNJ6YyqRNn2QAFQ23VqAEaffGchGokDoxF02nJFTWijqlwj2lEmvN6VJkylUOi01EPwZGhMcv6J8l8szOrz0xuCXw76Zkvty8vfL45WmSc6bzTSloyzlvpaduJLNVEoQAwMmerJOuwNUbFRCw8TgmFDDmkcFQYlVNt3s2hmGneC3OPDI8RqoX1RbBySN+z3NEbMnUPnOtDKGk010/DPseVulMNpdik0JBX0dMKdwoixsVb6qgB2f2h7XLOJkgrxAi+EozXIASwaBEOtSxnereY1II1GXfyyy8/dcCQNwGgSdv9/E1PbXP/ZN1gdbZUHNVBZddmfHtNIBIGG9/dfVcRtjGJmBC+CgFWplHZM30x6BU35XgWtTHpxs58eoJQKVBW/kgp9hckShcg0VlFiyjdzgksLGWQnAARRhtK29jAxbvSdqyPBNjiNAvYb6EmMMhBumHJnChOIz/XerEOCLTceQa262VcrNmibxs5xTf8x5HJ6UHMTFaBdrjcKa8yhZ2mGepVEIJpG+Ac6Cjtrlu3+temu7D7PJsJ2BuewjEQJynef9QgCU7TeNuGgePAgf3ShmtRLXV/xAIlcf99ArzCaIx8QRh/zKfA4SOVHjk94s/gTxLaE6RBtkwwwCJ70WxwqASfX9vnsPb+b/hngFOwUBpVCb3dxJxq/dja5Co+TsxdDG3h9pgbOwlmDF/0b65rQnrsjlSaaVRo3sHgyxKK/jaMROKarhnjwMt2F0PwSGwqzB7po6+8vNNOQLSF5Ewb6wxHXbP1C8ogbZnU9VUkg3/uuD9Dx8yfFYUbBcApZVNKR7+QdpV4XG8XWnsJmJ4y3C
 S12oLJKG
 gjeZLAGLb6r/Qx/NyFkYb1WsywGVRB7LkzyCJjDnObbyESohWgBYd3gdFN42LffACxgB5Yd0ZpJQRz4hes32iuvDejEFi9H6cN48seyRBq4lz8SgOX9ENtnHJ4kSUkvSkLL+STdxrS3kARLQtFPNqUmRUUSkPKrd9kcOafql8X+cPSP1Kfgai/kkUTkcEqlWJY71bkmvVKDNOeDiN7JMl5CA9xUzqO/sXZm7ulz9ygEpLRYyOFEcKLinK+GZtHtRd5phWGvuAomLREiOnY+QY7jobxg4ErEOCeKC+6H4kQUDPbdKemNBPQg/P8/XZgk/b/dl/JUEEmy3uwpmi3nyXTn5//baDpN5aLRuqbMJeF/iJcZvSX4u3yevsLveWGzPxv1eWIfyTpkFd3CD9Q+NFluXafO2Fw0m0DyqaZM9gt9uCuZs+vh50rqwXzEShhCTQgHzGj6CAOpAemf1nzrnFLijXK+1BWU+fLGNjMLsrbfS++eBjsH2gSbYV00Cpg9J+Y+dpPYUchA1zdhWC3kCt/1j93caOdtF6QIUxy5R7CLCUQFSKGgNHHhOrkOPrE5EFe+sYKQuD2hL+GoMA5U99pLQGJycnZ/ByAQhHS0M1CX77ZUgvKJlMDSNpXbWvbAC/oZcIWkFua414dygAc6DnwJsuMB5YZR9TyA+v3B3Y1udjlQLQVslTffr7KbEnsrJIVRcNosamhQ7aDWm1YEx6r11tbFRLk7ZjJHLlP4wRFRRtuBqc2b2TiKZ/jlr5yM1GRUCjvb5bihuDr+x0yqq0HNYC3YUOuOw6o18jkZaDhdjei1/0hSsAytiEwb1QtPOTi2y9NfXf2IPv/kZltbEyFp3KAnJEhIfmC8uccwyGD/i//P7ikpAzHEeDHGHCo4vxWIF3Yv3YZE8gChIStLp6bTyqBqFYzO4lHQyPJlTp6WdT7z2fIeDC+29jaEbPixscCpjUoDSDEdiEPHiDukLoiX1KyYbg
 Rjavw2Ak
 xkhq2HzF274+ouBGO9SIkE/PHS+efqoSl2k8lX+SOLgF9mP87AotFAGD1InSmqlzXMRTFHqX3DOnjgTf0vrfW1jTu1+ZqK40OWATgcoOcGqBsA5m+4hmwmHnP7vTbMXrED0h5Rq04R6jFdsjbvvFm/gExjqmMYSY5gIHe2X4rtgeELUNI4IjEZiTz57ldwTXACdIQEZbFzyPutiAqD9MvluFBtwkVBCU8nQ7epFi7w+dKFGMDQZGCUebaUAE5fLW4Jfukn7jHVJWUBOZrO5TBcWSWykbv7Z2o1qDnuF6CCW/v1xJzJK9JEPf3k1u23mpzYkxD+tQxV7UOe4pf871Q4ZcDIa4x3Ja44yN9J9klsHwYKjPZYe3qf2IG/fCEvlNwgHuBERm26eWs1SaZ+CBA86hmiDYSByvlc2+uALhTVTKiEmZ8DlYc16XsUEE3ZqJBhRF7uoFT2PkQRzg1CfDJqO0pmvZp1pa7rxwaMDi+0BkfG+xUjqOpMxZYLN8jW62RY8AtHnRkyiapQOh5SXJdSuC/h1YUx7KAgGgr9o9jDxaUr7qLdyJGNMATZxNuO5wbLXMVxeA87vY2eEJbLbS5NLtpgzCz1VAnj+WYL+Iz4TwxWT5YjFejt5GhSZv9GG2P2j45nm3KP6vAl78+UMiqIfzxhgK8NH98oz0SkhuDYadK+o57SLSVTi6wdbiENWPdXoPBqu6wmsAYvYnV+SxyC5uwdEal5no8n3cn4QFS4pZDXfEWjH59/hpo/QbzRkzcGVJoOZNIQNYIn79VOt+vcrPxEgRsymdZGnd7H/dzkFr08vFhDlTdCTg8egR/oZApWapDPZ3XiAFMyElbBh3WBt6gJAtganH/y9OxzOo87vCSYEuh0fAfJIDt9uHG9iUEbfBB1i8UKl8QjvQRQCqsDOYgEJs8TMvt231rnoOs3U0UxRZulMuEOnEIF9j+BlRYMdiVp7q27wiN6AyrOhYKTg/ZecJw
 4/85XeGD
 KjY6oLRa8bsyHVnwwYdNIoJLOFgtMdi8CoCKvKHilt16mkFMw4BctfxPUQ7sMoV/v10RDv9fiRNZsQX6lLcS7YwD63R20UNfLKmceyOT7CjaVMt0nrsQewxY7ct0OQ5SntMDyUoidzvS27vXJQ5ELKgQn3EXagvGxBcjrzdB5eVaReSteSD3hSAZaUbZY1BCLZnzIVcutMbGMnYgwl//kKqW+SrWnlrLEoP1p/0enYGTTEEm3pS2MYH1tZqR2s+DUSd48dJRIeqaoR9WOJ3F7M8YMDdNSGHcHPIr9VddW7jFDj1fVxLZsxSM9kj9jk1pJHUuz2EEinc031tKLMDDi3ZblZj1wDkh6p7N8c096dyzmBBacGMWA3NVCpC+f3JP4fY69NS5vOY0AoE8K05yxAHmFgjqD390Z0fzwDXcVjLVbiRpgPL3Z5iczxqh85gM2EdAp5lMMb4glgCwFJqnb8Zlb1e4ns0LoAfQVMgAJ/OiniCvQ5E9eQuCkMG8y9d/PvduxbT3k3ehoe6spSFxdXGNJ/2+an7YbtwOc3AwqkME+609m+WmqXKgMtmX/DgSSai77W6gmVLYXUoTgsl6Cc0ukgVreZ0bh7EyqQdozmWEycBdR+uosRNwjWvYqGlWuL7HMuXGFUVACrBsqyBMRO/pxATLnSHBHypT49RuXKNm7iSOLic7oO7Ov5h5cCsSgKMlTmelN+F6MBKXhIlz94GaoMBBb5dNBI54xOIEC3/Z2EmvNm1UON0Cii/k5hXAJhkWlrOlod/HiPa0N1GGLnvhvbGN9aJx4cKvKqRJ7l4qtzHigSMvLGXgIsDXGILmx0E2o0o58A7t4pvKDOsUcUcdUVstpYoE9i5otOo1H6JD3JoDocei6xn6ryHqt0YRfNVPZ1yLD74b3ne/gzFTxPc3HnyhJ3k7pHjDO03NbxSnSVXlil9tHbU2jTLu3G6kkPil6f8U7VMkA93Rd9hvdL4ipoe9M
 niQJ1h6K
 pFw98aoDDDA31z/rV1Qwf/46Atf7TEPWdn5bwDFLKItET/yliqeM1/0vO6RJqPIKn4zYEPcHJWaI5dzy4CN9k415Eg31t82n+X4v7d/HoHQ8iOcx84gkFWGmIYGfW9VZvsXwrzDfYj5BN9xh1z0/IO7lwsX9Wq1BhN2ja3ZvwTYd17C1khpDPVj7TY7SEsPHC6dQubeDaSzVLauCc9vukBK1Sx61uMYhn/jakDw1lIyULILXPw/873dzk7SpSrT8OZr9Vp/zEZ6R/QB7SqcVN0QCCIjTviy1wVbtQAlAdGxyP7H2Cx1BlNhCaK42KsMt0J+yIx3Lg7zpSC21ZzZvZUYOAb3w2ZYUHwMBR2UMWCzJPrJ1JfayA43SV2naPyFvSJWU6Eovi/Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert dma-buf i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/dma-buf/dma-buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 11711874a325b954940fb289f09936de0152e683..46ae9c77e6045a7cac7c318c3afe41daf88c8dee 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1708,7 +1708,7 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 
 
 		spin_lock(&buf_obj->name_lock);
-		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\t%08lu\t%s\n",
+		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\t%08" PRIino "u\t%s\n",
 				buf_obj->size,
 				buf_obj->file->f_flags, buf_obj->file->f_mode,
 				file_count(buf_obj->file),

-- 
2.53.0


