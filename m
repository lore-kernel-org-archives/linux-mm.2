Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C9AFEC1431
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7E066B0180; Tue,  3 Mar 2026 06:25:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48546B0181; Tue,  3 Mar 2026 06:25:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9A56B0182; Tue,  3 Mar 2026 06:25:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B97A16B0180
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:25:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D09E1A0108
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:25:06 +0000 (UTC)
X-FDA: 84504520212.09.67E561E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0F0BB1C000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:25:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cp2wGG3b;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FY1dH1mO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cp2wGG3b;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FY1dH1mO;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YxnSO6wYqIgHlG99vcTIcGeXP4duMd7Ux36r4Q1ofk=;
	b=CbsWQZFroQKXOF+JV+vRtxTlWQVYj4of/F/rXBJvg3vODMF7E6rpAPZY4VPoZelcCATLs/
	ncRG8fi3N8OQFaLpJD16PPGRlyHDOFmvHTnQ4hyDZniD+36nCDzE2q27COKWascr7UgHhV
	4YDArVuzPQyuYnpL4EwqWbQVGeim4Ms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537104; a=rsa-sha256;
	cv=none;
	b=C7uRL1KZS+BSn8pepe1tyu7ahDPnL3loZO5bW8cvk7R/gbGQmchH49PAXgLrJIK8LzLV3y
	lo+uXxo74YKonJncBt2ziA7lr9GtuykU+RXQWKbUAdCd5vkaqJAVBOj6Fsvgwx0ML7zPFp
	OOecsHprAYoTEcaYGKp6kxSX4gg0158=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cp2wGG3b;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FY1dH1mO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cp2wGG3b;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FY1dH1mO;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8B2E85BD15;
	Tue,  3 Mar 2026 11:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3YxnSO6wYqIgHlG99vcTIcGeXP4duMd7Ux36r4Q1ofk=;
	b=cp2wGG3bRJKiUYN68nRpyBn77MC8reO7VI0NDbMUH6Gavvlj+c5tRTwOFIqiPnWjX0Qwjw
	RW+zrIQPbA+KbSu++nhAT81fG5esOebAI7zXOMKcR/GP/zZkW7LEAhJ3bGMOz6iqfFeDkU
	p6Dj8reQ+EQ+Mps44OzpOJ4Th4tYT6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537102;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3YxnSO6wYqIgHlG99vcTIcGeXP4duMd7Ux36r4Q1ofk=;
	b=FY1dH1mOn/Pqm+1fJQmhvM5A1inXBqPa+uljfNfdnSMdwhQWodNFFBHl9VOeyBBhRfZvet
	42ntbDXFRTWgP0AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3YxnSO6wYqIgHlG99vcTIcGeXP4duMd7Ux36r4Q1ofk=;
	b=cp2wGG3bRJKiUYN68nRpyBn77MC8reO7VI0NDbMUH6Gavvlj+c5tRTwOFIqiPnWjX0Qwjw
	RW+zrIQPbA+KbSu++nhAT81fG5esOebAI7zXOMKcR/GP/zZkW7LEAhJ3bGMOz6iqfFeDkU
	p6Dj8reQ+EQ+Mps44OzpOJ4Th4tYT6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537102;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3YxnSO6wYqIgHlG99vcTIcGeXP4duMd7Ux36r4Q1ofk=;
	b=FY1dH1mOn/Pqm+1fJQmhvM5A1inXBqPa+uljfNfdnSMdwhQWodNFFBHl9VOeyBBhRfZvet
	42ntbDXFRTWgP0AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 774733EA69;
	Tue,  3 Mar 2026 11:25:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uhYOHQ7FpmkbSwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:25:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3474FA0A1B; Tue,  3 Mar 2026 12:25:02 +0100 (CET)
Date: Tue, 3 Mar 2026 12:25:02 +0100
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
Subject: Re: [PATCH v2 037/110] minix: use PRIino format for i_ino
Message-ID: <kywopfbqsllo7hy75okmrpljpjppknqbqk26hl4lp7vzspif6w@vs2n3nni4vda>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-37-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-37-e5388800dae0@kernel.org>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0F0BB1C000A
X-Stat-Signature: m5te3x5zckcch46xnqmkso6qwq96ekfw
X-Rspam-User: 
X-HE-Tag: 1772537103-743751
X-HE-Meta: U2FsdGVkX1/pGssOupKGG1K6icwC5P8ERBFQkgAugsA3su3WnHG+qADgqrzIZ/llbTOMZwFuif0gojF+78FeW4b/O0QaTzb7ar+9PwTmVJlhnPW1GI1xMkQfHCwqIbSh03KKnQH0stotij7ldHR3B293+fb2McI6R3ldxw0RF/B4R2Nq5xyf7r1wMPAFVWT969SJf5OVguSZtQ6pKVAKyk6Nwzh5jZHglRZ0jZjrcrWsDdzzgpBFZIFXOkzTUL7gw8hPQ2yfkfwXUdZ5h+q2jbyrBqOLJyzQkxEvgyP56DEoO6F5c1MFGaDx/S355ktnHo/GNHe/bYByzbPctwow/anPl6kAUppDQbXCxSoOTKN1soH/RyrdcNz1d8F9jIcxPJ42GLC7aMftoB+bhUSnz6m4NS907GmljKKDmyuGYGqqVakcSfI1AdPcmmw1jbEx+V+Z/DEysr8L67LqUtymZuzC8Cm85L9+chdev5A/OB9hf+TYSM7IKLfruAY4fT9FFaUokS4cUDBU181P75KGzhWyk5j7UiUfyFkObbom/7IcKW8NkHXDKeDvOvH63c1QZ/5UEd737mhWchVUysMCYPe2H/QRHeVsJq4CCtCrgjAiIZvlhs1DwHEeizU9/AlZXtnZkFa8suRm+Xfx892SZLxyOX64pxzytW+t6ZSS8nXaMLe6/BwYBJV7Fa2U7Em6qqf7UtZ3dZmLqBfdgy85wgd+nNTBWw5K76rw+vZAy+q1nS3Wdxn9THBYM6VjelD3DpeTly0tnrMTcMK6RP4dyj+6W8mDTQVxfgIfJxPt2PNgxeg9zMgkEqMbvLa6kszACMxuj8HddVWJY53ospaab44Meint0kJPdF4HJ/2rwN28ZtddWdRc2nV+HLG1i8fv/aToU+TPZoNpqn2zzMgWpHatbR94F8Y9cmlwBgleFhCaKIqP1Kb6O0etkGh/zmldcdIa4pXlmJqk2W9DwhX
 qETcJMef
 61fqwteUxjwOmXtz0fygXRtbWvRrNvkQ/siCXGvc0CNCQv0WDW/A2cXSH+YOe78JAe6scLShsqkhytg/W+8nbZGXXRDiBksWh1rNPCY7s1UOu7kPWSwHDbzoqslIVo/prr2s6Q/aHcPsitlj5U0lix5zmmSl6ASTQm6O+m5gF5BQy5EpPNSCp0LkAbSUXiJY5OwcY62USsxebPQj1Oc2t1mIdc4XSrYgEjbKzgHSjV5i7+/JyaO21By5pzl+unvqN7pljvRdFLdq8h33M6Ww6eC8W12R9mDNjE++e1mXp8sxkHvdENzN+J3iIIpu+myzVCJBQQ19pFEwjLPxD3YNTB4bQD53gZBMmpyxwnYlsDLKcK9Rk2Xwht82argdyW4bs/QCoZfR33BgAxcl5809F2ugZIL7aWPuw/LEndlRaEg+Pm43gDFlqGTTBOnriSduJPNKmtjW51Rge32jIdc3UaKgoPy0ak+bNP5KjIFzSekSLHdiA7yEFV1mPaqZ5+zOMZxiNA2C4ilMDAoYuNej7AGq+L03nR0GDT27Tzu/n238V+cji0PHAaQZmQZ3nCJM2qc2rYtjO3l5jJ0WTJZKm7GhH6tcG5ufCuRoJ44v0juJApNkzYGycqf8NJbr9ynpY7aC+yGwkTPtrqaC14nHMxBc5XASdX6d5SHR6BnJDkJoEROEp3mMEufDT18zKNgqauj8UPN5Rk5Z/zzOY2Ui7u9WZUudiD32h4s9A8Gg8HCjROpUkj4xNgNouys/WbeU0YL7ZxJ5bTaGAvewrcVi5if9Q90Pg0aNN58m+n8YAtQxc/+ItG9ultQWFkh545D/AotDep0C2Uf+gdctZBKRRRknVuD2hdGt/Ntu0qwSfLb674SWK4md1BgLQ3g77U0Zj716AK+gFV8uQ4Ne3sp/SdTnN+RsRR1Hhta0riJ4FRVYAuVyEOWhitFauG1cA0pHRWUUddjMRmvoJP1jAbOJ9z/rp8wdU
 k1E/4TWa
 EsHAJjCY9k10hiXhhyYdzYgwrPw0lcVpJ9BnWma5evr9MNbed5xEU+lB1RnsGlXxMzQzRRThLU1Ka8xlMBe8J8XHFz9fdMXC1mNymZXTMNHe9P6LBIq1buKro2juRObn1icRVVWUGUBadruVmNC8HOWHjnIzQwtrlI1RZ+45NnupccHm8u1pQVmuEungxrHluo1VDYQTBR7ZWTG3UrzXc1VrlnvY2dsw2kVk4me0Cjp3CVVDHJXYtyxFetMI+Cl/85mQDZensIw7ps64wN9ORU017QZDPZ5Qg27kbpqWBYWUOSkMsUM2WclKgEJo44RRV+ZfsPkqGQpEuWTcMvhKpvD/vq2f1wgXZ3Vr4i0FBzapUAaxEJScM4sssB9qO5n2CQoBGcVueG2e9LwfN+ZfJbKUZbPamduXL1UcGqQ5gZ+jOdh0jgxk55MpChmI5OMxD645SlRETyXAqPbsg7wr5KOxH3xH0k2btHuS30/mess/4CJ/+FRlrPPCvUaD51BqK+DzwvYrksIlQAs4QdFPfgFiAJphtGO67bfMw+pUx4W4rAvdXzhVTVVibUT9ta58FCbBpFE+1Q1cCS6ThuSycCAs7XdaPauVIFJZzMCM1TmTY4UZO/YVHfMnpn49t3yVLK9HS4++kygOwHTwDH1z09Ub0McRf5OdBsP3fOYUBqm9mjAsdBAgjswUQyqbRE2U6lrTbMexe7cFTqC1OQK1Pb1dzj8D2a7TO7cCMPfzpnKN7uq+f/1ZF5Jl4Z1vUra13mIenaXJaiSVamLzkLIeMeGr1fxlda4uSfuG+ugnLJ4qyU0TUwCenMr9cICNGOq3vj1UC6KWvozoK9/MwM7EQnk5ngWE077c3tqMPXMbUufFgLrtutOAaiYOsyKa9xCrkDnOVbTMaAc4giKDQauZgYV/FxT6qgh4zY8UOm2FIlUAcseMqBK0LEfjNpOSXejxtU7JnMt9hmrDx6T9L63PreHMAT8kU
 uBg9zwa0
 9wTQ6HUzNXxjq3FsKCVv3xJDjyatUMPRcLPICjeQ/TnasmDl8RTJ7PX0sR9WOStZ2eUwb7jJEqIlf4AtJku48mtgaPwqLivyIFLGDKDmGIvKWujZHggeg7sG382Nws85sv+J8ZcFBjYK0rqSM17+gser+bFUH2bTu3ZJrJknrGlUG6wzCs9c/IWz7jq0oAShIsriON36+I0ilAwwJ8mfrc1xl5q/ewDfUIux/+FPxiPHLhKNBgqaPHTus8iR/+Mu8oCxPZ5T2tfbwVS9vVPdZHYikDLEflb4LaL6o+Oh/gTxKPw+1ijSxEB4V7pLxoBmv5WJnggZWlbHUT6vOtMVboQVj0rrg3mteE4vl7rpgEnCjxNgPjJK6hc7gfMYemRgYG7Kg2m93NEAXk6cOO4RXcYken+Gp+61YAQcZrU9FL07k103qHEVs2Toa3T69P89tClQOpmYusWHycBxbNT7wXqx0sbe+oZHAc5atoHf8ohM0y8VRmN2ckdnTTiAgaKb4tXD//OkuW7l/v9QPnNJjaQuH5nxNeBkMI8z4cEJdsaJzGnAs9NDm7y92LxlWRDaSIHSnwwU+TMK5kMhHBZKHk52jBCusasoDFSe6+ASQuiTaczbdPjwrnoRTl+GEJgiNpc6gAKL323eu4Hixtq22NnnnZdymax1bgvG8c4Wem3lGT6378Ohy+014zky9XjciB8YeMWCRkrfmMK3IAxGl9CRt0BAxRlw2W+gsvBzG/pLI4aq6g9H0PfN+kTGaDuMO00JZ4Xq/6pEkU/lwWxV1upi1JVWs7g7UVlJGAlyD1AFYu3YKJ7JwmHl/TDOfty/Ef70xZmEPOxGumD2GfYmGwy447nSGGAuAYyezeBmJX4P575FKl0JCDduBvrwr+fIRDKx7WgGC1IqI3XM/DYwC0EcCRYYdwVp20UQBkfux4BwC3QptBIG8ZFzcwLwfN7W/D/+ZSjH97PURTnbm35BuZnAvWQ7x
 L3nBTyCP
 5+on2qU0Bot6O9SuHW0slosubttj4PqJshmPF0QyRx/B+Jbgq4Or8Y3oSj3uDWZ1/QSJQS/TRXBLuX1k55Ev8pJkHISZ4CvMnt+AA8LCdofV0f9XmVlIa54PjxMdPXBJO/+Hrou5JdAoddx4CG0vcs5M0WRpyXrHZGoDvZkS7QBOx4iM1VyQ00eAZxOkEM+t//GHnZ3X25zngs+YQKh0NEmwFD4qhmeXvbumpST6NR5rIQqtwItIEsA6iHzk9+j5zUvwMOmbEbXQYGTG1V9tWqeFzArzQqBGagOqBoqKyPQwMPFNwkEt+JYvtttCgOtI4vuknmB5Aya357yn8/F0Fgreg/bNXKgBngml1hnm25tVVUAW88DsTGin6DyEWzTNDM1ZyM5Flq4GZ49BzKK/6ileChIs7uTxT+Chbhn5kT+CwFoPOOjGdZvaUtjcMXDliHZYV8yb4qerIOt7ruObTX7j/jdMB4/O4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:24:21, Jeff Layton wrote:
> Convert minix i_ino format strings to use the PRIino format
> macro in preparation for the widening of i_ino via kino_t.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/minix/inode.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/minix/inode.c b/fs/minix/inode.c
> index 99541c6a5bbf13f3be27474a316b31d8db9fbce0..d92059227d273564c86f100dea3366be4509090b 100644
> --- a/fs/minix/inode.c
> +++ b/fs/minix/inode.c
> @@ -36,7 +36,7 @@ void __minix_error_inode(struct inode *inode, const char *function,
>  	vaf.fmt = fmt;
>  	vaf.va = &args;
>  	printk(KERN_CRIT "minix-fs error (device %s): %s:%d: "
> -	       "inode #%lu: comm %s: %pV\n",
> +	       "inode #%" PRIino "u: comm %s: %pV\n",
>  	       inode->i_sb->s_id, function, line, inode->i_ino,
>  	       current->comm, &vaf);
>  	va_end(args);
> @@ -520,7 +520,7 @@ void minix_set_inode(struct inode *inode, dev_t rdev)
>  		   S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
>  		init_special_inode(inode, inode->i_mode, rdev);
>  	} else {
> -		printk(KERN_DEBUG "MINIX-fs: Invalid file type 0%04o for inode %lu.\n",
> +		printk(KERN_DEBUG "MINIX-fs: Invalid file type 0%04o for inode %" PRIino "u.\n",
>  		       inode->i_mode, inode->i_ino);
>  		make_bad_inode(inode);
>  	}
> @@ -542,7 +542,7 @@ static struct inode *V1_minix_iget(struct inode *inode)
>  		return ERR_PTR(-EIO);
>  	}
>  	if (raw_inode->i_nlinks == 0) {
> -		printk("MINIX-fs: deleted inode referenced: %lu\n",
> +		printk("MINIX-fs: deleted inode referenced: %" PRIino "u\n",
>  		       inode->i_ino);
>  		brelse(bh);
>  		iget_failed(inode);
> @@ -580,7 +580,7 @@ static struct inode *V2_minix_iget(struct inode *inode)
>  		return ERR_PTR(-EIO);
>  	}
>  	if (raw_inode->i_nlinks == 0) {
> -		printk("MINIX-fs: deleted inode referenced: %lu\n",
> +		printk("MINIX-fs: deleted inode referenced: %" PRIino "u\n",
>  		       inode->i_ino);
>  		brelse(bh);
>  		iget_failed(inode);
> @@ -692,7 +692,7 @@ static int minix_write_inode(struct inode *inode, struct writeback_control *wbc)
>  	if (wbc->sync_mode == WB_SYNC_ALL && buffer_dirty(bh)) {
>  		sync_dirty_buffer(bh);
>  		if (buffer_req(bh) && !buffer_uptodate(bh)) {
> -			printk("IO error syncing minix inode [%s:%08lx]\n",
> +			printk("IO error syncing minix inode [%s:%08" PRIino "x]\n",
>  				inode->i_sb->s_id, inode->i_ino);
>  			err = -EIO;
>  		}
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

