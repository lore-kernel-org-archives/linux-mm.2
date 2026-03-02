Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C58DEB3634
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86E0E6B0153; Mon,  2 Mar 2026 15:49:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822736B0154; Mon,  2 Mar 2026 15:49:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CCE56B0155; Mon,  2 Mar 2026 15:49:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 594ED6B0153
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:49:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2648B1A02CC
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:49:45 +0000 (UTC)
X-FDA: 84502314330.12.EDF32EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 69B6520004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:49:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=knLYfPr6;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hb6zW9n9ycmxz53Pz/V1POsIv5nsMqaLKXpFqeLKSw8=;
	b=Um7QBBaM1yAUr16M7G+5o45YTWyHEweYt3MU+/XU3WML5erDYwOXhJfCSFDc1SdEy71g04
	7u6oX4Y/OUAnYtyUbi3W7eaShvEhHHZ5psRaNbpy6Nr7jxQS0rhjFzoO4nuA1awpQetfL3
	oML2sBGolpkjn8L7154rfvS0sgEGTb4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=knLYfPr6;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484583; a=rsa-sha256;
	cv=none;
	b=wplTFaE6nj2cnNAcCuXpFdS0ISWH48bhhASntvNeKwX3Mqq7q5ADm5dMrT/x8+m+f6VEfB
	/2Dn+WzQy04LnB0hQl5FrBTvgyNp2V95UleKzJ0RQmdNaJQoKLIzHEqlxoWzJd9hS3DLr/
	/lzG2/GWPkxTJtF8EhMcC3VGJF6AylI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C3BD26183E;
	Mon,  2 Mar 2026 20:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DF6C19423;
	Mon,  2 Mar 2026 20:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484582;
	bh=OrF86pnnzRRnjds+quZtUnJo2UCOcmO0ZqHGWktfNkE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=knLYfPr6FfsyRAUVrahs0PoKaPLKsxOi/9wlbcqokdDPDZ8TzYmFUf5mi6VFu0/3W
	 J2GrVsjFgWBQoFJ1GYRl4LSjOhysR+R8ne4dbixd0PAuUrgYWvlNoIZc5+Pka0cQoC
	 9sVFIw3kCgdgs9eHifnrk8otuNK6ezeAh4iMJ2cvZzGC9pgos3FPuEZe3Llj2DLmu7
	 7qMSgJS1ANe3aONc4h0e1OBFeysx6pDRHW5OTP+UcUmddfyEWf9Tj8ySWfyV7/X5fN
	 JGa1kN6gEUHECbXZT0JUR5MOxwoDpyWw3UDNUeSs7fWAvYKYa/YcyZqSq83o/iEso/
	 3JneClnhaxt4Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:27 -0500
Subject: [PATCH v2 103/110] iomap: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-103-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=906; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=OrF86pnnzRRnjds+quZtUnJo2UCOcmO0ZqHGWktfNkE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIMgY4WRtvV89qroK9d0QtS0zCUEPiZQ09iE
 uWlVgO5iQ2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyDAAKCRAADmhBGVaC
 FcqgD/sF6hTA6GliYzQgts5PnTVjpvsM89KjjDv9g3Pti3KDEr2GIVtApcRlnSZB5VJvh0GuF6L
 ybQT0VPwbLP7xwgjXRjVan3GPDp0vLkZsvxmUhFuwbRl8qDo2PobDuvLc2+zDjB2zJ03OAnx0Go
 j+gnWXlCGdlqV5Zb5t93H9TcpCHcf0iZll4dka4YNifYd+JBs827STH3afywwclyinkiGwWMX3o
 H5CA+yoLCkKDpVpv8i+I4rqdtTTRcE3OOLeFNWuPT9xUVavHH/j7klvD9WBTzYsFDJOUXw51/U1
 M19wvagGvX0Ms8rsoVWNJZ183B38cajQoMsYzTL3UK0BQoybkFlvY0lQ6RczSuBQanuq+WHvrUR
 mYpAfUl3PQT+dG0JW3uIj10ktuzv7R+9lVME+u3JQJ8DHRHWg5Z02pM3Cuouzo1gsZGRWDjV1lS
 8qMeHLvz/CDEgKQ19KjtM23o+c0gmjddJ/QG7hkn5HaGVOvALUTfOGYlGmHTz/psX6Fn5WCL/xX
 2UXaOfvpij7Ao9znvsbl6hayxErNIof7g94hLcXOZNVt5StmNndilHPEpp5vOX6lL79sUrFTGwr
 6SPNcyoDRsaJhxoWGWJMoVGsPEA45LQIzsfGgN8PQUYqbp7kzLHWH3SRHeaHz0wgSzP9lRYL8c4
 mwDckMwsn7U+OUw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 9s1m6buzs6ewht7ifz5mfxin5xqbannb
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 69B6520004
X-HE-Tag: 1772484583-472709
X-HE-Meta: U2FsdGVkX18qopoX1jb5i++mrbT7OGiUqo7mlZOWgA1sX2OuqDYv3fj0hUhA8/hMQuUg5WyJZCbslIMvmLEqott8c9lvNhoQx1pSJXcwm3DRq0ye+QepQrqvZeXntps4iJt5wxt5Ume1hqyUDv9GE/qSRgNeFZP3OB1uqltvvDdo9r/g+IrYagfg9+EkcPWG3QNGQXlw4ujIQEh2L4pxgzKx1dpvpN3oS/QketdUHNUm6DKDM//eTgbgdx4EhVDjmETJs4PmaMju2n/dZXsQni6nwJ0xDm5rVmGLSFh4o0T0ecyJMIw2UoWaC76HX/y3s897WsaXC86RaPsqglQdU/x/ixvXys8RA1YYKg3FqjRNfUBSa0IDCDXiC2ijBjsgVDOXq/DAMfIHl/H4zmsHFDVAadXE0I/ZOFVq5SxPvPVabJB90pieySjkp3vcIJtbeaONstk5KHOy7eFeZWwgmdfdDgWq41h70p3SXMn2uEy1i9Id2jeTAMfKRSv3OIg2J2cN0PTq2AalqgpurvEsxOWed3SH6WRRUT/eR/FH4jRSqvz+TUhjJnlM8C5QzRUW8B/nA4AB/gR/jHairlbbte4b8MiAZew3FNSj3V8LQ3tCpLtvexS5Eqb/fLx/CPb32ylbb4hPmoztdadIZzkbILJwbpY9kbmRtDw9dc0JMaoDJL06ZECv+2L87Sdu4tbFOVB+BODjwu5Vg2hYwTMT82zbWRo0ksRsB3VaAo1fn2jI3pH9R/YblbY9NsFFd8zrhL4+eMgNlv0ih1RbZpanU51HZwwgDksCBfSLkfNSXe+luCNbIvm3pArmwkn9IxGGeC1rfHVDk9SDEhPSNr2F2BefQWDSmxmudu4tTKqXLTkTEjYwUnwyo/lCs3/HtX4iVjy3rw2gwJF0P5tfKx3DruxnEs8mwhJZBr25RGCert8Q1YFWtbCga/pNmupf3xdjngrnxDWf654mCDjJUbN
 Vah965R0
 V6s/8eYNY4bq7zQkwDUfhPiAHPqojDyJYgN9gNDr3PBuPIB4CoEY/916DTidpS8RyCVQKI4fKCDxZwPunlPOjemdrX9ZqM1ZvX4dmYXfXY5IRwF+irzRWcvOgJ/0S6Cr9cnKDqSx9X8xUHh63M3CChjK41XJsl5vcwHfcmUZJ8ZhgkOyFrGZlYkNzc25Zo7XrlAkzkzuqCwAnenKLKIpBbJvMiMX7W+q7MFAI/3U8rpdfQFQn5ynQiE0qWYxvP9Gq4e4X3CtiU6lvNy6RU/KCOO3fuGKmYqdZonDdYYkdU4e6TYUB6VqFV3NLrckAGA8DSKEaWvsWMhcIPF745ZIp0qUIG973SP2jgEmYeZ3zyioCGus5SNvlylhh65wBb2z4bYZsyqquC7BcgwugeVGbzFlkZW0aHtSBATM6Vc2vo40g/3TpozF9pVbNR2HNlvYvHkHAoqIRiK1xQq0qU+KpGBCw6vgtzJ/squrLDVgeg17fkkPy83ZuB5zJbB+7PEnOsyyg1XjUoqbA1Iyw44eBsvElJKkc0qAuTJEu72kFrogVxoVS3q6uN1fTIy+KorllVVzm2X1Ft8FJ/XEqpw/9XR4bQcm7MgudQhO61agNKnLH6f/JjjOPtXoIYXKQBXFPB3s05gdEtx9tk6fqdaFV0kc3RmwZWnUPg85sPRKxHDk+zRCzXOZAQugpexsSFuvUMOwd8wvZH4m2S4vzOG07A1unlP1G+B5Cw+V8C6irhtCiARVfjyKOPuhuOe1SdP0FZGsNdBf7Jx7oBbnjNp2e6M5jS2Zal/Mn+G0trUQFdGiELV8IrmOrLgNAjSZtfQTlU0Qf/8N2hnM3VbrdEAndP97Bwc2FH2kEntye4bF/PSLojWAWBk44eh38W/7zAQLROyfwugndknOLin7JdbG6kOYEzvfh+KqA+d+2Diw/GnVe6Qb+mR+lfdLnA+uYhq688mjlrr7h4MgSfTOMO567LjZST9hK
 QRnNU/LD
 jh++DgDGZSU3xyW0FO+r3sNF/gijs6xsPVrTchM8wTKL3Hgiq/3YHqlKV8bE9Zp5gueRPUB/4PfKoTi9/uVzmCVkge2dWKnvZwaOkwkoPBDWZuszKaJxpzCsSrnEErf8urvJYjLxTED1Xco629hS2uXH3ZRwsh78odX8jfE5te4mQJGvX9qSHU/jJjf/IHTc/PS8zfUscahlc1CgGUBfS1YOomjIuqsVKRtsbavTZ1JvPB4Q/MortCOAoi7CQuwoJrWNsQX+hwMOL/vUPikCMRD3rTQSfBuwrClIY33pQvr+fL0QRka/om6fY44eFnNwZiZft75ryfoNmfiOzMI1YVBs108S6Hzl9SZsnvCVRNxVcI7YKXn5rFCEi0tYo5x6nV4zhtOXt8VLOdSAqdZd5GIvgi5EoFy8E2Ki7RyNXijIfPtISZzsrLdk8QTl+cRI2klcOXE3L/wG64YVM+PGrzLzhAupeM/HsO5gKB0kMiaw+bbk7YJvTouWj511BCiQLNxXtATOuZVC2NGMvWyhHQ2C4U+qGP7jurqmilNKCBXpkjwO7r20fj9inbJeY1QnoBtxVqTHW1AUOvb0e21dpkFCXg43mDaC/wwpFDJTwU47hy/I7Md2ho2Uxkmym0ep4TfYNILPkGzmMCq2F131XgjfYayhO864H1AKS3mp9sGu0Rlqpf+oGBJJ0wo+gB8WDLQr/D/60w1/JR1NTO/UF7uTxJ0CURBQLFkHfcqqXfYglEDEyiviJH4Mml1qewQzkyIIH3dh91Lp+8muoYhdrUMngrXHtyti73Wch8QoxpLnkg87AXHb4x2Hnf16inEi/R8gMYZXElGUPKbFBnOdUqeqTWEEbTxWmnKwo53wEiL8RWT2R7zuvH7pwWQ220votGWDQb7u4cQ0fwp1fXg1zjErerOtn56VNRNfEP9BtNSy4uYrb3/kILYcidb37/6HlbyUOpCgD7oT9GzOTbqtUkMgp8vLj
 CplICnv8
 +1IleDeOV99PfYyZgCTNgZ7SLiQW7L6WOCj24Gsny8rdN4Dr5Jo/gzYCQ9pxQIafGS1XMAlpwZA9IPdcfkE/aWosWxZpkADGPpAt32aP5myZHwipsdyVDqh/mOeUo6yaSWUyeMF0z3EemzIQjKL6q3v0sK9Rprh7SNDfI+eY79IB/h/5PlIDPJSiaXBiWTaTo2AuRpXsNIy7UjHfHir7XYKm5omb3EHewTMfgR2FTP4+2fZfiBHmpvpGW/vzg3G3U5COUBXWVGKWwIWqchSoDhtaqSHp1ANhFKIh0lAWxsASaFyHVWLbALF9qX4HZGlgl5ChE+PzoRrTaG/HnYJE1XVwMoCAZl7sPJ+BHClr/oq2b9dOOujwTXrDf5me61ROH2RA6v3wdpi/Ou+C3Kcp6UNE9KkWHsJCjl/hqgJZlNX492Qy6pOhYt4NqAmYMP2ATomAEKzUa8y3ezMxXQGeDcjxIFy4PDZPUhu9GfHVU2qcCCI/AnSVDBiYR57MD5MfChVJtsCrcf3DCjzPbe3yyoDAsYJT/7Lw2U6wYNhA6aT7jqMdztBcyYLPsfk0PpbJnjQIcMGPiVsJdFUasoTy65KdycOwzJ6KI8BkO+73khHnZs+0hPCjUlACnsRAE0qzFF/i9B37bKVbIMOGcZFPZgHNhJRVthvAhk4IzsvqIIPbxVhS1aSaTJ7hqIWZVeDLCjvUzVGAk2hmrkCwl/JxhhMf1Tk6TDOs9BIHjBErU/eYfL2f/pFRbTr/tP7FZxo0h9Rbe4AbCV8zjiFmmJDDVqqD8bAXemnpd7kF8YQF/Usi+euI4PVeGz7JI4FIc/Rv4xg+GCklzMv2u3s6MiXxCommgmRUABoscQDRWKc8E+xrKUp3xtHYqsWD37k5MWOBbT+IvgfJnZIwlfZPjfWuttf/j4I97UlZblUIbAql11DLZY3FSIE3A84hcaUO+tjPYZZeCEsC35AQ/D+Ew2kZU1nao6Ote
 FBfR+plv
 0TgBcjQDE4vag3W+n3fa3lL9qQ5EC1j/Cb8tRrgj8I0lBCsl0/OpAHxG0Z7HE+rhF+oKFE4/rMd5LbIqVMjRSBNk2PvQKqTU6HZ+Z2tOaUfNU++T/OwlUWIG9k7peybE1LERZPYOlXanXq9wjYZoQfyqEGA9ri/9UKOU42smh/pjlGkTvIHDtu3vBOEozTTtpjhh2VNlZP5GtUIxU1c4gGEPLl0hBGwMUjvRw6r5oQls6Mp9FnfxbxskMOjxDU2j+GlQM91r4nQ8wei0qJxPbe68iaddPzntmNCxX4tmVF7AiH3Y79UzCLuXuq4HiKrdenZfAryN2amEbVUlVS50aMnFGsatgDplE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in iomap with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/iomap/ioend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 60c4ba5867f8c9edda2d8b14c6cac0e1d0e80484..94d9a3c77bd68581d752fef4c16b88e1cb5f88da 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -48,7 +48,7 @@ static u32 iomap_finish_ioend_buffered(struct iomap_ioend *ioend)
 		mapping_set_error(inode->i_mapping, ioend->io_error);
 		if (!bio_flagged(bio, BIO_QUIET)) {
 			pr_err_ratelimited(
-"%s: writeback error on inode %" PRIino "u, offset %lld, sector %llu",
+"%s: writeback error on inode %llu, offset %lld, sector %llu",
 				inode->i_sb->s_id, inode->i_ino,
 				ioend->io_offset, ioend->io_sector);
 		}

-- 
2.53.0


