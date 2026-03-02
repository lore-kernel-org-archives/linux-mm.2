Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56B82EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02E86B00F1; Mon,  2 Mar 2026 15:37:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9CC6B00F3; Mon,  2 Mar 2026 15:37:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA23C6B00F4; Mon,  2 Mar 2026 15:37:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9987C6B00F1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:37:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 696508B37C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:37:31 +0000 (UTC)
X-FDA: 84502283502.11.8231C57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 899E6100010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:37:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kk2zQoYk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylDwaPdi2nprsFBnGZvM7hP7Lz4lwas1MJG1wBpOGPU=;
	b=ooxhP1LRtYvSJN86kjHiCgBOTzua/AjY+uMc1wU1ZzSh/Uv6N+tGY3/E7Ec6J7XwB3APPl
	jmLSF3wtWzTql8SW5Sx861mOJ/RF9SCSfGxxQ7BYa9aqwMa5x8FQ18hRUFlR7pEAcnBhuJ
	91KlLNfQ+FP6yvBtf4+rZxLNiHOiYCQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483849; a=rsa-sha256;
	cv=none;
	b=JRrDrNFp9p718Zb8ZLhgx1U30WSmrakRUQQZCqC7H4W9Q7EVTLHkFfGN8+df5YxB6aSKRa
	SYlhM2TfdTTbwb5v3nwXDNrIa/G8omGluPF1XlhC7JwE5rXZlvfQJz49/8SxANvinUVZoz
	r/qnAQGCwzTSTkCu1rYJcNgbLt0GcnE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kk2zQoYk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ADDD43444;
	Mon,  2 Mar 2026 20:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC4AC2BC87;
	Mon,  2 Mar 2026 20:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483848;
	bh=alIboQURMSK+ocSf/bFc1ar67kVswLEBUSDYfenVfUM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kk2zQoYkBDVLmoWgKHZGKpn6ciMFY0Lbxt9dGlgIR/0lSt9KnofVckQ/mlSO61Wd/
	 JUadFiLXBbn75sghsOdtPcAm1W0R+9zn7xYBbZd8Z9SUbEkfHQaN0R1rsKSsPj+Xmn
	 MgSlyPKkbHTzlCSvGcKDN6rfFlkyCWv/Qp1l0NoPWsIIo6XbKx2AFBTeAIRA5boOPV
	 qckOmImvtrEhq3IfTiENBL1u8UnTNC70aoQfpfo3E3c+ESJRJmLbAPOmVNChAxcqNj
	 Fre4JczkJH6RIUREqUj8fF0NayvsPuWmvQCQr2RaNhqGgQ2jiBHhT1hgnCt+uvBxbH
	 VBBzAjyYbLQwA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:36 -0500
Subject: [PATCH v2 052/110] net: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-52-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=725; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=alIboQURMSK+ocSf/bFc1ar67kVswLEBUSDYfenVfUM=;
 b=owEBbAKT/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH8QXEIw/5gHEXeNiHaVL979z6DfrTJZcwhr
 5Wh/IhWaSaJAjIEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx/AAKCRAADmhBGVaC
 FadsD/jqW06qbLKQK8ySWMls9LvJMwDTfI0waxgMsD3IIx5QvU7aM2FC4Dzo533i69av7HWEhvG
 AL5R3yXp7BtQ1uhorCB1GGR9HPQDeZnkxUBmuR7b/D422qzz6wmLet1jyHw7x3AYUDXKo1hc7qS
 KV9z8VBGFhfutf2zvQqvKDr0HI54etmLsRNGzphVmsn/xpAFZrbDaRYrkv3dG16RrIWFIIJ1z6p
 iJBtOkUzcnyydqX/T2U4yMAQ/cYn5B3Ff8byI1QIFb88cQbgv9jRQce7DVC6Be1RpdJGxat2QLg
 DSu6J+cB1HiZ6FMJOzsocwII5LsCxvTORHzkuHcONuuqxERq+e82InEA9w7HJQ7VDTfDSHOmtTa
 X9kgWHAicmgUEVJjouiXOGERNrOdM9noz8bYXFmeFlDhs8gTW8VNwsqW6BkLRaCs7SC5BBd5MNQ
 JKsUnY8t4txGe3bRKcHDJOaAhfqWJX2vIjeWNBQVz7REBu9gXcMK/L3QIaGDSelXK0JvXWxJDmq
 rQg06k6xTCn54Hp3APckPu5S7lmRwAS/pGeL9MesU51wK+5r6lUmk814kj6Y9FVd+3ycy2ZiHvc
 fepQJzb1f/55QB+/pq3Mor1mYgPcV/SjzpEp3xUZRqIeC9FpR076/m1Wxy1t11+r73esUyAK9SS
 5kqXEvwauhcaj
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 899E6100010
X-Stat-Signature: 3c7n54k41e5aek6ky33a6kzkad4nwwio
X-Rspam-User: 
X-HE-Tag: 1772483849-808664
X-HE-Meta: U2FsdGVkX18gqpA8EUUef8a56cfhxsz7yKV10RjnoAh26eIZ/Erj/mYYiyBuo3/h/BS10TD/CnLk1rUbD4PwxgjZeGx8DuUogHmVMHdV0HH+9eYpRrYEh5Zwrqc3DNRRj1PVEcSWTLv4mCFxmnpxuCXaBu8ScMqXnsEfQkWwEB4RZSw9ThG1Ug7Ej/4oDPTzz37KBJ9M2PlubyT7r7EdnJvdccRaP4tNPeEi81bM56PjlhjK4lltQ315EhuxCtnlwGV9VfycoIpoPAKYg1i6bwrN/18Ms2rW0jv9CPFVi/ftDXYlhi+HV5Xxctw0zkUgA0vJ3wjUOge4M7bfQbWri57mhIsdMLu4Cw9Z5PH7IRlH7nrFoZdyVeO753nrbKD9jh1rYpfWWkrqvU0kYU3XCRpak1EksHgUoIdzoGhOH5YevWgdKNYO4mEVkqRAH7ae9iT5QaHQPE17v6cWDyQNLHvyt4Eh3LcxiN6FI0ul50EbC/gCW9hoVgaqsl965B6ntmfE7C9Z7Uy5rJ2dqsMyBExXUsofniTrIAgM+7m/DwItOIKw+SLZllBMATPrS4J0a6+XHeJMd7nXo6TqRsZcfV2ZFXNos5QrGrfTDWxHq+0A8Iva2W3NDLtcjU+HpSITo7UlHeOK8dOz3B0hVipgeui2tlTgf/X2T9AuYT1qO4ix0l7euXkZksBPI3ozd9hX3MtSumR7PKnpRPnfkp0p2+d/3V9Q68bSg/jsjCivZKUD+GCbilP/jrMhNEckXtZXwcNZICY+HFWDvP5jPMbZRImwUV9NnZ6vPbtQNJ2wj9sQXta0Dt53LjcyffI49PdJ2EVeXcQifIYv0R/8LG+YN4T270edY9uhpTTv8emPfwYUGUAu2MJL5cv1vO/BItREfSnY5xapVbTW12D4mn/s81E4/TN8VOACNrpGnw2An84n0SvZHTt5g/hSgzEQEZAdx7qqd7RGmzB12vjZ4Dy
 ojojg2Pc
 AL1ke9vRc7XELoetcb76m+gAvGQ9ineP+fwKQE6k8NHhPMxwO8qnPG7SkTeIkoydzxZPywnJN3U+W9p9s8qjFE8DKRAm3inLDTu87G5Cp5d06uUE9LECpAopWRxEXgmmbeVbuQivpYHMJQ3a8bxKPjiOyT/wbZ+GfWqI65wb4Z3/Re9b1ancJOt0MbZtvhVfnTnikvEjBz+FljojxaqyF1sBSU9q/PCSjcxdZWTxNu/dh42iKpMPXoxfKAiIFcRGnT9P7+iIbhXErqpeKsNnFHy6g9h/LhDsKPa4L28Eyk0S0koGYPKKDFIBXQgc8JACJggWxXxgOvwu7ybLqwxV38hC+m0oWdAcEMK1KItHdZEHbZjTtshlJwrz8fztAUH6MZpYdYzNrAg82byu1/cvR/4EJsi8frT4WH+/ZuuPvknU+v5ww+ez4TRRhlGh7Km87i6SQNU6ORzm+XtL0Rvghu2UvwIAeYojDIGBCLvzxutMjr9P+vQXNdV5sClyjTmS7T7TT8TatBiTpHwekLf0D2MXuco/ylMaKk+EKz8+MABucDlG4nJHRI68naQopzceU/D+OpKgZRLVIptWSzpySDbsCT9GKHKVfI2cdZzEOC45SrrKMWwBIuAS2d4Hxcu6h9yd+SZsgz0dhM01hiKKAH2SQEjNtHLSI7HI9HBWVdEhGRMUaN4YqvwbXYsLa+ayd8uk6zQi1WsZp+PjcmTV0iWSfZ8TQ+xa7VStz9cwUSYefW/esbNM8XakrUnwDcyyRoE9TCF8YGNM7sjiM5HZM3QVV0YBSbxbWESIQzvICq9RrlZmYogzu1qsT0draawZGI/YuTJHoiADaL8kK7LBxmXbVghLd8QC9ZDUm+y0RDeKvMrPy2MklkFj1MlbKQZQpHTNiaELlqxNxBP21XQWcoiT8iBpXU6Nl0Df7WRQrojmNI/kxew+uFHMJlxHa19hWeUa7JbB4IRx2GsR5QEf/Z855ncQe
 voj9yndK
 EayTqogFTGJKuiIdjrufd3QD+skqHuaGSOTs5dKkucfErFdNl0rRVc64Qh68DBHjFfVHyKLV/kVhisspDCKcJOPu6dX+OQX2N7wL1Nddz2T7KvXzK7Z0qzBeXg4wWdum/g32TvFM5kXORpa7rpiq/EuP7LCgs492eynUAS4VfFz9U2SHjmqT/fs4tUcsKVf0l+6BkzCJSkFrm2Q2l6p46HVvXNgFf1wqS/rOI+mehrLoMvfj2TorWaFS9IbBdkotkQQHf3gQTpQtAQA6zV9TglA9RJRPcocu4XD8CrSKULY5XaQQqYlaQYLmU9n4Z5ZLERmNZthdWsgS085E6IZRBCbG/+v1lBzlxWpa18kmaV/HfQUSoqvrb0zlXcUlW2I/77YWEJATo5z0s9e+LiSkhEhIL0Lx3sYyFFb2wjzdkfXcUfCpg34vtQCLnKNQ5LpVRW8wSl8twO840mxUk62lsXqxIhosILZKYpRFBJyr3OVzhiAqsoJkX2bZvAfil+2B7vdqhm3B7zGB1nmZRpzKQsQtcvvh2z9s6YBOloxVhwJp3CfkVL5PMbuU+uHGulHHtPFCg6WMna6Twq1tgTziJAHamBrsBBJoi+t8iCHhQ1QbF+h6pGG9E2F2D3pWN1/FTVT/d12gktwgWwS3yCXHhjltJhgsCfirzwqlQBrPPk6sjyv8p/Arv8I6gF8F9M5a/nUU8kcApvQf6h6FdXgY6ozKy/Xo5ifw5EmtrSSk6p3qmsoBYLGkhUm8s3ZMcRxixmnlYyLF5z5/HjJbha5tZHw4tIc6J2LcPFZt5gZmF+K12FwJZcmtPG0K5zP6mpsE604JUuP4F2umus3KCsIkzWkooPge9gHV7TnPHBu/UiVvlxN2LSJcVwNl8Eio6NRjAt0JxkemOwTMIkVkBgg4L2DiHDZdOiivbI/BZeOWQU7CCIZkPmhchiNPn+ia19bJZLwlBF566o0FCO3MuYJOEL/5rCCah
 C5pgOzKp
 jSzCrcVy1CzQeM14kE46q3jZ2dtqBFb2YLOtOy0nbS8CyakppAohZPuM0ZV07zyeYdg+Y472Q4VpPQyFrkrpBkThK4omg+jHOlckzCpYXpCkX6ItEwlky4VEcVTvyAlT7bD9Z0L8ad53W1vNvBZADfrWBMXOSbMBXLIja3IMAWVPWI3/TsrndKLlM6wsHyLGTulbygbHdI14SMN+ZhfWtrU+aW2TEOpK70b3pA5GWZooupQjm5MLXwlkHRW2ieevYPH1RVgw6m8tFOkCE60vJf5N3k1sSBMno4Bqm/CmsyyAF9gUo8AShK8KZlYenn9OT1iCIoXWrtZ/kr6qgd+hZdlH7Llv3U5r9IKLYjaWaD3Z/3EL0SXV449AKQmmWRKNq+gd+TpWyFIwM+ExwMdiZ+lqzZosk+hc5fzwj0USL7UNVtDh5ZsLzR43oRxgU4dfIKOgq8M+FGW0ltKJSXVTLDoTGfHuApxYV+7DxAPXcpfgmc31XzRz1kjbOBTCXfX8G4S8qDuJ/y50P4WyFYeR8O2/RV1rOU8jhO7npJhZsbj1T6+ad8daq0RS8EZNfhbhSrik0rcnKZPs9WfcqAjMks/Daw9gJ6zdu9Dm13l09eBgnlYC9YbHLHLVfr2LYyr4hFzwnju7GMSBjdZBu2UqRWhklogQ2owWnI5CBD9BqTHBnUBoA6pfHLYQg6JMINh0xCBIg/3egPM4bzbCh9dVITEus2dH3cb5pYIzH3oDmCKLfI1Ft+ZCUUTmZGiHjd+4dZjAyUhuR/uoDN+9qzVRMG2ML3KfkfLLvU6sP/5MF2EnSaEtHbKTN6/lIbXAnH0jXBdhQ6gwTUgB6t/AmehwODUD18AiksE7b6ECZhOxxzXnBEV/EjA23iMNFObs8VwX+1DSYQVvz4VJ1rjHQGoV33nqzbLXQ1Ixb2vsa+gNY17FJrjdSDpYrU9iLXpnVKR0z/dLtlizGRR+AaTnXuWN6CA79N33D
 HV5HUFuv
 BHZ2O69A7wGq7D29lF4z1a0WfQekgDzT7vj5UrzNAeZes3UEvypVfOUofyEXBUParHmffKEkAmmr9szM8ufjNBRebUtXU4X8HLrTw5SyyLXkrVs3+duvqgUft05iYGQRMNmnFAl5kzHqKmNnJ9L19TjI+ZLIFHSIaMepJtIbFTiR8mhaCtyVjGm6HZ0MtVe6uXPmltcSGyb83LoEm8FJVwKvtrMmq02VLQDhgWqHkcwBJSacD1LaxI7ic5/XfGIkcmwRW0iHaDOZ1/oj6SKGHFdU5/wlzYGqXdO713dj9H9XmqSoOazxqgVkz2KUzmJTI58x8/tbeLo/S9L5he88KZu/YC9BIbEK2i0qadKU8GjKUErA4NioLKnoJB0bQl//DJt043yMaexg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the i_ino format string in sockfs_dname() to use the PRIino
format macro.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index d25be67e4b84a5a0a033802404ad06a837b299b3..24b89b8e39405972dd602f3373ae53d56a4c625d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -399,7 +399,7 @@ static const struct super_operations sockfs_ops = {
  */
 static char *sockfs_dname(struct dentry *dentry, char *buffer, int buflen)
 {
-	return dynamic_dname(buffer, buflen, "socket:[%lu]",
+	return dynamic_dname(buffer, buflen, "socket:[%" PRIino "u]",
 				d_inode(dentry)->i_ino);
 }
 

-- 
2.53.0


