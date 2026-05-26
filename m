Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B3ACD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5416B00DD; Tue, 26 May 2026 10:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CACCA6B00E1; Tue, 26 May 2026 10:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9866B00E3; Tue, 26 May 2026 10:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE3276B00DD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:57:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73C5BA035B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:57:17 +0000 (UTC)
X-FDA: 84809874114.27.AD75A18
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6B30C40006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:57:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b="hV5E1T/8";
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf12.hostedemail.com: domain of igor.torrente@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=igor.torrente@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779807435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4uYynv8jqFOKV2j+Ed4KuBsQHA4WRlcoUWnsLzIeZ4=;
	b=aQA9XVxFnL7vH45qJ80VXy+TEAsqUC31LGr8hhbkp1MIUxhlBCVMiucFGxh/GmOd6kYljN
	bx7yAjiFVZKm6SDaGC8dYpAj3SEzhKQzeK2T2gWo/ddZx7XdMu2OWQ5+QkAvHcy4lgbqFY
	ossUwKq67BaXGEUfUDfGj36tEzyUMeM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b="hV5E1T/8";
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf12.hostedemail.com: domain of igor.torrente@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=igor.torrente@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779807435; a=rsa-sha256;
	cv=pass;
	b=KnmHqKvPD2lRDAbZNEsjog3SQ24Te9/aLmzvsdnAFqZv+mylbvlHZUpmT9Pm7WW46Pa8Re
	YHVFSmVwdM39n6wsqfoCfq3IVTYtRkGxBEQF9uQzixgENYPa3r1Z6W4TxBsLlOvCgjwKpB
	TVPCd9FYyUQuyGHx9516N3jfIv5Eb/A=
ARC-Seal: i=1; a=rsa-sha256; t=1779807408; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=h2KHOJwv/HetVmK4gkRcMaDZ33eimcpWHHM5PeEPRQq45uefqxGyI8UMPUPPRcUbdTIYaUZD7w1SFMWYBKu89IbzHB243qco4i5fWfp6YITN+4A9e1Szdfe56IsuXw5HHykMvEFsqCeIYcxpOJV7ffUtjmKp+5TmIWoC/jLB03E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779807408; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=P4uYynv8jqFOKV2j+Ed4KuBsQHA4WRlcoUWnsLzIeZ4=; 
	b=hqYTn7LfxvxFE7NmkT5BmkPrGOtghccxVjM9sgX2NvC0+QTbBHhnQ3+8tcah9GqWBIcJndHN64+rHl+dWHTTAZ5uURRfqDwanSqb1ukZojpHwM22h9yo/DHEWfzE5USGpJA3JdbpLkUzFYFZwCED/SdbYVFTysuV5mc+AcxZjsg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=igor.torrente@collabora.com;
	dmarc=pass header.from=<igor.torrente@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779807408;
	s=zohomail; d=collabora.com; i=igor.torrente@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=P4uYynv8jqFOKV2j+Ed4KuBsQHA4WRlcoUWnsLzIeZ4=;
	b=hV5E1T/8MTAT4Kcm3HZcECqZpSMGZPLYtuR0bZHam71+bZyItXhR+BYje4lQFK85
	2UOu66gOiqCfHehnpZcEATLZopMovi1tYD1fEbofP+W+4JcokYPr12doZDqRKiGRq2D
	pcK2CcwVivpiaFDbzT79RYbBtzR+6gUgYsa2+kMA=
Received: by mx.zohomail.com with SMTPS id 1779807405712511.32591999559907;
	Tue, 26 May 2026 07:56:45 -0700 (PDT)
Message-ID: <831c0943-c75f-4d42-aa5f-90ce34cf8530@collabora.com>
Date: Tue, 26 May 2026 11:56:40 -0300
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
To: Thomas Zimmermann <tzimmermann@suse.de>, boris.brezillon@collabora.com,
 loic.molinari@collabora.com, willy@infradead.org, frank.binns@imgtec.com,
 matt.coster@imgtec.com, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, airlied@gmail.com, simona@ffwll.ch
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260209133241.238813-1-tzimmermann@suse.de>
 <20260209133241.238813-6-tzimmermann@suse.de>
 <d89422f1-f00a-47b1-b68a-d949d6d6a974@collabora.com>
 <850e8355-7884-405c-a70a-986ce032c019@suse.de>
Content-Language: en-US
From: Igor Torrente <igor.torrente@collabora.com>
In-Reply-To: <850e8355-7884-405c-a70a-986ce032c019@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: xug33b865ocxyt1fyuidonpm5yrhz4ce
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B30C40006
X-HE-Tag: 1779807435-146434
X-HE-Meta: U2FsdGVkX1+Jagp5TqUb3olOXpspUDbxLDmUD8y/sqRdOdD47VcuW4P87NoNEmrVEOg/hwcMQ0gSkdS1rmHaxq63+2ZggWU/fvdKFDvOeWRYXR0gMa/Q1ijonam/tirRKpTVnUuw8zWrVDpOou5/zi8hH6CySh9DGW3++1b5AkPqFr3EE80D86aT8/ZMvRQc8zd1rJZBmIgnM5OMi8kSxXSInrgn5WbvF4+lsiOWxRtCFdYl32+P3vPZP3oeY9Vi9FAY9wbPvOwH9+zmC3z3MLC2PZ1ZePwDpX2rayuTNfZxijI1Ct2UfzqMDhdSFGzT4UQt3rxcynvLI+EnSBainPKaKz3n8LWqOIAhzITRgCQZuBPnklNTDeM4nEdkamm22d3EngYonHfY25LSlWRmeLtTAL6pczM1beQTnOULmt83bwXP3jrJbEwD5ZW5Zz2xmPwPXHzWyb4gJ3JYP9GwXkYMy99eABuRUGCcZTaRR345qt1bfA60QP1kpkokk2njzWrftpGCZvDu8WZqLLILqJjkGtZ6MWe8MxW9AnFeUehy1v96dEUb2eCIc2g2ZrCmH20VKt3VS6jjrpPZAwI10VINUxMUxP7vCn4YU1Fa/N+8aaCMilnX2xVvVKvi6LrZprN6pq7tkWrY66jJ3kMA/B7qVSIQpFnqrlWEcBh+USA2Hj4F8P2Oj717FqG9cInOtzRV1I4Tsx8UlAZJeDewMxlYKsfKXK5lIeoZ+OieGlQ2+RijZ1pKS52tOadpdjiB6nZyQw1J2OHFKhT5xz8LVOHZ12yTRTVK75Bqgxqr3F0+NgEp/V5O7wRlml94KkZh6Mnghc7T/s8eETRIEPOXithmAXzumviAvjTjFkg0DJiT3vWTw/YamIYm7n4n5iPgOT/CzlWmfVx5+mi5Jf5XzZSD+/VdH/Zwf6SgeYLKf6joIVaRQqPDWrFCPG21kgxZfbonCSl439fKzq7cTpd
 2rASqGrj
 MnZX7ajPl7WvQbkaM6VZaCfCMkGRGfI5G4Q5Iu/Py0FRkxMRQQQYHXfWa2GeFSkXHKrhAJVz7FjXZTUQdgZFq8H1Zv0nkhUIKS9/yC3Bw/PmkXSZxZYJZbJopy3eO+IFOtLQ49P1yZ0dKLUuOuVIzg0n22VP7Qe83n7SwWDsvPHUB7kIs0u2HREZcR05rlR4vbiHG2lE2ZEJyLbP3YfaBKnjWerQPObMKUkIiKNsQ3v9Pneh5DPk1vfUDmf1e5ElapXV7ulvExuAxgzgLwvEayXVBgpvUZvvoFTRE0SCInWFJ4Sku1CAz7kFiK+OGI/4K7rC48OQuQ82RmbK/cp0H6+aREko5fUyUhODVY6QXaSvmRjqVn06fDoaStrXA0az6xwkEfLBO02f8k1Ggp7f2PA+H2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thomas,

On 5/26/26 11:44, Thomas Zimmermann wrote:
> Hi
>
> Am 20.05.26 um 15:11 schrieb Igor Torrente:
> [...]
>>
>> I'm not familiar with the drm_gem, code so I don't any more 
>> insightful information
>> to share.  But hopefully we can find a better fix for this.
>
> Do you have huge pages enabled ?

No, I didn't even compile my kernel with huge pages. I've already been 
burned by that before


BR,
Igor Torrente

>
> Best regards
> Thomas
>
>>
>> BR,
>> Igor Torrente
>>
>>> ---
>>>   drivers/gpu/drm/drm_gem_shmem_helper.c | 20 ++++++++++++++++++++
>>>   1 file changed, 20 insertions(+)
>>>
>>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c 
>>> b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>> index c3a054899ba3..0c86ad40a049 100644
>>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>> @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct 
>>> vm_fault *vmf)
>>>       if (ret != VM_FAULT_NOPAGE)
>>>           ret = vmf_insert_pfn(vma, vmf->address, pfn);
>>>   +    if (likely(!(ret & VM_FAULT_ERROR)))
>>> +        folio_mark_accessed(folio);
>>> +
>>>   out:
>>>       dma_resv_unlock(obj->resv);
>>>   @@ -638,10 +641,27 @@ static void drm_gem_shmem_vm_close(struct 
>>> vm_area_struct *vma)
>>>       drm_gem_vm_close(vma);
>>>   }
>>>   +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)
>>> +{
>>> +    struct vm_area_struct *vma = vmf->vma;
>>> +    struct drm_gem_object *obj = vma->vm_private_data;
>>> +    struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>>> +    pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page 
>>> offset within VMA */
>>> +    struct page *page = shmem->pages[page_offset];
>>> +    struct folio *folio = page_folio(page);
>>> +
>>> +    file_update_time(vma->vm_file);
>>> +
>>> +    folio_mark_dirty(folio);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>>   const struct vm_operations_struct drm_gem_shmem_vm_ops = {
>>>       .fault = drm_gem_shmem_fault,
>>>       .open = drm_gem_shmem_vm_open,
>>>       .close = drm_gem_shmem_vm_close,
>>> +    .pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
>>>   };
>>>   EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
>

