Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF41FEB3653
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 02:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B0B6B00BB; Mon,  2 Mar 2026 21:28:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322C56B00BC; Mon,  2 Mar 2026 21:28:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9246B00BD; Mon,  2 Mar 2026 21:28:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA3D6B00BB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:28:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9AAD513B0D8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:28:32 +0000 (UTC)
X-FDA: 84503168064.02.77C2A82
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9498DA000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:28:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=DCsfrE9H;
	spf=pass (imf25.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772504910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1bg6xiI4y6+7k2tjKhPvGRGK3TFDQKnfwBJ+EjIYKA=;
	b=kkkVS6ZlG51CgLCqLoA3mNOIM0itVmyi0WRPgoT06Id0qsSiDHhlQIyke0p9mJwqpSSzKD
	AtFM/jgz+/e/BQVCAI5D2W1gPIeOoDRT463ZefwOdNAR2FSAG5MDN3yiZWnJE6RsswJyvm
	VmPmhb0hQ0RoPJX4c6bcn77BMHkMWMY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=DCsfrE9H;
	spf=pass (imf25.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772504910; a=rsa-sha256;
	cv=pass;
	b=P2lIZgbSqDa/P8Dv29Yws/dkg7uqdr/OIz1rtSr0XEsPu19tX3wW94UmJA1Gg1tBIfw4Rf
	8bwbSsvKk4Yck3EBPRgjbRbws7xmE+4W2vfkEcODSAiCkvDna5r2w8fz2/sZ2ZneNLesDQ
	dREkuCZ2kNJhYyQxa2J6wi2fYlmlWPg=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-354a18c48b5so4570982a91.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 18:28:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772504909; cv=none;
        d=google.com; s=arc-20240605;
        b=kLJhFti2ZEq5TW5gNlq/h4XH1m8u177pphgMC+xlHtx2iphjWWjnDjSO4O7BeEQ1VD
         o57ayrSt78ab1ZwNdbAvHiNgfMFfIbcYL+J3CoYErV/K1xBRS67wroVebG1m80Kdfguq
         rr6NCs5IXt2anI1K32U8gSPcugNTipOl4oHrMtT4Nz8HK89Ti6DBAKX9yetZDN1rEutL
         y61sT3SViBquLynfuSeTno4ed14JKFoIyXHyYIXJZstsAYZSmrlVEQh56zDj4EyGIwXD
         345axbHTnxhBABowwRpGpMdFccyen0YUh5jLxiLM7jaMwk6TPnzfaQlhNcLe4KlIgiQJ
         4XNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C1bg6xiI4y6+7k2tjKhPvGRGK3TFDQKnfwBJ+EjIYKA=;
        fh=lBqFO+IBXzKRgm7QaM1IG2wIY3hh9jzUV1n0K6FSzDo=;
        b=b8IPNowXZ1YkaczdQi75nGUYvj51VBlrfzaLRzvJcqYYdDv5nof4HZEznHZCPMSmaE
         h2F7ArPXb+S39QPg7a+8C/OXNkhCbcuSH6LynVqD7T9nrDb846PBw+sZLWMTyEbMc5YM
         oKsSKeyvpZJGG/vksMD8kInqGr+cdNNiDK7EkfuJIOT1XS2HkO3q0doFOFE+6JiPibAH
         T1TpYE9Hia84H4y0gbzFTEfEUKPMMISL7ZIdWLK7uTB3PCUf6LrSOKFizcSKZsMtMPp6
         HCRKxV83wetg+TofVYtCp4WmAkG0MxpcrIA1yVzg6nVe+quie2dcZZuNd08F+43tOP3k
         VH3A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1772504909; x=1773109709; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C1bg6xiI4y6+7k2tjKhPvGRGK3TFDQKnfwBJ+EjIYKA=;
        b=DCsfrE9HbkDBgRJfp1T0jTEYfVS2z4mpVDaNZ27Jm4BM/oZ72OrpDfIg1ebZvlH1xX
         MkzzkIZNGoqzYdqpTpjUHmOsnTyqguuXUsMWFqAXmGcr0XL5Vy/cx3g3fsRgy3dNK2F6
         Pp7zV2gctu+4pq7HQQdEbaSNaSL69rfqWjsuydXjTIRy3z1E940ebu90zhV7gSxCTk80
         Rsr6t/SEJeH7Udyr36hFah13XAWAjOajAdVIZyCXPYnJrRag221kluLbTQSHbPnxn1Tf
         /7g+sEP5/ji8yWRsUBboSrUF+VQ5FJTo0MuCmaEKk5YzDfqCt4kC1uxQNbRc2Ko0Au5p
         wULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772504909; x=1773109709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C1bg6xiI4y6+7k2tjKhPvGRGK3TFDQKnfwBJ+EjIYKA=;
        b=wH8cjZeY98yKamxmOItQ3OveDXlV3iNIYKTE8A4JwVaWlJvaD7+8v3GpCBWHTLFXdk
         FnDIMnnjENO7oog0qq6yu3ksT18ITjEEQRyVuVBzAdDyR4XXO/KeRRLn+oHbFUgRY96n
         HP6/yANAzEzBl+kpp6DmQaJ1rAunZdm5wznZNMokQy0y0CmBmG4sNe+F3intxWJQPthU
         BZyHHVw0FTbQtkvt/WBOj7iANT3nOsfHFLRGx4WlyIcSB2jWen08EbEU2CIk8Owy4pwu
         EhU6/lBGm7ghFA1+1v+SScRirqbgTahmCag2x/OgOz7WQfz9k4geaknB5bmkGEktfw8+
         DwBA==
X-Forwarded-Encrypted: i=1; AJvYcCW3EycBeKkP4nkftd28YJmpxoBKWcxfaOxaN6onRPrI2kZ2hLxIRL7VgKzblpxssynPMfmnmbll6g==@kvack.org
X-Gm-Message-State: AOJu0Yy2Pu67yoH4dCWc8jMwvF7NpvZxTk44noffClxLITDOgX08BkSJ
	mTfMN0DHMvEgKVQHIMyCc0yixHIACeCK2+5X3JCDDJ9KSuJpOXZg5uR8ic5JlbjyL2G+Xe3vHSy
	MWK/+W3ynj1bs+yn8HNNQQsyMHppbMbyyg89enmu+
X-Gm-Gg: ATEYQzzU8tYRIN8S6CGWl9ME4oSx3ch9dLOVTw3kV7t1cygx6+zDVx0QTPg3zGosr78
	fIqCiAJr2D9SFwlglJ2KotHeQFm66RiLh/1nftkTg0y8SGcDk/t8AwSi0jUlFlP3MQn47mH9phB
	6szPrn1qLziWhlC+AawY23b4KloxjIxSMhAsVzlgDynMU9jHFTOrWlp2ZiLiFeETN+vuwhhlYCf
	nSBT2wAVcC17P7gm93+e8F8a4GDBzZtrxp/8ZherJHjt+GrMrR5V39OF6QKg7+KBzMUlfzrLK7/
	ZCtKFzU=
X-Received: by 2002:a17:90a:7f93:b0:356:1db4:8fe5 with SMTP id
 98e67ed59e1d1-35965cc714fmr9453563a91.29.1772504909127; Mon, 02 Mar 2026
 18:28:29 -0800 (PST)
MIME-Version: 1.0
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org> <20260302-iino-u64-v2-49-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-49-e5388800dae0@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 2 Mar 2026 21:28:17 -0500
X-Gm-Features: AaiRm53ToDAKLnqMzF7h_Rr5obeE3dnKPI4TQkaY52RSs5vb8oGyabc3Zmeif9I
Message-ID: <CAHC9VhRLAhMYL1ax3+LCeLLhnK0XGnvs0kGPGgHaptTaDynroA@mail.gmail.com>
Subject: Re: [PATCH v2 049/110] security: use PRIino format for i_ino
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams <dan.j.williams@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
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
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse <dwmw2@infradead.org>, 
	Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>, 
	Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	John Johansen <john.johansen@canonical.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, Joerg Reuter <jreuter@yaina.de>, 
	Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>, 
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Oliver Hartkopp <socketcan@hartkopp.net>, 
	Marc Kleine-Budde <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Steffen Klassert <steffen.klassert@secunet.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Remi Denis-Courmont <courmisch@gmail.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	Magnus Karlsson <magnus.karlsson@intel.com>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
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
	linux-x25@vger.kernel.org, audit@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org, 
	linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9498DA000B
X-Stat-Signature: fq7jasixwqa9ycxuhrbezse4bbowxms8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772504910-230189
X-HE-Meta: U2FsdGVkX1+aJacEZ2SIxzM2u6+d/8buh2NUqyjF7cmAFsw89+/6rcUzPOKasX5TZkyHNifOzmzMa5+3xQFtcGvdrDyeob8eKHtQSbigcm9rWMBLvowVrJ3T85UaUlYheBWDrvNEYgMfCO99UqL/8JQ2sEVlsrgIyeLkQ7EnhBJvbfyIiwFSiGKJ3bQlr0dUT7S59/QucVh2a/zh9nz5624cb01Q8YXOQq7cC1wq/eHgNFOKDGVEcwYh3oynCUHbrRdub9tEEEWwvzyFa+w++B+9o1TI0BEE/lEHo5/q6e+PJk10xQSa0wJOi1oEK9jGt0gJX6B5APQFbGGKA4Q1oy9Flmxu7/qoH+8iT9xC/qmTVUUTtGUDqS2boMW3dLMEYnsMjnbxGQhCTuQ/+FT72nwK/3KE5rabeaRLx1KEeEVoh8XSzRjq1fu+Rx8H3cmF+ZyFZlkgT250bpOtuYkCcnFNDZyFysLMgHwmijJo8Uh56PnXnMPWWXsVnQt9vmfxeoE8fsf3DtPKIYZfC3fVBJqP0ZEKOy4eD8x9rM8+/9stnK774dqx2uM1+XzTPG3JZghnQiB0cFSWMRSP3rOaCQ2Y3gcBhnBabHBJZCLyGiDXdsTqf/ElSIOokYrZlK1bNZgjFkodJeaaV4TdY1+lOLANIZ7xtFAsneQx6vMwGSo9RF96Qwa5GNwC+/BRrwEorE6QiAUU1HVt++3HgIKa5LJBCqvctTRDpEHoVBwI31nwEa7Tw/xqnzwauAHzPvkSXw4WEEFD2K2QqYGqk7HoipiDBuBkfSxD/3rEO1LOx6UyYoV5TdQ/GBUGk5iu2ju9vwb7Sdi/a7tO7d5rXEEnLzkN4lqDnD39wF/wZminXtqMc+uOrNAdfTt8ebDlbBAI4FzAHl5O9MJKT5eyIG8X4CAFpzyF1hTKHws03lQa1CV3VYft24qGsWd7JiAzx9pa+Mf/AuXt3sgSp4WQV4u
 CctTrnif
 +8eoyOAjiCr7OFei5WzS4stj2R95UW0/GvdCSvedq02cowj+ovNafqZ2cC/+gvVhplCvqNDcLRKSw8a3zlIlEliuJ8ef74w7Th0MknijCNukxkcpOdx6tEnQNl89fyDorz3DjXkMluf4/xlmejf40P0kDm3d/x1Uyy5Lw/OxmGRnckXtcuFITlVga5nTet6IbNG4IT0ANW+8JPETQsxpgrea0pirg26XK4yKyHEBuZX+zC0gWoJZRwp8qzvGmFTaiZoQwnTqnoTm8supytb2wlsIeEnTmSs2AbbP1so06OtlYNn2TxUlr6s6THEfuoFNTLgg4ep1fMvdP++9Gfee3rRCelY2WQF3/Ue8NZvl4aFPE3BYTcp39g8GayoE2K4d3Gd89Z4J+uehMD2XcNV12HIj/nqvBvTEp9HdyOXOCnVs4kWGCJ2YaLQwkH8NC/+Vn/jIZ9rQW/Fp9YzDAa+YsGjD2BpZP9vyb0cXXRJW9o2RBMWzgiC4Taj28DI1ye/KacpWIut7U1hne9N7qOrMBkao44YxwSIemtNvNyv4nBahnJmlwS1LPHge0uYbwPlA2W8YsCkip5U2kVGydNxvfIEoHr4Fya0km6x5sI3WGW5cvGOmaWTK6wWrTGwIglK0xQ+cPPPEPj/Dn1F3ZJizRWlOu2VqHIwKPFovJcfTtH4QHuaPUKTfyQLe1AoTt2daGy+W02qURzaPCvUs10gouRkHpOC9smSLATOjJhoP/jLZC/YsXk4HWkaMiR+IY36TtIkLqnEzOagh1cT3eDLffM1u387R9wfqqB/uY2KRV1Pbr1QoXqsXooAJ8ZyqAoMtY1EFNwoC2vz5wfMH9KwWnOk05+6q/7sx2Bf4kWae29mr01H0snIt8OKqn9fT5XZ59kR1ChIUgGXlAz4FgBq6sqOoELpR8LPv50QA813GteqnwTYc3u8+MBqkeL7HZNditSoraR17eLwhX4pa6GrDWDOW/xVaW
 r4dohEXx
 bKnTuVPpC76KABebWTLH5Hq7yzuZxuBqP9nutg9CSdjrvJpLj+BXA35JNoxYPTsAm3Uun1KT5SYZOPjH3MTGzs8thXufJxVojQnJrC2yt98+L/h0NeXqGtQiqpodvmXcDoT1U2m6JU36u6t+fj6wGo6hwvVJzbKEI2tityutakJu0yflUHdDugmuis6YBtNmvvn5OPJHYLPrwGWLjV6SKcVNz31nWSxmPDTvrVcTKxyy2d52uwisYPLTcc1pd8MlfRAesuY3N42992H8UQTKcmPMYYvVlWcj9E+TFWaxz9bNlCug9QHICgv6C13kanuAbk6JtoM06+4Q42MSIZZqSaZ3DzgEQmDlH0b/NcjC8J2gsyDn8LEIY64LyUxQWJK9pKaZ5UbeXih8cSjyd3A9bh69/9S/GR2g4+eVUF84LSrYIFMuoBkqxNN/bkyuRAA2ovffzUDhXyP70j2qew/gHIc9/vDq2+dTelDVu+ts30VIpWOEUcrElq5f6xUZrfyq6pbVtxlDgJWds9JpzfOhz+SE/qWtUdy8pa/kGrkq5k4xyadbSKq/1Sh3TWTHESVMTHyDa8yrf1DYQRALZAUmHx70VBDKuWoLHf7Or55gzxWSZjR01WqSrz261f2XxNHUDNpur5RrdkGjomHKDqExhul32x66TmbeD6wUOMUCXUroZ73Jhk8xK5v6+Qp7ux+DRUN0edBOoGyhczYmyVxziXqk+/dPL6ErMD7JOgSVIkjl7jEmsppG9WH4a6c9bFRinhge91r+p5R2JrbXGTJo4eeJj9zfSUpm6nd+tz8CPeT2oETuSiQSy37WD7/tevkZAOAv+ld3po0T1xgardXE4BICcIPnPFyxLpDYx4MJrcl1/y4YvjcfFluQBK71eFk0j5UcSxoJOvUUhpnE0hiMABYEDuE5FvXrmgVcVtIs4SYbtvKjO36Lvnd6w/qAJNrOh7nBCXxhlovJgkXxVSX5v4TXLWzu5
 uoU+iagm
 Lszg1zday8nzSfS4v9HVGRKvferYdtUSdpJcYZK3Ex4iNpb4bnpqYHBcuPHm6lKyh/cwuERy78nw7Z6VKBxjTzj43MdSUZeU+olX0KEzIZvY0imjhr4W0NX07zIQUZDWkr14BtnbyLnx8j/J4NLDMvKd2NVm8zpP6a0/FLNx6cgQ6Zr2EWpC1lavIraO0E4YNjSl1gpI9qfNQ0ZRpzwrRkPAOssfjbcO34j3GmySa0YN40ez6o/SAMr34qosVNam0sCsC9AdmI1fygJNfhB/+XNaOjLTjgjSH8jBIwAlpazBfV+W4JjhD6jwZEaq3FdEokOmoKNuRhBn7z4MvH8TyujteQuIpk8alYeCT9XpsZAtEupcdq1AUHoGcvsLMR6ih6dTjvr7Rt6sGKrOYXkMXusyP9jL3hvg1rFL8FDQV3jlEoU1glBFo9U87U2s1iKcZTylSXCmsWJ0WRIZG7GvIfMSZnxPLE6FLp4cVvYK/I/XfEBJr3Zdl3IXyE2tTTfJna4EJW/2kEI9TK63lh2Cd+P4PZKovq6F368Orn6xokgh+lgz1FYbq3rwO23AICVjKQiuK543TgDJtSGuCMETGoMN+RYsliR6gixlEFst2gJ9JdD+iexVoVNoyMqDr+1GPNfnOsIPG8giR/lfFWQ9a0hybY4NaG0bDllO0ZxRWA1QFMi7nO297/Fbhh3vSSCmmRy1sFbaVMlQl1BDh9faT7w3OdSTLq/fgxFnbq7DH06tG7WdYsOkw70MFke9t1hbUYNWYAa0gUnBGY50ALT2ul8zR60Y4frgYOxLWbso2m47sCOmZ3hO4d052kaPZskf5ovUg6mluvYsW31EdY24HJJ6erFoaCruLxexliV6DieXuQjceImCE1FiPDzBvqVi6wy3obyL0fDmX2n6U6xTRQIwG6JyLNzEPz0CcKTdSo3lwRVcgDHL+fIJBZvRY+DCMf5kqZiRnLorTo7rQ3SteSumBKitX
 CY8J6UhI
 3oxBobCrbttLm3kE3Qkhrt0Y1pMWM+kPbqKZiCDH3TP5zcb97IywRv8zXxwWZTyU8F9m00PfmZlQzAKjoEQghhXdpaaSfCkxoOqeL6nr1LXJg17xioNW0Wg3ZDg3tibtu1sUANwB+84lzbzxLLG1vAOlYLwulZRB3Og3q48x+aHmbIUHLhYKtQLLO2h/0T5fic7b4UJ0ZI451eofeXkWy5jde886EHSYQ4mIqv//G/GZZT+S9ccyeNFi3VjPDsnqNhgn98JfOw1F6LpAl6/Bu7yMaVlaFF87WXFoJ/s9yQCSYxkwRk3eoSPS+05wkedZm3CcCWrk7E+OeWkmFQH07hTddOBh485WyqIg2r8JfOzyhC/K+NqxP4DxO9koin5pqElQ69c8JRRo+HE3JM/3Xta3/pf79r08vk90b+on9SmiPnvrC+d4jSUFO5HuoOglrph/uLiaMIGeUsd+limAsf5pO4/qREWcu6DD3Af2UyT9o0Q+68ynJteq28HOSz0MCPk2PVhZP0U7+b8CfS5e0H4N3/OhBk0FDHoq9RNLLdWToDwc09ezsaDrYB3oRdyOlhpC60qR4Z/LdIdMRB/Pru
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 3:36=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wro=
te:
>
> Convert security i_ino format strings to use the PRIino format
> macro in preparation for the widening of i_ino via kino_t.
>
> Also correct signed format specifiers to unsigned, since inode
> numbers are unsigned values.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  security/apparmor/apparmorfs.c       |  4 ++--
>  security/integrity/integrity_audit.c |  2 +-
>  security/ipe/audit.c                 |  2 +-
>  security/lsm_audit.c                 | 10 +++++-----
>  security/selinux/hooks.c             | 10 +++++-----
>  security/smack/smack_lsm.c           | 12 ++++++------
>  6 files changed, 20 insertions(+), 20 deletions(-)

No comment on the PRIino specifier, but the LSM framework and SELinux
changes seem complete.

Acked-by: Paul Moore <paul@paul-moore.com> (LSM/SELinux)

--=20
paul-moore.com

