Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E268BFF6E9F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 00:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1AF6B00BE; Tue, 17 Mar 2026 20:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289296B00BF; Tue, 17 Mar 2026 20:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6146B00C0; Tue, 17 Mar 2026 20:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 083736B00BE
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:34:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9699758E53
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:34:56 +0000 (UTC)
X-FDA: 84557313792.26.FA52495
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id DA94A20004
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:34:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s+6zukas;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773794095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZhHDd6C61G35p9Vk+gxxm9a8gXjmErasuDo/qnx5fA=;
	b=xRMpn//gU0k9LnLGCvHO0QxnzFmfdU39vfMySXwpDrx1w5pzsAQPckGMTZKrF+CSamrIpO
	65hsI02qO2KSnlYKxpPeektUZS/7oGzNmwCcY50nxGeBofVMSVEwAmSghnusUotdAkBLLl
	s43bUl4wfDuPs2nal8F4AtK3q3aZ6Yo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s+6zukas;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773794095; a=rsa-sha256;
	cv=none;
	b=O1qkiqwxDPxBAlEQGgGgrcB0rjxYospXPT8SiafS0B/7QwKSRChvXsnLcexYGHPbe3rinO
	SwcwHAnxSOYeAQrMxxYWKEypKU/dTnG+p6K3wK7X2ERjlSrfa9xL4II+Frjq3g+GzQg6go
	oP0aBh1c5M/ySJq/dXChji3vQYRYda4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF8354440C;
	Wed, 18 Mar 2026 00:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA85C4CEF7;
	Wed, 18 Mar 2026 00:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773794093;
	bh=o+2EsIbr0oIAwZoKtQpYtJm5KnU4WKUHU9+5NFqAz5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+6zukasbBZhmH1EtCxMiJj6J53CY7qrVYduVrdi2hUhkqKjruyVm6bC6NvGRycXb
	 MIKaa5JBTG+Ti1LDUtnW4YvmA6t2UT7N3PN/YgEZ0nyetyWGvRMJNXv/2818gI2x8v
	 BBoLaZC8bTrWRk+dajPwhSnvUlkhjsapwqNQ6WMpTSjeaU2CYIhzYsKcNrcxEiZmXe
	 SpB5CN92VNUYTGClNeAsPS1gakRj0311McyRjfFquu5uNHRcrk7MM9GsdvxVfDNMp6
	 x1rZD+emjyHY1i/iF3dD3tti65Zw+KDlJOM4/VL41vpQ00errtHlvUm43Wxz4iuAwn
	 K72RcoN0FMBTg==
From: SeongJae Park <sj@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/zswap: add missing kunmap_local()
Date: Tue, 17 Mar 2026 17:34:45 -0700
Message-ID: <20260318003446.132008-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <13e09a99-181f-45ac-a18d-057faf94bccb@lucifer.local>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA94A20004
X-Stat-Signature: pepk15deghxz3hkemmqei55ekja86exa
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773794094-792456
X-HE-Meta: U2FsdGVkX1+Y1twG2iHhXHUgW3Mogm33Z6ey71d221Ugk7JDNvKgM1KG2cbNTlt0UO/zVL4y8i6Eyno9TXq1qzyjpWbTa3lfjZWQw9zhRo16KlX9tByMbuRVZ/r3ne65NC9lRvhwEcP8BwART+RQwoa2+a/pmW8sUcSItx9xSlGvtTsIsu2TMDFwsHtKcWwgOBk9Nn9SlvTvi+e3n3HC1fgaz4xXkvyDPjWT+4oz/AwMKPkLYod3KYxKZuvrcSR0JLjdeKr0cgMo6cOi0ay5Auf7X83LNwxc99qD4iWZ1jYjtD10C8dJyXfoZb3dOwBha8jrMHaNTymlwtemeIO8BBEIuv4OWhjZ5c5oiMd5zFeQ8Ev2EgT6b9TEMvQfV+DJYA9h/7lOFHhOlXNrXuYXPtsK/tygQYGEbPH2iSxN6wcb8x0sVjqVPd62uS928e96ivVaxjYjXdSXTRpfBBh2ZKjRZ9B3hIEEZI6B8sRII9aB/5Rj/nc3QIEjuN1p+tEITBR+HAU/2fAbqgrh+7RWPe6MIZJC0Sz955v8//RUUIhCsoejvqz3qpgt/cXFjTUwnhYPdMJpxcTUkJH+RnaAsqPCIl1rI6hGA6+stfXIAoWypnbeOviLK65ltw+J+PZAcxnWecI54fiGlxrd/t9+bH+FuuhE17XARGZxzO5RZUYIzmwD7ZNweC3lA8ZIZ0fpcJMS/MGfkJvnPF1DTTUiMAs/NVhyPsYAQchdk/dFDQJs2o5l+Aay7zsHArrtpen16Fnn/mafgW0R/Y2miEjvnKQS75+BDoQqKxMMfGi0VM+o1L6YJkIVE1rvrJKGT4P1VlGrRyDgq36EQqWoLcgICHBogddBS+/EH6Sz/c28xy8acMCpcuNKW94fRorXONfLglAYSY1B7DyXFyIg8qOrgLlmveF9TgzbxCditeLxcfMr/gJ8zNJKl0PgjJCORz17ABkRp/R+uYjHXrEuo1a
 eOj6skx8
 qZmjbEpFrezYtHxXLB8Q0pT2yeHdKbPepEwPo83JSNvR7kQC3G4q3U6HeBD/2B4ToruNgkMLwoHirnWHZmSrqZoB/VtnzRAkl7UmmyHhCVIIiO3b9fo3uCgHscoe6jbVVsuzl32fymO6FhF7WTMI3WehJnlNryrSQX92ZOg3AsbKR/nuccfPQ5esbLDiyZwpG/7TEAjiafXVj0iRmQtnCcTsI6tQ+oc6j0SM2D28xDHVZ9RqFyf9XTFxNMIcXn3e+bhFKZ7sPYGfeIcqO9/30te+nWek/g9wME5GcmkUh8tECtYY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 12:59:35 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> Hi Andrew,
> 
> Please apply the fix-patch enclosed to add a dcache flush which was also
> missing here.
> 
> I had assumed that a new folio here combined with the flush that is done at
> the point of setting the PTE would suffice, but it doesn't seem that's
> actually the case, as update_mmu_cache() will in many archtectures only
> actually flush entries where a dcache flush was done on a range previously.
> 
> I had also wondered whether kunmap_local() might suffice, but it doesn't
> seem to be the case.
> 
> Some arches do seem to actually dcache flush on unmap, parisc does it if
> CONFIG_HIGHMEM is not set by setting ARCH_HAS_FLUSH_ON_KUNMAP and calling
> kunmap_flush_on_unmap() from __kunmap_local(), otherwise non-CONFIG_HIGHMEM
> callers do nothing here.
> 
> Otherwise arch_kmap_local_pre_unmap() is called which does:
> 
> * sparc - flush_cache_all()
> * arm - if VIVT, __cpuc_flush_dcache_area()
> * otherwise - nothing
> 
> Also arch_kmap_local_post_unmap() is called which does:
> 
> * arm - local_flush_tlb_kernel_page()
> * csky - kmap_flush_tlb()
> * microblaze, ppc - local_flush_tlb_page()
> * mips - local_flush_tlb_one()
> * sparc - flush_tlb_all() (again)
> * x86 - arch_flush_lazy_mmu_mode()
> * otherwise - nothing
> 
> But this is only if it's high memory, and doesn't cover all architectures,
> so is presumably intended to handle other cache consistency concerns.
> 
> In any case, VIPT is problematic here whether low or high memory (in spite
> of what the documentation claims, see [0] - 'the kernel did write to a page
> that is in the page cache page and / or in high memory'), because dirty
> cache lines may exist at the set indexed by the kernel direct mapping,
> which won't exist in the set indexed by any subsequent userland mapping,
> meaning userland might read stale data from L2 cache.
> 
> Even if the documentation is correct and low memory is fine not to be
> flushed here, we can't be sure as to whether the memory is low or high
> (kmap_local_folio() will be a no-op if low), and this call should be
> harmless if it is low.
> 
> VIVT would require more work if the memory were shared and already mapped,
> but this isn't the case here, and would anyway be handled by the dcache
> flush call.
> 
> In any case, we definitely need this flush as far as I can tell.

Makes sense, thank you for detailed description!

> 
> And we should probably consider updating the documentation unless it turns
> out there's somehow dcache synchronisation that happens for low
> memory/64-bit kernels elsewhere?
> 
> Thanks, Lorenzo
> 
> [0]:https://docs.kernel.org/core-api/cachetlb.html
> 
> ----8<----
> From 94989ab3d97f0cde0dcf59eba6466fee932ec4ba Mon Sep 17 00:00:00 2001
> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> Date: Tue, 17 Mar 2026 12:29:55 +0000
> Subject: [PATCH] fix
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

