Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 525E2CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541796B0088; Mon, 12 Oct 2026 23:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F30D6B008A; Mon, 12 Oct 2026 23:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 408366B0092; Mon, 12 Oct 2026 23:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3036B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:46:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B8DA1209DF
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:46:24 +0000 (UTC)
X-FDA: 85316215488.28.43D570B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 64DE6140009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:46:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cGjuDRH7;
	spf=pass (imf23.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791863182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gC6zFEfTKNW+9VnhF2BDN32Uuy+DW12hIGMiIIHt3k4=;
	b=48Opg74pPLWSghsOuaCNVqroXQnO9AuuPZbMpBQULaPQOWbdBm3o/H764DTg3bn/722XM+
	b+z7QzUVUwrs8zFZL2uk9d3RAD+lvDLbInXIWBFJMKxosoiCMn848uyfpowQGF2ycmxmSt
	OQRtORstQ17K60ObgnAcJgZbZtbqo/0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cGjuDRH7;
	spf=pass (imf23.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791863182;
	b=sOL6RB5Bji+QYLpKygRnvGZm2Ijlf2h6wD3Qyc2OM9Ww7RFm7rYi1W+DsQFMKtz3NwU3BE
	p/wOQ8ygZfbyVFpnRWdm9uqstkcpWnoIRVZ+YDllxXz0+nYZaTAscsjyKKLRWCClA+HWcE
	/1DLnKrS27WDCvgQMa92m6e8okb1/aU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76D7D43D7E;
	Tue, 13 Oct 2026 03:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534BB1F000FF;
	Tue, 13 Oct 2026 03:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791863181;
	bh=gC6zFEfTKNW+9VnhF2BDN32Uuy+DW12hIGMiIIHt3k4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cGjuDRH7fd9Q/vGOFT7srXE4MzTaO0zvziw1vupAjmuNfJNV1aw1OWZUFLjuLqLq/
	 I87VuwtS1dHs5FQ/DKdlQisdn43nyzXs9Kd4T6xzP4a1TQWy45Re6iwudrZ+5QtEFV
	 fzz0HzS82PYt3Xg92bu5uvNyIhnz725muXUX2lfYjTmpv6xKxmB0EYSWqqZOrA1zQB
	 1lEKQvnQnz5DIPbu9YI7ZSuAG1Pl0hqbabAb9PpdL1iwfvHMFjz5A/s173yYvtg3Yh
	 4I6L0EMZ5eWiwYWI/6OsZ2o19PmZpjPcEAGi5dNXnpqJVXBO2/H1jcejotXKyWlDgu
	 PjEnZQQ010M0w==
Date: Mon, 12 Oct 2026 20:46:21 -0700
From: Kees Cook <kees@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-ID: <202610122044.1E1CDBF72@keescook>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
 <38befa8c-3885-44eb-813c-0ee34cd55248@kernel.org>
 <be34b92e-e82c-4f69-ac9d-b045081ea418@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be34b92e-e82c-4f69-ac9d-b045081ea418@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 64DE6140009
X-Stat-Signature: 5cmgjphjjcauab15aorn8drwxg7rtjr4
X-HE-Tag: 1791863182-414104
X-HE-Meta: U2FsdGVkX18pK8OIcsFUEqGlFn6/O1Lbt+7aKrZxYdVAyciSVeacNwkOhIx9BMoH2Jzp7vp45mTBTdMD0xk3OvQi5F9N2i/Shdxw82aoy9a37d8C+fycTz5XaXtTD9IbXEyqIOleyFBn6/gVkyzfyWoftpI6UiBpxwseJJZFoV0OYk2mQjbZzvA68ddOlY9Rnpt80xifbJrKxKLsEsCVQegeNV/T3ggH9tZN+l3NpSzt9oFENA4OCQbZITLig5Lr9tOcGklTWL50CIARWD/tc2D+Irk90RgsNouLVgTwH0ZaCB06vBx/w3eI1/V/IDoATHtmOBNnGnrsPoCCrQJPRJMUOQi9agwOeAKNbFAVPnvVHli3S2ku7gHztpDAIHiIdHGIxxn4yYMdZ2heDr+RPCQM2d3oNFPQJ2r8ShUmeTUm6XouaARkyYDs9SXAsCR3qkqspFuPt8Mf64cDclvDdbXKBOxhQeE0C0kjZ0cAs03pT5p4X5sw9tzr/fEeoeiMoOi90gPPsOFeP7O0oLTDZ7FHx9VfUHDo9/NSBfwFJRrGPSAMygzUxtXXeqjIDkb7+G/3ydsmSoqftbIM57tSuMDC1QlK0h3m/hijs/p9cSi/J1fF7FBap3KwegrdL7s0wKnY+NGDFKeEU0thNW+wmWt6IyFz1B1SwuX/BhUFZuvVBTIruzXgBz3ih+qUuI3oCIj63IFyLsoNXQzU275U+jxxvBYwV+/1xy4bppY1ad1lcIMEfOEcKijbdSasRMkHebn1zrvf/6SoWfqO286+WMHOnSf3z4coRJb+imIE7vcMtwhEGqqqvsnp56mmpsUj5JtWU4Qq2y01A0Vc2Q2KKXdmSBsgCSu913CGcmROK2879dRHvDYZJcL/ItRqWipSFczPKzhCKUjiKSvMP/3ENiT8YvektZ8NGGuT74w62AFZXcyBsPlnYIzdgbVKGMIsYDDkcSbYweT6mgW9RfP
 TvlxmxRE
 Qmx8DjBlxsx0AEz7jJd7G50SwAIYdsYbMO+krE5FtMgAZmZL+o1DWe2yCHpBJsPRQ7rGVIUaIuAYVnCtpAx+cMb+ozetkbLDCkKgG5u8qXtVnCSD+WyRSsdIDgMkLtB0VJWgqTnT2aospMKOXAWiWCqf4VDn6U3i79ISW/hxNN8pO5i0eVBZcGIx7jm/wriYGfm6HduiTUMExr1J2DxLTTPHh9m6vJwyPojjeKg5lUQL+HSj4CTL51HR4R0CkcbRBfWKUBeTaOhJh4acZVOAO9+VNPRrNejXN/HDCUuF5yzwT4L7JqUCkf1/wPwL4I8XA7fg2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 11:03:18PM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/12/26 19:55, Vlastimil Babka (SUSE) wrote:
> > On 10/6/26 11:20, Kees Cook wrote:
> >> Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
> >> alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
> >> accounted only through SLAB_ACCOUNT on its bucket caches. With
> >> CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
> >> kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
> >> which do not account it; the same happens when kmem_buckets_create()
> >> fails. Either way, the allocation is not charged to the sender's memory
> >> cgroup.
> >> 
> >> Allocate with GFP_KERNEL_ACCOUNT again, as before that commit. Memcg
> >> charges such an allocation in whichever cache serves it, so drop the
> >> SLAB_ACCOUNT, which no longer adds anything.
> >> 
> >> Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
> >> CONFIG_SLAB_BUCKETS as y and n.
> >> 
> >> Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
> >> Assisted-by: LLM
> >> Signed-off-by: Kees Cook <kees@kernel.org>
> > 
> > Could we, for the purposes of a backportable fix, just have both
> > SLAB_ACCOUNT and GFP_KERNEL_ACCOUNT in place? That should do the right thing
> > regardless of CONFIG_SLAB_BUCKETS state, no?
> 
> BTW we're thinking to add 1+2 (once this part is clarified) for 7.4 (with
> stable@ for patch 2). 

Yeah, I'll respin with it present on the create and the alloc sides.

> But for the rest we'll have to target 7.5 as it's only
> a week to the 7.4 merge window now.

Yeah, that's totally fine; I'm in no rush. I want to get it right, and
I'm still recovering from my surprise about how GFP_KERNEL_ACCOUNT
actually works. ;)

-- 
Kees Cook

