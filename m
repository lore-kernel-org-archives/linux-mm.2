Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A58C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D9946B00A3; Wed,  5 Aug 2026 03:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1986B00A6; Wed,  5 Aug 2026 03:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF1F6B00A7; Wed,  5 Aug 2026 03:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA226B00A3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:25:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E24EC1A035A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:25:42 +0000 (UTC)
X-FDA: 85066380924.27.9BDD661
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 52E0E1A0007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:25:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JJAnyke/";
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785914741;
	b=Mi0hW4/8tyiZiMS24lTP7evwwMeEtowFP/C8dorAJZhwLlo/5RE0zl6eHo38a5Me8u6GFa
	eRpHguFIZCIETojYAdJ4n/+Fetd/13N8Fbb5DbWgRyVSWd9+zwr6a6zBP4tF52w1c1d8Tj
	UZNz2+YnvJz1GkNBN0T96dYSaUB0vMA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JJAnyke/";
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785914741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JXqpQV0NjLsf1xiQKEbDdQ70WObdlUyTlYYy/kTGrw=;
	b=zG48rA5HwF2Q+zaRidCxIOOAuTyo8glaGiDpoxFyWa/frXdptsSkcg7R5FU9Ms3H5JYm4j
	1yR6+yOINwPjx+He31DQJObDYY0SdFK01JONsLnjhyaRd7xKvzaDd4TQgft7A2lhmUqd8o
	JVCGhN5A4AoQxkXjIHkWUvzIclTMUHA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8D26600B1;
	Wed,  5 Aug 2026 07:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9F31F00A3A;
	Wed,  5 Aug 2026 07:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785914740;
	bh=2JXqpQV0NjLsf1xiQKEbDdQ70WObdlUyTlYYy/kTGrw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JJAnyke/EwYDi87GOHBCKaeCVp0G7y3cs8S/wZaXXAdTXu4eFCW9jV8bXyJz0XTBp
	 Y59DjAkbYzgJR4Xbn3ijJuOyURRlH2G5QYfD1m/Q/By9/3RR5IzjY3exP70+Lsbr+O
	 7xfVSGK5+uj8M14+m1XFsPsZu8gb8JRzNUB5Z7Qg1W1pXWKOJocwSBn4muyILbctXe
	 VnoyaZpBK1wGiQ/B4OBec11Pdl4X7IKTcHnM7rO1RcGST1MZrePAAZ9YROj1oivOBH
	 kD8eT9e6sBWr4f8t9GuWcPCV7ENYta78+GVmp7jWuRUqPMnoSJc71VBYDTYD/KcwP+
	 2Mf6eTPlQJzKA==
Date: Wed, 5 Aug 2026 08:25:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 07/15] mm/rmap: track whether the page VMA mapped
 pgoff is anonymous
Message-ID: <anLlVomkachZWbk-@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-7-e8ecfefea812@kernel.org>
 <1b48cf7d-8906-43d4-a85d-5cfad10a12ac@kernel.org>
 <anCcMvnsux22LaWU@lucifer>
 <007258ed-3fd7-4d90-b909-6fdda15e0485@kernel.org>
 <anCmQdKzZFRMqcxs@lucifer>
 <f31fbd7d-2e8d-469e-ae8d-abe5b7f6e236@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f31fbd7d-2e8d-469e-ae8d-abe5b7f6e236@kernel.org>
X-Rspamd-Queue-Id: 52E0E1A0007
X-Stat-Signature: e56ipqrcmzm5zzb9zy5ioefmj6tj8oab
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785914741-722165
X-HE-Meta: U2FsdGVkX192fGieQjmaHfyppk4Vb3nQi/nPjYDS3FwUgjCR2Jiz5ZkacQAVu/mj25dsErKzqa7Nj22w9skI3qrGKlUgFQ+N38k8YOaSxEjbu11G/QRodGbnXYL6KYsVLrLkgqJUV1n8pCEFuEzV00xOBMO1oBva54Lz5QSOsPdCRB2Xv/4PvTUoer9LnDH/rLKnM0kEahR5ozqC6kig+ZcJMl/0XXsXn3dOZQ0YR7PkgDUOt3dcSFxLqQVKDKGtXlcyEL0GuNRqRn4jf1jW2ElqhsHStMoUHyd9kSSo7tvpp1Y8H5VKA7H3q9lkIS+8XRlFfbErtCO3RMv7gBcP73N876qMpaVY4K8lj68Bus1TG2PlaCJbYICk55g58/PlW3lBoybgbxJBWWrrsZaRTkd1Iuv4akv8W/TCf3XXZwba+vJw8YI67PpdAFC82l4vgA6TUkpjVRX54CZwThwJnbuG2gVNvVM4xHdiwtot1EnmuvvzAWuIVqCJyKsoUnEKir1EzGOrBjVPJCziVW6moNFvRpyvGOAm69hT2fvlwuiaghuQRD8UiSslq9aDACjPq2hvMpnU2rYKg+OtN8p31Un1ncWA6WbLFKQp0CKAPB5DdQUljg0YRFQrr/4XMsYTHkhju7+2WKVorauqdqSN9tjkJpa0ftS759GkvU3JHPn5mLE4ryhhu/eRSA0hxpbj+TKzsVSLqSgv/Lb8zD5/iUhAiIjTi276T5UcBMy7WTRTVTejRF5xttkctSW2YB+cwaL/1cRG+Gp0oIG3mGR2zi+oQx3WOAFguHbtbWjLPcZFJDPCYBO4sW5wxtuUixlmASBLTxGgE8x3WtmC4jKoIX+WHs7WxuaE5vXFX8nFiJgJ5njhDBj7bMiKX/iozFwCXRNJY54kbhpFBmhxxnIVu99vT9EVOjztNzfwKoK7famnyPOWirx9mlqZDt9HR0SDsuxPGvJhss66Tx3KoNH
 Rl96Bqmr
 BOHw2tvOD0ipxGMmMSK3zI/91+7Nv9/Umz6/Ylm0YGankcQm8WJjrAxkUUcLAEBd1vjFf2xW6dxJHzfsVT1VacRVvch1W4dtRICUP0hI+f+LaRIYfKHNL3tTtwEWgHLmneiRAMzkRf06nOH+1jf8YHqQXyO/OwAjOO+6oFWmPMMzgiDGZjS41ffoNu0LbhSUVMUndW3FfXqrNyj28lZTkeNaoi9s0PjT53Pc/xnqIFM2it6qBtSB2D67giBpzhfm4vWqAw3ojc4RrfFGXhlORQdxGMzU7HrVpgizbSm03gDqSIHuukSPIWscHdcEyerfGP44+CbHPsbcPfPc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 09:17:26AM +0200, David Hildenbrand (Arm) wrote:
> On 8/3/26 16:32, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Aug 03, 2026 at 04:02:45PM +0200, David Hildenbrand (Arm) wrote:
> >> On 8/3/26 15:51, Lorenzo Stoakes (ARM) wrote:
> >>>
> >>> As per commit message:
> >>>
> >>> 	This is laying the groundwork for eventually using anonymous page offsets
> >>> 	as the index for all anonymous folios.
> >>>
> >>> 	No functional change intended.
> >>>
> >>> I cannot enable an effective change here, because if I did I'd break the kernel
> >>> and introduce a bisection hazard.
> >>
> >> You can just throw in a patch that cleans that up and avoids messing with confusing pgoff?
> >
> > You mean do a separate patch for this change?
> >
> > The existing code is already very confusing :) it becomes worse with the
> > anon stuff added, hence the change.
> >
> > I will separate it out assuming this is what you mean?
>
> Right, if the vma_address_end() is not required in this patch (and does not fall
> under "track whether the page VMA mapped pgoff is anonymous"), just have it in a
> separate cleanup patch "prepare vma_address_end() for further changes" etc.

Cool, will do!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

