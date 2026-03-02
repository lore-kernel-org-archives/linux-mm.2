Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3491DEB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1DD6B00FC; Mon,  2 Mar 2026 15:38:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975C46B00FD; Mon,  2 Mar 2026 15:38:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82DA06B00FE; Mon,  2 Mar 2026 15:38:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 701F86B00FC
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:38:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D9E2160349
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:38:57 +0000 (UTC)
X-FDA: 84502287114.11.2912D1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 93F9120008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:38:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cw6fYKRx;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAq58+KAK9+s0j9E9XgQ6Gq6nZuHLh7Fj3B5ZV9Ehvo=;
	b=H4bWTR1u8MEk2Q9r3jlFRKh6r67bwahX/LDxs/I8ASpfWf1ve9J9v6VdEpTrHvhYAIIZ91
	J3BKy4gU0OANmBbTxqZPckelTZwzONr6kourLj+YgG32Zh7ehq1BoetxSi8M5op4hoO67w
	QhtylZvtDMZyar+47mqzIacmHxVh7H0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cw6fYKRx;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483935; a=rsa-sha256;
	cv=none;
	b=fmtvDgu6WbMQv+Zc9wGsNDfoAxAQKzHfO+1MgVw1hHkpPyFuWLQrSf+yJLegALjPl8OD05
	CJxOkU1UfEoNVpaPlZBLlm9a1EZ0ijb3+41CAWAAOq6OHtEQw+UfIPLfIifUUbkKtkp4vG
	1sR3ZMqq4laR61ldEyco56bNMiCYnEM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8460C44238;
	Mon,  2 Mar 2026 20:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475B2C19425;
	Mon,  2 Mar 2026 20:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483934;
	bh=EkVY4OzCxoV1B6JjTU1CxpHxdOMuJb7GCMDpICOoKnM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cw6fYKRxkA/2qSg00XWLZ3vREeGKcKpXCr2z3otf7bkXJULLwvJXZFBTr8QeEXtnl
	 O3cBxE5aiqKSM1aXOiGIip6+rT4A0MrUQH9aqQU83yhz8xx/h9TGq8qEhmouP0c+Aj
	 /6PXUjtDxSwGSliUzbksOagSQR4xwcd/yRfOL2tsDICH2gl+uLTlfAbxk5gSrdPWHv
	 xw/4aJ3ejktiyiV+amJL/6JM1R2kuUkhC7Yjo7k09FiJfXJg5p5pScgxdBJr7BV8uO
	 5575ABTf8Qasm1xofy9cIyMwaj8Va59trON8+cvaXZLEJLXGYR/KR9qJUlavo5ClzX
	 fXp6LnsikOCag==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:42 -0500
Subject: [PATCH v2 058/110] net: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-58-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3590; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=EkVY4OzCxoV1B6JjTU1CxpHxdOMuJb7GCMDpICOoKnM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH+Mnc8nVtv6Lm/omX/kUloGe5xdlARw0dWD
 Dkf72ua1PiJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx/gAKCRAADmhBGVaC
 FV7ND/9cbF3xOXUXzNKgQSMwCY/Z6EDC24GChRkdNAAl2jLMVrNdA7SH+rUX8wS/Xb+ecl0XjLI
 HFbdQ8UNLvQUahhf1pRfQXjDDizfsBxDz0duLiApUFVBwsiAaoWrQYbIHfWhlzdAJepp/UtQJ/D
 GIQwokNyeDXWkaggAVnPkm2d3COjH83H2J8ccxPeLu9l9zDOBvWyDLkGlOjkscwb/iR7xJr2fXc
 0CEWI9jtoEP3GEivF0SjoIc5i2h3SQEBoAYj0t8+IcbpZ90X/s/MK2k+HwpUCjvSFSNbI5BV8Tg
 3Ouof1vHdnLHBn+12oiFIs1tadfwHNStEOM7OcrKXaXrJXXLUmXy74caMCsgJ2gnR7wgeRtE/Vk
 JwqHwo3E8d5x8cbXVL+202F3p5BdjJ2kOorBQTzRHYE5ivZlttgpSL4sgvE4Gm+JK2ID7EWPdh+
 pFWKqlh0cEgynItMvOkQ5UpsXIW4ApzelXba3f60fUeLkuqQnB+ub2aeVlMhM9ohXSul6YNT6v6
 xJt3BmT7UVPe3ytZX6eKnsmRaA32wHZD71biGWWoWDE/2JSKC0IHCVBEi2BWWvHErfhWEARE7uC
 cx+k76sD2N1X1CWyiiJjpWD04bpl8Jzg6bd+yv+OkmZkJk38rrUw8X5C0qzK+ZUYfxWKya/Ufq2
 ER0lcckWB4Db/Aw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 3fyx73he3tes1wkyfxp46w6kud1ob1u9
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 93F9120008
X-HE-Tag: 1772483935-821923
X-HE-Meta: U2FsdGVkX18TaBUpAIMrYk0XqNUIe/i4IHW8Mf6pN4KUEzVU2wnVjKnVtwg3Kj5fc2n73pASU+5zDCTlDUnW4lqtorD4Chv/Eh55DIvW9JvabMm4FsxuccY7Cpb6fgU0Tm/oEUWg3CYcFdEoMZP5oGYZoLrRHRPtpiiVYA9JELHqY3MCkZddfk5BRwTsVYW/gCVIkcqposYmIQgYcG/xW2jZCMFwmCaX7mxiyQA9kHRzneDDc3ijS26F0qXCXM0Vg9aJHpvUbehH2p5YWVB3m7rS+CKzd5CwQQeAnPbShGNQy2KyhReKA+aiWa8BySVgBfFi4VTKuZkUpNBBrcIlIoXVrvR1+wkUopQi0xxf95ndF6bGMl6AcOEhMmwaD2IyOTD9dAM9XDyXNEygqklCr/n++pWTnPPfbdTqRiFjXVUbgcYNd2h9ZLySa/PmRW/M3IHq8OboYmxRUHDyfzzgmYgXkbpI9jX0vqvzmI7rVudr1xVDt0RJQbOdgYyj0D3cdcSikFAoR1E3+9VC1Noo1WYiwFWtWLsXG/ETDxZt/KvzQjXsiSQYoaN2DqmiizunAkPzOJThDFngVHekdGCYcisXLehP4O029CXkFZkv1Act2HDy8YzvzTtqCzRGOfHffoaPQRt0SZbsuLMLY5qnBtCBslIpoVFGZ3Bfd1c3ZzpvmVcsEe2qBL5bW6Nt+OOOdbxKcRyTpuZg/1oegZUhlVSM+LMSNIQuUzZrXDFUTX7ZaFvaCaUTYN+RG+AL1UcM02BtDGVTI99aHBhuE+iwsU7s4bxbbqCyVQ8ATooT7MMI9iW+SyO/fHwrCcakNkypC37ideqpNKo8dtEDuDgi7+OioIQ/QOIia2wJuHChRtzprUbobXf7JfrTCQQw/ELOLK1UFuPzfk/d67tB3DYP+SNn0pDuW4AW6uP+2RuqcG56f045rJOErg79wjmeel52ho7+mIihA1AlnURQL5i
 k9JuwY/2
 xGUI84iPTZCkvNp8jVwI/t+yQnOVkeEFPITp12DdurXXXqTQLW1bg+LXGVmNwMnVRfOrUXOt1U1ogGGEnkDme9ByZWli7+SHR+BXu14yqV9/Jbm38Ks+sYJWfp0gj0VyrZF0cTmyKABxUyDCaQTSZh32ppSut2ngqz/4E+yP394NXRjB9+A/ym2IWEXWnP66YiZ6YkDYfk6h65D0aWuJSFLEx7WVE8QJASAtoCA4wUN4+tauwcAfQOcOpWBoOFFHWcGGxViR3yfHvQcvYXszD+zlyIoULzWz46GI2oFSttab1ha9TEPBDHIal6lE/v+2uvw8SfCir7Is23YkxUEc0FrCa4+IzCZGE7I8XVvbJ3HZ82zH06LWSKnA9Pteg8+9Tn5H+9NeHPObkOuezcrEsvVIHGn9JiOZV8UUh7ajdoS9gIS/v/V1vIaqTWRgFBI+QeJIkW3I0eXLFgFIpqlwklnNVGKrVJxuRTxloGqxiCOIgK9ezx+H89O7l4gUNvei1QFQAKzkcjgJc5ItQpBLwXIwkhrJrUI0vV+vd8bDu2d/xXvAJQN+4UgNh+V3pj95zQ12M2t9P8DgSe4jRBjOgDBawwNRnf8/X7UyLxmwj3Q8v5J8wYtc+B40WlRiz5wlsby+TcZkEcyiUQeKyaujMWO2YFBU94ycPdUxagV9ZEQYw8JHJMPJhpTeRheZ0PAdaUrrw2Wi9+F4z9W6n3NlHCJUJ9Ek6rxQ1gHZXwA4yNsP00wXatGOfqb92k22bgMA51hvnEAQGYrGZOUjjaWkAbDExNQEkkjuN7Giqa9JPGZFCgDM+2gUb9stYUHazvN1R9UndaqyUG5jky5+8MBVi/3rw8TSYgHrh5drr3tvoXfdNkCkCzD8hGAglcrjHHJzUQ4IjhmvokvzJKVVAXsv5U1hoPSsHit7io1sFx5L+WwrkwFwo2bkAlIiQAnO5L9TXBpD7T5QStRWOVll2w3luG3CZVu3B
 Sfu9ytI0
 NWW/46dCJ6AYG1qSGmlOK7DFOWZWW3XoPHXLDBxCIYefBcc8ZH3DLvI92/0ZvfdVbVWzI0HS7TAzbBftIb+4OJ2e48RvfAxQHYUtnKAU9Lda2ZV58IwF70UK6PcZN/0yLVB/zgnXfuzS9hIFtARL+KOoaf087QVJTtmxQxOj8wlp6jmiQNrlYJsWTMnSyBRfl6ch2D5TXTmCBQTad5cu2azHbEdd7APFufwcXFcTuNmAo0Lp+mhMF7PSqB7IbBuTco6/w2pO/ty0HU2y/zxTM4eTvMgNB36xNj/6doQx/3Id5iMXGEbp2jqI8Je5PSPIq9hnIXl7HJQNfKWT2MDbIbIJTvsZ2QZ49JQOZBcx8GgbIIU47S3qS9umdGVQPt7G02o/sqedi2XeW8DymtFUb+UoXAOdiHxXsxsyimXPTPFSGytPYIuyk6ELZR1qgxzWraSBFnaRMAQhlO7QLBsYjE5Yjz9FtD5qztRXZuTRfnHy4aHrtKr2200Sj8W77kMM6u5GtCj34ECl459od22v6Chg3vtUtODJSA50ed0W4t0BODWqPR4+GqBALg/O1jiz8q/pwCMdAysVXaFakyCJfBmugJecndnSitybZa1Qz+pYTU4ugbz6y6Yhk/eIHbGlJqYwf56edH7Ew8GdXx5rBLOHnHxDZ++oXqsGNzIPyiWnW1W3DSlyLWpHQ2bX7EBMgbku0Dg0mhUHLJIT0NOTuqjfQEowMxV/V/j7pe1Hke9BUjKNmTegTHu/mFGdu0PZNeCoV3UO7oHjHgWgoaxCHpiKlPM4vNjPNGggZvIuHd9xZTJbp9lhPY4G8eDzzJf8K9ccXNiamnGdvyyj/jKdwXJ68dRKh6VT97caUi9Zcmg023/NT3ucRrD6EtACB7VLJ37mNGmuBYs8+OaywCvZ4jGO2RZDtI/D+sJLHEECJGm4Pl+TwRC7CygBd5eHTVpHmc9bsqOBTKEn48Kf2bEBdaq0A/5Ic
 6DTD6wm+
 WFUv5Cf7+vqK68VuRura+KRIIOaQJbXlBx4FgeulW3QHyv4J422PJuAg89lG/Q0VNmHilX5TyCIrVy2vhWoyyfiUk5wQMoTWGZDSmnYbdXResi2gcQb3Bbj8lsqN4DTC1l5f/++ZJZ1q+PSJluD7+oiCIuKHNg4GzUmXBadLkqdejU4vp4nuBJt55crUIGw/KPVFR8nNBKKg6eiTbHoIXVtySkF3Qw8dh6/Dw2PgXpJ9SYYhnyOGdlcGtVR6FNXc7FkVDgffgXooq04p5lnyyLcWCCqwWvBa3JVeekly3aLvHiu49caVk2QJg1B6H1dMTS7H6PpxZ0eBXfI2BFG97ZiVOPvjSJ0jxXyiA3+84bkjp38KI/mNKkW4CWs1VebhqXwe/lIzd6dTvVrdn/4mn7hvggocsorIlDnU6mMfZQuYXajiwfXutm8xmiPuIDrdzM78YvtZ4HKurkKZzt0EOQAL7pA5fPuRwilFqvK94i0c3egBMWDDL/7n5mbT5o0WzK7JCMqbkWq+Vb8p2cUq+eo4xqNgpFyeBYnUpMTlAggekiJkXLN1zrDlW5XLxlsxFypAZoRGgMkvo9lDKVkfBSeoEE7qPh3Hl0CunGHouGCSq31V4MRpcxYB/SCnA4Bzik6FTgVabPz3iH5iILJr9JuSe9xrl7on6m520OsCzq3LL4kE1gbYUgGQvnfBhLiHWh0tkqNHqYXOIwaXmuxTXEu6xVRgiQkk/ZH/C+6hRATgOMX7Q+kUCub19AfPXeK6pIW6R2X94pfijxMQOtq5oLAkYOhDQ3nB1xXZq/dDwswcgP8qHomo5B1aIhSJjRTHotNNOMvI9n3MAyCfZiT9Owo20eeNi9EuHXloU/OJ4R2dB3h12KSidSPvAnvp4JmvJTgl5+i3++3JDMk7hvV67GS/mRhp6eYhF3JT4wLQxDt1ow6iEf69tH2v6w/eejraidMuVzqulV73C++/+TYD2bh59oJRS
 ozNYGEwN
 FeHG1K9GIhm3sqzcXYqr0Jcf8nY1Npl+u10WQCB1tge3OuGiXw3EHMSMOgyG7T3b4w4uTWkiU8Yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert i_ino format strings in x25, netrom, and rose /proc output to
use the PRIino format macro. Also correct the format specifiers from
signed (%ld) to unsigned, and change 0L fallback literals to (kino_t)0,
since inode numbers are unsigned. Update the local ino variable type
from unsigned long to kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/netrom/af_netrom.c | 4 ++--
 net/rose/af_rose.c     | 4 ++--
 net/x25/x25_proc.c     | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index b816c56124ab8b7e59689e612d36007bb11aacaa..883c8aa90235d746a688c5f38b812c20faa7c770 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1305,7 +1305,7 @@ static int nr_info_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "%-9s ", ax2asc(buf, &nr->user_addr));
 		seq_printf(seq, "%-9s ", ax2asc(buf, &nr->dest_addr));
 		seq_printf(seq,
-"%-9s %-3s  %02X/%02X %02X/%02X %2d %3d %3d %3d %3lu/%03lu %2lu/%02lu %3lu/%03lu %3lu/%03lu %2d/%02d %3d %5d %5d %ld\n",
+"%-9s %-3s  %02X/%02X %02X/%02X %2d %3d %3d %3d %3lu/%03lu %2lu/%02lu %3lu/%03lu %3lu/%03lu %2d/%02d %3d %5d %5d %" PRIino "u\n",
 			ax2asc(buf, &nr->source_addr),
 			devname,
 			nr->my_index,
@@ -1329,7 +1329,7 @@ static int nr_info_show(struct seq_file *seq, void *v)
 			nr->window,
 			sk_wmem_alloc_get(s),
 			sk_rmem_alloc_get(s),
-			s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : 0L);
+			s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : (kino_t)0);
 
 		bh_unlock_sock(s);
 	}
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 841d62481048def8d800779efb6e4ea8cbe419fe..ceef3e801030d4782b3d05374b6ef48a9d544b14 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1479,7 +1479,7 @@ static int rose_info_show(struct seq_file *seq, void *v)
 			callsign = ax2asc(buf, &rose->source_call);
 
 		seq_printf(seq,
-			   "%-10s %-9s %-5s %3.3X %05d  %d  %d  %d  %d %3lu %3lu %3lu %3lu %3lu %3lu/%03lu %5d %5d %ld\n",
+			   "%-10s %-9s %-5s %3.3X %05d  %d  %d  %d  %d %3lu %3lu %3lu %3lu %3lu %3lu/%03lu %5d %5d %" PRIino "u\n",
 			rose2asc(rsbuf, &rose->source_addr),
 			callsign,
 			devname,
@@ -1498,7 +1498,7 @@ static int rose_info_show(struct seq_file *seq, void *v)
 			rose->idle / (60 * HZ),
 			sk_wmem_alloc_get(s),
 			sk_rmem_alloc_get(s),
-			s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : 0L);
+			s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : (kino_t)0);
 	}
 
 	return 0;
diff --git a/net/x25/x25_proc.c b/net/x25/x25_proc.c
index 0412814a2295bba5e26f4c95697ef7b7ba5fb34f..196e1850e925e4034b2ac71df151b9b953fb2570 100644
--- a/net/x25/x25_proc.c
+++ b/net/x25/x25_proc.c
@@ -96,7 +96,7 @@ static int x25_seq_socket_show(struct seq_file *seq, void *v)
 		devname = x25->neighbour->dev->name;
 
 	seq_printf(seq, "%-10s %-10s %-5s %3.3X  %d  %d  %d  %d %3lu %3lu "
-			"%3lu %3lu %3lu %5d %5d %ld\n",
+			"%3lu %3lu %3lu %5d %5d %" PRIino "u\n",
 		   !x25->dest_addr.x25_addr[0] ? "*" : x25->dest_addr.x25_addr,
 		   !x25->source_addr.x25_addr[0] ? "*" : x25->source_addr.x25_addr,
 		   devname, x25->lci & 0x0FFF, x25->state, x25->vs, x25->vr,
@@ -104,7 +104,7 @@ static int x25_seq_socket_show(struct seq_file *seq, void *v)
 		   x25->t21 / HZ, x25->t22 / HZ, x25->t23 / HZ,
 		   sk_wmem_alloc_get(s),
 		   sk_rmem_alloc_get(s),
-		   s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : 0L);
+		   s->sk_socket ? SOCK_INODE(s->sk_socket)->i_ino : (kino_t)0);
 out:
 	return 0;
 }

-- 
2.53.0


