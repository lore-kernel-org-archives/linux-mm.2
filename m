Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D26EB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA63C6B00D9; Mon,  2 Mar 2026 15:34:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5A346B00DB; Mon,  2 Mar 2026 15:34:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A32CB6B00DC; Mon,  2 Mar 2026 15:34:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1356B00D9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:34:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66D19B7646
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:34:24 +0000 (UTC)
X-FDA: 84502275648.15.E940CCE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id AC58510000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:34:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z+57nIPb;
	spf=pass (imf14.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rHpESWMSFWfwe3ISTMS884LlH8TpPYzSWN2nQVtiMZY=;
	b=luWADkpbIIFvNvojZSAUVUFfTMDP9GPEJRX+4EDwVSYDmam2YjhNm7BKta8QROirDnrbaE
	PvMYPPXbTvojlkamCBrPBqf4OESLZkuIYsZu8kVi9xS7QaAwotjvSW2/EBsvYvubjZRUPG
	Nv4Zf+jxXySl25ph4pmH2shEIUVO368=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z+57nIPb;
	spf=pass (imf14.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483662; a=rsa-sha256;
	cv=none;
	b=b8slUm7SAW9B+h8Nr7VgT7/NveqUm9SmJUETdCPVechDFZH2I/9eUkVV2fpWfBofaYySzi
	fpzhIXzZUxIADmyXkxzln33KI7rmShdq8O2jO8rKDY6Echw05yJDWG6S4JcKdZDhmmy4XK
	k+NrUKU5a9ziLrmXartHdMNN9fZPPYE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 083F56133B;
	Mon,  2 Mar 2026 20:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAC9C19423;
	Mon,  2 Mar 2026 20:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483661;
	bh=9vOORhA9m+Cr2DfixXDJ8c/2SDQAvlb5ujFFzPjzDlc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Z+57nIPb+bk9zi1MjrJosbkn0fEdK3CorLwsR0v6ukr/wnxc2efBPpczQ602ZCKGC
	 z7p/vwb/xRQdC63uq2tnxlejzgMl1TpFX3nXcclQBK+AFWIp0SDBT5qqwuZK+D6Pz7
	 mRqRNzvHf7HlkXaqphW33b/7nPkioKJ5VPplLeCLO2okSKOLt47oiwWkoYr0jAabk8
	 J8SojMzvb4PfpcYJH6Glzrr+Cy+bcL5EkHFY1UgXQ4xbI1+sAppFKh/JJPnnqsFrRi
	 TBC7OjKJ6OmwSlm05TD857yF975y2YZ4Q5sWIl5jpRkUS/GVtZViwwM4E6Q8hl5IyP
	 PcOkhImYnSTpQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:23 -0500
Subject: [PATCH v2 039/110] ntfs3: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-39-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=833; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=9vOORhA9m+Cr2DfixXDJ8c/2SDQAvlb5ujFFzPjzDlc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH55egcRR4/mhYfnDyqBlADGfqgvIRt1PCN4
 x+gMyWmMCCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx+QAKCRAADmhBGVaC
 FdEmD/41M/JHEs7IP3sfe79Y0dcvJeMl84jQGbpG214MGAeA/jtquJXDxncE2gWgJIjMsvDQ8g0
 C3mWf/U5TfDjdFFUx0T4a4Ut7VzCiw6oZ/KlqDMJFJqbui7JZFTyWwIc3FD3s7iMncRlChMLZPp
 q05zf0ttbgtIHWawPfZu732vWozbRo6TqyCT7RYqor8fKO65yquJqUD9sBuwLxRPz7VLijOr7sn
 qUh97KrpLnoHZ3HchUw7dE6yR5rTd9dOO7izjatKYI6hATXuN3CAbZnT5kxcXB7Y5Ubd/49n553
 xbS6DR6HfR9DTweBVmy9gz4J1S2ML9hAn0i9hEoPMM6bwTfnGnirO2MbqsnxjSmKtg27t4NIPZ/
 LGoVO6MVj/BUGAfrAzR/HhoQXt9z7TRb6Ka8msUIfeL6LDAxcrk2sPoVbs+9ZLIL2Ql7cL6e52o
 PT0igEsHZ/hNIjPCPFYO53UYOCyCoSapxCnKhSKzojC6DvcA0nL6oO6kHv/MvjHI2a+th9gNzgM
 Re07vU50RULgKDmWkrWZowfm3su2IvZpZKdEd5YtCd+UbjB2IxJdHyDxcw6DbqQyX29Ohh7yNQi
 ZJeSVNN/CgV37dmFdJKjePETW9gfpjtphDsPGE86Pc6iRKaB8gn8oYsRC7PkH7yEBPCDbPPwip8
 UQ17gyzCLJ44b3Q==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: AC58510000A
X-Rspamd-Server: rspam08
X-Stat-Signature: hhtmsmdpbziaipi8xs7si3zs6tp1j9at
X-HE-Tag: 1772483662-12319
X-HE-Meta: U2FsdGVkX1/+Xs4/zToHb1Ql0zHZCw5PjSy/Rv8VijWi1PojB2KeTT46k8jAi51FRGBugWdbJhY2zBdUoseNn7LE44hZ7nOQKMOPXEkXD+7ZrbcF/Krxis8QlPB31IKJWd1vKkEiPK7NZzZgucunYFYypfkG3fCxbOnmRyT+CKq8vT759VKrUCDa6LzRxJ2i7S/yXIIpfD508fFNO8bbiOB5s2DBPn4QnzzCQ8CAkn7BCv9hSTgdwIpzP57zuUHu9IB9lxXFRL8KB7MG+e9gCvCyNQfGO+iwiejUTabcdcVDngNCq3YN64u2aJwBpLsa5aJykHB20sUmiUqk8kvLOv9ZG0Nx75XNZ4c00daSAwQphMCaVrQ09rUDSwJtfTsY7RksyAGX+gNmLYYgP2pvXRZzSt/rFv2VD0ojnXv4Hxw6wrRMCLbAGyzyPE2nrm/3n5/2nCGqDISZG0lVhYB7qXAx64b6cGZX3GvBqjVX5dozQaRYM2XaKcmS3+diKhps/sHu8S8GlH7Aj0MGMXH/ORtECVBsbht7ev3XFj5n6UO2tq9IYDVwLWIIKzudZg3wPtRifq+SWZe31SLcv6WqEdEcdKoxqkR/H6D2aAqBk0vgASE8a4UkTW/NC3cobJYul4rZuec/oqz1ZX1P1yJ0BEBYdGVlOO1BYK8dgcH6GSo97pojxv5/qrhYxBM9aJW1lqaek5piKkbVjE+kq+x26bISsG3kRRCMDo0HcxKnUoBL6YPVSy2wjYLVRirT2nqSbELoAcuVPq4XkUkNFpf1FCsE7fZN6YbZJpmwVG/gMCc+MpWUHr3qd/j62KNAiaWlmwFUHbh0awsCV4j9pnuo9aFzY0IkSuk3KMRoqF6aM7CMM31Qi1tWo2JvvnIOZatrWnyCmRC6bL3HOdbvXISROMSZUsjWxwdkEI5a8uTNsLI5fd0WGpnQbrz7kWmvH3Eq49P0wLtt+8zR/knLzRS
 8v1IiNed
 aXqREHMKHZs7xJnByolNzDH0R5CHlsiSqAtfzoqo3CWdQvU8k5LNyzdbcGWwF8A2kCB7/yEdrIgmoKwXSD37CASC4Hm7jwYeVH/4dWqoiGz2yeNedKVYuJ9+httKT9XX85r7wiAPL+kMaXWjCpTnT2sE27hWrEZqBe1Op0TkyvtT5EevTzlHo8hx5bnZhcBkqAAJNvJOaUmAsa0zmL6CDUMd1PQSFuWjZ9b5YjmOQ0oT8tkhrCz0FxxmDbzdHRQvNylAOjPFtODl+ZcUTszanKy1aU2Vo3B2cXfVzOHEwP9ifYS76173hCTtp1TgdGZlO76jYS4s6QikckIpYPnrYj7zOJFdqg+2T46hxkpTD3R/ysbbLvwgflABQMLBUZTQ/H+fyoRTXUpvt2t0gQ5V5KgHD4pmiu2o3qz/aNPsUB9aOY0WQfQTGb7D/hOK58BBuUFQGIJdi9xoY3rPnEpZNZiXk8gsjKjQVepVQoSZUA4pXh/REu3pssLkrXxAMQG3ZbuTdD2gvTKjXZV90l5JY7Q0VD8M2b5sloQzUlJmrtF4aPVauPyu+e06f4uGlaMNtdthLL8R6CfYGIAk22z+V+I3IGDKPVNzH+q1Ap+efaOc4rZzmFk7HpmjXiqKVmXeav2njCrJim0CWb3/Qsq6EKbtreId8G8e8sm+2e0zFLp5TbSmyDtPGUiIfndFd2p+S3LeaoE9Mw5fVPkARgB4F+yZLHy8gHhhmSOeWR08aNyEgNF3rf2KvIc+PdcwgsFrY0SJ542LXO1dEszU+qiIWL46V19qDvGAoGxmPauY/QYTlBN3UyX1tikDwbOXvYbtHBtBzTi/YiD6ICgL8QIRuxgzn45fk/hP0hraid8LCcompIP4WJmtk1dOZ770QDq6ccUw2bBrbD9CdDjpzolHhkoXL3MkWd5Le0c7hhcrfRDsWDojg/LrY4718fT1S8YWEStZ+c3agAIwp7FV9N+fBD8iJOLbG
 iXm3WfIK
 SuwtWGv6CI7mEsMSpI/1hwNk5Ymmo53YvoIvvM3up3Qji/+zZIG6eymh1Mtjdun8ZBvjPhzEDpWLPDCjAYQMmjGxp3y804z02iVqXSAaR6iln6toI+saGfdlYm2mtfppwqoqy/8cMOEdqTJM+UneY/r1XOes7JI0NYyMP0ThhSJOVF9hLg+IaFkjby/8TkU/EAas75TGhn/wilIh7/5gdG3aMMYIoNKBZt3y+5IXpPUfK3d60nxofPLxAw1E40aZPLsrbbiR17MnTkfl/FoqZzbefsoox1Uyw4Fz/CPtxHSmXestCxs/knMWT4fU6L9QUJxU7GVZ4MpZTD8GR/sy3CyXIFZh8Y6MjHuF02TLhPQEP+BpeKGlMNwZlkdxIguJYFO9P+4xf0u80KclBl8AZIiA2e+p6188n0jt84bwtkS2IC7voBIFO75ruKeaKzWSUTM4flUV60nbytek9sxULZDjGNnhAjvS1QF767etdWV9esRXXSmEREw/aM/uC34bQ8ypUo+A9lx3JIWKzVN1d+tznwWsmWvgQ85ai0FpExu0lWwE36KvmNmdVoP1FnE/THlTqLooGAVCysTUodFT6UcUoUIPnc6DfddBsWvpwFrjELkRj4cNsGaQlqVxuUh8G01WzuBYe+kSMmO6BkzuNHe3SeWehJkA8pbAOSI1TIZpThDzVTs9Cx6du6g3DHnNE5hPvUPwXHZyB7a2DGDzbXnD4Q290cAUNN3ZERzHg6eVaEAKrU0J8WhngqORwV5wv0fiwPGwoUDfGCj1SyXRIZu6UL608WT+19RmjMD/mCDW9OWIx8Xv4LQkYm5X3+su9NoBfFxw4tNLPKXh7mKgSVYJDrw5z2OBwL65fneYN0ff/79PKRGquXmsE/8Lb/rc5cZJdfDaWXbYSUiPCW7IFaAHdCIkuF3jvFjAqDqUGBCJPVAwk4EmHqFk8SjwzMD0R/FTiiFrqqMsWMAoYpoqYDuJTFpBP
 V4isjiFo
 W5DJYrbsCcn8kXG9v3FlLBOc2IEFnUEYxFXW9+yvNtBsUXWo5cUynTaxHAjZDNWftnHd/sQ87gDb6B8di28oTfNyabhZzyOBzsX0oCqUEB+WSiQS4nBQGfdqLXIzOw91ko5lNJ0vdS7u7lynWLVAoR1Zt64mDBnuB2NHW5WByFoVSAkhefTz4fARrRB0fOCYM9g0CAEtJNFD1HsJjAVLR+4gjrTRdVKF7vWjMhME2+N6Kgx0QpRmb6UiME/6w5kiV6JOeuACW8ga+fyV08ZBBfHkrYRsC3fIxkvtwPydH19sQ3ares9/BT06oNfQX/6uCLZfucMrwGpDg4eg7QafWkuVRGuiM4nJfZgVrkkvMfslz0gOF3epgNpdkO5PY0ExMPzWzlVRmf7kbCsyVjaLT3BE1q41QVwG/7dlHsVpz1RICg9AZiq+BXGNUh8SOiWY9j3dFcTB2kzvJuF6nsoosW6mhFXIKJIrhr0IzbjayEyiJdWfdXopSDkQ3ZuomLJUPeMh5MUTaTnNGqGKVRkY+/DzKdybTga8DHIrDngFGKMlJO6i6ylxtiOun7Y+LOqeHudWGgV+aH1VVQVZxNrF+gL2vF2JCguJs12RxDBFVe6aWBh7MjamsAP6vmI8eZDGS8Y1CZ/Hih4YOpJrw4ItvLMhqOdEhKhFyHfQYs8Cm+8vQDBj+ChcvM/BLJUabAqUkimOIVgVCwpEXENzSNB6b+fOsT94FtzVVX51Qz8HbSfZn2dZ+KijAyHYeogxNmMTe0fGnFuQA4RWkFBxB3sKsSVDdL9x6bXicfOPl7Mhn2t9TIGvarGE7BLJCl2Bd++BDzWKOyVz69t2XO3iKUVtWOYPsSC1yciOiomneZWDDlLP2oEqbaGEn1pF/KPADvZNKT5a1wFZYlxKgdGV8flpOM/LITsICS8zg9Vnnba2M1fN8wcrowEG6UvIvVoMOMcUNbamZWebGRszoOQs6rZ8bQ4vjBzMx
 7l+muc//
 enTGqAs8782PKPyS+ru76pyvU/vvYTRhTRv2+RnCOaU36Uj1cIUyJokKSdzzlhKMHHkrgBSl+9iyVgSWLGPzz0BZB5oDhlsrJqrFh177W3S9VxEBto/uNukqOvtKNKTHoHuMmyEIpYdsXkB4SqxdMpJdAWg1kqnahXGf+SE0q3EZV9WjB3CFFH8zaS3QaVUgpuIJS+vGzBSjltWMSrDFCs2C9RiCHtL3e+LcdNKWdNZUkdlOH0d5iz2Zgo5vLe5b58cYT9SJTkud3o5QCskmGgkLY0KBwpCz7HWYGW+VlKnEoOU5xt9LefgkC7SawFylEa1TM5mzyc5Kr97VsfRZzL1v37Oky6kaOhyuIxutk/xShBP0mdFrCtwNf9niePSOSc52OuXbnGGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert ntfs3 i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 174a7cb202a08c550b3b8497cdf6105192be2e43..f32227750d6f569286fd973a5ca745a655a470de 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -153,7 +153,7 @@ void ntfs_inode_printk(struct inode *inode, const char *fmt, ...)
 	vaf.fmt = printk_skip_level(fmt);
 	vaf.va = &args;
 
-	printk("%c%cntfs3(%s): ino=%lx,%s %pV\n", KERN_SOH_ASCII, level,
+	printk("%c%cntfs3(%s): ino=%" PRIino "x,%s %pV\n", KERN_SOH_ASCII, level,
 	       sb->s_id, inode->i_ino, name ? name : "", &vaf);
 
 	va_end(args);

-- 
2.53.0


