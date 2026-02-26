Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E53E8FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E396B0149; Thu, 26 Feb 2026 11:08:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402506B014B; Thu, 26 Feb 2026 11:08:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA2D6B014C; Thu, 26 Feb 2026 11:08:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12EC86B0149
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:08:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DFDD61C2B3
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:08:38 +0000 (UTC)
X-FDA: 84487090716.15.FFAD2AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 155C1C0009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:08:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t0Vv/8r7";
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iaw7Yzoe+sn/wR22JLcBiF1LrSzLSZpM6YnZvP/2HbU=;
	b=6x7gA73r3V2PbrKg26aDPbOlaK4WmAjd3dXcLdTuAHE3+g0EONw9vsNVsK4tfgbKJUSCd/
	c39jkU/GX+YjmzCuso1h5Tw7A6uiD/FXAHw3V5t6iCgA2Cqv2bWgkKYhLWdlV2L2o5ljWK
	h0LAqobCjpBqWUKtrMomnayruhR9rK8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t0Vv/8r7";
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122117; a=rsa-sha256;
	cv=none;
	b=wJ8WFW1R+iuQQrIByVYfiSIR9UWOq5q+J0exEOBYe8VoKBoG9YfGp3ot0QEhMaIAOb9MaS
	I30Ou2RZpogXPpnTFxoKzX4sO0oNoAKwEPYz4nXI8MJPl8WCyiEOvm2hG+C810pxw9UvPv
	w6yrEm13uC2atgNPZ8jdMOjAqi7KdEs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 294954048F;
	Thu, 26 Feb 2026 16:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02FEC19423;
	Thu, 26 Feb 2026 16:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122116;
	bh=mJz0eEHEaRbf0z67WFaaYbKMrUAzDbjOomm21BzaG1w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=t0Vv/8r7hvTEyyrgpQEos+lyQHw8VuPB+RKx+RgG1btJBNaNAxEkO+60lW6HbyPby
	 lHSflQP1RDVfk8I83JhIewxB80P6D7EcglTFUB/NZenAdVCdLaEuesq/G3oHdy4Ase
	 QfDdy4jDvQ29V9tOsfw8Nu4t8CIhI0KsVuJVltcrjRL/2YMFWZQ4LrLBsZy5i7ta+w
	 gwyT7GdMLiGYkFsO8ihc5ehJvozLKUp+Hv3sU3WCp+lsij1NBAqgspLMxoEqqFwPqR
	 JZHdXQQN18uOq1UCy5pC3jx+yHPhdfRzmomqq/fjlBEW6XdhnADZZ673SDFrJPxa0p
	 45Mc6++8Tu9jw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:56:01 -0500
Subject: [PATCH 59/61] iomap: update format string for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-59-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=872; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=mJz0eEHEaRbf0z67WFaaYbKMrUAzDbjOomm21BzaG1w=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0TpQY7eovVW3Aydx7V0aRSrqmhzKyz82kFg
 yDGXy932HWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtEwAKCRAADmhBGVaC
 FcA4D/44LMTaI1yNGSRMRxeUlEYsH2ArWGWr0IQXM4Qdw1OnUTPSbH/n3gZo+wcSet5Gzug02cO
 jcXlMnvYWM3OVTF6i18cUaqSFTbugS4UAO9Mk+Lke+sy9yUakMTo7FNfkQ+f/sk398/6/5szQVZ
 MUy4ewI2nXzMwq5afGcOoIDLVZixL+oLOl6QLfvgpnWK3/gNoES2uh72pEVkjSgdQZnY+UKaqd4
 7n0ARSW3OCvonRlusw3OlE79ed7NBP4olnKzZba6tqeYjtcCyWaVmxYVBa6j0M57j7pvxZ96OJc
 7a2Fq44zHEF9dtwJewVlFtThajHSJrr92jbICM7uR/B7Hz7EyYD0LhmcdLaepe4FdL25GRmPCOe
 XSX9mfjHvfnq1Y3wE+Pb0DVhA2WocfUKncSNil3vb8yI55n2CEtXvfPsoyJ9pqpS5rCTgqukoqt
 sZQBQhXYqPb1/AxxjHtM8qeoVyjkFaZRJPDW3Hw1TtxR0fq/K7+zgUPffxE9ni16UTo4q/ZqxRi
 rDVEotes7qKCDtvl4VFlr7CLGXtrsZVu/xWV1Uod99oci9bsUb+js1G5WQByBvq8VuRRCwdGhG0
 YRSpXvriSFf8pG8NEGkkkH+DddjxU9ZbrxdudoSGdU+UaRLNBLKM1dRSqJOjxl5oAYK15lrk5NB
 wtLloV9zJaVgRTg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 155C1C0009
X-Rspamd-Server: rspam02
X-Stat-Signature: efkg5e7obkxie8611ntpbbgebosjxat4
X-HE-Tag: 1772122116-630050
X-HE-Meta: U2FsdGVkX19GymJGL8fONTfcONF3w7vMxHaiH2XRW/aXMNsB9v/OBa+op80XHEj2qD/v4wIPETr7yDyM2Fe+bGZl9P+n6ncSq53d5nhe3XGqb4C1jxj4vVuh9CMd21RPhf3ohY/3RTqFIM3upXzRUN9O3jnt/NEfKry323z5cNhU1WgNQN33OByZvxMXpo1H59379+G8lZZWnZagvE4L/6bal/XQxpYU8MAOBsCaCZYlCpmKY9ciCaoZFnGCw8Pi5DnBY0B24c4qKep8UWOa6BsIbNQOLtwnOYVHggsZ9q8RAawFyfzjJ5R9inzEX5p97uOB4k91YY/K6qVhrXnI1yORq27pM9Cwl0EIopAXrjgcmuVnsn+rvMSBdVC0FO+FhuHVzg+gTEpefy1z4MMjibtqc99Wszl9533Ht8/AeJBojwcJP9z8S6/XR2RncWANnhpNucy+na/oAWGiICefycFQtv2LZuFh0WKYKUp4AA0JjcYTtzQrjyoQvtGFdsM7WKYZDUbSlWC1hH9C1Tezjg9LZGG7sTbDI949lVaEq9Q1JWXL/yG01iIHDJMFDEOB7rVjhFZY9G3WIsldAeQ7F0m9cW059DdEXXXbhv4e75FFYZVVqK9B9EjVj/7NYCLFHmdZe8Fsn5gCJmjSSuDb7AWLOH8lpEM06aKgc4znknMihiOtQGreq1wG2c1XzyUDeCONhVUCGMmz/5KMX+DSD5TC+zTXudJtPrFw0kaEVYEnP8vkBgOP+a2EYtQ9QmeSemFijU8NbSU8L75jmPZ04oZdJ+DdZ96Q2sZhOlp+9Ujm/vDgxB8sbK51/9FNcktNoOCQwAv/RUjTEu7fYecfyNx317Txa2qLt73hTMHapvI8bjpiDSjZeXOz1rnpQha2/ZS8iI0Y0EOrYer6s1tJUUBa5XSW2y5wDh0FIyH4L+HTxaYmNgOjnZdXROOzb5DU1Ou17JbjeAvltiqJN95
 SoYGioVm
 jphV5v+o5RmAGGgvHgdHuB5OFL7JfjtR7SwzFbJ5J0bH10u18A+7yu6fC1ZyzN7GuRkfo8q+M9TYTtUqI06prazwXCAjIMyKcRgu3N4Uj4I60PdD8Nd28S3UmN/eL93s00GWDrfbJx3YjMMKJh/dwN3PJvT4k9RVXthdj6Ia4FNyO1MS8N2wUYXk2vS6WlEfmX9FaFFtbWYU4GcZVGz5t9oYtq0253dIEMkG1idyGTANXTkNM4M31iOxf6HiKq9qvATMYUqgyD87QhGHB7DSDKZTi7Zbwo0pG4D3DxPUm34eWzcbMxUfWNVJ26OIc6jrWAC/kZoOO81Z/MQbAt1putaZKbGLBvO0Tz6F9h6/jRt0kiBxlR1iPOdkd9hfAE3+baU1GyNlqw6zzta1DPlr2M8kIivW+S2bWXsQK6gmuAVYa37C0yBvLrNMFQfZv2tfviRyek0yYviVq+ejwWn78ytYpHKpqe30jVdMh+QqH+TZwQbzxsqkJEA08YutacHQFsgjqufnOQn8fT6vEYHvLzQXaEvRhxubXNlcBbx+ZybotpPqGJUmdQlqTtPx4qkHu2G5rat+T9ZSi+4BekhIi6+bnhTsvCG2sLpMDvRtA4KHUUpUi245QLpLzlYuITNp6lK/7vazoVhzegLfGRR3j3T05zElTjwYHaqQfik/pdp9IhnUidMNOCXiEF6uAXEiYxBZbiO1SxOGv482OKA9aZWrvcmdYKeAxm2d/i1Nnf2ACeg8Z0H7wwfwRKfGSYiZQu/GUV0g1oZTbmRcYmqGziD8HuRMh+yv2t6PtKds7k0W+GX8iQoO0mYcpM5HdWLZ82IlMKUS0ObWuV+9NoSQdI3i2aJA0No6CoZfmmpGE2YT8bD3quQ8Cp+K0aUv4bP0/LcxrwMonTc6F2AyJ3JpqwadbRQLdItWfDO1uTfXTX55VeVhoksGiW3AlKwXI/IGujBiefvcz3iKqMu64PKdXX5WPDNH4
 iCRa6kLM
 CVhWMoO0A8P6dOYYWmviXZn6gnO5HK3gl9V/66l3f1MWOeOd+QcGmRDsahVFKA3/V5k1TYgxwCKHJgHVFS48yzRu1q9IB8pLwIxub1KGNsQlRaUOpr4EqBdz4lO032VAyUcX5038hSqRdhYMp8lf/xjfoH4NNTM5BaiebUAxuELRgn0ez2ZPCkIcyA/V5B+gFXAfGGG2mJZVYRViIcfAINGXWyXJ1j2kWU3jUBvio1ZDdjI1b8lbItQRZUA9YZi219avZf+Blqw/gMwYJhp/vifRxc86Isq2qZqdQBKGkgtssVF3tLY2NQt0TmPpWhrLUGttLXpMafLA6/yrj/5XGkq394Wp+76IPlpXJWjyjdMFjDzTWq3A3moLDiwMkzDkdMpJt89yW6RnYC4OArjv4rIZyPgqtKeKBzTBpv80DE/UvzQ0VGtjI450F3bZ8UIGne/0BcwDvp8Oag0vdivCIL+JwOwzOJn2+VP8Phx5I4Gt0eQ58w01D+g23OQbfSE8VgbACGNxIyVh9xE2oQrq30I59h7V3ce3tcLWV7ZVpafQA2qWygaxGCJtt5ChAuKLwGTpQtQ7+SbWEXW34GhvUlA2Y1UM8l5mxu/hzJRN6w5muQUQ3oVFqVQPstrVZaz1lyWD6DHyFvdlYeQrmiIQvMxJmr2UD9jXgrWpgw++F3OxNnPclicSkNOK/kvJdjmChnYSvvug4Exq2W2fugfTCkc5aEJksc6OHuFW6SpaHRWGoh331+htiN+1fANh0cVYKKs6K5ZTiBqiAOZAdwFZrrULxO2VJ6+XdLANA6QtuhuymxrindIs2oOz0p7uvTqbfhFQBsHaV2kVDx6DJBXvtMgKhFB+VU3ywtOUzOe39+YjMSX+9WpXwGqd0WIYUj2HxaXc4fvg+BzCVLJWpkBsFK5CaL0vwNU/LBhwrAU6y3fW1bjjNCHmWsoldOUaa/pmuNI4+zcmSRVdxx71ZRPzr0C5VNW4b
 ehSMzeCy
 WnZE9ZfhITvg8oi5L8RI5DcCbagi46rnS1o1BM2w8/MbxcvAFX27BLyXoU5rCRTdrSpKGWnhtPT0+1ro0uZjHccuzbO2y9H3mwUwUtP5HgROCT5C8khHVqpmCS7JYdQQskYxPVNjHq5BFfuS2CbSoQGgYn+vlaxa6vwJ/g3XWxsJaED4+Py+tWrSLRQ6I43AnDH621DF6ReCnwpbrIzCFVzYUeE3TYXrZBJ1lGXtss8Z50LhbbDdheYxN/h8NOQz033/I31dyKTQDJQ/x7NOPZTRR2Z8U4uQjC3ImkDUZ1ffMxDCO3xvMmWuVVhR3bKiOl7qVXLQi//gFksAls4p8/ddAy4KPKG09y+0PjfTt5CUKhM/v4oWtYRaYo/brxUYSEPinSlecAN1+EmxSgYsqEYoeLPzwFKG8Iwoq0HruoY3cMguYNpr9mIHp3tpS21h6DRSNQZuOz8hWqNtPxXFmhF7z99uiGG0SI+sc6r0HexG68ODl44ILq9zVNRtqlribB3lW15KwEd4qftwWDn898otwzpdY9HwmsyqYXPVIjAd//tmBOdVsFLpu/OZiSowMStOWhMwo21DDNtFLsrf5QF2gNhWgeNCzr98Yx+WYxvoG7PSw6zHWaZmQFCWI6VCdk2dzMaO+t7TybHe1qP/y9EWMZfUaP/0zeNFCKBah+LpNvY4keW3X/Ot/Wv/Gio4td5RqvjWsLsUJDtCryRPb+EE+yq9zlbeIC+Tm0wdVUB6/7dxb4md8BAS3Qu5XWO4ztEKdU7jv3f0B8afSc5IOEChNxQ+GNxlW1XtzOB0EN6s6SiQU/jCvUvlaTWGXt7EdGhF/f0QL+vL/GC5IOC9GmnJ2qQ0/rLaPGMfe8z1GDJ3vTAkRjMiR8O6FsYAOMQrDp8SUsKTc9BeyVpeyVmP62ZNjhhe6Nhbt0Kkc86H/rzIUFOW4fZD01Zio0+O1rEaEIG89SewiEb3p7N/y5P+XcQKQGj09
 DzsagTAX
 xBtgfCmkCzJJeonpH28AiGixHsHqo6E6ABO8hkAs6HYcyEXQf+Hsv7+KDASs2RYE+tUGb5pb+EDU2IVc60XlSOPV+hHbBMGX4arGwKPSTVOye4DPq4yOs+pS1W+G99LExHNwSI/QXVdTKVS8hohq0lrpYC6IPm73oLEcuRV5WycqmbJnGHwQKP6KTkZ1xRqMNtJG21gDPXGZPquK3zs3mPLqu3nFt6MRGx8rN64BHJROOnWhcCwRT2d3q4r0WzF7fm9c6IAqi3tiofg4+FX8eFAQhRaJbDqzcY7Ko0Fe3m2X81nXtKtZG8JZOGGAhtgorieb0HqPMbJ2WESEBHXUbpkjKGUA2xEUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format string from %lu to %llu for inode->i_ino now that
i_ino is u64 instead of unsigned long.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/iomap/ioend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 4d1ef8a2cee90b91591d387f8e1c3f75350c1da0..94d9a3c77bd68581d752fef4c16b88e1cb5f88da 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -48,7 +48,7 @@ static u32 iomap_finish_ioend_buffered(struct iomap_ioend *ioend)
 		mapping_set_error(inode->i_mapping, ioend->io_error);
 		if (!bio_flagged(bio, BIO_QUIET)) {
 			pr_err_ratelimited(
-"%s: writeback error on inode %lu, offset %lld, sector %llu",
+"%s: writeback error on inode %llu, offset %lld, sector %llu",
 				inode->i_sb->s_id, inode->i_ino,
 				ioend->io_offset, ioend->io_sector);
 		}

-- 
2.53.0


