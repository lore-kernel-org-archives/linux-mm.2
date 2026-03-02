Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 496BFEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:41:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B100F6B0096; Mon,  2 Mar 2026 15:41:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9EC6B00DA; Mon,  2 Mar 2026 15:41:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A56D6B00E3; Mon,  2 Mar 2026 15:41:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5896B0096
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:41:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DDEC13A7B9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:41:06 +0000 (UTC)
X-FDA: 84502292532.13.3DB55A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 81D8740003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:41:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nsRQ0zb1;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bMxzqTPe9XfClXv/yADtYZQDyNt0qqjGT1kvEMNTVA0=;
	b=Uk9I2Eeeh1LfwAfYnx7OsLiOS5jmF0SgfEMoeS8aVmPFK7g+n8zuAVZ/rjWVt0WnFPlAXT
	7stmHV9EIU3rbf6KXXKlaBJsrmjAnB05RK39TDGDTrsn1FZeMquXc4c3o+UhkkdCioZJyv
	xZjAbTBMxi/g/x7UB+CZHBrVAzI1RCA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484064; a=rsa-sha256;
	cv=none;
	b=qMyZz/bihw9HM2uJfYt8JJ0GKstphhzEWI4B3S0Z7RAqdhYAuAfE7ys3n+YJeiYQRYjwuL
	PEoFSNvV6QL+znZfSfG4Owf0BmKu7taTJ9m/dg65SsclA0jpwbd0LWtoFM6lP1MiiwfQzp
	89p3Ye09yhWQuWXGJljicrGpHYPvnOc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nsRQ0zb1;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A217A43A6B;
	Mon,  2 Mar 2026 20:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEE7C2BCB9;
	Mon,  2 Mar 2026 20:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484063;
	bh=WWDsZMw+xAvkwDsc0kcWPVeKunXZFMVO799PmJoRNqM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nsRQ0zb1ab+ZkcZzz7r+YLKuwRK24aFsFKjgWA4FqQGqh4dZ8yFa/Djf4+GRwzYO3
	 Dmrby9nn7us83Wu4l9/uHZibESyh8J47JWQr0eVNZ+t+ZYgZZlgwcTZjR18/xniQdg
	 9GFSImETKoEqRuGXt0X1AGsdJsHvr1AQGIo66OojuqHIKlAdlXpOZuL2LE/3vBTexv
	 7xxyBEGmDtBwaC14K7iA9/5sfpdVZ+iTysYke3a2+8xRl9UX6SMGbF53LOpsfIprfx
	 p6xACfvAYCLtYWTpA8NrsvuLipLVjA4moAg6dQ9t0FQN1+My+OG439WexLgPEkb76z
	 +cZzBsaMbDNZw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:51 -0500
Subject: [PATCH v2 067/110] proc: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-67-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1739; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=WWDsZMw+xAvkwDsc0kcWPVeKunXZFMVO799PmJoRNqM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIB3Mqfx6DG7ZTBsjtQrYMLYe/Nl/Mvu66tj
 sUpsC41/jiJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyAQAKCRAADmhBGVaC
 FerzD/91JAKzoD5PVDImrNmj8PqJtg5HShblNDfRf4ROaIlaFt13tN/BOrz0SnQq63H+8q+VsNL
 rMevWMQM3T9oESfg5ka5s2M+zZyQV+KVX3XnnDO1WY3b6KPXs0whkV4/mPVUG5DnkeFk8WHPj6D
 4QW0ZBR4kAA+i9p1aDo210b6b8yVlGTLSyVkfffd30FshwQJZRBJnfCNncEK+s4133oJ2qemVVl
 juUMsuYyLNztqGCKg/wvQVlJNSzfQ12reYqlEqKbo8fLja06KpWxS/IFmhx8P6xfjSiMIOMu/N+
 RuqcXYlnpKzWFwEr1Ei5yMZkSemIbR5UAq+gO8W07YAcOJF1swBHK/Yd0VzM3tk123T2U5YL342
 ouYpQidGM+00icbnbO48hdQaA6Ta3Kx21wRp80jKnyJQOEfL2pV3Qj8UATOKl5z0sBUu3g/SNmo
 3GPC5WUCYgvUYG2z7RYd5eIS9k2lEkPxvkwEsDnqwQ/FfHzW+tqIyHrwJQh/JwRvInyNGXWQeod
 48gfWV56buVvcn/Gkw4ZNFC6e+L4HMyMc22XxyYbJ5P03zTtcoCxkA6AZMCcMgxN+d2+yNyt59c
 XulFUs6HcNiHkZC/RLHjley2OWDsXYScFR1zXhCEEYwm3l9MgJhFi/hB6CjAFVqgezk/xCV4U28
 HRTx/obS6b+0ESQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: dwid8h79jbcksckb4zmodztgy53cqyqc
X-Rspamd-Queue-Id: 81D8740003
X-Rspamd-Server: rspam03
X-HE-Tag: 1772484064-818163
X-HE-Meta: U2FsdGVkX1/37ZoK8ar+IdtCirNwMMUO69Wz+IO9MJrg57NayNAZDLevCN4HmrSf7ropUavxXIYDBBT/jXu+Gtyi7OXbJc84prrwtmuBG4lNC6DMUwkza1WKjd4Os25SRgFjI+XRB7vMXi5TJFGw5p94shFm1iI0zMO/acYjnzH5KNZ4so1Wh8AVoaaj6KPlORUIGDR55cpIGTlRwv6+SDhyHLeAXlBzCAgFoZvoWsVVLULHLl8xv+oZYDg8I+T7q98yP+tSYERFygH/1p5HI2Z/7nRlyzEpE5sjCsy0KWnItblyRVsf4gb48lGYRwGHnEOMP5cdsE4kEdTevTHqOd5LkAWKtLwlaxs4RbAwhcCGNMSspc16O7azd9WZG5z+wJ0L0jK4aN5Lmu+apfMXC9IvfTSmTi43iZw73pua1QVzTUUvHxQcMro2Haawg+5snjyaVIQ8t+Q/4T74hS0GJq8XpGzxlUoNfEDrJCw97i2RhnnuIyg30ZBCSPDJzaHMd7KXlUsB+NQhYD5oCWkmyguAVheT7/4sEVAFuaH1t8MGkJKfUCiM/GFosA9Uf6QVEIPd5Bq7Nkgzk9hMAFFOUT7rLLOddxgP+sCeSEBxLDCz94bYOuKm3N15wjsUfU2JRGUYrfyNbS2lfq/94h75taxNUuntHN0DgwkKwVyqcKw188PBuPnToitANF8IEE2cIuZ5TQtbxaDXVgKH8ItHxqoFeAKR8FpmiAixMe4Jy9I911jjnkNlcg2e9F9/r8DcGSkU0OEUGcSP+Ht03nGrLhBBHjjScz/7uQBctyoaZ76tDOUig+F85/x6esKZBnqudBAlElrk5zV8D26VD0wOsYaYxNC7IHELNDuzYmTLqkcIqnNlEg7NEXfZinw65DpVyHTeABB2b5L/B9spOdNVeBrPfK32O+usFZo8T3YfPakC5NDvfZxrzKBQaa95cutDkR2tdspcYh2Cs7ek7yI
 zcJ186ZV
 /lNHpILDZFXMh/QhxcXgWvwaAqDbWbzR7YXrQwHu2grj1/akmmCYAXQcxCNGrxRrK47OkQ4FyGCBMtveCTWVYoh7ZmvImS2RYsDMYLPHaYDvQQrJrdKnBRAMRHIs55lyY5VBqVx6x0rNFJ0Y5uOU7PyYc28l2RyALSNnbV3SxFaS2nOzfm0Wt41uGDIziemIJbViaXsbZtffegTRDmHG1fODWxT4PwZUk4tYG8hChh/TMZfr3PZ2wFBN+v/oD5MgViuWnipJF+zRYyEiVdCZO0GEz4LsE3/kZryYjTH/chiXHmJc2skP+uxlwDFG3fgJtdp4dtXltN04bs/f7YxaWDViaVy0HDBfNPHidbDF2kU9TxhBWcc19VFq+A2Q2qAzFig+RMo8K0mugMkxyVBZln6dnfRNO7A/S0GZHRKWJmDJRyqq3W7DZ5ftvuWFuwZVc6WwZnxH1A6WmpO8GN88y2QO8bVORsklYd2iUec8GosPXHXX25oguJB8SWBf0wFfBlntDWypOQXeqb8FECNJ5yG1iDF4qWe6koLRAupum8h/MLFgI3aGv+7EaUKmT9WilMbvEt1ZNHeu8F1fZbsAw+RR8UcBLPXKfd4dpV1i+3t8ntMeT6+h8BgO4bZsNxYUDytxilwv8FPsgRUVaNahHI8uEsG3p6QCpzP7zQzUIPPDwBDmfpTeIhejBdVQGijRT/DPtwdw8a50dsyhLF1AexaYcCBzcoC7homlPdrExthtcuGj4U+sVRCqZAGkggD2Hv3+0vxqC2QeahoryRWuKEsPXgINR18tlhCQKdxmgWJ8U0y84OsJqbWs+483C4mXj/aQ870ETBw9uiOQB3de6z0z2/DKwg5TZbXQxAHeKztqoD8A04zuYaKpiUFn5ogPtOhD0cdbTSLSum9nUopVdV2FJIsGDsOwCSsMD4HUrHCJrtypOAsczQjeXdq7Rybi6QPsBZfzKFvoRTn5Zwu2+Xc43pWsd
 JSJYNZ+9
 lMaFXgZ7fKeUXElQt7cmpp2LMWjHFHt1rdrLScoI/zVnxhGeuOWRc2EHwSj6N7zBEIljYKIo7JeuPh2bC3mWOAbQrCCOBe8KI37fSF8QNwCbrZo2+3NgtBWEq0fzfY4lWINVrs06XGyvPMRTHcEcZPWdi9dnedUk018q2ekZOBvJy4jsLaTQqzGZjtzSMx1WdQAmOkqSD8LKjSbjq299SnU5Hkno9YvHU86D0+qaXoZIJfyh1ob+UedQDulK2kTE6Qd5FTYyFJpc/nWC7AwfZ2b/P3OmhMNHvMuBb83KW1WrTI6iWPYeh3m2eVjiQgNUlUmTzcqOzVRI/VITlpDwXcxGNRMOdTgEUY1QV2lLOCea1VJ5cPWMwusWfCWJAuzHT7hdV8m4Dc9MpIqXeNQdbDC2rPv/1Jc/pjWfS0RwdKrQz1LI6cBvD+lTgcic3e4F90JsVVQ30KFsDsDBThLNN/A7HAjBl6LyS50QrV2QTty0CMEBGQmtrLxfHAVNh10TKK+Ayb5K/i4tDpdII577VlLWIhGiK6hXkAhmKfDq8PoEK0pT3H+n9LX4wzT89/0Hc/duk/kOKS54O/uN0g5pyxDKHiuaee2/kHgcs9VtOhDLloFWyStERbeK+jqLxmbKHK/isjWw2UHltWmXelHRHOgDUnXH/KATIDHQw6Bxy7AEkH1NXjS0qGDUDoh8uvQn1BG+ttnsn2a/HVx3xkyi+72m07Q8dhgMUp+lie8QXyMFVwpGwCI43QTBNuE7mFelU2muzQQIQaEFGYvif6gi+DFSFPF+lt82OjB/QqyOPQao6+5pupIIFawE+4ZnbNb8bYrMpInGoi7mRCzvicflz3A44NbuEqAfQ27L773ddkHs+1pkv2t848F0zbAxnoButllcKIVo9A0deV8Mc+p4W6E6XKehgevKjmxNRmjoKSqPTC5PT4zli6l2NOy+jnrjQnJYtg1uMfOvtDbkBl04dOdqrmedI
 UKB1mtay
 WN0wWMzeD1QmQs5jo88Ki/+fbWJyZqdXDmKOhtvYgplOrOhr1jowjk5ARmFtHzbgD4BrOYMCGv5dHxYhwZmlPvIolLgJQmiHpDV6dHIFjQnjmO4rsSl7yZ4E/JSHxFavBgoL3F9MMH+oOcVNBfz+ZPOtb1q2V77rmzOI6yermPMUtZu9O0FxCvXANLoWgDJRbzyqkDii2VHYWnTUEA2ZHfS98Jj4JtXW2nSBISTlOU6GPEbAhlfnvDRO1KK/h2KHSz1fd44Ka5yiyJYgkQIxDr02CMnzNPjiV49f8ezNzOgXBBVU4W6wNmH5Um8o4nrxiPKuzM0Csa1xCtlCaNAISrv68jcs6zaEbnVhP9XUVGgX79zGfAzr5ytyhG1yUzYHXzjfTy4GG8FiRtGVr1ksilMjnUGsYO40HTS6GL3YdKgwGBNMG+cYoxC0peoOrCiUinc/iNX1kqT+VJoQbJPHBY2LQw7PdqnP7usFRDLtRJ480fWGwS0l+ulfD1kbeSwXPFBtSFKw5w1sZ3RdLqMZNbAwmgbFrNJULbkFx9nam8hOJ3nY1oghNZq3nqS/7uaWVxwNOMDbENh9vr7nsj4YTTXxwJBVTEfZvdesex0puwL7POQO6wSsNZXHo5O8ByQ6duGsl4zs3s++qwAUPD0jt6gjwFkrLJ+Njq2ZYazeFzxOVlt5grFM0pi2Da7ak++MC5TbRpvCTe8cxiH8J+YsYK5I32Le+NQXBzq6Hw9vn9XT0qgr9UUhp8dGB23m3xp5qvOOvTD/qPppXLYH0rzU4mnUIHVFWNLyqnKQgryfYM1kD7SsP95cBHyH0KmMRTjnByp1YGSd7EaSyFqzka1mz+VERjW1WKxBtFmjTSDC6kw5HNe4vSKbEfU3QygFod9N8t2leVfth6a/4dBdVBRb+EXSrLnHiUae1KfF8HDWjEXW6fAQyZtJ2ri/ykYSmrqUXfkN6QoXCDUC5T22WgUJ7+TZ+B43T
 1YGi7H6x
 chrQ5HElkdLorzVYvTg1fbA/7p6srepA5NAKUZYNXBqTwmf5oqm1B2EEA0zqRX8cBvtK4g7jMzdS38/Vf1xWgHPYMl/V1oUG5tE0UT26WNwRzds8Edie6kkHsvzCEs8owT1Gf3WdPdEtCT2YfNVlENrk59mhUBY9BvMWDiYFzEuXzLJtp5NpvFkPNyL3MXIX3JTXolqZFGgpOJ28RmbnZng+X/Rmxk4j0WMBrWIuJ+BUfrxWLB+lpFcQDmZgAnYs3Ba9jQRt3kgklQ8vh5A8PvwJLuP/5KxP2Igif7D2ENmd2l5d1oz/YtZBZtw8u9OeneQ/lqGX79PMDQO06qPG3FzkmW3RNqOYk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in proc with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/proc/fd.c       | 2 +-
 fs/proc/task_mmu.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 936d0258d688be5fdc384ee5c4dfbb8fa0d19dff..aae1a83e884686471758703634f0d3479e77c9a7 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -54,7 +54,7 @@ static int seq_show(struct seq_file *m, void *v)
 	if (ret)
 		return ret;
 
-	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\nino:\t%" PRIino "u\n",
+	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\nino:\t%llu\n",
 		   (long long)file->f_pos, f_flags,
 		   real_mount(file->f_path.mnt)->mnt_id,
 		   file_inode(file)->i_ino);
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 702b0f0433f91077cd0d0af4a07e9d67d9fa9a45..751b9ba160fbf15499555875871d727644b0df44 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -442,7 +442,7 @@ static void get_vma_name(struct vm_area_struct *vma,
 static void show_vma_header_prefix(struct seq_file *m,
 				   unsigned long start, unsigned long end,
 				   vm_flags_t flags, unsigned long long pgoff,
-				   dev_t dev, kino_t ino)
+				   dev_t dev, u64 ino)
 {
 	seq_setwidth(m, 25 + sizeof(void *) * 6 - 1);
 	seq_put_hex_ll(m, NULL, start, 8);
@@ -465,7 +465,7 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 	const struct path *path;
 	const char *name_fmt, *name;
 	vm_flags_t flags = vma->vm_flags;
-	kino_t ino = 0;
+	u64 ino = 0;
 	unsigned long long pgoff = 0;
 	unsigned long start, end;
 	dev_t dev = 0;

-- 
2.53.0


