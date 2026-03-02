Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B2D9EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58FC6B00E7; Mon,  2 Mar 2026 15:36:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0C186B00E9; Mon,  2 Mar 2026 15:36:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCDDF6B00EA; Mon,  2 Mar 2026 15:36:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A55F16B00E7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:36:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 731AD1B74F5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:36:19 +0000 (UTC)
X-FDA: 84502280478.25.4D771E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8972214000F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:36:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D28UfErK;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Stiwy+8hAqOPM36499lL4VuCAEvMe7Bk4QeNFasmLsY=;
	b=uR4p3ltbISGhdISh/MKmkI54m3HE34oHK9Cg/029HC8zzq0Lv3T6ocHi2WHot6WffdiIkc
	axpQYDMh/8ph02ZveFdKiVSggvTm13M6nzlfZAvUHv57t93jKq2VHBHBgQH59OiwdDM+5K
	6K0ZrLIuUWmyTtrgVUxqyWFB8EI+mic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483777; a=rsa-sha256;
	cv=none;
	b=fzQ32k0YPh9RHI/M3++on1+mraImMuQ8F70JFNyQPEoN96zNZingoyhhPIygUsCC5GFfqq
	JeXHx7Ea2tO36xMFTMG7k2ezaDg3vVzLQO9uNtJfx53SmIGbVLUQIT5PQTqM4cS3k8A8ml
	Cciq/lLedJDQor4XKyVhUQVoAxugifE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D28UfErK;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A20ED42CED;
	Mon,  2 Mar 2026 20:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68853C2BCB3;
	Mon,  2 Mar 2026 20:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483776;
	bh=2D5RY10D3f9EA9VpSCyHAUgXnN1Zhdx+XHZEceYHLkw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=D28UfErKl1eVcmih3OCYqwtJEuipyNBp9pccWN4O90PfjlQCfkkqiKjHx0aD063mq
	 l821fn1Q2d9BAIgMPaDT6IfrQUygarHlZB4m+fsBbydlI2jsHc1vHUoRf6RM+GdM0m
	 /FVKPTbWxqvtfYUVIqsR8nj/U2sD7GLB2Ls9Ru5l+x/v38Jfw6FpxolDHaxAoIyaA+
	 8Sx8d9SB+FgceSv49vWPXcCRFJEGFdyB8MA3zKxF/dknpmKpl3PTOwupPpI5NnZKFZ
	 j6rLDF+JnhA01/h5fNLCayGWtR0S/VuDR72pkdqZq+useJcEkMg3c9QWpOiqJNRued
	 +3gaPWPXWwOBw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:31 -0500
Subject: [PATCH v2 047/110] ufs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-47-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9430; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=2D5RY10D3f9EA9VpSCyHAUgXnN1Zhdx+XHZEceYHLkw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH7rH5PHRctdRRgjkwiK9qGagiBnv38zWs92
 EflSEcxid6JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx+wAKCRAADmhBGVaC
 FSh3D/4/PsJte0gi8dRA0elfhS2fQq0Q5BLWsJIRQ0v1yNUSYVJBfsKc21wLkeg28VhyxcPrBdB
 wV8K4/ffWGU7hs5jUXnMevIziT5Ni0HtqEJgdX79aoxyyblykf5U/2r5meRVpQWJ3pW9a6vlPMn
 n+5vlifF8JzJqiEOoiilUeT/eI+sj1LVaytSk9qgSIFYoz0qcO+aP0tflWOtQESjcDQpNn5fiTI
 cfJPvelPlPF1zzoS9suzIcAYeSJ41/BYVlfNp5y6si/Yq/1Bi1g35jmTPIfSQYKS5VVlDOXWFXS
 E/KoPB7IsQZGsFQ89C3T7aaaVk18XUhffxKeodoFgKmb3sFpxJ53fttSUL6XISkSomzHH3tbsrH
 +/zRf21W/uqcXY7lLxPLSKtAA7ZnDaPi1aIT61mPsi7cKtf8E3YEmGmyCW4nxiVQ8oSWomZYYaD
 TXwkCIXmDp6cbw/OBcsiDQM1jSeSB6QigN9xYFvYTx+KvDtVrtUeWPigEenILHOS33QJR6aiYMO
 WV5VDgDnKrStOWXcyvzqqbnUbWSYvNoNP5hUCSXAby8uLfxo85MxPHYxefD5fjJtAR6QQDnfum0
 M31wgdYwMrbWW7LrWYZcx3bdukHRB0f7bamrCtoxYs/3A5nL69KoTjrgLZqyP4xaYXJyD2qvmPp
 02rS3BwD2CnpO7A==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8972214000F
X-Stat-Signature: yrk17gr1rn6qm6r6gitk6j3nqmnd9g4j
X-HE-Tag: 1772483777-407240
X-HE-Meta: U2FsdGVkX1/b1bRpd1lMWQWCAd7QpxBmH27syhdwzbHtM5m/DNE1JbvFENulqnZqcE27cVduyxl6Y4Cor/E60IMd7ZTDbc0/TgfeCG5u4zVtspaSCYEqAUs/CvVid7GYB+9R8xW0EJSxD6xop3vvn93BtAcXteWJcnjhDC6jvrjkVmyQ9cUy63Dp53S5An5E06kWi8bBW5cjmjTcrBRKl1h4jj5o4CgmfRF/Cxlf37d626OpSfAVHodlZtG7VzsxsUaDCosNsxa3h43mzGIaKnVsRB7UCOxHcdY/bqS8WwnzcnVo5QCFmzI0IYaouzbf+4QXZQjBjhyENoryh1+6dnGC9CHW05Us2GHG4sQ4HAnGYh5ZstUiThvu5A/ZaLu2jiyt+qQV5La+iStHp6SDWKiuFtueDG70OhFOH5iKlLOu7GpZ7RodZvOS5nyUDknujMX3dDpguEiYOcDjI0dbygovnl4XBdq0QdUWC6yFQ+Z+DjIlRpEuj1AlsEUxRVj0o68KedzHeLjRDs9servCMOPkdIwk2yLCTGaeyw7h3P1R8JZgfd0GtDfJBK0E11Z1guDs6fqKPfzsLzObH7l9E0XjsHwkNLojVyERcLd9/2mGYZ9XgP33GIKlqlvol3i0t/lniN7N1LYBMCdWA/Yk6VYQqKYWNvvqcJJ/3B/BDTlhTlcIle/sVKQekI7pHnzJC7QsYAjiUhsrldGpJNlzHeRDbRj7W8UVp9AocogLhGWXY1ucqoTWqRPedGs1EAQkTp8IABWHdF6lqyV+RDDtA1ajAUPdfoBRg22WdSI9gNEYp4tBMZx2eaVFL54bYnHA3H1o+sIcb46OPRhFkqp+EgrHJLESo4DaJg6EvPb7cAL0fctv/yN0Ct63+AtKtvgeO+BJcPz0ggmBcoHTNhcx7K0w/3Kc8bXqtoo86LV1dVZ14fpgEFQH4vOECOb3ymSg+AWcnKsrLcJaMwwC2tW
 wBLUH/x+
 muHlTD4xNw27mDEuLevQGm5xRvpvqHL+7/yhVfW3VHnpsouLayICCYkEbBu+1dfnVnoiKYXXbFwqDn/sAMDGhw7L98jGNwpwDZBHAh9h9ISCd0TuIFTzepwMF6uHrVn99cmJOKrGYxGFhg9egGbn9exWF/ztGttJp0uZLcuGFkXurBv0GSZMLg2FcymkEtmN7Fu4IcFP9j8yNjGayZFjDZWhZALq0x1g19X5jxBIN1RQidJxjvpMIw/eJrlKxcK89B6BELMHGthnDxWc2iLiXOVohEWYlkvkOcTXb2kRpTuwbYsPlJ+wQhwmiWWIRfw0qaNo52D+iAFRNMg76m0+xlSIeMtj4gyMTTWqHXcA5WsDKgmC1SQrAVoZxZvsV4PqN8V330m4Hu+u8vgIdICjnvdQjQ/xAfD+ch6daZdUTiz04rqcv9qEitYMB8418yglzrRnb4FQBIVUgXVmhOfn7xx25ikkEXpsSjp4s0WR2wnZ7HEB92F7Y8sTaubyFw9+kuYamUasVGyqGAVapFF/dTsK1cc1RqBPAllY9jOcUHMcxHLGHNAInUq/vXix0FLI5+DK8EqTP5t+1DueZYM7YVK8VCI9ZBMZO9egFqA5GDhYKU68B+/zGGultNcARGAfN5rnC4L7dzbJbPymnBGFNs5pvt6Z+uJS7cAQlyL3U9fm6gyHYk1erfDfwqNOND62qIjqDsJi/GmsXG7HktgZcfRMADqETWQJ5LtqZJBYRol6X/wAqK3OFyTjcC4h+/eByRd5aJby66TlRNMMFLAtc6/YOyVJu36JgcySFtb6iB3Ra4+JKeeBlLupl21M2WoPfZEYgaWKTx7kH/EyW971aLN1gKfIM0QXLBThRQWI3hDGm42T/dHJovEPErVWR4fQL4kLukMPakCjO/qYwRG1k17ElyCzQU3qQYv13fTnbWWF8izNW8NxXTTGjb+9CmQa8FDcV4oRLDPoBVNLO/F5IKhj0lzNP
 qMbCvqxZ
 ZNjMfdDylvgv/0fXj9UGyD3nObTAr2SnDS/Yaor4WaLQIknPf+i8nWQ4bHWuI+iiBb5k6dvzGNOk9jYPkk+HE1fqs1egqQTss5szEkTSZ2FyHbGERgofIun9KxsyIfKeetmdlNaTlc7Im2dlEN+7Y9StRrbbLW099luHskGe/1Vbz64fbR/saF/qEKSVUz2wdC1rmvCEgpK7E6pdBc6xr3H5DXEPn0c8ZR5pKrjSalKKjNY9uanaveHQh0H0sCX+MX7WNLT5F/wpMqcpFm+g+1hw1pck4ezs/Mrept74KBsAtjr3RxwPxYmGSt5JxkAUYsl9OrbSe9P69hdDG3gFn2sTXqXIOKo/XhjMYEeA9Lf+Yhtsfay0lugVPY1V2dZIjomI1SxdVrFl9moKzonA8oFaHoVBQMfuHeWKBxtxck4objIb9k4WyVEAkQfshfmVg6zgSba4vJrS2jsn+qU7WyERi8uNRPS78p/A23cZzsNSeFnhuynevMEBAtyvCsU/92A3mQDg709lVk6P9ARPKACfYRTfTtzbXeFMRJWlCmUi/fGsI0tdtQLPxJOk7cYmYSjaswUOee83hpOk0CjSirMj9POczBLpu3gZZmSz8anwFougMdrUbD27wI/EDD/qaU6wFmDCBImXrtW3HICTEz8cEGG26jzl0Pdy0c5X/xeKBtUYT6fe3Ir0pf72cW+o+bTLwIEM27pUpEIjeusc7OTDJUJdRL0FM93wj3s+O8/SnxdsZx+zHF8LjCELl/GAyNGqIwpnNYVQKannqsERAEfbxYapDPlCfI/aVChp+PLdRoQthznqQMQHNBo941XOSac2NrJ6dVx7IBEngqHz4L6ROoypkfCYlOoccuRGv0QmGb7vzxHIxSCHH9tfvwyA/VTK3pQQQFPZ7MSXcSEQEDMchbEegpDJUgmGq/71+OS2vT+Z3/G/2JX7/hIxZf2wEDY8XwKDkZX2InyFBxoKAq5J+iFHw
 gSsjxd6H
 2gpdul027sA9T86csedycuipIq3Q9Mmj14bqUNouNCSpqxLlkbHFPFpQpkwptyrcT/LQVmRZ1EI2xtCR5eih7IdqbpdJmb2/UO90UYKjEP0iUqwlHA0//Dsb29pXWWAGWZH0iT3R3J2/6wzaaz7A9YQ8SnlYNTU7y/66/PZZhqZLWzOEMtt/lLfcoZEdWTSJ/GXYOxCnQn4Dfs7j5khY8giOYzt4VjPwCn3xhu+72a2JDdGmpr54ygo5Rdt7/eGSiWvjgKNp7iM0kkWuIxv+6rGgU55awFpMNMwBQ8bj0NWCHFQ4oqbSesvg61k1mibP94J3xa7YvgPinUdVxsVdwTvzL90CWZ8mKgXtAPLowFbHkwpU4hpQrzMHuJQNOMtYg/E5eQJXjiiX/yAyhDevnSPnB1Di8oPJ8nT5nv0l9q5JiZp+Lja2v7fPorc2N3Hpyyu1YMy2OrZUOaLX+zEnXdjAa6xz2evcgsgPvlzeeBqIBuDPOMz5tG0AOl33fwc5Rv7/XrNPwyubHBVxq2RlPAf+wyj+N5P4y4b4Os5BLkv4TmRdyT0af1BVNThVErAsh9Y+ua9ORTvr3b7M1wIei3n9gc555aAp7MvQcOxD7bKxm4SPd96ENXdqibe5GsTudDCbDA0DKYZPdC460FgQtyK+4SXlNb3TOooaUq8qTBDMkTg0MbyuONhhMMDIGiDHOXIyxVVWHNcbbp71zgjAaAVEOBc9jlu21L6EfqlazD2qv/l6Xsg+/xHrDFN+Opiu6kf15VOmIOoOm6+d2lyItRliHW419w+KduUnUGR0wPYMNCAw5ZuWnm9EFgk2L3Mgxd2pkVXv2jHybEPWVvX/Tfx88sK4HliiCZQoj4U9F5S94NbN0osoCTR3gTv8hhySpkefn3Yried3HYgshVfGN0/32LaUqxwFOsP0nI2GTPMbRJJUpdK4i56lPCGSYRUtumxoNqU5OR8a6IeCuvHSqufExpeCi
 bUID4VHt
 JKswleTnEtKHMCykpL7Z5/Joaw9QIsGwUsT8KwHThYzVam6dIqt8J92mupn2wo9bxmlhhjMjkaBQpFIHHB/jRy6/wyREMolzbW3yD+qWmg+eiQCwjEr/bYTyqpnci6C/ygafgD5FiIfhCLR1eWi7pi0PFmn9bUCpn9tFL0jjXMs0/Izg082iaPv73HHhthT6NW1iBAlJOAnOFuTppsK3sqhdiERdBjZpKpVHjeBLMB8sliEvsgx1sJfH43QuSeRSIxIT6JBxSvUTUMjq9QKevgK8i1uD1FZV/HUSU+ds3ydjnbsXx0u8qn3JHiwWq0J4vcAD0RE3D/SwC2J6D4vSYTQgkxxetoHec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert ufs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Remove now-unnecessary (unsigned long) casts on i_ino.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ufs/balloc.c |  6 +++---
 fs/ufs/dir.c    | 10 +++++-----
 fs/ufs/ialloc.c |  6 +++---
 fs/ufs/inode.c  | 18 +++++++++---------
 fs/ufs/ufs_fs.h |  6 +++---
 fs/ufs/util.c   |  2 +-
 6 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 194ed3ab945e3eae94db085ee8d37eb1a4439470..b961daa05608fa52dcfc2702bb97c437ef27d9c2 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -245,7 +245,7 @@ static void ufs_change_blocknr(struct inode *inode, sector_t beg,
 	sector_t end, i;
 	struct buffer_head *head, *bh;
 
-	UFSD("ENTER, ino %lu, count %u, oldb %llu, newb %llu\n",
+	UFSD("ENTER, ino %" PRIino "u, count %u, oldb %llu, newb %llu\n",
 	      inode->i_ino, count,
 	     (unsigned long long)oldb, (unsigned long long)newb);
 
@@ -340,7 +340,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 	unsigned cgno, oldcount, newcount;
 	u64 tmp, request, result;
 	
-	UFSD("ENTER, ino %lu, fragment %llu, goal %llu, count %u\n",
+	UFSD("ENTER, ino %" PRIino "u, fragment %llu, goal %llu, count %u\n",
 	     inode->i_ino, (unsigned long long)fragment,
 	     (unsigned long long)goal, count);
 	
@@ -583,7 +583,7 @@ static u64 ufs_alloc_fragments(struct inode *inode, unsigned cgno,
 	unsigned oldcg, i, j, k, allocsize;
 	u64 result;
 	
-	UFSD("ENTER, ino %lu, cgno %u, goal %llu, count %u\n",
+	UFSD("ENTER, ino %" PRIino "u, cgno %u, goal %llu, count %u\n",
 	     inode->i_ino, cgno, (unsigned long long)goal, count);
 
 	sb = inode->i_sb;
diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index 43f1578ab8666a9611d4a77f5aababfce812fbe4..c7a13e01119f990b8f7139fdc3005e7b65afeb54 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -150,7 +150,7 @@ static bool ufs_check_folio(struct folio *folio, char *kaddr)
 
 Ebadsize:
 	ufs_error(sb, __func__,
-		  "size of directory #%lu is not a multiple of chunk size",
+		  "size of directory #%" PRIino "u is not a multiple of chunk size",
 		  dir->i_ino
 	);
 	goto fail;
@@ -169,7 +169,7 @@ static bool ufs_check_folio(struct folio *folio, char *kaddr)
 Einumber:
 	error = "inode out of bounds";
 bad_entry:
-	ufs_error(sb, __func__, "bad entry in directory #%lu: %s - "
+	ufs_error(sb, __func__, "bad entry in directory #%" PRIino "u: %s - "
 		   "offset=%llu, rec_len=%d, name_len=%d",
 		   dir->i_ino, error, folio_pos(folio) + offs,
 		   rec_len, ufs_get_de_namlen(sb, p));
@@ -177,7 +177,7 @@ static bool ufs_check_folio(struct folio *folio, char *kaddr)
 Eend:
 	p = (struct ufs_dir_entry *)(kaddr + offs);
 	ufs_error(sb, __func__,
-		   "entry in directory #%lu spans the page boundary"
+		   "entry in directory #%" PRIino "u spans the page boundary"
 		   "offset=%llu",
 		   dir->i_ino, folio_pos(folio) + offs);
 fail:
@@ -258,7 +258,7 @@ struct ufs_dir_entry *ufs_find_entry(struct inode *dir, const struct qstr *qstr,
 	struct ufs_inode_info *ui = UFS_I(dir);
 	struct ufs_dir_entry *de;
 
-	UFSD("ENTER, dir_ino %lu, name %s, namlen %u\n", dir->i_ino, name, namelen);
+	UFSD("ENTER, dir_ino %" PRIino "u, name %s, namlen %u\n", dir->i_ino, name, namelen);
 
 	if (npages == 0 || namelen > UFS_MAXNAMLEN)
 		goto out;
@@ -434,7 +434,7 @@ ufs_readdir(struct file *file, struct dir_context *ctx)
 
 		if (IS_ERR(kaddr)) {
 			ufs_error(sb, __func__,
-				  "bad page in #%lu",
+				  "bad page in #%" PRIino "u",
 				  inode->i_ino);
 			ctx->pos += PAGE_SIZE - offset;
 			return PTR_ERR(kaddr);
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index 73531827ecee12b3dff09aef0acc0e374b00fb29..f26fbe330a1d0e053ddf8dbe2a8ec5d41373c79f 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -63,7 +63,7 @@ void ufs_free_inode (struct inode * inode)
 	int is_directory;
 	unsigned ino, cg, bit;
 	
-	UFSD("ENTER, ino %lu\n", inode->i_ino);
+	UFSD("ENTER, ino %" PRIino "u\n", inode->i_ino);
 
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
@@ -317,7 +317,7 @@ struct inode *ufs_new_inode(struct inode *dir, umode_t mode)
 		bh = sb_bread(sb, uspi->s_sbbase + ufs_inotofsba(inode->i_ino));
 		if (!bh) {
 			ufs_warning(sb, "ufs_read_inode",
-				    "unable to read inode %lu\n",
+				    "unable to read inode %" PRIino "u\n",
 				    inode->i_ino);
 			err = -EIO;
 			goto fail_remove_inode;
@@ -336,7 +336,7 @@ struct inode *ufs_new_inode(struct inode *dir, umode_t mode)
 	}
 	mutex_unlock(&sbi->s_lock);
 
-	UFSD("allocating inode %lu\n", inode->i_ino);
+	UFSD("allocating inode %" PRIino "u\n", inode->i_ino);
 	UFSD("EXIT\n");
 	return inode;
 
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index e2b0a35de2a7000f46a298114c1dcaffa17c43dc..199f5f71f77b20bfde408cb1ac7a8ea8c45cc465 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -400,7 +400,7 @@ static int ufs_getfrag_block(struct inode *inode, sector_t fragment, struct buff
 
 	mutex_lock(&UFS_I(inode)->truncate_mutex);
 
-	UFSD("ENTER, ino %lu, fragment %llu\n", inode->i_ino, (unsigned long long)fragment);
+	UFSD("ENTER, ino %" PRIino "u, fragment %llu\n", inode->i_ino, (unsigned long long)fragment);
 	if (unlikely(!depth)) {
 		ufs_warning(sb, "ufs_get_block", "block > big");
 		err = -EIO;
@@ -595,7 +595,7 @@ static int ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
 	struct super_block *sb = inode->i_sb;
 	umode_t mode;
 
-	UFSD("Reading ufs2 inode, ino %lu\n", inode->i_ino);
+	UFSD("Reading ufs2 inode, ino %" PRIino "u\n", inode->i_ino);
 	/*
 	 * Copy data to the in-core inode.
 	 */
@@ -662,7 +662,7 @@ struct inode *ufs_iget(struct super_block *sb, unsigned long ino)
 
 	bh = sb_bread(sb, uspi->s_sbbase + ufs_inotofsba(inode->i_ino));
 	if (!bh) {
-		ufs_warning(sb, "ufs_read_inode", "unable to read inode %lu\n",
+		ufs_warning(sb, "ufs_read_inode", "unable to read inode %" PRIino "u\n",
 			    inode->i_ino);
 		goto bad_inode;
 	}
@@ -793,17 +793,17 @@ static int ufs_update_inode(struct inode * inode, int do_sync)
 	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
 	struct buffer_head * bh;
 
-	UFSD("ENTER, ino %lu\n", inode->i_ino);
+	UFSD("ENTER, ino %" PRIino "u\n", inode->i_ino);
 
 	if (inode->i_ino < UFS_ROOTINO ||
 	    inode->i_ino > (uspi->s_ncg * uspi->s_ipg)) {
-		ufs_warning (sb, "ufs_read_inode", "bad inode number (%lu)\n", inode->i_ino);
+		ufs_warning (sb, "ufs_read_inode", "bad inode number (%" PRIino "u)\n", inode->i_ino);
 		return -1;
 	}
 
 	bh = sb_bread(sb, ufs_inotofsba(inode->i_ino));
 	if (!bh) {
-		ufs_warning (sb, "ufs_read_inode", "unable to read inode %lu\n", inode->i_ino);
+		ufs_warning (sb, "ufs_read_inode", "unable to read inode %" PRIino "u\n", inode->i_ino);
 		return -1;
 	}
 	if (uspi->fs_magic == UFS2_MAGIC) {
@@ -891,7 +891,7 @@ static void ufs_trunc_direct(struct inode *inode)
 	unsigned int old_tail, new_tail;
 	struct to_free ctx = {.inode = inode};
 
-	UFSD("ENTER: ino %lu\n", inode->i_ino);
+	UFSD("ENTER: ino %" PRIino "u\n", inode->i_ino);
 
 	new_frags = DIRECT_FRAGMENT;
 	// new_frags = first fragment past the new EOF
@@ -956,7 +956,7 @@ static void ufs_trunc_direct(struct inode *inode)
 		}
 	}
 done:
-	UFSD("EXIT: ino %lu\n", inode->i_ino);
+	UFSD("EXIT: ino %" PRIino "u\n", inode->i_ino);
 }
 
 static void free_full_branch(struct inode *inode, u64 ind_block, int depth)
@@ -1169,7 +1169,7 @@ static int ufs_truncate(struct inode *inode, loff_t size)
 {
 	int err = 0;
 
-	UFSD("ENTER: ino %lu, i_size: %llu, old_i_size: %llu\n",
+	UFSD("ENTER: ino %" PRIino "u, i_size: %llu, old_i_size: %llu\n",
 	     inode->i_ino, (unsigned long long)size,
 	     (unsigned long long)i_size_read(inode));
 
diff --git a/fs/ufs/ufs_fs.h b/fs/ufs/ufs_fs.h
index 0905f9a16b9150b656bd6d8966c0f8cc220b439d..b8dc354ae90f4a0839303f89c87bd2940db62b99 100644
--- a/fs/ufs/ufs_fs.h
+++ b/fs/ufs/ufs_fs.h
@@ -226,10 +226,10 @@ typedef __u16 __bitwise __fs16;
  *     inode number to cylinder group number.
  *     inode number to file system block address.
  */
-#define	ufs_inotocg(x)		((x) / uspi->s_ipg)
-#define	ufs_inotocgoff(x)	((x) % uspi->s_ipg)
+#define	ufs_inotocg(x)		((unsigned int)(x) / uspi->s_ipg)
+#define	ufs_inotocgoff(x)	((unsigned int)(x) % uspi->s_ipg)
 #define	ufs_inotofsba(x)	(((u64)ufs_cgimin(ufs_inotocg(x))) + ufs_inotocgoff(x) / uspi->s_inopf)
-#define	ufs_inotofsbo(x)	((x) % uspi->s_inopf)
+#define	ufs_inotofsbo(x)	((unsigned int)(x) % uspi->s_inopf)
 
 /*
  * Compute the cylinder and rotational position of a cyl block addr.
diff --git a/fs/ufs/util.c b/fs/ufs/util.c
index 034b1d82c355ca49ec917e98dcfcc6d80e6eb00b..9acb59697d85015e83cd1e59ffbccb5452e6dd2d 100644
--- a/fs/ufs/util.c
+++ b/fs/ufs/util.c
@@ -203,7 +203,7 @@ struct folio *ufs_get_locked_folio(struct address_space *mapping,
 		folio = read_mapping_folio(mapping, index, NULL);
 
 		if (IS_ERR(folio)) {
-			printk(KERN_ERR "ufs_change_blocknr: read_mapping_folio error: ino %lu, index: %lu\n",
+			printk(KERN_ERR "ufs_change_blocknr: read_mapping_folio error: ino %" PRIino "u, index: %lu\n",
 			       mapping->host->i_ino, index);
 			return folio;
 		}

-- 
2.53.0


