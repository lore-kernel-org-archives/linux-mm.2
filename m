Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D217CEB3655
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 02:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473EA6B0089; Mon,  2 Mar 2026 21:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4214B6B008A; Mon,  2 Mar 2026 21:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F61E6B008C; Mon,  2 Mar 2026 21:30:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CC6B6B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:30:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B15FB1C6A4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:30:26 +0000 (UTC)
X-FDA: 84503172852.29.E8EFB6C
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id DE26B2000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:30:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=GmEqgycm;
	spf=pass (imf13.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772505024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VKlMqpEd7YBdXym1IpYpN4BFku3eaQLOirqfkrIT+SY=;
	b=KK+B3o7zcQzlghp5qU7czKjxAhwNRceNX2EBtrd6JsQehRxQxvjookMgKTsSQIF8Ee2j7G
	r/5SgWqm9J1MJ36F0UmSVq5s8YFnoa7ZicsKPIf0CYZFFa2cIhIOg1gEYTodcLjmEx0nSj
	oFfJGXXA27xD6ekgA/GKkEiBQarzLag=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772505025; a=rsa-sha256;
	cv=pass;
	b=NbMTOdy0sGpwmJiKjJM5KCvdpE1fdnoLP24/oYW39u+jLfNqbxp2jmJ1ZPtz6tFUGOCbVN
	DonuOI45162X4Y/G+VcBTUXVn9fbijSS3dPv0sg4lWr8Eg5j3q7r8Z3egGpys0x5kzgJGw
	AVQ+XYG3XnjhkiiYieGy8Jj8hKhCung=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=GmEqgycm;
	spf=pass (imf13.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=paul-moore.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c70378ddaafso3484807a12.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 18:30:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772505024; cv=none;
        d=google.com; s=arc-20240605;
        b=MJTA5oaYdVF3dH0SsmMvsT1A1GOY9l4Ua6BPZ1+/PL4ctiKS4RaPmOleaeCIR5SNiN
         BY4Qnf4o1LWmpshnpVtI2C/M8WBB3LXrWUKUYGt6N/lv3eP1ifT+yMk/hFU+smdrKfAo
         7cvSI2OyjGKrjUMwCZxSXuDF5xB4iEHGkxKdXVOHiFgAeLEB/o4g4SdX/CxYN7m14vdA
         A62+vd79q0gG3QjrJxqRwPHRz71ICe8S+/b2bJiiMgIL+yqmXgkkZs/9v+ZrzdWRORR9
         sq8/H73kTjsdJTWAOAQiNtUtzIAOvDhzLTT+L1oDNQg8m61xhUV70uMHa/OJO3a8f50f
         Cflw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VKlMqpEd7YBdXym1IpYpN4BFku3eaQLOirqfkrIT+SY=;
        fh=a4+l8JWGpsVpcsRSbrXbA8thxvNROFkHj4lHN45lbOo=;
        b=ElYGzyAT6lYwe6O4ZFdYDGCJx2650dmV2YTEkrYp929nXFL4hICZHjKkzg0TZgWR1t
         4bhS+gPZvz6dON+OTNIuY3zi+81MWHRV7DMSWo5kR+4+VLihx2+GBO4xFCQhmW91YGch
         MTaPlD931XaRncCj5dpxijotmJyvOPv/ddPw6MLxK+CA4vLQCukjRaOS9HohLuqz8H8a
         WF1/EE8aPYnJs3c0kKvwG7LpUXwuf8QAjoQ25bkfjGQg2LDZnAi+l7tiZDmsWmt9fJ1Q
         0eNd0Q/RroQ0ofLbRue8lfwFFDroJR46hniFDkonJTa2mhSi2bkf+QFHto49Y6Js46eX
         gfnQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1772505024; x=1773109824; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VKlMqpEd7YBdXym1IpYpN4BFku3eaQLOirqfkrIT+SY=;
        b=GmEqgycmzSnCOBjWUwd73H/AFfCW9UzAdM6PUsM877R+GzyO+EqQOPkXgbBirFDw1+
         Dnr/lCFvsOs32qyC2bM2wB5gHQRsO7qAYMD8sO9LropC9Pw8N4oOH6BrwZCaEB9AGy+j
         wpDritNF5eK7K4vGkX1IN4nTtkcSYP0GnRvQU01ZUc/hapgVag5v0p4lIwjjgbcJCfgI
         bdS81aFagnZaiyUNQycSB4npQ8xhm5VZ5s6R2fFaTOlG2Hz7hRriACJqvxH/1VP7jj3i
         y1i2HU375ZHDWcqB310c/lY/MzHIZI7O975rjLYe7M4gMbfI3Hd27rRZg2hwaOhzpRoU
         MszA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772505024; x=1773109824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VKlMqpEd7YBdXym1IpYpN4BFku3eaQLOirqfkrIT+SY=;
        b=Ai6ZxeRTKiSFtIQ3qAXsCkHE5gaXZA+zc7Zt8Y+J5YyTYPy4OgOYIjyHeSsrEQcZ7T
         ZM10VJva4j2bmh0BCe+XVVoMcc0bX/sq1JPDGP1wc7/FWjuj2WgLXevks9sqwyaC2I2g
         M9xic5eOWvfYhwzTAPH/m1OMM1VaA6ljJbD2SXsxAElxWwzPiRnyj64g0CeBxXpjE+M4
         TU9/PCnbyy1kgNSTlmzQqOuwOSzABXFih+1NNi6UWmuvIgEiUoEdgR9YPcYUyjsrX9OT
         4DZJkys6aJO8NbVuRHx2uoeIJ+0rUdjx9Efm3KS35XUERtGSOn8LsLqVBdCJu3HOBj8p
         0prQ==
X-Forwarded-Encrypted: i=1; AJvYcCW97A5QkLyx7rhqNg9D4EwVUO+tFT5Z744mTcvV2bsxidY6qbS7m44Jf1N8Ppqdz5RBKVUb3SyvYQ==@kvack.org
X-Gm-Message-State: AOJu0YwNVycF+TEvp8gaIzzTgxy0+P0/domcnoxASyo4LLpLcH/B0/4Y
	5VURsmcoRPwcUCza/LEWRx8ausV7eY7Tsr6d/gQDKuTuYqjP5pz6tv+YnTyuJfNgmxiFXSUJu/u
	Ec56VkZFJcTqlrne7acO5B0Nr3CE4yN4p0ky1M1s2
X-Gm-Gg: ATEYQzxhnVFH+NKU8CHf++bI49r3+4J5AQaeYLxixTZc5XHbmiGCD3kQ6SO4nV7BbbP
	xgnp0scbXWWRpDX4MMUdE3u9DpjibAGO3cR0lWBFzd3i0tt3LwS3hbMJFlxO4x7Da6YijD/1OjL
	Ksk4Ijv2g8GCs1/TFlCh0XO87fu7LeIQYJKYpOL1/AP8weSCqY4Oo+p2Nd5Z1nbi371M1ldUtfi
	w/ZosK5ohQqp0kOPsPeKdnjpn39LhUv51/d1GMDiW7xNU5d3LfkRv0eCh74WDaTpglhU0I9DAjj
	5NR6b6QpsQfpum+AVg==
X-Received: by 2002:a17:903:244a:b0:2ae:56f8:747b with SMTP id
 d9443c01a7336-2ae56f8786cmr37920855ad.57.1772505023451; Mon, 02 Mar 2026
 18:30:23 -0800 (PST)
MIME-Version: 1.0
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org> <20260302-iino-u64-v2-105-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-105-e5388800dae0@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 2 Mar 2026 21:30:10 -0500
X-Gm-Features: AaiRm53tOqTCLn9NgvLgqwCOFo4xSyksjolr8ucn59RQ44Ck0r7mzGeRmSI5U0c
Message-ID: <CAHC9VhSHj7qc-tKxEN45bkfr+Dha59ihzOGiCO2WDYTYoB-LeA@mail.gmail.com>
Subject: Re: [PATCH v2 105/110] security: replace PRIino with %llu/%llx format strings
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE26B2000D
X-Stat-Signature: r5gs3k7c8pnzdp4wo1x1ad8ny5zu8zsh
X-HE-Tag: 1772505024-332896
X-HE-Meta: U2FsdGVkX1/zH2WQN53agvxcdAfYWH3pzG/+le4j5YBVdtClM9hvNHMjWeU4anq4Z2+pBDVUabP0TYt3ZkdnnagA5bSlP6LwYEGdgYhNu3dC/OmF7Dzn9RJnvVvPV7i8NyP0DtwScbJBTpNkUdkqAKFXYbf1PbXINTa4ADZ6qWG09XNuJTReCHBq6Lmh2OX26057DunMRSi7xnk/GJsnMi75rdcGDK8c37p2HY3v6OTDUxkiJ4HRwEqS4RNCnmgEEZPvw0XuZ1/vbIcQA2RFXccwpMuQBvTyiUwW7Xy4d3q8V43nuD18JLOempY1TBsQqIEaI6SFqYp/f9RyDEWWPbpQmrcjuekDD8+/4Gm4xLv9V1W1VwTkxWd8Iu8MAmd8hqV05lhxw+hfcaS0VPlahUHc8JKMpGwE0Kp36bWd0G/5Qk2Kw4Y9w7AjFKQA72EAU/s8gBcw+Erk1ZevwZzVgc1X5dtj7l28Rm9DTR5/gDasIApeRhh22zW6UWaXbZhAD8roa9I+0WH6Kuu9ccmf1SBCE2bPy7HQgxGwfGpDIVNGru8wFik28N5Tl40/DsvlXXLirUeUBV1hOukWfDQ29+0/h0304DKEsaw8pl8vf623j1qCOmCyvs0SeGtSne1KipHbR2UQYtBRlduSiTJv8OLOC444ilb8SmCKCkPsmdidT7ijmfiBPrhKRuf55TJQ7IkckLb1gVhnx2lDf+IAntON6azNun2X/FdwLkyGhBl7hikoLgBld6xatobPGnpnQ/6WyXDiNK3jt2dI4Kz+XTX72B7QEajUuZEOOpJD8MbZYYDg8rBCWanM6g1M43fFnYyepqlF01azjn343bIGt6LSaD+S4/HQ2H0AzJL6ZVKU+z4rsoyrKvRcoCVV+ib1B+qD5FsuT4oXB1W0TAI4TAlQF4xE3/naAwxAFpDasJCnmwIpOyhdCPZOMWN3qNTH5I2rBMpqWhuXAkhCogj
 rzgFX2xS
 72fiDHPOS7X4GVmDoWPFUKjVaRWW2VfHqVdTc8VO/fYjQTbttDkiRSr3oxiUAzNr7lSZCiC0DK2GQqbcrwejSGOfHuk8zoTf1hgvvGKMo06bgARVFGYGA3co2ILPYbUpQ3cj/CdLj1TYzFPZW0I70a093PqKtNh2T830ogTJ5CoBSrmAIBvV4vzj7LjWpeq8QrVBGQy8zff4VZ+jMRHKoVeN/IafmTsWxV34asOtTDDg63jduUm8Kh+NehKwKGeZHLDUohw26MbCdb1zTedmnfzjsBFnWGkNXCe8raVmMDNcuMhjyQwhoF4kGrGT4u/JgqNpKrFIJanYih0eCmxukhNZhvy879bP98dgRaQT9abv3yd0+0wwZqY5cqKefDaiZ6iBW/rKXH3SqsMnC7fAKXo4PHBz6sbeFNB/bGsDX4ip1xRyRK5flf7oul/AOpkpjoJgdg6u2hU8XID3ykKV/MmMeFP9bA9ij0vEGLEmRe8jlPIK9v3jKSKKVwJ5W6oLmbo3jJH3eFV62VIcu8JnGo0H59gldlqadi/rXZa5afD4EPZ+neZ2ru59Z0ShdH/dUaxdbpxdH22dzee3E1gPjIGL6c/PgA8a3DRauQl0coW+Opy8bFoaM7M4No5kZY98sJGTsdL7wQ9RijTrlVpRldPD+XRBYsLQful2VBtJhwsDJ6LN++4VQVve1NSLqsXNqwmFM+/RZrn7PQK1DZ70m/v5LujQyt/mu9dzxH4QSGCdKpjHYNrC5POTXAPpbhW//giQVB/XOu/JDsY5egpnzBDrh9Q7766y77dGW5EAt+6/PAuc9zI+fWI4PHUtDu09hkniaJMBkgtZ7RV13jodaWgDEw38hXNw96n8HJ0J9uge3xeSSjT8tsN1xigW2TNZWjdktwQ6uJ8oUGhwsJMO8W8eDyhj5dJzp6m4N6dUfHhhMe6TXNQK9kOG2ZzJSsSng4/qcF1KE8t+kS3fdPBpXIa7gUoVQ
 Z9ie37En
 8phZ8aaz85TZPspYKpNv86REyYPGSXvrMgC2b8g8HAxcVqsFW9rH02VgWGzSPNRiycqctTiPQC2orHsO5CdolKIc6qdlZ3fxhZFq/aZImsi+1PttKgZHGHAOE84Gx1PmS841eAdrMvvQQqs5dDo1S5yU6+/1aoKnd8XvKtgW6jWMd9880UfWWuvespC0RvSx7/0WjMf9EMmoaWynH7DkWMP9WkPTvjUYg7lJzyCmtOwbFRC/myTo+6/co46ahHYKHSVO1+2A/3zkXPKQSnI44k9bCGj6hdQu544giY7qXUZ/lkWx4JbzEIY9bDL1B07XoQUlbzfYMqnDeTG5fMPhP5+7Ezz0UiEe7rVI+xeyuLbZL/XcuO9R1FjRper7kd4c2bNnZ+3MKrSVDAHy9I7udq+XpYiBjKFqTe0AifFF6TsG1ch0l8oEwrcOq89tkhUc6kmUkFV8C0xAX2h+bRqgLPPGby6UaKhRxB6rc5+Yf7lDc2OBm4YNhQj+ARz4mR2VRx1wANMMjNrtwcG8yqg3RNdeVfT0jYsdlA2ZUmwV40ntjabUthl6fpaha/woRz4EUMb56BOsiBM2YXSZZzMXakUiJoFvpQP1PUidQwIFaYQuZIyvN8QoUAsqzDyH0Kx9Wm3XVxIdcjTYWIRqf06zEIUyE3nHR6SsileHK2P/SgMuFqSe1eC5YyXz0Y9W7wwBY5iDuE3iFMfWOzhyygUcLv1EaLIeAvXzTftozaJxstn4/+rd6TDtzVV2q+UR0nhsOZ2EYBuG0qYTWJgPW8qNSDB0eXKOJLP0XZz8Xb9JMCd8k3X+LSvCbx1WAY6M+Q2eH9cKwzTdirZmITb0hJ2PIsu1rG6qRiaccVzb0aMpzMBwQGbM0JmSRLNDqxiotlPI/DNTHSiFkfHfZwYre9M9XJvm7+2zjJRSwDzsSCfu0qWtNylOhZVDwH9QOdRfOVjD/jgl1QzkRl6D85iSxdDMsQAQzp5th
 0km1g0EF
 EzKXq7EM+xWN/JL3PBrFJMWZ/OrkuIXxR8fYjoCMCpk3PzPAuP2UW0ZfcwJ2KxA47PVVGLtMjdKeGxc7R/YPLvnOrpVsrgO+waT8ysFvNFwpzYGautU7rqJSQvu8ILzzLJDy8cVzIuUYJ5spIql8SE6vZYppSHfjdUeE+mWC2eknT6xja7zxSdJIrbsEyjRBYJr0FugjMHFqI2JBdSedgBYRrMhkT6XCGvbORJoJp8Ltah3hgpVNBQurPYKzSaG6yTUOMbvWZmJa9Y8qDUzm38QELaEdRT3D3snAgjwn0mEg/g9IgQgLXuHAof4t2GKIrZD3kpJI5x+mfz2orn1RsUONK23wcsPPr+jq3qz3WnvEDtxqnEY8STimdMQ7mA0r4jG3aUN83kGnWvANrxMOQydDIY5RkJuD9zWHLr0HWHVoA8MMeR4dJhKDwqDQOV4ybxguECvH1yXBWLRGbIoJc2GrEkTu9dIzy76vZ535YYx9eh9pxCotB95s45CpJS2e6sL4DGBvRYJ6Ldph7dM3g3wmbJHGDSTwWksbyqrLInUotvezeeVKEUL6xO8llV2AKnZp5cj7x9SINUIr5RG1GyA8VORb6F1NyLQEskM/EVmjs6UEJoCwGZr1rcD76y/sl7gnIWX/JnVk+/Rq2S+5llhd44xvY48uFTR98SwXXLOXrTWAXMZBR/BA4yqcUA4yUyjXgydYfVrtR84c/WyBC96AtnoOLPopq+Wh2uMBxMTjB4Ix1Mr8kc9NoGjEInN1lq13YRL8M6pAg0BVYKvVHPXNZj+NlFx0MBIZbGn/fF4lR+wJSC2jnDQ5IYNGl3yzKoDtdLwHA9vJb+Ght2ycLiSAGlNAJiJ09PD0ym0DC7lHirsvoT0AFiUHfjl5y9suG3mGvY8MRqqVf8TaDaX90vgxJFwqdVV+kIhE4JFKxHUeTKwazykTmGPXHzAVon2D3ST7TR1aljnc9oqYSNAqi8NqNmEFC
 JOP4m1+P
 uCDw8Q57bIWjJeySb/M54BHuuAngG7fT3Dwjnr4lXJbXQI9FT2Zllu1DA0RgjcnrXbu2ZuF80inmuwbcxiIITO+Rb6J27SetM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 3:50=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wro=
te:
>
> Now that i_ino is u64 and the PRIino format macro has been removed,
> replace all uses in security with the concrete format strings.
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

For the LSM framework and SELinux changes ...

Acked-by: Paul Moore <paul@paul-moore.com> (LSM/SELinux)

--=20
paul-moore.com

