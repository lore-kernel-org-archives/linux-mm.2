Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AE3CEB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85DCA6B00B4; Mon,  2 Mar 2026 15:32:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824D46B00C5; Mon,  2 Mar 2026 15:32:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2ED6B00C8; Mon,  2 Mar 2026 15:32:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE396B00B4
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:32:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A1CD16033C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:32:15 +0000 (UTC)
X-FDA: 84502270230.25.D967C10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5BDC7180007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:32:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cvJD0maX;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gUhNxcPnK3c2jCrhaYvPQWAIRRqycFK/Jto/eJJJUQQ=;
	b=FYQMu6t9OriStk0H0qbyipjbMkxBvNSef/UD/MIDmp1ynNKZu0fos9cxapytEVQzYpZ+wh
	2MxdYMGGhpG2/jMXto4/OJ1RgdUYzcHntvnoo2/oaO01+0iM2P0tLKn++S8k+rWkyes4nI
	mxxVLFB0F1eMP3CzgvPCEX37jlClRWU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483533; a=rsa-sha256;
	cv=none;
	b=HtTd0ruqkYot8HYENC71DrDQUVHUffch0MvJLYfnpP7R1nJxAmP0t7WQzMMYJk85W3ZF94
	Lvnsq5res7Y6tEeD90s5sZkFIvK0fVDba9AGBYEDhAwNDpU0Y49atBTUfYWpo0oQzxgfd0
	R9V7AY8L2/lVQj8DQoFyMX5OiKLu2KQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cvJD0maX;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9981461336;
	Mon,  2 Mar 2026 20:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D85C2BC87;
	Mon,  2 Mar 2026 20:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483532;
	bh=Yn2Qu7UMbJThtBrilI7pPp75jpWmCP33tSnnkZRaNHI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cvJD0maXNCq/O2xWYA+10/z/E8YRFJML0cT1B7vETcvH7heKfTKxs7p0sibB9di3C
	 xmlXCoIm0SbP8G0jP6YbPVrS08BL1CKixwPXXAHSwrbjS/ap9RtAD2VbsMv+6DS1Z+
	 bYFRaNFCNzJyKTwYvKvWvkDXLLlz6UDKUv4QdWjuBjWr2s8DeLpw4BzecJndVkUDTc
	 JvNMHFwSqjHsLvb+zIYSgWv98lgKNu5JyaFPqeiyRcJSPD+6PeEPcA4HTxiN01b/WA
	 uJsVT+8FSNriX6qmTtPlrORgIvHgNAff+hjUKshE6/oY62XlnyoDIEObjmzvFgOxFs
	 1KO0+PpVUVnaQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:14 -0500
Subject: [PATCH v2 030/110] freevxfs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-30-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1132; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Yn2Qu7UMbJThtBrilI7pPp75jpWmCP33tSnnkZRaNHI=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH2F6E1WlwdQlGn42tvtpN56rew8QauNYZQs
 uWunqtOWmiJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9gAKCRAADmhBGVaC
 FYwCD/9NZonA3wb3PFwtQxjXkl3/WD8EX6eYeInYrgJ+QQAL3s5tSoYqrHvvuIMkqJtY2WtxKqx
 CF8LInObvig0s/yGrrCPVa2VoLCG5Z0LvqvpOVu6C70X4D6PTl+bZk2/ntELohSSwHjidIKND9G
 O+oGpBZ8AiRa+lnT47HdvUbfICl/UEOL7sWQpgKMOJu20kdNSTp88wCNqlEudsDwgmkDnhGhVhz
 W7en3NFkygdhFH/wKB1zoCC8TjZysN4zbXYomqgVIYiXDwlzQbNo2jlNP1N940xUEv/3hFfG8qf
 Vw0dHduyiZTtOM5UffLrRmXGRc+1KOzZ/BvlTWZoRoVLTOYPUNVklRgufo+O+VlM4OwZ6LV92om
 yk4fZFCjGarfqb4xOPpE4ch44M7YSeH9r6R9R6rBQdDz47vVglWbtQQEZYACQXI/5rj+POP+fgA
 27EgS+Iw1Jy7RaDluifkQV8PMrxIUlZP0tqbLdBeHv4QrY6gUv9TOHrmXIFGAnfGb7nvXYaLAIG
 I3eTOBuvNA4I61CPlwUonTwuAom5g/7CgzIAezX/YGgTjF/d/vxADqcCDboGMg9hX/ZLS7gcTmw
 pRMcZQMdu9Cjzbc7d/2GgYJhPsRGWSxkZ011EBbkX7wxbrRKf3i6YdwSF8cFWU5jNvT4fKKy32K
 y8aKLyjuQhVAEUQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: b94dzmjeydztxb5cur7sxrrgbdyoyo47
X-Rspamd-Queue-Id: 5BDC7180007
X-Rspamd-Server: rspam03
X-HE-Tag: 1772483533-35967
X-HE-Meta: U2FsdGVkX1+1hqSaTAFupuXO3jUe7v6eTbx1ayTlLx6jfbM6+IsB1PGZpDzqjx9BAMRkW/beRdcFAt2Zxfawqx4f6e4XosQjAHEM67pgx6I/KQw3Waajp63YEvoE6sKsuPGvRxIRddkCTv4ufl8HqQw1q5PlmeVzqUijQNtEqv/tsOTRxKTmYMUZp9Tj7P6y8IfEebccfbWlOYh/QiEIpaQ6IXaosapNThNoH6dNzhUdyAg1oaKIAoK9nr4ato3028DMu7dOhM6fXBGSsC073SvN9aeLi/6kTQzWSF8LocgbT9fAmIXAIM4lUq6pMWAlIpV8TFuvoG3qt3iujyZS1SrjZTjaGr1MUd48i5D+p1rvo96nr9EY8q3d+UpvIXcs/plZmzTF99w0QEs6KeELJjjNHd1yBv1kRc/Fz30l2wSCdJNxd5HbnwQCWd1Q4FDRIeZ4Cm2VrSLjglWhz7wleq5PgyFacbXaw2bXSTTMp27hud3Cl4DdEvcgYQ8LxY+Ifey+15uyDPVIIlB+itH3Owx9FWSY91gL19V+6gkwBWjbDpT8EdiZnXwWCVmE7HSBf+jJ0uwlJJ+dp8GVLo9fPwm/ehMjRv3IFpqEfgQDNEdAxvyXo+ltRtNFRtJ1g4VSSrN/G9ZLkdFH3u9Vtbo0+6wtUZ0yJPGizuYhYzW9CpzUEEIAkcGVAF9PyAoQXLj2pBBszZbyCjyGeP+9Noje6Wh/XtXOqtQFkNOd3tVCl/6mDM4r5rXOgMxqe0jpHs/Om88Oxtm3ZAJl0i1Nuu+g0ozPQuWxRIQes7DJ2kYuG7ZJVMfSqJO6qGDEXFVX3j47wLBLAScPRcN+Gg2h5yC2/sdhDyjwYt6OdQB5zMhPgurCbnb+9BMinGZVvT68BdSSNUZVqsbX8AvJQClyKonKbESKrp5APHGLZxoiGLtbqWHYYF1CEcS4FJLVGur3pGrt7fgKHz/qsVCgRLEvRL5
 lCA94e5V
 Wqn9RqVRW2NcpZuF2LC4CUOWJNpE4CN3NQQO4iHrZYlAbwrv51KmKtwLJfws9YtDJAQhDdJidB6R1IRn1rskQ+juK9rZqxODsH8meWWJSZtCgR8U5p7hoswJPjJcHkelbkHX6ge5ReVRt1/7oXrT4SwdTlNL3sbJ1WPllH9d/nczEG4DZzWyyofcSk1ZQqcaAo2BAGhsl/zJyVbzJ7ElgQ/MkeRbypD9qvckTtqkRhWQObOBKqE0eW42CXgTxzpXTp/Vd28K2Uix5Lm7sn0X7JEBarAzK5TCDswIQPiAUlsxv0FLzHQv7o1eRrj7ROFeHbLYcjZroJd5ysXX48fOvvQs3OflS4wSP0cp2Cd7WbLeYRmsBFCid0EhfQn4YqEhJfWNYb/d5TEQFHmfCzpf0WBbY3D2HRQSsUUL4h5kEuH2n4xRL/E64O1NoqovH48+ZvvzE8F9Yo7qo/DUEOFaoYlpVlrgch8Cnq4TucOUxtj34WB9dRuauqXZ0RIUaK+Eie8fEIx2AbUVFLEYbV5ob44WFcUr6wgOAqyMFZkAoj2eRhJ/PL8wuo8oMnCSEMF+cIr4BEBYiFK+Txsp8AiHmryG+eeKSEpBfh5NgE7TYgVu+JgIdfH9MgwL2npXeqNpgYlTUUE83jiz/jbGqiM067NuadQja/LnsLa12DkN60no5dxQCJtU2DEJlEHGF36R7tS1sbq5WwgE8mvWKceiuUKI+C0WA5Vz2d1fDG6fiavF+zLvfrzNgAqV11OcNQlYVpbpJoy+mTC7WPvbVqBH7LPYW4nFqT7uQtT3XmMdYGee4g0529ItOtZlcwo41IeUir0bKLJyUKUSKDOyzVyXddiEH4UrTubYhLjlrhT8MQpF/pHn9zML0muU876C230tmeJy4yFmIErEGszF1H+50kj62lqYT8U+IH65i1oFo/OWWBJl6QfCbXeXf4JPQ9l49SU24w89Ejwiipg778IDuHgXv3gDe
 41TFz/nP
 0+Yu64ph/SQzDp2CqIPOD7TSkNScgU8rEh5wnjggsKUjZAU9oTyBcQoRVgjEJYS0dbhCFFkLfQw1DzRRO90zXSlqASq3xgBfY0rJj0hmyIMVXz2cv4Ck1secpYzoqnHwBJs1V0+qab1ePUgNwukey+FEdKmU9KMktTViJ3DV1jGMj0+XT8XCXjEMAc6fJfGjX9OgsjXNUruy0rnotOvfeG3g/GQC3Yav24EwFHfbtzhyCzz4rIWPC5BBSMESTBct6utNK/sjKPtKYC+D2d5wLCB+3wZOmWkZtuuP2ZoHCoCBJVHhfMANHUvFQ1JXe9sNNaRPOTCLOhm34BogPbI6We+Awn3KovUzbzbt+vARYsLUgkEtwsZYThmC6emVuUeyqdXU9wZTZGSSDQBeTEp5oG62iPTQL1UYxHU/VQpyq8VxHIuStIJfxVuDv5tglZe6TOEsHfS1aQFSocEmmhqXF8ji4alu5Mpxv8cSoUqICHvdrdhpsSQRWeUASPrzSXaXKEWBAfVomgMoF+BqgqNPRsrjeY4p8OBrb61d5uio/VDwVQoKQCJYN0vI08domaKPkSBw4ACJHuj9sGXmZeANgz7zCcFdByVknwxtSoazFjW+oQJ8J3dmDuR4YDrzjNY6NeFOzdHXnsle2EDeMF/eDWBN7FLFLs12MXbl/kL9ixE5JO9vEEJzNlUzmaY3aT39thYtWq5CChmybEXs6wLNoNKDAN7DQZlOD5Ek4KbHoC9AMDcaScjS4uHQYGStZqrosDBG05kPpg49F5opxupbLii5NkjxbVXIrTl+ftK447nUZ1y2vclmybAuhYXoRVuYZjofvfTbljUEJ9mXPDPxW7m/S1kiiN2If3U5OdqQnx/0rV9mAAL29t4ZjVMQYGQqvKsQgu7P4NbvRgppiqvC9g5qEYJSl0UVdCX9khrxtlg5U66trBw7ZU48izyUAEmBJC2abitnA5Vic4YIWtiqN0J+9FnuG
 cLcxyIiC
 HKIuVuCQJYX0vPVbHsUha3mcO34SumAIcFISu5MEFFfBLX0vTRTJXWeLYs2tIYXjWpbSufKHXPnsjHyNyHL6PoO6Co5Lhw6DRdYO9xGh4E+qtKR/Fy5OsRPi1AhP87G9k2O4NAya73HJZMRKDgz/bFucinMnstz3LwvsJlk+q6/VJ5uYM9dQj997qIuo0XQrcQPj9Y9bUn2rBFX5t/sAEuZycF5YzCyuRoVnm80mrdH6a7bc5xVzZfrc5tjEqxhye5Ee+FS8DI4rDIt60h5/R/Ha9KEoKcCNll60sPj+ZxbL1Y1s1jhZgCCGvdUybNr7oYkZ9yslTPlor77MFFOQnP4ZBMfaJxLuJFbg4U4Y39xvM8Rbh3IENWhbRC91tOd+Xz5vIAk2Vl1J9dShwQXH21cnAZmuKrdUTvDTSvRyTypDET9YrD68Dk4hQgRWauIg4OV8XY1RIyZ21nRliGS3sCJiiu385g80CtSB0tiXg1B4jPOjELyFpn/1+uetZz+AR89LKRfCP1UU26j7247O/m4e4qzngreotpoxl5IGcuAFF0Ebqico2J5ViU3FfK5ich2MnpHhmGQdWcE+Nh7sQaL0DHmFi+TelmRwoHMqyMLSL1qP42DiQ3PQVR+jjv+kDOtuCS6rwqjuv1bQ/KhwTiRjz0++7q5o2cdECzEzE3VIf18SMm9iQuOc21887+8RHP9S4GKrdPCT7tnFxAw6HdOzPJ/nztvWVzMowcwRFtTiTGKdGKcxyreEcIt1ZazXEUhrEJL1a6UaflYIZHH28i0i9e5g2IUESgTmkiQ0v5XjfrW75G/WrsigMJMc2KFzzD+n8+1wsVn3X4BMPBGV5nzMZKA9xiZa93Bbc3MsaIFgdLbM8mcosTWilUIwVgz0WjZDUD6a2zKBq1c/AQn8ARMSkpaZjtOgStzjh+rt/lRZc79T0k7z+PwAEAzAPwJcnp1ccBszxTuYoZU/hicM/Mirpfjsu
 TtzIAReS
 71x2xelwmg7Nay2KnTTem+7ta6uDaFkrF/gpniSnIvbaMXKMuLowO0egFqkhyG9DJZDgI+I6RuFDjuAFeB5v2zd3ZlS/74QIjAHFnvaXpFL61yk1oPl5QXDZl2GNI0yu3wRRatE11a2XCPx7yaG9hQqU6umYPPlYx5X/hL7bzZhwh4cVh5aacXUIJNO9tErA6JY4nw97fxs3Ga+LI/z9YafA28YVR/nqL/Ep5lCQ1j4XIBpebOPfm64IwxhhQb0bv4LV+lu1TsK4+VLMBJGUnWtZWG5N7wsiJ2ILFp2WB4ojzl52r2e1p/10dcAPo5LxE7deowtWU70yi31bBAODrOeazSx4SbzwdWRfugv4I4NuyuSKRsovnG7c9MPAcDArr9qShfPBK5VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert freevxfs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/freevxfs/vxfs_bmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/freevxfs/vxfs_bmap.c b/fs/freevxfs/vxfs_bmap.c
index 26d367e3668da0cfd916881c7a07c047a7ef1bf5..93570fc8eee1e0889d13e3e6e351fdda91d9094a 100644
--- a/fs/freevxfs/vxfs_bmap.c
+++ b/fs/freevxfs/vxfs_bmap.c
@@ -260,12 +260,12 @@ vxfs_bmap1(struct inode *ip, long iblock)
 	if (VXFS_ISIMMED(vip))
 		goto unsupp;
 
-	printk(KERN_WARNING "vxfs: inode %ld has no valid orgtype (%x)\n",
+	printk(KERN_WARNING "vxfs: inode %" PRIino "u has no valid orgtype (%x)\n",
 			ip->i_ino, vip->vii_orgtype);
 	BUG();
 
 unsupp:
-	printk(KERN_WARNING "vxfs: inode %ld has an unsupported orgtype (%x)\n",
+	printk(KERN_WARNING "vxfs: inode %" PRIino "u has an unsupported orgtype (%x)\n",
 			ip->i_ino, vip->vii_orgtype);
 	return 0;
 }

-- 
2.53.0


