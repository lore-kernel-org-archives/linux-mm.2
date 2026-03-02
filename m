Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB0D1EB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 219AA6B0005; Mon,  2 Mar 2026 15:25:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE6F6B0089; Mon,  2 Mar 2026 15:25:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098B86B008A; Mon,  2 Mar 2026 15:25:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E74C06B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:25:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BC961C2D8
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:25:32 +0000 (UTC)
X-FDA: 84502253304.01.A2894B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C041D14000F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:25:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h1YsGwEm;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNLGTCYpPU0Zdb32XtgOndq80QkAo3EbPBhcCvj3Q1Q=;
	b=vMxlzP3Sp/y7hPZw66magoElKeM9zcjwKYmq842m9PVkoQkgg66uyyCOffgt2as4iQzSq/
	AtNNtO9Ic3LgdV0AhpKzBo7dZTg6QVnvhrJlBAWPI+8/EQyMzeJQ6GDzRKQkG1wM8RUfGl
	64zSZOhNGxi0PrrWuVlk+H95xyrRqeM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483130; a=rsa-sha256;
	cv=none;
	b=Blx+nAPrGUV79P4wDUJDk9F+Dg63WbxkkoppbKnE1hPM4JF4sPI5I18xs6eQrj2mgLRVsy
	6RRBJ0JzcyYjbjNMWMSnf1tJPHIPeYYBB9g8fB+VTdVxc9yUDuTlPe7o7JBcG734bSBykA
	CF2/B69qGt/AajMyauMV73no9UcNu/k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h1YsGwEm;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C862260133;
	Mon,  2 Mar 2026 20:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F56C2BCB7;
	Mon,  2 Mar 2026 20:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483129;
	bh=Wct+3cAXr2AVkFzE/jVOQWTeoTa9TE6CBNx5sw4yG2k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=h1YsGwEmIJFLW3CzZ5bdaHSN7FOic3MM859XdONpETiRcUDTpTpCOxvJ9o7kNEnO7
	 /xK5XcGPfUtYFW/ENmFaQRwFKN2R+eXt+h3OPJC/vekUeqpWsoucdwJaurhoY6wzVO
	 PEsBWMWbFFZOMyTLbyN/JqhQP+3fK785gISoZJuIcXKsX0mFgvJJ27zdsZJ0BlJK5k
	 teaWIuCLkXCwdJGli0atBQkG+LG36qpMQrgpykwU1OdGCjYLHgXyy1Ifemkpz96T8a
	 sZGRtWy1O9whUwEJ9/1jSPRCYKDth5+KE/y5ZPAL/oBdCyC0sVwaWk2uzOgJ52necM
	 9ZJCgMYuXe9cg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:23:46 -0500
Subject: [PATCH v2 002/110] vfs: widen inode hash/lookup functions to u64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-2-e5388800dae0@kernel.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
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
 Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, 
 Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, 
 Johan Hedberg <johan.hedberg@gmail.com>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Oliver Hartkopp <socketcan@hartkopp.net>, 
 Marc Kleine-Budde <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>, 
 Neal Cardwell <ncardwell@google.com>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Remi Denis-Courmont <courmisch@gmail.com>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Xin Long <lucien.xin@gmail.com>, 
 Magnus Karlsson <magnus.karlsson@intel.com>, 
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>
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
 linux-x25@vger.kernel.org, audit@vger.kernel.org, 
 linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org, 
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=11795; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Wct+3cAXr2AVkFzE/jVOQWTeoTa9TE6CBNx5sw4yG2k=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfHvU6cVWqbaDIbMAybD3leM/4REmF8fNAzks
 1D5ugRb5kGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx7wAKCRAADmhBGVaC
 FSJqEACGVXYgP7S/0O88rguKCt5UBBebX78Yd/Ny0Giz/8gkn6H4ZasyHdat7uciwGrE+vzpfec
 hDcmtAeU8KV1g0NTzRwMdbt+fUtDf8Axb+dP87wiZi7B9VebDGYSbxtV3919EVAsZLhhPbdZ1wD
 k6xomTm3YhxIfjzMJoiS8wloIyxavvrGoUlhTsrZHwJGzCMqZut4XIUr6Ea4Mh/f6RQcHb3C60B
 Z9qcpfp1Kx3z5f4axj+htIopvZQgZOYGZw9xjndBhKxZ7bglSMV/JUKPMwzeZQFDYQc9RyusBfS
 c43y9CSbqz4uYufv5ONojU30DcquejtK0pqINYNPT4v6pa5l7YFkVKfiiZebzx+dbvGLSvKkcSo
 C7F1eTT7ra5VIy7WyNwhLJ0hzmj63Th4M1f3NuLFTrC1TWZM5fFO7Clb+D6ISIKUmXTtjkJlrhG
 8S4BdTZDc5G/AyI4RkbED0Z2e+E6lkiR11wXAguJqmpvxGH0AfoRpJc/mLdO/LWfdKz4C6EX8pH
 KQDFX/DtIfpfS1h6opy5lMB75/2+EZB8v5lKtFs5YQubrMeN8V4oasdRh4H1gIn+mS73srj5x/P
 EmrhJmpvXn5miNTq52vSkkliQA3X3Q+giw7hPUILgdV6WOeYTDX5/jns+ZU/QAAOP5kjKT7SXkB
 IBB676fZPDoGQRw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: rbpstegmgxid6op1hbyt1jnsspkg6nhg
X-Rspam-User: 
X-Rspamd-Queue-Id: C041D14000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1772483130-308501
X-HE-Meta: U2FsdGVkX1/VTHVkvJjdpcidkp7h9DwhGD6/1fEkvUn4NsQLbaIx2UwuTJ2UFop0OIx3nK3AqbDrgV4D8DcwahbGuC1uZJHu1A9l6OvT3cRtR9IRbAPwkKKe4ABlKQaQKJ9GDjbHihVK8VxfaO4bf9rav7VaoHn0SlJ6hdx287/1wbvEYIpiQKhh9BfNkT0CCObNm7//VP7qawlIYmM7caOHdq1uhY/7nwSIZvRmp4i+xhXgDtW4l5IxzZcvB11gpNaIrX6g8H3PRrFArzjOfENwTtJaTHA0rvdVfYQpVfOAkh2kAwRHcRN6Yp2+ariXbtIrOnG7v6rU7CxC1iAs0ky6NaEfPkE2CtJiA9QuwHJNdE19po4JiCrZntkTOlq5Qeg26mpbaTW1CLx92+xRP1yRG0rHmBd88X8J78aZnxKPeU2SdBMygXCqvjXEAzWULmOBLypVTxAzZLTwqaVnInfG+q2p+Gar0QaaKoVqgSzVpQRmGfbkx5CGSX0zSmOZnhBk+KCE35505meKRGIPRxCIGv7JgBuHc1m0Vq5QpcMJveNdcbNqYQ8WSYd3jk0Qj4HrqUiOzRLumFhm2YZXgnkVgMMIuGTWZuEvsoszg5A+YmK3nfG6l+ABNOIWpvobxu2KLPIuAmSsiluxVqjbrQZPmracIuSXwkxpUiSWcWkUSSHKWOt46c+FXvhHFJoPsuqNpPBs19DnHWoxJpX5nj+0PVxiGURn7Nak21B9ZM316gVP0xjHDRPK3oJzmKoUBoTFpvacbuAZErQx+CvkgmOV5Gftn6+G9AWZjZx4cpg9iuiD9svh2qYqWXVUdSqBWNQCWSOAYL6B40/NgjLCxrJIJ6TAfSNFFyBbm0Q2Bd/1kKFPylD31jc7NQvKDPvfj5IBSTIOAOPOMigBPNRQPHAU1D6jUFre/B5d6YqYtnlAcgmTKBb0/deaLNK2leEXg5Pi0MkBefdwtDV3T5i
 5iTe6F0f
 jC/g3IiFjQFXSOuB7nIvfZcfzQjSNQwMrLCExMpFZRgMTibriw0WoahooPl1nLUI+LW6jyhZu1iImBRVSK4diymFtvfUuWogYrqi6XNPg3iUFjLU3Ry2wkaMfueptQ7ifPthMVX8E47+YOk12pIFNYcUbcmR2Ch752KwuPrslZKJDqa37VpsKEXKP0FgGqM8LCFosLA08WNApMVHMHlTIUJYyOIH75XNFwwv8bPfUv6O2nz6mBjKwbhTzovJL8ZAbC2TbN/lOxtiva7OZPE2q7z/Fc/iQQn8255EUh7+36o4gVtHcJejROtsifB3ApGNePit9hfcaWX/6Mnbk7uC+7q5iwIUG8bE/kCbra5iAmom2nN0r23ta4qGA6FaWVfgm1y7940oCVqKOx9qisqdnBah2GchZA1ltms01LnCWHK8i92PgZ4pibU1kuU1nhOR8LoIZ77i3/Jjql1R9qsC0JGEwffr40V0J2kT8mVWFzAVxfOqiJR+CQdRxMqeASn+aBvqHAbKhNBZj7Zl+qhcSii6ru5YeCCyhV2W8rWpQvqTFL4nfN9AT3IgbG1tOPs40O6hfN4+3Z+aq7XVR6LRvDT4kXKfHEzSsyKPvAsajiYPuhXagg5dQSvAgU4rTI3ktGt1QgAR7dhmLB5ULBZhHrwLDcduVqAgHlt2fWWe7BfTp0dhVCAu31fwMLUY4nUpkny8CYsAA9HaJOlKOyqUqKwJ8Izx7syWEdR7D94z1IqA0/zfo4aT/oeyPzRBe/zmApnhICUXH+nkylf7xOVKxFQyvnUDl/sh2MJofJhUFmxjz6hCcUfrV7R/yz+75N5hyZm8rEuwe+lrKpLfxQ1h3xqdQ6GRDfePeDxrouJYpTNFrrHyUFWlIHzxp1Fdj0eDMW1IOS+7MqvDyOGuEbePgOROXiO+fbusoENp2O/bJijYL6jnnltPLbkJeW4Jg1KOXjqYFrHdCd0N4MJH9SBJQ1DIj5V+C
 ACkBGX1i
 gWmE1o2eAHsv3AUi2RMb6f/DLwalqZIDdFiujIvIpbtD8E/5xpUM0seq3xE17Ey467iJTMLaFw3CmuhoOEHWLCD7+Pxonyb5bENOIsi9vNEsTqxRmJGbUIGN9XHi5HptZbHsUHzb4e/ZgUCYexZeOYq+mrLOGRnwLA6QuOF5joUJwg7rxVL/wII4p3o7EyVCrEcf35gfhNFPxAalm8xoC4YLhtgswI98QDbwvZx+PzsUMD9fYvlzAOdpLv+WHGn2VhxVulb9jyIUlfe+KCkHDYImIyIkOht71CgXyKWHpTxtSkrdNtiYXxuyU529UGyVRnHdim9OcgEHUAXvymMw2hfqDM89W0/Kz4AasBIFjn6+uMXDWUXLsygUxIDDW4JcYVjnMDBsnEwpK4iooc/4CQhlzTA5/O+Zt3DgDOAi5kvFFmMsforcirFcDqRTrs1agU98pG4sJvjYKVP8rZng71BARwWjcr+IzTQgYQl9233e0PLb9YAD3A+kECLf7qzrWbydnj3STVUvCqzOtLLfjHxdjp33kvbcYJ9FeiMo4dTdr/KF7Ak6/1tgnE/+25LtWk+ARzcj2pIysrCpoBcXc3lHHFDzg2VgDN7vlCFXyXrNy6ADFdllYPFPNYqYatPzehLviND/07LqUtHywckm9mcvsetW7DdafBunqjfeEduSw0QofYjQrCkfZBXpQL/RfGiEhEtNEknomn1P3EyYtvz/Je57a/4GRq8KcAPLWtkOH9WCT2DapRlNkcrrbz1gse3h5fp8ekik+tRx+XZqrsT8M6xlNzZ+MDu3BFFa4F2hGTxbTKc4zwawdYzXBqawnqDcwzM7xnchTeecwebvdHk6viUT4STPaFFgvP6xgIdUdiYZ0merJll/ZtB8R33m5Kz24TlAos6W03DXB04jxhdmD8++5Q1T3voNsdAGZQwVk1vY3G0IfpXleHQnOL9+fr0Cf1LYOoER3jrwue+gKTiRx+cr2
 /Ivp28aG
 r5Dk4SD+68cfr+Xj5x4syMCeTW1pbSmR1X5UJpgHX8U7jsE4nKl+/cJxRe2drEwLocas7i8sCFGZwivDO1Ity4Wxc4kZU1uZu/Evp4ZHJ3nCJmW4Uxva+49AZZsrw0CH9ZS4zC2XF6zwlFml5T89EbMntWAz4563nTgSMdyKC4wSjT9dWSYM59fthd9Cj51qaWQD8Yt/6dnRfcQeLjuF+4aJkDyijtgiTq5BFub8g8FHuEziN7FSc9ytvu4C3aqRfdMSaqM1+lxAtjskuKk9H+eMBuyj629RNUJJNtn8q+0j6FuvsVAtZfPM3LTIOJpEDNEDSFX9vhUrKoOwTTuA08zFk+tee+3epreh8Ist9QjJ6CfkRiifInDxUvVtads9d/ZBorE68hFT5oLQm84b5pzfLAVfzzNcLzQFyp0tsVdj/f8I1Ri/Oybwy9ea2eCLTHrvoR7OsIkpFhH/XGpYAO/A3xOaveTlrxM52yFnn1vvOGeBzssSmLu1/UIcafeEO2RwYRMeVV06DRFSJFvsVxKyfzlGWZZmdjgSHJvSxHaEZihD9UXhcFKSQTbha8bMkT1aj9Prpkj1tiOU8m39250WaQ4Q1XZGoecZZPRgxq0P7MQZNgg/8q2dnpYam8KqDLy3IgUw9YX7myd9x2M/Vt5IqHwuA34H+O5YYcldce8vfcRxEKQWVo5gcrTfG2rjFLRVD55pzPz6Kd1bhag4x7AwKpS4nVECNaS7MS4iA6diusFSl3TvUCThSxdZqr8VD7tbOZRdgGjhlqlR2aDwqFyBzz/LIJy3bgqbBN+DFVQDxVzlkSOfJbGfNxQ5UsowtqI044OvhYbSiWYas3JrtVXNlgqaYTZyWhBw0/00LMdsCOVBnk4JhzQ0yI9sL7zMpB5fOk2pyLM65uekyQw9ONw1SrpONFnp4a4kQaoknZ/xfsS/yssXEmMI0P+HFeZpE+WYQ6UvICTucayANBHbmOgHTt4Ih
 Sa4xCkK/
 cssAe2+SkFv7oQATH1HnQezgBaKTkoUhw2IXpr/fFlO5E9x2t3k2/IntY+K983Y+SdEmSGY/uAwyogrn9FHQpIOQbKHJSOlZsrtnJaBv3FMGRLmpmEQv1LWKootKGlS8N5cw+5x+LKL4Il+UyM5/msR7RGqUO42WPSjCFfAU6h+Ao9GslGAdtte6e62mTI7f3xqOXeCc/UmFm4KFfmVNJZ+rv2/g+w0ObjEJ6vGaa7rHi7cbNgsOA+PWfGRfLgWwpYGl9Zgp5cggcXy+x4oTquHhIr0k/w+1ILpyhyDUIuXzJikfHuR7Fu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change the inode hash/lookup VFS API functions to accept u64 parameters
instead of unsigned long for inode numbers and hash values. This is
preparation for widening i_ino itself to u64, which will allow
filesystems to store full 64-bit inode numbers on 32-bit architectures.

Since unsigned long implicitly widens to u64 on all architectures, this
change is backward-compatible with all existing callers.

In dump_mapping(), change the local ino variable to kino_t and use the
PRIino format macro, since this variable holds an i_ino value. In
init_special_inode(), also switch to PRIino.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/inode.c         | 49 ++++++++++++++++++++++++-------------------------
 include/linux/fs.h | 26 +++++++++++++-------------
 2 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index cc12b68e021b2c97cc88a46ddc736334ecb8edfa..24ab9fa10baf7c885244f23bfccd731efe4a14cc 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -672,7 +672,7 @@ static inline void inode_sb_list_del(struct inode *inode)
 	}
 }
 
-static unsigned long hash(struct super_block *sb, unsigned long hashval)
+static unsigned long hash(struct super_block *sb, u64 hashval)
 {
 	unsigned long tmp;
 
@@ -685,12 +685,12 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
 /**
  *	__insert_inode_hash - hash an inode
  *	@inode: unhashed inode
- *	@hashval: unsigned long value used to locate this object in the
+ *	@hashval: u64 value used to locate this object in the
  *		inode_hashtable.
  *
  *	Add an inode to the inode hash for this superblock.
  */
-void __insert_inode_hash(struct inode *inode, unsigned long hashval)
+void __insert_inode_hash(struct inode *inode, u64 hashval)
 {
 	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
 
@@ -726,7 +726,7 @@ void dump_mapping(const struct address_space *mapping)
 	struct dentry *dentry_ptr;
 	struct dentry dentry;
 	char fname[64] = {};
-	unsigned long ino;
+	kino_t ino;
 
 	/*
 	 * If mapping is an invalid pointer, we don't want to crash
@@ -750,14 +750,14 @@ void dump_mapping(const struct address_space *mapping)
 	}
 
 	if (!dentry_first) {
-		pr_warn("aops:%ps ino:%lx\n", a_ops, ino);
+		pr_warn("aops:%ps ino:%" PRIino "x\n", a_ops, ino);
 		return;
 	}
 
 	dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
 	if (get_kernel_nofault(dentry, dentry_ptr) ||
 	    !dentry.d_parent || !dentry.d_name.name) {
-		pr_warn("aops:%ps ino:%lx invalid dentry:%px\n",
+		pr_warn("aops:%ps ino:%" PRIino "x invalid dentry:%px\n",
 				a_ops, ino, dentry_ptr);
 		return;
 	}
@@ -768,7 +768,7 @@ void dump_mapping(const struct address_space *mapping)
 	 * Even if strncpy_from_kernel_nofault() succeeded,
 	 * the fname could be unreliable
 	 */
-	pr_warn("aops:%ps ino:%lx dentry name(?):\"%s\"\n",
+	pr_warn("aops:%ps ino:%" PRIino "x dentry name(?):\"%s\"\n",
 		a_ops, ino, fname);
 }
 
@@ -1087,7 +1087,7 @@ static struct inode *find_inode(struct super_block *sb,
  * iget_locked for details.
  */
 static struct inode *find_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino,
+				struct hlist_head *head, u64 ino,
 				bool hash_locked, bool *isnew)
 {
 	struct inode *inode = NULL;
@@ -1301,7 +1301,7 @@ EXPORT_SYMBOL(unlock_two_nondirectories);
  * Note that both @test and @set are called with the inode_hash_lock held, so
  * they can't sleep.
  */
-struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
+struct inode *inode_insert5(struct inode *inode, u64 hashval,
 			    int (*test)(struct inode *, void *),
 			    int (*set)(struct inode *, void *), void *data)
 {
@@ -1378,7 +1378,7 @@ EXPORT_SYMBOL(inode_insert5);
  * Note that both @test and @set are called with the inode_hash_lock held, so
  * they can't sleep.
  */
-struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
+struct inode *iget5_locked(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *), void *data)
 {
@@ -1408,7 +1408,7 @@ EXPORT_SYMBOL(iget5_locked);
  * This is equivalent to iget5_locked, except the @test callback must
  * tolerate the inode not being stable, including being mid-teardown.
  */
-struct inode *iget5_locked_rcu(struct super_block *sb, unsigned long hashval,
+struct inode *iget5_locked_rcu(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *), void *data)
 {
@@ -1455,7 +1455,7 @@ EXPORT_SYMBOL_GPL(iget5_locked_rcu);
  * hashed, and with the I_NEW flag set.  The file system gets to fill it in
  * before unlocking it via unlock_new_inode().
  */
-struct inode *iget_locked(struct super_block *sb, unsigned long ino)
+struct inode *iget_locked(struct super_block *sb, u64 ino)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
@@ -1527,7 +1527,7 @@ EXPORT_SYMBOL(iget_locked);
  *
  * Returns 1 if the inode number is unique, 0 if it is not.
  */
-static int test_inode_iunique(struct super_block *sb, unsigned long ino)
+static int test_inode_iunique(struct super_block *sb, u64 ino)
 {
 	struct hlist_head *b = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
@@ -1616,7 +1616,7 @@ EXPORT_SYMBOL(igrab);
  *
  * Note2: @test is called with the inode_hash_lock held, so can't sleep.
  */
-struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
+struct inode *ilookup5_nowait(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *), void *data, bool *isnew)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
@@ -1647,7 +1647,7 @@ EXPORT_SYMBOL(ilookup5_nowait);
  *
  * Note: @test is called with the inode_hash_lock held, so can't sleep.
  */
-struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
+struct inode *ilookup5(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
 	struct inode *inode;
@@ -1677,7 +1677,7 @@ EXPORT_SYMBOL(ilookup5);
  * Search for the inode @ino in the inode cache, and if the inode is in the
  * cache, the inode is returned with an incremented reference count.
  */
-struct inode *ilookup(struct super_block *sb, unsigned long ino)
+struct inode *ilookup(struct super_block *sb, u64 ino)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
@@ -1726,8 +1726,8 @@ EXPORT_SYMBOL(ilookup);
  * very carefully implemented.
  */
 struct inode *find_inode_nowait(struct super_block *sb,
-				unsigned long hashval,
-				int (*match)(struct inode *, unsigned long,
+				u64 hashval,
+				int (*match)(struct inode *, u64,
 					     void *),
 				void *data)
 {
@@ -1773,7 +1773,7 @@ EXPORT_SYMBOL(find_inode_nowait);
  *
  * The caller must hold the RCU read lock.
  */
-struct inode *find_inode_rcu(struct super_block *sb, unsigned long hashval,
+struct inode *find_inode_rcu(struct super_block *sb, u64 hashval,
 			     int (*test)(struct inode *, void *), void *data)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
@@ -1812,7 +1812,7 @@ EXPORT_SYMBOL(find_inode_rcu);
  * The caller must hold the RCU read lock.
  */
 struct inode *find_inode_by_ino_rcu(struct super_block *sb,
-				    unsigned long ino)
+				    u64 ino)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
@@ -1833,7 +1833,7 @@ EXPORT_SYMBOL(find_inode_by_ino_rcu);
 int insert_inode_locked(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
-	ino_t ino = inode->i_ino;
+	u64 ino = inode->i_ino;
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	bool isnew;
 
@@ -1884,7 +1884,7 @@ int insert_inode_locked(struct inode *inode)
 }
 EXPORT_SYMBOL(insert_inode_locked);
 
-int insert_inode_locked4(struct inode *inode, unsigned long hashval,
+int insert_inode_locked4(struct inode *inode, u64 hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
 	struct inode *old;
@@ -2641,9 +2641,8 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
 		/* leave it no_open_fops */
 		break;
 	default:
-		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o) for"
-				  " inode %s:%lu\n", mode, inode->i_sb->s_id,
-				  inode->i_ino);
+		pr_debug("init_special_inode: bogus i_mode (%o) for inode %s:%" PRIino "u\n",
+			 mode, inode->i_sb->s_id, inode->i_ino);
 		break;
 	}
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e38bc5ece1f360d679a8f30b8171292f7a65c218..d0c4789838b5852111583a3e4cced88999496e68 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2938,32 +2938,32 @@ static inline int inode_generic_drop(struct inode *inode)
 extern void d_mark_dontcache(struct inode *inode);
 
 extern struct inode *ilookup5_nowait(struct super_block *sb,
-		unsigned long hashval, int (*test)(struct inode *, void *),
+		u64 hashval, int (*test)(struct inode *, void *),
 		void *data, bool *isnew);
-extern struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
+extern struct inode *ilookup5(struct super_block *sb, u64 hashval,
 		int (*test)(struct inode *, void *), void *data);
-extern struct inode *ilookup(struct super_block *sb, unsigned long ino);
+extern struct inode *ilookup(struct super_block *sb, u64 ino);
 
-extern struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
+extern struct inode *inode_insert5(struct inode *inode, u64 hashval,
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *),
 		void *data);
-struct inode *iget5_locked(struct super_block *, unsigned long,
+struct inode *iget5_locked(struct super_block *, u64,
 			   int (*test)(struct inode *, void *),
 			   int (*set)(struct inode *, void *), void *);
-struct inode *iget5_locked_rcu(struct super_block *, unsigned long,
+struct inode *iget5_locked_rcu(struct super_block *, u64,
 			       int (*test)(struct inode *, void *),
 			       int (*set)(struct inode *, void *), void *);
-extern struct inode * iget_locked(struct super_block *, unsigned long);
+extern struct inode *iget_locked(struct super_block *, u64);
 extern struct inode *find_inode_nowait(struct super_block *,
-				       unsigned long,
+				       u64,
 				       int (*match)(struct inode *,
-						    unsigned long, void *),
+						    u64, void *),
 				       void *data);
-extern struct inode *find_inode_rcu(struct super_block *, unsigned long,
+extern struct inode *find_inode_rcu(struct super_block *, u64,
 				    int (*)(struct inode *, void *), void *);
-extern struct inode *find_inode_by_ino_rcu(struct super_block *, unsigned long);
-extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
+extern struct inode *find_inode_by_ino_rcu(struct super_block *, u64);
+extern int insert_inode_locked4(struct inode *, u64, int (*test)(struct inode *, void *), void *);
 extern int insert_inode_locked(struct inode *);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void lockdep_annotate_inode_mutex_key(struct inode *inode);
@@ -3018,7 +3018,7 @@ int setattr_should_drop_sgid(struct mnt_idmap *idmap,
  */
 #define alloc_inode_sb(_sb, _cache, _gfp) kmem_cache_alloc_lru(_cache, &_sb->s_inode_lru, _gfp)
 
-extern void __insert_inode_hash(struct inode *, unsigned long hashval);
+extern void __insert_inode_hash(struct inode *, u64 hashval);
 static inline void insert_inode_hash(struct inode *inode)
 {
 	__insert_inode_hash(inode, inode->i_ino);

-- 
2.53.0


