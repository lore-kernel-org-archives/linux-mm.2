Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1861AEDEBFD
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 01:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458436B0089; Tue,  3 Mar 2026 20:12:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406296B008A; Tue,  3 Mar 2026 20:12:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DB006B008C; Tue,  3 Mar 2026 20:12:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 177516B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:12:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B476B57A81
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:12:53 +0000 (UTC)
X-FDA: 84506606226.17.B1D1678
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 00E1440008
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:12:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WgCKlAsk;
	spf=pass (imf17.hostedemail.com: domain of mhiramat@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772586772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnSZjh2WNTulGYRVG9NKG5lKH6rypFLXh77lgmoqCuU=;
	b=M/DHzlZSSKhZ8Q5vrhbJszxnwEKOOwE/NZ6sxJLCak5bBoLqrEVPwfPVpC/2ckU7sIwbg9
	tHLg6HTJUMULvkaBO4FuZIoNTyjPdrtDknf2C5ktmmr1kOHHlvobD/vdMwxCNkvepCzj9r
	+yD5g8dms9J5RbBVVTQTfixQFUWYgto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772586772; a=rsa-sha256;
	cv=none;
	b=1Zbm1AoDxz1qHgRych4lsbk1wmlCh+jAvJOWpIbTU+S5LvRPV4ZN3/Ef8GJy+AzAoMkW7H
	uZid7Mhm6kAVf7Lxw2b9n4yd310R5YDxR9gqxtE98cuT3B585p40KTbqdFciKjP3L9HDZa
	1kfzrvHneMf1+0Z37CmZWUFeGieA+eM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WgCKlAsk;
	spf=pass (imf17.hostedemail.com: domain of mhiramat@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0802860097;
	Wed,  4 Mar 2026 01:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC630C116C6;
	Wed,  4 Mar 2026 01:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772586770;
	bh=GFMrZQJwS7/We+LO7SGzzxn2lFIugPuzG0DMG56Js2Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WgCKlAsk3bXb+r/1s8b+OdlG4mX+icJAS45Uq+KKMNYvC49iKTzsvQ1tAfDcKjOHO
	 pKVaQRChw5HLqCsmNleVgIcsLZe/mxOdeaALYcjfevERMGUkXjesPWWweCyhou7fQl
	 VQ4Mb37EKNYYDJ4P3igTTUB/rwlUKWDzyHL6MaEPUYg4GKRNARAdOpQi37TER+bijy
	 ujXwk/T7EtjhMi3TyZMPQ0jsSUIHCkGDCCDxAdqRqWs1EQh9//lrZ/RlcnBRfnGFFQ
	 Jo6qgWMK/+GUePLR79A6WJNPJzwq2R2bZgMbaePiL9CPpPo5lJ+0GFE54ESH67v3gD
	 aYrfgbEpOhAMQ==
Date: Wed, 4 Mar 2026 10:12:29 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt
 <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Trond
 Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck
 Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, Olga
 Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom
 Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Bharath
 SM <bharathsm@microsoft.com>, Alexander Aring <alex.aring@gmail.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko
 <slava@dubeyko.com>, Eric Van Hensbergen <ericvh@kernel.org>, Latchesar
 Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, David Sterba
 <dsterba@suse.com>, Marc Dionne <marc.dionne@auristor.com>, Ian Kent
 <raven@themaw.net>, Luis de Bethencourt <luisbg@kernel.org>, Salah Triki
 <salah.triki@gmail.com>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, Jan
 Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, Nicolas Pitre
 <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, Amir Goldstein
 <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>, John Paul
 Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li
 <frank.li@vivo.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
 David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>,
 Dave Kleikamp <shaggy@kernel.org>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg
 <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen
 <al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal
 <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, Johannes
 Thumshirn <jth@kernel.org>, John Johansen <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin
 <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, Fan
 Wu <wufan@kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, Casey Schaufler
 <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Sumit Semwal
 <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de
 Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, Jakub
 Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Oleg Nesterov
 <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar
 <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung
 Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander
 Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>,
 Eric Paris <eparis@redhat.com>, Joerg Reuter <jreuter@yaina.de>, Marcel
 Holtmann <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Oliver Hartkopp
 <socketcan@hartkopp.net>, Marc Kleine-Budde <mkl@pengutronix.de>, David
 Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>, Steffen
 Klassert <steffen.klassert@secunet.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Remi Denis-Courmont <courmisch@gmail.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long
 <lucien.xin@gmail.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Maciej
 Fijalkowski <maciej.fijalkowski@intel.com>, Stanislav Fomichev
 <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, fsverity@lists.linux.dev, linux-mm@kvack.org,
 netfs@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-nilfs@vger.kernel.org, v9fs@lists.linux.dev,
 linux-afs@lists.infradead.org, autofs@vger.kernel.org,
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
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 053/110] uprobes: use PRIino format for i_ino
Message-Id: <20260304101229.bc9fba5fcb816b7325fdf57d@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-53-e5388800dae0@kernel.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
	<20260302-iino-u64-v2-53-e5388800dae0@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: eb8ftd3uis8sxmr81yk7uhpzsrbww7bm
X-Rspamd-Queue-Id: 00E1440008
X-Rspamd-Server: rspam03
X-HE-Tag: 1772586771-340916
X-HE-Meta: U2FsdGVkX1+hXRg7flPWWjorA3ZdGU9v4uEGz+o+zzH6gW2DI98Ow2P9waA7YJ/Vij1DNC/W+SXHuq5wChPQJXHB5KMiOb7vWFdDjDS/tdCPFPCj5Br8nbGfRxosOyM4Eh2QCuwMraZIT7nsVmz9+qJO4/EPS7ywoqSPudi0w/Eb1KZ0MlISmetROw8QUhXz39b2TYecRA+fJMZxy9mobpfFch47qCSI6SKx8k47j7ZgMFdzFHuEymtnJA7g27aFdaIDuQ556fBkpVDbzwrfyyySK876pyLl+vaVmS/GAI3uoyF2uvNwQ0UPR1nE6YKGGCg7YGKVOTbViICH5TOJRofMrH+geP1wGR3F5tLheH2oFH8fW8HWRWzudSFoNkFMq6QX9WnhtomSB+9DvhNnad6XYlIuSBF0qYd5E3pumDOXEm0w6VPt169yoznYOCZA7efdljr8JeyZyPqhdAwJLQENMEEdrAlC7umRmSqrf+t/EEJJIZ/7ZNLrDGUuYaTKaGU6nVsDmTONlm25EO8BPG9W5l8sKAPhgJ09qVQ5BbNLJWVshY2Cu3kJeKvHVWuRAFnaU1CeoR268BXHKHx/2JzeaeafE3WtAVJyfe9KzrU9SxNKbwpkFyFhJVttXP3Z/TZQD8JmTP9i1VsPi8/fZDq/IidW1LEqSAIHb0RG3iX3hg5vgf9kEPXNNcohT9DiejzAyL2bHYv9Ql7XME4xrRvPYp//dEP+WwS2p3TcPxi4oTn3yq2+ZOnU/QOLgNn/H+AVPlpyCzhFbZK08TG1bfBL7B9zPxUu/eSbFN+sCS1z7jsU60+0mrssonkYYVCIscDhgUXNpBxeZmwj0cGZPTse8S80grK9t1jqqok1VoKkZiICr28hLF6Oy+/SAPgCf3edrVmPsdcgYuZ0sC4Hyik1eyb5szEh9MApJenmupUgZNKjnpoIBpQSP09Y1WuR9UviBYqQqpZJpkEm/Af
 WxEvZ7u6
 MhC00BUjnVSq0HeZVcQnXE4WsqWEm4YM78ugJ5JQ0tSMruEodovD1se1n+6PBI6/irV1mjFNG9hu0WH1NTfg4vp7eYLNq22GXFmYodVGo5ZPGCXN7RpvW9CLfg8zLrOfA4ughUvQ20dV1lCMUngQ5D6jLEuO4ncy017Z+aur/qBlbmZ+vf4MC1pXeEV6SQ8vgN1Cc3w29wtJRlT6yJp1USsvOibFC514pGf9PfDWENvceJtqk1T9SN/ROh5h2gg9kUJdG2lVYtk33z0FLBCbSyzSGnW3dlvPnhjoSxXLKQnKSwxYKYbhP/l++7ypKHHFvDBNP3S6uJHIwwE0ZSeRr/8tlxQ+Yxh6PWdhRlvcRiSpAdEVW5F+RRrbGOt6AL9lxY2RoFHliKHdvfKTROyIbm99sAbBnJDEeuxdQzAw+8BUtuMDQObAWIKTrkHHh4WBX8HhrKfpfnGJM+UyPn7a7/py5j3uRhhOrmsWc1Wyk4zNSvrJZga5HzObJnLC+N+OnuZA5llLh3xNim10qL0N/Z7m/6tnM06xe8rC4xb2ZlomWw9NRWAOdeUerpQkoCfDOpQWWv/+Th6pikWVWe9C/lGPfPPZKKVhuf9jmVxhrY2Ik4z7sb6RcfyuwziZcCA+qlcZxLj7LIPf50ydM6O6WjHb8BJzJMkH9s8YGVcJL2MCvCv0eowK0M45NTM/0iqh7/I3BAGpFjS5INM00fl4lrxmg0o7iS5eXfAtweRoP0emXHHOdS5StxW/yUA65yOn7yUT60Yb7Br6WYJXvQkYmK7+oSW1eRpn59sfQsyXfVRc5YbqWfxo8plAWLOuIStdrknTe8PDMfXexpUGu4tgcbbDAM438oBzd2q4c8YGjFxNLdgutSq9QaTS8L9RT096+QhdPTq+hhZK2Ycv5gdIHed1JsIDOPUCrQYSCYSiXM2k4zp/BkCDQlKFoQCV6EF+tUsxzYhZjFH9fSinqFrCe/crBBggt
 jn6BDGNT
 iZQkpbXlEYGGuRxOePErSYhZ61IcFpxICXM+3YmGRPiAoywqlYg6OZB73NayL9yyMj26t8Q5mRRU3KYa+6XE1lmApiwCjpSdZ1QkywB56VYBqLUmYD4dzg4hk6URg8U6F4VJQm5T9RB0Mv06FtC5707tET6Nbjcxze2UqGsZeeGwvk7R8xnXzebxfrVfA1hLVtYxrlqEAmcrL4txxDPr+cZXnp9AkcDlkWGF6TZG7NoCrCaCYOdNj2UF1XTemuFFhATcGLgQDDohPpjfGlKdcnEj/wB3q8483qLL2TPe46fqoUkg5C4IVT/DktYMdP97O0OMnOkAjZJkhF8pF/BcpSJ0l9XDBnrDSGgm92gcq67xN7CW4ogxyFziXK46p5fGh+kk2hYRGveTECpGt+bmY6q5sujQA3FrJjL8mBUqQBoaw8Cc4eRU9xgz5de8G7V5L2mBGrLlHbniaQ4uwGLwJebNbCmETtqH5GnMYGzmZAWbXvfb4Vvh8IOqy+sexcWiUv84xH1FvC9WzNGKXJzC9h/H2YHQOOmnkc1w2MYKrdrx17Bk4IveG84y1xGIttGWi0B+2yKuO2TgeazXunW2XhwGEMcjzxWuk7J0XZYgenXYNq4wQZc8ay/JmdJVKSxqAg2L10pI5TESR74eGuJ/3hEInGklsIW8hvks+5Ufib+KMBqNHaJ5NrSgb5ivkib0Fj/PND4EPo5JBT/I5pSweSQudmbYErOVmISg47ldQ4nrYepAGip4FvTaQaNT7/1jxMWrOc6kCclhTC/zYVvLT3iyoC7t/XQQ6SqazmEe6Y9vNZhvMD73gmdZt3x37aiiO78okfSsUkronFZdv9y+Y3nFYyob3l5HJolnPQo0ImiqRlWU9CjCMxrPy7Xcbyfxl3cFmCevqRCT9zEzyEaraFThAQyNzGUwJn1lySOB+WUkgZHDGKJ5IEGpkToLOgN4YutfaVbkRxx5hdf5Gw3oIUKoruOrW
 2MR3UkGX
 EfQ5Uqd2O0rveBHvVlGdgge1PkXnQrX75KOLop0gXRovOt+51aS8guAx5519+LobxZKWRUbaeap0CD6pV5zFZKmHP1QUABSqL1wchc+4yWUdRWl7IgRU9QNl5ThAl1IU19oGAoi1locPeBtbSxVly3KCQuhjvKbpaW4lhnpZa5bfRfz04k4GwxPeelwzpXfM1WgNxAT6Lex4vHSXKcnmg+sQtOu33t1Y5koZ+5pXFRh6f87M0JBBmer1JS5balKmsJz7cbFTGJPguHZpVEkJEJtt1Q7gHaGSsTVfxFPvTRAgZwLJTTf7NuCkfHAh2pW6oFuhD9RKzsr4vZHYZTF9xP65+dLwbKhX57tPYTLtG76mmcMWa/LGX4xjaa5MeQLh+NPFp0h87ntU1a5SK0cHkHmpL4k5kuFIIxMEwsAtJroz/gmtUcqdJLEks/msm/aatmJ8wPoERtNjIOWnLZgByum8ErR9BN+fh0L6ROlxwh36XaIEtranJSTsHrWiMoyj+YTRT23ioXCtdyizMEbINSQZqA5xAgMjLj8OYbEdhZIs6UXU7fK+apKGuT6xBKneNTmQe2MmblNSdcaNBBUwABJsEONGFB9MLCL2nv5/djeeKyaXco2Hyy2/y1oBkzyXlROpa7Uy0OgroAIp7xbP277Y2sUIECDNIEsApArhaRWB/6fYCP/y/IfvtempfpntKAmvXY5sYayl35SFbSAFRn+er+uK3Ll9eWXsmudXDDjTw+r+wlHUhHn/knAfPP4DNEIBV7qTQrgklkvnNYJZSDemCw0vYrdWuVi2FGf/YGhrIkcfWxwcp9mhOmiMkZxtB0Rn0xh9dTONlwV5AEbVnB4QDCM6QOh0ow1oH8cT5GLzCr7gr129mqq7aK3RWks8AzFtlRGAw/orTnAGygM1j9GuJuTnePNun3Ol0FhuGoTwIfGBb5yV4f9VqUQEnBK5i4ooH7Fjb1jOWp9Y9XpArkzYme0i5
 jWkDBB70
 1jWlLWMoXFr4bGu2EW2VgFEYCJ/or2TtatRSLNywrt8etkGUEoX84UA9zCjbY0kRUDvwUQsD9RHi+292W59s6AlIyTsnZXez4gO7ZbRbsXeDhksnsHp3Lz+LHfxDgP+Ihr4XPB1cLQ46hgIATm8TnjF+/q1JS9QaK07w+NRz3zzrVL75PksCZadpoGX09wY2eBOqoiAS+Q+vwqP5fCmu8+maaPWfFGLOX9zdaBWv6Mbm/5TJfMBjeojPM3HTTigiVEyTRqQ1PAQDsCyc71xndQy67XfxSlWWwXIAmllBKENLx2y8Eu3SKDfcpa5dl7NcM259awH41pvLbX0lirB1OO26jexYyV2PFE3oC6oviqfNUboJL+mTx4u3cMXX4TaLDkp2yGDVNTDIaSH221ZJY+KFqN+ysk/x3Y4Yfjc7TyjKxbUNe1zeDcPcRYHTtBxdvBNJ5M5gT6V2Nf/V256GfWAG7U6hVcc+NvkMDBmvS+Pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 02 Mar 2026 15:24:37 -0500
Jeff Layton <jlayton@kernel.org> wrote:

> Convert uprobes i_ino format strings to use the PRIino format
> macro in preparation for the widening of i_ino via kino_t.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks,

> ---
>  kernel/events/uprobes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 923b24b321cc0fbdecaf016645cdac0457a74463..d5bf51565851223730c63b50436c493c0c05eafd 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -344,7 +344,7 @@ __update_ref_ctr(struct mm_struct *mm, unsigned long vaddr, short d)
>  static void update_ref_ctr_warn(struct uprobe *uprobe,
>  				struct mm_struct *mm, short d)
>  {
> -	pr_warn("ref_ctr %s failed for inode: 0x%lx offset: "
> +	pr_warn("ref_ctr %s failed for inode: 0x%" PRIino "x offset: "
>  		"0x%llx ref_ctr_offset: 0x%llx of mm: 0x%p\n",
>  		d > 0 ? "increment" : "decrement", uprobe->inode->i_ino,
>  		(unsigned long long) uprobe->offset,
> @@ -982,7 +982,7 @@ static struct uprobe *insert_uprobe(struct uprobe *uprobe)
>  static void
>  ref_ctr_mismatch_warn(struct uprobe *cur_uprobe, struct uprobe *uprobe)
>  {
> -	pr_warn("ref_ctr_offset mismatch. inode: 0x%lx offset: 0x%llx "
> +	pr_warn("ref_ctr_offset mismatch. inode: 0x%" PRIino "x offset: 0x%llx "
>  		"ref_ctr_offset(old): 0x%llx ref_ctr_offset(new): 0x%llx\n",
>  		uprobe->inode->i_ino, (unsigned long long) uprobe->offset,
>  		(unsigned long long) cur_uprobe->ref_ctr_offset,
> 
> -- 
> 2.53.0
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

