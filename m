Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF75BEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:41:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35BA76B00A8; Mon,  2 Mar 2026 15:41:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FBAA6B00DA; Mon,  2 Mar 2026 15:41:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19C836B00E3; Mon,  2 Mar 2026 15:41:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03EE46B00A8
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:41:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5043C17EE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:41:20 +0000 (UTC)
X-FDA: 84502293120.17.3D66DC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D338F180003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:41:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q3lWy3v4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qs6yjgrToUcqY+yJg4fgzeQmq1Yk4KIzI+pcCkKbq5c=;
	b=JQdVtLmZaul3sEkmdotDakclJBs8JDubwaJRQTKj4Qn+WGvahIiECG5DudwNPi9z0ysqUp
	lZW7uPBJkJ00NoaXA/HJa4N6WR/ZkBO1etfQkvcqCOlDZOEJx9+JEAlWZ2jvN1xyjWW5lQ
	EzeqVjVRpGz9N7A04iyWrVEn+kJQNp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484079; a=rsa-sha256;
	cv=none;
	b=uJb1pmoiUfcJ2XO1jMmCkIwMi3OBHB07p3aaNFxU74Fd3so+RqYs6xw1MTA/IxUV2ufZBX
	q8n4nOC7wMankoksEyPrUiB0J+y6dSzyq4uaJ1Fvkd/rU27XUmBUgLUnRQRpCudBBgk5z7
	qZxsUXDoT2uY1KbyU3kDwNqRk1KqlU0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q3lWy3v4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F402E40279;
	Mon,  2 Mar 2026 20:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4D6C2BCB2;
	Mon,  2 Mar 2026 20:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484077;
	bh=7iiTK/WlallPtoG9cPNjecKgEBkMT/TeqVgQy+WopvM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Q3lWy3v43bm+80a+0OwzqN6HO+WYZrL+cAeVzq9he36ZmAtFYTR/rzVUIOd+XPIZn
	 xiciprDtyAiCVp57Nzi4tvZ8Y21cP7iDyRS6JDAwcVAjHQ3q1cgBKlwkGplcbRZtaq
	 wu0ln60mDcobYuejPozOuD/SEwr5UkMfFPRnckpe33RzwKjIXJ3Jucu0Cix62ZMXir
	 u+siRB/S0m7tx5nTgxL3R7ly4+L/HI3KzITee/l1HsslT8QqSzDTLx5ns5Mq4srKXf
	 Ndo3CW8EU5EMBb98PjC+ney+FXVIpyqf3TaCiM/5UU3fbLTn0M67jYrBEstdade6rG
	 PYLcnjlQMOWag==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:52 -0500
Subject: [PATCH v2 068/110] nilfs2: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-68-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=14594; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=7iiTK/WlallPtoG9cPNjecKgEBkMT/TeqVgQy+WopvM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIByzPBKN+6Lr3DkJlbKoKDXSsmMjh2nWOjA
 OenDfFcRDKJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyAQAKCRAADmhBGVaC
 FcVzD/0a3wbbo/lvqeGMdK9SeYLF3NTrj3JCtWkiw1CiLf06TkanPBZN4g21uciz8A3bhypmKQm
 ur1miF+4oxMw995RrTSwqIFlhBTSOlbgi88+V9KV6ir1SaXotaYRHWTnkhmEazGKyQ4e15gUV7d
 4EtAAK2sojRlcY+0Zn002f1amXr5goGrtuQcMx3mLOVglOIlAi0k/n8GyW+N6kNeMV6wxKokXiE
 yfkwZMenwOROw3SG3fLOtneaSgawXku/m2Jtt/Q4ch0tGmrbNq1ZCyOczLh6zQt8U/h660/LhkZ
 EZSjYQqYUc7519xck4rS9esm9Dae6T7ihTSgSQOy08KoX+EgqqxqWIObPtH7FPpWdZeZMTiEdra
 xbOHVgxCqFJfLvM4c5G2PsIFVCXcIBiQF7jnORE0Y1wUdL9xEHUUA2eeEkwv2px+oI+R0P4Az0h
 mQ2V1Zjafq9RxYAZhPoaBr8TsqNQPach7sdWbxhTPgQzZjTbHZwsdROvQlBAdznlxLzIRbkzByX
 n4VnP/+pP+U2Xp7ibTRbYfdhtRyJoa6MqjOfrpZGaBGVI0BfQ9a41R3xYDUif/ioKhDEoxEfud1
 NbBFix+eq/ukXY+6Dz/20Ixoih4nKZOD868lCfiF/gOalbvoZZlWsu3VLzKMUgSj2Cab4Zk0v2z
 dBKhS6EU8pUW1VA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D338F180003
X-Stat-Signature: r447s5chzyeuaz4tq8aymo3xmsskx9ke
X-Rspam-User: 
X-HE-Tag: 1772484078-986161
X-HE-Meta: U2FsdGVkX1+3e4UN1RXAPl7jml4CQcDgWMfvIL2myrtDuZ258BjzIdsYFr/gbGm4R5iiOUcuub8S2ZDCQqvhT2W7ARFddXQoYSPGAvm3OmSJSQVzossaaBL6PfzyOanw1pMpWMhHYARjvwjzPypAZxxpNlloMq1n68QYXuUxPALo2fcko6Ob7hnKZ3pYbmFs/+abcMDpbRlG0cDULSZSHdqhNWHIbleqFt50K1iD8DAdUMwnAvoHX3J0Bt0BHyK3FI0ZqLBNe/INP3W1GFSMXRr7q9u0i4RQ4pnXF4Gu/F5gr5Z9GSvgubGs5E4onFfYxDi3YA7BEmNJ5MPLmui133mM4ZCpWkKys+thMcRy8mxit5NjgbFNLB0nm3BJN2cMJuxDq5cFytxw6qDcre4CqfBC58BBbh2yy1yAb9Rn2+vcvv0e0ii/U1WptnbAvcn0el/Fhvypm+ikxh55UNpgtELQox0vA/LHZD2kGB/+XG8xDVsrtlWJnXALzex++j8M7w1GqaYvQXClbi9p4ZqQJ5PJY9p+LrTfAF8xxf5sOhP+8+ezUnWekYTKra2CVfAoRneDRnf/pFIX7ro8FaP2HKB3Rv2kJyCwg1be8y920Q24wmfZwlqxjaQOf4T77L9Zfa2bVUF3+wfVbh7vZfOZlnBjnuVb8nABfmvQJCOjV9JEPYGQgHNFaRnL1ov1NLS7eGntRKlHClLSphhXqgosWh46iECMO2bqiMnjpWBq/pkvBKYCF4vEI9q5W+V2DyxwErG8ZviaNCWgV0gfDYmAjaawlaGpA+UugH8HTeZsoFz+60qP0fbxogWFkSe6V7fR82o00fEXYo5fbnSmRnMt6Pzs2QOTIi0iNBzbcsqpe0CWecCSIZBuzRKNlzAfIuuF4Wc0HSk0CaU5ZYDyRTwoLX9T2PAo6QyB7TX/sHmEL9C/y3M1LQMBV5VX0Fsu+LXFmxEK9oWBnnjpVCmTWTO
 2c2uVMXK
 3DBrepg/OGvyHtKc8FwJK6HhBF+Q3J7rzQDFOKL+/FgP3raM+aPawBEtT69EpUFTrHJg9DTHzgnVZ6Gt3Eo4a3xwJg+aMWLBWXpyKiIDV68oJpEnGySTwM2pGRawIT0HG9hm8s6Uj3r4QaxiOUpgvH9wQtGi7hAOlr86ew+wjXMNDooJJ3oEn39V+0A9z3+xk6xgU6S3PWXkORCZRfuFPErsxiTrtitqktr9DOMk2/GJO+epjqZTtG3MjArWrzX5Yi9IZ8VeT3qX1q6wKBS/msjIHxWv88hr8XFpir+pn39yFNda64aObPWDMvVMPZGCfNEAqzg2kndDp4BWkUeclCickKflPqRLQL1ZZzoObu7QC69a2NXt+8gqtzOAttoImi6HY7nDsXsAeaWbIpbj3tFf8f+e7SH89EFDngpeGA91IVXVMwCGvhBnjS4Nh7AvPbg9027cW3DtebUZBMyO0eqZIBh3jsGW3QdMWzjFKrJVIBIXxCNM/ruiUNXrdj2spytWyQ9AdknqMU9rW6Xq/CioArCXNGCrobwerQ7Rhkkh3/Gp0HVtoOHerVaxWaYHoSkvITdHuR6DHbPIfZYAPiwd3LIYTzGllF2OjrFOdbeZUkza31+UrXGqSOr4SdKH7uuD4Baq5vU2+j1NInj3Px6w7irKYtOxigy7bRrOEo71bgjb5ot2bzAG173ZJE9GRp9hummwHM/boCQxa4kkK7tecLUpRlf0x1bvwbjxvUDYYeK7TZZ7WCj6oMf8WL1Dg/EjbeFey/ZTG+YHZlE5R9VIgCQoYxag6+SJZuWDye6ofuW32qbORRcogGAddvi0RFrhYLjSdul3Gl6sVOJc1JY/s9FLy601aoQBEoPbQfRO6IUv2f7nFeEVhs9jHqe0eEX43pNPDce0l1h+eLG6m/1EYLqlFqMy4yjomlBJbN8p1wVs/p8jgcKgG+gRGUWlcmZdBTBG/XX4PLc/RlhTQB/nMpnlY
 Y5UelEcv
 slSl8o+QKWDshfTafa4d2LlKkP6B5JoNu/v6Mf5yL0gOhGuqBIBwkd7sVK0ZqzJSpz/nXzCjwRxiLaCzvFtDOCh0tCbmxPuiXDyVuJ8h9fpW1WLEAsaC32CUy/qLq4nCfYFDk8W3pmx2dYwlyxROzbFyJPLQC7pIAxZ9QIDXdWdSgzMzYimH/zxLCPY5tBi1v6jhQXBuykqtUISZoYvRwmwqeRM/1wIHZgnNOhrBlbGMAaOP8ofRBzXyco++tlywqDKSm1ICJ9a+g4SPJtx+DF0HImTYewCht3KbUQUeqNtgdxcZJq7YyW0k5MS4gOaEm4n3NPyaRq4Xm0Djl/4sEEJG51yUZ6IXujv6qZNs4WZIVGin/3Y4y7kUteO7uCKfsBWvIkhbD+TcnIttNq2r5Mi/yNWcshmBYW2iRHuOVU89wkXQyvBqw8wSDipoJGW7lZnyuqFzIgRuca2dzNMPr6zMaY+O2xeIAjrxbUSIMuME7IiY3yRF8FSaM18u5X4NSeVZPpzFKa0QAWBz2PrvxZEp3RiyCEU+cNmV2vRSVVEVqkg4UZeJ9WtKSatU73WlOprgV9YTFlaubmpT8z1xZ/gQ6Ru916l6c4X6ARA5Zg75zlAgfPh4SgovlaLrpwXcchdCntayT7HqykXqON/8BNanyuZHWVseqpcKIaddlTIEn+nUwgXcWu5H+SQMFf02bYRs4ujLhj7aMk6Nr3ug+lmB5x3FeJhebWf5Nk6H7w5m9HfAsns+cPk8F8j4800Dp7S8fcvM7R2U4++obEMbmzjxUgtqUOETHgEW6NrGspaQVYN2aTiP7tQ8JXdTw6jwZzB/yX+j3vGZ6ZoSvM3Bdx5RpiPrgFIvwQckJt8RHMDQVI0Rmr3yEMc5crXqVjBi1bRwgDMa24T7T5VfApTmtE7XjySGDzC4kokOZg0s4lJ5Gq07egklKuDouFdblZYZVu1OpaMKF78cDy7rLMbvLWvf5TRXQ
 RL1xyvII
 CMVLazPCAaRoUstj15HAmr53Mpl9XsO1MEN+NE5+Yct7AyFEcIRAuVZuT6xL5bG7RgXnU3CTODxt9m/fWr5IxL8AeAqBHMaUbQET4pjRXaQD1wbWrk2CybIVAi+ym8sAiB14WbSiMw0ixkUMpH0pb5/YP+byLfZ3JHVbH4oda+GlU/zmoB0tLG0ryTiXgnWMZw12w+JphiRnQ61BF1w4rrTMTJEfz1y5Bmb6gy3XgOJp1d5JOA8pH5qF4IW+YyiTJkM70yBB1sIaRnBp6mOtxzsURRTLbuOBwIwbUqYiDTzvw/yTO/g8NaI9jobgR/0XtuOlbjB3MbOhUaw8BW9286lqqjk4cLrXu2ICVxGZqzSzh7S/kHFm03EQ0uOKV02ZR6Vhrkuqi1x9Zojz7s1EQpTlOn5Yyu1uQMd+vG6qmgLV2Zv6NmI8t9md79AoqYPJ1eMzYGMKZNwmMOOcPasT79Xqm3DqfA5hc1OmrXrcPeF3epecxWC5o2zFMjD1jPpVaEehfSWkZDuODkkogrftyREslxuTcRHnTmUFEzJu8eqiN7Kj8V1bulokjJc5bo0t2MqIgSQspi9LW7FnRxz8YMVRmqEOXe7r0myI5PU/Xsr5QMfh8gm9j6lIsCDnHYfXg3R5k5/GGwd6OkUHFK+w1LGdnHGBupp9aVb+FZTtVhp7GHKNMe6Ccgev/xQohDsQnqbyq1K1+s7tyHQmy9hAhayNPZZDgfubKo/4fq38P4l+lGTtuNSw4hWc1XbScgUvgQkro+DqMLdmAzqDkR3PseFidkp65zf+hJR1peJ3udPHN0pJLNuohQQjPG+qcWrWzLuLtONUImvOCmJSo6A66f1yUgaxSfZe88fxhBw3WpWS1bNEu+rmoqXwHxuzuKTozVTSNAFKpubla+HJ7LoRvGocInCcRmH26OoiJCpvr5l38dosSTur8JQWnd7Tg7n459MGdKIlxbTzk8pqw6j4t5aVRw0Zk
 xrZj974+
 T9XcfdJKCKzw9FYz0M6c+PjXYWJIHBiqyIixWM6ulemU9UvSQ8OtbJx6dhTMw+n5329O8cgXjgJg4nYTiWDibKoDGayPEeIrZ0eD1957CNF0FnyBOm9UiFCVZ3erkJs6S2N6rLLc8fNzzr/Ov80j2I5fe31PeR2oUnvi4SQlV7Xwv2p4VqQ6HySkGW/LwNYUfH2TH5RMkHRdtj2neE4xQ2jE3PEwMM53s3ypeylnVFBy+le0PGbvs16hGb9q6yxiZq0X4CUh00Rb0FCVEPT2kPpYQ9gIU/RvAQTvjBI39JdY+HgL3klGZ0uluOVPdbl//Ku2cbBMyv2CbzIoeN907+hGz1tLgZC3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in nilfs2 with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nilfs2/alloc.c   | 10 +++++-----
 fs/nilfs2/bmap.c    |  2 +-
 fs/nilfs2/btnode.c  |  2 +-
 fs/nilfs2/btree.c   | 12 ++++++------
 fs/nilfs2/dir.c     | 12 ++++++------
 fs/nilfs2/direct.c  |  4 ++--
 fs/nilfs2/gcinode.c |  2 +-
 fs/nilfs2/inode.c   |  8 ++++----
 fs/nilfs2/mdt.c     |  2 +-
 fs/nilfs2/namei.c   |  2 +-
 fs/nilfs2/segment.c |  2 +-
 11 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index a3c559c86e5a4c63b1c9dd4ca137f24749c3ee87..7b1cd2baefcf21e54f9260845b02c7c95c148c64 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -707,7 +707,7 @@ void nilfs_palloc_commit_free_entry(struct inode *inode,
 
 	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
 		nilfs_warn(inode->i_sb,
-			   "%s (ino=%" PRIino "u): entry number %llu already freed",
+			   "%s (ino=%llu): entry number %llu already freed",
 			   __func__, inode->i_ino,
 			   (unsigned long long)req->pr_entry_nr);
 	else
@@ -748,7 +748,7 @@ void nilfs_palloc_abort_alloc_entry(struct inode *inode,
 
 	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
 		nilfs_warn(inode->i_sb,
-			   "%s (ino=%" PRIino "u): entry number %llu already freed",
+			   "%s (ino=%llu): entry number %llu already freed",
 			   __func__, inode->i_ino,
 			   (unsigned long long)req->pr_entry_nr);
 	else
@@ -861,7 +861,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 			if (!nilfs_clear_bit_atomic(lock, group_offset,
 						    bitmap)) {
 				nilfs_warn(inode->i_sb,
-					   "%s (ino=%" PRIino "u): entry number %llu already freed",
+					   "%s (ino=%llu): entry number %llu already freed",
 					   __func__, inode->i_ino,
 					   (unsigned long long)entry_nrs[j]);
 			} else {
@@ -906,7 +906,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 							      last_nrs[k]);
 			if (ret && ret != -ENOENT)
 				nilfs_warn(inode->i_sb,
-					   "error %d deleting block that object (entry=%llu, ino=%" PRIino "u) belongs to",
+					   "error %d deleting block that object (entry=%llu, ino=%llu) belongs to",
 					   ret, (unsigned long long)last_nrs[k],
 					   inode->i_ino);
 		}
@@ -923,7 +923,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 			ret = nilfs_palloc_delete_bitmap_block(inode, group);
 			if (ret && ret != -ENOENT)
 				nilfs_warn(inode->i_sb,
-					   "error %d deleting bitmap block of group=%lu, ino=%" PRIino "u",
+					   "error %d deleting bitmap block of group=%lu, ino=%llu",
 					   ret, group, inode->i_ino);
 		}
 	}
diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index e12979bac3c3ee5eb7fcc2bf156fe6e48fc65a7d..824f2bd91c167965ec3a660202b6e6c5f1fe007e 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -33,7 +33,7 @@ static int nilfs_bmap_convert_error(struct nilfs_bmap *bmap,
 
 	if (err == -EINVAL) {
 		__nilfs_error(inode->i_sb, fname,
-			      "broken bmap (inode number=%" PRIino "u)", inode->i_ino);
+			      "broken bmap (inode number=%llu)", inode->i_ino);
 		err = -EIO;
 	}
 	return err;
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 3d64f3a9223e5601dc2332ae6e1007edd5b4827b..2e553d698d0f3980de98fced415dfd819ddbca0a 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -64,7 +64,7 @@ nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
 		 * clearing of an abandoned b-tree node is missing somewhere).
 		 */
 		nilfs_error(inode->i_sb,
-			    "state inconsistency probably due to duplicate use of b-tree node block address %llu (ino=%" PRIino "u)",
+			    "state inconsistency probably due to duplicate use of b-tree node block address %llu (ino=%llu)",
 			    (unsigned long long)blocknr, inode->i_ino);
 		goto failed;
 	}
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 57163e991fbc49e2bfba2fa543f1b8dbd77718f4..3c03f5a741d144d22d1ffb5acf43a035e88c00dc 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -353,7 +353,7 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
 		     nchildren <= 0 ||
 		     nchildren > NILFS_BTREE_NODE_NCHILDREN_MAX(size))) {
 		nilfs_crit(inode->i_sb,
-			   "bad btree node (ino=%" PRIino "u, blocknr=%llu): level = %d, flags = 0x%x, nchildren = %d",
+			   "bad btree node (ino=%llu, blocknr=%llu): level = %d, flags = 0x%x, nchildren = %d",
 			   inode->i_ino, (unsigned long long)blocknr, level,
 			   flags, nchildren);
 		ret = 1;
@@ -384,7 +384,7 @@ static int nilfs_btree_root_broken(const struct nilfs_btree_node *node,
 		     nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX ||
 		     (nchildren == 0 && level > NILFS_BTREE_LEVEL_NODE_MIN))) {
 		nilfs_crit(inode->i_sb,
-			   "bad btree root (ino=%" PRIino "u): level = %d, flags = 0x%x, nchildren = %d",
+			   "bad btree root (ino=%llu): level = %d, flags = 0x%x, nchildren = %d",
 			   inode->i_ino, level, flags, nchildren);
 		ret = 1;
 	}
@@ -453,7 +453,7 @@ static int nilfs_btree_bad_node(const struct nilfs_bmap *btree,
 	if (unlikely(nilfs_btree_node_get_level(node) != level)) {
 		dump_stack();
 		nilfs_crit(btree->b_inode->i_sb,
-			   "btree level mismatch (ino=%" PRIino "u): %d != %d",
+			   "btree level mismatch (ino=%llu): %d != %d",
 			   btree->b_inode->i_ino,
 			   nilfs_btree_node_get_level(node), level);
 		return 1;
@@ -521,7 +521,7 @@ static int __nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
  out_no_wait:
 	if (!buffer_uptodate(bh)) {
 		nilfs_err(btree->b_inode->i_sb,
-			  "I/O error reading b-tree node block (ino=%" PRIino "u, blocknr=%llu)",
+			  "I/O error reading b-tree node block (ino=%llu, blocknr=%llu)",
 			  btree->b_inode->i_ino, (unsigned long long)ptr);
 		brelse(bh);
 		return -EIO;
@@ -2104,7 +2104,7 @@ static int nilfs_btree_propagate(struct nilfs_bmap *btree,
 	if (ret < 0) {
 		if (unlikely(ret == -ENOENT)) {
 			nilfs_crit(btree->b_inode->i_sb,
-				   "writing node/leaf block does not appear in b-tree (ino=%" PRIino "u) at key=%llu, level=%d",
+				   "writing node/leaf block does not appear in b-tree (ino=%llu) at key=%llu, level=%d",
 				   btree->b_inode->i_ino,
 				   (unsigned long long)key, level);
 			ret = -EINVAL;
@@ -2146,7 +2146,7 @@ static void nilfs_btree_add_dirty_buffer(struct nilfs_bmap *btree,
 	    level >= NILFS_BTREE_LEVEL_MAX) {
 		dump_stack();
 		nilfs_warn(btree->b_inode->i_sb,
-			   "invalid btree level: %d (key=%llu, ino=%" PRIino "u, blocknr=%llu)",
+			   "invalid btree level: %d (key=%llu, ino=%llu, blocknr=%llu)",
 			   level, (unsigned long long)key,
 			   btree->b_inode->i_ino,
 			   (unsigned long long)bh->b_blocknr);
diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index b182da076c58c4813145bc3e501a1e9a188bce85..3653db5cdb65137d1e660bb509c14ec4cbc8840b 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -150,7 +150,7 @@ static bool nilfs_check_folio(struct folio *folio, char *kaddr)
 
 Ebadsize:
 	nilfs_error(sb,
-		    "size of directory #%" PRIino "u is not a multiple of chunk size",
+		    "size of directory #%llu is not a multiple of chunk size",
 		    dir->i_ino);
 	goto fail;
 Eshort:
@@ -169,7 +169,7 @@ static bool nilfs_check_folio(struct folio *folio, char *kaddr)
 	error = "disallowed inode number";
 bad_entry:
 	nilfs_error(sb,
-		    "bad entry in directory #%" PRIino "u: %s - offset=%lu, inode=%lu, rec_len=%zd, name_len=%d",
+		    "bad entry in directory #%llu: %s - offset=%lu, inode=%lu, rec_len=%zd, name_len=%d",
 		    dir->i_ino, error, (folio->index << PAGE_SHIFT) + offs,
 		    (unsigned long)le64_to_cpu(p->inode),
 		    rec_len, p->name_len);
@@ -177,7 +177,7 @@ static bool nilfs_check_folio(struct folio *folio, char *kaddr)
 Eend:
 	p = (struct nilfs_dir_entry *)(kaddr + offs);
 	nilfs_error(sb,
-		    "entry in directory #%" PRIino "u spans the page boundary offset=%lu, inode=%lu",
+		    "entry in directory #%llu spans the page boundary offset=%lu, inode=%lu",
 		    dir->i_ino, (folio->index << PAGE_SHIFT) + offs,
 		    (unsigned long)le64_to_cpu(p->inode));
 fail:
@@ -251,7 +251,7 @@ static int nilfs_readdir(struct file *file, struct dir_context *ctx)
 
 		kaddr = nilfs_get_folio(inode, n, &folio);
 		if (IS_ERR(kaddr)) {
-			nilfs_error(sb, "bad page in #%" PRIino "u", inode->i_ino);
+			nilfs_error(sb, "bad page in #%llu", inode->i_ino);
 			ctx->pos += PAGE_SIZE - offset;
 			return -EIO;
 		}
@@ -336,7 +336,7 @@ struct nilfs_dir_entry *nilfs_find_entry(struct inode *dir,
 		/* next folio is past the blocks we've got */
 		if (unlikely(n > (dir->i_blocks >> (PAGE_SHIFT - 9)))) {
 			nilfs_error(dir->i_sb,
-			       "dir %" PRIino "u size %lld exceeds block count %llu",
+			       "dir %llu size %lld exceeds block count %llu",
 			       dir->i_ino, dir->i_size,
 			       (unsigned long long)dir->i_blocks);
 			goto out;
@@ -382,7 +382,7 @@ struct nilfs_dir_entry *nilfs_dotdot(struct inode *dir, struct folio **foliop)
 	return next_de;
 
 fail:
-	nilfs_error(dir->i_sb, "directory #%" PRIino "u %s", dir->i_ino, msg);
+	nilfs_error(dir->i_sb, "directory #%llu %s", dir->i_ino, msg);
 	folio_release_kmap(folio, de);
 	return NULL;
 }
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 1084d4d586e078ab6825167976dd2a71d52bc8aa..8bd0b1374e25f8ff510f3b36dbde2acc01aafc1e 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -338,7 +338,7 @@ static int nilfs_direct_assign(struct nilfs_bmap *bmap,
 	key = nilfs_bmap_data_get_key(bmap, *bh);
 	if (unlikely(key > NILFS_DIRECT_KEY_MAX)) {
 		nilfs_crit(bmap->b_inode->i_sb,
-			   "%s (ino=%" PRIino "u): invalid key: %llu",
+			   "%s (ino=%llu): invalid key: %llu",
 			   __func__,
 			   bmap->b_inode->i_ino, (unsigned long long)key);
 		return -EINVAL;
@@ -346,7 +346,7 @@ static int nilfs_direct_assign(struct nilfs_bmap *bmap,
 	ptr = nilfs_direct_get_ptr(bmap, key);
 	if (unlikely(ptr == NILFS_BMAP_INVALID_PTR)) {
 		nilfs_crit(bmap->b_inode->i_sb,
-			   "%s (ino=%" PRIino "u): invalid pointer: %llu",
+			   "%s (ino=%llu): invalid pointer: %llu",
 			   __func__,
 			   bmap->b_inode->i_ino, (unsigned long long)ptr);
 		return -EINVAL;
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 714962d010da4a23e9b5f40de8aaaca8b95a74da..62d4c1b787e95c961a360a4214d621d564ad8b4c 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -137,7 +137,7 @@ int nilfs_gccache_wait_and_mark_dirty(struct buffer_head *bh)
 		struct inode *inode = bh->b_folio->mapping->host;
 
 		nilfs_err(inode->i_sb,
-			  "I/O error reading %s block for GC (ino=%" PRIino "u, vblocknr=%llu)",
+			  "I/O error reading %s block for GC (ino=%llu, vblocknr=%llu)",
 			  buffer_nilfs_node(bh) ? "node" : "data",
 			  inode->i_ino, (unsigned long long)bh->b_blocknr);
 		return -EIO;
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 0bc1c5141ec596b3c31e7d18e4ba3541bf618406..51f7e125a311b868860e3e111700d49d4cb98fa6 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -108,7 +108,7 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 				 * be locked in this case.
 				 */
 				nilfs_warn(inode->i_sb,
-					   "%s (ino=%" PRIino "u): a race condition while inserting a data block at offset=%llu",
+					   "%s (ino=%llu): a race condition while inserting a data block at offset=%llu",
 					   __func__, inode->i_ino,
 					   (unsigned long long)blkoff);
 				err = -EAGAIN;
@@ -789,7 +789,7 @@ static void nilfs_truncate_bmap(struct nilfs_inode_info *ii,
 		goto repeat;
 
 failed:
-	nilfs_warn(ii->vfs_inode.i_sb, "error %d truncating bmap (ino=%" PRIino "u)",
+	nilfs_warn(ii->vfs_inode.i_sb, "error %d truncating bmap (ino=%llu)",
 		   ret, ii->vfs_inode.i_ino);
 }
 
@@ -1026,7 +1026,7 @@ int nilfs_set_file_dirty(struct inode *inode, unsigned int nr_dirty)
 			 * this inode.
 			 */
 			nilfs_warn(inode->i_sb,
-				   "cannot set file dirty (ino=%" PRIino "u): the file is being freed",
+				   "cannot set file dirty (ino=%llu): the file is being freed",
 				   inode->i_ino);
 			spin_unlock(&nilfs->ns_inode_lock);
 			return -EINVAL; /*
@@ -1057,7 +1057,7 @@ int __nilfs_mark_inode_dirty(struct inode *inode, int flags)
 	err = nilfs_load_inode_block(inode, &ibh);
 	if (unlikely(err)) {
 		nilfs_warn(inode->i_sb,
-			   "cannot mark inode dirty (ino=%" PRIino "u): error %d loading inode block",
+			   "cannot mark inode dirty (ino=%llu): error %d loading inode block",
 			   inode->i_ino, err);
 		return err;
 	}
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 8629c72b62db33217d4747124885b6f727f182be..09adb40c65e505d92012a3d2f5fe8a5696e10056 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -203,7 +203,7 @@ static int nilfs_mdt_read_block(struct inode *inode, unsigned long block,
 	err = -EIO;
 	if (!buffer_uptodate(first_bh)) {
 		nilfs_err(inode->i_sb,
-			  "I/O error reading meta-data file (ino=%" PRIino "u, block-offset=%lu)",
+			  "I/O error reading meta-data file (ino=%llu, block-offset=%lu)",
 			  inode->i_ino, block);
 		goto failed_bh;
 	}
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 29edb84a0663caa4b29fa488c0495fc53358ca00..40ac679ec56e400b1df98e9be6fe9ca338a9ba51 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -292,7 +292,7 @@ static int nilfs_do_unlink(struct inode *dir, struct dentry *dentry)
 
 	if (!inode->i_nlink) {
 		nilfs_warn(inode->i_sb,
-			   "deleting nonexistent file (ino=%" PRIino "u), %d",
+			   "deleting nonexistent file (ino=%llu), %d",
 			   inode->i_ino, inode->i_nlink);
 		set_nlink(inode, 1);
 	}
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9a8bc3fa35ce9b447abbc2fb56cbd2b0cc5f76de..4b1bf559f3524b1cc3965dae9fd3e5745718569d 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2024,7 +2024,7 @@ static int nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci,
 				ifile, ii->vfs_inode.i_ino, &ibh);
 			if (unlikely(err)) {
 				nilfs_warn(sci->sc_super,
-					   "log writer: error %d getting inode block (ino=%" PRIino "u)",
+					   "log writer: error %d getting inode block (ino=%llu)",
 					   err, ii->vfs_inode.i_ino);
 				return err;
 			}

-- 
2.53.0


