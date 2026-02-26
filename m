Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E33FD9E13
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1094C6B0099; Thu, 26 Feb 2026 16:11:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7036B020A; Thu, 26 Feb 2026 16:11:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6CE6B0246; Thu, 26 Feb 2026 16:11:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0B006B0099
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:11:57 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DCFA1B6D19
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:11:57 +0000 (UTC)
X-FDA: 84487855074.27.D7CD5DE
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6D702140008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:11:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=di3e1G9d;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772140315; a=rsa-sha256;
	cv=pass;
	b=MlDls116l1j6CBH7l5D8V0o95VQBzdox/L3BbhUfS0rOGcT5v72bC9POx9hwfMKcj+vSqv
	XD6awRHtJcQt8yTss2dKbfHp2njW54rQSoYaOpRCtM1ElWKrK99FAhrtoQnHf5wRv7isYG
	kQG5R6AfTUg0L1akuafU2CymjT0Ujig=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=di3e1G9d;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772140315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmNhsrxkJsNmzJoSll+GD0SvmHq0rQdZiw5NaBd3y6o=;
	b=0f1H6+LXUNq/KgrNeEIUOEMk91ZKPBg8S6VYa3/Bsi2p2DXpBgxpZDc7Jesi4tLhUS9YYg
	V/lN7JAOyr41cv7zDeXZBLiUVqXpPgY41jx0LXbP6PV/94HD5mKyC4ASJc+tH1qb1rzqq6
	0lbQxWtglEx+achcAB5Sp2aH+mG9EPk=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c70bfef17a4so739142a12.2
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:11:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772140314; cv=none;
        d=google.com; s=arc-20240605;
        b=fayM/KO6xiK8URz9n0Suc0zArJrBBoSzgSLWUhG/9zHFZR5SaRchsoSlLW/UKhACMJ
         7BwZNupNd9FKuDzoV4WyLkCkDIVPJ6mJhgg8EOc18xUTu2UhGZjajdvT1OuFO5ewLKZt
         QMZ0ARXBQa+YnSGWIf1X/bMWbAZR9UcxeOQ2qgkm16+cRBFfGmuEQolaTqgTetnivdtW
         lwR0wDrD1hOFR0rZObqmPjVGkm1CSgZGNTpHxWhLDvzIPHWbks0cAntjVyCwF9jeq0HE
         vkmslxVhf5NkQMxUeaxxZBh5S/x0ll9IoPA91Xi/LgtqrRBcnm7oed5xfvxhOobNxqWX
         XeKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zmNhsrxkJsNmzJoSll+GD0SvmHq0rQdZiw5NaBd3y6o=;
        fh=jQAfLLWqGF1XNHQOsTPb3AX/L+gbS2vHtojIneVou/Q=;
        b=WYMsouL7ZL2L7GWYPPyuB9KLfZYj0Yn9cz8qbJ9LH/4Ydg/QCxWj+DY8rBXM3Q7Kz2
         pxpZFhAzFr/M/EruSkKrK1nHvUwrMCUZb8qQsh5WFwOvq1xpNEVtdvsNgGxM4t/QTAw1
         A6KxYdlWZsF54Pdk1m3NX1+/gC9vq1dLLdeRLMBwGrc2ix7RdxHgvSSrxbyTHpKHhMGy
         P2sdE3Joe9Cxk7YgND+rVetO2VT1UBgvOjeXEyKOTwT8jdeD03H5ysK3Azdn50nFJONy
         l218EGyWai1g8WiTMp64w4bIasXjmUxA32GlYL9zCjBkR8Voi9ZKd/0symC9yCOC/wA0
         +d5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1772140314; x=1772745114; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zmNhsrxkJsNmzJoSll+GD0SvmHq0rQdZiw5NaBd3y6o=;
        b=di3e1G9dOaBrd4u1Le4IEsARZ30cO4G1RhKUdTOHCGhlX3MhBq3bBdMdzF6LPqcDa7
         GNaa6+8hEAt260z2B80feIIEcIjM0wGMyFTyGScJ2hAx/kCWZSq0XTdiz434p151uOic
         c1rbKbsuvsZCr+T7u74ByWCyQGNX9/lhzvRWPOMShTQvIey0r/qHVxlXHiqAjFlzL8Bn
         PnWyR99K1Bbl5CtZl6rVwou+vUWXdoU6LsrMkItSb4bxT+onV3/YGHohtOnPc8KkHksF
         kJyRptuH7RB+Xsw1Re2NTAmbJ4mIXsvRV7scUx/ERZz3B/UiuUfvr8twwtMe2LhIEoRx
         rNfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772140314; x=1772745114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zmNhsrxkJsNmzJoSll+GD0SvmHq0rQdZiw5NaBd3y6o=;
        b=XmhUKnb42K9Ks6w7quieDxPDaugfXDmdnQDt87RCps5Z5Dxk2RByiht2zuTMfMXw5i
         E8Shg76D9luIwjrPHtKgAtIeTDuB2pLSvq/pILMwlgTuWevLIX7fpDV5n8B6t0Nsd8+e
         Fq0RZ4mod/kvUZ3hUIdVGLttwK+Gk90PgOmVAeoRPxWSTsgJWW4yePMcxM6uIR4Flpl0
         IhuI7lVVdHiYv/9MD08UiutA2d/GRJtGNClA88sBfpMsYPs856SvA9JuK9o/2TwO6tTQ
         zQji0+0K+8X5x64XbdNXL5d9xpjl2KKyvduRVf3wOB91dTV2cno5KZZEW2sul5H1SXkB
         3krg==
X-Forwarded-Encrypted: i=1; AJvYcCXgXmHy/Jz+lYniyYNHaKhrHeqE6/gDRgxEWRi8DqFFdlat7GpP14210Guuo9dgk1AZE0Ks5KV6cQ==@kvack.org
X-Gm-Message-State: AOJu0YyaOS2qoyrX6O45DnaUhBbLqX1rspZROPN3h8um6iRs8A4Jgmwu
	ZcE1d4MQK7MWO/YLWRg6hk9c3OUO3ykeB6NXz2BN7ZB8HRE4wNtLKLGJkh8snSwTNYvQqoSaUun
	AcOYU1Y4uzL657Vx4Yd+FiPCCqgT9EwVNOU2RSl9S
X-Gm-Gg: ATEYQzxD2QE+b4w989Q9G1sMuUwvNEHKUy+WSw2DvEvMU95nrEcFGmNR4gJkTcOIf+T
	fPxUFP2Ud2nUkVgdBCWDotXpAGgn4EwQugcpenmTd8reyvTQUMyGhzefN/m/lUFlUPYtgPGsZo5
	kmacdoilGkptU4bqputPPQYnv1MCKlYB5RduuLsDbNJICnj00F2/wmfwWo6e89iHvaYmB4Ptfh/
	ptwRNfYCERtW4AndAz+F39xGcp5auljThTDVEYLeP2ltFTWxObwc5Zc0nETaZW3YQPe8Z+fRvRl
	Qss9LJI=
X-Received: by 2002:a17:90b:574f:b0:359:877:370f with SMTP id
 98e67ed59e1d1-35965ccf029mr498632a91.17.1772140313953; Thu, 26 Feb 2026
 13:11:53 -0800 (PST)
MIME-Version: 1.0
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org> <20260226-iino-u64-v1-51-ccceff366db9@kernel.org>
In-Reply-To: <20260226-iino-u64-v1-51-ccceff366db9@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 26 Feb 2026 16:11:41 -0500
X-Gm-Features: AaiRm51CHDvKlRV2Z04ZUK5c4lU9AiJhpRFTzD6a70HHA0FgEKDqsojtRqG1Wpw
Message-ID: <CAHC9VhTPutzjNfYoRJigC2AQS4wz1A3vTEYn2koeR0kKetYk0w@mail.gmail.com>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6D702140008
X-Stat-Signature: fsn6mszrex1sneptmonnenni6fez57p6
X-Rspam-User: 
X-HE-Tag: 1772140315-827774
X-HE-Meta: U2FsdGVkX1+WklusboKdWO/+eF66MMJXSFrHHiTG5I1/oEdmT8V95OcrkaM4h+PrYiwGx7F+PVEkHxUSkqTjPuDCPuoh4yhFpMQmYTExvmx2wXIik/7T1xvbFR+fXAXHKNkMRlwnCa82a69kxGqDP87UrevBmOtqvegcqsgr86oUvIQEzCI9RZyrFHJsCmlYhOD3w53eRpTpI4jIe0UFPwiOcYG5XLx2raR8RJFvxeRPNd3BKLx9Trmp6rsyiJcluJFg/46zVG9LnEBMpCt8YFcZlmIcCSZjPsNZiBtIrqnRRUpDSz6P4EgAIBvQMYlp4Cx/guaaaLRy6Gu5BeVJoxL/wtrRfo8kKHvF6hxBZ1U1/hbkzVTzi2Po/lxmNzPx2QsYrZ6u4bKx1WYWhmJKs2JQZG8tw0U6GLeF0dgZUuGQ8e8ujE4omT69Ywx8rbgCnJscKsZEsBnhXimBn3tkJ7/mj7RGs5FzhlRxGtgM11RPhpsOJ/j4tZzldZuc+F9O0FL4fD6qSYxBmDQXgrht9UGF4MEbVQ7mwvXPUDjKYoWImKe3mQLXrW4wCIuw+KGFMwO+Pzrnh7gDfsr+/K0jrqc4APUq/x6Cl4VQ+8/0hfcWQXiMk8E224rj9xpSPoVGg43PDmDwrNc7MPMJyghuQS18264EeJ/I84pO7lA3iIXFWtt6kVFq/spihv67oH2nBiPZjkZZgh+5p04jzq9AhcD3N/KzbFVoWSkCSB/doBG3G92xYtGuIcsmD8rzeUY8hyYq8TdPmRqSnD1mOts/vAx63CLJYrGROZqtfItp3QPr0uUVOOtm6Y8z8TO5YZnvMIMnyTfnDPnqq1EYfOdPcncA6N2W0EGCsMf9lfdxwxQESRjK9bdcd73SZDU5R0S8Lut5UYSzCpDO+ldJIc8UpKS/I98Fa4HqBoDCQNqsdG0mbf+xQvepABx/IalYdgAtTBqDIQl/3B4fvs9NvVz
 xGUAtpRc
 43me9LMpbwZiRKcO5Ci5YhvfzDtxUg6ZbaDqf0lfNXSk4YzBzPeJAsRlGd+838hKAWU2ZdDeTVgPWiJLX1GBhnaiek4uGzeQuDg/TiljQI+VZYtyCKoavi/JhAbbsWkkxXZ8yZqWqq24oKth167cr2cc4f+lX6gvQS4wXiijCd+37gyOyiL2FkwZiYT6q7aCHI7qYJTluwK90kIScPfVbzzH+i4OWf+MD40+PdEvNvKA2EUo6Q+WXqNxbf7a7wRJeRlHhf46lb8SgRsM0JeFvoOTkNE0u37AoPyMM8k5ZVFDf6FYGIKfk5si1N1o+CG+nQjBS6jbSLQ83tOY4XORJBZMm1hZGL2GDNOjRcBDzByoWcjoTTsA+DvVAtSqGIt8V+InarE7s1mtBUBDriSlZqDvJSp7eWGr69h3uLTFpDrlNjHfzgB7w+44azmibY4uKgEeAZFuuIe+SaaEvz+z1cCKgCKf3pmqnyU/TSk/0Ex6K3FVjxQBsh7PXbXFuh+zntJ6hTYPrpIFqnSB4Mfc5QQIVuCticmm0z6yXwI1L1WIb6gkiEbdBDZct66Fy40hgX1mKCLHlpW0Wy1QS+LDGxiuf69vj3TE/67uHPRQIaLStD5Z3F26qyAqwPavBIF2/p6u7jFi0LJduBm+9cyX+DmZMGG7S9jau0sENs4v1tjtHdP3yO7BfbvajKI2fkKJHPySQ1kLq6kLgNWzh2hIFQmhQ78Q51hfN7xlpD0Ud4Gu6iB8CYm5udxcrSxs1H5wWZIVym8qf0gfjpDw/KxirNTtalz2RwRw46eB0LbZs372P+vyYeVMFOwXa78xhJgvs39iA6aQnNk5slWvl0ZBT2WW56Pu9eqQ5hW21pNsp/EtWfRD/swCukfRaMj1eYQBUqrwHemHv14OVRCITIzX21AQij3NVEVPyTDTgnSzZBlNRnLP65D3omMsSB/xnbWBnQx+Jc6tDTYA6bVorVZM+dleVRdQ1
 wW7PkgyD
 3XowINlojBDy79l0kUjJBAZR+YfYqe8gmmJ2l4VMpn4Q5Fs5v5XCuOpk6OmzhFk9+5XOa9JqkC88lLWNFAL/aaPc0a6J//vsGndpg7CLL/9+q1cmXopPozL5ONiRFqePtWmyyhyqa4YMt9Xdq8vPbMX4pCwhj2GQ8fji4Ym+Yv6EGAba6dJf1Tlavrgx47YUSOcYb4EL8zEilyH1CA2L0pfyg2oLFZXT/OGaPwVUoBuNKZ8xQxLXU6fBtCMUNudkhxJHxmFBFjJBj5XvdPFyftrwqoEQ1nu2IOVpByPknNmGf3u/+yoxG+QkUguJJlyKWBHSxUDbSGx23EdEVTxNlcUVlSIeuif9fh35wnPml8B+QarS9c6nN+Jidex5YVnLiXjX7aj3HmdsUGH8mRPyKKcTdQEzKot15YiRaq0GXS5mtebtyHv0TjbfnHXdEwz4UXUTwCJOQxWwQY2/99hvCdzKa3xQ28sKpzo0SyeDBLPhJkYRXiBSjE1oKZP+8GDA2OLSyyTjzhLrR5C9vLPMxzqF47N7/e3Ye/BB7BIZ47/fgv2K7N50SfAEaOFkkRig0M3YvE+NBlhvzTSsyiYnjsRtrqGyyldoWV/zHAZ/Bi0NO8VYqxXuZ0WLooFS5LzIK2f7k6vkQ0XHcTCXAfManqHK+Rru++PWO+/tInsLrD36ekymCivy4dNoK/lrZl+NRarsxXKR3s+hjJObIH9hvwwoRKavTmIaX962406AJqX4QBBHrVRDfq/ej66ivsQlZG3uQmbfchAAqIN+tu+ToLS/h4moQj6nzdChsmH1I2r6iDqJlVwwzD/bjC2N9+wZxgTvxduT2KCqmrVyRXfx117ovK3N7PEs5k0pcqRbz+roaZ6MtIy+lXRbQdt9NKBzrZYfN20mMbGAOB0MbmjS5v3pZ2TxqVAUjS2JI48nRGkEwfSsrVdgU6dVpOoctiO9GqFXPl/ozT5/E/PMOoUgI9W3ovxtz
 JP7LPwB8
 xTTYGYOPelwjxRgqgKYDZrHnbAMIuBBTYqnWbkw6vBOvQLPJuVUFXf3JC49n/1TqtUwT4+UZ/6KJhguiOElhdxJ/Xku4wtQXA3JojjshzYyxrfNFWvlK65I1w82JRqZ2W+ajzlF8f0fYcdGjEbCoxfVwM3z+Xg4fzFMtf3fPmMkFUeB9KgYtZ4qHf4N949ec3NLgxgs+L8LBohYsjssfxbTXPoG3gKx1ByJfseVWgL1MNMKDy7jAVZ77w2CEld4gN4kgFRfht9ntUn3teI4/9BNODPJ77K0rM/xaXBeCCCTzAGw5L6y6Ot+1B+0uPvZ6HCTkasdpGQbf9hPpKrlVsRD2RIJyfUT0rI1nE+XRcrTOZTzMKAWYLiyYa37WR2w7PCCzBCuvigr0QKx7RBmVjPZg/nD29iOC5NcO4WZmAqxduZ7iHUf4e3ohSsyQkBQf/ePL1PrWDJOFClID7koLmS0u/CuBHw/IZP9uoQ5wc2M6IvF80js9q+K/CI7+qsaftYL8NjS+viSjG8QwphyBr4972MZRBiQ2XZ+koUhBwlQtmC+6HnDF82UJ6PJ1mYEH7wYOd7iOzmZlECgRe8LWaRex+ERFNZCEYk3BPbHFkRtIc20nVD8aM71g2gCzXrdRBiCkr/yUd9wIx0dXIQOjoGW21Dc68DNo1Fg5kxRjWceKg7Mo24FAYYC3Vo/uykleY8FUanX9IO8R/MlfNMXTuVN7iHqbx96JGQJnRBch5ETcuKAvCCEStWRxzeiNAdKKjD2U6yk/ajXENuQRjyWWJzloj22BdrWUXLY8SBdbkH6B199SWlvueeZUF71U0uzVkzcsFkiQLyti/FupCDCyZctVbLyw50qzXRKdQkAgd3tadWQ8nKJdAkAi1g9fIQhBw3JK8NdMmBu/3FhKbGtn/zauDhyDuK5QW0FQ3zzZ+FML4kvoHJ/y2oFTDOFKfe5k2lybtuTfjRVQlq2BFguANIah0Wzr/
 kEPLSsZu
 R0Azg+gCva7LXoNbQ8JlXJrhEZKdyWU7XGEnVjOPG3jYRN2TwUHhoW/VtP0IdO1Q3/o+HYBvRELeLcVJojoq/V8WWzwh8ozu0nSc7tbTvlPfmhLCOb8YAlm/hI8a9TKKkLxSjpX/YjbaMhrNjOPJRpuLRymhP9l4zDewYadMJlaUDhG20sMiipUQ77bcCfhT6RHkTj8O9cijiHxbAJ7PKP8SSIPKlKNkik98y1PFE6zdZirtb3k1y9w0ndso4CFL6kDybScORqGTjjqqtE+c6Ul7+DXX2enxEzuaqRyH07eKbOK1muU0266DJIcJQ5QJkEucZmMrma76MsHH9zB5pf44G30DTKYOIUhQc1+I9+j9dgIizxPMKXsf7isSqjTINmzEH1dzA/MF6Ctn7/MXx5sxUiqukUHM8Jwu0ekSZAOLhr9BnvPudbwG7kwP8pcn+iWS+ahhFcofqftOhoudUCXtptxXpn/Pg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 11:06=E2=80=AFAM Jeff Layton <jlayton@kernel.org> w=
rote:
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

...

> diff --git a/security/lsm_audit.c b/security/lsm_audit.c
> index 7d623b00495c14b079e10e963c21a9f949c11f07..737f5a263a8f79416133315ed=
f363ece3d79c722 100644
> --- a/security/lsm_audit.c
> +++ b/security/lsm_audit.c

Everything in security/lsm_audit.c looks okay.

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

Additionally, later in this function there are pr_notice_ratelimited()
and pr_warn() calls that print inode numbers and need to be updated.

--=20
paul-moore.com

