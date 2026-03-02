Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9982DEB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089EB6B00CD; Mon,  2 Mar 2026 15:33:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B906B00CF; Mon,  2 Mar 2026 15:33:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E040C6B00D0; Mon,  2 Mar 2026 15:33:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB8546B00CD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:33:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 828308B3EE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:33:12 +0000 (UTC)
X-FDA: 84502272624.24.E0BDE21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id BED6016000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:33:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ulNZ1v1n;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLF0VZm6YONkPLY6EMR534AToMnEGkIaVj4ZfbK474A=;
	b=Ri6BP6zvNFuuR+JCY2uin4Zqz8TVuB5RufDbNZrvns7bQLd4/lefBXD7LgbiIx0lBnL2uv
	OEjrwFi/dwLqfc1CmDVnE96vnul2PE/iblfcrfJzE0BNDJuPxFDnojj40gD5D0FhYpObNB
	zbM1cY0MvKpzEpn8rvDNptvULhzjKJ8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ulNZ1v1n;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483590; a=rsa-sha256;
	cv=none;
	b=YaJovUUHwjHwHxNpPrhU4/cCWpi7ORLZmD1oCQkyZAbg7awKFF6HN+/fHO1x4w0RaYYNoQ
	dknVUyEgL99KfVWbz9ccXrwbvMOXY8axRFVpjueyGb/Hr/IJC6XTBpgL4MAwnVk/B2b6ws
	5F6qMjfjfQEEzUNPhyRzC+0vqVzoF5o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 075AE6091C;
	Mon,  2 Mar 2026 20:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9200FC2BC87;
	Mon,  2 Mar 2026 20:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483589;
	bh=2fWMPK5Jvgx3sChSGX/i85cQKEjufZ9m7RvZ37QQ5JE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ulNZ1v1naAKugDLRbGhhq8d/j7ysPhGdj5T0z13soVe+au7V6YWKPKgQPbqutMYo0
	 CWFsi0XbJ5Pow9s5orXp2F0QUYFBDrBGNy8yXWRN3jqHfvqbOIumOOqhToWtt2teqn
	 g00ve/gCh4FVUjSox44kER/1pN4jUtQyruLLXHLGWuV//9oZTNMDFrMgThCPV8MW0b
	 LAbuIwA9VoCTLwu+QyltCVyLOFmraK7r7gstprm5QE7S6jIPBtwtMvlcXGWwxPHZ7Y
	 uQNVTRSIJf/tpDAhNh17ugDGRkl3mN0Si5bZqo3AbWHhEc18opnkiqhOwfCaYUFqCS
	 XRommxBBk6Vzw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:18 -0500
Subject: [PATCH v2 034/110] isofs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-34-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3621; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=2fWMPK5Jvgx3sChSGX/i85cQKEjufZ9m7RvZ37QQ5JE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH3mTiODVdusXQ78uPmApvINi+EnNH5gx0fO
 +WQtFwoQ9GJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9wAKCRAADmhBGVaC
 Ff+RD/9S0mvqlV82eOK0hyQ84R82llXGhKpvMzr7kIzk9qL9vzVpGesAxuLG1DcvZXGa5n2olJo
 3nSpuC6Xhy0aVZO9GroT+3WPzWKaX6hiklpPiy4ikwgJi/5pY7bbRwGPgg/UQcpc/bR9yzOjySR
 rsoje91JCMD0rbhNroWvVOeTqgEbBwrt+dLaigd2I7X4hXR8S1YefuYDoqrr1TFqzaesnTV+qbT
 Y3RwcipushMbMF2Gx5M7ewGsApr4yhGU1sMdW3aRH36CfPFWyEQlmc92qReSqm8RlD8UHlJ0jA7
 bqCnFFHfZtmBn2erXzN/EICGvvNmb9U0CbTW/WAG+fiVkYieuun18tTIiQQw6NwyGbryJ8Q5t2O
 5qlH45GGOLlVU/aHmnNNqCBEELJePqAMneYQmHcCmJSrAn7EU7/GZOuIo4WJqHeLnb+nrIfYuBL
 QinbzHmc6EQ6bGggJBpbjYfp4IzkAeF+rfYQ6O9zrrPU5hn6k5eL79WZe2agJkGF1tuufCtIhfc
 vqQWroLW2SmnPNSPi70AtYF/VF8N5Gtt9fOlgzljYYxSVln7ctfDXoChSQjzcv5gPtCtICk8+Jq
 kvJD8dey/LuywFldNY4z0PujzecbQFJkmacbCiaI6LpURV0/bW2QIPpQT0hCorzIQ/vb/BZgwYl
 sbqv5VK/yuhnIDw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: BED6016000A
X-Stat-Signature: u1ikqz8u5jrirpsb69si1rqdit61r8ta
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772483590-518176
X-HE-Meta: U2FsdGVkX1/QZxD2XUyYggaZ2vycHUt2AExLbM2rMF9sGylMFTlOZlGzrNjoTkBa7VgAZHBPwhwvAKgyvAP7EppN0wAW0ImlLbGMYuLesTk1mkmOOcIikZTQJxYDzaa0gD3Uzblfggyg2FCcuEZ4AoEOu9U/LnCyHNmaNyX1hNZWr7Nlo+KDAi8sELBMkI2tP85l7/wJfrNt7vpGRd+1pWvsnJlgPNJaZe2uKCue9a8WzNGe2Af6zNCqGIQ6PHS6LCoaiv0h7qKPa1bCxhwqQVE6+aJ96cxEN0lELJBKHMIT7votFLU0DrFBb5uj1DB/q9qw6EP5JoxN1np3tMbbTzR03RBI7Wt8VyzoLJpSFEtauStfzxxXP79ux2oar5NLIudTsOLVvaVQfz4JiRnxfweHHMSkfxoxPEXNvQcjrgx9Hfx5SGA7B2P2W5IYxeS93RgHY8WQFvyGagL6Y/KUiMYH/E//E5biH+teUJKiILnG83l4vS03yz9fjRkPTY6vzIdYR22vRrOe8deQ4NIPjVHKV4MtTRlGI36idWB9o0tMWDH9A3C1bEurogrn5hMVwCinydFl5WpDdKRZ0kWRqlIKryfKiYpXutpa2tdzuR5GQzhie6dWYLoV/oizgMZ0CJnvYCOAM8Uy9gaF2uGZ8+JoW/cVqZgoAves5l9DbtSMnz01wpShcjKx26fPnCgWHTqGP6rSWWE5bFZeFMu2Kp6SuhqypxZbroq2BC1tVg+VdXwekE6B9PTzeD0bJWBpePWGSp4mB6Wq30ILYQGwp0dv+MsZjg7onCBg2DITMxWMSKRP54Sh/DEzEZlJmRNUxk5uoLfDqdV5uvHaCqkbqOOCwB8OOj2+G0rYnjwfsfLzojMXcAArNAeeyYwHzY0nXZbbgRaUmZGnApScguyt/EYbWWQzjShk4lyyNzbLa/Ke4txDkhHBe3NN3XEwxBhZ8k8cPtzKFuAS6X8q86z
 yDGNfHit
 BKp6xyPIA6r03rWB7vGxCqvmc1VXcHPiuBQ5HmCjXxP2oGTAAEGrfy7QOhKZLyzclRXM96zB/GR/qTnr2VR2m9QCWazTYe84EeD2pZZEYDnKKTkvuyCJit58Bv4aACkNFq3o1QbKKycH8dvWdFISVC1YcIr/QQ6Jw3Vasq2y5Rd7gbbj2bz39z0HWMGX70DcMdEp2cAOH3vJh50FcjlX7eK+MGCnmg9u71xomcEEpFlxXL0I6Lf//gVbB9FJFoUzH7QahnITqUal2G+OUR4lCVeVs235shbFVHEhfOVA0Df4tccbTLFnByUcqNdIfYFMEH/o2AQpDDLi7/Myz08vk0hAruW2nXgPyAuXsIJGeKVIWBLgjD8Lwy2QzsthJ1/Pft3seF0yQ72BrSS1Hgb2svBqS2qplx5aDCSx2pnOK08CaJDIKPeWZ59rE8ImBT1Ldsxln9NEgvesWp+jA9m+eCKR+ZF20DzFSC9LYNfjTh0PvZqxap2Yg1VDNZpyrcQO5niq58fXzF7Aa0l5cg5uQITQmu1mrf8Lu7JkCWdm8SQoLuuOdnNvvCObmfuZ/K0Dl23UufTv5jepokWIhR1X772A11pN5AsX36Ptp4r2iZyCcy0og7ZdukAoNtpMnzarGAZmdzXkXy8v8T3DBUcWdCLsu359sqQQ4zWS+up47z3k/ElICKjrPKW0XPCH1QK9CJAAsYrXEe7/XpG86mkzx8J1Q7o6pMquhyvdkWnwJZmpGOe1Oyn7MDtraS+U6OhyYXorz96TChG7t+miExPUnoD4FNUlQfUvPPw0RYbwB6IM2LGYvFcQDJAtKswnFxMOE93czuiUl5V089olKBkLWyzQQD0YfGy2tnCKv/+03H9ZD/OiHHjJJWIi/8Q3NW1hGKGYE/gXnF0pacS0ALF5z+daYcNqw65WsnCvTRwJKiZC2H+tscTGUl4cgwM6/nXNKq4HivCyvjAgtjKxdtKzdYOrCqoXI
 2VuYyzX+
 /QqNN2lusV70uS2jgOmUBXnACT/3mSGr73Fl8XTKQuBiJiNPTsUk6o/ihS7y57pEZtO9SmwfKVX58/1jQVPUAGe/0TFrKXBc0IzpKBDyiQAT4qadV/lzHhOxAMjHiCjoTdWo+rsQV7RFqzMDAKm/ZH8eQLUXyl0SsFf+C4DmUoDuprhQrIoO9BjhI+TpVRg9IGsmmEIj/To+4a+GFmKiQM8+oTvBZw62FMAAzWuVu9MOTU0+lzhKgh1wOtirdMBTCps+dYFAaGDZ9jeLpMb/BD8HRi4DxCZDg6a1Px62jJyhEo3RrGVIqSsNaBlzYAMO1jicknfr9xcDcpKiqz0Wi18kztxz8TzUSC9Re1SpXZVw+gT/wClqEa5o4cX8T4/m6cDxq/tuFeUeRVjdXEQRN86x8nvPcVND1MU87DsVYzY6mwAcyuq22kT+gEPseQftTQUnVqMjCGTi27NLgHMLUMGpLeYNQtRyrAjPK3Zztp5a6+367RffH0YNSOH9TTw87JbNT9mqCLoigRc82C0TRHP8zljcX8GnZgs8+Z5QCB+GBxL/fMAowRbFiihJm6S3iE0D6AMh7Cnid7vQ1QyV1zIditkOs1flHS4aUZa4FbsfOMdVKfzZXvU5eVr8JQ9MocMcSyyEEU6h/yhO1sa2nayLOybyVNiEPs+T/n/KB6me5fA7tBH07qOVRoG8kwbqVVipcTAa9mmgFWwjbKPTbqVMdCYbF8FjxiswaeSxhAcwKjZ2bPn/1DqIcMQQhqscPlbSIj0WzuO6Zp4wwht5Nl+kaHi31CKsxnHTpI5ZJHd3dVMOH81pBJmK+AIMlJ7yO9BJ6oLP5BgTr8zR1G79FIhyFgSnUoBrVeihEX8hEwFPd7ZqGuHAI5M8ozL+zkzYD/rt88Ogmh9cG4YMhJlIo41W9TavowuKTJ+IzLLDuhrcGUBETPZn/5UEjHcgSD+OPr+8CKQRvWK8soD5RKDeShlfSvjAE
 bdnP50h+
 /OBbb4HFlrMqxo/0x/W06vk6coc5+bnYrtP/+gsD85mmjEDYaGbMBRxD96KILNdT+DhR5uOiMb1By+y8kbhCPiHzdraqPWce0Rd8ywY9G1HP3eUpzheSSNLhQzH3K45DY8atcqJIOnEj1kWYh3GlXUdJG20xxKG/yd9VxeIXecHzQUPG3TQBRuPYXZg/jm+zuxtKT6uvyjHSnVgxvCHvGeeLanvngj1aFLA7pNv/lwjIVqnrelXsHju5Y9KeWzg8yx7MlviZRukpg+bOUCGJFSO2fI/u+zv+KgBakOqaFIYDYuliGKYZwRMAjUqWmoM51ZS06NgSmGDEPA0buA35AqshtdX5afcoNMi2x9qS9PlIytbopCqlPu5lxifw/eBV56mPgDDYDoZM28+G/D8TXszR9puvrCeBZjZkAr2StGQ163n5FrJg/gu+ZeR9F/udO+BOLmvLGx2WwxkFsARuRcDySM8GjM6SHonIXGGL3qGvyXHhVNxGhRHKJCizuldDI9CXbSbgF6Ju208p2AKqLFQ7EldusMIp9Ec7MR/2oLLUQO4ZoSo7OpVQ1fLcN71aoHBLSnoyND2NakL9I2EN7rUKVFk9+Jsq+It0yOST+a6VpU4QpQzPLqpAqdnAg85gtmZSQkK4pK3uW6WS9pEbVrDzBb8X/Xc5GOdkXvXb6RZ88zDIK+Q9O8+rAqaYOqXYcYnNzXPqR+3KxCvyjyXmlwgtxTuMCJtpmoITPy2fbCqQ34Ujl2lgSSBQeOp/KYgkhUkjuJMmuA5RZ7mXuM+wExhzTxYweEtVbyJoKCGOviHRF+BaVP1AyU32TS7urerLuFPEGH5u5eiHJXGIquYMgHIoPZ6yOU12l2Pz771KIgO/dKdfP0/R3SW4tAhvv0PGwMqH2BQlkHohFIVP+IUpZs0qzSq11weqmK8UEr8qNRi9B9o3+5SQtM6O4u9iTPVU/dwv9znZx48oAmJjhKI29w856OBwj
 nau7k2Fe
 Uc9vdFejE0g5iC1PP6ushiOE8WrzgyhFN+VBwvFzPiH5KGq2tINq8OklbuxSpfLKkW3JmrnH8OCtJ6iNJqj+bL8dp/93JikAtJI2KQfGVTBi15uqUIuufFh4tDX7PjCXf7q7PRkBLr0bgTg7EHn5wcXVsk2txzNP9q4cyS3t9uNPa30I4z7eZg20sMStuaLtpIadLN1S0ina87dr7LoZmbxbFKbC4ffTkfZkUuMbk1i1pV1qU7RZLq6tVF9RYGxwU/RLfyVSlkYkoTDfXOaNOYOOJ9RKCXHpG8wU4k03OOgynWno3SpOoIt+uTWZOrAmbt9TD9/50UQ7lNSmTad287HdKZci1ihOd/IFUxuUwnYz+FKm5SuTvWuWxq2DyDmWapuzOx8/gLGPSn02CyEOhPaAX5Sre7qC2vw3Pww2mwNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert isofs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/isofs/compress.c | 2 +-
 fs/isofs/dir.c      | 2 +-
 fs/isofs/inode.c    | 6 +++---
 fs/isofs/namei.c    | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index 50b4cb3aea87c7fc46b8b5483162bce84573b483..dc6c7d247cf880720be47cd26d23206d25a4e453 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -156,7 +156,7 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
 				else {
 					printk(KERN_DEBUG
 					       "zisofs: zisofs_inflate returned"
-					       " %d, inode = %lu,"
+					       " %d, inode = %" PRIino "u,"
 					       " page idx = %d, bh idx = %d,"
 					       " avail_in = %ld,"
 					       " avail_out = %ld\n",
diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index 2ca16c3fe5ef3427e5bbd0631eb8323ef3c58bf1..0a8f9e411c23425a6919b7a4fa3fb387eb2c3209 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -152,7 +152,7 @@ static int do_isofs_readdir(struct inode *inode, struct file *file,
 		    de_len < de->name_len[0] +
 					sizeof(struct iso_directory_record)) {
 			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
-			       " in block %lu of inode %lu\n", block,
+			       " in block %lu of inode %" PRIino "u\n", block,
 			       inode->i_ino);
 			brelse(bh);
 			return -EIO;
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 5c01536c5e8fecb73a95d801cdd3b8ee22011a3c..678d7363e157d893e005152e64e922d9170468d0 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1261,7 +1261,7 @@ static int isofs_read_level3_size(struct inode *inode)
 
 out_toomany:
 	printk(KERN_INFO "%s: More than 100 file sections ?!?, aborting...\n"
-		"isofs_read_level3_size: inode=%lu\n",
+		"isofs_read_level3_size: inode=%" PRIino "u\n",
 		__func__, inode->i_ino);
 	goto out;
 }
@@ -1380,7 +1380,7 @@ static int isofs_read_inode(struct inode *inode, int relocated)
 	/* I have no idea what file_unit_size is used for, so
 	   we will flag it for now */
 	if (de->file_unit_size[0] != 0) {
-		printk(KERN_DEBUG "ISOFS: File unit size != 0 for ISO file (%ld).\n",
+		printk(KERN_DEBUG "ISOFS: File unit size != 0 for ISO file (%" PRIino "u).\n",
 			inode->i_ino);
 	}
 
@@ -1450,7 +1450,7 @@ static int isofs_read_inode(struct inode *inode, int relocated)
 		/* XXX - parse_rock_ridge_inode() had already set i_rdev. */
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 	} else {
-		printk(KERN_DEBUG "ISOFS: Invalid file type 0%04o for inode %lu.\n",
+		printk(KERN_DEBUG "ISOFS: Invalid file type 0%04o for inode %" PRIino "u.\n",
 			inode->i_mode, inode->i_ino);
 		ret = -EIO;
 		goto fail;
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index 58f80e1b3ac0d5082c24b5dbfd064cf5bff7d5a5..494d2ae4c0955123335a97f23672b959dcc9e0bd 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -100,7 +100,7 @@ isofs_find_entry(struct inode *dir, struct dentry *dentry,
 		/* Basic sanity check, whether name doesn't exceed dir entry */
 		if (de_len < dlen + sizeof(struct iso_directory_record)) {
 			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
-			       " in block %lu of inode %lu\n", block,
+			       " in block %lu of inode %" PRIino "u\n", block,
 			       dir->i_ino);
 			brelse(bh);
 			return 0;

-- 
2.53.0


