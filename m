Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AC26C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D72E6B00AF; Mon, 27 Jul 2026 12:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588EC6B00B1; Mon, 27 Jul 2026 12:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0D56B00B2; Mon, 27 Jul 2026 12:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FEC86B00AF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:50:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9EF6140140
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:50:22 +0000 (UTC)
X-FDA: 85035144684.27.8C995BF
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 68610A0009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:50:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HLQ5AMk2;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785171020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TyxgjtQoCDEFZf0QPk0ARVlu8b9GSZjprhFXfcluj1o=;
	b=ZUgo2k3zZqbw4arv3ozQAabOf78bcz9pcmf2e8UVJw1Sixo4xK1IEPXUQmqU14YwCUQvh4
	uCIsMHqFJLVBOJCA542WAETdlyQXABQSGip8GCkjT34PobWGj8BNu5SAlBUMOjuaWuk3YL
	SDTRegCRuvNcaDWO1LXDhdKUc+gLL+s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HLQ5AMk2;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785171020;
	b=UglPtnfYuRUupkp2WlrQNGP+gxAhtLW52+wC9xLMi1Y+rVr2SWoyCad2+uRjiQqtCPrC+8
	nB1EWP3DNbYq6LeZw5iBwb08JsGPWBLuHzHVsNBjE07LGB1qcRM914+T49XSVddMIAxgJ9
	/JjIQdVsqbTfdP+AtqDI4b1dplnAhEU=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e54f8c051so161819385a.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785171019; x=1785775819; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TyxgjtQoCDEFZf0QPk0ARVlu8b9GSZjprhFXfcluj1o=;
        b=HLQ5AMk2XYkhiIaYKQuLnaY1lBSlvu5CP0RePTKB0MN0i0esn1Serv+F5IdtCpTrns
         SF/JpVkQVKd/eI/+HYbhF7H/SWDNk0MA0uGxj5qUA7OwVnEKL2N7xXemj4bjRt0BruLh
         QoOh72zv9yvOzTh+pvQqlxrqGbotMUdPZw7gvLjRnxg8iixnUfU8CpYpNiiyPyimh6X1
         9+NyICeW/GuyY3EL/u8SCUVrqeyNiuoCh4/jFasGh1KO546q7g6UOBFu5fbfIBf98D+O
         x7QMobW6yv6WOKmrigPJa2rvYuWOKWl05u3EyrWVUEhjqCrqrmbNvM8C9Z8aPC/Dnuae
         6rkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785171019; x=1785775819;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TyxgjtQoCDEFZf0QPk0ARVlu8b9GSZjprhFXfcluj1o=;
        b=GcVzygluiJ9vqsW6rP8svmXprVJVxKk1+OpscLgCxUgKMZhR9a/8KckWMRvg1m0Akl
         zt/IR/gcy3KU6uhl0yZfuNRv8pKmz5N/32FMhNbHcoaMl+reNac3b1602YS4h634iqFW
         nTtJOPvyBR/taCTPXkMYx0XZDlVqyFBPPXH+gXJPsDA1N9UEERC5vp5pjiQn4XX/LB3s
         K8jribIWKaG3ScukrbwHO/Dah6nkQvkfpiGDEmqr+FQFHcG2oGWOoUzeDFaRJ8VyMyH0
         sxzIyQsaXvoJJExxYT8U6fy4EjciFlOZhmW1JPjDC1NDBNZMC7DE7m6rvCxYoIRDTnFb
         3dSA==
X-Forwarded-Encrypted: i=1; AHgh+RqZtb+Ma2pfqKkjyQ72hcIQrg8C2tuJ/9vvrXt4KAaqZSr7p0ywHpUF6OrDGOF+S8Cb66Y0Un5xQQ==@kvack.org
X-Gm-Message-State: AOJu0YzAg18IpKtGxOS3ybezfj5DICw2d+iQBdE1mNwKgqv7nYPMoxQ+
	qgibdBHdOwvkLEUu9ZQErVnMGaR1jrq2F7IG8CHteZfFe1Gom+QdiuwKdNa1UWvCeac=
X-Gm-Gg: AR+sD12QkdF3HVFSG5r0bO832XmXlwYMiRXMTGapJgzSsLLeZo4xpIPGm0oEFyL+V35
	DMfQP8sIBxGYEIrahnHPcSPyNXGN5bMMh5RfNhvVYkKYxUAZrQ1ucjwbWRreec39LWhAW56snpL
	k9fke/YBxRm3+Sm96lAE387s6aFBfXwxxqvM33IW3mT1wiLGjLnRAPgzPcJbhktpzRoh21N2QIx
	zFGbEkZp9fMBEfc5YYYXdhAVdp7nggt8bAo8x5Rk4gnuEXZcz/UI7nMf6eSXAnIDwLNtS99ZTya
	ZEdtxzsAPLWXTG2qVlQhTuTDhpFWjk2W3oDxCNgM5msSySiKfOU4n5Vkl+iqi78d8jjQotoJgee
	qgv3jHuAsRlcjnHlVPkG9141nSNnQlmUGAO/3SVDQGXLt/AFdA4E36Z+np5Dp2rffIrTaRByHGu
	Mt
X-Received: by 2002:a05:620a:2983:b0:92e:a48d:251e with SMTP id af79cd13be357-932fe2b5b4emr1445285a.24.1785171019290;
        Mon, 27 Jul 2026 09:50:19 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de5150dfsm649312085a.3.2026.07.27.09.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 09:50:18 -0700 (PDT)
Date: Mon, 27 Jul 2026 12:50:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
Message-ID: <ameMSbNO49M45Ieo@cmpxchg.org>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
 <20260722150006.3848560-5-hannes@cmpxchg.org>
 <DK7NM9RPUJOD.11PNJJ5N2OBED@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DK7NM9RPUJOD.11PNJJ5N2OBED@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 68610A0009
X-Stat-Signature: q8upwzscxrnbh9qcdxisirdbjrg7pu3a
X-HE-Tag: 1785171020-13945
X-HE-Meta: U2FsdGVkX1/TL4brWhIMBoFa+GWpg2PgfKK/vv+teT7GexvMPHDBbLYgSdbmX3TpA5HLPHSTkg+1sN2udTXnoWbQVEh3NDjAUPiZP/okRKLLmRTmGI9ogC1H+Hj3UMfgJaBjFSaqwOYAEx4lWi/CEH8WaynczEkPEPEgEBtWpkhV0b9j6SPoofSGmepmd4ks5rBzd5BppEIcXk1JRRoU5eoQTZHqwcoPkz42QT0oYvu8rz0fQAvCaCOEdLUnPdu2HZ4WE1KJORFeIxnZM8oA6oHZruy6HleVEXcxgo+28TGyXInLZR/KjUEJbOt/mniTvH9IHfMkF7ca9gidLCUPpOBu741thLeCCym/Sb80uscUxNWqJq/5x+sqShiR0Sde2L8WAQiD8OCvwxHx0A7qK5LmAF65BW+gz125l1BdIgo27gmQGZuSd42rY9e70l2wKqQrps49LEgYrnwiEHY04xB1VFdXUz6dWF+3DtUGL+0khrJSIYtUMxl5qg2LV7rc/RULduBsD/IzQ4K+WLBh0KOqjao9X/s/8QLhmFtXNLTZMKRKROuipiUcUPBbZr1CcexP4Gl4OOlLAAX1Vm1CP6am3u5hNOxvUrFrA5RDRWPZn/T49NT8GjGc8vqmxcE1nHaD0sLoXIlAlNlwiACBJxJiY8yGNoeRXaUaGE7VkUCaQurMN8YXgDkaLnrhbL1pMZPA79W96dMGJeOWCgOiXRgKiawEnfDPtywC6FFHLZLBjLAawJYn3SUedsbPgnYkUopnk0vRmbbD5L5VxLqP49Iaa649xcDwj+D2jxugLdI50SBQIUs8qdSSEb42JukqrylZ8za9OxWyBN+IfT3q6FmgZ5kP+4JUzvpZSNu6QU32n/qFUdAsljGjxRuVOLghPjhJwnraFrPj0N4QCma/+tHHh596YnHSXV1Ymv/bNiEuhSuYMgVN+08QpCRAJkrOQnql7H+yyntTjG5WUWE
 E39LiUtR
 fmKrcWN69lEs3Ku9NSEX/61IUz4WzkVm+cCdWEfkLfDWmUpi/ET4C0GELirzWse1LypyvC5P3AfbIYvjllC+bEe+GUiyx1gF0ZYfjx0R4JLVgWCii50Mlu+o39JRPV6VuRm2gm2/uqA1NabHjo67nPojMAhUpS6HV8h82XiONnwi8vJusbKyuatoFZ9CM1I73ZPvryrHrxVqLcjSrEelfd+v0JIj2Y/DWJ3SlPfkIGXgpDboJd06XG6K66FOWR38Iohlxk84J0XElpdKokFDHwmwhcVxc2GFogYF6tNyMwWdkcGLU/L/imkSpMIDNVuJMnB+AZsq3HDSyIwENaA9Nd3YCEsiHu9hI4/WvzEosV3DOVTORMMk7bjd8s+CTvF8NK+I+iSR2cNjeYDRFmLPSsWrDqupCOEVedv1hHiPu7pKhTs0FHrZz2/xlFw6Y3R04tyMftOPQ/723AsI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 25, 2026 at 12:34:29PM +0000, Brendan Jackman wrote:
> On Wed Jul 22, 2026 at 2:56 PM UTC, Johannes Weiner wrote:
> > @@ -4169,8 +4185,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
> >  	barrier();
> >  	WRITE_ONCE(current->capture_control, &capc);
> >  
> > -	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
> > -							       prio, &capc);
> > +	*compact_result = try_to_compact_pages(gfp_mask, compact_order,
> > +					       alloc_flags, ac, prio, &capc);
> >  
> 
> Nit: the comment for try_to_compact_pages() is falsified by this,
> we need something like:

Yes, good catch. Thanks.

Andrew, would you mind folding this difflet in place?

> diff --git i/mm/compaction.c w/mm/compaction.c
> index 0568623d9384d..ca57403dc1522 100644
> --- i/mm/compaction.c
> +++ w/mm/compaction.c
> @@ -2823,7 +2823,7 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
>  /**
>   * try_to_compact_pages - Direct compact to satisfy a high-order allocation
>   * @gfp_mask: The GFP mask of the current allocation
> - * @order: The order of the current allocation
> + * @order: The order to try and make available
>   * @alloc_flags: The allocation flags of the current allocation
>   * @ac: The context of current allocation
>   * @prio: Determines how hard direct compaction should try to succeed

