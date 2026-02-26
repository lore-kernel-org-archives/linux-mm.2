Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD27BFD8FCA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1656B00F6; Thu, 26 Feb 2026 11:00:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74536B00F8; Thu, 26 Feb 2026 11:00:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE19A6B00F7; Thu, 26 Feb 2026 11:00:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A71CC6B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:00:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6ACAB1A0300
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:00:06 +0000 (UTC)
X-FDA: 84487069212.20.D507C7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B017A20016
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:00:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YDzbCEdI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121604; a=rsa-sha256;
	cv=none;
	b=K/jCeHQtE0NWstzg+4uv9lXcxYfoNcDdlGEnYOlysKYNNzfQquCQJdlAmAFeiBYI8kbLDT
	YrVWn764xB1Qpxw57mgC5AfNNsW9YaOsWNrNeTii0KlIsRB/+O9LnUPXmJRiDYvrsMeKjS
	g2a3Nt6iDs+ikL8HmpUBrQ/aoyo8rdg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YDzbCEdI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IczmRwrKS+CY/wjEQekbRlkWggHZLXWzsQZr3rhlCro=;
	b=3fPYTKV86SHGHOaeMmuR6XFfmGPOiBLB/SaERbQJnZ5aqzxlcaGDFvRZSSe9RIRylWTFop
	T5Jw7PMyQuRqTQKhdyyS5+S89QPSVu53BpsM4Z10T3yh74/TKyGBcb6uxE4caC5dZ3JV0i
	vgrWCvCl2022cq9sEZWWnZ52w9YrkMs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00DEB6132D;
	Thu, 26 Feb 2026 16:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10356C2BCB3;
	Thu, 26 Feb 2026 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121603;
	bh=kIVFsmXtBE3YuzRB+strxcrcOEXNDR/4sXDdnMV6RAw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YDzbCEdIFAS3XGTFYeKhbBvMOHdk2GCv65NO1aAYs5h3azw9VRNLRJ9Fbn00BONBd
	 XZ7Q5YtaGOLoNjN44S8s2loYRg9chGJoSdQqOQUCUSyyrTuMXpdER+QNm8x2gyF7L8
	 ri1g5oeJ1OfZ/tOcgVd456us4+YacMZX/hr46U25NZBBgnaKDgHrOprTihC/bgFhA1
	 RiYO1VO8vRpTLjdTKTu+uePcGEN6072PH5y/cukbIpk3bxRe2aKXlakKytXJdfNbg8
	 CPNEVITwSY9we00NyTjK9lJzoNG5SDqRTyk7TCSii+0E3vkMGJPHWkJzKpDUpL4qH8
	 o5DeOf1pEvh1Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:20 -0500
Subject: [PATCH 18/61] 9p: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-18-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3755; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=kIVFsmXtBE3YuzRB+strxcrcOEXNDR/4sXDdnMV6RAw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0If6psvaFLhG5GB3QWW9P7h7vG/pnb7lxXs
 CZ+gDM6mG2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtCAAKCRAADmhBGVaC
 FdKIEADP6XMRuAe/OrAUfesmSxFdHao88/Flin1MLL7xtSytZJHGQ4CZFPmxHE0vn4cXVNtsXur
 4lOmKOvGEvRgPNsggDD5qBh1Arb0M9DX0QxIvm/EH79Z0ptVoVu8m7SpOj6e6IQ3y6SFjZBjicK
 dO+LW3XgSPLXjy9hxv+oS432GzeyPdrOlNQF4wKgxYtRUc0dPnzDFSC1CqjNRxP+T7l5aySDOoe
 S8oLG4YoEk63+3sJj5kjGMBIFveg23IW0jalUkrEIl0D1ZSUvoSKpsoHYU1Y4XuIHGW63gfJskj
 /jwpRMnzoio+x5aNIiRplu8qY5Jo/nAnwCKdqddKWLeo3pys8P4TKPmEQ7gL2MsuAQ8feiD3hht
 hOkyH1vUB4bT6NZe7njX6tr7A6vvrgITD2WiVwput54LNflG7A3WKXLtV/UTR3QEdRAxxeJUfvt
 ooybLC4A0ZpJDd0YYSP4zGcUmWDvmBSUmBEbP8sD2mQNLoJMuM9h8OySjaQ9NZtx2iCuCS4Rxoj
 RciUZM5QkBcyuBTeD4YDGohYKBN4wgy9Gg3GdJ8fDeRjJytnZnFAx/dyUY7PTGqG+UwgfU94Fwl
 h3fv5Myhfxhuy1PDazOm/qHMj9NpBQAZiaLTm5d1PxJL0ih+NNN95P4uEvVH+76atxLGWmN8zO6
 u/SWlnT7tELjwcA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B017A20016
X-Stat-Signature: 1o5tnuchqbg1nqc5ppbrmm9np1y1gmy7
X-HE-Tag: 1772121604-264511
X-HE-Meta: U2FsdGVkX19jSuQ3RCf9kESPiGi9vP8iwxbSqHZXxMrr3AwAmcMpZ7i0Fku+FZUjmbd0jpW3LRad+eAn04yTCIlkTzzPptsYTJu2VulXg29N82RU5EPDNWL3qmOdDtAxwRm+GYZoj867Aw/YquhOL+I48lLELNW8U5YtUio52W87GFHU+hUQeFjvBaIJKkOPLbuyqlsaCVgMXUBowuEtyVrpuaruxFN6dE/XxPm2k1wxA49n5g4IWdzIcUHcESITsDdzid+3iZHZqiWhrfwUb9D6kFon7KJPsYIgQ4kpclmr7iSfuz8c2MJ7AyB+M6RygWXfFbr/0nFXme2ERRvsbWizSKcl599UXw0VS8u64iCzT3fZMCsMzwedThS6P//v5qoPYY9m9nNnot6sAU+ZUkrHUptngS8HJ6C8XFGvyILLcdR5yUt7t3qkxI2hclQFV1eMUdtfHGeQU0wDcGgkN0orYkBmpXZmA4NXpquQdyDL1z1voaB8xchvmXwJi5/04mibM0VZq7xPtpU3ozEYhTomChxvQ3zMnBI4rUoEN13Ty75D/WzFBQ6xipDjBnbp4hzqWKR69QSPjZhhAMnn5G2ZjrOj/zmS2cjz54bp8NqX+0vEwsTfqu5bsPr65I+LqG0USa9Lrg9RongEnLpO0oNLcc7L+KHPdpOzNiNuIoXYsJTCe/BoTaX3a2FS3317C8mmTlVlaSXu8s1dgu3XQDkhQUvpkHE60ueLvauPUFMQaABsuZ3BZGZWQlmgVZ7leTy+v2qaVoylgTpfV8GhC80dkHbHMgNhuvEvwP91JD1mRtGvNqzOZZm0ARF2a8G5LZ8t7sjKQHnHQLD45ItAiLh/IoT5mObtfVUYfbgk9zk7U1jIj99G9DL2RwiJU6j7Rb+yhifEDBEPbOx2xjUPUORRS9PmBakIsycz8PDjnUR0fM9FijEr+kPbrFPD5P+fM/MzGrcUhSNk0rsvoMN
 q/vv2e+w
 0ukdeOFXVKtB7WuLdt5qVFQB9qH0xG+WRkWHGliik6aWwkZYuO8Sq2J8WE1sKRGvf0WFFn3q+INq7r/JX5QbldbqwlUrQrI8sgkY27bZoRB2wAWb/w1rhhvz7IriBjVryrvr6ZtzJdfuTaOWTsu+Irm/Wy4bM7sQ6ehOjg/pPKsEqnsjmCkmddkZIL2eUNL7cAENTO8UNqboV9Yn5rc1kb1E+x/doD9hE4kCIwIbhMAk5E2P+7v5RbHW49pPxDnvJFwbj+SOCAuXgAxx9a0xjoKmw2GCGd8ZnCr++wfdMaCYllTmEigzifwJ6HY2MkoelWH2SGf+R4XcAwYbfsTNiiBLerJSl1mVskDuPiB4/aOkBTNfx/OHUxoF8fRs4S7CyAm40c9d05VllZi/1o45Bbi0Frc91eLggsypt22Hn3VN9As4LIF/JWDwqHI4s9gNBdfzYCoRhaKM7jjgHf9z9XoN/xHMi/ydLp96Oy9TTg9jzGzUklPBBWWUiLmZPNvY6ZN67pLAL37tdShC8UogrrXnxdXW7F1knqTrrdzZ+Mmp0iT9JbcwtmPsBSE+6NTpdtA1J999S79uU743VhFj6mNcktoquDW3cGm44KYZQcaKGoXgFdUFphD3ZZJ6KZUwhC5uCZ2P2dLno/gNWoqn/uDR1ZzHyelEDwvTAqPaBn35uvVyxpLvA1C0kfeBmW4ZCgcbd6fY+eD5SsOUp0+oL21tYkF/Vc3R2EyxjYhmQmTzrTxcdamaSlKL72Vi6dXZHP0aL1W8QCJhheAIBuOuW0Wcy9wZ5rv0/gUpzcDNjfCjewanZFpkDPwRR4yl4gddz3rKglNhFNdGU5eeVx/YI6BrttQMG6rtED7PFSto7s9QgNvFc2PFiADs3CMIdjzdJCnT3UjvqQwBB2KEWK8nsNWBngCnVdlP5BLInwiX+xgnE60r/YFndbOfWMuVlfQbX3sM4CsoBansibOu9000gq16F0NoX
 mRo4YsAF
 103GWnBk5PFuosbt2FedhB7elCAoFw4m1WblfFo7Mwtiva/zy/cpzks4VIa5rO8hTa1IOtx+EVgE9j8W/Dsi1JosXRlVnfNyj9aaDw5+itRodeELurIDiETDgyWKcsDIGy+0xYMTj72RBbFJ9Pn3JXTcaXkTThSb5cCh4r/PFLIs5vwKOngKPjUHdgPyuHtOb11PdYfjcwdtCAqo2ebf6sZ5RbptLVERKl9tzuHgpmfpC8ntA/Kobs0yB0HRDpwzh6cjT70G3AKyAOsM5B5E886MTrUPti0K+WL4RWBNK7EELg/QwNbcjBMKUe6BSVcyPFWmwGqrTDnchmE0Y07tzR9FMiMctEn/UZwFPvWEN2HhmVVKJOt+IDQ+yBS2cut5Y+dkwT3O8fGMuzThERodiIXQBjxo5RCzewbjvVC/DIJSf0fgxkKd6Uu2WipD/PLz/0WFlJUgqvxbW3bTR5NhKpzNOdrasevI8tHwTnUbOsKPfA8FQjcsz27dckxlU5q4E9L3bQZaX+V3Zx5UG6XHP9DwlwoUoy1ab7iRZM8twGlcTOCAS+NmWA6bK29epJkcvANQK1ytBoqbeDWNUDWW///J2qasaa0PQXNWoq4bNxl/ROGPfjLqocq5xxlY++zSQkIFXzwrdqa24JInWDo3GxCWrc+t8YKlVg5Xgc8bauUiMgmG0GX4AG1q/OiPnL+s6Ep+Kphxz+SiXO/176Gr//rPKUrizx2EcbaykC+LX5iDxzF3nowqhMevC1AcODGkSAzWOQu0M1bNgXDZXfafyFY5Qjd/wnJCcmbvDRhtbLH4oZ125q1qaXCD2t150vtqBzHXNxCZ6ATR/Z2XLw2+2bn/Ppu/3/prA21I5lBb/12KwxJpoGXNoUrbOPLyVJmSfqrUbPac+aFqbJELvnB6wk+APHe3JrpS8rufVtlvWSEHnOTSCHeuaPHDbpc5+JxjnAQKLJbK9T3PihfsXrgJ0ftCXXy2i
 FMjTFYZB
 24n53hnrAMHaOtfT6q559jL+ZUg2pvmGI/HmCeONAIINRDIYdxbRa6AEJy/jOeWX0JqoN6xyFsEli/7bQ2sxVPyRfj8tsJjJWaHnlcvr/aiOy/G+UqpK8CxvPZjQQjor66PpZSTuPOv4RQK5TjiY9i9n9e8xftxTlHgizNwOHbJ6iGE0XjFksHp8N9C1PunlMR4KeuuGh0NY+4ergMhxdrjkouedbfLch4vTlav421ZQ55yh6qHSowgI4FVB4aBZHwAAwrkX1aahQyYepMzg3g93l+bDpsLoWq6k6PfniQajTzhnL1rVkQepg1vvzJnDrOmG0e80SPgkD96ZTV/l27KGIQKYZRsbbfjr8362g3JwItlHPCZg3AqIYlzvNwmlToz2s1/Qhf6r31aITAVg+gI320whh5JIS0PjldNmfwLrYcKItxCOI7/c7b1zqldOIPFsc7WnKASLfk8hqXj45DCuniTOw+R+XHmK1Sk6b0TluFcnlHcvL2DQzSH+W8Mng0AXAvkdr24u138TtDVFs48Ga1sJBn3YesIq+YtSZt7TYvl0EJRzmX2YeNJtOMmWwnm/3DPws/n/I7Tls8kgv3PW4kZYlW0O4kh0D1FFlC16IsSD6U1xiGW8iPMHy2x32C0iWhdRuS1EbQZmBb1prFPRr2L0mrVu3Nlx+PkFBq6Mhp3aInUNdmXU3z57vug4XA2G6fbGIJCxIXpQ42oWpCC05TGsdxk3K6gpQjE4k8p/+ZDmeixp1MA111nZT8HqxQfMuhCzzG+VziZHpBW754+kEMtLiqr+qTQeY+NW0cPnEoRI2I2R0jhNO80wb0Cv5V0LTg82UJwBuyV99kef+2VzUMZx77wnW1tznF9i8mFaU+4ee2QLI5xn5BxMf0B1MTQ7Gu3nv+JcAWwgcYZc1F2mVd3KaEXkRWUQM0I2yEKkV+FlYH1RUIJAmD8NBruzzY1DRDp9l0SRxDj+FJ3G9Nsv3G53d
 CnpI2QWS
 A5TJN7kJikiN1bDEbgQCVDJOWqLIlbmTlDwfUCGeSZZuw1sE7ml+l3XAjM6U/pTRW0o6364mCEOs1pL5hdUsMdJ8ZivK2lZv/Sftf83ae2rWcdPLD20GQB5dE1loyyf8pku5XO2OUjzwgYPxBm6rp6oEhvbLkAz17iKnlekjxKH2VYeFDj2oEp7UYOhKjik3FUmiHnI7H8jY/a8JOTLuleUM3eF/c4KU5g6F24TGGzM4E6rD4KSgE3xkh4M/cgNNQ9Y4hKzK3nHhH0GNusiHcgGwKf8N7yvpaf/imT3sNZIQLV+Yu6GPLzqSjtvfF2Utqzneb1TXUyoBch7aHWlePs8Xo26EgBDjEDv9iVK+o6EJpgW7gl4Qq02YHglokGQFJss852wjTArA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in 9p for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/9p/vfs_addr.c       | 4 ++--
 fs/9p/vfs_inode.c      | 6 +++---
 fs/9p/vfs_inode_dotl.c | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 862164181baca1e88ecf8859c55868bb01525ce1..c21d33830f5f021904f490ab6185db5fd40f736d 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -36,7 +36,7 @@ static void v9fs_begin_writeback(struct netfs_io_request *wreq)
 
 	fid = v9fs_fid_find_inode(wreq->inode, true, INVALID_UID, true);
 	if (!fid) {
-		WARN_ONCE(1, "folio expected an open fid inode->i_ino=%lx\n",
+		WARN_ONCE(1, "folio expected an open fid inode->i_ino=%llx\n",
 			  wreq->inode->i_ino);
 		return;
 	}
@@ -133,7 +133,7 @@ static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
 	return 0;
 
 no_fid:
-	WARN_ONCE(1, "folio expected an open fid inode->i_ino=%lx\n",
+	WARN_ONCE(1, "folio expected an open fid inode->i_ino=%llx\n",
 		  rreq->inode->i_ino);
 	return -EINVAL;
 }
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 97abe65bf7c1f00e94e431fc69dc5ce647d1742b..d1508b1fe10929d8d847af313f7661d693167d96 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1245,7 +1245,7 @@ static int
 v9fs_vfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		 struct dentry *dentry, const char *symname)
 {
-	p9_debug(P9_DEBUG_VFS, " %lu,%pd,%s\n",
+	p9_debug(P9_DEBUG_VFS, " %llu,%pd,%s\n",
 		 dir->i_ino, dentry, symname);
 
 	return v9fs_vfs_mkspecial(dir, dentry, P9_DMSYMLINK, symname);
@@ -1269,7 +1269,7 @@ v9fs_vfs_link(struct dentry *old_dentry, struct inode *dir,
 	char name[1 + U32_MAX_DIGITS + 2]; /* sign + number + \n + \0 */
 	struct p9_fid *oldfid;
 
-	p9_debug(P9_DEBUG_VFS, " %lu,%pd,%pd\n",
+	p9_debug(P9_DEBUG_VFS, " %llu,%pd,%pd\n",
 		 dir->i_ino, dentry, old_dentry);
 
 	oldfid = v9fs_fid_clone(old_dentry);
@@ -1305,7 +1305,7 @@ v9fs_vfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	char name[2 + U32_MAX_DIGITS + 1 + U32_MAX_DIGITS + 1];
 	u32 perm;
 
-	p9_debug(P9_DEBUG_VFS, " %lu,%pd mode: %x MAJOR: %u MINOR: %u\n",
+	p9_debug(P9_DEBUG_VFS, " %llu,%pd mode: %x MAJOR: %u MINOR: %u\n",
 		 dir->i_ino, dentry, mode,
 		 MAJOR(rdev), MINOR(rdev));
 
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 643e759eacb2a46855c7db6187fe6b29b7534c9a..71796a89bcf4745363b59af1047ecfd7e3f4d956 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -691,7 +691,7 @@ v9fs_vfs_symlink_dotl(struct mnt_idmap *idmap, struct inode *dir,
 	struct p9_fid *fid = NULL;
 
 	name = dentry->d_name.name;
-	p9_debug(P9_DEBUG_VFS, "%lu,%s,%s\n", dir->i_ino, name, symname);
+	p9_debug(P9_DEBUG_VFS, "%llu,%s,%s\n", dir->i_ino, name, symname);
 
 	dfid = v9fs_parent_fid(dentry);
 	if (IS_ERR(dfid)) {
@@ -734,7 +734,7 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 	struct p9_fid *dfid, *oldfid;
 	struct v9fs_session_info *v9ses;
 
-	p9_debug(P9_DEBUG_VFS, "dir ino: %lu, old_name: %pd, new_name: %pd\n",
+	p9_debug(P9_DEBUG_VFS, "dir ino: %llu, old_name: %pd, new_name: %pd\n",
 		 dir->i_ino, old_dentry, dentry);
 
 	v9ses = v9fs_inode2v9ses(dir);
@@ -798,7 +798,7 @@ v9fs_vfs_mknod_dotl(struct mnt_idmap *idmap, struct inode *dir,
 	struct p9_qid qid;
 	struct posix_acl *dacl = NULL, *pacl = NULL;
 
-	p9_debug(P9_DEBUG_VFS, " %lu,%pd mode: %x MAJOR: %u MINOR: %u\n",
+	p9_debug(P9_DEBUG_VFS, " %llu,%pd mode: %x MAJOR: %u MINOR: %u\n",
 		 dir->i_ino, dentry, omode,
 		 MAJOR(rdev), MINOR(rdev));
 

-- 
2.53.0


