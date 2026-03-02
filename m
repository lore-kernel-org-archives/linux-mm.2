Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31EFEB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 138066B00C0; Mon,  2 Mar 2026 15:31:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE266B00C1; Mon,  2 Mar 2026 15:31:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDC136B00C2; Mon,  2 Mar 2026 15:31:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCBB66B00C0
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:31:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD589160303
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:31:03 +0000 (UTC)
X-FDA: 84502267206.02.5D4EA81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id ACB812000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:31:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnvKe0nX;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RziRaLsUSj0F4TWeSmT8bgQxPZiu8qpf1mjNySuVHlc=;
	b=cPm+7K5WW/NRYDMwmUKzFKT9v1RQ8lgiIKqSOUcX/cMe/NL3sCH9R1Z1zHtvh/eaC9Qczb
	sgUuy9TwFXc9XrMbSYn18ksP3//NuSfSDhmr5z0AW9d1Y3qQNcbtcGflNqHWyNygUFxxnK
	3gyntllyT9S99Yza2zrP4TczpCqbL7Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483461; a=rsa-sha256;
	cv=none;
	b=vy/lgQLRidox/egkGHTevX050qoajH3IyAotCoDFUCC2JuYQR2pgtIHhAEPS0RtEgtcdXJ
	3gXmqUkFAZrAxGS61YzPRYFkhUnFVlz507ScmR6bfd4S94d4qZXxsxCv2mTSPc4+O5ol5D
	GsGxi2f0Xhi52U93PAX5yT0t2D5Wxt8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnvKe0nX;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA8C1423CE;
	Mon,  2 Mar 2026 20:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F096C2BC87;
	Mon,  2 Mar 2026 20:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483460;
	bh=riRsVNtCfCFegg9RyCzZ4Sz7jbdraQnKk8jYFH84Icc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qnvKe0nX8QwUdQoIpHO/ZgmdEE5cOFTXQqjK33XdgB7DYCgcZnGqlFaUg29IlWmuV
	 RpX6zUne9keLBWiLnN8Kf/7mw3bMCoZqrcH1oD1n+g2rghVCZNwys0mDgXBj58y78n
	 ra3VHpaiBeC1gGEPkj0JZJVMkqeJOSrG5RgJGHdXoOQeMT2VvP+eP9/UU++B73Hxl6
	 ac823MLXfOQHxj2HQ/j+T6IizaYa14nSw8j79/rWBkXcn/XSubxKUG8CkUnfDMlgPE
	 wr0Ez5NpMjcw1bAP6uhshpK8AblWMuxtAQXuFDnFXtpgTT9IL/DPOwNDhWJydGMriu
	 qzJEouDe28RRg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:09 -0500
Subject: [PATCH v2 025/110] cramfs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-25-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=866; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=riRsVNtCfCFegg9RyCzZ4Sz7jbdraQnKk8jYFH84Icc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH1bEf196AVsr+Ud/aaxjvJQgxKhH/XClqjX
 MSfRbTdPm6JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9QAKCRAADmhBGVaC
 FTcaEACprwQPcR4yodSqEJmffPlvSdmIx4EzfJK5L/SlJyMWj4ntmS2KZcxaJGD5wvr+9IjBLtx
 6Fjn5KNv1RpqKEyPbXoK+DBK46cdKHbmNZHS3te0teZYTwSZzH39CDqdk4JcrBMpRL1AqWLcLsQ
 0PY39sZuPaHOs5MLQC9YC3X2GWSbBcu23B+7FYuhYfEZJwa19x9q5sb8vIBX+wj9tfAk9iL1/Na
 eP7gOl2qLRHzNyCEsUdu4rgIdrRz9NO3cv7jrLSe0X2l7Zcy16R7mXgU606DPjbWFaCGH103fu/
 nTNCjuSR9wanoZgBVVitZWUsO+8FvSKsetv3PnUzodUQlnWhWGVMH8drB75vI6ocAdWewtp/bbD
 Mb/VKjJt5GdHym8es1Z+DiMdupuZcAjFULurZEM/sydLBYroadzmugolrxCh/9+yWQNJeFZaCIC
 ZX42GGtqXmerBVHSIBxv8A0KEiSR+XmA49hHGS/E7oOFjdJSp+ARL3D39ZOkhFGm1ty2ClQP/iP
 DqcTMbssUbELTKTFhMCB94WLalQefSD3yQaqFQnP5V6W/V7r5PwxzfgWVg0b9Wv4V8Z+rebP4xC
 0jUTuGrsWIvDqm9U9gFCE9IXL1KwqpzSwiTYxNERrgaMl+7DblOWrpWqeoAgIJu7PPXTENLLcnL
 //bfkHZlbLGnbpw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: rwqiueh1y4hkfpiyujcgz7ppep17jmqt
X-Rspamd-Queue-Id: ACB812000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1772483461-984566
X-HE-Meta: U2FsdGVkX1/xhsAMCUlDbm7lRDZ9Y7L9yqcGz1wJpFYKorkRUWE5j6b90jcd47MWO+etVOjA6GH6tT09+LjljubvHNOulCeIqmyFSRerohgTkKcAeCt50E6JqYbpF1hmHvyo9zTNgMTwesV/gNfrqPgKoxIOcPJ0Vqy6Hox6BCbUkhI/h/56hvF9wW+63/B4zo47jhGCsE25gTdqRNkIBw98SDvsVUcCq0fPHjAGUiUe7R7WmEsYFSsNyWO6393TvKM4mkbbG8KF51OLsMZu+TPFu/7io1nWnWpZNlkGhAwFxHwMgLOJwTM2zscM5m8g4fzZtEYfqP+dh1cYi/N0sC0l42wRlG560daBwKQLKJ29pKgDdyJB4ZeLuaWftSFWLrU7UP+wpKjXr6DEhtOX/pzpdHedIa0VHxFGIw3mI73xUIzYUxq/ItEJhgJ8V6GpLHPibhO4nARrf4Ydlnt5B2HbYD5d5ziE1IzzDXwEz7NueCMQ+zU8MlcrT8TN2QuXRo9rZHiRQ+PnKc5kkY+fwADHBMU5t2e9cIXC/agXWb38K/b/f8JGNSsrUBVEYIqu/4onJPJ/aU53kmUxpEa6bGrkRAOqtcrE+V9XG7foiQa0mtHbJasHmrB94v4XYreJ+d8yfVijSYg+akRGIuUz4gy5EfaKN+8nf9hmTz6IM/SrecL8jKptkKyFmJLP6+GEQaQJamqaXy6MgoR4nAGZQdnJ1+FnDioZkDhFsj2lclEgDTHEE7DMVZTj5jJpd8qOJyzBIZ0xDtHaF+c3sedQHjkDspfzhbuTP49k653rfuL2gCr3J5ZMOcH6L8O+gMp+oRfeXr/1DY05ixonN0Q3bRIscz7nVVHlrufPcY8acdPWl+VXj8Wi7ZJLaDMFUstPsvEh12kSgy1XV9csXNbpHKiCe7JtAOO580oVyQZPKRccGWGVH54DoeM1yV+JbSI6MeVajuyHcCTbvFenyn2
 DBMcdkOE
 0JQCVsGGueO1ORJC7nK6tcyySDA6sdMiukRfIQQ6P5gyWg4z11lnrv8hyejdp0jcVDN7fVEp2TvnXQMn4uOyPOGuzBOpkF4DXvfCJF+0marHB/k3mgdi5MEAYc4jN9AYwXo0POPL/3ev/yz96Qpg0HVxGigv3BIZPK9mCbkOlOhyGXhFGjQSm70hvsrGEOu8ZrHBI0E+IKDbtRgGcii0JWQNVnwldI7SNNZCz6IkvA4gcu+QNBolxZY5Rxu/rUMbdZ/Rcc+qQDgKF0rqTB+HMBmoU5clQYuDZxO8H3N/FpY3j536Bxv8jwYDaOz97zOApS9OHK4jl4EaytLyK/Yp01+X3y/ybomAh4hXaJXLgQJIcTcKcsdI/FB2oapyGvFfrc9Agsd5yxPJAJ1/6PZlVjqTRpETpbZgk7MXPp1COPj8JLPF0/hPBtgkGWTxge5lEXe+9f+3HBfqvOOamwW+H/vhRvwo4L9B/c9w7V5Fi+hKDnIIdonjRo0fHg4YkKCGWZZfiuTay1LtPc9fmtgMN1lceIRILuKL3fUTV7He8wzXPRbqgvftO4Xr+BfvmkDCN3hWSJpM6+KN9S5WY7TheVPahXj1gIvTNz74CTZbrFNqP59N2rS2aAbEkmPAW0eoAEjIZjLU4V8++aFMXixw+SvMQl9bbLSZUvHkidxZeT+Rv5B6nNtp/EXyT7W6SHH1dXf3sA4i3E7EzLx84M6F9jCdsvzu71w28ZO2ntMxhRFxg5zvAU7ko9QqfkVlFJpqaY1YCcGH1ATLY78kMU99wzE3Wg1ytMWeMZo+7xZYPflzKqD0K/Vi+LwJj3FgLRruk35kJXGWTwi6Ld0Yzxas6oUolMNYzDV4+/cxjqnzu1/3nItFD7m9WPFhPyKmRwvCdqo98lQLA2b2YtqmLBZrnvPTKLpVWGsw/11YWVzcfoWtjtextCIRbrpCj3tsuy/eMaTWZelxU1PI544BkOQErKmMwX2ht
 1llqDJ9a
 NVFSMFlOprcsM7RmxmTkodlzMXBwSC7E6zWUSqWKF6vtvhNKOGkPF5vJ8McryI/w5RDmoxR/6Nvz1j4M8W1Rut8d4m/0U0JF0gHwaNYUYppYskqEN7t3JniCBLEMTZk0iEJOLPA+KA56mCxurs9C3uKfeEDSqTUPu+BjCtXlpjJJp0A6ae3owgWWBBW/BkFFghec3mMe0fNqK0JlCWRY6B3+v1n7nBooDUhUvckTnF5LLupYFGS1zt5fJVSu/JWi1HAX+UZQbE6TKti/dhFRd/7NeZ7fbXqDYhgvWtGc2hvnKUWtlXqYf2fA0qjLVCt5kPDICFtjiRk3LtVHm+9IVqSaTG1fzBepooPFNWEVi78EOozTRH2M0+BXgQWZBqh7g+rjbsJj30r0Ed8xDcdbZ3WUlOyvP/79kl5fH7++g7p+R9UVZ6IQi9hZ6LxqMnvwhIaUUSYB5TJA3mILNH0sZAi+k9UlTvQ5lEJwxvy6HeQNlAuPyh6Vg1kGdhRZ67uFdvIwga7wI990nEXl8QP/nvkni3hUfSm/osEEjnJwrwCIHXiZ3IYTKWxIB+JJndXCfwQbukoYt/4vCPgSAjBQeGv+eyWrv5Db2JDqgI8ib/9qFtfV2olskt22jKOungsC9JT4p0d+pQr8Y+BObBHr21FtFbkjvEVS+agl08mDdtxd/uX+vo5fCI9/1xgRCrmyOAZXdQjvMNUpqkxfZ6zsdfv6y8yig2mxavr4yL/g5JomSIgn8cyx4A5ahyD0287Yy7AQGAoVQ4UgOuavNOd6TE68CPgMAiSgjPRHMdxTflb4o90oTy1C569KjZmQBJznmmJHuUDj9lsws2rX9ufrl/OYTn9JXYIcV34UDdxYheafTm4qVupeVduvPPwYshGVZVm7T1qseaqqKaQ+bdXr3cFQUFI9cIH1S2SaPFLMiPkf2XbS2mt3l0KX4qt8AybTOZjzw7lXe3zdUZY0kNTXZqhc2dJbN
 Qvlltfv+
 k6KnTcZmuofs5aEF/Pa1CRKpUV8cZQAHKD8qwOiMLr7eZuQVCi00WDyKsOU6q90q6itzi67vy5ii37r2hcXxAJiXmVIXPgmHNrmF7hiAAOGwyCy0UzMTRxwAuMCmBdLLGj3BYPAE5w9Dgo1NLWssHRgV1NR05J5370vOG1gxaXEWf1dSOfwESs33HgMikPxqEQmUX68f7gj14DPOLBAVx8M2P8fh5y/wkduiqaO+gEIqs4F3cZk9aQ1lEy/9Ax+xonfueYTV/ka4kHfdpjjiGwVfb1XM6JhYPDeVIWqa3mk+IvdnyYUU9So7bNpyTaIM+GBAeT0OCNep6TIMEOLuWHzqmAxGD+2dk92rmh05KdJusgDEXJ0vUxz0httg4pTIH46tVnmoiLBaqVHhWF+rRw7LDJRqdoQK+ZoW3t62xQOvKuW4cZWXMuuGvI+onybB8kHOypddeVbCdQuXjAoo7kzEIW41pWG6/48ePUdWNbnhvYBPv2eTEqoEjbeXEr+q2KDl4iws8X8ZYNiTKsf1NeMyH0xqkej9gw+A6uTV/ORSoBx/PyLBeBb/aauGMr4No+3uA4fTg1/321yZyos9audM8OqJfYSRy+e3Yjvh2DjFJuM5fvgymB1daVTn/cmhe2DYoBVoDOEG8fmO4ww6Y2OuHABHTAb4fw/v+t8XQJbBzpNzCREbGN/zedlrGha075tRPA/UfJW8wBanp7CJEg8RHUhZ4DUINSaaMpMibarkxQY7wgD/uebykmiOioPN9yU4fjBWgPxrLmO5hj4FBorYBGdpYcrXQWoZq16iNvAYgLbgCxhtbnzpMYYLgGfKcIPDst+IMGv2SlUi6rNQ+GgKPma/xy5elZ2ziuwBG5FrYCUMU7rwLUwL9LyIrxkPKQj7GZPZhCPi0EPryRR3njzQwe3ESUuGf0lp7s5nhwKEGnSdx+AfmK7KJC2k/G8QLh1Wx7IhUdFCHz5HfXwQIN1t/Fzzi
 wYSMrekk
 L4kpQrC4R5xBErEc1fS9KOQeCDp4a39gVwgJVmQM+oEHXXVyIiw0FM7fV429sBuz71yGcOD1UkfFrUyBDHtMitCL3Ii+JAutgoEpQPfu21Vn38yqAgCdpo/u7I0GHNflNVUiGjBlbMlaKfXyGXUrhU2H4QfxYsxoVLfZvpKy452ZQyLvbduujXpgSKGI+nV/ngXRlbBG57YwveNxxhDCi6u3NhBi6lKImrwI5yMglT2iY/H6cehlwbzJaEAjJ2rELRMufH/gH4N3JzsNI4N/d5/BDWXCBHe56/P/9W0GEk4ytFrWgWejNvoWtWeK1My6MyCFRWTecS9G1L0GMv5u2Ecfyxm3FTEoT8XKm2nzWh5XNVoDdNN6r0UAaXGFccIRP1hmdVWJFzAbTo91DfTBtDmeABk+AEpZia8mkT6w4u/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert cramfs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/cramfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index e0ba9cd640dcfe86e0976344b30a5b9a0da6b90f..624c5ed0ceff2e4d3e964401e3cfb82154c719ae 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -125,7 +125,7 @@ static struct inode *get_cramfs_inode(struct super_block *sb,
 				old_decode_dev(cramfs_inode->size));
 		break;
 	default:
-		printk(KERN_DEBUG "CRAMFS: Invalid file type 0%04o for inode %lu.\n",
+		printk(KERN_DEBUG "CRAMFS: Invalid file type 0%04o for inode %" PRIino "u.\n",
 		       inode->i_mode, inode->i_ino);
 		iget_failed(inode);
 		return ERR_PTR(-EIO);

-- 
2.53.0


