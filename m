Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34555EC142C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 990646B012B; Tue,  3 Mar 2026 06:21:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9514B6B012E; Tue,  3 Mar 2026 06:21:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E8766B0133; Tue,  3 Mar 2026 06:21:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC386B012B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:21:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA2F6C0123
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:21:31 +0000 (UTC)
X-FDA: 84504511182.12.19D3D36
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6FCB1C0007
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:21:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b6jNDfVi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uyidiFws;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b6jNDfVi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uyidiFws;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772536889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xaF5W9aSrKshGb16nBXxZvUHZyIiebEqgbhTj1G6nAQ=;
	b=zJEci341tQU5RgkdT5T1VSmdBfMXQ8jA4hbeqhXfr2FwPvQpC2m78kQMezo2nuS5ps3ASb
	l3ewO5HP6j6eeT85WsY85wcvFo+JNI6dFnn6xbp92nJGcgJrV2VE1pKABiIBp3e58/HnXP
	eJ5NnxJaA/gwV4tcE7+nynS+1Xo0xzQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b6jNDfVi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uyidiFws;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b6jNDfVi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uyidiFws;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772536889; a=rsa-sha256;
	cv=none;
	b=6Ig+fb3uIxMOSC5HA1weLy4F8h7wPuzyFo7yyF/UdERambnO136U6yS0PWtDxKxcDCXNk8
	qGsafaVpW5NIm0NOfBJqUnUPC4DAMw36lHbuz8G9ky/HZL2HlSS/dMoXr9ufONvJN/X/GO
	FD/co4kyBKTv39lk/0yCBcozr2Djv+o=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 593365BD15;
	Tue,  3 Mar 2026 11:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772536887; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xaF5W9aSrKshGb16nBXxZvUHZyIiebEqgbhTj1G6nAQ=;
	b=b6jNDfViNbFrmsDqc/oS4cdPcAzoSnPDO0n+ZU0LKqvgQio180xKukrLRiDXQ0xqDxEphS
	arT80Harzv68tgRfSSYYdAO0AHjXHfFS0T9+TTRBR/weePSDfnt5uVsmX4phBc/L/vkHwM
	LM9iaE3rw2vBc8sMJHqpaQ9kqPgAq0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772536887;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xaF5W9aSrKshGb16nBXxZvUHZyIiebEqgbhTj1G6nAQ=;
	b=uyidiFwsvpQd2SftBHkOPjt9jFLC3+RpLp3SoiF1Mpgu8W7p+JWgKUIcEh9kVujUWxjL7v
	MzLMGIayaU8obgCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772536887; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xaF5W9aSrKshGb16nBXxZvUHZyIiebEqgbhTj1G6nAQ=;
	b=b6jNDfViNbFrmsDqc/oS4cdPcAzoSnPDO0n+ZU0LKqvgQio180xKukrLRiDXQ0xqDxEphS
	arT80Harzv68tgRfSSYYdAO0AHjXHfFS0T9+TTRBR/weePSDfnt5uVsmX4phBc/L/vkHwM
	LM9iaE3rw2vBc8sMJHqpaQ9kqPgAq0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772536887;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xaF5W9aSrKshGb16nBXxZvUHZyIiebEqgbhTj1G6nAQ=;
	b=uyidiFwsvpQd2SftBHkOPjt9jFLC3+RpLp3SoiF1Mpgu8W7p+JWgKUIcEh9kVujUWxjL7v
	MzLMGIayaU8obgCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 41BC83EA69;
	Tue,  3 Mar 2026 11:21:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zs0EEDfEpmmvRgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:21:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 019A9A0A1B; Tue,  3 Mar 2026 12:21:26 +0100 (CET)
Date: Tue, 3 Mar 2026 12:21:26 +0100
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
Subject: Re: [PATCH v2 008/110] jbd2: use PRIino format for i_ino
Message-ID: <vtdds6ie2xhtkvmlqmhmuuexlllt4c4zvpohuxbwldh5uhdfxt@bq5kjpmviqjf>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-8-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-8-e5388800dae0@kernel.org>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Stat-Signature: bxamxmfispo5mxaraa9o8dqmctr1nteu
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FCB1C0007
X-HE-Tag: 1772536889-405855
X-HE-Meta: U2FsdGVkX1+B0JkOy3guHpaJrXCgzRlFqyK7Pue53Hj/vogjGG35+z6YkAo6tWAMrD1YQws/28J9QrCrVzhIn2QxwyNV9J+t7AJSzpGo6nI2gqsUkzb8vFvrEbL1PfVMbNZkKhco2wQwCxvXUke2e/fUhz65Vv9uEowJPfv4zny23qo77vKCpUSzO6jkxuoKC9653uLhMAA6ED6N4WSoijFxjfUpNBDakSO1q3wIY8vEixuo4Vz7chtPyIdTfD40aZ5cqhPSDBpTdC3FzNic+8YCwb1VJ+4i0X4dAmmkWBU77wGJmRaKX2RFbzPda4wYk6khtvAp0xq81FQm1VLgQ5qenYfVl8YmqhVE9H1+8sS8E64p7cBsOgR6OZMMGYLM7f+xDHbkXjPfTHPj6QC7aJVNo0i5PFhQgm11GzPjO9+CbJPWly5wUOQtA8z0w3vm7CEPLyuX6unQb+8KfOODoa+YycLYPlfATp/G8MW0hW4UFnbbAA5F0oLEXIQ+LFVAV3JQSIkjeawi+LhxmnX3vIvh8zPORcHeYZypcNrhFZtBpkzLc44LF8Z3cA39M6g2Td+9w+iDKGWSZ4fZCVFGhGC3yXQbc1D1tsEL8mdZr2qSCIkyMaGHER4HD2jktDB+fGoJr8ljEbqWOkrBk9Ag5D/LPBC+gx8/NsAesRkSUeGPPFgsmsibACiUoDAbePVn5jqYmSzIEP/zfJwBPYvlsGbsPlGQWSKWrd1sQIrk3CMyKO2j5OeKDYylVh9+SxH6b/Pzaj3No2N4MW1DG2qncPDo7lPzxYWXXq7E2TuQk+RYHnddwKaSCI4uG8YYCdevVucHBDYbiXN0vcIJoBoIwpPna/Qtjt2Gqn6raJV2jbT0CxejNIaQb6ef2ECHOqm6anKISZhqzYP6HAeo6MZ6rIlzCp/j5zvGxBT24p0g6aCjNfyx1GTmJGMR7mQt1DnGd5U9252o1jo9Ih3EwFY
 LHMv9gkt
 Lp93oVB290qKc35HrL4nhNFJcc93jpEP5eEnp7xiMv4Hw+hFN4vPGRKbx9Fu323XwHKzFHLiL33h8u2lOlgX0gWDqZIxvMlygJTBqk/c9gd2S1IewGrqieI6czvSdOEsKUsh0fZGp9BLO9VTgRRNZ3qA0t1sthiZOJcWmqUSw46qE4+WW2xcyrZ5U64u2zsAEPv53jvsO/nY7O/CX6uIZcJ8VbjQv3JV4a8TGkv83z66Dk17fCfH3sFFsabqiEF4PQaRuXcyhQ4NYW8037o45K2nAigQhBXGgoqSmL1wbSt3vXY2K7zdLw+4+/Ns316jz+kIZ+Az2EEAOGEDFk8GZWdvV5vcQcWC75iqUbl2lzr0zIjEnmQkUpbb77LIgI1QiOCwmYksMHPcXSFey3LezzKLPxXj2yOrKNf+YAG28NZ25yrWXKRWi9vMZ3ro3042/iMV9g87Lp7O9fmTXz16+GXhC+E2T3mBZFzM1Vjq9qtM0j9C1K4kG3r1UdLYTfVXPo1rVD3jJtp0HcI2S7+bSQ4Njv/hK5mPJGgC6yEtvaWCnaWy0CvbnAb0rOBfOOyTQgb9KlXBjDIvIvsaAOIpEoz2tqfoTK5Q28XSPZHP0CUzC5FJmnvzJ+DgGJbz6aAkOKZEnf85qJPnH4N1GWRYuDU0Uk8QOYr9ONanUjO52MMEljT/NA0nC4cjT9OJD+oSARjc6kh4Z12IWauWZLd7THDThY6uDPs0vgB+n59HlyZ01al6ZhPhkqzqYr1J2O8RZ2l5hBc62YWFM9BGJ03oB2GGE+BgKOuC9IzEpLMAtYnHKeBGb4EMXPRqNQuTGsgf0nQSMmbRg7nSUawHaVZdWVKZs/fFyMjdJG2rAwfFKjJIx3xuySOfR/W1mKjnqOubzaATDRWrrrfhxvTGEustOGCjn5hodLG4WUFlSjRI3XsTacVDDMCk9ODLhkSr/aSVgmXmnOPQ0zrvXXiFk0ZeULbtXgh8v
 bL9Ihwzv
 hGz44zeCD+lX6gTk32UAebw3hCkJUlHARdb64QFjxMpSgxziZ6fRcDzj6WK4RKTVzV4UIZEKwKYUsqMerVKjmN/uwUdOVvse5JHUDn8QRley5P1Ns1JuKzZc2scgv6ozs7Zu/yD5Nl7NRGM7Km4lGw9KrQz3udnbmcCSmu1kl+pxZKduU5tEN+GB2fK7+fNvZdsw2CjSPvzgH6/kZ64pTYf3xVlPjjaP59giBmSZBK2UJHVLgM2GUwo8RpIrRIwRBHwkkKbsCILR3s+AFXgM3d6pBeP8woU7zCgeBMhEcErCHCtOpBvKNrYllMYF7RH7YbWwpNAUDoU9TtsCwsRrgnz79fKMq0dVCyyT6HYS/OX90l6f8Q5i42xV4jOrKjGKKtA6pY/O9un09X280RYvTCNEHXjTXPk3ONf010tKLTcCLrkzjn0QYC2phXL55R/I5Q0as78rdQkMocehuSC+qmq9ESsCdO5vMs7tF7LddW3mNp4R9iVIocIwPZiUYgrCwu9a5zSKXtcbEoy2mTGsh20/Pr//fQVHdTcCEDVrJ95LlMQWDo9vLvPfljOEKAs8Q6S7weW3ynLuAfMDEPGbXwUfNOv2oT318RtUzONtlKHNlCjWjMu1GXYTqP5ywz5JaQ5DxRcXeKhydqHijdHAf7m+hd+oKQJ7Go2WEXW0lbCVkFt44A8QGTiDABDlvl3Y8fvQFc8ReNZ9tdnbVQTQvdfr3GAYiUqtKZzmHomN3LRtpfG7CKzwf0JfUfN1RJ6ABUY3bYuQghNhJ4LpTDnoEaH+MFt8kscwJZmXbBuBrR2LQXRsiy3yhMxAjIMDMq854U/GxPaNwGCWyi0YUOInzLUPNv31+JsenvCC1dECI+bJi6PfCfjyWpt2c+WBed3SLgyU//C1QGwJ44tK1QZD0RHCLrPhUyrVLKpe55qM8bS1m58OgqfcgOEdFmVPIOIg//zw39aojsJONGHhs5Tus7o5+N1RX
 hVYqHoLX
 bjzNv7/igFOv6DHdEsZh2tj1Oys/A0zzar80YK4BZFh+P4sTt71F6x9rGVJ7qVFG8jKZP1R8aQOiuOSPs9L9eTzSL5EGIFyd7bgCQ08lL5lnJ4CrvW7t9kAELw7Kl1JX0swuhkvf2jeGENzBOOouNvEDa5oVh45IrO4kXB4DX41Oqlz0/0t+rPWNqzd1zgNfnEIqw8xT1qGpW+sfoPl2ojqw3UEp2KpMjsFGxkdmR/Lggo6ulX8VMsurOCeRJDXBVR3hBKWQPYRoPjnxD3tq1NCcJGnlXsui5HFEphnpxnacV97/NNXUHNF2UBZps9i2wTSqA95UdFiMx8FCxGXTYrkBkCoLIKZEXgvGHBfS88eBZWxHfjR1MTKgnjZmxiDR1LNgkt1EUP0ddD3cFmMYwkWS7gBKQov4D1xfpEOCazrxs04Qf+mBV5lKPFEV3rLf7Om8NjVeTnrJ06WrfIECFg43VlLie0KTatk4YJyg7GTsJCtGntAyz5gOsBzHiTqHhUKDlZWLojquala89s9e+yNgwhnV/TqZXCygmAook4qANoLHXQ3bln8gDqt38oSbo9qhzTZJJV+i5KqnNOIc9uwLpKptWW2YNKxlNMWyCnJQxjNOl6aa75IKpd2UrW31HAS8G0Ta2Po54yhTUut79Pd/FhUPeGM+stODkemzUnseHltzeRjWazqUlK1wzh96gouQ+knF4v+0DT1a5XSEjkPk42f6k74SWfxZCn2LWXPjUVy+Twdrpyd3DPWPj9Zzj+7CzZOTt7F+wex6p3W9GSVxA8zb2apVNH2DXI9PEEIClqivprE3XhNWnrQkNVDh1BoEj6aX0D/NLJZ4GFb5ZvsKUxQ+/HuQtiLpREFlKBzYbSDadJ0dB0wxlrxUl+gdzynFPIQU0a+XGO5B4ZYEn+JC0iT271XsDCXIuSy0DayHXGwOPNso4ufNTZPRuYAyiTkjr48jgIt69FlUZc7q0xdg2z6jo
 g2xILOcY
 +vAyHwozQC2k8mYov7/osGb8b6VujLSW3uFVwx4rtcJfrHrpjKQOzLBCrQeR4fxhP4G4qP+TA1eAGYMvcXXJXgbjT3gcqC6Zn2EqKrEj98mmEBxj6ZPUx5uAg+Gl8MjsMUazTcUWZxxljhAZR9iisNkgMK/Z4UiClxfAfVenJwsN/uhu4KBgkw9ZA3r5+COn//1U4aMdK2gOamOr2d7edzbSPjeVOUrXFh06z4VzGh1BhdY3f+cfBwelSEW827l+UjzXz7yCcgTP4MXmxKNXSGoKCb6oMJD7ppxHtrvyGRB3ybXskYsLhCtFYn3bs0wQBQH5+ylqbLGA2N7cFclAaSJuE3YclmMaY7+0XynaeuYcaLTYtFIOz5V13lxv4zPYLStEFyWB5Atr8qTTPSkERyld/AB++JdQe5gu0algW8CRrJRo8ByGBAEc3A0yb94gXEdnQJ2U8bgX8uzpIMLmJJJ6/hh71hBWcKjwSzXXkpWwH3zLjPaI9RzPwRMPt2Boc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:23:52, Jeff Layton wrote:
> Convert jbd2 i_ino format strings to use the PRIino format
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
>  fs/jbd2/journal.c     | 4 ++--
>  fs/jbd2/transaction.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index cb2c529a8f1bea33df6d4135e5782b9a77792732..9df937f0e15c71028038e1c0c12159421a2444b4 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1677,7 +1677,7 @@ journal_t *jbd2_journal_init_inode(struct inode *inode)
>  		return err ? ERR_PTR(err) : ERR_PTR(-EINVAL);
>  	}
>  
> -	jbd2_debug(1, "JBD2: inode %s/%ld, size %lld, bits %d, blksize %ld\n",
> +	jbd2_debug(1, "JBD2: inode %s/%" PRIino "u, size %lld, bits %d, blksize %ld\n",
>  		  inode->i_sb->s_id, inode->i_ino, (long long) inode->i_size,
>  		  inode->i_sb->s_blocksize_bits, inode->i_sb->s_blocksize);
>  
> @@ -1689,7 +1689,7 @@ journal_t *jbd2_journal_init_inode(struct inode *inode)
>  
>  	journal->j_inode = inode;
>  	snprintf(journal->j_devname, sizeof(journal->j_devname),
> -		 "%pg-%lu", journal->j_dev, journal->j_inode->i_ino);
> +		 "%pg-%" PRIino "u", journal->j_dev, journal->j_inode->i_ino);
>  	strreplace(journal->j_devname, '/', '!');
>  	jbd2_stats_proc_init(journal);
>  
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index dca4b5d8aaaa3e1505b09fab42eb45bb201a8db8..2a03d4eafdee95e5caa8dbd0afe4e32ef4104378 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -2651,7 +2651,7 @@ static int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode,
>  		return -EROFS;
>  	journal = transaction->t_journal;
>  
> -	jbd2_debug(4, "Adding inode %lu, tid:%d\n", jinode->i_vfs_inode->i_ino,
> +	jbd2_debug(4, "Adding inode %" PRIino "u, tid:%d\n", jinode->i_vfs_inode->i_ino,
>  			transaction->t_tid);
>  
>  	spin_lock(&journal->j_list_lock);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

