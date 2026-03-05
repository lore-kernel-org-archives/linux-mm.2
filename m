Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ADEBF30924
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 09:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967186B008A; Thu,  5 Mar 2026 04:44:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93EE36B00A1; Thu,  5 Mar 2026 04:44:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ECB96B00A3; Thu,  5 Mar 2026 04:44:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 691946B008A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:44:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B8AC8C6B0
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:44:41 +0000 (UTC)
X-FDA: 84511524762.26.5C67936
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id D84AC140013
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:44:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SqrLTtrC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Cc2OmxUv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rIV3CSH6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T0y5uAwf;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772703879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZXMJnNQRQ5VbYUyas11IQhQ7OgF+JkPi1N0Dbj0ESVE=;
	b=7GyHfrkY81r7pcLOh5AKEZuEoxZvYfz3OG/Ys/iV5MA8gOnARHMhcogxJ4R6bDhsfWvdTr
	asL7ilh4a6Ll3krDKiPHUa/TBx/8YuH5AdYsIveWnTljFqqDuoO3Eqk5rBIhDKOVqgYp7f
	8c7JAN9JMlB4usmo3ZBJVLP2STkAelI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SqrLTtrC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Cc2OmxUv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rIV3CSH6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T0y5uAwf;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772703879; a=rsa-sha256;
	cv=none;
	b=sbY5KunVRhs1Hy258smt5XQWq3ojUsvXiTuJUHl+h+woW6NllAWU0v+fcQwbGCfo+pcu3Q
	y12+8YFNiuJXLOD1ZPPXWvqlQtBsSlNsld1Y8II0sWIhCNlHQQMT27FFLtkrz4aTRxo0r9
	dPNooG6LSrRS5Hkay9SqLXfb/eygjCk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 134903F88F;
	Thu,  5 Mar 2026 09:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772703877; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZXMJnNQRQ5VbYUyas11IQhQ7OgF+JkPi1N0Dbj0ESVE=;
	b=SqrLTtrCNukP+XjEFtaDk9s0jIxOzYsM9i2TX2l+ExhU0WbbNgdvw9SdCbFDDxeAamywop
	d4q97Ww1d6wcW1cErijrOGaMDee5tROvWE1f6wWFUC3D3nQVMV+kv551BmtxUMl0TW1T12
	euOE5BfRxamy2ZgcgdomfRrJbGj0HQw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772703877;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZXMJnNQRQ5VbYUyas11IQhQ7OgF+JkPi1N0Dbj0ESVE=;
	b=Cc2OmxUv2Yfy/axuUAbORGol01RqjJTtDBrCu/WYIedR+kpvukVQrlqX5Rae8AGWI7BLVM
	kO3vKs4/LRFdOyAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772703876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZXMJnNQRQ5VbYUyas11IQhQ7OgF+JkPi1N0Dbj0ESVE=;
	b=rIV3CSH6Dbl0N4NrCSYIAFgi2dT6//Mtk86mtDPUl7m5EMVkGH4kMp0PmgdHitf14gG8Xo
	Jtz+Ss4INn9j9fuj06PdU0hOt8zHJBcIQ5lMaTny40CilHiuEasa2dcgYwoQQfqEMTHF2l
	+heO68t0BlFSP+tNDpPD7lBa9HkSAIg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772703876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZXMJnNQRQ5VbYUyas11IQhQ7OgF+JkPi1N0Dbj0ESVE=;
	b=T0y5uAwfgp5vRY41dbKXfnBGTOqXPVvqQy5AVYpBBgsqFNtVLdWcDKOEO8PgP8kw4QkkOb
	YoOkDcryaPGVPIDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 012583EA76;
	Thu,  5 Mar 2026 09:44:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dv9AAIRQqWl5PgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Mar 2026 09:44:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B98A9A0AB1; Thu,  5 Mar 2026 10:44:35 +0100 (CET)
Date: Thu, 5 Mar 2026 10:44:35 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Dan Williams <dan.j.williams@intel.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Alexander Aring <alex.aring@gmail.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	David Sterba <dsterba@suse.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Ian Kent <raven@themaw.net>, Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, Nicolas Pitre <nico@fluxnic.net>, 
	Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Yangtao Li <frank.li@vivo.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
	Dave Kleikamp <shaggy@kernel.org>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
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
Subject: Re: [PATCH v3 06/12] ext2: widen trace event i_ino fields to u64
Message-ID: <bfltjtuvcxljfok7wqk4jgefhk6zeix6hbdwzaj3fel3j6z6l2@stzidu4vmlhu>
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
 <20260304-iino-u64-v3-6-2257ad83d372@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-iino-u64-v3-6-2257ad83d372@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: D84AC140013
X-Rspamd-Server: rspam08
X-Stat-Signature: 4yatca8w35t68cdn7rsms5gcgjukbquw
X-HE-Tag: 1772703878-60215
X-HE-Meta: U2FsdGVkX1+mKgU53nMjq53ZFgne5ILCkkJBeslYr0mKkvz5JOEO3dWmud0Ot+1wGIjlHA1VLoO1ZGtkwXoksI5U9VUMpFSUNVHV/vTIunTFxA7uni0ukrSZsCpr+tqTt7maZqnuYdq2b8eSU10gUdRuKWMFRYhVT4A5fBmqSYMQvIgTUyW7x1DqJ4CrpiClyzQD3cWZ5jvpwmV6wDmGNxugCMIiQ4Re+m/GdLMnPI6qz894agdW8fPmbTHT4VtH8Hd5U7p8BynYW70kKZ60Ar9VUrZh7HRmbCe7QBnPQDRqCfT2CNfu0HWQbHdCwi1/7E4YuaHm+k96Yjwsc6k3P61dcqU+e8NXQlDnOeIBDqtg+gaGDWeX1kAqawH7VgLp3OnmmRLrZHMhbOEHSDmSGM1HpGIvpfq7A5JfOCXLUTRQ6KfheBekh+a3OpxfmuIJs592OD/VBYF9nirpQ1mvSCC5B5M0UIjj6R3GBM47ja3PwBQd1olB0wWuMpzTnTQ78GInecEkw92KM+5gvNG7kGph7dvJchXVBIsUajyWwE9a4WLWim9aNPu647srKCvKd6Z/RNsMFxrczxTE+KZ5UcYFd3q1QzVk8qU6Ch4AaKBJgmdO+T1N43Or5iKfkgNXxHeHcP1MyC9SxTDWW2Bod9oR8QlcuIbq2GttKl4Hf8dRxdKVq0Ad1RGI+k4/cF88Ax11YkJ+rCUmm1y32+wk1TQP4vOHkQUOVufQxXrjVswQk2CZ2sHjab2Ui4ctE45NHpTCNCrUt3y84G1sv0iQycR5I21AoKqoiiJ5i5FRuCjMh/HC5kg4nUyga2C7BWYo40h45tyMd5lPnpMc6xduFCqjHtiBwpvcLonMCfinletX1kcqxJhgas0SElKBgXHP+5gUh/svUN/l40wjUNRJbuwZwS4BEtzyMSzlgvCp+XBy7aADxjSxSvALRT5Nq9t6wPQ7fu+9Hv1HDPpWelU
 nwhO1izY
 gddL0jUJMojldTj+XO2bxQWZVE2WSS5VxzAWhO/Mza6oFA1IcIUtiFCjNUfJZxDIekQ7ZqvK205H7xo2cbt0F9JeHgA2HOaoTU8qHwfAQyBjDSe84MRzBzeg4AniaI0csJ0k1Vu3Gzzhn0j323UUG8J0EtvWhP/VFu1ecDb4SOta5fMdbv+j4OoJAaoXljzzO6O0+U8aKMMeH7WTNbvzLLHkaV6GEAweRvowXi9eqavjHCUn3D4sKppwtCIJXj9YP3HT6dFQ3V8B4bAG4N9N5pvyyxwQHOXHT+Bp9ppaeOY7loRBLKRFZOOTgXrknSmovygrfAYcOf+/dbZS2F9aweFYltUlf4Es82cSWYDGeop1TeF+LycNEaqafhJ5ydsbjW0Q7S6dtPil7Wm82MQQDIXqlTtZTJ+z/02/vME9t4ZTnvl0cgq1lTHBFinwg8w5pXrPLbfJi/k/oRn7pS2Lm1pYEbTKQlptaBeVbacI4j2/6L+p4Z6jJf2x1dlGv2IwFBbjoY95gUs1JK+OhjxfjTMpeDuWZ3CvdM+mmF3OD3fYlvZT80zNj0d2lwg4WSaelNyMMR+xw/mcLQZCuoHhz44HDkI2cjFmni85zYIaSp+8Z/hpkyuSjg8Fjm/DSu2MvX+fBsEl4N4wNmxD19LLMzQrJiXm9vo3DJtiT0+qoX5RX0O3HHxYjOvnM2iO21xPm1fI+Bifq64UNVakhL8mIgnTY+d20RhPlOMjvxP6d8DHYy7WqexkYFcWbYrubozD/cNCpa6sr0moItzpzCgxS2xvTQBfEGujDovOPfg/jQJflIRs6xjv/FSeib8CMBldJeKUDEE/jeqP9NgNs43KV3uuySDFSBWfvJUsoTB5QVOdt2aTETEjYz0T06HQiuY6LDGA0OeX30DSQQFLoDQ9zq1dBUUz7IMIvGjGxh6423jdmop9X0XEJOa54jMNKtG68RJognkUEuY03w3m08AgjIwD1shCP
 /RLzQvND
 0waJe8NaH6yF9JSVXn4eQEivRH+dQYvSNY40TW+2FlbzZzp3gar8dj79A/iPTLLRuCYkb6jOUbgEsnkUxSnqivO1n/jdKI8yqdPGYtmq4b33MtpklkH3F0lW65wVHaicBFLeWGP8B0TW1YpyVg8pbxgQEFQxHl31KVmwpZelSVn+717n0V9f8nNwzhBSfCDm/Lqk9SsmKUodQWEPxFfAx62nDFAj0uteDLmAyYYB/KOKSMlBBP88coKOZgOpA6jDlGZB77YWwKqU+zxRYHbLr0ilAj1AJzfqsLXQd7oIqotOblgq8G5IXgBjYqLnnSHCqI6xxEprWz7XvVXgidwX+sYEWTu6xVUdGmyXebpEUEjRrR3FXyDGK/QrA4IRYr7NEhnP1uown8dT8w0D+1ULgmjSU3VrMMAy0VcEZqMUfQYDv3eKCkcMGK2UsfXRShrEn99xaCDp4zDeUT51LDpkPlba132d5Hh4Q2FktGhUz7tK7UUYAoN/MOBHTY76y9ZJVJRqEHEq8lA59ZUAcck9Gp49zBWMJYpsLRuu0cx/YStWsjQ6l/kVhyKQa58LOeAC80od91l/qudgQmJgL3Vd43lWs+cCza1yPDlvY8O8sjadpCsI+mF+MBicDqAnqkxTOd92HgMHlDo+CEMMwYeGLAUSE2puPW7yg5RTczdJr4ISZsiH/R+PN9/eLj9m/5cB/3WvMZbZsMcLQKEOCu9Cc9gdfqWSoY63JpL7zSwvqEauj2UqWM2t2N834l9WOChS6rP3nCzviIp/FXccpZnF1HdZKwYOne6SoPkqjyGQOBZ7EOsjPb6cpNVi8lo4dmRjo+Lb/jAe9zglO7eBAA1OuaNqeYlB7edauF+JrUWVJCcSA+K5kqPCnaMcN5cLx2pI9TSmBk58wrRTMEP+rEFJScp7VHBRm/p3qSYWIPe/gtxjMBxwsuKmDhHcoVtGTbNHy10SQ8JhSA92LIyyOPxT9dArbRuyC
 vU2h2fTV
 GJ+VYzFI5RoLLLajfDYLTuHWbHqhHxDeXuW0sCfTHfCua9p0S45yWyz8Xm5A1c03giY1FtY383MDCYoTdIv6jlwk5R7J0VDvPwTA3JHRK4p+Uwir6fR/DDYYsx2xuZ96vLr6hYakh9kRUlDlk4GoI2JKc2Id13oS9BMlhKKU3yiE5zOaCl2EGwyxD92PMSRMmKREGr9ACQpUA2zTe3CNUVXrOZcRss1ZZD/FTW/8yUG0YBWfx/Be6jLnYO7kAGu3ukqYFmyO3ss9S6EyyuYo1t3Gtml7ORDZFuGP1hV5kqwIcQK+zwzS2IoIGe+PnfuqKLUaMXx1X971TrP/0G3ES8FRW+1TrCDs9v5mj6qgZTnK8YAViPMcUnkq9YofFO7Pv6tCU9507Uq6Gzbbl/ocwhG80WWnPFfJg9qAlRWxp3bQ3ZwrJENly4YKOkUW88NhXVTcXLl734Zr5KgohXyYUs5wJ7vME6Zq87V0o1Cpf5CzVQk8EP9otyIV6dl7xs83IIp5HSYX/oMs1UDC5g/yH/Kh+h3Bi63zE2OdyqAakB23FSPjuts3JG9LzDqhTU08xsYmPY/YbYFYQbHTCJCK/+fEG6kag3p+YslzQbrloXOMhn8Mx8fPLvWiGeYNRtL6rByaVtsN1RwkoLxLF8cG+T1+CJdfos/Z0/p3DmPZFv8Hny0+6OvbzT1SrftF+BzXbZ0KiYVBQ6YJS0ABwYZOQt10GGbmv1Ho61N712pATyMNl+p6qtvoUlIlfQnhPtVTzHfcl9tCXVWhv4gmChEtZExBLddWaPKBo5Z9PPmbSRDPGCziVx0ajYAIGChykCyk5mNr0czWaD4TtM62P55M8N90DH9EyPf0W0D/ChPPVD2FzXBi620Q9K+LLjm7a25b6GpzguPmDfgoI4rYieghKM+tESxJRE8lV0I3IYpFIY3xjoBK9z7qskyWbEbYTosVEd9oAzW0XeVaeBSB/TtLhXTzLRARX
 dyzxakTh
 S3KzQcfcWBWFWC8q6kFo0oTVtGU75RDAo7Z58k+//s0sfFN9EkaoybPY4Et/jjJ7jnQH8bEQUOW7d3fvcHPKGn90BCVj+noJNf0AomcIIKZFBXAtwn8D4s19LN8x0z3Wfw1/dXWVXWF1u5swxgwCOGVG0iwCsjjAV1PChrpssow6m6aR1ktmiZfSgjmMqob+meyQzZWsPlM4XiRF4nvAxiAf7uIQD6r+KVnHNGqQYpvhZRGsFXGu1zvZ0biTmY+XudWOmHETvORPjWl/nV2BmyRo54Vx313ciFHkcmmX8GGb0WlQMnaPhYlTRJqhteMG+q3IEwidaMHcAhOpHK6ks8rRLKicyDkaBKSznj2TYaD5StXeIVhJUbB/un+tDHvEu053f3fS0qbBUrtY3sjxa+221SzqhxcI9DTiFCLaBnhTvSCi1qXgBmWECiZlb/NcMutoUc07btThbeFiWzFDThgWGrwWAM3/bs+jRF+M+PnmwizxZPmsoi4MBJCBgGnvM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 04-03-26 10:32:36, Jeff Layton wrote:
> Update ext2 trace event definitions to use u64 instead of
> ino_t/unsigned long for inode number fields.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/trace.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext2/trace.h b/fs/ext2/trace.h
> index 7d230e13576e78713846248eeb21fa0770130540..0922c0e6aab8531c9f5646d86758e6e3595754db 100644
> --- a/fs/ext2/trace.h
> +++ b/fs/ext2/trace.h
> @@ -13,7 +13,7 @@ DECLARE_EVENT_CLASS(ext2_dio_class,
>  	TP_ARGS(iocb, iter, ret),
>  	TP_STRUCT__entry(
>  		__field(dev_t,	dev)
> -		__field(ino_t,	ino)
> +		__field(u64,	ino)
>  		__field(loff_t, isize)
>  		__field(loff_t, pos)
>  		__field(size_t,	count)
> @@ -31,7 +31,7 @@ DECLARE_EVENT_CLASS(ext2_dio_class,
>  		__entry->aio = !is_sync_kiocb(iocb);
>  		__entry->ret = ret;
>  	),
> -	TP_printk("dev %d:%d ino 0x%lx isize 0x%llx pos 0x%llx len %zu flags %s aio %d ret %zd",
> +	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx pos 0x%llx len %zu flags %s aio %d ret %zd",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->isize,
> @@ -57,7 +57,7 @@ TRACE_EVENT(ext2_dio_write_endio,
>  	TP_ARGS(iocb, size, ret),
>  	TP_STRUCT__entry(
>  		__field(dev_t,	dev)
> -		__field(ino_t,	ino)
> +		__field(u64,	ino)
>  		__field(loff_t, isize)
>  		__field(loff_t, pos)
>  		__field(ssize_t, size)
> @@ -75,7 +75,7 @@ TRACE_EVENT(ext2_dio_write_endio,
>  		__entry->aio = !is_sync_kiocb(iocb);
>  		__entry->ret = ret;
>  	),
> -	TP_printk("dev %d:%d ino 0x%lx isize 0x%llx pos 0x%llx len %zd flags %s aio %d ret %d",
> +	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx pos 0x%llx len %zd flags %s aio %d ret %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->isize,
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

