Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA2CFD8FCF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108526B00E0; Thu, 26 Feb 2026 10:57:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2776B00E1; Thu, 26 Feb 2026 10:57:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1626B00E2; Thu, 26 Feb 2026 10:57:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5D0C6B00E0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:57:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A774C1B6715
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:57:47 +0000 (UTC)
X-FDA: 84487063374.21.7F46E89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2DE478001F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:57:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJXC1eWL;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJyZsz+fohmAK08AHNG3YfkKVqQB04kAr1yiroxeWic=;
	b=Y/EM7/zmG5EIQTskUP5peiqEvwdnoI0eBXxxHKQUAKh78ClrplFqyVlgw4I00/uxvy/Cs2
	u826/q7fk5kIYAvWvjbS68M30ITuwEyaLEvadZKzQhu7QH3Uj0lwoaGHkXNMIVJPF2m2m6
	x5bxUqMPHkfTs7JgxRsYV+wZdY5MnmE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121466; a=rsa-sha256;
	cv=none;
	b=xduR4OzobI5813A9hstTVktN7I8AVM1RH4oGVYMRhcbHBFtEiNAiMIkutNHrBQWXIxcR09
	cZSuwQAOtrSP0+mZfC76+ddJW5P53dLpZLfQ9BRNin+AdmGUkeiEpoQ06kTi8k0YkmNMcg
	UAw7F4CB7Ca5NWdc6YXRvi2cYwNMfWU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJXC1eWL;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABE4660138;
	Thu, 26 Feb 2026 15:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DD4C116C6;
	Thu, 26 Feb 2026 15:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121465;
	bh=rqDfmaeFpGOy4VkjgclW6jgD7R3a4RjPLNoq+iXmqNo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LJXC1eWLdW+kIB4X8lOCU/EpF3XTuwVxtrLXCs55vGYXVupOf+KL3L2L+q2tiYjvC
	 3dGLmzfnqmFpcV6WdQ8flsofhG0yk/Ik+yDyh3yJXW3Qk7FCinqCXM2KZhprmvvGQX
	 mW6pgwzsrU7f53HRrW+mVUBISH6yFB8lnMStsipd3ikUfRuZRo18wuPfpq9fHM9TUs
	 jYMUVJ3A6AzeZbvc13rZQUg/EbK4wXwGUYq68MYtC0txZ9VD/ThnjQHWRlusrcGsPG
	 pPNuzw0e6kfq5znVj9qg92Q7+uWLX7SJV6LESzdKLEB4B5mRzJnloIUHTU77bO2OSG
	 A7M0GEkbB3c6g==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:09 -0500
Subject: [PATCH 07/61] lockd: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-7-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2384; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=rqDfmaeFpGOy4VkjgclW6jgD7R3a4RjPLNoq+iXmqNo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0FDtA0+C6/aacY18hSs3tG9QS+JeAuKU/CG
 0hy0qQFbZGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtBQAKCRAADmhBGVaC
 FUa1D/9GH2hkiSXfB7S7SQT/ha26yA51x5dACbfc2/2SkZdxavqWkpUuU12zApAkI98BUxetYA6
 TKlfhePH3sHcJNb9e1bY5++qI8AYnq8cBEPpT1fjL+eq0Zg60ohLYQ/dYYlZ63rnf6w4nDgbgDR
 fi6djbGB6rucuL6hi1S6GFooDk83+cPQlNIgySQ3LsGKkJKgNpIxA8YN42QalTglkXfvCsZa5kU
 uwLRyfW1/1QaPVMp8In8X7YWWjBUEj/3FPxcG/4uU1sgUHwnJt7Vh0nAwqxILt2zmi7PteHywqL
 yMM9qfC6FspSrpezY51Vr9xdXdJ4A5IkdpoS0LqVYGDxPXhU6yDUhwuLEKuHTLgKzE/Jo7VGA1+
 hKsjlR6cY1FytpszplGuyCLO8onq+dEXwr1bi1jw+7DYQBzF8PzvEFfS2MszZxWFTLSNIcWRpH0
 H8onuTb1Iezgx7XYE5Os7wMBcGMtLNS7fUUOjnkRGIkr2+fuP3KprM/jFzIpnq4XrmWDaoK8LKc
 nyvQiFC2abPkmxQSNCUMCoxi/bAaLa6fJzGyd2s/df9Hex083Yc+mtVhXGVtc+zGF0RXZfrkHJ2
 tkl38FVieOkapgXsgzGNfycthwS+HXN5mBd/eoZOT6369g8471AQdUNZsgDTVduODC8xXx4yeJQ
 J1jwyINglHn6a8g==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam09
X-Stat-Signature: az3dp7zknau9zfdbqn9t3ig87epgbqq6
X-Rspamd-Queue-Id: 2DE478001F
X-Rspam-User: 
X-HE-Tag: 1772121466-442595
X-HE-Meta: U2FsdGVkX19yUVshbhozgdKpjnPIqSlVZEi9bZocnuFhVMZMNmJ1Lpxe5oW1xfzNWKzaNCYRNHEm4/tQ/6wAb0NZxUHlf9HGtgfQfMXbUsBqJLz/yjg9/Zhdc9bDvNBdJVeSvOXSirF+6sjt4a2nYwQkpVwbkRl7oWOfG5a56mteG1vZYJebWlvSYAJ1/KNZMJ5fYFYH6ehK5bYTrDyn/krh6TI61NbsvHxPBxXY7WPx7excPsbG4ugnABgFH1uB4V6tKTNedJmzdiJC1RF+z83UFQe9PtTXfRCS/UeR3W4FIESFAWd048ymY2CPiESS6ouxfo8WnPz0TPZ5SHLQjwlKivxor+xTei0kaeeJQSosvsrnuMGJn2EYIQOnqFgZL3U8tRk7A20j/pdQJzp8PCZRXCcy7zV2gOKf7Qfc/cRi+kcMZHGzXHMFQBRPPLB8RH4VKXmHlf++r3lT05LIwVcaJbqge+bh9l6b+t9cl3hfkBQPUCkliVkMTEamgfT1KOg+bUmhYNhPtWQTKr+bT5dEEwGIg5fbGOP4uwYX4G8tV1y2hJu90nbeqXg3+e9I15jcwLB6HYtTClhHhFtiRMFT/Yt/q4xJSvUaj0Nc8mgc1PEEJ71LENMrtWB+CpqRrYudWYMzTLhoLlT7lyMs+Q8MWcuzqFTZm3D1D+vfP5u7CVYyyOpahGDRh3D6kWESJbPy6kAtlh+8/MrswBtyl2OL0yw7nnCGVlu0lnQGpV17Zaf3+NF+x1K5oxKliqbJnnpvQRULLQqw8o+oo1KSDo1dxLHhHFK8kCX/H4OUCXrWPTBVd59QKS2ZRShGYJL1WGyyijhxIzgdfPFaIjc757FwRZr44Tc+oBEbJOzOeza89QO3zjDQfPL/MaSonlJ0/JELaJaQK2FeVnXBU2c928BrIBMm2FIJBdNDg5/eQLo+PO7XaQDE5txbB4SWySq5yKGXP0PMLAZzWNtudJq
 HyxoGZiN
 Swxux36U50kkm9Lm0cfHK0ES0ir55+qZZPHuyHgdqR+9YnGLBxhOZdyAWyFiV3BhwqLbJkENcN3kmW+hRmKXt3oyasNuVRK0wmSENJ8mQ3z0oIuEdTYGo85LMRl8qQmZ8FF5BizD0NHuzPZV3+YuilJ1oC0XmZpus+W67rath5ortiC01qcT7H49ezsN5t0V5BlHHVxmCWMwjJ7EoCJnm5X/1lDekTlKmVTBwH7fVOeqRGovnFC/7GcRJtjNglsbzU9E0qyn6eOsJpcQYqY2RJj7TbP+BnLN0+K1bILfjsoh3D///8XJ1X+nqjAm+bF98sESlfZIl++yb/ate+P5hrz+JugggNYHZgCUOMuQ+cQZcSYUQqB+w1uSAbZ2ZvPa4Ga10WdV9ggIQU2OWU+C4pgX3qavPLeZTcY+GJkl5QOGFpDRz6TkrUfAvnrPQoZzMW/n4eqnpXLpkkL6h15tliGrixeP++0SIy8SSQ5XGyDmI6lux+ntupe15lfCN2HgZ/PbcEuuz5bSJ/g5V7RI3UISgqaj4WkIGQHiCsEZRagRR9zvd+t9GmeZT9TUMQDlvu33kFQ+HcTfSwFKc9iItV9iISqBnPDmYZum+i9ACgmd/VFIzQHMCWYAqD/kaiOggDscHeHGzMuCKVtoF5O80dTuEUP7gpAjpsF90CwpBWU8T73tcq7l+/S/M465hPuk5uuAUpsMeGPDSJAvURMZYpx7WzTx+T4SbtEh2Z3GGL1AIZ6IWAHC5krncZCIJfQoB3N+4BWzOBeKuWPesx8eUXwcSJjWVFEtD6kMZE8mLoXvwiTOmlfPr8jxV6sM58i3nL5WOWHXzsxwLajEaEOWypum+6JCa808g0+dKhQEigQcMBCCis7oWBTdS/Z3gLDJJArRFP7FFlaRbuSyhtV9XASC4YtSrbZEZECDQdT+QT+hhi0eScKSB1AleSoxW87NdVM6c+xmOncirXIL3/enGTKk1sYQH
 50/mml7t
 32HngGIaPKgbVIE6IlRwgONgQIp8rrO7mp2CnWh2zOB0cNl8LhcKTaqrdiooLaC5LAS2hiuNv9RRrLd12ixbNZ/ru1v+H3Lw02ob1yQiCU/j/lah7E/+smc/JpnQc37ZoZPS9m/0RHBi+szt4hfMQAfy+lWHTuuWMUU5uSda6rZJ6yaTf0YfQcPJT1MLrXPiKbmdLcT4n724mlC4gESd7hjSia2e1XqtvLGIWLW+N3l7h3HwC6g7RYQOSAG6a3mnYAraYQN6tWcPSt2+wTkNA1BZWH8eegh+6FmE0/tN/BZDaKMORnTGmdIhYtNlwtrkpRR4x/zzbumEPWxk7TLtG664qAYueSuLH90nE8CLjNSz2OyGN1iNs+ZnCJeDCBqU14e8kXKlDFkD1J2rY75rAYZMdk/C1top2/5yNIPJNgsY02VSATu1Jh2zCRulouSDQUM49w1VxnfRkRRpeVi9KIQdYIoT7UntlTDnuqXX5hl3gPOBekNTelbCTvbtoixK2QWcrYmEqXwVduzO7NpqAi7CeasCrz8Aij/iZMtyaaTB2aJcl1pC7b6z3RAQEPvVCcjDmKFQAta6b6DeAWu5Ko5QzNztqDgoPjD6ua3YKBVL4Sv6Q/hHb7YrB6EyWngQbzNqMJoeTBmo80udRMMp3T9+2e/N9EtUCZyiq6P3MmaMtxwZ8oLX3sYlH8Tg7MOuKIRD2Y8qR6244sHm5/1NAR6ptNGKZgBWGaeE446sViDP8Jc1SqCa+p17/t8NACxMvEfmLqeXfSwKwAZf9I+iHrzYWKy5gS36j8By7AiMje1du1tgU9LuRc7EvHhggp+8xZzwkDg0NmBh5S8KbBDfUy2iEUsjNKtRbGfl/tPmB9BDkKL5XQ5Hvnm9V0EOawHuHVXkgFbtXcfFYJHB//rRK9HerN+w3WfL4nhF4zb8ADYOxtQrrBqxXvK0l6UaV8Ca+f6uL8CV7w6D5YoqtJISkBhWWlIc2
 sguXAM0x
 cvvo/dfo0WAtOcvM7xUthjGswS1+bBBqQmg9flYuU4PbHLQIEd9vmkHG5jiK6T+D1zi/hgWpttu8ffnpcRRA3DodEPxXJcR7rnAI42Lvo8z5mUCp0FNUXTSIDpH2IHUjB2M9U/YH+8t0Xb6RWrZeztsLT68LpCsoCRQJgwEZMUCe1Cn4+rqDubJlQ0wJ0Qn0lSZZ2H/vAHTjVqX0dGoYPB3ynfklPGbb28+Pp+UMpyaFXWr5MnXqTwZDCzByYcdin5jg0uKMHM1QvuIpciL5lAvlQM/pWRyli9hA4MKzsECfo1NlfTqFEki15Vis+K447YlJv+uu5xRhKCuxbdU/OVzj1+9dPLyiaTWz+tOoO8cWlahmUCIpKynbZ8xQhxXIbtcbmU6I0WGrzz29eJXMrbES+5fxXQZTlIplyZqJFb1WiNAob9RY+XDnkAXZjFxFfn01T5ou1hMofuGdXBudQU4cUgrDHOiI3TaA1seSs7YbXq1igUUh4McqmViO2rHCkyeIXMYEbtMlYqAc70g5Rfmg1fOgKF6MLYv1PuZeszKdNP8XE9kND/FHRA3p/g1WjiX6pyfSfS3siggjY7bB7/0UhngfqpuA+nUzsh1qUm2qbcY7JDznQD3tMrfRyaTnClVMlw8dSrUtPSjaLdN1mYtGzQHEFDStiJOZwp5feqLFxFro7sJMrXD7eEGyh9xsDfPsGCSvMUJVERKEhI5lfahyAA5Fk0DNcoRqDIeFQRiZaTru9Z+TzelYmOuJZUXzlga3u8YpFcuwKn6xY/4o1iqbsVa8q2fLWJ5nnLnHPDmgvQjdBtYkcdTP2L+JaIv2qUNJG7DOVd93iI5ATf0IIsnc0jgXjKdJXr1G0TapqW84FPKzd+qFusipZ+Uv+CUCOfhH5fon3Ni4+976PBtfWnsbRsZIvv95QVotGsgmYEHlMW9Mzxc9CN1oTIaaY8VzaB57BTvHr7Fe7AhiNw3D8Q5mZBhMZ
 I2x5Vfdt
 XGO7th+aiq0wH3VrkauV0/mD+iut3UEl1UK0GHD09zFF17nqTJqSdyShY1kU3AKIFK3AhJSLam5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings from %ld/%lu to %lld/%llu for i_ino, which is
now a u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/lockd/svclock.c | 8 ++++----
 fs/lockd/svcsubs.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 255a847ca0b6b9f7ab5a99c3aaa6856044ac0535..e29cbf8baf21a4ad61f4c55f7664e2063f0afcda 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -487,7 +487,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *file,
 	int			async_block = 0;
 	__be32			ret;
 
-	dprintk("lockd: nlmsvc_lock(%s/%ld, ty=%d, pi=%d, %Ld-%Ld, bl=%d)\n",
+	dprintk("lockd: nlmsvc_lock(%s/%lld, ty=%d, pi=%d, %Ld-%Ld, bl=%d)\n",
 				inode->i_sb->s_id, inode->i_ino,
 				lock->fl.c.flc_type,
 				lock->fl.c.flc_pid,
@@ -617,7 +617,7 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 	int			mode;
 	__be32			ret;
 
-	dprintk("lockd: nlmsvc_testlock(%s/%ld, ty=%d, %Ld-%Ld)\n",
+	dprintk("lockd: nlmsvc_testlock(%s/%lld, ty=%d, %Ld-%Ld)\n",
 				nlmsvc_file_inode(file)->i_sb->s_id,
 				nlmsvc_file_inode(file)->i_ino,
 				lock->fl.c.flc_type,
@@ -676,7 +676,7 @@ nlmsvc_unlock(struct net *net, struct nlm_file *file, struct nlm_lock *lock)
 {
 	int	error = 0;
 
-	dprintk("lockd: nlmsvc_unlock(%s/%ld, pi=%d, %Ld-%Ld)\n",
+	dprintk("lockd: nlmsvc_unlock(%s/%lld, pi=%d, %Ld-%Ld)\n",
 				nlmsvc_file_inode(file)->i_sb->s_id,
 				nlmsvc_file_inode(file)->i_ino,
 				lock->fl.c.flc_pid,
@@ -716,7 +716,7 @@ nlmsvc_cancel_blocked(struct net *net, struct nlm_file *file, struct nlm_lock *l
 	int status = 0;
 	int mode;
 
-	dprintk("lockd: nlmsvc_cancel(%s/%ld, pi=%d, %Ld-%Ld)\n",
+	dprintk("lockd: nlmsvc_cancel(%s/%lld, pi=%d, %Ld-%Ld)\n",
 				nlmsvc_file_inode(file)->i_sb->s_id,
 				nlmsvc_file_inode(file)->i_ino,
 				lock->fl.c.flc_pid,
diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index dd0214dcb69503006181a1533c440fc04a329d73..79f3dd2fd3666d835161a54a6b3d2b69e7741dd5 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -47,7 +47,7 @@ static inline void nlm_debug_print_file(char *msg, struct nlm_file *file)
 {
 	struct inode *inode = nlmsvc_file_inode(file);
 
-	dprintk("lockd: %s %s/%ld\n",
+	dprintk("lockd: %s %s/%llu\n",
 		msg, inode->i_sb->s_id, inode->i_ino);
 }
 #else

-- 
2.53.0


