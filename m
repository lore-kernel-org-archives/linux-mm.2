Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5416FEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88CF6B013F; Mon,  2 Mar 2026 15:47:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFEA66B0140; Mon,  2 Mar 2026 15:47:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BFAD6B0141; Mon,  2 Mar 2026 15:47:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 862F16B013F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:47:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B9031B74C8
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:47:05 +0000 (UTC)
X-FDA: 84502307610.10.D17964E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4424E1C0003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:47:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ambSviBj;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFaD7sjS7sfimEKOYa5+6i82qhBzvyU2XQtixt9c5iQ=;
	b=GdPLj1gUtB3GpscwdhT1b1nlDYWcJJQxBKnVluns+L3I1Bi8Ndl39zHyv03jzAaz3yrcaA
	+lxE7TQVlTU35NogcQVsSgJJ09If/1ZK4YeRzCTAPjUauNcuEcjz/Su1byQx0xscq3RIwP
	T640ebLEdlrOc7PFFjTHlaUrseSGFcA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ambSviBj;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484423; a=rsa-sha256;
	cv=none;
	b=3Pv7/sLi+ZFclwT7kvYuXBX8sujudRGMT3jAUZiOuyxs4LXYF7Mdt2n9SS/HfSU6M33Zta
	5x6NDGOa5qLKns6vEvT5IA5kyUhpCTZUSXpCbuCa2chlcYvFEI39bJmG+xG06oYvYY7KM2
	REg28B9E/zSro6DTVIGPkujTWpFC+5I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 34FE943B9D;
	Mon,  2 Mar 2026 20:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88BBC2BCB5;
	Mon,  2 Mar 2026 20:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484422;
	bh=oqS9QCg9tNmYBpy8UvwdK8zGUnF+eDzx/i9FXGO/+NE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ambSviBjmCNOk2xXOf+nbet7ut3aY5kYin6cYiQEteMyYXzmNBttnALg2M4Xxw/i+
	 xggPLGKocc224mtCMRZsty2EiRAB2oMlOk4zzemvCltwJ7/ucAR1ntsajehYzEsknw
	 KwZUPHkK/S3Ti9fnei4Hc140jc80cuTALDU1qcx3m3hJc1SIBjv6Ysr9al2qul8l7D
	 wV8MKIk8MM0CcD5fbuRZCOzXA8QY0l9XSoGiWNJFX8dhE1M4UI7eXgUpBJoxSyQi2m
	 l80+gaEUFDBf60BEkoo+/oD3sXNYEGTCZdVXExhxfkOIvZBm2iInrtdQbzzz0Kc+O9
	 73Ra1j8td5Efw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:16 -0500
Subject: [PATCH v2 092/110] ocfs2: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-92-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12030; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=oqS9QCg9tNmYBpy8UvwdK8zGUnF+eDzx/i9FXGO/+NE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIIj81VxxMGzhEZ8rAVGcYo7t3Bf8RZm//xr
 Fh4EJj3nFeJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyCAAKCRAADmhBGVaC
 Fei3D/4wQsOGhcBSZj1b0ZsugS9tZtv8BCz0qm495sOCVFVK6YtC8n6F/VSVFgwg5sL1qtMl3VS
 6jEVUa0opP1CekoyqC/kE3lbCPLd5Q77Ol4H50/ZjTjfCcP0ml1W5m/7nYgZwSMeootACnqCmMu
 QE8ASYqomYlLtYLIM4+mdEZg/JIVmQPMG2N8BPend9rXOiR3xgh+78HEBsGLONI4XLkI9yvk8aY
 8uuVtJxCk0BlZc48sSzcsX2iCnxxv+gJx+bGpzflfdkakD8DFD6UkSXGIElmu8mHXFBca4R6IF/
 OdAIABvb2rD8HoOB4raSQZhp1AtqtMI/YD3Ks+sVRENXgTm1yc8E23s5+rpiIo3GxtXcYE6JKiF
 2tx6HaxLYI1MTiBzk1TrOMtvSSZSpXm+RfXRnudO/NgZ498jDMt4/vtaNJdTqAZuYyB5KB/3aht
 j4vxSd5DoKTpAIl4NYZyBU6zjw//Y6zDWoYDGcv96K81P5SJ0qz4dMHZT/HItjOtjOWcw0MIM2Z
 Rta4q357T3iCydta3+cNFEbSdAYOlmWhh03+doo2FKeswDWfRVtrHxEPN4+/ImPCYS5FcamCIEy
 uqv3BipzONX947eUI8oaT0TrY/sq7WV015zEmJPpU3QND5ZkZbF7M/wI0rSkdI4jxQWAxmF4E6G
 mhRwe7ufflieqxQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: xik1u84ttdgu7x1pesg83d7jk6tnd1fo
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4424E1C0003
X-HE-Tag: 1772484423-506821
X-HE-Meta: U2FsdGVkX1+0EKGSk62lE2eNNYq74bYXrT4ldnzvfqQ+pq5lyeXorxkXmj5olNym/AIh90gOGhpUr2PXPlofu17cA1Xita6XZb0DNYitumaGc+UGGi3yiu/+Ud1gRPfW6OaaJWTAKp6/Fg05fl4aPfksEc1E15HAaVUaZKnbSgJv4L6cXZ6uUEl4RgYz8j7SkajLJXssSHCyC6GTo8iiCo11jZpF/lRdcYTDgjN5RzTRdhTjcIl/fK4NyK9yFKMgGjOa8u9/5PbDfiRhRQBFba/RNL+oCtGqNp+fMQJlTlMEZY+NDgIZV0/WsGwYEqryOxCy4iicBr8U9RyB7Sfxz/oVhFk46upUEGzopErpa14mUUv+H2BkrloZQwUVFKIwS6QA1IBzCPw4axDRPzizIYd3BHz86UyM0/mOnfqRy9QsOm9Lv/BPeeRtaNfmxwXoEHtYqh2eJMbFYBNz2sFyE8WPwz6210sJi9HHqvjy9CmkADCiwZQc5bGgm8v5vlT1kwO7VIieyrX8ZRq/QQ44rOr8XrjgjqLnU95PYq6s6JSqxHHDPGLgcYJ9SfKH+ryeJBp8TavqD/jlsgKOBasprb/Xw3bK8i76MJvPu6BuEpjl3mV7lJZic1eJkqR0lVR1kmTLP9vkDBkjNoamOOH4bNEjQqujypPV2tv+8EGtvHXa07TVc3czn3aiwQSuJ+bVFi/4tSkBMtmEzFN1bSTwT37xCz9ofulIkDETkn8tCWgIu1CgiqFmOzKL7jTnkXcRHxb5Mmq/I5bi0Dw5pHJUKsq18N9S4OWwzDUPOttFZLo+B3r3S/5LHLbJwtS5KLhi0oYpXf6yj0RvZS7Y9Q+FuwAmfrjdh4wDYvGQtWxrhFhYijDc1Si0ZUToKdOMIi2CE/qHUruNxfBhw+M7B9qagGGUTZ1kFS97htDN4jNG7Lw3Qj7gf/+fL7jjpCUyC6oGyvaRJNqg3VC3rCV/dvw
 60ZeWjzY
 FvwzTf4JEeTS8CMiEgtMYrRhOav4bf3hxvQwk5x01s/XXE95fR2YHIY9H1mBX4Frsi95PQZqZyy2T6voLYeRfhHC28/F/sPjHrQI9I9INyyixYSfNleVLgndX9CeNT3FEVXhRl6WKCzUiG8Nlk2PcE7wSygWmpb9zPW2XXEEaX4MiF5KK1Mbst7GGuCoP+CuLtyDtATK4jr5Qqqqf9DstEPAmQyzjjmStj949EpiVnph8H97NtDVti1J0rCyHvlvu4nFGaNGOCrutxKCvjWFZ07LU/vJ3fIIvB7NETQ96MXKJumVodRZUF4DBkH64W6F/cmfUYyQj2XeQSfVe/Mn9TmhIrd0wV7B6jQdBOJbxZGRn9NSoozTVxK4iZrYUSz5EnFP4Vj1PW+0fIQziPrEFNcN5huYBk0N4hKidVJSMzSD8lMr8XcjA1k1wvnXCDvX21hrpKrPWMKZr/Gk6qWhkRm2E9pJT0bC1RNyqzjVaYuzu/ETATffE/D67ZIaEgOYgv0RHMyjLwK/+3IPZgL+OAK8ytfqYv8VfTiVJefvmWnJOAC6DAKM/ZPfHkRpZjqCqbMTtADVTZWVqn0qgNCaXwtxGe+1ITEqiPghuR/vUlhFL/mGdZezeOQi6d4JVVlcxCebkT+3QUeEBfk4W9YpCnX+ac7sV6Z7499VMLWzwEmaYqAy1FX3FRG0VN7ylreuSrk05KPkyCP0UEJtAlvXxSCbBevkr93p1zSqq72TJTFZIXY0WsAmWtJkSz5jEs+w+7woGVAfzohMxCtK7+XkCxa4i7vpMzXf1uKV95DoLRVpdyIDoCVl+f6b+oXXGOxY2Eu4BRXPjIlGIHMDmxqXdHURTukFoL2rfINaOE7wMv39ncVf8LGgZBxnU32Pe6a4sRQhaSFpQfriwGP3hmzfDVROJdZEieON3mCii9BCBU3+azf0TChO2n8BG49cW00yEucm8ptg+XvOC0llLqxnojo791dPe
 6aGv55Wg
 QcVKU7XdoiuzBR5h6wXdJcoL4Wuk3WL63TFMKgNFjWakYKdHExbV34c4NeTqv58obSFr8tmqyfeFw3zplVYLCkpRj1TYhC2RJY2iCKPd0xc3Vl8DXmtV+IQLYmdPGypXVtYdoOx9hMKetqis3ms1Isq0mTqzkQfkLZ+T9x2GJAM5R8zHqwUWVZ3vghLYvJ7i/zHhis+23vZenDJQKhhi+YCtX0TnAaoPT5S4rOrCWyJ+DjzITuZczXtDnStACltYBP/TicDeWqbbGvB8eslj4oMAtebteT6ZU/H3M8H4T4B7h95Tu6gf97vhWh+o9AkYl8F1MmYprourfhinjJ/C5mFCS/JEj9iRsY9tuVrR3SeSUyfoWXTDPwIJVwfyP6mvt7UguFJza5squyWOwja1U+bjN94hpZXBJSXWreBOCQMXCnlYQIjbADWyol1t/zQRvlMBwQvYgw8h7/vI5QxurPgotisoin10hW2ujmlI4sF5qd5QY0IbVAj4uqXwgiO/lbi8ztSkNbBHf7qrzFc5gyY85bd8sNEvBDpl/dAAKr3kxsm0n8pudgvvSbip0f3JJ/0PDQCJ3I1s3/8eYPdNAw6KCPtrdWBxVlUqdVD0U0O/qlGRk9qJfLATB4VM1cll0u0snwdmZa2OvCEOYyHHW3yz+AIJvaa1f3QRge/FWtjiyuk3/bz5UDGL7rbNt3c4t/r9T5OD1LiDhHTiPBpJZSLC+wTHC7imcXDZCdbeCx4rjcfcb8clgGKE9vtuysureqp6HbI2IKgCHyZETrtQUN533FaF0UzfkbOL7c2uaYCmk46ct2U1HH98EmJOJiyoHk2n3N9h0Fz9H3Jgl57R2iLX8zwhVP5+DAkVdTyyiFOswcx7pBWNbWhXJC20S4ZQRB1M/ul4UFsNXkS+aV5sQRjIZ6mKbY/1l/a+5VuPkerova+om4e3ZrHzmid4HJHMd8YbXUmji4ZBK545f1ctslfXbRHvr
 Kn+i9yjv
 PUeGRwNeTp5vHzTLqkfYQQbwZ8e/XdRFEjVc/hfalQ+3r4RoEul5xQ+Fk1iyknllEbjQPtVDf3RRF7L6YjRNCa9Yf5uiyyjw9CnkPi9JjVXn1AhmVI+XAAI9SMeFiS7iKPou2zC66jGjl4LJEOt0i73UEG6se0dhpBX7onejrRLffHcwN/9r1MO9q2qI+OifdklSx+rgYmugaLJlf3a3SP8xQpvmPJp4WO3jAV9TYhjWN0KUzyC1WMXI6Bkw4nnH3AWTCfp60sCrzgJlReg7byztRSI72h3Cex5rqCF4oCHdeOw0MgBVJxeOBYa6D5CmoivPo6Y011U/SzcMuuTAvzLPcmIs2uvljZFNXziUay+Y4c+c7CPbrk1Jtjo902Qee1f7V5RwrI85yQTWzAv8J6/5pUzYQmJOJRo7sEotfrb+MF26+ZkYKWezJXj+Tab4YPVQ3SfO+u4CZofC1IpLUys4POxpEETqTMhfIW5EUPquRg7F9HKw4Kwl/KQIgO6+7ONMDwUO8sjOKYE6f3CsPTHkJgqEsC8VWcYri3kdazZaU5IvaTcS3bGRVb8JZ7ItF8u0tI0j4gza75UdKIObwlFY9EjAmDkC2nAmJsaQ6aURlqHDh20oLWKI+cVGu5/KTqlmnkCv0h9bZlbHBIfpmiCEj9HYlWzTflYdvZ+Lh4+5dkITMmmhGgACt/K6OIzH87M2mJF4sRvE9Ougrbyn3ZP94dY471ENqy52EUCTx33WL7hIORvZFAjeNg//jqXisj8O/tNy0wqhIwirHhZzyMjBKHq/dmp/XEMhjytMrPbFNeMuQKYOBzzDXj5B0wAWXMe1qTsNFQVlZEoZZvHOxGnOhuKxMVg3zUuuzgib2Mll2UME7P+BON9EI+A07p4FY1eFCceTjavWoNJsBLCyohi6mILSz2D80vTRWsJZNhN77Fkfk1OT77l2yyTSGFy/bmSDpiR2/Ck/TwEfCpG+skH/+p7tw
 piJ7oyvq
 0ruioHgmEyVZn8I4e68HBa4CcFmiS9jHMrqqQ55MIo0Y7fi3sXMR9YDdM4vG7AbJkl6jS4hz9dtU9nHVqzJww4ULHPcdNHoh2gs3PS/IxPi1kVOMjQB8E7L7pkXGEROTE6WWpKeD2e2owLUN4mBALxbSBTWtzkdI/5pWv4eeRpbxyR0iEVkmoDp+krSujqjx8iprSeD2y9zrey3kXSaqK3VwP3MWiLBXpxlrF2yaFEV0xp3sdSNhKLOzOtG1oNE/ZsorENNRvZ76dN1wBBmrLu1EblSsjumvaMplkRuNwOcM/IikAgqEvz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in ocfs2 with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ocfs2/alloc.c        |  2 +-
 fs/ocfs2/aops.c         |  4 ++--
 fs/ocfs2/dir.c          |  8 ++++----
 fs/ocfs2/dlmfs/dlmfs.c  | 10 +++++-----
 fs/ocfs2/extent_map.c   | 12 ++++++------
 fs/ocfs2/inode.c        |  2 +-
 fs/ocfs2/refcounttree.c | 10 +++++-----
 fs/ocfs2/xattr.c        |  4 ++--
 8 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index d7703549645b548d9f5d77b2214a9a7c0af0ef6f..d40f5d205bce3675ffd37e0e6c228e88c1804a1a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7318,7 +7318,7 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 		 * to check it up here before changing the tree.
 		*/
 		if (root_el->l_tree_depth && rec->e_int_clusters == 0) {
-			mlog(ML_ERROR, "Inode %" PRIino "u has an empty "
+			mlog(ML_ERROR, "Inode %llu has an empty "
 				    "extent record, depth %u\n", inode->i_ino,
 				    le16_to_cpu(root_el->l_tree_depth));
 			status = ocfs2_remove_rightmost_empty_extent(osb,
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index aea35b1c9fa3ce7327672c1862d0d1201c895c40..c7ad912ec7a0d6fffd09c3d38f110e5d1517d829 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -137,7 +137,7 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
 			      (unsigned long long)iblock, bh_result, create);
 
 	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
-		mlog(ML_NOTICE, "get_block on system inode 0x%p (%" PRIino "u)\n",
+		mlog(ML_NOTICE, "get_block on system inode 0x%p (%llu)\n",
 		     inode, inode->i_ino);
 
 	if (S_ISLNK(inode->i_mode)) {
@@ -2146,7 +2146,7 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 	    ((iblock + ((len - 1) >> i_blkbits)) > endblk))
 		len = (endblk - iblock + 1) << i_blkbits;
 
-	mlog(0, "get block of %" PRIino "u at %llu:%u req %u\n",
+	mlog(0, "get block of %llu at %llu:%u req %u\n",
 			inode->i_ino, pos, len, total_len);
 
 	/*
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index eecb2b1d2ec17fb4b3f09abb9e168d2f28f9b420..b82fe4431eb1f0811d81525237d02c5a3f3b021c 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -794,7 +794,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 	if (le16_to_cpu(el->l_count) !=
 	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
 		ret = ocfs2_error(inode->i_sb,
-				  "Inode %" PRIino "u has invalid extent list length %u\n",
+				  "Inode %llu has invalid extent list length %u\n",
 				  inode->i_ino, le16_to_cpu(el->l_count));
 		goto out;
 	}
@@ -812,7 +812,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ret = ocfs2_error(inode->i_sb,
-					  "Inode %" PRIino "u has non zero tree depth in btree tree block %llu\n",
+					  "Inode %llu has non zero tree depth in btree tree block %llu\n",
 					  inode->i_ino,
 					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
@@ -821,7 +821,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 
 	if (le16_to_cpu(el->l_next_free_rec) == 0) {
 		ret = ocfs2_error(inode->i_sb,
-				  "Inode %" PRIino "u has empty extent list at depth %u\n",
+				  "Inode %llu has empty extent list at depth %u\n",
 				  inode->i_ino,
 				  le16_to_cpu(el->l_tree_depth));
 		goto out;
@@ -839,7 +839,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 
 	if (!found) {
 		ret = ocfs2_error(inode->i_sb,
-				  "Inode %" PRIino "u has bad extent record (%u, %u, 0) in btree\n",
+				  "Inode %llu has bad extent record (%u, %u, 0) in btree\n",
 				  inode->i_ino,
 				  le32_to_cpu(rec->e_cpos),
 				  ocfs2_rec_clusters(el, rec));
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index e96c1c574ff7dc3dffad58ce8536b7e337d3f6fa..5821e33df78fd92fabc7fe7fa1c3b3c62c50f9f8 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -123,7 +123,7 @@ static int dlmfs_file_open(struct inode *inode,
 	if (S_ISDIR(inode->i_mode))
 		BUG();
 
-	mlog(0, "open called on inode %" PRIino "u, flags 0x%x\n", inode->i_ino,
+	mlog(0, "open called on inode %llu, flags 0x%x\n", inode->i_ino,
 		file->f_flags);
 
 	status = dlmfs_decode_open_flags(file->f_flags, &level, &flags);
@@ -170,7 +170,7 @@ static int dlmfs_file_release(struct inode *inode,
 	if (S_ISDIR(inode->i_mode))
 		BUG();
 
-	mlog(0, "close called on inode %" PRIino "u\n", inode->i_ino);
+	mlog(0, "close called on inode %llu\n", inode->i_ino);
 
 	if (fp) {
 		level = fp->fp_lock_level;
@@ -242,7 +242,7 @@ static ssize_t dlmfs_file_write(struct file *filp,
 	int bytes_left;
 	struct inode *inode = file_inode(filp);
 
-	mlog(0, "inode %" PRIino "u, count = %zu, *ppos = %llu\n",
+	mlog(0, "inode %llu, count = %zu, *ppos = %llu\n",
 		inode->i_ino, count, *ppos);
 
 	if (*ppos >= DLM_LVB_LEN)
@@ -301,7 +301,7 @@ static void dlmfs_evict_inode(struct inode *inode)
 
 	clear_inode(inode);
 
-	mlog(0, "inode %" PRIino "u\n", inode->i_ino);
+	mlog(0, "inode %llu\n", inode->i_ino);
 
 	ip = DLMFS_I(inode);
 	lockres = &ip->ip_lockres;
@@ -490,7 +490,7 @@ static int dlmfs_unlink(struct inode *dir,
 	int status;
 	struct inode *inode = d_inode(dentry);
 
-	mlog(0, "unlink inode %" PRIino "u\n", inode->i_ino);
+	mlog(0, "unlink inode %llu\n", inode->i_ino);
 
 	/* if there are no current holders, or none that are waiting
 	 * to acquire a lock, this basically destroys our lockres. */
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 3cf93a08f7a8946810ccd2de246be4d07a23b53b..eb5dcd17d43752c08eab423fd667b7c0363ba6a1 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -291,7 +291,7 @@ static int ocfs2_last_eb_is_empty(struct inode *inode,
 
 	if (el->l_tree_depth) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %" PRIino "u has non zero tree depth in leaf block %llu\n",
+			    "Inode %llu has non zero tree depth in leaf block %llu\n",
 			    inode->i_ino,
 			    (unsigned long long)eb_bh->b_blocknr);
 		ret = -EROFS;
@@ -427,7 +427,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ocfs2_error(inode->i_sb,
-				    "Inode %" PRIino "u has non zero tree depth in leaf block %llu\n",
+				    "Inode %llu has non zero tree depth in leaf block %llu\n",
 				    inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
 			ret = -EROFS;
@@ -437,7 +437,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 
 	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %" PRIino "u has an invalid extent (next_free_rec %u, count %u)\n",
+			    "Inode %llu has an invalid extent (next_free_rec %u, count %u)\n",
 			    inode->i_ino,
 			    le16_to_cpu(el->l_next_free_rec),
 			    le16_to_cpu(el->l_count));
@@ -472,7 +472,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 
 	if (!rec->e_blkno) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %" PRIino "u has bad extent record (%u, %u, 0)\n",
+			    "Inode %llu has bad extent record (%u, %u, 0)\n",
 			    inode->i_ino,
 			    le32_to_cpu(rec->e_cpos),
 			    ocfs2_rec_clusters(el, rec));
@@ -561,7 +561,7 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 
 		if (el->l_tree_depth) {
 			ocfs2_error(inode->i_sb,
-				    "Inode %" PRIino "u has non zero tree depth in xattr leaf block %llu\n",
+				    "Inode %llu has non zero tree depth in xattr leaf block %llu\n",
 				    inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
 			ret = -EROFS;
@@ -580,7 +580,7 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 
 		if (!rec->e_blkno) {
 			ocfs2_error(inode->i_sb,
-				    "Inode %" PRIino "u has bad extent record (%u, %u, 0) in xattr\n",
+				    "Inode %llu has bad extent record (%u, %u, 0) in xattr\n",
 				    inode->i_ino,
 				    le32_to_cpu(rec->e_cpos),
 				    ocfs2_rec_clusters(el, rec));
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index c3076b450de3599291c386ceeb8b2d26e8680904..26025ba2656c66b61866deaff60a0da204745c4f 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1196,7 +1196,7 @@ static void ocfs2_clear_inode(struct inode *inode)
 				inode->i_nlink);
 
 	mlog_bug_on_msg(osb == NULL,
-			"Inode=%" PRIino "u\n", inode->i_ino);
+			"Inode=%llu\n", inode->i_ino);
 
 	dquot_drop(inode);
 
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 1586c42fdabe70056bf7f103d583dd9000fe9510..6d7f44d3e929d94f3ba6121cc30a867887e0bbe3 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2341,7 +2341,7 @@ static int ocfs2_mark_extent_refcounted(struct inode *inode,
 					   cpos, len, phys);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
-		ret = ocfs2_error(inode->i_sb, "Inode %" PRIino "u want to use refcount tree, but the feature bit is not set in the super block\n",
+		ret = ocfs2_error(inode->i_sb, "Inode %llu want to use refcount tree, but the feature bit is not set in the super block\n",
 				  inode->i_ino);
 		goto out;
 	}
@@ -2524,7 +2524,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 	u64 start_cpos = ocfs2_blocks_to_clusters(inode->i_sb, phys_blkno);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
-		ret = ocfs2_error(inode->i_sb, "Inode %" PRIino "u want to use refcount tree, but the feature bit is not set in the super block\n",
+		ret = ocfs2_error(inode->i_sb, "Inode %llu want to use refcount tree, but the feature bit is not set in the super block\n",
 				  inode->i_ino);
 		goto out;
 	}
@@ -2650,7 +2650,7 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ret = ocfs2_error(inode->i_sb,
-					  "Inode %" PRIino "u has non zero tree depth in leaf block %llu\n",
+					  "Inode %llu has non zero tree depth in leaf block %llu\n",
 					  inode->i_ino,
 					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
@@ -2662,7 +2662,7 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 		rec = &el->l_recs[i];
 
 		if (ocfs2_is_empty_extent(rec)) {
-			mlog_bug_on_msg(i != 0, "Inode %" PRIino "u has empty record in "
+			mlog_bug_on_msg(i != 0, "Inode %llu has empty record in "
 					"index %d\n", inode->i_ino, i);
 			continue;
 		}
@@ -3325,7 +3325,7 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if (!ocfs2_refcount_tree(osb)) {
-		return ocfs2_error(inode->i_sb, "Inode %" PRIino "u want to use refcount tree, but the feature bit is not set in the super block\n",
+		return ocfs2_error(inode->i_sb, "Inode %llu want to use refcount tree, but the feature bit is not set in the super block\n",
 				   inode->i_ino);
 	}
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 74cd6dd57abf71a69adef18863d057e48496ccfe..4d55ad963ac514b4b4081447af0992345facd83a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3741,7 +3741,7 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ret = ocfs2_error(inode->i_sb,
-					  "Inode %" PRIino "u has non zero tree depth in xattr tree block %llu\n",
+					  "Inode %llu has non zero tree depth in xattr tree block %llu\n",
 					  inode->i_ino,
 					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
@@ -3758,7 +3758,7 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
 	}
 
 	if (!e_blkno) {
-		ret = ocfs2_error(inode->i_sb, "Inode %" PRIino "u has bad extent record (%u, %u, 0) in xattr\n",
+		ret = ocfs2_error(inode->i_sb, "Inode %llu has bad extent record (%u, %u, 0) in xattr\n",
 				  inode->i_ino,
 				  le32_to_cpu(rec->e_cpos),
 				  ocfs2_rec_clusters(el, rec));

-- 
2.53.0


