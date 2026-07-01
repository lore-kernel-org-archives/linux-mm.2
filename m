Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E153C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363D86B00AC; Wed,  1 Jul 2026 03:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF056B00AD; Wed,  1 Jul 2026 03:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5A06B00AE; Wed,  1 Jul 2026 03:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E38BE6B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:04:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B98B1C6A61
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:04:55 +0000 (UTC)
X-FDA: 84939320550.11.5AA8C2C
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 68C531A0008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:04:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=hHLiNgPR;
	spf=pass (imf19.hostedemail.com: domain of hare@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=hare@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782889493;
	b=SngQYI5xWkgsZZO+Z2SgWGWnJp+AJ13cDGC/NqsVe1evD/wHR384IX9H3D/SsDonWU660a
	J/qLuQzSU/iQUafaQRaEEcsHKvtnk1zkEZQ0VQti+YoLYDb3PXgoAagASpXhOezt+5vxKX
	g3rUili05p3ShQDnd/ctfG2jiqHFRCs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782889493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Frs6Emcy9pNNZIaepK2NrL0xBcYA3u3r9RRnho4i+Lk=;
	b=BQxmzUUuv+Fw74aGABVONb/GJsPbJyvE71sqJXkWEAUlKFJ3cfoCb0tmI4zV9UoFToe7Fz
	gSNHLwlYtI2CIkl/9YG+IQ79sFvDJyWhfrJw7mPH+Bku2Fkugz85FJeNEveVIsNYAWnm1e
	vjPZ+wxTKP/Zp12A0rQAJh1tpafVGUs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=hHLiNgPR;
	spf=pass (imf19.hostedemail.com: domain of hare@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=hare@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4926bd21aa1so1673765e9.3
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 00:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782889492; x=1783494292; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Frs6Emcy9pNNZIaepK2NrL0xBcYA3u3r9RRnho4i+Lk=;
        b=hHLiNgPRds3RzFOFoCiCr4XIEo65Avyt+Vz9WtFREXcrXEYdXW/CgYnBTKj6cc/VlG
         GZRz63eIXPsROd6ahqyObsrcsc9JjgsRbzXUbF9PlLOLp5+mBOYtyrp079nC+mFBQPEm
         e8ncHGWOBhKawhL4g80bTS7buXA6MCLDgwGMSFh4bT2tfd/9sSDjJYWJb+77f00evams
         shAmUnNA6w3CzkFLmoP1cAQCJnqVc10auXUT6pMpDMHk6lgcQ8+vuQr2Op4Zn7H+SArF
         /rdtxye7PpPV1FflhjLfcRvHQk8KtDCpAfRGfWeBhgMzl0GGWAg/OEMSnWWPteB3HUq/
         ik4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782889492; x=1783494292;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Frs6Emcy9pNNZIaepK2NrL0xBcYA3u3r9RRnho4i+Lk=;
        b=Ekrq/0cwdensbgaBTTobaK9GJvPmyIF82VPG44sXkgPR/S6kNN38R+vuSpfE5hb465
         xVdvrlOT+I+Tk1UaXABsGyqnfq2qjxlWou+bjqI0qiIkerzF63+rP9Kp6rJAhhOXe7SG
         hC9ZS2iUEH7dzOlv99g7HsaSVt8HRB5A/Q2kPsSeO0Yc6Pby4LOC2EKDeaOpb7hsQh3F
         8cDxOyeJvs3Vomb9i8L7GdCIkEv+eE/5HuzzblHfaGCgupmmsJFL/s3HkGeJK/cFz8Pt
         5pZIOxx/Giqmx/Siy5p8ZOacDyctyGcgQGeyyNS6AHdT0ImSMrXQEaAsLH1kfZHhOm6b
         IsbA==
X-Forwarded-Encrypted: i=1; AFNElJ9ciJiJ4xAbbxonlhCLuZ3W4Ik5xLGjkkdyJiHTFwBLRz+RYSMVxu07qnDuSVTmYCTVioPmJq3H2Q==@kvack.org
X-Gm-Message-State: AOJu0YzBhOvnbxdbA+5vUft1Xof043I8ibYwOIQ4SjHe1vRgxSCNLts0
	zORd5O+O+96sJVugcXroSjBLLX9eWsSrt/ujy9hq4QGBh4amucCKEsgh3LgwQLomzCw=
X-Gm-Gg: AfdE7cmojTFNXfqSSlUkcbC2CUrlU12x3Hyj0eADtN7wkixt2pG/+JXH4WBzAblKpQQ
	11hOLAWb190L+xyAZPbHx9la4KcTKWq4lbk2jPecODN0la9p7PnVQWlqVf8pD+LCyF/NOAIjbBW
	qPy5b0OSz5XcFeTYx1Sw+lGgP5N8IJnPcuhTUWLcF3iLYVGb5epk67BYz988qdsjFfLdYCMoBcY
	bGbWWP4xDtDUSAjBFKnJjqo0dtR0QSNE3Dv6wCw7AqNN3g7QFgABZgiD8x1H26UyO3dQehszXe7
	HALSoYsaMEaA/GhlioKEpzeC3h3g//zmXJKB+TWE5D5tEyj1C6tE5VX/5VPvT2SDCXYMAor6Iur
	LxNgkdnU5oHyxuMTj1Yrz9lr4YHgKjN7JXDD9dmvlxgMxk6ngNXu09jPBJbnTumGq5WKIs/Tq6B
	nPC412kB4+g8AAfoO4LrBinvMT30A59jPnZS+z+5Mo7SPCpls=
X-Received: by 2002:a05:600c:3e14:b0:492:437a:a653 with SMTP id 5b1f17b1804b1-493c2b9022dmr4676775e9.26.1782889445790;
        Wed, 01 Jul 2026 00:04:05 -0700 (PDT)
Received: from ?IPV6:2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1? ([2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493be81df2asm94738895e9.12.2026.07.01.00.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 00:04:05 -0700 (PDT)
Message-ID: <9bc4021f-0648-4cea-9f27-8ee2bd9e7088@suse.com>
Date: Wed, 1 Jul 2026 09:04:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] scsi: sym53c8xx_2: replace __get_free_pages() with
 kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-4-494fb37ebe7b@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260630-b4-scsi-v1-4-494fb37ebe7b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sc9bmy4hyn7h7gho6esmfgkkhswjoqyr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 68C531A0008
X-HE-Tag: 1782889493-877884
X-HE-Meta: U2FsdGVkX1/mlRkyCn9io56NdR0OkXlVgIwzmDsf0vG4gYEt0Iv6AYQCCZGQVL9I4OQ8bufe0zsrATcKPWKdnPs/nddIBDJg2lKmE9DlMEObrgd0J1r8RwiW+ipjvHgViws7e9wCwiRd5a4hEnKY20NjTvLws3AKrAJPyn0rjVxkqKwGBs/7B9hMZgmoBAmk3EAJkrcFs0rgEkiEURrXP2uotJPTjsa/dkQss6jCWe3gbFmILeUBTGpqo0XTvXSkcPd42EqBq57e2mqge1tRE9X1GaAkTz9ExyLvBT0BXs4NLxxcl8ATX7uCl84B2ky7zHkF3BZJg8NaqdeDzN58alVMCh6ZSWhx5qTAuiMMMKaFMGTv/8r2Xc932tMms7NF24t5L+n1lgMus/s/72sfOVYW99JIfPE2WrXLDEcoPRKN2YCnHnoPn6PYHcPnHe0Vf61Di3jOH3vCEBu3FrlL3dAvU/GoUOSDO3D2Fmka+5anpjmDO+IjDoAldQ24DJ0WFS4so/usyc40kpCSRt3etWFbZiBHARLyR/j/HzVBaDbAo9k+wVH2F1uav/TAVoDM2gg0e1S1Mkmk3PV2LmNXiy1Mf3yUq+hr5Io1IFzPiiKzffSeHxFQBa74D6ej66HBYg739Tm73HgnuzjS2EgJQOzcFY1atU7aTlxVJXgP8sEjqdOI1d9ylwW0W4k81EfCIKVQBtTUJ76SPjvWXXp8BaTr6KrmvD5kd2XTH4EAOqeGoJXZ2rc8tnE5ADii2DSaHvB3JbQVE8PfQXoyYFySq3wKp+gI/KpcTbd/qIT2xUQLH9dh0JqY/ueGZfBtxtagvxjJWuT5Bg9vkz1mi6u19smaNMF5QpiU7LuppQXAt91u+Xj7ebksj2dleSmF3L5k2O/D9UZ06T1Gj/kKLO+6wcuxkxvnVqpR+Y57gnN+8tEjgjEO9pF2o0KqL8aNbbiempLIQ0HGbj9zZ/y7KGJ
 k8wY3nd7
 drCN1sPRWbI3wYpY6YnIeBZkNtp+DtVdoZscrxZK/Dv6waW+RUYr5zKxZ72ShRfWqxmXZQQZJBboLxN+Tj1OjM4Sf/PmrqXprrlHC354SyrVRzrdKvwrxIAm+3t9nIYRqDHFzxSRTTv1ApIbkVMNm2jC6BnSvxb/2QBiY3xZANtoY8I0UxzReNoiMs4MOG/dE1Y/TQjpVDa2Bsws0BUWPTThH8bcC0tzYWZVIoceNtRJsPgQ11RVosRamXhMTJXDyJWSk+Cdubyi9rmkCNHD/OKUnHJrzZnanZ2JIlidhAJ11jl1U/0grhT061N9nV3UbQzgVCLXzw3HLsnsd0wk3w7b4vYqT9TZOW/Cfr0YM0ThQezy1sUaIspLWPdmRxpu6qR6ZMosG+bTFFMdu4VEYsuoIPbzoPwqAh27eHVHNcEfZxyJFaWfgOvfz4lu9AsHFY1UR+9Sz3pzUrRy7A0sz12d2anJL9lCxJ8o/Pq0mTE8rc2EoA30xRwlm3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
> sym53c8xx_2 driver has an internal memory allocator for small
> allocations of the driver structures. The backing memory for that
> allocator is allocated with __get_free_pages().
> 
> This memory can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> Replace use of __get_free_pages() with kmalloc() and free_pages() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   drivers/scsi/sym53c8xx_2/sym_hipd.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
> index 9231a2899064..aa365e8ba66f 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
> +++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
> @@ -1110,9 +1110,9 @@ sym_build_sge(struct sym_hcb *np, struct sym_tblmove *data, u64 badd, int len)
>    */
>   
>   #define sym_get_mem_cluster()	\
> -	(void *) __get_free_pages(GFP_ATOMIC, SYM_MEM_PAGE_ORDER)
> +	kmalloc(PAGE_SIZE << SYM_MEM_PAGE_ORDER, GFP_ATOMIC)
>   #define sym_free_mem_cluster(p)	\
> -	free_pages((unsigned long)p, SYM_MEM_PAGE_ORDER)
> +	kfree(p)
>   
>   /*
>    *  Link between free memory chunks of a given size.
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

