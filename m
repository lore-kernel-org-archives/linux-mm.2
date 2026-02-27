Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E0C2FEFB70
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D2A6B009B; Fri, 27 Feb 2026 12:19:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D113E6B009D; Fri, 27 Feb 2026 12:19:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7DDE6B009F; Fri, 27 Feb 2026 12:19:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB636B009B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:19:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4EB76BB10F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:19:20 +0000 (UTC)
X-FDA: 84490897680.26.F2EFF0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7B61314000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:19:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3h9wEAn;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772212758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfqr2aJJYOHBkiONcyrlCdNky5+DRqBMfCvBWlcviRs=;
	b=4Xh9sTA1e2csfJIQM+i6yfMEhtV8OgmXM6XuDmocO0FZr/hPJNxybbaujhcBZFDVRp/vuk
	CJIRE3h0hlPiGEfQVcKH3UXTPklAunUh5OouELlwfgkAceV3SDBHB1KyOh/MU7mKzfUK7P
	gFp04FzAbJQ+BAr8FcUih8VIKgf8AVk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772212758; a=rsa-sha256;
	cv=none;
	b=JZSsjkmg/vCzZhRaBGM/yjZ9a+SQK6oO9TklxQybeh/xEqSVfWYx4WJBAKDf2CKFz9DwEL
	0eLCYyBPwqgNqNAduf7KgZ3SuxM6/oTZoC4pjXbOvxcAQNFq8MUoWL862y3E64wUZjC+Ad
	XlFoZhREoal4tfJeOabBJtyjotm9l7I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3h9wEAn;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88AC842B9E;
	Fri, 27 Feb 2026 17:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDBFC116C6;
	Fri, 27 Feb 2026 17:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772212756;
	bh=9Hmf5kY8YWnQ1E7H340nV4l2uV2/0yd8vERohTamu7g=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=U3h9wEAnA4jdOFdHtUlDJHH8RA37wTgdzMio3JTprgvFZncKOF1Y9bC588tgzosoO
	 I3zi4F+PWUveDMo9C2x/IXighlDyvN1dDbfbkoNeEuOpsd8g8ikAvEdDJWJkVEkTKR
	 33cge3FKI8KoskHXtQRcy4n72Nf226qDkiqE55Ck8EczyfA2ppenIbdwy6kk9gn2+8
	 wrVv1JAr9Wa2QDkrJ0O9YuE5evAkKvxtHpzIFmDGHGCDIvT5o2ZLGWF3kk0YP1TpID
	 zG1I/R0E6cqPfGKFx2kEmBBYt9VLZy6xqxjG5ly2fMrN8gQnYDoY1zDoAnFhgIWI4Z
	 qy+iMn8iaN9FQ==
Message-ID: <4a462d40899698586c110add96ce3fab6ddac30b.camel@kernel.org>
Subject: Re: [PATCH 00/61] vfs: change inode->i_ino from unsigned long to u64
From: Jeff Layton <jlayton@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner	
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt	
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams
 <dan.j.williams@intel.com>, Eric Biggers	 <ebiggers@kernel.org>, "Theodore
 Y. Ts'o" <tytso@mit.edu>, Muchun Song	 <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand	 <david@kernel.org>, David
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
Date: Fri, 27 Feb 2026 12:19:02 -0500
In-Reply-To: <aaB5lgKd8FOIizPg@casper.infradead.org>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
	 <aaB5lgKd8FOIizPg@casper.infradead.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7B61314000F
X-Stat-Signature: uofw3tmmdrc5grczk8wjbc37ucpnopda
X-Rspam-User: 
X-HE-Tag: 1772212758-769659
X-HE-Meta: U2FsdGVkX1+7eOYZQIydJZFO86fq0YK2wWsrRw+e3ttrXLjdek7jHzs0Vwv8C3+RTOrI5s64/ki4qhg8NQLoFOoQ89y/Yy04ppwtCgMhtwEx4vEN9J1rUV2+yO95z43YSutHD6/+nnlmvAAboQq2InJ/XVln+IKNv5bor+cp1aoq70es8ocEwsRGzP9JfQ2VLZ/4c89Vfwnp/nhoggmlhlXz1JycfBH9DirDabfkVYITdD9KkaTAe4odj22kmFLNQa3ofklJDLZJexNJ4h2TfVe+dnI+KLNZg+IyiiTYmT/au9tfvePQ2npqG+w06K8wNLNe2++udz217s0dS9EKLJWQXmOiKIawr97BP9zSi8Zk8o8slOujTuPGxmO5gKRYe/Lt5fR+aSwJfdfEGzXXgQb/AGZBYPfnzuTqyAeIrc/9cDTVt8gSEdrqF9uThzERAS3fCtrucGjqY2G67Tbc33OnDcdgDCrSINgj/7EG+adpuSaY1LWBXtd8c+6zB/02SDznSZPPvEAAFJHaTOoetuVRQQArqUeL6JEKdJwoAqZwwBulQO1yUHj0Jh6kkpxvvGjTtXr7fZA1cfHxfzVIBd2TJIUhrpu0WjLnSAgdRjOXu0uOI2R/xcj+irP6QqtZkAvm4MtyVT/NHGxg0nhe1ErrR4KV/UupbPXTx41yvD1kDbeWtWFCPQ6Ifc4X51ys3iswqmCCZTqtQmj8uVpsNmcypoTAuEuYPyk450lCKA19D6Ao89KiAo0/EfWwyX331qIDQNiYMlwKwYX4xc+gz565LvmZSy2x0/vFAy4P9AFb3j6HHnKLw9F2rO63cQHech1mDXO0zntaPnTjcCiIaJYH62kN6ihT0x8+CVHr/GnV/eXX1U+Ff/U6UOzkWXIlQ6WoL2Bd/4B6x9vgcGZdd+LkJAvZU1izBdbWXlkcL6fPyshtuuHlxZ5tJbXDilFNgjsmepYuGjkjhmqPUul
 94V118HV
 jUuW9hFkwgy3lgZk5jJQzczx2SqTy6YgaLoi8bs7xZ0+iXcpdQJVKA85NYnb3qsW0/bfqBk5/PwHBSjfJzA5tFo1MvpeHbJO9yrYH3UtWRA+1tVONuQg4BXRvT5VE+sh3zZDx8VP9IvS8wKMyY3qmHrjXuAsC3xQ4SUs0b9I1awRFoaWgKe6pcJkL+C0Bj/FOLVm119Jn/9O0wKaw0JJLtOpigUdXdtvA2+4bY4z01Q0ddB/3L7bv2lHqP+sPUTNkEOJtPjbxe8E5jvX5NJOtVyGLH8XyTE8hdp1DJV/A0utLIemEEoi0IFTIfd3J6EFhQz4rUSjSl5V12si6+wmbxKeBU8m1OVczDwi2KWgMPGvn0o/CGVtAXNWSaytcFm7plmXh0x+WXypJIgKF8oRiQNhGpIdLW8Z7XdFoezgzQNphVzRUtrI95UYSYImhyWQ54m3gO5h1LOaUuVKA5DBtCFKbK94g1D6hFcxFVdW1YgLY4VrhFVAS1RcvXafai9a7csAATSRQmxFP5k/jIB8pC7yTTMWCbPFJmGXonjQmxAtRXJ/H3bdKi3hgb/kc4KyIrsWBOpeorVzAHS+suucKhUcFk+yLl5I/AHOMlGuB2mDI3xGDmoVf0dHgcmxmn7cILsNqlYeQQreq7G5bu4mSgY289ktIsHMG580VhldkOmcVR/jktbltOTPCcIPI/Sq8Dic+e34jDpFznaXilpCD+VtFOez6cKSvL/JmNnCosZE0JZVcXAYxFVeJFLmESMxQzBmm3Xv5gM7Y4F6evVUE9etxEONNmxkdfBVwrh4dAfTFQvqtDklNXKfdbkr/0SN1VzR+puv6TpXK2EytPrMIsAnPy+LYBZrzKxDHIGCJT1/BiSghvhbytgZN9O5mF3GQjuS6PLuceWKIS+SsD9ynKld9Zq1fvvGtxIUh1IVJ4FfP9ytQ8MoUspqK2ctWHssBQ4GeDKUgriWRJEPuNH4D7tvlR08Q
 ISbhGmiS
 wgiclGxZXq2oEtD7gmOXN+krh+SFmUgcUkooidoAOXvXEQwcyw2oDfuJU5yfhlAMN0qWf2cePvenKL51cbcL1JgqMBkqd50U+nRnXjsVCtXpxT1aBJZeTtggfAPdgyoLKK6rSGOpWxxsiLeDfstR0T17AXP0E3ReF1ZckWNA9jzRTK47FtkIuYsGQJ9/dLZTw5dUkDFMGe0SecLcErunF2+Qf6OEEkrKzMP5PCi02XYxhjPdu4RAkgJkukNrmpoLul7fJTeLEiVf4RphP0I6cDFrY/GPCEsD+ZJCDx0bPSTFO9iNtPhOtFgivNYHKueGGI1pV07FkgbdhGPmaJ0+48Z43XBCelS2Ka92r++iXfLwkAU5bgwAHsi8I9fxIp0Fwdf+9y2NT3PWwtMcWMGtpgaEZ33tAmF18tK3V8o8TQNRAdm1acEE7SU1GxW3/iR30U8UHTycpG3ISkmYfOBDQtMrRIbp5ABfO8HtJIwMqRtdH68lou/iCDOk/KfD6FzwGXCD8CPSYhrTwkZlpzX09godMwC6FCGpFXXUZi7M310bs5iaAOaEBjwNg0jaZJKwchA/mVoZ2TzgLlKlYY7XA7qELKtLS6KY0D5a2eC9WBHHNnaA9vKGxI4cBv9Q03mQ2IS079aIkf0yPUBCgYLuqiGaHm5c2BaqrqeqbBkvDC2WlI+3upIo82am0BqbPw76OwN4ZSMmFPKgF1G87dWYXe0TkPsJSY4cO6sYY36Nt59rpKi6dpdpyA4x8ym5ApZw7wCGMBy7hlpyvwB2n6P8OAf4NiQZsZZHaoOWCS8BUPRuYg8osYZmXvvfln7puNGyfuxwY1hNA2d7iF1udh7Sizzv7hcI1u5Ps44I64jBXpgvKfIhn7fZG7RlrWPQ65lGlpJnOLKGyqMnv22K0uTjGyUMH9wMkYo8rUjVCttLK5oQJKG6mns7Tv6bsKHWFwM78CRZeNZn1sgU699cxISVTKZnKkjeQ
 866W87+f
 h5xROLyVzDnmXtSA/cPr4nba6U2havijmUF8Pzs5VSrEdirhyaxi6mlXnfqYOJkWJ9em8ODLC1SOMwDkT1qX9pRf9zoO+S8kkJaAZFne24SB2zdP/RvC78uBNmu66rvnhbQ/Atq2zkRARgFBbR5wcJVe9m/S+Erd2YTLRCIM3aOvVSM8lHP4x0ujqwutYgK2B8IEUrjymHCf8LWNg0q8IR/8qMibjwdMb6L9Dv/1w2vJxZxAAjwKkJ1jTBHHUhbqUmdNtfffFX5aVEhq7ymy7AE+XlgP2uUnRpoOmw46rBjFlthwsCwTuIX7Vp9pOSieepkP56okgWkIBGa92bNiQaGyDppE4RXJXJvNO9G7PfSs0h913ogOxL6f+LHuj/KsVza5PrDYZ/roDk0Pva9/JrELqoNLKX4QNPIy3Rqg4tnn7NlkmysHgAm8HsPTpjYOvd1u57c8OCg/rqK94s1rSe145I3yR58SSNpx2UeF4qDKhkO29KsWpY6yLDzN/bzt6pumlKcVjUXfJ9BqkZn/vTP5smbELlS0AOR36UrKgrV7HhRpVkCBOlSzRZA4u6kSw9s4yBe566WOzSmSCDQuxN46B05n+P3JBBo0qMGpkrhTw2mSRPSrv0MXRCBnoN9Dxi/ILl29MGDQU2ZJ7d6rMvpidKzuqtcL9GuKT8VOq2kGpOMVNRvqpUB7i6bz6JkaAD2QcAJaRGAZfF6MLQeeYjftcS7PRD7UHJDz/Aku/DvmZZ5c6TZTWd0AVhU9GKeI4/ONluHTKFFHSaSD4IqwWlwrUzUm0Uli8LNfbnITj0Ep2wUjJzsRwFLNzcEOOdvEOzi/qjFWQY9I2zxxgfu8UzFCR+ohUgJeoyINsSjLh4YWnv0APx6JmWYS+6Y4Y6aUAkkzDdRpnzhaz0ids8WP0/CoWp8GyOuj0z5x3UM5L8k2ttK5itGJLeDpkwIB8YGYjtlFn9lwq053DSzV39KuUM5hRco7y
 z/M+4PIF
 YxsJNs5vf3tMEE9GBIEN/7jWR/HKE7YhtkNk/HHhgkjGkop8LiWj+FXYBQPKNA0M3Lel6elY15cRreBWJuYuTdoi/e6xtZxOumkReDLAE7nufqrhdWLET/CCK5maGc9TliTpK71WJui6ttXOIHTTYHr8TNoXMN0FzbX6Z75y0r0ugizrGl1rvMMDu9YCQxrtTxaZSkB5lRxKN0tZ6qsQQXwXci41CncUIBrHMi9kbn4ChxkkybIXKQyJcEaiBypVsEdNhbGuD+BOWo1lONABjt4fLF03R9FVZ+7FN++K5AZ6xm2/U5WmctOFEE+Z1cNw5IAbFt2np46ab3r2RufV71zHRPlprNLl1Ek41lldVp+Rk+cCKtVKOb6803Q6wMou2YSS8UIVVV8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-02-26 at 16:49 +0000, Matthew Wilcox wrote:
> On Thu, Feb 26, 2026 at 10:55:02AM -0500, Jeff Layton wrote:
> > The bulk of the changes are to format strings and tracepoints, since th=
e
> > kernel itself doesn't care that much about the i_ino field. The first
> > patch changes some vfs function arguments, so check that one out
> > carefully.
>=20
> Why are the format strings all done as separate patches?  Don't we get
> bisection hazards by splitting it apart this way?

Circling back to this...

I have a v2 series (~107 patches) that I'm testing now that does this
more bisectably with the typedef and macro scaffolding that Mathieu
suggested. I'll probably send it early next week.

I had done it this way originally since I figured it was best to break
this up by subsystem. Should I continue with this series as a set of
patches broken up this way, or is it preferable to combine the pile of
format changes into fewer patches?
--=20
Jeff Layton <jlayton@kernel.org>

