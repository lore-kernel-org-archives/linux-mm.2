Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD3CEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BDF46B00EB; Mon,  2 Mar 2026 15:36:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79CA76B00ED; Mon,  2 Mar 2026 15:36:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633146B00EE; Mon,  2 Mar 2026 15:36:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC316B00EB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:36:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 237D98B304
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:36:48 +0000 (UTC)
X-FDA: 84502281696.02.BAC173D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3934E20007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:36:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jb0EwRhp;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/ePwxBFGp0TUralj2txfdH1+xp/6GZJxEtnXLo1AWI=;
	b=bJW82N46LkBw4bqC37tE4FQkUr3hODNA2Y4gJfIy82PriYpNOo0/MMQihchA+fiNl1jS4J
	lGXtup7cPV50RjcWQXi/vd9NrPqrv54/RFTqIHaKco8YP+o+3RcwxhxXFPt+Lb56liPePO
	X/NwYXRQD+fV/37LSfBOR7gvlxSQbQc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483806; a=rsa-sha256;
	cv=none;
	b=XL9XGUa5t03/MaPihMzSAKwcmriK+cjfLlm4alhKnJHBUAYuWjMk2pnviZh2z9AHPqc+JV
	7OmcPiGq84CXGCVLF6/KRldIoCp+TdmmcFhMqzXjt7d0P592z+1jukFeR3rO0n02YT74Jr
	lJRzU6AB204XPTFQNP+yyxAXm+VVSV8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jb0EwRhp;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5188943B8A;
	Mon,  2 Mar 2026 20:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E28C2BC87;
	Mon,  2 Mar 2026 20:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483805;
	bh=H3tL61fbWz+6oVu8xWt6IvuT0fFPzYC+T2ZsfuwYtEE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jb0EwRhpHGcE220YDMsWSuPg35XSq9cyiwcFhJQ8siQHLMQWzG8i2y3FoBOtdsxS9
	 /EDw7m1rf0WcV5mtk0FOjBB0zCbpG7g1rtQxNdqr6jhRcr+BbjiUm/sYPWDTSY3p8c
	 IQXLH/KIH0e4kWvqpZ54+HPEHzQaOhGJaPC7QVzKeWNtWoDth/SKHT0Dy3XzCN94A0
	 RaeG5MiKhhWwatscIOBrsa2NW3KO2i2v94MUPvP0MdcEGNt4dFzcNMtV2Qok4k1a3I
	 uxmlDo6F4HEGR6q8t+BVX2Nv0OXZ+To870NHKFm9/QQh62tmbhyPuTdmgvQV/j3muj
	 jte1N/R0jEc7w==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:33 -0500
Subject: [PATCH v2 049/110] security: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-49-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9136; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=H3tL61fbWz+6oVu8xWt6IvuT0fFPzYC+T2ZsfuwYtEE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH7D5zjUk6ZmaUDERwrTJr0eT7+HFUlu3gfC
 gJ2G/7C4vGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx+wAKCRAADmhBGVaC
 FUGAD/4tZ8ATwOq5FhuMuFqlnoBgDgX4KgpAqw3nDkOioCbzRI2x0A4UdyghtBNj2ENMISFUiSc
 Aat6uAxQuXz216zBpHpV0AvGeuW74IDTVEqTkP1iKmKXcM/nf879ZTeWUl9HvtNFB5piLmT0AKb
 USC2zGKx8pih/uyufVImQcZsLvJcWz6RX+jADkYFTA1ttN5lyahaRFJ6EZ3ZJkwCm+ZpRMjFXDh
 pt8C5Cl0GWw4x81tnJgbSYHUGwzPyYnNZHLXD8Wlbkxa/CB4hQNdIOqUkkg/+9UcICK3/RENtoJ
 zqs0aQrqzBvk2AlX1q5OmLhGejCZuGefd4y+2LigaI5FJj5g282DBNppyCEyOipT2eqHAF2Na/+
 KCCMeC5OWo4zMrmypcQJ+kkKUYo9ZKvj2X0Mudel7eLUZ1I0dMfcs1od4E74C2m9jsspDR4JF7S
 lf/NjzfWtH8CaY/x+DvvAlG+ExMGk5hM6kreEq34SLp0ibsAD/8lp55HGc2xXQHfcbeqYseMkyV
 LlXACKLdA0S53mH4jZi0vfT1bOWAwC6HMhDhfrejzvZpXezlkoNVo077BtvVXMHW20PhJ5c61pQ
 74oQLAYB8YWWR7ZqRuTKTXsdcqVx74hcl6wMQak/8LWj2D0dyeMxqws9EgC3tzGM8ct2S5rMvb/
 agR0vgUd1qAypMg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3934E20007
X-Stat-Signature: aeajsgw7iy7ehinnernksr1et78aqanb
X-HE-Tag: 1772483806-89762
X-HE-Meta: U2FsdGVkX1/OA6iHG3xObBV/ovkSXr7WOuafpd9R1dfdzNs10/mukqTogfZVi7f0uO1p2MHV113pIJmqyXlh7qFgl8m7QPQdhgIBvM+dVplLtxkwNKMryUUjatKtdRYIbS0J1GdTV/mvtzyVceDb+rciP48U0RJa8ixoSUx6AEdXWcZX4t+ENZkAVlR9j+jKjmnBepKwvaBf5hVjBTu8UwgQ4KveqcuY8pmeOhVEmmcpkcm6lZEAbMyHYOZH7dDpH5TsjPYJZ3wobhpLZHWmgQMD/Eq1Oy6qnG6nSFnuzSBbwb6ourXgxE+o/g8PdZHgl3bweHEny+DX+Svhc6erXKpsc8GXoeLYkNIJs6h8IS9OjjugULJR3/A9xc9b8Wt/AkS0AgLcwGO1WfAAfbUZPjh7Tu9epRYI3cKfVtCcemZdZznciUhxmbLos7WdsTKfcTs4tIF1vazk4eNPpf/Bq6wkqrf42E4lWN9APYnNxR1f3VhXbe7bMpz0mq6ekQqIsHpXnmBFMN/DDGxzC1csO7SfuArBR78OoB9vxCKSkpmsuyXeUUHpS17ItfbP5fJ85aqeEIU/P1DjGBE4Q8YvOCFA7Xqxbm5LCI2t61Kq5PUKBjz7UGqRM1LE6BbTIfN6bb1C2Wb2xb4oCbZp7KpJAk+YbGTKdHGdK23sY0UXoRcimmcP3MPpd2l4+XbY28bn2xppJ28AriYJOLlnUUKrTwjx5Bs316c0Yx78qC96DdGAlW4hnBydIJgTjXUFor9Da1IERfMPws2MgyiP0SluKtbX34CKoDRrG+26CXrzTolAIMeasjoS+NkCkEvBCjF1re2gD6/jAM9doZCUi3X68VoWIkp5Dp0I4Vz5QPoO2DgNEVc+mw0X4mW3svxjOUs/la4170Df0JfmfhkE2u+A5AjEcNXyn/OvoM5tEBs42MGvSFIopoJy5VB+dsoMevItF3aiMj+iw44qt7UREiN
 ByEuldUI
 ImpO78ac0eGEILvfg+IRzE39iqsKNZsmMVKA5f9VQjsHgMm7XKksRqvRcSuVRdqaXCta9amx0ZPLDETl2umfBlT2QqrgHfoRt9EKydj1zwmxQA8tFmCr1JHYR7HXrvf14Z7+GHIEkuOuL9Tp10aUSp8dd8eoIlWTzQHbg0xQmcCAG/UH4vFgnf7F6FAPIqlJ9GZ7jogzgzpzzxLmUzf0NjoOVQg6wDRalHTckWMQvOmXE4JMw4iVi4AY1bJVkwmabp/ZicyEjB1BkbCkxxXHZTybStyfbZC077881ugndco/goB1Dt0ct7HgwBJaR7KV9bTjGENenVtm2x5J45sZW7jR4wiMmJwSbbnoxMEU2ResHbK2z1uMoTqQEF3gNTyRBENC+2psDPV+2PEjVwO6Yg/Zkbnyw/8qbcqAk69I/UowlbYEC9xQYdRi2RQ6otlCv3JMsA76pRRxPfZrTMVEGKiTl+Rs6QUNZW6w78ONt+mxm3g1GUq3zq4h450zXsKbA54CgPsstBbhd5Pk/cURj46c5OJqZ7boei19gz11Kc5zap6IAcZVC3njpKePAa8PI7T8Bvrc5pKavFfSNIH5suZ3CvLxYDQWYPaNVdV0wYSXmYhnVT9ai2bDMtFehSY14U0LM+nwr34py8Kh9nNSmBbfa4ln4EsA3cWk6tQDhO9xpsByjq6kyQXuI2A+CCpjd5p7pIBjDlBcG3ZI8INLIFxymPLPt4VxuhJ7PPzwDUdLNbSKQogoG0K318R5FpobYbKEYjRiecVtQzKGuyLqjTs6CX6ks7euj+EWOqYEiz7otekYIsn0CyU/dIbytqtaoMnmS69iMn1BWvKfBa8mTTjzMwd/BrzI8YS6nITnqtBqlsVsEjBv9vuKBi0xQARINqHbzD9v7DUsXLo3cWw0O2oJ7j6WveKZNTNekulVDU5AK3Xa13azBqs7BU83zD58nDR3OmlyYSG00SZPsoVgcYZkx6uh1
 4Jyv5nna
 Mv1g4Ug504t9QvFKSk5oSZ6mvHKU6lnsAffwHEmQmDTqW98ttw+oWT8T5hJKsLlg8VfQUhdomeR40meHZtkZ69fta1B54kpmJX0E6IX8SOvo8MirAZHk80B6K9OjY9hJq/MXvwWEKBhRWl1RaJJLspCGowns0KU6HeEgxsDg7dp4FT4s44G6gn24tLwa40gjFj2B1wdtc1MsELNQ3rBZE7v18RUA+wxZS+sFadzzrJKLvQfq2m2YyYIEIUiGJ/C4WujjfqaHk1bYylM/29UfI9FIxPl3U5brYKJL6NniTygGf9q3NBD9sJ6f3NUFGNNqzH6RQgtPD5fhUEf+1UENGA7qzr6JNjKGIjN4NqBG8t65JgCttwiGVYD1g9ablbikHUIG1QFF8t90IoXRZUmptHd6U1p7n0hZrVS3kgpSY3qK6wmveREosZqOuPWjE2dNtTNgpbjYGxWqqzkodvnsuXdpx3GLb6H9rPKB8bnmoeJVBO4c0gUcZSMr9owdZF7CnaNVXd9YMVCFFsaXPPjeg9NdE/h3HxQxU8BaPBHYLt+yHzVrX6ISp3Kdgy4lDVZT+QolrNtVPhMTlp0cHiVnGlwx8RcBOcmfmN0CUWd6sczle0hKWwB42DYK01XjO2pq4ZdwvTX7EqmowRldICZalNi1zd0I9EiP8bB+UTPqeAxeIX6v58A1JCLR7UVbdALYogKWpo0LdcnSK6ZvmGxYA+0qpaUO40qZu/5yvOwCHkl5YFQoFJa51Ppbxba/oLGF6IuvS15rCMyuWJBx/Ai99V3cs0zgo2yO66Qa7dzkL8w8Q2FekwPWPaWlWOcGdt25JTNoG+R2ChNF7cTsuCqVykjNykGOWOSEKHjcdvKimwPjIl4jzuopV3Awu51vV4hjo+qHTXl2muZJ5cr9X5aEI1W/ucW7OLt6PNhu/RcGmZb5zi91iCNW6Mz1unQjukxvWp0X6MYoCicjmZOQsOlcfgqOhuVPI
 9JhcKLyR
 heIAkiRrtBwWr/9mtGTpN/t5fNvuxFMdrUf9MytXgANX1Fr6vw/svdDhV10PvcTnod/aiHILXLBcMzIT+LCqt9MHs39f+smOLgH1QsbkUUhtrXNJAIqOzPsC/tDBljVZUM/VsK4toUxsHs74TUSd2jQLQJvNsccqvJlOQPNsLVI2vhZLnB+JXrh+AQjSJ78sYyuTfbR6armQbB5HFIN0SHILpLpD37BCgkLO34Q/BukZqy4myUnBxgwr+FTvp7+brWB/lxkvpTsRICnWiGlUMMUlnlm8Agg2jRyUibx1Q1n74ualfkJ9vm7JCaGLs5RRgYQBzZMErW4zCz20w9AJIr/EyyCPzMhem825LOYzMMGheGG3Ip2yNXe1kL70k9lraOkn7+q53KYguD/q2MI/7hrP7nfzDcD7G7OvhJQ3XBGWHlzZUDWpGF7xkMIjggiaA9SDmfXiBqsoifiI1q6/v3O1uhW/E0TbzPrbFXWUEZth1d1EisZ3EOxFvb453gMPbaykEJS+sxyCZjtGtDQkpGoejkUhcpmkmU4sISMWLDWi2oenmQpuT44lkrTyxog8M4OtJ6RuW70vhsHY3mo0L4+1RxiQbFXL9xWdg+J+Yf3jGSDABmFNyVolmQjWwlm80mNDugB+QK4JqXMPPOqfi38JQ2wL9562J0DRO7gzqmoSuDo0KtDblHADQ6t93RXJlkAv4FAsLcHjaMKztWvEHPtbNwlfDk0HJ+UV5CgEYK/ISIebla64u362GE+pxab6NOCp1t1w1fBiAdcrRJD2qNkL1LoXvLObmSCu1xYJWnPf9w8aSuPGNPw/hPHIA9yPCn9WrsxAV6JU8KaQUhYeJVrZQQCetIu8ZxV9R/JQtWQaXRHgqz+benk8TKeGfAImYnlR+NbXv9TTxQMyel/gyit5/5WtSK12xXvqDQpSvyV5swT0cYFYDh9xsNeuT/lMuSCCQ4PM4HQx2uqqEIO1d9dGH30uh
 pgld2ctl
 55hSuASU1DW/hyAO1of3+vRlFyAAqQrc8+qw+44iZkERXBAW7LybGQKISvTmKIGG+dUhzRLbwKplE+EVhj0NOIPVDPchDc8o/2W0PpAf0SmTaan+Hys9klkLJ/dHUjUtcZ2AKFYbBnJpqhX1doLFEQgjFKJvZ/ggGxrKVEf2MDJKJVk8PzNwI/4qQxeaIB7uAhMvxjfHNbCz5RwRhgR4YA6DkOEdz+5vcrGiYnKqElQa7Zbp6AvDqf16JhNb44eRDMRQF9mLueHLa5JPco0/xC1k59JvStPmLKKCm5fiSLE52TmFndtcLViSDuZ6+6NVweft7NMUPj4pUs1v0UUsoWldBG/NrNKODPWq42aDa2t8V4w+7k2ezGvcY4ltPEFjtyj11eydrlVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert security i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 security/apparmor/apparmorfs.c       |  4 ++--
 security/integrity/integrity_audit.c |  2 +-
 security/ipe/audit.c                 |  2 +-
 security/lsm_audit.c                 | 10 +++++-----
 security/selinux/hooks.c             | 10 +++++-----
 security/smack/smack_lsm.c           | 12 ++++++------
 6 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 2f84bd23edb69e7e69cb097e554091df0132816d..be343479f80b71566be6fda90fc4e00912faad63 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -149,7 +149,7 @@ static int aafs_count;
 
 static int aafs_show_path(struct seq_file *seq, struct dentry *dentry)
 {
-	seq_printf(seq, "%s:[%lu]", AAFS_NAME, d_inode(dentry)->i_ino);
+	seq_printf(seq, "%s:[%" PRIino "u]", AAFS_NAME, d_inode(dentry)->i_ino);
 	return 0;
 }
 
@@ -2644,7 +2644,7 @@ static int policy_readlink(struct dentry *dentry, char __user *buffer,
 	char name[32];
 	int res;
 
-	res = snprintf(name, sizeof(name), "%s:[%lu]", AAFS_NAME,
+	res = snprintf(name, sizeof(name), "%s:[%" PRIino "u]", AAFS_NAME,
 		       d_inode(dentry)->i_ino);
 	if (res > 0 && res < sizeof(name))
 		res = readlink_copy(buffer, buflen, name, strlen(name));
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index 0ec5e4c22cb2a1066c2b897776ead6d3db72635c..d28dac23a4e7cf651856b80ab7756d250187ccde 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -62,7 +62,7 @@ void integrity_audit_message(int audit_msgno, struct inode *inode,
 	if (inode) {
 		audit_log_format(ab, " dev=");
 		audit_log_untrustedstring(ab, inode->i_sb->s_id);
-		audit_log_format(ab, " ino=%lu", inode->i_ino);
+		audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
 	}
 	audit_log_format(ab, " res=%d errno=%d", !result, errno);
 	audit_log_end(ab);
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index 3f0deeb54912730d9acf5e021a4a0cb29a34e982..0de95dd4fbea15d4d913fc42e197c3120a9d24a0 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -153,7 +153,7 @@ void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%lu", inode->i_ino);
+			audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
 		} else {
 			audit_log_format(ab, " dev=? ino=?");
 		}
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 7d623b00495c14b079e10e963c21a9f949c11f07..523f2ee116f0f928003aec30a105d6d4ecb49b0b 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -202,7 +202,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%lu", inode->i_ino);
+			audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
 		}
 		break;
 	}
@@ -215,7 +215,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%lu", inode->i_ino);
+			audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
 		}
 		break;
 	}
@@ -228,7 +228,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%lu", inode->i_ino);
+			audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
 		}
 
 		audit_log_format(ab, " ioctlcmd=0x%hx", a->u.op->cmd);
@@ -246,7 +246,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%lu", inode->i_ino);
+			audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
 		}
 		break;
 	}
@@ -265,7 +265,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		}
 		audit_log_format(ab, " dev=");
 		audit_log_untrustedstring(ab, inode->i_sb->s_id);
-		audit_log_format(ab, " ino=%lu", inode->i_ino);
+		audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
 		rcu_read_unlock();
 		break;
 	}
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d8224ea113d1ac273aac1fb52324f00b3301ae75..9430f44c81447708c67ddc35c5b4254f16731b8f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1400,7 +1400,7 @@ static int inode_doinit_use_xattr(struct inode *inode, struct dentry *dentry,
 	if (rc < 0) {
 		kfree(context);
 		if (rc != -ENODATA) {
-			pr_warn("SELinux: %s:  getxattr returned %d for dev=%s ino=%ld\n",
+			pr_warn("SELinux: %s:  getxattr returned %d for dev=%s ino=%" PRIino "u\n",
 				__func__, -rc, inode->i_sb->s_id, inode->i_ino);
 			return rc;
 		}
@@ -1412,13 +1412,13 @@ static int inode_doinit_use_xattr(struct inode *inode, struct dentry *dentry,
 					     def_sid, GFP_NOFS);
 	if (rc) {
 		char *dev = inode->i_sb->s_id;
-		unsigned long ino = inode->i_ino;
+		kino_t ino = inode->i_ino;
 
 		if (rc == -EINVAL) {
-			pr_notice_ratelimited("SELinux: inode=%lu on dev=%s was found to have an invalid context=%s.  This indicates you may need to relabel the inode or the filesystem in question.\n",
+			pr_notice_ratelimited("SELinux: inode=%" PRIino "u on dev=%s was found to have an invalid context=%s.  This indicates you may need to relabel the inode or the filesystem in question.\n",
 					      ino, dev, context);
 		} else {
-			pr_warn("SELinux: %s:  context_to_sid(%s) returned %d for dev=%s ino=%ld\n",
+			pr_warn("SELinux: %s:  context_to_sid(%s) returned %d for dev=%s ino=%" PRIino "u\n",
 				__func__, context, -rc, dev, ino);
 		}
 	}
@@ -3477,7 +3477,7 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
 					   &newsid);
 	if (rc) {
 		pr_err("SELinux:  unable to map context to SID"
-		       "for (%s, %lu), rc=%d\n",
+		       "for (%s, %" PRIino "u), rc=%d\n",
 		       inode->i_sb->s_id, inode->i_ino, -rc);
 		return;
 	}
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 98af9d7b943469d0ddd344fc78c0b87ca40c16c4..22b6bd322840c82697c38c07b19a4677e7da2598 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -182,7 +182,7 @@ static int smk_bu_inode(struct inode *inode, int mode, int rc)
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 
 	if (isp->smk_flags & SMK_INODE_IMPURE)
-		pr_info("Smack Unconfined Corruption: inode=(%s %ld) %s\n",
+		pr_info("Smack Unconfined Corruption: inode=(%s %" PRIino "u) %s\n",
 			inode->i_sb->s_id, inode->i_ino, current->comm);
 
 	if (rc <= 0)
@@ -195,7 +195,7 @@ static int smk_bu_inode(struct inode *inode, int mode, int rc)
 
 	smk_bu_mode(mode, acc);
 
-	pr_info("Smack %s: (%s %s %s) inode=(%s %ld) %s\n", smk_bu_mess[rc],
+	pr_info("Smack %s: (%s %s %s) inode=(%s %" PRIino "u) %s\n", smk_bu_mess[rc],
 		tsp->smk_task->smk_known, isp->smk_inode->smk_known, acc,
 		inode->i_sb->s_id, inode->i_ino, current->comm);
 	return 0;
@@ -214,7 +214,7 @@ static int smk_bu_file(struct file *file, int mode, int rc)
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 
 	if (isp->smk_flags & SMK_INODE_IMPURE)
-		pr_info("Smack Unconfined Corruption: inode=(%s %ld) %s\n",
+		pr_info("Smack Unconfined Corruption: inode=(%s %" PRIino "u) %s\n",
 			inode->i_sb->s_id, inode->i_ino, current->comm);
 
 	if (rc <= 0)
@@ -223,7 +223,7 @@ static int smk_bu_file(struct file *file, int mode, int rc)
 		rc = 0;
 
 	smk_bu_mode(mode, acc);
-	pr_info("Smack %s: (%s %s %s) file=(%s %ld %pD) %s\n", smk_bu_mess[rc],
+	pr_info("Smack %s: (%s %s %s) file=(%s %" PRIino "u %pD) %s\n", smk_bu_mess[rc],
 		sskp->smk_known, smk_of_inode(inode)->smk_known, acc,
 		inode->i_sb->s_id, inode->i_ino, file,
 		current->comm);
@@ -244,7 +244,7 @@ static int smk_bu_credfile(const struct cred *cred, struct file *file,
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 
 	if (isp->smk_flags & SMK_INODE_IMPURE)
-		pr_info("Smack Unconfined Corruption: inode=(%s %ld) %s\n",
+		pr_info("Smack Unconfined Corruption: inode=(%s %" PRIino "u) %s\n",
 			inode->i_sb->s_id, inode->i_ino, current->comm);
 
 	if (rc <= 0)
@@ -253,7 +253,7 @@ static int smk_bu_credfile(const struct cred *cred, struct file *file,
 		rc = 0;
 
 	smk_bu_mode(mode, acc);
-	pr_info("Smack %s: (%s %s %s) file=(%s %ld %pD) %s\n", smk_bu_mess[rc],
+	pr_info("Smack %s: (%s %s %s) file=(%s %" PRIino "u %pD) %s\n", smk_bu_mess[rc],
 		sskp->smk_known, smk_of_inode(inode)->smk_known, acc,
 		inode->i_sb->s_id, inode->i_ino, file,
 		current->comm);

-- 
2.53.0


