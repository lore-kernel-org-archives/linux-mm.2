Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16756EC142A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D186B00E8; Tue,  3 Mar 2026 06:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D4E6B00EB; Tue,  3 Mar 2026 06:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5089C6B00EC; Tue,  3 Mar 2026 06:00:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DDE76B00E8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:00:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D84591C41C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:00:25 +0000 (UTC)
X-FDA: 84504458010.08.9B3FFA6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5980D4001B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:00:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DbtHMotC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gsLHqQdu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DbtHMotC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gsLHqQdu;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772535623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhnbMNQM0zK8uEsXfKabt/iC5mT7FVi91m1UyqMxpMU=;
	b=BE6On9S7iUe/FSWm1L1bPcLyGSuSZKyTxemofjB6uXc0drMCHxYluHTa1ToC6P8RVKyNtK
	lg8kx0Ii5L6GYEz/TYO/oCBanZVPj4ZhWi5U2odk2lrkLFoOJk6dbYoC1kNCi9/kiKZs0K
	1g00TgmhkSFCkRkficmmrMpQWrKiysE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DbtHMotC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gsLHqQdu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DbtHMotC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gsLHqQdu;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772535623; a=rsa-sha256;
	cv=none;
	b=6xplXFn/vZIz+oOx57p01FQGYCWE3P71o44JQ/nnzY2MHertTgKs1zLkXYE0QQ4uKOVpMU
	AOTQ4blp5EUzUuYbIWcO8b9sB+r0m1fDVZyUFCzXuJS0YiK1m0pfBR4HVToh4M0wRGtDXz
	o8mW3xSRHSQiIFIfYWUXrMBigniVfE8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BE9355BDED;
	Tue,  3 Mar 2026 11:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772535621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dhnbMNQM0zK8uEsXfKabt/iC5mT7FVi91m1UyqMxpMU=;
	b=DbtHMotC2fkwuee89xKeRtFeVp6RNaKShtvPGfZmXLe3xysZMJabVOcmgCA0AFlJfgenpn
	k+NGM6F9rabVCF2bQMODitFZHUHgiZe9+QNvAINh3bP2dSNe6mGpV+Fh3WnbAgnU33aKY5
	Y+KyhmoXIr+k0O9oDuUvTeBhpK7a2uY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772535621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dhnbMNQM0zK8uEsXfKabt/iC5mT7FVi91m1UyqMxpMU=;
	b=gsLHqQduhNKupVSKkzKyiP02Xq5mGrMXk0yXO5V/lAsHipIQ9azFjYPsfEHTHGqrxS61X6
	7Att2gAlaKqI68Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772535621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dhnbMNQM0zK8uEsXfKabt/iC5mT7FVi91m1UyqMxpMU=;
	b=DbtHMotC2fkwuee89xKeRtFeVp6RNaKShtvPGfZmXLe3xysZMJabVOcmgCA0AFlJfgenpn
	k+NGM6F9rabVCF2bQMODitFZHUHgiZe9+QNvAINh3bP2dSNe6mGpV+Fh3WnbAgnU33aKY5
	Y+KyhmoXIr+k0O9oDuUvTeBhpK7a2uY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772535621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dhnbMNQM0zK8uEsXfKabt/iC5mT7FVi91m1UyqMxpMU=;
	b=gsLHqQduhNKupVSKkzKyiP02Xq5mGrMXk0yXO5V/lAsHipIQ9azFjYPsfEHTHGqrxS61X6
	7Att2gAlaKqI68Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A81C23EA69;
	Tue,  3 Mar 2026 11:00:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oOQCKUW/pml1MAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:00:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5F742A0A1B; Tue,  3 Mar 2026 12:00:21 +0100 (CET)
Date: Tue, 3 Mar 2026 12:00:21 +0100
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
Subject: Re: [PATCH v2 001/110] vfs: introduce kino_t typedef and PRIino
 format macro
Message-ID: <qgxgwukvxgqggl2gd4cb3jt54ocvu23p3qurzwyxhtewtsu2sh@darljhcli56k>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5980D4001B
X-Stat-Signature: wonr1e1p16pet3z3wq33waxydcog5ud4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772535623-106686
X-HE-Meta: U2FsdGVkX1/7OI5LSYIPlMaW9ZkYl3O6vYQwAmZ80QJVl3yL8zIiDaZNyvWlMC4F1OHhiFkKUuDFouVAOx3h6nbgKqXWuUNxQN3zWy2ey3xKpMPXezi9/bYfusTc90ojOQNHj+T2iV7BNqb/bDRDkEBBDzNcRWsV0R4XOwDlOAVog3CmP5oRQUZZBwWY34Inmd3hKJvBgr2flCDCkr78Ntq/movf4o/LjqTivojhI7pbSUdtQBc4zM7vUVNbBI7BNP1Fzby4Yg9kPrfbhl9DCqG7KA3BDzlU0yJGYPE/Lk8p/2wqYIDXtaNcXsZPIYt7YiDLB5yqq5IwawTuWpQO5sK6b+wN7ntnEQtVR5gUxx9VtlmzbYl+doXyS7SXNENZHBjLcVYWJyegHIEfRrGIniMw4ZSNOKjzobuqUO9YEG0xQ/qeUNzgbJ9Bz/tUpbZ3C3gAmHBHfHVe+SXXqBmPTSfSHydypsM3V7XbVJrPpwxi1L5ccaWR2On2iJ5e3sBcXt5IDsi8lzROegeL3e2Z45qEMNb4xMjdh5oqLC7KXNc3tolzHokcx/3BcN9wE9oqSbLpYpvrlOmTjqZ3B0B8pbr3UedbWDxezm/K0Kf+G8ymjd8Bv3NbZUpVwXpg3XXcgUGYd+HbgkNkT+3i5Pni/zvgQEtA0dUxnUDxFchteUSdKzVyESzvs32UTOAc2UrBaCBdczLNkTgYt2hFzIzo1xxayQr68gvoctmN2Cm0yEF7GfZuFHtodYo3Sws9Xx+rxbPfqCkyntokAaueFzdyhuhSRztd7Lqiaq8U0mTfW8AvJl+BdU8VEysTx+OwdqOPpOfpLPQKsKHoCwpCNYs8AwDzlgIbawCtHSXp084hCXyc5gUJYB6pgQf0ClKJYOVrna9xxXDF5kGfzMG/bzFWUkFgsW7t6xF+3dJDwE50vb5/7WuGQgkPUEOLQxIes84VRRreCcwUBFaN0h+CbDt
 RZ2B55xG
 sonpTJQD4Gl6BDU8LxUfReoh9wASUD80rq7HzH/LviSxwNz2t1eeHxkKLpxkkozY2ucGPvqLzG5j/lEE51Wc6isGKliV1uGMIZ24DMP1dwwSa2Gzgulp9f3aJJyZhy1lOSUfSy5JF5uJcFOGFWBtnzemLReRFlO7hFp2EiSgf3MhJn3wXXSYJJEvJy920KhYjWbh1aompEEmiTSwc1EcPbTJEJDFxCWlV4rLnC14fb3sVximxsY2yVqe1+jfrnBp0aVKZlIb7KQ0XRajxXLW1K82OxoOd69Jl4HfojNG84zDWb2pgT65xmMDfRB4JvfaA3PaoGpie/zB/+BhFmUyyN1egPRSVC7w9fbv3hFKlxQR1FBLwfToFHFBQW7ZBSNQ0NM/VALc/C+6qEuMz+dBIa4VbNDwWlgIOq5PYaKkYVzVIDDkztdIQ744w3FjnG3jFfWaxwClR3xRA4BzRORpfYtecceOXnBDgOtg3uVHuy+3xbvaiOFIC1JdCVeHvNi/Dps85qZQ3+rfRpZWXBaAV6gapS9AfYByJPi5ZSSr5Yo2Eb7WR5isyxdkS8XmBawgahO0FiqCtzc0pM77bA73JxSn0bm7LJcOtKW6w1afqEAmHYY3ngPPMuiFbyF4Nj705o+qSMFCrIzTqEYw9bIr/PnVXDr1pGT6QUj9mZIw6gNJtNJpMr/aj+ha3Z44sEwWXo3mXPUYZGaSXVdYvUdrfRheYr44foi9VQFO1zPvLOuFnU62txOz588uthDEWIBzEnRN/Nji28JJawX+vdsKcXx6hjt0Opci+9dI6isKST1aWre8L6jT8nCHUd8K6ZYBQUFBYA1t/P5CYLO6kiPHqDzl0Jm1r8opWmXQGPcHG1sGUPYvo7n6KDIcySu0DGb8MgHvK9eWRNQYWGhp22u0c+I3Yq0IBhKHloDtb5OAjxHcPTUYHQKE0fZceYANNqpA6TX2FfaMgpoWH5F5WP1AlM+WFV6CQ
 +yXrevBD
 +irlOp4XfmDFtCpITEgJVlrNZ8iuac+W3E4DgWI4r51qvjAMciqnaVNCZ5Uvvo0phJc/yj/3pEi7W5lnrIV1roVKKYTxrdCTy+z5mDfv0555INtFt6gMFa2T3F9heqHcMT0L0HJm4fxEiybDRChHDt4nqYPMamxg1peJuxMtFeNN19fyRoan8EG8MB90rIAC9NIR531tgKNPuFOyx8yU1w0J3aGPC490VVJo4sZ4rF15vIyva/ZPjixmt/tqR8cmK41GclX5N0PsU2rA4CC0sjK414BUU5iE/aVySeFxFbfQRm4u9YccRq32QvNNHgnIWLpNOAuDX5NtmiTAOoL8oc0Zn+Dbc4/1H18P8FKwb2UHgKk561GJWRtpINFIuQXOXy14QHqsF1J0U0kMtC/goMjtOk1VPwDQtY3Zb4QvoG8rBTYmwsEOmixjMVClAL8SHyI384p816I2knToHU2aAzK85L6cSMh2002ZyfvptFBGlHm2aIbNnHbhgLv/NxXRfrCuj4mKWFVInsN5V9Se/gQM8JEBFUf64RsjRXWBpsNl/v3J4Yya9TWv87GoCjx5gzy6IC21YCCjtvAXXSw9UeHqzVhB+cpYn5RTwL5b0hRndTeduE9VSI9t6X7m4VMT/JmD+KfKDNcislqP54l5iRK+YlZ0eHT/tI1AWqd/tod9OI47Y9HLDaZz1DjVwbxKrjiaQWm7aZFX+/cjplBAu319tgRPc8b5lKt2n6e82iVAeRELlpZY1op0CbdDs9F5omOaG8zBuWojCeYHDQ8ke4kEtrEy3SQSE/V1fTk5fp0H7htc6wn3uh14L/av3MMO7EK221mCkcX8Y9M/lVVr0oRBueaZEnzzUNMLuI2d14SsKgfxBEIkE1atx1BUn4dbc6bVUbIWTHn/9g+QUswcyfSVbjpi96JFHxWvb6b2a/JTDin6EO64SsN+hM3YSyRy8XkNawC9KtEU9qRYGN+lIWbE6b84U
 wbCBmAQ0
 iEZKa66u+OBYqSIE9tQlFL1KAiKwZNeAysZVUchnodfPR6JdPru8PKKq3Osqw8Ro88lPjgABCXfGna/csgEuPDmn3/n98tH32r2ejHqwfyNrdw7romqQxQQKA5TmK1OFAs5c0gkJ9T9KBoupd5/6FsA1RsEunr8zve/KMPyVxdvE4OrnWTTNAfZgT8qXCYrwv00V8sjRzAvhYLolxQz0gWGqqtXsLt5XEd61QR2YUjfbgZ1rTm56mFzONQleHQZ8XTqhx80Qc/Ko34SmhsPTvVasNTZ5mmtRKwQv9q5z6PXKUvmQiztYAAk1TeehD7imxBD7zjWYVdpYG9Cvtrpa8K4B4cR3GswqQfohHRLDrongUzQVHr1edDjzAUQGlae+y+x825vydhf6ilkvIbrSq/qyrJ6K1MXIuL0seQOeZzHYHAVQh86u3agCGWFG518l6GtpZfnKvr8sqfNzBr7TirGqo73suzjALzNPryTMGDPSNfm9VGAqn90qNyNoPlekfZVZRen4OqwFE9nN7SWRrKUg1UsYMg5DgSoEyNvo5YDfGJIWNtW0g1URdzWzJ3cYDzIwNaNTZMENlYnLINVwauOWmN+Apdh/w0V0jiGT4U9ltdgfalehMf27ZnZGEc9Tcgbx2a3UsAhPr5Mk/iP3y3gCxb12vDV3jliVI5oALUTL3thqabeLLhFG25txbZ2xr/b4jclamq946W6wE0M72E0PYiQ5at5HUXWw0KPhQXhWLQuUc4D236Lsqnyj3GMgS7dEfg6WnjeujoVgoh/jKJ96FzWEBs7HuHV7QoztHcwOxUXUbSkrIdPmw2OD5dMoTIfpbkyJ3vu1WLaoQuvf/CcAQuTruOyK+SClpWPIXXcWcJP7ECliv0zGuSHt6JJLU/nwnyUSjcYXkknryUqzxIZH0x9rparRk+1M8Aa2Kh/gkJn00jD0B57Rp9daS780t8cYG6KyJ2puBlvOdA+QY+W8iG+FW
 QZhiWZ9q
 rlcF3F0d/EcJbiRUoe+37b9ArP30ALtLCg9rp6Znhiskh35NOyFWanG4U1+LlGyN6Lg5/82RTBJNUv6nFfhwjLP8m8MP6O3i0asbtq3zilheJnPzf2Z/tP3Q6g8S4RyxAGdhf03YMDZt6qGoNxc117WbK+3oTjunoXWMqr+2WwBwWH4uV59CTxlfUXYC/2h+p+fwj0rOKOESXqHTQOCl7fTIjJ9Dv+tPw1aZmRWSWTIEUjmanXJ5bXrMdDzsabdgZhSys5gSxi07ddZNqj2LWNTVq5nv9uiYKgmJFNU0F1LQcYn4Nn/6yz7Fal2RRGkM7WL7poiPniG53qU9V6GawFnBNbe9tP4upzvbi9COJAl4MXA/oQ2jUqMUPPQ2imHeUEBWGrjTMzcgsUNjl4gef3ldTtDjdr/ziUOmMvsaSI6b15ThNAwE9l95+XcsgnTq/pFfVgzJjDRQEzjpc+mBC9juxGnjmXa1sW1Q5ksypuAvXe69jrBrG8aqVme4QuZss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:23:45, Jeff Layton wrote:
> Introduce a kino_t typedef and PRIino format macro to enable a
> bisect-clean transition of i_ino from unsigned long to u64.
> 
> kino_t is initially defined as unsigned long (matching the original
> i_ino type), and PRIino is "l" (the format length modifier for
> unsigned long). A later patch will change these to u64 and "ll"
> respectively once all format strings have been updated to use PRIino.
> 
> The PRIino macro is a length modifier, not a complete format specifier.
> It is used as: "%" PRIino "u" for decimal, "%" PRIino "x" for hex, etc.
> This follows the pattern used by userspace PRIu64/PRIx64 macros.
> 
> Format strings using i_ino should be updated to use PRIino instead of
> a hard-coded length modifier to ensure warning-free compilation on
> both 32-bit and 64-bit architectures throughout the transition.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Yeah, as a temporary solution for bisectability this looks fine to me. Feel
free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/fs.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8b3dd145b25ec12b00ac1df17a952d9116b88047..e38bc5ece1f360d679a8f30b8171292f7a65c218 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -758,6 +758,9 @@ struct inode_state_flags {
>  	enum inode_state_flags_enum __state;
>  };
>  
> +typedef unsigned long	kino_t;
> +#define PRIino		"l"
> +
>  /*
>   * Keep mostly read-only and often accessed (especially for
>   * the RCU path lookup and 'stat' data) fields at the beginning
> @@ -783,7 +786,7 @@ struct inode {
>  #endif
>  
>  	/* Stat data, not accessed from path walking */
> -	unsigned long		i_ino;
> +	kino_t			i_ino;
>  	/*
>  	 * Filesystems may only read i_nlink directly.  They shall use the
>  	 * following functions for modification:
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

