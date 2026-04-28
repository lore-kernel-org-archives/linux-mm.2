Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFB5FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 06:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61BCF6B0088; Tue, 28 Apr 2026 02:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CCCB6B008A; Tue, 28 Apr 2026 02:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BDA46B008C; Tue, 28 Apr 2026 02:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3986A6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:49:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FF531B9381
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:49:19 +0000 (UTC)
X-FDA: 84707038038.11.CED8B10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C86BA100006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:49:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=esWUtAvA;
	spf=pass (imf05.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777358958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpj9mKdejBwTu3ZlO1/Mlo6LKK3S7LUo8VpOmqvuHcA=;
	b=tYXCRB4Ly2NYZ1awEf4RXpqw+5Xngkv2rQ4xn3eAjfrfUGduggTnN9C7lmkkTNa5vKielE
	LGaro+oc8bFCdppl0QhLFuI7sB8MwnEb4JvnGszX6PjhdItQRj40+9xZRbvZC/BKVOS+bT
	gaO3C6ns7d/Ne558/HmxqKfU8+qYlGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777358958; a=rsa-sha256;
	cv=none;
	b=UTvAlzaM1zgM68ADFdMLaOYnrxCOPJRKpWDt4wEUlLgvehvmS38jMGM1UjnvkiXnQKT9pj
	0d+euwKp5A8G9rK5NO+399m1j9EkeSeSesUnsY7M6BaMVeUE2KYKH8fW87he3hYU3Gd9CQ
	NwSST2eyqtpME5qVX6zhZaZCUVdQDQY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=esWUtAvA;
	spf=pass (imf05.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91E0A40292;
	Tue, 28 Apr 2026 06:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F094C2BCAF;
	Tue, 28 Apr 2026 06:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777358956;
	bh=O6Tl5uKBi0wzghvUNws6dob3i+/LXRVGkMCIkzps4sM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=esWUtAvAg85xffSclXJ2spbcOZo6K08t3Py1mIcO1/GgcDIRe38KSZ/eqYq2nCQt5
	 G+aK0NhDAR7gRI/kyn/5t1uB66kWlYEPKC/0aMPiz+Lb/fEimsbnnAEY1emOCyyD+t
	 yIjw8WkYSFa/Cei9Fzr6TLMqTVTHteiCS9W/ZzZNWQqb+MPoEMEUT3+RiI2czfnCoa
	 ESjtUACghBgogglewSRom0JMpIpJwdDmVXy1TvXcI6t76m0vvfQouy1coW27925dwR
	 n+OSne1CqBKIt6vaO0F/ny/bqKMgIE8zd1GyXj5ydLj4eD3rqeniTsfsFANTgEDZWl
	 DtkosIk/qNTKw==
Message-ID: <7a5bfc91266c4432e0b21eb98e2e1087936cb657.camel@kernel.org>
Subject: Re: [PATCH v3 2/4] mm: kick writeback flusher for IOCB_DONTCACHE
 with targeted dirty tracking
From: Jeff Layton <jlayton@kernel.org>
To: Ritesh Harjani <ritesh.list@gmail.com>, Alexander Viro	
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	 <jack@suse.cz>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew
 Morton	 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka	 <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Mike Snitzer	 <snitzer@kernel.org>, Jens Axboe
 <axboe@kernel.dk>, Christoph Hellwig	 <hch@infradead.org>, Kairui Song
 <kasong@tencent.com>, Qi Zheng	 <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song	 <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie	 <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Steven Rostedt	 <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Date: Tue, 28 Apr 2026 07:49:08 +0100
In-Reply-To: <jytsrnn1.ritesh.list@gmail.com>
References: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
	 <20260426-dontcache-v3-2-79eb37da9547@kernel.org>
	 <qzo1s6a4.ritesh.list@gmail.com>
	 <bb418f9a7bfcabc3070b412c745c5b6456d592b9.camel@kernel.org>
	 <jytsrnn1.ritesh.list@gmail.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C86BA100006
X-Stat-Signature: ndeis85whe7ygrng5869h17g35cm4ofd
X-Rspam-User: 
X-HE-Tag: 1777358957-608794
X-HE-Meta: U2FsdGVkX18CBV77Tqqyi2eC8qYqRi6sR1y0ZCQF/U4ej/XXXLnvLqbr4mPY5YK6CQZLYXobQIRvoUpPBbS0KtiWXHngKxEq+9Ce1q3Q06TMRqnyYRWvMYBvwOR1sroipfpnrPJOaMuRbDpnm709/n4xN92PELILVc70/qTh/cNwIdh/KpKm1h7n0DhfSJGLuvW/7IazrTJKI3sd9RlFCVDbPZshtRoxP3rqL5RB/Yb9AwKAYWBgDbadnF1JkPp/Q8rOSW8JEjo9zFwxq4rVt9sWGWCOcvTAUNdIJcVLnjC5e3p54GwntSxy/TqTJ1HiO2HjfZmYhmabDo8OVh3XYIxzSiug5uYsvfX1/0o2EszF5XXtImLyiopdCumSTh2XENeO0H6LcITBapo+SXofNnIFFSoWJeiLd9MCuOvtzxSbJDQw3hjwha1CSwHd6CP8br5bKW64YCdGms2N6UgEz3buDP0QtxjYwPKdvRc0MHRLVUrgkOZk7oFiktCA0EMThvZENwXC4CM5xr6PvWKyKPQp3/N2HOCiP3UnnNVZkH0qTyvKoBOkJnBHEIU+eVDKlbt4KcMlZqNeHBB2NWTXor1Ep5emEX+nRJafNeyTuUTIzgrlhPcpk/h1HWrTglrf1mPKJmYQ+RZ0wuJTRs+PCxHeGLXtRZR7a9Rf6cKQ6VOnc6NBQr9hc1oirMuOhazm9yinsHZZH7IV8iUXVuMlpES3pFoARcs0pprmAl3fnqyfZjkykgMr6YyYpESKzn2gOi2FOT2i84cD+6RfZHRFiNpzHGAMuvt1r1miLQIPmfCwq6Dwgn7vrXydZpHxmDbcGnOyyejKHpN4zW60//KcesWQKG9BQh1ZwZp4EmB/MHIcbnkDqKAKhCAiX06YF8OTuyC2FjnteeAEzU41Jnr2Pu8lDzsLLgnkJz5fKuC2Q14+ocxL+w9P6OgCMG9xpd0kXpePbwo9At1m3daXIJp
 6ehLO6U4
 FsJZjF8Qo7k4uzASShGQr0J7yd57Ixefez6k/273GbexqUVGs8CKclHIy+qEH1eBivIM1Cj9ct1aohXyzgPLMpx90hxTfDbZQ+0WM0nv/XOvid+T2INBqmWyq2RY62c7tb1d/H1wJ/1PaQ1fDYJwM4ajzNl3a+I7iLfWD0ocpGILJ7APA2nn7Wwu9xyni1aBspi7+uax6zVkCcF1kb1x07XjWn0XcM58mo4OddlcpZ5bfUx2XQ7kiLXubwn4djeYDKipLK9b9kgO39lDdWx6Vib9DbPO5Lf1VhzFXwaax5VbHfPejgeI5ngpYwQEYzWPJVduQbwozzFd3YveEjpuapNw+NQtB1uvhSJnOiLLnOYX1WPQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-04-28 at 04:56 +0530, Ritesh Harjani wrote:
> >=20
>=20
> I guess you missed answering this. The reason why I was asking about this=
 is....
>=20

Oops, sorry...

> > > >                        baseline    patched     change
> > > >   buffered              1619.5     1611.2      -0.5%
> > > >   dontcache             1281.1     1629.4     +27.2%
> > > >   direct                1545.4     1609.4      +4.1%
> > > >=20
>=20
> ... If we see the performace of buffered and dontcache in baseline case,
> then we don't see dontcache doing any good. Even the patched version is
> just slightly better compared to buffered case.
>=20
> But IIUC, dontcache should really shine in cases where we have buffered
> writers dirtying the page cache pages which can overflow the RAM size
> [1]. The reason why dontcache should show benefit there is, because we
> don't see any page cache pressure, since after writeback the pages gets
> evicted. Also earlier in the unpatched version, the I/O submission
> happens immediately in the same context.
>=20
> So, I guess, isn't it better to evaluate those scenarios as well with
> the patched version - since this series affects those code paths now?
>=20
> [1]: https://lore.kernel.org/all/20241110152906.1747545-11-axboe@kernel.d=
k/
>=20
> >=20

Ok, that's a good point. I'll have Claude recreate a benchmark that
mirrors what Jens did in the original posting and make sure the
behavior of that test doesn't regress (at least not significantly).

I'll try to get this done before LSF/MM, but we'll see.

Cheers,
--=20
Jeff Layton <jlayton@kernel.org>

