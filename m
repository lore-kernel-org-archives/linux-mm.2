Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE4F6EC142E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09B6B6B0178; Tue,  3 Mar 2026 06:21:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053306B0179; Tue,  3 Mar 2026 06:21:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E802B6B017A; Tue,  3 Mar 2026 06:20:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D31C46B0178
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:20:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7CD7F140128
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:20:59 +0000 (UTC)
X-FDA: 84504509838.01.C847C9F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 33A5740002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:20:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PpCG2m5E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3lOiLnGD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PpCG2m5E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3lOiLnGD;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772536857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asUKdaYp/fpPQxBQi+IPj3US2Mww0J2EhlY3RmWmzZM=;
	b=VakYSY8qOolbW+x6bmewNVP78kpBEJNxin501napQz8FDd9q4li/HUtcHdMSo/blkrkR3V
	d5Z9jrVV5s9uyiQVnwFeoo5PP0d3Sr5qEEfaBvvQF879L0TzE57ppVc4L/Y8i6x0Eg7pCn
	pNHUUtfSKhRU5pV4LGhbeLvXBfjA6sc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772536857; a=rsa-sha256;
	cv=none;
	b=ORZu+m1lXi6pyLMRFeaDFfx1dou4lu+8FZ053/3Yh8fgn0m9UP2Xs44m3BBYNx5dq2Nbxf
	DU/vMQy7THJJZKSlYgQ8jI/FUOSqffSbHP5VQ5y8z6m8V7GoBYxCv+Qq4P7dJ5w1RsKtc1
	PEpuqMcwPPH/GvO/Ostl7xiqYkMVxfo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PpCG2m5E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3lOiLnGD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PpCG2m5E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3lOiLnGD;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 284EE5BD1C;
	Tue,  3 Mar 2026 11:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772536855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=asUKdaYp/fpPQxBQi+IPj3US2Mww0J2EhlY3RmWmzZM=;
	b=PpCG2m5EeCa2pnKUdS/MhpSiz7AoniYroAvKOyFalKRlJoQwR4ieEsts47IlvKeL147JER
	BXNuO9fwmhfW7OwGfD9fF8uE+GukksOqLUS4ViPxlm7+bzakYrtN+lnATbdHBu4cInzw/E
	iDmTaEx4DppaXUtaOOmXggr2KEsrNqo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772536855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=asUKdaYp/fpPQxBQi+IPj3US2Mww0J2EhlY3RmWmzZM=;
	b=3lOiLnGDcux7sWopnav1W/ZKPSPLpTVvcroTDcmHJTuI8kVYOQeYHrHRnAO/gS+sO6ffmw
	srjPeLy9KynESHDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772536855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=asUKdaYp/fpPQxBQi+IPj3US2Mww0J2EhlY3RmWmzZM=;
	b=PpCG2m5EeCa2pnKUdS/MhpSiz7AoniYroAvKOyFalKRlJoQwR4ieEsts47IlvKeL147JER
	BXNuO9fwmhfW7OwGfD9fF8uE+GukksOqLUS4ViPxlm7+bzakYrtN+lnATbdHBu4cInzw/E
	iDmTaEx4DppaXUtaOOmXggr2KEsrNqo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772536855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=asUKdaYp/fpPQxBQi+IPj3US2Mww0J2EhlY3RmWmzZM=;
	b=3lOiLnGDcux7sWopnav1W/ZKPSPLpTVvcroTDcmHJTuI8kVYOQeYHrHRnAO/gS+sO6ffmw
	srjPeLy9KynESHDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C1B53EA6E;
	Tue,  3 Mar 2026 11:20:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FwtYAhfEpmljRgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:20:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9F8D5A0A1B; Tue,  3 Mar 2026 12:20:54 +0100 (CET)
Date: Tue, 3 Mar 2026 12:20:54 +0100
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
Subject: Re: [PATCH v2 007/110] ext4: use PRIino format for i_ino
Message-ID: <eb56qw5rblcnlqupj5lftynq2vts2idha54xpegrfgx45znfuz@mdjzriuawmfn>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-7-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-7-e5388800dae0@kernel.org>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 33A5740002
X-Stat-Signature: u3f9cfq4nxy58na3kmu3en771qiqgrck
X-Rspam-User: 
X-HE-Tag: 1772536856-752366
X-HE-Meta: U2FsdGVkX1/+QMefapp1uh9gqsVHd19kdnb/FZ+TPynQVKkmsShAhcTksormX+aSO/klTaEuWHPQigFiJefdtPvw0mE2Vj6aQcz7kyKaWS0GFE1BX3fZy+FnhQu6kBSuq7i+HuhDnvTN0aNkoAl/AGwzrwnDuNFliSXWvhAwRz4DqMGrP7kYixuR8uwkD7uFnCyVQOShX3g1cC1wyaVpkFMVB9BcrLJI+vHef2vcnI9iEDMZphLwPcZJUpODMFHbFsm8ToCBP9RLfeLU/SS/s982Mti/zNwd2V3qH5xU7a5X37f984U0vpzuVcjiz0gGIbg635VGlfQzBsNeQZ0c31KJR71Yv1dPS5GfUfaZj8gKEmUOzn96rgkfuHsEZeYy4ezqqHIrQI8pqok32JgLdl49EgoX+1mqvK153mJXuCasgfjVbs8kGabVMo01l2eMB8phLljnKkpaS882etxTBWioM4xgJ0eY1Zr3ZqOYWQsGZ/iqXuE9D5ugQRV9yeQb8cLQXI+1HcpVJ6VzQYJEU2h4knytHpHgsSkU5ah0ujDerNGV5K3ujZpuuqY048L4g7pi+eW8b18dkYXv8kbMdA6OWRfuZPx2NTfN3FKSdPKlCSxJZZoXMTWRbLvWdeyAtQqnBcMRWmk2ka+R+8aEyXKaRB9K1LreiomC4XSGt6gyT83Zl778oYYI7HaO71fz2VZ24jLbg+r7tlfmKevPqvsJNqY/RA91qpzKUTkLFwogXm1Px7dO/r0G2d/Ozsu8avzA4KrVXO5VF1oaAixUPCPGQkFnx1ICdEmzO1+HOSD3OC8Ouh13c54G0RygLjA3pQokbjqMS7hMGr/FNRcUW1TpDcv1G+768+kdFcUFhSLSNk9SDpxbKlhfkvjoCLXWYBWIEOC5RIyJ8To2yiIZUR9kwyXgS4A3fpjxmUC+CvHbUaHzpoRiWGEXQSer3V2z7mwYBCWIeS9Hw8VBEUp
 ZyHzQhe7
 D/Qw7m3QzH3icV2c9syAOUbkPbJiRx7JBbJUZyfgAM0pxzVVeqKRl+SvMWu4KtjrvOv+HRg4Ik0/WpHDrr4MjT/ImbHlIKgLPyAbOqyE9oA2B0KbH/3w6jcHXz4mHBqwzd/S1eN2tB4FTbyqrBeYaJkzJ4vL8eI6qU50vS/BLh6kfqnzc95LWZ6+iyzzMzwHWQfVPlefTykwKBWn/DNpS0o76oy+GVvVPnnmvHwfce+t+CS8VqMZrNzOzPjbfmKCLL8+gMDZlxo2WSgUoGNgaHoEJbXrk/8CCyVW5qRhurEiOQDZYBlMAffle2SX5LoQaKHRO0diTfaidWwTWrATfGX8UxDHfF+MnUACDqQ7uxIDFInJ3D66vlczoZ0U19304++iTiUBfMIa/LtrD6cLje2t3s8bOZaWKZ2tzwcDaM16y6veDOEsbpYLErwNDfeRdT6xSxgn3slR5UBCE+SST01FuDcpI8sEJ51EVnqk5/esOluqirwGCgZQv9eouMl3lM+DGQ/EtwvOsMNMxalrKCnKELmLM85kBrJiNUmvpbvNaP/S3wPY7Ce5D6tYgLTPwMb4fYj7voqXddFOuUciN7RDjGeuKXh+4X/awrFDBYa2AVPp3KmB4K2431iDSUkTuoxrGGC05SO0Ez5NT8dexs7YIZZcaYG0bdmGLocTipKOl/34kNY9mgeRKs7wXiN6ml7Ksl27Z3L9GDoGkNFM9MGrY6PBUuvBwzK0BZ6oSP0YwVU6wfHuG0aUyjZCShbfn/lhPE/3h4vr1NlsCHe2cagCEhkCSLShiqYGD0BB5w2UbybGzhnxgRc7jXrqS3r6BCcohoMF+iDU6t09tQzImqj1Petawi/e8Xk7vm6fcmYygGu4GrbH8dv5qAufRJ/tDLBY1X8ZnKBXlbu7PjN+nCJAy2wiLK7begR0InCsW1LiX7dCteYv7FDHdRYTS7wNaxjOmOgzRK0V4mH4lfYSljJVVhY+M
 wJfuRWoZ
 XJkGKzr8BGxrM7sVN050tSIiChPC7ZmUjC+FYiJsQihGEixCGjAxzVaQeXcMqSJXE3hvUJOBoB5ODZ2tmfKVGZUTHu70JpR4RxySYgJrfMSugo3FgY57L4daX6UMOac47pZl2JmxzU3Kyp4opknqGsauqspEcBI5SYX9hzzzPiGmg4hYZHcgu0lJVk1lQzt0BRQZEet57lBT18I/9q6fvH+td7NnllHnmLe9ex5A+hNCTNoZmhc/sZgIfqR6+dRrdTNq5UeMGQi/rbBWTil9nwuPHpauQhrnT5SuGBZHbRRY3sC9KDTfOTaFodc5LmjQ+QcvinHVu7L+f8YhN8xsDU4Trh1Ap6VN8AUX6RqHp4omgiVymV5xbVnTllxpaHphZ6a/yPggJ3YklDBqzC+65E+h3RPo0WI3N+6QdfYp98ukM/uAHEXkBcXqTqooV8HsbqK8qqZbyH46LW2+8CTAS/REsEvMhEvayZoAI54hrc7jrPftUdrWV1bRn4/qxQug3ruzCVv3GZIyoRKT4+XgctZRjvf3eW44QnoN8i6abWgREomoaIzpgHW/zhzGxEBYjXhud+Eu/1t5VJqlJRrKTy5kY3tnbR2xhuJB6biot6MlM9KmDktJgX4DPqhkSdmYxZYHFauMhKFdgqn5ZIjxa4qOspNgYuELxtkOdW5DMM5Egbd2weqCl98dFM1zd0NRyCpKb8PGo7/LDhWpaKPnUOf6zmYP8N/7mHsnwmVyEk1i568XBo7MMwhiOok4zpU9JWcKJYGIJBQFroBva2EO7Wj/vOIna5d77qSNE4dFRuL4n5Ks/2RLQP/TxIx3ZxQC6qWEzaUo634kuLqsNV24py9B1oO7twM/gv8G7wNx9zvHY8Krwln/YV88lCE6HGg2a5dyWdxNJQjM6s+V9aCa0xgRCpS9Kw2hm+sO3Z07Y6hrpV3TZny3gqLIba96iv9svwMTo1OvxHgT6tr4ZALf+Rb0flHLJ
 bm1Jx5qQ
 W6Zg39jKiaSYLdzx4zuzxJyEx2WfVdqW3dyAKFLPIUx+oxwXSMOVf7O8SdJBG8fACYx4bXU95jlWLiGwtapi0JKvxuhQRMP6KPjkIVNOTTA6J4h0P+FGEm9AsAakjX4RcI8F4I4LvT87J5rilOqda4i18NWOADUK96FtXW4ZbGJyLcxCZkn4kfNQYu7Mtjf/15pFSRMVXqDnaBSz+gvp2LLNsJdmJxmQN8dnbOMNI497dCRMSbJHh+LLYgqVZ+uZfzjGlFNI5l70WV+tllnz7X0IBTgfPlQv5gwGhszMq5snnuoeN3mK/lZOQARugyYb5JDDy40sdSSrh20mEmM9v24kPCC5fIYWluWS2Sl3pNXkBpHhm0fuNpSvV3yLzeCiTOE103ZNN4r9+pwcXv70c79EcAPwWX+0tCe3+uN8cHX3zBGnlYSZUE5IFOLamTJCjslHZLuZhWjDzyszTAle8He6q9MIxFpEkT2IA54ldAUUyM35KUE/h31X9mXGliRpEYHnJw4dKXOyyCKBnNF07kmK+8ILL9GoH6OEmLeTMP/8Aj5Z5qUEOql+D7P71tt59qskKlcty5+9qhkXvV3oIN+w3z30v/KZumiLVmkFXh9EHLbVkRe6i9w2iBGvyIyubxrDuLERB7Z69EhlgZp8BM0B3szuM+qlRyYUweNIWrt4RNO3I2gK1z4I9+8elh+ZHvUDuhyigSYun/czuuV4MBsAv+jd2rYMwv+lik0YJVNF006loEVqsZNMX6b8LwbCiDiEr6gTqCvWnm7oli0Lqlz7vUGUPCWy4tAxCI1p8CElwtXIrfNrabt8YiDiKT6ITIjcXHENt/XraLdhQGcGUttMISUZS5Lfnn9ehEdmzafYs0zGBO2uOWmHBwdsFFQIph4HuxfeGOrVw48RJ30a1FjGBqKnIPhaXm3SFnguyw734JIeGBpMHwRrVdq82M4D2uOGyrSwg7UiYXZVbIzZKmwx+oX+2
 34u7/CI0
 U9oRZPFT6t3zt+/NvryL/8XgBV5T7+WjKlbL3TFyKNoAav1ns1mhJPlmlOVzslTXUstxV7IpRPtmxVxoereeeqp9rfrzrhvQB9UReB35Ye3+xFNmnuOQtCkkp4/06Psj1ZMyHBlQJN5b+AZIKAfkv6vVWe105OqD69hNKYCXd827eLK4siNTB/Qa0/owd+fxyUEMmcKtNarypULqbJ4TPfQaybg3ral8xJaOjvZ68FGQhigcwUO9bWwqHZc/o0yRY20fTlXmyZrJDUqEB0RGaYAzob/TiRon/dgYQpXDeSq6ykq7LCveULmk0ZakYIfakLoBWwdhCKbRRrvbnXo7dQ6bpEYCCY7+yX7wHXDEAFRI94PDtCFSeivuH8J84IPvj2/+O/XHmfgoB8Ac45nT4IMMGvVAWLE00Pd0aH/2Rge2zmjMsLIDQ8vM+vh5eqmgPcwDCalWpeMn3exPIFgdq3ffZQqT+gLoexvJFvAFKNmDrJS8FzNG8T9dHT5xMPhAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:23:51, Jeff Layton wrote:
> Convert ext4 i_ino format strings to use the PRIino format
> macro in preparation for the widening of i_ino via kino_t.
> 
> In trace events, change __field(ino_t, ...) to __field(u64, ...)
> and update TP_printk format strings to %llu/%llx to match the
> widened field type.
> 
> Update local variables and function parameters that hold i_ino
> values from unsigned long to kino_t.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Two small comments. Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 96ab95167bd6e10ba86e61a60cb0be9fbafe157f..43103816b80ef4901858bcd789acb0ffb2612317 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -455,7 +455,7 @@ int ext4_ext_migrate(struct inode *inode)
>  	 * log, so disable fast commits for this transaction.
>  	 */
>  	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_MIGRATE, handle);
> -	goal = (((inode->i_ino - 1) / EXT4_INODES_PER_GROUP(inode->i_sb)) *
> +	goal = (div_u64(inode->i_ino - 1, EXT4_INODES_PER_GROUP(inode->i_sb)) *

Ext4 doesn't support more than 2^32 inodes (due to on-disk format). Thus
i_ino is always guaranteed to be a number that fits in 32-bits. Thus I'd
here just type i_ino to (unsigned int) and be done with it like you've done
it at other places.

...

> @@ -1823,7 +1823,7 @@ TRACE_EVENT(ext4_journal_start_inode,
>  	TP_ARGS(inode, blocks, rsv_blocks, revoke_creds, type, IP),
>  
>  	TP_STRUCT__entry(
> -		__field(	unsigned long,	ino		)
> +		__field(	u64,		ino		)
>  		__field(	dev_t,		dev		)
>  		__field(	unsigned long,	ip		)
>  		__field(	int,		blocks		)
> @@ -1843,9 +1843,10 @@ TRACE_EVENT(ext4_journal_start_inode,
>  	),
>  
>  	TP_printk("dev %d,%d blocks %d, rsv_blocks %d, revoke_creds %d,"
> -		  " type %d, ino %lu, caller %pS", MAJOR(__entry->dev),
> +		  " type %d, ino %llu, caller %pS", MAJOR(__entry->dev),
>  		  MINOR(__entry->dev), __entry->blocks, __entry->rsv_blocks,
> -		  __entry->revoke_creds, __entry->type, __entry->ino,
> +		  __entry->revoke_creds, __entry->type,
> +		  (unsigned long long) __entry->ino,

Not point in the type cast?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

