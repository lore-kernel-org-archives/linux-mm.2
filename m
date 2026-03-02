Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ACEDEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DB136B00DD; Mon,  2 Mar 2026 15:34:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88F3B6B00DF; Mon,  2 Mar 2026 15:34:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733756B00E0; Mon,  2 Mar 2026 15:34:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7FE6B00DD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:34:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D98A1A030E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:34:53 +0000 (UTC)
X-FDA: 84502276866.04.20B84F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6DD491A0015
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:34:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fgY16fS3;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGuznyFnXveIvU08I91CHTtCt/39AoIQOKlGXt8YS9E=;
	b=rAGcM/jnX9Te9H8Lgu20IQGRQc7pt2/zO1zvmbVomydgwLqZlQ+5ivgH2ziDf8+lJTTHrK
	rah1wY3jx6p1GHHaAtBKLklS+pUT4ez7OnGy0CX5jlIKpruGvMVJzKeCHkClFwXhpIlTiR
	059cHL0fDY4F96L9jp21nWqRFM2Q87c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fgY16fS3;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483691; a=rsa-sha256;
	cv=none;
	b=xgemF1u10fYadO9EzM8rT/XJ+IvAbAuGpLmMUgvMyDiAADTjkPaLR06TA/JoQyCo4J7CyT
	K4Ae7FUa5tJEVAASb5iEOyO33dbtSGfdVq+GqXnU59XKPj//DezPu46i04bxEIzHwwCRpu
	M4D4YEx/1oGdk4aCW/2OOFD+0D7CFpM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A2B6D61332;
	Mon,  2 Mar 2026 20:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AFDC2BCB1;
	Mon,  2 Mar 2026 20:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483690;
	bh=EHTsZzHVuU/dAy7aXd2v1GUI+PyYFtjQTBu0LlSdxmo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fgY16fS38E/poeIDCvXwd3Uta9LHaa1wjvUhqssQ1VgO6gCS6Y1GzJlWzt+QOplXT
	 +wL/zcmPvZR6tRpbj+9gDIhvp3laupQc95FBZa/PLD/4FiyPanmiQUTP5Yivwzh5+8
	 ltJRJD7fRDVnX62HkgYMdezXFWsSlTl/Kxxaal8h8NrN9OMVgP/npyY9E1Bki6/2e5
	 Kq9R12cj0929PjFeVc3hwTl+oknr5F9dtb6M2ZV9nnEr2FPIUzzewSlYEajo/imw9Y
	 67RLjLyAPet1y4NBEUiQvYbWxunU1VBAmdGFz2rFIcIBeCcdVqPlXXKZ5PbVUWcYFl
	 CUpiqX/BGq9AA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:25 -0500
Subject: [PATCH v2 041/110] orangefs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-41-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=808; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=EHTsZzHVuU/dAy7aXd2v1GUI+PyYFtjQTBu0LlSdxmo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH5WfrxGH3Mh44KYOsW9XO3qsbxXNwgi6BBy
 q2ckAptuM6JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx+QAKCRAADmhBGVaC
 FTRpD/wO+gig26Q2pAO0c10h91G7JeQHdtm93kH3B5YmF+85UiTROFT/FQ6b8Xr8QyQ8yB6pcNE
 OIynDYQwbs0utcUEU2W23V2gSV6M6UolcdjiDkL4C6yC27/J5tgxPfXFkRcCGmzhYtFfdg7t4Pl
 Uj/YIZ+k5+YjstOHulNPBp7qzrkatUoQ1Ngz5qq4nPswn8NkK72vs52MQ+I8CLKrF4CCy7wAQwI
 F07cyOuNO+ao8KdbWqwRgVcm3QjyAcj59iL3ThjYPnZyz4zudphEqaR1F/Oz69if0BJ3ybiGWbG
 7QQvJsih7YiAxDSGAnNblFKgw6vQ5Okr7yQaEjeeMhvwSbbusMZBrYz1Bjz+mslvl85HyW18nsx
 ad6VSTOCsXafZidzXSqx1NK2w/Z0EegWPpG6rbk+PmTIzW8bhl8jA7zgLQFVaWt+uvWF3/YsWR3
 phuYf55TbT4TBqEMOJdr1DuiI/CCKM+SNkHOobO0JQct04U1Xc2dIUKKVttqz3bmoZlGw1mB2ZR
 3fx/A3s4KYjTu+RyvqioVFNutz6Gik5US9ioG8UKG90XFVIPkVz/PF2tPXGkGN4/jYGPi594gZY
 T3eps8lpKzobfpEhVn5gbXSL/MToqXXiuXyUPUD35K77OcFQV1hZMFb8FSe9pSJ17khNtZqgizn
 nHzm2A2UJPzbMiw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6DD491A0015
X-Stat-Signature: 41u4o1pocaxqqdqir81jackff1arzzzr
X-Rspam-User: 
X-HE-Tag: 1772483691-863260
X-HE-Meta: U2FsdGVkX19JKzohWib8jyECbG1KOCUGWjnjz+aUeTvxYbIOfoelmOcZBEf9mDDPVYQqrTQXVUBWSK/aDd3bTrGK9+vibn3DWuD8rjDhp9cqBGB61ty+98i8Ht+0k9J/n188XUiJTkpxfOwCuawen+1kZ+J0BVqNdAB+7zSZVYGCVGu1B0v99LmSCz5U7UGMMOkTVgUkdHo5VpIdiCWOf22rBYlMSopEGe64BYxt0aEyHSER2fDc3Guo+rVuoxuTou9iiGAIZT8WsAk9iH6MrYIMBHmsq+mo8lhhDJNd7xtz/nIFEbGiYu4lkZ83Z6sIPYxLbgRQy5jX232EZDsxjlkogTQiBSbaFkylGVS6Oxyan6g7W3E6RCM579evEEA1G1ymXc8uzs03EuxOohwzNVZY6WA7CEhXwDJyDjQ/NFzQvx8pdkJCFVJuCz0oTRHkpzdyFgGzGIn8dHbBm/aTVlXh14X0+3rqwg4C4QG4KL9bsRC1UbcUTlSRGKZOZSPGhEAOoM5n8taqfsP1FLRAW+x5M8rGkRM0l5iQdemHzxZQdLNfYZP3fsDM5L6M6VeeAs/cAHQpPfhUUaO3uz88DTX/N0XJAXLosI8oVnCqO6vLO6AXnxbOvmsm+GZ9NBc83GsG6FPe9R1RueudTBL5TLHwnlXxvvsLWD2aur1QEO9PjMasJK6r2eSBNmRWoU192SAMcdIcwiIqcfr6IeORC7wqjZg5OCY8PjohiOYdVavGQ6QYiteN6RrBYQI/tH4+lKmJamkkyf87A+9JASS7ZSrZ8emGOLVMH/zQptb6XK0ydUBbahLlUS2hBMxfJdpGiSyfOZp6Cu31o8RZ9Y74OADGSAloZpJHe59BLCivwBdSOPY7BvN6zbSOvHh0AoInqaSxDei9CpoHwwFqoICmfgtBRDgLl+wX2q+6u+El3MarTcFa7w+oRfNIcSvf6eqXjG7RJZnRXJT74Iqcq3O
 cup7IgYT
 l+L9oDRQFUGhTvTzjFPieNmLOhx+ljG24ZeSiyK+o/qrH1LYA0zmrH8DkyjJkW1Dnxy/IwtzMH8aCMCI+DB+NeovvCLyPvyH+w8BBUgytyCG7CnQdHyrpGHF4DUoUqbftNteRJltff8PzvTJbBsxAYyQELdEM8FYlrPd3u+Lh2nrIxcFWwuW2lHzXmAGZNdJT3Xb/wuzZ8sVRUe7gGHh++08nG8MN03IMx78OkaRbFkvoY4bqKlZ59RYJkKJgX5IE5g99dUI0sjVBnWrGlz4HB/MlZ1k6Q3iGyb0fwbAtYJhTqVyK3qEIX9g74w2nvPL65xfa2elMcoAgsTZKGGJ0FduN2a3zo3LgFIW3DMfht7S2Cd84G8qzDKtqZwLZs5jsdS4OzXDauVuua9bQdVikrBGWa5Nt/UxOFZm7CZR/Z+9PQCWP+r6KVnyJtTrU4tcc934yenwMzm7CWJilHP2SEPhrHN9KFVEdCYDXmIqSc+nq0FIsBpRqzrI731+F8at1gpF6gxxDTaAdguIYQzS4C8qKNVxdoLZ7KDGxbhA8Uk1L5PlNv25oM7zdZ+/pCDkuWbg+M5jWt/hiIj77MX8HBG2OSe6pzsQhbanLJUYNy5hbMSZLxwbmq0gmtiqgk/3NT8she9XaRYEi9WSKxA2muFHaFvGdLoOsnAqC7cT7uJAsGoK/6BpEQl5u87Traov3UeJWNvoZzCBX18wRjd1GO+KCDqQiGYJLGjFCCH+GTnLSvEMDqWmJv8IQjo6UwchZXJZ31y88f8aFJhdSEFumdaAWDPdr/LIrSnuM+VokEnfr7HhVd8Q2upjePkOhg5tqgnO2umx03UBgwIaC9QmC0hwiAWoc6/GXC7q7WNQZVyxhl4wTcJUMIe0b5bS2aKH7cuqUdrVfs1qddFA4ZLnM1R+mIunl+e6XWIeHUDzfQJKjgbnol3RlRgzSQt+/3aWa5c0C+veAYBbu0tVF6aKNraq2WSm8
 1Tf44FUK
 HVebaCVfoTTUUIUzyyfK+x3G0+D3DoyhwLVO0lJ/v92XNISWZsa1xSSOU/tQZQFh3uuaAqmPdKTp42TVjQZgO62vqGzdSJ8qMWoN92C8OjgZEuWNHm6IPdBTJXPqqSNZ4SRtTPKPRzHGAur+/QHt9dg9wn4YMKprvO9fdfiYgd7bKOXdcsgYRd6fNwVbAQdIYIS35nvvjtLgiJ9QejHMUrG1DY+wnQmdt+1o7E0ocMo94vTzmlj83ehLMAl5unbBkQjl9LF/nkToGxKndvdeI9gqyGTZBGUyLDNf06/G6ZGeeD7NiDbUvtAl2OvkP8rTyHB/zUer+nsTO8lNkcdLGW+NNTE4Ex6RN4YRRbu3oKkhE69aXdn31z9arPefytxCI5I6Xe7fq8XqXSHC1SxKd3/M9uhllCAUKVOMv3s57b11cN6yGU5mBozmRfAQvjt2kPHMA1tZKOG7qbemGTfqti3Pl2hq/Wz+b+CUdEc8fyYHZ5Ic44pIfs60NoiED18ars18GBMgidk+lJREVzm+c6+5mqGrBeiMjulAHEIJixZx6V27zrJNQXSKfPoianlARN6ERkF16PzJ57YRUCkbnVqqwJZ8SBwLmUvPpJIZTrxeb+w4sYWpamU0vBIeXn95cdF1Tf1drcIgXLKOR1/gGBpcKWRwTLpd18lvb/rjb28hWnzS4hgA1kC/zONq4X+30JJu97+YmTrtpkNtw6vsJ+AtaH2Tn9irz3gpLb7p9Tl8nKxMWb7donKBODCwuxuIvfOZYpoutDKoIKR617Zlqr/jOeH6Hxd+lVSWMuysv+yAYVSWAlr00MXu9dSfdtvKuJPMcrxky58Zelo4V21QXn4Yx4+fR76p/WB61Ka9CeIvxWhpUKgz3rLFLUcRG7MHYBK5N7mJo/hCJCcVA0Wy5ZH9QV2P/YpoAUnwS+8splYHXr1kwH+W9zRh8k3/gdxO7ydZ1nfgna5G6wEdGs3FsREOkY5KK
 2SMVSRGx
 rF6AsZIMWQNulRKMyRRkQXxCeQw8G4CMB8LOeEqd9duOLg7F6MArZF/KXx4KniAenzOEHGS1eLVrPQ3it2xUFtJ4X2j1yTK8eNhzrPBTuRAK8cFBWN2X/Y3PmnOoU2Q6DYt+WPFqpT2rlEugnOAiciIXg2b7JyIo61BRSnAfCbJur80B/r2LOQVMcauH4ZXrPvNbI1myJyIyo5ANNC9SdOn/8ZDy08rqadwW68TarpGFu58zf+g/1SqFhj25JV0psoO8ID+jXPklJKLYCNwz9HffT2GZ+tT3b736X1TbGlg4x/sdQIowfmnasttBwuFRZjUOMV6LKLtbhdBaiu2Ljwx6Z+6oWPSYXLnBo/ftaURuqFsl0AKyEHD2F3WGHkrl8QYkVw9D9lL75MQsnVqeEoHHAmROnaIjsC/kIQ2PhGXOpPCbAgwESXgNJEB0V357+aiyyGYDUad2R494JjPYu5kDrwFOK0Z/NZcfiDQme6Y1/68mi3egqCA6J4Y7TpAihkGyoIU9Qd58qysw1sGkclKSbIyuGe5jcl7zNdstaGegsSMm5XQKrjRF1LyP57bblTfv5CAIqF0j81Y0PmD2aUDa8jV/UVHl6AO7w5Icad0Qvw+UymAFN3DOCbZu9j/SI4wggWj3Un1R7S4klTH5D5vBu7X+c4DjbeVmQBgW1YG/nKW3LDkzfsEQdic3RBj1f+ONhJp2+Lz13KT0moprhHncpiVJobMkaSrh3+zUuqPKpnifsjq0dfxEipSblc/As8F2n6RJvLo6N3UlEXxKJQrWFSCKtrZyl/fAKl9soCgJbjnh/EryPL9hrKDNe83DTUS1+XgS0Du34PATlK1Eisc3oxAknB+QueGTQZZ3CoS8dou+/5co0zlPQRrSf+k2/2esGu/6A5Ax2UdBA7cGPTzeh9lEO6pt5EE9nRcoptFPsP+6d7CtElrZPh4jjKcDVuJkaOLs9U0uKp11VHCAT5T7PWZcw
 zgvVwiTK
 xpQFEIMc1eH6YCuqsJHZxP4gqKndo3kAPCvLw6eNKfhtSAjJH1fQlIZcsB5lTGqyVNYBUmAsHWBH6+MqEcc0wrH/VrwHkL/UC4IP/yeyBpwtbG/ta4MqC+1vNHBM+vZhd1dr0+hhy1+4IjQ7hH2ICcEgrkwYTNfNRuS5zKw/EHPly96gYZ2MIdu5vbfoLoZsMjdX7QAcmgodx166m033KbOzNuUlm+CutTMVFyzNWkMnNYTYxG7UVW957xssMFvxJ/jUurOB5UQTzV0vzaRF5H8jrLo9tb1ftTCuH4Ss5yqxipOcz28gaGqAyeUWQZABZzCtILfaCS358XjF2Zs0UfTD1md+O4KnZ9nxERFauHSu+fhsquVjBKC+llSiQK/2qwSLEj9QVlaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert orangefs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/orangefs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 2d4710d0e05e195855186c6bedd211bc419abc36..fc0b20bd1d37043461bd2768e9155a763d3469fe 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -1062,7 +1062,7 @@ struct inode *orangefs_iget(struct super_block *sb,
 	unlock_new_inode(inode);
 
 	gossip_debug(GOSSIP_INODE_DEBUG,
-		     "iget handle %pU, fsid %d hash %ld i_ino %lu\n",
+		     "iget handle %pU, fsid %d hash %ld i_ino %" PRIino "u\n",
 		     &ref->khandle,
 		     ref->fs_id,
 		     hash,

-- 
2.53.0


