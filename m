Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58120EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970C26B0156; Mon,  2 Mar 2026 15:50:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90D446B0159; Mon,  2 Mar 2026 15:50:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CEB86B015A; Mon,  2 Mar 2026 15:50:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 656BF6B0156
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:50:14 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A758B8114
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:50:14 +0000 (UTC)
X-FDA: 84502315548.22.BDF62A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 86B28160003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:50:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mQXhr50r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=khNugZudWESZiAwFc0P7ueANTJm9n8WmeKMlz46cHIg=;
	b=SwZtOwDSvDfqGyeLa/+iJ8V0K4a7Alu5x4gPgclOMSONZ6kSJFbmH2XQVT15yCbCtcnEuL
	jUpIYDDT6o8VL4yErqOGFAzcgYyhBOBKGP6TbeX47JRek65QpkbB92eOrHzDlcyQWp7UH9
	+BCACOdABN2RH4bTLLV6ix7eW36aYTI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484612; a=rsa-sha256;
	cv=none;
	b=C9tQibHNVV3CckZ8YIQSySa/a153KsIx/VbBqezyLpQI8E69E2zv3mdPneozDav8ERfBSe
	SvVZdg/fCngzTG68HKHQEj5piKKYQ2O/QOEzwsmJ7C741E45qokt1ugEkns91DOTOh7fO1
	eFV2vPIXyIhk22b1LybdoYmcvhUf4hM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mQXhr50r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6816861850;
	Mon,  2 Mar 2026 20:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F66C2BC9E;
	Mon,  2 Mar 2026 20:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484611;
	bh=JPKwVFtY7y15aQ0ACp/RNYZdvktcOhYNyEwOFBbpajk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mQXhr50rPhqiJaAE46QOiQaS1GigGjkyfHU3ea3xTGDwDSg8agj+bvmfu8MnTBaye
	 uHx4YUJ72av/YaUG/IWhxpZdm8qR3c6BFTW9Ut82dfdCNhsx4BEExWOLvQxZq6Jw9G
	 MD7rARU6qbSA+OdYE+b0EaHDtIRVRUa0wLLow63W+qb0UzN2PMcHRgq6qwdRB4MQMM
	 GsVH7DA1fdahoGFwNQXviOC6OoZ4O1c5cjj/wfYPqtXBnAAYRaR3RlWIRPMWGxj0+Y
	 Q91z5L3PWaadybVNCcLcB+3tZsv5jATjvMXnDqHhEIdHSBN5EN2s/XLlsUnaPRzW2n
	 7tBeLDlmeJY3A==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:29 -0500
Subject: [PATCH v2 105/110] security: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-105-e5388800dae0@kernel.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
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
 Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, 
 Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, 
 Johan Hedberg <johan.hedberg@gmail.com>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Oliver Hartkopp <socketcan@hartkopp.net>, 
 Marc Kleine-Budde <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>, 
 Neal Cardwell <ncardwell@google.com>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Remi Denis-Courmont <courmisch@gmail.com>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Xin Long <lucien.xin@gmail.com>, 
 Magnus Karlsson <magnus.karlsson@intel.com>, 
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>
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
 linux-x25@vger.kernel.org, audit@vger.kernel.org, 
 linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org, 
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=9058; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=JPKwVFtY7y15aQ0ACp/RNYZdvktcOhYNyEwOFBbpajk=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIMT/IJ3kLMsyWUGkmj+RutCWvyg3pdXWUeJ
 H7H/xONu9SJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyDAAKCRAADmhBGVaC
 FfBtD/9v/x6SpHlOSfRtgdtFXChydGJ/cGAt4/OmHih3k6NV/wtpjljKPdT7Zjdb4vM/BMdd/o4
 JAhmm5IpWH1G+jOCQsYjN3xwArrxf8ryZj5iRaiG4NyWar1Matm0j9mTAX/H/qNcbgdZZYzhHsp
 fLgKEcGnaDnMWCfmCgy2cuh+oTNm+58kA6W4PgVd/ki+3GnYCdcc0Tpj7tU5gON1PwXmCHpykcK
 OOffwvnN2dS4TQBEpVe/j5MQiXBob3RKe93n7sgkj1dq9TEtcnbgVF438aOP/1xU743aj6yGhQ4
 b55WP3ctl83nYaAZ95lSqwEhFEyW7VwXqHG1qa3qeixLYgH5v1yisAIdgnndT7cifui1Wsk2j5w
 c9e4VqpUO6hrueXltvFOSd7I8q5blS56BCPZEMwOgp0u43DapU9PubWIr/HkltUtQnmzNDaJjIs
 aW5op6certMTpHX9PrraMBr/YUFVColSfUR5u2Fc2HasmF46xOxxgrgoVZIFk+u5N9mBnQxJb5T
 N7gvIrulbELxl9kEyuPdwML1vSsKufgZ7J60DKuCHgZqckSpFR75PBjlwTKu+xCa6c1QN+qeA7P
 MHWFgYI6OwzU9ekLenKBJhWxqdJKbk44hkMyOercoxNUkM62lhqVgf5vgvSxytlqwD0SC7gaqaL
 9qZuOp4OR7pRn7g==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 86B28160003
X-Stat-Signature: h9fhjbm4o1imhh5q9ji5pgrkr76ky8yx
X-Rspam-User: 
X-HE-Tag: 1772484612-191752
X-HE-Meta: U2FsdGVkX19JY8KN9X4vtr3bcrXCR4fp8Fqn+Xp4lzdISZ7awRTZ/EfAnGwnh8CXInKX6zx/unIZFdERiFnIBdBsqLAMBZv7CJ1f22HqO86FsAB7NJdyaV6LAtbS5kNdVvK55K5nnLa9Xs5rOBxrr15YkkdcjGCNVsS0RsDV3kiLMLOtH4kXY6e46eJmcCO4tq0M9dYAQjUEtOZcST9THlruwHv++IUR/+gmTfrGIQ1izh3+r2PV1/wohIAR8s6hkuWXCjq4UW/G3mwrkIDTHYtUkSGDcBuPlei4Rgwr167/AhZ71ylUgScnKn5pprApbPdh04m9S42hPgsejzHooLzuc1Tkb6NhT9+g4VuO4D1zyVvs947TUSGfjpnGhIi+cBjtSraCCHM8qN284SJLR6PEw390GoHiYWXbJXqVzLGRrfzkcrvrZon7aFkg5Y1wnEEeXPh2ytvMgQ8EnzFDxUGugr18kVDYhhuEM38eJt4Aa8KdBtSuyHXD6/eCv9EAd5+lz2grT5xZlx3zFIw29WPauBrH7zTmN+rweAU/ovQFhOWJjwVz4CfWw3oNwwsoJSNJqFQWFA7TmAqLLbm8bU9eogdhBHjMFjPcPPurcSqgCsWCpWFAvim2rgL7s1Q4KWuxLv5t1uwhOGXcNvYeYZw0U/yr+48sCki1Tol6e1VVPXrnX9dbrFMMDVH5fwyOr8YNBHLLWdgCQv+ChSysH5oVUZduQInlVfX4uOZviPECe14B6o7Gpb7ne0tZjIrCYtHBQX2tfskmi0TrrPVsyz8NuPtLt7j5s5EWOkcFcrPxmlwVJwEVGJv3UfrIyA55xIDjv/BKn5AMxXGyrB3hAUHxrxu8+N6kC5ygWl0DKGRXtHwEA2zpGf8Do5mQQdzKaB6YQqhejVQrZCij3eHb4TtxoGXBjfRwwnWjO0RlkCNVV+QypQw22JT7rrE/qmfD4t1dQoQizDqaTIygJW3
 82p3Vr5h
 tbv3GcSfMftGZJ5pk1tDakGtLbQtFFcTdS3+hQZsyGBSbXw/bhHKGwnB2TAiq3U6/SMERxFqeReb722ZSVBeCupqiobQ8y0wgD9XvT0OxhgRRgeSiCT5uyUs4em8cnDaiI4xJFnnYInDDsQc9KaJe1EKZZamYZwyxOP7tjr53f70fM3iQzMMbr171/NOATF7rOw87JAThSak/ORAwY6koglpwexYruG23ibdMO2zQigpxDOOIW+AAaFH0KJpNFolc8M3SFNOBZ2QC4DxAQQ52c30b2uEdbJOs+6gkj/FDMYlSk8/NFPDnGtWP4MKmc+M2VpjWfod0mhvm+ErstjgRbRimEIuEjmIqH4m/Nm1pw93cG17yScf51ARjGUSceEgeVty0XhqSL67sIqQwhGA3qxLGvtGQa0dZUVOXig1590WCU+9KlodMKHo3rdbvB7/LV6dCxPqskdCnIwnVaYcqERIUXzT+V4tZtyuwnIxh18v68Xrk74/YM51op84y4yWrnNQy7A+DmzHyXnOl/wtiKTdHdc59AgozJGVMYLvHgjNKoccPwIFGDEagaZ72UPpKpTpoV2Vm6OL/03IZjdCCHzGI9IldLwVeTCwNsoyhCB9o97Ld1IGFZrXdYYwI6GTuaNALfzMJko5fgyQnR7ij/tuh6a6PNob75FQdMIY0QzRkaDcsrMdVWaU6Wcfn35GZkgt+7MTxJ80zRv3K6XE+s7rL+xFfnAWFlDDf02Nvh6Wh9HcjD1ZLe1w7w7xk/gaEv3oOD4yADl5rlZ3hVeNJ77W3BNTiR6Y/P5l320yjc/mRhWZqZOhLIWhgmV4ihoI3wAc4puU/zEraqyuL2ZgK7Vy8z+2M6qL6bLgUBmvZtOV712IrV1nIjciqFWknbf16QDwKkDhdtUOCp6ApfeeZ8Zft5wm9OCaCqS3et3p7vO9ijgTSX4rToA7c0WtomWqp3mh/k8dqSZipLlE53OD281zTaFGP
 O5EhQos4
 uDaTgpeNNTDcYcb6eHe7oDD40b9cjYo24so2qxMY3rw0+y5yinSS7HopZ4Hb64vX2UKAxG0u+X0Lx8LIpVHzw3zv6xDOnN1CuXd3yte2C6KTstS5pu4xCUfw5zqLGYHq1JVNfck/rNnMFxOcF/m7y2cHusG1s03M5epQygBwiOB3iyjOg35fgEu3InwKx/h1MBi415Gvsfujnhyhkza5NDoo4+jRMBorSzfiIOMmHfBZ9jnkA7v0b5cbQtHJ57JGVWxZ03n03L3HI7lxbdk5RY0zGqNCRjXug13zorfpO6YB50wzR2qSbxtLgqrnz5QOmdDXrcfBXTCW3PZC18rkvkV5CfnHt+Yuis3RkyjjAtcse3hYhJJ9k1NqiV1Lwbvt1UOqzXwdIF7sRVvcLjXUKJQjKGo6z+MuWnA5OqOOvKIg/Y/NsDDK08ef1+YmTUPunvpJYhad9/4ChcDyLQC8KtYg/CPCFrLMgJ+ROhQXh95Afs0w8ClHjg5LGmCeD+oalCJ8fM8zIS1qeADbp4ez3tRPFnZYQLlA6EVAyVblN/eGSOaJ4Xi5Si979yg0BwF9RABkLm7psVB1I2Xq8VeH3BVpdxXP0nR7u2+3LpyDFI1zwUYYyjZ/soAjXA5gP683Y1wgUeDm5qsv+keOt3svqXbSBPprAOg6YYaAyOZtKM3mzasnPib2S76wxKLz5j5WN40W10oBWSLg6JbY5aSih0sO6uVKkE0x39GUp5t/T1pQpGJO4K/TmdadUvam3zabAYtasO1evPI/8dLFYJRujrrRUwzLvq8thS4QqPvDEIuGkU2CYpb8BEn1Jyxo8dVuvyZVoUu0g0IIjknGtUiOhd88fGhUY5QXI4Gus70z9GEHphkf9LoFKgo4E5aKovfO/Bybcd8uZ+dU3mmJU8Ndik7/mQXV8gYZysdlK0bfbPlgeXS5wF+QABv3l9bj09tpVEPFDaKa5LootgfHmRf6nQDPNgCia
 Es9yJZ7K
 mwzdwO5zX06KTEthelQ3eFVc8firUYCLJb26CoVCq3RZBXuAS3r/ITMWZUYqlvC456jcx3QX2GDTbfLhs4xrRcPgBFKpWSyb2FI0Vh6sZfS6TbykpgxvISlstqvp+VzDjUcKcAZXpIZ09CvcEpOrt8r6qLdGad0NapbhF+kmQQiqkqk7QFQUxlx3a4TsoFS6DFZpHvUllMxO49O/Gboa0dWYfKBl/qT48foaTiyPsVR5nE6fnro6Q60woeNJ7b/OxjPZjz+f7TmcrbGNSDSdWTm7lIzw5HLa2c03+mR/95sMDdKLBVFwXzoGL6tjGjKSfPjE4rHeT3Essa+NJgrCM/lk1oWOL8/4UYnDcY8Cp2XsnqFcwrgo+aPO00ltYm/vTyppPzwIJ0hqXLGx8gkWexEx22al7F5x5QV8sEGgWqjDUJfw/ajcTC6BGl9N3MvgWF03RHoAV/cmKX6zlIXPIbnvlrXFXUPxIboDBeG4wumRZt98q8FZDHmkP7Mbr1vb99KEGhTp1zsym6eDui5joHfUbER8kt33Q+m0GrrEFgMl5jOKQct77GdVHM7r7FLY8qxXGyDtpBXgV4BVSx5hgjWVBJMv/WZulYT9Qj33u1oLWWPGf7KuUROK7KmyuiyR45MzS82y5Rcrlj9EhsOl8w2anMrAtWLUjWR49cFbWnV9ivPVK2ATUdgd/JOfeUqsAmKqafCsuilpdA76reYIzxsjdw9XKrHSg2P4Mf6jWzu5GZsLIYCCR2oyQis+3OE4bnep+nDYS26zh4LJGdNXFFqU2U2xGARtJtsB62iATJa+cEuEuYTpb5aHHsQp5qYjobpf/8w+6/PKFsE8+uZREdQ5iUAXccmnQ4rPQl4opZxtFA4C/yFi4hf/RyMC+XAwnzvC9IX8l+gD+EFOiMQIAwLUQXbBRtZfRz1CwizTfcSihmt3E6C48NMOJ3fLw8fL/oHkLj8uAO/gzxMKJUfnNNMysgRSU
 0FVpcT5m
 FEsvP/JhoUC6lznR8E4HNhrmFnoXuUAYny+Jxs+oDupUEGxPOY8VCEZCc5y0LtL6i44l+L4GV6Zb5cnZJkHxzVqLRYCdOdTLVjuw1Bc+dpblD5u/jtJ+vIqibyuA2ZD3BO/VrkRtqgPhDqOV5kogY+tm2aBEtJ7wHHdntAYW5Ubh2Cp8ixN3zgxkY4oCVGF8QM36NCkKfVoNBErbD7RDclgDJ8y+NRud3Eqz9+ujwYcamIs4Xm59H32xPoeNiahR1nTxzZXi5emWd8dOoKxd2vArAwctIv7uZOEIBk82ryu5DYn0BKJurtYXTor1H1iOE0y7Kgc09iSqBtSvYqHMvDPWer12kMxuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in security with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 security/apparmor/apparmorfs.c       |  4 ++--
 security/integrity/integrity_audit.c |  2 +-
 security/ipe/audit.c                 |  2 +-
 security/lsm_audit.c                 | 10 +++++-----
 security/selinux/hooks.c             | 10 +++++-----
 security/smack/smack_lsm.c           | 12 ++++++------
 6 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index be343479f80b71566be6fda90fc4e00912faad63..7b645f40e71c956f216fa6a7d69c3ecd4e2a5ff4 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -149,7 +149,7 @@ static int aafs_count;
 
 static int aafs_show_path(struct seq_file *seq, struct dentry *dentry)
 {
-	seq_printf(seq, "%s:[%" PRIino "u]", AAFS_NAME, d_inode(dentry)->i_ino);
+	seq_printf(seq, "%s:[%llu]", AAFS_NAME, d_inode(dentry)->i_ino);
 	return 0;
 }
 
@@ -2644,7 +2644,7 @@ static int policy_readlink(struct dentry *dentry, char __user *buffer,
 	char name[32];
 	int res;
 
-	res = snprintf(name, sizeof(name), "%s:[%" PRIino "u]", AAFS_NAME,
+	res = snprintf(name, sizeof(name), "%s:[%llu]", AAFS_NAME,
 		       d_inode(dentry)->i_ino);
 	if (res > 0 && res < sizeof(name))
 		res = readlink_copy(buffer, buflen, name, strlen(name));
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index d28dac23a4e7cf651856b80ab7756d250187ccde..d8d9e5ff1cd22b091f462d1e83d28d2d6bd983e9 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -62,7 +62,7 @@ void integrity_audit_message(int audit_msgno, struct inode *inode,
 	if (inode) {
 		audit_log_format(ab, " dev=");
 		audit_log_untrustedstring(ab, inode->i_sb->s_id);
-		audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
+		audit_log_format(ab, " ino=%llu", inode->i_ino);
 	}
 	audit_log_format(ab, " res=%d errno=%d", !result, errno);
 	audit_log_end(ab);
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index 0de95dd4fbea15d4d913fc42e197c3120a9d24a0..93fb59fbddd60b56c0b22be2a38b809ef9e18b76 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -153,7 +153,7 @@ void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
+			audit_log_format(ab, " ino=%llu", inode->i_ino);
 		} else {
 			audit_log_format(ab, " dev=? ino=?");
 		}
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 523f2ee116f0f928003aec30a105d6d4ecb49b0b..737f5a263a8f79416133315edf363ece3d79c722 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -202,7 +202,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
+			audit_log_format(ab, " ino=%llu", inode->i_ino);
 		}
 		break;
 	}
@@ -215,7 +215,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
+			audit_log_format(ab, " ino=%llu", inode->i_ino);
 		}
 		break;
 	}
@@ -228,7 +228,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
+			audit_log_format(ab, " ino=%llu", inode->i_ino);
 		}
 
 		audit_log_format(ab, " ioctlcmd=0x%hx", a->u.op->cmd);
@@ -246,7 +246,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
+			audit_log_format(ab, " ino=%llu", inode->i_ino);
 		}
 		break;
 	}
@@ -265,7 +265,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		}
 		audit_log_format(ab, " dev=");
 		audit_log_untrustedstring(ab, inode->i_sb->s_id);
-		audit_log_format(ab, " ino=%" PRIino "u", inode->i_ino);
+		audit_log_format(ab, " ino=%llu", inode->i_ino);
 		rcu_read_unlock();
 		break;
 	}
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9430f44c81447708c67ddc35c5b4254f16731b8f..8f38de4d223ea59cfea6bbe73747d7b228e0c33f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1400,7 +1400,7 @@ static int inode_doinit_use_xattr(struct inode *inode, struct dentry *dentry,
 	if (rc < 0) {
 		kfree(context);
 		if (rc != -ENODATA) {
-			pr_warn("SELinux: %s:  getxattr returned %d for dev=%s ino=%" PRIino "u\n",
+			pr_warn("SELinux: %s:  getxattr returned %d for dev=%s ino=%llu\n",
 				__func__, -rc, inode->i_sb->s_id, inode->i_ino);
 			return rc;
 		}
@@ -1412,13 +1412,13 @@ static int inode_doinit_use_xattr(struct inode *inode, struct dentry *dentry,
 					     def_sid, GFP_NOFS);
 	if (rc) {
 		char *dev = inode->i_sb->s_id;
-		kino_t ino = inode->i_ino;
+		u64 ino = inode->i_ino;
 
 		if (rc == -EINVAL) {
-			pr_notice_ratelimited("SELinux: inode=%" PRIino "u on dev=%s was found to have an invalid context=%s.  This indicates you may need to relabel the inode or the filesystem in question.\n",
+			pr_notice_ratelimited("SELinux: inode=%llu on dev=%s was found to have an invalid context=%s.  This indicates you may need to relabel the inode or the filesystem in question.\n",
 					      ino, dev, context);
 		} else {
-			pr_warn("SELinux: %s:  context_to_sid(%s) returned %d for dev=%s ino=%" PRIino "u\n",
+			pr_warn("SELinux: %s:  context_to_sid(%s) returned %d for dev=%s ino=%llu\n",
 				__func__, context, -rc, dev, ino);
 		}
 	}
@@ -3477,7 +3477,7 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
 					   &newsid);
 	if (rc) {
 		pr_err("SELinux:  unable to map context to SID"
-		       "for (%s, %" PRIino "u), rc=%d\n",
+		       "for (%s, %llu), rc=%d\n",
 		       inode->i_sb->s_id, inode->i_ino, -rc);
 		return;
 	}
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 22b6bd322840c82697c38c07b19a4677e7da2598..2eb3368a3632b836df54ba8628c16f7215ddf3ea 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -182,7 +182,7 @@ static int smk_bu_inode(struct inode *inode, int mode, int rc)
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 
 	if (isp->smk_flags & SMK_INODE_IMPURE)
-		pr_info("Smack Unconfined Corruption: inode=(%s %" PRIino "u) %s\n",
+		pr_info("Smack Unconfined Corruption: inode=(%s %llu) %s\n",
 			inode->i_sb->s_id, inode->i_ino, current->comm);
 
 	if (rc <= 0)
@@ -195,7 +195,7 @@ static int smk_bu_inode(struct inode *inode, int mode, int rc)
 
 	smk_bu_mode(mode, acc);
 
-	pr_info("Smack %s: (%s %s %s) inode=(%s %" PRIino "u) %s\n", smk_bu_mess[rc],
+	pr_info("Smack %s: (%s %s %s) inode=(%s %llu) %s\n", smk_bu_mess[rc],
 		tsp->smk_task->smk_known, isp->smk_inode->smk_known, acc,
 		inode->i_sb->s_id, inode->i_ino, current->comm);
 	return 0;
@@ -214,7 +214,7 @@ static int smk_bu_file(struct file *file, int mode, int rc)
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 
 	if (isp->smk_flags & SMK_INODE_IMPURE)
-		pr_info("Smack Unconfined Corruption: inode=(%s %" PRIino "u) %s\n",
+		pr_info("Smack Unconfined Corruption: inode=(%s %llu) %s\n",
 			inode->i_sb->s_id, inode->i_ino, current->comm);
 
 	if (rc <= 0)
@@ -223,7 +223,7 @@ static int smk_bu_file(struct file *file, int mode, int rc)
 		rc = 0;
 
 	smk_bu_mode(mode, acc);
-	pr_info("Smack %s: (%s %s %s) file=(%s %" PRIino "u %pD) %s\n", smk_bu_mess[rc],
+	pr_info("Smack %s: (%s %s %s) file=(%s %llu %pD) %s\n", smk_bu_mess[rc],
 		sskp->smk_known, smk_of_inode(inode)->smk_known, acc,
 		inode->i_sb->s_id, inode->i_ino, file,
 		current->comm);
@@ -244,7 +244,7 @@ static int smk_bu_credfile(const struct cred *cred, struct file *file,
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 
 	if (isp->smk_flags & SMK_INODE_IMPURE)
-		pr_info("Smack Unconfined Corruption: inode=(%s %" PRIino "u) %s\n",
+		pr_info("Smack Unconfined Corruption: inode=(%s %llu) %s\n",
 			inode->i_sb->s_id, inode->i_ino, current->comm);
 
 	if (rc <= 0)
@@ -253,7 +253,7 @@ static int smk_bu_credfile(const struct cred *cred, struct file *file,
 		rc = 0;
 
 	smk_bu_mode(mode, acc);
-	pr_info("Smack %s: (%s %s %s) file=(%s %" PRIino "u %pD) %s\n", smk_bu_mess[rc],
+	pr_info("Smack %s: (%s %s %s) file=(%s %llu %pD) %s\n", smk_bu_mess[rc],
 		sskp->smk_known, smk_of_inode(inode)->smk_known, acc,
 		inode->i_sb->s_id, inode->i_ino, file,
 		current->comm);

-- 
2.53.0


