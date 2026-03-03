Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F791EC1430
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958766B019B; Tue,  3 Mar 2026 06:32:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915096B019D; Tue,  3 Mar 2026 06:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3486B019E; Tue,  3 Mar 2026 06:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6645A6B019B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:32:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D9BB14013E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:32:21 +0000 (UTC)
X-FDA: 84504538482.18.4492EC2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id CA667180002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:32:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qZixKyc0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vTR9ctkM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qZixKyc0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vTR9ctkM;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzhnvihOfHfydYiO1CwZD2NgrteYNhrJZScxCSioSLs=;
	b=NXc8KKzVV/WNgUJNbSBDRSThpFWCE8reYYPtDqt40QwxaBhrWhyHkCWpYv9S2zSlMzZ6RX
	SYS2eseuLpqUg5w86yLYdEu9yI1mSIzn3rVPAhD+7UuhPTwbRfgef/2disOkwarC9JmdKZ
	AQMt/DD9F9h0MbPRKvl6Z1GK6kc/oic=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qZixKyc0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vTR9ctkM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qZixKyc0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vTR9ctkM;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537539; a=rsa-sha256;
	cv=none;
	b=kSr5wYETXy6qdte0JKF/rsXurCSLhr6Vf/p9g03AvpEc/QNP2OOd1HGrOOQmLQB1Fh9X1Y
	wGCy8OrYDUCl438P+qWcuM73vK0tR9mwSqAkuOine2lF0+TTMpvs4O0gqqiO3SXsmqq3CL
	e7aQzZDWYCoAl41jNJ+wrzUPWNmBHSI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 640475BDF1;
	Tue,  3 Mar 2026 11:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzhnvihOfHfydYiO1CwZD2NgrteYNhrJZScxCSioSLs=;
	b=qZixKyc0tT2bdyykJ4KebrYwpRE96amUtxEvkOfDSqAfZauAZbLqVj3b3hg61ZPWxZbF9C
	OUpSbd6Rg4p+mjWRKNToHt5JlNJ3w2Cbe2e9l0ZdodQBbVtB0EnILd3o3uZTc8HcEgGrhH
	BopqWcNrZKr9KtyWXmvVajcGNzpqpk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537537;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzhnvihOfHfydYiO1CwZD2NgrteYNhrJZScxCSioSLs=;
	b=vTR9ctkMvDHxvhaSZs0f7E6BCo0TNU+oZifncBH21JXuweYA50y0R7NXn3t7Epi7ng2HSo
	BQ7+h+d05nukQJDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzhnvihOfHfydYiO1CwZD2NgrteYNhrJZScxCSioSLs=;
	b=qZixKyc0tT2bdyykJ4KebrYwpRE96amUtxEvkOfDSqAfZauAZbLqVj3b3hg61ZPWxZbF9C
	OUpSbd6Rg4p+mjWRKNToHt5JlNJ3w2Cbe2e9l0ZdodQBbVtB0EnILd3o3uZTc8HcEgGrhH
	BopqWcNrZKr9KtyWXmvVajcGNzpqpk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537537;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzhnvihOfHfydYiO1CwZD2NgrteYNhrJZScxCSioSLs=;
	b=vTR9ctkMvDHxvhaSZs0f7E6BCo0TNU+oZifncBH21JXuweYA50y0R7NXn3t7Epi7ng2HSo
	BQ7+h+d05nukQJDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4DEC23EA69;
	Tue,  3 Mar 2026 11:32:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gj8AE8HGpmm3UgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:32:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 11AD7A0A1B; Tue,  3 Mar 2026 12:32:17 +0100 (CET)
Date: Tue, 3 Mar 2026 12:32:17 +0100
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
Subject: Re: [PATCH v2 062/110] jbd2: replace PRIino with %llu/%llx format
 strings
Message-ID: <qc6zicmkpuonxte4exzsrh7a4dstbhpughp74tqf3w5okgetto@huf6zcd3bf6g>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-62-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-62-e5388800dae0@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CA667180002
X-Stat-Signature: s7bb6ts3a6aq4gp38oz5t19kn4wzzbk3
X-Rspam-User: 
X-HE-Tag: 1772537538-568902
X-HE-Meta: U2FsdGVkX1/Flx+oOOmKVODB9VUUE5RSWNN6RqW9TBQUG+SMu+ZjyS9zxHuvQLwZJoEimvWoen2dVHJpR24Hc0GpYGEaGDJaL2PBAxinx6Q8azqMar6DgktwTq52fcGrZeEvZibvgu3hIuJ/BrjTl9OiYDk/GvpyjwtCAPpJ3qWy4gUkyv0nn4fN5HZ6ILIfK8ejIVzT5tt2xvhvaqo3gK3KtIDj5PmZKQ5cg17mrkqJwHn3ZVMmJbSxYzOZqa/dNfETsni/64k/GjI/A0oADsQCbl0kQIJ0UbtEPomPwYrf2ETYHPnvtx1dpsG9XIJtVCpP49uTu90L4TvDHT3XZ2l36qlW44FHDhGMHXOLg7JDNTPamWXG+oTNHM50r9inbesRPkNYhmHvGT9Bae8VbM0DUngHUdIgQouv8aH1DDf2C/XlIvOBm6yPUZIqRYNHgrtvP0V1T/7jhvX3mhDjNW0SgEuLDCoVaww0ZY+eSuTGFYBS0iLVYAa/AuPzN6WzVpTt+kQvr8Q/QzJlTsNjyn1geQa6yeKe2RnEoiCX2fx9YZK6mkiOrJzRTbPgrp4EGBy2r6qQNxsooOXhLJwbLTz1N898txZS3MDeUJtXrh0lII6+BIA0X/yt9wyNR6XAK5OYB5EdK/fze/V/sHEyvc7Zukgt0CykUk353H+cESoeIZALAddIMPVYxjE91aFW+GGENoiTr5WlirygkD9EunXBd+ZShpeWYRyy+afdP9hsl3Qx78nEnT2xC4YMuuQGfCB84y8pi5d7Gg0TGmCcEEAPt8RSUzOknuxPtt7sXlaI183sR8xV5eSrPM0m3F6V8FvzP/OLTCYNWT9f8goSmqau9FK0RJITM3pG8RKjVXyIuvLt3NDd4KRTM4mTGWUO/Jzwhm06w6wnvXWcz5pmR47ymd7FTVm1WNGcuTZbwk1neLzExkhMm/ShgseejR5kgXhe9TtotNrI5i4uxE7
 mVehJ3Jy
 x5dKAYrT+VRDSv5xXOXyTVs1NEemnNfHYUylRGpLoeX40Vo05ITRj0SnIbCyyxSuQwGAoeqED1PRUU3pKMGVy1OTu7JObr3dBuOMV0PqCttVSxj2q0vLEmUfgsYBx0ZLITJShETPgHJ9KvqhLsXK+ipWcqiYt39WYdFEcf6CuTSZo3+X6hFjSIhxE9nVKwH7LbykXp/JL5hE/7hRqL++oHa9XHXRhePriDf6rcBuiyeV1m3KsUvU4j6braVZ/OvZdI6viNeYvSAPkOmekwRFIAZhhHhLQqnr0auaRHlPgiUV9KtUIPJ+zuL/se45IkOrgUnMLpLhQJSJZgQ87Vbe8bPifbIukd58gABCRd6ud/fq/zCgxjFSLB8vJsJrvbCsp1LB263O5d676Lm2X+DA0Vhcaga+vgJltQbtIenQL7yYV/YsjCDZcI5483KZondIYnXy1KIHt0LmwkRneuiLF3EbReK45ydip26aqYYmYl9+AynUvfh3zGCAIh5Xps7Rb2fFFsGgCz9/b7XtL97yAA1j7MAEArvAMgkiYjnyWcWiLXDdAKvcDsPKTTkT2Ms7fzncCC/WWFur5VgdlX+z6j3fBtF+GjUxyFth7Vc2JHvQosxRqMJzHJnXaH2osuhTWCU1ZInjnQFQFNE+KxnYGR67GwXlLCzjHeqPovAyUoRAy4BkXxM6hGLwisZaxwcltha3PfDrjuBHdjnmcGxbDz+VlLZY/VBWrKrkgwKJ1VKCAJbznuxiKM43t4Zga4CvdTKqXHTaV5Jm5hjBcUY5XNxd5h2yU06ZHdcQY/XZX1Og2VsFDSiZeZVGY7rLgqrl5wRcf0pvrQAp8oH0n4G4zCwdTTkRsDDybWWJdHQ4p2ayLtmG+vLegIW9c8+QtXSVx3S9Wn0GxPwOGzgFjlHMrW0E5CCJeZXSTyHde+cW/eB9F+bJ62bS94aDZqfPFECX51IMfIfhRQQUbP+CUUWMwtjXvUwTg
 KiPMCSk2
 OvPUUreUgNAUkRmGQ2dUgblyR29vOv5vNvUgXq2b3GMVHdYQ5bTEiDa1UrhLv3p//PiQoIbdqcnaloBsY+nmdwFSo3fxLKB5J4AwX6+CKZAWWUY88hCFpMn5hCPrTdmTD1peiYWYgaEXUHTus7vILsjVF4a0d3qLcsCzexd4XH/sKhhojXOkmoXflQLCiPFYGtKNrSDKC7SkezjX4QbLyOL0P7cTNzBECdcaP2WTem9otIS1nUymcj7jSBAKPr/3tutmQZ8fcZSgl1QMRXMbW4J5tyBOQ445hFN2jizutnpU7n8zCBpm5ItqcvXmJzmz4FFFcNJj22HGTjQvkDX0cCC2HJMxDjWJwbgNdKgoDXJj14akwMgLX0VHyRn2CEHLQ/U+xQzB96R5z7RFfYxzFCV+PqSF8DWKx4MhwhCYuJmeo4Wt4jp6ZUKzSiB+B1RN0LRmaubWLfNW7F8jUBlc4x/r/i03sWUuRxHmHWzhRGVy4yj6n1UOgTRAdbm50dMOe4k2NgYpB3s5+GnYvARgrUKoaia2WLE5GvHuetD5PzamvlLoVrmM1+ND9/pypLzz/mN2u1DeJabb8EZW3rOz+/IW4ZwFud2/8YBNhEW0y4cJdQlxyS9LGZ0b0XpbB32UlchX6n0oNc/swL8YVI3Y5vBgubhTGGPXK2h69q5sw4qIb1SyNzzzlkFjLMJaaUiif6LmywYYz42Dq/76faLQtD/RFWDHmj8/sRqOFIVJqB47wqEV/MC/NUhP8nkR2bwvHz2Pw9ABmKK8Tfv3pKz1Z7y/78rhp76u26VE9rYOAepd8+qpehCWr+ohdvZ35bBkJtxeWRf/0xnFJgeRkKE/DamRNOad+Z9YdSQg8sIUlIyilFEfhKokvgARbw603rXVQkMnxeEgJwD2MVP6Y+8Sa1AHpqUSe+vYeI++aQVFR2yB3rQEINoITGv9Z6Z33BHY7gh00a5sDXahKCY68TQ9Ajyb2+Nw8
 sT4yRzzw
 rcPRfHro8/HU9xHra7th7jQIlF8AbBEZ/Zzr5Hkko21QmyeWs4DcN3UoAcj63Z7vC/08Mxtrv2M1nGEqxc1S7nJ4T6oEvNguHkaIFF1DwzjKP1d3I9oWcIH4cw91BaFqw43+EYzXljW4khxlb6KlmF5Ubn6GXsnRmsm4Rr7X7iW6FUK5/4q8NmKRjlEyOQNtLHlpVeLzTqos0jEHKsrajwzCf2Q25B1PmRzghuehOcPnSQI5DMdhLHEmfYo5Gi0ddwxMJhjrOyZY1RTfIYJbP5kGXq/xzpy4MvoOMYvSp67rCY7WZFzWYHIyfpA+t9XP2VQrZq6ICsTkBPme6/CJ9vXu1JIFHYRk4xSCIc5S9J07cEUd+JD9zOzacUQ030V63cglTM71A+YJBmzwIyw/ChqYLbyJewQq0n1r+KaFPU2a4pZMhF3Jmaafgi0K1UMq2kf/0t4IBnIWQibV5QyNYjbQ490j4pbEegkd+gaC1LPM/dedMb3OiYdj7lQ6TxvOjbpZSImA1hZo/XLcSy6VTgOp4hswvj4Dj9Xtpm8Cpx5KLDZljHO+osE/btQriiu9Fo7Ly4n1TjqJAtkgD9ojfiqp9Xsq6nkqE1Ffu0ocB6B/PPzFSKjhs+3oVxNBfiRvi2Y6ZbuOO2BPg3jWK7jdiq1fX7O91ec5E2Ds51SV3PusxKvrBp74VOHawGQVSNcP8HSyYbKzDEzphSE+vDg+2IOwM2NNkQh/eXGw+oHsqdAaD4I3QmxeAZNsshBDtQ/PCBTQtjIpzdgtVIjfw3bBwOcIsBz2exiWGFWFNJyf5TDXTkfaVogwybB5mwcsX/2883xqZhYbjkeKfL7m2jozyUlf+Vf0omzY+CatKUxZtVi/AwuVfcn1dQIzMZXU0aaleYbdkQfa1+IZl8h+ljCRR8+gLothD7JdzRhio/Wg5rBEKvuDXAI1XNbL4kjdp9jaBaEKn03HNClmLWSpX5unD2PfP2kgm
 tuPfPEnX
 cp6NLR2XSl04bZCrvFKlmE7PJLDbeKNBjtXFUCy9FWATfewVQeXtGsFrbdVKl70aSHn+0Yqrcr+ICyR3zTJOpdvPt5DvjIqkP8rc5QP1GATgkV8dzP5xTluEnRGaQvCe4e9hJpha8jzMIjXCi2TlmSlYQXTqWJgHEML+D+4C0vX6fjH5Cjhd68FZ3OfX7cRVnC6wwMLgBmimPomWqprvQ9cII04eI1x6BRydPXIrxWo/ywh43m2WNgQHUITIYRLlTpDUPJkWXawiio5jlIQl2H001JGAwpchPzfVYKBAR44Ib8MaiqGPm8/yfV3nemZx1tMvkXxraX2szIw86o9/QFqKL0J+xxEeQ55LUfafrZWgnOapyUn7G1rffzLwyH6vtW86WphREY/yTSTWLT+/tPakJ6NGwv29y8K3OEaZ8v/pWsnPeQ2bc2w6X9+ffnxZBJYT8f9AFd4Yp/O3zWPlWI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:24:46, Jeff Layton wrote:
> Now that i_ino is u64 and the PRIino format macro has been removed,
> replace all uses in jbd2 with the concrete format strings.
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
> index 9df937f0e15c71028038e1c0c12159421a2444b4..b60918ed8a9965efe42419e6de3f449be50f7ca0 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1677,7 +1677,7 @@ journal_t *jbd2_journal_init_inode(struct inode *inode)
>  		return err ? ERR_PTR(err) : ERR_PTR(-EINVAL);
>  	}
>  
> -	jbd2_debug(1, "JBD2: inode %s/%" PRIino "u, size %lld, bits %d, blksize %ld\n",
> +	jbd2_debug(1, "JBD2: inode %s/%llu, size %lld, bits %d, blksize %ld\n",
>  		  inode->i_sb->s_id, inode->i_ino, (long long) inode->i_size,
>  		  inode->i_sb->s_blocksize_bits, inode->i_sb->s_blocksize);
>  
> @@ -1689,7 +1689,7 @@ journal_t *jbd2_journal_init_inode(struct inode *inode)
>  
>  	journal->j_inode = inode;
>  	snprintf(journal->j_devname, sizeof(journal->j_devname),
> -		 "%pg-%" PRIino "u", journal->j_dev, journal->j_inode->i_ino);
> +		 "%pg-%llu", journal->j_dev, journal->j_inode->i_ino);
>  	strreplace(journal->j_devname, '/', '!');
>  	jbd2_stats_proc_init(journal);
>  
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 2a03d4eafdee95e5caa8dbd0afe4e32ef4104378..a90f9092706cceea56c1100f7d40ccba0d50adba 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -2651,7 +2651,7 @@ static int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode,
>  		return -EROFS;
>  	journal = transaction->t_journal;
>  
> -	jbd2_debug(4, "Adding inode %" PRIino "u, tid:%d\n", jinode->i_vfs_inode->i_ino,
> +	jbd2_debug(4, "Adding inode %llu, tid:%d\n", jinode->i_vfs_inode->i_ino,
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

