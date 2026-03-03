Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D1F7EC1433
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1AA6B0135; Tue,  3 Mar 2026 06:26:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C336B0136; Tue,  3 Mar 2026 06:26:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FCE76B0139; Tue,  3 Mar 2026 06:26:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7D16B0135
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:26:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34E7D1BC00
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:26:19 +0000 (UTC)
X-FDA: 84504523278.05.8977C98
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id BDF7B40002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:26:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nkwxPU6f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=agjLNWMi;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nkwxPU6f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=agjLNWMi;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPu8XPuDlU1g9pC+BD612SKMgab6QY4hhTylugDlyzw=;
	b=YBmE4HhbYbRY4hqZamSlX8wbAtze3nlAm7f2sooZeS3BdHZ4IoCIJsarKOGT7LyIm6SDpf
	p4ZgPwnBUZumYNcglaszfvcM8E8qVhnAdOUrBo1wC7unaA3NW23digFmpTi3Bal4mfPvVE
	I+YWSWBNuHJ8kdOLE8WeIla7u44ErAw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nkwxPU6f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=agjLNWMi;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nkwxPU6f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=agjLNWMi;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537177; a=rsa-sha256;
	cv=none;
	b=tcFIzvR0FufPT1t5aH5l9InZ6c4Uci66b5alm5sOpv3vVQvbxombmt+wo8dEuLuDKxX71Z
	+wcCZmGVpE7SRO2kKDhMRP4fBPIB7/b+WxOZyH+ang5ZouUTJOU+CH6lBYBP3YutsCnU0e
	JfLBdQapJPN7uYE+bPzetHWMMFjLe5U=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4C4F13F875;
	Tue,  3 Mar 2026 11:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nPu8XPuDlU1g9pC+BD612SKMgab6QY4hhTylugDlyzw=;
	b=nkwxPU6f/8r94zxGc4RXWbdDzA6AH42XX//Xsss6YCxStp0x2EcOr0GsBuSmRyKCliLMNC
	33kSvTr/ut+H6ayhMqYeTdK3NFYWWb4fo7LpP8U5eO3+VvW3rrMLpyl6x9zanAM0NlTtEe
	35vwx1OUEh1rL8GgkX/OzITY8DEMdwg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537175;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nPu8XPuDlU1g9pC+BD612SKMgab6QY4hhTylugDlyzw=;
	b=agjLNWMibMrxLGF3Fa07k6aUsfYIAWz4Au/CjhQcIFoZ6f1qcU8rerzkKEteqvTexnsZJk
	/gGscWX4ng0HaUBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nPu8XPuDlU1g9pC+BD612SKMgab6QY4hhTylugDlyzw=;
	b=nkwxPU6f/8r94zxGc4RXWbdDzA6AH42XX//Xsss6YCxStp0x2EcOr0GsBuSmRyKCliLMNC
	33kSvTr/ut+H6ayhMqYeTdK3NFYWWb4fo7LpP8U5eO3+VvW3rrMLpyl6x9zanAM0NlTtEe
	35vwx1OUEh1rL8GgkX/OzITY8DEMdwg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537175;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nPu8XPuDlU1g9pC+BD612SKMgab6QY4hhTylugDlyzw=;
	b=agjLNWMibMrxLGF3Fa07k6aUsfYIAWz4Au/CjhQcIFoZ6f1qcU8rerzkKEteqvTexnsZJk
	/gGscWX4ng0HaUBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34F173EA6E;
	Tue,  3 Mar 2026 11:26:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5OvoDFfFpmkcTAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:26:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E0715A0A1B; Tue,  3 Mar 2026 12:26:14 +0100 (CET)
Date: Tue, 3 Mar 2026 12:26:14 +0100
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
Subject: Re: [PATCH v2 040/110] ocfs2: use PRIino format for i_ino
Message-ID: <ssizzrk2zdfrfzppx75xewimgzg5rd3ofunrxa2vvrh5fmroul@rntxparm3irs>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-40-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-40-e5388800dae0@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: BDF7B40002
X-Rspamd-Server: rspam08
X-Stat-Signature: qznubik5k61puij37kfeubisx989ypd4
X-HE-Tag: 1772537176-78441
X-HE-Meta: U2FsdGVkX19jcVVuAJ30VFfupGZ8PMPBUrDMdRhwpx0CDEKZd1B0hdAvk4Ij0k5wGSY8GqJWWZeJcwIYRqBvcQFvOIHxbNEWjKmb+9+uSWGl1JRrgah5PESx+Psb9yhroGV1rF3Wx6UF7d7DyiG1zYGZK7QfIKxOPIYeF7icnwyivPO7AtrfC8WqJhAGCklYJ3q6uqqrmZChEkIr4G9WqjrIOD8Q2RIqiiFP36Pbx3t06rVFvjwr1/lhJdcZrJm9ci5pklhXvgVHIZoyrjJ9zBY0NYZ9kWcLB24/JzKjMXSAKo/WQp9Nu3cUtJEP8wf5FyxZaUH263Iex6gPoptqyOJdRGJ/zBxGH3ZSxu9eZMjFmImUlW5NOrI5DJ2x7cdHSIk1sft9zYX4rD698K4ehXZ+RsxFZsvXIT3wiyR0a1QslzCb1UsWJeuBwGmU9Me1Rl1y7khBiVoCFvs8UMmUAobAiKSwBRlhl0dRFF+9Fsyiv/BLmJZ63YHcbMPAYHNfMDTLdwlr/PzLArQS1DhxPm3VVNhEj57AeAu1CCoAOnin3R3lL0ySUPhlKJIkmNr5yxZQIevyAppuqPKpLfkCixsLE+rPwH84UHxsnfQzMfJzKes0zFMk1b2GavyJyk5IYmrdmNkr63D6MqzgqbhHGggUcBW1mGDENCAr34r0ub4P9MDHHoZSE3qcwhsAg3xnqqkF2uPACaAa8yBQtmZSDX2lX7olOULUqWYgIm6shDMvHgQrLfmHSIx5hDrEUsCI3gFuNwu8dWLQm1CQqCfgvo7iLKNk9fPVwcCvbJSB6ASlii7pX07mTLn/FjmFBY/rFLTlx4F4ChAOFQ8poQLJrqpj5XKB7v7ZMSA7EMLTgj1oGE5L+ilsW+p3yvrEDzianboJx0j+Y+1EWCKLO82TfJySBYBEmuCS9O61YXrWAZYdI+NDoo6k3pOY/cr4lkCk1yxTjZM07208BzkanP2
 PbuuNpbc
 bxDgpaDvT0o2EyilgtRftKz0YS3YSzNqZPLV1EDzc9XhwQ/ZvU3iU4QCWZvd/3rVU2Kv9y5llOJOF7GC3C5t4yXXJ+PB3R7ajg6Z1HHzbeZfCM0Rl/2FSCpvbbaSoVBvouGEHxLOpFbqb0yOYaA2b3a9360+1PN6EmQhqKdVh2qdFEqMQWfkIqo249C4KRaBHecSvbr6rdLDoq3ANaDBGmG5aABB3j7xrL8+TDRW6/hWz3G6wMKWfb60GpI4NL9nijzIfWSqAAxJBEsn0y6Z0XefElBxvDEV94S9WW9+ugrU3JWxouywz3OAvSAxnPg+X5amAHj0v0krNwjD/6S3JmzUJMHMYk0yP86gI/PykG4+QzJewcLMmHdN17WutO1VMWnY/hNVZeXbpWplBs2Y0H5Timq2ibQJhZyj8keBK8UmmslXVDJopRf4hHSwbQnSgDUhKb52CokxPPhmeLx184kJ9fmCgaYn9QNH3IY+esiF9heKnXxN6Tsj65O3LNTbLunQS0LpqpmaP3KlfKn8HV3EPU+Bg6NPWs8lbZIgzDdnUTxpjCelAoVtl7W0ufYQOeDdap4RfFOzNg3cQmcXNWdjRCOSHzZLQvow4S6Cu/ExvL1Oy715jYa5mwjXmQeJfTEDE7zOjyjhCzIDbia3C4UdKRHNnqYuoM/xkswzyLAwqaVR//ZOGMKbT1icIov410P4srmUH7uuJtZUBoO/yZ7121rS4KebFl9q7Xg4aDPpV22by1h6myz/efNebNpIOKy5kpcNvCpV8/jsI9GxyPfXisBQq/o/cV3btF+GA5ODWft70SPt+cVNVIv/kn0hE7UuDh2ksHJ0yuVSmJwPfguvglRAlGf9R4GVs8MtwFlbw7hOvbYvPYkuYqtN3IHjYBWJjmNE9+Wd815CYwnS0sfUgs9YsTSYyYhuQfYXI4rwT7LWs1gtfltrqNcYhtui7S/dBBpSWz6rEBETPMSD2I7NkGPy4
 YdgyUZEF
 MstA5bYFzzUT79oXZL07xAtDOBROONto+j6qz0uH7Ld2kRRsRwY4AbwQyYhgpkpP4JxbnKI2izXJ8LEd0J3Bqy+mrkZjZZBCfwnkAF83tWI0YYKf/6QvxF3ZnSJzWv5UDOQNjp4U0MMQDbtw5Q1VfVKzQwtN7FwWlpI51O6T1o1LJRCOGyqQ9Mpqs88hqyaBVu3YOsRprcTfCFLLuXBjsdzef4GxS4CWaJLsxAw4+V8Y/ekB8R8cVqLDrOloaZZ1jZYEPxO48LOFE19nGVDrG/Ff5mioF6ft5FyJ9mG5ZOX8il6UVNDwRyDQu64Dh2ImRVWN6aMP+o7WVLLgP0b/f8REC2NSEfwvMqKNvebGpSg5BqjrP88Y9e95v3Skm44pRFoNO7i9L7o5kkpq6DRWhgT8syEGTGRId7XgP1J4e4yl8saDoJ1XAhxumO1UmaIHlaj5aj1mYN7f3tYUkl7ngDBgsvLPKelh6tUkbjXu6begSoi0el81sOzAD01Z9oXEWfiMHLEuP3hsIthFt2Vui+iPOqiLjXaeVDgUrf6jS/foIEqKB0B8szRH5yKTucIBSHJHoTEJHey4hC8h6XStH5MP67mj0RT7v2z4GFas63pEeAcPkVBIrTjGqxhLHRAY/9FrxfxHNtjyIuIHZx4c9BtdUTST7Q/4vafA4MeoJL0YLiWQaopb0TFgdZu+tQHRAL+YOJnFcYSbwKecjxJgmhADbOMYrH3v3nVmRUqE2GEzwJbe2qZMIcxmOgo3aNA6sD1EYiWUOXfWUvPWXMYVSEykceM9G2wWTa5O/xKpwQ8f9T7G2iHT43VpcFJtVnzAKqi3/ExDxLcSFwUqFp18xRtbRnka8RgzRaNiXQt1JlykeEbxxf3QyB0JUnh1JAjwyRKznW8mvXEdh+6ywuo83PTicHjwtWnCFRNOpc2Hg8k2ZneDodaezWdX2eIGuU8SAHHOyRueuIRPb69iEKoBQ58AKS6M6
 2jN3ns/G
 x0W4ES14YySbMvYy6snBnmAeLLa+M+94VQGsV15KcrS0+XkmGMhLWN1yrpVNz3jH0m3FBWyrbf1bBt58u1MV49XPukFsUD1vZcpugKPeVLJIgKCOIyseDXP/aHS69TL7T12SLqlR8Im4ahxaUckPoZ0GUwJi0wYpfLSfyyX8Ug2YYs4q2OkrSUSHAH4jlRfbGfCWSVFCuKea/fTewOSlsHq4Hmej16OKZRPRmnJjYJ0HgCJ7oOVVAG/4d+MdPZzLNSrPxv3ACBC7g8fqmKuhlieju7UhOyMlBbNqAZhjASo1Te3os8BLqr+rmBFgo3wNOUtd6bW+p69/o0JwTPVhGOk2bl05AFbng/ng2RmaZ1CcOSAxNaa/8sDHdKBwZo+vx3opTo9NQpOHVGQcUgPg9rTnZRnXP43qciMfcRuNTJS4dtcltccnDKcy2ODMpYb7JW6bSCAWZEcVr4n3kBTiBqmT34NAHebYnXy985NN0IvgzBcRZLNDciALvESN9xbRVQibKs9SPAEL6jj3pKtrCaYqzEE35K7y3Z9G0h1B+alqglDfKuuz3WEdcGuSoNmfzH9nbWb2vJUMjZuAuE9eGHrkYXidtHjVkuqoqapze78UB131DyicIzo/oy4hw4oRKUvBxonCvRbzaxvFRZM9q+j/LfHT47JEwt8HS54D5lMpecNArjvlaeSkPI8FRkv2AXIBccn27qwEXucKSBKdiUAHtW4HXjnN4+33U24nZm6G8dmraOWipwTA8nfv55jPBv9jmmN/z1Xn0zj+xkeFp0jQSdD+pgr9dPyX232Np6kfRApfMjFkqoNjltoLkipl5SW6ZY6M6VZeCgo+zcNYvJ9RrrBnK8Znp9DU4Su8N65ct1kWeCv2aaeBTtloZodM87/8bBXIRsUQXqQrtvFMz16Vy+Kxoz17+cmU+uKXLkjvhmdOQBKcCE4VeBb0d56EVtiACExS0SEVeDFDUvYk8aEt3XGtP
 hQspYvKd
 Wme32jSZRqTxDgyqCzoS4e2EHTHvjXq3Cqt0aQuCQr8JT3LmjourvNLpYynr2K0Qv/pRS7YDiWb+Zn9fTUZ2MiaUZtmTBG7V9BjibDyyzWmqT6Psb18kWfOl5WOwboCoLaGl9zqYmXobqACl6a3EU44KhlXX5encVbspm1LNU1r0R1FtBM1J7B6yxr5EjlQt4ukGqB/N6CN6SSsm7Ofy+LFaea6mFMwZM7eMzEF6Ky3JPluN+yC14flYByJil1amMG9ox6rsx16haNDfdqQ/VNGRoSdXaXbEyFVA14w1CTZcFErDeirFGR15omLTg3x2SZ0df6oNPM2PFi5C+ogLzQZujeJoT0rKG6djyXgNeVkF9CQ5tnl/nRxDYbJqT0tKFkx3hnchAjndXldlUjf3EDQfvFishyrgx262pP0dWBYH1Qmhzw0B4YIePfp+e9l7sEgwca7ex44qoYR28i+REUEeImm3NgbAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:24:24, Jeff Layton wrote:
> Convert ocfs2 i_ino format strings to use the PRIino format
> macro in preparation for the widening of i_ino via kino_t.
> 
> Remove now-unnecessary (unsigned long) casts on i_ino.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/alloc.c        |  2 +-
>  fs/ocfs2/aops.c         |  4 ++--
>  fs/ocfs2/dir.c          |  8 ++++----
>  fs/ocfs2/dlmfs/dlmfs.c  | 10 +++++-----
>  fs/ocfs2/extent_map.c   | 12 ++++++------
>  fs/ocfs2/inode.c        |  2 +-
>  fs/ocfs2/quota_local.c  |  2 +-
>  fs/ocfs2/refcounttree.c | 10 +++++-----
>  fs/ocfs2/xattr.c        |  4 ++--
>  9 files changed, 27 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 344fd4d95fbc8bd7a749e9d51d31b5682ff030d0..d7703549645b548d9f5d77b2214a9a7c0af0ef6f 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -7318,7 +7318,7 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
>  		 * to check it up here before changing the tree.
>  		*/
>  		if (root_el->l_tree_depth && rec->e_int_clusters == 0) {
> -			mlog(ML_ERROR, "Inode %lu has an empty "
> +			mlog(ML_ERROR, "Inode %" PRIino "u has an empty "
>  				    "extent record, depth %u\n", inode->i_ino,
>  				    le16_to_cpu(root_el->l_tree_depth));
>  			status = ocfs2_remove_rightmost_empty_extent(osb,
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 17ba79f443ee736cb5225702c57d13f4019f3c52..aea35b1c9fa3ce7327672c1862d0d1201c895c40 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -137,7 +137,7 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
>  			      (unsigned long long)iblock, bh_result, create);
>  
>  	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
> -		mlog(ML_NOTICE, "get_block on system inode 0x%p (%lu)\n",
> +		mlog(ML_NOTICE, "get_block on system inode 0x%p (%" PRIino "u)\n",
>  		     inode, inode->i_ino);
>  
>  	if (S_ISLNK(inode->i_mode)) {
> @@ -2146,7 +2146,7 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
>  	    ((iblock + ((len - 1) >> i_blkbits)) > endblk))
>  		len = (endblk - iblock + 1) << i_blkbits;
>  
> -	mlog(0, "get block of %lu at %llu:%u req %u\n",
> +	mlog(0, "get block of %" PRIino "u at %llu:%u req %u\n",
>  			inode->i_ino, pos, len, total_len);
>  
>  	/*
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 1c8abf2c592caacbe734d49254b04d507925c9d1..eecb2b1d2ec17fb4b3f09abb9e168d2f28f9b420 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -794,7 +794,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  	if (le16_to_cpu(el->l_count) !=
>  	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
>  		ret = ocfs2_error(inode->i_sb,
> -				  "Inode %lu has invalid extent list length %u\n",
> +				  "Inode %" PRIino "u has invalid extent list length %u\n",
>  				  inode->i_ino, le16_to_cpu(el->l_count));
>  		goto out;
>  	}
> @@ -812,7 +812,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  
>  		if (el->l_tree_depth) {
>  			ret = ocfs2_error(inode->i_sb,
> -					  "Inode %lu has non zero tree depth in btree tree block %llu\n",
> +					  "Inode %" PRIino "u has non zero tree depth in btree tree block %llu\n",
>  					  inode->i_ino,
>  					  (unsigned long long)eb_bh->b_blocknr);
>  			goto out;
> @@ -821,7 +821,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  
>  	if (le16_to_cpu(el->l_next_free_rec) == 0) {
>  		ret = ocfs2_error(inode->i_sb,
> -				  "Inode %lu has empty extent list at depth %u\n",
> +				  "Inode %" PRIino "u has empty extent list at depth %u\n",
>  				  inode->i_ino,
>  				  le16_to_cpu(el->l_tree_depth));
>  		goto out;
> @@ -839,7 +839,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  
>  	if (!found) {
>  		ret = ocfs2_error(inode->i_sb,
> -				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
> +				  "Inode %" PRIino "u has bad extent record (%u, %u, 0) in btree\n",
>  				  inode->i_ino,
>  				  le32_to_cpu(rec->e_cpos),
>  				  ocfs2_rec_clusters(el, rec));
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index 45cce261da65cab7ef48b5b88c0de5d41fa57615..e96c1c574ff7dc3dffad58ce8536b7e337d3f6fa 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -123,7 +123,7 @@ static int dlmfs_file_open(struct inode *inode,
>  	if (S_ISDIR(inode->i_mode))
>  		BUG();
>  
> -	mlog(0, "open called on inode %lu, flags 0x%x\n", inode->i_ino,
> +	mlog(0, "open called on inode %" PRIino "u, flags 0x%x\n", inode->i_ino,
>  		file->f_flags);
>  
>  	status = dlmfs_decode_open_flags(file->f_flags, &level, &flags);
> @@ -170,7 +170,7 @@ static int dlmfs_file_release(struct inode *inode,
>  	if (S_ISDIR(inode->i_mode))
>  		BUG();
>  
> -	mlog(0, "close called on inode %lu\n", inode->i_ino);
> +	mlog(0, "close called on inode %" PRIino "u\n", inode->i_ino);
>  
>  	if (fp) {
>  		level = fp->fp_lock_level;
> @@ -242,7 +242,7 @@ static ssize_t dlmfs_file_write(struct file *filp,
>  	int bytes_left;
>  	struct inode *inode = file_inode(filp);
>  
> -	mlog(0, "inode %lu, count = %zu, *ppos = %llu\n",
> +	mlog(0, "inode %" PRIino "u, count = %zu, *ppos = %llu\n",
>  		inode->i_ino, count, *ppos);
>  
>  	if (*ppos >= DLM_LVB_LEN)
> @@ -301,7 +301,7 @@ static void dlmfs_evict_inode(struct inode *inode)
>  
>  	clear_inode(inode);
>  
> -	mlog(0, "inode %lu\n", inode->i_ino);
> +	mlog(0, "inode %" PRIino "u\n", inode->i_ino);
>  
>  	ip = DLMFS_I(inode);
>  	lockres = &ip->ip_lockres;
> @@ -490,7 +490,7 @@ static int dlmfs_unlink(struct inode *dir,
>  	int status;
>  	struct inode *inode = d_inode(dentry);
>  
> -	mlog(0, "unlink inode %lu\n", inode->i_ino);
> +	mlog(0, "unlink inode %" PRIino "u\n", inode->i_ino);
>  
>  	/* if there are no current holders, or none that are waiting
>  	 * to acquire a lock, this basically destroys our lockres. */
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index d68229422dda3423971d7ab0e9a4335acab8b344..3cf93a08f7a8946810ccd2de246be4d07a23b53b 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -291,7 +291,7 @@ static int ocfs2_last_eb_is_empty(struct inode *inode,
>  
>  	if (el->l_tree_depth) {
>  		ocfs2_error(inode->i_sb,
> -			    "Inode %lu has non zero tree depth in leaf block %llu\n",
> +			    "Inode %" PRIino "u has non zero tree depth in leaf block %llu\n",
>  			    inode->i_ino,
>  			    (unsigned long long)eb_bh->b_blocknr);
>  		ret = -EROFS;
> @@ -427,7 +427,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
>  
>  		if (el->l_tree_depth) {
>  			ocfs2_error(inode->i_sb,
> -				    "Inode %lu has non zero tree depth in leaf block %llu\n",
> +				    "Inode %" PRIino "u has non zero tree depth in leaf block %llu\n",
>  				    inode->i_ino,
>  				    (unsigned long long)eb_bh->b_blocknr);
>  			ret = -EROFS;
> @@ -437,7 +437,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
>  
>  	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
>  		ocfs2_error(inode->i_sb,
> -			    "Inode %lu has an invalid extent (next_free_rec %u, count %u)\n",
> +			    "Inode %" PRIino "u has an invalid extent (next_free_rec %u, count %u)\n",
>  			    inode->i_ino,
>  			    le16_to_cpu(el->l_next_free_rec),
>  			    le16_to_cpu(el->l_count));
> @@ -472,7 +472,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
>  
>  	if (!rec->e_blkno) {
>  		ocfs2_error(inode->i_sb,
> -			    "Inode %lu has bad extent record (%u, %u, 0)\n",
> +			    "Inode %" PRIino "u has bad extent record (%u, %u, 0)\n",
>  			    inode->i_ino,
>  			    le32_to_cpu(rec->e_cpos),
>  			    ocfs2_rec_clusters(el, rec));
> @@ -561,7 +561,7 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
>  
>  		if (el->l_tree_depth) {
>  			ocfs2_error(inode->i_sb,
> -				    "Inode %lu has non zero tree depth in xattr leaf block %llu\n",
> +				    "Inode %" PRIino "u has non zero tree depth in xattr leaf block %llu\n",
>  				    inode->i_ino,
>  				    (unsigned long long)eb_bh->b_blocknr);
>  			ret = -EROFS;
> @@ -580,7 +580,7 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
>  
>  		if (!rec->e_blkno) {
>  			ocfs2_error(inode->i_sb,
> -				    "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
> +				    "Inode %" PRIino "u has bad extent record (%u, %u, 0) in xattr\n",
>  				    inode->i_ino,
>  				    le32_to_cpu(rec->e_cpos),
>  				    ocfs2_rec_clusters(el, rec));
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 03a51662ea8e79f7a64fcd320b974f954b2ea8bf..c3076b450de3599291c386ceeb8b2d26e8680904 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1196,7 +1196,7 @@ static void ocfs2_clear_inode(struct inode *inode)
>  				inode->i_nlink);
>  
>  	mlog_bug_on_msg(osb == NULL,
> -			"Inode=%lu\n", inode->i_ino);
> +			"Inode=%" PRIino "u\n", inode->i_ino);
>  
>  	dquot_drop(inode);
>  
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index c4e0117d8977807dd6f0f4df64e1ddf72a62ea09..269b0f27d5679aba317059b245ee4bf4f5580eca 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -471,7 +471,7 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
>  	qsize_t spacechange, inodechange;
>  	unsigned int memalloc;
>  
> -	trace_ocfs2_recover_local_quota_file((unsigned long)lqinode->i_ino, type);
> +	trace_ocfs2_recover_local_quota_file(lqinode->i_ino, type);
>  
>  	list_for_each_entry_safe(rchunk, next, &(rec->r_list[type]), rc_list) {
>  		chunk = rchunk->rc_chunk;
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index c1cdececdfa4ef51a1bd3a5addad734b324b92c0..1586c42fdabe70056bf7f103d583dd9000fe9510 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2341,7 +2341,7 @@ static int ocfs2_mark_extent_refcounted(struct inode *inode,
>  					   cpos, len, phys);
>  
>  	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
> -		ret = ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
> +		ret = ocfs2_error(inode->i_sb, "Inode %" PRIino "u want to use refcount tree, but the feature bit is not set in the super block\n",
>  				  inode->i_ino);
>  		goto out;
>  	}
> @@ -2524,7 +2524,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
>  	u64 start_cpos = ocfs2_blocks_to_clusters(inode->i_sb, phys_blkno);
>  
>  	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
> -		ret = ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
> +		ret = ocfs2_error(inode->i_sb, "Inode %" PRIino "u want to use refcount tree, but the feature bit is not set in the super block\n",
>  				  inode->i_ino);
>  		goto out;
>  	}
> @@ -2650,7 +2650,7 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
>  
>  		if (el->l_tree_depth) {
>  			ret = ocfs2_error(inode->i_sb,
> -					  "Inode %lu has non zero tree depth in leaf block %llu\n",
> +					  "Inode %" PRIino "u has non zero tree depth in leaf block %llu\n",
>  					  inode->i_ino,
>  					  (unsigned long long)eb_bh->b_blocknr);
>  			goto out;
> @@ -2662,7 +2662,7 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
>  		rec = &el->l_recs[i];
>  
>  		if (ocfs2_is_empty_extent(rec)) {
> -			mlog_bug_on_msg(i != 0, "Inode %lu has empty record in "
> +			mlog_bug_on_msg(i != 0, "Inode %" PRIino "u has empty record in "
>  					"index %d\n", inode->i_ino, i);
>  			continue;
>  		}
> @@ -3325,7 +3325,7 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
>  	if (!ocfs2_refcount_tree(osb)) {
> -		return ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
> +		return ocfs2_error(inode->i_sb, "Inode %" PRIino "u want to use refcount tree, but the feature bit is not set in the super block\n",
>  				   inode->i_ino);
>  	}
>  
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 42ee5db362d3eb6df886d6721dd7398b8aca8cdb..74cd6dd57abf71a69adef18863d057e48496ccfe 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -3741,7 +3741,7 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
>  
>  		if (el->l_tree_depth) {
>  			ret = ocfs2_error(inode->i_sb,
> -					  "Inode %lu has non zero tree depth in xattr tree block %llu\n",
> +					  "Inode %" PRIino "u has non zero tree depth in xattr tree block %llu\n",
>  					  inode->i_ino,
>  					  (unsigned long long)eb_bh->b_blocknr);
>  			goto out;
> @@ -3758,7 +3758,7 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
>  	}
>  
>  	if (!e_blkno) {
> -		ret = ocfs2_error(inode->i_sb, "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
> +		ret = ocfs2_error(inode->i_sb, "Inode %" PRIino "u has bad extent record (%u, %u, 0) in xattr\n",
>  				  inode->i_ino,
>  				  le32_to_cpu(rec->e_cpos),
>  				  ocfs2_rec_clusters(el, rec));
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

