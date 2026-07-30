Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D38FFC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F3C6B0088; Thu, 30 Jul 2026 03:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D16C06B0095; Thu, 30 Jul 2026 03:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C539D6B0096; Thu, 30 Jul 2026 03:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A084B6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:23:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3734580652
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:23:55 +0000 (UTC)
X-FDA: 85044603630.26.CFFDF93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9428DC0009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:23:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jHj6GHG+;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785396233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Os9dgFvLa7OaBZRPPv98Vo5UROeltiAo6YFGnDGfHRI=;
	b=esxOQnummeAyHInUzE2XM+sKKfN8gWJZuBHVeeyChDBMYWSLlj2gJNZaCp1MiGVagmIhmd
	ixD+lD/zHE7Es2Ntm/2410Oa7yST83R91uVatOyyoXmqIpZINmyPkAIfgQZvMYP48KpqXZ
	bpv2P+gRUZho15dnpFC5hUdjvQ1ETeo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jHj6GHG+;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785396233;
	b=rWNNXChBOlAPdO+L/BNvAq5ZMf9a1/q8+nWcALN6d0QpTRkhU8chtqeZhYVHifEM8TA79V
	SK4chGqCPMLpHZGVC8movDLQHUymRfWzmXRPm1caHzeJqwJWsRJFh3Ha4hQHKtghP77U6C
	0jfxvUcpVSKVt60abMiO4Dvdyt3NgpY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07524400AE;
	Thu, 30 Jul 2026 07:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133881F000E9;
	Thu, 30 Jul 2026 07:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785396231;
	bh=Os9dgFvLa7OaBZRPPv98Vo5UROeltiAo6YFGnDGfHRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jHj6GHG+B6LgtjHEN9lD3r0pHdLDN+4kYoIS1VogXbaHwhDQ+DRNw19Wtm3HcxLVv
	 iAF5ezxDHjmMOOm4WuZQypQ/XfMT4Pw6Y4ybYPZwHN6f4GDG6DIfbgwpOp3GAZyVT9
	 OfRTqZ51g49gULmex43tFprNxYVrVBkKDfFVow2rJa8asavexLSTKdQoT7CSUiF93T
	 YtdwNIe8jQPzVp+WdhrhWq0DPLI8WOshgBVxTWWl1Kud5DYndfXSqA4kvyJEzwTyE5
	 2MAxFIhxHhTM02fFqUhgN+JXPlGtks6I/DHxvDiBX09F2bKGjgiH9dDlqzT9bghJhg
	 L8lfRYaJWm2jQ==
Date: Thu, 30 Jul 2026 10:23:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 17/22] mm/mm_init: don't rely on memblock to get KHO
 scratch migratetype
Message-ID: <amr8ADvAiJE3ZYKF@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
 <20260729145610.2827231-18-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729145610.2827231-18-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9428DC0009
X-Stat-Signature: 8qep9uy8uhk79nxzd1s5kyfgpr6yzdoe
X-HE-Tag: 1785396233-246275
X-HE-Meta: U2FsdGVkX18dcQqakQZav9XIZDek8+MBNHEo+CYARKCkO7jxsbIxLBe3OVmFvp0UIJcOzL2a0ZB4Kzf/kfqnsMjwqKGYle9B6YlG+Pl+hJig7rjwbor+qzsQ56ebxnEfQK2OaDaIORzuxVcAyNfgrDZZOHTz9V8IWaxuaY+WfULj16tE694lprWPecUJqKRjZe7E1rdgoUK3DEFYVeCwA29ezFvk+MzLkU1Xfh4PWWsuAUN2bVdB7pA12Lw75aSFdNhglY3fgTnHacA3MTyxiTYe4lv9rgvmVij24wtgtACrga+yv7NovmhVkfuLvCcfqQ7R20RNKP7WHx+HcCpZlhwLAU43I/ngGFk31vP2dmMLn9+rYksRokyNzFyFkYufM9h5o7IC8Sq/JSMOgU6Fwe4s09sc7e57PG4Fdg3UqwwNnP18Xy/C4pz7VLyxDEeoWdhMqhv2nNB1Xp75Wzrtb/5OhLua/iWUoBqgrFiTdkQruG2awaJa5NXqsIjUKrBeBI+EBsSixX1se4jrurRlVtX2PCTNOQVozZItABTkwY4G4squ7DZd90yN2AYiQyFkxiUuQrfVdcHaRa0KyR8D7WmBp6UR6Ip/ZrxPj3sznTBGBoCMYmlvSLdYMuLmc/juIEvWODHb0IMILypycAs+EZMp1Qz2Q5Zw1uCxH+90m7jLa0LfImSDIDzdlvyuO9R6SENZ3z2FH7X3KkZVj+48Xnrnn2P6UIv/YnMIhR5XZotwtz6zviUTfbrVUi0u+7q2tVfg4xdXKed1HCUnG84GTAOfteqMMfFP4uxWjN8mUCSj01P4VPDp0lpCI89mXyhx6o7YGFItktRbBUIWZG+TUuDInZFt4H8HhifvboSRiDSx7AQ74Q71Z77BG0kp0UITMCve+tOs0LW1g6DL79AACvopFwVo79KN2lRW1MORIzQZP677tH8Y4bgRFcPhSu+zOhHdt1MJ+lFL8gTQTiZ
 3zxmguMB
 EYrqN9XmkKOmt9FM90U+Osj6/vI05RaY0Lq2+WOhdlcE0x7l1ARuekDgq24JTMLosXcxoxYYFinKZq6PI4keYETi3Ox5w/k1dVZrljxYGV7At99Ln13U7muu0XqWgOmAPojU4A2ifZh82lXpff2spnu1Q8A1Ymm/pPEM9OH5WcLa+g4R0JB0eSTV4IcI5X6RZBqGu85IuO1GAHWlfwxwSx8Zy28GZkehuGFRrN7eIZIImLD9fN40eD+TpFc+qmAJc6WWMa+aRUfAnvkL5L/P3Nb0aUe/mrRykOC4YVaksmgmoonFwKihkurtEjtaYinfqEqbuI+w7onlF+E4t8Jzrh4DGQ5uc4HDDxaJ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 04:56:02PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Currently struct page init via memmap_init() or deferred_init_memmap()
> only queries the migrate type from KHO for each discrete memory range.
> That works currently since KHO scratch memory has a different memory
> type so it is always it its own region.
> 
> An upcoming patch will add support for discovering blocks of memory with
> no preservations and it will mark it as MEMBLOCK_KHO_SCRATCH to allow
> allocations from them. This can lead to the bootmem KHO scratch areas to
> be merged into larger free ranges. This merging breaks the selection of
> migrate type.
> 
> Get rid of memblock_is_kho_scratch_memory(). Instead, use
> kho_scratch_overlap() to decide the migrate type of the PFN. Since
> kho_scratch_migratetype() only uses KHO functions, move it to
> kexec_handover.h.
> 
> Instead of calling kho_scratch_migratetype() once for each free range,
> call it once for each pageblock. Update
> pageblock_migratetype_init_range() and memmap_init_range() to do so.
> 
> Since the migrate type is now evaluated for each pageblock and not each
> free range, drop the migratetype arguments to deferred_free_pages() and
> memmap_init_zone_range() and use MIGRATE_MOVABLE directly.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  include/linux/kexec_handover.h | 15 +++++++++++++++
>  include/linux/memblock.h       | 19 -------------------
>  mm/memblock.c                  | 10 ----------
>  mm/mm_init.c                   | 27 +++++++++++++--------------
>  4 files changed, 28 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> index 18ba417f1ada..c83ec4a15fe7 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -5,6 +5,7 @@
>  #include <linux/err.h>
>  #include <linux/errno.h>
>  #include <linux/types.h>
> +#include <linux/mmzone.h>

Should have been mm.h, kbuild bot is unhappy otherwise :)

https://lore.kernel.org/all/202607301001.ARjK0D4v-lkp@intel.com

I can fix it while applying.

-- 
Sincerely yours,
Mike.

