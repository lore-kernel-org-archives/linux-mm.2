Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A82A4EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 180036B00C1; Mon,  2 Mar 2026 15:31:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 134826B00C3; Mon,  2 Mar 2026 15:31:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F377E6B00C4; Mon,  2 Mar 2026 15:31:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E3F266B00C1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:31:17 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEAA388DAD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:31:17 +0000 (UTC)
X-FDA: 84502267794.15.FDA2776
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DD9EC160003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:31:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iLDEKABf;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qldfkeLrU7gnCZuk1mHmYsV+gtcZgaz7QUT1rOg0Lz0=;
	b=sxi2ZVC5QLzabbs40SunR6Qe+kmns+YhzHZFjVsjZ21alww8ARurmKu9FMSc/6LeLgWKE0
	CZc2uq8E38IaLuI28mydC3ETqWJmWtTGrhGrNIxGGn8RXLR9bY+nJ76NDvTWhCMbOlPIpV
	XALAQtQ6UFh6UPqqk9rIDFJj+BtUWlQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483475; a=rsa-sha256;
	cv=none;
	b=hm1AgGTc1KzICbHpP3D1Ziy27bak1zzYyEExT099MDf/miRjeWGxwRoBlgwUqsCNoJ+v2z
	8vTbVfKry6Z4xFWYfy73kiDZGipUSAV9QwbeM5bX7Viqr+DftNAhz6Ear3ktKY4Bm2NACK
	vtmX/4NZzRjyoEg1/qbcI9Qd4Aufl74=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iLDEKABf;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32B8260134;
	Mon,  2 Mar 2026 20:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E42C2BCB6;
	Mon,  2 Mar 2026 20:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483474;
	bh=PQs9e/NOjDYQIdekonxqO2Eg+K5kq8v2IBNAbt6jik8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=iLDEKABfnyEwokacyJc+5tE7MW1eGsXyn1cd8frfJYf03nto7ny+7UcEjBahu9oFR
	 w8fNdbnsnvjW9ZKuZO0qPuh/mYfRHsFe6bbm8gndqSI+A2aXRJOnY2wmecb9CiMt/9
	 tLwDroyIHJfyFvkxWEcQ9dvfXLeTqYgTEGWwzsS34H0ZAoK+36PRzQS719v2XPDByu
	 H+zq6ZrpLXRWhv3VDpEqXHw9icIvmEg1krs90GIoMjV3wzrsnoIjNkL5Oa8qV/8WtZ
	 egOWkMJ/rdh2HRuLEAAOqdi0o0N4h4aJAW4/V7v0glZ1E3E8ht1Zm7+2xyCczHE7ej
	 FGow+Uq3khl1g==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:10 -0500
Subject: [PATCH v2 026/110] ecryptfs: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-26-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2338; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=PQs9e/NOjDYQIdekonxqO2Eg+K5kq8v2IBNAbt6jik8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH1FkE5dE7Y0NIe63WcPbRR9LyBnUB7GTTws
 DTP377b2LuJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9QAKCRAADmhBGVaC
 FXI6D/9Bg5yw6mYy/IgYsOpeDgG3m4q68wHA5zFH0nMd6cmp+0K1eZLmFTrlctr7OnYwEIwX6RL
 RBJ8cvCZu3r2LsUy5TqsFCNH4FLZ6DOWIYyC+39C4fAzrVNg8t3P/u9MoSoOMlDPSojaa5ETnXP
 mYaPta1+Bm45AZezRf9ZaNedU9dkRbzDCH9/e0bem+J38IleYk1dmJBbf38jkRt22nvPysOBkq4
 /oO7UaW0ln3aGb/OvFHTgcHv2Hd0P2irky9qeLUlr6IMATSCktEOHX0xWddZZo2Oya2effvUFyZ
 b66aM4WclxeSeJQAH03ZP1EcYs22K100luc830HOC87JarOUbsZyDCE9JhxB9hZnNDlPAkCv3QV
 GDVFO+/dBCoSCLW/X2OCPzTIWWn2nnjdg12SbOktg/zn/9xsrpHDlfNGGaQv8eDFBpBuWdsFTVD
 WRvmsQIgiEnJs0gWagNVcG+/qNGaeGVwNVRmz2bKd8UBXaKfK2MknHjGobTfygvHaivSzucjJvH
 LgRe65ISNG+uUDRHs4boc5s7UzorIfLLqdRc3/aTSfEbIBCEsbpsBwELPyO0TfqZR1bDxV73Ib+
 r33cFhr08IaoFvlx0/xR2I+U3kBsUz2zLZzv+p6/aCAuv3qL+ATLBSZ2LCStIkV69+YiY+fUbCG
 IJKDD7vRoDijdWQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: hacnbz3ywqdi3amou6sctb13onxjmhoy
X-Rspam-User: 
X-Rspamd-Queue-Id: DD9EC160003
X-Rspamd-Server: rspam12
X-HE-Tag: 1772483475-819602
X-HE-Meta: U2FsdGVkX18gTO4qEGCuc1SNyEfmjK83xDHuNiW4bXwJEw7sP6i60iuLX134LrS5ypNGFs4kHoPajwE6n1DdVPCcT6H5L7i+G7i5zMoD7rIFqt589VW3zK0u9h7yud7SB1rrMa3q8hh4AMIHdQJ81NED4IoNUK3EifldkDkhZd+2SGqZpbtcC0VWZQssaxMBvQRcrrlE9giIm7WDMXPx1AwGLcdZtoJucXu7PieK+CZmWac9YdtQhB2kNl9joVcNLyleS/7qUYljStms7y2SrTKcUrlRC7G2e2Jdchkvo87OPx6HwxTdyAl1dziSeJ5olplMc01FUhZmoEpYwdKdT41mZqvH4TLEg6K2OveKhApr0Bw8oxZdChR3LFB5MlmneTzL2cwAAwIYWmpFR1hdv0eCaX5Fee0JtWbwBxgizwjkcZpiVWEf+OlpEQapKz4He5UtgtFqtjkk9zplWMelKXy4tCBeB4QOq144trhIdQiA0Qy2licNNuOUcugG407Z7amkVQaiNsF9QcTfvLxiJ0mOoWBYng+vEgv8gfKjZTzXZdFOHTd2r3Vfb6g38RyDsMKSdqvBAjEaRZfmZwiI7FvpNqHJVkLMLTmjeYGLOZr1O1Ms+aBZi7RLW3QFW7Hg7PBwR0Jb/p0Ge3gdBkysL/6aJjF1L45HR41fmDpuB4t3i34pZgErV/QhdTm30SF4q+8rCTiE+k3j4BHCMzmADz4agPPRwvi8Bs/3ZgJcu0TGRh4q6OUJodHKRP/AsNprMoje01bwfD/+ksRJF+P7Gcij37yBvEvIGEkCjTy+AjfLRGH0ZwqJw+XBTYPOBRVNG+5Nx0l1ePZY8QqWej2hW/y3RkNPUXJPrBN7rDFgg36l5BhwLo3QdLd56IQtLDfAv4V1JuE3XNhRuPI6+MuCJENhKd7GyELILLyhsK5j4wkAwlBmYZnVD3EjuaYqm4k1FWNE5v1BUwXCMnA9FJg
 TfCT4rrX
 rQ0+dcu5iEfxMUiddbEh3vZIK2yCH1Ydr3YW1+bXmSMKQnaplUykihowjVzkW83u234zvWdH3laGGskUNB2YtAfH3aGsFCqp9oFxrVECRtkPNeBPPx+Clw43rT3v023z8tsgMoNVzYSdxqeCqXRpmTg8boWp2gdsFT4Stsd2ESEU14Nq6gMZ7NwGcoKYFwHyN7W1431FxHBWEiMkwIUdm5XFrsfGPN6ZCvGyvgUTGQ7w+YdKc85uJLUBUmpVk1tDZpic/g44kyOspV2NSaLIm9B2rItGS1PnsZEiKtpkRu7nsc6unNrUR66vTp5Eox4h3LswggsgEm3N8vMnuqV5TCXe7vKJ0nxZwScGVIXpc7Fj1ew073msEPwjsHkrUGust5PjYDpdyf7Wug0kzm5f0AsIPOo9eJLpTlIjrIT2mdrE3svCeAZbFxsK09+x4V6055FTwEuN4+fEI01GWzB8Podx/H0eTF1x9BGB70YkzjzmTDMr9dJTJWB/wXiuUKFCR1u7gEW3gkhC6wfFK/FkOfxpn7lg2sORkvSGazsCptGBmQIPSMD+dsIB0AlMKSK7gSezm6RO5v6WKr7LhXKSsS98lgwMR3MqV7AHqu4lr9JL8D3YZqT8+1FXnav5Ny2yvFdxALUuARAtpZiK23WmxEpT5W5nE6VPlz5/6SuT7XDWFqTPfshnMmSPdwXTEGgz7os5ryPRGvqwCCl8p2SL8nRbrVG1eCc8B6SgL4F1lG8SDagBuYZtjhQM3IbqdqTFnw3D6OTbpxDxnwsRvuf0dy3eGjqyckuspXKAokUDPuc62M9Yj2GIOroZxjLTi4F+SzTGlriRRXrMJCo7Aq4o7Mc2P5xbgbsu3M6qEm2POKA5DWjh1407ohm1e5hJYOhO5Go0rJ4yxqX6rkoVCC7tevnb2n5IAqG2P64rFKSHPZZT7DQsEiNFkvu220KQ/JJRuM0M+J3hRU5+k18c+4WE7wmkCam++
 FBQ0c7v7
 Ua7gUTO4R2SxhyxTuVPVfNAW3Sl3mwiVw2Vl9sNRIzGu2KKWFqvEqtLFje/w3NM6I7OzwsJEkHPuV75OGiSA+K/2Yl6rBHPr1TA4NGu4dK6QHi08nZXyOvMfYNC11BEqgdFip0i9BLeQ0p1uzqcnRct/sz1AttsPmKSjxJDMOxXiTBEtpMdSI+vjoEdM61b/L9oXdkwMtzcfEfzkzMJIDzMlH/akLMaWljW5saz0OYbihxN/Q/BBiDO1NLX3yL0aGyTTcRidfnzgrTsuL9z/FRb29MZH9A3eL3BVbpOlKgb2dPQmcX1JTgXhQgTwIuUVKUP4+p9q+Y8AQ397imESEpNWngTpmkGFZy4EIIu97AREGBjEKpCR9hUHO/TQ58ym67OStxer5msBjU2vB+1nUcIl9FqLjFIQawnSx28mC7rxhJAUTyWKNDm1zXKktm47vxHh/noRcziX5evwBgtHWZJeYATxGyuBO6B/ng9UIwRvnS7Gyxw0rS1Z5CVgQea3yGjKiVGLetSZyDoH51UwEHi+I8EjX1sd9uRPgtdzXnwgivoVemJ/zN8oovjtDs6Jw+PkFQcqpfTtYdM13uTtbuc2wCQYwjC1fT30r19jEiqEH9Kjn+MTaRE1btG0owuZVIuELcaAv6MIhr0crkIziQz+f4AClUJl/ROGYs9oBMNrWdyYc8QkXLY32Lwfh1jaiqJqf+5f/1wzx4P4tmXLRtARSk0GL2Lqi58YeP5FBFD1al9Cs9epKNG6E7NEiCbr7Ouuub8nN6kvrDXRG8/ALHScuetdiEbAWuS1x1cJ1+6KXkl9ZbhWcuJsBOCD2AadoiwO5Kr6tRlvTZiZ28iOspFdP9/K4WUtJuigqnh9DymkRhtnCewJZ3TJjLNA0j1f6B1Y2GXELpZ63iyJc9ICQK5ozUtjvI09DdXqNOM5NCACa2UBhK0UhL50KIvV6kzQd+hwHBbTaU8Nqll21DJrCMB8QJPTV
 zM1hWn60
 LlCBks/I3A2tICwbWH43VtiXHwNYc4m2VbOAgrbC/X2VoCtaUiZT+y2tGBioXJ2BKIx3wsPdUgfQBkITcoKN5nLQZ2jlLTnNq4d7jIgFtzEubqTiEbGadHeipu8mbJQwWe0QFlKVqOjL27SW2XpUMmAMhJ1VzWKJjewRBqSdk4aGGCskfWUNUnOQIRVJNArN5td6k9GgI5G80vof89xWFW5KYe/mGv488F5yJSErZqt7pAQMBQrXA5ZNIsAt7WkM1AyN6rJXPMxBHgsYUednVrWq9WR60x/iLJWQMaqKo7yEC70vY4dmTJrfSOeuRkrW27wZsoMl8WAunSIiCvQKY7OZiq5e+UQN7UJJc3P7rG9Pl5URV37tR8n2RFIUGJTLUxl4oGBZB5usqgnXMhBfO3IgU570JSaSExiUrBsM4274JC/023dRGT/yvCKlLXuZk7emMHq82lc7OPBWMxflYvljcnrBStL8maUk6YkjbCek9WTlJEQVHa35lSJ7Pwl0mUmXrtUa51DU9iIlVMonRnFio5EZ2sZmhcXNsU7oYgxK5+Jbhw/tVNPlz/BadKcVsYHfOPDFeQjkGxfITLAdqDScdGUduPSufUvfR/U7byGXn9c/S7dsY8hhpM4qZgchmS8hK4tyTHlZ5rUoMZr04nUmnQPjW9TAG74hpFTHfjuMA1cavrNpEu0JLuaUa9/4sMT6HwPjZCxbRZo9wRbodNrrfMeHscPRx+hObBYkX4Rec+72PGD/VgJ4Z7B5NpaiZ5mZc4Kh/rDyxL7/BjIBmI9nWVQf1AZFC8SFqMDcy+6tiO1loTnptxsJV2dPR3nGM/+fvJ5aOi9IZ6jcGCz4RBhBrdZ3zeMbRJYw7cMS+1L8Utm8+A4IwltnAMstjpc56KbbMlCGvH4lUNGuBj4a9ZopVMdR21Q+8atqyqS3o9e0Yspd3tvZsAdIeoQDpo8fthH1r+90nfVU9lVtXj+6d4ep5nE+M
 AUYWJa9h
 PRmD7jp1vBrPsGkZbcd39R2BqqMmJr5tFv0M0m5q6FiWdxnIX9iQQciXM/HpiWoE3FEhOg9OgvLMdKMgln0J3IzumHAGyQf9uSLRuMWGLxIODDaTFR4E1nGAdsj8QZa52clrBkIOovti2RMVRqtvmeHQ4RFpjO1DRHEMno95fU+myP6lVL7dlCblyopzL7FESWmBBkNwvxMq6RtrOIg/1maI2iyX9MD6NjiNvn6hS0Ow0GNs0DrHFOpNHFmWi13N1+yksDkLYdiZBFzowbyXU2wa8NpKUgp4rjS9qLAKvT9QAxmwNaCumLLcpYdybPrgCQdi+bj/JVYv7OXzKoLAXgsUdmeXFy00AdwcYAu+iJLbFNJT+G034Gbfs3XdLjDSIsquauEutcKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert ecryptfs i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ecryptfs/crypto.c | 6 +++---
 fs/ecryptfs/file.c   | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 3b59346d68c594fcd7e27bae87849d3e19eff56e..015b2e4ee11cba5b734d1f8fcd851accfa8f0481 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1313,7 +1313,7 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 		rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_inode);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
-			       "file header region or xattr region, inode %lu\n",
+			       "file header region or xattr region, inode %" PRIino "u\n",
 				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 			goto out;
@@ -1323,7 +1323,7 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 						ECRYPTFS_DONT_VALIDATE_HEADER_SIZE);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
-			       "file xattr region either, inode %lu\n",
+			       "file xattr region either, inode %" PRIino "u\n",
 				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 		}
@@ -1335,7 +1335,7 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 			       "crypto metadata only in the extended attribute "
 			       "region, but eCryptfs was mounted without "
 			       "xattr support enabled. eCryptfs will not treat "
-			       "this like an encrypted file, inode %lu\n",
+			       "this like an encrypted file, inode %" PRIino "u\n",
 				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 		}
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 7929411837cf5b2e98e1d4288791d2e07c44a4eb..9eff00cfbc46c5fbd599252dcc4434fceafb7223 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -253,7 +253,7 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 	if (rc)
 		goto out_put;
 	ecryptfs_printk(KERN_DEBUG, "inode w/ addr = [0x%p], i_ino = "
-			"[0x%.16lx] size: [0x%.16llx]\n", inode, inode->i_ino,
+			"[0x%.16" PRIino "x] size: [0x%.16llx]\n", inode, inode->i_ino,
 			(unsigned long long)i_size_read(inode));
 	goto out;
 out_put:

-- 
2.53.0


