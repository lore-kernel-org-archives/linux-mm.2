Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0992EDA6B2
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 17:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECAF16B00A1; Tue,  3 Mar 2026 12:19:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E0A6B00A3; Tue,  3 Mar 2026 12:19:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF89E6B00A4; Tue,  3 Mar 2026 12:19:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC8086B00A1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:19:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48B511C1CD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 17:19:58 +0000 (UTC)
X-FDA: 84505414476.15.8BCCF23
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id D94CF1C000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 17:19:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Dwtx7drr;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772558396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tao3d1V6YUWjQGbciieZF7tZIWM4RPJQYZqAieQGxVw=;
	b=7nnBfGKBdVU/1lZkIjtVxHImfpeAYCZIY0TxYpYwLF+0l9mfsaW6/CT+k7+6/NPRPMDWsD
	xJgnmxQ3cGVUJCB/FDQw4IvvpOid4Rs728wblY5sA0ovItvRLvo/Ldq4u7PwJ4A9+H8EOp
	GnMatWzMhHi3Y8RVBkFp0CZJDXiGvqg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772558396; a=rsa-sha256;
	cv=none;
	b=a4QuTfaqhLV3vFsNsbnNBn5ro18jlxC6EGGjR/8115sZcANJigSOVSuaCppLJy8gT4of8Z
	y6nOTDpbmJ67SbmaJy9utV3vJSdobyHqt/ns1b72DjwtVefJoLEw/IIrUorhNNIRRbyrt/
	J7t2k4iTIT//MK8U035OFzdYEYTXP/Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Dwtx7drr;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Tao3d1V6YUWjQGbciieZF7tZIWM4RPJQYZqAieQGxVw=; b=Dwtx7drrLMoXnL7AZ4mDDb+Dr1
	pHpHIG972dhLGyxzFcAQx+NudbFIcurMxKVq97sQTr1lhz5PGW3hew2GVT9QoeCbheZzl/O82STLK
	vg8zfOueGsejINU32tZqwfKdGcdQbjZuH93Vwz2pTaPZIsUFcvRc5p4xprv+YZmZa41AUiirVclTo
	qxIIHl6PoQ8QMH4z3vU3H3gUflIy+NEXbLJEmvYHKdxOjT+/NqRvilsvA6ZnM/G8lcC5UPT2gBhSW
	z8jZyRc6CCB7fazc1OBmrw5oOtDAXe2WSm0mby/ncmsCi8bS24bckEVTfiMaEfIq2JCGnv34ZS2p+
	wh5wZg3A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxTOA-0000000BrGK-29fG;
	Tue, 03 Mar 2026 17:18:30 +0000
Date: Tue, 3 Mar 2026 17:18:30 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Theodore Tso <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Steve French <sfrench@samba.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	David Sterba <dsterba@suse.com>,
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
	Amir Goldstein <amir73il@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Dave Kleikamp <shaggy@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>,
	Joerg Reuter <jreuter@yaina.de>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	David Ahern <dsahern@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
	v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
	autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
	codalist@telemann.coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-hams@vger.kernel.org, linux-x25@vger.kernel.org,
	audit@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-can@vger.kernel.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH v2 001/110] vfs: introduce kino_t typedef and PRIino
 format macro
Message-ID: <aacX5metux-C_xBw@casper.infradead.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
 <20260303012556.GA6520@macsyma-wired.lan>
 <20260303042546.GF13868@frogsfrogsfrogs>
 <33228005140684201de2ca0c157441d3b6a06413.camel@kernel.org>
 <aabkBadGzo7IZpSU@infradead.org>
 <19e4e79a59dcfc4c61c8cf263af345d0d7026fc8.camel@kernel.org>
 <aabpPQxCTweoTp8Z@infradead.org>
 <1310fc5c09cce52ec00344b936275fe584c88dea.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310fc5c09cce52ec00344b936275fe584c88dea.camel@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D94CF1C000B
X-Stat-Signature: koqknognh56hezkja1g5befaqtpajn1g
X-Rspam-User: 
X-HE-Tag: 1772558395-774372
X-HE-Meta: U2FsdGVkX18lg3IgjHFP/dTI0NkmWbnZLeFCGi6kB3FkDMBmfdsdEXWWk43lDIyV/+S/DD/FiCaNR/xqXx2DTluuTkD8HhIvMxjRj5DsQf9MM5XtduzZ/IH+ISvo9D1bfASEnDhSETwQMTArgBb7QBPQ0l7B3fxffu3EYGRpJDVwGfOWSlmNUJDDdPjRQ/xpMaTVHorf88qRGhqRkar8/xOgunnGVP6AiBz8Bd4yDmBwn3BNYL7SBAa0xZRKfj1yX2xFjaDcrGxp8OaZLRStYUpvkIgQWJoizdfwx9ky/OwYQyMFQyHLWe7rdyPDib6nRtJrYZ9pA5Ii7px9XVHIOpsJzeN+ZeL9QwiKIm5m8PGpA/Dk5uZ8yipDXcPfmObblVA6l8v3nak9bIKIkpyLoGtS3bhRN8C5rhbA9Lucg8lfiLooOx+mS6Nf0+c4HLjmacmZoZupxHUFOHS88vm/OGhl5RU60lDXlZ94Tq3DfWAZIbxKQI+mwMmrSg/XbYFeKPbI+dUi0CMQGMwMJIpOFhK+4z3kSQvkDOatFc0cvw3M6mDN7Q0DyrCXHBg109J9uQxkK5rIwEWKM3qP6o8P0GNTC1tPS5JnABkAXWd6U6ltBQSpda7pEsZ61Rw06//eUbIjqS40FTcBzVc/fdb72iy7loluw8oiTaqJEkxu1G0ODmcZ+AAGh7QH6hGGX1nz7GQbeROFbHGEVdfQzOx5wln86rn1uVilEgKlexpT+WsHGt7X5ki4/qJBeXK6jrlf/oQUP7mlWIGO5JnO/I/TUao6dURBYCDyPx0Q69FJZVz8Ad286ygq+nPa/jEHxOej8BPuVDnIvjYU4L2hoegsnJMY2f8J20V6PCMY4yONkuHLDSlutcMfsliWNTqC1LA8/actD6XolC77cc9fLRww8YJOdk/kFH0dO4Dn8FndUHdLijJRM3ZUablKG2+JNQ18q8JskeyZbFVsi553YFr
 DhejGV0S
 qQBOa+DKS4E0kmzBU+xxGSRyazp6ooFz3m4mjbBg+EzJaSfqV5eYKOkqznNR2itxB/fAjK43GE2PdMYXL/1y3t2gwkEkOQi9zcYR2V69Vgfe7nX+xNq3RBD6gdQ9GOZvsCL1XBTlTxhZcU498V10eb9qBT+7IA6HMG00YUihN8hRNX7bNLYeR+eOw9YQkXoldylCumTjTl5agZymGr9SbIHUqGtpP/cv7GY5YWA/Kf5wTQDVCyWTXGXnoaYkEc1WOqO2tjVmPJMmC8s+hgG4bXMOnbWuFc3LWcY4IdkARp303jhwZAntrHLP49C+PPUC3ComoGwc/TM7VtTZSDfPQa3JNdm1HG77xyQgT80KPnE0vMsWUZbYaHINRjeO2+3hwSjD8bQsz7yc7cQo9tMm8HHq51P7YgUwgwCVq1jvvqRyQ7U7xiMAPDaVPy4xhPRV7t07Wb4W4npzKi45q9EslsORsFVYG/zO1td3Uvll9HfJY+qEHvpbWdaflq2V9nWsE4ePuankoftAwzlZ8zo+/275Mm3N4gOmnKEURgy7vLgSn/VYUQDgi8jZ6JEsCcnd/aoyMcNi8e1Np2gFn0bfoRRqUXZhF1vEI818sVG8kHdjPnExmSO9r8Fm3rKh/lXopUB4nAk6GbrrjYshBVrE8VTtuoaOH16SL8I0LYqEi1nqz+wdE1Ph51KYxNbKsEXzG249OBgr7MdecND0DRwSTC6bzIyu9PtrJKPS5GRPfptl9YVinpRGvQ0SREJV6CIbnot+33qIvd/Ne04F2JZxm2K9iotk6MQyIpjmcnCU/VcsZqZh8fB91MLm3/HYo+KrcHXswXcQ/RDuX8rpSRsGLqAwPNWSXpJKakZ2qrFj3wdJ7zInLEzc+vAnIMMZAL5o6OFzRfkhz3TJEQb6ae3o6Atm2H+ZtjlW7QHzkSNwp5AmZpWdht6tZg7up6njpTWsMTJXDuvR/ULP+8eR6sNSFYyHnRt7K
 Z8MPSBx6
 SA/IxxbqoutAsVumVJIXpRFpdefC54EAH+AO0KBZ90BqMByxWp6TGu6Y2D6Gr8N/ZjxfKGBiIARGZf60S2VbUu8j2TcghmTvVPRtUkmSeap2APvyso3jxzyb1Y025Xql9PV+mGl0jJwz3llzhkPRYCqzfaYsAaiozs1ZcTd4Y0XhSAbpdbBNo9fExKmZALHJoAyaE66CaFDf6bVGtEhd5JpDWE9NCFLoxIrHjb4ce7QJ2O5dyKWhJJ7sH5aL3Q+3k5sxQNIkf8vfSewfXKBVDb1k3SA9qOlUc3GfVr0ONhV21drGeLiI8YgIxFMsl6ehFf7qOnf9WC7UNmciP64Xo2C2RX/4INELiOimEnzcyFcMwYUXLQ/jo0JgQPG9xdLoGZEtZHsq5yzynLkHVGdZDsQ+pNRun4QfPYjgO8wdWEz1/Sc0pa/rfO7C53AprCrirrI+n7nZC+SIgcQbNw/AKz1dZvWwFkvn8FyFryEHlse8Ag9XsOhpZZg2q8Bz9qXhGUo9lrX8Z20lIfOb4D45pZRs7DQhPph5JQzE9i9RMQdPh9rLHdrcXuIcamlx7ZlSDWO/IDghymc5/QEQaiEAmodWFjCcyFE006yFdDetyFAfCZDqzu/LJxOnD4/Wki8k6DfENE+VzQG2UMqie11YRJoFYXE5980DS5hvMH77JetJfdT7C3RQUarpz7u1UoDKSUGBoRCXtVWmsK7E4XN/MOfGTgjt3eAJef8mtaF7s+cBs9kPrD2ihbMGQh1yjt+8RhOtQLZRZyqxcArWjZmWdfxF9zptqDgv5yZgUDdoeFNPevUjMvOngdqUl8znIzC8KP2fpeAORrZ9TrlDyPz+73Qy6h04TJN7Q6bZMvaStYttRxg5nSVTQcB5WE2J2aP8AOJRyeMKI+L2BD6BB3YeLEyBMV/9Zvgaz5g9EcVvBcAI/LgS6Ec6Fk6jHwjYR3uInC2LOgAcB2a+qGbxsMQPZP8IXQFW7
 uDfo3TIu
 6vvQFujU928ScqaH/FaxBpnUJZVt7desYrGI/ks7axRW0fvflqE7DnQBOtKlMUriFWO1j+S2bZYwGg7pN0lCf2jMU7NPObfdORXPuOMn20Ox+qw0OM0ynhMR0IVdBILcjKVfo7X/3rPrRwa0mCPZI93S9Gf53RSkOggtGLKewg/PNbPbWUGpT5+D4dbA2M/ay+jKlq5tgFdwPnwuqi8oqMO9ERv4tqcBVnXeQZl43zbivpekIvIA6Mxi83Sx6li2AXGOewXsMIiVI3JDB9RqaRankvoQqqepm0p5JHRtM6ux/uxJe62SHTa56b0Qt7lOgiaVYQYYN3k6CVl9mj0As6uY9gbVo5D4ABVZtIvJGbZKZluBeAuLYEh2YvWYFnFuee0fz6pFH0EXF3T1Hva4goEDvoKP9Sbaq14X/+/Z/kwlKvUUHwKso1saASUmQSnze2il4b0NB3WGGxFwvLUYVRBRu0aeFbOzTBGk39mLmWJWbT6kfI64JZaSpyRiW80TPuVpeFAGhzka/8Cp8w6BMXXTfNwAfKbOrK29EQ6K4zdokA5fQtg6A3477wdEYd2sVyCsKzX9bk2WNoasG69K6N1Di+uA9L+T/u6EJr9y65ijiL3LuKq1W1wdBzmfS6+ml5dv2XTntUP7FEASoxI9F0ZdZk+dj/tST/fKe11ByPnCQ0PHlOON6GWsd15wr6a44CzA+R/QOMcMAjL80ODYpM+FoK1AXOVgDnTk59dvwrS6qqczdMavUNx4RsojtpkaNkCMSuYeZHBgD0Hs50GKncjg7eb2yxTlZYd0h2dnWUgbEzmrY8aolHAktSfktYgQsqcNMLPDToDpJmsUaXiOYamEsb6dzXOnk47Meh6M+nlZMunc0y2FgrJbNN2z7Ywuqa7xTTCwMgttsFb//2RfDbSlafstGok0X22mZ7ZkIQewYiafk6pr5nw2cXU8iaHkkNsiUr6wEN1pPm+iDYbFKNhFOsrk+
 UARx/36E
 p9UWbROZBxpfGHQdYn086VzGp30veec35NBvPTp1w1a/vRlSZg87wH85REZxHJc2YqflR8svJTqcFhgaVSewpmUDSZtyFLFg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 09:19:42AM -0500, Jeff Layton wrote:
> There are really only three options here:
> 
> 1/ Do (almost) all of the changes in one giant patch
> 
> 2/ Accept that the build may break during the interim stages
> 
> 3/ This series: using a typedef and macro to work around the breakage
> until the type can be changed, at the expense of some extra churn in
> the codebase

4/ Don't do anything, drop the patch series (I'm not in favour of this,
but it is an option)

5/ Do the conversion(s) _once_ per filesystem.  Here's one way to do
it:

-	unsigned long           i_ino;
+	union {
+		u64 i_ino64;
+		struct {
+#if defined(CONFIG_64BIT)
+			unsigned long i_ino;
+#elif defined(CONFIG_CPU_BIG_ENDIAN)
+			unsigned long i_ino;
+			unsigned long i_ino_pad;
+#else
+			unsigned long i_ino_pad;
+			unsigned long i_ino;
+#endif
+		};
+	};

[...]
#define i_ino(inode)	(inode)->i_ino64

So that's patch one.  All plain references to i_ino access the lower
bits of i_ino64, so everything will continue to work as it does today.

Once you've got the VFS core in shape, you can convert filesystems one
at a time to use i_ino(inode).  Once you're done you can delete the
scaffolding from the core and go back to calling i_ino64 just i_ino.
You could delete the i_ino() uses from filesystems at that point, but
why bother?

I'm sure there are other ways to do it, this is just the one I came up
with.  But for the love of god stop spamming hundreds of people on the
cc of this patchset.  In fact, take me off for next time -- I get each
one of these fucking patches four times.

