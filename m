Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 951D6EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2136B0138; Mon,  2 Mar 2026 15:46:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A196B013A; Mon,  2 Mar 2026 15:46:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62336B013B; Mon,  2 Mar 2026 15:46:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D209D6B0138
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:46:07 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9387F8B3B3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:46:07 +0000 (UTC)
X-FDA: 84502305174.26.CC2A634
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B5A6E40008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:46:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WD9QSZaB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukJlA5hNGeDu8wDq4qMPFOKZ33ejxXPqDyKKGt/DkT4=;
	b=0hhW1vcyk4hgeTDwgWKkysRO/cXPADH1Pbelm/cZIq4iNz5evrd6L0lzgvCLaypnG6gzpn
	c0vZBfPtMgVxe13QcXz8lpltFU6ohRJphk5pV4CYWtd2Q0E5lQrqmOzQalGYDA6fiSnt5O
	qNa6LAeZOjfmMX0Ed4yOJXSJV3wnGn0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484365; a=rsa-sha256;
	cv=none;
	b=eh6ZKl56/fwD2+YTNuOcbafIWhwSnID4JDY5yJrvZI5nZQ+ESnSJ2pEA4/TTEbjBGXciUO
	EkX1AbgbAwHsqNS66g9QzYEzQgh/G1u1AphchCfXogu+rS8d1i26pnQiuIYWXVvGjfkxli
	CQJuRPSPIgVXgcmKPGjF8QDJCIpVxl8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WD9QSZaB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C279E43B9E;
	Mon,  2 Mar 2026 20:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A47FC2BC9E;
	Mon,  2 Mar 2026 20:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484364;
	bh=qBOGZ+H4FCJyoScuTijEcAxm33DX4t54AKihmOD4lfc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WD9QSZaB4Ynf3T2024pRykq9e0/jdmE8EG7gpxceQsWLs9ldUDrFlX4ArZiie0vbL
	 19LbIvHDGkRkdQlFvg2Y7NwamnoN3dr7aJrGPp3z71wIC5mJJ7qSa4bmsCB3TH/SeC
	 hUi3DjOP9V4XSETuRPjeZTuWgMSi9immDKfUAEtwEpfS0taqUCB19NTdwT9PAl2Dr1
	 X6n/FZutnR9+MwmmLPosjsknaR7URHBAA5CT4uRPA0WQdzY1319ktmFMHsHOHDXsX6
	 uClORVRaA5wOmwgDDGWX9W7QBFGsaZ2Twg5ddM1UZAYTdINoixEOU0+4vzdq6qPVwW
	 Ibfy5Y48Gl/bg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:12 -0500
Subject: [PATCH v2 088/110] jffs2: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-88-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4782; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=qBOGZ+H4FCJyoScuTijEcAxm33DX4t54AKihmOD4lfc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIHR7PXwpRijiaDSNoHBRx6sRq6q8UIIYKp7
 0L0gu64QBiJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyBwAKCRAADmhBGVaC
 FdutD/9ObZxe+nOy3nsTFaq7Ut8ArWcplsqSov2kMlKcZpVCHHzCKDenXVX9I9pFuqNSk3FCVmR
 ZtENkgoSqrEgrLbDJ9RYgQz5YLIkClSpE+d+3sRwa1vcidi9xUmF9r1539KnV74bVbjnUn7n39b
 5Yz4oalHYtyM0RxZBk4NYEBKtBfrTqeXOydheHjmorfO4SLpKbS0DJSXG6yKJp+8cYAotA5dyLc
 3wz9mx4uNNIi189tf6M4st3QnK1Rse02wHg82ld1a3TZwDRBfVMBrAtlw7DNUBGBc+nVPRYksak
 VxsyEvoslW6Mw05AybupfOtcxkiI7AacYGnromEJLcZ9ZlsBvV9WkRnM9x/QaFVylYPnp96tPfm
 vie5eyII+IYTlT43Ms7C5qU2fcqdKWkC6fZeKSw3Kh7u/pRdAWPgmiOQdnJIZMUoz4UB6CSQJK8
 a47IYq+UxK3Wc55K1/6Nr/HQ7be+ZGdPny2IRYMf644RLf9W0bUdW+9jBTSSRT7I/77bh4GypLj
 13ZdGuuNKShNp8yE8pV0NP6WB8IbR3yr/yVN3F5UOGRYYRzT5c7/SWeas3JKNG3EhQqXtFQBTC8
 n8AEMtgsyD6/eAVFe8FdKpcragAugbl/JXE/AL/jlB+vFGxVdYQthx9JOUOfU1J2NFyfRZMlbfb
 M6QevW1Grdb83mA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B5A6E40008
X-Stat-Signature: y93wdo97zkicoa6kzcbnojaae73dc1by
X-Rspam-User: 
X-HE-Tag: 1772484365-72866
X-HE-Meta: U2FsdGVkX1+5/9oaE4Vc3C0gKeVh2kcaUx3lx0bikY1Gvcuy8dRNbfcpifWbAjH9SNOjrbs2c9akIrpA1qTvD4tAjIRsXMeL1HH52CebUUinNU78BiQaujBlCa5QaDwgeVt4npOirqx8FmnByqPL45yajZ8j5kZFqZcP3izpw4eeM6eWMK5cHVYDFH1qvghLNf4KaRcs9aiEuPcraGi2UafVpfBfu7Afqn2RuVzx2ef9vvauUnE3GPkbtT0SqLtKQ2pLcYOummLVLTueBkwEuhTPWkUZK96Jmg7ByS0QiYQVP9u83a0+qB7zlcqQQL49lYbeGJVrV0V24rO3WGVMVesvwVtRw0jxXKtNSZROXnlMpARKGlnw4lBEqlWk/7VSTxAKpNmg5j5YFH49RTVCOT4N4oA2MVhQxCFpmSOlcuMYB8K3w6S6TKtReTbKqPzE2Vzjfu6skcIf5s+QG90q7HIoCuUngg0gzcmfDDyY+w9BMQE1QobdDjY2RV1yTKAwfG2ZASxaFNuhG92PVCAq+ppNclEFOk7u4qiDG2UFyBIGpDzBQiPSh260F9jJyc4pzdpDEK9xcYGL4w1yTk8+GeqS2AmyshsceCFpFJK1GiwTu38mVeWojn9ln8CkoVEbQBMC6o+iQ7LvWqKybJyfmItTdeA4P8RpDh6yeZaFCvRs0I+thYufNr8u1qpqztd3C+dy0mIrBZgYhsSMzVfjtVq5eQSDujQEx25ZY58GeqFSCvwYVUcDllaTfjW+o3gTYTBmcXnaJtFk3navdPilvsiHCZPCA5jD3AO5FbGogF4qR509mGYXg5/2h6dJ4A91yJIWaB8iCQ8xaOlVjDyrQDPZ+mDGJ96xdjqcYuG1FZyxUl+CIfbJ7gcnjZsNOUaCXrqiN8mOgn+97JyNvSCSkynIHNVe1tqQNT2MfHOMCdlsfiewyWmPQxFzrx6wwV4/ZGAkKAxbirs8Cf9j6wz
 UugrDgCS
 pswsXNOVAQPAmEgKRJOGI6qXzF1741ol7EzJDPq3E9lkoRylLLLnQHdurTHWHzcrOlqoUKm3aELXArm4kqJOtd8ZSNRNG3V5uQ4iW4lKAw3z/XxYcLC4N9FL3A+SkaSX5NLmsZ94yIAdo0+JBrzGsh0uGimxh6+IgsUKaCCwLMTmIcMtxuU6+Ji4rSlk1D7p6ZSPwksYYzCCmnFHHEB5LK0BADtydPI/2YWTBZ6Aq1UQUghfEEA2rpxU3fiUQ43GuOaTChIMPyDIeu746KZ6KbF37bm0zk7tJQbtuGlwS0+2sLJqidYC15ZFsrMIEM7mgZPPZ4Iwdi919BJSxDae0cIY5koWHvWwQT+fY4vnpJGTA3gEcKzoa8P0tLt/lDHSciWHpD0OC1bpmSfv5rNKi06goPAzUiPbXMXAb2rJ+nMYqwTqr1qn/U2MDf4qdI5unXNB3qWjcuWCgrDesjTYZe7xvtF1eoyD5dEshAel+8+Q3u8cspMhXTpx/f9aHKx9vS6uU/a+nZnUKnHpz3wROdqdCOu3q0MFHeYasBrXIR2HN9a79SD5YPWz0AcCLS/SYHrUTvNfMZWKP+1TrO3igLT7arfVfGv4+CMnHTohYeSCTbvYKd6MuvNr8NXc/J2ZrdtGBcpvoHGiCnaBSSogpWseUzDKsYALeZO3u70U+rgMEYmYqWPL2D9hDACjY3qcsX2D+LNTcFNx4uXKRlaaX6yorzUOHQxEsaeYE59his+6iG9TL37zHclhDjozCDCbpajjrhdreXd1JJ7Q8nrDB3KOj5N6XclJHWOJfNxVDXd7qOytA7xj075mTKjkMU3RVAV1KUakM02UJlnmdEqZ63DEF+Jv8fohGBWgI0bAueGKNRoEeYHyc84z4opKoJBmuZ5lcME0AqCDFY4unLfh6BR9iwrtgB8in1bqYHQcBKrVU7/IBBSUMEmiDdbTeto8hD2M3o5AfAxUtcC/+Wqh778LCYIcf
 t7+8E+iD
 MG5TvPtRKLBtO1iXFyY0D7Gdk8EL8riJcXIBXQpX7WDY2NYGy75YQyHr/W789+vwqAk9pduKiDAdzYK0KshjW9VVaWIdRFkmsKRfr/6w4BfY4aoeG/6z/kUc/nQ/FVz9pgWbcgSB7DMnm+vgh0dycTkq/j2882xWsbN5XyI/jZ890549wF0YeAhDj2WzhFsb4aPgx2c9q97n3RksO5JMuRF+lWhmvYEQrLL7nUU0eAm5WEqTKl5DiVJEhwCva50c0tyqi5j1zn++SnADphZjU37qiRPDWUqSOb2BYsYwmyASKHB8jPxDpflipjp6YCpLLwSkUzFN6ABbJrsuQ8He8qCa87cCzpttfWXxTJouXz3B2ekg17TWKQNAsJ6lm72azNTT9Glg+GHdJy9uuYwm7k1Ts2RqT+wGPcZRaMGGplCMUyN3RzDLTcSS8CNesc/DmvdFXiHHZfwZTEm0oI5UHiM/D/l9ekPNDVNleHT3Tjpk39kKmnhO5lzjmMuGIsDEJr+y5qugUzq75fJvBUjvY7WzZwxmem3OeAGs/8yF7V/XdoG0xN3G3rmhL2r4Fgn3EjamIu6WtSsIqwjnYxf7yHXOtClD/I1ckmFBU+i3MvcomH+hGpnZs4NQeK2o40kfktgFD7y1XoQBOepNSXOYAGrSR8yLIYNNQ3vhTjQQRdBrxfPG00N4b4HnfvTeVLV5Lz1JWehuYvZsqC1XA2bVQZrOqPKOtcOJq/uQ+MwhsLnD+YFW3HmShjm6mTwajnXGUchW6MPZi5FN5/IeKEj9aL+FHm96xhdvuVJekclAIyQ4cckungwSqotKG7vgofoq7VT0HS3qILtLyLDeu/HV/t/DnVzf1Hk+TF7taCnc4cLn9k1v7Lar28SqoLaf0ZUoxZ12KfzdPWVIbw3K3dQfeAmAV6hR2dIZWpD3ZSWUBxV3hPABeAKm+ODq8pwmNm4m2H+bvRi0ImHfgCkejC9mwXv4NXBQ1
 b9yzy6Pn
 1YDAunCifdIYgKniZoKRAcyYkvOF4XRFLQB9z5YRJ75yFXnGUqviWlNxA6q+BJl+wknNXDFUc3xYtxLLtcs5PsoCexf7hGmDSrUb1ScROyUvFmdY+C4j80c3fM//hyGL2qUH5dv3wyksJ9+7mY3N4AlaJpum4bWb67gPnURdmfiOGfVeUn+vZPK6Co7CniDCwQz8VdL/yBv+vGXqyjInhU7QL/rRfL5xe/fQgcmJFVeQUpHeH5HyBic4b06MhmvaXxWM2d90smC4ZmLXIYoSZ6JTgx916GVykbL2wE1cusWlQ8rv6Ypfws69iKbuwaQHKITUV8R6KCPTvXXYs0IMr8Ui1DnA5dGo3BN0o+4nM9cvVrZwxhks3OHkciG5WfAucV02mFkxMx8T+gSAxmTna8Z5DAdjoxYsHNQzzUFWDqc0DxdPPNyHUKzILGp5wecENIf8d5xHfFvHGog7KZU8Qyxhci3IiQtskP9p5CI7owzkEsUgUHzCDJffJ/qj8iIucbBQmvmH9NWk4CDbxDPATowYVKQuVrCfJhixvBa8pDiyiWq3dpahxDaoEkWUQ7TNkPEITVDzhZdFmc+YjohQe/marlXWM/22X7JvS9TUBFhUKue95baQ2FFx2MRwBn22iq4jEUQOpGX+62qg5Yl7rxaL030vPzIbv0jF51YUCyAkr5hiiln07ejK9P4939C+TX3th3uUAnw3YQV3IHJ/eq/t/qfg4mqJLHocy60iKTazJYV5Hl1zRdzlfzPyTkptDfHU4nYk8YEC+W2ByLGwCu/a8yxD8x30XyHk1woDiws81TH/HGRip3TXhRWKWlR84CFHEpYij/sIo9MnQM0j0h4rDd5N40M29VtgDcAvgaUVVW+5XeJZiTKQtov4ZXgKq3n60S+YasYG38fkHX6Rr8+7agDE1peMXOmMDwbmFNKQjnQmKhNIgGVlXSGmyXzu6RhFDXA/9pt38dMXZg4u6ZGZ8qBM4
 O1cVBLA/
 p3CBXn6b9DelddTg8KxVrZ3yw4buehuWrZHDsGvPKMvuzNiQiIJnO8dSRiQILf2u0h/Vl6synVzWTU1rrpv45p13JO/2smFCE4ZJ593DM++IE4ld2EbONdqh6MWft4OKXu/OWsqyOOsd/rE1jBBHuvlAShsNuj80nrmfDIb5hOU5xJLHyxhpJ20/K6GQgE7t8mzbOlpvRopTRDmpAUgrD12AtM5IExSXRUNz+BTMHv04r+A4KabPN1kcstgSCeuxDStdkOdp3A0tuXsYFUbQS0Y+TTmLNcA+XH+8dNEm3EA1Bi7WdP0hWDRZF92RPeLrxVO/lDzCww5MIQvjPR3luWWXr6A4DNqD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in jffs2 with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jffs2/dir.c  |  4 ++--
 fs/jffs2/file.c |  4 ++--
 fs/jffs2/fs.c   | 14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 6ef2641b39b3c66924eb4641f5c0024ae11ff255..c4088c3b4ac0362074cfa186c04f9c3afcccdff2 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -129,7 +129,7 @@ static int jffs2_readdir(struct file *file, struct dir_context *ctx)
 	struct jffs2_full_dirent *fd;
 	unsigned long curofs = 1;
 
-	jffs2_dbg(1, "jffs2_readdir() for dir_i #%" PRIino "u\n", inode->i_ino);
+	jffs2_dbg(1, "jffs2_readdir() for dir_i #%llu\n", inode->i_ino);
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
@@ -211,7 +211,7 @@ static int jffs2_create(struct mnt_idmap *idmap, struct inode *dir_i,
 
 	jffs2_free_raw_inode(ri);
 
-	jffs2_dbg(1, "%s(): Created ino #%" PRIino "u with mode %o, nlink %d(%d). nrpages %ld\n",
+	jffs2_dbg(1, "%s(): Created ino #%llu with mode %o, nlink %d(%d). nrpages %ld\n",
 		  __func__, inode->i_ino, inode->i_mode, inode->i_nlink,
 		  f->inocache->pino_nlink, inode->i_mapping->nrpages);
 
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index f6b9d76d9dbc32f582069aeef0b73cf3c6ff842e..1e18d3a798409d23440a5890808bc25372549e93 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -88,7 +88,7 @@ static int jffs2_do_readpage_nolock(struct inode *inode, struct folio *folio)
 	unsigned char *kaddr;
 	int ret;
 
-	jffs2_dbg(2, "%s(): ino #%" PRIino "u, page at offset 0x%lx\n",
+	jffs2_dbg(2, "%s(): ino #%llu, page at offset 0x%lx\n",
 		  __func__, inode->i_ino, folio->index << PAGE_SHIFT);
 
 	BUG_ON(!folio_test_locked(folio));
@@ -259,7 +259,7 @@ static int jffs2_write_end(const struct kiocb *iocb,
 	uint32_t writtenlen = 0;
 	void *buf;
 
-	jffs2_dbg(1, "%s(): ino #%" PRIino "u, page at 0x%llx, range %d-%d, flags %lx\n",
+	jffs2_dbg(1, "%s(): ino #%llu, page at 0x%llx, range %d-%d, flags %lx\n",
 		  __func__, inode->i_ino, folio_pos(folio),
 		  start, end, folio->flags.f);
 
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 4ad37a42c03d8357f3ef99596b725bea3db1932b..6ada8369a76227c30ec27e8efebd93939376494e 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -43,7 +43,7 @@ int jffs2_do_setattr (struct inode *inode, struct iattr *iattr)
 	int ret;
 	int alloc_type = ALLOC_NORMAL;
 
-	jffs2_dbg(1, "%s(): ino #%" PRIino "u\n", __func__, inode->i_ino);
+	jffs2_dbg(1, "%s(): ino #%llu\n", __func__, inode->i_ino);
 
 	/* Special cases - we don't want more than one data node
 	   for these types on the medium at any time. So setattr
@@ -243,7 +243,7 @@ void jffs2_evict_inode (struct inode *inode)
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 
-	jffs2_dbg(1, "%s(): ino #%" PRIino "u mode %o\n",
+	jffs2_dbg(1, "%s(): ino #%llu mode %o\n",
 		  __func__, inode->i_ino, inode->i_mode);
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
@@ -334,7 +334,7 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 		ret = jffs2_read_dnode(c, f, f->metadata, (char *)&jdev, 0, f->metadata->size);
 		if (ret < 0) {
 			/* Eep */
-			pr_notice("Read device numbers for inode %" PRIino "u failed\n",
+			pr_notice("Read device numbers for inode %llu failed\n",
 				  inode->i_ino);
 			goto error;
 		}
@@ -351,7 +351,7 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 		break;
 
 	default:
-		pr_warn("%s(): Bogus i_mode %o for ino %" PRIino "u\n",
+		pr_warn("%s(): Bogus i_mode %o for ino %llu\n",
 			__func__, inode->i_mode, inode->i_ino);
 	}
 
@@ -374,12 +374,12 @@ void jffs2_dirty_inode(struct inode *inode, int flags)
 	struct iattr iattr;
 
 	if (!(inode_state_read_once(inode) & I_DIRTY_DATASYNC)) {
-		jffs2_dbg(2, "%s(): not calling setattr() for ino #%" PRIino "u\n",
+		jffs2_dbg(2, "%s(): not calling setattr() for ino #%llu\n",
 			  __func__, inode->i_ino);
 		return;
 	}
 
-	jffs2_dbg(1, "%s(): calling setattr() for ino #%" PRIino "u\n",
+	jffs2_dbg(1, "%s(): calling setattr() for ino #%llu\n",
 		  __func__, inode->i_ino);
 
 	iattr.ia_valid = ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_MTIME|ATTR_CTIME;
@@ -428,7 +428,7 @@ struct inode *jffs2_new_inode (struct inode *dir_i, umode_t mode, struct jffs2_r
 	struct jffs2_inode_info *f;
 	int ret;
 
-	jffs2_dbg(1, "%s(): dir_i %" PRIino "u, mode 0x%x\n",
+	jffs2_dbg(1, "%s(): dir_i %llu, mode 0x%x\n",
 		  __func__, dir_i->i_ino, mode);
 
 	c = JFFS2_SB_INFO(sb);

-- 
2.53.0


