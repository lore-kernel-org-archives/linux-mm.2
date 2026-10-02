Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E17CA5FD9
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 08:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9A16B0088; Fri,  2 Oct 2026 04:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9908B6B008A; Fri,  2 Oct 2026 04:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A75B6B008C; Fri,  2 Oct 2026 04:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 675B96B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 04:23:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B4AEB1A065D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:23:06 +0000 (UTC)
X-FDA: 85276995972.13.7FEFD92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2820940008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:23:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HxfcHBD8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790929385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/f9I4vHQK4JOyc+erbBtNclRJr/3Y4Kf9SezEHiCB0=;
	b=mjyxrMWS6fSPakzOcdMBuYLpG4UGZvxd28Q7LQ6FEhQ8VRyAAdIXxVF9R4rdlfPLWLWH/A
	Ag96cRNRYYPpgIuR1Q9rZxPmitG9q5pb/KEU4ovTfKeS01i+bmJKjtLdCGm5SJrUUpO3os
	MvXCWtc3NufZpv1oBUndqNOJWG+Nk0M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HxfcHBD8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790929385;
	b=eUIb5joODBjKj+MXDLTp0tltzv8yGR3CVW4P7KtSAkHv1d/Se+Q46WHI8ktAmKUf4TGYS+
	ILT4fwVPjWRlkwrtaavnyrlfvRhSgroDp+zRthRJinwOKrz1Ahuk0ZGG/pkShdDYl8dfaD
	D0Xf5CBKAiEmYJTnrkiyrFr6lJ5klBI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2B0160A6A;
	Fri,  2 Oct 2026 08:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FB01F000FF;
	Fri,  2 Oct 2026 08:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790929384;
	bh=G/f9I4vHQK4JOyc+erbBtNclRJr/3Y4Kf9SezEHiCB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HxfcHBD8rebzYNDmEhi6ZjEMfdZKUzhjRiJMId5JdydfC1VdWyb8c08N9eWtBVQDD
	 s8ik9RohZH4US83JNfPsnlk8g//6XwGPAYSZSRPl31LER1mBTyZgYsOP6gsIdd0tXy
	 nLTKGK1iGyLORSlzVOr6U7eeUq2VLTOa7+2TjgOF/DFKV0/MMF8BaQfnkxf64MzxSm
	 QR1mL6j6ja0eAy9STNBKy+bhwdvUtLq18bDlZgnYUnd+JP+TZ/wmn++l1Th5RBZj67
	 PnQXRbUhDXumsopPyQKJ5tmPfpqn8AdmtKB63Z0Mg+0rwMxgYTXHPogcXNKqrZLXFl
	 B+elqnABketew==
Date: Fri, 2 Oct 2026 10:22:55 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 6/6] mm/mm_init: add zone mismatch warning during page
 init
Message-ID: <ar9p39Y9SmlxvbA_@kernel.org>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
 <20260929053231.66085-7-songmuchun@bytedance.com>
 <ar5xbQsUpSQZg0wO@kernel.org>
 <78D5D6AA-BE36-432C-B0F7-453F93DF18C0@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <78D5D6AA-BE36-432C-B0F7-453F93DF18C0@linux.dev>
X-Stat-Signature: hmix88xhjo5d1irjry3tp9pighsdo844
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2820940008
X-HE-Tag: 1790929385-645466
X-HE-Meta: U2FsdGVkX1+USsBeAYrPPNJDygUrEWpEAcxIO5lq/5FuY3pVcF4Lztmbdnv/LoZ+xlNFMCXClgoc/6rfAkkC+JfV4+oi2t/Cabg/aTTZtJ2mdlK2yZiFFcXeGnSGQigT1COYLOnnjU4U0DH/174GvcjSBEfkEcm5s1zZWtB/lOjX54pt7Dc6plJpC0Dk858DLMHXVrrYgwhydSdnjdTfWXKJcOSswqZj80cU/Q/SmyChCBxZpaNiWPz4AKy4k8kaSQeAGXT3drMiZDPiOdJmAO5RR/zB8Hr1cL9xXgeyf6Tt78G6PR13OTBZI8N46SYaRyEvV9KPifP8NRPl4VImcs8b2Q1wXunXxy2GOOHkyAnQGMaAwiK3yp9M/kLktVWkK4gEWqDwqwhFwP8YY6Ldafh3FJ/95UPa6mghrhuYX7bwZWJXE7/pZGQDUalGLOvz/jtdH1kVLx7HczRJJTajBC+rBi+UhcrW7I7eNUTgZRCG5QDc3LVSBwPC4LnzGULDqNyJigDQyXfam3F8s03Oc+2SPtqqwG75Z7lhPyifETL4VkDshEhTXkxU9iZptF3+S1CNv/8Q7zXRkEtr7912uxJNR1TFF2I3qiE54PrzeBiP+WL80PjJdaXErwuSujhSzFuxOiTsmnwx0uWa19oxZGc/2gHx2UP0xJHSQS/Ova+6jPfTOVyCOFTVEK0L7Cei27Hzy+Qln5mayMACqarID5jLTyHTJm8lef1jlnnjjhCyESy/TyULRw6fGJatIkFtIZGB8GE9xU3MNaksS3WrTNePARzc9FvmFNvRmPhX/lP0mvpbx/pznp6kEmk/RIazHukp4uy079Su+5Ds6kBCLpk8+AIQJFeBBuhWUke1+IdJaaSI2VLl/PoW/Q9nRxGRgDmkCii839zAwJ4lO7WM7zNeAm6ZX9pdMkLSpMUh9w8ex81FQezLLOAgWtXJ3BMAEOWEidRKhEVrg7gUaLK
 yxfn3Ckf
 87olOFO7eHhMV+RtjR4apCkZvp5w/kxoGHhYultuMdy6YNDgjMsc8V00DaJ3Hfa+RTD2Eog8BGHOlIxr8FDf2fGY+001evUDlgHg0wO1bxVs8Lp7zttpf+9xZzK3KS/L88cOZOx+nvPwrs0hnvxWN22XoQmBkQ+xxTEcmxe428w/9Q9A8Wo8Rv2zHLRhuxKX5+bwcdOBMuogPM/bh0jFgr2tHs1MNS3D8n5xP9zo9Ok0XAImrefEQ8em0PPnXGD2s+/Rw2mlFA1nC1yz8odgXok5jClxk1MHr4OyU6vRYYjloEDRkKdnYy2zj9nprxYYkFYhSi/Gy+ljnIK5OIbI8ISRvYd/ElaCrQpray8Gy6wgzUtjvzBCBk3D3CyBOuzC4yTwbHQaE6kLIzYGLIuDw0UdJxkU9us4shL2bvhRxpGTg0jGrBvCJCsp8lKaGNu+wWJeT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 09:48:42AM +0800, Muchun Song wrote:
> 
> 
> > On Oct 1, 2026, at 22:42, Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > Hi Muchun,
> 
> Hi,
> 
> > 
> > On Tue, Sep 29, 2026 at 01:32:31PM +0800, Muchun Song wrote:
> >> For vmemmap-optimized sections, tail struct pages may be backed by
> >> shared vmemmap pages. Those shared pages must carry the same page zone
> >> ID as the struct pages initialized for the section.
> >> 
> >> Warn in __init_single_page() if the shared tail page has a different
> >> page_zone_id(), which would indicate inconsistent initialization.
> >> 
> >> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> >> ---
> >> v3:
> >> - Collect Acked-by from Qi Zheng
> >> 
> >> v2:
> >> - New patch.
> >> ---
> >> mm/mm_init.c | 3 +++
> >> 1 file changed, 3 insertions(+)
> >> 
> >> diff --git a/mm/mm_init.c b/mm/mm_init.c
> >> index 1650d6bc1211..bd02e8d06965 100644
> >> --- a/mm/mm_init.c
> >> +++ b/mm/mm_init.c
> >> @@ -609,6 +609,9 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
> >> if (!is_highmem_idx(zone))
> >> 	set_page_address(page, __va(pfn << PAGE_SHIFT));
> >> #endif
> >> + 	VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)) &&
> >> + 			page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
> >> + 			page_zone_id(page));
> > 
> > Hmm, page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES is initialized a tad later
> > than page so it'll have stale data in the page->flags, won't it?
> 
> Lance is right. The shared tail struct pages are already initialized by
> vmemmap_shared_tail_page() during vmemmap population, so they're not stale.
> The head 64 struct pages are initialized later — right here, after vmemmap
> population.

Still it looks out of place here, can this check be done in sparse-vmemmap
somehow?
 
> Thanks,
> Muchun
> 
> > 
> >> }
> >> 
> >> #ifdef CONFIG_NUMA
> >> -- 
> >> 2.54.0
> >> 
> > 
> > -- 
> > Sincerely yours,
> > Mike.
> 
> 

-- 
Sincerely yours,
Mike.

