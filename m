Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E2C8EB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4FC46B0130; Mon,  2 Mar 2026 15:45:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A168C6B0132; Mon,  2 Mar 2026 15:45:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CDF06B0133; Mon,  2 Mar 2026 15:45:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2D56B0130
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:45:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4FEAF13A7B5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:45:10 +0000 (UTC)
X-FDA: 84502302780.02.86474CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C88F1C000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:45:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bVw7xJah;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ca49OBimjuWpku/AXS3vucqiLTlQC5qnPjjlpydjkDs=;
	b=Lu5ObIBRD0PcDarvPGFwYhQ12gO/YF+kRPPQeIAuCSXKLuULrNignR7hRf+VYtWktiKtmG
	rTZXC0pT51ZGBSUoNw7VKCYdqa7XIcgOqVe4gXCZB92raqihDGTk6uGDPm+sWRDtfkBrgk
	AE44++iHxpq5XdFdeKcyduGGI6EfzSo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bVw7xJah;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484308; a=rsa-sha256;
	cv=none;
	b=hoTqNt8L8KasojBjbH2DAHmEYDlfJkRXew5NhKXndFJk1Rh2Et2wr89z5d5GXz2hY+2jjE
	SBmwC5oyEbVovLbXy0be2/iwHrA+xRiRLhhw41K+LX3mnxm/IGGE459Tz6PGC9T11Jd+KZ
	Be4E6Ldlp3N3ji6JgUoajTn2Rnrldf8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 81273404C1;
	Mon,  2 Mar 2026 20:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA94C19425;
	Mon,  2 Mar 2026 20:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484307;
	bh=AleFBN5sPrQMDxoQcz7RCiAUkW1M4y/w/e4fiUlZ1xQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bVw7xJahfm8Tm4bdZCyfu9P+ZCi6iCMfEgJmGOL343/w8HBOS3WJSPgeazUL20mEh
	 Md8ughee7NhUqXO6x3bQHqYigaVlCjxp5hO+Pz5xOr/pXujjHW7c1ksaEmHybrfqYD
	 tiZNxerAZmZtyrFfhXdQg/Cy5zNDrsRIzhZvKnEOdrdI0K8SJt2qJlfoRXfnDu/fDa
	 dYuW9qi4QO0mJiXkhAUASBfIm+QkMWlPfaGdA0sT0gUaZr9XpPsbneKwSj5k3neDnW
	 FwcfM4oN0G+zThHw++OqtWYJZJNQpEA264Tub1PeSciUq5+FPaRVtgu+rhFKO11pEh
	 PDq3cTCbyQycA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:08 -0500
Subject: [PATCH v2 084/110] hfs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-84-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2652; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=AleFBN5sPrQMDxoQcz7RCiAUkW1M4y/w/e4fiUlZ1xQ=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIGUHTTAeH14AJWhmBMM+46YGeMmg+2iIHQu
 C44K4yGKBWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyBgAKCRAADmhBGVaC
 FdPkD/9z51R7liAqp5UFbxwRLqvIszl+C5qd/GP67j1aaC/feMl/zq/MoEHMtECSHLQ9Cr3vli3
 KpUje8gXVPw8c5FJNmy+SPLAUOICqlAoyIrtY1Q/tievM+0wDAAYH/Y7uDsDl4MmVcB2USjO6UQ
 ukvOawig2HgJZ0JvJALhNY4Sj9KgenVymKYm127j9mmiDTvBOzMz6N+S1qZ5mhd5PepsJPfCZkn
 hplvsjjEHQs2/sUppyDaCCdYjICR1TJt8KG714Zesw8MNlGx0eIuUceT64U+dIkPvy2qesW8ofR
 DgLylhrKsu/uxfcDL9qCTfcOnRNXOsELegSHGOCPJmo/VSzvCZOwg8e2dD1d/6BxrE//YhflElq
 xRPy0UKjO9n8kmHjhb1xBl+KqNJoQxODV9Et1DTPcrli1PHyaTMWil5LmUe1MUUomv9yX5Btv2V
 q+KhWTjonmYMELcnDujhF/krR3jJy4qo9IWYMKEQo08+U+sw+FhUwwfAj3uWW5nuB7kNQWhxWHx
 g9cuwPby+C5yqOUbWZxIEYJ5+oZTXDZynkOBOTyXjrEpCZDPGlAUyeXcOql9EpeKKMeItDP3Y+w
 RSmXgCAyrXMXP9me0PpEVNjIBd4ll4mceHkANulCrg6cRHy/vstlFXOM1V6W5at3+tDq5NDhkwe
 ZW2EtEyXcB5JPTQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6C88F1C000E
X-Stat-Signature: jnrsy3qyw7fog9at9chcj4ney8ydmiqr
X-Rspam-User: 
X-HE-Tag: 1772484308-442961
X-HE-Meta: U2FsdGVkX1/2J+88VqifETOb2L7we03Q9lPWO7xXrldEsIotZHPv79Knonn00BLP+m9JoIva9ECPgIkPa9xwKcUXU45n100R6iQeY3an/KLkIdKFjaavZ5C2MT0eJIBgKx3ME/lqtmR62jJyEa9pYMwbQhVVBQN9/x2vqLzu+HX7oj735A34z8YdzoDEm+2ctaw3ubyU/JixuWOWCcJOh7KhKJ0AU0+8dJm48duOMs1LZvpLthfPiUCaOR99ChI9IU8wajz/LSABP6lOXhaLxx0Kd+/icsLEuFimYSq7JfJO6DOePj1iEo/7z18oZ/7/emMQroN/NIavJLu88VcCZ6Yt4s+JrBcsNmYCX2ydE1mh41a7eFI7e7fX+qlmAvElu3kdl0K8/kxEN06BGiBEtOMVXbVK8fAeAMAcYQmEReBzh0cyqjdYb3MaCmI1u7D+poVMrXe5InHkScPe3i8WiFUr6wH5jx3ZW7LBaXMLwujfH1JrHYaKqTlTlQXoE7oFKT4BBnE0OG0FfglCmbpS37Vszhp/shmfe1i8ArsgujMnBMpme1DMxsPnG5HuPS5Hqp1YuvHF7SKzRjxbM6xwTJ1fsKCupPsUQN1ovrQ+4sSH5GxI4dlNx7nS6OHIZT/pfhm3ZxTQAMvRG9ykelx+pW/csD2eUirkJ6hdgOJqyiC3kDN4bgKamf7fys6RPivZlzdQfvTCaq/IEkox6pkL/fvmFrZeDwv6XdhmpuUvY1l0Jom7W2sd2HBhzIo7nV+SggcU1AGAau3lbgVdH7T9/cAxUcE/5brC1Nw38WXj+BWmsuWJoVDyfl9MNPX2VfgDYfsWqm2lHzhrdL6e60CM/L+62QYjrBYJjhH4/ZkClCyXgWc3CVZZADlI5E2wZ+E/K6C6c92qACJdVF33fELArRNkA0+o2it3Ufo4Zh5DVDZ/MLrdxtnGhozWPX27rADhKZeSIHMOdYNKWZ4gl+R
 F94yfmnM
 060+4Dz1VMBQYrBRhPd/oB9aUIKaoOcSMBnKRw57+7lrAeyz0b7dGLYDNP88CCpSd/C17TSrh+m4xNc6Ygy3BM/EffMLfmn1OekfVdYrDbiGh4NODf9hv647HhZr6RIG15jdBT+SHtr/4GzgP8UK4OnCkwms+TKiynaGJ9ShEW+N4TSECFuLAAEsFfoyCB/H3lBHVLVouRMqxs3vwXlpcebao6ak0/5clsM6xWNraFZugJWW2ELa71/XL9PJ4p7j60UB5fOkfg8bjKw6NnMEBMRQYbtxv8B8TdfgXpzWOVkAUC2St8eZ2xfT4N27aeD1QV3p1IfEvdoQczqAcjPqf9YepKQlwvX3EsAbIrsZnyAd28Y/diIiStAxTyCmTt+fpAj5nGwV/pwKXQ2aVxLQPl0mOmSARuRlRPHFeR8SO2EduIGfdBqToa5CSaXu1QXQu7iG6THNrrpaUwtTgYqE4ilaYKLul9pK/l3gOB7vYWMdWZkOxFrFZWQmc1Y2hrTre4Dhb9IHOvfAOpE4wTKjk4sO1XB6qMik8GGq3okqtvWudyqyQMvWPq7QbjuDUAqgXJMkvsJOLqtCv99DYBdmBEpfDpql63S7osW3ISo4qHor/oJbNS8Swosw4z87WY9KsZS88FpxnAO+2Zi8m3wyVczf7+QTua2rU9q81qylb93Ko/3ohLwV6+7qG6I0hMhBs3sJfNfssHtBBFKGPNwX2PTN46hlZdBTsfMuHI7aI75KPU8oZBY2IvtanUwD5aL7qeiQM8reFwkWdScpq9PF4S6yQg7et0vRBFNk0n+yJ2sIxH9/k1Kt1CCVVhTcW+aGd/+giLD4l4KZi2ZcYvT2wWerb/5R85rN2r7MrYSzfvXRt2Y9PqPCjWiU62Kv41YE8oAEZKt1q/ux6O1o5/9qkNfcm8weLwKt3ejajZK21WNjOOtft0QwIjdcyAGgrgqo7/aLyYGiCcZv4y28CnV/qdvU1EQow
 6JJ3DyQl
 KSjcyBruD1gIQpNOfW7caIZCrqE3nDnwRGEP9Kcqw80XYdN8ZyhACC7y/i0Ne8jzr8T+zcDHkLuz691lD7eFmxF+u8i52ehgMnPQoiWowh8GVB0wG6h3uEauy0XRUl6UFUDS1ZwaAIlufRqg5UpiSP5g33RXh5TSzRpDqGKivIRz66BzXk38bIDPvv4LxaUjavYZ29oOLqdirGiucdDFB9W31njODilDPRWK7XLc9q/JCXGkMvRKWOmzmI/d7F3JoYk5t82bx2NeqwVdF+L2hQTuQN/QinJJz6vfvSRBeG5LdQxZ2XjP+X40Rcr8OiF8soJZ8N7l8RUgElwRygi0fqt3aafAG/L1emIWFKMmM7i3im5BCzywtMiOsm+9pvjjlYIFUjiJf3FXg6RkO5rgxu+O8RRPYKwhiIJKt4LwQax6gHvCpV8g9+XRSpjVu/uKoEerlQtSa2EQ471M6+mSsM6mXIN6JPnluq3sGbU2WneipKSzkcZyzBXgjjcIKiV6M4SGP0Z+A5ni+UtidvpYyrsJBfiO86+piLn7aQ+9mRZYYD50z9T9yBWcV686/qQPDyt9ZYkYbfRGCdB442qsHsyPVFw8V9nr+zHzGYBcD0Btk5uv9T4GvuNfVg/H7YbHUKk3OfnfycmnMqqRjGkVOi+9B8WsQvcDQ82Bm+nx/iHo97N5AhPsqbGlO7+1bxB2DoRjb6ebn+Wx9+zVvMuePhEPhQ5qHIHw94CTwg8azcF6xwUbrFoBTeXbUsoDAR73xgvZR8+oW4YPjbKLpnJkwXdPrSLpVuAlbAvKkOlR/1Yj044afwlvmUjeprQ3UTqsomzcyvPuzZ4oXUAFK9pSQ7FCH2jo9c50BORXJd3iZGxduZY3s2lXU1bygIKwwWMSSlkth1CRbucO5EBbsv32YRNVYpuTlzKrBs1/dF82BYiu4uEnmFEWxRv3ogLbHA3CFM3mLl6L1lUbsXR9HNznu8mIJYWp/
 wqu62ekE
 7N38WonI1pV3QQC9PImEavazrDMlF2liuGIaA8utJ7e8qpQLMaSX6uS1iJmGYHuLzFrf2eCoVo7FUj11OPHwka9uv+Fz97L/PX3+YcavEC8fZfbnpcSitCpZA36zLaLvbgBnDwQwmrmFcFoXhjV04euVN8XNwNCqE6WI4fGITVi/1XFQ0qoSXZu4UJPwQO5GbI53Ym/fdbP3iTCdy5ecHa4KdhvhppLTM0CxUdqbZWcOWVF9Kb13PEfqgAqZOE8jt1E9w2cDoDoFTtNoq35LL9buAj/PYMHDRhCfAqmPWBVVvO9lZg+GZs8E0Mv0ZQ6lcx3+aF8yx29i+lkbBGVRIWdvspNvhCq9CehiRhZZp1FatukB7AgunlZsHr+mPHGxXTUiR99LB5G8uTFI6ZSjPlngmB3ddrhjTFIfom+gYvCoLsFGBx1ahKe2YNrgaXiaG9Xg6Dl1q7bP4m/p1P0VV37HkGwKHzYRH7HNAeus5Kds11gqmzSnc84sdgtthHguf1NhYXIIwaPmU1m+8+/Mo/3Ri6vfswjuQTWitGdfNwISjWfKAmJU3QktuaM0sY1bLvWp3Rl31bkOVDCSeHXaAIhWBeMAA0i484ObURj08wGuscwqtYZPLn4on7GTHMYsPacWGghRfu26Y2SWoNDzhJ9v+IcUdfbEfNKkXwgGRlsU+wreq4m6kVTDZ0neiGEa02KrSz1d3Gvu9beL5SWUM3xwg18oC1PB+0OB0Bdqxq7B0Eu20juApyHUIqn+KDiWsuEjQE2rCtGrwNEIwfzVzYbRlk5c2q8Lwb199AW9T584xh9eIDwS7At1SCv6+zONQcUXueO0kPFGciHkZX7cbQa8jBD2vD7nF6YOV7rKWBIOZX8mVEs8Teb+5zJ3R2LURMgJZ/eRBYoUDRL6vyz9gB5Dxqgjy5SAPQdSCtSP1y2HbFHFhldEA93t8jI74Dgg9fHFu6ezL4sR4LKJDvQq1yMr1WFY/
 uWJlsXln
 u2a6oCNWHommqzdwZ27+9aASGHTnIdW0KOyi3LALzeSY8WK4LGeEI8V/L+BTnSKsqrGuropktikJu7mcc6EQL8fXR8TrCHC0McnoJcrUvdPZ8WhnPA+hPfJBISr8tqYDGF6vVS7/M6qAWno+AvdDiDeyIV7MUFl5Xih/jQRhohMLXZAr7soeC9U31RoxpuwHH1KRcu0iZ07n4uZslg3cE48Sfo5UvsAGTxtwRhmFqmyPtizWrMPEnin36Ox1hmJDrLZClWQh4msSTsoZy/yd+Q8+svbCQfMdpRrFUPxGmLbCMX9saZ81/1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in hfs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/hfs/catalog.c | 2 +-
 fs/hfs/extent.c  | 4 ++--
 fs/hfs/inode.c   | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
index b07c0a3ffc61584165e8cc9f646de6066a6ad2c9..7f5339ee57c15aae2d5d00474133a985be3af6ca 100644
--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -417,7 +417,7 @@ int hfs_cat_move(u32 cnid, struct inode *src_dir, const struct qstr *src_name,
 	int entry_size, type;
 	int err;
 
-	hfs_dbg("cnid %u - (ino %" PRIino "u, name %s) - (ino %" PRIino "u, name %s)\n",
+	hfs_dbg("cnid %u - (ino %llu, name %s) - (ino %llu, name %s)\n",
 		cnid, src_dir->i_ino, src_name->name,
 		dst_dir->i_ino, dst_name->name);
 	sb = src_dir->i_sb;
diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
index 60875cc23880b758bbbb5e4b8281d9ee1f2dbcbb..f066a99a863bc739948aac921bc906874c6009b2 100644
--- a/fs/hfs/extent.c
+++ b/fs/hfs/extent.c
@@ -411,7 +411,7 @@ int hfs_extend_file(struct inode *inode)
 		goto out;
 	}
 
-	hfs_dbg("ino %" PRIino "u, start %u, len %u\n", inode->i_ino, start, len);
+	hfs_dbg("ino %llu, start %u, len %u\n", inode->i_ino, start, len);
 	if (HFS_I(inode)->alloc_blocks == HFS_I(inode)->first_blocks) {
 		if (!HFS_I(inode)->first_blocks) {
 			hfs_dbg("first_extent: start %u, len %u\n",
@@ -482,7 +482,7 @@ void hfs_file_truncate(struct inode *inode)
 	u32 size;
 	int res;
 
-	hfs_dbg("ino %" PRIino "u, phys_size %llu -> i_size %llu\n",
+	hfs_dbg("ino %llu, phys_size %llu -> i_size %llu\n",
 		inode->i_ino, (long long)HFS_I(inode)->phys_size,
 		inode->i_size);
 	if (inode->i_size > HFS_I(inode)->phys_size) {
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index b19866525c1e9c43decf3a943c709922ee8630f6..95f0333a608b0fb57239cf5eec7d9489a25efb3a 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -270,7 +270,7 @@ void hfs_delete_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
-	hfs_dbg("ino %" PRIino "u\n", inode->i_ino);
+	hfs_dbg("ino %llu\n", inode->i_ino);
 	if (S_ISDIR(inode->i_mode)) {
 		atomic64_dec(&HFS_SB(sb)->folder_count);
 		if (HFS_I(inode)->cat_key.ParID == cpu_to_be32(HFS_ROOT_CNID))
@@ -455,7 +455,7 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	hfs_cat_rec rec;
 	int res;
 
-	hfs_dbg("ino %" PRIino "u\n", inode->i_ino);
+	hfs_dbg("ino %llu\n", inode->i_ino);
 	res = hfs_ext_write_extent(inode);
 	if (res)
 		return res;

-- 
2.53.0


