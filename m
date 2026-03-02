Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E89DEB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70F0E6B00A2; Mon,  2 Mar 2026 15:32:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ECD66B00A4; Mon,  2 Mar 2026 15:32:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AF756B00A6; Mon,  2 Mar 2026 15:32:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 46DD46B00A2
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:32:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1DBCC1A0308
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:32:44 +0000 (UTC)
X-FDA: 84502271448.20.8B6C106
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 37A9DA000C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:32:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ojCoqFhm;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wm1fcI21oxlqKRUFzIAkHXw3ELvm6lDM9Xd7hGQOB2Y=;
	b=UF/LVokzzO1BXVBLOCXXv/Z4gg+2Ya1njYgqEN4D3NSdxLrtCPldPldFzTRGJ60Tnvalz5
	xYQrCeJKn6RXFsfrEguL96+A8a14NDLm7uE8l2PFmPWtCiRrfhZWyJyy4+32yyqwTMh0zX
	hFgwEpr4bctEFhiemlKkWQnXhJh0xUA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483562; a=rsa-sha256;
	cv=none;
	b=YFc3q3laxz28T00VN8vmUU9IYgPcjJsEg7TSRgUd98eKG4FtlHLP9z+vxUXp8LrpIaSn1R
	fEeEeCSTJ7V2uJxI4WjQKvA4m2sSVsxiugQktviMR78rFzXgq1h3mD7Eu/2El1rHvKRJCh
	UJXNR12/zD7F1Bgsy6UrusfLl8iHjoU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ojCoqFhm;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 224384386B;
	Mon,  2 Mar 2026 20:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2FAC19423;
	Mon,  2 Mar 2026 20:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483561;
	bh=+U4pNt+4swYiU9juB5jIauHdQ9T31eEfIxB1XthGj+w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ojCoqFhmV7GCrZ+Yvx92kOHI5TqyKrnvaCFU6FpqnAGViviTfAuamRP/H9mhNqtGH
	 u+FxaG4Wf66tEh4drhDAttVolsG2tSNh2xSH9OXsDquICmuS7tb898TcRn+9hcrXNB
	 PIsRd0nYcnTuoNzODM5aRXboLjkIT1lQTFrRJqn7sPcx197sc9545FiIhdWhV5F+ji
	 OIsl8P5PnoElKCdcgCqJTiewXixIrqIe2jSM/AI4HyRwmBJTahxFKfNd3TUxtlokVD
	 LlgPb3dM5yyDrht4HOUX7JY0uMwI2XSnGXVsqP8Pkgw6VtEp9Blri5ZcPVwSqvfr2F
	 YvSNTWVnt+3Xg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:16 -0500
Subject: [PATCH v2 032/110] hfsplus: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-32-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9754; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=+U4pNt+4swYiU9juB5jIauHdQ9T31eEfIxB1XthGj+w=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH3jSEbImeP7Mt3efN3F3b1XEUUqy+cE5abN
 fhMCVLVv9mJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9wAKCRAADmhBGVaC
 FQGVEACGoc4gHJJvkaRBE7U4SzusXwktwtTDiKy1lqvRLWq+5xd3TiTXvRW49fG3Px4IXHfgjeU
 OA20qk0l1SI3NPYLqkBZwudJosLPcYEJKF0/nGoUqtGTQMbdy2OgVw+Kbwcobr5uEFvHqHVzGtI
 6wyAaAkj8aJewHaL2Hwgk5IMoVl1CEZmSHkx2AellzvvcQn8giFdE49TuyFj8Y907fBc7KE194n
 TRxwkGIhlEq+OqMtwWVbyYVMIWF6/dYDdMXn5uzXJywhJSTZf8P23fgT+0kwoXtHJ3et7zhVBmq
 Mdi1PN/1V0oqyrX+iAO2chFbHQuViQAnYSfRVr6b5oxGnfZ70u337q2BKjiLy38H3+K8yhTswND
 KLdEl4N7hRJI3LnjK+63/aMsB7DnzRK2aCzhe6dCfDTOqLhY1YkHt8X3nUOv4j0RLN1ssNieDSH
 OyVpQdlVRYbCr8D3PQreL7rsevbkdhCqG3pgzfTe58Ybj9ddRTGEbGpUkrGmD05mBmf9aY4BMjS
 kjKI5ywio73Kd9rXiJ7H+xSPoDlorC4vGHKaHfj/vhRmtYcDbX7csmpHZcCJB8ygyo+mBLmm/Rj
 L0pmwUiNwPV4dxK42KDv3SAGQJtnlxEgSmMFt1WXljiiCvXT0VjtaM1vzVIbaVWqcdz1YiNrjl/
 mH4QTILnPt0HyTw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: prmpwp7yufhg666oksuiwfwehx53whnm
X-Rspam-User: 
X-Rspamd-Queue-Id: 37A9DA000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1772483562-679800
X-HE-Meta: U2FsdGVkX19tkFHD90iPBD1Wki0hIof+OwFVyj1qO5J6q52yNY3WkeaqtoJ+lsesrtXL2Yv/h+yDtoBLfqSumLnXn5W4FwGFq0YB25Lkr4/3fNpGNDtWfqtnMOk7c1Fg81hk+MJhgQPUVAUenSNFmi6szSbuHRo8r3OmLUDbqsS2Q36pSFZGZhrBZvKCAemNIFWcbyaXinvQNmd9CFh21qN2RUkUbeG47l8IjX13MXkOO0fX0/ft7J6JcBf+f6mz6YNOTLKvqzMQj6d1pvNeaiQYmdnjPWJ7Uaz7IF53KgOn+p6RzDT/ABeQ/e1ACOEuyStjcokh5LE5oXnaVHq9geawolBXLlZ4U3/BGZOX+hZXd7/mNEPdBjQtQVzgvmJHYZlhBs0Fj+b8VvQETQN1EBPd571ybm9y/r5bdUZlFIsh5VXeAHHYvGsf9GN3lQNwxGxyiBoSzcKJUr3q/czpr+PpMO2ZX5Selux8P5udat/tJ0H2la9gsRuFb68FFgxyM23hNwRh0zmcBDBeWgPqeJX/vNw/nxK0fKhYgaMlL8u371X5gcWl+T2jlWBCcpWuibp7bXujThfyMmew0KqanfgV55tDax/yyePhTBbHuTTwwYROEKTBDRJqmHHebgqEOM8Ur7I/bKGVtdXWUlfdz/N6VC+CeSrKrhqRYSeBtCOOtNiH1H12LFejUKeOX8Ekkjty9JKsTa2IsJCEcfc+d6VG1+/NKmHnVYGIKLnnYuiBzT26H82dE8b2ESPY4o/FPFK/7ljX8LE76zCYqcf6S5GgU41zF1rSSLcegI4wMMpVprpHWV5VGfSw916WYWkVaApYyBaU/OLK6aoAYRkiU0TpUgFlCJz+K6V9QdlRkiv38ReVo8/SK+5bGvl6OTj2po/Ncl37dCUTu9SoxVCt6bHxh5WLoHu8PIrmzdw1ySEjtDFm7EuRutpOxoHnpiGl9GXtLM93Ff9o6Shghey
 sjmUxTRQ
 btYossCB88LMnvMVpvbPr5mnQjF5xHDxRrcWBjDjjq06bnZKzCP3tMziFJihiqEqlE2BFJhC4J9vSzDn1thG4iuSlIPr/uIRJuOkbpwYC+nPjPPpAdIuXwfVaeuy4dn3e35EhGqbdTAlhl0fQT4empEyvltBMOeQbzww0SLNOuUzBBh6iof6PKT8ZO7Nm3Lx8mKejZXX6rdmXWcSTWud/xt+uOSzCXKjRoitVBlX7aXyGvD6hDIFMRZ5340XZnUpuukLwaj/0NnWMlcQIJ7qvL8DWQmnIswTc2HRws+9TKNoM6XXfGC/IJJixqCD1eRb4nKWZE51X4+DWhhpuxZKSIO7lR65wbSv0i0bjvu5/1is7WoMm+ZwbH0xK4eIBXJmI3JLK5CFaDlRaS0+PfkjRDQa37EepO8NU69sCyGrT5hbyy6e2/VXyz3ZNHIOCr9UVQ+dNg5CFgf7CWbycHgj/bPoLlhlxCOCb1jWLwago6a8elNl29k+mpZcQ3xuyYrwdFckzEZcV5t0+P/A0Zdzu3aWbTS2ahNNWBLCIuY9vYqaotwRNPHkCDWEXs2Nj3vivjDundGNXNW8c1+cDTg9SFcwWoKtUwP9OiEtIIBm6jW5cAMTr8rRdnNHXOOBLVMPosDGgSAmlOYw1TbLsO6ykM9RKRyu9979bmPwAnUaQd3J71piEsi8C02fKZf/fBrm9KdbKMegZKfAbyvbJM9GfUrfSdh+5kejeVG3y0I6qf8hRfWGYk7fLVbMJFqWR3vCDPDOZSbC4WvR/8BfrD6rbJoRsvy8t4imU7qUwPX54+vwLv60ANXIacBG1kXgQaSS8fawtyhpahbMlSGt1mxUh/hJ0YvXR2MOSQjxKpYQV1YoVXnkuCImBcmKjqfx/az2eH2DzRoeQDJMcfKp0d0S0bpmfbq2qoUJWtP6TXKgXv9JRhG3JdUl5/35eefw1e1xKHyTqIi7N+zbOLmUp456/EsPz/ryA
 unSv6nS/
 8Cd+YhOAhVV1GCaWgLX4FXcX7jw5mL1kuWFi/sWi9k+ofC8YcDrc/hZUZZAjzMM28NC4U64PyeuX6v0K4sRU/ZlxWlHPTRWiRB+dcPc0I7/msf9aarkx4zbEgfKuAO2gRsFWNjZ2Aytb9KFtRUg3zF3m6iOyIwbDwq/ecB6v42SDpC5YZylY+SO9v0XrM6YTc8X4hxM2Ibk4RCx21WYAT5z3Wn4wNBx7TUcHziZB3fXM5yFj2OVLCM/xNbtGEDypdWiHzgvgjZNVjDPppGBpPJV832HJ5DLpdBU7yaXFaoOU9T80moC3gcm90T/XTy93QeracDdGeh6y/aLrjIV7FPsrKUBdFKB5zPgoABOgn52S36PaUsIB84mh9t1PWG5y79awfDyMQBgBzPazj9DY0uCJvTn0w0wDh5t0ARqhII1/1ms5zIPm7zHNtJi1u0c5vMjEVx77L1z1OKsZeoOEzfyrF1sGDWfeO217AvBhaKciQuSaNKMQYNE28BjXhQ9ITWaWjdgKEZTIJ/Z4n4HFfkrDkz9MWkZKRsdJ9/Ob4pIYxJgyvTPQdJHB312w+DG678GRvLXEjWDKGbVu+Tqia9BGgRd01+kaa1LNbB2lJQ6YOBmcXVxRdQ6tlInKSdFHyl5bIhfcQ8dODL83b/Q6RWnLkNafHHha+8nO1O6xgyX6c0S4iEN5C3ZFCS+MkJteh3kQWsZH3cDGlRgDrARoMU3u9JUfXmXUrMoExrZkXxvWvfX+B8WBuM+cOfCFE9vQOW5yU5raRAptuMms8hHw+y2n5HolYPRv/jjkimqnAuow6V6oNaNosJ5CMD0//BQHQJmvUXl4w3X1WSZQKV9+4aO6JxrE/8i4XQ/h91OL//+scY6xPXIrvkekP33+RfiNL15JXUMk58Eo6QFOz59ZLq+7kIF8LIROV7/rlwo00Xdv5xAg9977/qrfPQY7WDd8DOULyLCYpsi2FCXvfyctnI0cj1n4a
 m0Ih66jk
 4wv0L44PRQmqlOyB4VujzciuiSxJQIY1Jut4aNIOeMLO+TPyQxiWMcZPMEKY2az3spGBguFLd76De7RYU6rA96sAicXvMRZqXsUX+DjaWF4yCSySmgShham7mYxw89q/FnqTKgB40/g5MvFYGPcO3wwnyaCGXxIHizFJVjIIngeuYZfwjGKUV2ltk1InoMFRemqCgjKeIE8Qas/23z2plZmgi1C/M3pP/LLxN5+rmmXBDiI9OUpEH0lv9tNmqkB9z9/uEaoWOPzbEMkiTCuBdVui28bG4u6KbUwnIiZ1mtpnLw78hIBazIkBYV2uT/d898pMuuzDHUe7r9a2T0n2YdAoGi+qx/wGIKUNSg54gzc+dhLqH9KaV9mb9qKje7Ah/zmXJ5EquQhit6wX/HMpizKOnngpD7RzQ1qxOIiBPF1Wmux6pMyw+3v2jtODTG9Uv2Mhnaj/e3MCcESHjecFfb+5rzmQWBIHESD4VSBpBvWgeHdbZbJYkkXwrd8bYCJs9uLns5AHWt6QmL9p9K6i3j5HtkTy2p4DhVzBaNfeo3lG0PNAAgicq37vjSVxaHtXNvWIVRdtXAzXf/TA0HAIEu6GH8NEbnx5XWpJP/87aW3J0iafJGCvPXr3EcFrCTXbvnp5/835rbSkWV3BO/toNMGBauYYd8gUHhkaWAGNeMAN/F1Mq34Rkwo1yKjxAXkUxwMhg1U91D4NpzF8IRROpBUYO8PwJ8vye8isl3R8dKCYbMzp8sPd4So63X805WZxfY/DZiDMlUxwZWhTZg+nOBPsIMseRgKk0IB1B3km/GtMPDctGMntWuFoSQrq5igutXxKAMfJkjgNO6cJ/CkcxE8f6G67P68oBDkz4Npva3mA0W0d4zhbJfC/GieYMCgdN8On6qi0CWj2FmpCHQJZNY362rimjhqaJhk8IYJhujUgzQ4jsXtTi2lKcCKsTPOeCY8twC8+na2d8pP5FusvYrZgkJCK/
 5IPQKox1
 +4btHrhVEJ4Pk4HqkCsg7m9+/0DUHWpqMOEVJ/kjvxe+p5Sz+ad7L3fiDNraPtCGrWnACBpcuLnjckxbpe2qpPssAYRDeCpSdLfh3nu4uqTQTD0SjaUGM1ZWBbk/arqEDsSfX1rsdLui4/rqy8tTSrKFlSzlZtP5n5jr+nKyMT0Olf6/MCqv/V3wu0OW/Zn9wNYkesQ2xl7zdorARTi4/M/SY4yRh5gXUyU68eHVAKrnjYhW3p0RlGsEQR6aYiEXyVd1Gv5e/H1qzeJ9i0nzdMb50sryuHKIwnYwwEz+bX/1szBRxpUgwI+3bh+JFUP+XnFqiUo1vVtW9Gcd/PR8pBYCOnslAyZi4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert hfsplus i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/hfsplus/attributes.c | 10 +++++-----
 fs/hfsplus/catalog.c    |  2 +-
 fs/hfsplus/dir.c        |  6 +++---
 fs/hfsplus/extents.c    |  6 +++---
 fs/hfsplus/inode.c      |  8 ++++----
 fs/hfsplus/super.c      |  6 +++---
 fs/hfsplus/xattr.c      | 10 +++++-----
 7 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/hfsplus/attributes.c b/fs/hfsplus/attributes.c
index 4b79cd606276e31c20fa18ef3a099596f50e8a0f..d0b3f58166a057c0a5bf2e41cf6fc839798c0ded 100644
--- a/fs/hfsplus/attributes.c
+++ b/fs/hfsplus/attributes.c
@@ -203,7 +203,7 @@ int hfsplus_create_attr_nolock(struct inode *inode, const char *name,
 	int entry_size;
 	int err;
 
-	hfs_dbg("name %s, ino %ld\n",
+	hfs_dbg("name %s, ino %" PRIino "u\n",
 		name ? name : NULL, inode->i_ino);
 
 	if (name) {
@@ -255,7 +255,7 @@ int hfsplus_create_attr(struct inode *inode,
 	hfsplus_attr_entry *entry_ptr;
 	int err;
 
-	hfs_dbg("name %s, ino %ld\n",
+	hfs_dbg("name %s, ino %" PRIino "u\n",
 		name ? name : NULL, inode->i_ino);
 
 	if (!HFSPLUS_SB(sb)->attr_tree) {
@@ -337,7 +337,7 @@ int hfsplus_delete_attr_nolock(struct inode *inode, const char *name,
 	struct super_block *sb = inode->i_sb;
 	int err;
 
-	hfs_dbg("name %s, ino %ld\n",
+	hfs_dbg("name %s, ino %" PRIino "u\n",
 		name ? name : NULL, inode->i_ino);
 
 	if (name) {
@@ -367,7 +367,7 @@ int hfsplus_delete_attr(struct inode *inode, const char *name)
 	struct super_block *sb = inode->i_sb;
 	struct hfs_find_data fd;
 
-	hfs_dbg("name %s, ino %ld\n",
+	hfs_dbg("name %s, ino %" PRIino "u\n",
 		name ? name : NULL, inode->i_ino);
 
 	if (!HFSPLUS_SB(sb)->attr_tree) {
@@ -436,7 +436,7 @@ int hfsplus_replace_attr(struct inode *inode,
 	hfsplus_attr_entry *entry_ptr;
 	int err = 0;
 
-	hfs_dbg("name %s, ino %ld\n",
+	hfs_dbg("name %s, ino %" PRIino "u\n",
 		name ? name : NULL, inode->i_ino);
 
 	if (!HFSPLUS_SB(sb)->attr_tree) {
diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
index 02c1eee4a4b86059ceaab7a7c68ab65adba6fa26..d422f117c60dee6fd8ece0d01d4ce66e04421e4a 100644
--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -441,7 +441,7 @@ int hfsplus_rename_cat(u32 cnid,
 	int entry_size, type;
 	int err;
 
-	hfs_dbg("cnid %u - ino %lu, name %s - ino %lu, name %s\n",
+	hfs_dbg("cnid %u - ino %" PRIino "u, name %s - ino %" PRIino "u, name %s\n",
 		cnid, src_dir->i_ino, src_name->name,
 		dst_dir->i_ino, dst_name->name);
 	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &src_fd);
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index d559bf8625f853d50fd316d157cf8afe22069565..e701b11437f09172f88d68b4e4f5998591572b38 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -313,7 +313,7 @@ static int hfsplus_link(struct dentry *src_dentry, struct inode *dst_dir,
 	if (!S_ISREG(inode->i_mode))
 		return -EPERM;
 
-	hfs_dbg("src_dir->i_ino %lu, dst_dir->i_ino %lu, inode->i_ino %lu\n",
+	hfs_dbg("src_dir->i_ino %" PRIino "u, dst_dir->i_ino %" PRIino "u, inode->i_ino %" PRIino "u\n",
 		src_dir->i_ino, dst_dir->i_ino, inode->i_ino);
 
 	mutex_lock(&sbi->vh_mutex);
@@ -385,7 +385,7 @@ static int hfsplus_unlink(struct inode *dir, struct dentry *dentry)
 	if (HFSPLUS_IS_RSRC(inode))
 		return -EPERM;
 
-	hfs_dbg("dir->i_ino %lu, inode->i_ino %lu\n",
+	hfs_dbg("dir->i_ino %" PRIino "u, inode->i_ino %" PRIino "u\n",
 		dir->i_ino, inode->i_ino);
 
 	mutex_lock(&sbi->vh_mutex);
@@ -393,7 +393,7 @@ static int hfsplus_unlink(struct inode *dir, struct dentry *dentry)
 	if (inode->i_ino == cnid &&
 	    atomic_read(&HFSPLUS_I(inode)->opencnt)) {
 		str.name = name;
-		str.len = sprintf(name, "temp%lu", inode->i_ino);
+		str.len = sprintf(name, "temp%" PRIino "u", inode->i_ino);
 		res = hfsplus_rename_cat(inode->i_ino,
 					 dir, &dentry->d_name,
 					 sbi->hidden_dir, &str);
diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index 8e886514d27f1e5d4d94be75142f197669e62234..1dbfdf44f954f2768852678d1e386a91758848f9 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -275,7 +275,7 @@ int hfsplus_get_block(struct inode *inode, sector_t iblock,
 	mutex_unlock(&hip->extents_lock);
 
 done:
-	hfs_dbg("ino %lu, iblock %llu - dblock %u\n",
+	hfs_dbg("ino %" PRIino "u, iblock %llu - dblock %u\n",
 		inode->i_ino, (long long)iblock, dblock);
 
 	mask = (1 << sbi->fs_shift) - 1;
@@ -476,7 +476,7 @@ int hfsplus_file_extend(struct inode *inode, bool zeroout)
 			goto out;
 	}
 
-	hfs_dbg("ino %lu, start %u, len %u\n", inode->i_ino, start, len);
+	hfs_dbg("ino %" PRIino "u, start %u, len %u\n", inode->i_ino, start, len);
 
 	if (hip->alloc_blocks <= hip->first_blocks) {
 		if (!hip->first_blocks) {
@@ -545,7 +545,7 @@ void hfsplus_file_truncate(struct inode *inode)
 	u32 alloc_cnt, blk_cnt, start;
 	int res;
 
-	hfs_dbg("ino %lu, phys_size %llu -> i_size %llu\n",
+	hfs_dbg("ino %" PRIino "u, phys_size %llu -> i_size %llu\n",
 		inode->i_ino, (long long)hip->phys_size, inode->i_size);
 
 	if (inode->i_size > hip->phys_size) {
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 922ff41df042a83d47364f2d941c45dabda29afb..f61397db976e8b15fa186c3b31af71e55f9e26a6 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -230,7 +230,7 @@ static int hfsplus_get_perms(struct inode *inode,
 		inode->i_flags &= ~S_APPEND;
 	return 0;
 bad_type:
-	pr_err("invalid file type 0%04o for inode %lu\n", mode, inode->i_ino);
+	pr_err("invalid file type 0%04o for inode %" PRIino "u\n", mode, inode->i_ino);
 	return -EIO;
 }
 
@@ -328,7 +328,7 @@ int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
 	struct hfsplus_vh *vhdr = sbi->s_vhdr;
 	int error = 0, error2;
 
-	hfs_dbg("inode->i_ino %lu, start %llu, end %llu\n",
+	hfs_dbg("inode->i_ino %" PRIino "u, start %llu, end %llu\n",
 		inode->i_ino, start, end);
 
 	error = file_write_and_wait_range(file, start, end);
@@ -639,7 +639,7 @@ int hfsplus_cat_write_inode(struct inode *inode)
 	hfsplus_cat_entry entry;
 	int res = 0;
 
-	hfs_dbg("inode->i_ino %lu\n", inode->i_ino);
+	hfs_dbg("inode->i_ino %" PRIino "u\n", inode->i_ino);
 
 	if (HFSPLUS_IS_RSRC(inode))
 		main_inode = HFSPLUS_I(inode)->rsrc_inode;
@@ -716,7 +716,7 @@ int hfsplus_cat_write_inode(struct inode *inode)
 	if (!res) {
 		res = hfs_btree_write(tree);
 		if (res) {
-			pr_err("b-tree write err: %d, ino %lu\n",
+			pr_err("b-tree write err: %d, ino %" PRIino "u\n",
 			       res, inode->i_ino);
 		}
 	}
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 7229a8ae89f9469109b1c3a317ee9b7705a83f8b..b76865e2eac5260b681fc46b297f1665f1bc10da 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -156,7 +156,7 @@ static int hfsplus_system_write_inode(struct inode *inode)
 		int err = hfs_btree_write(tree);
 
 		if (err) {
-			pr_err("b-tree write err: %d, ino %lu\n",
+			pr_err("b-tree write err: %d, ino %" PRIino "u\n",
 			       err, inode->i_ino);
 			return err;
 		}
@@ -169,7 +169,7 @@ static int hfsplus_write_inode(struct inode *inode,
 {
 	int err;
 
-	hfs_dbg("ino %lu\n", inode->i_ino);
+	hfs_dbg("ino %" PRIino "u\n", inode->i_ino);
 
 	err = hfsplus_ext_write_extent(inode);
 	if (err)
@@ -184,7 +184,7 @@ static int hfsplus_write_inode(struct inode *inode,
 
 static void hfsplus_evict_inode(struct inode *inode)
 {
-	hfs_dbg("ino %lu\n", inode->i_ino);
+	hfs_dbg("ino %" PRIino "u\n", inode->i_ino);
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	if (HFSPLUS_IS_RSRC(inode)) {
diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
index 9904944cbd54e3d326591fa65a5ed678f38ca583..ef9121843482e81961fa541c53c906ab04d6fc33 100644
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -277,7 +277,7 @@ int __hfsplus_setxattr(struct inode *inode, const char *name,
 	u16 folder_finderinfo_len = sizeof(DInfo) + sizeof(DXInfo);
 	u16 file_finderinfo_len = sizeof(FInfo) + sizeof(FXInfo);
 
-	hfs_dbg("ino %lu, name %s, value %p, size %zu\n",
+	hfs_dbg("ino %" PRIino "u, name %s, value %p, size %zu\n",
 		inode->i_ino, name ? name : NULL,
 		value, size);
 
@@ -447,7 +447,7 @@ int hfsplus_setxattr(struct inode *inode, const char *name,
 		NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1;
 	int res;
 
-	hfs_dbg("ino %lu, name %s, prefix %s, prefixlen %zu, "
+	hfs_dbg("ino %" PRIino "u, name %s, prefix %s, prefixlen %zu, "
 		"value %p, size %zu\n",
 		inode->i_ino, name ? name : NULL,
 		prefix ? prefix : NULL, prefixlen,
@@ -607,7 +607,7 @@ ssize_t hfsplus_getxattr(struct inode *inode, const char *name,
 	int res;
 	char *xattr_name;
 
-	hfs_dbg("ino %lu, name %s, prefix %s\n",
+	hfs_dbg("ino %" PRIino "u, name %s, prefix %s\n",
 		inode->i_ino, name ? name : NULL,
 		prefix ? prefix : NULL);
 
@@ -717,7 +717,7 @@ ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size)
 	size_t strbuf_size;
 	int xattr_name_len;
 
-	hfs_dbg("ino %lu\n", inode->i_ino);
+	hfs_dbg("ino %" PRIino "u\n", inode->i_ino);
 
 	if (!is_xattr_operation_supported(inode))
 		return -EOPNOTSUPP;
@@ -819,7 +819,7 @@ static int hfsplus_removexattr(struct inode *inode, const char *name)
 	int is_xattr_acl_deleted;
 	int is_all_xattrs_deleted;
 
-	hfs_dbg("ino %lu, name %s\n",
+	hfs_dbg("ino %" PRIino "u, name %s\n",
 		inode->i_ino, name ? name : NULL);
 
 	if (!HFSPLUS_SB(inode->i_sb)->attr_tree)

-- 
2.53.0


