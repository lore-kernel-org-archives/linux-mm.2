Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B8B5C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 04:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E006B00A9; Thu,  3 Sep 2026 00:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5A36B00AA; Thu,  3 Sep 2026 00:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D276B00AB; Thu,  3 Sep 2026 00:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1B1A6B00A9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:10:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F35FA0441
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:10:41 +0000 (UTC)
X-FDA: 85171124682.12.8F7A37E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8F2C820007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:10:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iLrCPn6Y;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788408639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dL2GJG9/VEyZC05fJEAiBzLjrdjvGGpM9qesuwNO/8A=;
	b=wZ3q8qJ34ATuieiP0cCvZ+MhX1sRdBZVu1TWLImf52gH67HstuePKJV4fcRBUX8hBOOPzn
	sWveq8c59TRb/v+qhiDvAjQSWrzVta7SM6m8epXRdH6LM/7l1MJ/LioZwxb9GZkrw53edm
	w97+GmpWf5Ofi43Lf/9Zgg58p+8sZps=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788408639;
	b=AwELxuCr7Yfn7eiGe5+JidwKuEH0D7Qs8CA2Xg7Rxd9ZsOHQIg1aFy3Nuf+Tah8AgeZ8KZ
	EPhK2mOOwS2tWtyyflhxdWyi4W3dHsw9SjYqmsUhBpj3wz0HKa7sEzakNsrJLZq9y2qbyW
	YNt8roY5b/SZiBcHPYpVCkdap7NAf6c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iLrCPn6Y;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57FEB600C8;
	Thu,  3 Sep 2026 04:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A4F1F000E9;
	Thu,  3 Sep 2026 04:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788408638;
	bh=dL2GJG9/VEyZC05fJEAiBzLjrdjvGGpM9qesuwNO/8A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iLrCPn6YZCAlBAwXZwTAIdv0FOoVgaIvXkp85YUvAtva/DcWv+UfPMmZ1f1Qeel/M
	 E3o716U1yotV0GGqCyL/NVfk4KWFdUrX2QxXClXlgsc4i8GDaPIrQtztSq6ciJ1Qwf
	 Msb3J6OsTV+BEs5F70tk9Ku135lnzQZSNKAjACYA=
Date: Wed, 2 Sep 2026 21:10:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com,
 rmclure@linux.ibm.com, andrew+kernel@donnellan.id.au,
 pasha.tatashin@soleen.com, kas@kernel.org, tj@kernel.org, rppt@kernel.org,
 rick.p.edgecombe@intel.com, yu-cheng.yu@intel.com, orsonpeters@gmail.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, Vernon
 Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm: Fix pmd_modify() dropping the dirty bit
Message-Id: <20260902211036.8184c6e5535669bd73c71fd0@linux-foundation.org>
In-Reply-To: <20260903031608.1194238-1-vernon2gm@gmail.com>
References: <20260903031608.1194238-1-vernon2gm@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8F2C820007
X-Stat-Signature: hhganwiqhy4nc7js89p9nsnn78h7aw8f
X-Rspam-User: 
X-HE-Tag: 1788408639-558331
X-HE-Meta: U2FsdGVkX1+eKHKlX4H8vIv/gYU7LQknPzvzu7cbgUcSrjllBkmcuaJg6iHwyFvH3Mqd4RMVdzkyhuuGv62f9IYcRdZGOUHUBQjAHk6vOFBwxwXWUGaEOOX6RJwnCdJ2m7hmcqcS/NXiJDXR/+RlovObwnV9LeBqGtsb31sXaa9gpjL7bYNhV3Lur+p1eXEXhQ2CnDxKOA4RiWFqdSpf5gHnXwtxQDq3nXoIX9mA8BcVO8IEuhf8DIHCnVh14NHOl1UF0x2JvM8/Bpe9XZ+X/kAtmkLTATK7ilL0XbjXqPmPlFRk9xbqS7wwzG9rY1ywoCI3jYtC2Nb32uB3slBle+pvOG3nigRuIljdf3SHnqtlh6aCBjXtqyXJ0A5bDnbOnDGj2wyI997H3KebSc7BjMQW6nqfKm9xCviJoBYmkuShnODtaM0nIHT29j+WZ9HowYf686QWKkipnrL+QDqW3XbFN+Nzi/9XV+XkjTLcGfjnmvlgq3Dc1VUpMmzUOFMRQDFznmjk4o+V0bOiSTKaCXqMSr3fz+rESJYukh3VMFcFLSn4nTeu7cR+g2CcziOujP5fHOnnqSY+mHzFJQgNsdrF6EdBnnhItqor7Xm3GGyh3KPSTRv75mgfg/KfpOrm+MmAWwrvXFsY1ZuIRq1JTDhIJ7hx9YCkQ6d1DsOv3QuaL7nzdN++UE6Dve/9KJbogki539ggrmPth3PYpRSBnzYsOcdI2ovHj2JgWFPUmDx5H8mm+jcBfTXCR6hvliRs6ypwLGmaPp+fA8shHz8oKcBACsrHj0W86MZJeNi8kREYtjVb1vKS+R4fH04kXnF45O858ZRt+uPEQ+hBJxHpOLdh17Hyb4jSrwkVE7RyIPIrxbMWpPwGlpDrB2sazJuUNaQU7v9yPDz9YGsJ/ZDL9i+1nULlteYBLgRGSPXejepnoKpQeKZjBRlBLoSdsFBTuVZxA1yWSl+B/tHKonL
 cfQI7umU
 XEZSkgm7Etd8bcWap8fb/R9kYdrOs6Y5xsS2FaeUlrnDEHgK5b5zw9hIRhoJGZ+OtnSa+XSaoOxNsjzgg8FrHQijVrE6MU7hdInckxCYbV1bhE5p9C0uWzfQx1Y5XsTM161M6QZYdm9xR0nt+6IE+uyREhTRmdBkdzmAuPJZMaB+8uzZ9X3/AZC+NYogGs4fgMqRnTwPVtKamnZncRPrYizTJOy6rSOsre2trquOkp3QEslgticWRPYlsX1oMVynNDG1IrsB0zID3oNyIVgaECy8JzGhDk/cP2sU+Hb+O+q2b+sEE35C7PIhz/UqwHGRQ1vLvkSVKAx87hcTWIXCJnKocrKAi/iFhMX9CJmdLB/U0L82O6j0Qw6fxyX28a4s0STrqPY7abfYqOPMVGhNenFhwyYMahUUIrHAVvKRi//u04+XXdX59yOd+knbQwn+fbzktNJu6SXbGOhM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 11:16:08 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:

> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> pmd_modify() masks the old value with (_HPAGE_CHG_MASK & ~_PAGE_DIRTY),
> silently discarding the hardware dirty bit.  The subsequent
> pmd_mksaveddirty() call is supposed to transfer _PAGE_DIRTY into
> _PAGE_SAVED_DIRTY when write-protecting, but the dirty bit was already
> stripped from the value, so there is nothing left to transfer.
> 
> Contrast with pte_modify(), which keeps _PAGE_DIRTY_BITS in its mask,
> and pud_modify(), which keeps _HPAGE_CHG_MASK untouched: pmd_modify()
> is the odd one out.  Any pmd_modify() on a writable, dirty PMD loses
> the dirty state.
> 
> One visible consequence is data loss with MADV_FREE on PMD-mapped THP:
> 
>     memset(buf, 0x5A, size);          // PMD-mapped THP, PMD dirty
>     madvise(buf, size, MADV_FREE);    // PMD cleaned but left writable,
>                                       // folio marked lazyfree
>     memset(buf, 0x5A, size);          // hardware sets _PAGE_DIRTY again
>     mprotect(buf, size, PROT_READ);   // pmd_modify() drops the dirty bit
>     mprotect(buf, size, PROT_READ|PROT_WRITE);
>     // ... memory pressure ...
> 
> Reclaim (e.g. under memcg pressure) then finds the lazyfree folio with
> no dirty bit set anywhere and frees it in
> __discard_anon_folio_pmd_locked(), even though the data was rewritten
> after MADV_FREE; subsequent reads fault in fresh zero pages.  NUMA
> hinting alone can trigger the same loss, as do_huge_pmd_numa_page()
> restores the PMD through pmd_modify() as well.
> 
> PMD-mapped file THPs are affected too: mprotect()/NUMA hinting dropping
> the dirty bit means rewritten data is never written back.
> 
> Fix it by keeping _PAGE_DIRTY in the preserved mask, exactly like
> pte_modify() and pud_modify() do.  The existing
> pmd_mksaveddirty()/pmd_clear_saveddirty() pair then performs the
> hardware-dirty <-> saved-dirty transition based on the write bit,
> preserving the shadow-stack encoding rules.

Yeah, this is exactly what I came up with, using chatgpt.

> Closes: https://lore.kernel.org/r/CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com/

We definitely want a Reported-by: Orson here.  He obviously did a ton
of work on this, and it's the least we can do to thank him.  I'll add it.

> Fixes: bb3aadf7d446 ("x86/mm: Start actually marking _PAGE_SAVED_DIRTY")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>


