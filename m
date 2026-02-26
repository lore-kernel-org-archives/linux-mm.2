Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBFAFFD8FD0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 577D86B0132; Thu, 26 Feb 2026 11:06:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521AB6B0133; Thu, 26 Feb 2026 11:06:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3CF6B0134; Thu, 26 Feb 2026 11:06:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 221C46B0132
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:06:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7E0E1B7020
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:06:21 +0000 (UTC)
X-FDA: 84487084962.27.2777D70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BB15040015
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:06:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q+nkvjU5;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8ZGGQY1qt6ZflVHJHdXL7pSr306z7ZFggqnVaoYryQ=;
	b=1HvjVM33gvyzxYVnZwYUtpe+f0FNvjNIaU3ttMmDc5mOm+oLB2myPfj7UlJqq1de9ksDXu
	p8ZjABjb3YqLqYW0TkNiHjLbwXeTkN4ZNzyk2v+EX6m4Qe37UBHOJKv8/+44vUBrLQjnBz
	1r+oIhj6iEciob0cRv1g1SqtiAhGrj0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q+nkvjU5;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121980; a=rsa-sha256;
	cv=none;
	b=p/6AxlwVB5tC/8a6nsdUJ5hrkNN6llE13LpJ2ZFAby1EezagFE8hn/+aypMG7gxNxmWj5z
	WGIQiyntYGy/Sq61CjNbHuFUJF7oYkiJWfAsHD9Ds/je7ZsubKg1P+JsNeAR7nmaz0y75X
	1DSrNHrEERkYXW8hsKjKuwWvWyD1oKc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D360043BE1;
	Thu, 26 Feb 2026 16:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79300C19424;
	Thu, 26 Feb 2026 16:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121978;
	bh=iU6e4zeAj5z40Ah35aY1Jl4/4X7n705dfCUksW8kFiQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Q+nkvjU5PH9beX1sDz7TCsGU59b7gNRW0L4FVkS1TxbYVf2dxcTYZJCdahq16kk8H
	 KhaF7luPDMrHsoDLihiy3XRwGzOhdOHklTnXTFqiUNpk9xbeIbuZAXIZiVyQMJUHSs
	 0thfIptMhvoCgjCV8rtksyKLzyK8Qzl8TlINr01NDAKGOnLMWvK4vMPzhZ9cZiOZWE
	 EEYxRFbvgEkMHUz7/plm1zhg2LD/iDkTpgEDUXEFFyYjaOR485LQ5gBJhchKq9Q8II
	 0xuI2i6blS7+c1UFIt43sTJQyGkoA4wxF3SzrVEbxy7kPXrqL0o+2XnZfs2mSyR2Ph
	 K/arfLmyIBGmA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:50 -0500
Subject: [PATCH 48/61] udf: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-48-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9281; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=iU6e4zeAj5z40Ah35aY1Jl4/4X7n705dfCUksW8kFiQ=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0QDnCya8A+2cJJ9pOZSFdmxegEJ3eymi5BG
 766eHMtgmuJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtEAAKCRAADmhBGVaC
 FcOYD/9P5pWzfQuRUb6+cBoUCHAhFB70OfFIZwuhgN2vnyZxuw5DlmpjeZfqLSA0uIv2wWBNue2
 qADCpMu+cQZe7F/XaXtUplsygzoq1jIFrtkQypp0Z+/w4UVy73Ikr0a0FXrxLVb3/PMjGHNjM7I
 HoDBWjU1befct4Gd4Cvj20PsB7hm3cY9Qwgm8aGn9ORDjyxvTDZrYxI0snho0Bb9BwNiSFTgdu+
 IzsGRpgoRHbAGA2P9OYczBisozKER7UrMkmqSq9kEvC/zF3jQKjbu5H2xrIpXoDeIipoVF3Kq7D
 kwztabjrqa1iR6NfOF4vMbZmIH7HWtrTr92NwUqfw1E+WTuhXl5dM3EzFR/wqmq6jtVd+O1BMBK
 GRNphZPulnGgW8MdhkHr1WhB6IHdTR2g4Gudbk+Zv5UWwX22+MJfr8nc1/ZaABnU00y1beP4qsW
 zT9of6iaDj4AKxUu4o7GYQ9sPeBpdmDT0ViCr5VWGhbX0u/G8p5d8Xt0xT+zUhigfodUnB/3vuU
 zFB6gNo9T6YyGZLlImQhBNEjuv7RahinrrNVQCJGpORKjmO/Ss+Un5OBeUhaOtrQ8GgkqaZ1Fio
 X4h0O7SeOcQbTwUOeZVbbr6i8aX6UtXfQkW/WVdQRtelo3zV0z5P/4v9ET4BRLNDCFVcmVjGz73
 K6a3u+3nNCsAr9Q==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BB15040015
X-Stat-Signature: 5xmjahdmoo4hxnewrep7nsepfpibykh4
X-Rspam-User: 
X-HE-Tag: 1772121979-984678
X-HE-Meta: U2FsdGVkX19GTLmYyq93TL2+Pu+4CoQLIA61F4b0RcC5jNHKrrkdIGhNnc7jhwkYw4wjsXMVVP3MGpaYg9unc18WShIFqs67Kt60j67/Dm3xE3a3M5ftGEakQR8PbKzsrVF8uH8z41OYJDivc2IeHnun+Gf408UVtfo6jw0XFQo6YIpnMkEVuXsNQ5RN91x8jSC+cSToC/rI60/qBy6SumoY4c5Zg3HJQImwFGIKQ31UanI57mt5hUK6LNdPmTrJg3brFC/qF8iuD2q3bYztWwveK3/c9b+Z2DXet1ioaR2YVq/8SJ/ZU6VnWzC2k4nQokeTlI+sfxf7qQr7pAKbLrN0Pg6YNw1OqnM415PLnBV1lK26tishLguymMEURkO/2Tnah5PQHsYuTb+ltikQ1ouqN8IhMAaA/reYqafxRKRzF4IYpEyGsZ4Qlv1FC72BTDpLEYxVUh+HWCnoi+1w3IFAl/dl7DVYN4CGp42yEN1OKNep98DPRYt73neZlPDHduHox5whI4++IeCGtIgCDzPemL4fPqvHx/L14dsG7HDMs3XiCyH+X2+6XyaENTC4XzVb6xB3wKq83NB1XQL49sNc63nXo1t4p3z4uMuvIebxQlVxBzk7ZKkqL9t5fpYYAjtaMxtZqHSS3TD5qKa6HbaEkmvBzH92up9zrAFQFx0aXXp6Us0UyP9EkDrOuQz48EOrBPu2mNZzZ1DR91I5tNPZZLEpquWEoIqgeRKknf+4VSQXSuYJTxwnygELk5NgmZhoylVzigqFcw6lVf8XEEbnxJeHX5vOqDfbohiq9KsEpXQLX3Qg3Hf1jCEThe62JGad9yoh0Ue8XVglu3cL6qFotE6yEOhWCdPdNMMlE5VcJQN8Q70C1RpRm8BGcQ4W7eMxRJM+IBctQoYx3p561BzFfom+LyFWKEmTL28VRoKg04FaWi5AW+IqBTy74lz5NXhi7v3mPrnIm9YKJYo
 ctsURjFE
 MMvMpDDJq7hJINHJRbzHG5977xDyPqLxtwZucApjtJZJZ0vsYR2NUAf+AYlfXn2ryaV2eoXvN0rh/9JksqmhEB+U5rK9oqkqrpNkbIqN/ZJsLBtmMjXpFKnulVOmMYAI6IUl44W61apr/tLqmS+fn2RxXRtA4OcSLQX4uSF45f83LE6BwVJdyPozyR+Z0QXOw9o6IFi2zAC6KWxbhQ2ZFdwopjSvbmLBDUOGTWVNlVWjEaN2bXETBQSly0jfc8Cpj38mSCsUPowzI+w0UEOJE1dyGyZkUb6e4HiSqTsYDjIwYesYgBEWWlIzVuIFky2JWc8PC86UcCyODRFbhpK8nNu46f6qC1QAlY2lw6G87ITXxUoKvrXarUbl7lQECaIncSN4MPBCVWkdqFeQSYG4H7xEYaEDiS2A2zWddRk4RVBzwju+Q93RPEyhMvNSNzj23MCXu3mXN48P9ti+TntScmgVW66HxSC15BhkSydCKEObVgRDXHiDR9FZ4Enjrrd6dC6BBWi/ATIIqKcekkJ6fbC65gV6xr6YuUcXNWarppQnxVxaqNeQlBisVoS92VeYZ5C+Keso+uoz1H0TbwcqU8eH+D9A4nByGDwzBd6D2CMz2NkFm301heaJ9S5UB1F5yYreCIMQpT3ju3/MAwyTyhB6RFgN/r+WBL1fE+DXEsRpz0mxliXTxgAoDxsQ3NNcr1XXPc866ALNv7Tc+REDo5cVLUwKKMrt80i9a8nZo37EBKL6byAU4YmhYKU+7Jya8dQ7kBPgs9VgCsVL+xpE+Y6XNUDQkNMtn7rY1auH7C+ptP5QZwcxvQ+mAwB+i81eY0P5AR67hntAmbemNCdfwTHHkq6IzfgW52ZfamG6ZOY0KBNrUQhBdFbHog/DeekUUMfsWj8iQgNjrA2k1RYyzroRSVghO8EL8khDaaGvVTtCf1skOWNykiC5j/XFF/UCtn/NcoVsrDtUai/vDXkiiPVGQgIVy
 x8cTrDH2
 yfezJsgSGzBCiJHpFSF8WlJvNooa5IuJrhwGWAHx1fRP6otprL4PuMowQ+JwvTjXPKLYYBIn3tUABo15q4zQpuWv6xylCcLwVH+2Mno98cLxYxqx5Zd8sQxRg4U6lWUrO0u9N6IU1yB1l1QESWUQlZMOIlcqxIuSMvexWyWaEsAB64H3hK8+arm+2v4VRGzaHGc9UNAzPTlXAf+RkNPnDQ+lhy+UwHJXbk6/fkjTCkcfNpPcBpPwNufH8f9VDkPyEJS77OMICI4OQEYethPTx3OJ9JZ/kBS+iDPXmzUL9tpjU0wSf1MOQlYjByziZp9pLh0EsI4UK/jQvJhNXRswhdaawU4Q7vyh6hyPnSFH/NaQgzRBlOdecAPMZheRPjTGXghAFZj2y7CehN1pNMi1K5CymOWGYICaUtsy6m163jiPkBBZGTUuFej6zy74vEHAHiFuZUgKwxAIgedbrL5540zXuBM1BdbVuHHTiLwW98oiZMIJ3BSFNgNUe5AGN89bCI7XTeDCpqUKP/wA2pQnktHsrylUGtfYFhLv9VdGjLqrqZ3YRekoP+71/zBk11YSIeJbeLjk+UikuUb3ekns5DYbW5jODlGTsU7n6BLYH9IximhamFkeK3TnA4oqpmp2O4WkMlhLD7AuGNGsPLr6Dpey+8fAVqLUQgTT6BDH7Lx2Kr19pQ6CAhSQ9k1La1kaTPFu3F8zkLllhE0avyHaOWPST4UEFu1vRJB7NQP3TFW2hOpy4Sm+ccXz/U9AvvRdXeY6+tzbqkYiK3oh3s+6AgRa4wG/TlPFWfsE8eo3xf2nGIm1N7tuVQ1ZTaliYFxJQC40BNGkbk7wGy9EA87zuaFnvpPQiOrGJKRXT87B/GXqdM5MrSRA8EgoiJKZob6OaxweLFvrl1cjtGjTsVnynrfWBW7+YDvPxYF8GmyVgdfdP6OByn0uOeRXlgjIgry62ZjS4JDOB341BU0URIeo7r8/dzUmM
 YZaYwWwq
 sirWDPKVGMbsJCi155wnVIH43ojZZzHw+tKJ6FaQA+EhTNGriiMSXvMSR7/CV0pViaMwjhuSLnYfa+TaOUQ/w9PvcNMrlLfZvpy0Asp0aDLbMSjPMo86/mmNvPMxE2behlJX0ao/FDDxsxkv+wrz2A+7ZpsHI1fkYMKt7KxorTbgTAGynlxLSN3lBoO4iMmp8kHTLoWTSbbgdg/R+HVjCM6sKUOiPq0ZBGmhfA7uX/PzWYc41tYxMq1l9GeUYXFd1bUxgXN5MPHYWaEy9QZZgB3XOgJ0kRbasKl4WO01h+tHk13bg72VLKnPfpS8xHyKFowrr5dJZ2LOWzYWtVUzPz9XapaE2OuirDKBIA5HhH4RKzaFVNU3WbMdlSKx6O/lub+FUZqFsG8v9Eg5b6H/qYEwi57SlSRElNX1QxyQXN8T+CeqCJ+SeTpOUSAsoQK8gNRXurdy63asbp2xRN16JRQB+yko6BvlaCR+D/Z8+M4TV9LCZFzBzLCAHKJYS3z3+TH3M1k4DzNVgC6CXRBeKN3I/PRz0+gfTuSp9il4tXUWTK4i5Bnm4I/OsjwXc6i+HgvzrmdVaBVLFuvL6hcICDX4jkxNRkXm6BlXM06uC6xIl1nA4IZ7FQOEc3eZfQ98/0k1Of2Pr7yCmz8mcZhLag8xYH5UaSF8a2PvPrEd2d9wTJVUqKSyKXzMFkmxiuk1JYjJ4JVJms3fizdqJ1e2/lsWGRy6SBd3SjC8GKDwQ/8pHlwTYA0P1Eqheq1zECYqwENShmqIigirc24oKzP6hqCnARTwIK+sQBgDiOcw2u5hpmtOX20NEJvRA1eAwG9KmExCh7EuW5cw/1oS8lGmvDBEswlVCa4L/wnIxMx0+McUxQwRpMyrlJkuBUCzvO8u0776JutUiCjnu9Z2Dnvb1BQtWpN9KCON+shRc2dd1LVKKCskUOkXQdu9onUEz2bXy5IJkPKCJCjMDQBQxPthQ0DJ3MD6N
 yV0xecAU
 c+pNSXDdiUhHZrg2bS1dZL13ht1wdib2LlxkH+D/x97sfDaY/6jZTyih9oUg0ttN0sQn1iFmHeWb4Vm5oaGPEeZYloHDf9bv7ffJ2aovH1XDIrOYor0NdNAQ/BSAWxrfTuiiRjXZIOyUjDd7d4Fh+brhEJk34qwt4+Y9J6/wiKwW/cLmadCHVxNyMOhzs0lEelJNVj1kRHLBS1E0v9KseFo/48Bo8HLcuOwrLr1IwrxJgbtINO7uQ/SFPsHRQ711ddk3gOxRaybHmj2i0mlLNxSn9qTA/iG0u1ZRPS8JWwTjQb3UfvkwymJYxRdUB6F3XrRW9S9j7o0qAkqjJqST1QwvsypOvNdfiDCuGlqriJLCcp3rSIt0a8+jVHTQhaLRSPoo8WhP/E5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in udf for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/udf/directory.c | 18 +++++++++---------
 fs/udf/file.c      |  2 +-
 fs/udf/inode.c     | 12 ++++++------
 fs/udf/namei.c     |  8 ++++----
 fs/udf/super.c     |  2 +-
 5 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index 632453aa38934a0b58b420717ec0674c85627ce5..f5c81e13eacb17f931d2df564ec4f2a6e9a5d7ab 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -22,7 +22,7 @@ static int udf_verify_fi(struct udf_fileident_iter *iter)
 
 	if (iter->fi.descTag.tagIdent != cpu_to_le16(TAG_IDENT_FID)) {
 		udf_err(iter->dir->i_sb,
-			"directory (ino %lu) has entry at pos %llu with incorrect tag %x\n",
+			"directory (ino %llu) has entry at pos %llu with incorrect tag %x\n",
 			iter->dir->i_ino, (unsigned long long)iter->pos,
 			le16_to_cpu(iter->fi.descTag.tagIdent));
 		return -EFSCORRUPTED;
@@ -30,7 +30,7 @@ static int udf_verify_fi(struct udf_fileident_iter *iter)
 	len = udf_dir_entry_len(&iter->fi);
 	if (le16_to_cpu(iter->fi.lengthOfImpUse) & 3) {
 		udf_err(iter->dir->i_sb,
-			"directory (ino %lu) has entry at pos %llu with unaligned length of impUse field\n",
+			"directory (ino %llu) has entry at pos %llu with unaligned length of impUse field\n",
 			iter->dir->i_ino, (unsigned long long)iter->pos);
 		return -EFSCORRUPTED;
 	}
@@ -41,20 +41,20 @@ static int udf_verify_fi(struct udf_fileident_iter *iter)
 	 */
 	if (len > 1 << iter->dir->i_blkbits) {
 		udf_err(iter->dir->i_sb,
-			"directory (ino %lu) has too big (%u) entry at pos %llu\n",
+			"directory (ino %llu) has too big (%u) entry at pos %llu\n",
 			iter->dir->i_ino, len, (unsigned long long)iter->pos);
 		return -EFSCORRUPTED;
 	}
 	if (iter->pos + len > iter->dir->i_size) {
 		udf_err(iter->dir->i_sb,
-			"directory (ino %lu) has entry past directory size at pos %llu\n",
+			"directory (ino %llu) has entry past directory size at pos %llu\n",
 			iter->dir->i_ino, (unsigned long long)iter->pos);
 		return -EFSCORRUPTED;
 	}
 	if (udf_dir_entry_len(&iter->fi) !=
 	    sizeof(struct tag) + le16_to_cpu(iter->fi.descTag.descCRCLength)) {
 		udf_err(iter->dir->i_sb,
-			"directory (ino %lu) has entry where CRC length (%u) does not match entry length (%u)\n",
+			"directory (ino %llu) has entry where CRC length (%u) does not match entry length (%u)\n",
 			iter->dir->i_ino,
 			(unsigned)le16_to_cpu(iter->fi.descTag.descCRCLength),
 			(unsigned)(udf_dir_entry_len(&iter->fi) -
@@ -78,7 +78,7 @@ static int udf_copy_fi(struct udf_fileident_iter *iter)
 	}
 	if (iter->dir->i_size < iter->pos + sizeof(struct fileIdentDesc)) {
 		udf_err(iter->dir->i_sb,
-			"directory (ino %lu) has entry straddling EOF\n",
+			"directory (ino %llu) has entry straddling EOF\n",
 			iter->dir->i_ino);
 		return -EFSCORRUPTED;
 	}
@@ -184,7 +184,7 @@ static int udf_fiiter_advance_blk(struct udf_fileident_iter *iter)
 			return 0;
 		}
 		udf_err(iter->dir->i_sb,
-			"extent after position %llu not allocated in directory (ino %lu)\n",
+			"extent after position %llu not allocated in directory (ino %llu)\n",
 			(unsigned long long)iter->pos, iter->dir->i_ino);
 		return -EFSCORRUPTED;
 	}
@@ -272,7 +272,7 @@ int udf_fiiter_init(struct udf_fileident_iter *iter, struct inode *dir,
 		if (pos == dir->i_size)
 			return 0;
 		udf_err(dir->i_sb,
-			"position %llu not allocated in directory (ino %lu)\n",
+			"position %llu not allocated in directory (ino %llu)\n",
 			(unsigned long long)pos, dir->i_ino);
 		err = -EFSCORRUPTED;
 		goto out;
@@ -483,7 +483,7 @@ int udf_fiiter_append_blk(struct udf_fileident_iter *iter)
 		   &iter->loffset, &etype);
 	if (err <= 0 || etype != (EXT_RECORDED_ALLOCATED >> 30)) {
 		udf_err(iter->dir->i_sb,
-			"block %llu not allocated in directory (ino %lu)\n",
+			"block %llu not allocated in directory (ino %llu)\n",
 			(unsigned long long)block, iter->dir->i_ino);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 32ae7cfd72c549958b70824b449cf146f6750f44..b043fe10e5d605b62988512bbda65bd357fb649a 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -133,7 +133,7 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	int result;
 
 	if (file_permission(filp, MAY_READ) != 0) {
-		udf_debug("no permission to access inode %lu\n", inode->i_ino);
+		udf_debug("no permission to access inode %llu\n", inode->i_ino);
 		return -EPERM;
 	}
 
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7fae8002344a0e1e7e51022e97f1e0e2424185f9..902f81729bd886a534c9da644771c7c04c067cbf 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -147,7 +147,7 @@ void udf_evict_inode(struct inode *inode)
 		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
 		    inode->i_size != iinfo->i_lenExtents) {
 			udf_warn(inode->i_sb,
-				 "Inode %lu (mode %o) has inode size %llu different from extent length %llu. Filesystem need not be standards compliant.\n",
+				 "Inode %llu (mode %o) has inode size %llu different from extent length %llu. Filesystem need not be standards compliant.\n",
 				 inode->i_ino, inode->i_mode,
 				 (unsigned long long)inode->i_size,
 				 (unsigned long long)iinfo->i_lenExtents);
@@ -1386,13 +1386,13 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 	 */
 	bh = udf_read_ptagged(inode->i_sb, iloc, 0, &ident);
 	if (!bh) {
-		udf_err(inode->i_sb, "(ino %lu) failed !bh\n", inode->i_ino);
+		udf_err(inode->i_sb, "(ino %llu) failed !bh\n", inode->i_ino);
 		return -EIO;
 	}
 
 	if (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE &&
 	    ident != TAG_IDENT_USE) {
-		udf_err(inode->i_sb, "(ino %lu) failed ident=%u\n",
+		udf_err(inode->i_sb, "(ino %llu) failed ident=%u\n",
 			inode->i_ino, ident);
 		goto out;
 	}
@@ -1641,7 +1641,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		udf_debug("METADATA BITMAP FILE-----\n");
 		break;
 	default:
-		udf_err(inode->i_sb, "(ino %lu) failed unknown file type=%u\n",
+		udf_err(inode->i_sb, "(ino %llu) failed unknown file type=%u\n",
 			inode->i_ino, fe->icbTag.fileType);
 		goto out;
 	}
@@ -1942,7 +1942,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 	if (do_sync) {
 		sync_dirty_buffer(bh);
 		if (buffer_write_io_error(bh)) {
-			udf_warn(inode->i_sb, "IO error syncing udf inode [%08lx]\n",
+			udf_warn(inode->i_sb, "IO error syncing udf inode [%08llx]\n",
 				 inode->i_ino);
 			err = -EIO;
 		}
@@ -2224,7 +2224,7 @@ int udf_next_aext(struct inode *inode, struct extent_position *epos,
 
 		if (++indirections > UDF_MAX_INDIR_EXTS) {
 			udf_err(inode->i_sb,
-				"too many indirect extents in inode %lu\n",
+				"too many indirect extents in inode %llu\n",
 				inode->i_ino);
 			return -EFSCORRUPTED;
 		}
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 5f2e9a892bffa9579143cedf71d80efa7ad6e9fb..ccafcaa9680982decaabc180833b67ace5c92973 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -550,7 +550,7 @@ static int udf_unlink(struct inode *dir, struct dentry *dentry)
 		goto end_unlink;
 
 	if (!inode->i_nlink) {
-		udf_debug("Deleting nonexistent file (%lu), %u\n",
+		udf_debug("Deleting nonexistent file (%llu), %u\n",
 			  inode->i_ino, inode->i_nlink);
 		set_nlink(inode, 1);
 	}
@@ -809,7 +809,7 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 					       &diriter);
 		if (retval == -ENOENT) {
 			udf_err(old_inode->i_sb,
-				"directory (ino %lu) has no '..' entry\n",
+				"directory (ino %llu) has no '..' entry\n",
 				old_inode->i_ino);
 			retval = -EFSCORRUPTED;
 		}
@@ -821,7 +821,7 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 				old_dir->i_ino) {
 			retval = -EFSCORRUPTED;
 			udf_err(old_inode->i_sb,
-				"directory (ino %lu) has parent entry pointing to another inode (%lu != %u)\n",
+				"directory (ino %llu) has parent entry pointing to another inode (%llu != %u)\n",
 				old_inode->i_ino, old_dir->i_ino,
 				udf_get_lb_pblock(old_inode->i_sb, &tloc, 0));
 			goto out_oiter;
@@ -869,7 +869,7 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	retval = udf_fiiter_find_entry(old_dir, &old_dentry->d_name, &oiter);
 	if (retval) {
 		udf_err(old_dir->i_sb,
-			"failed to find renamed entry again in directory (ino %lu)\n",
+			"failed to find renamed entry again in directory (ino %llu)\n",
 			old_dir->i_ino);
 	} else {
 		udf_fiiter_delete_entry(&oiter);
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 27f463fd1d89e8ae4844cd70c291d737aee1589e..3a2d66c7e856383cc5c8a605180a9582396ba805 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1166,7 +1166,7 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 		}
 		map->s_uspace.s_table = inode;
 		map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_TABLE;
-		udf_debug("unallocSpaceTable (part %d) @ %lu\n",
+		udf_debug("unallocSpaceTable (part %d) @ %llu\n",
 			  p_index, map->s_uspace.s_table->i_ino);
 	}
 

-- 
2.53.0


