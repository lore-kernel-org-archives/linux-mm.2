Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28D63FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A14F6B00C1; Thu, 26 Feb 2026 11:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87FA46B00F8; Thu, 26 Feb 2026 11:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742036B00F9; Thu, 26 Feb 2026 11:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59C476B00F8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:00:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 161541B6EDD
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:00:19 +0000 (UTC)
X-FDA: 84487069758.05.CDACC63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3BA1B4001B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:00:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WKYLjoM/";
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LoyfKAbp4ehnYaDcxGzEKgCVnSF5mqP3RYxvwUEB8xk=;
	b=IG4BmdBJ0nJ4/8cNI4551VU5YKz9YsBQBTJFQcBIDt4ssPDgeF6Q+GU0BCsxpGY4E0DFb/
	njHQFLnZ11wtlUBOKd3/f3dNEkezNY7Ed3Iu4JldZmiJtAGBWdGtdJl0wm+eWCNCVt4dMt
	Rdy77v5USKQBQrOe7LF6wXG9OCaDBas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121617; a=rsa-sha256;
	cv=none;
	b=pjoa8t+6TuQ8fV4wXT3wNA5FtbjJmo8sTzLZx7BeyLa3uOACPZcAXb2dIV2p9aeCJdsSXE
	5dv1+FDmTo9niVH0JuP4E1uj356ga+DUjVNKh33Vr3WTrrHL/CU2efnO7352y45VtK0KXn
	WJpCRDwkBDC6j9jQMLogFMTXMoeIdss=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WKYLjoM/";
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E61E61336;
	Thu, 26 Feb 2026 16:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4361C4AF09;
	Thu, 26 Feb 2026 16:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121616;
	bh=PMTUPg+Vtukd7ZH3GogoOQ4MO2V415SHtzBbqVns09Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WKYLjoM/OQ0ArET9Kvb62cUrV0wnBoZn8f2sBMFTymTNiTJV+uHPfmmiVjrLlwIYy
	 BUKlRVKY5gsHWZ1bbMydTwS4nXnGHW4lWYMMbktPfa+bV8Lz9POKlMsQY7+9OxwmYT
	 RmShAqP8d6HXcNHWVj7XfrCEqoFMTJc920ouIupqQglM74awJf2I4DTUEc7/oBc+Sa
	 O0w6YPanA2fnHqvxpPQpkgp48mpJYdIgwJmYGEtu9bZjpZUKaGSiAsdbz+/3K1kf3p
	 OKL+CNJy+lWJgr7Dd4Sjh7Lla52+3Hc2BJKSoCDfKrMuElkhtY0kdKsghB91ws07ov
	 tCejBPz9D1Oiw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:21 -0500
Subject: [PATCH 19/61] affs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-19-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11775; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=PMTUPg+Vtukd7ZH3GogoOQ4MO2V415SHtzBbqVns09Q=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0I/GZxrTrxW27NqkBzXi03S398C1gpdVKop
 G4gmAuooeaJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCAAKCRAADmhBGVaC
 FZ10D/kBlG801DflhJWEuWomWZV2XI1b2h4CXXT2GzfcIMyoAtutRoW6qzaUgaJBJg1WjikH2Q8
 4y7JHoLr6eWOtVbYeE2FZFkDuiar3DRWM2FF8FrhJLaCcZE1QFgUhk0OyPqK6oo3jhL4fAoS1vG
 Y+1JK1J3GIi8VGzBw9WCHbcIG1JL4c5NiU93mZ0MpkllJ2IZPPKllEJKLY37dtRxzxEi0E7bL/e
 6/GhxrbkJ3LJ3z1SJPmokDcZmVJXb+ThUf3JbEjelMAo+BdspGLJpyNdf7oFrutUhabZDQOUr4P
 0WSKgXM0lqis4STIGE6L6p05JEd/VGFhw+kT+efbTdyxOVILq/7dZd87cA5x3snO2aZ3Ocom1lR
 zVKEmSNvtqO+stqUx1abiUcE4AYV8vODG99mnRRoWUxaX4KUSpioQgUAiSJStFPew8OpT6Mx8fo
 kkZgiz5T/MrL3uvxmwlSbHT93lBLZOsy0acH2U3fbNIpDNGvyiI7nqzCzilfuTZpAwJKGzC6JBH
 cor98pThLAMCmTfHo5wyWb5n1vB/J5ejETlHtbW/YMDj59P3xUoyTSwzxembDQBX+Q6kpSM39+S
 O6q0SEzAZUtwHzj7HIAA5iWkcP1ll15TAtfMWMvoH+N1FYW4bTsAGOBnzihcvKX0lhBj3D1OMh5
 Vij2OwHGtazlRkw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam09
X-Stat-Signature: eixsmhtsibuxza1sttegfk8pk19dw359
X-Rspamd-Queue-Id: 3BA1B4001B
X-Rspam-User: 
X-HE-Tag: 1772121617-601293
X-HE-Meta: U2FsdGVkX1+ubglobNlhVr6FLpof1N3shj5SWwyBuZeOnlsegITPJhnzc2ruvAfJYofpiTzx2foAEQYmtTvLSepxQ2whVPG8d5TFF0zF4WPVKswZhThCN2OWEugOoBt3CQw2mhJVUAx7sO5vDvdgu46RlHLhQDfdulQJxubz7yQm6tFg5/C84XskHs2YtvulTnMBAbxFk3AFSyGYJ6ntQMAJ6z8Xg9Fxvf5CxiKpyrID3DlfXSY8YmU+PqYYWDSQyqYqMBnx+s49+QMtvi3w5tlivs9AOdniuEcZ+YDefMQEOOVnQ/4vzk7TNqFdJZKsZzhZhXjKpMeYXn67GuvMcOVx1EM2u3Pl8I7t9SOeRuSG53pdSqQxfkS1rLIEjfFT5ErK+3HcuxyiWXDPVmVOV/TlMhjc+lLt37KwrhSl18YM1IbXAyULLzmTjzs1mp19W3vqYfMyRhU5zlYW3QvXrTxOOmU397CFfjekfWmbqRoH0ykUStxtdMMZZpFGV0s042RQz3+ye4qHtOAOgu36K1inSbJcw5r1s3SzIS6uO85Q9Fze7pvV+KphB3/CajMrMn+raqE8m+vTlMdUprjmmHmbZhVD1qAcvpViv/tte4t2yghuRPjjfSjurQ+0x70ZU4Z9qg0cW7bB0ZPdUiOLSe2xVqEDHxByBv7iPAc+hC6mT/KrRGiCAs0MUkmOjcKQdVSvoZP1baQSB2V9a4vEkjFZVNZ2ssFRQdTj7XCd6uzSbjTtwk6xRnVOJb8BlxlJMFoBYIb49gxcql3t0iuWbkCuyZPLtz7M/0Gy++W1SZdzkq0L8koTtPfd6eKofmb5nwHl4etSk+T7kQQK5Q1aerBqaC0RVDgB7Hxz8j6yiV4uOXF3E2z3D6wt9rkdyG7VLfXQQ9cKAUkcz4h/ncS9DRYOx5GurkiMBYO0z9ZMkBDWnVMb99xEGHTSy+dabvZY8IVpk420gtmIc86yO2M
 cpihdoj3
 fComDVCrG8wNVFGT+RsIAIRpc6NtU7U/2EvSO+GnTiLPmJeqvmgC0k1d8qPqhz2/INUVJctPNE7A+UPVWSwy5H9ul+jz8gB6WQgPxy+1C0Jziax0es3cQCChT9m5KMSJ3doKqxZQl7Bv2NyFvPPLeDJSi00BV1FWag8GOzfNr/6rc3ZA/HQdMHA0MM480SnvjR/OiDkbefVZZCjpmIwHpbF8KW0Gu8bz4OpRl1NnLjyHVUc5lNpRSyEgnHgY5GYYMEOPXMHS12UrnY2Bat92zT4SJ/Iek8DOQYnq+UJ509J+y5UBQXJTOddWNTHMMEUEFoVCaWIaM4BjYvH09zhKDZGBIUw/QnlQWKSvlbtYJNmYGeQVG+tZOMv10YBbLhMb6xII9aPkvIe2V+6PeyGFtrGuOw9f8S7pJzAxHAwoUs/tPa0AqPBjSnjEdzPXBZf7YnpP12cPOTyHbm3zpfMfPqFykXunjysepCSJduFYWZ1X7fA4KJmCyEswN28uvAi0ybg1uKAYsbR8DA1maNhbi7Z7Ni/wcyHAO3FBbPD4Y2z1rCJIPMIaMfg+uxSCeQQ4K4LiS1M6cHcsWNTECKaJZ99sfChiD11PGqa58hIboBv1NeGB8pMzCIDHRugRFG4StnSvVN6dkvd8bgHv7+DJr9IATKardtLezTbRJ6nItjYoPA3uVsIckdw3TVTAsN62WcOG8y8XjbyUIbRJTptAwhu4wOgyMBCOI0fr76q14XvUAXppQYxYxaGTK8k/7D6wbrGhPaw0nJLJ1sjFn8X/fOgBN88y7xmaHURAN2lSzypFV7s6x0AoI85ne0xrW4tovoaqcBZ3HWApXq/SXuOVNFJwQyplSgJdAZeM8/SaRWfKXCuXBSF2Qh3n86gYdphfnjc9/E7jtCToGulTM5siTxSJISRZHv0my7x5uHI3JCBTfmutRTQX62A9nM4S97eppkQ4W6hTJ96LyfAYUxU318B63GlS9
 2fTCmKkW
 +f2fh8eksZejGKAkAXxQPNf1oKhfI9opt+GZka804/vSnG2SklqpZhpL1RWBEa/iRpzxI5SPKHCis+A22HFGGdVtT+ObNIDFAxAtWzhYz5JRGDAyjZVk5jrIY+gA9T9xpIw1LRqHdBZdZFoSCRqci3w5d17pv0s43NAs9IiCoKxU+rMqcxGJp9yytCbDgpzncc8Lgl//EuP+XalDYjtmtNmNShmYga5KBTZipIOgJ77zd7LbeE0uGD1WmeudowKHmgDyARnFh9H+6OQnnBaWkwqeYT00uPi/PGTBX6dUi2hqki2/7J/bRlwTIkJKQHBgs3GVyVegdbrgJrLHsvsoUHOmIBsjU/zwmwp6+kwgBB+IqhMtuOmmXSMdPK7h54V1msT2J+b66oWZVQXNddkfVLhgLQTXD/5hgr5lTGkXwXFP0zP9Gr75zGAbR/U/TVl9Kmov0MPrzmzwsfNzMHjyxg2FfsWPo+X3ZSHTzsLqN0Lo/C3/nfWQBUApiIwwv6l7n4ObcQks/Eto4vc8JvbekDSlTy0vTxWyOcF30v64z+b6zZIRtFcGfNdXVbj+X0WYEGUJWuRJWzGpc7rIXVP9l2g+385FZZeWsy+z+9B/rP2mNHKUUe4RRy5F4QtBdqVFpOhuYoA6TzBff0SYYpfsXDG6sqY8D3WfHoaKkD5iPYus2fymqCTjH2V02zDToiJL/mundoReB790yLgU5GW/dwOBZ/NVnOF8bOiw1bjv/6q8+Z43uPGJXrIR8//sG4YA4WEF2mtuwNa/N3ywox127WcS7oCUvbBKmQqG4v76VkOOBJ+/5ek4g4LbQGs/nvqhjI8NoA/HRA+VnUFBkPTdoMzSLrp5AzN6DbegHXAKxb4zNp5IHbS3aryJ9yFJ1j2oTdgY1ztTzV/5ZtgnwF/gUQF5loSpldzQNRePZDgCMFZZQf6SllgwTgeBWmllSm60KZSB66OvdJBCVUQY43cjcIDggXzqI
 zWS1YStP
 hYKRdkI0MzcQDvYykodGkypfa7idr1/KLKv+TSPQ0fBB922ZF2cyvMVXco4WGVdKfOYlu3icH8dmhm4Nt6b8kST/vCyclDmSKlVgWVhc/4dOF0cBq0P1SMRurInIq5YKnly+NvfdkYWoGG9/ORALlP+k7oK2GhERutoM7qlCzWnWwisdVv4GxPeMiWl9aMAB+TpPQ+jr2u+S1h4kZcFZUm/s3uVx7dmxGfiOVyfw7F/pVxL9aR6crlRSOufZdmtRslGAoGlyR1WB/vpBWIeWBeO56mewGGHC9D1hTsJ1vyjMyZQ5NF7pPpIcchX6q30fHs7CobOn/4q07uYHI2+uz1rXmcrj+PYccNgB+NVn31yP7v+gAWJq4Ohe3w/4inAIj58032AeXqDjGO7iPB7+e30orE9+YLmnOx/5uoNTCdgn7odYh6MIZKYh9ieiCLJH+M81vA7/NX47PNcfVBKFkZV/wOqxCTnG47/rfCVxzLsXVXV4jX+CN3EfPQWlzOqku8MdPiDg4yIyn6vt69d+VxqmHfNJa1+MZ1ve+wubCEq/HuYquyCIGpmKDQT87Llb1GhwPv9rCR31R3eniOK4A80YGn+xAu4JpJdPAXAWBJ0JC4SaSj2gCztD7EBKrjEkuwdxVIA9iiGuNjF5Pj1SJlxegKDRTzi2HJYHTN1iB6Chqp99JwUeOms2UMViKIBxHh4iFt/DGfhdeH8CwwfdRvXHmZLshIX1z30rbAZjLFKP84pSQhUZXeJAwwBxevJ4WykSW8N4C0r721cJMPF11Nwr1nMpn9Slni4FPxyLdLoIFh1wIOrFNMIZSRvvd5gwJlJlEYmCPeKF+oEMt6HPrZNPWG3NFmlPcwLWkfgGKcKqOkJdqBjPDBMUv0OP9BINXRQMHo3+kEeB/8bwtTXR0RFePR2/8hiwsZ6yX7uUIq4EF7E1tvgXIhArXXHjfihiK383XJzLNJDDBBreYMcd+WVTofeB6
 SUF/Jocg
 vDkWon14R/HLpyVE79g/cSkPMkdtkgT3aHzAQkyErrH9DrHewUsponmZ9wPU9n2wyYMHflQ9V7UA66EttW+J3ifVuyKoAvY00Ngz0YxlWqlr4+VngSYWyXYt+L8VcZrO9NAwI6Ue2B3g/fGi1odCOkmgjpeTpjVYYBpaNX5OedtgJfIna848S18xQhAUu0LqOqWMruIvjJBpK9pgp9GysG+EoCVbTwEDYuvRpD3SB+AqhcoF1UkOvicCP7wEJOMLZB5zSw17lvWnkiPWVoqsfkPGyVwENgQgS7O/Lu/0sSDF0jZJ1g45tA19G2z3B3eFaaf46mmTsZNWgg4OHDR1MTS0NRpUg2T19gBMpHefM5oBjQDIJFOKNpQaybPkouNIMLP4VUCbNp3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in affs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/affs/amigaffs.c |  8 ++++----
 fs/affs/bitmap.c   |  2 +-
 fs/affs/dir.c      |  2 +-
 fs/affs/file.c     | 20 ++++++++++----------
 fs/affs/inode.c    | 12 ++++++------
 fs/affs/namei.c    | 14 +++++++-------
 fs/affs/symlink.c  |  2 +-
 7 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index fd669daa4e7bc951d8d7959c7a5ab1b60b75c61a..868dedbe236cfb284e88dcee3bc50fd9ea4ffe51 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -33,7 +33,7 @@ affs_insert_hash(struct inode *dir, struct buffer_head *bh)
 	ino = bh->b_blocknr;
 	offset = affs_hash_name(sb, AFFS_TAIL(sb, bh)->name + 1, AFFS_TAIL(sb, bh)->name[0]);
 
-	pr_debug("%s(dir=%lu, ino=%d)\n", __func__, dir->i_ino, ino);
+	pr_debug("%s(dir=%llu, ino=%d)\n", __func__, dir->i_ino, ino);
 
 	dir_bh = affs_bread(sb, dir->i_ino);
 	if (!dir_bh)
@@ -83,7 +83,7 @@ affs_remove_hash(struct inode *dir, struct buffer_head *rem_bh)
 	sb = dir->i_sb;
 	rem_ino = rem_bh->b_blocknr;
 	offset = affs_hash_name(sb, AFFS_TAIL(sb, rem_bh)->name+1, AFFS_TAIL(sb, rem_bh)->name[0]);
-	pr_debug("%s(dir=%lu, ino=%d, hashval=%d)\n", __func__, dir->i_ino,
+	pr_debug("%s(dir=%llu, ino=%d, hashval=%d)\n", __func__, dir->i_ino,
 		 rem_ino, offset);
 
 	bh = affs_bread(sb, dir->i_ino);
@@ -147,7 +147,7 @@ affs_remove_link(struct dentry *dentry)
 	u32 link_ino, ino;
 	int retval;
 
-	pr_debug("%s(key=%ld)\n", __func__, inode->i_ino);
+	pr_debug("%s(key=%lld)\n", __func__, inode->i_ino);
 	retval = -EIO;
 	bh = affs_bread(sb, inode->i_ino);
 	if (!bh)
@@ -279,7 +279,7 @@ affs_remove_header(struct dentry *dentry)
 	if (!inode)
 		goto done;
 
-	pr_debug("%s(key=%ld)\n", __func__, inode->i_ino);
+	pr_debug("%s(key=%lld)\n", __func__, inode->i_ino);
 	retval = -EIO;
 	bh = affs_bread(sb, (u32)(long)dentry->d_fsdata);
 	if (!bh)
diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index 5ba9ef2742f6ee5e903b3df04c5f627fc4fc00ae..40bc4ce6af4ac9d8dba81809e22516a58f0aaf15 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -125,7 +125,7 @@ affs_alloc_block(struct inode *inode, u32 goal)
 	sb = inode->i_sb;
 	sbi = AFFS_SB(sb);
 
-	pr_debug("balloc(inode=%lu,goal=%u): ", inode->i_ino, goal);
+	pr_debug("balloc(inode=%llu,goal=%u): ", inode->i_ino, goal);
 
 	if (AFFS_I(inode)->i_pa_cnt) {
 		pr_debug("%d\n", AFFS_I(inode)->i_lastalloc+1);
diff --git a/fs/affs/dir.c b/fs/affs/dir.c
index 5c8d83387a394146f8df2e97af3b65723a076be1..11e2bac2e391896a32109335530a6af5543a0abe 100644
--- a/fs/affs/dir.c
+++ b/fs/affs/dir.c
@@ -90,7 +90,7 @@ affs_readdir(struct file *file, struct dir_context *ctx)
 	u32			 ino;
 	int			 error = 0;
 
-	pr_debug("%s(ino=%lu,f_pos=%llx)\n", __func__, inode->i_ino, ctx->pos);
+	pr_debug("%s(ino=%llu,f_pos=%llx)\n", __func__, inode->i_ino, ctx->pos);
 
 	if (ctx->pos < 2) {
 		data->ino = 0;
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 6c9258359ddb9ba344976dd5a9a435f71f3fabc1..a51dee9d7d7ec3724c642725812415bd33c76273 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -24,7 +24,7 @@ static struct buffer_head *affs_get_extblock_slow(struct inode *inode, u32 ext);
 static int
 affs_file_open(struct inode *inode, struct file *filp)
 {
-	pr_debug("open(%lu,%d)\n",
+	pr_debug("open(%llu,%d)\n",
 		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
 	atomic_inc(&AFFS_I(inode)->i_opencnt);
 	return 0;
@@ -33,7 +33,7 @@ affs_file_open(struct inode *inode, struct file *filp)
 static int
 affs_file_release(struct inode *inode, struct file *filp)
 {
-	pr_debug("release(%lu, %d)\n",
+	pr_debug("release(%llu, %d)\n",
 		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
 
 	if (atomic_dec_and_test(&AFFS_I(inode)->i_opencnt)) {
@@ -301,7 +301,7 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 	struct buffer_head	*ext_bh;
 	u32			 ext;
 
-	pr_debug("%s(%lu, %llu)\n", __func__, inode->i_ino,
+	pr_debug("%s(%llu, %llu)\n", __func__, inode->i_ino,
 		 (unsigned long long)block);
 
 	BUG_ON(block > (sector_t)0x7fffffffUL);
@@ -534,7 +534,7 @@ static int affs_do_read_folio_ofs(struct folio *folio, size_t to, int create)
 	size_t bidx, boff, bsize;
 	u32 tmp;
 
-	pr_debug("%s(%lu, %ld, 0, %zu)\n", __func__, inode->i_ino,
+	pr_debug("%s(%llu, %ld, 0, %zu)\n", __func__, inode->i_ino,
 		 folio->index, to);
 	BUG_ON(to > folio_size(folio));
 	bsize = AFFS_SB(sb)->s_data_blksize;
@@ -566,7 +566,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 	u32 size, bsize;
 	u32 tmp;
 
-	pr_debug("%s(%lu, %d)\n", __func__, inode->i_ino, newsize);
+	pr_debug("%s(%llu, %d)\n", __func__, inode->i_ino, newsize);
 	bsize = AFFS_SB(sb)->s_data_blksize;
 	bh = NULL;
 	size = AFFS_I(inode)->mmu_private;
@@ -634,7 +634,7 @@ static int affs_read_folio_ofs(struct file *file, struct folio *folio)
 	size_t to;
 	int err;
 
-	pr_debug("%s(%lu, %ld)\n", __func__, inode->i_ino, folio->index);
+	pr_debug("%s(%llu, %ld)\n", __func__, inode->i_ino, folio->index);
 	to = folio_size(folio);
 	if (folio_pos(folio) + to > inode->i_size) {
 		to = inode->i_size - folio_pos(folio);
@@ -658,7 +658,7 @@ static int affs_write_begin_ofs(const struct kiocb *iocb,
 	pgoff_t index;
 	int err = 0;
 
-	pr_debug("%s(%lu, %llu, %llu)\n", __func__, inode->i_ino, pos,
+	pr_debug("%s(%llu, %llu, %llu)\n", __func__, inode->i_ino, pos,
 		 pos + len);
 	if (pos > AFFS_I(inode)->mmu_private) {
 		/* XXX: this probably leaves a too-big i_size in case of
@@ -710,7 +710,7 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 	 * due to write_begin.
 	 */
 
-	pr_debug("%s(%lu, %llu, %llu)\n", __func__, inode->i_ino, pos,
+	pr_debug("%s(%llu, %llu, %llu)\n", __func__, inode->i_ino, pos,
 		 pos + len);
 	bsize = AFFS_SB(sb)->s_data_blksize;
 	data = folio_address(folio);
@@ -854,7 +854,7 @@ affs_free_prealloc(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
-	pr_debug("free_prealloc(ino=%lu)\n", inode->i_ino);
+	pr_debug("free_prealloc(ino=%llu)\n", inode->i_ino);
 
 	while (AFFS_I(inode)->i_pa_cnt) {
 		AFFS_I(inode)->i_pa_cnt--;
@@ -874,7 +874,7 @@ affs_truncate(struct inode *inode)
 	struct buffer_head *ext_bh;
 	int i;
 
-	pr_debug("truncate(inode=%lu, oldsize=%llu, newsize=%llu)\n",
+	pr_debug("truncate(inode=%llu, oldsize=%llu, newsize=%llu)\n",
 		 inode->i_ino, AFFS_I(inode)->mmu_private, inode->i_size);
 
 	last_blk = 0;
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 0bfc7d151dcd383af31d1fa41723e7391ec9d4c0..561fc0185e89c47947c83bd1a56cdc8be46f8d0e 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -32,7 +32,7 @@ struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 	if (!(inode_state_read_once(inode) & I_NEW))
 		return inode;
 
-	pr_debug("affs_iget(%lu)\n", inode->i_ino);
+	pr_debug("affs_iget(%llu)\n", inode->i_ino);
 
 	block = inode->i_ino;
 	bh = affs_bread(sb, block);
@@ -171,14 +171,14 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	uid_t			 uid;
 	gid_t			 gid;
 
-	pr_debug("write_inode(%lu)\n", inode->i_ino);
+	pr_debug("write_inode(%llu)\n", inode->i_ino);
 
 	if (!inode->i_nlink)
 		// possibly free block
 		return 0;
 	bh = affs_bread(sb, inode->i_ino);
 	if (!bh) {
-		affs_error(sb,"write_inode","Cannot read block %lu",inode->i_ino);
+		affs_error(sb, "write_inode", "Cannot read block %llu", inode->i_ino);
 		return -EIO;
 	}
 	tail = AFFS_TAIL(sb, bh);
@@ -219,7 +219,7 @@ affs_notify_change(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	int error;
 
-	pr_debug("notify_change(%lu,0x%x)\n", inode->i_ino, attr->ia_valid);
+	pr_debug("notify_change(%llu,0x%x)\n", inode->i_ino, attr->ia_valid);
 
 	error = setattr_prepare(&nop_mnt_idmap, dentry, attr);
 	if (error)
@@ -260,7 +260,7 @@ void
 affs_evict_inode(struct inode *inode)
 {
 	unsigned long cache_page;
-	pr_debug("evict_inode(ino=%lu, nlink=%u)\n",
+	pr_debug("evict_inode(ino=%llu, nlink=%u)\n",
 		 inode->i_ino, inode->i_nlink);
 	truncate_inode_pages_final(&inode->i_data);
 
@@ -353,7 +353,7 @@ affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s3
 	u32 block = 0;
 	int retval;
 
-	pr_debug("%s(dir=%lu, inode=%lu, \"%pd\", type=%d)\n", __func__,
+	pr_debug("%s(dir=%llu, inode=%llu, \"%pd\", type=%d)\n", __func__,
 		 dir->i_ino, inode->i_ino, dentry, type);
 
 	retval = -EIO;
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index f883be50db122d3b09f0ae4d24618bd49b55186b..8705321926007f559bac1af42fbadca8da67afcc 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -235,7 +235,7 @@ affs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 int
 affs_unlink(struct inode *dir, struct dentry *dentry)
 {
-	pr_debug("%s(dir=%lu, %lu \"%pd\")\n", __func__, dir->i_ino,
+	pr_debug("%s(dir=%llu, %llu \"%pd\")\n", __func__, dir->i_ino,
 		 d_inode(dentry)->i_ino, dentry);
 
 	return affs_remove_header(dentry);
@@ -249,7 +249,7 @@ affs_create(struct mnt_idmap *idmap, struct inode *dir,
 	struct inode	*inode;
 	int		 error;
 
-	pr_debug("%s(%lu,\"%pd\",0%ho)\n",
+	pr_debug("%s(%llu,\"%pd\",0%ho)\n",
 		 __func__, dir->i_ino, dentry, mode);
 
 	inode = affs_new_inode(dir);
@@ -280,7 +280,7 @@ affs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	struct inode		*inode;
 	int			 error;
 
-	pr_debug("%s(%lu,\"%pd\",0%ho)\n",
+	pr_debug("%s(%llu,\"%pd\",0%ho)\n",
 		 __func__, dir->i_ino, dentry, mode);
 
 	inode = affs_new_inode(dir);
@@ -306,7 +306,7 @@ affs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 int
 affs_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	pr_debug("%s(dir=%lu, %lu \"%pd\")\n", __func__, dir->i_ino,
+	pr_debug("%s(dir=%llu, %llu \"%pd\")\n", __func__, dir->i_ino,
 		 d_inode(dentry)->i_ino, dentry);
 
 	return affs_remove_header(dentry);
@@ -323,7 +323,7 @@ affs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	int			 i, maxlen, error;
 	char			 c, lc;
 
-	pr_debug("%s(%lu,\"%pd\" -> \"%s\")\n",
+	pr_debug("%s(%llu,\"%pd\" -> \"%s\")\n",
 		 __func__, dir->i_ino, dentry, symname);
 
 	maxlen = AFFS_SB(sb)->s_hashsize * sizeof(u32) - 1;
@@ -395,7 +395,7 @@ affs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(old_dentry);
 
-	pr_debug("%s(%lu, %lu, \"%pd\")\n", __func__, inode->i_ino, dir->i_ino,
+	pr_debug("%s(%llu, %llu, \"%pd\")\n", __func__, inode->i_ino, dir->i_ino,
 		 dentry);
 
 	return affs_add_entry(dir, inode, dentry, ST_LINKFILE);
@@ -511,7 +511,7 @@ int affs_rename2(struct mnt_idmap *idmap, struct inode *old_dir,
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
-	pr_debug("%s(old=%lu,\"%pd\" to new=%lu,\"%pd\")\n", __func__,
+	pr_debug("%s(old=%llu,\"%pd\" to new=%llu,\"%pd\")\n", __func__,
 		 old_dir->i_ino, old_dentry, new_dir->i_ino, new_dentry);
 
 	if (flags & RENAME_EXCHANGE)
diff --git a/fs/affs/symlink.c b/fs/affs/symlink.c
index 094aec8d17b88bab9392abdd497ed687cd85584e..de31ed2e71dfcb71b770a98c9b43a248de8d7041 100644
--- a/fs/affs/symlink.c
+++ b/fs/affs/symlink.c
@@ -21,7 +21,7 @@ static int affs_symlink_read_folio(struct file *file, struct folio *folio)
 	char			 c;
 	char			 lc;
 
-	pr_debug("get_link(ino=%lu)\n", inode->i_ino);
+	pr_debug("get_link(ino=%llu)\n", inode->i_ino);
 
 	bh = affs_bread(inode->i_sb, inode->i_ino);
 	if (!bh)

-- 
2.53.0


