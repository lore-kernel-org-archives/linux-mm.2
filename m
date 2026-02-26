Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B4C2FD8FC3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BD4D6B00D6; Thu, 26 Feb 2026 10:56:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887906B00D7; Thu, 26 Feb 2026 10:56:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736236B00D8; Thu, 26 Feb 2026 10:56:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6163A6B00D6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:56:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2EA811A01E7
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:56:45 +0000 (UTC)
X-FDA: 84487060770.03.7359601
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 47F6B120014
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:56:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GJUXRCbN;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UTcvI4LE1U0Njb0Id02QTZ/MZkj9HxDiWsbitLTNF1M=;
	b=sUvoZ9Gm34knnvsyxcXZVNTBYtgW886+oXjXqlbB4jZ3SR1ItQOfQNpzTtGj4cqqNEe1rS
	pVW9l4Y6C/uxOidBeaywDraudhQ9AE+1ioEr51STWjB2crTPoCeMwX4MG4JajWWTy/ZQUS
	7WqNWrx1VRpwb2oVoxYniA4UuJSt9Go=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GJUXRCbN;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121403; a=rsa-sha256;
	cv=none;
	b=CBhZj70udl2yLKEaj3sGat/LIRIX7hnnM9Qy+7/dVxWzuknfZz5mA7rtLCqPjMOs6yod8h
	ECrWWyBO+z04dQiBeb/jgi2V2bzR8HYcVsUf/Ey+Fn8z90tc5zYAxEfbOJ3nxjYPjABMeL
	3jEpU3okqrpxYiz9NYY42C19LlEjGzk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2693441663;
	Thu, 26 Feb 2026 15:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD31C2BC86;
	Thu, 26 Feb 2026 15:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121402;
	bh=p4gAehVmKV9HRwKOVD7lkA3H4G5n6gGJrLiMZGfJlk8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GJUXRCbNue8c5nQUmOYnprKKGdq7est6xgtINLJuUUXA4AxOjErZBX1aak75+Z21b
	 sxiP1Rl7ai+UG33KyVcwcRkjZXWRDBruS7v9OzV8IuEOOSF3c8s1CXc28CbGsrZGtE
	 xD0keh/3myZHJQB64m40mvnfyBsaLRvn1Dnmw9dC0BDswBoq55OK9GwHazx35/BTvI
	 AWKEnc6brxgFFmMt17kKJI6KCK6v1ivCu24aRSOj8nQK8WkEfm+jfEukffTvGE03Ll
	 nJ1uNR5hOO0JnT6KLr0xHOiP1dSY5HMiZwyXHC/GMlpwNre1sCDIp3ELyKlr7lS7OX
	 qCy5Ft/TOotVw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:04 -0500
Subject: [PATCH 02/61] vfs: change i_ino from unsigned long to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-2-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1326; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=p4gAehVmKV9HRwKOVD7lkA3H4G5n6gGJrLiMZGfJlk8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0E7jdzVUiTIZmlR2CbMineoxpzqpeIgZghk
 w9xgP6zhVKJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtBAAKCRAADmhBGVaC
 FddWEAC/pE+Y3T6Sy6mzHZaq/ChUkWFVvyHrvP0hJug6Uo8Izaru5rInGMeAdUWp/Kq9GEBWDYd
 /VRX/PMYewqA9ZBE6BfIe3k9MHRxDbRdJ1DDUZrgrfwTjQ+V1qQZjA25e6SflJIsWyPi2tIsTOj
 3pc9wz4+v+SFEPDSSvdwlwsd1DUeBkbZ9w7suFRGOI7I5VdslhapmQuqz7wOaIsILumdQIA5V18
 1sA/ljkjTWvu3wRqnx2/HZwqH6Hk3vCl4jTwXTKMOtbHBRhN9T7nWQg2XKX323R54BIRKKDDoa+
 FIms6yXt07D0pcD8Qxe3ynSsIZZlM+CHi2etoc3KcSBOQZ4qUUhKeekchWa5rXdnUR5dHCAccjC
 cGFjJLxuGTBREkSYZVk1Dw+nJZVJqCzjeRLtOkDP7QdcQn2UFWnPuuDiiRSlDo11QXWh1cUNOJu
 umuHhAch0IS0VZ4zXX3Pm4XqH49/QnNNEPW3I5F+ezC07rpVel7oHK+Wg95LWew1niKhvVTTbtA
 3n0H6Vm80X1OlmZWH4V1WeUN48P2H4agTQxObtRr48n07+hmCldNwwwi3o5mArzoh58n1cVbutF
 bCbB2Iwu/fQevOiKPcQuu76biljIvPYmgGX+lQ30ipMaGmAOibaungypM5v6ep1tOUtQApiOanC
 dYao6xjrL9V2c3w==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 47F6B120014
X-Rspamd-Server: rspam02
X-Stat-Signature: d8frbcn93b94qbc7q14xg6367p9jw5pk
X-HE-Tag: 1772121403-722631
X-HE-Meta: U2FsdGVkX19fzNLHWOgYM8/LmlMRtCvlliOOnaFesMhzrei9+UN/N/AMOP2ETLXjn+ewp9htbEzVHhnlBxE7hrJFOYKXrPH511XRTkSO0X6p776qsedniCqwyk+CRAUeFo5HzCxcd3gX4o2sjklxC5CV7K4OrtLjZJgcIRS3n8VhWu0vC0xb3imyX+qxpJYT3egAm3CMAF0YzfCwou++rxgK/Dps+/LEEeQJt7LlxRohCuqVEAWkAVEAb0Br0cNPBGD5MA9irtZxcCSnKfLLRUmN6u7elOYPTb7voi9V1I246JcxAYxRIvI7zpgYx0pZMDLCQecQfTZrqTz+0NMhYF6+aBDzNNgyoog1lWsGKxsZlBZL6XPVZq6cEy5r0p66LqRQ5m43mxQKmhIC8er5SH4fTsyv6ZnoVQ/Q02EcfYpAddYpFu8zHgchA7vLavi2JGV9FpdBOjHxMg9KvMsREmZRnROY5gWxsvn1rHtFfU0swnrUfReHZ62iskIsDZcdhQM4MxkIFB/aa7sovD7JmPr5Jy4l/37MHcx1A6XcoQ0g1x8M6IsBSNM9L608B7yytVhbDW4aGA7K16uJVfX9NjmMkjA6sBjiq7ikv2co8e6hrjo1jdQ0vbIs8JCFUrjFYpJTZve7PXSj0cMuR84QYYlVB0c5RUretQ55oRxCGL0BZG4W8V8sw1HgMl0ubnlUHfcvtxN2mIboUt/faWg161x4I74/ZAHest9udE/Q4nmQQj6Q5r1CFWiD6Eb3Wgy0o/UWl6yQO4o/gXaZysl2bZmprVrJPUzcrar7LLl9rpQt8LgvNMc93Y/eUmBu3gRpyjeA5/FTSJrPRunHaEHU8DOtXm92WE5kyBH4pLdXmOt1/KSmB9O48c4LaHV4eKf47J9OVabrZV5h8CPrsKKa42M5n5NeU786mjjQuhwn0bibVo+abiop59vtT3iw4NHWaCnqm1CIyI0Ze/PEpoV
 UXxq9q6D
 IquB4mDhXKWm+E9Pw1a/dS2D/L6QztjapcaQclLMZoUiysma4zQ4zqW4uKd43DMhIAgeErYsh7zIIzl/EvWJf8nY8jVYcID0az0/8dEt7pWRTmyVOebBVVoBg7zrKEdW4yEhtjc/MDG5ePhiMA959tIppAX7nmPlmtg4osR3Xm8LwD38RtCa4INfqpjSiPEhsNT4z+8e7FpO5PcssQNB7r2RhLMspy1I5SMzkK5gIUcFDKgmN+K6/ccfp/79DS0S2Pz3eADRqDmDB24TFB/aeC8wSgDyCk5IJQ4ShgUaLkOlZyImBddQRypfizK/GgLcMQgaQw3gUfCoqKvIyb/f9LzgAFvoD0Le4CURYSzLzTc1HeJkgVknwotwp9GuYD+wc+uYqL9+qLwQKIIOJq2PAEycMgefoyYbcfLLBP1mrywGJn1CMwAaKL2tAU1z3t4x36iTVSBGH866ZXygw6UCZIzMu47Ek6vthltChKH6PE+3PuJrrkeWo/wW8cIG3RKxBWP+XF4Mr38rHtX5Fk2T+zdqWL+KbNzViX1d08jpHhOEXG1B8FBwX6+N6o9dEhqm0jK6Fsakf8e6paC44/75ZmNPq18wLPGj92jSIt+CConOBNYMKCDgjq1AqxS3efj4MIuvcSn9O6OF94rW3taSK3INVLVRMrZ+XMNQ/m/kcWNRsZGWzCbpZUS9kuzqvJ7Rr8djVYg7/83aYiVkNKAFEskDv7RGFfUewrP8BRr0hDUyDhI1xSwMfAE8XKjfaVBjCzyr7F0ISOC1+cpYpksfF10494vv2qxENQKsXcFt2rCx+FvjPF1/yZjQnI4dqvlrdeTxwiompeLNFlSdy3i7wAh6Sl6DoWCguhHjTgyOIUaAMPTq8Yca8o3QaQhkBK8LZcwjLnHgV0LS4H5Lw/GPNZxMX2lgISGjc7sX7yp2GqYEl/rB6pMAsSrmqkhVpT+VfgnB8wjpNH2mhcwjJvJ5Vo80KOL/+
 DCrMNs5T
 2jhgiDjpwE6k3AF1sjQ314TvyknN95tbSP7oCGen1OCT0zy1PT8GdnPOaZSSfQi6FHHRh0MkrYAK+z966VBgxN+pYgw5RwSiJ+Pvg0V7a8Au5NpzzjsmOu7q0hqVRZOdRJZqw50NsrR5op3NbdzxnG806T+PIDvoeocGerVBWJSm9xTvk/ANjT/RdVXBFewYct0ma69t0qDqOILNw+xHx8/Miudam7bH2dJGStG0H545O9hqciH4HkSx7tQ4iyyrpVMOg7/01dzPMeCEKZa5+cncPhm47PsDKMbK6cdMhwmHlZ3ccI4tqrebRJS5v3U/K+laTIrYybpd1YZ/dUkzMRizOR06LQc2QQJk1y778meWi+sp+LC7UezKjsl3S2moPlERS1MXkYe/1jBmQ4d0XqdTABdKSMtylY5Vwsm9YlU+8rn1uitwTMJ7axqLjH3zK9l+9ILxSiujmxNNRKql7Y8aHl3ETA1imMD/WvTTb/qasiirzIwN80ZUK/ByA2cyz9Hrt+CNe5KIuiMcQ6aGUmrcuApRZwvP1/Kiu93NbdQC3L18H+wA9ztQOPk+f7rNz2Xc3+BksGZ23BAceBTFpvJ7tj/twqUe9IkgA2WJRyy723Off502mfXh0Rgcb0nu02ER6EJJeqWr8UMo9m0hAkyEnkW/LoqMcEzlkA8m/JvqL7aI4WBfUuu4Cu3jrXJv+1phv3ue6x097THqBZFyPmxBK/YgpCYZ4HyiycxJ2kSO8pEbBDJJVedFjYSYZ9GlD8Mb0ZPm7ceThUuVMGxrZ1tpc7WDgtNYmIFbkCYH/NBinqSVvLaw6/V+Xph1XxWTH9toseiQox03pTw545T+FLMeL584EEY/kUKpCpm3VFkZtAWBTmzuyNKywOaXroyJwa6BH+7AQ1DEcOrwZgjTwqQVFZkYv1/WGjhaIK/hZQldAp2Q+N9F5JRlmrpXKGfJNP5keaJ+njGLJjV4XK+dBnWB/cFNv
 nT/X0OB1
 X5cdFOcLaolKGJz1DXictdFDd3Hla9IjpNc0dtuHUd7NeWq7BV1TnWXtacV9Ad/bQ6EqzCKoZfxu1bs4b2ZUE5aSAv/St+mQHsW09fCUGCLymm1Oh/pwFFUfvNmo29xCV9w1sUy9ujges4z7Ia/vbbBTtTJFM6ISZf0eWp1GpS/LkQcb3BGL6VbWey8DysO9Jc/eD4/gdVb+SdACIr1+MMWesOO031qkv3nZl4KFo21mgivMEghBeHG2bEI0vh1abPoqRDJMnwqxb0Rjh0vdJsUX7+Al4bRvr/G/DQ3Q1/PI+3DuiIKvoz4HwgG0tcQR3IdNSq6YPFKd66AL4rXiEWm7HNN3uXIUy4sHlN539O2bposaRtBNOuygMbXWh/69EGinh+kDj+dS0bndu3IPQwwmYdokQBV7XktR3fl9eBYxGtSHb8txSnmDMjzYmTBXv4PykhkIqyuN5iRVTWdM9wWXjpeGbiO2KAWmRkmXi4Ag4IbdXiZBam0168wJglaOx5RmfJ1UxwX1aS3QXZtP+NeRMuY1eAQ88TDT5SxRhViGAqXTqUhlVm/o+Yk6fi2F++h1SqrghgWmgycKFQJMIfPBysemJzI0R+ul9HI8CKfl0iEHxL1Q/VedczgIlaAfSNGQVPNiwCWH2QeO73yADU1pjhQgp8uyla3Z1mMjxjp7IOTggo/b0MdWhe9Jl2Ef/32cScQfjsAToNvmoZeRDVfbq303d0YrVA/zmRUxauPy6UocQzEhhR6FnzxoDbYFIjjdROHbk68zV7q+0F9Hgx62y4pnuWyADbkB6xhbUWudiaLEI1gW85m3BUQkay3EhJiI5cjBHItyrGnrloW0eXxQ427Z4jJ+Fyj+xqiiBcFQwAskt9HSZ9CvIBjXIb67PwfhWRY+oqcisQINsqEUWWXUDKbdAAR3CgZcOlFQkBDv6kWDPhCzyNvevdlfjNx5JnYNflz3KJQL11/y8YkPha0baweY9
 Ru25GblX
 aPIV6g3xtE/Z2jS7s/X+IFpV59kq3NYy6VZsreKIXX4x50QLzCq99HB0uNUFbBb1RV2usySY9FHQmhYZjX0PsTSPcWE9/2kXbiARfTVoE53VYD3zDK3lkcD3+Pq8NijQ26mZEfGhOVx7I2iQg0x59XKCDogJGoz/BK/JihjKedgT6b7gUIRu8w1do/WTP2I0eFiwppJ8cL90gBK96RTerWCBL1GXFwUt/py/5G0gCg46zIPRkDlSecvxcL1qTrLKDjBxoqUJTjZoIHUTOQj0MXDPkCK74bMvssKtYTXD0gyvMq98/3GjWeDwNsvr0DB/H/zGtvLz+JcYTOUo9o0c2TqgQgxvRcIkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change the type of i_ino in struct inode from unsigned long to u64.

On 64-bit architectures, unsigned long is already 64 bits, so this is
effectively a type alias change with no runtime impact. On 32-bit
architectures, this widens i_ino from 32 to 64 bits, allowing
filesystems like NFS, CIFS, XFS, Ceph, and FUSE to store their native
64-bit inode numbers without folding/hashing.

The VFS already handles 64-bit inode numbers in kstat.ino (u64) and
statx.stx_ino (__u64). The existing overflow checks in cp_new_stat(),
cp_old_stat(), and cp_compat_stat() handle narrowing to 32-bit st_ino
with -EOVERFLOW, so userspace ABI is preserved.

struct inode will grow by 4 bytes on 32-bit architectures.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index dfa1f475b1c480c503ab6f00e891aa9b051607fa..097443bf12e289c347651e5f3da5b67eb6b53121 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -783,7 +783,7 @@ struct inode {
 #endif
 
 	/* Stat data, not accessed from path walking */
-	unsigned long		i_ino;
+	u64			i_ino;
 	/*
 	 * Filesystems may only read i_nlink directly.  They shall use the
 	 * following functions for modification:

-- 
2.53.0


