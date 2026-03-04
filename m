Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DC4CEDEC12
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 06:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2FED6B0088; Wed,  4 Mar 2026 01:27:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDE56B0089; Wed,  4 Mar 2026 01:27:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DAA6B008A; Wed,  4 Mar 2026 01:27:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8C36B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:27:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E2BDB9803
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:27:59 +0000 (UTC)
X-FDA: 84507400278.21.2EE807D
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf26.hostedemail.com (Postfix) with ESMTP id D10BA140009
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:27:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=QGqGuB1H;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="o yBs4Ci";
	spf=pass (imf26.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772605677;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+RTgashw6751XVNDWQdZH+Q/6MhJxiaQle0ycbNIPA=;
	b=EcOCD74Nth4nxQDDpdX8y1noNDBeiExWpljkVH2Fva5SGmFVxsWFUkYlyYkfofJnrmbi9g
	IGFJjbMvK/BZc1u49O3WOggqhfE6ufrLPKwu1Gi5JklmaS5oIOyGtgWaM3uF7BDYTGWxUf
	YgkZgiFK4gEjQHQlSvEaIk56qrX4l2g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=QGqGuB1H;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="o yBs4Ci";
	spf=pass (imf26.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772605677; a=rsa-sha256;
	cv=none;
	b=MhW2UJuqpCj25dkrf7a1vIOBsCRfi58rPEqB1XJjPu4UJd5KAM8hHoKX4jJ0Lz0VnDRDUQ
	/MiHrU/GuVm6UNBxn3VwkNLqCEDcUicI2eJDm/liGkzeWyl1h8ci+iPgRDTiyCj8jb7S6x
	7+EEhm2zE5NitaQayc/8pd2fTb7TW80=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id C99AF1380E87;
	Wed,  4 Mar 2026 01:27:55 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 04 Mar 2026 01:27:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1772605675; x=1772612875; bh=5+RTgashw6751XVNDWQdZH+Q/6MhJxiaQle
	0ycbNIPA=; b=QGqGuB1HfRnACei6sx6c+uNgMwLaYwouTEpFj2VP0mlDfEqPtRY
	hq1PRy4CBOv70+oVSYpqqZpM0oM/LMhJunekgV3eBzmsgcDG0OI2C4tzloWCpVvl
	4i3VE4LhXttp25s0ZK9pW3oyxGl321uWgHvjWqgL414piiUtcU8j/RBBg3lpxTfz
	hyOETJnm1GZ3Vny7khF6LstdjtjpNA05Sn0+69teOfVwM8bTgFFfpYoCWjZ2d4gj
	zJQVyFRZl/QUmgQAY8aclFxSMlCDdqzk+ns1JfsxU4GqHtILyAxxV1rlJifkZ7nV
	XCXCXCRkAeoUwFwEPnGvyan/ZZjUaQt5PAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772605675; x=
	1772612875; bh=5+RTgashw6751XVNDWQdZH+Q/6MhJxiaQle0ycbNIPA=; b=o
	yBs4Cidn0fowkiQNkfBBbpvMteFnmb6KK9N9BnOLF7DAXMw7rLEfq8O8XkeXs0++
	AItJEKwgOy6+J2k0jKmt5y/gjZkZygq6/z20y552PqK0SvgaS8EPmsW6WcRrV1pP
	Cka6lApHFX3ajwbAqxHOCPa0WJuwpyjOxVf4rBBc72uzD/6CW2235GcM//0i19W8
	7L5pQzsL0OaBqS4U5vUHJiQNiyzDfXHteA0Tj9OpC2tpQ91dxDiKNGlVpY+sXR+u
	F/1B+M7f+72ADS4w6cTGLYwsrCBQ9Ty53UNfXLWsSJmwJfMdphzrO6855O9pzOSm
	tL559XeFSYE02Ng/iW/iA==
X-ME-Sender: <xms:4tCnaSNbDrQ_gxgn-FDSHw2lZNLRjN-bQWFxNuyRrlsjf6GtgESQmg>
    <xme:4tCnacDbxasyEcYHsybPZFFbKL0qOs4hHCyDZ8PnwLz-6RsB4wLBwEgkGnXcsPOlZ
    vDBEl8eoy7hp-6BzaC204ogbJpjXhIDJYl7RZzbFer_2uIshg>
X-ME-Received: <xmr:4tCnaYoX3ksWGbwPjYXqqxsqc0TduUwk20wMvX7c0reLYwrKoLdGz80eJTir0A1PtkE58RYexQ3nSkgmperFT043a9PjJpOJNYr5279CEe3n>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddviedvjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtjeertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epudetfefhudevhedvfeeufedvffekveekgfdtfefggfekheejgefhteeihffggfelnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohepudejuddpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtohepvhhirhhoseiivghnihhvrdhlihhnuhigrdhorhhgrdhukh
    dprhgtphhtthhopehjrhgvuhhtvghrseihrghinhgrrdguvgdprhgtphhtthhopehnrgho
    hhhirhhordgrohhtrgesfigutgdrtghomhdprhgtphhtthhopehfrhgrnhhkrdhlihesvh
    hivhhordgtohhmpdhrtghpthhtohepshgvlhhinhhugiesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheplhhinhhugidqgidvheesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehlihhnuhigqdhunhhiohhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:4tCnaVnhO8CafOSbZVc9pJUxfys9OoZeY1Z5ndlwHjH7CSajOCGlDw>
    <xmx:4tCnafRh4kpYARpWLK-yCUUMUT7nS6ebAyXQDsGD0JLDF2Tv3K7JJQ>
    <xmx:4tCnac5DU4GRJRJMC10qjpWx3MESrDXeWNEaJqiwQejNUX5p7MDMMw>
    <xmx:4tCnaZg3__L3okNus_55Ab1m3xjLlY3uKakknX-vQwxPKM6XDQv_Ng>
    <xmx:69CnafTUulKHVEiWHbvsFlAmyCSQisz6ZPFKNRFf-ai8k8007x9TdQYK>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 01:27:03 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Jeff Layton" <jlayton@kernel.org>
Cc: "David Howells" <dhowells@redhat.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Dan Williams" <dan.j.williams@intel.com>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Eric Biggers" <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 "Muchun Song" <muchun.song@linux.dev>,
 "Oscar Salvador" <osalvador@suse.de>,
 "David Hildenbrand" <david@kernel.org>,
 "Paulo Alcantara" <pc@manguebit.org>,
 "Andreas Dilger" <adilger.kernel@dilger.ca>, "Jan Kara" <jack@suse.com>,
 "Jaegeuk Kim" <jaegeuk@kernel.org>, "Chao Yu" <chao@kernel.org>,
 "Trond Myklebust" <trondmy@kernel.org>,
 "Anna Schumaker" <anna@kernel.org>,
 "Chuck Lever" <chuck.lever@oracle.com>,
 "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>,
 "Steve French" <sfrench@samba.org>,
 "Ronnie Sahlberg" <ronniesahlberg@gmail.com>,
 "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>,
 "Alexander Aring" <alex.aring@gmail.com>,
 "Ryusuke Konishi" <konishi.ryusuke@gmail.com>,
 "Viacheslav Dubeyko" <slava@dubeyko.com>,
 "Eric Van Hensbergen" <ericvh@kernel.org>,
 "Latchesar Ionkov" <lucho@ionkov.net>,
 "Dominique Martinet" <asmadeus@codewreck.org>,
 "Christian Schoenebeck" <linux_oss@crudebyte.com>,
 "David Sterba" <dsterba@suse.com>,
 "Marc Dionne" <marc.dionne@auristor.com>, "Ian Kent" <raven@themaw.net>,
 "Luis de Bethencourt" <luisbg@kernel.org>,
 "Salah Triki" <salah.triki@gmail.com>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 "Ilya Dryomov" <idryomov@gmail.com>,
 "Alex Markuze" <amarkuze@redhat.com>, "Jan Harkes" <jaharkes@cs.cmu.edu>,
 coda@cs.cmu.edu, "Nicolas Pitre" <nico@fluxnic.net>,
 "Tyler Hicks" <code@tyhicks.com>, "Amir Goldstein" <amir73il@gmail.com>,
 "Christoph Hellwig" <hch@infradead.org>,
 "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>,
 "Yangtao Li" <frank.li@vivo.com>,
 "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>,
 "David Woodhouse" <dwmw2@infradead.org>,
 "Richard Weinberger" <richard@nod.at>,
 "Dave Kleikamp" <shaggy@kernel.org>,
 "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>,
 "Mark Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>,
 "Joseph Qi" <joseph.qi@linux.alibaba.com>,
 "Mike Marshall" <hubcap@omnibond.com>,
 "Martin Brandenburg" <martin@omnibond.com>,
 "Miklos Szeredi" <miklos@szeredi.hu>, "Anders Larsen" <al@alarsen.net>,
 "Zhihao Cheng" <chengzhihao1@huawei.com>,
 "Damien Le Moal" <dlemoal@kernel.org>,
 "Naohiro Aota" <naohiro.aota@wdc.com>,
 "Johannes Thumshirn" <jth@kernel.org>,
 "John Johansen" <john.johansen@canonical.com>,
 "Paul Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, "Mimi Zohar" <zohar@linux.ibm.com>,
 "Roberto Sassu" <roberto.sassu@huawei.com>,
 "Dmitry Kasatkin" <dmitry.kasatkin@gmail.com>,
 "Eric Snowberg" <eric.snowberg@oracle.com>, "Fan Wu" <wufan@kernel.org>,
 "Stephen Smalley" <stephen.smalley.work@gmail.com>,
 "Ondrej Mosnacek" <omosnace@redhat.com>,
 "Casey Schaufler" <casey@schaufler-ca.com>,
 "Alex Deucher" <alexander.deucher@amd.com>,
 Christian =?utf-8?q?K=C3=B6nig?= <christian.koenig@amd.com>,
 "David Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>,
 "Sumit Semwal" <sumit.semwal@linaro.org>,
 "Eric Dumazet" <edumazet@google.com>,
 "Kuniyuki Iwashima" <kuniyu@google.com>,
 "Paolo Abeni" <pabeni@redhat.com>,
 "Willem de Bruijn" <willemb@google.com>,
 "David S. Miller" <davem@davemloft.net>,
 "Jakub Kicinski" <kuba@kernel.org>, "Simon Horman" <horms@kernel.org>,
 "Oleg Nesterov" <oleg@redhat.com>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Ingo Molnar" <mingo@redhat.com>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Namhyung Kim" <namhyung@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>,
 "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
 "Jiri Olsa" <jolsa@kernel.org>, "Ian Rogers" <irogers@google.com>,
 "Adrian Hunter" <adrian.hunter@intel.com>,
 "James Clark" <james.clark@linaro.org>,
 "Darrick J. Wong" <djwong@kernel.org>, "Martin Schiller" <ms@dev.tdt.de>,
 "Eric Paris" <eparis@redhat.com>, "Joerg Reuter" <jreuter@yaina.de>,
 "Marcel Holtmann" <marcel@holtmann.org>,
 "Johan Hedberg" <johan.hedberg@gmail.com>,
 "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
 "Oliver Hartkopp" <socketcan@hartkopp.net>,
 "Marc Kleine-Budde" <mkl@pengutronix.de>,
 "David Ahern" <dsahern@kernel.org>,
 "Neal Cardwell" <ncardwell@google.com>,
 "Steffen Klassert" <steffen.klassert@secunet.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Remi Denis-Courmont" <courmisch@gmail.com>,
 "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>,
 "Xin Long" <lucien.xin@gmail.com>,
 "Magnus Karlsson" <magnus.karlsson@intel.com>,
 "Maciej Fijalkowski" <maciej.fijalkowski@intel.com>,
 "Stanislav Fomichev" <sdf@fomichev.me>,
 "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "Jesper Dangaard Brouer" <hawk@kernel.org>,
 "John Fastabend" <john.fastabend@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
 v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
 autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
 codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
 linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
 ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-hams@vger.kernel.org, linux-x25@vger.kernel.org,
 audit@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-can@vger.kernel.org, linux-sctp@vger.kernel.org,
 bpf@vger.kernel.org
Subject:
 Re: [PATCH v2 000/110] vfs: change inode->i_ino from unsigned long to u64
In-reply-to: <1c28e34c7167acf4e20c3e201476504135aa44e8.camel@kernel.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>,
 <1787281.1772535332@warthog.procyon.org.uk>,
 <1c28e34c7167acf4e20c3e201476504135aa44e8.camel@kernel.org>
Date: Wed, 04 Mar 2026 17:26:59 +1100
Message-id: <177260561903.7472.14075475865748618717@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D10BA140009
X-Stat-Signature: uf9kyiqxgknw9kquxhc7h6ckhhk4rg3t
X-Rspam-User: 
X-HE-Tag: 1772605676-632336
X-HE-Meta: U2FsdGVkX1/kMcn40p7ESqZgyqJgRngM2YAjs1wu4CRETrX6IrCNdKgEeh0jmVteR7Y0jY6nZDswV1kk8t+Wym2o5pAflhOU1h2ZrvmE+F626TW4jQf3a3lZnFNOwX3qE18EcyEP/RVSkGjZV45PcJcOal8DUykZnXSoXshyjGf4heJCmNJ33Q/Hob7rk7pV6HTrM6mpwSkBuG4ZXok4gMgDqa4h2BktAbBTS9S72LOYqfM/95zwhMGRqjhncSigKXUPvJEnavzoeyRjahpORbv4VRSbBOdWIPWhPQMLDZriNqmpGhwLji0voW6Pah+FmETVNRNAQoFD50ZgmpXaVaP1hrZ26nh4yt3lT9TZKqnN9Y0czX3BZ0zLlqNny/umjdVsJgz1Y2u2hiWLiUeoRcdb634risfVEZCSA+zCg5F0yla0izWxkAczWkyE8rLh6Q5iJ0g+ibhFPMB0kI6Hpp38l8Lhi32gB3RGyoJ4CpVQmeA2ZMN4bo235eyg4VQTMevFVoLRR76eejePSmabQkuCMDwFVf6gGGf+fTcoh0PCjKtSAq0dYT2hvv/cJ6CVtx1tf1enmfQqU8+zx4fvlzn9pOZlrKkCcJaPZVIyp1aPSoA16i3xu0a/zbaQ6AyzFrRij+p6B6Qn5+ZqhkBm21ibtFEu1rZUsppGfNF8Ioz89veJCJc723cEkCrbxQjP+3dBq4xvjaQMobE3IplfIlpTM2GI8yBrk0LeURPpWufEEgOZpIX76Yn5s8UCwYagdX7R4965UafscKJqef8bmJgCV1CMUC+AHGy0dHojxy5q2gRk0SHCTdFPyjyhXhJA9EJLAfrXVO0ofnBSrQItNFBSL8k5jzTrdU0mz979pTDd1uYbdHPgaURFi+/gvzheRmZ1lyQC3vjT2cYtx2axHpQxgt3EQKKLl32yGEx7455//Bz5ukJuw9gy3u8FJVv3v2Niw1fbKE+3T9SnSEg
 IcpZHVHz
 GF5LO2Zg351liwk34PsqrDrQp5vRagpABkCS34c5SwNSbyfedwIzcLM5uDQAhEGZzT/ay2J+OkxgwZJOV669zZAZCinVhQiYp4rjhTCe1MaEuQ/+B74qrXlvjbMwVADN7OjJJIQROMy3Tr0UYdznPHVArjCon3ZkxHi1Y6i7zYeBT9NXsezLi1KkQOAs0D7y0CXwMjwrVoEpJEAGpbe7CDfeDaBvybbqnywNQTKI5VR3lvCW9gACeXXd4BoiyN9ARIgesI5/+baaHozzyYLHZQf8awMxvaEYaUJYpgI1DQOuvdjuLL0+o28TR08uUNPZ5SvhDO7zYqQO/Q+80rHAQbxlF6qtPfC36VoRgR5VXPMabASQo4gtp2tEdiOw+D8+UUGqYUYubeJSbsRyltUTqSQ3vJKui7q16NR1hVo56X/x5UPwvA1NT5q1VcilK/RS+Y2yVLsAo6L9W+5l5YVAUsGlX0Iu8NWBoxpxprOFU7j/FCrVhPq1L/QOuqHZ+/hZJLgLx6tgpf5GkDTCqaUe5D4GiHwEXIG3qpw9NQNEGG3rirVeQucaFSyWuMql6ytiSICUxJmp+45upulEiQQMSCOncMiBP3CG0RSp2EPIBNu9Z8Ezag9CmeFdAF4+qUynilPyJu8CtA9ZNR+teIc5kSITk/k5eRC75WqlmHjainoHeczvymckQJ0gV1O+H33b9UjyHhdmOBV2XF82WYklncl+jt4xPj5tEwX6ctSidfIVeRvOU4/djecLPXQaq/+qsWJYeF/fLaPnPj8e+oi7I471FlnECPOrWHuLcEdlzIjPRRne+i7ibXc2+E1/W3Xzq43JqOYrsh0e5JqLuVCdA5IkUMk2cPaUUmFwPxo2aPBPGHKqHRVesWi8RnZCTRZEKlLwsneAwjlLpSXdZqD/Eaz9sO0rE8KJjLFrDcjhbEGhOKNWG0IhYpZlu+UxIZCfJFWG5po4rbYErfGX2X9rR5RUuBwUX
 x5zchIaZ
 lcaqAIMpShC1V7X3eQ+EzzqL778gW+bpPaSdwtphaJD+s1ZkmWxYdlTNkMTmI+yJif1O6ROBBDQE9krKASSS02LXOKaopa+BCJd5scCaThZpAHRwjMRa1212cEH9X7fzmEIrBrwG0emEYwX2ELKCFAuoxBRp1+ERIF65+w+nw7p8bIZ0e9LFXqROekN+eUh281xpV7fVyeFc33tAZdfW1ZXg2U4APIG76vSzz1tbe76SEIg3xa94KYg4engQMacWlKT/aAy7m3Uhq/nOTQcFynAQrB2445wg9IkwsHZklQd5himKLNP1C7UwXhr2H/NVIBt181kGYMJ2Hn2BvGxStselss6auYiKmdi2w17XTca0ovFziHbJ7alPxq1wSuV87e8TOtjjbvzosWsdAaKNy9s50RXrLCxLVi6lMliCYbeio6MbOYSe3hSQbi3iIy1sPoLng+jRCBNjFeV2vjw6fRgwgmnnGzQa+vFQHnakUG8+2daJey/al3IqasMJKmuS+g2IZSGoJxlmJnqcU6nIAdCa4ROrGdDRewkV4Gz1FJdE2OK70yHm+Wxht0vCUcR0xqXBMutlE9IFcafgOzL6TbQeLhMyZbhC1TBMDRCwadour5sQQ39fdjlZ0726XLcbd3M5BsIQPywfGNG2kc5n7A9Hy1wKrdqsdV31H0jhyyD8EGVEoF0lJsqRyxcNwUI3JG2ZKIceX5z5Muy0fjrQ9kh18VCIvrkASjUu3KAl9kxrNoJKjuawY8hMFHL8/gVU8zR6rNOZeeSwa00NGbpC8c1snRPlqB3oSXBPl1aFgFL3AYJ8wDj77oF9s35gA3236n+N0ESuD4yfgbipKMo37KeO8hq/JOb0wlq052igv//jUGXQgKOXRTBnSOUFefIhG47SGo+9D7tXxg8Gr64O77hOMXSt285rBFqU5y+lT9LFiuVtzWnX5OfSztu+wNxNbozeMbqgioEj2xvi1NunW9oxlhsMO
 N0b0drBf
 F6eWsLC3fWY2nwOIlt8M/lbUP2GG/lAh8iKZgemm3opfT8d0rnTRc5+/+OP3PFy4Duuzfwz7UrbY+Oyb7vOOhv1FwEeUk9sGDw8/aC8iMInt4iAUwR3HCP6Pvq+Qtm+4N0G4u/wWa8VGDq8D6EJxUq5Yzq8Uv7jB08jn1zMvaAY/LKZQ0gMdR0LU11H7KEjWEtf/ZyjGyeUQHv67HC99Voaj9gw/z1n5TdRwNGgWCcH3avAMfb2Li7/WrvgWXP7LxmlumLWztTwN3BOUEvAd5J2a2AIp626yeycfpilOhSUJZxGeSgCvNkuIgm4Sbbzt88EWa7skRMRDnQ8usWHljACB2fXjrwznfrCSsArNCec8tuYF+tZ8k7AhAK8gWYOf2qGTSQIXne3ESPhicDX1xqyoxfjnYERq3XuyZjwvohbwAs4Qnj7BsNL+/P0mcg3wsy0V3w3d3aGahkFtvE5lJg96Yw8tUgQYF+WvrAUaYyBtV2O/l4z3Pnq9kezYyi1dDkNUuUf2FLNCmrQSFUVM6z0RQpbHf6vCynVshMVpvHexuHdVarhKpw7+MdtU2hPATjYwHhokg+TVE9doTcKX0YXrDoIErJj0Q55UTOwBch7GNXRFRG3pQWWvO4r0X5PxLlCcvixVQdmvOuhWAiFl/ercDZ/ipMJ19Xvivnallu/ShdlvA82b1x5vpOpg72VsKu2iXC1P5qOc5k0V+OQheAQnfFRsMGnH83t0RR0u1Q4DxR9QxCNs+dskKvLvUvIFlb5oELujb10moR2bppC71nawN00sL2lZpl2bHt/JLS1FN+OgcWtjG7Vvfalw/yC+mHN2FInuR+0nwJh8/fB9FL6cDSwrLzlNplmD5lwhRpxI8tU8+In+VitTizWmaKndC9mJfU1jxKNyDTXl2En4gtsI7t+gAyFm6Re41Vjd20PHPlpOjIHyHyIXQ1vTn4Yt+coDds2Wl+Uy/h4p3DVhWKy9vxB9w
 x9Mnl6GJ
 wc2HSJzaHa4CwXVBXKcvMeEz1FSTlYkxVaXYaHtrMpNna2josWJ4UBVQUDza9RvMHBvILuS2WlzKtBNVv6gNWBN7EeYR9UCvltFs3yvGr6qz4qPVAuJkjn+t4PgbmbH7+hNq5LFSiajHwurKZ5aHpkY3JEpAZb1pdMVJ2WIyttiQr8bkrj+bSsH6h8eciZ8Zh6j4nVZdzD16ZKJSgGfI+20v8AE4v8qzsZKPGGS8tPDuun0gtR44jK+ftpaLvGil1xBiZl37PI79ceWxS75i7XJgdZ5hyZgarW4VC967u1f3iv1qvac8KAbvs6OwE0D1TIS8johqQ5LZn2/BhrsJqaXFJAU+GMii6pi4sAVbNFmkBkM95eK9fcbg10Wqn7UzYkMjKkmcm5YS6EJiZcNxK3tT7BIPdAuVRDB8wMn5gkHSVKxqbYCNHiCw335e++09ikh7TkdLiRLCqTtiEsd7JKfItycaIS+QPoYt5kjiEKeHvWAKoM63cFzIhpbvvZYMEuu3+UepeSd+4wS+w7JvTabsX150ERJi6ACpoObIAjcd14CfGZHb8mCVeSU2Rx2WHITLblRB/ioMZCEjnDzjNc6iqFyehqWhYWcf3byn8i6hADzNONJOdYFw40vlVc9ZyC0UhGUSSfB94zYA7WVpadvtVnIDV7NpR/cUbNwzJv4Njhk+RYczLUgHlaOwTTURu3sf//HlNViokGmt+eUIYQNNY9kwm8ftmcT22IzxhqUNWaFlEcj5XfgVggABmC3LVj8LfXqLhGNk5I0ZUUYZU6o23/1SrYpq7rPZg2YABryAwTUe+EaD7WVWj0paBQNL4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 03 Mar 2026, Jeff Layton wrote:
> On Tue, 2026-03-03 at 10:55 +0000, David Howells wrote:
> > Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > > This version splits the change up to be more bisectable. It first adds a
> > > new kino_t typedef and a new "PRIino" macro to hold the width specifier
> > > for format strings. The conversion is done, and then everything is
> > > changed to remove the new macro and typedef.
> > 
> > Why remove the typedef?  It might be better to keep it.
> > 
> 
> Why? After this change, internel kernel inodes will be u64's -- full
> stop. I don't see what the macro or typedef will buy us at that point.

Implicit documentation?
ktime_t is (now) always s64, but we still keep the typedef;

It would be cool if we could teach vsprintf to understand some new
specifier to mean "kinode_t" or "ktime_t" etc.  But that would trigger
gcc warnings.

NeilBrown

