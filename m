Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31D87EDA682
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 15:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F0636B0005; Tue,  3 Mar 2026 10:14:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450486B008A; Tue,  3 Mar 2026 10:14:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D60A6B0092; Tue,  3 Mar 2026 10:14:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17BE86B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:14:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B121D1A0220
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:14:49 +0000 (UTC)
X-FDA: 84505099098.20.33D1503
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E851A40004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:14:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bOtyGOy1;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772550887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iBkaZnzDcrSX1Vjtd077OChmjWaJhBpXj2ieOFqI0Rw=;
	b=UoZ0mcIZT497n+XB6H2Teklv6B76wrwXYGCNx0oe36o/MDObx+YVtTb3ybqRRZ9JWedb7m
	+9z4ZnnXFOC2PpeFLDodrto9hixdcXFZlgVm/mAmp31qZITxFN7JCPDAx7KDMAiA3o+zbu
	N5K0uyE6i5m0tYj5vEIPs2lnaQo3nUU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bOtyGOy1;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772550887; a=rsa-sha256;
	cv=none;
	b=pm8J4OUPItvyeKesH5p38OdqgkJCdZ0w/JvjbJVyUUCDMcSD5dCM50fNQ/xQmbw9CQixtZ
	x1Fvt4OXaPNVBmOy78onUcRJxE42o4oC7Rk5vFvbk86A4G+txUs9pZ3CbG9EUz1Twu/mmQ
	MFuo3DhNnmdQaYZ2GlVG8jyfVbYCxi0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CCCF960128;
	Tue,  3 Mar 2026 15:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9D4C19422;
	Tue,  3 Mar 2026 15:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772550886;
	bh=LUIJz4FsIWfEPnQTh3nTlMuIExFTK9oFuiI/WIKZaBk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=bOtyGOy1zgXQ9SeNybe47MisNVK0ZQsVj3kYL2VIBbakWQv9jitSA8b5wSqV3TSZA
	 2X57FTDxFmpFCBUdF3ZkEt+1HevVNgJVJgYiUB6mFFR6y2tK63Zy5v+Xo8CQ9oi5lq
	 gpCLjoUKYRhit+PJnWCGFSEE+ZiJCFkY/6ZZCOnXVS98tKxmr5riqyCyVllXXtec0G
	 m64D3VUmoxSiXqHXbXd06UgIztTY4HD4WUwKmWwhCiSJL+QxzZqL+3+9L/eYvsVfiy
	 d+NOX8HbnI/MVXcEi+uV5z+NakEKYD+7wk6B73CaNREtlYybAXNRghRJImB9cRspT7
	 6RfeRfaYVfyEA==
Message-ID: <4d3b9b92da613ad329b822f3f6043fa08f534451.camel@kernel.org>
Subject: Re: [PATCH v2 001/110] vfs: introduce kino_t typedef and PRIino
 format macro
From: Jeff Layton <jlayton@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Theodore Tso <tytso@mit.edu>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>,  Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers	 <mathieu.desnoyers@efficios.com>, Dan Williams
 <dan.j.williams@intel.com>,  Matthew Wilcox <willy@infradead.org>, Eric
 Biggers <ebiggers@kernel.org>, Muchun Song <muchun.song@linux.dev>,  Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, David
 Howells <dhowells@redhat.com>,  Paulo Alcantara	 <pc@manguebit.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara	 <jack@suse.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,  Trond
 Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck
 Lever <chuck.lever@oracle.com>,  NeilBrown <neil@brown.name>, Olga
 Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,  Tom
 Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>,  Shyam Prasad N <sprasad@microsoft.com>,
 Bharath SM <bharathsm@microsoft.com>, Alexander Aring	
 <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko	 <slava@dubeyko.com>, Eric Van Hensbergen
 <ericvh@kernel.org>, Latchesar Ionkov	 <lucho@ionkov.net>, Dominique
 Martinet <asmadeus@codewreck.org>, Christian Schoenebeck
 <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, Marc Dionne	
 <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, Luis de
 Bethencourt	 <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>,
 "Tigran A. Aivazian"	 <aivazian.tigran@gmail.com>, Ilya Dryomov
 <idryomov@gmail.com>, Alex Markuze	 <amarkuze@redhat.com>, Jan Harkes
 <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,  Nicolas Pitre <nico@fluxnic.net>,
 Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, John
 Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li
 <frank.li@vivo.com>, Mikulas Patocka	 <mikulas@artax.karlin.mff.cuni.cz>,
 David Woodhouse <dwmw2@infradead.org>,  Richard Weinberger	
 <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, Konstantin Komarov	
 <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mike Marshall	 <hubcap@omnibond.com>, Martin Brandenburg
 <martin@omnibond.com>, Miklos Szeredi	 <miklos@szeredi.hu>, Anders Larsen
 <al@alarsen.net>, Zhihao Cheng	 <chengzhihao1@huawei.com>, Damien Le Moal
 <dlemoal@kernel.org>, Naohiro Aota	 <naohiro.aota@wdc.com>, Johannes
 Thumshirn <jth@kernel.org>, John Johansen	 <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>, James Morris	 <jmorris@namei.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, Mimi Zohar	 <zohar@linux.ibm.com>, Roberto
 Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin
 <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, Fan
 Wu	 <wufan@kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, Casey Schaufler
 <casey@schaufler-ca.com>, Alex Deucher	 <alexander.deucher@amd.com>,
 Christian =?ISO-8859-1?Q?K=F6nig?=	 <christian.koenig@amd.com>, David
 Airlie <airlied@gmail.com>, Simona Vetter	 <simona@ffwll.ch>, Sumit Semwal
 <sumit.semwal@linaro.org>, Eric Dumazet	 <edumazet@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Paolo Abeni	 <pabeni@redhat.com>, Willem de
 Bruijn <willemb@google.com>, "David S. Miller"	 <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman	 <horms@kernel.org>, Oleg
 Nesterov <oleg@redhat.com>, Peter Zijlstra	 <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland	 <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,  Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>,  James Clark <james.clark@linaro.org>, Martin
 Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>,  Joerg Reuter
 <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg	
 <johan.hedberg@gmail.com>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Oliver Hartkopp <socketcan@hartkopp.net>, Marc Kleine-Budde
 <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>,  Neal Cardwell
 <ncardwell@google.com>, Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu	 <herbert@gondor.apana.org.au>, Remi Denis-Courmont
 <courmisch@gmail.com>,  Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, Magnus
 Karlsson <magnus.karlsson@intel.com>,  Maciej Fijalkowski
 <maciej.fijalkowski@intel.com>, Stanislav Fomichev <sdf@fomichev.me>,
 Alexei Starovoitov	 <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, 	linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, 	fsverity@lists.linux.dev, linux-mm@kvack.org,
 netfs@lists.linux.dev, 	linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, 	linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, 	samba-technical@lists.samba.org,
 linux-nilfs@vger.kernel.org, 	v9fs@lists.linux.dev,
 linux-afs@lists.infradead.org, autofs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, 
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
 linux-x25@vger.kernel.org, 	audit@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, 	linux-can@vger.kernel.org,
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Date: Tue, 03 Mar 2026 10:14:27 -0500
In-Reply-To: <aabwflLfe2HcGv7X@infradead.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
	 <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
	 <20260303012556.GA6520@macsyma-wired.lan>
	 <20260303042546.GF13868@frogsfrogsfrogs>
	 <33228005140684201de2ca0c157441d3b6a06413.camel@kernel.org>
	 <aabkBadGzo7IZpSU@infradead.org>
	 <19e4e79a59dcfc4c61c8cf263af345d0d7026fc8.camel@kernel.org>
	 <aabpPQxCTweoTp8Z@infradead.org>
	 <1310fc5c09cce52ec00344b936275fe584c88dea.camel@kernel.org>
	 <aabwflLfe2HcGv7X@infradead.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=mQINBE6V0TwBEADXhJg7s8wFDwBMEvn0qyhAnzFLTOCHooMZyx7XO7dAiIhDSi7G1NPxw
 n8jdFUQMCR/GlpozMFlSFiZXiObE7sef9rTtM68ukUyZM4pJ9l0KjQNgDJ6Fr342Htkjxu/kFV1Wv
 egyjnSsFt7EGoDjdKqr1TS9syJYFjagYtvWk/UfHlW09X+jOh4vYtfX7iYSx/NfqV3W1D7EDi0PqV
 T2h6v8i8YqsATFPwO4nuiTmL6I40ZofxVd+9wdRI4Db8yUNA4ZSP2nqLcLtFjClYRBoJvRWvsv4lm
 0OX6MYPtv76hka8lW4mnRmZqqx3UtfHX/hF/zH24Gj7A6sYKYLCU3YrI2Ogiu7/ksKcl7goQjpvtV
 YrOOI5VGLHge0awt7bhMCTM9KAfPc+xL/ZxAMVWd3NCk5SamL2cE99UWgtvNOIYU8m6EjTLhsj8sn
 VluJH0/RcxEeFbnSaswVChNSGa7mXJrTR22lRL6ZPjdMgS2Km90haWPRc8Wolcz07Y2se0xpGVLEQ
 cDEsvv5IMmeMe1/qLZ6NaVkNuL3WOXvxaVT9USW1+/SGipO2IpKJjeDZfehlB/kpfF24+RrK+seQf
 CBYyUE8QJpvTZyfUHNYldXlrjO6n5MdOempLqWpfOmcGkwnyNRBR46g/jf8KnPRwXs509yAqDB6sE
 LZH+yWr9LQZEwARAQABtCVKZWZmIExheXRvbiA8amxheXRvbkBwb29jaGllcmVkcy5uZXQ+iQI7BB
 MBAgAlAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAUCTpXWPAIZAQAKCRAADmhBGVaCFc65D/4
 gBLNMHopQYgG/9RIM3kgFCCQV0pLv0hcg1cjr+bPI5f1PzJoOVi9s0wBDHwp8+vtHgYhM54yt43uI
 7Htij0RHFL5eFqoVT4TSfAg2qlvNemJEOY0e4daljjmZM7UtmpGs9NN0r9r50W82eb5Kw5bc/r0km
 R/arUS2st+ecRsCnwAOj6HiURwIgfDMHGPtSkoPpu3DDp/cjcYUg3HaOJuTjtGHFH963B+f+hyQ2B
 rQZBBE76ErgTDJ2Db9Ey0kw7VEZ4I2nnVUY9B5dE2pJFVO5HJBMp30fUGKvwaKqYCU2iAKxdmJXRI
 ONb7dSde8LqZahuunPDMZyMA5+mkQl7kpIpR6kVDIiqmxzRuPeiMP7O2FCUlS2DnJnRVrHmCljLkZ
 Wf7ZUA22wJpepBligemtSRSbqCyZ3B48zJ8g5B8xLEntPo/NknSJaYRvfEQqGxgk5kkNWMIMDkfQO
 lDSXZvoxqU9wFH/9jTv1/6p8dHeGM0BsbBLMqQaqnWiVt5mG92E1zkOW69LnoozE6Le+12DsNW7Rj
 iR5K+27MObjXEYIW7FIvNN/TQ6U1EOsdxwB8o//Yfc3p2QqPr5uS93SDDan5ehH59BnHpguTc27Xi
 QQZ9EGiieCUx6Zh2ze3X2UW9YNzE15uKwkkuEIj60NvQRmEDfweYfOfPVOueC+iFifbQgSmVmZiBM
 YXl0b24gPGpsYXl0b25AcmVkaGF0LmNvbT6JAjgEEwECACIFAk6V0q0CGwMGCwkIBwMCBhUIAgkKC
 wQWAgMBAh4BAheAAAoJEAAOaEEZVoIViKUQALpvsacTMWWOd7SlPFzIYy2/fjvKlfB/Xs4YdNcf9q
 LqF+lk2RBUHdR/dGwZpvw/OLmnZ8TryDo2zXVJNWEEUFNc7wQpl3i78r6UU/GUY/RQmOgPhs3epQC
 3PMJj4xFx+VuVcf/MXgDDdBUHaCTT793hyBeDbQuciARDJAW24Q1RCmjcwWIV/pgrlFa4lAXsmhoa
 c8UPc82Ijrs6ivlTweFf16VBc4nSLX5FB3ls7S5noRhm5/Zsd4PGPgIHgCZcPgkAnU1S/A/rSqf3F
 LpU+CbVBDvlVAnOq9gfNF+QiTlOHdZVIe4gEYAU3CUjbleywQqV02BKxPVM0C5/oVjMVx3bri75n1
 TkBYGmqAXy9usCkHIsG5CBHmphv9MHmqMZQVsxvCzfnI5IO1+7MoloeeW/lxuyd0pU88dZsV/riHw
 87i2GJUJtVlMl5IGBNFpqoNUoqmvRfEMeXhy/kUX4Xc03I1coZIgmwLmCSXwx9MaCPFzV/dOOrju2
 xjO+2sYyB5BNtxRqUEyXglpujFZqJxxau7E0eXoYgoY9gtFGsspzFkVNntamVXEWVVgzJJr/EWW0y
 +jNd54MfPRqH+eCGuqlnNLktSAVz1MvVRY1dxUltSlDZT7P2bUoMorIPu8p7ZCg9dyX1+9T6Muc5d
 Hxf/BBP/ir+3e8JTFQBFOiLNdFtB9KZWZmIExheXRvbiA8amxheXRvbkBzYW1iYS5vcmc+iQI4BBM
 BAgAiBQJOldK9AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRAADmhBGVaCFWgWD/0ZRi4h
 N9FK2BdQs9RwNnFZUr7JidAWfCrs37XrA/56olQl3ojn0fQtrP4DbTmCuh0SfMijB24psy1GnkPep
 naQ6VRf7Dxg/Y8muZELSOtsv2CKt3/02J1BBitrkkqmHyni5fLLYYg6fub0T/8Kwo1qGPdu1hx2BQ
 RERYtQ/S5d/T0cACdlzi6w8rs5f09hU9Tu4qV1JLKmBTgUWKN969HPRkxiojLQziHVyM/weR5Reu6
 FZVNuVBGqBD+sfk/c98VJHjsQhYJijcsmgMb1NohAzwrBKcSGKOWJToGEO/1RkIN8tqGnYNp2G+aR
 685D0chgTl1WzPRM6mFG1+n2b2RR95DxumKVpwBwdLPoCkI24JkeDJ7lXSe3uFWISstFGt0HL8Eew
 P8RuGC8s5h7Ct91HMNQTbjgA+Vi1foWUVXpEintAKgoywaIDlJfTZIl6Ew8ETN/7DLy8bXYgq0Xzh
 aKg3CnOUuGQV5/nl4OAX/3jocT5Cz/OtAiNYj5mLPeL5z2ZszjoCAH6caqsF2oLyAnLqRgDgR+wTQ
 T6gMhr2IRsl+cp8gPHBwQ4uZMb+X00c/Amm9VfviT+BI7B66cnC7Zv6Gvmtu2rEjWDGWPqUgccB7h
 dMKnKDthkA227/82tYoFiFMb/NwtgGrn5n2vwJyKN6SEoygGrNt0SI84y6hEVbQlSmVmZiBMYXl0b
 24gPGpsYXl0b25AcHJpbWFyeWRhdGEuY29tPokCOQQTAQIAIwUCU4xmKQIbAwcLCQgHAwIBBhUIAg
 kKCwQWAgMBAh4BAheAAAoJEAAOaEEZVoIV1H0P/j4OUTwFd7BBbpoSp695qb6HqCzWMuExsp8nZjr
 uymMaeZbGr3OWMNEXRI1FWNHMtcMHWLP/RaDqCJil28proO+PQ/yPhsr2QqJcW4nr91tBrv/MqItu
 AXLYlsgXqp4BxLP67bzRJ1Bd2x0bWXurpEXY//VBOLnODqThGEcL7jouwjmnRh9FTKZfBDpFRaEfD
 FOXIfAkMKBa/c9TQwRpx2DPsl3eFWVCNuNGKeGsirLqCxUg5kWTxEorROppz9oU4HPicL6rRH22Ce
 6nOAON2vHvhkUuO3GbffhrcsPD4DaYup4ic+DxWm+DaSSRJ+e1yJvwi6NmQ9P9UAuLG93S2MdNNbo
 sZ9P8k2mTOVKMc+GooI9Ve/vH8unwitwo7ORMVXhJeU6Q0X7zf3SjwDq2lBhn1DSuTsn2DbsNTiDv
 qrAaCvbsTsw+SZRwF85eG67eAwouYk+dnKmp1q57LDKMyzysij2oDKbcBlwB/TeX16p8+LxECv51a
 sjS9TInnipssssUDrHIvoTTXWcz7Y5wIngxDFwT8rPY3EggzLGfK5Zx2Q5S/N0FfmADmKknG/D8qG
 IcJE574D956tiUDKN4I+/g125ORR1v7bP+OIaayAvq17RP+qcAqkxc0x8iCYVCYDouDyNvWPGRhbL
 UO7mlBpjW9jK9e2fvZY9iw3QzIPGKtClKZWZmIExheXRvbiA8amVmZi5sYXl0b25AcHJpbWFyeWRh
 dGEuY29tPokCOQQTAQIAIwUCU4xmUAIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEAAOa
 EEZVoIVzJoQALFCS6n/FHQS+hIzHIb56JbokhK0AFqoLVzLKzrnaeXhE5isWcVg0eoV2oTScIwUSU
 apy94if69tnUo4Q7YNt8/6yFM6hwZAxFjOXR0ciGE3Q+Z1zi49Ox51yjGMQGxlakV9ep4sV/d5a50
 M+LFTmYSAFp6HY23JN9PkjVJC4PUv5DYRbOZ6Y1+TfXKBAewMVqtwT1Y+LPlfmI8dbbbuUX/kKZ5d
 dhV2736fgyfpslvJKYl0YifUOVy4D1G/oSycyHkJG78OvX4JKcf2kKzVvg7/Rnv+AueCfFQ6nGwPn
 0P91I7TEOC4XfZ6a1K3uTp4fPPs1Wn75X7K8lzJP/p8lme40uqwAyBjk+IA5VGd+CVRiyJTpGZwA0
 jwSYLyXboX+Dqm9pSYzmC9+/AE7lIgpWj+3iNisp1SWtHc4pdtQ5EU2SEz8yKvDbD0lNDbv4ljI7e
 flPsvN6vOrxz24mCliEco5DwhpaaSnzWnbAPXhQDWb/lUgs/JNk8dtwmvWnqCwRqElMLVisAbJmC0
 BhZ/Ab4sph3EaiZfdXKhiQqSGdK4La3OTJOJYZphPdGgnkvDV9Pl1QZ0ijXQrVIy3zd6VCNaKYq7B
 AKidn5g/2Q8oio9Tf4XfdZ9dtwcB+bwDJFgvvDYaZ5bI3ln4V3EyW5i2NfXazz/GA/I/ZtbsigCFc
 8ftCBKZWZmIExheXRvbiA8amxheXRvbkBrZXJuZWwub3JnPokCOAQTAQIAIgUCWe8u6AIbAwYLCQg
 HAwIGFQgCCQoLBBYCAwECHgECF4AACgkQAA5oQRlWghUuCg/+Lb/xGxZD2Q1oJVAE37uW308UpVSD
 2tAMJUvFTdDbfe3zKlPDTuVsyNsALBGclPLagJ5ZTP+Vp2irAN9uwBuacBOTtmOdz4ZN2tdvNgozz
 uxp4CHBDVzAslUi2idy+xpsp47DWPxYFIRP3M8QG/aNW052LaPc0cedYxp8+9eiVUNpxF4SiU4i9J
 DfX/sn9XcfoVZIxMpCRE750zvJvcCUz9HojsrMQ1NFc7MFT1z3MOW2/RlzPcog7xvR5ENPH19ojRD
 CHqumUHRry+RF0lH00clzX/W8OrQJZtoBPXv9ahka/Vp7kEulcBJr1cH5Wz/WprhsIM7U9pse1f1g
 Yy9YbXtWctUz8uvDR7shsQxAhX3qO7DilMtuGo1v97I/Kx4gXQ52syh/w6EBny71CZrOgD6kJwPVV
 AaM1LRC28muq91WCFhs/nzHozpbzcheyGtMUI2Ao4K6mnY+3zIuXPygZMFr9KXE6fF7HzKxKuZMJO
 aEZCiDOq0anx6FmOzs5E6Jqdpo/mtI8beK+BE7Va6ni7YrQlnT0i3vaTVMTiCThbqsB20VrbMjlhp
 f8lfK1XVNbRq/R7GZ9zHESlsa35ha60yd/j3pu5hT2xyy8krV8vGhHvnJ1XRMJBAB/UYb6FyC7S+m
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: E851A40004
X-Stat-Signature: eymn7wfykx858zdyotn3whxgsysk4g6p
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772550887-954589
X-HE-Meta: U2FsdGVkX1+uI7TNsJpnRyr5Z1SVFoGKDN+gYN+9g7Z01T41Kq7L+I1XAD+RRt/WpRVyXYa1iGY2+ORbec/pUlSesKEasCBMNAIGVAhtOEePTD4k478u+sHeSOR0NbVtwDJ1cjhRw76MpFTBU4e0ykin43tTrpRfl2mkXeJsMSh4CrfexVKoBS30T1UbiKEWKtmSHpfgl67IFWcIk5ILT55SjmcS7HwTu9qYkjixIxRZ4ddYx0PXS7kHI1fqeIn/3m+gx44B8Unjq05reiU0rQomDmqZLPfidx0sByNwHP4UPGNCQfRqZdFcfE8VvL/izct3kXl7u3yNj2vcAokLXlx9dMaG7Drk7g7hZ/Cya31lyA9I02cf8fg1kkWsg9rpBQ+PUndLXdyZAbAwHtTUtxP4BcRF+woEN+QgQcnYUJEjvNUVTnPTH7ul1DUOjhI4kON8Ns2m2a9kZEFmvdxctSl92duh72jRIBo1gn7gleJcBavKZEoBJ0PP7nnv0XpT7o/b5k7v0QqM4MwyCmxNeJPhouusadmPUtWIc6QJ4g0u2CaCgyV+iPv+i5Yj8ZlR+WnE3yToliPovUUwbSeD/gBKgkU2irpvxrYYLTB3DMJw2iZVpKHe0ll06rssytmBVfJnUNmICewLzysVhmtO+nHpMqmwojyB3BMVthOrIbSGviqHeSo1wdxEx53ZiRoctjXjHvITbyUEkr3N1PxnoUNajuW0vxzUN4mc3Kx/fOUoI6cJ+SH0Elmob0SqtQoPmGA/fF2RcchVx8BySwzXAFIMwTW/sIqJ70uCLJ819YrK6vWJTShABWlr6XCHaiXOL5rp5vub1Askw99TqCLO6tS2Q0tWxjH2zA4nqeZLqHQ5/NnRfaNgACSizr7zSk2CQ55SK2iDnzPq36Z/9UYAhQsjy9w1fJMUhCmktTyJ5K+Hxef/NAEuIdqzPZnj9cu5cLTZIAsvUiBxYrNji88
 ke636swy
 yqGzM6+mtJdzrm4Mmn39jW4XVoJUgjdDmBguRwOhMz9fhfw3ylFC2x6MuOFXAYs9asj5R7oLpcEUCBpygKV2YjDwpzwGLQuOOODmEemZtTLPTIO739J/UPe231OK3NZ5MHJVBRVAVkOGShrQeDYSXJgSHf0tt7DyJdFJq5k69PJivDoeusHmRG1uvJiByb6njCDg7A4TIFjj57KdNEvQnBuDSweVTLcc9gMsMP+0Val6W7VW8i4P3jWdi/zVpzgxfuq7h3wrb/dTnm6c07hN7hpHrhwosmQJbmqszNHWh1Bb4U3p5eUbmVoO/68BporgxkY39adTu/goMkaR2d76uH4H8QzUC8SgCobbmMODcpLohPl2wyar/nwqXiY4Y8TCMcNTS3NkxxITGXewWQQsJasL0Q0FvLScbV5xis8SgicPFfJzRC30c0v22SJFY3H0e/DN6ptNdj8hvxlxnOpPEdE5CXc4YFObWwJn4Oysa0jp6qYTvgNDoBOrEVH27o6vvS0MdXQlIQPCsc3aT67HOdlGJHw6Jfn0KrnatO79FgZfrIsHPhG2wrWrDCMrPxrDe+Ye6KpdSF6y86dtT7ia4x+4tQFLrCJxJkjDVLVuR4e3HHhGiN8T/qnCM1E/IvlAwJWzd1Km8HGc94OVKe7LFrxzAMQf9Ly4elTpmDR/4MlYrQeOo0ktLWXtyFaqn0RcKIqAFs735Ei9DwCTHRn1mAQtcc+d3x2oH+TQhE/JrX1K7U/zhElROzA6QwIPPF2DUaSWugEYGjf6GvlzRkb87NiGIkuMtISnLLRj6QHU9UVGWTTbFH4V0z7d6WkhlHk9yQZJyAYb2M1SO9sFfJHE1p5PKyAwio+SBV75+JmJM6pXO7aOefReczwV2J5A+SntIn54wqLZI/fE6+p/BaxpgR138AzWUUNiaKRLtWaTaJttcR+a2ac6E4acPn352P1tauUgyqHKEktkCRY5JH5gz3ftyrClU
 k3QiDRVd
 KjpgsO6rgNJzcy87Flfmlle4nhp7ec05ZY78cMA4SED14zLVDckcL68tv/1HuleBJ9cXvmC1fYmABzlzMi2IKYEaPezBU/WoaGPcnyWATkIVdsISO253olXmxI/Hv+ndMaluDoO0LZ+4sXL8s2fF0L46Vtfp7OWfiaSOxX9tvRPYg/b1fQ72dIlj/+FFilVnw5DClPMAEBDP564v34FuPhv/3T7evzs11EEWaApLwqJRNhkqGygd/jz9nRj5sBisMLKClnvoDGwuqYsrrz7dNLzdW2dUyxx5stCWyK+lmMfChjGwR85Ia8kIMkPdqvcg4pxOF3DPouVex1bxUeTkd4lnyZDtvp/giXSamTjqXXwMtlNWkHeB/dKd1DYzVO105CWF6kIUuRKq+FbHEMu2Hk16Jt8iqsWfw6bfc5Ay5WHT67xeeXr1bTk8wLzgdjr1SGneot16qgzcaHJTSwEA7PjLXpgZzcyujZSoupoKaWf3dR2JpdHfgjcIw2ihhNOwLnZDPHBcaD8yaSe7GxZB6H4KbTe3YRCbgF7CC+R0ksQBv39g4u3HtDcl+JW8RstIO82G5BlmWIU3syU7YsAB42EguJxJ1Ceif7SGPK35tXF8wViVTI5I88TORnqEToUUCq659VRZxtwg3/goEnMJsRmy0gqHlqlqNeUgN/LSbCv1nFxbwuIV/tthnOO6k9drwhqs5YUNpVZvc93WVgW/SyzTBk0TUtSSwmbKXaT1o+eH1kOPQsbiVFkMnIurnPgwwZep+mbaDf2i342JzccUPJVcLWTcp9EjsqcUfSS/FmSvcXx1Tls8pS5A+keBbrOBV1gp6Up1NMr5iy1jaS2sLZ9zg4O21NnN0VZN/FjAcD2tw/epCePZdKepvBrjcR8f/cPgTiQRIbUD429XmUQPigXtOeEc8xkzPRoJPLTAOpe4zHfxUs9pINrEd94ZtCEOAg4ZFCiHyb4f6KR8b/8xbf2/7IijH
 18Bl8LIp
 kQbqzMAyueQ10347UrtL7wDG6K4+0LnX0TeYHRLn9GXENiK/9D65TXsc13oSBVfrZQ21wfhLlVZYCGPnDEy9PlltjhTuqeP6F0Vlc/NcMQkr0IaYqVKuIuK4Pw5Mdd6Z+NV8ZV9u7XSbsSVqHUy21+t2cvMSbx22zOVnd1b83H1fOy4oJOLoN3ndRP667EFDjk4DdkBV8NeU3o78mAIr1xXPLewexenn53FUM2NRhJcV+6aR0a9ZC/I/i9BTYny8Nfyro32x5Max3QNgC9Olo9YB/bNSEGrU1Xu21Mul8iVQYfAI45HlnvfcpYELF/qBnUSJ74Nf1boj1FT+1yyBHHyC3gOtfYX3olGcGEqxA/ipLb2k8aj9X9wa/jBm9Jv28kgqKAdkIcIzvBRmLNRo4e9qrrbl1OOA1bEuiLhhnWu+eK21sMMeylQLGfVrmnLUDShKGXlmPCTDMiYY+c5NTlRc+W1lL/4nV5ls7QJ2bwC7ntfDFiL5WRvLukCSfoXlW92l0P7NPM18BuPPLsWOIQA89gbrQ2yTdO1rg4jvkJOMmtWKJSCnTiW/wHEZtq/73+a2y9eMzYoUI3eM9mbAFf+KC0pFY5TU0YHtaiPZF/sYhGJW5VVojnNwtoFcezO15zbQqevdjhNNxQ3mlRSFbTCfgYef4sO0FPciiMEVVIuhcBFQCUy9mZq99Mwits5ggF4v59G355YXL0sh760qAoLF4QRMTwJSCMniA/vlavhokI8lADQhSCd2DvvJhWKR5lwyZBZSC6BBHlgwppnuZtSqwq5B0rJYOU6RgLjwFkp3T5dKrUAr+Ysd2nwgsYXUQGhqKPzdUuMDNry309OgSlAlB1WfhVDYT0aHJ4ldmtoWcYAwy/voP+ZThvvq+bV9VKA1ebxAy/S2noNZffBN3+MBS6fJAc0JKdoO7emg7pt6ZO3PvQM1v+3xk3SORJxCEgLPNKhagBVD8d+i/et5nRkcklFQX
 FIpMTLek
 DHICn+uwlhLYKKKqEaQLKdbn2QDXufCcdpjSDoZagC1AWBF+fj7L7owFPfncUveb90pZaS8Z2qO3R3SUDZo2DrGFADCQOlAixEOLYPETLCQ8Ze3TXaGYp7NOSYBincXd2ooBMmSoK1NDtkm5Cbmis17fT/Gt6jbMvY1Yndg3IXULu5bIMnve/DW7iNjLxgYDFYB0ECfLft0weMvEN8M26DauERlKqpnGwKPJaIj3jwAiCQOw735suwQ+rTrV81Q3WVxHou0DbN5ktHHC21yRSkc/tWBX1ZfNnytT7mmQqiTwG6UUTCpWUYPCfvo5SZ8YJGmsFfgExDJuBT3REkC38WgZymxlaeg+V6kaAKMQkgiFqMwyrd2ChgeKsbUuiq1CUrEUjHdlr1oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-03-03 at 06:30 -0800, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 09:19:42AM -0500, Jeff Layton wrote:
> > On Tue, 2026-03-03 at 05:59 -0800, Christoph Hellwig wrote:
> > > On Tue, Mar 03, 2026 at 08:43:15AM -0500, Jeff Layton wrote:
> > > > On Tue, 2026-03-03 at 05:37 -0800, Christoph Hellwig wrote:
> > > > > On Tue, Mar 03, 2026 at 05:53:39AM -0500, Jeff Layton wrote:
> > > > > > Like I said to Ted, this is just temporary scaffolding for the =
change.
> > > > > > The PRIino macro is removed in the end. Given that, perhaps you=
 can
> > > > > > overlook the bikeshed's color in this instance?
> > > > >=20
> > > > > So why add it in the first place? =20
> > > >=20
> > > > Bisectability. The first version I did of this would have broken th=
e
> > > > ability to bisect properly across these changes. I don't love the
> > > > "churn" here either, but this should be cleanly bisectable.
> > >=20
> > > What do you need to bisect in format string changes?  Splitting
> > > every variable type change outside of the main i_ino out - sure.
> > > But bisecting that "change to u64 in ext4" really broke ext4 and
> > > not "change to u64" is not very useful.  Commits should do one
> > > well defined thing.  Adding a weird transition layer for a format
> > > thing that just gets dropped is not one well defined thing.
> >=20
> > In the middle stages of the series, you will get warnings or errors on
> > 32-bit hosts when i_ino's type doesn't match what the format string
> > expects.
> >=20
> > There are really only three options here:
> >=20
> > 1/ Do (almost) all of the changes in one giant patch
> >=20
> > 2/ Accept that the build may break during the interim stages
> >=20
> > 3/ This series: using a typedef and macro to work around the breakage
> > until the type can be changed, at the expense of some extra churn in
> > the codebase
> >=20
> > 3 seems like the lesser evil.
>=20
> No, 1 is by far the least evil.  Note that it's not really almost all,
> as all the local variables can easily and sanely be split out.  It's
> all of the format strings, and that makes sense.  The only "regressions"
> there are incorrect format strings which have good warnings and can
> be fixed easily.

Well, I've done 2 and 3 already. Why not 1? :)

It's not so much the regressions that are a problem here, but the merge
conflicts for anyone wanting to backport later patches that are near
these format changes. Having that change broken up by subsystem makes
it easier to handle that piecemeal later.

I think we'll be looking at close to a 1000 line patch that touches
nearly 200 files if go that route. Roughly:

 182 files changed, 910 insertions(+), 912 deletions(-)

There are some tracepoint changes in some of the per-subsystem patches
that will need to be split out, so the count isn't exact, but it'll be
fairly close.

Since Christian will probably end up taking this series, I'd like to
get his opinion before I respin anything.

--
Jeff Layton <jlayton@kernel.org>

