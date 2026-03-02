Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D3DCEB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984226B012A; Mon,  2 Mar 2026 15:44:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E156B012C; Mon,  2 Mar 2026 15:44:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8FD6B012D; Mon,  2 Mar 2026 15:44:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC186B012A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:44:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 32AEC1C302
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:44:27 +0000 (UTC)
X-FDA: 84502300974.28.F969A10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5400F40007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:44:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E9+ubBiy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPdHvQzlD3hosTu2dcBXX+2MnsPea1UVCFR5m+6Wiu8=;
	b=K6pUAMUfwuNSvuWUZMwLizrFfE4qjLc79Mp+vnyluSxl+cE2x/y2ywnkD74K3zJd+ll2Ms
	Dt0845OzIQcLBhdg12d2yztMyVlXJgYhFf3fO84RUWGU04Q6fpmsc7YI2+PFT+OJ6ObXOs
	EPpq7ENctFwzV4BfTdocbk58gQuM00M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E9+ubBiy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484265; a=rsa-sha256;
	cv=none;
	b=w4uObZ7C9zsZQCh0TXpvglILCSGjkXnB+hcLXhxWTdgFrX58TFgAJ3EK+ajL3ilBs1/EJm
	o3eyl6cBy5nBrXK+8xbdFRLXJBUcK0JNJonrK/QgaWQsTHF04/J//4gFykXzlpk9RQSr7l
	Pt5tcplxxgnJkhb4CL0LPE5+vWtNiPI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 67615407F9;
	Mon,  2 Mar 2026 20:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3517CC2BCB3;
	Mon,  2 Mar 2026 20:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772484264;
	bh=4E1gzRUBmunwgkb0zMzfDEZ/3XSvh+vlngA03NseX/8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=E9+ubBiybQM4l8J+x0uaWTrJ76FPaFlfXpfLW274DMsNkP+ZxsdUliXZoKKVP6djg
	 83tb0KTHY0ioVcHMcYF6YTXIDwmqUIiMzvE4ba7OPOV2u4HgV3LB3sVX8MXanItq+3
	 iHqFjtWyG4FeIpoVAydn4THnBQBPOHkNggIOt+pOQ9PCK3D6wZ1lVvDMzkzQvAxX0/
	 dhK7SILY1PhxfyDhxG0b0xRZnLFC+sZUYeyNvrbE3hrd3rDb6iypP7aQRRKkh3AkMy
	 AGf0z8UjGi9SiRcN+d3yNP5QWj6m1ZrplF3x15L3Fk+R2kjMIfG/y8oDo4WLJvTe9+
	 Nh7DfktB6muXg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:25:05 -0500
Subject: [PATCH v2 081/110] exportfs: replace PRIino with %llu/%llx format
 strings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-81-e5388800dae0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1107; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=4E1gzRUBmunwgkb0zMzfDEZ/3XSvh+vlngA03NseX/8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfIFr/xLC8FHqElos9Jx0FlcCMm2vSh3OUBzE
 MyfOvUWL8mJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXyBQAKCRAADmhBGVaC
 FXrgEAC2fOFg/WTLNoXvWGsPImb/26xOHXaPVYy//FG+b/NEfpy0INOU75ohoYtWFAlQQQAVy6K
 WwFypniJMx7qup2zKyPqMOBDdXILeEaHzrFxwTkebRBowv1lHwDN1MNIMVH/eI46ZuIGPflMQ2/
 nl/BGjeBU+RC8B7uJiHCnG1SKIFFTe1ehGOstt1p6PkK7BkMB9GijlEPo8UTDJP5ISpt1BWylby
 DGfEZ7FrRe53WIFFKCloOE0ziSwiJEPJggN8UtT0zzc2oDnbPKJLZIuqo7P4BHY6pABLlMRYB9k
 1dfj1ytzYywLzl9F1pb5q/mZ6zX6zUhhqlYX6ihQoZBvRrJcnQdkdYsCKEBjyleHreTywcEhg/I
 xiBAh7k//PoJAoEp92y/4+fN+s1IbU5yCFu1LRgTywGkFugeE5qazuuj3KlHzwitAD5/keMeR2n
 MpTGRLUa7s2PYj8NE4d0hV8MutPuy3MLiyvS4+zQSsR9Q4/J8vXGEGCZ4WCMOa3SstDomdJHIbr
 s1gEWIie828N3apNapK7BtKyPYbBYKl8FCqOVGyTGQvR90q7TvyFrZ+cix1VvyCfpUP2PT5Yn/H
 8w82mrmMztw72nvuHUy9j3RS3KEEBs+FdelNIuKaFQ3MwiY0P+GU4DcQrlqBNfMCPZCMZnVxx3o
 34OcsOZ2JYQjryg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5400F40007
X-Stat-Signature: 4wstso3bimrf5qaoty9btc1s4neg63ty
X-Rspam-User: 
X-HE-Tag: 1772484265-705039
X-HE-Meta: U2FsdGVkX18vEHfr1nJT4OyFDZ9EbGREdQ33qGHeJvgOdiMdCYZoOp8GDr9nouLN0lHYipEShXA/MWgfS6eK/HWKqL5yYa1Up/m7HI2dYfHRGWD9PI9Obi87SOsHtrDDkViMpNmQB+KbhMAc8Us0ezqkN1XPY3WOSPrmThoDENFSzENoaTca/e3it+NyLpH4dOrAcwoOZ8sOJON5KHPkHmLWLvzQgIt+REfbsyhQX8Jj3yHHN7gZVOFSq6Gzx7fTuVCnfYsRsXzlIs71WRK2bovL4MIwCuT/l62k/98320qwT2MRMXWXs4AQiwt+k9fs1fWR2FHWPNvRuMV1zktvTzqBs8y+oWqvdwB215P7BXhTtH9fD4GG5nhTpRQ+Es6rimLyd0ForcGDFq1gj/2srUHYl1qcgbPy8ictoznlBrfWd93MFH5jKLefqHNPAo1XD1kAKQfabM8up4gmfxrdfeFZS7iPzCSr8KKLdlKPYAi8fGcDv1sLBiv1mALIJf1aZSyOMacRWTH6+DaCZXkTlPcgr7xf1kf9iTfNG22plFLBRV+oIjCIcfSoAzBztw1ZBFvmMKdlZrPvARfrG5slt2xRx3mBteFIi3DSKlRCezQ199eNflobLhidZmuygo47uLaSimCqMY2EebdXVU1TkAsWVVRimJvYdGvRI4MMfc+AcCGoplQ54/Y+/9fpjRPCSW+JzaR87HI2C1/Pn6H+yfIXGq/XwbQKajl8Kmzgx3OvMq/bmNj46BpznMTHlkmtLrH+Nmz/UMXfFg7K/JJMiqopCS48rFxkfoikkY/lfnBofCRfbc9Y2gpEGyDl5dqNf2mDwtM/7nsPlp09f5OP64Qrodx8GOeDgpnh6E3+4XL8RuQyxUyGrM8eMQdowQg3FSpj5H1OVeztDBrSVVfqRD48kUUQTsOAe5CRNIUF8D12/L+o97o1bnp+wki65VYgxYTFJOSLYDmcwVwayPT
 u/cJHPTu
 e/KdyOI9+LWZ+MqG6xf3fGw5ujs4ItSWkEz4WLblEDxchB5f0AVrO35coAvn+4SQBtUALFy3Z/8eE9bv1hq+lUQigTNhQHlQ3aL+CLnF58vTfRefzAlrKpTmj33s9uBqEK1n8Zq8wUTZ4/Vx8DHQq76ZL6521BFfW9SpOhuvN3P6ZS0k23c79ayEt+XWSoAFGNhk2TFTMPHauDaptyXxD7wnOacF1EUCitB3pQi2ssGEY3x1mCVTUl/HPVqGOKmKk03y4BauKwUzKMcKgeHl64L00wu0BcWU+GtB3+fjDWZX1IQFXio3mK/8tsLpOgB/YJguuMJxoJw9+SueyDS7BP/BnApSejkI9fRK3zLQEQ1sPevLNTyxH5tXpC7/KRb575z+YqVN1/4HkvtdZmaT+NxXNhM3PEB2M//XvGcqdJdsh6E77K20+oj7ma6llf51/+i0PGCbhPmkM9fTO4fziSdr7H0q40G+lpgGcEr1uacR0mcHY3jjztp0JqdTEDMWT/jgOC59yiwMfjfiVNpA48JnLA0Vbfs9xW1tw33g35Wu5Q5w61MTEL56rVHYDHnzSkZKLW6QqELGFuTsd7tzsarka3JY3FfSRQamPRtfSp9dn1LYtHPfBAbScDCJhkXLwU10VNEGA8pmuUFJCN2OK6iPLZHwbwUG3SuCMid44QDGBp6QVltQe1XJ/mjtW3LZKZVq1zdCZQ3Zpz9n+8mpYRy2d1e7W9iGQByCw7gmC4LNqS1aQ58DExcZvKMQ8r5hB4Zq3iI2aInPLHRIc9bf+RVsEWk2pe+R8JxIBi+zc+Y+YXJl55SjTHdLuti4C7jpOf43TyNWRSwHEs78wytPfnf0SnVfl0Go2x4y1obKOoeka1s6BqNPKgbzeKDD/WaPHESbyoFYtslJ/3SIQedEwbnmDSs76eCLxp8dlYQvclY3PrXOhgyrTIhUQQqqpfu+4JxyHwqsnIHr2S4wPiPlLkzvx83SS
 ASSC6dsO
 OzEeD8PQFTfEzNWdN8NtJ5asWmjs2l8NHlLp8hzs9vFPRyt+VWxa65rgGutRxKKIYTA59dAaurzNuHC/KUVk9tOaoD8/DSDyQcawLKoMoVQAc/TUJvqtqFFPhPI+owyzfmpzmKlAltlbOAi02KNZSTorxiUcKYwJLfRIh4Gp9WwzcJ7bjN5rY/EKPO7m2r76gvdZWEDD7yxKsPMNIcj+btV1f+Rp7ANI639D/WxBqsapSahBUE1lyUqCMa8vedoY3x5W6V3tOeyKplOBUFFya92T8aMqYX75uWsGPVSy062NUcY4QEwSahJBHS6J1BqTYEp6mvpgvND6Dxh6cTYWWHCXGbbht1asc2YnzrTye4/tFBlK3NFMP/TAN87Pu+PjF13xgwGKYkhT2VEeQPWprPazbcOSV8JofJGrTDfQtOmQKMjm8WASVoOoZEMSohqNgSwS+uzUPC44OC1KgypMSVexLZmv39cCLv3OYJ+TIrq2CI+cNYn1ulMQfVlh6y7cIMo9Vq8VG3POYHJ13VeKxaAsBPNnLaBGGAzJ/3myF60r24I85LLT2KI77WhEGXQ6BAVRgbqh9L3fuYC53wqAOFY715afNcKRIArYgG9HGWkZCFeYDOrXucqHXA0l8+NLTQR9IbywVSJtXaKwXQP/iQJ1/dasGv/uokZOTs7nmOcpUcaeC/HXw/mOf0oFDmKEOaadULlNlP5ArosoB6XOG8xEZNx6Gk81psZRzR6O9gWOGoPtzfpqRt6j+oScvhUjX48HQs5qf9e5/x5wpjrNZ/eXmcvaIST3fPxiiuCQeAAmATmsnCXUPcl3tnFuUuf4864KkA0AHS1MsDc/aYSrnpT141TTfPyDgan+u5SOq7JcOVpM+XuVzX0n/u9DG65r9xiUhGFqdTxV2j2UG/XP2hGNKD2F8Onh8zU2ToAdRWhd9mFPq69+ViMAQ+FAAKblzYO1N9HfSStemabs2TnWnKj72/hbp
 61Me3yEf
 Gy/YcKDzSO69fy/pOd9SWUuYGsvf2y9mcWtDq3/d5n5pFlMCNzJlkd1J0VrbRI9ggyZLgRw/5fOdGnPv3zlfOZGqle04+3tnNzp/o6lRF768Tir+PYK8eHgI4bVhiqwYiWDtCv+ugZE02zvmZx8Uko+u3sXs5+XCLsdR536wB4vZxDSWBskiqXLOOMesnTBFCrOvocIPjW0BcsD7plKiJyBe5GC/0pricjmebsurkqJaqDRt0xLgthwSpQsEG1t+PtMvEwXsp95fQ+FsK+8Rxn/cbjhbVnzjEhLrDZCsDhhdD6z5iblioSZa2NKtsA3GoS6duhosKekoHTdXseaFk7KmgThniAxvmwyGSNpHExc9vMEsZF2PfPXN8iv+8Xl84O3GIRt1S3ZMdmOAcxO1enPwgMOJV/xqBj2sVTtOxQAVw9tYmk2KeEWrG4q0fS9uLIYlCWCnX6iQtoNelQ4bkz4gNSkzDJ45aCKW5EL+jrT4KAlpGtCzM4az0jJKj0WpJ97YsfZCcFCNP6mqSY7GzFMoI3uyxPzeYXENplENJSvL8FiCaPmF2uGpu/wLXDmx4y8Lxv+AeMEuNXLNpA3zHQGt9Eg0xE2Cvo0/4oOFk+MAsKvTtpEdQ7c+HKWu17DOjKGEXJ35C9l1UbyWn+r4O1hvWxOS8htslkQ17girfE1aJ98HvgwLf/GI5w09SERRDGEaDL5qjVDeIFvLMWnqJnD64VeX8PYV8/kpUF+L6gi46NbbnwOCxGCwbf+FRgZQ1UB4KspGLiQUWwkLFqmxmFADfFEpu5gWHFmXM2WfLNp8wu1X3Zgce3gTObwMl0Zd7h8ikGy63jJJPJSeRhK5wpxI0PFyacungjiA2L/AZnxyvqFkJDgEoc9IYZtIOa4Yxrc8lxtKR+wbqUXs2doUE2DvKgChxeh4dmSk10eoMTu8eyG1EVJiQSCdusL6JMSjiFCNPuWX9ksigrf6vigOK8zByrEwz
 8UT41q76
 gYtNf4XM40ibvODjUts70UdM4tgsBs1Ey8N55chXnCAibqxcYYd/myK1IgBUmrPOAPm9bglQHqM9lAtCiFVjIENxGzPhuovbcf1F19kPFqjeME3+Y/FLip2CfotseheUuRvdP4zEsEdLBY/Ml5AXRCezx9T3mveweGTNFgatLiluddXPRztN7NFFMcg6fUMRNC0PgvaZGINXmLWVLc1tysXKsCACfUXpCQi4L/+YGr5NmKPj0CHHB5IeE6vQrsX25KjYHBmjpCzaF/jpVh4WZztfHmnGDxkgwn+YLlMwACuOp52/9DHQBc53bk9C/e6dI12N9n/Ev8OrJw1hPuSJZ2ggz9ihc1gfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that i_ino is u64 and the PRIino format macro has been removed,
replace all uses in exportfs with the concrete format strings.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/exportfs/expfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index b9ec3be466a06c9ea90cac62979887c3fe1af5a1..5c3183ce350ebc89ba4a5c10ffd644b6666395c3 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -130,12 +130,12 @@ static struct dentry *reconnect_one(struct vfsmount *mnt,
 		parent = mnt->mnt_sb->s_export_op->get_parent(dentry);
 
 	if (IS_ERR(parent)) {
-		dprintk("get_parent of %" PRIino "u failed, err %ld\n",
+		dprintk("get_parent of %llu failed, err %ld\n",
 			dentry->d_inode->i_ino, PTR_ERR(parent));
 		return parent;
 	}
 
-	dprintk("%s: find name of %" PRIino "u in %" PRIino "u\n", __func__,
+	dprintk("%s: find name of %llu in %llu\n", __func__,
 		dentry->d_inode->i_ino, parent->d_inode->i_ino);
 	err = exportfs_get_name(mnt, parent, nbuf, dentry);
 	if (err == -ENOENT)

-- 
2.53.0


