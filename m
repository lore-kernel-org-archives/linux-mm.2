Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C35DFEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BBBB6B00F5; Mon,  2 Mar 2026 15:38:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345496B00F7; Mon,  2 Mar 2026 15:38:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F15B6B00F8; Mon,  2 Mar 2026 15:38:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0EAAA6B00F5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:38:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF3468B34D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:38:42 +0000 (UTC)
X-FDA: 84502286484.02.814E53A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0D45F40014
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:38:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KW6sLgQ0;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2YKkRlb+3NBPs/oV49SYM4Eqwc91Ri/EXy78w7tBVE=;
	b=k1wuxfopPFJoxSZqATqBwygpSBaGAT3zs1tt28zaR/R8fHYGU9nCJ7rrK+2JKG1wt6yXCN
	Qio2C1YqN+EUpiRY0x/4/9lxQn6KyHidX5Iz8YidiTUYkN6GiwZsVLnMbWv7cxg5trLI39
	+gPigwCHzy8Wzw6OxBg4e/Gz+goyR/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483921; a=rsa-sha256;
	cv=none;
	b=FgIS0uAgo9DI5UA8Cdtc1WnBw3rQO0hn3m2YoB0Ty1/ufV9DtddL/jr6dY34ttEbxepjTt
	OEvhtmg0EaRF4SfVAmvkTS+EAW61YtmqRxW9VMIzQY6Vh3Czgka9dMGzTZmmgybFDfojpW
	nvcTfcNgq6+SXMqLkQOJvnXXM/Yqx5I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KW6sLgQ0;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BAFF60141;
	Mon,  2 Mar 2026 20:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9CCC2BCB9;
	Mon,  2 Mar 2026 20:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483920;
	bh=Pa1a7MUazwWtRIy/L91NUgTuxF0Xvz5MqICsJ7XcBpc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KW6sLgQ0+kbptMpwfxgqsxPKgJHgnWkHvUw15MtsbIIFkGZmGZMlUspcJiYwMb9w/
	 /JFlKe6QcXKc54Vdz78zZ2mk3pDDG29SWDK1PSSvV1BE031EZCFWF0a1vcNSba9tS9
	 sYEQ7WJVhOinJFas4ubuTyArDmN0FTJxphA2q3qScM17hlNdCneF2rXuZ4dDiffRPh
	 +Gb0vdptxU/rrtwQIfuH+64gsOfed7AmMdofGQSWqPB3Tl+RKI1XwvdQtdil6jB3Oq
	 unRBEFdvDrTHjttKFgRV3DQSb11jr0zeTz4sLbEA3zUOPC4kPnTueMsS4YNC/RKl2w
	 4nxBXWc2HzFFQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:41 -0500
Subject: [PATCH v2 057/110] iomap: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-57-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=896; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Pa1a7MUazwWtRIy/L91NUgTuxF0Xvz5MqICsJ7XcBpc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH+YUoZGChUtceBYv02WJsKa3i5Y+UJjTf5j
 GbTR0EKL/WJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx/gAKCRAADmhBGVaC
 FSjdEACHQO+4+knOc4KC48DC1onGbTDd53B9vfLkTayG5rzp6rApyO1WfzrquWc20DTlq+fDmly
 J7FEad79OdL5kngOID3P6/NqK+KGBl05ggSgc/t4z5+JA7ILeoKrH/kSED5DUU5sEb4eqaBZ567
 XF71VJ34KQKQqS6+nK2eCr2mM2BC+k7qMXqwXnEpoZCxpa9siuJYrOnliG1DP67w7+XuOMYPW9M
 urDy3cKTSbf2iOub7OystjIg9N9ZOGYnoRw0Hf9b5M1vFcoZfLxx1R7L/tOgcP7VhMBb/R4S0yk
 P67atnhYv3eg/NxGB4ZELKYvKhPoCJqTwGLPdD9lld9bYBlJYSLxI5VxXpwkwyw1Wvh6eD+Xsce
 8VS/yBHBTjd+RJhFN8dqwUgS98PCV1i88V8nhA4pu7e4r85kTXdSUIGj7m5w+pZ4ImdZ9dLgZLM
 1fAUnseohUleWPev0UWdk0quelSLb5rz0aqRwyrVtj4q6G3Y2rWEYMeUPHq4nSne0Fqet0ZF4hN
 4OTt7LByIoy9+VKlqgcI8IUu2bjkE65Qx0JE3UaMl+ONPP74HMWx5e2bSVlppxrqhPrNMnUD87+
 xEl1W9YJFqWtC/iDpQCA73TLsvBIeQMWP9s5BpsQR7R9aeSD4FdmdjOjwZYu44PlmYPm3R0Fc46
 06M+Oieuh9u2YoQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0D45F40014
X-Stat-Signature: 9unzneg8e7btom4e4anktuqiakhsurdj
X-HE-Tag: 1772483920-146277
X-HE-Meta: U2FsdGVkX18h/9x9zOQmSEm5dtxwDtTMJTnHIOQERNybUHYieRobCbTaZgOt4wQNK6sPNhiUV+lW5fQUhiVHEuD/8QdjroUuRbJkXE5TJSr97d7rUB8zKRqqNIjkgCf00Hpi24bEyqEkxMe+XMWi4RLMd5ueAUTifOkyAO3v8BCaV+w+dLf1TXwm8cgtx8Z8qcIZMPDAZ4ITq2J8/VxadSCO5xSaZpa5nVmgfHdnCQlY5j2qtzEtddjfNXdH5v5pj80fylCwJQyPOXJyS7Dbm0y5rgdiKfP1b1d2qaZ63c78jY1Jq9gjOeKcfhVgwOPSIZt88QPDIZe/H6LZ+Ek3yoZOH+5i9eBK+JYWFrSaRaNIct+2bMrsHF2kQ/LYl3V065CMQbPcWGnqlXmcDIWXC3OCEUrcOZV3k3CU2vZv7gD52l2yybb+s2Vqw3J8zFTsEZ6u45fCFLb5cU1oJ8GqGZaMZ7YWb0wNEsCQapxHWdFklGz/ni++3wUiQ5bUcFIRsz4WSLX5nCLfz+CPuOmYgoU/sb45bjMX4yJj1/9J1jc3597iCXlNwTL1HMI4xMAlLSckd4bt/VY8BH2rcmP3a2eSXrk0b1NWGRwijApYobPqzAN5ROe+3NvaiSbq+TBe5QlMTPaxSCbvTnNPnPk82vwJlinCPxEZGeqZfut5dqCBV2LO4WO2O9uJZ5wE5bKyvlppBnuRNTrILwu9t83zVd30uMfjTxBQe9Rotqa1UodL0FywZ7w22xRcbyJIOTTjyP1VK2fHsh0xpI8Sr0UUkAQzWn2QEWClbmpbyIoJN4RFvks6VnWbbE48zIsvpHrOSxfZGj4asrjZaccjPYjPVU4hoyCxK5oC2o8fckb82okKaq+iHODd2NkoiZ3+8Hj2yC1XY948J7y/Qr2t2l/aFKW1ioQi5pwAgXH5YX+q5M5w1ab4DRYUyKo5HGhJZDeaKYi1S1Gu7WRxVBWU9V5
 AOZcmUun
 9L4ZCKQdJ1hRUzoYG1+CekM7RJm48jeCpUnK1rEVTcjd20Mlm+SBRZtTF+4YoCHXHXSX6I0lrM9kq5+hB6F0woR49t+gjP6si8aDfHsCM1OvjZQ+gc4q1b9SG00SUlGahk5JankuqbXgOKCfikiZjFxlrxgT258FduoL4irmLu+YNuHP/2mIhs1fm4zyqBiMWEaQjBPQV+vIs1VW2lsb+RdM/OyV8Q8LcZGhMvE4k4nBl7ww5AMZ7ThcbhoCD6Ok6F1mJbJvLk456MYpmXtJ0h0iVfyahlx01uZy4ZDh0vgbQA8ElCYRp4C5aXQVRN0YyBquSqZW2RQFSLpGY/saFolE/R1PdqjEowLTMScMzF3RrwjhaD4wE3HfdbaqElV/1hi1/JzJQB0ksih5r0ikjQrQ0HG6BGNJ6UFBNI7wnwv581Gv65OnFGOyFAqH1aet16nn0oxCaemPzZ1rZbIeGR9oiO1lfTWI2pP0RpWAo/VE3JjO4uK1ZhZDaQnchkVtSuvxnE0Kz6cxgT5s3+mP/OBAC0BP+EVIUFZkAxPYw51TNMvrnJMeqbZBQgJwmzgKLsSnpLuITvLBWoBxi/MWr5HyIwe9189poR5rU7aWEc3BnBzy8g5evGYJUM7FiKW5wuWi+2TQ6AYXZgU96nvY+w59hZnPhlUx2Fe0/B+vysy5gN+IKYZ+IurhU0ztR+Rj4SqRTC3fRVlsZMU67H00lrcXhbLNzDrXc7Ky/MCWpsQg/v2kvET88GQcrTI9YHtwbTP0skhPaTRg07jxYuHQTNWig4qczY84hTDojTQ314hKGSgr+MscarTOMg9JKL/gEIsS4H5/E1dMyjECoBpCWalXa+LYM71IadpG6FqZL/MQi0/1vV+V7EW8uu9vl3yS/fk61F0YgHZBPwNRHaKC+JUxGTxPY5cVxvWmY3WnyIjHTcAQhc5izzvqFC8hmcD7NOMnzLhBJ7bFjBXa9u6vjyXBxAxvw
 bZAfUk7/
 205oCcIp5NL0r+jKDDih4yl7G/iWu95nCXGGnvglKxYbgs5xUlUeP5WjUIdU1J/UNi6mynt4nmRL/n9RjnuF0gUV4MkjYcuan8o49ESe1QBqRJ8c9gnzL+4+5wFzam3L6E7AhGXYD+6Jw20UtDN2T/BLUjDqwvEMy3uC7cK/k187hAT1d+kGRCBmxt9XLAC7xAZgdzBSy6eyoi7MUzsmAWi4p/B5HV+TZfbIA+KmMjKRtkM7MB0CFmRouf1lImxEZ4fCD+Iw/IePR8ElAY0CkmAoHk48K+FxdbHB8xXpajgM1iQ1hQ4PN/WgLy2BvDROII5qq1LCoTC3nkPz/3BQ9WrDzUTOVKiio44flf1aSpTX672FaawFyDwSWnoWFF0hmji713N0ydNHTeW3wYeJMn0HYYWindm97a5iN1SIO/bv2rs2IcB+HFW8Q2TG4L4YANj77d2ldv/gs5pWOpgAsrpuSs8C8AJ5GMXVhki2Gxa1H0iuxydk2rQuLFSVeL/ZBkIPdVAVHA6HmurXE4BjL7XLdQ5+BznwSkYA7N8W7GXM2O65QApdUtoHq2gA3Ug/kfYmEMOe/w+yEfUSQc+dhYIHh66im+quGBnSEOETEV+v0d4a7n7F2p8PQd2B1s3gYo8V0GG7moALtIR0hP6f9A3W9WTLFqHtg/zMqzB8SDuXR136unr2yui/oTt+2pxauUVzRmAV92elT2pfD9OMOGS56KZdEg4ENTJEWc9zNxh0uYz0TGYpCWOIiTtOlZKOGzQMm9y3xWxZMm9djjVO4iWlmavrDPsf1hHqLZQJTEeN02efqNUgJ6qj6RZNf+6fh2xE8euQ+1SnXRs2KQYnfU4lxVimlT4oyqv1uPGPOoGYtZ7AO1VJ0sPHk+UkNBTgthTvDz8FZokzJprajfTKmYxx6fjuC6BB/SYZGhngFAP5RxCdbg48HoU6oVxDahdn68jxrNvuvY6DXPihKJH7JwW6p4Xf5
 ronNfdKD
 e1kaAv1H2Sep2xgLOlW6pAR4SQeZeZc5NIzy59D4MU+Gk5vmk0X7+O7Sn4xJKJSiFU2FLbvMXGZ9pezdjHRQAVeogYM2/9LNNPvoTL3pa9zjkbaKeOK6JRkf3S2v0NmBMeqpbFdKz/OyZJK/68TE+u+AYECmkdbi5DXkUQGYo+2rXt+2A2ec3WUgt253wjhXirKjcERjfkyGsdeAakPYxBD4dBnht6L/K6VzPbvmBQ26K7dAR7pk8CajCESlWmBYIVFmWYuwAld2YBdqNfSKGQM+b9nm/vwMDwkhOKGlxDMsLWLApCsnj83bHx8xst3Z7fhQtuuxDNUlC3YTuEEp3HFc4vTVS3gp9ACc705CW8+m/MZg4In5X8hZnlgYZuD2KmZnOUkp1lvdASPCS6vHIFUPeBlQY5KhaKe03EdJQ4RRo9SLj5mcdxficT01sxTnhQpVQxjtuN29j+iFQINyoEXZzHodF/+HZ6fMl5dAtpq6UqzBSfmDtCoUtdJ5vskOg1Fexp7sL+tZs86EgUEpF0L9mSqqDJCX60xWH5f2E9O7DEeGFTFU1ydfuoWJGIOxLN0/LM63HsVcCnJLdf43Db4xoiRqUr/eWTNNx8dZymo6yWa5/C3pnuH6o5meDCwwClyP208xp/0D8S6qsTIyrDrhXuyITgFpoh6zfBA/tEJLtWXYWF+InXuS1tuZgSybBw2ulXeEgwN1xDZDsvl+HYAtvbOgz+lBpsyQas8yeci0rIukSn/JyoWst7wQ0p5JTjjD6wZkS3qgy6+IVK5+ASEqma2Nt12mzg93kphI3Um5cvVKIKBk/jzILKWR6uwLbL7UA/Umpdj/rXeD+4Ctj2b90/yzA6N4NhnB4i6vFnVrMq40c+8JcAtXxJw/Yu6FVdwq0neUZ2cTCvXQxPOHXOIeGIapFiLAB9GAM/cB67F9XIaPVaDCYLhSG2sSbBB5EV0+5un3GS0+ERXnuMrHl9kVW8niv
 nmo3prKp
 Y+gQTgUotsrr9FaICROuaZgEKJ6CiMli/55Jf65vh3O1F+N1QTO3dlxHdDUVonezBrGx3MJWF87whTRME7Uxr5V+WajpUvrfRyJb83Vcck6n7eZzM2DooRfofdE7p2VTt/sd2Y+xNqV3w4woXW3YUiG9mrecCpATEwhni0Z/j6P3YXW+XACwwrXl1e9wyu4rwt8h/EJTvCIudR4JECOiENtPcEzj/jfDsxksX2LM+xdOtSklkD7Hc4v9DtV3z6sK0GsyBsyEoDnEp/m9oaZn1VyYwSnei16z0WteTvt0sbyal2pPARRcNIo6LjsvJ3k/iybZ6hJ1seN7wjf5z51kAi+eR28Z5xhxs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert iomap i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/iomap/ioend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 4d1ef8a2cee90b91591d387f8e1c3f75350c1da0..60c4ba5867f8c9edda2d8b14c6cac0e1d0e80484 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -48,7 +48,7 @@ static u32 iomap_finish_ioend_buffered(struct iomap_ioend *ioend)
 		mapping_set_error(inode->i_mapping, ioend->io_error);
 		if (!bio_flagged(bio, BIO_QUIET)) {
 			pr_err_ratelimited(
-"%s: writeback error on inode %lu, offset %lld, sector %llu",
+"%s: writeback error on inode %" PRIino "u, offset %lld, sector %llu",
 				inode->i_sb->s_id, inode->i_ino,
 				ioend->io_offset, ioend->io_sector);
 		}

-- 
2.53.0


