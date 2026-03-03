Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25402EC1431
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9A76B00C4; Tue,  3 Mar 2026 06:27:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6969E6B00D5; Tue,  3 Mar 2026 06:27:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55ABD6B0186; Tue,  3 Mar 2026 06:27:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41F4C6B00C4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:27:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1A93160125
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:27:40 +0000 (UTC)
X-FDA: 84504526680.05.DB7F87A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id B179E1A000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:27:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BNU8vxGq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Rt3olZrv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BNU8vxGq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Rt3olZrv;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32byVgEzGWs3SGMdcYa9Pwu5ZAV22remyLhPovOtNe0=;
	b=PxyG6tMzh/mjFt+ITcvsfPfOKWrDIdMZl8TS0/1BfHLYSmcwwBugIVlQXHdhRDkPIvermf
	48StzVw3boiSiwabFCHAnIJAu88BN4+Y68wqVmDVaAJtZ//CRIOHnSbqVYxZFsrjo0C1ph
	h5M2Yk3P/Gy0MHpd9Ht9iz+i7zqJOvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537259; a=rsa-sha256;
	cv=none;
	b=ZVZjkLDnun3F0DpAXUHzCnTYJTXiZ1x+u5KOetZIVl6NO1LqORlU4fRqzrqJsGkfapoIlJ
	z6M2tPI2Zn7BTwS1y3Etnkh0JvEsHeUUxNDz+8SDnN4qD15xu12ouR13KAxtcIBfsOT3f/
	RDnmvU0REL0lxjmCyGXTlbAKdwUrxlE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BNU8vxGq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Rt3olZrv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BNU8vxGq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Rt3olZrv;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 39D395BDF1;
	Tue,  3 Mar 2026 11:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=32byVgEzGWs3SGMdcYa9Pwu5ZAV22remyLhPovOtNe0=;
	b=BNU8vxGqXsLgpfZHPskBthD+JL01RrV6UbzUb0G5xLiS4vm6GKRSodzbj5y3Ks/usi88RP
	8cSPFh0Es+CPKaxXe6JECIwWe7qbh7aEiVrruMZwkl6fvtf069/MQ3dTtZ0/WZLpfts5fk
	dYSMlrN7fsDv7J9GoGsmFVgp0wO4Ht8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=32byVgEzGWs3SGMdcYa9Pwu5ZAV22remyLhPovOtNe0=;
	b=Rt3olZrvaymW/bYjfmsWnkwpHcLC9owdsmwcBh8E5YQcvvn+CINsVM2clbLpo3Nj7L5gvC
	eOFaJnESiZC5ANAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=32byVgEzGWs3SGMdcYa9Pwu5ZAV22remyLhPovOtNe0=;
	b=BNU8vxGqXsLgpfZHPskBthD+JL01RrV6UbzUb0G5xLiS4vm6GKRSodzbj5y3Ks/usi88RP
	8cSPFh0Es+CPKaxXe6JECIwWe7qbh7aEiVrruMZwkl6fvtf069/MQ3dTtZ0/WZLpfts5fk
	dYSMlrN7fsDv7J9GoGsmFVgp0wO4Ht8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=32byVgEzGWs3SGMdcYa9Pwu5ZAV22remyLhPovOtNe0=;
	b=Rt3olZrvaymW/bYjfmsWnkwpHcLC9owdsmwcBh8E5YQcvvn+CINsVM2clbLpo3Nj7L5gvC
	eOFaJnESiZC5ANAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 22AA13EA6D;
	Tue,  3 Mar 2026 11:27:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FFJtCKnFpmmbTQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:27:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DAA71A0A1B; Tue,  3 Mar 2026 12:27:36 +0100 (CET)
Date: Tue, 3 Mar 2026 12:27:36 +0100
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
Subject: Re: [PATCH v2 051/110] fsnotify: use PRIino format for i_ino
Message-ID: <g2trnjm4froahj6sjhhroei5yjmpozeff3erxnhd4h76p4xpoe@ytaohydgalpp>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-51-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-51-e5388800dae0@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B179E1A000D
X-Stat-Signature: q49ez9ez5cx9aphq6fj8bgxu6urctrmb
X-HE-Tag: 1772537258-704291
X-HE-Meta: U2FsdGVkX1/2zcfalSyFLLi2OcUSJLs0wF5D1ihCBuSJdZjh8J0qJ6KbucBNkCSop5Menc6Oh09bFvhaPlVNquqhhy0koacmZSDkkp4Go03imuzbil3oidFRkv70OnsHAf5a0BTYxX5/DazZo+j1+IqFURWL5FaIHpbiWH3KuIbT83a86snbzcYTibAhyzPgBtz1Clczcvkvyxqnac0Tv2bpcpV5FBrcUwQFMcqhpp1lIaIwUvKKeOo/pEMPbaptzZ16YGADHhcBv6cHGUh7sWe5xvQZNhMX/ou7i/njXDYORmxTnEQfUPyVXS5c4iuYIibAZit2keNR4ihDkNvMykm6YbARhPHy/Imm+Vsa+VRC93eIEv5qN1+C/IzSUs3KfzKZEZ5/m5IfrOIxLk+R1M5YRXsjAAn4TH9pfXQdUxdLuEFZuVcmkDaNESCbb0gJRfBQbpUAQ6+m+cTTAHH9OpIVvVSoWDWNU9TQ1I2B2y/u4Ls+nLUyypWHz4VpyJHcOqn3u0PgbkW34jqTmAdX55d9/k0fUbBhplQuKJRM0T3s1VE+LW4pqiOMD5y6E26uV035S/4fGkXL/+tEFvGY1NPPeY6Rr9Im90tfyP8e9LcvkrogqLfPwwUFYknpv2ixh71KSVGMErHeQtLfWFfXE3wNPcMeuEWi57KJpMNo4uV9NFdA7vTs8RU/svY/6OseG3VUZhpMJtZxzeA12pXxEpTHEQx8WBgq2E5stv9eAvINZUyh/Bkz0LYaL0rU4h9hJNfM5e3RSkEKI/PuReuBW1UVeAu63mESM2fxJ77u/Jwx6F1+jMmAHfxKagMaFq1umC59jvScLWGGeJDQD8bar/6FwhPIhI5np+GcaOlPqcOtlFjyBryDa4ft/RENK99UoN+VE2KxYApWC0qj6A4zrCyHMK+zY6TDcK1cRVWo+/dE8tLJE9ZmKig92I51KMqPrdUgzWVh6JeG0dRQYBz
 pSB7yM3J
 iSZ4HgzmNGG5Doir4aCN5bIJ4LUuoua0sU2zh9q7e89gp45NRFY2E0fgOO6VfqhkgLt5NsrGUheqWEm2W3/F5iCol/wyhEbdKeHEuEtwd5C+fqn46GjqgQVX6eayI3eZEcvK9c3gxS/UDbqn8n8i1SHCybhKym0htkDIyXKmijGefqFgvdKhGZwZblcjXIcE53u9qyAcatrN+DJEsoxQIZXNcHWGOmKAVRLHqafx6Gxdq5WSvG6FR8HS69JJEWihdcvJqOqFDDUnJcVBoXQnI13ChlSBvmqiocjcl9pZ6jTVtykWO1SNnHNOX/6yKCori9/NYtKCQLzbDspUiCUW1mWhOBVssFUjHfNHdxXUOa+9hSs+msnwr1SCq12NbgpJujLoXYHwSmcZoHRsZWSJHiHHrPcXP1HQKCDM2k89KvcvBVRpU0TLKXubFYfMqWArHtt6qseM1r5ESBEomIv6WdZkWXU1b+81xogCP7sCaEd0q4gXBikiqUjS7ttywERBoJCc87IKbAkJRW6DeU9Zd/2aEhHLJj16hB4pK7IsUTcD0rNBihqhwH69DWJKoOcEf48Izy2jPn900ehb2mCo4gf7pfV7cQ+uVzII3aI4jSbpwElQAfI6SvDc29g2waxrpWRIeRjk+PeEPA5BhCs/b3kTDK+L1DlXfrRVeHi/ASdLjHr0v85Gyl/79rTLjrafxw7nKSNvEfeJx/auK1lK6LMibX+Cf88f5peB66+Q64wcW4iwuKZ50vpcZw8ZKlkKxZ8b2d2XOfR/+LVCZ8TkitO1Vy0qmiLA02/jCIH6OgWygmYWmhCyIHLdUH7A+9gUSte67dJCNiAfEZIZIDwgIjnRBtOcx8E2YJc9g9o0IaJGM/C25PGkgEZUaL0K2fUT5CytoVferA7f8mxgD3kiv85itkkV7sDJnO0aci0szTbGFV6wrODAoenPotsRj0giFFZaki7Jwop2/v2meWPT28geHP/bp
 K2RbET8l
 +t8NhKvT+2rv7Hqc8dAu120REQ+Ldso0NZEwwAOeUsSfsYECLcBPoJK7ajtoZeB+8OUZxKwzLJYcsp6NdLGJ1UCZxlA+qMlFg6xAzYLkBhQ5WxLfMc1QHGgRlD39D9r61L0LyvTlFbGSWmu0RLLEfyrZK1gfL5p8T2cz8kwxo7IlHVPagrsHaQeOdjeCgc2e3yboqueWki3AWeYYF5AX9Q0C4ZKEcu4OeyDKAC5gGkiFBs3RSLiPGDycV25rs15Wc4TKg52VYtX/z/7ivjtxiIfs2a9dI906/G+x7vn0mzeM28yVW/L0Rnj7gr4YDa1UwR1ywYxMgPqsR9nYupGcfyydpD0kmJ2ZeuufJ0MC6TcfUXxwpnZdvwC6aEZvZNXBa3A8lOfnCtA/cQnq/DbLaS4d8+rVAne2NPlEqLbXVBjzDNRTw+rFl6RjeKqN4vHOjfSQHwvsTf0zy6Qe0QTH/5leyN0YgruuYa4t/uHmT+eQRtmF8H/+FGRkSjDZhRvdTAsV3mu81xc6vgjS8jBKV0BsqD4a8PYDDgBdKXl7qpA4JdTBh6vEy0rfv6OX1vTBhbTa7boMz3mxUCOx/6buGsm+esTksGxgXvkrqWtuAcM6MR8xe4qehymyTGKus2Osqs5xFW3sXEW0rt1m7tgrpPbIGXDZNJtfdcRDNYX8F8RuiKMICFawR3wavgdJbRpNh2AGr7iqInjch1vk+JVcInRCAQh1XEYu7iiO/x7tMI/dybOII2G+kQadweGHdYUifGftf6L/MTJXWOwLLcC0m/pPgqhpwHdiw3zLKRqs/4VicmOPIqSgfkinuA1e7+LLbLztWO+fzp61rsXDaMOfgLzHkl5sepqCWUJRrkwmTdEo8e5hnqP9JQPjTrkSGLpU6TdhfQrougKkcmoCNP0XpyLJIXC1n/wMbS5KGkLZoUC6kZGx4bgCvXW2PhghKfKw96N4NIJ88R9zhW9Y0LlDRhj/Q3Q3o
 3W0QJog3
 Ab8EBT6NiMb5IB9kMlYwS7DVMeZhevKv95Lvhnq60yIH+AFO5IqgoXUkT+Vr0nBlRFbiXGQLJi/NGTzIGe37Hu+vOsSdFEfJ1rHSA8yVEmHHL+T/1WOMydfPzmIfGCF4m0usjvT5y0LavyiW2uwJeDTPFcqQ284y1STNhhg0wJGDqpGf0o7Z9n13/LD1GYq0hyxABlTppSj+kdR+dxfRZPf1NhCDe1r0EThOQurxajRLYbq4UknA+tbRwl1HtmWRlX+z4QUwKVKsY5AKmczmkyC9lnZF1FjgleohedpRgIUDcqlacVhtHaJCUU2dp/wlzSoeaju3RqlkdhcjKJ/lwNc2Fsp2jDk0NsejzW0FB8Rh0EXcGPXFw64AtpS5syAwWiyiu7mNiOn30C1wWuYZfgQoj7dPnaMsv5WDPOoauYAbF5wLJLgyOhwP8IT8ZnpU+SsyUJ/XcI0QxnhbEGgPK5BgG0eXhDtQQxvilhMz/PHIbO19IT0Qa9AwHXFO5Xw/xkU8gZpdYFvzknJ6UVmN5Qbu+dzhPnF84btSDEqar7IKi1oQlCka/Lf6fSteHk7HUeVyK5DwL4/MvxazgCyJd4wfc3FQzjx/Hgxws/MUWRNMpdCK2Mp11T9mluvVJEutxOq1Kb1soXZZ/sok+gveUmOwFAp98rj/qcYpnESJmZGH0GYqXQOssbyk7i/qK/2Xw+e/Hr/zNMLHrsMahUUNGAhWCdUULT3AIK2T6hEktDAUM00MdS0GN5cqeQ9ASS2P+B/g6f7czcNZIvlvt/RaUyM2iIv7hOpED82OUsCFCxS3IsfcGZ+P/rxV3+6e+UNSYlqtQkEOuv8UhT6Uf2IlQfUbAjquGI6Ar5NEEjgjMkORlOP5LtYROD4g1nh+K3cdYcVxz876bv2V5K8f0G7ai3UJzrmBJAQQrCYVNIR5PgZBImV7h88MfjPQuCWsPYg6j3KdDYfFlBOkflxLR5axodf1YTovT
 3hkwaSLA
 +2V+PHAk7BdAe6smog0cKuWmeuTtY0pBy6DUtleonj3EQ0Bjlo1OHyhGpHHdqiT7UuQeZYBBvnGg2MtKA/RLSYzGQF6efaEV9XK6mOT5Qavt6k7+M3ILrytuHsdEVeIw2uDRC99w/khXJAylui2o/t8EqIb8A5ynCI1ACyruo/yp69zn84TEc5Zzwq/dLfF55GZvR3Igpp5f/ValZnSNCxhzr90Ezgylf0SQsjwKTLJvenlSqUxmerGTHT2uDBTKLg5u5LSH1hA7ImNcObVjrGzL6myl7sgp/OdFIlLZuSFiSZDXA2gcCnDZ3Z9f6agKKLpgwxjEJfdaiC0WL8cI5vPYYYfjVJCjDjpSHyKabhMF4kd77ppuFHwwvrCIH52ZYElk+evEN3Q1/IMtMi96Gf3jMzh7OP6vWJZkBwYNSkvdb2hLuTJsx49cnghC6NDCUD+1W2Ism5WMFoPjOjvK7wbIAme2O0Iwmlvbr5RFWd2TjcCV+JpnNe8JJ2h5q4yn4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:24:35, Jeff Layton wrote:
> Convert fsnotify i_ino format strings to use the PRIino format
> macro in preparation for the widening of i_ino via kino_t.
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
> index 9cc7eb863643774b83da8b6228c38db16d0dbed1..586eaa7f65a4a61b892fb9c39e6a0d81e025b790 100644
> --- a/fs/notify/fdinfo.c
> +++ b/fs/notify/fdinfo.c
> @@ -84,7 +84,7 @@ static void inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
>  	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
>  	inode = igrab(fsnotify_conn_inode(mark->connector));
>  	if (inode) {
> -		seq_printf(m, "inotify wd:%x ino:%lx sdev:%x mask:%x ignored_mask:0 ",
> +		seq_printf(m, "inotify wd:%x ino:%" PRIino "x sdev:%x mask:%x ignored_mask:0 ",
>  			   inode_mark->wd, inode->i_ino, inode->i_sb->s_dev,
>  			   inotify_mark_user_mask(mark));
>  		show_mark_fhandle(m, inode);
> @@ -111,7 +111,7 @@ static void fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
>  		inode = igrab(fsnotify_conn_inode(mark->connector));
>  		if (!inode)
>  			return;
> -		seq_printf(m, "fanotify ino:%lx sdev:%x mflags:%x mask:%x ignored_mask:%x ",
> +		seq_printf(m, "fanotify ino:%" PRIino "x sdev:%x mflags:%x mask:%x ignored_mask:%x ",
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

