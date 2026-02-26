Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF030FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AACE6B0118; Thu, 26 Feb 2026 11:03:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17F0F6B0119; Thu, 26 Feb 2026 11:03:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0342A6B011A; Thu, 26 Feb 2026 11:03:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF1A86B0118
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:03:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF0051B6F90
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:03:39 +0000 (UTC)
X-FDA: 84487078158.05.A40F9FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id AA970120015
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:03:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/wtq9Yq";
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TqC9XN1OSzXVJdhQiV4JhmptihHnM3GMZGRiKcnL048=;
	b=vhYVy1U4S1nwBR5oXvxoNRVzPaCtxdWIQTQFnllSCSb5GOlppauahj44BL10oejAnxG51/
	0h0ab29ixpCECmCEDQn+sY1bThigtT63NeRIqie5nSkUts8SW1wXjQPIuUu8G4oUkLyFUv
	XqzQAus89j0qKsfBWQowaEnp4wNRP2A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121817; a=rsa-sha256;
	cv=none;
	b=eR2mnON+5GT56SYsaX5mn1z8e2cvzHKq/pI+on/9/2wYoo1ibe2W4TRaxecnvhinHV9Pn1
	HheUYXC2OU+oTUZIx0pgyMenb0Qil4C5agSnlEz4phB+YWhlABDR5d1hS0rlbJi8FEqWbB
	XChOUdRc7vV/DWB0z84XdQvQwIZbn/4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/wtq9Yq";
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D5A0B44407;
	Thu, 26 Feb 2026 16:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0E9C2BC86;
	Thu, 26 Feb 2026 16:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121816;
	bh=Mm9/OP1Us2ZjMqs5yAJOCtSY+KcTrwpYMhIt9vayw6Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=N/wtq9Yq1v9LjJEvOJcB4GqjdG6FyOkiqDeKIjlIp1hJXZG2nttGDsAuWI3sa/hUN
	 XTxIAFPfrbTTj9ShQOTTox1X2bHJOkY9NB2iEz93vj4GrIzNlux88w8z407qzForZH
	 1a87Kim/akMpwP6GwC22lGad82iCSV/DBT28s5v0xnEAMLmbQpLZawhGzqr5oRDcXP
	 OKZtqGXtDlq7wrOjIb7ynIOkMKne58O0jsE7Tk6RIfAbw3oCLieGp+GfH8auZnKYuC
	 RcyVvVHgkZo0bZrDNq0DsihqpKZkBUrLzrhhCr5gnCdOKGGzszV4WTirWYtIE/0mu9
	 tFRgaJMbr07zw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:37 -0500
Subject: [PATCH 35/61] hpfs: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-35-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2961; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Mm9/OP1Us2ZjMqs5yAJOCtSY+KcTrwpYMhIt9vayw6Q=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0N7kdaYrUk/5+PhJXM2cVD9G1tsSNaaeQNq
 x2+GLQgWSiJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDQAKCRAADmhBGVaC
 FZC/D/0e/0AVhKBe5ozYYOnbgiAtc1nrTMnGaFW8Rdg/h1dux1f37tU+G8wakXQcfRJ+LTzQ9R3
 41/wptHxxGiF2TF7NuBK4AJoFJ2K/vthItVl9PKqGT3znPVGctxHrJd3/TqAUVA2HD2RnH8vZY9
 HDofY52XzY9t0Y7ozbRmq07Voi3EokGoVvYNHhU/SWRgNrp+uRfmloaN5Dd4vp4Eiei4rsblfco
 Pk3r3cTXLszGokDkB56olfZy9coVhY2zlD1E73gh1tivftXDQdZx2J0VLfslN/EXiCEcqW66stW
 PiTLj3Tl2SBExh7Wbd7PCSQHFeYWjGY5QblzfySOeHk4Qn6naqktDjXrjudaJHbIeP6VBbXVRNn
 mhxIvVpYE2rhU2EfdFxrK6gSE7N09E6aosv6yw3AkkDoEGNhsa/pxYhbI8PXXM+v1EIP7bqiF1W
 9BJRu/Z+enOQfgFZlV8n3UTqD5LMiWSqVTD1hI6oTapARo5mp9FVgCTQ35t094RRkjp1MXgZt/Q
 2RIW0w85r2dct6IHBA6UcOcFW6xn0SjsehuFmzMvyzP1ccF/AVHC+Rtu7UPC6WU+1hjq3jGJ3aD
 MUGE2bCkZFuVsXb7vZQdaAGkWhfjgvIgiglP7fQJXuqhLQ/o1NXaaxiANsHkSdpmOO21vsnp/6M
 SdxP3CWDbZzdz7Q==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: AA970120015
X-Stat-Signature: tetpmha5jqx33td4uhy8wexoa56s4qc7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772121817-132117
X-HE-Meta: U2FsdGVkX1/c7W9XhQqVAV/r9hNf3SgO24BG0zv56ESSpkbB1c8KTpZr7v0fqPlSZnJDsEuKD0kb7zlh9TS/ESxfziXtQDHbc/WAo73ltFSEXHnkJEZUg23XyUWwgjs8t2HDXE0ztPw02Hb1QOYIbUPzMfVvaDsHwSofgHqFoZi9MlT2j9C+7WSVY/vwMpJRTHdlI2DDe5nnVDKxiMgX219Z3VrCCzu+dTLP8KT1xFJ8W157ZbnrkxQqm/LxA/PqEvA0GHgan6ShBNQVrYL9gOllQYkQMs+b/AXb9n6jHCAURvpbBX4oSALxjsKJAz4WbMaZlwBmmj2ZCMN8JZJmrWpyQ+kebwy8GjybhdfOcHK1xK1+jptdmo1i/I4BNjX60y0PZFfTcsAkjHxvtoTTxMLAZr2d7oF0Qo22K07TNy1X0+TLqc4ZUCUfa2PKySWKp9stnQ/hKkhVfE82ePIJUgIvWwRwLoOAY3te9n/LTRSW8a3/BmLXvPLokSiyRQjNXKLZddhc0WCQYy3UMuE3bfhVPFb6aIYy0G6XQslyafYQcNhBVOTazsHSs24P3mx8U5b2RCpl7VuzYX/epA0TAONLEGA+nweGD10XyYRaRoPFt8USpP5vUIAZfjCmuQ6Vb9eLvbTVVxUwEItXYInIRIiviCnx0Q0kd+ePSuStXhndLJVV9mg+8p4GBNwbmpNzpDOjRRNJ4k8kbzP25RJWbzM5FLw3Vr7e+KWVRmadcqjeF90B+dePBp2C3AjBLWzciqQ1+OH4hEepst2M9olycAo91teGiJ5DlNa+6pHsvIQqMbFD3cGnhg2NrijzeQp+qK9ck0dgrnz/EOn6ZS8rVhI14HS1XRY2Pu9W+5BqTG63WfRdmiLE5V5GzeA65EtTCiunzIuy1tl36bZL0rzbea/xcEUfg2cocxaI5g5UsiG5qjtTRJtDWbJ4UCMXjvwOvUtj/EzJYL/rPr3Xzkx
 oGAh8s57
 7CtiOnb9lW1WDlOpFg//vqcKV2KpiqYXZiwQ6aC6bGj/W/TpQl+5a6SEI/ZM71iyYHilWKy1Y30yiuGi0dAxOV2Ww/EvDolji6S9buQytNrmr8AwgC1lqGhDNnxt96CuaQzCCHtlD2GY4hcw7igk8044i/33TsxeTjNkvi1MaswEt+Jqv+vCHoGn8Y4oDl87QahlLgH1B8VASlTnzkCnhaq5ZtGTnvi8SrPAehCgonuQFyGjiwpMwoMSMncr9JP/tNPeh1ItOmZIqx2/5FiC6xcOMsGGbu6FxsnTQe6T8kBmmUdxXWW1WcXE17Pai7AaqocxcT68SijHOK9NOiP7Rq59ZTk0+AhilwPnGR15vF9em4kuso9TCgI8G5JdBbmlSd4PZlc7MF1WcQLbvfd9mOq8MwZZgIJR+CyB0E4Bs72cjXQ6jh8K0rzZFXXg5zd5Pkv2y5xiquyneDMhFWDyad+Sw8batEwpToWmgu7GZyBlZl4cQQjCxD7yPClAR4jBd5Immatnkj4Vn/k8popT/sFSgGMk3zYtrb2VXzTj8eI2brPar8CIqBxpJqJIesg8nM87nf/73fVqLoZ180o5khv2fgO02TJAVw7eUn4SpkNw0lOg836ccYJOYPz/h34OjBgeniKrrWKrE9WbIczSflo9mxnWJ/xGnmHoIl/jGwkYhN1aPYuo2CKVIuxCs9P8MJ+E4IoMvib9hH6JcwZcIELT6w45ZzXQrEsCxhV3o737VSX/Xp8CVjBa63S3G5MXaealTCRzj841CsrcAPt7qa88FKzPbN/S7Om5su+t0ADDDUctvDWuaUdfyB8kq2eFVUcjIg3iJJKyGn77mdMYhFNx/q8m2jFCH6RRTydvB9fzfFuXRVJB0OLNa9NrpZR1ZDuuaQqO/KiJjfxjJpAPThcjBl7KDWcIvPt49InWr6a7TaNxCz5Na5JXVRl+RqzMOO1Tefg7K7o0igWYyaDJ0fWzJGYM7
 HTtMCxuK
 SmPiABvpP4vLRyMVs8ksvdafJmXWvS2Gd9Px9jN/HEGmZndb2gO7ImtgKdLKmh7vJX/IR8UXZAsKd/Ngc8n3EoXrMseLKv+8bIoi47aSgnGH2DeWJ2v1cE7bMVX08FbVfsaGOfhWfTINvL7WKe4ieb1XCihjodQA8780cZEy27NZR/lxhtBfGCbi8sAw5aML7Q0G1xVd69F00M+KejLL+OEXRyQO3x3BDpAsGHsw91RVKgJb681MtaitnCQ1c7tg9xyXYff6uc/nJ7683nlYuo4L4UyCKdgQUxiQch4jNRq7e4FvC+eVyqvfQcDtcMK1YFKETffMWV891rZ6HPceP9BDpugBNVDxGXx7AZXlOlxA/V+d3s6nzLj9BpmhZHcOBg5S23HehpuApSJrR05m5tEztxzCd3dduISLq2QGngYn7Nnj4GamZR0uApa/cF+32LaOizwXNWS9buh7vMJym97fsMmgiskja2ne4UAIdIOQqNw68Mo4QlNgTLMhWUdyQ2VuD27xCBFDZ4C07/KJieRqTfn/yNBZLsoj8gDZNAkKlr4mwLCRbyrEcEnckIomrUsEYL1cuptVM3ZY/MYdC4qrqLwDIWGmP2jMjRfpvllTzD2BeBkaNp/crBPNduVWlQPyaZV2q+6dA40oz05r74CFkYNLc6iTwKMgOFytGWDAay+y1xIDz5mvT2vp5HXFYa8JVL89lgNZO8VeLzAJVvKvp7Cxjblo0glXzpWUNoobW8vIZbR+DHaQwZMhM28Z9z3LGoBtN/6yDbwU5j4wv1bQHQ65HZs91ycIebO7cgLotl+drdbJKdSA7MUgkLEwJGPXzrtpZFXb4WYHK35rEl4itGmPtZJH1U7IMl58k2+CbtMTmik118IEvpuB63SN6QBvV/I6+iR1pXBB+QNAgAJ4gJ40iwzU8fyJ/zpFHRoSzYNhnT0iWBXTfmAFtWMuq0FqzOmPWQ1fRr81FbEMH9u8nYeUf
 cyX3K2YQ
 YwofYO6GvcBpaEAxj5pOmQdVhulSkD5JaHZh9Q/06OsudPQGe+JTRBOpNmU032wtAmIPdXnI1GAXCt56px5YuXmFoizwXdfrvwejV1aTMqr16wuxFiP35MtybC59Qg0jy/F+GF6gNqhZj7IUaxa752Uj0/AElKnVXvylhmrSeSZsxjEoCqxjWgO9qL6RhoIwOOh0DR6TKy4Lj0ut5Uk4w+sOsmR4D6TWrCKSD++MGEHv0CXydE/UgkSu0tQ+NUGUfhtTBrz+YwDNpMpASrUvuWkYq3ODVWhlLvbAy9kD3UJ+Tyyln8jPB67YhJxgcAo7iboEiZXWPmUnSuTm3gByaKzj2iHGEMcnbLQn1EvK+hKoo5hllqeUYCYCKhVW0ifYmwbMOe7FT9U55PiaHyApg/GM7Kk9SMZ7BAkGhDs0LfJ/ROKkLHwMFq/plMIymXQKuPcDMVQ45VeT9MPmUCk76WRkdFe0t0MffHni/oTKsbh9bau0FDefK1VC2Cqj3DJyiBS/vLbO2XyfimDNP26GfSzMfg3+dv39JWHBhV3d2Jb5p0JKApuvNUKirkXYZH92D7WR1/QII4O78p+JiWh7D8l5nb9am61t8VfSCKrzkT1ITUBXCCkWwrUia4GxYxA0M3QPu/HYGm8YFxlFxBF9xIBeCHrOGsxP8FL4alq5/8KLuBzfB0L9V+cMVBgAskseBo4c9xOXRiM1Z5MwXRVd1yUgJA4lkNk8TFXt79NTNTcExcLxMVrLssKcKJwYsU7qf+/wBGhEkKDqqn7TBbwhqPpiN/X75nvsrjizLDZLLPRf0lWMB2lubygLgABXTHeSxQWa6nbp+ZHXOk8WPzbOnB4K7hEWWoeM0iC2KXWHfme191aeQq5uPccmWV/RyfenZRIHUlkpImFygKBoiOi2/aoa2+gVcf1XE558CoGio0dWKgPhkE4PqdbALTWS0pY0ZPqpRLn98wqC2tZtQ768I0rAPeQCG
 A0zZ2UsF
 DPJv6qnAy1DJ7YnJUeCZHcM+LBy8TXZmmWf1dtaJjtcC+5CVAUcNsTl9YVw7FxmXd5SCeIhv21NXbM+cUqZXbiCe8tRLJ+RUfxUw9TkwusFTqrmbT7uHHZ0N7cJVkTiujs2997VWVuw5QZ4jfcNSffBb3la3hRN6W6tWj4xs0yrH8al7B8bXoXLZjuCaip4tT4/paFnXfkBd3hM5/PpCu13Dxj+FdAZprkuIjR1ovc9Nkc9mYBahUnR2/iE2sHNSYCB8Ba9Gvljp6T91hEDwwCCfoPVOTlJBayKGLHUsMl+xf2pO9PjcGlmbRWwRxmWHlfi4eJmk3bPfhaHwk4Bn7ipnkCycqRZzIucizbnpvPre368XL+5MVpqzebSq3w3p35qei56VjuQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in hpfs for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/hpfs/dir.c   | 4 ++--
 fs/hpfs/dnode.c | 4 ++--
 fs/hpfs/ea.c    | 4 ++--
 fs/hpfs/inode.c | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index ceb50b2dc91a9da02997a40836d6543786d883d3..3398b3417a4966450e8e070ddb7a45a19c442d3c 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -96,8 +96,8 @@ static int hpfs_readdir(struct file *file, struct dir_context *ctx)
 		}
 		if (!fnode_is_dir(fno)) {
 			e = 1;
-			hpfs_error(inode->i_sb, "not a directory, fnode %08lx",
-					(unsigned long)inode->i_ino);
+			hpfs_error(inode->i_sb, "not a directory, fnode %08llx",
+					(unsigned long long)inode->i_ino);
 		}
 		if (hpfs_inode->i_dno != le32_to_cpu(fno->u.external[0].disk_secno)) {
 			e = 1;
diff --git a/fs/hpfs/dnode.c b/fs/hpfs/dnode.c
index dde764ebe24673c339d4602172618dbf6ca0b5c9..a89c5b795c4bcee590bb9200296ce78c64211bef 100644
--- a/fs/hpfs/dnode.c
+++ b/fs/hpfs/dnode.c
@@ -550,9 +550,9 @@ static void delete_empty_dnode(struct inode *i, dnode_secno dno)
 			if (hpfs_sb(i->i_sb)->sb_chk)
 				if (up != i->i_ino) {
 					hpfs_error(i->i_sb,
-						   "bad pointer to fnode, dnode %08x, pointing to %08x, should be %08lx",
+						   "bad pointer to fnode, dnode %08x, pointing to %08x, should be %08llx",
 						   dno, up,
-						   (unsigned long)i->i_ino);
+						   (unsigned long long)i->i_ino);
 					return;
 				}
 			if ((d1 = hpfs_map_dnode(i->i_sb, down, &qbh1))) {
diff --git a/fs/hpfs/ea.c b/fs/hpfs/ea.c
index 2149d3ca530b6f635ff884988383bdde21be5e7a..7440d31d2821fabb3e2cf4327281c20d16773225 100644
--- a/fs/hpfs/ea.c
+++ b/fs/hpfs/ea.c
@@ -245,8 +245,8 @@ void hpfs_set_ea(struct inode *inode, struct fnode *fnode, const char *key,
 		fnode->ea_offs = cpu_to_le16(0xc4);
 	}
 	if (le16_to_cpu(fnode->ea_offs) < 0xc4 || le16_to_cpu(fnode->ea_offs) + le16_to_cpu(fnode->acl_size_s) + le16_to_cpu(fnode->ea_size_s) > 0x200) {
-		hpfs_error(s, "fnode %08lx: ea_offs == %03x, ea_size_s == %03x",
-			(unsigned long)inode->i_ino,
+		hpfs_error(s, "fnode %08llx: ea_offs == %03x, ea_size_s == %03x",
+			(unsigned long long)inode->i_ino,
 			le16_to_cpu(fnode->ea_offs), le16_to_cpu(fnode->ea_size_s));
 		return;
 	}
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 93d528f4f4f28d5070162faacd65d3fc2341248a..cbde82a53066c5d467173b67b5e1c445fe3c9101 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -250,8 +250,8 @@ void hpfs_write_inode_nolock(struct inode *i)
 			hpfs_brelse4(&qbh);
 		} else
 			hpfs_error(i->i_sb,
-				"directory %08lx doesn't have '.' entry",
-				(unsigned long)i->i_ino);
+				"directory %08llx doesn't have '.' entry",
+				(unsigned long long)i->i_ino);
 	}
 	mark_buffer_dirty(bh);
 	brelse(bh);

-- 
2.53.0


