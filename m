Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6800FEB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCD656B00AD; Mon,  2 Mar 2026 15:29:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97306B00AE; Mon,  2 Mar 2026 15:29:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CC86B00AF; Mon,  2 Mar 2026 15:29:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DB946B00AD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:29:22 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 653F914031F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:29:22 +0000 (UTC)
X-FDA: 84502262964.19.6CD292E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7B84F100004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:29:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fBMBqtar;
	spf=pass (imf05.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TflinJqjU0AZ7hcRhv28xDNB0iJ0wkqEl7c/yxP0pNU=;
	b=0cUNdzuYhLcb9LYJkTBG/kA+lMeYh1kgALlbTekWopS/PvR/To3DMO2LCyXzX+q5MkpF4+
	TA57TB02uIbF6nSh8WIXfFPASnkSW6MACwda4BXtkBqjnOHU6ELXPDrP3lOdHWZyWXnRWI
	nI/Otv/SPM68gefa82tbzEN29Q3iqlw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483360; a=rsa-sha256;
	cv=none;
	b=tK/MPtVtd7IvvrVbXuOhQ7f2M7PAK/5Oro+gnCHVKiVqaRA8CQX1fHpGOPa8R4E/VZoI50
	ZJP88JGnHIIjE6YgZk8w04z9brJN8vASkEMjm92+T93FQKLSReyjCJsClYp+wDei+RhPm/
	ghGxVjr6g5orW8r15S0rRmUGIqcHHSs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fBMBqtar;
	spf=pass (imf05.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB04660145;
	Mon,  2 Mar 2026 20:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4398CC19425;
	Mon,  2 Mar 2026 20:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483359;
	bh=eZCt7O/cBHS6+jaXbF0bDvdTJVnhNrKq3wa2lAjd6r8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fBMBqtart3aD0C9RzMfCHTMFx3kcpZai+WoV3/wlDdnhCRn576Oi01in8ttP89rrE
	 1jbLEXnH+DHrEGsYmqJiPrBONqu8+W536+wcd7gPdwUXljUJbhXOcQjv3U58cWs1Bw
	 yvA04Z5/1tYmvhR6EIwuN4x6yE4TQ3vij1yl36SwVS+9uAikR3ofEAIaHwhf28yVQI
	 nnWs1kCVddFM1M6h5PvLxCCq1vG4N3N0eg9OcH++fLDnbg2+WgxiVb6DgHnL1XIpBG
	 kmEmtZg4iFg5s/AtPz7mqssjfeXGuS5qEvVqKxEZGY+sy05o1BzDpXrkCWS3pnQ490
	 lHm6Qt5QdCPrA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:02 -0500
Subject: [PATCH v2 018/110] afs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-18-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3901; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=eZCt7O/cBHS6+jaXbF0bDvdTJVnhNrKq3wa2lAjd6r8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH0RWX8wpryRk/QgAbjn1Q1ANZbw4V+PFw8A
 vATQsWHGvyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9AAKCRAADmhBGVaC
 FQaAD/9DyJTyKKu/cuTCajh+8TP5xfDXlFmrEcCNSHdEiwWEokDdm2i1zkGOG7X37vO2jK00FQo
 WjBIS9/SahFHFKYltsILzhUTsyqG2dGgqlMHmmvEsPlH3sY4ceSTCVxr7QPAAXw4qs0Ubk5uk6v
 66Ta9GmMoq1EVnQdLiocwj8ezT1Tip7XxRvuesh0eaZ4t7PYnVShZvOq/8pxR5lBdi2x4UawIyY
 Da9WRPW2K3CENHKIL0mMv6M8duTJvIpXQM+1jTZ/GxO2pPtbYoVrDsdcZbOufwZv+2khcznhGTr
 asoLO2U26rig19ah9eoWCs8/wlRtvU+8z6/OlVXeeF9rGXbbLuE4iSPpUqP7jxBQfwMuHj5ZCX4
 EOxwz8pdqTN+NW6Z5baBdvt2ZlIAiut/DYl1I+MiPUYp/UJ2QqGbCm1lZoP/SYCEtNaAzTbIKAJ
 u11RPrKEnI/046wbiTYxb3VWrNRz9oxghsSipLPEgFccdFxmdm61J1ol2HcWaSxC6rrtcP7Bevq
 KGc12QzSt8zNfENsH+pM2JNf7XxMK5LTyXT3D4pnmbZsw+aKFwf3r2GmTAt+nCEuWwd050ur19+
 4lYSgVxjvBOPBGW+PkSFoOwP1q2Ro8/isBujNxmKasNg0fsW9KA5a9E/0PjiIrziosap53nhDmG
 NQgJaccyKt30Rqw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: biut3xihm3ugod95qrwjt9p5jmt5n7gk
X-Rspamd-Queue-Id: 7B84F100004
X-Rspamd-Server: rspam03
X-HE-Tag: 1772483360-774601
X-HE-Meta: U2FsdGVkX1/ns6zIsslELIi2EQCDhRFbsUQ322eRwtOUyPTGG5/CYONPxDR7PswF/HZ5w3yJ8BO0rHA9lV1oda+VcPapcrurq2DFw+TqOXyit2jWf8FXr/MPV1fpy3RJzLFNe3pNX7sqgxzwaOYeO0Gcs9a5skQFxzM1GQ5EAnkAGcn3/T6VRthwF0P0sjVZx0m9mFcltzLyAOvNMLe4wvv+QyBiifd684k2g0yi4mwqn5NgjM/ztDMhimrzaXDJUuEn9zfVCfgY8AUFhMUddBIvy0ek7JGRLgVVSktvhV/ByX6NgOtPm3cv+ycl7dXGYxmAPsFn4QZmXRJyDGOkfqQgAkyWK5/dLq3C7VB5skScC+Q12IKSHG8USwDHy7k9/IsEP4E5yPLmbR6TXyPL7xRA3HORiN/S6sAW7zAlNBv/E9GVnvEoxEER+jj12YLp9r5Vzvovv2f6RGCuxDyynFjZCibDbH5M30yS4Jsn8VMeUOpYcAZ46GA5Kc+VkajE4hylajoyDref6RhFu6dYu1VDeH1v0cK/NFrxB8tOZ3iIZooY9lXeIYadLD3nNxUrJsrrK2ZeJbOaHFOmi3B6hWHts4MhAC8Aa5TV6Y090ECF/5ETCW/G9gjE8nuXhrMpg1RhctoX3Ai96C/MLusMI6Awo+RVZs2fBMCaSnv3O/8ShDY2Nu5BizWvsYKShYzb5WL+PL7vZ3Lh6OH+J5QR8ShYzu60fu7O5KxMXoUACJOos1T6F29Y/cSpzoMbJYGc8d/rasSUqLd2viYOiHDYze6hv3h7JLdfKrcU0+eD1JHvJGcs/pIwojYCRD8yxFeMz66XJWRxur3yozHJYzNDy/gDkv8W+IsluSsya0W5cTSr5Mr0kCFLYqQjZm44PAHzHhEvjOmzbSdw9n2W1nz/HUhajxtgUXwqL/wqIEzNi+2fIuHYohuKEjL0b2nKBkTQn5GGbWGPxNpti5c6wam
 bons8in3
 2nO6ym9KOIL8yG4ZfEzvjQFhxGDnU9iFjXDNi5nlm5raYZmDijqAGlzbPqXSwltBPg+f8N8mTnWL43DbnaAFX5ldKU9YLFEQRuf3xf9PakH5PsaI+RNrLEoCUpW4cuG+hb+cuZtmMpwrlv7hVzouOS0yjfdall262hfdDO5qD2Yl9NF/AlOAF9tH0JyZZtqTnTEDlMPVpm0Wfi8ywzyKZQb9DoiIm+Tfuva9Us26mbojSQNfYGK8nJiqeaalUHxpr5tygr8OVaCr1HVyJ+ggA9YnrF383d0fLO//v0vXy3QYlX072aZbDlb631hubffzm+NBR47XwPFjNn6HB/wKp1eSQdVEbr6KguRHtd6+n058/iHuNzR6z3pSh14il3A1RcGIXfLbp0O/aiZlyRHnDdfREgCvSkRmNYwhJ02u4o9G+OTOwKIq2B8G9y6qe/U00YH3ZOHFlAS0s3QAYJb6CjtjKmFxX9Dt5/6Y99oS+bdxoqeKm8joTeuJsX8H4xNyg76Y0QjsqECYq73QCQevQTPdTbw7cD0mtWn5pozyzJev+RTBb+RPzycAInZHOn1oCh/QFqTQS7foa+3up0e2rRxl+fKqx3Pk2gx5UCglee6VSF9KD98jSdaXEJGNkIOtllwk8OvA5PjArE7C3/X2cmnuo0sDavK9iDWSepNOKw764rPqBVpCnhFPawA+jew7iWh92bJkL8HGK8cQv2M1D1vwc+ty3cQBTixIBtNEIc3SU94/EJJQNvxIfZCUdPwNbbyAVjnl/UYwUWXVHs8PLI//jgC2KPRzo8otRY8lxLfL+ZbRtrqNj/EboUd1cf6si/9MEbR9YXYi+eYskqYCQfN8lJ95ACYYD2+p83uGQh5qZa/2ysiMUkTpODu13FyOP3yKeTGE/DMaNTaZdgdnoGIAhpnsxSYPUx9v6WCGzFgfbfiaiUrFxfDgP/OOcrDq1o2ELSwcQzU4YkKxE6J6Pgpucf8KK
 lZBXwwUa
 AqVAx57IerVa6Ebzts/fOhUfaOOznhBuA/li7eB4T6P74JatLIiJhAi0xGqGkSvfFoa8KDjIgRFd2bPyhrtJB4K3mTIfz+JsxEPxJvcZyZZYAKGkYLHbrN5bjr15ja/TegFcxjxPMbrBD+UJGNxlr8gyi2fAEyzlJTzocZNpJie0BFINUfRM/8mJgTjBmXnGaTFyqJ9S/QGIyynz/Wcu7e6YCGDKUuo6tl3WqingkzSGmxxqwCn/wLT+haaMr3GKokdRvxdwaZBOBNDtjrqXBBXBK2dIs/GkHJjpaXgNpycrvWEmg5v1dIepIbPrWMAOY++b93CtnufDn6iHQ2jPff2JmsV5pzbSUzmZbPl40WTci/QUTy0j/x0iSWzS8+uFg5Vy9fIYf8C7TtajDaQ2X+uL9eItTJbjPCEfhF9eBxXAqcIK/1r+cjCofNwNstybugXGCyzDNuSKAOBr6uel96AcKsWnXVWdnd6lVS4LVutt6cWktMXj/NiOa8zSqlgthcizIF/+hTHs8RKuAhjJ+lALho6yLMjGDfs4JKwtYnvph+7P2FmBeQGuLpOTFQxXu4MLkQnlsdnTS3na1lJYVc/LfIEJrcoruBHJGTCWmWzWRrByjvEzJ78fGSM9f6DMj6HnUfpNDeSNN8CsG4a5HjWwgNyJR2vsYZN4dVi+IJ1hyTIXGGKI+kkAgA9M5q3VrVae3wjVuWVwfjhwJm5OJ184ElWrvGGpYGPcsmKdgFR9zS/pfYRw10FgB+zEIrYW06yLqS8P4AbOg2VySpqcLasUW9fNFB9eIxqoT5UB526eF3OyzSRBCqJrs7B/cji6hF4K04Cg9312XS2xYHv8L7huPtzE6bkhmgggBRwqqaP7afEcLQdE5ntloeccnD7s50rKC5pD6+S0ThKVDB9RqIcMjMy3Dr7ipcJTC3GJkIlzt9ZLp2wrvretaoMGlRsMB6xfyvt9EuXtPayyi+t4QRZ3X8ot9
 rb4y55D7
 89jyFgXUHYzK65JlSnCAl9rVPCdOH1d5YQdiWfTqzJyi/ricxslvQCmNjkXS0U2AvMHN5O0/CYGj4vHg6NN4qEUiyDakncdNuGBpiCBNp31q2H6swipMWeg1f0PCUAAQEFL01akpqY++kuAu3BBddi4SguMJeGC3jq4l4oOSL/9iqCAOfmbgGBkvmWLsVFvf9Dto5gZiAF/jlOA9t6I2v6L2yDFCicT8qp8fa46BoC85iyH/+F5504vzMCWCxDf5rHmZlvMn6YFZN75xPX4PWr1zFNi1YKWu3uyN4aB3ao4ngGOpFXP55pP5y8WHTJlJs5pqObvi78vG5lT2i95IrfWlkBQ+R/XRsuoAz+aawQmgNNiBuhKRxodfg4xc28oOlTHWvzOn+gCYDYHuDSCk0p93+WI4WQIlCpkdCR0NlrXq81TMQVR4f+lBw9rcho1ae0vlKXmU73bYuEMZYpO0/CD4rSpmmPPW6WuyCExiu1X+utbgX3RHfv3Em+CYnvtAzbqgklRgpUsTmy7RSBY7HC8Fzm4GDpOB9ai6J0CgaMyC18B28itHadQ5jauEdTtvYVCwS2Sj7wfmqiHFx1haVUEXn6uEz3Cgy/i+0Bu8Ra5UL5f4KBUjZ0bj0AxP+F9V8QhgttqmDkGreT+C3APryT5Mpru+7awDc2pQaCKxTWmK0lCjv3zM32lZfSxAdmpB8nmL+lvEafYXau4/wG8DU4522OP9g/tGRqpoZq/EGEsVw6uhUOwdDvKTeQ7FGqKVoP7m9iagaXYnjMyoc+93JNWvyoTKBFr5SHZiyQ2AfDJMPczwun983w2pgiW5Kv+UoV5wIAF3qpE41v1sDJso4aX7Gy51Dnn14QcNUi2NfzLYmaKEbAY28vErxcaYOFkRTei4WWR3KiM4N6JUZ5XBy/QTXK08JFGT0Lx/E4zYwMSSaBc/YaZqZSlY3l3ma52IzCpBoRuNascZL6YTZD/uCzzaXNKDK
 yxNKwp6L
 XqR3+rVZ+39deKThQiTZdw2MoHq/HRE1WcmHkiBWwwLQS7xGOOAUkPblDTpteJxvt7qGU6bxy49G7N+g50qyv52zRl8obnjB7ygmcwURz7gqZBcv98IQnAUQ1Dvt6xNhdNyMZmJJoZMS/aKSQwG9k88AQp2mVccX5rJmDVDbYfxNJMzL6wNX1/B+WEvN1d5i+FCV/lZQ11Nz0FGNbpverVXMG9YwtFIEhe92heD/M2+aJeYjtkHqz478yS9tV19nevfDEndPuCAsAbiOjz5o04VVGJo1VBwxIVKUcncrubOV7TVXuo+sGoU+xOYv9CT9amFXRfPFPZoJwRG56YVH7egy2DxShv5Vb6WOMe+NCvsoeji9AgppwUJlFiAtKjXdBPf7XPxLBf5vPuNnBQEAvqKmZ3GNIr/jRvoFS/oywsNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert afs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/afs/dir.c        | 10 +++++-----
 fs/afs/dir_search.c |  2 +-
 fs/afs/dynroot.c    |  2 +-
 fs/afs/inode.c      |  2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 78caef3f13388c5f604e4970bc0874de168b57f3..52accf0a8d9d2e4dfdff444080683d5ab16d8e69 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -148,7 +148,7 @@ static bool afs_dir_check_block(struct afs_vnode *dvnode, size_t progress,
 				union afs_xdr_dir_block *block)
 {
 	if (block->hdr.magic != AFS_DIR_MAGIC) {
-		pr_warn("%s(%lx): [%zx] bad magic %04x\n",
+		pr_warn("%s(%" PRIino "x): [%zx] bad magic %04x\n",
 		       __func__, dvnode->netfs.inode.i_ino,
 		       progress, ntohs(block->hdr.magic));
 		trace_afs_dir_check_failed(dvnode, progress);
@@ -214,7 +214,7 @@ static int afs_dir_check(struct afs_vnode *dvnode)
  */
 static int afs_dir_open(struct inode *inode, struct file *file)
 {
-	_enter("{%lu}", inode->i_ino);
+	_enter("{%" PRIino "u}", inode->i_ino);
 
 	BUILD_BUG_ON(sizeof(union afs_xdr_dir_block) != 2048);
 	BUILD_BUG_ON(sizeof(union afs_xdr_dirent) != 32);
@@ -523,7 +523,7 @@ static int afs_dir_iterate(struct inode *dir, struct dir_context *ctx,
 	int retry_limit = 100;
 	int ret;
 
-	_enter("{%lu},%llx,,", dir->i_ino, ctx->pos);
+	_enter("{%" PRIino "u},%llx,,", dir->i_ino, ctx->pos);
 
 	do {
 		if (--retry_limit < 0) {
@@ -610,7 +610,7 @@ static int afs_do_lookup_one(struct inode *dir, const struct qstr *name,
 	};
 	int ret;
 
-	_enter("{%lu},{%.*s},", dir->i_ino, name->len, name->name);
+	_enter("{%" PRIino "u},{%.*s},", dir->i_ino, name->len, name->name);
 
 	/* search the directory */
 	ret = afs_dir_iterate(dir, &cookie.ctx, NULL, _dir_version);
@@ -783,7 +783,7 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry)
 	long ret;
 	int i;
 
-	_enter("{%lu},%p{%pd},", dir->i_ino, dentry, dentry);
+	_enter("{%" PRIino "u},%p{%pd},", dir->i_ino, dentry, dentry);
 
 	cookie = kzalloc_obj(struct afs_lookup_cookie);
 	if (!cookie)
diff --git a/fs/afs/dir_search.c b/fs/afs/dir_search.c
index d2516e55b5edb273677c9cedb6f15524bc56348d..903cefd81f3f2ccbdb28264b5e99151f5a54d1ce 100644
--- a/fs/afs/dir_search.c
+++ b/fs/afs/dir_search.c
@@ -194,7 +194,7 @@ int afs_dir_search(struct afs_vnode *dvnode, const struct qstr *name,
 	struct afs_dir_iter iter = { .dvnode = dvnode, };
 	int ret, retry_limit = 3;
 
-	_enter("{%lu},,,", dvnode->netfs.inode.i_ino);
+	_enter("{%" PRIino "u},,,", dvnode->netfs.inode.i_ino);
 
 	if (!afs_dir_init_iter(&iter, name))
 		return -ENOENT;
diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index aa56e8951e037b2e3fa9fc452b43e7bd2d61b926..448083d79c3d0d2f29934e105f48d617330de8b4 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -59,7 +59,7 @@ static struct inode *afs_iget_pseudo_dir(struct super_block *sb, ino_t ino)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	_debug("GOT INODE %p { ino=%lu, vl=%llx, vn=%llx, u=%x }",
+	_debug("GOT INODE %p { ino=%" PRIino "u, vl=%llx, vn=%llx, u=%x }",
 	       inode, inode->i_ino, fid.vid, fid.vnode, fid.unique);
 
 	vnode = AFS_FS_I(inode);
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index dde1857fcabb302cc6b06cc018fb1e4108ec6284..a0261c2c246a379689cbaa44b7ec456f1a986142 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -683,7 +683,7 @@ int afs_getattr(struct mnt_idmap *idmap, const struct path *path,
 	struct key *key;
 	int ret, seq;
 
-	_enter("{ ino=%lu v=%u }", inode->i_ino, inode->i_generation);
+	_enter("{ ino=%" PRIino "u v=%u }", inode->i_ino, inode->i_generation);
 
 	if (vnode->volume &&
 	    !(query_flags & AT_STATX_DONT_SYNC) &&

-- 
2.53.0


