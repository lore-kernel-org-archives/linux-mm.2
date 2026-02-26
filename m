Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B389FD9E07
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 20:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667336B00FD; Thu, 26 Feb 2026 15:06:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631BD6B01A9; Thu, 26 Feb 2026 15:06:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9506B01AB; Thu, 26 Feb 2026 15:06:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 376A16B00FD
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:06:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E13D41B6DB7
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:06:53 +0000 (UTC)
X-FDA: 84487691106.25.2F8B014
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0FC1B4000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:06:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T6YnEYfl;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772136412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qozl/xu/R/ec/NMcbdYBOotw52eFCc0c8kMyaFBnNPk=;
	b=rlXk3vVVkgxShfdh+GBMHKFeeb7R1pN0ELSQ1Km39gWboeG+cmmpZYY5ajDUUQPLyDnOyB
	X4GKt5OnP1UHwCfIxAapcrQKc1doRy4PUvFvcV1BHm3atzbgW4/QJzitDHxKTTSDscP1kZ
	UgV+CaCZskDmRbI/etV3rh1XnYo+Bq4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T6YnEYfl;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772136412; a=rsa-sha256;
	cv=none;
	b=MSQ++P+tC8fGhXaxL3AZ11HotNFeI9m2MEdQDHIrm5JTaZ7Jm3HG90l9Z0ww7LEg0KIdnZ
	1le7uyVwvaDSkgJudaixTgOqsZjaAbY+Dul8NAHkb1iWBVoWvKBDK72Ybd5SuMon8V1qQk
	xzkFbSHKLReG3CtezyB0CngERXYos6g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C12C942B11;
	Thu, 26 Feb 2026 20:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520C4C116C6;
	Thu, 26 Feb 2026 20:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772136410;
	bh=76x3DU9MzBkl90lZYLvAbZAUO09C1G9Su6aBBpYsJFY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=T6YnEYfl11ih7xUSiFK61/RDBp81heXTpln3ok8zs3Zd3nR9+pOnRsLAGh/eo6zzB
	 xh1FFGrV6ghTw8iJhqrMVYDcQ7Io+PErWnVjKKQrZ1K9m8FptJkjvekaVsWXJU24My
	 UlJTUr1mw9KmSblPgaqK4kPBOMclcTyGUg6sIEibALC6s9Eo0RAC4P98mpmWUxKxML
	 WCYGgFC1YjtgKQbYQpyc/2jhWHqhTn6/UIey3SlJZaM8cFB91k1Jrn8n4CCOSeLC5x
	 1Zz9aVxBrExtMgqHMxE6dB/3PmeoJvP6nYlZZkPZRM4Wr+F97z1rOiIzHljyWlcR5y
	 +jc4SHRMUt5HA==
Message-ID: <9dd2d94989c395a99576b6a8896c582dd33f6740.camel@kernel.org>
Subject: Re: [PATCH 12/61] nfsd: update format strings for u64 i_ino
From: Jeff Layton <jlayton@kernel.org>
To: Chuck Lever <chuck.lever@oracle.com>, Alexander Viro	
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	 <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu	
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Eric Biggers	 <ebiggers@kernel.org>, "Theodore Y.
 Ts'o" <tytso@mit.edu>, Muchun Song	 <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand	 <david@kernel.org>, David Howells
 <dhowells@redhat.com>, Paulo Alcantara	 <pc@manguebit.org>, Andreas Dilger
 <adilger.kernel@dilger.ca>, Jan Kara	 <jack@suse.com>, Jaegeuk Kim
 <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,  Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, NeilBrown
 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Steve French	
 <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N	 <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 Alexander Aring	 <alex.aring@gmail.com>, Ryusuke Konishi
 <konishi.ryusuke@gmail.com>,  Viacheslav Dubeyko	 <slava@dubeyko.com>, Eric
 Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov	 <lucho@ionkov.net>,
 Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck
 <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, Marc Dionne	
 <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, Luis de
 Bethencourt	 <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>,
 "Tigran A. Aivazian"	 <aivazian.tigran@gmail.com>, Ilya Dryomov
 <idryomov@gmail.com>, Alex Markuze	 <amarkuze@redhat.com>, Jan Harkes
 <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,  Nicolas Pitre <nico@fluxnic.net>,
 Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
 Christoph Hellwig	 <hch@infradead.org>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>,  Yangtao Li <frank.li@vivo.com>, Mikulas
 Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse	
 <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp	
 <shaggy@kernel.org>, Konstantin Komarov	
 <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mike Marshall	 <hubcap@omnibond.com>, Martin Brandenburg
 <martin@omnibond.com>, Miklos Szeredi	 <miklos@szeredi.hu>, Anders Larsen
 <al@alarsen.net>, Zhihao Cheng	 <chengzhihao1@huawei.com>, Damien Le Moal
 <dlemoal@kernel.org>, Naohiro Aota	 <naohiro.aota@wdc.com>, Johannes
 Thumshirn <jth@kernel.org>, John Johansen	 <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>, James Morris	 <jmorris@namei.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, Mimi Zohar	 <zohar@linux.ibm.com>, Roberto
 Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin
 <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, Fan
 Wu	 <wufan@kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, Casey Schaufler
 <casey@schaufler-ca.com>, Alex Deucher	 <alexander.deucher@amd.com>,
 Christian =?ISO-8859-1?Q?K=F6nig?=	 <christian.koenig@amd.com>, David
 Airlie <airlied@gmail.com>, Simona Vetter	 <simona@ffwll.ch>, Sumit Semwal
 <sumit.semwal@linaro.org>, Eric Dumazet	 <edumazet@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Paolo Abeni	 <pabeni@redhat.com>, Willem de
 Bruijn <willemb@google.com>, "David S. Miller"	 <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman	 <horms@kernel.org>, Oleg
 Nesterov <oleg@redhat.com>, Peter Zijlstra	 <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland	 <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,  Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>,  James Clark <james.clark@linaro.org>, "Darrick
 J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
 autofs@vger.kernel.org, 	ceph-devel@vger.kernel.org,
 codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org, 
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, 
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 devel@lists.orangefs.org, 	linux-unionfs@vger.kernel.org,
 apparmor@lists.ubuntu.com, 	linux-security-module@vger.kernel.org,
 linux-integrity@vger.kernel.org, 	selinux@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, 	dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, 	linaro-mm-sig@lists.linaro.org,
 netdev@vger.kernel.org, 	linux-perf-users@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, 	linux-xfs@vger.kernel.org,
 linux-hams@vger.kernel.org, linux-x25@vger.kernel.org
Date: Thu, 26 Feb 2026 15:06:36 -0500
In-Reply-To: <8b0bb056-9504-4835-8063-7ddeba328721@oracle.com>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
	 <20260226-iino-u64-v1-12-ccceff366db9@kernel.org>
	 <8b0bb056-9504-4835-8063-7ddeba328721@oracle.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: zzwon3k7xzyeoozpp83yrso6fmdcpp1u
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FC1B4000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1772136411-795383
X-HE-Meta: U2FsdGVkX1+ollNdx9wUDTHTKyLpwzV9rI9RR9ZFQIimxE4wHv5dEwvyKPhBFLVussyCSiVav2XuegcEK9WwwyxTym8IxtuoovqtQyYK5EYzJYpHgMydbBbsohEdO8Mp6blm4g7azqCuu5buXs+lcJ3uYa9QuJ2vGKREcpY47mde4nC0xxujUhZ7tX9ZFJUIqndYhgKCUSK5tkN4LwsFUEhENz8lDVsYXDukT4cJ+0K+OVF/34tTTTQKToNzPaglhqiA0Dvyh4EgvY51CN48rPJ+XtBGhy0GX9Rtb28dwtzQR+6YKnOO2+0ne0z+wn2Ie1ECNRaaQCzJAT6O/h0iDYypMIawHEK2UscaODG99Iox7gXqh+hYVSwvrpAmwBhMKOl6QnmK+dO4knRzMEwR2SQxmmWtkgPd7nFmW1yLVALEN3LfTEot3axBnngPZ+egNFRCD2QHpWnCtGm5jl4yUV9lolQt4uCAnBfIjZklrFKmTL7RveSnITcL1RflbMaUCo/mbqStnKC9/N2WfaAo3lNLZcDD4I0MVWMKTGPYOUvU6VKcODpVEFpWxFF9+gLO3sx09+jsx86xflwjxRmjgrV652JCFD42GxbQNrg9JPSle+P3AZIjd6z/rWGaVGmzofnGxR1T+0Eic+a9sJE3oMjAyyuyuVy6O8chq5jDJ0oNWkGtUVK44BDVIathJccsefbFVniP0ulNiZiQUajQTYQrcz0uZomhXjKNWkazNGHYLC/oTsyL/fJROnKiQkP/OvDqJLW3C42XsvM0L9mT35AUEN+U6peuvQLsZg0SYBpHhGtSYBxNU6syqUAlQpxYwwAs/BSRQKLLASm7O62aRW2ioeFJoi23RfyjajFOaU/yEyCJvu/c4IOp5Chzx8W5bgCzZKlRKE2nS2Pnm4Ih2Vw6iZqQCIirfUFrTrsCKF3Dhku/obUjPfnHwRlwRfsms8/Pqx5ShNb81seA7ov
 mdzowdzb
 E8ztpYHaPyMcew+la3x4yryME9bPJbVofrvc0Um5dLo96r4a5oCebF9bSXntQF0IrORnG1v0dIU3rqoeEAbspxY5X6fExjiwuhJzi4QXmkOhednsOld8BSUrmNhyQkuWX9/+xYUa6UAovJCZTa+iy1jjrD32vKhUpQt9UjPnV6yERnwilglTZJKAEmEvjE/K6SC4SjPcEVxsiFbu1WKWI3QF0m1qlPGRg2W+faq8iPqGx8NlahOpW3/uZBE0jaT8vSzjiBWdXFzQCN/bg3jkbfZLwmQHAojCbGw0QnyIcb+84vVb0Lg6csyzeAiF2ie3u0OFiJVEP3cXFZ8KT4Uq+WGh8cieQamrLgDPF7chpDxq1erELObcI072P9YH2uC8+lhmNWA0QDvSDySurjje9wr3YKAam+SVR0a9OUOEp2smiMsOYtfIxyIoqX58ndKmrgMIee2c71f8qN12Daru5EdOTqBh2FbmimCaFq1OzsH/Np6ySAM6XB/YrkTMjmO4ZKCcEERYwsMIsd+wLqxcJ3NgXaiZpKt+LHAV/IzIBn6Cm3g7RZ/EglaEbBjtyONc0l46dMAncruTvu35RSbI+dqgigN0UWx91gVVs6T3LEGzZI5aTWsoo66bdkzgNWQHYEpYOVJgR8Zv76Ux23bfLgGO6FnnXxzlhUnoROGGzJpR0tXqvxqtfPI0Bl+zEe2LwGmeOSfM74G5isnV9pHra6Ay5vG34ahTskhUPaW/2VVdjTZ3aCP3nf4fNzwGs56w/nh7yC52V5Fq2LOSDEIzTozST74a+F6ft7ulTTJOgH+m4uinNfl+7+CDRQUCsGCzfj6WKpRaZrCAJGPPhSg0oyO0xy+jh3+tjJeBgKv90d7otU2XzJ3Ml2FUsRaWLWtfyEfQETbqPlXUm6/R8aDUOvVxOHwskg1uJxQ1/84AdREHpFqUG/D+Z2hVWoj7HqiY6jeG/ZKy1nUZJUjBiNXFW3fHvlNME
 BcuMv7EI
 LhEJns9oQ5K+ehvB8xr5+2uNcFCzW3FB5kHLsqBbHy3XJshnEYgSrNeG9bayGBz0zEwQwZuQqr2Mh7GmNPLbKIqtzd6zL7qz2TfxBAZEO6JhO/HRcIF4z/pmoLqQnUsqHk261DtRfqWMZpo0DSghTs9IkfHOvj2HXwgrfYNsuPjMm4VrwZR/40xt2uE1l4A1pJjRqQvc8vaBInPU9qltJGpY0+UDorV3/pVXgL4/9B6I8w8z8rd55Pvd23FflG3j511YBPrcZ6O7grQDfVvmYMW2kDNW58oaDNrwJXatQRTlC67JFCr7PpgesF75iH3qewWJzLC8jhy1G3+qk2HqlFjrsIxiu/uJECqyeUjq6JneWlV4C+SvUcRdQ+GSC2Ox8OQyk3+tMqc4wQXn9UtwJ1cdbZ93sybFA+2kFAuDsY3wsBT/W+Jv4rs/8nExRgxrbq62fhKer93LMTYHwNptS/zLCfUZ6sWqaPNdovLQ6HRddKDuI7RQAPcJWUsIWQtoUr8aa1F9wSMb0YwFu1NjkQWU6pRERyn++oCnwKoLPe6gq5R4KL2oKl+Kpot0oFeZYL3ieXsPiZCwTxKh7zisner4Vn2cWGU93Z+cOq/2y0iZZ69rYUCmoe8gIiMhxSfr2EYRVcs6+JK23GOh6Kl2UUOACXeSBw88iPJU1OcG672HPp62n8PML1yKw7j70HoE6FDyXJxW5hnfRcRwMISjS1m632cc00PEtpZktl8Qu4sTsPf9Dt4MBUGLg5KsI93FjmBzQT6s9GH21u2Xml/j8sNSi2PTEAoofYRBXbEIRkMqFogIfXIiWRFTG5ks9izqsd8Na1KtpCsn/U02f/K4/fk0P4LKliQf3hFC5+3lMb/VBGflgSEVlxCF29YYYtR6q8r4CrYUwiYnsiliIXnzAompYuqkVzlNYbUBPepCD892X0NpaVwxKbew+FnClCBXWrebtTbDBY7wpIe8p7k8isHOFLje4
 8dmTdeI/
 u5sSbHRYKqSIOpthuY4Xep1Zgfp8dhNjqZ5HmfznHcfOMrjfrpsFP9gLvfuiK66xlGcmFooVdX2wug7YImaOc1dh4il0Hto9cV+urJWdsD/RvvgRnUkebRGVA9hn8TdET2KeF75AQsuaUGqU50Zg35sHsfmaPn10Jk6ZcI4MdnAG/a+cH0K1No3U2eDvPMw1UQFir6inh0bf9ejEInEddx9vJcBFZ2Bj+HJC5IXzLl0GCPlgjPNcgpzkJVD/SzJjLmKaMxe3nvqXjowetZykYFn1arTuJgVIZi0hJDGFacD8hCgTRQgRuTJoiH2N5XZhWbX/cIXJPqHTCyFcoCEW+Qgd4+t+RNxMCN1KVG8X6GArVGpJHioEp7PXFuMZ8MmjXht9lH91VQt4zbsOGd1DQXun3bY8UJvvJClllrsqTC6NAOO0U+Xx+CLbjbDW6u9O+izi+IsREDccE7HLvTP2g3p1cfz+Ft1gjZFS0w//zAcGsuBHEo5jKjLDyktvRlBSl5BBdDVO1SbeZs6WCBLVUBpl0U+jGo/HF537gbj0I4GTnGhF1AWBwokkq7Akrrvte8QB9DGo6txRfWcYKHFHYNFKgjOYRyuxMvklPunOx5/4i9n/OEf5VxXEAaflko5Ms0xBsE6M77b36qBAN5cHvwp9ULfvdcfWKUsg5KJozplTeCq/+lcKg3/JGqwsd8tcxlW9CQqIVkK7iQcK7qDZfSKFHqv54ziuIRWApfYydCa4SyiY8PFStD1nQPxOAmj0Qa4MtDBbP3475CxnAasqgaq1EOlnONRCnIQgkETgJTdU+M9DRJVSAGNh5Bwl72VOpUpJJU+DEhcuieUapER2/4hNDczbEx40zJrDdYk8lUjDZUVrQEPZrIPLQLB+kodO8YBxr4Tig6k0n3peooimqQHidF+pO5eN6qUBLK7/YFe8fgcE1a64q0grbPKb6mSSXNTup0P2lzmoOhE2drJUIDMUiV6C7
 oq/PivqL
 PXIlQTXUXZzNRJ+ECQN3EpRJzvY69aPglL8c+BEVTdujx5dPnKPDwdnkHnsYLn+j3s0I1csx9cFMqibqWeSGBsziQDKw0EOBSj6rL0RuXA3jKjSg3CaOyLhsuCfTOsInWwAz2Vjq94QMMp5Noyn3hH5AWNXMvG3CtH1neEa5Ls8Oos9qNo9dQ+/4Ty+ivRrm0Yabw8LJG8tkHGdhz3v/DXKMsKLAoSo+2BNX0nv592PQ4TEyvruTZHXDWK8TXMe6iAarcBXgLyVZdODL2/oLQWubXOdFdOhqhLyjlCNMO4GZ8YkONigY5LZ1mCiJePVH8oawaFsQEV1gRdfzynhLIBm/P9Eq9Em6OSv79TgMRhBA+D7pPTX/WMfB5jGW7x3tvxvaYtH96i8ihQAHUKbWxSsCyp//D4pjQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-02-26 at 14:48 -0500, Chuck Lever wrote:
> On 2/26/26 10:55 AM, Jeff Layton wrote:
> > Update format strings from %ld/%lu to %lld/%llu for i_ino, which is
> > now a u64.
> >=20
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/nfsd/export.c    | 2 +-
> >  fs/nfsd/nfs4state.c | 4 ++--
> >  fs/nfsd/nfsfh.c     | 4 ++--
> >  fs/nfsd/vfs.c       | 2 +-
> >  4 files changed, 6 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
> > index 8fdbba7cad96443d92cc7fdeea6158c4cc681be1..334b63eb966e71e6af6adde=
61aa1123f01b4390b 100644
> > --- a/fs/nfsd/export.c
> > +++ b/fs/nfsd/export.c
> > @@ -1039,7 +1039,7 @@ exp_rootfh(struct net *net, struct auth_domain *c=
lp, char *name,
> >  	}
> >  	inode =3D d_inode(path.dentry);
> > =20
> > -	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%ld)\n",
> > +	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%lld)\n",
> >  		 name, path.dentry, clp->name,
> >  		 inode->i_sb->s_id, inode->i_ino);
> >  	exp =3D exp_parent(cd, clp, &path);
> > diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
> > index 6b9c399b89dfb71a52b9c97f0efe9a1dea0558a6..a569d89ac9123d66bb47e7d=
74c7c98610de21da2 100644
> > --- a/fs/nfsd/nfs4state.c
> > +++ b/fs/nfsd/nfs4state.c
> > @@ -1253,7 +1253,7 @@ static void nfsd4_finalize_deleg_timestamps(struc=
t nfs4_delegation *dp, struct f
> >  	if (ret) {
> >  		struct inode *inode =3D file_inode(f);
> > =20
> > -		pr_notice_ratelimited("nfsd: Unable to update timestamps on inode %0=
2x:%02x:%lu: %d\n",
> > +		pr_notice_ratelimited("nfsd: Unable to update timestamps on inode %0=
2x:%02x:%llu: %d\n",
> >  					MAJOR(inode->i_sb->s_dev),
> >  					MINOR(inode->i_sb->s_dev),
> >  					inode->i_ino, ret);
> > @@ -2888,7 +2888,7 @@ static void nfs4_show_superblock(struct seq_file =
*s, struct nfsd_file *f)
> >  {
> >  	struct inode *inode =3D file_inode(f->nf_file);
> > =20
> > -	seq_printf(s, "superblock: \"%02x:%02x:%ld\"",
> > +	seq_printf(s, "superblock: \"%02x:%02x:%llu\"",
> >  					MAJOR(inode->i_sb->s_dev),
> >  					 MINOR(inode->i_sb->s_dev),
> >  					 inode->i_ino);
> > diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
> > index ed85dd43da18e6d4c4667ff14dc035f2eacff1d6..cfd143b41eb1fb53868f378=
d668905c1c7d5f868 100644
> > --- a/fs/nfsd/nfsfh.c
> > +++ b/fs/nfsd/nfsfh.c
> > @@ -601,9 +601,9 @@ fh_compose(struct svc_fh *fhp, struct svc_export *e=
xp, struct dentry *dentry,
> >  	struct inode * inode =3D d_inode(dentry);
> >  	dev_t ex_dev =3D exp_sb(exp)->s_dev;
> > =20
> > -	dprintk("nfsd: fh_compose(exp %02x:%02x/%ld %pd2, ino=3D%ld)\n",
> > +	dprintk("nfsd: fh_compose(exp %02x:%02x/%lld %pd2, ino=3D%lld)\n",
> >  		MAJOR(ex_dev), MINOR(ex_dev),
> > -		(long) d_inode(exp->ex_path.dentry)->i_ino,
> > +		(long long) d_inode(exp->ex_path.dentry)->i_ino,
> >  		dentry,
> >  		(inode ? inode->i_ino : 0));
> > =20
> > diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> > index c884c3f34afb044ee5cacc962a04a97de2f7fd88..dde09f3734c2844a3fe0b6d=
18d596276a19aa2d1 100644
> > --- a/fs/nfsd/vfs.c
> > +++ b/fs/nfsd/vfs.c
> > @@ -1163,7 +1163,7 @@ nfsd_direct_read(struct svc_rqst *rqstp, struct s=
vc_fh *fhp,
> >  	} else if (unlikely(host_err =3D=3D -EINVAL)) {
> >  		struct inode *inode =3D d_inode(fhp->fh_dentry);
> > =20
> > -		pr_info_ratelimited("nfsd: Direct I/O alignment failure on %s/%ld\n"=
,
> > +		pr_info_ratelimited("nfsd: Direct I/O alignment failure on %s/%lld\n=
",
> >  				    inode->i_sb->s_id, inode->i_ino);
> >  		host_err =3D -ESERVERFAULT;
> >  	}
> >=20
>=20
> Suggestion: Let's use the %llu format specifier consistently for
> inode->i_ino, which is unsigned.
>=20
> Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
>=20

Good plan. I'll have claude do a pass for that in the next set.
--=20
Jeff Layton <jlayton@kernel.org>

