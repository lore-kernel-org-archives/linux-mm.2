Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DACD6FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4808D6B00FA; Thu, 26 Feb 2026 11:00:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434036B00FB; Thu, 26 Feb 2026 11:00:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB196B00FC; Thu, 26 Feb 2026 11:00:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 175596B00FA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:00:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3BF21B4129
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:00:31 +0000 (UTC)
X-FDA: 84487070262.11.3ACCB6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id F38B180018
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:00:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HYTbh8az;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYlkEr09/aInVhLnFKkfxo6QnM4132E3DVBiWR1kRME=;
	b=os2ky9xMHv6N9uEqAnWIxCZ38yGDRkOA72GvTg3p49kEklYFWhC5xPlpVU1WoN/AQqc2N8
	fL6d6+/od9LkCm4fBVH4g/1VPAzwaXncWvrBYo0O8NWP7OrSaSlNJtLI0U9PYNdx9BMAD4
	gJmXfVo1DxSQXJucc1yfTVjgmlprU80=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HYTbh8az;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121630; a=rsa-sha256;
	cv=none;
	b=Uj+dGgNIkXXKdLWx6lFLzP9IVbfcJfgfQzLOwdOrgZ5c3U014Y49Cagk0zVz29Cq1xhcue
	ZaIjhtLeyky6EGk+07muqIyQVNq7BVfT5zvD/3mgL5s2wbWdNnwbz+UNVtLuw7HF73W/95
	OxduKZmV6Xi6AzYWQBEnR/z03lLjgDQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1AFA43E6E;
	Thu, 26 Feb 2026 16:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6ADC2BCB6;
	Thu, 26 Feb 2026 16:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121628;
	bh=T4XOURJp5h6a0W+w6Slhd7r2zVOXmWLyb5oaovUOm6s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HYTbh8az9ttre2WoQ3PB5MGwQxAiiploAPcWAy93PIxVejigQcZDcMkTnfaGW8HgR
	 lTA7Pb1/NOMO83NTvalDUDSElKXMxtvLDHgmXRvT8DZq7TWtAODghENsLgepuGwCdh
	 Pb7MLLg/AFm5mEmSnA0W6cOba53KeeKBRJuWMNOtIkBDyNvU/lFp/7OHDCTFTd8izc
	 YzzeIR3xEvFuqHTvzU5WZ6akTwHBiLw/lG0kXIYOcle1pKp6l2vHhl3PhbFk1DlxXI
	 siJmnZMwWR2mTtQTkRDpA9w8jfwFg86GAPmVFa0vrH2ByNRt7nUjALiU7hMNSkimpP
	 r7/FNozXlhnEg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:22 -0500
Subject: [PATCH 20/61] afs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-20-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3827; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=T4XOURJp5h6a0W+w6Slhd7r2zVOXmWLyb5oaovUOm6s=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0Jd3rTJKBznl41a30r5qtD/z0aeq/r47sgP
 CVEl5KncpyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCQAKCRAADmhBGVaC
 FfTFD/91T+jSkWFt3wxt6E+853oG/5gpw6xS6mUwZV8IgcoYswcYSqbkTpqsCPaikzV0xFXpX+p
 92d/7BN9iTdm3au3BsH44pHnkX7XObNAg9sdTQP52K6DjP4Ufwz7XbXpPc0tQ2fThZjUWNGiOJ6
 bme3H1hM/w0HUxB2616Sz0uqNvSQGjvaUnUv72hTiXrsEkZ4m3tYZDBBP/Uiq9vEV4vgQn99aMC
 JrQDxxuyEz5xnv9psyVOfUi7H8UCZmc0rqJDf7njZ/Qf9W1K1iSTJiCAmz8prECctblCpvbBewD
 ue7i7WUwkbgbb8INumtZy3sWluypc5dMkD1zRITFM7W4trbEHZx2P3g2pJbplJ4SlgpS0ahhVsk
 Shfnhfm7R3smVsVJBsM9s3OmcMuTO8LFbLFyVK6q/6RO5qnx45HwHHsP4oLAs79iBQLqFt93DOa
 iO3Z6XuLlcEM7M2hi90gY2GAKLbiLs6G/QWEpfFC+IVSoCJqXFcBv8vbp5JGPSPrlubPwc1myaF
 TS5RtvR/iXMmTfsM7ypKOkxmThIMIFh/phF4TckHqHH7B8FfxJC+36v9VFeimnBDc92ZfkCM1Ae
 R070EpuJNv/2J3/k9D2zcnmnuhcgE5roc4eEEVayPUeRtrDZkWkX6QNUOAsKz2oJ97LwFSIPkWZ
 xjAju7Q478qpNxQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: x86e3uny6wkt6x7ura7mmou3xi96pss1
X-Rspam-User: 
X-Rspamd-Queue-Id: F38B180018
X-Rspamd-Server: rspam01
X-HE-Tag: 1772121629-928695
X-HE-Meta: U2FsdGVkX19K22PPto+0KcIAyo9PTKSl5TMMBltj70XOnZcggCjNjGvHlNq4CQUlMFcQL3Hs8SZDpQjnttrBSr21DiZ7S0McpT0ZZ/RKreiz9MPl14duDTcCz0gQac0IGFLSpurmOy8tVeWJU0jYsfjMRmYiVfWm6xK8TLTr4WiTrV324EyP75MP9EsJhzz8HBPHDLtPmWBS/3NWLHyQ7aIwtEZSmxdCeneZJSlK17EgHfNdLIn+XTpbTF3cmvn6htbRQmpJtDrlfT5iiQrlwFBH3OclkRIxy5SSu6mRWi09xkJ+5cpS3OhhR9TmHEx7MJmTB/bBaEDKc/bhMJTZ8iPlNk51laBMcwYJcFLIe+EtauA1hSoMeJS+801e4kBPV4dicY/XaEBEANdOCLC30rOSyMJ97nMPCPTDA9CQmo/6mmkR6vYi8RGTpjJzIpxtlNsBARethqvhkkDMnkJEPileihXNJqho59LwcdsdJi7LuNhoSFlDFjk8sNaF9TUnG3JD4snJvwIdXOTq8KqiVmK3RET52dI/XU9eeBxXoledD+3UVqhXHY+kziSHFfOM72WAli9NfyFS1St/Nfrmui88m2eY3Nuhrb52PTuHX8wV+hOkGjvLoSqmqQTbPwozkFcDRa6TrIlYqEB66xjgYiXpDS3Zql4TBT4jtfMngo/HUM6wduMtS98jUTa3w6RPc5b9yGFXhnezWKPhIrikLvkTZX6pncA0avI000n5jmZFaCnFNyWq6j27jCr0cUuf63epFxZkvodnBIxzzzQbU/JEe4kdUlwGVIPRBhF8Jfcqmdg+AnIZkBStkPd3fKtraEXpcy2gdir7o6/ad7w1JDum8l+PLFSVNiRnwU+pAZa8VU1xnGTfxDjfyXlmo1EbVjtPxGFFCy1n7JPMAAYEgyCPmDRq2icyKsKl+SQdozxtdB6h7StgPTjDrp9SqIZGs/4NkBPzbYX3sivASmR
 T1gzBMxk
 8zV0C0TxhRQoP5MyFsIJvEPBL6xW3sg1LxF+iRIcOOiGbgeA4WaxU+NEWj5q441xnaOBweY3qhyJ77nA3paUkZl5VUweaLx8NeeRRppbbi8XZ6Qdp152DBh7Ope4i7/xYRGLZ/OpNQip9cy7KQ/jraZxF1f4uCPLasRlGV6vGAhwxo9x6KLhYTo9cMYV3oSo9BfgvfGIMNWBieePMZ3T61p3rQ5jLxHGc+r942uNNcGsRX9P67p/3RiJNigajIbFIyLvQoYeZTtyyYhB81EvNgmJ7EwvGh3m14O8NG04qGZ3ojIlDpbTy5QKvIYFKvveZHB7LfCye4WnzWMQ6Dlc3C23xvzabwtvkSmNC7yVjQkDWl41LuiIB9ZWqjYPi0d6myfkIUjezfYVDK87adlFJWTs67kjXqQRTDeTfSxM2D+zx7waDwIBFTYH7SQcDSGfVg/cBS4hQJOnw9U+v6qw+AbzMiTA4P5x3LTZS8DX5PDpBUMOXSY9A1k2lq1MuqXeEwG2tXTow3pVurpSoNVDjZpVBW255pUvzXEhrZeBqkC1ueM4NMy02Ir373KRao1KpJiUOXUVBahOAufxznfvGjBYYG2ViXERZIACaOyDbo/QOjYMOhkaYG41393yksFzQIcO2vxnuCIqRMczbO4LQQYVs8SMrWedIbd9nXOk7vwLPvyA+udKU2rpSW+GSVc9DP9yez+j4WsmVbtFglKe7cZx0EA3fCWrSK4IgFWzqYLG4jkeGsv64Xm9Qme3tgy7i/ZVHh8Ri0vbXydJMwei7AuIFOmQF1pUosM1Sd04MHS6TQbmyoewW/1GI3BmjljvhttVmCkTt/XG8FS3sMBHW5KDshnlAxM/2169MiZa0QXElh7FUOkFtIdAdTTgOu0kZ5IT5iRLO5HnPgVSsbEXzrlOwXh97gr1JB7yfTKXEudfFOvxTb9pj85cDiNExCT/TBBSYx+CC0BjXzTXxPaeCpTfrU/hM
 Uyvj5WJv
 Kuld5WCZ7YAnbGLDcl/mXW6xlaIg7Cx40W/NCWeelHPjNE7iehsO/F8iH/NkJlChmxFuQaaTbLDkFymR8Ezg62i1xD5r8oAOojCW2H952InlWQVJDFlX9PIH4SHfKcj6jbL9Met0d1IsT/YFET7pT9XYxFcy3fZ7ZKhWGZlWc+90yb+HyyvnfOInEv8HBjAHtBfrv38Pz1+DCyKC047KqbZB3wPcKZ0rseFlUJildBOcvlhenibsJuBz5yBvG+qQWULfczXVKy5aYtyanqYEy6r8+ttF9rfLpjUUkGaLAKg7uIfeIy/nIdUjFvi8zyOrU58VX33Afx5hyNYPiWE4W1J29j53IvSgXvB44I6d2VsDSWtsk+EJygNH72/iC2M55jbzoLDyTOGwSsflKszuQUbE1aHmbKNw8W/4eoP2wpFCCvGq40rmm9vuUKdMv/sTbCidxZ3Made+ltdTgtWCnArSn7CfdCVTBriAb/Gl7DRy0aFJpUBXBehglKn75JdEeFZMjqKEJ4YGSjOFPta1HvUrkPhz3bN01IE+4awP8+qJwIcAHlVmyCUu6Y1rKaY+j5/zXGl35wIW2lGbhAQa3uQZWy2Cza7U0zEGlPFncVnNCaPtwVZ3bGJErlwLFYsFrdGf2nQeBBeIBJJkxP9f8DVblTCxu+1aLIkxuMSP/dUEMiTB7hBN6RWAwIAjWCKHhCEK9Tc+sUpH5Ve+Mqshx83gJ7JBQcv8uWpEMYUpFKUmyXkv8ty+u4XToaw5aA6jwiVPYgVWoq/CA8SEBqaLkaKhrFlqazzf8MJabWdHVDJPZlnkwsb257mC+Jqh0d2VKlhaEFIPDRbzdAvyMkRKe2UlX4YoMatto3l2LbdWCPG7LPsBlSimyCm09PQH5GhZ5pnQydkdWEG6mn5U79/U7nB7FhFyaHAZXxBZBJ0mPW4MU8g0nu75jubdqCxpy2A33zlalqkdPSgVLunxoviPUsLQsrrMB
 hsQTKuju
 CzCoUYRdB2FtzqgDGLTgEYrDb99v/LoMjP1F+4Gi4h/rkrqCJ30gxnNuLzZXlnJqDYDFdFemxqjZMo+gfFE0QdgmUQF+fgEuOQ+jcI6E3rbWfHEALu3YrnbZJKUCXvWvG9TJyooPv6C/Z3lCeEMsOIUu7qt/h7ykJ2pqOjkckkixtm0F6Ah9PM3hIQAwF6YQ49MfJIy6yT719leOCIBn5Uodgx8SllpJ70vfnrDA4Lso2W1dZxXQmV65eNq/S/ruErtQHkTK9YfX+YdbBvJ1HmXOEl9rRP63RUTptVdq2wkXplcxuycgZlm1FTHsnrJ+DNlyeupqkyaJ+6WUNPNUVuAuUAABddL298cuVbFYMY00UyDbWJV5CZ8NiPO462qE1OfBoMtqHK2R2DzsS1Us0ZlNYoOz7NGpWgrWIoqvH4t95ZKR4D69wRivk3+oMw0OcV4KxfCEB0NyMxuVoxnCl3NP7idV//+hZKtJpBfd5vTe+BYKBsw+8xtySt1Q5SiTn6HFBLk0MVdVeDaYLUPmXXu1G929ovGzj4kDC5x54dr0TG3DzUIcoicmIXO2q1tx2hPBwDYtss+ShXlo0dHGuC7oqRatwOqspcXqKVdgnQV52y5UxYoMm5OVYDGy8SqKfP4HNRTaqso3lFvtc4PXZuNKxLI8nvgcV5/RAuXwEXgob4qV3PzNhKYDIfOqUSp/+hkSPU259wUiu44ijaUATHULMrdL8ii9uu7lTgTNvBLnJ3HtW9NJRJuFcw8ZT0itsTCm2F0cgo4oFR9DU5m49ZT/MsncQFwIpKeGQxlzrCnNE0q/8sZwWZ2sO+IOUNiOeWpUaTJOHVvAhvk+fcNGNf0Z8SU3x1DD1/N3BIB5dlMHWLx6PjrSmdiXLw3o5hGzJdYeWdvCKw8LtfOBHK2aD+nO8KhQEu2UaWiy1A67GOseiYmbijZ+VUl9b155CxRBGRdVa34468ZS9MkIZ9+1aYVgLUZIl
 MV4tDn75
 S1g17OMy1/6yYVmA/p4OF7roBKL5cOEw+8Uetol0a+5ha3AetVRFFGsMMGRBRDKZrl7caaLse5MNPqsCsAS0ZTX6/a/gNYCgTvVkBzQBZA+OXwl1ABPBdZbCxbCd+CNYVc9p2pMEEPECSo/P68BbbBvTGYNJR5agDTMXBF/Dm2+9Edh8a2SBFCBF82l4o80o82F8SZUg/WCihjYF/nIKZ6VY36zSIb+kde+gkMRNQQ0GqZp1fwonHqA6OPi95ktISZZOBTgLYfO4Xh1YYjPmCcCxTD7y5gOXMPCYcwyIp8B5nDmY05D1GFydoJ2WMhTbiIe2L0CMfpzFuv0qW5BsaeWY2q8BPa8WG2OG1NuFbdFYTUg06ewFQFVCLoaYYICZd3iWQfKiu/rvzDNTQ+iWe3kf6wNyd8KxUl1/4q2VPEZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in afs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/afs/dir.c        | 10 +++++-----
 fs/afs/dir_search.c |  2 +-
 fs/afs/dynroot.c    |  2 +-
 fs/afs/inode.c      |  2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 78caef3f13388c5f604e4970bc0874de168b57f3..aaaa55878ffd28691777668261f577d7a9472d6d 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -148,7 +148,7 @@ static bool afs_dir_check_block(struct afs_vnode *dvnode, size_t progress,
 				union afs_xdr_dir_block *block)
 {
 	if (block->hdr.magic != AFS_DIR_MAGIC) {
-		pr_warn("%s(%lx): [%zx] bad magic %04x\n",
+		pr_warn("%s(%llx): [%zx] bad magic %04x\n",
 		       __func__, dvnode->netfs.inode.i_ino,
 		       progress, ntohs(block->hdr.magic));
 		trace_afs_dir_check_failed(dvnode, progress);
@@ -214,7 +214,7 @@ static int afs_dir_check(struct afs_vnode *dvnode)
  */
 static int afs_dir_open(struct inode *inode, struct file *file)
 {
-	_enter("{%lu}", inode->i_ino);
+	_enter("{%llu}", inode->i_ino);
 
 	BUILD_BUG_ON(sizeof(union afs_xdr_dir_block) != 2048);
 	BUILD_BUG_ON(sizeof(union afs_xdr_dirent) != 32);
@@ -523,7 +523,7 @@ static int afs_dir_iterate(struct inode *dir, struct dir_context *ctx,
 	int retry_limit = 100;
 	int ret;
 
-	_enter("{%lu},%llx,,", dir->i_ino, ctx->pos);
+	_enter("{%llu},%llx,,", dir->i_ino, ctx->pos);
 
 	do {
 		if (--retry_limit < 0) {
@@ -610,7 +610,7 @@ static int afs_do_lookup_one(struct inode *dir, const struct qstr *name,
 	};
 	int ret;
 
-	_enter("{%lu},{%.*s},", dir->i_ino, name->len, name->name);
+	_enter("{%llu},{%.*s},", dir->i_ino, name->len, name->name);
 
 	/* search the directory */
 	ret = afs_dir_iterate(dir, &cookie.ctx, NULL, _dir_version);
@@ -783,7 +783,7 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry)
 	long ret;
 	int i;
 
-	_enter("{%lu},%p{%pd},", dir->i_ino, dentry, dentry);
+	_enter("{%llu},%p{%pd},", dir->i_ino, dentry, dentry);
 
 	cookie = kzalloc_obj(struct afs_lookup_cookie);
 	if (!cookie)
diff --git a/fs/afs/dir_search.c b/fs/afs/dir_search.c
index d2516e55b5edb273677c9cedb6f15524bc56348d..104411c0692f570a217d8f0e6fd35818eaa02932 100644
--- a/fs/afs/dir_search.c
+++ b/fs/afs/dir_search.c
@@ -194,7 +194,7 @@ int afs_dir_search(struct afs_vnode *dvnode, const struct qstr *name,
 	struct afs_dir_iter iter = { .dvnode = dvnode, };
 	int ret, retry_limit = 3;
 
-	_enter("{%lu},,,", dvnode->netfs.inode.i_ino);
+	_enter("{%llu},,,", dvnode->netfs.inode.i_ino);
 
 	if (!afs_dir_init_iter(&iter, name))
 		return -ENOENT;
diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index aa56e8951e037b2e3fa9fc452b43e7bd2d61b926..1d5e33bc750224d063446ea952d5ef97a2481010 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -59,7 +59,7 @@ static struct inode *afs_iget_pseudo_dir(struct super_block *sb, ino_t ino)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	_debug("GOT INODE %p { ino=%lu, vl=%llx, vn=%llx, u=%x }",
+	_debug("GOT INODE %p { ino=%llu, vl=%llx, vn=%llx, u=%x }",
 	       inode, inode->i_ino, fid.vid, fid.vnode, fid.unique);
 
 	vnode = AFS_FS_I(inode);
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index dde1857fcabb302cc6b06cc018fb1e4108ec6284..a5173434f7862e92a127994c56b89f530ad4c298 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -683,7 +683,7 @@ int afs_getattr(struct mnt_idmap *idmap, const struct path *path,
 	struct key *key;
 	int ret, seq;
 
-	_enter("{ ino=%lu v=%u }", inode->i_ino, inode->i_generation);
+	_enter("{ ino=%llu v=%u }", inode->i_ino, inode->i_generation);
 
 	if (vnode->volume &&
 	    !(query_flags & AT_STATX_DONT_SYNC) &&

-- 
2.53.0


