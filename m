Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 691C1F513ED
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 03:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2846B0005; Thu,  5 Mar 2026 22:09:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98CC36B0089; Thu,  5 Mar 2026 22:09:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819BD6B008A; Thu,  5 Mar 2026 22:09:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9276B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 22:09:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1333813A84C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 03:09:28 +0000 (UTC)
X-FDA: 84514157616.17.248A906
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1041A14000F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 03:09:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=DzN7iOin;
	spf=pass (imf09.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772766566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a2wyFmqtgQuSSxu/y1lHXpYQVnaUEjD/9HUkzSu97q4=;
	b=tMiNPL1hp7a0PGPRQylrm6mwR0gspuNpBEAWIEgXaCYtVcE8LrmEk4eKb0PthRG756a57i
	wln68lR+RNYEP5ABFEW4ahMUoM/EPefcGXNT6+MWjdqxxYXEfWepHEwAWEZTTZ7IW53NRz
	2eFcrYXq993Jsv9Lw1Y5o4ZoWf1hHOY=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=DzN7iOin;
	spf=pass (imf09.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772766566; a=rsa-sha256;
	cv=pass;
	b=wFKcyBPvJX39auVvILKbPE/0Dw8Atw8p7Q1WbaGowug97EstIPnGcOfO+/aQ9MwDVCixVP
	Wm3CwWTf+AqQWi4yDc8M+End22dS+rrp0J66c6CYXt7I86db/wBg6UPeSVdHLBWKQwFPv3
	OKevrvDQSYjVqXFkkHc85474XJDI70M=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35994d84c6dso2071711a91.2
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 19:09:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772766565; cv=none;
        d=google.com; s=arc-20240605;
        b=a9fsVjGB7BVB9AjmbYeyBkJ9ywkkVjqIjclwMmRCrvp0aLx6f2iznoMSfsY9TFCxfn
         T9ARZnnq7hFr45mmYyyuqAMy9CiT8aK08AkfVs3zDQWuMBWWC3RTd0d3wOAqVX2kiyrB
         xXnQXwbhH2VDi02fAIiXI5xv49Jfra7kXiUpCg+NC6S4uXunO68CHIp3GE1oONanmCTH
         94wfD5XEM1QvEmslkD75BUNCORLVVS4N5YC5h0WUTORkfokVd4I5dGXFcAe2yJ5wCARp
         wW1qkrlHkGZ5SzE1sk2ahPDVLO+Kfz8WytT5FB427ucIalQwLn+Of+54IKK55DhcVWug
         ai7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a2wyFmqtgQuSSxu/y1lHXpYQVnaUEjD/9HUkzSu97q4=;
        fh=eGowkcsLK/EHsgWrUd4XKh15SQL3DdfLX1AKSIyEtcs=;
        b=Ho2g/kCFpUUYMreQT2YhIRI4ZMg8JLUdKJ8lJq+td5VIMLlQcuYGPYBVxJsF4fN80z
         cMXudBD4uI66dRng9MyWqFPV9HGU2PaVzOc7QCqZMaVKGKM8XaKJJIDmyyjspj/VexyX
         r4pjkoFFp1+bYWMrKKnCyDGBtO1Tvvo9sg5NJs2E23+sMyM64QDdKhnFyfHo9pix7kGs
         nOLKyuRynCkdbk+sF6PFdHYfWGD9vWxtBjlXza00oA8JYG5hT/FmwLOzNdtp15mXdR8E
         U+Tdj7t6YnU3i/8CVrAEsu0UYDlxL5HyaMQJPP+te1mYgH2CTOyJZ1kLIzjahbKERtzS
         9zug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1772766565; x=1773371365; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a2wyFmqtgQuSSxu/y1lHXpYQVnaUEjD/9HUkzSu97q4=;
        b=DzN7iOinND39gt3UlcQX14jKRRWpBT8WFF4Y9GhmyW27JJr3igP5v1EDxKb5PwSmdO
         mLxVG7IQ7L9mea6XkdalhjO23DrUXIctSMtoDmZp83vINxIfo4HhIxP55eXt7ZlNpJxv
         zCvp19sflJ0SO2X4E3gk9pYp7e1fFybXgwAZ7rm0x4/QLtnfi+B1b9+h0v5BwJQmIIo4
         XejYelI3gshR4EUJ5FME4bxllZqvrAXH7pTqWxM4gRfX2VHllNRNF5DFVulSJC/euWsD
         7dEptHJMDFmu0l5WAesdFsaF+NGWLpHGLHmvhvW54fXfByjAUtefMBgEOYnxqkMCUhLC
         Xt5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772766565; x=1773371365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a2wyFmqtgQuSSxu/y1lHXpYQVnaUEjD/9HUkzSu97q4=;
        b=B8hRNiesiz14Ey+BrkgwjspD3hBI+kFDEwRdEXTdVedGgbpcv0lh7cSbeaQNSNQkeb
         PRTRCbh/degZOIayhXRYR4ueDlGFglZibTCF1HITiNHDASVtPW6p6XWL8dFJqshOSyKu
         RwTbXCzrSLTE5jvu9JLrXiGrC40e2oBavn9VzKM4lAKgoD+utGUak2RUWtFaZa6aU9mG
         9llX+9HL3qajO9Yx5/cwocUnxBIIXExLLxz0h/5s9pyJWdewqNhhsuP530JDez015hXX
         NaGnqdkRAC/bkVpJ6MHwMu/t819gMsfi6RCV7/+8d6Cwt3drEYt0OpVWStHy6spFyunm
         QPAg==
X-Forwarded-Encrypted: i=1; AJvYcCWteNGa9kuIUkrjb2uPaqQXGzgCLKms4VA3VABFFSxyYC32qMXxS10Z7/nc2+otV4SK9QjlQPgz/A==@kvack.org
X-Gm-Message-State: AOJu0YxXdnW/FmZtuT+OK2RgydkjmpyEqdV+1+8vkHq+2+gdHFi4FS/E
	mB+EtZNI9NeTNa7XwZFeds5vrSxKZrDBTV3I2rcG2CTZaTLJ0yndoRdg3Gf5dUGLcqHvtzUvH6O
	1w+nLBaxWlfy3JOejKpc9kONFCUBxlqBAtAef8+Xp
X-Gm-Gg: ATEYQzwp/sfRZv/d7eS9ZtOwcd9cmKE3gMdlFUfEy1QJQiDIuTxCUVJdu3gPXVDiPfK
	LNCJH3pHljlWhLfWICb2BJxGC5+YRppROs3xrlXvyyymbwd5J410ppPPajwY6+ZTY7IWCa9EXG5
	n+OemkBSZH/VeO0LZ34E8FrWRmqvzeM4QCx/PSK6c5KiREvBYvqlLB/rAjoz8snwajH9AA1ogPJ
	Nh77/mQgRSZOjJcva8TVdeYbAxfSziUGPy3aTGlZ4Nv3iSkQOJ7DlmEaU/zi5W6CAmU8WHsiXJ5
	QKsU+m4=
X-Received: by 2002:a17:90b:390a:b0:34c:35ce:3c5f with SMTP id
 98e67ed59e1d1-359be28da81mr585228a91.5.1772766564424; Thu, 05 Mar 2026
 19:09:24 -0800 (PST)
MIME-Version: 1.0
References: <20260304-iino-u64-v3-0-2257ad83d372@kernel.org> <20260304-iino-u64-v3-2-2257ad83d372@kernel.org>
In-Reply-To: <20260304-iino-u64-v3-2-2257ad83d372@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 5 Mar 2026 22:09:12 -0500
X-Gm-Features: AaiRm51A9fGFpauPslQfX6LBJuSyutri4HG-shh7wAOHtGm4QDzvXC5jtThE_pI
Message-ID: <CAHC9VhQix8opxrX--w-pw5vEAiLaYX=kPhnm4x+dEFEwHiVnfQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] audit: widen ino fields to u64
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams <dan.j.williams@intel.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, 
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
X-Stat-Signature: ztdscda6ckkqn7ucod6784bstuzadytq
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1041A14000F
X-HE-Tag: 1772766565-307892
X-HE-Meta: U2FsdGVkX1+Uo5H0DsswpS8cxkxYmgpgHfFut78ewLH7RZQLKMoMUev1y/yHC/8G0DFCFcYNvW+ZP+6k3pMCHcBqtSNWY0qgv/MGyj6ccDI4OCLpG57uJPoPMLDX5aYSxqLx+VWnMefYn28fKtNzgCG5ZTzdoD3RmsYht0yA5Ev9kWGo7qukiayT9FUpObWnm18yNTysu9Vma/Ne0wEeNTJvOfJguyi+avs2CL7Uq+06NSehHtl8RoZNCKTq1q4T0+4wj8/Q2arSEiXvMkNhoii2AjH9BCQsPHK2y4i2P2C6KJZRZgCaBU19gKiS/6A6VTPmgWIp3+4N71wdA0wAtOcmV+AqzIop3FAwT6/ua52264Yz+gpcbeiEOuXtkpd0tsza6MAt5H8QKnC+NHHYz6BmAc5xLJ+mUpV4HycsVY2K/eaer5jbDcGjBwBESe6HcegKu66qZV/vO54xVgHUeJy+wtGv/44yZH9yY5c++o59JJCKYa4oiwisbUOh+Ux4E4OVyfNRASxvgdSLI/E/Wx4Q4IpFeNxnOY7r3o/iieqFXtNNZqXjjVPMLIryqeIPaHb5l18APZoHI3GPxGfQvjlzD4L1rSRSFsVXQDBrb2cA8u5UzgW4DY25ljTMcqro1M6ks+rVAjE5Bjqc6Tx/CWaIBEcxmuztMpo3xFI1y0ST4/EkYf1AYlaEzWZ1E+dpTmvGIpP2abHgsHYHZtxFYOsYwlB5uJ7PJp07IQ6Wz1iygThDB5BNA8xH6dCitAuXgdsEPoQNxbHXUOdd3zTUgCCfEn74Ch0QMNm5Dg0RzH38wWpYVdcfXZsHBHdtlEA3C4kQZSw3SLxs9fbsqPs9WHnGySBtoctdgy0UPTHObqFsOHlzNe7bQU1kGwiaacaeUDuo8XGoiAyMuRCUum3n78LOOo+rBuQBwQRD2SPh+1XWHCnMYbpqOPGcwGMm88OWZPJxzR5QVc/M+sbgD5B
 37y7iOQo
 XR+W66qZgoXTn353huxi6Bwsx5DCYGNE1bnZBilE70wWBMg7Abhfgv2MiH2aLkCBenUXA++GLbnRp8OoekA2E4p3CPvfEHZlSZPXXDmBp02KtL3aRzQoVKanUXRD+m38kfXglEqLHL7lPO+rzRn00mMjRbcs8f5tTkdWyAkwg0DhH8DITrjgIBAyOj2hMTT8keW9zIY6uxFAKm+b1mVNNqz5IcTun/C6GUT1kpqHTpF2N7MIK0hnGLmY4xWu17sivEnDc9ezgdq431hKiF0qUWJgDMrj5joLXaIiOfu096YuNJdZFrUAINlLIxC78bHaPt32Vv+YuKtC945xDVRCxv+1xjb0kaZH4Oi3wVjK7Ze7fyurZlVSnXzv7e41e1xffvv8EQzKDi7T18N6y/xam5sfJReE/LYadRWBIEktVxPG6ie1XWe9i7lx2wXPxegAtAolmr1qjNxIE2TB0VVcDo+0U1megZbzamd3m8/iO8TjP5M4GAh7rffdSNcjR96G+80TiBRdE/2n0q5p2cyyv1AzLmm7+KFgB911sVbU/HZSjFhjoAXwrGQyzzVOd/03o3jU6pp3wirOcUyn/rqmdnhtetlER2hnyGHeE7g/Xg1jIdQZhG2Xk/QVw62f1eaZJMi4amofU1nTmetVW8h0S7bgm94n0RM/MlN1oIAzGI+Ql4O42bsSLIo5qp+V04d5vLrxGL5z19Xm34dWdrRq6AUi1lauawlUmSwJue4oGrK5DmUtmznan92NNTB3KJUofRgrEidD2tXJcm/dWzuBDuT2W6AXOxc52VsO9O40RmICpkbFOxOAywCEzG76QgYqIU4agGCanmvGHOudOXvbe2tslGfnNOZOpCocJN65VHXpwBC7O3TPmR6Q+2c0Yxzy92yM0k4XfQnd+WiiCoWIjXrc5IsA0Hh7kYqbHMFJDE+KB/XhUp0SJy39MSgYB2u2rbVY9X4QBYruWQaMwr071wy7/2vMH
 +2rJhdpJ
 +i2+CtIRy2D4QYbkyik/cyoGgQIB7kKckBKvAnRI3U7p1dpJ9AK5z1W356WkUXSAYhmvRKRyua5ltRFoZ895X8xSWkG9hY9KKdnD234V8Zu0Y7tUYbgdsZH6cn0m4RWkphh5dHBeojsqFERLmljKdO6gBdB0aurxlisA32sAg5a3Yx6wD0AWR3jFXSGomKoFa8nADiN/Ku5XttLSGmWk6dF+l31tCwK9gyHc5P0J1e8jh7RrqFCn7pYKmmllsC2Hi6YjZvXEfCZKbM+DY2kPFrYUQceH4KlmlztO2vHph9igSgN/tTaxPsoE8AjvSNm51xR+CwMVKydmE0xcPhVlC5DA/HgG11tm5LZHP1qkrPA1B89DhvuhaVY5DXe8Cn7Od64AIOtNwi4Bg3Ww6z8KA8n9XImuJ9zvGfZmZ6+y7QpU/Q9lR6n0eOMdfSgWfzzByDogP4hNz+y/k+8nYKVBEEKFF2bY/UBFHcOkwR8lS0xr3U6x4oPERvpaHgKYpFfH7yDC2CKeF/LHGW2edFiKUsuKIcgMSRXpXGk9rQA4iqMDCRndzcsKVxmoRkuUbaqZ5VsIYqlKNp07xugjIhAA3hlHir3r7iCjlPh25kl/q0cwq34tp2fEJYAdoxlQ97cs4Djt27Fk9r6TVtTYCzdNEaemmGijmM+ex53AANfO4GxVIFd+mxLefNKpxRHkchQ5IUEKziVuTpWCn1/BY411TsWTssUAvmAqzERcwXG4lkR6mABgStfqQzm2vvb2dv1leJzia/hBmNu2fx0Lz8ctdRMDqCKG5TAqtO4BszzshBJKMjVj/wROGfGj/TI9V9nUAwvdCH12eONS5ibXlNEAV0yoXqUNcIvN0q2gTeTlis13ZklTn4LBipAVpyCof86jJE8lw77zLkPlORUWzKmXpF36m6KA6tmFqVfbfa6IwTm2MyS5bzj28bMhoYIvMZeOIeGuoKql4CiRGdVsCoJmpitYNR62x
 w5m8XXC2
 FIIHemk3+8me01eiaN3aGBYVG556dpeMg5YkeP3qo8xdenZ776UY1TWgGmsUDdP7utxUg1twbGUm8rEnQnPvBwcJ0lAyOCTt5dwVmeelyU7//xfeIiUdSH4uElciMfXo7g1WQQPtJT+heNmlpin6ia0WzEZejgscyrJwT/GlKWC2XTbuOzgtEpJm8HStACbYZ/+3EG9UIR1mBqAOEXefsywtkiexQk6HWVe/LxJ8ClchC7PIQp6IcZYgZdmavl6P7hc6efASb3YeDi9895iYTJeauviZ8x1d3egKmEdJ+XCH1zS+6T0mo5MLBYr1GhEf+2McJzeOZDNs/DRHah+eVILSRB72lPjeYJtpQ2VTUD3HNtAIm9cdVuv9iEarNPZpNo209FGO5IZCjJyUMmyE7z8fsWdLpVMXs1QqMH+F6lxF2e3HXz6cQsDuLg/Y2V9qUss5JISuSj7GF8gwsj3GxzL7mRN9SEj09S0a4AoLsoBxfQK4u5PZPUzM48iFJTZyHh3FOzrDkVI6R7KacIGPacy+W/yaKMFFSCPCCfvPuv7KZrj1gw39Kf4eLP+wLWrcJQxnQr7mi1Adw5jZYIbSXPtSdb2ZWw1L0GoRRZd8btOptF3rqZP4PQBJpIvtS8YCFM42Ust4vPBIl4wMGHS+ppwwNu7uECFMYKTxb+7IHPZCihANvek4ejBpxcr1JAUGk+SGftskJp45G1wlYUuW4lUuzw1kD4HbTo15i1jC2fMnyygQeRe0VuqkSAhLT0oyhmUya3IisZEfvxFMwP2GWpJuO30BNmsueL7yCvMUjk4ONQnBes0uPkBCW9zsd5yXtp6r1GXFYkbJPtlAHyeeI8joZtWpeoeW7drNo96rdfwu6wnb0/AOks7vk38bdgt+i24VV/atQRZ0NQNfFNqKAbqgY8uk6JopbiiP0W/rfTI8WBc2bhFsZBfxwWkGw9ZvcHZAGaqjW8uuMSDVzngeHVaryIpP8
 7H47dMoS
 iWYSeUemwB5CdTQn9iCqZM9vF7xTcfefdLstBVnK3/IQtmS19JCrtCL4Ztofp9wVkyP2WDZ0JMpSGHn1L3KwQAh1928BUit+p0vt3PrBE4aSR2EHiNIlmw51kHyE/6z9N0UFSz0lwF4fVyqfbr59vJ3AnrTNZOPGKRrLVYr7CReQwF72Hw1PdlwHLIbVwAgR34sQ8L5EraQ674rUurr7CYwxE42TVJRfG0NQzTZwuWIdIO+frmMMBTDZKjeDN9Lv6YpZAaI3dHugVuAi21n6mZqZf84AKjc4U7JzAuicagGMqzuMzYqzShEPP1tzoC6/2nQreZPqzFPLIR2Lt6ZULy9gP3aK8TH8B/oowhyRmpMHTbDC6O+FmVJmd3JKlUF/6eTKOzAanTod/4wutZHT5NIBu2Y7K9XOJT6qn/An6e7xC0K1Bff4jQreygS9AsyvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 4, 2026 at 10:33=E2=80=AFAM Jeff Layton <jlayton@kernel.org> wr=
ote:
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
>  include/linux/audit.h   |  2 +-
>  kernel/audit.h          | 13 ++++++-------
>  kernel/audit_fsnotify.c |  4 ++--
>  kernel/audit_watch.c    | 12 ++++++------
>  kernel/auditsc.c        |  4 ++--
>  5 files changed, 17 insertions(+), 18 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

