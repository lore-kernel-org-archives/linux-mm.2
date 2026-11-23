Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D67E8606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 00:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Thac0G2i
Received: by kanga.kvack.org (Postfix)
	id F0A246B05B1; Sun, 22 Nov 2026 19:13:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBB426B05B2; Sun, 22 Nov 2026 19:13:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1BC6B05B3; Sun, 22 Nov 2026 19:13:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C03736B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:13:18 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3FAFDA07D1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:13:18 +0000 (UTC)
X-FDA: 85464459276.03.500AEF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AC22940005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:13:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Thac0G2i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795392796;
	b=t2cCJdMpr0W3iz1/0ySjrMnMKZFBvlJanSOThGdoWRh3fr5vlZ7tKpIlXjRYCmPapMQfLo
	N9c/bzNXh5Ue1414wBxM6hrfpsfDeSxvVUeYS30FMbFfRhion9xFu4ckdFIxLOYDodfVbg
	w+tunE32d0E+mte3ASPlYfG7qxFvzgs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795392796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNHqEZsoH0fl0KvemxrRFgEKII9FO4FpbdMxVzBA/es=;
	b=w07kZRQE4Q6/H6WzdbeQiTWwvUFxbksHKy680R0kNQnCGv5indmlqpsJbHOtYnBQiSiTy5
	zMd98vBKgiJuiuEPTWt/KwXsdzu9xgHYMNjsP9494ccCQBVhGmK3BawrUDjR9KzMiCNXy5
	TxSPh4hgiXu+6epbNg1dBvfKA6Ci998=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Thac0G2i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id D244E44D7A;
	Mon, 23 Nov 2026 00:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EB8E31F000C0;
	Mon, 23 Nov 2026 00:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795392795;
	bh=wNHqEZsoH0fl0KvemxrRFgEKII9FO4FpbdMxVzBA/es=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Thac0G2iUDcXz2qgaJW8h/S+5nNIqyajBYdxzDEme/bJSPMTe7c3pRgwzgodAVoQh
	 mSokN09iHBie/kF/x0KahT2ipTDZfjbXgWYwU1GSRAZwJdLyPaFSaN/DwkoxM+5A+p
	 7MshlxsCaWUb+qkLze23KVR1cmAv5hnNsNU939yryaW8IPFXuZTne6FPxmqP8Go0Sa
	 cDfWRGtcKwXGHvXoVygr6TiD71aXKFcfCOU2d6HUw9YdgmFVbrYVyY6igYRm3F9YKb
	 EViZyMRONm1wSRulbDZZ/8V5UuxKVjY/b0SanxkgwkIiE4eozqzbOYfncDgHX+BmsK
	 M4rbopl0ZwExQ==
Date: Mon, 23 Nov 2026 02:13:12 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awOFGIWekH9-vlhM@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awOEa303zNUDrzA3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awOEa303zNUDrzA3@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AC22940005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: f77yq4fyccxurxqg3qckge97o7j8hnso
X-HE-Tag: 1795392796-439696
X-HE-Meta: U2FsdGVkX1+Ja84PZnKT0SM0h4blBPVy9ZMAidX97VwVd7tQ9Eyi7KwE++whqUCcZUIj2lWvNF42sKdkrSexGwYceddmuruY+AKVAnpJmp8eOjTZXjQM9igmxw196nWITs10xkVH68mLokmJAytdpM5pdo0iOe4w8KkIvcpiN5WozLe07UzYkTRNVs3Ry1lCdP0lDKTJUGoNyJa3u6pSzcpPTg6L+AQc634vj7wtWCy1jYugNetKJL2ptql4gf3I/fNLgoI4hdEuGLa3I90K6ijJcAz3xqMgvh665yrKP5NM9Bkpok0GSArcDJD4Ln/VkHvPLKU4KQoVmqwJtVvyrAdpAvVbLoLbwozmrAc+aLMJ1GkDbdJ0U+oZNooSEdU5G2EKYdHzD5jTbSwCc1ayJsapXdaHU9vn4L3QxghRX66NytwY89U6fsu/80nWv20wadT3vHBoA8vnXSD8V/yGpBCEX+oc4c6pJsqfIKecf9AA3yBx4D5Bmx+OX0gR7g6mAFnvMQB1UA0M6K3MQTZB9WJSXxYXfKWTyu+sd4tCXCo40tEZGu6AoUdj/GMU+3h+5/thpkysWkMl6Xn84n+o8FcDkaxG5v5F7WXMTqF1L3/OnwXU8C4RdIrbzVDmkx0qwzs9rs/3OFPttLcbsuVz721NTC9+Xd/brd5MWbgBaMlMByMkdIxHTnbCFkRtFvhqn05bBRiqvMmGURwiSaaWuRpKtCIBv3PDHGFsqthUENmJ8/oMi4Mxm/CNOhdqiQiWs9ByTJi2WZz6r/1nQpVNizqghYEx2CJzJFWYRsZP7eFoa5iqYZLbDbCULO89EwC4ncSNhEDmQtevb+Avw1wRcR1x9PtnFucCqUBBvFrJPoKZauPhM4BdqfyJgq9f2CQ7U8nSpOHr46zeXefAJLMhtZEDuFSe8Jq0mUcSlSXi1L8govTa5x55ezNnl1p79R2y8oCHyrojLwIdxgIZg4W
 IqR09lcE
 7losCNpIPpbVz45JPuxhYFJaDPSLXWQid1ylEnNZ08J+qnunlVGSiM0a8+Qd0Qn7FvpiRg87JsDhKxnGWPhvEf4dlgXmRGYhiJfT/fEVO7xvyB8/H6ljDnR9vnHHjV5iFI57WOnc3FWGWAa8/2laU9hnSWTvMs+8oI2vQwZLRFglNC+eBWkLbiJpdiE23W3P9oJt8EJLMKdIf3W9oAzIxx9no77ybl6hh3X8/CnCqfPlt3dVHC3A8zbmLsXVCRQuGvpNjYivow4D4LsCBjPtV9kqzKy0/e0BEmPFsGFtLx4DaQPNCD98Wh9g1JjRWzfkFYEK9adHI+0UYC+jAWqHOMZvKBGwNGK5hnQxAm+sSSwQG1EbxhNE6F+4PNsqUlhfuvsecB3QUNAMtmL0yTDG9DWCKPC6hBnynEY8G+5aXFs1xbojISpoSTY8IaEVnps+Wwxw/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 02:10:23AM +0200, Jarkko Sakkinen wrote:
> On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > SYSCALLS
> > ========
> > 
> > Two new system calls are proposed:
> > 
> > 1. userland_open(): open an opaque staircase-initialized container
> >    object (modeled on Intel SGX enclave initialization with separate
> >    build and live states) with no embryonic state, opting selected
> >    shared namespaces in via an allow-list instead of unshare semantics.
> > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> >    extents for a container user namespace in a single atomic system
> >    call.
> 
> Andy, perhaps a bit too far of the box idea but I'll just throw this out.
> 
> An alternative to userland_open() would a file e.g., virtual device
> file, and necessary wiring for open().
> 
> Then the added syscall surface would reduce only to userns_set_idmap(),
> and it adds more robustness to access control (e.g. who can create
> containers).
> 
> What do you think of this?

Also, easy way to detect the feature. This does make sense to me.

Br, Jarkko

