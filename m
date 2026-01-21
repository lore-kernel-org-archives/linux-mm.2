Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A676CC4451C
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 12:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14DEB6B0089; Wed, 21 Jan 2026 07:04:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E8B6B008A; Wed, 21 Jan 2026 07:04:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010BA6B008C; Wed, 21 Jan 2026 07:04:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E72676B0089
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:04:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FC82140CE3
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:04:04 +0000 (UTC)
X-FDA: 84355837608.11.5CD2B28
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5A8441C0011
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:04:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=OznsSF27;
	spf=pass (imf21.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768997042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7j+sEH7m+daksLB+ZuBKTUOnUZv3+6k0Buxb2N1uXU=;
	b=fF1i+eoVn8lecwPOwpSY85W0VPqjmHGCQuhevSyLneRThaKosD1FqSU7joxImLD4Vwe1Jo
	a/RdvS4bCwwOqTG2TN257TfWZqrtj0nZxIo/36beOKm+wWjiXLiOfnYp61w6jzPtn7h+aP
	ROgBISH2/jEF0zQRs1xwDgolZ8Jym0k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=OznsSF27;
	spf=pass (imf21.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768997042; a=rsa-sha256;
	cv=none;
	b=BCThCBo6cMs1QJUTdsB3tAmDoGVcsz3WQzDEHmvXfxejhypc9bFalGQr0fWILpViQ8diAy
	9/k6LjGtjiwaHnQ5LCSry3ihEZOZzo+F6Bwom+aJSfBc5fPrkFwdqjyiHgyvyqB8TL6uHw
	TC9fy9nxZOIuLsyCSQlDfKqEBo1mb0M=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D4D5A40E01A3;
	Wed, 21 Jan 2026 12:03:58 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3bUkssn9ZTO9; Wed, 21 Jan 2026 12:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1768997032; bh=j7j+sEH7m+daksLB+ZuBKTUOnUZv3+6k0Buxb2N1uXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OznsSF27U01oslR9kU0n0fpXNwRZLjT9+bRMs2jZjuatdFyi620oVLJwHcrKWUWfE
	 /4QAsI+bYZ8a/KAlMZ9knAt+u1iYykLD5Wfm/RDdcfswjfk5TXm4c0AL02Ud1jUsV8
	 j86lndZyXIcwcs0XszpGGoSOFS7YZ/2LDiEPEbaiWxVZSiBnamcM6F9yDH7h9i7LrT
	 /Z1b6iNkIxDwOvAojYajFCrGesCIGckDIor1MbEgedABbX7xWdB24QK6DY8UlKelj7
	 rfa7LhB901D/XwX0BXX0AdQqXvjz+9+7wEIq8xpYKj21KTXdOsCoC1uV4r3VCUijfC
	 Rz0zV1Y4t8SNBIZgyB5dw9IDjbTvd3nQNE9SqqZ7QUAL8I7Gzhno3dX94Dwj9w8qTt
	 tKF7HPd4PyhEHNOTKJEIgdTKDqns4qhmBPFPfdNPrxSjpaHqmeGyfMZV2wjIwBFQaJ
	 DPYWstKchyWBkqmiGZVKKUSngm7yf/G0nlyHHtfstDJZMre6lbWMoSylSI9nQKMYIo
	 PSnlXsYwsKYzghhgCJi4oUXVhvdI14KDF8YCln1Gpcj+OYzGlyIOQkn0SmEaStJFL3
	 liaJ5zYNnHDA3/XaVsSKXrH6kq6Kjvr7eWAmlHUhFSW7jSYinRUqKEsW1hFjSygvwG
	 OmTe4f58GoKeff9zIfsSkDKA=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id C1DB740E027D;
	Wed, 21 Jan 2026 12:03:23 +0000 (UTC)
Date: Wed, 21 Jan 2026 13:03:18 +0100
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
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH 05/21] x86/mm/pat: mirror direct map changes to ASI
Message-ID: <20260121120318.GCaXDAhqoU8Q0PLTX8@fat_crate.local>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-5-2d861768041f@google.com>
 <08338619-6aa1-4905-bdf8-bf1a90857307@intel.com>
 <DD7WQ97R8OG6.1CA5E2FU5ISMZ@google.com>
 <19e5012a-3c58-4696-9e4e-39e2b7d2b5af@intel.com>
 <DD80374YZEWM.1L31D2VUKK80C@google.com>
 <20260120163728.GDaW-vSLGY1P_E0DqS@fat_crate.local>
 <DFU660CYC3H5.3L7IVBXG8AIY1@google.com>
 <20260121112738.GBaXC4KgFQ2J667ea5@fat_crate.local>
 <DFU8STXKQXN9.E9NXUMU72SFQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DFU8STXKQXN9.E9NXUMU72SFQ@google.com>
X-Rspam-User: 
X-Stat-Signature: 1wzi1qzwickhzgyucpjbztqbajnx6e5e
X-Rspamd-Queue-Id: 5A8441C0011
X-Rspamd-Server: rspam05
X-HE-Tag: 1768997042-310186
X-HE-Meta: U2FsdGVkX19/ZIOJmVxw17H+rp1ydEOr8jSuWg4Tr8ljm8YiQWn1/C+V+JTmEl9OR60KYTV1riETYrPR5KOH8Bzo0a5XjX+OEB9oHCK5xanMp9UQuHXP4j+rAgHb7QAm44cVdMXZAalwp9avHgV4/gIOevO05psAB9eNC2/Dr8xLoIoUxk31cmJAMbzR8obwkr9gJMpRgWL5dJ3DPqQoMeKG3HUu8X2Vii4V4oi3CWaDlOogkm06YLRc3bRVuM0V3rgP3JZaWQrekEPdgUL+JWCC33UoV9pCldEqaEkJO80/nPBknejrKBiHEfwNvej6qogbxeV6wSkFUe5l2UapoyhzdlWMcB1S/EEFx01w/h/PVXuERKNoS6I1xOrtMoqqWRkxiq8gdcs+B8/7Thi1N7FLQ2vz7lH/tjTSBwII4TerEqO44f8LgGoDy+RqyUmebQwY0ttP4AOSRdSjQWWXY0QTY0dnlWkefKmFkpudhnLS3psFNqdBclTur2JYzTVwaYDbVARp2cpWWtDT8U7dIrFhsgskdgcVxV/mBFYHHxri4qx5EYxn/Ip8WAY0Rn0uBLnIWTGYgsBFiazrE6f3RyeZHPgaGRJeSd/tRh9FMTkDfmzgKMM6ljAAf1HoUMIanG2RcOjQPPJstPRrd4bc+Bs+Kl7FpWZb5o67prNqQLPy3u4bkiYIgwx5LSpjy2wupKgRUb5B/om3zlJQ5lFsdTXB8ktBh1URSJTRyN/DQN4YWeIbbIKbwARt/OGMqIPyGhcm+z8q/lLMxQCIIgyrQJM6gGTSLYQm9WFhwEWmxBxeg5p589STbChfyyjvCEoFUN4gqCFhitUNln6x0tx8IS0IkkhMy1a8dCo1/qa6vt0EZk87SnNdFRAncczxhA5+kdgvQqATd+nnQ0Fk8YyRVOXr73zIjtlG6TAfX8gex2sukVY2/HX5WS/l1VumounQ6J+GWLGrY4q8fydY3UK
 i3TfPMu5
 hhE2RUkmgS041DCLxr7NQ7kX0YMEkOJfW3k3vxls7S1aMh6wxjCEJSFXOSFBqLvTP8CQIP2adxNv3M6Ue63oHNesNU/LxdLnicFx4HqiQ7d75rrIFboaRoGG8oJkkpiJR9i05UCEvHB0KLjPj5AZArbuizjqBbJga0SJgZOKgJSEBR+q138k/NtLGS860ka1bp9sgHe3cdXS/ckiaWTZCB0UQidAxR+SLXzmAK+coQbNpb8M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 11:49:13AM +0000, Brendan Jackman wrote:
> Well, something has to manage those pagetables and that thing needs a
> term to describe the stuff it's acting on. I.e. we need an adjective
> better than "to-be-mapped-into-the-full-pagtable".
> 
> Anyway, I think this will be an easier debate to have once we're looking
> at actual code etc - I'm still debugging my page allocator changes to
> support the guest_memfd thing and that code doesn't need to care about
> "sensitivity" at all, there's just one address space and data is
> "mapped" or "unmapped". So I propose we defer this conversation until
> after that...

Ok, sounds good.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

