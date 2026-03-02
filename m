Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F7A7EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF18E6B00F3; Mon,  2 Mar 2026 15:37:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E5D6B00F5; Mon,  2 Mar 2026 15:37:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53A06B00F6; Mon,  2 Mar 2026 15:37:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B40416B00F3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:37:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 739E6B8253
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:37:45 +0000 (UTC)
X-FDA: 84502284090.17.0548CCB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id BB96740014
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:37:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c/9X266o";
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZB5iPUB5KNgzdYAvm0sWeHofJHpy86RKVW1K264/Jk=;
	b=1tDXb0xVgG3CZ4m3NVrdZ6s0DhVhth35UBfPOyZwUu5FQxUSeF9fhrV5fRgzxzTsEDu5Nd
	D2Kn7Exs9yiJ2tj/Mj6XQ8H+mZllMbIErWuuo6xpI/icP+zCvJq0vvcjRXbcSgW8HORXRY
	8HDFQymiA32GK0GLBwOYJB1uSW9Cs/U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c/9X266o";
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483863; a=rsa-sha256;
	cv=none;
	b=mrgcRC8mGJU6zl70fOkgz+1TVnYD70vQYo0lmn3GG6gNGvFVrYEh5JAOGbHIhsTnTcXJuS
	xI7ZuvptW9muV/ZIwxrdPMRS59uTYaGzBM380gaF0TGZSLFFdTYYFzo59j2qd0CCWQlmTM
	9NqFLlgFOUYdPSAkgwB881aMxJN5/9c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BC4B6013E;
	Mon,  2 Mar 2026 20:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5093C2BC9E;
	Mon,  2 Mar 2026 20:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483862;
	bh=fGYHXlsbo3hX+sj46S1AiPXUKeQiwqzfiJrHDisSkHY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=c/9X266oNOfvKAvPFmZGiBXLStP5cBXK0Dp0mJyjQEeHjqImF2hEL5wpLYtcaUFcw
	 2sC0owKXlvgaZa5sWulnQuOCpp4CtmHNQds98lbOD2Yc1Il/Drz4gKpPzn21zZd9VP
	 HebEipWl98MlWo1FiW0+1kLGHSXoqdAkY1+SICHjyLUtlZiZIGYgOm06vONwEmE9v/
	 FBnsJ04VtuxHXf5Gwb4XHQpyHl1iOnlDJTkIbIBzNRsylsPuJdTlc5BH7z4MTjE3J2
	 qfTS80KOfLnK4Iav6vFw73aUFojUrfUSEZwKTH9BaNVj1bF8aUXr2R/vVacChhuNK1
	 9bDJbs+kDbGrw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:37 -0500
Subject: [PATCH v2 053/110] uprobes: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-53-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1464; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=fGYHXlsbo3hX+sj46S1AiPXUKeQiwqzfiJrHDisSkHY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH9tW5Nkdlwch0QiCW7vQI7VKCIy7wElai9y
 ll7ocJEhdWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx/QAKCRAADmhBGVaC
 FZarD/9y54Q4L+jetMNmFB+qs8kAlh2TWuAHEq5hwBxHmBX7IVgfxOu88FDR1I00AXN5QfiePfD
 O6OFcz5I4MiPCLCBJBQPz4Q9C1ZIpBw3oMbpJDj96b8eyV5qhbHxwhhMJWjVnz2ZdBXSMlcoilq
 xT64Mf4SnaSaZ5qqDJonVw2sQojOYQPj2jyv1Y7MjqbdEl9cP4VwYpYWCUrlacGaDPNYdQDnvv0
 jnkGFhH804OSUuCW0QDL1BrL2BKWEQ0DEaQndw9rEvommzO9vPfIaIrN4pifQrPpiU5PG3eLaH3
 FoqXQQ6Wn/huK6WATaLKmvAdoZH2uWOzdotg9nis2NEB+MkciwWQn70+O5oiln1vfZDg+dEgRVE
 MAXLiNymeViZ4KJU/IhQIZMtGNQua2Rf/vFL8p9tagtZWkuLlWFclZkXff0hABRJFfEPVkRIK7y
 H4z5ar1z9lRZXAYBhfJJms7RYg9lN8G5/TC7SdOJypT/eapE0gVHIIe2H/3/DV6lx0VPJPG7tr7
 IVlUN+zyvxD/xjX8JzuowRkWr2TYrIz6kNrmMiS+1mVqwAhW5PoPELrP3ywc1RLKdDz1jCP1p96
 aZ8yYfF8SX2pljfP84I3kAXfU2nYgdVofWDZXxSPrT5YacltotUUtPJDc8pJB0215HikbZacWff
 HVnb+5hitlPg+Fg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: BB96740014
X-Stat-Signature: sh4gx9tnnqswbdtee4eg9b7r4y17d5ki
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772483863-878454
X-HE-Meta: U2FsdGVkX19qBy3UZmwsvZAWsQK4Lfx3xned1k8HI8j4kj/Ex0EzNuYnfdvzV/q4RuVt6VX74QYRkJjI4y3F3g6iGdjl1nAvRruhaqDKIggGWqwNJYCso6lylT6NXGWobgCaSJnkFat0i1wquzxCsTXyRy4O8ExbUYP4JQvHr0qOTppzXFemPXzpR3FKgQ8GemLVQvkGzPF3QGulHbdr+eopI2WxzWixw8mJ2r1FmPq5DM6bcu3CvD9Dz9J5rejW6xwLsotHo4kqI5iQKXI26mMhx9M8T6EjctJ2lOvjlrkd7P7dxa46ly0Ni13eWT13NsfTMon/fOeEuvwPBhrBRoa3SKgnoJXiVUif8LUZ7lERV1/3Qthk/HDraVcKmX/ety/c2FgJQsLOnB3IMMtGM0B1Ychh+XVZx3hVegqkyTcUj7jwgNpCpCy7SBszzF/3ZGonSInjfQc5uCkcocMckF349m9Rr2Wrkl9xl66bXqUXQ69cM0RarVY+I8UOwzhxmgOHkJ8uXK6uvRyg7n4VfsJnsa+wvaFalvluHdt7tbz5uYEAEj8NFABLTN+XgBd6OyVqrhA1g/czeJZdrZ241TeGSk8W0LBiB+jnq3vgCZfLOhgopBDmUFLrNvzbx98hpbyVumyL6X+5qodhHHZ+zxmaeKPpTR5oiaEHfvAsqHKPW9O4CNhu3yyQ52xs/Vvh217wsRteDtKBjm7svGMaMN/l55u5GEaaRFRDl4AEgcNMtOrJhcPaOAFM/GEKBXZnfkuNaWlPKHa+tf1e6fKiWemDfaKCSOkRZudoF8sPb9lPMmpNtRuFPqDWWr7BHz99quOwlLrNl74M8Eg8PA7dp8OXkxVWGZeaQmDK3PwzaucsAnSz3M9m5qxaLx5JUsuMmZZE2WOtG5P/gxNq1KdG1WyJCsltnZ2cCYhlxOvqXBuWsQD1YVPJHbGvUHYZTSC34xkaxkZ4RCqGCrc6Rz3
 TCez/nny
 aI9ATCbphbUdcCJ7KvdmMJKHI6dZjDyYSTu/i5zSr8wIMeOhJP0HCitpMOHPK3vziKVRhiPBKDGMbDNqtPxYJta/fWTVNKZMPuDgE5NWWwDn2HO1t1jgWk6zcJ53iJb95uoSu0emn6RgCTFuSUH8P0KJjhLNwIxrgGT9yPJto8MbfolbdRAHzJoJacps9+KeEjpOyEPwzF1qcwJUMCXCfuoALI/MKfkmcYahj/vjyHtr4pHfiRnQuATVHJlIhrO9eyNmIbbmzO2lXZcazCt5qbX6C2h+PGfzs8xZWBBlkv0j2PkPNYpO5rh/wOTp4LoH37yMM9fEQXvLVb34kqsU1hJT2YwYWr7zVCp/tVpxAWrq8DqvYmn/jMAmmeINb2I/RSTfnqIDOf4bMYzkUPqbpmlgu8XH0hOdTH97CgXxse+EHxAACfmVaMNtzRVYYIqHVsY3NwxnlA8kndt9Dio2MT+9CPZGOyYeJCSSotOGtX9x262y6etwnHKTlOijmosSefB9akzql4Nln0Xg5ruxZr0misks6RccbKMbmYjrtZ7oeU+TBCXvqEPfIl8S/JUFqLYFn3pOzUao5GvUO7MFC6F9PxG8I/HgFdGzYiqop6rY1NV0T0DWwgFVoARhuMssMECyEBMw5CiUx/TTb1MR/xIv8YZwktkEu0Xii7bzDtDjYIIW+5VxbYY9DlmeTDNFQON7OWkzrkCUa6VPzPjZFua7n0jHRqj5OBlotD0KkrsxnEbjFonMGoWfSF4RZ8UcUFZDi/Uny7xb/cCxqrsTWt8+aavC7aqhuTZYMXFk0w9MgV7gk2w0lESixhnlmbQ1a2VFt6r1emCpT7M/hzXJ3vpz+OrbvH3K/pn5xiVS2R0WGH4ch+bN41WDJ1Jv5rOdHsP98jtQrxM5PRZ14MlftoLs+uEL/cUobVrDN5XZAN2wshnkjujVUMD7qKp5Fu03lAoh94SAPp9M+NQa47WuJClNgXuHi
 Y+0n0gh+
 CXyCvcgIZE/N+19hXafQDh+9q6uF14ps43Iuo8xGej4j8lTrTGJCUlH3YguyYJLVuq2U1ZXMP9R3oF340JjagXyExqWmtO08rprQmTcN34Ztddyf2u7USlPUxA87NYTY1QV+3HKv2rkdvFToXlXV+AY5mPW20uy8MYHHonE3GVeNdS8rwfH18BNCeTf/5ChwAAkKht2IPCAdLzVn3t7iaDAgWQRcpeXBOMYFTj8jVXJB5LLVhbIDn4LBV0Tu3M31C8XLaT0tt5drV8uiILzjiOeXsSVakk8X9qsBAEh4psQTduwQdukJiFOgZnIfAFQSOOh6ng869u6zycP0tPomPK+mBm5GGq96v3L72vnLhfaFsXW+3WDKeLgVEFoJHWPNc9pdvHZsZ+/UQy7beQ/KrhpWzrCU+6vbZL+rF3AvNHIf7SesDmDaZWlFfkhbB9TUN7Bkj/9vthlpsVqhuzTCt6sjG0yKyyMNJNstjhO7zvQrgak3Xq4Wby4wr5fMOoMiP3XmLh5BOHOKko3RhxgkYQCk49kRgQaqchou1nXbM1ofBouaQmQgLZjpfMQMQsnpQmUINIHksHI9nDV2vwYXGm1Hb3Hqbp46JTmyqoWNaeTODaPOmPp9ljZC4q8FDvK668UtanI/IRzuYnMY/vMG83rZQ87YJH5xaeDfKlUwKhkJgwgs67WPk2HYkEonSVafp7KAS1q/jgsvo7+f8+MhSLp9fKVOvkjWQRFgg5nzEwwBt1h9pfjdFh26o0iCHqbRU3e7+d79gcVjfNGzfVVfO2hA2J+fxBp1iSNZ8Vm3hiCoU/b8WpLw+jzkUVbougOcgijw6iD1YrfnpyBiDUlyk0fUQnJEcGJ33c217IeuS1k5EZLGgCSY41jhDs7vXy8l4VWO0mnzxrNwc9ZI0QXU1iVv0UH5SDJ6i4PKh0CJvbmrC1GG2IU2WuTOeQ+Zei96z6qZ1vMjHHE/Ph1cuJVjBZui3oeWB
 aboA2kAo
 ZUudIOLN2O3pHzNfxMMSudG9c1mnferuocSV51PHaOu5cZj6t9cZdVOKkbbQWJZoDkQ1WIqyQeriOgfAfROp3cNzD9+K4NdD321BFHQ4XOuyKRBV45hwJl99btyhKDJ2a3ROgwBBO2OCCbj161C08tqkkW1T5Dc+RT+EQZtrb72fyfavTvnHRZn4PHPei2SMPRiU+dhy991UksQy+fywNCp8maXjDQtYm5mwANhY3hQAxcxu6nrbT/g2bgrMNC8q31+/wja112MwUmG2G0Nq1ADAMLi6esJmDHIbJ3rJdPCE6iDfiOw9tELPAXA52DYBz/5Bfshz/xcI0PEpKFaxhE2tA6hU4qnxPol/jvA87VIJrIOWWeiwgAzg5+eEyDLOJ3yYs464HvIIhPjkxL9T7nuPsJYIYD20IQg5evF2tYIzDWHqkEFalipY0YDYFLe4R1m6gZIzV7hXvU55FckSUhFzjbxp0vdhwXiZ1b6ooM/PYyyHlbPErK1iQaFmt64usWh0qcZULMgI/APj0VPlgOskEBIF6dEAzAewHFvgvENIk9LPO/CKQHX1ct91QG9AlpeRQPM1vx21mcI0mgH0VcRN7gjpYVlzHbQajWed/EACPA+AInjnjJZBKCb55yu7G5NeVD5GMNFfkY6OLuRQIriy9uZ3OQnDqXeBA3PTmsqQFGWqBRPAkLjvZXqwio5nMSYuKzSU7FAdUOjlGtgplXygZGzk0BWW0VH6c7LJ0cpX9gCSg8vfr5o1ZAxzfxRfHKTI4jytLQB6EiY30FTaMFMw4s7EecsBpWcqCBGtQ56q0+D9SNPtq2jIB6tJJ8pistDU3iz0yXLjB9jxxda+O+MkBKQnNdUxsC2A4AUSA2H43upEb3Ho18jvWSsaqyZICX/P4PmdaUWUK2YwnHpxFKjFFci5JuulUVfUrYecD+S6b4HOxLP457tAynCEmRNDkrOAKRKGBChKVGmrqt5D6wkdbHAl3
 koX/2CaV
 Q95v2fV7UtE+e+o1VygyG+FQFEuxwuZ/O8I/W2sygl15Bh20S6ZgTrkWxbjq4yMavah6Nz0Dr1k414BaLK0PPjHPJIO69DynlNoP1T5LMnsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert uprobes i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 kernel/events/uprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 923b24b321cc0fbdecaf016645cdac0457a74463..d5bf51565851223730c63b50436c493c0c05eafd 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -344,7 +344,7 @@ __update_ref_ctr(struct mm_struct *mm, unsigned long vaddr, short d)
 static void update_ref_ctr_warn(struct uprobe *uprobe,
 				struct mm_struct *mm, short d)
 {
-	pr_warn("ref_ctr %s failed for inode: 0x%lx offset: "
+	pr_warn("ref_ctr %s failed for inode: 0x%" PRIino "x offset: "
 		"0x%llx ref_ctr_offset: 0x%llx of mm: 0x%p\n",
 		d > 0 ? "increment" : "decrement", uprobe->inode->i_ino,
 		(unsigned long long) uprobe->offset,
@@ -982,7 +982,7 @@ static struct uprobe *insert_uprobe(struct uprobe *uprobe)
 static void
 ref_ctr_mismatch_warn(struct uprobe *cur_uprobe, struct uprobe *uprobe)
 {
-	pr_warn("ref_ctr_offset mismatch. inode: 0x%lx offset: 0x%llx "
+	pr_warn("ref_ctr_offset mismatch. inode: 0x%" PRIino "x offset: 0x%llx "
 		"ref_ctr_offset(old): 0x%llx ref_ctr_offset(new): 0x%llx\n",
 		uprobe->inode->i_ino, (unsigned long long) uprobe->offset,
 		(unsigned long long) cur_uprobe->ref_ctr_offset,

-- 
2.53.0


