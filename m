Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA45EF8FF7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC906B0089; Wed,  4 Mar 2026 10:33:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E026B0092; Wed,  4 Mar 2026 10:33:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A3A6B0095; Wed,  4 Mar 2026 10:33:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4AFB6B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:33:44 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 88D9A59807
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:33:44 +0000 (UTC)
X-FDA: 84508775568.07.82B6A39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C482C100010
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:33:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kbxvm05x;
	spf=pass (imf05.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772638422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xT2uLu3U2dPOQwoKuw/wYPCwRB2Co/aMQ5GXGcWGK2A=;
	b=AQwN0P1Dz0yhc8oWI+otH2u9TphdbJGnkp/x/p+G8BG4EFB9uK5XMmNOw7i1rdrQ9lxxoc
	whsmnoHzk5AcOO0RaqNnPRyTrMs7n03x9GXIDpAKO3lmLMPtHRuhpilUuHC6l83jpJkvJk
	B6yVD0q/V1iDiplna2mjKtgduWIwEQc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772638422; a=rsa-sha256;
	cv=none;
	b=JfGONqmSnlkmkyRWmisD0nGQhpD5kD9Y1n7tIlx/nfT3xrMmBBQpIRDoAYGTzqLsSGuIZH
	OonZ4rk2HVWke2JTQqAWoUfNsuVFmvMJ3gTOPgr83VsNLS/HvalFEOO6fMUsEDVRd9tTCj
	lCwEYeu3FH81R/fyDIsBl/Mvu8ZH9mY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kbxvm05x;
	spf=pass (imf05.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 24AC060097;
	Wed,  4 Mar 2026 15:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685C4C2BC9E;
	Wed,  4 Mar 2026 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772638421;
	bh=ciNSSeLqRr2BU//qa+tQIIiBFv/zr4BgDhwVpMxT7rs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kbxvm05xEkrnY8P/tRyCMTKI2dUt9lQTIT87tn/iqa5xj1Nf4RVNN4IeFKVK+/i/h
	 cCuy6DwK5kf0eHpADxr0uui0yqClmO5RzkQiq+hiarKU0R9OfrTxCwrwsL2U5WPKb4
	 x/cVNwHwTbJsERVnOUQYRWWB4zPSvs4XPwm7hmk8yYB5N0WOdQuw6QOCEo+Skehnll
	 dfh6gHvSqguhj6ATJwi/mNVwCQQzvf72au7kSngXMugLBZnGpF8EOy2i2TV7CENRqy
	 jz50pLi1cAo9FJqFzmNNlLuh7Pki4UWyeJO5/COBPnM7ZAH+6PYUsHHCQ7S8ZK9Gnl
	 4asDv/cQsr6PQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 04 Mar 2026 10:32:32 -0500
Subject: [PATCH v3 02/12] audit: widen ino fields to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-iino-u64-v3-2-2257ad83d372@kernel.org>
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
In-Reply-To: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Dan Williams <dan.j.williams@intel.com>, Eric Biggers <ebiggers@kernel.org>, 
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7545; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=ciNSSeLqRr2BU//qa+tQIIiBFv/zr4BgDhwVpMxT7rs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpqFCmqmFUMh1WlR9KQ8rb35f1AaC/6SMNRQit0
 fpl2asozXeJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaahQpgAKCRAADmhBGVaC
 FRYoD/wIBIrwGcTFOF41QzahbNDfzFpIV1/911ZWCrCmpN5O+1eeArtgs+fVyy3nEcn3GQZxSGj
 WDZ39Hlt2l5zY+WDTLYGDWamaLGGS+kuyYR2cMBfMiUZj3a/8p4EoRSUaTQuXMSWwk50Uov+AK1
 oLRlw6CiPmuPnGNbpn1YN4jSwDBtsw0Yqf1uDpc0fh579gtJlJyJWBsZYEZ1tgF4tpkEloDsqw1
 cAeE3PWIwMNKY3kM5Ly9ugLsJLpHD2UmlqV7zTLFfEHpXWsN/m4RmjNGfHS2ZMYZzoFtjVdEFG4
 yw4OnUx81ZlFYLw6Jlf7JX98hoPGdMu/l1Wz4dqebVX6JjJ8s07kW2ifdUdT4sOPRGR2BlAfgRG
 Hhys286dKG09WzHbXfCWTThcGfox2fXbblbyIsM6NprJfyLfJPmJbR/0cXvC0uMA94qtxWaJNA+
 AzqK8pog0HLa5WfBVdgYqC/PNUTGvfeqCK/DygdkbqgOP6URRThg9ui0oaDb8Xr98rM/pZGWots
 1C/rGVrQkpTfQa1osFjKA6GjXKIP6yJ7prSYAZRi9hFHwHCg+OGxvu4xldqyQ5fDMHNgu1tcNuL
 OxqY317DSUySNeD/EGUxR/wbyIFVZFpxmB0oj2j6/GMVSnZ8WQxq8NBWlbXYlmwHQw92HJz4oSy
 nvMId++sLPZY57A==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C482C100010
X-Stat-Signature: zfasjh8acpmpfxh9msnccme8cg7xf4rf
X-HE-Tag: 1772638422-651242
X-HE-Meta: U2FsdGVkX1/tsaPM7Kn1kvSxPrkUlRJ6ylBRgzxuYr6h3qh4XgTIPn4E1qsrehEKzH+GEvs99sWI187tPbF7tFNQ2quaKDxYZIdrlno44JmtEmyRH8+UAw7RsFPyoxN13gL93YDrkew5l63xgDC/yXQbESgE2nlX+y2MRIto28nLoyE0I4GhBCeXXFfXrnbe02toIuRvLpfvM37CGdlbH/S4vXZhxsIyw0PvqaO1eK5Y3lxDEWuBdZVvomWezDXiJmfeuBHLxtvOtcCaaLCs5JyETB3GOA7BJKK2CHLkkQRHvqNNt51Q5mw2niiR15DwRysla+wXfyk8eanLOqRQkL/A5nFM29mlaCxLGDO62fabgEB7MGE2gq7/TloFCy8/M0mG0lEJnX3IgPugudnqT2sfwxa+KeLtdSFc/wXzzin2oa9KRVaaUbOpEWsbmMRHoAvdlE4zOcCZTR4gqLSzWySeDeqdw2S3MEXcMH3HgY9cJzuLuiUyffFwVP44FZekUHa8NZQEIHv7EBV0OvNiGlyVscdvZlSBHGj9WSg+NUItUspQ6ZqUyah+jahvhck35OXYzCMMetVUC64naseqo+DDsePvHY06Cc3MQDCmV8EtrHNL9a3tStyslrEiFYl5t10dysoGMrb7c39NOnCc+6ANDW4lnVU9My1b4Bmq2T5YPOhjTVQ5WG2Pd+Ohcj4hp+Z4KTS/m3eEjqh3I7hUxTeu1+Ry44knbWeIpzRflJvORRPqP0UMWuPQAP+c83ge9Tr3NqudiDeV1nTdIJiIDhNsqGwWofzpBxJkN/hXecaWukOna6WQ6XZWPVA7bSMtpvbFy0GsD+Rayy+U9qa8CqrbPcRfjJe6kwf5QdCWh9saBLB3wPBmrauhbOX3LRlQjhi6gn6EDIvNS5/j9uGjeh/+k+9w+EAqcbzcEwDYOtFSoIQYRMvdEWx+ssZElQQhPtUxvGdUSmrgGlgxHTQ
 dZK54wg1
 IEUVqCFTG93M9zofEz0a22906ADpPvFFUT6IQ6X4WREiEdR0hwUGKCHBw/IXPMCbQNaPzahFOLqz1Y6nfyAAJWVrQgG6ye5K1BPdloXtCOSi1cBtMAmyXGugGvY5i5ciJwgWGnD/MEI7zLC6I/8W6zd4b3uMmfb9uxD9D7kJ2nmC0jl0o52MyI1wtHcas0kWcdHbsRREPmWtTX9th3Go84Xyx9BencBhstNS5cvs85ty5MMMDjSrqjsKirH/ntoWOV8rMvzkQ5BAzTsMWUljtTyel78kfI74Pc16xNy8mwxqCXJg7eNUyDjkJvwI5OBV0xYMRGopq5Fnkuiz0gbHcoyGwDCBAkjBCDIS1/Cydj8sqvo/6IZGSaAlS5aXDEa5FJqkKeHbRirSCI1uYWv4tUraep72+8RacZtcxTCfVjIUU+SygVcPCGhaHYuUqJ7p3zWnsv6AniH1V8byHnwPOCzzmu24i+e3Q6asAIg2FCqP+ZS3HVLK9KXJQk0jgIejo7lvFBXSnN3xwer/k83PRZr7TVM2n1QshVhRmeoIeAcd52u/4HXivt/h0srk878wbvbR1tC5OUhMwQ1x5QfrJL8GnuixYaeua4RRX+MhB2NdNM+59/GoHQpz9mL6sI05RmnJ0/KLZ+BqN8C8K64BTN2TFfiUgGH7WgnMRM9C8AKFpsAd7db4SBwgWowJF8fpng4VE4ZCof6meIQ4JLv24J/SSuOZMBpqX548f+TAn4o2rNF5yLv7IjsmheKjkkuDgwggsoX6J5Mvmko7P7YaDDJKXIt+XV0BiqWuekm7aoKoezBmpuboA5QCIFzZBj4wKx98jiyWabSsHO5PQCqDzVRqQFw0e9mG/8pt1SPz0xFIJfHoARwYlb1HM9knWY0Gy0RY/jrxDZ5ZpCZYtkqNeneKASdw9Y4k3iR0m+XbeEeD2wUoSJhJPEY/xeTIZkKI6hKTFCoIQ1ot/4lga8sWiIVFbeRS5
 I3x8eH6M
 GdbnIXUsl4voj1K26SFLKxVPZWr5GBlNgXq90NSfkotnusY3omN9UYCywxnQ07IKY71y3uJHqwKSRDHnmN1niGVY6Igolmh5T9iOYzyvAw28AGpQgxwfOmPsbYas+g6w7915lXGCzA9eWSVux0NZSSMTvLZCjpCdQ06CP5I97r1p0N/XuIkJdJHSfCJV0zT22hQkuyBFeces+wDkMw7Ec9h5gNKuZja+DlXqoJf7cXgWnAifsulPNiQ1ei7XeQJjk4rfwuKnv1f17Rg4TZXqOQ4VyrqimNnR8HS4ujTcgcXDZUM3fUYv9CPva+/YZb2vrxs5+tPinxNRz09pIwzLWgUkEcWUuLvTfe0qrATLE8SDErBwPa59wGhXe4D66lRJ+rqVFStyxe4J+UlMArG52tLvX/7fiVQ07XO0RNQt2a4VCygcA2TpSFpiCSsyhEtLf8j8pD5WGBPvROJlOjuzoo+z8+pHfbwrfZxf6aNTyc5ZOjpgI/R8z2lhb/y/tS0c9tBbPWDNhNb//6kaSO62c9KnNicVTtO/96L09TbawbDHxUnTYOD51ZAa4OsNQ/XG/+0JPZHbWN+RltXHEQ4T20tznzdyegJIKrs8SWVXjn0YY3KXvWncNr2GjIOLAnRUwbhcNDE2PZZfhRMbeLlRbDMNln2dnSXTrkkgK02iMWQTfoyDFbqE63C725DMcz1FBhxZgNyNYQzBgG4u/rKwj3T0sXruJg3r5fpZx7dcVWuQO/Susa9NfKu+J8hGw7H0AilbL+0iQrFncZsEbRVDPoxO/216LJnehx88IdiMA4sF62hINEFW3ISxKQANRA3WHgBPrw4BZN2xddhhw/YETvmvIZlRY9CCe54TOY6958gpHeUWXrkGLufMTBmrKtYtz6lXpQcZ1AQPdx2Q28O3BDDztD/Lkhi2w4PS+qJBChUakHuLXQVO/GxLzaMLC39oKdLWbPtW6m7iPZnEbUe+8tWRRYpqT
 yY5PP7iI
 Gv73KoD85mmo4ZUiXtbe3df2cB25LP47302kiEreCbkWmJS/RQT3bQuX81Ijps/smN9jy/+DRvzXZGk1jVV3YWTn4duhTB1bNVntgLueAUKCFQ7Ou0EG6XYrEvo9eyiKL85l0Y2bushsY/uc2vGSQ31vuQuJhxX6VSkSFDY3kb4jLeBlIN1CC2y/cYfTqM/ZyEL1xtptysqh8/44XHeALM+RbdC5y23fWHoi4pUGzMO3cyHEyD8frmZQCrKXdilcjaj6kFqfC5I8ju2Om3ctAyH1WR7nm7XI8EwsmuIKn0+BW8NGOfeBKQSeau8PzAWLrJI1QSBPzoNUR/RsDvOtMMpYmFNNwBKJ/owbLGGxDsMqAeAO6tATH73IGeJZEwuwX8GT0DmKXfY+WX1nprcDH3AhhtCqclQrsXyn1yvEc0jmAo9MJM2v0dmMCXb+UmUKQpXBng0Nse2P+xSd4FnVTjMzRN17z21ZsZG59zeifDR7EDAHE8T2gMGkuI0YThf196PBypJrN7uwx2sg5qP4OlCNohJ3JPht19+B7AWvdlA1y/J/zoJlE5mnyuk+ProDNRGGsocbKHdpv4nwZ6c0ZUl6CAV7sgjNLTnAFUsSvqkCXFpwDxprPJHa+oSGrMK+JgHcZ5/PK7Yl7HcfbhAgl+HgWSbqEK3/CUpj5MiZL6JsEwAprdpdPsu2/UkjkIN0DZeWwLd438oPS8evcq6KBoLfJpsksxkXHyGwnfh/bibUT8dlytUNSF1cCCYHMXQ1MoHXcOLley5ZITNblgYAKWAF6+2T/gZL24Fbv5mWVAM0s8+WgZC/W79DUJTUW+s9pll07+GsqBOX1oxt9xClzU/BF+N50iTp4QdMp1pYyatR03BJNueN3sdvQ6fK32cnu5KyDnj3w9yMTyh/QCcioF9waIMGu1Gcs0KNgFHRH4+d1FEU2/kyDVlBs1UkitGyTALaTNHSqWfZyF4JG5hXFvVdS/rK9
 pnLZiuSv
 W8DRXZn2KbKJUKhR/hAOEpryVaolkY7ZaePJMsTblilEbGaJ+Q6FEiwqLJ22Rizt5MEbMTAGtm6QjRftj9yQTqEnZRnATHZNyRKDJX1IFBIjq9AmI3bmE9QeDbjsTcquwakIWXAcYpIhDsXS7zTwCs7FZAEnQ929gi5f2BO8hay+01/wRuX1kgYbkx3Nt/stfZwzNLJF2q8vJfC/YPW4AEjDmuxj2STiw+6gGBXvSz2WAGgfmThV1Fsbm+EGiSZJWttYFS76V71wjXVyYO3gbCTfEjGR3p7hITG/anCEO4hHy0ysZ86Jd54YzkuHentzZRhssg77SpoOxbgyAFr0rFpidZWA049U5SjdOBn88ktIr1ShFLnUxgC9BevRYQEd+0Rqm0HGMcJIU3uy/i5XBe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

inode->i_ino is being widened from unsigned long to u64. The audit
subsystem uses unsigned long ino in struct fields, function parameters,
and local variables that store inode numbers from arbitrary filesystems.
On 32-bit platforms this truncates inode numbers that exceed 32 bits,
which will cause incorrect audit log entries and broken watch/mark
comparisons.

Widen all audit ino fields, parameters, and locals to u64, and update
the inode format string from %lu to %llu to match.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/audit.h   |  2 +-
 kernel/audit.h          | 13 ++++++-------
 kernel/audit_fsnotify.c |  4 ++--
 kernel/audit_watch.c    | 12 ++++++------
 kernel/auditsc.c        |  4 ++--
 5 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index b642b5faca654c8465b6839c32b633426e1d3d9a..b915aaa7ed7399a6e453b1bb9bacbda686028638 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -15,7 +15,7 @@
 #include <uapi/linux/audit.h>
 #include <uapi/linux/fanotify.h>
 
-#define AUDIT_INO_UNSET ((unsigned long)-1)
+#define AUDIT_INO_UNSET ((u64)-1)
 #define AUDIT_DEV_UNSET ((dev_t)-1)
 
 struct audit_sig_info {
diff --git a/kernel/audit.h b/kernel/audit.h
index 7c401729e21bbcb062e2d5f3059d4496ed83529b..ac81fa02bcd7501e31461a346c4e599841525001 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -76,7 +76,7 @@ struct audit_names {
 	int			name_len;	/* number of chars to log */
 	bool			hidden;		/* don't log this record */
 
-	unsigned long		ino;
+	u64			ino;
 	dev_t			dev;
 	umode_t			mode;
 	kuid_t			uid;
@@ -225,9 +225,9 @@ extern int auditd_test_task(struct task_struct *task);
 #define AUDIT_INODE_BUCKETS	32
 extern struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
 
-static inline int audit_hash_ino(u32 ino)
+static inline int audit_hash_ino(u64 ino)
 {
-	return (ino & (AUDIT_INODE_BUCKETS-1));
+	return ((u32)ino & (AUDIT_INODE_BUCKETS-1));
 }
 
 /* Indicates that audit should log the full pathname. */
@@ -277,16 +277,15 @@ extern int audit_to_watch(struct audit_krule *krule, char *path, int len,
 extern int audit_add_watch(struct audit_krule *krule, struct list_head **list);
 extern void audit_remove_watch_rule(struct audit_krule *krule);
 extern char *audit_watch_path(struct audit_watch *watch);
-extern int audit_watch_compare(struct audit_watch *watch, unsigned long ino,
-			       dev_t dev);
+extern int audit_watch_compare(struct audit_watch *watch, u64 ino, dev_t dev);
 
 extern struct audit_fsnotify_mark *audit_alloc_mark(struct audit_krule *krule,
 						    char *pathname, int len);
 extern char *audit_mark_path(struct audit_fsnotify_mark *mark);
 extern void audit_remove_mark(struct audit_fsnotify_mark *audit_mark);
 extern void audit_remove_mark_rule(struct audit_krule *krule);
-extern int audit_mark_compare(struct audit_fsnotify_mark *mark,
-			      unsigned long ino, dev_t dev);
+extern int audit_mark_compare(struct audit_fsnotify_mark *mark, u64 ino,
+			      dev_t dev);
 extern int audit_dupe_exe(struct audit_krule *new, struct audit_krule *old);
 extern int audit_exe_compare(struct task_struct *tsk,
 			     struct audit_fsnotify_mark *mark);
diff --git a/kernel/audit_fsnotify.c b/kernel/audit_fsnotify.c
index a4401f6510608119fd928944c36103326475e3b2..711454f9f7242847f78e7eeed92db7a66be265e6 100644
--- a/kernel/audit_fsnotify.c
+++ b/kernel/audit_fsnotify.c
@@ -25,7 +25,7 @@
  */
 struct audit_fsnotify_mark {
 	dev_t dev;		/* associated superblock device */
-	unsigned long ino;	/* associated inode number */
+	u64 ino;		/* associated inode number */
 	char *path;		/* insertion path */
 	struct fsnotify_mark mark; /* fsnotify mark on the inode */
 	struct audit_krule *rule;
@@ -57,7 +57,7 @@ char *audit_mark_path(struct audit_fsnotify_mark *mark)
 	return mark->path;
 }
 
-int audit_mark_compare(struct audit_fsnotify_mark *mark, unsigned long ino, dev_t dev)
+int audit_mark_compare(struct audit_fsnotify_mark *mark, u64 ino, dev_t dev)
 {
 	if (mark->ino == AUDIT_INO_UNSET)
 		return 0;
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 096faac2435ce2b3741fb1f623ea7fab65ae7a07..33577f0f54eff1eafe48a94dd2839b00fe7dffcc 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -37,7 +37,7 @@ struct audit_watch {
 	refcount_t		count;	/* reference count */
 	dev_t			dev;	/* associated superblock device */
 	char			*path;	/* insertion path */
-	unsigned long		ino;	/* associated inode number */
+	u64			ino;	/* associated inode number */
 	struct audit_parent	*parent; /* associated parent */
 	struct list_head	wlist;	/* entry in parent->watches list */
 	struct list_head	rules;	/* anchor for krule->rlist */
@@ -125,7 +125,7 @@ char *audit_watch_path(struct audit_watch *watch)
 	return watch->path;
 }
 
-int audit_watch_compare(struct audit_watch *watch, unsigned long ino, dev_t dev)
+int audit_watch_compare(struct audit_watch *watch, u64 ino, dev_t dev)
 {
 	return (watch->ino != AUDIT_INO_UNSET) &&
 		(watch->ino == ino) &&
@@ -244,7 +244,7 @@ static void audit_watch_log_rule_change(struct audit_krule *r, struct audit_watc
 /* Update inode info in audit rules based on filesystem event. */
 static void audit_update_watch(struct audit_parent *parent,
 			       const struct qstr *dname, dev_t dev,
-			       unsigned long ino, unsigned invalidating)
+			       u64 ino, unsigned invalidating)
 {
 	struct audit_watch *owatch, *nwatch, *nextw;
 	struct audit_krule *r, *nextr;
@@ -285,7 +285,7 @@ static void audit_update_watch(struct audit_parent *parent,
 				list_del(&oentry->rule.list);
 				audit_panic("error updating watch, removing");
 			} else {
-				int h = audit_hash_ino((u32)ino);
+				int h = audit_hash_ino(ino);
 
 				/*
 				 * nentry->rule.watch == oentry->rule.watch so
@@ -439,7 +439,7 @@ int audit_add_watch(struct audit_krule *krule, struct list_head **list)
 
 	audit_add_to_parent(krule, parent);
 
-	h = audit_hash_ino((u32)watch->ino);
+	h = audit_hash_ino(watch->ino);
 	*list = &audit_inode_hash[h];
 error:
 	path_put(&parent_path);
@@ -527,7 +527,7 @@ int audit_dupe_exe(struct audit_krule *new, struct audit_krule *old)
 int audit_exe_compare(struct task_struct *tsk, struct audit_fsnotify_mark *mark)
 {
 	struct file *exe_file;
-	unsigned long ino;
+	u64 ino;
 	dev_t dev;
 
 	/* only do exe filtering if we are recording @current events/records */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f6af6a8f68c4f6d14d9a899934138df2036e1f9a..ab54fccba215ca61d56335d1a22a7f26297e28ee 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -886,7 +886,7 @@ static int audit_filter_inode_name(struct task_struct *tsk,
 				   struct audit_names *n,
 				   struct audit_context *ctx)
 {
-	int h = audit_hash_ino((u32)n->ino);
+	int h = audit_hash_ino(n->ino);
 	struct list_head *list = &audit_inode_hash[h];
 
 	return __audit_filter_op(tsk, ctx, list, n, ctx->major);
@@ -1534,7 +1534,7 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 		audit_log_format(ab, " name=(null)");
 
 	if (n->ino != AUDIT_INO_UNSET)
-		audit_log_format(ab, " inode=%lu dev=%02x:%02x mode=%#ho ouid=%u ogid=%u rdev=%02x:%02x",
+		audit_log_format(ab, " inode=%llu dev=%02x:%02x mode=%#ho ouid=%u ogid=%u rdev=%02x:%02x",
 				 n->ino,
 				 MAJOR(n->dev),
 				 MINOR(n->dev),

-- 
2.53.0


