Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A624FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB626B011A; Thu, 26 Feb 2026 11:03:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75A76B011B; Thu, 26 Feb 2026 11:03:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2A3C6B011C; Thu, 26 Feb 2026 11:03:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3056B011A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:03:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3BDE7B832E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:03:52 +0000 (UTC)
X-FDA: 84487078704.22.2399BBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3A6EEC0008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:03:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcTCpPsq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121830; a=rsa-sha256;
	cv=none;
	b=dcpX1q1frPiP0a/2k8i/nB2GDCeJa+iRZTFiki97CeGCAWoc1v3x8cZNguGyic3j/w/gPS
	23GBGHmm/hC1Loj70kV7sy9mRXGkrDCuNoPRAfEKU9KYNX/RABQiPB6beEg6WSJx1zB3DW
	Y6EWl88zIjqp/1SmwJZeboLd7XfcylU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcTCpPsq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hVL6M10p06QMq1LWsT2V/3RrX8xk8uE97/jXlA0WolU=;
	b=enowqbquHQW5Ij+54+C/X2+owXc123+v8Yxvi/YVpvgZBCM5m9FuFZUdCzUwqvhtYPgyeC
	KCtLPAoGwD4SN5dYORD5hTpQ3VSAi1G/mYPFvoSjzkdLSFee/LOcjnNWcBaQc88RnEPrfV
	RhPT1Qbkt2lHPp/2GqxNkzHHjxVo1ao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 55900437B8;
	Thu, 26 Feb 2026 16:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2E7C2BCB3;
	Thu, 26 Feb 2026 16:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121829;
	bh=7ZXyl76yXKAVgEB9XnfKu8Y7KFxyRRm589E8p3gkT2s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KcTCpPsqT0E5ocLxE89k0oKhHGVx7VoQTn3/uYe5/qXwIXPvYdQEwFRCyS6KM1cNQ
	 zBEzmngpDW+7qc2cn+9opn0tPt8pJ7awOyzzo0R5hQL5PQdk4CPX09raGl2N5LarlE
	 7+YA4JD9zTwdj4F6AXiUzJ9Vh7bLryWHvL9ZqFHCerZTQRHd/fYOQx7E1Wh7ou7xgX
	 BxRLHJs9N2l7iFfbzvFtwyb2aFJy0N6n6b9nIrxXFd0GZBeTaQbiZSvOMvGG+M89eU
	 MR+4+e3oV4GpXdunFeQDn39GpWw62ct90x3cMW7WCAK3bvjdi6sKTZKRMHVG66nLiR
	 F4O2Jt9m7SwHw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:38 -0500
Subject: [PATCH 36/61] isofs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-36-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3467; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=7ZXyl76yXKAVgEB9XnfKu8Y7KFxyRRm589E8p3gkT2s=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0Nmf52pdo656jlWG4t6yni37xfclzHx2ZRe
 Hw1/6GQjdmJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDQAKCRAADmhBGVaC
 FW3AD/9rOAXtG95ctw6n0QBFd93xKDo7vJh93xVrf1hM7M7M9YqMLCRzKaYvrvf8+yQ1GDCcm3J
 S/+kU0HuaVEfXXKjGWe8VYJS5AHh2kuXydz4f8AZaFEh5T3E/tj5W6xHU2l3kMYX9rKqM+TLKUV
 6eDA2MJcyUi8LBzCkaElVmMUIuvbHvuj5FeqDDymRc0g5DEq88RLsQafiDn+oIBtQav0OwofD/H
 UQA2j5KV382N7yGCPNhG0xeX70APRR15I5Jkkh5E3JyUIUuJ/dgFHSNUFUvA6gV7BOMc9T75Idw
 /HFKLptC7dGdiHO2WKVZBqq3/xTN6Dy8AiyxY/qR2SBAPlRvyagaRa5sg3Nh5fqyn7rEO+K1SWz
 p2A0gQ+Pf1CwKBuynNegFK7pPKf29/drS5qS45bhHmF3NH/U2HdfJL4P6FzfjulDLVEZChFiqJr
 Z5Qok9gagjzuWpfkx9r97B/LKvi2+qoJXIwoRY4kPevQhamlcZ5ep4h5Af18MGgCCLLFoT08ZmV
 qUabhq/rjFG0UEiy72/s0O3dRIfUi16mLehRNeqlBe539MhbgGK1XFlaDDUVcGvzWA9YBWDWwBb
 bIZSztIcE7iXdNRY3OdAt/IfwuQbe0vr8GuaY4IIHodKPolCQQghHhemHJpZ91FU9wQppzWJQ2Y
 BHEQ22WX0qewrzQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3A6EEC0008
X-Stat-Signature: enxjmk7pgi3juggxxboopwxptdgfrixn
X-HE-Tag: 1772121830-531174
X-HE-Meta: U2FsdGVkX197BdA3fYNtQHC5aP1nX7cH4an15Afs59ZkYnnwnOsYhaZb9bm2Gecva6uQlipbEaCWwaHfNjXZgSizupy0rvFuIfAMaOJGlno0yUKwdkTD5crMnNst1BADZ9LybTPa16plriSLyYUt9SL7qaZkaeTqUU/u9YR7jLBBTOrE8tWv4PU37KGdyL7C0SMoZqglPQQuu5UZs1QCP+3bGEcdqAiVMe61VW5w/t4Ec3LMMMgODQllqjZsLDVmiB/7xNU01YDRaqzsFuEzMbIguP26ua2Cs1/xDZBI8/9lBODXijz/dxWQcDk/xX+s2yhS44X8KaVAmeynTjpNB62FSXWTlrBJW4s1zvToO3SK72xFFhpraHLplUSpF/pCccZft1JVd1ilpaIuOB8UbuHyeFsKFWK570KZVAgxrbTb745CErd34W2I/W9ruREDkqTXf8u5V50USYhA3EGXG6UFg2A7CzqapwcMqtvG3dTjEhpDEoqz79RRhcHPDS3LcbHrjnT1hch48tSm1DnIGgjwvfkrlzuJsUcn911RTfugCtnMTuIU0qVpch3z9oMAC3PJ3YQWEfZX/wqpAsiEo1P5u5lUg6pUs3TfT/9/1zkWyQfVD4ilrsGKnCTpkDAPx7JNQNi4biLPPsp/A0b/Czm5k4ReYEKw0qEvaRbb4OQK3mFc0589NAQcTdOXGNzFawAYp8Vwh+uv5c6QNIa3KgQySrxg8df4oweT4biOhSpXuGugS9e+0KIeppZbZWnlB5Xk+U6XFvvTqVzloAJ8ca4Jg8KQlKDwzhBGtZ+aDsRBjzYnfp4Ze1szy00ItuqhTZMT+rwfx1qLBkNRDO48d5+iS73XB2AoFPCJ5EqrNXlx+VZhsV0UGqBPMB2DbN6GfO7cQnX4ufM/FJiYDssw/t3+os3X0/lBaSKTf7vw/K0OdgEjzXg4HKit5Nnb+dWFD5MjCjR+Y6u6Bgl4ouD
 13l8QXk4
 z3XvXSea4dleepn4byVmFvFtPlkZ/C48wgPw0J+d5At7CD15h3B1p1/SVp9wRXYdqANI29gdr60EWelQJoxkQttjij0ngQO/XHyawg/Nlv0p+z5KC20i840MSFAWey08jgl8BghfCcTPO8YqXlbZVjRTCc3HjAkKm9CRck9FoYIjHRzUFl9GuFEtJYCX5WNL1Xljjz+lp1E0wUQC3ql0yqIvHRVhZKC5l259LCL9JwzGwv9AvuL72utEUd4Z4U3RV/M7cAIfxos+++xJM4jlR70syAMtZwjh6udfJrgBnao28ssxCuYrGiL13XwNykgO7u1bg9cgD7AsN0qqzBytCj8OI0jVz8/5O9vA+zNqt1lsb7dT1NaDW4c7TNlxEEFWLNSzUAZChBEZL+8Rs54jFUBfqhUbzae+iVd7tGbrQGX/tGF6n8RPVV2IhXZQfDVj3OuO/S2CyN8D7EDxtVX+9STFAGcNdNSHQjhXE/URXcgyTB/fu24XPGvSJMid32nCgu29OK7uyjkybk70aQXSCGSi9iZtCNNtOJVMLwe9206VrLiiwQnrWXRsc26fFl6B+P6BTWXq40zuatI7hCnPfJOpwfHyrw73qWjywjkKxFZbjP2fqyJJf70felGruFz917ET9pFXG4ZLanVBmZVCaJZWUB/T220XjXe1AXpxMkRKKRqK42JrPTANsGSuPmfn+QimGyn5xP9UwjZuSUIUaez4UZdVKg9PNkS0rng0qWqnjGisoOZnUexgj6y8qxgWlWWi9txxkoESfCZdTEIjjPN2dSLT+EWBb/AzTBHi32ObZ+cdNsSUjWHfwTiR/Y+h6v/7fz4OmTzWaudmG0mKqB9JDiFZISNNfd8AgElS6mJrB1DSGmZtS3VscLcObGkd3Xtz27tz9qel6UCz6nD3AP4z0O2JDxPbTqCLGb5UEPlPdfqYUZCHq1Uvd/qo9SQarJzN3fT8dEA6Kc4N5qIBZOn8TOXb5
 UeYkxMuN
 9xUu864V5k2ZLht6krOK3OyDJRfDK1Kmim0cqgg6wi4D94Y7E4ODgA4g7ljYLEtrRUTdONh4nT2ht1xYu8Lw4bw7RgPXZ+ClFzYZCZA0IF8LGAvIaQe0WB8CQkJHSmMqMe/NjkQfohlib3vhsCQoWZtbtloMUuldZokUEM2FIHNBvKgaPrv5Y1ukKZhQiZNo5fl/lTi7p/IYNJIHNUUwQohLPAoDA6AEJfO/hAFQ10XkKt+1pJxtdjLI9jCvitovZ/uwQcDgxMQ4IlUlmMu/VnL4JocEN0juv2+JKGYvpomfdyCiDntzDmRcksL18Tj8jH402bR7Ht/YvsbY6yfE/6fHeJzio32Mz3gGNQHDsoj82B8Yx180CEl5y2G2vWo5Pw/k07bEtEbfUnTaYBmxTGu8WrkLDfjJsZwK54xEOwO2HR4zED/VIKhzC1iqQacL+yZUEvFEYyFHaTSGEuO9/ouDD3+eGF45qVDBLcqlZDAHlKgNt8kTOnAUmlP9udXlfyCqZU32ijazZIAJ17L2+yxcwc8LHQN/eW9wm+xEtUbatsEv9XfN3NcnTR4nUn8cNhdAqZlwVZDfG8J3wTlGCkK/Jmdcn/Q29YGzjOuB15lvrg7gZBma6ZmaVg+9fvCv9nwbzY4FxcUDVO5Zxi4s+rTLdhCeqSCp8hCKBnELrZUBMYOILuq/POFCUJfs4pBOrDniZumMszzO6TcwRsmkYEar/7do+bEl3wzRNuvR7JRWjLs5jR048K3dGsdyTxvNUJe6eWjaDLvCEfHDQ6JC0p8L7tS31HhdoPWjAHZWQ0Whu3EIedcXNtAB4iOmfgfIv39wLu8eB3xVPOZm21reuH3mX9olTDG6vETRaSN9fOg2tCWTRm1yQZDhfKwC5yZoNgR3Bs0ARAZA23FDxhJBgxk7A3raznfKX1vLAgMvK1yowjG8qDwJyEJXEaiUhwYWpVHxgEsk+bWy3YfxRYu7hH5wxrkWA
 1xOlRFk/
 dM6SOySdCEv3Dmzx6YmE98zaw1sfQNdnMAu4uk193akxu00wohoaDIeiVk8FHRkjjtLPKeNUFqGSiDB1DKjKhBDgffJrFtYikGKW9sBeQi/qSrB15Ph/z8oOHhljzrG46gI0OExH3ekMw8+fWojZVVOYSnyX+bkBMpCkcgjDRjlqSWCM8jxMl29sLDL6jTQS4Nx+SZEFuM/qU+ie7WCFOgsuUZkuYO2myAaTJtCf060VfxCu2MIi1avOK9arzuhsxSoitH3yZcS3LSA0hYh5+zHokt2vZBn9S+pPpOjcMC7jbC+sLle6dNyiacBL7zg7ItMO2ACOJwZwpLw3ZaIIGmRJebrJpGH/s9ynuBiLG3hKYNEksRFMnZOBHBYvQrpsLGMKfvhkGskt3SuvtECIQ0ah04GJDm7BvoaOV8nDnZN7z/SJvy7xByaMgoBfxhD0YZBiICcVa6C1PuE+HoiQAAdmoSTmQp/B4RDYaxEwh8lq0Xn+fz1ghLWf5WVfpINwT+/MJCduZ7uLeH616U6UUcq/DYKXeHbxBCAEZOYAVD9feut+AnGISIJJu7FnaBIBkRXWYQ2/UOvV0noUtiJlXfK1VUib5mhof0B7uhTX9JV2FwSy/RbvK0qU+VXbhI9yB3f9Q8eE/43wLkz5SWbyggYOD0qMY/unCIvjW13rKz0PKSm5EfikzjJbsiLDJzjEveYfOjRjXD805rl0rwtwN66d/BkuzxVRb2RvYk5GsJUETmf2V9SZ2x9UnXI6Ay6uBYGili3dGMJZuNj5DiajaVChDYo3aJhQ+99BEXilFuVFFSHNdMQTUNSCf/DK0hvrHBgpgp2lo76+s6PfUt9pR4xg05+VaBvkiE8CTWvJpmQ6B/gLQwD1Td7X+SgSA/o1wxjX1uj3hbb/u42x1blBI8RxS6srd4VnSlMqlscPqHeBMgY9V3bZzQVT3qvuENqds4GdVZYk7spKfUMWJ0G9Ru51+ygkM
 vgBMZFry
 wBGWQs48w8UDtFNDin6gpQNzdegEhXyEwy3aXrA68g0KSevpBE8IdWciFNI3+DEJjbiIuMdi6i5XZs4n7p6sb1b6ifrVo0gikp8KZGnNSHOM2TZfl3Zc/T7/z9AWghKL2/IKptPQddQwYaWsIu6MqrPyx0zC0kmV29MYHKO3aTLA+7UFMWdOqdtyCFjlqBZBf9T+U9xMo+ac3ZbHs+F2DZAf4FlZmizeuLuwp/DFuSul8+Pi45oBFxfPKrRQbngENuUU4dHuNxzLVNX1wab5grRnFFYSOVCcofqKDksS/x0aoX0VDBZS7q/qnbo3LzawK4lNCok5YhlAfcPXXF8W1zVpana0XADbK5Wlb7OrfkBykeIDM3Co2OkE3o9CJBTajeTeeaae5s8XrAVhpizhzvYmAclqhtjKf8DqgjglcJWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in isofs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/isofs/compress.c | 2 +-
 fs/isofs/dir.c      | 2 +-
 fs/isofs/inode.c    | 6 +++---
 fs/isofs/namei.c    | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index 50b4cb3aea87c7fc46b8b5483162bce84573b483..397568b9c7e7d3e28873be02c8a4befcddaec7b5 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -156,7 +156,7 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
 				else {
 					printk(KERN_DEBUG
 					       "zisofs: zisofs_inflate returned"
-					       " %d, inode = %lu,"
+					       " %d, inode = %llu,"
 					       " page idx = %d, bh idx = %d,"
 					       " avail_in = %ld,"
 					       " avail_out = %ld\n",
diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index 2ca16c3fe5ef3427e5bbd0631eb8323ef3c58bf1..2fd9948d606e9c92f3003bfbaa4f0271c750a93d 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -152,7 +152,7 @@ static int do_isofs_readdir(struct inode *inode, struct file *file,
 		    de_len < de->name_len[0] +
 					sizeof(struct iso_directory_record)) {
 			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
-			       " in block %lu of inode %lu\n", block,
+			       " in block %lu of inode %llu\n", block,
 			       inode->i_ino);
 			brelse(bh);
 			return -EIO;
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 5c01536c5e8fecb73a95d801cdd3b8ee22011a3c..1d9a8aeee1fd55998abca74c7e171dc2bc242084 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1261,7 +1261,7 @@ static int isofs_read_level3_size(struct inode *inode)
 
 out_toomany:
 	printk(KERN_INFO "%s: More than 100 file sections ?!?, aborting...\n"
-		"isofs_read_level3_size: inode=%lu\n",
+		"isofs_read_level3_size: inode=%llu\n",
 		__func__, inode->i_ino);
 	goto out;
 }
@@ -1380,7 +1380,7 @@ static int isofs_read_inode(struct inode *inode, int relocated)
 	/* I have no idea what file_unit_size is used for, so
 	   we will flag it for now */
 	if (de->file_unit_size[0] != 0) {
-		printk(KERN_DEBUG "ISOFS: File unit size != 0 for ISO file (%ld).\n",
+		printk(KERN_DEBUG "ISOFS: File unit size != 0 for ISO file (%lld).\n",
 			inode->i_ino);
 	}
 
@@ -1450,7 +1450,7 @@ static int isofs_read_inode(struct inode *inode, int relocated)
 		/* XXX - parse_rock_ridge_inode() had already set i_rdev. */
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 	} else {
-		printk(KERN_DEBUG "ISOFS: Invalid file type 0%04o for inode %lu.\n",
+		printk(KERN_DEBUG "ISOFS: Invalid file type 0%04o for inode %llu.\n",
 			inode->i_mode, inode->i_ino);
 		ret = -EIO;
 		goto fail;
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index 58f80e1b3ac0d5082c24b5dbfd064cf5bff7d5a5..8dd3911717e0cc221f60fb6447e1bf26cc2223dd 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -100,7 +100,7 @@ isofs_find_entry(struct inode *dir, struct dentry *dentry,
 		/* Basic sanity check, whether name doesn't exceed dir entry */
 		if (de_len < dlen + sizeof(struct iso_directory_record)) {
 			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
-			       " in block %lu of inode %lu\n", block,
+			       " in block %lu of inode %llu\n", block,
 			       dir->i_ino);
 			brelse(bh);
 			return 0;

-- 
2.53.0


