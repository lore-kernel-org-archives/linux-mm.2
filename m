Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 258B7FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80B746B00AF; Thu, 26 Feb 2026 11:01:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8706B0102; Thu, 26 Feb 2026 11:01:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697076B00B9; Thu, 26 Feb 2026 11:01:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5522F6B0102
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:01:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E9631C285
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:01:22 +0000 (UTC)
X-FDA: 84487072404.13.30BBEAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 14B7540023
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:01:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ivmk1v7V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121680; a=rsa-sha256;
	cv=none;
	b=NOmsogTPMZDxJp/Jt2YNYvc+v7WWfJVit/d//rVdnbm+yT09ShQjL0gkbnTCNB9ZnjTDLt
	YES94WYiPmmYBoHkWdoKynul+dRC3JA6DNVnedDEGJ6v0dycPbPLSsBBupMEhjh8Q5seLs
	cUPpalEqmTuFWdHY0N5rdWlQ/mlvoz8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ivmk1v7V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFz/5KKDyFJwt0X0ie7sTH96u/9wUvnP11ZGhBkKsO8=;
	b=07hDqwiWD5hmZf6wc2ca910brBImoZFfjMjU6QXmvgxz1xwV+/Cg2OHA4adSZ0CdUAy17q
	pfzN93hC8UVfMOwupS9SpDc6TMFhzsvVXaf/YK91uMTDMH2LO5sbZkIlb07lMl3tFE/qDl
	ttRUB+iRpInM/Z4ZiNleE4svZ9BR238=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64D4261843;
	Thu, 26 Feb 2026 16:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AE2C2BCB4;
	Thu, 26 Feb 2026 16:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121679;
	bh=MwavyxIYlS9bWn9ErxsqoDmGcaV0lMqgZ3OvxFOJWq0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Ivmk1v7V3CJiICUlcp+XecxQ8lV8EsvWNHo7eR+YxOQbmYtedtALPPtlvxelp6hjh
	 en8jABiMzMb/OrtCHXYcM4ik86k8b/NdKS6iQNsceskhDSrUAGrthU+Mluo9Y3k5OY
	 hLGGzCNMcAx+HcJMRHPgHxCwW6zWxH6VTPO2mshnW9Ta5etwpt94k3KwJKKWDvu9ZO
	 wzvN5qcZ0hcx3Fb9eoFa+y7vAEMv+EMzEtIsC5mu61EwaXjr9g30suDQA0zhULrwLi
	 r1tYEXKRj5sFs5LaOuPmEij4Gg2A3MbYdnp+GKNGqW6icNTxudYs2jchlG7ZcVlSJW
	 TlOBjKksVvQ6A==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:26 -0500
Subject: [PATCH 24/61] cachefiles: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-24-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4391; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=MwavyxIYlS9bWn9ErxsqoDmGcaV0lMqgZ3OvxFOJWq0=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0KNFRsbW5kG/p9PtFPpXWeEzWzPxJtHpHVp
 a6torUfDXmJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCgAKCRAADmhBGVaC
 FbHIEACZSDMJAqAwQ0UXgiwJ0jC+ChGbMCd/Sa5yBvlpCfjSmkn4n6HEjHw/4s1+fMmd0m/LwmE
 8jH1uSEVla1iJBWmZN4Xmpo5/oGmeKxuCJiBT+T//EpjIq1eV366Wwlq7KQ+yOwNIpAewI1OK4N
 PRlmobIu63prMJmjcVGhaMWtjg/olAgXr+44X79kcORF1excabF2OOgoAE237OZrMV/pXS/EyUw
 cRh+8Bqx0o/fII34tA4kAWOou4JBmxxBQGz7pB1yGKxbzrM/hUf1apOp6sY1tIB/EHW+XUJ1135
 UimmosoXllhYTYz7gsjIEu9frAYnYwXkrfuEUag+2PAjWfNTIqHI8PxPEuTcmY6erOvzxw88LzW
 jsGnRh3iUm7XUez/cpw0Ara59XzP/RWYuRYzwSLHWaub8hRyUrvdC/6X6DMrvMmABzLvFNoXMum
 U+NXn/y/d8sMb1KpWcJZtq8Fh4VtPJi9afupJhGnOXq+JGgNjjpUhCxAd3M1JBxNo/ueFIhhIbb
 wwcyV7LsjMJhwseMYJqWooz6vpkd/aGCbLkFfbdVky/iO7E0YpZ10MzPRZpsqsOpn9pAxtkPhh+
 EucWjJg2UwqxM6ydVT7EBx2NgQD6V+NpF2Mg83BX551O6BuZMAl01ktREHrwHp3YwbqnlZsQdVI
 BaUUCgERHQ6vaqA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 14B7540023
X-Stat-Signature: ezge9kdo7ggnjjqmkf5qsperm6qttyyn
X-HE-Tag: 1772121679-796061
X-HE-Meta: U2FsdGVkX19McpsfabYgCKZ3YKYEBiTB7OqnF05RU5IoH4Ak3HPD0AF9tcqhKNIroxY2A8cvXMZNXW0UUG3GJEfBLBe+xKhA93dO5K5KhLdwJNy721+RgXn6vO3+0IuHQZqG4r8rlrY1gv7pxhUSdLN+dO4nCa40cSUTqduRamwtaLhhBgEFczC+YBSval9tAE7leA0Ez8ZsDCUn3NlXq4+sETTrOc4glYJAt45AZ6n6MTq9+TDp1VJ+InKnpBbSBuKh7XXdbG3vKWcZ690P2xP/+s3CZKN9NLYP51BYU1MFKFxT+Ngu+lxPOADQeVApLzHGsmcFv7lGsODNMI8oyKoLZy6Sp4OB8E/okNVycrtUQAJ3e8sJ8k6CQCV1qDPGXrngGSwNxl2zFxRyowJ8X/FR9jchFICbIFf5dzyKDoovwaDAH8HAU6y8fIvmZjKsTrHRLKfTn5KEQ2xmYbDsRDEmeX11jYbyyPW4ttTcy7aWZcfrT2FPJnxb43gNOX2DzYLL85lrJAFapeYl2A2SCYeTSO3wSWeW4xOK3rchbDO9SEXXzt6OOBZx+21z1DrJiYSybYux/b4nn/qUest+Rkabwsr1po//S0KkdtCh8KbjunYY8D3bFyqzDydRGvei2LpsqzXNr+5LNOCBEhSw8KeYu1UtSscV6qkGHERSRbEfim4qQUsEiXjZtltMp5EpQKFBtLmw7ZBFyEdgxWbeLvTm9wVl66QO15t3/ng0g1XfFNU5Xw0e8UtSQCkqcNLq0y6Fv8xyaeMfOqyfMEem/C8ick1+T8FS1FLK1MMKT6dUffVKSqvoGceglOHu66O4jBnXfJQQ/9o0swVTp8j/+FcJ0dlMfolMUowat90vdR8tOj793Rh8rJUKSmDHOqUldVnnQg+B21U2d16WxfyShAVGjh/w8Ap3TA43/T4dOIwLeWXpMoweUyp2UumO+A6F314z47ZaXUlM3EfJIb4
 D0uO46Xh
 M1KjBWVmzUrH70sFzwLmAtKbrVClxRliznasgjKK1lGJehDXZwEpAVmLEqFm8KX0B9E2FcLvNfFc9FAtMwrutfxrElI7/ELsD3c3vX+MSROQZ5fridlEmsMoCZk3kHHKhrCTaJsDGeuY4ihPP/6tc1R7J+R+rssW7wZzsyZXB0b7LrEVcWsUsiPWAu6lyCXJdgwuzhcip2bbHcZrlKg9FPyOJY3UWN2BsCGGStp4AB3G5MZ3/pKGhEkb8pubBu22LtGfIjkMNDx3CzZmPc7ScCQUJnP2LNf9yUIYeShu8IWWaK6fI6dsNd6QYStsgHkdUlA2ID2r6m8+CqjnSi2eUZA2XX48O+pEEuu3h8iM3cLqvRdLJtHUYpher8LyYb5dj2q+0WkjxH7I7pL6xUjFZRWaO6NqU3GG2ffEZBXu386YHtlFuCSMrM6tTeik+NHVJHvXMY9jjlK2lmJ15gPlmMzqGs622yZ3K6DKGdD1tBocaeNnihrs0ZDY+cOnGTvcNYW7sZoh6JpKcZ52WvSfdWd9rQXDuRa1nCOZmdkYGWQ4L+z4e9nYP3KmdtZfrv7mW/gYQ96O4QoVmkTexA0g+JAKPScoYEjod98iTIvB7Zz2b0WikJaGoax0ZGI921eHeRl96XYzKIHPTIDrA7S3KXN82kmA9BfPxH6a+1/DDYGyh9M011AK8Mgkzkvq+tKWbnnClPa9bf3b3VTdlrE6NkIy0pSvkO2AJoEgwmLDy5N9sYFUKwFLvJBSTLMqkORsfmfSvr7w8yKddeM0yb2dnVsWPh7zyuSrdXRfOKuNSGWI5HgySHl5kymv6ce5vwoH21oRJ8cnq0O3BCWprMJ+WR1q4lytQRWWJygJ5UuLK1eft2ZVknVexBoS9oxDz3HcIEANk6HcRVv/PnqW4Qn3C72uF6twLqK22GQNTBe0vc8hUnpKBWAWvVXVEeutoDGfCWekmNcZRVwWyasF6/72jRmyPCVFk
 VkKoYEyt
 Rtxm4wbodECA+23E9Yux4SNnh87bkMjh/Zybc0JnLoeT9GX/QPryvzeF6B7Pq2EdsZYM6S931PO3G8H6EQWgQ58n4Cf8MtMj/zIY1tyNG3u7zo7fjbr7U6yo+0OaJhcd4W7Pz5daDJSqeaRL/hPARFTyzHQqLp4G4DNvbo4ocMmdnYafmZr5NVFEdM7JvKQyYwShBzgqP6NfoVbgmLSoftG+dLSW9FtqEWPcN0SEvrbsbElXEbJE3KJOZvU8k/lyVNkb40tdH5r7QBDxP78mFyNDP4kPFE99So3kEt5+45goi0WF5UQ9bSh27x+HH76lUsrq0QD7KHcw1IJf4hC7pk5stO14RgEKb9DDf4xSn6NufgJ8vbQMUfcoybg5RVeUrGhIKZQhLq7g8FWhwxRSw8BEzyVtu1Efk2840G0ITTkHuOFO90ywp6rk2okRUjY1EL9eUTtqwRJVp6Xqj7b60As2EcXt/Y+YEiaQsKMDRzpccTV/tV58rdP/uX+I5OD8SbddIjmoT/yKz53QjnE9z42dWCPqps91oXXO3f66mp1kbEQGgN0OUUDEtPTj7XDElttJYwoCR77NnbPR6RKZNhc0I+/lXT2p91FDd2jnV1xb5sVPFbvgU23RvTKj+2p2jB1Duu6qCY6k+VH1oOSeIeaiLPvBk/glcrtvi2DYmQ2xi2E/6VqiwY1Wm1apisCbWA3Qt8PRY4eiasAGVhUGIOM9dxUMyH6a8XjHzARnpkhb3Ja50fv/JP4KWUizjN1u/sK+DiOMlYNXD+tEbH7LXHJyaE53XV6rWDgWcgBkKkYHVvNqq6OA5ZRjzDgs48vhFYnDIG/AkpWs2ra4zcsl4GM6vZwuqywPdvi4gH2OqnFdLTiN4tQlCZzRfqELL76I9SRHp4ETCk2g98uHp668nAzHN0Qdebjnp/Fnh/FryiVm4/79mYFRBGwvOS0kvzNLGGvb0WDrrmuUFmA4/drOQXeasDDsT
 Wxhy085I
 1aWnRP57/qLaM2BJFio1oQagb38j7+xj+oKBYBE+Y7SeMMHmdhxxUfBvBYO7OehO0d5tx2trSK1x3e40XzGmr8ODJmwtvjbdnrOnVrs+tWvnLb/39V0QIx+2JENfZvkoTb/fFw5SZM7B/AyTeeTmNe4kYEiqppGwS4xuNBt6EI2o9Em7wJMHC5tXSPy90Gg54o6at32R7xI1od8vBkwf7X2l5bXQ1orWooB48ZOzptMq3tJIp0W22UkneFtZfQGVXFQW/8BGMBtbIxZoQAm4d3MJiejvmDBWtyYVyBnvhDLd0SWGJsOWRu/A4HDfbs+IkY4oyeWFcHdZDBopLdfh3jtjny02sjQZKhHXpqyyJVBd3mbNKKttqB0/irY4SmraLLiHsCJA+Jftpp3w5Sj08EVYqzR+TK82uknpVGr4KKRxs0D+ygFwM+6Gn9gBNl5hEBy+RsDR90UmYtxwPlVLzj1/HQdtufVgqT+636Dww+PsknU+iu723OHTPk004NpXFao8CnicKtfacll8CrUvdp1FPwZcwBKUHp+o6x+7mr3Iqd+73XmQ0CbjBq789Znrqu3rI2hIQQNySeE9Zp2PEfgSimxiJcu4EAPF+0dmK2P4LGk/tRG49dI2RyX0bsLxgVPrYSr7TtvSMCztgT1Dfjcpo/I5cAcEeEZ8FascDDcYiosLdN+goj9ELID6w2FuMC6OHte6mXN4wJgPsJGSkYTd5wTTk7OXDHzasvbjTcA/kONzPfchTCH6SrPe0eEwZX16dEx6iLNApqgZ97WOAsm1NCovOhqghOP5tpX6m3metugl0KdldDN+dZy/LxXHA/m5igudcLb0UMNv2JUgjctczvJINVHKU1cLSwuvTEisxuTxThRrtsodeF8YeCfCan5o9x9ltj2aayOWe3j2PNXp4K4Cf8YI3R5R86XKuQigpp5FrxbqnCwQvd2UDzGGetSxwmvQVJKdtmId0fcqWsaCL1seq
 NJdRfiJV
 ZeEysbOpmdJ25k0Uv+s8VksDlAZEn+NxIUwe1vBAbzi93TbRymvmNSJxDEgfIyV8VQbxQvPjPUu2qhSHrREmIRki6WQOgF8r0u0mTUCvpzi1CQtJiXKD9fgXuro7zGPDRqujOv6pRR4FICkFqXZA9V9cIYvTiBC53VZzrzOg29EFbhaVoDikXAbLGV5WOlyQYSPJ1Gi2dAfMEAYk0ukn+mTMBidyv6SdmLBI8acVXjWQyDkt+Uh4iR4vDIr/4y8drgSZV9I6oljW7EwWTEcjPsWa2RBJ8XksZZrQzl18SPS7m7LCbSHjZ7B1f4sI1N6Qs+BUFR23yTxliVEhr8uexTVp4+z1FzG7Sux4LtFNbGnh/uBCwkHNTFsukV4rV5qhNqVLMT6d2lMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in cachefiles for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/cachefiles/io.c    |  6 +++---
 fs/cachefiles/namei.c | 12 ++++++------
 fs/cachefiles/xattr.c |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/cachefiles/io.c b/fs/cachefiles/io.c
index eaf47851c65f4736a7a27f13c498028c7c8dd1b4..d879b80a0bedc95533ce05361ed8cb79c7ed3826 100644
--- a/fs/cachefiles/io.c
+++ b/fs/cachefiles/io.c
@@ -93,7 +93,7 @@ static int cachefiles_read(struct netfs_cache_resources *cres,
 	object = cachefiles_cres_object(cres);
 	file = cachefiles_cres_file(cres);
 
-	_enter("%pD,%li,%llx,%zx/%llx",
+	_enter("%pD,%llu,%llx,%zx/%llx",
 	       file, file_inode(file)->i_ino, start_pos, len,
 	       i_size_read(file_inode(file)));
 
@@ -214,7 +214,7 @@ static int cachefiles_query_occupancy(struct netfs_cache_resources *cres,
 	file = cachefiles_cres_file(cres);
 	granularity = max_t(size_t, object->volume->cache->bsize, granularity);
 
-	_enter("%pD,%li,%llx,%zx/%llx",
+	_enter("%pD,%llu,%llx,%zx/%llx",
 	       file, file_inode(file)->i_ino, start, len,
 	       i_size_read(file_inode(file)));
 
@@ -294,7 +294,7 @@ int __cachefiles_write(struct cachefiles_object *object,
 	fscache_count_write();
 	cache = object->volume->cache;
 
-	_enter("%pD,%li,%llx,%zx/%llx",
+	_enter("%pD,%llu,%llx,%zx/%llx",
 	       file, file_inode(file)->i_ino, start_pos, len,
 	       i_size_read(file_inode(file)));
 
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index e5ec90dccc27f71dc19219f7632f3e48eaf51545..4fdf7687aacb8285ae38d9b5d7e5129897b3ca03 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -147,7 +147,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 		}
 		ASSERT(d_backing_inode(subdir));
 
-		_debug("mkdir -> %pd{ino=%lu}",
+		_debug("mkdir -> %pd{ino=%llu}",
 		       subdir, d_backing_inode(subdir)->i_ino);
 		if (_is_new)
 			*_is_new = true;
@@ -158,7 +158,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 	end_creating_keep(subdir);
 
 	if (!__cachefiles_mark_inode_in_use(NULL, d_inode(subdir))) {
-		pr_notice("cachefiles: Inode already in use: %pd (B=%lx)\n",
+		pr_notice("cachefiles: Inode already in use: %pd (B=%llx)\n",
 			  subdir, d_inode(subdir)->i_ino);
 		goto mark_error;
 	}
@@ -183,7 +183,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 	    !d_backing_inode(subdir)->i_op->unlink)
 		goto check_error;
 
-	_leave(" = [%lu]", d_backing_inode(subdir)->i_ino);
+	_leave(" = [%llu]", d_backing_inode(subdir)->i_ino);
 	return subdir;
 
 check_error:
@@ -529,7 +529,7 @@ static bool cachefiles_create_file(struct cachefiles_object *object)
 
 	set_bit(FSCACHE_COOKIE_NEEDS_UPDATE, &object->cookie->flags);
 	set_bit(CACHEFILES_OBJECT_USING_TMPFILE, &object->flags);
-	_debug("create -> %pD{ino=%lu}", file, file_inode(file)->i_ino);
+	_debug("create -> %pD{ino=%llu}", file, file_inode(file)->i_ino);
 	object->file = file;
 	return true;
 }
@@ -549,7 +549,7 @@ static bool cachefiles_open_file(struct cachefiles_object *object,
 	_enter("%pd", dentry);
 
 	if (!cachefiles_mark_inode_in_use(object, d_inode(dentry))) {
-		pr_notice("cachefiles: Inode already in use: %pd (B=%lx)\n",
+		pr_notice("cachefiles: Inode already in use: %pd (B=%llx)\n",
 			  dentry, d_inode(dentry)->i_ino);
 		return false;
 	}
@@ -657,7 +657,7 @@ bool cachefiles_look_up_object(struct cachefiles_object *object)
 	if (!ret)
 		return false;
 
-	_leave(" = t [%lu]", file_inode(object->file)->i_ino);
+	_leave(" = t [%llu]", file_inode(object->file)->i_ino);
 	return true;
 
 new_file:
diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 52383b1d0ba63d4a09413177d8c0d841b5b5b43c..f8ae78b3f7b6d368526a86b454bf0febd1ccc509 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -179,7 +179,7 @@ int cachefiles_remove_object_xattr(struct cachefiles_cache *cache,
 			ret = 0;
 		else if (ret != -ENOMEM)
 			cachefiles_io_error(cache,
-					    "Can't remove xattr from %lu"
+					    "Can't remove xattr from %llu"
 					    " (error %d)",
 					    d_backing_inode(dentry)->i_ino, -ret);
 	}

-- 
2.53.0


