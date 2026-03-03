Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F14CEDA694
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35C86B0095; Tue,  3 Mar 2026 11:17:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2F36B0098; Tue,  3 Mar 2026 11:17:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B907C6B009B; Tue,  3 Mar 2026 11:17:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A36876B0095
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:17:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 417768A028
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:17:51 +0000 (UTC)
X-FDA: 84505257942.21.2D9D976
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 38347100003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:17:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Pg0alB6i;
	spf=pass (imf14.hostedemail.com: domain of paul@paul-moore.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772554669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vlM0HTuT+/Lu8GovscjfA3KZuqms5GnXWRMciKBvDhQ=;
	b=E8v592vnHYyCF+J5t43UTp2c9hR081xptEZPpNmKuC4R2hB8e8O0feuq0lJysH6zoULFMU
	X3WQYNL3iRmwSNdZW7F/xKUqgUWKiej/Y2u4+xdG8YsmI4BjNjGVWHvBjuaYYR1eESeiEH
	1iDy92ZfGGuJr9jt07lc4bRA9v94RV8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Pg0alB6i;
	spf=pass (imf14.hostedemail.com: domain of paul@paul-moore.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772554669; a=rsa-sha256;
	cv=pass;
	b=gxLHTp33Lt/KKN2dzYAzI1DL4hUAByxoVNEPWS76y4JInQyYnSolacV5hOHjspOC2MqlPL
	BE3/MDNte7nJx8NaMvmHvzqBJRu7KU9E+Sxf+/UAmT+fF/Q15mCBzK3Sj4Kuo0NG07yP/Y
	wINH4C5G0wjxH4yMru7AayplKsUwgFU=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82418b0178cso3394581b3a.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 08:17:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772554668; cv=none;
        d=google.com; s=arc-20240605;
        b=KCe7QDy6vFuDspG/1fzZ3g1s/9SSyLVSFt4gzsBfVgE2/83VfbLFbS10q/VciicjVR
         vdUyHsKdl6KdDnwHFlFbMJjUKt0HYBOJfzo7gFgyOvjtXNNI6AFNm7ctvGIvKPYQRmJJ
         F9XMK8c+fRz8FEn9RSPTBxdxXM+sqKyZaYUeN9SFqlI+Cq5Jty5ab4js5Uynoq4kD1k1
         pEEedfjB5tL8rkivEnvPsqMazeQ6FRMG7AnER2nBZcHng47iWJxd6TTHSoJqVsMP6FMw
         9m4cJ504p8hb2pRpfElVUQBIRhQJNykUakI43ilV7op1E5csE38gXj7SrxRRbxo472kW
         NUfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vlM0HTuT+/Lu8GovscjfA3KZuqms5GnXWRMciKBvDhQ=;
        fh=JYkjB1AYvp6TdyqJ0UwP/K8lvGgr7Nse8t8FPojWvJc=;
        b=Dj97avvAlGjSvL0jGsckI+ebgg6t8sG6bFzEyEA1foQhLJoVSK8Qts/RfTnrlT4Cmo
         CfxwWQeF3D8Fu3i9zRpoRJ57yinnD/m6KMJPry09v98dsJbV24PZVjrjqXJHYvoTTkkK
         cXS5Vo8G81Lweb48g1wgjZ1Vg4gskxCLJECJ30Ocn+4FnpSkIaSDLWGuLOMPzsiD7mWa
         V3THlYY1k56YRXaKgfNI/6Him/JsfS5oxNEDCcE4olF+3WppwrcYsV3CuEjCBlSTWjdk
         513I0t7dk518/AUEQTjmquX26wONWF4qX3Ma5hlHgK6NWuGNrBc/9benmKFnjEkR1eAp
         T22Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1772554668; x=1773159468; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vlM0HTuT+/Lu8GovscjfA3KZuqms5GnXWRMciKBvDhQ=;
        b=Pg0alB6iFBXawbIUqekMkq5D7wzscd4g7AdfwYjUr/BFAafoPKC18/JFn1v2fKTtiQ
         lQa/cpR1NffdyAcMvvMYu6iyxMqjRRhMz0y7QPvAVx7GAEB9H3vUhNhmknDGr4qrXJ3h
         7QnsQsyPOzcJ1DvKcl9otNYX0xVHrfl3pDjbsjzhAfCyuLk/+uEZi6Iwm60CCKrZ0//G
         /wlXLyLFK9pVak51EAMLmVX4RqQ/52p4vHmfDp1qcHACrHkyK+cxLeyS2AMmbAgmhx/L
         FDRZAWfxOKS2VSTmML24qedlOsJi8GF3vwz7JPHlNPwrsePj3G0IXl0l20YkvY0ZMd/A
         O1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772554668; x=1773159468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vlM0HTuT+/Lu8GovscjfA3KZuqms5GnXWRMciKBvDhQ=;
        b=eP1tgn5LGdN0FRZqpVcFo658jBns5IBTEZRSSZyExsl1uZxRsyv5g7OBEZTMeQYaUa
         EqM2fLjqbRipxB4SbDL1r/XZtsQLy4XCdsFoAdyTLnQ+kKeN35GRyYoWp6vxBW61LPUO
         Z5lC1eerPGxgrdMkoAqvXbW7TYkjj3rNaKyBApEMQdME1RC84dZpjCQGO11ElB/ft2++
         RjKRZCN8PkOws8VN2/csWW1Xpdl3Mnw8VWhFUeO+Rh2ZoP4pgtSZBHpVeDFBcAwruwRs
         QhIBFqNhHtE18FCTji4SNaEsup9NDOipfmOXISjaBc+9xIEoI9pdAwAxI+oXBCZ8zjoI
         iz3g==
X-Forwarded-Encrypted: i=1; AJvYcCWOOnFSa+bZyLRtvUGgJeFnJ+LLu2V0mh3E07hNxrBmxjDpHAl0oBmIOqh+P9QUqgY/ZnrcZobtTA==@kvack.org
X-Gm-Message-State: AOJu0Yxc7TOx5eF4UL3MNJwgVKUbChIeQ5fbHNfvgXJc72DDYbduoL32
	LgICJXB2q8IsnbP/EWvMMOHvfNpdKwbGV1K+lW+Vl4GQWLA8hQ+5zct+OmHk1IfSnRnlGDWUgir
	y467fnuJIkI5weH5j52lPCsFApdThfY+6EVoKUpEZ
X-Gm-Gg: ATEYQzz636b9AqDVee7IiBvevaHxddRvztnfPO9E9NVuZKFPeV0O7AOeNGA1G4uRaPm
	bO+yQOf9ZhXPGgfe39pcsTkexf2YbpfE/Vxnzha45zzLt2HTf73mlPUxeyCHp1F4y+l29JBPzQc
	Y/G64AaxrUEjPB8iYQ5rk29sU0VmJDA8wT0ZmwN/UF6PxZGgfoq4KxdTfYpSG03IZlD059mrd3G
	zanjaD+/VhqUs9qHWdLMhbGgYzAJyUq079ueeF/iVThpSbnc/iT/zapqbpOiaDTz/knjI6K1SSc
	Xv7kZiU=
X-Received: by 2002:a17:90b:4c12:b0:359:8d70:c4e6 with SMTP id
 98e67ed59e1d1-3598d70c5admr5344309a91.1.1772554667658; Tue, 03 Mar 2026
 08:17:47 -0800 (PST)
MIME-Version: 1.0
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-3-e5388800dae0@kernel.org> <CAHC9VhRnmBuXEKkUPQhJ_LDzcksjoAJL-ne6mFoJdR1hnDdzsg@mail.gmail.com>
 <7a0165fe39e82a1effd8cce5c2c4e82d6a42cb3a.camel@kernel.org>
 <CAHC9VhTyhnG7-ojnTnVdh_m1x=rKxw9YEH9g7Xp9m4F78aA5cA@mail.gmail.com> <add39953250a4a1b2fe2b09deb3373c2a7482b88.camel@kernel.org>
In-Reply-To: <add39953250a4a1b2fe2b09deb3373c2a7482b88.camel@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 3 Mar 2026 11:17:34 -0500
X-Gm-Features: AaiRm503AvilRZsmzje3hsLVwZQN2UeIDoaYrT0wwtgoCj-_LcRzyWRvZdGrFAo
Message-ID: <CAHC9VhSb3nAsJBxhqitDVQw=J8hX1CJDe1xqL-JMjOA5J4tUkw@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 38347100003
X-Rspamd-Server: rspam08
X-Stat-Signature: oj8r5coybm3cy11fnfotj481fk8sncmj
X-HE-Tag: 1772554669-296182
X-HE-Meta: U2FsdGVkX197E3RuWBxpByRfJ00C5kSMcHK5uEaOvI0n0kzT3MW73RNYrIPJ4+RUdXSTpyPMuRVlKhHAljQHCKat4xKof+8vsfxHwmx+A1D7kV3eS8F+eJcruwj2crvEsfd1dtmaUl0iym3J/wn8t0bCycZCoZlBREEt6m12WfPLNX5d9rgbuTUnG+hqjACCHQsF3dQ7nE3cchUJyjxZq6TIhf/I6k50Wz85Kn9doiwcfugioi7yWWnqR09kQDGfiEo21FgmJsjuJ1l17Lafjv88nuZ9glVHhplHgN8LcLiFABSQSDbN/WlFb7cslI8BS6LS/3SvoMuG8bizaxZsWg1rDPLjlGOsz845VyFH4916DItuvwY2Oa6l18nvvanYdK0+gg/Dt7tf2dJFRfenRiQIeLcTcO28xQRRoWeibgu1Ego1vhHRqqh6MKHZeTYVD+wUHYW+0XruFnXq/1R0XmdjB/jqF+LPgGkDk7zoA3piKRhvyss1BB0nY48c2CRoVghfcbUI5P1s6ny2uLWio4aVwz0wmJFswEe9YfZEC2803tPLf0RmC6QfjdyRdLqlaIo/glZ47n8QyagjAW+buxiW2aD/PHSffBQ20voYyn0VNhSedMzVsiSIy8vTalMGQxrF8VcdwzDL1YUumD5/PteYeuVqpK1LqR9iVfgdxoVrrBd5gGewPzgHAAXjdE7B4T/0oHe7sjeM9t/u/sqMLgCtso9xd9kadvnKUVUyiCg2aRrwzrHamUO/AleyWW0Wh0Xf3tLTmFzSKv/l+6w+chkrtcXs4brlLWI+uVDpdqnu+agfIMJ9KXoTba3ZE1xBYyJbehblHi20MzPxrmlUqTXlth7DtvhXS1G4JZaDpsCASQQciZN3KC5Nzw6RJZE5caWT11vD6fPDtpozNQuAiKbheMUtFJBa2rsSokOivlsHdu945Ja7FOLiC4gr0hRspLXZMN6KvcMNcRAcqEl
 YumEMxHm
 4GA6p5fQpAnGOEJZD8D2gp7K2cyqZv6Np7DetOpg0NdJJM5glbhVsJPXyljaSIauD+982e2PXirTqUukc97wo9LJyo3HNzwLXsnCcb4t7+Kop0Vbp6L9rvv6Gum21awOA2JoKjtnOogWtigPpcymzfGTkuw97618Pw3ue1sY7nsMrK60x+zh3LflVF/+RwrNHbF/4+ABnDsrpkeu4x9EfmCN90ut/OIpCs+iVKyty5VS3VdhcWnUSRrnHnFUJ5lgWOpjaQaGpg35TVP3EoQyd6Ie4iZu8ZDLp8PskqwQVL50+Di8wjkd5GWid5Z4lAxkwQJk9dOI2n6iyo+N0cg7YhBrZCMoLeKKvKLQNW4N9qrxNHFdQ3WNWog0xTHfaaBV4UTMUAVVklTID3TAl2aWlZ3jmGH6MfXgymJuj6IauFYN0Hqv2v+qMQp8UikOeNqrNXXgN5l1xGJGhbdyMhK5jhfWqwvjSu5JnwFmtESLqT90LpCKe5kxhjvW1TNAsZ7axouWpqlOH/hrgYp5QHNGGW2yGYIaLt9fswbMYUfxBrkdOrIe1vWbXDpSBiD9LP6cESdtqamrYtBVrq3FaUeVU7LJJbpF7j0coXPpFCUJPsro6ac/sl66hngPvn858ljZn71p0b6BPXYKQWqP0GY7ixeDkhTVtUjPzH/BxrjelgMvLundZ+AsNb6NQpuGl5vPNhqlkvFMu4K9OPY0TqqjtFtzXSyaEgjD9+Y3YxS0wEvV0ajXIaX5BQ1nie3AoqOw7N53AOehgFm3I8Zh5JLccBaSFFQO54O4xfnP+eyN7qyXJu1W93H5H4DAdAFsD4KxrIM5W6fqbmng03VPmPH3qTq538BtzTlq0Gcp1Gmvv6cRwHwBCZOpDshW3ImYPAzR1HZUMXG3Wza29dy0XaPkXV2JPbzKslPqgmJWwlxFrF+rNTdqPixjH6ZKpiW3y2lBqMwqu6nYmz02JW8CJy+DDDK4T62Vv
 7A/uEVw0
 uYjx02gA2lird055CED1VIwRZJpZAoJYSOEe8G/Y9EMcNnHriMeuJF+mANHDH3yQhRiby+IkJbfMQELDwbaI8zYbFP/CGv9A+xyIPK3mMw9bF51kTc/SCfKXxxf0ePkA8xYeMxiOP+cRkKdFVoe/wcAYpRa3wApCEhww8YaMl6a3v8ymToYyQTJYXi5XJobXqaUazjW0M+6xOmSMUkLirJTAosWDzzToe2hNmCXqz0RViDB7pmaA+FfFWDehUfIJz3I+xeHJIr0TfFLZvW1ASpXCdZSUjj7OawVUyohuBmXPj51ipwBJ54GtERx8MI6gBCJu9ZuHSYn4NVJFBM3Uku3G2BRKIOv9ID6+9cJ6MUedDcYVHkMqFvLZ9nkfI62radf+cHQxSuTcsHyt+eaZLW2BZ1jP04Vxt5i4GOO4TetCJvX82ydGHl7Rb7DPfAdIl8U5PlAvxwt9VBbArsjczlOsyX3xCEPC/KnEx9x1yaYb6gB/OPBHO4ohonzWGI6+LMHQQEo7NuGBE0xeI4hPnZFtAC5aA7C8tcEZg5YFJhJEYYYHot3+6SMiEKc53eH7bC4L8jRjURG14vN52y3iYKHJbp1XqtodGdLuem2okksdEHtT/ipj9bpWH0pHsnrvvmsBOinxnVkeqshf1/GZRnOINUdR1kPB3fN81vojg34zmnM54NzeLqWyn9xlzsCdCjDdBfImcIuceuzJlChPeEjL8vjQrn5F+HVC/HJI+8K+sACTgTiyUMyGchlfkbHBnYH/ggCC/PwK6fL6rBc6UWGLqmW+o/KIVIIgKaD9hye0WvgBESKQc1xa+ErxRQ+QwZWwSC2nMvvbxZlyNTnDFgJ3XoWnxfhnf6tN/CqXBD9ltuWA3r737Kv9MjKjVSNvdw1dSsXg1OU+3ZngjQWpmrI/cdsin48wgr3VpIdll9YIdBRhcq1B48B4Kd8s+8uHB9Fk/gO9iTESE5tl87O9gLp7Z52zS
 BmzcFG8u
 rA2moljxGQfc92pnP/c4c1m5bjikIsCpgfa5SpyCpFvSO3gXiRXSU5XWybT8ujXCHEmvDbd/6s2A34uRiYLyYqXsZ0C7coAENcA8fGX+2OlxJL17HKNFsenIEHD0z5YUNTJcVwVxwXdVkyTtbimWHX5SGnvKrAi4Kjn2s83SkJtODOm+XBoMj46/N5/oAZUA5IRSzRJIT3Cajep4F2iJrj0EUubGStTsCE4O/lbC8ELjjt388hhJmL7bS/oe2AA9OE318MTZl0YRM1iDU3xp/4egiBNBhzs13lCnFp4pbTmOCDPXrWPLY/nFRfr5R92XbZs1TV47svZ2YitOWoplL5Wn3zccC9nq11ArC6M2WJsaN4U5mT0S882ZzFO8Yu9wT6HLOD+CL3ehsaQ+XehhXAB+42Ji4/egVejeHfATfRurOVGf2d4AbZtD7VsqJqUsVisfSzsBC4NGqqBiEzG1UMbnikCCrGPaO5nnmvCeyzr37zTCVckmeXzOla700+tBqSURhxnf1Rhn8fOcBaQLGxQs2V2hK5mQb0zeKKsL7+aSRIhb6SaoP5tYV82VgyEOwkROfJ6bBSsGZvoDkf66lH0+UHGujjIxFhtcjDbdgIYDURLW04WyThELKnuSeuE29QCZgT+o3At71wi3k+G0Wk+I2Dv0A3L03oerwQ1j+nYxRtx8asVc4ftXwNYzUckGt89aLroigvRt2hoPr22CiNYmJ9I95gr0vdVCZV6zsU0WNt4UomQeZoiXty24ZPxlW34+p3jY/0Pnsv4kKYek5uJFYADv4QOeXkhTsLU0j1MRK7DDSwIqy3isvWgUG0Waw9QE4kS/amMNmwbVWMXtIyL9XE+1U8TkPdPaUDOLY2eAYw3UBYfrOzUtN2VTYsH1nkXFxK043P6aGoubzXbH+j/qfkkhBymuuhHT6Y+W6lz5fEGBInk0+tdzGZNC4rZWD860QpReEAyX3m6astoUXwjAJaApI
 iUkHQ0sc
 UxdKdCkavgqNqHUls1dig912tEKdn07Wm87EOojXU41QNqbPy59PPRnuPX0dLEDWKm4u3kqGV4rmBh6MdVN7mulGgJx9GVRLo2RMOulZdbb/T2Hro+zIRiVrm3fs2htK6xmE4cZd9yRHILg9C9FuwJ60BQc5MCagUjznw3l8Q6NI8Yjye2ZfAoD3WEcJpx5nUWU4GBEkICKL3TT4VFV9JWT1NUzPMRF1YyfJ9jrNcs06YnlF4aVe99n0pY2Woiri+27zjqVim3BWQvJVSRVvRzyVKzC4/eqBPEvIsN/acRB+lZP4jBLUW+Lt8evm699I1/92hvwkTVcrMkMRMmszDYB77EvAJ2cJ6go4kqHravFwZlW61aoAFI+LgEtxt2hMWwYezlbWTMKjEhq/TAi54TLHE35U/tC24AKr+CINddk7M0Y3FvXb2P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 11:12=E2=80=AFAM Jeff Layton <jlayton@kernel.org> wr=
ote:
> On Tue, 2026-03-03 at 11:03 -0500, Paul Moore wrote:
> > On Tue, Mar 3, 2026 at 6:05=E2=80=AFAM Jeff Layton <jlayton@kernel.org>=
 wrote:
> > > On Mon, 2026-03-02 at 18:44 -0500, Paul Moore wrote:
> > > > On Mon, Mar 2, 2026 at 3:25=E2=80=AFPM Jeff Layton <jlayton@kernel.=
org> wrote:
> > > > >
> > > > > inode->i_ino is being widened from unsigned long to u64. The audi=
t
> > > > > subsystem uses unsigned long ino in struct fields, function param=
eters,
> > > > > and local variables that store inode numbers from arbitrary files=
ystems.
> > > > > On 32-bit platforms this truncates inode numbers that exceed 32 b=
its,
> > > > > which will cause incorrect audit log entries and broken watch/mar=
k
> > > > > comparisons.
> > > > >
> > > > > Widen all audit ino fields, parameters, and locals to u64, and up=
date
> > > > > the inode format string from %lu to %llu to match.
> > > > >
> > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > > ---
> > > > >  include/linux/audit.h   | 2 +-
> > > > >  kernel/audit.h          | 9 ++++-----
> > > > >  kernel/audit_fsnotify.c | 4 ++--
> > > > >  kernel/audit_watch.c    | 8 ++++----
> > > > >  kernel/auditsc.c        | 2 +-
> > > > >  5 files changed, 12 insertions(+), 13 deletions(-)
> > > >
> > > > We should also update audit_hash_ino() in kernel/audit.h.  It is a
> > > > *very* basic hash function, so I think leaving the function as-is a=
nd
> > > > just changing the inode parameter from u32 to u64 should be fine.
> >
> > ...
> >
> > > It doesn't look like changing the argument type will make any materia=
l
> > > difference. Given that it should still work without that change, can =
we
> > > leave this cleanup for you to do in a follow-on patchset?
> >
> > I would prefer if you made the change as part of the patch, mainly to
> > keep a patch record of this being related.
>
> Ok, I'll see about factoring that in.

Thanks.

> > Ideally I'd really like to see kino_t used in the audit code instead
> > of u64, but perhaps that is done in a later patch that I didn't see.
>
> I think I didn't make this clear enough in the cover letter, but kino_t
> is removed at the end of the series. It's just there to support the
> change during the interim.

Ah, gotcha, thanks for the education :)

> If HCH gets his way to do the changes as one big patch, it'll go away
> entirely.

--=20
paul-moore.com

