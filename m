Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B069BC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2CD6B008A; Fri,  4 Sep 2026 07:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A566B008C; Fri,  4 Sep 2026 07:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90806B0092; Fri,  4 Sep 2026 07:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BFC66B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:04:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B17F1C2BE8
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:04:35 +0000 (UTC)
X-FDA: 85175796510.04.EC01DAC
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 32301180008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:04:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="dROb/DG6";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788519873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ba0WVI8S/qZuXrDRnwRxY/dvGyBoVl56jflNJMJpGxI=;
	b=Y06Q8UI95ghjmGcUHg6lkAH/V4eWjW2A2VNmDPyt8CjDroAQnbbmV95TWSxLYKJ3dRXOWQ
	3uxzm9rWfyzNFwUzRcj9Um/rgjWZhYipbEVWH0QBLOlhkvltCLaeBisc0gOUqfhGofF+F9
	+QWttgrhTjXf8vkyPQLNM2IPtS5Z6Ok=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788519873;
	b=6AOR1h99GwAfx6E8o2tqOGMqHh/b9bTivz+v8h7fvin+RLzB8OHHtN8uT2IgazZyaNZTV6
	t/az9u9VUkq5gRx7C0pLAHyzRvCl7HAHpARSV/KJDp3SvYTTWDPCsoBNeyYjpuLFAvldON
	xnZ2JWgIlw58y0dcl2Sj15kLlVTCUt0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="dROb/DG6";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so9426085e9.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 04:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788519872; x=1789124672; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ba0WVI8S/qZuXrDRnwRxY/dvGyBoVl56jflNJMJpGxI=;
        b=dROb/DG625Zs1LbBRxZRdwpfi1sWVANJHGYXE5lcEbYZ05koMwdte01C/PIKSmnch+
         PbtMcXCzSKKhy2sf2NFGkz1GV2u4yRqpuIvHwnqMa1lkPOYnwXGvkEALhNKvQbEibaUN
         QnhiazfjoqvWYHYyP28JsAjgmN13QFNdafcEVyFdEkyyNmZrYQC045gQu9AsYn2gkwTR
         /c4k+Pf9giaqmndqCsAqnzkqKU9v+eBW1YiJfI/hakgMP0cyjjMEARyAXi0Bwmv20Moa
         h0CTwGY0V0LENZIGmMjgaaAhcTWnSoQB0S9T4ix0fUli52E1WN2EWmbdoDSosUPmYyoI
         r8bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519872; x=1789124672;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ba0WVI8S/qZuXrDRnwRxY/dvGyBoVl56jflNJMJpGxI=;
        b=SPHCnjpFUdRK2e9rRmcLOMPmOKY+nv1bRY870c7Un1hIBOdSeAiSs4mkXdyU2wqZez
         BbGrJ7Gz9W9XoNhFlfaAUlYSd6f5mLbgPjI6/fulgCX2U8t1/4dDjCsgqk6P/qfPsU8/
         qXI6u6bkOUY5M32Z9IxT31m5dTEnI8dHMrUDU3bAyOgi1S3Jyp6qJJ36ycMqg1iDJQZh
         Ekb1nbJr4deZkmgQz4Tlzoob35dY4pa9aG4b3otzrbtYderKY5yqEVLVcLQZHJm3luda
         4t7f0va6LDvHVKsksN4JibF66gOi94fOvUL9NEHLZ3wwlYx1hcZL8OiwfSEKTLLXIm4P
         cjCw==
X-Forwarded-Encrypted: i=1; AKwUvBxTNpphHCRhDZVVf44o5mS4Q7WjzQROMXBCsIEtMa6lOUVhd4GuYfVmByflTFRrRvhxHrfA7U0lYA==@kvack.org
X-Gm-Message-State: AFuF++kP3z7r89SgUcWaujMkHgJiLNb1PEGvyQbwddXdla4wxx+Oya9X
	Elc8xdEdNEP2N8aVhHbnz5dEqk7RxbnpaQJSdr0JJ3HvMcp1zsNf37kbqsBXFr81KuM=
X-Gm-Gg: AYBFou12Vn0POg8vCE6sBzxuzC2U2gp5DJTjZFjWDiW7q98wsqC8LqgiyzRziSbs50l
	XOZXE9rwZP3YnrT4hqsi6Of9OrUijUpgkn4DffyzxfFNeBPinf6EbskuyQGEl5bTcXjMC9Cg/En
	vrNMZdC2jErlsr+N/duFXkjqlUpiFrLxGOSZAL4eu9prPwCUBK2+UT8EfzhBLl5Vd2//6+8cJYh
	P/FQvNN/A5+yIlUe7Swuw5o1tVwr1srTCkiBC6Pnb6gmvUNWPsdFaPvZh8ta2v/Owtjs6DOqL7X
	/d5Le2LaJ7YD3/gqKevmHsQU26eg5NIdu+lC5tLiHfsM8CHgH/0yaD91TH16Ihzbe5j0l/3tM7T
	TkGLZ621XgJgGdDn28tugx41YA7217xt7ebS46OwamIRIfkmFjITwOHuiePYXG7EUaV3OjQ0aq0
	KcC/KNkHqY42DtM1WNm9fa2ZsH+OLkYSVg9pLxyNF5j2SrKzgWtYVxulg4RVU9YFAK7Thzg7dE4
	w==
X-Received: by 2002:a05:600c:8b05:b0:499:9240:9a1c with SMTP id 5b1f17b1804b1-49cf82787camr51743595e9.15.1788519871896;
        Fri, 04 Sep 2026 04:04:31 -0700 (PDT)
Received: from localhost (109-81-91-122.rct.o2.cz. [109.81.91.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee80eda4sm142910265e9.15.2026.09.04.04.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:04:31 -0700 (PDT)
Date: Fri, 4 Sep 2026 13:04:29 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Ye Liu <liuye@kylinos.cn>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] mm/ksm: convert process iterator to
 for_each_process_rcu
Message-ID: <apqlvearwGfs4A3_@tiehlicka>
References: <20260904083001.553587-1-ye.liu@linux.dev>
 <20260904083001.553587-4-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904083001.553587-4-ye.liu@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 32301180008
X-Stat-Signature: er597bsqqy3zuartqkf7x7mhgu66i8rc
X-Rspam-User: 
X-HE-Tag: 1788519873-181674
X-HE-Meta: U2FsdGVkX1/ID0IqEycala0AYrjuPvsv47QpCmyvdfVWQUmuQGhLIeI0xianDktbIjpn3roWQ+zvirCKH1IZ+4fVxC9km7tceLizk0jBeDjPSgCMp0GRBMUXl0Gdc/aiGaPYvc+E/ZcLeckXzxrHxKkfqG06EJPMkziI9Q/mn2OgYVUwt9fKXbmbOgshH6b3n7f8whX7mymf0C6fVky1yYG5yRt+ebvwpUxXOj2BucmYQVozYWJUJlvjcwICnFZAPp9jjx/brdie62LRHfNDGIF5KkEusOdN7ozJ9SicC/2TTCSrZSsuStz4ILWFNDOMFLSciN41ZFloZ0D2stKt2QA7wiQ6GFvvbGWe60iBtNXRMh4fZ6XaMFnViTpjgYUVBmahABMu0Zzfm8EIRkBytV1vtMxK0rkWhRgjwL6iZpFYLdVTJIAJr90LtTdu+PS/M8Lb30CCUmWh5cbIFn/v5V+U99KsbOg7+Ey7iaixMsaY2qABJFFGZwGdmGEzZR9em/cP9l4E+Si0O3IW2P8uUhd7hFq6WM7rND3hJLg/26QnyqB/QSISBvIvsmN6Axd1fdOnY9hMQYgvI3RMJVkL0xLmgUXQ6YJQxSRAMrED00O95GdtvPbbCTC359sa7qKN7s1kWlitDGTV1egTkjfZNvgKpeRsZ1SUyNwgkDCHynbEt9Ve5ybL9iNOJEYirSLxQX3IxCbr1ThLMlarLxC2OA9A1WzQqNRkjfLvffdttnvCYEZ/fMeI99F/q13Sd43aNjHBpvySuD2rF+JaA48MRTVrDF9p9j+NFAjHUsJ3ZEwmXtIKvYSUPGqrXdMW2EVqgZU3nhzGm6Ku8WU8y8QqrSd/vyMvMpJwhKcHFyT3M65K7sJJOa/6huddOwl6/Y+CCWcfISOFyb9kNJUUUcoKMBOKYVhcYDEAPLAZnPoXZpG81r6pgwIKUwigPKUHLcDYmuyYxdJ+XzI2IOaeBcA
 qfPCa0OW
 kcYcVAVadpzBTjHroXtx8HL3UvZU4oNIsOnMwD3cCPhSgs3n9GLkMegnSpUSFjy4dMIqnkZFwNoZ4PD7j4oyUuVJw4dZZoNrDCQJrQqrVGgMOCcAp5C+Pb/SUza23T114Rav6XWjeMaAGMc/RPTfofN87robx8XcClgnJ90NFPOMlBXcYzGJ444Tq51C/d6NG6PXIvjL+vUiQZIs7oONoQStwHOphnCHFpRgF+sPt1/uStXDtWn/Fxa6ba/zrmBHzArqKKKO1a2ni0HVFtED77AmGWm+zhco+iqbElRfdYErYEMzPVaCsFe9hspzUJgyu1rqlvvhne9KHXv7LqIJ5W2TaQd5IVxH9FIdv3Yy6a7Kpb6ycYIZ0kPJcu2x0z5gDiBJF/gapOA25tbR4kTX4v+yVm/UC1aZ5iF+9grwXWJvbnhoyjuJpS0PwlLgPjHnc3PZS6sP1kUPbC8c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 04-09-26 16:29:55, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
> with for_each_process() loop in mm/ksm.c with for_each_process_rcu().
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/ksm.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 49d48d1e0998..fa5e4c47fb1b 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3280,8 +3280,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  		struct anon_vma *av = rmap_item->anon_vma;
>  
>  		anon_vma_lock_read(av);
> -		rcu_read_lock();
> -		for_each_process(tsk) {
> +		for_each_process_rcu(tsk) {
>  			struct anon_vma_chain *vmac;
>  			const unsigned long addr = rmap_item->address & PAGE_MASK;
>  			const unsigned long index = rmap_item->linear_page_index;
> @@ -3298,7 +3297,6 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  				}
>  			}
>  		}
> -		rcu_read_unlock();
>  		anon_vma_unlock_read(av);
>  	}
>  }
> -- 
> 2.25.1
> 

-- 
Michal Hocko
SUSE Labs

