Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE30FD8FD0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EDE86B0089; Thu, 26 Feb 2026 11:03:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394566B0115; Thu, 26 Feb 2026 11:03:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276896B0117; Thu, 26 Feb 2026 11:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6986B0115
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:03:28 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6BF08B2B0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:03:27 +0000 (UTC)
X-FDA: 84487077654.11.4033952
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 774272001F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:03:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aFHVn5+y;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121805; a=rsa-sha256;
	cv=none;
	b=lOu8qt6MbL4bYdNZ2NKqmnysZ2Zo+WTYguDwavLUiXfxyxILYLOTb8SEPZ5FyLPmLL98GT
	hF68Uh8IywjpbGTD0CXT1ielQ/H9msgJObBAo9EX+H80qXZKOSbJlMccJdNJHsA7YhQuLi
	T+70iM9KusrL2cQlp8EddOe1L49Z+5U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aFHVn5+y;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2ujPgExd8rNHD9CLg8cZYlsJotDN55wgwju4Cixcgk=;
	b=LrhR9jd+krwjD/VXr4qxuon5kwyU5nw5ieosqo6p9XJpyLZ44+HikbB7swFx/nZFDicsey
	pu1NTSR9LioF376/M9KzcHPIUhhC5o/+bdYLvnWm1jNNzr7kVGMiR3Wyr37oTwH4LaSP9n
	/uU/O2e2Dm9Cu+Bs+LeE6zzMPXHi1+k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 664CF43D59;
	Thu, 26 Feb 2026 16:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119CAC19423;
	Thu, 26 Feb 2026 16:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121804;
	bh=1IUHG0qj9DwKDe8pV21i0BfsnujMolTsgvql5CzVfG8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aFHVn5+ykafFRFhd0msqquxwDkSHW1iNLQPpThJ46xY80BgGw9se/+uID4QKw8voY
	 JBIVHqxM+jpt33W0Url5uVEPDbexrlv4DTSL+r6PzQytuGsisjGBc3NjyzX0PCfgJq
	 oyB7H3LB6vWVA0qHbIyYNyAVakpfDvKdr9z3bs1HHORzqMD1Ca3t6AITx6Mb2i1xJr
	 4eaqqGo6z7j2ZdweIw+Fk/Tkn8jjDWdmkyrSJFr/5O/29zu9ljwvHaYMKfo440j4zz
	 n+NhSa4EVlfTvypb/rEEe/Nss0xmCMzdWLiE1ddLtXvhYRD7IgHKExswidX2e4hPmj
	 KMMGXRWfXre0Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:36 -0500
Subject: [PATCH 34/61] hfsplus: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-34-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9424; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=1IUHG0qj9DwKDe8pV21i0BfsnujMolTsgvql5CzVfG8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0MpBOcUdKLBTbmmPN0jNpJrcykq5KO06rQp
 tLi/hHQ+TuJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDAAKCRAADmhBGVaC
 Ff+PEAC5tkujedJlI5dNofD8jtTXYzd0VpVlyWlSrfhEGqjiHukcPMO0c1zVxH5MXYLkcyVwa8W
 2ongG+07LNoHjWzSlOfbZTYeIynxNz9ziwJ7XuFgd9PC8TpE5meZoxZ+0ccRaYBntRRR4b16gnn
 rKL2DWj9kR6R+vfU7qQ9O8afq0USJ5eHt5a/yVc0zCGZLbVVRtqUuhDO0AU04VICjX2tEQG7CEL
 rMo0bVun85JDOpF0ywj/TvJEXaIalHwU7i/KRgKU46n7sd9b3MUKRVsxAeO5x+bZu84potKQldm
 mWZgA78bdlGr0gsl/hxkIl4tGX7F7aYz2hf2I+3ostgNMwdZy/2Vb9+MLrPcjUmcPR7625jh57p
 7P6bv11Zl1Taz4r4Z9qrJumhPerXLmNLsQV0efRBzHfrFXwy68KZqdMrwHmYEHYF6me+dyyQqqA
 uGAsJMdIi/2We5FfwejdT0bNboCd2cVSr4EQHo7ec6UZeFvVxDNMl4MRsN0Qil4Ver6Ic1+lCgv
 ELHmNCO32Rn+Zf8XeNokgMCvNUdaIE29+Kcmplwx69NKlUUVLBoTfx1m65ZGY/AmBQYK68lfFtT
 ydaRFb6cCt+R0BIT02Zg91pmqBHk3EG9DDuct2OtI4cKzdQkxC8lDJRIKiscAX3+kJ03Geqwc4i
 A3lzjSYyHqWsFFQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 774272001F
X-Stat-Signature: sg9wbre3pgh1ufbb3rs1tibs49osqaxj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772121805-428258
X-HE-Meta: U2FsdGVkX196g7NuDEoUhSLn9r9QA0Uii6Fb4S0m1vTu/vvJWRHWy53Lq+P133Fh2UtWLwmVWbKnFyNAdn2QoddrKc2o6b/0y9AvRPCXtw5pcwAcY0vSi37ICSYmmxap7PlXYrNjZWK7GBPx/cNi4kKTN8kdZib6I2JHJa5hJP0EY9cbIGlfTl/paBdxxr25/yU9gUkyDTeorwxR89DJtXoECuiBai0noPBiJ9Fc5pgXMN+lvc2xtSIJyTnNClK6Qq/vO8GoX28nLHlf01qMgW1HSgfacOrm5ijBMsndVao6jThQvq1XMcxEjmo++AQ8L/c433KJB/Zp+e+Iy85jDGiu/h3BSIWOZouWiGJJ0SXcs4Hu/nCRfEjiR/uEkvKVjyv0A0DRTXR8W/v0D63C1zVy8ah5dfkxnymnnNwlILzyMSKV4JnzSUnfBel7N9af8BHyziZAnKQebie+sqKeaojaPZ8GkHnMcqfzV3c4CZkfZhsdG7/wqP4VEG2Z0XUGnh8FHlcZ7id3BmrcCtxBREa2e8kvQBdePSrrsXzb9AhCjQ1k14MMkJxqWqal0ggchyHTsvG5Yeorwl2+Ue33mFx0UMxPkY76OrDUu3F5pO6We5F5+EhXvFbeRz8kTPrN+wtqkcq2LFIcZ2QBLxyDv40eNkMryP3GagIrsm1Zqho0bNo8eB01S5Htg2WwmhgHgCO7oWN5iCFilo0hfEXnMNBJ6DFLlBLPllm0f65B7ShfEWrUSAqLc/yw9bjOSXJQYoXVh+CZy4LpBs7ZjjsvKGzVy61bbqMiw724KQna+vj0y95Y9S4bZHfw4Ja3Didooe6+Tlb0YTO6mdMlUFYfQa2HspEf9baHFW2wbOyEsTVKaQbh+pu0N8bvbzT5i2FrUMo6uVCphPXWnRJU9oNd/8Gt3i6FPrrIKdmPf+a2f/cuqlmge5wayCpxHAHGOphGLrYroP3Npv0CPNlq8Bb
 QF1JnbLL
 ynBZqR5vq0e6XYBHvNabR9MX5QhyYP1iIM+gL2ZLKS6vjG655G6sPZkZWhESmTHFi/ian6clLHriB626IisNtqEq59PrQS8NcD4ZCccam1L2PzXSLkhmvF1qFOtTOYto7aG2mM3TXXj/krR1akawpaV5BEOXYCq6gUET3wDPZmOw5B/T2WIIEd5HlnenwSqQFxEr81aZlXMfwFHu162hpx7m2phH5rHm/+uMAmT95wgRfvDRYWj8FbNxRagxR1MDC0cBarJL+vS+gWb8Epqe7eNggpdPdCvoPDykTdH1Run7BbWCq6J12/8JOLu0H3iTmzRItzD7vAIiXS7tRJbzhmPxCUzL/03202+NEpjeV7YXfWAmrm2U4PogYZmXihG5eiZJUCSfUNErMLxUqsn/AX2ClO6SiakczdNVgPydp/e9GV31Jjse/eVytSzXLkjc+K47iwQfAukHU85H4T+qh3jeic+yJOg3Bmt/+4uJMioJ4GOUOwg8YbUJelfCTTYk8S+s2DtldumGEVtduFPQS0XrQ11JMpwWxSOaWzjPjLKVpBzSGuNAFcyofRrT/f384UP/6bRQ3HZIXqBibi8R57mc5EOCM9jqKVz7b4RjB/Nj07dY4mTfgYMThkBPBwa4ZqzSCEcNhCU+UQc0xyuvrPQwC+QsJoiqaC0KRXiUxHcQ10dwKVVzzFRFbrVZrfQOoIprqIPk/GsJB/b2Yxg0y2SOYvHuDfFgvnyaq/EmfJIme6jQSBpSruVPWRt7R4xnvVIj/WskehEKlppxnNiOKRaFOMGhg1nYNL9rlO6CvzqgRhoKnBRpZZ9NjCjOHfvphH05Wvjqy1E0tjX75E2C/8RtoaSiJGhmJ29JWMLarUnQfqNV2K5jD4aSkziNg+J5RH5b901jmNamWwIQ3HirIzd4yOJ1eFa4q8njgDuZLMAb2lSnQu5pJglTDhl+QvJcf0ssSiQo7y6uXcz1zgOYR1P2br5lP
 bg4Iv5tM
 7c5ijHjSu7DYI57ty5/aXGo4I2jeGkcy2Xzz9fmqIAjMlDij7wp1SnqNWR/PDuIhQnIR3agcJ5OtDrpDlzCh/+A+4ivUrupm7Z/jKhtKofrTZX5dTmWLOGctrTQzAl4t6PntW0jKH5Y7T74qZ7Job96OYoiYxXFMdK3lgXGDRpIEaSYrXmnCXahB8kbwkykAWkOv0AsJ7SdWmbI7CJ6ttwTWiEnw9VAlvDNwY7EU67TLr0dq8+YofdJdIGo88WXbZqT8Z8g7Yk/lH7xtuMhc5RandbXXFTIsuyhUefGOu1GYfi42O+i2OUd8sPddXWnTJRoxfAgUAN6lINTsRxRRWHdPXJeQx+JKt+m/j1Aksm6PykbWap3Xtt2OwUDSDDrgOsDPaxuUijtqEm+m34XgY1FSUs4vQ+mDQpBjOQANPe/lOvxyiwnuGMeJTMkf9fOM6G9kKpp7VNtzoF04zYVYk2D7pwKI0Gb8qlkfTzLeukQZFExc5gpxPlaq/tqAXecF4OxsYk9rHuEivehSPdIhXRiHE9Iicz7uO0twaIUtRp/3vYuWXaZWepAqqIJZnagt+9QaUSCN9deEW39FZRmZFAVl5qrtQB7aj4HiQmgpdcRJD2UTomJZPDJQr92yZYo8bXtUgy4C+GDqkpW6jVoorxx4+xo+W4+5yaAKq4yIjgGXzI95w2OzQAAgLEtyzkA9t0Hluty6H+JWym6k+g1lADxApaPp4YyiFfAq0bykC/GyghxaCC5Lb/6lR7pqGcxPX21SlFDbRImVD3UPnssXLT/97hFgHe5o5hVJimQ2MnZyJ+HFx8/cZ4aY5R4nRTj9+H5vESlgnUu/BUygOjCcinUBpNV/T+c1cX8pGPQaItLl1e8SCEvxQ9jtnPVTbyaK7gZQYEfQxUWc953hJDbdjuzjQdyNXpFJSIYNwKl4b+h/vzqsZpUPd+iRVqHHqmRlK4lmN2tXJLz/KKp4BgI3y2ycBzElX
 fIbDjG1P
 I12BNbns34QZahDUtbYyEGQa/zvVKLKu0buGCYzie/rBf2b9YBgYwhyT0dFz+O6IXId1tdJEGqGMlBJeq7O7GK+l3Wbeoc4K04AxG4VctLwnw/RXVyeoKcDxQhVLQ9cdeMP3WAQfA8Txr2CX21t6aI4IDA0dCkps7hy8v1wt9djWBllnHpJD5qDPn3B+/TvD420bVPU6uzSzIXuyeZu5D3VxvzDmJtWoJWdjfHt7MgVII9EXkQAxQzsrjEaejagRWmbWh87SeNhO9TlTSBsoxvB83ugz4EwZaxl+kAdzVisVl42N1HDWNqnNOhAYA8GMaULHXj6lVOMyUhNcTjUTkzKdMYJz4ZjvfgeMTUZ4QNthnn126znQ9tBWO1unTkRuyfYKGGxQB+gBGYTGxQ2OkLmq5aanp/79aVihzXiIHZ768ao7fjLLKG5v9WmPOntiGalqTJcK/XahU1WuwjQdGRd/pWIB7spo3j+1rytt3m+CQz+HDbwtS2qIQHCF5IFryWAgnX8px6Hzph9XpfbBlpJdc2lviOx5qcrVey7OljAFd0PGpZt3syskKEjRUR6S9MCmByvj3NhhNksiH5VRG4jg1NvBBT2c45DYzoaiF5uGMkMvV67qvTTdVPnY9zv7a2gEgAMt/8HcwelQwJTyi/8vnazjeEuF0iQd4B1WkRdgVGhZyZOhfnYXyhuPp8JTcBY8KAhHLBqNzOA490U31tSDtdy96Um7qgw2Dze9Hxgw6Q9JQAcd0DWuEVjQnujZ0awF9LV1PltyY8FqZfyapLE9Y5DvVkgPfgBcaW3B+14pwFlJg/sXiAiEoeJGASwFM5MJUHPVN6Dk4FdKtujsmN9CsBHZykfQSJF1rw/f315vD8vYIw3l1fX/bFd31x4Na//5kDpLzv/Kea3NA3BXU05IRq+J71072455Tw0XDski/k1FM43bqrXJiTBA6LYKzAnxlmz9cM7pgw8dMdX5xkwPsu41p
 4cMzGhKZ
 zQ+Y/yPg4Rl1Cq+zp5ufiW3ftCm0PB+NP3/v34cD5J+uj+zM+tron3q+ST+WZ8JIYtYyvsUkarGKJhokxlKnDnClStlItbJqW0RnH16okLogTqb/yCRvUR9avOIVUolUPtdMHoPToz5mu3Vmxg2oafOMiKBdacQlbxmcXL8ULM2PtZpQcPZIa+fu2xx31uZH88CVQA4xAeziVxIi/RFqAuUHBATTWFxdwxdx3y8wRw4MRsnqwsxPZgJtCHQqE+MHnQdqMPJgh+ltoD5k/hzeeik2aDcnS2dc685tEtM86T5skeZhwVKf9cRWzU1g0ldAnAFdYjMAktZh5UlZYv0b7A/QRmZBZkwB0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in hfsplus for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/hfsplus/attributes.c | 10 +++++-----
 fs/hfsplus/catalog.c    |  2 +-
 fs/hfsplus/dir.c        |  6 +++---
 fs/hfsplus/extents.c    |  6 +++---
 fs/hfsplus/inode.c      |  8 ++++----
 fs/hfsplus/super.c      |  6 +++---
 fs/hfsplus/xattr.c      | 10 +++++-----
 7 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/hfsplus/attributes.c b/fs/hfsplus/attributes.c
index 4b79cd606276e31c20fa18ef3a099596f50e8a0f..e3d8fe1e7e75d9895c4ae30810a334412b4c105a 100644
--- a/fs/hfsplus/attributes.c
+++ b/fs/hfsplus/attributes.c
@@ -203,7 +203,7 @@ int hfsplus_create_attr_nolock(struct inode *inode, const char *name,
 	int entry_size;
 	int err;
 
-	hfs_dbg("name %s, ino %ld\n",
+	hfs_dbg("name %s, ino %lld\n",
 		name ? name : NULL, inode->i_ino);
 
 	if (name) {
@@ -255,7 +255,7 @@ int hfsplus_create_attr(struct inode *inode,
 	hfsplus_attr_entry *entry_ptr;
 	int err;
 
-	hfs_dbg("name %s, ino %ld\n",
+	hfs_dbg("name %s, ino %lld\n",
 		name ? name : NULL, inode->i_ino);
 
 	if (!HFSPLUS_SB(sb)->attr_tree) {
@@ -337,7 +337,7 @@ int hfsplus_delete_attr_nolock(struct inode *inode, const char *name,
 	struct super_block *sb = inode->i_sb;
 	int err;
 
-	hfs_dbg("name %s, ino %ld\n",
+	hfs_dbg("name %s, ino %lld\n",
 		name ? name : NULL, inode->i_ino);
 
 	if (name) {
@@ -367,7 +367,7 @@ int hfsplus_delete_attr(struct inode *inode, const char *name)
 	struct super_block *sb = inode->i_sb;
 	struct hfs_find_data fd;
 
-	hfs_dbg("name %s, ino %ld\n",
+	hfs_dbg("name %s, ino %lld\n",
 		name ? name : NULL, inode->i_ino);
 
 	if (!HFSPLUS_SB(sb)->attr_tree) {
@@ -436,7 +436,7 @@ int hfsplus_replace_attr(struct inode *inode,
 	hfsplus_attr_entry *entry_ptr;
 	int err = 0;
 
-	hfs_dbg("name %s, ino %ld\n",
+	hfs_dbg("name %s, ino %lld\n",
 		name ? name : NULL, inode->i_ino);
 
 	if (!HFSPLUS_SB(sb)->attr_tree) {
diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
index 02c1eee4a4b86059ceaab7a7c68ab65adba6fa26..0e961e99b9856ab7d95da5d070b4fbce1e67ebde 100644
--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -441,7 +441,7 @@ int hfsplus_rename_cat(u32 cnid,
 	int entry_size, type;
 	int err;
 
-	hfs_dbg("cnid %u - ino %lu, name %s - ino %lu, name %s\n",
+	hfs_dbg("cnid %u - ino %llu, name %s - ino %llu, name %s\n",
 		cnid, src_dir->i_ino, src_name->name,
 		dst_dir->i_ino, dst_name->name);
 	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &src_fd);
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index d559bf8625f853d50fd316d157cf8afe22069565..054f6da46033404bbbcf299beb5d8765495c0de3 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -313,7 +313,7 @@ static int hfsplus_link(struct dentry *src_dentry, struct inode *dst_dir,
 	if (!S_ISREG(inode->i_mode))
 		return -EPERM;
 
-	hfs_dbg("src_dir->i_ino %lu, dst_dir->i_ino %lu, inode->i_ino %lu\n",
+	hfs_dbg("src_dir->i_ino %llu, dst_dir->i_ino %llu, inode->i_ino %llu\n",
 		src_dir->i_ino, dst_dir->i_ino, inode->i_ino);
 
 	mutex_lock(&sbi->vh_mutex);
@@ -385,7 +385,7 @@ static int hfsplus_unlink(struct inode *dir, struct dentry *dentry)
 	if (HFSPLUS_IS_RSRC(inode))
 		return -EPERM;
 
-	hfs_dbg("dir->i_ino %lu, inode->i_ino %lu\n",
+	hfs_dbg("dir->i_ino %llu, inode->i_ino %llu\n",
 		dir->i_ino, inode->i_ino);
 
 	mutex_lock(&sbi->vh_mutex);
@@ -393,7 +393,7 @@ static int hfsplus_unlink(struct inode *dir, struct dentry *dentry)
 	if (inode->i_ino == cnid &&
 	    atomic_read(&HFSPLUS_I(inode)->opencnt)) {
 		str.name = name;
-		str.len = sprintf(name, "temp%lu", inode->i_ino);
+		str.len = sprintf(name, "temp%llu", inode->i_ino);
 		res = hfsplus_rename_cat(inode->i_ino,
 					 dir, &dentry->d_name,
 					 sbi->hidden_dir, &str);
diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index 8e886514d27f1e5d4d94be75142f197669e62234..474fde1a1653be6cf74b26e757c6d8a6f8d2906a 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -275,7 +275,7 @@ int hfsplus_get_block(struct inode *inode, sector_t iblock,
 	mutex_unlock(&hip->extents_lock);
 
 done:
-	hfs_dbg("ino %lu, iblock %llu - dblock %u\n",
+	hfs_dbg("ino %llu, iblock %llu - dblock %u\n",
 		inode->i_ino, (long long)iblock, dblock);
 
 	mask = (1 << sbi->fs_shift) - 1;
@@ -476,7 +476,7 @@ int hfsplus_file_extend(struct inode *inode, bool zeroout)
 			goto out;
 	}
 
-	hfs_dbg("ino %lu, start %u, len %u\n", inode->i_ino, start, len);
+	hfs_dbg("ino %llu, start %u, len %u\n", inode->i_ino, start, len);
 
 	if (hip->alloc_blocks <= hip->first_blocks) {
 		if (!hip->first_blocks) {
@@ -545,7 +545,7 @@ void hfsplus_file_truncate(struct inode *inode)
 	u32 alloc_cnt, blk_cnt, start;
 	int res;
 
-	hfs_dbg("ino %lu, phys_size %llu -> i_size %llu\n",
+	hfs_dbg("ino %llu, phys_size %llu -> i_size %llu\n",
 		inode->i_ino, (long long)hip->phys_size, inode->i_size);
 
 	if (inode->i_size > hip->phys_size) {
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 922ff41df042a83d47364f2d941c45dabda29afb..02be32dc6833dfdd767c407ec0263485d1a2c3c6 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -230,7 +230,7 @@ static int hfsplus_get_perms(struct inode *inode,
 		inode->i_flags &= ~S_APPEND;
 	return 0;
 bad_type:
-	pr_err("invalid file type 0%04o for inode %lu\n", mode, inode->i_ino);
+	pr_err("invalid file type 0%04o for inode %llu\n", mode, inode->i_ino);
 	return -EIO;
 }
 
@@ -328,7 +328,7 @@ int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
 	struct hfsplus_vh *vhdr = sbi->s_vhdr;
 	int error = 0, error2;
 
-	hfs_dbg("inode->i_ino %lu, start %llu, end %llu\n",
+	hfs_dbg("inode->i_ino %llu, start %llu, end %llu\n",
 		inode->i_ino, start, end);
 
 	error = file_write_and_wait_range(file, start, end);
@@ -639,7 +639,7 @@ int hfsplus_cat_write_inode(struct inode *inode)
 	hfsplus_cat_entry entry;
 	int res = 0;
 
-	hfs_dbg("inode->i_ino %lu\n", inode->i_ino);
+	hfs_dbg("inode->i_ino %llu\n", inode->i_ino);
 
 	if (HFSPLUS_IS_RSRC(inode))
 		main_inode = HFSPLUS_I(inode)->rsrc_inode;
@@ -716,7 +716,7 @@ int hfsplus_cat_write_inode(struct inode *inode)
 	if (!res) {
 		res = hfs_btree_write(tree);
 		if (res) {
-			pr_err("b-tree write err: %d, ino %lu\n",
+			pr_err("b-tree write err: %d, ino %llu\n",
 			       res, inode->i_ino);
 		}
 	}
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 7229a8ae89f9469109b1c3a317ee9b7705a83f8b..b3917249c206c3a25fe98b39a5eb2168b7404dc2 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -156,7 +156,7 @@ static int hfsplus_system_write_inode(struct inode *inode)
 		int err = hfs_btree_write(tree);
 
 		if (err) {
-			pr_err("b-tree write err: %d, ino %lu\n",
+			pr_err("b-tree write err: %d, ino %llu\n",
 			       err, inode->i_ino);
 			return err;
 		}
@@ -169,7 +169,7 @@ static int hfsplus_write_inode(struct inode *inode,
 {
 	int err;
 
-	hfs_dbg("ino %lu\n", inode->i_ino);
+	hfs_dbg("ino %llu\n", inode->i_ino);
 
 	err = hfsplus_ext_write_extent(inode);
 	if (err)
@@ -184,7 +184,7 @@ static int hfsplus_write_inode(struct inode *inode,
 
 static void hfsplus_evict_inode(struct inode *inode)
 {
-	hfs_dbg("ino %lu\n", inode->i_ino);
+	hfs_dbg("ino %llu\n", inode->i_ino);
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 	if (HFSPLUS_IS_RSRC(inode)) {
diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
index 9904944cbd54e3d326591fa65a5ed678f38ca583..c70bb6f494b22b1e3f74e18a9ef378e0c87f8194 100644
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -277,7 +277,7 @@ int __hfsplus_setxattr(struct inode *inode, const char *name,
 	u16 folder_finderinfo_len = sizeof(DInfo) + sizeof(DXInfo);
 	u16 file_finderinfo_len = sizeof(FInfo) + sizeof(FXInfo);
 
-	hfs_dbg("ino %lu, name %s, value %p, size %zu\n",
+	hfs_dbg("ino %llu, name %s, value %p, size %zu\n",
 		inode->i_ino, name ? name : NULL,
 		value, size);
 
@@ -447,7 +447,7 @@ int hfsplus_setxattr(struct inode *inode, const char *name,
 		NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1;
 	int res;
 
-	hfs_dbg("ino %lu, name %s, prefix %s, prefixlen %zu, "
+	hfs_dbg("ino %llu, name %s, prefix %s, prefixlen %zu, "
 		"value %p, size %zu\n",
 		inode->i_ino, name ? name : NULL,
 		prefix ? prefix : NULL, prefixlen,
@@ -607,7 +607,7 @@ ssize_t hfsplus_getxattr(struct inode *inode, const char *name,
 	int res;
 	char *xattr_name;
 
-	hfs_dbg("ino %lu, name %s, prefix %s\n",
+	hfs_dbg("ino %llu, name %s, prefix %s\n",
 		inode->i_ino, name ? name : NULL,
 		prefix ? prefix : NULL);
 
@@ -717,7 +717,7 @@ ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size)
 	size_t strbuf_size;
 	int xattr_name_len;
 
-	hfs_dbg("ino %lu\n", inode->i_ino);
+	hfs_dbg("ino %llu\n", inode->i_ino);
 
 	if (!is_xattr_operation_supported(inode))
 		return -EOPNOTSUPP;
@@ -819,7 +819,7 @@ static int hfsplus_removexattr(struct inode *inode, const char *name)
 	int is_xattr_acl_deleted;
 	int is_all_xattrs_deleted;
 
-	hfs_dbg("ino %lu, name %s\n",
+	hfs_dbg("ino %llu, name %s\n",
 		inode->i_ino, name ? name : NULL);
 
 	if (!HFSPLUS_SB(inode->i_sb)->attr_tree)

-- 
2.53.0


