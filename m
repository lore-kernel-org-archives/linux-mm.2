Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3147DFD5332
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 10:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 565026B0005; Fri, 27 Feb 2026 05:07:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512B26B0088; Fri, 27 Feb 2026 05:07:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC2C6B0089; Fri, 27 Feb 2026 05:07:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2470A6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:07:14 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8B37C21C7
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:07:13 +0000 (UTC)
X-FDA: 84489808746.15.413E3DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1FDC280013
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:07:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LELv1nLz;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772186832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTWBGiJNHjNg97ed84EWtjfBVc/kjFMz6xplS+Cxe6o=;
	b=QyxFJoso6WAA2cmjap1ajvjkfvZ9VuIBmOctlgMiVE2vrU6HX5bQ3iWS2ZRz2bRkdTeGqD
	KtnMI1IBuZVIVA22zPZxb+x+j+dUuWzGmlkFLS5WQWisuL8Qr7G7A9ABCU24jXqm31hBqm
	X5CvtHeC6AYDImjvSNAKRMxklQ24EqQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772186832; a=rsa-sha256;
	cv=none;
	b=QGGlLcTTunozH/1OU0XaEhIT8Ho90LTN/Uo3Zze4d8NYgr9LTko5/mXPvoTJGPork9Zckn
	ZhIAwMoxsKD/t9aZ58qdo6Xmw8djFoSrEiGV1GM8cOf6yYw0+YaPbW3kzRrnDXB4ozChFX
	ZmxbN5Ndvfgqbd6jHxhWwDNaDW1m28M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LELv1nLz;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A53574092D;
	Fri, 27 Feb 2026 10:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9A2C116C6;
	Fri, 27 Feb 2026 10:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772186830;
	bh=Mp1JXSTiLvThOX9+iafDoJIcaXcdqjP2+vG+mtpInGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LELv1nLziJIInpPEfBGwhAV2gMFZg12s7lFE0KxfTQldEo18NluQr9e3C+Zct+lyZ
	 drhXLzadFmCAbIbeq3bsgUtgfAnwVSB9B/lX0VpyOvlAJ9ihOIftg2vbjxkn/BO8qX
	 uVjQZAzhR6+W+W0J8fzC9LGfhszCyPHqWUyfeWWQk54n5K8J2+Lq3RSoWH238qvmja
	 zUj111yecfmSqu9Gzo21TEY0Dy7GefpBTvyuB7b0hFZ8/UWmvbKQ/1AsQMoZt7sN+P
	 SMQhFN/3rME7rBp2YRNdOAUhubk/iwSO58hKw1S3dlOGtmn8p+ue+G/QetiQW6CaQr
	 Vs7VZ81sfYPdg==
Date: Fri, 27 Feb 2026 11:06:39 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams <dan.j.williams@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, 
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
	Christoph Hellwig <hch@infradead.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Yangtao Li <frank.li@vivo.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
	Dave Kleikamp <shaggy@kernel.org>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
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
	"Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-nilfs@vger.kernel.org, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, 
	autofs@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, 
	ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org
Subject: Re: [PATCH 00/61] vfs: change inode->i_ino from unsigned long to u64
Message-ID: <20260227-herab-wolken-c52d560f40d5@brauner>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1FDC280013
X-Stat-Signature: 76uxzq8u8bo75s3mac5jmrob99au3zgu
X-Rspam-User: 
X-HE-Tag: 1772186831-739887
X-HE-Meta: U2FsdGVkX1++MQJrg7SshOu4Og2opBarZfwL+0D+Mwybvmom0YyiJVQNxHyEK0OrhwW9f2YA0LlnMEXXdtmGYpZ9iM3vnjQ8041UTeAiLyuqp0fjo9Sw/2LjyVh1uEdlh/7zE/zFTC4oA7+j0hDLn8hs8lOmbCsdxr1Od8fvMqB3e0SzW/5vPf1EPnc90EVb2bj3JxA2jKNQNWA5Cju9RRT4kmWu9yTxVvrv9L7qu7jK28Z3pIO2bvJC74cS3G79wd7LBTq/d4KERsWNseErDz8IqIvGIMgNQo6EoXpPkAmAqMU3JUYUXD0RzrOYQJ8Q7k/J/2fCJb2dhp3WRLPbTYEzDw0VOj5tKVM5ofbi+uyiGXnPV92+z9+8g1H7BMMpoX4bCo4DCMQPakq0i3PmWbfLYmfPxBsUAX8yVSkHEhF2/FsSfNwVLRmCsoB2BG6teCDxLKdWJFq3jR52Lg8nWxQkfaMTenNsbE4MLMZe9fc+MpG4Fep05+fvpDJD45qlZmvbjd6HUbx+nX7wDWWFC6vQCf6KvL9saQLD9rWz0UiXsc+oMgd5RuSlN3EZrYLdOuHiCPA3EZKCqLQZNN4iAQ4fRSO7Q6kyKaAvHqKhiVmn55MZ7qwZp30qfO10iyqfxYWvQq8a0sQf/3BqtlBss3eEo6iE5W0ONYVcDb+58kaJ7f6yZqisAOZRIF0ZiSIC2fVpZezOkzk0iFeSjerxLYLB7hkP8c2cU6NsSoiBiOv0WDr5ky0YXz4niEuUfWhNYKRkwUIl+RykHKrLsKXv4uTiblJidcn//3+M9ADpCqWvMjHgjV64taEB2lGhVteLLRP74ENHogE3TLH5ghZvhUYzBj2IJvQSfRQsPaByg+29+Ymc2TpwhLyXFU1AtaxtcZjad/k4Xrjh+tlFmMCmkb39KjwlUGZZhdKtt9g75oq3T2V0uJV2PQ4SzT6mUyqjlvJI21jaAc9ylkfTWH8
 y4k5V9yu
 l88CfEsonH1UJcz8wAM/gwAC9WICaobLP8Kyh68N4tEXF5cSnH/041/9pAby1LO8Yo+PgQcJw9gxFACcKLjFtEOeb7jdnL0pDRujk9U12ku8Rz4Kk3B3qMyv4pJyw83UZdEuoJmps4R9awyjoF2dAobNdOt4XSwaOGrN/VnmOAXzYJp3H1LcxL/TLk9bt49h2Q7Qy/ijCvqXMvq6Uyper2Gh2uYiWYuinYurkccuvokjdS/WGRFc6FYHe5mR7l3MKencfeSb4E2HEYosc32kb8yalo9lFfIz5pnoYop7wbYgSG/PD3TrGLKTZ+RLxSVd38g79/sazYQl9jJO+5Bzu6/W+F24UWqAFnUgK8KUJbRjjJtFX6Uxu0ittLd4+ISLYdMyrBwYt82QFcsxXGujqrONtGYN1mp8+jJyV3jYZE8rm7bY/0tdGGCEUWXn5l54Zo0WejZGKCYJjxfyXsum96t97E4fJLu3Vr++aBG7NKHl0M5UgD86mq0qF39EMYEfi1Afhn4TKK807gDSjxPGxpxxYzlslqFE45G2Nxzclp/TKRBInInIGCoE622lbz8Tdc5AcvhU3Xeg3i4QVhlWBQPppz4yAFBF4qQS/2QSJwCEwIPu1qJHjv+VYIY8EdJbS7G7DVV5x+xifkuwqoPcTbzlshIYqmS4aIDw+lLeJ1GIXk/aaTRP3PxKu7KRPtst3x5JVE7u1rf/X12OPUyJkYA2XuKycBMqKHBCla0HqnM2TFaTAldx+2KEdu3KUPPgOoKYeXa4q4P8owBJhE7TQJHdiAXWj4F7r6diECtYzDF7QKHiQAhM80VIOl8OV8+YN8jWsHN9PdXkakoOgvrwKCpyH2/iLdVFC3+YrC1snrnde43zXypMudRCJ3tqtPElFyocZSTcHMikkICHa8Wldbe+b6xgEGX7E9yRyBVFtig5qKlVtdLNTsIarv+ecRZB9qjs3y5O7ZnQQ0ulZfGQ6TGCjdowW
 S/+X/onl
 2Oap9v4JH6kLri+m6O9UVVrn2+Zv33BYV3TPbtzPHXe5oU/wH0kgmsLSG5rd1zaQe3koMM+tTvj4Zo/qYhwj/dYPEDXBP/Uo3PEL8Ip8w/8uW5O7pR0rj44+dPwC+B0haH4mTiXLKH+sdwC/8EGofDb/GDmvfzUcQghSGojU6SEetXoDnWruOI2hrhL89I7MDhRAswQ2KyaSE1mci/3SD8ZpW4swT6ko+oZdu65IbZnQRGPwFhkdP8ShSxiKOO71h2tCjYu+1HEtbqET6etBHfbYl0M6Z2JYdl2CqFbxlDodPdrK/C+tGIJOPIxH8ogDnddYgsgeVUXLxzAWCedUzbT9bKVWFBUUJKUqU9fNduz9rCRDaT1k/7Kw8QEX/xw8dJC4UZMku26i2+BucF4v7GmT064Y7vXjGn6DITUAJ6tuKFzAvGMjEZwVNd1T7Oo4kx1bqSC715fXAxWSd2d0R9xSzcIVNmb/PzHr/7LB00Pv0a66C7iS/edmZDwEZBjIdmg80Yzg7KosqF56lI5zaUVWw+Q8yYbQ+WcbNGLWFl0t57DmJ36teP2lyZXVX8h+rvgtoMtSRfhZjNNwx9QnANwJ34PjsIpk6h08zGX4WS5Qr0IJZH6yCeGxb0pwxfzQ0epZ4gjoneOF2hKeJ3bNhWXNjgQjpTkvJyCzGIlnxfQdULtoOVdtgH3vcFfBYYe7V0yNF1Ou1GevlJHA+PttUSSgkA8aa+6lIm8N2CN0tr38Y0ZT3VJhFvS41lm4wqO39yUqvAv+xv/ClCTgtKvtmF/FD5QzbPja8YPP/34UCHrXO97PhhbuBGx/cFpzw6l5Y9GgApqKBB50vb5cC69SL9xKetW5ThIvJwe0BW+25HtrP6uB+N4hqi8Oarfc2EnidrepaJcBtf8nGYKxkUH1KL9v5iBzEhYHnHkz7zjvkRfK/nR24BMPO+/dcQqW5m+IB/en2LJeZm9SQjkKunkPkuUVr7Zea
 V0YtDxD9
 5u7WhicUECzJyqriovPSyq3KmrlWWfeZhRGgOU4WrxBz6+MZ5TtRL6qwwZmsleDNH+7FbkT5w2y2eiDEiEEnrKd8CpsZoYvnNqteN58dtcN9DPb7M/9By/AspVwbMPvRqb+t+B3mbpXTsawZPstXnfhKftS3O4jxGG4HZUMk6nIZCpBBXKnH+sykKue+YLfR7w26kII2xqBeze8qm0LK+7uRVENZmB2tOXNJZU+aGPKtFkZ23J8//fED5WTAOOvV3RSwv1pB2jjHsNHtKNOBAlQh0mTRRZC7aMlW1v20o7iM06TS47rj/3wtoCIALLo/utLmcv/MhDgi1+6qHzKcc2JUgWJvQSFKrFgbbTafAuQ1kmHmdY0KoRtBB6hquba/33z+SspFrgDBFfuNBgl3jUUbd8lhF1X/BVfwDhcqKXsyd5vBGZFrfxevXT93id+H4nn/Tpa4d7z7cGPI1rp7slKmkpWCx65OamHukEyCXOiyb/7LzkXcLwgTBgGbfiqEgPAc6RV9Mpnv0u6/PxTzCa3eQp88QswfDy/6kibSDfW6ntZDRW8tW3Gy6AbmNWXPCvFl4W7v0ohfFiYmHF0HQhZg1aC9p9SQFMNUkYdiwC8jIFS7lcz9NHYZTJWLTTPJNvFfyZy22TSwe8MpD223HO6wc+ZAOmlRQ99drp3qJYVCABbZ0EfWpKT6kKmdNgpeu/TMQLn9iUBmu5AQCTNj0wPY5zId9KYmSMMrhTvKjAecwAfttSTCRAKtyf812KfSi3uhy6jSTabmL27XYddr18bWA9t1Zq9Ny4ZAYvUFs8cekQQizustpE3O3bgwtZonwoE1nw0kqJ03Id+SP27NU+zH2/KTUbD2/t96C7gtkUqkgcmjpf3HYnDmIiEkWF/BF4yrI8Wv8pDInhYn1ylRnnHZKKrr9SLJcChvcDpm26gaSd4tHZBUXZBbhNbYVSKYyO5pTIAYcruu/vg3goo7HO5rtiiNX
 POBxjVCB
 BlRZQlOAG8c71iWVaOrDcvGKsXdSsa+gZnfT7kNWUND+xYW9pfyZHhg2QDcW2dTSi2rDa+wMDYzu1R8kBaRHJarmZOHHqqAgcu5lYlXmv5ld8jwQQkuh4zyR9wLNz+dfW5EG/Vy2Gjfrjv/lHkxwHNdzAjbVjOpOoU22PgQMzpT0MyM+98ExMNs0bDQ2uJbJPu5T9dTTJSlgy6uxnVxVaixrupeoaIfUjZxm4GfjLrac3mhcrQlU7QN84ZqCZHuOyMaWRqBYoEyUuYrXV76IJ2UEs9kJBPXhhOBhmcsqg9zegXcWiyweJapeuwHE6yjkZBWmZFpx5c0+Sd3G8RZOXNPV8UmgAeDhUJDeP3wYnuSiJNSwALE2HSsYodscEhlUbD1DrvlIHur2aPJ81ltmGfFjd0PpUm/KtwXy9/0rw2rQr8WkqnqqgdIoxdbgsQEbGama+RDi/N94d7wlcGSxC0a7hGsXytCp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 10:55:02AM -0500, Jeff Layton wrote:
> Christian said [1] to "just do it" when I proposed this, so here we are!
> 
> For historical reasons, the inode->i_ino field is an unsigned long,
> which means that it's 32 bits on 32 bit architectures. This has caused a
> number of filesystems to implement hacks to hash a 64-bit identifier
> into a 32-bit field, and deprives us of a universal identifier field for
> an inode.
> 
> This patchset changes the inode->i_ino field from an unsigned long to a
> u64. This shouldn't make any material difference on 64-bit hosts, but
> 32-bit hosts will see struct inode grow by at least 4 bytes. This could
> have effects on slabcache sizes and field alignment.
> 
> The bulk of the changes are to format strings and tracepoints, since the
> kernel itself doesn't care that much about the i_ino field. The first
> patch changes some vfs function arguments, so check that one out
> carefully.
> 
> With this change, we may be able to shrink some inode structures. For
> instance, struct nfs_inode has a fileid field that holds the 64-bit
> inode number. With this set of changes, that field could be eliminated.
> I'd rather leave that sort of cleanups for later just to keep this
> simple.
> 
> Much of this set was generated by LLM, but I attributed it to myself
> since I consider this to be in the "menial tasks" category of LLM usage.
> 
> [1]: https://lore.kernel.org/linux-fsdevel/20260219-portrait-winkt-959070cee42f@brauner/

I'm working under the assumption that we have crossed the threshold and
people send patches they did completely themselves and also patches that
were done with the help of or almost completely by a tool. You have to
defend it one way or the other.

Frankly, as long as you understand what you're doing in general well and
I know that you are a trusted and thorough developer/maintainer I could
not care less if you tell me whether or not you did this all on your
own or with the help of some tool. In my experience, laziness grows with
experience but so does the amount of ideas. 

So attribute it to yourself or attribute it partially to the tool. I
personally don't care.

