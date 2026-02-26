Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1E64FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9636B00FC; Thu, 26 Feb 2026 11:00:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587496B00FE; Thu, 26 Feb 2026 11:00:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446646B00FC; Thu, 26 Feb 2026 11:00:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2426B00FC
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:00:45 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C15658B251
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:00:44 +0000 (UTC)
X-FDA: 84487070808.23.29D202D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D352E2000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:00:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fNcUeAC8;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwOkZMjbWRxvVqwrAW2xeF+30SW70eom28ybXT/H+eg=;
	b=fNnTVuITib60v5s38bXlgOVPIv25uexlGVeObf115/dFh5yab0YfFhcTSQemLn4FY7hpf4
	qZ407RpcVnb+QlRM6X8Cfqu9GtQOBlqjuDB4dV2t8GPnya9li7finEGywhPhKXMDeIi3Bd
	4jmuIZ5sBl5iJzCqwTrClJaOzPmqqKM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fNcUeAC8;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121642; a=rsa-sha256;
	cv=none;
	b=Rw6xAopegEwFL71YLLEOSPNXq0c6mCAWIvinF7VqPEtHq9LLKj5slm60oXncXbvXPTtnGx
	ws9GWGIxoj+unotUIQVXWFp33LF16QadMO0OJrXISENE4+EANz3/+AykwRHiSe49q9yfPr
	DrEffVHOhD9Q8LgWuXYyaQy+0bYciBk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DAF5461421;
	Thu, 26 Feb 2026 16:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17119C116C6;
	Thu, 26 Feb 2026 16:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121641;
	bh=xyBw1SwfRMQLBWEgrrkEe2eyZ3OT6lx+HD9fIFZD1qY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fNcUeAC8LfbuX4lgGT7aQTxBgLST+vuvk5mkMds48GQ+g4HSaoCSpDLHLVMnj0NuY
	 1PIGro8PCwCPQq3d9zMOEafCLIMRrO7q/wdYeMeJVFK1Mt7D0/uZ6UZjf3Hfmz1hvq
	 NSIkUALrDVgV83c2dfneqajdJOgd7N/8TlaV6HeAsWHTIxc9KjXlI7XQzmZ4QscjRV
	 3/u5SxnOABmrerXDkqlgbfXbfI6Fqp0zjAGbGpPMO7cPsucvQfhOLksSp9q15b4LDk
	 pyb14314OSLugQNutI8+hTcdKqsNBCsQQiBbTV6yeEJSkS3IHTtjxVol6hFk5iqsyR
	 tq8E55Bv4aIWA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:23 -0500
Subject: [PATCH 21/61] autofs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-21-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=814; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=xyBw1SwfRMQLBWEgrrkEe2eyZ3OT6lx+HD9fIFZD1qY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0JExbzcWBTBp2aNu1vnR04MkNZW/nAdrw5g
 +xITs56jyuJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCQAKCRAADmhBGVaC
 FabmD/9pShbzxgqwMNSMpo5tHg43GuaCxALPaIjR8IddB7ch3WNAsd/XGJhLa/gFoiMUqmCKEJY
 oOUmX+N+T0SzuhTlRRcmphGFEAcGmaqtc+/nhhb2O7N+VDnavu7DGbYPckBO+M/n6B8cIbWekm2
 Zg78DvmVE66hziTYY90oXnom4z/GJU11TLp5+DNQivyMeqxdBOkB5i/uMxpFcI2f9CaoYardgLn
 lk1qAHvHDTrSakJPXNMRLjGeBLMxukrmVWG2eT7tnlHksA+iUaIx8cQRqNs6uyjf18Jcw6rDcPP
 tQDN1RCczCxUVBMehNGK8XoIvVkoP/QbM9sD+XUIaT35RdgskcXOY0JET6OkBHl2Tu6SeeEyE6a
 jvzxl1wM5MSNeic9rAL/3dIle7gnU36ht25+Z//fJY7NMtZ49KxHgNjWTd3DGYWIpbWa+4jPlaa
 7q+oHXxiagWBUK8xCNH3N/Kf85OyQGGUe/oyHcNQnxVsK2doX5Oc+6XCeziyEaLp3iixL7hC8Nk
 phKLvyz5EYv6IfarhlHlPrSvEy2ztw0mlsuV3MHn1m7YpNfnvO8m7Bqto9MD+wqxu90jXl48/OK
 4ktgDLCFT7QMPuGeSB4qNJNvclX6NaeW6tqsHwgFsbk7tMQUUgnX6H2W216RnFB+2nkb+b3TWQF
 uMdBG0nI+CTO7iw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D352E2000D
X-Stat-Signature: 99qbx55yoau1xjqaqqr88im3i94frn57
X-HE-Tag: 1772121642-428036
X-HE-Meta: U2FsdGVkX18C8VsiQ/ZEIBD7bEUBI13s0YdslxlR9CEYyyd1/oST3WTMxnMzYr5qG6OGf4S1TevqRVfjoglCVnao5th+XLNUGlsLLziygvDOUJEoO2Fuf1bcoFNszMgq07dguBK+a3uc0RZ4KJJp5UwjfZ83ZzdkH312Xh/f6CV5GSwkiqt88ouKvnAMmjQLZI7ZEo11zfLTo9B6XABoh6X+eiwV18ivJO3NVtcyT0UGmDrzK69f8A/sHsKDCEnm3blEURDv7fUMjt+bAxtfdNR2e3YtwOkp5V49mRdM9tXtz6Oby+xkGSrbV5TBPrfLKA3GmaxcxpifVzP+BCw10cxuu4wz8Eg01Y7GeU+8AuYtZrmt5Z+m1pqqc4AxgWyYRMg4mtnlFVOy0oDSHhHR2nI4NjeoxwY7Qq7XDxCqAsGi5zyLtgGh6503IzLJDNnh3OFFLwvVBaCndnnhg9tRHzKhFuU57RZwKB3FqF0U5YHVXZBVeIWOfIDuKJOAL0awYlhmcNsW9fz4iet1P6PdQLWV3JMkDPmfw4Qlr5pqtC1WQFO5F8fQdByMJ8BPojr/JNxbKXxzO4XL4imE89EuGU1z9OtbrhXnYxkhd2dxLNyNHHpmf7s1wC2YNeUYGKaqIM/Zf9UU7j1FzEJ2hf158+GNVbBBH/Oy6twEyePztAmrnTgQCXwaVgGeoN1D0ugMfafaNPRSUq91UegcpEmxyqyInJ+6vnUfsdzHdVoOEKF0cifdUmrCExnFAy/GZD6QtNYG+6PRPZ7ED4b40LLFxR1sPllOM4rT0T8dw9EUr9TUrPYz3XdIp9UYriSMVgyE8ZwpgtOO1D5v9kuDC26zpYn/3ytF2EYoMH26A0IPT9N5yXibtWBFXQ3VbCCmKZAclKQw/yh3ri6ImZX82/Af9Z4KmC5I5Il7amMpkNKfohl+UTc7nNrXbuuIT6zoqyoTw7ZVISQRdSw7scSprZy
 mauCksGm
 sL9rbMdHyRe6oVylbGxnHyl8fn/7ppSyh5zmB1/teMt4ZhQ/fCziMF7msHCYuyQhTXOqIzn9jREjXHIRN01CzMGldNM7QtGP/EA/2+BQ0eB0bJnD2ZXD8ssq7yAlxCL5rYQsYICj8TmSHBbPlWA6lF9P3R9fOpDa7Vs2hkkWwgq+vT5iH/IQfZnmt0LPXC+Pbtp6Rs+7pskMBWKaeV8pDaz/tAfsTulLtqb1wVSH5nKfc0gHJPr5KoComhW0oPbi7jdBSaya/BsSgN+V2K344rwRPcW7uPjYPv7ZP1GwNCzc5+c1RdJjwIqMDnNZTDmIZ+56611AeerW2/YuxH3bxWQaoyo0bdQbbEQZX13OSt0AuDBFG/JASvgWsBwPkXvZzLkqLTcvVEnGX/OXCM1Ie0flTjJa+EYnW6Of47bC/1CO772wXmt7jbwFcyakwITZQrIba+X1ihPp3OpCH4l7+hlfRG7c3TaX+gvELxBM2KxN7qmktvH8684ceRHLduDLqjjUWQaEyGEaUM6dpPesK5PzlXkTMdEW6HMCq/fkqk9q2lVi7aycnQqwWamEAOGCM9gRI81d7y0jJ/evlRiZgfLDDkAYWbyfWDWCv9dRGT/+1D+PE7LUhgmKFifqMjLJzkU+hXQTQ2f6I38OEIeJkeKqMfrGUOJJAVvS3/SPcIq2plEcYGV7D7ThxOoFsZi2d57Ch6lzG6FIItCcbg0I9BKpYFguPpz+qo2ZxZaCxN9vnZ5RQ0KZYc8lPz3Qs4jjz+lDhx//vDsb2N8QetkchjOCKmyxh8qZDblZglqHGxrssCyRWlr1oCJYAkT8sVlXwhQAUju2/T5QkZw0NaPKQ3Lh9wBi7ApBRoXmS8taA+q47gGdz9FDPLal4TwpaBzUpjRONPa9kAhPSS+4hTZfjOiZ+mjItvyH9LeBpA2j8H+09rK1uu7tJ8DHsCzm8WpTantHg2EQY7HAYqfRtOSpTPxgzMDtt
 uaq61y/l
 q+YtChzjB0wkwfN+OpC+kzxsjk/6N/OFdfZgR7Dw6BN4cYFX+ylXTzpmDYOxCckCNllIKnDlqdi397S+JVlnG3B+tnRBiVnUfr7RkpbT3UOhYyDChx2qi+XxAY+wC5GxKanDHoNH6EN8wHMR7eMoc77nn0Lk8JnZfiDoow6/X9qzcZB0PpAgx1xHqn5SkgVLqohYpw6VUYTFZ8n11J+uM3i8c03sklqrLSFSjPDfqvIlncl4wABz3o42c26lxGUNRWZbCdsbfBK6aL93aNFe4KBLJtiRHcuS60zk/ze7wa6mzp8s3+nWTzdJValNigWMge0/gncuY1Zc7Mk0o8x7BPoUkW3f/lHtulk5txZANzpXFSdutlcqPuAVQUMEf9mF3y4+Ca11o2+BcJL9Z/FiSi3toiSwrOjkiAr4aaPs9UYs6Vhfb3Z23V38q955I3Cl++xUJ91qabifWANDUTGt5oY0wgMLHstKscrlRhjBWMqwD7GvJS++dkNTZiSwtgv3S73SsKfON8enV33a+XCYdFtFtNqxVbSvIH5EmplS1jJslCATnD+iLFY6r1bPtaDSzqOQJ0xAJxMq1ZDz/sg+ZwXz6XWBo9bY8+P+QQNSeJYwFCsHGf8sNc0hn/dRChoQIcIBgb265KmepliwOiceJEjYIUq+4fFynoSAMrAtfNA1oCyezH2AqznPkTZ9mK7ZiLy/NHUequwEWvz+sHlM1sp/0Vb2gXvCNj0pXMrxc0rSR6G0L7Zc0dPqfLQf71qAvGYvJCA1GCoAvQonN71PTthuShPlnhvyjVdCiPYnGENfM/EiAWHp3srA0pl0FrYGAVosSC+TTHuoBgq+W+FZ1uKFhKdirGVi7gpVL6aHMi//I3wEDwmY+ab/a/uyG57Kb/JYzSfib48Kd2L+eMXaIP9chjCsyIq3FpSz87lEmFVKqVHUJenW9Pw8Uq/v6i1EVBbNMrx+EbE3MoHICmIxCNAgVqe8z
 oYYK6204
 isJCy1Z0HOYj2DO04oC5Vot3VM9y0UEsPJABGAW1gUntlfZBwWE2ipO/hTe4neRzd1M1sWOm9uoQJAe5xeyWnSXiIt3RYXBrVzEAHUwT0VowLRwakOsoknG/hfjO5h16wqrblNLPFttkqO6snuX3bVTK7d3wRJJUTfB67lr1YDsMKkr29a2HC7iwaYTv/3dru3YlCn5+uZeLsL8GQS53KIUdteytO3sUm4zGFeENwo4gArIH4ucuV/1Cb1ETI7iQacAoP+YQ9d10YfCfcvVoUQSJrLQmMegbHK2hKayN970fQYnK9STZXxNoZKnZWKEz4cHcyZxahLdVJFnGFfftOAE1jEXvYJG1JV/uLD/joFRx1iOQFmzhnQI9xrrMyGGofQB1uMTywSzkTaUVGASrNjmqGAhzZYicLbZW79zf4HkiBvJ91FbclGJBPOKhbtqM3mhJENa7z6X7jF2yBK90KAYsEiMuNF5xJRr+KYWIjw0PrrdEUTf4wfBHWG6PeqiUkgjA3AkPeycxPJuuq/7pp8MJXHlXN4bchruP1oIVNQ8+ebWaVnlW2ZmoUQQmVZ4Bye9RhSGxxAXRcmaCoGIvq6OTemGEftwaaSfz9xyrHQbN7f18wpVq3OYJt/hPSgiVPgyFtBZ+fUK6TJStRM51VOEeHUJXDG/swgBLERrwfbRanOzIqTFq/HUBzeOHHHd5WG9XwsyoaSjut2Jvw8Y2qNlFnBRkxwwFx4Tc4ksVM1AkUm+yzcu3W0MjAcbkyYPYQQ3+uoH+X4JHJ39kMSMTMARWs+HLmiviyGzCpUJthGPX+FkGaMtAYTkww13b/1is//jGLookLeZ7eWaB3fS0Qnlj5KUbBycDISC3821aIU5cELSirLHU1bMggWv67Tzm1gdfiBWrEvwzPUdaHFMMurkBOAoz4GilrpR8VzS9hIQUHoT24AWnGZCMQ3jPmNIQ1v+3CeTlthGTGItJ0/LTcv2wT5z7B
 aRlfQCcV
 260FRM/WzkxM5ISupBoYf3unxIZ2wM6ZlZQkLKoG02qGuM/W6OSlrqLH2Z0+o0ojyKVzNOxk5uDsQdXaOHNPDAsOs3fYwXqJ1Mca2kzqOfFNvKmEeTofF3kRRtmWIEfqFxDiRlbomkSLAndB5IZ4/gU0savy4o/s//YrAe1K5hxhsJoeoLxlEZ2g5Iq+eIXhQEsZhCCKW8LcjcY2ifspye3WNXcnnNGosRbIZxTsnrZuG9sr/Mk+MRqdtrbzfnc+7u9BdMjXfmN3r/FdfkfvgkCdhz0f6rMuRaYPU4q3Y6oydkofUw4u2OkS0TSGQqTK28PaS+veKCoVd0UwUb414ZcnrdTG2rUhb8o0KvHWqS/cDU4pUYrYLwqlNmZ51JYxverlZnHrnCZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in autofs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/autofs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index c53dc551053ba53fa7c85ca57eb877fff74a4ed1..87195c5d07fe99076ef962e78d3fef0414fe46eb 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -92,7 +92,7 @@ static int autofs_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",ignore");
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	if (sbi->pipe)
-		seq_printf(m, ",pipe_ino=%ld", file_inode(sbi->pipe)->i_ino);
+		seq_printf(m, ",pipe_ino=%lld", file_inode(sbi->pipe)->i_ino);
 	else
 		seq_puts(m, ",pipe_ino=-1");
 #endif

-- 
2.53.0


