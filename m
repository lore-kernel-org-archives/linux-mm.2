Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C4F606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 18:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MEKhaFyl
Received: by kanga.kvack.org (Postfix)
	id D31B96B05AF; Fri, 23 Oct 2026 14:33:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1D26B0901; Fri, 23 Oct 2026 14:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5BA6B0BCC; Fri, 23 Oct 2026 14:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9E96B05AF
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:33:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37C7B1201FE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:33:04 +0000 (UTC)
X-FDA: 85354737888.30.B497BEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 96820140006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:33:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MEKhaFyl;
	spf=pass (imf09.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792780382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAxQFAeQQPQpgLYQtsjV0kUzkeCj3wXnsII0CK5Zrx4=;
	b=K1nwo+e/SuJcUv1JfJOwhH+HSHvsXZEib3bplq5Mup/ttLw4BXHQY9yTyg5whc4xQswWqg
	0x+jHis6N1TNewNTw5ox2lAUwr+OflWUc89pCAcuBCe1mv9/KSiIEBuSMJKriF8m9kickg
	XjSW3TPytOlmklb5FYm+puYNbbjltcw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792780382;
	b=evgHtTmAOIMyy6dLFj5MepWpuvoRvczFJizXqbfSqodZVE9hmI8nKikefKRLKIs9Q15dm3
	3xtqWaVXTNs/UaBGFjc9yi7shydb9f+O2/Q9e5D9hWPTWgJUf5Th+MDyhgBOy9McwrIQ7Y
	J2fWBoMc6ftVGJ6dDJ4YRmOHwvr/Ld8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MEKhaFyl;
	spf=pass (imf09.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0545D601FA;
	Fri, 23 Oct 2026 18:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C0F1F01825;
	Fri, 23 Oct 2026 18:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792780381;
	bh=KAxQFAeQQPQpgLYQtsjV0kUzkeCj3wXnsII0CK5Zrx4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MEKhaFylL2Mm3oqorh1fLNWb5zHAkYoW22VF3+3JTivYNQ0mPy/iPbaUnRz1IqCPQ
	 iad4WCsEAroHopYevsON8Uy42QdWKMIl4B3x8uNON/C7PktgbWetaP+l4QkTWbA1QS
	 5n9/0uP6Qj3WGIBGiAvGve6oPg0gD1+U2tUpbffoJ9ImuwJrRhWOomhLe/J+bUoF+r
	 g4fZxIZFQiVFAsa/b6P5GxXqC5sJdpRBpNy+vvG5D+brBFu6ggxh67texi91Acsa8X
	 Aq1cXxSQZM+wCIwYNdPWoyRJ/VN6fbxbB3ajoSWxHy2SgMhX53pTMkb6Bx+34SthZP
	 UX2vEImHgo/EQ==
Date: Fri, 23 Oct 2026 08:33:00 -1000
Message-ID: <ec0c2add83f18d7a3c726d5d219dfe42@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: Ian Kent <raven@themaw.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 driver-core@lists.linux.dev, autofs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/2] kernfs, autofs: fix pipe lock cycles through sysfs stores
In-Reply-To: <7a212208-74f2-4d79-8ca2-a1502d0e0a1c@gmail.com>
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com>
 <cover.1792577179.git.krystianmkaniewski@gmail.com>
 <649966b83b39fcdd25e892fc3c6732a1@kernel.org>
 <22d41f2a5546d3bc90a1b3ad24ed3656588a854f.camel@themaw.net>
 <7a212208-74f2-4d79-8ca2-a1502d0e0a1c@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 96820140006
X-Stat-Signature: nfuuje3r4swzb6q39yeak7k5uu7hog39
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792780382-927476
X-HE-Meta: U2FsdGVkX18wyed7xKfXbl4WCalLu9JsM3hLIDNGoIaop6uE1mYJIsD6dZ91fcdI6WB/CvC0otMLsPu3w13YDoOzZ5gGaAhGkiYvQHvVIBhUR9K7MuNuTDQccMx4fOD2cuIABsvWNicAYm+6sYE2GoxHMvKJOKdcle7AZIHPnyeypi1kwNcnPBkjj4EvHEfo52WvFMVQNkiLmDGVbu/FIz7ua/42pWfmY6uZS75VxhQo7HpXxRimIzmJBjLKSCss0OesrcvkS1nFvU5sxfYB50IsEaXTE3xuEC++/kEuP4SSHxdBdlli9UV4gql/rLfUA9BX8DC1fvdGty40X6gsrGFdfGCuY2Xh7fZl0yBcUgFAbIfewAcLUmAE6RtR2GKIWqb7pev+YyVqQXljK1zioHY9mVvqkaRFRL6K1ALxP2t8P82PES9gM3S6FL+z2u75sYopv8c09V2f6qHnWTW9TQrgSDdSv4R4Q+LYfkVj6N7ZjHdQ4/1jVn5VuH9mo45o14ZSwjIs5EE25uGmNWxgm+PdKvcVxLUmC4dkzSTJ/EtS+PfR6iTk1zfDjX5oXfTeyxM6jJbVZM3MPR8W7vEpuMzo7WE9ZTPeeiIe0hrr7wBz073dO6K1cOORWMGyFxU1LFLAmS41lgyNV1JHo9aTOnIyntZdFlYlEYa/9GCS3WiWI0F8dABfC+u3AO7Z1iqOWNdXmu4cuhsLj1Wz4LMfHd3F2hi25ft05P6zoRhjQEMGkWJdtxgVkwzwha5oLtvOM49bCZYca5KlTkbkN3cvmxFB+nPwjyzXn/s7CBWfmzE7PwmSWh+ZxdT5PL0tMJVnQSs7TDIjGE4grDXniWnOG8yo1+TMOJrxmrxVqypVZ+lO7w0eF/uDXlFEXWU/O2g1K8KlaNXGM+TV9Hm4LMAFFnp8Rby+5JMzrwE6G5bicmSo2Jz6FkIkydwLZg1gxmVfCWqg+/SW6ggFxvjV1MW
 gJgemPg/
 ySET+mw9rEtZjUHpCmW1x1zlHa6rUFgc82Ia0ILlLoMfsTrYoZ+pT4TjWRuiieo6h4QWLFIVkAxcudxg2QdEoq/AYkBCYxGKyCKcTj4CI4QlT8clHgEE/femoss4RYL7O8z0fRrEAgbsNP0moVrgMO5aPYMRc3oksehOUPJMxQyTE2rn2W5fs1/yWYwmb4eUFIFUS8oQ0si1ljcMs5/zzlICl3jf7T0HJA1CknExdfVnBmXdfMVDwQaymMTu3ho3ftRjb7zp92R9AhdwZksIz/2I0yrZ/fkFjn/CKkX8ogkXS0XElcmrtofgLhcNzda3ZEQsGAYaaKsXxCXCXtgk1bDk8d76NOiYfjmKESd1o8sJdN3on0RwTgpqoVTRTKcgtfvvuGsJiQDwcAdY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello, Krystian.

On Fri, Oct 23, 2026 at 04:05:38PM +0200, Krystian Kaniewski wrote:
> Given these two separate paths, did you intend to prevent only direct
> splice operations on /sys/power/resume even though the reported class
> cycle would remain, or should a replacement also eliminate the
> lockdep report?

The lockdep report should go away too.

What about disabling splice only for the files whose ->store() can look
up arbitrary paths, such as /sys/power/resume, and giving their of->mutex
a separate lockdep class? Splice is what nests of->mutex inside
pipe->mutex, so if those files can't be spliced, pipe->mutex never nests
outside the new class and the cycle is gone. Commit 16b52bbee482
("kernfs: annotate different lockdep class for of->mutex of writable
files") did the same kind of split for writable files.

Thanks.

--
tejun

