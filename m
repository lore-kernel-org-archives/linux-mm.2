Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5492EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3536B00EF; Mon,  2 Mar 2026 15:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A026B00F1; Mon,  2 Mar 2026 15:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138596B00F2; Mon,  2 Mar 2026 15:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 023A76B00EF
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:37:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBCC21A01B9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:37:16 +0000 (UTC)
X-FDA: 84502282872.23.F8133B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D1AF4000C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:37:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HXw1mief;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBwJSLH1YL+vpW3V+2BI3WM9lUIoSyEn+ZXU4JnF5wQ=;
	b=n8XRd6wPVJNDmDRrkJkKrr1q6fsDuY2gICSPegkkolD8+nIhNLiAa5O4zvZJzy2bzWy824
	R1jJcRy/9fdgTf30e/W6PSq5btPm4n1gb1kyY/P791MqUBFZfVBPcRklksCjewQKn1/C+3
	HMrJH1vUSw1YoOCWuIDF7yCmrvPPwlE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HXw1mief;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483835; a=rsa-sha256;
	cv=none;
	b=oWJ/rWqwr/48peVMYvZJTD4hLuF9D6BkHdzHkacQ+7Q/3XyPmMcJMW4+DbOx7aCLRtsT47
	kod1jBhYPvZoRMhhiagG43JKQVPlyQwN6ZDr0YSaO8FC7V+QWDLGdl17RgtMeQEznnZsqk
	xmynYpOVvrQFNO9UpThoP6MxyJTucc0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F88F60127;
	Mon,  2 Mar 2026 20:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EFAC2BCB5;
	Mon,  2 Mar 2026 20:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483834;
	bh=UgVJPM8BqxMlT560fdqc1noj6F6UhsdCukOI8Wq5nIg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HXw1miefYXbtIR6JE39RM09xEPjBmSrYJnc3qKdbSp6N5ItcD+3dqGMszplv1N51y
	 FWyqgcWzhdjGCTvf4qERhS6VpTiXBI8l4n7NfS5KqzE84xU9lOB1OBDinG2QVBUc0U
	 6WHJFMrk5n2jcImnUlQrHHjr5Pfi+8D6j/0VttCKj7s4ZbjYP4yoVdh5s65pBnHnKU
	 eQEHEcm+TWFIcZLQPDS6f/az/q7e1/JvJU1wVI2zC2IkbPObkZWYj/YlqOkmiugZtE
	 Io2SG6evn1tZgNUCy/ziVq5GkMQ52nu/w/LQNuTBDxOYr6RT9Btat+MaRhpqETOL+f
	 gjSkv9mWpqP+g==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:35 -0500
Subject: [PATCH v2 051/110] fsnotify: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-51-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1485; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=UgVJPM8BqxMlT560fdqc1noj6F6UhsdCukOI8Wq5nIg=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH8DjQ61VuGHYqnx4y2RrHHfswITVgpEIRC2
 nyttXLIXcKJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx/AAKCRAADmhBGVaC
 FSp0EAC2mUe7VbzdzmXlDBKaHjpH8DkeAZ99MO7xXMFQrxi8LyQHDnksKIabJ1CMbWRV/7a+AcG
 JhcXJYEASNFrvvQlot+lJ1YU5aBLLnWRSDfbjx3I+nN8wIkqyKJlZcfaf6UJw7ynquQlQbO0q/1
 hCj4l4ff5JhTCvb4SGY85ttZDXzHn69Qo5KrvTTZxYtAyobrzpPZntiPtLl9Tf+GufsnYlSxss1
 wF1/NMmA1v8Orp6i1U8bP7B6eaWyLPpLg3NBtHMWGI1rl8HV0YGoj76ycIWtfNDtl9K4zcKwE0b
 eHeIQBn0KnUhRvigirZeqGAq2xj4LQykixIs2eWy6TK3U4ASfA5xNgeoU++63nkZ5gqpjB+CE5d
 Ut3/4LrcQSE4ZJlhvlPuetDghmdNKQ3zOgtxJPTe+Q1eITJMTliYd+0GuN6eCtPEkjGUOmo3R0F
 z20u/6T1nghDE37cI2psJQNUBlUOR5XPH5wqhA5cxuuDAe3Jd7ZmOOfLZefbivFHSm+A3pU07H/
 gKWVwXcZmY3tDJR126BbBscgE1xItR4sp9XIK8qY0AbIlUtahC4Ofs3+0E2Urzwm2pRgHvPcfAq
 HIqKoifPwSRSVoW5nkPIXYjrJGonxL2GGljvkLW7tnGX26B9t7VI2PyKvW47n31dx19lKsk4ze3
 D4V8Yn2yXUUmYmg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D1AF4000C
X-Stat-Signature: bna5pts9q8xdchdkenyad1siwn1dwsb3
X-Rspam-User: 
X-HE-Tag: 1772483834-104581
X-HE-Meta: U2FsdGVkX19vxLa/0wIkvEuJt+vxtCTt132W0Aqr8Yz91VO4WmYQjZK9Zf0WYGJiGaOoG6m7QxcoufCL57RHC556F8JZPGbA690FI2rWXyQJ8TsXQ2hqEO5LvEI8DWgEW9XtYWJTKGWeL9gAgOsG/2BTykgSFAunP1rUb6ehDA7idUR/N1Bfm8EtPt8il5zaGKNWBXgcEIh1P0kSLrTjIXJIKPx9D89wygmHJq+VRAQbnfSWpjqaOkp3eOpVnFwDnvNphRl+GRQo2pB/DSziwajVGEZNN0uU4WDo1BpCwiWNzdX4e/8TqFCEd8rRf/LpIJiNgGYpdAc8d+EXyUPojrXzK3KOMNpxgKTzGhWmSL/tORbXBP0sQuWpj+0tL1bh+bll3I2OAbO3zdSnkm7u+O6JW+czt0F43F4xiGOvAf+2kJGriKH+MGinz2gE1MBfYV44tmW4HvK8ckILE/I2l4GCpTImiNP/3kaHFzOH+xuM+LwfeqTIndFEgTJqvPQ6ybPbzOT9kNZZy5gS9/ov9sezNAqy9lKxd9skYUeJdJGKrcYrK3ecDganKrKCvhdi9hwe79LTUF07+beCyi3CUyFnOMm4EoindL0F23m7kxjQn/8677VpmMSfDr/eCst9OsainAIPQPzMPJGhbqkpYb/gTo+Fa49H29uL7E0RRvOP+ST4khVR9Kddz9bfljeCDpl0zPq9vr2TTbFkKkizsfqsR9vLT3LVVeYKKCeOCkBueUu4vvdk9p5OjYOCtwgAvse2ctH2O2mHbypjcigofUjuieiWbinmYP808lD5y2H4RVhjzeXGz0eliBVhSs0B3ZNP7L+crEVSAXHSZTudw4eCGJc9AfPYLhNIBJKwxCU05kRsRhunrGXkHF6zFxZ9NlXOPj7HPzGcV/nZUnS7m3GRaCi2xIPOxCN9iQH/PP58UDqR722tu07oNg6mGV5MYpIyu3P0uS1iz/5OiV7
 xVBJPhic
 2HI3wQ0d15WTjUWkpRYzcvTjw+WuGTz3912LyyPvJvH+qRHmHoOrY7W2HE1oAiYrpc/wMbaNPUYKlv4RkGRjCI4YfDNhD3Ce25vR6Jzlz9PFQwVzVWW9D41JA2gbGELfoX7D1AfMcqyecat18ijE9IpKnlz3t5WN9oIvw3uxZhT0mrYwdMATJrBPwSpefpQFjXuv3ahsO2OJ7vE2U21PzSWV2nc3nTyd/GNRsbsPdehXBlRekhDhdP8yZBjISMkS+a0WmCqy/bsVkuIWaE6iKVQelyg5mmGP0jeNevapOlu4LF6X2nVLdVT+qeWz00HwYL+NBu+tfsSPH0lxv9DFb5SFe17Vpkpfmi4TaZkd8CVKRaHPU4IMB9a446mC8cdeVB7qxdToQt6DoJYxFznwK5I9odCF8cITNH+Cm8JLsb1rKkQBa0t6WyCbAM0osgcijcdaXUMiGc2DdgyXd9AmZaUKwHBy8NQG9GIVzGMWSHzLzkp9GMNePOu9DuoClw+VYIw4iIS00rEu2Ovnnh0D9ISfkv0LFAO8l/U59qvCh9jv1ikfZWv5hxSG3uiNjITiZaxHzro83nieJ+NzOV6biyQz1znm42WiH19lcgdYQQ6VgOhS8NklafzmB4GZitEFsOCQrHqL3ZZ+PwrVuHLGdE083WDdEli7FEUdtMHgfUJ85EEZyYZWYPPNmNWlT4lebYYj2MukNPEFSrlAGTnGH+Zo8+hEiOPcYNXpE4SvfXnNV1uWNZuq/DyfwABYvjF+eE8fdu/YTLCQTwSN+0kcRetUehOTs/m9AHIVGxirh2mz7iXoVUfsQnCO22Xg72Y/uyqKu9P33MHcvXic0XtJfzAQOKBuAXA4Wru99kHJa3VzMCxfg0KzJIlqhhZ2Fyfdj1A1HJ9S1YUhzk8zv2e7csTCqu2EDX6MvOUSFC9/fLJGBjKJoHdo8uaR7BapZrrKzN23j+rF/YO+2fNqOW8+muUdeJFdE
 vHyxUNp+
 vuunzGiTDxzBIy5VdytYdjtXJ4KHHshTzuoDdlZicJ0ICgYx1lbXGSWdzWn3iucOKrEi7p3vsGpmDvlfk/55lx88hdhYklm8CEeh9oRfJYwMQ8aWYLyaANeSOBRXlYZANdGrkPzBlucs+v0mSm/w2aus4HxqkLOlRb1pRDazi8wupa6uLpSNbIvT/vZ4ycomkbjsZs9XPugVq7Jgp5ZMrjdv7PPjqoa7mDjbd6KtHxW8V8PAoakpQ+TCKQkslEFwcRb9q2+/RDrOt5I1qPexSHvnnP6AZGfJ6o0FEmk9IapHVcBMMNYG0yKdlwyP3rlC0gJE73LWso/YudEYFyE0gZiyjpppHmpNao8TabNlV40eR/lAzFT3Qg0MPVORkCg8q4UwEoXUy3tl3GxjQRco/4X4siWJwsssyLJZU8SyyUDEbaDxjP0KCAqkcIOAi6BycvWOc3bUwsk6f/gh+oiFCsaL3Krk7E6OnLW1jHrCbUKO4CQC4uOSjWfj++OqP4ATBoDkWdM5wqwKjsoPURMaegYnmbkUCc4gmY5dKd0VgUX08be6uxTKbH6X1+w28RfphkDb/5Cjgqgo5bDxOrhHzUwDrpKvyiyTEu9YmjfCnNxNTWap5FAzd8vtY++x+i6S3FI+s9hmcWr1XgvKn0GeZCN/rhkmMaXhtCJ/fFOtkpaelsoUXywaMUl53hQfZhKVQba1RPbry1dYj8W1a/LK/twFEisidBFMW0irsguISEe/xVQc8Rqf80z0XTOvMbzAXz0XgoDgwlvoqlXLJUVpvz8kB/UzF4m5T0wH9oUvvE51EVoNCAcSSnczgoIB65mPvD9kt/HsRIgiuDjh3B1T/PXLbDWTWQokCviYzVjdN90tuOBwQqZ+42FuNhhVDY66FTzETAaMunxiMyKRz4SM1d8rkRd9KqtnqPju4hen3h9SwhjnB+lMqtyqROF9K8FnmmhEw/pf+nWuLMxaDRCn9SUCjTZEj
 aj3P65Z4
 WBnle90snWmog5V2HBVMgE0U8igsWKrRC8ZXyCLnUiBcJ7vHEaJhZj5BoDUbyirTxzqsZ94T7Ximu8StvqeejB2c+zynr0UKphe89xbS5KDDXWnTBMG2QM7uJkwqzKBTAXhzb+DjYt0LUgQJ3m07y3wZawFM3m8yInOm216oKVlMEqikIKqIJvET1eI9eRo+ATu7YvPm9vuTUv388+u2F7seiWZwv/QYfybovEy2XjFlDfr9PEO4sy05k8K1Ebalc5YniQGe8TkJwg5UESBjeDrvicAoXuCDzyFa0CTAFFWQXJOsAXIqcakQid5+O59zr2AvknYkavYAJBzPagTXeq+NjYECnfA8YlhCU6LSBJ5MoNyY57V0Hm6EMeGjEBCT3bX969si05ig+jrTAA/cC5mmxQQaNdNaqycGhq+cJVXsjAYp1RlKGW43/vYLn0bogYs6S8W5eUJuJrmBgXXFK1HWFgp1F7bUotq97tq3YSUhmCJptoRtEAdPMzSvIMNfXstNevdnxthp5UIkcq3cQ03CJ/EtamCzxgNKCuIMwVLyDa/UzHIztp9AgKRG34Pvus5gOuIIl6af3y642Rucd84zZlHFX1dxQCiFV9SUKepBbnX45XwQuScBxwFD4yWSfgHfLhQWO15wSKO4eXW3HptJG/hK622zto1ks1IWDysVHZ/MO+xInoFJLhHsOE3bgKajxtCVt27SiFai8ZfgfRPnaxcAieZzShiYIEecLiBJ+D83mJ/5Tl3Gk/aSRcE0YTo3pGfLV9jsTXAoVWYoRmqKdw3WnERht9f7diXwkyhSWZWxh09T+USpW4GrXgxPkn/9iGa8v4kVnm1tDCH25PnPnpR0gVA+8bx0lxhx5OpvXsYKw6yNhssqRq8bTOvysaHhSoAq13487tCGdN2J8qt3Rd8KMKJC1P3b5CXMwU0+MjoOKy7CJVj4j0Swsj3/c2FfudCn+g/VbFf9dzxy1yLkj3vp5
 p4uxkRdC
 ZivSwFiXR0yO5+1tPk2tUEb4Zmh1VSu2RcC9xyEenME5axsqYpuAMkfa2Ym+dBA1I2R+beCxUHd9PgNy9QsaJEcIIkSwWOL84Whm61w9wAEKNHx7rf/8wmisKWnTuVV8hFWIoBLoVFmGq5T/jdQqzvVEXoNOtd6VE0jk0axEeCI7MvG0uyXL2lCmilsFwnJ0n92ybobB6BUx0fPxCGwqHDAwy/rKdLJlrfGnqM6GoFUmpOR9YRlQkuot5kusH0yabdPjwdrG/Oufyxr7o3o7CA6lH/FjloAX09PqouuA958/BTBZWKG/GQQgwf9m1LMDcDvg/9pDc7r3ZfotuKtFK1yThlMt4ozfEjubgpV7K5BUUQJr04EcQuKR5c61doLpu7b42v3scLpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert fsnotify i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/notify/fdinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 9cc7eb863643774b83da8b6228c38db16d0dbed1..586eaa7f65a4a61b892fb9c39e6a0d81e025b790 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -84,7 +84,7 @@ static void inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
 	inode = igrab(fsnotify_conn_inode(mark->connector));
 	if (inode) {
-		seq_printf(m, "inotify wd:%x ino:%lx sdev:%x mask:%x ignored_mask:0 ",
+		seq_printf(m, "inotify wd:%x ino:%" PRIino "x sdev:%x mask:%x ignored_mask:0 ",
 			   inode_mark->wd, inode->i_ino, inode->i_sb->s_dev,
 			   inotify_mark_user_mask(mark));
 		show_mark_fhandle(m, inode);
@@ -111,7 +111,7 @@ static void fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 		inode = igrab(fsnotify_conn_inode(mark->connector));
 		if (!inode)
 			return;
-		seq_printf(m, "fanotify ino:%lx sdev:%x mflags:%x mask:%x ignored_mask:%x ",
+		seq_printf(m, "fanotify ino:%" PRIino "x sdev:%x mflags:%x mask:%x ignored_mask:%x ",
 			   inode->i_ino, inode->i_sb->s_dev,
 			   mflags, mark->mask, mark->ignore_mask);
 		show_mark_fhandle(m, inode);

-- 
2.53.0


