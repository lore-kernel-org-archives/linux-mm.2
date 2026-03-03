Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29432EC1430
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913626B01A7; Tue,  3 Mar 2026 06:36:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC496B01A9; Tue,  3 Mar 2026 06:36:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C406B01AA; Tue,  3 Mar 2026 06:36:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60E696B01A7
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:36:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23B76C02BF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:36:34 +0000 (UTC)
X-FDA: 84504549108.07.2215220
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2C40160006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:36:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UA0yQrci;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="H/d0D+AP";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UA0yQrci;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="H/d0D+AP";
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CkwgRCUqwHTg0BO7ZDmHD49cJ0cFspBc62hi3O91R1E=;
	b=SSV1+lcfhJV6XetehnS78BYTVMmaSvj3obIwR/IxV8/TaNfJ4OZXZ9VVOIdV5WRHvoV/qw
	6P1bLz/tHOjABDLTC1HtgiKTnPyn71i2mcGy6ueRRez5wG60zSrfzH6HeWpwc+f7pUG5Gs
	Xqz4gLMdcwSwykdp/NVicutQpz4YBY8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UA0yQrci;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="H/d0D+AP";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UA0yQrci;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="H/d0D+AP";
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537792; a=rsa-sha256;
	cv=none;
	b=U5mPq5gXxcR+zTk54N16IGCpdSUIP3xXawKaJtmW5Twk7ouYyW3w5D64A4nULpKMhC2u4d
	frG5WVfaOtc8OHXb5cYlUpEdwki6+vS+ub7wj+cslTsmsM+7x//xMnMkz2IGbQK7efbHQg
	lXgbQcxoNXu3mXDsfG1/v0tVQD6HCTg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6747E5BE05;
	Tue,  3 Mar 2026 11:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CkwgRCUqwHTg0BO7ZDmHD49cJ0cFspBc62hi3O91R1E=;
	b=UA0yQrci2FE0Wix8n/isWmsbi9Rp/ce43M1wmsE5Mvq3brVHpj5jbnSFZLxR3wW/4Wy5Hj
	bMyeNEnoP0ckEOOwi6wk7RPy6QuHOuKx0GbTaIwJtSCA8vL58Te3zZxCHDdhmTI/VKd5n/
	1G64XSVXFa20yNoXy75GU1+rkGerel0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537790;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CkwgRCUqwHTg0BO7ZDmHD49cJ0cFspBc62hi3O91R1E=;
	b=H/d0D+APnG9mhuvDkLbn+vHx//ZT5bWKlKKivEPJd3jq74VW6GrUPUUkKJo8f5NuvfHEzP
	ND6+QfH0yfTKsvCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CkwgRCUqwHTg0BO7ZDmHD49cJ0cFspBc62hi3O91R1E=;
	b=UA0yQrci2FE0Wix8n/isWmsbi9Rp/ce43M1wmsE5Mvq3brVHpj5jbnSFZLxR3wW/4Wy5Hj
	bMyeNEnoP0ckEOOwi6wk7RPy6QuHOuKx0GbTaIwJtSCA8vL58Te3zZxCHDdhmTI/VKd5n/
	1G64XSVXFa20yNoXy75GU1+rkGerel0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537790;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CkwgRCUqwHTg0BO7ZDmHD49cJ0cFspBc62hi3O91R1E=;
	b=H/d0D+APnG9mhuvDkLbn+vHx//ZT5bWKlKKivEPJd3jq74VW6GrUPUUkKJo8f5NuvfHEzP
	ND6+QfH0yfTKsvCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D8F53EA6D;
	Tue,  3 Mar 2026 11:36:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S+fgEr7HpmkGVwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:36:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C696AA0A1B; Tue,  3 Mar 2026 12:36:14 +0100 (CET)
Date: Tue, 3 Mar 2026 12:36:14 +0100
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
Subject: Re: [PATCH v2 098/110] udf: replace PRIino with %llu/%llx format
 strings
Message-ID: <a6ozjkkvf5daoegl3ephy3st5dsagr4vyo7jn53jdv7vubphwc@iyjiloqftbf3>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-98-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-98-e5388800dae0@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D2C40160006
X-Stat-Signature: n4rdh3npkz5q8a8nc45q95exfe8x9n9u
X-Rspam-User: 
X-HE-Tag: 1772537791-991848
X-HE-Meta: U2FsdGVkX1+gT+v5eHyjAkNcbbzLdzpmTljYxBxdAOzohbH6MqztSGxa0IQfs9s5R4gx6MPLgmUJAUH/opLp8hjNEO+1IOHXFkfSM4qME4qiXy3wDBzmqM28+3pCxzCexMm348tjyKk7dVaogbAFIhrQZ+lW55iXquLeuIH9gViRbg2Z3idv8NQE/8TS6OGi+l6ExqJO0JLsJMQEM+lBSNJJp2fYYPNuMFZqyzpgWo/DrbuQelAgL5C+NVzeTwcb71xDxGeRD+G6ztJjZ9YAgd64J2EczB9J67XIjE9/OTKibVgF5jpHixJErkesi0OSGWc6ENEzgM6jvUUvv9gKrUIB/FXd89KyzG/vnVDHG0sVPEwIEi2/zyO/Iwp3IQjpnVU7QB8UcSjx4Pyjs9RN4mkdBI5w5VYxoNnrDfabzgi9nYLmlRbJDLlWXOFIMf2Kl6y7qpfGvvYEVjV0GcV2qRNYjt+qAcdLAP5Le9bFvLs00MWRZNQSXGKn0nUQF+H+4VsLgxNq91asqLcaOqIwxwshCoTJgleXZHQWKhryO0jctX4Rw45+MJI2sgWuGxf4yYNs6tof5SKPm2bb9hGTSHmvRFf5rxs+jyCwgW+ifClvOngV4GZ4bara/WAXaF0+zcyELkF+tUN3tFAYmhL7HMsrU1a93QCZ2L26vcLdJBvltspuajX571d/FKiY37QgdWFTuoasHhgMicOdE1SHLhvnwkS6Ng9I8woYN3P56P0f7MIGLXTcAkLJc37W6c+pJmkkIUirExJrQvW+BpwbCpKV5myGYk25yhVxa7Rq+D6bdpZU/SevHjpofw33veYiVXqEBIItuhrpImaDq8L8DxM9MWcmL170Cz453Qbd3K/UwSFIaY9VzHKAxeVjgODh8q727lZ++90fq0naGF3/sCYLQJ+LAItSJwawYhfA+n74GrNarTP3V43dkUJxA+YH0TLUdHPc9lW8SmjA4uO
 jKGdcVwu
 nk0ARt+qhA7B7zV7kRC+5uc7+x0TqB6nSraC/8xiDtyrK7DYhFSI+qmudPZ0F2cswEyFoIsbh1RHhGkMA7oPbAlKsdDuOdFHxSxJMjIG/Hquf231Ob7BShB/BQ2iQ0jLXe1+rNHlO8+hyXJ4Ltta/rOpYHwGouuAffViItAQG2t0X43YLZWRdA8rxLs5ZbyJWtunT49c6v3gCgJ7tZtxHcgemxSbfqtTATDd0hx84kCoPy3CmSJ4dwrMhFWGBRgm84mNC41t3nVFoCdxKOgxNXkHaZax/2LP8ZcmT1hkBAcRQ97Edtt4bkadFFAyC5pLUvEfow20Xgq1yeYdVnN/cY7H9Q8qpODmd0xlj8AMVOPDGAB1pn8XTTrYBavvD86F/M4JLp8LmMhm53pa84ZhMiFhSLfODJYzIl4vCbiZZ6rvTyeysjEGXwbSW1U2LOAtaIAemEe8QQBIxQLCmjI9VH+hXDP+1TZFo8JxKvjXqo1CYBe4HvPJpeUYRwOwph3TawP/kM8iSJZArw13Yo79QBQp2eh+yrYkdK5X1zgFj65wtEB66f0HGqG5xSQ5y3HqT6NOM0z1qQXjdQeGl3FZb8A9vnVNjfAO7lL+LEL3pnPRED2Gd10D/Mo/qQHjPiCijYyDNIXxFvObarggKhMhG3ptqrVfd5KNwWlquQ8jJ45wHrKToM5F18+ji+ZUeyvnV1/v2MJmZYJtm4WmcuD+PFO26G1kkoQYlPROHmBx1PGQMwxrrZRVVLsnM8k1Lkd/GKQuVTrz4GwwZh+AQ8zOzSkDlXWKyD5Cd0FOZt22DnhImMpuTB39ccF3LIrbBKzeB7fZktf10/r5wcSZFvPvaY3i85NUMuiXKKNOVIXHCJvgHdLyf+0405f/gxWSv1duqVPTlvzJdAwAPi+4/pLw79krtvL+UAZhA0XcFNHONxktWKxDEEL9C5nVutgtSpn0iiJQtqqetCcbveyI96tiDTshL17Uz
 h3RY+w/R
 HtOffc+E1Ic5HFUrQpBZe+Tz0cYjH2E2R6P066CH2t5suhBGe2ogFQmLeqwJwosirIsjk7dEBacp/aO2vyAmQz7qtG1ZOh8YmCthB0uR5UADNu6k2WDsImj9iutcWSBnkjaORGyTWi/kkPI2VcdedWEYPnl/+JNzQxYFq8RReMOSbc0FsvMuHry6pkOEoEnMi6vzXEvyvp1bgoJLPk5T4rr/23fWXjOAHSVhstDDOQI7Inp9XXw9rav2MGaA1nIeys7sPrp+obgt9Irbiw2Bbu3bASD7Y9Z4IeYNbIJITVw10/BCQIv0W6Otj8/2PGxZxbgTTPaTAcxFoShYriSb7XQ3tRhLoWmYkl5/CjUwONQDp+cLuvZTQrCWAJV4YpzXoXA6bixch3zOsZrloQgEQ/e7E6gSNF6oI9v0pRV/6fOpCYceU6buQ1MgkWbNJA6qhnME26UFmNlCx/vamxWvUW3L/ARAyASB0OapFUY5El2Jmo6UqmlxiPYVP+aUZKNyLRU75Ri/pXfaSGHqRrb4Mi3+p+41gIZr09jB17Fo8/suC0aqWbC/HiJiv8gc1vWd1y/SW6HkAZZUL+XET762Ks8dwd/eaF28UMA30VCWrQObzXLbFXRXsLQv67aLD4sEiKkjxYSxM5LsH5gSpcXqY5inW3+NxwTkYBdf3+GSBOW7bQ57kYGRqrUoZE6cDXmhHAg3/ZrLeo0RAw7AwyKpOIpfnHDGQdt6y7S8uFFrRdXn/wKjm9RZqzjmgxTn2JSbtaavtLBF93JsySgDQ11LG+RRMbQndq+EOcTsPmKbn68buHsw79jnEpqUFxmXwDn2JwcbdtWD3vca3fR8n0gzSguQXZdn0qODQF3/dsqyOci/4XJawZuf2yrgjT9B49/GDN6M66HR5FfGIeRqX4luYSEZiX/MwqhL1/WNeeRryoM+R6ugn/fYJzsaibn+LleVgskb4j9GDFLPl20MqKfYl0+e8DuEM
 kCX/A0pr
 onhyXo/3wnsOIMQUcUsLsRC9woQ1+niEzESeKg6tZcILSEDuyyv0/A6+PkynGRpMLYEF/l2tmjkL2BeUSCH+bcWyAONL8f7bmTdsgq/OvHe2aPsVc4VcpHGQSvsXEgSK5r7TMPXR+ydZ6Xz7WmIk68pfb2xGoVx4uYXlnW98/F0puonyryBMJMNCrZfI0QM9kF/B/syVzWfv+pBnWpD/NtJRSB28rbyxAVJHMqZWJHXVB9Nxw1PFPHRe7G9gkRGE3tubgb0dGcRZbLOMaxCBkJ1+Hco5ec+ceTo0GMw/S9YtRuqqyYGRxu4yVGyonRJerTQYs/tvT3F2D+S6wdhK8OisJg7cFS5oW1psZQ+EPLG/5nrvH0tMxNg7PlqPPCTEXn2461fjbJyHYfIEDoHXg/ryrMNX9lWMrtYEndJ8ZaNDhKswIzi/B0SPl68My5KlzxxzPfFkc9pppy0MdAelXOvipTLeRwKbmiLFs93HU4a7Vb492ctZBE57m2cEtvioNMjBKTd4vp1IQwiFNTcKh/oOqDSacpFqKhuyV7Zx7b+r0xNDCTWr23HIFR+C5VIkOYiyNf2ufd/amtAkAREWxQOw+7H4LPhpbOJ8eKmEBE8gutyyIdrxci6F9DXHSaWVbSvNfZzCe5rhwbWSmbRDg+Z3LKN9uUkMvNULpw7gIHqD0iWImk8uw+XOa3Wbp/50b7Pq7E89U+6C69dzMOkXTVfXFKzLUGAYfSFnp3tajbRF7U0QMQ+XeIYjo9UCQDfqpi8Jd69NvzrjtIDM8LwxxAuehDJ2q8HexCjbDSDZ5W605H+GTyml3WV36S5Sh74RLZDShbTWF7ony2/o0DmzABooS/AFsbFqCaKUQRbZuUKI/KAzEUeJIC4/aNSoebzb9KbqxRUGtwmVTSBRMLJoVUXhPtfye1bETmI3G1tIUowsHQ0cHzWRAXuBA+fTPmV0alimsmeHax73uJzH96S17V+dO15Qm
 R26OYDGy
 MsHSjyQf6T9cWZpfVNAM3ePU/Irbbw6r/zSXmZQ9vhBB+7NQmx7NcEuQqEjEiAIPw3jJFTRq3y0pIz8w+F4MmuIAe1ufEJ6QEfj6xuaqX42A3IF93ZDZrhwZgEeu9YLDzdh7ZlYR5qzVQgOwEPLvNLd/8ydNDVzs29S9jJe9zHwd6Whllp/ixznBUsvigdmdwMyYRksskRZvjicjG1Pj6/th9ood9tGjX5BwIbyQ1EhOB9cud+Dvpu9YLApY56BdmYsDgeaR5kFlTDtJCl/Q8Yt9XZxnnwZHR4YujKYDqDVWtVPhmuNirgeA79XtqsGfYDRSyc4DeSEZm7dNDl+35AIg0xWwYFQvlsrcpvw2ZPYcf+RxDklfREO1yuaGNFqj7YRHR375+Mhokp/qtGpVowD4YGorwJzErKqF+rH4szLVP/nmAjrwe2vkPDXkiRTZIQsvDrn6nRkYmGDzHRx4Oi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:25:22, Jeff Layton wrote:
> Now that i_ino is u64 and the PRIino format macro has been removed,
> replace all uses in udf with the concrete format strings.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/udf/directory.c | 18 +++++++++---------
>  fs/udf/file.c      |  2 +-
>  fs/udf/inode.c     | 12 ++++++------
>  fs/udf/namei.c     |  8 ++++----
>  fs/udf/super.c     |  2 +-
>  5 files changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/udf/directory.c b/fs/udf/directory.c
> index c825e11c017f652500a3dfc83905679ef86ec570..f5c81e13eacb17f931d2df564ec4f2a6e9a5d7ab 100644
> --- a/fs/udf/directory.c
> +++ b/fs/udf/directory.c
> @@ -22,7 +22,7 @@ static int udf_verify_fi(struct udf_fileident_iter *iter)
>  
>  	if (iter->fi.descTag.tagIdent != cpu_to_le16(TAG_IDENT_FID)) {
>  		udf_err(iter->dir->i_sb,
> -			"directory (ino %" PRIino "u) has entry at pos %llu with incorrect tag %x\n",
> +			"directory (ino %llu) has entry at pos %llu with incorrect tag %x\n",
>  			iter->dir->i_ino, (unsigned long long)iter->pos,
>  			le16_to_cpu(iter->fi.descTag.tagIdent));
>  		return -EFSCORRUPTED;
> @@ -30,7 +30,7 @@ static int udf_verify_fi(struct udf_fileident_iter *iter)
>  	len = udf_dir_entry_len(&iter->fi);
>  	if (le16_to_cpu(iter->fi.lengthOfImpUse) & 3) {
>  		udf_err(iter->dir->i_sb,
> -			"directory (ino %" PRIino "u) has entry at pos %llu with unaligned length of impUse field\n",
> +			"directory (ino %llu) has entry at pos %llu with unaligned length of impUse field\n",
>  			iter->dir->i_ino, (unsigned long long)iter->pos);
>  		return -EFSCORRUPTED;
>  	}
> @@ -41,20 +41,20 @@ static int udf_verify_fi(struct udf_fileident_iter *iter)
>  	 */
>  	if (len > 1 << iter->dir->i_blkbits) {
>  		udf_err(iter->dir->i_sb,
> -			"directory (ino %" PRIino "u) has too big (%u) entry at pos %llu\n",
> +			"directory (ino %llu) has too big (%u) entry at pos %llu\n",
>  			iter->dir->i_ino, len, (unsigned long long)iter->pos);
>  		return -EFSCORRUPTED;
>  	}
>  	if (iter->pos + len > iter->dir->i_size) {
>  		udf_err(iter->dir->i_sb,
> -			"directory (ino %" PRIino "u) has entry past directory size at pos %llu\n",
> +			"directory (ino %llu) has entry past directory size at pos %llu\n",
>  			iter->dir->i_ino, (unsigned long long)iter->pos);
>  		return -EFSCORRUPTED;
>  	}
>  	if (udf_dir_entry_len(&iter->fi) !=
>  	    sizeof(struct tag) + le16_to_cpu(iter->fi.descTag.descCRCLength)) {
>  		udf_err(iter->dir->i_sb,
> -			"directory (ino %" PRIino "u) has entry where CRC length (%u) does not match entry length (%u)\n",
> +			"directory (ino %llu) has entry where CRC length (%u) does not match entry length (%u)\n",
>  			iter->dir->i_ino,
>  			(unsigned)le16_to_cpu(iter->fi.descTag.descCRCLength),
>  			(unsigned)(udf_dir_entry_len(&iter->fi) -
> @@ -78,7 +78,7 @@ static int udf_copy_fi(struct udf_fileident_iter *iter)
>  	}
>  	if (iter->dir->i_size < iter->pos + sizeof(struct fileIdentDesc)) {
>  		udf_err(iter->dir->i_sb,
> -			"directory (ino %" PRIino "u) has entry straddling EOF\n",
> +			"directory (ino %llu) has entry straddling EOF\n",
>  			iter->dir->i_ino);
>  		return -EFSCORRUPTED;
>  	}
> @@ -184,7 +184,7 @@ static int udf_fiiter_advance_blk(struct udf_fileident_iter *iter)
>  			return 0;
>  		}
>  		udf_err(iter->dir->i_sb,
> -			"extent after position %llu not allocated in directory (ino %" PRIino "u)\n",
> +			"extent after position %llu not allocated in directory (ino %llu)\n",
>  			(unsigned long long)iter->pos, iter->dir->i_ino);
>  		return -EFSCORRUPTED;
>  	}
> @@ -272,7 +272,7 @@ int udf_fiiter_init(struct udf_fileident_iter *iter, struct inode *dir,
>  		if (pos == dir->i_size)
>  			return 0;
>  		udf_err(dir->i_sb,
> -			"position %llu not allocated in directory (ino %" PRIino "u)\n",
> +			"position %llu not allocated in directory (ino %llu)\n",
>  			(unsigned long long)pos, dir->i_ino);
>  		err = -EFSCORRUPTED;
>  		goto out;
> @@ -483,7 +483,7 @@ int udf_fiiter_append_blk(struct udf_fileident_iter *iter)
>  		   &iter->loffset, &etype);
>  	if (err <= 0 || etype != (EXT_RECORDED_ALLOCATED >> 30)) {
>  		udf_err(iter->dir->i_sb,
> -			"block %llu not allocated in directory (ino %" PRIino "u)\n",
> +			"block %llu not allocated in directory (ino %llu)\n",
>  			(unsigned long long)block, iter->dir->i_ino);
>  		return -EFSCORRUPTED;
>  	}
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index ab8093b87dc8f21ce8af6a72621e2868fb4b9a82..b043fe10e5d605b62988512bbda65bd357fb649a 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -133,7 +133,7 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	int result;
>  
>  	if (file_permission(filp, MAY_READ) != 0) {
> -		udf_debug("no permission to access inode %" PRIino "u\n", inode->i_ino);
> +		udf_debug("no permission to access inode %llu\n", inode->i_ino);
>  		return -EPERM;
>  	}
>  
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index ecc22aded0d287ccdfb34b42a0d82e392054f585..902f81729bd886a534c9da644771c7c04c067cbf 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -147,7 +147,7 @@ void udf_evict_inode(struct inode *inode)
>  		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
>  		    inode->i_size != iinfo->i_lenExtents) {
>  			udf_warn(inode->i_sb,
> -				 "Inode %" PRIino "u (mode %o) has inode size %llu different from extent length %llu. Filesystem need not be standards compliant.\n",
> +				 "Inode %llu (mode %o) has inode size %llu different from extent length %llu. Filesystem need not be standards compliant.\n",
>  				 inode->i_ino, inode->i_mode,
>  				 (unsigned long long)inode->i_size,
>  				 (unsigned long long)iinfo->i_lenExtents);
> @@ -1386,13 +1386,13 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
>  	 */
>  	bh = udf_read_ptagged(inode->i_sb, iloc, 0, &ident);
>  	if (!bh) {
> -		udf_err(inode->i_sb, "(ino %" PRIino "u) failed !bh\n", inode->i_ino);
> +		udf_err(inode->i_sb, "(ino %llu) failed !bh\n", inode->i_ino);
>  		return -EIO;
>  	}
>  
>  	if (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE &&
>  	    ident != TAG_IDENT_USE) {
> -		udf_err(inode->i_sb, "(ino %" PRIino "u) failed ident=%u\n",
> +		udf_err(inode->i_sb, "(ino %llu) failed ident=%u\n",
>  			inode->i_ino, ident);
>  		goto out;
>  	}
> @@ -1641,7 +1641,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
>  		udf_debug("METADATA BITMAP FILE-----\n");
>  		break;
>  	default:
> -		udf_err(inode->i_sb, "(ino %" PRIino "u) failed unknown file type=%u\n",
> +		udf_err(inode->i_sb, "(ino %llu) failed unknown file type=%u\n",
>  			inode->i_ino, fe->icbTag.fileType);
>  		goto out;
>  	}
> @@ -1942,7 +1942,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
>  	if (do_sync) {
>  		sync_dirty_buffer(bh);
>  		if (buffer_write_io_error(bh)) {
> -			udf_warn(inode->i_sb, "IO error syncing udf inode [%08" PRIino "x]\n",
> +			udf_warn(inode->i_sb, "IO error syncing udf inode [%08llx]\n",
>  				 inode->i_ino);
>  			err = -EIO;
>  		}
> @@ -2224,7 +2224,7 @@ int udf_next_aext(struct inode *inode, struct extent_position *epos,
>  
>  		if (++indirections > UDF_MAX_INDIR_EXTS) {
>  			udf_err(inode->i_sb,
> -				"too many indirect extents in inode %" PRIino "u\n",
> +				"too many indirect extents in inode %llu\n",
>  				inode->i_ino);
>  			return -EFSCORRUPTED;
>  		}
> diff --git a/fs/udf/namei.c b/fs/udf/namei.c
> index 32209549a31f451a486918e673a41497bef42e89..ccafcaa9680982decaabc180833b67ace5c92973 100644
> --- a/fs/udf/namei.c
> +++ b/fs/udf/namei.c
> @@ -550,7 +550,7 @@ static int udf_unlink(struct inode *dir, struct dentry *dentry)
>  		goto end_unlink;
>  
>  	if (!inode->i_nlink) {
> -		udf_debug("Deleting nonexistent file (%" PRIino "u), %u\n",
> +		udf_debug("Deleting nonexistent file (%llu), %u\n",
>  			  inode->i_ino, inode->i_nlink);
>  		set_nlink(inode, 1);
>  	}
> @@ -809,7 +809,7 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
>  					       &diriter);
>  		if (retval == -ENOENT) {
>  			udf_err(old_inode->i_sb,
> -				"directory (ino %" PRIino "u) has no '..' entry\n",
> +				"directory (ino %llu) has no '..' entry\n",
>  				old_inode->i_ino);
>  			retval = -EFSCORRUPTED;
>  		}
> @@ -821,7 +821,7 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
>  				old_dir->i_ino) {
>  			retval = -EFSCORRUPTED;
>  			udf_err(old_inode->i_sb,
> -				"directory (ino %" PRIino "u) has parent entry pointing to another inode (%" PRIino "u != %u)\n",
> +				"directory (ino %llu) has parent entry pointing to another inode (%llu != %u)\n",
>  				old_inode->i_ino, old_dir->i_ino,
>  				udf_get_lb_pblock(old_inode->i_sb, &tloc, 0));
>  			goto out_oiter;
> @@ -869,7 +869,7 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
>  	retval = udf_fiiter_find_entry(old_dir, &old_dentry->d_name, &oiter);
>  	if (retval) {
>  		udf_err(old_dir->i_sb,
> -			"failed to find renamed entry again in directory (ino %" PRIino "u)\n",
> +			"failed to find renamed entry again in directory (ino %llu)\n",
>  			old_dir->i_ino);
>  	} else {
>  		udf_fiiter_delete_entry(&oiter);
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index c6e372d573885742745d3ff4b3b017facf228a32..3a2d66c7e856383cc5c8a605180a9582396ba805 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1166,7 +1166,7 @@ static int udf_fill_partdesc_info(struct super_block *sb,
>  		}
>  		map->s_uspace.s_table = inode;
>  		map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_TABLE;
> -		udf_debug("unallocSpaceTable (part %d) @ %" PRIino "u\n",
> +		udf_debug("unallocSpaceTable (part %d) @ %llu\n",
>  			  p_index, map->s_uspace.s_table->i_ino);
>  	}
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

