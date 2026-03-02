Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 079B8EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73A356B0095; Mon,  2 Mar 2026 15:28:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4E76B0096; Mon,  2 Mar 2026 15:28:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F7D6B00AD; Mon,  2 Mar 2026 15:28:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 468976B0095
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:28:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5449D14031E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:28:53 +0000 (UTC)
X-FDA: 84502261746.16.496CB68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 95B6EC000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:28:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sph0KI0t;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mbxfa1Z9fJKxq8ls+XMPMCN7W4UEkq/3+yRqgFWyhtY=;
	b=Z5DdUsDnk07Ysx4x10O/o8hh8y6a6XJR623dlehN4eGsYTKfMdD2/hCyy/u7noBV95JYQA
	USDO0dI5B51kEOiZ8Uw2wcOvI2h8ug+HEfwfTg7uPhEGbXDK3gHJqH88czv4xlO+lej6IW
	/D0VuT1OoUDK1S0lsUqSowFRsmK62oM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sph0KI0t;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483331; a=rsa-sha256;
	cv=none;
	b=BTrJQnYmDtQqg7JOkFmMKrFGr1HQmoOwpylVcAwHJtHuryElEI4kENt3a/4GRtUKoREDld
	sGbUcGJdC+289b3cHmCBAewLNBQRWRQ3Je9CXTpwvpAdluhtB8x+kgmt6rVWoLIQi5He2t
	S+vPV+zddQebE6PzHi1QzlAOrbHAQ0o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D96166013E;
	Mon,  2 Mar 2026 20:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B64AC19425;
	Mon,  2 Mar 2026 20:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483330;
	bh=yq1Cs9ZR0lS9egEdGO4mUiRBStCZ5hAnYl6TTsYVp40=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Sph0KI0tM2m5iJ7o/uDRUkmQrQd55EjK7+kOBcZEB+Z865SXKxxqYKXQlil0TPhhl
	 1TLaDa1FusgfArqQgtA/+bqrH7RP9Mf7on//w1qvwazMPq1IBps4ucgLRandSFs+me
	 2vXmCGOlvs2r+od3HGrWxm+BfAsndPV8fJYUFExKYzvjJKLysspt3Y137nOhCHP05W
	 kLjY+KR+GqK5XU2eoEeanI2ywIOH4g+YX2e5aehBacSrgMwMUnVRASxCDeJWqLYBp3
	 sUjtvh3a9E/UvMlMDvrO2uOa+q2E0sKiOz8R4BiRzD0qmvO/5im+Hra6a/HIurcRXC
	 63qhZ59B4r1Rw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:00 -0500
Subject: [PATCH v2 016/110] 9p: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-16-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3829; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=yq1Cs9ZR0lS9egEdGO4mUiRBStCZ5hAnYl6TTsYVp40=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfHzcHlSSc03ks1WmM35c7oIOdItTbwjnJVYQ
 RlqK+TmiaSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx8wAKCRAADmhBGVaC
 Fcl+EADKome0L9OFCCWtEcg+bnttOWPBC2ymrN21IlU4xNiJxXd/SNBmwfNw2PhlYAU3eQFtI0+
 5m9gyVkegAC7dmP7O49oU9P9bLik3GRIBPcyct4T0wKcKcoJ8qDjZjZDyWXKG2hRCc3POma6vh9
 PGEY2XVNxD4VSw8TNbwTMQDVvFUewJD5pE9kO4rCEaoQ5U0MEhxk2TNJwE45QRfi/2/5KVyCgiU
 3BWRw8P9bt9rJFZMJsXqF3Wjpc38gN8z7bQRHunl6L3+zEv0JNc1AzzgUDQfsqkSzsTmu9OoHsV
 8r7u//Pnt4LQxUanpv8tk9/eLdDkzIixQGkonO4WZtrrZsWs2ilYU/C21KbB8/wrScyo40u77aI
 EdME7QJX9yxWjJggTLjow3HOrentf4oMkx1dfEuanCoZ8RjROxhYpPJTnUBeLF3WEf2Nq3xOwfj
 hvqQORN4ikvenhSXH10X/8g/ZlBLQLqcWwgzy7d7Zyc8wkLe0mYdYSOE2ybwhHHlzzFunX1JQGi
 qd88Y3A/+Ym90L7ziA6480ULmn7vidwkNWAEob8awEMhtrSoE87De/Mnmzw4l2xQG3YdvdZEsI6
 mLIxaGHjhUd9SghLavqmIVLfK9GDC0M3adC4bGecCPA+sXyHlvP38Mi8mx890qqCVbRyXsDfUnw
 MAF6nWY7uo7+esQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 95B6EC000A
X-Rspamd-Server: rspam08
X-Stat-Signature: d8j8hanj3pi8bxpzux9qcwyoe3nz81hd
X-HE-Tag: 1772483331-394086
X-HE-Meta: U2FsdGVkX18Gq/3W+sOrWgVlS/JyJDJMJF0Nligk2buY+BNS/vcQ8YFZ3K7MI/PfPsjuww0BsnHUZ3MJMdelsSi8+WV9e1XIHKSLejl37i5oNN+1fC8WG4njHF6ZTx7unUrbMQd7t6hblggMy3UTrrO27W5ynDEdq8GA1e71UUzDmwbK4bINjqjWTE9IoOTmMeVQrT0MZ3MwxXwGI4QtJwxyUpq4Acor3nOzr4Nt8xjA6qsStCWSW7ao2VipgCXEVJCttfYjhU13+sX7LQiP6bCLw6bkV8is7E8KOIaJnwJlKxGrRudsQ0whJASlmtTXca3Y69fi7/Bx8D4XB3gQpa2U+BjYafGrHPNjygPyc5wcqdj7zNq4VrwJjb7xA5MEJhYHxP98quZGk+dleA81MxNBYDPafso8vYQjnsoU6xNYN+loXxzixiUViYvEtD/+0jnIEQUn4+yaaeAOYGW4BQo6UR7O5428fJNtYXcT58DJot3L85JqGK+XqEFAwPDIZx/Oo1BE4ppp0uSmrlEzm34vfXmahdBVZt9IGG9P/I5+Z6xg5GmvMIgQRuw2CJ+vmu4srmyftm2DLosJypmzM5OyZHnaqT49DfTRJwbvjlqrhvMyRxxdb/XAKBbiyHLKqi/1ttxZ+tcYkDt9FPl3KhNTGNS0u7+0Q4ZV9dt4Mv0JC4b88pM2VTVPvFYE1S8NdHlwV4k0g+2XqjASHuUC9Aq0GEaR6b71ouT4/32KSHFa0Hy5+zNtY8aFJi403vDNNVPWZxJGbqvuw2BPM3k7pqklcuIIiV8fWRoP4LGwKxVBCVxv8uPgI5ArGrm3euNSbk3FvOPp6U8YHpA+wCRsSSuSGqAQHvr9gVgPdkhtEO6Vn7vLQ/nahVfkzGSCrFqlAUrIQxxYHoh1GxR+BKfVJi99qJx/+wetvHXIXEzCgAz9A9E4HzE0XyaIwYNLer7rczVlJvI7rcWA9CJrWgm
 6+ZENLQv
 0MxoxKLlcRX8coZEcCJbBdNGUrTDn1Utq68JCaM+VAjd4Dw9u2UANfgOdA2SvBzHDxhIxqH6VkhLyl/PF4kk3NkixZBRiR5TLg/fzB3HKw+BbD7+dKfE+y3p84owGCY0+Uun30vXPxpWz88yyCcU8Kv8PNrONBRtRXig91+tpMx8/waIe4aRxZ0uRdlrYnLGtNytTUXs/hmWnoCrVTulm8RFKby6Ix0lGJIeftBMBjBbky3n6py3vo3QJl0D8ow8WT8RJJVnMnJTtDzjT0g8g3pERm9ll6No6oXIyRguqPKCBxi2auYFLmCGyatUZ8V0v1odOEOlp1qXbU7sG5lr4DqoKllq6jeK0c7TzRzTtAO8UdG+1ykwhNw7BjLI7xFhGS5qI2Kgfd7Cle9hhKSeCB68cMA/iEe46brOOs2xdh4uA7mrMCxWc6KV6KeOqMe8NNB5yJo/6Q/wvA0wESguF581vNczHR5FUrAcmGtMwT4P1T82lZXZohfWvohFfAeUQyfblkJe7BhqrmGeQExF6MLJQC09xTZPUiYavpp8cuImkmIf2WWEPVZJgYV15WmiKs+3Dc+jODm3TzhAL+MA01KoAIGSpiFCJ/qMWqoIXPHJG9kGTE3TMxHQNnahOKRPkHLrD+QM5/M2HynZzXqSUig695sBgMNxUVwWjPjy5RWf2WwcOvr0s09+XC0nSCN5VViumxToRfkcVOd+/Cxt6WBHgzeobJuSu0TaTUVLGk7Q0rPbELlnt3EAh8KxlxsvFvpXk+ldlYvTt4FU3Fhdc8jXcCPmBZVymgxk/GR9Wx3Av1TNFy/iGn5hjq14K+bojs5O3SlWVrBPpvqhYn+IjRfjaFFmIUzFvpIml48PiHT93NABvbcIJjRkGVT+4eVZcGUJEikAv987KqaX2GR+wgxvPA0MkftvIek+Bcaf6NZjjAm/BckKSfzMpt486wOYmdT9TquEJjSPhVYUtFQ3LdlT20EPT
 subcXv9Q
 1pszB0+IOhK8ekMQy4qTNzgKiqb91hl0FsWPYDTPzE6oiTKaIgbgltLBbFepIFOP9x8Wsdq5cVLssN0TyZ0YMhtHlYc9eQc1nfCGVWepTZwqqFRpnGogXarSd03JOETr3bcoau0D4S2Acn6cY3+yW3HNaoKvADzGiOluDt1R9Qg/e1ssKmsrYEv/c6cKn42vAVMpA6X6pYipMCNNRT2NRhm3jimXx5379d8IzX8rSXtVAuLsDKlEyZNudXznceW1LYHSyMId/jGJ8yENzuzd2nxBo9tL6B7aH9QKHxkqPobOn9+23klpqgCYZSKh2yWciwUaGJMyeiwtLqHIGbDlX2L2FlbMHn3+D86HmyRYRXmrsQGWARZytAq7gUnVN/jKLiCst7lr8JHO9hN8DcuvgR2sU09eqbexxyIpdgnj2EXq3pqS2pxWvh+zD69/VcTbEgPEePy75tFqoYQls3FJYhhRQSYgpUalQaQDvcciRnZ8GGpgqsCTGj2QKyn1ZILnLkPUrc0iw/GG7gBCOGpgDT7XfdiiNvQjJZL6E6iW0EMSR4tyJaYsydP5lJIRrONhFPxkrC+ZZvSc6oEMpwm5nLolmJPpy0M1EUlO7cFWY/nUhYleXv1oYXR2nxdaTxyf8FTIWga8fzlhcsD5zOhv9QCc6bPRhVdZ0FHZLuKah9XVxyffDsKsp//SXLlRAqqUJTe9xoZ4+YuYSm468fHbm17nsEAshV/1F9xYYTX5yzY4NK4AkHiMYLPcOFf8vrGsrj1o5Y9ubXdBh0/L/zyOB32ba0pfBI+I67zvgnamNYr6/cQHV7ebUHK/Wqn53hDUlXxOn2qTF21d3uRTmRI4GVX5HzdqC4u555qEG82fTDYZLnhlyRzB6kK6O9HcytMY7awdPspeX2qPI4zTI3FyLgP+QFBcQV2hUt3ZbJ9JjmINE2LOuZ6pK2V0CwwJsWsQ91LxYcHfBCUcrP2XGyLRGA0yZKyuQ
 WbRs2tY7
 aSHneMzCtUtXpQ/ene7O1NDrWp1JFncAKuuXv3nNXWx9QepXePiOtdpf5x6QSrfDRNT3u68EHufXgrYyXRLSq9QZ899wbFv8IAxGqA6P3hWoWw0J04pk9M8o9+UGDjgC7GzEWemEWFvQPRLyFNLrOYRpOtu2XgzV67GqubQGQzW5NYRESczhls6zpee7pKdz4OtB56l1pXjCqxC8khu1vyCo2p1x0NL25kZ1+D8778sY7xMdSZISE4NeE+iXsK35l7/0AcfTXShxEN3R1P7EAThlhttVGBmSAar6LBeiiGdolCikuFIxpkoLjA4VXWYye58PrXWY5cm3jD9VKyWIbsAnexHvT4HYjOjwrsjnPci/Zrr/TLVbATPuS6gb/P7xKV1bX4VqUo/rnfvLnHEIKh5DA+uBcwt895qac2STRwgWIdklTvL0CbQFAd8i44QAf8bSqYrkDplzYuVheNf7ptK8u7j4s5fz/wjprpKzXlimwDmxpdskBC6NeFhWBr9lGTj9HObCKyFez9mUgy6/LXTfurfAaSWOZfUtnCNoU+uYhrw+LSwHXN24GHBalC6VPrztUTcaLhMkTDJ7SpIxq1rDnN0D7jMlNF7+4crXb3tNlqQHbzg0euWqub4rnM0M2cIWBcvPRDJH+oYc4KdG8qSEc7vUv2oSKzo+MrZ66jlrOvklDI96iuuWNnhrw2m+C7GxAQN3MQ7WZqpCqQcpdqZlVkddml49+Fap5+tLpVocaigoQCmmpwEO16mpPDtq2tii/pWmvukl+43PjXkGMW0xnb0BXTSOzMmPZar7YWpQ2FU9kZfDL8avbiT4K0vXi6gyEG8iWYGv3cZbAzElm5o3CZnZQJ/4sCPzJQq9tEHHq6wNUNGelUlZtZZy0ASaPyI8OVHmwTp4uAGigPLTj2DjoPXuvsWlmclJ/NPLzSP0wvtLMD/V7i332yRrNwYtBkQT3fShuwvmQL0+b1vN0OawvyEqb
 mmuowrVu
 oLCUdWb/Q8u5XHZAkNxdIpcOWJL2LJ6B5uylGNvBrRABophl7TErWjCSfgMbxd1T2sQqJz8/gZdCc/OLpS7OYXhN5oH+y8xmv7zAovH3KukiHgcuy5rNkmPYUEFjWPbS5szLeWPfOXcOluY7jgcR3kE4fVpJ1NuxIl+qLtN1rKpj8VJylKAAi828dKhJzkvPi6ohAlszcvGX99l5jQt6mVc33QgZfPd5JMC+K2M54slYnfmMVMyq9t16C/hdfklN6amPYGCMhlYU7ynLkz0ii/AiuGykgvRvzLcQO1dG3yKyRW1e8oc0I07Ivtowx8nFk5Rrry5w5EehrOv3c/V1sau0MlNizNJF8a4HV+/42DkjeH80YToZEIfagEtOT8i6QUeyAvuizGiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert 9p i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/9p/vfs_addr.c       | 4 ++--
 fs/9p/vfs_inode.c      | 6 +++---
 fs/9p/vfs_inode_dotl.c | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 862164181baca1e88ecf8859c55868bb01525ce1..59c1d3f3c45300f5c796a2a441842a1a781e7291 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -36,7 +36,7 @@ static void v9fs_begin_writeback(struct netfs_io_request *wreq)
 
 	fid = v9fs_fid_find_inode(wreq->inode, true, INVALID_UID, true);
 	if (!fid) {
-		WARN_ONCE(1, "folio expected an open fid inode->i_ino=%lx\n",
+		WARN_ONCE(1, "folio expected an open fid inode->i_ino=%" PRIino "x\n",
 			  wreq->inode->i_ino);
 		return;
 	}
@@ -133,7 +133,7 @@ static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
 	return 0;
 
 no_fid:
-	WARN_ONCE(1, "folio expected an open fid inode->i_ino=%lx\n",
+	WARN_ONCE(1, "folio expected an open fid inode->i_ino=%" PRIino "x\n",
 		  rreq->inode->i_ino);
 	return -EINVAL;
 }
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 97abe65bf7c1f00e94e431fc69dc5ce647d1742b..c3eee0d7a70dfe07ba09ce36458228fb00c5855f 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1245,7 +1245,7 @@ static int
 v9fs_vfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		 struct dentry *dentry, const char *symname)
 {
-	p9_debug(P9_DEBUG_VFS, " %lu,%pd,%s\n",
+	p9_debug(P9_DEBUG_VFS, " %" PRIino "u,%pd,%s\n",
 		 dir->i_ino, dentry, symname);
 
 	return v9fs_vfs_mkspecial(dir, dentry, P9_DMSYMLINK, symname);
@@ -1269,7 +1269,7 @@ v9fs_vfs_link(struct dentry *old_dentry, struct inode *dir,
 	char name[1 + U32_MAX_DIGITS + 2]; /* sign + number + \n + \0 */
 	struct p9_fid *oldfid;
 
-	p9_debug(P9_DEBUG_VFS, " %lu,%pd,%pd\n",
+	p9_debug(P9_DEBUG_VFS, " %" PRIino "u,%pd,%pd\n",
 		 dir->i_ino, dentry, old_dentry);
 
 	oldfid = v9fs_fid_clone(old_dentry);
@@ -1305,7 +1305,7 @@ v9fs_vfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	char name[2 + U32_MAX_DIGITS + 1 + U32_MAX_DIGITS + 1];
 	u32 perm;
 
-	p9_debug(P9_DEBUG_VFS, " %lu,%pd mode: %x MAJOR: %u MINOR: %u\n",
+	p9_debug(P9_DEBUG_VFS, " %" PRIino "u,%pd mode: %x MAJOR: %u MINOR: %u\n",
 		 dir->i_ino, dentry, mode,
 		 MAJOR(rdev), MINOR(rdev));
 
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 643e759eacb2a46855c7db6187fe6b29b7534c9a..18a3792afb4fedcc870a6090ad364a7ed3c5e9a6 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -691,7 +691,7 @@ v9fs_vfs_symlink_dotl(struct mnt_idmap *idmap, struct inode *dir,
 	struct p9_fid *fid = NULL;
 
 	name = dentry->d_name.name;
-	p9_debug(P9_DEBUG_VFS, "%lu,%s,%s\n", dir->i_ino, name, symname);
+	p9_debug(P9_DEBUG_VFS, "%" PRIino "u,%s,%s\n", dir->i_ino, name, symname);
 
 	dfid = v9fs_parent_fid(dentry);
 	if (IS_ERR(dfid)) {
@@ -734,7 +734,7 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 	struct p9_fid *dfid, *oldfid;
 	struct v9fs_session_info *v9ses;
 
-	p9_debug(P9_DEBUG_VFS, "dir ino: %lu, old_name: %pd, new_name: %pd\n",
+	p9_debug(P9_DEBUG_VFS, "dir ino: %" PRIino "u, old_name: %pd, new_name: %pd\n",
 		 dir->i_ino, old_dentry, dentry);
 
 	v9ses = v9fs_inode2v9ses(dir);
@@ -798,7 +798,7 @@ v9fs_vfs_mknod_dotl(struct mnt_idmap *idmap, struct inode *dir,
 	struct p9_qid qid;
 	struct posix_acl *dacl = NULL, *pacl = NULL;
 
-	p9_debug(P9_DEBUG_VFS, " %lu,%pd mode: %x MAJOR: %u MINOR: %u\n",
+	p9_debug(P9_DEBUG_VFS, " %" PRIino "u,%pd mode: %x MAJOR: %u MINOR: %u\n",
 		 dir->i_ino, dentry, omode,
 		 MAJOR(rdev), MINOR(rdev));
 

-- 
2.53.0


