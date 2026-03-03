Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B492EC145E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 14:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5AE6B00C9; Tue,  3 Mar 2026 09:31:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D4B6B00DB; Tue,  3 Mar 2026 09:31:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334896B00DC; Tue,  3 Mar 2026 09:31:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1F36B00C9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:31:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB7008937C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:31:37 +0000 (UTC)
X-FDA: 84504990234.21.7CC9FD0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id A87C61C000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:31:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Lcd6Fno+;
	spf=none (imf20.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772548296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVGHEap2/y4lqrOlTw4I1PUuJRk8gJ1LY6chx54er5w=;
	b=SjyB2EZILCjlBS7LbCnKRWCj6O3mEzZFLDlDSnYrcLloZ3itjLh9kVzZVzy8JJ1L9wG7NY
	NR+ER3ZADdMgrRgVCMa42Pd7lYqxPSH34UMTgPSwGMmR3DnBFeHfT1kyfXOBQZeBgX5Gsr
	IKjp9ouoRlQS10sigHPT3WtQ9a/5d/U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Lcd6Fno+;
	spf=none (imf20.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772548296; a=rsa-sha256;
	cv=none;
	b=dz8O2qYJxkESSRBQ3bRKyuM+HbWM58U8hpk3HL9XNcIb3Q9XBg0788MkCy0shJlSTMtAfe
	VBkrp0Jl7xOLY/Z0y2YHAqzc5fH0WYE7M/Ojm2TSCniEouLsPUMVZE9wAlyKAm9eE5hRl0
	RqFov0/BBmlBX0snTnZj40R3n9Dis8Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FVGHEap2/y4lqrOlTw4I1PUuJRk8gJ1LY6chx54er5w=; b=Lcd6Fno+d5UFOYRjzgSXS/STDW
	OnOCNUozkxsQY4gAaLcG3UD8bgmPzX/hQhnp+XRh93wE//HqWrx6I2tY3mKjuf2IaREQRwDMg25PG
	3rHjoEyH4eWTjWo2to2N4q8xFIulCCjw+wnruiylvrdWjofeIWtF3V0P9I2qdnWzQ6TL3ZQvvH61Z
	rPO9WUDLhEIV5cHVRy7B8ebSHdIsWTUbMNRXqGGAPCL3AhrpvrHgan/jOnhq5S2sES5qYdDusKr5g
	aSpySF1dCrXtiFPjIQCZRSsvuPR6BM2kGpXN99BQqvFof3+8ottSE9BRZ+7Avp/LETtYrw8IHT+HY
	hmdbkK9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxQlS-0000000FKdJ-46fW;
	Tue, 03 Mar 2026 14:30:23 +0000
Date: Tue, 3 Mar 2026 06:30:22 -0800
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
Message-ID: <aabwflLfe2HcGv7X@infradead.org>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: qo7ox8ee6gxf4rd887e9d6n5aiqgx3yh
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: A87C61C000D
X-HE-Tag: 1772548295-537445
X-HE-Meta: U2FsdGVkX19VWKyY8gmRTypRCqmKHvidiMtyJMlGxsX6QkR+iLYJralfzGRD3HejEd+4HZVtCVymkCznWMvpnQDAhzg/I92fpMyT8aA1pMoe6VsB3DOECa3jMBmp3VT6Tni1Z3Udm0iJzdSpaPV/uz59gXAwVz3fyRjcEC/nVAyUrmfQIBBqc+FlpTsHyQYwwTQTUG2l8T6yk9HU4OHl5dzQrPD82t3CSy1ulHNdsCfUly7bRxxNJaEztMx7achUN7RAQ/hG/tKv9m7JLkul2f3MBoNqQlRDpa7BpU+FaHeEKJTN1Y5MXvNB4eAnFZpdsXRh3kpdUIsSPgJgewqBEeSbBVnX3BUr60+hFLVDnVVRpLTQT8/yX6VQ5VXdxJUEhqoQqdpAe9uWzCCjF6orJfoy9VA8ujIwF/uyfYON6NujUrJsiDWb1pxP7ajegTSS2heXpcyBVTJ7zv1dwT/sy1R9+9Ip2DmTgSeRGzJHhTvRUd3SpER/EQ2/S+o2lovgMrtEpLUyPRnzXpxqKuWpJ9QN4GMM0osJkJx640BZh/tH3Sj1JBdSgObBYzW76hMUbWKy7CAgPfiVg+mMFnUsTrw38t3mf/Wh35HvxKvqxdwQU/TQqznAAA5LR97jYDD83RRb5pAfmeYy0J4I4N+mFWa3NM6CKIJTksl1dHH/8bfLGRyQX0lgzp9jFbghoG4CPn4dE70l1a4JYQd9pS1f5fF0IY+tPASnoY9YY/zagWCeCIacK9EAwiKssic6pQCcmBBrutvgyAMASBS70X1IF606IDSRT1RYorr8ZrV+JHo9bAT1ZhqRQ2Sx6E4oAWchg+zxDmEV3QKwoE8vR47Sf/rc6GdjPkSEoqrgTJuR3IAGIHSpXrZPBfCdFj/EZpcnFcQfCA1vbZsjZ6gnxah4S6AJO88wRNb7QH+oOyCeGPdD76ACq/c8fcgaf845tECcjMTNbMV35mv7QtLAHpC
 5P2LwPT8
 zVb/RNefHejX0ZHqNHmgjTr9sOdbJwxf5/VbXJ4mp2s8sa5mJRRvGF8oPwU+ZvC03UpvMqatbwXdWnVqbtH8BiHlClntd36yaByZKFG8OEneNMMt3rY+1Ncpk5ElyRSF0G0giwMZ2Q2OdLsoqhtye/5FKQU+svvIVPdgZXr40E/3HObYljh64G16JMVjpwXgfbb6Vnls8EmKzCPpHGlTR5HAWINbe4mnRyNxN0coBL/tTnpgrLr4QoBrsEAxzgGnYqzdToap/OMjDZSQkTAlQzslJ5QdawOnlExno2ciCrswxuKpkeS8l91WfEBMHQ8sjfwZq1orHqyt1GDNcJogvsGejKUQqZLat3paxNbNZ1nuhyGSRbt/dMc5kE2HpMWbVyfMsFrAg36GfQD0poHroMx1zmkIe7M7kzr9DlGYS2E3xsbhVF7gUCxXRatj0xv+zMDAaiyCixQikG+vxNv+Az3d8q53GH3WnGhdcQ/9mr/QQOyw8D2DeHUoIm0MrNdouE4PzB4EXQLuzSZlAAKpfujuXDLfvJFzxNNIjrfOX+A5QVnDUhkJxIBb/gMDZOl+i8QjmcX2rFiU9GkyaN3NolD0mt0kzYoXzzeH+APZKswDr67TdCaHx3SCaykNsbYRjrpPWSG/P8yZP24Lf65ip6yTKPANml7Hy1SOl9BBw5sKFgCiURrWXbT+WxUMIimmg/sierBZZAyvzCJZq7YHfrbm/27Mc8hRP19cDdYgPr4uaKExnqqTuGZIARoq3h5mnVWMTvSSpuFQRRRzPYwhHTALWR23ribkLPB5gW9jTF5OM80O0mV392O89whh02kfWV942QkJF6Dw1GAFvDMgoKv95LmmuqbKhR4SZjF1l5O84IB7kUFy9GyOYmUlFKg5hhdpvU0CymqWvNBrt57GnkfRFv5WJ0wc/hVgtwikSVkfPEjGcqueqN9DWEuRILNojQwkjimwlsg6OHJWTos89mvfBUfkG
 +t0o9VO2
 V1LTd3uJRwtCypmslBonicj3ronQCROPJH+FzzoVSu6TSoLnta68ruShuBpL1LdD0EhM4zr9U5gnmAGdKDj1/r8Gueksv7Rh6UAXNrZ9GVXfn+BysvQQNxtDyZVR30YXtA8wLkwi56cHmDdu5+y1s6HhaXNrceYEhzLQg1uthLtJFaBYzB/bMOBFHUZEVDdjwiK7D7INCI0N9Snf4axHIpj2dmG7NRyGawXQpk7BwYXUVyBXkgA56Rp+a9O6/yDqcKdUWxvkFffBK2jITjofLfHbSlRxm2wHIwCGUpIVryAjx7GSOtH+raA0DBOT2PcFHbeF4idgnV1uCwhY7fI7Wo+XBspUCIouU+877O3xgQXEpw8QlJsUJ6ir2/v1uY46rAub5hlYNGlMZkh6nGZD/uLG+KpqHn0mV3RXxd0fvlbRCZ9fEGPzdKTRup3XWnHcH6z0we22KdR4B5Xc2AnTeOm5fjvxMmM1MWJ1FDCAjdSL5F85Hhd/4iJP1EUs9Y2kXkvqFsIEFJmMWmFW/dcnhDza/HDYwCbitdH+2UlkRdW3lh2T5Ro0RwwODaIGyjFpEfPD6Hg71yMrbCFQNzbzRe0AGhxsZAzZm34x94FJ4LEE3IXAnyFYtf1sHLwNmmQ4U34ysk4JWTNpg82sU6cpgA7Xtxmu0cPiZ7A3n5HgXBLsr2MGMI82yVgwWXdVEcNZqa0cw5VbCE9q1/7V6fM6flDh4VOZivv2OXvZD0t94lJCAEFxUs4bMxzEq1/lnHL+0kEaNC24HGYZW9o15CA8JOHl7ZLWfF9Vfsmfa91KI5QS5qUHfnuF+cpoFZ1xA5Ls3rueFxmeGB+m2VfwDE5fkbmDDJEOeggQlm7TBWy+InaWj1CrQriPlspm1Cg/UYx+cxiVW2XTsfffUVdBfND243LgNDJRGdbKldBWJK3ZYzaKcXHLfY2jqPOf7XaG+SrJclyOFC6rruM56rsnDS8E2RFYnvzKj
 Dz50/jsZ
 zYh7QGWnoSnyyvLfxWZL7KTVeOMkFqQe2565uab5cSLjAf8Ck792jvl12GCXrni5UuOEDh8xkQ1UiJYpW3U0edqrH8sbYhGOVp8yixutMEkHdgbvcz0IcZnWbs75SEI7A6Aj/VCiR7/HKYEsuKkXFzq8yQTVktNSAecTXwWCrgczJZDCtNRAxJzr1git3OaBPCxbe0xdfUGkcJgWvOKpyVa0/2ruWGEWD7Leyup8jqhTbCj1mrp2yiblGCS+2a5GzZ5zUKVFZT1oQdbVMVWPrwClbmuFWZHBSn2n50CzZfBYZ2V0QjeFGQvoQlIf/pGoXPe0aSCiwF2c8f/epx7Fq5QtseMw+GGbw45xUS+v9yYeDo0x8HMSKFbzEb5jterrlvqAlqVofFt0XpRmFko5k7w+/gDdX1vWTXdNjA0newXgVqeNfsWU7lFsOwpAHYL34b29uvLJ5MYs7ABG8dXERBmp6v9Zw+DmdvJCCsmMqEmmMKbF4MuUfB5aaeU6Ksi3v7L5Yl8TAl/E801u92m62ZLWMTWaR/g+YayRpbC2XsDlIUVosiTxB/07WnpYRPVukSs6aXc/5TgD8f5/N24E/qrAf98zMAr9MEgSo6DtXvpvWPt96yoO6h4Q+nZlz35THL4iwx5ZQxjwICtoVu5RpFP3EigbYzyybByLUOuZpdYTQqtmbSkJspQ7gm69SAk4ER0OC6WAX+K1StVrFeDOSWTwl8MP4KZL011a00hh7gt9xshKyWhedHEkcDQdCyvWuhTYFOgJg9riDN5CE84xftbQj3yXlCm8XeTY07B2y+NC4wHyp+MqPu6WNmes0r2rgGClqVWUaX2vz4LDLwV0czK8e7Au3K/xZTGObIwQaXMJw2x8ZeuCysiXuvUylavKv7CAjTrQvABMZO7wLpCTpskynME57nh6RQwCZDUwlzB+zeO0VlZMPcTkQha3T++Fj9dvlpxzFieyaDMtMKS9uUmxDsTYY
 zkEPcZAS
 5i9alxoMPpmY4OCP0W6WhvW9ojrrPJnjWcOuXR8Nh5aO/j0oQghn+Sn897Ne0QMyCQav8LO75zF+EYDFurhNlWmd418p7vSjI9jDH7a+sAdK1p5dXEhyWVDKXxMK0bwMafU5zaguF4sUw1oKWtCg4EFH2EP7blwXPeqYw8uMlly0YbhPQP/+xkGIQGET7u6hdE2c8DR+ENyhFJjwlMp1uwDDMeXN7sGwHFS548kBurZtPeMk6b1vGDKSMLswxr/cmjAmmO5gqwaNraMtYE6GAopDouMhJ4ASLae7PUQC1UIzO28MligjRFoexP9pVgiGaDZ4TMFjkXWFjSbH70mAL29rE+BhZUSuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 09:19:42AM -0500, Jeff Layton wrote:
> On Tue, 2026-03-03 at 05:59 -0800, Christoph Hellwig wrote:
> > On Tue, Mar 03, 2026 at 08:43:15AM -0500, Jeff Layton wrote:
> > > On Tue, 2026-03-03 at 05:37 -0800, Christoph Hellwig wrote:
> > > > On Tue, Mar 03, 2026 at 05:53:39AM -0500, Jeff Layton wrote:
> > > > > Like I said to Ted, this is just temporary scaffolding for the change.
> > > > > The PRIino macro is removed in the end. Given that, perhaps you can
> > > > > overlook the bikeshed's color in this instance?
> > > > 
> > > > So why add it in the first place?  
> > > 
> > > Bisectability. The first version I did of this would have broken the
> > > ability to bisect properly across these changes. I don't love the
> > > "churn" here either, but this should be cleanly bisectable.
> > 
> > What do you need to bisect in format string changes?  Splitting
> > every variable type change outside of the main i_ino out - sure.
> > But bisecting that "change to u64 in ext4" really broke ext4 and
> > not "change to u64" is not very useful.  Commits should do one
> > well defined thing.  Adding a weird transition layer for a format
> > thing that just gets dropped is not one well defined thing.
> 
> In the middle stages of the series, you will get warnings or errors on
> 32-bit hosts when i_ino's type doesn't match what the format string
> expects.
> 
> There are really only three options here:
> 
> 1/ Do (almost) all of the changes in one giant patch
> 
> 2/ Accept that the build may break during the interim stages
> 
> 3/ This series: using a typedef and macro to work around the breakage
> until the type can be changed, at the expense of some extra churn in
> the codebase
> 
> 3 seems like the lesser evil.

No, 1 is by far the least evil.  Note that it's not really almost all,
as all the local variables can easily and sanely be split out.  It's
all of the format strings, and that makes sense.  The only "regressions"
there are incorrect format strings which have good warnings and can
be fixed easily.


