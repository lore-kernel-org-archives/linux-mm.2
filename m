Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 854D2FD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:09:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A796B014D; Thu, 26 Feb 2026 11:09:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDEA36B014F; Thu, 26 Feb 2026 11:09:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96516B0150; Thu, 26 Feb 2026 11:09:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B2C996B014D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:09:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 813F51A02AA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:09:03 +0000 (UTC)
X-FDA: 84487091766.12.59BACB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C99204000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:09:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Idts03oy;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPAQGlZWtF3twqInmv8UBV7lhOjoWbAcM+Xf1T0CoNE=;
	b=sN9htkQkGS6/cYpzBO4qhQK1AHR6sm8tsr3gb4eXaYnOMQkJ/zp2fPpcGsdoD3sa5/32Gw
	3E+6/NI1lb9KGE7wqKCHlaI1YAg+KTpnjgJLcH2QWHHr8qzMuZVQC5wPgIEMRDldGxwqpP
	ZOoB742vozvu+Dq2tKAierAQ2iPDvgI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Idts03oy;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122141; a=rsa-sha256;
	cv=none;
	b=EBEuyfwi0BhgORaXBixg8N7n2jw3z4fBLEUYxHPLy3RNIm9rx6KmnW7WZ5tVSAViBkIZ+Y
	1BbXx7oFw+i8Jw53EuW0AVhLsbr7BS93va5KHobg9T3PfUI21pgw/imz1q63YpwqxNJxsd
	wKh+iesFWj4BMbAS7bZ2sRzbCgEpWsE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5164E600AD;
	Thu, 26 Feb 2026 16:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF4AC2BCB0;
	Thu, 26 Feb 2026 16:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122141;
	bh=ohZEfeuOi4xkg2naUuFketibeULdy5VGYUJnnORD2g0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Idts03oyKH96SfAopisoKaTLc9SLusBKptp8k/MDagLyPeOPplHCfbxiFlufDFLUc
	 5K4x+4vaAaBsfCpythF7s9D8EXByli3J3u+iy7xATN3OlRJcUBEcuJN4S7kWV8Q8G4
	 kOfdNs81HdEuVdL2gjffCyo3XQcO4jO4Dnwu4cYxFGG1cqCeDmWXs52Am2xXWjWgS4
	 OHldjywAYIMuMJotzrCl3t6dbCEWDiOdxjpl+MI3bIDcoO73xuazQ8k66fi6Admx/j
	 nWxyaEUpqRkV/SeIHZG9VWpdqkUZ5a5E8jjeNvQO8d/KJ1BO0kCzaj91GgaIrGYKnL
	 sd5mww8Joksmg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:56:03 -0500
Subject: [PATCH 61/61] vfs: update core format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-61-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2734; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=ohZEfeuOi4xkg2naUuFketibeULdy5VGYUJnnORD2g0=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0TArPB/A14lA7MwkzhIW1OToQ0CsW6q2kMJ
 NMIT4N0RQ2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtEwAKCRAADmhBGVaC
 Fd2vEAC7kuwrOi18JaQDOOAKwnH+i9pcIGDqiGslLsrUPbu1STWmcsQX2/GZrZEiyYKHKP0S6Wl
 zcMnbPl3utwH6hWUgGtAY+gzzjhdicih0FDyp40jJOzpKVKjISFyGXmUR+d+WyX5NpbL6x7qZu9
 1Miz3ZXPbvTnSNhE8UDHtPJWb2LmH5aKdBmNvDuy1kUOZgpWBZN0V+Ugpt5CfHOpb07X6niHBko
 zYIXIl6b8SQvksIwttBHLHM7QD8ow6T8ami6Pv1KXGhOOsW5PIUcgKu7c6qD1Ir8/ZfUUAlgFgV
 C9+vZOR5mC4QnKJBd++VbAJ3ULe7TCMOJv3o9H2kRNMQGl5ztzX6aB9BGpF+YXEKrIeFwlVdTJs
 Wd6qjLkpJj32hltK0IEZaYfHtDb2wBvKqYxVW6nrow+NnCFN/ks1A7JF6fvNPLkiVzv6bsthwaT
 hT6eCv8yxReYIOkkcqbBpyYIyRStZuKDMahsoKkn/NLlvFbCqB06XLmdAHID33m0jXIuroMxuC5
 el7Oug4tahBPWWr4msK1xsxlFlcvwmzmYJvLsGrgik6EThKzRuz1zmh3kfJ5AOnN+pKoArTRBQK
 SunbKJEttAFl0PfaA332vCGW9ETR82ytCvG59Wew+5CiziepSNpMW6ZDKu0oYg5nww31TsjGKV6
 lhC0Z4ASG6kR0mg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: q3yi3cmes8t3993s7cxxaeizejeyk4zx
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: C99204000B
X-HE-Tag: 1772122141-394946
X-HE-Meta: U2FsdGVkX1+kXMpOphkHhAua1zNZNVxUdA+i+dZ+8LvD4D5LxYpJw94IFQ2OTgblYSHsfA4XKLD0JMEulsCKHb9IuR2iNWQ8guCH4Y70Gur7hUpU7Gy+LRWlwQ455whkbES5ADoN1cyIDZMiO+vwqm8rfPMU4P0vSIv1kgWhORbwecie5t1HFTNwBsKJJcSU0WqrC0OpqTy80pJ+piCR3P3g4jCK7VZGEiF5G/XgDjNwWQVMnxN2jznsv/NCH+BtbzXX3zAn2Znelwq5wUqxvmoFP7073yoa4OLIBe5T8UQTeeC4qYfdD7+NWApdzITIli11v4rIOAv1p3hZamKl8ZpsyJcCkFe5YUP5BrjiHLzoT2ann9NzwmMj1FnfqotfPwaG/aoQoD+ISh624ZpIQUFcyBpXQ+S12Dcll+PmcEbOdmlEpDt3AxUFWASXdNaBd9g4FwU4VtP+jUyxhgCgYeGgxCrIXTDsiknpfhMk+kwjKh2VDeDlKF/FxBWdr+A7ueCPgRsNqDylhFSS1lTJge6qMSjb7fh9AfaOdFBuEJojdi55xnR4WE2E2hfOdPAYN+zDev9zYU4+nkSjwPJnb41/Ye+TZBLIucTkPzRgM+dTO8QqvUGnVLAlHxYdA8pxcgXTvLHTMDtJZUb2zdFUVIN4XIi5x2WEfW9l0VDY6PgJ9dhFWvnbmoress8VPodIgwXX0+F9s/d6X96utvpzaUMSYBsX4HAXZWYRlg7m+TTJrQjTBbJP9kPEvPh5gGLwMgchL4h3+5aZQUBPe44iI05ctFmDfcdZD7v0111BT7fAOhUYUH+5IbVIqjD/cFbschLeNkP685kEzOEzTUxy76iDD2HbG71q0pjxzXe3daL3JWScXOutpr+6eLMu+T0U+c6iGi68GOUGww1x6/0fOV2psK6Hf7BwVn2ov0VMSrSfY+xPbZ75IvQAHHJWsNB1p0sNyfasw1xCDI0cyJg
 xN6ZzwuH
 T4Z4q/wyB/DWrsMWtHe1msXMgAJyK7NHnKkUjXDD65hB/+KG7cqDiF1BSKZcvVTUYWI67GH0X0YRLi6irxoeX7fc2OFH/8EB4BfIF5hJALDo9/xgQ47C9ZHpJ3o0GZbqK6LyLNHREPsmaWe6xq5aAN6YvzY08fnW0H1UpV3lv0ZBilpVIgN0VqJrl4UwQ/uB0/O4q9LUOh6m9HT6ederEnhPDFs1gv+rRcK/RJ4KqJ9SfhLg8hCLZ8v+rFgwlWJoD6uezeRr8XZhwk2eDUHoAc6m6cqA12m1j7qTOkd/o5SVf5z27A6DfRRtDxhxfotzYVxG7/aIwn6SBlC5pxLja6G+rQ2Ozgnmi1UtUzc3CQesDgeMzCATX205POyXGNMky9dg/jo+ThGW4TpeZ1Ugl1f2hmgop3voSUbTm7rxcMMEKqvyVJQ/7Y9I3S5lGF4nUo1eUvRAJaCUr5V/q3FPJx/Vl3WdvMuqL2KnyzAknj2RfTwWh0Q+OJ5QBQgnAWkgIz9pa5SPq9VhwfRm1u56M+OmtgNpVAzNCPLatyN6bJ92fIvUnnu3Q92BmRNPM48glhHSeLPUNC9htypu4OxYd/DdGGow9we10Qkw2zfp1SX6mv2TYjwYW5KOhtt1Qb9Xpw9G7jMe5f5gWa0vPu3lcr/qaLoKBB/8EGtGhbjJFmxcXpkxIGLHx0BnWCGOjWYMvyI6Ao6wmsubsXsCzXxnh4onoDeJ89PZAqMZDX93M/DrSOe0eoqHIuxXJl9qkgxfDy3NuKW5AVhm/1tWyLV8YnZgGjRJsDx0gykFUx4Wl+8WD+bZaA5cxBd+yxd6ShE0KxTYTP3u3AyTDKzxLVg/WFnF22Bbdbzd5jdAPgzutiJ0d+/yDOkf5efoCjKTjI4WLe23MrErGOX//CKjE3a3ebTAuKmT+UJLIdWtHQyQ3Qr9wSoDvyQSwAMSuvayMNzSzOyNW6cALLplrtcbRaXY0Qw3xR5Gv
 bURMerGW
 6OneP7MPmS78PbASypeeDkMQvLFqpZFqogx85TU1Eoj8XegaeWHiMWoKsximaHOmeKdYwBeazY39OuW8jT5dzG90PdwRz/oha/YN3jijL1+SNOCT9KJsjTEtamYBrOqDk7JnxKL+Dx4rZL2SN+IP82LIafF7b0Ud61qi6BE8SQxg1fwOfHjYcDZW2cURbeFfWQwWz6MkOEQVCr+sdaYu+VYFrrwhLTW3ZNVP/j5Rb0Lj7KLtv8jk0zbYfMYdgpeL48GIp05n8xBWqET6UbjYnit5LFTxd2hrLNBOPrZguByVe7pUu8qTY9RKr1aoSdSJxfMTAwJkkx6BChyH80X/ojS+4yZ/NhI2Bv/kdjq5heetoAV2+kLQ8Z3cVr16tG1EDpjIovuOKVAt1vFCFDHLBTMG5iiiPV8vXqMjmy0zI6ar58hX1uQiF/F0T+Q1F+Raj3gJay9asOs1FIpINWh6vu5UDu/O71z/vgJedfNb659ngy/XV4mGxpGrozzQLfkw43PgUJ9+g9Ouj+0KZSV9nxQe85foRdBTnoXgW12wZDJduDAQUDFN9CObabrIzQefLNHwR50LMbchsFSt472Y9QilF1epjGd9Bx69GHOPmZKsSP18bCoM6GVjYJvEgwWVrA72ud9QpC6C1adS38sNAx5uPUfJbtR99ZFMzj01JrvjqvNu8JJsW2a+nlDuxjjQwYSqvrdi9cRvQuK7LFfLWYeUMfaFHP78pkZD+NML2WtT6yS5VgwiYsrwdTwkMQhGlv9wHkjNI9koumURd8ZwBhAcGiGTU/fax/F8yO8hK9Rav9s076JF1D6hCEnLr18hZajVtHFYQ0RIambwtwHQ0BumfbBJ2lStRtTEUIuM8htMTm6II9H99UNzlH/4212DW9H/NHLIlJFIg5xkm2I4MJLBdn8WOzJB5+Sqehpw9pUjjUFU3wOjpyGS8RDcV92hkN1Vu6iEfwkyDKgwsgBA3Kj7KAGcj
 qAOjIqnl
 EUmkFG7pnhbL1LeNu0gqQyCDB8d9WwJmuFrFklOrR4/i3bfB0bxoYZUeNTeOPja5Ruy9jAMECeaP7AQ9CVhIh8k204gFYk119cV+0EYtgW5hlRwck5zAjKcYi9jvRgSfo+WwlUnRr3RWj2ABqlm6vuXEishd+TO2QrqRRi+hssR9AAZkqHczndQPhBLcTBOgSyqGKQwVJj+0gLaQHdv4vkqFc6qWV2su/APgZ2kE9w8jx2w84J9ptrLEvOeZDxzNDsCgVJBvjAEowx4iGqSyTocCtfwiC4D3CPFKVYGT1UHWT4oc4wTsoovaI57dJZWEV6UnJhsOZu/2/c47iz7myRsjK9b/bPShw9KNiwqdAtfs6R3feC551qfXA2CyWTGgvXxM/gt+GV1EcUvV5ugwYF2smf8KTm1mJHJp01kgbV2Rh51pRLv+5tBaQN7ifupbFrjgXealuCRI2JCl/vHv9YXS1EsNev+/p7BdawueU6eiKEKi671cWh9o9xQ8ObXX5gqi23MqSy6ZlJtceLkwIaKCxTvtJ1X9GuB315XCQwKuWd5vrbuQAydXEAgSF+RWlIEWbCv77n/VUpVudiSIloc0k6XmhfrHXNUw18szcfiNRWgKC41Qj4S+wfgG7PkO/a6T3/XTfPJjgvd++jfGaY8rKuylI/3HpWXDIMyzXEAmtJSBYIHVBL/Xu+5zmkrFOqabmd46Fk1c7RxS1cg7zORPXDWrMLWhWpAmrQXHkCCL6s/c2JALLQ4jWg9QMR8YiGqS4L9CfSgmt41jsKYnSDjnfOSFQSd89pFP/FUee3I5hwfcKQ/dWIBmyAwPBZdOwi2RM5w9qcD/Tl83qZcyye6JV3AtuUenZWbouotaRKyQB+cELrdnLu5hVTV6RkaWTi2df4ZwsY4Y6ZFCaz+iopwT1Wq2OYp8wMuLFUwkh6YvDE8zyEt9a4fwq0Sl+hSU50pvP4hF3gzjD1SRnYGJl0wswp21J
 tIA5VwmD
 W5yEXT0uYUhQLFADoAk6hKyHZ4JeE+2DYxFN41Kuzun8kCu+uNxcolSgtpLJ2L3K+p4tEGh9UeQRHy8DUd2RZIGS9kvuZYjNPFZGKrfmbpmzbhb06et068YLQXMPtaxZ+MYVyEmDv/SoXjRUUdklMAEkdD5D8erWanyzzpToi2tecBwLUh5oJCS1Y4H5i8Rr2V2bx0oUkdKSxz2VNPdWTkmCnQXNwPmb23b0eV6BVityOfmhPr11bXCxyvmtIE0lEypzkxsjx3sesSPs3nssfcDkdb7SLprPsgBkDUyon+4WrjDqJkXF37HrhpEcBFUvM6HKY/fniMpTVbOPuV0tfOgBed1yquNviMZkhOZmIaG/XVQl6+GzqL0Sb9pzoXlGPiqwqLEt8UbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings from %lu/%lx to %llu/%llx and 0UL literal to
0ULL in pipe, dcache, fserror, and eventpoll, now that i_ino is u64
instead of unsigned long.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/dcache.c    | 4 ++--
 fs/eventpoll.c | 2 +-
 fs/fserror.c   | 2 +-
 fs/pipe.c      | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 24f4f3acaa8cffd6f98124eec38c1a92d6c9fd8e..9e8425ecd88955c72027d21591b1d12c87e7e8aa 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1637,11 +1637,11 @@ static enum d_walk_ret umount_check(void *_data, struct dentry *dentry)
 	if (dentry == _data && dentry->d_lockref.count == 1)
 		return D_WALK_CONTINUE;
 
-	WARN(1, "BUG: Dentry %p{i=%lx,n=%pd} "
+	WARN(1, "BUG: Dentry %p{i=%llx,n=%pd} "
 			" still in use (%d) [unmount of %s %s]\n",
 		       dentry,
 		       dentry->d_inode ?
-		       dentry->d_inode->i_ino : 0UL,
+		       dentry->d_inode->i_ino : 0ULL,
 		       dentry,
 		       dentry->d_lockref.count,
 		       dentry->d_sb->s_type->name,
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 5714e900567c499739bb205f43bb6bf73f7ebe54..4ccd4d2e31adf571f939d2e777123e40302e565f 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1080,7 +1080,7 @@ static void ep_show_fdinfo(struct seq_file *m, struct file *f)
 		struct inode *inode = file_inode(epi->ffd.file);
 
 		seq_printf(m, "tfd: %8d events: %8x data: %16llx "
-			   " pos:%lli ino:%lx sdev:%x\n",
+			   " pos:%lli ino:%llx sdev:%x\n",
 			   epi->ffd.fd, epi->event.events,
 			   (long long)epi->event.data,
 			   (long long)epi->ffd.file->f_pos,
diff --git a/fs/fserror.c b/fs/fserror.c
index 06ca86adab9b769dfb72ec58b9e51627abee5152..1e4d11fd9562fd158a23b64ca60e9b7e01719cb8 100644
--- a/fs/fserror.c
+++ b/fs/fserror.c
@@ -176,7 +176,7 @@ void fserror_report(struct super_block *sb, struct inode *inode,
 lost:
 	if (inode)
 		pr_err_ratelimited(
- "%s: lost file I/O error report for ino %lu type %u pos 0x%llx len 0x%llx error %d",
+ "%s: lost file I/O error report for ino %llu type %u pos 0x%llx len 0x%llx error %d",
 		       sb->s_id, inode->i_ino, type, pos, len, error);
 	else
 		pr_err_ratelimited(
diff --git a/fs/pipe.c b/fs/pipe.c
index b44a756c0b4165edc2801b2290bf35480245d7a6..9841648c9cf3e8e569cf6ba5c792624fe92396f5 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -873,7 +873,7 @@ static struct vfsmount *pipe_mnt __ro_after_init;
  */
 static char *pipefs_dname(struct dentry *dentry, char *buffer, int buflen)
 {
-	return dynamic_dname(buffer, buflen, "pipe:[%lu]",
+	return dynamic_dname(buffer, buflen, "pipe:[%llu]",
 				d_inode(dentry)->i_ino);
 }
 

-- 
2.53.0


