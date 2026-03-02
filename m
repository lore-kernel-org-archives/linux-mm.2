Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F89EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00A46B0161; Mon,  2 Mar 2026 15:51:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4926B0163; Mon,  2 Mar 2026 15:51:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6CC86B0164; Mon,  2 Mar 2026 15:51:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 953026B0161
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:51:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60FB016032E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:51:11 +0000 (UTC)
X-FDA: 84502317942.19.38D1AB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 890F610000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:51:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ezajfXsx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMnXjX09cpgAbbnvNzwPBaBnYdpvcuQuDwHRdLD5uSo=;
	b=YC39mVOD/i1gepqtKsihh4Jrv9eRP8pWZBL+ODXcYZhQUWTCj2YzArDnPMVEdTUDI2EsmL
	gwHR5vdAyrVILld3ZuSd+B20PWljvHAbYrrBtqywBQlUvZ6bvDvt08i/ESYdmENMEdsx1l
	umErC7wraXunXUo5ftG/esJtIcEBS5E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484669; a=rsa-sha256;
	cv=none;
	b=qopA3Nl8JfZElvl/eisVR12QwHoETiDa9iSwtvMXvSt40iaserp9QvC4v6HxW602YVy5nQ
	A8N8OlEDOXxe8MunboBjQiSRmr/PfTLxx5Wrc2v9yMk91cih3GXJE9BN8yn3pzs6IR0L9H
	LgG2v7So+Q3eiSjXYfXQFgv9j54/nfc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ezajfXsx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D546C6013C;
	Mon,  2 Mar 2026 20:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E3CC19425;
	Mon,  2 Mar 2026 20:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484668;
	bh=bh/9FqQ+zYZ3KRPKzQcXTHwDk+54O75ySXqKcS7HYvs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ezajfXsx7jOzzXGyYD5JyoqhK8Em2M19Oms4vv5wm8s7gGd1RNIG17dLJ5uTr+5D6
	 13XlSDniCDt/7J/ablb2gb7iBuW/Oox6Ug/Wbln6TdU5pjRwg8QqUZyvUmWrrwzdzh
	 TdPoePjqX1wISY5ACwM75XnPKfo63iKnsAlgsvSfbHZnf07XlHfFY43qEpxpxB/MWl
	 zscDqCe1CnjGQpXdKoCAVl0e8woVX3ioo/6Qwmd9fITJqR2AokFIdtHXdns/BkdG0u
	 8tm3I731Q//Wx6DIYlJDNlt02wCFczoInqoYaDkiI/NtEl1kCXQ/RPXOqv4IcIOCPv
	 17eeYGfWCbmqw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:33 -0500
Subject: [PATCH v2 109/110] uprobes: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-109-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1475; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=bh/9FqQ+zYZ3KRPKzQcXTHwDk+54O75ySXqKcS7HYvs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfINtFesBvHoVALkwuzaop+mrk5+hHLUhRkav
 SbiQ5q2EFuJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyDQAKCRAADmhBGVaC
 FaifD/93wgaFohJzMv84cczGy5tqsiSQqVwg9N8IAOpIePJgt0kVY/+xJf0mgMpNCnwO6zNhsuS
 g1IOSlsrTR/MJcpKIRNRt/reW3SdqaEBr7CdUBnbzbCxAGIB+xu/HLgkHB7/xhXL78vuqw+zKnn
 JWZDTxZoLmgiBqPUS8UuOWTjTgkdOZ3zJMEnhCZsH/bvVaqe/Rx87GvqY9JB1vVpsjXluNfRHKK
 wnBcICij2U5zjwQL5pknxzyX+HmPY8260HO4DpxpwCbbXYKu4ZWIJ/0RD/8Rxnqi9RMgWONvuJK
 t+OWOpldFH4s+VBc2nkWs/1iRttLrxwAIoTe727yA+1RDN0kDcWgo5OKw7ETerM45p0uldTJJZz
 +b+0XOeGvsVl2qkZ4+XzpPZhUWp47tWlf1PFhlW8GonbWOTaJNdK8qvCFr3zuvsSmJOiG/+rg5Q
 B2j6heaXrv7KtI4KgpYSMyno9u5SyNZcSqBZspBnXgh2tJj5aQYIxuCDdbq0L4shZAGYBclkCXT
 A78go1uY2C0RpRjk/L8MeHCIPpy2rSoZDGJjUO/g5YlhVBfxrWaCv8yPvr9+APQpC0tLwYTEh7+
 RFM6hW4wUjX/5fMwwSL9Dp6TWTKIc6GW5tTG3pc5VAzwgmOaFPDsLKARdA8RqzISSskdsOHTFvR
 wQa3ZehRJTPIiiA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 890F610000B
X-Stat-Signature: hc71zkhdoi3c8sxkaampkxudf64phqwi
X-Rspam-User: 
X-HE-Tag: 1772484669-195396
X-HE-Meta: U2FsdGVkX186L1cp20/y8qhmkkv+s/QRmCJWB1/yUcKIQcz5e9S3AH7NdZUkRr5YIE0Xd+lHIxD0usGsYIGO0BuxTo8Zy4blmRxEcpTVCey0dCZAqhAGsUEfk91CG93pr9Go44Rf3lWtNYEiBe5ovNK4nSCIQB8tdGKminKVRo7L5MkBVV2BTArmhhXpLRoIqKOvIVXpCyDZTDP3ZuTthcQyGEG+Ukf5gyVQCK/PUsSzBmVmoLScClGnY/CSRfcuZq/jnDllCaMq1KliP4j2QSTFbcrOjSNrbYrWvkwBLNbPWW/gd/V/uRUJPS1le/3yFkHPl2xdmQVhby+Wr31AE7JE0w+O2GKSaZKcEm2tdnHgj4b24s/c+fsk/GUCNV4/GdnFJ5FHwQce2DuDVcR+he4U56WQGD+8J6dTAdwLo612s5/BMQRCB8mB8czs7UwpjtNoGcn14CGSvnhHS4ITkEbUo+8ut3Fxi2l7k1z4e//D55f5ab5znzh9+w6PHyFE18TuP12vV87stm99jJGpmVlnn8fMOH4qYOiBV35gwS6cj3MBCfaBx5f6kY1xQ30+4t58SjK6dqXAwbmT+lj0InBwOcjDDpU3BvdMHwdo0e/S03gpCVo3Ci5+vvO0aPN1pvR6ToU/pg+ShWPTHut//Txr5Zg9+DLZphor2gRttuT1D42+fYDOhYgT1hr8tcCFFWsKMS4sKub3jEqvYI1/PYvVJM/3k//06iDVXp7cCZuzYscisDUaPDtNGe4MkYVeRemLkBOTEPbvdRKe9H7iC9AFQKpGUN/7Tp3BWXW5Yh+x7KARYyNyU6uy9LCmcxSwrUg+1XPsyrwpB01AKf7Aw8owFxxEmWNW+IecFdRKa+vYr/7dBwH8UHVgyatwnWuD/Swcvvj8DOux9ZlTik9LEcZpDMb3eV1JmL8YCpu+xPmGcF74Ge9tsferVCYdhaDJdy6Qjlg00EhYA6TMGFu
 t8Erl938
 AxbD08NQf26NtO4x4s2Yxfhge5NINcl5sApMlzIhMX5C6lehnllnube6MnKxBUK5n9btbkX9qhi6JbZv7wPz2Xz4/XhJ4ybSHsJCBwjLlHPsjoYTsh99xYhBPEMC8s+EJdXByONJRYcuE1u99VGeghjTPQdiKtzAgp8ykV9GF8lf9mbfvCiwPwESYxEqbrpVhtstqYHLW3G7UvETaQKs0dP8p6NFwKrQJqqNEPZo1/+1mwUzQyvqW4mvGM41MxKv/q8CKG1JmqqVfLEOWW5FfmxF7ZXr8LUyaDrFFfk58eTit4JjlLkydNJdZYr2RP5lrMCQEZ7VLWBfG00BS6+jWYch1Xc9ZcBeRmInKrNrdqC8dbz+iuEQVBS6AbqccpvONyEqI3yu03V4suvvlYnCRxrTPki8S2p2Y0QSw0d9k/urelEZrftoNSXDk2pwh/teRzpwAuHVKrqwQmhTAjD4VxWC0h8bATcq1pZN2F58b4F8UzCLCSU+xaKD1xn/BGH659z2U3tfU2HjPkxDc6aKbhhB/8dVUzfLJQKq3l1VOfyV+1nCTtqjVkYYyJhgJI2IlI7kMADChdVg23mntS+1m2Rrzm+K24VfGEwZkLI/FhBvQl2ACXKdtP3uqXMwryOdfVxZEEeHfwdxkYHXLv8Oa99bTrKHifp6Iq+R2RMhLgr//koRvC8at89mchA0GXsGn/Nvy36J6d02D+wnyPhwwwwpS0NY/TgV01JO2ehqMHSKFWiL15rYx63VGm7+MTdBG+s2d4ulYAdkVMO4vCK1fkbsXh54A5gNMSS9dNCPBO14ltbCwascM2pxvmdYzQpknG0mpFlwNhdf41uXntGw5XUU/fOB4+1KEgR3giKAh2c8PaHCghS8D/HUs6mz6C3FA6oxl1dymt9LatngR++76u/Pgqe7sVSUNGwF7UYO4Y2un0fZNXxX39t20sHtBVx1ICQnUy5ecrGypJgwEoEsp6JGpyhsH
 LXo1wkwj
 l6iX9aWAd7sFnLekMQc8Pm8y3YYoFAo20JO4+gRpW+4EFQCM8HGVhETD9vQ45lDhDadxC2Caw83AZSnJpLz7WqhPWcyq3psKsG8n7RSN55ZLIKz/9RyKgeQWnYKgJqjTD4lYBSbs1FpPlj2eRShctteDBLBfc0w9KD5WQ5T4az3FS9M68yph1r/tElPgCXcZb+qPTkr9vPOGmXcwEjnwO5NsceWjs6xTi4inMiQ1EkXSmu5RnvFfJyl1uIhOrY/Kz62qQxb1PiujXMzgE/SPNrL5VtLvReVFvG08yti5pR1Sc3j18OiEhvaCvHz6Ao/HnA4JUoAIc4VyvSI4EK+/hyTUtYlkT0r0RhI1FiL3fmCkx4BmIjv0YueuwxUqt3PA+wCKLwgzVWx3I+CxFp7AqSwAkdr05nqfpm55Nbk3jq/J3a3czeaqOsVkvSKXQ0xG/EoEMBj+6rnxep3TMXnJpWeWQLRpUM6aOB03JEQjmiFwCtkW5iGarnP/14QdjDmKbmP1ZKewXXKLFmnwanCgEbn/3wRVaWG8ZY0c/olf0PgHvg8L4j9x+yCPosxjJR6Vdebnr1/Sl1Lf3Tcb+DujS6GwON7d/hKKzLHhiEIsotnNezbR15I/DqoVw/BF+ZBQedFWrIxZRvYkkJg3thlgc38NJddzglGGwgBftAomSHHBKU93gjtigRVcjf5Shk42b4RL4qEd+nJogmQ6+YlB0tmUh9id3biViwIpZxxFdkxBqBTO/7H2acnFqAeDmea4kgEpS8rX6mAR0MNAQLdRYiy/tOmpMjCZF4C6gLyvhxWVMzqdqwwHBMsgviSNB3kKwOi4ZQXBHPWOB6pN8aKKvoIWC0EHNjp4gKsvJvjhnRjpejMVUaCdGmjDltePLooFT0k0zirlt0Jrqs+bLRWVRCOeZraw7stFaZ33QpwyTFKVTTrDg/61WBpO9fjh3WoaTaF1WSu40mYS5awWpvk9+gX7Y+v0v
 y+Xf7mU/
 pgP24/eGI+IRtUoyyJr5bJVx4DH3Ht+oWpF7hVboIYIt2lf7w59ZK0Xop5vIx2/5jN2HW1t8lpv5Nwu0VPLeSQh53TD+9qILwk6LztLvPTpJ361k9aK5Sgrungmy8oEbYLocgkZpWPax8q6opu3bigPyfMn/PBVIHZn85ny+BuLDlUHNgL5v4pOir4FVM0tC0vcZamPv8C601eqliDkNFOZ1rWZ3wza1ZY/Hm9nccoVRBL1b8logqm1V6huEEdq8GDWU8qcWjcpVrLYQVnvBRtLNPozDOcxHnL/OIuxWoYq8j6Se/RXnTFGzqlsmOfeygpKhAUz0PkhU7n4vY7bFSROa6trFC+i2DEH89OkNXJNqLV1XcB5mXDb2JEEgc7GXv5Y94Gm671740KRgbYl1uKjyLG7Pufbi3zXJHDXYbzZpEQFX2/TIN6zEX11DBmr4SIqQJXQYoxABz1WvpB5V4pP1RsRQfw40nm+6fjtlpfLi+Sm3EW3duvz2poFqvQe7mGahfoKats30i1wjWAhArLgXy26UB0ZkAgTszvQ3jVHXzgrmjoAxsH0sTMmZUu57iZZMEgVkspDwqCIhmW8/B6zBRqFYOp6ru2AWNudTZ4MXQf5O+IvbseZerdSIlrvYq7C8ESc3gwjAz7LELhsGiJh9toW1LlzaKUhkOSQYhaOJ1nVVlxwsqX648inv08BsiwJUAKKrHzsxaWWb3Zd6rAYVBzCHUKA9yQG1svxrpEKc1+MWoKjW0O+qNColA1dljMh9rmGuaN6tgfSvJq7IYoRXjNVB+Y6EhbqQd4T43h/LjBwMU6OiNCHy+ZuK3+5ZHRZsj4vf/YO83ZCpqDmtiquu5KD8Fi/zDHngp7XBT5aO5mjE3B3r0pC37rHsNQTefYw9UQ3REWyEJ/F2YU/GfEI7OvGvNFdvNR60NMrqLXpt6Xb1vcwDkWrYNm0qfhC9Vmu3g1vWdfOZqr9cQLMRLbBWcSaHj
 tfSAyTed
 MAYL8RTaCjtxh8XlTHbfZRBcNhj/eFC0cRjnC0DPHFiyg5SRef6WffJEsi8sKY/qWP9KINtfGRcYsforHitLk4P6CHos6NUrSXJy8+ctVR2XH6hvbuDrIgWK0LkWvhFi6h2cmO7xTYk6OfhaulzkO2/cpnNJGJvgW9yY5ufgjfgKXyyHH6qceJElAbS39JImg4yiUikchG+eNNTyssy2FaHmEryXkYfRvRQTBOpBYT2nXWEL1iFDd84AjDWd2/HEfhXUx3igOeW1+SSGFYwEe+Or63/iAFjji5pPEYfT7YP4T0yDJ15CrXehCL0wQjTJgTP68/yXaYK1bdxuU+e4I5rP/3Y+r8cIGfHl/eYKjMJ90nO06lPqiqW7v/BfXv1oI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in uprobes with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 kernel/events/uprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index d5bf51565851223730c63b50436c493c0c05eafd..4084e926e284487ea7e28b63721797b20f0dfefd 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -344,7 +344,7 @@ __update_ref_ctr(struct mm_struct *mm, unsigned long vaddr, short d)
 static void update_ref_ctr_warn(struct uprobe *uprobe,
 				struct mm_struct *mm, short d)
 {
-	pr_warn("ref_ctr %s failed for inode: 0x%" PRIino "x offset: "
+	pr_warn("ref_ctr %s failed for inode: 0x%llx offset: "
 		"0x%llx ref_ctr_offset: 0x%llx of mm: 0x%p\n",
 		d > 0 ? "increment" : "decrement", uprobe->inode->i_ino,
 		(unsigned long long) uprobe->offset,
@@ -982,7 +982,7 @@ static struct uprobe *insert_uprobe(struct uprobe *uprobe)
 static void
 ref_ctr_mismatch_warn(struct uprobe *cur_uprobe, struct uprobe *uprobe)
 {
-	pr_warn("ref_ctr_offset mismatch. inode: 0x%" PRIino "x offset: 0x%llx "
+	pr_warn("ref_ctr_offset mismatch. inode: 0x%llx offset: 0x%llx "
 		"ref_ctr_offset(old): 0x%llx ref_ctr_offset(new): 0x%llx\n",
 		uprobe->inode->i_ino, (unsigned long long) uprobe->offset,
 		(unsigned long long) cur_uprobe->ref_ctr_offset,

-- 
2.53.0


