Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 397CED3F08E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 16:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DCBB6B0005; Wed, 28 Jan 2026 11:29:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3C36B0089; Wed, 28 Jan 2026 11:29:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0806B008A; Wed, 28 Jan 2026 11:29:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA686B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:29:57 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8D63D4272
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:29:56 +0000 (UTC)
X-FDA: 84381909192.05.5BFCB5E
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id BF322C0006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:29:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=DnlvIKsp;
	spf=pass (imf10.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769617795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AkBNSZsN9haLUZALrG85Bpqhx1SbTjrtFwWDUmDpT6A=;
	b=sADe5jwndYm+b06HF9WZ5+NLpwUTGzQIIdqEqpDdZeFkxWTnNAse/CvfJ5R0BpZoe6v16D
	XArWaEOvbD72soaudSg5lbOcjY+YIL2s5Xx+YOo50XCe+60p1x3yAsN2mW8s7TdwdnjqVP
	vM4OGjhfFYyhOhT8qSykqUhmix+Syzk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=DnlvIKsp;
	spf=pass (imf10.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769617795; a=rsa-sha256;
	cv=none;
	b=bTe1+bmf2kVxHC97aFuBedjRVmVjTilRwumX36uOtrOWqnci5aMAE9v56xPlhEQkrz4UL1
	bcI3ce/3pgcOFIEg9NRaMaqQ7wU3/vl3vSw+vwQrJ3lRpVjRnI5SkSHoE9l+Lh1i2F+dUT
	NdDp/jjn25cWEtt9y28WRrqWeptF5fo=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B3ED040E01A3;
	Wed, 28 Jan 2026 16:29:51 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id wTmXdpBXVDHP; Wed, 28 Jan 2026 16:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1769617788; bh=AkBNSZsN9haLUZALrG85Bpqhx1SbTjrtFwWDUmDpT6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DnlvIKsp+JaDr8QaY/x/h2k0ICj/t9uuh5SllKwetId6B9ZeCbKBzFtXoEtIYpK7S
	 Z7tqRWckd4Ra+fxKNgrOjCl8psDcSJjhOoyo4SEvFCZL77dwUxjB62cH2aLCbUgjW4
	 iDcdWTq+YvEl8aq1Oa+dMxKwnfzze34hl1o/68FHBi8oXIWjJmUD5ATgTZ8S8+mO9p
	 z3d+KyFj58BJXslfZnLfJPGixzbHgOEANeGO/TadmfwbLu/+yLmZMoI/uzouGPiXyR
	 N9tJob4pdJcGXZZ6XuMl/8ICavkgmbYwRvnx3cAKMIggxict93DWqvyV6gaYtcJge2
	 N+KMq7t2mOSauQgIpn3+rvkI3mQ9xXCqe04eHSdHLjJDRmqIF+lFCHrR95Gx9aL9Ru
	 aqHmT3Okwdm3nPV/GVJ8hm78goY/TKperJ7bwskiIOXRVeW379gHBTo+C9nRKSi7Hy
	 qeBz2lHNbDYBBTHUpEw2T15EVnxOoYAusgMosCeixWcBdQYo1z+Zh8Ag4YoUzJJKR2
	 dl0yTy+5twsHi6fqfjjR6m0lxvrLW/Uj3ly85YmFkIhDzLmFjYskF7zlwop8/P6U7P
	 tzy8AmuLylkNoUP2KvGClMZgolc4DJhgcns79tZCbtnbbByNiyToI9SFE4TN3rl7sv
	 mF1baVEl4VJ1pwtO5FZV7pAo=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id CFBC540E0028;
	Wed, 28 Jan 2026 16:29:19 +0000 (UTC)
Date: Wed, 28 Jan 2026 17:29:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Andy Lutomirski <luto@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, peterz@infradead.org,
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com,
	rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
	yosry.ahmed@linux.dev
Subject: Re: [PATCH 06/21] mm/page_alloc: add __GFP_SENSITIVE and always set
 it
Message-ID: <20260128162913.GCaXo5Wch-bmKzIZuj@fat_crate.local>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-6-2d861768041f@google.com>
 <fb450443-07c3-438c-888f-30540935da15@intel.com>
 <DD7WSY2PPABG.UK6GJ98WZS79@google.com>
 <20260128153834.GNaXotelMi3QMuvh9-@fat_crate.local>
 <DG0CGGDZ2G7J.54SC3XV42CWW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DG0CGGDZ2G7J.54SC3XV42CWW@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BF322C0006
X-Stat-Signature: am7n14mc6brck9iht1ibhzxpt7wzsqtm
X-Rspam-User: 
X-HE-Tag: 1769617794-33288
X-HE-Meta: U2FsdGVkX19DX+BaGQSB/jptSOt4OKyJsRyPQq16QAu8KH1Ln8MDtamA1BEbORY6WboMflGZXHNhKoA2ug09xrXXcQPybnIOWGYOCJ8Ne8mB5QULqn1XAbDlQHM6cpYAaQ/vyaQzDARJgo7yNvLjnMJM9w1z8KCo/Bq/RX7e4hTNnOI9VphaDHkn2fuH71u31+fHVDFoB7uq00zo1F+24go1MdxOeCeX+Zi0E56NFtzIAH0csnEWYNFgfDog+zqKotPgxGnoGGqDcbav+pgXr5UvXGXJE41NXc/op7IyGd375MXWJ7p5k94DJzoHGOTEf+ypDATFs3l+RbMrJ0DMLifobtJtP9cxkuffHfm66oGLobV7SaJN20yMnvijvWPlXayxiYFZxlFnbsVWTdXTqVcBvPzT8WfedlZWulAC+kPAabPA983dsYP+1snNOZHTdWHpb7LDU6tBrB4wxOnLe9tv3Xj9iFGO98yfWtEPSUCb9cNc+Cwr3ZCxS565SE4pEuhbrJBsxgFOypTnR3sLXLu9nd41adsPo7eeSbFtlZsXvZ/7Jol56YTuB9Q0LpEI87sBZmWYMlFYyVYrd+x/rZX6gADkHFmYDEx4lNlq8l3m7a+KiwLbXjW0ElOIRnO1ha3qOdNYJyjzLVKe8QDCs1CofeRWE6rfnfXdk/p+C8t0sUNvA2rNns55uOQ5LPBUgOMR1qyCYgSzj0fz/Ylmh/pyJGwZEs9gt9IJMS8tIELssguYsxtU0DcnBJpcaHMAlhW8cY0f6Z2lqvJhsvsNJwZRGlBDrMz8bLP9tCJMqs6TcWd3uYI4zL/SX9mAAhaG3yWiwsk2C88+SI2dKZiMCwFdZANfvextRBCMEWDUAXrsr9xjPjIUh1s/4KzNBlh6i46NJ1pSmgWVWdLjEt50UTnw+B9YiAgw5tZLAMaXnLNCp+QSaYPIUsuDh4IkgkiN6mv8/2KCJi4Vv1JOIBG
 6PS69bSd
 RIX1t2W8Puj4+7LB7XbAMcd5Z2IMe0o0va+DNKofi0De7GeD8nsE/HzIwQHYudNuyxeBsB6lC41LkWdGfrcHhTcZbMJ41eHRdMKiNMc8CpH2SZ7KHInGC65anTnJQZ9ByqR6hD1hxSLpX01KguATZqAbF64B9/B8Mk63E6CYLyTtBc/j+PShr75R8ZaRrEjdvxamJ4sMoIgj9bVWTPFNr7ZpeYLkoMWD00W8HC5WhHsSu65nVkAHz6XkKw13QciQsZlrYrZKB++GF1krCLqLQhtyH0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 03:57:07PM +0000, Brendan Jackman wrote:
>  Yeah, that time has long since passed, I'm sorry about the delay!

Nothing to be sorry for.

>  I'm working on it as we speak. The submission I've been trying to
>  post for the last few week is to add a __GFP_UNMAPPED flag. That will
>  unblock the guest_memfd unmapped usecase.
>  
>  I got some design elements wrong and had to reimplement some stuff
>  during January (I had an AI review my code and it pointed out that
>  part of my pagetable management code was garbage. Spooky).

Did it say "garbage"? If so, yeah, you're using the lkml review profile :-P

> Now I'm working on integrating the new version with the guest_memfd features
> to make sure it's actually fast (it's quite complicated so it had better be
> useful). Once that's done I'll hopefully be ready to post....
> 
>  _THEN_ I can update the __GFP_SENSITIVE functionality on top of the
>  __GFP_UNMAPPED functionality. The former means "don't map into ASI" and the
>  latter means "don't map at all" so they overlap in terms of allocator
>  stuff.l

Sounds good.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

