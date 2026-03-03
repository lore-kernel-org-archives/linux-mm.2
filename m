Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B44E9EDA680
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 15:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214D26B00DA; Tue,  3 Mar 2026 10:26:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C79A6B00DB; Tue,  3 Mar 2026 10:26:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088A76B00DC; Tue,  3 Mar 2026 10:26:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E84366B00DA
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:26:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91BDBB7654
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:26:09 +0000 (UTC)
X-FDA: 84505127658.02.8941AC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D6C27100010
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:26:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FuSlGmei;
	spf=pass (imf05.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772551567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vq1l3VBMBEIjbra+1t3tpm4BF3TQVIgbh4HW/OqV+AU=;
	b=g70E+v4w1oSVtO0cMx6xZl2Dyz5txAHoAEWZ4GK4xTRpuAtKIximXUeGc+LNCF4sQj0Lts
	ZU3b1ipI+smnFNB4JfymFIVUo9h7Wq0uF1MSt2x6vJ2ZEcvpTsbsl4j/fnvMQXsOm52CfQ
	OjsBBHz1T5stXMTWBG+y4CbRJ6x9jj8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772551567; a=rsa-sha256;
	cv=none;
	b=4zR5UD7NM8sZi2CbU4PVdweQlMYfBgK9Zf7kQS0YFKOMu000u5/t7N+dxdvBG0iVd0FRBN
	hZ46dEdrRDdjDPN9Ww1qI6m2jotNHFv0E7rCUF4AxGYRK+sdn0CmTzUvCnImEIBIW/V/QZ
	2xJdjP1vrF426DDsjM+frjl95MZ6Tds=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FuSlGmei;
	spf=pass (imf05.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D268260127;
	Tue,  3 Mar 2026 15:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19832C116C6;
	Tue,  3 Mar 2026 15:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772551566;
	bh=GR5xxAO3SaQW9wgM7VGtxRPOkk2oeXbLrLD7cLv6Vfo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=FuSlGmeiPRKGLoVXeyoAW/4o0okRbURy9ms1hiH2PDqHC8YS5UGUv9pjnJURfC1N3
	 wEHpswFKJ9D7LuZA6II7jxIclJzmZ5mTaaPW4MAHz1ft4MhLW1HZrLr0Juj9NIJ8+5
	 CYHQJkN8Mlno7UC+a35h2JBvFZEkwIKYFfjenBa8ci++7tWv3SBJpPkEUhCg7EA8/C
	 T2oD0g2pCazrgxokqgkGYkIajww+MhJ1/Z0LjEDZPy8xCtNF381iB35sgllJ8wNyOg
	 qAL/lm8ZnxNCumPp1kFjCkJBZmxGM1T9KXd47dCgWe+GFM6EaCUfBAl9jXPgSERD/R
	 MVuefm1rcs/Xg==
Message-ID: <78abbfef9b7ac8cdde4de9f2cf3fbb50317d6dd3.camel@kernel.org>
Subject: Re: [PATCH v2 001/110] vfs: introduce kino_t typedef and PRIino
 format macro
From: Jeff Layton <jlayton@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Alexander Viro	
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	 <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu	
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Eric Biggers	 <ebiggers@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador	 <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, David Howells	 <dhowells@redhat.com>, Paulo
 Alcantara <pc@manguebit.org>, Andreas Dilger	 <adilger.kernel@dilger.ca>,
 Jan Kara <jack@suse.com>, Jaegeuk Kim	 <jaegeuk@kernel.org>, Chao Yu
 <chao@kernel.org>, Trond Myklebust	 <trondmy@kernel.org>, Anna Schumaker
 <anna@kernel.org>, Chuck Lever	 <chuck.lever@oracle.com>, NeilBrown
 <neil@brown.name>, Olga Kornievskaia	 <okorniev@redhat.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,  Steve French
 <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N	 <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 Alexander Aring	 <alex.aring@gmail.com>, Ryusuke Konishi
 <konishi.ryusuke@gmail.com>,  Viacheslav Dubeyko	 <slava@dubeyko.com>, Eric
 Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov	 <lucho@ionkov.net>,
 Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck
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
 <adrian.hunter@intel.com>,  James Clark <james.clark@linaro.org>, Martin
 Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>,  Joerg Reuter
 <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg	
 <johan.hedberg@gmail.com>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Oliver Hartkopp <socketcan@hartkopp.net>, Marc Kleine-Budde
 <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>,  Neal Cardwell
 <ncardwell@google.com>, Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu	 <herbert@gondor.apana.org.au>, Remi Denis-Courmont
 <courmisch@gmail.com>,  Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, Magnus
 Karlsson <magnus.karlsson@intel.com>,  Maciej Fijalkowski
 <maciej.fijalkowski@intel.com>, Stanislav Fomichev <sdf@fomichev.me>,
 Alexei Starovoitov	 <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, 	linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, 	fsverity@lists.linux.dev, linux-mm@kvack.org,
 netfs@lists.linux.dev, 	linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, 	linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, 	samba-technical@lists.samba.org,
 linux-nilfs@vger.kernel.org, 	v9fs@lists.linux.dev,
 linux-afs@lists.infradead.org, autofs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, 
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
 linux-x25@vger.kernel.org, 	audit@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, 	linux-can@vger.kernel.org,
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Date: Tue, 03 Mar 2026 10:25:50 -0500
In-Reply-To: <20260303151617.GD6520@macsyma-wired.lan>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
	 <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
	 <20260303012556.GA6520@macsyma-wired.lan>
	 <20260303042546.GF13868@frogsfrogsfrogs>
	 <33228005140684201de2ca0c157441d3b6a06413.camel@kernel.org>
	 <20260303151617.GD6520@macsyma-wired.lan>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D6C27100010
X-Stat-Signature: ydoy6gnmi1enpgqr4qa173xrrcaptq16
X-Rspam-User: 
X-HE-Tag: 1772551567-850314
X-HE-Meta: U2FsdGVkX1+Eg5OFF381Qk3YwXKzTDVYvj8PQfuHsqeWzMywvHEH+fqQdssYoWCRntA8O4JdKKNIWM0TZmJ1yu4Pn1ay70hUzfLu/s96BSdupa4/7F0qH3bOBuErvziT4EzJ8wn6jH5GX/xQBH73pIXCuUycjrLwtH2uT/jjaQMtKrQ7EoCaBWqLzxKUi5edn+tnLmWNszgqIYnEcrvvbBOlpDpZkFpwmPY8GWxErRTf2yFMP8FkvWBMcpG7f6/wTO2xKvicpKvtOjTCfIaf4nX+7jX0RM7tpBKKNrHV3EVsxBBQAFSht+JNTG5UN8AmtvhrD4NqJ+I/6eTssdbkDY0V3e0Mu2emPxv2F2bUjeJVVNSJ3ksRfdKax7S75liqOQPoCM/3XFNvAJp999iCSutCSPYBdtlptjOkvbys17KVyYJbc+DJaG1WsxN06597pbeNKs0k6/UTSOnnM0jmjdS1dB9PkNXS7+wyOFELJSN3EqLSaUmlj8VOXlplKCVvZ75xW6lu6pka7wBFgpuP/JlzTgWK8dltqcNJuUIFoZ5IKI4K+wPu4iuFPE2WrOeBDmRSTKq7654/P0pn0cxLWIyDfc38+5GdiLUURQeUnzDMFaAzhNOAq1CQat6eeOYxQd8DJO3Dyr3OeYS/yTqfCAHiKPfjtH/ZMHtH4nEaP5lk02NOLAegURwz7AJ/Im62kPHWRq61N4iteBJDkda+t8WfUeWTmP+G5cSK6tqcflndx9bRUiMw9uDa9RmLY/z30Dn3GMIVDYQBuEueSY1HWif3Rt9bmXyFiiJvtJjfIUKrn4/codLnf+XmPgPK/i3ShaMmLgX1+Qhe63MHHPJff4wPJjDJx9T/Zl//tEdzINb6m75T4hKd9zG0VpoMjPJE4rEE2WTblQ1+7IZkoV8ZwVDNbdQzYtB/NB+cI5ftUq5t/K/trTgoMqiTcozvy8qZK4sPSRuohogyFsBXrJm
 /qV/hAn1
 u0mg6tqC4ZkvxwRLpbGVlbVO+/VnIJcsK3sCjcX5ACb/jBMK0mY0g+pYXmAvD+Yt3PT0SGygLRO+aifkxNvGlf2qCT7Mn+D6Gq4NJZ78/ac3349WjuiFUJsezoC+Sowc88N0b6NSF92f/PSGR/vNxnqsfHXROqFMF/wN9PgoFriiC6RADiqK3Hkl1Qb+CMvXnjj0+f12TQj6+K8ku2IWgwhbHcQOGWeFNeSLrkkeMkttCi0WltH16A+A+LyAtcJoCmTaF0ZPh5wkmrb466nTyg/zFFlouYb2MXNWwFFbEZ8uo+e8655reFTSHY0Lh7N/lW/oV9Bisljn479/7XoNl0Cha4E7oL4Ci9fobBrLbRC9p3WOxBHrgz2ORHfvwynw6jzWThQiO80Oa3VxbvrFJ6oJ78D3iROLllBJ7Z1q8lSsiWELMnSTd2LrWHKWSYzx0Lfkyp3V7lIZqa7KKW4sl9nWFTX4qEHJqnW7Gn13cywS+jULbYW3F/Rn0KCburuvGVPli4aJwjCvgr5u8t6KLY0WomQV/qbI/xMFR+hItjE1chnNZdxx9LPECeEXjqNXYWr9BagdLSVC0eFzKtGHZrJySkANCZF7LUEGDQ3EsKnPIdQ+8J/CChYxGl0w1a5cM2JsoateHx4qa4Hzce/uK1ttBLxn45V2ahTeNgfwlYB2K3Ct+K8pXg1ncZuD4geVSDMOUbukhixDez/L80eYRArLkcctsW6W6ANtREgU9LdutCT7TC+RHLAX/bDXPBCRf9W5Baz5I/wbVQD1djVEfXGOp2gB+Z7yYKUm5TECK30Myn4QV2/06auT1lMfrsP8mZdIpUiVQf47ZQqCh6i/k4Zbb5CI6K6NODvUO4McJIYsrrnhI6+Z2UhFzKc9ATEikrCCO3XoISMiXIP1XmtVIs4MmiEClywCKm/5zG6FVDSm3SLNFjesZb9UJ18I3ABtUSj3XOqD4tHHzcmlb62BvyG2W9LD0
 TiFGFQcj
 WqTAOHJu+d92V+lXHKCto2WmGwchL3xi1RLVtpj7ZIZmmAL9TnooEdMO8de4mqcrFi+cZw+XCLQWTC6o/hvaYv3DcgoWHzjIsGuQGAeBUEiiQQz2Z/0pnhvPnp/N0f3Q6UJLOKeCHZh7DkV23mGkwf0vUdak2pB3eL0x22l/COqovexEVn6MFJta+Vxcg/oIuYmZmj0IqYfUVBmnEmWIC5BwPWvEC2cmqvdl3aIDBoctLhcJevki4HFXjvK6dqP1vyavrp5NQIpw/1g7FA2ahwaBLMGoJmUE4LuUhiqxMvPf7SbpitUmwIdvx0o3pxuZe/uMoLo5izNg+QOZ2BZ5LR3KF2bPs/adacfRCgv1lrjBxfzJqic11j2DTfitMyzVfNVgY+zR55Tfcx1YuGGPrsDxpgoCx+4drnVKqk6VxwdNXPuKlVGX7y5qm1JTh2Mh3EbDGwU6UDXyzxC6Ff7Q9d/OXtRPevO/YNAuexiCkjuSg1pxa9uo/RZzFc13Q2Kk3Ueo6g0j6F6VyzXjP7tbfCmgOvgCADFIRdcui/8a6hiYcAJ2Mb8fEI7L3CbYckM0C4gzHd3TM5lur6lzZCi0pIPhQ565ud7OgvbtFxTgI6+gmFMs9qrvsffoInSyTmlqJ45lj4LmRIRXt3296SlFCLt/W6VX+fU7NrwNraJGvG138j4lRM+1g2qz4kaW5aH6E0Re+x4qEm//M8NF79sLIhFKgtkj7+S59ddsUMSjvbNymnZ1UHgnFXe2m9755JPce+l15gfO/f+hFTdoClm6xsFmh6dgoj63CIDuClMLSUUus71OBtFodU4L2C0Rjlxo5XCTu8N1yIoGSh9QsZ5oCRLokwBENroThyx5LH7oqONbqdpQe9z4zmhSY0P1PV+X9OEGqf9nwyR4tSs1BiTBTcKyjhvyQ0qf0BFRMcUgGEPGWDRoHHjwnmzUl7a72JlNjDoRqFT1Z6ayu7r1Xl4MZ8uibYrcW
 KNKM5FLS
 ABuMlOv92kgonDEJS9fMDP2b1UJ70Ik5hhAbIVQV7rSCnSQPNQMAMGxuyDO+PN3QX0wlpmIYzL6LOLOhuk2/m0y1h40TDgLKbh3T5EBurPCLqDyk3P0Be9U8j0PyTDrbC2U1PndLwG+cFKPk7knrVCjctl2Rw03w1W61KBJUWvmIIC3zRCdvFsqCrq55K8zuZ/sAa+gx3pDv+KQQJ+68K1XyhCvAWGijZXVGzMzLhsEXf0vpXCZx2SsGRC+s4B6MR46kf0HKfBHVcw9FEL6FP+3Og/qs7K2I/xsl3sxlM0X6SR5oUvBdipD5s1ltWEuo7sILiNsHHzywAje+SUJJvvXTBbXNhpyNX0vJw3vvrRUA/Qpf7wZpHxOmDMokf4RdwJr3bB7YaPxQA2TlkaL5dEJEcpjXo1Wv+1uMVcOf4xz49V7U6OabA5l0H2fupn9i5WfPWxiQoisxRoqQqHfVphc0ApHAbKCKunBXhxJModO/kczmKTGeYMAkN2aQxWD1X89A7KOplzWn0Sf9bXoGrgH9+RiDu8RLxlqU2qA5m/CGS8dVjdJa3f8hJaaugdwTKJ+FYS+gSHCGB4paBegJju9iyKEXYPcjmJUtG1jdCvowa+i+KVVprfqtPC3weAlw6gFWKmdGLxJMgBSq8nYvpN9Bnfr7wjBEY0nouKuFDyVHfIrVbAy1INcKVwSNMtkWZhT3dGMAKygwxfBRpEu9Q2l38PbScR1Ri5seAimMJ9dGHRPCQG4TwuQPHFmdt1Fl5oK5/ecbOHtkdWrGHyexlrxwm5HBdhhMiPj8Fot3KsZzSoh9Y98J3P9w6csPKGtM0y9p0YT7RSqvrCuuwzKhNxY4hPYexYPhBosTJULtGp325ZeMUVVHLX2EIHzVwQMw1dGcjAdcrG1uJXtI0bWdtLHuHShwPFpRT0BIE0R3Mequx/Sfximz61VcqEfxxWL8qr29YFXuJmY8L+KfQxyGb6yUETUFG
 M8rCxZ3i
 dSz5oIDuAiHqy4u8V2q88Jw4nepuM+yQsdnDJx5efJH/+LsYJV+CXucgQCMLrk7AoBSw8XCR/5RNzbrC0SGA9N62XjlvYe9wAI8m3MlIIlMMzQgrE2/BTfkJFus1QsJLJxtK3t2fDz1fkp/C574UV6HdlgnXmKaZJqSyiXS4gwOPmqG11SegqTwnSeToR+wDkTyIriz3WYi0Dmmz5uGRNCPC9bJgIY6TGzvSL/dotMQDtWiqGZ94o4dvQaZ6bkB3WCDzP8H4rfi2Inyxf3Cmivts7XbTK38/OaJDPzpmPmFkAjqY4xjYfHOnt8dZDoAFmLkcAyaFS8tOE+szuA8JYyk3+mvdG6ue9+ygngJugrYVKb23YwJ2WYhAylnA0f6RNCvX+AvT9oHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-03-03 at 10:16 -0500, Theodore Tso wrote:
> On Tue, Mar 03, 2026 at 05:53:39AM -0500, Jeff Layton wrote:
> >=20
> > Like I said to Ted, this is just temporary scaffolding for the change.
> > The PRIino macro is removed in the end. Given that, perhaps you can
> > overlook the bikeshed's color in this instance?
>=20
> I didn't realize that this was going to disappear in the end.  That
> makes me feel much better about the change.  I'd suggest changing the
> commit description where it claims that we're using something that
> follows the inttypes.h convention and making it clear that this is
> temporary and only to preserve bisectability.
>=20
> One question though --- are there *really* places that are using
> signed inode numbers and trying to print them?  If people are trying
> to use negative inodes to signal an error or some such, the it implies
> that at least for some file systems, an inode number larger than 2**63
> might be problematic.  If there is core VFS code that uses a negative
> inode number then this could be a real potential trap.
>=20
> So are there really code which is doing a printf of 'PRIino "d"'?  Or
> was this to allow the use of of 'PRiino "x"'?
>=20

Mostly it's to allow 'PRIino "x"'. There are a number of places that
(for whatever reason) print the inode number in hex. I don't want to
change those.

There are also some places that print it as a signed value (PRIino
"d"). I suspect most of those are bugs, or just holdovers from a
simpler time when we didn't worry so much about the signedness of inode
numbers. I fixed a few of those in the context of this series, fwiw.

--=20
Jeff Layton <jlayton@kernel.org>

