Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53485FD9E1B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 22:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5116B014E; Thu, 26 Feb 2026 17:56:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6525E6B0154; Thu, 26 Feb 2026 17:56:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD7E6B0165; Thu, 26 Feb 2026 17:56:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34C456B014E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:56:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB10E140214
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:56:45 +0000 (UTC)
X-FDA: 84488119170.18.C733184
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 30BB740010
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:56:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ln4pWb9Z;
	spf=pass (imf07.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772146604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QKjw2490skdA7I90PoNooqy2Z5vbbaG3ix+lcITPfE4=;
	b=SflQfT8NI9v8DBNby1BxEdYFBMskz8IvL+wsszHFUGzF/nrxKuFxQefTAHyrhk440URP3+
	f3qbmD+sVweXXZHsRCH1Svc+Atlg98vHQcfTwGr/FYwdYU4OH6ObBNvuXUHJWCNpDXrJDv
	XXYj9nzOckY8Av+dgRfISOuET4ctT08=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ln4pWb9Z;
	spf=pass (imf07.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772146604; a=rsa-sha256;
	cv=none;
	b=hrPurbnCFmYU3RjGGOHXh3g0WTpDwfMlOcri7/W4gmoO3IM0M+iIU97FpN2wk1JFVePH+2
	6mb0rksuqzSCjIdpa8CnyVr8WKE/56/RQewqBoTE27mtinEC15fOArEv+HGyvr0vkRWtY+
	H97O7iuyCJqnm6gGuhQYebAzmI9jBec=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E46C60103;
	Thu, 26 Feb 2026 22:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E473EC116C6;
	Thu, 26 Feb 2026 22:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772146602;
	bh=ElkHN/R2fcBT5rLZGFbsSk4BZBEcI1Z5rkz7cnL9q58=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ln4pWb9ZIa3iii1vd5gskrCoKmm1t9tEjYVEd5fbke5FD8fPQDsw2mkbqPb5Bnw+S
	 z3+EiWtdlhrUEY/TzIpfb4TaDwuEYYePiDKvB2OL6xLfeGklpk4bZ6oZPa7zFemslG
	 rGqmK29WoeRiHAvoCn9ydRfTOnwb3b8GUvcCmKy2jWa2lV07OB5alxRd6yvLlYu4sb
	 GaIsxiVCRS8rqhZm6xuDYkrjN+izm2sJOCaV0gENsM1vxdjD6EFWvjkPYxW+Mk0ppk
	 CgdPwGLujPkowNzYZB2g8SKWMopeLJvORgQ3TQwNfrH9FkU9y/THXIshdB3DErq5Vf
	 e80DkaSCt9oCA==
Message-ID: <044291bc-9841-44fe-813e-c50772962f09@kernel.org>
Date: Fri, 27 Feb 2026 07:56:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/61] vfs: widen inode hash/lookup functions to u64
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
 Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Bharath SM
 <bharathsm@microsoft.com>, Alexander Aring <alex.aring@gmail.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Sterba <dsterba@suse.com>, Marc Dionne <marc.dionne@auristor.com>,
 Ian Kent <raven@themaw.net>, Luis de Bethencourt <luisbg@kernel.org>,
 Salah Triki <salah.triki@gmail.com>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
 Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
 Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Yangtao Li <frank.li@vivo.com>,
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
 David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>,
 Dave Kleikamp <shaggy@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall
 <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
 Zhihao Cheng <chengzhihao1@huawei.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>,
 John Johansen <john.johansen@canonical.com>, Paul Moore
 <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Roberto Sassu <roberto.sassu@huawei.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Martin Schiller <ms@dev.tdt.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
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
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-1-ccceff366db9@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260226-iino-u64-v1-1-ccceff366db9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7qoq1jxcfwpqy3y8cpyz84htadp1e1hw
X-Rspam-User: 
X-Rspamd-Queue-Id: 30BB740010
X-Rspamd-Server: rspam04
X-HE-Tag: 1772146604-298506
X-HE-Meta: U2FsdGVkX19dfSkxVV06BglrMgeTDjoTc70LsxXaD33JC9iYsf669rw2nOd4jG3Dtqd/g1ZPl7zpRB7s/SCkq2YiWiMAFppCxVP3Zurov37A5SFpuqBIv+oZvvlPXEy8kriLRlkIzcC5Aq3bW3lmf9yde+ZBE5LOTtyMVt9u5XsMxHWrCHn53zR2eBrlbECkhQGWrEZld6+eqyvR57zxUgQbd8L3WIUB8qUZwGxuuJjuQ8j66vqMdb+tLerccd4NxvQvOrBs97qATfyNbWe/717iDvNHmo816VYIEUVnF/MItEdrB75AYviLL2WX2PcEMeLfTz3nqqqbpRLAjqPuYstBZM9U55Z5kBhQ1uE1Siq89Sm74B6f3EAYCSt3mQgMc9r9NImI2c5IT4LFVEf4cLnGRjlKoHQMXnb7Ok+1/DNbNg31YbQU2qXmiuVBd9JlbKLFnzX2l3q63kWutFamBtwUSYAmR7Q0h/CL5Qqh6jGmi6vSgRdeJNxHvwtY6E5FBqwWP1py++uhPlKZ1Kt62WDAQK5knph5ZzHmvC3YBmx8jycG6Jo8nY6c4SgvV2aSEel6G8c3Lit1cMpYj1Er6TCejHRRsDXvaxD8/tJPLKo+cnV79LNA0AticwfTrm7Smy+rHaAwThOo7Kh+8rRGoWZD6CgKcSHDk+PXkTdzXFo3+RBwH1WgJd5I60wEC9/BWCFXiVUzgnMoWiLv1Zt2FMzkDrlz2v+GVAN9q8tbgiTN13f3buwuPwwBrpsczsMtmQtUGwY4uzH8cf5RiEAwuczYj6OsGi25kltpT2r6/sJBpF1mwtmIyVRZqhL40L+pTlN7WDgGBvDujXm115Y10f43DsrXnURFob99zv+YyRDw2bX0hag48FAuWxJ+oQqK4RKqvC45Vk9Z0l5MO6cvWe+CUhoOEFNBDQ+4W+HQzRGOOsd3BUhsj8WuNZgioP9tL0A/mzoSCkJtS2njwKJ
 oN3Z0bYl
 ls5tBQk9Ngql1v09EFb/myVQDKoLqco96pGr08VSBZj5EB5z8y2Lxdubt2vFZ7wjEf6nTDqQfSHPilp8TI/gG25ioJe7fimefqH6h+8YtIeNBbXXfBabIajtlBeU6WXVrU5yK0amMppEoanX4jlaOf/EXPgnW2UE7Kx5PVOtpVjIFJHAiIFAdQcy2gHVrtGMq6VCUtN0RftaN8m6OjtCGB9cw+LJONzJli38anoVmE/K+8/y3+cI0H/6FiOie42RWSBbA9APbi0XZLik7PkLM8o3SUW6ofjzm3hc1dg05MnLdjG2aywE7Z9mDXxSaTY2GZbaxn3B0C5M5An8JOvN/fqYtgqeQAN2S12S5WZxlOt8O+eGecpBe7ncEVlPR7+i8yvXTf6kkIQiypm1dqb9l78W35b4xDb9dmisKtXG6EO+8ucu/4++AKV8M7ozrkS+JBMlgHAGnJf6Y680c0E2B8LYOMJ+y80Mr9Ha6lxVEfQSNFdYhN/5igWHR8R+vzkkk8SpKvCfxUHsEOUkoKCnXm4iG1YzvFVN+4095lp5PvwJn8xRmQjOfOpwe4p7w7V1K0Y9YDAhjYr3luzMXYD8jhc8BILYzV8ympqNb+w/EtHqqLibPx+opiXEPMEdkrFUbTXARge1/JD+WBi+EV3xPZAG1h7RNZyMiYBwyUPD+02ZWqAFSwGqco0B/0KOUGZbbnb2CyUxouxRD3l2CZmv2/Ct7zDfD4q4tE4i8QzXHnfhsyairPQjKPYWyomdVkTnMxuewNDLQee9SZn4J+yRRBRRt7pKdqy4csJ0kATpK73ldbWYA/HwHNYFENfHjW7w9qPN6a3WdNLYl6OVoigGoaX1EYsUg6S3tKU2Yh4osdOG58EWSgdduq0m3yztNf3wIvPgFJugFCgBZq0dHTp4V4AQPyY3Fr7L3Ue+LmJ7U8UW7B3V0mqQpC6H84IEYUHQJsSJVCwJ7Dju3GWaZCpld4LdGC0ql
 ksIh54l2
 Mzk7PnJ3UegOi4lG0JMdfrq46trs2Yy1Tx2V/eIYh2TTma8TrSyvrD6RcI/avwgrE3T+Dn4UO8yHVnbw/5Zl1XczPLFPeXluUv+uZxlKVxc/3oAwIdwuR2KSoOb0Eav2XSNFWhAolSHqMKPxf742E6sMDFMCz9Kz4ez+3VKRK+ElWdbOuqsT8YZnXYfkl8IzWwcaE3UEAB86anXJMPbbru50goDwzYV6RKwTh00MaiHDLoyDyDZ/FnIRev0ibmTPS0Cr+HmtpJuQQDoGTY4iC18SlhDDFvxu3CDflnYM4DtaUD1AvcCKCDL51LZMze285ydvLvw7CqwVPkCEOqZ9CHFWG3lCY9nqLsam7JoQNGEctWKP66nzRAqf7QmaYaKSuvO9a2K33sKshuy+Hy8wmVQimeu79O87Tsph99/oFeKkI8d/mPLYR7O6/1QlsG0ZbyrrnboXoWzuDp4li22j8EmAExYfmIbW/Cf93Mk0KcPE2dpoIuNXvr1wTdiUu7eRFEjtFZsU5rlwq8nEesmJ302fQxULrspCzgnjRbVuHhWqyjLReduU3gb1Ka+zT6MzM8v42JHUtCm3UOn8vOQTwwa5dzncNql5GaN7tkyWw25itQe20tjTaByx4eB64aqOmvQsZBGs+2ZG2+tjmg6aRPULo0V2Ii+ps41rRPTJHSOThPaW3yOrfCsVZ4pKnNOKK4pRxC5g21lfRVaUKzUbT0HhGOiDVqbr5D99khzyQG0zFcNPlXZmpz18JvaYSa+7Zwgqtno9O+se17jwLqItIS7eKIZMUOFnagJM1qdh8/1/xzWJFX9Y50+9dL+hLNF4nnvEiQxxAB3qiE3Ne/jAgHwml4oo6ojNP2kvX5kXgFVEPlkUUmevW/orZIoeT0DDUn3qbIyWzaunVVWrFYGWX5BbtZPsozYN45eW+X6SXUcYuSY1lNm5hK+TFGnuofl9qFAwFZpQ+z+gEGAL7PCj06VdmUnF3
 dVnWVu8F
 WHEM4Gn+50BgdsiR3eZSmhbWpyHAuhp+KqmjHF0K0D+OlsIdbaUcNSbxkiBSjUKnc+IQe+F7cEzlyVPu17FTBMQy9J4AJ/9+FJJtD7ih+9uwCWo1qtbeF9nWjBZmLY4xqaEDXLP/20qebav3XpWYl5Lt9vKcgkiGIYY5VGdLF9bPfY8VLe5fTuoAGW37PvRosJihZOya8eFL4mtHduiGEoWNSOA6Bw9bqyjcgyvZyaOw7+/TqkfOxnEz+C0VUMO71kSYmBUoxeI0X4Oryq5d7ldhy7VT8olIQ6osYReLJ47DYX7vDr2AMB+5rjVa9jA6bjZqAaOzUFbpi82H2UH1KRjhbPCqDpjFUBwmeaUq4atwlP0r3zb7XkMUOipAMSht2sn7D8UB0TPwpQHWO0VmSw3mGKZKcau7/C3ZODmNphBJsugupuxP/LHeoawmGD52Q1h6fnu6qmKsv1pPIa6jGuJkCyjm8rdu8PxbXI1tjMiqvk5F3zFWu5gVJH/VfgXWNE9Kced/qU7bV88Dx1SIxadTEN4ej+bIXMKFnR3vpqZLahuSDXBJfmZaa3YBQLPVyI5xIzIJvMo/eY8ZVq7DI55AYT60VblxQKTXhk7/D2ZACv3NzNF/qES6sICsuVL0XHlNtsz/HP+XKKtTCc3R/sRpcJcyCNMZgYvIcvUI6iB9L/ecb8p9XpFv+xknvJSMlyxXWLo+92xkrboAoSu30svGgqfi7IKqwvYBm5g7gW2EGF3XQIbrc5O8XgZZ11MpFQf5ikLOZfhnT1F+iIwkdyVxzGqk4xMeUXnK8Y+jhdcPsaTvBiMMkTZsM67HNxzPW03fkMBIURESZVnV8RHnsQRjGI0mBY70I+yLTcj0a0g2Xh80C2gXhO1+a7r3q/BQO7nRax4jSNDqSbz7uGljZjONScklfr9Ty4M/REoV8wM75xCG4Mc5QU948n9aP3HK6e/0B6Sa7rgHXSkfj4OIrmmsi5Lb/
 bjCWmp/u
 JvRZ/Ru1/yEl75nQBucknJ/bvWR4z8dO9Zi3oaYo1KAlukznZyCdATVPwx2oDvVAEdMOcoHNn0lAjwH49jdLvuecUYhKFOCqQsoukYQ0lbY7ecr3tcMiMra9xyrAniO8M1/aRpRqsxGibIC0H2FrFu8gM2RLJf8LAqjM+QCGK6e1uE8+EJPmIQfPZcKGvyAGIqHm9TYrWve3beBlwWEvxvLHIGYhH1Vf1YgVb5dH84WfRqu0zChlxQmFLPwe6R+ODUdSOvDu6rD7XCzRQ1sKh9LjPCN8rMyPf1uzuOzpdoHpvu5/92tWCgkqR2UXNc2kF1LJXXl97E4+KnEjvu9w/wdWF+lA4vICZB7KAp4XgN070d085ZhW7ElwHFX+EJTTSr/uHLUCL8zSGKxhxrKVgne3r4jtINzt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 00:55, Jeff Layton wrote:
> Change the inode hash/lookup VFS API functions to accept u64 parameters
> instead of unsigned long for inode numbers and hash values. This is
> preparation for widening i_ino itself to u64, which will allow
> filesystems to store full 64-bit inode numbers on 32-bit architectures.
> 
> Since unsigned long implicitly widens to u64 on all architectures, this
> change is backward-compatible with all existing callers.
> 
> Functions updated:
>   - hash(), find_inode_fast(), find_inode_by_ino_rcu(), test_inode_iunique()
>   - __insert_inode_hash(), iget_locked(), iget5_locked(), iget5_locked_rcu()
>   - ilookup(), ilookup5(), ilookup5_nowait()
>   - find_inode_nowait(), find_inode_rcu()
>   - inode_insert5(), insert_inode_locked4()
>   - insert_inode_locked() (local variable)
>   - dump_mapping() (local variable and format string)
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

[...]

> -int insert_inode_locked4(struct inode *inode, unsigned long hashval,
> +int insert_inode_locked4(struct inode *inode, u64 hashval,
>  		int (*test)(struct inode *, void *), void *data)
>  {
>  	struct inode *old;
> @@ -2642,7 +2642,7 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
>  		break;
>  	default:
>  		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o) for"
> -				  " inode %s:%lu\n", mode, inode->i_sb->s_id,
> +				  " inode %s:%llu\n", mode, inode->i_sb->s_id,

Hmmm. the type of ino in struct inode is changed in patch 2, not this patch. So
this feels incorrect. Why not just squash patch 2 in here ?

While at it, maybe you could change this to use pr_debug() too ?

-- 
Damien Le Moal
Western Digital Research

