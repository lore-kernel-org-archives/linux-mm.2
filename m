Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7B67C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E5C6B0088; Tue, 28 Jul 2026 09:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A576B6B008C; Tue, 28 Jul 2026 09:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9947F6B0096; Tue, 28 Jul 2026 09:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE116B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:11:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5E381A0251
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:11:38 +0000 (UTC)
X-FDA: 85038222276.06.FEC8C01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 39971A0006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:11:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mKcEJwJI;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785244297;
	b=yzM7f1bF5gk6aekB37wYd5bAbsrGvncaYs6qhmxvkRyz0cPDFLhQWojWvreQE2OmPvEQOL
	XtDHc+kGtyuzoCLV2G6ZjstyiT5D2Iva0+EwdOeYSe3hZfAWMp+pLcZPcRXrldy2VdO80D
	brkpjTDTrteFrK8PBMux9KigQzZNGYc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mKcEJwJI;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785244297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vns0tlxk7C8bBVdnIv05S1BNPahfXX1Lxmvhci83FeQ=;
	b=3VA1w2HBj7+z649YxrsBqgsYodRxIEhJAM4IuDKM6eVTrSY4iiKryUJ+HCMaAEs3oTTztS
	lC5VwTqyluuOQ5IXjX6O+5CN+gGVEL1REc2Z8kq33+WZnk3VyuZtadAZMAqbSE/ZvHopRS
	ltlZ7MNTeicuhZe4gXcrlA31VUKOFZU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5ADB143AE9;
	Tue, 28 Jul 2026 13:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2991F00A3F;
	Tue, 28 Jul 2026 13:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785244296;
	bh=vns0tlxk7C8bBVdnIv05S1BNPahfXX1Lxmvhci83FeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mKcEJwJI+iahQ0Y/Jyo04if+r0C5BJmRYgxH9GAgcjlw2mHG3j1F1Lwqa21fOv9z8
	 hpVMqlZfcTuTVnhORm8SJOfexjZy8oMuhagcu1JwiSmpHcyusSqzbVMvFCX8Fh9hey
	 86gpHFhWEu0ogxPg/+aAuWb7tZrCF3oJdBpHlsulcysmyMyNBtwSGUHs2IFIvE8OeN
	 rmMTGZFhKVYIhT0+G2qbHvB1prablSjrdCB77JF1BUpqVZPTnYV5CleQMxJn3ZkdgO
	 YBMVxyLpMSWgHQP4WgkbVmm75Ly68OejP7V/GaOi90D4Z7blax3l7PGkqcVjKIhsHt
	 WakxVX2BLMaBw==
Date: Tue, 28 Jul 2026 14:11:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, David CARLIER <devnexen@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
	Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org, 
	syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
Message-ID: <amiqDkAxFx60biG1@lucifer>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
X-Stat-Signature: 8hhc4wjhwm5fwnubtu7rmmtewjwekupu
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 39971A0006
X-Rspam-User: 
X-HE-Tag: 1785244297-252871
X-HE-Meta: U2FsdGVkX18EcHbIR43zb7TEy21iXO2kn0+9Qa3KtZF63ZoH7WTQMEyl54TtzH5+fU19aHOclgD7spFF6FjIShlRLQ0o6RcCe7mgrsyREkR5F05fgrn9H+DdvaVUTlg0ZUKt/azP+4zzzybNaxqph+W1gND7tnFsEo5O38ObIc2g0Wo+9JSqVndc9snZiiC96dgo0xciYfdSquFKdX8YDWtnfbhyE/22JoLI1k18/mbU5LCxEtkcsw8kKgHImv2+zV1pMRuB57gclXIyPGE+wKm2pfcE8T0kwLYR2x7ghnlyLSfTYslkDhfVyMYBaB3nyFcrT6lRKiYnGEog4+O5UEANSDvlgkdQ3DE03dafgMX5T+xHiuSAUkUONfoKhW6LJykoDpPTt/w8K0IffzTMTLM5a5gigfRlOrkQ3mp4s255oN2QMCahlr8Tl1FPrebFOQeTCxwEs9q1hx3zyDEBX78MIjm5fmovf8jssOg0YYu4Ixip3MfJEUtUhwgpjGT4r2V/2da/c5BMOwNm8lsZ+rGubokSgkkckVmU5sEwmjzjiTkilacczoO6ZvqPNSvwtTLxbO+xHJRtZqc5HUL5Ntk8KXqYlZUWh8dkFq5FKCnDzGMPFAvRuq1andxz0GeEZCczdNOtxoBbZxN/0OLMq13MehIMzmMvaFhIQY0s8JA2tx9uBUoWlQanGRvKB+HvJsWSj+97MUag0P3wQOCLglCazT5dDTTVlbZlfEWOrmxlOqit0UldcrlxxgzrcYZTbZH8KPDXE+XoAPtyiRFDAvRcBJVR7+x0dbkPbISY5dTxWBO42raIvk+RDYa8UCvDX4UAQRwXoUKCi2sCqkdyCZvSXJK+WlMWWQIGhPLA8jo7wzyxXda0FrX534N/e6pktN1/GuualwHYRax+aKFZKvsJWVacEvgsKxcZ4tara3Qgj1l2RtJV2vueNhRMo/9pYE6NdeIhOhmmvDnxmS0
 h0z7PmLn
 WqNRQvQ9xiPCYExx4zfhIrHie9+Vfj5wzlqG6/sTQzrNAwOlBWFTkmqQ88Oxy1Hn0Yxeft1v1ut2g/NUyH0bRYfg+ZnFBN4yyCe6gJPTvPPty0Q+P702/G0GVrSmcIMCitCEOEJv/09qw1Cy3Yu3zSN1926lqYvUcjicQbKlgjmkRhSUncWk8Yr62Z43F+MmGgrBtKADNwPwnkNz2Jp68kjY2kXQ+XG7wUJ/8odt5TfgrBhlbaFrJM6N+YdKvZBl08hVEAIpHKcPOA8B+OVO/9UJVZYC3IvC2Al57ZJDT0LSi4VTdIlUpdKo4I3n5EmDa91n3NMiFmBxvrjLUoiq7kCFSPOIODu+A+lq9ZBf7i7OPL7agN5Wqz2eBd//nY3M0oS8sjxiG/GbotcHZZjc4wTcVYvolXZgM75aE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ack on all my patches thanks!

Andrew - let's take the x86 patches from my series through the x86 tree, and the
core mm patches through the mm tree.

There's no ordering requirement in the x86 patches.

On Tue, Jul 28, 2026 at 04:07:43PM +0300, Mike Rapoport (Microsoft) wrote:
> There are a couple of CPA fixes floating around:
>
> Denis Lunev fixed races between split and collapse of the large mappings:
>
> https://lore.kernel.org/all/20260715183453.2381141-1-den@openvz.org
>
> Lorenzo Stoakes fixed UAF caused by races between CPA and ptdump:
>
> https://lore.kernel.org/all/20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org
>
> and an issue with stale page tables in IOMMU:
>
> https://lore.kernel.org/all/20260721-fix-cpa-kernel-pagetables-v2-1-2b255deed710@kernel.org
>
> Mike Rapoport fixed a check of RW attribute in lookup_address_in_pgd_attr()
> used for the verification of RWX:
>
> https://lore.kernel.org/all/20260715144519.934289-1-rppt@kernel.org
>
> Some of the fixes got merged into x86 tree, some of them got merged into mm
> tree and some are still hanging in the air.

:)))

>
> Beside the fixes there was a supposed simplification of cpa_lock locking
> that looked like removal of an optimization for DEBUG_PAGEALLOC, but it
> turned out that it was not an optimization but rather a correctness
> guard because with DEBUG_PAGEALLOC the locks could be taken in an atomic
> context and couldn't use plain spin_lock()/spin_unlock().
>
> The changes here are collected from all these fixes into a sinlge coherent
> set on top of tip/x86/mm:
>
> * update to cpa_lock handling with DEBUG_PAGEALLOC
> * fix for races between CPA and ptdumpi causing UAF
> * fix for stale page tables in IOMMU
> * update to the fix of the race between split and collapse of large
>   mappings
> * fix for effective RW computation in lookup_address_in_pgd_attr()

Thanks for this!

>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> Lorenzo Stoakes (ARM) (3):
>       x86/mm/pat: acquire init_mm write lock on collapse to avoid UAF
>       x86/mm/pat: acquire init_mm read lock on attribute change to avoid UAF
>       x86/mm/pat: allocate split page tables as kernel page tables
>
> Mike Rapoport (Microsoft) (2):
>       x86/mm/pat: introcude cpa_lock() and cpa_unlock()
>       x86/mm/pat: fix effective RW computation in lookup_address_in_pgd_attr()
>
>  arch/x86/mm/pat/set_memory.c | 95 +++++++++++++++++++++++++++++++-------------
>  include/linux/mmap_lock.h    |  2 +
>  2 files changed, 70 insertions(+), 27 deletions(-)
> ---
> base-commit: a5a162fe1ae130e3d2ceefef3f43afe3773c1d56
> change-id: 20260727-cpa-fixes-d3c73c075672
>
> --
> Sincerely yours,
> Mike.
>

Cheers, Lorenzo

