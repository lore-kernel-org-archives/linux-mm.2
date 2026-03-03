Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0BBCEC1432
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2439C6B012E; Tue,  3 Mar 2026 06:29:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0DA6B0136; Tue,  3 Mar 2026 06:29:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5E16B013A; Tue,  3 Mar 2026 06:29:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED6E06B012E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:29:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0075137AB2
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:29:52 +0000 (UTC)
X-FDA: 84504532224.04.5389451
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 62164A000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:29:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EmOx0lKI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xHcfN5qP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EmOx0lKI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xHcfN5qP;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cYw8VD7aleVcghFQ9+p/b6r3CSegw4nIvkNduu063c=;
	b=DYoewMtDVGUL1vJ39CFnzhDI+0VNkPNVgCULcHXp0nPzL6+CdBuGbGzDEZICLiG5zd78rp
	vgv78VVdM1WXkiKuFH6f0UavgLi8nwgnjrj8GDRY20kfS4392kVTD3P//zUCB5QxcChvYB
	l3/ZwNfS9R8N7ql2JYPZ6NeKAGyE+ys=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EmOx0lKI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xHcfN5qP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EmOx0lKI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xHcfN5qP;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537390; a=rsa-sha256;
	cv=none;
	b=8pOaAXZiaRKtratZx33ET+Af8NhN1cmuuG7EBjMdD8LvaukgJU5ecH3ZqQt8ddJUVsNxB0
	7M7c1U8SNZY41DO3T0ArQZt7ns7foBj7/N9974CC4Ui8aA9zv/if+N/AevX88OG4fhgD4/
	t10fzyL7nC7KjDQX3nLXneSYs9u9CqQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EFF813F899;
	Tue,  3 Mar 2026 11:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4cYw8VD7aleVcghFQ9+p/b6r3CSegw4nIvkNduu063c=;
	b=EmOx0lKIT3N1EWFaJ+qXMxOLK6ewXQRsG1S7uUHtrrsyZKCuKpQq1d5e/B2EI4OLCk5Zsx
	+HBoagECsN1Bb9zjUfycxKVXPSLBGZkIFVk4nMkH3R6KfTwyB4g5jdsFjHwwqdmwDk0gjC
	SGJcEP7zorePK8+w5QgsfvCtqorcOsM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537389;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4cYw8VD7aleVcghFQ9+p/b6r3CSegw4nIvkNduu063c=;
	b=xHcfN5qP49v6i+SF5MTzOV+1zpFdvaekhWZ8tV1V6SJgevJciM4Bcy5z5W/57zxlA2cda8
	32g45NoTRnMkZkCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4cYw8VD7aleVcghFQ9+p/b6r3CSegw4nIvkNduu063c=;
	b=EmOx0lKIT3N1EWFaJ+qXMxOLK6ewXQRsG1S7uUHtrrsyZKCuKpQq1d5e/B2EI4OLCk5Zsx
	+HBoagECsN1Bb9zjUfycxKVXPSLBGZkIFVk4nMkH3R6KfTwyB4g5jdsFjHwwqdmwDk0gjC
	SGJcEP7zorePK8+w5QgsfvCtqorcOsM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537389;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4cYw8VD7aleVcghFQ9+p/b6r3CSegw4nIvkNduu063c=;
	b=xHcfN5qP49v6i+SF5MTzOV+1zpFdvaekhWZ8tV1V6SJgevJciM4Bcy5z5W/57zxlA2cda8
	32g45NoTRnMkZkCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DCABF3EA6C;
	Tue,  3 Mar 2026 11:29:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id egbaNSzGpmkOUAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:29:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9BC70A0A1B; Tue,  3 Mar 2026 12:29:48 +0100 (CET)
Date: Tue, 3 Mar 2026 12:29:48 +0100
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
Subject: Re: [PATCH v2 060/110] vfs: change kino_t from unsigned long to u64
Message-ID: <yfjlanmzvvyuea5qeqnozxtb4ubpkdev3o7ibwmmoo3oczthtu@27zcimxovqjh>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-60-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-60-e5388800dae0@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 62164A000D
X-Stat-Signature: xkg7rjk36x1bcf1fupap353b4atc8kbg
X-Rspam-User: 
X-HE-Tag: 1772537390-915934
X-HE-Meta: U2FsdGVkX1/uqvusdhhV7bFx99UUoGJt4IHap0GmivdXaV18rLMwTQXZ4CuVtBs8wzQYSFnL6HlqTqSIC9EnPBBSKlK41FucS5Qh+NEjen8hz1+bDh0vIV9TIGNwMCfW8d/xy9fjAVkporBOtfUP+f0dqiPtQl9fmz6AsxFcj7VSgKgnJTglTpkGvB1pi7ogomUbg7BbNnmr8yfsNGMna+eNlJ5ss/g9rBxdi0I2xDQnKfXXQjUMhF4YPbF2QMXctEHXqzCAOCCr9lbBx2wNUkd59XZkgWZkf7q92rI7MyUl8F1z+gLWeS71PeEDctxebl8Pk76+w1KTSYTUDhr7K7ajJLxB4wLaiT7lcz1TjJwLwer0vt81o58igvUKTflVPmQAt4AM6cQv1pga0j2vTF+XYgM2FEfmsfvK9QFFXBLFjzLDJ/C410W/3e5MqZOl2pwlT0FA0kBUiP841OcMRJRm3OvkD0xb3L28AfiLGbMXFqPyfW9QmwaMI8PTu6Eh6zGMk+2JQyXoXWr/4Z90pbHgVNzHxZTScQxHj7kO5foeZR33emLqK4qW1VjX25zaT3FPcTWAcpEVq6YBjWdjD/nYwmFz1W4qUR81jJ0ObqwOOqZ+9uqICFd5ZSwfc7Dy+6DM0k6K7SXlfqvCGvUrFq9Ix+LFX7kIe8koE5JmpNnnehcY1/E96IqURemLpi+/vWIFZ6EPm8WNfP26rrxZdIn+8Xhs+xyJdZDFyDoqGgS/dEPmEdS9lKbmV5lu+ad2PNtaM1G00Xpk0/yK4j8e0xJ754GwQDmBdODGsSLG6m0UO/qofjRaT3Dt+y62+VvPLHlovEYTwzoenEzTpDoxQxmuMVQTGzn1P/oa9/WXLbwWIVv1FNOF45sqQ08STXBxvV2SI4KWZimWfI31taHayd1pGR1IhtREyfwDHTLwYjFrh3KYluu4GdrKklLwNHlQN7mLzIgln+/kx2CJUER
 Euva/fXC
 NQwRuQ72d3o8KxpeZFglFDbVbSRWI9Aby/4uKHzIx/x8HqBN52wR/e3b7Y7yNWAxp44v7894hESEotMcFjH1L0QeDnLzTvrpJoCkANiHrX1htd/ldNo7TWGwME/2TQ9Djo/SMPH6vVP39FyWC80InjYCdRMnc/vjc0ZrAFgvgMzrwqkp7C5orbagjV8vFxI+r3kl7WKiNL6cVx7riKVZLzbqDhLnc/ZpOhe4akfWhVVl9pOxrtq6E0zSLULfyslpRJu4txK08Hr3dagwi9Td1kcQ65gyAe5C0VpTASVrGurHwBGkB/hZKzJ7i0Ji0PdHcrcXD2StJKLdHHkNYT24z8thItsNKtNxbW2QCYgbk4NYQa2mJtvPye/538LjeqoAttZt3vvgXqoGYs9SsnkRkCP+xGdZJQIHykcOTyttQON3Ypjy1SNqz1Vswm3fFrCwDIQeRx7EXTHMu6Qo2T+Pi/Xb8kXsa9NolQ7bxDSgXQ4ULck/+3W/Jzx6BdqIRlhfjPv7jSXPfeURbyqDRDnq9Y7WKgKARxt+0cgCBtzxeI6UT+ZAtp1aHztuyIKbknf/nD9dMYOiw9ZPYGba/ixX7fogeUyM1hhjcXNPuYM7ik7ULWTX6mdQULzKMJTdqo9DtbHJyLPPB/U483FTcHYtz2lX3DC/vMLllAbdIy5itPuXJapMJF5ScVb1zeQUpkzgrVa8u8c+9OmHVVGDQWN7YB1F2ZxZ20U+Ymkaccm/G19kuhkFonhP6yOalyO4lC+r0lN8ltZ1Qio/XXqFf4mthUoyilfuIfLK5+iH/0xZ6/uO7QRhoRWFmquew7hsQELH56fEP9T4gf2hjgAU5Y9EXtKIRi1EUJRPEZPUhVC5ToBtH6qvsLPRT7dpWqEvu0Dhy/WCb16FJE6MCt1B2eRfCERvhjc9tjErBmnFKgSSDCBoUfkuC8Bn8NnY2thCiV6ibbqdogtXy2vGJu9PR4t6C8ro6bLCK
 XB5zxv6B
 CWKE2zuBWS8LiD5Y1UgqTYR80JJRS+IL8bH8mFL9RLw77lv/iZNMfM/GkkMKcYL8g2c8LChXx2g+H7EHrqblY8mPZfYeurqG9evqZVV1TerAuD7diJ8seMow8BegJGeSQKMN/miOESIGEE1q257h0rN6qaW/dFqgdhcMxfz0MjaXQFQ+luceF8ZP9deZ/kJLhTo57QJwiHA0T1vfkwW5gbVFR01YLi/+49Del4GdoynD/JZJsS9Kx2K8vgg2erZ7Z2EM/Q3mOiyXymBWylORRJdzQ4QUlZeGTnmwWSkpomUbDpKobN4RstPxR8TxK+ermHW59SBf/oCBOgvWxup3G/gHi+C4ZNxaOyM++BgDXg0R07Jj6TUN73EYsi6F2z2jIxAJ+nrzbwTpklJfEFi//Y4bRumnazhP9kdyzQ7TrOhCQmGQeWSJH5JEyrdulTcIp+tBAbGp3i0v5y1/ZoL1O5H4uYEoqGieNIXWH5Y5SlxaSVMMMECESVKnbMCPKM6zuJ1F6GTicXqPMOQQUgNoqTHok2aCy2Ot7fYQg3gT3aUlNiohLJXC/uq+S6vx6diQhAFXTn84luWmHrBADj1MSTwA2HjI7904TRdEObzWSgfnb9NXUeUn1SXTn1mda2VYzi8V/HRYIDZdPSFNbdJF6u5y3Z9PyaBcABqKfpAQndtVJ/4QlS+BJwwvDWBEPnG7HmRCbiAIj0CiBsMm8MtMFFwRjBYWkWFlN/KHzevcZf5a/hajMpdtMmQdIoT5RIiEf58K+IintXJvjRxPDAKRWyDgppnwto1ei82922FpD79a02G3fRbVQj4F3PM8bE9H4+km/NgMv4/fBQBbJaAhowIuQO4NAE6P2JBKev0RQUVgWuJ/KenInacuTfHQW5QcfeoHflnM3zebfYfcIsFTJaiuQsnzA7zsQsA/ReHEaHqzGW0xc+iHgn0Xt6kXobQfKBDPR9GmmKODA2QiPHQYWccVUYvPC
 EG+CuwhK
 HarVajIRH2YmZexHwaooj94GYGWVAe4DDeaQ48x1Whe4f8UAcbX2R1R9eCi/a4XUrg7s/wYBFsPvxylaymQjQXSwgNQTXoula/jffOccAXJ002uZZzbClOR9L6iN6xAQHE5XMmbnJGEkt+stgHZ4e4SmTjufqM5hXeHjB/GDYoZNTtcJjIPqqpGRR7GRqy2OXP4WMZ9NB7QI1+r1zwTWLTOv66CWp9r6IAMnuptijsj7JwZh47Ht8O/3iZ0ErufNA0ThlOtew8NPqTUiaiMmzTR4/mPMtbiu8bISZ7dsvGlAqcRD7QMEmtG/yTtzEDGj1e5X6KvICDvegvLl0DEufCPduvYUgiRz/HI5aTPGb6LifNQoXjA1vFYix7TOvixAZJidPuAs9FzNev1LuJ36dqSZpYvJYZVUmMoIT2PgIsW736oDXeIqS/7lBVE57ZLH6ka57LqYqzw9ADPXC+vDy8uaHqcbfcDl0LFH8JDEzqHAdD4SIAJZyhULKRdl9Y9+bXAJg/ukU1xIuPJ8dw9KlVJdq+6h1q9TiZs1GqVnPDQtid1qGiplNO3FjBJ8HC1br0e4avBpUHqMuPasX8XNp85Zjics+1G7P5HG8RqGy74iZI1o3Dcg3xAuG87DhQis9/AH2FX+Lz9qqH4CJBoQVNqpRg3GAWRZiDqXkSc184xCvtJc6bayou/iZLasn/ftOLtLQY8RTYIEOIbo0RiPbXDq33tAcKScbMf2GVUx76Zt2BJ9blOQEsHvdMmlftKp+hPLjFAJGlEcbJCzXso8DIVs18QEHdAbB3wWDo0cZLnwe5tBr6Tr7C75E5LZTqj1g94JtwZ8XvWLi6DRjZ853G0n2gI4JzLWveev/87W0raswsj4HzvzaX4Xjt+3j3vECWuQ+nXebykh1Oj80qBoWPi7yzngSd40odasPiUYgwPAIxj34xp7Wog3h5Bh//Igp72FBM62MygfzV+1hxZptp8SX3XtI
 +a3Wr/9t
 JZ7bX7+SzeRsn/a8vwliuBNYyu87JcXYDtdxrR2pGf3wtcrPI6CDzHKQvRHekOvLklWeS64lATJ29NW4yAggcO2KyILzd1sBKEazp8KS2Hbb2H13ga+lK233+g8ON/80AVAXPi+9b5TpTAUCdalqVQGazGg1rMnUl3KGbY5UvD/u0EW/929ilaagROpGZjCWrGqlpGhhSMs5JqetoKwMnOFAKK6aV2cyovC2LbJI+awpgmUtsI6BSeXLjXGVacLe7/b3a24+PDLhlyJw9XPHk3D4+ABJRYMySgq0TBCIyzHKmyTk6lTwby0ppCiYd6VKoa5NdYcHLcroJiA7v/Wq0Nf9jdPdT1J9UliSDvlSFyAtST1vnvPIWpAbB83syYC8zmpi2i/t+YLbtspdWezqUffSCnCpIj7Id97EivtEsZXeA/qYQGCxPbYiIslTDboEoIEGcETk7BNHxDMhivJ45RF08UsR3BRRe0FgEWqGhlrHRx6kYMxzheXdWyCA2/Gjg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:24:44, Jeff Layton wrote:
> Change kino_t from unsigned long to u64, and update PRIino from "l"
> to "ll" accordingly. This is the actual type widening of i_ino.
> 
> All format strings have already been converted to use PRIino, so this
> change compiles warning-free on both 32-bit and 64-bit architectures.
> 
> On 64-bit architectures, unsigned long is already 64 bits, so this is
> effectively a type alias change with no runtime impact. On 32-bit
> architectures, this widens i_ino from 32 to 64 bits, allowing
> filesystems like NFS, CIFS, XFS, Ceph, and FUSE to store their native
> 64-bit inode numbers without folding/hashing.
> 
> The VFS already handles 64-bit inode numbers in kstat.ino (u64) and
> statx.stx_ino (__u64). The existing overflow checks in cp_new_stat(),
> cp_old_stat(), and cp_compat_stat() handle narrowing to 32-bit st_ino
> with -EOVERFLOW, so userspace ABI is preserved.
> 
> struct inode will grow by 4 bytes on 32-bit architectures.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/fs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index d0c4789838b5852111583a3e4cced88999496e68..4193817e02e8bf94f29514ca43379af21f37ac61 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -758,8 +758,8 @@ struct inode_state_flags {
>  	enum inode_state_flags_enum __state;
>  };
>  
> -typedef unsigned long	kino_t;
> -#define PRIino		"l"
> +typedef u64		kino_t;
> +#define PRIino		"ll"
>  
>  /*
>   * Keep mostly read-only and often accessed (especially for
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

