Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89B6606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cTGAIvl8
Received: by kanga.kvack.org (Postfix)
	id B4AD36B06F7; Tue, 27 Oct 2026 08:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22D56B06F9; Tue, 27 Oct 2026 08:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11DA6B06FA; Tue, 27 Oct 2026 08:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5766B06F7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:23:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02443C09C9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:23:10 +0000 (UTC)
X-FDA: 85368320982.11.6B67E69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5A66B40004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:23:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cTGAIvl8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JH82SQPddTJN7QL/zfTDbgly6+w34WA/Fx2FsS5gJX0=;
	b=VD75d/oTWksWjEJHwjqt1X5NSc4FOtJ2LJr2+/Wy5A3TJvfSmG6CZ6+e7OTkcB5fSEBzep
	YNFUHEcSHmCXxaZdI7z7KkwahfUf5DzdhbF+/fXuyINg3N7bC188Ba7KX5jQT5V7v5fj8c
	3fNqoDgROZJzhmP234gm6kwIASkjaWs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cTGAIvl8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103788;
	b=eoI69NlyswPuarK+2SMbzheQF7av9TMmXHprzdBpNgv6FRfHPcffCMvwXL+LKbEgjHqQa8
	UwUuoL4JwApgiCxKL8BBllV9Qn3laIOs8ocC4uZBT6NFLA7rKwiRTyMQ+f0uyelDYdh7Cl
	OawrQmOtkRjBOrpe2bJoTsOpNtCa4sI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9100D43BDE;
	Tue, 27 Oct 2026 12:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7F61F01828;
	Tue, 27 Oct 2026 12:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793103787;
	bh=JH82SQPddTJN7QL/zfTDbgly6+w34WA/Fx2FsS5gJX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cTGAIvl8KYAHXGMTqGOQk68gsniw9gx8F27qvbylYCwXiZAkK97itRAPuz+Km69z4
	 l5qVom+jPX/FujKiJ6g4N913fr+YRHsXQxEL8+pFUsh/WJtw0lDnmUFjYnMLWBCFdc
	 57ODOoIud/rWWtr6vu2w4+LSoKCYzJH17grJVSjKUqZZC2/tv7aZ6SmPgAME7UECK3
	 KuYJZEf53Ueq9VReoyDmf+ufsMyNf8EYyupuBFA3EBVKgjcD1jO5HLumBmQXO6SfSX
	 JOPh+lyss3rYe/13Uao+IZrYFgTvtbnu8SxJbxWDDcI1gyjlDPzn7+ghH+GMdWe8Y0
	 Wf9ZKgUtTzSCQ==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.ams.internal (Postfix) with ESMTP id DDFAB198003A;
	Tue, 27 Oct 2026 08:22:58 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Tue, 27 Oct 2026 08:23:03 -0400
X-ME-Sender: <xms:opfgarAkOIR74toP6hkDm4hzLCfGQYFCfhEhfk01zfxeDfHJdt1rxg>
    <xme:opfgah83ME6NZzWbkbNozB2k-g89XlXI5GXyiJwmo8FgcPu4M7R5CJT8nkqZIGw3u
    YoTl63A1oEYW5gfV7RGxJg9MuCA8n0Tgk4ZTJe-S61Zdhh3f7CzbJsg>
X-ME-Received: <xmr:opfgaoDoA_su67fQ0_Fhwb989zrijEY1mAcviOvIPNP1jmGNjiHfZ_C5aEw>
X-ME-Proxy-Cause: dmFkZTGoVod3f+gzQyI5zh1cNfz3B/lNl8CDem1gpH9oo/zANXaPwl4/lEqCJQk8zhtrP8
    e7wY2xOwNY02y862sCUKLrBcae/3k5Mjx6jchUi4fnRUF6UQHpQUbtomDtloc++Mt4EgSn
    6OV9RwY8x6EJTliTPczhJN4bwoD1ZHOdp41L3oJAKvV08FPgHXZUAzX8iM6M1RdDjWD8pR
    flOlcktTO34RfTZi2p3OTP+In8WQYMN3c5GjXWKOEMG60YIxkwPPIpuqZOl4C45T2eDwgW
    PusULDyjW9qdpswwCkeor1T4yxtGU13QXTc9UC8KmEmi1bBuXRU1OfZmyA7pgZDHjUdQlO
    eTlCLrQybSUeUm8OclpYFgHiYR1SQjwWU2EwgbgpPq+uzDLtCMAnmG6d21lxdDOc7zZYVZ
    qpoln6Szr0E9lNDodnbNfhaO7NFtKowYNfwXS+qA3SreBzDEv/1UbkZ20VF5R9kZ8zd5EZ
    EdQkIg1e2QQUmFVzGBmv6m69wiFiq2DKcfJ/YeYzEri9vknsMF1POuw571ZzzSc+60r1IN
    U/Xx4NiWDE5T3vyWJ987ii2GbtrGHqbTbdJAxro2VPZIxLXMz3aKaNBoPaoM1F2ACL6VEb
    P4n2bL+zkmkGncjs+41PFLwOkr/kxOR2XPrab+i03BxCQy4AjAvowYNZ7qNw
X-ME-Proxy: <xmx:opfgatwlOOaO3u-M7qIJwbOTlyvqeCdmAWaZ7aiELloCGUdpNVU7zQ>
    <xmx:opfgavoySzDzAfoxLc1H0-acvIkZ__jv_lnKNrlz01s0emfTeoZHcg>
    <xmx:opfgaoyL1LIDX99Q-sC8wT-79rA1MTeeGbpgpHTuo51O-hl1-nLazw>
    <xmx:opfgahNFbSFQotsSREFgxFAy5ldq_Ws_JeARrpcX72LIH1y3MFysnA>
    <xmx:opfgaieOHSnFuqEoCD4VythpZOMKPLvazSko064KPu3HUzqbpEzy0d__>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 08:22:57 -0400 (EDT)
Date: Tue, 27 Oct 2026 12:22:56 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
Message-ID: <auCXVv9yXtaS42w8@thinkstation>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-14-kas@kernel.org>
 <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
 <at_f43oDv73y-t7O@thinkstation>
 <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
 <20261027121323.GO2668564@noisy.programming.kicks-ass.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027121323.GO2668564@noisy.programming.kicks-ass.net>
X-Rspamd-Queue-Id: 5A66B40004
X-Stat-Signature: jbfmmn8cy9rrwys7msr5rk96a7m6xxpq
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793103788-556711
X-HE-Meta: U2FsdGVkX1/M9ay741CnOx3oQU0MzElEj0mp/XeYXOQuiBKgvuOTFpKI0CC52UGdyHgcCvYM5VRm3IxgZBC9sS8dwyk1k9ePnsCjVJ7/ki7C3dh6D7UKlvUyGbErL3o0HNqtxl5JtRetFgcD01Y1LzZS+npfEuqgtk/n+cGqSHnGbrEr7ajMzBU9gf8E9KzywWCia47aGRDhgxFyC2Q8W/eq4vu+Pnoc6yCtztHFMmk6OMdC22dbUhkC2kCjg1/li9C2gOz8/y6hW03uBPHo7hrg/IEa0Dsie8RUTd7Xv3Io4Buxg5hsfTV1gL1Otd4XCZEPMxuijcn1l6amqLlW5VJmYLaIuoCT5dgctLomB+Rt2mryAcm9873M/ItwunKFssKpAFaZzQr4q+/lRjREMwsZcg0vuKAsX0pVP/nwigyl8Lc/vu8LAHjSjKUPnejYs1FWqvgF+4AMUdafNyygeT0wPbCfFOrUlXQNmL2Qp71SyM3P5G4FzupcIaXvcwWsFLMoL3gW9lq0fuXRIVFQSh8w2Z2Y3austdgaNuD/ZIdYe4bwJJMJ85UhYqv2qWqt3bgRh7NkV0N/HXhzdLsrKpyNWiBT/2Lakyn01wjhzhDkyM/5wyxYUWDKASkrYgiqm00y6t07tuWnLqbjbEDFsls0SijWPYPm1+PFikz7HYE6d74S8QpElM8LJB7XKtB5dNXPRYsxjMA3+Nha0mAdV+M9EcgCRMJ3813y6kP7t0eWGWyc1WBTg2pRpXIDW/qEeV7xEy8E42ldJaafWqK/StE7FJ1S+k1S+2Z9skfDXyrt+NKWz2Pg5mtbvw2jbrnlehSXzAE3HDpR/RZjfvUI0TI3D6jC6y+B8J14YeksSm1EgvjAELjttlUwvVkjSJnoRGzS87PeAH3BOx601+4cN8e+SzgrvpTEm5ylyHZBzraKRM1pO4nFS0W75gsZxGXAUjLrRIGrkjPzZyfCZDI
 Q19vXFyj
 4xwxHe/M/FZF4POGd3rWvDtJT77l+GnrjAYyQndyge4fUW0NYxtrgPbUIWto/me3tMPXRv8RFkoD+G0/KFZbevRTxNdoylwfZ2uBrJ/gvfFhvZQ/wM/SFu3WpWEDF4k86VTGKE7XGYK2t1BjH4jnIADgr+8iclrkw/VBTo0os1NGZU23DASOzAHb77kF6icifyvEGZrDPAM7dajIIPn+YJK0gdnw9aHWT6IrQrqqy9djfgu5oniwEHfBiHALCS7njYV+L9e0QDgAtbb74K6B+KqJGlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 01:13:23PM +0100, Peter Zijlstra wrote:
> On Tue, Oct 27, 2026 at 12:00:47PM +0000, Kiryl Shutsemau wrote:
> 
> > Fair enough. Here's some context.
> > 
> > HVO (HugeTLB Vmemmap Optimization) frees most of the memmap of a hugetlb
> > folio by remapping the struct pages after the first vmemmap page to a
> > shared page, mapped read-only.
> > 
> > Every lockless get of a page reference (e.g. page cache lookup, PFN
> > scanners) relies on page_ref_add_unless_zero(), which is
> > atomic_add_unless(&page->_refcount, nr, 0).
> > 
> > The page can be freed and reused between finding it and the get; the
> > zero refcount is what makes the get fail. The race:
> > 
> >   lockless get                        other CPU
> >   c = atomic_read(&page->_refcount)
> >   c != 0
> >                                       page freed
> >                                       page allocated as a hugetlb tail
> >                                       HVO remaps it read-only
> >   try_cmpxchg(&page->_refcount, &c, c + nr)
> >     -> write fault on read-only vmemmap
> 
> I missed a little something here; page->_refcount is in the page-frame;
> how does the page itself being RO affect this?

Emm. I am not sure I follow the question.

The memory itself is not touched. HVO remaps the vmemmap, the array of
struct pages: the part that holds the folio's tail struct pages points
to the shared page, mapped PAGE_KERNEL_RO. So it is the struct page,
and its _refcount, that is read-only.

For a 2M folio with 4K pages, its struct pages take 8 pages of vmemmap;
the last 7 of them map to that one RO page.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

