Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EAD5EC1431
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02DD86B01A9; Tue,  3 Mar 2026 06:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23586B01AB; Tue,  3 Mar 2026 06:36:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9BE6B01AE; Tue,  3 Mar 2026 06:36:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CAE666B01A9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:36:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93A52AFF50
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:36:39 +0000 (UTC)
X-FDA: 84504549318.22.4F9AA04
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3B843140011
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:36:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K8oGnLAE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NK5Le7Fx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K8oGnLAE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NK5Le7Fx;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EW+nHsGcUVv3yJibcGm/qkEU+CG7g2O6QkpmXru5Dmk=;
	b=zoUkyKtqFnZAh/329n8oR4BOs1xdfZFRva762nxeKf1t0oh/5541qnIQvQGwohV95ZO0MG
	q1TYtvkR65xyaJRlGCNMYRS5XPDFAgOAK2YJbxKKf0Hz00WO9h+ipsEeZwzgH9HpxwYW+G
	z6maHMsaByORtR+M1MbHthRqCnDjXDI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K8oGnLAE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NK5Le7Fx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K8oGnLAE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NK5Le7Fx;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537797; a=rsa-sha256;
	cv=none;
	b=7rc9zhHxHb7JkcVIaVh42f63wGeflAOXof3fA73/CLu/U34WF4HBnTu4c9Vby5ZFRYPbi1
	otvuOibq6e2xRC5yNj0Jv4bAGxn4INOp2OwSFy4HWPcremVMCerou6ZTeexZXHs2oqQBpI
	C9nIFxSsHbH+IPNfbEuaW+eZ1bw8z74=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE24E3F95B;
	Tue,  3 Mar 2026 11:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EW+nHsGcUVv3yJibcGm/qkEU+CG7g2O6QkpmXru5Dmk=;
	b=K8oGnLAElFNGhNmXJABH1aWKs6Do26QyM++Q5sSlj+//arPYMhVviz8fK71eusXqP+DKMX
	9WUjSsWT56ltqxcoZzJ0mmIggx3oO/8U4pTHbO+1yN+eDZUmOtERjnQ6WFWbDIUikiv+Xp
	MnXZm1LPdJA8ZesrjOa6M7IGDey2fn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537795;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EW+nHsGcUVv3yJibcGm/qkEU+CG7g2O6QkpmXru5Dmk=;
	b=NK5Le7FxOGQ29yshZrsSUmqd5PRuVQJnYhThs/9muQJnLbKscOMq/oRYP7z29bxRkUUFv5
	lFqIv0MKsJHpajBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EW+nHsGcUVv3yJibcGm/qkEU+CG7g2O6QkpmXru5Dmk=;
	b=K8oGnLAElFNGhNmXJABH1aWKs6Do26QyM++Q5sSlj+//arPYMhVviz8fK71eusXqP+DKMX
	9WUjSsWT56ltqxcoZzJ0mmIggx3oO/8U4pTHbO+1yN+eDZUmOtERjnQ6WFWbDIUikiv+Xp
	MnXZm1LPdJA8ZesrjOa6M7IGDey2fn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537795;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EW+nHsGcUVv3yJibcGm/qkEU+CG7g2O6QkpmXru5Dmk=;
	b=NK5Le7FxOGQ29yshZrsSUmqd5PRuVQJnYhThs/9muQJnLbKscOMq/oRYP7z29bxRkUUFv5
	lFqIv0MKsJHpajBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C7B223EA6E;
	Tue,  3 Mar 2026 11:36:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b/O7MMPHpmliVwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:36:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6C94EA0A1B; Tue,  3 Mar 2026 12:36:35 +0100 (CET)
Date: Tue, 3 Mar 2026 12:36:35 +0100
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
Subject: Re: [PATCH v2 104/110] fsnotify: replace PRIino with %llu/%llx
 format strings
Message-ID: <tapjz4t6hyww536gl6vsvqn55nf6k5sllfkicmfqzowrmzs7xh@3llck4prdgg5>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-104-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-104-e5388800dae0@kernel.org>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 3B843140011
X-Stat-Signature: fetwf1zraisimzb5tpsn1msrikkd4ctk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772537796-469653
X-HE-Meta: U2FsdGVkX1/AKgyg5xUsJa9tN63z2iGng8rYS/LrMQ2EUGZNAy4axVex3ejQCiI51q8zz6I5mR3SzMsN8huZqkb59ft8yDIhVNK7+xPbN37655tY2tBUw4Jjp4ArYXCRvm/X+3SWFb02u79w8YME1gC1J5kN8TXHTOrwlK3tCg9msrs3taCfxuJqE/BCzzqCD1Kf65iJW7kUbHeIuiakZNiFv0NkuKkFefqvarkzGB0afep4ki1mBgf1GVX2ivRZti4194GmBZV9TQDw/4nF/YH7eI7iI1RcZiVQgdgjr3yTEjRJS6tkEC+pD9UrAiCVmD9m/BZ8Wkz7GFKJRnSNHDIMY39bIniebZvVovgVRFwQimMTqhsnQye5O9lTiJvyAq5oL1Vv7JWEZ2GvMFxOt7n512AhYuTmTutAy+diBCDFsil29jexRt6IaamfCGrkZ44fTzldwLR1Y0YtMCe4FgDAc60W0uU98DZKCEansmjGVvVIYxViCx+LUWIhORoM0qIyMupPRT9l1LbcSlBr4Dit41ZkTUNDGJOsTcNCJf/NRWXI327fWzeWx5ceyPjScNkLWobfTAfzg0NCrykvd6xdgxjzuzjTzR+N/1zrpr0azojubOgkDfbH6yooHcxPLkEmLxqPW3cNjrYSGCIcLQz4SdzCCsNQPDLr2Rrw6wiuU1Y5AOMRMZFkaPcv6dSXmA/t/gfYH4MBK+GGQJT3qiKrhnNuNL71cvUa1zxUsLxA+xR9R32s94kpx+zFn2KG3pkAtU1G6kv+wEFyAnTgjScX1OjgjH4UArHI4qbBFVJs5PM2afVRxYGV4SWSUJX9enBmOmZglgUJpHXe4RjoM8ezSmuAcR1pMzEHMLwNWXj32Fy9nzDUGEj+EjxEglysBwEzAp41pClrILJqDofelxtzkoF/x2h3xePZ+qbwsWxD6u05inFesqU54bVnXDPKst/vC/sYG3B7x6Z/BX7
 TZkTE9Nz
 iKPt0f7aulWx8FBUERz9/wHXn3wqaXxtJBwtDuyv98JCkJDAwHW74Ut4Qmk/OUpanTrvWFnksEY942eg10inUNG19ySgZOen9VeJfJTGAirXTYLOt4xhiEkuim+eS9yh4dP2VKnAgh5t3QI9pp8Rat1yIOvJ+Ibb+Hi1Ou7O7dOs0EQeAEElezyh2yJW0cHGHAWGn8FnU8fAQypR/52yXaYbLIYOakSlM94d9r9jPWStK+vFC2gW2wQFFNqmJW5XI7fjg7ugcyfo7mhU0fGv0kA91Kb+FwBunxctXARKVrucRl0hoF/sEzuWZKFReFaWeNv5OjUVvb4fH7kymtcqkyhiehyCqPyEbvB1fA98ZB0FZVjEH4VdJGtpUblZJ+TTahDi1JDYhhVVpwMdoNiybqvIb04WvO/HpTR/mw4NZbc76Ljouf+UhroRrSceKawqetOrVCw/2ustYmkmm5NNO7XZi4rSXcHnRvP9lMSHpqXAvYcpRCxPlXQqASA783USc1c262UTi1GPOpMJu0/oGq5y3FB+44MvCxHXgxreEqNVSwTtngV6Bdcz9aE4eNZWPaySO1tonfCSDQWxPAtEuiJBYf04wsfzkRbMPnUbg4LHGHGGewnWT3O58Cy+QDVxrtSqgUNvFC4Zc70NYLakd+YTpwqxR8EDAJJAstxmyEQIOr4A3JYe3WtIIeXwAmCCtt+JGMKDZ6Z09kT/YC0ZER2dD/XxFYiVoeywTxEHaY97NbpGfTLt90bkba43ZO120Wr41HLPprJRMbFTKopME2gdqiQ5FMZWKqGLy1t7/gxMChSggkAoOImbJgA5OK0EyE8jlk/hQWXtF8lAz8otjyWWe4DErSnsBW0DEo9rO2OV1+7GD+dWhdHvwL3jK7bWYdjmPHp3VNDurBoDeWjGc8LHNdxQ2yR+vLlsTe0iQWhSr8QiQ5V1H42UN44JQXpAHcK6iiCBvtjR1ESTR/uIq9P02W/rz
 E5bm50yL
 4/ds7ddLcdA/OMC8Ldt1mRG7xh+j/Fo/SgTPN0r7GQ2C5WPnldfsf3y5AdtWXHVrMkE97X3+v877578RYt0EVI5A4g7xA6bdgCOCltTqJ/wPwMqU6DuiYfZILL89hmB1mdHJjqvmzyhJ0SRS+9DspA093qSKz9Oplb2Uizzv5aV0WtmDm+UbjM8G5AaEztIAPDgywEnbpd6e0AZIqBJumgLHR/GkCDkQhwTVY5bCtZ1Cg8G0uSdyv1NwGUTl5e8BNlGVzROH0guUdcH/KERG/Qc8jOWzALcWybTOn16Raips0vqmcLHl+yueX7EpMSP9Xwy3Ny/pl54A5UcJOfig5Gs6wPj/6Z93XSN9duJuJnhs5El77nlRp4G+7fe1/2Ev1JIP9/yR2EHRCMdBEQFJKw6aGmwHrKXH0QjJx698ybAdo5618xdwapiq5Va2ICSxYzz3JuIJd8JvEI2oqbqPh0lpjMuV9gnWgsQuq/3O5d4R9KxoKEkM7q1B+A/9uVD6qnkxQr8xkOhzIpHEFZj3lZh8PTLAdC38R38e8VGCFFrZWGsOxQfyIB+YmywdxeI4w5l7rQNaEbbDXTF1eAuNN7BpN0NHwc6nN+cRd+yHi7Hyw0U+dGB4GNMJufnz4CAxGNCW3IAZcgyHMcXwFwXYH2TYzx2SU8n6+IEFllexrsiFQL7G3bggQhx04cXShk6bWBQMh3pDO0yMxP0kfAwSoo9GvJmRO4fpqcaUEwnXxn7fLfjGSbRxqKVvV/uFqjTcOutIbmPqnxVB2EBQ55Zhfx0U8RrkaqU/9dGsHtbeFIjeRkPDFG0uP76/Uqa8lJQAmoEmCXmk0JPQL1mY2RzMnjyUpD6picUXDDLf5Ym02ki5S9hyhlx8B1j0lrjsoDl0JQCYImlqprHS14T6Lm4kGlcPABU12yqO6hvZ83kXcy3JroPyTu3UxAJ2PZdegiRTXjpQV3nhxPSYKcEsCfBQaF2sEOp+y
 zs0oQW+g
 wNYVSlEd8iaLkC5zvtNwd7pdBRotzaMrss7lv4XKwBFh7T4Ppq0DrCFKSSG+j3Yz2/kR8QZG9R1Xs3t/NSyOS6rRbtAoA+lWjK/25dZHDkKBm4qCKFoAFfzX5x11ONOgfyT+GJGjKdvttWGxOlma/unKiEHVgWQg1YugRI2h8dRK2CXdeUd1BPSxHDx/Jb5Zjl+I9RDIVT+nkycFJp0yyzBDsXy8ajutrSa1W0VbYL1jJJDEpS6terTYn5VI7e7hJA6AEPKSoWsMUkijS/fqdQTIxjjuFO6hHaNzyhyx0Y2dV1VNLTFZeCzxZhJUUukNfRfiAVdofIzH86E9ncydwBo4DpvoA/8G4WQKiViTi85xWR8YEDRuPsXurCeJ9PsZPD8W6khR1+hKQ34V7+iGj1NRo6ZJptdVPfYZ5AQfkYchyp+eJzG0wqz6KX33orJbp/qSJiHWSohh1PpIKBRKJEYWu7YWiHyrwe1jsCTBqy4JtNyyUY7LNr4cPum850ra/K4lHpFd5ysVXINITnMq4lHnZEg3ga9OHLwkHPQc5CS1hu0VYg5ozpTUQgZgcF3s0ah0NSaUZtsVJbPOgI9pPdRCSYa2RPG7F8fS6i2OLpQ/9ajH++1s2IiDGgN+57cReBj11YE+gPFM4QivDqhY1rhuYWW/ydB9cMH3UoFCLsyS8bdmcx5p/YhT76bYcWfuTMF+v0Crhj6BuQ/f5WAOu/mWXBFO9zCwTd+iX6swtv2Y2460la37OvF9s/C0WpM2m0nlZbwFMO6SGtKUnnoHYHlxzn2gKAFC0eER+pROJhnsICfDBQRNmZzbf7zaNY3k3BBQKd1npPxQm+A8w5aBDLTSgU+Hq+L6FRf6OMJWx16EjE217SZriKRNj2scqSEJ733Aoe2w3dWuNl3pYipdG5Hb2CwZamYayXa6KpQ7dDZKMDhQlAS2uxNhCVzEhc4Ao91uariaunCPLIWEWUg5uGaQoAZIh
 t84WkIX6
 uFHj6IVMBj4iXr8WTOKaxOt2982csppORo3vkSZrVaLquD4vgSA74KlZkRN9+Be5nG8zDvUhLoWqxnGBgj+YlhOButSAQS4mpXxlogHBjpXcq/1HHp6ZUVJmfdRCpqLc9HSwD4sNHOxIl/zNkkczYt/iZr6X3iq155qZnpqbvOaFRK5DX1bOLhtQYAjdn9dv2qFZds2mVs1M92uO6SbBsEJvZ/Ynfm9cFDhz6fy7lHWOUX3Esjs7ap/E9k9x1ENfrOdtZew7yphU0Q16OvI/nJMbHbpq7rldNzplEUDQxImmbGJefZjk69Smco03HbFffmaGW1P/p6PPRMTk2IqJIayj/MmMv3hApR41Vif25rVXs0/x0DewCRWynyvc0yWzkqkQ8x0nre/hWJbVk/uc4y9uLuugKf5wBodAbbkFxX+s5rvmO3rUFd63tbkzrkolD6eOsJ+eHUqRFH2S5a3LJM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:25:28, Jeff Layton wrote:
> Now that i_ino is u64 and the PRIino format macro has been removed,
> replace all uses in fsnotify with the concrete format strings.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/notify/fdinfo.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
> index 586eaa7f65a4a61b892fb9c39e6a0d81e025b790..0f731eddeb8be74113361f45aa4fca2943395e9d 100644
> --- a/fs/notify/fdinfo.c
> +++ b/fs/notify/fdinfo.c
> @@ -84,7 +84,7 @@ static void inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
>  	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
>  	inode = igrab(fsnotify_conn_inode(mark->connector));
>  	if (inode) {
> -		seq_printf(m, "inotify wd:%x ino:%" PRIino "x sdev:%x mask:%x ignored_mask:0 ",
> +		seq_printf(m, "inotify wd:%x ino:%llx sdev:%x mask:%x ignored_mask:0 ",
>  			   inode_mark->wd, inode->i_ino, inode->i_sb->s_dev,
>  			   inotify_mark_user_mask(mark));
>  		show_mark_fhandle(m, inode);
> @@ -111,7 +111,7 @@ static void fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
>  		inode = igrab(fsnotify_conn_inode(mark->connector));
>  		if (!inode)
>  			return;
> -		seq_printf(m, "fanotify ino:%" PRIino "x sdev:%x mflags:%x mask:%x ignored_mask:%x ",
> +		seq_printf(m, "fanotify ino:%llx sdev:%x mflags:%x mask:%x ignored_mask:%x ",
>  			   inode->i_ino, inode->i_sb->s_dev,
>  			   mflags, mark->mask, mark->ignore_mask);
>  		show_mark_fhandle(m, inode);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

