Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F27D0EC1431
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD376B014F; Tue,  3 Mar 2026 06:35:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA7A6B0150; Tue,  3 Mar 2026 06:35:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B8E6B015B; Tue,  3 Mar 2026 06:35:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 106B46B014F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:35:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76D271B6BCF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:35:01 +0000 (UTC)
X-FDA: 84504545202.14.38A63A6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1DC65160007
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:34:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pXCz07BH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="5ZMPV/gG";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pXCz07BH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="5ZMPV/gG";
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2KtMfk6gMVMjoQIrKorgsodqn+umYv4SqWiaDMLQLh8=;
	b=Ce1ki7Ifhes8DrjGLzAdfmXQ9gbPR27bD9SWCTHMJOZ37O+ZV7TAoABgF8KOPHiMbUe6yC
	ijYkWg2VKkyg2opvyT2aJuFuEDdym7OrWLELypKn8FAA+gJM2CgrWzJ8LJN+K5waRITPsT
	9Zhv+R5r7B38bA8PUZ5ECDneD15ylJM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pXCz07BH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="5ZMPV/gG";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pXCz07BH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="5ZMPV/gG";
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537699; a=rsa-sha256;
	cv=none;
	b=Eqzl4XyVNcmvWUhWMMslvSmgWrc2oORX3eAmnapPoGt5sO/G4e/vuace1PuOBIUMsIBQAe
	vNF0FQSTewd8cGS+fpVFiNO2I19E1kBXqvbLPtUI0C30n2Z2GthFIpSZzpyXqia0EpswKP
	p74w6LgzwrE9agViWSA4AsF/bFD/r9s=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A57CA3F96B;
	Tue,  3 Mar 2026 11:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2KtMfk6gMVMjoQIrKorgsodqn+umYv4SqWiaDMLQLh8=;
	b=pXCz07BHHzIC4qyGYeJj1zJY4fSOqjkS5LFNOf+IuFQyaZBLkjOgOkxfS6ZmlBrJUpCShX
	lMXLCh0Kh3li8ULWw47rwNFTgaqUkIJukS3jO379SF23/8ffcNWRkrSs99m725psNbxSPN
	BtcFGp5iLwQ4JVVbv0LR1gs7zkmiq/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537697;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2KtMfk6gMVMjoQIrKorgsodqn+umYv4SqWiaDMLQLh8=;
	b=5ZMPV/gGQeDku5UbctOORvDceLlFcJr3veNqwi8gjPw9myVqfisLA5re1u60WZv7uvDS6s
	CvipclKKh8Gp4bDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2KtMfk6gMVMjoQIrKorgsodqn+umYv4SqWiaDMLQLh8=;
	b=pXCz07BHHzIC4qyGYeJj1zJY4fSOqjkS5LFNOf+IuFQyaZBLkjOgOkxfS6ZmlBrJUpCShX
	lMXLCh0Kh3li8ULWw47rwNFTgaqUkIJukS3jO379SF23/8ffcNWRkrSs99m725psNbxSPN
	BtcFGp5iLwQ4JVVbv0LR1gs7zkmiq/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537697;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2KtMfk6gMVMjoQIrKorgsodqn+umYv4SqWiaDMLQLh8=;
	b=5ZMPV/gGQeDku5UbctOORvDceLlFcJr3veNqwi8gjPw9myVqfisLA5re1u60WZv7uvDS6s
	CvipclKKh8Gp4bDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 913653EA6E;
	Tue,  3 Mar 2026 11:34:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0aJpI2HHpmnbVQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:34:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 46C04A0A1B; Tue,  3 Mar 2026 12:34:53 +0100 (CET)
Date: Tue, 3 Mar 2026 12:34:53 +0100
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
Subject: Re: [PATCH v2 092/110] ocfs2: replace PRIino with %llu/%llx format
 strings
Message-ID: <jgnphntmcriuqdplzxlgsolfp6nioqdwpt2n32w26xdzovpwhq@uvu6a7frmfhb>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-92-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-92-e5388800dae0@kernel.org>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1DC65160007
X-Stat-Signature: cmwbtrh758hijd489iem6g346m8fx8qz
X-Rspam-User: 
X-HE-Tag: 1772537698-665857
X-HE-Meta: U2FsdGVkX18rofJcH1X9KbTG38gF5sncW2bmockpNwBmAFQNiqlfnKbFEipLS6PKGQli9NmqpOL54kGsyyv6b/U2rGzVlH4f/AsTWATwZkrSu+V1bD1vagbHHUHK4zrumCdN2iur7J+1UN2xZiHLTm/ekegI4ygoA8nCEuD27ILLkj1Zo0dFvrpuUInbpBIGJamyP/MjuanGVJdrRe/BOLtWH4+kA1RZMLdwitlEFx3e2ejEar4BR+6UAvj9Qq6U+2eDCcGcgrbNV2RK8DvhbaDzOt9KUxQJtL/INQsbtgHYmVhvJ8mvSSQsA2yfv4jyhUADoDRFDMUIexaqYLgr6XiWpTjnVvWhkhfwzJvgAHQPmC+EImwptuPsNNpnaiOj0HxSvqJ3zNOgwzdXzN/UgEJo8JOPFDma2WwPOB4jkiDwKU9N/rzVCrJ5H1snU5zAA97RVqUN3JHSu4yDqZCEDDxYAlVV4aPP6TDgLpyaIGjj1zyBsKg6hSUsq423E8B3kO7Ai/nVaj+21+CtL5L9O5pGsD/en+Q25hcUyfxW0AbAnp5oUq910wcLQs7Aj1QVEqm4NsClgNhaVCwVLks18gcHO6eFAjRuqvDADR1rn200DyZ5l8wS37fzmNbqSixJjAnUzqHqqKqoPIT+NlM9shojrPLL5sR4ZfmXG1FVr4NcR6IfWcePZETRJE4CrKImeLHaLpBz/YHMbEJYfsEZLHO6vL5/QzQrRGtyZpEEu9tV5AX2GuBXch/m32HPaZKaCiGL9HVcQrWmiERse15TENJhHOqu992Zkj7uJ0+W2uyH2GzXzbgT2STEJ1mG7mwSWiKdTY4xe0T/NjkN+bWThXDeK8cVXwmr21515lX7BQTArYTzVbzBzqkcv/MbBw4UId4WEckueCxxHEpvLxS7EO4uPLgbofGDYdSn0g6afb9o2V2CPJi01GrIny+eKbXn5Jfxr+8i+ju6mFixuv0
 Mkj7cyL/
 Hx1HaWwx0sz/oIdRkvqv/799LUKboDfiuI3ULGYEIUE2DetlVQdCmG2tl2vu3ffIOQ0bqVhAaS+6SDubF3gKSKW27qXT4oBGxJmglP08F8+DxQpmfcuX7mvsQSbcHs1TesLZPHcPELJzukrZq3Yp797EcXfVOZGuA92PnhtB826aSidBSJQpFxba0/eJE6CiuQ3of1LGAri18Xi6GzpnrmzvbYWCPK5b9fnyXJR36uGDFuY9qLDrB4enscGJ1V5/+/vjgsGe9Sgank6faqZi8+oTIfOyuYxIbcUnt05O+MGPSVVai30oQXtIQ56Y3p5/65+HW+ha38j7nu/EnWNGtks0h+CMks+w8V+Jn2dqlCroEgSrLF19ThuzGE8CxRlS4XJnRCVevg/CbhYLkYwaftD+xoRb5uSpPrIGu3JKb/Jme93NRNAhjzb819KQAcGdL4o3ZakmsaqFoBztlkGaA+kIiaDOaBXbut57NVEIHG9mclVWo2qcb6hYS0BEjGntJ7IjSoKOrSAC4Izu03r8zXnf0UyL8UQyF4PVExIwndrGrr3a+tpMIeLRHVVwr6KIUHLoYY1DBcXlKQbDDOTxcGfVPPO+4QlkSDn+CSK8jcxS1ycogN95SXxramk5pAUUI1GSFckZ5Fgs69860lhc/5KZgJBgT4G5xh+eP8hn+s7j9UqSsi2LXXWUTFr4kr/N5TKGsJVryaZtd8dK9pnaFbCsnCKUFMQEiGOwVqhUEa/IFZiX71D3/7N9Klf6G/4Vpbj27iYCCDTGLiOO+3nomoF5vMuBBrY0cYC6Lg8g1cCkCYLUaFTgVWB5wC/lBITQYtsz0ZQDfaGMaK/yxzON/yEfoLozFv69BDP5tnUlTDAI43dYdcz1JTSpemGzFzI+GwyP4dzVekW34SFiD0g2pItQ1XOxLzeJf5PNNkSslnb/YMkFZXY/prFK3u/9XLrVYMPTkVlaSSlYuSEmaYu5v/fgWoP3e
 /S+1AAZ2
 E+IEX0RTvF5umSuO/83nrfCckxguO89fXfu4iVAMuz/RlzfzbA3Fw1imyUSnHHxBpVwj8OAarueitZ7gJzQwQBDGk0RrvAeQkcaEHysuIkV8qbDgzOlfDd+rR8rOy5ThwP5JxSatGtPcTGDa+SmEOCyDpT6r1jOAk7i/yKq+Yxfg2tG3PpmIDbJCn4129Mf4hXrudxkqdmWne7/0M3VfTwklEsvP0aXN4r/ecVQkrUguDbTa2VD+Si6mBnemMXFUmsoujjb49TDtXrVQGgqcS8PSokz2WjQCh62ca57Dx1rA4AxpoUpUwsivzIo7QO3yXkQTfK+u1LdkSmASzHDUNw71rCbpbPKLxhWw5Tx9fFqptLSAA3v+bnl2Zb1F5qMCU6fYmnSCY5In4htjbaKhAvP8Wu2iRXBCFIwPW/IMy3y07Ob5Ffju2jbXd45/a0GS29NGnZecPGfgGqqaK4q0ylnboS9Rr0x0kbXZo3jV2pKdedJGnBjj8ZEYFrA2/PfUViPwBazJppN1lNrw5byVKXdjPBuhVB4MtRkDaEJ1tBA7WLIcgcgUc1v30Z/35ou8Ux0AANmjneBfxvHlkUnPsC+ljNk/4dP7L2IogyKEqruBvLkky9ZOS0DlnTNMO+RsD05r6MwJy+k2hOYNg8+/+Nq2PPoWUSKuXQwEjbbevQPQzWZo/j0CruVMOOceHfMWdxh0HkEu/Mt+FrQ8i3RlVGTamEMLRDmZZFLRYQoMtwqJef8wXC7LaRB7y1205j3XmsY3F0mEWIfl/BNC5acS2uhpJENuZ+fZ15Ceami4skgQKtR06N25oKO9y3JUu0fymR8bwwJApTMKT3p0Z/i1j7hyjaMXB3j/dztAI8F097D5nt260HrJi6WURbsjVBlBHZp2lWZBsIn0YsN4kD82zcyJ4yJR1f4tsXyrvMgFokE58ClW3q8WDenfBJX7dfKiea54jwbE8Z7fJmEKGmLpoU4dtBN5b
 Mf85c/lT
 7VHj4GRuRys8QZ4iRV844V6XadbB8vVDFZXXWVFG1pcoBNSwDD/srLMR+IKA6kiAZOjdV4DoVOX6zxNRfAEWyIbZbI5MjmUK649qZ2cVdSvSFupMQGkAe5MBJni1RhEpsoa0AQh0hnJ6KDY8ppbn/nBu9usYat9CV055PLG0YubkNdmMW+Ky8XuCXVkqyWIAfBa3jDnCoRgU5DEmyt2v/TDP550RoJ4XP5SOEqfdPY2vx4ix8QimXW9u6jV+hO0lIG8hvF8YYZ/T29CJFSCnP6E2oQynwEOzp1Kr1KgneNh8nCk4s9h/4JkZ5HtnJDaXJAVAUdS9slh30DsUn1Cw2Au3JwCxDKoUFt3pZWYe4jkr51XYHu/g/M54mMx8KxsBGMjydLZsF7luyPqCSdZII1NdIAC90ILbwX8NdVsZ4/ymofCkWNe2uD4ihn4vmBCYlRz7gGTpd53EUutfkFNBzf93UQis++GLHDDXanqZ/+Mbe5sQTwbVKt37QzxHnt84Z8284vzRJSMpPZYeVx+C+K24CiGtRx8SYYA9su5te0NHsAnw164xHKhPMFKD3p7f+bw6U47mplTUCulHfAlZscmEDE97GtVgPRk2VonXyxqdOhI4cT/OQfqXwxNmaeR2ibwzIPoGfdZTo/dMjWKmfne4vXmwHLLZc0mlnc5rr4OdSeZOTXUS4LjT47reScTkN4mu3/GOsEE8gcGWmIjbxMsA3tGbrZSY4fviE5SLCNiU+Af2HYk1Iec2FsMW2559Hcxo+zUcvjul15GR2VIglgqpiH/pnMDeOoQxGgt8PIxoKeobB1bjd5kPX/Xpg34tpRr1ZA819ZJytphxzO+35TxT16H8PdgLXEiTla0bnuk5okkvtbTbCJ8AAbYgtmGA3iB36t85VVvVU2pPKSaAQWTs91/E0w4stwWEj1N8PXfzEvbeesq1Xe4zdlSZNtWbAziWzer1go4pN6uMcBFLeVsq7miC+
 vMQce0YH
 xXHuOwDpWvI93AYWnEL5Bc+agRFshDNaX9U792tsooKbotGmP+zrINo9JzyKVa/hUFSLYvonPlBCfhkZFm+rHV6sEKcqqVkkelw8h6c+sMH8YRJ9M8XTy8QMpyNWYyyvRL0GBo7BYSeZrXmyt2D/zYknLq+ve5CUBdBKz8JkQRksJ9WQgLqvGDLSRtNVAPEuzs+aWHVDbB5GNE0KH2Q4p66ucQQh9+5P8ALNEZhqFX+iFhPdB5gEVA4oNFhIUJK/9IqiJ2FSvw52OqEwjrvYGLY3IoXOU8ozNfYJZOvxvBFyUiC4vtOnpE2TDTPYM9qd2FjHGxSDdVLgoKcV6hyYxINET2gVBDzZJ4gx+vy5gKd8QSNHrCaFvVbF6j8a2F7ZXMMxR3AFQiynzDgQUC3oMI/DnvIZg8xOMWaP/p7EdrOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:25:16, Jeff Layton wrote:
> Now that i_ino is u64 and the PRIino format macro has been removed,
> replace all uses in ocfs2 with the concrete format strings.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/alloc.c        |  2 +-
>  fs/ocfs2/aops.c         |  4 ++--
>  fs/ocfs2/dir.c          |  8 ++++----
>  fs/ocfs2/dlmfs/dlmfs.c  | 10 +++++-----
>  fs/ocfs2/extent_map.c   | 12 ++++++------
>  fs/ocfs2/inode.c        |  2 +-
>  fs/ocfs2/refcounttree.c | 10 +++++-----
>  fs/ocfs2/xattr.c        |  4 ++--
>  8 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index d7703549645b548d9f5d77b2214a9a7c0af0ef6f..d40f5d205bce3675ffd37e0e6c228e88c1804a1a 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -7318,7 +7318,7 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
>  		 * to check it up here before changing the tree.
>  		*/
>  		if (root_el->l_tree_depth && rec->e_int_clusters == 0) {
> -			mlog(ML_ERROR, "Inode %" PRIino "u has an empty "
> +			mlog(ML_ERROR, "Inode %llu has an empty "
>  				    "extent record, depth %u\n", inode->i_ino,
>  				    le16_to_cpu(root_el->l_tree_depth));
>  			status = ocfs2_remove_rightmost_empty_extent(osb,
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index aea35b1c9fa3ce7327672c1862d0d1201c895c40..c7ad912ec7a0d6fffd09c3d38f110e5d1517d829 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -137,7 +137,7 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
>  			      (unsigned long long)iblock, bh_result, create);
>  
>  	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
> -		mlog(ML_NOTICE, "get_block on system inode 0x%p (%" PRIino "u)\n",
> +		mlog(ML_NOTICE, "get_block on system inode 0x%p (%llu)\n",
>  		     inode, inode->i_ino);
>  
>  	if (S_ISLNK(inode->i_mode)) {
> @@ -2146,7 +2146,7 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
>  	    ((iblock + ((len - 1) >> i_blkbits)) > endblk))
>  		len = (endblk - iblock + 1) << i_blkbits;
>  
> -	mlog(0, "get block of %" PRIino "u at %llu:%u req %u\n",
> +	mlog(0, "get block of %llu at %llu:%u req %u\n",
>  			inode->i_ino, pos, len, total_len);
>  
>  	/*
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index eecb2b1d2ec17fb4b3f09abb9e168d2f28f9b420..b82fe4431eb1f0811d81525237d02c5a3f3b021c 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -794,7 +794,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  	if (le16_to_cpu(el->l_count) !=
>  	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
>  		ret = ocfs2_error(inode->i_sb,
> -				  "Inode %" PRIino "u has invalid extent list length %u\n",
> +				  "Inode %llu has invalid extent list length %u\n",
>  				  inode->i_ino, le16_to_cpu(el->l_count));
>  		goto out;
>  	}
> @@ -812,7 +812,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  
>  		if (el->l_tree_depth) {
>  			ret = ocfs2_error(inode->i_sb,
> -					  "Inode %" PRIino "u has non zero tree depth in btree tree block %llu\n",
> +					  "Inode %llu has non zero tree depth in btree tree block %llu\n",
>  					  inode->i_ino,
>  					  (unsigned long long)eb_bh->b_blocknr);
>  			goto out;
> @@ -821,7 +821,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  
>  	if (le16_to_cpu(el->l_next_free_rec) == 0) {
>  		ret = ocfs2_error(inode->i_sb,
> -				  "Inode %" PRIino "u has empty extent list at depth %u\n",
> +				  "Inode %llu has empty extent list at depth %u\n",
>  				  inode->i_ino,
>  				  le16_to_cpu(el->l_tree_depth));
>  		goto out;
> @@ -839,7 +839,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  
>  	if (!found) {
>  		ret = ocfs2_error(inode->i_sb,
> -				  "Inode %" PRIino "u has bad extent record (%u, %u, 0) in btree\n",
> +				  "Inode %llu has bad extent record (%u, %u, 0) in btree\n",
>  				  inode->i_ino,
>  				  le32_to_cpu(rec->e_cpos),
>  				  ocfs2_rec_clusters(el, rec));
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index e96c1c574ff7dc3dffad58ce8536b7e337d3f6fa..5821e33df78fd92fabc7fe7fa1c3b3c62c50f9f8 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -123,7 +123,7 @@ static int dlmfs_file_open(struct inode *inode,
>  	if (S_ISDIR(inode->i_mode))
>  		BUG();
>  
> -	mlog(0, "open called on inode %" PRIino "u, flags 0x%x\n", inode->i_ino,
> +	mlog(0, "open called on inode %llu, flags 0x%x\n", inode->i_ino,
>  		file->f_flags);
>  
>  	status = dlmfs_decode_open_flags(file->f_flags, &level, &flags);
> @@ -170,7 +170,7 @@ static int dlmfs_file_release(struct inode *inode,
>  	if (S_ISDIR(inode->i_mode))
>  		BUG();
>  
> -	mlog(0, "close called on inode %" PRIino "u\n", inode->i_ino);
> +	mlog(0, "close called on inode %llu\n", inode->i_ino);
>  
>  	if (fp) {
>  		level = fp->fp_lock_level;
> @@ -242,7 +242,7 @@ static ssize_t dlmfs_file_write(struct file *filp,
>  	int bytes_left;
>  	struct inode *inode = file_inode(filp);
>  
> -	mlog(0, "inode %" PRIino "u, count = %zu, *ppos = %llu\n",
> +	mlog(0, "inode %llu, count = %zu, *ppos = %llu\n",
>  		inode->i_ino, count, *ppos);
>  
>  	if (*ppos >= DLM_LVB_LEN)
> @@ -301,7 +301,7 @@ static void dlmfs_evict_inode(struct inode *inode)
>  
>  	clear_inode(inode);
>  
> -	mlog(0, "inode %" PRIino "u\n", inode->i_ino);
> +	mlog(0, "inode %llu\n", inode->i_ino);
>  
>  	ip = DLMFS_I(inode);
>  	lockres = &ip->ip_lockres;
> @@ -490,7 +490,7 @@ static int dlmfs_unlink(struct inode *dir,
>  	int status;
>  	struct inode *inode = d_inode(dentry);
>  
> -	mlog(0, "unlink inode %" PRIino "u\n", inode->i_ino);
> +	mlog(0, "unlink inode %llu\n", inode->i_ino);
>  
>  	/* if there are no current holders, or none that are waiting
>  	 * to acquire a lock, this basically destroys our lockres. */
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index 3cf93a08f7a8946810ccd2de246be4d07a23b53b..eb5dcd17d43752c08eab423fd667b7c0363ba6a1 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -291,7 +291,7 @@ static int ocfs2_last_eb_is_empty(struct inode *inode,
>  
>  	if (el->l_tree_depth) {
>  		ocfs2_error(inode->i_sb,
> -			    "Inode %" PRIino "u has non zero tree depth in leaf block %llu\n",
> +			    "Inode %llu has non zero tree depth in leaf block %llu\n",
>  			    inode->i_ino,
>  			    (unsigned long long)eb_bh->b_blocknr);
>  		ret = -EROFS;
> @@ -427,7 +427,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
>  
>  		if (el->l_tree_depth) {
>  			ocfs2_error(inode->i_sb,
> -				    "Inode %" PRIino "u has non zero tree depth in leaf block %llu\n",
> +				    "Inode %llu has non zero tree depth in leaf block %llu\n",
>  				    inode->i_ino,
>  				    (unsigned long long)eb_bh->b_blocknr);
>  			ret = -EROFS;
> @@ -437,7 +437,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
>  
>  	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
>  		ocfs2_error(inode->i_sb,
> -			    "Inode %" PRIino "u has an invalid extent (next_free_rec %u, count %u)\n",
> +			    "Inode %llu has an invalid extent (next_free_rec %u, count %u)\n",
>  			    inode->i_ino,
>  			    le16_to_cpu(el->l_next_free_rec),
>  			    le16_to_cpu(el->l_count));
> @@ -472,7 +472,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
>  
>  	if (!rec->e_blkno) {
>  		ocfs2_error(inode->i_sb,
> -			    "Inode %" PRIino "u has bad extent record (%u, %u, 0)\n",
> +			    "Inode %llu has bad extent record (%u, %u, 0)\n",
>  			    inode->i_ino,
>  			    le32_to_cpu(rec->e_cpos),
>  			    ocfs2_rec_clusters(el, rec));
> @@ -561,7 +561,7 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
>  
>  		if (el->l_tree_depth) {
>  			ocfs2_error(inode->i_sb,
> -				    "Inode %" PRIino "u has non zero tree depth in xattr leaf block %llu\n",
> +				    "Inode %llu has non zero tree depth in xattr leaf block %llu\n",
>  				    inode->i_ino,
>  				    (unsigned long long)eb_bh->b_blocknr);
>  			ret = -EROFS;
> @@ -580,7 +580,7 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
>  
>  		if (!rec->e_blkno) {
>  			ocfs2_error(inode->i_sb,
> -				    "Inode %" PRIino "u has bad extent record (%u, %u, 0) in xattr\n",
> +				    "Inode %llu has bad extent record (%u, %u, 0) in xattr\n",
>  				    inode->i_ino,
>  				    le32_to_cpu(rec->e_cpos),
>  				    ocfs2_rec_clusters(el, rec));
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index c3076b450de3599291c386ceeb8b2d26e8680904..26025ba2656c66b61866deaff60a0da204745c4f 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1196,7 +1196,7 @@ static void ocfs2_clear_inode(struct inode *inode)
>  				inode->i_nlink);
>  
>  	mlog_bug_on_msg(osb == NULL,
> -			"Inode=%" PRIino "u\n", inode->i_ino);
> +			"Inode=%llu\n", inode->i_ino);
>  
>  	dquot_drop(inode);
>  
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 1586c42fdabe70056bf7f103d583dd9000fe9510..6d7f44d3e929d94f3ba6121cc30a867887e0bbe3 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2341,7 +2341,7 @@ static int ocfs2_mark_extent_refcounted(struct inode *inode,
>  					   cpos, len, phys);
>  
>  	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
> -		ret = ocfs2_error(inode->i_sb, "Inode %" PRIino "u want to use refcount tree, but the feature bit is not set in the super block\n",
> +		ret = ocfs2_error(inode->i_sb, "Inode %llu want to use refcount tree, but the feature bit is not set in the super block\n",
>  				  inode->i_ino);
>  		goto out;
>  	}
> @@ -2524,7 +2524,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
>  	u64 start_cpos = ocfs2_blocks_to_clusters(inode->i_sb, phys_blkno);
>  
>  	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
> -		ret = ocfs2_error(inode->i_sb, "Inode %" PRIino "u want to use refcount tree, but the feature bit is not set in the super block\n",
> +		ret = ocfs2_error(inode->i_sb, "Inode %llu want to use refcount tree, but the feature bit is not set in the super block\n",
>  				  inode->i_ino);
>  		goto out;
>  	}
> @@ -2650,7 +2650,7 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
>  
>  		if (el->l_tree_depth) {
>  			ret = ocfs2_error(inode->i_sb,
> -					  "Inode %" PRIino "u has non zero tree depth in leaf block %llu\n",
> +					  "Inode %llu has non zero tree depth in leaf block %llu\n",
>  					  inode->i_ino,
>  					  (unsigned long long)eb_bh->b_blocknr);
>  			goto out;
> @@ -2662,7 +2662,7 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
>  		rec = &el->l_recs[i];
>  
>  		if (ocfs2_is_empty_extent(rec)) {
> -			mlog_bug_on_msg(i != 0, "Inode %" PRIino "u has empty record in "
> +			mlog_bug_on_msg(i != 0, "Inode %llu has empty record in "
>  					"index %d\n", inode->i_ino, i);
>  			continue;
>  		}
> @@ -3325,7 +3325,7 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
>  	if (!ocfs2_refcount_tree(osb)) {
> -		return ocfs2_error(inode->i_sb, "Inode %" PRIino "u want to use refcount tree, but the feature bit is not set in the super block\n",
> +		return ocfs2_error(inode->i_sb, "Inode %llu want to use refcount tree, but the feature bit is not set in the super block\n",
>  				   inode->i_ino);
>  	}
>  
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 74cd6dd57abf71a69adef18863d057e48496ccfe..4d55ad963ac514b4b4081447af0992345facd83a 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -3741,7 +3741,7 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
>  
>  		if (el->l_tree_depth) {
>  			ret = ocfs2_error(inode->i_sb,
> -					  "Inode %" PRIino "u has non zero tree depth in xattr tree block %llu\n",
> +					  "Inode %llu has non zero tree depth in xattr tree block %llu\n",
>  					  inode->i_ino,
>  					  (unsigned long long)eb_bh->b_blocknr);
>  			goto out;
> @@ -3758,7 +3758,7 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
>  	}
>  
>  	if (!e_blkno) {
> -		ret = ocfs2_error(inode->i_sb, "Inode %" PRIino "u has bad extent record (%u, %u, 0) in xattr\n",
> +		ret = ocfs2_error(inode->i_sb, "Inode %llu has bad extent record (%u, %u, 0) in xattr\n",
>  				  inode->i_ino,
>  				  le32_to_cpu(rec->e_cpos),
>  				  ocfs2_rec_clusters(el, rec));
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

