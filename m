Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 667AAFD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73CC6B00FE; Thu, 26 Feb 2026 11:00:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30D76B00FF; Thu, 26 Feb 2026 11:00:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D136B0100; Thu, 26 Feb 2026 11:00:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC6D6B00FE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:00:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43309B838A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:00:57 +0000 (UTC)
X-FDA: 84487071354.11.2C0A042
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2F064180018
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:00:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Al9v4g11;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121655; a=rsa-sha256;
	cv=none;
	b=s3BlAfSDu9ptHvqOpqRRnHmURvyZ8V+NrnQFugOmlpVTVH1/Um/XkeXCu9Qe68h90VIdIZ
	jJYHzrnO89XlCN29fo3ISP26/uotayx6JRspW5+lwAXdb/YfUFVdwtuECUiNGN551Eh1gB
	jklv5eyupjNNKFb11swQl0dL6/v6HVM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Al9v4g11;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GcmkSjHQNiMAP4+M7wcaRY6UQRDbZhoonmJV2imO1GU=;
	b=2kj09FpIE/w4+WKK5A7I6FQC1SR3m4h4ViNp3PAHlLuz3PxrGSyl1dV797hyKHqGN86+AO
	9Ce1IqURHa3vXdsaqdkmKEScKJrzUPlbwqAOkR5/7VALi7pXri9qVtEk/TDOIBkWal0edv
	jwpMiV+mwlr9VDgNVgUB5iVXFPZpz74=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F90E6132E;
	Thu, 26 Feb 2026 16:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9001C2BC86;
	Thu, 26 Feb 2026 16:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121654;
	bh=/Rh5l92pxUR0Hc+NWiEklxCWU8fkH3LHs6FMqZ19Oo8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Al9v4g11bgttBretqCk6v+BK+murK6wO5/oUmaNNieQtPjIMVjtuBO8PMZCCyv/5+
	 X8jdGZPNJ3Fz/FAWtJMVYZybLTu0jAyAiSWOJwgQtVZSWj7pQcO0riI2lmq7rC4Jth
	 BDf1bLNgHpQRr3qrClsuzCYSIm/wZNEjHIvoniQuogUVRVQhiudWxOeF0x6s3TdCol
	 IfHTDEbWAbTw0dspo7vWT/gYzIm2KIAMtE5csK3lSM3M53qqo4hmxiK0S9h17zteF7
	 3LvhC5cERiGItYRrQrFzWgcBUAKKqhnM0ywV1SL7X70zb/FKxoNkZCVAzfkqw8nZwA
	 2Su+wJiblkW6g==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:24 -0500
Subject: [PATCH 22/61] befs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-22-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3936; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=/Rh5l92pxUR0Hc+NWiEklxCWU8fkH3LHs6FMqZ19Oo8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0Jvmm76WStrh5xahUTKUjiwtcnMq9ptlqKZ
 tqDyJlo9miJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCQAKCRAADmhBGVaC
 FbmUD/9q5ZqayUoYrNWZkjLIrqrANg3Io4MBJ6MmK3WYFloPzA6GMTaNhuhwZKsYzL7+nxAIapv
 pXVOs2Vc0T4DbTVK49XTh0Ak98am85jThlTD1sq+Tzh7C64LE4MCRLirQG75+bclLqRFhek8FUi
 7JaaQRNSQeVvJbVY13poNMa6w5xyLnXXvTkezLGWfkAO6iG2zDNevRjhNzizbfq6fjuBqenD1O4
 Cpmh9/t0YPuPpceU7G/qxPhwGQ+uz9RQx6y8iPTY9lWyWo1fjIJLf87FXqLnjGT39NnfuLl4MQC
 2wURNAbVNF8xbZs78b1tPxp2YHop5vI05kxdwnqJC881GAzBpy3zqJGxTA98tExCGG5tXIPkjiI
 jBhDIIzyKFZtfBvcEXttoK2b9x8U6kNs+uSCT1WZRLhLlv7Bv7dSo4PR9Bih9LV8Oqj+sx9sl1Y
 kusaOE5oDwfnhkjNusNUQNSpVO1U8Cv1eMUODJx1cORGtqci+dqTQJJltibPcrPoAj5ExD0VMvS
 1Ic2P472u61RvIhg7soyu0jhEJi8ZwT5bEw19a+dkpLoQPlrJOJ+anDi5hL9QM5l/BFiZ6v/eEf
 lXRJN/PX62lhGypSgM4xlJPcKRmNY9fIklDVBTIp+GeYU+uuxwAqKOK5wTMNybQqHCkbrR0zciD
 3KB09K53Ips4MBQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2F064180018
X-Stat-Signature: os7pw8bao516zfkxwuuh3y8y48kjsgea
X-HE-Tag: 1772121654-735357
X-HE-Meta: U2FsdGVkX1+qYEc1EGybvrV6zelBmtKdTZvquL02hmYHpeOIBxjgwRhRaK0FvvWrWuObOz5O4T7O398eD6TRstKmxHiGy/X6mvQJB715AvYhqu39Ys+vLEHGK+xN6ioHLwH2WhNOaBKBkYSEbWTAk3tFx+ldCYv9ZKE14ZQtDhWxGZAzSPRllNQi32pBOfXBzh1c/U6YuPlNvk87PB+Q0NMbJfX7bdH6mM/M0zjO8gwYzSPhtjRHZZ+p8mSoKNcPkM5lRIqb2xIwXr/b3S8NfNC3MKGvt+/fFa8HaRVa4KFSGq+ytuPT8vSGtRTetACYcRmGlh1MCgAlJSW0B4jmiyHY8js1AbgYCIToNd+8dt+V3SH5ZJL+L8UbrrxX9CG7f2sSLbo7ZZ52m8nqCM2Xe0nf4gZ27O9leJU2e7/dSHnYl6WVdDSbpf8VGe/tKISGTbg4Lwr7ZEkByBcu/5ckrfxRTzTsxswmKyXj/wg07x+sTqMlmHPlMfrZFG6ykT8UGmUhukIwVbvI+REC8xiyjcY120v22rpy1FhPP+W1/fYJwLeT57dvvQaF4Jsy3qPZr/kkO3/Qer8YUYRjJH/2t3n1sYDJBLFyZ9GxgO93axnctfbbjiBr/u+NBPbiX2lrMsGGLJq0pdwNIX1TvgclDd2Q3nG6eofSp5yk7ziFhMo7UBxtb+XDx/7HMhLPj218tz6biORWV2cviiujSn0ckCVeuNLbDUT4hVaznJzLcmQE6gpT5mc7X1Y91zSmx1uGrKSPf8t79PpaQaOoFhDR26qwhUl91Nw9WCYFX77Nkaf4yKhFAvzkHDIhmKl8ZzBnjY6y1hZY+7gPi+CxYIVRjHu14o/zqpeO4tUj0DfAHsMFPAPgfxu9MYdTPsYZyazdgsaLJSCN47ZQXevYGz8wIT6//nRm+/wd1Ios6GZ5wKBVpByepIYLQtXal8w7TegNtDHNbk8m88AwY2yNl+1
 YhmfXhDR
 lLBdYJoQbV2RjLg73PrAk9Wc29YkXrHxu53oW0clE1vLcP6iMl1TEd2SJcNk9l7giw4wRKHrk2w+cDeTzQ8YFJWP9QfczfXCxueEGvr2Cnu2jg6f7AzeRvUm7FK5t7Vq4yB3+KKo9LrIgvyKS41HD9x+2fl+EYCTHa5IOGRIBN0JS/F6uSPbq9f+NDvKQlynAckIhCdJC1Pwnc7O+TmHE/WbT0na4pWBz3UB0VIq0G5HOUblryRleLHZxMKj/P0YJt9JMNM/RzRbdaL1HuI5dyyK9z8iQxkGELeumWDbNfcIaktwHANOfcfuPbSlRUhMr8TGuwq8Idl0Xm1m7S0Po67NkHtvuDWhMwJnPmLeenwk7sfpHhA9oU0nNyuamkMb147UZd+xDpju6mv8IcYy9eSvt16P5HohfuAoDq3tT8+1XRqX86lqb5v4Ht0RtELXGxiaSsvekNfe+5tV2wR+VfzMWBLKBkt/r+9LYZslz6+G8PmwB2sd2O2GAD5Z1Krun0h6YvLLRqpeCKo52jAxiQd6e3nxEOQw0h0WvO28tJVi93+k00XZpSRb9OsBLpQ6GSzrcR/lLK9RrYBdNMx0joD2bNZaZhQBrO+ZZ3IZpOGYK7T6SFdBRZxh1WeBEVUfYz+jBtP2RM9WecfOyrwsfb9lDCvx96mL73BZ/0rKpU3FiaKXhyNsTEsGIYMM60TqBQvqzqISaOCd6XU/NalueXWwektw5elDpIBD6FanM2vTYlfZmKqyeqBdUEYJQG3A/htkj+/f2mY7cQVhRegTLOevxbGrlSEG+1W7E4NxEnP8qEUq3NhzZxAJ/T8ra2z0HD9DXnOmv7y/RNBDCMPLn1eBRR0+AxAyxFOpA81bMi0UFK7ousRxAwhdLvZgQ+xtV/Ud5laFJypVmIlg+EJMCHUm7XTZjvC/Xh7neHza1r1AwE4Gz6jRa9MCpqbBdIryWG97OuOt2bmPkicPdoebSlcYxHXNJ
 +ruE/Gde
 NxxOLFjwjEXdYZ0RIJ1RnHoB5SDaDgDNtiUd78tLxerLdzRewBbleiVHKni1W+qdUBWvP5+jtl3AHVRa/AWEiicxG5PEJGiAhCuoNLn17UMNFg7m1BzKQSM3xSza5yS2c96P5l6lXJ5lz3Ch+TrPs/xdzpepf3qo38LOwU3r40bklIygbp2iUmXiU02VeS9jYmw4lmjD84v5ofiLX+2oNHwWoWxA6n+gVeGz6+eeWAN6TpPh+oWZkCLY1f9q4GmGONeBbB617cqMwwb/vyXO0PYci87kljpDCY8ONJdtNvZflSntEzMsrNG2Szzr6368R/6KceExv32U+EiImNnCil8n2e8DMwBgmlpy/UIVSEVvO16KrU2+OPsGBnIdG7LR84nVxj5pa3cHUfw2zdkKy/Szg4OHuztfEj/p+JbfmRuw49nZ3G7cj6TJhxQ1zyij/uwCbvId7Zf0LeTSgvswvi7wa8rYBxVRE/HESgcmG9Sn8rv6KrOYE4OrZTmJlzlcRJei6j6PtRkpWGfnU4SpmHGkVMug4JYGMHvgs5qs99Lb7uJwrMoHDSCm+Cc5yqRmvTfCPl3hMC/O2Mlcgp/0e+772ikYEtqfN1SRByFSfSmVqCu5lbXOAc2PrFNjKuGtcRKhIxE89CVmXBv+K9KDNXC+H/qP7qqcWkuHrPK6mOW7wGjK3/zNEOIXrm81XfkKa1zdihUxG4Zf16siS8YSJKqBMwWnHsKg9CqsXE3tDfgnPcvd3iuGJXjOUKgIQ/rPpA02Fv5XHNzWvimsvrk7zlwrDVi2Qm8usrd2c52/tXl8/ricRq4LUJeIfe69l6t7BApWEdtt7mhDvwPGpwwQttBnP2jBkyDWiiLlqSauzpEgbPGpsDbRT2vTR3zHmSsmGVYJ47dxfbHCzrxjqc+yq2ME2mEMEPqS1uC2nvmNicBb3p/2g84Kgf8RmIJb7bnfgLJSKq19jM1/VCSJNWgVi00XVnSdj
 z7jnAeiA
 guybYMtQ5MXhKY4BqymNLBeoyrwPXCV/OX+CQnkjNNkJp+gucLa0CJq8BODg9NCvV1o8bAdvS0W8umydbtX4QQWlfXvqxuJmMR8V+Er0pYGFZbmPOahJWUOdHq4OWhGg3VUp+5Kz4hOwEn9G57uFcnIhIAVNAX6othIp9Qqtka5jX4WCfvIowJlraHqDIz9+w8JQpridJzcE8HKTt+pePazND4y/wj0q4p/e/oYfvgq1OaoOX1lSpJPAxvKElDByPzKwcN/jl4t0I1vkgF6p4pqdlRs/qWcA4lV0t49VCX+YgBa3tzO7d0Dct9aiIDcFO9VGIpKlzivgjSWQX62MsIODl+GyMo5mN4CgGG2CGRRkT2XHyVuB985EZoQ9O6bhzSfF1CZWgk6Oco94846msgkIi7sIG0YovyfIHEz46uKGIuvMMnZC76aq+DjdHE9iWWI73+RsDSvM0l906zl3tTQxwGTJAI6XN5CRd+9Oh8vnUYnilbzUBd5xTBoehyS+6rNPplR3tTfceeq6BJQiy3cs1tK8WhlW4XVyhvtScmYNxqntB+FuRWtnZMXYDsLRoOtt23z1CVcJdqDrPQTfRs4qVaQvvADkUIulhbkvHnbTzJcqgTMJgiCP6xPWlmHVrdGBsjJsH15M9IBFMr78WooT9cwCKr6vKp0tFoNOs+G4u5MdvdwArhPjmQXHe3a68NN9Nu3V6kZqk4HB4etPwsBub7wQIn+Jnp8Tz4eLrSRXEh+ImmNRI1nXLAJGja7Oj7stMeDcITMrqLmsg4VX+wD3SnVJpLjOSibgA+yYBzZgMccpKcV8dtH6pVVAKWyHk9bA7DXUZw1u+WWCiAX9VQmoZUHr+t7WBl+0nayxE0GaimTQzwjuCArOXtA1bI05dXdqBQ8AF90OprWAq2OI/GplBl8skLHkGqOzF3/YaFUX4k0BT5eAMFdf1+gizG9Tdl+N4GUNQ9liDM3zRIlp3ky4ctbWS
 X1OyTHw0
 UNsO/CjZNvP8rxtCSCTlGvHoRJWXrTeEi3sjV+0/fv6QRMez4SgSlazFetaqeeakE8fzSi5M5fEw176iWVxZngNtp8VjSSw5V4E748uVV/HJUmHhcUkp/kCZDbrzSKmV7kgOQtrmVmLhHVwMCE9tlyV0lz0f9R8H5iYCHJpn43BHS7Tw61kTnHojkpVYLeIYduNyBkmlxon4oZFxQkF51sKZYrqh3U1WJ0QJ1zxupFLQWbaOvWdcfVznp5kpdkqWchJ12D5RHxJrVblJJp324M/RJt3rwevFCHDJvnNY3vLHXG74Xw9OfdL6TJCxW1PiiBSf7dRHiUbWddvbyKqmMNpjBP9iB/jn3iKwvQgRVJhXBx0/o+Q2THp7VzmpYwqt9hCdcFjQ0q6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in befs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/befs/linuxvfs.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index cecbc92f959aa5098313050b515c9af38662c8e6..fac23d6cb6c49f2cab691af357f76a17e1c0ef29 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -140,20 +140,20 @@ befs_get_block(struct inode *inode, sector_t block,
 	int res;
 	ulong disk_off;
 
-	befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
-		   (unsigned long)inode->i_ino, (long)block);
+	befs_debug(sb, "---> befs_get_block() for inode %llu, block %ld",
+		   (unsigned long long)inode->i_ino, (long)block);
 	if (create) {
 		befs_error(sb, "befs_get_block() was asked to write to "
-			   "block %ld in inode %lu", (long)block,
-			   (unsigned long)inode->i_ino);
+			   "block %ld in inode %llu", (long)block,
+			   (unsigned long long)inode->i_ino);
 		return -EPERM;
 	}
 
 	res = befs_fblock2brun(sb, ds, block, &run);
 	if (res != BEFS_OK) {
 		befs_error(sb,
-			   "<--- %s for inode %lu, block %ld ERROR",
-			   __func__, (unsigned long)inode->i_ino,
+			   "<--- %s for inode %llu, block %ld ERROR",
+			   __func__, (unsigned long long)inode->i_ino,
 			   (long)block);
 		return -EFBIG;
 	}
@@ -162,8 +162,8 @@ befs_get_block(struct inode *inode, sector_t block,
 
 	map_bh(bh_result, inode->i_sb, disk_off);
 
-	befs_debug(sb, "<--- %s for inode %lu, block %ld, disk address %lu",
-		  __func__, (unsigned long)inode->i_ino, (long)block,
+	befs_debug(sb, "<--- %s for inode %llu, block %ld, disk address %lu",
+		  __func__, (unsigned long long)inode->i_ino, (long)block,
 		  (unsigned long)disk_off);
 
 	return 0;
@@ -181,7 +181,7 @@ befs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 	char *utfname;
 	const char *name = dentry->d_name.name;
 
-	befs_debug(sb, "---> %s name %pd inode %ld", __func__,
+	befs_debug(sb, "---> %s name %pd inode %lld", __func__,
 		   dentry, dir->i_ino);
 
 	/* Convert to UTF-8 */
@@ -224,7 +224,7 @@ befs_readdir(struct file *file, struct dir_context *ctx)
 	size_t keysize;
 	char keybuf[BEFS_NAME_LEN + 1];
 
-	befs_debug(sb, "---> %s name %pD, inode %ld, ctx->pos %lld",
+	befs_debug(sb, "---> %s name %pD, inode %lld, ctx->pos %lld",
 		  __func__, file, inode->i_ino, ctx->pos);
 
 	while (1) {
@@ -233,7 +233,7 @@ befs_readdir(struct file *file, struct dir_context *ctx)
 
 		if (result == BEFS_ERR) {
 			befs_debug(sb, "<--- %s ERROR", __func__);
-			befs_error(sb, "IO error reading %pD (inode %lu)",
+			befs_error(sb, "IO error reading %pD (inode %llu)",
 				   file, inode->i_ino);
 			return -EIO;
 
@@ -324,7 +324,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	bh = sb_bread(sb, inode->i_ino);
 	if (!bh) {
 		befs_error(sb, "unable to read inode block - "
-			   "inode = %lu", inode->i_ino);
+			   "inode = %llu", inode->i_ino);
 		goto unacquire_none;
 	}
 
@@ -333,7 +333,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	befs_dump_inode(sb, raw_inode);
 
 	if (befs_check_inode(sb, raw_inode, inode->i_ino) != BEFS_OK) {
-		befs_error(sb, "Bad inode: %lu", inode->i_ino);
+		befs_error(sb, "Bad inode: %llu", inode->i_ino);
 		goto unacquire_bh;
 	}
 
@@ -407,7 +407,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 			inode->i_op = &simple_symlink_inode_operations;
 		}
 	} else {
-		befs_error(sb, "Inode %lu is not a regular file, "
+		befs_error(sb, "Inode %llu is not a regular file, "
 			   "directory or symlink. THAT IS WRONG! BeFS has no "
 			   "on disk special files", inode->i_ino);
 		goto unacquire_bh;

-- 
2.53.0


