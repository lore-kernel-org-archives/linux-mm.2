Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF8DFD8FE1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9246B0175; Thu, 26 Feb 2026 12:02:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A566B0178; Thu, 26 Feb 2026 12:02:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724F56B0179; Thu, 26 Feb 2026 12:02:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5ABB16B0175
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:02:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 144FDC18FE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:02:01 +0000 (UTC)
X-FDA: 84487225242.22.8AE95A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1DD731C0003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:01:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rVUHwL4n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772125319; a=rsa-sha256;
	cv=none;
	b=YEbS436rJYNmpwC+48xgUikwg7gV1Mn4GeHaBYXvNqarRoOVgdW5THF587CRn/urdogvji
	KJkULt9jeMjc2El5wufASi3dg2HagHTbCTeFF3kwMumTK36ECAcBZfQm+zvORXK/3HeYRG
	qG1jAYWyUMbVMki+Zwe9oF9xAiYYhCQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rVUHwL4n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772125319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VPx/r14wbvdoX8ApWQmOZgE1QMNZagzrHnDmgiHaChM=;
	b=vmF3w+yELUF/jslJthhP2Xu53VNYQyHt0C2kTUCje/JNxBIIUhsaYjdpfEmYWGtlot2Tpj
	xmt6uusM2Z1P4aJZIWgcOqYHk5ZjEFAfRCu5TwEK2i1RPWYMBcL+4L4I+iPZ1D8/uztTiC
	OVB3psAIfD6xj+YYdSxAW73Xy/HUtxQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA13240534;
	Thu, 26 Feb 2026 17:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276F7C19424;
	Thu, 26 Feb 2026 17:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772125317;
	bh=/QmItQ6z1ymV5XtAi2g/Dw5o5IqkDFW1zO5h6zottN4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=rVUHwL4neSjulGzFN8BMg9pKoDHwp+Xwjt8pk4Dq976Yi206M6fYhg3+WieL+MRW4
	 gvEYeLd4d0OrxGKSyMS7lmJtR19iZofD0P+t90t6LNfHeq6XzW6OQASj4UUhHO5fCd
	 Jt8xHWi5aSMJPSiNEI9iRQh8NC5Dch7xrdXuGdJKTx0aJjs5j6cKM9Gkvh3cIFtK2O
	 sFUZj/AjXkRLJQmkUXZbGx0heTelso0a9SoyRim4Ku5V4qzU2utzORGAmy3wFg6DDs
	 Ch7D5AWOMdEKvdHUcpKrRe2Jd7F1IAFx5wgWR1LreDYTyyqYBb0eiRGxIh6ia26Q45
	 Bviw8G4tAPjkA==
Message-ID: <5826915dea6b149707f68847f0f3330a25615eae.camel@kernel.org>
Subject: Re: [PATCH 00/61] vfs: change inode->i_ino from unsigned long to u64
From: Jeff Layton <jlayton@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner	
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt	
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams
 <dan.j.williams@intel.com>, Eric Biggers	 <ebiggers@kernel.org>, "Theodore
 Y. Ts'o" <tytso@mit.edu>, Muchun Song	 <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand	 <david@kernel.org>, David
 Howells <dhowells@redhat.com>, Paulo Alcantara	 <pc@manguebit.org>, Andreas
 Dilger <adilger.kernel@dilger.ca>, Jan Kara	 <jack@suse.com>, Jaegeuk Kim
 <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,  Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
 <chuck.lever@oracle.com>,  NeilBrown <neil@brown.name>, Olga Kornievskaia
 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,  Tom Talpey
 <tom@talpey.com>, Steve French <sfrench@samba.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>,  Shyam Prasad N <sprasad@microsoft.com>,
 Bharath SM <bharathsm@microsoft.com>, Alexander Aring	
 <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko	 <slava@dubeyko.com>, Eric Van Hensbergen
 <ericvh@kernel.org>, Latchesar Ionkov	 <lucho@ionkov.net>, Dominique
 Martinet <asmadeus@codewreck.org>, Christian Schoenebeck
 <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, Marc Dionne	
 <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, Luis de
 Bethencourt	 <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>,
 "Tigran A. Aivazian"	 <aivazian.tigran@gmail.com>, Ilya Dryomov
 <idryomov@gmail.com>, Alex Markuze	 <amarkuze@redhat.com>, Jan Harkes
 <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,  Nicolas Pitre <nico@fluxnic.net>,
 Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
 Christoph Hellwig	 <hch@infradead.org>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>,  Yangtao Li <frank.li@vivo.com>, Mikulas
 Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse	
 <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp	
 <shaggy@kernel.org>, Konstantin Komarov	
 <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mike Marshall	 <hubcap@omnibond.com>, Martin Brandenburg
 <martin@omnibond.com>, Miklos Szeredi	 <miklos@szeredi.hu>, Anders Larsen
 <al@alarsen.net>, Zhihao Cheng	 <chengzhihao1@huawei.com>, Damien Le Moal
 <dlemoal@kernel.org>, Naohiro Aota	 <naohiro.aota@wdc.com>, Johannes
 Thumshirn <jth@kernel.org>, John Johansen	 <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>, James Morris	 <jmorris@namei.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, Mimi Zohar	 <zohar@linux.ibm.com>, Roberto
 Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin
 <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, Fan
 Wu	 <wufan@kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, Casey Schaufler
 <casey@schaufler-ca.com>, Alex Deucher	 <alexander.deucher@amd.com>,
 Christian =?ISO-8859-1?Q?K=F6nig?=	 <christian.koenig@amd.com>, David
 Airlie <airlied@gmail.com>, Simona Vetter	 <simona@ffwll.ch>, Sumit Semwal
 <sumit.semwal@linaro.org>, Eric Dumazet	 <edumazet@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Paolo Abeni	 <pabeni@redhat.com>, Willem de
 Bruijn <willemb@google.com>, "David S. Miller"	 <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman	 <horms@kernel.org>, Oleg
 Nesterov <oleg@redhat.com>, Peter Zijlstra	 <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland	 <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,  Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>,  James Clark <james.clark@linaro.org>, "Darrick
 J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
 autofs@vger.kernel.org, 	ceph-devel@vger.kernel.org,
 codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org, 
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, 
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 devel@lists.orangefs.org, 	linux-unionfs@vger.kernel.org,
 apparmor@lists.ubuntu.com, 	linux-security-module@vger.kernel.org,
 linux-integrity@vger.kernel.org, 	selinux@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, 	dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, 	linaro-mm-sig@lists.linaro.org,
 netdev@vger.kernel.org, 	linux-perf-users@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, 	linux-xfs@vger.kernel.org,
 linux-hams@vger.kernel.org, linux-x25@vger.kernel.org
Date: Thu, 26 Feb 2026 12:01:42 -0500
In-Reply-To: <aaB5lgKd8FOIizPg@casper.infradead.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
	 <aaB5lgKd8FOIizPg@casper.infradead.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: e4piewwxt44igpiixwn4qgqfyxt918k8
X-Rspamd-Queue-Id: 1DD731C0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1772125318-584378
X-HE-Meta: U2FsdGVkX1/zOSGxCPLR/FxbvnYA+kAKD9ei3WkKfTnYhkN2vVCtmZDe4527BL9v/UrHf9J5yIVPJXOSiEZHzQnZT+VbBJqWEv4mXjgeDcbxLos9FtqgQhrvqwoCJsqMJaj7F+9/66acuI4XPSffKmJZfWA78qfwyt0cj3m+ARI9JmI7yAKJRbyB5FEjwPjzMAz6QMmSTbqjksOlO83Oo3Gbo/diY7E1CcV259xdTNuVLyUylQvtX799K/N11D81CYAStGVqu7WY8S7taxY5C2V0I66HjrbnQWjE+F68VLLRlACejl83Qw8hbsad1lWPKJjyJb4F0tNTWICTzUmUHFgW5A+gxgFU4weVgQ/rwlpzfGR6qC5Fo3O8hUVCk1JfWUHhWKcdkjLmfzhdiBVv6eIykooYWBu2NcPZ9WVfeTPIDn8WSD39qmSvJJ341hqq4ccO+kkioCg5fvCW0ujL+WY1U8MUIIdsMx3f5IY+7PKwsS7471owyCPSWS0UlzTVum4g7JZ5I0ECTNTi+RE5hTCyfcIucct4ZWGqSURxYnBu83xD324l2GTHgu0OJYUj7ddK0Vsu1AlE9YJtAdG5mgypQGYV9gZNlvPijg3cc0kvN+hPUY0d/+Sti2E+uhWAaXA/ynadg5Rj/L6WfTTYY8A1xdGRqZaKKJaeMImZugMujHVVqhLqtHvpe56jrF7xhF59EEIa1YsYK2Z1/IXXo5zEwIVREE8bSf9MPSJTQ2wbKvLDGSzz6P2/rioh/EpT4H9OiItyCcDuU0Mrb0XewJRUfT/8PeTqGykPskGiGkdCmxJdCUh5SMW/pehFZIfaoGmBCoEFGXq1/ei5EHdsr03htBYxbhSuXm+F7q6n7ZATkkOb+fFRXTYrSQ85Ahi69QdAvfYCVzGWxg6oyHj+pk5d12YKRqLLjctSLW8McEq7JsdS/+gjxHAwzU8fQzIihQo2RvfaPG/HSVsJvTP
 jsTiPV6b
 y95ejatn7i4h94x/N8er1eQZtNLP1f4gCWEKVV14/9oiw3/y8COD8jhN2IprWuTXLvM3gei6+pmnOOkWBIG73Ge6M7fs8JlnRii8lWPrNX3NxO65sJgz7+59aZRjee9uQAMV0fErZxMQnA4EjTAsWKW2NflMGNbMAuIs9sG+trQ4w6V8Xd1I8qA+h9cy7Y718NXaqxpP2iYi9BKME9xBkKt60FhpXLQXFjZPMvnW+33bdM9UCZPewYQfyyQf4YR1kTDyzcVTw54B4l/7wFIEhJLBpjVkQBJn3OdPuiaM9Qm4adgQ+HFz0942OBaQ19JCJmdGYv7xCGy2h2OccPsIaM/GjE8ckHMS5yXY3MUTHG0T6ny7QikFHydR/iuyaOR4E3NeJhzysUTQAksnZpNPdplAB+ikMe/KNNp8/eZ/hluALdXVSrIXgGUnpTVXcZhQdFqsGNu2s7l76UF9ku30StGdztKMQFiQ2IeSMw9CnMWcGDRzRyBDxFJo4UFyYKy7JLQ1iR47xrXP/xgqAIZpOkTXv2/L5iP5nT46M5qkUJH9fV1IQdNWKH3wE2olN/rN9QgV9RynyvohLxt08hRdNjNc5LQy7YJCzYtgGSyZ9E/5qFvroFse55wVGJNNLmoGhL3U9MHL9sZQ+Rhgij9G6VdexpLMNM0Dm6Mm2ujTnM/AmPupGSIaFW1r8Ou+FazkcMCy0Wgt2vCQ6IAayqn8e+tiyBzYjZnFoeyaYN/iF05W0ybvpFtfSrUlph8axr3hxZEB3dxsWmi/XBwUvLmkx9vF1OUC+f2SRBUiS36403BG4zddU8NOcknn+/gZnWNrbRlZ9YrsQpAFC/+8L/RelsejmWn77u5nPFF0SX/qS82mFv5xr3q7K9LMa93lVQAvLwr+0xw2U5pfJqHGQqkB+DB3Hq6EAllWENu1REdQq/4ImMh5gGqgoASTqQr0ackE+v2MtBZuz8NTAXJL+AFA0K5CvQiXL
 z4xx+J/R
 gWJgdz9X6+tczPg48M6nOWACUzfmOfBkXilKc4ZRl7U9Cg7bDJnUeypYRW8PzfgqEHlZUPgJkM0pAi5zNQ7RvJ2KL1n4ktWpP4Kt6cwPHGGPIeDI/kuFUg/2eRidnszzReW2xIc6oEDE+nadE6ykOM4Pb3u4ZPmyqK2vGBbu4YUpLYznOcw/3377Job7Yob5b44HzuCtQvOrZkio9CzYFK7c9BiqCsm0wXto4EOgnf6/k0ZqEWXvGSl4Lq/j/gvOpnON3G83Tapn5LeCkPDyrVE+th3UJZB6aG/K9UM+/4jHXFOTslO7E8kj4dMdO9zXQhghaRgw//m39/52IhgYOxcxxBSK32IWESCUWVo+43MhawkWKuRiUoYE4LlUI7VsFU2HgHQ7EQ182iFaLnETgO6AMqpgVnJm/nJmANiZmfJj19jJ2GBZjy0iK7DT6nIurbX2AcyxHOdbTHF+s3Fd4qTLEGZApxpMS5P6X2BVjsx+QV5UPMyrn7yH/KQ4GkeUVUd8DzYWXtvW1KTPxPGfHUD31ZJ/AysnPON7YySPJ/W2RESsUG9IhCJeZI5eyXx4bKPQ2k8p6IDKSY27hI4gshId/mZ7mRCbbux4cC7Pi9kQomJDnFvnLtr2ZBuwKNcHxTT6u78Va4JQ3j+8c+b9qQZwxAssx5oCpKF9AMfB3upnSRNAD3cfVHK0l/XIX8pm7AlykKya3SSNtqkuPm29AdkHLojXVM8w5PpF1hypee47n1UT631eaXrpziUtP9nfBTNeH/nJepXC0UjAdn8MnfZXuUAcdUbrqS9ZecZ86gOCmIBOfNCCCjF8j+C7TgJZkG1UsSAumX1g4sDX8baSoIAmWGj5A9mKSvpZSpRDVnSEDMVfaqyvGkU+7JNl/DbpQLk31mqZtrb+qm7sH4NubZb4Esu/FOL/CqsYelGllFtaRfEMPXexdjQmy0TfWrx5X7feO9Fs0MB+/NwogkpLEwTCeayOf
 pVBzG9JN
 cohgADX2/x3JBhjWECu764kIlBzILvRjRyfzzSmICyUC3rU0kfIqrFzn1NBB86dUBqmfJtEXv3pDZ6StaourT5mITbE8AnnQCmg+eiB1ZkUU8QAGWVrYL2WpluhI144teQC2luZukkZH81JPsZZg2JV9rw/0yJdAT8w0gX6nojykj6ifl1fpr4+mN+3CdZz0om81fCBYf/a0PIY8XREsGJMf4/oiAmKJ7jD733SuR7ofzk9NZ+pzkSBXFSZsNlpv+EZG2iCTb0Yo51O73oVpgVDf9qUNuCRSS+Qqi1K7hTcno/S8B4nUA2sX1y23C8oZyeyaZ1/+2ZRng3h24inTWFWc9woZY67MoVzK82FMjB4Go6Q6IOFwCSuuGB6gylIFueSKDIPfzQyKJ7NQ21pLdD6zukePp8g5fL96H8Wg0k9e7H7zE2dGUunOOUMUqVbNBHIIhX/9sKnIsroQVcjzVXMXjGDoV3pbk+PaOrmLhRpSNWFWk+OF3vNDxFoJa0w+88QVGPi9wy5St/G8xd6TJRnqsAwW73OoPEN6W4rnSDc/pKNKCVRcqsrUSfI4Vtmsdj8MLf9HU2Y3GRQjwJWJt2aRl37n5WlT6B7k/zEPR/ehBd2q2eLeuJdeQ/ZVpADVXUVng+JyIptjLXG7BPtihsz4SMpp1SfXxGPlDvHlABfLAi/TIaHytTS3tpLqA3lkuyNV02bxghDjhvnO826hzjCNdCCzUjxenPfYOpiXK8/lWdHXNlIhetUzFc+dW7SuAKSiZxalMX5yRrxNpWnGwt/Zu0FRxukv1wvoaXIIUe18k9FKALKbcXq8QA6qm/SJZxtkYe+njMUovjI+jhDJV5RUrqSpU6OwG1n7MWWxTVInxYd7dXaR2GgxuDCZrfH1a5frli26Lb7V2TN9vmwprm37/dN9ke2d9d+AXhVwQI/4JcCnYvi2j1i8rg3dWclew4S9VzolBTF3BLHyP854rncsSXxQB
 Vxpdnr27
 UXOfF/iZ+Xh5H9vHBp+dLyDMAzPPl6/EavoAHN2g7gyRzY3uU9Q4YlI2N3HicJmmvawCv0B2x5DZjwNZyyleWy+jvDsC3w8CyhOWOmfe6IUkrOzaL7uK/gKVkzAUQEvZDQOqwo0hL1e0eSkTuVIhu0fPZ1nf3q2PZPZRKwDSmFb1xpgplepeVlcTKl/4jrrbiKvqLJPURWxI5G7lg7mU1AElFDYxBEb2ECg4X6M7Mn6jWebesSXdMrSOOBa2+V7IHb/anbAV9fn4Ovj7XYilJwKp+MTd3/cQ/cMURlTXntFScjFlBovZWmu3YDt6vpXicJGvFFGcw8CP9rr9NFvNSqusTXlCYSNJCDFagme1Y0xXBGP+hgIi7+aQL8eRS7kJERUVd98y9kng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-02-26 at 16:49 +0000, Matthew Wilcox wrote:
> On Thu, Feb 26, 2026 at 10:55:02AM -0500, Jeff Layton wrote:
> > The bulk of the changes are to format strings and tracepoints, since th=
e
> > kernel itself doesn't care that much about the i_ino field. The first
> > patch changes some vfs function arguments, so check that one out
> > carefully.
>=20
> Why are the format strings all done as separate patches?  Don't we get
> bisection hazards by splitting it apart this way?

One big patch would be Yuuuuge. We could certainly do it that way, but
it'll be nightmare if we ever do have to revert part of it. What do you
suggest?

--=20
Jeff Layton <jlayton@kernel.org>

