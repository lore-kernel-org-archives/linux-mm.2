Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC501EC1432
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0A16B0170; Tue,  3 Mar 2026 06:28:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267CA6B0189; Tue,  3 Mar 2026 06:28:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1211A6B018A; Tue,  3 Mar 2026 06:28:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F154F6B0170
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:28:43 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A86C8140137
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:28:43 +0000 (UTC)
X-FDA: 84504529326.09.8B17692
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6BB6440010
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:28:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ovsi3N8Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iEJXYQ6l;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ovsi3N8Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iEJXYQ6l;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GkHTsnDKFExgY8Au+TUPe9t6sWfT7+a6ilcs+U5rAUE=;
	b=WpLMjE2Cyqi3M+6vSByxESf957SD3YoHXCLLbemNH5GRUnDAgbo+E3eSrkQzHtA4RuDGn0
	wVgTJ6EP4sLwkh63bo8vyzCGWOvU/eZiJZSVIvG4x8OGsKQbc2KT2W0hOW4LQFxJ358j8K
	9WBqgJgOMKjp18T0PyaWaWEM1uKpFwk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537321; a=rsa-sha256;
	cv=none;
	b=oOeUBQHkFmHbaweu87XJH5nJ2S2dIl6qRV2YWuO5bzC+/P8dRItK3IPbKGwIqg0bnmsx3R
	1gZcnl3feSPsDEsfpcD0vVFpJk6CFljiwrtj1e9PHafZr4qTKk1A4QqrzsbsQBbjzCFdw3
	n4VrSxP6b2eIWb/9gqxLTDIUvSP3ge4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ovsi3N8Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iEJXYQ6l;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ovsi3N8Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iEJXYQ6l;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 048BF5BD1C;
	Tue,  3 Mar 2026 11:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GkHTsnDKFExgY8Au+TUPe9t6sWfT7+a6ilcs+U5rAUE=;
	b=ovsi3N8YbSXQGV/M7cUTJEgKwEiLw7rYNcxZTiSxz7OResa+5FuA0MAEX7akSdj6J6ccV+
	Oli0ymexD4KMBhyvj1/rS7hhJtJHC7vOF+sWZ+fJyxEssw6V6pGQCIEcwyoSE7jWAEpV32
	vWIf/X0rowBcgGiPSnDZSgH2ldOFSgw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GkHTsnDKFExgY8Au+TUPe9t6sWfT7+a6ilcs+U5rAUE=;
	b=iEJXYQ6l3M/32fgct7BH9fouf7LWizYrsVTFjipmpYicQfYiNGhF97ZIwFH8NMLZ0EaCL9
	coTgSQu7YxFl6fAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GkHTsnDKFExgY8Au+TUPe9t6sWfT7+a6ilcs+U5rAUE=;
	b=ovsi3N8YbSXQGV/M7cUTJEgKwEiLw7rYNcxZTiSxz7OResa+5FuA0MAEX7akSdj6J6ccV+
	Oli0ymexD4KMBhyvj1/rS7hhJtJHC7vOF+sWZ+fJyxEssw6V6pGQCIEcwyoSE7jWAEpV32
	vWIf/X0rowBcgGiPSnDZSgH2ldOFSgw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GkHTsnDKFExgY8Au+TUPe9t6sWfT7+a6ilcs+U5rAUE=;
	b=iEJXYQ6l3M/32fgct7BH9fouf7LWizYrsVTFjipmpYicQfYiNGhF97ZIwFH8NMLZ0EaCL9
	coTgSQu7YxFl6fAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E47B23EA6C;
	Tue,  3 Mar 2026 11:28:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qEjEN+fFpmmqTgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:28:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6FE61A0A1B; Tue,  3 Mar 2026 12:28:31 +0100 (CET)
Date: Tue, 3 Mar 2026 12:28:31 +0100
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
Subject: Re: [PATCH v2 059/110] vfs: use PRIino format for i_ino
Message-ID: <mtsi6ueq2rz2kjwsc7hesxpck7amge2zjqdeptzf5jom26sdo2@z4t6nryzbley>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-59-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-59-e5388800dae0@kernel.org>
X-Stat-Signature: s9t989gaxxnhnhgf5bdzf4juqc5kco1s
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BB6440010
X-Rspamd-Server: rspam12
X-HE-Tag: 1772537321-1619
X-HE-Meta: U2FsdGVkX19QQalYFWJvnn/CNxN6MWkMGNM1MAppaw5BVbZDsGXBTJRI2b/+BalBDGUo1ysTPMAjJwzGvne9tiN9zKwNiQxFP4BjqSoXWCE83fKH6joe7km34UjsWZpBlCt/pxTVPQpnE49rAh2MpWfdCIXMTN9TNJ0bNZ+7yl8FkOHiQyoDp1vsWACMG+6e1U0ubyqyJ2iskfd9t1Cc0CWGGYejXerNGFjFk36xTQrzS/e7CVjcepwLojxzdyj7byBIlqUKbPmpTR8FUlp30ndhA9EeCuTMMAEXJNWv7UwkNC9nN9HbchD/4ljIZGtpxlBsG4eOtYOKf1dWwQp/2NMvmPDtTII1gLM9YzHHSQnTi9fA3jOSQlS4iPjkikM/Kyh4auZ/AvdHt8JsVC26cydFEh7GSFkTe8fhZ20tVqhGMQDXHbmyTB9oA7obpIH9nXENXkPx4czShJEN0WAtXTpyeg4e15V6NFcRgiBpcKlkFL5R4VmdHtjf3Mz2dMMyCQRxVJXvvNoDWAa6kMghB/wmNVm+XOdm24Rdsw4yERVwW/DHUlBqWUaY8NuUVw31czj9ZzP8ykIx1Jz77HPfp3g7LjkOrUiiwM7NOenFFKHmpaQpo7+QWkKVvdFdKFTcfTvXLD7ACF713Eda7C1pKNA0PVdwYYmF4tx/UOV0s5+JczcNoMnCTygPw10fDgIMYK8ixDhqBM5tXfDkFa1pJ/8voT+576tUZ4Zow5bmfGtr05ZpWgXtudEPJ+bzcSdPCDr3k2CUO7rI270e0dPJ4iQQoH/Bh6YhaE06sH0u84qvDNQj8hj2WLbLJJxQ7KmZHJHkHJfgVP5Jehf+qIap2ih5BvSN3fLzqSQEHbfDhM8IIs0X6MlaioLjCo/2OIpZLV6ElDc4DbAAWXZ5IkIcgOKMH6zGGExUML7gCe2+4g8wc0SR6aItLIU3mDooVPEu996GXEUfxjIwHYxPy5T
 Kh8YW5po
 RG2A+0Rl9aHTfaIszVxFgYQTx4Hb0wQJ5bD5rfn2jSkMDLfY9k4O7KYKN129p1ORox8LuMQEFQksidAFAYqSkgMbIt790+MBvx+LBXNK3t14OX6cQejCWdn0xOSLgbZzFeLKYUdV5ja45RO1Y0DXSK9b3UB8Amo/pD16PDF49K+1k1oAkW+u8urx7xW9HWzt9Lm6yaYPt7k0f4E/Wbv2eJYxaZeXU/Pfn50sSHORgUimoeM55hkOTO0n2Yz2dvCMQLk5gni3zZuRmIt8bT73ORrnINgvR819w8kRf3muFaERMsaZ0pVbZlZJN+zKW0euSVMBWz6xl2rOKmJ48l+XnUetZk/73MZzPJfDaLogmJQwZHYLBo6QH7XwdTdEdeDjC3Rs64zAYdRLtbObkDbP8lysy8NMBZiOI2zoHkWjoRqo3clKDXyNm0vUT93usWlqK6MVXSR8O8pPS4ddLogzlI2g3InkYKKbg9nMXOVJrMLvhCRvPXcE5zxoUXwXITJ5j5ERDOwG4G7FtNjIJTeiObcxbeBF0TOCKM1o4HKmruveKTCZqZQ9fe89cZZyUcdp6/+um+JnkTFQzewcVQR8BFrsbuHcbu1y6xV8iaWaB8bfxnY4amTr4cwsQBgjjhX2J0byviB53ffwgmwUARnlXIlz9h5wfcEi/1Ooenb2bJSrTI/EeLJ+MDyLEBS4x5CzmKuku77rZpFKs1jk1a1NGJhk8opgLyUclxNp/PpwexJUMN2xmJqd7gfAWWOwDJOEiXmaBEzwKiOwK2rTc5usiKG1DRh9Su8dWOlReBEAk/0kz4h48V3Fjz+QfmKxFSm1zVWsnGAc6/epg8wgB4oWuCb4SWahuWF9qDIpRlh0E7DTFwj+Vq7fQxOUDcnIu+GiCpTTS6oUI/JLLN9U+h9TP+vpCQMGn7tuQALar1kQOdQxaNyobftdbDDDE0V27XycgmHwwAGwKDAz4Z+hS9TrjwMJMiTYT
 yAZju0bH
 E26Q7clBBV70jLB/ZIWwMF9sBYadx9JKJ45pw0w7TTbVUibXZ7PUr6hpitk5Crvz5VeU/gKlaXb9MJfFPdW3bf0ECRX0PjVM8cxOUOnbT6oG4gcpx2l2+AlmbdVetF2BdT5k2WbAiE1v0XyDmU5L/3q9HhWlT7DBfSQzP5BssgNPMnVTW27TNWaJOxgSGZonberIj4fRGiK+q04UDeQraXPHg3LWrOFZFdjDL+qvJiFaABKP2jUzl7KZ0wyB4yusqejZWi1wCurn1/d1qv+dUyFvseoSnPXZW73kTLDOFBK3/LFLNpf5yEGpzNrvgwngAcf52twR9fyqV4wB6kkpzm3pPsB5PxcpV4zZsXNcTKNq7Ki+5qnKLsnLPAXVhKoSDtXqDXYysAANLkwxTe8/FkXcKYyCMInkifOcXbUkTkanWCo3DYySFt/vktI5+otoYbhnFtxwZzClTypvw+BF9RTKfApqkVPWfW+Vj0Ut8VRye/w9la6vQEW0Uf5jWcFZHtygz8vuG3z4gWkBE1OjSjT24C7SO8aAmngZKroB9NZnNI2R1S7lEvEx0IEJPawWg+nMt2XcfSTnzglcQCgajj88nUv/AEfqTTiLjeJFBJ46bkT4akXbiZiw9FNclL+BQeHYn62gKMAshF2Wd6tAHpg+WzmgvpjnMnPzDqNlmdTVTqYUa4MQYN9bgEwzLcfiYr0kjlheXZeJEVzfxYtgB/5D1NVkVsMHIYJ7gDLt+IJAk+Qee56+p33QDOPOAARS6zuQTC4guWuG8AASofLrxUOLN9lb3ulLsVsVxMDttUcvQVqarRg1kwIZ2i3uytenqGY0UxrBA5NiAJAJ5pl5vvm7IjVEe4desu6NVRCcwiTaNpdh6HJeX56ULuzvm3YKbdQqLGQdFxsy3gl/hGVJ1m81VoPp4j+vp8hjWepqKMTcpU0gijrXtQ8GMiMwfvUVxlLqN5kVXJXz5gtWggBEh3Nlmmo0p
 J5WPJ+2f
 CDhbwstaUMBFIIVAl5ccYTUJMherT6/vJ8KlcsKi7Gyu3X7ZzPPbsTo1VEE8AzxuaLL/c6Zx6vmOZoHLwSKURQtmdkKl1RBSrgBdit7coi7R2tNjcBJaZNqeplbguHzLcv8kd4eaSSY9UtU+0CvA2pBasmf28WmKZtdXdJF9WR7x4rq1wECRRhjk4z8J07SnSrzJmxpDFhLZxznE9gJhnW+8n/TKcA3lEoeNSnlWFOO9lsO1QEoZCrT8xJfIQepSVTGg3RBS0VKUTFZzePttcqA5ZXfSX8m+vMUPQMXijUCwHsxUgc7TVYG7I89S98xt5HRtvWgekK0RmZEqlVNyXec+tUXeIRbcjGr6bJcFUxxGrX23TLwMtsd9gIu7//1N96SK8Ux3a8PkahXMWWGONoo1pwz8wMyWV/GiAgwgbNuRV6FpObRbaDcuVEk5v7dPNJO2o5gYihwY06Vqs2+PN9VuoH8hkEqSCrI+6eXSiBsxzkEV7Y6Licwjc9IBx+fsR4GdIFLo5Og6z09I2+oAtphzfHCC+sgCEA7Mov6SoYcfwMidnUDx/jGVPbdped4Y2KKZf/Do1IusnEJS2CgeN6yLNr3W4bVmrkvCXPDk7rq5bbyF0jVEJAmAXocHrEz5WbxMsS6BfrXX7JnL8NU6y1SHFrkvDrdhWWHUX6VNUafZPtIlRjhrUYogUUagzHS6sLhBn2hBTUlOhuU6Ya6Itn0aWs3ao83Fiznf2HEazatIKXAYve3v9237+hjY0PVpJ2N+c76xZnNqrOuAlY5beisrrJxQdWCXV9CYCcjgEXTIFGoCp4e16tOui4pu0Nkoo833tNnLjl8rKQ5HWLBzfNwBUv+0YCetzIhD3XkIQ4KpOkIhHaRvOHNPMq8vbvPpda856g1yPL4633AeCFdH0YDy6RmpLwsxZ9DxAGosb09Czriy6HwiPZ7lo5j1/4OCuX/3+1O2mwwsVcH9d0fsPdg+aNTs6
 H2Zw6kGT
 jUUaxo60VDtZwdvBwuKpZ5hZr8S7CmsAbB44lMqhrgz9FyZM0nu8qTx/t138SKxWfEAMvQ2+gafCSqywCaETxrSFRPVLsII+hsl3XHFEsaDH1XutBhw/4AcSg8A9N408fuexw/Z/w8DLyxi3cv/qNeSpEUnbNxK1i4gecCejsXOHNQKcWugngQTnboEv5ilamzV77Sj1BH5XiIUCZY549h81wRXM65n/yNBzn7gbooONMeeq5CKT0Z1gFv0OZqkExTULTSVLTZmyEunbNLvJehEyXSzsyT8zyPXpJe1nLmnsHjCrhcrchR0TT1aWOQ+NaldWTovFntG9rwd95Eb2zMybb0pdrkiz5bZ1uvLCpM1/vzjaK2EqX7E6PO7c3VghmLZl4LJfuySHQBeWRtLCu2sMiGNqEu8kgmkcMmqBsfnj8nMsUwpKqTeb2g2LHvnvODMQ7RZskQppMdZbJEwkHCT6280wgnBgW8wQetoVe4NfzWV1iAQQO+SxuBCCghpQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:24:43, Jeff Layton wrote:
> Convert i_ino format strings in pipe, dcache, fserror, and eventpoll to
> use the PRIino format macro and update the 0UL literal in dcache to
> (kino_t)0.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dcache.c    | 4 ++--
>  fs/eventpoll.c | 2 +-
>  fs/fserror.c   | 2 +-
>  fs/pipe.c      | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 24f4f3acaa8cffd6f98124eec38c1a92d6c9fd8e..13fb3e89cba7442c9bed74c41ca18be5e43e28c9 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1637,11 +1637,11 @@ static enum d_walk_ret umount_check(void *_data, struct dentry *dentry)
>  	if (dentry == _data && dentry->d_lockref.count == 1)
>  		return D_WALK_CONTINUE;
>  
> -	WARN(1, "BUG: Dentry %p{i=%lx,n=%pd} "
> +	WARN(1, "BUG: Dentry %p{i=%" PRIino "x,n=%pd} "
>  			" still in use (%d) [unmount of %s %s]\n",
>  		       dentry,
>  		       dentry->d_inode ?
> -		       dentry->d_inode->i_ino : 0UL,
> +		       dentry->d_inode->i_ino : (kino_t)0,
>  		       dentry,
>  		       dentry->d_lockref.count,
>  		       dentry->d_sb->s_type->name,
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 5714e900567c499739bb205f43bb6bf73f7ebe54..90fd92425492221d13bd0cf067d47579bb407a01 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1080,7 +1080,7 @@ static void ep_show_fdinfo(struct seq_file *m, struct file *f)
>  		struct inode *inode = file_inode(epi->ffd.file);
>  
>  		seq_printf(m, "tfd: %8d events: %8x data: %16llx "
> -			   " pos:%lli ino:%lx sdev:%x\n",
> +			   " pos:%lli ino:%" PRIino "x sdev:%x\n",
>  			   epi->ffd.fd, epi->event.events,
>  			   (long long)epi->event.data,
>  			   (long long)epi->ffd.file->f_pos,
> diff --git a/fs/fserror.c b/fs/fserror.c
> index 06ca86adab9b769dfb72ec58b9e51627abee5152..b685b329b5956a639c41b25c42cfff16e6e5ab6e 100644
> --- a/fs/fserror.c
> +++ b/fs/fserror.c
> @@ -176,7 +176,7 @@ void fserror_report(struct super_block *sb, struct inode *inode,
>  lost:
>  	if (inode)
>  		pr_err_ratelimited(
> - "%s: lost file I/O error report for ino %lu type %u pos 0x%llx len 0x%llx error %d",
> + "%s: lost file I/O error report for ino %" PRIino "u type %u pos 0x%llx len 0x%llx error %d",
>  		       sb->s_id, inode->i_ino, type, pos, len, error);
>  	else
>  		pr_err_ratelimited(
> diff --git a/fs/pipe.c b/fs/pipe.c
> index b44a756c0b4165edc2801b2290bf35480245d7a6..311928e8713989747605fd79f653e36d27ce8c0e 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -873,7 +873,7 @@ static struct vfsmount *pipe_mnt __ro_after_init;
>   */
>  static char *pipefs_dname(struct dentry *dentry, char *buffer, int buflen)
>  {
> -	return dynamic_dname(buffer, buflen, "pipe:[%lu]",
> +	return dynamic_dname(buffer, buflen, "pipe:[%" PRIino "u]",
>  				d_inode(dentry)->i_ino);
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

