Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BC70EC1431
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1DAF6B019D; Tue,  3 Mar 2026 06:32:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADA9B6B019F; Tue,  3 Mar 2026 06:32:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E736B01A0; Tue,  3 Mar 2026 06:32:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 832396B019D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:32:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C8AAC01C7
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:32:48 +0000 (UTC)
X-FDA: 84504539616.18.0266718
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 122E2100005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:32:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HfJjB9z1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AElBCnhI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HfJjB9z1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AElBCnhI;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXP9gapkvJkQwmzCnRQCpwpSx1/qOrmg7rRUhHTzz+E=;
	b=orTd5WOc1wIoMlukWA6NHP5nUwUuqwx0+FOr50dwqKDpoSm2BwFeI8H5h4+vNWRvtd3CjQ
	p4WQq430/mh2kdZR8XsP54hIiZMmqrNfjnT6xkY7uNfe9kS9c1/P4MrhnsoLJ37g8QGv0E
	KS3tPt3/K9GxxJDZvDIGEP8NRNYdmZw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537566; a=rsa-sha256;
	cv=none;
	b=BX2RqZKU3hfP1aMhyi9LlNmXNtoARBhDL6hKToqy7hmg2d7k1O8XSofI3B/8BKWJQzTxeg
	YCyfsMnKaT+J+a1N874iDYg/N4UPPZo+5CPtQxTtfslJie17vQEi5FHNvutIgaXRoETmaI
	BZ843lRmcEtFsnnqOnmTkdjJ1bitqW8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HfJjB9z1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AElBCnhI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HfJjB9z1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AElBCnhI;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B3B143F959;
	Tue,  3 Mar 2026 11:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537564; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iXP9gapkvJkQwmzCnRQCpwpSx1/qOrmg7rRUhHTzz+E=;
	b=HfJjB9z1513Kp7eff2XsY+fgu5N3lYrgW5QmS+gRImeA3LnL+qnr6dE+Mth73FU+8XMCW4
	Fj46WBAPxTvohb3FCq5NTFT3S6oJjdA8jy3hzHCnrJHtHwc0wu3cPeFqx8z30qEcJO52If
	kjnx8zsxDQoxya+au9IePYorlhmHeFQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537564;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iXP9gapkvJkQwmzCnRQCpwpSx1/qOrmg7rRUhHTzz+E=;
	b=AElBCnhIP5Bu0X3IX90FwwyrLkyZJjJcGtGikQEIRtRytW9GR/hFpndKZOiJIbxDGhEVfz
	KCmgoQOSvLYJ3BBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537564; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iXP9gapkvJkQwmzCnRQCpwpSx1/qOrmg7rRUhHTzz+E=;
	b=HfJjB9z1513Kp7eff2XsY+fgu5N3lYrgW5QmS+gRImeA3LnL+qnr6dE+Mth73FU+8XMCW4
	Fj46WBAPxTvohb3FCq5NTFT3S6oJjdA8jy3hzHCnrJHtHwc0wu3cPeFqx8z30qEcJO52If
	kjnx8zsxDQoxya+au9IePYorlhmHeFQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537564;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iXP9gapkvJkQwmzCnRQCpwpSx1/qOrmg7rRUhHTzz+E=;
	b=AElBCnhIP5Bu0X3IX90FwwyrLkyZJjJcGtGikQEIRtRytW9GR/hFpndKZOiJIbxDGhEVfz
	KCmgoQOSvLYJ3BBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A05EE3EA69;
	Tue,  3 Mar 2026 11:32:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AVQgJ9zGpml6UwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:32:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 64588A0A1B; Tue,  3 Mar 2026 12:32:44 +0100 (CET)
Date: Tue, 3 Mar 2026 12:32:44 +0100
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
Subject: Re: [PATCH v2 067/110] proc: replace PRIino with %llu/%llx format
 strings
Message-ID: <6myy5axw5zn3e3gtmxrfw2iynowkont7dc7mm74j24cvecrewb@7qitmwzmad2k>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-67-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-67-e5388800dae0@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 122E2100005
X-Stat-Signature: 9xy7y8558fowph6f84jnnsjsp3zemtmq
X-HE-Tag: 1772537565-173644
X-HE-Meta: U2FsdGVkX18hD44m0qtL/LKbQKdSNBPQNXrcsxefauFByQR/PmCSRo2qMuw4nUy6Aj9zF/VI6eUucq0kGwZ5f8hAfVlAObYnbgTFkkkdOHwNCsmGHNcoJT/QRlJFTvmY280vIyIMpoPX6j8spNT4EFi2htcYxci5LIUuv9tY/61O/60cnMkIGbLchMzm0xvWtucmnjpN+3aZ6UgD5y3DGnyXXZ0b7jNEepWzpKPTqo6bGlY1vnYN+79aZzQPZe7Y0wDZKpTsJA/IlDgLTucRCwlPiHbj9kIsV5zpADE1nuxufQgBXzJMPB09imk3xYp/iYfy2BmyCdhpe2+ATo0JOLUSg2+Ir6w+PbKc3szEyasBH2V0iWWsrLIaNBhb4m5Jl/UndaJIFl84hedtEjVJ1SoUTtmqF3ftz3FHlwKQdb4sJTx3JzIiHBBT3hgZ9OJlLNvOJUcDYwrc8aqAfTGmctIkmyIFcJz+0SljjCUI9hq1FDVNFS5bpN5xNu/LwcNE5daSXCWoDbng4QwBxu0KtuVa6iet8r2/XkYNIMxPgjpitb+FL3pNdxWj4kN6eeidmDo/eeLR0LIbMHohQjLnfDKQKKsVkY3Nw9+akimov18c0jZlsxEif9hfkgNR6RARa+dgkz9XFCDcj25V2c3EEhIxgc30A1wgXpAZcsg90l0zeyfCZe2/9MbPFfaQxPdWDER6cPFPDm2xgHhZnWEAEF96tjgC8XbudpD/jQEsNhCSfxt4pju9K1xrmrOXv5Y4QJ4roKL3ILjKvcJ2GCUCw5u/OvHWlotSmWGOPvpBrKFFKsu0fwQ2G7s2uU2XkzZ3nQQ9rbc8sJqMTRtisxixCWRZP9MczFNg3j4vYE3ZfweuLrczK47z2rXoHn9WXxd+ZU2lwUKwtwtZTaG0+3bPCZb0PpG3I4TYQ5Sd2BQq8aegD7Ct+rvlbBFJnOx5b9Wr9sQRN6NxbLboNlTqevJ
 q8eRTCYp
 YXdNlMmJyi+7WzmhuXjV1AEp1cErnQUnxjGKXW4RHjNrImyI4KeqJ+Zgqk8cHttPsZzf3EiPYbNJ7al1jkBMhQ1Cjq3S+Vwj1W8CtyRnHV83U5B6ETORNmoMfJDvPqspRRQsWpPtbcAr4H/vWYOH+xZDjSIc6qwtVekEd7D9LsS/AmyELtfIiDyHz69g0u7tgRHQGL52PMI+70qmTz3pvuAlz7X/g+GDHvBc7fpTo+ihjSNpyDfg53o/OpM68CUOyH5fOyRWb1YUp/7pB++MDGsFwdIZOZqbRJkuL7ct82Jzz4cy4uck/j9Vyf32mvQR/M2PXGNViU+Xx9QO6Slt0xcuCFItq/0LLy29PffIVi+eS0FkyELH/sfoTi6wMuDwdkjuDVYTXJXYnwy3Pec4RKcjdvytWL9QkTBiyIvgGKV/jclhynoF02vtFadlXSVaarG4mfu/ILbudDhRpys2+KTi02Nt6BhlXCVbsxhVh5vxg/Niarzq69T27nBUdvCfGtYN8XK0W7Tnef/el76np3YBWovj+ydHR7f+6T7XOUh8vVfHMI97r85oSPglYNGfGjiggaQGeBu2vGKy+DuXfLlM/g1QnzrRFpYJmETznS1bn4EAG2tmMqdwsnJBLvLnVtL0O7FAqaODh5Rp7IDfJMQjEi8Pn0/HzkGXfDw7yggsvFRW4UmIcVaXzwEnMJFkumnmKCAAbaoRIXllpEl8fK1tUy3NqXadFXuZtY9jBvzACMTMaUuOwjr57Oq7dDZBE0BfxSnIARb+X7WSdSefxjt/1tKw20Rtd1sxxNMBMaWFbgInVQZF8/kwMLb4IJOVcegPrD7k/YMb2vTAtgwA3gc6Y6XJN3XB70BsPVgFXVXYR/MV06S5i5e3K7upyvLTSx7P+6g9/HYMt7R2PwJcN6E4pry14tAqtZv6wH8gnthPGvLNrIxmcF5K4KrynHU1VUa6fGHuaUwdMYmWaWif7TAyitMo4
 3Ju3qNGo
 zvzgc0pWX+smF7dCTcJ494+ZeoWv9WOOct1jYeAeEZn3wcubnHvWg7hsULGQp0lxggNSQTvlc/Y/MiTk5A2alEHW76gdnPPMqlH+WA6bG6xE4+qfkMgz9hs/ys7B2LF0qYNJ7qVUU+NNTPpW39rOFtoWSz1Ln74koXPcXpjJ1JSLTIkUvI4Z2LVrkk2yWLFr7HcKTKSkG4iWcSITLvr+Vsad4kWFd0V3ObFyjiCsvouMt5XkfdNbpHz+qFXJ35/QimMp87HKBhHSS+ZWJN+m8fOCyItvGzHr2BoN0kU94d28ulTEVtbblvSe6nrmWodpm7pNV26U+/60GN9yxfOeG5+IyAHdc/ndVVdFR928R+dqbDhMGMCdAOHK5Jn1ITRz3C+5BZX/uhFcp95cmpWWMgxr+Ko8nRydpKwI9prVJvCJyhrHY2RY62u2RTZaQfLR89tnUBNFMYD6RjNun6GPg/LSXpMeDXbxvhQDowUrM8p7N0r6jSq+gsvLAe72IPs5geJzPMv5veg46UAoYIAaRSF8wx6m15f00KHvpAemPg4+G7qd6OB8ErpIxqfj/alojpri0zq+PQ88aexpvuqQzI9saA/L/HHi5fnN9jhy2cKZil9bN80dFUphOKBUV51EIElXw6WlN1O0nQngWl9AvFiHxS1SMKG8N3rfSdUg8qp0zh12o4w64owCz89eRMX4lvs3+xVpJczu8ImZthIHn4pYlfeN903/QebbUfMNlI/qhHuJJVFcyrpfLlMMimkJGTFmgXTvd0v+I2aCl4PZ4iw7xqbZytgLTfrV8/aBZGgPQqs4CUSAsRDnIAmsG5/iO9olyQiu02BqsRVYgOv/DbTA/hGKcuPrzCRjtn9uSzT23S8iS6pKXTjTZbYi3ffaRhBE5KuR9EVrT90oFUSym/Tzljt+jrpd417L6l32yuD3+84wD3OlJv9kpscu3a4c4UrnyDDnzkWM0SPr4eSdPJG9fw7kQ
 ZrOVuWnO
 UwMdPXKqTbNpmsLM874B9BSzw5AkCsTHeKzsx/lNMzIy+W43aDXvR6f24n+Jur81nZqPwaGRke6MJ0Igw1oBxLIwfL3VIVWQbgPqzGaNrjaT47rtBhER4J1nXpSD45Ad6qdahbeotIU9BQPNFiOFgXgKNfo723GgwvsjnXPGFXtkLsqGxEdiatVid+DJ7/8zO+J6g6jhnzqjEAzpll2GlRXteErLrlC+KxnkMd6ffE4pyd0C0rgcspWFxqc/q4LpwxxFNBuH6bMz70uA5adbWQPs5fEH7dG/5MC6WBdYSIAENKn2ofthWbOMKq+2YO6k8fF9rkXiuMYvAwaC9ARY7WZDxKZPmjpT48C4F5wJHRxbsWzRp4KMTV9ZlCAoi/Nub8XXrJDUL/QUqP5dn/rkbcxYuwh0HgcDa49vPjxMB+XJYMT6wRDoDSPmSvwqRPT4TlmVgVoaPpiyQR2h6kxYPFYy0No/jrCZHEMfjZJXw+dl0gara5rgzVPZvSF7xSnHugDAgJUiKO4mbrNJnupcKczoisNSq64U7ZTm5dp2ztkQGS+grNkLVMfJzgx+SZnVR/wWnL7pu56ETziYuHGyD63dRWQqF9CDOPegvOAUoStjM/6C1b7sbdVZDb1kUvoWHtIFVuDfbIdR/SjO9CWU7EHfydDQSMGXiFYObMzsirhcVFgcxR3kxId074QggZCioR+9mGA39aKeOiFLCLTeMFGmG0hepIfsjYkUUTZtB9wcTFSQuo+5x3WVVZIEeHmz54sCD+3/Dbzov/flL0o61Ik6w0Llupe+zvVz9BsfchJnNN7BCL5rigCPwj5XKhPlld/fXKKI6wccd+8SBTMNTX/303HVcAdzMNVgAY33Cj53bvVjj/1OQ6HxIiDwP1shhuvrBEje8dIIel6NMJ22ww+gk09wSmB8aUonXP+vIP36X5EvbzcnOCX7+ywN5QRH+Btdlxg7i9/7zusCird3/yVQC/ynA
 /aSMbTlZ
 E56KSG5K4san6fp2yA1LN8r1fj4/2VvAxIpioUZqg5Yfm+/PJSRSXQ0Rv+T2o/0u0TmJ/ZvkuUABYhYApTNEA28Te5EwAXscJoGl5Km/heA9cTrBt+wXU+qCWauf+9gaepQrcJM2W7x5VaBkw6jlYwvEPCulnD2nMES+ZAI6uyK/t3p/ocpQXq8KqA/OQ2v7Xqx1tttEvZuPpjhXr6InT5DD15arVEEwXmHh7Fj8f7/eKB7OIK8ugZlBjU7qUBjSM5o/fa+BRbtRiUww5aSBwqktZ0peJzpQD1zLuxJYZgZuWHN+wFjjZe6qnEg5/zJKnV1KPugKHnjwVu98TQfHIIymVNRJnhhc70g2np+v/CDrtnqYjEbWZ6eDkIuL1L/9qomxi/9rZhzYfaJtK9jGgHbxrnDlALX1qsO+Grofmi9u+XLFitqIjyK+VSJ2jzEYqBdoE5A7d8tUJd+sRCD7Vo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:24:51, Jeff Layton wrote:
> Now that i_ino is u64 and the PRIino format macro has been removed,
> replace all uses in proc with the concrete format strings.
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
> index 936d0258d688be5fdc384ee5c4dfbb8fa0d19dff..aae1a83e884686471758703634f0d3479e77c9a7 100644
> --- a/fs/proc/fd.c
> +++ b/fs/proc/fd.c
> @@ -54,7 +54,7 @@ static int seq_show(struct seq_file *m, void *v)
>  	if (ret)
>  		return ret;
>  
> -	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\nino:\t%" PRIino "u\n",
> +	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\nino:\t%llu\n",
>  		   (long long)file->f_pos, f_flags,
>  		   real_mount(file->f_path.mnt)->mnt_id,
>  		   file_inode(file)->i_ino);
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 702b0f0433f91077cd0d0af4a07e9d67d9fa9a45..751b9ba160fbf15499555875871d727644b0df44 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -442,7 +442,7 @@ static void get_vma_name(struct vm_area_struct *vma,
>  static void show_vma_header_prefix(struct seq_file *m,
>  				   unsigned long start, unsigned long end,
>  				   vm_flags_t flags, unsigned long long pgoff,
> -				   dev_t dev, kino_t ino)
> +				   dev_t dev, u64 ino)
>  {
>  	seq_setwidth(m, 25 + sizeof(void *) * 6 - 1);
>  	seq_put_hex_ll(m, NULL, start, 8);
> @@ -465,7 +465,7 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
>  	const struct path *path;
>  	const char *name_fmt, *name;
>  	vm_flags_t flags = vma->vm_flags;
> -	kino_t ino = 0;
> +	u64 ino = 0;
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

