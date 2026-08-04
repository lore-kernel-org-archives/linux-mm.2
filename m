Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18EACC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9F316B00FE; Tue,  4 Aug 2026 12:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4EFA6B00FF; Tue,  4 Aug 2026 12:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65476B0101; Tue,  4 Aug 2026 12:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E9186B00FE
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:13:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25365801C3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:13:52 +0000 (UTC)
X-FDA: 85064083104.15.2438AC3
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4C93F14000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:13:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Lp5Gj9Tj;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785860030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Il3F1PhWfAFb5O45rjaP3HRomi1hREacW1lP6pn7nyE=;
	b=Ktk8wTnrfFHQiEGs/E7io1viAdFXbW/ywelB8ZWLqNjbHqUqbbx1AgfaAKTFZac+6DtpF1
	8DXBRvCwq++vdn+oLz3Z8udvBBX0Hz0OknlhVkvGuYTfIDkWRALHzYiCKisOPyUiIbozIP
	Nz3aIBW93GshrF+mVg7aLo2YTBPBNJQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Lp5Gj9Tj;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785860030;
	b=eLiuNoR01EQLx4hcAVCcrxQWkZC4DvxrL9VSoeUUYDfCLwTuevgmT1G205flv+8OBHhVzV
	VQNNPGQ7N+/Nmgz+moW1O+7//LB+HPSy9NG0xie/iD9mAtoFUOeujqFg6D/+GcjjMtPoQC
	v4ObXt2bzTDWnA8F82v0ro6YivxbjKU=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51bfe810293so23892241cf.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 09:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785860029; x=1786464829; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Il3F1PhWfAFb5O45rjaP3HRomi1hREacW1lP6pn7nyE=;
        b=Lp5Gj9TjL4qIS4lEckysr3dLWAAPYQhOd4wCg+vocwLciUSKdVEosP8kZ/6dmidbwU
         2SuOKu9z/85pMOWFaw8p7qU2Ehgmz63/X1gkZazvaaJ82oo2a41sf/RaupiL9wowCf7h
         4qDudsA3c+tXU5rPFgj8RiEiXrJJ2j6G8eCJhpGlPCG6Bow+1aIlsHX7sqdKRjtIxTKN
         BNZEZllA0opyInY2zjcoywr6xBE2AESkRn8ySntsvMNeIC0YT1V/KFK/eOw7yg4pKy/D
         kvFAkpOtme1nLMsEDgd0gkfsItIJMDNpDAAzUz9Fesr67wj031X9xjAWeJeYqXPXEoHv
         aE/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785860029; x=1786464829;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Il3F1PhWfAFb5O45rjaP3HRomi1hREacW1lP6pn7nyE=;
        b=KqtU8g7+3emKjMBRDsfnNrigk2W7pGrA2rNScWtViuHVgsgZVxEQWL+M2rQiuggmu5
         vzu/i4390+tHCBElNVrEK7Dn6iT+WXuYmotB0vMuG5mnEeEdYNsbS0i4DhhvQU3bcg7Q
         MZAZSYokIN/w58E9Mbuk2nrnsPUg/UFmAreRjsPZ2Il5axSSGgr/1/XJtc3nH19ES+Sk
         KfpI4r2dpUuEzCBPhkJsbIjo7huncqG6eiy2gqlG2+Qm1bxDw3FM1g3d+v7yBb2u1CSA
         df4UWMeu6P1zrm+EVcSqJ7n+HBebiHtbKJnbO4ZYWpIfQZKnpWYiuS5FAhELRMfcUB5m
         RquQ==
X-Forwarded-Encrypted: i=1; AHgh+RrG8JKB2s+8Sytans+ZRBtGKvZ8m6MKjm7MY9jBPeGuhtELNB3VEsBrUsaDfbuWBpedRzuTJ4jP5w==@kvack.org
X-Gm-Message-State: AOJu0YzOAPlUkKIG1pBE4RFWL0FeOzuRvKo4/CMrlKHRaxi9NiL7fOsZ
	jXnUrSOlLGO/gLMVLWaXgh0oxztdo6tGl44B7AWMs88SjbL7lFiz6Z/+9pLXClhV2Io=
X-Gm-Gg: AR+sD13JywNcvdzRXpIiLWqrPhwmGDt4G7Y3N9e4H0jlrul+jhzuhuAzyXFxTcFiC5I
	i8ilepdw2sAcrIejUIDkCDp8cXRmbj3z3whD6Vj23rhtJccFbbr4GMDyr+wezYGFLIPAGpsXMeJ
	I979LuOcT5V1+5k8yOG0ScADlvNH5FxgcSFK0k+jb3sSbVNLy/+mlZVweWl+ioy4JoZD/G9XmMq
	s9GOda2eSB4EVj3LBcGTa4L3VtqHfEQ/UDvyvBe8HJZORWw0o7n8RFoCwmvoGlOQKmky585nmRC
	AKi2SIi2ReSaI9KTqOo7dWJR0FUijIm2LFy+qb6xiCwLcFVcUIQI8kIodIlisTEbj3v1ASpqbC3
	xD9M8G0QzMOvV1++yP82eUwzgEz/UrxVS8Xy+Id50DahbWH6WiE/3fxEZwNdzDRtKpoAF131hHa
	6H/gVKEV34N3437XOwEodvelWwAIo3xkEuqYzWmFp7Ck2r+f0T7xyhq3tDhQS+PO6Ze+S877d7b
	O7Q8Ac9j/KPp05bYO+whWTC00AwNGNAkmEy2BtInl+v
X-Received: by 2002:a05:622a:480a:b0:528:3d14:c381 with SMTP id d75a77b69052e-52ce5f8f76bmr2339841cf.3.1785860029308;
        Tue, 04 Aug 2026 09:13:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52ce5172536sm2529861cf.6.2026.08.04.09.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 09:13:48 -0700 (PDT)
Date: Tue, 4 Aug 2026 12:13:47 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 06/15] kpageflags: Use is_page_hwpoison() to set
 KPF_HWPOISON
Message-ID: <anIPlxgqKXEKKnLO@gourry-fedora-PF4VCD3F>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731200802.574821-7-willy@infradead.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4C93F14000B
X-Stat-Signature: h6qfmj7bmr4q59etbwccbsexz9y8gkxe
X-Rspam-User: 
X-HE-Tag: 1785860030-641851
X-HE-Meta: U2FsdGVkX1+EDq+8XI8e8LVHqH6RQI/UNNZzZmKH5VYKxjzN0fVJWI6/LdtWI+ZxDcctr5NwpNPZEHOtMTrG+VWZlpkjuJZMIBaOujfibhMusBfp4Od9TWog6C6bNhP8L8mhtNuXaNZIyBvcmVT0x1xmvs2kDaQuM3TFyNJV70TMlLqDK1jTR7IntH9bw4VNt8CEv1cWlBzoQUVMbwFf60OAS5sBBsKw02FdI5syiOl494D5pZorTZqu6n4kCVkmFxiqQqdf1tbytd57yra2C9hzaTM1g0W9JdjEHNCjA9mfB/zQvqc9krXaWi282nqPAtxOxHJANUijqNkKDgLiKFsx8Lt3wrJgPVducKiLe4tN4I2Z3rYZ/8dmEex59ZE6c77Nw4xwJxpQIb/afYIiGogrl07OpElz1VU1sHWbonxQnzfKChGyYG9++3bjcWzBUxCaHfAXAYwpLG+O1v+RuFDLlzRHJlj8RpKYdp8GCGPESDU290eX/HlyrpeQLCutJ5KxhOKbDRmOIzh6i71KQolbZdKi5a+CkJbuTov29KomLxWZ97OvIW6vtCn0UjFdDLifC2yH2EwZxPb5w3lb914CjR1uT0C5+ruqJKqgYGijE7DrV1qoXOlrJVRck7Iy+ShS3X+t2MTxrZkJDhhlKx5B6XxAz91f73JfIrzA5d1QM+yVtFJK4NDpDktxNyzSuwTTEI3Byr+s0ZPkBBAV3Zamt+GnHlGxvEvRMBQSQM7wyhhp7d0Il9ffIlKiGoN0PZZNsp1MJp1YZmZbIv2ZE5NNnH7fc4cgM4IvkNTJ7MZOMcJxR4v6+uBUcaIHIfhpVRuxFw3j3w2IwcH/HKeTf2jmhlCywJGKPZYG244KbWWBURAO+NlALMbtr+qLSlQGgpvMRud24sB3/3/lzeZ2nsoScJbxUMmLlN30j5f9aN2JRnUMvjcGqIemV4I/gmqJCXU2u2Sq6j3n96y5p65
 FKBps55r
 GeId3JNbD+Jq5mxzuwaqHwiP8Gko5zMMX0lyIbWrGarS4przFW9D0NeDlZfM618CpyF3eeW1m0Z3iVEWVzqms8mDBVI9vpOKZBqhNW7zzwQPYBnq/kkUvsrmR8yRdXQOCb5sZZePUVQ+MeF2TCIvdZwv4beXdtHQOaGljVucjhTKLBibIDflcyhYB1cil2owR0SSsFORTArrMQJP+jqsSR4tdjuV4hvBcXDduNl36a0HqLOgYZgzTBDRT5nS+sz3Vo3kodhHFFGdJ5ZE/F4sdrdim7hEz+TA+6ZBkltL9rFspbH/gACyw7+RyRnUbbIfXGfPGCAe7Gwt0l2fLhl58ZQON2eN0qmOEasBQYtMhaGidfNYMcCF5cKfEw64iEEQ8hic9hydmEP3Y5Y+2aeIlZh2DvT4t2fKp+Ot4XBLWkELQ6lHo9VFYAPJUqAEatKkZzdUDFh760LLdDlHnlvdjj/PPw+R5ozpKtQtCLgjAWx4jG0XsUUgBiNdPL9wyVz6rtLWmEuvOWrbPJGQvi0xoFMpk3CByvqdfWdtbe23lCsVz7Eo+IPt3VSjK30yv+LFN/Wp7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 09:07:51PM +0100, Matthew Wilcox (Oracle) wrote:
> Instead of knowing how hugetlb handles hwpoison, just ask
> is_page_hwpoison().  This gives us the flexibility to change how hwpoison
> is handled without updating this function in the future.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Nothing to add, love -ifdef's :]

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

> ---
>  fs/proc/page.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 7d9387143435..28c9a7b724f3 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -233,12 +233,8 @@ u64 stable_page_flags(const struct page *page)
>  	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
>  	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
>  
> -#ifdef CONFIG_MEMORY_FAILURE
> -	if (u & (1 << KPF_HUGE))
> -		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
> -	else
> -		u |= kpf_copy_bit(ps.page_snapshot.flags.f, KPF_HWPOISON, PG_hwpoison);
> -#endif
> +	if (is_page_hwpoison(page))
> +		u |= KPF_HWPOISON;
>  
>  	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
>  	u |= kpf_copy_bit(k, KPF_OWNER_2,	PG_owner_2);
> -- 
> 2.47.3
> 
> 

