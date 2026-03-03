Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38051EC1430
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6696B017F; Tue,  3 Mar 2026 06:37:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77A906B01AB; Tue,  3 Mar 2026 06:37:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61F1B6B01B1; Tue,  3 Mar 2026 06:37:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3DA6B017F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:37:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D468C160110
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:37:41 +0000 (UTC)
X-FDA: 84504551922.14.5D172A7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5811E4000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:37:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="s/VMDDhS";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IavhWDx2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="s/VMDDhS";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IavhWDx2;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGvY1nGGnAjT98RkQRklRyi1yhpK4+sFFW7EPqGn82U=;
	b=Z8lOKsKq8HB6UbliD86jwBBBDsSTamTSWPyGQVctQSrNH8Ii2CvFPMv0uYAV9IitV4Knx9
	2MpIWaIyLEAFhRUJ4qSxEFLNWfQaccAcVmM0SfyIO06Xl3IwWMD7LnWNNmzQTZVpL9pOcx
	783laHAXQPnEEImWDTJkicvnz8PwBvw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="s/VMDDhS";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IavhWDx2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="s/VMDDhS";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IavhWDx2;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537859; a=rsa-sha256;
	cv=none;
	b=1IPPnxMFDM269s4hz9RjH1W0pN3HoDfIal405cLGf1y5PF3qE/oVAnBOJrqAJXX8/QJ0Jn
	80Zx+fFme/dgH2whvUvF8cp71bslTBjyRQKT7sZUs3eY5WRiZeHuH22yqPHy06sfupReS/
	+KahRca6UPuK2ztuSB+2pU/Z2fVljqw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DC9953F8D2;
	Tue,  3 Mar 2026 11:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537857; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KGvY1nGGnAjT98RkQRklRyi1yhpK4+sFFW7EPqGn82U=;
	b=s/VMDDhSu6BZiztym6Ch+Vqn+dEYit5a+K9wld20IQPyPF0MfkQcPZbt1JXN5C9+h4qCLh
	ID6Zk7+HSAG4ZSjD2n1LEFqMuhKE2VZbDLeUc7OveJVNc7A4UGQVRL1slSpb+r6q19pEpE
	n5vVxWbmt5mSZQVZox7T5gtS/fcza38=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537857;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KGvY1nGGnAjT98RkQRklRyi1yhpK4+sFFW7EPqGn82U=;
	b=IavhWDx2Kh3DHq1zANsSVI/WiJB5RbdvrN53jtu4s07STfLomCtQ+AyQtB77CtfxuNuELQ
	WJjg27+5hANJ3lDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537857; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KGvY1nGGnAjT98RkQRklRyi1yhpK4+sFFW7EPqGn82U=;
	b=s/VMDDhSu6BZiztym6Ch+Vqn+dEYit5a+K9wld20IQPyPF0MfkQcPZbt1JXN5C9+h4qCLh
	ID6Zk7+HSAG4ZSjD2n1LEFqMuhKE2VZbDLeUc7OveJVNc7A4UGQVRL1slSpb+r6q19pEpE
	n5vVxWbmt5mSZQVZox7T5gtS/fcza38=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537857;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KGvY1nGGnAjT98RkQRklRyi1yhpK4+sFFW7EPqGn82U=;
	b=IavhWDx2Kh3DHq1zANsSVI/WiJB5RbdvrN53jtu4s07STfLomCtQ+AyQtB77CtfxuNuELQ
	WJjg27+5hANJ3lDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6B323EA6C;
	Tue,  3 Mar 2026 11:37:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WceMMAHIpml6WAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:37:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 86E9EA0A1B; Tue,  3 Mar 2026 12:37:29 +0100 (CET)
Date: Tue, 3 Mar 2026 12:37:29 +0100
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
Subject: Re: [PATCH v2 110/110] vfs: remove kino_t typedef and PRIino format
 macro
Message-ID: <rallmd55miopcn5jdtzd33ez5udz2haadugzu7vaqxvv2udhje@i73uyn62zwyp>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-110-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-110-e5388800dae0@kernel.org>
X-Rspamd-Queue-Id: 5811E4000A
X-Stat-Signature: zb67qyuq3pon9zg3r3gzahpznzxn6j99
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772537859-652040
X-HE-Meta: U2FsdGVkX19LdDLd7F0EmxOU5FYSrl/YeOswX743US2YkLAW7KBlKXP08o3sLtLaZWv8IgkMcbzrn+20vsRn2ugz2GnLbJrz+nEoWSEWHkxW+arZSM4EkQTNR939J41uSkf63oqQmvoJ5Y2Cx1SGRlt9oWKZA90Bc2GAtU+PefrWxX1p+WQO0DncoA489fx4Im49ggaWkAZKqWo9jVxJv51VCrjecmu7J0lAR5OnUno0kCbOMGM6johwHsMGD11n9ZadiPPvTVCNuLXb33WmaIBhGEP2C3enjm4/2jbwmyW9LVScyFm7Q5JWFBxrXsS2ymXGQea6daDwhNOJ3F3mP7p8wNdwiPg4NLMzJxFMVYNY0MCovWZepzRQREYmeFElPlMkqRAGwLqXd2t6GaItzx5Xe9tS/pRxAVBldz3eTVuUXLt1UGkh66mj5JFxBZ7hjkCIZKmvn9mj4b8I/OzCngSAsDHsYsb6/EwbzswN1GUKrKcGlTkPV0PXPtm5Cs7rP+TBY09332JVtrXE8A9HqT4qzUqanH9VyfJjqeJH9bLb6Xy4jD56SyTC8J7y4haW7R2e/mbAo/5JjPOZqAl7T1vEFK8PVgUD9yt1pWmBapRIyCfO0UicjPWCiBCXlnW3/XoIsykzLUtS51e3u2A/Lq1CXqpDOSw+jXMatU33EZx8EM5s/Sc6VwLq5JPgcdKme3iYIic/Qwqb9kzayQqR+ou3h4xX2T/NYVZPAjR/T+HueBE2jJtqY/Sagcx8Dcl5OaAs+dyf9kEyqI5mDQ8iMK4flAm8ntNQtFL/QUeEzGc+lG/dNhoYfzvtxvgtGKwvvW/kBQvEuQdh+yVjVwdsyg4KroscD8vk9Ny/oKvWIF76Qr0Z0uoC+uMwFOb26HboYR9HTYnYOzX3W8NbEbq1nDD4CrHbSh1Jy6bhDgw+dSL4goc+b+c2CtZZJpD0Bgv5in28nJU9wVBClIar7KM
 E7Pw+eD7
 +w8MdDcnOwstQPjTOC3xrel0wdf+kkY/spKPJUbs2xpFXQiW5q+/eu0FCIyB4SXBEFDr8cFh355VWNLJvig+ERwnzVPI147rNP6mj7IL7Ybpm3vjAOae/RIPCCOmR4Z9uCiG2D7+VLZYg3uPL/Em+Ls/bbwGAnN1nQbLl4RMTcdPg57eJAsE/+V+q5meROXckbpb3T/6oQ5bYuvVZFLKAgC8dpRFc4pnFzwwQQxIP8LimMabbah1pzZBXYFT6UX/CxneKwzRXM6F1QEuMIakl+uNhIjqY58rvKmtj/V0oqIAj2tarhb9KI/Mh4tn7TO+yKMFP1/wi8uE3j1c06ftg5dyHMG8D0i2xSovI2oVxGyBbIY3qT8CwNgY6XKNJoDH9N5Uw6XJmpbcYOBR3FLnCQnqU6RtVmyNg4Q3a5emPXxQNsY0HA/Vj4Daxy9YV5sbT36QuJQN+LpMUPqCSGOGdLI197twV3EYezPeyYwVyKJX0HS+N3P5mADtRJiIZOUJpQYgQm9AnjolSiEFXyHX7zvcwlLsUIVk6i2mMi/v9uGcry3/DOdHGISFLw+dDL8K3WLPXAuOXUeaumrXnJw/h/h/jg/pC9H3CXtCFE9W0kJPCeyytPe/HUU7OhsQAlqXkp1uxDCDZvc9llU4QIf0wfXa1xTsvlOrO0tMegF3crPXY2qWdvL5U10W/ehJnorq6t4A1uhLjPgJ+PSg1tTk3YJfLRkFcRa1uSImYghMZQEsgqGQnt1q76d5BQGfV94nLZ7dhzus5gmK/2MqNM/Amz4b8LhVkjW72pxRwBpO8UQ9mlsOnO2nVPvNIFQ5iGEtX2u5ARKYGysSu8TIhQY8NhWs3d4ubXwvwQLmtoG4Zxkbl9p6xNAhJphC1AaKrcwrXXAHN8VfvQIwQ8Z85rn2H5IYxjEFygIDWwgz/t5eb97lqo9PLioZ/YaG5vPa+C45bcsZ2h3SfDfqUwaYzqG8OF9hdvWQe
 pL/17p6C
 7ZLPC1NYVcTlgh8yfd+v6+6UJ/lNQgqRI8kJ0yWHnjHFFpWwzEJZVZqPzrX3kkYli4abLSjNmNHaalquMSlS1B3+JtifUqGhlpB4yCZQ4oXwMq4rvIQs7emwrMzWU2+mBS2S+EI4cTaDa1XQuQA+DWp6cB8OKmTES1WaOH/eeURIYH7A9ekTv537oZHYGKtPjPuzxfYgOyaTnIHJQAtvGnph485iEyP/k5EHk3nJS2JGK1w35TyaCE306EupAbBGcbccp0tfD8Cco3npzJ714QlqtEXKuWDJvW98gIyL0aRt/Ao+sK3ML+NWZ7sHRHObilPTXxfEJQLCbbfwE7XkuSRvXvU8ogSBuSlqPemmlkzFwiIVofps/byzfEvx9AsDfraYl2saOZ2zAi2Q3YW7woY+eO3IwKVIttdMNgrue4tcG2PYJg4i75rTtToVLtTvF69uS3zO5M33SMjF/76mTP3k0kHH840dK4k24uv/346PbrNIzRlHcuaH+MGI/4A3BJUESNF95bRcJyXvzT2npeEjOUVDEURt5ZAb6AzLduIAc2MTLl674+9kIb0tMx4oFNtSTX5ySjqSfFHWPojDjKuHwWUZoQjkW6LpDD4BsxVmulKTQEKQav9OvTUFxDh10QxkHmDNu/5xuoiG+o0VtYCB9fS9J3UTXR/6jUcPtvvlLr+Zc/bBrUvp7Jm4quZ+RJdV/pLaxY5NH/EWz5YFpfLaw8ctzcUMKvzNwhA8FGth2AlhPY0bPfd8vy6Wg5DZy8bj5E1kDqe3nta4RZAtYkxA2U9b+VHZiia26rsPMqNv0dpLRzLyirr9vxIBsHqVhe7ltXLv5EsOsAXJ1U0+eyzgLYJuQg2T3KR/wxDDCNiz5tlPtY77zjEnzK3b1s+UqGmC3FdRKt9ABF1KiTxfC0T8uzQ7LFwo/wXKYwSUqVn7V9PucNlktD5hCqUlnmyQno5vtJadbqKpHPlZtjAvJGuYVTA92
 Efv+39ij
 HG6Nbb2WbkENBBd3fUKcej1nvC5XVxU6hINH7cXLDJ1QYD6NP7lYPasJyHNdIvVzEC17/i0BtQAs+a2v4MrMJoxeNHzqj6+N9IytIKDEVllOAZBQxwfRfT77f/aiHcjFh0Zo3W+5gQCbgo6aUZsiys4DMnQNHIwEVDYpM1uijUxxemREoIZNKn09PVe0i2r1PGXlqbl73LMXEh9IgNeh1IsAnYTpIoycXHJoXGReMpNpjuCNm7wjPUx6qJW2DwhYb+yQg74OWre9SuDPqhV9VsYYYEkC0o1jSePRXhcltvOLJumB0t0IuTPJDsUCcktnJT+vqEMYwJAI1DxxhcqF3VACmIRw8p8oCi/OhEfdzhCVmmeioPwCqnbaeS/a35XyvgArXU88alP0udBWraNIreFQBmnowYeFOsb6KcU3yR/iBuotRusUbplOWtUtJYZ3HELoh79X5WnrNQAqC2OX2SorfXmg4N9Hz7ohWM1aTfVS+nyrpPSL+1Ddoho9k3jB4i/lUjQ6+pGVNeRrGWU4Ga8KT5eANgRcB9jIdU0K7LGhQoT4RV+dodcYfJM3fqMuoJhdLiBkQ3PxGo/rl2lBhyE34pyoGbz+KUoY3xz3/YXTsS6BNcHgJz690l4LlvPD9GHRgqTbVRMzKnrMtYn1pBDl/W6xkOXmVNl0lXNLCfZYzascqFcKfwrnW6AUhEpv7HAq+4+rKW8ldXg4FymNQVmUEGpZqSBIz1INIMZTVlXedf+598ELfmt8/x9WErx6V7YoXkK4O7E6YXlA2wf5zwo8lupBEqkijqCO+F9L36/vt1M/dLplXppt8mM1um7rxivaC7HFHoU8oIiEGZ9fgGvQ+gE6nMQa8NulR4cYjHZiVwXlVHMOw49N77b2neg7Ono596Zy5WvudPSMxEezSmFznwrpmbB3nPkX7kWYOq7mIbO7rYH9T2OUwN/o9Yrs70c9WXJcsUrmtkXNmrD9ldf3oqy4o
 AcTPJ35Z
 ZP0eXwuA42Gz9xptUlhDb22o3RX0BVOp3ujo7YkDKwkpmVzlTAIB91542sCnvVDZdr3E8E/Avm0+hKSJ6H/ixHICP+mVJ+a1C7ZUS0FRCDMB7Eow2k7JidNym3yxPDKMHzyr9Fb3FVzQuldeaB+iv43+ZkroZVHFzJaCA08FQqXd2jJEG0gAW0Ebd+wCWXcaV9obSrTxY382IfMGfRXIE6pZ4R0FUPaFW6fyTE+z8BEIsg03T978QY7+O88xui30DD8i6xK3r7Afb2WkO7SNIssqrziSAqQ5ZVtCc9Plkww+vRsXyH4qhO962eqSmFeHHkIIAN2psh5FU89Vc8BbW3NSavfi/IwfCAYCUU2aCaFVVqAOB1LJDpUPdo2/3/SZHjRP4MGFeY4S9PBhMII2FbSC6W5vCCZ3HR70bQWTaryPqUOGAHBOkOuKatjPW2b1ZFbVDLBPwmBxvm12L65FYrID7vm0TrJiFFI5L5RWsPh66JUE6+XBqlRr620pex1eg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:25:34, Jeff Layton wrote:
> Now that i_ino has been widened to u64, replace the kino_t typedef with
> u64 and the PRIino format macro with the concrete format strings.
> 
> Replace the remaining PRIino uses throughout the tree, and remove the
> typedef and #define from include/linux/fs.h. Change the i_ino field in
> struct inode from kino_t to u64.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dcache.c        |  4 ++--
>  fs/eventpoll.c     |  2 +-
>  fs/fserror.c       |  2 +-
>  fs/inode.c         | 10 +++++-----
>  fs/locks.c         |  6 +++---
>  fs/nsfs.c          |  4 ++--
>  fs/pipe.c          |  2 +-
>  include/linux/fs.h |  5 +----
>  8 files changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 13fb3e89cba7442c9bed74c41ca18be5e43e28c9..9ceab142896f6631017067890fd1079240448e13 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1637,11 +1637,11 @@ static enum d_walk_ret umount_check(void *_data, struct dentry *dentry)
>  	if (dentry == _data && dentry->d_lockref.count == 1)
>  		return D_WALK_CONTINUE;
>  
> -	WARN(1, "BUG: Dentry %p{i=%" PRIino "x,n=%pd} "
> +	WARN(1, "BUG: Dentry %p{i=%llx,n=%pd} "
>  			" still in use (%d) [unmount of %s %s]\n",
>  		       dentry,
>  		       dentry->d_inode ?
> -		       dentry->d_inode->i_ino : (kino_t)0,
> +		       dentry->d_inode->i_ino : (u64)0,
>  		       dentry,
>  		       dentry->d_lockref.count,
>  		       dentry->d_sb->s_type->name,
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 90fd92425492221d13bd0cf067d47579bb407a01..4ccd4d2e31adf571f939d2e777123e40302e565f 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1080,7 +1080,7 @@ static void ep_show_fdinfo(struct seq_file *m, struct file *f)
>  		struct inode *inode = file_inode(epi->ffd.file);
>  
>  		seq_printf(m, "tfd: %8d events: %8x data: %16llx "
> -			   " pos:%lli ino:%" PRIino "x sdev:%x\n",
> +			   " pos:%lli ino:%llx sdev:%x\n",
>  			   epi->ffd.fd, epi->event.events,
>  			   (long long)epi->event.data,
>  			   (long long)epi->ffd.file->f_pos,
> diff --git a/fs/fserror.c b/fs/fserror.c
> index b685b329b5956a639c41b25c42cfff16e6e5ab6e..1e4d11fd9562fd158a23b64ca60e9b7e01719cb8 100644
> --- a/fs/fserror.c
> +++ b/fs/fserror.c
> @@ -176,7 +176,7 @@ void fserror_report(struct super_block *sb, struct inode *inode,
>  lost:
>  	if (inode)
>  		pr_err_ratelimited(
> - "%s: lost file I/O error report for ino %" PRIino "u type %u pos 0x%llx len 0x%llx error %d",
> + "%s: lost file I/O error report for ino %llu type %u pos 0x%llx len 0x%llx error %d",
>  		       sb->s_id, inode->i_ino, type, pos, len, error);
>  	else
>  		pr_err_ratelimited(
> diff --git a/fs/inode.c b/fs/inode.c
> index 24ab9fa10baf7c885244f23bfccd731efe4a14cc..5ad169d51728c260aeaabb810e59eb3ec1d1ce52 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -726,7 +726,7 @@ void dump_mapping(const struct address_space *mapping)
>  	struct dentry *dentry_ptr;
>  	struct dentry dentry;
>  	char fname[64] = {};
> -	kino_t ino;
> +	u64 ino;
>  
>  	/*
>  	 * If mapping is an invalid pointer, we don't want to crash
> @@ -750,14 +750,14 @@ void dump_mapping(const struct address_space *mapping)
>  	}
>  
>  	if (!dentry_first) {
> -		pr_warn("aops:%ps ino:%" PRIino "x\n", a_ops, ino);
> +		pr_warn("aops:%ps ino:%llx\n", a_ops, ino);
>  		return;
>  	}
>  
>  	dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
>  	if (get_kernel_nofault(dentry, dentry_ptr) ||
>  	    !dentry.d_parent || !dentry.d_name.name) {
> -		pr_warn("aops:%ps ino:%" PRIino "x invalid dentry:%px\n",
> +		pr_warn("aops:%ps ino:%llx invalid dentry:%px\n",
>  				a_ops, ino, dentry_ptr);
>  		return;
>  	}
> @@ -768,7 +768,7 @@ void dump_mapping(const struct address_space *mapping)
>  	 * Even if strncpy_from_kernel_nofault() succeeded,
>  	 * the fname could be unreliable
>  	 */
> -	pr_warn("aops:%ps ino:%" PRIino "x dentry name(?):\"%s\"\n",
> +	pr_warn("aops:%ps ino:%llx dentry name(?):\"%s\"\n",
>  		a_ops, ino, fname);
>  }
>  
> @@ -2641,7 +2641,7 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
>  		/* leave it no_open_fops */
>  		break;
>  	default:
> -		pr_debug("init_special_inode: bogus i_mode (%o) for inode %s:%" PRIino "u\n",
> +		pr_debug("init_special_inode: bogus i_mode (%o) for inode %s:%llu\n",
>  			 mode, inode->i_sb->s_id, inode->i_ino);
>  		break;
>  	}
> diff --git a/fs/locks.c b/fs/locks.c
> index 9c5aa23f09b6e061dc94c81cd802bb65dd0053c1..d8b066fb42108971f6b3c7449dbc9b5f8df16b13 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -234,7 +234,7 @@ locks_check_ctx_lists(struct inode *inode)
>  	if (unlikely(!list_empty(&ctx->flc_flock) ||
>  		     !list_empty(&ctx->flc_posix) ||
>  		     !list_empty(&ctx->flc_lease))) {
> -		pr_warn("Leaked locks on dev=0x%x:0x%x ino=0x%" PRIino "x:\n",
> +		pr_warn("Leaked locks on dev=0x%x:0x%x ino=0x%llx:\n",
>  			MAJOR(inode->i_sb->s_dev), MINOR(inode->i_sb->s_dev),
>  			inode->i_ino);
>  		locks_dump_ctx_list(&ctx->flc_flock, "FLOCK");
> @@ -251,7 +251,7 @@ locks_check_ctx_file_list(struct file *filp, struct list_head *list, char *list_
>  
>  	list_for_each_entry(flc, list, flc_list)
>  		if (flc->flc_file == filp)
> -			pr_warn("Leaked %s lock on dev=0x%x:0x%x ino=0x%" PRIino "x "
> +			pr_warn("Leaked %s lock on dev=0x%x:0x%x ino=0x%llx "
>  				" fl_owner=%p fl_flags=0x%x fl_type=0x%x fl_pid=%u\n",
>  				list_type, MAJOR(inode->i_sb->s_dev),
>  				MINOR(inode->i_sb->s_dev), inode->i_ino,
> @@ -2896,7 +2896,7 @@ static void lock_get_status(struct seq_file *f, struct file_lock_core *flc,
>  			     (type == F_RDLCK) ? "READ" : "UNLCK");
>  	if (inode) {
>  		/* userspace relies on this representation of dev_t */
> -		seq_printf(f, "%d %02x:%02x:%" PRIino "u ", pid,
> +		seq_printf(f, "%d %02x:%02x:%llu ", pid,
>  				MAJOR(inode->i_sb->s_dev),
>  				MINOR(inode->i_sb->s_dev), inode->i_ino);
>  	} else {
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index 0e099ee2121f8831645c3a25d759793ef2ff9ce6..eac326b85314ac8080248347154d599c953969c7 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -46,7 +46,7 @@ static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
>  	struct ns_common *ns = inode->i_private;
>  	const struct proc_ns_operations *ns_ops = ns->ops;
>  
> -	return dynamic_dname(buffer, buflen, "%s:[%" PRIino "u]",
> +	return dynamic_dname(buffer, buflen, "%s:[%llu]",
>  		ns_ops->name, inode->i_ino);
>  }
>  
> @@ -394,7 +394,7 @@ static int nsfs_show_path(struct seq_file *seq, struct dentry *dentry)
>  	const struct ns_common *ns = inode->i_private;
>  	const struct proc_ns_operations *ns_ops = ns->ops;
>  
> -	seq_printf(seq, "%s:[%" PRIino "u]", ns_ops->name, inode->i_ino);
> +	seq_printf(seq, "%s:[%llu]", ns_ops->name, inode->i_ino);
>  	return 0;
>  }
>  
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 311928e8713989747605fd79f653e36d27ce8c0e..9841648c9cf3e8e569cf6ba5c792624fe92396f5 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -873,7 +873,7 @@ static struct vfsmount *pipe_mnt __ro_after_init;
>   */
>  static char *pipefs_dname(struct dentry *dentry, char *buffer, int buflen)
>  {
> -	return dynamic_dname(buffer, buflen, "pipe:[%" PRIino "u]",
> +	return dynamic_dname(buffer, buflen, "pipe:[%llu]",
>  				d_inode(dentry)->i_ino);
>  }
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 4193817e02e8bf94f29514ca43379af21f37ac61..097443bf12e289c347651e5f3da5b67eb6b53121 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -758,9 +758,6 @@ struct inode_state_flags {
>  	enum inode_state_flags_enum __state;
>  };
>  
> -typedef u64		kino_t;
> -#define PRIino		"ll"
> -
>  /*
>   * Keep mostly read-only and often accessed (especially for
>   * the RCU path lookup and 'stat' data) fields at the beginning
> @@ -786,7 +783,7 @@ struct inode {
>  #endif
>  
>  	/* Stat data, not accessed from path walking */
> -	kino_t			i_ino;
> +	u64			i_ino;
>  	/*
>  	 * Filesystems may only read i_nlink directly.  They shall use the
>  	 * following functions for modification:
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

