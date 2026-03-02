Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC7AEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D6C6B014C; Mon,  2 Mar 2026 15:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42BC86B014E; Mon,  2 Mar 2026 15:48:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC7A6B014F; Mon,  2 Mar 2026 15:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1990D6B014C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:48:47 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E39D3B8172
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:48:46 +0000 (UTC)
X-FDA: 84502311852.15.5F8011E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 087B54000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:48:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iVXrDOh2;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ZqTrKdC/jsCoGS4oRviLLNxXywHaNjXZ+hkzY35ljI=;
	b=E0aL6dy0GkR5XaOS9Ne8QmbFEKf8Bb5Rxji1LQVAsTlQP5UkByzEqwmLIKlvvTZsyD/Nvi
	EHT1n6+41CBqE/1Ven29Ir4Us+bdz7ggOfIE5R8RfrwRKotXONvz5rQwJQrXrbsp66ddrn
	1h3HegVXiIUILKdgklTL/Vej4RiURaI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484525; a=rsa-sha256;
	cv=none;
	b=XwmQV5J4W/bUhQIXYNRcjymZjSckE369GvaLVwOAnmeYij6YMSofpRm677MA+1skBIkdjE
	PGhKqy68BgNOS8Dq6wzDKmrVxaudk3CpjDzebSO9yUnhvq8ljM3IhVIv49ZxiE2jtMaRVP
	PUgRwdGKS9GXTtvuoLUHWc6vy6cOXGc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iVXrDOh2;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15E774049E;
	Mon,  2 Mar 2026 20:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40790C19425;
	Mon,  2 Mar 2026 20:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484523;
	bh=XH+uFZSmNDN2ptX3RrQASaTIj90c+ocZQ3rxyA6ATLE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=iVXrDOh2Ncf5NrMJX3ihQ0yWYBb2qKpf1HDvUW8uaT1pQpdMsT5DTGR0WLz8/PKcW
	 dE7bHgzpy10p5+ASLMDMPbJwJ+lyneDG1E/2GII25P4yGZW7tTPCBi2IwXsjtzXpza
	 gQ/67PlXgGE4V3TZod6qgfREW74kicxEttREEGGDVmakwnnSBQl/9iH8qiQwX3UUUi
	 qTYNw/V30fH3FRdzDydenPEg5d0ZpCBxvGPyfwxsCpYSFUuFo2vrKBZNb741AfLs45
	 t3aKxo67Sv9a2MrfLiyxtNdMk0hwRyd82S9gMag4wOxhRH6k3m1e6uHk3O5iJTtC+l
	 C7dNHXCjjF2Tw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:23 -0500
Subject: [PATCH v2 099/110] ufs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-99-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8514; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=XH+uFZSmNDN2ptX3RrQASaTIj90c+ocZQ3rxyA6ATLE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIKMSoWP8hFQKjjQeno+hUGUuYd6GvJ4bDs5
 7A3Boocpn2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyCgAKCRAADmhBGVaC
 FY3oEACyqIaJVAIso5s3j+X74J8R7OIZ/3TDCJ9XB5tC1cEx7enUCvtu37j0livMQYt+5/C2Rh9
 ru6qJKy8aZ21jQpbYqyiZHIg/0is1waiDOrKEtB7HyYm98IaEN0YFz5uzcfiGuGJSdzakmiFuu2
 nMfsAW/4aEtQE1ytbOR1ZWtykmsZMe0h91vvVWbHlZ3lNJWX+5ui2x51WoK4i056frqSjzIwyAM
 nV65BDJ1Y0tAUVBUznyrFbkHe4tOWe4RpA0g6E3+zlKE1johBi2QGhPhT0t1JpefRePwXzSMZ+d
 5v5FTyhm28Gpj0m5gm5BkoO6DHT75enaedHOt/b6OhMPG+iKy1Q4BuDdnCpMgnB2piQQNiFJ6qS
 DwxuMt4AghbxBQWlmKoImjirtPYMvGQMpCVHCLm6cIhr8KQxHxVItTV0X1tRSVKorrPzeDlzTj7
 YxBIK6/M4zQHsnJXnXsVUi+fVQJA7206szogovn3GVf/tIiAmhkwVhsCjw25MppPIcsgmXBsvMs
 Iirc+TTCe6Q3FCBzUJX4x7/xhRAYOArxmoTLoon39IirCDJwAg8jI3hhd3fE992K99lw47W7Hxx
 J+el66KP4PdCBmx03OzxpYxhI2TyG4C5EZui0czqddpHczx8MN+mfe62gilR434DDf3aunJnsvv
 Z+h+VZ85i3fWN1A==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: o6dh5j31xmjfjp3ibc4wtfwf9onuik8p
X-Rspamd-Queue-Id: 087B54000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1772484524-68344
X-HE-Meta: U2FsdGVkX19HPDzJJXo6C9MOsLm6RKn7ITB7r+qp9iSvJb3dsGC07iUuTJ1mwQ/KG91aBctIfNkyogrwjQ6ZeWoqg3DIktqFAFqeWR2qGJ9Pm9DJJVH2E4Vdd15t+960Yy+DhL6LvflOjeH5m271XORg+6lGkM80qPFaNcYngmtqpdh08C2mE/cmC45Oit78ppo0mn2hwDdIn4YFYskUDdER82j5zaSJT5GVBJH7hXMvWBUFGv+8Ul9GDAG7CM3NSjHm6B1JYc6bWQZsZpeCdfhn5ZPxYNnK5l8RMyLeoept/3snLbVRxKQ8TCTLNrVJql7E3YEioiAGzLu8IP5lwyfT54gZyJqMFPzMmQwwocsTJXLP+derAS71PZphRNJHHoeiBE1o+tvrY8V/vH+b1hi5N70cZdnRZAcrv6iIZVqwB6lC1Si+dGK5RcPtIwScXSrrBkMDDZjWMcP0RNqusnMp+1iFagkrr3nTFHA34EK2AxeqQ3dA5kKbKmYndWvTbPpZYE7BMdfloQdrlwcI8P4sd9kvBOBv83+UWgyKJvqPr/60ig32FJjC96MO5NAFeA2kSyXMgFgLYGwH13nOyG3f4EDsVWXxdvSoWysFRA7wVmSNyKCdPXQDxXekzQWEIc4Llg0qNiQhfzzqEARJc8KdnClIjma+3YryexcAR0693IDUObcJH9XWCfVR8H4hBuar0vXyKe9sLWdv3V15qGJ38trBWhzOYX+UNkz4n6VSOd7wrfUZm332SVmPF5D8q444dT+TBC9Eklkz0FDnhnJigUxqsFD6Xlguu40LO0Og1d6Lja0NH5fQK9Iezsgqgu8BL7KpRWjLJPc8HLgrfpMQHlD2cVm+X2dwldo4lJZAlmji/8K3yu0ZP1QGMlEsULHvTq6UC8UsmBWizZqL1BuIIX1FnKkYIKIEOmOC6JmbZE/Mm3iiSqp2fe2SAJwgIAhRZx71cPt51N+JS6y
 mxoPw3W5
 2CkQyeC33wfzgDpT5aYJxCTRU2PCzEDYmB10zZcXkFSK8xq+ECPfK/zniZ1T1+VwoV3/upRR122/+GLC9Y4pVsJ4mK5qtjq5CGIcKnNctLJ43SgnzyM2FGDH32HtziUlAOPs//2/lkXDVtoPAIEWix5lXwwdQYcHPUtCSY5rNC9DM7zhiefAH0ihxLTxNIZhEv6KtODNF9LJT2vWmV9i7I3F+BlmpBPu+023PmMJuJm/841AXQ8+fTf6uhULxjfb6/8rMHoyhf87Es3ThYtY/d8TY4twIFud3J04siqF10DOgxobZ676ZepbjZJoeWLiLrU9XCnA8bJtZQRqqlliHjXgzGgnFPG4ZoHSSy4hUQMlS+yCgaHE3TDkhhDOox4A89TtliEpj/KiVtUq3h4O5REtirKw+lY+XTV561aHs7TKuQRLfUOCJFpN1FOVUTHY73IEJwgUf2rIk8wGaw6sP+Mr8Cq9FTf/CKzy8aVIuSCC7l+6AmrH3KAryp4EeJAZvaWdpG847zJWntoJy69z6BiZDmowB/HCgXijb4aa+piuq0COv9BBn6rIGECqVcppNwGLDDs0GUcg9CKne2i+06B9+lvTatBxgJNBsWPzNMJwSv9hZPZd3vRUKSmsTUs8257mKBfUeJbM4slrK/48IEKBHf9Y4iGu0WrtzOJBEVCzESNnFORqYG7kAf1udvArn5YO4M4BKBiZQzPhcVDGYOasjLbaWaTxd+A554Cvxljn1tGt0JGzxTli3fDrM0+Um62BBzDI86IN+bBI5gAWhU9I/z1xAz/YK1G/yrZVJ2Uo4TAb8+Y3O97OMzP9rRpF3N1t8ukWz7XEBGJloxijALjPujvQsyIOHvlKMh4xwRY1jF3lwekb2yT0BC9gy5lrkc9DF5L5mlUd4E+q00c7IM6eGo7w1xE+pEzKLVu7n6Venj3Mj/XTNs3QGZ6BX7fGO8PrJ1vTGPJZXogRYxU60P5bs4d0C
 vKPSsrR4
 DFII97AzpWSHVEUXhzk1ox5fbsQ2zUJCbmspgmymyNVW5cuoyWLPCIaRxM9jWDGaMXSHTjlvgj6JXMxXg1xB59a0+mqDrXy7LfvIDJ/YHDEfIViBmnfUIRqZQIEOLciAhnrCjRShWdf7K7ERvHwoq7XUsqZjcg4uIJdtUkc+TJ8LohHy/cLIm7iBGBbUBVGZM43cjDS/hF+YWLdUkI4pZa4tEYr9nK3eMHlxOV3skWmjPhtYq/rS/gvD0dTX8CoblvRqCkMAI+v73717gs1DxXxdYdnTFCujMgfnrrFsCInllwhQvpjUm8X/GlOcahDmGHdKPT7tEvp+5WXND1QKnVxZbgGlotel6l8iatFzkbnZ994NZC41xhjXDx7uDUCaLkYIS+EJ5k47hF+stA+aMgale9NottBmujhe6q1YIEX4ouH/NylLMYI/XbzbDCgFGg/XBqH8JVtlQuKA14LFjFMXwcZYEOT6TxU1b4Wg24EC4ARIwFSlWQnkYaXp8N2hwX4zOFkHL7z9BV356FCbpEdpKnjH9YkMptXr4DGDatITqgxm0aAgeivwud8vZZNcaQTxWQ4XfuhX/yddZ7JIDVs/9lWAT9ndiqKEfS2cw/BNzlxAoKmY6i7nIltRZ1Olb6hUvvbaI9JXuR7FH6ZDmpjiC7z86ju+6lVLQUeQ7S8CuuAnZbzlUtgpXFd/5WMqkilPh2x4MWxOBirftRhKk3m7LeiCnkOFpeISKD4dgBc4IusHy2j/EuyWJFnhTbefhKoUNx7quA9sIc6nVRhFg9byb/KvakAjufa1OSCwH3qnvBtNrIZKP99yVXM1kILJ3iKBVxAA/dXJnkxYZeLHhT2jJUeVvRGmMJ1D2Z321AuBfOqc28VivM2ADWm7JVLt8lXuO3PFHGAoUxkBvMZIZny/GdfqO22khHaWl7JBhpkmzNM6NTgGdTfzfL4ZzbwiD5fODSpcq8FmjbwXZKa5m7NzqFfGh
 o28+4xhc
 yATvypIWWxa8KemCF1vD1e2mcgVnojVmUJJgB+VNdLtcOET98cdX75dELyGRef+wFd7l8sTY0nKB2P945IPUUOf20mzpnvDHT27C3ZD1TtmoL5oP65+OWD4mE1nXsM+T75YtpFvv8JqTQtrDFiooOtwahv/WoHkwFvUzVXRKoWNL3ty29oR4oyb7c2+/3PczbF9da6ytL2r/KzT3QJRaNm51KtAX8nuJv+eODKRZegKgHxn1mMczIvcOknnelsRnR3Aqj2BbAGB9j7hAswip+T+4QBtPNvJbMRHVyCTV117pKMc+OaftLW7X4K5tRUgSig9HXYdBbJE2LBlUp5D8mcdYctgN5y7auKFwKsP2EWAKEL7WS8/dwvZ+N4HFu0EPQHrX+36XbwPtBJ7wzP8DMgMAD/m7IGiOBL1NNfS33SMPkIdUIR14l0dSLHJfCB1EFFKBoaDIEQE2UOiCLQ+p/0RuiuWEwFNwNHmKJZF4D/HQHDivFQ8avN2mRCzadwo6iGnATaHLD9jOjZL7BCUsL9eJxLwX/qJGY3t69BJWbe073nZqwqXx0NmtyHH666r/GzGxq3kTKfMGZStpaU0WApZfR0OCsJs00K4gnbDcdONB2wEA8LU2OxL9PvQaU4Y2KLCf+l2l9YgNJpRUIi3Bx8VzA/unhhqgzn2Bl1Vb2pXcrtQkTZJdA5Mge7q9LnF1kf6NDRNyPvBGjvdFF7bSYyv8h+T0zcUgRNadwEHkzqKgsRrwr7YCz4Xn+OPjUMCD1Jden4FRkUYVfT4kPDlWR+MdaemV4Gh3be8ZVxu1HjPCPAp4hy8ANsSjaKXSIIpl1TxC9kNEOQXCIdK/arpwXi39nLh5hL98L3bVGNOVsMZmkzmkYsuE1BRchh4Egr/Nr5A49IvUSLWFbVWSvy1ZhumAzR/9E9w0Wg9mAg2SOLKJQr6Ot3Sx3Qr5F9vtuLKlj2kYjwP4AIByxWQH/q1v3dN0xuHW5
 h7dLldxH
 Dx70uhyY3r4LWmLu/B7x6S4BP2CWM5VHXJul4bER5YnrKQFJkEiEhCUNeLmfF7jo+0pduaPGK1nBHx9qqQoEorOIzZNuwx5xBMxQ5a7i+FFiTsAhKPThKytBt+8aY7XOLMZLeQt1oKOhjV1mwV1fNLaEAngkdvnbIcGVuoJmtWQfHrDWFgKxIeN3BPBPunSMvdT4r/zm9Igbyvrfx2qurYd/DUrO0iR3ZqCjw1psPcpuWqVtctt3M0AGrL4UTq7WnTLWkn/F56Xotf1VCX8hwQ6JGkK1dS3Fcog2ngrRxvK0oPzrMZSLbT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in ufs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ufs/balloc.c |  6 +++---
 fs/ufs/dir.c    | 10 +++++-----
 fs/ufs/ialloc.c |  6 +++---
 fs/ufs/inode.c  | 18 +++++++++---------
 fs/ufs/util.c   |  2 +-
 5 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index b961daa05608fa52dcfc2702bb97c437ef27d9c2..628edfde3a9fd73852930094c19ae6944858f2c4 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -245,7 +245,7 @@ static void ufs_change_blocknr(struct inode *inode, sector_t beg,
 	sector_t end, i;
 	struct buffer_head *head, *bh;
 
-	UFSD("ENTER, ino %" PRIino "u, count %u, oldb %llu, newb %llu\n",
+	UFSD("ENTER, ino %llu, count %u, oldb %llu, newb %llu\n",
 	      inode->i_ino, count,
 	     (unsigned long long)oldb, (unsigned long long)newb);
 
@@ -340,7 +340,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 	unsigned cgno, oldcount, newcount;
 	u64 tmp, request, result;
 	
-	UFSD("ENTER, ino %" PRIino "u, fragment %llu, goal %llu, count %u\n",
+	UFSD("ENTER, ino %llu, fragment %llu, goal %llu, count %u\n",
 	     inode->i_ino, (unsigned long long)fragment,
 	     (unsigned long long)goal, count);
 	
@@ -583,7 +583,7 @@ static u64 ufs_alloc_fragments(struct inode *inode, unsigned cgno,
 	unsigned oldcg, i, j, k, allocsize;
 	u64 result;
 	
-	UFSD("ENTER, ino %" PRIino "u, cgno %u, goal %llu, count %u\n",
+	UFSD("ENTER, ino %llu, cgno %u, goal %llu, count %u\n",
 	     inode->i_ino, cgno, (unsigned long long)goal, count);
 
 	sb = inode->i_sb;
diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index c7a13e01119f990b8f7139fdc3005e7b65afeb54..f10a50f7e78b8020fd216eff19c147b20bd332c1 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -150,7 +150,7 @@ static bool ufs_check_folio(struct folio *folio, char *kaddr)
 
 Ebadsize:
 	ufs_error(sb, __func__,
-		  "size of directory #%" PRIino "u is not a multiple of chunk size",
+		  "size of directory #%llu is not a multiple of chunk size",
 		  dir->i_ino
 	);
 	goto fail;
@@ -169,7 +169,7 @@ static bool ufs_check_folio(struct folio *folio, char *kaddr)
 Einumber:
 	error = "inode out of bounds";
 bad_entry:
-	ufs_error(sb, __func__, "bad entry in directory #%" PRIino "u: %s - "
+	ufs_error(sb, __func__, "bad entry in directory #%llu: %s - "
 		   "offset=%llu, rec_len=%d, name_len=%d",
 		   dir->i_ino, error, folio_pos(folio) + offs,
 		   rec_len, ufs_get_de_namlen(sb, p));
@@ -177,7 +177,7 @@ static bool ufs_check_folio(struct folio *folio, char *kaddr)
 Eend:
 	p = (struct ufs_dir_entry *)(kaddr + offs);
 	ufs_error(sb, __func__,
-		   "entry in directory #%" PRIino "u spans the page boundary"
+		   "entry in directory #%llu spans the page boundary"
 		   "offset=%llu",
 		   dir->i_ino, folio_pos(folio) + offs);
 fail:
@@ -258,7 +258,7 @@ struct ufs_dir_entry *ufs_find_entry(struct inode *dir, const struct qstr *qstr,
 	struct ufs_inode_info *ui = UFS_I(dir);
 	struct ufs_dir_entry *de;
 
-	UFSD("ENTER, dir_ino %" PRIino "u, name %s, namlen %u\n", dir->i_ino, name, namelen);
+	UFSD("ENTER, dir_ino %llu, name %s, namlen %u\n", dir->i_ino, name, namelen);
 
 	if (npages == 0 || namelen > UFS_MAXNAMLEN)
 		goto out;
@@ -434,7 +434,7 @@ ufs_readdir(struct file *file, struct dir_context *ctx)
 
 		if (IS_ERR(kaddr)) {
 			ufs_error(sb, __func__,
-				  "bad page in #%" PRIino "u",
+				  "bad page in #%llu",
 				  inode->i_ino);
 			ctx->pos += PAGE_SIZE - offset;
 			return PTR_ERR(kaddr);
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index f26fbe330a1d0e053ddf8dbe2a8ec5d41373c79f..8e51f4630d186ae49aa987ca46df20960f300614 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -63,7 +63,7 @@ void ufs_free_inode (struct inode * inode)
 	int is_directory;
 	unsigned ino, cg, bit;
 	
-	UFSD("ENTER, ino %" PRIino "u\n", inode->i_ino);
+	UFSD("ENTER, ino %llu\n", inode->i_ino);
 
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
@@ -317,7 +317,7 @@ struct inode *ufs_new_inode(struct inode *dir, umode_t mode)
 		bh = sb_bread(sb, uspi->s_sbbase + ufs_inotofsba(inode->i_ino));
 		if (!bh) {
 			ufs_warning(sb, "ufs_read_inode",
-				    "unable to read inode %" PRIino "u\n",
+				    "unable to read inode %llu\n",
 				    inode->i_ino);
 			err = -EIO;
 			goto fail_remove_inode;
@@ -336,7 +336,7 @@ struct inode *ufs_new_inode(struct inode *dir, umode_t mode)
 	}
 	mutex_unlock(&sbi->s_lock);
 
-	UFSD("allocating inode %" PRIino "u\n", inode->i_ino);
+	UFSD("allocating inode %llu\n", inode->i_ino);
 	UFSD("EXIT\n");
 	return inode;
 
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 199f5f71f77b20bfde408cb1ac7a8ea8c45cc465..2a8728c879796403166f713d1b4ee1b05fe1ffed 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -400,7 +400,7 @@ static int ufs_getfrag_block(struct inode *inode, sector_t fragment, struct buff
 
 	mutex_lock(&UFS_I(inode)->truncate_mutex);
 
-	UFSD("ENTER, ino %" PRIino "u, fragment %llu\n", inode->i_ino, (unsigned long long)fragment);
+	UFSD("ENTER, ino %llu, fragment %llu\n", inode->i_ino, (unsigned long long)fragment);
 	if (unlikely(!depth)) {
 		ufs_warning(sb, "ufs_get_block", "block > big");
 		err = -EIO;
@@ -595,7 +595,7 @@ static int ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
 	struct super_block *sb = inode->i_sb;
 	umode_t mode;
 
-	UFSD("Reading ufs2 inode, ino %" PRIino "u\n", inode->i_ino);
+	UFSD("Reading ufs2 inode, ino %llu\n", inode->i_ino);
 	/*
 	 * Copy data to the in-core inode.
 	 */
@@ -662,7 +662,7 @@ struct inode *ufs_iget(struct super_block *sb, unsigned long ino)
 
 	bh = sb_bread(sb, uspi->s_sbbase + ufs_inotofsba(inode->i_ino));
 	if (!bh) {
-		ufs_warning(sb, "ufs_read_inode", "unable to read inode %" PRIino "u\n",
+		ufs_warning(sb, "ufs_read_inode", "unable to read inode %llu\n",
 			    inode->i_ino);
 		goto bad_inode;
 	}
@@ -793,17 +793,17 @@ static int ufs_update_inode(struct inode * inode, int do_sync)
 	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
 	struct buffer_head * bh;
 
-	UFSD("ENTER, ino %" PRIino "u\n", inode->i_ino);
+	UFSD("ENTER, ino %llu\n", inode->i_ino);
 
 	if (inode->i_ino < UFS_ROOTINO ||
 	    inode->i_ino > (uspi->s_ncg * uspi->s_ipg)) {
-		ufs_warning (sb, "ufs_read_inode", "bad inode number (%" PRIino "u)\n", inode->i_ino);
+		ufs_warning (sb, "ufs_read_inode", "bad inode number (%llu)\n", inode->i_ino);
 		return -1;
 	}
 
 	bh = sb_bread(sb, ufs_inotofsba(inode->i_ino));
 	if (!bh) {
-		ufs_warning (sb, "ufs_read_inode", "unable to read inode %" PRIino "u\n", inode->i_ino);
+		ufs_warning (sb, "ufs_read_inode", "unable to read inode %llu\n", inode->i_ino);
 		return -1;
 	}
 	if (uspi->fs_magic == UFS2_MAGIC) {
@@ -891,7 +891,7 @@ static void ufs_trunc_direct(struct inode *inode)
 	unsigned int old_tail, new_tail;
 	struct to_free ctx = {.inode = inode};
 
-	UFSD("ENTER: ino %" PRIino "u\n", inode->i_ino);
+	UFSD("ENTER: ino %llu\n", inode->i_ino);
 
 	new_frags = DIRECT_FRAGMENT;
 	// new_frags = first fragment past the new EOF
@@ -956,7 +956,7 @@ static void ufs_trunc_direct(struct inode *inode)
 		}
 	}
 done:
-	UFSD("EXIT: ino %" PRIino "u\n", inode->i_ino);
+	UFSD("EXIT: ino %llu\n", inode->i_ino);
 }
 
 static void free_full_branch(struct inode *inode, u64 ind_block, int depth)
@@ -1169,7 +1169,7 @@ static int ufs_truncate(struct inode *inode, loff_t size)
 {
 	int err = 0;
 
-	UFSD("ENTER: ino %" PRIino "u, i_size: %llu, old_i_size: %llu\n",
+	UFSD("ENTER: ino %llu, i_size: %llu, old_i_size: %llu\n",
 	     inode->i_ino, (unsigned long long)size,
 	     (unsigned long long)i_size_read(inode));
 
diff --git a/fs/ufs/util.c b/fs/ufs/util.c
index 9acb59697d85015e83cd1e59ffbccb5452e6dd2d..dff6f74618def7bd5687bd7427f3001a78b708b8 100644
--- a/fs/ufs/util.c
+++ b/fs/ufs/util.c
@@ -203,7 +203,7 @@ struct folio *ufs_get_locked_folio(struct address_space *mapping,
 		folio = read_mapping_folio(mapping, index, NULL);
 
 		if (IS_ERR(folio)) {
-			printk(KERN_ERR "ufs_change_blocknr: read_mapping_folio error: ino %" PRIino "u, index: %lu\n",
+			printk(KERN_ERR "ufs_change_blocknr: read_mapping_folio error: ino %llu, index: %lu\n",
 			       mapping->host->i_ino, index);
 			return folio;
 		}

-- 
2.53.0


