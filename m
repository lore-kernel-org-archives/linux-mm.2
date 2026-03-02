Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE84EEB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D426B0129; Mon,  2 Mar 2026 15:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1E36B012A; Mon,  2 Mar 2026 15:44:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19FB36B012B; Mon,  2 Mar 2026 15:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 090FF6B0129
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:44:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B450C1402CC
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:44:12 +0000 (UTC)
X-FDA: 84502300344.20.9C103D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id DFE7880018
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:44:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jQmcfG0R;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TqYGICTLdvMKupufJrOyipw88lvf2nIDOL99U+SN0/Y=;
	b=ncgYepN6gChVkQasCUahMkSgv0f42xy6YJjTT2JCAitUaScKjZ5crhQXP4gt5aFhIzf56f
	5cojZov1XFjF77Wk7uUNCQopiaiVvFBn8Tzv9yW/nPNVYL8Rwe4LiszuDYEK2nZHjr0go6
	HAzwOKrUB1wCdjQnWmbyPBE4DOfhfas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484251; a=rsa-sha256;
	cv=none;
	b=BdeVN5DosUYgJhEJaE8PKy//D8IM9vc70/ffQN+b4qtCth10uETyABcqP2Z6P7HzVZAH+s
	alyzGjRIsNHcVoe1WCMbsvywhRAsayifP24y/u5uj74c11fyKTrotjzIARBuauw5ORyeHr
	G0/Y/CazIMAAHThBfAZeZMFPN7VUV2Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jQmcfG0R;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A74E41AF3;
	Mon,  2 Mar 2026 20:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38FAC2BCB1;
	Mon,  2 Mar 2026 20:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484250;
	bh=4w4fA6dhQCNf/APQlOMjiisq4usxy5N0JbGQrOBIfHY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jQmcfG0R/etcu4AtMgMzx+6210wFhdpzx4VBtstHwijAJj1WcqKYoqHi3c823/EVj
	 Ol3vXOlW+2Qb8OOE9xV95XfwG1RNKVkg3U5GT/GCa+j07aCaZQqkao3eJvzjW0kiMy
	 Wa/BWUsqX3j2iqdLgs5Sfl+ck23zI0IPSbXYuvRfNAp/ktx0Xbs772zxKVXp1HG0yV
	 I/95mI2VKXBLL7b5P1JjuZuqoj49S0kTem6ElXk8GHhSY2rhrAqxUa41c3p+snu513
	 sFY6f11xyykIkDW5gFwyNCfFpdJABbA4RO0j6qHKfjnfhsi+ggsS1Ea7ZGD7KWzjbS
	 wBNsB+g4/56fQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:04 -0500
Subject: [PATCH v2 080/110] efs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-80-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1604; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=4w4fA6dhQCNf/APQlOMjiisq4usxy5N0JbGQrOBIfHY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIFUSBYm47jl/gQ5ZybZZz5mjBR7fn61c9UJ
 rlM0RlJ2i+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyBQAKCRAADmhBGVaC
 FbY2D/9aXK0BLLKkuyBGYm022HPboICg++WR7xeq0N25AFYA/jmyqK/9ldEChVQT/4P8hjRV6Ey
 o3mU/en6afvPYKoDsolzdVN5UjcEHlqWfyzrTr7m81pFC8474syuuwKbLbp6e4jfF/aLNJQqpmO
 ty2qbxqkBeqhZQAvg/i56PfIbeUCTFkn4lSm+74r75wu2w0aI9nNO1sAsHGSBLs1vlX6Ct64Hs0
 Pkdrg3FDTaxzTA19bPk5YFZzi59YzBraWmHaH+GD0elt/94yfsdbzCmLpvtAvH4tJ0JvrzbxmsV
 8PpViqm7enuNr5fzS5sUvG2/SrQqK0kTjDsoCsRUQe1pdkVYBjCSiz8UIP/M3yJnxd3eFKFWnFl
 P3r5/SCwkcD8S/ssmV0sdbxg2tskt1jG0nvAdaiotALMlyMxsgj9fqj7y4E5w5B0ZQ2w/Lrvxbx
 HkL7JPjcfvw75xyFUfvqjUe2nG5lDorbOTHl8QhvNmpbvf+U/kxYcydrnnoZoTumiP3MIEQG1nr
 w7uc+AqtP3O4GjJPN4liIyi6x2huu+tBp1YyphFEf7AIldVbKWJdLM55AX7D4FJTdbZ59HU+Srb
 F3X+X96KD3v97gUsh5nT9ALqIEAJJKR/uKUK0hRPaqRDElMeDtSqB9KCyeBdNh1UGG8ofnHxI14
 4JbqwB06oLNknyw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: r4ehjm5ikbejttioxuobcxhxhcjn7x9n
X-Rspam-User: 
X-Rspamd-Queue-Id: DFE7880018
X-Rspamd-Server: rspam12
X-HE-Tag: 1772484250-246520
X-HE-Meta: U2FsdGVkX1+mUvdxD1QIB+RuTPP2BU5EULluspiko3ktrQeSQmGxsarzjnt5XFbEBgJtyhy/VLApljjByXMZhKFj/elYQ+ofKguiFvgk8J8Q7L1p8RwEnk/L5MQwFY+jYfKW1dKI42ICi/SVGT64LE6mmlU9PCKvdHww7Y7fbHvXT+6nckGWPv2CzyNy7FTFHi+o+0LUGUeAKm1JitqMNwRk+r7b+HoDsclCesSuGurZqUlVAbehj/bRKojZxTko/MRMzA4N4ZD7UGJOWUZCyGDfdBaoAR1fGxCR/HAobvGlBS3ts5QTV9hSnJGchqDVywF3XyFzHoBcoUotv8gp6Xk5nz5DFiARTNcO1hFktE3z8lGI1BwtgKjlF2fXKC1dGy3OQhgn2aNinDQYgKV10guK6KcHQldHPMlIGwRugE75dIHX0oMxQt8hRhgaTHiV3UDNNY+UAyUWJcgSd0sezcVJ5VFmUXY7q21dj2QLoD+/mVB1kJe29IMx+tUWaDwRTFG5ewQKOGPN17zaCkmqmWtbChHp/mWa4YRLTYs54p59g3xmhdPDHid2+/Me2xM0KzrZ/VS7t5EfOoNf3C2azBWi0URz8Rele2/F/Yhj+uXydhIrHaVwpb+ZAPM7NXABSis4aJFg6xzz4Qp8qPizbWnwxlYDccw4sugOW3/doIfCGqB3JuHqDlN7BX7wSaATwZ6h/NR9nMU0+4yiigppVxUFY1Pgy8PtGFwFBTGN/7FUNSwqjBcQwj58fVfObC+SJpRofbrM3ggubYpacHcuJ7o0dc6zZ8mjLtu4Rtg841t2Ol/kqxe4iHsGIbMF62Y1wK5mw0fjsyppPWlBOFlUczeSkEloz3VZOLXLLCT0mfTdS1Nnq2TWM0/K/ZVCkDK04YkouAiZ6H/VC72omNTnXNr4Sdf8P0NVDNskRYWLBV8y6JVy7ZLAbg8Cmgm1jwzvcpksbWBZEDlvS/IWRWr
 IJu0TRnt
 byHQoYtc400gYQrQbcUwV4ajV1vT5E4/5reUs2WAx5lDqIiCZ8KdjHDbtXR+JFaYuECysJw+EaNuprhceECisH0yufIQIX1Nq8mSLxrD14BTg+p8SiEyAOyiJGhTXWvGdz83e5fw8RNPcbr5oSSVx1c7A/Gjs3BiiDFOaDhSpjSkrfi0qao0tL2Lh2YkDO8FwBcJk6PTmEdPXyYwgqMVhbE+agVAdLt1jqecoI4gA3BlUV0dqmFtKy5n59E1GdBNkcbrUzhop/tXsytCPDy8TM4lt0Wrem+w6iAIorY/hL2ufOHKoo7IHR+8pfase1DdVcvmAwT8vU3+pGU2oSlRbJPJxOvFbjwGuFXelrQmpk4MyzPGXnrnYnO1Ygj6HHDSfnC2CQ3ZKgnBTTHNt+Wsc0WQ/NKqI7q+liXuQY86MHaJhi06lWzyNRowj5mlzWjZLayDfFTTTXOGFs/Sy/o+z2BXZACwREVgSBHwqgXd5IGjMWHOx10z/AVVslkanDDjxlD/MgTPKSL2j3FyHuzaf6PhWOuzD0zMUIaBz9JFT6azlztwNqZlySsDpQqHukkxjE++PfZmfGKlgXv9u/5WBM/IkMmSGzSSvdE8KygsVcnLfk1XoVI4Y6Wvy6ys63j0tzK4L5ra2tQr+h0lTljBHwnnWDEjb4L+9SaoIWbDm6u7HxcsrcQ4V2lOhSiiUqGED/x9E46DgdmO6B1rDp8585kA9E0VM66Hv1YjTQ8impajuZk9dRUZM6jyaNND9ba2v3m/Xt0mEvG4k8MlqHOMhIz25tCLQXc/XFsc4OM5Km+dg/mD3r8nRz1NHBET02/2KSTPaIfkgN0EXl+co1NiF/53qMuKiKncd5CYr01bYeJFHX/QbID0GWvOgR4ExvHcaPNv2yO9cRaEdP6amF4Mt81v3SnZ14fZMP+FhaxNcz+WDf9+RCU8A1wMq1MYHjzq6tPGqLZ5N7dtoFgEkNLRaA9DwHQ5z
 oS4GFCuE
 v4wJWpihjrGSPYfl9AZDcrxiyjm9TOlMlRnXKzpZ6EmH3M5bMzgrO5ZIHEhPbNO6wsPd+jW5wh7SM4mDKDpZU+oeVKQRoKUJs7JWzYlVsyGdXgjB5oyXvT6cNi3MjLQQNCR8eALeiOyFHFn5J4tMg63R0WtLNEQINRitWPrYOkOcPW6W/axLF8Ecx2TfwzaHKvIyV5i0EryBjB//6ZpXAv+NDiW+idtzvYJC9LbEJhaqqZBcavIir493krbBiVmyQpu7X/UBw4d3OkYejo09uEsB+5zhQg4ASyYKRX1XHlSqlm12Kp3ai+IrIRHNjTm/41hSiyp6SowaAWKtuPxqKkc0/RrRrCVaPbKeQjqYUwTJYlKdJb0fjKqx3je/yv0ojr1PPKLV4qVUHpbmHP96/pxW0lllhDv3Z1e7H0kN2pUd1bhDk+m+p2D5lC49H3TwSA6YjnyILtYl0oFROtKcK0O7ga8WRifXf1qrud7j+j+aksyKB9Dx+nl9lzD40q1rzdKWPsSKAfBckCmNXHO4M7Iu2k4iJE2prssIPuldmscDy5Op3G0vbEE6TeeT7bfLXJLLqq5bxa7zrwca4848SK0GW+aWcdyKDti9na0vCrDBu1KgnPmL/5tHxxlPqzaF93wy0HCwkvesUquI7igssUBhfmT0a0eNDpcIbwoxHoN6IOE8R4g/Off3ngQyKbBopsNAU3+ZaQEz52xzSCAprx6awzmFIxUfCNAjixVa1CpUwQuc/5eYqkjFgBXqz7N4BdGTiaBl8tCOrUzrFlZ5pAuvDoMr5ZRuezX4cROCGyWFKLdyimgMlz2/G5AhQI7bQulFa7rapUbZKZpTDhgqlXn9LDN4DVSBx2lxeVSUcNfVpiEynVHH0u6RyAOASDh1rXSdGioj7Q9cS+fXa3xiWz2uTOlZhajAnrAWhH3pN0MkaVP81h6ZHQMqYESb5zYrfwPJv0sLh6kxSisBJLApS6VRLW80G
 AKVcu985
 0UtPu8RLl9md7Sf2eYHn7xoDXJmlSr8Tj3nihY0BlIeQ2Ug6hsOinHbFR2wsHIRFd4Xk+kJWIE3g6WONKsTSp0ZCiBmgDYpYzr9xPZjf6Eif6j4HzN7rnzmX2EUJEDqzqnhcvvQy6dJCgEi2fyUxSj498QjS2Yue3EfV4xe38qA8Ch+8KbFdZefux9b/h8teS7/U9eTYZ0hS+xZCj+LCfeIaIBfeQSmftK2bXs7/1bZ6CbaWM7K/m+uCed6U76ikihFs6u8fdXbMSe9UeiGJTM7GkuQh5mdfKa5CQtzFhcFO6DjJH+cWwTcdEMEA6UST4yQQC85/ES4qxxetRXnQS56LtQogytUHcm4KPAHiQKKxr6/sLqWts6U4ZFMdKgDD+WUfKapsMKaqkjyUlzx0toJspcxr/bM1lzKlNcQLxyN5gVpOGYOkp7nYx4S68mDJb+xe5Ic6Dpae/osjZS2pLMmKwGKrwkAt3OEzEp+qsq10gtpc17R0Mgwod8grcvgR24lvTcLERk5egRGT3MJtVNvD/S/JSLspSqeVqM5q3JO+zj+IDRyB/sWCIIOTLzi3Dcr7OU7OnqbMy95HTuJPydtyK01G2CIJ7Q68MuYIFxkHf3V/N9NGWhIuosOdxJyn083fD0T9yUaiFsqqAaJQXjzyO64NcVqjv1Jb4IG98q/azHrgjH8oIy2QMxUnRQBLU5FT0Z7etOB9CWRHNIrZHxgC9aCR8F1ubqyTWhlPYYoJId2sUIi2WvLlrK0FrINCuVL5byQd1TqNq7ZY+uXDGELCsOwZ1M5jB0EaLB7ZB6+MxGXCE73HD8puSY8oZhfI+J3QS8X/wmedPxPaTUGG5oIhh8MtwI8uKXldEFA08t2gEltchnm67iXRvU2Hk3fnNqH0i4NAsYqdVV1PkoU0fjEbdY5XOAHK/ZEH+hfbFY5Kqda6dOiUZXinr65Pv3V5rh+MBtj/YYba2hpu1l2iO/17H69JV
 bKVmRtof
 3uvaca3GK6BqLCIs59Jhw+yU9Og16/iEhgKzsI6LaHGuDuL2OpsV8z9+8Z+9w++DOOjzGUZqcaJz8urLNtFHYliSQaKUbasUJCTvlbmm6DyxFrKT349o/s+EFD9qcn2RfPSaUCTKT6wAMYUss7Q8/m9HM6j7F5jkdD6bvJ4Wc2nJMb0EtpeuRLKVGl8g70r/lIfqSAGU/rmW1+ihaSHxFj9Z4BFEZNKzir9b+LLR1SApAZ/CG+ofNGVOKo2edvz+OwVV6bS9XiMGajE4S9eQEVE+O+IR5FOzPZbmmVwJURSGT60pmIjVeRPjQZ7QmG31Pn3ey4LvjKYeFUpymCw0wIhoXrt+byZGg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in efs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/efs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index a21a03f7e5790aed95738b1a0c0f1edcc84848e8..4b132729e6385de196e156400d17a86ed04dc2f4 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -132,7 +132,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	for(i = 0; i < EFS_DIRECTEXTENTS; i++) {
 		extent_copy(&(efs_inode->di_u.di_extents[i]), &(in->extents[i]));
 		if (i < in->numextents && in->extents[i].cooked.ex_magic != 0) {
-			pr_warn("extent %d has bad magic number in inode %" PRIino "u\n",
+			pr_warn("extent %d has bad magic number in inode %llu\n",
 				i, inode->i_ino);
 			brelse(bh);
 			goto read_inode_error;
@@ -140,7 +140,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	}
 
 	brelse(bh);
-	pr_debug("efs_iget(): inode %" PRIino "u, extents %d, mode %o\n",
+	pr_debug("efs_iget(): inode %llu, extents %d, mode %o\n",
 		 inode->i_ino, in->numextents, inode->i_mode);
 	switch (inode->i_mode & S_IFMT) {
 		case S_IFDIR: 
@@ -171,7 +171,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	return inode;
         
 read_inode_error:
-	pr_warn("failed to read inode %" PRIino "u\n", inode->i_ino);
+	pr_warn("failed to read inode %llu\n", inode->i_ino);
 	iget_failed(inode);
 	return ERR_PTR(-EIO);
 }

-- 
2.53.0


