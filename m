Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A38CFD8FD1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D042C6B0112; Thu, 26 Feb 2026 11:03:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1EA6B0113; Thu, 26 Feb 2026 11:03:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38826B0114; Thu, 26 Feb 2026 11:03:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 991EA6B0112
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:03:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 652F51A031A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:03:02 +0000 (UTC)
X-FDA: 84487076604.19.6D8A6A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 31B2314001B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:02:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TbQmzaY0;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PnHdu67n6Al4qca2HdYL0cqYw0s1KLN/SKYhk2CMP7U=;
	b=I1G5pdIjeHrKD1VhQbgnZ7z5zPRDGwIBe0ml0nqjpj6rD1u7YoHHRg4iGodVCmLKg/OP5n
	szIg2xk8dSLCdYL6ASYx4lJnbt0CVxjG4uNQ+gTfDF7/2WkmS6PkqkOQ3HsTjrVNHYhqlA
	VHWGo8X+PQeUuvaTmt/9JT5wq1ONG2g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TbQmzaY0;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121780; a=rsa-sha256;
	cv=none;
	b=dBzoPlD4JbgFViHOzhNRj0K1iZnkpRCdgorGRdTnfzWDNXvJUqa8SRofPNRFirX+CER3sX
	Lg08aExv7YA6cynMcQMv8mT7NMR9JAuBPFK0rM6u2c064pQgnjWGiAKrEivoQm+iJ93FwF
	jyov+CRwaCjOPbmtXw18s5MZi+sA+Jk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D8BF40798;
	Thu, 26 Feb 2026 16:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B50C116C6;
	Thu, 26 Feb 2026 16:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121779;
	bh=OQCOf5ab2K1mQ+xHyh4YDX8Wu4WoXlx58z+ZGgzTgGo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TbQmzaY0ToimFSGEqqBviXqxwD0bsQQunPHBe4Esrx7faWGcGcQAWK/x89VfMQARu
	 MAF416OE8SaAb2kDCB7GYV73dZyAtE7pa8T2thN0ZQYwZJZIRrTkGi0HdyKSLBqHE9
	 jk83XUg+9Dw0B8v5uK8+g6si9Q1VjGUchf+JZ3VQz4A4Z97Fo7oCUECQKvtOtqz6Qm
	 8apXth+/R3hmpE/a0ui3v6v/JU0Ca2KazJu3UX2LW3h8VyEakwzX0ai1eFnGVuADkm
	 16lHS2lWUcEpC3DciJr9rb7jPw0FQlx8BFdmvHSTJW9e5mFcKhS5/Mz51lf0ofiEAK
	 FxcCtypCuKNww==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:34 -0500
Subject: [PATCH 32/61] freevxfs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-32-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1010; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=OQCOf5ab2K1mQ+xHyh4YDX8Wu4WoXlx58z+ZGgzTgGo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0MytO42ubVkDA1oR7CCr2K7tCY0oxaOdcl7
 ubGW17+fNeJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDAAKCRAADmhBGVaC
 FaSRD/9QZxi4U+dSi8DJ94se4LGWC4f3gLm7EreqnTo0S5Uw1lXf085M+yMl8fOGQP5j5HOXAMZ
 zlV4QOZrgcvv5qbNR/Uu1bIqTr4GHSHKyJRhb4qtl3XVVD9OJjwjulJPWUWGWTAHWJvUamYmUAG
 hXgGEUQxxU7+fHHrNObtVo80fQXdhXwCy3VHQYpZzJk3fRfkWehkcjrhq1KUn/mE4E/q73FuL4J
 iIFJxiycMuoF2Nk1tPnVZdml8zdN7phdfKQ1IIwhTz7fPC3lwhJk0JJ0yT3UloXDRA+RGIR+DaV
 l+3GuzqonpW6vsTlD21OALuHKEIrn0a/+TuUgceZzb7iJwss2Y3sdItY7U5JCxFUVrrjhGUXJbh
 NBMZAccD4ydwd2qrAcM5vQID6YReX//sqI3yMQnV3NbXdzPPC0BS3YXFtsVDcfm6AJHANVxOIXf
 78Am9OXq7FDfhsbMlJumVawUiJXcUQ1G9ykIA6+7J6RhjnJuWt+sB81Mzr9QKnmqs3BWIXvJPOl
 e46W5ho5QdNKcbtaP3D9LL2RWW8okhwpDeWBatMG+8dYr5WeCcVq1uJkjKj5c57uIwz3Ah8/X59
 /CWaZqu9q9XJKqkwLn6kHAdDG7FDvv5IiCzUKq3JfCR0eg7y49iFkuBkwgYzMQMDMucgUs9EoKw
 V5YG7u/5qThqmSQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 31B2314001B
X-Rspamd-Server: rspam02
X-Stat-Signature: kkphct4eyngczdj5kyt7kg73zhgmb5a3
X-HE-Tag: 1772121779-161479
X-HE-Meta: U2FsdGVkX18WNslsEUWB6EVmEnGVna3qV0wDAejAblLhydg2/s09zMU1gZ8QUPZdCm8QzOMDJQiqEI80iaeVTilUsubYIt4H5QEJPjVhrazo3N5jeT7kVd5WEI++MBLhM/nRWS38ukUlck8DTO9fzRa/Cx7l+NUL0Vqdc+tlsZ78ORkvuflSpfuPxJZpauuVCe/lR1U4avdJnR3spjqDaS9HFcPNerDcw9PVzQASB7OtWH95VDqusJ8xgETQEvcIq3t4pf34JAybxmQvOepTCKJUeL8W5kdDupU4c1YE4bVB9Mco/YbkeGK4vtf9eVijzIE8bp+xY01FJ2lyOX5KAh0BfFfpyPL85liU+LYaoPg7XTTyfiOkRP1F3UP1lD+DG154LEIGuLB08WyGImadmR9cwaoer7rFQ0tpslmqa5UAbcNGYEFeXEOZBaz04wfflUAVQy283Q6E5ny5FHuepUnWzLDeX7i459PNQk/paATXPB0zsYcwUuq1Ou7g2dpyAqkBTa8sAcsQK7HCjzSGX+UkYrYe4dbcgrWSo/sQTtGdmrmnV0sAecxDLYFPoGeMW0bVKiMR96OsTOrGyKwfSW2mh27WkzPwcS95PRRheK7R4t0esk/wGaJgWjWMn/D2AFqumLxhw6pJKNzr4t7znCxYgy+iGZ0Epnh+MHj2bisga+gdBTO+dgdyAo8EZ9O2of9QThfkXPA1VbgTMvcKIZ7kwQCjCyZotFI2kRGuHVtQvA2dRPy594mJXkD8boyTXfPwb58PjCIHcfNdA3dcVgd/dx/EewOpAdH5ybAoiOTit9rV3tKBj8rzAW0PAcZS/cohXfhLAsiW681ied/rGcIN7GPDQoBCEA4raltw+erBCL6OtTGhYJtPn5fjrUKwZC2p5O/VilZy7uOir2TqHUwct8ftUFnSairSqgZyuBd4DE+UKOmVKp6PK2YWK0mbgeZvs6B90595GO2cQq2
 /r2POici
 ilKmDAvqZbOlY5fJAFsAVH1gIh/eMic5Og9vtmq9tFR+vg7aC/c8GYLy9FzigJH8ssEC6Qyp/U85/Bv4c+I3ld4/X9P84G0RVzksTbOYb2zgMKsPuDBP0P/wUxbRMUuRulSkNGQnTtpn4yLG33mX5JphWWfYoYZCsAknNVzdqaQ5ZJQiC4ZG9mK25ctWJuXLvzYKvkGyD0Pwzp4algsp7KGHRe2z4V48bSlId/SnXAsbCQCA1xOrxLR0Xxccvdh1oXMKUk8ULZJqAi5XgxepuIXCo2oj0L4JRH7tyfj7Be6Cq6Ipkns/QXivtHSMSfb5l3cikxLpIgU8Hrh5lZSVf0cRcMl+E+aLXYZyYjZCm34xPTHZ5dict7HhPeITOS9X8SqwvMtYgNMWTZcjj6HsdjhBXhL4Af4hcilTktPc5pPuw3ecEJyi7EgO+HZEif4QfxnWaiAMDmBsnCKanB8HJvWspiF4iYaRo4UbtDebNDOhmi4MsNJ8hxHzOiHIcAHU8MI1P+26ovi2m5vsBXsPIKqaGsLeBNb6U7MFuWVhx8qHY+WCl4dERs0bLvg6i090rdDTK5N6HvXsh0SAX9vug4cfiq7slXYKGmZLCnl3gWB6IrZHWgV4RiIqEfpzMU/3T/gHfSUU7hsGR5XryXbBLNbKiW+g3QZ1ihKIYezhzzO16VS/XsPdF++4WMEvN3vukCUDRdAna2ZJfJgwdMZ1SYmfc/ojLG10jv1e6Nqfs38H7YFpZaJo+fjpumyVRxm1qnloqMchK+q+OwvX0jFBUAs1SGTy90rVF+XsmLbk9xdoUhWH3JcBkRH/8GByhIWYNwFW7C6eKpn3b0aHPAfr6GGj/AzSjMS1pIipD1eb1ixxx6tqLyZTzzDzy+AMWBZOsrLnCK4l3+rN/BzYPW0FM/s24v7lv2wVAxm8yXsqJKl1/J6DwZTkv5F1RgOWb3CsYf7VOgtE65/9t/rSSM3L7CsJol4tV
 URhMKa7e
 tRI4xZFCUSTqQpUmeMgQlT6VovUhPcMaBytnu+xeHpfSPGt/Vnz64T4rfZPzy7lf+c035DGBDDjX5+OyWShXXxafoSs9rWKKBs2QR+7fQMtbhC7Ep5fdzQgIV7NU+5mf3tZQ1q6qTUoA+lroW5Ca0ZIrfD1yHX+Szp2vqpmJJhAfd8GgyO6Iy4Nb9ltG9QtKxAGuZxJmULqHnWV28mQFy9uI0UCaUoMyz2xTTfr6/PxfiZxjxqg3aVZQl5v+WCzTIPkSPBWYAh1lcTk7wPu0Uwp6NX9KggpsLK6K0dackR1L2bLDkntyz89svuwLDSgbjOJNcCLXQpo+goir9oQ+YEXy3rkMhfKeufzGjzwe9vpwDUrRmPZoCf4W/NgqYFRHJ9RMiohQQKmP5S8fDLhTa+dHsRJsZteb+lMVFNJWo6S4M/1cnfv0qyd7ljeKHEfdN++ywta5PC7H9atZxZNVn8jnAEViqbZbF+Nsl+5o5b85FrP6djahJRB5ugDOyoxJ1sfxVp2EREt++TuCF8x2rTK+dztVrn4Nw/Sbv2RAygoAmGejP8V+v9VY+pW1dm+fFQtK7773jGEGl6XcPL/IMvORnm+2wL8i/rbo5I0Bnk5BvELCS+B6qtxJgJ8u0Ue9ZmoxbDb3tQYBD5YYPzjpLzE57oIoJbb53g6PRUwnUFclMFJdBJMwoYFIGq9xO1GM+FEEQvotlVNwuTO5tDto7SJ9jhHzuDVjt96mDiIl9xpArPZRfYikk6Hu2uPKbKUouEPxyJH/nrvWtcaUQiYcXzhc/tliOKUCzyV51u79+d0Y4v9NtBFVyrAWCPD+L6z3M44hPXQbQjYzwdIfU+7zIM1C5g6956QPgVWCMlFUXRG9C5tra0AXQa5I4kJN6Vth8uIRBtnYgr/SjZnXgGx0w+ZwFTB7wBwCAkGWymp6u0X5mKDL1CKgl/apYI3CLc2QVULJQ+1xaTIbntvWaHasfH0zant84
 JkctKfI2
 byI1J7KsCl7DDetdFb54fElhRc46Ziwffqb6pH6fNH1oIs0FZq5vu6LcmHB/mOyA1rbLQeiKnauUDYcjEfHjWaGoadr/dZsktMNJWpDIbhwJkx+BX7HF9577mtrK6wtcU+ldr+7PCnqfVsPAjWNZ6pzMqilOaM7A+Adovzg0Xdcqt3Rk3sFCboNF9xHUaro1gANGJ6D4C/N4tcWEMRTqEi37kW53/z2Q3FaYwWfUYAU5K4PfNsst9p+4ibJt0gO8ZjoH/Nb6y2OJD9/Hq2ByH86JbjWBmYRk+5xFO0GtEWZmSPXnCL8jKKWMXAX3rTLvPXyUN0yfyGNuTHQDFrFzSWJ1Te8rZIS1qrFq7gfXh+tw9mqybPC/T6hpJG+Wvt+LkHqGovqGTle3RdCOpTa85Yd//mfj9EQn0Zt11poJb6M4SuXhWYOAzDVrW1CgTECDgqJ/YkdyZkeaGjPOmqMfqmlZ16m0ihAAUplAfzlYahUR92q/DTys7Z0lKdX1zkAilUV513mjAxz/sePJl3XYSQKfnfRvEHGDeHAMUSDACXCCSlq0vrFT8lbbT3FGY0NDeMIV/2hq88SU8qncNgAWoY0yItE5pe4RC6x6905oWN+jgPF6QhuLmpkRfgqscv6UeNqLjvyo4Ha4geMaEiUdmnTjbdtd2NiuW4ZhRsUOheruBww82nAebDNhOBGAuLZg/awlDBLTasIq2CRvnFv4jT3rgqm0RiZZtKYbSCgRfqEcad5KB0jGQJkQt7IfnVlAv/iHFulAea8RN7KcquSQYuy3X/S/BN/DdhBUqKkA81rTET9cxQCg7C1jQOxAFaxladFnSA7qudy878ePYUD1QyMFuMdC1rlN/gu4I+Lk1vRchyjQNK2OpvNXp90YFQfzuGgviYT3p9GQ/RIsGVBKb96FMeWGdZK1WhpQ7OJcNsqLoxVfui0KUZXvBoGrQUYegar+ADy3+vVazPXhhJjsL7HDq3aAa
 fyngxNBD
 ySR7joZuUg+pqHU9gGMPezlf44fEZ6ZOyPBBF+B4Xum4asxs5iQgemWpYJ1vampMSb0sU+V0X9El8744UCIeumQCInaKDLuH0fMDaEJsHtxPHL02CgcbqzhobHsaEvNq68AOWViVKQHm2ivrRk/XeL4P3QflgxWyq4uh1UVqs2ifingcJcYEAogrvuMZXGnA/E6RDBZD5rE6E+ecpsP1Sr/avGtKjKe+ZexemRf0R3+65MlHh/GeyKrtyz7HfpXFxpEX/OCkRQ0earlx2XYXd28aaDaQ8a7Tj/aPDYV0duTaW11/Ht0aRwrY6fCsdE07Tmm7RPQKdkEW0st/0/RjOl+kY05G6RPhp+yOTHnHmn9WavFkQDEa2Bu70Qe10mtXJ2/2j/zr8iRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in freevxfs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/freevxfs/vxfs_bmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/freevxfs/vxfs_bmap.c b/fs/freevxfs/vxfs_bmap.c
index 26d367e3668da0cfd916881c7a07c047a7ef1bf5..cde52187bb7e3dcc05a45b1032994b579d4e4974 100644
--- a/fs/freevxfs/vxfs_bmap.c
+++ b/fs/freevxfs/vxfs_bmap.c
@@ -260,12 +260,12 @@ vxfs_bmap1(struct inode *ip, long iblock)
 	if (VXFS_ISIMMED(vip))
 		goto unsupp;
 
-	printk(KERN_WARNING "vxfs: inode %ld has no valid orgtype (%x)\n",
+	printk(KERN_WARNING "vxfs: inode %lld has no valid orgtype (%x)\n",
 			ip->i_ino, vip->vii_orgtype);
 	BUG();
 
 unsupp:
-	printk(KERN_WARNING "vxfs: inode %ld has an unsupported orgtype (%x)\n",
+	printk(KERN_WARNING "vxfs: inode %lld has an unsupported orgtype (%x)\n",
 			ip->i_ino, vip->vii_orgtype);
 	return 0;
 }

-- 
2.53.0


