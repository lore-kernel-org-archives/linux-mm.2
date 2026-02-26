Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF334FD8FD1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A9006B010C; Thu, 26 Feb 2026 11:02:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23CB96B010D; Thu, 26 Feb 2026 11:02:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106F86B010E; Thu, 26 Feb 2026 11:02:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F07CE6B010C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:02:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE0B61A0302
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:02:24 +0000 (UTC)
X-FDA: 84487075008.01.06229D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id F31FB40029
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:02:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IIeKZc37;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5z0uqmQ45+6/bT0pw4xpo46USFkmWfv5UBxpfUjRJAc=;
	b=T0bvH0XR6R1twb2t1w9i/ITCQONtur8PS3SI2hZtpIGG+MdM7szuOQ8PdnBQXPcMBwIOg9
	1dlSjkxQzOntv03173+n5SyQmtSi5D2OhrmeMPUMIZSpZStwAKueRVzpIovjCUxmYwkx6h
	uDXeE+q9yC5mThQ2n8m9EbX1lY8bBdc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IIeKZc37;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121743; a=rsa-sha256;
	cv=none;
	b=ADeW79v9/FFoJMaMJXOe3X7HRIObiJ4bnl5ntnCoq8Hf6fa7ixSVWhenRvnKyvLTi2346Y
	+v7Jy3wHRbDdqRmEBR7ociAgi/lu/CLCWk4WOpPqsU5ReHMjVvbmL4yargrvxyk+FCZbXZ
	xitkoWRwZl8o/H5jpEMHufEiy4JBt3A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 13C0261421;
	Thu, 26 Feb 2026 16:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BA9C2BCB0;
	Thu, 26 Feb 2026 16:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121741;
	bh=r4NQTMCAdJdTju60BKkzI9ZgcdPji05KczFBMoCN7/E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=IIeKZc37Ng9MR9i0PG4PHPUvKUs8x/8M97lxx3hpHB6pv6XDnOisZ0nNCgz+ACp6X
	 bBneW9dqcyJmA8N+DzE/wME74yqR5PkAwepfFzbD+XqLAyHNdiia5tZqfdlvjRAwQ1
	 smLKQTnhuV1zmjp3kBX25ZNfa30WPnU/cl80mUs6X+8RJeVBFThXa5OX7cB405ODBB
	 020q3Aryu5IZs4v+b7uNLOH7f+2zOdchH0stYwjryyY512Vr5vj5LljegQZ30ee8C8
	 8dLkD6MWawf6hLtiijiZyqrNKFzSJSQZpHDIcfpMuYNMjJmubAY7lULJU7bbCo9sY9
	 dxMpjBOROvlcQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:31 -0500
Subject: [PATCH 29/61] efs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-29-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1558; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=r4NQTMCAdJdTju60BKkzI9ZgcdPji05KczFBMoCN7/E=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0L8HIg1mrked5hBecpnNFa4Zl5RR0TOro28
 77DuvubI2yJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCwAKCRAADmhBGVaC
 FXCEEACs4uqez2OwdNTA8bdFfOCIcaeA9+QQy5AhCZlueauFg4niQjP5FJUQqWj4EBcdYUUgDSD
 9O0MfFdiD55b9s2B2y1C0WprMQ1LAVc3V+c8BGmy0H7ReRxXViINdENWWjrUcGerbCPglhUulBA
 CiwgQKfHNJ6ojEwzWX1KE3GHnhl1ocMC430TV0xpEa0USKFXzhqLcTdHzWdC1sKgtcZhTGjCzyd
 eX0cEv+Vx0LBY81mvN7XaYLRyCcRR6yRMH42/2Q7hS8hWQO3IAvzL1sBV2mnnSmH6TYdvS25kdA
 x2EeCUoLJggmEGF/Q5KZf55MTXLOqgCkS1OiP9zYAkBH6EzgOSnv9X8JCRs62gtX7WNhd/nxJKl
 IKFFe4x+mQ7xnWu9W4IXNyWKrIIQ23TlzZtv361xWzq/2GmHoUNPyxhRPNyg28Z0UB8OO/mtKBd
 o2rv4l7wtdRyby/QV+6G5SC0Ob/19MX77a+4FPGMH8PmkZ2qcwn7t6MouQvthGV+kXJ01bi9ttC
 /5wgOjnQ8vZM1dZzyGhI6phRI8+/jLlJTFXmqLX+ZCfR/ke3hjxf7HmgZ+NjOLyMguXbm6HpDnn
 3+aI5rjLOyX/Rgn+wHYy296J0xSZvRbHMi5b8Qf/GGMH3A85276g/4QHvszZ+XFQyLR6LUgUPSx
 XQpdfsjLgWPecOg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: mu3dmqrege9mb9rwd3jbif4pziyqhe35
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: F31FB40029
X-HE-Tag: 1772121742-946323
X-HE-Meta: U2FsdGVkX19yVCd8wMXC3ElboAF0afVPX8p973v7NXqh+GuWclu3CRC2d32otQqpsEi2kixyi1CgIMz2ZgCzSFuSovbgpZ1XOoNVn1X/Y4Bp05IE7LlBgPjwkPf7WK0z+vBKhHQoEJuYotqxtDvj/K+9RJ580+Q8nGndsg4ECREOZM7CTSXul+WVqSmu1QHF50qaztbK3WVQxW3J5Ro8+3IGi3XKuClcCgHNiwiuml3KFBWc4HI1u6S+k2EkWEx0XRpeBKjBBs28jVnvZGiIIu2VGHqwN9c/9OK8ytRKoDylvv9086iMmfij85Cop2dE8YPtnkmN3rU1S+Nv1p8PwciE5Mx+vK4W5LM00yo4UYno5Sm+ciuZwC1QYqTV1WolmU9UqnqWcY5RElonOkMF8qrRH5zmj8yVj+wQ0ZXn3OuIshroMcR0y+NyPRFYVEQxNlu1JHObd4vUN2RgiKzos5dKusmpgf5hFfidMGPF2Ctrc95KQDo30maDIuKhGxlbbYfjdlxWbB+il4R8xoJvRoO0b2/0JJmVBkuWA69lVnffAQBxiVzm6034ND5VyP78PlqOkmlKEbA6lqWWRxiXS1qiWaiXqLa5nMlUVYCpx6QX8OYI3oOcLSzTA1DMYW77J4mzrqIyeeXwVkMim0USCLD7eYnz7PKPkUdZoO1ykbK4v5zuuVSxNnrzUBQ+TYZM3W3uA9NQtbbg+Enk6j1h0wJ4XYMrXzQ03swXa5p9B/rHICxE4K7n/SoqDa3Pn1rs1X5hvJiNkMcHY4qXn131/lS+s7FAfSlz5X+gHP9Sl1rdbS+V+4PRsNB85G/1BoQuv962AUvJ0S/I3MphljxSZMqNNgbxSzdqHjMJ160CdG4/uBbmVBXS8D6K0uJ9ZBqyeJXgGA0tYZ6x7lvru9+bmJxOeKEEaVyKbcuEH/xdDOANKdrU0QvBdcyvRCizZTul1+lTKL9VnQzax8DzRsZ
 He1CNnV3
 1aAqytE6W0CFinKWYP+wxO+gQPNvStWeRzSvOJQvpTpFWzQwrh1S+gnFrx0okKywJI1jXn2zFmfoij6JOrQhbC4nxbbaArkhAyVFOwbWruHLniZqhbMcit7XMiLe49nrX+Cocw4odqeGopveAKZXCpfO1Ojj+SyYXjkXR4aULr3H5a2UsM1jonMHhy7DjzrmA03MSGRGehCB5S1EpAuEtq6QUP5jPVBSAEwbp63CJ1u6JUrhk+QWU3ntKhaUBJiLcPC3sI5kyzjjzE3AIlc06lm3juvC9r6oCt5fuJCQ0vhPnD857BUbsz6AxidnJgcE3tq5E59lnzp25HDnzqM5G1Go6jt/LrZFkHVDxDm8kIFXdlY1vs2H98aXj0UyKd5wqQPjU6LN/xk+zm8alomeGyQMe8q/7Utl9eQ9/bROWN/SyYslM8vGcl1M2OLlYBUnRuBItMOCGjhdMz5Kz1HIw2HlbXvJ382sKKegx3Xrx8mJTpz73VYL0oJtqosKoPwJZRf6XTSvYFZJJJ0rP219alR9u7sJlfLfZ3q/Vrj2ZgOJGSHbTK0alYecV+XRkSlLRkpqfIfj9o1O1aQvYT/XfF0xPar8rRYyRgxhcdX2dkPlUyuYjSnOXTLUVCoGub5A18Sxud+m6AQgwc5bFyvhO2oDt/nu33VTGz7sxIjTiwFJOMp5U3HMllLmqYp8U1T+ZFCJX8pLuDvNIKR1qGHDOONOIQ3H+ju9eWgUKtv5cPjPMflVHYhLy7WNhzIKB50piUR1GQmY7MDk1dY2mPzI56gvGj59WJXJPpAXJasiNyZoQmAbt/EEDH4u3N4SQroeGIoP8gr9fCjgmGEXTQGQArIsZtVEaN7MK5B0EKDmiIB+y2MMQdOW5hClMgjs4JOQXQKQIojMPpxw695/+o9rR0Rc5Z8yn4c3ZR6+1As2RjY8PryE0uwlgb2V2oXKxB+TriGZtccA2UBohs8P+UChIW2UjeSic
 aA4Z1yN+
 RUyIqNkAsRc5uCowNNjfSz6ceeI3rz15kzAobghiqjIPjMMtXuVIzje3p5vtP8WPodnVX3TEfcs3ME5RC9HGsSMbXKVOacI7k8z1TdPcjzT6z/MYA3TzOTcuphMQciBxEoYbEyCEQaILieQDx72P4tjfywGDxmNuAdx50hnLPg49ZaWuuzWoIS225uL9NWrBejGM0AKY68weeSXBPtJxsQHi6OLKVcIc8/QOEIRyrkV4pQ5dW0/YJyW59FZtI4ZdRMqkTZHIMMsxVJG+R1J+BP5NGmqWwnunbK1acs2iRLcd7Yx8EnrbgjBvkx3wodRU1pyEdz++uQy163lGqE4yNgc6ipDNPQ6F9WzkKMXSS/fA7rhY1DVcLRx3jtNyL88gR0ItG8g1gZyEL+6QY9olWmO/dAo/YtBNY+m8bSdgwDMclCkDazA974OwgSlefxPSB1VdirH4ghkThB933OMuNMBujlf8indidednakDYwrU3vqIT5N2ylerh1Wekpku3oV103mboJoAoycytbmIwJevGLpeOnACWa89SwCZiLQr06mf3vB3tMpwsv4fkIOLDkTZfsYnQKcnH3T8HMwrHz0Y1iNwZtadZsqnn/gn2BlP9vGworjom+kg83V1GoNjFtywKqY41B4XgD7TAygPRZ3VsIvMoLPz8NqH2fqt3kcUY6q2uliQDULOx2Ttcuir/B1SNsakT5Wh3SJKYd/pWtb139dPpI/j/zU1m1am045ZlN6S+vGcr74+zkbOt4hjeCN2++YVfgf8hmDee1SPRNrXsvf7bSh0vIdmxA8+DbHOEl73OMSWT2yqYWJ5onXbSIK1m+SkBvT5I6avQ24hFhctUN8mHBiIB2Eph5HITZmguxUUn6aDajYZSp3pjAHWgPK+2QHX6WmhoC0XFU9fuVoEGXNkBe0iadMIjPCBGo4o33W401Q3wvBWrNBMVOfasPkIdzfXmfvc5HXtnIVXt/NTnIqfi2
 ggaVWUYy
 jtyjaQOGXo3imhD4o2nNIK4Kl/xY+JfhgvZnm90Sf2PtNaScDTyoXBy5PzC8t7g4MaJfqJ5nlXyYIM7QEl5xXfBkIvrp4C0gSWtt6n6B8KEEBaBlYxq2Ty4d2oRUCG67w9kpaz2FGH5WEGj4kujULi50+n+3rLYKvfYK4n3sULUTh331tLQlu2OaQR9YLIHmJmnqc7XceIu3K+2dmlV1kh6s46I+0mg0d96ExnDW0djx/48TvnSeXm9eHZD+HMPzFzOYm55p8CTLHyQlThFcCsNKOltHS4YhkojJI8H7FSoygOLBfdYDfnthMHT1Yc+ne8NI8PtV/xqIGEgpH2oHjcBb+Z3UKtzrON4CJGAqZXwNjzOGQje5364VLO0xhwVeBCi1M+FZygHsXEOoNpfR9i3wcnPo6VTQxSHDGbGc8whKGxysRL/+mCUeO3sRFb+xzfzjJVch9GbHtdOrncj1gG242JJvLHVp0Mi0ilth6WAGHsMTcHnhXXexcIWXOIes/5G9z/0LmTIyNbstL525YaxTM6GhG+h5sLyKGndGoIJJlFUpPIrG04sTq2FzU9Wz0Nc8iK54oVjnJBFkuezTUBq8dNAcdGFrSwjrU6Ot1hQrjsR83X7aTSgi68geCpKBWbwTpm4jPFGeRams9KK/O604P3QMrpf2l+fmGWiM3Y9KJoFkpx5vte4d77E3eiJOrQ1eUqKIONFNJr5gBnAikVe5FtT4eqlBZT5CQ6BTjfx84hTNtpjMaTGq4psXryZlS31ZavPGrshhIf8xeSrmNO3s1bDIS1ZeyPS8zonPjOwvXuPSp8Qos27ytKl/A8Iy/RUs/piGkWBkiqsolUGloQiy1JfoSxeA8h7ipbSzRmy8za4TNGH+Qsz+7231GRY28j/4AuswADkGnljRuMRcwcKnlUnU7OD2Ph10v4mXjmvr7u628g7/ipEZnhKNryscNMmPhqd3HqhB25P3VYhnmgPYZH3N9
 Mn6DCb6n
 JVfNll4XE5b6bGPltCbkxE/nEnfpYF3gm3oD/Y08w51moJ28mYQrf4MJ9n50gmN/omgnhNySfQ2QWVDyiias9PcxyFshrCiVNu+Anh+ERL9VMAEaDmnX2Y6+fF+BOKwsGvmYgXNYlTQtA8+h7JVIETAryTj3fda0t5Nevd4EqlRdH2f44PaI2SLKtuhOQaVNVZjQeCmwCEitUalbOTWnc1qgWGFe7cqQmTixXg9XvY44/dzfEE7kL2zO90c6pkdqTCj6rUFzm6/eOaTTS1WN2WwY9AePL2GQYz55T/enP8ujj2ZoCBcacfqLEA6aZgcYO3vtn8h+hofsPChJMny77jybbPTWV4Bs61HmJ6Jq/PN5OrJczsQcXV+TFHdRFdM3reSBJzx224SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in efs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/efs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index 28407578f83ad5db1b8a7b082fa3e990b6b442ec..4b132729e6385de196e156400d17a86ed04dc2f4 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -132,7 +132,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	for(i = 0; i < EFS_DIRECTEXTENTS; i++) {
 		extent_copy(&(efs_inode->di_u.di_extents[i]), &(in->extents[i]));
 		if (i < in->numextents && in->extents[i].cooked.ex_magic != 0) {
-			pr_warn("extent %d has bad magic number in inode %lu\n",
+			pr_warn("extent %d has bad magic number in inode %llu\n",
 				i, inode->i_ino);
 			brelse(bh);
 			goto read_inode_error;
@@ -140,7 +140,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	}
 
 	brelse(bh);
-	pr_debug("efs_iget(): inode %lu, extents %d, mode %o\n",
+	pr_debug("efs_iget(): inode %llu, extents %d, mode %o\n",
 		 inode->i_ino, in->numextents, inode->i_mode);
 	switch (inode->i_mode & S_IFMT) {
 		case S_IFDIR: 
@@ -171,7 +171,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	return inode;
         
 read_inode_error:
-	pr_warn("failed to read inode %lu\n", inode->i_ino);
+	pr_warn("failed to read inode %llu\n", inode->i_ino);
 	iget_failed(inode);
 	return ERR_PTR(-EIO);
 }

-- 
2.53.0


