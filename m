Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE61606A684
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z8UhRyzJ
Received: by kanga.kvack.org (Postfix)
	id 32A2D6B05B5; Sun, 22 Nov 2026 10:39:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DAF06B05B6; Sun, 22 Nov 2026 10:39:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC7E6B05B7; Sun, 22 Nov 2026 10:39:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F04066B05B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:39:42 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8327B406DD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:39:42 +0000 (UTC)
X-FDA: 85463165004.10.CC56A2D
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 91210C0004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:39:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Z8UhRyzJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795361980;
	b=myw3PCAOkzKuDznf4rTHVm5XtZYvQ3UGINjXaVHmilEGOWKm6vBThGsoIHXr0rDhc0JDGR
	ForqHtDvBddFZ4Gxt4sM6qe/IWyxfjN1JCjvNyVgUz9mY8VPiI8NGfUX+m8SRoSlbXH6tF
	jng1yfk0qi7lG909VZ9lWBe7Wuzy4dc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795361980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CF1vPMfVpzbutUW1ILt/0v1q/2bQg+t3fMWuVpjH1nY=;
	b=NLdB8rsRDn4F/y7ufFo3D6eP9zUaQi6sxJ7fRjl3VFc9Cr3aMDd6tZaLdDp7jeWf9MLDw7
	eO1eonogJUIGbsfWcBLGaAaMff983OnZgdsJYuFX5Acnlb31X6jzFtfgPAIZ13Ouo4WOq+
	AQkEVzpN9aeizHSPiG34pX0RAZQ7Cjs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Z8UhRyzJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b88b74e54eso2871128a12.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795361979; x=1795966779; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CF1vPMfVpzbutUW1ILt/0v1q/2bQg+t3fMWuVpjH1nY=;
        b=Z8UhRyzJhPxU6YI6ZbtHD7j1GUYkTzsW0OXdCjE//5HCSoWdm2DoP8eINE1yja9oXS
         EGfRiud7PUgl9Tw8bN4N9JdJK6//UbJF5zi3i03/fipXl3RC/ICvpLPTeh0j5jCJvLR6
         jbeGaBESYX1OEOdYM7GUqfRQIl81KvSO8wpEsfqDc+lV01y2kCnMACIF69XgKyy+2X1X
         0/AZbXHqIDWgX4JywbsCcRQi2rahQM+Tss1inzy82ygSF3vdtuHXCnNdhm+5n65V7YZm
         88T2rnAyjjPpj1aO3CfYiG1zh5UuPn9T8zHW+TSxxKuWx1f47Z4OaQP7AoptIxsHKOeU
         PhlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795361979; x=1795966779;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CF1vPMfVpzbutUW1ILt/0v1q/2bQg+t3fMWuVpjH1nY=;
        b=fK3phw0ImBSdr57CfDKwLRsU5a9sJDvNzH+2HQe9kvLbV7f11vZpnQhtEqXUE6hsrG
         B5AN+f9Nf8O2khA0VgYMzAqrI//ReOaEGOiYm3QAscMN9d9nh7uwyqeRjXt0KX96kpiE
         6xlBzzxlEUhhV5OeJm+wZS31EIx/888tXFCCofoTh6l63rGwebh1/+A4kKkg+w0oIPCf
         c0mmAUz2YpecQrg7oFYLk2XlNOPSNpX8v9ebiO+xqj0U3jxZas1llv30ix9R9DTqa6De
         5IKkvNS3h46bdW/Bd7rH2AecOZTEYBTYl6it7lXtbo3CrcfYGT9RlCh+mJO15O6fVuzU
         GkAQ==
X-Forwarded-Encrypted: i=1; AL+hErGSNRU8HixnMMH2BG5G+/0MA2YYHGFP+1Fyd8yHTkuGYtz5vy+zJhUTVNMn9aXS7cnmQrDkZXxoIQ==@kvack.org
X-Gm-Message-State: APuU4Z/aAEuRzuG4dDAJS3Qqe/OjuIi7HSXOPS9kKQhL+7csfmOVPqPR
	MuVroRTPG2rG/zUG+yGumsRT0Gn+EYogG/nnjWXAM1QicjpMg/SqoOMJ
X-Gm-Gg: AZFdTZcByVod9Ddm5tyN5Srk+4RWkky2arGjrOqBYoZ0+6wbPh9KEDaVO+plsnUESJd
	CcDN3CxGsNlVTgp6TOF63QsjrukoRomnVOL4QVhtrbg4nbNJLrR02mEqnsnblLQHf/H203d5Q/A
	GwBCJrMN4+7C1HZMUHF1bOgt4WmZJBWFC+BYAS/xTabByrDkbAwrazfeZBgBJCastPf8H0dWYPe
	2dZk0ZdQauko/oT0BDJ9oiKo/e0CccPpfeezvhM0t1oHVDdrnS+E9/awTKQpIApVa8kb7+pSYz1
	tHEJRTD9cg7ggOUya6nv8+nPd+VOUik9LXsVEXAghW2XYjqtPHgTY6wBHGizCqI4swaiLKjMvSn
	s9GYlZykat7YSL6c8SfodvLos16p/6EioTOmV3m76q63OO7P1XvjU1riAOMeMGjyNqFUCAEvnkq
	UCmDinKNC3LwjZ3tsZw9PjnwypnwyDZBuHfaBxcE+71r6En2NvJRcfaaDPrCsm0nSjLjOBuegVw
	cwDQQEVU6J3RFWBDzFugWb3kUV26csDEvEt0hY1Edmn1BGs23MidjI9Ae+PAw0xrSg3gQ==
X-Received: by 2002:a05:6402:1f07:b0:6b4:87b8:1348 with SMTP id 4fb4d7f45d1cf-6ba37e83f34mr6102402a12.27.1795361979136;
        Sun, 22 Nov 2026 07:39:39 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ba370e8ad0sm4097712a12.18.2026.11.22.07.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 07:39:38 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Sun, 22 Nov 2026 16:39:36 +0100
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH v2 1/2] mm/vmalloc: drop VM_DMA_COHERENT from
 remap_vmalloc_range_partial
Message-ID: <awMMuDowZKcMYc-8@milan>
References: <20261029-vmalloc_remap-v2-0-c4705cbf26c2@linux.dev>
 <20261029-vmalloc_remap-v2-1-c4705cbf26c2@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261029-vmalloc_remap-v2-1-c4705cbf26c2@linux.dev>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 91210C0004
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dczorezsixm6q98343pm6max4p7g45a5
X-Rspam-User:
X-HE-Tag: 1795361980-559665
X-HE-Meta: U2FsdGVkX18Yhr77xKsak4rnGk3qtS+n94HUibGAi6AgX5EQ8/jHC8WBxgVt+pkfVk1C8FD1Fr8I4kiexWpCBujVWlAB8XgOEzrXOMXV+iuGto6UlEGhyWZ/Iq6gEcd9D/OBlofzzMQMS36J5j+JXF1dYGNuAvOUi4a/V6yEHZ7uA8CRYXX1tWkiDZ7i4gugorGmMLulKU2ViI1pQ5bmaZ2iz1q+7H8vLJ/FB8EjFSW9+Y6YasRzxzoXj+n1lAHf/SsMQZ7I+OCiQlM83wSlO7YZrkzc7X+eu12xXQQdwwt1n+OBPFaSFqDpmAbJ70ie6ynrSCoa8vL7TpjpsDM4Ok+5MAObI8450eeDlahOsscrrv7NwmLIKywFoOerk7xvnAk4r2sBCkQmmftP6OIVa1/f4pq/rNXSSa29wI5texptSdBdBhD03LKVZJNn0OJ6rxXiFxciQLDpWFkQvv+sIRStIQEe/3rH1BJDcp/YSAi2e6C+UiYJvMhLm6K42WUi1HoqueIpCdPgVPY9H3fM4U0X0RbD6OtgrIYSKQTEbo0B2v0o/zkBvOAu992pMN5fClAHlS1jZzLs/HW+iBtFTY+qXqQkju5JPPkGxdvV9XYF3YocRtSTfzddI8nnn+DzqPIMLRmE30LN5i7bJWKdjwAyYUTWr6hszQBODg6ptFGsf/FwOplRCFFWyeZbj6myebMmgQ2SBCWq5sVBUeTzXit5IdzWgFUNgOUjgrMS6MZ872zMNRWDScqJ4MTIVghA2AM9q7YKd8hRUuVjNDnkuu9rQP/Y4twH9vjNbb9eHH+QzOvhQGERw3wIT52r2TvP80qtb/E0++S19xBOnZcczeYOW/k6N5HVF1GVuUEAI/YEkGWh3AeLzy+tN80ozDogYBo9+vy4Nem5mPhY8ohiS2xzH3NWQog7nkDwNvD6WeJUxktWW42Wu1rBr7NGAUCPB+RKQx4AG6peRuF0vwb
 iMfuFELv
 dK4JTSZ7ISC5rZAI1EY9F2bqnblwDZk3G5XwflsIA5o6Goo8DaSLT7gRHVo4qtIcsoKpzCaJ4MakuM/XRxXeyUe9SW9hOWr0t7OoJcT8uYwPFmmLTNdq55ZT5XR3j76vPFdVsrjYtlJ6AfJQ13Bus0rxRR1rw6gEgGKGChWxRmIHcoyEGXSWby/ztFtRxJf5ZWx85DOw5EqYr1GmskYqvk1Rb1NMh0oI3EPWDL1R1X7r9sXVhisxZq5AMAWFeL/PC88UDhAKrHmQv852ybA5X+D3xGJKTVyFkAk81ULDoXsfJVUpeqUSHoraVRH4ij8Ld4trCR6+riI9eLeU9Za+ORY/sNttaeb11l2I8LMTALyZ3BoIXUJIgqN5s7V7a3i+r77ORhrxk/L52FFB/rBW4+oo6troQh+gDO3c+lnrSm9g+3MHp4AGP4icZjLospU9jDrZU6ieDtLlCComt8JQfbmdSVnGs50cxrGxX8lDceGnd3Z+5XxJ8hI5PG054nvMxv5Zbg3j55wo6EwlK4TWf9suWpQAPSnXVQJuFR6O7GGUPePHZscUgRHH79zvfmXDkXPKzl/bXxmeZ0KY+wOSAJo/3+OrLIP0DGFLW5Qkw+bPRUFddHpAwR9FUka4At/cbwaA18HVGcu9KWQLZpncYAafjDuZlUnarnlWv6z/89nWFM6lyROeTGUAdjz5fKiPJCccskLQj2iP/dAYYHE4m4KXxG5y9N0zPn565HksEXzI20NgUTZ+7jSg4wwLCIYnDEMpO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 05:19:07PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> No caller maps a VM_DMA_COHERENT area through this path: such areas
> come from dma_alloc_coherent() internals and are freed via vunmap(),
> never through remap_vmalloc_range[_partial](); all 13 callers pass
> vmalloc_user()/vmalloc()-backed addresses.
> 
> The flag was added in commit fe9041c245196 ("vmalloc: lift the arm
> flag for coherent mappings to common code") as a mechanical
> translation of ARM's VM_ARM_DMA_CONSISTENT.
> 
> Drop it so DMA-coherent areas can never enter the path.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index db669103dc66..a888eca016a8 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4894,7 +4894,7 @@ int remap_vmalloc_range_partial(struct vm_area_struct *vma, unsigned long uaddr,
>  	if (!area)
>  		return -EINVAL;
>  
> -	if (!(area->flags & (VM_USERMAP | VM_DMA_COHERENT)))
> +	if (!(area->flags & VM_USERMAP))
>  		return -EINVAL;
>  
>  	if (check_add_overflow(size, off, &end_index) ||
> 
> -- 
> 2.43.0
>
I think we should really clarify why а remap_vmalloc_range_partial() should
no longer accept VM_DMA_COHERENT mappings, because this change explicitly
disallows a previously supported behavior.

Could you please clarify why we should disallow this now?

Thank you!

--
Uladzislau Rezki

