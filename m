Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48CE2FD8FD3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991086B009D; Thu, 26 Feb 2026 11:22:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951AA6B0148; Thu, 26 Feb 2026 11:22:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837416B0116; Thu, 26 Feb 2026 11:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2036B0156
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:22:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E9088B3F6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:22:28 +0000 (UTC)
X-FDA: 84487125576.25.119F4CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D795040011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:22:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JssZjrPw;
	spf=pass (imf27.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FEJyjbicGOzFjiYzXKTkera7jYDMXPs4gjGho33QAb4=;
	b=KO+/JosCFSYj2WuVUwzIHt35DsQdMWU014+3m0IRHXA3rWxZkq2CLm1X3fG9tqnwRZP4On
	ZxiRF7rV1jDh/HejtwCXKesRfGb9VE0jV25iVb28FIPZm02Uo8L3PlNe9lGVwX9tU4jkzi
	z8uaz3i/Pa1jHbubQh8OEPFzzfE5NZI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JssZjrPw;
	spf=pass (imf27.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122946; a=rsa-sha256;
	cv=none;
	b=L+sYTX3hUAUXwa1jewlrB9Mk0VQeLQChbm8mBRcLEKAOAlDByLjfuDPzk0CeKb604FLcIR
	kmiKEHFBg3+QPBIIxrEtnz0TSm2sVUsu49EXJv4CL+eCFKb2HZ10rGn3vmaU3GT0iSmlry
	O2tjWK5RvP4TmAeg6SH21a3mFo5wuXs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6E3460137;
	Thu, 26 Feb 2026 16:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBF5C116C6;
	Thu, 26 Feb 2026 16:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122943;
	bh=zBSOHROIWzwnJvs9/9cwNsUSUVDRgXIG4XZCDyNzlZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JssZjrPw1BO0Mw8Q9yfwnQsgaD6FpgkNgIWpbVUWXLyeJnokKKg4hk1SAaRN/4Pl2
	 p5YBVNEqJjiqtkjLnya4b8Ga67KiibEKKFpBd87HHM6a9Nr/QZeAv6psBrGRdFMMiz
	 A9DSSr/iUARrTgSnBid48sZtR6nbfqnBEMtEEnmZIzWpuH9bLY6kY9ErKk7lBImyBm
	 /Lk4+mloyiRijQ2SiVpy8mPc9oycbHcUIEINyu+Tm3ChF79dz7yAux92+Q0KlVrv/G
	 LUTkHVEDI976MFOVD4JvxorvgEXP2iFNe7YZQj9uo/QF6AdIL6XZAAV6xKOXhQSqTF
	 qLmaMxW89/z7g==
Date: Thu, 26 Feb 2026 08:22:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Steve French <sfrench@samba.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	David Sterba <dsterba@suse.com>,
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Dave Kleikamp <shaggy@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
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
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Martin Schiller <ms@dev.tdt.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, fsverity@lists.linux.dev,
	linux-mm@kvack.org, netfs@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
	v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
	autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
	codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-hams@vger.kernel.org, linux-x25@vger.kernel.org
Subject: Re: [PATCH 61/61] vfs: update core format strings for u64 i_ino
Message-ID: <20260226162222.GH13829@frogsfrogsfrogs>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-61-ccceff366db9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226-iino-u64-v1-61-ccceff366db9@kernel.org>
X-Rspamd-Queue-Id: D795040011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: cbmqyznt8o147b63z44o1czw5f89cw5i
X-HE-Tag: 1772122946-788668
X-HE-Meta: U2FsdGVkX19nk6qzESZ5hlD9fxMQK3PamKePmhv1iqyfXy2JGbTS9IEgzHIkjvtKLS4PYm4tLm5++oxZrAQULsC5A6wxPBPaJ8p6DhWYQYNxEGTBRGUoDupFiiOccqI7MusLQV8bNw2piDCOEgGG4OXTldrOGFcramlnbSqRlvohfy7M/ZZnRNfj3IkNVwqUO9rGlbczTCGWCI3V9w+nGXwwwPo1DszyehyQ06eE+5M6431958hqRTG6UzcA0riLr9KkLeSRTWiL4OC5E9r88w5oDYnOn9z+AmIwfNekE2D7DDi7ibyruRpW07F25UI01dfq/nkUACgZeLchCv5SDdS6Yl9aHAXHtlAC+JpCU1aTIn6Vowb+V2Z/IXtsEJZZI7WuHVEXB7lWm0jsnmPVQnnfoHdfm6iztfgWtiaE7vUMCSSm3ksn4dKChqh/OtkWtj3tH7boQe55SPhMkhM87hO1EfPEYwStPZQ/Qizv9/4otAE8cNO+xt5H3kY40lepr5kz2hJJTLR5M8r2u39vT7yiNa5t+6cs4c1xlWWDUsunvxD6uSWJSkCdHSaTBkOPfWQRt2kS1KraJwES4NkPbcgc/5hEwzSkzARTB45n5OA+0DzKPrlMCvBP1abEMbLvVKLZcRdMl6Ph38Wii678aFPCFFGqIPHHS6NSRTvViox4/lL5PuTu+d4X2ctQ0Hs4Gzineig54h8uZ9dn1mLVycNqnLyp62rPcd83ngxUT30TWVnnkPhjAuiL+kHQyIa5PtK5D4uXeUgFk9cT6vc3L1QdcOiua6HDA8SnGONF6inDac0+g/eXCys2kXvKzBV/B8LCER/gdliBhYVT8oZSlZBOf2D4/nAgSd1YXcGU+ct70tPCud7jb1j0Nc3+mkvIKgUC4s4UGWk+TPk4+bvhsgPqVjrykXq7ocs6bJB07zH+SmITSRupliZlL08la31O00D5BNWTr0v6ofd1kvu
 8GEvIvh8
 b0CLmLj03QEMrtGEAA49caTrsGJx1de68nFdJj7EjDY3xQ4qI3VKbbqt8a+EafUaxazhNxoOcqgQLkifHXQgr2gwAJ+TgQogziwQSFtIuR3zcykhGTw7GYL0+S8hV4u52xhg80SueYT5ggcAvcXGL9dvOexoM7yzgTxShuuH0eDhHxAMozu09HiWEFNThKiywLB9/siPEUYEmW0tNnKGtfR3bbNBDXpUsQPenioJaL/0jJZaLscrk9BDUpqLIHx+66Y3oJKeOV3x87i7WwHB+t4tvTVWOwxiXgtnCgIp6CoHurQwMb/NdN3UEvH7amVGKnNYneWYE/xHDsam2PdlwIshj/VeA8HnfkGdcHJ7pQV5kW1Cc67Amo8KTpw8e78JBU13WC3E7DZM3Da1PSDE9QJKYLEneJsj+hvr0DtHfUMvbWx5bFdtKE3S4kCqLMdyXc0I1jTmmBWjkjNealcFD6GHzgVcjUQ+rZsmskAvQ081X3+BX21o6TXf2xvWMAPFS2QZ12dQ1QpP2s71te1R+feDmbw6aHkFPMBIrVnD4VfMF6mBUHWSFcnW648O0wyA2AZvZVzB8aGXfHNHWKbyxiGTZYrYBflXgHGWsQWcXHPCQ7QQHLPe7kCd0+tqLkjZ4RaNh0/giaegBaGwCe622butDGHT4FiEoEZM+V4ye1reTjTk5rE1oeMb0kL9UVXaM96797/lLLp20hQO+Tl7DKPWAxAUGep6wvzW3vScsfENfohVRZ6t5Ai4yBVD0ZOHmP69fbeQyk2imyULFhdDQyngm0OCiQG8woxc4vG18HSlSAdC8du7Rhx0HvOnDmRq+PZjaOgA+tTrBHihYs3w5cVbKxatsS27eu5vOIMnEV5eu5Uj5XnJwgf0I3paYWbDf1g/7p4uYFNz9vo7pcB04JBSEFiE/9z2TJ26eOGk6I6ZfndJ2MZd+9iNbuFGnG8xsEpGqWfLhmFW7atML/anL2kFEDYQi
 JSCiKsFp
 ZErF7D106yim9VAyWHj1wk62P4BJjxL+eCcsd79I6xIjdx7lPb4nj1JMKzaK8VvuqnyjLoZxqNpt1p46q0d+RKe3pilmdsIN4KTVJ5fXysVcZTUR226JhNCE322aAlk1sXNsdYGYAeYMja0+IbSWP9LBPruakM5Obbsc0FmsQGQhACTWUa2ZDduXG1yqdqAZBI648tOpxsTpfma4rEnZ+lhv6gWHedVa+Mq1A2xKt226uX/KyYqD0bUPf4BnbHIRbE3cCmQV/pJBCMlmuy+yyaVv7fD39RqYU2xCpitasBiAT2UHyaUI0Ji1+aQAKYco/9YvEjC+1ZFCC+Wdo3lzAqwy/+kVxcRxkxm3gcpAlY07xtSF1h51Fw8ZRqGergxZYT1J/BRVB6RMo3zJukaU3egWmEyoJJb3GZ09nQAs+vbYh3sZCpNd9YkV96OnW7tp2jmqPOid/F+zgqj2AMeWoddM56QoV+6MBEfXKcQgtH6dO5+BBrHWVVO3EEMqvaw32qB52Kk3H8Tg1fZISr7Lvymfl1xwCk7jbcQPUAgu2wXVtYbaZTg3KdmSAkhJeCfXSkNIsJTQgOtQQR+gAg/4QIP+HLHWIquAbzhdl6DiMbsVZwKYsxJrp2NiK3AOTuVtE0noH2zB4sixYjE4f92OISwWX1aMGcFTBC1jv+CMzqRxX0k+BE0vdY/REnSuGxglMgrN78lsvBonWcHDFqyf48VSr9uj+6FbwPD+swJwLk6nz91A1Op+8LzS9RWVxK811z3POZFa+uT91O6ajY2YpOeq6rO2XJbI2FXpNfuijSdZPu88lPUtwkKEvv5shvSk8t48p8sUVX9ylWJ4W2+eH+CHotksUeje7i9L7OIrrqTCdjoJIortqDpuT+pL44lG6CnKl3H7YATLP0SFRMMOHHjAB6YGUaDjUp9A0FVaqWCebVzZRjK8HXws9F1gjIn18T1Li3JUcnwXcbadOBzhO+mGxDevv
 Q479/5Dx
 KEhdqaCNPj4Cd1Ej2YmQjoyZ3X78En+SShV4Lmzhc/NqmcwwScQGF3xfTjrtlQSjyJZG4/WmoidkQVOvE1HDk1ADrjy0zMBHO4Aje6KMC0gyTSDJg7A20SLRdncFrry5gX3d3NxAnAikDuMvI5M2nEPzd2UUSml4N7CN26kFbEjq0+T8V0fm07TXnKjkcS4soSO9Tg1TFvA4q8kGHfUvTMru62pOqwfZ7qjGGE+VnhAMdztsFlWTGq/Ny7Ub1F1yrCZzomAU12tvqN4gkr1O2kqBMxO6WOf5iQ9ooJwwvpATZIRVkZC8hzbVt7NCPXsnXN0qasdsepgFSmyW6bSHrtYGHUAz1wosrLcJVjPFbWUkGq91nNdZkSUeJ4aw13jc01GNlT+NiAzO24nlIWh5mpfdiMr22+fUvrukMpXOpI5bcVcPVyrN/GE7ikZsRrFb+iKoIRPv7Hjg+suAe+AhKKF1Y0vW8Uz0dxdUT8mrWZXuPJtBuELKplISVn0mV7v15Is3n+oEfINxIUzr1lsgmQns3ieshEebmXqLc0sTLj3LhsQVBM3MA4HEaI8pWMiS/KasikJOIpXLo6RQaJhSQqylR9dCYJCHn/TgsyBp0Ay+McpSj1Zmjxi+tBdFTodqXqA1oi39z9eivSKQMvxAdc3OWlpFWEqw6fREMqYFp3q5QBkatALdqLpjS0MB5XF+6scq46eGsCm1Jq+PIbVeb3bjBE8FqEIaCKXW1UHbRsjtEHksivNi6CsrxdLapeFtY/JR4VxXBPpD/Javt1FSdIsSpN70f6m+3+xSX5w4O8HmyMg4vfti+cgt9kwKhIRQNSpOO9fVRT1HkYqgr8yJAunsiRh/vpPg82shdo5JBlPbvyWxKahnBNS1F0i8J7Sj46cFO/v2ZfdCA6tL+dYof2kDX1MhoR0cSF/ofpOG++czIf0+4eyXAys8oheTfG44o4F0xQxnYxRltOWtoP7xpkKOtDvud
 Hb+HBO6J
 5csRgjVa75spetJOiPKh68Lg8IDNSN+ZoZhCziH76e+2nCxp7OMqQ0lQYxQ3hIEnW6K7uScb3+cQ/OK9/ZJ3A4LFP3goWnuYDr1LX/CFIeo1UhQOfuet8hsfvmSQzAs7dGGAvj7XJEVL/5hRckeXCx/KCTI68E/5Iv7zjumnkFuc/z5FQE+8ze6fEd8LAxeN7OH3Sbj9wE7iGR0Ytef9BMRUOPF8Ikdd2G+ST1nM0USpNsVM9fzXstE9VrFozfgB3S849FWKwn3y1KF9TWcYaCDTkEG2poskor5ACVMveRN8YHHTFv1uBjaq5IPyHxoyu22sPZOZkDrIsJ8kUdRjvk7HyxSI5jH3EMCwedLyF4M+rSbx/EESPfvlhnmRdO2E3T9npkB7FHZPBf0wO9sfuzhcc8jCMnyM31+pLX+XEWLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 10:56:03AM -0500, Jeff Layton wrote:
> Update format strings from %lu/%lx to %llu/%llx and 0UL literal to
> 0ULL in pipe, dcache, fserror, and eventpoll, now that i_ino is u64
> instead of unsigned long.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/dcache.c    | 4 ++--
>  fs/eventpoll.c | 2 +-
>  fs/fserror.c   | 2 +-
>  fs/pipe.c      | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 24f4f3acaa8cffd6f98124eec38c1a92d6c9fd8e..9e8425ecd88955c72027d21591b1d12c87e7e8aa 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1637,11 +1637,11 @@ static enum d_walk_ret umount_check(void *_data, struct dentry *dentry)
>  	if (dentry == _data && dentry->d_lockref.count == 1)
>  		return D_WALK_CONTINUE;
>  
> -	WARN(1, "BUG: Dentry %p{i=%lx,n=%pd} "
> +	WARN(1, "BUG: Dentry %p{i=%llx,n=%pd} "
>  			" still in use (%d) [unmount of %s %s]\n",
>  		       dentry,
>  		       dentry->d_inode ?
> -		       dentry->d_inode->i_ino : 0UL,
> +		       dentry->d_inode->i_ino : 0ULL,
>  		       dentry,
>  		       dentry->d_lockref.count,
>  		       dentry->d_sb->s_type->name,
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 5714e900567c499739bb205f43bb6bf73f7ebe54..4ccd4d2e31adf571f939d2e777123e40302e565f 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1080,7 +1080,7 @@ static void ep_show_fdinfo(struct seq_file *m, struct file *f)
>  		struct inode *inode = file_inode(epi->ffd.file);
>  
>  		seq_printf(m, "tfd: %8d events: %8x data: %16llx "
> -			   " pos:%lli ino:%lx sdev:%x\n",
> +			   " pos:%lli ino:%llx sdev:%x\n",
>  			   epi->ffd.fd, epi->event.events,
>  			   (long long)epi->event.data,
>  			   (long long)epi->ffd.file->f_pos,
> diff --git a/fs/fserror.c b/fs/fserror.c
> index 06ca86adab9b769dfb72ec58b9e51627abee5152..1e4d11fd9562fd158a23b64ca60e9b7e01719cb8 100644
> --- a/fs/fserror.c
> +++ b/fs/fserror.c
> @@ -176,7 +176,7 @@ void fserror_report(struct super_block *sb, struct inode *inode,
>  lost:
>  	if (inode)
>  		pr_err_ratelimited(
> - "%s: lost file I/O error report for ino %lu type %u pos 0x%llx len 0x%llx error %d",
> + "%s: lost file I/O error report for ino %llu type %u pos 0x%llx len 0x%llx error %d",
>  		       sb->s_id, inode->i_ino, type, pos, len, error);
>  	else
>  		pr_err_ratelimited(
> diff --git a/fs/pipe.c b/fs/pipe.c
> index b44a756c0b4165edc2801b2290bf35480245d7a6..9841648c9cf3e8e569cf6ba5c792624fe92396f5 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -873,7 +873,7 @@ static struct vfsmount *pipe_mnt __ro_after_init;
>   */
>  static char *pipefs_dname(struct dentry *dentry, char *buffer, int buflen)
>  {
> -	return dynamic_dname(buffer, buflen, "pipe:[%lu]",
> +	return dynamic_dname(buffer, buflen, "pipe:[%llu]",
>  				d_inode(dentry)->i_ino);
>  }
>  
> 
> -- 
> 2.53.0
> 
> 

