Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6417CC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA79B6B0088; Tue, 13 Oct 2026 11:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D317A6B008A; Tue, 13 Oct 2026 11:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFA3B6B008C; Tue, 13 Oct 2026 11:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC036B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:56:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E4DDA8C44
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:56:56 +0000 (UTC)
X-FDA: 85318056432.10.0A168A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9D89D4000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:56:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jKjG9aqR;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791907014;
	b=uy/TfBP6AZMRjaTN+9STy4QIzNpv+DZabsmq+9UOqmwMcsC/SQXlpBdm71iN2Ym99JQNbk
	4EqCWqVycgTpJQBgu56HKuLlSEMFwkeNaxPVWmtHn547m6V+MVL15pQfG/TQ8qpjyZgtSS
	nSLbJZ6UY4JtKeFluqsEvW90k9plF+Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jKjG9aqR;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791907014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPx6DSV+4j0EiNoTg6BI5ljLh5I5fhSgaI3qnLWLPmg=;
	b=ZB8vqZuVi1THQ8TfhyC1JHLZ1xRbHpKTJJXBps2EBaBKBrxtfh3yjKK74q9CFDAT+4wOAv
	ZBRUBIPxg5fDSvKWheyVJ7jfLVqvVJMLT24K9J6w3CyVb63YoRj9GpYoF8xRUEBlv+SLvQ
	4dCMyT3u3EmeXYjBV15UKdOm69O/zL8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35FE460A5A;
	Tue, 13 Oct 2026 15:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168301F00893;
	Tue, 13 Oct 2026 15:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791907013;
	bh=NPx6DSV+4j0EiNoTg6BI5ljLh5I5fhSgaI3qnLWLPmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jKjG9aqR/NFKyzM9hSQJgqgrhKzeAMUeH4nmyVQZBF18/6bLwiIA0wwCIoJto4wQr
	 mYTcRSCdiNFskdTNuU5jjmNNQwz3rw21bVgIAi//rvVjDW1qOy7tqBqTowFYsOWBZ0
	 DG66fN7fah7/IN0x+OGv1P7gTaoAlaZASZ0zzbwb0JG1u1h3bUxS74wtuRw7Jfii/t
	 Bu0fiGWwGEqZwxAgib1ftjVNEjUS/5buDMB8sVPXJMrvAuNZCsvHLVIrC/fSnMVkqO
	 saPja/KSPrYF8BkCAW/MqK/0j3gGfBnE9aURwNtn4h6SF4bEJVONc3uKuIVZVRJuFD
	 awiQ8eIZRguIw==
Date: Tue, 13 Oct 2026 18:56:45 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Benjamin Herrensmidt <benh@kernel.crashing.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Rik van Riel <riel@redhat.com>,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: disallow ioremap'ing ordinary RAM in
 generic_access_phys()
Message-ID: <as5UvcuKuVjCOvuN@kernel.org>
References: <20261013-generic_access_phys-v1-1-b3963ef76e37@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013-generic_access_phys-v1-1-b3963ef76e37@kernel.org>
X-Stat-Signature: ajcfxqjrpwdbrmftcf8x6e5wis6o3s9s
X-Rspamd-Queue-Id: 9D89D4000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791907014-102571
X-HE-Meta: U2FsdGVkX18euzAvvBiRMce5kZ3F+K8P6n57MrwnozgzIf2jscJfdVOLcSbAqxbCKT11wc4p+uYvPeRjAALhzFnJFxpqZdQch1NOoeBHzrEIQh2MnnB11VbatzFY2nfWCnvbkmj36WRT/twai9fcX4edyrXhRSPSV/s4DNfBHyYz76WuUPy2Nfit4pjtrU43EhCmJzs6NZ8jEAjq3nq3UU8DjRGZ+zOSPKy6YilbBRmO/2mUQ8FXQnM2p0Ma1M+aqphoCfjH63xP7muE2ZS16XQ1oft1AKKSUnMfrt/jQRBFyFt+DWzhPdBWNlyCHlph8t71VOmF6skh4bhYgo/67lueCnZzfqANoanFyCHLTU3F66Q85i2lz8gBg6nRFqoCoGkhhiK3x6r3rAiIUpJEIY0m3Fgn7IGlEuM2ZyZrgIifWIOL6kn0JvP3Xu38XUf1epeUY7CEx5YNIHL0YGfTHZEZjTlpkPXIyPnSO5f0qIplHYBcMLEY/gRfEKVAIXrxlFWRcTK08Ze6OXKNu875O1w9qnOlQuDjkEMJmKdf8RKy4ycn5YJbIdpsu6joISjl6sE/I16dnrvWSwItx2PnnURl82hhKpewoOX0l6VoFlEMHkO6xvslyElCmotYb8qtcUXaDQhbbC7NjAVVyKZxBgWnZb55KMhjQU7GMtkLVHQuYX3iqz0LwITLwPka5Qg5ORVnQK3LqNdmRDHI0Z0PVgkeEXVQFEyamY7T4doIqXGIHM1J2uhpvk/W8HG4pg77O8WLj5KukaCNfYQP+hhDxWEuDkl/yFX+cx2P4y38GyFZrkFwQTrvk3evT8g2TaspXEG37DPjWYmQ5nAE8bbC3zSJnDUnTaK0fPWLHNrAUAXtZwrLSJz8qt+JrICYEf9Etbkj4DsJRiZmoYJYPjSl+HLEVsT6678MPe2Jm377xIlbHBumTPynuMXsvAwrkfl23xUV1oHbI+xpxX9sd0z
 f86x3sgn
 ihL2dMh/KviFUjnQaZV72o4/DcFeixxbkB+1f3fnSwILT2lsjd8Upq8r5FLFAjWzpcBO5fC1fpbpPcx2GLNG+O8ppztIOQQ5OS62kqyarPMLed0ycTiEVSIyYy/KV3O11dQpTyRE5H7PTUmK1Y6l+No24xX7XZabq6mBPnSC0BeVvSu4MWng0JlbKCeLedKv1WI5NKF0wQmgw0tQM/SSUtiT44039ZEGrCuX0Fo+GaZkf7MIckSAfR1Aw+zghL3MnOh1CQR5xA/Nva8PLhx2aUM16Wet1/boQ2aoPRw4vJbwSpUxfQP2Keq9lZiX9W8w+RF2P/GZdrjzuDnEn8KD/a8pS0Fhou8NYY5vCb87fZuaZPZAY+G4WXuj6aoVPohIO1EuPXhQny/1lXrojs7hiYVykWFGLkYjBCcCEuPIWaPakSEQJlAsAhtQXn2oZvHO7YP+5d+n2FWmboa8yDEjbDZI/ShWC+kYMrzGTCxRoH9ZKUi9YDGCl+8xw/MM4RgDw+/D9AQJTcfhQmaisK0I/ZnmKK8i49FmmvnP8DsHBEvcw0qPiTgt1FqSNw9D9dhY9om4bOuiTNDmpU6e9xWKTB9H0vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 01:41:24PM +0200, David Hildenbrand (Arm) wrote:
> generic_access_phys() can end up getting called on CoW PFNMAP mappings,
> resulting in it trying to ioremap anonymous folios, which especially
> the x86 code doesn't enjoy, and which is in general just odd/wrong.
> 
> E.g., with a CoW mapping of a PCI BAR:
> 
> ioremap on RAM at 0x0000000045623000 - 0x0000000045623fff
>   WARNING: arch/x86/mm/ioremap.c:216 at __ioremap_caller.isra.0+0x4c2/0x5f0
>   Call Trace:
>    generic_access_phys+0x130/0x4d0 mm/memory.c:7178
>    kernfs_vma_access+0x1ce/0x280 fs/kernfs/file.c:437
>    __access_remote_vm+0x58f/0x890 mm/memory.c:7256
>    mem_rw+0x2a1/0x670 fs/proc/base.c:912
> 
> But more generically, we should disallow access to anything that looks
> like ordinary RAM in the system: including allocating memory (e.g.,
> alloc_pages) and mapping them in a VM_PFNMAP.
> 
> For pages with an online memmap, allow only pages marked as reserved
> (PageReserved). This also includes memblock allocations, however,
> distinguishing them from other MMIO is tricky, and nobody should really

With ARCH_KEEP_MEMBLOCK it's actually easy ...

> be mapping them in a PFNMAP (except someone abusing /dev/mem, which we
> do not care about).

... but yeah, it's not worth it.  

> So only allow access if there is no online memmap, or if the pages are
> marked reserved. Reject other pages with -EINVAL.
> 
> Note that, just like other pfn_to_online_page() users, we won't care about
> concurrent memory offlining; mapping memory that can concurrently get
> offlined is highly dubious.
> 
> Reported-by: syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=49b1021becba70c1f3f6
> Reported-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
> Closes: https://lore.kernel.org/r/20261001152524.171115-1-ngocthang2710.1999@gmail.com/
> Fixes: 28b2ee20c7cb ("access_process_vm device memory infrastructure")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/memory.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

-- 
Sincerely yours,
Mike.

