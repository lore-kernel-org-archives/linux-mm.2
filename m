Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6681EEC1432
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B200A6B0185; Tue,  3 Mar 2026 06:27:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC056B0186; Tue,  3 Mar 2026 06:27:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C1B6B0187; Tue,  3 Mar 2026 06:27:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81EC06B0185
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:27:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34DC71BD91
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:27:11 +0000 (UTC)
X-FDA: 84504525462.13.4E1B919
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id F33BE14000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:27:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="TNLv15d/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eV9smZ4Q;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="TNLv15d/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eV9smZ4Q;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772537229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJNIfED44CDmRM9QKnZe3vjqDvjr0r1+sKr6g16PVBU=;
	b=JeQSkDZKeKUTSbUyxUNe99koIiq2jXNtWWBDu1jb1d5ImdsyN3GaoxwdwedmPjdW9wHxYX
	lsiTQi3tgBlZMUKNsedQiUIIQhA+9dqjbah3wbL5rUpcDAL+pxzIFPA0/pKY9WaQVSouyt
	1VKOHavAPKPNd4KMyTQOpE/JyjALc6g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772537229; a=rsa-sha256;
	cv=none;
	b=PfmhCDv1HCWT7Xgqnhqhj56fin/gb6F1yk6HxWfdo6FhfwTuMwwsAq6QZuAU7XuJZAYsbU
	nekqkZREgcqVXzOM88L5bMLFO735C7/WASV3i3kT/u2pLD/w/dSMrmp091DfZ7dYT0oh5o
	bUsLiL+1Qr2/TQBFPpi7YWJVD5vpHBI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="TNLv15d/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eV9smZ4Q;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="TNLv15d/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eV9smZ4Q;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8E22B3F778;
	Tue,  3 Mar 2026 11:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PJNIfED44CDmRM9QKnZe3vjqDvjr0r1+sKr6g16PVBU=;
	b=TNLv15d/Q09vJ3yaa5rtyOZXJnqvcbR6rI/DEcqvgjcnvPlL2p7w7N/t4v6fp7iXBMckFn
	KI8390yLukozk4ihYQJERYEt3MZ2Xa8hOf2lyCyXhQaoR/0lyLYN1gFf6ZLwspZgvcblJf
	8eN5vb5vdtk4do31HPWR1TQ0uj9qGIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537227;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PJNIfED44CDmRM9QKnZe3vjqDvjr0r1+sKr6g16PVBU=;
	b=eV9smZ4QhVNrlGzngsZi2/ze2KStbs+OocyLFDwfN7mxjM/fsVAwO/OP45s9rzwE/ZjD34
	N/ABwqmXs1JJtYAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772537227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PJNIfED44CDmRM9QKnZe3vjqDvjr0r1+sKr6g16PVBU=;
	b=TNLv15d/Q09vJ3yaa5rtyOZXJnqvcbR6rI/DEcqvgjcnvPlL2p7w7N/t4v6fp7iXBMckFn
	KI8390yLukozk4ihYQJERYEt3MZ2Xa8hOf2lyCyXhQaoR/0lyLYN1gFf6ZLwspZgvcblJf
	8eN5vb5vdtk4do31HPWR1TQ0uj9qGIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772537227;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PJNIfED44CDmRM9QKnZe3vjqDvjr0r1+sKr6g16PVBU=;
	b=eV9smZ4QhVNrlGzngsZi2/ze2KStbs+OocyLFDwfN7mxjM/fsVAwO/OP45s9rzwE/ZjD34
	N/ABwqmXs1JJtYAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 764A53EA69;
	Tue,  3 Mar 2026 11:27:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uIXZHIvFpmkQTQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 11:27:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 349A8A0A1B; Tue,  3 Mar 2026 12:27:07 +0100 (CET)
Date: Tue, 3 Mar 2026 12:27:07 +0100
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
Subject: Re: [PATCH v2 046/110] udf: use PRIino format for i_ino
Message-ID: <m67mgdgcjw6hhbrluvsdipezmgzmdfewqw4dlkbmqlbxi6gv5x@bd3aqfjjcqsv>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-46-e5388800dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302-iino-u64-v2-46-e5388800dae0@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 9phoipruynpcc53muacwnex75ij5rgkc
X-Rspamd-Queue-Id: F33BE14000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1772537228-598877
X-HE-Meta: U2FsdGVkX1/SjdqBiUBDGrY0eh0R4vOBJn9fSZtQWUFg8+fCSOvMyDQUc8tXyyZ23XZetExyOcArAczaU6Wrn97Ne4bR6b7yOa7RUd6Yo9vmglZrzjgQrxHuopNjtujss+O6W+y0hSWC9WphGgfhuNXMiviMHp2bZukJXt6pUAM7nJGhZNSVy0iKV+eegD1HKAFuvVVuypoOEvHLmEkdR+TrQc4EsF2UHD5PRrSZqY3JP5G36dXmoDlECWEJJdbn0IyWd3kRyH/EARKTUxMmYatk3oBwKAwcZZlRVN/5ZzpEWKo5CgGMMyru8ZdKyoy0CwPaEgbidv4VloMt8E1ET8s/CwcNrwXA0PgU/QuJmu3QJlEY6daeWwHLnYmOZUIoFggG1skXNL9+zOf3rtSppL4PtyKvbgIcS3n+ncF6fppUkwuMTGEf0cZD4QY+1SgczOLgIviPeYNcA3Vu3VbyOMJ4PE6RBaY/dhckovl+pCYc6XtoywELCIzuvVnHcOVi6K0NJdAH0slQT3FfvVdbL76XBu5cgaAMJ9ZMBeYYu4+fmrG49BJ0T36D0Rhd39qXdo1pyF5hvInzTr+kLKBDI6AFGFYIdHTxUtBndy4VhMWjkZ8Ea1kD/sK0AaWoTxEBHUJzTRFoSdvnX2W41xwSgW2rVh15RjR1R0g2Fy8K0FrrVFhG7tDixcgEHQIE4t+soPSKnPpR+cf1BmxFuCQSpfaRXTB3aXLZ22EvuiZU/lpDRw0JOqX2PqnFbGy8ONuqjG3pZ/eeBRyodwzelq4UxktdJg2Q31Ojq/NHr393NpoZnlpZOomb/HZAXNp8EWtP06VI1QXsvV48z2FZ0/cHlOLzi0VBA2sOb84OO3tfRw+L0HHC9kJPc0cN5ZBui9jjC9bNPa48fDQTeysw0DAx939//uOBcUmiBeOnPP0f2K4Snqr/4PiX9xnQmzJp389OezCLu1R1w6iuDc4XMC9
 U5Uufw6T
 vf0aX0qmhb48sDLuBxGKMsmjHFJZvUyUt5avbW9ucn4UPjaOQi7xRcdlE+NJsQdveGU9DFuHA2xM82KnALfMEVXWLLtOPULJqrmkG3zVe2qcRg1FQxYQUNfRt4EkltavywquC4fbSDxk2V+bRqvM6EIYij//ouCyhVKQ5v0R1E+UapKlcddWAqZn6eSA0fQ76TBkSQEUpbfrnRhQlpQzTgGe0XSi0qq2tqW0GopnJHJRGDjWsOJafwMgSxafZX4IupvOnZu/mL31YojwE5iZDy0Tzns9TSiezqSSOci/IH8uRvVZSboQtdok1JDcDcdwwptiuq3/IeffpOO09KkHBVDqAMA8RfazebcpLhwFph1fdZJUFxnf6ZzXWk2B8SgCk+kk3UHrGkkdXrW+Ds/k+8Af7Z/Cjw6Uia0/z+DxbRCXz+ZEAE5sYMnlMYbNhXnjo03/oQo5sfsAg+Ra/tDxwtUBlL192GO/Gyo5NcAXkG7YRxtiCO/BM8fy/EbYR+x+iyQ7rS4qEvyNq9rrdmEwcjoRMDqbF8WeXWjQ3GhmmzOLhRcAsJhr9zUXKxnitO3k+Olyw8i9U1eCuFXGbIJLAOjnAorNCeBkG2mH1s2XuqRgfPoM1fUzNrGlt4SMxWhIO2obxd0+4sG0zE0ABJ4m7e4YUSnmkmhHgH0D78bIorBSbpI0oMNkFRNOR2E+QGnZ8oGV0ZPW2+458CK/za9k6jfofRmHPIIjKSeeQP/rGqG9MN2OLaegKoFb+hfMhpgMmfqWRyoWAirn6GP1A8MK+xAPrEOJcSebfqIvLK3qFir9UNTKtKGwh+pcEpKfr7CxxC6fb1XqAruzx9Oz/KEEwRK9Y7Iky8AV/YKdX2Z4uTecmXoyZIjT0FJfnj6Dr7xMxvD4BPa8ghvyUOdoSGPA8ijxlrzfr+vzHbE3yb9QH26f4weCIjFVo8T4N0DymCWQ7uWuD76npznoIT+T6dPbBJ9//iOUG
 xQgd0sBU
 9qNMyKh25+BRAgCUHjwZn22h8kM5SxRJqVRQ8+9emkBp3Vk7Ljpxl2ob7RqEpwC4hycXhvAFHDcJ3F7WtmZnNDZ7uv3EvmWX/scVdrtrx2dkK4yC6AcqxA6a4N7RKYORqh2ZpY3FQxR63z0Sy9tKLQ8pGLrtNZXA/r31/Imh9InYCKJKlJdexkwoXRqNGJK+udHPypnO4zW0BXcg8QGbu31sBq6kGNZRY4zR2PVcrtJvBlSKo5H585aSiR2pMQngqKUs/GtlsDNPlHrzFVUdVMFc/bc31PretN7/OujX9CqtQ8NHDJh38XWYb8YUm4HCtREtPQzeMOje5kuWvqlMb0IuUszIzXHraQFEmeCtMAUbTzQy4bokwyA14q6YWmC6ciRHYfOo06N9H++nmiDJgx+YbFyNcNXx2wL0ARiHzOs4LFZJBYSTLv1GghNM9n2xMrBOdCKouZ6bWIv5acVAfdsYFAF39IPyXDgP7w+qqIA7+5zXURHyiZhx+EfZSExrgrjt3yykir0fvKHKbQuPLZObYYuXHpYEJGGpcdd3qQPvRfEyEf59QV4kebG1uxxEysMX5N7pkxRS5dr0q32XPho6c+frssMTZvHXimPWOXlzJVC4dt1tUofG43D6VxIeaKyL64R3w7dysbTZKDrnZ/zpQlbY4k4OBM0TQOX8lMkuHDNgkrjnV+6TiGsJaazKTVsR21SYprAuv8w2vfrEuc2hHvl1BrvGpePOife9damEuOc+A3vRElmSEl+I25y/nGeu281rsaQvcOh1/C9zl4Q4Z9+oYz3YXY8hWnCP8bnTTbjzUHk8cSn0rgnr1HgIz3HAHcP+/dkD3JGeD13BiIm1TR39Vq/NfRPsr1PAj0oNyXIOEtHr4WIyxJPdF/pFP+JP2jdWTEVyM3T53Q3QuG/CVfgDPkAogWtfcTr+DNEl3opOtSRWaO47BPc7tpklK18rIniJ2d12ntEHLRH59rQ+XHXTO
 lLsRsv32
 fveaxgdawq/YCmj1CQhtlvmBwk/Re2jpKG9usAVdGhyxdKFiFVLJ/aFBBhkSJKsH3kQj4pUPllaDPXLuOb7hv98wmje1/uq8cmAvCJm8MyLupxyh3oox80JOI+FqeCTPp5nQDfNYALfv+shkBLl8hYdYuFm38La+t/CBv2mCeeg23Hq9gKfO1nCaqfH4yJANayErdqwXuo74dYYIHiFu/q1gqB+9XhQezcd3/epepG7Vcc/qDQmf+olC+I7V3F9NOIo7hWhf8IFVnnUVVo2iIH4mgiQO0OlxeeJZK/S4MFL3KetZRLlxZ7cn3QR5vPQXYqw97kHBDMjaNzDAc2yq8V7J2eVSQOg6erlRKQiQsfFEZgLMqmZcSho56IfqqI4ZsspZjSAYaAErk4fQPS1SsqHZp0SoJBN5aWEzXxgT7/EQ9dzFirSbEkwIW34gQafy2GjsawIe8HDf1YrHuGbgIhSfH1XcYQr1fMrd6CdRcuqdmiNdjgC86lq4PUuLpoLAOuSP4aR3leZ6yj9zGdlXXflQMlVUaPmIG07Y5EkIAzkLHYVkYQE3RJffHukJSsT7yedz46ikJFbU6UhHRmpn1F5VGa49sFJnmCKqeIrm5lm6uGzON9d/U+U+pg/e6OO3pfDVR/ai/d36SjvVf/xKWxMGmb3nISWF5UH3v5AT3ishImtOuHmfKi08ilGnfNcmc2fp+dL4PtK6gT/xJZoB5l1gEiMMYxN2y7jX3wYqlco8dJyFt5TnQGjUn48J32neUtjRqCzKYzj1r4kmtJNNNy767VFFpQ8E3zyUox6zqDr0RhbVXpOw8GLcOeTCCCmiyLD06171bCHB/yX3/v/DDZp/sU+d1t6YXOMVtOHRxboLMOqkWXib+sfofZOn4RxL9xt2Aolj6Jp6hsOJboIj93Fv7BnNAOj/LcVrWRAXBRuYiS4TdyC0IOOEukkR7BeZ/pySSy614WHfpddTvHqm17mIxH6tt
 R50VOUiB
 cm0U0KOhkgBecRFo1LZpIu4fUHqlpZR9dMh9szBP+p/TySx9dNW4dUC1qkcYVG6B1V+JQjIiMPXX08v3JAFKaJ81JudggvoCG8TDFZTwa9hTDLGNPgDrVGImP1Xtn4D4txDtJDZUrExlzft6LXTIkzTGYH+og6wOtnxjCFmZM0/7Mf4o6q10nDilUlAiLC32KlZB763bPQfQCq+OkKYLew+JwI2nzSC0Up082CmeEsgfrGyO0RHPA1RyhbGLJkVmZLigs1AWQ58Vt0a+VUacvQpXuUT7ybJYWasF6a8DYLN1ujv7ftjSpwttr6NXUIQzBNDKjJ2POardHllxoJiUYUKHth6a8CF1jcpZBfr9Kdxj5k3C6WgZlUVjmoJPZjZqvIKCQgmgx8pjlH7pVYEVKsMs6HLRANRchPVcf+t4NzJ3jCQN05M3HsaJtSFaXDwfQyCptSWx/RAiQMtN+nFhbb1qLpN2iKT3HqHKoZYVOTbdSsqydf00U2ieIQvwWHWI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 15:24:30, Jeff Layton wrote:
> Convert udf i_ino format strings to use the PRIino format
> macro in preparation for the widening of i_ino via kino_t.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/udf/directory.c | 18 +++++++++---------
>  fs/udf/file.c      |  2 +-
>  fs/udf/inode.c     | 12 ++++++------
>  fs/udf/namei.c     |  8 ++++----
>  fs/udf/super.c     |  2 +-
>  5 files changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/udf/directory.c b/fs/udf/directory.c
> index 632453aa38934a0b58b420717ec0674c85627ce5..c825e11c017f652500a3dfc83905679ef86ec570 100644
> --- a/fs/udf/directory.c
> +++ b/fs/udf/directory.c
> @@ -22,7 +22,7 @@ static int udf_verify_fi(struct udf_fileident_iter *iter)
>  
>  	if (iter->fi.descTag.tagIdent != cpu_to_le16(TAG_IDENT_FID)) {
>  		udf_err(iter->dir->i_sb,
> -			"directory (ino %lu) has entry at pos %llu with incorrect tag %x\n",
> +			"directory (ino %" PRIino "u) has entry at pos %llu with incorrect tag %x\n",
>  			iter->dir->i_ino, (unsigned long long)iter->pos,
>  			le16_to_cpu(iter->fi.descTag.tagIdent));
>  		return -EFSCORRUPTED;
> @@ -30,7 +30,7 @@ static int udf_verify_fi(struct udf_fileident_iter *iter)
>  	len = udf_dir_entry_len(&iter->fi);
>  	if (le16_to_cpu(iter->fi.lengthOfImpUse) & 3) {
>  		udf_err(iter->dir->i_sb,
> -			"directory (ino %lu) has entry at pos %llu with unaligned length of impUse field\n",
> +			"directory (ino %" PRIino "u) has entry at pos %llu with unaligned length of impUse field\n",
>  			iter->dir->i_ino, (unsigned long long)iter->pos);
>  		return -EFSCORRUPTED;
>  	}
> @@ -41,20 +41,20 @@ static int udf_verify_fi(struct udf_fileident_iter *iter)
>  	 */
>  	if (len > 1 << iter->dir->i_blkbits) {
>  		udf_err(iter->dir->i_sb,
> -			"directory (ino %lu) has too big (%u) entry at pos %llu\n",
> +			"directory (ino %" PRIino "u) has too big (%u) entry at pos %llu\n",
>  			iter->dir->i_ino, len, (unsigned long long)iter->pos);
>  		return -EFSCORRUPTED;
>  	}
>  	if (iter->pos + len > iter->dir->i_size) {
>  		udf_err(iter->dir->i_sb,
> -			"directory (ino %lu) has entry past directory size at pos %llu\n",
> +			"directory (ino %" PRIino "u) has entry past directory size at pos %llu\n",
>  			iter->dir->i_ino, (unsigned long long)iter->pos);
>  		return -EFSCORRUPTED;
>  	}
>  	if (udf_dir_entry_len(&iter->fi) !=
>  	    sizeof(struct tag) + le16_to_cpu(iter->fi.descTag.descCRCLength)) {
>  		udf_err(iter->dir->i_sb,
> -			"directory (ino %lu) has entry where CRC length (%u) does not match entry length (%u)\n",
> +			"directory (ino %" PRIino "u) has entry where CRC length (%u) does not match entry length (%u)\n",
>  			iter->dir->i_ino,
>  			(unsigned)le16_to_cpu(iter->fi.descTag.descCRCLength),
>  			(unsigned)(udf_dir_entry_len(&iter->fi) -
> @@ -78,7 +78,7 @@ static int udf_copy_fi(struct udf_fileident_iter *iter)
>  	}
>  	if (iter->dir->i_size < iter->pos + sizeof(struct fileIdentDesc)) {
>  		udf_err(iter->dir->i_sb,
> -			"directory (ino %lu) has entry straddling EOF\n",
> +			"directory (ino %" PRIino "u) has entry straddling EOF\n",
>  			iter->dir->i_ino);
>  		return -EFSCORRUPTED;
>  	}
> @@ -184,7 +184,7 @@ static int udf_fiiter_advance_blk(struct udf_fileident_iter *iter)
>  			return 0;
>  		}
>  		udf_err(iter->dir->i_sb,
> -			"extent after position %llu not allocated in directory (ino %lu)\n",
> +			"extent after position %llu not allocated in directory (ino %" PRIino "u)\n",
>  			(unsigned long long)iter->pos, iter->dir->i_ino);
>  		return -EFSCORRUPTED;
>  	}
> @@ -272,7 +272,7 @@ int udf_fiiter_init(struct udf_fileident_iter *iter, struct inode *dir,
>  		if (pos == dir->i_size)
>  			return 0;
>  		udf_err(dir->i_sb,
> -			"position %llu not allocated in directory (ino %lu)\n",
> +			"position %llu not allocated in directory (ino %" PRIino "u)\n",
>  			(unsigned long long)pos, dir->i_ino);
>  		err = -EFSCORRUPTED;
>  		goto out;
> @@ -483,7 +483,7 @@ int udf_fiiter_append_blk(struct udf_fileident_iter *iter)
>  		   &iter->loffset, &etype);
>  	if (err <= 0 || etype != (EXT_RECORDED_ALLOCATED >> 30)) {
>  		udf_err(iter->dir->i_sb,
> -			"block %llu not allocated in directory (ino %lu)\n",
> +			"block %llu not allocated in directory (ino %" PRIino "u)\n",
>  			(unsigned long long)block, iter->dir->i_ino);
>  		return -EFSCORRUPTED;
>  	}
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index 32ae7cfd72c549958b70824b449cf146f6750f44..ab8093b87dc8f21ce8af6a72621e2868fb4b9a82 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -133,7 +133,7 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	int result;
>  
>  	if (file_permission(filp, MAY_READ) != 0) {
> -		udf_debug("no permission to access inode %lu\n", inode->i_ino);
> +		udf_debug("no permission to access inode %" PRIino "u\n", inode->i_ino);
>  		return -EPERM;
>  	}
>  
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 7fae8002344a0e1e7e51022e97f1e0e2424185f9..ecc22aded0d287ccdfb34b42a0d82e392054f585 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -147,7 +147,7 @@ void udf_evict_inode(struct inode *inode)
>  		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
>  		    inode->i_size != iinfo->i_lenExtents) {
>  			udf_warn(inode->i_sb,
> -				 "Inode %lu (mode %o) has inode size %llu different from extent length %llu. Filesystem need not be standards compliant.\n",
> +				 "Inode %" PRIino "u (mode %o) has inode size %llu different from extent length %llu. Filesystem need not be standards compliant.\n",
>  				 inode->i_ino, inode->i_mode,
>  				 (unsigned long long)inode->i_size,
>  				 (unsigned long long)iinfo->i_lenExtents);
> @@ -1386,13 +1386,13 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
>  	 */
>  	bh = udf_read_ptagged(inode->i_sb, iloc, 0, &ident);
>  	if (!bh) {
> -		udf_err(inode->i_sb, "(ino %lu) failed !bh\n", inode->i_ino);
> +		udf_err(inode->i_sb, "(ino %" PRIino "u) failed !bh\n", inode->i_ino);
>  		return -EIO;
>  	}
>  
>  	if (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE &&
>  	    ident != TAG_IDENT_USE) {
> -		udf_err(inode->i_sb, "(ino %lu) failed ident=%u\n",
> +		udf_err(inode->i_sb, "(ino %" PRIino "u) failed ident=%u\n",
>  			inode->i_ino, ident);
>  		goto out;
>  	}
> @@ -1641,7 +1641,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
>  		udf_debug("METADATA BITMAP FILE-----\n");
>  		break;
>  	default:
> -		udf_err(inode->i_sb, "(ino %lu) failed unknown file type=%u\n",
> +		udf_err(inode->i_sb, "(ino %" PRIino "u) failed unknown file type=%u\n",
>  			inode->i_ino, fe->icbTag.fileType);
>  		goto out;
>  	}
> @@ -1942,7 +1942,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
>  	if (do_sync) {
>  		sync_dirty_buffer(bh);
>  		if (buffer_write_io_error(bh)) {
> -			udf_warn(inode->i_sb, "IO error syncing udf inode [%08lx]\n",
> +			udf_warn(inode->i_sb, "IO error syncing udf inode [%08" PRIino "x]\n",
>  				 inode->i_ino);
>  			err = -EIO;
>  		}
> @@ -2224,7 +2224,7 @@ int udf_next_aext(struct inode *inode, struct extent_position *epos,
>  
>  		if (++indirections > UDF_MAX_INDIR_EXTS) {
>  			udf_err(inode->i_sb,
> -				"too many indirect extents in inode %lu\n",
> +				"too many indirect extents in inode %" PRIino "u\n",
>  				inode->i_ino);
>  			return -EFSCORRUPTED;
>  		}
> diff --git a/fs/udf/namei.c b/fs/udf/namei.c
> index 5f2e9a892bffa9579143cedf71d80efa7ad6e9fb..32209549a31f451a486918e673a41497bef42e89 100644
> --- a/fs/udf/namei.c
> +++ b/fs/udf/namei.c
> @@ -550,7 +550,7 @@ static int udf_unlink(struct inode *dir, struct dentry *dentry)
>  		goto end_unlink;
>  
>  	if (!inode->i_nlink) {
> -		udf_debug("Deleting nonexistent file (%lu), %u\n",
> +		udf_debug("Deleting nonexistent file (%" PRIino "u), %u\n",
>  			  inode->i_ino, inode->i_nlink);
>  		set_nlink(inode, 1);
>  	}
> @@ -809,7 +809,7 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
>  					       &diriter);
>  		if (retval == -ENOENT) {
>  			udf_err(old_inode->i_sb,
> -				"directory (ino %lu) has no '..' entry\n",
> +				"directory (ino %" PRIino "u) has no '..' entry\n",
>  				old_inode->i_ino);
>  			retval = -EFSCORRUPTED;
>  		}
> @@ -821,7 +821,7 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
>  				old_dir->i_ino) {
>  			retval = -EFSCORRUPTED;
>  			udf_err(old_inode->i_sb,
> -				"directory (ino %lu) has parent entry pointing to another inode (%lu != %u)\n",
> +				"directory (ino %" PRIino "u) has parent entry pointing to another inode (%" PRIino "u != %u)\n",
>  				old_inode->i_ino, old_dir->i_ino,
>  				udf_get_lb_pblock(old_inode->i_sb, &tloc, 0));
>  			goto out_oiter;
> @@ -869,7 +869,7 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
>  	retval = udf_fiiter_find_entry(old_dir, &old_dentry->d_name, &oiter);
>  	if (retval) {
>  		udf_err(old_dir->i_sb,
> -			"failed to find renamed entry again in directory (ino %lu)\n",
> +			"failed to find renamed entry again in directory (ino %" PRIino "u)\n",
>  			old_dir->i_ino);
>  	} else {
>  		udf_fiiter_delete_entry(&oiter);
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 27f463fd1d89e8ae4844cd70c291d737aee1589e..c6e372d573885742745d3ff4b3b017facf228a32 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1166,7 +1166,7 @@ static int udf_fill_partdesc_info(struct super_block *sb,
>  		}
>  		map->s_uspace.s_table = inode;
>  		map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_TABLE;
> -		udf_debug("unallocSpaceTable (part %d) @ %lu\n",
> +		udf_debug("unallocSpaceTable (part %d) @ %" PRIino "u\n",
>  			  p_index, map->s_uspace.s_table->i_ino);
>  	}
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

