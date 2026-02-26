Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA30FD8FD0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDAE56B0137; Thu, 26 Feb 2026 11:06:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8F046B013A; Thu, 26 Feb 2026 11:06:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48066B0139; Thu, 26 Feb 2026 11:06:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0F76B00AD
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:06:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DDB0B7D82
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:06:59 +0000 (UTC)
X-FDA: 84487086558.28.C1D5F9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 48E2A1A0012
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:06:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P1fg6RLY;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4e6IDVOE7d4q6x9PNEGuGfi5BSX+UMfs1rbMjq6iQ8=;
	b=Ugwk5SMDyASeLPWw5vuJks9VZPC2lRc8Lqfo+mBMZ7cco9Zs8wIwMBwevUY4BosIigalHG
	bCwc0IRdIhiPLAws4qhvKT7+XOJodiVA0EsX5UdmSn1RyOfAB/pGSTUOH8h0TYJOmQ1pT9
	p9fAskF0USl4+tlRsi/d6XGL05P4GGI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P1fg6RLY;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122017; a=rsa-sha256;
	cv=none;
	b=vAid64IyDb0rx41xENHNEPDDXvpK4csyRei5dT90jYe1YII84fy4HcIh8fZ8e94S2WH3cE
	sBrIWl+yCK87rLkUF/jl/UJxt/MvvSAQOrY76lXAbiBCLopolk70msNoDtRDJ+A33i/XV5
	6Dw2Ht4mjTlY4cRGuDU5ipXXQdbM8Vk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B48442DB9;
	Thu, 26 Feb 2026 16:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EE8C19424;
	Thu, 26 Feb 2026 16:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122016;
	bh=FmPBc0NhfLgyYBRek3UGiwF5KRQmM91KdK9CMwNeb7A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P1fg6RLYZtOqeaPyYCSbcWnLY0bPAHJhLVTkuiLTNpt81BXrMXLx7a90piiz4kVDN
	 ZwEVP9yzroCTdwrjOyqkuQb1AygqTWpE4gSuCRmV+2JH97xaHBkhG2SGgwl49NKbzV
	 WVbG+Y9GnPqQlyVbwVwGRjXFzNLih5FQCDNkt6W3J15NYBkeyYiOTdvhexWLzISbG2
	 3++3CE5I1Xq6GZic+my5GsrMK3uWBn0DQ/+aH2W6VhBfDrbLrsZnN4BJAoa0M3BVGG
	 eLSHGwn5gRXb9om3wP9dM99al/tcw4wxsP+jK1HoKsOyT3DKn944Re8Y40lRLwUPZD
	 AbEOCA/YNbN9w==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:53 -0500
Subject: [PATCH 51/61] security: update audit format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-51-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8060; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=FmPBc0NhfLgyYBRek3UGiwF5KRQmM91KdK9CMwNeb7A=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0RIkOUwB5FdByxBC3LRrIg3ty7KbK+nLDoh
 QFlxOd+DmqJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtEQAKCRAADmhBGVaC
 Fd2qD/4sHrpKWPPkClKVMZa1IK2OiuALVNOenyP1HzN7a81bq2lSU/lTmH19YwylEeGJd6mAly/
 Nlth2m2Wd1orRPqEGRyW5PLu20EtAstZ79tv44qr4Yiez5kOyntZhwtUM7asrWWJbBbgqqCM2ae
 x+nr/CqLoQ0oxfSBX0IKn1P3095P5SUTv6jJM0baKx7pXP5fDHolobpbmfBIfvgPO6sVU/HptjR
 hQayS2OjlhcNKyJK9yYP8sXDb1iEqUKEBILryQCfUeYOMZp2Tt5RwEt9zgYmkF4OoreIZ5NyVMP
 ckk9U4Zy/iT2+/hvxSLlJ3FpQwMY8ezs8k1RB5Eb+QZprStMacIRl+QYeIphbQgCnN7iptIKxuk
 X3BjKUXXUkLr9QkmpGjkLzLjObwxSNJOmhd+JuxDwVwkd16XM/3qhyeOSJTozf7mxwKK8BdJApJ
 IgNRvWFB3pDfZTNYObJOeY5srE7RepL0u8IGsTSON8gQQ1wyZz8mudCi8FmSe1QV3YP1HAZ73/h
 5Jp33Gj41Y54Rc4i4+c1uCzQLaeVrZPZqye37ol/uMIfcRGl0BXbOpF1ByHps1s5H0A6VdYtMbE
 B9iom5OtSG5rz9aEC58EdWdw+UPdz67cqbD4y4A/6xHMEv82aVmTMZuFFsEbg6NIJ5uQMfz41Au
 sZrWk4IjaZWH7jQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 48E2A1A0012
X-Rspamd-Server: rspam02
X-Stat-Signature: acn55x7m86rtme61cee7ffryojdwq4pi
X-HE-Tag: 1772122017-208783
X-HE-Meta: U2FsdGVkX19vqLdLPqi4ctOj2abXL7s5yNirEXcY9MAUH3iVeJr6Jfkr4P1CfDR3kHXI1kWcSa3e4ZaDWkOAt0ZzhT3NohmQkR8uq4becGKoY9zjvLP7HgLuo6iTb8jNoobmrchvh1KDeQeRq/pkL/c3zd38ahPsNj6ir/swaM9Jp2fG2x/BOCEO5hsAGptDsgOd/3bKx8e+NM4GVCbeD9MPVX7TANOlYGDW3U0UZvvVrUkBGu8MteSH0E3yuyy+679n1SwNrHxa3OIAPfTUa+LJgEMCZMVFd626bNXrBlGQWXYCm+xHwBHu3iWD8yKDhqEudDVJdVvZrKt29Pa85LqiG13p9GP41QdaUrrCqPa3ts8GizyIQ8N7RO+RWLfq3oXljRC1rw7AQUM+m4akDHKZHb84KCaqZMMQXgBXG6hrYrG9qedVPrKKed+Pm23uHvtHEo025ZYEb/bBAQnNf2vnhLnKKunc+8vUv07WqWvDcqBBuo5XaapdGZRVSK6B8SbDII1CD5+INux+GdA6rmv3Z7Vjfn+ansMmf5RHzkVvgacP8E71WMddAWcj5q0X+saQzcJBAx8MLJfTzsVKYgUnbCAwR/pl5crdgPB3qP7dFJZ1wUJgHHOvd69vijvFPFVm7nB9SYMdsGSjZzKTrX+yWyY02KAvCcPNUBZ+cI8FtcDYNOyXN0htoRGHD8jidcebTI/Kagqr0uAOFJm2ectWBS3aC87zBxYFOqOIyFkOTsf0cYRukXdvkFCqnu18mfDe2X21X/Ro55JSyjmMz6ypOj773WlmqpJxXTMy++q1Z8MHA4apZDqrSaiJFkiqAlOU4BxNVgIERdM4B9ye0jeK2tTVtD/PkDYqLZevaI1sU2SvyNlfecc6P1NnUv8qemlf8+6zKFl4bcKDi4Vpmv/l8esrAp5Fp+DODU3G3G/pNQYeqG5//FHzhNM37QsxwuAMmZazVo6nRuGFpBa
 QJbYwJK3
 kWQPqLb+NaVIcPzza/OfmxHkGhg5wPu4XomX7guiUolW32X0T1eUsIityF9L9QT+wecIoBNNwbcRO9f+eoXMToz1SNjc9Cqo9zNTpEzaw/kxDc0nciJPdBXhhkGaR6LPkmzP6tHD8mL+48Is/n2WcBkbMaGOV0xUnIcWwF+bfUlEp72Hvn2tCJrv7ZjY03j8Ssa6wktLnEoM79CQIgzJ1/bZuYad4YAmBGMWkohFE+mJAAwnohwR9nfsIvyjxvDBAUuBYJuicBo45dwuCpDYD0ZlUfiY0pOQnlGyM3twmskG/JlLnChac4YelUvx0Y1JGMZ+zyhtpOwbO/aZyvgF1LopZtXv3ADR+Me/b2ZvR5vo9b9dsUd6cZXGlnfJbjUufVSxy7z8LaxagM5q5bZ1AOPay2q8xdkvBYekjZZohi7a6yT/Bdzv0UUvPKzaOMiBCAuTthWSRrAyIZXBwq0D3dIjQsHqB0YezUh4ZcBWP34q0kfduPQqGNbskC62oqsIGz9QzZYJ80BcJGxUFwfRmc0bgP9gFbKCoPHoRaGXX8gXnLKKdC2z7Qs6ItMe/L2MAQsVjoOS2zOLw3VnW7XSaNWKCQ2x2AkORd8tyYrRonpvZvm2A9O40v6B66NaF1A/P2VSUOSrkRcrxcq0Gt6fC+DD4nA2ZNl/VYQ/kUKw0BryXBb7a6yFDiqkkd73Uy/uCZsDBR8NtcjsQ/at7MEMwBWu4RPBIXIiIrGFG8feUAT/5HjoSIOrGbev7f/6Aro9ztBuhyLtc/RVxDArg0ttJZL+0pO68PPDpCkBHb3PkY2uRABlWb6q5ZzG2d2EDXX/eTFLLk6mm5xlo42LnD03N+XaND42UqGDBr9QHozYrHsPmrc65L1bDJGAuJACdyfkuW7wzhTKvwPskN6CnfkJKieEYfkyeafsKiVkGq0MJf51fcuHfv1l/S01m7K7ctUnBmE4/4rb4xEbAEFqvmMbib/7ZXT2K
 vLzmZOrc
 kGXYHMXW9ZERLWm/OpnD8M9JEU5MiaIAft8H+u/MRMngdiPFhRX9LTG5v6D9PjifCxZgzHq3XdOyotY9JA56UN/jDMgRUmMWor1w3+OZcaB7Hg0C0oy0G+YMTIBG1FpuDK9mUrmUwddpPH5i2lO9SI6HiKyEB7xKv/nlYZcSEIq65aSV8JRuPFEF8XnuDYC3W6By+m5XbP0QD6mfFhb2Jnvp2sVPzQEYW3zPViavOvsvT3G8sJx6A3wqkmoJMp8vJKMfyTMXHyUmukgw6h9exbJmxTViqqIuiOT9PqkH6A4Uxrh4dZQ7V+olVr2uqtYO18Ei8AKc5eUiaVhiLle0VH3/sux6jcbpcCvZ/ueGSElhqb4/hKxAuLyN83gtnKsOW4QRLKSM/QmZXJeTum4uPcIUFvh/MTr/RZLAQ6y0tWnTRJli/3nMT8LQGRu4wbg4TM5ttbTZ7TuGNquBhA+sPM9+YL050aUgduhMMoP/iS5uaDXdBSDVR0zQyaZz1S1ics+WCTsPR4KK+E3N5xSeLZuzABu9xAWmllHnlq8XK9FYH8BfZG61CyfkJdgZeXMfvwlixSxRohbO9v9eGpb7FN0W3eDd30dWu6AOGPtFAGCO4yCr8HBGgtuXuH65H2f6t6yO+aAkp+yUXrgBp6ufi4tzrhIfxJV7yle6IWybUkkHpszherDtpBRPo4+GBbTMnOb6ZkLjgrSYursmA808jWe9zKqzA9cZ6Lm4plOXM9mAiPlqHiSm0eRrDFU2tG0yP7GLjtw8Dbfbm4GlwHTD9nY4fDbHbpa/SywLkAtxYvCfCph0pgkTWUubP/pzO6HorHBPP4l//u6cUoJ3HOzf9YPpW3MIgJ11u5rQl//4SxsAk4+Bk7wJmqBpa1Ta/hP+hlPGYCuQCaDxGi2+9+NP6fMmMDR6WDeRX6Lop0Mmm2IrmPwt9YcTrc3LY4/RzIJ3nOtZSN7MgqxvX4PuHHyNVqM57JswP
 IvM2qm2n
 DvJi5iK6RwK9TKH1iNJ4W55CKXIAmLraeEow+3bfBSU0L96cHmARuc4cVqY7kj6Py6f64dzsY8C8d5WuGGELsIcARMpKtuYgEzoB7zA3LVklDMPWJwZbqW90WOeeP5o2MrhOM5Hh7nhGAjvfWU+2Z8JhZb/eOUBcnGmjx9p4nO0T0y0vc4hFPyjs6QQhmyO9NuzBaxjiTryG63eKgrSmoY2LklDEhDIXbgD4Dfy+ucIFwtorzCoGSj9qeLF2vkomVoly4rixgz8kMiLbINh5TVZKibQrTWxoLdU9TSN4+4climsaWf/XfUfobse/C6KHdGXRyhUP+noXJw+mPEFsVdEJtEfTBkc3E9k93N/hFw5S8JWpIPb0J9kAIMvDIESjpkmXjHRQPAZAY6+7bVRFIU+ERLN5ELfIMPCyukJqzaeYUK/ZNzsUzovogs8pojRVllLRqFqAIkgTzauePBAGKureuoesJrC5j2/VeNileMnwuHxOyYagvzvLlltkr+RQf+TcYz3hu/UoI2EICTU57Dcfb2jOas8q69iQmSAwm3SF1z34sxoyIy4bAYcMSvjduwPRS22jMgfbhIvU+Vl9XCHcSedKEe37+tb98/kBNjXjUfdDcedPAjcWvAM38FM3ycdpXxdbh+opkDNc7/5S8rkVOQVen8Sxq8OfY5a5DDUyTO3DZin/QkE94/ag2ldw6mzTdRkZQ4jSLpQPdf9ZXOjVkchjM7ciNjXBS4TtqLMeu5BfPbuKd+Cjm00RbsvasSAVZ8qhj0bPsFcC5rKux6cqgI8tSWmg7jC/QGXBmkx/QH4rE7PTD2rYwxmuVdN+U9Oj/2hexsTWGi6qA3Cu084HkOTRhxfj8hdXBs1lQKEnhI5jgDp95fkNF7E+Kdo7+4emlB7OWgD1Qy9+Tafk28I6eDhfCjqpEPuzGyJ3TssmIVLqUUW12Xbi3drztsuCl8zjd16A9QQylCB3rQl78YT2vAVHO
 sja4p8A2
 yKAcDYCP6ckAX6jjnyBbl9lOQy4RuvudxDz8mKrxXu69ag+PHuER7462rRzi3t1aipI8RZUSWGs8nFpzvh0BwB1pdFc56yVWMKp2SvvJoedD9y3knEJy0gXRuLVDweS6aIFEwH1uI9kKwOfl+wmnp0xmRx3aG9YDw2XxjAsqwksVykNscXFTN9D5n4hnQ+xAjsva4Kx74Ln68jsqrN1wyuMCkm8NXnbVqXb8Iz2eTbGyVVX7lGa0PL4pxs7Zocaw2DAtliE9TcYyxTN5zmloncllq2248sp+xf8amvLiRri8D9PBBO4hP0/yGOKLPlbw8eOwfyNrv8MW+6P/7YjN6zoCDEkQmpH/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update %lu/%ld to %llu/%lld in security audit logging functions that
print inode->i_ino, since i_ino is now u64.

Files updated: apparmor/apparmorfs.c, integrity/integrity_audit.c,
ipe/audit.c, lsm_audit.c.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 security/apparmor/apparmorfs.c       |  4 ++--
 security/integrity/integrity_audit.c |  2 +-
 security/ipe/audit.c                 |  2 +-
 security/lsm_audit.c                 | 10 +++++-----
 security/selinux/hooks.c             |  4 ++--
 security/smack/smack_lsm.c           | 12 ++++++------
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 2f84bd23edb69e7e69cb097e554091df0132816d..7b645f40e71c956f216fa6a7d69c3ecd4e2a5ff4 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -149,7 +149,7 @@ static int aafs_count;
 
 static int aafs_show_path(struct seq_file *seq, struct dentry *dentry)
 {
-	seq_printf(seq, "%s:[%lu]", AAFS_NAME, d_inode(dentry)->i_ino);
+	seq_printf(seq, "%s:[%llu]", AAFS_NAME, d_inode(dentry)->i_ino);
 	return 0;
 }
 
@@ -2644,7 +2644,7 @@ static int policy_readlink(struct dentry *dentry, char __user *buffer,
 	char name[32];
 	int res;
 
-	res = snprintf(name, sizeof(name), "%s:[%lu]", AAFS_NAME,
+	res = snprintf(name, sizeof(name), "%s:[%llu]", AAFS_NAME,
 		       d_inode(dentry)->i_ino);
 	if (res > 0 && res < sizeof(name))
 		res = readlink_copy(buffer, buflen, name, strlen(name));
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index 0ec5e4c22cb2a1066c2b897776ead6d3db72635c..d8d9e5ff1cd22b091f462d1e83d28d2d6bd983e9 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -62,7 +62,7 @@ void integrity_audit_message(int audit_msgno, struct inode *inode,
 	if (inode) {
 		audit_log_format(ab, " dev=");
 		audit_log_untrustedstring(ab, inode->i_sb->s_id);
-		audit_log_format(ab, " ino=%lu", inode->i_ino);
+		audit_log_format(ab, " ino=%llu", inode->i_ino);
 	}
 	audit_log_format(ab, " res=%d errno=%d", !result, errno);
 	audit_log_end(ab);
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index 3f0deeb54912730d9acf5e021a4a0cb29a34e982..93fb59fbddd60b56c0b22be2a38b809ef9e18b76 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -153,7 +153,7 @@ void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%lu", inode->i_ino);
+			audit_log_format(ab, " ino=%llu", inode->i_ino);
 		} else {
 			audit_log_format(ab, " dev=? ino=?");
 		}
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 7d623b00495c14b079e10e963c21a9f949c11f07..737f5a263a8f79416133315edf363ece3d79c722 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -202,7 +202,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%lu", inode->i_ino);
+			audit_log_format(ab, " ino=%llu", inode->i_ino);
 		}
 		break;
 	}
@@ -215,7 +215,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%lu", inode->i_ino);
+			audit_log_format(ab, " ino=%llu", inode->i_ino);
 		}
 		break;
 	}
@@ -228,7 +228,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%lu", inode->i_ino);
+			audit_log_format(ab, " ino=%llu", inode->i_ino);
 		}
 
 		audit_log_format(ab, " ioctlcmd=0x%hx", a->u.op->cmd);
@@ -246,7 +246,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		if (inode) {
 			audit_log_format(ab, " dev=");
 			audit_log_untrustedstring(ab, inode->i_sb->s_id);
-			audit_log_format(ab, " ino=%lu", inode->i_ino);
+			audit_log_format(ab, " ino=%llu", inode->i_ino);
 		}
 		break;
 	}
@@ -265,7 +265,7 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 		}
 		audit_log_format(ab, " dev=");
 		audit_log_untrustedstring(ab, inode->i_sb->s_id);
-		audit_log_format(ab, " ino=%lu", inode->i_ino);
+		audit_log_format(ab, " ino=%llu", inode->i_ino);
 		rcu_read_unlock();
 		break;
 	}
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d8224ea113d1ac273aac1fb52324f00b3301ae75..150ea86ebc1f7c7f8391af4109a3da82b12d00d2 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1400,7 +1400,7 @@ static int inode_doinit_use_xattr(struct inode *inode, struct dentry *dentry,
 	if (rc < 0) {
 		kfree(context);
 		if (rc != -ENODATA) {
-			pr_warn("SELinux: %s:  getxattr returned %d for dev=%s ino=%ld\n",
+			pr_warn("SELinux: %s:  getxattr returned %d for dev=%s ino=%lld\n",
 				__func__, -rc, inode->i_sb->s_id, inode->i_ino);
 			return rc;
 		}
@@ -3477,7 +3477,7 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
 					   &newsid);
 	if (rc) {
 		pr_err("SELinux:  unable to map context to SID"
-		       "for (%s, %lu), rc=%d\n",
+		       "for (%s, %llu), rc=%d\n",
 		       inode->i_sb->s_id, inode->i_ino, -rc);
 		return;
 	}
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 98af9d7b943469d0ddd344fc78c0b87ca40c16c4..7e2f54c17a5d5c70740bbfa92ba4d4f1aca2cf22 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -182,7 +182,7 @@ static int smk_bu_inode(struct inode *inode, int mode, int rc)
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 
 	if (isp->smk_flags & SMK_INODE_IMPURE)
-		pr_info("Smack Unconfined Corruption: inode=(%s %ld) %s\n",
+		pr_info("Smack Unconfined Corruption: inode=(%s %lld) %s\n",
 			inode->i_sb->s_id, inode->i_ino, current->comm);
 
 	if (rc <= 0)
@@ -195,7 +195,7 @@ static int smk_bu_inode(struct inode *inode, int mode, int rc)
 
 	smk_bu_mode(mode, acc);
 
-	pr_info("Smack %s: (%s %s %s) inode=(%s %ld) %s\n", smk_bu_mess[rc],
+	pr_info("Smack %s: (%s %s %s) inode=(%s %lld) %s\n", smk_bu_mess[rc],
 		tsp->smk_task->smk_known, isp->smk_inode->smk_known, acc,
 		inode->i_sb->s_id, inode->i_ino, current->comm);
 	return 0;
@@ -214,7 +214,7 @@ static int smk_bu_file(struct file *file, int mode, int rc)
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 
 	if (isp->smk_flags & SMK_INODE_IMPURE)
-		pr_info("Smack Unconfined Corruption: inode=(%s %ld) %s\n",
+		pr_info("Smack Unconfined Corruption: inode=(%s %lld) %s\n",
 			inode->i_sb->s_id, inode->i_ino, current->comm);
 
 	if (rc <= 0)
@@ -223,7 +223,7 @@ static int smk_bu_file(struct file *file, int mode, int rc)
 		rc = 0;
 
 	smk_bu_mode(mode, acc);
-	pr_info("Smack %s: (%s %s %s) file=(%s %ld %pD) %s\n", smk_bu_mess[rc],
+	pr_info("Smack %s: (%s %s %s) file=(%s %lld %pD) %s\n", smk_bu_mess[rc],
 		sskp->smk_known, smk_of_inode(inode)->smk_known, acc,
 		inode->i_sb->s_id, inode->i_ino, file,
 		current->comm);
@@ -244,7 +244,7 @@ static int smk_bu_credfile(const struct cred *cred, struct file *file,
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 
 	if (isp->smk_flags & SMK_INODE_IMPURE)
-		pr_info("Smack Unconfined Corruption: inode=(%s %ld) %s\n",
+		pr_info("Smack Unconfined Corruption: inode=(%s %lld) %s\n",
 			inode->i_sb->s_id, inode->i_ino, current->comm);
 
 	if (rc <= 0)
@@ -253,7 +253,7 @@ static int smk_bu_credfile(const struct cred *cred, struct file *file,
 		rc = 0;
 
 	smk_bu_mode(mode, acc);
-	pr_info("Smack %s: (%s %s %s) file=(%s %ld %pD) %s\n", smk_bu_mess[rc],
+	pr_info("Smack %s: (%s %s %s) file=(%s %lld %pD) %s\n", smk_bu_mess[rc],
 		sskp->smk_known, smk_of_inode(inode)->smk_known, acc,
 		inode->i_sb->s_id, inode->i_ino, file,
 		current->comm);

-- 
2.53.0


