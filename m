Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 606D4FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B006B00BD; Thu, 26 Feb 2026 11:02:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15AA6B010C; Thu, 26 Feb 2026 11:02:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9AE6B010B; Thu, 26 Feb 2026 11:02:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80C546B009D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:02:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A64C5835D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:02:12 +0000 (UTC)
X-FDA: 84487074504.27.C7E5583
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 24F0E180025
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:02:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KTS2PWGC;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRaZlA/r1pQa0xsF1F8X+A83gf1h0lYEaCHuljR3Ims=;
	b=D5Wo4+RoSQ9WAO6iKJVt7sdG65whsvYBA7qF7V+1fDKcha8C9McxS3J6X7z9v/r3cr9fW8
	llZT2j9/XcjKW2yByupPCvgcD7oi289QXmLUXJO57SwldDO8zOwiL1zR6rSXhXnT4ozVOr
	LBdtOirvlaxr/hXBbIEqy3y/3xqeNR4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KTS2PWGC;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121730; a=rsa-sha256;
	cv=none;
	b=Xrp9tn69VYgnXk2UE+1ht9sEJD3UOVZYp5J/phLoHaTUZNQxooGis+zOOlsYD9UPKH3k0R
	QdcbDuqzliN0PNf9fk2w/3+eSyqA0Io0DHo2wrGrOxyUxL4NJ6Ld3S9xmXftmN43HO+THv
	EJidnlCWi4mITphi45gHUTFfq1oQJYM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B41F44150;
	Thu, 26 Feb 2026 16:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B310CC2BC86;
	Thu, 26 Feb 2026 16:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121728;
	bh=YTbr7TKt4LQ2o1+jxlObzx7emPxn1Oeq/I0LezRxo6Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KTS2PWGC6R9Sylx3hK9EcI/jfttT97QjRqd4AxXZUUK2JrVz0ftTQ/sVqVpNcj4eO
	 x34z5H3Bp+9OPPDwFyhn+iHp2VkfykINv4c9c6+QMG28V8N8KPeLaFGRC/bLjUttS2
	 FnuDol5Y0RXjQ0cI0VQJFRBbWVJO6yRgUFs85sQu80Rc0dBsfXAlHLyt4ofWn4lpvG
	 n2+A4jL7FsRm6RFi0xVb1CxYgffoFDsAdB/eWsn14lebKKPT2qtt1HYSch9UwRjAhT
	 36q57LVuDl9ME+VWcfuj36QVmM+TDuiK/XhR4RVuQmT+n89sm9P5XsxkNMhU9uzjiX
	 kVoil9mKcnsOw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:30 -0500
Subject: [PATCH 28/61] ecryptfs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-28-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2296; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=YTbr7TKt4LQ2o1+jxlObzx7emPxn1Oeq/I0LezRxo6Y=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0L4Mj1AxIDQm1k1xmtwQArsrOZBQzBXsRIl
 tJOq34H56SJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCwAKCRAADmhBGVaC
 FYHFD/9/4SmDq0NVf4WyTJj1QscpH29q4srVz/eMwSxi0pL+MnvNyTuo59lf1LRqS3dEpDBzDYJ
 DiZ01OllPxKnt8d4cJhXmfuIURz6vvcDRxuYsedQe4ns8+CcAl7xfzom83oshqp7Ja36Nqx7X1E
 NocldtEIlx/Xeb1waUhyR91Tg2yVfnsLWdlYaBiIy529/ksoQihkbkepd8QVGAVlP44SnqfVEyn
 HbUx6CUjW4bfMZ4N6flUhVl78JBAHpZ1rn6jNxdGOXhL++NZCwCHZ7q5OhhpDYF0iSdfelnzUsU
 5zjIIg3pCzsznlwpIlqYIoIeVGF22rauK90zWoDPByftW6+t9XFEVCTTGZdihafkl502Cld+4cW
 9Ma20UDTYRBB2WOflt4RgpKuKQSRY31MPpLYp0QmUkrn8cG3Qhf+MPxRXrAmKTPh44k4xSRmNeY
 UIWoy//TjdKKCa/DHvCQ6R8BUC9/xdLut6keDa985ONgQ6y7Jhf+JHrn01215JzBAYXqNYhZlNw
 Q0UNmqycS3rp/nY1u8a+JOzH6rwCIw60HOclnd2vrEvaNKF46a0I9nAO6JfL2D5BbGGW2dqhwCt
 lIO4QxejAs5/blU84QUTM6sWE8ra1z4nUEP/3JR7Ox4CodTj+5LIsx7AsH/jviyD86jq++0GzBh
 l0kMb25Ke5SmJqg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 6ahnp3tpozjf713u513h9nmeu6uhigkz
X-Rspam-User: 
X-Rspamd-Queue-Id: 24F0E180025
X-Rspamd-Server: rspam01
X-HE-Tag: 1772121729-193509
X-HE-Meta: U2FsdGVkX19kBQOhysARK8ks/HndmXGYzK3RyW0fePvcT0S4sy/BBfXKmUx7OkS95ivXQL03ogD7U9ogrzYqOF78SNEXhxy254apUVBtGUftHK+bX8Q1Wqrb8+ccwRqmxJLn/Nbgc5hZrjBfvXencV0b6KRvb4k+MRO5RIJs9q6SCxJZ/vBPKMQTsFzkvtkJWXbMHFRm+zehF7fCcM5G1MA635KheRBr01MHrUmjgsbcFakTO3YBPtUBck7kMS6oUbV1/5eBGq7ycL0W0Ss53pN4qVQ2q+7lD5kHO1i5zeQFC1Da4U/qsX73FPQJ5WLpuCl9MsW3xoKKvkybBkHl7VrXdxnurYJmLve4taGgpyAU98DTsAwVr4mpjrIL0fsmS6j8uRPQopAcQBSlHLz/LpWibYcH9Ope8MXUO9pQYBayNjnWKL6IHD3vBdDUr8lfAw7gcvdeowgZLf9kDxO3e7VC9xo+WvO5HQj6Rm+lQtJdZlrj9n1ehTGmnbmAsgxWtlTrb5+VxFO2Tdl1oprPPsR6I3K/DEW2VJMGT01uLVk8lpxe8NMovknhDBNa9zD+B0OrjkBL/Zyui2+lIfd7h6CToRpZsTjZXbA1ICxHY+QE6hTf2P2psAK9Qu5+TFrQjSRPbAH1Q8upyc4oIKEMZjDHJy8z6t4l0DnWflUziWYqQnKJPQJGhzFWANa7bhJb7y5MJEBCOXzrIP50yDb6xprcHBiboFBo1st12h/H5IQIxB/EJW7/e81dtjDXdcVQ5K/NijhkiiQd+Opd2Bfa1Y/DzMLzdbQr5yDuWl8Dc3VOwvLcmAut68he57ISRgfzE6NZWfHwSo0R8r5DFJLd683JyVDBDY6DvZKa4qzThETfcVmTxpDSEuNEK9D0+ihtH/u0O7DqN5/UfNqWgWa6nd9t1x2d+f+11rpKQQkdbWpoCjD8BB1H1UJLpN+Ga91zjcjUM9P8a7/uPAdTNzy
 Nrvn8tJP
 sJy0FWHBtc1OCzSgJqMebILz8oZ3Br1MrxDrk5QyKQ2IgnK4xb1eAdbFhF+tzx4T1Hf/23qXaXzVo6fCTI4wz3CwIrH4TnJqGinfzcUix5BbHuutEflFiGe66rkeMAQU48hzVvfnkS3vKGVa5B7DIX8zpWjqlO6p6F1Cs5+3ZMDjAQ/oIzytiAQ/pYBMDjRV7BRtYeMebtIYGTDBz6Z1n7mDihzufpCY38sDl2LtyrkIJ1vzxqd8CfaINtxKOmNVztgWPmT+sI4JM4/c3aGNTwj1Y5GsFNTKZ66V3H+yTJTH0pBWbowwYG0PK44VHyJ8MVLrV/qQJ8hrWRh5DF4FKgM4u6gIP+yhjmdmSMIQ8BkNdymxCuPFgODpVDTCSy6dIudGQ44CTpslKipH1CgnZa9j6OXimSzyhVB+f7AmMEJo6kNax2Ohd7iAcQeY3DZ8wXAlxG3r7dAlxktmMQG8U3uMm9yKeudEcHWK03XhHut4T9OFUe09yObnE/a1w1q61pYY6W+2KdpCNh/+5OJ9WUzy8iSZF8Cs4wwxAV3YipLXvX0u1KFVNjp5JfRasFRYMumb1E88a8+CZ1cOgqHkD5Y8pRPpCoysjnHGFf3Smxgxv2K8uTiN0QwgGyV7Hsy1pBPuzRMygLwhTNQM2HXkURiMasftXrorQYBcXbhl2OwbrR42lscrZi/5ckVxNbozn2BiEh17HsjC8P8un7X/TkLWoaIYe9S/Pk/3JARQtTqXDOtNkfcAskynhuf+A84yP1ooE30o6sAX2+UnuU8vX3EE6DYcuimHoHWxbg94GKQ6YejGzqAUHR7h8NXLTHM3k9BVhZTAYtqDep3STxy6mnUtOnUt0UQ0zDMUsQ4s/pT3WyglqcBkzFPx4irJfh41cf9ZoXRacMe48w2Eu2/XvTklZfzT5XZ/ACEFaD0xDSYqd6w6OX1OnJY2xw4LwWvBYuFPnKA+xXX8or3nibBE65gTqQiFn
 fZeo/SCh
 z1SBNUpr0ZwMtex7/ceJzLznGsKE+63pzcgqPjDHToLnyGmBSYk5q9NSypzk2j5lUeK3E6M39EfdkRNARUhAhdNbIJb7RBTcZj4MJHkKzANzLU6fOabQYM8O3bHeZO2qXa2bf82PirnqstY4WE+k68eQNgv0ppy9vIa6DtNA3WnZ3A9QseCNVp0GEfZAOolj70Ds/QXjiiQHPktgjJtN+jXR8bT2UD/p8np7SjWcU2w4JXGnjorqjhfiXLePZi3BF/bFxk/2tig6W8Keqo0V40Y/mekcFGfm4C/UtOD9QRi6frKt+JY+gwDWvBgZEzO2D0aYPVVLsOl3tXII+DgUugHRws4eYIYFxp2AkId6zzMRSqfa6BhqNOQ21uurDU7Mr8cQlRzmyzXKywVE0VZ8fPb+k8yO9FdOSjHLHVjG7FQnzl2fL/1+c/D4Wa5DGuFiTW5WXbNeZZCBRXgoUwyvpFBkQuQRQ01FVMhnn+ERsQT7IfiN8wIp8yaJgCVzVibPGjlm02BmbleRdX67YM5Q6swiDgKEGnQOg2JxHB86eXGCyoFroSVi15bkmgYaOx8DKzObFGv6bjnFXrh7lXBth3piUGgozWUBNViJOyndZ19sbPo4mtDI1WMawRw0X09kfoQRSGeRZxXUJAT4gQLrjOddJrEd/3AA07tIH6ceCSSChPLrKPRV10xDVC/tyJE+QDw6Mf7ey8LS15QTE4XB1qyhG3HR/TmG++C/2j2Ym2oNaaGfhe/23xQtix9ghlHVkToyZ3ITDiAZYqhoGsw1C+5xaw+D1bJwxuxid9JSWpDNFPM1qGgzuMwOdAfHPpACRCNNtBVNz9zTNEB0QwkXJIWy1nVcCy1hodoKBmqpM7WyDUBBigbQ7zl2Qoti1nOen07ZiRDaDTYG0ta5KW1o3X527rtEt7oEisb5/alMl90sK08lLPCRlmn8v1ba9XCUUNFsIvkOkYLWRwDKASUW1x3K5MAg6
 jbW1JucH
 /0UqgBfU2i+6LNoybkMCI3lByGNgPk8jBcoY0LcpgaLsYrBFNGdDsz6P95nHBuYuC1d4UW/3w+yXDeM9CJNh3t7d4axs9GK78JYH0m4g5u3hC35f9ktX6COcGY2uMXKnmUi0jEfu11spj7EhmlTWhGeqb+o0IKsbcpzFX1VfDAFvaEsTP+r+FiGkX39rPtR6mt0Aa1uPom+fR80RlxD61xtpxY+JbhlcMUWG3+WjiM5gD7eA3WtvuYjY/s51Y+XTPnXPKIQwPfLett8mBels+jnDNHDV6GZSTJglGRY2qX9XimnW3WQqS9Fuhv4SVnVCHWqznVisvHEsSmnfsJ58jJFXPp4dF+UAekcPQWNe/XpQnkW3NVW/zpg6Pb5pQYD/XifnIfOJQmKQga8WxeEhsuqTOM6aA5e3oZ+qYhDJswJKRN1LkZC64XNob5xiRdCFM2wmWZt5H0bbzoZ6EJbsHEVH8svhO2Gk1U3rHcRDCjGp5iwspx+UTjnYzIc4gz2FQNV5N0apqsMTB8jbElX999OSMGYKLNtRhxAaMHlSPjDb2kIlM/r9dYyV2Qi+KS4IGqfxcz6l7drlns2j9um5MzFxBQ/UIipvYzTOCBrkpkabgPQn6XqgkhgI98D6+/uqub/zIOUFn20Uf/ck9diigCGy7QCf6Y9EIkxs5CINkg+AlT/Ku6vzAhzmua7/yICgh9emlv/tdekQEGIT1SwTdM9q/qLDSMrKe9ECh9OAdV6u536ZThe7AOznyw2zudYBPAQSI/grzQ5VsZc+WHGHttJZBq5+iGCpwHpe/T+cYo3oCxN+eFNZ/zfl8Og7nBn3R7xQTiqyNl4WdgPtwyUQ25PqaMwI2elt621kryPuZ1U4o3ASv2RD86bX1FXXkTgn1TnmNIwtj4SEgZxIlPE0cggqhe6R0gjV2Fs0Ba0n5nE8BdykGkHUOapun6CTQxLNmJbTBYb5fbD+tfMXnH+MrN+Dhi/3T
 9wXJdfhv
 D408GweDQ7JuQSA+7R4JAgZGhkJbc97Yt4KNogJUHIbzzQpRfL2E3WFo9g/Nmx/NJdB+T3oDKX+YeTjzNZX477428Xxu05SUX5uEnpfoSoGBS2YuYdlM8BEDQs/ndLKfEVXQy8DdHWeoQ1GjsA6TUD5Hb7Ghyfv5k+K5E1HVet1PYMmeArtxqG6SBKtpOicypZzVloHlAEoAhJagHQ6u791tXusLcmTUfLCwZEDzuJCeznzzzrQkun6qGT565R0Gspfnfk42cCYUKZnmf4pv2FoMf+MmBy6M7ZkzFVADB3eCBCHxBWeKyfJ4J0JRpKD51w4Vg1Vpj6R2CRKQYG8UAJqhDkQaegUMICA/wniq9WDSVBl3gbBICOX2cCf3omIwaRpSNRYUlcCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in ecryptfs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ecryptfs/crypto.c | 6 +++---
 fs/ecryptfs/file.c   | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 3b59346d68c594fcd7e27bae87849d3e19eff56e..f25c9a49e251a591695a143f64d1a81c5211ec18 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1313,7 +1313,7 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 		rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_inode);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
-			       "file header region or xattr region, inode %lu\n",
+			       "file header region or xattr region, inode %llu\n",
 				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 			goto out;
@@ -1323,7 +1323,7 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 						ECRYPTFS_DONT_VALIDATE_HEADER_SIZE);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
-			       "file xattr region either, inode %lu\n",
+			       "file xattr region either, inode %llu\n",
 				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 		}
@@ -1335,7 +1335,7 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 			       "crypto metadata only in the extended attribute "
 			       "region, but eCryptfs was mounted without "
 			       "xattr support enabled. eCryptfs will not treat "
-			       "this like an encrypted file, inode %lu\n",
+			       "this like an encrypted file, inode %llu\n",
 				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 		}
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 7929411837cf5b2e98e1d4288791d2e07c44a4eb..49b0fbe0428a2d202434ce4b5fd7d82d2a63cf58 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -253,7 +253,7 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 	if (rc)
 		goto out_put;
 	ecryptfs_printk(KERN_DEBUG, "inode w/ addr = [0x%p], i_ino = "
-			"[0x%.16lx] size: [0x%.16llx]\n", inode, inode->i_ino,
+			"[0x%.16llx] size: [0x%.16llx]\n", inode, inode->i_ino,
 			(unsigned long long)i_size_read(inode));
 	goto out;
 out_put:

-- 
2.53.0


