Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38339FD45ED
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 20:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99F6F6B008A; Wed, 25 Feb 2026 15:15:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978816B008C; Wed, 25 Feb 2026 15:15:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891816B0092; Wed, 25 Feb 2026 15:15:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 749BC6B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:15:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 480AA13B8D5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:15:33 +0000 (UTC)
X-FDA: 84484084146.05.A561736
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	by imf28.hostedemail.com (Postfix) with ESMTP id 429DCC000C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:15:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=S3uLI0LX;
	spf=pass (imf28.hostedemail.com: domain of praan@google.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772050531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YyrNDRwRzkk9A2IzQ/QDYdpFxKzWLCjN0pyf/juCsM=;
	b=ypbe/W9A4ZKeEd8D2m3thpYj2mwblTugmcJ7ch7B6N84k1w+GsUxjkjMC0CbX8WcgYtefF
	LlYjABx9jXOcI4KujPyIz9rHzrzQGRznRyMI4J6pyM1mnEbONrBXZgCxac+yDy8OjEZuyK
	QfIhimUXc1XC9a4Zhb1B4lo14oHLSEE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=S3uLI0LX;
	spf=pass (imf28.hostedemail.com: domain of praan@google.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772050531; a=rsa-sha256;
	cv=none;
	b=uAKACYMzwUAbXxI04z+2pxkmgOCC/QwJEqegGLPJlc8wuDkZYPR86yihlHfRJOA9UL8rfy
	5rhLv6bJWE5Fu8uxeUQSvHm83EXll7yeprXqoaYSbrGnXm//bZtuVqPd8ZF5ZjF+b94hd4
	CuStMNm+ERoTYIIIOQd4G7kE7TOwd/U=
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2adb1c1f9d4so19145ad.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772050530; x=1772655330; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4YyrNDRwRzkk9A2IzQ/QDYdpFxKzWLCjN0pyf/juCsM=;
        b=S3uLI0LX4/UOtVwBD/jBRSrZ3eqQbvmcAOIzprOF4xh7/1Qh9XwCXPVDawFyuFUUaj
         gDgd6Ous1nzXLixrxwPG8BlhoZZ6136vzqRb4hq2Snkn+OgRdk5FShw4A3IzmjvaZmPE
         qRY7qH5MTaO7hmAi0lzNsSXmb7+CM7t1DxWyIDIF4x0u0VZXf2UMdgSl1QeS+neH2I+b
         RfgX9rJpqHddsn6RpiNeixn8fuy3fZWy+oCl4TsPYmGg4YZ2FZKyXwRp3ORgDPmRD1ZO
         niaYK5hjzeidlfnkxMoVJqKdN4l1J4wAKhYFAMG0hnZMyULOj4uDHgLeAFBng4dRl7rb
         4UYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772050530; x=1772655330;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4YyrNDRwRzkk9A2IzQ/QDYdpFxKzWLCjN0pyf/juCsM=;
        b=ACiRlSLvFK5Ci75msT/87UarTk8t6Lc9cNZtg9J9WziwSH5A31j69fuctIbbq2MPaK
         RgEz6UfBPYXCLT9dk8qDafAVhumyEFONyNOb/NXpoRITkn7Bw7SCO2ID7oYK4oIXfUz4
         gCbBAWFmW905+T1/lr0cBTxNmziI5NBKEWz3zmL1afOUbUC4cyTImSo1XIWsOf9/YMhT
         wFBaY4Fw3oLYwa57SDXoFv6UVz+qVXUQHcpqN4Z4/qWuhONS+XRJaIHK4R9OseM+DJTa
         gvAN2VAamffWmpDqkSPvxCELU0k2Dhp3/NhvfnE8Sc/9tqJfYAn1NNi+EOQzWCi8bGHb
         D6Wg==
X-Forwarded-Encrypted: i=1; AJvYcCVo9PSEY6EzpH3Hgi7a2reA1YbJjeiU6FfKS1updha1P83GYW3RmsaTFUBVkId/EVWZ2Bif2NQtAw==@kvack.org
X-Gm-Message-State: AOJu0YyWloMArhaB/9UdS0OWzZfeZ6IbhZMgK1EEE+C7zDcuoC+Dlonf
	X8B8n/Fmvi2LyFCBVagJ5qRrLMwR7nz2lzLRtzfA0cf9sme56P4HvZ0UzenpihbQ3A==
X-Gm-Gg: ATEYQzzB4GdTP2zc0JQiSgLpZSbIa+PGFmy1KzvcnEUCcNsD/UbjjlJKt6g/pG5a8OC
	WppKnNuF7RrIlU/pGvEaalFy8Yn/zpC1UWDEfBe9KlH/8SW7/GXnkYOQO5dtJOYy12ZoCUzMGuL
	EOlQghodCHxccn5yCbZ0rimIk6eT7spiylp6y7LI2twb4YjCfH/23y8Jjq2M7cySVohYeifubXt
	dudZw164PDR++EiI7zXkzeAqmqR8o/ocS1sdV6Czioc91Tw8fLRCGtlRKZHbFfdgCN6ZpTrAfYF
	YzPaj2IUiXTnWLCQT4yG9jqgOLAkzd307wDBljIpvykQIwCgvjqS/ceaO0ypW8cqyfvRMBkARLe
	cDcBlRLHgqgNG603+Ds4YgQgO3VVAndgxEWAJVfMLS0HMKZcDJ2oYlN/cVXCZyHfq+nLAhBX2xl
	Q4Y6mt7EPe/ybzPJ+/JrOWN/QiswvdXcjQa5x0FlOyiaFnPUlaTeyLr++9ddYE
X-Received: by 2002:a17:903:2a86:b0:29e:27f4:bac0 with SMTP id d9443c01a7336-2adf77c692amr376915ad.16.1772050529556;
        Wed, 25 Feb 2026 12:15:29 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6d5970sm502335ad.80.2026.02.25.12.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 12:15:28 -0800 (PST)
Date: Wed, 25 Feb 2026 20:15:24 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Ashish Mhetre <amhetre@nvidia.com>, robin.murphy@arm.com,
	joro@8bytes.org, will@kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH RFC] iommu/dma: Validate page before accessing P2PDMA
 state
Message-ID: <aZ9YXDleB5XyC7zt@google.com>
References: <20260224104257.1641429-1-amhetre@nvidia.com>
 <20260224123221.GM10607@unreal>
 <aZ4Q1HA9q1ojsVYY@google.com>
 <20260225075000.GA9541@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260225075000.GA9541@unreal>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 429DCC000C
X-Stat-Signature: moiwhsmq8n38hqrdert3fp13cmkssc63
X-HE-Tag: 1772050531-917499
X-HE-Meta: U2FsdGVkX1++1HnS2h/Sl+I4Tvz/0lq7WLJSstcwd9Gn2wS5jXIPv2OyTIGNucbF4HdWzbQVeps7a8F1brIKlXVkGL+wwST6qMEvwN9JWLU2VACTGvc3sit/CGEQ+j0bLrgOxKu1d8AR9QHnj7m1X1t3LeVS+vu36PLqBFHuhAiSumQyLcnR4QYZQnwvMnPbKIrUwrz/lAh7/W0PWRt9aFuX1D4wU+a01CSL+Pp440L0Yhrss1wdkLdsQSbf5RUATTLi8YZdlophi/2Wm5cAwxD2Qw5Eb1Hi1fujClTi43RQPXV3Zf/idVZPkjaRKdGq5a4BdpE+tTOstehjIo6hv13GSA4pGo5T1XaQ/Xdq4NICbAKHMG2/FyC4QU3dIBcSE15Y4GT9X7/AASd8vjF05EKew3mcslrb9+y8onx6r6RUUbC2ged8hRmHk9WSrctuKHAna88yo4gbI0Kn2EPcv7zMBXbJv01EUznFyEZuk4zpl6+EXJ/OhKjaoZHYVo5y1+mW5qfLLEfho/fwrhQpmFOP+CX+MxfmgkVXotYSWfmPmShiE6DYRJpfBZ/IkGg95xbroQ0Ny4YFmy8yOUg7ZzZE8mZIMJZ+xDISKpJu/Jr9Cf6/voz0i5wEIWXIh6hLLnlptOiUQgJ4yQVuSq3BYIN/M+YHXJjHEUtDvwbfD+Y2LmqNQrGYvfc2REh0aUjYoPJBS8R5ZG4QUah2ikkqdw63PhZQ7OwHEWnZM/d+nGzuJKkUVxbQ8lmtqpbb7uHcsZvwhDKzWEhiuX4Mv7UG5Tcvc6GqkbR1DinSZd9eUzTHSVaIl8MYDAE2TdZhFF1yrCwdFNJjb8+ux2jTLNgytRMsplc1OA3q6b5InICMNLRnp91ykHIkovubCg4tpzjZkoCcF3hsV1GHZy5CxwRkBQffKbD3a07i8XuydKU9DK7LBpmjPsbD0Pb/HKFUipk5yJg+glqBbZ2G9XhVqmI
 NuyBmYg5
 /kZVWbVYxft/4hHjpIBt7zgW38QJTFjX+pctNarznTjAVi+w7bwzGrLujkcVpoqoifBuQNmTM4yShTZ37dpff4/8gT0+yVeHie6Yygp9RaaaGiDgy0N41zno7un5iXGRM/U/uQchSNHCQ1YMVIAP/nUcn973bQGr7/4MA0t4bR/feuKu+lr6b1bPw0IEF17wQ1sVINCDd7eTCYO4TnuYNLThNaB788enJZwEeFaiKmz3Qw42qABczDvyLraYRDiEEHcNLygIVaCzhptPMl5G4MGilWQgFBi7gT8/z24gsOt626cL4uppNvLw60jRoKmucdbY1e+PotLcOgcwoeIQKrh0o7kikUpdkuBQHQYVr/t46ySUb0D5JCHKGhbsA6iMXH8sN9sFZ/wpURjIg9iHouFMJmjPW1UdXF0UJgICwV6V45TIe/CYnocmdD5kKav9jo+Q85bFVDhjuAtUUQ+netgFshnOAeFrw+5XyvxUtbbz/5OG/HX0zOG/eTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 09:50:00AM +0200, Leon Romanovsky wrote:
> On Tue, Feb 24, 2026 at 08:57:56PM +0000, Pranjal Shrivastava wrote:
> > On Tue, Feb 24, 2026 at 02:32:21PM +0200, Leon Romanovsky wrote:
> > > On Tue, Feb 24, 2026 at 10:42:57AM +0000, Ashish Mhetre wrote:
> > > > When mapping scatter-gather entries that reference reserved
> > > > memory regions without struct page backing (e.g., bootloader created
> > > > carveouts), is_pci_p2pdma_page() dereferences the page pointer
> > > > returned by sg_page() without first verifying its validity.
> > > 
> > > I believe this behavior started after commit 88df6ab2f34b  
> > > ("mm: add folio_is_pci_p2pdma()"). Prior to that change, the
> > > is_zone_device_page(page) check would return false when given a
> > > non‑existent page pointer.
> > > 
> > 
> > Doesn't folio_is_pci_p2pdma() also check for zone device?
> > I see[1] that it does:
> > 
> > static inline bool folio_is_pci_p2pdma(const struct folio *folio)
> > {
> > 	return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
> > 		folio_is_zone_device(folio) &&
> > 		folio->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
> > }
> > 
> > I believe the problem arises due to the page_folio() call in
> > folio_is_pci_p2pdma(page_folio(page)); within is_pci_p2pdma_page().
> > page_folio() assumes it has a valid struct page to work with. For these
> > carveouts, that isn't true.
> 
> Yes, i came to the same conclusion, just explained why it worked before.
> 

Ack.

> > 
> > Potentially something like the following would stop the crash:
> > 
> > diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> > index e3c2ccf872a8..e47876021afa 100644
> > --- a/include/linux/memremap.h
> > +++ b/include/linux/memremap.h
> > @@ -197,7 +197,8 @@ static inline void folio_set_zone_device_data(struct folio *folio, void *data)
> > 
> >  static inline bool is_pci_p2pdma_page(const struct page *page)
> >  {
> > -       return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
> > +       return IS_ENABLED(CONFIG_PCI_P2PDMA) && page &&
> > +               pfn_valid(page_to_pfn(page)) &&
> 
> pfn_valid() is a relatively expensive function [1] to invoke in the data path,
> and is_pci_p2pdma_page() ends up being called in these execution flows.
> 

Right, that makes sense. Ideally, it shouldn't be there at either of the
places (iommu_dma_map_sg or is_pci_p2pdma_page()).

> [1] https://elixir.bootlin.com/linux/v6.19.3/source/include/linux/mmzone.h#L2167
> 
> >                 folio_is_pci_p2pdma(page_folio(page));
> >  }
> > 
> > 
> > But my broader question is: why are we calling a page-based API like 
> > is_pci_p2pdma_page() on non-struct-page memory in the first place?
> 
> +1
> 
> > Could we instead add a helper to verify if the sg_page() return value
> > is actually backed by a struct page?
> 
> According to the SG design, callers should store only struct page pointers.
> There is one known user that violates this requirement: dmabuf, which is
> gradually being migrated away from this behavior [2].
> 
> [2] https://lore.kernel.org/all/0-v1-b5cab63049c0+191af-dmabuf_map_type_jgg@nvidia.com/
> 
> > If it isn't, we should arguably skip the P2PDMA logic entirely and fall
> > back to a dma_map_phys style path. Isn't handling these "pageless" physical
> > ranges the primary reason dma_map_phys exists?
> 
> Right. dma_map_sg() is indeed the wrong API to use for memory that is not
> backed by struct page pointers.
> 
> Thanks
> 

[--->8---]

Thanks,
Praan


