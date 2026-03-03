Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 055AAEC1431
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64AD56B00D2; Tue,  3 Mar 2026 06:24:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8886B00D5; Tue,  3 Mar 2026 06:24:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0896B00F4; Tue,  3 Mar 2026 06:24:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 390096B00D2
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:24:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD4841A011A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:24:05 +0000 (UTC)
X-FDA: 84504517650.30.0C38210
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id A4C1B120010
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:24:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oy8pWoHq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jJuhp4wn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oy8pWoHq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jJuhp4wn;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7Yl9Dt7jVlcVQjEf63B1tQYNVt8eYC4EdfdZsuIVJM=;
	b=3N5igbcItv+UJ9nY927ZFFcmwz9+hAqe+y0VLUaTKUZIDQ1urvjSyQJXPV6xKvNaXvyaNB
	NTsYoOJsM3bdfPWb/FrFqPDlUrDodRkA80ki99vg5wT+OqOtxXuu9prMj/lgHawjQQ2XBy
	9qLGB6YgkcrqIoYApYRILkXzK7WDHJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537043; a=rsa-sha256;
	cv=none;
	b=inOYMEnjmZwKj090/kb5bm/sNIWvXHHk9BVZDvJGhzGdeYIiCUGZwCLQ6T8RyEIRo/Yb3/
	h9QTJq8MWIW3/a/hO614zkeeO9yTLvI1iqOnOn1h0KaRVqPCFJYXMwgTghT9Km1iEO4YRo
	42RAdEZLic1f/U3t9aBZS87Lh4RXvD8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oy8pWoHq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jJuhp4wn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oy8pWoHq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jJuhp4wn;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4BF235BDF1;
	Tue,  3 Mar 2026 11:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K7Yl9Dt7jVlcVQjEf63B1tQYNVt8eYC4EdfdZsuIVJM=;
	b=oy8pWoHqrMEHlN4brCXg2tPFAhfnj7hNnLiWr7QZqvLnhUUVRLml6dG2v7DgEPSLDnZovj
	KAXy3PwMSytjm6CRgomx/IgEopJ3owCZp+3PaBD8ZCWWFIlSZ6TreqR/OCjywszkRFPjhM
	RZ129a6nRDsR1gOHwRCIua5AvBIGjGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537042;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K7Yl9Dt7jVlcVQjEf63B1tQYNVt8eYC4EdfdZsuIVJM=;
	b=jJuhp4wn8vYJLdotyAquo63x/02x111qPRtzSjYNdGjAowRt5gzgynAxTUYw+Ln14/yoSt
	LKDZZhnGQ3WO8cCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K7Yl9Dt7jVlcVQjEf63B1tQYNVt8eYC4EdfdZsuIVJM=;
	b=oy8pWoHqrMEHlN4brCXg2tPFAhfnj7hNnLiWr7QZqvLnhUUVRLml6dG2v7DgEPSLDnZovj
	KAXy3PwMSytjm6CRgomx/IgEopJ3owCZp+3PaBD8ZCWWFIlSZ6TreqR/OCjywszkRFPjhM
	RZ129a6nRDsR1gOHwRCIua5AvBIGjGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537042;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K7Yl9Dt7jVlcVQjEf63B1tQYNVt8eYC4EdfdZsuIVJM=;
	b=jJuhp4wn8vYJLdotyAquo63x/02x111qPRtzSjYNdGjAowRt5gzgynAxTUYw+Ln14/yoSt
	LKDZZhnGQ3WO8cCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 356003EA6C;
	Tue,  3 Mar 2026 11:24:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KO4ODdLEpmm1SQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:24:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D1FB8A0A1B; Tue,  3 Mar 2026 12:24:01 +0100 (CET)
Date: Tue, 3 Mar 2026 12:24:01 +0100
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
Subject: Re: [PATCH v2 029/110] ext2: use PRIino format for i_ino
Message-ID: <ru6heof6ndlg2doksb3mhaz2gnfdt32pqkiwv3trx6ppbmtu3l@466clvjonlps>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-29-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-29-e5388800dae0@kernel.org>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4C1B120010
X-Stat-Signature: 6sske9px3q1n1k6fcca5s31rycrayu6z
X-HE-Tag: 1772537043-645619
X-HE-Meta: U2FsdGVkX1+7TFhXK/prsdeaO7u3C4iBlGzXO+pcwly/sYwkUd/S9xD8FouFVXUXtLqF/mO1re3QnNwhJhrlqiyezR11OBU4n5nAJqk4RjXbSFsIzu+kbabNJ9VQs4tEFse/Q3DKKQbXiwAa15s5lmQoewJrDUGMcXMqWsuGAo2IO4bK6XtI5jUkxWTqIcFWsqgRekev/vky14s6P3Zugf2JCzHo8hQByuvTWaDX6Pc83p8ZdxqanHRPJMZIx6sPWm6XuzdbBpibNGuZusjfSC/XdCSqA7eOvZx1FSuEmuzxymhHpBObBLSEXIXcnQSBR0v0XIr2xAE/qhVvU/c6s8eTGTQJZ/00M+0PZD8u8tDpYDctozV75CHg43ljmuzLZynWckVR5NJGexq1eyQo/+WmZDHAn1U8UlU8GTW2M6boPIiXmXKZ6QeHwdv6yjk9gkih3sMgMBVgi1O7OBGdkdoC13u/ceJAhocg+JucbYNPu09GCCPsdZ0jTba6FLYpRH+4Z2yC4G8b/211vFRawht7evaWjMZJGRztTkDlPiK0nztinWETEVNFcgNotGW9Ewi1Y4BEfTsXh3F5wKDpk5aNbt5DcArFVZRxiLI8g7YUpAF8XgCRK9l+c+wZ98gPbSQnir80jgZav86z6oJR6B5M3ciwO5c76ZLcaCK0kYlO1ihcHijvUk5dcSPsKOxcnyokr/m0R5SgWdGQ/9bulPy1N5ksITJxuVPdHR3xVC/Uw1Jz+kRPPMXtnoOssex4mns1pTSLvnIqrLC+4yqF6eo1cgSHD7EzmWabQSahHr50K12BeVSkw3Y4VlJQGVgmkuxTdsttiVnhJXSocmKoU9c0/kI02vDsAajouLf7pk+Arh498vgSwkMWt5blO6NVHykW1khTL6b1bKwLui7VvPJFB4a9ntfykvRkOVWrvXBZKunfopS4+CFNUGNqG2cLi5JdIY2QSPOvfxiDZiC
 DhoBlRkI
 /SI4nPKSASScj1q4+huQVN3OnrQcaHm3eW00ocKLme02C7OE++uhJUxJF1hNZC8EXR/0z+8zCC9G+/jsfNuOen0DisAiKCEKFn7Zcp8HKc56LirPZpdztBYCfpYfvkKSu9FFJncVUcnQazWp5IvAKvLTybvwpJRt6lUwZJh3vrJ05t3gDxvSzmpCWzvVDbS3t/HzBTXYsi/xI8RxyfTVgTLyjihhHmMg+2yI+Puvhy3eYmwvBujnLyZ4nvEJsmad2YlZ57RNiJWpB7qYCxReSV3I6XV3CJvYi649vUWFV59mEVku9VlnyyQv2xbXqIShlkX76sFuBTLk4625+7PsVFDlKrAQETXpbBi4hU3PT0IIiziSv6Mc7W5gnB6jxC96RnciBnrfxWREHjhbd2+HusNDA+hKNpFD/hHOAR4iS9BqYqirCYWr3okr2uaF4HwWBEBM4v5xC1dIzNKMAgEgrTdVqiLYxUrVzwUDip/59ZFfgDqUIKEP/AblPkXd2b6f0JT1qzL/L102JL7oR5rLvNOV0B5sQ6VTHC0hnmCLOTQAlqtTpKjsvt3E3XMrypW+LU3AKHqWpq0M33pMrB7mVyzntfXWq8a15M0Y9kRtMNMhz2HFIp6thhRaz5e+RE7kgt1yuSXZZfZEtlPpUEyLkp+V0F8v6XOCs2Wpd/Mr1SWrBQ7DIidjJ4HSRwzi1aZCKwhYhdQpjTEJPnFs3MfUzT5zsU4RGpwDymKaR+kphvPu4jETD86+xfYslVq+nWjOwn7OdrA6k8NcDYYF3sVURd+nFbJPdJlh8zfQqheQ8g27P9KoIbI3RfKqGm7ZXfTEge1CS3+mJQWpJ8zn3DrgLqA04fjkBBTNp2l7qjqnPyTQVMp+oN/TBP6JV5hwic+TG+yhuVtP5xm7ooqVPuwxMEvcpMG6JOHd4PleWAwlfL+glZPLatv1wJU6NZ3+8aRzShmNwooAhZD4QA/p1MtuhTQqW7Azv
 W0+8HM0A
 zElBBBYMlfIlomU7rLv39Wf20UgSWmOpzsgN3UmDcpKOIvE1+2/msmBRTPs7sTmSIqsUubs4cRkMSyCYROrLRxhmMrEqVaqOp2K+f72o8bpsERICmykBY9zIsmpZwomPzTF57cmtPzM3RAgsPndddhGcO1XQ0ExqqjUKNFds0WFQkjvXaZPbkM5ilCpfyEE9FlQ1QJvzGThP2miL7Ux6Ycii+f1cczK/byy8oFI6Tx0xILGyyltTOsjErjepihJFZuUk0jkCBjumUo+KDTqmT2u8J3uHM9aMUfo4Ro9kKIvvurzDuCq0qSM64EE2+DpJjHE5KZwalvX2WJbYbHmdJrZr6qwU8ROPlJldNwaZdlkso+Wl7z8UnADaPxsV5W+eBd0AxL7A7sTDGYKtyhZcZ2Xn/Hq/CIrwKsld561pAtXKQ3ANOi4ObNVgJFaYsdSAMVqZHpNo7n6QQTMzeIzcNdv39buw1FnliVkS2BuPpv/4+Ex8gp2zOxFOd0bSugmFd2xN49zNa3sjl0k4tmVWMuaQ0uV2E73R/U9hxzEo07Ubta8J7TGn8MB4MAquiRLq2IvXKfybe1hYBrq2g1SuqDBmzNf9rDncYT/CXhX7hOcYgo55OsDA0sGfcbcHGHsDthmPGfwnvGXshZTCMiKKImyh+WMuNY/cTAQJCVNeYj4JxrjGYHkLBTZvznBSHizQCGx4gdMzEacaeGZph/Sytuhdgtij+mTUWvrr7gsMC6qaeUp82A5VyeJrJwWyz7Vw0lZKoWgklWo/LddedA1O8PoZZ6cjPISZ/bvR+4DTZ0Dhj/1hspubOV7zqCNL4jqUSM8qR+tee6w4EgAZ9bmbCH7FhhMHJPLd/BJ7hglUEj/YazPvDjPEu5KbEFn0PjMlnWcladOUwj6bnipa9DpwnZ9cex8m2RHuSIJFrEQDzmnhcK6l2ItDv5NoaI/HaXv3pcz198BMCGHV18Sxq9+DK005Q7u0M
 pJLYdRca
 Co6dkf8mIHv2Hww5FujZkpzlc2R5bpRnCMitFSaPHFC+suNKEIbZUegmwChIVOH8mj5cocN3TSgotIc9TvXViN5307siWjULj6IDlHO8y/RGQvdDFfmtsFe21Z0RI2O7KcxBvFqlpL1sFPd9GVHzMnM993zXGcFX1tMGXQ9+amo03XuGzRw6LbL9IR9SwMTc22RNKmeWPYVkPR6oz9CsyrXm8rdG+Bp7JWpNvGD/TqVzxMah51OuH61YExHTV+zTjOy00nxBD5X6Ak3MyBSkVknLiZKKAuMXqpwibW/sJPMEsqXGVVO8Xu1+5+g4pqhdns/d6cD6ODSTz6tZph08QM4Q5A4ZwM9Tc1Cuo/dgyDzZ25yNiU2bK46l2PhPl4t0lgg9L3i5LUMSK46zO1KAp2+bQbRWiKS61ru+Q0FEWObClYklmHNhlfRjgZk9hn1m2gvpevoh55Kl+6Eu39aD29ykFkkyVRo+NZ/9XturZArj9q9cnbQUkDsxbbTjZhgi2KfV9ik/EWlyiCjZp7/YVGWes2ld4Cnvk9KtD/X+nuD22av3vYwV66mkxARiEQi3mr2EgSAGnjSg3z8yHhIWdbD+S6YzgpAObmlkdlcBrlh33UPXnukh4dnQFd6lTF73j+yAnKqenyAxpMx5HSYZnMNd27JPu36vtpne8rNyTBNLirIq0StvmqL5Cjw2tuV/8fLzVFdyQLtW1ei8KYMYuzFdGQk2xsmcWrdBkvRR0CRkLAutNUmHjO72ni9KJMA4HW9J/KnKqf9Cu3IbKYHqnbxEYr5zpg8rkcoV22AbMFksybMYjH1gAHhvaY+wRyq7Irl+38C+W5fX0U+t/pBfua9Lb1qz7TywRyOpTNSKI5p2rvLmjlZVX7WK7h40nRI09txMhX1TOwZxRn5c3de9wAu7Sy80djQi3lcw4KjCds6L7o6ccAg4wMktKSejJ5VUQvdPkbyZzi1Htug1htiCuZqG5woe/
 bGZuQvFE
 b6Lrnn6bdPOHyg1KRYQIny7ERSp+Vo9Y2tSdPNF8Yg6/PyeoEFYGxXkb8roouDZM/o0fa4T6jJKR1647gB5Qplu9usMjv2m554R/woriUb4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:24:13, Jeff Layton wrote:
> Convert ext2 i_ino format strings to use the PRIino format
> macro in preparation for the widening of i_ino via kino_t.
> 
> Also correct signed format specifiers to unsigned, since inode
> numbers are unsigned values.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

