Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D20C2FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39CC26B0125; Thu, 26 Feb 2026 11:05:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367E16B0128; Thu, 26 Feb 2026 11:05:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C9A6B0127; Thu, 26 Feb 2026 11:05:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0853F6B00BB
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:05:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD7C4B830D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:05:06 +0000 (UTC)
X-FDA: 84487081812.29.83AFFE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0F3431C0013
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:05:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HPrUls0p;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jpJXAihSkMILVtb7R+51KFSEsGYmq6Cft+BVJD31CU=;
	b=t0q0IvpFGp9r6sZ3RHjzrp0v1nc7P/emLZJUiZeAMMHjF4G3wRZi0+z+vJnedOyPzWVhEW
	O9PcOjhsAxV2wazJ8hcslzfm3aFvO9Rt/oJo6yQQdPjVOnKa/O3RNfJC/PhBlRhV402ygT
	9Sd7WyO/hlmOhaPT5PX2CkLC20JKSNk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121905; a=rsa-sha256;
	cv=none;
	b=53AWP2BP4YucExJ9xW45mihfgC6vh40HcODjPbyF3C94caH+sJFnLcVrBrX3OmReAQCRys
	6f8x+f8/dxkTB3hSE7GI2VAxL1+mjdfEd/cFpJYCo39fNagkKX8W+8BfXJMkCDFhZGMXbj
	hmZxDpN2sZTtPuJjiLtSl1hZcShjhZs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HPrUls0p;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2249C408F6;
	Thu, 26 Feb 2026 16:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7722C19423;
	Thu, 26 Feb 2026 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121904;
	bh=WjoPQEYX62ntQ5KvwiKXATuVz2FXwgUeqUutOdHuQO8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HPrUls0pttYjYlcIKlZofSrqW3fdl89q1I46EFL3Ui9bdpMLXu3vRfiIrp+kzPgOB
	 RBwGgjaLoRKm+EPrhWUG+BdSYdVAcSPulqqKyq0D2N2CiCufQ3eJdG3aR2BdTNTnbu
	 bjpLNSiNZkUxPvxkTATzyMkvMjGekVrLYOsYBs6On/AAbw9x2Zqs7u1MaMV9I9C2c6
	 6R2p4D81mdC1vzc6ZV2IP/ocrLyha5EFh4BtvCHFduJPOHKMPy5UO4rPryiehYkb0B
	 rJ8gyGaCi9BxDhuhH0a1WTxBQ2XSn+7whUV7nvDaFlQEl4/fCBKyqX4TfllbLfUlYE
	 FEutDFpxmUvnQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:44 -0500
Subject: [PATCH 42/61] ocfs2: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-42-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12451; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=WjoPQEYX62ntQ5KvwiKXATuVz2FXwgUeqUutOdHuQO8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0OfrfTZKHp1n/fmZIYEbIrkGI0Y5JPmrYRj
 XCtZRIknwaJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDgAKCRAADmhBGVaC
 FZmGD/wOCKbpkObKLXVuNdAaYn+YRBVtPHnVeinRG9CpA2zkvkmHkpGaJw/t/lRR305OQ4IOLnB
 +Re9+UFnwawHAWE83vUbqg1B0cRR7JhfVsn0ZmlzcXCSlkvZOqc/i+sYdDtOLmuhI7/lc97aqp6
 azifdrS19aKHKGTarMljUoY5siOudJImEtsrAB2RLSdmSeP3vt44DbWTkoBpYdWwk/hHvkEfz7N
 f8N97wz0ObO9lAcUiYQQ0x/DfBWP1Yg/EfWO0g7txRlYDqVFHP6fn7g682D6rXjcsQHuFrWvtkM
 egzSbbKNZrwORrEgFHYFPGgh2zHHs1V3LkQY80lyAimWjOSNe+TogzLtn5fLcZjZGdiAJkSxpti
 9wTBnJ0aw2aF/X/KZbCx3dcrG6tH1GImbBRli30p5izUd19v9aSL0T+Cq3FciE2Xkn6Jd27r7sx
 BsF21i7U33FM4efy7YEFCXah17EY0QvnHjLdZUPOfQ3sHryM6C6WLaet9c5UJTv2PHgp+ZcZNr1
 wcZd6gVc4CYe0Y1sivEREcbArmpfOuGdCu0oJzxJU71lra+jgK5UxFzz3Hq2XgjDi79HscgO2CI
 VRDYxVXvsM2OKidz2ccd+ymCIAuJ9Rp/UTYplRb8FGUProNn7xcIvpPMFlJ0k+6qGOGq9HE26dG
 lWMMkEsNAdXcYuA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam09
X-Stat-Signature: 6kstopocy5gyoe7ebbwkpzpxys6mzixd
X-Rspamd-Queue-Id: 0F3431C0013
X-Rspam-User: 
X-HE-Tag: 1772121904-287507
X-HE-Meta: U2FsdGVkX18o3E0w4odgxdiYiur+N5F0fUEf1JscxQi/nDAp6qwIpde8a5c6V2G2hMvmZqF7gsaAlmVl5EvwvLGX2jHJRw5XpZNBawtkrS8MGcm+IiRA40cJNiVuE70sBuDnUvslOxyo9dmE7zDFsuTlpij4PG8T08VYQPvYlXyQzzZIQUie27pSglnqQl3KWnJeyopqIdZ+maoQx/EDlzhzng12RMKttl3DswrIPrIvVXLv69sytE+AwBjmnOQ9vTsDm6rluP67u9dNw4ZzfNPS791Fgl/egyMvWVMQ89di5rZY7yp/qH9qXTTSOjhTU8KssfYeO+dXUQNI91GgPwa5L6fqNIkOiHwwvyTBrOntimViFTT/UkKnWGii4ZjpT5mn6fZJYCRcToqmZBcpufewwpMusoU+CJ7FvLfeWJ6H+rpb5ICJDjnEccb3gS1H175fqfRp9Ord1dQmw0XNyh2/LUa7tPwuSH4IMi0DrdtbQouLPV8WWkPqCHqOxWDxy0ZltjqJpRjSzQJca/KRIcUtUzl6LaKEPhlQvsxGkDcyoP/vKrtZSOM2Lulyj4DhKavfpRAZ2lTWnbo5s695g0Klg9Crwcjb0xWH2BUYAWSmIpRtkJoNHoq00nW2e9ylxkKcfMpLHHvKQ4fbrSZGSwZVwM8fwyKMzh0nVx1f+N9EPA7ko6QyvzW6tLSBKt5PiSmmvMysE76+xsd9GegbK8E4ih5l9TClWYmhzRRXGKWg460IPow/OY8jag+4FWNvYzYSbONaxlFHcE4WZ7Fp33hIW0DYa48clIRMy0eMCYPaATEgUNuaMuNwgSzwPF+e5huDVwzcFR8nGAtPzUALru0OPF5TcqmW4qcjvWD7R2PuwD6Jo0LvHEOR+bq3kvN/AEgRGAE3sx/r1Aou35WH1TTxzXOHws1Ja1xwEQwKTj7Vw9Yc5jnAdfvWd/M55Hq5f0MfGlBZEw5Qkm6+SP3
 xop8JYQa
 FUkdyJkbwiIBven/eI31Le5SKmUGq9OBe2zoOU02A098suu61v78BE1/fB2pg/MBt0Pk0jFlxtOnYDb8eephJLIHL/oem+y7VUUTtNCfEbT0jLdAS12MA5qxJxjjX+uv7lVuzyTMZRURgzxQ+0L6vJFMDAysl0tBq9HEABYott2zjXrC/IK0hi/narM9H6D1oWM/url53S3eydElrQCLNelsUWsfJw7DJ/y064BGSpfh2+TWBWWzSX8MNLRdz1OIRHdvl7d5/EDpgrHI8VyvMu5SjfMtp6Xu1tGb+OSD9SxYigihYewuoF/PrwdN+xkms/2/qZfdmIZ2fIxW6qQQ21D5x3DpUQ9wu+OLDiPZt94S/r1KHBqszn6N5tYD8aZt7LTDSXimYqCewSZzkOQ7YFJwARkoJNjGl+F+GMzvqxzdiPu8Z402FGdK5TfjKknHKDqDBF29xTkPYMohCPy+5ozU10Y0CWKa//MExIAj0FZ7k9knX3i/+7o3ksPFmpKDTESaLHUOr1cpiqoyQl9y98ONwteijoCTCa+e3x4w2Xkksg5N+EHn/0pXGE5allmLVr9uhkHzHz3lLJPHX4GxvWU309FkPQBo5c0vT/UcETVET0jd+xHUCOzQT1voppWmGySiE5Ht6t6wi3oEDTbdoecIL9q76Zg1FTcMBwBMy2+MILkEuiD6/jQ1MQGCNx7xCGHARO0hFz5oFpo4ctN6TsIhLw+guSyg4sRzAF/wxl3Rcx7+0GoAy75mQLEMnM1SyL/umhhRb2/Utg+Q2GHrGoIaOQcHskxEXl1tAecQc9JX8Y4sOBwAydhzOFmCK7Ixr7LlYRKyAT21xkXhrNCaoWE0zTrr7E9gYTlXL3Mv8bs1mbaPi/BXqfhevkhXzcHMW8nUEEQio2t7uHVYGwvavyWSO34tiUgdeqYiRsxqslmqMZCv7uAx99JjkomnaCvG11GY/Q28U+iuR/n3rTLTPNZw7VdCU
 Z70kD8CM
 A8pRc0G1KjZYYdNr9EOKYwrsmyUCTnh+ny8LOuki69gm4iAToJTwaJN/vAUa9AN5d0WRC9cat8pflL/ppMaGrwNnqhsxBO4HBt7K1C395rsk3KUZ6HPAhl3F9O73+dYpEbLozmZrfC0P1MyeBwvMJydaE/6jvj5tXoFrO1OrmwRJRyxVkV/NMJFe9U9Bg0WJnnSescW0sjaslZatEAkl+w9th6dEc6DaC+4KYBlc7uuae0fw/84WHYWPsf2jh8MjkwK93EgNf9pd07StwEaZqo3m45/lzSsI9bZt5xuv97bPuqR4CFAtoVB8DPaPKXd08wJuhhIkSsyn5wWntbALgrzJ9W/G8GUHafyUf2vfygWp5YAu2ZgRMam6ayEaL+6HlfIze6S0qpTGDOrB9S26WI4hNpwOwVjx0BOT+lRK08tiNslg2QBhCO2RbjUHCZGIeqbikDOlBZTamKw4VA3+q4YMU/ejXlQAXkli2xLdk5NZLM2TLMzcfS49I8JTe+e+aq+xn49ol+d2qWIwtXt6hKu6Eeho041lZ6URuTY1zlop+l8ixQV1nD53iKwMJs2ebgS3jpRceuX1zPMIJChSjOR9PMzOSv4/NgCVYVYOKT+Bhkr8x8zTa4Bj9FGAOVbmce72zFUb2wZH05FQgi497UXdbxfosMjMDaBav0gsB1kDC452RqCBR8nHXDSNByjVZ6j2ECmz+rvsi+BgzpB/VTckyKb9BtwER120GrRyvoTybOhwhJ0jjeQ8432tId0ihQZDs52bBVpuMhVUhPhQkz0FPo1wzNaTdSbr/VTed9tJPBp9w0v7p+CwTmyr0d9gverTgAmg9c4H2zVanxECXp5mw+T0La3nx51YQc9XLCPo6pd/K/7w9RUOCWb+RGTyBFInxgKAw31fANACjAZ6DTnJmz+BGHj2PsUJOdkuY+6LRyGkSFu6VUl6ckH+FddKYTECi7lvoQezdOCejVoPaIsKW6oPF
 jSrYOhUl
 QTaV/htFT/5k8mUWGr57X1VRRsNQAWqhtvRKXrXA+9rEgrFFAPSwfQd+yLCqA8GHyERFfsFy3YefiGdBUMygkoFDiVBdawqKfBXJhkGO3Ohn3cZShCYoaW+KwGqWFtI5G9hshPcpnz/Ch21PdYr3hJnCgfQOirkcCfm4hdZxxczpObKI2NHTb72p/IsD2nkQQDCUL76frdtrSkfzLQx8Y3uq5Z0RCAuQeNGY3Y5yB7p+jq7r9gEYoKol2JUDMVWPAyqppgsqs9A0T2/BFMdcTXEcGVXqJomueUkBUC2S7afwENjfg6b6mqknFXFClwCnglavHzBC/YzpsE7cNGUMApDJKr8nn6rwsEJxgEkdudzWfvO2U7l2CTAfn9yMTjtIQ9Y/KgWGmQzu73/rDXuIZebowNBBZi7qtpBxz5tfHpliRtb5KAejSCIk6fCotQqgoMt3AadwDr/tJkZ8bqueoeXkzsljuAwdx1buWQD/+WMGlzCuQrXTtP1pmM8TbacypDJFaLVOchK8sZHtBuTeoItyIrZRhv5mzwDBI8hqptiovR8zZ8Xsjks2roKyjGFjFvtB1hFfjzXv+le5TQZEDkRJjTvL8BkL94Pi4cqM7AH3sGvbb9PnCaKVoqOm1+iyAs5GOpLPl8vJlDHM4fyEFYMI7oABSlGFl2I0CYEgIMDChkvcI5ACr0y+icpN9zFC2EV+m/uihvuQp7H9A7LZNIMTzJgAmiTznzE5L2JALz2xCD/pBrPMxgxQYQqPm/bUlvq8vayZgvjI+NGV9OdbpgJzHsxPO5TozyMgAjHQywDCIrFFJFMj5FwePLRv/PUKdieOLWweV0LQfHZYOsuDAEQQC3kvkPi6GHaDwpJI6fIGpFmuE9CqB4IiB6g0kW1OSvTh8+hiFqmF3ehwlSppHVTxAf6SakV4fc9DfMWWGQPChSnRJPRxAVOs31fnk/j8XnijicGSwtysb89AYBuaXVGjW7Fnp
 pBJh6RZa
 BA9v+7fq3ez8QedWBfv2GV3vLyjPnk+uY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in ocfs2 for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ocfs2/alloc.c        |  2 +-
 fs/ocfs2/aops.c         |  4 ++--
 fs/ocfs2/dir.c          |  8 ++++----
 fs/ocfs2/dlmfs/dlmfs.c  | 10 +++++-----
 fs/ocfs2/extent_map.c   | 12 ++++++------
 fs/ocfs2/inode.c        |  2 +-
 fs/ocfs2/quota_local.c  |  2 +-
 fs/ocfs2/refcounttree.c | 10 +++++-----
 fs/ocfs2/xattr.c        |  4 ++--
 9 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 344fd4d95fbc8bd7a749e9d51d31b5682ff030d0..d40f5d205bce3675ffd37e0e6c228e88c1804a1a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7318,7 +7318,7 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 		 * to check it up here before changing the tree.
 		*/
 		if (root_el->l_tree_depth && rec->e_int_clusters == 0) {
-			mlog(ML_ERROR, "Inode %lu has an empty "
+			mlog(ML_ERROR, "Inode %llu has an empty "
 				    "extent record, depth %u\n", inode->i_ino,
 				    le16_to_cpu(root_el->l_tree_depth));
 			status = ocfs2_remove_rightmost_empty_extent(osb,
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 17ba79f443ee736cb5225702c57d13f4019f3c52..c7ad912ec7a0d6fffd09c3d38f110e5d1517d829 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -137,7 +137,7 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
 			      (unsigned long long)iblock, bh_result, create);
 
 	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
-		mlog(ML_NOTICE, "get_block on system inode 0x%p (%lu)\n",
+		mlog(ML_NOTICE, "get_block on system inode 0x%p (%llu)\n",
 		     inode, inode->i_ino);
 
 	if (S_ISLNK(inode->i_mode)) {
@@ -2146,7 +2146,7 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 	    ((iblock + ((len - 1) >> i_blkbits)) > endblk))
 		len = (endblk - iblock + 1) << i_blkbits;
 
-	mlog(0, "get block of %lu at %llu:%u req %u\n",
+	mlog(0, "get block of %llu at %llu:%u req %u\n",
 			inode->i_ino, pos, len, total_len);
 
 	/*
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 1c8abf2c592caacbe734d49254b04d507925c9d1..b82fe4431eb1f0811d81525237d02c5a3f3b021c 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -794,7 +794,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 	if (le16_to_cpu(el->l_count) !=
 	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
 		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has invalid extent list length %u\n",
+				  "Inode %llu has invalid extent list length %u\n",
 				  inode->i_ino, le16_to_cpu(el->l_count));
 		goto out;
 	}
@@ -812,7 +812,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ret = ocfs2_error(inode->i_sb,
-					  "Inode %lu has non zero tree depth in btree tree block %llu\n",
+					  "Inode %llu has non zero tree depth in btree tree block %llu\n",
 					  inode->i_ino,
 					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
@@ -821,7 +821,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 
 	if (le16_to_cpu(el->l_next_free_rec) == 0) {
 		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has empty extent list at depth %u\n",
+				  "Inode %llu has empty extent list at depth %u\n",
 				  inode->i_ino,
 				  le16_to_cpu(el->l_tree_depth));
 		goto out;
@@ -839,7 +839,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 
 	if (!found) {
 		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
+				  "Inode %llu has bad extent record (%u, %u, 0) in btree\n",
 				  inode->i_ino,
 				  le32_to_cpu(rec->e_cpos),
 				  ocfs2_rec_clusters(el, rec));
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 45cce261da65cab7ef48b5b88c0de5d41fa57615..5821e33df78fd92fabc7fe7fa1c3b3c62c50f9f8 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -123,7 +123,7 @@ static int dlmfs_file_open(struct inode *inode,
 	if (S_ISDIR(inode->i_mode))
 		BUG();
 
-	mlog(0, "open called on inode %lu, flags 0x%x\n", inode->i_ino,
+	mlog(0, "open called on inode %llu, flags 0x%x\n", inode->i_ino,
 		file->f_flags);
 
 	status = dlmfs_decode_open_flags(file->f_flags, &level, &flags);
@@ -170,7 +170,7 @@ static int dlmfs_file_release(struct inode *inode,
 	if (S_ISDIR(inode->i_mode))
 		BUG();
 
-	mlog(0, "close called on inode %lu\n", inode->i_ino);
+	mlog(0, "close called on inode %llu\n", inode->i_ino);
 
 	if (fp) {
 		level = fp->fp_lock_level;
@@ -242,7 +242,7 @@ static ssize_t dlmfs_file_write(struct file *filp,
 	int bytes_left;
 	struct inode *inode = file_inode(filp);
 
-	mlog(0, "inode %lu, count = %zu, *ppos = %llu\n",
+	mlog(0, "inode %llu, count = %zu, *ppos = %llu\n",
 		inode->i_ino, count, *ppos);
 
 	if (*ppos >= DLM_LVB_LEN)
@@ -301,7 +301,7 @@ static void dlmfs_evict_inode(struct inode *inode)
 
 	clear_inode(inode);
 
-	mlog(0, "inode %lu\n", inode->i_ino);
+	mlog(0, "inode %llu\n", inode->i_ino);
 
 	ip = DLMFS_I(inode);
 	lockres = &ip->ip_lockres;
@@ -490,7 +490,7 @@ static int dlmfs_unlink(struct inode *dir,
 	int status;
 	struct inode *inode = d_inode(dentry);
 
-	mlog(0, "unlink inode %lu\n", inode->i_ino);
+	mlog(0, "unlink inode %llu\n", inode->i_ino);
 
 	/* if there are no current holders, or none that are waiting
 	 * to acquire a lock, this basically destroys our lockres. */
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index d68229422dda3423971d7ab0e9a4335acab8b344..eb5dcd17d43752c08eab423fd667b7c0363ba6a1 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -291,7 +291,7 @@ static int ocfs2_last_eb_is_empty(struct inode *inode,
 
 	if (el->l_tree_depth) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %lu has non zero tree depth in leaf block %llu\n",
+			    "Inode %llu has non zero tree depth in leaf block %llu\n",
 			    inode->i_ino,
 			    (unsigned long long)eb_bh->b_blocknr);
 		ret = -EROFS;
@@ -427,7 +427,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ocfs2_error(inode->i_sb,
-				    "Inode %lu has non zero tree depth in leaf block %llu\n",
+				    "Inode %llu has non zero tree depth in leaf block %llu\n",
 				    inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
 			ret = -EROFS;
@@ -437,7 +437,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 
 	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %lu has an invalid extent (next_free_rec %u, count %u)\n",
+			    "Inode %llu has an invalid extent (next_free_rec %u, count %u)\n",
 			    inode->i_ino,
 			    le16_to_cpu(el->l_next_free_rec),
 			    le16_to_cpu(el->l_count));
@@ -472,7 +472,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 
 	if (!rec->e_blkno) {
 		ocfs2_error(inode->i_sb,
-			    "Inode %lu has bad extent record (%u, %u, 0)\n",
+			    "Inode %llu has bad extent record (%u, %u, 0)\n",
 			    inode->i_ino,
 			    le32_to_cpu(rec->e_cpos),
 			    ocfs2_rec_clusters(el, rec));
@@ -561,7 +561,7 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 
 		if (el->l_tree_depth) {
 			ocfs2_error(inode->i_sb,
-				    "Inode %lu has non zero tree depth in xattr leaf block %llu\n",
+				    "Inode %llu has non zero tree depth in xattr leaf block %llu\n",
 				    inode->i_ino,
 				    (unsigned long long)eb_bh->b_blocknr);
 			ret = -EROFS;
@@ -580,7 +580,7 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 
 		if (!rec->e_blkno) {
 			ocfs2_error(inode->i_sb,
-				    "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
+				    "Inode %llu has bad extent record (%u, %u, 0) in xattr\n",
 				    inode->i_ino,
 				    le32_to_cpu(rec->e_cpos),
 				    ocfs2_rec_clusters(el, rec));
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 03a51662ea8e79f7a64fcd320b974f954b2ea8bf..26025ba2656c66b61866deaff60a0da204745c4f 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1196,7 +1196,7 @@ static void ocfs2_clear_inode(struct inode *inode)
 				inode->i_nlink);
 
 	mlog_bug_on_msg(osb == NULL,
-			"Inode=%lu\n", inode->i_ino);
+			"Inode=%llu\n", inode->i_ino);
 
 	dquot_drop(inode);
 
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index c4e0117d8977807dd6f0f4df64e1ddf72a62ea09..346c455d089564aa8c9bdead9385ef0e9eaef5cf 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -471,7 +471,7 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 	qsize_t spacechange, inodechange;
 	unsigned int memalloc;
 
-	trace_ocfs2_recover_local_quota_file((unsigned long)lqinode->i_ino, type);
+	trace_ocfs2_recover_local_quota_file((unsigned long long)lqinode->i_ino, type);
 
 	list_for_each_entry_safe(rchunk, next, &(rec->r_list[type]), rc_list) {
 		chunk = rchunk->rc_chunk;
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index c1cdececdfa4ef51a1bd3a5addad734b324b92c0..6d7f44d3e929d94f3ba6121cc30a867887e0bbe3 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2341,7 +2341,7 @@ static int ocfs2_mark_extent_refcounted(struct inode *inode,
 					   cpos, len, phys);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
-		ret = ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
+		ret = ocfs2_error(inode->i_sb, "Inode %llu want to use refcount tree, but the feature bit is not set in the super block\n",
 				  inode->i_ino);
 		goto out;
 	}
@@ -2524,7 +2524,7 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 	u64 start_cpos = ocfs2_blocks_to_clusters(inode->i_sb, phys_blkno);
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
-		ret = ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
+		ret = ocfs2_error(inode->i_sb, "Inode %llu want to use refcount tree, but the feature bit is not set in the super block\n",
 				  inode->i_ino);
 		goto out;
 	}
@@ -2650,7 +2650,7 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ret = ocfs2_error(inode->i_sb,
-					  "Inode %lu has non zero tree depth in leaf block %llu\n",
+					  "Inode %llu has non zero tree depth in leaf block %llu\n",
 					  inode->i_ino,
 					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
@@ -2662,7 +2662,7 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 		rec = &el->l_recs[i];
 
 		if (ocfs2_is_empty_extent(rec)) {
-			mlog_bug_on_msg(i != 0, "Inode %lu has empty record in "
+			mlog_bug_on_msg(i != 0, "Inode %llu has empty record in "
 					"index %d\n", inode->i_ino, i);
 			continue;
 		}
@@ -3325,7 +3325,7 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if (!ocfs2_refcount_tree(osb)) {
-		return ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
+		return ocfs2_error(inode->i_sb, "Inode %llu want to use refcount tree, but the feature bit is not set in the super block\n",
 				   inode->i_ino);
 	}
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 42ee5db362d3eb6df886d6721dd7398b8aca8cdb..4d55ad963ac514b4b4081447af0992345facd83a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3741,7 +3741,7 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
 
 		if (el->l_tree_depth) {
 			ret = ocfs2_error(inode->i_sb,
-					  "Inode %lu has non zero tree depth in xattr tree block %llu\n",
+					  "Inode %llu has non zero tree depth in xattr tree block %llu\n",
 					  inode->i_ino,
 					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
@@ -3758,7 +3758,7 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
 	}
 
 	if (!e_blkno) {
-		ret = ocfs2_error(inode->i_sb, "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
+		ret = ocfs2_error(inode->i_sb, "Inode %llu has bad extent record (%u, %u, 0) in xattr\n",
 				  inode->i_ino,
 				  le32_to_cpu(rec->e_cpos),
 				  ocfs2_rec_clusters(el, rec));

-- 
2.53.0


