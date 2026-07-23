Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B925C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 23:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532286B007B; Thu, 23 Jul 2026 19:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC116B0088; Thu, 23 Jul 2026 19:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385C46B008A; Thu, 23 Jul 2026 19:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 04D586B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 19:26:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7CBEAA0226
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:26:50 +0000 (UTC)
X-FDA: 85021628580.05.345160F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id CDDF640003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:26:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JgkzM7dC;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784849208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iglblMPnjAGanPHzfwJ4G7yTcJ+FyPGK1MRMDiMSvoQ=;
	b=lDg1RjYFM53MCfuEC/5JpfznMkoZjkGHJ8uUGtDpUpRc8QoCDPFYtkUVkWguVW9WSFO+iv
	z0WNcjxKS/NNZrWsrMok977tLBZ26cTlnCqpJUAmQ5H3XulGYuohA4QXnr+ieUeFWxfThK
	2PkdwpVFfatl5gGuw7cr328CnmxRilk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784849208;
	b=XUOsavyjCN0hbmxAf8w+Et1Etr/OQvIE6qbOYrG2vwJBktZukRAuB1vAjMPIlxEeO/MQX4
	IuqEmkjyF2T2QaWiT/aH4DwCW+ryRYE6kEgaQJc2AkzZDKm0jarym/NS8uTdGVy+R8nXXp
	2A6kGiUzlergWGmy1fFM4kVZxM2M4G8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JgkzM7dC;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21167600AA;
	Thu, 23 Jul 2026 23:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2061F000E9;
	Thu, 23 Jul 2026 23:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784849207;
	bh=iglblMPnjAGanPHzfwJ4G7yTcJ+FyPGK1MRMDiMSvoQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JgkzM7dCM/Zxzo/X33WrAwQ6AAb4lf99G+tDra7/PJLz60BVyuGbnByOdwXTvCHUr
	 8ixHDSHqInlknVMXcQa9n0XkZXXdkSNo2VuXqP8GFWbHnVhkRGfTdswcCbcqyHGfmk
	 OlbDd+NmHmHOgbEeFTTzgxwjrDukDaeRj2Aaa/Uc=
Date: Thu, 23 Jul 2026 16:26:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Uladzislau
 Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Dev Jain
 <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, David Carlier
 <devnexen@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, "Denis V. Lunev"
 <den@virtuozzo.com>, "Borah, Chaitanya Kumar"
 <chaitanya.kumar.borah@intel.com>, stable@vger.kernel.org,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes v6 0/5] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
Message-Id: <20260723162646.350cf3bf415a0855140d139b@linux-foundation.org>
In-Reply-To: <20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org>
References: <20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CDDF640003
X-Stat-Signature: dzrm5ibakotw4yf5fy1pfrj3p4c77gu3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784849208-55165
X-HE-Meta: U2FsdGVkX18pIzbVN4/Tee2lbUfUtK5Vo7C+2vX4dzoiBjK2oAvXbPKP7i1zoVHexD5TEwf61waBMgbxIXgP71zyEYuqAkZo/1ZoYYtnIalNi4qVojaT8xX9iJlCfTanoYjtwF/JG6pfyNLGLRlY/JFefd0B63DaBuFrPOVeUWEzpcWljPrZJnAksDtliEsCXAbkW1GZw0/FWsrhWchPAsJWjhXhLfoLSNeMRkI0jUsUcT7JJqmS3QkgsnnIyk9QygPS8uObVZaM05Zmtgyv4PwpX9TwcIPTf3qucfjt4E8OKi8LiYZbO/G1n9+5HK99B345o+HjQ4w+lq6KfNlLEFEWVhXfgMtH7TZI7oB8dbEwSf04fYjXXI8HA2WwiixfnPMSx1w+aXW7eVJlSvaDqwtnkl1Vbr/RajVZqlkD9uAVPVhQD5u1kkQC6ZttmvntklAh1BrL60Z/Yy8+T0krFcujnoBtodL0KI46FUEq60QZkTx3NdAbwV8FkWfa0BHmIe49vY5+296Avu+8vwlTf3mrZ7CuXV0wzPUUyHqMY8My/5SBw59bXSFEMwFwvhXWlA9r53wDqB1C+d5d0Lv0sd3e62P9OJiSuDo9rMuKL725uGbF1CVUWvuHVC++BiE+XrmeaH1zplinExVNv80Lj8qXKShaL8T1jDMvB6U1dDQJM7jPp4Bke+IDU5E/xsG28gkifwpKGCxQodCaVYMUjtGgo0dThb7M1H1Md/8wdMfsKOlinfbGUdqf8B5V3Ik8JJ5OG7OhubbzzNtz/lMa19x5cnwoiQQBvrTq80TMkgCubykXGE15UmPEH2d6eKLyH7bw/SGTsq/g6xxWfjHq2c+7DxG1pZ3y40hjr7NT6UmDEfJgSV+vnaGQ3lyRdIb/0mUNbniGvRs2wRjJ7EwatGOULCmbRw4J9smTEBJ6MlJUXNUnpfTHKuujqIlqBCOig0tBQLNBoYkAABdOY3/
 x+yviuXw
 Ig9yPDAzk9DveUjHJSCHdXmDotnAZxSElNwcwxQShFgSeSLG2aOWNpE0Ha+QgU+f75yd4d9P20GvwE7lkwR7kop5plx/4DRf+iUcbS6AsRa5fSlbS6KiSGqVuAWYMq72cJ20WvAoztkaDicuy6XY9M3KgiIf9AeFoc5hz7CXwVVVD1N7x7vVle+xkxQRoJaO1E5g2GRXaCnj3faSDOOmyVfotlQfv4WYcdGqhFsqYo4h2rZjOunbE8txF3xHJsjclembJoARvC8Wdo1rHfmzUIbqzx0RQaQKUngEWmUWWSgPugKU7yEv8lD/T+BWnDE628kycuocte0wmmXpxiKqUIyVYcLwVzanmsiwnJZfL3i+19gLKzWsbquhaX0W8KZ8inJhxV3AFGQMur/GXlcsLIrS03A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Jul 2026 16:16:30 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Kernel page table walkers fall into two broad categories - those ranges
> where no exclusion is required via walk_kernel_page_table_range_lockless()
> and those where exclusion is required via walk_kernel_page_table_range()
> or walk_page_range_debug().
> 
> ...
>
> This series works around this by #ifndef CONFIG_ARM64'ing the mmap read
> lock in vmap logic, then partially reverting commit fa93b45fd397 ("arm64:
> Enable vmalloc-huge with ptdump"), keeping the enablement of huge vmap
> support, and removing the ifdeffery with the partial revert patch.
>
> ...
>

Thanks, I updated the mm-hotfixes-unstable branch to this version.

> ---
> v6:
> * Rebased on latest master of Linus's tree.
> * Updated: 3/5 to drop the init_mm lock over page table allocation in order
>   to avoid deadlocks due to init_mm -> ... -> fs_reclaim -> init_mm
>   dependency cycles, as reported by Chaitanya with thanks!
> * Small cover letter typo fixes.

Here's how v6 altered mm.git:


 arch/x86/mm/pat/set_memory.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/pat/set_memory.c~b
+++ a/arch/x86/mm/pat/set_memory.c
@@ -50,7 +50,8 @@ struct cpa_data {
 	unsigned int	flags;
 	unsigned int	force_split		: 1,
 			force_static_prot	: 1,
-			force_flush_all		: 1;
+			force_flush_all		: 1,
+			init_mm_read_locked	: 1;
 	struct page	**pages;
 };
 
@@ -1250,7 +1251,11 @@ static int split_large_page(struct cpa_d
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
+	if (cpa->init_mm_read_locked)
+		mmap_read_unlock(&init_mm);
 	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	if (cpa->init_mm_read_locked)
+		mmap_read_lock(&init_mm);
 	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
 	if (!ptdesc)
@@ -2123,8 +2128,10 @@ static int change_page_attr_set_clr(unsi
 	cpa.force_split = force_split;
 
 	/* Avoid race with concurrent CPA collapse. */
+	cpa.init_mm_read_locked = true;
 	scoped_guard(mmap_read_lock, &init_mm)
 		ret = __change_page_attr_set_clr(&cpa, 1);
+	cpa.init_mm_read_locked = false;
 
 	/*
 	 * Check whether we really changed something:
_


