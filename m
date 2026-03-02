Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C15BEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B165F6B00BA; Mon,  2 Mar 2026 15:30:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAEEB6B00BC; Mon,  2 Mar 2026 15:30:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959846B00BD; Mon,  2 Mar 2026 15:30:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB516B00BA
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:30:20 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5114613A7B9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:30:20 +0000 (UTC)
X-FDA: 84502265400.28.4D77B28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7DCBBC0006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:30:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j4Q0pC9g;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KpKfaRNZ5wYjQtfVgj9AKFtGAgHK5uZkRyZ2seBYiU=;
	b=ixc5FVq6aUmGemNdy82U7IMEjqtIH7QzWQbuqABQkWyp+lA8vHSOiICjirAIgfAGY4dfDB
	wFveXe+x5dsAawRSGWQBqKLKlu2kSEW5LVpSB9Kw1PdJw8F0nSo84m4SBQ4r0+U5Y/xFy4
	DrDoI7kYWJAuOtc80W7r2fjFQlX1Htk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483418; a=rsa-sha256;
	cv=none;
	b=uSgayYjCPXfIsAgHAW51tl6uL5GA22cFx7/FafFxI53Qclzs4j7dsNzBwyt6YcqdAaZV7n
	r2O6OdxqF/dT7ZwivHH6ukwoXPsfbfXdb/QBGp5ahFI4Ne9i5v6QZnb1sNXsSB5TAwiMhp
	v+HICb1hMyOblaflho3hCpJHQOazBXw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j4Q0pC9g;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B5A5961118;
	Mon,  2 Mar 2026 20:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3952DC2BCB2;
	Mon,  2 Mar 2026 20:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483417;
	bh=SFRV06+LrpGHyP+DQJTOgjuew1xPKXuf8ELCQbvFgSw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=j4Q0pC9gVLX/GuwL7w/ffoGxBSP7RPq+NpPeuKosbD6Ck2Gau/xQeD4N8u/naDEfg
	 sQvcWEs62tYZz1Og6NpqphRwz7cEYCfdKIKPrjOotUTkt3XZhHEwi/2iG912xqPECA
	 7YMNOiIX+IghztcKyWE7Ox/VLOKYNqsl7Rsk8r9ufWjVVx6E/HxKBo2GjSiifNcZO4
	 ietEPmuzEpsEPHkaC7xO+bNI/vdAUkDAuAuVRxSyT1gJUTSRzevU77MTueOLTV7YVl
	 kY7/Mvx1lXjTk92Cl5v04JlNgyEnC26cdENhAS0zGOG9gxP2feZIqQD2OjFTyOXtxA
	 RoeIwgF10gexQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:06 -0500
Subject: [PATCH v2 022/110] cachefiles: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-22-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4457; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=SFRV06+LrpGHyP+DQJTOgjuew1xPKXuf8ELCQbvFgSw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH1W0urNlOitGlDcMkogI9SpWyxFPxip32Cx
 0CQBjKPBryJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9QAKCRAADmhBGVaC
 Fa4nEACgU9mb4glul3V7gbaPmMmo0AVe5vpRFRnW3696SkbgSJ0VBjlh5PZmnldNvzfjR8agjgC
 blt9LYwfP104fdmxdFml5BhFoIICV/xdU/ZyqeJkY47XmrEU5i4i5TxfUk09rsNI7IYdHEhvlrs
 yxbfR83D5O9puMDcxFZK5FzMN08g6gq5jd8Sm02cpZH6PeQ/q6gGjDTlsD3V7cGbunZE0XTPUd1
 P68x0C+ZLSqEg1xDgLoI0TElMvVIrEixULTNgmd0kgC5jlBlesUvYw3366GeftrljvSKHhWmApN
 TNwJ/vPHrrrNk7im2W0S+Avn0l94NtR8AJryn1v3iznfSFcQEUPbVetlK2xQDcFGAEuTndnYEXz
 dBEU7aqaV0M+0jegI910gHVLl6bxFEtpLOa1Dzhj04T8Zpy8DA7L3OAesSYO1O/UZaslux7SR5o
 18Yveno33NG/TnVYsZT3yLBEhatWz/zjHJexQnXLaHGNgAbKlBtxpBNXbBxPeJ69/LVKYCLXJAS
 0jHnDr+/6Fwt6q4ZNad4+cN6/v5ijaB83K1rkncF1nwi7Hv7rTPP0nnbHRQ7SebPbfMyP6vpezH
 zgm/wh5VFkMEEGaDIOaVnyq+jjB1YsDsMP8aOsxwA4sgn3ksKF1jwyvsyoe1fPWmuY9FbmOuRyy
 Q9ROlaQrf2RDRXA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: eq8x1t6e97o3cfzedeoibb1h4nbqm7sn
X-Rspamd-Queue-Id: 7DCBBC0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1772483418-482279
X-HE-Meta: U2FsdGVkX19J2qXWnO165MkHST5lidgvdaoADjCmmlPGnOU1SMdEm3pO6b3a2eN6NeLDAIPSGTxSwNIjwm7Lk64QbL8B/YmChnlhuO0y0SDl1oeKSDEV9nm6bbDVEmTrE/tnW3kE9I3E/or1rRDBYNF4nL5U0gXS+RLs9EnaZ727pf1xPtFJX/UCRzamoJ1yeWDjxex/H1xMUk2su7F0ALuqcKx7Bs/cc68Cy8FUmg2CX00kQaInhu6dnEb/d1L2GJLNUVtlUMCFkfEejK6ufeFUjtAQ4saaybbECxvXUHHVHMcecZZ3dI/dDbI0zBLtL6tmEoYs9+0iifesmTZYFqLqDv3X5e83c/TNNItZ1ckUpV6fH8unNJwIUyYA14ogqlOb6LJw14+xWwFBGJZ+aXAB+oIQT1nMameDO3e4E9Zz1EzsddI6NJUqq9yxmtJiQkCDvS+pqCSu6enJFSetxEEFI+JO510G75qqTJR5vqcNVP61hQccajHHWISkPa5qwuZh0jXDPks8+bLoUX6CLILoMKUHiwrTrk1afr3w8baehWWxeEoxaPZpeBIgFg/yZItNmPy9xNpVUN55HQ51ZCYJyMIq8wMvQ87jEfV2GoARFQLN0rSxZMpoaoCCVQLt3/L4azuo9IWKj9yBfKpmww/DN6gw/g9qjidZxy761j3VSBp+H0eo1DOLFFROXXWKu42z0NcVn/dV1zwjrptbzovrslFUf4jzogrgOOP6OoW0tcmBETLQcZQE6HlbkZShBm3Kr3VbPzJ7OghcbrMUgwTG3QlPiJfKGTbXH0cXIpFhdtaCsuOuCFCJ+a3zCpSbA/srYe39zquLL7PF26LI2TPXLV+RptzThcHiKMKpRlpuGfk5A3KDR813nylPx2N/dH3QtYEP75pcdh53UyI4h4jrzrOhaaeZT7dsiUDjaTUXfWmu3U5vKr4/L51u7LcRCmrtYEQVxeAx9K2UFCH
 JrIzEIqh
 hvwnKM9m5zfCq3mu17MAGOW3IPv0eBjKq4JdsI14KjitJA0xa/hcTEy1rcilHej6ANegzl8M9PZtn7ClFllSXBXfty4YA23zYLMwz3/tsD7HfzIydoXQnjpqp9erMjQgx3RogR/NDnjU7tnqkTXm4ixlds7HGgmK5Kt61flo8XjATdGGQHpl1XcVhJfhOcWujRH4Dfo1Z4AVV83yCaVOqe98SmzN+z8GxaAeK6uZVyQRy1VgNF6NMmzxKmf9piXnybE75fdw3t30Q/ECZm22c8ShkSu5EJ7CY5yUzEbVLrsA9WgD8QV4CXLY4bREENTmzu+8n3jiQHcVkM+QBbYY3YB+KzHwjc3YGQ+b6M4Pwpi0eEGv85v9GlmVzxbQfgIe6sZXuVjt/4ULdS3jqykVB9Skqra5E2Gmkhv6B81nizEMO1B8a+ibEuU55WFsvacPBdGssV7My0i+HZdqWv15uT7Cbg9uEwusa+T5qJifQSyafbrb8WJBPTz5AinleftHybj4QmcroDyjegXR0Az5HIU78rUXCXNP2BjSvnPg56bEXmZFKApgVHGHY4km1qWCP0tXtFqS9NTAVU/+R6Y1hC1zkrFp9bOzHJbQ1xiR9bW+FOzkLWIlr+p/OPWwZZDMYhOQ7liqkMicRyVt/aFHPCoKbzz7cZ03K1/t6dlFIeEVXAa3Hlc9oQh+MDxl0J/rmVQHmfO9N5h8XuTVJPhESZeLwABTh2mQRq7WI+v/Jc0ubh/tOY07/Tb0a50jo5F938YgIA6zPJsSAhuOKxyWuIqA/1fmisfBziei7s7yAjf0I9XnVvTDfD612al+T8H4GKugx/Chy7B0PBUHT6isiI/Sg+5A5jvsAdcOsLj4WdTULNGuZ5tPB//EGBy8NQFMV1TyeUcucVgUV1uC7ao+kxGvbbhqKwxb7oqRVM0QOGK5HrsEzZqxE5uN1Q/jGbAeAK512gK4OaoJ8ZD/WHRmaM59a5ZmI
 aEUPRc3p
 4s0/Q5hPxoIiaPBEZb6sY0b13HaSppHxwp+jT2evRTzKP2WbDxANvcQpvmNKRGrc7NcsU07qcdt2zUrEl9BzrzOh20oW/BMFD5cA54LbjGFtqQR81HU5nw76V9qYT/lyEniE3/vp88EvfFVA8jRzPsmRG1S3a8r1ec+R/Ol9lzHWB33u4kESGOjySm+QzhKsrOhuP3kX/wqJDXuAqV/NgtWNehlXFL7HxnJSz06acfdeuT3tEO/LJLrQzWzTdlDzt6A8WHmtGW7ZTTl959zVFPVhB2IflVISynbgnWNqXxkZ4OaYJRFbpNuHs6NRJB2//fwTFZtYwS3orr4pBjhrBRsXSePXPCFs9BMN/z4U9fy9Y/GP39R3TfflWpt7d4V1ckyT90sp0+WCJGwnTVBoyb7700m4DA0Qj958cHuHnxbmw+mARY6kjgtiQnLLij4Am+iuWH3TmHNIbciGcjPBpyetjjE+s+G9jsB906viwyHWHh1F3oB3GNm+JFIKXgIrd3kSdeMHUwbhcUuI1M1VjL4b6rIm50gw2pgeQmikbsS3sVE+cGiCcHiC6JmRi2AhcIZcgF83tPSmIfGH2djXiKTAzp8Ua3XJPgeXDLgnubuSYbd8MikmR3aekDPPVO72tk4/7F/k62QzwuH6uSl6NuV/tZnk/wmZ8BH+D1dz0+vKLt0zl2e2KLzmB4IjhIY/K5GYnWiJCCGcnPsovgxIPJITVHrS9jsrbk6Fjz1m32Zry894nDgu9Nft1zUqPi0mZJofOZOuvn2MLzh1EByuMYxwSUUs2HE4LJ5BS/HNmsET0Tls7EiEaidaeNH5szTvykLzhS5mDQxtAIVjbKMYGjll7Skcd+FX7zmK0OUwoWSaiTQ61ad3N8mujpioTbAtPaRCiVQaWqDzNUXmkStvv7m4uraspFFwWGBvXlo+b+OlGBSMFmQxmJ1wD8QIQ/8oGdPrBLQrzI/MoLPzwDHU/ve2lTS5/
 DLgJYSRS
 ZOjrQHud/yu+EVehSXC8RNSoJey7acGptOvUz3p3vrkWLlQ0pMhvGAXe6H3/vuZUExuujAxSzDK6rdeW/gFI2cPT+t0UiSJozp+z/WCzpy/Wr2y7keecVo2UqLjX/oCN4bKfFbgNUhFZSBof9HZFkIrBFJXyEguBr533Z6dO+JMIn5YKufyDJ406GYCYKs8aT/KE9oR0O8Db3u/gU+LyG0jioFxQ7totzk7dQjguSdFeMmiywpb1JkZU+8OJBsBnDbaCt5os/40y8NfhOPYkCwS1C0Egb3IIOmjqgbHxMD8lQLrgAQ60kBoZOb/LpWNzvvob6iiC5RYyiqhGHEwIztAV6JKVyt0ICAWuqder3Ox6aQq/4G1tI4sbGRv6+wPtEhs6oqNDGn9cciNxQ7SipcnFTd9eaSqvnymlxgodxtkvTYsQXLm5YiPaX+HkGnGC9mrSMQVHtmt5cjODaNGvsCFiA/T+BJjlODNimJ0OgpLwX7kbzUr8UT/ZXKCqr6wWFf/Nv1q922cFRVJgJB17hcrUQ2jdLBRaPoI2htIE8HcEVFcjf1RPEUiW/oh9vpbuRseQJWYNmiVvExQVcu3fXgvhvvVjlmGn/zjsbbSqDW2WlkO6/uLhuxQkkQ4HNlp1wUtio8XootTW3iBAl3LcqzoIER0SDgyucWk6Vu2GULI+Qy95tan/dvQJBXKUsdBFve403LORr4boaQNFGHAGwH+OSB0tNfSxLEK3y/iVzcVEWDciYlRcGsu3CnNuhNgyf27UfKykDSfAx37U26xDzuuJXVGdVfUGiQ3r1uzheSBDR12FTXzu4NSUtF5qlNqG+mZB/KnvUg30k0NGCk467Mrn5btuXStdL+OoY0EtkPLZn+9UQ+xofDU45zTjxVN8u5K4YQwOdzA3RAscZJKEMfoE1R83/r0vNd7eXgEq3Nu5dEdklOhwMGcmvQRqN3zJJpquznC3ZwM0HLZ+38ncR9Wzjnc76
 iWAhSZVr
 NNyW6txw3yLtJHtCwkJXxJUpodPLJuFEmUQeW1ilaHy3HdDFiR9UQOfD196LV/ja7gx+W4bIWsAENsEuULR3MrSXystFkAGhCw4Sdt26z+loQLp4U2srEhNMd/W7hvIoJzyKQR0nqMkdGiG0FJgrPVeOVGdrTiKLOaDS2rexDCHUNJ1bkCrMbolVFxhRwwit6zOWnlCtbN8DIZEVp2rheEPVQS/3sBfp3+dzDbZH4/lkXrF/+9Z3M54SpLXjQrPfRnfdwpuquHPg2ffoMPciOWREoHKaqSoVycJ/sj+ch0cgaE4U3h8Y6pWTmWWSKhej8j/RPhGvcKYfJ2JGuCVE9deRTF1MxQxSIAExP9ENBES7lypQDLFZ775impmHY3t2yC7OkuCLo6VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert cachefiles i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/cachefiles/io.c    |  6 +++---
 fs/cachefiles/namei.c | 12 ++++++------
 fs/cachefiles/xattr.c |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/cachefiles/io.c b/fs/cachefiles/io.c
index eaf47851c65f4736a7a27f13c498028c7c8dd1b4..d879b80a0bedc95533ce05361ed8cb79c7ed3826 100644
--- a/fs/cachefiles/io.c
+++ b/fs/cachefiles/io.c
@@ -93,7 +93,7 @@ static int cachefiles_read(struct netfs_cache_resources *cres,
 	object = cachefiles_cres_object(cres);
 	file = cachefiles_cres_file(cres);
 
-	_enter("%pD,%li,%llx,%zx/%llx",
+	_enter("%pD,%llu,%llx,%zx/%llx",
 	       file, file_inode(file)->i_ino, start_pos, len,
 	       i_size_read(file_inode(file)));
 
@@ -214,7 +214,7 @@ static int cachefiles_query_occupancy(struct netfs_cache_resources *cres,
 	file = cachefiles_cres_file(cres);
 	granularity = max_t(size_t, object->volume->cache->bsize, granularity);
 
-	_enter("%pD,%li,%llx,%zx/%llx",
+	_enter("%pD,%llu,%llx,%zx/%llx",
 	       file, file_inode(file)->i_ino, start, len,
 	       i_size_read(file_inode(file)));
 
@@ -294,7 +294,7 @@ int __cachefiles_write(struct cachefiles_object *object,
 	fscache_count_write();
 	cache = object->volume->cache;
 
-	_enter("%pD,%li,%llx,%zx/%llx",
+	_enter("%pD,%llu,%llx,%zx/%llx",
 	       file, file_inode(file)->i_ino, start_pos, len,
 	       i_size_read(file_inode(file)));
 
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index e5ec90dccc27f71dc19219f7632f3e48eaf51545..ace111f29c6fa006b69a0808764b60a0074db229 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -147,7 +147,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 		}
 		ASSERT(d_backing_inode(subdir));
 
-		_debug("mkdir -> %pd{ino=%lu}",
+		_debug("mkdir -> %pd{ino=%" PRIino "u}",
 		       subdir, d_backing_inode(subdir)->i_ino);
 		if (_is_new)
 			*_is_new = true;
@@ -158,7 +158,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 	end_creating_keep(subdir);
 
 	if (!__cachefiles_mark_inode_in_use(NULL, d_inode(subdir))) {
-		pr_notice("cachefiles: Inode already in use: %pd (B=%lx)\n",
+		pr_notice("cachefiles: Inode already in use: %pd (B=%" PRIino "x)\n",
 			  subdir, d_inode(subdir)->i_ino);
 		goto mark_error;
 	}
@@ -183,7 +183,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 	    !d_backing_inode(subdir)->i_op->unlink)
 		goto check_error;
 
-	_leave(" = [%lu]", d_backing_inode(subdir)->i_ino);
+	_leave(" = [%" PRIino "u]", d_backing_inode(subdir)->i_ino);
 	return subdir;
 
 check_error:
@@ -529,7 +529,7 @@ static bool cachefiles_create_file(struct cachefiles_object *object)
 
 	set_bit(FSCACHE_COOKIE_NEEDS_UPDATE, &object->cookie->flags);
 	set_bit(CACHEFILES_OBJECT_USING_TMPFILE, &object->flags);
-	_debug("create -> %pD{ino=%lu}", file, file_inode(file)->i_ino);
+	_debug("create -> %pD{ino=%" PRIino "u}", file, file_inode(file)->i_ino);
 	object->file = file;
 	return true;
 }
@@ -549,7 +549,7 @@ static bool cachefiles_open_file(struct cachefiles_object *object,
 	_enter("%pd", dentry);
 
 	if (!cachefiles_mark_inode_in_use(object, d_inode(dentry))) {
-		pr_notice("cachefiles: Inode already in use: %pd (B=%lx)\n",
+		pr_notice("cachefiles: Inode already in use: %pd (B=%" PRIino "x)\n",
 			  dentry, d_inode(dentry)->i_ino);
 		return false;
 	}
@@ -657,7 +657,7 @@ bool cachefiles_look_up_object(struct cachefiles_object *object)
 	if (!ret)
 		return false;
 
-	_leave(" = t [%lu]", file_inode(object->file)->i_ino);
+	_leave(" = t [%" PRIino "u]", file_inode(object->file)->i_ino);
 	return true;
 
 new_file:
diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 52383b1d0ba63d4a09413177d8c0d841b5b5b43c..1cfeadc4f8f0b95ce861a2faf5b7b41b8156cf47 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -179,7 +179,7 @@ int cachefiles_remove_object_xattr(struct cachefiles_cache *cache,
 			ret = 0;
 		else if (ret != -ENOMEM)
 			cachefiles_io_error(cache,
-					    "Can't remove xattr from %lu"
+					    "Can't remove xattr from %" PRIino "u"
 					    " (error %d)",
 					    d_backing_inode(dentry)->i_ino, -ret);
 	}

-- 
2.53.0


