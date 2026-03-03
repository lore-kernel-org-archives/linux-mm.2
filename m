Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2977EEC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EAB86B00EF; Tue,  3 Mar 2026 05:49:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C28E6B00F3; Tue,  3 Mar 2026 05:49:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56DAD6B00F4; Tue,  3 Mar 2026 05:49:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 451B96B00EF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:49:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04B171A0437
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:49:13 +0000 (UTC)
X-FDA: 84504429828.23.791CE03
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id D679080010
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:49:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=redhat.com header.s=mimecast20190719 header.b=etvYOP58;
	spf=pass (imf02.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQfcYf0nTgw81P/IsIDOOQjFjTNPUrLYna+XMlLw958=;
	b=ydKaKWXnMGpcopS1pNGAh5peayD83KUVmmzEg22051CIngHYBtyyFkQ17YFekSNH2RVX6e
	kIdFl8vbXHNuMOHS//7R0KyLv0DbEQdhzx/9vp30EhPNcTxv6W2E4RL2GDIWZS4MH896ve
	M3awr/Yjt2rOfOEn3KsNQLqIq9wZ7r8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534952; a=rsa-sha256;
	cv=none;
	b=1sgszxvpCtFgsYRsMyz4U3vNZMAUiPk36jT26Uc9fYj4U4ypvI2uIMJ86nrFent0IChR5P
	UOlI+3DPLYB337h1CbkK76QP3O2UavWfuxuOhN+YI+X26Sb4ctITxj9l0SxgX7IPrMI2Yn
	A8MEkdzChWanNv6YOqaF2vARoHnic0U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=redhat.com header.s=mimecast20190719 header.b=etvYOP58;
	spf=pass (imf02.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772534951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lQfcYf0nTgw81P/IsIDOOQjFjTNPUrLYna+XMlLw958=;
	b=etvYOP58y3MGUnlGQZgiThVBTypqVi0jBi4/ucgmtnDvBHxRDj8Q3ThwULUMIIyx/3NVAR
	+hjm7fdJrR5dcFXNCQSLsZKcAoyUj0llA1dWiRezJunC5RzGhcJxLAyBcZ8DMaCE3oQ/Jo
	ik2i8nIo9vLXnp28EzlrdB8fD6moHxM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-0G4Chi9APz6r17gOWHLpdw-1; Tue,
 03 Mar 2026 05:49:09 -0500
X-MC-Unique: 0G4Chi9APz6r17gOWHLpdw-1
X-Mimecast-MFC-AGG-ID: 0G4Chi9APz6r17gOWHLpdw_1772534944
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 529D919560B0;
	Tue,  3 Mar 2026 10:49:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.249])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1F8F319560A7;
	Tue,  3 Mar 2026 10:48:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
    Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
    Steven Rostedt <rostedt@goodmis.org>,
    Masami Hiramatsu <mhiramat@kernel.org>,
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
    Dan Williams <dan.j.williams@intel.com>,
    Matthew Wilcox <willy@infradead.org>,
    Eric Biggers <ebiggers@kernel.org>,
    "Theodore Y. Ts'o" <tytso@mit.edu>,
    Muchun Song <muchun.song@linux.dev>,
    Oscar Salvador <osalvador@suse.de>,
    David Hildenbrand <david@kernel.org>,
    David Howells <dhowells@redhat.com>,
    Paulo Alcantara <pc@manguebit.org>,
    Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
    Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
    Trond Myklebust <trondmy@kernel.org>,
    Anna Schumaker <anna@kernel.org>,
    Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
    Olga Kornievskaia <okorniev@redhat.com>,
    Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
    Steve French <sfrench@samba.org>,
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
    David Sterba <dsterba@suse.com>,
    Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
    Luis de Bethencourt <luisbg@kernel.org>,
    Salah Triki <salah.triki@gmail.com>,
    "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
    Ilya Dryomov <idryomov@gmail.com>,
    Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
    coda@cs.cmu.edu, Nicolas Pitre <nico@fluxnic.net>,
    Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>,
    Christoph Hellwig <hch@infradead.org>,
    John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
    Yangtao Li <frank.li@vivo.com>,
    Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
    David Woodhouse <dwmw2@infradead.org>,
    Richard Weinberger <richard@nod.at>,
    Dave Kleikamp <shaggy@kernel.org>,
    Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
    Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
    Joseph Qi <joseph.qi@linux.alibaba.com>,
    Mike Marshall <hubcap@omnibond.com>,
    Martin Brandenburg <martin@omnibond.com>,
    Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
    Zhihao Cheng <chengzhihao1@huawei.com>,
    Damien Le Moal <dlemoal@kernel.org>,
    Naohiro Aota <naohiro.aota@wdc.com>,
    Johannes Thumshirn <jth@kernel.org>,
    John Johansen <john.johansen@canonical.com>,
    Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
    "Serge E. Hallyn" <serge@hallyn.com>,
    Mimi Zohar <zohar@linux.ibm.com>,
    Roberto Sassu <roberto.sassu@huawei.com>,
    Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
    Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
    Stephen Smalley <stephen.smalley.work@gmail.com>,
    Ondrej Mosnacek <omosnace@redhat.com>,
    Casey Schaufler <casey@schaufler-ca.com>,
    Alex Deucher <alexander.deucher@amd.com>,
    Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
    David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
    Sumit Semwal <sumit.semwal@linaro.org>,
    Eric Dumazet <edumazet@google.com>,
    Kuniyuki Iwashima <kuniyu@google.com>,
    Paolo Abeni <pabeni@redhat.com>,
    Willem de Bruijn <willemb@google.com>,
    "David S.
 Miller" <davem@davemloft.net>,
    Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
    Oleg Nesterov <oleg@redhat.com>,
    Peter Zijlstra <peterz@infradead.org>,
    Ingo Molnar <mingo@redhat.com>,
    Arnaldo Carvalho de Melo <acme@kernel.org>,
    Namhyung Kim <namhyung@kernel.org>,
    Mark Rutland <mark.rutland@arm.com>,
    Alexander Shishkin <alexander.shishkin@linux.intel.com>,
    Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
    Adrian Hunter <adrian.hunter@intel.com>,
    James Clark <james.clark@linaro.org>,
    "Darrick J. Wong" <djwong@kernel.org>,
    Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>,
    Joerg Reuter <jreuter@yaina.de>,
    Marcel Holtmann <marcel@holtmann.org>,
    Johan Hedberg <johan.hedberg@gmail.com>,
    Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
    Oliver Hartkopp <socketcan@hartkopp.net>,
    Marc Kleine-Budde <mkl@pengutronix.de>,
    David Ahern <dsahern@kernel.org>,
    Neal Cardwell <ncardwell@google.com>,
    Steffen Klassert <steffen.klassert@secunet.com>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    Remi Denis-Courmont <courmisch@gmail.com>,
    Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
    Xin Long <lucien.xin@gmail.com>,
    Magnus Karlsson <magnus.karlsson@intel.com>,
    Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
    Stanislav Fomichev <sdf@fomichev.me>,
    Alexei Starovoitov <ast@kernel.org>,
    Daniel Borkmann <daniel@iogearbox.net>,
    Jesper Dangaard Brouer <hawk@kernel.org>,
    John Fastabend <john.fastabend@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH v2 000/110] vfs: change inode->i_ino from unsigned long to u64
MIME-Version: 1.0
Date: Tue, 03 Mar 2026 10:48:05 +0000
Message-ID: <1773080.1772534885@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a53DL6sEgQF7csdAOXA4ecA0uHLtxpoT2l95dXrgqEk_1772534944
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D679080010
X-Stat-Signature: xebnwu9a3uyzo6oypacotsp3mstw7w6z
X-Rspam-User: 
X-HE-Tag: 1772534951-850182
X-HE-Meta: U2FsdGVkX18SWMhzcFvGW/yof0elOwkl0Icy7fEbbhgtYMjVROXuKgPO2qRzQNk7p5ZuIYxefcdANi+AYQCO50YjH4BnoDw7I9hz2c+qKDx0FB2SplBdxO05AOHEcsIqOunJc0CL4c3Pd8YZU/t7slR5aTyTGGZLvSGWyK09RBj4k3DOk7ssdZraKyOTPCpHABtWEj3JihLKbj+tAKVjTS9xrItxHMaRF3qn73t5pozsT7rjDCuafXdKkBG+yp2lVbfeRkYiDX2X97XY/y/anZzzmpLxCrxvOZekkB8BPmeiNk6DxecXZ7E3xHy1JDpzxWQc77mPFpN+yIPvXHhZZ9lWisDncgsl3lBcd7WDp6+RKM50KS8n9XMxxLqT3W9AxNs6RqvxF6ypVK0+R28u2KWHmYwJ5NfLfKW8nbSOJpsbcGwjI7rauzmSr7urvpIw8q34j03NDbLcDk/O6gAWROcpvSxXfC9gnfF9RKBHDiYpFP2vqNG8ppnUIJKpZ7VwVA9bvb6abhIIYkWEwC+F+r6cbx+4VoFAj57AKyucIPiDn2FpJxxOO4FCQX2ucHCLRX0blvXBPjVex4o3OBJkrLa6oTj3BZVg/pzIscIXcAMENMExJ0bcz0pKGpQtHBdzUmboHNe9X+yjnyeJvy2kkAYCCrmkz5zR9dsevjahiMZv9z1koU9IuNpSczBfLv7BkwhxmmdyRtFMuQajJN9qnz9GQHaA5La4NZ8gFN6MYr/auwmkDjpvxCHRg26hmIM+0yQRNikqXdeJft8L7x8yf1Erycgt0R43OnKYuyFirERrqWB8aWxW9jG0nDlK3oif+6EfOCxPphzoEfTUgCLBVA6/BRvYozp/L0P7myyApunSU0Qqgw/KUX0YAWT1VvWmkbnWQo2EPKNrnfgk8VRT/CHeNv0j7WKujIsVKwM1mg0wHuSxF8VOH5OOPOd7xjR91bO826tET7b9ZOPYyoW
 X7998gBO
 2vBYX20RHFjPfb1e55eKleZzjQmghU1AGh5WyXhAi0KuNCFkVTBxHy4qdKkxU62HDLoYG3OeSyMivr+figr4QXiisO14Lj/MTRrRVd+tDSHYb9oidwmVL8rO0ZyqQUlskLyEHZT2WY5GkitMrZkBp8mhsWe5N4HZTkFBkgHHU9I4Mb5biloD8zkrtad2rO+I7qjT26UUjJSSE3QQuoxuXkoMlD4i+NZ5zo5UwwVgXjP258RkMXOz2fV6LC111FG12W8NDSl35Z4ZbGhVe4Tc/yKFxtobSl5FPj+LGajRVeUNGkGLS0ryXmhH5qV6zs+mYwfuyGQEwevEv0vP0P+DZIQFJKP6QserCFSo8Dg0kFdChiBLVunYc8bn033tHDiNKj0Nfh6EcB3+SLf02QbyyGnzXeZnirlKT342csel021T2xdSt0a10uw0EAEXZd/tPYnY5LpqbbsWKF+eArE/DwjqGWXNoY3BxGaO3YF19k3Hs/OIDGj3EQzuofFlZ3sgW9HQUi5zotrTZNAwjAqfKjtLpRT/qXdjcLgFVpUPcvuEIRsGeZKtIgjJ2amHNHAD2nrogVyd8C8HULs5Kj8ghNqnxXxScowyj/y+h/G9bxGTkvTCsDSvRdfyKFXq1CoZozweoGjU4w6z1axRtA32yr6Sl3OJ7yXKgemoTLrkChV7yIXjxa30EdbTiSafLS+d8RXG82eoH3d6T58H9jC0iJ74VH6pGt48rww/YrsTNJ0FgoSYDFVTrtsZcTBvHa7IGGmCk/l75HHUQHFVEPdggmGAcseSm/ZZjxLkAZ0MUwvNt7h7WnAoMO6I51DUmlIBtthOL6YcmkfBWd3ks6Y43mjCTC0Tj/TIJjp8xaTMCPVmBVpOhKxjVDCCQwOMizDUC2lY5c4YubgKvtRT9dgS0xRUv8p763aCQG2VbeDSyiC8IQCsQ406CqLL9EAj3py1T3htiOfJDMCoQ5GTxTToXcp3d8zr3
 A0Pc9r+B
 JU31GTuqSDN6wFXUbc2TLSYaba6P8nNQUrJ32q697jnFyJTQPMkjXyFHoUB52JutiIBfhDUO9no2gGq5bB6qXKP6lD9dasMhzsoj6eSHmyOgjzKYsMR2jDZIRx98xTPRMQs56jFa0kWViGmtbGr/JvSvwDppFGG/mlknJTOVenKIQRheaSkJ5xvlw5YixwnuMgYgIXnTIEngGB/5isnDu/UhBwti459fP5FKkXXqqgQIWqmur1eWjjNzuRcEK+7VpSFPzxaco+U//Uu/as5iViGfrzL+O5eQl+qWZID4aY5obZK9uEAsbRAkCBSz0YoHzFoMdcCtKul1XAa9CJKRMLmzSW0wcL5fqxN/gxE8QYG9z1e17XGDD96cbURgQUmZjoSJ5tLiC4JRB1DLjwRq9pZ/xIX/CYOaLF3lG4b5BjYJRuitzuIULWZkzPiQIWQkMydeE1Y3dq+4HTL0v2KNTlULILltdtpQpsBh6N5ya2+O3CC4keX5TL8/Vs9EYuALCGhGp1dVP0pEgvVO/PNYjONjhsWkl51genqY8iI4BsldNPpzncEjXot0pZ8scFMvVJEk0xJDeGOW47+A96K4tO0hTRLt/nYM0UZKUlj9pXk2Qh+wyE4l7Q58N+e61i00l1GFuyRr9DxNBRl3acde4h1cZi5RimJ606mo3d4WvgyENsXr1EQXw4Fc9qGZWBY9C4abFBA0sVIqcS2FikvjYFGGhSoA9XnMS6a87RooZCdVqqeBIrP9mzBvv1i4uCX83Sdyy+osU3t+BTzHSseuAIUaz3Lgl0Pf4FCfcvbqi/J7SvNr4yu5doeJqBILSJeyrzOro3vksW6AJNTws41qNQiII0Iu0ywwmuEbCESLlW/1MqcDH9MO34mqbKvie6lf9Sa3JR1kmSxlrcSjBFHZ0HMKHodYn7kv1Q/fKys80iHfuIfJZHjSlzbga6hWb0zC1nwJrz0NVvke31XKWRKsR7clFkork
 M8a8Cdu6
 DWfa43n+jyM3OG0ZH9kdpD3liWjZ/NT5F7wxEA/tKEnS6jhQuoJeacl1gMTP6yoSGuYMRluVnPQM//EtfqcOk4odEiGyUxOZfDvuZf7l57MbmiZAJwtDWHi14SYTvY/II/Ik79f49UU+LVbDAStYkNtWcEUg7P6qME77DkFrI+xU5gzUU3UFn8qUClzpbHTLPYQ/TGAHjW57SlorQ0EI0FlWYqH4Z0Ry0G/hWLj0ZEKB+QbAxxCAOF49mRIW/zbFjrNfToAGvKFF/JvZ/58u5RAo0LDNuzYOV0TKgmIzFt3iIUea+vDgdL89Vn/2Gde2+SYaQvzMcYjJOzPOTiA7K7/piznCQjheaq6xyYTZ53o6Vee3PNUxrIvhTCfmKdpcW58FJKEuGfD7onnPUOvXYuvoZjTJvu654DylUHiIUtGKaB2s23KBw9o1czxLGRi/NMjcxJ4Pyx59A9MtJ4BR88p0kBPbPKLor9i0gwiUt+FR1XnHviN5DuJneA7Oe0ReUK3zUvzBqAuvNGXqkZH13klCw93iyYe5yM8eTKh0oeN7HDbzxTY+zrPEpbb6elqmRS3yt3gEd8ePj7ZL5O/xpOD2Db9E/N65UYOLP04MPNMDqR2tAeo89bw4sYaVPKdz83mp+qWPELV0rxV3AshK6ab5aOQHNXKpabclQtFUt6Ad0C+sM90iEDDHG+x8V3nckP0uoGyTgFWwGxBcz0KAJ6NdXGoKaMDUQ0cm/KE1lP/aIjMePchLVF2vECGLatiroMoOER+G+WDbRARLy02j4Abd8RGfa6JIFCWTw8bA7C1xbH4X6MPDlXMv3YdNFw3JKqHUPo+6Dt/fITIkkSdRH5teuUPJtEg5dpVoxEXPI/cFeYu4ItPZSBid8AX2qGhpmriU/n2LpPeJuNmwhb4XIfkiTNksN5Sss7hiniGxHkUiNstTfa7md3l2Zd+RZ1/sqHOdpLLc7oqYouKyxfox4KS4/vA1R
 XZr/l8nl
 /XW3OhpHq+kzQdMBSFUDn3HmSSA3iVbIcVimq65OigYj4GasCg2Cpp3cq+OpQen+BdsbjH80cjVS9QnchDSACI/iIozTR4R8oN0NQiI9WvPsDj9tujntbFqnlse6N24nYdNdemO15EKX3lvACuFPp2vvd4vdkVECOe05pouG8/VLlGJ3RWqZ/ZCcmcRpYEzHFr+PXbxJZrIquwnm9AjjMDle5XGSRDqkDwXiRwsBDzMguoA7NazEVefrB5K8n+ZO+XdhkoSdrk96D7e7k6kHH0EBQ1RBcWzcnRa9zGfhVr60v/SxCZDmT5v4YpR7SzVLVCQGeh6dN8eozvYpVK9kb3Mt/Wlr7155kgr5RzcXj5ZB8Fizw/73z8pb37w7P1OpKHtcm2bArHPz3Jlp0w3dyzUqtvsKYQr14G+Wn++EE5EJEZVZeafnYtbeM4ZCBS6ToYD4qXJ5JKcD6HEPViPWJGbXgLVvZodrC7KGKcc6PNGvunfX36lWkf0Etiz4kXpC3ozf628tqGyMknhYjI43fw0B0YpHIEdP224Cn7AnsEkrlxK5fk9Le6G9QcbzM6bsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeff Layton <jlayton@kernel.org> wrote:

> This version splits the change up to be more bisectable. It first adds a
> new kino_t typedef and a new "PRIino" macro to hold the width specifier
> for format strings. The conversion is done, and then everything is
> changed to remove the new macro and typedef.

Why remove the typedef?  It might be better to keep it.

David


