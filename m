Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C63CFD9E10
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 20:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599226B0163; Thu, 26 Feb 2026 15:06:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C326B017C; Thu, 26 Feb 2026 15:06:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34EC56B0163; Thu, 26 Feb 2026 15:06:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17CF16B0163
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:06:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C45DE1C132
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:06:24 +0000 (UTC)
X-FDA: 84487689888.30.5842220
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf22.hostedemail.com (Postfix) with ESMTP id AC7D8C001A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:06:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772136382; a=rsa-sha256;
	cv=pass;
	b=sFXSXet2wGKTvZq9N4Xecw4tYN4HSe3g4Lfs3Xfl2M5d2Tf6+EsBadnhKFQ+W0qkJvMXG5
	BlF9ry2wx2hL9IEAryI2FF9xOKJ67JdCfCi24xcGoCI55suevF3aRBGOYI6bgOidEYQH32
	htcOlOvyIzeQgNiZvT28Grj16gIV190=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772136382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQFayWtpCiwY1tVJe/mxs2AbgkdyPNyv0sAxXD5cj2g=;
	b=01z1k+LUegr1Gs6R+r42zy4YyO+5oZFJOPdv02klxtiJYzu8ie3clEusF6DjGF424wC/rT
	AMk53qQuOYcliA5k0GfGEhG/qHp7LelKVu+Fuh1YZk0rXmIjyfHNfAu9qa4miAuZhJpcbd
	t4tRZUcQIbZviqZMecSkY6OWyJuqTwQ=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10518573D8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:06:22 +0000 (UTC)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFC601A01A3
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:06:21 +0000 (UTC)
X-FDA: 84487689762.14.4239062
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 15BC6100019
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:06:19 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772136380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQFayWtpCiwY1tVJe/mxs2AbgkdyPNyv0sAxXD5cj2g=;
	b=LT+z2NsFKrHCjzWWFAe6mohF8yCyKYindZsSUHdLEqQE3THjhihAwET/2cLl0uQ51cuEUQ
	e5YwowpLDqxFEniU7dNS4ifs6PGsw4fmkaJGZvu1K75qp0L7rbFP0niNbAZBou/r/ZffrW
	+hbEZj0mzIi1UujvVSyNcAqPa74x4kE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GoiapCCj;
	spf=pass (imf14.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772136380; a=rsa-sha256;
	cv=none;
	b=grVYJzWBmnNWlVMN3C0KmR4MR6q69Sav0vPzjTv/lMUFc2AVvOQm22AoztS/9fg6g6yRYq
	0aRp858ELB8TPk4PQNzXiWAK2OqvUnbKEvpc/sN8Linws7zvWnqXI9XM+z42EWfJWvPokH
	7Z4uL1dU3dGT/4fhQNUxaTke4RGFdJg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3733260054;
	Thu, 26 Feb 2026 20:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1109C116C6;
	Thu, 26 Feb 2026 20:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772136377;
	bh=amJIWoT1nC09hCk+fwfbrDXhDDzedSUJ2LEhzzxxTsU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=GoiapCCjXtcW/ncWAnCZfJR5QyfV+JUZXXnUIjhxbyDc7L9/74824XjLGF/9FcdJR
	 SHDVHPsQnmcX9UVRLy8HgT37wgK6s8QXPaw6c3IwlPsGwOa3bfi8lNSWFLe/Bah+sW
	 ZA/4okeZZPZJ7mvZzl3EE6xRSak7Kyr4Yu/stsPLfya2o43enXoLgzD9mTD+FyXLtX
	 +yY8TWh/m28GLJhf7ExEjMw72g8WiX6uYn3ecMNMArIST8tJ8isTBaGjNYY7m790z7
	 pQLCm+TMkPfrsnPhjngtxwcWPP0z2TyIJi4xqcJt/EgJRaTRJCjXT19SFgFPN0H64M
	 eqDgsSpMWSpow==
Message-ID: <d8d47ebf099b21bf20f7284837f8164a19590010.camel@kernel.org>
Subject: Re:  [PATCH 17/61] nilfs2: update for u64 i_ino
From: Jeff Layton <jlayton@kernel.org>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, "david@kernel.org"	
 <david@kernel.org>, "namhyung@kernel.org" <namhyung@kernel.org>, 
 "oleg@redhat.com"	 <oleg@redhat.com>, "anna@kernel.org" <anna@kernel.org>,
 "ms@dev.tdt.de"	 <ms@dev.tdt.de>, "alexander.shishkin@linux.intel.com"	
 <alexander.shishkin@linux.intel.com>, "jack@suse.cz" <jack@suse.cz>, 
 "ebiggers@kernel.org"	 <ebiggers@kernel.org>, Ondrej Mosnacek
 <omosnace@redhat.com>,  "mark.rutland@arm.com"	 <mark.rutland@arm.com>,
 "casey@schaufler-ca.com" <casey@schaufler-ca.com>, 
 "glaubitz@physik.fu-berlin.de"	 <glaubitz@physik.fu-berlin.de>,
 "miklos@szeredi.hu" <miklos@szeredi.hu>,  "sumit.semwal@linaro.org"	
 <sumit.semwal@linaro.org>, "john.johansen@canonical.com"	
 <john.johansen@canonical.com>, "amir73il@gmail.com" <amir73il@gmail.com>, 
 "slava@dubeyko.com"	 <slava@dubeyko.com>, "willy@infradead.org"
 <willy@infradead.org>,  "tytso@mit.edu"	 <tytso@mit.edu>,
 "asmadeus@codewreck.org" <asmadeus@codewreck.org>,  "jth@kernel.org"	
 <jth@kernel.org>, "shaggy@kernel.org" <shaggy@kernel.org>,
 "serge@hallyn.com"	 <serge@hallyn.com>, "jaharkes@cs.cmu.edu"
 <jaharkes@cs.cmu.edu>,  "trondmy@kernel.org"	 <trondmy@kernel.org>,
 "jolsa@kernel.org" <jolsa@kernel.org>,  "ericvh@kernel.org"	
 <ericvh@kernel.org>, "simona@ffwll.ch" <simona@ffwll.ch>,
 "willemb@google.com"	 <willemb@google.com>, "aivazian.tigran@gmail.com"
 <aivazian.tigran@gmail.com>,  "hubcap@omnibond.com"	 <hubcap@omnibond.com>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,  "sfrench@samba.org"	
 <sfrench@samba.org>, "neil@brown.name" <neil@brown.name>,
 "jmorris@namei.org"	 <jmorris@namei.org>, "jlbec@evilplan.org"
 <jlbec@evilplan.org>,  "chuck.lever@oracle.com"	 <chuck.lever@oracle.com>,
 "ronniesahlberg@gmail.com" <ronniesahlberg@gmail.com>,  "lucho@ionkov.net"	
 <lucho@ionkov.net>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, 
 "raven@themaw.net"	 <raven@themaw.net>, Alex Markuze <amarkuze@redhat.com>,
 "mhiramat@kernel.org"	 <mhiramat@kernel.org>, "alexander.deucher@amd.com"
 <alexander.deucher@amd.com>,  "mathieu.desnoyers@efficios.com"	
 <mathieu.desnoyers@efficios.com>, "horms@kernel.org" <horms@kernel.org>, 
 "tom@talpey.com"	 <tom@talpey.com>, "mark@fasheh.com" <mark@fasheh.com>, 
 "mikulas@artax.karlin.mff.cuni.cz"	 <mikulas@artax.karlin.mff.cuni.cz>,
 "djwong@kernel.org" <djwong@kernel.org>,  "edumazet@google.com"	
 <edumazet@google.com>, Olga Kornievskaia <okorniev@redhat.com>, 
 "bharathsm@microsoft.com"	 <bharathsm@microsoft.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,  "osalvador@suse.de"	
 <osalvador@suse.de>, "peterz@infradead.org" <peterz@infradead.org>, 
 "christian.koenig@amd.com"	 <christian.koenig@amd.com>, "pc@manguebit.org"
 <pc@manguebit.org>,  "martin@omnibond.com"	 <martin@omnibond.com>,
 "naohiro.aota@wdc.com" <naohiro.aota@wdc.com>,  "frank.li@vivo.com"	
 <frank.li@vivo.com>, "dsterba@suse.com" <dsterba@suse.com>, 
 "zohar@linux.ibm.com"	 <zohar@linux.ibm.com>, "code@tyhicks.com"
 <code@tyhicks.com>,  "dwmw2@infradead.org"	 <dwmw2@infradead.org>,
 "kuba@kernel.org" <kuba@kernel.org>, "kuniyu@google.com"	
 <kuniyu@google.com>, "nico@fluxnic.net" <nico@fluxnic.net>, "jack@suse.com"
	 <jack@suse.com>, "dlemoal@kernel.org" <dlemoal@kernel.org>, 
 "viro@zeniv.linux.org.uk"	 <viro@zeniv.linux.org.uk>,
 "stephen.smalley.work@gmail.com"	 <stephen.smalley.work@gmail.com>,
 "salah.triki@gmail.com"	 <salah.triki@gmail.com>, David Howells
 <dhowells@redhat.com>,  "paul@paul-moore.com"	 <paul@paul-moore.com>,
 "luisbg@kernel.org" <luisbg@kernel.org>,  "irogers@google.com"	
 <irogers@google.com>, "acme@kernel.org" <acme@kernel.org>, "richard@nod.at"
	 <richard@nod.at>, "rostedt@goodmis.org" <rostedt@goodmis.org>, 
 "idryomov@gmail.com"	 <idryomov@gmail.com>, "joseph.qi@linux.alibaba.com"	
 <joseph.qi@linux.alibaba.com>, "al@alarsen.net" <al@alarsen.net>, 
 "james.clark@linaro.org"	 <james.clark@linaro.org>,
 "dmitry.kasatkin@gmail.com"	 <dmitry.kasatkin@gmail.com>,
 "roberto.sassu@huawei.com"	 <roberto.sassu@huawei.com>,
 "konishi.ryusuke@gmail.com"	 <konishi.ryusuke@gmail.com>,
 "sprasad@microsoft.com" <sprasad@microsoft.com>,  "jaegeuk@kernel.org"	
 <jaegeuk@kernel.org>, "linux_oss@crudebyte.com" <linux_oss@crudebyte.com>, 
 "brauner@kernel.org"	 <brauner@kernel.org>, "Dai.Ngo@oracle.com"
 <Dai.Ngo@oracle.com>,  "eric.snowberg@oracle.com"	
 <eric.snowberg@oracle.com>, "adilger.kernel@dilger.ca"	
 <adilger.kernel@dilger.ca>, "chao@kernel.org" <chao@kernel.org>, 
 "wufan@kernel.org"	 <wufan@kernel.org>, "coda@cs.cmu.edu"
 <coda@cs.cmu.edu>, Ingo Molnar	 <mingo@redhat.com>, "alex.aring@gmail.com"
 <alex.aring@gmail.com>,  "airlied@gmail.com"	 <airlied@gmail.com>,
 "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,  Paolo Abeni
 <pabeni@redhat.com>, "marc.dionne@auristor.com" <marc.dionne@auristor.com>,
  "almaz.alexandrovich@paragon-software.com"	
 <almaz.alexandrovich@paragon-software.com>, "davem@davemloft.net"	
 <davem@davemloft.net>, "hch@infradead.org" <hch@infradead.org>
Cc: "ecryptfs@vger.kernel.org" <ecryptfs@vger.kernel.org>, 
 "linux-unionfs@vger.kernel.org"	 <linux-unionfs@vger.kernel.org>,
 "apparmor@lists.ubuntu.com"	 <apparmor@lists.ubuntu.com>,
 "linux-ext4@vger.kernel.org"	 <linux-ext4@vger.kernel.org>,
 "autofs@vger.kernel.org" <autofs@vger.kernel.org>, 
 "amd-gfx@lists.freedesktop.org"	 <amd-gfx@lists.freedesktop.org>,
 "fsverity@lists.linux.dev"	 <fsverity@lists.linux.dev>,
 "ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>, 
 "ocfs2-devel@lists.linux.dev"	 <ocfs2-devel@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org"	 <linux-fsdevel@vger.kernel.org>,
 "linux-media@vger.kernel.org"	 <linux-media@vger.kernel.org>,
 "linux-kernel@vger.kernel.org"	 <linux-kernel@vger.kernel.org>,
 "netdev@vger.kernel.org"	 <netdev@vger.kernel.org>,
 "linux-integrity@vger.kernel.org"	 <linux-integrity@vger.kernel.org>,
 "samba-technical@lists.samba.org"	 <samba-technical@lists.samba.org>,
 "linux-nilfs@vger.kernel.org"	 <linux-nilfs@vger.kernel.org>,
 "selinux@vger.kernel.org"	 <selinux@vger.kernel.org>,
 "linaro-mm-sig@lists.linaro.org"	 <linaro-mm-sig@lists.linaro.org>,
 "linux-trace-kernel@vger.kernel.org"	 <linux-trace-kernel@vger.kernel.org>,
 "v9fs@lists.linux.dev"	 <v9fs@lists.linux.dev>, "linux-xfs@vger.kernel.org"
 <linux-xfs@vger.kernel.org>,  "linux-x25@vger.kernel.org"	
 <linux-x25@vger.kernel.org>, "linux-f2fs-devel@lists.sourceforge.net"	
 <linux-f2fs-devel@lists.sourceforge.net>, "nvdimm@lists.linux.dev"	
 <nvdimm@lists.linux.dev>, "ceph-devel@vger.kernel.org"	
 <ceph-devel@vger.kernel.org>, "jfs-discussion@lists.sourceforge.net"	
 <jfs-discussion@lists.sourceforge.net>, "linux-mtd@lists.infradead.org"	
 <linux-mtd@lists.infradead.org>, "devel@lists.orangefs.org"	
 <devel@lists.orangefs.org>, "linux-afs@lists.infradead.org"	
 <linux-afs@lists.infradead.org>, "linux-fscrypt@vger.kernel.org"	
 <linux-fscrypt@vger.kernel.org>, "linux-security-module@vger.kernel.org"	
 <linux-security-module@vger.kernel.org>, "linux-cifs@vger.kernel.org"	
 <linux-cifs@vger.kernel.org>, "linux-hams@vger.kernel.org"	
 <linux-hams@vger.kernel.org>, "linux-nfs@vger.kernel.org"	
 <linux-nfs@vger.kernel.org>, "codalist@coda.cs.cmu.edu"	
 <codalist@coda.cs.cmu.edu>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
 "netfs@lists.linux.dev"	 <netfs@lists.linux.dev>,
 "linux-perf-users@vger.kernel.org"	 <linux-perf-users@vger.kernel.org>,
 "dri-devel@lists.freedesktop.org"	 <dri-devel@lists.freedesktop.org>
Date: Thu, 26 Feb 2026 15:06:03 -0500
In-Reply-To: <34b1d1f43043ca1b71a3ca9ea5ebce597a4c02aa.camel@ibm.com>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
		 <20260226-iino-u64-v1-17-ccceff366db9@kernel.org>
	 <34b1d1f43043ca1b71a3ca9ea5ebce597a4c02aa.camel@ibm.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-HE-Meta: U2FsdGVkX1+8q640f+lgG65Bf9wqaCcu4cfX9q3stXhoZbMKYEom93xE7T4guA6WeeVB+iWIDbZ8wL9i0lrmdr5Q9XgYxef+5dbFMRK5evd69j7FL5tgP/ltIktk8kUuBYUCHzQ535a2NlFgYg55NPBv6rbb4oQ1ADgBwSa4Ggj35IWV56mRlj4PnsfG4dRf+1gdyt+7nev5F6uKcbdHzFNhrYRitFDDZlJT4HLi70r86zxqrMhPDgMOXOYkhS+HsfSnpXkQemvZLHr3UhQzBH22ySSATM3Mx+XlaYrnopwPgT9zevu6+q4dpEbjfI307XZz1+u0HiJXdt64O+YSbyIFXpwFQuI4i8aVCUWTkSxfyIQBr5Wx2YlCoVn4yJaziCnNPOE0N+rh0HvddNKCxpyYSFsnDPZhXn0IqCPgGMPnCtf0xmio83q50b7W1K+sLAuOEDchir+L/QZVd7JET6P9d7e1D4jauec6Lze1SHWxHRd3zv6sLht/9hU0gclX7iU5SLsntut2qP5veWAExjWBncEHOfqykXh5HMV1Jp2lMq0pA0ao2dlCO/481MsBQ2KlbythCJaz5H5EfPUpYnYy0YVWuYu7I66/EgXatWEpg7cy0kIGFmMkwXpz/sE3s9UqCcUCAoIZK9lEdVhMmNbvlZ99ywWic/c5g3qw46+O31Qq4E/e8uJJza3Wk51UoOx7aW6wQXr+gjcSd4ofYKfguvYUoOfm9+x+6TJWrZoNDrTe+NySgxP5IswfIwKHTKLNuEqy2tENAXfEaSSowdaHHaRHGeiDwozwUrzx+hDQuXo6n3+QzxJOxayBzpSGmA3xz9n9e0pyN61k7PG+b+T87Y4iPOwGPBYi9zMFrc4McKj5Lqk/PWHxnCsI70CuE5U+H3D/B1j7ChqEqGYia65FxCSrta7aMSaZCss49dMHi2Ur9cbCQrpVn0ETJas+buYTbmBciXBkVSTJaGt
 YEvm+dQp
 PK1mE/qp+MjWU3SRHBpbM7684jmg8SAY2ARWS4GkNkhDK5TmZYn8urciPkde17zxtNlWF+DbamSScNxMeVGPOpaBYOrzjfqIbYhL7UB4IgJd0QuswRZ7i0CHd6mJ+0OUhSx8+IFlqQwrutBhE2BiBZD7NFAJhtmAFyCOEdkOjtFkTa+aLQSo18cAQnqEkzPOcUtSH8ozZSfE6WNTgAlSU1XDjSklnBJF43iyAbx64bahbQaqcvsoSTko9Q+9LuAazbPoK58sW+fAUko0H61r0lCjknhXCSep2usEsqbS3B66A/aClBbsuR8mlZHmdueQNB99VuiBVPPODPsIcnqvsXv8omr1m+GmIMHg20tKJ/G6XlZ1l3jiXbj4YZ6g6AyU4b/ld/eQ5y7ADNh0Hz4dMh249j3j6WPHl3DRu3JUkeutVay/l94r6nAuA8et4PuyPA/9ASNZjXiJucwrnYrfTmlIj9N7Pw/YqKKp+9grU+meWmVOaYvD0g+306qgJRKgv0Tgdf7NESLdLekXLCZQm8OUNsmag+BIVTaHnDNIOt3W3UiMV8S43vTrqfoSzKmgsGw3fwjQDD3UYjXzf0fOlw5it6Gwqpu+t5EDq4ee9YhcBSY/MguMUPARuU7STgCf+lOPwiEDcevZX2ZyE8OjqFUySCt3jaeSIOiWeukakwtHD6qsFhL7+Ou7IGd/uVj112SzD2GhXbkgOBl2UqmrsQ57WYRmDg5vgMI6YGCT58sy/l461qng3El8P/AkDxmXzDqzxvh95WfGlNIo9JCjD6AYDiGwMcM7SAEZN1GLUI5IdCg8RpZwnmfT8OUfNs/9Sq2WmfahWV4527iUYH19LI1HwRBmCOnOV4W2App4Gm22Q11qgr/KkpH1kq4Dlwg/y9lvOgouU+KdpO/ooCRAr/CnNSAaHcz6UE2brW+cWxofTOoUwQ92qy+WkMNQwP6YFLBmNWXbs/CzIUfv21P/futUO6KPL
 cdo2LDfX
 v6zjg0aj6+uu1Im6s6DXftlIKi5AfUxPGTN9EdmMTiwEqAFLK6A2Dn5PrVeQRb8IxNWMA+rGz0V670Rq6GwbD6S7wC0GCDZdhIE5LmD4TKafoi7gTzDnaI2SVKIyoQ6QcphUkkNKNXJjnKKfAbhRUEzoRyTPK4+eyMZXldcmja2PXwC6sQ8ehP/62ypl3jhxS2022/TLvtw3hAvbwSvBy3aEehdUBuZHKeqIFl1Zao/rdJdTi5sTgAsuc4TW5W9zFxnyNyGxZn4m2xiiAISSd39XALEGI4QdA2n/S0QH1mZumCKo7oQrryv9hyfj0OeeH0/CrXaktUc38EUlfE9BQMU1/rJTAX5J6PUykaz584HNwW5V0s4mQerNnTa8Vd+9Wv8kcfwAf9DgXY9sbn+Ns9PgIxwBudMlO/Q+4UFJazAMfGqMVIyIJkrQtsZiGCanSzJE4asu+hVSR7Vac/k5cNTcyCNCABwk8idHZ3vJ+U6YqYMjzmVp3f8U97suk7oInxbQl2KB184ujKlh6fEwFbdz6qDRFKCkq/yxp+f+50nX9rCFQWtAXXEzI3qCxwWeWTZrjGoczJxu9OxNZKqfmjjUzzXsnM474WFVNbvkNTVzmmdG7PwqCJaDOzshn+D8lMaEQvdGmh2F/mzKKJqnWPCVr6lp27AfWD/EQgyY1ZbOtEOHUDH6IZkDHVNIwX4HBEiNBMevVRmjksPuzscYapUgoOnESZoeILFxdVJ2CuGBkiJCEjx9hXeW8CKrsOKlYQJvJN+YX/kH3JtO5Nn9lggPq6O2Km1L5SprrXxmxkIuSFOVZtNiwlMpK27TjGWJbpkdSy9xUOaRt1Jm4nrQc5AS3ia7ntUNFNbzX/C7pLUk6+MSmvH1PAAyHwTMNvT3xNbAuJKbB6ywRb7PjiLXEdf5Gwt7imyiRNfQV2j3eA2GJQM6iW2v+T4GbR/lDZCZBHO0LEI13Il2wfeLyu5L6r0hPVJFH
 OFgNSCyk
 9ez2VpyRs94T5iggdpPl9aCugYvP9pebUPstBsRswQqI9ec1AcW3stBXpz2LG/akFXeXXF0+ZOf1XKWhX7c+/l7j3zPe2CkFq+tjVZwuwviPhac+bcKeGYhkS7JswTeyD2CzCbhfEm4vtaNN+sW2qkx0jOgtP+TKtI+eMmO97pNkSES1DFxck4kBEcQ0AqUiuYokP7qxIrU0aoI1rJOpvdEdR9L69hy8LZLGbU8To7jZsJD11p6V4dFpw3E/83VKZHVPI0A+7Xthn+eG1TEHSmuS7YzdHHua/xZC1FdYvaZYzR4LMm9c71+isykSzj6hFLO33p4XJkM9r7gu961skSYkgZiRKvNabN0wRX/4coFeVC1QEXlDpAFfbjNXv83PD/txgPlf02gaI07eRedAqqJO45X2lLykkX1kaBkxM5eqx4qmaTMmC+ig0vLdvMM8LmOneZCL6tHshFZHQ2+qLfpifOxrD+6Lm1onINtza7O8QvdiQq33A7TwD23qJWjvjPEwYg1stUPkK+l2gigEPYWdmTwRLlX6NF9KfmI+wukpwjWRKjGYchQIxhqJqgR0enLf5gOWaosvY6S/HE+KPCBRbtCPhQWSEPS77rB1TxsJ592fwofx9vYhuL2GyLBdgTH+jrgw5tUS4ALisxk+0pX900Izexm0EdBoWHTa9WLEucBR+rtzR1sYzqHHh3oRafXK1T8GTiuWFTvaZiEn9GE7fesfjm4yE38/90n/O/wKQ+tkAjfOTmfDYlV8UibgV9o7J30UOsGXPx5iggVkGXGiCQpigy11H3NbQUnzhCJh6BG4VPJ7O1mYQHQiL+TF8BGjfhVDBi+a/hTSuP3xw3CavHZHgruqDYMolQpuh7XJzktG+uSuj03ISCfFxs71cweJ+Asvh+kJ9tgMAVj4Y7T400NsFR8/vuBAJ9TymmW2VFOgyYTxU3peYQCas6nX+VtUjxkx665D+grH13IBUl08wcuzJ
 F1xRRvdG
 trKl90zyWYZN5xv7xulHVEHmlpe7/xkmJKBQKVFuvIqtwBBNnxdbcJEcvxpNTEsr96IJb6EScj83n3pruowzvlC5ppb2H/EL9roaoM+qSm6pJ8G27DUqDszh2VjF8HaMzkAYbb1vMvFCGVsuoP37u8zpMCd9sou4JFTnU21YRvOgooKHk1d+IK+qciPoZ5p8VjINjBlyxqGBYk0joVq4hFMbGBf21dph7h5QYZUgdn+uG8ujDkeTMg6u0LyYWbKwEqKp0bWYi8zWs8R42jIPsuDgdX6cy4zlNC3lDoyJqB/kTA3J70fKxO702kp3O13KUjMVyKhxEfI8KToM2Mwa9Dbsss8mlmzunJ7tDL4cCrYCr1zU25Dy0tXBI+DAKqxcn/nU+ORyr+q/+/HYW3yrFjOtwFCOSrQj8=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AC7D8C001A
X-Stat-Signature: fx5arbx7bo8popsi7irzpqp14hi8597d
X-HE-Tag-Orig: 1772136379-467163
X-HE-Tag: 1772136382-517090
X-HE-Meta: U2FsdGVkX1+BdHfOD0ffvkYIZgW5PTXnOGAxrJqA6WjTkZgoFYUxq3mALe4acaqHbxzkLTd19hqoMqJ8sLUrRY3ncNrcG97cC7VpvyPIT+T3TDnGkXsqLXV0LOMzUfm4FHTl7e+ztQPw+GtUUMkLP+dvJQyQzb3eLEgNu99huArffiJ242Ks4kTaFuFE+64AMzIXogEK01vHdEpUCsWnXwvbqRH1oIutFp5e7XHZ2HIE59G/1sh0VCMTpBUp+Hrmbp4hLec7lnZsT5NaSdTwy2D0/Z9/H5zVEVpnLQqjZEVx0xLcJzEqqTQzXtkI9oI5m0Oj5mTUEIUblfIVOPXdwEV6TFtcwQ5jNtVPuDWhWKecPd0NzDPlxHCOFAM26hbgJF9e1854uUPQQSL/4ZtIeLQMNiR+kfPhysnoqS3vebijihtmLx0Qum4B4E5K3viuXQNl0nnTaNCuqF95oRj/bhRuNTqA4YHcWxffUv6JddJ082MJ8zcJTLSXZ251Shq5lotyEXK/sqIkH9iu12U2tC3ESL3N9W/gQvMNihV5CIFwU3b5OrGFj1Ng3wF2KjGARjJD5emwknyn3QqlsAhtepyvOgKyA4l403QBrFtawEQ0dk8co/wUkW4PIphIjIcVLU2m7Y6THwDyOw7tLfZfZGAysPe5QDBn7IgyXRCxJL/OZqwkRaMsCw/+6g8EJU37tHuRCwMLj1ZH/0NBxnuggGp5iWWtAHXG5ljh8VzHheSiyQI/XOPwcy9M8nXinGz1cc27SauTn0t0pGTUZZVSUCTztnvYEamqxOTAZKbCywPtI+HbpsbzT8P6w9uqLAaOweHtmJ2X0h6ELidQ6/Og8P8CKRp1ogwy1WeRln7cW3MobzycJhFhZ0hVj8Asn5hk3Aio8YAP2/CpBA0+WwkmFwDfjJntgBg535fbWu8Eob89+GWAmFSiKp5VSmHEUO9M+aDr0QawColbjdLiA1M
 +o44r/0T
 gXEkJpOZlOJeNv4GgrezeJ+c54dy0t4kwC357aLj6Xypoey12IBBmNNz5FnvDDQWKWCs0ttkV8DxHZQV5WvJK1owz4hzzi4YOGRcVCsAHNpMLugDNedoCXlydehkH02J0GjOd+sZYzRZz9KIqQ0bVQkv9iHxfp0gPiEdzarh95HIKFIZclHw7KAKBJXz0uxte42WU7fOi2EnYbvi/9zspktGs5Hl9u4knu5+gorIzFGukRG4ppLrwfLv4y9RmfrBZfrphYMTBtbpHrF7wG+/dHfyhuoTkQkk/xwNw+lqCxLRoYmGGtqyjHFA+vYDIQylKTUAdHLLDskpmuZnWE1MvcM0sQ7+P4lOudwA+ZYW3X50xmGO2+P0RPFkDnIRcyg2gykffzxUnNJeZbsDb4SixEgUBvvbWRO4aEqkFqLECYOR1tKavfFUjx7msgbwpyx1zMfsmdKts4ob0OKe7h7Rpuu4/IDAUwpdcX7Xzqg3PZp24V3Erz7nIkfbaIJjLlyVLovqZ4Lx2SREaG8rFO8/OjXRmcQ7MPkAXwZ++oetU/ZdnC/psP3a+m/gVt71d2ctN+HkGj5Wpb6LYrgAKEpkjP+BYMlsNeQ8j5fJaE5lDZvpIgw8Vq1WishtV437alnPG5SMnXKd9DbNgA4pFqXugfa6BcoMOQO6qZzhloLhTqDNmcVqrmlYwttChwoT1wFepoC1VsPDtCV4wSVDnRZCXEPZJqRXX3pJ2VKqbTK/IZdpTDVDsReB4NpyCoitGwj4YgPO/OoE3uw30Nzj3yIq8kr5w+Jka7deo4XnUG2CEya6BxvWUu5gxkHQkUg5KaIxVsVG+jJ2WJD66cmv7sPswIMZAGAFDbFAwYwjFpu7Hu4V4Qj7oLgefMtEJ+ztKaKfM1XHYhZixcCZ8NgyPZde4wPqQtddwqP6NxoWwJNPHXqRVhW1tKkZ/21CsCEXz7zd9JmSkUqUSQw47/D65VALuKoxlP9Wg
 HgtA1o2J
 qxb3TU4e2P/4KpMQX8JRTWHtTfBc7pthl31CZ/FKqaCxdOFShiUH6/zCdcAll2Na1pc00qbltGmNkamrT88Rn2cJpmxeEpZsWVzypuGXvCr4IKQaW6HiXtteqOXOzzK3f26ZaQPSPbfG4Y0KEBvFFhfLK/aMDfeUMh28bCARcSHgoMF0NWfimFBxA10V2Idb4xCrh7VES5ahgj/I8c8E0RPQdiBkRz2AOnWHDk0xRjydUku2jj+r/eVA3jt8LqXZ1QLtLCtrxxo9CtP5lRG8gq0YcuHBvs80agF0jigDY1rWSgwShLm9Ja2kUTFKoxSqeTsZ2mNPyJwVRypQy+QNG3VOnNSc+VxIc6Td4q2bXaXQYFAZH57nZC40JiWEbwWjb7AVTw/TDMqVJ/fMxbtaryNXPVjIUx4t9yc2vpCHNu9ZFCLGziaY/gsT/aDbzp1bTzqKWMdliY9KVxm8PVSoClsksy5XeM1Ok5Uc4dNOqsUbzwKjrUOuizuqbr0GzO96Us5AgAUgd2Kki8ZPqCrpiZIE05TFFpsrl1mmYWed8x1+WKY0sKweIuRaBSdvG3va9AJrGXarAzP0HkiZde0gePMrnzH3k1/a0T97Q1UCYA0DR58uXr6JTND+QdFkSr+7oP885JpUssx95L26HdfSakbJjabqtEPDSATc2M3yYYuH8rXCTrdsxsnumIfV7MjRvyvgxSUEIdTMST7SZ83Im/kTUNsVVYv5ZDYNi7N/ylU0fGNbYzaL6wbmAVzPLkR9XNo/HNOE0DiMwgdRiJk2AJwzkp0C+QdihdbYH5RTCrWoY7e8H4sqZlKN+ANJash5qT6UscbRjWq4umR4iQDxWaNv3AZVGtOV03K7YEPB0K9cK1q9X7FcU0gdYEWXE+LPXqHYL1Mu/vu4JEiScAxHC7C7o9oqh4JZvbDuBr2JggG0LNi169Bv0qJv5ppU11JmbrENCH3eI/SJzIRinIuJOb36QxvKB
 X90bwY7U
 dNzhNaAPcZsMLP/14b/X9+KHcT90UaTlGqYppd6SX1EmUyAHkpN6n1N4S+Qo2geeSzjqi2vvrFZSIj0qDVlLZNksSKr3NgYlSnd6VPPv6aGn9FZREiFH/ehjEXUQZF0JkaaDKYQC1f4dcz8mkWWRMCvTy5xGGzJijOY+QakAPRhMMBvPXFqrA4QeSWPN7QVtul941IHZcRUhHQW5d6gi51ELWujHF5SQ4/jENdKGvdQZaVDlAe6pcs/lHYfR3+NWoan+Wnef/lEiiaS6XXOnU9Rg1tT/u2FSFfSO59BbsfK0qWdh0xsFeIobkS9kP6SG1vG1V80lNFcBE74OVjxDmYFr0ajJEkiT+322xZioqYTvRWXvcsNV4SHpJ5cS8jk3BdY5R1lX1EL3u5TnWlRZPt5ll17BYfsGvryyKvMEaVf0LteHzzyvqW0eMLykJBc9Euf4LfsST2gUcWl/L7+1Ly4Rfcu5aMg/I9hrFEaBVUIak/XSj6pRUWzHfjqgBifQnW8gyH08QCXyZjMfbq2gMjqttrO+SOf+F7L1wOoIuSV8EKBxXGQ7TEwt1dFMStkRFiMuDhfnz4i/vcPFDFk9hfzFhmKfBdfKhMRazfNXoWy9sYvjPdM4pPscDQg3E0bdTuivgvXWTSY0uJvJn/v+CCbG25sUkt6JIC3qfNrHCbGu9bsH1FeO1JToYM1GLpoCwiO1W2AI5n5kWthCYWpAulo1E0jI/skuNNOdPskqTxpnOYNWGehkArXzOUJa6oTRfTXtFWP0ch4ew4WrLJlHdqAcAlq6GtCfDV8UTmt1w9otff0bSSC7oREncpiACLLPieRjIeg91LIp1OZUwYVmOzP0HWcPEG8o9qTcI1qzRAXHaBc0979rrTTrAYRD/TK9iDw3Nutfizy9Srj3SYt86HxvdJvmqP+U18kkOgZzRuemfgGjMTxBHXap+u4JshHp0czxFUHixee/bQKmb/jDuPB4ZbKgz
 gk6AhFJR
 215x+0w/S4nq9oBFLL24NsyD4KzGAHll3cQJoi3l/5sbNKg0i4l3enmg587nIbqBRrWg1AIY4qb49uaPZt9OR7/7GeK+Q8sgeqPg0As9dRh21foS8RA0NFIIvlZsaZTnsuLTbVLqkrU0YtDtGu5iLDKDi/+Pfr4JUgVteQRNfS3FrZ82we129yOF8Tv9RgnzzwHNdeRGAPzN1pJk58BkQNtOvpe/RN02FHZaFoJxcBb5ls/yhOMrpGZqtOxTLsNuJoYuSMJuw//c1tGih4bs0jY3G9MY5G5XV/Y7PS3clzFMvDdDzP78zLaLjUY/iSUBM+6B+XiOXH4PJC2H2XZ8/omKQ2YxYrQ04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-02-26 at 19:46 +0000, Viacheslav Dubeyko wrote:
> On Thu, 2026-02-26 at 10:55 -0500, Jeff Layton wrote:
> > Update nilfs2 trace events and filesystem code for u64 i_ino:
> >=20
> > - Change __field(ino_t, ...) to __field(u64, ...) in trace events
> > - Update format strings from %lu to %llu
> > - Cast to (unsigned long long) in TP_printk
> >=20
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/nilfs2/alloc.c             | 10 +++++-----
> >  fs/nilfs2/bmap.c              |  2 +-
> >  fs/nilfs2/btnode.c            |  2 +-
> >  fs/nilfs2/btree.c             | 12 ++++++------
> >  fs/nilfs2/dir.c               | 12 ++++++------
> >  fs/nilfs2/direct.c            |  4 ++--
> >  fs/nilfs2/gcinode.c           |  2 +-
> >  fs/nilfs2/inode.c             |  8 ++++----
> >  fs/nilfs2/mdt.c               |  2 +-
> >  fs/nilfs2/namei.c             |  2 +-
> >  fs/nilfs2/segment.c           |  2 +-
> >  include/trace/events/nilfs2.h | 12 ++++++------
> >  12 files changed, 35 insertions(+), 35 deletions(-)
> >=20
> > diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
> > index e7eebb04f9a4080a39f17d4123e58ed7df6b2f4b..7b1cd2baefcf21e54f92608=
45b02c7c95c148c64 100644
> > --- a/fs/nilfs2/alloc.c
> > +++ b/fs/nilfs2/alloc.c
> > @@ -707,7 +707,7 @@ void nilfs_palloc_commit_free_entry(struct inode *i=
node,
> > =20
> >  	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
> >  		nilfs_warn(inode->i_sb,
> > -			   "%s (ino=3D%lu): entry number %llu already freed",
> > +			   "%s (ino=3D%llu): entry number %llu already freed",
> >  			   __func__, inode->i_ino,
> >  			   (unsigned long long)req->pr_entry_nr);
> >  	else
> > @@ -748,7 +748,7 @@ void nilfs_palloc_abort_alloc_entry(struct inode *i=
node,
> > =20
> >  	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
> >  		nilfs_warn(inode->i_sb,
> > -			   "%s (ino=3D%lu): entry number %llu already freed",
> > +			   "%s (ino=3D%llu): entry number %llu already freed",
> >  			   __func__, inode->i_ino,
> >  			   (unsigned long long)req->pr_entry_nr);
> >  	else
> > @@ -861,7 +861,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *=
entry_nrs, size_t nitems)
> >  			if (!nilfs_clear_bit_atomic(lock, group_offset,
> >  						    bitmap)) {
> >  				nilfs_warn(inode->i_sb,
> > -					   "%s (ino=3D%lu): entry number %llu already freed",
> > +					   "%s (ino=3D%llu): entry number %llu already freed",
> >  					   __func__, inode->i_ino,
> >  					   (unsigned long long)entry_nrs[j]);
> >  			} else {
> > @@ -906,7 +906,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *=
entry_nrs, size_t nitems)
> >  							      last_nrs[k]);
> >  			if (ret && ret !=3D -ENOENT)
> >  				nilfs_warn(inode->i_sb,
> > -					   "error %d deleting block that object (entry=3D%llu, ino=3D%lu)=
 belongs to",
> > +					   "error %d deleting block that object (entry=3D%llu, ino=3D%llu=
) belongs to",
> >  					   ret, (unsigned long long)last_nrs[k],
> >  					   inode->i_ino);
> >  		}
> > @@ -923,7 +923,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *=
entry_nrs, size_t nitems)
> >  			ret =3D nilfs_palloc_delete_bitmap_block(inode, group);
> >  			if (ret && ret !=3D -ENOENT)
> >  				nilfs_warn(inode->i_sb,
> > -					   "error %d deleting bitmap block of group=3D%lu, ino=3D%lu",
> > +					   "error %d deleting bitmap block of group=3D%lu, ino=3D%llu",
> >  					   ret, group, inode->i_ino);
> >  		}
> >  	}
> > diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
> > index ccc1a7aa52d2064d56b826058554264c498d592f..824f2bd91c167965ec3a660=
202b6e6c5f1fe007e 100644
> > --- a/fs/nilfs2/bmap.c
> > +++ b/fs/nilfs2/bmap.c
> > @@ -33,7 +33,7 @@ static int nilfs_bmap_convert_error(struct nilfs_bmap=
 *bmap,
> > =20
> >  	if (err =3D=3D -EINVAL) {
> >  		__nilfs_error(inode->i_sb, fname,
> > -			      "broken bmap (inode number=3D%lu)", inode->i_ino);
> > +			      "broken bmap (inode number=3D%llu)", inode->i_ino);
> >  		err =3D -EIO;
> >  	}
> >  	return err;
> > diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
> > index 56836712909201775907483887e8a0022851bbec..2e553d698d0f3980de98fce=
d415dfd819ddbca0a 100644
> > --- a/fs/nilfs2/btnode.c
> > +++ b/fs/nilfs2/btnode.c
> > @@ -64,7 +64,7 @@ nilfs_btnode_create_block(struct address_space *btnc,=
 __u64 blocknr)
> >  		 * clearing of an abandoned b-tree node is missing somewhere).
> >  		 */
> >  		nilfs_error(inode->i_sb,
> > -			    "state inconsistency probably due to duplicate use of b-tree no=
de block address %llu (ino=3D%lu)",
> > +			    "state inconsistency probably due to duplicate use of b-tree no=
de block address %llu (ino=3D%llu)",
> >  			    (unsigned long long)blocknr, inode->i_ino);
> >  		goto failed;
> >  	}
> > diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> > index dd0c8e560ef6a2c96515025321914e0d73f41144..3c03f5a741d144d22d1ffb5=
acf43a035e88c00dc 100644
> > --- a/fs/nilfs2/btree.c
> > +++ b/fs/nilfs2/btree.c
> > @@ -353,7 +353,7 @@ static int nilfs_btree_node_broken(const struct nil=
fs_btree_node *node,
> >  		     nchildren <=3D 0 ||
> >  		     nchildren > NILFS_BTREE_NODE_NCHILDREN_MAX(size))) {
> >  		nilfs_crit(inode->i_sb,
> > -			   "bad btree node (ino=3D%lu, blocknr=3D%llu): level =3D %d, flags=
 =3D 0x%x, nchildren =3D %d",
> > +			   "bad btree node (ino=3D%llu, blocknr=3D%llu): level =3D %d, flag=
s =3D 0x%x, nchildren =3D %d",
> >  			   inode->i_ino, (unsigned long long)blocknr, level,
> >  			   flags, nchildren);
> >  		ret =3D 1;
> > @@ -384,7 +384,7 @@ static int nilfs_btree_root_broken(const struct nil=
fs_btree_node *node,
> >  		     nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX ||
> >  		     (nchildren =3D=3D 0 && level > NILFS_BTREE_LEVEL_NODE_MIN))) {
> >  		nilfs_crit(inode->i_sb,
> > -			   "bad btree root (ino=3D%lu): level =3D %d, flags =3D 0x%x, nchil=
dren =3D %d",
> > +			   "bad btree root (ino=3D%llu): level =3D %d, flags =3D 0x%x, nchi=
ldren =3D %d",
> >  			   inode->i_ino, level, flags, nchildren);
> >  		ret =3D 1;
> >  	}
> > @@ -453,7 +453,7 @@ static int nilfs_btree_bad_node(const struct nilfs_=
bmap *btree,
> >  	if (unlikely(nilfs_btree_node_get_level(node) !=3D level)) {
> >  		dump_stack();
> >  		nilfs_crit(btree->b_inode->i_sb,
> > -			   "btree level mismatch (ino=3D%lu): %d !=3D %d",
> > +			   "btree level mismatch (ino=3D%llu): %d !=3D %d",
> >  			   btree->b_inode->i_ino,
> >  			   nilfs_btree_node_get_level(node), level);
> >  		return 1;
> > @@ -521,7 +521,7 @@ static int __nilfs_btree_get_block(const struct nil=
fs_bmap *btree, __u64 ptr,
> >   out_no_wait:
> >  	if (!buffer_uptodate(bh)) {
> >  		nilfs_err(btree->b_inode->i_sb,
> > -			  "I/O error reading b-tree node block (ino=3D%lu, blocknr=3D%llu)"=
,
> > +			  "I/O error reading b-tree node block (ino=3D%llu, blocknr=3D%llu)=
",
> >  			  btree->b_inode->i_ino, (unsigned long long)ptr);
> >  		brelse(bh);
> >  		return -EIO;
> > @@ -2104,7 +2104,7 @@ static int nilfs_btree_propagate(struct nilfs_bma=
p *btree,
> >  	if (ret < 0) {
> >  		if (unlikely(ret =3D=3D -ENOENT)) {
> >  			nilfs_crit(btree->b_inode->i_sb,
> > -				   "writing node/leaf block does not appear in b-tree (ino=3D%lu) =
at key=3D%llu, level=3D%d",
> > +				   "writing node/leaf block does not appear in b-tree (ino=3D%llu)=
 at key=3D%llu, level=3D%d",
> >  				   btree->b_inode->i_ino,
> >  				   (unsigned long long)key, level);
> >  			ret =3D -EINVAL;
> > @@ -2146,7 +2146,7 @@ static void nilfs_btree_add_dirty_buffer(struct n=
ilfs_bmap *btree,
> >  	    level >=3D NILFS_BTREE_LEVEL_MAX) {
> >  		dump_stack();
> >  		nilfs_warn(btree->b_inode->i_sb,
> > -			   "invalid btree level: %d (key=3D%llu, ino=3D%lu, blocknr=3D%llu)=
",
> > +			   "invalid btree level: %d (key=3D%llu, ino=3D%llu, blocknr=3D%llu=
)",
> >  			   level, (unsigned long long)key,
> >  			   btree->b_inode->i_ino,
> >  			   (unsigned long long)bh->b_blocknr);
> > diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> > index b243199036dfa1ab2299efaaa5bdf5da2d159ff2..3653db5cdb65137d1e660bb=
509c14ec4cbc8840b 100644
> > --- a/fs/nilfs2/dir.c
> > +++ b/fs/nilfs2/dir.c
> > @@ -150,7 +150,7 @@ static bool nilfs_check_folio(struct folio *folio, =
char *kaddr)
> > =20
> >  Ebadsize:
> >  	nilfs_error(sb,
> > -		    "size of directory #%lu is not a multiple of chunk size",
> > +		    "size of directory #%llu is not a multiple of chunk size",
> >  		    dir->i_ino);
> >  	goto fail;
> >  Eshort:
> > @@ -169,7 +169,7 @@ static bool nilfs_check_folio(struct folio *folio, =
char *kaddr)
> >  	error =3D "disallowed inode number";
> >  bad_entry:
> >  	nilfs_error(sb,
> > -		    "bad entry in directory #%lu: %s - offset=3D%lu, inode=3D%lu, re=
c_len=3D%zd, name_len=3D%d",
> > +		    "bad entry in directory #%llu: %s - offset=3D%lu, inode=3D%lu, r=
ec_len=3D%zd, name_len=3D%d",
>=20
> I think you missed 'inode=3D%lu' here.=20

That is actually the placeholder for this:

    (unsigned long)le64_to_cpu(p->inode)

...which is not inode->i_ino. I do agree that the cast probably no
longer makes sense with this change, but I'd probably leave that to a
later cleanup so we can keep this set focused on the i_ino change.


> >  		    dir->i_ino, error, (folio->index << PAGE_SHIFT) + offs,
> >  		    (unsigned long)le64_to_cpu(p->inode),
> >  		    rec_len, p->name_len);
> > @@ -177,7 +177,7 @@ static bool nilfs_check_folio(struct folio *folio, =
char *kaddr)
> >  Eend:
> >  	p =3D (struct nilfs_dir_entry *)(kaddr + offs);
> >  	nilfs_error(sb,
> > -		    "entry in directory #%lu spans the page boundary offset=3D%lu, i=
node=3D%lu",
> > +		    "entry in directory #%llu spans the page boundary offset=3D%lu, =
inode=3D%lu",
>=20
> Ditto. You missed 'inode=3D%lu' here.
>=20
>

Same here.

> >  		    dir->i_ino, (folio->index << PAGE_SHIFT) + offs,
> >  		    (unsigned long)le64_to_cpu(p->inode));
> >  fail:
> > @@ -251,7 +251,7 @@ static int nilfs_readdir(struct file *file, struct =
dir_context *ctx)
> > =20
> >  		kaddr =3D nilfs_get_folio(inode, n, &folio);
> >  		if (IS_ERR(kaddr)) {
> > -			nilfs_error(sb, "bad page in #%lu", inode->i_ino);
> > +			nilfs_error(sb, "bad page in #%llu", inode->i_ino);
> >  			ctx->pos +=3D PAGE_SIZE - offset;
> >  			return -EIO;
> >  		}
> > @@ -336,7 +336,7 @@ struct nilfs_dir_entry *nilfs_find_entry(struct ino=
de *dir,
> >  		/* next folio is past the blocks we've got */
> >  		if (unlikely(n > (dir->i_blocks >> (PAGE_SHIFT - 9)))) {
> >  			nilfs_error(dir->i_sb,
> > -			       "dir %lu size %lld exceeds block count %llu",
> > +			       "dir %llu size %lld exceeds block count %llu",
> >  			       dir->i_ino, dir->i_size,
> >  			       (unsigned long long)dir->i_blocks);
> >  			goto out;
> > @@ -382,7 +382,7 @@ struct nilfs_dir_entry *nilfs_dotdot(struct inode *=
dir, struct folio **foliop)
> >  	return next_de;
> > =20
> >  fail:
> > -	nilfs_error(dir->i_sb, "directory #%lu %s", dir->i_ino, msg);
> > +	nilfs_error(dir->i_sb, "directory #%llu %s", dir->i_ino, msg);
> >  	folio_release_kmap(folio, de);
> >  	return NULL;
> >  }
> > diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
> > index 2d8dc6b35b5477947ca12a70288d3a3cce858aab..8bd0b1374e25f8ff510f3b3=
6dbde2acc01aafc1e 100644
> > --- a/fs/nilfs2/direct.c
> > +++ b/fs/nilfs2/direct.c
> > @@ -338,7 +338,7 @@ static int nilfs_direct_assign(struct nilfs_bmap *b=
map,
> >  	key =3D nilfs_bmap_data_get_key(bmap, *bh);
> >  	if (unlikely(key > NILFS_DIRECT_KEY_MAX)) {
> >  		nilfs_crit(bmap->b_inode->i_sb,
> > -			   "%s (ino=3D%lu): invalid key: %llu",
> > +			   "%s (ino=3D%llu): invalid key: %llu",
> >  			   __func__,
> >  			   bmap->b_inode->i_ino, (unsigned long long)key);
> >  		return -EINVAL;
> > @@ -346,7 +346,7 @@ static int nilfs_direct_assign(struct nilfs_bmap *b=
map,
> >  	ptr =3D nilfs_direct_get_ptr(bmap, key);
> >  	if (unlikely(ptr =3D=3D NILFS_BMAP_INVALID_PTR)) {
> >  		nilfs_crit(bmap->b_inode->i_sb,
> > -			   "%s (ino=3D%lu): invalid pointer: %llu",
> > +			   "%s (ino=3D%llu): invalid pointer: %llu",
> >  			   __func__,
> >  			   bmap->b_inode->i_ino, (unsigned long long)ptr);
> >  		return -EINVAL;
> > diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
> > index 561c220799c7aee879ad866865e377799c8ee6bb..62d4c1b787e95c961a360a4=
214d621d564ad8b4c 100644
> > --- a/fs/nilfs2/gcinode.c
> > +++ b/fs/nilfs2/gcinode.c
> > @@ -137,7 +137,7 @@ int nilfs_gccache_wait_and_mark_dirty(struct buffer=
_head *bh)
> >  		struct inode *inode =3D bh->b_folio->mapping->host;
> > =20
> >  		nilfs_err(inode->i_sb,
> > -			  "I/O error reading %s block for GC (ino=3D%lu, vblocknr=3D%llu)",
> > +			  "I/O error reading %s block for GC (ino=3D%llu, vblocknr=3D%llu)"=
,
> >  			  buffer_nilfs_node(bh) ? "node" : "data",
> >  			  inode->i_ino, (unsigned long long)bh->b_blocknr);
> >  		return -EIO;
> > diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> > index 51bde45d586509dda3ef0cb7c46facb7fb2c61dd..51f7e125a311b868860e3e1=
11700d49d4cb98fa6 100644
> > --- a/fs/nilfs2/inode.c
> > +++ b/fs/nilfs2/inode.c
> > @@ -108,7 +108,7 @@ int nilfs_get_block(struct inode *inode, sector_t b=
lkoff,
> >  				 * be locked in this case.
> >  				 */
> >  				nilfs_warn(inode->i_sb,
> > -					   "%s (ino=3D%lu): a race condition while inserting a data block=
 at offset=3D%llu",
> > +					   "%s (ino=3D%llu): a race condition while inserting a data bloc=
k at offset=3D%llu",
> >  					   __func__, inode->i_ino,
> >  					   (unsigned long long)blkoff);
> >  				err =3D -EAGAIN;
> > @@ -789,7 +789,7 @@ static void nilfs_truncate_bmap(struct nilfs_inode_=
info *ii,
> >  		goto repeat;
> > =20
> >  failed:
> > -	nilfs_warn(ii->vfs_inode.i_sb, "error %d truncating bmap (ino=3D%lu)"=
,
> > +	nilfs_warn(ii->vfs_inode.i_sb, "error %d truncating bmap (ino=3D%llu)=
",
> >  		   ret, ii->vfs_inode.i_ino);
> >  }
> > =20
> > @@ -1026,7 +1026,7 @@ int nilfs_set_file_dirty(struct inode *inode, uns=
igned int nr_dirty)
> >  			 * this inode.
> >  			 */
> >  			nilfs_warn(inode->i_sb,
> > -				   "cannot set file dirty (ino=3D%lu): the file is being freed",
> > +				   "cannot set file dirty (ino=3D%llu): the file is being freed",
> >  				   inode->i_ino);
> >  			spin_unlock(&nilfs->ns_inode_lock);
> >  			return -EINVAL; /*
> > @@ -1057,7 +1057,7 @@ int __nilfs_mark_inode_dirty(struct inode *inode,=
 int flags)
> >  	err =3D nilfs_load_inode_block(inode, &ibh);
> >  	if (unlikely(err)) {
> >  		nilfs_warn(inode->i_sb,
> > -			   "cannot mark inode dirty (ino=3D%lu): error %d loading inode blo=
ck",
> > +			   "cannot mark inode dirty (ino=3D%llu): error %d loading inode bl=
ock",
> >  			   inode->i_ino, err);
> >  		return err;
> >  	}
> > diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> > index 946b0d3534a5f22f34ac44a91fb121541881c548..09adb40c65e505d92012a3d=
2f5fe8a5696e10056 100644
> > --- a/fs/nilfs2/mdt.c
> > +++ b/fs/nilfs2/mdt.c
> > @@ -203,7 +203,7 @@ static int nilfs_mdt_read_block(struct inode *inode=
, unsigned long block,
> >  	err =3D -EIO;
> >  	if (!buffer_uptodate(first_bh)) {
> >  		nilfs_err(inode->i_sb,
> > -			  "I/O error reading meta-data file (ino=3D%lu, block-offset=3D%lu)=
",
> > +			  "I/O error reading meta-data file (ino=3D%llu, block-offset=3D%lu=
)",
> >  			  inode->i_ino, block);
> >  		goto failed_bh;
> >  	}
> > diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> > index 40f4b1a28705b6e0eb8f0978cf3ac18b43aa1331..40ac679ec56e400b1df98e9=
be6fe9ca338a9ba51 100644
> > --- a/fs/nilfs2/namei.c
> > +++ b/fs/nilfs2/namei.c
> > @@ -292,7 +292,7 @@ static int nilfs_do_unlink(struct inode *dir, struc=
t dentry *dentry)
> > =20
> >  	if (!inode->i_nlink) {
> >  		nilfs_warn(inode->i_sb,
> > -			   "deleting nonexistent file (ino=3D%lu), %d",
> > +			   "deleting nonexistent file (ino=3D%llu), %d",
> >  			   inode->i_ino, inode->i_nlink);
> >  		set_nlink(inode, 1);
> >  	}
> > diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> > index 098a3bd103e04cd09b0689fe2017380d74664496..4b1bf559f3524b1cc3965da=
e9fd3e5745718569d 100644
> > --- a/fs/nilfs2/segment.c
> > +++ b/fs/nilfs2/segment.c
> > @@ -2024,7 +2024,7 @@ static int nilfs_segctor_collect_dirty_files(stru=
ct nilfs_sc_info *sci,
> >  				ifile, ii->vfs_inode.i_ino, &ibh);
> >  			if (unlikely(err)) {
> >  				nilfs_warn(sci->sc_super,
> > -					   "log writer: error %d getting inode block (ino=3D%lu)",
> > +					   "log writer: error %d getting inode block (ino=3D%llu)",
> >  					   err, ii->vfs_inode.i_ino);
> >  				return err;
> >  			}
> > diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs=
2.h
> > index 8880c11733dd307c223cc62ee34ebeff650ecb12..86a0011c9eeaf031cfa0b79=
875b2b106ef8b7cfd 100644
> > --- a/include/trace/events/nilfs2.h
> > +++ b/include/trace/events/nilfs2.h
> > @@ -165,14 +165,14 @@ TRACE_EVENT(nilfs2_segment_usage_freed,
> > =20
> >  TRACE_EVENT(nilfs2_mdt_insert_new_block,
> >  	    TP_PROTO(struct inode *inode,
> > -		     unsigned long ino,
> > +		     u64 ino,
> >  		     unsigned long block),
> > =20
> >  	    TP_ARGS(inode, ino, block),
> > =20
> >  	    TP_STRUCT__entry(
> >  		    __field(struct inode *, inode)
> > -		    __field(unsigned long, ino)
> > +		    __field(u64, ino)
> >  		    __field(unsigned long, block)
> >  	    ),
> > =20
> > @@ -182,7 +182,7 @@ TRACE_EVENT(nilfs2_mdt_insert_new_block,
> >  		    __entry->block =3D block;
> >  		    ),
> > =20
> > -	    TP_printk("inode =3D %p ino =3D %lu block =3D %lu",
> > +	    TP_printk("inode =3D %p ino =3D %llu block =3D %lu",
> >  		      __entry->inode,
> >  		      __entry->ino,
> >  		      __entry->block)
> > @@ -190,7 +190,7 @@ TRACE_EVENT(nilfs2_mdt_insert_new_block,
> > =20
> >  TRACE_EVENT(nilfs2_mdt_submit_block,
> >  	    TP_PROTO(struct inode *inode,
> > -		     unsigned long ino,
> > +		     u64 ino,
> >  		     unsigned long blkoff,
> >  		     enum req_op mode),
> > =20
> > @@ -198,7 +198,7 @@ TRACE_EVENT(nilfs2_mdt_submit_block,
> > =20
> >  	    TP_STRUCT__entry(
> >  		    __field(struct inode *, inode)
> > -		    __field(unsigned long, ino)
> > +		    __field(u64, ino)
> >  		    __field(unsigned long, blkoff)
> >  		    /*
> >  		     * Use field_struct() to avoid is_signed_type() on the
> > @@ -214,7 +214,7 @@ TRACE_EVENT(nilfs2_mdt_submit_block,
> >  		    __entry->mode =3D mode;
> >  		    ),
> > =20
> > -	    TP_printk("inode =3D %p ino =3D %lu blkoff =3D %lu mode =3D %x",
> > +	    TP_printk("inode =3D %p ino =3D %llu blkoff =3D %lu mode =3D %x",
> >  		      __entry->inode,
> >  		      __entry->ino,
> >  		      __entry->blkoff,

--=20
Jeff Layton <jlayton@kernel.org>


