Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E589C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12C976B0093; Thu, 30 Jul 2026 07:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 104816B0095; Thu, 30 Jul 2026 07:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041926B0096; Thu, 30 Jul 2026 07:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D977E6B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:17:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64591140980
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:17:27 +0000 (UTC)
X-FDA: 85045192134.01.5306E30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id CD6721A0004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:17:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJSn2uKq;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785410245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0EIPu9PN0yu7q+s4rPgyOAd/4Zfoyra3jhu843lc4c=;
	b=nBc4TTwhixqNGhV5mnXATlw3xAoerVif711QvIRJgrcT99sBGCSkecbR2Zh+fNIHVKuCBu
	HMzPzAtAqk8NzyhhXM5W/4E8bQAG58xLmu4xoIuNKgvjwdhjuqNmeuGixnD3SZEimgIGQW
	QQ2DA9mt//JGf/g2pqIsJXPUxtnqeEE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785410245;
	b=ozE9b5ZuqdnBQndMkCxBL7MP48TCvIRidgsnHyQ0jA8ULFg1ZJE9RLEKe1ZMKoPTrO3bTt
	SJVtbh3KZ2/+b4ugaXoXl7cuSyrv/mhp2s8VY/Ewx0vQBOrfl5UQnK6jlJSsJL2x7G1hO2
	EjDkwIBCL2ewjVpqQXeH0ZEcgMkp4TU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJSn2uKq;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0440B600B1;
	Thu, 30 Jul 2026 11:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9288D1F00A3A;
	Thu, 30 Jul 2026 11:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785410244;
	bh=J0EIPu9PN0yu7q+s4rPgyOAd/4Zfoyra3jhu843lc4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dJSn2uKqy4X1N8KpDU9tw0HfzTaEO2Pj6MHEBeEXgjSVM5Xbr7EZVdWtj3WSxKFM5
	 adOwt+KFYRhEgEorTkdoEUV7gHnv13kdZqukzTfqtuVipJ3B5uCKc3XoasaVAVqSzl
	 hQ7h+egoWcwwlM6k2yeAtbaMFRVC9VrCHMsnv2G7Sohhnuzv5XptqxN+RKP+SvuNFE
	 Rd6g54eipNLuFBelDtsKnFmkiMA5vXjQRdmTnMnWHcgsw+DIwT0iXkAAar6JrjxrRZ
	 2PTQK3hHN41LuVF7FEfbokbmneesooU2GWZC6RfcrLXZqvmIP8r6Qfq9z49zi0ipRm
	 eODOrYYcUDPEA==
Date: Thu, 30 Jul 2026 14:17:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH 3/3] x86/mm: Fix and document DEBUG_PAGEALLOC
Message-ID: <amsyuUq_JDh9k7J6@kernel.org>
References: <20260729110807.797920433@infradead.org>
 <20260729111119.604452135@infradead.org>
 <amoKo2LoJvfndqHn@kernel.org>
 <20260729144838.GM651302@noisy.programming.kicks-ass.net>
 <ampPb0o0T_JdxrMx@kernel.org>
 <20260730104333.GE751831@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730104333.GE751831@noisy.programming.kicks-ass.net>
X-Stat-Signature: eeosshhg98em9sta9biia85ww4x8k83s
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD6721A0004
X-HE-Tag: 1785410245-741751
X-HE-Meta: U2FsdGVkX18T/puRBk8Bp/kxO4ShVfHUWenvA+q0wpajJXUt6MgNJy3Cp77ClJ0hywJszrP8VbnWbipBERjDZjCDK15pvL69k6i28r44FGsx4u6PmJY1Isu+WNVIMpx+egokQoymzhaYWw1owTIf4VgEto2NqupwjIO5ScKbw/xetRjn9OGUP8N9MtS01Jo5TwmCbk8WpDXa0YdBV9I6lJMRsW3/ihr6Xaeko/sSajeNpWEQA99eYzx4IKEbY4TEYxhBos+D9g2QS/3l5y9gSX15HCt/Ek/UcNa2PvXq3UGb5jr6pQtGcnm7n21dBMDw1n1QbZ2JBGK01PLbxhYNZ94GIImfc9EQNMQ649rU8dSKKhGR3GT4UscZd1T8nryRihTxe+a/JnZxKjGk7T6F5GUAQO/OgkzKY9pqM7p88lBI7ZaDpF+M4mzv/x8pjIx+CFPRM2SYW2nkmMWp6XySfTMgFZFp541d0JLkKfu2GtyIUNfa5szgFH7XGkCj2XzEIZWWy9SXb+6FRnpBX/i3h61z1AZrsmAt2PTSW7QqA8ijj04Hgvx4zpF+/IZE5xT1hMCxiys7sMhDhLJKmPGruUwIJ3XxHG6t3e/0ASn4OGSzb87CP4CvgNtnZVFCqbcB5NyHmYSRYuYEpDg+Cw+6BLQeLoplGCXcRgbOrsmTIAEhzZ75FPJbLyXjkNr4RpXUIvuPOy0Bj08LzXnwNoxJpgIF2IJ3ixPTMq50Sa7J4Qo+32S+gRIT5JmQhc86S9skiFsZss+KFL3D3xq74FOaKtJSdxRInwCgl7RaXI3B/Hi52536PEZFNEIOiUiTweozWYyorICq0nHQZgpdEbxTCWHMvHulDT6iv2LkFo+gzT9zL65z/kAVyaFXcmPxtp1aQif0xD99d+AMWgy2m6D7CAKj7mjaf3bJqwCH7Hd/KzEEvd2tWh33eeMkTRL52JlDkS53UakwloKa3WzJdlY
 u/LeMkl+
 IJZgPAAVGCwafUCkl9HBb15d8Q2a+bCE+1MDTG0mjY+LRK4ZdLyI5LKEhe8EtQDFtlemjeYw383e2BnXF3eVyKu7Nyu/vFc/uT6mxWBC3pYssYPZ/qGM7etGzWE3aOvG7B4GdfmKi3nbmHTB3kk6V8OXH43BbS4d8N7PnBIrFKc405OwZggY8e8eE/GnbOuV+sAQD3I4j8R+pG+b0FeObvGcbuoQltRp8vIVfIHnEK0tst7d7WK0e3D+DYj/irEcThSu8mT5DkGtbodWkcqeTG0cUe+JhBxl2WTfbtOTl14d17v+4D1iuewcqWVweGCgv2bTb3NieGxkw28I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 12:43:33PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 29, 2026 at 10:07:27PM +0300, Mike Rapoport wrote:
> 
> > > > I like my version with your comments added there more as it localizes the
> > > > DEBUG_PAGEALLOC exception in the lock wrappers.
> > > 
> > > So I don't like removing cpa_lock entirely; it is still serializing cpa
> > 
> > I meant static inline cpa_lock(), not removing it entirely.
> > With your comment why DEBUG_PAGEALLOC is special.
> 
> That is, I despise the whole:
> 
> 	if (!debug_pagealloc_enabled())
> 		spin_lock(&cpa_lock);
> 
> with a passion. It blanked kills cpa_lock as whole and changes the rules
> for everyone when debug_pagealloc is on.
> 
> cpa_lock ensures that concurrent cpa() calls on an overlapping region
> have a well defined outcome. By removing it entirely you can get random
> state.
> 
> In practise this isn't likely to matter, but relaxing this for a debug
> option is insane. Debug stuff should tighten rules, not relax them.

In practice it's the same, either the thread that won the race for lock
updates the pte or just the first one to get to actual set_pte and it's
pretty random for overlapping regions anyway.

But I can see your point.

Anyway, we need Lorenzo's fixes from the set I sent [1] to protect against
other races and they conflict with your patches :(

If you are planning to send v2 maybe you can take them on top as well?

[1] https://lore.kernel.org/all/20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org

-- 
Sincerely yours,
Mike.

