Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4626FD8FD1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0D96B0124; Thu, 26 Feb 2026 11:04:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060E36B0125; Thu, 26 Feb 2026 11:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77BE6B0126; Thu, 26 Feb 2026 11:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE94D6B0124
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:04:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9AF9B1C1ED
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:04:54 +0000 (UTC)
X-FDA: 84487081308.18.540B415
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id AB5A21C000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:04:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ihikh0fH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121892; a=rsa-sha256;
	cv=none;
	b=t+jDRM+KRuVOFVgURPG55LXs9gAWNd6KqRMAub8Zrfk3fm3RteL772bhXpJN40kK2Tz7gg
	G0pE110nqxuYS3+oVYJsggFpRQMH/hAqJWwXb+0ElaXFNacqxe+PJtrXkfjR3AlbNwbCkd
	vwoTmoeQRmZrivGiHP+J7EpcA5J9dV0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ihikh0fH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xP2LNvm//fBUZ6GbH/eGhBCodP+vHpbGT+KmTNuV63c=;
	b=v01y/GMOtYGl+vPs/0uLBpjJ1A5dmh4yydoNQMY8JihOuGNYJObjVxDGXQMok1lfVrtgPC
	A3ZjKoiaHeigyREnDTbo26xoIKpPNJj4RmAvAKJjo3BbeIuUYv3/JvDgbcViuel+KroWVs
	DHkckUxNcCTEX4pZ91UpEIk0f4xwg98=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A328B4172C;
	Thu, 26 Feb 2026 16:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9C5C116C6;
	Thu, 26 Feb 2026 16:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121891;
	bh=wgaEh25KMLtfYap2XafuanTTSwLN7VDrZOEdlc+rhYE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Ihikh0fHkFo5VHrN+kl5f9glGlinbKtpho2+DlzUtm4OmjkMCG2xnfPWMK+adJAp8
	 tuz6Jje9w4lDHKub6lxBIZ8ud/+PV8si/+Y6reMvHz/mbUAVxRyEIdTHk5Z5mvkoPq
	 fyAbSrYDacnT0cdxeMC4pv0CYMHBI9b/sdX91/uFj/jRCmQgRXjq7FZWkN2Pk80noT
	 34bnbfnst9zjf3oFsUKAwoa98O9Wikot7oUadV+HG/IEoTHIOqKT7CYUabmNpaTAbE
	 TWndB177NRkSpiMjT0FnrM2tqfOsOweeQcR2wmf1L/VhsVCOC0fl9e3ZVPjeyLaajI
	 vcRLvdwNKn94g==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:43 -0500
Subject: [PATCH 41/61] ntfs3: update format strings for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-41-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=815; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=wgaEh25KMLtfYap2XafuanTTSwLN7VDrZOEdlc+rhYE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0OSIiUz1AkDZ6JYGrAoeFBgTB7iDZPyaD5c
 NromnZp8+qJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtDgAKCRAADmhBGVaC
 FTqCD/9UYfDbK1XGdJjkbgOj5OvuREi9qNRYWSvCJQjp0V1l40Tc2SwR0HmU+EfwBlx6Txb4Wrq
 QdcBO1GXudcSjsvJ/3hDOB4tWaT+HJWmU2xqpTs1Z1tyxrirA1E6eBgrFZFGzvOweegta67Cz7z
 VI0eeOR1o4J4WhJeAmqXgEFNF70lduqS1RwWyH9HGET9JjZWgaQ2zaaEBbxgJ6A1kYGvZzSFdqE
 276PPffVIlQyNtpPaqDUqNQ2n71ynLyE/SxFTeMN40RwZQ9zLXYj7pEBMzCCe5aNctu9Pa+u3C3
 opcZB2xSdWANY+EVsDRUBiP6xPoipYDMS5EoMOeUiNlpB0Umy6Z50lWTGn+4yRK//d8hbJg64Ur
 i5bT2mFmy9QAVGKTGcqnn62Vm/lxRrCeklIgoH1O1dp3hgS3OnZYYrT+51ij1fkoEgpKYQzasJp
 MQF1WYqqr9U3V6EWXm6UZPZ6qv1f5hvsNepUtngGu2BBedYjgk9HVNlFEcX5rUaDaza5rpxEzDW
 D4yhFGSyaYUAKjHy+UjGu2sUAbiqM2qLyNtGqZPP4LMOwQAh3o/hAqoCj+8txericgHxp1879k+
 gs9ZoEcZXM7zFmOIdIdPyEb/kup0f5KrRxobeyYYYoV+9YP/2uBa2lVyl9AxEdR9RzQIQ5ak+WK
 VJL0ubImZpV5d2g==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AB5A21C000D
X-Stat-Signature: nny3pqp4ghuiwn4iwkbn6gwh5j7pbmre
X-HE-Tag: 1772121892-479845
X-HE-Meta: U2FsdGVkX1++pOrgRDEpSz7Uq+k+481kV5Xbk5CLwLl2qREsDhG4DQ1fgCU7EgdZt2DFfWtRrcjSDgOoQbqg9NSy3qraku03oFQxNaNtwKIOLVfKxZ8/GSLfeT6CN8XJ4Gv5WtsYoNfrz//DeB6Oq4j6mL2KbfxxK/WgTCnDFZhKbqyZFkXnWhn59ddPaI7WUmAv0WVuPLSjYKzMSneWZmsC7XIvh3mGMk62X3JwHcSnFBUkuvUfFIoDPy/trDuzTDkzsv6EElk04HnBsZkuw+1N9jKU7EvaTmvSNIoSYAA2MZ0AKftqx2dIVYKRWqwSegxeZVEsxDBLpRKSQRg8az4LIHyS4Uqc+LQi8fx2ILt8ltcSo9F+hGZO4PUjN0R2G76aJWH/dH4OFDG4OKPNx5Zz0vB1l985LuY8Uae1c/WdFj9wwBNko9mSN1oWK2g/u20aCnAjV3nFaLK2AbllRwcyBf8w2DWW8btPLaRxaZfoXUoU87qVx7VXO+5p3rt3YvRcPk7930da+8VSuiPfnfBIV6r1dsuYsqL6wIZ/+Ei17NKo7wWiRzbXPA2emre1gCHYrvX18WBcoOroFO0b1fju0C8F0cJ0RpCNsEpihS7aKFx8y1I85FaZOBWsz+FRQ+u43tZu8paLiaty7t4wrbq6xFMZSV8AvqSbS+bk1YDkLD/UW7/w6T933fSNyK8kIw7UGNA4zmAkUUbeEEijJqQJOTUGnCCHPRMtbfCz8uyW+ndxwrdlyGlfVGdr31JvHjju0ZtjCunl+gVxOchXk6zbHkzEW8uLiTrvC44eNTmOO+7lNt2WVAbkvD2y0eP/2FBZUAsQ8In0gjLf6eETIfmnY8NPehzrQ1uyVdcc3z0xGPl8VBqAnCLIhufqxILE0ALPir4JdS9ZD/edCaWvYH9XcZLnb+xowXzb+IU494btL7yDmPTWSnkN2kobLobuU01YQEu2MNb4FFCBGfO
 DF0dW7uc
 uyI0R5xgDv+H44Cbe9LA1wYvjyIBp7jRBlSIfkbRESroQe4KkLn8ZoSqH3stMmpkeyfCr80MjbkBUTHq1VcgTpU5NQuoha3H8Z/ffIg3pDCBUgPhr/VrUz+GQav6N6fm2AUa5NH6+H8V2Fvnq9nP44ymFaIvg2UwdQGKmkFFI0j7ioBOx/2JKA1AfkgqA6Uus/Gq5YX8osCpIlSX+zF6cHV07U++sLhhcpsnrVuzB82xJy9DXS7bV9r0Ko4ybyWNbQXwmuCeNaoLtskmplVoSHq6pr9I3Uge7lg0BSThWfUS/UfTACQEt9efXbmvF0wsJocjn4cEd1y5kRm2efks8jWjSaUxNPOT6L9sESrwVCVkI1z+/xbsOTzMo5wi4qFFFt5qt8+l0Vqit6JR7oTQR6J1g87KKNzYFP7stKeRsyldAw9+DBeAlOmftJHpAg8Op1b+Cy0BB/ancnQR2rI/IG+CVMwsLbnhc3g3u78WGJHR7uAusC7W/PhOHQZ6JhRGY8LMfhXIrX618TmMLx4WDvCr8JykUYKMkCR8FXpNG5K0TRJAl2g4LXCFHODzPk/SzM6J5tfINl+WK0PqCidoXhS0DmNJloHjTVspLen4BpG/aabme8qEIP3WW19KmRy4bzn9TdSb/zDCDclN3dyWiXABGykvklOngeMoUKMOwNknA/jFbBCoHrqrN8nhTRP1Mf/Ijiu0ZIA680LIIHUOAJq8IDAgXcHoojt7mAdd1VrMYyRSb00v7LN9rYctHDQvWk8HdjphjxuiCW/x+BzEGtuLprZrLPym8ciW/aDNM1WReQemOOvQAcUU2Zmul7q7oOVKESh1xWHtCZjLK4LEIkIwLeE6XgZuAQvQULjTX5nIUlIgE8jwS56dpkEagOGzcAkRDqCVtawwIzZgy7xvGlfPJ6oP3coOfBlhTxrV+Dny4wbBUxlPCq7V4jJSZYaDOllIWsU309QsgzSi4L06fB4f4Xpth
 fSPtMUP9
 jywp8w4V9M7+KTs2jfrubsbPZ11pKFeV1Rj6v3MfNGCjfDL//6aWUk9V40Q81/sSAjZFLXMvMQNV/DGHmNA/kx0l24DZQjAWFd9RlM5FCocp1PExqgXjvWCpanINLLergFHkOXiz/ipuGCH/3p+J6PU99KYSb5nW+J14UIBCciZz2Q1zrK1jsJe7I6NUreBUZipnnmNUkkwuOA3kFHvadioXe/S4ISWxHzr9mZbHcgrIU/TExHHmPoZiM3bx6ksm6UmOsJyvwRWKZQtksFVX+vk4pL2X9IMz6ZACG53I82hMcQrttJAE+K0TGGGeDrcBzI+8t3BQdRIIiT182uLnNSIgzDbkXXq+Cz9nqCjHtppHiXfVGnQOoC1WKeVpryYWwxW/pAi+yTuPVPvisChxj7h9OFlQ58VKnU7EHTm2OMnFB/tRMio2u+gKtwq5gSN6V0fIA3AykRlH2235KgNmCrZHYuY5+DgqDQb4vFEGcRsM8WqKV5n+fyR+hbqo23QShQ8Enm6qaN4LN8ovBFbzYva7B4UbGF1HOVii8YbukFi0ijzx1ml5K+Y26NHKyy5cWWWHEpKx9gAR6cLMFP0oBXf1c8agx/tgwSdfYbGMqJO5VvfaIJzL4JBb8aUz4l94sjI2+fjvU0RXfwyVvB4tQfpJtIjT5ABIxEdkmGD+DzmRVlCBrIVyjTwYIm3kxTwF2ecsY0X39cNR8mU2d31IMRhe9PkImTltkXUz0PzbHteD3b8ty2oZn6AJKpQkqB6ZuoVPnqldnG6gh6r1w7Zyga8/XFjCujcw9JRVxPutdrw3iKDmD69IVK/u1u+EHuOCNktLrdDCUbh90h3AJHWmBjfy/Zp887i/K2Fif1QhYBPsTqyHylmkwOw7ZBkN3Zn3BGxB5+Z/QxT8DIQSeo28nKZ7dKdjJBAmSXZwiTWMxXe+20TS6XkexkDHPLEeQLgDVNohTHq0R+Rhww7+YV8ypmaVF+0f7
 nRqtSl1A
 Nr8VxtaYcIdgxODLLnyARxCNiB6N2rROymZei99v5zBCNCKmrojUOnPtziwsqEtfmsPO+nJnBN8nokWJU7xJmRN/TYz2C4lWeB/jE6Bs0TZ4E+76TbymF131TlQRvGrAzCHWMzhBu4pEOW5IQyOK2fvcPVxwxsx0ifKU/cux2kbJtvxQasHE2LcrS7oEJapFBhp/6Xl7hpDc8nWT9K8KNo3/SxwqElDsL6to4lqIYw6eAfQWPcTOtnAgf0wM8LGr6QFG7rCDdBj/ZWM7Fbq1nFxtVJixOcDbRfmptPfVe3P2gvltsnpETECfKjB5bPl50bHRxDOIEqFcxpfzIUPBB0JvpIKlEVHLK4FZvtArP/xKrY5RQaKKFhQvwjKKXaRGTdLHdlvnk8dj7zSiw47TiNF40Gas+y8Ueu8b9WR/nv0NmypAi6k+HL3JHBh2bmYhmvHDVMTlYNlEd9oi+107WWEjb9+S5lQsiRaOZjho4iF3oooWhGs999A6MSPInvlFnT84FdwoYZOg0nYzwtZqSMor9JIH6i22ZVAtT4Ji0/iIPOsDqs6YviSkrqmHprlJmmRR74PmCCq2b7T/YBU6VDKLzZdSjAb4DUyi0RvD5HwYs5dgyp0P8qggubiPd9Pfag/78N42VfEwRUOLCOwLYikeHD6t1zDpemepIGAtnA8ITPLC+ygatyRqyrhu3M1EWln7ccg2aZ62MvWiLnvWGgtb/Z3Bs2mrWRKoqk73T/BjYyCzYRetDN5CZhXhyTikTEURD06G3Tt5Eq6zcTwWXUduHmegxrE4Q2Bbs+ZJo/GGcsG5xqX4Ge6FNK3jNB+x9llAzyS1IPc9sI92PHiMy+K2BfNXG8uJDiETmkwfkwl9jA5+q/8oDyMe4fo80CWdr+uBOEbCJ2Ej4yE2fbPG3u1xUXJsf2COxbJwRpWoliv5GhnVkOZA6PGxTuR5/bLOY4Fzov3KtHyw2fP2ycz9QGOC77lvF
 8qQbVEGi
 G3+FyTPQS5eNfj4XmTJ1O5JdwG52w9JiUnXSxJcHxJXf23iwJqD56sQa753QUQSghYGgzASyrZwNIsgUj3YTEIVE5ubedGqfKwwzeineq9xLG7mE+y8fksOW7HhZzjG8ReRqItfHirtSe8Kg3areqG08DmC+pvAX7pKSg1+4PmqnhjH6yko8RmOw2PQDkQvfqcc4nC1ijnbGKqbXO231i94wF+5Y+9BI7O71+LCy2FgZKWLnPTSH631v30TBls4CQsaz7kDmQc656K8ANvPzDckZGGvTP35Sx/ms0T0FHBzigwSTKGtVhmF/ZT1W5ydsUdIXE63c06PI4SRxpwD0pwuiawMW/jsVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update format strings and local variable types in ntfs3 for the
i_ino type change from unsigned long to u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 174a7cb202a08c550b3b8497cdf6105192be2e43..51aa008e126a8af18c39dd825a17c12df859329d 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -153,7 +153,7 @@ void ntfs_inode_printk(struct inode *inode, const char *fmt, ...)
 	vaf.fmt = printk_skip_level(fmt);
 	vaf.va = &args;
 
-	printk("%c%cntfs3(%s): ino=%lx,%s %pV\n", KERN_SOH_ASCII, level,
+	printk("%c%cntfs3(%s): ino=%llx,%s %pV\n", KERN_SOH_ASCII, level,
 	       sb->s_id, inode->i_ino, name ? name : "", &vaf);
 
 	va_end(args);

-- 
2.53.0


