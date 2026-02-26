Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F2FBFD8FC3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A9E6B00F0; Thu, 26 Feb 2026 10:59:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651166B00F1; Thu, 26 Feb 2026 10:59:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51FC66B00F2; Thu, 26 Feb 2026 10:59:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5B96B00F0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:59:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05D8BB7B27
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:59:29 +0000 (UTC)
X-FDA: 84487067658.04.BAD7367
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 247F31C0011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:59:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N77oxwXz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121567; a=rsa-sha256;
	cv=none;
	b=lLJ+qT5lM4tgqpkr57FZBgNfBbFEb0AZQswoTO+Nj9uJqM+MGd8/gNah56Un51zC6RDMOh
	TSfBjARGCPJwMnH17BVaR2nBE0Ht6DRHMR5wD32P6vZTShNWjznGRDaf9zcUJWX+KtS+XJ
	9/KMgPjfqQef1vvmIQffNzUWTqdnIz4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N77oxwXz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7edsg4C7ia7st6nXCys5xdk4S/5fBr8tFvDFf2zJqc=;
	b=38rKj9Rbu01kjA47czJq/D5p3QXSUbVSjQq7Kt3H1JICD0ntOYHHD5qtbo0q3ybP68tmLI
	vn8VNy0/PFuJyVxTmQQX6onExp3vqf1LVLN7Ty1hk9Lt4i8D9y8RsHeoEbupeLdZJYJuHB
	ymA8Xr5xNnb3shvaA6ng3S9sL5kKdOo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0630043C78;
	Thu, 26 Feb 2026 15:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCBFC19424;
	Thu, 26 Feb 2026 15:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121565;
	bh=g5wV3nKd2fkYaUzdtAFph9msp5xwJ6RZyVnJ1pAoKXQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=N77oxwXzWSmqiv4n9JoAOeNfszEZBfeOgSv8Tvh6hdzfxMHzcWkg6NqzIwzXL1t9J
	 lIfgR0aoySbF9TxW4bRiTuva6YbgTY7qIIkaiL0SyNKorrLDxsWZwwc77811vnw/4z
	 kH1IrYSjgNM/SD7ioFxLkm0RjZqGM3zdAdSxhKHrqgU2v6KjjiZEedNO1Oay17zKYI
	 m29sPyavc2gZoemVxxngEEdBgYx7vYYt6cswz+cjE+UpRoOcJEabGTgYyhStcY/9PD
	 W7SiFP1Zc9ivzrBKhGK10ZSSiECGZ/2W0j3mghQNRu4TT6vd2HuPhzeOT3wYYlaDHD
	 SFeO6K5okNvrQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:17 -0500
Subject: [PATCH 15/61] locks: update /proc/locks format for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-15-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1741; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=g5wV3nKd2fkYaUzdtAFph9msp5xwJ6RZyVnJ1pAoKXQ=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0HH319jkE4Yrl34DaunuDnGYZ75BXLH9h46
 zoQskxUz6GJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtBwAKCRAADmhBGVaC
 FUwjEAC2ZD0qhNxn0eTdG9w5L7ZFtQ6MZt/PduR8tBc3steDLPNlVr1HlkztvzNhjEOjeFzGNPU
 4noqHrsD5fArwVU/hc6LnjXeQ8RAy/6Hlf3azXhaKWbWbrzkh13zrEYDIdOJ14A9y6jY3+xttky
 D8J0Zr1cBS+Fea9EypNUH9iUbsMWzobZMoFdR0QuVJKHuORdhQcCVeBdduppG5CLBlz8mDe9fO4
 fl87CAf8I8SWWGbHr+Ci6+/7Cr8hK6ED5HB2IDSeilxnKXdaHNFgGNGNGzYwowpMPX6H/JlrNSN
 EanbpucgYZEbZp8Q5AP8enVYbOCx8iesoQSTsYqhB4YbEZyRXe/HyQcclJ+1cKiT+/mKW7y8Krc
 M0+g4XeUfCV28zdM/SRcop8nhoVyuv4ZR9JNdA9pb4+iiVb41A9l8m9vkxO/uFsXMfaG2sPRjk3
 l3rQ2itrahMP9pU9pjjJ3pO6wU4VI1O8I3iw87/ngaPXuWbRUxWm+ZQ3BLLijixSs2EGPRHP0s1
 FP/nnlD54YoVMLF9vPr4rvBWgP4pY2pJsjAOTLFpNvYzfvlVpGWBUhJwm6vSBhfysRhoV3ME84C
 9U+FefjqnYIccrpU9UZdDviywXX3E9g8/fiSYVJTayZJdkBeH4Qdvg+hgVcv3BrX1XcZxdljHr4
 zqhW1CQyEOF9qKA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 247F31C0011
X-Stat-Signature: izturspyuzgws5wyaowood8xatsx7yx6
X-HE-Tag: 1772121566-648966
X-HE-Meta: U2FsdGVkX19ezVNUksbqocenQdBzqG6rQ+Lb3b/OlDAwMVlW3XlDcy4cKu+4BHz6DlnMnBWD5od58YH3JecJL0OWCnAzzDdY988Xpvl6KcZxlF+R+6F9iwHhync3cm1YQF7wEWY/zex00OIXcpd5S0aHiPmzNjzFCFCGUb8rgUhSFkC0rb+5mEooKuZiDWsVkfQrTRzaVr5xas18PxvenEHnb6kJ9u8+m98j7p9QwPwuQwmkHvD3fTffiEnX9lr3ycZqHsgXB1h/iQMqOZO7sis1ftN05JOxA73EHDijmpNsfQ7TLNipvUgHMtfEDc1HydZTZFYJDWGNq47Aj7hHPatKPa+0FRmjQWAP/cwHGbW7ilwqekEvtn0aim3KanGqOCOAqR6kiSFP9cvq5SpTawZsQWVSfWna6mJEdZYYDDGd2TR+G7DRYbCE8prfm0kqj1cI5T8L9uekkd+ufA5eXxZpaUX1BHPexoGntnJm3po4j8pP8C0NsVIzNpr58AOfmpnhHe7gTwjCzKElLhXhOlAj0Zbj/+p0qnlMqYkVYemvJpzXns06O4KdXGUSLkidYCBP/UTVa3wtBOAYYDZwDM9TZS9uuOaQQFKWtSywQGmvO76LU/63eahD7ClJdLlYtpgRKHWRbMxdCqldXLbs5i11eX66fJsFksmZ4MVB6f8/6rZnmwtmiz4oqLTpjozJVjYgowRatcuklp0QUdN8G1VAZqnXMw3dkEPvTE8l1zycsvOnIIUX3jk4BGSaECWxo9wCStGcDhpqLAQ3NBOSST5lK8DJAbnDt8GM1SjvaYSotzeHtILHTp9nnxqIXgAQ4seksCi7yLK2XxjFuc3J7r9ItPOXgNgf84f7HhFn+3iCc9KhaH1iBWJppdxbqnxT1S0onr/+cZU6V/EWsDAm5JBbU2XT13BSr/O1k27FhqVgzq5C2BCzDF49gZwQ3fzgvLp9xfTT6UeBgVO32A9
 VFjMC6lq
 HZC+FgWInC+aG/kUD5ewPRi7m3OTo4gXm5QfmQLzkALBbklfgbWMc5JaLG9ytGU6ru3YexcqyU0WeUFIQ56TV2dt1Z58j18w6SAtcu9Hbivcbpka1S/pxo3594ADTl6KveRJxlMhs/o0H1fzXpVNcsDSfgkrp01ReMy3+1UpuQAcfq/6H5T9moVs+EFOc5xJVxB9z8qEGpfwzwiDb1PyKcarh1/+vK9y2cCRZUEvgqoleVce9M06MfDLEl10aNCJqq5ZLxv8DgexP078bRpPImZyyp2OTEqyECpOicFK6dKqCjHAnqVxg61e70P6HBv1yo3ID3ayDu0CZOmA9knijZEOnoivk25aj5i3vzO5saOg+59jx6YpweDzXCoDQq40tH9HnV5b3tZKeeDk6nU/5bPlE9OnqjkPE+A2aP+XyjQjPFw5x+RVht+Bry0SnUEXKpTYF7MYCfsmN+0GGhdyKVXWRtWrbFkZcndVu8sBgyZK0XRpFLxGtLHnyXtfg3bnB1iBqJ9GTB3+dI0SCo8y+HIMohMFYXpzI0jyLAAcqVuyZw6YbLaWczuCfDizVpCvNJyhWes7TF1g567kyZI5/n6U0kwifTkbGd4jdL9VZ2l+tnd/B4/tcfNBlq5smKhMjIIxLTmNS/txlQRZ/AjiYqXNALITxMxG2LE3RFLrr3lkppd4A4ETL6PENwt/DPtHZ1XVgulK4rkxOe26MYH+YnZw1k/KjVrewUH7U3YS1hTgAZkRWXj2C4ss9V53FjeFeASLaC1xrTi3JNvABoiX09yBOCgjCqiJhm8JTVpljN8YOOtav4RXZAtkAAar8VHDTNK8sD9x2ueBEWznlC7qvXlE7dIR8XO2nD00RhlEZ/agpA/S//IAXPrl3RvXNhiF1sXP1T81+rRh7Ne1JSn+g1PIpHbXkOihOT2ac7RNH7zooznz+RQPjRZ61gDRH5vUG8wTbyXYOoKzbg8DOThkMVn926TNc
 vfdkB5Y+
 GLgMKsrp9cDEUGsZyQ2PbJlqIl74vLwUJeH65hjqFHCFxcJi7sLcH2GJjXRqhvxO385U05w9UD8bgxiJP2/ObnuEljHaoT8yfdAWyn8VUrZ2t1IWB7xFXvbKZx8U0cpT0Nzn+Kpz++5lLUj5MAQTY9O97K2stvYiflDY9UIYp7ohrVEAZSuuqXkojVMtnhHd0iW0EiVekEc6O8ZJ9dhf7C6GTS6RsUgQlTv+r5OA36Q2rojtNr2BS6S3d5Eh9qQNExkpfKtkG4uygsmoDFy5oS4oC/5XNBE0AhdCGYubbF3cyrO65d5s0750jQlGgiG7pEoTBdPAIkLrfSum/cjOM9GZiBKLUCuRN9OnX8KRyj1lvwbGAa8XVTbfN61bozPSWfg2JOoipbZTgo2mARKzQcgRSg+gou7pQ4/nIzAuzJK8zIEiZfHr0b7/39i7oNaYW4BnGhRVPFWI4jOznh/Hj0EScXk2dmAJWZDcdkwy/jFFmp8xwV13CsmqjFjWfiulbbz+hyh3wpQTSlCvfX9rkizM8zw+nxwnKNcnhFCSCxx4FYpMiWBzp1p5xTMDZK1cDk5B1t5MVNGs/RSif6FxeUu6pGYUMCzWDZfopz/rZsw0sDbfaEf+ig9QH2blr7POMHPnyqDxa3lvL5y9NA1iGcDOvUuuXxl5YawT4+JQbY8uAKPHcT5QsiU1mk6bba5+HMbivCkcCfhweayUcojn/NKPxR3tbcm0ZZGzuSw7tN8n2I0T9Yylm6kdrFxHlokAp6kvZ32yEs9izZwNxODEhd7Ktjlegc7SxkK4nljxjSsJ6aQ9DyN1EI9vKpKLF7z3ajF2ZRxbx+WqkEU0yFKVQURfEBiLuuWLAJDJ4JtQkyNaEy04Y/lcy0vZ6EKJc2T/uxfnT8PGeZIOFR5ozoP5Z+iRpWhBRpLAp5tMdW3iaxBcywdAna+q2NHFo6d3pIMfX/7kroxQYidTnQ/c3bZfZTgDhCznE
 /Ry25i2l
 gqWBhASSt3P6iwPu5j1hQcLhmhVSalzj4vaWrjclgxzwi+KCkITZdtvJgVVksSe9zPbXlY8cTPtNwmSkc9haKtm7gK5Q5av5baotUn8z+oQjz0sxEZ0m/qMfuGuwArLP6tzshv8CmBDcKnegpGFk7Koc6h3x2HyrLfpAfdbss7iwe87cTLAz+wfU+rqFD1C6wpNoCiF/izYuBXVZHeJXFbwn2ZMhPKyTFisw6AB3CFQMNbhuyjX+XUOV0BefYhakrPI44MjFZoSjExZ9evs4MC8WlL+zCIulCQP/HYByTTcgfk4wgKf8NZRh2xUUgIkyM0e0WPHYkveLuo6qQUmyTWKiFbT0Bev/+3mpEuAr4Cyoisy2sEJDluyPv3u6oVPPsuMkIT65X1VCGSgpj5TAzh2DGYprCOLQcWOrZV523oSMxQ8gXynCOmRxRLIe7g6gkDRVjhiJ219eoWcwEssqMn6nQ28F9lU8Scu/1ACvq1n5TiRXyUKFAInavwrvEOs+Yy5m+W0KKHaE3ni8DA+KxH9dDVK2xE1NYgTlTfrOdG6NYoXFXSUNTiOQR3HHlScYsZxH00j6zz+O2O49qfJDi2mKfokWQnju58A4mE0wF8Lh0Kx8rQtZUOvLNJDCPOz3cOtfZh2oH0aVtBRhzC3s+vHx+csG1wHBU7goR37Q44rsTSt/t37RbTGOz1ocNxqKDsRlZZJH1EgjprWg9HDfPF7zHY3up2gzN+6anZVWxOUs3ljeTJGgpRhQFd52azbwTuWU3553lzRlw3wc38nmItfvkSCiXrdQlYskl3v5e7LtLim3BuFdo5AiuVYcPoa6OQFnDC/lwgQkwsPRHakqwZIZh4pud2jv+jN6+EKq3Yv80bM1QaGLhb674epjyXl79TkacSqBx7rN8NnGi7Tm7Z8QS4rrYvE+EjrPhrExHb7Mh120JTonYL37AQWxajVgBVPBnEi0i41s6Wv1i96VhazwfiXqY
 pC/1aAjW
 j+8ErzUhsmZBPHtznHD/KIHhxPX1AGp4Wmy9ZSKPg9wr4nD+ZCW0ovwtqpMOaajCGStW/0Rlu3CIZ1+I/0dSSy2Xs3tSxlUNzXNQ4oqhDP3rZK1mP6zhyNZ3JjPNXsaf6KpdOTMPSFZJtpCQGqbsSahTJhl8pOIz3oJyhjCMhrDxQhrSdMit19MRuvnnXGMnRbAR9GudQ4l/O0FGUJK7+lw6TVdqw02ClpfCfyIAf+Ev8brMMBme1Z+wezVzpcf1+hy3bFVREqoNX1Vsm5sbDlCQ2NZHSg3fDaeVWBAN+U9oPYAu4tuJZIdbQRquMvxzAgCZ8HNkYRcKnsPN6YNmTyqqELdd77SN/UtwFhduDTt+yZN+705ml4I6ytMp/X3ivm3J09XiRbfyTe7GyAX4C0qn+jIDcqEbm43inuomBNI8NqSVHiFpcyYSyO+bjWOPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the seq_printf format string in lock_get_status() from %lu to
%llu for printing inode->i_ino, since i_ino is now u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/locks.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index d13ec930b7bb03905df50bdce30b84749edab8d0..d8b066fb42108971f6b3c7449dbc9b5f8df16b13 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -234,7 +234,7 @@ locks_check_ctx_lists(struct inode *inode)
 	if (unlikely(!list_empty(&ctx->flc_flock) ||
 		     !list_empty(&ctx->flc_posix) ||
 		     !list_empty(&ctx->flc_lease))) {
-		pr_warn("Leaked locks on dev=0x%x:0x%x ino=0x%lx:\n",
+		pr_warn("Leaked locks on dev=0x%x:0x%x ino=0x%llx:\n",
 			MAJOR(inode->i_sb->s_dev), MINOR(inode->i_sb->s_dev),
 			inode->i_ino);
 		locks_dump_ctx_list(&ctx->flc_flock, "FLOCK");
@@ -251,7 +251,7 @@ locks_check_ctx_file_list(struct file *filp, struct list_head *list, char *list_
 
 	list_for_each_entry(flc, list, flc_list)
 		if (flc->flc_file == filp)
-			pr_warn("Leaked %s lock on dev=0x%x:0x%x ino=0x%lx "
+			pr_warn("Leaked %s lock on dev=0x%x:0x%x ino=0x%llx "
 				" fl_owner=%p fl_flags=0x%x fl_type=0x%x fl_pid=%u\n",
 				list_type, MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino,
@@ -2896,7 +2896,7 @@ static void lock_get_status(struct seq_file *f, struct file_lock_core *flc,
 			     (type == F_RDLCK) ? "READ" : "UNLCK");
 	if (inode) {
 		/* userspace relies on this representation of dev_t */
-		seq_printf(f, "%d %02x:%02x:%lu ", pid,
+		seq_printf(f, "%d %02x:%02x:%llu ", pid,
 				MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino);
 	} else {

-- 
2.53.0


