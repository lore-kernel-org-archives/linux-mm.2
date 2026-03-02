Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47CA1EB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AA906B00E2; Mon,  2 Mar 2026 15:38:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95D7A6B00F7; Mon,  2 Mar 2026 15:38:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8156F6B00F8; Mon,  2 Mar 2026 15:38:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72BD66B00E2
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:38:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26024C1840
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:38:14 +0000 (UTC)
X-FDA: 84502285308.24.D2EF822
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4DB5E4000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:38:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dfihw1jF;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7QOLH4F6SVW69mm8ZWBBGSwyZl4pStv0v5H5uLZHpU=;
	b=cpb3M4FnV7sG93ou8C55Er6/Gf4Jx0Wc9PQGv3owazMm0jrilUr/aE/XB9FGdekJkroXaZ
	ej4mmBopww/FzzIxiNPGOqnOQ3wYlkz3EjFpMNEhBisTk98u5e9blhyvtypz4v6ZEUgci6
	1VzNVDMMmrbRntd/ibLFsNoLImCFXHw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dfihw1jF;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483892; a=rsa-sha256;
	cv=none;
	b=wcTyUsyjlwkTkgcg9FWbcPUU/IhycolJN/3BRZIgKSl/p8JBN7BpAFL6RJfHn5bRrdymU0
	gJx/zQj1UkeNA5o/o3cFliqYDzcv6i48vqMPCyJ5AX8Ka+ZmZ0vgoxPI2eIeBON0hl362p
	+rTnUpzeAY4Ccxx+vqF8khj4hYDE+SY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B137D60145;
	Mon,  2 Mar 2026 20:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490D7C2BC9E;
	Mon,  2 Mar 2026 20:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483891;
	bh=dnPu98PpOBsxLD5hcLK4mgf9NbKurHnG2PHV/YVPMtE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dfihw1jFSIdvvofM7GeczTRZaGjN56IVko/RjWryiRlHmabpPZmIfpljOJ2J9MNOV
	 ys0IDuA6hyXtNpLSD2zuRcDoVU/QLP7NlQ3Ef9jE+J8bRYhSKrBKc3JqiKI3zZiRQf
	 Cdu1+/pJ2+qo+qXqDf3bRWM7JI3BxxucWbSP5c0+7xYBk+8f8BOmCFC/cctg83T9iw
	 6MUxikSWx/kJCJgX/mbJrJmLC3xowGW+PwD3vA3NivcNM6sfK0x43czxIYsP6PktEY
	 KhKMBNMYfkJiICleMUUBg0ZVsV+gi0abWrxcL/3dVrICnxMxJygieV9huNAKdzhf+Q
	 1CEdudwrsxe+g==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:39 -0500
Subject: [PATCH v2 055/110] fscrypt: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-55-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3328; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=dnPu98PpOBsxLD5hcLK4mgf9NbKurHnG2PHV/YVPMtE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH97wgCsVXgRJvPbO7D9YfwDtQeOfAz7v61x
 OuSsVRyaqaJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx/QAKCRAADmhBGVaC
 FT5qD/9WD46NwA8dANhwhXI+E4wgQ2ujvVgqswNVOt/R0A3KIx0sWulEaOIVfb0S5FhqLDrP0g8
 O0nsiKplGgwCYCETurJGyhKlKT3Hs5NMI+PMPNHbHDEummbv973D/kH9gzHzg28yaYLCxBEkXxr
 WN10jr1wEowWdjCJkQepvboyqOMMphj/mMqpwI/oaUyNOTilpa2TaMSQypi8qXY5tFyPWAoVZEm
 1gafS/GnYTOLOuvdBmxV00tHamx+t24MobT4a+bXvq+W1le30GP/PZq8XNUEIGAVssSdSK8jlCv
 V9hxJbB6ouLnkbYzPUy2wzaeyNHM+T2wZ2zW+e1zP9+sxk8cp3nHhoT4kKfZ2aRnmSQxEUMoGf1
 C+xlt3Ko9v+UoVeYS46O44bFTxxfQjVYFqlHK0X7hv0fRr8vo+OGzmWNX2YopKnaVxWvcTOgmvK
 VUionH4RvddXKuFr7wkk7h9HPsU1IIrpQn/DO9boSCZKCmn+0+P808UszU176RwChBwc5wIdmAK
 97bikNaDuaAHX3GPGyo4TzY9azrw/+7t/X5pIsfbRpJ+s9gJE246v9pS3SXnM3x07Hu9gpUjJ2K
 e24X9IhPT9nnEQbjLHrTrbB9ufKbvzg1uI/0emWw7jPTLCJOf1nxHIBi0rAn7v39h1caBc0EMZ+
 1r9FSwPv866FIaw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: uoqmj16k643dhfnydcr9gk3tnm4d6ijc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DB5E4000D
X-HE-Tag: 1772483892-259855
X-HE-Meta: U2FsdGVkX18C2I6i/+lzqJCQjlkvMfhg9Ov8p2TsOmTNTO8X4jtFlxdn/1K0hmK/p/CulKb3Sd6wCyGTEtdFdKsOjbSW0DI2fkwJvzPs6LJwpidwR8LvI1Qmxp6eZGUyMN5UlAfzN+blPr4ZyQqZ1jHlUc6Kzqai8W84Hmj61RaR5XFMyJzFt9t/IqsfwW5X/5rMUR8pbIgWNAqeL8h0KTRVdaWiCVyszhzLVKjbAX6pQUTJGy2+gSukAV+MYnEqcnOKxQQ7zUqUjX9hQelYpkSs2HjxHMonZalBCPctA5HLiSSIkCwIKC5K+Afz+4/p5Ikph1jZBhl1xhFrPEVWndIWt+NaHx6qsLyma7Tfc+mBbmqXgdnHw1iasiSIrCyCf4Lr9BSjjdaYH4cqBunKVzD+ddZiOQ8kT9YQaoq2ePxFE+SsRlSKi50fu5q/XSV0dHh9r9sSFLYqOSeQkWR6bksXkRg3dPsaKdJ1eiP2vrncTRjtJlJlprJ/M/yvE2rTvTIfDiYhK06ElQhu7LfktKQy/+NzbQxPBBLqNp2TXNW+M9DliaGmGzp8RgBYNSJvKuVTIxhCk4QPvFJjasDxm1Hiw0M7P/8MkdVy4BqilZqcjZTclcye6/QVJyOzXlN5vs8Jb1812S/CdVZ7myVSw5jJF1V8Js/ltiOpCWE3fHQwg9YXWlFil//m0oIJ2/+pIT2IkRETzCYmszFvOtN7s3qWrPv/xCQNcbujnTgrSeFSyf4VzwhV7671rVdt8lxTdJT16wfSSBjcdtl+SJNyKIGLBnDVRwoCRKyD+HsAMkgr0XAW0yc710mO0iZRcNNxXOjm4Kdjg4ehfC3AYvWo/jbzz0nqMbw+yppdM6F3GwyMrAkBsj0i/4NErPiAGqypIbo0+UKf6Y554P++Si6xGCq8uax9up8d6NHgtxDk7faNINsTPbdAfnbOFalUsd7CXXV3xW/6N/k+myb5tt7
 jdw8Xjvg
 V/SRaV3wq72x5KwCjbKsvIarttzJEmMv2caWreXHyaj7M4gPacKR1ywkNfadj72uRN15bsnFPhPq5BzoU0xha9rsTJ30x2GPD+xYkqD7SnnEJrWmnVhJpQisnQjUDoLtUWW6oTEYKrVmaseM8PJW1LyHW2IkuyZenem8bOXnYMAtBHvTtc+2QQj2MBxoUaPYRayAXlgymIu8nccdL3UK4gbnLfbcWzU/Gf7vAC5rcW+cfC6wflb3k3ocIcvhYWHp38rwZIS7QiEh/YaN2NCOyRwOHieGb6cGDcEetujlEbp6maaZkr6pGucMPkDaUeVSCCblky6pifxJYwCzyR6hjy0QzDfShUpxnr436oOGvzOrwwFAF3s6nAf5xPun+AssgFMHLOsT/KedtJIuK2S/VWqj1Civliy9NuL+/14DsIZPrd2K0LaVpkhk3/Spp4foQj9VYlnqipAFp87H5SfVUQsL8gdpanzIulHqv6Ogr8L9+0pW274saDJXMXUzNvE4YfkfnicrYLPMOKzN1E9n38K80T2boZVRddnJli/fOG34waa2EqVVq/7uLM8JNXG16S78IOaX/lZ/WFD8RRGIS1OmQY7KgUJ89ROqm5zkg4ClVXvSZ7E3LOL1MK9/Lf6RUA0eZRWPP+5qBsTekFOyvmJeghSCiErqcn3sf26dX8x9u7TN2hvxYzJrOu3IuDmfVIpnZ+TsIgR/Qg8aW6OAhUuceTrAbgPOmJHpbkA3o1lY1VQmVQEvLL7+rMhY1bngt8CsO02Vn02MdK7pWccNFeX6gOC+7BgI6Y6lhlIrGYLOHNwQBM/YNhzNJ00z4PtwVLPC8o18uJI5KxAA0IkMmjYDZLMs8QG61/0dpWJWriVwHHbrTBbjuHpGDKu9fTt/0bCoYjLBHZu1mtrMoCIwFfeHz0S1qdATvJsFlV87RdYNt+qws28+LCFRnjCWyP1yFzQ7zceCa9Zhmf1nb7AH0Xh4x5FL0
 OBeHAudT
 1REgwY4y37FakBspMy0uz1j8v0SuXxNntjUrhfeFBoAmiCC/NsZmY9llZQJ3MEhwko/CNjtqWy2N/Jg482hLGmq+feXSr26UjoaV4TOQiO2lnfHiiL7XJqN9a0KNEryUxiPMyUUaFuHoVrx+8XY8BVR+kFYn2GKSGF5m/eMC8VwsGoNqBseQxC4QXEAbcNr/eqAkazHNbsOoobeJYKvgI0z0MPkjt9UjlVhlhUymJZTNQkYm/lMdKs1VZWdLF7nb44Ayhu/k/SFVYNKtjIKYrt8PABgF7wn/FsandsMM4Hkc6fvLCEgk5Aa7p2f+NUEFkFdZ2lsy2xL+KA7EynXtTSpBqs31t6kykZzwBia6gFBL8u9/gThXCwLmjcfw8/tjSUW5pJWWvvmM084atuhyeK+vZmXnZbwgqdZD5UoOZdGwQ3NZ6NGZOq48nMjlh41cq4quOhP2YOp9RRnjpHxu1B/so0eTgP6f+QxpVV9T0ufnHtIuImrUFaR4RdXuNjldpWsT4RrbC49FPcFZf604MrOInxRXveZ7Fqh23QVC8TdDyhX1gHHHpl7kx4yb+4LfDsmT5pCGT8XNxYRHup5kP5rKJHuwHIGvxQ3Od/803eu9M6i2quyPP+TEbzIFNp7/qXHL2+8R0Xn1cgbFlgK5uji+CLNmGTDafB0SGghrtG32gkq9nHDTbPQwT8jz7myylvdrgZ2FuqIsSRPRRFpKAPbnbb4IlOzPXEOYsLEVVD7R1jGzwlEmDC9vxCcmoLimzcAuj1qGo0y2RQ6bKatSoAJ2Y+MwRWkk4RIb6lKkYvjob3HbK8t4L9sp7n/vfEG4gZwKdT+r83M73sVAX27Y/msLhYtgmIBxLitdr82RNYaHq8Fq6V+WeQjIexXPGOA0vxRSfkiFFwQBbV5crySANf2G/lO/0np4ba6tS8sHGCEkVKHO076QLYvXAa/dahof4xQKAhl6II3aepWgjmxSC1tYHWA2A
 E2pLURak
 x1RS1wk/Thl1MegnJE8WSNV8By5bgpvtLp1h4Yu5/2vwsLsCpD9jJwxWqwH25+CiPnQ2G//uIXyLS9pXKS04h9uMzF62hj+e3UtXzQ875qbkogLZesnn0c6ImygtjsFqsDacfWWQ5+sqtE6nkbSv+7wmGYxOtAoZG7xxfdHT3K+Me2De5dpHRsNc94K23hHSfKbKJC7EnNQITpwCwey/2yc3Uh6/kSRHCAiYSVrxWdPr9NTOlwnEEf3lK4kolemEUAtayEW2Fc8HwvAnRDiR+3JYDbgBdlLmQrwNvF9ImLKQIZSm1fr/cD698wznyjvvLHxl8ZdwuNbF1648ysMdpcFTZQmaOCIRB95vgtcOejlzCZG2fN3/VbwGkMBAxriMG8ZOY6iHwalUsVqWFEemdwmErtUciBNG5lu59ADFzcjC+jp93K0Vts8TBoubZrJtswdFNm30Chs2vluN8AzC9azQJt6N+zkArQWSS7oYew++AjTjSQHv+rrMSQ0cphuTsJETZjsz2rYgMraQNHtBvliWiFmVR+7Nw1e6PjZEAsi28tQhA2gLmcshiiRL6QpwRnnB9FVEuTfwQwRyjaBi+ljI65jNbiRLrSPoD5vhFWFdNAqbBErFDiU3OIAS0WmjYSPZI+ZEZ2lT5TLraFeAwGX6BZ4JnaNDAgwBWu/ZeRdzYdkXiUX1ovwK+Ig2v2AuCjG8ZBZx6igsZy+uNrXQNNk/+gi8GnByd1tyGfAz5ufaaow4Tt2qB4dYFmowU/xmqgYbYH8PLQhDPrq6BAh6Fc+VqQrtpMbDWJAUtDdeaWwUafBA7LO0fx51Xp34QG53G3YxTP/Bjp8GTz7jFovkPU0fB1dKTA//TJ5yLtkh+W4tusZC/l1IN0tpPR5h2gI7bAiQ+EjUBvvjPsDq/z89X0e1JKetyS8gM5AaHL0JMGG9oW0ZQnhK7vOwXve+r72tcO+N67SDObzArZf1NtP6pKd+SDZ05
 Xv+IoOBb
 SAm9ISuWUKBHI2CRTjqdrB8pKPHpjhjrKsm+eiEVut8Uy4SbWbzTPppAwWkRPucPqHpJREVCgyYiGp+hWnm2RfBZUytAs1ZKrmCgGqMP3H4LLvtT6vYeomE/rypsTaTd9xHBlcBoGbKX/PWsgKUAenveErKoNdUO6C4nGX1a4206mlyHtJBOt19lUivQdcAv/np0j0lr2bDf2AZB3fp3rpdKyUJxN7BFp0BQKabmtweUApyzUTGbxGaBcqr0h/4nqMlzeB3feksmW0GcNgS+ICwt7FPcM6MqRA8dAQyhYxAGiiB+7jLe3RJd74IVzxOAy2Tzdpbh534zKrkX4cyIwPN1fnagDM6bw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert fscrypt i_ino format strings to use the PRIino format macro in
preparation for the widening of i_ino via kino_t.  Also change the
temporary variable in check_for_busy_inodes() to be kino_t in
preparation of the same change.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/crypto/crypto.c   | 2 +-
 fs/crypto/hooks.c    | 2 +-
 fs/crypto/keyring.c  | 4 ++--
 fs/crypto/keysetup.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 07f9cbfe3ea4115b8fcc881ae5154b3c3e898c04..4fc2990642fd3ee385a9919183cbb0f1c5ba6a58 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -365,7 +365,7 @@ void fscrypt_msg(const struct inode *inode, const char *level,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	if (inode && inode->i_ino)
-		printk("%sfscrypt (%s, inode %lu): %pV\n",
+		printk("%sfscrypt (%s, inode %" PRIino "u): %pV\n",
 		       level, inode->i_sb->s_id, inode->i_ino, &vaf);
 	else if (inode)
 		printk("%sfscrypt (%s): %pV\n", level, inode->i_sb->s_id, &vaf);
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index b97de0d1430fd6ec764f4a758dffe00263496118..f41809f1f1ed0b1ed78b85a4a987ec9e6cbcfa9d 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -62,7 +62,7 @@ int fscrypt_file_open(struct inode *inode, struct file *filp)
 	dentry_parent = dget_parent(dentry);
 	if (!fscrypt_has_permitted_context(d_inode(dentry_parent), inode)) {
 		fscrypt_warn(inode,
-			     "Inconsistent encryption context (parent directory: %lu)",
+			     "Inconsistent encryption context (parent directory: %" PRIino "u)",
 			     d_inode(dentry_parent)->i_ino);
 		err = -EPERM;
 	}
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 9ec6e5ef0947eff394166d8af438a808cc8a4b2b..c0a2568a88cf6318877dec0f5379c5c8511c00f8 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -969,8 +969,8 @@ static int check_for_busy_inodes(struct super_block *sb,
 {
 	struct list_head *pos;
 	size_t busy_count = 0;
-	unsigned long ino;
 	char ino_str[50] = "";
+	kino_t ino;
 
 	spin_lock(&mk->mk_decrypted_inodes_lock);
 
@@ -994,7 +994,7 @@ static int check_for_busy_inodes(struct super_block *sb,
 
 	/* If the inode is currently being created, ino may still be 0. */
 	if (ino)
-		snprintf(ino_str, sizeof(ino_str), ", including ino %lu", ino);
+		snprintf(ino_str, sizeof(ino_str), ", including ino %" PRIino "u", ino);
 
 	fscrypt_warn(NULL,
 		     "%s: %zu inode(s) still busy after removing key with %s %*phN%s",
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 40fa05688d3a1d4aa33d29e9508441faf4bca933..b30630f2c6a4e341c72af0db6aa173f59f742fa1 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -91,7 +91,7 @@ select_encryption_mode(const union fscrypt_policy *policy,
 	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
 		return &fscrypt_modes[fscrypt_policy_fnames_mode(policy)];
 
-	WARN_ONCE(1, "fscrypt: filesystem tried to load encryption info for inode %lu, which is not encryptable (file type %d)\n",
+	WARN_ONCE(1, "fscrypt: filesystem tried to load encryption info for inode %" PRIino "u, which is not encryptable (file type %d)\n",
 		  inode->i_ino, (inode->i_mode & S_IFMT));
 	return ERR_PTR(-EINVAL);
 }

-- 
2.53.0


