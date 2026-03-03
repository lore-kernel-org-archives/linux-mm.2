Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21ADEEDA68D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2215D6B0005; Tue,  3 Mar 2026 11:03:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F94E6B0088; Tue,  3 Mar 2026 11:03:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0E86B0089; Tue,  3 Mar 2026 11:03:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E86086B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:03:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E35D57801
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:03:36 +0000 (UTC)
X-FDA: 84505222032.28.136F53F
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 637AB80002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:03:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="NyFlAl/R";
	spf=pass (imf02.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772553814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCKOB8v5PMk665Bqff0+UwFdzmHKS9yVAUuIB18V7V4=;
	b=pjcw67ZISL7alCT2gbDO/QyxbPM3RNr00D6GUrnwpauONDkdjuEKNHypw3x8h7EPdUeZ17
	7EeSFP8xGFhluY1nrePZIeYWjEG1MOrupsrVIepUv5MuPIlJO3VxBEtOMj7MUt/T72QxzC
	+5KHm4q5F9ZM1tfOG+ZhETxzL7MXAKs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772553814; a=rsa-sha256;
	cv=pass;
	b=hHwUhnsU2KctOWzy9YVZ8K/vodlHgrbu01e5qspBw/1sdBWg1GZNc5O0boVeQ4bvQWeJID
	0N78gHDE1/PdjH2rpMMOQhc+UDAALQuM2GN4fAv0TBokZQNpP8H9GdrMY1qnat8VRIeFXj
	G/A0/96nk635kJTl8/44U+jiBIMDK6I=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="NyFlAl/R";
	spf=pass (imf02.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c6e2355739dso2380989a12.2
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 08:03:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772553813; cv=none;
        d=google.com; s=arc-20240605;
        b=M8ohKqhYNI8BJ6wI6BEJn1MGZIioRiWQfIirZcKXZMgXPQB22xXMOGmawzlpAHCzEN
         +LgKQFl84vHHq257ofQWUWr3xpUXCtr4vObAIbrFGKTNjbKaSO+uvUzKD+8/bAVggk7h
         Ix3tbKwQk7zHz86qFZUXKHkf3pIjzxXV0oa3hYzgQ03KsFfnEY9UJvsUyKPm+VorLjqt
         LD2ARDLCfK0jJ22AUQwhHggHwhGxHzqgWcAIfjz6al4WalqvY71rjI+2sZvNKHmVk3xo
         FTO8PTr7DqpCekyoMq3W7dLvdY5l9XOKXi8JXRivAy8ttpdBojCgkYXY1yF74fSH0aZZ
         rfHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HCKOB8v5PMk665Bqff0+UwFdzmHKS9yVAUuIB18V7V4=;
        fh=zDUzjYYU8Cd0EuwEv2+LtInHwwm1HlZIU8HJVUIwpPU=;
        b=P31FpKbWasVh6v0IjDHGvGauv3Ycgkpa5US2fQkWaWrIbw9/ql5YaVVNM4HAUYHsFM
         Y4nXxNE0MLo7JY1ruJ/YZBuCeLJZL+/HaR1Z6V6tDr+npMz3jNbW3BY5j+ck75dexgPm
         GWSB1Dgda0aJtbZtEU8nU4zMTKR6dsm5deoeW1VpzaJ0Fvol7wGZwqu+RRU8w/8YdvGa
         d2mA3WOudsZU1kR9MzAB7FXPDp0I2Hy9BC6hfc//e0BIVaRFgYo7cGeNfNtPDgC8XEKL
         qaB6U+hxYJNoIcZV5vq3cTyfI9D0Isf3VEyHQVu53sfpxx5+m4pW3p8y8VZR4CBjaocJ
         ulLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1772553813; x=1773158613; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HCKOB8v5PMk665Bqff0+UwFdzmHKS9yVAUuIB18V7V4=;
        b=NyFlAl/R5E3y6uFhXp50xGc7KE6w34fsYXxRkVjLj/LQB1flcFxfU5Tcv63FmszfIc
         LwrawNNsSQ+hMwcqGpcu/87lUa1xTj2cahWiqlmrHj7rF0HrutH9FzP2LS+HywHohfa4
         NTiJQxsFgKke+Z63Y2lxNld4iOnwwEPEBZpd64LEd2klo/IxoO3j7/9ciEmEavidUEEo
         yIiVsMCs6vYuz0aOgAxx/6WxcxfRhgzDW8+81+cKbwLls1Nmr3181eM1nO53vhW1IpPr
         HMHtUDEB/xMbg9el5K22TEAn0JXc9pw7vUCcBq2Suf9gRPFAF8mU5lxJblKcE0yxqgwZ
         rXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772553813; x=1773158613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HCKOB8v5PMk665Bqff0+UwFdzmHKS9yVAUuIB18V7V4=;
        b=RND07qxBwl4XUqSchRFTMUcTXrdDxqkPfAwBtrAwzKuQZrxHA2ppMjqkNoFlwesZzG
         zS06x+pS52V+DAmFBR+8e5/33orhoHr4tRu4OQsO7UByh9YrF/XCr3esgHEDPDzYL32m
         a+yFMWjMDTEWYkk4n2tb5FmEFneyccUfY0CTvq2ng/sKJbefPnCsptrtTWVDbVFbHDoH
         llD+JVXq5ptaqGbBbNVBHMG9s0kdn2QsOn5xvI5d26VcUyW1QX0sUhHfRcSwgdWN+1nN
         XYa0f1hYeda3li+OmX5GnVlnhtW/ln8IHcY2UeWRjJRk5SxS4RkgY2NrNNUAczaJr4LP
         rB4A==
X-Forwarded-Encrypted: i=1; AJvYcCVRLSdE2MRtXnWfDNUvXF8lH1X4VlZgY5fUah9JViZCcULq168x2gslJccMIrq6xW06KqHe6MhIvA==@kvack.org
X-Gm-Message-State: AOJu0Yzp4Lq4d08ndYcIxRTX4ETq+nG+Ja42ccoffZGCwBDzeL3du6MP
	NMSOZs2bGtspxIghM2ldxh03nm81rZqSil3yCcIa9wrAFIVxFn+lZDb/pciLdWVobr5x2GEW+5S
	Wsvb+GTrM9Q/gQvy0O5uJjaNepOU3geWk6X7D+uEP
X-Gm-Gg: ATEYQzyilDnXSTVoJ3GaErLHwZqLxZVy0J8043ZsVKqTxhRrMUAzyJ+oQgM6ZxE2hfR
	t1+A4zjv3mJANaEkF3bgrCzDpx/urhRE9KMAqKl520b1+e2m/hb9WCNlkHle5Qlku8P3PDUuIbE
	ppqs1kQpGtX7sCMXtRloysdKKKIQLULr1eO7FLvoj33GIfCMG67YzZgwLKDRup8lsEMAro92uM5
	scTSWB6rERpVqNi3IsixwKrvPf7ELmXhRTmMVdu6nJ2lOk7lg83XwyqO3sf9KX27JCoICVZXtaX
	mADaY9I=
X-Received: by 2002:a17:902:f60d:b0:2ae:6457:30b4 with SMTP id
 d9443c01a7336-2ae645735cdmr15498765ad.36.1772553812817; Tue, 03 Mar 2026
 08:03:32 -0800 (PST)
MIME-Version: 1.0
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-3-e5388800dae0@kernel.org> <CAHC9VhRnmBuXEKkUPQhJ_LDzcksjoAJL-ne6mFoJdR1hnDdzsg@mail.gmail.com>
 <7a0165fe39e82a1effd8cce5c2c4e82d6a42cb3a.camel@kernel.org>
In-Reply-To: <7a0165fe39e82a1effd8cce5c2c4e82d6a42cb3a.camel@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 3 Mar 2026 11:03:20 -0500
X-Gm-Features: AaiRm51FwCY5Sd0470l_ykVC0rIb7qnpGdc7B1bNvF1bAK1vXw1y1CZQ64VgwhQ
Message-ID: <CAHC9VhTyhnG7-ojnTnVdh_m1x=rKxw9YEH9g7Xp9m4F78aA5cA@mail.gmail.com>
Subject: Re: [PATCH v2 003/110] audit: widen ino fields to u64
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
X-Stat-Signature: oscptx468yj8canjx9mrgpn1ym7nbkao
X-Rspam-User: 
X-Rspamd-Queue-Id: 637AB80002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772553814-862518
X-HE-Meta: U2FsdGVkX1+sznifq8IscwOFUWC5EGfvf59h4WdoNNNLVLXLfGs5zokIgXsalIv2aVR1/RyJ1ov0FbQZX1LgIkw84IG2YfJeZApAAifLS8ClFA86LMZZ+U1B1DNxTxagFUpKgRM14DBXzAeYjVUg1rJxNLX5H5wlDti+hN9fzPVC6T61CpDJgNN4Fy+C6hiNlcyvtdJHJPAC5VYb1oGN0FwDHzP15zizQ6uFFjVgUG5lkjbF4TyKREjrHL2IY/tCCOms1IWmFqaoywtJVZJqt8Nx0xGSm3STOZJkLzGB3vDZR6WhGOtHxFX5Oxzs+/mipXtn77yqpeHCPKT00VllAJBGu1kZBoZ7/FyJRzX956XCgC4N0XOHLmASDV6SRhfdnctOi2ZHjzGdjxKUU7x9b/xAacti5bmyiS2Ba37cxXz/xc762ZVDwjayaidYZKhAhRuNTT3OQ2MXDUsEePvmduQoK+HT1J0anjHcZ37QIiaCOJ5Ki2NwHXoB/iecJUjwIraXFfu4X//JbcEUriFsYWEXCEwGVIdvVKVcC7O2l9OJv7kWfek6UMuK8hhsEpgHJvqPkRHnrTEVgHnhUwXiq892Ims8dkPH3WBokZafFyuCjrsNGH1eus5DVYMrRsbrbqPaZbLBBK68BPW/Eu12ebLxc50KUftpds54MmVLI/mtjGzghVlh/gZvc32J5umweA//zlSxALYSuvAHSJcLXGwpmhLYUwurOfhd/CsjZ00i8xYXLVZnzIIPyQhNngt7FNAC208bmF1nidnXuF0eK2G0PJvww173VSL1vWXupTvuYT2OswL+ANs8DBg1Yd9qt9cIOP6rkt8oiLaKvcRFTAWr35EKycDHDggwjWncn7J3ZvJikAvZJRvJHFVb6/RxNzoZtCRCcSV2TLMRv82mMXKCaF9G1VzpuVCji6k8r+a88Fk8XD0zKrOaui6xAwFlIvB3UMgkgyVQeRvQD5w
 ipFfTPP2
 srZ+zcf7sIWFNqYCG5Gqvplf8UbWCcAR3xq4CvikxhHmMz4SgADRRIrMHdMdST++vI7wrtukseOKfX5B/D65QHbeQCnsBKgAIrD9xNiWReA2mNszlyNlkKpBnn5MUDQsPEVaNHzyDC4ROXhEJHVhiXhbJycNpxC0xXB1LtwNU7/cxFR/UTyEUetT8JHEHoV2LerYdGVN1jfAX1jm8JN+UnUQ5oe3VQDgeEKyKzYSzNseDe5GaK26uOuUYKQgoCKyLIM3CtFavyV0WEYvkYf8wWP9Nkj9442sIDzB83K+Y9H+ohbB0CTDZX/AHWPKzY0pTIv0G/VHVT/Iks/cNThdbLg2+xNtb7HrcCL3YEBc5xEFp0cQDM02Z2p6Nvs8krkAqvRQFU2cbi37JY8Rjrve2ZB3+4IYrW+3naQWYtXPKZQEz/mjRnPM/Hctr2vYEYri/UuTwEnYsi9yJ76IytE3xP+9C8rdlr3TItkcolQAhPbIWz0q01rDy7APCjghoR8CQ5vKZ74Ab2+2JvHWSZ/bXWVhIPHDTbpo//BwiRvwx6Y9+sCU24dgmKwvwqntUSxpHFclicVyiwJ7Y88piBC4hZiBwfmKi1dqjR07UCvmYHt/qCfXJwbR4qlZpdgCDgVRY6DCds70hTOnFL4CRjKeLJIdIqN2H/RzQfrudKTy5Wg3jrC6eyNt/NY6SHoKPz0u0i2pa3dKCBdPgKCk6YZn0UxpHdwMOWGOmxXwcyLrX3EU6wDUzYpOD7OzjQ2J0yw2lNPGFn7m1dmB/CV8k346Tr1SATnXm9BNUNlucQW3NOqC5zYN+1RVp/41ylA9LIGG9oO/raXrCiQ1/9uA61j4cDQV7EQHOn3eMzyIfQlkT1hB02nQ71eYpoeW+axZ9k4Uy2NK/A0pchzffY34V76NFZKuFS4l3uEW6FAUaGIM5nEJwWlRlF+uUO2f7/zWesBT9vaLkUyDOQJpdgl+wLrQDvDFWGN+L
 YZNlSflV
 9MaVB/LkB+Q3vFHDwIxdzijMIX4y2MSEGpBQ5GJyJd4RHkDWWRglo7ShXkBpjiwPXe2etJAwStb2iVRAVRt+iGAs6dF075XUsIybZsmuYTxwi1EmSZlHiqXs1ZGOCN2oS02wedhlMoitRp4Y2QpPQFWQg/5/PYb/3LYRrKkl0ZrU4IyByh363NWzSuiE/p0p9f2Fc0cQ+rHkTgnkg33s58rAJN5sHCanqZ8iKcQZdL/DcZsP7zBWnF5tYMGHBOpQFVBkGkPyVUmnc29tDv1bbkeHZ9qafNlB0hoZ0SdqwJOxztTeVQ1Fwx1nv7ntGdj/ttn8BovjfsnfO1+KWq/J2midrh8thjZK3S0BlXEn7Zsc6OQ3XUYfv0G1TJiBK9n8k3Xpyk2+1Zb10Cg7XaO8FqP+pGXuuJDU+mPMpMPMDcxryKxCuQmXGv+vgRmLXBY8K5yVr7d/WjmDNmbRdpFecRlNgMDjFNOdiubOIS9gO9eK53AgsbRMqQTJOtRbUkPGefgDPU/YYbvRv0fwdewUr7zjwmuBWGrjNI9cPjo8BBfe7xjghfNrcmOUJISngx57EsRDwfIG7ui+rIckTU9gZKpGlCFmWZkDgMASuVTeOFiWFzA2FFp9vof83GEIHeAIV2ZxZP3q3VBJsbfIfrG1V2aB8nVPdjWA3TrQasl4bj+ROtldIGSPUo2u0CieFOTR6cAgO78tFgbYpMy4XDbNSCKQ28bPwm/8jNkkZ8nwoR3yVLMvD6UINpnzeGYmZ/Bi3WttSpayu6KA+wgZxwA7D0ZjHLWvUTXEKEspxycNpeDlL7CI66+ftyGCHsCqXhC5LAnKI0eFf9LCyb2dMgMhdPOmd9uJ4613BpZlAozgxsbDfYJisFQEy1sHK4b/n958RyJBmoYV2oGpl3CnZrLPuWpJ5JWcjaB0MvN0YKEtBJ8d/py1Fws2PxrL6tMw27BbU9OMVTNiyNDcmglmfWKMPleqQI39I
 ENjvn5Pq
 fua0w4+6Y5+zhUHbz4e7PCZJsdnEaGo4u+OptIhiwkulQQUdmLM4fobkG+rIzSbBoA5Z6gTBxZy1eIC605hvZC3xlwmCXAWuo2KyCbcJ8A1VSVJ7ViD+fuSaXmhzm72Hb0Uyxou3L6xkNG/gWPXc9cj72JdSP3dZADdWn/2irfYcJ/8gAOozmqZQtx4Y6UYdEbOx6ZKSkF1DUAaTNBSdRbYNue894uzQcc7gF5LfZYBPsUaj6mPo3cmfT7dnpb8CLv5HKmMocDk5f5jJQQ0A/bEvXbg5vcfd6t0X5DbJE2l6maNv9dXpvcTILrV+eLKPHLF0TdPyuNzJKuWRmIlE3z3Q884c9PFKNj/0IVUqKtCKDxjvdLRFYBP6FfDk098n6VaOeLT2Yalufgfdh2L5fi7+2fimZgrhHI5XKOORnzARMQgyZ6k5D5TCR0+rQe+L7L2773NGyK7RCcyaZqw6+YClx54WvOYNVcg2Gt9O1ujo7uMGnrf0c6sl5DFUO4fWX6jsAUurvygYAHC5gMs/q1lQuh9bxUoVt8Zxm7CSHLqOp9pmGfIoH9saQr6gDD1dNcOafGQpFILX6SAO3VfV1RlN3g6FMvR+3mK3IIju36bdOQFUb1Rvap6n2aL/a65ZBKbQ7o5g3m/YpPZCm+Lvh2yCGKU9YbdAPUMyQRYxWpMi1FaVUME+H1YDOV+SmUI+mQkKJQbjlzv7fsxtoP5GtpQjGhlXIAUcYgCE+BU3+TH65MQ1kRKSONPDhAsodveo30uS6bSa0kj/OgiHJ0GXGz7ErrCZiTFST9P5BOxmMJhzsMFn+ZAG19NNKLO2mvNuJekGYJRMCayJQ/KvHgT/jzNZOndhmlkdzyzis4JWfvJA0hZdbAaUAWCZ4kwoy2PzQ1sup1Gjj6YWV6Tkb7k3BOO5xZrxKubgXq0xcrpOtc9EzTM2WRKvl9d3I/rAcNiMHeeWWpHcrMiVlbYYJCLRbJX8HfkAm
 Oh/ULH6E
 keeCv6IVR3Ps0HBQfBzFwe36BomOdHnpY+DYxOW5XZcoRvYf6N7Pcv1EjtaGl/u1xadKTxKtbN+cggBrOm43LFVc3S8NNO4fouYtbTN7j+0YRNlIp7CDATLvrzYObLiGE/bKTWcinJds7r1RLP34BOnGoZu88SFDAoLv2KYokPYIE/Af8ZdwSB5clhE7F/E7vLdUEmGNJuMnSo9ZMiaI4NzazOvuzUe41mhlO/FPZ34yTtml1XkSE+3rNu8yMiihtynB7BMOMj5kE/c9blXRhbFQ0ycl94+leuhTY0B9LGC3FP9P/RC80Eu2br2H1+kYeJUqrCWvVsCmrDxlw1zE22+o4sy/Fc1jXIP27y6iQc5t7FtOgGvdJqGqM65htJmzIfy00x0rxHIMmV9e2MUwUnq1PthHMlpoat7X9/x/npdzcUS0dSrNst
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 6:05=E2=80=AFAM Jeff Layton <jlayton@kernel.org> wro=
te:
> On Mon, 2026-03-02 at 18:44 -0500, Paul Moore wrote:
> > On Mon, Mar 2, 2026 at 3:25=E2=80=AFPM Jeff Layton <jlayton@kernel.org>=
 wrote:
> > >
> > > inode->i_ino is being widened from unsigned long to u64. The audit
> > > subsystem uses unsigned long ino in struct fields, function parameter=
s,
> > > and local variables that store inode numbers from arbitrary filesyste=
ms.
> > > On 32-bit platforms this truncates inode numbers that exceed 32 bits,
> > > which will cause incorrect audit log entries and broken watch/mark
> > > comparisons.
> > >
> > > Widen all audit ino fields, parameters, and locals to u64, and update
> > > the inode format string from %lu to %llu to match.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  include/linux/audit.h   | 2 +-
> > >  kernel/audit.h          | 9 ++++-----
> > >  kernel/audit_fsnotify.c | 4 ++--
> > >  kernel/audit_watch.c    | 8 ++++----
> > >  kernel/auditsc.c        | 2 +-
> > >  5 files changed, 12 insertions(+), 13 deletions(-)
> >
> > We should also update audit_hash_ino() in kernel/audit.h.  It is a
> > *very* basic hash function, so I think leaving the function as-is and
> > just changing the inode parameter from u32 to u64 should be fine.

...

> It doesn't look like changing the argument type will make any material
> difference. Given that it should still work without that change, can we
> leave this cleanup for you to do in a follow-on patchset?

I would prefer if you made the change as part of the patch, mainly to
keep a patch record of this being related.

Ideally I'd really like to see kino_t used in the audit code instead
of u64, but perhaps that is done in a later patch that I didn't see.

--=20
paul-moore.com

