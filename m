Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FFC9EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75506B011B; Mon,  2 Mar 2026 15:42:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28AA6B011D; Mon,  2 Mar 2026 15:42:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD416B011E; Mon,  2 Mar 2026 15:42:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAA0A6B011B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:42:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D7351C308
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:42:46 +0000 (UTC)
X-FDA: 84502296732.14.4499DE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id D2729A000C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:42:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jr4ryKdK;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MiLA0YJFtHTCebuIf6f73w4q/hJhF9MIy9BYrRmXSy8=;
	b=1Tk9QsM/R88t+t2E7Zcy+YDply3fmB7elPETVa6vCVY0CiYKLu7nd5UNakNCwjijz0xUEV
	aKAi2EBijYEgY6OY71wBi3oZAxSFMQH21cn9ND4qAnVXspoIFXUSDxaVynR+BivNo3/Guk
	nEIxsw+Jd6jDhmGBrz8g8NkC92FzrzA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jr4ryKdK;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484164; a=rsa-sha256;
	cv=none;
	b=jMeGkL3t2HzfFny/byHSUW8oaH3NgUFPLxY371rInlVkQX5fOphFt29epXBdnGZzUXf1if
	9LSpSf6SF+0bkhB27TUrLB/k1elS3TUfbyTRaVgoNCvf5Gzg7qZlgyzft5RiXUH4177WM7
	DxA1bFWNckCwSzHbY7fwzvbTiwJJDcc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2809760180;
	Mon,  2 Mar 2026 20:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6DEC2BC9E;
	Mon,  2 Mar 2026 20:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484163;
	bh=EAJn9Z1NV4V/84sfstd7Uwl4ofHtYkZnXmJoeTB2O0U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Jr4ryKdKtx1Xl9H8jdMicHUh0ZD42bTwJ5rs5qy5r8kvx0IRNKlpuXO2UnhmAYNb5
	 MMjczqniL11HgAnnMwY/J4SxP3KYbOnhyAaBVIyO5cI47o3h5HuD9b9FL8kkpmNzk0
	 bHWJ90Q2CfU+X1p7WAIizPNzmZRMqEKbn0gqaHzTl0GSjMfk4STHRgXCUFsmAvmdeg
	 7CoucHzN3eNoxUJ+MLdy4ul4iCatQM2SQJAJDpOqZhAUz8yeNRB9undUoQxo4t+2vg
	 Nu33AqNUyJs9z6hd1uAj6cq0LLryxc+fo8QjBb6MCXpkmGori6DIf/OMolbD57+7r6
	 0PHDYuhVphGIg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:58 -0500
Subject: [PATCH v2 074/110] bfs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-74-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1144; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=EAJn9Z1NV4V/84sfstd7Uwl4ofHtYkZnXmJoeTB2O0U=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIDN2db72FR1UWDXZCuAGWaBceZDMPNjq6A3
 xUpvPai2ViJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyAwAKCRAADmhBGVaC
 FfEPEACxDpZ4NHP5fwLmLmKBZLRvL1n45+ePpCbdvB+lSGBQwRMvcN8doyc/3m4x+L9yg0POdje
 BTXvhtP6M3D1VX4SjH2U5lHcNjOIOa1iNipJqhtnwoN/Xa65n8PZY2LwHpWXr/dB1QhXb0960IS
 qHytjICufHdkZhDulqmJh/z5zdIAHKlMaQsoIgNRnMiWySIE3dITo23Pq6pxbmTAI5uMGDd1Z72
 nFhq8jYOO/+KE4f7dIEhFXOLukkL9ZW+Jn/Idri2QLZ1LxFuoS0ydvpjc0Dw0FPRWeR7TsaBBZZ
 LPJQ98oB02rnYEx3HZDlZPgyn2UzOviV5lYWe/Iht1ltqwUdPDLKF2imVUlsG7OOGXCoGrEdfmw
 aIBjlKyYQcC986YSod1svFJn++ExJaMHgD+RdAbqCxrut0io3LChN0wVaQQFbOL2s1Jer3SZqSz
 AeIyna5wMIziQ3gOA5p1h+wsNMCVaPuhn94NTjFog4da67Fv7BaoQoiEY13Lj+JAUBM6QXbkm2e
 hfsoJio494+cFY59ICY/ZEB0l23IT9DKZGPJuCof8x5waX+aBpI3Aq1I0PDebbaypQQRngsK8kZ
 MYAdEDyXIVm/IVrlWavPwYIqp5scGsbzm35tZQsYk8gs9SJktBCxayP3BNrZ7MjT27gCheVfIcS
 Ze2xcUru3kDB4bg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: D2729A000C
X-Stat-Signature: cu78was4xuksniz8g9zbu9b9bcwocswe
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772484164-862851
X-HE-Meta: U2FsdGVkX19hXweZe5CDmqhcs2oDwy3VbUTj1RXKZIa4cbS4w8cNj/m0vVjuZ+b6Gv5QpvmOkViji9G7RmVTPVRlp7pFl/SFs15jFczJZtcqmWRmeyLoJjsq4i2VsSixYv3mZjWvbWDUnzUsRQ6B6BwVUkm5tPLVYCnm/PhQwOgvBVG6mqrQevRLHwzn8Gff9LAAXgpdSjZqFPCJ/oFwns8Ns43LW/VujWwsdQ4vNaMCdAEoyppgIij5jAO2ihi14KOtzJBXFkaE3wp0rr0pKUWlftbCYSia9SFBUI2fgAFYeh4SDXkut3Qc4bdgJ41N7+egh+l+PLl+M/7OWkJVD5Y8XrJPBJP7BhfFaiH/XAKiKX4hWxGIHV06DcVHoBlWqfYvWIek6wSQY9QrX99vzFqBMh7xSOUd0VcDPFm1ZEZkHCIP7db+vlF60PnflUgZ99zxVjmugFlXmibEC9nShFUOd/pNiLvb57ndZvgiHG12GT7E2CSq/3DYvgECs+Ue3/nrtdks8LszM7O+qV7/7DNUtH8wy/Hq9drTRs94cuZIQ01o5cqDn28Yunh+u0nZ37fYV+Ad9/gy4RPWjcGMhp0t6FM0S2ykMB03IkepuUmA/vHN0r67YZMjOrwC3bQUdRlvhHMhn1Q8sVPdXFQ+TRQp1bNHU2+fI9XVJnN0eWUEjcVipR62KllcDXTO/5SMRE2UBii5K1iE3JrrseIMVSQ5nxwii4JZstbAYE3wSK7tfwi3Rk5/KB2hksQeoARiNWfxKN6lNtmabYFPZv+NEOcDeNSY8E7oDcgnEX/MBprNwnvddS0wD2cs2jtKsd9rr44wZxz5biE2TkN3kNbzuulnHTIlpkkj091irxpD7dZbS7pooaVIWrA98Pb1qGvzMTbhxn/VkVV6pyzAlEihn4MT3wkcf6qx13UAMs0DjiO0GPsvl/wDpsjQzVsmGtokaz2WO8JHNTZ9bDFB/kZ
 KfAMBBYu
 pQNfrkKtXSuc+ye8iztGSHDzSSTv5IqFKQL8g+hrPYv/6BMQhjsxzdx5k97MZHGklaV/YdayLtBZRce177Vs12422Hhj0pE0YVSAyxbfcEctBQELZxecYDaR+K7G2p+fSbX+Mmztrk9aB+twX30hiYwlJn6RPpytXcmR5t1g4Nq64MyQNvy0vbc8WCjy8tD3opkuqHGhig8kATSttT8HJag03DR1dfl3VLdfOnaFvSWAby9y7H00jDt7U2lAeEfd8yF2itM8GChXOPDLLcjz3vocV0LRcJBG5ixexF+KmUxrBVUmxl27tyWoI5Qv313bgmqseFYm5gXL5hCjsFWD6zowGkn2DOtgpwu2zn7k8Prtkrf4g/Ny2jamXuFn/0yjIrw0PRQIqpXCdivfPLTiuil7uuPDMwj8Vo1v3wiL6aGYpxL/xSqulOSLi98O0+T6DoXhVX5ejpEjZ+7+xgLFVu2msAtGwockiWKTw65FYrKo/lkfCFMJjPnBwTKqTgNUbKoS5fxkVVEl2dkgLuhE05KQXNOSzjQN4/Y1IMe8U7VDcYXIaINVQMs1xgy1lTkXbnuWGVIdjIwlFsg8/E1CGr+t41bOU457NKzC9aUzvYiubU2p0WBvKnuQRQFvN0OO1Szy3UbyjCJAWtsHkCsx1x8tYWM345cUox2+oXvvQnrGnVEhO8hucbA64wCZYn3zJCKpSG+sJ82loW+GYHWhBf6j0041QvtzhHUJ34FBc5NlHDcAx1uIwgURXRlccgResSuyJp/tMf5P5ELu7eVuEj8xRUNi4kWJliM9dxUOFabfhTz2e+xSSLDSKA1g+m25/rugbNQ22zpSI1DgHOXHPwfT6n8CRVQHMkoGeyRvifF26Y3zBA7JXOx5xly3RyXS/4GomoM7vMwADGTM65cmWC9kYai2yRphiZpeR2tjZGcMtT866oorLhvWARko+n1UlJPAsGixj3ySvRl3Up37UzhuAed3N
 QCsRxQc6
 hkYdNdWqDlmXE1aZoW2TGe1mUcR60TgDwZIQEvNRG25jzDte4TcasZmDWqqrWcnze8jOEukssLxHpBrA0aQPoSot1Q3vZ4uDIv9a8bLg6Wkki/xMjDc6kmZ+vhEWAMairPfgSERBJ3AdQmUf0bxf3bpSMqUm6oPy+1y8/zxOJSqSYbfVbaVBwRhdHnYsendvnQeIq2S2IowMT2Jj+WpDRyMBSiZ7rSMNs2+6FAd4ULWGRg4JdcAzEDv/ZD6N5Ojc5Bgfa7xZ8J6PKi5k+hLgLxeI0jn9UhmFLQHNoeAB5vCQqMgSMcod7VVkZEXDdNJugKrMMhav6xzP60lHytQtIQEAvnYYIx8afljMIGPs/mbjXjic60FElHLgd1W4UQTuy9GU3ZJlc/AwpIlCtDe4KeiOlO2SoyuS3Jeyi5i2fKl1/34eDdC3adIaIsbwMN1KnSjq22TiglFByukuqqqVeKqkvNvJdoyuG7x5w+r27b9jHa36YGg+4S8qAe16vn/6XAIqZI79FvfIwNVyP2vbnsYAYH5aFIUvVduL9F68PO4JtkzgTt2XoXO5JDhoMB9/RoYP6wTLjaAl0PgHxZ3irycc5FWD5Wy6EwfFrdQaIWFN5MvqptfNx90vr1+YsXPX/nNdlimzEqWZVZ+R8LlPCAmNXl/Ckb0Z7S4gpDh2Tt4GAdlLzWbyDCI3U+0vxFuGkVlIHLJFI1vS0Nvqr+O9eCD/+4LGysJ5RZJAO+ttL3QdBkynD5Q4EtviS1yAGk+KFfIFLkM73p1qyu+0ake1qcnp+EvqZoQmBf6sAnm8TQ5Bnx5Bjq0FDTAMt2qTwqZlfFJJuEFTPUJkhtvVJLB/5WhjRwsgUUMMa7yRxozA78UX5cBJhfU87PpMQp5RQDX55yzdyVtC84Sau7r59aSxd8FBi7VuJehnZ1/lK8o1ayEEEK1u95agYeKvg9nD9UTuPhp1cRzla0pic3F9g2spVunkqzwcs
 WSCMvPiK
 gvH3Rk4LghwCVXm31V3g/Kip/2xXtpunLVeEv47rjWaYLrzcjxEegjCXLnYw+H8MuKDNNWMCJbUMI8pLOmN8NVe0FJrFKWNfF0oLl+uXHcR5YST+ja3LAmWejjJugJ6PGlbJXVcm8vyAXcCju6INHpuLG+jkRmyoR5snN3P6W36mNPHZrjIs70vXpHHy51FJJ6jLA2QwzqmZmA1G4fcrdcU7bcGaFU1sTCvgtn5/fB5E6PDr9X2mXLzKbi9O/iZ4034y1xVFQwoH8kzt490chpg3sB659SR6qB+mftpSxXrqbMpWxwJuczyTx0/kuw2jJbv4je5tHgSJXUJmsso7KRof2N5oJ9ow9xQOsdvaCA4rPkGLY2mI3bF82ETDNg2x07JeDi6UCsMZK7/+0O3ONnFapJQInUda2zC9IkqKygr9t+KqRMlkbRgQl+B9csWm1OK8jr0kv42Ml+CgrTY0UVa8DvszbU8/DwnQzOpSxhZP/gS3j0m4JEKYfuSyvOoyysK2smcLVTgr8nHbVrOscceThhstr/7prlqZJ0uIBIZHKfr3MhfVNLfR8I3Mxg7AMqIk2wD7Qc0On6GUcWUX6r3VdDHbhR+3BsvRZoM3bN4zTJPWCCY1n6nIn+ZNxS4hZW+5ll3gaTtzdUjfuWNeu6NZD7Jlk0FLqgb7KX8oPS+7LEyRl8w3jb2L9pCyE80V9Qee6jEyp5eRimTkYE/J4WxP9pSHlilb9EIsFdal/SS0LslxFocV8cpydBoKVwHsk/tX4Je6m/ie1qss0W2byO947OrpRTJDL611zV+BFSUxwXgJzO3TUPrBPzEFDAW69JtnWxUJNZQWItyFg7l3kllIgfLCehfthEoaJisDrgO288Gw72D7VvGBH3eIEXOQugFCFUVMORyjoKTe3+E873aPTPbZDcRaH47nYDJTsaoEejc/XWgn6wGpogMjXe/2gX+l7MwVAClUdcQSig7oJiOf9rcDs
 3eM0krOw
 7r0S8C/6C+O3C48j80IGqEWPe7RcquXslzMoA823jVGOAiLsIfzHKfGOBy4QdU4CN8BI/9Ni/j1eeRGZpFhpyzZYjjwei9NjlfCUgGRxHgQrty2mdxNU1S/VFo+DeHR1S/e8/YqpyTo8/EsIXI6XBe1+Hmcl/Cfml09BPAZXlIezF1m9YCWceRqo0it6mna35l4qpqMncWtnQFrjEsRfsLID8cqhmORFxnYmL1nzfixxy5b54a9Z8QyYg7FRnk5vVhV6L/KdfRi1oD3a2H7fBghbwqzt47Tc5kFSA8yhDIxerABKpon0j2wUMkGAobIBJBjCnp1KXnOT15NxqUqXQr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in bfs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/bfs/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index a70efe448ee82e9b1bd499abc968cd47271e33ba..481514db4eae3c33c280d04371a17ef321486ac1 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -35,7 +35,7 @@ static int bfs_readdir(struct file *f, struct dir_context *ctx)
 	int block;
 
 	if (ctx->pos & (BFS_DIRENT_SIZE - 1)) {
-		printf("Bad f_pos=%08lx for %s:%08" PRIino "x\n",
+		printf("Bad f_pos=%08lx for %s:%08llx\n",
 					(unsigned long)ctx->pos,
 					dir->i_sb->s_id, dir->i_ino);
 		return -EINVAL;
@@ -180,7 +180,7 @@ static int bfs_unlink(struct inode *dir, struct dentry *dentry)
 		goto out_brelse;
 
 	if (!inode->i_nlink) {
-		printf("unlinking non-existent file %s:%" PRIino "u (nlink=%d)\n",
+		printf("unlinking non-existent file %s:%llu (nlink=%d)\n",
 					inode->i_sb->s_id, inode->i_ino,
 					inode->i_nlink);
 		set_nlink(inode, 1);

-- 
2.53.0


