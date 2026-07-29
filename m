Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666BFC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692246B00A4; Wed, 29 Jul 2026 09:54:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622366B00A6; Wed, 29 Jul 2026 09:54:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50A826B00A7; Wed, 29 Jul 2026 09:54:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1506B00A4
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:54:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CDA68069F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:37:16 +0000 (UTC)
X-FDA: 85041764472.08.0F0F7BC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id E42F940013
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:37:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="HsBO/9wN";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vhLdNBgT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nBonCs6a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BT3fFBrc;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785328634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCPopA3duELZWRFQ7PC+zcU7UIlf1ZyVyMzN0xmYHFs=;
	b=pRAnkV/KJWFBDy//7MqdcopvT8fV6aoKvQer8ecQ/BgdlkOSmctJUNqDgW8D2Ft63NEPE3
	pvXZ2XBB89w1tvqZmfZUx9OylyIO8Lh6AIYdt6zAFu3RZ/7AzrSYvsLWHLiqhocBLNzLYO
	lZGS+o7SoKgsbOn/Hov/mjk2sbW5IUQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="HsBO/9wN";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vhLdNBgT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nBonCs6a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BT3fFBrc;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785328634;
	b=VtXlsDlX+OxGpg9mNvg7KVdI2vef7+XttiUQW1dMSkh00XwNoVFn1xStjHkw21NaLVtP+2
	HAwnazS8t3CY8aiSuUIRzeGOtMGU3/VIRNTnb6nsEM4maEbJxiWGyNlbEmr1DSEYtnAMx9
	TEdapHTutuvO6/zNfG+CJLBvJuizPOE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0AE6C7CAFF;
	Wed, 29 Jul 2026 12:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785328628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aCPopA3duELZWRFQ7PC+zcU7UIlf1ZyVyMzN0xmYHFs=;
	b=HsBO/9wNGNK0BBi/KZnybjT4wfzH1RbauNRa3BkCq1Gz1ZFYfyulio9BMMz/Qhlayjht8v
	gD7JzPlP/j/lbzamJYZIEmtCD/24X5mlh9Cm7ueizVVj2a3/38UgR1iUgozDxsYGd00nVJ
	81gftDjjAsCoQcZd/g/wQgIFNVzYSPo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785328628;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aCPopA3duELZWRFQ7PC+zcU7UIlf1ZyVyMzN0xmYHFs=;
	b=vhLdNBgT3LES3Nfy+reOhuZbF+sRDMgTm8/+rp44QydsQ0PgJmekRb7kN8gf1KeP/gQfF2
	vhVMad65mEjeOWBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785328624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aCPopA3duELZWRFQ7PC+zcU7UIlf1ZyVyMzN0xmYHFs=;
	b=nBonCs6auu91fwhTCPSwwqM/BnHZLlIGXt/TmMHVYSy429b64ZCJOljFWGBAHwpGwsp+VY
	26DPb6Xoz2zlvJd7icT3XVFcHRopeHCqPAv9U3TcLO99ha0MheRXkinzHltD+E4YU5GueL
	hsbqCAyQMiJN0MmV5BgL9eX8TbAHxvo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785328624;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aCPopA3duELZWRFQ7PC+zcU7UIlf1ZyVyMzN0xmYHFs=;
	b=BT3fFBrcAWB//UVTCQRGI3kpRDayFQs1zsoB1XrNCj60pSuBHTbHXO+sVcJVpP7eK4LEaV
	7UMRX0P/16CpuzAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11699779A1;
	Wed, 29 Jul 2026 12:37:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +/ToAOzzaWpxRgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 29 Jul 2026 12:37:00 +0000
Date: Wed, 29 Jul 2026 13:36:58 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, ziy@nvidia.com, 
	agordeev@linux.ibm.com, ryan.roberts@arm.com, linux-kernel@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH RFC 09/11] misc/sgi-gru: use ptep_get() for page-table
 reads
Message-ID: <amnxCmFU40QQaxTx@pedro-suse.lan>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <20260727164715.2866609-10-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727164715.2866609-10-usama.anjum@arm.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E42F940013
X-Rspam-User: 
X-Stat-Signature: 6mmei1f9oh3pu8xe7cqszfmpbmf5wx4h
X-HE-Tag: 1785328633-95994
X-HE-Meta: U2FsdGVkX186tX4CWqCzrrXexW9PGzpPNSv1/FAK/OZJbknOPBaxJfeHTcsD1JlKcnxLcHSGq3SxP3nL3qqLrPCbM8cH9qBoSHKt4Y29LHfZbG8cHM7KOj4Dxqfp/fm9/uTB9hz+Kcp47w1KG1CSmH6BDhVHN+86UJEiZk/QtCE3UzpcHdwIvDkFDs1HSkZWZPt4Vhvywuo88SGPkd+b6yUwS1aViFh0yCZXcX/M5cV/WocWpLJhSIti1QD5Nh7M2tctSM9qAhgnALQo0XRJg+TuRSk3hvxPh4m2nO2w/XM7dPxWlzbhF+otO3EZyLmd63cKwFO9c22bUvY/C7D8+qxxutE3NyZYCs8aCqxJLjYqC81cBgSgSuGLxPXpQI9nHwKrlB1rSpncbVIiWRpXZaaKJFT11n52QALNMrg5Bty77IRuGU8M4twewpjrE7W/bthTLrhgjhsF8fONCmQyLliQFwsDkZeUEORve8LuST9EjU6ZiS8GYCUCZxZhnqUamTGuFT/99AU2OBCCkjkc/HZAxaQUbmW3ZoZbHLeOaU86ELFcBEo+L8dYZR8Zmauxi/7nk83jwutE3tSYHUn3MNOc0hPvohPCwa2gt1iVC7Gr+dLVXWp0AybjnmrLQ6Rd30eqX2pjq+Srk20hVRD9ERHyMk3sfQrUz4gEkTLje3FZZIh6L2qCjytNJX7aMQsk1rMs3eJRN5WWTkoCPKNUkQ9G6BV2jb+tlUN0KtOzkw1XVnjXlBS2HBWqpQZYLUBJqxLDri2ovQFuO6WtD1BGrlEbxGEfGllw4rK0XCbmqIAyn6KL1CINcsuEj3vBDp/qBHoXv2iGyeel1MzHov53sI6dbPzn8iH3ccO/g0kOkJ7nESeO/LlO3Rgsx7JiKufY1hlcJ8ikT5dWS75Wke7wfPSFWGh2sWZfnwtFCVzH+lVBROjOoj5Q72yoM0h0V8KZQjWt2bEXjMNXOJJzNel
 lR79T1su
 9hjLMxXyEK+MU/g6ZNPtbNqxAikGq6mwkd02jmk+NBTTZ9mLWTmXSfhXaGOX5xGj5S3OUBQ/BZxCraQWEXpdBgXIEm4hHxhSxQ2h6PGXMy6gNdckbzit5c4tfLMewr1ZelOtxIoBwWFgP2aHGPfU/OxR4wCO/gvuc0K0qei54UWl+lwc1Lh4Db0KOWR7/WTknnqREdGNUc2W7M7VglMTTKVKOI5ih3pY+/DM9INz/jU+Q1o3xmA1jxMPnpxMwfpLyMf9hbRNrLzgwu4P8WCcMMGEaTFQYqdyCi8IHebynxoCy3A4lUSmdc+Z+F7UAidDu7/VRKNdUHrVwfrZsNhIfLRlzEoF1NaFppLQnQtgPbLP0ZmSgJ36u6JOU5MYQhNuY23BGf622tk+Hsaj8IdBUCqhkRBe/G1HTae9FwJi4rS7INYzIqolxFv3S2aBglvh8hH1y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 05:47:00PM +0100, Muhammad Usama Anjum wrote:
> A leaf PMD is being read through ptep_get() by treating the PMD address
> as PTE-sized table storage. ptep_get() now accepts hw_pte_t *, so update
> the cast accordingly.
> 
> pte_offset_kernel() also returns hw_pte_t *. Get pte_t value by calling
> ptep_get().
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  drivers/misc/sgi-gru/grufault.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
> index 3557d78ee47a2..ff89d34ad2aa4 100644
> --- a/drivers/misc/sgi-gru/grufault.c
> +++ b/drivers/misc/sgi-gru/grufault.c
> @@ -228,10 +228,10 @@ static int atomic_pte_lookup(struct vm_area_struct *vma, unsigned long vaddr,
>  		goto err;
>  #ifdef CONFIG_X86_64
>  	if (unlikely(pmd_leaf(*pmdp)))
> -		pte = ptep_get((pte_t *)pmdp);
> +		pte = ptep_get((hw_pte_t *)pmdp);
>  	else
>  #endif
> -		pte = *pte_offset_kernel(pmdp, vaddr);
> +		pte = ptep_get(pte_offset_kernel(pmdp, vaddr));
>  
>  	if (unlikely(!pte_present(pte) ||
>  		     (write && (!pte_write(pte) || !pte_dirty(pte)))))

This code is super, super broken. Can we remove this ASAP? For starters,
we're using is_vm_hugetlb_page() to detect page shift, the code does not
grab refs on the pages, uses pte_offset_kernel() on user page tables,
does not handle PUD-level hugepages, does not handle PMD-level hugepages on !x86_64,
does not hold page table locks nor check for pte table retraction, etc

I don't think I need to go on.

-- 
Pedro

