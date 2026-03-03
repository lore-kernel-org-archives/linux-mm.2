Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 929A4EC144C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 13:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6866B01AE; Tue,  3 Mar 2026 08:38:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50A76B01B3; Tue,  3 Mar 2026 08:38:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5B86B01F0; Tue,  3 Mar 2026 08:38:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B084C6B01AE
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:38:09 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60C591401C6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:38:09 +0000 (UTC)
X-FDA: 84504855498.20.4885BDE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id B6EA54000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:38:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="kr8/nkhx";
	spf=none (imf01.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772545087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0i9fNykMCPIYLtg51f50XyVAFwwkJeuAbf20SWgL8IA=;
	b=wYKkbdiy9KsbRSFdenlbs27KYjcBZKhbEdb9jE/Of/YSJBZ7197N9BZkVjuaaV5As6T9pq
	qlgdBqYla93XKzusCnVZXM1EFffzV/F4aVxLzd7c7jEKq8sQxMCzax8JnV/gMJ5BH1TU7A
	ORtkgG2jpn4uTT3YGKE7g0nzzPgstcM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772545087; a=rsa-sha256;
	cv=none;
	b=eiiJJodoroKKFp/rB80s79pw1J/mABsqNGZ9UVnYUX8ZrzBEf1hUKlMDQkE3ApypgDczgZ
	WR0o0ISe5HJ3PcePPRdmYmP58G6Py7MnhFgCarCQldYvgUCDR3HLpgFi/MN/sJFiiYLxPD
	YUk73YWJTpXBsH+1K4umV3/yShlkWyY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="kr8/nkhx";
	spf=none (imf01.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0i9fNykMCPIYLtg51f50XyVAFwwkJeuAbf20SWgL8IA=; b=kr8/nkhxdG+BacNcKTfIO4XZUB
	i7xk70hVnj0kN38gmr0dlJaLre+m1Y8Keo9ymYXIoBcHww1Y+hPC00/UHvb56kw8vUZqxa+/jNahq
	lo1JvQxucy9KP5YYl3BJvCvBlMRiI1+7TOS9UDCexOCQT4oO0dZF73KEk82auTfbqI7G3klcW7KCl
	2+/df6PJTgQ4/8fk1VMkhG3bXi2ZmyKmmwEvzbL37VowoKQNKhueKgAd+dHU0zICZvWhtvA8HARA1
	eICbHHpV2VmmTUNzGuvTIFriiMF2hmXCPYb4u7czBRvmuy0jRezd2uDvibuCdhD4GO+QcG9vVwW4n
	DD/PLaWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxPvy-0000000FEmU-04pf;
	Tue, 03 Mar 2026 13:37:10 +0000
Date: Tue, 3 Mar 2026 05:37:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Theodore Tso <tytso@mit.edu>,
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
	Christoph Hellwig <hch@infradead.org>,
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
Message-ID: <aabkBadGzo7IZpSU@infradead.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
 <20260303012556.GA6520@macsyma-wired.lan>
 <20260303042546.GF13868@frogsfrogsfrogs>
 <33228005140684201de2ca0c157441d3b6a06413.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33228005140684201de2ca0c157441d3b6a06413.camel@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B6EA54000A
X-Stat-Signature: d56dptuaba1zd13z754dq45dfhis8quo
X-Rspam-User: 
X-HE-Tag: 1772545087-351830
X-HE-Meta: U2FsdGVkX1+V978G14ZfmWjaCjZcm/45MarHj0ImipDtYiOovjjjPPZTV3hnmSoGPtnxm9EUOIyHAloihYoERZ3rWNsvMWekYs/RMooldvl1uK9x+rCrkxCXlXMbOjqCqR2vR/PmeQWu1hR1kvxANOI5aJwANL+uwdiXkXLNsiXDPGvsBDWWIaCmIggqVUuHSi9xMFvTa597d4WIMTQvjyveC7w3qQbkiqWjYkeMxH7pJbIDsxafjAuJFhTcLQD8gnCmU28nGc5z1KzYm2SNvXGbNiQmQHYOIck5xe5Y4lOknemTDlW5eQbUVWVOoWPUnDtb750gyWRc7oNaUdZnnxDM0LW17/JQgF7BEYtWECQo26oeLotigO7XTfm+CqG+C+n07S/2zoXJkh8CLS925qL5xXqBhGTbrCJ8xRshk4v70fYxstun5nFUs2aDbhmbLsargCgCeadSn0AnHiBUbZHg+GC0o7ZxcmQN2k+yzfQhv4JMPTOCd37L4SS/8A/8DuUP0HO09XB5/D3hNnyrbVVEzUxPPoxBR1NwXC+mGcjFbYs95M4CZd/488Kukmcr9PJU7GGGQCOmjRETN1SK+ydYDG0IcSYBv2Wimh3KNTA0AWU+Eg6UyOIJmyJ/FDjMFfwq7Z9HRX6PR/vOqT43hHKaKUp0pHU3GrRG9+m7g+KZJ3yucmDVmFCNh0ERCzO2SNxm2JkMHXxhHVKIIkZInp9EK2QmPtnezE3+Aa7T+PUtR42v0Zgn1D9+gDAvwCe5GLlzP/HWOAo6a+6Ei5oYIQpfNzmYtuq7P5tMYKRJIIkSTVmBoRoFg1tzeUnqJ89z3qJXHhGfspFp16mdEC5zoqougkjtxMOmspCQ4oX8K/uQc6aUA6uHzU3nQYm6MocQmkkrliQQnaikHCUpqGuXJxtk1jUc0Qjod9QGS3/uBEibAGv0teOY7zXmX38xJjaOr+FAYLmwCUALUWS9Hhp
 PgoeUDQE
 2pQhkSBQAa6HmrYARQhPvpnh3od9/DkgKsbClyEHY7VvepEQC+3+eKrUdTEv5zIDUBXhSYq+YaSroJZ7qs/y8KG5rdSEpVeU7Hnv94RBXkc6LQLOa1+lnVTrBLSRcbowR7Sh7XkVLokN3CcLqo+ubcLWdaqvUZydE9LqGmfBfPl+ODsXMdWJz80vm453HJA1paTM8XmuHF2gjH2A3cDS4UIP6rfOxYvSmobWJB5Cs0bzO0twA1roYVn4as7KYqtkrncXLNAjOwbtE8U0nwttjntKLpdj+5/zRVzqZJAXoLZApX6MRtmSyyWfqIhIM0ZiI+3JYyChBb1jkNMDDWC3drQetMYbV1h4URpLYVN8zxAgvWyr7WRWdIpE28maloXLdw790xsUIBV4c0MHDevxknShhhz1QnBi9qJjTlMabzQlE/O/3gmzPemIGLLIkOxGH1RLAptVVXFbw+NzYjW8zBBqywpr/JUvt0Ls2MacxUhE5w1Nu53t/fLf7+iq5Cn3UI67AR2sMRxOhTFMHaFdH/BMPw/8d4B5WCb5suHZOGuTAf0XCbqN9YXM4aMaiGZ5VkScCq0Gr/jF6KYYKV0nislWSMOmMYBw8k8dAuQTqUa0gaCKYhHl3FcblYPlD8bLCCNpBM2I7xFG1/kIT2SgQlUZZ0sWYdVZYKCZMCPFXM6GQmqEQYjXdN86EuJOl169cmn1HphGor92VNy7Ug1s8TIup/nwtlL6Oej1K2SbW9FpPR8/NH1QYgdwHJZGECygQ6ENfggq+yD7d1rhV5V04CoR4leFinSfbBSBwB6MDB8H1sd5+JcKI/NU6YMhc1pp219LzdVq7FHkp24sIWhr+NYH4wgbquG/RSfVVV0VfeEk/2G8zCWf6eP9hybuU4mMv76SbhA0QuzclVoAeyqwSeeu138y7og2/XII7sicDghDPYzbCQyVxZKDNEoC4KlHKX5duw2/5oBT69XknEBMeBFZHgD3Q
 xDjkwCJ6
 vnxUyUHhgG02EDTq1alsd5pK7mJbGclFDiPxQyZVPlngH+nv8ukvr29Lqj8PW69h/xU1T7DGn77zbMwW6A6xFuR5SKtZi6CHfM4eiuRfByXSm4K9Tg/Von2OS4M2X3WHsGMJLLavID2avfgoYi/y/dJAaqyHWGkyNmkSR30WQkUnrAFRuHz7GuYM8abHyVu3zoniAqSNM+9pLinFatSXUgzpZGElLro2HGIUOrRSvZKH6a03+7CXWsHz6Y/2zJA8CCASSOKRGV7NvNYCE0ZABrOlNY/YJIz0ED3pEF2KfPgtd77o+EIUFQpOPktfC8lekG8RfPoLQgNFFXGRVGJZ+KYmuRseKWaM4NCvWHxBGJSFMGRrE7fzsPPN3/LOSs4HywHa4N9w3PGRYIX/AEr4xwFpo9L8KRfDKwdGI0AWtOV21RZ52jNWvY6WHcaUEkimPnv010x+MQUqcgpOGOE8qH8P1+YaNDmxVRT3985ZbOlofB/eWioZKyWhGRUxj7B9HGzk9vgjcbk2+5L5fM0bfdpHLz97qWs7ikqhreejjwVg1o5+aUW1YDagy3129HQkgXUjf1h5/z9EbPW6g9ry2ynldAXuUUNqXvRdGlKkJj7ZUXAMWmgvGoMhl2J++W5/T/kpoNJerZ7kL8GjLKKX70K9DWUx3aZAVzcodcLUpWEkD4RFoRvj6IOQ8zhPzPA0nK68LB3JTP337aIZAJD3iesaJ9RoWT0s74aXdBfHxEYsXVNnFvngp0mMh5X/nx65Fe4mR56O3ROioIywSs0rOYUalycI+ahFqXZ5GOfuaVUXGlTi/UlBm5Z4jGaoyya7iLp4MaxxApQ6DXiwpS9Waz2Ps66hgaNYJuGsYGlQ/vmQXfgMlHQtWJYXUAR1UlnEyW/7rnnaOsJE3I8pr1hWog9wwrGFyXJyowD9SexmDebyZ6FMakV4G/ZA9uSycTIuMuucsHBvYUrQ9RjfQct6gGgOzgxWh
 cGnbAYR7
 WMraH6CmZAxvLZpOozZo2XZ03GoXDiYdP1LsTtgRmWCz8JVwgr9WF1d0fkeC11xhcuxR1l5jukxWue8taSrghq/JNTXpvj0zwAw+rAQ4GvCzCK+ATdhaC11Nt3LFBweXnhzwQDF0hWadmLG2vNOJISXohDxdGwm2eC7KIPs8+mB8A6ozinYuy+WXyAjNpI9I5qv2e8LWW9gmTt8gDHb4TEkublbyRlVoTyW1Gqxf3EpCsjhfs/8XAmEitoZrpAjX5L5H66CG0QEe7uwnizCw/YqPrdLPXiA7n2HDuWNH4EbM+ZRdDRH0PHAvz3JPJkpzDNpKH45h7mdAUhWZ0yogT5mLUaRbyV4v5D6njcO9K1w7I4km2ykGbDDoOZ/ySjoeTubJLGgY6EL8LSkbo/aa6XQ48p1Qp0hhpj9SnwwddVe2SbGjQZINaqrkYNyk+uH8Xlv0idl5UXynY5TrK7rk98H2ypRYCkOp908V885uvAvbBIWlZOc+60zHtqInUVUX6AFqg1uIFWmHZTf6bObz9AXgivqe6j69JvJLkVv8YrrRJ20hm8fPAy94guBoBv4MLmdd0NC5/t9KjVKrPZm/01PkaDKA7h/tvfqMQoY8DCiNDYorhVAFv/55KCtS4BajHhiIb1YmMMF7VLc4O/E187cmdAmftVEBxg+LW8JGPOObTKZ1jLpIzdbKWIUbCix9nTSrga+Mmv2cZX+kYip1H8G8DeOJi7AFT9DhleMMjP3CI/aDM/69dqSlbNNS5ZkjCjVfxWanXqDFZh10jAb3/BJfIExpFwwtr9IrWJYLb7POqLKRJdkrLtdGXhhY0DAndlAhWISD167GLaGGuewyB6MEnxqdxwp4c7gWpih1jHf9pYr1j35U6Nvs8lJVoAytjo4ZV3Dfrex/iP+b20GJCmhmYLcj0HZMBYI5WNdTw0FYhOIiikh3U3wMPwLvSgQs8KrukEYmRBi+dK7WnK58vfs5WBiXp
 FDHhrWUl
 DeG7nJdC7ZMcAPf0x1FZ2MNi6H3hwC+OlaK0xh3mjDRoErn7nPSJZZKY2kI31MonKUAqhUT5HujoLx8yRTH/oUnCvbfEuTIi+Te0xlAxGyB73USo3xhGeh/yx8dJWyVnPF2RP80tZBjSrPM9InFBppEX5SaOE5Pr3Au61LC/Phd8yYziZnl6TZ0uViHmcYMJ6Y9qPgoIJbmlogngQlkIZ1OvuL5lxMjtfglxizMU66LJj4sZOeqq/jMlWBLp7YB44sAUwvE4v52ZrV9xhrw0jQ5MPb1O+c1tL7AKaIzOi6VybphoMOdEPKTiyGOYtF20MFH7P0BfocI20b5dQIq2xnV9nFY88FEobWet1j7rVgy//G60iTfYTUPRalqU5yvZgcR3yeUl6Jp1385v6GmfDVJFY1QFXptvKPIvh8feXMdUkglukepn8NkO6uTYOzowB6EXmDPdss2HMjEMr7m6VNxXCj2zvUY3VjjurwR/6U0yYBlq/z1pTArRaeY6J9XxNAvGNeUaCPrAA7BxxDdw2+tuQgEJOCZ5duAARfGBXoAtgzXIOxY3SzcwG1g/hUq+at0xLpCUWGXZkHo51uJE0UqH7CxMae1tqlQ7KTHfCaACsCRwPEgo7aTaL/btD7W4aQH/oMnE+wyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 05:53:39AM -0500, Jeff Layton wrote:
> Like I said to Ted, this is just temporary scaffolding for the change.
> The PRIino macro is removed in the end. Given that, perhaps you can
> overlook the bikeshed's color in this instance?

So why add it in the first place?  


