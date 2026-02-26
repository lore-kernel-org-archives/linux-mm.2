Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21BAFFD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823456B00DC; Thu, 26 Feb 2026 10:57:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0156B00DD; Thu, 26 Feb 2026 10:57:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697946B00DE; Thu, 26 Feb 2026 10:57:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5493A6B00DC
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:57:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 17DBB137BE4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:57:23 +0000 (UTC)
X-FDA: 84487062366.12.B8FEEC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 319ACC000C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:57:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pBlTECaW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121441; a=rsa-sha256;
	cv=none;
	b=R1AvyYcUz2BJrVmaJeP1JVnRC7q3DSrNwPveGPefF40aq24uQrcyKmCxbMADv9mAk86XCa
	6RFOuh3kGd4p0fNgMlY7HxXc84tBcok9lBI5hpzmh2PvB4lqPN4MPWRxaN6wqIq8CF4Vwp
	5zanPY6bBNIMj7y47WwbtwFn3Bi70Mg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pBlTECaW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqtW99t3OD8UejYyxhddM9aW/17FdtFITT7wfOS/knw=;
	b=5g1aXMshnQAEvdf/sZWqpUofmiEPQBIGPq9IlHfE5EjhA3k9h2PP9zRspLZtMKypocCpCW
	+pU2nDEdCIwznSI0ym0/9t5w+GiDw4yfAQQGj5Fnw3LM9sEE/gcJISwh/62zJLLFkDVhbz
	ESLxpdPASntG+C2HEIzA8lnm0WuT9Ns=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 47B8440692;
	Thu, 26 Feb 2026 15:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC98C2BCAF;
	Thu, 26 Feb 2026 15:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121440;
	bh=onxb3Cyqd/rilCm65K+p7iNnpXJ1vFPpFmw2Azg3uIU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pBlTECaWBg2Lnsgi4c3FnOQxb+NhDxloLDFll2ORgPJtvoW3bSi/c1w6MjoZ/MWDx
	 6yQb2NAWqPtdoP//iXZhudf5uwqmvA6zTsZysd0RclMa4KA8A2E7yubYRXWaEkwGLH
	 KcP47iPodNczlsp4pkoEOsmIrodBF2R1908h827GvxVRN7M8RkVTmdnlWAeJwIB6ml
	 OH06GMgsn7Xhsq0Tjlr96Ik/X9487Ydj4Kr0llQ9seraIF9scWjV1cyKKw4WVdPZdG
	 ihwjXNIfAI7Cf+zdOWxcOt5RxWayraIECcLCLMf8qh18HpDPCd7C+y4E1yDFufLkyu
	 /Zr3aN0J0Tb6w==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:07 -0500
Subject: [PATCH 05/61] jbd2: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-5-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1864; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=onxb3Cyqd/rilCm65K+p7iNnpXJ1vFPpFmw2Azg3uIU=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0F8qRmALygPLLmUZVfpzbSTaHn975/yAwHB
 dI9f09ry0yJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtBQAKCRAADmhBGVaC
 FTGYD/0elblMywWvVOn9kJc2PjMQ+s7lv+2eg/EeUnkEeM1NRAlfHASrkNovCSp2JS8bN3Wio3K
 oTEF74kP2mzLPNtCAEkpGyBdTQwFDZiHsG8G8OISwxOERd5YsPrAEw1nBrLrphhpt0Lo9hKbAUQ
 tRWzAlooO5fdcC7gywLb4awZYzRFdVq8IbvBWvMdsEhjiZld9T1wx879gxJZcGPXcMs5Ch//E7m
 6uOTayYJ3+mWjLk5L+lyCAUwjR/SGxD1EkfAo4PHRP7XksV+tlwJAnVncKDwnZ9TEN0HNHkwAPx
 GgRwnMuzw24gx3kVRm7R2qkdlgGrg9C2qt/Ks/anblg+tOrlNgx1mpyVAkzWISmZBqs/K00IWq8
 NMpy+k2NHj3u7RrSq0JfaUJkxTyEfiob89EoUIKc/lHeasUhFMbSwNSWh1phJ5+MDw0p/KIFa81
 GcsYIoBEQqgbTPjwRrIQ2Hm43oQIkg84N2pK713+zgfsJ6BIcmI5O1N1WQLc4tnTFnFa1kLDCue
 yPOrVs3TZT9rPDeu1qfi//a9XSO06xqU33tMKAunO+K2Y8XD2TB3CalnBIFVoP953fD/RNjNQNx
 K/uXIIYVUwmz0TkKYPYnL8E3R/S54eAgjbhLs1iHrx7lxAwI9/BMsp/p8OcwqXKO46Ka2D93Nr5
 u/i7SAc1jppid9A==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 319ACC000C
X-Stat-Signature: udg5www6op19g5io6m5w1qa1q5cymgz5
X-HE-Tag: 1772121440-284383
X-HE-Meta: U2FsdGVkX1/0fbQgNtdhEUJ1BzLj7TwLAjnnSTthzq8DshwPysSlQ0Mud2TCw+wIDNFRm2VtkiVdzR1zQ7v7HcNgx4XrEo1rsAUZAhaLc1V+8cvelxxfatx4HGsIfgs6bW5nyO6b7ZrKLdIt2wz7JODN8T/T8heQzY1G/AndyUU5UEYYkn8a/5RPQC23p+696Tz6wsMWsp+Khjgd72+VvECyg+2eAJBCecuU6ebU4I+UkQx9RrQWVQCJ7c0eJSLgwRc5irqAox2I2JbURKw70gU9/9JsPE59oS7oxv1VltBHl9acmeJkAmESral2WRthwjFdPR0BGFbzufWwaVF6qCKgqbZwCeXN+M1tCjkybktMYklGfums1PTuTMwj/qx+jv+WpQJnNmBGqzPak5byS9DwVo7hYg/kZkzYp78noHmJuu2HWcZbS5VdpCVrs+LevQV4PVoZBqNhesvAWG8HW57dYaHBDCnWFTrRkpYKHifOPrb+ZjzPsmjV+9SHVvXQdQjl6yk8EK/cz4vaZ71oNdn8YRkRpUy/4cQjaUmpfjoCxZHTSPKMbrr/2NlVlSWC2zZYbSN29kQYwj1LdkOU5bPzaEo6eRSN2z4cl9g3DWnUY08rJeldZmn11f+BtJgjoNmQWVKFc4ty2hSH9Ra8V/iK6cNjU/2RsPi6KcGixA6Zq3mx+qhUZszwL/Sfrv3GXsBkwDj4ldUAtTCMs9+6bpGg/ALA4TDkb0GaWbMDEef7QqS1Dz/FbiuD28cicBrCzXUDvWxC9AXhIgJMeN+Pk/kzdgLLO/AuCIS+7aJKsTkOdPnMWZqsDxGqJ6N49ID73ir/DPUD5YQpHwhsyLxw5sRH4RrB6wFchUW1M/ymfK9r/3OROTr/bDrxr9cz5wD5FAiFE6d/rQx3kDyZ1tTqGqTLl3bJA8+XjziiYMNB1QxSh6Uf1DLEXz0BGDJ3+IvNFubzQFkVKpB9Eb9FNYH
 zygyUXSZ
 Ilb9zE07MSGULjijHRZgpnVB7lDJGSdAFa1spLS+oO0qjk2/3LWBmiF6uCmzmKlidhWjJLUWPctu0XfWh8CyVjkbLPKkM8WIw/uv5O5jWL8Be9wG3gbxRLfTHVQBGIxODbOIh7GDRtMePxzxWcw3SGpmTNYMNgT9qCe3STkuva9XmUYGFMk8fBERWL49FxuhDO+rKbEFs0+tEhZnqYLFarW0P/8wa76CUSQQAxTq9/OCy7LKToENvB2+Bncom2YFsTRQTvMTby4JvfVH9SG4dpSNLI643PKz5v6x7Gh0t6t0mQYxgrHiNK1HVEq3ObyYXM+bCf8R6lxFoTLMtGuSAL+lEyWLgj2x+nz5YnLWcquT7VdZlCjrA6G6Rdj1xZBCt5DfqsOp82sYe+RvqtPIsHhXRwi7qqvjoaAMnLVwv55LqjFBspvFu54a7KyrcSY4VivjBNNB3ZvmB8cL/Pq2DdcwTyqgSRNoEfYB2xyB59hVEj3859vdmkLoR9tCHNMVzjqMQiRz6MPAwctKtE4+tc+cSf0tO5D1gCdT/oszgwLJGbT2QSHEkbPHeCfigpbfWmexdkhf5IP1Ge0004YPLevYgoc0mc+kT9O5+P4/eNx/yosEIFxIYFwL+ftU8rTXNbOItTiFwuVTloJeRwjzpUwHSS0BMhfsSOQfcY9SygdciTAg6464NTIO/fnxkcn1MMYq3d7aB4W5A8wrLXC79Jz9G0IlgaxHbTw0S42K+rEve88co0ZGxO5sjeZZzu8m6eriNVvuL2L5ncJA55Y1+Zj7+kTIm0xMj1PNV7yhNekgvm09k8l5sP/lB8b3CaDAy3anP7jB2lFKak1b7msWXnUySSoO3kfZzRoBwmixnZ0oDgW7Ey+66+BSWoqujzDIGvBPXQACK7abYdYFGvuhfZZ3+fcqtSaDhIpSVF+Qu1fw3oSq2SrfkfHUjqOyUpdyWX02FE3tI/ZEwywv35vKbEpX2gLn4
 pyu1o8rX
 ozqaPhuvZexIYL+xrZDfOJgzDYmAO7dYmlwaHUJeAN4veRgHukCKheehxDBiDFjDY2Ls4oRA9gsVb0Dg3SwW5QfsPvqhNC0KbwGIoz7S6Gkxj81ghq9ZxoSxzK2i9WKU+lEPNQxcucMraOhbtVNmGAq2/nsXJYNb4NSw6WMpRhfkHdDpcCXUXOnCsLJ7cn9jxsXDZZM0WEnyhVHWy/hRPncCCYdQ8t58X1erBwbaapR3miL7Pq8RRVAFiUfdEsJQInfs/Ul0SX0PNfMU/KCcZ6xtjNUXXbI3gute3mjrzNlO5ENrCYO8jmWxozsQHxwkjzRPnj5uDZCyYhd2mzNGhL2jtEudAbg4/5wlvvybZEBm3oYaWu+HJOCIf3BuRJCOmVnwsO6VBre2hEMaVNt5+DcYKmO9ulXZY7QuMSXm4Raim/V+ZaXzsOsIHWOf3tIVWDmychMQXRmmAYi77UwHGvLYRUwqwvQq/La4SOaIJuViicuK42G1cEIo6h85g/5ZAgaLR2dcdop6mtacbkRLAt5NTsHwEJ5dvuCbdR/UUnQkBF+kzVqm4/zIAmw3U6mjGZ243YDYddKGmNymG4WFz+K0ljOBG/T9Ptw/vWachQgrOw0LoUAKN/RYIYptstk19xYPtjXEbcYahwT8m+85UYKAxnYL9/ozKiSe9mHmeTTG4LR9EhGxTXLiEgFkFyIDU0vig6cWvBfYCa2rrI4F6yZN73heNSi1HvCcbVr095sPR6AhfcCN5OwmNpAn/4zC1PhoXYovTVwU8QO5NoSWfjGWTt8CXS8X5QZyDCLNHlAZohomfajZL/a6jbolKUI2jqb3Nmt3iKpxN36/UryF1BuZpHUpAg0FOne9pO/+CH+k6jHmwBzDiLeUwSXBfOQr6+zw13psG819YCdiosQ4TLojNs9X44N92vQq6PC2v1DwrPrfPYxbVxDHmb9cdtVe5N1cRmjaETSoLMOhsHYvNvH+HGm8P
 ce4EAzNx
 gaI8DCk6rj5R8EbfB29yTRTNiCT7qDBL5Apm5w3FgTEo7BTWkMEMKuLPjgBJ43vIoplfF5VvOODhR2+HAe0a4+8ePjhDxIMwR71priVABurM3fYHUucBLfDawAfL8VeaQAmR//5YLTOsuK09JjKDtA5llxMlUjLD9MpS7+iQyZh7pCKMR4yaSgcPB8RzbJubNLE3fgfl9xBkRiNy62Ru7cggV4ypXCVBClEJxKpFdKSQ+LkcWV+BRYqWxphFoBThMq/gbWjtSM0Jb67tigG96ZdUmRAfnyESGLX8vbMWKre7VCCesiK7Drs+gRzYv0cahKBX4qP9elrKum5+CTkIWF8k2YiCmEp84Is4ixjdgppJTg/gQXnKB3tfAVBdbTaDiN9TkrfIj3uYmKSahJuZI2b8oM3WxAZsdSGISZBFayCxWLIv9bNL/Q54O2yXKhacZSymk6OoWHufBDoeoo876OVP771LghciW/ez8/XmC8wJxvqXbEYRyKIWZeViRGwLbTCH+3A3RKFHStAMCd9a/2JEsOi/mrCVCig9HtU4saBmveLdYuOocLTIAU6h8LDonKmANdVlnHyjIJntRcaP/+alC5AwWw+C5pkbUTq4dvbBSRlXIGJKPWQ1Lf3SCRz3ru4QHWwANkIbbjBS96rw+9miEmD6apoqlx84uF/8CbcPeqrX4REvlTUAxvmSCSy5f9eed0Bq7QDtlWrCJE2VkJHuxMJjSTf5OyR4J55zFbZg7pyi8ly+A8x249m0gPR4OKfayGkIHMbplct+x/kypOJ2mNkxp+icSp/a3uTTo6r8hZ+c0fy1Fx5TDeR/EJ3rP4tRvBeejBmY3PvpAVZEe1ml7U9VB83kUMmRSalMnNmME62SKM2ykbzcnW1jx7fGMdwADKHSnK0wC/So7iudtv5L3/ak3IpAQM4O3UAJWL3cQawXthe9OjSOjW90J6XojiGi5MYqUSICfchCCoa91X0GrIKRN
 n7eiH24Z
 kw0jvZOOdtBkHi6P2zbJyUqRZDmy+Yk8RvLBQ2oQGK4y+5J1YyDcdmirjTDYaLlSKsC/Lw7VRjijZXmJyuGJ53npPtiJRIrzi6ZpiVcltegv4zVVSK09oKnvYfqqKqKlH6p9hbUMU5w1CXCfW4cZhfOTsLZp/Vdd0mJeloMPqlrETbBlNrwoBmd/DIA/ZNfWJLJCk/bHZXqLTKwXl/86PJ9ILNp//3wgC446Kbh4cdmeyUt7xEQC6yodrFOc3vMVOfsiVF5WyXrAXrsUns6uFvYLC+do/ZSj3r0IcKlqPwT65/ZS/AEC3gkswSZMtpOWwRMA39UdoV2xXJXjfV+jmI/UynCAxJ3co=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update %lu to %llu in jbd2 debug/warning messages that print i_ino,
since i_ino is now u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jbd2/journal.c     | 4 ++--
 fs/jbd2/transaction.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index cb2c529a8f1bea33df6d4135e5782b9a77792732..dcb38453fcda1ea666db5c692dc48f90a40e0d7d 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1677,7 +1677,7 @@ journal_t *jbd2_journal_init_inode(struct inode *inode)
 		return err ? ERR_PTR(err) : ERR_PTR(-EINVAL);
 	}
 
-	jbd2_debug(1, "JBD2: inode %s/%ld, size %lld, bits %d, blksize %ld\n",
+	jbd2_debug(1, "JBD2: inode %s/%lld, size %lld, bits %d, blksize %ld\n",
 		  inode->i_sb->s_id, inode->i_ino, (long long) inode->i_size,
 		  inode->i_sb->s_blocksize_bits, inode->i_sb->s_blocksize);
 
@@ -1689,7 +1689,7 @@ journal_t *jbd2_journal_init_inode(struct inode *inode)
 
 	journal->j_inode = inode;
 	snprintf(journal->j_devname, sizeof(journal->j_devname),
-		 "%pg-%lu", journal->j_dev, journal->j_inode->i_ino);
+		 "%pg-%llu", journal->j_dev, journal->j_inode->i_ino);
 	strreplace(journal->j_devname, '/', '!');
 	jbd2_stats_proc_init(journal);
 
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index dca4b5d8aaaa3e1505b09fab42eb45bb201a8db8..a90f9092706cceea56c1100f7d40ccba0d50adba 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2651,7 +2651,7 @@ static int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode,
 		return -EROFS;
 	journal = transaction->t_journal;
 
-	jbd2_debug(4, "Adding inode %lu, tid:%d\n", jinode->i_vfs_inode->i_ino,
+	jbd2_debug(4, "Adding inode %llu, tid:%d\n", jinode->i_vfs_inode->i_ino,
 			transaction->t_tid);
 
 	spin_lock(&journal->j_list_lock);

-- 
2.53.0


