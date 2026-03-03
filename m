Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE465EDA687
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 15:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379A76B00BD; Tue,  3 Mar 2026 10:24:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327DD6B00C3; Tue,  3 Mar 2026 10:24:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DEFD6B00C4; Tue,  3 Mar 2026 10:24:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4656B00BD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:24:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A675BC123D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:24:45 +0000 (UTC)
X-FDA: 84505124130.23.659BDC9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2F27E40014
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:24:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qxYMrhdo;
	spf=none (imf11.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772551483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVOKKYXrgrNLIFNC3VguacredGR7s2JIN9XLcH6po4k=;
	b=DpUs5Q5rhw+OH/RREqGusDCqgoCOUb4xoCedrB1fuPUUaWUa5g2fQ+DYBrLM56FWyFxgXq
	bUQwuBdzW/TJlT91fRatbcFTV3l1xRYFLqR9t2d/0zkLlPaqwaVI5cMQOzf8WW0atnlH4E
	dFgYONxaT0GNR7LiUCBYkpHugDEPQIo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qxYMrhdo;
	spf=none (imf11.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772551483; a=rsa-sha256;
	cv=none;
	b=DvvIqryDnDmpu5teF3+nEZrzCUfRhT7vMBS+zwrdvfqPSRsr8AQLATmqEVi1spJ08dJY4i
	bz7g8WjXOcM3pZc3vz/iEEH2I9c8ZdYNpP3pio6k3EundDc13Ydfqxu2KxHCDEnWA1tOdi
	30w8CWVs4gr0qk5zDONYO/2/gBPsXlg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FVOKKYXrgrNLIFNC3VguacredGR7s2JIN9XLcH6po4k=; b=qxYMrhdokZ5HXfsJyeZZ+fltiy
	1XEerkGQnRdFJFtxn82KxLYF5xmIBDbLKs4V5zGrkkAKdseaLA2m9lZs4IGEqH3A6LWUpxG3Ek+0v
	CsFSDoyxjNUXK6JzWA2t741hlnnhb/IO6SKTq1jFtxCMKdi84yA3hG1047qxz6D3ckz2IMKUPrrZ+
	IsefqNYtlHN3yxW5z7UoF5CjHCs3ZSN48O0RyskoLNNqzqmRayaRrfbdVH28j1Gcw0oa+snoJHb4N
	qozTUybJXPeznhh0k0t81pNRkw9cK+17tfXfV/o+1HTdZPJiQ61RdyrlxyCx2e/u2tRFDLzeS3ydy
	Ipijolfw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRb8-0000000FQIt-0QKR;
	Tue, 03 Mar 2026 15:23:46 +0000
Date: Tue, 3 Mar 2026 07:23:46 -0800
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
Message-ID: <aab9AlhqA5u4p5FY@infradead.org>
References: <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
 <20260303012556.GA6520@macsyma-wired.lan>
 <20260303042546.GF13868@frogsfrogsfrogs>
 <33228005140684201de2ca0c157441d3b6a06413.camel@kernel.org>
 <aabkBadGzo7IZpSU@infradead.org>
 <19e4e79a59dcfc4c61c8cf263af345d0d7026fc8.camel@kernel.org>
 <aabpPQxCTweoTp8Z@infradead.org>
 <1310fc5c09cce52ec00344b936275fe584c88dea.camel@kernel.org>
 <aabwflLfe2HcGv7X@infradead.org>
 <4d3b9b92da613ad329b822f3f6043fa08f534451.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d3b9b92da613ad329b822f3f6043fa08f534451.camel@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 2F27E40014
X-Stat-Signature: xso7xita566q9f5tnb9c84zuddha893z
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772551483-805346
X-HE-Meta: U2FsdGVkX1+a5sHhhql7D/KwP/TfT68SxGG4j3ab4tCO7WiU8LEr5fZz5XltDLIlu/3Yz84fzR8dqpA1k3sQYYpChJf/7AXmqohaNp907TVRC0o/Iunz0LwNcIMb3he0ECh7tG6+Zr/4xs2gsfFhlCXF9ghaWUlgbwGBUJd5qNoN+Nk1ZwOApwXUq1AqhTzwIa48o608E0ATPcmC42R4PiqJfM2W3NeJcGlcyjoOOKS1m25eXFYZptog9CulaFbh6t9fIAYdd5kQNwXATOdRZnM2f5E1Y+C/DXyrQbfxjV4WgpGBBtyK8c8F0fL5tjk6RgZoD5oHkYEPxQ0JOwGTTVEZrQJarSMmXRJyh6S9AaJ8FWjsA88tjMzut2CHB4HCAeJ1iJjqoZbZ36UUkH/hvTzNAyij8gtX+dK0DFJkObdgi1OQFOinWF1EeEqZi0sIT2oTPU66pBFiwK+JpTg4zgMOupieQIEKeUG1Pcjq81gkMPQBINYZMpD0Rzqr8nifwIGLB2idcjrQthfFRl5h9b6pekvww0HLRptiNR+iTdLs8ZlJRu+KGWb71tU0/cPrdJRutTffdvNG1PdltS8vxZUmMjgzCjuNzYDwDv3TIgVW8bm3m8X14vCgV+uHk6Z0bWZWIDl7ouE9TbuIOfNdER7LkwSVzE7MiIao3CEjAyOlIM6P/X4RBkMLcTKO3kZEO/dycK15a+C/9u0sU66uyc/CI5J3f9BT4u/7Z/Z3dfAWOnltzOAVP+BapXXZGLFfK1YbQn6uU+mq0LfCnxRRE086dci5Z4VG4+NKhS4lfgDRzmGyXIRbSdnLQOf1jWe/MqjOcTIXV3erMzarNsgnuZ5yU9uCssPzvZsmM1RxoFQKzGcM6bFEIxMTI/ahZWvPVNoF5A24EF9skUe5cG0A1ZR92XaSUzGyESq8yyKfwkA2ABq8KiH5ZRJnXQ5x9o1cqxVYmvwYG5HyjG/yxLj
 62aI03Rh
 O0Sxd9l8ledF6QbeosxkK7fxxNVPjQy2+7FubGtGz4LPVMlsRFhS+sm/4n8VFMm39Tq6tmyqbkLx4B84z2NVCk7YQj/cmiNqIlDJ/rzx39Hvt1yfQRLpx/wZrZSYIZ1pjr5iAdsx7FJyCZg1EP617DBTf9lOh3MtL8V9L11nc96H8TsB1fNm8qOJlJRDHXbrmGLbtfgVlMgoqlmuTPfgWyF6zRpuvfnv/lpVeJmBsNKooeflNafamkF7y8qz9FeFtwXiz5S7THBdRPsvHaYAg5nQbozpGBRrxTpMNUVQ2Pl43q8YOPBvBSGYeslAv+J7aNx92OLcDTgJSZkoj4PpKUetixGejcJVexp3fd+ZIUYiy+lojoACfGwQyPzKn4pTcPINSUWiDMiBW0oZ3m3+cTzWtBRynbSlJQIgEfgDDk8IZ0DlDTzw4DK36NPtYkPbop7lKu5T37o5D5e3Kho8vTHNxQmVROex2aOmM52We80zCikL+HmDbB11tibJ2lNCsgrR4PJKWNoEUWvwoZWQgFnNQCG0svQPnWPCvQJFSESrxSyUhhUOMu0HONzTbz7gMQff5UGkjL8fuBCBFHgSaLW5WQiJYdUXHRny3fYKBvPT5VJHZOG2u/6ubMAE3KX13nWIAnvG85qoLEp4rDv3UUy8xkrqyc1ukwAGy2nhxDF2Je/wrTqiw3MUVxwEGWlqo8L/ezaIX2k2uXUhs3RaTKK87a8xkaa33cmmPKc6nDgQaRje5dFnzjYU4VUy9fOHzWNMqnTKSaitcIl0rjEE8WWetw1/zXfdH+xfP2ya4KyE2U/OeJkMkPN+e/dQVi8YvdvAv17wQqxU/aRHGLVb3Ux/auty+a/LMqsRZmn/hd67VMvz+2h48f6A8Z3RFayMbTyn5NyLU5gTgbUWIiAX+RwNjPc8uKuh0VLiRiOScyk1ikMfBYc6SFrJnvs+vqfcc9+/XRs2cdRB/NWms6Hsi3jNKna+9
 WUsF7yI8
 m+EvSAnLnKo9REfWkAd9mNZKgSGq3980Ii24gvZ6dtndAb5Bb5fQ1x9VSwWindJiprf3uobkJ5DMKEr+A/r2SrkshIX6sUL266RgDYkCndFoqyLS6XS/ZpKjHg0QwIzK/J8m+45uh0MX1nBzHThrBFc/76UmCemND4/9rLBpTfNeot6xKn6Q30wcGlpSQyeyqBDPC4QCmSwB/19QB1ecqDRNi4Yb8PWHE/qQ6tdMwymqIz01R71F+ULlQak6TLxEBqYd+GWQRq5gSe7Q9Lj8zyRZr/W83vvIe9JO2LmVg6rZGdA4nQN3LY+iWC15oto/2NVWbd0PzloCS9JJx4NQuijMbMKyIih7GsXR/JFi0Wa0CX5D4fJlNO3g3QTXc9D0PXTCJ4qDoOMGlyogt+EvVk3ixcIIDrTbQ5pmHJufvp5GfhMtpidGxusfMW8rRPoI8jBo4M/kvB9raE2wGQ5DxU7+JhR0pa9BLWdhV574tyg7mVWSjs+tuWN+GDVj3xxVaAV7QnGxrX2BRyq54/4bz7dL5LQSxtWUedbLm+aEiDnUNc9Lzo8dbkBV5lLyAQwf/X4QdW4QPEIhcEdwdtBShBK9mHG/Ljl0ZSbiqhheJkDvx8OhlTDkJVcDcmXV0izQLLs8OtSi83BslFo6I6uWUe28LTiax7WY0UdMoSc0I/jv1xrefj0+/4YJTd6noMWZDl5nbbnGO9nGTgFAARqIZBLyAWAceR/VGcNXiRvYZ5YhAVMi55zf2mdrvPyRmTBVqVnecugvCcw2UhlAyAY1/f1HDzHM3CBWS4fQjot+bgQnGZxkXA75wQgYhut9BkAA9QrU3YklK9pXKJJbaWoivvS8+cYDDx9F4XVEFrElWB45vvrnIVH3naf+LRsKsbmIKUWQ13Z7mzvtqLx0GluE6VjO0hjbGWBVbgDJvOkF8KwPB38cCg0LktIXjKJ2BoKNpsak4RuOmTlbA5SaYzpEoOw6aihLr
 cqzKwMwq
 xPbn2ENc95aTd0Ib0jFUmBpTdGXBDANSwigH7OFBvR5miYfzOoAlA81R8W2qLRHVJblOt0rTJt8W+JOg4qp9Me5COv+aTnn/6XTT6rkttTNFzqU526YwLc2zO2UwCWZw7omITcBjPWp6uqTk4ukuVTHhutv5qQfk0XGHdXqp0dQ3egIhsfBijanL+nCJPhM7UeXmBm6RJG2MtXSiVK+03HpdWyM9Yo79n1sd0zFQQRbxzlkpDleKz3KbEpPm4okyiJA1rwW8mMbLabp3xbLz0VcTpblb9braCekMNAjHE1bu4GintZxPeVb9al37czWYxXUMPVU+G+klCZr7LUvO0CSuFqgDB+hb0DbkluPNqJ2Flmc1nlhtTbz3Yu7kfy7eAnKgCSKePpA3qr24+7cevHtn+TxO/T36pmhrwyhaplX+0jq2Zvs5FAycHUHSn/l9L+hLm7LnUgdIx6V+NtFuLR3wOLHgWglqNw5xAEygAHWEjrn0s7axv1m8+kGSiKHVerXTxpOEppuXX/GLiYNhxLQJ1e8BnBcWBn48DRzuhxL5NO0LRkZuM9euAhm785u7oG/2XYtZh+EScjXNhpfu7HYCqSyVVOFjN19r6iAc13jmtskxffbWnmD9YFj5rty6Cay7gyccZ62d6rDMyk0JEnJhK+YZMwrU32x3un585zUpFsB3UXC3F6mZb9UZUeLqTMVe2samcOoq9lIuPlyAyVGDKBfBne10U4EwjuPPOTUVqHnRecK6R9DmyzP4ARwqSPems1b97UakxtpWkYRwulI2Os//Vw7Jt0yl0Gn2H3JmqZXiLy3hHlDEHZfPdPL8hoZo8jC8DeScyOr6dyGrug4VI+nvK8b0+JUia8Qe5UJKtIBq2/p0tUayqRlKoiwFjWkZ5js2vbJg0gHOepYBR7bkgoxLM2jq7zQ8pfUOypjVLgUS3Ms55pEkQ1uxZYp2yoLKFvA3SDlXw/dRWfQjSLegvPXbz
 PdnlvpZb
 wT01Ew/66acRdjBrdmfSidVjFkJU8zwhNqjI1EtX1KBBumcObzGOiNcnjf3HdacIDEkqeWSCAmemgq5r2eSMGxPAWRn27MbhiSb8hre2jGl/CVNYyDurPyP2XOSbRSTE8XnjjbuvutpCILMG1UljNICDdkjctbKoO/+sqVqrVjLXBs8sXGm+AMsUbRO7JsxfgEjM5jmsDIVAAK2op9RzCWItwNI0/1nfvM5ma0QL6uZ7Ra+/9oZ9RdXJPYg+JY47l+XAaaLNIWEUbDxTPoYdlEPKA+s6czFXVNPdi2/GxYWnqF3trkEhmtpPsvEhZ3enqPQL6fWarOA5YaylDtFVhHA0TCghWn68fLxwK1U1m+/9J8AFiBkvdT7g7NuBL/Xw3nU5FiWv/qeCYHZbvtTFZ9pbe9YwZxaBhnXywHIpOY+BnFImdJRZPH5iI0UAlOVq0AVgkwgGmQ5onZBfFxoWTcNQ9yMyNdT/8tuUH8IWk3mDG9U0yW/7N2qk3TFBXuGdydI0Mz4RjgpkXceS45hOaC9+9Ih/1BhHIJxwuVia3Oa9+7n96r+VcQnqCHrnDdprvy1Wa00PaLKBXNImcXoQA2+VGnxM9/hL1k+A9UoM+74I0Uz0lOgpipHm4ot781S1YH34O6hrL4rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 10:14:27AM -0500, Jeff Layton wrote:
> I think we'll be looking at close to a 1000 line patch that touches
> nearly 200 files if go that route. Roughly:
> 
>  182 files changed, 910 insertions(+), 912 deletions(-)

That's not actually a lot, especially for a patch that should be
scriped and mechnanical.

I also really don't understand the backport argument.  It's not like
you could backport any of the split out patches individually anyway.


