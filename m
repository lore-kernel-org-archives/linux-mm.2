Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43563EC1432
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3006B0152; Tue,  3 Mar 2026 06:24:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6DD96B0153; Tue,  3 Mar 2026 06:24:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA8F6B0156; Tue,  3 Mar 2026 06:24:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6256B0152
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:24:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 482B9B55DD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:24:41 +0000 (UTC)
X-FDA: 84504519162.05.832018B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id F1A0F10000E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:24:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UoWJ+20F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q6oUQTud;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UoWJ+20F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q6oUQTud;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDQHJTybbwme79tj0LaoGJ3bxXhb6k+U6EpthuA22eM=;
	b=P5VpbmdC6HBPZ2QxdEhXv9+xanwUAcK6AO09D7UbGdBxHB8KEgo+rPdobM80uwDrscRV5X
	AL7OJkW7N9/RSZWu5jztD4F5rbkhQrX7+/RD7j94GBhS5jVbOgGhNClWWyjo5Y176Zvor8
	tfi7WeaB0Ocr8rJBIQM0zjMHBMsOw40=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UoWJ+20F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q6oUQTud;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UoWJ+20F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q6oUQTud;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537079; a=rsa-sha256;
	cv=none;
	b=F33kl9Lp/UCGEZITvPTHldiaJAc6wHc40yASZ5nRWA7VMjAs0iyY5UriwuZutxdL0gRGyr
	zSBQ1/lrnArizHikd5XwUZgZhCj5/80PNkSql8UIGth7PAz/eLZ1QLLRXSJeAE1qy1b29X
	b5UXKpfgTLXf87EMaxRvaipuHw7NUUg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 21B0F3F957;
	Tue,  3 Mar 2026 11:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vDQHJTybbwme79tj0LaoGJ3bxXhb6k+U6EpthuA22eM=;
	b=UoWJ+20FudPqog6nxHkr+fdHi2sJkTvwHuu+U6kuvo8gTTWmh/AlFpBu94vJwGOq83XWlO
	SWRBZty/CKQ0hlfQ+lZ8gNI3kKqwwsJ/Lu5UnE5LBFMyAaA3/uvcm0WcVYOvdRBJtXQ4CA
	ohEwDdk4ePzsFvbqpNx8CmCIILQIl8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vDQHJTybbwme79tj0LaoGJ3bxXhb6k+U6EpthuA22eM=;
	b=Q6oUQTudfBrS7v+5ldwHSD1RVeupUKkxjY+tqUelutQ+f0ackTTzkSKTR5cBNAJo7Ebnpa
	K1UfuCNCKIm02nCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vDQHJTybbwme79tj0LaoGJ3bxXhb6k+U6EpthuA22eM=;
	b=UoWJ+20FudPqog6nxHkr+fdHi2sJkTvwHuu+U6kuvo8gTTWmh/AlFpBu94vJwGOq83XWlO
	SWRBZty/CKQ0hlfQ+lZ8gNI3kKqwwsJ/Lu5UnE5LBFMyAaA3/uvcm0WcVYOvdRBJtXQ4CA
	ohEwDdk4ePzsFvbqpNx8CmCIILQIl8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vDQHJTybbwme79tj0LaoGJ3bxXhb6k+U6EpthuA22eM=;
	b=Q6oUQTudfBrS7v+5ldwHSD1RVeupUKkxjY+tqUelutQ+f0ackTTzkSKTR5cBNAJo7Ebnpa
	K1UfuCNCKIm02nCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 080963EA6D;
	Tue,  3 Mar 2026 11:24:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id htTrAfXEpmlNSgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:24:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BC159A0A1B; Tue,  3 Mar 2026 12:24:36 +0100 (CET)
Date: Tue, 3 Mar 2026 12:24:36 +0100
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
Subject: Re: [PATCH v2 034/110] isofs: use PRIino format for i_ino
Message-ID: <4sefbdgtlxnclmqd5drtyk7k7iixheqrkxambzoazpc5wjbaad@z4djfmeum5ks>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-34-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-34-e5388800dae0@kernel.org>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: F1A0F10000E
X-Rspamd-Server: rspam07
X-Stat-Signature: hkxmk6n1i9a94ej6ttr35ojpyzfmkfk4
X-Rspam-User: 
X-HE-Tag: 1772537078-915045
X-HE-Meta: U2FsdGVkX1+Qux7PJPHL0mKnSa3xYAKRc4Tn/mBZlze7th82WaKPGsTtzCyRf+/1z1mJVQNmAZyampRtrHgJqCkvwiLnp2hITx9cdJ47HhOng968sbAsZYBWxqTMK0gacDNfotxxCEn5gwxyp0KjD5ebR9xNcdnb6QmqT2Gmf6IoO+tP/VFFeJ3sfovxlEm4qRztbu9SAsrVU9Wwd2vmnCg8vQ06yTPCF8Cf8f0fUCgaxnU0q6Rt17jShlkzKpIpPr4rmThTbLqmL69pkCxVpCntNy6nGil3f7hC+mIbyPXvxXUvkN5kPb4Bxo80OawF7N5G4G2Qd1WIgru8mzF2IsZoo+sKdxikmh6YMoAMkYC6grfs8uFsZT+fpcQOWXSLA/nE/TkwYzPX1pjlf1Syy/OChPRJqkhl3Gqhjt9lOWUxPAQTS71DhJeGxhtXM7f4ejUK2eIcaI1BLuIi6h+KoeBehlxmMUVOmviund8WY1EzOG1j43V75tnIHFla8IXlHZxcgiPcSi9ypd//m3e+Qwz3TNiimcYNE5i2F0liKofd2P4P2OpPA7jIBqCDQRuAOcY60wwBrvIMZjehfSPtXf9snZQg1QApxwP1RuFOSjSry0g5e59qm0V9ebZo6s6L5imz/VAqKGFN9me2yg/yIVwsBB/o5OKZO9FQD+1tMpGhTLdvzb0J8CYhRSHUOBRpcQsj1dUhrTqMbrB4kQCUp8Ul1K9AwTLY5fBvLT1oVb7/dtI5wlMMYCPEQvq5N7P0S0vTVSV/eeKFf3Xo+z4dkHk817qzXg0WcuyP35vPq80HkW27nmGryeTS78wpW5PcncQebzIV7ywNHtb3GvUtRPtyS8Bw5/hdvfQbdPdnmj/54s7tVk8EUnHLR9VZ22yop35/bgc3HsbSxFcxTln3J9wjYRrhAwKcA+poe0CQVCSvuUd2jrSyTDWehG1Opn+qETxPku4PyJAGvua+M9L
 es/tpHTx
 tMhWguoiK7YskZrSK8Yr6NUYjTHQ7jb4AnNFYqWrDuBwllOkuUUUNNp0+esj4LAytltAMoeH6sP6neNeOmKh4WFGtu8rXdLZUxoPEnapOPa9jRbem1o6vJqLmjUVCbuK5sA62LKBw9ZCM/GV5EQ/rKbW5VEfgSuT3TLD6OFADTxDIssAJ2KjHakA7Xm9pKRvz9arjvMiJT4aJ3+DzkUMU1bx7q3guCq28yWzul8ldydDYcEbS+rlumQVaVWaFgI4ILx4LtLBN7EJiZJasHZzopPPv/5U6FVX7m6/C6AJkZ+nX5ekIElfP3mvIFurrC88MbX5CvmOUC/pU7lwWQXiVSVc9fCIigEP5iLPoRw+7HeE7Uu3RZ1pGAEckwLAl4D61Micb7a2lfCWpLwQcOTtqeWHPToNB4rzcav5N7hbXJ3qolyuA8XEi0Hi/JMATNeopJVdJF7zHhnABbSWNCPJpIbDHXNnVrLHm44QN1AYmp7cUz0xza3ydrQDLvPMP9aJe4jhskWCh9r0A33VKO1y3/gMaXoBKDpoZdz3PjgkVW8VKrOhnLfEmPxhrVsTOHk7VexWmePeUb2hUlUH/tMaA1YDx9mH5RQPr+bYug35Dm8j3nLiZo/CLAWooyJlmtUoN7DuSJoy9T3Mw4VwnFCpl/tTP866mNfF8DmiQcFwpNLQTJdhViyOhaJuB+5Au0V6O8GPS55Klpxo81Nj3Z7KVPhhSQS8a7gs4FHtaP+B2A2sG+851Ef9q9XBN53fT/zPU5MVUsZD/oneAlWPrMNtH9kT7T2WMtjECB1C6TDiuqOsCbk3sC6e09RMdZe9Ly+4ZHULPUUeq5i/6MTfvmZCkWPPBMgdCWl3zLEs1DYIrDXtpmDtZScbdlTiOd/okHjMZ9EwiJIulMXNwaTnu1BOHx+jpDsT17M2Q1ElFW/XqjSZfVZrX1FvFhpFWa453Vtdfukgc9H0GhAEOdEWBKdOdrZOIN19Z
 opG4T+aH
 E4RZriiyEP2Aymx+3a+EiIb0/Ml/ZZjpDh42SDtzUKJfvPzT7iExqEragXEqnmGOb7+sj14SBv+3tvtszvJgr4gtveYJp52zEymv87Cu5cXe7BxTpN8UVS9zsCEIY9v+u7c2dshrEEJAJKR8W5EOfICCf/CMXp1z0I/zrV6glMjBsV8PUQY/eqwBTi6b7Qw6nu7UgxWDLJj7ZU961d94acZ+8IoGZ4tZfFMgQSyztIcmey8xlSaWcCFPuolhSe6KY3qK/ABKc2aST9JEWupN274hcoJbpIHEvgR4EixL0DICO7B7K246CW+zlv3a3s+eu3XXCPeRFju2Ua23amxDMkYRfvS67yTdJXJHCcatMJYtg7yMtAq0tj1mo1F7ZPMZ2aI/8H/8SurKg7LvANxrXE3lh6KLgyHUT1dj0APWotiGs6W7VjRET528kaG1GOrdeQvDboTa3YTNZdLH+tGqOoNYSuej8mbEqvTOday1x5b9awboYdU4mEcg1Ihwsx16F8b5Z8SuKUAHw+ywcGuy/251M+oE/ToER+48emcqJL42Xjcj95Z+OL0U0gq5Ba/ybLZa8IK7flxRxBRApBx6rW+q7W8TLJEAOc8eEHDFAMBEcVYehitQ8P/JjfYO3YHsRvw5B/5vMrk4yzxlHZPJ7+iXt7NN2Ejy3Wi7zNcIAr4CUYl/k1gynsViNUjpC8EJsfWlDiJ9Ti3W118PT1G+jrgsiRimoNaI6qMAkkAvzPuFU/ORyMy43kPwSMX8BXUNBfUN+nz0xpspaRiSzXykS9qwY0kUTg3k9NrZiZTy38/aEC0JFHvtajsPgAfQFO0wXZSk18g00AyldSreY/1fkhePS6jvkLxCHfI95I0sJJqz/uS5FUN0opFxddPjcGjgP19csCmd3HhXlxVMNDO6tlad1o0jASo1/DysWlkL+vPZVwggiVuL5ro95wID0yXXNzPf0J8z2FecZH/LvEC4GGhgjDWOc
 vDKYHsnD
 IX+muDo4nJ/9VX/J+nioj9zAA7FyGg6DlfPuPkwME5bX8N2BL97R57jEMklFus9MNIg2DpeCfzFII/DNaPN2C1gnXvADm2QGKNnI17dHre0bDgfFxMEAoyDZ2jf5A26Y0MDcxzelutrjAhdm51fC+aNj2TlH0hOTq4HMiSWuyq6CGl6aS3WkD/g1hnezmPraiZf5WosbSVrmo2QmbJBufOoKvzHa3n4TJkYpi5VrwAJ+YdQzf8QCR6GoAPv0uFEU9OkuT8LLzXEi4n+20Ty313v5O9LcjwADC9HnU7+eUODNOwVCvqXZLHuy99FUvChq4cSZyNx3AJgRLxJP9qaPzFHSDuLgOdAzLAth4Aqn7iokwSHZFSShm9RxBYV8yQL3jDMP7rR6UX1ph6NOKL3yNjZ3xZrHzG/zquTwpRa8wRq/+Gl04KSZvMCAqwpAL32jy5JtpJgMI9QALF/RuY+Nhu0CZqlYOYa70225vvWvRKPTSuhJ0KzGEk9ERJrwYL61plWuw+A68yJhM2dMedjdeSJsO5L+QnK4elcuEupBv0wgVwejt7/drzc1jZq6bl+/QtTBoy4KFUcOFsOuJgu06jV4Ct0ueoGUhfjp7bnRBbn/LIaIonuv1r94AO02REmWzSq4gQ8+9sry6e6G4CRy+cP8EyTsLfyK9sIYTOI3HYA2RWPJ1vpo9LGEENHl0TaW7FIZ9AeJFbeJAVejaI3CPtgztqGIDersEDALOFiHJQ/N0dPB1grVJCTM/hKvkY+RoMjQkNfHWTsnyawkth8hPxNghv5Uy5Bd75mmIVthbM7dNtYnUOkTu2Bzvo4oz9UhBWFmxrDqCFMhgTVPRNpU1ldPOowG1nLnmbQ435921Lc9sRuAZaCNVCoBHPatoc+FMwy3GvPEQDjo5bzBQK7NFS1bgV7E0ujJ7WIdqzA4avu61d6oEaXDregXql9DEOrBVhkUIa0VJpgohJ0+hbqyDS7jRZ7J0
 Gl3gaBmu
 +vGyaUIHohDmBC73WyEeIdfxIKoVszGV24mdk1YOpDq1+OCvSv71XERfqATex7kGgSImBwwgxF/gh07U2vCBX/3+kAdOuWr4CnwecfRPyaX7Xh2b9FIeXp9fsVfiqRx3mzI8RfTjGCEaLS/Q3SLofbOLt3tsnRLjFRb3hKKTuPDOICNLOokgden92uhCg5+H37xljSMC2uBvpsVgLnt7DqfaH1IN4snUe4IjV52pJ0L1f9PhtgDkxoZW+/apbscgMeUit8VhEg1r8cK7KY9YruasgPgUdYytnRa1PH4Gk23bRNqnapuLRJr2Jjxz1yrklN17d7mSmGAGqE7/b56X6shgIgGZWKaKXrFNBfOSlD5I0t9KQnK5Vlf1ElkQDwRIPFBHjxm33rQ9Fvi6p9nLxoIkGwJfRPoHWOtx78ax9rJXSadfgf7r2qn2DIeO4R2e9URzOG7mMI+JJpmWbYITiaMKz00MYoNxDWcLyUYU6lL/ZHx0xP3R4xgKzQme8eY1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:24:18, Jeff Layton wrote:
> Convert isofs i_ino format strings to use the PRIino format
> macro in preparation for the widening of i_ino via kino_t.
> 
> Also correct signed format specifiers to unsigned, since inode
> numbers are unsigned values.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/isofs/compress.c | 2 +-
>  fs/isofs/dir.c      | 2 +-
>  fs/isofs/inode.c    | 6 +++---
>  fs/isofs/namei.c    | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
> index 50b4cb3aea87c7fc46b8b5483162bce84573b483..dc6c7d247cf880720be47cd26d23206d25a4e453 100644
> --- a/fs/isofs/compress.c
> +++ b/fs/isofs/compress.c
> @@ -156,7 +156,7 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
>  				else {
>  					printk(KERN_DEBUG
>  					       "zisofs: zisofs_inflate returned"
> -					       " %d, inode = %lu,"
> +					       " %d, inode = %" PRIino "u,"
>  					       " page idx = %d, bh idx = %d,"
>  					       " avail_in = %ld,"
>  					       " avail_out = %ld\n",
> diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
> index 2ca16c3fe5ef3427e5bbd0631eb8323ef3c58bf1..0a8f9e411c23425a6919b7a4fa3fb387eb2c3209 100644
> --- a/fs/isofs/dir.c
> +++ b/fs/isofs/dir.c
> @@ -152,7 +152,7 @@ static int do_isofs_readdir(struct inode *inode, struct file *file,
>  		    de_len < de->name_len[0] +
>  					sizeof(struct iso_directory_record)) {
>  			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
> -			       " in block %lu of inode %lu\n", block,
> +			       " in block %lu of inode %" PRIino "u\n", block,
>  			       inode->i_ino);
>  			brelse(bh);
>  			return -EIO;
> diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
> index 5c01536c5e8fecb73a95d801cdd3b8ee22011a3c..678d7363e157d893e005152e64e922d9170468d0 100644
> --- a/fs/isofs/inode.c
> +++ b/fs/isofs/inode.c
> @@ -1261,7 +1261,7 @@ static int isofs_read_level3_size(struct inode *inode)
>  
>  out_toomany:
>  	printk(KERN_INFO "%s: More than 100 file sections ?!?, aborting...\n"
> -		"isofs_read_level3_size: inode=%lu\n",
> +		"isofs_read_level3_size: inode=%" PRIino "u\n",
>  		__func__, inode->i_ino);
>  	goto out;
>  }
> @@ -1380,7 +1380,7 @@ static int isofs_read_inode(struct inode *inode, int relocated)
>  	/* I have no idea what file_unit_size is used for, so
>  	   we will flag it for now */
>  	if (de->file_unit_size[0] != 0) {
> -		printk(KERN_DEBUG "ISOFS: File unit size != 0 for ISO file (%ld).\n",
> +		printk(KERN_DEBUG "ISOFS: File unit size != 0 for ISO file (%" PRIino "u).\n",
>  			inode->i_ino);
>  	}
>  
> @@ -1450,7 +1450,7 @@ static int isofs_read_inode(struct inode *inode, int relocated)
>  		/* XXX - parse_rock_ridge_inode() had already set i_rdev. */
>  		init_special_inode(inode, inode->i_mode, inode->i_rdev);
>  	} else {
> -		printk(KERN_DEBUG "ISOFS: Invalid file type 0%04o for inode %lu.\n",
> +		printk(KERN_DEBUG "ISOFS: Invalid file type 0%04o for inode %" PRIino "u.\n",
>  			inode->i_mode, inode->i_ino);
>  		ret = -EIO;
>  		goto fail;
> diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
> index 58f80e1b3ac0d5082c24b5dbfd064cf5bff7d5a5..494d2ae4c0955123335a97f23672b959dcc9e0bd 100644
> --- a/fs/isofs/namei.c
> +++ b/fs/isofs/namei.c
> @@ -100,7 +100,7 @@ isofs_find_entry(struct inode *dir, struct dentry *dentry,
>  		/* Basic sanity check, whether name doesn't exceed dir entry */
>  		if (de_len < dlen + sizeof(struct iso_directory_record)) {
>  			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
> -			       " in block %lu of inode %lu\n", block,
> +			       " in block %lu of inode %" PRIino "u\n", block,
>  			       dir->i_ino);
>  			brelse(bh);
>  			return 0;
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

