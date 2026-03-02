Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72B71EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D68E6B0005; Mon,  2 Mar 2026 15:25:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A0E6B0088; Mon,  2 Mar 2026 15:25:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9666B0089; Mon,  2 Mar 2026 15:25:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 656706B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:25:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D4A81A02F5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:25:04 +0000 (UTC)
X-FDA: 84502252128.04.E4DF915
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4D14114000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:25:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cHu2iKyX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mXh6rRb96LlNMtZtYzggQvLzGUmAXVnrsMQP585tqh0=;
	b=wzjezhfO3j9ivq6gM6eL2WQZLz0i6a2Cag2/mA9Eb/s6+Z42z7o3fzqAmSeb9NYyipSmYm
	IblReBQmtQNPW4Uc+GMxOghSWJdHldBhqRW8tdu7hL0x34NX8XW11WfAFzU2UXK+tcit4w
	AxI0U+FBG1hnIrDLyGjzsj3WBr8V0Y0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cHu2iKyX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483102; a=rsa-sha256;
	cv=none;
	b=CuHI5uWG1ThKkBqE0bkKz5eMBtivyxIZjbINB+obYCbw9Kk+gf0NdatuMRTk9rDlxpQFcz
	KI2tIyOsSwgshAWKDl2Z2ufLDOLM77IuWSrFoNE1k/xO/Q4j+Xn5tNDougVWgPx1TMUWP6
	baHSVgB5J/13wq/qPEOjG/nUqlZQK7g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1895E60128;
	Mon,  2 Mar 2026 20:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A61DC19423;
	Mon,  2 Mar 2026 20:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483100;
	bh=QDxKqN1aWhMFnYUc1odbHS9kXFhMLp/XyZDDA7haX3M=;
	h=From:Subject:Date:To:Cc:From;
	b=cHu2iKyXY4agdCXmzBTDMnWRsTQUGp5Gktu5PjqkGlbWkkoAeX16dS9tdaoGxdknl
	 ECREpq3HSxntlz7lhfo6y0K+ACEDdjWeefDfqI25+p8tgIE+KlvY0ocOG/250z/NUd
	 783P3OQ4WB9AiB5sPNyVimRd3CmDJpBirkTO5nNcE9FkcLBQJiHm047n9ry/lUhLmZ
	 8VfN/gCFGYQfg/9Cc+9XjaAznMYlk0Xk8nFQRiG0XjLVZINPKn4esjjGtcPyeRU2m+
	 5a/4N3NEqGX5mpRhsogEqjxcpHCl5Sx94CTDwccdE2qLMWHuWwvhIzAKGfzA+kRTXF
	 4qC+K6ZAZTEXA==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 000/110] vfs: change inode->i_ino from unsigned long to
 u64
Date: Mon, 02 Mar 2026 15:23:44 -0500
Message-Id: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/0XMQQrCMBCF4auUWRtJ0xjRlfeQLtJ00g5KUiYal
 JK7Gwvi8n88vhUSMmGCc7MCY6ZEMdRQuwbcbMOEgsbaoKQyUiktiEIUT6PFoLXt7FEddOeg3hd
 GT6+Nuva1Z0qPyO9Nzu13/SHmj+RWSOGcQ+87Y8bhdLkhB7zvI0/Ql1I+4af1EaEAAAA=
X-Change-ID: 20260224-iino-u64-b44a3a72543c
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=20524; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=QDxKqN1aWhMFnYUc1odbHS9kXFhMLp/XyZDDA7haX3M=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfHvd6Xa5qPNp/iwSU34NwgPJFsY1EsbhO8Tb
 Jb0JQrC5vyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx7wAKCRAADmhBGVaC
 FTEqEAC8R2eMoxAYPwc4rs0SZobO+TNnW2+wshdq+W5N+hB6SQHLM7D8eeK7DbkPGmwlkqmar1o
 MldSWfu0J48lOe+l2K8jhVHfsKXIwkBqFiWnz12nS7A88+2+RSFKcvwyGakxgC+q2KYigkxYuej
 FXLd/Lea5TS/2oWmUcOdQxWQn8tWGthL2xgN4TyQOzOmIhSk7eaf0qcaVRGhLv0cZfljRVlLs1A
 VuPWTsMaBTwkSM+kCDDg+FqP5m2qJTarTVChSYBDbCf2Th0vi2Flf8kid2djnAh31USP0ENvf8f
 1L5WjfZJAbsTaRy0atgpFu/6/1xXVVBOGKN41KQHdjAEdBaH7wxtUa4StjjCHPgS7072hRNMepQ
 5ZxVVkcEMbVO4fVkWJ/HGi+kKu7V2TnTvzxpuX51SGIecEGOXMG27WpQmEUBbUUt5e2nIeZlYoQ
 Xh2l+VCVvGZSO2GOoPjJYMWzpdQOz0m/SsJNKKD5I3W6abQyRZ3Bq1NcV0x9qFOTP3zgsoFHZ8D
 Q6uXGkJY/tM88Nf3ZoqNd0MuAdXY4RMkLIvw/3ctvzbnsxqpsZIxB6KGyA5RoXwI9YSOcazwOx5
 ExH9GL2ezwbsZqa+JBc7f4pB7IWs7vik2BzUiXCw8tTGMoXJii2hN6IbaaHRoU082J50be/PP6U
 OLmKwAFXV8nvtSg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4D14114000B
X-Stat-Signature: whkiswre7axtkcsc8oqmbpnt9m54888r
X-Rspam-User: 
X-HE-Tag: 1772483102-227570
X-HE-Meta: U2FsdGVkX1+u20JfYz/X5z6haBLmiIohh5S434qoa4VWp6xLvc1Rsyzcz9Fk2297aXbeGMUV+UzHKf6nf77sOT1Ew4sKYF9hTok5y/vTqvEQn9Wca40Y30w5bgFZrBiVkmdlcx4aPaEXuvin4bTFaTGh3snq6q72rnN0R4CCRDerxsc/XRLya4mNRi/0FUMuuflU0w3mn18Rg8QRbTO1iwtmdFrs3I/FqhvUAEzOAhTHkTshhzNqyDrOORUeeLaLZ7ad3HcbG4IGcnJZ3x/Vl6Eqdxw4CiYn+5ni7vH7DnD6RudsTDCMU2uP/H5BeqnzM4QfPVQ9FYzXOB0ede5VYTCR0MVvqS8NFFtRBcpljaibryV7JiGtB0zwXecZpFDR84GmBAlIZGp6zHm/lsW6UzEbKAh/LzkPU7ikWkbDoz8Af66AEa0tefnr2ZOXw87ZVqccwpXmk/nS1WlwMFQPmWeWziTq+Qiu8loBErx8x608C0VkZqNpNa7792EDWua3Uf3jfKU5/qve9MMpJEw7m4j3IqnE9dYn8mMQ0eSd+txQF/KRP2B6SpR6yQ7CNSE/HcnxlZtK9Zyc+dlI/uxSLwJWKjw5sc4KEE5GjSiOIdat0ObL3cMvK6KDfn8IXGRIjCQRoOHu59y+/8jWC8nkrV3dQ8SlS3uMncke8eG44L0Nfj4OeuN4peb0S5bJQbQh52cjCUUYxPOukwXGz3wMk71iCnsgO859KhxNQzBIHZT2rdnCLEYVwzKbTcb/nnwD2mTHn8lVHoE5oMO3oIhVPN+BAwU5MVOfL/eClHn2WaXRwCuAfCVDJs+gqrmfgVx6uyqZJXzZ6OZ/hZC5GNiTDO003MG9RCkxcu15Qa/qew60eDZCjw/swoSkiqwzB6pgNh8JHPCpP7cyweUxcAXBF/oeN9YZU4HKopOOYgItLmX8XGOPRzjXFmA3++ALamIkCbxshz3dmzyqkV4X/zp
 B22/ze8M
 uBp8Lsz3eHJlTiEsLPph52JRUBbIz2xioStVU8LljlW4Mlis24HP7wlsg2i+wXxbo4A66fmvHiQpNOg0waXHrk3RidY8yYvuWZ6or5gEz1C/rexK2sG8iCmPbs4hA1Pghkm7IPuZPBuq9WlL97nMpX5AJzFA3usVxTZLbZA+ynwhXMVnPlI4ceUiPEZZcqnUM56LEFSO4fVxSPRjFRdQJdSFBjVz257qic9OXrwIUDJVseenBOdog/qo+xJq0CCPuVMyB6qfgmTY5mQw/IjuOCIaE8xH7mS2uSCJAVQwIwXV6A5iqMK1VbmsK1jw8j3Diq6w5O+aK4DHoxJP58Y64/kbt7jasz1WYMFqKrW3AOgFttOSH+ME3BtxbDM9cPW11+Q8KpWpCbsLK8XK6t1GxZ70r5LiultYiWToD+GbwZhax+5hAZ2rbsuqirogI+k35dmbiI1JiBIvpcwu1CiCXfJsZI2scQNflLQrXPWYfp28o7H8YXzkxBrKKapeDmV+bc6qRrjUJjMVQ76tFdZqiVypmXRbsEU/fdJnNHb6TetGGEeKInTBstnPbtbudnhrrBhwOXjVaHCJIkhcWICH/l63t77Uc6ukkjLGYeUuO16mlmA+64hiQe8NUWwzz/bLb39kufyvKvNFXOkpxy1M7J6edIs8Wa0nccBkxzVojPnAXLGUdXzGLjtaL+M5HhIzV9+XsXc+U3qm0cpSv87BnAGS55Lcg3D0ieP43VBnOXUOXDOBWfJSPoWNxa9bOnMEUz9PzV6+cVlO10g4HoDDyrzziil/Cddc01E5ZsUZ0UlZpS/djRXN+/xsCyqd0r2UvZ7KKSSjzMUeLN+TMk1aSztERdx70Ys7FiZHHvEpchR3JesltQnbCGKMXzXbsOraFVJN57PCQT5zkz39jVm7Op0CkZ9hVVj8nnx+vsj1tcoK6X2Zo3EkclkL0YxjEBun3lsZ9VvN2eQXR9p4PgaA61ZvvyAzV
 V3Gm1hA/
 KDtAe3j/jisWZ+lAYYtZapv5jvKI1QYE+SuIqbnS8LbeZkjWe9QkO4wDX71qzN2aKCO6PS1qy4ZmK8sS0gRBzm99QQrEwc6G3cnZsnnvQT1oquriw4KMME6uWZOvx6EvYzdR4wINXRDyql7nwmOVdqgQl5oADltRK//zRjxpQc1oPc7M8ZkBNNllFZeyocN/mtFrqus0HyQkIGtZG/xi7G/lJrdTP9+uAITsPal1J+z1HpyLKNKfoz/0uxgeDElMW4E28WOR661n8yOQTt/UsnJYS8Rtesl4LF7OG7b68RlasfrN51QQ1o2PcHlAAdMev4cIaty1n+jh0mMSmPdPkiCfPRLKQyKCoOtscB/kfALiFHETDClXRheBNEPjSzvBGTT189sIPCg4OzYBPIhfPT8Z1mvomkQTuNynxXRTs3V95KNCt05zbOs0y+muKHB4yuPOxBKz6WMoyfQM7ouctkBRFQJMjkoLvsIw8THq8BMawfTWirxSW7i3aYTgSJYQJ6OjZQYVG+5fzg5uiTXmxnvQVQs9yy9mjJrUwke7Bmyhin6wtdA3MMeBMdQwRwcV5fGgSBDeOsQ4QhJkif69hAtghmvnLKr49r9X4TEfVE4Da9X91PrtnVZZtvvlkOVqMm5mC8kK2FaTBDmr1/dV7xhYoIDwZXEFnr5UBkvwW2i42Oi7At3TB6BhKGpb3hGcsqUWDXdQa4OZBQtidQKMvBvLLKJ4vrPpN/uKGKtQjGkv/YSvUMqeN1SqqtX+GhDNAwjoHC9RTKPM6dKPa1cARaUrUaa7jPT8ykzJ05o33glRxbWMn4eKpNWT0s/jA6jF82izJtc0+gMHlKRSo1uAvqy8puv44dmRfOAZBra2z/PPxlD5zaPmA+4epjQTiD22+dqiYqaVwv3utYmVxXQn1WjcS/l9LClYbLb3sVHShGAmOXVNkZbFuIrrYDbyY8wztqVNopFI5L5GRDx9xxY9JgEOpOc2W
 VeqMoEMr
 qLhqAuFwB4pclReTv0hHKSpoas5kDHbi3sySiYRyHps4BgSYnUGXEXie+pbjRFHc/dnUzIXQVo5wXXOjkRTVac1Mx/1OmGcG/ZC2PFyE6lCosR3AgI94eALIcqVGUUpg4eqLEfhtSWTxjDeAwyVe3IUyOZhkoW6QR6Qs0ZoKoH4UDeTlP3fu7Y83FOSgnUXK7q5tg8nsLRbrhQAQC/GAOfcHcRxmEY68GaHvKtiHFv7oqOwU3mnMu3XvSKnsczlggtBL9R9iR73/v5Zuwrg3InWChS1cXR5Jf9DBcvpSh+sOWtaNO27T1vt7Lz6g3Kruk+rEwpz8FrzKPFZ2dMxQw6O4O04oZdrnElNvXiAQqCCp3ujFm8ONKP6TiycGNfWuzUNNymOSJkk8zQaAFiO70+aHDIl42jAetsGMn3zJXPh8mCFVlvjdFctmljnQEGkZe8U1uZurK/Qa6DmJFAEWprXQN0z0TjGOzoJJ5vpXaY1MpgXwLoTVbAvtImfJqc8MonUtCIfQU/9zrS/cOYvXCOnXVqunMCpNYkHIBqV4nOq99sjltS9Mm5vgUMW0dhxfzGgo0v3q5McWUdjPn63KrXoXKdnMWwa/XbyzRiqZ9pZ1bdjN7sk74Tiv0RddZ/isXXTu9kHoyG0OceWqqZB/GmYbgkNViKWPguIwO6qC/mz/G0TDN0U7lByyx9SWu4uTlLQE6Gfd1Mg2bCdSUerjtsote8Jbbs7BfyDc/xFJMLg32/sPPuM3jneXPabvp8OOYIYPsBaCzPIJdDTK91V738sbNKL/HQU9FNm6tA2v7vgVPH3fuV+mOwFcgwrozb6+xwAMyLW9rKqGgHScC5kyaHuWXqYSVR/3PHA6qObKhwYpOn16gXSHRJTgRvIRsvESC5paudmzmFWa1YYSdRNkYJXHamMISjyS2n6tXPBwvT+4sfmUQc/N6/WLsAXXAXm9Sjy7N1flDA+pNHN79RTwfisBFq+Qj
 tf212sdj
 2Hd923Hw97AKbMV0XBlhJ/5mbjQBUTy9Q/W8QJf+iCfaUTOCIN0xdX4i8QDtbp7KaQmRDasXNPvT9LxTGlu2tjLv/TzhRMpORZG+uKjgOeKu4EZJ497xPAFjGVtOTu7/AAqMs5UVVQvF6QrLNFDKQXLsAkAykrnam4TfwYPVNwd52Z3Qp27MerRjaOK+Sh5UQBxu+OfdipRLq8j7ArV6QAEukcTV5c3n18m4+WHQsK4/Urn1WgEwM9vAJhcBXhheZrXf0TR9Pdp5dy/964WGv66emr/kK2+R1/dacw5/HkLNP1gwwivRBcpUZ5YhNHFTgQMr6ZTdup12nBIc0KI1CUT7E1eiH1d+RS5zZXmfY+ZfWSuuNhpZTU/ajX/NmvNHTB3LAcBnm0Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This version splits the change up to be more bisectable. It first adds a
new kino_t typedef and a new "PRIino" macro to hold the width specifier
for format strings. The conversion is done, and then everything is
changed to remove the new macro and typedef.

I also missed a few places in the earlier set. This one hopefully does a
bit more thorough job.

My thanks and apologies to everyone who sent R-b/A-b for the v1 series.
v2 breaks a lot of the changes up into two patches so many of those
didn't carry over.  Please resend those if you're still OK with it.

The entire pile is in the "iino-u64" branch of my tree, if anyone is
interested in testing this:

    https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/

Original cover letter follows:

----------------------8<-----------------------

Christian said [1] to "just do it" when I proposed this, so here we are!

For historical reasons, the inode->i_ino field is an unsigned long,
which means that it's 32 bits on 32 bit architectures. This has caused a
number of filesystems to implement hacks to hash a 64-bit identifier
into a 32-bit field, and deprives us of a universal identifier field for
an inode.

This patchset changes the inode->i_ino field from an unsigned long to a
u64. This shouldn't make any material difference on 64-bit hosts, but
32-bit hosts will see struct inode grow by at least 4 bytes. This could
have effects on slabcache sizes and field alignment.

The bulk of the changes are to format strings and tracepoints, since the
kernel itself doesn't care that much about the i_ino field. The first
patch changes some vfs function arguments, so check that one out
carefully.

With this change, we may be able to shrink some inode structures. For
instance, struct nfs_inode has a fileid field that holds the 64-bit
inode number. With this set of changes, that field could be eliminated.
I'd rather leave that sort of cleanups for later just to keep this
simple.

Much of this set was generated by LLM, but I attributed it to myself
since I consider this to be in the "menial tasks" category of LLM usage.

[1]: https://lore.kernel.org/linux-fsdevel/20260219-portrait-winkt-959070cee42f@brauner/

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Changes in v2:
- Use a typedef and macro and do the change in two steps to make it cleanly bisectable
- Fix check_for_busy_inodes() in fscrypt
- Added patch to reorganize tracepoint structs for better packing
- Added patch to change sock.sk_ino to u64
- Added patch to clean up internal handling of inode numbers in audit subsystem
- Drop some unnecessary casts
- Link to v1: https://lore.kernel.org/r/20260226-iino-u64-v1-0-ccceff366db9@kernel.org

---
Jeff Layton (110):
      vfs: introduce kino_t typedef and PRIino format macro
      vfs: widen inode hash/lookup functions to u64
      audit: widen ino fields to u64
      net: change sock.sk_ino and sock_i_ino() to u64
      trace: store i_ino as u64 instead of ino_t/unsigned long
      trace: reorder TP_STRUCT__entry fields for better packing on 32-bit
      ext4: use PRIino format for i_ino
      jbd2: use PRIino format for i_ino
      f2fs: use PRIino format for i_ino
      lockd: use PRIino format for i_ino
      nfs: use PRIino format for i_ino
      nfsd: use PRIino format for i_ino
      locks: use PRIino format for i_ino
      proc: use PRIino format for i_ino
      nilfs2: use PRIino format for i_ino
      9p: use PRIino format for i_ino
      affs: use PRIino format for i_ino
      afs: use PRIino format for i_ino
      autofs: use PRIino format for i_ino
      befs: use PRIino format for i_ino
      bfs: use PRIino format for i_ino
      cachefiles: use PRIino format for i_ino
      ceph: use PRIino format for i_ino
      coda: use PRIino format for i_ino
      cramfs: use PRIino format for i_ino
      ecryptfs: use PRIino format for i_ino
      efs: use PRIino format for i_ino
      exportfs: use PRIino format for i_ino
      ext2: use PRIino format for i_ino
      freevxfs: use PRIino format for i_ino
      hfs: use PRIino format for i_ino
      hfsplus: use PRIino format for i_ino
      hpfs: use PRIino format for i_ino
      isofs: use PRIino format for i_ino
      jffs2: use PRIino format for i_ino
      jfs: use PRIino format for i_ino
      minix: use PRIino format for i_ino
      nsfs: use PRIino format for i_ino
      ntfs3: use PRIino format for i_ino
      ocfs2: use PRIino format for i_ino
      orangefs: use PRIino format for i_ino
      overlayfs: use PRIino format for i_ino
      qnx4: use PRIino format for i_ino
      qnx6: use PRIino format for i_ino
      ubifs: use PRIino format for i_ino
      udf: use PRIino format for i_ino
      ufs: use PRIino format for i_ino
      zonefs: use PRIino format for i_ino
      security: use PRIino format for i_ino
      drm/amdgpu: use PRIino format for i_ino
      fsnotify: use PRIino format for i_ino
      net: use PRIino format for i_ino
      uprobes: use PRIino format for i_ino
      dma-buf: use PRIino format for i_ino
      fscrypt: use PRIino format for i_ino
      fsverity: use PRIino format for i_ino
      iomap: use PRIino format for i_ino
      net: use PRIino format for i_ino
      vfs: use PRIino format for i_ino
      vfs: change kino_t from unsigned long to u64
      ext4: replace PRIino with %llu/%llx format strings
      jbd2: replace PRIino with %llu/%llx format strings
      f2fs: replace PRIino with %llu/%llx format strings
      lockd: replace PRIino with %llu/%llx format strings
      nfs: replace PRIino with %llu/%llx format strings
      nfsd: replace PRIino with %llu/%llx format strings
      proc: replace PRIino with %llu/%llx format strings
      nilfs2: replace PRIino with %llu/%llx format strings
      9p: replace PRIino with %llu/%llx format strings
      affs: replace PRIino with %llu/%llx format strings
      afs: replace PRIino with %llu/%llx format strings
      autofs: replace PRIino with %llu/%llx format strings
      befs: replace PRIino with %llu/%llx format strings
      bfs: replace PRIino with %llu/%llx format strings
      cachefiles: replace PRIino with %llu/%llx format strings
      ceph: replace PRIino with %llu/%llx format strings
      coda: replace PRIino with %llu/%llx format strings
      cramfs: replace PRIino with %llu/%llx format strings
      ecryptfs: replace PRIino with %llu/%llx format strings
      efs: replace PRIino with %llu/%llx format strings
      exportfs: replace PRIino with %llu/%llx format strings
      ext2: replace PRIino with %llu/%llx format strings
      freevxfs: replace PRIino with %llu/%llx format strings
      hfs: replace PRIino with %llu/%llx format strings
      hfsplus: replace PRIino with %llu/%llx format strings
      hpfs: replace PRIino with %llu/%llx format strings
      isofs: replace PRIino with %llu/%llx format strings
      jffs2: replace PRIino with %llu/%llx format strings
      jfs: replace PRIino with %llu/%llx format strings
      minix: replace PRIino with %llu/%llx format strings
      ntfs3: replace PRIino with %llu/%llx format strings
      ocfs2: replace PRIino with %llu/%llx format strings
      orangefs: replace PRIino with %llu/%llx format strings
      overlayfs: replace PRIino with %llu/%llx format strings
      qnx4: replace PRIino with %llu/%llx format strings
      qnx6: replace PRIino with %llu/%llx format strings
      ubifs: replace PRIino with %llu/%llx format strings
      udf: replace PRIino with %llu/%llx format strings
      ufs: replace PRIino with %llu/%llx format strings
      zonefs: replace PRIino with %llu/%llx format strings
      fscrypt: replace PRIino with %llu/%llx format strings
      fsverity: replace PRIino with %llu/%llx format strings
      iomap: replace PRIino with %llu/%llx format strings
      fsnotify: replace PRIino with %llu/%llx format strings
      security: replace PRIino with %llu/%llx format strings
      drm/amdgpu: replace PRIino with %llu/%llx format strings
      dma-buf: replace PRIino with %llu/%llx format strings
      net: replace PRIino with %llu/%llx format strings
      uprobes: replace PRIino with %llu/%llx format strings
      vfs: remove kino_t typedef and PRIino format macro

 drivers/dma-buf/dma-buf.c                  |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |   4 +-
 fs/9p/vfs_addr.c                           |   4 +-
 fs/9p/vfs_inode.c                          |   6 +-
 fs/9p/vfs_inode_dotl.c                     |   6 +-
 fs/affs/amigaffs.c                         |   8 +-
 fs/affs/bitmap.c                           |   2 +-
 fs/affs/dir.c                              |   2 +-
 fs/affs/file.c                             |  20 +-
 fs/affs/inode.c                            |  12 +-
 fs/affs/namei.c                            |  14 +-
 fs/affs/symlink.c                          |   2 +-
 fs/afs/dir.c                               |  10 +-
 fs/afs/dir_search.c                        |   2 +-
 fs/afs/dynroot.c                           |   2 +-
 fs/afs/inode.c                             |   2 +-
 fs/autofs/inode.c                          |   2 +-
 fs/befs/linuxvfs.c                         |  28 +-
 fs/bfs/dir.c                               |   4 +-
 fs/cachefiles/io.c                         |   6 +-
 fs/cachefiles/namei.c                      |  12 +-
 fs/cachefiles/xattr.c                      |   2 +-
 fs/ceph/crypto.c                           |   4 +-
 fs/coda/dir.c                              |   2 +-
 fs/coda/inode.c                            |   2 +-
 fs/cramfs/inode.c                          |   2 +-
 fs/crypto/crypto.c                         |   2 +-
 fs/crypto/hooks.c                          |   2 +-
 fs/crypto/keyring.c                        |   4 +-
 fs/crypto/keysetup.c                       |   2 +-
 fs/dcache.c                                |   4 +-
 fs/ecryptfs/crypto.c                       |   6 +-
 fs/ecryptfs/file.c                         |   2 +-
 fs/efs/inode.c                             |   6 +-
 fs/eventpoll.c                             |   2 +-
 fs/exportfs/expfs.c                        |   4 +-
 fs/ext2/dir.c                              |  10 +-
 fs/ext2/ialloc.c                           |   9 +-
 fs/ext2/inode.c                            |   2 +-
 fs/ext2/trace.h                            |   8 +-
 fs/ext2/xattr.c                            |  14 +-
 fs/ext4/dir.c                              |   2 +-
 fs/ext4/ext4.h                             |   4 +-
 fs/ext4/extents.c                          |   8 +-
 fs/ext4/extents_status.c                   |  28 +-
 fs/ext4/fast_commit.c                      |   8 +-
 fs/ext4/ialloc.c                           |  10 +-
 fs/ext4/indirect.c                         |   2 +-
 fs/ext4/inline.c                           |  14 +-
 fs/ext4/inode.c                            |  22 +-
 fs/ext4/ioctl.c                            |   4 +-
 fs/ext4/mballoc.c                          |   6 +-
 fs/ext4/migrate.c                          |   2 +-
 fs/ext4/move_extent.c                      |  20 +-
 fs/ext4/namei.c                            |  10 +-
 fs/ext4/orphan.c                           |  16 +-
 fs/ext4/page-io.c                          |  10 +-
 fs/ext4/super.c                            |  22 +-
 fs/ext4/xattr.c                            |  10 +-
 fs/f2fs/compress.c                         |   4 +-
 fs/f2fs/dir.c                              |   2 +-
 fs/f2fs/extent_cache.c                     |   8 +-
 fs/f2fs/f2fs.h                             |   6 +-
 fs/f2fs/file.c                             |  12 +-
 fs/f2fs/gc.c                               |   2 +-
 fs/f2fs/inline.c                           |   4 +-
 fs/f2fs/inode.c                            |  48 ++--
 fs/f2fs/namei.c                            |   8 +-
 fs/f2fs/node.c                             |  12 +-
 fs/f2fs/recovery.c                         |  10 +-
 fs/f2fs/xattr.c                            |  10 +-
 fs/freevxfs/vxfs_bmap.c                    |   4 +-
 fs/fserror.c                               |   2 +-
 fs/hfs/catalog.c                           |   2 +-
 fs/hfs/extent.c                            |   4 +-
 fs/hfs/inode.c                             |   4 +-
 fs/hfsplus/attributes.c                    |  10 +-
 fs/hfsplus/catalog.c                       |   2 +-
 fs/hfsplus/dir.c                           |   6 +-
 fs/hfsplus/extents.c                       |   6 +-
 fs/hfsplus/inode.c                         |   8 +-
 fs/hfsplus/super.c                         |   6 +-
 fs/hfsplus/xattr.c                         |  10 +-
 fs/hpfs/dir.c                              |   4 +-
 fs/hpfs/dnode.c                            |   4 +-
 fs/hpfs/ea.c                               |   4 +-
 fs/hpfs/inode.c                            |   4 +-
 fs/inode.c                                 |  49 ++--
 fs/iomap/ioend.c                           |   2 +-
 fs/iomap/trace.h                           |   8 +-
 fs/isofs/compress.c                        |   2 +-
 fs/isofs/dir.c                             |   2 +-
 fs/isofs/inode.c                           |   6 +-
 fs/isofs/namei.c                           |   2 +-
 fs/jbd2/journal.c                          |   4 +-
 fs/jbd2/transaction.c                      |   2 +-
 fs/jffs2/dir.c                             |   4 +-
 fs/jffs2/file.c                            |   4 +-
 fs/jffs2/fs.c                              |  18 +-
 fs/jfs/inode.c                             |   2 +-
 fs/jfs/jfs_imap.c                          |   2 +-
 fs/jfs/jfs_metapage.c                      |   2 +-
 fs/lockd/svclock.c                         |   8 +-
 fs/lockd/svcsubs.c                         |   2 +-
 fs/locks.c                                 |   6 +-
 fs/minix/inode.c                           |  10 +-
 fs/nfs/dir.c                               |  20 +-
 fs/nfs/file.c                              |   8 +-
 fs/nfs/filelayout/filelayout.c             |   8 +-
 fs/nfs/flexfilelayout/flexfilelayout.c     |   8 +-
 fs/nfs/inode.c                             |   6 +-
 fs/nfs/nfs4proc.c                          |   4 +-
 fs/nfs/pnfs.c                              |  12 +-
 fs/nfsd/export.c                           |   2 +-
 fs/nfsd/nfs4state.c                        |   4 +-
 fs/nfsd/nfsfh.c                            |   4 +-
 fs/nfsd/vfs.c                              |   2 +-
 fs/nilfs2/alloc.c                          |  10 +-
 fs/nilfs2/bmap.c                           |   2 +-
 fs/nilfs2/btnode.c                         |   2 +-
 fs/nilfs2/btree.c                          |  12 +-
 fs/nilfs2/dir.c                            |  12 +-
 fs/nilfs2/direct.c                         |   4 +-
 fs/nilfs2/gcinode.c                        |   2 +-
 fs/nilfs2/inode.c                          |   8 +-
 fs/nilfs2/mdt.c                            |   2 +-
 fs/nilfs2/namei.c                          |   2 +-
 fs/nilfs2/segment.c                        |   2 +-
 fs/notify/fdinfo.c                         |   4 +-
 fs/nsfs.c                                  |   4 +-
 fs/ntfs3/super.c                           |   2 +-
 fs/ocfs2/alloc.c                           |   2 +-
 fs/ocfs2/aops.c                            |   4 +-
 fs/ocfs2/dir.c                             |   8 +-
 fs/ocfs2/dlmfs/dlmfs.c                     |  10 +-
 fs/ocfs2/extent_map.c                      |  12 +-
 fs/ocfs2/inode.c                           |   2 +-
 fs/ocfs2/quota_local.c                     |   2 +-
 fs/ocfs2/refcounttree.c                    |  10 +-
 fs/ocfs2/xattr.c                           |   4 +-
 fs/orangefs/inode.c                        |   2 +-
 fs/overlayfs/export.c                      |   2 +-
 fs/overlayfs/namei.c                       |   4 +-
 fs/overlayfs/util.c                        |   2 +-
 fs/pipe.c                                  |   2 +-
 fs/proc/fd.c                               |   2 +-
 fs/proc/task_mmu.c                         |   4 +-
 fs/qnx4/inode.c                            |   4 +-
 fs/qnx6/inode.c                            |   2 +-
 fs/ubifs/debug.c                           |   8 +-
 fs/ubifs/dir.c                             |  28 +-
 fs/ubifs/file.c                            |  28 +-
 fs/ubifs/journal.c                         |   6 +-
 fs/ubifs/super.c                           |  16 +-
 fs/ubifs/tnc.c                             |   4 +-
 fs/ubifs/xattr.c                           |  14 +-
 fs/udf/directory.c                         |  18 +-
 fs/udf/file.c                              |   2 +-
 fs/udf/inode.c                             |  12 +-
 fs/udf/namei.c                             |   8 +-
 fs/udf/super.c                             |   2 +-
 fs/ufs/balloc.c                            |   6 +-
 fs/ufs/dir.c                               |  10 +-
 fs/ufs/ialloc.c                            |   6 +-
 fs/ufs/inode.c                             |  18 +-
 fs/ufs/ufs_fs.h                            |   6 +-
 fs/ufs/util.c                              |   2 +-
 fs/verity/init.c                           |   2 +-
 fs/zonefs/super.c                          |   8 +-
 fs/zonefs/trace.h                          |  18 +-
 include/linux/audit.h                      |   2 +-
 include/linux/fs.h                         |  28 +-
 include/net/sock.h                         |   4 +-
 include/trace/events/cachefiles.h          |  18 +-
 include/trace/events/ext4.h                | 423 +++++++++++++++--------------
 include/trace/events/f2fs.h                | 172 ++++++------
 include/trace/events/filelock.h            |  34 +--
 include/trace/events/filemap.h             |  20 +-
 include/trace/events/fs_dax.h              |  20 +-
 include/trace/events/fsverity.h            |  30 +-
 include/trace/events/hugetlbfs.h           |  42 +--
 include/trace/events/netfs.h               |   8 +-
 include/trace/events/nilfs2.h              |  12 +-
 include/trace/events/readahead.h           |  18 +-
 include/trace/events/timestamp.h           |  16 +-
 include/trace/events/writeback.h           | 162 +++++------
 kernel/audit.h                             |   9 +-
 kernel/audit_fsnotify.c                    |   4 +-
 kernel/audit_watch.c                       |   8 +-
 kernel/auditsc.c                           |   2 +-
 kernel/events/uprobes.c                    |   4 +-
 net/ax25/af_ax25.c                         |   2 +-
 net/bluetooth/af_bluetooth.c               |   4 +-
 net/can/bcm.c                              |   2 +-
 net/ipv4/ping.c                            |   2 +-
 net/ipv4/raw.c                             |   2 +-
 net/ipv4/tcp_ipv4.c                        |   2 +-
 net/ipv4/udp.c                             |   2 +-
 net/ipv6/datagram.c                        |   2 +-
 net/ipv6/tcp_ipv6.c                        |   2 +-
 net/key/af_key.c                           |   2 +-
 net/netlink/af_netlink.c                   |   2 +-
 net/netlink/diag.c                         |   2 +-
 net/netrom/af_netrom.c                     |   4 +-
 net/packet/af_packet.c                     |   2 +-
 net/packet/diag.c                          |   2 +-
 net/phonet/socket.c                        |   4 +-
 net/rose/af_rose.c                         |   4 +-
 net/sctp/proc.c                            |   4 +-
 net/socket.c                               |   2 +-
 net/unix/af_unix.c                         |   2 +-
 net/unix/diag.c                            |   6 +-
 net/x25/x25_proc.c                         |   4 +-
 net/xdp/xsk_diag.c                         |   2 +-
 security/apparmor/apparmorfs.c             |   4 +-
 security/integrity/integrity_audit.c       |   2 +-
 security/ipe/audit.c                       |   2 +-
 security/lsm_audit.c                       |  10 +-
 security/selinux/hooks.c                   |  10 +-
 security/smack/smack_lsm.c                 |  12 +-
 220 files changed, 1181 insertions(+), 1181 deletions(-)
---
base-commit: 842cfe0733c5a03982a7ae496de6fdc0dd661a41
change-id: 20260224-iino-u64-b44a3a72543c

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>


