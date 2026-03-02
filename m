Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E79AEB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA4AC6B00BC; Mon,  2 Mar 2026 15:30:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E456B6B00BE; Mon,  2 Mar 2026 15:30:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1DA66B00BF; Mon,  2 Mar 2026 15:30:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC84A6B00BC
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:30:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99EAD1C300
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:30:34 +0000 (UTC)
X-FDA: 84502265988.20.779DF68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C85DD120012
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:30:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QGKDMPmB;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LdeBOK3kcjWGhtRSr2MfTAqlw9AuAsAnDPkgM9pY0S8=;
	b=1nsgg326GAgO0FzIJQxtp9Bx8Ax7/KWzo8mnjoTN5H3syjWOciM6SXhz7tzX5AFMGXfWDG
	Kn/8gYL47SRjExpnsb95X/0J0xxRjFtIc6N7qt1wn3VtgwFk+96qtO/b0l1l6eTSHFZGeO
	oBqFiYtWCEyJTyAJRYeb/GkPYpbCaow=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QGKDMPmB;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483433; a=rsa-sha256;
	cv=none;
	b=E7/J0Pe5J37WAtsOqVPAayAx/60PvYBXNB8DmOEVlHThTXqooS0TZtZj+utYIXsxwqWEh1
	k0S4nEF4mOsxDmRkzjy04tG4h4I7bTzKwS05j8xO0oMFMiPtZT/NCsOX1Ih25pD/b2tEwo
	9Ug1Mz1a8BkK0JE4yHX/vQ0njZzHdZw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D0BA0443A7;
	Mon,  2 Mar 2026 20:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92324C2BCC4;
	Mon,  2 Mar 2026 20:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483431;
	bh=HzkTCfTdbZXozIi72Y3c8yb38EYipl+Okwb/1CYJMQs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QGKDMPmBZScP1p88q+0GtwvCQ8N1XOEZpPXE5npuKlCAYT2YhxMA0L2XUBKQ89Kvl
	 0X8j4P+dsWPgrozE1MFbcLSCky227YVYgr8+XKShfglZTIbSgoD+X/2xDGc/g8tVAM
	 pM2X1ZueBn9CJyiolCVTZE2H5ofqPtipn6QFx1YpPi4xa4sXMf/SrPIwJ53cXOpk12
	 2BEyZRBvwGfVV/xqSDYXS5K1PincxX4uRBuwhygtWfqiuCSRhO40hO2iQd+BkNGtEq
	 BmtG87s8RksaPLPYpmth5aW6LvruTmJyHIs9BTz3lLue5p8SbP22P+xcjddKPGe4EJ
	 TB11oiIG15/7g==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:07 -0500
Subject: [PATCH v2 023/110] ceph: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-23-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1410; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=HzkTCfTdbZXozIi72Y3c8yb38EYipl+Okwb/1CYJMQs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH1q7k2SFrGnaDsZ6JWT0aZQUGR01qn3laql
 Bf+R57PpDWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9QAKCRAADmhBGVaC
 Fce6D/4jdG0G/SR3JVEOwPpDJIAgrqCTmUYNA/iAtg23BJ8jTnRGt2tnKORjREbtHrA7cIbnHo9
 WlBSFP7RRFt91i+5VUPZ0O/qBD0fBXFQG9PDTEbjk1ObHduCzdbjVTTGhv8NlkNO2SVokjMfGRM
 /bdjAVI7vMyZY9G0G7lh6V4kSPxhZo49nOHoQ1Rgx3FulsEAjzqk6cKdK0WuYpeoFtjB31nHFOI
 C8WxuS5q2Qe27OR/frKM11w2JIlOvAk2sO+E4k/MuemVUmDp4rpes2pK8JE/gwXyd0HZqO2IIuT
 tvEUOVai+aNZgBB9Pb30Ml3+GLHhsBHbxJuBCfUSAaMtNfccBQBcrLDEUrZJUvkZSyEddPeZ0UN
 O8r9XzGu5cqzzACzr/+1R0f7s2mRrLieZHULDNP6s5FuMJoek3/ef/9iTP0PEdlUBz8/0HfRDB8
 oGdQwzV1r0tOg1yr0mf37YDHRm/N+PX6RdjnzTDYvdGvWjOQVdTHTMXTSMzdpNnWhYDS2GXgwwF
 Fn7hv3MCYgxaptT77U4pMqwbCmJ5rdC4E1nbq7HTFqYpJlj6D/VOrKLEKCreZSAcyUomsELKb8V
 oRtmXT0NGqGTcA/82d0nnaKDM43BYb+4vzit817795+sDhSChOs4I5rKs195MoRsEqJeV1QHtGs
 xp4GC+ckXG1fDtQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: C85DD120012
X-Stat-Signature: oepcmxtya1egeh6wdamhgc6j4xndf7pq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772483432-974084
X-HE-Meta: U2FsdGVkX1/s2mTgnMFx7ZKHf2B5KbxEqyTcK0jy1iPQjZ806qbAYioqo1N/4UQwEDc4ntH4UEHyFnEuh3nfoAuSd9uLRE3ieMyz20RMRae+XtdfJAqZomb8vDlE6x4MYoe8nB8G4GsKOnOlVyCJPeN3amBvcKxz3FiK9iRyTo6OSk3D60I52H70Hh21NNxaMJZpwgkX49DOp3ABtwoRDZQnOAM4raz8EW9V+7NcPJlx+FBptmfdsFYzYtJsfJ69t/j1mTqdfUMLzjb3as3naIon+rOjY2qaWDD6VWYs+FzX4TDadEf6X7g60GeZwb/kACznRSwZeskNVgO9HoLM3ek8k68KLv4JuxW442OitSNL8GW8aIJwbtWYHuC3FZvFDXDvzAIKkD2qeuN3OwY74Hn3ReeUKxzmQAraDY2iG7GvjqkhXXKO5cKn478gkqWW3mSCHe1B6LOctAGcne45C9oefeLUS8x8g5XUy54nV1Tm4pWCL/zEz8AU9XYcCSeDWKu3PtEawjGPE3ESAdfdF0DIor+iN9UU3TxuUn98n/BheZT7nj32+33Ifw7EBperNReq79msBfM3TG/QtOwqnSzi7D9Yl7+Lq3Tl0O21foGq4amdfKyj665lMc01KEyjNQi6mT1zxFS6/XFkmDyuQzx9Yope+Xwsw1//JvC0iseEioV89ZvCevLxJvyzm8mF5WmHvbUWNXjibRwBWpvyKwF/cMd6FaEoB8JvM6DKr/Nxy7O/wQwoq5Bpw71STs7tQGeoPBxjM0XrfEjtnY95D4OBVui8xwkxm5aCt14EQIQgf8LFChRHmBn1L0vUOYS8AxTrkRjyBtDGMU3XG/YW/u0mJBElZkQIr+rXz4wtTpxP6Amb0u94xuQk8hIlUoBWoFEu5WQX/Zb1rQ3O4ZDuQnhjs33LrHBllKt+JMX/4060yrk5jG9CjL8A9kA0UpBIFrThNqi8X/8FMbXhn8+
 p7LzeHK9
 BRumrayNb8ihvVXNgoA7cGEJBTLoQhRJfXLbkhmnrWz939zgjhkxMsvKKe3pmCPs8W2lsLeM8pfFLN8TISA8wxpEe/9caMcJkksJyO/ZkAcViyYWk8jTfNV9XW+cndusUeByYrnJrsAGaeWhpAOyU0/wLqEs29MIrYhTKCCkCoEsKieB1mXmdDCNx2N+6HTdL8n1prWWsWUfE9h0OFR4fzPHbxOxDEQt83s91yEfQJvpKSsytk8pwJz3AJdMMcbflwGyGnT+7mOKsSnisV1+uWripQFEmH75kRsZvyzuAbGR1R0tImtczDqQF8xP5NL0TsV7LzxH5AaWnOpNADlTEHTXRKFTM2lzixxaYbIm2hQNbA4/I9LJTgEQMDZHtQfuo+csf9vGrJACaJN4QtOrwu0Mu3lM8937lbezRY0HYjxW5m4BDC76a10Vq7av3REsMTnA2X+gfzCtQUPSUYk6q2CdIn9vpj1ORwWrIsjNP2wedk6l+CPcU7duHxdoIXvji7VpiW6K0wY8Ddf3Rvkb8giih5qxM3eCVXHdGdDNo9pZGonExRdWs/dkZv+1r3XuYh/HBGoowLgQ8751eunT8slM0ibZtvHlp//l6ZNOcImam68Sq2CoP3YTJ/ZL3Wz3XuVDGTw5USv2d7m3hTafuHt0peoqFx9SuDfDGU4MTw2vpMDEYoMEWRV+l7vdeVmKbyzyw2dGlENR7C2C7PThZ4+wxHYZwDlS4G/UwZY/rJZpemamZC57eMkMHlaOTJ3k2kLzYVyRGwd9gbrh2iD/xjUg7G04h5G3o9z6D7OGdr888gnV+BUrKt4pQwVgLCCQzshkuA+dtxcy5PPrf3l5hloiWGXzsgmxaksMmJ73YOjyqFBuTnP4AX2VwczEO3hVMJZAwXbiPLq+AX977vLmgxx8x4cagBh3zzAO+W3hKDx3I1vZsUHKfUCELalI1DyVAxc7RHWvrhPx3td5YPE4pTLHrC3ox
 rWZfLaka
 6v5EpwSVYEN9+boeLNIBUMXdsx8rSVa2OV+sAA3di/r2zXiXVGYr1lqAGLtAzjbeV4QJjiVbbGvEWSy5KOy1Zo+AD+iYqEEXT5PnXFpmK02npI+g2kycRs5jUq5n4Fn3eh/yfYzy7AcFBRHM8fVUiPwZ+Q7DncCEwOOQNNeydiEKmX6ZCKhHpD06ZfjxHs+0mJJJKqzuM8T3fAgpQKr/nGKgc700xSCxNo8IK+NfiEJv+nM830bdzk1zRS3bm5IfhQ5lNmIOfK1sgI3PqLs4gtCksQYKXZO5NP/Ml6QfFIw6eDkaofczgFOppj8rmy44Po7faySXpkrT/KL8casguN/AmiDpfYN4u1LeqcQj+M/0SOVhpXYBxcl9YgugtuSKQjND1g7cDxTPiHXKwMTAqjVeINH1ccr6XW+3Vf2DxJJaldry9B8fspr0wiQBqv96n5ldDRjJHGh7CrPdymwXaJlFgDBzANwHBbU3w+akuIeRu/MzrDrByhKapnN3dSFilt6LX6gCY8TUsxhp0kXvdgHXTuWrfg9sfTFkwmOlbLqg+eCyUML3l8HQjJOhHG1f5XAWCrLplci2tLecOHkzYpPlhriPsr+DKmCxPr80N6FPza+TcBz1toccSyJCf8QRzD6L/qcbMZvsgL/hguAJ/opePiRY0v1iVPlJsDEpEOYlKC7zHRR9BbaiI23u4u7ClwYNs6EB1lU0AEArZXC5yHyzystBKFxNTv5YSu3i3KwHn9EnQYuq9IKrvfu2NHvydq8Ztj0rUr5VQ0kGvbF424X5H5VhR8Qi0byas/WchjoIa4eW7kUgP1bcvRnaP2EhTf737rgWmOZ+0APpswurylSLQbes00Y0Gm3YVx5oavB6MmqrMnY3pLjuVkRLLIsSIvtRwjhT4jypvsAcnZUowZnLZyem3j35nr1e+/obWU8FjrTXv4p7Mqyt4eilX1Be9Emyr6jO2eptKDENZIySpCfIxqKe/
 GMjA/yFZ
 1CMwVzYCZBeBfg4G5XqgQZDFITTtDYDUIZVlmE+Sxb3OzztOseP39wGOxqjVJXTF7aZx0vPQLvZ8BrXzNe3LeEaV3h0165UhDGKobC8zDYzqZlxiO99eYBkYSKh0rVru2sP7gaARTjBpR5ZX5lk6rHw6PZan9Bp4dANzurFlVf+I02LH0ziqwbJaJb51hflMTfSTr+AeNQxaA8LY6BLW0P/XELYmW0LydhfIqwcQAiOMmf7z8ppihEhHgCLyJ0cFQyp/3lPU1KftUBEVKpZx9pej8uEe3W7Znr7142M0iFcwBNphyIZurnay+CydoGf1FlYpuv0mJvQDKcIMJQxkprA7moN/59qWQ59ynNWj9tiKQevbj8ZCrn/BPwJE1x9VU5cDv829yUQpnqJPfafX+sro3nLhJKff0ewob/m+7ijDLnLJKnTL3ZDuJKO1S8u/C0DkKndqLk86zUTKw6a5pZZ30jIGPG5A0FgvVaNHIx19B8Mgu+lfO6oXsS0okotKSoCp9iyEiD8iKpa84d4BhkhjN67AO/SHzGyV40UowknaQqvbrRB/pRBobhJtMksYnfAnWaDIIttnVUSceXpHInwKOJc9QVYCZDxugKKDTZP/AGHzm99EUxF5/OWAFcSwUWVRVj+CO1JiwAh4m+KHnJL9GWGX1VIeiKA762k+hG9lqg/7q4+6n22SMfsEIjhMeMgvlc39Zjlbn/dvc6spr68SEGuxSKCEUEuEYDXDOd/aFiZeTVfIypxKA+ENowdm1GAnfF7RIfuemmce3F/3YHJbsJP14W2pxQ2LbB/Y4pQj7Om3t8h/GHrHQGQymuKyYEwYHvem2cAR3xgFnXICeE0uqrAsvnJtSzZ++FuGqU7rznnQq9o9OxCE8w+XNxgDjKjxl91sByL/gpzuhiyk2qUsk59HJIBrJiFroiv9HOU62smuw/W0y9u8E6eodmQx6cRDzA+WvIRcaw3VBx21euZeVuUIT
 hU3F8IfO
 +Yl/w7GE/BZbjecP6Cimef5kdNVed/frEJ9bkyOu9RY2TAbmtWw/RZEUj3cGuS5q5Mx9DPbuHfjIbvkBS3RQXe+vsYx9JZoPxkfoGJFOX6jTrUMpNgcW019Tr+kzefVkR4Q/g/ZvN2qq7d5OGH8ebub2Tg34wA1bSOwrmHUoKTBTpJ8bpmH5hCv3Jp+9ix466bWCaWtW2TY8eXTnJ0lvoKOLLcEDlh/gCrYtzE9MTc5Ph5NXrQYmGJkYTQcDuAQFRmEyklQ2otc/IlUUax1b/GvtFyNM+G4KuvuvQr6KkZuEfo2A7FYfoJUu8bFQqFApiLrA0hTk1abYGbdd35g0UNypYvjJxTspc/EdTlR9W55zDdZby3qCUVoVNVoMrBQSizWp+GBeK+RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert ceph i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index f3de43ccb470ddbd7945426d79f9024ae615c127..718c194ba5d8ce22c6a5d1dd687ec3761263e7e1 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -272,7 +272,7 @@ int ceph_encode_encrypted_dname(struct inode *parent, char *buf, int elen)
 	/* To understand the 240 limit, see CEPH_NOHASH_NAME_MAX comments */
 	WARN_ON(elen > 240);
 	if (dir != parent) // leading _ is already there; append _<inum>
-		elen += 1 + sprintf(p + elen, "_%ld", dir->i_ino);
+		elen += 1 + sprintf(p + elen, "_%" PRIino "u", dir->i_ino);
 
 out:
 	kfree(cryptbuf);
@@ -377,7 +377,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 	if (!ret && (dir != fname->dir)) {
 		char tmp_buf[BASE64_CHARS(NAME_MAX)];
 
-		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
+		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%" PRIino "u",
 				    oname->len, oname->name, dir->i_ino);
 		memcpy(oname->name, tmp_buf, name_len);
 		oname->len = name_len;

-- 
2.53.0


