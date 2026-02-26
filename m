Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 034E7FD8FD8
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E396B0092; Thu, 26 Feb 2026 11:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14BAA6B0136; Thu, 26 Feb 2026 11:49:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002966B016B; Thu, 26 Feb 2026 11:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DED7C6B0169
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:49:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3805B57920
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:49:25 +0000 (UTC)
X-FDA: 84487193490.28.9873F9E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id D18A64000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:49:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hAYgA2jp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zCgOS19u;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hAYgA2jp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zCgOS19u;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772124563; a=rsa-sha256;
	cv=none;
	b=ACG6bgLU3MviZ2NYbLxHSAcxjPyJ9vnnZoVU8dXQVAy5Uw61HjR8TFTbP4ddSX8ovzyf39
	sb/CDEylbS0fOurgEixV0NmpoR9Ws48lpGmuAlXuHjJdaTzVZM1j1rCXKfWGaa1Z14AdRM
	kP+B1Bhnz6qUdKNDW2kgUMV7m25WQWU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hAYgA2jp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zCgOS19u;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hAYgA2jp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zCgOS19u;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772124563;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNwEAWIsld/a3bTo0jTTEGruuvEsAoMftAo147KwrkY=;
	b=WQL8vEfQvxdn0NqX/TwavPNWAmlRQd7QIYvaJHD2cwYgTVSCAJ266+zV4oR9Bdn8f+k9Ni
	KZAyM0AWG2aIAhQ1gCNUKEGSq94satcB1MNd703jxX+w62EIrV45JxHMMNFwv9bi6YHne2
	WTD9uoHsprf53piu7J42I8gak3N4S/M=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C88DD4D4B2;
	Thu, 26 Feb 2026 16:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772124560;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BNwEAWIsld/a3bTo0jTTEGruuvEsAoMftAo147KwrkY=;
	b=hAYgA2jpZa4xi0xhqaRwMEM4MmatY7e7kOD/E1qjGdJ66bF2R3siOjYy5Y6Yg9dDfzUDD4
	aeuOtKCnl8v1QoxCgsTX8W1RjLx4+PdWc/SXCUL+OLAvf+woDLtaeDL8YsARBgnzpciH/g
	IVXCKBa3wKZd2silyKmBo19Po0OpWAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772124560;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BNwEAWIsld/a3bTo0jTTEGruuvEsAoMftAo147KwrkY=;
	b=zCgOS19u4C6rF6D6cMRbA7dGGq7ArZv1u0GnIvuUsaX35ZbUbgb8M1Ez+SVwqYgh9euqH2
	kmxPCc+6nDwXgTAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772124560;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BNwEAWIsld/a3bTo0jTTEGruuvEsAoMftAo147KwrkY=;
	b=hAYgA2jpZa4xi0xhqaRwMEM4MmatY7e7kOD/E1qjGdJ66bF2R3siOjYy5Y6Yg9dDfzUDD4
	aeuOtKCnl8v1QoxCgsTX8W1RjLx4+PdWc/SXCUL+OLAvf+woDLtaeDL8YsARBgnzpciH/g
	IVXCKBa3wKZd2silyKmBo19Po0OpWAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772124560;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BNwEAWIsld/a3bTo0jTTEGruuvEsAoMftAo147KwrkY=;
	b=zCgOS19u4C6rF6D6cMRbA7dGGq7ArZv1u0GnIvuUsaX35ZbUbgb8M1Ez+SVwqYgh9euqH2
	kmxPCc+6nDwXgTAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3626B3EA62;
	Thu, 26 Feb 2026 16:49:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GqJ+DJB5oGkrMQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 26 Feb 2026 16:49:20 +0000
Date: Thu, 26 Feb 2026 17:49:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
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
Subject: Re: [PATCH 19/61] affs: update format strings for u64 i_ino
Message-ID: <20260226164914.GG26902@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-19-ccceff366db9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226-iino-u64-v1-19-ccceff366db9@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Stat-Signature: ohfm16cpifhue57b4gqxbubi7isxsint
X-Rspamd-Queue-Id: D18A64000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1772124562-379429
X-HE-Meta: U2FsdGVkX18Hvz1H04If2OMGCSS0p98fnwf9kkYynQAELweUKYODxIidyjHBs8lwpbIDYRVEFp/wW5FmyUny6G4pj1N3j9tEZRMPxjao6EJuPJzfp+NgzZUzLqQBScNLQjxzqkPGrYXMqWQUCLJkPRnvXxvE5YMAGsici7QWMy19gouPpvn9wz1aN0l9QbV5XPR3y7zjiAAcpff034Qim6x0OcoYc0RZh3yt2VpfyVkEqHPMsw1JsKfi2mmEQP1tuA4tQosW1YUhsgtALC1eNV/crJh5zMWCZIrur397lOuz6Zn6vneHyQKopSI0nixCnYqr/ubX8bUdm8b0/UNmRcqgPxh3fQebeRZrt/JoYR3RanJcALQKqi7+sM6h8JxQeSsPoWN1ckQivil+BbZ3o1UAPPX3zs8zYUxig/WygCz9ta40pzHRrJL3IHSAw1ve0w42aILHO9/GiFKhMbLCBtKTZXyJOBNhpt7TupIW+rJFZkRTLyggl+DQFUA7jxzk1gpdlBhPUUDDFrJEfNOTffsTe4MKLdi20xRybhbMpwwOYvB73qTRw/5GUcLur+DBYJFDW9924h79CoWrZSw5poeEx/+u7rv3/64QZYVyxCO/a1VA+7Ndd8ItiEdgCZxhngEwGEEND0kHU8gCI+SWPt+GK2oUFf/x6xzw8fPeMG7o7BIy1F7AB0CxWE7PAuKdtoS2+vqbleqCpJbrl4kVOIh2G3pGQVurLZC3rL0Z43NhK/mY8QTgu05KC7NlS2rEUhXb9ZfYwAqmCzr5j8JIiqsh+wWE+GCAUY7BW118nST/02uGo7WWkxuE9XcD9fVUrjnORSVbpinbeTNmV6V69T69K1iThaVRN8TFHqdVUycn+V5OkPNG+8KQdDrU6sk26HhyOF1d0ZYRPQgvMOMBD+zZEdXFFeFApX2oO9RKnd2J2BmoLXyvwCm7ROiOuSOzVsZy36bXcqkN7wGpiXt
 XufoWbd3
 7i8fSAFl6qNgyGN7f6uhkV4Qzhf9i16nezhA0+csDu0/ZxFN4cdMl9pgifNjwN2DSoCAib7aBIy7Miel/T7to94ffQb8+ZTAtRaKm8cbjmy1DA/0KABU37ctRYksK/GoRSg+l06J7ewWQ9KHFlA0GEZjFdQpokiJjAyStv/26kHb2qOSZJuyJAXtTR+gd94/ga5JdYOZB+5otaNR34cEMUGBtAdJ6BV6HYnHDWLhZCwGQosjZaSWwik2UAwCyMIVIabs4gF6J/QQfMLuMUiD6WDwAUci33j+cJhC3tdrBZiePMMfCRYFiXr+j6HLdFwCiJkh8xsi+4GT/XvE2ivqulSWWmqvwLC36GehjydszIC/zGTVarj0A/RqVwGYABnqoxA75lItzuTn8TMzigqek3zT49QI5ghJ8XdDDXcJIhMolIeRTjjkhEzofickqvjeZRakNsi+ZezvgTCN/gdeoldE5FaQ13cEvrGYeDesms5T5HWvVGkKRYbtViOO5Hodrw/o/xOfY0O0JLniXwSk3b0BFVFsviQRHyT2WN171Z7Y6f/1coeBvIF7OHnNlRrGf97U4JgFeKT4agzqQb5DdpNsDPcA1icTYIcRCTS0/FL2TvbBEjIgycivhaPCXAVGxk8I0r0WKOyWDXZzd0ayT9oM4+HQKnHk8plQpQGywVkHOoycGCqCf81WbTxp4lr0qm03gCafN87wW10RgZiMsN7EnoIkTQ/+2b2QYUYPQNrq+viJm75sqLVCbdJOI20IkxxPzWg/MMMeOALDKc9AzC0drzUODwgIkAuH30UJL5ujkCnDJTWqYH0wTQbJUCEtK1bFxkyyfHCwRbPXgpQ9zbwGdruWVFW39/YCFozy0bmyB1buG4+Ya/cR38/6ZT8t3hkc750l/ycORdzJ4px3PD0lkVVlIwLChtCPhP3xzgX2dHMFfgimpgA7fsWk7pZtXjYCCGa91N77axqRRPX0uH4jafo3G
 g7YY4Fqk
 gPLZsfIFHVg2Mxd8NmyjB6+3HcQEQlKMGYUOlsoLsi4gj8aNveX6nb99D/hjS/cnb/Sk/8KQuQeWh2xBRRd4TmGjffkH2pbNTRBlLFayI5fGGsQl784MxmvihHm62J1U2eUbTgoNng2WEWNAbksowIGef2enSAF1nvUp8S8+6vYKtiZ9eJx56kTbMVt53d0omS+svqjQG04bQDg57Er5m3TYy9tJ5FBTzLBr8Ckj9JRv2Rh0E5R56wjzWTYENY02qe1gfo/Xbm5BaCawlQKjXzxI7R4F7FkyEs67JvR+j+gUlYA/NaVa5KoX0UawdnonQjyAo0Cd2kNCXiy7dM6Jk7p2QuUbxnAtyZsmIfEdJE9FzbzqkbFyj0jaLaedWIIA2xMGdvJMM5h8ULTSiNa6wf4V0t3RudrjhS6D733D/eI9mJ4ZZNUAn0CCzT2sQyJKa1/Vd7paDWbQaIbsfEblQXkpKnS4cxdNPAl8tadQoaUtO00VmGp+b8LGqmF69L9tfjMS/GZwstwSWByiTIdOmJ0m0GPPPjWhsO4ZIEIUiFY2F1Wo8aUPxQFmRo/EC7TyISn5nykfyJcU2Uxl3cOidbzjQmRGvzK9gXqumyO5NSRyeeGPzfnx7sAhib+TUaklCQzWCLhzw2hrJH9OJVZS8wipDaLrRVNHbLDwk3qw2JCTaxNfR4lkkWajqQ9X+FUVgnrQJYaBkZP2WRjjLPk6+eocRwVepdTGAPAGC15H2StV+eKX3tmCzRLwu+t5bVAnaRaRcaL6hdhI/sAsBVqjwEjNYRtJvU71O85ftdtdfbFTjGtFnvRXLOfZNKx+40gV7MxZCbvxkXOeuDu15dhns2kkQoYva0RYR4oprWee4NcbduoDVM2BvBZthiBjfXiyPHq2G8jl/XNJ0CkyUdYxRaztxbXQdavkgoaosn1iYaSCjkbtVQQeY4rWC2sqddq7hE3x5ZMBdigkx4aShdVEdPfqKZyUx
 HKOXH+q1
 CsUSaTS/hX0Jd6KXbXaSKA1p3bJzmP60ix+C5+dGB8QTQRj5p7j80MuuKCk+LKHNjz+IWdQxB0KdRJ0w0wozjZW3D7yJY2LSxo29lR8GhXTz3pPjuoocpGMhe5SNwfsmlNyitmhqhHgT8T6l8yElxP1ody4820O7K4qzB+gBW2ABiK0fv5cMqzscau7Yew/L8d60pl8TmeYZEqXquxuoXfUSe2SegOtrUz7hzKGtoGyxZaTxniCzDb6NUGNCWdihFHrgG5mEdnaWXo4++2/Ps7LlpOnsMfLjS9vTq68bXDB1h71nl0xXqjlIa9F1/6QCb4ukTNcTLAAJYyaM8eM9khFYBUoK92ODvl7jGMYcuU9GyTECJI1F9Or+RuauL6fWVfuUOysU4PbXTkS5KXgxaUtHbkTvLrHO0e+w1nMdEPtPUzZLNqHtY1/eTad8xAC5nfGKZ6QPNKDg6EdcOPfsH0DbSvTBqqb/agORGYdVnlhGgKqZiRtvQ63mQFCTlyPvvRRz9lm4S5fKP3OzFme7Y/FDuoaYVa3nu80NjyXaDjXsB3UU3NitsKlSqJ9z1cZcBZUQG+xVUfIvBfl4/7ew0W3PgnT90wJB2f3sqEVY6yPC5/vFG8di9Cc4ausMfxqGE/6r5C+Jyo5PRRfd7PcTi5pISIBffA4OIwkw9YO3VyR1xNtJTzK/3j8GQrDOT+qyit/JzPorSAYCDYb8EER/Ez42TML3Ei5iJeJwfb2Vsl4WwsKGJIlhSoUmz+zTazP7F06DPjsjGV48QVgpg/DjN6UaPyMdAulXdrDCXfa3uj62GfyCk0n3H9FzreDB4cJS4iZg4W92a1fHIfVdlotXo66v+sM7PoSfkduKOU7kp6ncNw9Mtq+yu7fFIa9YsGJykuT/qakx26FfkeYzEcubtWDaaCao9o+/giOApcE2d9OW8mGH6wPYSWJ7n0zsNbiJGm/MeLjzCkkQqglAiYXCJP3rhzcUw
 13lFHrLW
 Rta9wh7/1R/hkwzMrrps7mjR3D8iZIk1dFOu4/+Tstsobjx9apSPADt6wRAIN8OoOKX+MNGrL4LNfWhrLxVBmvh23vxabqfUrAKAUyAl4VCzkp/iYBxCx6ngivhkMuRr47+Ql9s0NLQ9R+mGPunTwH+QI68hBzRe2GHjVdkaELI3UXAMHY8qhO2dZvWsCV40uFzuyH6MSKgEAOzdbqksb4x6i3BTB6jDBTh/ezc03mEBQFbeE9g6SoihjECQkLhQysshcJq1+Ld9lcKHrTKaJpSKgdoAvuQmU8T99WiK83c16NE3oNiVIIIctS7fx68sW5wclMzDuA72Fwnpc2F+Dhev//laHSPoTCwiKOzrFluRBjXA4QrtYyMIOryBNuCyrFXkeWl7ZsWf9s3eISBoDFoJIGSSSRDU2+poUwgXLn49EV+fbTLWhYA+KVPAaLBAD47KCebEIknzgdQIWhIZ/OwJiwm1pZeYOax1PhUfHefuOSz8zL9XQ5AxBhmRK4nRvVU6t1PklR/Y+OYd5ZEUEHPqrhwOc+8o6jLUPMyNthVP/rIZ8CLjclc8tJjJkXTNNNXOQj33U+YPA3SF7HWoA1ZjVYInv7ffGGwN8/Z1hIB1aXM75e5ePsSiIw8w4mgxAWJJg4cKDyIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 10:55:21AM -0500, Jeff Layton wrote:
> Update format strings and local variable types in affs for the
> i_ino type change from unsigned long to u64.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: David Sterba <dsterba@suse.com>

