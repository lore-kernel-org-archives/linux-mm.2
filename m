Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C67BF4BB8A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 20:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B2A6B0005; Tue, 24 Feb 2026 15:58:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6487F6B0089; Tue, 24 Feb 2026 15:58:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548046B008A; Tue, 24 Feb 2026 15:58:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4113E6B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:58:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C462C1388F8
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:58:04 +0000 (UTC)
X-FDA: 84480562488.23.AE532DD
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	by imf30.hostedemail.com (Postfix) with ESMTP id D750780008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:58:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oCmzwMkl;
	spf=pass (imf30.hostedemail.com: domain of praan@google.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771966682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCfIJGNanLX/GKzPG5uplkTp3s1FhuLnYoYswoYHgEA=;
	b=yLxJjjEKbT9HqWCdIBNnZmM6Mb8nPAIioXQHoIkjSwOTu7ErG0CinFHMV/8MhvB+x7igd7
	PlLM1CMiJpqGeWWH738YDiowUbJPD1v7eS1+xf/FWr7MKt0UqHklBji5H6DH5/cSUjxUES
	FUMwyHPE5MpVnTEq/J66fvRCZpihV5A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oCmzwMkl;
	spf=pass (imf30.hostedemail.com: domain of praan@google.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771966682; a=rsa-sha256;
	cv=none;
	b=BoGXxFJ+zbd47u8jJVaNJUNuHv83hXkHgIEivD3LAtn04VHnKTr4DdkcKZrz3C7BRBc0CB
	cGPTQZ5d26bCmZK4j7fVkqqIy1YPYmmcHZOThn/63ojvdFcACK/QY+hkDBcsGd/TFFMlyn
	4OIbAMkGIyPwGrqJPdDVuHHrx6xW12o=
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2aad8123335so5745ad.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771966682; x=1772571482; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dCfIJGNanLX/GKzPG5uplkTp3s1FhuLnYoYswoYHgEA=;
        b=oCmzwMkl3g3HV2DfbtVPWkOR8y1tkjGurKB8SCXyrxsZ4xJGI4GulptShQ3/29zPJP
         kb74RgxNiRtCYoSzQm05alX/N5dYcsvn5HP0tzTBuNym+RANV/jJ2b7ZoxCq6YMesaGW
         8p+XsjMEo90OTM9/61D+eZXKB+zN8gDzx2SI9f3X7DxjHTi8Ad3ZkOtJ//qrz/gV6tSO
         iPm1Iaas4gd9q2G9ljhVdxk79wpoQFKeAvmUuqvqz6IU8DAM5OQ2gNaoy7naWHVhEoYq
         ue1n6p2NoJ/WSbGk9YtIpS5/AYqj2NcSdauffqIqb0eD1ClyIKn1+bPFTc2o9juhMjuw
         0P8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771966682; x=1772571482;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dCfIJGNanLX/GKzPG5uplkTp3s1FhuLnYoYswoYHgEA=;
        b=Lixpo+bhP7KTfx7WqWVZLo7VEjcStsCLau0LapLjG9YzkI0KskgrfQCte3ffOyWDuN
         AGqBKDlVTOiWj676uacNWtI+PTTvY+JihGf1oFOnn00gL9gBKL6SjBrkQjqcWUao288b
         5x5Gf2QvLL4k4ujtH8i8xBK5Ov5YY8heQ/yY/0ui2tWZl0JAvvIlr6SkVG3ACrAcz3V2
         8oq5EGz+CypsS+3+sJqKitwQj0sRAiA2Vt7AHvwmDMrehmCaQ1rBmbK9dvSlJ4BnI52w
         7IEvbjq04PhuJlOmRH9d/t9R7uaWH8tniMKao/lm/o+u/ngfXapcBFb+0KgzvPaXHfiW
         luhg==
X-Forwarded-Encrypted: i=1; AJvYcCWYMxcts4aVcPKrH3u1BAt0Nth3EnFme9k3ayeaxqtJ6AGcKIdJ8mkrayyQ5SYRhXPtiP89a6fkMA==@kvack.org
X-Gm-Message-State: AOJu0YwM+oVjXJvLmcly1CElc/GTra6xijpT8eY2ZXDO17vQurr0JZy+
	bOWXt+aBkQ6D1D1vobCnsVxEnUHcQyl0HY5BkzckVydIH6QDArj609tLkZrRqOcpG5K+kmG5K4d
	+/4M5NETd
X-Gm-Gg: ATEYQzyF/amJf+a9HgsbwVbLifrn1KRu3U+KTmIItqq0ACfAuUIJl+1Y6yNpngVu2I4
	VW3QuFG3Qgo7C/TEG9yMlRKBMPQGyFeClyzMATXLEKbJtTtZCzGCekerrbeqL9UGm749LrOngxE
	JIdN59jkBI4KKrEZbdLAlrwebJ2X0UhJpqdMYNqmjCpf0ur+0MsGw/uZrbNOkZxA4i8I4U8DHU/
	G/k1eo2U09yfJifq9zNlivI6ShgUhRCh1ceWTtKxG12fg3iSYOxUPWpPdEH/I7Ie+VMjkAlzDVN
	9aMCDwN9uQIznj1mw0pTk4AbZpXawlPZAbIK7NFbiK0iI6Xp8Ma1StBqrLypo2KwegWJ9peXQHb
	grptOV9NZnz+MpkSF6VMNVBA6VBJ+hFYpiHv7V/89C61LDz/T4vDfPhvrqfabNd/z0KxSai685h
	f9yP6vPfDUwxnY0t+Kdx17zbnbWS8TTadjRiMV8LYcJjqtwAvI3ifWp1YQ+DNKjm2z5IQPJFA=
X-Received: by 2002:a17:903:2410:b0:2a1:3cdc:7720 with SMTP id d9443c01a7336-2add13b3df7mr25705ad.21.1771966681213;
        Tue, 24 Feb 2026 12:58:01 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35902bdaffdsm686832a91.17.2026.02.24.12.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 12:58:00 -0800 (PST)
Date: Tue, 24 Feb 2026 20:57:56 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Ashish Mhetre <amhetre@nvidia.com>, robin.murphy@arm.com,
	joro@8bytes.org, will@kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC] iommu/dma: Validate page before accessing P2PDMA
 state
Message-ID: <aZ4Q1HA9q1ojsVYY@google.com>
References: <20260224104257.1641429-1-amhetre@nvidia.com>
 <20260224123221.GM10607@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260224123221.GM10607@unreal>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D750780008
X-Stat-Signature: 6inha38cac89z4ckkfrkk6m7ey8gf6x5
X-Rspam-User: 
X-HE-Tag: 1771966682-172798
X-HE-Meta: U2FsdGVkX18aIdBXKf/tcYKlMABv2/wNYd+NOcHzmgMSVSKxjF2JTj2CDKWnwbq55sktXzwfnM+RsX59XHJ+66Dw5YUE92gnoZ/BIGGnLkclgBDfBnLYrixYC1Ze3tXhgkJSWi+np6PsFlbSkmblCrOZTIeecixv2sy1zSYjr7vBuFJhcp988OxDs7gtWmBglecsn5Petm0xdUuEqTbs8oK9TYYV5QYMiHTtroGkZx75YsjnXQNm72CaElPE0teXGdVG4XFlGjkvK8/wZE1s/199olNLCdPS/hfbOcbxlVwL+HSVqBbcaL0SQuwAJHGY/sMF7FDSzVhxFd44yWgjWeZKX2cIiQ2llAiXymCVVd7/TPldzhHHfmJECcw2woMeBqahcfrzOvWv5P3LSxPFPDre/M/0UqNy0WSQSvM8fj78aPYa8MIBLN9A/KrBwoOFo5U9ECj0yluliVpZPLxJN4gXQdRnsVn9AjFzrX6OSQd98g8PqZB4hhC6Sm9Qqa79WJLzoPrNCRdqOedZZMiRMhV7+m5jhITustRnx96qzjyK98w8vS8WBmK5f5Inisr672u2uaU5dWX7U4fyf/HujcuX1M+3OJIyXFehdmcx4DZKfHNMq45kzpplWQqIQv9L9NHkDIxOi3xWHs8YiTxrT4HxKgwfQwuqQOJAJRrRB7V2juGccFdE6l9ZFxjST8kvKvQm9PxkhTQ3/qfD+jiwTTOWpybt/lyv/6ZRMe1m50JrJDlRA7L9aGvo1QLO2zsc7ZnXJC2JuGSF+tnsLkWHoRwfdsRP8bxBZiQXHtS75b0EOJyT5c/7qydbm8QvvwHcMklowVabwO+SQRf/sKAFJfpkNe3zbSDdiRUXghjgeYl5hCKdCu6oCZmhXa2Sfu9BKIOFgnQru0rCKAD+q28ntSgZjGpcW/YROMG1sSavr1WRWxKc6OFYmYRz0v7/vOJjqVjhuVS8F2Ql/2/4sNu
 hjoPdwBK
 Fl8WNw17c5y4b2QWt6uVDo6KgrEheF622pOtoSUpT/NI3XuzkmGEC9hc3awe6f6MzjLPqekWQ51Ydjq56sz/ZHAxWy5U2L98x+fOAufKNrvssZg4jb6GUiUipmuhasMNiPoqslbjYFEaM8oGWeiYkB+DQikMLepgBAXHEUSE//9/JVBusNL6NkwWhmaQMPwzGLu2xs2JdmuDTzB8x0hNVXzBrCeNpMPUEvtGqle/zkZuDj3r64hn2LYQ41lET9RrDoZqd8OJhLbr7UR1AEumc/plIjQ2BHvMkC2tWXpzpbEp6zk5CEyFzgLA26+YibHlhJ5rYIL0HIfcmodebsDCfgk4H/sqQonJN+5ifjha9pQu7yPoycrl34IKnyOFJtMcHI60ImEoWSee0SN+Yf/EfT2k55rFCN3/1+ECXdyTTY9nPwUXFW94OuqLWXP35dLX1eg1SglHFkRrL/fFQttrqlhlVvdJ8W9Ph/Mb7oyIk3/90sHu4P6xV4VkL70WpHkGsEzmLaq+vDHiwSMbtoVkjqgAQboErmExF4CK0aO71IsikZLQNUS3BXVtJyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 02:32:21PM +0200, Leon Romanovsky wrote:
> On Tue, Feb 24, 2026 at 10:42:57AM +0000, Ashish Mhetre wrote:
> > When mapping scatter-gather entries that reference reserved
> > memory regions without struct page backing (e.g., bootloader created
> > carveouts), is_pci_p2pdma_page() dereferences the page pointer
> > returned by sg_page() without first verifying its validity.
> 
> I believe this behavior started after commit 88df6ab2f34b  
> ("mm: add folio_is_pci_p2pdma()"). Prior to that change, the
> is_zone_device_page(page) check would return false when given a
> non‑existent page pointer.
> 

Doesn't folio_is_pci_p2pdma() also check for zone device?
I see[1] that it does:

static inline bool folio_is_pci_p2pdma(const struct folio *folio)
{
	return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
		folio_is_zone_device(folio) &&
		folio->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
}

I believe the problem arises due to the page_folio() call in
folio_is_pci_p2pdma(page_folio(page)); within is_pci_p2pdma_page().
page_folio() assumes it has a valid struct page to work with. For these
carveouts, that isn't true.

Potentially something like the following would stop the crash:

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index e3c2ccf872a8..e47876021afa 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -197,7 +197,8 @@ static inline void folio_set_zone_device_data(struct folio *folio, void *data)

 static inline bool is_pci_p2pdma_page(const struct page *page)
 {
-       return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
+       return IS_ENABLED(CONFIG_PCI_P2PDMA) && page &&
+               pfn_valid(page_to_pfn(page)) &&
                folio_is_pci_p2pdma(page_folio(page));
 }


But my broader question is: why are we calling a page-based API like 
is_pci_p2pdma_page() on non-struct-page memory in the first place?
Could we instead add a helper to verify if the sg_page() return value
is actually backed by a struct page? If it isn't, we should arguably
skip the P2PDMA logic entirely and fall back to a dma_map_phys style 
path. Isn't handling these "pageless" physical ranges the primary reason
dma_map_phys exists?

+mm list

Thanks,
Praan

[1] https://elixir.bootlin.com/linux/v6.19.3/source/include/linux/memremap.h#L179


> If any fix is needed, the is_pci_p2pdma_page() must be changed and not iommu.
> 
> Thanks
> 
> > 
> > This causes a kernel paging fault when CONFIG_PCI_P2PDMA is enabled
> > and dma_map_sg_attrs() is called for memory regions that have no
> > associated struct page:
> > 
> > Unable to handle kernel paging request at virtual address fffffc007d100000
> >   ...
> >   Call trace:
> >    iommu_dma_map_sg+0x118/0x414
> >    dma_map_sg_attrs+0x38/0x44
> > 
> > Fix this by adding a pfn_valid() check before calling
> > is_pci_p2pdma_page(). If the page frame number is invalid, skip the
> > P2PDMA check entirely as such memory cannot be P2PDMA memory anyway.
> > 
> > Signed-off-by: Ashish Mhetre <amhetre@nvidia.com>
> > ---
> >  drivers/iommu/dma-iommu.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> > index 5dac64be61bb..5f45f33b23c2 100644
> > --- a/drivers/iommu/dma-iommu.c
> > +++ b/drivers/iommu/dma-iommu.c
> > @@ -1423,6 +1423,9 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
> >  		size_t s_length = s->length;
> >  		size_t pad_len = (mask - iova_len + 1) & mask;
> >  
> > +		if (!pfn_valid(page_to_pfn(sg_page(s))))
> > +			goto post_pci_p2pdma;
> > +
> >  		switch (pci_p2pdma_state(&p2pdma_state, dev, sg_page(s))) {
> >  		case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> >  			/*
> > @@ -1449,6 +1452,7 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
> >  			goto out_restore_sg;
> >  		}
> >  
> > +post_pci_p2pdma:
> >  		sg_dma_address(s) = s_iova_off;
> >  		sg_dma_len(s) = s_length;
> >  		s->offset -= s_iova_off;
> > -- 
> > 2.25.1
> > 
> > 
> 

