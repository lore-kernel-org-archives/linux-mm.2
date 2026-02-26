Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 143D7FD8FD9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37FA46B0171; Thu, 26 Feb 2026 11:58:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328526B0170; Thu, 26 Feb 2026 11:58:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227E66B0171; Thu, 26 Feb 2026 11:58:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1246B016E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:58:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B88A31602FE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:58:48 +0000 (UTC)
X-FDA: 84487217136.02.3FD3F9A
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id CC21920016
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:58:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b=ulkKHiYz;
	dmarc=pass (policy=quarantine) header.from=manguebit.org;
	spf=pass (imf03.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772125127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHNPvXjvxrRY/KHE3atTkGQgKEoBn4K5FRw/b5IfwZY=;
	b=znWWRKQn+K5VW/QOKprKJJ4OqHmUnHTDPMr4vCxUiRKJEx0UlyNeC9CNNsf4TTTQ72oTuh
	fZFMUvedMctkf+Vt6tRwaet7WPsp7qeXHhnuPzN7H5Os0WtqSP90Vxj19ocBYpU+2ywo6i
	yJKYchW9OrRsFUwBRmMC4zIwZn9V0rA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772125127; a=rsa-sha256;
	cv=none;
	b=WC5TQvWweWsDRvnPSYEMFdIOShVjAghMnkZQWQD1p31adgquKeqeDRYBDsNrSJ2O88qrxw
	GWUadJW5k7Hn/TuHAATanL4absYApMAmNvknR5wWD+QiZ9iFCoAIti3OGXAdmmKEwewtMs
	5HLOHfiniDo3p+FiV2XBE4FVPXPYeak=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b=ulkKHiYz;
	dmarc=pass (policy=quarantine) header.from=manguebit.org;
	spf=pass (imf03.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lHNPvXjvxrRY/KHE3atTkGQgKEoBn4K5FRw/b5IfwZY=; b=ulkKHiYzv6I+6IIa14ftoupjDe
	J6D5Nic3w9+LTbwjPerGaRkKolwfy2KcZUzYubTFBR1C6YfViQ9IzWzOqE1PMBvOSLtWvDqYWHDkS
	e8YKhk2RZVgK/kgJGqWlaX1VlOeT5XV51JNx7TY19yYOoCL9WPMfL7DEx3UWQDxjJXBn4KZXjEq/L
	QYbtmeNM6AGz7YQoWObfC/Wgr1ca8Ha69hN8dnEa+b8qtPVTc9YoU/4JL/CqWgk9ghL/akGLMqNBo
	zcPi7YHA7wTZsVYKJPKxzvhBKFb5Xcdj6osXFB4VEMUpfmqou7ST10TYaQkSCLGoa+WvRtMN6QWb5
	s7cLVI5g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vvegP-00000000rdH-33sy;
	Thu, 26 Feb 2026 13:57:49 -0300
Message-ID: <5687bdf62ddd20660394eb0d7dabb96a@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Dan Williams <dan.j.williams@intel.com>,
 Matthew Wilcox <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 David Howells <dhowells@redhat.com>, Andreas Dilger
 <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Jaegeuk Kim
 <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
 <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, Olga Kornievskaia
 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
 <tom@talpey.com>, Steve French <sfrench@samba.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>,
 Bharath SM <bharathsm@microsoft.com>, Alexander Aring
 <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Eric Van Hensbergen
 <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, Dominique
 Martinet <asmadeus@codewreck.org>, Christian Schoenebeck
 <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, Marc Dionne
 <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, Luis de
 Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, Ilya Dryomov
 <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, Jan Harkes
 <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, Nicolas Pitre <nico@fluxnic.net>,
 Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>,
 Christoph Hellwig <hch@infradead.org>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, Mikulas
 Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse
 <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp
 <shaggy@kernel.org>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg
 <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen
 <al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal
 <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, Johannes
 Thumshirn <jth@kernel.org>, John Johansen <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, Roberto
 Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin
 <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, Fan
 Wu <wufan@kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, Casey Schaufler
 <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>,
 Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Sumit Semwal
 <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de
 Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Oleg
 Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, "Darrick
 J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
 v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
 autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
 codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
 linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
 ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-hams@vger.kernel.org, linux-x25@vger.kernel.org, Jeff Layton
 <jlayton@kernel.org>
Subject: Re: [PATCH 13/61] smb: store full 64-bit uniqueid in i_ino
In-Reply-To: <20260226-iino-u64-v1-13-ccceff366db9@kernel.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-13-ccceff366db9@kernel.org>
Date: Thu, 26 Feb 2026 13:57:49 -0300
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: CC21920016
X-Stat-Signature: 6yqz7hazm7xr9kwibhmo399ipjr5k7ef
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772125126-775086
X-HE-Meta: U2FsdGVkX19hx5Tq9fJAfbYrXkndl6aoKuEIJSxze7vR3psGN6KGZz+MXYQzWfqTb6ANkOGr22th8s7NWmEMaSquLVjOUVan5AZxkMRkErIYrzmxiD2hZL5Gm784eiXWgSGkmMkDyyepxEF//O/mAW4jci+VKXCpb7bbt+k7RxAeUVayELtblu/ZWpufim98a7PeH8bRQd1jSw7zrhChdD055iL0M7LF9MeuZKRUx6jKGr7Kovy9B/6EZVEmResTEDPGW/5mLUNWZUAgw4QZ1+gI7x5k0v+Lb7as1kzf+cbo+cOgF80yufQW10yQThtzuif8XszsKowsApuwXYtPDFSwTx8Sb3fE1s41fDcBJnH4HWVmVcunnhMKBuS1KzFUnIVD6Krg/uSikSVsgSmGAgCg3LqWhEPy6SZxv+gen1eSFCyj+iprOaUlvsZV3tpt5U2p7IWSFEODBYKEGYTnFqCvnVpQ+r5klt8Jxmvm+8HP6wxtBc2uisoo0vI3HtiA71RbIb3nKfuzl6T2k67qK8pIgF+FK4VW3xu7lmNh94MDHV+4/mAbw4xE0l3piLEVf8Outva0CpdevAq69dpjziJpmggUN7qXNwhCF3f8R3LDQ9puYDV7SuafcTfjyUUZ7TgXVc/89Q9S5ZUgNKfsCqn1vIpQieEHloAZo1OHMk55Sz4CYr41ZkEbCDlNeV9EhGaF2LMfrm56FI3uom+uqalTkhlQvJKTA8agnoda66NxLY/LzSxZbNUOGPiZWm07saMe94EWYsK1r54To2LfdbMApUjWqUNSk0IcnoNNLBPXf4HSK/Bi08TPuMLtU5zWHiXDBE4SNT+hI7JSV+8Q8LDM8Iv2CoYXhIY32WkzaCbh7ftLGrnD+O4ejPzSlnFw4SdEhRP2V5Szu00L74OoyP3dDpMs3znNJHHcOOueDng49FYKxbe2gPKsguSaLoGrc8rZPmF96JM3xCrKE2m
 Xb7GxAh7
 pldacOTzVtJmlDmRmQFLk1SMhEBi9NX/4XTS7Zt436CAOMky3BNIhdPINcAxvguB5qYuUrLzolBIG8x+jIysGOQak1iFB9hkjiWyYsbkrErRMt4vvT7YTQBufTcNR/uOC9UuOHdwIKWpzs8fe3V8e0d5WrZH0BLkycp/T1P6ALPZfV/jeQwp5C6gIf5m2vMBxnPO0a8NIMGN5FlVZDFgWwL8nwiUzZTDwq4u/9VTl9C+YYp6xc9wv5Oj37G7pLFFafC0t6PJcrcqvYCaUTjzarNFgST45c0YejU2o5U2Nv7yFcq8GaNPYDKtq2WajiABnGPrkeJLp4uD+lylUndOf6/7gKlgYSSRz5xriuFA4iJuk52//CVvtTf6velg2gcpzgX68MInOR0ce9eDvYifVn9tgo6EBZmEJ3wrI5PhIVRU60DRcUcw2cAe4Wv3gHS9vx1/iYiRAusAUOqUF4Lda+2364Z2OI4RpSfzB0MjiYaN86dCScwLaiLH2twOROF5MmNomyyYtUDzrpDNl21yTrdNYkROmmtw66ufL9IjOR7mLNWfaoiCMpC3UJmQ+jpgLdehjbZK7Y37EAtV5ag2FV8BneWEE7vVsI9VssVD7CTktRkUT4y8myYHhjmOZB9YNLhHSTXRkZcsm4gxp8/eUApJhXm+nxhOvGd8Qg11u0IZx4n/R9F5UciWOssSWaDRVeY9k3heOt0SyBGRjcfxaOhTAVN6VjZjcNv2qBetulm/g/owle69c/VkZV4hENGy1MmP1O/VbCgVmQ6r284BhlodfxK5Ihsv1xpJHBrZA1/tTex6XYi5Uv1ryzE+BDwo/GqMmBuKwg1vm9YiNDLF8sFzdyYAK2/mSDbwEq44Av8wdjnveHqPmfHYVte+c4EfrbAmWoql2C5NviZcsBm5Fvyt/DjgGIiM2z1t25rII2cv03wTsSlmn2tfoV/V293K8khX0l/BZSGCBWfNTO+wuKRk0bmWJ
 08PYzFDc
 dXKk+Se206U3jVxMR6LHH/wjKEpZeXr/YUXni7PautnkEI8N7GFtclpxa8jKS0Rgf7o2HLaXC+JxpylBz0EZD47kuHwlpOMvijiIKQfZU9GZwHJP85N77+JHvv2bDsMrWLqNTsvi8UW5rxl9/wHjmEQHB99Q5snVp5zeBnLyD413Ohm4S0YmDCHiXA0Uin4A1Hvz1iBKp5xfzZhNnE0+5Xmljq2gWZaliuHTZsmvS029eZVi0bp0UwxIZbsV7p6YqOEB67HeJEkCj8Os043OlRBHLEtSPd2l0URHK68UifVEcaZEYhXc3NfH6hwcLHMIINZaPgURjg0N3Yxw1elHGwOhNdEc/eM3/EcDZaOZjQ9Mjlb2IhiYTkAHkw4oIa489ddonF72XsP3+PuncKXONnwGh7hErRPLIYvUVOmwsXcye5yDdsZYlnqcj+/jsmvH13OIdtEwp6mhUZNdCZTf/lQF3G/Yf4PJKOoH2m+A6UOJQTcofE8qRquGE44U+p9xq01K6J0/PSOkcMy9u5tmKMVuiKevMBnl/wlLSXn8CIIR8TdMsZPnnmT/dmUiyj5qPS/C5nNyRz7sKxr9OvDnSVW5NMQdp6RtEkWC8ZTv26QyS3fzNLLeRE6NzQqi7+tQPuOLecJvay5WwiHlTLtLKcVC4/bGJgES3oUKgHtkgwM538CJ94eJuAgkkLlDYkHd/6S5dIXjeaKJK+S7M9tLMZhUbuh+NMFSQCEJ8wH/xGF8+JGnXJac21Efhcz2CFGvM048X+yMPsR0d2raJvVG8AuA0wM1dfICjCIK3NsRrqEaEsSn6sh0WQ0pPwJDk6HisPC/adrwYdBcDWvdyeFcfHLvQ7RCJkNnvjO07xwyPrPWCC9/wLZpZQUSPc3z36JQwL3/HyGtylL1P1eBuQmbWqI4BVZ6zjFg8evP5Xybhbm+Ipa/W2riiT+YR0lRjJoT9stFFqrTyXRAk/b2+M+SxY3PxQKHl
 TPmu73IX
 fltb06qGFFfHMxsfesr3T6U525KFf94u+1a9qml+1WnYwEtbm4VXXmVAxmG13p+H5L00sNtJTMXwAN0u5Bb5FlxpKYc7YlgoteZu67Gce1AMavt2P7z6XFYprIyFuwIgL3adRvcaIRK4HQAhhjNXDIB3Ze8YDnCV6dn9xsRA+ddUkXHBkZz2vPwyXqcUAswisP/umh64Qo8EfHECgbYD4gqQmYiTu3KJ6NV6cNGp9uqWGvRcZQOsns2WGQGoR/WzuCb60B4yBU/c5rsthGzfSM6/qWW/x/++mcz3Zerp5VSlJjjtNPG46eJ/3NYglB55Ac0hQeGDrjd/vPF7cxXzcP4OrCIC1W9RASdyyv3WZnmwAKP6DbUCj/jrCbftRiwZ1hLgfuvn3Y+Ohule2Xk3KhGttkZQrLIVNHtxlTnnXDYw/2nKNFpiP5i0LlPaHHvQqe+x5KGGFKhpleLGH4stBZQR3JMlgeXO/10UJlwpy/eG6e71DIkVmRz7iaDJxk3SgjvW+qs7No9UuMI/zl+rvaTSYpLTK4rPqNK2I94Sm6GohJAL9NUjA3PY2HZik1f90UPqoBM+XMacGxnoLZLDvOeyoGVHsBD9fd0b6R3vpC7SOBnRJtqzx74dr60IR3U9ufUpWDz9NalLxuuxBUu3AFdgHUvucU9kFe8xbX6tcC0aFA1GxUpzG2mfroZApraJZNg5kINxA/1b0BvlByizYt7/baJeB0kHc6d7QEa+CLZf8sEq/4VS+75uOurcIg1NxdlhI2oOoymASiN4TZPML0GNUcbdOnc238UqdmWClWcXXWe8OwYKgMJF6Z34xzK6SJPs5z99GK1ktmt7R0nkMzQLzSla8Xam+qT3kEWpuS6Fe5MGqOw2nG1wmblFJDD7Dofseyeg9DQJuv4PDPEyp5IXgIMryeN/mqgrI8E+1DoDrJJnTToFYo7ZrstZJnidu582kIggcZoDB9N+ugw0c92Ih0Muv
 oeRQoKmW
 isbMim+lRu9rW4rknY8sF3EH6LnnUBr4ml9oPdn++yj7bZWITUPq21G/OPXIWLhxPphtO/w1sd+gJq612uYCznWZMo3BUlJqPMDkDLX8RbnJzLqlNEsyBGqwxpd653GWzAIUFIp+LsvM79kc39u/2NRIZAnUUr/5rxCXPKqL5OV7BAer70GGS9wZ1R2LKGOhxVqNWCXd/p3rANj/kBmoHM3+vF7ka5LyzOi1CryD9ImxAjtB7RlGjRlxtHEmEoV0m9QoHbCXW0WF1oLlKzBFAP0uyg2y5nr/VtWK54R/n7ASxzHvB2NgP7TOZQbdBy6AWgX8d0f6k8VWEDIUukfFL5MqPAKR+Ai/EW75ZDbeU3Rtx7wOQN8B2JH8AoaTksObLwjstwtRd1injZFIu1Nb4FUjmMTt8D4NtDgDGneZUMA34ZeXyNBkrS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeff Layton <jlayton@kernel.org> writes:

> With i_ino now u64, CIFS/SMB can store the full 64-bit uniqueid in
> i_ino without the XOR-folding hack previously needed on 32-bit
> architectures.
>
> - Simplify cifs_uniqueid_to_ino_t() to return u64 directly
> - Update hash variable type in cifs_get_inode_info()
> - Update format strings from %lu to %llu
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/smb/client/cifsfs.h | 12 +++---------
>  fs/smb/client/inode.c  |  4 ++--
>  2 files changed, 5 insertions(+), 11 deletions(-)

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

