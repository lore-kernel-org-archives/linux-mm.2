Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C7BEEB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A3306B009D; Mon,  2 Mar 2026 15:32:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956446B009E; Mon,  2 Mar 2026 15:32:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843366B00A2; Mon,  2 Mar 2026 15:32:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 71F5D6B009D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:32:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DA5C1C14E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:32:29 +0000 (UTC)
X-FDA: 84502270818.12.BF7DA3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 908E71C0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:32:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EeqjF7Mo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wepF4eEjwE2Uv4X5oy60a/bx+6Rq+2qdSDmK1U5QKc8=;
	b=MWUhzjYvbKXu3PKo37j9JsiDQBHWYj+mdQGULc01ZW7ncnPa1KusEDiAqbkd4FkDt+eo05
	XL0JbeJiep7p6wlBbfBPUsHLFLTm7BWL4ZpuQVufz+YsvpIDTNglpLIFYZEwLeA+qHGVRY
	8mUa9xftCv38guO+H54pLAdCJts8VdU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483547; a=rsa-sha256;
	cv=none;
	b=XrQTpccDxhkJ8O/BszarMUjuSYlSIjpTogRwLYkmO6DL2R6qtO+QPf/iZM25LLsAuw8K28
	TRJFMeYy/lEEQCzplUeaVOw+GiDL30H4kOSqvrVNapKOo+//3KbHsuCCJAIsy4W9wmZGDJ
	/AYObPwLoc6uWSN+0WlsNEt19gqNiOE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EeqjF7Mo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EDF646057A;
	Mon,  2 Mar 2026 20:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862C6C2BCAF;
	Mon,  2 Mar 2026 20:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483546;
	bh=4zZLVZosTMapzlnQbViChZRIJwQ1YxnweV1e0IzMxKk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EeqjF7MoRlh/kOdenMQlIQE0g82iImB4Uqc17fvZNGHc9MCYhZRKQUrzHwrNeRq2p
	 BBd77tlP32HU+4aiXzIYfNufQXBt3X8waKSDljOzULdc2ZzPgaNbJuziGiAeIjrdwT
	 DwOQXm3XqIrKfCh6JfQAi71zjeYrPS7NwYlDS54RXNALxFlh84pcNKXllQMlS0+rWr
	 ObIc83qr4E1Ng8CJup4HLyksU6saNDa39jLQWyCxqJyFgFOMzbY9U3+kcB3HNXDaoI
	 S35PTiTtQsrGJUXNbJoGHIJr8oB2LXx/1BDWJzcsUHPVjDCcrGKCuxlFpzcMVIXDc0
	 8djRYyhYmSagQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:15 -0500
Subject: [PATCH v2 031/110] hfs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-31-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2637; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=4zZLVZosTMapzlnQbViChZRIJwQ1YxnweV1e0IzMxKk=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH3/7MIAGsUTXCwQG56/sekwpotJydX2UJpS
 A4cYEttsOSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9wAKCRAADmhBGVaC
 FQm3D/oD/nBEETcBUTWgdz+XCetI2Fr0jbRxFfuFvOIBZ6EGdtu5UWMBtyOxFVVjs3diIrb4PTx
 /M8z8MRQrujiBZ4E1XZeTgynSueGxnTAZdQK3vCRI9BrRqRDs+Yqxyg5LgkCINzS2rmO70woRVw
 OsAptb/wdU9AQLyMsGwgsTueVaN9omGgS/50G3uN/3cQm/WYKeCClkRPGzRRIEfIUKtmQnNRhfv
 C1HTPxtq5w+ThSVEdCtjAG8OakcLP+cMFfDX4T6rBRIFEr/N95umFouZ0cHCjabDE9DaxWjhtm1
 BrKedqbNpn5enrOcdwU866m2oqgdji5QoHO0aBgHdXGHjIKdjtC8+NxylR7FqU+p1hFOZQCzFQK
 c7PLmGif/brK7rUao2mM438Zeh2abJAZXdMKrguZv1XVRWcO2XYGS4Viptsjzh0rzDfuTY6d78J
 moge0sjDLD+JozJi7HqQNserJ5xdGDzrmj2Opw7TMXfGsZBX4gaZIyf5iCGi6BBn58ZI9fT4bFt
 G8dW3lXq3s7O/GNGaf7/QQ35FnNZP86XcmMYGbHbET0dD8V/ps6xfb3Q8rWCfYxot7GEGOvelP5
 m546feb2CKU8E0nSiVk3DL254B1ZNgEchgRGxtBtn2OzKVLBwwPIsy59/W+qr77Q/YZosjsT5qQ
 YzATlmVEc4NMI+w==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 908E71C0005
X-Stat-Signature: bg6xpqbbuueof4d5nf7q7xhkhguekm91
X-Rspam-User: 
X-HE-Tag: 1772483547-212387
X-HE-Meta: U2FsdGVkX1/gw26VEGrvda5G/+7RFuKGquj5bpqF9DnALmsyZt8u1vv5+XBlzQOXAoug+v+nw0tZ2dPm7Mpc84m5jKWDEHWU0enPYA+j2EiP7Crnza1/LCbWsGg+LdC6rGX4w85/STORLWZRfHQ+AP951A0fGXTzyrxhwDPN67lU3aa6M21s19Z1OKdzMrJ1TRt7y6lr0Wq8sW9dH26pUI87K5Y2Kr3JGrE4y2VvxYbvP30nnH7r2nvvlyGZb3DLHO+R62n3ltWnWRbcyHqqBH5hZcvnyUOQBkv+vKyM1jH7cONWK19qgTSJVucK9jLGD9/2nO6Jl0pLu0O1CNeV51zDlxJ9n1NYA9b7t3cO5V4fTTioLAHtB/GFTvUenhMTUau9/wJrOIevKR6WVPmBSeu4CRsqNariirFYBuyKFXOQA9VeioLbniPY5od6zZLSJTWWGs1o7YmzRQxRVrABFDYw+PoPh6PcpsHWSvQWRCGPoClr2jfU7mZWESX4nhYlzO1zEqDVD1a4gQA95HwDzpmn7zfXjIHgjpoBBV0xLTYc5MTRzE55THDPTJM0d551yxXkWrod4hEP3aEcB93H5x3h+BvRopxURoGCsX50YuTR5acBKEJPu3/pcDnFSrCv48S+MpRNVA8U7O099/CV/NmDxctOOha7tWVOWLG85c1j8MyaGuqV2RbOWq1XIyCQ/aFBbzRUwVsVwTpGUeyPrWMnJpEpd3LUTTWfF9COa9BYulVLPti4IPCqDw0wWQ73rFYiYF+xuuFoT6BKKGlxw2e58TXnRN1RgJzaiZ4Y27ZIKbkGZPCow1EtOU5AF8HUzqkSwaeDnQxyUBuYSFoy4RHVZ+K6UvrdSSXglPD3CzLbU1G0G17fUAiGeGZYHuGcHGV7PSnhJh8YXhz2DyzK45AVlzfcnMEJLitf31z4D16IhNtVtoAbwbMyA1Wnrb2KTT4xVSxI+lEamnhdmik
 ALOJRGdc
 XCk50F6Hq3M5jcAuelDhU6amH1/oHcLvuO5VtxWCfCS05UB1oghotxuInfIXe3UiW8Ly0w2/cxmvh72N5uhXbYwpJl6bD0AU1Qgzya80wRn6LT0/t62U+FP/YRN+JBaeREj9SDIOPRDLWHhwEBfE35AjkfF3snEARAQ7XWjF1sgwBs6Od8XfiGM3NisW40MK1dHpfdLuClBW3+0lQPEN9Q5g49gmvazljKzANVBXYA4bN2kaJgcc9dcoUN5QUkcCQIKpvbuhVYxpclpAy37+TgfzzTYxx95vP5HRpppRqq1qsVkQ5AxI2gL/4Gqib5rEZxgY5riww9MsUV1NLH5GVR9camtm0671ZfQRfVAKZ72F+ngtiKxKXahwgB8gNpky+QKOHioj5NsiNXfcvJZwu8NWHm5wyULaIh+W0Uq14mwsqy5wcX2Yp4DK5rL/Inxqbuzw9BtPziUt821vkWqRqB4TNr0ipxPXJWbLpielmJQGhJbM6pwAAtsFCmIvLn3EbgXY5TszW8BKbBDG2aUhxQkPmihUfQE+f4G0s2fv8PEoRjB0c7gXmk9sZkpapwEUDC1vM/P2EDChARSoABezoxl7yVrFF2oVgzudTIeKCqab1VXDIW6Lf8HJ/M4x4yNt2nHFV2gO7ajU5MucHFHtenV6fuLRqeWkeZejKaR/euLvIrjlCUZ1pSonVQDnGpAmBxrh7pgCZcOe+TwI34MOWLPk02l1/Y+J1ELoIEvPbEH7p8CjT4ArzCT1S6YLSrUff91mDX8VnqM7HmhStNniZATb0RJ3Us3OdIp/K0lTFR34rYsJIdPYLezGjPLP9grzPDm/takjvQKSHTsN/kOvpZhn3DfCchffVK0KJG5HCnx/dc0bfbdivo2cDE1YDQdmm5liYEJJdJmvRs1ceFgHRAy1nuXjgICqmwm0TUlqDiA0fEs22Q+CkVF5ACTBGx2DlHp70QWnbqnwp6SR6p7VZpDfgBZKI
 Mo6chIa8
 58pqSaFLVX8sdn+4heI8FucmQDHnXjPvtHAX7YJM6dbfuw7S9Hn6Pa9nQv4mUtiTKsdbMPSIDaKndNm+4BWZXxpitTOT3rwMwmQcldIBzxrOy1VjAikSFUwKWqlraI7NYLX/AECFNb2nH/AhGHJMZwq1iXb/9YwBeVQOmX8gHXm3dyKb3tppOZPWM0vhABATiB31J0hBfLETlvbgixyianzsEbsNYsyXYz+k57oweVlrVunLXp8bLW2JBccUUeMcLbDLgiJlrSbNleCrbt2oMjIOLypQ5VzMkud1YfrqvQgv+D3GovK5xQ7176LVsOmo1oHiDTHAht40eINj9fSZ9oMUNweRcbkMf1awgGRHUNIICaoSMwH4ltqG7dKh5dY4PyJAoMwqLDpwqjNyLWv8PtJ/XOv9I8tJ8ICxMH2fIH8lQYjy4sHWtOQ2glz7mGVAlPkVFyTZebP/l6NzlNU4xsdQqL+2SeiQPk63HwBQpKwAkQAvcNHHWjy/u03/eL1Pk5a5EDjJStyNl+uCb3JrGWdge+iRrTBDF1YyF6/hpRj+h22uHKQwcC27ON/GJGZMCtqsDXEzeJXZNhbwimh4/iW98ZmOXPi8R9fqwcobmINQv0cAPu8k4jCJcInmonNLZ94bPfWs95rnu3lu0xBLpXkfp790H/0uKXPYKVkRnlRBuQvkkdjxNGZgw2gGZ4xvte44I/ONsK2731W7kRW/hnNHVB18n9nH8n9mGxDvjgBxPv2Hxf+gdPWRA0Mbc4XTu9eg5GoZgexGBbwwt8ouBiNQop/6Njz9JjhuRvu5/cg2p6ttT4HTk7K8OkKr73HweKS+B2PF787eaInoOCIRBy+lpTwmufk87SSBuRJiwD4IjNFd9al27YWFKNGhXZ1w5CPLDCCYzSF9a2n0IDVMEuJIuL5U44gnFXO6a09hnYtjATCFV3jkZiLzatSeqAvvR8w7XTqhMrKngs+SPAFDCobIOAiup
 QjWVfKJ9
 akQNtaug3CUoX/DDa/YVIrNMYx5t6Khk+OngS6z9zs78GwJrnBczRd4u71hs+ElS7xQmkBySVLdidroTb4cs0sxAB2yK7C29jqQx/OjszL0NCKguqsbeOIM8JgfQTYRTT0SKxrbGbVGocesFS9UHpksrC452+WwYZx7dlqswQ6MG+Y3ErF2G4yjufG/spqyKUNYbLyX60KnQ6QBjUVoVsldKFEkt+9F8GU960mCvc64479atplX0sAo3BeFva3aUOpYXVXeMYiUEPAGvQfxpTPX01yN59hmrXOlz0snTOWPJrCCH8xsUZ72DyE55CCc9jyS3++uYufcSVkK/VqrXuQ17S/bE+27x7MZezPBwJWEIWyeKIfk0BRcgfUfQ50rI6k9NcyhMQdNos3UH5fXi7WfJ1roIVoyXOZwqCGYZh24NDnVfUY0pgrxmsEQvwgxOvdmUvjKpgfve8f5ESRZz0VfwoTfvEGAidCyWlY6ecwK0jSqktG0ptorr7MI5SNoueQAvR/+g39XBaLyc8VRF42PDOV3gUMHqzRoAbhIGOImIU+mN0/lt4otuRRqXPHp6f6JKFZXBMZfE4onL67sHYqos4mZR+CW1KPXLX9tV8soNGNHAQ1uv6U7aqPhOyEeE1U5twWPicydARhxkKrdCb4LlNhSrU96tEHrajOrhfjazcdGRUiJkYz7Lck9C4r3TRshZkCtTAjzP5u24ZPzUShVg8RHwIVf2HsPIdbC/P5j2/0BGxej3QRU7S+a4sAB63Sz1mIc+pVmmsrob2C3TwcMQYkjHgF/TAwkgvgVOj8nT4ZXbfvZTYlrEPqixbyOslZ20sUFPMB7kOP4l66ReTOx7Jz/3JJgc+JG01thzpWHK/0UtNcbssPM4KuaaC57scmbgDyV12Zd/7mN/MyWxsr8veXv52+BqZ05ENkujgSIpTfvj+RQyIhGMcbQMeoqrLtJYl2+F4ukYquqfH40QTr6S+wVJr
 zsY3zb+S
 Vits0udeMVwiacOgFT2In8pm7r7euNt5WGs1Kdmk+suty6f9LBm+rffjSR33117P1+xKh7NUusdGu3CmQNxhqURVBu/LFI+rGLPHOdWxxTKvYzZcHGieQ0R00rR8ZTo0ic6kvMDGl0xoNk+r0/KdxgL+nQX3C4pHKZZN3w4aJ9Tnxke071JJPU+ruwljIXJN8nQ/w7uUxmz28OqukH+kTTqCUjVFmoHkzrtGD7spCGqe01HzhBB40qMIAXHC7OQ/SILsztaDKpJ1pmzLkUJpzq/O+0dvnD8dhfEBBfw0+YULgaBxAUQ2dQZtwX2RsreUHDVblhtZ8IKjbIJGGzuLxjR0EGJsxwA5mpPVKJIC7hLpGRH0OpOU+2MYqIk9AxZ2bp6JI2rrtk+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert hfs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/hfs/catalog.c | 2 +-
 fs/hfs/extent.c  | 4 ++--
 fs/hfs/inode.c   | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
index b80ba40e38776123759df4b85c7f65daa19c6436..b07c0a3ffc61584165e8cc9f646de6066a6ad2c9 100644
--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -417,7 +417,7 @@ int hfs_cat_move(u32 cnid, struct inode *src_dir, const struct qstr *src_name,
 	int entry_size, type;
 	int err;
 
-	hfs_dbg("cnid %u - (ino %lu, name %s) - (ino %lu, name %s)\n",
+	hfs_dbg("cnid %u - (ino %" PRIino "u, name %s) - (ino %" PRIino "u, name %s)\n",
 		cnid, src_dir->i_ino, src_name->name,
 		dst_dir->i_ino, dst_name->name);
 	sb = src_dir->i_sb;
diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
index a097908b269d0ad1575847dd01d6d4a4538262bf..60875cc23880b758bbbb5e4b8281d9ee1f2dbcbb 100644
--- a/fs/hfs/extent.c
+++ b/fs/hfs/extent.c
@@ -411,7 +411,7 @@ int hfs_extend_file(struct inode *inode)
 		goto out;
 	}
 
-	hfs_dbg("ino %lu, start %u, len %u\n", inode->i_ino, start, len);
+	hfs_dbg("ino %" PRIino "u, start %u, len %u\n", inode->i_ino, start, len);
 	if (HFS_I(inode)->alloc_blocks == HFS_I(inode)->first_blocks) {
 		if (!HFS_I(inode)->first_blocks) {
 			hfs_dbg("first_extent: start %u, len %u\n",
@@ -482,7 +482,7 @@ void hfs_file_truncate(struct inode *inode)
 	u32 size;
 	int res;
 
-	hfs_dbg("ino %lu, phys_size %llu -> i_size %llu\n",
+	hfs_dbg("ino %" PRIino "u, phys_size %llu -> i_size %llu\n",
 		inode->i_ino, (long long)HFS_I(inode)->phys_size,
 		inode->i_size);
 	if (inode->i_size > HFS_I(inode)->phys_size) {
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 878535db64d679995cd1f5c215f56c5258c3c720..b19866525c1e9c43decf3a943c709922ee8630f6 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -270,7 +270,7 @@ void hfs_delete_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
-	hfs_dbg("ino %lu\n", inode->i_ino);
+	hfs_dbg("ino %" PRIino "u\n", inode->i_ino);
 	if (S_ISDIR(inode->i_mode)) {
 		atomic64_dec(&HFS_SB(sb)->folder_count);
 		if (HFS_I(inode)->cat_key.ParID == cpu_to_be32(HFS_ROOT_CNID))
@@ -455,7 +455,7 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	hfs_cat_rec rec;
 	int res;
 
-	hfs_dbg("ino %lu\n", inode->i_ino);
+	hfs_dbg("ino %" PRIino "u\n", inode->i_ino);
 	res = hfs_ext_write_extent(inode);
 	if (res)
 		return res;

-- 
2.53.0


