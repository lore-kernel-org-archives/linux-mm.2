Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B19D2FD9E0A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3956B00DB; Thu, 26 Feb 2026 16:06:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1686B0102; Thu, 26 Feb 2026 16:06:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E908A6B0153; Thu, 26 Feb 2026 16:06:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D25D06B00DB
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:06:44 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74EDC1B6E03
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:06:44 +0000 (UTC)
X-FDA: 84487841928.05.A10D860
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	by imf08.hostedemail.com (Postfix) with ESMTP id DB4C716000E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:06:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772140002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wXm653hpUNbvhGny2Mqq3COutnyaY+n/e+zXIaJf8vo=;
	b=Ugq/ntulmavy1oQ6lzjTq9hh5Qzn7oCNJ258uECu1eLvU+IcL1HutOD8bEsdZw1xmB1w4P
	spWAtWhlhQcdvD2vloYPE/G1eXcfjkD/w41VAKAAnamdElESgP5zG8uKRjPaLmqq0XL16z
	jiF/nVIsccH1auslcfP5fcd1yD6OOJE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772140002; a=rsa-sha256;
	cv=none;
	b=o5uPFjkOgoRlgnB1TvKAh06ETkE5Utb4sYaliSIKU9cqFqhTGTV5ohX26eUhS8eRZlxkij
	czJ5dUBNR0sSHU4GfqiEmX54MJvQUyYV1x2Gf+ihaQbhgedBsLeRF2rbVPMAWuriiziFVi
	Deuc8BXBOIMWmoS5VwuhPhCWEN30z3U=
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 325382A3C71;
	Thu, 26 Feb 2026 22:06:35 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id wtNVnsVrigfw; Thu, 26 Feb 2026 22:06:33 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 3D6F329ABD6;
	Thu, 26 Feb 2026 22:06:33 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TTBOxwOFVdGm; Thu, 26 Feb 2026 22:06:32 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id EFF89298599;
	Thu, 26 Feb 2026 22:06:31 +0100 (CET)
Date: Thu, 26 Feb 2026 22:06:31 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: Jeff Layton <jlayton@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	mhiramat <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	dan j williams <dan.j.williams@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, 
	Eric Biggers <ebiggers@kernel.org>, tytso <tytso@mit.edu>, 
	Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, 
	David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.org>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, anna <anna@kernel.org>, 
	chuck lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Steve French <sfrench@samba.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Alexander Aring <alex.aring@gmail.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, 
	Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, 
	David Sterba <dsterba@suse.com>, 
	Marc Dionne <marc.dionne@auristor.com>, raven <raven@themaw.net>, 
	Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>, 
	coda@cs.cmu.edu, Nicolas Pitre <nico@fluxnic.net>, 
	Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	David Woodhouse <dwmw2@infradead.org>, 
	Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>, 
	chengzhihao1 <chengzhihao1@huawei.com>, 
	Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, 
	John Johansen <john.johansen@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, 
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, 
	Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	sumit semwal <sumit.semwal@linaro.org>, 
	edumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, pabeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, davem <davem@davemloft.net>, 
	kuba <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	oleg <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	mingo <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, 
	Martin Schiller <ms@dev.tdt.de>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-trace-kernel <linux-trace-kernel@vger.kernel.org>, 
	nvdimm@lists.linux.dev, fsverity@lists.linux.dev, 
	linux-mm <linux-mm@kvack.org>, netfs@lists.linux.dev, 
	linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>, 
	linux-nfs <linux-nfs@vger.kernel.org>, 
	linux-cifs <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, 
	linux-nilfs <linux-nilfs@vger.kernel.org>, 
	v9fs <v9fs@lists.linux.dev>, 
	linux-afs <linux-afs@lists.infradead.org>, autofs@vger.kernel.org, 
	ceph-devel <ceph-devel@vger.kernel.org>, codalist@coda.cs.cmu.edu, 
	ecryptfs <ecryptfs@vger.kernel.org>, 
	linux-mtd <linux-mtd@lists.infradead.org>, 
	jfs-discussion <jfs-discussion@lists.sourceforge.net>, 
	ntfs3 <ntfs3@lists.linux.dev>, 
	ocfs2-devel <ocfs2-devel@lists.linux.dev>, 
	devel <devel@lists.orangefs.org>, 
	linux-unionfs <linux-unionfs@vger.kernel.org>, 
	apparmor@lists.ubuntu.com, 
	LSM <linux-security-module@vger.kernel.org>, 
	linux-integrity <linux-integrity@vger.kernel.org>, 
	selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
	DRI mailing list <dri-devel@lists.freedesktop.org>, 
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
	netdev <netdev@vger.kernel.org>, linux-perf-users@vger.kernel.org, 
	linux-fscrypt <linux-fscrypt@vger.kernel.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org
Message-ID: <1889140340.1973.1772139991688.JavaMail.zimbra@nod.at>
In-Reply-To: <20260226-iino-u64-v1-37-ccceff366db9@kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org> <20260226-iino-u64-v1-37-ccceff366db9@kernel.org>
Subject: Re: [PATCH 37/61] jffs2: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF147 (Linux)/8.8.12_GA_3809)
Thread-Topic: jffs2: update format strings for u64 i_ino
Thread-Index: xD7TK6/dJ7pUGRHHehUamcKvWNrpNA==
X-Rspam-User: 
X-Stat-Signature: 1173ddiue7xet1agxsp9pg4wn6qac9qt
X-Rspamd-Queue-Id: DB4C716000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1772140001-377311
X-HE-Meta: U2FsdGVkX1+WYr3X3cJQ6WGtTDyUZKyLHd+XZt0gZUmjRHZpC9osFuEUpGhgXXfCg1zvVXfjBSbW7Wk325T8CxP2jibWstPpUQrqsoA6oDHUtSdYIbWFP9US/hHdOIqog+34CHdLc70kHTWPJGWa93rPNVOrRAe3GK0HZroXnhIxzjl6l1voaQGbxA60i+A80L1/Xp9LqsDjwrZ+sfxIi25XMWRaRn2bECv7awYoDc+isivJng5AfaZ8NPZcSv/IhCMS3npUNeGwtlijm5JDwEf/CO5pyQQTnyREEGDl+cA58/V1ksjWGutWQXdwTmIK9/R/WI/5jMTcnAlZtRd+KQJFLh5pW0hmUy/5143NsRt0Lb1/5eSahoy9tG4VlDGDBf1ePUxAg+Q1k1ICPaj7RIDXIFMJgFM0rwezB9IxOIXyF+KBd11uuFb7x77uRHc4VZzSTrzP5IqQUOz8T6VPq40bqNjRZtR+guZTTF+aloqVoeBV0oinEl5EwadiuqHQW8EIKwEP9zf8omtjK7JczdagKg66DbIv1y+3Ul3aHnW9fh4TNkgwxCMZ19bNRopT3TxOJPEuNJQJ/Z5F+K8jlZqc4nU4mSorAxCQONc0Ia+lGuEyxJ4MUJYDifvylw63WMxdljo1Nlo9dwKfUTOkUdtelRRGDcvR8ZqdOwkFiRkouLfMMKK3aJ1xHAFfUEYD8kDf/ojxlsEoCT7vhSfEC9WtyJMVyBPerTbpVZ5DwIgtVBVjHyiuUAJ0n6TUoLSTVreq8p4HTLpLyWA3Fiuuw3nWHDHh4azQFuPBamV7Vuew81C0VqmaMTBrN4csSW69WiQbeCKZ1ojCU5MJwk7mKameOUUGhlkoD9mJ8Sl7o9JZoL+yS3aPS5iKBnBXVJaHbXAEQhphzJ97EzSCKVCv5Vkus7BFV8v0TdOvxVaM/cVspg03yxFnokHSsKQCiiBn7xx2bXpC3ayWmOh3Ytk
 mKq64u1A
 pvT9+4vz4hPMafLbs6HFuQN0ricHndvAS02XTleTof5IYrSTdcuFhw67zLCnjAbpinAKWFVdWtwRv9jqDgUINDJbri1FXdj5eVqUB5YhBGLWiVT0ywzIKyGtsDmufIxDSXIsI7IAbFb4LPVWsjHl3f1L735zu1iKNDIs4kPuqB5HtCmUK2ji3hSN6ehWd+7wdqLmtsk0JHgtrDry3KP48nS1qT9MeAdMaWeltZ4dpoLzHnNEmhkHvk8a/dPWGIbm7nke6JMe/rKWtTxrFrox3wImvPsjrCiTRa4vCitICIe11OrE3cvcBQoFrt0IBnxZ2pxPjP5AvPL4IPOfgN4y7Nd3GO01P0spUILmi0MPTVNTDBdwmaVI+2NCm4ingURiBKDrfU8M4NTSUQ3yS8/FE/XWR3yIh1PmI7sWV8sXQUzt5kAuM6RLcS9PHCf4Wgkd31C3G1TZGUqCvET59qM4qroI563Ce0EgcmEjZgIVjBurT1ZQE5I3jXtH9WHtDuI8Wh9nhlgEtdvBL41Q19o5AoCPH/rhxVno+saIOTjHNCRqL3rGzpHpdX1rGm/8DPm5kOYRnFb6k9IK1YDtSVRBzSIK1sh2Zxl5nGyAqkqsqckl8eoxzLNDg0m8fGi01KbpHLCHyQpT91P8zeaLqrdTDn8EiqMov7uryXvKt3A/rHZ6W6SqVb0BwnCn9Ctlx0UQ06v4sky8DUteIIkMgGwyVURIEPcjLwktZOPU09rKQp6q+V6+hPQabLBnuzqHGlHe4WAyyLpkzQEioi2lr+lOifRwuV+KPDTZAtRF9p6P9FWHyFIriuiTNTX7rDAYMbE/aGEcfr/dkzCLykb0PwdJBWw/jVAv40huoXUNLMJN07CVp1nJEgJlunkgMuRRfDOlYdbaiAlL02MkEIve9TnY+X0IwkboIJAdruRjpb1vbDvis5jLLPCTjI1oT25H4bNuqAXVVrkJzy3B+n/hzQK9yye6C2KqH
 HLmZK/5v
 a3i/83GZ+/KoqOz6TZCZ17gtGC1wwSqWj00G+cSE/N9qXkTjpqg0iE4Pja/tyvXEFMplis5IN88zKhwnKHOTX6oVYcNORBUOcE4Ngnc59/kot9jfYDUSeRgpGtpSGOAc+seT4guOGsbR7Rt3eyWELBl98C7DwyZ9wpk6Mmx2jLsJMSAg1uJCTThWZrv0BnSDkJ5lgSIocO0Cw+9s+qsD7uGvQ/aJgU2fZGKSi7aKNEyfxLybU05m5jX6dDpF3UWa0xkryteD5npF0kIivCvys+254c79FieKf8Q7M5Y3YLa4PElPjsBD1SMQCeovR6jvqlu1dkHdbWgtNeELeUwTNooi7pos/wZ8k20n4DewcBeK9X4ao6OXfEVVDDkQKYkA7LErmNd9PoBkKAQ6sbk+gbMK63LnDms+H5s79yMKn0fvCkhkLFK7qFxMjQHRGy5PRZCVdrUpSLiXsjj9ptV7etKBNJKL3tZWAiEcH1xemYHQK7olL3daCcDFzwXvDskU09GsBZiTu+nHq1Obi2kZofg9Pzd46l2cXGxrPymTuYDDvT638L/KEFuq6QvXR1nEbTY99bg3nwdL0rl5l5Jvtk4Y9TV1UGFJ+B5mAhTdQaswmY/xgy7ajQXDduHIAV5O1C9qRAzBVM0dUOtx+LnYtbci2DVpW3CeSHUlKK2D93JF3I/m46nEZiQy+J5lWEDuDzg0BXWPK0gH53GdWczHJaihLlG/p1Oqc1FMNLuE0+v+xAqB6FBpDbnPpRRhj1iN9K36mW8kZJyh9r9VAUDOmkaYS0xcDxz2DqUmmm5Nw9+gh6wvSvNM3I2PO2ibWZXCsBDH6v0pSkAi7w5P9pawk+nSQJmcx2/FeoL72fGnhBBwDxLBgWrwSzwtlMc7BZodm8cnRYR7q0nO+tEe/nOQ/JnpP2+0C8A1pyM3FUuPRA9xZQSHbvgf4jMgXTAK2dysdoYkHlcKiyCHCa0H+/MG71UAuUzQy
 ldWYk/Np
 go1WIeV5BbYXaL6hDeCNeeQ5UtmTBbnC1yC9bujAYQEazG9opgo9yjbg5rxOYcwbWkJ21Ox6TkkhyOlr3p2Pkq8sl6MUXNKRLLs3633cPMPVYHBXvFlxKcG3CULNSt899SyGX/KKjV1dqd3dgOkJebUp/VkdLCQfF4cY+6LxzoWIxBHD6uwj+kSwZ7hiLrAWijDPaCzwZoIGDDKejzWuiqwUEYrwCY3nU+1aC7TrRmXQy0nW6zCr/i+s9aUsRJ3NxQApaNWvk8Wfwfl8DUSUATHryg1ncbX38qZO2tDcTY9wykGbJOb3jYY8FWo93mkhSLwXUKmJn602IxVIn2O9AgonOKS9rgDmUY4rZo1iawaijthnidJNq5Apv9MGITvPvcHkWk0i1/UkqawIayv76jAEx5ZcPpVrIGFNEDhXH+9ktM5mnc/m3QQvzvaPMYFzD+uS8JQvnvTRM2KP8Gy29U4BDPXXkev5gUb8V2lp+LWLgcgp8FrKkeVdIDccp6Tu33H5tjVNoZZXtD1bKoGOUPJzdPcLI3Uy53H3gFHoeI2Sj7V8P1jCMRCFflRB09pT1O5ELUg89SXhbCIjvDPWzN42iy0Fs0DX9XgpHu8VcfhpTXJvRZ0YR7LiaSRactLWPkz8OGVKP+2I5M1ET5/W0RmYK0lUiIYBSUmO5HJdbk41yWHxITjg4G/iitT4fnajrrYrx71v3e40AszelMiBkn+R0kcENKG6Jiirm7JyiVyE6GdWK42/z90rTlPUv+A0EdstIxyePoGAsp3w4281bBM82kSV95HWZyq/NgHnVEqtUOjIlPKbjH1/ol0OTMPczfjxEH65DvQErgPl/fXrzTgRDds+uNuGlzNpeXxwmAmchqvzHf7eydBf0wMN6ZMJCplT92UIrEjeJhO9ePDVUJFc5sC9z3AxZCNsldvGIcFHVz3eaKNCBnVLV958yKKxo5fpBftZAe3pyYeDxiZW7g6ueQ/R2
 E2W+oZJg
 F4zgp4UqgYQqCd8czrTCMwPlA9T4YHIQXSizjiK5P/zJjappAY130nfDxRy7VOLvdDtLg++q9LuoTjxER740gYJXX5Jtab5G2vxQHvcQduBeo6prAT2R8Fo8KvUqTuAlHdn2HzjUyg8p6ASpRc64ThAlhexyvf8puNhMqBoUSJ9Ck8Xm7Ta9c9E9nM0FssqYKoxbM7e0V4JN3XG+fT3Kaf2l0pBM9k1H/+xtuhW2/ZVry36Q1ySxzYtaHn8pbK/BIMMocmtW3M3gib7F6JqHeUwTdsiIWiul3qokR9KmQtjtAdCCgDWmwLAUZaZNgfRHnZEOfWWaAduH8L3toO5PiuDzLUwZfu5Upvasem7Kcd1plM4Y/q6xzlHHvkZ2Da/tK65xR1F09saElnYBeXkw/K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----- Urspr=C3=BCngliche Mail -----
> Von: "Jeff Layton" <jlayton@kernel.org>
> Update format strings and local variable types in jffs2 for the
> i_ino type change from unsigned long to u64.
>=20
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> fs/jffs2/dir.c  |  4 ++--
> fs/jffs2/file.c |  4 ++--
> fs/jffs2/fs.c   | 18 +++++++++---------
> 3 files changed, 13 insertions(+), 13 deletions(-)

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard

