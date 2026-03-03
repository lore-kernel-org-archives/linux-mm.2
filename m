Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0CE0EC1429
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DAEC6B00F3; Tue,  3 Mar 2026 05:58:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2896B0168; Tue,  3 Mar 2026 05:58:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 069C16B016A; Tue,  3 Mar 2026 05:58:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E6A166B00F3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:58:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB7FA1C432
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:58:39 +0000 (UTC)
X-FDA: 84504453558.08.6CC60B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 097ED14000E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:58:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U6O5maGd;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772535518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJBIwyenvhF1oE92YPonh4V7tqP6SY6ckXOcKiQA2pM=;
	b=Zl8RD2P2dZzcvLvusMl+P2rSf3o8KZeW82y7x815p9xN7EbZAvi1jmjDmyoD/njre+q+bF
	ra0Cj5VDLTMV5BJoq9XvJqb0f+0OquDJDuYvl0eO44i45cl97/Vq2hRAdWQGIQmjir8Bf1
	TFClfUHH/KCBDwNkZ08ZTWGsCtRfkcQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772535518; a=rsa-sha256;
	cv=none;
	b=ljodcZEZtDLSjkQRMJB8QgsSKSnXZbg9RG7O768elK/LsRVFs3a0foxXUHX1fRTb1FS9Dg
	qnvl3xXZmrAGnHl80SrTMuudwrz9PO6ELDrSK9sXcMSWTXkXwuPArVF5BuMpuVIuUFp5qa
	RE+peQBWe8ZD3oasRGTLV8vAxB3HvFU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U6O5maGd;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF550600AE;
	Tue,  3 Mar 2026 10:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D470C116C6;
	Tue,  3 Mar 2026 10:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772535516;
	bh=LTGZ5EPnzGkcTqKhItlUmFCtGUuR5ztGdIWTTSykpcw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=U6O5maGdSAxWIHhPIoDEGzoxTEy5qgEId5DY1DAFqSI31LGsO4sBizxtyvv6Y7UHy
	 TTpm2QlfXC1NqdbowSQlo8CNX3qzQzuQNo64t100MYliHYDoFNKTtAaoaZe22C08wf
	 5lk+981yWSBxTZatezDRR/6hdGx3qpaI7V/jLy7InoGkMFl2BMfbZm+upp/ubCXCnB
	 2EK1qjQr+2Zk9oyeRQA0VTK98DcSOvY1JFfr8dgk1COufDxUe8Ib7tmF705ulPbQli
	 yoy4lD6qxjIFSp0IZtDBxhsRYoy8GYv7UxdxKDOyub6gyzmgqBuT48feWTn+QuCj3u
	 po1tHyEJHrgQA==
Message-ID: <1c28e34c7167acf4e20c3e201476504135aa44e8.camel@kernel.org>
Subject: Re: [PATCH v2 000/110] vfs: change inode->i_ino from unsigned long
 to u64
From: Jeff Layton <jlayton@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner	
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt	
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams
 <dan.j.williams@intel.com>, Matthew Wilcox	 <willy@infradead.org>, Eric
 Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o"	 <tytso@mit.edu>, Muchun
 Song <muchun.song@linux.dev>, Oscar Salvador	 <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Paulo Alcantara	 <pc@manguebit.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara	 <jack@suse.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,  Trond
 Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck
 Lever <chuck.lever@oracle.com>,  NeilBrown <neil@brown.name>, Olga
 Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,  Tom
 Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>,  Shyam Prasad N <sprasad@microsoft.com>,
 Bharath SM <bharathsm@microsoft.com>, Alexander Aring	
 <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko	 <slava@dubeyko.com>, Eric Van Hensbergen
 <ericvh@kernel.org>, Latchesar Ionkov	 <lucho@ionkov.net>, Dominique
 Martinet <asmadeus@codewreck.org>, Christian Schoenebeck
 <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, Marc Dionne	
 <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, Luis de
 Bethencourt	 <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>,
 "Tigran A. Aivazian"	 <aivazian.tigran@gmail.com>, Ilya Dryomov
 <idryomov@gmail.com>, Alex Markuze	 <amarkuze@redhat.com>, Jan Harkes
 <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,  Nicolas Pitre <nico@fluxnic.net>,
 Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
 Christoph Hellwig	 <hch@infradead.org>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>,  Yangtao Li <frank.li@vivo.com>, Mikulas
 Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse	
 <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp	
 <shaggy@kernel.org>, Konstantin Komarov	
 <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mike Marshall	 <hubcap@omnibond.com>, Martin Brandenburg
 <martin@omnibond.com>, Miklos Szeredi	 <miklos@szeredi.hu>, Anders Larsen
 <al@alarsen.net>, Zhihao Cheng	 <chengzhihao1@huawei.com>, Damien Le Moal
 <dlemoal@kernel.org>, Naohiro Aota	 <naohiro.aota@wdc.com>, Johannes
 Thumshirn <jth@kernel.org>, John Johansen	 <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>, James Morris	 <jmorris@namei.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, Mimi Zohar	 <zohar@linux.ibm.com>, Roberto
 Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin
 <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, Fan
 Wu	 <wufan@kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, Casey Schaufler
 <casey@schaufler-ca.com>, Alex Deucher	 <alexander.deucher@amd.com>,
 Christian =?ISO-8859-1?Q?K=F6nig?=	 <christian.koenig@amd.com>, David
 Airlie <airlied@gmail.com>, Simona Vetter	 <simona@ffwll.ch>, Sumit Semwal
 <sumit.semwal@linaro.org>, Eric Dumazet	 <edumazet@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Paolo Abeni	 <pabeni@redhat.com>, Willem de
 Bruijn <willemb@google.com>, "David S. Miller"	 <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman	 <horms@kernel.org>, Oleg
 Nesterov <oleg@redhat.com>, Peter Zijlstra	 <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland	 <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,  Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>,  James Clark <james.clark@linaro.org>, "Darrick
 J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>,  Eric Paris
 <eparis@redhat.com>, Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann
 <marcel@holtmann.org>,  Johan Hedberg <johan.hedberg@gmail.com>, Luiz
 Augusto von Dentz <luiz.dentz@gmail.com>, Oliver Hartkopp	
 <socketcan@hartkopp.net>, Marc Kleine-Budde <mkl@pengutronix.de>, David
 Ahern	 <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>, Steffen
 Klassert	 <steffen.klassert@secunet.com>, Herbert Xu
 <herbert@gondor.apana.org.au>,  Remi Denis-Courmont	 <courmisch@gmail.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,  Xin Long
 <lucien.xin@gmail.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Maciej
 Fijalkowski	 <maciej.fijalkowski@intel.com>, Stanislav Fomichev
 <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer	 <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, 	linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, 	fsverity@lists.linux.dev, linux-mm@kvack.org,
 netfs@lists.linux.dev, 	linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, 	linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, 	samba-technical@lists.samba.org,
 linux-nilfs@vger.kernel.org, 	v9fs@lists.linux.dev,
 linux-afs@lists.infradead.org, autofs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu,
 ecryptfs@vger.kernel.org, 	linux-mtd@lists.infradead.org,
 jfs-discussion@lists.sourceforge.net, 	ntfs3@lists.linux.dev,
 ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, 
	selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org,
 linux-x25@vger.kernel.org, 	audit@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, 	linux-can@vger.kernel.org,
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Date: Tue, 03 Mar 2026 05:58:20 -0500
In-Reply-To: <1787281.1772535332@warthog.procyon.org.uk>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
	 <1787281.1772535332@warthog.procyon.org.uk>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: ukx7i9sepypzop1bj173kydf8awyftmk
X-Rspamd-Queue-Id: 097ED14000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1772535517-421376
X-HE-Meta: U2FsdGVkX1+ECHz7Ot0FXQSrMK/Q5UpoLmAqDNaOzxWpYmmHJS1ReSfvhwKrFxY/d+Om7l5wt+Ow9y/bSeyN3Nnql4WVC0qfywz1jPXJBboUSNj+OtDcTetzH8JaicUBJQ6NL+IxpABojEHPK0p+WX07nh9d7v5CKip4pAmsS0qpM3xwWBKxSQhSoSUr+5w1bxM+s1ZN6olVbNz/Kgs/4C8NXJ+qvffQ60QEyaUrF021bvR0uS8rDlY+Y7DyksoPnjzvHWdeSPblK039Jgk8Plk8xDonc/+t2RffI6g9seEMMRAn82zR+rbMlqbzIVuZiGqhJnnz/jRm4Z2CxQarz+7rwXLNisE6PNJPIeE3/dm0XG25nLaEpkfi/Ddy/COBpThuuRuaHDPcIXgwHZOt8pNZmz56TpzhaW5QtBgApcTTm8ZK8CrUEfqy9rdD/xUNjB1n1HC8zDAfl0GjFYdEz4fKEVWraDD8VwsziH8URnfEUXGSfabdT22qE+n+yrLwwOjbnTJSgeZrGazFMWUWfDk6i+N/hY7A0IJ5XtGuYcuJ2IIVAU8vIGXApOTcLiEy9pgRxIG7oChN/O2WIVo6RAG/4N+ki0RQDaojs5bt6cVRnMUC6PPWyMbvu5HGEBMLtOFZMY2yf8ZHKcjduL9W3iw4e6l1ZbfK9NCKPEZ5SE9j1uOFxVvnyAkvXKtzeShp2rUksHsTwyv+CiXdtJix5OImzYqTLjLfR7XXMWS9iVrXKrIuJUATArJJIiPsF8X8/6AqfI8sv265MUocP8Wc4OxVtsmei2gNYL1naqodMPTkreStyA7MDQyBze7V1G+pqs6sxQVDeCP72scYede5J/4gIinWcAgj7JAL4U3Yqo7iBqJXX7bU1gvOEqhm13FM5gP/X1sb1yyev4jt0lgbQ59O3+WISnYT25zMhyg9tGYaNxehxvKiQsqKNqQ4BbA8tCA5ShENHgdUhaqSiZw
 NwUF/Xmj
 9fFqFebv4H8oYo0d3hVViT9H+Mk9G2pV3YY6JEEmLb/jCvGg0LmA2DCA1oqWSExYaVVFw7zoLOqPbtPspITVpj6IsaWSw2ywvaqfaC9fgnyLgj1jHPtXLbJiMDtPIVr8GVTY6/Nlh9VBx3marZA8aiUxZlg53Uo8cxxCHQtwTpXBzjXI3S8XIAzAquhP5AyWjVNarJaayE04QmU1dIBQKzD9EvFK8edF2u3MNyB3sCtK1WM+LeI7sV11LC1F9OsnGjA7jI31VMLMDiiDYiGXU423Q5W/wVVEAWgzaKgpOg5lepK6wQkfpBaZKoHEOvBm6zo00xgBHIPlR6e4y/f18Fu7fiFTYomZtZlRnY6VAwCFIy85F5EfaMUD6JUINsYYgGR8vCjyp/WffEkRpFQ2lcjaoeKR2gzBR0pTlflCGkaDLnQ0kEx2ds3Bz7514fSCrpz/3QXjFC6ykKbtail7ECb2gh8+IGqdqhxYlCmcn4SWDkO7OH+nHK0qMk99Lx75jC0z0iZ+ZlEhIgvUmz5M0xyXPzo2bryoNBMzIMkBgV4EqjA4t0qrEADigBRoAqmspHN+BgbiMxMlonaLyw0IWCeullvgp5Yv7UpNgg+3If+GkqQNgUM9Icybpc6qKCY6bob/VUjXZ9wZtj2kPsLUT+4VSLAD5hgsNBwJSdQS+e2nHdjcRq+s5KNV3tcybdjhRgj2lF1/Twm632V96C7Pefu92cSUaUwF4ALwlVkFrLfnCaC25pIB+loEToAilizzvjb5Yc3Uqy0so+knT5MzU8ecxXPED/kInwwlECBxIGaP8JM/7b8RLcTDhyzRxE2yswOTi7AN+F0dT35LwkLviTcVJua1YKGg2aeHpwo0an22/GjC/PKwvuiVOHdCzrqjRLB0z6hmFq/SeYR/pnYCj+VV9Snwge/7yPV8pXLd0ws+eMZu+e0pFST+r9zzw9RZ1Bgl0OsZlpuNuc1uPinnV94QpZf/a
 UtlEa7SB
 yVU5Ugm/P5ylzsHe/LcAtcOiXKtAz8p3+aNdSHd8H/FboQe2JDe0eyp2+74r6ghal23djs+vlYBeHlsqZIDQ5H0di36xQWsyPY2I3Y7FrV0F1Helb9Bw+zXNxJFyXS4/XAAz03RvGK/5y3tYwmdn2xISLXl+ijjsWBmdOOta/ocUDN0i6siLg9XYlcj0GQCuqdWCsNYS+MSfMAVbiPVwaTNWvuhLxw1F//e67vgm/9g2ctbpMCEaieztbIpkle3fP5nw3zkcicELL35qMQJjE1smi/9yitpaDl0+cnoSQYHKOYjNzocI/bu8fDoLTLT3Nlg9MV8fExU+X08rSD3ZhBjz/b+xwTD5Rg8+nEHlA885i2CVKcEJqubewX4xEaMnp6oFijlOoty2woxw8lULpIftNtC5qyhKa+Wrn8Q3GaEHtPh+dlG8+vFXxGDiFo5k9YF/19n7ItmO6uf2up1uSrH448WStzA/RlG0lllsFuJQk8Uo57t9yr0gqfXD1CyOQF0XHOfEu/YoclIf5pXXg3fnWj7vCX2WUbH42LlBv81Xchsl8Re9vYMDxINdI/KspQFiar/angTrYz3a/g4SwhY+sYNBqR5cX+veY8vXElQz/91IR7YDONbyXSzQGeft2wGLFk33FaKpFKjHweftBP+ERsoL3zyFusU1SHMmaFhuPcHuRQf0UUsSxf4zJ77WK8ta0+lk5aZTbPWg34uc6Dcyihaa14cOW39rWW44UCS65n2GIBA7mrXwRdMbvUQmKBLxdYZ0Vba7dwPQ+31IVqvtQOntEGP5eBEmcXGelcMMdp2YImQiXOn1K8Ek2ds4IX/hZGkmaw8whxWAUl8zWHgY08k/M3es3SmGwDmnpxqFl8fv87qCdwZ6HyRzCHT29VC3yxMhYji7SMOUA63y8oYt5cmoy+OtcKHBUpzEPUyVlOujAu74NKnEwWkLPItoU8+9gQi8YwBDHW+0HpLMioWn4pt2o
 KkwcyRvb
 bntOy2PDkoHreufRjcjgmMIYRSJh9V1aP3Sa2g/8qwnaBfT44HG5/3tA/pr1LSPQ3pTlAYQ2wkQo1SCoaIWGAUlcbYRFu9A1YuSd8VhWbOZSyt2UFqS6IG7HDWYCR2jNtlIRxc/TBWfC9oXsY+H4y40RbJWe1O5DRXBYsOUJ9svtcyivg0myDdBk+Yd3q1EXt0+jNV6Sb4NtXQGRVJQWcW1NrMep5RAEJJldLBcBl912nnHgRZNC76LpZmPoSI+AEo0bbChq3j9Xi+9mbkiQUt7YeF+4kEzCQxISFY3Pepuux+ianRN0EcYxT/qSos8hh5vPDc1jzhvHFztP/MIXBiTYeJiWZjyPlaQAzInrztTcPnC2U8sdBCIE4Y2ly4yd39yOcGIg/cbLvyZnE7mczh/fbNmiZLpTXcOX9fYfKnSIkKvJLLo1Td83NbFXBAkDEKjYcrglVnFFir0I7I2OGxoQsigBNT6Ke1pYx8ijxzQOC+ib1i8fN3iW9zNbnLPw4B2eLcjLueBX1pMBCoyr75cpxYvMwR0MWPQwcUtxzYJ61AF1+iKv3cWiq+Fn9mFq3IEB8K/x3t0LcNhsI2VRmckUmcHD1Xj6hplneriLRFfmTnR6e0mmfpoyAdyoWkvA8sOCtD20Np6/94gXOS5ncVUPgSv22gce8BDtRHct2pWYoysLMfYhzYXA5Gcg0lhlZNu+e4BNnVVDFqMAWsMN7pAfLmfNmrAuZHwt+ujy5qmONQNsSZMGmGl4gxMFLPep4Eqs1dxPH7DzIcIssI2q6dnkXFbIuim7s0/o1jwFawn58VO3sMcHdpMcxC1xDFvuFshS3kNc5yc4SIqfRciUaL4lwYLkPsO8KWvRCkk6B0qs+L2dFtAg8Exr6aQLRW+3e37WRgXMJxcfypHyk4mwWZWh5E1w4N2J1PVCnWOoU5RGvCo4f4jMeW1WLwOqE7wH6ArVXPboHfx4oAKcAoBuy1ATscC1m
 BO7rhrXm
 Jp0Ij550RpRU3E9PSjudBgP7vV1a5zcadSV2NEEiGQrCEHxUJguLF0L8qR0lOesf+iPhjN0dcQpAkgth1oTKoqyPVx1l5toLXAH2YXJk3HcMYN8UUburOf6LE98cHRVqNWJOzsLKHdOWRbxGxbGWnvD9kL34ULKIBoOwgJ3Fkf4Pbxrz8OLNUcK4TV0N/u/qYbmw2p+VKHRGbHvcen5Ondv/+0go2Vx4SsvQaE/2eqBY7OvSrIgu9cb9yfOc96w9V6BGodTB2er+xjlTZuLwJQOcJEB7j7tJVCsKG1Jk2iPyWnS6SZyPCAEztyzlNjLxpTUynR5gK3VhLaThm3TMI4IEBi5JY9G3QiTse6Q9rL4GlOI4s82sBXFMpQAecSmLg+9jpdyWPlm0HQYYC0PRa+Oro4MGv18L0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-03-03 at 10:55 +0000, David Howells wrote:
> Jeff Layton <jlayton@kernel.org> wrote:
>=20
> > This version splits the change up to be more bisectable. It first adds =
a
> > new kino_t typedef and a new "PRIino" macro to hold the width specifier
> > for format strings. The conversion is done, and then everything is
> > changed to remove the new macro and typedef.
>=20
> Why remove the typedef?  It might be better to keep it.
>=20

Why? After this change, internel kernel inodes will be u64's -- full
stop. I don't see what the macro or typedef will buy us at that point.
--=20
Jeff Layton <jlayton@kernel.org>

