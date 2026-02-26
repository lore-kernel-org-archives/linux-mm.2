Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC3DFD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4966D6B00C3; Thu, 26 Feb 2026 11:07:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A086B013A; Thu, 26 Feb 2026 11:07:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F9106B013B; Thu, 26 Feb 2026 11:07:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1478D6B013A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:07:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C96651B703D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:07:11 +0000 (UTC)
X-FDA: 84487087062.14.BCA721E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id CE1F914001A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:07:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MTzuK409;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFIXgRT3H5Z4anGhAZVgpZ1TO17Qe6unr61kib8Wmyw=;
	b=bvocU+dAb2Wu0mGqgGfmh94IBPMD7wT4oMMyNauehWGN+eMKgW8JHiFigV33vdLi9Yhzyi
	u/Tl20hhrk0r2tWTM1gmWEQbl0qZnG+me6d00Xp632FbXTh9EhRSrchOUSLCFhnBIFXSiM
	9GkXNUtvFCKKuY0OLgYU62SF49SQbvk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122030; a=rsa-sha256;
	cv=none;
	b=Noenyc46xsRkNGiRRkKYajddOtOg/w0nU9Y284c0oi27nLwoYNdZHyns8Es3xbVaIstgQe
	y4VxkeOhV0JiprxSsY7c+gjGejcISjRK3F+MZw4bT3qhvTCCRECDLEAkK2lEOu+FqEC7vi
	mh+Z+CqF+P12wdH97MnkoX2pRig9f0U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MTzuK409;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E215240735;
	Thu, 26 Feb 2026 16:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546B1C2BCAF;
	Thu, 26 Feb 2026 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772122028;
	bh=7K/FmEuDwTdjSg9C4rAKy27XY8EaYM64Jbqxib0imtg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=MTzuK409usSF/cCRJwKXtZdkSE+7pHi8yAZ9UZ76L5NsHfF5ERt7nC6cuK6PyEV6L
	 wuPk+HwpV4SYjH4tCBsNgiI/678QKspeymc5VXcjQXnq70cN/JUrG+t75ZyU/HFl3v
	 IJlI42/zJZkvI9VmjeDxiHpkaLAsKRxdoGmJ5kZFm2BOFKtZP0fiIPawonOspYjOYh
	 ElsV6nhu1rfvM7+lq9jzj9SzP31ih3vT+/mK4TWTONAfGnk4jDs0Z4HSGmkmhX5MPm
	 l6O6P6KmcK4u8AF0coLoixJNbAxHMZED6GQQ46ntc5J7spZJa0dE7vmlt628I3T4XT
	 +I1+GhJYaCqkQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 26 Feb 2026 10:55:54 -0500
Subject: [PATCH 52/61] drm/amdgpu: update for u64 i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260226-iino-u64-v1-52-ccceff366db9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1179; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=7K/FmEuDwTdjSg9C4rAKy27XY8EaYM64Jbqxib0imtg=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpoG0RH0BlVgd1hc2ARIapdMesOcS14opM003NR
 0erAY72K1uJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaBtEQAKCRAADmhBGVaC
 FVkrEACFYDnqY+DXVKQGR0Z58808QWgMd5pKPx2DTRKvHR17M3Hp++u6sixkYKtqtN5Vgtjtves
 COCxrY5lB6ULDLg/YhlBrempWhSvAlbQnsrmNV1Vz4kpbHhknIPakEgxTz1NH2lBS3Gh2z6yTkh
 vq4UOlQjzeLuBVa8St9lXEr6JyYIMYlccfZ6wvlGG32nzar5ePPSRk22lJixkBhqiK2zYyW/qza
 dQMjurfZLFcy0HxoBnoy14C2/TgwvEf+hSykLI5YwCnOfyZnZ9ymGxexwtDoTn5ew7qLwuO0+Yb
 13buCK6sXK6vZDcJqU1pObj+2Q+OhPftmJoGVBwYZhvyb5B7NJsgsFllJ7AvzW519vIYgF/CZ/j
 vwmDwyGT8qiQbeCAeWlK/t7xRN/FFYxTNDN5/aAATKmOCGE/v1TjgrV3Aha7It/M1Yvc/Gp4hTe
 gJdO5OQEF2tRaq/FqrRPOJRWPPqruBbOfz7WyLHAgVBSFcIzU8sl3p9GXiTZP2TYRcLpRQ3m33e
 yhVzI4bWSiqG+WeMlfMvzndN98pBgwCnDN/d5Zr09Jy777jlU4bqCdVDj/L8ryxSWfU7CXDVqUO
 g1hF/vxaNXaMtE4O62LJCjZI/tDh7Uw/IvtWG1FQHdgeWA/PJNtmZnA7jY6iekxKbYCjsmTkZ7k
 YT8fFRkl5728AJw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam09
X-Stat-Signature: ysucyyx9zibipshjdaw6hbn3geg4es1o
X-Rspamd-Queue-Id: CE1F914001A
X-Rspam-User: 
X-HE-Tag: 1772122029-302947
X-HE-Meta: U2FsdGVkX1/BIdirXup4aiooeCc+JmaQlTwQRQ64CocrQXQ09LbdXRa6AYC1pU+xtY/L7QW7IvHPWYlKyLYzn4GhlW7bi6NRGreERyw3ABlxCCW+GeoGzVB8CMuoNCUV0UMQm/l3PmaN/V1GJ359ADsFlnRgGCDoKEFvBRWfYnMDewsERu8QSbuZfbISU9xZVamhD14kUR6/D1EZL8dlJO2ImgpPcTm6p4j626ec1ZwQ0H5xmr8a53Pss7YTDONx4odc+Gggs3ZfunEoGR5YiCnY7isaG0ohpUEGZ478gd0xpUEIuUu67F2DKMKDVShI4UeqtKAVBzlCVLZvmu6/7Tuiapz8GaDCGmFdLxgjeFAkxYrFy+/4PrekDO53NJUkf37QSgpURX4f2T5TNbmZso2TeBjn7Rsfti6v4DLhLb71wHtK2aWPE4C4Xea9BORTRHybN2W6ffrQIkRwGBqFAfANzBWcsVRPIdPNaOc6LHrQlnOwdPPDOuRmSqGN1oIu5GuEJdG4KXejNy+sUmOSps6rIpZpAV6nGSTwlz9r/Vaz8TQIFZQx89t6yo6vMvJOa4sq94vt+6sSY8tFvI+yCyZKES5drgNAXitm8RUKVNlWTpNHJWvXZgIvPXGwxTbvPyHUIWXT2UuejXxvlAdyOuXBGWCOFKB+trkBeWVG+gV04nbgJpGPyc+owGJYpoNtlSIRgGanknIRSCgNh//cGejszO5p5TLxKDKjRHSzz52x9V1VcN9HZJJl9Fb2j1WRzHO6o7VLPVD4CXwq1CVWXtA+ibssWp8hhFZQBc1XXPMLIjjNFIhjZvEDwx4ZiLNsNYlHK/swgkv3lqci8RpLRV5eWsZwQ924T/BfGIJx4m3gVBo8rvy0z4TR7C+84kiKgLKNRGJIP7k8dTxnXkjFZB0k4RD1SXKmRkfUxl9e0Ww0wHcN2lITq9SpJd+n9aF3NtNKamBB+7yKG6cfzTi
 DB8qoWJH
 KUY6aMSD2EfkhEplTK5i2B7W8gBZhOzwItBo12uk0yOoRdA+fxmWrUqHkdYYlCzfvpw6Toqt2P6aaFOzSLSAQEcFWCBzDrD98E6J6J09tiQ6pFU365gahmv++xBePJQWz7RPbzbftRenZJGBcXmfp9KEIA7m6gl3gxeHmEegDQ9r0dbuNbYtaNzgVJTVRnkEFdEHJfgzBQsVG0b0jLLNH+wKlxCYebER6BQ+6C0qrp/9/Iht6WS34cvgMl1AYI7yv3FlqmktGMULx9/2O+fIe8lruITz9uLApR2bjJlskPPy0N69BkI631b7gw7e3Tvf0sVwOSTIIop2uPe/tLQu56KdkcASi1I5oqkJcI6hwWs2tdjgY0ynlYy6ipnaaIEwGqtMqvN0Cw0XvVonOdpjOEqk45WvBAoQsseqD8/QcE3MZzhUgE+tfjttgd8DJjFu9i2bZ2n7uoVlzxOBi3K75A1a/vtBvIfAhj92065LgsE2xWb8ndBNJBoONgeGryNwq6+dRNfNfNnndLLFetb8WS/yPNzDohFwnvrT59RMzgBY3MCxxTbUc5dEo8t+CzkST/EnTA9JvVRXoHjl/O9QxtX+bEa2XfnnYiJLbDIndo816fYk7W7YSE6BAesWNhmlP/X0nJ16T2ZlX/poQ9C/DKMm9FpP3HG7nyC5JCKxoIl6eiGFrZdGfj8pB0dpvQdFXyGRiGakLpzfd9YAJelZ6qH3V3QhJqE44zk7GanIhGyeny9e9359PsSOlmh8BeiASrKGQ4VfWSKOHPPgkqr+OKopDSS4fzihRqR36l/WpL3sb8UJKNJV04O9WRkFNF1FQs/vIxnt9wUnq8DEx6Y3iRAglgZvXolIyMbqqan/Kp7OREtklnJWWIkQs9v/n8UsBVF38OfT3ICisJYCBEvNfDFnqrVNqIp8n8p7QsvNdqUxc8Gum2RamgGy7cvh/3S90iFs1hM641GBWm+wasTgW/9r55kId
 OpOngzF1
 7uonQUgCJLKO8sSPtCi52z6noYYut2b1FQs0DudckheutqJTjKpnVai6glZSMbzekmnSiNFj+pxPZnUeF/QULeyl9soVqo/8j3G9wTdobZzXVZmujXIDvqeHiFAJY1dBbgkwGt3JCqHMcmfigokjzXMvtipOEebO4xP0VQ4pF6ThaD4o174L0pUbS7FhAcXx+ghsElGPz9sPslqT67krPaSVg2Cuhf7Lx2ZEsn1JxKFXFFpMSXweq7yvPczvw+c1Ln9cuqfgkUFaRTIMnMhxlCfTzMrUCwwXibxa2lEdkwEV7cQPH0QA7fHEVetSees88eWAZMfa3yUnAVVuqkkK2IOj44jv+h3MntH/J5mKqi61pjsw1TpPMZYN3VgmY1g592ebnlR7PInm2O5Ufcg+VSRMURHmWNqH49DdvXddlwvn2pKpAYV0Ao7zUCVCvb7mUJUCVyzsjhCBHfycpG8IVWoAyb8vsDsDYrPhJ6nf2fvP4muYOEF42aGM87/cg0X/Jzjdtpb58pFNN8hI9NJafwtxzZnuz6/G3i4BWY1+Rna01uACVS55GKtzyLTK310fS3Kt3TCAYjNC5mXsKAU59iqfX9yCbCCKAu9ixrWsVyfntl6rXjd/2/OMAMLIsHlTGMHvRodTqMVgbzzLM9l5QpC4ScVVCGqzba9n4fE9C3nm872g9wJcSaOPgKmIBCKFqus0BjWuGyZ5l0Wzt5bQ7Vxa3zKngDmV6YFNM/dfRzz2xKF7AhrtBIxkwGdJC4IavikaMbjU5Unwqqil7TMOmNb99l8ADjUtVlrJYtEYCnRJDofrQknpVLHy3YWxLjSylKN2pV7oHIlsuW/Cx0tFHcFCXdo/ssfho7tmqkmbUqa8kUE9MnZkNYpQDKbpQ7mdbRiLsMaqpqgxOoDUnck+is0d2dGDx8/4qCAdj/Ol4b0UTFJewtYWA3+MyCzIqMQcB5J/JAM+1tsGE1R2CX46mBMZ8qUoZ
 NdeJ9b9R
 b+nhBKBSDYU2hurRVyPSd7ffew6JbCX/IwZIUgGBlys9DzDaQQBo/Xtb4FXDykQ6SxlqA3nUnocfZpHLiPQg8M0n1tz18G4WHojKyAGpJvo2s5zbA8N5WmG/w7v+TLrdVMz8f5/2JY8hjo8CjF4Ri7kSqwujIUcB+A0x5H3ead+sQgyJzlIgECXmjcvf8wq2O41V0nTDHFwhuwPy2sgnqHIvCyzrLa4jBBIuKHuJe1K0QyxyHs09GlL5ABj2eyMp7Ua25T4zQMIi5tZiYHWdgPQLpLoz5iHCX+obqV5jNxtZIgI93fGtvo28Uc2ClDGnaJK4RtvVB9to7vkkIHrIbS3mpzcDbHow95KQ85Wlp6fuHHXIAyG4XjorZv4dRWVRFmVVLWw/uxtvtZma8U09t2cF74ca83N5n4wQdBkpan0zzKieKg/ebaSUvh7V4HcQogAOPFcx/FTLndDlklXx2Ew/Vu8joLK1U+aVVMZmls/tcBRjg3J4QMcMQupKE4358/8cugFZfmzlLU2GcjnqXAN1zfJpfgORrvnjNeB8BSVLjVTrYwwTHrTsxRfUyNfqG+rVen4wQRLpk2w+4DgX4+TVbUo47y27cYTF6How+DiPzgyfAbfGT6VVBp+8fN3/UlnU4J/zQVsV1q5h7krHjwa8bSi4McJMf+cT/SdgUB0AasBxgGEKBAIa3ggwvSnn7CJTqAyDgGK0gsHXLhmF/z6PeKyPEEdwmXeWATkxPVH2gp81METGGz8xB4z4O66+fFP++G44/9rEGgVLA0PVYj8scfKhaHNEX7lC8W+TkR5kiAnu+YDeQDCwZY2tMp2IKsjUiCGiy1T+yMqsTZ95z745zBm4dEDsOlwExHXW/xRSXO8JlQfV1M2q3Bn2dLnYfkQu8QDE0AgsNoFgBJa03G/QxJEJs9WLaD9OA06qlDOnctCVEJ79/eBb0Zk5n/IUKe01PbZKByI2QWUj9EwY5j1woJfD8
 qJzVggip
 +/jRuWjmBy/CznsT1LPnIM3svrlhCClNHn36P8UFM3rb0NJkyCGtlDS7WKinLdrtMqxZJLQISHEHCCgyVwr72OD1YGLRsbpfhXXEGISlWYOWuwqKlfvBTIheJMPCLBv2mPNYl7ZotzLyklTtdOd0nv1pQY+IYJ55o7OgHLpzIzpUeAa97SKeBK72Nd6nwJM6yI9CVuqoI+MXjQuGDXTWaTkqSZgt2pTchDZ2jCNqggOTw5QDNvHGJKz9sH6UWy6YXSQaDCgAR5Pwo5OD3dOOzSW8O/AGrkvNYOfQEyEFObK9xCvtGeTrpvh6Dc64mkHAou3D4s14hudxUHLRBWY7ImYu7y0PZd3N11BI5jKswV08LGjbqo2wxdsOVFIZejXarIr9/H+qXuVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update %lu to %llu in drm_info() calls that print inode->i_ino, since
i_ino is now u64.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 1fb95640069667bf731df05990b57c6e0a0d2c16..aaa8cdc122c49ebf0b5b6c55edb3a1db2a4fd710 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1676,9 +1676,9 @@ u64 amdgpu_bo_print_info(int id, struct amdgpu_bo *bo, struct seq_file *m)
 	attachment = READ_ONCE(bo->tbo.base.import_attach);
 
 	if (attachment)
-		seq_printf(m, " imported from ino:%lu", file_inode(dma_buf->file)->i_ino);
+		seq_printf(m, " imported from ino:%llu", file_inode(dma_buf->file)->i_ino);
 	else if (dma_buf)
-		seq_printf(m, " exported as ino:%lu", file_inode(dma_buf->file)->i_ino);
+		seq_printf(m, " exported as ino:%llu", file_inode(dma_buf->file)->i_ino);
 
 	amdgpu_bo_print_flag(m, bo, CPU_ACCESS_REQUIRED);
 	amdgpu_bo_print_flag(m, bo, NO_CPU_ACCESS);

-- 
2.53.0


