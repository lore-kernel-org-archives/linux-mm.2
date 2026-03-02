Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D03FEB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15E1E6B00B8; Mon,  2 Mar 2026 15:46:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F256B00BB; Mon,  2 Mar 2026 15:46:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1F26B013A; Mon,  2 Mar 2026 15:46:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA3506B00B8
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:46:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BB3C8B34D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:46:21 +0000 (UTC)
X-FDA: 84502305762.11.2330CF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id DA2B64000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:46:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QFK/l67W";
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTLDjRMYqIqXizkfTfBaXPlCkZuiyY7yVVz1X0+FiZg=;
	b=g8rJ98Labce+vikl55YF8tQKKtFFbpoqXLZFKE1LWEXoUY78gyTXz6ITfWk+tyxIn4yfI/
	Sw7zPYvS1czmoWDaDJ3F4BGEx60a5Xr2Nz2+t/RmrmS0XW0L7B7PNpv6YNa5sDT6uywWxK
	mD5OI610u4KFEy/O9QBPXzwldWFAsko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484379; a=rsa-sha256;
	cv=none;
	b=2r3eP1Qv/Ph3+Qd7nuexN9QeuQcVDAxFUDz8Eo1NOBeeS1CWsEjo69GksyfA+ZtvZsJ8Jb
	521WQsIZqEdL/Joi/1+sTXdTS6s0bc/9hyK3n6prcLpOZA5Ia1146ZQvIKVPH7FvuzR/0d
	o0ne2inPN6TosefImcxaw3Cbp8PAjqE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QFK/l67W";
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5321A60133;
	Mon,  2 Mar 2026 20:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC442C19425;
	Mon,  2 Mar 2026 20:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484379;
	bh=oOhSUmlogX3hUkfVoKDF8y8a/pqC/DLSTod5Uj4+yCo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QFK/l67WhGTxY3MNVSkTneymqOrQE5FKXZDHe6SB+nNMXtNeYjIew5DQgABkgt0Gn
	 lNM8YjJvoVkj+HtgUYYgAW9IQzpr0/cfOIHJ4dGkG9iAxa7WPVTRI7LfMjERvp1g20
	 NB2RNHKtU66gMxoH3/HZRV4R+2rfoO7mGxOFgvn81JNmQu79EVZeqb5N7sgERHMisD
	 XaWcM75KqkO3sODXZYDjBLbuOWxKgLDuUYiEf04D7AYj7x0tsxaMfo2IGzfcO0gSOD
	 YcWpwatBWQJMdZT69vmlZKdq2eHu04aKj7o7WnXXgMX3icvM9eeDG89T5QFXZHV9ki
	 qqt8UpZV8JT4Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:13 -0500
Subject: [PATCH v2 089/110] jfs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-89-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2019; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=oOhSUmlogX3hUkfVoKDF8y8a/pqC/DLSTod5Uj4+yCo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIHVuyPWm6Ogyyr4Uaitgz5+Zy0QdOagQ0LM
 rh3nzuPVViJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyBwAKCRAADmhBGVaC
 FUG8EAC6sR6nI8JObBOYvouIGChfBANCmxFZ2xYcY1j5s2hD9uFCg7fQJ0jAKZMouw/tMAZgjd/
 m4N7AubbGIA/9/WBMScxAnpsIYHXZraFaWvOsndsTukur5JxALyIhPFz6+GpkFDN2s2OT66hKfh
 C/RT3gGd4yxg98E2KnCo8aHKhr5lG/0fXpqgH+IOfdddVYehawAK6JakiIfhF2nyW8nDX8U0Eif
 /6Wj4ib6XZsuiGvHt7SJ07d2Q8QTzUhgWiyNtu8KcSYMces0Gj6zeg+i/SvD0L0ALWJ56UUe659
 pdyiLnatxvmsx1NdT/UKUKlFugXyUeJFD46H6wHulnrl6XCiWi8FzNwUrOe41pj5DwtyLLp2E9Y
 sAA5HchXdhWof5rVVqElVkMrXdASYBe7HPu/dRMeWwAdQalBHWFivg2gKMIpej4I8Uhqffimo7K
 Ax4qoBlNlESu4VpNIsliVjzhHvzh2cmxafpGTewoFYW4P5GIh1IZHN6nd73fG9NauLvMC/J3K+w
 kqx0oRG4EpCQ1U/ntMliW508gwqp7fjR6/uekoTUSYH9eplK82F0BA7QAlBmiB1LBAj9pVj3DLn
 jte/6qynA4B5h0jRQkSRTuvbLsRccq+akrBDBXmhP8CALxeqnjlFNMsC6dLgInpOlFCBea/12HK
 JZIjXU3wI/gm1HQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: f7zsey3kizs1kyx6i68ido6xbwcpeck3
X-Rspamd-Queue-Id: DA2B64000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1772484379-575168
X-HE-Meta: U2FsdGVkX1+lE1Mshf+VQ/D+Riqn9M3QlMdSt1v5n2D4n6WOFV7e1Q+OJEXbEKfklIlokrI5pm25nPbGfzMgO4VUxj9pb1T3l4NdJM7AFUME4VW9QBGqryi/oWZ3qdyBxkMOscJ8xB23Sj4DPzOIqDd4m4A2ZdMbqQXdRWU+wKHnVfpd02t+Wz0u97ryS79u+3RHtrjWBdlasT4ZoOY8sF+YZ6xAmdgNFp8dIedVeuA+Ces5rLoiIW/clSfhWKE+PpeNPUX//nqLaqNavZNjxKVQY+pqapghbfoURMMCY7bFQM1E3pXxx7K9tyXVxf+EVQVaUwA2vmxUUHdgA0l5x789R6T4o04F8BU73TyFhRU7TyxQCmu5FKVPYxbLn7eqt7J3nqz+Zd5PnVkfddsYUMo46MxUr0y7/wvfheW2V6guwaTkkNXjMu8D4b50PNcwnpaJUTIrAB7paKcdRIHj70geaiwtKbiDdtLIb3CjYcDkYRFCmB4vKfBYKUOe+YXarIaTxQyplxc+PiVIUBArPogWZMtm2UgLe4L8w2ZoCTUvJORuszB+a54M1J3K7AfCH+WScKDPQNkbkt/YRHtmFyA2G8vDu4JQVig8Qgj3mssjKI4F8DpLUNRsZYwNuDiSaihDjiqN1g5mHy5STXU5A+HCksFmEOawU6pj+xOI1sErKfLc7zy89xaN4WjU6L8EhAEg8cr9DK2IYZ7ZDlwcOYuSaLBmWVnvw+HgzSSIMLRtRz+eqv5O9ZMRL/ZakQZZIDAdjC/xWk9cmatbUFH2lVb5MxfPU0jLeIadfN0PD6jpVm+Sutd3p/H1Z52mgnWEK1wPqPkxE4MDDkjbV8UaP11Dfu/MitpaSQdDCGyU0DG555/ea6TYjgLYnqq3nfZr5iNDZQbfp2ZoIB8PHTjcIsYJFys0wDhw3ZEDQMOUykg0BsYEb1SH0rvrhZECVp3ItuKSaO2Mim9baZA5fb2
 tf9ysAJD
 L1OHGxqjERfUTzCSDTF3mH4EO7SBBv3c08GvZLQqWQgpKHhXOyp6wC4j+9T9EWdJUStHRan65INOGekZyStyOtT7RDcKOjFaP2yOYRjSe904ILTt/NdLAXeQoopN6S9pIXtnpuFVbBFgfmJIhaoOZuRKPfgsTAyTwEgxL9fU5YKW0BcOgqve2VZxPRkf9fvd/a0hYm6kkfKirEqLDF9aKHbLAOiOqfMfAdqIOeZLr3S+iQoAj8+zWBG+aDBq17Qj+4VezdhS8MgVAX2NGUqBHietg/p83BvTwR2l4Eu0tAEZtAuS+IZpJFgQcrCXUa3XlP5r5jjtC0VNY9IgKca/CBateXcwBkEALvAg3SDGnNTh72azw+q1OD1w5GbyYsW2YxWQEdrglqTP6frODB0Z8t8/csJVP57pwjqpO+fInDzJ5wsZjKKGFQNOEyIpt6IjujEYU7YR6y/xia8zLMx4lIS3sKOygHDVQFTmA7w/afkZXiw3Iu1Pjd7udfUig1zK2tjIHpv6PO/zgS7yoKwIYhrC65ZWhXhHcBstfR9XOmuo4FvJ2mfGRe8JaQWYNb6aL4r/RG3hpVD4+HZsmGwx2jeu3WkKpqs6SZZh2UihO1SQ810yo0yt4hP0mUBu7KYXkh/YI+R3Spp8Y2RGt2UoIRnk2rpdz66Uny7bPBx5uqAztrvr8BOU0uTkNustDDBar9warBZeI1D5IHPDoWzz0VZFOQjLyYVHA6eptomDTMHt6+KOnJbCNP/ipz+NZFjILrlhNCnzV1ywRp7aaF9nQd/iiThTOOLS88VMTj67y7oY06yE1rFzMMoe/Xtz735ruDFmMs2W5QGe58SWLBf98pu/vXmL1aw7KDxwP//snv538Sdu6ofkWmVJxi+zqajv/rs6OMQL8wMF3tt5+PbEVvbOkZQdLZFGKyVezocf5KmcPjyN7xa6RKDUsVUsV+XmWJgIwY0HFF7XDLB1mAJ9YmWjbhX7j
 wtd/9pBx
 pR08OLHQFQrlQHxGjJf7fLqoN2VIQl6dBHCJtF/Xffv+sjuxl9JRRv6J29SkdzrikCIN83b/UtyRBUey+vg3Gr7++zZVGeF6tWNqvBomRfIezTuFmCj/gcg4xb4331Gm53F1wHm12tqg5MVCW3rgf+GMLbP5m70+P8Se9iPBNTWFkeQFSphLnu9RENMHtzwBD3ompMk4EoWxUPNWY6ijRWmmC30tHDmEVBREtWMWYInwOFYm4sBuGFH7vQ7EOp0ua+Z37dQCBXMHG8tDxtzrpBIJR9+0q6H9pTqptk+PZmj9hPIrIl1wJk2T4/6uRe+j/KM+eV7dsQ1HjpkEI/gPH4NsxTheKmKFT6Al6iWTs48kUAHgNuR8UkyRcVrTZYG1BvT8oO3EC7P3BcxUlijlJ797SP18b36ljeQshDVqtyuH6LLHFyJE8hlKHzYKhlvgS+qISsEjJnBIvach18194z+5QS3JgKLjrj74T98TJunQ4MbS3vpeFAv9tpUKMatK5WOQ8Xeqb4JSL+aVjqaambTBIj/IZ49KZaMI26x3ikQwspDLjE/9KdcAcYW1JODJzdKVWYGwPa631gmqEeiuuBL6mux/Br4/HMF9947Ao9Cd5orT1P5xOZzgE37A+JK1/kNZ2hpKqLDw5h46VhppGOwRoZ1P2WQGi5L5rSfUWZMVRGox4Q23CaETai8uCqhQ1+6OhvHolCrCJIY29kRX0Xv1Y5luDlzGN2rRmFy9lxe6e2GSjASv3AFFXhts1968BaDXCjyKgHGpxozKAwpeAb7YS2uosc2yofsgZ1GConiFXN9fVlZfZ6FfeDnmplS2J251UW+6O9+R8uoOXTpG4vjz4sA8xSieWIjhJiNmC439SWJ3TIURy9AioLWVpWjqN5hrkzTB+X4zz08VDOOWgVYvhF2TEz1VIPSoI/56HyBWSB4/ilU1mARxzE9MJwT0zZvMVfXDMegL2awoTfzR+CEMD0xlI
 KOl3VFGA
 gfdWEAnvSGvSwr3AZY1TKwIRo4WECwJ7PjtndArlI4GoHLDpEacK30TwllEXPg923likghAi7XgLtE8K0VzF3s3U2VfRu8LjjY+aGWbLHQAgMlrZeoQaVU6VxoZzgJ8Jo5ZCqSUHLKBFuuekEZ2YHLkU+gXspF0dIkRYeKxRt3oj3rxEzwuNn7s/CgcIFD7R9XVZRuQfBPwsRtICCamspIg3OpPAqTB0dTNZ0hcoGe9DBR8SmD7Csn6dJWVp10NMPsv6Fq9D8JFUZ50sH0+w3sQg9iBl5LX9DIWvvpVgDLssaJL7DJ39yUM5R3Sj6lwoZ01BqKC3M3KcDyPvzltcSQwmZcqGIcGnUhvpLyUGda+yueZ6AEGx9RBLQC4VCzjMKgSqWQCJ3HMtX7ccA8iNYV8oZDPtgQoWfAQMtpoc69n8JZADCjr7BLEguuO9862sROjLyI9V+yCbpyLPFcw0DbrDGOM0O0o7iDu0t4cBpu0N8+YTeVDkV8+uH+CWWO57Ny4zad1TaUrlRWOtKqYyHAIYJPL4U5TX03kiE/6w5LjiXQ9rZ8t3Z+vzfFkZbkNA55+JVDWPPKt8lTf3eaPHXsMbbLH3PRfyVuvyicuQbpViDZe0uppZEqs/Y6+XS1oSg+Z0DAGZNj5XR7h25ybZM/maL9KqzMgNKV9zNo+EqLQ3NNBOVZqCYMO1d08Lqq0hNXXGu+JOKoO0WegMi5EqMc5Qp23YIEJkva7FZCvh44jShcjR81TNHVauibtWyNqtuGrjRTL3UHIpdCF9zvOORBqq2mVekH2PD1/0wckMcMvSX+puvr3Ua+woLqYMrqB2XvbjticWMkWa7fkM5Wv5fVeQvFyvq9WoHw4YAlrlQVJEG6Ygswzg4FeUdgwshtJ9Y6XHraKEo68VvdZjFVtLfdZRQKGl9HzIdzwbWJNLlsVGg+VoD1CKa3gFJETe1f4aKArTTYXv/SSW0aZxa4wq1O4k+Oj6T
 X04UFvNX
 4G3lc5YibGiSrBvVFptKSQsxU2MkAbOvPUGuM8f96TqkJrr6Q6nM7gXXtfYZLhjRNXd9x46s1zF706vQcO2c3DKy6KHrW571N3iGNQ7VQmA0NME5UKn12iHHcds1TyMM9svq/mL4t8AsCo+btR4E1J8p/bAoWcEA/EI3kZNz2eQS937CbfogsiPd7g0lGiPAO889mDqi5pPOjmmXkOx5B/zJbG9smUkR7lDr03k2dBPzHEE7uZfX2FqqTZzQ3fV+4xyd6oAOcd4UIdVCuyy1iql+aoOi93K1ayi3L3LeVGJpqJp3kMA3L6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in jfs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jfs/inode.c        | 2 +-
 fs/jfs/jfs_imap.c     | 2 +-
 fs/jfs/jfs_metapage.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 7529043baaf30a6227e5d8edbefd9e37a8105d43..c7914dbc91ed97e200edbd114e2d4c695b46fb7e 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -64,7 +64,7 @@ struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 		inode->i_op = &jfs_file_inode_operations;
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 	} else {
-		printk(KERN_DEBUG "JFS: Invalid file type 0%04o for inode %" PRIino "u.\n",
+		printk(KERN_DEBUG "JFS: Invalid file type 0%04o for inode %llu.\n",
 		       inode->i_mode, inode->i_ino);
 		iget_failed(inode);
 		return ERR_PTR(-EIO);
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index c9ea54f06114ce210ab2d80ad80d0dfa6c55b250..13ab21e66f510befc477bd15d40f69544cb7a386 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -302,7 +302,7 @@ int diRead(struct inode *ip)
 	unsigned long pageno;
 	int rel_inode;
 
-	jfs_info("diRead: ino = %" PRIino "u", ip->i_ino);
+	jfs_info("diRead: ino = %llu", ip->i_ino);
 
 	ipimap = sbi->ipimap;
 	JFS_IP(ip)->ipimap = ipimap;
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 0a1efacaf4e2196197cfe44e5c51d89b15d39545..c95804f6dc1912510c51163cc120d536de652fd3 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -692,7 +692,7 @@ struct metapage *__get_metapage(struct inode *inode, unsigned long lblock,
 	unsigned long page_index;
 	unsigned long page_offset;
 
-	jfs_info("__get_metapage: ino = %" PRIino "u, lblock = 0x%lx, abs=%d",
+	jfs_info("__get_metapage: ino = %llu, lblock = 0x%lx, abs=%d",
 		 inode->i_ino, lblock, absolute);
 
 	l2bsize = inode->i_blkbits;

-- 
2.53.0


