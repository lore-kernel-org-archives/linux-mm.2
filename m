Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A36CEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106C16B015D; Mon,  2 Mar 2026 15:50:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083066B015F; Mon,  2 Mar 2026 15:50:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7CF16B0160; Mon,  2 Mar 2026 15:50:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D79616B015D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:50:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A94A6C185C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:50:42 +0000 (UTC)
X-FDA: 84502316724.26.8423C12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E487F1C0011
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:50:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P1h1fEKe;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gOogMmlqO5KnCMrnc7mgiYO0AiIEeBH0jPgNNxah9n0=;
	b=X619s/4rmmungwf3JZveBP1p8Mr417B7T3Bl5j6l5OjR/49bGw3gvWSE2hd+piuIN2/0sm
	LQ3KI4vcBqIfayx8eygilETjE8IEyefeYFnQyfXWHb/b4LGs8YVcIu7a90ciSieYcJiwjD
	kCOpWkS1ozl0t3BGbRtISh9T3OqNwxQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P1h1fEKe;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484641; a=rsa-sha256;
	cv=none;
	b=CbSK0X1XD3wjFQXfelJXaSqpZtfkXmQ86HyTe9Ct2yj1NVTvnMBZ23+42iGEoRodVrkw9N
	jgSEqxW+a1tCpL2WI/BO5kMPzNDEjcf0qWdVNFtC0FFz7ngTduYrt8MR1Kd1A2SWZjHXSm
	5AZjqT5hsBuYLNpJxaQhQOZ4JqtYSyc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1C0040634;
	Mon,  2 Mar 2026 20:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D49C2BC87;
	Mon,  2 Mar 2026 20:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484639;
	bh=cLgIu+r8isiqKa8h6mhOgoB9Fvp0x6cK/inF2LepjEg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P1h1fEKemmxMNI5khnWmEMlcoMkgB+/ndcq26a36WpYNnj5HqMAU6dhjx53UqCAeA
	 lP9YqLzJ9qmLhhlG/FOnaB4UY0KoRnJNC5Vf5fXCQWMRyqSBn3UmmHNuj6dtwi8Ae5
	 u5+awrlVxw+WcDM8SGld99KFh9rdl4J9HmerK1eWhNrBYmVACE58jX3jIEQSectG4f
	 jIauczB9D5gEW5zzQDRaLDnkHcURB8shFhmSt86kCavUCnVKiyy9t75OhRCspCDTf4
	 dhI3sPDxX5ZI/v317crGVUmEkI7n6rxCPKqjLrkhDC5+WoRB9yK/u4f3E2o1CGG6PT
	 Fpr9AV83Kh5iA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:31 -0500
Subject: [PATCH v2 107/110] dma-buf: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-107-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=891; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=cLgIu+r8isiqKa8h6mhOgoB9Fvp0x6cK/inF2LepjEg=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfINS7AXFLAAzgn9fyK/X1PwsN/DtHFgvy+zR
 mmwTDJsS+2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyDQAKCRAADmhBGVaC
 FY7lD/9TWal1LPrcFaJ43Jqomy251Mc9Q643LlnCCv5/Rc/KRGLbH5fSwQWu7UofnrUqnUaEsC4
 hsXBL7UC5EOWJZOjMitjmjrtNm/jpQ845A3htLfW7scR+KxS3KMa/ArUc9eX+tIDXBjom9SMBLa
 zUFz7APNciQuk0y10edidKTFAkD01P1CrWiuK3bw6giGwc6Y5MjQLEC7nV3YW9uP0qVRB0B+9TP
 v0UY0BVa1jRp3IDbN4TlixCeYS3NFDPihTp6PbASMqTK4AWSSl0mFuI6o6plhWwg9zyMHhc2d3d
 g/x4uYQfREiTtQ9DdfLEb6xy0KsNmvTvvjp7fsNJdH5qpSUQnvGAogY6LGqj3RKjFwVaqzurHIq
 pXH8xZNrQGo7YGVIIbf6Xi0hsoAafjsCWVejiHi0Ge4qEU+9wZtwMFbscsLp61ltLLeKA4rUv8j
 H6HpvtXsGRTh8KatLQS0tEw8mglMgS2gj7ISyCmRJN3j88kCNFDbSklxD9lXeJJV9tgA0sfqfVJ
 P5sWGjParT12dxe1TCowgNPLFDIdhK9uKdQyNDqE0h6MdW2pB+t11ubrr52s4qmVUuV9KdT7UEz
 wlleqG/f03XMhsTl5Q9D7R6wZnV7ejo/JiutdLn9N2XdPS6wVG25Fe1wlBjQ/MFeRWDmEm7QVPN
 83qraK44XF/1e0g==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: E487F1C0011
X-Rspamd-Server: rspam07
X-Stat-Signature: 77rb1xhhnoxktq8yppheaayjjnttdptt
X-Rspam-User: 
X-HE-Tag: 1772484640-293419
X-HE-Meta: U2FsdGVkX1/SWGvrahIohTTIpj+Tw0dzdvvx5JCDuES642DMJfguo7QdmegF2gQvJg/VBzeuzbJIvsCs3Dftas9uLDJGZgYCAY+Xa1S1mdpRFStmKEXV0wzJIdz6FM2DEt8dmB0lecHcxQqwfKJPPbcQ5H0vTXDt3OIaGShY5IYxGlgFoJxnio7XQfrDnkUEs/ECOip76g3rQbXzknYjiqfirYwWnKAHV98TZMkciIrlQdo/sTVeWNkK4ZeeZIOGclqWX7d4oNWIXw+2vOkmaUvV3k5jH1KyXAsC2qmc8hziFs3vaUnyAr4jNAaOWX2n9p36J/jBhKMCRREh5Uk1fguMufgP3zTfTNPkbK1Wqz80bIk0AdjFXEAe4prNpGOknBoD3IrDf9Kd7glwyFehOxENijIcQkXC/fzqfoUOKDTWpdruDj/EBNquPaewAekz/SrCA2kimbVtBigJMAOaz1igGbooCtbe3JJ+i/c8+3fpSa83jg/ymtL7KI0yk2qfGWB5ubbEqq0Oj7NLtQIBKWHO51lL0AENmWXW5Oqdcw4qh4o+II77l98zCqP8ReIoOH/zpaHMBlwRqtcFdYoWB3D4nwMIq3/yWgmbFfGXBKJb+6m1u+CssRfv2wLMB2xPks2LgKyDe/0x96sDiPF2QfOlWAUariomfnJPoVQo8lOgPxfpJ2EyjsWxv3JhKzBGl/68cFch/0r+zFELCRPfR/F8kwOWp5ADEyzIyJGPwc/ryHNTccs9Sia/ysDr41Jl4jUk8rLEiYO0XnVOO/O3Ns+3AelZxMUPmU1Ad0Z8ZDnPsW3P47/HlvB/iaXcDNAQZzWhGhtthZwxC+Y8Ce3EHtifgoHf1dZHWxVEoqddvxCp35FkCll9RFzWMPu/nJRV3fF5ABCH/uCjtA2MVQRYX1DylVW5sqQd+CXXcO2QrsZnysxbKG/NO10VTvJbnVvbHTMggVKEKaYzTs8sU3z
 BEXhGzHx
 6wH+oE1ljJowSdIPJayHJ1b9mHrsBLB1EljBgLTtCP2a+b/yHQBDsdKm3NkT3ukDA9D1w6OywTBFkM3klxyBQUUf3gsAjbKF5x+eURwYcRpTfqayfa56P0OQMwyk23R5UZNmhZPD2hUzVFsUGTjv6pNgPc2nH9FO1wAjl32AmHtOwccv5QgdCZYyjWy7yyf5vhoWxUXrVxbcKT/ixzZb1zeBOCdVF1am1/GmkVTjrlwAN5jz3SSqKbdwJAVhW38IR/y0BnS7EYsjO8F61fLYvtoOh4uafRstQfo2YeP6H7tCr1T58ygeMpaMZmdwgcOjBkxZ2i6PuNVMHJNUS5/lZTyvdenrbvJknEg6Tv7nDFrcdz2WfvTm9+6qxBRjvwewxrMaZJVhsRy10AXgfODqUEPQrWess509h9uNoNhdsMbbr46P9xsvPV3cPhc5OGYx0/nT2l1uUdWxvI3EiYG+tpB3uW8inrnfFYGxRH0yofbg0e6LhkJZKY+/9UaJjFGyboh+WV1uSoCBmgSlpll0InZ3EG7qvPcTHvyR77rx/leMXs/iHbjZLSEF2xti8yX6wYGecuCCA/SWcVjSu+PP/g2KIvLGw8Q7rcDgsd78eNp6dxrEn+w742QywVV7eEH+2U9kEnKeaALoBny8lrUkjo9YLrrKStoLEKZ4TodB4wTRNCqNco2CdGq/2NqPKwUOSfw//+i3cNDMxQOqTwp3Xhj5Ij4KQr71+4L+sJ6zAAfuM2kbcgq6soIhdkWlEVHFYCu/Qg1tHcqVjpWp8ZuzKKVABpVRIvtvgQiSrCndskjbz83/t5NABw3+RQinhPlzPNd6zMbTSk2Y59ovAFNmY6Zp826rtS97bkTDcHVNvEy96sefhqpDB8/b8CbDW4KYhi3PEWuIXWRdEkud7CyGU1+Cj/MmBbm9UehLOmx3nw+u7spMczW/p168vug08Ehjpukp1cd9W76lyT308TCSqwMhV6bYh
 iSiXSFI3
 T0owOWDs1NtN7NbbQZ+uWAbC+mWM1aJm4zSEc/7EsUpqvmiT3EVdN4ST+c6caDSBtcyWPW7x4Sc1Hi63JYP2EI8xugurAhzPWAkEEBkJboM3ZvZguYBd0XLLnODB+3W//VMT1w5VUZWFFS2xc4jNyE/P37ZW4sXSuDRywO7R+tLmIl9ShCoC1QdPe6mjQ4ewYieemNhG3Af+Ut9gA+J7XAZD3ToiiQcy/xlA7RUVIMUEBlfSkVqmvfhhUrGSdix3riyUiTgGhQPUAcBx1kudTvkLi+9ToBzNoYsKdygsC4L8kSB/ex3v310bzfKBwun/DsroDk/OOw1mPdKRfotfvT12iy+3paeOJW82uGGT/ihLKu3YTO5hWdevOA9GTzl4toqjlXd/ce7vhz5R5KTssT8HwgKyVxwR7s7CCYlMKlVLqUTtrxJccDnILDRDOgX+kHOfUGKMjZnGtT+FpUZC3EEk0JHKlO9jCR4Gb8zjMy++wxo3kr9N7d5SSa7bvUPgYoL5H6NcNZCbpn7chGeVpdkxaGwuCP8z38a2uxrKLy0OBoL9qCZqKhNh80afqqiaCODm00je99cAbJglgwGoApnMIqC/OowSh2jhcz/pKk4cc2eV2FUcibRZzYA8bkKf5OdZPjKb2wQT0Kj043sErZGWiPmQhZnc/8dsKnF5CO/dgFBCHLtuouuQvNJpuyJnbZQ4cFKhjYwHcmiOWiw4rmrW06gsV8WVEwqvlFzZc13DBieZbE4H9RK4uXZj4fGAMX3xwF/eG0mlDXjcPTbrgy7QJ8XK+yutF2P50On/qpEA9ueej0T2wZIKEKFMKYfz7V4WCKYRpmrWNKfReTG5/y/fTj58hsfJgEaPZNdkH7M6tHOqcbrm5VorpHP9RDTrFgQMW+IK7ySnYM88uQ4IyUwu0m7aMylontRUq6fTvy8BaQH/70kl4g47JjIoJybBXpmqZDEJi4tPzb+08lmUTfxmvgouZ
 YPl1QpM6
 QRfil3DxguNf2QhF28LfEUq/++Q7GLB9wjQFFEUxa3OqUJ3fxJTpQRevzyXZzSInf1NCVYtiq4/fCmNnvL2lOosuzgs8ITx47H91+8fXm9eBae3jU5l31mLrpOyfQcZnKvb9fjyzAlxRVP/UGQ3UtAIL07K6/5uoacaCHUmvKbq6tkpAokSfjtiAOrL2UMVpwxBb1P49UAJgcATy8nJ8pF+njvYFJ6NRk/VuAy+GKNG6YO10cokyAmyrNPFAgWXrNdQArliilyl+UidtocCkHZcEwPdr85KXKhkb3kv/5Z3fbOSNJ5C/TGpEGvCauAzPGQeChX+AQLHfkZBdrB+B32DsGQY3QzG9ISdZ5uneg6PRZFFiLb7ExPPVxRXce/y6NsBMKaBCMc8dCmtlO8vYdNFKGD8V6D1He5kJbX7Bkzhz5K9GN19LwnHQTzqzblYkyOEVATRwh6uD2pX6dwCrn0WKKXZp7OPpqCzmFcXM5ulDRkSTMVhCua3y71JtZBsGmPx3QM74mO9Lq56UshRVdteDVPahefXWtp9e9sUE0p/GEKZ4K6brV0nqZHfBY/7tXQDknddw/WEVTzwjycm6tq8zBVOvuVH5EQKwNbBn2enMIZtpDrRpN88uJIFvdZoPld7New6osU7g9o1fYu2n7PJPDZzMqdOSVvgHqIjRXIeCts839nEjzR+7e75+g1usnHsHMLc9y7yqz5pk/lqS6uewxODTmknNDKjk4jFoJoo0+grD8Pbv3ROLG0oTrr0+txhWjzFhZih2EeLyze6FNU07GhlN6NO3XeABG07L9QebpT9eiw1zaWWKjHi+ykMXiURj5vLSP69Sw2qB/YWq1dKaX4EQ5S3hvS8mHFliWpa3+96kffLsB+auC/lYshpHNWoyouEFWqgsyC46YnMZAj7HKJOURzdEIZ7q0hj8Z3roy4kX2Z8qr0+N303VBOwHfM864zkjEcZs1wzd6XSRXzmRjJJO9
 cNNLOC0o
 uHXb65/z07tUBI3WZVRfsC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in dma-buf with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/dma-buf/dma-buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 46ae9c77e6045a7cac7c318c3afe41daf88c8dee..8c16c8c425cc84cf379d7f790d054e140471c8ac 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1708,7 +1708,7 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 
 
 		spin_lock(&buf_obj->name_lock);
-		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\t%08" PRIino "u\t%s\n",
+		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\t%08llu\t%s\n",
 				buf_obj->size,
 				buf_obj->file->f_flags, buf_obj->file->f_mode,
 				file_count(buf_obj->file),

-- 
2.53.0


