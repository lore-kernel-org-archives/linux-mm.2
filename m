Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B050DEC1430
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24FF66B0188; Tue,  3 Mar 2026 06:33:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20DEE6B01A1; Tue,  3 Mar 2026 06:33:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2BC6B01A3; Tue,  3 Mar 2026 06:33:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB0206B0188
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:33:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6EC316014D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:33:53 +0000 (UTC)
X-FDA: 84504542346.20.7022496
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 87D8C80009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:33:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iTDQ92u9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VbHT7f4K;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iTDQ92u9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VbHT7f4K;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMmHC5tnpofLlXcYTVcJFpK5OzfQknG7AaaojvDUgik=;
	b=xqzdbDmZR2TZRO055wC7aQlOw8qDmARasvAXDYqjSe/2m3ALDnzF9adkfl7m3HPyAyBYMj
	zubBZbetISOPvlM0EN762Hq5Bjr9gyBeUCeSEIep1O37n7UOAe9wpzEcZIhsyBJ8QLy2Bf
	4haQKDZ9Hw2CYxU+WzSeYkV8QXBd4iw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iTDQ92u9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VbHT7f4K;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iTDQ92u9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VbHT7f4K;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537631; a=rsa-sha256;
	cv=none;
	b=kl7FnlbcHJUxoO1uyP6ivDvnluHHrR0Rd91f9KkcdDtV0I/Czf1siNxm0fplk1jL1eoCLy
	sT7h9A8v5ox2icgCeOCiUc8XeaYw2BoU++yyWB7XayXeRQYe8kRJ4PlFuLUMUu0Fdapmow
	StNX+9nkLutvgS0371bxb1xdZKJxwn0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2A7B45BDFF;
	Tue,  3 Mar 2026 11:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FMmHC5tnpofLlXcYTVcJFpK5OzfQknG7AaaojvDUgik=;
	b=iTDQ92u9eNbf2ao+RuOymkmCDVw/XBW9HphQAIazIZz1kx750zvPpDHUtNTpCQETiqqSDv
	IgGus5h5MGb8bcixWgr/QBhDf0DeylI6r+9FCBYKch0yl9b6v7mz8tF+1owW/SDK/9/PRC
	gCPkD3Cub6EJtb3p9EuBql351dJygOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FMmHC5tnpofLlXcYTVcJFpK5OzfQknG7AaaojvDUgik=;
	b=VbHT7f4KxCwdLDtsk4IvFQoOp05K/VV2j/FlDdKZYoBOcdhy8XPeIxZioLLCy00usoHvIk
	qpQyvVs3ARxUckDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FMmHC5tnpofLlXcYTVcJFpK5OzfQknG7AaaojvDUgik=;
	b=iTDQ92u9eNbf2ao+RuOymkmCDVw/XBW9HphQAIazIZz1kx750zvPpDHUtNTpCQETiqqSDv
	IgGus5h5MGb8bcixWgr/QBhDf0DeylI6r+9FCBYKch0yl9b6v7mz8tF+1owW/SDK/9/PRC
	gCPkD3Cub6EJtb3p9EuBql351dJygOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FMmHC5tnpofLlXcYTVcJFpK5OzfQknG7AaaojvDUgik=;
	b=VbHT7f4KxCwdLDtsk4IvFQoOp05K/VV2j/FlDdKZYoBOcdhy8XPeIxZioLLCy00usoHvIk
	qpQyvVs3ARxUckDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 140CA3EA69;
	Tue,  3 Mar 2026 11:33:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9ePZBB7HpmnjVAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:33:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CE61AA0A1B; Tue,  3 Mar 2026 12:33:49 +0100 (CET)
Date: Tue, 3 Mar 2026 12:33:49 +0100
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
Subject: Re: [PATCH v2 087/110] isofs: replace PRIino with %llu/%llx format
 strings
Message-ID: <2mme4klgztb3hiutdnsp4pntmk7zf75frle4dexeuvv6f5j4ax@hn6evhnkzfx6>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-87-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-87-e5388800dae0@kernel.org>
X-Stat-Signature: t453o9ycr9kowzeqqjdrgotb4z938icu
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 87D8C80009
X-HE-Tag: 1772537631-65322
X-HE-Meta: U2FsdGVkX1/kxv67tDKQbyat6JlUK9tK8u7Nb6ZtzSm2nRuh+X9KFt2sPNYZFkmS2O+5YlX+2C2xhg6My2oZRUQYsS2FV4SVWzlJ6cRJA3zP39Ywj6uK2Fl7971YuUkG2rBU02OKigfWTBlIjjCXp3pYcs9l+q6LJNCxHQSUELuXkWELfUlhE0jrblBgLH41iyAdkufXnQ17GnvlZoQ3DcEuKodhCrTrzFZdKBZas3k6qWzRTByUOg9/H2nwUKq7mHU90P0x9CJG6eKBG8TLIWPsKXybOjlzDE9NxSfSbhKFI7+HGj1UF67aX7ukeVBDHL4ArNF+W/gcCu1oWtOy/EthOdms4smYKx9PFVa88grk1x2U08hubpeCzom9JJsgDivvo9EoXoreaR06No7G57pr0UHU0amazRxmE+XyUc0k8rz1MjpQUftYOKyJmGC3MDRsmYDoVoC5aeZWma35jvKYt/U++yBq7x5KXInoRFQaCvWUeL8d/Hb7a4O5gqXzTnsdw0p7QdDkb2WFw3DswAWMinDI9+rkJCflgkH/d2s6uQeeD4Rtan0cSmuBBMGIhoP82TebgUHVbb5J+c4/pwCWtcAQi+zjJnY5b8kXuYz+uoY82jRuT+jvfK0T9kOq0vrQ9JHNRe+goHlXC7bIdFQeEIJ4IFWI8G7JGpgLcZgo4AJ2YmmOsdeV5d7QHClapgKPLia3yH+6jJB4xClIfNsd+DEIUhcCS6RRtz55zrTI+FoqvDTcgcB239M7wjieKlB6WRqLJXubFcGtt4XSmywCCfHkkDbIZndF3582TVxkWDgMJWED8KolkLhxWA6DINbJKZtdg+7lH8q3lSnKd0a4PPoUcSahOeUZ6WHOJbL37v8kvOH1+x3HzQdE7+z6Ip5nXS3WzghkLeB7xhSQ5EeGTRRMdxCuLKVtPC8w+vt9DFG4HwQ9S7KGx6htWXd2p2hTYSB+Hn5xDhzPerT
 B4KDGADB
 qWQbbQnWgs/sEtd54ra3ztotzmO71jroL/7BjUPWy3lmbSUiqcJDn68bhYVfKX6o+kOw9be7muz7RB47CLAO+D1aLXMT8mNGE+NaRLDi+Nwav8jQRSRhg0NEvIZBMAMwvqEsQwSXxblCCuNmzcIqXZB6ktPQHDhQLT1uLCTOiB96d0pPU3qsQofH6aaW0GLsx19pA5NtnD36JG8KZTZcUacNGcye0SC0RwjdYqBGXDJ0RwOmCZvTT8a9aZ+gHZdBXGaQU5uxxus1P9BUudnD4Cb/fA69Q31Q36HJD5cUu+nwtotzGsAmtAl/Eev+rNBwNmHyCDisxy28TwIbCIzm42lj0iK11VLWDNxrhr7dDeOATiM9+4bK8PRjwOQ2ZUJamSttu/Issqlkflc0SlfyOSSeWL7kj8w0pe1ublfEcV7ctTD1soSJVazS58HsZPCgRasWG+IWokc8m73DP8VsTWslK9hKCTSdytFGy89jcPXxoHLSP/BUIWkjG8UpEy7DtT8HqrCJch8YqtD853Ty0wLvzpmRYSKOhYW2QISIrOBc//OO43+Pfwuv/cAzbeB0T90tdK4swzzMj8rwKypKE9eTekibAp4IYjhCpLyxpldXKwvb4xgEu/liFW61tKMTop7E0zLcBw4NEtqaTs2od8nXwUENk7YCeD6N0uqIg6JUuAwShmprWA4QJKTFwBElH1oTZWqdiJLSOtKxSt+6hJKHys1pmkP+/GCGHB0Kb8cBlhpFKrfUnGuuTWrsp+7U7CYeWqX8TDbvAlSAI/SiDKo2g3Up47f+6dS+hNTauxEnTGcOJi9l1ymQqRimjPeMtwtqdfBiIAJkFDXkn7R9q0MXEo0IYRZ6AVqAH/UAmGiyk3eJtuoFNIC2M6Zik0braMoFf75hT6o7mXMIpEE6qfBDPPI0X4bhNMmPidj+HcNereLlpmKW2t0K7EkZBwZoeNRif0ZIumSoyB04j5lLh9xc3rcKF
 G/39QK77
 k1klRrBkYxRg3rsWfJccJDWH8okD8cONbeBQldezkDslSxwUO7esqr/itfpwijGD9nYikuc4V8atru1VvZM1md1N9TfJwJ+1MZmwRRLHSDDJfCAsOQnoFV8ijNmYbqixPHg0dSjI5Tox69FTv71Uu8nCeQeyEcGQVo79keLXU/XYikbQsCfG83zKuLeMH4fCUGhjcJYchb2d4/V2RZuxZ73p2AducXQUrCWcv4LemNqTo+ghhtWKRo3kQUJEZUb5/UR/t2ty1FxufCylT5afqKyucWTzsg4C8RTY/wCSc3V5G6y4/VAO18IMeIlki0Y/MhijlO554gS/NlEseKNRSWRzC9tedMAQ9oMvmPYOjRWbRteN33XYyk/GPhO01DaQ35snT8LmnYsUVsa9sFFaDCVglZd8piRUepA4IzHzG9DsIyuW4BhFsgeg+4+2XBk9E6GsC29m4mPMs24eL1fXjV/JbC6ao0OlzwogjX54lhUT3V/WBrhG5qVWYZJzmUDB88c1ICz8otJaTo942U8xznUdws+8SU/zffrzzHjMP5NDOk7h3SjEYMjFB/v437F/2kpOYCIRT64sD4CaAbu3x+m2qVfRqfZN1ub3WfaQ7VtfnkK3T3CFufvbCKbHzKqIJMr0YU88oqzwqJyPu8xRU4R07KeFDDIvnVc1/jZi20P/xyZUcnrLxljH6RRna/30nJAV1krAtzGkos/HpXxJMwrniFG/UVHSr2tDrVFwokmGu1+rfMamdsa8JNcYxu36gjj6LuQJgDjEmllGH5vxqXzk7xSpRtNm2OnD/wb3/PGvqrlEPHrV/KH0kI/LeSzF79HZ0EV1aNNaIXSiTc1FcRiPq2P0/Xrmub12C/MLzeNGcUe/Ph5awIc03p5pOuDQKO3bjvTQueNLjByqKRlnJC2yb7Ky715WOKB+apJPmR+3spPaVtHuyE4YVMSZ28ROyKErz5AXvN7xrgAW5f+NFoeDyKD5v
 EiGgqefo
 MzchxzoAcEWCnYKkTHPJgysLteoGxOZA+77IznYH5xaGt/9UhmjNj9MQZLvA0lrL8dTfXHM4/Jtre8x7zgu+U5ct21d14nuU3SAn1l3Efu/eZVbIDmHu/uG3iKiN7/SbZfFHDzpjgAUPaE0kumcVyMvNLbHWMxPEVCH9I7PIMQGRYl4uzyMM4E/KtQYIR5gkXuzr66rd6R8SaCgca2xJz+0ALtbgRuKuEcNXfx275G5XJpukGaj16NA5f2EgS0WmxDLglkGfS+GMp8HiTkZ3l9mV+S2s1Gl0VndiQq9OrxpLl1yG/lAqGFWTUxdqn5rP0GP0VU0ej9R3j2ChO+sEZndshBYo0wK3RWlbEKFXdBNjOFXxh2zcfK0rwzN0Kro6i1LJHoSfOidut3RTqmQP81wj0LcYbo8ThJ23FizrKMTGUQi4SOmBtTuGwworhLXLsRUJFl8J0Fz1wsr3Hjs2lLpZGDh6/qkk4F1MCWxWbgjJwGubjauQujCV88NXh5yEOvgWpwJx1B4cPa1rSS5f7xF4Z02EngulkhuQmcxspqWqXT5OiiHxSgroOsLzKcA15TUkIZB29v9Llry/OcY51/KJUuuLAHn9BHpsI77cx4vqmSna9Hlf8goAhW5u0Cgfqjsn09IuWssiyyBglw7sWGOWZkhMEzNcpkFSaOJsEAlhIbcZlqWKd3eICZbaM9/EM2IHMqZBVrBbwU5z6Rw4z9t6kE0VAizg64tIlIXwT99Uay3cGzMkGyAdGOOFjNaNIGIBCVtIXHN0sSTL3MG2Ru4jX7hIApNAGZmPcuNjhFtax8pZndYi8J+3v2Ic/b8SU9taVckJq+C7qtBHtUWZEdgjhULlL5EVzIhpws74R4koARJwwYLxaZ0MGSVDPr0deAymon4IgsveCYJhva5OcOmk+Ho0WBUWENZcMv9jgeQruK5euIqcRojSqXApY44xXi6XoNPgpwY/bBS5opBt7EmjBBV3E
 boiXD4UH
 TtIYbwQnpdHlorP9QeB+Y/E/ywLo7DSlvS9f80GZaOvIEl3uYg6xlSOqfoC92WPy5cc9RCYTN3bvqKNFvyGMNIqq4p7xQ9nGpLM27rJyKzSn67Rm2MiC1uGLX9e4C2rHZY7cosVTDscxYFxwXiarIaOgOmXRQfFiyJwpLEEfqHKTjKG3Ks1j8G91dKjrFz2B5zMv72LPyTpVARWuDf/qrREXktlh2Fy3wZEIpMOfyj46dkRjYhCEZ2yVNnLxVgUqwUgI5+cituGHWl0iAZmtVabEYP01V21ZTaTlse30cOBxUmV2F/n8F4H1ZmP0YhpO8iomVQTeGno220RjU9d1Bjma+JS4THlNVb+FHokrzftmK+ptf0wUgnR2wmeO9rqKPdiQG4eZxvFS0za2R1zqn134e+ctBYDPa7xIU7B+kTMC6KUxAs9UTGz7iBQfU5NfyjQK5iCsdHzRdhp0elZupk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:25:11, Jeff Layton wrote:
> Now that i_ino is u64 and the PRIino format macro has been removed,
> replace all uses in isofs with the concrete format strings.
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
> index dc6c7d247cf880720be47cd26d23206d25a4e453..397568b9c7e7d3e28873be02c8a4befcddaec7b5 100644
> --- a/fs/isofs/compress.c
> +++ b/fs/isofs/compress.c
> @@ -156,7 +156,7 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
>  				else {
>  					printk(KERN_DEBUG
>  					       "zisofs: zisofs_inflate returned"
> -					       " %d, inode = %" PRIino "u,"
> +					       " %d, inode = %llu,"
>  					       " page idx = %d, bh idx = %d,"
>  					       " avail_in = %ld,"
>  					       " avail_out = %ld\n",
> diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
> index 0a8f9e411c23425a6919b7a4fa3fb387eb2c3209..2fd9948d606e9c92f3003bfbaa4f0271c750a93d 100644
> --- a/fs/isofs/dir.c
> +++ b/fs/isofs/dir.c
> @@ -152,7 +152,7 @@ static int do_isofs_readdir(struct inode *inode, struct file *file,
>  		    de_len < de->name_len[0] +
>  					sizeof(struct iso_directory_record)) {
>  			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
> -			       " in block %lu of inode %" PRIino "u\n", block,
> +			       " in block %lu of inode %llu\n", block,
>  			       inode->i_ino);
>  			brelse(bh);
>  			return -EIO;
> diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
> index 678d7363e157d893e005152e64e922d9170468d0..3593e02e75fef8567643137e0ff992019d2b6fbb 100644
> --- a/fs/isofs/inode.c
> +++ b/fs/isofs/inode.c
> @@ -1261,7 +1261,7 @@ static int isofs_read_level3_size(struct inode *inode)
>  
>  out_toomany:
>  	printk(KERN_INFO "%s: More than 100 file sections ?!?, aborting...\n"
> -		"isofs_read_level3_size: inode=%" PRIino "u\n",
> +		"isofs_read_level3_size: inode=%llu\n",
>  		__func__, inode->i_ino);
>  	goto out;
>  }
> @@ -1380,7 +1380,7 @@ static int isofs_read_inode(struct inode *inode, int relocated)
>  	/* I have no idea what file_unit_size is used for, so
>  	   we will flag it for now */
>  	if (de->file_unit_size[0] != 0) {
> -		printk(KERN_DEBUG "ISOFS: File unit size != 0 for ISO file (%" PRIino "u).\n",
> +		printk(KERN_DEBUG "ISOFS: File unit size != 0 for ISO file (%llu).\n",
>  			inode->i_ino);
>  	}
>  
> @@ -1450,7 +1450,7 @@ static int isofs_read_inode(struct inode *inode, int relocated)
>  		/* XXX - parse_rock_ridge_inode() had already set i_rdev. */
>  		init_special_inode(inode, inode->i_mode, inode->i_rdev);
>  	} else {
> -		printk(KERN_DEBUG "ISOFS: Invalid file type 0%04o for inode %" PRIino "u.\n",
> +		printk(KERN_DEBUG "ISOFS: Invalid file type 0%04o for inode %llu.\n",
>  			inode->i_mode, inode->i_ino);
>  		ret = -EIO;
>  		goto fail;
> diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
> index 494d2ae4c0955123335a97f23672b959dcc9e0bd..8dd3911717e0cc221f60fb6447e1bf26cc2223dd 100644
> --- a/fs/isofs/namei.c
> +++ b/fs/isofs/namei.c
> @@ -100,7 +100,7 @@ isofs_find_entry(struct inode *dir, struct dentry *dentry,
>  		/* Basic sanity check, whether name doesn't exceed dir entry */
>  		if (de_len < dlen + sizeof(struct iso_directory_record)) {
>  			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
> -			       " in block %lu of inode %" PRIino "u\n", block,
> +			       " in block %lu of inode %llu\n", block,
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

