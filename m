Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4371CEB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA52B6B00CC; Mon,  2 Mar 2026 15:32:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A588E6B00CD; Mon,  2 Mar 2026 15:32:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0A86B00CE; Mon,  2 Mar 2026 15:32:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AC156B00CC
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:32:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 219E41C300
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:32:58 +0000 (UTC)
X-FDA: 84502272036.26.D8F3C9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6105220007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:32:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I3DXMe2E;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aYEo1W23Qt3/z9qP5zZwvLKl1SiIVWxsyG4f4Y94pk=;
	b=6N6BTZOg5t+J4QCWOoadyFyKEdMu7vKifD3dYIauWio0mangCo9OWMUIuzTZZEE/mMC60O
	yfGcBkTMgYbEsM12ZEtdReSZsDrMXk1pMSUqCcfHR3jNtEulTtt2L/K6Sih8jRwnsDnzdE
	QjNn4pk6Q5vaXCID30N0KVmqYonPMXg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I3DXMe2E;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483576; a=rsa-sha256;
	cv=none;
	b=BU2xp4qDfGIMBR4qvJ+VJDExJQF0fNisYLeeDV5mBQI5eByWcSYNhblPcssGtbEZ04aC97
	ssd9NQ/4NtlZAb1TXOLgJMdKDVF2JUB60SeenGZlntKLfU398ZbfJnaySXEQhwj7Pfq5gX
	z0beK77qOdVH6artSSWRkQvsJyVjRIA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6D4161335;
	Mon,  2 Mar 2026 20:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C565C19425;
	Mon,  2 Mar 2026 20:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483575;
	bh=6he62HkTmrAJJK1V+F014fP6cP4Uk2TDa7mAcm5F3PM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=I3DXMe2EZLLgmbJ+4COsXB7QmFoiqqwBMZHBERmgMBum1GEmM9WBOndN6QOxNrTa6
	 XodAOBXKzRxZqLXzs/LEkDIQwz663dLxlCzXbT7ly7Mjq4OGMQCOwPLr6PqHY9OKJR
	 6nOHbSKj4KRHm3p3+DKRAe9jY/5WHpG4Yqq8ZZAfvQ4GfxsD65XDTnSyUcFO4wf2jy
	 mIDrGEFRJBRURxhU0mTu8jVk0xVVdDZe3p2nzsNKB+LpyYp2fQLz6QYL0Uy6cUqpBG
	 UQx90IGGFTeMYJ8B5R3SgVBVkYUm3YI63u6Ngwh42A48ZsoIXxLzXwHjS96ACfHe/H
	 RbZPpKHHnn+zg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:17 -0500
Subject: [PATCH v2 033/110] hpfs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-33-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2981; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=6he62HkTmrAJJK1V+F014fP6cP4Uk2TDa7mAcm5F3PM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH3QkUy253PqLXrCPd4bzHtp562xc6o9hGTd
 APWnnkqD92JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9wAKCRAADmhBGVaC
 FYuCEACCUfWHkYFuIq/9X5eqdFwf9bC6OV9r2Q3T6m28PCze7gl9TRluZli+IW3JCUNHVTnyjs/
 dfPF9HSuq0C4m5hhDuABwyUyWQ8Vm7AA1MoL6wZe3Mg6WCS8BxDfT/0p6J6hziiAvdymvcPYhia
 7Ap1VKx8lzJbTNe8L459ylLmo6bm+FH1GJuiu3DH3iMZ9idxhXDOEB9H0FqKriyAGjeFa6UVdHG
 qaxKUVm5cjh/9sahddb9icD2E+MVCzRci8C8+/QsgL+n1gEF+t9JKzg2qvBAwJWPBNrUYXWSLru
 7Yu2GrxJIJiVxs7P8S1bNp2PQBtpE9cOjcL/DTj/yGqXags4FDoZOmjta+8CUrv2EszWgQF43Q5
 SMRNoHT+8nVlCGUeeA0jCCrQ7T676Z1ML5o7lugaNKq3RE46ASPtpNOk8Qlmdez9CCrT09SPRAF
 1L7T54i0wH2e59Up8p8gMQVpBAPOZoLiytzikLWjfTMDiNr10z0cjqnlxLv4jvR2jVK4BlpEoSM
 GEFxdU8OmY0iiH/4/dGejJX9qkBMmuQscoTYADycPtHI9WkpdPYUM08ytZU8Wl28NJ4bRv9dIjH
 abldNKX7F2qN//q04f4/za/Im6dy66lMRpWX8m5mEG1+6CCjLsut0spC7foCfz1fcRsLWMOpeEV
 NKzahrEAEsuxzGQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 6105220007
X-Stat-Signature: n679jumwyawpkau4dkfaufkrg4mg6h45
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772483576-871954
X-HE-Meta: U2FsdGVkX18DYQGmz5L/dG3rg/rgemWeZ0tJrA4nsAhNDx5vJb8So7BHjmKFpZ+pi338JO037antg9RPhlip7QzUnjTsJOVjR/HKi9GbeD5oumTyVpOb7B9TgoF6SjUPWK5cP0DRLZVPYnB+fLkn3ZEPK22tpIzNUgOgZxEv8uT10GCqsZ1GGeNIceVnA0osOUUuSKr3n13fLV6531eE1bYpWA3yZ0gMytI1whr9uGyMtFiAQ/9X8kkcanbl/ZjfswWnd8OrIF/Bx8Yz1c0slRgU+SF63+2Px3W5AP+p/8fyUmRHM+M1+3R9ojMxl2Dpkq8pxx6wvc8mfV0pplm7r26t8FjcyktnchNTeujT99RybfqtMZDiGWsXC0/nZtWGG1mBxDX2bO5fFoQdRuF4mmlT8IW4gpd/zdvN3PN/qv+YL/jtARybyC/l5N1oOaqG382touhFNmoRkBhoNbhUwhlU/zI0kVaW3VUZoS5fVRBSoXqjRBU/y1oZZmtrPhxSWxbUZDB5KZa9WJWJ5Z6trw60Wf1OemBc8j2rtUmPDW2gBbW27Mcz2Ibgpg6bnNqNyqG1oymNzcm76fAcpQoJ/+qwNwFr9ZVTKG7Qlv1CHOIkERj1/+GtcJymt2aGj1hBbZhdfJFRO6rW0RfIDcy8XVt0uCuT8O8h5X79HyTW2FbKrdlYJ5ZErvdf6cTqNf8okiwhCQa95Jbsi+XP9SSWvHPjKy/mi0jqwA8mm3MnjHK+6/Gd7Y+jPJqYTlpenDsN352yl8fKzqILBENtm2jIbraUDbBfHnrXQCA82N4LMAFSjRDa4hwFmUsSvzWpRmf839rfaqOBwa/V6W0jxUVkUcGGMU4Z2TNRVEUCavtTnTbK9SYHBeRZPnx/IQ9qD3BwTVdE17KO45K/ZCAFpTckd5ROVTzq5AZSIVuYXCG4LHvNfiGfpmojE8xHXui5bx8LQvwt6Wxz912aUBDuLj1
 NO+9JzoI
 QcabcHGLtct1QF2XklW7bOa48jD3b3V2wcPCoj07gAoePU7BzoczQghCAB32OFCqtfI7q3hLCJ3LCGmYJRPSBFbB1J2Gz+TKuPAyx5XR5tSuExmhRAbqNpRspn2ZAMKHR9x96WJ4OAILeniU5HU23uKHMtNwtREf5RnGpi5wlX9FEqml8MzFafM0vShD5FTNFp0dDhqrpuaPSsblhHVsXcOZqh6wYTj1krlt3J2yFBt7wpw+dCu4yiFmsyO1Nh2+Dxa4HntRdJMFdIjRi7v2ucSvP0k2ihc79owSS6NcLQxIX3sOigDMNWwspMJ3RIm0LutVkbmp6kmWNrSfQFaJ3WnpREbQZ5NhUkkJPLpzb0a6oQ+BAKuwNh3JCpIBTunGQmJ8ObjNPIU73DgR6xizKD0v7B2qTLtPJAbNfAuK272b3TBGkZASC4MFGS36TX17wfM4wlx3wmpwrGRpKeBYgLx7qoGx+1mbR/pDNsabflRc/kHyALGS0FuiCZJyUDnTdShEUZJETwtfbzmumG2AfRFIL7PhRPCqDjehasjrYT2EnqdvqPOdmhsGQ9M8v8sefN73HBnNtCnqDVnt/Rh/sk7czF0iRs742rscrrqvlDUi+eylHgIw/T4jPp3W9HXl6gnX//Qj1pVwWFXkaur4ZfJVFQZurJJgZQO11c7THLx/mtEpM87mFBL/QKkGhRVc6bqTkmyYZXzAdxTp4Wa+ajrjB9Pp8+p+yzd4zN6bOauegZPPfvY04wibQFj0H3W9EYrZtZaTtqXbU+52tox0OqWEeEa63looTU9ziC8UWNuuavGh/ChprA5XQ4pflxMSdtfU4sw6GQK52XSd99ZQQ8J8k3sAalPgMa3OkpI82cbtbPLNVS9GLwfKwHiz9mEdMpcP3U7SMe2TSmpKa6PJ+wcjp08fi3O2IKDKNYA0YLS3ujeHklARwgXfYy+gTH7Ujch3oKnR5FG2JG3/hXrfLzUEfXZ5J
 kes0UsYj
 w57xBY5czUAMlNtTj9n6sh24MVNsLu0Hy6bYcsFkgLZuuEnIyGdvQQxN/BjIKtKsULFnnlOmS7YWC+bUddYSZZ6/RaHdKha2FmiywUAcShYr+Wn0KltynI2bnaEonm5Xd6LaPCnRRZ9otVzhJG+2BQeRX/o7QZBdQ7WJrsO3CrN0f0HycVN1VhkomcIbCVu4Xiyu/0N9IrvNMSHdtJrYur7wVSuvR811Uc2jtMugpNpCnhL99gLEiaNTJpz2DzktsqPs2oBW4OROovu1il+YjMtUl2OC/OHfcfUzoTImvE4hyyQKjCV8TgCjKG01IZytAXYHl6HqLLgitC6bvZg+8HqvuzRMi8o5XiDhjOlZT5ej7lahBbS3LcweeSLgi6FZ2jvobKklKKraHJL9dgKGnhDzc/I2pUoEmRDRSVMbe27gbDL2j+6i9Bzp2JWP1Wv9Fio+euFYzzof6L8xB2ge9XZavon8EtNBRTlDOZzevFN3CGhZacFNoU06BYEfu76VrXITjOEcnpz8vEMjBxDlGUlVjM2WSf7JdvcwCs8dNN5v5dbCujcGbChfQ4tw1Woz/DyOUjCqnbkJzfdH+4xmKHr91qJdp8ywI0H+EMn7d/pUDWIC9vEajNwcySKrQUwIcDzUOp+Mz6Uv7GyU3IZa0Qfb87myOpm5JKOybJnKpVW1iECvjG+YZUeizsAJTSlyYcWJOj9YAKIzqkSnDtdCQMD/ek6C0qEdfIaFNOb3Eb++SY+rCLjPLnB6QwbTxndAExa5Tw+7nJL2fRqoFyKu25UgqPr128iliQTFi1J5OtwRPNuGTxCRYc8zKItqMZQWd8j4NHaVU0yPQGdfSeZZMRj5opQf2FwDSbMo5nGvtUmq8zjq9jxZbRsv4ngf6LVjsVa9z3IZJSB75Ln6fZ6cvE7EVaVbDPaohVuBgiid+j47KD6KDg9Qet5nmxJ7DgF6XRTpd+2CCygZmU7TtaHPA/DQ6+MlW
 K6rFc8kp
 WL9HjJGuFJmeJRcGqidyKPxOLz8WT+nVDu5jkU8M6R7kvJVvW1avo/wW+3EwhiXWDRnq4PXph1FMulCWyUq2f71Mg32wEKrcYO+FqzEdv2j9QF8zc6hMYVxU6vQ57HtshGVrJXz1PNQEIvXAjC/lcJltdDRLWAY6BFxwSDADjWvPcC3nxkRDMmAnh7lDhzBHiznFUdD2VH+EwO2xYN7jD+VlMh6Vch93Nd2NF7oCE+JGIgkwHuJ2ZMutHgtTJxWbA+f2JtJJH54lHQXhd/y+YeAJG0An+wcC/X/qki1zUEgWJq+rdoyHb76++hTWYHxN/BG/ZGq+DMLcKabdCkkD5I/KrcHDSE41B1p7EfpYrnMnuYvjc1XPWny9YiWzeVaaT45hMTazCVkPqd6mE3+/551JXjSQg/A7I9syyakSfrvD7fpnaNgZRhAlYC+9Y8jzp/PqQB4wODmWA8iksRfWiayhUuBQfHsoE6JchBY6OcSbM99MEYKa74TznTLEiFrBGBm8Gizf9MlYxJBs98T7EJnuqM4ypNlFGlT9i1YsAfxjQ0F4NqVpcN/Rr2NtZCN8ERUAdrV3cUHZk18J59330dJGZ3+xxKT7qAaReock5Re9oXUh8a3q/24K7eMpiHmBAquIpWzjg8RH4LUEORL1MQoiTXsilJU6yVR4EtGJsAYapPReDjh3kaj7rjGvydOzxHRVEcVgDtfKIHLcmQ2rS1c6oujfcPxlmyZh56sxd4tssrTDdJLklWO5EQUreHi0iSvwyiGgnzWT6UwY9EocVaXdXC2qbjeB8cqt/Su19F3BUWU5Lc0B6+Wbg+oH8ZSlw5XjRpZf4HdYrp3zkI5AuTYyCUd6XErLIO8Yjc9PEZ7zkzTZyVMt85Ytz0T/i6tOzJOS4sLZdCeCHq/h+fNsWx9aX8ETnEJaVWFBVgVPzWEXxumTqUvJk1jZmVn1t6LOJuCm0/+wpc2cyRdaMhqILJnSw2J0n
 QQDuavTA
 eWcL/v44BvmpcEzNyj+t6Z/yzESd28H3EeoHuJgBcxjGCtB2igpu9tw/ZU9j9aNmiYlhPrwxPoZP5IGrZoDSJWKCvG4kvPRdGO9UJs1vERugxxOgKZ2vNmqdi4bw3sOvvRzdgYSrH0twIy0Ih562Qu0hqTCAM4CavBmX+pf5r1ME/8O+lx3TKh3XahIJ1Lq5tvrBLkfseSOzLMOU+x1D74z5V0loQTKhHMl8Cqva2ZhZe7+9WpL1Dgbz/j31SpZg4BKssbicpPtjWHsNwo75xYo/PycccunBOuOGy0Le6ZiKCSVBvCKI0w2uPH1OMB39F5+kVF8ZsRWCKxWl7m5iddmHxIIubHl+LRg+HluhKurWl25toUAfnqM8R1SXDj0cpDtQGLereWzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert hpfs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Remove now-unnecessary (unsigned long) casts on i_ino.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/hpfs/dir.c   | 4 ++--
 fs/hpfs/dnode.c | 4 ++--
 fs/hpfs/ea.c    | 4 ++--
 fs/hpfs/inode.c | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index ceb50b2dc91a9da02997a40836d6543786d883d3..9db0e7a101c2a8d9cc265c14ed74c58533ab31ff 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -96,8 +96,8 @@ static int hpfs_readdir(struct file *file, struct dir_context *ctx)
 		}
 		if (!fnode_is_dir(fno)) {
 			e = 1;
-			hpfs_error(inode->i_sb, "not a directory, fnode %08lx",
-					(unsigned long)inode->i_ino);
+			hpfs_error(inode->i_sb, "not a directory, fnode %08" PRIino "x",
+					inode->i_ino);
 		}
 		if (hpfs_inode->i_dno != le32_to_cpu(fno->u.external[0].disk_secno)) {
 			e = 1;
diff --git a/fs/hpfs/dnode.c b/fs/hpfs/dnode.c
index dde764ebe24673c339d4602172618dbf6ca0b5c9..5df10c82f84ca40c4d65b97b6c6b61ec364029b5 100644
--- a/fs/hpfs/dnode.c
+++ b/fs/hpfs/dnode.c
@@ -550,9 +550,9 @@ static void delete_empty_dnode(struct inode *i, dnode_secno dno)
 			if (hpfs_sb(i->i_sb)->sb_chk)
 				if (up != i->i_ino) {
 					hpfs_error(i->i_sb,
-						   "bad pointer to fnode, dnode %08x, pointing to %08x, should be %08lx",
+						   "bad pointer to fnode, dnode %08x, pointing to %08x, should be %08" PRIino "x",
 						   dno, up,
-						   (unsigned long)i->i_ino);
+						   i->i_ino);
 					return;
 				}
 			if ((d1 = hpfs_map_dnode(i->i_sb, down, &qbh1))) {
diff --git a/fs/hpfs/ea.c b/fs/hpfs/ea.c
index 2149d3ca530b6f635ff884988383bdde21be5e7a..f4fce87110d77c6af47fd45e024fb913c09e82f7 100644
--- a/fs/hpfs/ea.c
+++ b/fs/hpfs/ea.c
@@ -245,8 +245,8 @@ void hpfs_set_ea(struct inode *inode, struct fnode *fnode, const char *key,
 		fnode->ea_offs = cpu_to_le16(0xc4);
 	}
 	if (le16_to_cpu(fnode->ea_offs) < 0xc4 || le16_to_cpu(fnode->ea_offs) + le16_to_cpu(fnode->acl_size_s) + le16_to_cpu(fnode->ea_size_s) > 0x200) {
-		hpfs_error(s, "fnode %08lx: ea_offs == %03x, ea_size_s == %03x",
-			(unsigned long)inode->i_ino,
+		hpfs_error(s, "fnode %08" PRIino "x: ea_offs == %03x, ea_size_s == %03x",
+			inode->i_ino,
 			le16_to_cpu(fnode->ea_offs), le16_to_cpu(fnode->ea_size_s));
 		return;
 	}
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 93d528f4f4f28d5070162faacd65d3fc2341248a..c82f5f7f435a1a6f6c26fc62ff0c680c26c9f4ad 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -250,8 +250,8 @@ void hpfs_write_inode_nolock(struct inode *i)
 			hpfs_brelse4(&qbh);
 		} else
 			hpfs_error(i->i_sb,
-				"directory %08lx doesn't have '.' entry",
-				(unsigned long)i->i_ino);
+				"directory %08" PRIino "x doesn't have '.' entry",
+				i->i_ino);
 	}
 	mark_buffer_dirty(bh);
 	brelse(bh);

-- 
2.53.0


