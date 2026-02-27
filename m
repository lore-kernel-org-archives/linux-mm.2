Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E03CFFD7F93
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215226B00C4; Fri, 27 Feb 2026 14:35:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1957E6B00C5; Fri, 27 Feb 2026 14:35:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0057C6B00C6; Fri, 27 Feb 2026 14:35:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB9AA6B00C4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:35:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A028759BD5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:35:25 +0000 (UTC)
X-FDA: 84491240610.01.620C22D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DAC7014000C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:35:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HAkmYX5x;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKpm7qqgE7tBymAsIP5/pPRqd9KlkLRNY8d74mbVADU=;
	b=Fp1gwofGdoVZJD89wltys/fvjm+PNJO19nVIOfHd/Q55VIK/AYU0yw5ol6pi+ZRaoYZUBV
	jUfoQgS54KWm1R8bv1AhhfcsocGH+TGNZ8nha433/KfFgljVV3vCkQiqv8Wid7p7OrYhKF
	zMpnWpxIke3vaUCH6ISPQv3t0+I7W0o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HAkmYX5x;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220923; a=rsa-sha256;
	cv=none;
	b=2O+1x9HMBAFG7Xltcl3UAwYIYsYIhDFTlLnygQ5ZRzWbcwW/zp7pDlrKtzzXCKhEEAzkUK
	PTtOUdPvetJ7SYAwmtC6qaPfraCMvD66sFYXCILXA2gkC04nmekHk9P5iZyg5RHSPlnI/N
	NA0wmloeQudx5qnarOJ+rXeEO024+WY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F2CC60133;
	Fri, 27 Feb 2026 19:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA034C116C6;
	Fri, 27 Feb 2026 19:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220921;
	bh=x8aY1qdgt0C9tMQnJs5wAf8ATVjxdYsE22ORECBTQj8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=HAkmYX5xTgBJmIGTCpFCAMumPV3f8DHhz01MTU4lrlW/PYE/DFJ+TEip9CuHfwFXg
	 wnHRz8ZTqfNRIPcBsUq9VTxyJWqdA9nlRsXGMvIckPT60T4/pSY8VCbkQMz+sjJhK+
	 mWfZVqS3uf9mDqmTL7J0s+SnfU2wnKlWt403NJJww5ajMnIEf3ZfUnrEEWVuZszNa0
	 rG/7QKHn/vcdJlevA3dXj9ATPEG3uYHz4fBjrOh4zYSYsTphR2iVHIcDM/v7NujRPN
	 TIXwMfR/DPbY7XmlodpNk5WbW8qaLWuk8MmV9nxkf+H4qvlNLD1pukmeB+4AMz907b
	 WqDtYisysW8PA==
Message-ID: <1b38afe8ff4ba5880835d919c42e094d77a9d5ce.camel@kernel.org>
Subject: Re: [PATCH 00/61] vfs: change inode->i_ino from unsigned long to u64
From: Jeff Layton <jlayton@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Matthew Wilcox
	 <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner	
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt	
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Dan Williams
	 <dan.j.williams@intel.com>, Eric Biggers <ebiggers@kernel.org>, "Theodore
 Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>,  David Hildenbrand	 <david@kernel.org>, David
 Howells <dhowells@redhat.com>, Paulo Alcantara	 <pc@manguebit.org>, Andreas
 Dilger <adilger.kernel@dilger.ca>, Jan Kara	 <jack@suse.com>, Jaegeuk Kim
 <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,  Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
 <chuck.lever@oracle.com>,  NeilBrown <neil@brown.name>, Olga Kornievskaia
 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,  Tom Talpey
 <tom@talpey.com>, Steve French <sfrench@samba.org>, Ronnie Sahlberg
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
 Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
 Christoph Hellwig	 <hch@infradead.org>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>,  Yangtao Li <frank.li@vivo.com>, Mikulas
 Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse	
 <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp	
 <shaggy@kernel.org>, Konstantin Komarov	
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
 <adrian.hunter@intel.com>,  James Clark <james.clark@linaro.org>, "Darrick
 J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
 autofs@vger.kernel.org, 	ceph-devel@vger.kernel.org,
 codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org, 
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, 
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 devel@lists.orangefs.org, 	linux-unionfs@vger.kernel.org,
 apparmor@lists.ubuntu.com, 	linux-security-module@vger.kernel.org,
 linux-integrity@vger.kernel.org, 	selinux@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, 	dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, 	linaro-mm-sig@lists.linaro.org,
 netdev@vger.kernel.org, 	linux-perf-users@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, 	linux-xfs@vger.kernel.org,
 linux-hams@vger.kernel.org, linux-x25@vger.kernel.org
Date: Fri, 27 Feb 2026 14:35:07 -0500
In-Reply-To: <b808e186-3eeb-46ed-9826-b0ae6cdcdb8b@efficios.com>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
	 <aaB5lgKd8FOIizPg@casper.infradead.org>
	 <4a462d40899698586c110add96ce3fab6ddac30b.camel@kernel.org>
	 <b808e186-3eeb-46ed-9826-b0ae6cdcdb8b@efficios.com>
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
X-Stat-Signature: xybx41mawfai9de45mptm6h6nxogno35
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: DAC7014000C
X-HE-Tag: 1772220923-358620
X-HE-Meta: U2FsdGVkX18LTXjFHDCODTozhpix+X0GOovPFWMfBM5wkK4IV4ulYbverGssyCBtNGrsewHsv1Qhwg1fW1K6nbHmsU/qY3ZPejVQeioEIQhEd06oEuG48yyygbnvfmEWjlUMe1PdrmuwBkZ2xDVmFnnyWb4cxsYSZQsVY1QgOUkguLZKsSASrHhXN+7fP7cqhqulRTq2PrVbngSK8617xNIgXeTKKztasHj/0snhW5d62g6iPuFn8wDmKo5Ka2hhBtDcLoBT+6WZaJ1PFMHN47OhJ2Wghhei864mRLjd0XASRF3lwZyvtVhqIrum7dIIVNS+Xo9mgNFv2i4klMl07yurdQsqanNWexWRYvmwDnRsDVrS+QtpGaXW7LeyYSFsVffjTCU5lu02TMiqPPGQDIgHVh+cPWMXkzjamp3CnYikMaeo6BG67R6TRUkHzAGD5zpa177cbBIy8ACECmNyRhy+EzH90Odo/jvPBjjxFJ+l3NLRmml+LCcJrmytaxEGXVmU4jGuH32vb23sA8C1SgQNitGZRZ9nLxIs8SFvgsgt9Ppz316wngLjiqnELhYDcYQ6qvyXie5McyZ4eF8easfUTUOI/99J2RqPiQ5LrdxlGSgm7bSTPveDu2jlkaHmqvLzqXqc01Ej/WhkiS+cYqIuEZdjS3qVz/rhHWegqDYAsA1j3kgbPLh2leY4c9WrtpUrlslI7PdFkx6xK4JSL7KcyaPbyCSMf3Fi4kG/Ec6Pqhl1NfHV1x2kz4FixgW9cLof0o0vWcTeb8wfSXshPaVgEny+xa4OiFS3c2oJtcgv3PUBHVGaBPsxAj+p5BJfgECN/sGHPTXeGvL/IY/sMvC/hEWAgfztE32lN8ID2hzZX7JuWXcplwypfu9sSWGS2KUG/NT3tTc88UFHfuZxlXVCzA4jTOpynuweBP48BlJpyCDi13DGGqgaLK60BXgj20u5PGtrQBN48/DFOk6
 2oZmok/n
 Pki4ZjPs6k3dPY7URsNA/zyZa67MvTfNbWnKkfeVcx3cwCHePaK3aD1gD09u+wtTAI9U9KdebirV0wPRGMx05kHR95xpRf95ZGmG8meY8ohBC55Oy6vmizg8/QviuHS3GL2vhyZ9YLoifhTUG72JrducrnKwGu+8gM6DnDjWN4/g36ly/rL0D4pwEgQ7eCuWOUuKMEtA+0XaYgfkUyd7e1lG9pwR2PtmRYWrdLBjhwfCLs1wT2fX+KyNXtPN12JjsVwot0GsGcb6rEFSKcseTZDCkyGKofsuuuIjHb3HD3Xu0lgKyqnV2WNnDy5FqBZ4tzGzfl4H5L7nUgowhheDVLW7prgPbIPd0sihGWjI0KKOyYjfcc5Z2VuvNkQ48jMuV7q7R+es93LR71b2rDEzOplRPwVXpFC9QVKonekxD2EAROf/4WDY6bL6kTfBxK7Cdv8KCHS0sd4N/KsJjMuy7tzOIuL0JHoeJrFG4KlSqNzsdXyTw6MfUmeZ7x8nEoAXrTajmCPfTdRrzYkIVUiiKEvSOfY4W1cFscbpqiZ+1EQHrJSBgnEDT9U3mI33DO6r23YdNsN9v7wylhTfLo+MnWK54lzEAbuISdVZlWMiZ6QCrefSaRDfpIx2erSrOd0dykc+12FQ5cPZY6oOmfaVps3GVEI6JzidEbGHvE7wuraPF9nk6ZV0wyTFuI1SgVbhLD2yIn2YXrTy1XxPmvD+djvo80u5ldpDwE8ZeETymSYQGHpivsmdQTyAYCENMdLmjWKcKeq2o/ahtLAooiUDAOF/qF6E51MSxnXku+x/hgUiPeRh/dvqNPvdrG2Xsa2taLXfiTEF7vtwXj6ql6v/NamZQ3bDphvdAfEBq7ttisgaZ01XbbZBc65CSXZKhwPKEay2Jaiw7LdjY6Wkjod/qSfAUVg7+I+JL40wF8O2eHMIY21MWsUA8aoXHx/wWOeV0EklmGdu/LODB5eDuHkqTQGtcEBUv
 hPUORDBK
 vuikNZQ8Bn/AED3QsTew6bPZGMbTV5bfqKyVen1EtgxvWV2tFTFtxjOj7Os3YSGKY4dgGte71MUDV/ConoBFlL3p2PyH0lsOox89uPiUqtbWi0UqpbcV6vgN1wh7TR6medxZz86JvrYaxL1UaifTFxPLsUxMe4Yr+pzAjUt3TtKKggv7iD3ZaDhJEXbZYpBv22CvV46sIz4rlHc+Auv3QFWSuLgE5djRhptGP9HGmp5yP3bxOgCDOimcl90jLjQqWdxV8Xo9B01FTB2B9nWR/hYZWQKOU/yLF/Kv9hlw227ug3Aa4cO/A/8PwjN82rlR/JRLPJxUFngdqm8aICPbuc7ynUNRED9Wlozr5dzJOdVfG+xh+dRMajuUUdVg6n54pCex8Y+5CDZM8U/NqqlKKfTuoAke3VoEZf7pU7fygu7xios8U6i1a2qW6AZJbXc1MOEAqgsLACLJ4YEdfEPHFx6hATdliR9ObGNmbfEOddwNNtWhOaCa5H+C+pljr7+o0mTFo9nN2G5dE41hhZBkEa2J63UUfIU8J4PU2rzzqnQ1a1Lwk5tYbUI3aa3BPxbELS+8q9T63rEGhwwQli4azYaKvtyntYlTYkF4h6NQKZR0BhUfUzxD58T1KoIL7yMNsnkW1p0wzpFfUebGs695/Iym3IQT3pbPnUrC7SA0Jrc2V/cKITP90v9KsF/JRXwbdjkq8nM/JWsmr475gExwIWZpmO1RaY0Yrcq0eGoTIFUejzvmlXqSZDoGdBcAIK01BPbQOoKT69Z72sy0mS5OL1/+SoARIp7FxwRdTAJuU9VshJ7/za0OmJD/9fdI9PyWTSzindxQVKhxZyE3U02GA7nNtom+zW5EVQrOXTyFXj2CZbnyH3MSVCAVvKfwLC2FVwNQRId/JY1MuclxShXQdD1UcQwHNeekDWcUijrXw3Mr3Z7BZwb160buuKDSvTTPzTeufrQoXO9fYxCQXCCqZ+selQ8bR
 9pzyEsw1
 jczs6VEMV1o9e7PpTYKVYNPQnJrRWQbgU1sXZJfYqxYcvxa2SXnsnrmN6EHNE9QDHz8/UrpPGps/yWzhjDzsF9w96FZSuRENRTJ68r9qNccM7T0gy+ed5NXb/+h++syIJUp8ZO8LvKICX2FkjbcxK/WGoLLE8kJqLh6C8qWcVs5wZBybyWuK5ZOpeIJHDyGReTY86gtaLSayFUcYPMUAgGm7NWXa2r0f+w0DjEt+a/OF3hV7lTeddfi+/235Df3NArhX8bHSQqqD6yK4/hS9emEcpgBr8Yy05KGPeLUejk9HvK1+aVzKRdCSDVeKGctmA/5RpwcElfLRFl/d2X0KlUswSqBkhFAHILQ6KrtbzrQhfVxtILYekL1bf2CE1SpNshc2gVKSAA77K9naaNuCHRWs9dkl2LoOdbk+foMMCJyUZid1B3fa1dxSKeyHz8cyr8keUkxNQ3jni8Na0Ks0jLsfE+s16/a4VjZICyJsyP/xQHUw+2JjQi2j5271/X+e5Yu3PDT2+gMfUI33OKeaKSxGyapgKDDtj8mqWXjIr2VZNGaQWDC2YbowuQE4uS/Z2ttIOC944Lw1lgqY4rdpuvJA/HGkw1YF1CgXOAE8IvICtoXquVNeAPoQBpae0e42iJibmHVFI1fjPLIsdm9M4EulgNOJNvnsidZlVhx3mLsl4+8X2Zb0la9rEqinln9+U/QdUiWyEVCyMw3l3rbCgDchA76IcmrD5ZPcFO3tOwhQl+BEjK+aLZ/TBgZxxQyoO2UedM2V1tUJFXptFo3zicdG0TV+37jDBJLpQTvvYds24P/BkYIaFJAxZkCFLC4/oRa90BHumEbHScbWK0ZB5i3xyMr76PIZ7wogwrJ2ihYiqMAl7021O4Fguydsss8138VcWJ/a+FnT8nkXhq2Gxaz1Fdb1bm4Wv+z8zo3sHYmhefrbVB7+ZtsNuwMG8JQyTRvIDZaTRLc7jcAUToIh900s1jr0/
 9TLQ2nQI
 QvQZAtv9DdXzpWAFbYOUr/hy3eEpwcBEyW/tNEXVQrk6/l1ejoylepPyKaER8Bl7InFpgqLaHeY8ham1X90U2qSlliCMu+yBCsvYRNhGJ6wOX4i58X4MuV57R2nPIxIM/UP7gssPMCNPFqkTASyZFIogdAf3fGzzhSDEj2z2HFN34dLqa/lHoJgqMUrdGea2Uc8ffxunA8Y5XapYUXADJ++9zBAQYF8CTflsGKIi+RjTUge9iBL401pTEDkdg6jIWJ9Z40SCGSN6XCTZqs2VnGozRxkfJy+NYOXi3RAmf9g+UwoiIwUTOZXzEWaPqdmE+3a4xN745ulpsfGIvehN8kuUa4Wv5Tp04jvY2db9fg81V2QqtjJq2Tb3tZ8Q+da/ILH6j4RRsNwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-02-27 at 14:01 -0500, Mathieu Desnoyers wrote:
> On 2026-02-27 12:19, Jeff Layton wrote:
> > On Thu, 2026-02-26 at 16:49 +0000, Matthew Wilcox wrote:
> > > On Thu, Feb 26, 2026 at 10:55:02AM -0500, Jeff Layton wrote:
> > > > The bulk of the changes are to format strings and tracepoints, sinc=
e the
> > > > kernel itself doesn't care that much about the i_ino field. The fir=
st
> > > > patch changes some vfs function arguments, so check that one out
> > > > carefully.
> > >=20
> > > Why are the format strings all done as separate patches?  Don't we ge=
t
> > > bisection hazards by splitting it apart this way?
> >=20
> > Circling back to this...
> >=20
> > I have a v2 series (~107 patches) that I'm testing now that does this
> > more bisectably with the typedef and macro scaffolding that Mathieu
> > suggested. I'll probably send it early next week.
> >=20
> > I had done it this way originally since I figured it was best to break
> > this up by subsystem. Should I continue with this series as a set of
> > patches broken up this way, or is it preferable to combine the pile of
> > format changes into fewer patches?
>=20
> Here is the approach I would recommend to maximize signal over noise
> for the follow up email thread discussions:
>=20
> Now that your series is bisectable, you could post a [RFC PATCH v2]
> series with the following:
>=20
> - Patch 00 introduces the series, points to your git branch implementing
>    the whole series,
> - The first few patches introduce the new type (kino_t) and macro to
>    do the format string transition. Initially kino_t would typedef to
>    unsigned long (no changes).
> - Followed by patches implementing the type + format string changes for
>    a few key subsystems.
> - The final patch would change kino_t and the format string macro to
>    64-bit integers.
>=20

That's pretty much the approach the set I have takes. The current set
is here:

    https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/log/?=
h=3Diino-u64

My question was more about whether I should batch some of the changes
together. My inclination is that doing it in small, incremental patches
is a good thing, but I figured I'd ask before I spam everyone with a
100+ patch series.

> Once everyone agree on those core changes, you could proceed to post
> patches that change additional subsystems in a subsequent round.
>=20
> One more comment: have you tried using Coccinelle to do this kind of
> semantic code change ?

I've use coccinelle before for this sort of change, but my skills with
it are pretty primitive. The problem I saw with using it here is that
the main set of changes involved format strings, and that didn't look
straightforward to do with coccinelle. The LLM seems to have sorted it
out with no trouble though.

On a related note, has anyone has taught an LLM how to use Coccinelle.
I wonder if it might give it a better tool for its toolbox, since
Claude at least seems to mostly use bash, perl or python to make
changes across the tree.
--=20
Jeff Layton <jlayton@kernel.org>

