Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06BE9EC1429
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC716B00E4; Tue,  3 Mar 2026 05:59:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AA4D6B0168; Tue,  3 Mar 2026 05:59:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57ECF6B016A; Tue,  3 Mar 2026 05:59:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 442D16B00E4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:59:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E7FB81A042E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:59:31 +0000 (UTC)
X-FDA: 84504455742.18.94B102A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 77F0240003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:59:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jlrTi3dG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="buw/z/im";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jlrTi3dG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="buw/z/im";
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772535569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Ax2U3KSgQjtDsUZU4K+0IOeH3oN3CBmHmXatVIwbT4=;
	b=CjU587Mx8PJeFxhOKDIRuFRzVjtRofAs8QcA9VAC9Gh01L7KafzQNKJ85WoNWsh+vmT/+O
	HVrcUYaB0YW35JV7miK1uQsFsBQxUcWvGwH7hhfILPxU2LNbSDLFFPwT49musFeVgZQ1XW
	3zVLJzLcymRUO/LFXbdPMkqVpLqki/I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jlrTi3dG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="buw/z/im";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jlrTi3dG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="buw/z/im";
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772535569; a=rsa-sha256;
	cv=none;
	b=SWN55iSQ8r6K3fhnORWf2ujgK+SpkEx+auMfnJdlEEAxubAX3qqnnW/mg1/u3G63F9ErxF
	edoyWVbF1yEwYdjhvkPtQ5tYBH9ElInwFL5SYc2eAVnEwq3x+qTr8Q1ANBTNfahG/L18I4
	NOvwRtz5dANsWqFU/9LRiQgDO+6iLNg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE5A33F86E;
	Tue,  3 Mar 2026 10:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772535567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Ax2U3KSgQjtDsUZU4K+0IOeH3oN3CBmHmXatVIwbT4=;
	b=jlrTi3dGzi6tF685duuqaLJ6WZU3anD5qv56Ez+rz+JN3YyW16+umpZndND/z+6evwwU+v
	iV25kK98omMc+huAfdqvXof0fqmeprAS4F1QpWbWNPJjG/yoLSz9Il+psHcNJjmdULsl6v
	xxuKQyO7oM/GXdvEiCwSQ6AIQOt+gqs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772535567;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Ax2U3KSgQjtDsUZU4K+0IOeH3oN3CBmHmXatVIwbT4=;
	b=buw/z/imK6nKUxnqweYn7ZS+SUxT409/8UUPNuUvWQ8Mi6gHe2zTcjBSW2AlIHTW0Q2xsS
	nV0AecnyWGTC1JDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772535567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Ax2U3KSgQjtDsUZU4K+0IOeH3oN3CBmHmXatVIwbT4=;
	b=jlrTi3dGzi6tF685duuqaLJ6WZU3anD5qv56Ez+rz+JN3YyW16+umpZndND/z+6evwwU+v
	iV25kK98omMc+huAfdqvXof0fqmeprAS4F1QpWbWNPJjG/yoLSz9Il+psHcNJjmdULsl6v
	xxuKQyO7oM/GXdvEiCwSQ6AIQOt+gqs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772535567;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Ax2U3KSgQjtDsUZU4K+0IOeH3oN3CBmHmXatVIwbT4=;
	b=buw/z/imK6nKUxnqweYn7ZS+SUxT409/8UUPNuUvWQ8Mi6gHe2zTcjBSW2AlIHTW0Q2xsS
	nV0AecnyWGTC1JDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F8263EA6E;
	Tue,  3 Mar 2026 10:59:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Bu3/IQ+/pmlwLwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:59:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3AE3FA0A1B; Tue,  3 Mar 2026 11:59:27 +0100 (CET)
Date: Tue, 3 Mar 2026 11:59:27 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.org>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jan Kara <jack@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Steve French <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Alexander Aring <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, 
	Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse <dwmw2@infradead.org>, 
	Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Anders Larsen <al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, 
	Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, 
	Johan Hedberg <johan.hedberg@gmail.com>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Oliver Hartkopp <socketcan@hartkopp.net>, Marc Kleine-Budde <mkl@pengutronix.de>, 
	David Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Remi Denis-Courmont <courmisch@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Xin Long <lucien.xin@gmail.com>, Magnus Karlsson <magnus.karlsson@intel.com>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, fsverity@lists.linux.dev, linux-mm@kvack.org, 
	netfs@lists.linux.dev, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-afs@lists.infradead.org, autofs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org, audit@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
	linux-can@vger.kernel.org, linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 002/110] vfs: widen inode hash/lookup functions to u64
Message-ID: <o5ksne7mgzpbnevfepfgugnmniimpalg2z67qjnnfhhu5kd7fz@zeif2ihe6jws>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-2-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-2-e5388800dae0@kernel.org>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 77F0240003
X-Stat-Signature: gw8tjpfyxfsome76mmskzooowmm64yz6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772535569-898590
X-HE-Meta: U2FsdGVkX18/96Gbh4H2QsSoCXwwRcYcYZDB4wuyzGsr74jSmOkE4HjgmRoWSWaHWkOtVx+bsRCobdGvd1CReOX4IF9u38fDjOWbR6Vz1RwAOHUAy3/tGhS9I0ejP7A2lRL9hATCWfvOlxXveiyJjyC43ZJD6pTWGQF82HfJmhK4fIF5Q8itJ2DpyeHDcBS/DGcpDLX7VR3MzbmJ4t5CvkWY9zd5brnFZ479w3gzXTl+CqLxdBs2vhxGVdJQxsudQeZVqwLaYVEJqJnzWbYliiWpbAOgs2eDBE2Az8D3UO25TbWj1BpgABxdGcSEC9+UvqWUE+xtZByISWrSddos6gbofU5UNCRE7z1xhKC1/tuFIi+9KYbMJN0VNpbtEcul2HXR4iPP3jP0Iv8FmiSWCjuyExa/AG6RBVKpxdgScXJanTwZUruKvsYtKHsPDHpxxaJbU8JaqRjhPppuzfNh5GNk+0hrCw/V17o/XjdHMdFJiWvhoTYkF8XFzYMvPRFtZac0vaOs2neujK9/I0Bct2NP9NWo9Rg1DpKZBXrEBBtpjfGYfh3ZecPrrQ475cT5uQwiPqUrbEwWhk2bN+dd3QxiFoeF88MNcbyck/sLmETUpjaRWvsJuZaBJexHeWdLg19BRLSdCgEYLOZdvxnpTN8XZg6MMMTeHwhLlowEOqInTxR9aem2bTiei7cs6np5Bt5WmS6fAS6OMAPk4K+12Q2KrpjeR8L3tLYDmZTgDu5wwwKVHPjtKNAo5wt1ydX6pUkUWNmkpzBOGDgxxXmUs1CPYPH8CgXKqHE8Z5VQjXEJdAmkhKExEE73PNQCFWyrxXzixC0f3bY/1GY+JftMQ6jmIeqfAzpS7+kwpnLQySRjdTijauCSRksv8WCjv0amgfvgzcgterLsInIfYplgtEhjPtFePrt1mWzGQkpumX+06WNAd8Ss/jAQ+ZGWkH4cfLRQ77UAfMFa04L6enY
 haW/uO0C
 AHzyVgZFNKv5JweAliqakK/PnWKE2avFQblWQtd8nIURurbjdr9lal5hYmZm9DbmdGGrx5GuFiPQIMClm4Akvjjvxfv2Ljb35jBCvtes0DM/ACr++uVTVYaySKEg4ecy0RUWsLXFJNDCf2JhurcNk+QbPjdr7OU5PdF/kP04HE7o6h+HSOA1l12IvLQtw8rIpGkhCA6REuVPIo4FlfH7MzpqkG10FRJra7Bpobct75wZVcTbnxG+8wa2QKqgRzC8boDUOhuQnlexaHbnjT3jxQQIuotpjxzXB/ZE1V4yrKvBccCQQX74WN0RHuR4qm0BJSr1ldR8HypSSV6b4LgeGST+DF3rAcnPD1hgpYtjcLOlnDn+EIfG9Ab7Arc/gUeOi5lR0/8b/SJo/euHws27s5tUbIxEY8pJSMshyrIOd6QTq6ITYgiMc80pcUThmv7kdhVYxOnNCENPwT/vX3sRCrBCQcHa1LrkQ4oPxY+EdOmSlWt+pGvovB1C2KT4KXcX5wBV/t2BVDCmknOu6HHC/Jck7v5wF1aW9SPrCdYXrNsRvKUpH/RcFB06zDrPyq8bk9w11jVo/Z/d2UWg9DzQfEq+DcGRgg7nz7Y7plP2d+v2uiglebsZ75Ik0X2so0rBB0ea1hQAypKEVI95VJjW5LLwkmsh3WrTUdsGfTGjxIru5FQ6JMlr3f/AKvPPTuJZ8Du1d1jXQzJEwflUqPlAm8bxgonAnRbiL7zmunI/86AwNeK7ZF3ujoc5OQ0x39/xwQHBnRIA+2qvvq6mxty11oGEC94n0CStREa8RKX/4mhwQm6pEUboKzHNFC5eWPc+z2sOAbgWbd9tUYyQh3vDekEhlAv1PxkXSaOfbbEWAMTTN0bkYWyy0bo0Vc4561Ikk6/thXLGVf4gN38IElrobU3TB3wZ02JusAg/rv/wPFaP/X6y10vMtEa5NUNTzGaRFNnLd3B1ZBY7eE9nHc70sFyhe1MkH
 fiCaDZ+Y
 7e+Ol9TxdkyZ8YQDS6hCHz6+2Ia2nOLSHxcz+j+3Hj6RuOuIjMYJHod5S37VNBcflKRnnj4w6yaGgx/nwDyod9JRJmFtJ73zYHq2DwjfgG291D3Fi5CtQiijCyTzgPM7pqi1COwBzZFAdF3+7FL0O/lw8PU3jfpXXSonp/4SNx8qqva3TE99BBAtcfPm3gss3qydmDkhWIzIkEuUPObV8GUrZvx/w/Pl6kj+jD9AoH9NbiYvya+CXpLW0vfQi0yzt6ZXnwXaklHTkKSDU05HRBmPjJ6Uxosx3DNqvZsBjR/ZXUFxco8um5llh8o5EHgKvnbqX7tLpMBOrnEcEifzVSEBFMnQybDSw5zeDuJLWfSOK46+O7FykinhHBvpBCza6MBHA6eJTxb61K7am6NlcV2Xg9QvdqlDqRN+epRwtTO+2nlNGeZwANFBvoCPUbdBSFGtKf7U0vJO96JgIRyj8fV+nBODp9Uy5YCUTW3VOMrIEDg3u5rNHvFo553/9Zna4cplNg74/1zIp0EOgYv1zE1vULkOkKb1Lzs3lZBstf/hp656y/XOQzi2I/fyAjq1Nkk6laGemO8cpoSDCFkvflTKzwpbyxquWkpl3De76zjgerhSFXbldzi41W00s9KObjDpFmgZxF9yKgnm9LDMDf/aae9+hTA09l5U7tfCeKSF5BPZU8B2xvve0iOaBFGuRB8vYqA1f7jRBnxxeVvhuuYK4+skAZW3OeyZQTDDDTvCMB728hcfxh5VaORkmGQ/2sY6agb0dhyun3nvrD2lgifC0te1n97baaXOl0W8HkME09Hix2FlVBYvmyUO35iOGTw6arezxWQnW8YLbtpyDyxGChMRXHJxMJ1feLTN5cDoHMyVHyHFY5gxK28QZ9LpUN2amodAGgLvRoUz9Rkv60pWgay2wlgeI27J5El6hRr5coEQZOM221hhtaK4fQcLPDdL6aJoU0TmweXsKvczueJsGunos
 Skdxa6aJ
 bP4lgol+tXLBF2CIIdQOBkdyhJlFcFUbMzQyvKTi1/YUh28Ccxn9X3ienlFTJnx+xqpa0xv8/A5kg4TzPmlMrxeuPeVNtFvjPwpFAKvj6jq/qEVCpofn5W56oFJ9fFMtezuVyYcMFy/+hId3WapsxakcekNghFH7utbAmIpjHpH4WDC7dXStmhGALB24oXcs3i81z37V3H7pLJseFedgR4EqaGhXSmsSas1zNKXw6f1fESqmA3Sq/89YP6dj8YgtnqawNeTyU0rZR8P8gZllppNy8cUP++bMMVoxp73Fk95NzsKyG2HnYexqpEcCVfB67Wyt2j3MKv5STRQpsnUKOExaDYHR9lARXkxzSVMhasotI+Avlkkb+fECZ4k6ROiJahfMw9J10jL20cOVW1DENWUcIjNXoKyOSA+2HwgXVDkLPfvkQWWwSHfEh9tp0z2q5iMdQt/O2Uzc9adRt+AbGfVWnruZdqPXKwE/0dvm1Plf1bFL+aC1R8vQWImoWyqsRutM6DkfNVuCfou1cBuPnUgzSdYredUoV+RlzgirzeK4EhfhGNVeR35FwrbwqFoCrxx2Q/EC8fmvX9Z6a4cWpcdGVtmCVt7r5/ygGE49U7lKc/xuZKAzr5aVI9aq6CCa07dsdLKhXKj9Pf2pmtFtObBplpbY80AqIiUIiI521Y7qu21mHgWLy7gsrXVXEqFMdg5CLTKIRIpdxMbGisebmChQkRXx9Hjlkbv++vBD0s93WvcFuWxRPPpYOajKpN0VdD5RVsb9AiPRYaIawAyJdtJyx7G5HcGrSGfPLU7qGNjx/mOB1pct8/oKzSlshcLM2Z4X8XMzchkphA+P0RO5A+IsiBdaNV8J697P0h/ORK1IUG1gss48Jq0EQ4ajX5bW67KteA0xfnoC9HXWmpoUFQOYCNFIrj1JsnGnYZcM17izJlsNvWSmoxlp1efYbnB9SpYALSyLB+I2Y+MbcVjBKYjek8m1V
 2pTxNvjL
 iW3lvu5MYpIOuRaHXn1/XpxeO0vlVq50q/23P0SftYHoi4hpPSYs8hVmQmeRInEaHPTecEZKbCE7tzogfQN1DlYMt2jlvIXAk1/mxGofyMqQAC53z4ky31EEqxcNF0CT8PhJ6qO0kVFhSBO7ZXUfPSWCYvvFvKk54u18V9ER4l0OJO4oGB0O9DiLAporHF5O+2ETNgUcSjrtXXMaP4F1mF9UY5wxKxtZNcOpmoAMgLNTMRhIhRiFa26gnRF7mfQD8k2KduDsFtoMY/UEkQIHQ0CbRbpxa720p4hN+r+S3IK6nrNtT7Wcb2qQdeK3bOGOq3pO0CvNy4NC9Kljc9Hn9gXh8wbeZmtX7j5OznfqrstIEMYGJFDtgPPx9iyZP3b+lfDXe0kPtUKytaZ8WlPd293CRTbWuI9/dO1EOlvc4WBbTIdhB8yFESAsIzftP4gqa5pnqdkDaTkl7KOA1Ht1FN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:23:46, Jeff Layton wrote:
> Change the inode hash/lookup VFS API functions to accept u64 parameters
> instead of unsigned long for inode numbers and hash values. This is
> preparation for widening i_ino itself to u64, which will allow
> filesystems to store full 64-bit inode numbers on 32-bit architectures.
> 
> Since unsigned long implicitly widens to u64 on all architectures, this
> change is backward-compatible with all existing callers.
> 
> In dump_mapping(), change the local ino variable to kino_t and use the
> PRIino format macro, since this variable holds an i_ino value. In
> init_special_inode(), also switch to PRIino.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

