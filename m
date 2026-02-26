Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF1AAFD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409B26B010D; Thu, 26 Feb 2026 11:02:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA186B010F; Thu, 26 Feb 2026 11:02:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28BF16B0110; Thu, 26 Feb 2026 11:02:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 10AC16B010D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:02:37 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D699E1A02C6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:02:36 +0000 (UTC)
X-FDA: 84487075512.25.3420A4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2A9FD1A0014
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:02:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TRyb5ELU;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNshNCgnV5XTGjlZCNUGjSs9zbbjG/V3gBkBoY+OlDA=;
	b=BBd4Gp6TjfWQGQTmLtESFg/SJJLgkzjFP6CZR/I17tvvvJlkv7a0PhVfVUZ0qJSKjNISV+
	ghAKj+E8H5zYW+sCiDeUrfvItoI0yDZXKHgo0dMuK8vpQraVuO+IvBy8bKM6qv/BmRzfVp
	IYuSC8jEd6fthZrfn4mGoJXkm64Vnkk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TRyb5ELU;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121755; a=rsa-sha256;
	cv=none;
	b=d1gykds8vRzV7GQN+ohiQLOBIUaKr4ctZu+oVeDpH5kddO9r2GcHNnTrwBKGGbbMKmtc62
	aQP9cUC9F8H7owbvjALPgRagbRryA+yg7hswBeUVc83n/203m88nVs4P8GtVfE1Mpuw2R6
	3kYjR72yseyajiovBXz6wrtLRGOVaVo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D1ED41E60;
	Thu, 26 Feb 2026 16:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75CAC19424;
	Thu, 26 Feb 2026 16:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121754;
	bh=e36wvBqbLnA74Icp0D/z5ihyz+lsimYXgzizPubPc88=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TRyb5ELUwAisy0K081InalDzTYh15bN85HIat66QUrbTbFqkuLts5A/eu+pmsvLRc
	 SUtPpvZo/C6MKT5xJLJAOusvl3H7JGF/sDA1x8eaecHzewRHMiahhr85S/WbysY9LE
	 S5eQ+L7mcOqPK7QlRAcOG63JiHGqjanMp0FAj8Txtay4IK/egUUnFTKjjf+hzff1IF
	 zClndhO/xidSow88/OYkvEbqe1Z//ZmzId5N+5NBRYwVbHvy4VqwrCs9iB6fmMzado
	 OKRxYN4dnupx2LVz/oLfTLGDmszUVeYOi5uLa9S8LI4zeJ8YH/d5NUXTzULFR+KbUM
	 LdNv4gRs8sCzg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:32 -0500
Subject: [PATCH 30/61] exportfs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-30-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1061; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=e36wvBqbLnA74Icp0D/z5ihyz+lsimYXgzizPubPc88=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0L3+TuSu4JgWyD1O9aXArZUMQ6ROSrPqkT1
 DvBvPOLQJOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCwAKCRAADmhBGVaC
 Fet2D/9Nq6OH+wWNLA7uY3LUWtFVML7UMlUF3CZ6lkxbs2ZFlG76cdpXh8UVAuWv24ikYq7RZoV
 4onKygMToVtMwKvbxh6adn1CT80krVi3vlsb81Y2IY9z7cKeK0fC1yrEMlMEmoppHSK3L24mQww
 5pp9nLFT7gWIzm6/Lvj8e9FQr+1CpHHeA6nzGX+F+OVu3CVLcwRvNc1FOCrY85NAfAEZXAwP3Yu
 ww6lvg4vMbk6zCFUtjw6xJJssvy68cKX88tIhT1/MRmufCFsG4Mzc4puW/9OOkRhGmlWyXNrDK4
 Xe2Sb0i5KQDFDnAKCoaIUls3VjGqDqDliIm/ux6ZrD78hXcSHQHMAMcRmJPP0GKTWNoxIzsezpN
 kxIhx5qrMEifohsa2S4/56QGWIbS5ZnPoF6MlAJhbHtgv0e50asp7m8bArINnPxyPWDbJhA7EaE
 Tt9oDe8j7EuZGzLKMSBdmMo6AQU4y8oPKQq4ZpAkOfNsdu1qUFO/Jf3YyCrltpx4q+F63X0gn+w
 LyRJyufz81WgOojER6AjeUhQsdB3QDqEdXAhmhWz3mqhTDl1mZV40cNem/TWiLbs0a7BbJQGS5u
 4ysEMzwC/R6VktA7f2DqeBct1fX8MC1tyCwC+fCtJVYPlD7/xN1f4g6ilt7VsEroaAigB+ZWULQ
 F25b2DCB1PEj4Gg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: cruextsbdpqee9g8fstmspwmkcdzd7h5
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A9FD1A0014
X-HE-Tag: 1772121754-726234
X-HE-Meta: U2FsdGVkX18b7HY/e3gxIvmR/ilyNhFqbT0KYvBaXs1uKFhv0gAbSuw5K/VlLQ3Df8Z7R0PHBgYNLUJUU5kUzYaSQubkG96KRKT9QL5UhTXRliLPmvCa5xSfQAAj2UhC0C5jsxNHTJ9wcrrgEVTyCTq595VU6MEZLXd9Lc7S/dhC0Tbn7vgZJ5pT18+wOZdilRpt3yydVY3eldW4IMj3k+LQ+PfVt5pgKa9iCiC0RORrtn6j4HoVjb5I29xRkr1Ll8I5k03lzqvlghfhgr26ZbcCKAO0rujLXnVeq/EnGd7Zm7Fm8hfHUQsaVpkxA37rPN7TB0PpVrLmGaS5H3ynlPsnU2+oc2mhYwo2VA3gx+noi/9A8GQoopomExwXjBmpGOgDImZrTU0sGNRThVRTGE/Vt1N+jc9+EMf3EY/NGEfgtnkXwfyF8iXaAx5S2R1LAuXOY2j+FbT03wghOeCwXnHYREgj7ZcxJe+1RfRrghV//o7Z4VuCgVXruWLa99p2Y0vehyszQT1grD17xqqSXu4d1RH2GeNfHm8KQgSQxwYZxDlhCxgwOdb0nbfJPxBG76dbTYWI9dOU0Xr8UC6GUe2220BdbjWFEkWNFlCFzPF2o1hwYCqxOF8cmhZLegN6WOQx7ycJRKhJevlUf+B8NCO8qhl+vj3nC5lLc8YBcI/CF85v2b+L+2Yp+s6R5cOL9NcJokkFXhdtooZDgLVLTcoUJ5VJBFaL35510MpsTWMYuEy1ME0JL6+ZvMUhGKSf2FJhlKitr26YqkyiB9qn1ja0Yc1kH8LT27JGco2JW4ujNxzO2Md+iTzyEA5BK2Tv5IxBoO+vhieP2pRc+h6fvTYO/caUBnaTBcNfrqlGtc6p5mLiQTPYB7p6hMi3LrbgsOf0Dytp1Mdwos2xfVqCP+/vGI74/Rbf/tNutFzcf1uW5aFjb+gg9Krdc65lOkS0VwTVmeBblDvUhefwqhq
 XZznLYU1
 QXiqFE2GxOFLDpl3JvF9KTn4KVblzvxoFtGEqAHW582YJz5BG1PcbbcX5uLoDOXOCdSMR1OH89pJu11DphfvxnBH4pzBmZ6rvmGlgoMeFOdWq+6uqkgEVnJ5Yz6oFa1pfEAIt59hf0jfVayiGRGnxIR/NOfombYEwhbmuvH6XdSlwVVSsvnxM4Td4whJ5A+z/36Ep+2OznLeSwKCY8k9/nzdRBI7cGS5Oe/gwSlIK0NpzcmAyhLepx7loYjRvu/u/G7oRTkOFEzA0gV+MlW0SLujtdgy2FV+Vdw36bmeRL+mavrWjwaAUtINDKDdEb1bYPligNlPkjM3uLGWeNJhCkFDCLohCD1ZI4W6OTtpebynX39tjNsS66j879CH0OQZdBBg00yAPW+cGMsISUz8Gi7PfheI4dNd5r6DsbpKUF74bT0CkS/EFbV+ysXHgfR/bzKgyOAMqtPBPQAxgfJUJel3mOqQY854l/4xLJM1qEh+J+KwhscjQZbaxl0ce9yT8qSaB85RjjGlPRGu6Ex0vmFzus1mxV9GxY7tCFIK6FpeewzKe2ctXksH9+J9GUWuH+LLyFrUuduIM1ShpK1PBYJRTFx7cdXWslSfgvVmCdiApARQlM4aQh8W/DFM0UzyT6D2NGksRYGj/YZZPErEw8dvcoh3nkHIz7ks4drvATB/U6/akoS7PX14Y0rkaWYDVSBEXg1pdwQ+wkkFCKio10saLTQNBR3aqQlSy7FbVN+b/xH5c2HD1Kd2vTBNR7RvCGJFffZ2fSRfPQIXj4ISas1ZNc+ZGgEe9F7WPDfNR8LPNfZDgohREUfdaFtupnbL7Ryga/s9FflquffPkJamig9wf4KJtM/rHuBi7Bhw/yu4Y9PNloron/gWr2qg+6NxzH+klxvJQw8kDQFEH2HaUvgwIiajgRfT8mfJvqPPpFAgHe9Qt+xT+v+vkp7ObGg9LT8UCcJdYiUemIMFc6DTcAy7UPGIQ
 WdDFtQYa
 6+k8vlDZM3LwGiZ4XN8ghTBWQZKb/UA7wHi6LzhB/3SToxkCWuUyPr8Y5/+mHeRp+KeF+pB/BxEiBdvYD/xHIhmvb3/sAX2GKPWG9B2xQ51/OCg8ke6fjV/zjnYMXLh2xEFud/mheLOVXlTvPKj5zPLiNI7HsAC3ZRlX6Uk4z9X6Jk1TWQ5pz1CYSVCECyZ07zU91RFq1l5NnylR4fNyPqjR1gkS8ES7jqIYeLBmW38SdA2sPs6O4+dwgyZ4SrP5I8rUztR9gXRiKU4C4MKSdp4XUtpa1TtlsYPlCZpy62tMv1f+SOtRLSiMF95Skq+IkL9AdcmU6B5xTgB4zsJO9Zo3AYK7c+/ysx2lFSKbIUSmkPditYTPTfk5rCa2/USSdYQixTdiJ4NC9OIfrw2NcpBD4q5eyh/RhRVTSQIRSW8T3Pd2HewwZX+EogFttRk8tSgC8KAlzuNralmKj6z23MVB7eGDDQGbsCEt6jEQ/UPB8Dxd4iD1O2yLbJJneBT/tafZlwjpxFbKVqGQaFpGaM3ooQl5qCCzzw5QN5cCkrWQggnyZtzCiLi9M1qdGi+8Tdp36fGviolzuzEyRewJZ6CZd+MKP1AJKFy7S2AHvHY98DzorouYXJv+oe3wEj8cdqeHy3ImgkU62wBSfTvdF+u7JYfaj9RVXTtGsHFarlIqFDgb4XSTJk7IkkVroaU7iHJyDSWtSrQYwlSC1sLoVtJjbQB99hvoZd/BYtEs2FvaMfTZY3bJKQnLgP6FCCX7Or8PSUnjcxpo3ZnuLD3bpTZpgH50lS59R9OhWmRxdM0QHCCAzLKi5bZaFc9LDHiqYkZW8pNIIcGfzJgmjN1mjPT5GpA6gVSYWGNnyDvUeR1iPivr6aezLhrR6eJGbnHeC3ZH9EO6HAbpjp8K2FUqzfNkl7wxxz1PNECyHfE49zCxMtVBcEJ+8574HEtNUXw+bF8ZKfUCdmSnwPDsrfhh6SIKl2YIR
 T9L4FWd+
 a1wgwc7QoLo1jF1U+NwBP+wYV/3dPHwB1YMoGcORV/kwW2lXkqA8/xHO+7ffb34I36zMZavmI7reRT2t5Ej3BYviH8Kb1RLEAA95xl1HNZoaBJoLj86vw4b77kvQLDN/vATSU6mxbeKwwd3YUGH9q37Hw0aWe0o87IM/tcUeQd+3zgpQnBaobsodsbm8nd5e8x8pdGvIEJjtr88dGXkhb1BTDiniQbE53rQY4PEA8jvjIuDBzpOw+Cg9K9iv7YGN/MdxmSlgljFQ8PLReDEOwQ6wbb0XY6UAlwhaxvk1zzwUHX1GKhgg60l3W8W39u9gAdjZALzlGaLQjwaJcUA5y33tDN3wz4C/CpUJSkjOMpRRGWe2Q2MqEt32NxcFwNwbvv2BonIg4f0VTnHlFmgiY05QNbNGgFTQomRJGkQo4XAgIUh4URDnT3zDNKekJQAjGSwvjShQocy/1lHmyqiGXAPQKczVbFlAjvN5VdhBS4bGC8yyg9/gzBHdyxgdIlHtnNylI8XFHRjabjcXBFXUaP5tltmSXCja6V1SMuYVm0xHhgHKGroAl52Ae9m/IRJIQKttRgIStR9d/nTvx4sA/DGnNNginBJxKeodSa0SZv0hLAWmc1sLCKQIfAJarRCSkJ0+dcXyoLNM+22VcKGXri99ovWNqey/JOONVC9UwRNN+fMa0OvZhjpSUNyPky7MI3M82M4g2qTgVBBDG/bIBx/Hr6HehfDFGxYEkjdD9hlTOLbjwYEM3GEcYxR5Wm7uOBVI/xPGKgJSQPHVhmLzym7nYlUW6eeiPQJzx/cfMFY/B3lcsclbOEfH/zoofXOSK+pY7KxwgikV0u846T2MvMtebNA9xiv1KVJmjYDs+MNznGal2maqJSpdms191QM/Hl+3BbU6ZV3yAhNFO7eMFdYufvO6f3qt35iSx9GD5HAL4g/bZVgar8aF1KsEV7LyRM/Trkj2+UHeYSDiPhfJXNwZ9vYt6
 uNwtD/t0
 5YIIBYzJa8A9V8h64XF2p5sJcBuwiHJ2qzmY+VfJ4j3OXUsRy6IsupTmBUEWBsu7OICLw7I3P0NQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in exportfs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/exportfs/expfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 6c9be60a3e48dc5e984a826029375550d1494835..5c3183ce350ebc89ba4a5c10ffd644b6666395c3 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -130,12 +130,12 @@ static struct dentry *reconnect_one(struct vfsmount *mnt,
 		parent = mnt->mnt_sb->s_export_op->get_parent(dentry);
 
 	if (IS_ERR(parent)) {
-		dprintk("get_parent of %lu failed, err %ld\n",
+		dprintk("get_parent of %llu failed, err %ld\n",
 			dentry->d_inode->i_ino, PTR_ERR(parent));
 		return parent;
 	}
 
-	dprintk("%s: find name of %lu in %lu\n", __func__,
+	dprintk("%s: find name of %llu in %llu\n", __func__,
 		dentry->d_inode->i_ino, parent->d_inode->i_ino);
 	err = exportfs_get_name(mnt, parent, nbuf, dentry);
 	if (err == -ENOENT)

-- 
2.53.0


