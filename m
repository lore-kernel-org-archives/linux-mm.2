Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6FC9EB3643
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 23:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E251A6B008C; Mon,  2 Mar 2026 18:45:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8656B0096; Mon,  2 Mar 2026 18:45:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52C66B009E; Mon,  2 Mar 2026 18:45:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AED726B008C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 18:45:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33E9058884
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 23:45:06 +0000 (UTC)
X-FDA: 84502756212.12.3EF168E
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2A1B140010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 23:45:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=A2KwiKgu;
	spf=pass (imf11.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772495104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u082M2vpZx7MrZkmV/F7ZdAH+CJQSjxHglDjea1+awA=;
	b=S8VIu22HoXpiUzADAAGnsZ/pkVsqF6aRpcY9SePmdkwN72Lc7LqCjqh2GRZPqkDOHTrruw
	/ssqaZkDeWRv7QDVd/kYoi58djdZvJiqHT0bTXPoeR/beQSVd4IeryRQjUA83TtR3ffrsu
	iWbrHRYDcm02P7yw++LJHkmmS6IYBMA=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=A2KwiKgu;
	spf=pass (imf11.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772495104; a=rsa-sha256;
	cv=pass;
	b=Id3CDkC5caZqAWXhNqIe015j2Qmr6KmsyPi8ap+xODjjUXH7Lvxvp+WZo5732iZDZ/bK9O
	HRBvkD+//QNzQYdDVsv+RCDWyf4FHjLBpBOtKLq7jV2g8EfgqL/ReNZ+D6t3MlWH2w2WPC
	ICL3mup4soaBRmHbAveuxuhA9os5VWU=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-358e3cc5e7eso2209651a91.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 15:45:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772495103; cv=none;
        d=google.com; s=arc-20240605;
        b=KYYLZDUKQfVvgjVsxO4Ykw5SOLNVc8NuDMV2Ggx5+czQHX1Wlqq//o8E3NQmgNk6IU
         UHKSi1Y1357NqgUi0rfsG6s17xmxYgcM7nCTaZ0qNhpWLUrFSY3t9751NHi358BteDGJ
         PrCM41uSyIvlSqXsBy3QaT1zFvP9AmtP9b2d47uVflUi0ZE1chfb5uziPh4VnmRLOUVm
         2obSMsopwRjtq3zHQXAI+DIsMmzrsdL0pCRG6XE9TAcxfUwowWVDQqKh4iFYUNEFRjVf
         iHDg2+0g4ZX/K6jAaHPho4/Iy1lA3MOGdGtgSJBYEOgtQ9QXKDKRq8fQxPNWzH6+vX1k
         LPbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u082M2vpZx7MrZkmV/F7ZdAH+CJQSjxHglDjea1+awA=;
        fh=TMPR4nVPw40T920JJZweqp4RODNcuFYGa2B7nUXtokg=;
        b=etb7LWCC9/34ozW1Ehiqq+dNnNDCsMzh3Ud7H3HeoFki5SsTz0NIMfRg/QLoyM9onL
         HSi+Ihj5z6FKg3j8pdN6Wrs2y1q7q9cqdfry9fwJ40RJV67wbUg7fH7Wvj6BPdKsGn2b
         kNkslfHAoNbIxObTk9DR/rG+4KQEJaHjBXwOp3AcrusztSK31RLhRjvHBnED5ml3jN4a
         yvylLnvy6TF65Grq0GI30ELT5z7H3T6uWHCl8Qf9Sy1ip6tvIXD94/rOPGcNSHBC6RP1
         gTwY4TswevkDa6rngcyb9JKpAFEIWTkV07ppKCWA2XG097Qck68X2NayZ9BzzzH2di2B
         LWqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1772495103; x=1773099903; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u082M2vpZx7MrZkmV/F7ZdAH+CJQSjxHglDjea1+awA=;
        b=A2KwiKgu7+K8Qw/ehBd0u9k1Mp7Oli0Io4+cGswg59qxvOiLn4Z0AgOSfeyyMGq3hS
         /HYhWjSUnK/G/u31q5eoBzTfXtR9rtzEi4pehjNEAuMMST6aje4dX6C3JL9g5sfZhc+W
         4Q1aTcEJ6t6dfn2JVFcwor/AdPYhOIP4Ea81LuLqJ2cOPY5/stJPxjwDMefOkG9Cho8Z
         /a2rwqwd9FeJJbH+m5vQF56hlVQQLAIFG7E21A3qWk2NkQEAd4HPQkedStHLBCdBf9PO
         Y9+dXR5JJXgQKGaQ7H+zCta1NFl4ibjToTaM4IsGYa8uTwrzxGNTVPUsVLHUX+FLCuya
         ShEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772495103; x=1773099903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u082M2vpZx7MrZkmV/F7ZdAH+CJQSjxHglDjea1+awA=;
        b=Jn3kyCWN9cXJbRmHHwvo1ho9WsKqQCuKTLRRJGZ9R9+uT+9LKluN9D6W/luOjEI5fO
         5BdLxpZD8uG3b5Yj1PZVKsHJ8w4xe5NzBE7vwgIcghgCCpxaqMzaeiWn4CqvYkUsGd8V
         /ZBae4elMRIPBQxGD7iO04cMgPrS8kf9JlnV6ZGshvm5gnsXsmhOexJ8hjnyHOAwgEMQ
         /kiQ9XrKDdkCgT66IFtqmyHICK85+fQcC7OInMeG3ndCqGkyCWAwoQiTspeqRPPQcqz8
         poxL7PV/B6d1bjGkMwX4yIxtCyz1WGRxdvmV3O66TyL1rtRJbX+dwQy/b3gXmqHDB2sb
         R2YQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7ulLx+kl+gujW/KPgkENbnCYbMgSc0WTpYJSrrY5ERNQTvHmONmdqQ5j3uizNyARnFgJS0UUUYQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0Vk+QtSdIRvJRLH9/i94vU5k6QREXMcpMT372zA/oqsvfL/nx
	eG2CzXtJkn/zJN0ptKE62pEZbkqzKuzrOINKUlVsPuLYuAqx1ng4MPyxxBa+Bqp9dXEXXgfI8Yr
	IMNrQXPodnoUtdZMyN7FgJ1/FSZnMx4mo4EY0nU/K
X-Gm-Gg: ATEYQzwbMtcYf3ATqhCezpFDvghInx08qg/O4+0z0c1ZykTUOltZNoea1hUky8ddBM1
	qy0OBRnTDCi5PW7ZFUyv+AoNqxF7S05YDP3r+4eIS/7IZDey9d03GfOMGxfe+isoejpqx3UjElM
	C7Ydp7hkesNglDh+cHqLn7givinpolVkyM9An+eoEUs6jrzBBC/n3/pMc4UEqlmOEokNwfLjC7H
	6C4CRozICSRb4WDlHD9P01NTDx9TIvdQMtL2ZYsE9hOUREf9n3kNNloWSp1Ncxj5nq4nl2+y96G
	jbkQrUs=
X-Received: by 2002:a17:90b:578e:b0:356:2eff:df05 with SMTP id
 98e67ed59e1d1-35965c9d15dmr12730172a91.16.1772495102745; Mon, 02 Mar 2026
 15:45:02 -0800 (PST)
MIME-Version: 1.0
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org> <20260302-iino-u64-v2-3-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-3-e5388800dae0@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 2 Mar 2026 18:44:51 -0500
X-Gm-Features: AaiRm51Sffi2V1GbWbKQK3xjBHaGrjaqO3h4_HvI_INFaL56ZEFyr07E1_3tePs
Message-ID: <CAHC9VhRnmBuXEKkUPQhJ_LDzcksjoAJL-ne6mFoJdR1hnDdzsg@mail.gmail.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2A1B140010
X-Stat-Signature: iq4mjweyjqo6oa66jithm93h658hha6o
X-Rspam-User: 
X-HE-Tag: 1772495103-219156
X-HE-Meta: U2FsdGVkX1/aOu1NRsuLjjMl3VWOokHK9CjZm8J39Oykvws1SL+KHVWkwcW2dzpQv7R2HIekGdxA+4wlNtbLMvx8m/+cfj9UYj9Ra7R9ROX7PSt8CjHVSDXN6wlUZz/+9Hp3OlJU+EvhHl8EROnI55MsrVFYL+e/ToqrIBJoPCpP+0d5i4jW0+Zsfla8OOzKSnMP5H4ajaA+1af6Kz/ttV99S148BT23nISE7tjuesCalil4QozrY1RbEPYaSFJZRZrLUUjRC6m2dzseayQjYPd8NjjwbD8dLoEuFEU+Zoj/riKHb5T+UK/uI+Mj0ZrnikeSGQLn9uieW25/FHAEcbjW6O0inpS8wS/b3IeRzMEfMrGvKWnzxdRluHNSC3hkmkemC2/JYm/yl9I/OjrGjkdyiu8TKLzZ7URZ8BJcwMSSi86Cyy/6PnShWY5z4ZCRYM4UWvMLKthi5wUICI8ZN09ZuTGF3GXmUizrDvG4pSPJgh+y0oM9MfXZsk8oxiSC0OB5VR36gK0Rh9IJDc2WPQGsrH8cMKS9j3M20W11hNGL9T7N/o1VeDGZHAHC9r63NtPdo9OdcuNy/luKuMfAplzhe19qBoFukm8EAE8LFWzp4vkXV8LftdAcCEJssi+DYhX4JQI9QvTBhfXWMWaAt2F3P2spxQd3mqdDf4XRIZ8ceLOLjAaRN+G8/QaQ1HaRPVnd7W9Xm3R8KdwT6/pF7uCqNzv+41kH2wL+ePcg9XIcn9xSnlwfYWjew9Ah15wAu5DunC50AGcLTIvBnO1OGNDzt0L9Y7Zp1KpFi4Ij5xrjxU6MgOtrNIZKgkIEjf3vAFk5lSFUlYLBdTAbkkOCcExphkSThOMjqDrBFrYY4DPzQ/+dfj7p74Q6UxvBlqhdlqW0oduBCjXS2tiI6zXl7R3y/k4eczIBiVWz0D98O/kAzYIZ9I9aqGjDF1YGH+REYxrQ0WUCpbsj2W/4Rlp
 ekFeHqMI
 TayKFviUxBR57SF1ICI/06TNTWDImO3eLIMzFngSA0OpDsKDo4omziMA/p2W99wZqxZe65cQFaxC/mPUKvEsAffZa6fvL7pjDK6IZx2DHxdOVfsaC+hX2O1qnR9MP2rvLUAPKXfH4AmRk2XRw60E6/mqUpemPiAZPsOi/Zl6B/3hp/lVoU8Us9Shi4vKlND1acOjWLbr6Uft878ALUONqMyEJt13y1rzpVcyvwdbMR4tGHAZv8U37rdzlsHqssOxQL2U1GImdvK2+xjR3FKxUs/V993j2+LFsdOl01eAwPHAFmLJk/eMJEXW2+b9MKujy//c1KIgcos2Hi6/rtWARSBSgfHZXW9Z7Uw0ff7RGlhzphc9TRJaRtXCltjA+Oq8vImR1jidEoCkLzZbJPoNvlUTUJPv3HV3vlSQnJEdn8UaTZk1O4XeuAkbbdosixuKgJhq3Ni4wvFZ55oTu89v6GXNZUiLwFJ/aCP7mKKeabVSPmA1McPOEFqvx5eH2/X9iy9IgM9dIGKjl6ZqFhBM9F50k5/nLjiQEWTtOTrgrqz9ZG23o2kRfYb4fd1GhWT2UYLk60ukd4wI6N+6ARdnh7tos/rn3CUcwXSM2FVWzt9OFnAZA+DjBv7LGnaImilbKLitKmiXzdYypNAjdQCM/FFmyUroQqfGXcVm5bqYlkJN+7A99sjn6hQ6msM5seu2LVsfGtVo7B8kH8Y02L7xLgh/IZxtBajMX2GciTuPJLTNstvUUS98O55tdGao9GG8aA9o4VF+qFW0D0ZDzaxcSnB8f/8hQ64JlMv2RI/2i8lZhEKQK5fRvKHNFPBuorUvpEKR9UgVBW1IpjNtGWP+jSUyGvls61rq72aKdGb2vvlm205/PJ6LEu8wcfZnOuV0KkmiNpeXu9TZPAJx8RsGlFdOaImY1zoNKMgc4IpMYnHCpFpvql+EjFjllFbYgrQtKm+c1Pb/9ejYdDbtxzZaby0fFsGbJ
 qk0JwOVb
 /sLRKrq6ErjiTyOGtlTI6FYz864Hv3tWb6mCNWCZH3TwHJlZRIqPTbyFuOQjz2rcvHTfJPCQotJVB5WpYxzBz2euuhzL63iEJ0pqmEIPYt4+Nj2MLMEMPPL+EaU088PZo5w12flJJB/c4R/oeV1XpV1Tr4WggYwnB0/U+uEQT0ImhdQnqasjxXQE5EC6/WA9nZIHTdl0AONHPup0lqy9v59gl2cRagyknShPosIrtrUYnONA2tslYCrx+C6DXr1AfdjJS25s/SZAM0Y7i3Me8lndPiK3l555d3j1+BlQfj1LlXrtuBOvzbPtOJ2Dkwq0F7s22xkrmCnDHO9e7kqB5oDZcet39nr7l6k6tJR0FRK+Q+jWE3ZVQVqNaesiCTBM/3e/ar8US+wEWZ4IO2ehUH9bU15TnnBmVi+uLFtL5WnTd0Twrcq/jI85tz08WaNKkE7tOH6MbQHlcCF6vyUglxZDGlkow7n7ELHVTmk1WofpJu75UPQQlPN3C43MI07MP9sVT+Nt/nLWBxPG7QZOq08AGBY+VLqww+EHnQviOjoFFXy2nCFS9weguzNeL1cJFl0zk4ZxDHNJTjoTLy5WCl0hrjT5pU1kRCYRU364pj2t92M1Htn0iwG33gaulOYNm1Jdy1ITindr7ppSoqOgeyZWKNH+UDtUxGcloUg2UAjqVQ9USciTcytjh9DUXl267qqsQYxi02IV48vTBuivsqpXiYlZCnljvWG4LR2cVvqZmoN4+R6a0brA8gup/ukaBMOSrN7m7razlm59FdoDnduJx6bhnpAmYZQMFdOgi51GcP42xNEARH8BtCtVVwIHCySGn7+3pf8yNONOlIfOBTaWapI+xJhy6KYH4lrT7gAuu1kpoHWqu6C+gCjXwn/xgMuTMPjUSpJ6NJ+ATArwEPfe2GyORAmWXrao6/vBG/gS+8bjI8Y3BE+AaC2JqFUZDqy5hw1FpnRiHXJLnrfvH7wcDATtn
 gNQuCUEV
 uWeaDT0q/eZPJgyKA86/nEO8C1hzN9Aq9lyi945RL21defPecDoX/3iOkx2HXCfUi/+113M2aK9XQcs6jNsnFKPlfwAEIzF3m39Yn3hnLHrEia9tQ3i5j5tEi0eXk85ieVUQ3zRQb8tHbOMljG+pRtw+Ubcj5dWGTpWzQSWC0BMDpgpt1f1uWL0bjz2nu7r6T2RpUOah6m3JtrNxYFoElUx1Dyn8UPaDMeEnTr6Q745hM5F3s3V2bhb55skbRdRO1iG7Ef6tbYai4Osgt7Th8CVJJtN6YsZeLia8zWJR/RtwezZOc0zjBN+Or8nGcc5WAtFCY1UKRZpc3ViqVw5aXPePYELFAx0lCBtHFIrFN4aHtZe1qBBVrktU3eQdtmvA3e4iiCZ8/1pH8hu1v/ECLQ/AYVQQsNkD7zSy2Z6fZHEVD6UM4L++kMufa30dDza5Po/W9fkc+Bl+CIRo3U3HdY957t1lLvEa0VMEy3Q8uLiNwUEkO91dRneqkgJcihkWiUos/W75yqOuFzZWVSsepyBOTBuKxyB52RNjF707NyqXf5lRuqCDfFW7eP1p+fwDR3M5VD7VvQf+Vs+3jb/s8gf7QditiWhoPFrd+I4Si3hOVb3fIzUMkKEoJxL68LM9DIYoTHX0+/Sa/ovNix46p/FfNV7eODqYj+Hfuc/zF/IQQZwxmJpvV4whI65gJ/oZsx12M+/Z8GOitRAt+g3x+b3lWBIHYZTF3cw1yLdm8DMAcDRQGxaj9peBfkD/KyrnqGQ6KTxcmFYyr8Wpex+dEp6LPCaSzwrrCy45cUQ3YzER84w9Wy5yDq+KdRybYyOBv9hSMpYMO9N3yLMeX8tb9/jekzRZm+loViktO4Q/s4dbukI26AmArtRDwcNGyvqc8ujEQI5M3BzMqLArpkNZAw+oQ2DQswhrSFPbobVY4PUV+qSjK4T/bhFmx3QKz1oRf+7kpvjkR1TduXoILwPEN41OpdpU1
 nMHCPoWK
 QBpEldFqyia3LhSvsu5oBzYPoV3dXDLmRM4utGG4a7noPVMeYk4WYpkadORjRGTK2LykkOvmaQkBcMFTa/C8N5EZQd9EC5sJzY/ilwcog2O4UjL+mEnoBYwQvNXp9YYLGaOXAhJKd3Bb/1i943TV4F0J9fLlEh2BNcSQMZj7MQNIdpCxrJRmtMOniTfGu6W01oLRx/bHwmcH/jzja5WlMpO0683VxgGi257/Dohx5N0KNiQqlo4D+3ZL2OtXctvwpEj+OwTp/BRMGe/7KaeUhuot5nvTebZStXrfE/s6IjYxazSbDcrU1iOaWB0vi4I3RWK7OYv4dOhykdhh7aDFx/wttUMhH2ZGsT9RmCOMZB7xDAfFeiJynn65kf/1wV/vX1bF/VsoiFGFTYvCYyvAVc8fEPna35NXPZbg1EPrMd3P2aHExr7hMd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 3:25=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wro=
te:
>
> inode->i_ino is being widened from unsigned long to u64. The audit
> subsystem uses unsigned long ino in struct fields, function parameters,
> and local variables that store inode numbers from arbitrary filesystems.
> On 32-bit platforms this truncates inode numbers that exceed 32 bits,
> which will cause incorrect audit log entries and broken watch/mark
> comparisons.
>
> Widen all audit ino fields, parameters, and locals to u64, and update
> the inode format string from %lu to %llu to match.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/audit.h   | 2 +-
>  kernel/audit.h          | 9 ++++-----
>  kernel/audit_fsnotify.c | 4 ++--
>  kernel/audit_watch.c    | 8 ++++----
>  kernel/auditsc.c        | 2 +-
>  5 files changed, 12 insertions(+), 13 deletions(-)

We should also update audit_hash_ino() in kernel/audit.h.  It is a
*very* basic hash function, so I think leaving the function as-is and
just changing the inode parameter from u32 to u64 should be fine.

--=20
paul-moore.com

