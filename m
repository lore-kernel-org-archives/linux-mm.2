Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A01EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C076B00B2; Mon,  2 Mar 2026 15:43:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8F96B00C6; Mon,  2 Mar 2026 15:43:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6594E6B00D8; Mon,  2 Mar 2026 15:43:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 542876B00B2
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:43:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C4E158481
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:43:44 +0000 (UTC)
X-FDA: 84502299168.02.D9845CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 365A740008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:43:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GyUE/vAD";
	spf=pass (imf17.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6aP1rHtpQ5/Qtmz2u4oioeqsN4aUt6tJPCUG4pCVys=;
	b=EF2zzrlGNGI5V0TgRrsjzpXD5PkFv5ts7HVZt5tUPKgkqYi7ChFrqzdWRlwxkF08UGut7n
	h/kSBJdgB3xuV3ni4/421zzWCDFTCS0Ri00Ov/vUp1D0eod4/PeN+IYTnlC06WQ9lJyJVH
	R+4SE5L+FShuuzwQ7LCARqtw6mmeQKc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GyUE/vAD";
	spf=pass (imf17.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484222; a=rsa-sha256;
	cv=none;
	b=Qq7NEPfz1dtUdOrY1YMOGsCik0KQ192fTuijh+nHlWBEOabxYE+oK3N/gW1a/ChZqa5ZBB
	YH6HXamI+G+PXiCbtwg85FKiDgBPgzhe4BrFPrVBRUU4qJ6RpBtOEpl9WQeXKFx1CoWS40
	ykIm1me3jxxaQmMGHoT9OdMZSuXTHhI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C0E94174A;
	Mon,  2 Mar 2026 20:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154C0C19425;
	Mon,  2 Mar 2026 20:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484221;
	bh=VipzHX+Kr9eDABZYeJk6DXBkX8DLxI2R5jnS1ony64M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GyUE/vAD7KzUY+7p+6OmzJggORJGIyVREtyftkpl10eY2gxWch503ETBsS4wCHIT1
	 62MZajxbDK2+GuySOwLeZahfA/Ps8QLVRgyph++jY9+uLBX7YeSFNkrvESE+Y1kjHG
	 YiHhSdAyiald82Pd99zhkXqo6vqkhCPD9r0lpWAOb/kAW8p0qJgwUA6yqMtIzF62xl
	 sRDysRmrUVr5kNd2wqV4/laZwY1jJyIKNVXByAbROAP4l38TPMI8NAxfgzqZ1SYf/s
	 lLM3lfoPrclW8CEygf6/FU7krXV9mW99CkiVhlAKJsEKBWWofOi1SqStPAXfzd5zcg
	 dQd1a/KDab6bQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:02 -0500
Subject: [PATCH v2 078/110] cramfs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-78-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=876; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=VipzHX+Kr9eDABZYeJk6DXBkX8DLxI2R5jnS1ony64M=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIEChGs6AwJHM9PcHc3H1I/xxqGIk65ZS7xZ
 yEW4qgpENOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyBAAKCRAADmhBGVaC
 FTijEACkfQg4sZvZGPKPlw/OjLHzSIaxMDkyWX+Dxmfd8ktn9hI69X91bCmCML6O56ilJSkp2Mx
 xfgiC2NDUbZaRMumgnemmv/0CeiN1n1o3hFCaJY5JUHUrJrHNvd3Ei5ELm+m8qSI8lpH7b66D8B
 3E2QcAeGYNoxD69FgeaOSRFTRztCC68g2e1gdT/sGBaLQDWyCOE7Wc+xK0Qe3EagqrrUedInoK0
 kYnxsYoTuCD2Vy98DcuILDzEE7y2wR+zvPitJ/qQISjXuxMObSopJWLHLC7TpL2IwW9t87siF12
 WSxVzSoh/WY61jRE+sFIukPOX0lW5/ajdNO9f82kLr1ClpN0w4gWQbt7p9x0s2WagnfHuovxzWN
 1HY3t+EAcaIYbA9UiLxiQY2XsW6OdFeVzQDtqysCCPM9VlULMMXh79oNhFPJMBohHmHbH82iBBa
 wpZsYSmUZDem5L7WrQU9dl0kjd9GoykXnln+2enjQTO7vP6YABTdqnCwjNOTslJNgiHr9r10tsG
 vHAj8E8cKfFKZeAr9+9N37Vq9RhNS4xlrNNIINaab+uGhkU0YFNge1h+EVHqvtcMpBf4Jb2wwqs
 kwb7Gvr/KosDfFhdl6UD5h2cHOIod/bddYSfwLB3AaZl7DyHGpq35B17sDwXSEAUOJV6RiqGfHd
 6LwaZCyFH0ivbtg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 365A740008
X-Rspamd-Server: rspam08
X-Stat-Signature: jej3huh9gq1uy8q3egtdqqkckz1ymj3i
X-HE-Tag: 1772484222-282125
X-HE-Meta: U2FsdGVkX19n6uj03nrMIQQu9J49P51GnnFEHnR58ht4hHm35QlCbF7sLkDL075D8HScb1Hn9eHkPl5/ZcMiZZKSdF+7KEtGaTK5LNcYvF920V+KAS2p0F+WFWAc4EmYCtIqiPem2Z6rQ3mHpZpe8my+R1hRRfrU4Qtf+gU1hCcn5bzzRxMZ6h1lcSpDPQfdEtPEkCK+sZ60VNFy4P+zjeIbR9/5eqHyiOhWfQOWgbTUc9bDtaiHls19oNo6Yy6J7hnrr/b0dq9/syMblPXePlbyRKtwWEQjKXkV+3muZv9MhyxD4n4oxd0u0GfOnHS5IcylcvYxiCVw6LSziE70s4ylx9bphWfXvHHb0ey/o+BXQGF6odrV2E8vymwBNaockP9Hj+3p9YZqBM7zVUqDheQU8yXmy0YZUJ2DjHdt7AKe2GFSoKdc/MIAa4cyw2Vnf5q5s2yuLgv7FtV3l1tYB+1pjF3FNR+/8MvfHfHinUVlaA1OjnA7t6fVDPHnXKOyny1FrcNxP+BTgC2+ds17mvylFxZAJ/c3m0mdJZeodZR+jzHyFZxzspAt3+jUuw5RiOzGK9XQKHlPm4d+8tolh7haTenWNSpd1/zmJcP7XyX/rwFBSvl1+OexBGkMxTxAZIQsYkHmEmUiV47rvq3LPIrDBCdZWwn58QSQLpuerPYJe6D/CFH5toI9LRCQmz6JKnctWh3uaV4McUim75jXN2MMaEpOoeOL1ObncrebXqnatMIZf4s8dwqvcnN2OGB/EVbg5avLp8mLM2CgOhFDmar4E4cLKjwSvT2yS62AMRDj7Uf6Au/9MoBB1QbMGPjUaFJ3v1wWEEBuwMiE4rmdDNO0i0xDClRGNb0OEyV1azWb3hSD9JKWozZZjpvRCUzv77Rq8BQ/nrMDS7cVyHi7pNhNnsVuK5O8BcwK427kcvoUXKYM9FmEcMAY/t3ebS1sVO74tqplje7TrDSeT+8
 VDLq11w6
 8PMBFrSCjcTEQl4ZfsAZtVVHkSeGSCqArwCXml7tLkI0PyMOThOiNY1dUVudu2FPVjsSWVjsR4+W+9v9O56tV1SiYMhlomBsZT4ACWplDN1qTQR0i4bmEzg5mKkf55U/L2C8W3W98ryABqUUfgJnMG9f7NZ0Ao5GA8l2HkTt4eqU+jTOi2xY7e9oGnPIJeWLZul7gl4dLWqRH9hiBQ2komSk0w6uJGtRiF01RLMrvRT36FEcpHdA2Ge3WzF5pMB3LnkDd4uzS8WInUTJYTmY7WeHTwDwYyu+kn8DhBvYXAfn9H5qwyzRM4HPEMRicEkUoK97d/0+5sO++Vw7QZoSnIkgWiM2YRS98MlFA59Z6gdQKBJ+kctaICjpS744Ushej+/vbEXqlH0JOe1UySBsmTVPGmFxz2nOwVjl6LmJNAbxFZ0fgLC5jr+13EccV9jXORJm/O6mN8l9xlh/tqdvkohRxLpFDAe95kSEsnF0xlDQMXaI1NUyMazvFkScMjzbuhKSaDLdjZU1BIQmhRVAXS1Qzf7LitOMZkGA7jQzYpkvwDug551ZwBThwWYqf5sE8DQJ5dyqPUFYF49ari0YlrwKF3VvJ//pijcy9lY9mgSRn/uNBfZgsN7R9veP4ed9fwCBbX5FMMKj0UwA8VQrsZqRxzbGG6jXzrQEaBXj8BQEOL3Gw6+YByIFNRGzXi+4RxcrQiHM7HcvHeJ9F6ZSjdBmb5P0aV/cVbzhXj8Clexuik4lSq8purcfN/DkzwbZGhozylngaFYITebR+5R7NvimfYqp3a4yk5XLj5GU1cyvgqJmwDs5H9phpSVmlgm1xq+tLj674ah3P2/1D4jkgYmjDeiutC1zF0LNpbRlZh+NdfgMIHcPQunFApFqKKi/F0od6d6QKFe9tqkNDpXIvznqxk5XA2d6363sT7vCxVGkad7GIMyGr7YTXtscf6QnqLWrfS4yMDGp8AvI1LS1eRhXeM5yE
 fSe8xBUj
 HGwrWnTwPczRZlRFQYOeja+ZADK/qjBYarfaeKgn0aWYfB4MvL7N+0ulfiEeuCFyyrejZBgEUalv7gvv6a5Q4NCK8n8EfeilctG56X1AegAvXlmh9l3Sx3S8ve1cHXxOIrDwLKzReEm1hS7uhaUeibTXp8qcVb2DtOtUQ4q5Fq9OvO+zJby3IzvO/uZvcfBP9VWIiRto4RC8m6wi22pmouvvzxIdE93KXeXnBdn9ZDhiNBT+r1Qw9JABu82M31loMg0Q+1K+bGVbSmHOtL2V2X0K9yeQwJe6KzhpC1q9WHt+eeQfqOAl8q2Q4iZzEu9xCObv6Vrqnrjhm7w7GrSeNeHm1yR92pu09XhtLUvxkcIAvkvUFd5vlTHuOwTw+tmf5s4FqDM+mxgFMmHBsXS9E/IRsltprWwDB3Two/21HBAj5s3MkBQA5UAcMaWVnCJnF1Zg/oxIiPXNf7ym2/tCwMjSDAOOzp3/lD9MBQomZeX0hrOoMzDcNvGnk0zDom8Zi6Gs+RPP5XLiCtnwONePE7GbjOjgDKUFbkJ/xMQzvmJMJ6IGaoLM47DV3rbXTvlKOkmW1FqRvhnK0ztUZ+O/3qeN3u0FFEY9aE3hnFztv9/0Dxa0rm0Tu52xT/jqCzZA8Sz9Xx6XfiZYYRHtwIsVSZWXu5Kg/PfQBqxbH3ACyuRmI9Vbb7ufGxs8FzaDDoXaFf5Ct4A0Af/wkMDLNTo5hQRv//P7qdL0XZvv4YxWrtrxezHwIzwAKKt1wFhst+8pB/c2jgi+KhzPFfAn+scIVqSM5zWRqkFuFcyFBtPPy+KOXa6Nv8tgM7Pxp4xJm9WzYQx9WL/GBV1Z3iBQs55Et1MTLC8b91ZrDFxtgsGYN7eC1tz3B7a4+1LpGfZImDAXSz1T4aqoarvty/+EMmOUlgZYVsfcpY4PHM4JFGoFw9hrEhKfPmnUy1Pm0ROboOeQZjyfDm9be4WEFk2S/ddgsB7OKjv8q
 i6Kb+AXC
 k/AJw0ego2Y2jiW7nJrSsdmckNl39R+EZW+0fgAwz8w9OsDRicLuPWVfZ35q+PjGgb9P1zJMZ1dpvE71vvO5dtiPF204HMg6cZb3m3jwWIizYlB9gmI5etxxLkO1nYhSIfEX1LAmaIKByavmPi1sAmQCsD4sSjBVASinRZiFaCRWdNAvXJDOL1m1z/sejZCCDXFAOgXyC/lYqNlDQ73fd04jsTRh0JmuRQJvhV5eMobfQ4ByJsnh1WGSNAYDyOAjaVW8wYyzCEjwxkukP/W8QUiutVSVBeabtPP8aV0DW2nEkVB0AvADowNDLE10sjJJ4GKd9kohOCpbKWmlSOxDsBeE9Wfe6iS4LitTFs4R1YUPuBcNflvUt5c8W1og+Co/B4d3vd0XFDiumWeogIFnPyyx9jyVUih1QuyvgSfH3xVO/89N4AsGrIs6PWwnfbolbgg0/yham/QYuond8hvIz2Wtx8WnG7L7LNiPs8hR4UvOLr8XQ6hSHbNFWB9uMWPvznmJN5g/REv2OOT1fjiLSL+MJOo/e3ifPNKhpPCjs0Bsv/k1o6YibhDEcfTR7FF/9KmjgtvqqKo0SibzLaWMtN/YxQzRoWNICw1smcIESqZm00r+29uQ3+7kEbKW+Z823j3SKHHeKBuChgPNPWHK9uxPgVj0RE3A0cLq7bhUa0Jvj3g/xeS2nGEk4nMeQN6y2BTpRkPcYQnWJ/OHew22x/r5gBQVhSURp2uWhKKnhwYZXZS18GOy3xM55xJk5uum9mCt+MSN0PCmNM6HxB4UTXY+75fPfP2f+Obpu5C2sxOcWtBo432XJrFUYdBYA7Q4iswzDCH0bqDErOomAkmz+2sS8bRj22lUY7aD02T3PjYu29Og1KlPCJTWXNk/NNSlvy2rICiflEenV3iveINTVOFMi7pvDMmeiNF0k29T/Ti/FcSF8vbMOfdr9ksYHvDMqF8VLrCP4p+/2HsQOmy1DLeYmgi9z
 47Tb/02l
 XRJfjGi4qKImyuu6lLYuySu65wu1XPEX34kBUI9LO/IkR/aupyzqIMLWawh07JJ/EsW3Z1acxUmarorRbJIGOviqDT5RILJU/rnXY2/8s22iZ+3sYtjdfARau1MEsfyzqyagsyRofTBt8tmfshD2tNUmgo/ik0zFb1ORpDufitQ+Xi4TrVkKTuSHavOfr6xhVfvQxnVZLtRv1P38VJdb5rL1mUV79THLktLGSAcCiyShtdmBou7Z2exNN3bnodPpL1P4EA+7ME/sCdBeM+2gmQsQPI34sfbUaucOlkyNW4KtpIvffH5D4VJAs82B2fW9ekQObvENWgRc0cv5rkyTMXmWj6QgU6mp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in cramfs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/cramfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 624c5ed0ceff2e4d3e964401e3cfb82154c719ae..4edbfccd0bbea39a1babd289afb1d8b985570eeb 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -125,7 +125,7 @@ static struct inode *get_cramfs_inode(struct super_block *sb,
 				old_decode_dev(cramfs_inode->size));
 		break;
 	default:
-		printk(KERN_DEBUG "CRAMFS: Invalid file type 0%04o for inode %" PRIino "u.\n",
+		printk(KERN_DEBUG "CRAMFS: Invalid file type 0%04o for inode %llu.\n",
 		       inode->i_mode, inode->i_ino);
 		iget_failed(inode);
 		return ERR_PTR(-EIO);

-- 
2.53.0


