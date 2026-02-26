Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48AF4FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CA96B011E; Thu, 26 Feb 2026 11:04:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5AC16B011F; Thu, 26 Feb 2026 11:04:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911FA6B0120; Thu, 26 Feb 2026 11:04:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD326B011E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:04:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F38C160272
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:04:17 +0000 (UTC)
X-FDA: 84487079754.23.687D5EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 45DCE1A000F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:04:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JkZASixi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121855; a=rsa-sha256;
	cv=none;
	b=UvfSqWuoXaArzpRNVs9QaFgtef1HCVwi3aSoe48imhKcy5PXayTkUeQCJQnSS/85tYtjeP
	s+iHdK5cKipYCT5oxtDVlevhl/rEuK2PA8PH2eRnYLlnEKAHWJt4vvDp70T8N361O4bMty
	QAHvS8q6ZQOg0XQ1nDsFQV37VvwKBeo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JkZASixi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hchX0S9Zk5xgE3BLLxODoDG8quQruUK4nmQnhZUa3hI=;
	b=KeKcHa7lO5hh4hUflTsOAltCuXmu3mOrCMAsDQgKbz8160EECPZ2vdnFwHWeoB9BPtLDHl
	fH3msuaxgU0MYpEBEI25JgJ3AD+bNNnxU57iX0A4itjAvh4YuNn122MwD3BG9/7Vh+NX4P
	zTcBmDirX57aQcErkkHrW4WsnORp0jU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FA8E4067F;
	Thu, 26 Feb 2026 16:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9546C19424;
	Thu, 26 Feb 2026 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121854;
	bh=AClwnsoOnb4s1w/37/x3Wjk9ZhEATE7ToSrQpKzKnv4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JkZASixi554z5yi5ZZIWYqlk1ZbECUEfSqcqGujNjQ6C86T0rhzMLLyX6N1SUyDT/
	 eacDvIi4KsxI6Y++V1V8fXIiVurB4j7z8x6XPih4feH53SmhQygd3QGwtZj3+SsdgR
	 9Ji9p9bQF+sF6AjITALSoY4FIaGaz/s/C0xhEg1Ss/pnQ36ylVw5uU5DlHN4JW/xDy
	 gQ/21wx0xf1lNQOeP5Tb61fp9B8vUf4ktsntXvnHA9wi9AFNfAvWpcJ7gcu7nR8c+Y
	 qvBVMuUomfD7iUb8ytAu02WBsjYNp4eSVaFElV1DgJ1Eg/idnYMgsiC4sh2tI1CrYR
	 fXhCYJ6C0fPQw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:40 -0500
Subject: [PATCH 38/61] jfs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-38-ccceff366db9@kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
In-Reply-To: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
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
 Martin Schiller <ms@dev.tdt.de>
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
 linux-x25@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1973; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=AClwnsoOnb4s1w/37/x3Wjk9ZhEATE7ToSrQpKzKnv4=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0N0bOtgyDQKaoCMzeyS0ybevShKonkEMhhg
 xIfs2vXiaOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDQAKCRAADmhBGVaC
 FUduD/9bWKVRqNRryYhi0l3hd0bJfi5zi+Bj9b4Sj/rCTi1/ZWGN+g6mAnVnDqVIuEH3AFFqMe9
 +fddP4rH+hcmqrP9r5WtAB/nU3loLKCARLtrCaM3soW+zFwYqLn93Fi+6JyQ3kymejEgcCqDcZr
 +3mk+sBp5Iw9ESn1KCeZtzTeOkm33zBsof+00D1giQ7aaQOZ20MB36AXTN+KZrrU3Xc98770MnA
 7nL3DXPmK10Bo79Q2Gq4DmDZXUtD5/k4lsbxY6tTxxeUPRYR1Q8Pwq3Xo3DxD6wfB5BL+EwsW8/
 gZ0ZCKZZV9lqnJmddoSGuHSnFVbUEiTpwCpzRP54ZgTt7UtgO2UC9lSetosy+vDbZRhBGOhtYBB
 ZSAbin8hCUWXz6iZFk76OfxwbtJO909PLKTRDONCnLPVENtd52CoSFcph2/SW/0lWTUaS74T2j/
 FeSqJknU0HJ+CnR78eCFGQkv5wj3iCU3SOL/a2ue5aQW2PdX3W0JbgRTkndzs1jfPagy0SKH9Yq
 /84UTImr7g/wQS017LZvRC9TD+ucIWeddouDutL/dAVIQ8cv++OMp0JgZRxI4DgIYNvuYCAmWI6
 7bt3syz64DH8VZ796/EN1ThA9UfFbxxopX0VvgtC/CLWkc4LfPiAre+P7cro8zSixCwN3LFIPKY
 rgBiRzZP7A2Nh6w==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: dtf17g5xhjooohiyhpjyy4zbfzfbp3f6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 45DCE1A000F
X-HE-Tag: 1772121855-215806
X-HE-Meta: U2FsdGVkX1+Hx6wTIrUFrF19+POwDKIn0isS4Sme7CwfIlCKyRe/MeVC3RQIY6YLHeoANpAtMJ49F1zuciBmqrNuDa5WCgnrLmv2fIg3B/rC63qxKxjkx7X27VIkKScdfeXf2kpRgRd5S17jTpXqgbxDSA5CZ4aASqZtDhBM4lTYwKYUBathb+KIJ+d128Oum3r43r5eEWCO9qLZVQGRl1O0dJleBSSzkGOYSar3OghY6oz1tzB2ZvhrqS8Oei2fTkSkekfiPdptcC505msCGxB2MY1/Ta+2AF76Z3MDETfEylJkNvcI+Eu04oh8X90bU9wP3ODwqF1RGOf3JfCmx+d4+bECFE0em4Hf80eydirYEVeKLZ1Xq1HiP3Q7Zt1q/fwSXJ1+QvRPrKc5MYLyKV1sfH0BNiqGAk4ZU+PV+wTP0Sf2qi9n+wUs0lgx8c1qmUoLDwhxxLJNMoK3grWR5qEUJo8aucf4gB3hc1U8A4zvN691fqPk7RqJ3TU9PS44OfxQ7LU2nKAb5g8GN0L77g6hfzjOL8NrtQClwHfMQt+TxQNOOGjjwRuG6VpdS0VjTz2doLBb/dqb/l3MoqHgqAEz4BUkhO6PBBeBT98rSzqs0Stiw6Oh4kUieGVyAl4TT6qx9YGq++mEkTORvCD8fip9ZA9HNWdZE/IWSfI9HRc2n+BDAymkOpLgImTg/0DAsavzuzYvmP+K6eIPcAK5HURtVSn6+sTwr4NW2FPamipv0fiawTRF4cwKRvzYp63i8hqAKx00Cv6a9rIgqm/Iwqkp6CniIYeeRS5oJ5bZoo9JI6ZaqpHgauqywltxB0+3+eLvLCjg3luRdBynVahvigADXKv90rMVGn91A8pcYXu1uPukF+jUL6J3vwM3C+hb0eixXHvW3Xuja9CPSDlL/8j2Fncxm8oDR7EwFByhouDk6OBhumXYZtZgnoez5CdZea1NjyX+w3+BaJo8md0
 cLZw1HwG
 C/rG+c719qEb3HcZcs1bH3D5lxp/nPhO6t3y1hrIvmJjHCBrZ8vhKcJocDLQS9IywYTC6zcZErnRgMFUj6L1mA86HmKcnaVSrmJv7xdukx+uXp4/w3CFeF+Xqu8m3WXdCvXqHH34+XuJAAgR3kvU7Nec6hCG50SiBrnhr0zEp+zHFbIB437ZVdJOnzTBQi5GU1fNog4NaEEWu4gnW7GExMS5ezCDgFNaSS3bbJjzWhnjtbdVnEeXNEhSOm3P5qOUROJVXXM0u/ZGhjlKUoqfIryZivRtw7bs8S5i0+OzcZ9QPVXJHLF67iUEENJe76NxPbXMkSKLHRLenZuw8ZecYdz/R/0aPOr5upBp0zCFU4/RnQn7/1PGvinSgAOsc3IBk8SYSlq2MbWWBX7p0uw4BgliMErBJNAHb7J2oOYoJ0nJ6tGIHw7EaXA2jANoN7qnf+C9V1fqFYX0/uZcutCjweObqYaDCSs5MoDV1SwMzbA8kevlVXk+lg1iGRFw3KX/FKwhU0if3lWttRRxpxqlWZTnXQvsYVNUohArp+jnMsSp9nHjQ9GWQ+vuHWUgsRgo0ApxJZwkfCLJwrUPb66JabD+G/2vqr+4QzYFwV1Mw1rq1SiLzXldxuM1fomb0Ay6XgFrzZooJLlBxePFZ46y/56FhIh8pxsexyAA5J5mhDCyfaeH3VKad4QYSEr35aFhinWu6vDdK6bOAX51FnYTrhtGDzGtABgxUnBeQeG4veU2dp/YuW5lRA+y4RenRtQAngyNz4FIufaPPaMa7mQvGtyDWzgSgQ36/FOo6Df0a0H8KJ78y8ZL43hNGRZmjYPm08LxvWl+/I6Z0z7xGaaBFBZ+/uDGTKWoEJVwwBTrw+W5OBuidWtaXqavHjmcC+ceiQtcynJpZ/1UeMpSSRkhTIuetLode4E/7IztNOoahyV1VRU/rnHyHUi4VF0mh2HltT71rwyGbS3K24kd6fbDxFxcBQKLw
 6ouyt6VY
 pPsFL1TFevBbsX4tosqDnDT7bjKGbcnPzXval13zaLcFH1CLVhiy8vC/vWSAeWxMHLLSUSSmY+eNDIV1fYStwu1eGXiyitzqEZd+JEQEE+oNTpRpgRkKzIxBgmtcpF5+/hChTbWp/y+1ibONE4YD377t/MGL+SWWyteZ5mwplfavHCFvj/bm+sorrknLPrxo+3mJV8onY3HrMKN6NohVm9hLr9XV0v0qrucHPlNFHgTydjLwKFWwFpVxdf/oR4uIaqwb9DzsMziIjdvKhAwrhWhzX7WS+lmnQxejGzgv9LXVFhj63/yn4eofZ1PQ/kWol9Pui2miIKo4Wqey/Z1Lyg2JfNyD6NglicUz5uOYtlIYV5C1XaEjxzluN8j/pU5Xyt0850k2ynSEYrDb4ZmEKNm4ZjZL4mbaXKt3UIMFw9f4JChPSZOHzvuWMDZbLKp1L1kAhGPTJPbzD1sqAApxTMO+PnYGSPB9/h5zThbP7X2yXAPiu+CGEnrly0Lz5jNaGQhvxdKC6PPu+3dDCXaA2WXY6N6JZRtFLVfGhtzXBw6AOv2RlRln8LtF/7B9LzNL3rEiJZEMbdWXOVv3M6nOvB1xmDJortytBdWRyrMRJQfMMnQsO/+6stcjEiyBwFTRjT6S+teGsVD7ZA/CXLXuN6JUgxQtenAy6vuwhQQ0VBDOjElMQVLoZy5rpGmS1DIS466odfN+GNkZ5m22z/33MGohWrY7v+I2ROL3c4Mi48ftc02EyvH0faC1ahFhdncnIrAuU/VbU+I1+T4OPRi6nZjxoE32V54ihdCTSXApLPAI2tQOyBX81uZn8GBBBbizILwt2Wb7OYu77/2A/VUKaEGTsVvL+PG7j22JTyKtVqIojLgOxO4XACk2/bALk9N5c4l7pTmiGLObAH4hs7eGzCLZFwlw1g3+K1+q90hqZPJ3PlIpErN1bjIzF2pmVni63SCBkqxh2zBn0Mna9YL9ub9cGbUl8
 1Ci4jYTd
 K35G2PVjEJSLSM3SmSU+oUE4/2G4kDwSpRsMzKOHqOuc4bw44+4g6fqMS9nHdbz1BulzkmdGBqjqom9915/tJw6L2JIWwtXHUgfmommIykUCKSQUlMGoKj6e0WhLcSAuN0rDbeOOkXB2HWNcDKA626hZJWdDm0/Lx8KSLZHqr7pnZOTQtlplKsrtmTy5Ckn8GzEgClpCVWUF4wl3txB3MNMNBahNHAM4TKoFemayEEA6XCbouTo5meExQRQdPmCwqPGXvosSkBlV3T6YGWuySX+FILXkWfpglRf72Ms0z0U1Z0Cjzn9EIjZHtzeMF8Gr3fOIEQY5LgRgR/n5NRGQ1FXkggKx8k7u9NFQCR+U3HKsfR/bZGMBymsspRF7BpeI8Kp6RYeBfJ+qrtFnAf8EvMQQ6+5ZgQNpaco9akp86De3zcDzxEKutLfn5HzRZQIu/aOz9SCtioP+Y4ZOJ7PcJSgTxcZ+7Is8R3zW0MSRUZQ+SuDKTHsu5fd2Hs7t1j1K1kuUs8pGp9e2kWAUsRMCvHSuh2ZUGlDRiNSc3tJMCrlLBs2zcCyR6Oq5TuPTHB/Bmp72StBAygGLmQDY7evWjmu2oIjnCht2ePuORArnfhZyl7/TJ39RLoDNf4BJba3mfR7JlR2+pmned2TFbi0RxiFScb/MXSPKvKOljTwpJIJ69YexibPzN+6AzAdvhjke1MzBHH4YltYQ9Q44SDXHnhMkX1iYjZzRTUrGmtqjj/XxLGnD3Qt4VAIEUi4p191tThwtPOVeo7msw8bRxLqlqQ5q5Mo6vYmoUbTx1bO4lI8Ig9p2L3Sybt0bETo2/voaUC/o3odi5mSukNi97QZoAKKmOot09JPHlcW0w5CItnxqZAq/KoaOPZvd5C7mge22BHrcJ/2k/HjkQhdT7wI6WAvKA9vROu+r6ntCwFFln6wVQO732TvYdsCwEy1i3T5/WXdvEd6cVeiQ0rTT4BpsMF/80fJ4B
 8U0/0s1C
 j+UOgbeXq+LxW+5ZHWBX7QJMQO41d1XmBsL7M5BIxPHZewHuPlBSn8Hlw6NF2IEjT8HWV6qzOAcEnaoQgtckG31WKxVlJ1cMQsYKxJPuE/aFWdOvGGmYHGtwH+fOTDubgEFR3CUPGu/9kLZ/CbFM4KOjY5OpDXuVyb7yEBYaXq7MeoxR4Odbqnha5q7sciidx/gaQp1aa6FYdYPifMA+QunAOxPfA94vgx1lKbVFQaaxsSicZHp5jOCYRlVWT2Jz7B5qU5K5bUzed3ZtrcsIa7swSCRQ4gjM0d6DZtzsJV2ssz7xOZlH8HCsOOd0fdYEs97cycqQZK94JgVIxBX/sZF0dlDLITbhFW+YZs7W4EnW54Lnj1EMOw8VGfKfVaXFUpKqCbKXIgOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in jfs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jfs/inode.c        | 2 +-
 fs/jfs/jfs_imap.c     | 2 +-
 fs/jfs/jfs_metapage.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 4709762713efc5f1c6199ccfd9ecefe933e13f67..c7914dbc91ed97e200edbd114e2d4c695b46fb7e 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -64,7 +64,7 @@ struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 		inode->i_op = &jfs_file_inode_operations;
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 	} else {
-		printk(KERN_DEBUG "JFS: Invalid file type 0%04o for inode %lu.\n",
+		printk(KERN_DEBUG "JFS: Invalid file type 0%04o for inode %llu.\n",
 		       inode->i_mode, inode->i_ino);
 		iget_failed(inode);
 		return ERR_PTR(-EIO);
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index 294a67327c735fb9cbe074078ed72e872862d710..3d714fff09992173dfe6c9c74980f034ba4e1a72 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -302,7 +302,7 @@ int diRead(struct inode *ip)
 	unsigned long pageno;
 	int rel_inode;
 
-	jfs_info("diRead: ino = %ld", ip->i_ino);
+	jfs_info("diRead: ino = %lld", ip->i_ino);
 
 	ipimap = sbi->ipimap;
 	JFS_IP(ip)->ipimap = ipimap;
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 64c6eaa7f3f264ac7c6c71ad8dd0d59b63f15414..714dbf34b7ac17f82ee9ebec2f9a5b4c5e6f7356 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -692,7 +692,7 @@ struct metapage *__get_metapage(struct inode *inode, unsigned long lblock,
 	unsigned long page_index;
 	unsigned long page_offset;
 
-	jfs_info("__get_metapage: ino = %ld, lblock = 0x%lx, abs=%d",
+	jfs_info("__get_metapage: ino = %lld, lblock = 0x%lx, abs=%d",
 		 inode->i_ino, lblock, absolute);
 
 	l2bsize = inode->i_blkbits;

-- 
2.53.0


