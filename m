Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 128A5FEFB6D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4877C6B0005; Fri, 27 Feb 2026 11:47:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4350A6B0088; Fri, 27 Feb 2026 11:47:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5486B008A; Fri, 27 Feb 2026 11:47:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12D866B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:47:18 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C4E051A02CE
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:47:17 +0000 (UTC)
X-FDA: 84490816914.29.0700A92
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3316B180002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:47:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=AsZRArcr;
	spf=pass (imf24.hostedemail.com: domain of ryan.lee@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=ryan.lee@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772210835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKQzT9t7ZI3mb+6EDIKBTxaX0DX68JkIAcPYLBp08+M=;
	b=fTL0jqZ6ivvyPgDmFkBXHqCZXcWpmN07EqqlRIFXI+zZRS1Zn3qIsM6HZQDvI5+kK+2yt+
	arAarPBP1AkQd1nRp+ziLrCeJ+6cElrpJeU3V9PN21hLpr7bDywmSowwDeC5YEs5wWiRJ5
	0seMTSW9Ttl24Q7BtqREE1r3cacOf2g=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=AsZRArcr;
	spf=pass (imf24.hostedemail.com: domain of ryan.lee@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=ryan.lee@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772210835; a=rsa-sha256;
	cv=pass;
	b=6FWpQmYb7dM9piVrqlUJeOt3LuC3QaTssWhOj066vU3So4U/KPuTwSk+nUtCTeYIn4D1ts
	nE1lUJpY+yRk7FEmMqhPiRlm6KnS6IXj4iLDaqJyyI040RT3LLScQKIkCyBGCYzu5Lapua
	N8VTUcLZbCDonWyPSj5PigkF1mTCQdU=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com [74.125.224.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4EE5C3FE53
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1772210832;
	bh=BKQzT9t7ZI3mb+6EDIKBTxaX0DX68JkIAcPYLBp08+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=AsZRArcr+IHOjGSBnonu/oj477dSluZfbYqix5/Y3zCBdoV1+uw6mYYHWwc4sPEzW
	 HjFcFZE09FnavTkEnrKbxmF0r3YbTQPiFMojDWqkufdWKDMCZW9OPxWmPLHGl8VYyP
	 aEEDR142r/egN11v+6BUwh9UCjnO7iqcqVKNlvjuimRs6gHHfWgooiT0xYazkycZV9
	 iGaNpfepDa56QYdI4I7j3O9bAMZ5DH4c2WTlkXndqNrhlLiQOUUvwizjaREzzR+RaW
	 G6qhyP2mK34/AwEY8BsSjxU/P2yJBLCVcFF0FazsuIIhPpIJJoppDe/KKLv377XKJO
	 ckRoiSwBJ3h5NMgLM0yT68s2FLDl6gyLkP/lRN3fVuLZu1yxgjda/ENN1odqNnDS9i
	 cUltWCZdejwVb0iOVt7w8SJ+e7iURRxp5NxrVK346lnXyAMDOroqzltJLwTrKWTFrE
	 AN4ruGpriTmmvQ9GwGNvr1LpOw6mwnclV+8SKwiXFM2kWGMs7WC4UqqVSYW/5oxS+O
	 xoiqh6Acy+TYgniHFTAsDU75wpJzuZLSiIVgwW31LUadIpejlNvpg5EcfEaBbQmLVj
	 NgnJJyPdPSKozzmB9LKkQNdrUwMQftfhfgs3hHlvFhllpGK5m8UgazcxDHxIY0+WhT
	 Efp718XcrpREHjvzQoHFxdjs=
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-64cad8f8d03so4108380d50.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:47:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772210831; cv=none;
        d=google.com; s=arc-20240605;
        b=IC4RPntiJKj2nrNjwVSDQahI3w2pgXAN797gfkAJ8SELpqoE5p0OTdJFmrm7fyiMbF
         lqgdCkHRb7vG2Kk/61vMrBlLT+14E+JMBE2nW88USHW43bt4TMRR+qld72JFClp9zcD8
         AihLYtXupkq4vWa9VutFgZukQ7bRaeVfxGlqMWUgT/b5iq3ur4QgtaeTjYxNimbGgYA9
         Yc3XGwxrKNavnVHZm9z0lTUOrCePpzhUlGWTFtChZ4VYgUK073G7OHjO6dOJ4mIMCKeI
         fEahlTnI8deTcVSStLev1EquIZcBfyWQUnssnB724TKWNHxkE5QLrZINpNaCTCxsOmsB
         QTGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=BKQzT9t7ZI3mb+6EDIKBTxaX0DX68JkIAcPYLBp08+M=;
        fh=v3G2fEuXRASYU+nyBhj02+reiKLoO9G2QaeQ67C9zTI=;
        b=Tb/Aur8YN9JFA9LMCd8BhAoW/IRfaZxPVFXp0GIHYxvoHFdBjmkMgJ6Jy8ukqbDoP6
         k02RZJ7rotEvSxJ+lA35ebCKjtTpim9WyLYW6YVyOEh4L0xQw/YwzRhgxJYQ4UC6xD3L
         nTB8BfzrYGxXXmFOyROBA+5EtfNz49W0cohDXT7PN3Khyaq9YYB7jyQBBPrjrbWvgAq3
         zD4newCJJ9pWpWDW3DFWQ/KTI4ORqqAIfHHxYk3X7JtPcLq8OFYB0ERbHdIuiDMoWzF6
         G21G+OGoq96g4O3h0mE/e0VjJVS7k1GgH/AQokW7CTxd7KONxga3Rw7/9OjGDlOcJsvp
         G5GA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772210831; x=1772815631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BKQzT9t7ZI3mb+6EDIKBTxaX0DX68JkIAcPYLBp08+M=;
        b=RvwYE7lMz8qw2/NB3wKyKrpcTN89/QvJcdK4w01Bdi2sVeBtGqzfYXjBKSbN1Q9iZL
         syptmbkoXqPODO5K+l1SbvmJCeeWLfnCkfe9xaBHdNkL3Db66vbZ2DQvCxSxOdPdsqiW
         Njxf8nBXrJYZ9Km8VDa+u72ES6jdbFLYla4iipzIomW3a0KrHFPMaIFZdZSrcASIlv4s
         YRWtK6zEZVDjKU+MExIRt/ZcOnR5NhLlS81OmbBOq3Bz0ojhTFC3LKoZ47rRrI7OsJtA
         Vizd6R2vXZrRjKrM+BmUlsc5F1ikZeAUW1Ba3u9epj2SA2CERDdv93dLpi4rJ5ugzM9z
         gGDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeiHKlOONYB0T8Mti1euidoVnCfiGK5pG0hP9vzy1NAg3cpr+CB4qCAhI2IRDId/4RXCqkMnAVFA==@kvack.org
X-Gm-Message-State: AOJu0Yy1t2HhM5X4V8Lgo6hPT1bSKVnmUHYFgq/LHMkWVQ6eJcQVHPE/
	+PrrNyyVZ8qSpEqqQvzwRiqjWXuZRsFGRXGdlL2s4rlKxmDYOUZyWHiaszGNVNcBcyCFpgA7CiG
	eYuBEJeAc4bIhY1E1Un/IdO8WF1D3ETyMaGidhV8FLWRYO7raG7ckJAvLjlZcLrbiIehlKVshK+
	yu6pXnlgtv5fCDb6I9fPFVvRl6ZS1qdwgmu01UnK1kxW8=
X-Gm-Gg: ATEYQzz0Q28EBeRYyf1DKDyIztotAqObEPUZ/X67eZ0Edj7fdfHO6sLzvM6antgHPke
	P5J+tcyAy8sboEOiUfPLriqt5KbhiCRn8OrtEP+gjGRCTQNIqLjT0kVg1GR4dBx6UneuV7e7Fp5
	sx42eUu5RPX/CkLTmyyOxyw2n6IWtmJRjcp8bGG3HVsrrbg9SU9KVsvCF0ErW+YkPnwduve8L54
	1fqf5TkdR3v1RoXYwBaZIIz3qYQA0QgoMG3KVClRHdwkrChV1gPOuSQi5SUi9r1Pwo=
X-Received: by 2002:a53:b743:0:b0:64c:9b84:92ee with SMTP id 956f58d0204a3-64cb6f438a9mr3821280d50.31.1772210830779;
        Fri, 27 Feb 2026 08:47:10 -0800 (PST)
X-Received: by 2002:a53:b743:0:b0:64c:9b84:92ee with SMTP id
 956f58d0204a3-64cb6f438a9mr3821130d50.31.1772210830102; Fri, 27 Feb 2026
 08:47:10 -0800 (PST)
MIME-Version: 1.0
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org> <20260226-iino-u64-v1-51-ccceff366db9@kernel.org>
In-Reply-To: <20260226-iino-u64-v1-51-ccceff366db9@kernel.org>
From: Ryan Lee <ryan.lee@canonical.com>
Date: Fri, 27 Feb 2026 08:46:58 -0800
X-Gm-Features: AaiRm50sr0j0-BwzNnmwGRvH8jyB1wNkHgZo3vdp3K_4YIT1mBOH-BzuS2c5S3A
Message-ID: <CAKCV-6ujQK3yj8sB2eHafaw4pvrJUeK18Hu4vzvNSjH48RVgYg@mail.gmail.com>
Subject: Re: [PATCH 51/61] security: update audit format strings for u64 i_ino
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
	John Johansen <john.johansen@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
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
	Martin Schiller <ms@dev.tdt.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
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
	linux-x25@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3316B180002
X-Stat-Signature: eyznk3tndmwugueou3shk7gkyyi558ne
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772210834-713900
X-HE-Meta: U2FsdGVkX18TMhneRTvumoystakyC/6rxkKi3LSM8VaR9nq1keu5sj5SCgaZDhLrmhg8dTHzp857x9BgB9Hsj15eLzrek1EBU261ssc4HueSyn5K7QM9+XY9XPe3pdPTFdIpwSEeKpRBym5743WeM7tiCGa4IKPhrbX+m47U3kEKcwvN64MlB8ImNAXdWIpnphLm8ZC0gy2UCWQemH07NLgkYXZYzcz4rYnHVcQvGrIoAQ6YxxR75Asb6ODa9wkFUu5aFYd9GQWhxC5EaEYd3LojaNtTQAwp6iFe2Da7WwT5l/9nvOFNrJZzfPPmopNqrumCYlSYW4YC7nEDwNbKXIJlSotN4K/BgrgdvVEfGiJmQ1sKeKLharu38nNIlrtM+/plzXzxl3Ilni7ACfbMVwSvX3d9Z4QeEG6jVHtBALguW8ygDO2GljxfxZu78qNVGGna94fjsecHzysP5IBbA82q1Zu3pyZmo0Zs6XRjDdnDFlPxLsc7dQDeIypwOBqvkwRhZ6V1rsLUiX3D15whO9yzqEv66jaBGndBE7GjuE3K9oZ0XJR+7L10uNvcGYSANkZBgxsvO9VvL3R44VHu2SZ+haj+xTB6RhmkC9NjPppWWFsGcDJeh7+H5TnrR9cJloBEnMLzjfKrZpwPCjsWD8qqJqnpi0BGfdh3evF95+0OTMcZnFDuFIoq9p2NJQ3Naw61squoxTOVF8sfJzQZQWsWGMzvk8tBJjiE0A3pLlb1M0Qnj14NIGaIyR1tLliBkzIguRyZ2532dyksnQHOVpP5gtgC0OO877aTLT7K04nsP0VdwUHogX0ivQ33C+L43mTwTc46AeMT6zfKAoBLvsIe5fx8xk62e0wHOwYNtbNzk714TtkMZMAuWcTJRrL9sbp1RC5xA+VhuVQBB0upyPxUSnUAd2nhEx+fZGNviwoejWBG+M81Cq9BP6mJFrv8w9yYI1CBtUi8acxV4A8
 61cpHuRA
 caAQg/C8DHRVaP8am/oBruymqrczjyG/zGYP2Mk/lVc0moLgobkEtmYHmTTNY0j8hLv+okIl5RzDnYSZOQafuv71YDvg5lfnsad57s6vMyn7ulIgeRW6lGCfiW32O/CL+OKtVOjVdfrNIK3juO+MrtD0efMLeASW12vJxs0787eUThc74MuVtJY056UGGToQctB9mQ/2IvSXQA4ILCDyHkSqI3B00hpIcsxv/UxwEkp7mJZLHT0fhrSwIRfpDI7xzqYhQttvo1BsiJ8jeyI/U2smlWE3tpOHRLRVzbQ2JMQwOpAabq070u8IGXjnZBWo7jb4A1iszTUq4GYA+iRSJu8ZMziweS3uH1NiZMUoIqtuhxe0TVM2igTgHh0Y+sCEHhIJ/WVamgEFsNzvwcWrsQXIidEGXLW9JJJsQ9yD249rkZzoX7SiVMUj/yxED5F3PsivMreQSXbDprlOgNaJRkkybmP7iSRMjxwZ+OhC/Fwr2veTJU25oFfC5Vu/A1GGYmO+A2m2xHirCsVXQA25zzGSsttV8ZfXpkWNIYRZ8dRDItCZaJJ3Tm7Jcb7VSP62wp5e2CJKRA+OnzAGhYN1ns8S7n17bdq/6YyPJb0AMxVEXMvM1pC6iQfCDnBg1TioQAQ0QBevZ8py5VsmfdJBVQ8X34v7SboTKsiCCN6B3bO9dGTWP2/7+OcqPTXAtTTIYWbFJS4LdnwDTXc+r9HFzAlaeIetftj9rM7nre6s99hhv6Y9TZlsP++aAVB6vemf0JPyC0xAihKF1X+AHTGEfsPLzz+ryid9sG+8ggBHDXb1kQtPgE2CeAF4sgxpTQOfrjpbxmdrLzjsOtC5a7qnNbFOdMaJ/gKjQWiHc5GNFABiBqhEcO5SD0A6P8JGedn8+57bOkwV8PxCJ8XPJ6uwnpiiQPUJ6kSKTy1YuM7zNabJNcBs7ZbhhvxzxJPQLPpXrLQpNGnTrOswt3EIin5FK65GnPa1m
 HxtSgXZa
 9WzfWVgj1kqxsQ56jdBxenDQqMY9HCFjE3xXhXWM+B+uh6xNH/GTHA4B5r0NEHahWVmzVq887lFAfz2vZCQlxQCowZtLF9cT42WRS6td7cLcgPv1kHuTntoXZ/54WffRaTrITqjyI4pqgTqLwFCWAKYiiPiJKttZxYWhLLugNr2kv722y37seGr2Iw8bXmQ4rLrWDn37esKgubbCArYSR1SVKqFwiuMIKab5oMKqtJPuyMpuyrJFYXQaOAM18BIUmMUj58KGY50sUoSbXI9F8MvI6sqLImvYZfadDU6RJPnFr04jrcRAloBXl8zppkTo8Yv9wQZKpZoHBucRXwBPPYSh6cq0YaKKARa+Dqov7rk11vN9n7I9Nuv7pLBJCDzKbWdsh2+u7YHE8AK/dGHjx5ywYc4I/L5rR4YjWfi1sAv8bgxoPpBdlaHs0SDrnHy/bLcp1tA5nHZQ5WwD9j8n3Kz8EL+uSXpdd2c7X/6nlPBZGxiqG8n6csKCunhBn48sAYyBh/rFdxoLaTJUoODqV2rD7jK+FAFlvfswTx1BAi3w/AEAZRB9blkpsBngvU7/LP4XB1J9llCQ+sjQnRcQGonxdgZ8lLZwfcr6+4QNxIjU+4wq4ndMPaOp+UC6IprHaDYhJT+LqYdtKUe9Ku6Udd3Jtnh+zQb02kPijN6CjHAGBKDYe5/A+Bdn6AVS1moI9O1pr+31kRX3JNZZFwT+AQc6xXixUQ42pOwZKDVEvN0ZbnMv/hhk3NvG/pNBwRFnnX9yR1xO3HuzRQclyaC3AvnQZyn0Nd4gP5e7gJMCN0OvpNFJRjeMuSeDquL1oR919Ufc87oSzwZlZsQum6nFuE0Ryy35KUeglNM3w97u55vyFwAF6gfPC04gpkhjzlPGIcLLtui/HBWdhceS1PwO+sj9M/0pBz2TZ0Y0OYhIe80b0iRRMu7go09LC5QuFDFLEJSXUwzlB5NQUf7Dk6s+mmMdgQnby
 h5vfTtkZ
 3l91hnhGKg9dKf1twDNrhljNZiG3q8duxJ9xrHsMyYhItj0yKZRP4+ioT6vVLamQqKJ55agveRu5S4Tgcydvq74ZXXS6Y83B90QqK0w1YiNvVGGf7LkV1hui4tdO0V1ith6e47x0tjk1Gs7d4ZVL7RBOYRxsXIZZ/zloJ3H7KHgljj80nPsY9+ZDaTvbCthMJXCJp7/nC/uiW6NyoYgv2Z1T4wE8fRqyQEfjlVAEs9gJQ6feihWAy5Q3X9X6ObPqNeX8uOMZ05Y6C+OeLj1wCTuilN8Go+Ea/21xKeLlmLYRWL6G1362R/4Hsizs18UUcE5g8q6j9hRvcsM8DD0bOTKDrmlUaMwPkU5SnjJWsbQ60bMOVYKmc3fW39/sjy+VxurrW8O58bTS3D6qEdU/hs7jFuVXdOB02xfrK1PWDZMEufMCN3iEkZ1mpU4PCoVqlO1wSysU6FbBmgZ8cXYQWjLrq3sETDVX6TGiHR2uYmxeyVxwMlj3Pr2EeIbesDzIgN5fKxskZYsaBy3MHNYfVS5x6NMl2OoVY8Su4Rfhm0Q413mzlUYHEL+7yeL+hLNFT4ObkyT9aQL0yhnOnCYVu0eg4dVHjxmzw/YXg/qvycyKy6kFRKKuw3V+eFw5Kc7H0Gxq602yxtAMPYeWFHxcwj/R7q2l5+0uGKlwYXvbq0W2MmWgMcslcZX9eJBRpse4CXxvE790gpUQwpK7fvClOTed0jbkLoIlqw7L1bLCFo1o7LANudsixMBndY/V+KCgcNNA7CNL0+qq8uavdgurTHt5okgl5jMqZduUkkgXaduigjvy7vUZxvywruSrdLxcyQTaqMhgps47ScpsQ7bDMqjrUyf/gM0c/4bYAyOKzJUTkEr5JE/Ld05BGUOG32bSYfYVg09dqSR8SUz0ixC6vPcptTp+gYCZ+uhFE28VjxuaKKDLLv5+Laa45YG9F65H4nZBOtdUMN7o11RUCwDmro8tQiIVz
 Z0/OwMun
 H8472Vfsb16E0xxXL2YKixM5X8Pas1nvr8V9FzP0hhfXpZ0MIbNj+5XPzaWeUVMkcQzJ69VlVUp+Y8ZosPGHFGSznEF4t3cTnZrk6TxC1EI1VBucKC4L+kAPKNI/fQlrPRLQ6qtT47DGyl1Ko9z8ULoI874RnD8quBav1fwy6wmGom+yMeGmY1wUIXHPVKJfiUBtVUMCM4JnpVpKC7uRA5/Zzq6XRafKSBjqRhDBGNZmBqWQcM/eOMNZMXkcYGDadK+saJz+UizadayJ00f9ftZoRqh+FhjBHuEE3WHlkwTXgpZ0i4p6ldj6+Gd0qHJRXtvyUrN6Qc9UPlZZ0TE4OfS9omV1rfKcMWeNmGn1UJxivXKnvWL0MxRqZTNA+khMzsbqiol0fuidNc0ehIMlObALR67eSUuqv7Swqk5MYUzJcnuSucP0B0iyooMiqL2RGqXEvVHSNM1du9WR9aqpiuj4vz/d/YEwuBvLMi6nSNBz27oD8Jclxr7v5DShSnXKFUnuzIct4rCr0z/GSvppybLujsrp5zfc0DgrsEC453uXz5o8LdCjSWDuGLJEc1EzVEdzlCFbXJSiIQEeucpLAr+7v2XMuTdiXVKzqdWSSt1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 9:13=E2=80=AFAM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> Update %lu/%ld to %llu/%lld in security audit logging functions that
> print inode->i_ino, since i_ino is now u64.
>
> Files updated: apparmor/apparmorfs.c, integrity/integrity_audit.c,
> ipe/audit.c, lsm_audit.c.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  security/apparmor/apparmorfs.c       |  4 ++--
>  security/integrity/integrity_audit.c |  2 +-
>  security/ipe/audit.c                 |  2 +-
>  security/lsm_audit.c                 | 10 +++++-----
>  security/selinux/hooks.c             |  4 ++--
>  security/smack/smack_lsm.c           | 12 ++++++------
>  6 files changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorf=
s.c
> index 2f84bd23edb69e7e69cb097e554091df0132816d..7b645f40e71c956f216fa6a7d=
69c3ecd4e2a5ff4 100644
> --- a/security/apparmor/apparmorfs.c
> +++ b/security/apparmor/apparmorfs.c
> @@ -149,7 +149,7 @@ static int aafs_count;
>
>  static int aafs_show_path(struct seq_file *seq, struct dentry *dentry)
>  {
> -       seq_printf(seq, "%s:[%lu]", AAFS_NAME, d_inode(dentry)->i_ino);
> +       seq_printf(seq, "%s:[%llu]", AAFS_NAME, d_inode(dentry)->i_ino);
>         return 0;
>  }
>
> @@ -2644,7 +2644,7 @@ static int policy_readlink(struct dentry *dentry, c=
har __user *buffer,
>         char name[32];

I have confirmed that the buffer is still big enough for a 64-bit inode num=
ber.

>         int res;
>
> -       res =3D snprintf(name, sizeof(name), "%s:[%lu]", AAFS_NAME,
> +       res =3D snprintf(name, sizeof(name), "%s:[%llu]", AAFS_NAME,
>                        d_inode(dentry)->i_ino);
>         if (res > 0 && res < sizeof(name))
>                 res =3D readlink_copy(buffer, buflen, name, strlen(name))=
;

For the AppArmor portion:

Reviewed-By: Ryan Lee <ryan.lee@canonical.com>

> diff --git a/security/integrity/integrity_audit.c b/security/integrity/in=
tegrity_audit.c
> index 0ec5e4c22cb2a1066c2b897776ead6d3db72635c..d8d9e5ff1cd22b091f462d1e8=
3d28d2d6bd983e9 100644
> --- a/security/integrity/integrity_audit.c
> +++ b/security/integrity/integrity_audit.c
> @@ -62,7 +62,7 @@ void integrity_audit_message(int audit_msgno, struct in=
ode *inode,
>         if (inode) {
>                 audit_log_format(ab, " dev=3D");
>                 audit_log_untrustedstring(ab, inode->i_sb->s_id);
> -               audit_log_format(ab, " ino=3D%lu", inode->i_ino);
> +               audit_log_format(ab, " ino=3D%llu", inode->i_ino);
>         }
>         audit_log_format(ab, " res=3D%d errno=3D%d", !result, errno);
>         audit_log_end(ab);
> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
> index 3f0deeb54912730d9acf5e021a4a0cb29a34e982..93fb59fbddd60b56c0b22be2a=
38b809ef9e18b76 100644
> --- a/security/ipe/audit.c
> +++ b/security/ipe/audit.c
> @@ -153,7 +153,7 @@ void ipe_audit_match(const struct ipe_eval_ctx *const=
 ctx,
>                 if (inode) {
>                         audit_log_format(ab, " dev=3D");
>                         audit_log_untrustedstring(ab, inode->i_sb->s_id);
> -                       audit_log_format(ab, " ino=3D%lu", inode->i_ino);
> +                       audit_log_format(ab, " ino=3D%llu", inode->i_ino)=
;
>                 } else {
>                         audit_log_format(ab, " dev=3D? ino=3D?");
>                 }
> diff --git a/security/lsm_audit.c b/security/lsm_audit.c
> index 7d623b00495c14b079e10e963c21a9f949c11f07..737f5a263a8f79416133315ed=
f363ece3d79c722 100644
> --- a/security/lsm_audit.c
> +++ b/security/lsm_audit.c
> @@ -202,7 +202,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
>                 if (inode) {
>                         audit_log_format(ab, " dev=3D");
>                         audit_log_untrustedstring(ab, inode->i_sb->s_id);
> -                       audit_log_format(ab, " ino=3D%lu", inode->i_ino);
> +                       audit_log_format(ab, " ino=3D%llu", inode->i_ino)=
;
>                 }
>                 break;
>         }
> @@ -215,7 +215,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
>                 if (inode) {
>                         audit_log_format(ab, " dev=3D");
>                         audit_log_untrustedstring(ab, inode->i_sb->s_id);
> -                       audit_log_format(ab, " ino=3D%lu", inode->i_ino);
> +                       audit_log_format(ab, " ino=3D%llu", inode->i_ino)=
;
>                 }
>                 break;
>         }
> @@ -228,7 +228,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
>                 if (inode) {
>                         audit_log_format(ab, " dev=3D");
>                         audit_log_untrustedstring(ab, inode->i_sb->s_id);
> -                       audit_log_format(ab, " ino=3D%lu", inode->i_ino);
> +                       audit_log_format(ab, " ino=3D%llu", inode->i_ino)=
;
>                 }
>
>                 audit_log_format(ab, " ioctlcmd=3D0x%hx", a->u.op->cmd);
> @@ -246,7 +246,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
>                 if (inode) {
>                         audit_log_format(ab, " dev=3D");
>                         audit_log_untrustedstring(ab, inode->i_sb->s_id);
> -                       audit_log_format(ab, " ino=3D%lu", inode->i_ino);
> +                       audit_log_format(ab, " ino=3D%llu", inode->i_ino)=
;
>                 }
>                 break;
>         }
> @@ -265,7 +265,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
>                 }
>                 audit_log_format(ab, " dev=3D");
>                 audit_log_untrustedstring(ab, inode->i_sb->s_id);
> -               audit_log_format(ab, " ino=3D%lu", inode->i_ino);
> +               audit_log_format(ab, " ino=3D%llu", inode->i_ino);
>                 rcu_read_unlock();
>                 break;
>         }
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index d8224ea113d1ac273aac1fb52324f00b3301ae75..150ea86ebc1f7c7f8391af410=
9a3da82b12d00d2 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1400,7 +1400,7 @@ static int inode_doinit_use_xattr(struct inode *ino=
de, struct dentry *dentry,
>         if (rc < 0) {
>                 kfree(context);
>                 if (rc !=3D -ENODATA) {
> -                       pr_warn("SELinux: %s:  getxattr returned %d for d=
ev=3D%s ino=3D%ld\n",
> +                       pr_warn("SELinux: %s:  getxattr returned %d for d=
ev=3D%s ino=3D%lld\n",
>                                 __func__, -rc, inode->i_sb->s_id, inode->=
i_ino);
>                         return rc;
>                 }
> @@ -3477,7 +3477,7 @@ static void selinux_inode_post_setxattr(struct dent=
ry *dentry, const char *name,
>                                            &newsid);
>         if (rc) {
>                 pr_err("SELinux:  unable to map context to SID"
> -                      "for (%s, %lu), rc=3D%d\n",
> +                      "for (%s, %llu), rc=3D%d\n",
>                        inode->i_sb->s_id, inode->i_ino, -rc);
>                 return;
>         }
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 98af9d7b943469d0ddd344fc78c0b87ca40c16c4..7e2f54c17a5d5c70740bbfa92=
ba4d4f1aca2cf22 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -182,7 +182,7 @@ static int smk_bu_inode(struct inode *inode, int mode=
, int rc)
>         char acc[SMK_NUM_ACCESS_TYPE + 1];
>
>         if (isp->smk_flags & SMK_INODE_IMPURE)
> -               pr_info("Smack Unconfined Corruption: inode=3D(%s %ld) %s=
\n",
> +               pr_info("Smack Unconfined Corruption: inode=3D(%s %lld) %=
s\n",
>                         inode->i_sb->s_id, inode->i_ino, current->comm);
>
>         if (rc <=3D 0)
> @@ -195,7 +195,7 @@ static int smk_bu_inode(struct inode *inode, int mode=
, int rc)
>
>         smk_bu_mode(mode, acc);
>
> -       pr_info("Smack %s: (%s %s %s) inode=3D(%s %ld) %s\n", smk_bu_mess=
[rc],
> +       pr_info("Smack %s: (%s %s %s) inode=3D(%s %lld) %s\n", smk_bu_mes=
s[rc],
>                 tsp->smk_task->smk_known, isp->smk_inode->smk_known, acc,
>                 inode->i_sb->s_id, inode->i_ino, current->comm);
>         return 0;
> @@ -214,7 +214,7 @@ static int smk_bu_file(struct file *file, int mode, i=
nt rc)
>         char acc[SMK_NUM_ACCESS_TYPE + 1];
>
>         if (isp->smk_flags & SMK_INODE_IMPURE)
> -               pr_info("Smack Unconfined Corruption: inode=3D(%s %ld) %s=
\n",
> +               pr_info("Smack Unconfined Corruption: inode=3D(%s %lld) %=
s\n",
>                         inode->i_sb->s_id, inode->i_ino, current->comm);
>
>         if (rc <=3D 0)
> @@ -223,7 +223,7 @@ static int smk_bu_file(struct file *file, int mode, i=
nt rc)
>                 rc =3D 0;
>
>         smk_bu_mode(mode, acc);
> -       pr_info("Smack %s: (%s %s %s) file=3D(%s %ld %pD) %s\n", smk_bu_m=
ess[rc],
> +       pr_info("Smack %s: (%s %s %s) file=3D(%s %lld %pD) %s\n", smk_bu_=
mess[rc],
>                 sskp->smk_known, smk_of_inode(inode)->smk_known, acc,
>                 inode->i_sb->s_id, inode->i_ino, file,
>                 current->comm);
> @@ -244,7 +244,7 @@ static int smk_bu_credfile(const struct cred *cred, s=
truct file *file,
>         char acc[SMK_NUM_ACCESS_TYPE + 1];
>
>         if (isp->smk_flags & SMK_INODE_IMPURE)
> -               pr_info("Smack Unconfined Corruption: inode=3D(%s %ld) %s=
\n",
> +               pr_info("Smack Unconfined Corruption: inode=3D(%s %lld) %=
s\n",
>                         inode->i_sb->s_id, inode->i_ino, current->comm);
>
>         if (rc <=3D 0)
> @@ -253,7 +253,7 @@ static int smk_bu_credfile(const struct cred *cred, s=
truct file *file,
>                 rc =3D 0;
>
>         smk_bu_mode(mode, acc);
> -       pr_info("Smack %s: (%s %s %s) file=3D(%s %ld %pD) %s\n", smk_bu_m=
ess[rc],
> +       pr_info("Smack %s: (%s %s %s) file=3D(%s %lld %pD) %s\n", smk_bu_=
mess[rc],
>                 sskp->smk_known, smk_of_inode(inode)->smk_known, acc,
>                 inode->i_sb->s_id, inode->i_ino, file,
>                 current->comm);
>
> --
> 2.53.0
>
>

