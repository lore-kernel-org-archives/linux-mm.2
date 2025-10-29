Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A5ACCCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980558E0073; Wed, 29 Oct 2025 10:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9314E8E0045; Wed, 29 Oct 2025 10:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847338E0073; Wed, 29 Oct 2025 10:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 732C88E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:34:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC47088B80
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:34:31 +0000 (UTC)
X-FDA: 84051397542.13.BA5F96D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 46024180008
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:34:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hWUFe+nP;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761748469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEmkGkexw0CRk9bcDpskexAnNi17SX4ocXzcH4GVlU0=;
	b=nFGkSGoXiNjUSsLaex95rWSTAJ7eArAKhsTWCrvUq3wdV7ymd2IbQtptLVUVDXx+mbIvrO
	n7m5SOlzvcpmCDfoOFack0mii3A0b53jpMbjFIJ3mIaJj3PK8x0xogaoi7Yj2e0x8idMvy
	oC6XeY9AM9q09YqtfwyJvHUT4Ml+R4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761748469; a=rsa-sha256;
	cv=none;
	b=SmH0bC/a9b4rSFMFiimz6ScfYM2ALuZHeZawckUWrwrxLbJH7FveIMJm9JopLxKasondsn
	zSZ5oRUQniGdfDiTVGyVBOnueWp69+yRDmOKihjl83rBXjpjo5DBlqn4UWNynUGXrcLk1o
	Y8QLbvrWp9ZOgfIncob3R1GYXIUBCrI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hWUFe+nP;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761748468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gEmkGkexw0CRk9bcDpskexAnNi17SX4ocXzcH4GVlU0=;
	b=hWUFe+nPeGj9BTT33Fzh1LANlFSX3IIKpTt3PwGgY76/rueE3/T0dTynpsowWO0PFqnraI
	XpG9kjB4sL4YAUcJOXOgwRqpi2J8JmPYQvxDvrFZ3DvkXhee5nah8Gg2OnhYnzYYoJHdx9
	3PvVhHfAwBN7Yb840r/fiZvE/CWUQ/U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-8jC9rMUVMMOM1avy8DAVNA-1; Wed, 29 Oct 2025 10:34:27 -0400
X-MC-Unique: 8jC9rMUVMMOM1avy8DAVNA-1
X-Mimecast-MFC-AGG-ID: 8jC9rMUVMMOM1avy8DAVNA_1761748466
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee888281c3so5281377f8f.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:34:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761748466; x=1762353266;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gEmkGkexw0CRk9bcDpskexAnNi17SX4ocXzcH4GVlU0=;
        b=GbXzK5mHiqchtLNfgbw/49Ch34bv/9wCEkCP291Gu1K6Kk1jICmksDWvlMV/xt/Waq
         diTbh1B43diuBR1ZxKE6sZfNoJAdS+rmELB8r3yzsCjdu7jEb7N0Ow2pSzagwWcs3oKQ
         VfRl0D6Lx7OdSLSJpnZeTEsLj6w76MnCTdjzpZjGSJeXrAT2zWGbpjSGdWF8JUoeFtRf
         j3jy96cqQTsb4m+mnZlFqTK4TnSdNOwB7W0aHXxyNazXKAqZr67PntbtLnvnMzstO9nu
         DVZcuIDanmra8oPY42Za+BQoF51hEenRMOpHAKktMke9kF3l/s4smTyNKR3d3YVoWNlQ
         48qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoMtlbgSNvdGteLVvITT5a8JRlo5rR6nIjeuDrjBw0q5mKg4JxhRGNZSuESnVpUI1OsrSOfSDa7g==@kvack.org
X-Gm-Message-State: AOJu0YyFD7/0qck7y0+9bERDpIwnNDP24Gh5T69zmuhMIGrkWX0464LX
	FiPEPAW+1hX1GflE/rXDGBDTxc4r/Gef3yb3nUViR7B6ajdGa7b+dH+jC4LJmwwo3Dk4wU89W23
	DQMADnFtYuNKc3mLiCthiftxiIX/Iecnvrxx6wn+h285u+1rcdXhC
X-Gm-Gg: ASbGncu4xhMjGLDY1hluKbheWPsPRAWPkDWOWLXt//oaJtn9pNsJbmbuQBHAAbQIEW9
	HilRjcca74Z+UyvezcaJ7O25QbTrtqQj+kXcxxcrBS8eznH5dPIxK5qZzOGC7Xi28FHc4tTBCfc
	4wx/xhEH37sKbRsNui2h1Id0dsYoe0iw6Ve1lzkWSW7qHgbfCDVxYarv+xvdtJmmXP9iNeiMXnF
	MitCyUS7v4jhZPWXZN/FhDc1U4X1HqZmHPcX5A9TlhGvR/Rw6JXCPBkS8jSJ+elcmgq7OBbjJYN
	97MJhzmsmvYx7sX3LsWEKBiX2F/208qzZG6v/alXcd8pq2nwl5OXrXv+j0yPZc2DpCb5g2swZ0U
	u7jPXYCs6ZgjtzhTDaPQOZw==
X-Received: by 2002:a05:6000:186d:b0:426:d734:1378 with SMTP id ffacd0b85a97d-429aef7600fmr2321369f8f.4.1761748465821;
        Wed, 29 Oct 2025 07:34:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvlxYXsZF/5V2TIO1U8LhBcmcpqSHG8cv2bVPzCWRyBRIJRSugy1iaEGIczCZxlK6usnQ7Zw==
X-Received: by 2002:a05:6000:186d:b0:426:d734:1378 with SMTP id ffacd0b85a97d-429aef7600fmr2321347f8f.4.1761748465329;
        Wed, 29 Oct 2025 07:34:25 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952de4a1sm27199830f8f.37.2025.10.29.07.34.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 07:34:24 -0700 (PDT)
Message-ID: <57b83fd3-8a6c-4d98-bd6d-1c97c71b91a3@redhat.com>
Date: Wed, 29 Oct 2025 15:34:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] Revert "mm/ksm: convert break_ksm() from
 walk_page_range_vma() to folio_walk"
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251028131945.26445-1-pedrodemargomes@gmail.com>
 <20251028131945.26445-2-pedrodemargomes@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251028131945.26445-2-pedrodemargomes@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HhrHAIumFwHVxLKd0LNyY0G-NQ3VSrmN94V83wOEJS4_1761748466
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 1unphfon8s1dza3gpim7aos6ixpmrpw3
X-Rspam-User: 
X-Rspamd-Queue-Id: 46024180008
X-HE-Tag: 1761748469-877593
X-HE-Meta: U2FsdGVkX19vuaVilc3SfljDezy/aEDo9w/ixhTtSSJ9kj93qKZTLsPH+57IMOoBIIifFESAXChcfD6vEmE1+rIvhBgZ6fY13GculkGw3XSAl5q/3Zea+GrnhMLGTo3fCs+5FngEE+WqfP0JGFOmTK7OBi3KwmmLt/EoEseEMbVsDbNR5zPrDI6uwXeb+3ayzbeW4ow0+hkCCg0uSLlfcKgl9zTAZHCC1CAcNkoLLBwTK15dXioVe6nFf1VrxzzP2tHDGaKtSP+X7UN5xZIHEtsGtctsbt9qAiDi+dPTkpeIMRMUl+XCdIfgcBu34TfpG6QavCuzt3Nwndi283Bl/0surrOvrRhd1uKt8viV4jRvpp3jHdNa0JwLavayUp65DUF/OcUl9nKrWaCnoMlUqP7Lss6VHPNYwnVrkusID0oG7gJlZ8dgv6J4uoQwWon+Hg/CplWHXbjWhJvZpKxB2+++JLv3JMdG8X5i6+RneZLmTj0QL8OFqdjPU/YyTi26Ij5ZR88Rsf+b5/tb5k1zgF2oAIdgkjYfwHfofhSYQTx/1o8xNtXGM4XIo/Y2mX0dOTA8EaZkvt2AnBTz04XTLgoDiNNJxayC6sSzLvQkJtjSbWvo/3q81ZM6WCnrhkMlWsEYwwtJZbGUyPSvmbBMdIBFmlcPycbdc47QxV5fbb295QUJbJ7Edonk5sjiFPypUia9A44rXk3cdRo6BkGMyxaBY73v+9cRj5hhl5WSldtnWLZ4lZA4zTyKd2gQkhmo/du76vEY8apdmZ3oxal7N5Bi0Y73T3TN9SBiUQK4A+9KbzI4hRDNCcAW30HiDJgXhmbLVtetmWeEUgiakYHz8GgORcaqRmKu1E77vxOk6W0et6SZkNDrlS6f5QFbBzIFP3sOirttBk1KKyGsOGaxiC4NM7hRC3Tb/IZRbuqfpQXE3S0T86tmUAMykKjoM30+lO08QHEAbZ3bv6p5SvC
 MOvDg2Y4
 89d2pjA05JutheSdKHZY3KUcaFWkp88srsOlT9SSsvossv2hPILLc4GNCUqNQi5skx3K7v5WjyzoI+lqGWXOM0EXCcIWx3eS0IvN3IiuoaCu1EXx+4q6uoTiY8OSlIZSfKY9hsPJt+gIsZPWm0q+jRbS8IRk9F+824FkEpwt9WfqxIixTVc3mE6SPZArga7NhshliqXzuhhsqrJC6J2lgRYGAPDAW1tbZAtMjqYC8nTa5YObmvDfwdMza42l/4VpVhgFmIO2+12nvvTvPFoDI4QnlFr/8OpmTa4U2dwYAZMWj3C+3MrTw0cRNC8xuFCkRWKPZFtFIZNgrBs3ku8cZ17H0M52tlm1z2bvVbi4Nlf0I0dVTeZPwApxbZ2AcuHtaDccKs5Odp86/kmLRr/lGaIo7dO8Taa1x7uK0Yx7f8QgsrcVexaiUP7SUZYHYi03De5DubsrS7ehhJ3/vh4795hTcGwZFL+nN74AQcd8raClnBDn6Gm7naO5cvaej4hN+c50w0uhQiTf26BvlR3kPc5Uu28cDNT1Wi5bOfVztBu5KAZ8KOxEr+HSkKxdVC/lYfVfHANeiTS2ZXQCGHj9Nr45Y6aNuBAU/2yhk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.10.25 14:19, Pedro Demarchi Gomes wrote:
> This reverts commit e317a8d8b4f600fc7ec9725e26417030ee594f52 and changes
> PageKsm(page) to folio_test_ksm(page_folio(page)).
> 
> This reverts break_ksm() to use walk_page_range_vma() instead of
> folio_walk_start().
> This will make it easier to later modify break_ksm() to perform a proper
> range walk.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---
>   mm/ksm.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
>   1 file changed, 47 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 4f672f4f2140..2a9a7fd4c777 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -607,6 +607,47 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
>   	return atomic_read(&mm->mm_users) == 0;
>   }
>   
> +static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
> +			struct mm_walk *walk)
> +{
> +	struct page *page = NULL;
> +	spinlock_t *ptl;
> +	pte_t *pte;
> +	pte_t ptent;
> +	int ret;
> +
> +	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> +	if (!pte)
> +		return 0;
> +	ptent = ptep_get(pte);
> +	if (pte_present(ptent)) {
> +		page = vm_normal_page(walk->vma, addr, ptent);

folio = vm_normal_folio()

> +	} else if (!pte_none(ptent)) {
> +		swp_entry_t entry = pte_to_swp_entry(ptent);
> +
> +		/*
> +		 * As KSM pages remain KSM pages until freed, no need to wait
> +		 * here for migration to end.
> +		 */
> +		if (is_migration_entry(entry))
> +			page = pfn_swap_entry_to_page(entry);

folio = pfn_swap_entry_folio()

> +	}
> +	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
> +	ret = (page && folio_test_ksm(page_folio(page))) || is_ksm_zero_pte(ptent);


The you can directly work with folios here.

-- 
Cheers

David / dhildenb


