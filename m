Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3E73FEFB56
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 14:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF42F6B0088; Fri, 27 Feb 2026 09:08:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCB876B009B; Fri, 27 Feb 2026 09:08:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA956B009D; Fri, 27 Feb 2026 09:08:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B539A6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:08:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 760FEC21AA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:08:53 +0000 (UTC)
X-FDA: 84490417746.08.A9CB7AA
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7A06618000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:08:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KmzJ2wkO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of praan@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772201331; a=rsa-sha256;
	cv=none;
	b=e79hhsO1c/1H1kX7QAYrmBQjiHEBfdLr55c3vPbyRbV3OAqey6xwwaQn1wK4CQeL0219Ht
	85wdBrkvdMF074nOIB8qt1ULM3tE/NJbocHwRS280cMKRksz+AeAp1JLi3xc/0YG1crLZg
	XZG8q2b7G6oMsugYGpXO56LbGRFyqDI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KmzJ2wkO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of praan@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772201331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+478MnXHHm9he6xCScSmHIKPdUGXlF+DBnPVpCD0kfA=;
	b=cIDwk7wTyct8otlY2m2PRqY31PtQocBNASTNmUGV0+qJdkKeuYV2U0v+WQXL3sdnIOGs/6
	6CxjzwR4LJdkwV7SzbK0xTDcUOCmeuAY3i5EMLax5FO/vMvCMJQmwaS9KT3kwad9vyTq65
	ZjEkoVqLHQnw0wY1NjHW5dY6qPGKWdc=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2aad8123335so75525ad.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772201330; x=1772806130; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+478MnXHHm9he6xCScSmHIKPdUGXlF+DBnPVpCD0kfA=;
        b=KmzJ2wkOmPbqnWdoY37OLis2aw09WlNAvGYFU0/PVp5wKh3qgxoMGGgvCfZn2L0aRF
         6FbHjX7DwzPTGWh81bg8FBYuCnkvjQAbzczwkozKPZhjjz38P1iJzEjJAkeFjpu/p4sf
         B7eF8OY9xqJkpd7u5QadLZ5Qe+oDR3IWXNHeFHMqr6PM0aozgvs8HsKjNH8pV+GgLjYo
         GhslDx9RdYAvvBTu6CEPNAImcIV5McvADTuL9rixAuy1rUqCMnWAkVkvMNZ2CT5xcLQR
         aYtDBk6OEAbzWAXYWqvCGCeI1spMmLdvUBekvQdZ3MxF0Ygm6niPH/ZgvzNqp+j92zsv
         EO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772201330; x=1772806130;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+478MnXHHm9he6xCScSmHIKPdUGXlF+DBnPVpCD0kfA=;
        b=GgjStQLSXJbF9TeWJPAsdU2ztvI9XUdoUG4LdIUaOxWGLApe2TufKEuFXwF63So4Qw
         V7UJr3h3fF2wVgVlDHwHuniuupez2p1eo3a2aPLe/cge1mtD2TdBiHMb1i5XC6qp6Z4e
         zmmENG63CSLxEy//7rc0RmojeD7sEzZZwOacNEqqMI9CAQRg04RYFSsf3pp4xbbDIakV
         a8AZFR7333O3BuzrT0VgfvXn+FVGVODiaA7FxxFZTKzs+gsy857GB01NBL89n9SgrKCU
         3eSWRhRWq0ZUi217m5QFEc4tEm5E8M1bb2dgWMZGnudtyDRpGBo+pMRMAQ+N8VlLQua3
         MRHA==
X-Forwarded-Encrypted: i=1; AJvYcCV6G7/gTZIRYTFOmcFpMnIs/sChgPCsUNCkQ+2RYFUdmtsq3jQgCgyS3t4ceDwY/6UxEAnwCvUxIA==@kvack.org
X-Gm-Message-State: AOJu0Yx5vosCHKUh4eHYNb/ipJjeg5PJtcFgskFW0zdiirY55UcdAjqx
	sZZhj9UhYIkMHLsCvDO24rScz4VGbetjJmdo/U16lB3D6VubADcY54JYID3BRN7T6A==
X-Gm-Gg: ATEYQzyN6JDusQdsEA2FZbHo/kkJ+lpkhq4kUQyrjtPU6LOzMz5nR5FmUVee5Yk83VO
	qnC0Fk1XUD30nRAxOGcbTwHNbTnNVrBZZzL7G1psgvDY+ghimIz4LH/LjWx6QAgOjlWO7yrLynm
	kfsTdg25NXAYM+I/ZKolNYelEqYui6QvQDZcH1FeBwY/WgXgdfhpI8DHTagptN9b387mvhx0DB5
	NXkhR/g1pUgJYGwCShwttle2vZxtVMIwFlspTMdXzga8tn9MBpQiWvQatSdNSeNAvnDYoWk+/qf
	VwLQTBQSggzwydQJkGqLPmFJUzdPbclauJJsrFw0Q5LVD1fQx/7WdLb+fgAfHS+Clm6mXzpb96Y
	dXi25GJMddTHBk3uOhUAYyHRixdCunIxWuUq5QCQGUBNWroRUIZtPC2xTSxhGYSzK8db+SheGpx
	ooRSMak0wYWl5+y/Zx96qcMMCURfcVOXD2O6B1DBIN81B+cfnctAl1G//BYjhi
X-Received: by 2002:a17:903:15ce:b0:2a3:cd98:f07 with SMTP id d9443c01a7336-2adfefd95b6mr4837465ad.3.1772201329615;
        Fri, 27 Feb 2026 06:08:49 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5b148bsm77618315ad.10.2026.02.27.06.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 06:08:48 -0800 (PST)
Date: Fri, 27 Feb 2026 14:08:42 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Ashish Mhetre <amhetre@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, robin.murphy@arm.com,
	joro@8bytes.org, will@kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-mm@kvack.org, jgg@ziepe.ca, jgg@nvidia.com
Subject: Re: [PATCH RFC] iommu/dma: Validate page before accessing P2PDMA
 state
Message-ID: <aaGlapPSmFJcXsDh@google.com>
References: <20260224104257.1641429-1-amhetre@nvidia.com>
 <20260224123221.GM10607@unreal>
 <aZ4Q1HA9q1ojsVYY@google.com>
 <9d01b4e3-be5b-4c9c-8088-1d10f67f1fd8@nvidia.com>
 <20260225075609.GB9541@unreal>
 <aZ9Xccnn7JOikudb@google.com>
 <20260226075806.GE12611@unreal>
 <58634d52-5d44-4ec9-b1f6-273b5c32b525@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58634d52-5d44-4ec9-b1f6-273b5c32b525@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7A06618000F
X-Stat-Signature: rw64x99g5r3w7fkzyh1etewmssuwppeu
X-Rspam-User: 
X-HE-Tag: 1772201331-385989
X-HE-Meta: U2FsdGVkX1+Xwxq0xPq+wWzXZUkfq6Bs8zz2wMALH/6B8ttK8NemJSsNoicr4woHlrqL5N9ZFmU4liyjv4Cja7CPjU/cZLk58oZzX4Ah9BSWCEPdsgACpP69ULYK2jBuw1e/mqmmwXCK43ezB+sPJaPPmj8noBC09YUsCeLMIqaB85Hvw7/RTbq1GrwQ4PBnDVdoz/Qmfh97pkYmlIGCUDMlTVBV2St1iJjelQJbgAXm9GIifU2AhZZPmnLpcqUIIMsLRJlQw6NFXXViafWUCiAL7AGDe5WhKSojlI7t5Y935aoeL3WQIzqodsChYXzQuuXojO2BeLz1iHeqi1NFown4d6aAj2eriafsb7+/9fidjylLbsme/LksmpF9gguYkC4Sj/w33Dom6FJUop79ak6x5KHfL5h6kPc1yEb6sIKXrSyvKddF7UatcLNUWXQHpVj/koFNxr39whTiPdLH/uLH+QT8cRyCdAkLlN6nsWoawZN8OmLm5HUDTrPWM4RCWlTVDocpgzDcMKO85MVSdOBKaiuZsYkoxXRwH6TI2vKixL+eaH75PElEvrEuhJs7qCVCmbxTWXNN7HkuKAU809eL55UYtt7AmudF4d6DcwuxMrIbeNvCYU7Z3qAV1HOhRvGGtmQjJ2SGHx0H8IDVTZJkwhfzecsgOUkyJ7hdWhxVpowF6jLHKdYIR/sjSGtm1Z8mPYeFSlk77LGMBY7n3RrNmOvvzp/vg4BSTq4TFo6ANJ/z/K7w8G2uf3tfrqg30LyZrX3+UYGYZK3wV9bubF4FQ3TqBu+Pc2JjN7OsNhFZpXkCxlXfIijCAqfKsoEWavVm4gEskzysLq81VQrm9t6COW0HbJNyCNoUSJeCOKBV8l7cO6i1UswDpVDTqgLSkiephVX6A3iNwWq1LMDVv6zponyjcOiKktJaBspnO6LukeubWX7tfj3ZtyDgwaE9Fc0dfArUhohmNKCmNeS
 yaiEOi74
 DAV5SxXySnYzmk32H5caWLH9iUTs6A6GzjnTyfyVF2xy8J3yC/3HJwTdzJyaY6p+np+Rq5HiROObFgs3rgBwuk6QrCXl3zxwJSTUlPpOEWe+cbtZxqU9pHTuoeffpbB14yp3MJovSNPQG9hUtyj59QwovzvxOFx1+D1EcX6r4j8tgnGF2FlIupXYnZWB0e0P+2EyHTp57MLrF9bnUjIx68BRRsz9sCDIA2y9L7gVXCvmhyaWa1cK6Sn748hLcjI9zmIpUbSkX/hk2UGQfGDvu5nhapjfqslzbhX8x9w0x111q8AENxxBKWQmLmQ0yOrjdfqx0XlmMik+YZ5k5NlDLWVwO39uqzd8SlYVXaF4n7e3rGusdNzTPsC1t9gwqk4mNJE0PKlmA7e1APJFzN0lzKZhkPSzZXeOVYzbdb54X+UD03jz/9c2QXTzwhOo8cl+j+FVpBxEJiSGX4yafY/uDSs7ZUmhvjxqnVR75FygJtKtrnJu4BylvCLnYqgPPoqgcJ/oKSQalZmK25OOseD2G8KXQiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 11:16:02AM +0530, Ashish Mhetre wrote:
> 
> 
> On 2/26/2026 1:28 PM, Leon Romanovsky wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On Wed, Feb 25, 2026 at 08:11:29PM +0000, Pranjal Shrivastava wrote:
> > > On Wed, Feb 25, 2026 at 09:56:09AM +0200, Leon Romanovsky wrote:
> > > > On Wed, Feb 25, 2026 at 10:19:41AM +0530, Ashish Mhetre wrote:
> > > > > 
> > > > > On 2/25/2026 2:27 AM, Pranjal Shrivastava wrote:
> > > > > > External email: Use caution opening links or attachments
> > > > > > 
> > > > > > 
> > > > > > On Tue, Feb 24, 2026 at 02:32:21PM +0200, Leon Romanovsky wrote:
> > > > > > > On Tue, Feb 24, 2026 at 10:42:57AM +0000, Ashish Mhetre wrote:
> > > > > > > > When mapping scatter-gather entries that reference reserved
> > > > > > > > memory regions without struct page backing (e.g., bootloader created
> > > > > > > > carveouts), is_pci_p2pdma_page() dereferences the page pointer
> > > > > > > > returned by sg_page() without first verifying its validity.
> > > > > > > I believe this behavior started after commit 88df6ab2f34b
> > > > > > > ("mm: add folio_is_pci_p2pdma()"). Prior to that change, the
> > > > > > > is_zone_device_page(page) check would return false when given a
> > > > > > > non‑existent page pointer.
> > > > > > > 
> > > > > Thanks Leon for the review. This crash started after commit 30280eee2db1
> > > > > ("iommu/dma: support PCI P2PDMA pages in dma-iommu map_sg").
> > > > > 
> > > > > > Doesn't folio_is_pci_p2pdma() also check for zone device?
> > > > > > I see[1] that it does:
> > > > > > 
> > > > > > static inline bool folio_is_pci_p2pdma(const struct folio *folio)
> > > > > > {
> > > > > >           return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
> > > > > >                   folio_is_zone_device(folio) &&
> > > > > >                   folio->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
> > > > > > }
> > > > > > 
> > > > > > I believe the problem arises due to the page_folio() call in
> > > > > > folio_is_pci_p2pdma(page_folio(page)); within is_pci_p2pdma_page().
> > > > > > page_folio() assumes it has a valid struct page to work with. For these
> > > > > > carveouts, that isn't true.
> > > > > > 
> > > > > > Potentially something like the following would stop the crash:
> > > > > > 
> > > > > > diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> > > > > > index e3c2ccf872a8..e47876021afa 100644
> > > > > > --- a/include/linux/memremap.h
> > > > > > +++ b/include/linux/memremap.h
> > > > > > @@ -197,7 +197,8 @@ static inline void folio_set_zone_device_data(struct folio *folio, void *data)
> > > > > > 
> > > > > >    static inline bool is_pci_p2pdma_page(const struct page *page)
> > > > > >    {
> > > > > > -       return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
> > > > > > +       return IS_ENABLED(CONFIG_PCI_P2PDMA) && page &&
> > > > > > +               pfn_valid(page_to_pfn(page)) &&
> > > > > >                   folio_is_pci_p2pdma(page_folio(page));
> > > > > >    }
> > > > > > 
> > > > > Yes, this will also fix the crash.
> > > > > 
> > > > > > But my broader question is: why are we calling a page-based API like
> > > > > > is_pci_p2pdma_page() on non-struct-page memory in the first place?
> > > > > > Could we instead add a helper to verify if the sg_page() return value
> > > > > > is actually backed by a struct page? If it isn't, we should arguably
> > > > > > skip the P2PDMA logic entirely and fall back to a dma_map_phys style
> > > > > > path. Isn't handling these "pageless" physical ranges the primary reason
> > > > > > dma_map_phys exists?
> > > > > Thanks for the feedback, Pranjal.
> > > > > 
> > > > > To clarify: are you suggesting we handle non-page-backed mappings inside
> > > > > iommu_dma_map_sg (within dma-iommu), or that callers should detect
> > > > > non-page-backed memory and use dma_map_phys instead of dma_map_sg?
> > > > The latter one.
> > > > 
> > > Yup, I meant the latter.
> > > 
> > > > > Former approach sounds better so that existing iommu_dma_map_sg callers
> > > > > don't need changes, but I'd like to confirm your preference.
> > > > The bug is in callers which used wrong API, they need to be adapted.
> > > Yes, the thing is, if the caller already knows that the region to be
> > > mapped is NOT struct page-backed, then why does it use dma_map_sg
> > > variants?
> > Before dma_map_phys() was added, there was no reliable way to DMA‑map
> > such memory, and using dma_map_sg() was a workaround that happened to

Ack.

> > work. I'm not sure whether it worked by design or by accident, but the
> > correct approach now is to use dma_map_phys().
> 
> Thanks Leon and Pranjal for the detailed feedback. I'll update our callers
> to use
> dma_map_phys() for non-page-backed buffers.
> 
> One question: would it make sense to add a check in iommu_dma_map_sg to
> fail gracefully when non-page-backed buffers are passed, instead of crashing
> the kernel?

In my opinion, the answer is no, since this is almost like the "should
the kernel protect developers from themselves" debate.. we should be a
little dramatic to make sure the developer doesn't call the wrong API.
Sure, we could return a DMA_MAPPING_ERROR or something but a silent 
DMA_MAPPING_ERROR can be ignored by a lazy driver resulting in a much
harder-to-debug scenario than a straight-forward crash.

The question is, are we sure to use scatterlists to represent non-paged
memory? 

If no, then why are we even calling the dma_map_sg* API?
struct scatterlist has a field "page_link" [1] which is literally the
struct page with a few bits representing something else.

If yes, then we could maybe encode some information (similar to
SG_CHAIN) representing if the sg is backed by a struct page. And then in
the *sg_map APIs, we could fallback to the dma_phys API if it isn't
struct paged-backed. (This would be quite some re-work and not limited
to the DMA API alone).

But as Leon pointed out that the use of sg for non-paged memory started
as a "work-around" since there was no equivalent API to dma_map_phys
earlier. Since that's the status quo, I'm leaning towards no.

But I think this gives us a nice opportunity to discuss if we really
*need* to have scatterlists to represent non-paged memory. I remember
some similar discussion happened during tcp_devmem reviews [2].

Adding Jason for his thoughts as well..

Thanks,
Praan

[1] https://elixir.bootlin.com/linux/v6.19.3/source/include/linux/scatterlist.h#L12
[2] https://lore.kernel.org/netdev/20241115015912.GA559636@ziepe.ca/

