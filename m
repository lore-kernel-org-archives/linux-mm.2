Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BC8FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782196B010F; Thu, 26 Feb 2026 11:02:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73FA96B0112; Thu, 26 Feb 2026 11:02:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC3B6B010F; Thu, 26 Feb 2026 11:02:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 442DC6B010F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:02:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D12248AF46
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:02:49 +0000 (UTC)
X-FDA: 84487076058.21.085F493
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id DE31B40005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:02:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ji2YnR8m;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121768; a=rsa-sha256;
	cv=none;
	b=GPpWuR0uN1+IuWxwNWAi0EKTj/rZskq0PGoTtEKXWFTKwZdpza1yUrL7euetV7ti3SPLb6
	yTvPr4dDj/bsjCo3xun6PbUE12snBhktWmndlYV6N2oN+k6EnOMlkO/MEBAe1bSPatn82e
	XmDLaLmKWmG9fiNe6rWleckjknoc+xw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ji2YnR8m;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrwfkT0dxFjw57jrdCKIMIyJAT9LmgJ4Zg9Pc/AqhAc=;
	b=CahlDXERWgL5zOBYAT+hyl1ofUiTfFSS642JzQd0AHImookyGP6b1t75S9ZjQqrJaNanW6
	UFrtWFiL8U4SvK9y/Bf6fs5cP1KlPK+nwAuNHlhQg5bBMeHrBk+tUbqhG68GB8KYfDmv0k
	0uFXPlInr1dIAcfHW6CIAWF4YXuLqwI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E9670406A9;
	Thu, 26 Feb 2026 16:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662A7C2BCB6;
	Thu, 26 Feb 2026 16:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121766;
	bh=fIoK69cdEWEBP2I83U9z6r8DTMmEfNeiFVnV/oaeX78=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Ji2YnR8mQ5wad/oF0jPuW9nL/OPwCpL6+zKMmv0H19n9XnotdFO3o3e3rUCEDhb9Z
	 1WF/KkwzM64ExlHBH0B69S4s2meMjQx9vWjoA/AkZ80bU81SsuAlI2fXJwJraJ238b
	 zH7VVtRkcRXHsnWSJaF5568UCrPS7PThaFg9NlqqN+urXCQoEZRdyaUzrdrxBCUO2E
	 7I82X6Y5bVSyvS9s81e5aPbOZ1Dp3A7Hecs7W8mEzGL4plcq6VYIkCD9jx4XfbbS7i
	 sO8wk3aypDF8Sqbh28vP5BmlyYB77S1ZnMG8ghlFhEhkRk5jxxg9jMGGDMylpiV/ff
	 015uIipzZyWwA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:33 -0500
Subject: [PATCH 31/61] ext2: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-31-ccceff366db9@kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
In-Reply-To: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
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
 Martin Schiller <ms@dev.tdt.de>
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
 linux-x25@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7381; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=fIoK69cdEWEBP2I83U9z6r8DTMmEfNeiFVnV/oaeX78=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0MrWn95OY2IvrlnUkZNzB5OKGldbHxaeOhx
 6fnNYyqTCaJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDAAKCRAADmhBGVaC
 FTUQD/48IgCmYwuVS4Syo6OsAn79pnl/D+n76rrtbnabt+Gej6so4CnUg14EOIdtAOICigP2EiV
 LrN/eA1QXBz+cgGpZ+Bp+uYstZEXVE4wj85CNn3345fs/O8Twwy59xmFxPLabFN+2rhMKDFRUVB
 qZHd1/KAm3NDhhTnrF12i7q6W6qeY6ACZvT5gYalYp289/OgmM50p12JHBIxViZOGjK9yW9ZJ5k
 6C8j82F0K6aqnKKDaAlwZ5G4swXcYaRLDSCKLfeErd/1ggu8jObCi+H25F6gwuAsQD2TEC+bRgP
 +xT3s+NtSrG3Cf0Q/Kim3XDDQc7abwcwqij61zu07WrcrGMBJCsaUvJqb73ZKWekCHuuEurPyC2
 A60TdWIk2ox9QpZhNSdCY7UyXhyPqdBCpKB3TAPA7g8osE4Siu/sPGrhS6yaxcl72XJu6kFBODo
 y2D23z9768RuMBc07LSCgxsuYStiKlUuplXWVStRZ1nQqm5i9ktn7YPXuFtmTY4HqnsfVMaDgjY
 G3ZTx5towv6Y6QxYKbTVv3Eu/VDTdtWWHhf+o4H1YT4TtWRumFVxwiGrd712o3hs/2ccYsV2sJm
 qbvTzz3JyAjyloZygBQkSVIGL8QK+PeRmEtzUJ/e1SzB51SUxA85NK9dyRNGtX+eOX/PCgt7gVU
 oQbY/jqG9WlxSQg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: DE31B40005
X-Stat-Signature: mc17ktxtxx8zhnw4sqk7ywwcojftdr53
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772121767-228365
X-HE-Meta: U2FsdGVkX18d/+7WHvcxNsYNtr2JlXcAM/25FrZmScEQoKIwsWTKre8mQi6t+XkxWIYJ8Lv0CgUcUkVW8TUHeSCqqjJfjY/LuAH20WMPP2tu+DrxhxJH1zMf/UKCR3+ssLadzELJfFYtPS84h6hfoRzbXmsQQc6EhSL+qLpHmBiTllkqNGYfjKEhIeZNWUdMCWVAIi8hmgfrvAJEOB0g+YP3fXwju3+zfBoXvzJzup4ygomQZ8aj9rWi8L1NXl4to7mHQwftueZEz7jqTm47VUEgtmOpvu0i/hOvr/Ax/J5d+R7uhtT0g4APN3VYHe7eVYNQf2okcvsJcXhX9TzPiNMUuVoQeepnnvDop/JcUsxexqpIC4vUOdCLNJzmkrpiDQ9LCto8z6aTIkCIqhuR4b7ckZ3Dld2znSRv9HjpzK8LMkfeZZTozY+PNYFTNyp2j8XLKyjMJzMoodFWEanM149HaMxIQ1LF1e7lF4ZC1zn+RjakmAmfUwejMwTS2W05DHgjoCnAVD9KLW6upB+kTqA9GTnYQ8NlR6NEaAMCOSjLCn31xhZrtlds1v5eu/RKUEmDxgAB8V2BTvKd8mY4beGHViK7HGOR4ntCLcbmj/z8RsgJ1++a1/U0zeEE0AKMOpWadRuSBYWcf7H+uSXlM3jMzwYLQcpR7VlhhQjliPfYHuJ6zIJX7UceBi64xpWrtS0lwrlv6EyfQ58GUb1viBF5C2YB2vEXppT6SJQCc3xK1vIhfRhS4gP7rrkgfeeWYz4qyEbIUBA7Uu0OUNWuTU/ag7WDoGO0H8aqibC83Uqea9yUDdROIzANHJloJpuZA4ucXo3Zk3EjLyBXE/TIpC7e41U6iKrT+5XmL/rbSlJxt6r/EYPdLdlRDKT3yU6sePUYT5hR62wqyXl/f6FmfVuucppvjVxbWkExUPljYcWX5BtO5PaLQ6w0kUdds9wSQH0+oxVe0yUJQj+vJY5
 SK8py5f0
 HT0oJ/1zregiquGpiEH/cQUs2oITE08KajN5jAbKFsZDBzuT1gg7CAU+Btpxw3Ekf7wwITPLE+A2VuwkaBlqvu1wbfnI3Vp2637GKuHUdeCEtGZhvZ//zxF1YXfvsCVhlAOwV4Bg6FjSeoXrT1cFPgkWA6FgjHZ0sS4JC1eKXWUQgl3YXlvZqRZjbDR8IfT6cjhN7h/rl+YKkDsIkwPEV8JPip30BfN/AFC1V5BV3YDP9FagL3hfTKlMRsBOYOHY3znQUuypBIIWhciJY6TL7rw4rGARi3NqXEOPXqOT7rzyPzvBjaBFLXAaYARyDy8ywBqZdIpMedTdFlesnSxYc7ZXaX6FIMEjPm/sUkrq7ZRJwEjZ/MBpz5gzdEp299PyvJlvBqXc5sg7nmPRiCqwfDmUfpCokSB0MhIJe9+AASTJIPHWkgxuygySYUs0Hf17y/37fdXXxkobtjI8oX2iPkGCexrIGwis18HlPEtX0tKiFqwFFhuYGRqWimBKOUg1TI+vclCGDjjX/cOR4v4HkwZYU66RCkDOKcpWjYKspLPt/M1wmftn8lWFk8DKiE98GCsxspDj5H4Df44D958HDAKk0uYCvOx/fggSTQPrULrmrmM2/u982QSLNPhRnGOx2AKSQuxBWCo5a6QLOrswqM6Aq/IAgHjpPT017YeMu7Tn1FOn040eO0a5c3Ue/G5IATea/xi2fwYZP6hXnbvLmbbihI1fn+BZu29xdL/uvzr8qeY/2Z1fJ0kUQKjVzKmXeEImb1dJmL80IgK594rWtpnPWnpq5GRKOQRfS1K+/kaiyFMdTzSmFRMUF+XEXhQnTD5qXzh1HBMfj0KKwBwDVdGXm51S1npTRlLdKvT8BIVH4BPqekEKFYv6LcMgkrcpw3vs5yo24dHKoXQr6uwA2Bua3gNPUKSgsiNfBTeLi+5mMdFyNeF+p1kZizJtRlMBKARip6yqv5Jhpj+X1EAAOW3vKzIHh
 d/hhmVb/
 68maG1TeXtTrs8+WAZRnXD8ZoIWqEsd2sVr82gKhSbRY3jg1AZM8Y9hYxsY8uIc7pYoJp7LhKXteBORLe1L81UlWkcbGw1MfsePK42rr/bAXS662mpWDrJkkpTeIcXo0aFyUiDUB5eEePv8uapt5Rzedid7VLldErsZzJRBqxsERWeqU3Gi4P5WVwW4PaRtx3bxl0xJMbd7rvSZzm9ilImAnowRBSqXI5PhhGqkHNqcPS/peoMOPNUdgdNNflMqGyHYsfVsFxV+paVoj1tEBPMR7Pc3tX65fpttaGFW0i/Dqd7txul/73Ay+yFmXEP6IYBJAEW1+8EBB6N6p+MRZLSJdTjddUSUtk5k7rH75hwWehV9SrzLD97Y9eCSE3xpdomVKkB40roWJ3ZU8ylU6h7vMYLXLaJQyZCivMuH+2APheRh3Kz7BlHQAt4AYE7QLWgk960PrIyUOs5dP8Wa1PefDK/ur4FrNtLwlz5MSv1tQqNp+mm4xByl+jGpuYnRjLYILpu/mBhkf5abeOhqO5wZTsm4mc2DTEv59YMb1lOyIDr4J+Z300xyaZWd7hSqLp6pcRXPr7bbs7bU3tOBlpaXtEY6EHjYma83jdT1c5KLW8jvyUDWAu9vtIORzPLEJQO+Uqoex0a5PuZvWZKkHpcp9d41bOoZBHODg7Sms1q55K2NF1W8XSn8AjB6t0UPN89iLof7bgPxgunvLNp+Pxg6tzP+RqvWW6iG8woLEPYSVl1YCv+HYXAx5hj4It+im9y5z7httKATfebifi3Pb0RD8Q2+0rm8LAs2/zeUbiVHFTiK7NfS4rNLqRPgrg5do9p6JwfM9+w86MHom20nB6DHl/w0cVUUJJD0aHg2XXhPCBN7INlNuuNrH+ekLeRJoANcmjTQ6sRVea3sV/4MdyV89bnyDBOpbnMD4hmV6LCvjxRjfUBi6qutZeoWA8u/ehb+NQIg1c0ZZdjKMJUiiTDMzmkI4j
 pX3RoZEj
 tx7xW9z6tkx8biWep6yO7gMXJc8PqzXZVA6EHbu6SYJ3z41F8O9NiNN6vK0/ZpuDRaMWGCvXctd5kOYi4+yNqj5iXJg0tK6nTpV93ZLYo5Q1xci651QvibY5FsT/ax+71BkPFXb9zZHrvdcYhfrBzgj70VECrB0Gvkqlmb+poCxapO9gvbh/Fl4HvWaqowGEvJGe59ESBUFj6a5Rvemn4BTlUdYARuOQ4ULuCz971XxYAxOp7v62KnLbfqR+LafLXiIu+j07U/P7xVk/9ReN/SkmwHe0pfHUP8BSEWV5BdfeNvOeJEcOw4TEVXEYBN6XmMUiFwUPv0bPyG8S0IWVwgedyviNzlhjyRkux/hfdV+yIzVbTbPeASvIl3dvM3Php0pqGTisuzCEaILOX/ZVuDPZSHqzeVitetCMKtjP51FrrrAQ+cc6e+SBVRNMXclL+APls+srMpPa+reTTHhPil8yVOx2fgShHTb90HMUaxM8mFe/OMlLrSPyYcWOJEstR16pAKn1R9ru2drDcpXYUEEdY0SpPDot7PazsJlQePRDYaoHKswUco3aulD1Ag9nwH9p7J3Z51iuIW62MQr2Tl7ZxCHMeSUvkVQi71FRGSGLl8dmfTqyhDXb5sK0BXhTVCVFBxGZ6PyzzZkfO67X0G8CUQun0B00FNNaDViPmZV6CE3ldGXzVse6LZ1OU4YekF8d1+TuDgYBM3OVHBbMX6BJPeZPQ4h8+fH+fDfeK6DTPSC0mlPY9yuC1JLG3ySsjAZdtsAKMu1IEXP/+FZJr92G2WxYENeePBV67V6SbQM4WyU510vcHhsSWHedVLlWs6qSqJ1ZNwoeopzVeFLg9Kyno/jeBRyQXEaixKV9tSDNQw8qYi6oQ8MrPLoGj12/Ypf1nLV49uRZYqd47V2bhglj1GM+9eTAntt4ZxcSeO7PoLdyksTefkQgKcD5NaiTz6Ioxcrx8/owPvzLchim1b37mYxzc
 GL8UNhc5
 fkN08PdzrAaE1GUVJjNH7Gtzndmlq9utry3W6ApxltDzHOWNEo2LlBNtBuOw/ZFT0LvKth01xvDFkmSYXnYMt54hWx8NcKhb6+imuZym5fSPFpEk7lXnrueDcjsk7oDQjjkazJzuuCbAPZ+ZGczvRXhTcDqSdAIukEtJ6BFcUEsmBH80dmu5ODmMxQSlUBZ/hFbyPIBzSjN6pKwCcPfoqIp3IPqeqSMNvKS6cm5lD4BlEeWOIPqXcq3Q+N9LIBgwPCNgHsQ9oPmBPCkMIcL8NUzWzWC15bABYMDFdylrtA8EUnjAv3nK69+0RiuzOtHCs/ID7BtEFVcD2UUe4VRH4Q35Zx5CxgbM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in ext2 for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ext2/dir.c    | 10 +++++-----
 fs/ext2/ialloc.c |  9 +++++----
 fs/ext2/inode.c  |  2 +-
 fs/ext2/xattr.c  | 14 +++++++-------
 4 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 395fc36c089b7bb6360a8326727bd5606c7e2476..278d4be8ecbe7790204b5ba985a7ce088fadb181 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -141,7 +141,7 @@ static bool ext2_check_folio(struct folio *folio, int quiet, char *kaddr)
 Ebadsize:
 	if (!quiet)
 		ext2_error(sb, __func__,
-			"size of directory #%lu is not a multiple "
+			"size of directory #%llu is not a multiple "
 			"of chunk size", dir->i_ino);
 	goto fail;
 Eshort:
@@ -160,7 +160,7 @@ static bool ext2_check_folio(struct folio *folio, int quiet, char *kaddr)
 	error = "inode out of bounds";
 bad_entry:
 	if (!quiet)
-		ext2_error(sb, __func__, "bad entry in directory #%lu: : %s - "
+		ext2_error(sb, __func__, "bad entry in directory #%llu: : %s - "
 			"offset=%llu, inode=%lu, rec_len=%d, name_len=%d",
 			dir->i_ino, error, folio_pos(folio) + offs,
 			(unsigned long) le32_to_cpu(p->inode),
@@ -170,7 +170,7 @@ static bool ext2_check_folio(struct folio *folio, int quiet, char *kaddr)
 	if (!quiet) {
 		p = (ext2_dirent *)(kaddr + offs);
 		ext2_error(sb, "ext2_check_folio",
-			"entry in directory #%lu spans the page boundary"
+			"entry in directory #%llu spans the page boundary"
 			"offset=%llu, inode=%lu",
 			dir->i_ino, folio_pos(folio) + offs,
 			(unsigned long) le32_to_cpu(p->inode));
@@ -281,7 +281,7 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
 
 		if (IS_ERR(kaddr)) {
 			ext2_error(sb, __func__,
-				   "bad page in #%lu",
+				   "bad page in #%llu",
 				   inode->i_ino);
 			ctx->pos += PAGE_SIZE - offset;
 			return PTR_ERR(kaddr);
@@ -383,7 +383,7 @@ struct ext2_dir_entry_2 *ext2_find_entry (struct inode *dir,
 		/* next folio is past the blocks we've got */
 		if (unlikely(n > (dir->i_blocks >> (PAGE_SHIFT - 9)))) {
 			ext2_error(dir->i_sb, __func__,
-				"dir %lu size %lld exceeds block count %llu",
+				"dir %llu size %lld exceeds block count %llu",
 				dir->i_ino, dir->i_size,
 				(unsigned long long)dir->i_blocks);
 			goto out;
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index fdf63e9c6e7caa6d5267c25faa6c293622f00627..bf21b57cf98cd5f90e1177454a8fd5cca482c2f8 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -169,9 +169,10 @@ static void ext2_preread_inode(struct inode *inode)
 	unsigned long block_group;
 	unsigned long offset;
 	unsigned long block;
+	unsigned int ino = inode->i_ino;
 	struct ext2_group_desc * gdp;
 
-	block_group = (inode->i_ino - 1) / EXT2_INODES_PER_GROUP(inode->i_sb);
+	block_group = (ino - 1) / EXT2_INODES_PER_GROUP(inode->i_sb);
 	gdp = ext2_get_group_desc(inode->i_sb, block_group, NULL);
 	if (gdp == NULL)
 		return;
@@ -179,7 +180,7 @@ static void ext2_preread_inode(struct inode *inode)
 	/*
 	 * Figure out the offset within the block group inode table
 	 */
-	offset = ((inode->i_ino - 1) % EXT2_INODES_PER_GROUP(inode->i_sb)) *
+	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(inode->i_sb)) *
 				EXT2_INODE_SIZE(inode->i_sb);
 	block = le32_to_cpu(gdp->bg_inode_table) +
 				(offset >> EXT2_BLOCK_SIZE_BITS(inode->i_sb));
@@ -381,7 +382,7 @@ static int find_group_other(struct super_block *sb, struct inode *parent)
 	 *
 	 * So add our directory's i_ino into the starting point for the hash.
 	 */
-	group = (group + parent->i_ino) % ngroups;
+	group = (group + (unsigned int)parent->i_ino) % ngroups;
 
 	/*
 	 * Use a quadratic hash to find a group with a free inode and some
@@ -589,7 +590,7 @@ struct inode *ext2_new_inode(struct inode *dir, umode_t mode,
 		goto fail_free_drop;
 
 	mark_inode_dirty(inode);
-	ext2_debug("allocating inode %lu\n", inode->i_ino);
+	ext2_debug("allocating inode %llu\n", inode->i_ino);
 	ext2_preread_inode(inode);
 	return inode;
 
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index dbfe9098a1245d97ba97cff24395754197043c33..819fa81901b79e0ef4e01e428445bd8d8cc01e68 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1152,7 +1152,7 @@ static void ext2_free_branches(struct inode *inode, __le32 *p, __le32 *q, int de
 			 */ 
 			if (!bh) {
 				ext2_error(inode->i_sb, "ext2_free_branches",
-					"Read failure, inode=%ld, block=%ld",
+					"Read failure, inode=%lld, block=%ld",
 					inode->i_ino, nr);
 				continue;
 			}
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index c885dcc3bd0d180c4c3f0945ca23ed8ce569ef10..e7f87d1514458f14252702119e1c065a28ea3d73 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -227,7 +227,7 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
 	if (!ext2_xattr_header_valid(HDR(bh))) {
 bad_block:
 		ext2_error(inode->i_sb, "ext2_xattr_get",
-			"inode %ld: bad block %d", inode->i_ino,
+			"inode %llu: bad block %d", inode->i_ino,
 			EXT2_I(inode)->i_file_acl);
 		error = -EIO;
 		goto cleanup;
@@ -313,7 +313,7 @@ ext2_xattr_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	if (!ext2_xattr_header_valid(HDR(bh))) {
 bad_block:
 		ext2_error(inode->i_sb, "ext2_xattr_list",
-			"inode %ld: bad block %d", inode->i_ino,
+			"inode %llu: bad block %d", inode->i_ino,
 			EXT2_I(inode)->i_file_acl);
 		error = -EIO;
 		goto cleanup;
@@ -454,7 +454,7 @@ ext2_xattr_set(struct inode *inode, int name_index, const char *name,
 		if (!ext2_xattr_header_valid(header)) {
 bad_block:
 			ext2_error(sb, "ext2_xattr_set",
-				"inode %ld: bad block %d", inode->i_ino, 
+				"inode %llu: bad block %d", inode->i_ino,
 				   EXT2_I(inode)->i_file_acl);
 			error = -EIO;
 			goto cleanup;
@@ -833,7 +833,7 @@ ext2_xattr_delete_inode(struct inode *inode)
 
 	if (!ext2_data_block_valid(sbi, EXT2_I(inode)->i_file_acl, 1)) {
 		ext2_error(inode->i_sb, "ext2_xattr_delete_inode",
-			"inode %ld: xattr block %d is out of data blocks range",
+			"inode %lld: xattr block %d is out of data blocks range",
 			inode->i_ino, EXT2_I(inode)->i_file_acl);
 		goto cleanup;
 	}
@@ -841,14 +841,14 @@ ext2_xattr_delete_inode(struct inode *inode)
 	bh = sb_bread(inode->i_sb, EXT2_I(inode)->i_file_acl);
 	if (!bh) {
 		ext2_error(inode->i_sb, "ext2_xattr_delete_inode",
-			"inode %ld: block %d read error", inode->i_ino,
+			"inode %llu: block %d read error", inode->i_ino,
 			EXT2_I(inode)->i_file_acl);
 		goto cleanup;
 	}
 	ea_bdebug(bh, "b_count=%d", atomic_read(&(bh->b_count)));
 	if (!ext2_xattr_header_valid(HDR(bh))) {
 		ext2_error(inode->i_sb, "ext2_xattr_delete_inode",
-			"inode %ld: bad block %d", inode->i_ino,
+			"inode %llu: bad block %d", inode->i_ino,
 			EXT2_I(inode)->i_file_acl);
 		goto cleanup;
 	}
@@ -952,7 +952,7 @@ ext2_xattr_cache_find(struct inode *inode, struct ext2_xattr_header *header)
 		bh = sb_bread(inode->i_sb, ce->e_value);
 		if (!bh) {
 			ext2_error(inode->i_sb, "ext2_xattr_cache_find",
-				"inode %ld: block %ld read error",
+				"inode %lld: block %ld read error",
 				inode->i_ino, (unsigned long) ce->e_value);
 		} else {
 			lock_buffer(bh);

-- 
2.53.0


