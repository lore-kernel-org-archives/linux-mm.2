Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 347F3EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E2F6B0136; Mon,  2 Mar 2026 15:45:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93AC96B0138; Mon,  2 Mar 2026 15:45:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1BB6B0139; Mon,  2 Mar 2026 15:45:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1C16B0136
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:45:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18FB81A0311
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:45:53 +0000 (UTC)
X-FDA: 84502304586.10.470147C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 643F440005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:45:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nXSuM6cR;
	spf=pass (imf11.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ts/fmlT4bjjgqy5Gc20Au0Fvwpz1fxgRd3vfVJgyhC8=;
	b=086nfLRUvNzl/DySzoX8Ku3zMHZp+OXSQ1N5G3ms6fbBVfChelhlAvsa/8M1XWKS9VXhlA
	oawyQwquISNwm9R7IVEECq26VTR8mY0YGjCuWzY6t0iQruujbr9xG1Fo6Aa4Ulne+2sufi
	LSjrBpkzrEIOsGDu1hpYjc6ZLxoWuIY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484351; a=rsa-sha256;
	cv=none;
	b=6tnCIklo2hA1oQDeR1UKbdJEeAr1Jvdh6Qy89GCxHZN1SsurrSVKQKhgt9d8YsQZRRxUvq
	uBDv4FXuJYR8YHIx8waRn7j8hIL5MMHWN+LClVWwaEOmYPJjAmClDlYXqbWxPj8DRCGGLc
	AtKZModA9MQmLGAnDOoBlO3l97zgQLY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nXSuM6cR;
	spf=pass (imf11.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71897418F7;
	Mon,  2 Mar 2026 20:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C547C2BC87;
	Mon,  2 Mar 2026 20:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484350;
	bh=7Yaqcvybh/+pWSp1blOqkW5oyFHsnJR2av48Tn6jnLc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nXSuM6cRhWdFTIU+hMmsLRYCX1vJ/QVNZgjUVeDUVAQ0g3JY2lxvUILaJao43J3kT
	 sRkXNwWAxvtwAX9KcRKoX9U/e3H4NCyU1StJSBlnjx0BCtP+L1fhLpqMMnw8V/wyks
	 RKdHHAS1N2b8WNX4fPf1Dd4e6j6/C5cylUfidJ33oKLNTcZ+hISHpLhNHLONdrQIEW
	 I6SHbzLJHnY93Fu8gTWHjpc2W+D/vs4qzIRaeRQnBVEu9PFnrQKgP25gOUFXkg1IWV
	 7fZiX0CFTAfk87fhAw+VEtIVkc15wB6uQ7Fxys52W3ZeyrzQykBn4xmX5tM1IpJAu0
	 qxiPTiowROnog==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:11 -0500
Subject: [PATCH v2 087/110] isofs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-87-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3540; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=7Yaqcvybh/+pWSp1blOqkW5oyFHsnJR2av48Tn6jnLc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIHSlmbS586IDrOOOEqQZtQI/Z2+zAR5lHJd
 78usd0crveJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyBwAKCRAADmhBGVaC
 FVD8EACNshWBBeX04wM44HuTFupoTtw6nDoXa5sxvVoQw3ZqUVhTZcysodTV4o7fBAafvTADc2M
 453eWiBpQO3xZ0J+c9wnS8Jt29iGen6P1BpCm73AGV14xG6xWfxmSwPHLM1JrivyqoxZKYiC1sO
 hU7DEIPdbTIH3X83w7VOet9XzHnlCmAZpd/+F0VRTsa5dZndOzT+YBRIvCx27APYMwmC7Icv9XQ
 lwPeqcMzseE2kggAa1yu5/PvA6VhzWQDC5LPOqZECQFupxF4AvskTIeaQSz6hYo1UNxcBUy2QFD
 glWJF5l4mIUgJQyPidLRm4uOwlnM/OMN/VCwgLqFDoiOAKaGZdH4zQgBFitJ1gAY4o5BOWTZ++v
 0LJpO0II7noEnl3UdbkGww36amRn99U3qifqGRSVuKwA5nfnFWjqHO+vL4rn7oE+KCccl1XpGHY
 qLeW98RKpdCaF5QuR70By4fIg24w/VKB9yKRE7JmbczXXRI33LsoP2nVLz0Nf0lgkBwBE9IndOg
 gqP2Zx1J1UEo66s7sAiu+v1DTidPgC+jrEM2IWZYCAFc9MY1Ki3veP956T36zVCISOKz+hydm6H
 1A3sm4SxqrspBa7d0cvcUNA0OZbVbslphQZyN2RC42GndLkYgjqpKpWNTkfP1Puwe9OP7VHpUnH
 KkgktuBEm1G8yBw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: burup4uo7adiujj6zju1xhgj7s7uh4gi
X-Rspam-User: 
X-Rspamd-Queue-Id: 643F440005
X-Rspamd-Server: rspam12
X-HE-Tag: 1772484351-928058
X-HE-Meta: U2FsdGVkX18tHa0FFhE5cqW5MEtQ1xzvKbDVsbeKuH59zwgxl5jf5ke+tgqk25vKDwHYncaYTttEAc8lHOyU8LocGX/kkaHlpsZBzzYYiVnkXlF8RDSkROCwTbk6mBJCnNz8TESSh1vrTCjU3MV9PY60ke/E9PHetKjS/5+Wh40Z8hthqkt7hE5/kSquMemVEcibt8267hZGiABa731bqo+0qmxPFMuc6U3VSUBOwq0CN7Phkd0gtsxY8BjN7pMCx4f5M9ozyqjnK/eblgpSl0p4gGfJqklPZybJSsgNFxXmKztNsc6+bsbBJ1WekG8G+04VBzuO7g0LBcR+vrmRNJrOEot9nfC6cg9AOwq49lHapnVFlxgWREU3+9WgMvqQnRBWRyIEtbOjbHFg/gKm+iVPAubl5mFZltbgoIZQhifZwCWwNUBnEFPlt+F5ee+FqF/DZ8nnTUZ3fQ2XijM4xn5sreSltd5oU5zTKRIBW54vkz6oUgVeUJnBaSpv3CKxIDg/d03nB8nkHmbQg/JhGX6NlyCFlKnRt8yBb71dZzgMsWIcxBXaaRs4LgiEDV9+8eOyMY0sZW2NQAO5I914/A701f5aqtpsH+ZfUB0+NwDzpPfYpxboYoxcL5U2nzTTqzP/0Oj/wujnocGRxsptsve48dA5K+cPUCN0t/izTYCuKhOkcbwFXenU0V4iT6x/waNhx1HOzVbrf+hgZlyGSVsYBYGkDKr1/Iz9IxZ7PGOl1H75PuPPBVSN6ARq6F6dtQ/T7+p4/vyFSkuW6Blgj7glS+eoSJl9BYnspMPxD5kdLjuwS32HDcUZuOhAazsK5Xl6imX5RAkulD/jRqg1dpe4xmKEKMF3Asblt8NsCwKsdwlS8tre5qznZ84H3J1sRF7KnY9PKngrZ1IY6nLFSQ91VQ+Uce7R6CeFi2nj4uZ0FhywWfdLmcvW3J0+KFfxAS4F9JSRAWLoyIg4asv
 xvNzsnsF
 Bv+aLHasSli9KeHepXFPZqABqUp8Z81KNg8WdwEzx0yd66iOGutE3xNc3vsoqGMBPTBP4sRo+HD+mINBIFCPcuH6XGr94D2pQhODzTHhbICAFv0kjadcqOHkShGDLfjCctQlyCa3K8V73cafSewrXEUkqIWoGw1tMwx+Vfo+gQ6f+lLu6MPC9DPGWPFZvq0nwpoarZMvfVgGrkTk23jf5H+jOPeJPd6UFd72DeFtOt/2NCMAODX+qTOBpNfv+qZziHA2va1TkN35jOsxzmMdNjwuEbF0D9Pgj6aMK8R+04P2M9lwAnh696nc+Lo0T8E4zDIsXFh7NnE+9KM9Do1MpeKwiJ5RqlyJVrNuzJUf5ugRbU3NWxV+0fG31MXPtlDNa9YiLe9iD3dicCgjRBD17IuZ8bmK9u3ZPPQ5goh80fQriVqACTbFbkyPXKP1tsGE4L4UPSkmiLdtcegaOv7k3X1xjS5/8hYNcfhb9RX9fG/zgdXGzEqYLTWTL83CjP4MwLsH6R2Ll51SBdeCBkagvI2oEY4wrXcmz8zeJyU91NCrG0lK2eumGbnLv6qpdpS2CD7Ylr6bFnU783FO/bNeh8sLggBLfgcvpNZvvjgaFkSUaZnVLs+IQzFyFbrrInnat0bhN4o4h8Yu6S/2fediM7fs+Dt8gnd1X9lJQIgwdCVMpFWJ4sBn9vHRZXFkYDU+o2KnRcJXZHk0i58O6eNix/UdlTR56LJe9KP08sDvrffW7TEEhgf3vcwxszIkWBs4IyqxIdG/rzFg6g07PUH4856TeGrEd62RNYeVqVkZS78HyId169FSM2e+pH7VlZ56sQpbcz4EzJPjX2TF22EekPgP9cn/B0AECAFMW2MRi165tZzdyLMq6qm2FfVL4y3wqxsdu+foorU0CtXng5fqn5LWQzI9zb5fc7pUJ+OH1O/8Ujt4UYMwuDDByhx6k2G98lzVInIpOOa/UrHtYKh56a2Rtl1Ws
 TMIqLT4y
 DTlIlNS4wixti3snPW7G86gXns1Ox9YSnERjfb40fa3gUebbij9ZmB53ueS9jIiY6Gpxy32Kg/OZLnphcWy1Xf4zNZbfxhs8D9k4YBVaBUUYCvxDDN1LUCDSdechH+NMILc4Gb2yykWHJv6m9BtpRGYmUR/kMfbCmyTVM2Hv0OG/MPQ51dV8hYSc4wemwRaGSFY6jjNf/RsHDWMV6sks59z0s3MK0LxCC6bNSmVwxSDjgXxpiAEk1k2OyL1XtEuUfeaxyy0BAuLjYSuLN+KiayaP3wRxcUAJW2VzUaiF1UTSFoQnuBXmp/riYtxg8BPpn1hAkz0a9ijfIlTGbZlMFIkfcm8wY1DfUNduUmRqmzlfh0C+JSFqknWWhdIk5fucVyw7ZR9tqjYmDd80Aj71j5ualx5/xTaowYNjQm+5rVjlBsEAxjRBCVvz6yEVgF9mQB7v+pUvNuEptnPDyk2ksV78IQq3gFbD3d8IQkepiyF/guATs3mloLG4a97LCDOHAaD975ts546fjPuGbawLTxJ07ekcOZCTS5dPg8GpGto6k2JsY3ytv2jU+aYbrXqrv9bD3uPs25Oaz/JNN/6ufvrufIRV05gC+lxThPao+Jxt9iI2ug6tTHKRCur7Yl2/+8tJEpklyebdhFA20QIoz7mkHCoxOUXd4p8gu9bZVURZkpSWiksbQR89ewiMGv9jusv3qjU4ZapP0NvY/XpDaq0M3AMZ3noExTfDTBIyMpm8NfhO/Yt5fqQk01V7syPTDtE3IIoPHRyL20V6KG0uK2cGCAB9/DZAMpKfDxQdWw4PppuwioMILzA9YccbdbYvD4Lwq/JN5Ec/C2eKYTMWCGgFlmBrIG0aYdKMBqVLyBvHDCrBCzDags8dLftmOgccgGH5gVFQu/1ZEVbvnymuVvF/kDCL2IGQEv9K+EOwWF7sbnxiINuDPmjsHGEMrxWvouWeRRUCs6JqJHD67fBeAvPJgF0pe
 DmdKCJSd
 NTotemwVlByZOVfCtXPXit+sHy8zklvIjLVygvAWywR6lzT8pVzNaJRyCDmeEr9bz1hrlY1v0FS3OiAcYqExJ1ur7oROZSbrFr7qNdqfSSwPSZO64tKYqJV26GFv18JL4ldQkXoOKF7kF8BlklEim6cK6gesYlXMM+8Eompsa3uK3KusYmKaDBnZ++ul3jWbhIBQouRaxJgNRSDg8rFTEzLEepVQlE4LlVmknbQ4Sbw1N0OT29y9r8iL0dSzgnKQ7xn3zMFZNoAOpjP1MWTFj4z75WuEALvP2BSFHPRIbMOhikWsqzz1n5nChyJNUf40/VmCdKgFtzZ2GfYLC/lUp8EJYSq1hMWZj9XGl9+ohcgFtggzBMnrIrlmHbJ45hk9c+g5EDhEso/KhWr3vTXc34OLBi+egLp8iW0LvOGVKmwXuYEhTiDClK5a+jvQh+jh5dmA6ph2on+SsD1doBFGD7DC5iF0OUUXj1cUFjtutpBHMkvjKjwlP/jmiGlLy6cd09C3pKemkPLrT4Fm/K1qphTWlF70yDDgqqeEPj0MiFGx11brvk6fdXrT2Hr96J256ATdixUibed+peI5Gx80kz0JgvxZ8SMwYYKgnWa90dzEzZkEQS8rEe6diIq5OCPntmc9avsda07sOm1jM8LnTX+HCA0Bu4aQ/RCkLF3Yw6BA/ySuCTolJuvxkct6kh3A9heDbUbIJL75yUQ8quZCnJCQdyRhjJriH05pzy/NgzD0sgs66MIQS7fhW8+GgkH/u+y49+Y76rfve9pIWSHmj4C0ckWYzaAFRFl3SvMYu0mZJpewvNcrpVoAkSRH1WMwMYsRrgGWLp0a/8SCa3ZCeVsIw8tuwcEAsdAE0rhev+xCNDAp3Tr0EgE3O/bFB/eFRobGhAIJcy+gJzgNFYuN79y74JQSfFamiFaafiIhNQtn2m4hgoG9vlVhNfPwyXrUKl29ggLYGNzMQzg6VPjQ9tvcu53MY
 F38CKFrR
 Y7FsNRLTQ4nwTDtpO3wW16
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in isofs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/isofs/compress.c | 2 +-
 fs/isofs/dir.c      | 2 +-
 fs/isofs/inode.c    | 6 +++---
 fs/isofs/namei.c    | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index dc6c7d247cf880720be47cd26d23206d25a4e453..397568b9c7e7d3e28873be02c8a4befcddaec7b5 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -156,7 +156,7 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
 				else {
 					printk(KERN_DEBUG
 					       "zisofs: zisofs_inflate returned"
-					       " %d, inode = %" PRIino "u,"
+					       " %d, inode = %llu,"
 					       " page idx = %d, bh idx = %d,"
 					       " avail_in = %ld,"
 					       " avail_out = %ld\n",
diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index 0a8f9e411c23425a6919b7a4fa3fb387eb2c3209..2fd9948d606e9c92f3003bfbaa4f0271c750a93d 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -152,7 +152,7 @@ static int do_isofs_readdir(struct inode *inode, struct file *file,
 		    de_len < de->name_len[0] +
 					sizeof(struct iso_directory_record)) {
 			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
-			       " in block %lu of inode %" PRIino "u\n", block,
+			       " in block %lu of inode %llu\n", block,
 			       inode->i_ino);
 			brelse(bh);
 			return -EIO;
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 678d7363e157d893e005152e64e922d9170468d0..3593e02e75fef8567643137e0ff992019d2b6fbb 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1261,7 +1261,7 @@ static int isofs_read_level3_size(struct inode *inode)
 
 out_toomany:
 	printk(KERN_INFO "%s: More than 100 file sections ?!?, aborting...\n"
-		"isofs_read_level3_size: inode=%" PRIino "u\n",
+		"isofs_read_level3_size: inode=%llu\n",
 		__func__, inode->i_ino);
 	goto out;
 }
@@ -1380,7 +1380,7 @@ static int isofs_read_inode(struct inode *inode, int relocated)
 	/* I have no idea what file_unit_size is used for, so
 	   we will flag it for now */
 	if (de->file_unit_size[0] != 0) {
-		printk(KERN_DEBUG "ISOFS: File unit size != 0 for ISO file (%" PRIino "u).\n",
+		printk(KERN_DEBUG "ISOFS: File unit size != 0 for ISO file (%llu).\n",
 			inode->i_ino);
 	}
 
@@ -1450,7 +1450,7 @@ static int isofs_read_inode(struct inode *inode, int relocated)
 		/* XXX - parse_rock_ridge_inode() had already set i_rdev. */
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 	} else {
-		printk(KERN_DEBUG "ISOFS: Invalid file type 0%04o for inode %" PRIino "u.\n",
+		printk(KERN_DEBUG "ISOFS: Invalid file type 0%04o for inode %llu.\n",
 			inode->i_mode, inode->i_ino);
 		ret = -EIO;
 		goto fail;
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index 494d2ae4c0955123335a97f23672b959dcc9e0bd..8dd3911717e0cc221f60fb6447e1bf26cc2223dd 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -100,7 +100,7 @@ isofs_find_entry(struct inode *dir, struct dentry *dentry,
 		/* Basic sanity check, whether name doesn't exceed dir entry */
 		if (de_len < dlen + sizeof(struct iso_directory_record)) {
 			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
-			       " in block %lu of inode %" PRIino "u\n", block,
+			       " in block %lu of inode %llu\n", block,
 			       dir->i_ino);
 			brelse(bh);
 			return 0;

-- 
2.53.0


