Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF8EFD8FD3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:50:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7D26B016B; Thu, 26 Feb 2026 11:50:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691F26B016C; Thu, 26 Feb 2026 11:50:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55FF66B016D; Thu, 26 Feb 2026 11:50:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40D076B016B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:50:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0B741602D3
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:50:37 +0000 (UTC)
X-FDA: 84487196514.21.2E2AA33
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 165D040006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:50:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qdlbu5M+;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772124636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYOuv3Wk70T6Ktfro7eZgRq5FR8cgwXHcAYF//Gcaxo=;
	b=n0RZGjDAqlEF68YEZsoi8WCliqG0xDAA0JNjz7ip/rGKDE8Vx5nCfm8GRc+PdxGi5x1gPi
	Hg3Ot8eGKCRV4bUBtrxPM4rOVAqKMMiwH2ozO5jzUUotiRZXdgyDHsrtNzKWTSCJZAKypB
	M1uXG1zdQtBUUYQRNj0VRK2LjuBkois=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qdlbu5M+;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772124636; a=rsa-sha256;
	cv=none;
	b=R7y47w0BZvhYTxKLV/uYfElEhU4UqtLgX08MBO7cU+dV3nTUGS6J4xbTouoRbGk1gINfu4
	uqpsMS66I8zmJh36k53/MM6Aj98bY0kiaI5PfF/CvGAXfKrJY2LNTI/SSIVifT7uAHcE7f
	bYhNrAoj4h909SorCT01O8t6dxdL/kE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JYOuv3Wk70T6Ktfro7eZgRq5FR8cgwXHcAYF//Gcaxo=; b=qdlbu5M+P6Pxrph9XhplsceUnf
	By70JOxs9V7ehBqewoNTBtJyp3ozeST6lRBCTS7BcJkjUsXpWVNdIcj+v185wnLwPWCaLhNWzAoqo
	REd7S0IP98IzzAdEUaVcZ927qwAeGdsZABPpeKrkpMjY2T9PFxTUBhlfxm4AheId3dHNsbEbN7e1f
	xrm/+WlKszDxZnFfIixHQGgK1TJd5Pk+YcSrSmRLqE8DIXQoqxHdPhWqnHLTlmz8pOB/CQLVzgL/i
	Z3cJnjjLD5VAtw9cA+rW3ijYHu6xMMZdJvbn/fZNJGFrzBaph/MUmddmRCDoRXXHGr4v4tTcThIId
	1TG5iysg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vveYJ-000000037bs-0hID;
	Thu, 26 Feb 2026 16:49:27 +0000
Date: Thu, 26 Feb 2026 16:49:26 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Steve French <sfrench@samba.org>,
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
	David Sterba <dsterba@suse.com>,
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Dave Kleikamp <shaggy@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Martin Schiller <ms@dev.tdt.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, fsverity@lists.linux.dev,
	linux-mm@kvack.org, netfs@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
	v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
	autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
	codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-hams@vger.kernel.org, linux-x25@vger.kernel.org
Subject: Re: [PATCH 00/61] vfs: change inode->i_ino from unsigned long to u64
Message-ID: <aaB5lgKd8FOIizPg@casper.infradead.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
X-Stat-Signature: 1rmcoxncfcgu41of6a3u6ajmkgq3f7xi
X-Rspam-User: 
X-Rspamd-Queue-Id: 165D040006
X-Rspamd-Server: rspam02
X-HE-Tag: 1772124635-9300
X-HE-Meta: U2FsdGVkX1929t+9/8k8Pf/+8KkKe31gl2KFxO/QEGny99sryBXoxYpfnLQNLO8gX2LMHGXKi9sXWy1zIpzhOMYDa/5TQspeLqSJ2AaobLX8C0Jvz0rWzzcs3a1V1eGmKLZUdnGNa3odqHfs0SBh0075kC4Vmf1Cp//WC+Eqeqpq5SpbzU4gmC3SU9YYWTtj8RdzY5No2rLB2HhEcipNzO66ckNYAL/6hdFZgYBmo8R4kqtx+xkQmlRIi5159haJZEZDQxYm4blpNUVirksnbn5QzivQaQCGkVBMtvS/xyWdMjvHDEiV1hUj3sXKpGy1P5jBXhPK/cjyDCJaxgCItlz2fQlvZvF2GTEZsOFoMuYyIU4LbGqhyUJbUYwpmeAMXg1lfVHOdDESgU2AKRdgHc08FwtyfBVEVf7oe6Aa3SSXLNT7VJUTq6Y6u7/Znc1JGVEnSTM5qBoqSBmWSOI2R/YfFf0W+TBT5vQ03aprK2FLLS7oZ4b1M9i+rRE0a3SPSXt6z5Ky2aMvFMepxAOqfUJFab/CJtM6oAwyQWUtGK3IzC4AGZr5KcDSTzghErqrssMQ3bKr/YwOMkoThwXpxYtMcUA+Fnlfmhft9Vp+qkgZjwQW6tD7h/3tm7hdMZZZ8OFb28MY2YE3RiEftCeYkcvWtLWdNALZnds9tTZxQH1+caEs5iKrzmg6iqlPrzd7NzHf5rCDTWgWCOp1m/eyrnzVSnxkVkZhWplilfwWHqOOB162kl0taUfo6ifuYXsN4EJ7SIf3P4y1X4KPzeWkAX2qZQX8acYGJvgW9m0OWmyBVE/jySXRnQNrbGt04nzOhDvwKyvMRihkQDfpAR1zo2z0zK4b3taMKzyaZGgbbjTiFw3SFUsfeJQYkyjLV63LR/UDPgR2IRbNpd19kbKTOr/bKA8H7WQ6HoKd3uglPgwsF+SKotf3VkekspSOG8P6+4ATIu+kR3mdZmQ/G2h
 w37dkk3f
 32BOmL+zVtNi31C8pVnICgwx5HjGsDqq+GupeNH/gBNve/Hmb9R5+E+FvCwjrk8b13qZ2uUJkWqgfi5SeazhqiNEbdi2fU27i36mwdLWirySb47ceUHmlbFVXdOpfPqs6NPTydr9wHnH8yFEyzWJf95O7oVztpgAcPwhIhbrGSlmhD+GdA7E12DCJTb3lfFbwAo6eMSTJd0fYRwMyTMbOg5eaamKR3onbCyab6tmBTy324Jsl81SLcOjnJgkQU1EEDTqAliX/Tx6oQnzTs9caLmLgTB4X/ArTZraKtbdTZ5uFgF9w1c1RA7cpsQBaDv4h3Xr4ekRQyrz5FFIxbW1jEIVGHddBhAl1h22DCTgWoiM6Gaeoco4Z8KgZl2B/2UPeR4b1yvSZxwaKeWRHrP5aaOuv8ak8BmdPA/q3e049lPOGIjjUZ9x9SiEubOSZTHUG1gBopOTqMU5TpRDvflesAHidVcL4fztquYGUiXAmG5KgtuOQEjC45Jwh3x57/9TVtCCIpGGNyMjqksDBpnuvo3KbeX8je3tUJ2fscN2DltaiZd1HxNev/t14iGnZRNIhso1Z8518RKhl8JPELrWJkzj0Xa6zovt1Lfe3yIWT67Z07mXy2RWMGiJL9cw561JrbiaetgSvYHstwpZ8QGci9PhhSWpQ/w+xv04gi/fDk7CnuaMS4T56l630qWy4ToTA7tisGynFG9gE/cfy3/5v6+tA2dP5szMRyIebMXZmYET2hBaKCdIbfoUNqyx0E16kcYGDKsgcXYkwBNWMPIxXeTnvSQtmizhlbCaSiSIcuYNgvlADiA9bgMcG2PG9qtF428R5r+wsr/0JFckjdai9SaxU9YUQP69V9J5EVoY0gePAh7P+3NVYRCkI8Kn8IG9KfnT+6uL8wah5H8+8D4LOd/bIQGtJw4gY3sFMPB9rBH0wuHNtUXQDbvKmmJt5LU3CzVCh2UWsssFiBePsqkwJjd5G6dXl
 Ts90WCS8
 qqjOdZkNFJZeYqoY/MprjoaoWnFADzB98SHqETjgswhgTeJudFb3rhN9hZEnG35ejUrBJ8OC3jVHyrhiHDfblVMpgB0ON8q1n0zfYWQZVojdJVORjK/qdc7aeSw4+iz0KNaqMRenpuQEwWVk8D3wWrSdGEuQPgJ3HgPB1AIxkz5ZdwCmCO3t6r+JhRyD3o+iPt11Ms3KzDDaR+AT0o6S1JwkuH/Tj6SzGvOXk1sJDSD1RGnoltvng5N5kx3BSWTYnmNjj/I6Puoqxyv5IhxgjLdTPze/UTtA/NnbVpqqJrsXvk0C3XmUZOpzxgA+IS3Ekp0Wg14jyrqUEQ1Cb9cvkEwIRvJWfxT+KnVy0k7/tQU2ApfCRxYYx68WXIojSnByil77VImOJCSl+Zgr5WLbb5tw+8mt2ZYmKlSeHL0wm0R8ZA60SytHyEoKq/TzrgAybNmKLGFz6z745BjvPDmhbouwmAhuQZyv/LKdTnL7dklCqzoFaKKngadvIffv51xe4K2ff/tBCh/O/vHI+RMhSGEu9DWgpbSqVBrdGE8+aC4DDFJ2zmrdrt/JeJQnZ1ZmMyeFl0DFeVlfJDwA8zbMe5m7wzzuv5kNQwWEnLS2nM1Gix7HYOSrDLiv89neTBI3XKV3EMxs5FCTohq2ZtAxSrt8UhQ7b8j6XBaoUpvcQRO+4sv/em2amcSmeK2ku4qta/ii5STpeoY3bGfuQDETTiZb5XwNfOoOOpdIJMcpcQy1ifVBN8lJ1kuSt5FgYRjxoNDfNeVypBRPfMM/7YabTF84Mk0aUsXKddakx7b2FylXtJjdzW2Ta7pZFzmZwbMyPlSFOjSKwy3HKfx7bs525Dbmb3bA6WkRKmUyhVknkzazkdssLPmkjYjRbO25HjmoBtfVQZsf+hk/D6xID1nZGAG8cIdyT/+/9082CJhPopozZmAMqJeKIPzwz+LDbn9fw40hLBW7Wpf8j0ovurgZ9wKbWN+Pb
 w+BQKWu8
 c0SJyB/BFG0PWAqKBFmqkHAI+WvNYnOM0RHeNUIDK5tc/zFCAVWLOvLCXnPKp8RxCcTbKqPi3vSa0dXrtjLSuJc9iwKyDLCsMSFF0BRpmGNQvlPeZpavVU6rLUXV20d0gziDZTDC7oA1Boc4+hCIHf2RC87nPGGiJ2N2oF1zwqlBOH4hNpJbbgNRkrOPrqTDC89MtOfH60ZekKjqandCTIMOzJxyXRNHalLX85biN8J4O6rKGB9nQMZF/Vwdk1jt9WIjboesGWKx/cPIKnzwxQDSEJAhwFOG/5bLuGGwp0mUIY0BpzKXetO/6RsGtUZtt6itjcEp+u+84ZMJyILWES6eHS7GXdzthUzIo77km2t0zuLMej2Yg/ZxtYVxLMA/KjDEt5m6FSv3GLqbavmpYZJP88zFmgsQLaBo0XJWf4BGziWQpglhJW2RiIAZFBdZn8amwIo42OkZQ0p/JSxkA+ULoBGY21n4LYMtvMERWU79aPSDt8soLl4HqM/ucG6tJIfOuJZVDQ7iCPZuRd4fVQUhjsMfgKwQ3yijtm2yG4yRkMNq0yr8k2nGoUX3/P5XO2IvCw/CY3ZQywOEJcEMLBII3QR48DvjzNzx55/0VLWq4ijmnupag116ZxKzNGQ6sq9orvx2pmBzCouYOe3p3uIFDwzGyjwlIDzlOBhQY2pyhQPMCM9NgMK0Utp+cmEpsMtbQqknivg0+1cFd+5oFiQiGFvtTSsTijj7XsmnTHfdJiWivmzmEHHip19OVRr1njnVz3DLk5mBCOv8G1Z9VTwVYtkoApH+Hkswmpot/66YLQ0MSgZJF3dGxjnS9Hglj2g1cwic1jk12ltAxtaX2APQeB7sYKHoENPhe7PaHguoevvo3ijeFYHu6wucKsJiVuInuUyE30/ohw9tClOZfXJYEIw695631MFrxFnAr2KkPAwVP5nEZtXRau6T4aT15bEK7BGhwd789gfG2tV1MoOmXu6CU
 bVdrptZB
 412NbZxSB070bNquK6s3eVEXn+22SMp1mi3y7KH9PQ/33K0hTgjXl1Ffj0TEd9GasHciqGq/qsgLN0iDcpy46mwObyQJEcskt3hxEYjNwQnh79mnbjL5OC0259GofL4n4B2wL/R2mzMR4gqIKyWVxVv0Tq3oIKTJMoXUpHqVdgDNTHeon6vGVd5aiJQg57JhdJmOlns5vOiMS0xgfORwlzczG0ID9stcASpstfmM/aw/2YZOfaXQ/I8PTufa4GC4H6+gVCDVSVQVXDkrwrWjox7/mZi0cctcmA7uZSZRHz+38FE5japC1MzKHf06HQpXLlL4rnZiyTfM5Oqk6KFct7FzCDrq3VD8oZAASAp22nNdV1I7BlbYKi8qonCK3AB/YL68YbQ+lQsjde7nacGWHx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 10:55:02AM -0500, Jeff Layton wrote:
> The bulk of the changes are to format strings and tracepoints, since the
> kernel itself doesn't care that much about the i_ino field. The first
> patch changes some vfs function arguments, so check that one out
> carefully.

Why are the format strings all done as separate patches?  Don't we get
bisection hazards by splitting it apart this way?

