Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A1FFD8FD0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122A66B011C; Thu, 26 Feb 2026 11:04:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4776B011D; Thu, 26 Feb 2026 11:04:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDA4E6B011E; Thu, 26 Feb 2026 11:04:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D4F4C6B011C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:04:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 90D581A0311
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:04:04 +0000 (UTC)
X-FDA: 84487079208.21.A8E0CDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B4D10100002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:04:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gJlVm7bE;
	spf=pass (imf14.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXMchDH+vRPKRhtU7953G7pv8kQazBSFmdZQlAW4X1E=;
	b=fiRE5bSAZcYz4tqE1ddfozPkNdzrYv8ZYhaRp69giUerU6NJPoShCc4uWRTH6oo3HIYLW5
	awEOM+b4vLJPImDhfnErG8gTnvnS//BOjZpm2Jmgs46RIkJk/4IdG6DfyMzqVjxnsRYKKG
	VwhzAwvc7L/Kx0U+128nebptaTqa0m4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gJlVm7bE;
	spf=pass (imf14.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121842; a=rsa-sha256;
	cv=none;
	b=8iSv3PQW5qQzmSXNd5jm02P4+afjagmMKexdH7ptpE6g3pLM7cjn1QWqAS0yV6/EQfnlHi
	iLs/XrVVBAAnxmla9QycOd7rEVNEdOF6W5+Xq7b5QMxhDMZuD3kDNAXRmofgv92zzDsfU4
	ZuGPGH0Pgd4nkeFlS9MCdPvwXw7Y4pA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF50444047;
	Thu, 26 Feb 2026 16:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D281C2BC86;
	Thu, 26 Feb 2026 16:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121841;
	bh=HQnqBhHZU2sAWZhxdsq0PVvzgqOCHqHvsaI1swrWu1M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gJlVm7bE76zMjPY0CgXsfeaUiMCfDr29KRS7Vh4h2cufOsxVaL5HokgQrFZjvKWr0
	 LEH+khOHPUXIeREJ7JyKNIXJlLHTCAOxJPnAYoeWoFtolV2nTN/DhtW7MOAbUVibQc
	 WTdgnawaWwkZx/nuKKRr7IFt/5sE9Nl9CFm9QEukVr5io4yf2T5BY0t386rJEC+GEl
	 SflifBzQRFAoEaN/bU2SoYbHxhSyHeYnJKCUiuG46KLIUz85b/Ru9/lo2uzwMGJzZM
	 y3ZayvYKCJ9VnC/06j4fIoKbF7OIfu0CdyMytRJDWNemrerfOYGB0Kys9ZbiVmtqY5
	 73k3GRG0I2lLA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:39 -0500
Subject: [PATCH 37/61] jffs2: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-37-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4882; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=HQnqBhHZU2sAWZhxdsq0PVvzgqOCHqHvsaI1swrWu1M=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0NSWGyn7zHQs4lO9B7QHYKEbCOl3hhGFFiP
 wXI+jDlXyCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDQAKCRAADmhBGVaC
 FSE6D/oDcjFvjSL27UnDC75n4tTWmF3e+3hOlngVHS0P8swlrVZHH8UB/b5H9mPfSBtEwXOQ1Kk
 MG7NQleGUa3kL6qeHvNkP+Nh8nsEaTHjrvHUZiIrhWp7x6ItgtwqyKAOBGvCIm/ta4v/QNNLCW/
 U7+MA/+xQRyCPuJMUkEEffctlwe12qlyupf0uWNsR0SVxcFfc6tuqzxl7CNAf81vEfaRGZXKOjf
 iBw1omDa0EZ5xyRlJQgyvwDn6gYmkqiCec2DjDz3n21jYMA6oUvsdVldlPSoT4jBRQwFxiTUZwY
 4WsvihWU3QXqlN3KfgXvQBm4yE9dar7P0n35DxdQm+bxDzg9hOxMx7DArTKBYlogjLiQiaEkbIJ
 QyD6nTO13d55OgImz6XzFTTGgQSBr6CVz67a1snb/v5o+133K6uJ5nJ1HNXeptjXGc5O8ea3YOW
 +A/zEnZ4mJfWGG2qeDI8yQVZnR5lZV6OyCbzZaLFZaxIvadZ6m4EWHmLfcblHaPIguoJbzdKyVJ
 9b4uhXscumqEchfZwL61TofMl1Wnc4+VvquOetaInENpVxsGuUyv5KxOr4RN1gknWp1mzefX5v0
 nusE399ByDmiN2rubObzc6m3vJLBare12HsXVGbGORpySeuYoRB/HJXyFKUH4NBTzeJfVgIZxL5
 flGSB6N+pfsDpgQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: fidsieoe7343xhzxtdy5k6q6o76ypmgd
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: B4D10100002
X-HE-Tag: 1772121842-538641
X-HE-Meta: U2FsdGVkX18pHdMAIQd1sMUw06Rs1RhtL/I6caIrTE6vsDPEEXehyLnnH7/WjZ7xoQc7xx5oZrFLeVsQfnpSpBYF1RlTNdXoWqiCy/sfT5dVTXjubcYhzR34NqODaZHySXD0vOr6LoRH/FNomTTaJJ6FUUERz6E8KJVzuftwy4Dvfuw7FlAreyi4fJHlQJ61/FJpDUEWOEXzzz06ggkqPlWjl4n5xNRrm+7FNzQghTQbRSFFvF2VKr0KLJxvisVeJpPPQipbJTochO1BoGIoQ3w879o34SZXxM7YdbwjrTF89MTLjIMKTpAkEwbsHvF+Dji7tpcMFMd/ph0IkaQkW1TpHBoFngmxFQOCJiLjcbzPqGrykgo+3/W9T0DvrtgdMjlgvrHW9X6c6M3GMHRG3ne6LLReeHKb7fxn1AUFV08D3cdutNzcigXvGdyiD1ESBoD04BVQrmxLKPnXz0cxPyu85fzvAmlkz5JRfOa8p70fEdiJ3/8cMBFcfoot+kavwoiTjB8KcENV4LxZj6gRuIPh5k3jVUQVEAOZerMcqhWVU9DvariMcI5BcbpYz4YZlSTTtZ79KScjYJM2BXvUS2Xlp0kGwuTxnjY16e7Wa20XuKHrDsjeMiIFj2XCbyHxm5rvkYhEn+x50K1Om6E7dUpXEuiCjgXOO9vcZWdo90Qv7wUeAGRRz+Aaur4gOz5KSnoP7YJTIBtZmqk/CAbBxYcLXLNpsWpzY8IisaLCe3gauw9yL7cjDARjqsGwohbEOabY7MGzRh3tR/bCRN4vM3+IL/35AKIb+wNQtWGdFteDpfqa6wd6zaRpqp8LqhdOm0ebbE9KIMtLeMygWHKFawmJJqVP1KtxVJy3rfT3PDIqkUgU1IrLBeoiQVGbWR52WKiGF5E8geiw9YXjPfIFnjiyp3l+pstQxhWj1zTcrGg661NxL7l5hE1bClUVo9vQBj7MexkU4E/KwzTv2jk
 KBk6UwLs
 QnLaz0UUKbI4135/RfWVsekiSf+EBMUk9Z4t5SU3/GY5pyagylKN2i3RSF8d53Kgdp8dw4cDSu7s1iuMRhagQlZso1RsDvQxTLS7mHIQdvd64aWXdiucGkNFkPcE1HR6njnuvxB49xLiolDLMBLr+XsWgpaMvmHpIkVxhE5PMShmfhRON5Sr9eU/0I9dNiOzYU7W5HCcltFXAdnyHC1zYB6/j5npZfCaUyfvzgU1w2Qm8UY8kS1ZI1GVKFtkGMtof4kb98b619GwWRkfkG91BmucHj75P2YyMS2/a/EYeuzHnmSRoE4Vm2+JW0bVxRu2PFHGQ4AbWvJr6SnG8Is4RYtSdkyJRMTis4QkcPw77gyPYfwUh7fwBpIecvgrTfNjmAwK3tHAC925WMSLDU4g6USXPwAy8Z6Cp6toeJr8yVzD8gYRakGyYiz+5iLnEpkxCEwrDiRgFQyHk/a4hMs45FyiiXcVvpAT+vDWAXbcrVkjInEpjcAWjTK8L1mqmQ72cXBokPoxdRPV694kY67rc2B9ndphJjH+8lyfxmmzBOhIQ3BPiR1LfhZT8E9GAO3CwF4oXIK0BQrFMOeElIrQbuLzfxwIW9AfWs14Ytl7PDSYRkGiuJ/K0D23/9sjWs4HVJ5BW+T0USxE5cAWz5VngJFgm8xFXdcrb6JtiUcvj4PwcldFn2bdC7VoJD0D6WgoC18HVlEnujq/o26lhywdoFqpAl0UOSR73efFdc+dIryifd1VTJ0mRnc6p+vpBAOICPhP5AriJxD68hrnqjeI3ucR05HL57QeyT1zv8RO+cdpEts+iyLdeaAPsSSUq4FTJ5RAZKwpzelmZ9rIPUwRUqEIo6ZT1YB0aJDfb+Zmy5BOCOXM3z1Bo0pXFFM8unt2iKQqr1qFLLT/rnp5/iIjZBM3NAMKrVpqyBWCCwGEPvSo252v+Jx37Wa63hHTFbpbwTJyJnE8vIFLfH0lgku6uJnGMsgkV
 3Fop7zgY
 D5BGh08661bIqf4F52HrPjCBsGaRGI270rVwcpsl+IdO0FvjeG8krMc22bAMY5XO1OBmTwOiy68xx0WiAIOOIRUrV3RGD8Fagx4P7Hju+jStfftQ/sN3/xre4L4n0WijsWY5p9gveGsE/zTlGhjHBceWlqV5qbVgubxtwuWYyEAcciioC/Q16y1vCm+uM8NkCGrwLmTkzLslIEU697N+9n+afvcxqrmASlo4rBhYi/41fjUs5dOoCDvoR0a1xODRZjn90vcmmwlBTz6XuksfhDgmrO4nLGb6XY1AYY0dYDOD1GVsW59my5Lm7ycNMjLk4Skh3cDG5qc8KvJIM9e+ySrMzj091Ed3h5qTqUO5ANwiZyYODfMOpiUq1xozXK++2f6sNMg2BHNgAoZfo8z5xw7p8pKsli/S3nC5VCmoZBZQjQ/Ak82Wv0rKH8V8NhDksnZrtvnewpX7+O9hSTse02HSvnVMiLNTOb0uah+5njOXX2h+8fhXycVjliryrv+pJdUdOLWn0nDS6qrBHWuMrY2Rj/iMWEQM0TLnjOJMHdLinlt9HQ8NXQ4l08nPKCtvxICgjAToCMTwJxKEJRTxbYVQJCR2EJ5FOvuFEhVtmx3apTHTn/LjcLaxwOEBpsFoD8BiNPof2AnkmDTUCmzzB3NOdZmywaE7MLY7ui3VE9m/tYvjwbsedHvf1ts3XIRw4wXL/PIHecAlIsYJsYdeERHTrYeJvxrdvIQOxup7EsjiGkQe6wW+r5OU1fmBv2Wnb6acxgRLNXvozTpFTcoIE6Xw0vgPQATwplVJFR0yTfABXbsLNyr5cmDf5AJoC2Tj+RkVFresuTgHb80If3swvAtwS5fgm3ZUopL5yDyC3V4o8/7RE7Y2geXxkgZDazpZ/KkLNZGu7xPonPkYL8IVkU2LO+UwTdb52m4qK8MDKzM5D5Oa9ZiVGrq1meRHyb3bQL4pA15fOPkak9G5JTdYlCy5OrLW/
 /310LC5C
 66k+7o+mM5jY/3drGKjhfYIObrt5MuL/yS/iPzO6Bog3rwsT7gwJBnQ9hFZA4cd087juBLIPbMtQstu8YQysorcBnQstQFqnYMvOlGHMgmsZZLZ5k+eiGmirPha/14R6kCnrcM/dCkSjGbn/2Mb6D6zskHFa3SW/aQR1p2wUOa5JdUjJCh9vAOosYLxaoRHFVPL7RyZ0eTFcw/4Kc+GRtYbDS0EkDGG7iqgLBYArZOpGwDeUaADJs/+OdiJ7rPot0MMwBPc+m6dI+2OXqd4nGUQS3OWYG6l7s7M0AAXiQ+DNxvHnTReSQirVv6opvZ5gRoxZvZcVjIY/5nao+b5zfaXxqowcaMPrgOOj1KqVABkfbYbeVrRoYCFB/Efw9MXrcQrDAo7QnWLIwSOToKa8KhaGiadrb/i1XYGAcubrCbNQomB/9fMaOpJAltq9b8vfm150GPc+0/Vbj/0uBBbZWAUUoY3RA2ZyCOgdTnW3V8yoHsmLb9CM1O9MAX7oAeQXR3UHxXScgguFcgfDwjrXa4KMmX/YXVPrqmC/nKj3bTGcp3esYCrG8SFA6JJGG55zVh5/WOCM9HUHtmlrfmMdHgtmxd6zRwBjaCkrAHplEClS3wV7f1TUY+yakj+4X8HNjQBx1nlFB9O7RVP3YzpyZM6DJ+5UmoVOI3R+EAXdpLg7Aw5xRJJAyCxdAjAQ+HN+YpQGNL6oza/0HZoVzmOegEXimRcP9mN8D1c4+romYb3IUQXb9e8n488hleSYQjhGB1bedRZYflZB86CkPEJqXt3UxSnJKmvWSIGwrjMP/UYzR/sGuO15IpHlGBCuDHebNDj5R+lSgAB5drAEOairlMpmhECzLkWaNPqizQYH3S1F+OalTw9HYaNPsNpbI3BLAKpU41T6rGupIbtdIY/eVIgKn/8y9Z8OiguNZp/zer1D+C05SMgEnehCe7vWU9iVBFyW+2uCX3Yj/l3zS4o3Kow1KcDCe
 NqaNvw73
 RPs9r7+11eCCnGLlVPAtDJh5BsRfCpGqJhYuT5m9jY87lOAKxC1Tv4WJWzzYfZGww27CYHnsdx3DpnRozJGaCHzR0JYkJkMql3oF+7YbRfoIcy4Z+fOlEMP8VoVmeKub2Y1aat7NHKQtQpyZOO/4EaChAfTFXSNApSczRREVlD20noSMwAkhB+r2gn/pkfB/Y1eeTkqd+MuOtYqdwG0V1SDkWoNWX4FlskcUX78fhIPdwGV0F/XauL+NJvaNlEJY7z9WEYjizgfcv9FVu0fv+Kb9JJVannDbE/rPg+gtf3zKRZA4n1m9dHyY/L2S9nn2rrEjwm4NgWrcoBGkZVQqxuuwO9N873NFOhbwRheiymEfKH59rtZVS0/MkE5S0FUPN62ixWib9GTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in jffs2 for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jffs2/dir.c  |  4 ++--
 fs/jffs2/file.c |  4 ++--
 fs/jffs2/fs.c   | 18 +++++++++---------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 2b38ce1fd8e8d8d59e80f6ffb9ea2935f8cb27e4..c4088c3b4ac0362074cfa186c04f9c3afcccdff2 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -129,7 +129,7 @@ static int jffs2_readdir(struct file *file, struct dir_context *ctx)
 	struct jffs2_full_dirent *fd;
 	unsigned long curofs = 1;
 
-	jffs2_dbg(1, "jffs2_readdir() for dir_i #%lu\n", inode->i_ino);
+	jffs2_dbg(1, "jffs2_readdir() for dir_i #%llu\n", inode->i_ino);
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
@@ -211,7 +211,7 @@ static int jffs2_create(struct mnt_idmap *idmap, struct inode *dir_i,
 
 	jffs2_free_raw_inode(ri);
 
-	jffs2_dbg(1, "%s(): Created ino #%lu with mode %o, nlink %d(%d). nrpages %ld\n",
+	jffs2_dbg(1, "%s(): Created ino #%llu with mode %o, nlink %d(%d). nrpages %ld\n",
 		  __func__, inode->i_ino, inode->i_mode, inode->i_nlink,
 		  f->inocache->pino_nlink, inode->i_mapping->nrpages);
 
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 5e1ef4bc009b6e5b4818a7467639fc328c137c12..1e18d3a798409d23440a5890808bc25372549e93 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -88,7 +88,7 @@ static int jffs2_do_readpage_nolock(struct inode *inode, struct folio *folio)
 	unsigned char *kaddr;
 	int ret;
 
-	jffs2_dbg(2, "%s(): ino #%lu, page at offset 0x%lx\n",
+	jffs2_dbg(2, "%s(): ino #%llu, page at offset 0x%lx\n",
 		  __func__, inode->i_ino, folio->index << PAGE_SHIFT);
 
 	BUG_ON(!folio_test_locked(folio));
@@ -259,7 +259,7 @@ static int jffs2_write_end(const struct kiocb *iocb,
 	uint32_t writtenlen = 0;
 	void *buf;
 
-	jffs2_dbg(1, "%s(): ino #%lu, page at 0x%llx, range %d-%d, flags %lx\n",
+	jffs2_dbg(1, "%s(): ino #%llu, page at 0x%llx, range %d-%d, flags %lx\n",
 		  __func__, inode->i_ino, folio_pos(folio),
 		  start, end, folio->flags.f);
 
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index c3ce2c868f7a33476d5cde4f1af7c7ed9c6c6c41..d3561a9c3d2a836e2c1f9de87816b80d0a1cf2e0 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -43,7 +43,7 @@ int jffs2_do_setattr (struct inode *inode, struct iattr *iattr)
 	int ret;
 	int alloc_type = ALLOC_NORMAL;
 
-	jffs2_dbg(1, "%s(): ino #%lu\n", __func__, inode->i_ino);
+	jffs2_dbg(1, "%s(): ino #%llu\n", __func__, inode->i_ino);
 
 	/* Special cases - we don't want more than one data node
 	   for these types on the medium at any time. So setattr
@@ -243,7 +243,7 @@ void jffs2_evict_inode (struct inode *inode)
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 
-	jffs2_dbg(1, "%s(): ino #%lu mode %o\n",
+	jffs2_dbg(1, "%s(): ino #%llu mode %o\n",
 		  __func__, inode->i_ino, inode->i_mode);
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
@@ -334,8 +334,8 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 		ret = jffs2_read_dnode(c, f, f->metadata, (char *)&jdev, 0, f->metadata->size);
 		if (ret < 0) {
 			/* Eep */
-			pr_notice("Read device numbers for inode %lu failed\n",
-				  (unsigned long)inode->i_ino);
+			pr_notice("Read device numbers for inode %llu failed\n",
+				  (unsigned long long)inode->i_ino);
 			goto error;
 		}
 		if (f->metadata->size == sizeof(jdev.old_id))
@@ -351,8 +351,8 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 		break;
 
 	default:
-		pr_warn("%s(): Bogus i_mode %o for ino %lu\n",
-			__func__, inode->i_mode, (unsigned long)inode->i_ino);
+		pr_warn("%s(): Bogus i_mode %o for ino %llu\n",
+			__func__, inode->i_mode, (unsigned long long)inode->i_ino);
 	}
 
 	mutex_unlock(&f->sem);
@@ -374,12 +374,12 @@ void jffs2_dirty_inode(struct inode *inode, int flags)
 	struct iattr iattr;
 
 	if (!(inode_state_read_once(inode) & I_DIRTY_DATASYNC)) {
-		jffs2_dbg(2, "%s(): not calling setattr() for ino #%lu\n",
+		jffs2_dbg(2, "%s(): not calling setattr() for ino #%llu\n",
 			  __func__, inode->i_ino);
 		return;
 	}
 
-	jffs2_dbg(1, "%s(): calling setattr() for ino #%lu\n",
+	jffs2_dbg(1, "%s(): calling setattr() for ino #%llu\n",
 		  __func__, inode->i_ino);
 
 	iattr.ia_valid = ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_MTIME|ATTR_CTIME;
@@ -428,7 +428,7 @@ struct inode *jffs2_new_inode (struct inode *dir_i, umode_t mode, struct jffs2_r
 	struct jffs2_inode_info *f;
 	int ret;
 
-	jffs2_dbg(1, "%s(): dir_i %ld, mode 0x%x\n",
+	jffs2_dbg(1, "%s(): dir_i %lld, mode 0x%x\n",
 		  __func__, dir_i->i_ino, mode);
 
 	c = JFFS2_SB_INFO(sb);

-- 
2.53.0


