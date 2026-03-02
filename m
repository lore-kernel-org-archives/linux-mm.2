Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79A9BEB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C604B6B011D; Mon,  2 Mar 2026 15:43:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13846B011F; Mon,  2 Mar 2026 15:43:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1CB6B0120; Mon,  2 Mar 2026 15:43:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9365A6B011D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:43:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 414EA14030C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:43:01 +0000 (UTC)
X-FDA: 84502297362.18.2161E31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 447AB80010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:42:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U64fZHux;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCFWiOhDsqsgnqiP9F2feA24eLVqMvK48TFLJm2h3iU=;
	b=x2E60kAI8mn2smdEmRwHsRHc/wGFuj6DophgKmS6j+yGkbmFGMO7Lxic2DUETiCJIyRG1g
	w44sj7sz/AlsHKIQCR6qeEj4iOb2tUVcq1yGftWzMqSwKrLWxs84qtQCJGVkS+Qsg+2ka4
	lPuyq7UVGg/cKW4SsHTFVdAm2UiYPmk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484179; a=rsa-sha256;
	cv=none;
	b=HGc+azOag5A/TlPYDVttWcdKf5fpc078PdeEnrf7aRZw0BkBNnfYWOMYETQupe46DNuGge
	FCkbSNTkRtzaPUYP9PDphMJLXyxWoHt233O7TkR2LV3xKdJFzQEsez7Is07G2/b2+WB591
	CcR3bpYDyPrE3LlbMo3Hcpr3J0dB5vA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U64fZHux;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 45670439F6;
	Mon,  2 Mar 2026 20:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CA9C2BC87;
	Mon,  2 Mar 2026 20:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484178;
	bh=az5/UfgR48DhHcdtOz5xQudKTVsY7dUyG5/iejsoF3Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=U64fZHuxQT3j2g9YM2j7e/vbcbDBvajdnUXKwQIjuM3WFcIX/1QkPqF5sUYX3qHHz
	 Mb4JEexSPcZ+WRvsCPNifVFsOfIy/CB/Z/Glo/3zoEdMwflqDdpFDmrISqab44Dg0k
	 xXkLYaFAC5AyCROU+yxO1j/kVfIKnLHxzCW/grvhs8R6WgbTQJYhsMfGiX511FLGj7
	 G4AsHVkltVKQ3I9t+dgV/Uvo1wOyaHk3xXC3zcnK/CFBb4vsWNY+qK1nFlQBeXjm99
	 1DAM06ER88Zk2V8P4cduXVwHJgbcmFSUq0hqqz8MmZdSkmBf6enZg5hHpsT1vwSIXL
	 Q8/gXJBezzM+Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:59 -0500
Subject: [PATCH v2 075/110] cachefiles: replace PRIino with %llu/%llx
 format strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-75-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3200; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=az5/UfgR48DhHcdtOz5xQudKTVsY7dUyG5/iejsoF3Q=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIDvrM/TGfOFWGOUqzfIyuwAF6e1qhVhF+Yh
 Qv8S2GtC/mJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyAwAKCRAADmhBGVaC
 FX1hEACqbYeHwrURpMMogt8p9UTcZ6PyKhws+kg8vAResb4l8L4XKPbalHZif6Y08h58t/KgmbN
 AkeZNtvuSQBICx9k2yue0Kg1DC5VB163feX+p8iHl4d9W61xhIx9hc9MIZSo48OyYobj5dZJmxd
 saqzyRL+cpFK11qSphNjtHv5QicR5807/BTwqicaoAcc+0wG6Wwww9xIM0EepTkrs/YczUYJthe
 CFXtU18q3Df2UomQg5hEepZS074QE5VH1iwVIbkLo8aGKHjwI9Qhyaoz0GVV6/T5Kzaj0l+B05c
 j17C+65SAsnLhabenAbtSuH2PiV/K+GgKI+EVd1UCeFO4Tndlo8CF2lkIbzEr+uccKkSpo83bdW
 1IqkMQiNWhkDchA4mi2HgqQkwzX49TTnlMxF0uqpVnSgNpRHcBbuzBK1sMTrd8O3aeQdNTYDTQY
 8vvN3iiFDN/D86PtCY1nYl3+mxGdVATt9O9oaUxAi/8s3QI8OK5uXim0mOLMv42sx06Ff63wTCZ
 Gmz7zDOigm9j99CSyK87xQ0wkrLHj1wnv59TUkj378+ps4zBidsrXd3JPdFWl9EVxhMq0P9irT8
 CmZSS5ry0AXxlvqeLQoCk7RzUsNUi9i7238avFyp3g91NNOpuEYTCknceTCWgjP5GtOz3vvQVY3
 JkCvUHLgEBDZ2+A==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 447AB80010
X-Stat-Signature: h4j88yeywt3qqs3mhswd1yahfks3uy8f
X-Rspam-User: 
X-HE-Tag: 1772484179-406231
X-HE-Meta: U2FsdGVkX1+Ve3vxTWBNGdu1dn2fRdvMCtBktpQW0Pm1zhaHfwhdN4OP+BNT4yG0/r6jI7Rj2YI99Q/UoT2UJXHnfMEt9wvLrmdHITxKAZAMeYH8tfXC2nEhhV6chhA4zAV9EcckM4tN5pZH2VOYA6UtsKeP4uPwgUcPmCMAVxPv9KkEbfyWAwC4JqCSQUP+C7AIdwdfBA1cYVe4RypVcJ4PrJpexSq4TGifWBw1ql9zTcE0NsvADobevaif2Oiw4PA6zzYyVxb3BIaoLOUgh75nwFLpaHpxXa3hwPvZEFof4VuJyX2LppDbbtuMFRjhHoKuCwVaHX42Lqa2Nh82r4040cnWLgKwVHnpeYvAdaRxlA0dG9gSJYQWC0MxCQOcyXtcE3xcm3Qz+9AbG3o/bJDIY8VumDeJrwgTKklgws+ZqnnME99vZ+VE4f/BYC/ype+HZbaImirf4FJHgMxKZcqD4SnswPQMoQyV9pHCd3p7ObKIhibLfudK2HuZwjH/i/Z5oEhOFCrlwE5qy2i3P86ktIgrEaE1wPf1HUZ+TbmOzXPVjTMghUDvXGDfL3zbsuicDVkUmDPx5OxTJTB0NZlMp5FaBaRqrHL7IgKqWxpq3VwRGgAZ4GNTV7epFi1SWEoqWbSCJETPTuKumSBurL53AiayuTjd4kZaLKIonjhT3R+yWteZLE/7FQxaz9okr4MIBwsiZrkryaGB5K9tsqZfSo1GEWm3QyiYaitwr9skbuiBeHkIi+7txNlDST/krHzh4MhI++fxqB05biT8whBlJ+OxMBYBOmeBqhND6/mimR1VzIVnq4i5Chn99/wgYBQ9O7GdqEp+SYpS5TpuSWWNmHivrIX/sh0e/AA/7JtS2mQ/qJIF9kvYiXGnKXcXnFEmBshhx3/2+qtMX3OTrXGHTcX5FD2g5SqBBqPYpLoQyDcHRNx145aqKcGzc/c2h6eUqDsF8S6RjF+qY1x
 no+bc9r7
 RCJl5MTE+tSu00ETPKc4SwKwi8Kz6JQR8UrMpV5B/LVEJCS6B6TqJsS1Hw73Y9vA2/gHft2g2H0wRQv8Xy5+0Ag0SXw0hNAZNpcLaCZR5zrncXrrnSYHe0bYpHd40KACl8v2z3r1HfofCB4TAORg3e276ng/IZArJUwxxTN9Q9uPy7SVkvfoPR9rrN+p69oeHdyv+RbGFDX2eiMWEqYocJ3fNvc9BzFlYd/kVE6n5UvAE6EAMiSjQHE2TU1J5p0c3oVzDrLcycmpc/r9DVuZoglcPSsETP3xls1uO1xwNU177eP8mAD3oB4t5PH0EoKzG2GjrhBY8k3e/7mIsWqNMJWqhKgheTCMsZ+flpOOeMhoHL0XCfHxLetBZsjRX7Enbs0Mf4a3ouXXN+nNceEcDYuqlJz1WeZRClPlRdzCOnta3JBkTWFAprw1w0bU/p/5qayBu0e2k1zVB938EuwSVbT6J3bai9BmmNwzdexmnS4FWioqp6c0CLK+pwNew3qQqJ16CJuCtj5qPx5bEg7cPfFh9HlxLgLbW5uzEx+JfRshHLuRy67zewPm+zYaiXhWQqYoSjTb8vr34c4Iw8tl2q/eeJX0dHfFxikVSL3VT72LNXhchA4aOsVOCtgnAbU9l4efmlsFACAIspbEuJSg7Oy0yaT4Mv0e8lxZNGtVf77EfoUROZte9Lomyf4bngQkOjUMdVq9Stk0TEEctu7YBdeGNceRXm0Q9R+FOjgCqww4Ny58lA+eYBP7tPx1WFYR/1Ps1N/FbOkgJUuoChtVQnk3fq7LNVDIhRTI7Sas3Tw71gFoOKXQE0g308ichEOchKKMplGfm0oarqeIl6aA0P65Zmthcj+H/QLpfZZYdu/mtl4gU39goa7rhtiI0cN5rgdZ5kQlDcS53Rfc7bZlZrKy7StvXUQCadPyX51GfgXZJIT28V0AS8RSPqYiFPdjxQtRBgQV/sLhlIf9H1lVzacg8b841
 4NJ5WVkh
 4BPhON0OnaIoKxuoGBSq7KD0Gd3/jgNy7T7S8oLU32eR18ouyZl4PnzOOGRmRDCqUYJ1fo3Iw/n7DJt+FEYiz6iy6YIiOUHpci7L+FlpZg78q9WqGVVP/T3lX0IKsRvW2Jy8X4llvMDoZ4vXu5eNJZaSW7bmbeLUJSbtJUeJxSDUvIHyO6wZRPEi0nY7xnho7apa+qJqy+zCldRU9h+Ap5p261lRvNvE8o9jMKeFRBi6ah1HTnylvAJTDUvoalPWUbi07hQprMRLzMCK746oF/UxBRvdWCI+M3crJmTJSKj2LFM6pA3JsleP6nVzXOgAlaPj79aL9IOhVfN/KEQV3rryPik7nqURL6CuiCmtz5JEK3FbJgXPRbjgG069QQ1tDIgT4gm/Wm5ieNfiiu/SQLhSbTlq/2twqdnQkHMTKWyiPq8qebJgNBJ+2zDtkqcGIR3uDGFYso9ziqcKp4WDWQBLZa/lsti8rXJU9N2PJX1ln5Aw+1BEXn7rWqX041Aiq4rFfg3FqLId+IuuCzufKvv5EmpDu91eCKC6TPNd9AnnEw62Uun6WsncH0F9VNNtvPUvk+PNvE1Os2N4R1F/Y5nvarkM47OCVrYMnaflJNen3edtpB2VHmOTs9uL8xsrfNSyHRtiFEn/bAXBKYBS0kk7bqlEtNmtk4MWORaPi/QPNh75qd+ZnmpTNcQ9Owmle4YzYgs5qIKpvejF0sE4DbmL/BnFE3SFGi/iraM2xkBHSwmCtsX+SfGp9Yov31T5yGM4CjFblBRgoSQ2C/QhK1sC4qXxo1CpTehuGM6YvSwEFyApXyyn66jX+XYC9s3ROb4BI/O++s+iikh3Gkn/Y6zWRRUos6rTgQfes/hDRob3vQ8Ygw5uULVpv1OAcpac58avaJlWB4U4oXNjc7jGnF6pxug9QUvsRjeWvH3f0PYPD6GmXcONCVD6eH+Rm6zJwuOWp6UGCi0wqHRaCfUe1yBIOdON3
 uQteC3A+
 L6IBCJKYl0FoUg84xPz04zAOGlZPf7MJRT9QImP56QylgRPYkMe+fUVbq/BEbAmszbtvZNTQbSe+fN6O0FNdu1Uq8WMCU1ASw/5ghEqMsMxwxeFxFy2ZUiTwYuBDdpW96eSUMw5/C+naNrnJocAsl6SPWBiskypY29jS/cwCaCs9Hn/HOq/3CwLNeV15iMIjbk8OozTdDC0FsDoVC5qCF0JV4GcndsdUpxKWz0xBeRgboqKVsL/RLQlTQN1iQKi6c3YNzXL/2qpT3H5idJU3LFdnao3GDOwlqhRsxkkDwGANGfVVyOY2WwTdd9Xm4NUiCX+ZZsKe9rLL5vB74M2dLYKuBWuDel57JaiD/B6HVIOvVLnFEP1KzBQ0C4+6x9hb4Ygpp2gFw9RW4buk0+q+MZzuCZmdDPZsLM5qF4vR/T7AIBmb2j9AvT9AUUA3i/j0Z6FYSZs5RnFec0VlPjHBGtmtVg70qcgck16Yd5dnJivs+2n0abwYZ+z88kcprd2dVGzz2gW4xLFmmgu3mkcunMwU7NrBFc5TB0O/JPkYIQsErlRGVwkAwdNebvZRq+/PLrnL8QE0HqDHIoM0qJbeW6qEecJSG1xoVVlZS5d0CLO8EqqRCUy/sY4RhIdZZPiqx2bLmF5q5Y5L7O+F4Q7RpV/RHg+uTtBIQ5oLLZdgxX/EBz1JPSCdjznN00HvRBCefnBJBET4HULx3fuFshigl+x89BzMpy+zfrIIVIlZ2TkJlDCHeWyqxCW6MjvBvR1tVE2Emed4ht1yyq40E13ztOSt0GIRxKlwbfmIXC1gEQlkGV0fp4fLwk1o/MJIKn9XCvzHjFnf7qeZkUWvpw4O99BVIfHa0F6+PmT/vgwlq1W3McE+P9uq5cEjmyverJbNBby2loiBtlexrfuhWWxDzorTprhmiyt8dP7gxBWYEbmEJxc+8BLjJG50Eg68hQ0+QAOq0JQw+s23ysdXG7LL8itKBgjVK
 qZvTcfzI
 wXUESUmoyA/zzQ5lJhpD+ciL4wYPDI364mr+juPwbOTM4JnaIWNTCnt/xTpS1Zt7i8n0o8FPZQ02YY6skzKVa5CIvTa1T0t6OC2Ev+2hbDGq8VEjZ05MW7CZ/Fv8bibKcxpm/vxnwYKykJNI0/ASa13UZ88PeiaAXBzbmxsR1FDYRhZGFA/nIElouG8pr6B1HmLs89+Lq6fROW1LUMmd9NF7Sb9fex7X7FAVi8OIrQ9wko9zXOGto0ullDkNCeZv0nIcSxLPjomTPATaTCHEiRwmDA/egX25RWjJGQRyMgIqOS6myvZ7nPU2zkEyTRSwjVoD/zqWW/aC6R190kmQTTTMwOQ0Z2wIo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in cachefiles with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/cachefiles/namei.c | 12 ++++++------
 fs/cachefiles/xattr.c |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index ace111f29c6fa006b69a0808764b60a0074db229..4fdf7687aacb8285ae38d9b5d7e5129897b3ca03 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -147,7 +147,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 		}
 		ASSERT(d_backing_inode(subdir));
 
-		_debug("mkdir -> %pd{ino=%" PRIino "u}",
+		_debug("mkdir -> %pd{ino=%llu}",
 		       subdir, d_backing_inode(subdir)->i_ino);
 		if (_is_new)
 			*_is_new = true;
@@ -158,7 +158,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 	end_creating_keep(subdir);
 
 	if (!__cachefiles_mark_inode_in_use(NULL, d_inode(subdir))) {
-		pr_notice("cachefiles: Inode already in use: %pd (B=%" PRIino "x)\n",
+		pr_notice("cachefiles: Inode already in use: %pd (B=%llx)\n",
 			  subdir, d_inode(subdir)->i_ino);
 		goto mark_error;
 	}
@@ -183,7 +183,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 	    !d_backing_inode(subdir)->i_op->unlink)
 		goto check_error;
 
-	_leave(" = [%" PRIino "u]", d_backing_inode(subdir)->i_ino);
+	_leave(" = [%llu]", d_backing_inode(subdir)->i_ino);
 	return subdir;
 
 check_error:
@@ -529,7 +529,7 @@ static bool cachefiles_create_file(struct cachefiles_object *object)
 
 	set_bit(FSCACHE_COOKIE_NEEDS_UPDATE, &object->cookie->flags);
 	set_bit(CACHEFILES_OBJECT_USING_TMPFILE, &object->flags);
-	_debug("create -> %pD{ino=%" PRIino "u}", file, file_inode(file)->i_ino);
+	_debug("create -> %pD{ino=%llu}", file, file_inode(file)->i_ino);
 	object->file = file;
 	return true;
 }
@@ -549,7 +549,7 @@ static bool cachefiles_open_file(struct cachefiles_object *object,
 	_enter("%pd", dentry);
 
 	if (!cachefiles_mark_inode_in_use(object, d_inode(dentry))) {
-		pr_notice("cachefiles: Inode already in use: %pd (B=%" PRIino "x)\n",
+		pr_notice("cachefiles: Inode already in use: %pd (B=%llx)\n",
 			  dentry, d_inode(dentry)->i_ino);
 		return false;
 	}
@@ -657,7 +657,7 @@ bool cachefiles_look_up_object(struct cachefiles_object *object)
 	if (!ret)
 		return false;
 
-	_leave(" = t [%" PRIino "u]", file_inode(object->file)->i_ino);
+	_leave(" = t [%llu]", file_inode(object->file)->i_ino);
 	return true;
 
 new_file:
diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 1cfeadc4f8f0b95ce861a2faf5b7b41b8156cf47..f8ae78b3f7b6d368526a86b454bf0febd1ccc509 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -179,7 +179,7 @@ int cachefiles_remove_object_xattr(struct cachefiles_cache *cache,
 			ret = 0;
 		else if (ret != -ENOMEM)
 			cachefiles_io_error(cache,
-					    "Can't remove xattr from %" PRIino "u"
+					    "Can't remove xattr from %llu"
 					    " (error %d)",
 					    d_backing_inode(dentry)->i_ino, -ret);
 	}

-- 
2.53.0


