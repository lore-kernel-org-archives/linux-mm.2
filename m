Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6ACEC144C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 14:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD7B6B0088; Tue,  3 Mar 2026 09:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAA636B0092; Tue,  3 Mar 2026 09:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F4D6B00EB; Tue,  3 Mar 2026 09:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A3A4B6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:00:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 472F2897C2
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:00:19 +0000 (UTC)
X-FDA: 84504911358.22.072FE36
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id F40B5100007
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:00:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2ANHMPvU;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772546417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEZ/VbvFt7cbfXL60uAzuqwL1Xkzmb3tbb5L5pK1U5I=;
	b=5CKgr2SMbIRciDov+n5tb+0dMp4jm9YY2XzoZFU+FZrLjjDMYTc9O3ri/f0OFY4/zUVmb4
	H/hGkAjy3t8r92B9ybtLCOvvMMaYjH9S6Sav4PxnpqgJ5NggjBKeND+STy/mwzzGdHd9n9
	VfJpphgj8fQGhIheyOdyvBzrvyIev+4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2ANHMPvU;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772546417; a=rsa-sha256;
	cv=none;
	b=DNP9cSEEth7HBiyQ7QRSyyzkZR7OFUroFu5DtZvhvrMGXs0I8sYf6GBb0YRmzPZ3JJg2ti
	6oNRiXkk7nQHNrO6E8ceFHLKcn4uLLM7NIWPzGteWZYP1agFC+F16fp2JXrO4pInHsN2xw
	yiwTHpBvkdfiy0bkAT4xoqQFEKH2TRA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oEZ/VbvFt7cbfXL60uAzuqwL1Xkzmb3tbb5L5pK1U5I=; b=2ANHMPvUqrwVZI/9ItBiSdTN6F
	l8UfE7UMSvuHVZaJWhK09McBQCC5Aai6wPynwg24bukYeaGzQiK2R02Dq4Op8tWnLUmkN7XZ4ajfM
	Le9GGPICxIH2eRNnZgTpAzJLkRC2JC1BgOkZOOC4aPxulPKDiAeWNkWlYYiPws1+XvyX4ORTgwCM5
	U8CK5pP5X5qGQXNTHXXptzr7rmd2nNzFK6HNJZiuSvla56S2Wqhn5KBNWjoA9mRrXVtgSFTmyfqZY
	Owt+6ulyfJRIOIinFxUHBEz425U0gcsijCxEc2D7tW+/wVqapcxIPHte6W40vmHC4FO8ERdb3AHRo
	q5JRoAUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxQHV-0000000FH1T-2Wa9;
	Tue, 03 Mar 2026 13:59:25 +0000
Date: Tue, 3 Mar 2026 05:59:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Theodore Tso <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
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
Message-ID: <aabpPQxCTweoTp8Z@infradead.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
 <20260303012556.GA6520@macsyma-wired.lan>
 <20260303042546.GF13868@frogsfrogsfrogs>
 <33228005140684201de2ca0c157441d3b6a06413.camel@kernel.org>
 <aabkBadGzo7IZpSU@infradead.org>
 <19e4e79a59dcfc4c61c8cf263af345d0d7026fc8.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19e4e79a59dcfc4c61c8cf263af345d0d7026fc8.camel@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F40B5100007
X-Stat-Signature: h3eqhb1ighe6xjiwx3jzp43xje5xxc5c
X-Rspam-User: 
X-HE-Tag: 1772546416-995642
X-HE-Meta: U2FsdGVkX18Qbzde2C2zxp67knRad3BNvRPeJPez97MG0I7rwNJ00T47rnsbkwAirqosEtlUTqFFVEnygM91DX2kPwbXwYPYW1caYO+udDTWVIPeEHrmn8OGHJFBrONCA/bq+Z/gJhrIDBdi45IyANgwPldGvAbE7d94df6SNWI+K415Vzc6fcosEEkB7QRsXktMzlZo+ig+H8pLkjeQRKD2fAlKGSPNuJ2NYHtv8HFzyxMHn2jQt6HgPaqOaGtrS6jE7gF1vmDNcEskTicQtRfTOISMK3e95tfr5BiFNIU+ojcP/CLMjf9VUDNtxoOg54AB+MgSd7Lsemk8GPY6Sc2i2Vke5PJ+aUWILiSizywCK2h81r1Bvt9+mYGcbq2LXtbbs97vgY+jNACcHm/2Njm8UWwuSkohyICPblqSQhQj8b6vp1ybGNaaaot8hxVCCsIx2dhZPf8e8vVhrvpu9LltTenBnYsepHWlVKmPZYQ0OedhYfwWdHlMu/9VlUMmCGdvMjgnU9AECDEDuu0boYjjbt5VUJ4qhvAqDQMeiUvMZuyNPKSasQbDFGl1teUwtmnIK6w3BgxQfoyLebRYEicAmVRuO9znsNxDdlCrQPCWix+FyJCbBysKR6p8CH5IUyMI9xB/hzSE1rashifmKb4RfAgjMDP6M8HGU788sjE7A4WGcqlGli68hBf29WfpvBWUvkYBRVCa4yXOrfLKD+hWNQVoOv0Nz2IT8cVWahwR6Lv3qcjx/QT02rHn7seU28Gx0S+WIeyh/Wsq3cvPrg9+EgowUpv3kIAuspL57LEzz1rwT90T6s6Fh5X6uXl86VrhUmRoBMkaOoeGReqJzVXekPwi1eiIV8CfcEruC6tcwkNMumqj0h70XjSGn+A5h0/TQ7XgGHRonb8fj8urxQCe0gMEw5NFfpJRqEN0fsOlcxeGLefRh9GqRqGCj7kGwHIgKTirR8HtO+TmrGM
 zElxLUNQ
 XIl0tlyFLhnJ/WjOAN7Y3/541YXRWjGIwm6zesZvFcj2fN7uAtjW6UqJboT3hCNswXgoDAueOWVT7T0Q4BusofOMDRU0Wn7tKTyWC5HTzc1JlRrcZ/2r/Nj8zyuVxsd3CAE9iEd/zdiBGZvcGiscyx3EuiPkwR2YdZwlrP8JduHPlZl3YiXpd/sc4mfJ6xfWo/3cwFxZqN3fJxDsAArtq6cVKEvrvowdJwCSN21BOovEkY/Vm9Prz3bTvAknanp59yVEC84Gg2d2ksSl/OEIP/nh792hyLrBt75MCnf4KEqXUWIM+O9cx5e8YkUcjxX5WrJbVK/btKZGq6IUAZ9D9AfBTHDdno8bkP9f71qO/RXEHhML3RbHnG6jHCENwrSDwVwEACyTEsq3aDCjJ+M3itZnQKLM8yf338g8wJyTaI5LoULV+KdHpiEEvjNz8L7Te7KAegp3HAQ6IGGDOspjtMM8T8OixrmHqtySddJvlNq/1Pyk9QCo+tHOt4pZWijNDMGLjxhACibIBA3GaM6uT21LuPE5cbvbSPqXdCFCVFAIRTb/yqtylb2pqjfn6gkAK9U/aSdCeEKIOFU5I7RWTjKwQ7Aik/l36aToNBjSsKs2P7s15qIGDoNXQk6x5LJJnpDtmVxBZhg2l3i4oF6aQ4oYSYjkOtRYW5tKx+uOPzHSBv7mFrNvBBBI9yjicSeG4ObSYfLE1Ifth/AAwO6BY9pN0fVDRb8Hck3m3Dxu1t4QHEtfva+FbRy09vWkD+c0qSZTR7xKIQODpOiuSaTuaWmNdEeYNQRAblckWvR/jIDJb8zLcE/3VR5UzjtyejDCJfeSfr4eI3tXdPToQCtHf9N37cL1UYHOQ7jdksr1/sd7sMGU0Cyrf49Bu1EIS1Hi/5MEFA8zyNUnC+ebxaFtnMCyQgnI32R3cY0wCJkD7yQDOPH+5xP6dG13pvy5fG/y919t6ODV9OO/0TczIq94E5acVA9r2
 0GHRHNuz
 beO/5T6HyBUQwbd0SgQdddL+SP4TNFAIY9tHIlXlFXfaOR9dK5Nsow5vtBSz3FTj5UXY+kVHBL1Zq6It3M9SjoVcRn2ZX/frlc8bBhiD5xfIt3TAS9koSj2LzzwklZjHLKVZNdx7Ym2yqqctw4nGHTk4z9qMZEVzXO/A9G5h2nD7Z8aGTnw2FAyYNPd72+v4YJaA3gmZxD4BYfcfPETrMIMHqFMBI8qvD6WtzGxTYEAOhG0+a0qF6R+65DZFxx2rVIUTYk0He9MMriuW0LeRRD4Msxss0W/kjWjmgWzigGUPr4G7A5EbU8sM88PDPFWCttyo7SbRgT8OlcgcbpPZCGfoLvGOqGDR+EmRVzXvd9BXIH/VfQr5Y9C9ISVuIMsT6vpSXrg6blF9hrzMluzFEZa/ghC5HQyWqNOw1081uFUoMcAL1z87amPE3HWeYj/5DR63eBeDVW9bmtLP2zbGiBdxBd7xdAOp0Z0mqRsSgEU5yNNk3GMUKJD5Bo/PmK/d3nNbh0SvPwtqMnzvApRKrACy05PFu+gyklDcNO7esBVLqz29/yXYDWjFK+PFlfDZDG3E1aZxqbBx8izLnF8cynpwG7rQQYjmnGEtOKjBqjEvpgvtKHLfFgbyV/+4yOYZtCDwyuorA7QekJp8a1G12mqOcBI9/oJpx7jlGprwhES92+GRYQvMWbmRoTMZdIM2cyHn8KupGFsclf+oj6yXqnarZs1rOrkDakdqjYyib9JPon/F8fkyyNzDz10WM7iB5u8hWhtx78iI6bjKyws0SoFY41Zg92QRYDrfl5/w1ERQMIGUkYSnguaFEWjAuz8g/xG/57YCCubUgMGw973Mt2rDUW8KLiVM24wR2vy2OzHQSpkCkGzcgBDcs2ZFha4P3QXdsfGv7xX9KcUPHD5lGgiPD2CJkRIi75J0mdH8lNhmfwA5ORlbLdjxXrZNuEK5cwePjp+5xe29GTnzQThVOOgY3GTgx
 gD/VfAvR
 Bzyivem+UVZzsR/eLbw+lOnyXwNeRjJF11B3HwSqtoHDHNTImwKeFJKZllsYsfMUQe9rwuToDVWBIQ0k7tdiHcniZhsnUPhxhdvFFlcdYHzNpEGYfYdGHEkLhny3F9/uYBMHpuvBLk5pRoV0lkCLm6bQgOLVViRv/zCvXOU1LW85CAkYnB5gegjWXuRdmX5yHcpNKfFCJDSPrnI0Ydcu7C9DaEjAbjWRZzF50ceGYBdTOyiXX5O+zz7wpLr0x+naSGn1EtRMpCGEal+mh0dLqNtiWoQ4z80uooCaindY0n7+kgNFFo5t1mjzV2yUGX/DKdtaAxsnjG1cbAJbiXaHuPyKr8puTbr4An+jM/qK7n8tpI9IwQ8bn7bQllD1eGampvexYa2lI4elf/9brPttevAzm4jcFGjAsmFs0DlzO9TTpJIYTJb1ZxKHr+AJy04L5hnCfOYrxduHwlamTWA7gBTE28+IkyFJktTOYjigr1ENM2sCDn67rtMB8P6G5nCRRkX2IPEXB41oomK1njONjDI4/tLXndmFbR93DpyjWeYNQU8vmhaera1jeTDofooAUuq369b4XZ4QTrsoyZpsWqvyTdx9BOvEWcaWVDcxoEFcWMPIF8vfzMLjau8DbtufW2oQ/Nn8UebFGl2ehyRhGlQ62r/k682H0+W1d6mcai+mJc/Or/dw0uFJhZ7F48RW+DaLAgqbt7jxuQOowiAqFQJ3Djv8sM9cr9uc+are44ZqXpWJb5G2WQKL5Md5DYjOzbU833Tw1KMceVnuiPeSpOxT5sdxSgXtyoSgRPU5FxANYs3RHHZrjM/u2KV2KQ8HbBU5VLhrdCs+uEIZaP2/sYaV9KLTNHo1fF+RMeD3EvjxZB/Ot+uHa5M89Gc1kLBTTy4LwoWhdyv/ggSLlQ2vJcFrHm4hQ52yGBLf+KhayHir60yx4IZZoZVXHnBXDnL+3+eaCxOPQohUREpEfqsuq/+pyPd5Q
 Jt4kSs1C
 owxFUL24xf6xJ3dSIvY3+OUf094qEbhPli0QIfze/orEG5nPXWI2/pru1DLUweAvCb7eAUzY4yqvFC9eZJGXcSMtP/s4ncJ2LXgz2GaAFP7ONsZ21zowpdbcit4AMGVLCtqLV+jxEtRy7qIuMSKXVe2wCe3HumyheQMnzq2LJTclcfVzJNL3jIt2YXfEmRmYujUz5O6HDEy9vOOrgtHd1ru7C9DErCoDXR+iAuf5DsdLjnsfPxjwqj8a5Bx/kgREiO+pCjlBp7sFMV5LrWP0PNOIiF6XKD2+1MG4tGP1NgJvafeVTk8SEhV0BiNUZlu/phSlY3y1Kb28OUEHIQY2oVQJDXpB8QL8BuE4qt6Q632Lvwd52QOFnpSVWin6ukm3QGr4VUeaRbqnp43LDJWm65MlHhZ6xRA9ywrafKmYTHQI1CmBxOlDIP5O6cvT4ofaoaGPi8wohRJ4qxN//cGa48KOvp+/qc7eM5+MTxMVOD6BWoWujEp+GY9LdB5kmS76lFXUJFhs49SAhucMqmlZMXwebd2cogYLBrLw30Pkxtk9TyJggIxfAHw9ZarIpy4Mem5X0BUjs3zCMm84a11uBlgopW623X5iW7nljhLg/xlZFXdEgIrC0axDzq9ac4orVGPC4qqV8x4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 08:43:15AM -0500, Jeff Layton wrote:
> On Tue, 2026-03-03 at 05:37 -0800, Christoph Hellwig wrote:
> > On Tue, Mar 03, 2026 at 05:53:39AM -0500, Jeff Layton wrote:
> > > Like I said to Ted, this is just temporary scaffolding for the change.
> > > The PRIino macro is removed in the end. Given that, perhaps you can
> > > overlook the bikeshed's color in this instance?
> > 
> > So why add it in the first place?  
> 
> Bisectability. The first version I did of this would have broken the
> ability to bisect properly across these changes. I don't love the
> "churn" here either, but this should be cleanly bisectable.

What do you need to bisect in format string changes?  Splitting
every variable type change outside of the main i_ino out - sure.
But bisecting that "change to u64 in ext4" really broke ext4 and
not "change to u64" is not very useful.  Commits should do one
well defined thing.  Adding a weird transition layer for a format
thing that just gets dropped is not one well defined thing.


