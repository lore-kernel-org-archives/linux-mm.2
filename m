Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ABECEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44B06B012C; Mon,  2 Mar 2026 15:44:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE836B012E; Mon,  2 Mar 2026 15:44:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F416B012F; Mon,  2 Mar 2026 15:44:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A53196B012C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:44:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7316EB8172
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:44:41 +0000 (UTC)
X-FDA: 84502301562.24.3D744A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9FA2340012
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:44:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AvovHTO0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FLS9pQKjRNO4e/1Uk0VLdGEztbbOI/NdMDatIoliDBg=;
	b=RsdoW4ey/qTvVQ3ntwsmqURSid/dvok4i7FdVToppy9DHH0GCU8MvTpungGDimQUtK5iqe
	iiGwvTapcIMzAZ97FKqIBxvyfqLm6pxDXZMK7GWT/dJBq1EtT3u3oX8h+3X0hqEc/Ujl/x
	FWr70lqOugICGhGdItU6/UncfEQzNCY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AvovHTO0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484279; a=rsa-sha256;
	cv=none;
	b=Ym9yinQi3ZrvDRSj/HezA1qDONQ1e+N5eVPxL8K3bkM+yKYuawd1WA6PUwXeQLR37D/ydK
	o0E/Rg4CcDL9/Fxj6viQbBhqjHjOREHtiEN1qcfnxTqFFQdksdnMXK2VRpYEI+L56mtNVb
	4LW0JLQxZQh91p3KIRf4GnJMZb2pQw8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B33C343585;
	Mon,  2 Mar 2026 20:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C6FC19423;
	Mon,  2 Mar 2026 20:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484278;
	bh=GpoXSAIQgn/BIYS+Nk/tCtiWihZ//MwJ8Zy+f0Lcga8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AvovHTO067lyD+ZjLSJpxY8Wfw6m9TS/lKDW0wYVJy3tppLbQMr8Ut2Werk5RAzh7
	 5KCcz3HhSNdectg1M7MN30RacrgFHJ8UIK6NS8T71v3uwCcpRW/GYiqX4b4hckooEf
	 fu4M8605uVLHr5jcw865Tso/y2e2Iyy1FA77WWGpp74pLjRpDTwfd5Z9HcBTnNehBW
	 M/7LNqlLha5XlqxCXpG1215wLFSBEqq8XiFeqoZpji3oBYvjuoyucMQKt2lSvIMgsl
	 zSw5iI8JrNs9fqMgeqHzBBgEaK0KLZ+BLOkM57mupMWF2U2/Qy8A2GWonfGOyzElBB
	 xSRHW5m4oMAvQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:06 -0500
Subject: [PATCH v2 082/110] ext2: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-82-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6275; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=GpoXSAIQgn/BIYS+Nk/tCtiWihZ//MwJ8Zy+f0Lcga8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIFeUYeRSPse4fCxGgNDYIK+l25DrEjdBbN4
 hMW8oJt+9eJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyBQAKCRAADmhBGVaC
 FbgtD/9SGi4ZCAigckE5c0j0w/wNI20Kmd/l9hEx1qxDeDfpdAF7/czQKFnBM80YvdtzNq8HIHT
 khCVNvYdgyxo45oTfevabzGB3sZlj94WJ96jQ7cfAH13fpM7LxdiQuIFbpilCWaog8iIzdMYbPe
 jJOL9b5e5O4J6AcC9M8BZLZhvegN+9cQ7ynZiq4wK2tyzTa/if4CM+2Jkg15OjZ54f+WPm+kr/V
 N1/jvzNuOncAgK+UOfVFAydqc3nZamV0MXvH3bABFfLxMyZSwb8sKhrEwMlEMWNYvJjXrpsF11+
 l2dEPYn8+l/sZL8zSa5Pr1PgOPe6+CMBXBR6GkjcVn/G/rbMVhapqpOV6TUCpG0eiVW/DqZv3nO
 dOy0FeQgJ1vgf9MuEPuqMZlDHrFBSDmXSmBaoyQfu3ffHRHg8sSjB5isPrsxeoDsYdPCvbKIB8A
 umvDGu8/OecEbapCjXPQkhWhOJdDrxlUNhDZ+ecWs4g/cNVcc6d9tRJlm0gr8NQ9e7ikHZVbk3Y
 tHynxNQ3AXXy4OvvcQ9knjlsFR4v2nZcYJ4f2IEZNtUwfAPHRFuZ0tl60/rIX1Nl5sd5m/dBUDK
 X7pd97Xzq79QQ2r0CqkX/GF8KMEnXj+eG5FMjm3KkGNi7q7irme8pm7/bfBXeRxujbnXuPQbkft
 Dcpv+qu8GeHoDGg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9FA2340012
X-Stat-Signature: p9ous8ni3qei6z5y5fs7ftpsdjn7netb
X-Rspam-User: 
X-HE-Tag: 1772484279-675934
X-HE-Meta: U2FsdGVkX18TxLLolVSQohzgmTXZ9nETQM/ibMGE1NK/DzwjOqOkdsdsuqpdw7Pkamx7inhjnDfu9NmMzCEE48gPkxC7IiS2ZiuF5fwHOFaTZv/yK0VyRode69gT3KHP66uR6ZPQ6PQJa6NEtlEAEUbk8+RJK2/Hq8Jb4rbTVqnHsn6er6VXCZLRv1ZaZly+SzrCE9E3LIFO4Vv8qygPWor8iLBC+QprXjO+bMV+FlaDieSw+JkoQkGdQgO2k7cJEyPAafeMskD6MJzA1M9Xd1Qz6sN+r3Vd4Q8EM65ZLLFnlLtQVZruDo2UeXq6u2E7d4ZrU69pNoyfH3zYmGN+NPhfMa+PJoEIyl/daZZu726VWmn6TnX7WwcKzl9uEUprCuW+p5eyOcoMkZnoNENxXSsPcHdmNnSVb0nMNh8OpzMWPIzEAsJPDLmZ0XCcyvs9OC+yL2kHCB0xi/525WOw87er8C2xbXl8kWoZ5wZ/OIM0ECvfV3qC3HY/jLJRSLHfn2VBzrzEBeRcSmUsYqf7YiBlFGc6xRr8IJYQRY6n54KtCHg4z52WPn28Fr9cwryZnbAr/nK7NR6z8h24nQ+eBfbUTU7Q41/IAS8q6AwIZCOyMbbb57++RYqDp/9FS72OHahbanCy3m37rvKNBNEE/wSeWDX2FEklwa+vdG3RK1I2yPh0lotq6/kJeWIGJfpALMVqZd3GMGtSnkJ5x5xxfECNi+VPKRoLbBgjFWxJPvsxXiORYMOVa1HScQSvI1l8RDORmw/l43wdSoOuOhnED4kvbcQeDcKmgxNWMNNsf5XFLplgB2fJrjVM/xHMjiVu1d7nuSMCkyWnYKXOoyQuQ3KPqjG5Bd/xeuCbugOajwNwNfENip0+TCkqg93DdImJX/DTRVtcqDC+92hZ+6Bl1qoozye4cj5sgJDdwqwtvMtCC5QfrVRKESGxXPGtTCcaXGUDvQQ18xkja0MyTip
 WBLnfXJQ
 hj+cux+X4EWn6DVmZ7f24ra/56WijCQEe6y2r6GlNxx0PKWBbmYBLG9CS1CaHXM5IFvj7Z6866CvrmI2L56+uzGzQhbdnX3TnJ0WNO1Dr310TE2Yq3FyYXTS/OTtUiIJcTzMgNQUkzeidqOLvXTMFMUyaURPi6OF1zNniB3jLKN8StBR6u+uO++K0aqG8INwbOV0F8iFMV4TGZ0JFsYqWpuIf0vmOsY7M0y2VxW9V9+J+w2/4piNnnlxEO2VEhSRV6On8PPCoSPBoFo0PxOmLxRaK/BpJqvgefMYD3QxaYpwE6xDL6b0TrUHWSvymaH2YC/mcRec59QHwY+EgyN0j57buuDD3YkJ67os9Qc8l921cVUY9xDToCI0hOlIyIEeFHPnngOjFim3ke4oOFP+WXoJYaL77S0cS31dGNl6+4XmgxczKRy1Gjty1o1Z/Q58DyB2yTdcMQfSRHfvrRfEz0+aT+vNniHRIrx/AbwJb7sTjppVk5wjv2dZP8K45Jf66Dd+NMiY+wwB77AfB0kEinR2iO0jyQGpCllBH0uvYBrlxbv4FHyKV5nR5rdhAYMG1kvZCoRPFYlCl5kl5cAjOzGTo/helbUn1OqO99Pp++emrOobVVOohBkIgrVhwedtuuSc5jp3kTQkS7YUySiHvhBPvupH26MjTdDqocCOlRwePcG5XfYoJj7oGwsp7TQVVhKp5HWqHhPBpcpIvALNGipWQpVm1ToyO8rtVKG+yl3f2aOO7OV/nFUn6bgmf9DHbtU9fdzcPXnHojyTP87ulI+I9zKVS7Rhvm1djeDCdSMaq85LvJV0jCwEsKz+Gr7IyxB9LmWOJwoRGAcUYBj3lCrZ6eYbaDFnBNHhddtNp1HN/EA3wczEOQWaKfv1AlEb6ZHLrU+W4GMcWal0RM0auXFFhwbqyeqr9YjdUR47+zAxECtKgc+c1dj7V9cSirpGdXDc90pzvjmElLYxHkn4Fo0kFPmsf
 5KPbRet2
 25ZhjcGHCPPZ3ZhinncjGEhwPhe0lb9lqES/xvvaCP3czVR+PG4ZgfWws4Lv+oacQeQdj7qHPusMHd+NgwmEwT70NNus+kKJAgfMTjbtSEmegTDsU46dCD8MKZHplwfiGxr1Qg8zpq64YbLU+FtIaF+VfDKTFvVw1T0RKDNPS6NPqu5Irx/v6+XRbV6RSpTodY/sKSAUIBOmrGDv8BqAB9fB3p2qWSeMNcVtgqW5r2zWqR8YgRQ/cYCuKBr59Myp2c+356IIVDUV/+xtGfn1tJnAg3R1JVlYEabj6fCEZXKIvxddWCb/YPkVmJnmnsLMX1LV/MZuPGhWsbAFHJVLw6zUiLdd3o/7G2malXs9qU2tvfP1/JZCbUpHMPi5Y3eg+3dIj/pFUSWwGRiEzTca8I75f1ry4r0MSQzh9mkCnX8o8MMs2ezqUEOivYMWNyVIZNccOWsQy4l52d1yE0yXpDdoZMNPMF1h3OAsFCrZ5uFY7R37v1udBat7BwPV9W9x4qQfCQgtgPWVvHg1rHK9myFKDJ2tCgUi66K/CRNg9q3LXlr64W44oTncHQZYuLsH7VUauqCPpxK00c7oarVIGu2Fm4Vegs+8Jr7psJEWKF2zX1pTfg9lAvdDtv/oYSOVRr30CNQ5gMdK2pdLybVvZxfw5ITDwaEq3u1K73rEgVH2au1ZiN/CahkJcgabfQJxIFAkBMx/p0KuRZG3sC5mWthx0iJYXj7gxOL4WiJUZB3NesffL35hW9esmMQuSy+b1pkvJtvRdoPNvaPBvJSLm7DajmL5D3156Q+boinANzxcXABcKH4qphj/1wpceUzBKQ82nJ8+gCl/XU074gJl3kAw3toHnrlIPJmdIivssxGHmiqdfj1Yrvj6mzyHakIY94hyEAxbxXR3wsWXdxKujL7CzpD4gY5Ae4sTTr3C0iWJpX+6egaMcWsHMO0RDbRQDYHDRCnZS1EWGhY5xZbIRXc6Q2Ve6
 jzpzT/Ny
 BLbBsisxtCXmXQYlhZkjMHzKfECO9Qdldk0EcxYswo+eT+hxC78z+uf0Pd7MOSSU2zauzsghD7mFEHJZmAehN9yq4JzMZrF9xE5JQN7oQYrkGgz85Evx3aFNhz99yoNokhvfLK6QSH5MrmeWJvGXTrT1AHxJGWmQklqV0mwSXH5jxVOy8PhwXu2Fy0VuXfI81vR4xz4vreFDfPos9quRX9VIKOQVklDHFuvKdwd6/EZzTshezn58lqQQTmnp0TvPwzc8KtDp48amdpFhza+sNsrzoKXogH/ftZ1mZHsq9bTMsV0l/rOGId4LdU3GUc5YLk0gWOld4rQ/knmwtpTT3xkc8VLFVZeuBHx1GbmTUyUeVLgNtQUN8FrlNB6+gcPzjhioDhSZC5q06ZGJRQlY29u0n8SWovviNvDZhiZvgupQzCYJMA2AO5jho2A5Y4aCxa6k37sKKe7wOO3hpN1uLnoTMikJv36o95m1mwTTYgR5eoLibTaZddpO90rz0+qPqCY3zJ3JdcSw8xPzZwPIymHsRdDPRr/EXWuj1yE8a7o62g5cNlpjMvVZahTw2/+HXu1ft63leE3PTqUj9WeCLMtX6uXe/c3mX2rq8oYyallKbAeyHGChPM13cWNTyFX4Bas0EEr1ej97AKkbZkhdutQwQwNIU8l60FrpEOQI0+AAJ87QtcZ9BL01l0TkSNwIgR9ruNtg1fcZfRAI34eLZosJdMG3Gx9jhxmgXcuSl75uLa+gcJ+ROs7Tiqfxs/uQp09fdqHGHx1COSB72LGqDFXOK+ySuxmDzaxHiEqDnM5cS/dFMP26hcBBLlY1qQYmVRg5MjPshRj3TTme/22d2GC7VnewltDzhf00BxRwxGri1/WO2CatjGekLGGWtI2rNvMTwaDAsFFgNwZfvs9QQHGVY5KaUPrKpq36kyZ2Hc1oZM+bE73KDApteq6Y40KyWWB4bBZ5WD+wJhXB2NeOecqnu3yWK
 J/5SKKOM
 hvXMQexltP3VZsiKHdyq1BHCyay6n561z5G3W69ADDNIghXdEhT4hH6f5mNqknwKMzyaopAGe9YVTmaOIpvk3xcQpatMmxSQuIbZMkOBSZ5pNyan5GlJBXzhycE7+OiwMZ2hugoFVl95ZD2UqKigwDRDKXbc5ZkFT+BbpiA+l1tTkUxnioIkszAyn27g39FQrMk2gQ8v3WTBWj+cFV+wNdQGffCH5MrKLs1TdRsgyIyBRDzjE7tjiU7WvUbYlf30k0auxdL1v2Nw/bhqmP3maM8X967TbznUFP0DY7mdqUVpVqrkNEPWflpUwsZhTaARlsX1x61ITOxCu5KpkwCU6dZn/02XCqulU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in ext2 with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ext2/dir.c    | 10 +++++-----
 fs/ext2/ialloc.c |  2 +-
 fs/ext2/inode.c  |  2 +-
 fs/ext2/xattr.c  | 14 +++++++-------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index f87106907da31bb7c1ca65c0ec2dcc0d47d27c62..278d4be8ecbe7790204b5ba985a7ce088fadb181 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -141,7 +141,7 @@ static bool ext2_check_folio(struct folio *folio, int quiet, char *kaddr)
 Ebadsize:
 	if (!quiet)
 		ext2_error(sb, __func__,
-			"size of directory #%" PRIino "u is not a multiple "
+			"size of directory #%llu is not a multiple "
 			"of chunk size", dir->i_ino);
 	goto fail;
 Eshort:
@@ -160,7 +160,7 @@ static bool ext2_check_folio(struct folio *folio, int quiet, char *kaddr)
 	error = "inode out of bounds";
 bad_entry:
 	if (!quiet)
-		ext2_error(sb, __func__, "bad entry in directory #%" PRIino "u: : %s - "
+		ext2_error(sb, __func__, "bad entry in directory #%llu: : %s - "
 			"offset=%llu, inode=%lu, rec_len=%d, name_len=%d",
 			dir->i_ino, error, folio_pos(folio) + offs,
 			(unsigned long) le32_to_cpu(p->inode),
@@ -170,7 +170,7 @@ static bool ext2_check_folio(struct folio *folio, int quiet, char *kaddr)
 	if (!quiet) {
 		p = (ext2_dirent *)(kaddr + offs);
 		ext2_error(sb, "ext2_check_folio",
-			"entry in directory #%" PRIino "u spans the page boundary"
+			"entry in directory #%llu spans the page boundary"
 			"offset=%llu, inode=%lu",
 			dir->i_ino, folio_pos(folio) + offs,
 			(unsigned long) le32_to_cpu(p->inode));
@@ -281,7 +281,7 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
 
 		if (IS_ERR(kaddr)) {
 			ext2_error(sb, __func__,
-				   "bad page in #%" PRIino "u",
+				   "bad page in #%llu",
 				   inode->i_ino);
 			ctx->pos += PAGE_SIZE - offset;
 			return PTR_ERR(kaddr);
@@ -383,7 +383,7 @@ struct ext2_dir_entry_2 *ext2_find_entry (struct inode *dir,
 		/* next folio is past the blocks we've got */
 		if (unlikely(n > (dir->i_blocks >> (PAGE_SHIFT - 9)))) {
 			ext2_error(dir->i_sb, __func__,
-				"dir %" PRIino "u size %lld exceeds block count %llu",
+				"dir %llu size %lld exceeds block count %llu",
 				dir->i_ino, dir->i_size,
 				(unsigned long long)dir->i_blocks);
 			goto out;
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 6a317411e54191578343308b5a3990aea9c36436..bf21b57cf98cd5f90e1177454a8fd5cca482c2f8 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -590,7 +590,7 @@ struct inode *ext2_new_inode(struct inode *dir, umode_t mode,
 		goto fail_free_drop;
 
 	mark_inode_dirty(inode);
-	ext2_debug("allocating inode %" PRIino "u\n", inode->i_ino);
+	ext2_debug("allocating inode %llu\n", inode->i_ino);
 	ext2_preread_inode(inode);
 	return inode;
 
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 0ca9148583646812b478f01fd35bcad11498f951..45286c0c3b6b8f86a1ecec0e2f545c5a678dd6ac 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1152,7 +1152,7 @@ static void ext2_free_branches(struct inode *inode, __le32 *p, __le32 *q, int de
 			 */ 
 			if (!bh) {
 				ext2_error(inode->i_sb, "ext2_free_branches",
-					"Read failure, inode=%" PRIino "u, block=%ld",
+					"Read failure, inode=%llu, block=%ld",
 					inode->i_ino, nr);
 				continue;
 			}
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 4b3dadc0a2a47c85682d9c74edb900cf0f20996f..14ada70db36a76d1436944a3622e5caf0b373b9e 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -227,7 +227,7 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
 	if (!ext2_xattr_header_valid(HDR(bh))) {
 bad_block:
 		ext2_error(inode->i_sb, "ext2_xattr_get",
-			"inode %" PRIino "u: bad block %d", inode->i_ino,
+			"inode %llu: bad block %d", inode->i_ino,
 			EXT2_I(inode)->i_file_acl);
 		error = -EIO;
 		goto cleanup;
@@ -313,7 +313,7 @@ ext2_xattr_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	if (!ext2_xattr_header_valid(HDR(bh))) {
 bad_block:
 		ext2_error(inode->i_sb, "ext2_xattr_list",
-			"inode %" PRIino "u: bad block %d", inode->i_ino,
+			"inode %llu: bad block %d", inode->i_ino,
 			EXT2_I(inode)->i_file_acl);
 		error = -EIO;
 		goto cleanup;
@@ -454,7 +454,7 @@ ext2_xattr_set(struct inode *inode, int name_index, const char *name,
 		if (!ext2_xattr_header_valid(header)) {
 bad_block:
 			ext2_error(sb, "ext2_xattr_set",
-				"inode %" PRIino "u: bad block %d", inode->i_ino,
+				"inode %llu: bad block %d", inode->i_ino,
 				   EXT2_I(inode)->i_file_acl);
 			error = -EIO;
 			goto cleanup;
@@ -833,7 +833,7 @@ ext2_xattr_delete_inode(struct inode *inode)
 
 	if (!ext2_data_block_valid(sbi, EXT2_I(inode)->i_file_acl, 1)) {
 		ext2_error(inode->i_sb, "ext2_xattr_delete_inode",
-			"inode %" PRIino "u: xattr block %d is out of data blocks range",
+			"inode %llu: xattr block %d is out of data blocks range",
 			inode->i_ino, EXT2_I(inode)->i_file_acl);
 		goto cleanup;
 	}
@@ -841,14 +841,14 @@ ext2_xattr_delete_inode(struct inode *inode)
 	bh = sb_bread(inode->i_sb, EXT2_I(inode)->i_file_acl);
 	if (!bh) {
 		ext2_error(inode->i_sb, "ext2_xattr_delete_inode",
-			"inode %" PRIino "u: block %d read error", inode->i_ino,
+			"inode %llu: block %d read error", inode->i_ino,
 			EXT2_I(inode)->i_file_acl);
 		goto cleanup;
 	}
 	ea_bdebug(bh, "b_count=%d", atomic_read(&(bh->b_count)));
 	if (!ext2_xattr_header_valid(HDR(bh))) {
 		ext2_error(inode->i_sb, "ext2_xattr_delete_inode",
-			"inode %" PRIino "u: bad block %d", inode->i_ino,
+			"inode %llu: bad block %d", inode->i_ino,
 			EXT2_I(inode)->i_file_acl);
 		goto cleanup;
 	}
@@ -952,7 +952,7 @@ ext2_xattr_cache_find(struct inode *inode, struct ext2_xattr_header *header)
 		bh = sb_bread(inode->i_sb, ce->e_value);
 		if (!bh) {
 			ext2_error(inode->i_sb, "ext2_xattr_cache_find",
-				"inode %" PRIino "u: block %ld read error",
+				"inode %llu: block %ld read error",
 				inode->i_ino, (unsigned long) ce->e_value);
 		} else {
 			lock_buffer(bh);

-- 
2.53.0


