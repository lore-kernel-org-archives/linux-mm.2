Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0942FD8FD3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59ADD6B0105; Thu, 26 Feb 2026 11:01:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568D26B0107; Thu, 26 Feb 2026 11:01:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433B36B0108; Thu, 26 Feb 2026 11:01:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4926B0105
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:01:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC0F1B7D4D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:01:46 +0000 (UTC)
X-FDA: 84487073412.17.CB50B79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1CB3E120010
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:01:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fmQtGOEw;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SFvmCPDolXRj3RjY0YKmPyz/bA7x4DFhx9OeaSWa5I=;
	b=5YqbcjgMd6WL88Go96QIC5kt3Xy6fKa6thK/DxNtinsR0KSv6aoT4ihzhmQB/bbUNsd5R0
	mAu/JMDIPp8yXB3AY3cX7q7YV3nIJvXHEsJ3Zyo21rG3qGhfTcsdnx+8N48lrNvIH60zQy
	IQLKxv8quymOFScdzIu9o1TratsRn48=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fmQtGOEw;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121705; a=rsa-sha256;
	cv=none;
	b=RxcV5CHyHyLYUjA656GNcrFk2UYc6tN6TqzTE5t6LkEH5M7xJfklSs3QBdbg7WXWk1/qjb
	YRA4+m8q0E5d1IaTBU4o86r95FFFi8wPKpKiy324Eu8oetRidQLWjPVU8FwuUenBpTgUEm
	0TuHlMg5t81ghUFY6qp78QxlLS9LfzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 53EBE61421;
	Thu, 26 Feb 2026 16:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BDEC2BCB1;
	Thu, 26 Feb 2026 16:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121704;
	bh=1MRqDzL9jprz0/RQOV6s2Z3kM0ojj6Lia5YhASQ1sPo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fmQtGOEwOdRppRBYXRr1mDW9nDTIV03WnUMWZwA86n7v3BBErRLf1ipBHfxBQCpfN
	 npa6QMAEFGIawONL62RhmIC4e9cG79Tez+yxhabj/0XTaIQ4MeNOoeasizLgnv65iV
	 dKUZUvZV6n1pzRB6le5fbPQ1dzkyzTVBPhSvdH6e8IvmfemN9qVc7dvFhK/1rAuOnt
	 o39HhCCtX500wjY3xFNE6RMuPyvx2fyqYBdPVr3xZGrnOwmAgwXYFqFnl/K3GuKh83
	 2hj+VusGAu6ow1xrPp7XJB61JnoN2l1R+KSw1TVglaL+df5sllLhRlgQvswEraKTvi
	 HXX6Ak+jD/4lQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:28 -0500
Subject: [PATCH 26/61] coda: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-26-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1295; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=1MRqDzL9jprz0/RQOV6s2Z3kM0ojj6Lia5YhASQ1sPo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0Kj/NflQQj0MhCU8TbqiJ+/onYo6Sj/kvxT
 DVxI7gDeYCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCgAKCRAADmhBGVaC
 FQJUD/0RTZvh5uufz+hzldLldwGlERQkhYeUFzkpm0i/41gmGKPMd8ySOBM7ZsUacw8yMQqCmrV
 on5bZJVI533KhOqLwI+rTStOVJG+cE3SbSOjHQ0i4laBEJ/6yOO48GbLXLo50MnILmRlSoP08kY
 E7LGxUS61iBoMPcYqvB+8p6rIpyIfzqS5gZ5L+h5zWQK8E6n5f0gqpSWkCXBxZqTs23/PLr+w5c
 PcCEpJlE+tXjrUQCgmcTq+3oqeiMEFAfVsyqRjZRicFxPBRdK2aQkzCh+7CZ1Rnmt64FaxRCigk
 ghvczsT0NFn9XaFU0E3aH9ptNBBe8G+hvKMC6E1kv7xNU8DfjxzLY7hl7R/b5hPnbSDuPcTQBqV
 6TcBhzf4M87jMf9cvaTSKGhD7ywXxdaKiHHh7kbx3gcjem7Y7m7DfhemInNG1Br0/6ne5mrJjrP
 6C2lMRwARu3KBgrzx7a0G9A6zcn1xXreRW6lH3HDILorO+NAwJdy8C71zYC9RME2b2O6xLR9kDO
 uXPTY+b30L5ZuiTKlpXwEyLu+QnIPo9+VH1sfMCIP8mnoK34kxbZ9f7EPzffBDDEm/SZLcvcdxY
 SicYkGlIWX2MTjz/tI2A5A1bDIIeWe2cWZKZRReUU77whbgIc4P+VIbDw+iO23YekGm3EJ+SCZk
 wBBNnNGn3PTyLrg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1CB3E120010
X-Stat-Signature: pzibu3mqaxjqzhg5dsitfhfcfpnemw5d
X-HE-Tag: 1772121704-501629
X-HE-Meta: U2FsdGVkX18RCBkeqQ7BUM4r9lbCiZeortan/IZBcx++zobWVGOVN3PiaYRbGy/KXW4QjrvS+tjYhbbbRx8DqKmUkQ7RlQERegr7sgWP4DiDlu2EPetEV79GyQziLtHXnaElELoNRgwxxOW7xbeARdHmtooih6dOX8o+9Aq4P1gbeeCwyrJFHUndVXmlprgXyW0LMeqV9nqUSq+ArZDESsS85xZzXB15FJuNiy23MyMIGBMCq1+i4h63rUjz+8PC1cqh3b4hwIZmmfX93bv/dzwHjiISY8NBM+UV0impDBo2nGokHo+7P8u7Ini9GmbsEA6KKdNYdZ9htzJfetFLjTRVQ9rD0V4IEsw489wClGd4YM2YnK6TM1o5mNpxmZ6ivjges3DIezFw2zmphaiTvENN7qvWb34vLdD5XJXGaw4gQbZMlX34kSKcee4qCqDGXpgMu89WZQ0nl9OYBqHnN+KqN+z8Yne5tEagONyznLsvkW747W9r9OLfnFU1JaZk1d/l0aWoZaucgfOMGulA6r/a2iDsjFOgDF4Xu5jjEc9l4hzTQERIjzMsvTvuahhDpOQK+LxbiCI6K2aW82DDqhQTspv/bWW3PxLaWUTarVQcKyx/6xyv0qRwaT5rb/Tk5ln+7SniKnuATYA7SHQhaxcGH/Vs67h3xKZCw7DNpLrI9M+shsqLV77RhBu4Y/rEhpXCxjXssDv4pMsiUxjh+ewEbGqPyhd3mtePiRmVm9gYh8LLFE0wKVXGD636kGOrB31fbiegcro2QLGArU8LFWdNVg1r6iY6COUecyAvY8GitU7iaMBiL7cdC6dkKZB14NC6l2TqQEPLrbSV7jtanb7EN8DX6RPFm+LEpvczglvoRgiZGU4iwZXNibsNBMwvWAD4wC8AO5AZ+mz4h0rweqkQ2IFwUM4ZFdLC2P8aZhwWN5MFTN/e/zGut/S3szdYFp7DBqAP+bY/YSRZzrb
 9W+3d3hG
 JeK8ngpkYMLqwZ3wPHrQOe329xxTlxg4TesGLTwvaw/hm0CZLpDWXy8sxHawKuDjT6toWQ3Y1a3oK6luJyC/0jAudjl2GVZaJ2WIBQyh6aKJJU+9JIKmh5Sp4wK5KO9v5uhLiVFY+nFgqsco5Uec276tf1SAWmG99tehwFGaLnr1a1nnFS0drOqD+U/EM13+2Q9K+V0oFh3tLs9yxHzhRLy2EvFcIj2FBvUtVGPyXlA3KxursELHJlqZXnibt4w25I9ANGxqZMQpfLLxsStkRRmyBRic5PXkiz0ZZBOfEH0Cyf7LX2W2VNAqpBKUibowrU6ZOE7qzFjkQnkLkJ2r3gYt/JYtd7ZlH+KRfZFFrPwSygsZ18tXB/t19fAufOwupcwpDVyAkA5of+EbzZ4qBURXq8tD/HsK6P/mto8iP2N7625FveOAfPSmaW1IVlazEYHeHMpgnooIvbQUaQhGCfJ6lqBWmZYP3E7/OfYR2sLyp/24uu0fNb7jrLUiFty6BxxAP4dlHPqWqBB2uIX8ENX0ZUeN61N5CAOInqSKreZofTzdTvtWUaYatP6vlKoXJs16/uRC2MbZDqbL5IrrV+cuTwikUM0QR124LHP1+XcHRaB0qIEr/6R0dAkXi4DekbIhZhQ5elgY9yKqEwysW3JEaXlEkp4llFSRg0djzaG5m6M02o8KdJwXRQaicjU6Jw54p4Hd8177AqOvph+q45EkmS2jKAincErxOaIwOPt4NKF8OZenb/Cn0tHYYH0Ij4SSSQGk5slhIX86IhyoL0iT0IZv1leS2/dAS/CFJPlKiGldxHp7qTckHD7L37c3pA9yxhukPVDM66vakfSsHXemL367UZbCwWNhS5Egb4pnfrEf7HpJEhu13qIOK0/iCTatRhAo76fKy6ij4Zz3NRk7/oD46UDX4Q7qtWmRWAqRKblJ+1un9t5cB3I9mO8XNuO0mCDnGik4brU+OSumHTibmtjF+
 YSw8GYx+
 Tsqdu7BDe8xaRsoMRz01hHYMa/zW2BdfBIy3TUEGhEkojwDWQxJlEuZl8kmQ2gYuOCBErtFaPXVIcp0fnQIkbP/GffvDPTpHcnjUXRERBtb9kQB4IQBiERjXQX7PvwragO4cPyXhm0n8Apzvi8dEcYnAryKx2QjLW97zRkej61714Xp+k+RVSH1rmbmgI0dvciWZLc2651WIqS34PLFZELD5Vn7a6x4yDFATaZV9v8f0PeSo2g4kTDY03bIomIZPAKePqYqpvXsxDH1C1LXvAl7anSi+zWuwsCr1joGUoCtWhfXebGgK6M8tIiCfA8w3MLMfcDTTIAGr63ePaFvNdCX3cGMnx9Z6q8BPzdHsqx/IIanbsakGvTrfJBdBJsZd2tPurlts4MDA/0YAo2rNsvVv6j7NHGkyeBj8ZFEw/rlPDEYv+F63fvdQeKWO3PPEveMbydPJVOUPI8vBgV5k9YjJ1Zap894dVnlKWiCpGLs3v76Te4PDU+kEcDIB+jFtvbFO7j7OaUiwAihB/MNh5Du0hj3U4C+rqHoEd4i/4RuU90YIDtLSfR6l2uJUlTI8Mmb8eJ0c608U7L9ZLzdi0zlJUC1cdND2YuXxa5JuavApGzAyfLP40rLOL3sVO0agrZvYKqmyCT1i1Lm8vIotmvmPlleexxnxKXj7GKctxD403Y7RFRf/RYMIb5kdg0MKwPi03iDf2KWAUr8oCz6iyb6gJG80Dc06ty9eQM+o2tCikpX3wRO8wdDv5lMBQPftJSqm9GWMvC2s/vT3PL/QiAdkQbUJLCU54m725S735W0GqN48X/hcZNK5ciPRd5o5Jjllh2bI+MMolTFM3O05Peyq5g9s4jEnrPHRUtTdZmHPPJvDglDjxB90UxLiWtpH7c2KiYVFEcISc4/DMBX0qrBS2mMD6mjt8ZAXszQ9T0z98A6JRKi7G4oOiXrhNdpP3v/6Pw9gBKOubHFG9XGaVluHlXzSN
 eHGSFunD
 FJI8ky2vg2MJmzYDwAEnmzsr5acZZcyVKMN1OuGfbnB34odmhiDbHzmL8zAjFQ2WkoSuTyYTmGZQd9Mcu+mvpsEYDQzrb/EAxutcgefq+MRpS+rVdMoXClaAtcOFsLyFU/qO4ByNmRQozc6JAGC7cVFlvpOdQD1M5ld0liqeP2f1PlXs3iYB3BAlCJc4xWdDuYV+ekmOZ2eeR/KxPTV3cxkNp5yvHQzP6S1OyG/tOmdIhqVWh+HXoBAUgSMHL4AJBp9abI8Zglp4OSfa6iL7q3vqsQdCM8OrRG9xsCMLTdVfv1PdkOXJeZGqhjywnS4yafRGFtGPJShEUec8LfqAKFzC7oKdQJteTxEdteVR5kakSKnWjXfgtWrRInjCmetrrU+7xieI0hV0oyqL+FOeoJ1D38snxFAktKlJaBD2Ggli65wSBovcNVk9fO4rGas8MRe6Q/uC4hOtBsxcATsTwzDBPIDynwaZkAy/GfSNer8kkUJd5QMvYq6tZ9/R0e9psB9X7j32/esfmQiLSle0CEgWTxHvTQa9UqITFDGB8kac58kkSUlVp3PRcqiCuOxMoD2UUvXkCmU+HvPY+DV5bdzbRQcb92fgpQCvmenLor+Hrq3mpno9rQ1lNAQ9gyyNDyoDrrEPu2kuqM02XV2hmKWJdgANSX2UlGlWFD8wFF4W/d34iqpiHL6L+x0H6NFf9mVhQlStLKdKqTehzQFTGESwOaJZsCi7VQaGEGSUIP5MzKU7EReSpffKRF24aR2fWKa0RGtB0r4Tgppmx2H7tJUtgTc62fEH2V+S20ncm5ye7pstOAMjWrQ0h4Y9mg1UZoi1rmtdgzVQQ8pOQPU/PiVVxVj2PlaLk4FPtJFWjkR+2Hs+05FmW5oLWPn/Mpw77T2FKWfH7CXwa5cWEuhiTcK3Mwlva/KdWHDjYETKBGjnJ/FIC6V/d1KbR7AKIzVGTZ8rafSfbUs4tdbSZa7MPo68uc3u0
 TGuYdTpl
 JLTzYLpjMm0FZjhfPMwJBO3FuHBmqc685vIt8jIGIAEzkgcTew1lxPxkQR9npXF3amcrADyjMHnBPpSx1ck3RTgApYsvJcDGX1WY7/3/loA19fAkCLDw1QeXqcmdV7fzpkS1zfc9zCyXEdjkfDBITYdR+xmysCspplXl34adc+PnhSdP1KaGfn84GtAHqGqqBhoWHzshcV01Yfm7Xpo7zhhdR+g1Mk3upEjGXOOtNtM3Vr+9dWW6iN2uqcr/KhqEpYjcEIgJvp3Zi5TtFHiDpL3Y+Bpns35foE6V/V9CguJz29xay0f6CX8eAHE4wf6nJjfOA4XaEmjlzyevdR211jfAPHkNhwkD54pF8wwuLnGWN62z535SR6uaQ7WXADUalJbKm6fH1mjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in coda for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/coda/dir.c   | 2 +-
 fs/coda/inode.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index c64b8cd81568d3a7c0055f139d4b12cfa37399de..cd2f18233da8d00ca2932fedd07c22c4435d5443 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -533,7 +533,7 @@ int coda_revalidate_inode(struct inode *inode)
 		coda_vattr_to_iattr(inode, &attr);
 
 		if ((old_mode & S_IFMT) != (inode->i_mode & S_IFMT)) {
-			pr_warn("inode %ld, fid %s changed type!\n",
+			pr_warn("inode %lld, fid %s changed type!\n",
 				inode->i_ino, coda_f2s(&(cii->c_fid)));
 		}
 
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index ad1654f3adf8a6f4d9322d507264472f1703ffd4..ebfa003ceb8e01befaa7838b9903f892f80b9e8b 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -257,7 +257,7 @@ static int coda_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto error;
 	} 
 
-	pr_info("%s: rootinode is %ld dev %s\n",
+	pr_info("%s: rootinode is %lld dev %s\n",
 		__func__, root->i_ino, root->i_sb->s_id);
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root) {

-- 
2.53.0


