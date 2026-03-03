Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB7FEC1431
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BABE6B019F; Tue,  3 Mar 2026 06:33:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278C66B01A1; Tue,  3 Mar 2026 06:33:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1304B6B01A2; Tue,  3 Mar 2026 06:33:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 002EF6B019F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:33:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCDD41BE32
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:33:35 +0000 (UTC)
X-FDA: 84504541590.15.CE192C4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7F07680009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:33:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kpuEv/ra";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=giQRaJtY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kpuEv/ra";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=giQRaJtY;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4DdREtNiJiOQrLwoyUgGYussCYHVyIxoDajXjekPXE=;
	b=ZSEPfbfa/EsmXCtKbL6NZiZLxbufcih625ni+FpR2hE1t0Kjlkwx5194GZNTNDI7b1gzMJ
	cGeKwIDSDRRecBUJ5nuUETplxf1MCN8gSBjJU1pFIB8vrcW5IRG/hq26R5GcJcOEn+XSG3
	pPKjPSFOd7zppSuAwlcim3LSjklwqic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537613; a=rsa-sha256;
	cv=none;
	b=TyRLQ03aEGwV8cRon9d05Dar/g7ZmroMj57tXnur0khyl7M8G6FHLq1U0wczoa4uBM+nIf
	7luFL7Dlr8b30dQYWYheWD7bPqYI4qcx9n6Ze501hTBPfj0i02djrS4VLu9uVxYcC006tb
	IbB8ki/CIG2EOb1tXXe1la5cZrdb9+o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kpuEv/ra";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=giQRaJtY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kpuEv/ra";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=giQRaJtY;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 14FD65BDFA;
	Tue,  3 Mar 2026 11:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4DdREtNiJiOQrLwoyUgGYussCYHVyIxoDajXjekPXE=;
	b=kpuEv/raO0eFZTfGUyM+Zp0J3N8d/BUc56ofJM3npHqMnUodITGE00WQXx2aJzIh8OmGRi
	djUl98VPvFOmJaF3RG8TbY14u/wNVNsNbpO2KCdHXd2JhDtNcahijqb6GinSQeIx2YF7dS
	RGFXs8NFjCMxKc9DFVPaDzIwBAIpxzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537612;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4DdREtNiJiOQrLwoyUgGYussCYHVyIxoDajXjekPXE=;
	b=giQRaJtY2xPj1wOFq6Fa2xMiBEgSBCEyj1CDFiY1PGUtyx5b36SikfpUlOrmAycGcKKEg1
	gOFGyXQ4XTv9MECg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4DdREtNiJiOQrLwoyUgGYussCYHVyIxoDajXjekPXE=;
	b=kpuEv/raO0eFZTfGUyM+Zp0J3N8d/BUc56ofJM3npHqMnUodITGE00WQXx2aJzIh8OmGRi
	djUl98VPvFOmJaF3RG8TbY14u/wNVNsNbpO2KCdHXd2JhDtNcahijqb6GinSQeIx2YF7dS
	RGFXs8NFjCMxKc9DFVPaDzIwBAIpxzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537612;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4DdREtNiJiOQrLwoyUgGYussCYHVyIxoDajXjekPXE=;
	b=giQRaJtY2xPj1wOFq6Fa2xMiBEgSBCEyj1CDFiY1PGUtyx5b36SikfpUlOrmAycGcKKEg1
	gOFGyXQ4XTv9MECg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 00BEF3EA6E;
	Tue,  3 Mar 2026 11:33:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id skktAAzHpmngUwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:33:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id ADD8FA0A1B; Tue,  3 Mar 2026 12:33:27 +0100 (CET)
Date: Tue, 3 Mar 2026 12:33:27 +0100
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
Subject: Re: [PATCH v2 082/110] ext2: replace PRIino with %llu/%llx format
 strings
Message-ID: <632zh5igh5dlniw2aboh23enl34csbfb5oizz4udz2mca55rxc@ncjzx2adt5za>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-82-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-82-e5388800dae0@kernel.org>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F07680009
X-Stat-Signature: i9ufc15hsk3k5ik1kimqw45p56pifgne
X-Rspam-User: 
X-HE-Tag: 1772537613-300598
X-HE-Meta: U2FsdGVkX1+fKNmEmuwql/jOIXpu6xhHU2CKcx8xfs4Tc3eyJQR95Loe/3dEDFlCV0HXwP3dzvW0UdrpsBOujdi102yuqEYgg8FV/lAW/mXqDKFUW2WjFagAuRUsKzYmN5xZRywUJjiW8q0UCo9j5hNFf2nJNc7/mxQIsoYS74ETTVRm1jAFQU2ydzCwX4eaaDMrq4vMKPFEo5gyeDGiq1vwqs17xgIIVJ/YVzr3fs+BVbCLOQI6LM3+C6O9O6UT54Nrg6SfLtO5pAOwH+g96obYBkDDXp94DBPbvB/JBFn3YA9IrGiJ75lMcQ4kRagEXk6lbwc6zlNIW7zKDrfdUBoEWdSH75wflCmsHXonTUjpXG24juDG5sDmMrPzO0fldnKXTBfjwzSL39kyhkL5dqR75Ya1xPoSwhmlG8gk+EAGsdkxh5c7Cw/Tb8q6p7UcZz8ehifJOj1dNU8lEUurBuQpyi1Uygqva4voX/pISX2xw0+0eTs3vDnrqxc/opXrNZoTjOmnD56Yil1q/Nquy0+kHF3x0uUfxTD/0TQmO2Vo3GyEEdmiNYnOzLOv1R5/K7MiV5IdTcr4TZVKdjxTcjbOgccO57Z2rvVtkf3DlU2zpTqvxlYu0rGoURHg7Ij59OKzrqNHX4bvW2M03VVORVMkhRsWG/q+dFagYlyppWXhqWF23kDZsyZwZ2CZ918Nmf17DJKBMpug3kAoP1kTUNpE9CUuabH/j+II9V5PvcKrqnwOlacM5jzMN6/K6yg4U7q9SqccdH5cp/F7XQ6tiUsy1W77SnbfhMqjP1ykxPjIlcOHj6MtaowHN8Rm69DFmNorxMCXP6RdiC7Dy43yj9hncaZSWn5sTD+GM+gmC1PusJ6cD3ULnCUH8vFXilz5cO4uoh37w2SU92mADI2fU5esMHlY4qIpWtoC2Xpw4MOEUutQ+kKpzePu+6z1F6KzGKtVsA5HqLUA+uRt6Pv
 yExBjTM9
 3IAO+UhpOFaywgmUdneFr173Sv5c1lEvl8moKBcnkKljldnuK2Y8sW/4qW9a5cN24+4AVdnw+YhD+9zRHNsyypW69wQY0rynVf4C3Y6yG1pUc2U8Ks6hnYCyans9MtUjGwnHkw3f38wY++mE2q4BEJGQZHXRSJDtjdA4+gfTnMNyld4KxLeDeVNnrl0W2dlrV2oCPCLBNN5JMCp5bl7YqX50tPc3TOGpWAdVoHG3IGgY4eVerXdRDeRfoWWmfJJP9MS03+95sgh3Jj8ksU0tTT4p4J5MWQsJo4mPOyTUGKc1UTO2xuCPGALQiglc0k1GNFf1uX+oLhXoxypOjF7ZE1t7BQjKrrm3sHmYMqaZYkrEGmPh5M3+nefa/mzqW3tcTQr3GV7ji4jhl5mHLyDddnTRGKJ/Es+I1CcBNqaeafRQKJYplbwZI3mMYU1YgYyLd5dte4X2dT78Yn7CrBuiJnnVFsH/ZdFe1bJgNA3pKgncW+yYRy2TOM5HDr0f/Z8YHyRQCMUoseP+8TKclKbhQkinoPbxLGz9xrXrwN4y+MspD+dnKreBceESTE/6d3zlN7CdopWlFyi0tgJE8rz38Z1rUZMyS5aaInAphQDZy+P6QEsyvZBtro7WcH3p1ckY7E6AEn4hd4JHJWSiZ+1Mm/ZqUwEjMRCQouNAHSxtFVPWu4bjxpefZEUCSS1KUcbuXR9jm2KMvgluevF/U+Ezvv/dihq+Cv/jELxGauFuuAZ24Xn4360TkFUJ5tp2JwSz/ImzvnZfMVrDS1LVy1uTU6qGRkl1KLazZ1YGBRzvbK0Q7yPd58A9HU8f6xR/WmxLZm/KaViJWNBabqRfpeAhpDcE6XgEPUOkSY+g55CNH5e9utnuI2AHzPApIeAMypDRH6XGUl9jvT4iy9ZdJTIKbwDxiWTMfyMbWdAgipwqGzjMOk+ZatqpYvY2RoM2jZO4eHSDFSvNAUeLLDlCrh8RsAm65XRvs
 jI59daZO
 WF1BHoLig79nQT9ILXepPSNzWcYpW1cUhxiO9lxqZuK43Vgl18uimumuO6vEG2t7AXCf2ngEJ40avMNtQWrf5sLHHACzpDbBow4EiF6Fsgrib4XkO35knlOQNc1/3Sko0YsRFY2DO/Nv8fMHZZXH2ruwTyelL3dxk5XKvYidOx3fbnwDs++M6SDSHeGbtQY6rfA0UF3q8GNDKGr4zvHhqFY9qLoyu+9tnHMo4abRC6ik60v6tyydBHoQDQO67feryEU75TATQ4bXnVkE4km9bGfKEmZ2APqgZmYMHpDxrMHJdE2KRi8t3rGbHb8yocZPWbK3HuBBoqOUs7Mbc7tv6JfF3KXXpnDTfL7mR4r9vgczzvFOhsF7EfCWL2LNNY6Dokia5uzvC4NGcJPVhOdQUimDPFSUS257ZTPKSB/kmMkc5e3fZxOcBcJ0f9JfUYcDEpJWM4Qqbcqp+U9qcPThndJ6CMmBd/6wKERCI2oUugRwKKdPypI9KvRQ6Q8L67XWt++eMCLIKCHipi3UBF0TReBFBwbTvf4PPKS3U4Rnk0au78JzGGoHEbS7W0vKJXDCcuuIeoIIzaFWLoT5yBifd8K71C+doYGfOyzkLfIRRqclSs4JHrAeptUBBEOifF2KInNRK1HGEjFPDl17WzDrywHDSKjlq4P2oMG8lC330ChXby8SLnYCZqD1ngi+8QfIBb33zY+iF8SvsqUD6uyuX3Cn9BVifGnFNEiONqwfJ/gvydwaArGPt98TIKyJbyqIjAmU7Qr4lAOp/+fM09FFvAJJy6VY5kae8ozIOzoU5iUTOxu0ud9ri5Ee6xzGRJQc35ILjM6c6ak1OULutN9EoKLnwPZXJ8uWIzhMyx4GS7JNlfsoYZcqnQI7jmQvCOw6sopQp3OxdBiyv6IdPJPzCxp9CZPltkJEwR4OS0ilOMOBnbiE7SK/9ez95GcCKv9x007NOxwBkOo/1fIf0wtmK3h8zhhQO
 IxHDbqsm
 tq1eNU9f/ZsjJdd3RcXU8ThLUIxBviZ+lcY9wz7fyhDfpKpqFjzgSun14mBhqVeq+G8GaCpUP/XZ8EQR1Wc4K9XALuCS+j1nBDusS8Ta27gmn7gHucFJiirKBedELPZNylfx8LJjH9qpnk6dX0Wrn44/Xr6N19l4ppWZsnNmVHJudOOuSx0R+ld5TatzhAjzE0jKEcIxzCrc8yZA5hIZ55pgXmbkFf0GgjqTRux7r9R8k0CUFUlGZYCWlg17muCftJ1lZa2Xg46hq7W+iAKLTZZ61PDtP8QiKQ5ZJeb1eju5Jh+cmB6qhFdZzAo1/zsf9Qfa5cVlxQQfgOXR0mHvYTn3jRyymmed3FW/PUr92BQ3rNSMEpcUmaRACNTJ//PYrbCBQlE/ldKgqbmuS9gbqlX5mpnUX6HCp/+spHrC0hFLclhWnfrlZjGzhOz8OQAgqvn7fvMDFNxdhklRwWCEXwQG8ZIHVzoAeX4DXs1Dh/WO14XYmxp1OuHaLtV0lIWEBfC/GGT86TXAYZT10++qSMoYxizWM0ZI88305hq9m+5MyiBo6O1vKsoHvvGabrmh56+pyiZUq8jzUPcxfDnW8beO7aoe4H6su4LblaKoOZ1ePROQuFb6CVRGw8vaCwjIMkw5blVd57w4phUnqqcE8whwmUo+4Dzxntl56uELWmHd/G2xJV/jDHFRmouBmAdd91ajFDxyV98ANBwWH2PS8wnK5gR6HcHHUVUFvdfhqS3KWeettF998ReB/RPqkWhH2tFmhOpGcTViIjtuO/6OWsWdi1iIeKnCbgG2z8KnJ7Ajj8HbjYfNvT4Zh6bpeDOP9h3MhRiqh2IICEjEmourT5/XPhhzgrN6O+jV0QlGA4uiAMeqPHfwo0KVTcCEmolV6hoiz0D96YaIwneMl5T6GFoahCt3FUQyJxPcux2AAVcSOwqr0JpwyuBlt2kYfVqtuGegRD8RQrgI8sAz1/earI6AVk971
 W7tzrQwe
 gF5L/F7xHOHBwbUqWI0oIHPpg2LUPPnhSoYGUZxEP7go2rJI9qwVY6SuG0eb/fMAmKcd2gnF0VlQ5PQmvFkbucq3evpcHjZ4A0bl4qAlbeZOfvGSnLKGlaphvM20MCEwJ1GPwuNOic4IsGkxC5phta35LlDwyAl8B+ziMBdfZf4ZZ4xcwDiB4FQ5svnGlySTfGvANH/SzMOeTbTl6/cPX/KBxz4w8z47pc6nr0YZEqVnC6ynTr27c/91A5jauKvykLAmfEnIeB7TUPQ/5pJajUX9R8qj1hGTsSYtGmT+5XiixcfCtXJyJvjNi61JCePLlTOGLbECUnTKCzcQ3MPtIwqqSMlDIvFyc/OmSWrXmYRT4a7bkuPoyAxUicbxYwS9wVVeOzoaIygPAD5uKYjRTSkD0jglag6oT0X4tv0IT51Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:25:06, Jeff Layton wrote:
> Now that i_ino is u64 and the PRIino format macro has been removed,
> replace all uses in ext2 with the concrete format strings.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/dir.c    | 10 +++++-----
>  fs/ext2/ialloc.c |  2 +-
>  fs/ext2/inode.c  |  2 +-
>  fs/ext2/xattr.c  | 14 +++++++-------
>  4 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> index f87106907da31bb7c1ca65c0ec2dcc0d47d27c62..278d4be8ecbe7790204b5ba985a7ce088fadb181 100644
> --- a/fs/ext2/dir.c
> +++ b/fs/ext2/dir.c
> @@ -141,7 +141,7 @@ static bool ext2_check_folio(struct folio *folio, int quiet, char *kaddr)
>  Ebadsize:
>  	if (!quiet)
>  		ext2_error(sb, __func__,
> -			"size of directory #%" PRIino "u is not a multiple "
> +			"size of directory #%llu is not a multiple "
>  			"of chunk size", dir->i_ino);
>  	goto fail;
>  Eshort:
> @@ -160,7 +160,7 @@ static bool ext2_check_folio(struct folio *folio, int quiet, char *kaddr)
>  	error = "inode out of bounds";
>  bad_entry:
>  	if (!quiet)
> -		ext2_error(sb, __func__, "bad entry in directory #%" PRIino "u: : %s - "
> +		ext2_error(sb, __func__, "bad entry in directory #%llu: : %s - "
>  			"offset=%llu, inode=%lu, rec_len=%d, name_len=%d",
>  			dir->i_ino, error, folio_pos(folio) + offs,
>  			(unsigned long) le32_to_cpu(p->inode),
> @@ -170,7 +170,7 @@ static bool ext2_check_folio(struct folio *folio, int quiet, char *kaddr)
>  	if (!quiet) {
>  		p = (ext2_dirent *)(kaddr + offs);
>  		ext2_error(sb, "ext2_check_folio",
> -			"entry in directory #%" PRIino "u spans the page boundary"
> +			"entry in directory #%llu spans the page boundary"
>  			"offset=%llu, inode=%lu",
>  			dir->i_ino, folio_pos(folio) + offs,
>  			(unsigned long) le32_to_cpu(p->inode));
> @@ -281,7 +281,7 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
>  
>  		if (IS_ERR(kaddr)) {
>  			ext2_error(sb, __func__,
> -				   "bad page in #%" PRIino "u",
> +				   "bad page in #%llu",
>  				   inode->i_ino);
>  			ctx->pos += PAGE_SIZE - offset;
>  			return PTR_ERR(kaddr);
> @@ -383,7 +383,7 @@ struct ext2_dir_entry_2 *ext2_find_entry (struct inode *dir,
>  		/* next folio is past the blocks we've got */
>  		if (unlikely(n > (dir->i_blocks >> (PAGE_SHIFT - 9)))) {
>  			ext2_error(dir->i_sb, __func__,
> -				"dir %" PRIino "u size %lld exceeds block count %llu",
> +				"dir %llu size %lld exceeds block count %llu",
>  				dir->i_ino, dir->i_size,
>  				(unsigned long long)dir->i_blocks);
>  			goto out;
> diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
> index 6a317411e54191578343308b5a3990aea9c36436..bf21b57cf98cd5f90e1177454a8fd5cca482c2f8 100644
> --- a/fs/ext2/ialloc.c
> +++ b/fs/ext2/ialloc.c
> @@ -590,7 +590,7 @@ struct inode *ext2_new_inode(struct inode *dir, umode_t mode,
>  		goto fail_free_drop;
>  
>  	mark_inode_dirty(inode);
> -	ext2_debug("allocating inode %" PRIino "u\n", inode->i_ino);
> +	ext2_debug("allocating inode %llu\n", inode->i_ino);
>  	ext2_preread_inode(inode);
>  	return inode;
>  
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 0ca9148583646812b478f01fd35bcad11498f951..45286c0c3b6b8f86a1ecec0e2f545c5a678dd6ac 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1152,7 +1152,7 @@ static void ext2_free_branches(struct inode *inode, __le32 *p, __le32 *q, int de
>  			 */ 
>  			if (!bh) {
>  				ext2_error(inode->i_sb, "ext2_free_branches",
> -					"Read failure, inode=%" PRIino "u, block=%ld",
> +					"Read failure, inode=%llu, block=%ld",
>  					inode->i_ino, nr);
>  				continue;
>  			}
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 4b3dadc0a2a47c85682d9c74edb900cf0f20996f..14ada70db36a76d1436944a3622e5caf0b373b9e 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -227,7 +227,7 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
>  	if (!ext2_xattr_header_valid(HDR(bh))) {
>  bad_block:
>  		ext2_error(inode->i_sb, "ext2_xattr_get",
> -			"inode %" PRIino "u: bad block %d", inode->i_ino,
> +			"inode %llu: bad block %d", inode->i_ino,
>  			EXT2_I(inode)->i_file_acl);
>  		error = -EIO;
>  		goto cleanup;
> @@ -313,7 +313,7 @@ ext2_xattr_list(struct dentry *dentry, char *buffer, size_t buffer_size)
>  	if (!ext2_xattr_header_valid(HDR(bh))) {
>  bad_block:
>  		ext2_error(inode->i_sb, "ext2_xattr_list",
> -			"inode %" PRIino "u: bad block %d", inode->i_ino,
> +			"inode %llu: bad block %d", inode->i_ino,
>  			EXT2_I(inode)->i_file_acl);
>  		error = -EIO;
>  		goto cleanup;
> @@ -454,7 +454,7 @@ ext2_xattr_set(struct inode *inode, int name_index, const char *name,
>  		if (!ext2_xattr_header_valid(header)) {
>  bad_block:
>  			ext2_error(sb, "ext2_xattr_set",
> -				"inode %" PRIino "u: bad block %d", inode->i_ino,
> +				"inode %llu: bad block %d", inode->i_ino,
>  				   EXT2_I(inode)->i_file_acl);
>  			error = -EIO;
>  			goto cleanup;
> @@ -833,7 +833,7 @@ ext2_xattr_delete_inode(struct inode *inode)
>  
>  	if (!ext2_data_block_valid(sbi, EXT2_I(inode)->i_file_acl, 1)) {
>  		ext2_error(inode->i_sb, "ext2_xattr_delete_inode",
> -			"inode %" PRIino "u: xattr block %d is out of data blocks range",
> +			"inode %llu: xattr block %d is out of data blocks range",
>  			inode->i_ino, EXT2_I(inode)->i_file_acl);
>  		goto cleanup;
>  	}
> @@ -841,14 +841,14 @@ ext2_xattr_delete_inode(struct inode *inode)
>  	bh = sb_bread(inode->i_sb, EXT2_I(inode)->i_file_acl);
>  	if (!bh) {
>  		ext2_error(inode->i_sb, "ext2_xattr_delete_inode",
> -			"inode %" PRIino "u: block %d read error", inode->i_ino,
> +			"inode %llu: block %d read error", inode->i_ino,
>  			EXT2_I(inode)->i_file_acl);
>  		goto cleanup;
>  	}
>  	ea_bdebug(bh, "b_count=%d", atomic_read(&(bh->b_count)));
>  	if (!ext2_xattr_header_valid(HDR(bh))) {
>  		ext2_error(inode->i_sb, "ext2_xattr_delete_inode",
> -			"inode %" PRIino "u: bad block %d", inode->i_ino,
> +			"inode %llu: bad block %d", inode->i_ino,
>  			EXT2_I(inode)->i_file_acl);
>  		goto cleanup;
>  	}
> @@ -952,7 +952,7 @@ ext2_xattr_cache_find(struct inode *inode, struct ext2_xattr_header *header)
>  		bh = sb_bread(inode->i_sb, ce->e_value);
>  		if (!bh) {
>  			ext2_error(inode->i_sb, "ext2_xattr_cache_find",
> -				"inode %" PRIino "u: block %ld read error",
> +				"inode %llu: block %ld read error",
>  				inode->i_ino, (unsigned long) ce->e_value);
>  		} else {
>  			lock_buffer(bh);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

