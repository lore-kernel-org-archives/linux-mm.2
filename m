Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF0A3EF8FE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 14:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB1276B00B4; Wed,  4 Mar 2026 09:10:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E196B00B5; Wed,  4 Mar 2026 09:10:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08596B00B6; Wed,  4 Mar 2026 09:10:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9BB16B00B4
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:10:44 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54FBA140520
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:10:44 +0000 (UTC)
X-FDA: 84508566408.26.67E5F15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id AADAE40010
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:10:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sAz02NRT;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772633442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BUGzLaR4oiwfa8Tc2HLwo4cS/7/x2OrFBp5XTwrJflA=;
	b=11aNYn4ivVa3847PywmgsCHsTFJFLU5YH1wdwlcSgO9BdEwDmEhSNCPexC4d18HEOpUwQa
	J6Zw/JAirsZvJ6otiWd+I7q5nvpcCUpEyegJZf9ucARRopp591KxP3XcV0AnYH4vr+/z9z
	BqgIGBn285SyFA9JeB2iWt4oTUgwaQw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sAz02NRT;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772633442; a=rsa-sha256;
	cv=none;
	b=B0fp1SHxra1vXOQAXHJgMhDsy7d1Y/FG47ISkcPgfSwAup8rsvtUBfSNlxMPUYpOpTnMZL
	3tOMmgasyY7GqFmKy860lOfQpvLaQCMonbQot4uwS32L1VelUzJJwZgETAxzcTOnV0M7Lg
	cH/kZopIl/NcyO4jbRjo9z/OsuK6vas=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DCC286057A;
	Wed,  4 Mar 2026 14:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DE7C4CEF7;
	Wed,  4 Mar 2026 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772633441;
	bh=Bku8AHYCvwFigaxdtJ0ELP83jX+2snVdp3SrZhQcXMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sAz02NRT42GUSH/XghziBQEfEYYLQ50Z6H4Fr0B2eA5Ig7mTdF9TqYffX1JwUH063
	 6iPM05ojth9/rEwbEh7LlaKMnW/u/G/DBwkw1D4RYJpuNNZv9BhCLvT5PBe8IK+opn
	 1prADkLNYfSK2LwBPPaKHTGvsA77KEstjjcpOVzMmR0TqLvIhVflYrknnXy1YVCUsF
	 KNWXNBL4UGedCW/N+3VD8K8WE8OpUqMxkpT+k7q13zK536d/Te1lHCzdRyNNW/lFIe
	 pg0r1tP0OVdv3K3K3qvZzr4Ne1W/IxrE/2XIks7z/Ez5vNzwXN9J6wfHu8zNwQlTwO
	 dc6E9EejFM6tg==
Date: Wed, 4 Mar 2026 15:10:03 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Eric Biggers <ebiggers@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Alexander Aring <alex.aring@gmail.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	David Sterba <dsterba@suse.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Ian Kent <raven@themaw.net>, Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, Nicolas Pitre <nico@fluxnic.net>, 
	Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse <dwmw2@infradead.org>, 
	Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Anders Larsen <al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, Joerg Reuter <jreuter@yaina.de>, 
	Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>, 
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Oliver Hartkopp <socketcan@hartkopp.net>, 
	Marc Kleine-Budde <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Steffen Klassert <steffen.klassert@secunet.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Remi Denis-Courmont <courmisch@gmail.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	Magnus Karlsson <magnus.karlsson@intel.com>, Maciej Fijalkowski <maciej.fijalkowski@intel.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, fsverity@lists.linux.dev, 
	linux-mm@kvack.org, netfs@lists.linux.dev, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-afs@lists.infradead.org, autofs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	codalist@telemann.coda.cs.cmu.edu, ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org, audit@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
	linux-can@vger.kernel.org, linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 001/110] vfs: introduce kino_t typedef and PRIino
 format macro
Message-ID: <20260304-gebadet-zufahrt-3dd11ba681d6@brauner>
References: <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
 <20260303012556.GA6520@macsyma-wired.lan>
 <20260303042546.GF13868@frogsfrogsfrogs>
 <33228005140684201de2ca0c157441d3b6a06413.camel@kernel.org>
 <aabkBadGzo7IZpSU@infradead.org>
 <19e4e79a59dcfc4c61c8cf263af345d0d7026fc8.camel@kernel.org>
 <aabpPQxCTweoTp8Z@infradead.org>
 <1310fc5c09cce52ec00344b936275fe584c88dea.camel@kernel.org>
 <aabwflLfe2HcGv7X@infradead.org>
 <4d3b9b92da613ad329b822f3f6043fa08f534451.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4d3b9b92da613ad329b822f3f6043fa08f534451.camel@kernel.org>
X-Rspamd-Queue-Id: AADAE40010
X-Stat-Signature: p7goeyugwdi5n4j5kwngy5z64uftxxnd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772633442-799609
X-HE-Meta: U2FsdGVkX18dJ/ynczi302s5FOIsr0SfPw+ykxCcL1nSSW33SW8bio6QXopgXCFgFmDTI0JCslEk12QU9eKeuLU1lJr5xNafEVk07h95dafc/RXrbqqN/y76Vy6ybDETZQ7zq2gR93OpzwQ7e3kYMXblRNNDf/KXWAV5NBa26Y2cofb1uUZaR+viUHaOIWap1OqlGuXVOoWVnzPaF8jPiNdD0zqsQVXemrEpSNHXyZuusttT8nn142h3LWx7nk4DbbZO8dP9brRMr1Be2xHrWMICignNxgqA+AH9o1VE8BUoL0fxgHaEWSYO3J08dCDOkRj8XB+JhLGalPIN+7F88en5JGQk8xwyDwCiBK38QZUYj2hCP51lUbSJd2y3Xi+ERV5qpj2McX6B12hd0NY6xA0CPEHo+coPqKrfcYG5IE4wRVj/txvwGXUXmKuasK3N+aNcLV+dIu6uR48rYE+PMifrY0QfyKitNAmyNowa6aZBftRAnyHVPGOe3mHj3y+o32jKZMyeLa45oy42uQe0Y/kHQBEp9PIMIn1MoPjT2/KoXJj+TJGe4IXXJyt2QYxsrcNDlloBX6h0AIPUxFI8I5dMprHBq/1qZ1ZOVY1e5AB4r1WLZPVqWy8E8p9LYfcS9Los+ZnqCrr8zRZG5GCAGdlnjPLL+QbCx5FopcXDxmNWHKIC9ccZNHif9omh5GfklN8Edg84y6hjh57rifQcwwQhYSnaRsnYJx1mUixkoMNqEFWy5hESfTk9UHSsaubBecPAHRfCABDJ4bhH3Vu0VP/YzLIfAgUAy/qmP+B2HvudhSA7M/kBU5+4oETspS+ctinh6dquBlPhKVyhEqXJd9Um2VLZBdeHT2abYs24DQ3sUIA4d2fFSGFgFy2XNEQyh2/nwjuDg7hZcDnGGrC7g+9B2GzDivxI2XV2L1jTXi1q4RxAJC7m0Qf/AE+HFAAGm09bZfXcRVoTcClu09E
 zWwif5wP
 TD+ZWEigtKp9cAOyEqXK7S1bOQLu/GI1BpAf0g+dyzBfLnV02RvvYZ2LsUSAX6CM0SeOlLSG5DHQ2o/BmwbUrjM0wMiNbhRdRIuqIb6lgdStZedwyElF4uTxT7qzQne5e1RObhX2p2kmevm0S082VO6sEatBZ0NR+34c1sVUZU7i0pR/acAgltdNquEsSmo+6ikROC5lbBNxgNX/j+1gty8ZiIXMvzRD9p2+JisyQeL1unKHVSl1IU56vmoIp2sRZ5QXQtrgAQmnyHWnoym3zxtLLoOiaEcLKKaAEZ1HZ4tobe1wWtrPz2flnwMgXGjzjM8eDQUzJpPkobQlIp+Cqv8kyF5tclmNT89RmtNNlmOM1LodPUNZVuJaHKiyhsVG+FZJauMgXQE6rgKMA1BEjx/eFb+iigLJ18Vj/uYB5jB2mXxt1SedOKiHRCTaoFZUU7a1wbbjvHkDxllsPGteWRM1WP5ozpkox2jMMyBycUyShttxXtP0dEzBQLT9gkevdhWKErPEDcOYJE0WeR7HNerklzEK4t8p3vSd9nBxOJVJY0Zi/2/4RtnHlivnI0dAty9tVY/xKVNMYH23/4MpF2xRq3iT0dtMsVB7vk3Ql2CPaKwtpcZCLk6Te4tHW0xI7qnUraQiSLaw+do2U7M4kENkmrKp3RndCPAbKB1xMuO8QupHDVM7/UejVrEV/X66/iBnbG7gV4TlFeu9aX8qp1HkBGruuZaZ7MUVUaoyXqYDW30NOO5tJztXSvTwEIpqZ40DGCOd2tm/dmG0b7/eSYk/ddp7BC5Wn8Qje1GVTmFjYlfIBfTaSvlvRs9ebd4Gd7Dzfr6yD8u+MpZO2Qag8QG2YJ3YMSsQN60cHS4JVfZuOZhaOQ1rP64AKnNQ0gw2aKgMtj+h17j97AdXhLzmFsRhdn/fvMMPQU0NPNVkG8Z0QBiYbQu2uHnd80zlMDQu+3oZRsAKTQg4X57mJjXEcBrKIlNgY
 iMZ62sQY
 +wErAz4iIn/FZmybHwKX14A7UryU/EPpkEIrUjwc4QCdaFtyj7GzykYhuMggQumqwa6vg0Crcx8pfOipeIQyKzGrywi2mzwXK2v39IkUzk4PrHAw037oaGecs983zOfHTFZQnHz+tOoExxfTGV1D0P8TGMzEeCzFGy0s+BdLxOWnRmjzsGs7WqUP8ZEGgfkF5TjE7LfE/iTrEBt+CdmvOinw3uQSeAoJrzfmqIq8y43PoFkvw684Q5tJi4oL46MFwZi9eU+bZMdcJxC1w8Q0NJW2NpSw5TPMmUzNd0oO4dGJmtc0RsaUjgoAbnVXA2m95s/69vWTAQikqXVT+icxuUQJhQ5pe/cNnh6Qd/kPCPZpXgXo8kpIjeTp34Nl4DJhzELGfaO9g5kmKq568uR5F4WnDkSuG0Tm7H8XCAZRmCD9Q0vnIIxu2iHkjDBw93aXMahdwFrKd2pz+2/zlzkWslyjsB20h7VCfRS0HzkkO0mRvyAPsS7BTjQwqN7X+2D1u9ABpkM9O2hL3W7jHxlBW3OH8BeVOu/BE9AOLD6s8Si0bF6XBikFp7jnGHvR1l7FkToko+7x2NnJWIDoMxzRSR/XnzNOioy2UACH6crKn/V2yIS6ZX6MmXUbx7tZ3bV5RXF3zC06qM5PBFcUGKbwUtvfa+8vfIVZQjRGO8ey14tBYhn0smtL2iUek8iybDzbAwTV+ttH/TSz4I9GmSPkvMxo5vNlT2EshfdlHDi82qnuJcHVWecpoYNv1AWkGRpdqXex258xNxycKSgZQbX1U1W1yZWp5OFLK+6AV4h7TV2IFv2nG7knDZn28aA2ckKXC993ccMCSf3oOMTotgpomfh4fTqFuVHFW8LZMrs+AbLbbWtC8iqQ/dhBpUA6A6/BrBy5R0/5gCxvPUAJ/C8exr5GcwlsEpNLN1EVnxOiirtufJJYoD0I6QMqrUHKXzubf5whej99XfVhEX6MRI6Ss1v8OiGMj
 Omwp5MWO
 fLidexMn5haRzuxz/booYO4mCQdXDKh93HX6RR9Pr53hHwdH5CObB8+1DciFqKpG+Y9MfNyGXp+OOn/KWDdktwH5cD1uhjGw7WCI3LTt2qZSqgZZjRdAs1/AjD4xiDbaN89DZPk/w6/LlM+bzkpndbCEyMtZjQ3FvKgSaXieQ5Hre4VMkA/5s/GACEIH3VoURn6A1AzC6q47bVVMPbJ11+LCF2/f6M1LxW7HnT3pX9uKeknXSIzFItqxZ51eLOpYvsImGxsEu9rs8wSibjVncnzEibFAyxQQVAmLCOCmTLiCmjYrW2r1oZGRQ9JmKwyMBwJd2MkXOR/zsMTkSsDi/Fle45bVxhhNPSB4xMnofQAbDx+svZ7KejQnA5HREtlEEY+7tcdryvAeOKyVfswTAVjkzd3IuNKHHBfK1NSAIi4Ao9bpK3EdTbHYoXJeSSY4Wq3sJVOwvcA+e5jYfK3/RUPT90IMlZnEmRepf4MydQMvczwAmpMdt1zo2iJp/yO0d3L8KjmJk2kpnUJZdBf0F/5tG5Xn38+TgSR6cnaYj2r5r8mScUhC+4prnAc3doIgIot++gtPmLi+ci+bzp+ZNs5bLB8cIKEWrZr6b1hhTCnKnPMQDZpiMx24X6b03YjzFd4BirNf8ThzaqVHHhyBcO702cj091t1CirhfNmFMezTXZsFByf9cmCO9/uqaB+rWQ2g9nNmSJ/q2fwLF3MSvvbQmDsvKF+aQzVjkKgLbg9Cc9N5GY/p5K1LFJ+InOWbuMMTbkkhdmrA+eXomqAppxbSw1y7V2OXI2KCfwAcVTrIybU3u5oy/8i0kyAdraF0RYyW3Egk8g1CMfUvYM+qgKrMyEJAIgUKIScEczBXYiIf4cveDWK9VKLYEs/0dIv4Auea+weVk4hAJuaPb0NFiy1QTO00YMQ1MNsWGlhKY2fneAIH/EoLahQqFmlk+4NAaio1CyseMAmPt3oDNP5PsuwVd8AfU
 iFJ8QYbQ
 Hiz3KFjJNJryUksCFEPJKjFLbrET4cbMBOUw2P+RbGhxS7n5R/gAvtqXFal4Eng0Yq2/RS5Zxjq3dRWtn1679xl65dzK4B/4U6dI7cuTp/KSrYj7mvyqxaoxElgoL0nVyVv7/y9rTkOZOTrJq82bAj+DNLtdWwMdHDXXRRp+Cij1UADO2wOTsHn4+bh7IfS5Gg3WO/LzcWslDYBDCZd2aE+LunJK9DcLCxde+oa41yLAcR/84/fxLRgQByPJrigS8zsgwkvbV1jBNyDhMMS9BqgWEe7DjQEF2y2No9cqj/CRBtQZhSf0KqHOPf3hbVdIEwNCNiWri0aTQOTfwSwzfwqHAdlgLvpihkIExxql/+48GFshSKYsybDnoOTehCJM8uXxOPWLGVtC0Jcav7jo2e4VSDewj/p+XtiNKzLXmBQJxfvtDSuXFazDIyOO9U65g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 10:14:27AM -0500, Jeff Layton wrote:
> On Tue, 2026-03-03 at 06:30 -0800, Christoph Hellwig wrote:
> > On Tue, Mar 03, 2026 at 09:19:42AM -0500, Jeff Layton wrote:
> > > On Tue, 2026-03-03 at 05:59 -0800, Christoph Hellwig wrote:
> > > > On Tue, Mar 03, 2026 at 08:43:15AM -0500, Jeff Layton wrote:
> > > > > On Tue, 2026-03-03 at 05:37 -0800, Christoph Hellwig wrote:
> > > > > > On Tue, Mar 03, 2026 at 05:53:39AM -0500, Jeff Layton wrote:
> > > > > > > Like I said to Ted, this is just temporary scaffolding for the change.
> > > > > > > The PRIino macro is removed in the end. Given that, perhaps you can
> > > > > > > overlook the bikeshed's color in this instance?
> > > > > > 
> > > > > > So why add it in the first place?  
> > > > > 
> > > > > Bisectability. The first version I did of this would have broken the
> > > > > ability to bisect properly across these changes. I don't love the
> > > > > "churn" here either, but this should be cleanly bisectable.
> > > > 
> > > > What do you need to bisect in format string changes?  Splitting
> > > > every variable type change outside of the main i_ino out - sure.
> > > > But bisecting that "change to u64 in ext4" really broke ext4 and
> > > > not "change to u64" is not very useful.  Commits should do one
> > > > well defined thing.  Adding a weird transition layer for a format
> > > > thing that just gets dropped is not one well defined thing.
> > > 
> > > In the middle stages of the series, you will get warnings or errors on
> > > 32-bit hosts when i_ino's type doesn't match what the format string
> > > expects.
> > > 
> > > There are really only three options here:
> > > 
> > > 1/ Do (almost) all of the changes in one giant patch
> > > 
> > > 2/ Accept that the build may break during the interim stages
> > > 
> > > 3/ This series: using a typedef and macro to work around the breakage
> > > until the type can be changed, at the expense of some extra churn in
> > > the codebase
> > > 
> > > 3 seems like the lesser evil.
> > 
> > No, 1 is by far the least evil.  Note that it's not really almost all,
> > as all the local variables can easily and sanely be split out.  It's
> > all of the format strings, and that makes sense.  The only "regressions"
> > there are incorrect format strings which have good warnings and can
> > be fixed easily.
> 
> Well, I've done 2 and 3 already. Why not 1? :)
> 
> It's not so much the regressions that are a problem here, but the merge
> conflicts for anyone wanting to backport later patches that are near
> these format changes. Having that change broken up by subsystem makes
> it easier to handle that piecemeal later.
> 
> I think we'll be looking at close to a 1000 line patch that touches
> nearly 200 files if go that route. Roughly:
> 
>  182 files changed, 910 insertions(+), 912 deletions(-)
> 
> There are some tracepoint changes in some of the per-subsystem patches
> that will need to be split out, so the count isn't exact, but it'll be
> fairly close.
> 
> Since Christian will probably end up taking this series, I'd like to
> get his opinion before I respin anything.

I'm kinda surprised that we suddenly started caring about the amount of
individual patches. I personally don't care either way. Do it in one
giant patch if this moves us forward. I've done 1 and 3 and what you
did. And I'd be really annoyed if during a bisect I start to get
pointless build failures because someone did 2.

