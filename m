Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 486F9FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAA816B0120; Thu, 26 Feb 2026 11:04:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E056B0121; Thu, 26 Feb 2026 11:04:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94CE06B0122; Thu, 26 Feb 2026 11:04:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7ECD36B0120
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:04:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 371261B6FE0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:04:29 +0000 (UTC)
X-FDA: 84487080258.11.8084A9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7BF2EC0019
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:04:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iyTB+PgO;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121867; a=rsa-sha256;
	cv=none;
	b=SXtKNUzvGDSHD33I6unJWQLE3r6+IZmO1j2/67k5yABRz4KRNNOh83st2e8l/d/0JHAamx
	/ENQZuyZdxxGLqXs4d+K8Xwd44fG1Lm1H6fHlDnK8gaN8A+v9dUKTvMXzMzDJ6I1edh9br
	kgzURaYs/1mw9DH8WqJ0YFpELEw2Qj4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iyTB+PgO;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S999+9q5EAc1soSpTP5jmNAo+33x2+9Z0bhH2fDe7mQ=;
	b=tiy9QV3UdC0RtMLyOTWCqy9gbL6UWFOgGLoLT9gG7fUyYvSCIEoaohWexvbjt0pW3IZqj9
	HQDXh5FTPVonT4aHTNUqPeIANzPvoz1thyXmr552eHna90NfB6Vkoe/4TCMoHV5pDTkZ0J
	Bu6Hs3J8065Qhdlnhu1a5pDXzkiG78o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E32F361859;
	Thu, 26 Feb 2026 16:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6882DC2BCAF;
	Thu, 26 Feb 2026 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121866;
	bh=3gdRZB/bYaBq74nWKzTYBoxrmHjdrwN42kbAbXUAO1A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=iyTB+PgO5AoaN163AMcsotNvfXJuGhxw2cTMRntNhnt93ETFlbFc3PJnpiI4fcftF
	 QiMVFgL34YT6vMFgDtQ5pp5x3zuFr7xw0xcXxbRPnceBpAmIbSde2MA7Ix6CNLBDxl
	 xfDZdS64xn0x9jcrNDACgBBE+i3GvTW9KLEj9uurSWnH73nLcrxN8bG6K5ps0BlP32
	 hUml2ssxE5ImMag/sNw4Z4Jie9WtMK3TrTfo6An52tCSB6I9GtNO5Z/v0qm5YwD62X
	 TS/Bdak2CFmyn+OOPuqLm9D7AEx9dV0w+c8kCdRe47Z2CmYrXj8sh2cVuUvN7Bp7xX
	 BU59DAM8w9/Jw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:41 -0500
Subject: [PATCH 39/61] minix: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-39-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2322; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=3gdRZB/bYaBq74nWKzTYBoxrmHjdrwN42kbAbXUAO1A=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0OE+//p6uwDvrj0gzItm2YGfi4UxMBXmZ0C
 pGiklI3Fg+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDgAKCRAADmhBGVaC
 FUouD/sF3zA4f3V+06shKK08E+NRNBErpZlePyQWQ2KtTi3YsBwsRapqP1ljo0hPlbf8XOgRPSs
 KWWT43ftfSdav6Mz/lDNUTR2mwgsVazb/FkQWmKzAsc+m+AEVdgUxr7vz27HuQIOpJJwlWbukWk
 HRth2j8IvUo6uiuOBoSZ0oFjPlQWjLQVmvlcfUzpkL7J1Mn2eB7xqhizUoWCSU6+fo8p1gDsDCG
 pLDwiJY669EWlSIP0aMdDDy8ImoK3ngSmxikBLziQ9afCInCr5KeuNfwtDhBUbDAR8NvQEQazk4
 yAbSr5uuOVhe8S6Q8Sf8D9R1KPRHrbd9dVt8uMEsdFtRxI+wDD0n9MWOnZgO/gnqicYyjvizxqs
 SspzvjH+moxKJ0E0NmHt4nSTyNejtNtF+pbXBRcrFN+Jz0K9WQoPqJdcG63LGYRb7KAEmp/8ALM
 50GCfPjpme+Qttn6Pr394fSBJbTVSTqAGIYiscVUGCZJjPQo/XUm7w/9IDIDxAGqKaYq8Qlsqqu
 2YL8VDMlffOar9Mpq0vZub6t+CMlZRCiPGySod1JkezjvHtPl0lriqGHrl+NkvGotWcZ1bI5rlt
 d3UlVgZH5x5bgNfmNJzxgO2vj1etSDC5g62YDX6JkogU++t2RQ8NF31NUf1aLbftqdLoCm3RHz7
 V+TirKKj2qfXDeQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 7BF2EC0019
X-Stat-Signature: 1zc3yjs355hqg1m5116i9ox3ea4qy1jw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772121867-540227
X-HE-Meta: U2FsdGVkX1/ptPqX12TFeGsLmLMR1nOR9oWzrtfQFv2BGEUE/UHuGkbRv+h12VD6CrPWDagwlURJHjzED3hmZ/3NW0Lqy5MBWNSJKW9A2WR0zx/BQSpsOlV5OjIJrfRoRIs+MlC1O8uTOKjfhzFufOyNN4ytR49Qqnno/cK4mQAUpzLQY7Jx3SjtLb6a+9TL+hBSDp5qP+mpus1+rExSaFD7+vJIWj7AeaMa125U8/vHLHiqJMLES+FD6THeG+o0LeAA8PuByXV8J4GOLziA+VuQ+aNpL/Ew7YDEiyCpuicsBnnDjtYjEU3Ks47BbdlWG5AxCXH6aYLBHJuHKCHp4f3nXW+A/WOH+cb94LaZhByA4WDr++5eaNm8zZk9HjE7rSrqFcGa3aOiMURuLQ6DfBFLBeOyPhNpS0LCus3EbvlomrAcubL5tj8mD1EfcfaQFiWELhzFaA9K8BiB3RdhyZ1Xu7cj773LSgFUQnB5B4f0dpABeGLa3xYviq5iNGEJMhHNz3seJh/YyEzdjda8eXkvc09UXnHPZ+UdEFDcgVYMh2GiXJABRlryHk0Y1qoqo/m7GTxMRWfUNWmKxv9F5EVpIOM5TJo+Hrt16uYdEDMoY4RfEyOTB54GhPVLDz+OgcYA8BcSRDOwIyfOezt6QwrNs95u4Hcjx3GROTqIETtELxtMtmMEJ3WqcOBWZl2NB6ei9KYdjaBoPI6/18BcvMpUiJqWpgUzw/p+vDABU/ZK9eQAeN1SolJABs16KIghfKv9Y46VoPppJ9Ba0LLk5omJcElW2sgR7EeiJuhsXwxCp6+LwtLXDLghk+7NRaADS6WKPhw1w5VlQvIBD619kXg4muV8NCKQItJq/OjklLUVp+7sD2vzL9Muf8WYujAeLEoSRQqUmZXqVCyjxe7KfpF7pDHX5zwRQx5sTcNhRLfjk2b748TvD70JBZon2lJ+IYu7cy2Mn88kqW8olHZ
 ONsHMbIg
 sXO3EVHxfqK7c0dd/VwliZ+UtN9v0iw0Wg7gSP8c0PJOYPIkw1N4wUvslEjuuID+Y1S9edTtqaIS9L1JY7/goaoyIy2AjRg+6NTRaOzbkbDubodDwI0THswfl7txcG4fkUIsKzljvLpRgjJLXujDm+ycx0dcOvaVi2LPDPfXhbj40aISxaw8+e+AejmvROx/WVZXrfVCKULp4Ry3SYvCGsL7W8JuWKSUB1JU6FuOs7QuTltjQ+eQShf1pwCHTHnviHdnaFy1/q/apnHR8Cz1xf9GP7Npkq2/QLF+HH3MsQ4JZ2MDFiOcLqw+v0UDsFc3jrl5dgiKHS9i+nf7QaXG3eM+/VjTxEziN+rlRgH+XHLtRs4sqvZcu0v+jVEwdn9/IweArxtIPc80bk48WeUTP0I349z48DPuXKbZjHvVEW4v64aVEsD6ewETAy+/FEJu04KwORiR51ArhCQQGkZFTlTtH8ukXwleklan/j6SmRWs+0QMWOGdsmdoUzowaf9qG82aZ6bpTzpWOPVb8/gSeWYoCKbeThCMg1c4S7OA9U4WZywmHbwvkuCh4eIzYbjWT60dNrzHLMMWNshFkV5dyjijsBQjcVPhRuMlsfL9pTPKG/jSuYVZXfAza36OSueSWM8x0lyiU0z7i3nKOwaQIrU6Xc38h/GwrA3urMsH69o5zRLdQYDXcd04wXECt035v+vdF/YNZ3asNTUlRERtjCtNTkQkOpd9TIzgDh5uocq5RZQt0piUCTK/tz7wY+mlvCCuXlake9orxm8vq9J2qMTFNRATlIXuwAG06QQ4P0CnfMLr+FVBvlLgZlbQWfveWPwFneDEeBuH9Ch5M3ajDpFOHkSAl3iSpvCtU6Oj3+UlPMbm9H3Qaw/6Mjwr78TJW94fSBWe3QvWnlXXVbhvl5AwUYvOZlBc1mb5ZsRfBBd/6FbLWgSL0tGRnML2U0fEBKFghlKcBsHy6oHtHSIAeisNUj1E2
 l1iHI7LC
 6d+BNtQb+JYgjKR3QU8y56owzu0i5WCObSVINaN0OkL+LGisQ9zuACEoBw+8minIsHOgLMRvY7zefDnseRdot1i6kxbsgJmber2v5+mihz/zEmiy2JjyM3zodO1eedCeeQB2Cus4dUiHiNluqVRqkVTqyPM68lZQvbC2XEua8p/wGJrF3CY8FmsCQtqxmxNT5TDcNafeklRAloJjPsG8lbaXvcvyV/5KHlqYULIlkepOSMlhPiyKFTCMyX3IqRxyqQ/ThEAGQFzANzALx2AHyQH5eOsB0yyC5trNjgYm7168c0d6h0rb9b0l5pz4R+MrrC0/dgCJMIzbTTIDYpyqPmmptSFJ8Lc75QhJ9nlIbHRTqzGaY7fs1TFZz2LuS/hxLuGa2hAhdmGR92ALGWeQLUHvJFzm16cdQ3Cndv7h4v2Ryy1WzKPgLX+5jVySBU0K0Zw7XQz1s3iAjEgsBTDPQFw+FFj46WyxHVOI66VW+GvRdGZ9YUq6T3isfybWlZB1xsPWTWSNd69mlahtlZNK2EdqwLEX7FzDGToLzgpUCNdXyk/xLwtbrfJ3R7awewcJUO/X2/ttqUf60D5X2RxuAbopHJvagkmUd7nVWZn9i24eknaPDz1+BAO++0qu4krlWmZub77o8cGrEW4lL1S+3zckElP/ps1K4BQvgqzGoj1VbKrXG3V6iwODmNqTN33gyhkdYP45SDqgeDjAOeXXMAIZNUFDlUI2445HO3B5MbOtQcvaX/y1dMYzeUrO6BACc6WY3GdB7hEJH7/3fhNtkXaJimND5HDGBKO9HTD1REKqhGrkwgf32Y9Pa/QKQ9ghzfObs7D6wSn255qGPgY3yba3dxaVOgGiUSEVTvZDbMR23ahDZnBv+hLyBNNXqV1lCs8na4DlWSCvln4Yeco8oJiF5MmD1rVS+MIBB40ANm3KW3SQMmiamSeY0Q3WM1GLcUwZWK6z+I7zg3h2CWLMHrS9oxmKY
 LIoYiiO3
 ngIyw84Zpol1xLIQ4Kp0FmjVLQFwHHKsr5dDgPhw6WXIgi7HWfgJLBQtNIFEkajUZw0xhJcKsEqA06rU6SJVI8+xbv5Gbh58we7xo1dAEebtsH3NqLeDlhBGe2EPsWhuFsvZVyRZwQOZ0vlEWbUi4jI3ta2GXA0u+Ep1tvtNhq/DMN5/TQG9xDsJlBmN3R5FAH2QpoJkOTzMk2SKpJpn1ufWUN7oxLDuo19v6iuzb/LqCf7poGs/q+BzlTNVrr/uMOwQWZsH9AXOkJiulQzEe6iPqSGfJY1M+2FLQALAHQvEyc6D2hvcrfer25JjGM6B6BxGn2mcnXzfcrKRMilwIHPt/9ny5i0dLZJK6s5ymzK9b5unTX6aqXWjaT28mb4lbY43Bgb9/fGaE/FktI4v0owZuwfbzmf7WFkuk8etRSMLxgxUwUnAQLucZKstCPrZUzXMpmyo0JI4RpR6LUsK+Mze9CTzxa+PsSFHZECllwu7HO7XeFD8lhg/AkTJ4Cb56pCorbJoLf/vTXMulT5v+2Y90RFNqBT/4gDNiILKL+P+HBjP2MZ4aBCLj29WfTtsqhtF1SITjUye8/J7Kg6knL5xwoYhPle1sloKa/Rn6NXQYe/uKdlwBqX1QkdzEh6+PTVtLzneOJbI1iTxjrliyP0I3Z1xlI4vkJOqRFJFLYIYXQldOGMPG48z7nigP5Oyt8GBpv64DwcnJPEsNEWxju/8Rp12iDJH8oyC9K8RCKrCeg6648bX+jOktO67yi0BloOu6SE5LEjddr5XeJgPQ6692hv6r7ZLdN8vtHA+DSsUv8SOHXG6GbRyWBb/BpdwiJ+YTptyikiNuHYEblRfnsOCThvOw1hdO//kpwSPnlvIxkWQf2zP+b0OhsosXO6qGedY9iwbdWnbqwD9FrtNrVFKLH2n1OXcBjie7hZyyCTUfamarNgD05RTyivQXw7E42SNI+7UuCF+JrdMOA/TL+mwWaRHx
 4J2yAgWT
 n4CYllAElgLUy3beir/6X1fJVToR2G91A2IjHcPZSe8HCi2b5LB1rNTUyHwv2xAVahc8/zW/Zjs/n8oNZRlRVmOiGEnPXz5PcU21F+Osbok6L+boZh2+blH13P9fb4zv5E6m6lf0pJTBikuZSqoD2B3Zlvh0RfW88y9fr9PrvhKoBnaXCDeFbLBnqNLSsA8T1cnqCdU1toTd8c8aVzAbKKzX74AjRDuURIeX/YjyQFGobyt10G84DYjMVUMEWezF3wMr/Jk9Vj2IvJpdyuguaw+zK/RuH5gWQX2BEnk2PR4yu8HA2HeQN2j5l1VPhJhBis76eYqn/xIDrTzeyXW6enxQ8AiAZqMiRfenJdnQvNVhG27gBTyDj6X1ROdG+3Cy3Y6KMKVT+Gq1+fBoxkIbNjWx+JBAPiR2hy92Kv1M8w5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in minix for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/minix/inode.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 99541c6a5bbf13f3be27474a316b31d8db9fbce0..838b072b6cf0b54c955320916ac996e72f994a14 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -36,7 +36,7 @@ void __minix_error_inode(struct inode *inode, const char *function,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	printk(KERN_CRIT "minix-fs error (device %s): %s:%d: "
-	       "inode #%lu: comm %s: %pV\n",
+	       "inode #%llu: comm %s: %pV\n",
 	       inode->i_sb->s_id, function, line, inode->i_ino,
 	       current->comm, &vaf);
 	va_end(args);
@@ -520,7 +520,7 @@ void minix_set_inode(struct inode *inode, dev_t rdev)
 		   S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
 	} else {
-		printk(KERN_DEBUG "MINIX-fs: Invalid file type 0%04o for inode %lu.\n",
+		printk(KERN_DEBUG "MINIX-fs: Invalid file type 0%04o for inode %llu.\n",
 		       inode->i_mode, inode->i_ino);
 		make_bad_inode(inode);
 	}
@@ -542,7 +542,7 @@ static struct inode *V1_minix_iget(struct inode *inode)
 		return ERR_PTR(-EIO);
 	}
 	if (raw_inode->i_nlinks == 0) {
-		printk("MINIX-fs: deleted inode referenced: %lu\n",
+		printk("MINIX-fs: deleted inode referenced: %llu\n",
 		       inode->i_ino);
 		brelse(bh);
 		iget_failed(inode);
@@ -580,7 +580,7 @@ static struct inode *V2_minix_iget(struct inode *inode)
 		return ERR_PTR(-EIO);
 	}
 	if (raw_inode->i_nlinks == 0) {
-		printk("MINIX-fs: deleted inode referenced: %lu\n",
+		printk("MINIX-fs: deleted inode referenced: %llu\n",
 		       inode->i_ino);
 		brelse(bh);
 		iget_failed(inode);
@@ -692,7 +692,7 @@ static int minix_write_inode(struct inode *inode, struct writeback_control *wbc)
 	if (wbc->sync_mode == WB_SYNC_ALL && buffer_dirty(bh)) {
 		sync_dirty_buffer(bh);
 		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			printk("IO error syncing minix inode [%s:%08lx]\n",
+			printk("IO error syncing minix inode [%s:%08llx]\n",
 				inode->i_sb->s_id, inode->i_ino);
 			err = -EIO;
 		}

-- 
2.53.0


