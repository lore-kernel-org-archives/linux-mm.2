Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1518FFD8FD0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7655E6B012D; Thu, 26 Feb 2026 11:05:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739F56B012F; Thu, 26 Feb 2026 11:05:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB906B0130; Thu, 26 Feb 2026 11:05:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3B66B012D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:05:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DFE98140302
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:05:56 +0000 (UTC)
X-FDA: 84487083912.21.D430EDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 075BFA0016
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:05:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TeEU7zeU;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=632Oc+/xQ9ATwp0eW/zLiAhkamlJnV+MujUlnjodaZI=;
	b=U7RVsOYTMhiLl70t40Us02LsIuagrRnxJj9LfBs5f6nTUvjMuzavVxQXYDRA09cXa7JDBa
	gphYbXtEE37sLAsRWAsQt9ljX8+ibpd7z5iyd97xfylyXv+YmmicLffYKbu1ztIjyrD7u3
	t/aV+Y3+VMqwd3BoRdS3lrIETAC6Kuo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TeEU7zeU;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121955; a=rsa-sha256;
	cv=none;
	b=vZ1GtVjpVgEnQwJDxB700U60KaSdVaJwPr4Y0L65Hpi57uGFSIHOubBna8WWYuvhERbkjg
	oCLVENbcu6eeIabnXtrdqpSWHE3iyu8qzGb6VJV/Fh519ya1UYTW12nEHlw2WfHqjwz3Qi
	9f7tV+sQCvyH+ZzsLUH0tRKJ42JkT98=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E8F3B418AA;
	Thu, 26 Feb 2026 16:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B825C2BCB0;
	Thu, 26 Feb 2026 16:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121953;
	bh=NT9GoCKrhJHxzJaFVzYs+iwgpSzcQsNFzrkjPRxmI4A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TeEU7zeUNxSpMMkN46e9L3j3aOlE0vDkwCXGq1PJj/CHTmYVutZnXL5F8MKin4JrP
	 A2G7qUafg3ehXB/Blk5az8FIg9TANb7MNemEsXrYya0b5Fvst66jtyIF6YUJ7v27VK
	 z3EYy1wCaHSO5b901ZxcnOkCEAbffwTCLfaayIvm7hBm7inmuRzrEp8G8PGlf7TbUl
	 iQJDbzU/9ZKHv9IW/GHirGk7LZ1m1u23z3/nlVfBjjNaKKqYUxY3x72+ZQPhCC4a0+
	 ObSwwws+YwOg9yQP55KRghBkVnGX8DhzzxIwaxbgZGpifL5ay0WcCfXOGZzl3mHLfb
	 GCRq348a4qFaQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:48 -0500
Subject: [PATCH 46/61] qnx6: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-46-ccceff366db9@kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
In-Reply-To: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Matthew Wilcox <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>, 
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
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>, 
 Alexander Aring <alex.aring@gmail.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
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
 Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, 
 Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>, 
 Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Ondrej Mosnacek <omosnace@redhat.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>, 
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
 linux-x25@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=757; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=NT9GoCKrhJHxzJaFVzYs+iwgpSzcQsNFzrkjPRxmI4A=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0PPx4vgLzFRyqyCgx4J34+XZiyaw/sSPdij
 GSRivfac1mJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDwAKCRAADmhBGVaC
 FbT2D/9FjLqJOuCZ/iHUB6fXfFS0PRvj7GjtXh3TEl7mBaBqwoKn2tiJVhj8uIoLDInua9zDarS
 kj49CPCKVHUju5nyjzd4AYbAyvz+bLNRXpkiv+wwBafITWWLDAUBYHd3khfRwC7Zf2/GsbtOqra
 G0PjEIwc+ggLzHWlwJkaatzkAnwHg5mOg4skMPzKOTrAesBH0B/ud00dXWV41oUIPXO/zVBKa5j
 HlgW2VN0KHdXbenXBNwgZCva8rq2Yk0gvoe4F+hxSCKC6jVrstMcij8oTQRe4XdYBLW6j93GZ1l
 Bz+pZzyG/BEAqMQlDpq02p1pUK3Iq8wVtspVp+kenzKWBcRFzQzrgTze7VnpKUlLX/zqVduXx5+
 I31MduvitvhgUpJGk5SMbjgZhl650TRGucqbdCl51NzVhjfbT2ynMIyUE9lydocd6jRa34VJ4lV
 8HsbsnPB7bZvLUBGy9FSb03giKnQ5Af6PWhWgr/PZU63A9s3GhqIyla4lD3Bv/7vZ3poxaSpFb0
 UZOZoc19F0oKz49lInvML8oh0Zc+DLugGv49Fg2/DhdKc/ZNcLda4sZOipoNBhNkB5PhTVKOi1M
 Undibt3NU51UZyvlBAQGdE+ZbWo/s/gnPJPNhUQcUFSn86PjjdYzZ1wCSODoogl3UhmOdIQbV9R
 R0VSmXPaEkSynww==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: b4xa8pks3b15ka731oeii4cwzdnz7ekm
X-Rspam-User: 
X-Rspamd-Queue-Id: 075BFA0016
X-Rspamd-Server: rspam01
X-HE-Tag: 1772121954-168208
X-HE-Meta: U2FsdGVkX1+/7DEF4NOjy9fxohhiHl+W5WbC8W9uzvtjXaW/HNv2AnR6vjGVm3u1fWl9gXurxHVyqHzGBMPQFktDSCM5vYEqamJLXYyNh+NgiF9OdfMLosC5ELkXWLnYc4dQWLoQ4jyduHF4Cl7MWbI1hA2EW/obCzs/zBhZNF3OjHBvgB79+FAF+fD7mx5cTt+iQsio6VbP4L0ihFVlpdmbx/b7POKA1ylHAmPua2e75RKkJuyZx5cuaiXxRDLi+2XLHzxi2ULhKvh5hPXhFcyr12n+/9UYAkey2Q14DzI4B12+TU584OFQBOlHiMACCWB8avlTA2CLxdLczymMU4W7wrJ2xs+mrKdeHSx23h12gPahSQ79wOn7gQpAQ5Ga7ZcsYVJVhMQ9tTGDzYomjk5bcFP3ChrcrMJJEulcApk0JtvnP/INXNdC/6gHLd/1SrIGg8MVv11NsXUS/BVTO4wD7R7+xYjX/sjbfEUeVq/r3ukuP+aW8w+IWXdgeOo2D1Z1ZOOGjB8I0jD98hOSieRksK+oTqqoTUz7kMvMDAHXuXCQUriTFV7lTBDR+sFQKXFQwX7DhNmxwOgEGgHko9rRnEmNUH/r+lIuw4Mvkmf46dA0nfWG/FFuFB+xaKWxzYQmr16I00GSEnBGaRXZNvrTVOzB54kgEmdzi+o1WuY4fVx5RbM9VlmVybB9BcYasXj7Q64uBfLRUnZV/S/JI8cPUtFpJrbzd79TB2fyGwFiLLJxgXcxpbjvc4p7r3s5a90NVD+F1CPClvo3M9KAPC/Voat5Qsego/sGbt1iNGvmdI8Ic2R/AWth1mHGFQvFVqiPTA17AQpBlZVKk45AOQ1jOS8UwHVGzCbFm9murtiYV5VzF1LFxhG2+jssTH4R6W+El/3PFyWq17hCt7KN0FXwyp9QnHSFt+pASX1mONcjrhVEAwMQOawarF7geDQFWzqe7He49aWl11PjOdx
 Ykz1S+tA
 RdWH5eVJICQGvMDa2idBB2hmJ7gMJ+jJIu2iVQ+bkSZaGlhupeUSXxPnCnHMZjf4hkUEGwSvsSNU8GD5YPvskaoGfrpEc/hC2cXG8lV2aqka4zvsBazuzyzgxFj7+mOETEQDTwajGKGV5sqbGx55MOOsbVoLvqxn3Gft48F1xLicdWUgIyxHelvQrjJUqlVVXzhNt6qu38WfKu+KJEfj4ptx82iRaDEMGg43CxsCwieBmbr2vH0KFYlFfYzl32SIlL6ND+eruWGxh/cs5M9KdTIljxHKnRJfekzN0Cb8bUiRyp5NygvRWDBc6AVRwudoT6qpCj0igFyzwxt5i3KEpoX8NQn8Webmgr5c9lrIkek5srXOMrG1GWpZ/n39J3eZVkLnEtGOSpAZztMhInB4ZDu+1TOxD0q9jRercKj1MWtczVrC2ITPQBu7aDaxzbx9e8FocVAp3W2/lvNFPazZXMwq/nDEDvwHH6BSoyFgFVpQR95G0AARcBavMmiTnxKKefFvAUuk3KxAd5B1XU79pNAQEGRY933ovLcSxrWgVTfv29ADxvIh6/4BzGLfNxiyY2HxPmAd5cRG7OEMx0ftxIz7gW3Jp8K13b7GWbApAccZ9QBF3BRCCTP+A/1fcj+tGinjSVrOklgIl5aRDiY8AY3zo0qAFXIam9nkgpPlc62gkshUg6SODCM+r0Snz+5tvzs+B9xAj/wXBGS76EbXUf3QhToON/sStVtToFt9Krur3SmVp5dKQCe64RMUgORN+rmQPLgJpEWEAsvN/g8BL8Gibtz4pHfUaD8WwYovebEGiQLPwHHOYFF3bvO/J7g6HmvJ/p24eEH/YT8+1YAxAT7SPiJknZ+4L0w7ZpyufFQQOgMN718piPvCgPuqJzj6+9JrKvSrGpq0URerF+WMwe6aqTRTto5N7kZ1vFp2eklRonRcXnk2uOG3c1FzdKrZiEwXOZ4RoBRcoGxQsBLE/xBoBCPUQ
 2AyFDk1+
 297X+l85/AuhCggCNer0zrhRTuWVuweIQb+LpSNdm0xRdF/jy7NDE3rlZWsRnsGMTykndWlpefzYGFxjNeIvmIoz5URNyvIrT2tDQCSgkRNqfuKXltITB3k5cxDIDHYTQixDGj+nJ6lgnMzkXaQfp8KpuYw8ZUyu9xYQuqkUb54MDLrD/D7xB08ThrflJRo0xY52zyEbmkAJIuuP24Fumm3Ms3GsuHEd1fsgxeC3HGkWYPdCY8RHkCo6HkHGu0l1AHlkPvCoZAuleVDZnOb33ytabIv5COhDa89CjlsZRjWkGvfBJvyOaXAlMADzrgKWREyVUQRjHF16/JWPkE2vjfGt4YgAtt+MNpCGS8+QWlhBOqBV79KM5bY+4QUsOMuEQhI3UDtPmQI1AvTwxnjfCVRAZhp683m2C1pE4C3upF43r0VB0xiUAP3UgIhUwJhRfHz1np6m//FRpdOrQc70Ab2CyoPs5XjIL+JN8ENVpxAhHLIxqXsuo5q+9dNJ+oY/3me480p3PBLytx8CCl71vdJtBwXCuF4FV+LBHmGT8RohaNwR4fNSsIIL2R9waQDThoM4oASk3n/5Gyq7xPBZW4wiUUslTQWEzfjmK2seJ3T+7h87ub1PlNTVO5wvWl3qncREqEWp8hPEt9E26i/U+F1WoaT38AdyEAekQo6m5NTz2nDjivL9SP9vWD8T/h5VAKcS/rozbhXZE2W2ubtJKGI0MOe+JnV7+MLyAq9dKbpTRfTshdfUwAajDI3dS+plwN+Mw3BRiGxuv5PsbgBqmWUCl8KDCwwH9TH1dQK0VK6OyJ9AicQznLdTr4to/TJzkS9kVATpz9p2qVnFUUb3Ec76XmEvkcylqSBWEuv/FuTnJs2RM/rVgr7GaWTj5abeLOB5Mm2seHyMLVNTH9Z6uflgCgyw6XVmUWPrDpTu9YiOqJk8YXCVSz2mNAnyMXd7ZMZitssK+48Bl9g+D6Wnb4j+OMHXP
 seoL9EPp
 MlMahrlcezBV1WM+Rj/pDaoBeUFQsH4R8ww444Y/lBxEeXEQ+JmEoO1rwYEYJ+VAKThV0BoewENg4tsWmduJyPHmciNbz4LsRRef3cKcTpHKYLaqwdBM1i7Y1xke+zmxrP5dv9ehSTroMpACiUYwKCe9caSwSOAFEJHY08iKC5A9uv6pCrGWwgvJEMCKMN6lr6iGOEWgP+SNib2ysUScYNR55+mUK94rI0i3QizL09omADV+HszqOq7ynql/bnpJlZSzH+W24DK2+0umJg9v1SfooGaC2iiilHMxZuKc3jJfsdAesRtrdWmO2RwjiTmOPXlD9AzrNDhjWrGLC3fci0/ZoKH2/kxxeVvNhxG73S0ga8J3VTxbM3C62FrRK7z8cXZorPJGsCDiskeKOXC+jgdMaP4DecFFjKBcHz8pgOswJ4GaFXKFBtMd0QNzzt2BlPSycPX5bHxpt+sMIWWAu52wirfaQTchnntVrOIPHEAVjPPqZiPXK1QIsZTogBvNQ36cIBKSVY3iUBIZHswXa0lJxcuw1dVf9JbYUCD8Bwiom8RiYjOZaRnBoe4hfN2Cu0yKyjuqElMQLEZ4hVy7YA9qoX9XzM8wAp67sr06YnphZ57jjv4hObQP92flXrG5oasHwiKZs8CbkTxxFTJQLo2LrebKxRtSbEI2thiDGouJeMzSDbrdpaoyCzHheeEjnaG81sKUplIl3Lif4Y6qSzQxt2ZjpBT60EKw16miOZ7QbBuJNOIigbA7aVcoVloZebLHkzOyUex74Re2tdf+68cFZ6bfJhsr63lo8rdXSwa8TiZru1i9dG8jcsaNlRE5E1/4vRcNADfZmtSggG0KYeDn+xqBOYTcDcWpNyslcjyG0xlv41bXuoR1nsbPwmQiz9nX7HY+r8yBha10pzveXTQiFFEW91vWYL7IGUfXkcfCOfn5Izw8AYhHunOHiEm2g2ADllwv81nm7dPxPnm4Vm0uLIs9+
 1ZyaTsZc
 pQgNdD8ctos1NVy/veNZylgqYUFy5ELIjqIyaHQYVVFUwXbgtt4/sam+00mREJua9RIAo51oPyZF+Wnn9DJ/es07OP7rot8AcrsTRvA035fMXalnlRYA55P1VJ4PWw/sMjPpObJhc0znEUrwBe0WrgE/XjetqeKlJzI2nMBZIYu5kOWpiNELcH0u2rZExTn6NHUwOCtVd/PB+Eu6mOAF6OjcPl/bMt4ciwHsC2KbL7a+KsK0UrZZRpcjEt+lj7th9tPVGf9urOc45ERorDdlgy/bnmQl+kXFcWknTj0AkS/oucQqWOv0QV2ai2oJAVqaag/5zV51WvMxdEPGau2XmDU1ZeFkUtoZ6DpBA+Vv8DJxSP869zXM+JL+Tk3uO1ZKZ4cCVt15Mt1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in qnx6 for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/qnx6/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index c4049bb8bd60d47f9edd3d724a5d5be6b5deb5ee..73c9c456ecdfcbecee677877e9b1d5dc65071d43 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -75,7 +75,7 @@ static int qnx6_get_block(struct inode *inode, sector_t iblock,
 {
 	unsigned phys;
 
-	pr_debug("qnx6_get_block inode=[%ld] iblock=[%ld]\n",
+	pr_debug("qnx6_get_block inode=[%lld] iblock=[%ld]\n",
 		 inode->i_ino, (unsigned long)iblock);
 
 	phys = qnx6_block_map(inode, iblock);

-- 
2.53.0


