Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EFCFFD9E0A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4AB6B017C; Thu, 26 Feb 2026 16:06:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2046B0183; Thu, 26 Feb 2026 16:06:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659446B0249; Thu, 26 Feb 2026 16:06:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 503196B017C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:06:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E426E16010B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:06:25 +0000 (UTC)
X-FDA: 84487841130.13.77F7F9D
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	by imf24.hostedemail.com (Postfix) with ESMTP id CB937180004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:06:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772139984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b5speBzLOx9O3ZQa1YCvB0Y54PAq8tRZnmBFWuQK5aQ=;
	b=sb02QUeWXmL/QNWLY07tsjam5uazVa7jeVgn7fG0sQbUJ2bQ1LNLTQIwG/qkNChbPayWpE
	4EBNyafECAC5+9LPVtNE+uuzPgiYTvUhw9v/erFxGKkGfMM9ReJovWsGOuSvmpXnZQrTyi
	OiNKSazN1R07/xGFkcyv7PpC58BW1lM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772139984; a=rsa-sha256;
	cv=none;
	b=XKHKsTA9mx0UaJr8rvA1DJG+gQY59+s8DXKD5+qWgFRUfOW9iTFIPnICjwYeNFndn7UzWW
	QWMt2sJwXw2c9lINVC9AjvkxakjvrGQ2HVUgTsBPC/CLGncDW25tISUGuACgqX1UKf0rOc
	u4PgLlInWBTpMHecbKhX9X4AIJJX8oY=
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 8F3C528F9E9;
	Thu, 26 Feb 2026 22:06:12 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id iWyiIX5CRUJd; Thu, 26 Feb 2026 22:06:11 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 9FBFB29859D;
	Thu, 26 Feb 2026 22:06:10 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cwbgIi8mwQ6r; Thu, 26 Feb 2026 22:06:09 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id 1868E298580;
	Thu, 26 Feb 2026 22:06:08 +0100 (CET)
Date: Thu, 26 Feb 2026 22:06:07 +0100 (CET)
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
Message-ID: <909001762.1963.1772139967060.JavaMail.zimbra@nod.at>
In-Reply-To: <20260226-iino-u64-v1-47-ccceff366db9@kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org> <20260226-iino-u64-v1-47-ccceff366db9@kernel.org>
Subject: Re: [PATCH 47/61] ubifs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF147 (Linux)/8.8.12_GA_3809)
Thread-Topic: ubifs: update format strings for u64 i_ino
Thread-Index: W1YwJFGUiVxHsVs+FtVDAklXBDhaRQ==
X-Stat-Signature: arb9krfj9jpdigmkbeqroxbbr9jycy5m
X-Rspamd-Queue-Id: CB937180004
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772139982-123946
X-HE-Meta: U2FsdGVkX192QaJcd0+XfTla1cFjzwHsnwdi1axJTxY0piRc1wLAFJgowUr72mIieoeua8D5tVJFUqX0HEYMkHDK3cVBEDzhJU8Z1x3Thi+VjDBWur4+/nc2x4oX4i5gO/ED12fb25ECnB8wIanlx3ihvTOy9gcph7xxoye6hOMvNSNeH/GV1gqcLaw5WnbQl8kB5K3ON2OFhq5Fs999eIuc+B5OyBqtEp63lBlkJzJnFiJBIbDtMHRpHJU41Cb3+K04jpqIF12hDvC5Ox4BoJpt7ExlKj0TlhEje8yzWmLvTkGivNIN81CynWn6OkXdwUhaLU8Yef4+Uwc7e3dTcFdZrQLzH9FwJRgUqQyrm239nfDex4rfq1uzet4SQjnllKvnG5/P2kkKWTMn5prwLOGrYAwgwJddh4d83ppvOIy+OV9FLikkskvOi8fixxZjW+rpg+btc4Lji7Z3DyYreyVeYM/oFdGrXKs9kRrM5SEjyCWYbCfrpHi948nPUWOdfi2rZ0rWy8j5PCL9Km06XKlrYHgIKWFsSAuGOd7pqm29PkFQ/wTWDxYamAk6FOUzC/6QCNhjN2TzljFqVfUYBFoJikvnRSZDLU07nfGiRI5wpWFg+TUA7iSgSL7eElD0rVnSQ7JPIBY97GSTVuOYA6gU641RLyNl2ASjSs2OhACOFlBstPjIPVnckJZWmOZiaz+AQubLV/URfE3vh/C9OvSeU7adoL9MZkg5gxL5s9YvoOChZGau0V6GNqxrolMbJJ//xMIAAcQJ1aWptO36ycwmvzjSIqKRuQ3ToMMq5WPP4opBJ8SFkFT5TaEmnpWZDrTLCVtnLBuNaWkI/jd0hYrkdvLcc/qJ4t6c/Vd4k5WM755d8N67T0f9fgbylfwSPYO5IIDb9g+FdvE1QZzl2Z05Jz7R8GkhW4E4fw+bzR18bUR3k5CPMUFoTbL1rdkHaI1N8nQAzVJPKwVAAdH
 8Gucw/CW
 FaDS0Tc9zOhXswRNOByrYLXTVX2+7V93/uJJTX+Uprjt0QblSI8dcqGbk1ks+kjVF1inJ/x6SggQ8C7NbO+QVYpJh7XvBfSggk11FcK8mSmHvRnzwb+ASgBn9jAWTKS34Av1vhmKb0+nJQIffqrnAq9YCoh93dKHeKKDms6ym4eUYXxmhmCNTUp50AyQjNoUrqdGcLvEIkkqlQimY4IDafJHMNs03ibKfdRYSt9lFZFTdZVzo7RA25e0fWnLCRJ/SCpJWhAb3dh8Nedx+vUQmzBasOLuM59Czrc+XJDtflNR0HAHw50oWVPc4DHxydZngw8Q1p5+EQdHwCO/+ibDPgNzXwIRh4de28FA3fbj9bO+fr9uATXev4APQqfmlksXmFb5Nd3fYqQ8BK2pY+Rm0cm7nx5jQGa347GSneQyIh+Hsx3zek0hzacr5nqLuvpGQqPQJGr9W8kFYc3fwYTKBTaZOAeBcxWQvrtkgqeRrImNUIhyOR293N+ERlBWr5YaEklmiTvP0PFeyprB8qm9BbogcaiALkPG9g7xRcpJl8897t1me3/zqmrXvAixPnh4CUjuxlNXrWN7muaY35dG604NHCB77LPQF3zyfWpUe+ZZHQ3psKFQT63NVoF5TnYxXi1Rg5We+s7fX9L+lmjHDTAyLMcCTjiqtzm7ts/7StboFYMt6LwSPuvYnsTXRVmK94ObFDOj+i1APwozACosGDCLVpvjEbe+pg2XKZdl4JDn5+glZigtfhH9/5T+9Kg8zU2QhAoomQWvutEvjwRlw8ojVPi4l3mBRzQt4HIMnJiUB+YO4tUmoh9Cp3zNTqs71YgOdYvpAemTpAkC2xp0x7zEF/XVoPWhcswf9rsnH9nxvKilR1HYIG9McNhesqNM1VoT7OZpXv9LVdMBQeU9zG+A6GBov9OEgp7MZhSXKTOq8LgfeshVEHgNnneZNSBrlWU17LGPCPPZxCRhs/NHlTQJEDVZa
 qpPMWuTs
 LDvTgqjHkJ/0b2yx1CKVIE5/e0l4mEKmcxOlaztZVBvUv/zqA/teKYCAwvG1h2mWLajZ6kpQ4JlXxFR186iyL70hsZtsinQHl42RcuPNxXQKLcGRr+UdzSRoa7sDaj2NAVH5BhfyUKChtAxT1mEbJJBF5uz9MAcVrkKMVzxhh+h8258sR8sC1H+hBrYxY/z0Co7hoVV1ejAhyKe10aWhgi45Ik1UtHNlUaYcm95u/KTkPDDmzPkkcBwqy5qs7TkffvlP1xWt0tmCWgpLTVRBk8XwJ4COPA/mkOVqIUZ2Tpzd+3PFDDuHTI9HvBdHSTeNgq3DX5v/dhXEEUvANr2u5zGAiZqs54V7m5/ywg3LQWh123AT2T5ulyt3sMcXGGcFE+FpJ58Q0JrniJLdYJ9jbtyZcJtadnhVQrDjyj8oa8QjGkzPAeGgWSf4yZDceaLQrXzQBpTDT/D6Mzzmn4Ij/9i6m/7oZJXSFXiye0yJG2ZlKwJHpIqI46s+Fq4f0+J9PlGxy81PccJwWPXuX7UgUApRuVu6GF82ekgvnOGTBCrfQu8vHjpSB+sg3wU+FMeDS3tTjx2WnzFsu9oNtxY3/t60+OIdNRXkpxKdYdtDVXItEIwEp6IMKTA0zXtukmXsNhm+KShjOkkmpxvvgb728cV3Fas9nLITIl6g66PuiaKbfMPThSjxw23GxdMJjnEV48ajYFU2PV0UWEsTAfyrI7eQuaXUHT9HB+U6WbstMvk0VETQvGwQhYfGa47kNGmR73TenTdksWrTkUwFMaKTkokImfhsaGSvO0kvgemvy6dH31HcgjlqPYHhjPNIxW35nAptC6b7px/+vfjlSh22o9JpCaEYAcc4IbMbLBxwdmOol/GuiWtBKBhpkP9whBz2/2aBModa+bfF+Pm9rj+PocgzVAQ8VDCR6cqZxlMt2HkDGpmmg8NJajKWfKhopfJC/C2wuqzqjlNqm2fTrCKVvpoZHve5F
 xZ1eWZkH
 AY5op/l6XDLOvF21dZbSn99GBXTkrZB7B/+gTy5VOs0dUZ5sMibvKnENz15yzq1bCIH/e84RchxWWISUZwlQxr7go7v3uAxerYOxmFcxbmNCKgvjZkGP2595mC1xzVbDkPd0TTBFxKZclS4aY7Zx6IvkqB77oMAUPd56aDz3NH7FWAL9CNihuFwaF+x7xDJgpUUArmqTsof/3LLu52Ig/zK2JO+lbNuAgwNbUrhRAgWkpyY94vC6t6Ijv/QkpKrw7Hv/ixP7DusH5K+9DGx57ZaCA2aJkLKbYZ2PwN4Ql+nTKdv2gPBubnxzj1CzKu0sXMZdoF2WqD6D9G+IlmVd0HCRPMN73giENpJihUYTgTeWILHSg3m0jKSzByTZtCj150Yv07+6PSgqIQ0bkm3K6nhqQhwLQLQtSm7KX34B89zHeW+5L31OCT977wNRuaKx/9Kzx/iej27DrfJ8IVynr/7CXgaBlzaxlf+ehWNUqINFIqzkfUaBFREwyjxWrF+ViUxnXN/RAnW4vZgUN+GgR2ITi3OVrTNjJr9oU2pG9pTBc5ZNqXaWUQC4yMxSONIANCRQy7M/Ae+BpywM7TpiovELeiQf1YgFqXcPN6Bd1UoZ9EZDt5pSglYGwcsqqDZb9hFiewIwawLio23SMWU5LLL0+Z50/iPvJzvNPuEoiNRK7rN7kN+oZlkG18fA5Ri5sCDCQ/wxszgy5FL7Q/mFX8u3VF72+rc/JbekAp354l+gwpNlVgD34SYM4AsqiBxjv0zc5QRXPcJ2b2P8JQMIcnXFASStClwiF2RdQTaT2uRKcW2pNAM4VrwmfIqHpX5nXNgfoOYQ5cyrVF2KmAou3SBB9CpW+++8AzpCazs6vzQIh2ybxI69ovYNPowE1c9WQeWfelwWEbQUmCLEcWwfmAdBojZrnxwh+i6vAZ4SIZ0T44RfY2Udb8Dvc8OcSETp3MfS2lBnJv8MbKCHy03lVA6pDslOs
 0fWHReik
 Pa58gWlqUfPtITovVewZxpsDsJEa0BOgRI3tGGVfkR0qLhtIaRds4TXiplliL4uMTRXsiimld09tKQFFe80O5MiBruYD6qD2ncpJnnjn0hEOEPU5KQAmPnf5GQl/KgMq2s3b7h4MVHHRuP+Al1+lVacJnNvTGSVsgR0EVjKiWHt+i2SBmg4Eiaq1l/QjaxqDuew6eo6OFCfY56YuBlaezWcGZfmbZEhToB9BcmziYkdWz7nMlwfpve88qrzFz5EAcl0hMyqOoQukUYxuTL9I3vWHQPymhtcXBcqhskOn6ntT0Cq5ugSqXi2eg2yUNGGgAAPHXPnJIazYQGdI6YfgnhO97XUM7IvZPzrNFuOMTWoZUOQGeXby8zZTaKkpCUsbHZdTBokgyrcnLx4BnDX49Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----- Urspr=C3=BCngliche Mail -----
> Von: "Jeff Layton" <jlayton@kernel.org>
> Update format strings and local variable types in ubifs for the
> i_ino type change from unsigned long to u64.
>=20
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> fs/ubifs/debug.c   |  8 ++++----
> fs/ubifs/dir.c     | 28 ++++++++++++++--------------
> fs/ubifs/file.c    | 28 ++++++++++++++--------------
> fs/ubifs/journal.c |  6 +++---
> fs/ubifs/super.c   | 16 ++++++++--------
> fs/ubifs/tnc.c     |  4 ++--
> fs/ubifs/xattr.c   | 14 +++++++-------
> 7 files changed, 52 insertions(+), 52 deletions(-)

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard

