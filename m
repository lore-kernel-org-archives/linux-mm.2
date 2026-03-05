Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EBA2F33A71
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 14:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AF0C6B0005; Thu,  5 Mar 2026 09:25:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CA46B0088; Thu,  5 Mar 2026 09:25:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9916B0089; Thu,  5 Mar 2026 09:25:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0646B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:25:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D633D16016B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:25:37 +0000 (UTC)
X-FDA: 84512232714.20.3023A58
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 065F8C000C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:25:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lH0MXtHy;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of BATV+2e11e6930e970eb8572e+8229+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2e11e6930e970eb8572e+8229+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772720736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7WgSM2wxChLNQuC1Kvn6fELh/kLhkbo4HJpx2Cfu6A=;
	b=34sLxuYtp3mKVL5DNaDMW+PZFN6SJQjXJdwojisTmNXXeDBmGQViB/+SFSDMPzHPUFvLhx
	Ju8DGOSYo+FlbKxWTwUbTeJs3fus7o4PfeDDSdOkbE6fDEhIWOt+XTj3pnTWEz7C66EOmS
	1J730GS4ueRNtPVUsed+6+yOGMYgLBA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772720736; a=rsa-sha256;
	cv=none;
	b=myHQZTj+JEFiuABu5xStYt6z2RktQ244kNy+yGVSGNHwypy66jAZnZEdiGlUkaKORObdiN
	4zP/OAw5FtCYMcVlGtd0KGy5A1URhiwNw3Hkoqb5/bfNnS2QfQ8TG5VQVdJx7idsCImghb
	M5XkRZIUJQ/+jW5jSpBTMjIsCE0262Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lH0MXtHy;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of BATV+2e11e6930e970eb8572e+8229+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2e11e6930e970eb8572e+8229+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Q7WgSM2wxChLNQuC1Kvn6fELh/kLhkbo4HJpx2Cfu6A=; b=lH0MXtHysHRHd3GA37b3KZTjyP
	uu4y4Wtum5SU6K6sPfQMgC1wjjkW4oCqsV4k/47t6pQLQeF8ZoEj/MCqcOOGspH7qzymaVtmQP+Xz
	McOy8ppewKfneb0WSeWQnqvtEDYc/dlx8W/zl9H7IajaOG+qhDprLRbWd56Gq6X58gqQbt72A/1Fu
	57Ga2O0/96vpcbtKCzVO+AvNbbfp5XHKwrSU0HjpCts8yao8Gtx0uNB3CTwnNFoO22s1yTa6uj5cz
	t5l/w2CXYVAlbsn9+teUymKx7c1e2jxul2t/6h7WcREQXT8EksTsachxtLADsrQgvaMckHOQQ2x5B
	kI8111qA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9ck-00000001ywt-2yR7;
	Thu, 05 Mar 2026 14:24:22 +0000
Date: Thu, 5 Mar 2026 06:24:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
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
	"Darrick J. Wong" <djwong@kernel.org>,
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
	codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
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
Subject: Re: [PATCH v3 01/12] vfs: widen inode hash/lookup functions to u64
Message-ID: <aamSFgXhrORAJLBC@infradead.org>
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
 <20260304-iino-u64-v3-1-2257ad83d372@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-iino-u64-v3-1-2257ad83d372@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 065F8C000C
X-Stat-Signature: wm39gjd6wx8t9uhs911g7swqwj6qq9fk
X-Rspam-User: 
X-HE-Tag: 1772720734-585533
X-HE-Meta: U2FsdGVkX1/+JMCkaXwhCJbTKm3k+VHzfFaEgkt+p8XEhNwYv0prWxR+i/9XzQ4hamuKhWvWpyxr1LB0aI0mZ8wfKSqWntpoo17XFpjpxOYxCa2W4p7SkovM0EB86ywXwXrwsS7d2k/m04CdA9gh1qKmlBrQYOnUM+SoxwByEc8buXiciTZbodg/iZy7+PgX/NCKU0hOlsCKfQ0NVAXyk1R4HT+K+jjXJRkQZ0F8TGpY3Z5cP1V1sOGx7SRv3J8w5vGwLsjaJFfBqqsos5tHN9duqbg0aHHn/DITKsLWO0TVzAn6mJ1DAH1BenvihXJFKDNmyv3Fqk4jeKFFOrstbugKuIh2fI6W/N58haMXK6wjvin2p48hMcA5KlQ0SZYQFBMj5KTDLXnvoHutOisbaJhKtArpYJBzFv7IlAeWFzaZItffDdK8o/HGohbLXEMCdUeoRf7cRaPpTP4UPGU4+n78oW+GjftKOrXVh6ZED1ET+nDHsIXBPNUUGzwMpSz7EgOSfMMPSS+SYi1qoAjCRA3qTFqsL053JpNAQjoFljaqPYioDXYuyzKAbOic8Ie9M8deyhm7/+uBPZf/Hi17Q62Mc0R2h2FbHc2BIKs271YvbsT8r6Fuh/nRuX/+xmbezCD0Sb+udZ3OPJbe93RBe0nTHbyOasQliEzaaOwUdoPCvotc2PB/cdherhP7Rn56Y0Q+gU3fw1AMr+L7Uu8R3uWyPCSxw3347ZOjnnpl4ua5p37By22KPLSm2Y+m+Z9uVQafod9GsHWST3ChjYIGufoSx8gTudNx5l+H+xu1KxFwjVR4ipqG8ufVUvKXFiYzRlscvUCYMrlEYJrztaRkuRqy+wyW4c6OQU/nzGXvn+O5mKZxwRYi/7YC3QnehmzCHKPa/bsH/X14iQ1Np76wKWNV4HNKVg4FN53YPEZ6f6Vz9QQIUDmZziP9potc94WLtsg1dFua8R9+u8FfuPU
 WMcMPRiH
 /n2H4e6EN1tb+VlwE3slPbQI/2ohNMNvOtEb+oMyOXe7djzGQ/jwMAV7vCJMsztjRDAYCZf0kNBvWJEHzOvEZuwJYR0ZvfRrodpCrxfuRL8rSp6WnNiavOfokSVTK+dMqZGpAj4WNQ9SSwUo3Aj3XHNwXDbcvuTpxg2+f4LXY4fg4SRXLUxf2cfClWZQ2N0vo/tw5tBJ13izNqkRplT3l97vtalldX59xGzTn5xClEI/jOJNWlz7Z7Z348P/0WYr2W1rqwCfl7aFU7YCLyuPblHWCb4g+ZCS7EgU5RhjwdX5shgVPt5HbhQIZ6PBQIwJ24MXW1FacWw7URkrOG0HZwvpRBRXdu1pOgdV4cvLPrOyZ3zncRPfNQxw/pIR6a4poE1VaTWKtsXvfw81xJbpasBZCTJFtbJFC2fXzil10huGT+x8vPCeqQtBOWcImI/jqesVEWCyY7RI7l1v866LSy2t4x7zIDeB9JpdnlWkp5G5BunaBT79PDQ12cH/LvleDtKgI772Qdi54pl9ton6EoBcqD/JOTjuMiYEDxWsnRXRi8j0FsIgrU2AJW+taKisurPnhFwKW7KOzVNFYVbi9DkGZaeX0kemjFzjM0SN9Gto+cxsxGWbuYqCSD9TPwLRZwoB5Y6sS5mP7P7TmjA+b5pGNv/bDA343tzXcqNuejAHM4NCs9HOt4ICQl4+QB3oePZe48OS1W8iR/OcWDiL5j90E4KDGHeW2btF8ElNGdd4Es9KI58gBBfH6IpfNF9IQfulpPUHExpsF0MjPLABb2caFCKCxf78AGmEDxP8ARBH4CSgf6bsxybx+7NfAuf6Y4S/iDIPIqWvdW7GwgbvqZgXG2ycpHvO0IBVKFYhOMbMh0YKTtGAlOxdHYFl8EB9mA+TL7VE4CNqvuu4qFrnHjc+rtPXyIMozyId4wogDPqidsnYTL0KNuU6YNCz4abKge08xHxITo6GukTXsQ8tW+DwS0PNf
 B6LRN4+w
 LDINfVC5xY0HX6v5qOVvV6PsSL6clkYzcgGEpVphgo1aLNrBqkDigspteFh5aaeAJNm2rb0hXEE/R4ojN47PPQ8JVFXC6XwDSUSgzcfVQgJbAjBva7MjkxgmjqmWHHWrPkCBCbSL9EfKVpwQydJl5Jo2Yk7KSJwXrZel86VqT7W1K3jl3LlJ1CtEctcdQ0Rqqb62yQbfg+31Mey8skE5O+B1tKH/6a7vxMeYxXv0GpLsWYFiEhZ89/ezWZiAHfliuxkhk8AzqUCOlppyTS4c9D8PRhUC4g9MGAfdsgnlyNJZRym73JVHenk1z2G5z1aMkjg6jhaj87z3JTGp02S7CJtX1sIVMvA+W+CbTrjiQvBWoFIiML2ql496+aiQ/rGPIWsW/4vNNRaNazu51zJqX+pukjoSRMJQBxPa+nS5uDkOibFiZZevnzYoVKCp4x6j8aIB0UD6Bltp+0MjhVAY579wBvLrveeBe4Fx/MNbAySKVmXq9i78MiaPZq7Ngy5EfapXyA2YWJsvxx06Nd0LfXfEALaegJEnLkZ4NnvfQQMd/ppaA/HNsXwZxt3rzp/NlPA35+hL205Ia+TPqCpYoolVhpkgW4BBlZkGLCWRc5AzaclOxGuhuAaVnvAO/1lGzFdkO8VC1wM55ok1XaTMjftW/6NzJzqaDfywPPCvKrQUQQYPxwU9R83usUJ1BelGE0IojE1shn8Wnp8X5k0QP/P4FN7ikwHrzwSfFZM7pxgwTfAZtn/wbn/XBEZVVFPYOQftr1BY0NfZXZDDZQ1mJ8uHTh/r3m2WYvkBY7z91rLqecY+lOMxW4q43FQ7EuQqTE3AjIN1Xv+X98exihscbA3U5O8sUW8fAybzO4UctOGfSo6Bq+ZLMQJLIhWBRMnecrJowUs/odAxHhbdhs/mrbLjJjIgiGZlji4Q1E0G3uAs8g7qWLHDLOvtPVdfJeRWKaHa7Ti2Tnxh3+n8oGiu0aCUHZ1gd
 zZOadNQS
 nJ9VKoyakS8KBWQJZuUHmdliwObukyvXHaSETHhz6n0J2mFoCUNYcXaD/VlXuPux/VpUcdMHUpiL/cAstjq+8BpyayEI5NURS6N/yGK8WHzocVaSHgGEIzcNtXuQ4MG7WS53o1vLqQgC6fHf/7TEhoBD0ozENjcMP/9NualRiNwovxUkN3oXgvVIO56i4C5PVGe90hlmV6+d3XfL6zr45gzouiEeX+ncIkyVZZqLoWX/SAJD7vbxbHqvaBVZJ99o9FrGKQLZLaYCp0DDR4z3g2PHGbcYC3MvnGAwKR2Y3dwQVZ/5XH6qCPGbNM1Yr1zsXNWeR9OwaWJcTIfST46bZxj0zrm4UsTYeUC4ItwyG9zt+2NQsdJx8Tgmfq3GeeXRLnDKotRopt0/PNq4cTycCj59PuY0eZ9IQsSmyxJwrCfX+fQilzuaJvufkiku9B5FqDmNRa7dLf275yW3Vb/CmNrm2tQ46RajugJaQuT4KYR4IdH/5tEzVWtdTE2+w1c9PFcUQehHIQThk98SbqxdUN4bNHrvmyF4E0FyVLjU+SSylI2b/RXIu92R/zPgPckXU2+zjc9Vc+gpL6jIqTtWl0uYLsFr/F4HRtmwjXLzdJE5EIu6YXsD3LyYfbU6kHQbxmtfSfN74ZY1f0s1OyDj1p0soTco+g9hyuSsirj/pgLKBK80hWM5qb+dTpEnOHJgk3pe80+qM7bvGELIp9B6jkJ95qwjL0UWyeP7Tvc4RURXSLznyBY9BJuvrpb6Ap5yk9nNl5LoDVDTEEmZdmCzUz3XaminfcQijjYIBDzchYfsK+M8uRFGJU+S6xWkuA96wa8EzaUKFr0oLru7Uu2f+6DMZMuT56d+SMIzZRY2wkYEx5ekfIxNNti9OtFbMgtnFhDBTS2R5kK9E18rNARMrBzUXisKtzzpAqlPcaG4jMbxHE10o7Z7MzCqmMFbb4HsvxgSMyxszunINUZMKKzz200HKWK/l
 ++lZHvc2
 gD7vtozvwYp8juDN4/z1YuGrgAVUQcSmFRtINLuCiWFMgUiJNFhasprn03tyRtrix/rEGlSHsTjpz7hoyG4MYSq4nnu2g/kxsaRdOgO79PDBaSXOI2nNqjWeELdEmHttn+64sF2dBEhjei4gGQJeVO6Gwz+AGE/LegNxmK2PwL/F6L3yRr4KNdI9YQcDgfWKLe/bVE8sIss1SdmJx7il64Bs0C1zHbvQc+u77GvwyuMMdMlr7YHz/FjzT7jiJUdJhd5RZ6sdDRbzYqT5+HlTVWDq+DIaWygvVWg7F2/2wyFxr/KYa13xxKrMLB4HjpsPTAVThji1724AEPoDMElwYzjLSdKgnfK/4vCpaPNVHQTX+ZVDI0wEjLFSTjaCvjhJXZvkrPgBnRl7BExuGTTv1FgMzLBZMENjg6BsnHwkXjJwDK07VYx3bbTttpaPf1S+SiUThB/rCGZwM1GN0kPP1NcRUxvqOnG4KudhegrSJQTTNLAgBS98vd38YRpaqxyydgnw5JJZwUhFJjbiD/TCZg4sCGrluKNt0UGQtLqNZAeUaRt2+PH3u9RgNPpPeSuv5q2qub3mo3CGNsP8//7YfNzPp3PnhxnJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  extern struct inode *ilookup5_nowait(struct super_block *sb,
> -		unsigned long hashval, int (*test)(struct inode *, void *),
> +		u64 hashval, int (*test)(struct inode *, void *),
>  		void *data, bool *isnew);
> -extern struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
> +extern struct inode *ilookup5(struct super_block *sb, u64 hashval,
>  		int (*test)(struct inode *, void *), void *data);

...

Can you please drop all these pointless externs while you're at it?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


