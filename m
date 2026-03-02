Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C88EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66CDB6B00DB; Mon,  2 Mar 2026 15:34:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617956B00DD; Mon,  2 Mar 2026 15:34:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9A16B00DE; Mon,  2 Mar 2026 15:34:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39A726B00DB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:34:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5E101394B7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:34:38 +0000 (UTC)
X-FDA: 84502276236.05.1D3AB9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 171A91C0004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:34:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dugwQL0r;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WC/JVj47n9Do4ZUNTUGN6fO4mNJ4yLjLEq8KymwgfEI=;
	b=jggf90csswtsRR38YkRITvzZybyBdaszh1hNF1IhdFwrpkybzTZs/Q0SS8LhOzvejxLfnG
	kgr//0+hNZF5z0dkzx1+NcNfjoPyVw6UOwIqjtFo9111NCzUuQABZTPu6nMdunVCUFi8pA
	p415dBqPXbZBqjexQhqR+QKtLGxNmcA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dugwQL0r;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483677; a=rsa-sha256;
	cv=none;
	b=zMC8LzYATn1+ouFwtovj0jD89x7HuAarfBaHelxDRCowrL0S5fLVc7glDeWxSRtyxQqQNQ
	sqGgdUXF/zaEdXkAVkd2WFWYF7pyuW0OlLBAJ0CHYgLpecIe83G57ZEORYQKEYQrmE2YJa
	CZMUsyQcNvfReBfqGw/VdaaQ0pDGj8U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2868C43E15;
	Mon,  2 Mar 2026 20:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9153C2BCB3;
	Mon,  2 Mar 2026 20:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483676;
	bh=zDOfQu3cch1u1Ngb97bS3zzdl0dgOjMk0bBEwc1nc/8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dugwQL0rTQlo0eqDRzSj4bYCAaBkPTXwufIqepq8L90QxEZs131C8UyeZwQkXNV5w
	 Lsk4QdjxCSTp8kwzxRwVjy2QkvT4nom7g3raD5B/rkXq2DpuY/wMATjLDt9fRLqVTc
	 UtpvEt96O1ADdKNw2IppMzkDUg/eisPOIVPYCYsPxy7r0hrIIQyytgyk1BZDLCz5Pe
	 g/JLxWm1VRV7z/75H9nFzdMmu50H0lDEU8fuF3/3lIJOSXOB4X+zZVv3mXp/sNRpJi
	 NvajzXzASpyuyjaCxWYTXFpgLHERczrlNtRBRyrDg1mcKFrZprGTcncFL49eXanKVQ
	 qF/pw/twmcmoA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:24 -0500
Subject: [PATCH v2 040/110] ocfs2: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-40-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12707; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=zDOfQu3cch1u1Ngb97bS3zzdl0dgOjMk0bBEwc1nc/8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH5TH81MLXzhYX9ei+5zmHkw2gJXRYBhwKEr
 Jw8vSwrFu6JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx+QAKCRAADmhBGVaC
 FWlGD/9G0B+TKkI8uy3/96mmUDo5WHDJCLonyJTn0kWyjP9i0eBajXAHt1oQL6Lw129hT0PB6xk
 4mdougx7mf/BE6XmUcqAx+uzskgptUnDaYSdftObugoUd+kw6PGxHR8HUdRXN8Fa6MVw85JgFZ7
 9ZOL9MqZhJcGXjUn/11WT/w2cLSpf31tBHS+zRaNdNlRjYwdu/qG4Eywt66YnnFasE2NU8EXFuI
 hGY+DT21F3nA99M1IUicDc9WS7tPFk2HFtDlviD6+AQWJnOCbr5x7vAxoxCdJPMUvHNHIChjGMN
 0zfQrLVLz/eBQvCIOoaH1f8ob9UQakCQXZ0hTd1Wz9iDByUkzxz6RnSc7lLhr5d1fgnEvVjRVYq
 2wLlq+YN4Fqhad3LrKtFIODaGIvpvzg13GB6wKejwN4G3gj7hewX4vcwspbWO88vQujvwl8jpHm
 D2n4fsox9PfGt09vUTu5++IhlvfkM8jBlh1Y9tS+QN2gC4WWLnoMwut/ONLYDLjDZzCQmIAj1MH
 fj8wQbQQWXZqLXLEQoxRzjuoSWcVGZVCAN1FC9o1xTlUbcdgpWHjPoFc4lYw5VDlclxQ5rEvatn
 aeKm7ipPYT/7vBaPyMs9AVwWrP24kooYoy2NWKb7x0YC0ccAwKc7xOnPq6XbBrfCYv43dOcA6Fx
 R1s8v/5yER4ThmQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 171A91C0004
X-Stat-Signature: rtf68ydrwmmee4mq7xhquryeycr5w8ar
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772483676-695783
X-HE-Meta: U2FsdGVkX19FHYDElvsd9zd3uPHUBqSwUIeT+Arx7yxmQhZkzicEP6NQVoVK7RsUSfnVQV1H/Gtpz/w9xaRpr6ttBzin9omq/0RGxp0QCR+L8cAN+fMo2WB4JzM+ES5HoAFM3HmIVYVi+n57eRJUwbr0boCGoPO8JC27Qg2jGqhZI7BTHYwXhiw7IovNxA0QBB/a8JRQjFAv+cjA6l92bFm6o8x3OWY/5Tr0Fyo3hrytFO6S+d6Dbj98G6040SsvzUufouezOacsmC5J8Vo+NAZcAjeSV0kebWQxwavZGC+hgVuceGVxlt+i9e5+BOxF+IZ2OLOauV6EfxGUFZgEPx7A5rjEB911NSYayrB1humCxkbUaoKB5CXgaaR7HdRPVGLPWjLlKR9F29Wov/aE6qrP7k/jXkJSHm908CpSDlkAnO0dDw323AmVbOpz4UeF93m1GeHEZ2j5kwsDSDFYv8uwfGOWC7f4B4aLKV2+xCwMN6OUOVDDlkbkbyBRE9E/kj9oGBA/VgtA+wCOTIupD4vrSDS6wk+gROuojJOHR+SJIpZQU08+wclJylJgXNlx/0HY52ABhqE/nwq7zBOOv8fV4WcsQ9HP2RseGhLpfVkYprxLzUHry0CoMSw9dpHlZ4C195o+O2Len3bzuoS80pboBHae8IOL98OkfstCx0tkdoElcJTxIXzIMgyHUAz2XRL7I/J6RLQUvzblNSztrfGoMhsYaKYfa3iwV66BaEumFFGzy04PD8Eg3FvPp1QwVzLOiVpwG52gGob4EoZAmiqdXeTd0n65+OdZjpHMc3vzAW2bm7vzl2wb4+l9nudMxENXvKg/32n2rA7+qn2ICGUWqAHjfqOCyGbxDlGn+y1rNSdeyP1ozKcdU7Ewxu9Aq/12VbaGb9HFjBEL2ik0SiFNFl1KZsoxhv8zSTfJW1DomrWyVqGRc72g/tChphIfTMnvctT8pTCEoIEc7A9
 Jc6xxJoB
 lKR8XSQ5ZHmIX6Rr3EJCsiAatKzrLjfEYdiEvV0hcjP27fOC4TTh12Zoi7t/E2+BAilFsQQxJv688Zk+EioytxBaZCD9Lvhe/ppn1j2bBdj7LRdOT11XDu5yDvzqCmE4YivFHzwYfy2IVJen5FnEy7sNUVVCtWaeoMTgvfj+FAuYXGggZVV8aMRI441YANChtA6ym5g4iSrEhNJQitibkQzxXR2JZdkV2JyddmLCmasAG/CjEaB4SIuUuSpTf/6quIjQe6tGNpIgYn/m2Ip6yY1qWJwEUqpa2yC14TbG1A4HoF789Qp1ZV58u6kSYT/4AalvIY6KodieHrRZsaz76un5hULLHOpm4qBWLOiBaoHdzX/uZUDWmp6J6tfUejTWnXsTur6kjTkYUADYkOp6GtMiNBfrCNOhxsyHXiTuC79WFX/S7mSCGSWnlyATbvaRrnfeLv94H4Qm93BzShnqtR5XHh/JSxi7Jr8ic4BuxHoirqda+lVRwQxu+iwfDGb0DHTkxj9apLN4R2w/89NhMuKCjfvYpngi5V3hu0pK6G6edHXURUW7ONbtBtvgvZ11K/CD0j26wx/bA5i8py/7UWkyQwpFkW2qf2hT3Sf1rWcGCXuVeysXQnyZ+lcNSzZ3z/o7pOw6lhwRpXAf3BRrio0zNSsOUP1kTcMgW8p8ZxTyx7SKZiJ8+OyMxITgRu+MdRIkb86IONuVZnMGmiY97UsLnVTyaGA3YEFtDvkGcNQmaeYZ7XPkPxVaPeTNJIAq6U9lSYv4oditxiebKftildt9SRnlsYcuG8ODqQP7oaosWb13z0qNVsZP5e6PdP1aKrDSOo56QmraRPQ+8WrVzWPhHjdnwKiz8XytW9owh4XtoMYTG0ZqCiZKu9C8mtwWyXN+LRu4iQqP24ThkSUjKC1VYutqeTBWfFbis14nCLEeqRg5RuponmV5vDZ+RXnZfcb1WU0qyoGMQqtNcUAmXEtC0rTal
 3/l1aGiy
 IDrYMzm8H7FE2AgCSkhJP9xmSqEIg7qhYlw5CazLH0KQVt4DVUUCTMvqcvpyVeS/4nSu38rIr9RlFed3wnz1Wcz94DQOhMomDVs7VzmRorfTGMlgRFK4Wtakwam5L8Q2zSO6Bc8fFFyXGHZbwFp6drX1QSh8D3ICnoYQTMcAQNJ0qQTWXYh1IgSGKb6iS70oQsL+kfO6/Pn1ThXXZBWNtR4IWxJEklMIfFPKs6Nv/ST7tUR6ahC84ewhlo9ghsMU+08sISnxJWk/pXUj8eixUv0pLN1U4jkRWSH7OihcCbV+8Sya7A5zhnb6Hvy8Bkp6sUwHQtkjKeO0QotXlIEKOPrkhvtrbhdDoeZjA+XHqQ3upacqIr48136BRw1BNKpXOndULcp9ARIcLySYQxbcWVX7Ynpp2ukQe9EGQB6G9i27Q6ZDOgC7eYx+v4rGD92KW8gitpNWN2jcc5Y3BzzBkKrdp/+BRhQsFk0qnxlUByRFcd8JKY8wy+eIM0oWDYxXaGLVx2OFf6cYqSpI7OeN3DtdGk2E4Zh4jSkIgYKf9D9JWZdSS5iOK3U+c6AtRCIjqxQDLP+kF3JlfYaPEWH8Ucf92dxQx9WjK/ASzhftKTWGSbBMjoHUuBLzfpg1OSqt1xq/lcce0jdKr23RE8TxduKE5d1Kslg2W3pvz38PKPYEPOA6kpZ3eYK0RmxbGwqdScoF7yLL3H9n3iW38Dy+MO2zfxgImpT69dg3P1ox7ahS/+hwNjY/BFhrfNKB0HU/tmznXiwQ2QPdvOXJRbERoWLPk4URoogC+h8qprjLBj6WjZy/jifDwK3Z5+DgKGjxAffgNU6jWV+Szzf4N/ETmXrM/qgS+fwBuTvvJw+tBuSrLvnyjCZOUU+pKoh5Z8Hl1xIhmzgA21dIxaw21nL7neglOfAxa7GTYN2yiQ3oPg/IfWLE6BLNIpllXG9S1NlM0+Ubo3TXTjPziSiz3eOS+xypnyLDy
 l+RNmJax
 ObJdM17KbXTGErn/MueQeqcyxEaBDnMdJqgG+zTEpgDR/REUMYr1pnpQOrHgMNrqjgDy0eEQZRB9+LLj0SKIiGl9Wk/JXFJ6w/GpF4sbs7/axmMnR4KhYHbARF0xShJea2EP++zbupqd39dA5NpdHgdgGtOsD2IAunUAsZkDglEGGgcVcj3Wnun05BrHSJU3BwSwh0WMEUXiwDvSUrAPnQsxYh1ramHSlLcN4sD0vWWMY31DY7FdNXEh1/gRYXEwqO1/rz3/cSeNt5YMcdckQ2bZEnJBOea6IV1KyteOqBLlfPOHrfpMkr3d/SXQRO7AXYP6xyWqqyGY5X1U1oUrXdN+lPUTDGN+wWooAzgrhVnMV7md5AzGn9EJSakmZZ78mfiBg9U4WefYeMVqRbNWITTPLfHEZv190ijq6eEbFtt3kd6doxoPy3eNNzbaGYBNAPrVvb2lWSz8zXvYFxgawbV+ZK7cvN3tl0uLZHSNp3VaQZ5zlebqkxcuyNf5Hfb52SjKuheN2mlJSHBOoYRKt0CgJSt8bldRbp8LVag2svTHeBHQIwF1f+/VPZehIolZimGNLYr9meJzYlr1H5/oV9eP/kf4YPSjZvjHD65skWtEJ9jGfAdXe7g1l6PXq0gLhB0N5DjZPtHn/UXsyrew1XtZOMDWTOKR9m1eqQhjyzzGRJVO/cHt51NelEUqtXD/PNgHPX2tb9plZy2tdIN8E2sNEb1RaU3KF2HdJcg5Q/Vb/kjlGHkO4pwMARx7uorTMWuTHuihEiRL7WWrQZoV4Bb9QNHjobGy7LfMInDXSen++td23Qy+X1IjdGGiesZz2rEb/S9cVkegIGNBfNA0Wfa0M9pqubim1beOWRSeDYVSI4pZbgmhP6NaImdBtjfd4AYIPldq3eAXAdc+W7pcMfyMRxAKxr3vrvx9YUaqoOsHfrVU71nfmgrd6iajRZuAUY5+Xsc4n/Q/31wTIHfO9xSyfTVuZ
 orMb+Int
 /U9bZ8V4kU6NVnm9mN5tbfwu3oU+WhZlVGg8FP8zcXh6dJ006ROzA3RG2giVgyuEkuBt7rjWV4IZHn6UDem2SOToccGheyVCUVZKGXTefdbCRE/h9y52b+6pPFvRxp7fDybVhWr58IE55njivPBJVVc6OBmzeF3UJqznV2Wp09QxA/V4KyoNhP/hZaAZobZfbah/nVV5ueoWagMc9jO7YoC4xETKQGIoJrfKmHsDHP8b7NfgPh/2zPVM432pro6kGQzsG3MwLRTF575GQDy8IdB7lNdfj7hVLflbtXSIxIdDX4w2ucdkntTjeCW+86GhU6ygbq/XuPeoCvgqbHGWRkKFgKsXyFMdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert ocfs2 i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Remove now-unnecessary (unsigned long) casts on i_ino.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ocfs2/alloc.c        |  2 +-
 fs/ocfs2/aops.c         |  4 ++--
 fs/ocfs2/dir.c          |  8 ++++----
 fs/ocfs2/dlmfs/dlmfs.c  | 10 +++++-----
 fs/ocfs2/extent_map.c   | 12 ++++++------
 fs/ocfs2/inode.c        |  2 +-
 fs/ocfs2/quota_local.c  |  2 +-
 fs/ocfs2/refcounttree.c | 10 +++++-----
 fs/ocfs2/xattr.c        |  4 ++--
 9 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 344fd4d95fbc8bd7a749e9d51d31b5682ff030d0..d7703549645b548d9f5d77b2214a9a7c0af0ef6f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7318,7 +7318,7 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 		 * to check it up here before changing the tree.
 		*/
 		if (root_el->l_tree_depth && rec->e_int_clusters == 0) {
-			mlog(ML_ERROR, "Inode %lu has an empty "
+			mlog(ML_ERROR, "Inode %" PRIino "u has an empty "
 				    "extent record, depth %u\n", inode->i_ino,
 				    le16_to_cpu(root_el->l_tree_depth));
 			status = ocfs2_remove_rightmost_empty_extent(osb,
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 17ba79f443ee736cb5225702c57d13f4019f3c52..aea35b1c9fa3ce7327672c1862d0d1201c895c40 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -137,7 +137,7 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
 			      (unsigned long long)iblock, bh_result, create);
 
 	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
-		mlog(ML_NOTICE, "get_block on system inode 0x%p (%lu)\n",
+		mlog(ML_NOTICE, "get_block on system inode 0x%p (%" PRIino "u)\n",
 		     inode, inode->i_ino);
 
 	if (S_ISLNK(inode->i_mode)) {
@@ -2146,7 +2146,7 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 	    ((iblock + ((len - 1) >> i_blkbits)) > endblk))
 		len = (endblk - iblock + 1) << i_blkbits;
 
-	mlog(0, "get block of %lu at %llu:%u req %u\n",
+	mlog(0, "get block of %" PRIino "u at %llu:%u req %u\n",
 			inode->i_ino, pos, len, total_len);
 
 	/*
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 1c8abf2c592caacbe734d49254b04d507925c9d1..eecb2b1d2ec17fb4b3f09abb9e168d2f28f9b420 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -794,7 +794,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 	if (le16_to_cpu(el->l_count) !=
 	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
 		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has invalid extent list length %u\n",
+				  "Inode %" PRIino "u has invalid extent list length %u\n",
 				  inode->i_ino, le16_to_cpu(el->l_count));
 		goto out;
 	}
@@ -812,7 +812,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ret = ocfs2_error(inode->i_sb,
-					  "Inode %lu has non zero tree depth in btree tree block %llu\n",
+					  "Inode %" PRIino "u has non zero tree depth in btree tree block %llu\n",
 					  inode->i_ino,
 					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
@@ -821,7 +821,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 
 	if (le16_to_cpu(el->l_next_free_rec) == 0) {
 		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has empty extent list at depth %u\n",
+				  "Inode %" PRIino "u has empty extent list at depth %u\n",
 				  inode->i_ino,
 				  le16_to_cpu(el->l_tree_depth));
 		goto out;
@@ -839,7 +839,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 
 	if (!found) {
 		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
+				  "Inode %" PRIino "u has bad extent record (%u, %u, 0) in btree\n",
 				  inode->i_ino,
 				  le32_to_cpu(rec->e_cpos),
 				  ocfs2_rec_clusters(el, rec));
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 45cce261da65cab7ef48b5b88c0de5d41fa57615..e96c1c574ff7dc3dffad58ce8536b7e337d3f6fa 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -123,7 +123,7 @@ static int dlmfs_file_open(struct inode *inode,
 	if (S_ISDIR(inode->i_mode))
 		BUG();
 
-	mlog(0, "open called on inode %lu, flags 0x%x\n", inode->i_ino,
+	mlog(0, "open called on inode %" PRIino "u, flags 0x%x\n", inode->i_ino,
 		file->f_flags);
 
 	status = dlmfs_decode_open_flags(file->f_flags, &level, &flags);
@@ -170,7 +170,7 @@ static int dlmfs_file_release(struct inode *inode,
 	if (S_ISDIR(inode->i_mode))
 		BUG();
 
-	mlog(0, "close called on inode %lu\n", inode->i_ino);
+	mlog(0, "close called on inode %" PRIino "u\n", inode->i_ino);
 
 	if (fp) {
 		level = fp->fp_lock_level;
@@ -242,7 +242,7 @@ static ssize_t dlmfs_file_write(struct file *filp,
 	int bytes_left;
 	struct inode *inode = file_inode(filp);
 
-	mlog(0, "inode %lu, count = %zu, *ppos = %llu\n",
+	mlog(0, "inode %" PRIino "u, count = %zu, *ppos = %llu\n",
 		inode->i_ino, count, *ppos);
 
 	if (*ppos >= DLM_LVB_LEN)
@@ -301,7 +301,7 @@ static void dlmfs_evict_inode(struct inode *inode)
 
 	clear_inode(inode);
 
-	mlog(0, "inode %lu\n", inode->i_ino);
+	mlog(0, "inode %" PRIino "u\n", inode->i_ino);
 
 	ip = DLMFS_I(inode);
 	lockres = &ip->ip_lockres;
@@ -490,7 +490,7 @@ static int dlmfs_unlink(struct inode *dir,
 	int status;
 	struct inode *inode = d_inode(dentry);
 
-	mlog(0, "unlink inode %lu\n", inode->i_ino);
+	mlog(0, "unlink inode %" PRIino "u\n", inode->i_ino);
 
 	/* if there are no current holders, or none that are waiting
 	 * to acquire a lock, this basically destroys our lockres. */
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index d68229422dda3423971d7ab0e9a4335acab8b344..3cf93a08f7a8946810ccd2de246be4d07a23b53b 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -291,7 +291,7 @@ static int ocfs2_last_eb_is_empty(struct inode *inode,
 
 	if (el->l_tree_depth) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %lu has non zero tree depth in leaf block %llu\n",
+			    "Inode %" PRIino "u has non zero tree depth in leaf block %llu\n",
 			    inode->i_ino,
 			    (unsigned long long)eb_bh->b_blocknr);
 		ret = -EROFS;
@@ -427,7 +427,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ocfs2_error(inode->i_sb,
-				    "Inode %lu has non zero tree depth in leaf block %llu\n",
+				    "Inode %" PRIino "u has non zero tree depth in leaf block %llu\n",
 				    inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
 			ret = -EROFS;
@@ -437,7 +437,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 
 	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %lu has an invalid extent (next_free_rec %u, count %u)\n",
+			    "Inode %" PRIino "u has an invalid extent (next_free_rec %u, count %u)\n",
 			    inode->i_ino,
 			    le16_to_cpu(el->l_next_free_rec),
 			    le16_to_cpu(el->l_count));
@@ -472,7 +472,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 
 	if (!rec->e_blkno) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %lu has bad extent record (%u, %u, 0)\n",
+			    "Inode %" PRIino "u has bad extent record (%u, %u, 0)\n",
 			    inode->i_ino,
 			    le32_to_cpu(rec->e_cpos),
 			    ocfs2_rec_clusters(el, rec));
@@ -561,7 +561,7 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 
 		if (el->l_tree_depth) {
 			ocfs2_error(inode->i_sb,
-				    "Inode %lu has non zero tree depth in xattr leaf block %llu\n",
+				    "Inode %" PRIino "u has non zero tree depth in xattr leaf block %llu\n",
 				    inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
 			ret = -EROFS;
@@ -580,7 +580,7 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 
 		if (!rec->e_blkno) {
 			ocfs2_error(inode->i_sb,
-				    "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
+				    "Inode %" PRIino "u has bad extent record (%u, %u, 0) in xattr\n",
 				    inode->i_ino,
 				    le32_to_cpu(rec->e_cpos),
 				    ocfs2_rec_clusters(el, rec));
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 03a51662ea8e79f7a64fcd320b974f954b2ea8bf..c3076b450de3599291c386ceeb8b2d26e8680904 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1196,7 +1196,7 @@ static void ocfs2_clear_inode(struct inode *inode)
 				inode->i_nlink);
 
 	mlog_bug_on_msg(osb == NULL,
-			"Inode=%lu\n", inode->i_ino);
+			"Inode=%" PRIino "u\n", inode->i_ino);
 
 	dquot_drop(inode);
 
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index c4e0117d8977807dd6f0f4df64e1ddf72a62ea09..269b0f27d5679aba317059b245ee4bf4f5580eca 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -471,7 +471,7 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 	qsize_t spacechange, inodechange;
 	unsigned int memalloc;
 
-	trace_ocfs2_recover_local_quota_file((unsigned long)lqinode->i_ino, type);
+	trace_ocfs2_recover_local_quota_file(lqinode->i_ino, type);
 
 	list_for_each_entry_safe(rchunk, next, &(rec->r_list[type]), rc_list) {
 		chunk = rchunk->rc_chunk;
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index c1cdececdfa4ef51a1bd3a5addad734b324b92c0..1586c42fdabe70056bf7f103d583dd9000fe9510 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2341,7 +2341,7 @@ static int ocfs2_mark_extent_refcounted(struct inode *inode,
 					   cpos, len, phys);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
-		ret = ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
+		ret = ocfs2_error(inode->i_sb, "Inode %" PRIino "u want to use refcount tree, but the feature bit is not set in the super block\n",
 				  inode->i_ino);
 		goto out;
 	}
@@ -2524,7 +2524,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 	u64 start_cpos = ocfs2_blocks_to_clusters(inode->i_sb, phys_blkno);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
-		ret = ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
+		ret = ocfs2_error(inode->i_sb, "Inode %" PRIino "u want to use refcount tree, but the feature bit is not set in the super block\n",
 				  inode->i_ino);
 		goto out;
 	}
@@ -2650,7 +2650,7 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ret = ocfs2_error(inode->i_sb,
-					  "Inode %lu has non zero tree depth in leaf block %llu\n",
+					  "Inode %" PRIino "u has non zero tree depth in leaf block %llu\n",
 					  inode->i_ino,
 					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
@@ -2662,7 +2662,7 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 		rec = &el->l_recs[i];
 
 		if (ocfs2_is_empty_extent(rec)) {
-			mlog_bug_on_msg(i != 0, "Inode %lu has empty record in "
+			mlog_bug_on_msg(i != 0, "Inode %" PRIino "u has empty record in "
 					"index %d\n", inode->i_ino, i);
 			continue;
 		}
@@ -3325,7 +3325,7 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if (!ocfs2_refcount_tree(osb)) {
-		return ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
+		return ocfs2_error(inode->i_sb, "Inode %" PRIino "u want to use refcount tree, but the feature bit is not set in the super block\n",
 				   inode->i_ino);
 	}
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 42ee5db362d3eb6df886d6721dd7398b8aca8cdb..74cd6dd57abf71a69adef18863d057e48496ccfe 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3741,7 +3741,7 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ret = ocfs2_error(inode->i_sb,
-					  "Inode %lu has non zero tree depth in xattr tree block %llu\n",
+					  "Inode %" PRIino "u has non zero tree depth in xattr tree block %llu\n",
 					  inode->i_ino,
 					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
@@ -3758,7 +3758,7 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
 	}
 
 	if (!e_blkno) {
-		ret = ocfs2_error(inode->i_sb, "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
+		ret = ocfs2_error(inode->i_sb, "Inode %" PRIino "u has bad extent record (%u, %u, 0) in xattr\n",
 				  inode->i_ino,
 				  le32_to_cpu(rec->e_cpos),
 				  ocfs2_rec_clusters(el, rec));

-- 
2.53.0


