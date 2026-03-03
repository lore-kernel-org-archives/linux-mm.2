Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D195FEC1430
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 019E36B01A6; Tue,  3 Mar 2026 06:35:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A7D6B01A7; Tue,  3 Mar 2026 06:35:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89906B01A8; Tue,  3 Mar 2026 06:35:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C630B6B01A6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:35:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3612F1B6BFF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:35:32 +0000 (UTC)
X-FDA: 84504546504.22.5B1FD59
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id DD479100003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:35:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rkS+wniN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5n838WT9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rkS+wniN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5n838WT9;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZCu6t8s/sSBnbJHK1VjX/jyRjvJ6SV7S5hUeXBhK5U=;
	b=13hsdErXMvO/NVOxAh9IXk2eZCDZ4gWQKvVw137ABlwyNEWA56GM8g8NEyhHf26xeAH+bt
	Fo9IPYOdQGk9OLf1IDI+qjF3dC7cViztFCSVs8L2dLRJtBh5jnjFpiQB3ejt64u8lPfobt
	8gyncxQEq7gVsuWDaTnMFkpZInifBGc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rkS+wniN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5n838WT9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rkS+wniN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5n838WT9;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537730; a=rsa-sha256;
	cv=none;
	b=idJGdy7gOWLONfi4gM1WeK+NugMXbH6IldI/6/LL4Vs9wB/nG7q8Qavg/kfsuSShNwK4gG
	w21rmEeULlESpyYEZyD2+uEFYOOC4N2rlxpQeLXMCjI5AguQI8q4syy4VT9m3Nd/QV4iAu
	NUKpmuC5XJfCSbYHsN0S2GJ1ZdUt988=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 931385BE14;
	Tue,  3 Mar 2026 11:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EZCu6t8s/sSBnbJHK1VjX/jyRjvJ6SV7S5hUeXBhK5U=;
	b=rkS+wniNJdmwgMgWQNZP0yVJ5QAfJF4QbhWKLWjGNq5AREpEOGB1NdgNmKWKRx8RsQquqr
	/FscEa9nOxz9eCqOLtnESk9iZ/rHhDjS/fFN9Zt2ZH6u+1iE4HCPVlai4yvBsd9QU/fW8l
	oavk0OR04mm1RBV8HALvmkDbuDoRo2M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EZCu6t8s/sSBnbJHK1VjX/jyRjvJ6SV7S5hUeXBhK5U=;
	b=5n838WT9mcREAfK05BpxfxWv0WFedtuC/YenURrlWQw0SmInlrxV/LZVGY+PKFrBtQwSNR
	EqXxoqS9i1NN8uAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EZCu6t8s/sSBnbJHK1VjX/jyRjvJ6SV7S5hUeXBhK5U=;
	b=rkS+wniNJdmwgMgWQNZP0yVJ5QAfJF4QbhWKLWjGNq5AREpEOGB1NdgNmKWKRx8RsQquqr
	/FscEa9nOxz9eCqOLtnESk9iZ/rHhDjS/fFN9Zt2ZH6u+1iE4HCPVlai4yvBsd9QU/fW8l
	oavk0OR04mm1RBV8HALvmkDbuDoRo2M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EZCu6t8s/sSBnbJHK1VjX/jyRjvJ6SV7S5hUeXBhK5U=;
	b=5n838WT9mcREAfK05BpxfxWv0WFedtuC/YenURrlWQw0SmInlrxV/LZVGY+PKFrBtQwSNR
	EqXxoqS9i1NN8uAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74C193EA6E;
	Tue,  3 Mar 2026 11:35:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oGtxHIDHpmkcVgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:35:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 250F6A0A1B; Tue,  3 Mar 2026 12:35:28 +0100 (CET)
Date: Tue, 3 Mar 2026 12:35:28 +0100
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
Subject: Re: [PATCH v2 090/110] minix: replace PRIino with %llu/%llx format
 strings
Message-ID: <guzw554fqneukeadqxlwskqpukfrtbejaw4sn5gjxis5qqhrpq@3a44ytsermdf>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-90-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-90-e5388800dae0@kernel.org>
X-Rspamd-Queue-Id: DD479100003
X-Rspamd-Server: rspam07
X-Stat-Signature: zmc6gc4d6ps8p7ptibgdhdity56enhf7
X-Rspam-User: 
X-HE-Tag: 1772537729-543381
X-HE-Meta: U2FsdGVkX19q/g1is2aEOTtEnGdonMy3uB2WjczkAJ/fZ4bhyf/yu+/f6AGSZO55C6qeUwNgmbwfSdR/ETACBEjvRvnl7UsB/KOGlU4N5Rp7AyP6EE1Q0lgCznPZ5wWUDBUp9IxdIXrJZs/H0cBTTVgy9Z8JhNPLdjWAphUZfgfrYqk8h5E/iCY4bF9q5FNz2V4nA79bj9e7uL+LpP9VQvukvEXQPFMbZZpUQHS1CWgHDgixEcwqKcJ3HdJz4qN/ZgfVnj9GL1YLTEpPBZrxbr01bXlDzRs4wEAX8H8wyh1m7K07jJzecudJDYPOQZH6FT4hZ9tMQgWZib1/Pc/h6sYJXHBXCUiXbLuPTj2fE5L5d8ZoLwcqjst7u4/F23RlHivkCE/P6xU96+IQuiLk3XRro1lPpyAxLhw8tZKw0HUu/0YlCKiCjkN/0Yrt1DN7fHaX2Q9Vq/zLRcGfEQLKR7N7ULe5GwkKmmEbNBL/iOs0e2+REbaES1ViUOddthS8e6LNanChtZV8oUWrm5wHuixR55WA9hOiwCLRxbKtCDntlEY43OkNGwBwONgovEmW86GNrTCaAjI+a2a8bSFRfEwQ8BqdhPlG0ZF8AFNiECKH5l3rQwXVmuGeK7krSGd6EKSgIe0RaEm2fQLRbk6rEUlwV21GJHlUsTjxwtgpWbrE5rMf95HUgWRjFg0rcVkommbtcc+yPCK+luVqExf7izffBN4iWG4zQTHK29wS0e5Ex8fpVKBXfms2lxuLJFWHeExZU/1Z+iqGi3epv+SMQYt/fcLijfVa6YEMilcvCRVprsa6kMHblSPw+sNh+i3kGb62aAOkY36fAMf3ilb0zrWoVIS1ufUb5XeDJ/EmO9uDI+4i++ZMaKMYd6FxKY+S4J1WZ4mlQlZvqRlzByCSKYVWWKs9mW8sEyikGEHwJPY0CRnXdKiLYCNjRroploJ08yJZ98f5xDGGBeBGhhg
 wzAP/npc
 Dz3aZHN2+T/SUmRe9beO98BXf98s8YdcqyfFz5bD/DNHJo3o3n2lThUm2UZZARjRVwlGLBOUXZT1kN3fLer8jKEAUGWpGtsHvJsND7DtDFfU01vEs7yLZvdpRBmUQEiN/Fn3sK4oHPsZDJUkUp/5hop3V6AHI4RMcAHg8kF0GSlhquHoRviym3GNHcANLKWCMH2yzxKzo5Xzbt+UYdYlf4bLFUebmgjLbkTFEi1qg8xoxZFl6KDPoMJI0JMU/Np0cZtm/2Syih/xxMNX2I3+tYNYdLEdkXBStfauPDjt5uRbgL+k5iQ4eCxa8GVXSrmbFCiYveAnGXP8Xkk9+zZNxeetDrq/+HN5+/i/baVRvFM9QeXoplSZ/2JstjzhcXLb6YZhP59eVGpVH6x90WmIq2ezpfLu1Z3S/alfyusvjzYoBB420TWlbx89aoH4BTyfU8MfMlrVOf0ubjCjzOHQy3iVMVz8/oNagfNvU2Gjg4MOBg/iQvuf9SFy07XDNPSYTMkMxDETXXtrdbF7IjnV1fwFTx3Gesbe/rxO/rdmvp5HAElsXEvYfJ3ag+AC6EhSted07ZC3g2eA1NJICOCO8OH4gufD8QxnHmObMYnntiBzUSlPSYMeHKwDNLdhBrbYQvOaPNDoEv22JeTBVw9ocFUdz5eHiZwD6mzt5ikTOstEhZVfFfjFVy9/WW+4jknKMU8IzTQQ1soKLr/9rIwFikqYIyN6VCrB0VM2vpKFr5SDoEFf02WwryUwPaQs6lsTdHdM2wevlCYJ+9GMmXDM1a32ubwkl+5EHnWKCmp00RT0q/tdds9Y/G6m3rC938uvKtt68z2rpW8p/r/Kf5Y8wKNoiUJJnhZKhEyccgg2UK3G8eSTQZNApxVCeqSYgVnCjelyCpHMbnynRi/eK6OHla1qX7tRZhZHvhGUHKzQaO3cDMOjeISBxbkZaBcOdbBzW4CHTnj7WwzdnqVQ2ejvSo/fYls2o
 UxM1JPz4
 yPBiZ5iHbzm4mYSzspOq+xHWoO+UIg+D07HRUXx1sjL3Uh8xYgPNlReUyv7giMVoTYrLAv0mSwfENg0X//QAsVkVviTUM4pkUzGZqeQFp7sQ2FoojS4YqxXwcZ0PsW3kyZXtf1DAsisGUEoiRnLT/PCR0TEJbplDrvOCu2ZkFfZCEwsApgD8/JziQFdfqKjWDGMteXT7/FPzld/rhDUcFnHeJ5epCbJiUMK8ada99K3At43sIlJR5V8nB2iT5Lw15pD3uU11yplzJ/vSBWgwSTBUXGwQIcc9/ZN8hXAoNjR0eJwjuCVToUfuHtd5BmcGAH9dP5yh8xEaxJelXpYHBpkpO62tPFX70G7xPflfidUfTz3qLpLwnUGH1hgE3UpRfiQZNTZts13ENPW/2MQNZ9s2g1IIoCS8WGimG+awDOem6aokhYCvI/3EQiPSJ5nL7okxtir16etL04rwY49pYTKBn2F44oA/H43VmfUntHD1cBROuMylX2LrCbO3dLdICnUmi+mVjA/fGPL+q/oosuU38ljGlzL9VsHKm6O67FYwefi19kp795qoHP1LrdkMh13Ujzb4Eb3vfk63hh3l8yha32cYTBtQn1FNizMmJRRs9FeJCtAI2eez05fSXoUZXcJv+x9QaKWDve3Ytbfq+cmaUFhfUCe8Jau54Mqchry7PVB6WjAmT6R/ffdK0P3xxykhlFiET7tdHpfuXYka8Pnjoeq+9L2Lke/3HqKjj4ncwPi+EBcDocH4FuEVAZAWJVoVVSc4sAwYVaqcd2eQCa9nJJQnfFKNJ0+5BloXGkFiThceWopKmvu11b4EwlBgnUQBs7gOYBiAapnVAeCmpaRujjCr8RZq1p6E2OPAh1iEAecIj4Fxivt2SF0wQOZWmLCE3FbCS0LoEWNVdZgza0b4ruGj+zNfm5qwD33S6wcpzJTIBsiI6A48OJHUiJHoLrNWzD5oODMr1mSSj35HfIEnUsD8Z
 MTB62zAb
 nIizUdPM2B47fJcZzBaUlvNHZmE7T6yYUZ7mkeUL+uMDfBKi1OPfMkhAln98cuGUXvXCpWvxBCiaIHYmynTFZU5LDezrshCAj7D3MFkCRa2HFCrF/uVQmmbUPoX0P5ego0fQeKbk6QokSJo6f4QRmKkk5AzLMMuVBoPQ3YVWV1ML871RSmqGcr7ZVs3e2D6McRmGnmAne7F/+9jLis7oR7BizOql9GDrkoQQh9P9vrKa9jnMJGa3ATRlOXZqKEx4Y/wYOj7AVgekWxgwvCBucOFfYYzJLgdxrTpi0gFOmVFFTPlTR0lbYzxYKvdukYyfXlqZHrqQiRM9E+s0tljlN6lQQ6BYXC4QOksRg/OX3tIxmOnT9mmHqKWNteXrMxmTD6uwsVJa/xjcQgo6fkcLqE2We+RA7B5V+XkY6P5j/ZAXBJq44WNs1r9WtgzDwB7VP7SJ6VJ1ZejRvW7AcijdPlZyy6WcFvMXWW3n8UX7hmYPS5UJ4IX8kv61+CJThE3ntOXIqDJdyl4nwU9TrB7jsdHftDXI3oPDI3RGMqFfJmfC9ypD4eV79pGIxZwTQYI514qIFIpf8JmeDKp/HTxThH3Fa71F4qgnMRwvM9AOH5TsQ8N4SJJKd3vtMrte+9sePvesiYVxZAzbpi9Q2f5qahesk9q1fLUuA4/TM21HaZdRvDU8mqWUtf3xcT5l3HePt1nT5UJrB5XBhojNBVlNkb1HuEpU1NOMiHRlE2c0oD/styw3GomHxvL86PLM6LF5bPcoMqsFz2jPhYvM5c0J2/60SIf3yFDaDVoXJJCGO1MxoL+7yFNiTm6bXlFJPwjbMHWrnu5OLzESUueykZ/wvsVFQ/y+gdho3cDG8eCKTs5c9j+z3oSZqdqEhVhC5+lH0RVERok4Z0/Nqew0qX+SYcEAdBYGrERmGKyMRDDG0cvRHWLmDi6/39JYNACM0de5dZbPm3R6RgjyDTgNlWDy/aho0SBcM
 sZdiGuUt
 eOBihz8RDhkmMnI+YSblk2RJcCzm5FznmjbWOP8RaBYMbc/59fXXZWl1F7aNAXeqsL1CJFapUGh6tAkJOUOJnm0ZarKq/mta48WmXkscOy0qQdo+QNez6N6v5Lafmf2IDpHa2rjFIESlO7rtCizaaCNpT5JIVfdQua1/7eii6+5LI8oBbSiE0TTEr4euzeWPwOEnbEdFib0SSRXnygKCvLlzdH4bP3rgLERtuHyjyTYnuMvfmQCQEqcZo0FAqr7BCQiIPE3OKXQhzLkkfk8T7ygcIsob+SYq1FcOYKalCDnsVybFVSeD1H+nINPsvdTl1QTztz6xBC7grnT4S5fpl+dBVK7X7saO/p3t2f2hw7DpAaktQBqpExgSlPCXez9xUyUTcktU4ATZHodwVRVdmuu860VdCYMwLwNhtYx51YxE/ZZFlNfXcsMuaXsoSM6/BuLaBeBFnxCqgONEtR4mqV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:25:14, Jeff Layton wrote:
> Now that i_ino is u64 and the PRIino format macro has been removed,
> replace all uses in minix with the concrete format strings.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/minix/inode.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/minix/inode.c b/fs/minix/inode.c
> index d92059227d273564c86f100dea3366be4509090b..838b072b6cf0b54c955320916ac996e72f994a14 100644
> --- a/fs/minix/inode.c
> +++ b/fs/minix/inode.c
> @@ -36,7 +36,7 @@ void __minix_error_inode(struct inode *inode, const char *function,
>  	vaf.fmt = fmt;
>  	vaf.va = &args;
>  	printk(KERN_CRIT "minix-fs error (device %s): %s:%d: "
> -	       "inode #%" PRIino "u: comm %s: %pV\n",
> +	       "inode #%llu: comm %s: %pV\n",
>  	       inode->i_sb->s_id, function, line, inode->i_ino,
>  	       current->comm, &vaf);
>  	va_end(args);
> @@ -520,7 +520,7 @@ void minix_set_inode(struct inode *inode, dev_t rdev)
>  		   S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
>  		init_special_inode(inode, inode->i_mode, rdev);
>  	} else {
> -		printk(KERN_DEBUG "MINIX-fs: Invalid file type 0%04o for inode %" PRIino "u.\n",
> +		printk(KERN_DEBUG "MINIX-fs: Invalid file type 0%04o for inode %llu.\n",
>  		       inode->i_mode, inode->i_ino);
>  		make_bad_inode(inode);
>  	}
> @@ -542,7 +542,7 @@ static struct inode *V1_minix_iget(struct inode *inode)
>  		return ERR_PTR(-EIO);
>  	}
>  	if (raw_inode->i_nlinks == 0) {
> -		printk("MINIX-fs: deleted inode referenced: %" PRIino "u\n",
> +		printk("MINIX-fs: deleted inode referenced: %llu\n",
>  		       inode->i_ino);
>  		brelse(bh);
>  		iget_failed(inode);
> @@ -580,7 +580,7 @@ static struct inode *V2_minix_iget(struct inode *inode)
>  		return ERR_PTR(-EIO);
>  	}
>  	if (raw_inode->i_nlinks == 0) {
> -		printk("MINIX-fs: deleted inode referenced: %" PRIino "u\n",
> +		printk("MINIX-fs: deleted inode referenced: %llu\n",
>  		       inode->i_ino);
>  		brelse(bh);
>  		iget_failed(inode);
> @@ -692,7 +692,7 @@ static int minix_write_inode(struct inode *inode, struct writeback_control *wbc)
>  	if (wbc->sync_mode == WB_SYNC_ALL && buffer_dirty(bh)) {
>  		sync_dirty_buffer(bh);
>  		if (buffer_req(bh) && !buffer_uptodate(bh)) {
> -			printk("IO error syncing minix inode [%s:%08" PRIino "x]\n",
> +			printk("IO error syncing minix inode [%s:%08llx]\n",
>  				inode->i_sb->s_id, inode->i_ino);
>  			err = -EIO;
>  		}
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

