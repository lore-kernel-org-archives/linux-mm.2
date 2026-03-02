Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 890BEEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F26E36B0115; Mon,  2 Mar 2026 15:42:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB3F6B0117; Mon,  2 Mar 2026 15:42:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5DE66B0118; Mon,  2 Mar 2026 15:42:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C06BE6B0115
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:42:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 961901C302
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:42:03 +0000 (UTC)
X-FDA: 84502294926.10.9BF0D30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D46A5180003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:42:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aBcXn5QX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1dKb0NVz/wazM2HA8FKGoEvftRgT8acrtz8t6X+ZbYk=;
	b=CGLAclyA+6s43ksynnxx7qqC3DAU5gqhsE1nQlD0OW7dt5k3DSl1mun72VqfyBtNMsUmWI
	Gk17qYli7UoX0Gmatea4ld8D8oBp21sidTwq/wUMGqG9sAHckVpInJ3cdF5BX5a060cUTb
	LG8xCi+sfgTDv3Hj+hC4/r49PEkuuKw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484121; a=rsa-sha256;
	cv=none;
	b=FBpl8y6NfJH7xCtfEiPECMmgsm3TSZVd67TriI6IVvl0qmfl7TEVPzWRL7T6ha+6J6rfwW
	3A6Z0Bfsw19PrsSxe8rEwzZQRG6HuJLn46TIt25AnuehiK5nIPTJ4ozwXjU+hPtQAJc8DQ
	ZG0ehE8EV8fdfuyxukz+tOM0o5mDZg0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aBcXn5QX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BD0C60134;
	Mon,  2 Mar 2026 20:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FA4C19425;
	Mon,  2 Mar 2026 20:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484120;
	bh=cZRkm/x8uYswKiXIjQxPVFH9LRQuTFkwNEeVHlJiyks=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aBcXn5QXA3MwG7lnQn77lFtc6yjxwtV/hhmSL/G1RX8cGUqimMoWE4usYcWsJPtEh
	 xfvjyHSQQA6xt+Zs9RR1HfuA4mIHa+LnsqQPy8K+DD0z0Pem9UNS5BKbZ+bq3A9QKI
	 1IrW2zOHOYVaNEGfwAs+cAlO2WXSV2Qsx1cfORaKg8jNOqcQ39UTXwFuwKkJsl5/Fg
	 knCCbms+ECneqoTRvnwoU0qB3aN0/iSBzSOA0qFy67rQqYjxDsuN5/PGEXU9lEEYOA
	 lfi3kmG/w7fxnQqekxwiuyVw8mVyugp8DJM6zTkXBVzdumbjC3FO43IhHM5srdeZEc
	 LsAYyuc22nHvA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:55 -0500
Subject: [PATCH v2 071/110] afs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-71-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3918; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=cZRkm/x8uYswKiXIjQxPVFH9LRQuTFkwNEeVHlJiyks=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIChBoSEfj+8Eytj86TxKJcjYWZP4+8EVvqy
 JByJAE8rpaJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyAgAKCRAADmhBGVaC
 FU9bD/9zOL3GtqLTCPm3spGglMWl0EVnZTZ6JIDMho3AmfQ6DUBAbl+PtE7sbQJMDnDWGGLIlYf
 uCbubmpX5wgfsqxVaGqHJ1u8XGeX3FjBEIVcO0CjFv5Crc64VN+fMWC91K8T1EkD1eR6ESGVXnw
 KwKySuvae4DKLyeEnvt5JmnLolo1hWZ6Rrf5DIYJ7QOIhWYQMAdE6KSDSKG4o7k/8CLI6UPPV3n
 aG1kb48P2FcCEEATrohBxw5oV/7BeG9Ld22TDasZu8y089OZtxoyM+4n+RVug+AhI65V61b+tNh
 i+1p8hpUrdSo7pS4b6MVerqpl7TBGRzHcU1PCxfPjI4ssd650H7lgC8RJv+JH1ce0OMGKyi6soM
 DcxtqprS/Xxuylze6/BtrC/UMaoiGn3HGM6l4vPaUViR7ExVNZx1zoC1JYMhDPI/8P1Ti8l5ZXc
 0Snvk9WHAHNTPq1xUwXYPjiWeiHO94zn2OUim9konNp3ATlguW9We+XjJzAeaAaYYQHKxncLE58
 mZ7gIj44wxs3RmAlGfcnOCt5ioeszdiLclJ7yMD7tOyMIBk0IiE1Wwr63iL3QTN39rvLBgAjSDh
 fr4al4ZnGN5Nj4qBIJio4OYkH06HuNvh9yTLj4nnxDX9DHLbX99hL9X9KWck6B32ImcyEM07eLS
 mrzS1JaYFd5K8lA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D46A5180003
X-Stat-Signature: mdq9maafpy6rtzoea1n6jbp67x99hq9z
X-Rspam-User: 
X-HE-Tag: 1772484121-721736
X-HE-Meta: U2FsdGVkX1+PWnbwuEPS+FkKDsgJyonCZkSgDsYv2aZkZtV+Y0vnT1ZGrREufPoI1Fms+7ynaauH5fazHeS9do6Gp3p0lPXtfYeIGl6XMG+wayrGZkZamYQQr/01F+xyk/S3/wyz2hJ3sT+dgk/ywkSsMlmpqtO9DXum57WcuiRStW9j5l6NYiN5DydY+2sn5YIC6/rFzDw0zeLCv40QiNFq6ey3qNVMPyRQeKkFwZYwM6zcL1+3Y333rUMOjbBtG32cx4sldoXbE1TE3891l2Lmqw7IKH7rICXy0ZBNmcb8LcQcPMpx0TrEKHa71MuvRgg9tDihvY+YO+4PThE63wnm8HxhATqnSt18jUd2QUfSozYMUxnSWXr+iSAFyQzhr52Ef7+sQbGe1dsTXMK46kpXSQsmukji1O+IqRWNYboJwyUA/qaD5GW8uBOSWO8JLZhL0BOsxra+z6VRwphpRE0h0bU+KMOatPLbvW/jyT1rTjt+aTeCrYuurh8fnRyq1fRJw10BTGP7izU4S2PW4274RFT2Q6s46V8l1TyMZQNfQ4ZP/OSX8QKvSr57wuKAR+OfRPS15/7LUfIyzsPKN4bcNHhMOd9UjHdVG+DanDufPGg7GRrbsO/1It0hKGkh6Uoa+sTiLjk11HLVJlgAoQzP73GuL/tXaRBRDoyNmLnyQq6GrkcvA3/w9ytGYV+R7Izt6zNa/bYmWF6+nLglF8lzntcHU7lhDHQQ9FtTyFrxmMksWjv4AL7+5zly7gqTbqUK3lFlgX+EKt8qzlyVnbl4GDEms2sKZ0EWpWoLssRNJIuan6IWWvcOHq5ki23ZwPt9WXKTAcmeGgOAmp4WgZBug+m/tMLa2Zj8R1WZ1kNfAzr86/iOPjQLOmEMolvQfmJ6iHmJSPqaOBjBA3S9cK/Cblj2kddeQY66rftU4kFXrBnr0O3RWeMr07XVdrwwEALx+15FImaR0dfzyhI
 xTGweEXm
 //mYrjf+VT619qJ4p1jpuh4aZXivCvGc0OFUrQuqjViAIpsIZzwxjuFAwgTCZeWhULsV/BT1XaaT+yGrXSYffaF31gA+jEpwNyPT07tF6l65ljXs8f4iIEtXwnpk6tDXFZibkgsv5t8++BIIOsWqmCqsyeKD2ABLGWh5/+5zpAGTOZ/awpTIfHtyUaBXrW3t5s3DhfFZYhLUHywYCbPGEnTY5eWSaCK1YEx1hPx+KaWgVS1AzDn2DG+74uJ7rBltw8EWa7TVq11lfAIjogt9gUrKF9cZ7sCvDBCXHpe3DQGlBcpFqyCNBSHoX/cbW1PRbCQRHHQ6Cln6AWVo1SrVDgfYOnKl3AplqXlgMLJskTVTf4WvwH9KzLE6DPPVsiZ0pj3ilrWmsGG4PIV04xWePjD2Q8b7EsXDPfTEoBm5DrOP6ZEOHU6tcTBI+1wlqmtbh/2KXdcMe6J6m+gdzkAcvRhairl97fVS9ZNC6b8RtrFFRPTthNmcdade/PJg9FB0LWfF8gfBwRod2cfArw1BwqZlj+L6rwb1Gzk1LJ9toscdvloe0SGJqycmEZlCQm4ZG73Knr983naMJpGgUG+a6O9kh3brb8CriVPpQv5lOQFNw9WtlBs5CoVD7jVQf0OHZ+OTCSQ2fOdjfEREpzlHbqk5WpTtVOrSI03U+Q4JAu+x2CRY2XDcC4OaWI5m3zIuHfhqOLHcUp2tqODvzC8grBud5KhW95t5o0u3PtMUcts/uGxvFx2Eep/VL0bFR6Dp9pW9vHGv5LePxOz2mlqbA3XHWZAbjrMykSLI71K3UoXg8GV/8BimOU9ptVBiv1ssFzzHNC2mv2zYvEaNqB6SrP50lztNyPvJpYSVrO5SKldZT4vcbZmeRSHpA1mHUGpdoxfDwF+3SYOTX330wCptPACmw+dW6BkQWntX7UfgzDBqu5lYUjCR0AbgRN9NHxvR7D8ihoMbhIMDL02Xapwsb5M3fi0fN
 1+RGYa2W
 uC2k7jTpvyi6iK583qq9Y53cUxvDOf3BZTuUa320knWsvnfDUOhVr6gJApdZ14sl55cxNWNgGuDOzib2pY+dJxkCAZ9BE0+S4grwHiBAWN1VrHb42wN4gIzsQgqZPWGyldGe79hQ2yTxavkTKXRz/IDVKlq8/cxAs6HnQS5rn7Gyy2mcNTRfMomI5/3HdDyW8kO8O75HGUbp5bC12J8+cquftIxCLdetBJ/IEe2DpLXuta29xO9Aa4VYvw39hc5ybn5wg2sPW4383Xc2kWaQWie8NQeKBFwsvqYF4T8cfCxrkpf1aRU/jQa8YIIv60ONoc2bxFnvglzbmmLVKfguBfVVT0aHTreIH/RDssnBoHKyxBUYNhE3L0mncCSsWsugMneoNdtwPrD5nTD/eKugeM0QtEExXL99saVuS/hiZxH71rrxNnDVpgNGijACQ4l+Vcb20ya0pCnnkZMYllVfkYFFi0HZzw3QdmJoSYdJekwrZrZrouXY7rlRv0AzQZmM3yoQ2ijn88JQHS/PsOzKusGByndJguPYAWpomagd2AG5OYDwKfcYrFoMXZzt7hHeT5eaVYbhd7Vf9uRpYnUINiumW8HSnL5rF85GDOhngazvps4MntZ7n55VW93RsvPfBurxUo1TiP/eXJbzVGU06yeYWf4G2WStffsUDGKJz5VUuoJDC1j797c0K/gmLkziy6FqdruEocf7FA+A2h7lg0cBg7l4D7iui6TqUV/9EHiSLXnf0X3qVZ43+5RVKc0NJDXGi5UKcCWmLMX0tBBlsWFDigqFgHLpkPX7FzqxSWuO0+753aOpfIJNSOaoI+JxUPR1b/w1W04Tb7ttC40kuJUGgC1002d46SXwiMLkh2jXE3Mm6h/YcmtpxBBTnOlVoUCshZwl0dTGsGnOivgBb1TMUAdMb8CrPGPsWKq9cTUoE6rcYbD5OJZ9DgZVDBn/8kSZTHOETeH7YVkJ0/XU7ChpSP2gd
 gcUuKyVi
 10yxL7uxRa6RXFGqSgaKfhnhmFf2ZTpXbHOyvupuc7jqW9ouCtCmeDC7VIcRf/wLUniZYcTKYemANq8+0sUSmZ+sCUZCVle7eRAM0m5Bv5ezdF2weKb2QPVCUK1DtOroC8hQfx4uGfw4GRWbI+GFUnVpkJPEvlY1vGMj/RDZOjcK/y2FdNDeZBsoLEWHekA2DuLrpQhTOaemtN0HguwWUVeREsnE0OsvefQGiz7+6+GFkB9j99DU6akNwQtQsWh2SXa5t5DaDuryxwkXKpMdJ5dMFfrW/OmcZU/6Su8IZQhMbYCtEpz1cL/ERyqpqYPyJ+sPvcoaHhBOYzjpfSHtkGdL+6MMPEOhlxUrrNjMAZ4q3klqinSX3KKpU2twftX2bEKhGqwycrQobeRyjGTEHBL0xHemqqpS6jIHGTutHR5kLgKaNUEJw8ylAP/1h2cH36NBreMGBuhh4hFvrlDItYAuXtMcwCULoE6wF7QXXRrb11hbPdY3BXBfTFZVto/JYsteE9iv2Tlr7zXOxzW7CEb/lZ+X5UjxZvpjBOL+3EhQHDgf3RfJhtpz2jbGsq1OUtklvfYQM3JWXBHtticirhWwmvD7x4INlHWFF0zn+4jgNX2mNI5502dxWBXB5+rS5LT5a25YmAjmCST23Pgj+PG5trQznl2FDv5uvXSlY+carT6gF/00CfxgPFDt5rIhKt6QgNeq3jOppuTziCYBobHxedyelwgQgG6JuaECWSVB37WD96l7ROyS9R/Q4inwmaxD7HmqFVbWAibonrFnk2kmL13fwVD+Ax9PfrzrQ7HoeN1esbIpjVrJzl7AoI6laSHqFRrbWpsNfXGEC9XiUAQiiv9PTeIXXX5/ohh+s5747vPx80C6NFs+qffsy6Hmb2vEXX+k4VuNSaOYSvMKSPlRiyWIpGroWZ+Q/KgYGnhsJvRE08tV/mrvqq2pImzU6HyEhFl+chR/agLyhrn69mahmsDZL
 mRSDLX2I
 S6AYYi7mtviMPHwHyb7VPpIgfnG1sO6gYzJgDBnQJqzNLxORb787rcmUXyn3iYw+6r5yc6JzGgN/u2h4B66sal6V+gtXHw94ye7Tol7JEEVQ8YcXCQt1ZFO4CGyVYjkiDiqsvRkx9aqzhUzQJWSPYFRlC8WGI4/FGno7AwmRDGaqcwFGkw77sl6iXAuQEPh9ISug6SXoGOZh88d33vsmxpColFwxlajP9V+VECiBqquqDBGKETNu5Mgws8O+YbnfJk4y76IOvp/Ulc0p8PMDPgvbmfsUmaWbTchJmFS/JfcbeQAn0x+ysxmMPJy/vBDIOU8/Ro6c9eQM5xV4C0FNWRtQJz4RbWq8BJEZHOMuOwW7bBkmMhTXLusMnxNlJVOfo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in afs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/afs/dir.c        | 10 +++++-----
 fs/afs/dir_search.c |  2 +-
 fs/afs/dynroot.c    |  2 +-
 fs/afs/inode.c      |  2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 52accf0a8d9d2e4dfdff444080683d5ab16d8e69..aaaa55878ffd28691777668261f577d7a9472d6d 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -148,7 +148,7 @@ static bool afs_dir_check_block(struct afs_vnode *dvnode, size_t progress,
 				union afs_xdr_dir_block *block)
 {
 	if (block->hdr.magic != AFS_DIR_MAGIC) {
-		pr_warn("%s(%" PRIino "x): [%zx] bad magic %04x\n",
+		pr_warn("%s(%llx): [%zx] bad magic %04x\n",
 		       __func__, dvnode->netfs.inode.i_ino,
 		       progress, ntohs(block->hdr.magic));
 		trace_afs_dir_check_failed(dvnode, progress);
@@ -214,7 +214,7 @@ static int afs_dir_check(struct afs_vnode *dvnode)
  */
 static int afs_dir_open(struct inode *inode, struct file *file)
 {
-	_enter("{%" PRIino "u}", inode->i_ino);
+	_enter("{%llu}", inode->i_ino);
 
 	BUILD_BUG_ON(sizeof(union afs_xdr_dir_block) != 2048);
 	BUILD_BUG_ON(sizeof(union afs_xdr_dirent) != 32);
@@ -523,7 +523,7 @@ static int afs_dir_iterate(struct inode *dir, struct dir_context *ctx,
 	int retry_limit = 100;
 	int ret;
 
-	_enter("{%" PRIino "u},%llx,,", dir->i_ino, ctx->pos);
+	_enter("{%llu},%llx,,", dir->i_ino, ctx->pos);
 
 	do {
 		if (--retry_limit < 0) {
@@ -610,7 +610,7 @@ static int afs_do_lookup_one(struct inode *dir, const struct qstr *name,
 	};
 	int ret;
 
-	_enter("{%" PRIino "u},{%.*s},", dir->i_ino, name->len, name->name);
+	_enter("{%llu},{%.*s},", dir->i_ino, name->len, name->name);
 
 	/* search the directory */
 	ret = afs_dir_iterate(dir, &cookie.ctx, NULL, _dir_version);
@@ -783,7 +783,7 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry)
 	long ret;
 	int i;
 
-	_enter("{%" PRIino "u},%p{%pd},", dir->i_ino, dentry, dentry);
+	_enter("{%llu},%p{%pd},", dir->i_ino, dentry, dentry);
 
 	cookie = kzalloc_obj(struct afs_lookup_cookie);
 	if (!cookie)
diff --git a/fs/afs/dir_search.c b/fs/afs/dir_search.c
index 903cefd81f3f2ccbdb28264b5e99151f5a54d1ce..104411c0692f570a217d8f0e6fd35818eaa02932 100644
--- a/fs/afs/dir_search.c
+++ b/fs/afs/dir_search.c
@@ -194,7 +194,7 @@ int afs_dir_search(struct afs_vnode *dvnode, const struct qstr *name,
 	struct afs_dir_iter iter = { .dvnode = dvnode, };
 	int ret, retry_limit = 3;
 
-	_enter("{%" PRIino "u},,,", dvnode->netfs.inode.i_ino);
+	_enter("{%llu},,,", dvnode->netfs.inode.i_ino);
 
 	if (!afs_dir_init_iter(&iter, name))
 		return -ENOENT;
diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index 448083d79c3d0d2f29934e105f48d617330de8b4..1d5e33bc750224d063446ea952d5ef97a2481010 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -59,7 +59,7 @@ static struct inode *afs_iget_pseudo_dir(struct super_block *sb, ino_t ino)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	_debug("GOT INODE %p { ino=%" PRIino "u, vl=%llx, vn=%llx, u=%x }",
+	_debug("GOT INODE %p { ino=%llu, vl=%llx, vn=%llx, u=%x }",
 	       inode, inode->i_ino, fid.vid, fid.vnode, fid.unique);
 
 	vnode = AFS_FS_I(inode);
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index a0261c2c246a379689cbaa44b7ec456f1a986142..a5173434f7862e92a127994c56b89f530ad4c298 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -683,7 +683,7 @@ int afs_getattr(struct mnt_idmap *idmap, const struct path *path,
 	struct key *key;
 	int ret, seq;
 
-	_enter("{ ino=%" PRIino "u v=%u }", inode->i_ino, inode->i_generation);
+	_enter("{ ino=%llu v=%u }", inode->i_ino, inode->i_generation);
 
 	if (vnode->volume &&
 	    !(query_flags & AT_STATX_DONT_SYNC) &&

-- 
2.53.0


