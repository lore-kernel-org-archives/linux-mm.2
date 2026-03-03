Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC9CEC142E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416F26B017D; Tue,  3 Mar 2026 06:22:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7C36B017E; Tue,  3 Mar 2026 06:22:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299306B017F; Tue,  3 Mar 2026 06:22:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 169FC6B017D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:22:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B2F6A1A011A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:22:17 +0000 (UTC)
X-FDA: 84504513114.04.16C1590
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7EDA14000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:22:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MMje5RHt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mBJ7uKd5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MMje5RHt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mBJ7uKd5;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772536935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KeUIkqizRv13GXqCMqsXZmgZff1w7sG5Qjbx6Jj7J7Q=;
	b=oMO3ruU3cKVDe3a3FHbcUBqLgltvvdOWuWve4g2/jZfVBYHLzUA9HB07V/Jz0B5q4GNimZ
	uFIllHbPHuct3gI6m53JBeArGE7m2SkaE+9yQPakDnaJ9zZhUvPR4kNadCte24gzCJHAA7
	Lsqe5Uv3kenNCMa8biuUHgs7s690OIg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MMje5RHt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mBJ7uKd5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MMje5RHt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mBJ7uKd5;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772536935; a=rsa-sha256;
	cv=none;
	b=On+p5ndTy/P2nni/6e8Lg8nemmqc+I9jyDG/dZOITrqSoGmeETgOJVuA2kZtCYYiPmqFTg
	D7qlAoWcSt/HzjPFSvbsm8cKCgGSwv/Q4r2j/jrRoQtUut7pc1v2h1HNhLTnH4BMievOKg
	5GozvXXoXREsGI0ttq1J0QQMWDI8kDI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F3B445BD15;
	Tue,  3 Mar 2026 11:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772536934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KeUIkqizRv13GXqCMqsXZmgZff1w7sG5Qjbx6Jj7J7Q=;
	b=MMje5RHtAq0iyN2Ci5NB3siR+5uKf4OabgxeLPpbapGQwdYTZLHIG9WbEhBZtfZH4K6FJj
	K6dLcOOiweD5MCv526aROGLBnxAitX0xVEFukIg5VKf81+ODBL8aapNjjd2HAUQ3YbMqn7
	qxFG09Zg+uhBneAwqCoeimjK9RUv3zM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772536934;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KeUIkqizRv13GXqCMqsXZmgZff1w7sG5Qjbx6Jj7J7Q=;
	b=mBJ7uKd5M1QzjfrDgXpF0iEdCEhfwIvS8TCLCSzoZDho+dSibf/db1v1ycUm9i74WcZRv4
	dGapPbtCt8Qt4hAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772536934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KeUIkqizRv13GXqCMqsXZmgZff1w7sG5Qjbx6Jj7J7Q=;
	b=MMje5RHtAq0iyN2Ci5NB3siR+5uKf4OabgxeLPpbapGQwdYTZLHIG9WbEhBZtfZH4K6FJj
	K6dLcOOiweD5MCv526aROGLBnxAitX0xVEFukIg5VKf81+ODBL8aapNjjd2HAUQ3YbMqn7
	qxFG09Zg+uhBneAwqCoeimjK9RUv3zM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772536934;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KeUIkqizRv13GXqCMqsXZmgZff1w7sG5Qjbx6Jj7J7Q=;
	b=mBJ7uKd5M1QzjfrDgXpF0iEdCEhfwIvS8TCLCSzoZDho+dSibf/db1v1ycUm9i74WcZRv4
	dGapPbtCt8Qt4hAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC5A43EA69;
	Tue,  3 Mar 2026 11:22:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EgrGNWXEpmnvRwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:22:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9E82BA0A1B; Tue,  3 Mar 2026 12:22:13 +0100 (CET)
Date: Tue, 3 Mar 2026 12:22:13 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.org>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jan Kara <jack@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Steve French <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Alexander Aring <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, 
	Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse <dwmw2@infradead.org>, 
	Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Anders Larsen <al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, 
	Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, 
	Johan Hedberg <johan.hedberg@gmail.com>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Oliver Hartkopp <socketcan@hartkopp.net>, Marc Kleine-Budde <mkl@pengutronix.de>, 
	David Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Remi Denis-Courmont <courmisch@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Xin Long <lucien.xin@gmail.com>, Magnus Karlsson <magnus.karlsson@intel.com>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, fsverity@lists.linux.dev, linux-mm@kvack.org, 
	netfs@lists.linux.dev, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-afs@lists.infradead.org, autofs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org, audit@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
	linux-can@vger.kernel.org, linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 014/110] proc: use PRIino format for i_ino
Message-ID: <ylcfz3i2lduxgi5sywsxolkk3yc6u5satyzrf2mymj2vcirtiy@bfgr5natl6gf>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-14-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-14-e5388800dae0@kernel.org>
X-Rspamd-Queue-Id: 7EDA14000D
X-Stat-Signature: r1955baokud95rzujwyrss197gxqaqzy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772536935-503231
X-HE-Meta: U2FsdGVkX1++FcHM5Ajte3jEgi5d4oxA6OMENSmmOlOv94m3c3wJJUPPyg7G8y3TGxTN2StlnHIOHQw1CKH8whe2NUkr46Bjd11syZ5is5rdsMMb5IHZUzcPrXF1q0LkB1d/nicFkki55w2qXgMWeO7jbac18ezs5/kKBs/NaQeSxa6sN7BZA5kdubqfwfQSiJJOUhhg6hRVKuh/IAkrBnBZMyt7hiOyIyc1ZE6gFaSDri3LLy2lkHAWGZX2qoqFkSI6a1eNLGfU6SR2UMRCJ82FU47ugnLv9B8SHfUFLBJ1w/U+wSAkgaBSrsilRCM98WK9oogZlqA56NW5tbiKVN7v/dyzKHdcJ7q4nzaXP3VXBStH2xAqpfwbOUzlWjlzU2Q4xoBC+fONr3YWhI822G5n4iqf0lDJsf1IFdouWDXtDbeaJNOq4y3sUX3iO3G8pOsY/L9sTWp4dgb2DEbtlJVfpUTxm1aDiRp6KqfhbKYoyJ66Hkez9idY0ovOEmyrS6MB8eeBH4pMZUP2Xp//xi6Z6I8FigS0O5LI7h09IOyqmJqJnZtcS9g4jMyvLtnu7brV3YP2HryMVzXU967kqrLRXpmeNDl824F00zP3gZmrrgKLailTAmFaTwHHC77u3aT1yX2Vy+3TTZh99MKALGsd9mUz58zFFwp+EqAI5t9GR7FdzFCUseFsW4zk5Qlva1dXYcKwqnzMkzdy8XmTEsn//3YXcJqps1++gLWMk8eSvQmJeZxB591mNJCJLdQeA0Y0vZdNvL/KPNEGAaCt8YpXK5l67tzMMuzQ/ZollBFTKx0bCql1ZQU2J+zVkGVauzmNa6IzqoI4NC/OGbjcXnMQJAo3pd0BDYH0zP61oh0DiaZraj/5vsSNZcD7zSWpdj12EqHL7fu8jIdc2+AyMk/qtXk90vaIOm6B9CYhQtXCUsgZW0xpfhJPV80+zhTbr+78VukEja9iTXctOO+
 SxZJLNbL
 PqStQQlZmntQmdrhswLAS5FvzxHLfhuclgG1J9zyvIiqDCglv9ETi3NMGgxfKjtVk558wxyUCNCDn0NpIfTpHiePiP7osV3TCxcHqkU+j4IOVs/wCtA0nwphfAkXUmHC1X9o9vFXiTHOiCZV3LaLVWAI1jxAQFs/k7lqmpeVfafBm24iqiHxgJ4MVtEp9HDyWIdec3oXvrvyQ9kuE60vJ5ZKCGtRiyS2wNCLewdfKbrWG00VKpDhrV2I1yBAjULJloODX5iEKauLJXAbRgdKFi1s+CR1/g2p2e0KqUr0uoYFQVseKBBn4Tv/wgRTuGZIykSjaiPE3Iz3YW1+O+NhyAO4X/10SKgSBjJAbbixAslM+LZZjg0geI+nBS5uPDJnPGJohbejnMTAZeK/NEyXTK7E5pD1JhwxmZWSU6o2lK3pr66dSD0CTpMRaBcvZcnbEArL+IrjaYLvrfFe137EiJVBadlysz9KHKTXHwFp/+ovvzgQKCxeAptHKu87dM1uwIoIbr/8VInVl2x5hZG4DLU0TrKGToV/BXH97HNiWzf26Da7y4P31OzCy0w87yP7s3toPks6gQGwfkXnNgbZX2XiWWN4O+3Esj/9XaeDBU9hPfH35Cyf2Xlt0EdNuElJUcWG2IZNe1wGzQ0LxwKaEW+IbF8skav2VoTSM1O5/VBOUGPyCc0OFHuc1rQDcHNRwsgTtGnebx1HQIKeXoVljrhaeGUNx463nFuelVKEfuiDazl4PQgbDGgFXNy+rMdgpnk1jAJ7VhiYsaeLvOAy8JqOuj1iA4W3tVjbX+n1aYc5DJ3eK3X+fas7Mw+lrlhRewj8qdBT265rtDuwy5yjJyiloCprhjv99scm1wmkmjKZqWiieQT52h/LaIpfga6p7M+0GS1sIPvxvgw6JSl8lWV7vS+FeVVh19S+XywCm8C4ieOHNBw/sbJbiIKRCjjS2/ct9e7tSiMCLvFdoxrpXFW0bKPaT
 ceacDVPY
 aF6kKcqzymXYS/cpKf/I0BzWsf56BPB6NbVRHPFK2K5eUz20ka+4Mq5C/Odue0T3mkgD5+STEu2Jp6u6dyxP5Au2sWh+CCmM3mcPgRqrhCg/ZvCIEyGwfVvw+z23K/Skw06GURutP/8eT1c29oJxLZKBgpTZ1qiFbxSfBVCiN0NTqNkcfzZ/X7HfYCL/urWjjNl8mi7CMK/XkvGFfg1OXi1kehf8IxMIH9fKEGjEKgAJONrx5Bt51jb+g43UDSoKmuF6QNlDCmT7uL1BUAUWtiZgkFrrc4cpylO1pIHFBE1VC7xwXsSxCKrfXfcUnK3OYC5X1Z1Q6moBDcqci4en4NR6HHelI21TfEaDJuAzbLTqbH+hCqGR2h1Y5832wn/DJIIpHg9NnOh/1qj5N6dDQNjbJAUiEEPGXsl3rEhBZOUOMA/Ye3lJR3EELzofpqoqKR+7eczC+TOPa/vHrriUjjyteWuNsqc0VaX7R0n3nKDeuvxyYxmpd+4FR0vqODs9gPn0IStg4F5Uq5yy1K0ICCVTfA6XAZX5YJ0rr1BqkRQMKX0Fagspoee+zK5KnOGB+1qqbonxUK7N2lfY22IUoZgFhYzEErNCQXhn/f1ctj6mmsGxR89mVCtpPHU/8wS+7zpLQXEKhE5KffDKLvsYLWt7QokU1O3cVlo0M1jQ1SKE7sCyQPOyvjXtq03UxdlyeosZcmEWENLTcAyIn5bt8Yo9dJRxK8/wXjDn86Usgmninnw1huJr6C88D7NTMa8wKS+Jq5dP4Tjr9iqHRub6OPcdVdpF7WQn+g6tj7N/xL/E9vkYRsrU3DKD1pKxmyHROHnWPjFh1vl27KS1tiNKainH3Ubrm8ZzjRRyiyAUcV5xYR+m1lgi4kwv2e2/VTMNLiKQ69Eee/dWUQYdRfF4wtdzkCxEQNqF9gKNyYCsoiRbhIZ7of5Dn76UeWipptOd2+J0m+5a3YB4LdOZvRWgB+80jFJYM
 vI/IgJrL
 JFGMnxVy/yHglJ1AvPzwiblLpwCW4f5MrIy5xjrU7gIh8uOwj6Yp4zOGUGxman/5nJg6n3SCrxZaHQsktYDHkwW9mTlFSwrxCzBwsc/MVz6nNFWu5k4cvekHh0V9st9+/YFAs5KfB4Ia9uhcnEHndvKqCYXYuve9jPRvRUc7X9iXUFmf1sf/3rJk4fq8Lij1XL9+5vedWcs1qmAXFLty/cB+158ZHyxQ+7RNjrtCVouQUS8Fp8sYSizMfuISdMpLFTP3OeWM5KGBVBQfMm4P64YfVbBZEx9VffI2c4AaCmw5f3xFMoZ9oJKB6VcQPSadaClUKnnd91EWWZL6q79OcaoZUDe9LLyFo+KjHrs03OqRaV6XYWrSsk3s4S8cvqf3fMwrkiQoNmsg7gzqV+pd7e2zbCKh7VF6t26qNY9JeETiE+eABnNnpRbrnMXuzsy8ImlO5eLoZEHBHQTcTZw0tV67FXB1hCww2GipUFG3M0RCkpvlIbdKFdJ+WZpRws6wLOs3QF5t4mxGozWsbQzWzdNHAHbmgB3MUYWNEiCyRPp2scwieVxoJ/aE16Nx0ZBDvIpkw1Zb5Q7tSi1p2hcTySHSS/GOFe3wyooxW0kB22+SjDSclFX0Ingey54QS7btByJwcgHS0X3peA7VsEi9+pj0HiE3vctkrcl6kriM4+7rnn+9Buf1/99Al+qBX/YTkFBhFvRpjWcYbBOUKgqLIRaiFePezDKosk84p0E/9zOjrUfur0ho6deTJp40A9ysdLv2IKKOFEps5tuecYeJaYMGsfawjwHGMTDqhYysgT288MXzOWeJzUc3Ur3biY1gF8VQfz/4HTGbNfm2Hw9VLXaqgtSKWtVrZtZqBzDKh9qNewC0n5GTXCbhN6TNZX+qNFHRRAPuS/hkJ/YoGzV/TwF8MXdtZyEWTCHBDvdUVd8VfmHO6i1RkRdwGQ+sBROpZyFNhkL4jOX6Al3qJVndYnMYrVbvl
 3JnaZJ2/
 sY6/viDmLCgJRBhxsK1pWmNsVGiV0b/a0Pj6xBHDyYo5lr2uwrw/bfF5UKv3OWDUnUYt+skj6iF0iLuI0bEZ1xeiXyAyl9wjd/irT0PxYFGgrWSJ7HZkUcHZog/b5hs+b8ibj8zhNIOoX1PlcUI+KfTq29U1unPffpNBDEeUHZTncZf56W1hECuIfoYArkDUYJp/A4j2yvp+Z/UE4gvBSesQIm1qBCGYjX0aflzxJOo3kPh6eQTDssjg/fRaD7/YGSRd7UANXaeKYEcJG0Xmx+pI0x0kYkQUAFDRthtMoz38QRUPv/nSuRSdHy0i147Qxu5+DsYH1yZ0HKIbrTnGplPoIdLu1uFVw0DyTChlnbHi75ZKmjC8qguyDfO+vcRGQq+ZEg55Qb3Xi6SiTxO1or37EY7eoE9obW6alspJMSYFF3ECm89T2sJLA1lTHvKLlyD+gdf385jAeTQgfz9a0KkCspc45AJTfb0eDDlS2xI4DL9GrLM7JJy4cvUKTe8oM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:23:58, Jeff Layton wrote:
> Convert proc i_ino format strings to use the PRIino format
> macro in preparation for the widening of i_ino via kino_t.
> 
> Update local variables and function parameters that hold i_ino
> values from unsigned long to kino_t.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/fd.c       | 2 +-
>  fs/proc/task_mmu.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/fd.c b/fs/proc/fd.c
> index 9eeccff49b2abf57d766ce17fe47070c379ed2c8..936d0258d688be5fdc384ee5c4dfbb8fa0d19dff 100644
> --- a/fs/proc/fd.c
> +++ b/fs/proc/fd.c
> @@ -54,7 +54,7 @@ static int seq_show(struct seq_file *m, void *v)
>  	if (ret)
>  		return ret;
>  
> -	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\nino:\t%lu\n",
> +	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\nino:\t%" PRIino "u\n",
>  		   (long long)file->f_pos, f_flags,
>  		   real_mount(file->f_path.mnt)->mnt_id,
>  		   file_inode(file)->i_ino);
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e091931d7ca19d71f31699913d177eec0821ca7b..702b0f0433f91077cd0d0af4a07e9d67d9fa9a45 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -442,7 +442,7 @@ static void get_vma_name(struct vm_area_struct *vma,
>  static void show_vma_header_prefix(struct seq_file *m,
>  				   unsigned long start, unsigned long end,
>  				   vm_flags_t flags, unsigned long long pgoff,
> -				   dev_t dev, unsigned long ino)
> +				   dev_t dev, kino_t ino)
>  {
>  	seq_setwidth(m, 25 + sizeof(void *) * 6 - 1);
>  	seq_put_hex_ll(m, NULL, start, 8);
> @@ -465,7 +465,7 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
>  	const struct path *path;
>  	const char *name_fmt, *name;
>  	vm_flags_t flags = vma->vm_flags;
> -	unsigned long ino = 0;
> +	kino_t ino = 0;
>  	unsigned long long pgoff = 0;
>  	unsigned long start, end;
>  	dev_t dev = 0;
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

