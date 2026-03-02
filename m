Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E65DEB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7636F6B00A4; Mon,  2 Mar 2026 15:35:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716846B00B1; Mon,  2 Mar 2026 15:35:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4A86B00E1; Mon,  2 Mar 2026 15:35:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C38A6B00A4
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:35:22 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF943160331
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:35:21 +0000 (UTC)
X-FDA: 84502278042.15.F98B004
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 22D334000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:35:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pLx8cGjt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QoMtKZl1Q06E1bRZUbLwJas+/XfxfWdDQ+F0vm57lWc=;
	b=xknKAWoV6s2U1+tOjWSZ4BLJPdL0cRVKlILUF+0iLr5WykBIzmQiiGvduv4lFMw5sh8w/j
	vE2DPN+PeKGoPFi2HT+uM34uCGp0RbE+DOojrPeLju/wmvcEfrPCyGux4PMI9ihae8/96Z
	uCbboP+EuJ86ZDCYzOak2EPtlwVv7EU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483720; a=rsa-sha256;
	cv=none;
	b=afdXc6N4FabHmiAd6ZGFgntlEceeMaCvYQKWdY3RyJkopbjXnkeikLS7F+bi9OzAObK/JU
	IPtoomv/7oZcb9/ycfAYeHisE6FDMpT+lUYtpdJIfHEBAIKuZVYTqpn6SW0ABU99fOVaHL
	aopG2b4Nm38kaue7mrFVZcysKqgkJt0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pLx8cGjt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DAD0400CD;
	Mon,  2 Mar 2026 20:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBABBC2BCB2;
	Mon,  2 Mar 2026 20:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483719;
	bh=U3KpNq06HVb6xR2bnjz6Ns7LWxuPeJzECvQHHCOjgKk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pLx8cGjty4Av7EvuFhZGm06zvE+fJEx/T6LdYbGuWr1Kpn7VXQ8VwYafXrDnbdGA8
	 OTOcSvmMteKhRNPpONLMHZ9/j7peBuet7bN0a8VyXX0fAXV0iclQHv6kh9HVu6MIAm
	 DlrESCS7LYO7JztMixwR443j4hsExnSBrlTNcOxXedAyisLMpuFOTIuFnz/YpGcexf
	 EqeOXJEst0+5/M01sL0p2V5J6uYtPzLZFYEn5MkFmPwm9+8PjR8FoiXMPOQNNV1CUx
	 stv6xhWEG1bjNnN73vUPFdKCdrpxy4w6DkjhvId8+HpV7G1x2tNA7/wd1c47mEsp/8
	 59qfVJ1WsOLMw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:27 -0500
Subject: [PATCH v2 043/110] qnx4: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-43-e5388800dae0@kernel.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Matthew Wilcox <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>, 
 "Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, 
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
 David Sterba <dsterba@suse.com>, Marc Dionne <marc.dionne@auristor.com>, 
 Ian Kent <raven@themaw.net>, Luis de Bethencourt <luisbg@kernel.org>, 
 Salah Triki <salah.triki@gmail.com>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
 Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, 
 Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Yangtao Li <frank.li@vivo.com>, 
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
 David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
 Dave Kleikamp <shaggy@kernel.org>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
 Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, 
 Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>, 
 Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Ondrej Mosnacek <omosnace@redhat.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>, 
 Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, 
 Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, 
 Johan Hedberg <johan.hedberg@gmail.com>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Oliver Hartkopp <socketcan@hartkopp.net>, 
 Marc Kleine-Budde <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>, 
 Neal Cardwell <ncardwell@google.com>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Remi Denis-Courmont <courmisch@gmail.com>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Xin Long <lucien.xin@gmail.com>, 
 Magnus Karlsson <magnus.karlsson@intel.com>, 
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
 fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, 
 v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, 
 ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
 jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, 
 ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
 linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, 
 selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
 linux-x25@vger.kernel.org, audit@vger.kernel.org, 
 linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org, 
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1304; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=U3KpNq06HVb6xR2bnjz6Ns7LWxuPeJzECvQHHCOjgKk=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH6tGlXo9qnz4TnjlgdQUVua3GSVfoKz23su
 VdlF9QDcUSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx+gAKCRAADmhBGVaC
 FeRJEACqBomLSQl899X2tkLcb+Mqxa+0zQydlhBs5zMB3tLj1dC4mhQ3qXhr9GZdy2QuDdEXvR6
 vXwurD8v/1nTDZLG9XQLSP8sRIixE4Em8uwyHAWIP2OVXlWoxwX6pPlfuUdwwq926PANjPdM5vO
 4ddU2YnYdZLplqR56VOCioDxob7oxZQLRlwnGiWF6d2kQsZsQMwKl5NeUX1T8S9Co60DP6zd/3f
 ZLGej4CuVQEvn9zjEuTmnISBcYIBpPI5S2scJ+scU4e2YO4IxDD6DsBxQgZCnmgkJGGlLIPe4E8
 cL2iVaAoC/C2m54CnBY4Ukj5o7qSQ0Txck0LuTfS26luzsaQlJ0KthqjxLtbeMfDV9aPjfCrzO9
 9R/LMA+z4YvyDAmsihoaRFWArYKK9ZvFw431NvDIrMiJan87FIiFVHzc2qYHsTgT89T5bIradyh
 UdKj4iemeH8I9WXXW2+a1CMagwjFrhg/LxDFYV2MNhqgFHOVn8xYIbUOfzoG00EiSoV+f6HAEJp
 C7lLp+ZQuJW3Ok5eXfNGbu+wP5FJT37ql+u7/pRYeNl5ecwnFVXSch6rB78FSwpHdCHjPuPirlg
 Zfrmgto7pAcwfM9ZJxlgrSDPdpReleRhXjit8C2IkQigtXJ7UHT9AOLH+wCEUM4TgnWXHnVoXPE
 /cNmeh0F91M/fAQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 22D334000E
X-Stat-Signature: 16m6s4d9azxj7ue8xd13ntq6x9jtiu6n
X-Rspam-User: 
X-HE-Tag: 1772483719-7446
X-HE-Meta: U2FsdGVkX18MmEPDlc5vNWXfO714p+QGR42q0jZ3WExTVP1SbzmLIAiNCsbw73vJAPMkGtO9uUbOTG8FTdJCIcOuG/rXsGEPJUzUPRVB0tDcUBLp5iUlj00s9bTquHw2yPjX2bm/dT1VRoMr+Wum0TxkcnZHvV1kJ7LbheYF03Srrf50CAkY414Blid8AxJ7GZtBfOqexUqfg8nGVUlk7w6fey3UpMQO/a4mctccSwjKMeQzMUKCbdY+LeLZlY7car9rLUoO3Ry5CT/p2uWzdGQ4gW+01WFKwRhnn7bkyVneQNfzQPc5HJohS6XueJNAiUZh4MADlitD83kEC2cDpmnjCS6mFgGorNljjQF3zU+SgONgqa5QVn/UBncQRxE2OsDhPrmerazq1tVdRYzmEQefAJGNuYhGpE89V6sLt65ORfQ/GFViPhY0wrmf6bayKgPNyNqi7ytQ97fD0EmXZbPH8v83KzDlIHLUcpaBDUUxZa6IXnsJhcAKBE7Tm3jJFCElddpig+XKKQz/1mU5K7IdPPLLVSpKIp+YZc/mGixueEbZmWgvpztXdXakRvnB/7BBq5s9EcBOgVAfo1/RFZrgOjfKoj+263H33x7+/bKo+VUc9P5nbi8j7x3b27zTq5aNki46c0RhN+1KavaPtV7xiqUG2NldWaPMWW7XiYNkqcE/JXK9O0yTIUBx831nwoFjtFTkH+4BqErs3bhn9RqbCWwVZam0JVRzMAW5t6u3+ykea+czi+dpnxZMbk43fLZj0K5U5lwmYlXSAUdDDEwvlVzAUwIGTyo9RnV3M9qrXtLTdwR8OVlCbKT4Uo0kcntHEvTsnNK4t+15vhXiPzkajiEbzNZrDslgSx7Bo0+Z8UiWM1JYDKePVP+SesVlh/KaWNP8cXxTFUkJEH3QrXwwGloJTbL2+Nvv+qHjnk780pW9HtIP4O/58aokFLClrLX6dc9KLOi6NOrv9Ug
 W4GZ+a5b
 ZVgxLtk1O9AsEp0HrJ5+Q8Ul2hvK/mkVfZNVrhTVSubFTzMcQ/y4oMjM8ExwYrrBQXDW7IcDs/4SV83clcGLtZuKZrb9i214dIaZO+Cq1eGdcdmXHefIJdaNbBFXV8p8OhMkbiDQRlo2xq4wn6Rctj8dXg0/2DXIUluo6WuZnoZTE19+KDny+Oe0q5US1YEevRvNzm1IeMHSEXQZEx3KgYKbUlgnBjFMcOUfwFqEPqK02CV9yVgDHejbJ5cpzlcexPsfmarhZfcKDeJQiQTEbyW5JVPiHLPLTtIJ29OJoUERg8JWeFmJqsmhEYncdF7yUtinP+OYIp6YNrLWFGbxbX9E36um32M+7lxMUMQ6kBmGJUzwVNBNSin2Hn7gHrb+NxuRcomIP4WjdtHK+hFX5EA7r+QR5TTTSa4XOmEPKwG5+lOiXp5WOG/vgImFqsQlLZTxcRXnrgXGE6cpZ7AyDvPtrrkytFhsJMy4+0IcoZ0IbnPEUxCTPFuRUYI+gx6+nMVUPwaLO6Mm5/DEg+gMOgZqg45zCe7awOiYsot/5eQ0pGx0nMF5d9ED6JajYeRRkxZeBkutoCwZJU0NVZ07egmlDt9xZEog0/QRz6l5EeHE1mos9xf7K0yC3cbdoMoYO5nDEIQ8HzTSaKr58Mhsx+PbpeuUEpVxi51vs9WyC5CW5cpFUShKCOA50fuqPStQ0cqpRk0AamhgnjG5fqCqpzPyxk2WAZaA2Z2YMGCOhXguuFXiqxiBi1hc76hcGS+gtEfXDNuzVFVGCJUQxcTr90QzS/KRw6y+vYWgQOHkWwnq8hbMr0OhA4tlGcfvTMGL+s+BBvAyztyMpltJKBo1ZHNXoCco+8XAaVtWQg6OOU8e6MkfryQ7aoZGMSt6GVGZ0gzI+j4b/xwzJ0JUblBjeebPp0qcmgPIWJt1FNtafyybRdW0NTPGGFgFEsR3kv//SLifWkYE9Q8rjQfPuC3X3OkhPXAhy
 P8es2wve
 Qu6oTDjR8iKt26iGdcF9QBfP2DZ78dql7JC4E/xymqzF78RWyhCmHcSUCooFJCFySJ8OMqHQ14tRsmuKacmt6B5Icb9iwHzUL8UlDgsT6Kt4TPISucAmnzE7WwYDBHvZtpdrfzKQmVi/lNqqZWyLj87ClgGK+8GqaWwqdyadjNoEzY/PqEKXhRtvHFEQf8OcMqQc2nKkp0ixAn4qwn+Z98NvibRDPwiU9DwS714vjpi/bxI8wnvVeIvfZ+BqyMKJ8MP1l7FKD+MPNUCtBFySTlmPE3cwfgs9HlWsQk7GeGzZyy7EkJucWPGsB2BzJAz5iW4m5qWrZ7D3JAEiODH8w6EUebiSyZX1mEZ9TAq+vheERixF4OKqVY8qw4lmxkG5BbvIJDDHnqOInTaJH9TjiLsLD35RjD7/1fdEatt8C9GgxgDWFsJ7+TjDC4AN6Itp6bmf9XMsTC+/l0QJyCELvf3rtGpPbaNsh3jZQlq5cBqGbjt/b3fX5w26SAPb5rPcK0SYW4eLL8j9rqbiOWBBTDwoX1ENFM0aozlBiNA6fXQja8YNHQQsDo82Wv1mHnITw2QSnLM67WneqPNp2Gjs5X/syAuU71mXRYtZFUJGOBNRQLdaCCLuPnCzG9LLaru+RHAmE2kBYW70eeCIveagi6GNiBZ8rV5iuL1hE35AG8Fk7lq8iEw+2TGwKAuTtrELE/DT9YOgoVFMQAKvnrwfFAPba2TxKk8LvekjR7xEdOTE6TuZ0MtR5vH9xG1wpraygki3txR6TxbC2fn7rHmoU5XGNFvb9rxKgdSe+mDh+81lmUbeL018uxAWuCQNUhYvMSvQjEIq9c20YrxT4PsMGgOxYca7D0SHe0hCwkoDuIkXMlMOSnrbomgiWWr5zLMGaH9tU+3g4mhmHsTs1gGFvdAkiyrDE27K+sjs2a2j66G+CZ9+ES4onOHHUODevhFstBl/GV/2UbI6vurc3auTxeZzZZrtM
 lGS+o8r3
 Fb6lqjAXA6UDRCrZ0uXndNr5VBu2ghX6/siKPWdBsNLj3IxDRcYWlriJc7Bf+/Wkub6G2YsVNAYPCViX6M2kmnPB6ZBA+o59/OdEG7uvJ03RVbypJM/kuPNCSoC1H5ugN0SfcxBN5w6fQTbCO7Flks6XUC3X0+S4n2DSpK4rKtMDd8O5qlQrLjHgns16do00MMReUhNLFDEvKJytdM7UHC9keTs7rVe4HhR+d5+SUTxGh939CtmHX316vRBzRN/AcjvrhO/bU0zxM8dLmiVQrgxjsS+HcgMRVW23dcrroPDQ7u8gy4ryZ/hFWny9+ztrPIUBSJ2/DhCyObEV7VtR/0pTlqIrfGECLP03RP/Hl3tfdjz3AcrV4EMaigtVzX+gePkTqXgt52dOXxRNI09AzuNbfbfbY9uQeMusuMEe7xqkzKv/R1bgsVZPDwldGH4ImZNSE1kMvYHNECs0QVkJwb1bScsSAMwyGIuqs8CMqDCdaJ1IwxuAU4UCAloKe77TH9ZSfAUuX7gXFvqQ1KFQA3ahjzNqFpNVsI2pLvi7zmFzm26V7P7Al6ow95TJoepqAUBhS/bvsE5aokkYQMdioJrNF5tnSnHUOvvTwWU3I2gDsvGl6I+4KucmoadTM1wXz5VfYjxdhYvAvWJhuT2tzlHBWARKUSkdt5UveJIbPVXrT51FS7ujKl6XrNuphjBSTt4cQvQADjUOyIGlJApTwVPdA4rguny81oG9AVTXc0kUhxnw+GMXk/6QMWQLenGcrOeLe+egi7Qm5e23j+YfycreWl0/n8OPssEnRzuVvVYefRntwTbGSIvf6GCnUk32TywqTV8DSR+7QLQdkmzmKy/88rxXyriBb1zRMMTdZBcCkz+T5lA/fmmYTc5RjrCRD9ZiCQaMk0EbjHzcAgzLjVHj85+JswtFexroo6jGAq8RyiGjQh6C860aqKHSKGWGQ1qTLFZccY2LiVZAEcwqz0F3/53bm
 +BO3Sx/Q
 H/oAZ91Xzrw6dMVy8Q4cEYE8SPopEEOZWBtHInG1HSDFZR57bWwPNllakgLypopQBCTbP2tksRSXXJKit4PC6NZB+2e8KuhBl+qePysyJo6TxW0tkh1xRycoW0GuDBYFZF0kX04mNoM40CrVOWwmR7j5XssIrD17Pnybky4BYjVg/vL5zupl2v+O5HAHn7rbzbdbl+BgKXDfz+YmO+rnQia7RvrpbdbSvLT3qLdoyVDX5W+WzYdtJUAyjhXKfp5uGLqIzK6GF20mtU4UOS2MZstySdnrN+v6XgiBKuxYqQnxOytSiTY5Tam95LBaNGGl6XuexuGQ7zKCUF9kz6w+zeeHQ1nC2TRU8emV9pfZhDKKwdULrPuk8F2cKZ3uqVLgMvuL4j0x0CsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert qnx4 i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/qnx4/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 8aeb63d397cfd6c87b7862f0dc7a34cdfdf02f9b..1226de01f2d3c1d79fc054f2b882fdca2d9d78ff 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -62,7 +62,7 @@ static int qnx4_get_block( struct inode *inode, sector_t iblock, struct buffer_h
 {
 	unsigned long phys;
 
-	QNX4DEBUG((KERN_INFO "qnx4: qnx4_get_block inode=[%ld] iblock=[%ld]\n",inode->i_ino,iblock));
+	QNX4DEBUG((KERN_INFO "qnx4: qnx4_get_block inode=[%" PRIino "u] iblock=[%ld]\n", inode->i_ino, iblock));
 
 	phys = qnx4_block_map( inode, iblock );
 	if ( phys ) {
@@ -128,7 +128,7 @@ unsigned long qnx4_block_map( struct inode *inode, long iblock )
 			brelse( bh );
 	}
 
-	QNX4DEBUG((KERN_INFO "qnx4: mapping block %ld of inode %ld = %ld\n",iblock,inode->i_ino,block));
+	QNX4DEBUG((KERN_INFO "qnx4: mapping block %ld of inode %" PRIino "u = %ld\n", iblock, inode->i_ino, block));
 	return block;
 }
 

-- 
2.53.0


