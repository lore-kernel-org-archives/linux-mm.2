Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB06EEB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2E76B00DF; Mon,  2 Mar 2026 15:35:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0866C6B00E1; Mon,  2 Mar 2026 15:35:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA0996B00E2; Mon,  2 Mar 2026 15:35:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D510C6B00DF
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:35:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95FA114031E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:35:07 +0000 (UTC)
X-FDA: 84502277454.18.CB0B413
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id B65B0A000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:35:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZnKWjhh;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRqo4zm4VDfEBNknDdZzO2GQTzxOjD0oCw4EYxzR9hU=;
	b=Qcq2PLjTBhWT/WlGcxJbjxvYBKHFP00PwpKlvFbEi4haoCU2s0CCGYk50jKeK2pPi95pK4
	r8/Gl7bss6ZCU1OQCFyjdNKPA8HRjJ0Q5n+sW2SfO7J25ionzqKqHtWFUKD4ddMoHuXTo2
	pHWZDeo2kz4LiksE3lXq4MpgyJ0sssY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483705; a=rsa-sha256;
	cv=none;
	b=bOSaltARTq3nI42TKKI+SWWnOTCy7Mng+GXV7reU/6/nDNXx5vv+1ObIV9nj/tJY5IUWfL
	c5lqT8rdtv0M0bwnA9ExHS6x3Q+Z2A5fs12C8qKfblnUWqKjChnZ5VAskgqhopwcKi6hPM
	CYbAV5HnacRDdmLIXl1hciX/3+aliFg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZnKWjhh;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C3E6C43FD9;
	Mon,  2 Mar 2026 20:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA61C19423;
	Mon,  2 Mar 2026 20:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483704;
	bh=RKZuUpYb4VtVZY0tH0L18QSUQGxUCRV4jJmOJLJer90=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SZnKWjhhLKLCOwfXZfRvrOlHQATC4wmHKSpLaBQfHZNgeCqumK05mKsxFCUqX+HYK
	 A81tD+yqVOnm9s15f3Lm7VADbRBNrD7yTihefXqKDq3Mxe31M5vtcmMS3pJUzmTSrB
	 V0414pYxtBvqe0AhQm5wloTuTIx1yhiKvOGwInIJfrrbROKGSMOGvnKUCKOqTCQWSg
	 aelcfW2o4Dz/ryjizLUHw4C8TnG/DqA0MkhLUO5QAE3MzaXz7VVJaltXxxZRSTHm/w
	 yvLrlgvXWeo+mafAqSheqS3hKXEP+lY4FT9GJgkeELS7Ry0TuorMYWKFqrzdFfEt5L
	 OQTjyzwJ13u7A==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:26 -0500
Subject: [PATCH v2 042/110] overlayfs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-42-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2615; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=RKZuUpYb4VtVZY0tH0L18QSUQGxUCRV4jJmOJLJer90=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH5iFQBv8bFDBGTskC/qmqUoyRayl4RP3EIs
 HIhZ7GnlZOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx+QAKCRAADmhBGVaC
 FSYuD/9KUJo+A9x9CqKLjm3IT49I0BM1OGM6z/GI0KzplOX4l8uCoNg4oTvUPK9h3EN9pfGfbuW
 Fpg05zCdywvEum0pxOxTHWX2MEapQDU/3CIwe/G4R9SCD74ti0kl5PAfd+YTOxEesyxhtEy773E
 8VBgA2Ca/DcoCYrAfJC6Is0SoaFBio0qig/JUiCKUX1jV8ChLSUStO9OuQ5XwafI8cQtFfmqgKP
 cFMH9EsyKw7kAsb+0wS7PvsukcGuTTNUuz+lg/TU2nK+4HcBqsIiSdlhXx9mig0Oj1otHB6+Uc5
 WmAhdnJdFl3XHxFEVRdyuGyxdRBF7fqll5lx1/dnlzQGKJLFo3ILagKqERFvChq3jVxJTsJ1Q0/
 1MVfVNA0TgjhP3sOFFe0fEiBqqOGv5uQUhU3WknYVFsSCnio0rRpwhWlPG4iwj/aHfT/Y9eIi/Z
 ObSixQ09/kvkhmv4j4tCDnNQVTriAthi1yDdqvwvuEAv3bPCwNs3Gva4Kv26GFhbNyiYHLwPkog
 nDWFwwiUMMKMOngjBrMNjMAE9i2/CKRtcoPaykpf09W2vVii4JVNEqEyZTXxN+hyf0NA9vGh0dJ
 U5K1GFTKPj5rz45k4+yWSeU+ZKDcZpMWfvFlySY4TxnBnb/2+9GceaFGoMLwJYJAOpY3YsGAxPE
 gfeAKoddOxoBSbg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 5sj6jmeu9oo8qh8miqpri6erwrk5setd
X-Rspam-User: 
X-Rspamd-Queue-Id: B65B0A000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1772483705-952803
X-HE-Meta: U2FsdGVkX1+G4Dp/CLNiNjsJc2LSP0ogWHOx7Q+JVOOPOm3GhmfJuGECBrPc98vM+Tuj/wdkJjijYCCepYv2w+IgddEQfY5r+GOfeSWO6hefqmtOHuDmcJUV4A7pBXPwzrxXvWzjTdmgAyfTZWpgPu8VIexE/W3DzmhlBg2LX3Oiv1bzPRSAZ8JsBWHrkuJT+f04sd/14M8XDj9WKIhpdc8qvDIq68HK0KYtNP+tGbVIbAW8bWSjNgSVY2DNN58w9PZ4SjnNRCy2fWFQx+8TL5fll6cs48zguffyrBAenBdzQ+Xi1GLTdlHFs2jdbGRF6pG0+HbuZjAGGcMBTsRG8897oL6u0I1kWMhQn2QhWWTLTPL8HKAwpPQU9qwDat3lGHRwOddTge0evreO0VZWicbw/y+NoOhhw+koUIZcWJSYBAHmqqIJcMNOwhoZww3kvZdjzH01CVPEaywev5v6sNS3JxwMguhRm7x0tNZWiyhTWTRvAnrO+PjKIxU1tCYoqOY0bMqGD3ITILkBC7FH7cqOkq3gv/qKAIxjYMnSaSIxKz+Tx1jjqGTwFr8hPn0bMDUaOgQwu6Prs6sLYlicm65vkweELEi3BN9b8m7lTJ6s8EVYImndgri/ysu/isN2ZpzaqK/oHaqEmiJWtfNxEJVENFYsqxDJX/cVuqF9ZMxV3KVHsUmTgEBJ1Vtxct0NeeYLVYwRsov6YAVfxhukLMnhjChUd2/zzRnZXFC/luxH9p/8rr7NOnrqb6u4lYp6+9j3eV1hSsxHDTyqao+OHAzAPd0faJVWwkz4baewAwzsjwpW+KoMxvKYg5IOAueNxmIuX+Bf3FaIewO5vKa2WF+adtvNUhns6CHWnEvrMssBVWTz19u9ff4qFSXuwi1jRweMkUgGOtyLR8pe7r16ObLaCtxa6CnTs2+JeWiIEcLgI7Nq+mWHtWTNnOXmM+ziIs7u46/g/0Rh8ouh+lT
 i5sPg+jZ
 HioCGB4bDRIrjLT7YTjYsERxiewc6jwclEntZzw1glOFNuop30aMlpmajUGOz95xp7WG0LcuD3fW/bCJWmBnluLvXCKpC0RTb0Dn88iCvUNGywSBPFoYyxv69y9KrVNYWJHEOSjQ8snvcNRha2r0QRr/BaaoQtGeFgr26AJWSC+eG+ucfSzsl5+dHF7aug7wIZL5PbY71SxAjLcSt5GeaIUp34phKQAYY2gGB2Soi45AO87km7DZhzaw42G5ASwh48MQw51aB/CihMbHzAYrjB4u7dW5La9VRC10lFRaXd639Uiwu2AcTuYvLwUHfXG0SmzHoTCqEWacUNs7rA30yHorelwh4rgCGnskj3cv91p+qfqD/ympu+qAmlMrJGB4dzNyJK+tqplLyP2ALBPw38IeviK7kOfXSsguYqXLRT7o5ThDWS6ysxm4ZnzO6YgmDNTMzUaerVO0NWr2vaIz9Ndlg27ZQh3380oBok1/w8md+ISO3SBtwthdfrk/0VS3qMpFQPp4SImT7IgpmLZ1m3BFT6Uwyo2lpS8e+4kHZPXn+E1kDMCUDYHrnMGspJ2pDbO1HZawvhFxPFhdxabB6lISUs/6oemH6/xW3gavGDyCBedXu3JRs08OKiawRoMzjm2PnqLRdcp4oki2ctOCblzxc+xRQO4Vh0Pjjt7duUm/Zk2Sugr5mloJmD114zQuoScb0K30suOkeaJAg97lkstAuzwXq6NK69uvQxCVU7WxyNXUO/y2Ec1XcAVd9ybAarlbsh95CKKT9np3w3V+w5U+L3GfaND5yHv06prVofMWUztGcPQEovWcFwqoK9yIiWpaTiJkYymjri9kKCrpwgP8kBSX9ShOoz8xRV4z3fu/ULvMtm0Qvqq0R/RoqtaQE/u+vWQMxZjifn1LHMLcaVp8p8kH5MP0GlkokRJWQx4w3q6z8ery8I9023SmMVYjbmRv2zzLH+Ly+7yTmwyipN9hSdtqw
 yve2H1KV
 vuf97dKyBW4BPT70ThR5AtLO3TPfDizz7hyzYSzMgPvzGM3raSAbpcG4lonrEfqQ4uEN5EEkK0VsWHdqA8gV2/OHXQJ6T3qlfAobm0Uy+G1HIc9+nBV+YY4apOQDH0XOBodGAFd9lXTbxdH1qmgWMc4pdLgrIesdJzLuby4Suo4Vc6LSjQ/F22416kuKDgLACACFDUlc7Xv+iKwYz4/vtz13k0zz1U7fYsln8Ls+0Lexbgh84iFeqyiqTfSaVSgFekaWQzmVagCxbWHKTHBVacexD22g9nlbzan8jqByOCKv8+Wfy9UNDWJQt3HxnEAUO4gBqQxS+H1yG06vF/JQjwBcJf4HSKo8+yo6NlobTV8E+RLgySjH0QfHeeCpRi02Ygne3YXPTUJYCPh0o0TUQ9WxGZT8Lgx9dPKMuoUJRFt58sne8pv+jhyq/ZzJSoFvqYIN6xNE5UJqbimqIiD/lB4O0RD2kXi1cxGAIGvhcSPLYb5wY+j43bsprWvrRGEXWuvp9Ye6snLUGFo9iXZwMuVhw7s+WwxjgKzPKmh/mw6xnD8dp5zFzev54lUKbP57U57tNorkjIf7WOlxp7fj0gaR+yChXkHCCp6h2PIKRYTwPSqHQWjdT4Sq5n1LIspGaSGHQh4lsCOWqlXDzFvloKDvxWLXH1SL8QKrIGfn9nEKDqpu1Zaa+xswAcBrDTs2kQ+fx0VbuhX1KASgMI7Vymre9jTsX3qQLU4DtsIPehF6jUiZvEaIACOjYoRlrT/ZHRtkuAcox6Fenj1h1nejrtUaHtx7opDYwoZoPisC58wDM79J6amNNTv/O+s7Fk5tIOWtYolWMcSKdKPuyoyzjc59ISGYq9ouS5CdfptMa4/kIolWCMsO4yPvE0CetqfDE8dumyJDF+BsHch+5xfZXJe1LBNiNFtpHqVEVszukX8CIzcHkHUMXuy525FVIallWUBqWERgyPfA1UkghJw7Hjz3L3dU1
 GNK2mrBq
 9hs8V35EF8IcHANQgHDa8g+E5lNvX9EiMSieWtUW9sdv2v4vJi+cLkFEc7wW0z7rLaW2pRQeegrZAt2SdstVM45w72c8wch3n2NqcXVS4IULmyt4LkFupkkipwsaOezZzAGeYw4zzn9xvG6XhozKAO72tcJbYGWVSTSXaSeD/HT1lUEZW0w6hl2yli07DABfhKA/HtMzgTpj0HmzzaImm0mz6lcE70511crLPf73LZu5MJAquqgEFjfYEkDUaDOEHTekCGzaEx5arEOKlnDBYaSXAA15ycWdecdmHlOyPsKzs/mq0XqX+NbyXgE2JWsrkmNpE4xUqB2GAKNq1zIK+6+GkpKKxBZfHpNnIHg97UiH7O86ijI7+y5fcao9p7KY9bebs4EkjxjdDGm9vpTgGCjIYoGMajIBYoWLr/reNaPd2BTDVcwCISEqxdiodM23QOeDznT5Gd7P5UEDTw1+B5TUtfxFzen9Z/uwoWyADiSGEvgNBDnEd0sQHzA2YJEIDCTi7mjStHAcdFxkRz+TZUh9xKoV4AIYO2B/c+tvolQLNeZZyJ5F5MQnFOqOSV5NGXiAkhhPP4j0dTVnt/MM4DpRlhTOXEO6Ht9ui+NcvZr0pDT/oq3RM79FOb5V0qrkdSbcp8U4oy1ywBDGBwG2ichTEvWiWXGBBWMFNXgflI1SK8AKhmn6onsTu8J4kPHXfFTAx0wzePOshY5nfyu2A07aoAvJfTMKP+47RHCBPiESg33oXHoYDpUa+h39WccfAvZtfuoFzUDJ7ZpPtxoJrVzsz+AOeXxZ/8FK0jrB12ipCFee9huz5/DmI59qhwOXV36+eMDWnR8O0jpsjz4EWSz0JBbpHF0sD6Lnl7H6Js4NUaZC7dwXSJyiqaJuYiEScEWS5OJyylUmAUxzCkNHNqJM31BqaOE1wfi5MmalLIEBadpQNR99hzTPtGyGY4kFS5QqhSyqRg6kQtaPpLRIrzXHv6sqk
 K+e7yXnR
 ZcbHJlp0Noo6dpz446dP6XqRnlubiEZS3KvxsXrDMVteN18dQDxuaLjhyXjFGP50jKjiBaN29GJ8wy4/CePsuMg0/Wx4H1N3xl0AsSU3jCZMaIoNUc3BAD3SQUHN6kRSWY6p+Eis47lg/w3n3Qe0Te7fGkrjH9H0yO/dWtLeOgBkRKzmda4es6pWL6P8alHXJZb57AG5rMGeSupB2aGxbkFFxK2MR49vaKe82vjHJ/lgmbmK/kmEcarFP0grTQSYGR3GUHL8nqAfj2NoIKlo0hFJKQ7G5RWxLlLgUo0Wgj7p7ihuabUQVVGqjoK2q6X5TgBlO8D8cos3gwDZ37BRMJRfITngVfmK7THmd00HRIKBbfAOTsCsder6eY1WUh83TEDAzhvzI3/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert overlayfs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/overlayfs/export.c | 2 +-
 fs/overlayfs/namei.c  | 4 ++--
 fs/overlayfs/util.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 83f80fdb156749e65a4ea0ab708cbff338dacdad..a17d55db8ebfab7e47f122eade22b96505392b05 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -262,7 +262,7 @@ static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct inode *inode,
 	return err;
 
 fail:
-	pr_warn_ratelimited("failed to encode file handle (ino=%lu, err=%i)\n",
+	pr_warn_ratelimited("failed to encode file handle (ino=%" PRIino "u, err=%i)\n",
 			    inode->i_ino, err);
 	goto out;
 }
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index d8dd4b0529843bc20e4efc1924c2be3b5712b343..6cab72d7f70611a83bba433c769323a8954a61d4 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -591,7 +591,7 @@ int ovl_verify_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry,
 
 fail:
 	inode = d_inode(real);
-	pr_warn_ratelimited("failed to verify %s (%pd2, ino=%lu, err=%i)\n",
+	pr_warn_ratelimited("failed to verify %s (%pd2, ino=%" PRIino "u, err=%i)\n",
 			    is_upper ? "upper" : "origin", real,
 			    inode ? inode->i_ino : 0, err);
 	goto out;
@@ -831,7 +831,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 			index = NULL;
 			goto out;
 		}
-		pr_warn_ratelimited("failed inode index lookup (ino=%lu, key=%.*s, err=%i);\n"
+		pr_warn_ratelimited("failed inode index lookup (ino=%" PRIino "u, key=%.*s, err=%i);\n"
 				    "overlayfs: mount with '-o index=off' to disable inodes index.\n",
 				    d_inode(origin)->i_ino, name.len, name.name,
 				    err);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 3f1b763a8bb4cb842e5d5cebffbee6b8dbe01de9..536504e9803e6457fb7d248036263da446569051 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1092,7 +1092,7 @@ static void ovl_cleanup_index(struct dentry *dentry)
 	got_write = true;
 	inode = d_inode(upperdentry);
 	if (!S_ISDIR(inode->i_mode) && inode->i_nlink != 1) {
-		pr_warn_ratelimited("cleanup linked index (%pd2, ino=%lu, nlink=%u)\n",
+		pr_warn_ratelimited("cleanup linked index (%pd2, ino=%" PRIino "u, nlink=%u)\n",
 				    upperdentry, inode->i_ino, inode->i_nlink);
 		/*
 		 * We either have a bug with persistent union nlink or a lower

-- 
2.53.0


