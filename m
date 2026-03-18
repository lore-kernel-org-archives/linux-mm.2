Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93FC510775F9
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 18:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65146B02D1; Wed, 18 Mar 2026 14:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B255D6B02D2; Wed, 18 Mar 2026 14:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13E16B02D3; Wed, 18 Mar 2026 14:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4F26B02D1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:10:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38F1459BDC
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:10:10 +0000 (UTC)
X-FDA: 84559972980.25.1D67F3E
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 35B541C0004
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:10:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bmxk4jW5;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773857408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LqCwTUD6zrFGHKkKX0YkpZNWhhJCFlSqR1azNDH71o4=;
	b=Uhmm4AjJeIf6jXzJ6P84bsoDddaUs2YjC3qAH/n9EHuOk6lRbeYdE2ZLuo+xWRv2MuQWU1
	VVP3onxNkI4+JHhLmmh83ncvn0mrbHgLVk5smj9idw5OBQLq6r6vbl99wGGVsOKYUzo0oF
	PsZ/EMmA6+JW7DiHk5PNfEbE5sbdcP4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bmxk4jW5;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773857408; a=rsa-sha256;
	cv=none;
	b=CvZvYmvLy7+uuVmEIR9K2Z5xASOY+GXOOv5vLMeAh9dU7Jj464adpEyOVM5RGKCOwU4jXW
	8ZGDWUi93JrQOifCDdFDC81Fkkp0tsp6wTFFRN22ZR5rto+K0/J5BujM18h/QZoWcECOhk
	/Z8vhZsZLoZRppbOz6c49fJNVhyxY0o=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-38a43f1f978so1691311fa.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773857406; x=1774462206; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LqCwTUD6zrFGHKkKX0YkpZNWhhJCFlSqR1azNDH71o4=;
        b=bmxk4jW5hele30ECWqGeNGHq98g0OnF2eWy7A1i2tDoKL068/LOEImqA7lcjaDVOkc
         0k6yRPuwuPPt8n39q35Ot+pXdedcMg/fml4wCWfDHOOb7XwKOHq0nSanqBjW6J/Q4yLH
         R19EMDKA2mtC+D/NUkFxAx7SavmR2InLHIxeC2g15zMvK3LFi6Beh53cPI/LtgNvga5M
         NAcohsm+yJ9tDk8q84/3LwzX01WajHw2OpcQCHGu1394SjTdu3S4pWC089Cyq8JXnWtI
         ZhexCtL40O/Dd3aGajd34SOQEpLRPx+iyhL2asOUwtmRmQpg01FCH5aO0AsxdUDUjxsT
         r8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773857406; x=1774462206;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LqCwTUD6zrFGHKkKX0YkpZNWhhJCFlSqR1azNDH71o4=;
        b=hcFphgFuwG9KJtulESZq8sxVcr1ULyITlu3WCcl0or+jVf1ogY0h9+i/5PWBltypWL
         PM8vqYIzEQ0Ii5rmqv8Qy/RTr33lJRMx+RcK4SiIDhAqom+ebq2FbDWO2zRrnRn2OTq/
         +IlJeRK5Oq+iTn0HKv8h+O+niFFTeVY3C68KIkdM5Nu4JgqkT2f07elfL4Z0RRzlxUPR
         kQTMH6+oXQMol+toTQInGWoRZ/MZ2iXHcyTkZzxFS/GGyR5j1Mm8lknQfHvuyfAClx8l
         Yg7P+wDdauMQt5/MgyZlxDMrprfMTsBmYL8o8VuhatZZeHZ86zH06IGna+ECM46NM2uS
         Lc2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVySlc7xMTdf8nqvqGFaDYQwpHDEIrplWt5C3Hn/+VjEiR15oK311/PW07qQC9O2jdfH4iz0lpvqg==@kvack.org
X-Gm-Message-State: AOJu0Yz2WgeNqoDucPBPPPKdwzoFHsI2CAyCt6ioX6IR17YNnE8Ri9Oz
	Q7eSjn3+sLPNha7BlMxBFMRo1jyA8N+H2f/iq0qhN+7l9ouRi98IifWE
X-Gm-Gg: ATEYQzyFafnKiJhZF1gSDeTMImWlUt2Xp1XMOckjxECawiErSmXmmLUlHIS++CCd6kO
	k1vVyuEdgG+2HEeZ5NGW/nxsl2iOivxaFXm4wGo4dj2tr3mK625SJ+EkDCyWg1KE1v8KAqXkGRj
	LRlAtEBP33AZnLft/0eouqyj4GukfYVh1+cpZDZxiBPzAtjUWD43fNYB/3nty+FL4DxxE8bv7BL
	aYTaXGgyMUOkhJ/LdVQ6v9xjsryB17Eu0plH1dh8OU+kfVJlRyKGpNnvJbmOJunj+JBhvxpMIUf
	U2dGo8pZbr7C6n9pe0sEoyEIWghiKmmn0Bre4GrqtXembUs/gkgFpKxpB47RvZGKvrSDoA9r6Lv
	mMsh9YHbK9SXH1Q+JCefl/ok+7AuJMou0U6FE7pV9Z+1q/nQYKMofESzHpjYokVON
X-Received: by 2002:a05:651c:32f:b0:38a:4aee:423d with SMTP id 38308e7fff4ca-38bd588d042mr14940351fa.32.1773857406052;
        Wed, 18 Mar 2026 11:10:06 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38bd54ba2afsm7229611fa.28.2026.03.18.11.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 11:10:05 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 18 Mar 2026 19:10:03 +0100
To: lirongqing <lirongqing@baidu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: use unbound workqueue for vmap area draining
Message-ID: <abrqe7WDcbvzvrqt@milan>
References: <20260318073630.2325-1-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318073630.2325-1-lirongqing@baidu.com>
X-Rspamd-Queue-Id: 35B541C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: z5qk9388qemxp8koz71zbhjwagtri89k
X-Rspam-User: 
X-HE-Tag: 1773857407-689841
X-HE-Meta: U2FsdGVkX1/McII0DTDtB7vIZiU4SlY9HBd09fdPYQISsJVDCPIxjhLEZ4dFrv5xgb3l1I4fHBFeFw879LeTZtnPIl7cCSt5hF8Zh7OnAhpsGmo2Ipdzd/+UDYL7dH8y8BAiquXkxSnTwU/Dv6Ph4ap+v6zP71zilGmiPXvRC94VLhWNc69y6KIjW15opKL3CYqVuyB4L8bbTtk1CkRZvQQ+EaNQwBEXtD1WFSugFZTzDkOKRjpS4yFxX50p0rRa6EUo/uf0diV0S3rHF/xg5N2xxYzWJHM2ZsRavUJU+TSAn+wJ869ePvNprIdWQaFlLPpI83HGGEfJRbHBOPASPbSCNC4bAn9N4+MjTQQzmyOJspcRBAtS0EQmQdzEL4R0oz5LsgFRLFYD5C8WzocmxW/Cfk+by8rBqOfLgG3V+MfXlITOPjFX8kxVRUFdX+0LycJ1KdGQoSlM6ivSqROmPGu0RZt88W62n3gICC7DjLGSwyuIf/lqAFcLWD3INnLRKeX7pzY0TPsd+j6Nbj+z8sR/7YEo5zjYC5KRTufqHBL66xCgdJuZNCW/zYfbFb9FVIrDCSBVJ+0B2EfnkwZ2yy/ggQqpNAC2Qtve97YKnBCUmsIN7wQbAdMMxCzHspTyALj06t+Pt1qUKKmyzdOpFLLcptnqQZoIdrGBa0rJ0TiP8F9h0Fl/e9vAK2rTxq8TOv3u0+caBtQb4Rt4h0QZAQW0sMkaDrTx0NwU+dz8mcYge4dtydL744F1trwt7QlDmkCWGXFxP/fX73HEdCKjB72XjXzRG2VNTv4g1p4LsdzjfZ0rtyl3SSh2PQwgsiLwtpFFkbHS1eI6+hx8UUhZ8F8/ehYNxWiWW6JXly675LbYzrKTB/oEsnNBAf0vz9HEEOcFKxT+4uRQ7j8c1meI9vHqTCBQds81AP5n10i2dBWJ1VnQyjenuxsxTDJ6lpfAdpjVAPINWzKzMpucg1Q
 02BIMXwz
 uc/Sp47U6m+m72TpGZ2upH4rCpwJeGCYWeelYYGF3g5Pj8E5/uI+3fMg2U3VEzEOHrAD/RdCj/q6LabWyhnHPpppQ03l+U9eq+4n0sMgOv54NiyhdPlW/dHqLwNpOyvoAAEmDPQVPTAV9PPMkwqxUlchuWSNqeW39uvmNR73W5GH0PN5wWTZ7NdY8ljx8Xj+RGE2Bay/cNFxkOTwoV+rNNosh3D4yM/4RmPG5dsEqx9sWyjVf1GtmItziWyaKZOYbS3dgt5NKdhkUM+Idl6fkJiaCR/hYYY+uwQoPutyxqhZ2Wg2mvDf942UbIB9b29lQY85WDIZzgW5vFFu17i1aoeS7BMrHt+1COl6riBR+31VH2NR42akXOci+Dvt6oVV4xRdGWv+dw10nzHPauC67Pfx4C8QGPtAagzSN8SS4Hn6ZFL0gd3CtbE9P7/Kc8UvdrR5PhuuNXFoXvweqZWWHyEBVybyABSLm9MZp/q0Ed2+YrA3VZtVSVPNKp1DnPMligiUM/w5krJ/F0SXZOYfsnj+GiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:36:30AM -0400, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The workqueue watchdog currently reports that drain_vmap_area_work
> hogs the CPU for more than 10ms. This typically happens during heavy
> memory pressure or high-frequency vmap/vunmap operations where the lazy
> drain list grows large.
> 
> [ 2069.796205] workqueue: drain_vmap_area_work hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> [ 2192.823225] workqueue: drain_vmap_area_work hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND
> [ 3225.388966] workqueue: drain_vmap_area_work hogged CPU for >10000us 7 times, consider switching to WQ_UNBOUND
> 
> Since vmap area draining is a background housekeeping task that does
> not require strict CPU affinity or cache locality, it is a prime
> candidate for an unbound workqueue.
> 
> Switching from schedule_work() to queue_work(system_unbound_wq, ...)
> allows the scheduler to offload the draining process to any available
> CPU core. This prevents stalling the current CPU and resolves the
> "consider switching to WQ_UNBOUND" warning.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55..5f2218a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2471,7 +2471,7 @@ static void free_vmap_area_noflush(struct vmap_area *va)
>  
>  	/* After this point, we may free va at any time */
>  	if (unlikely(nr_lazy > nr_lazy_max))
> -		schedule_work(&drain_vmap_work);
> +		queue_work(system_unbound_wq, &drain_vmap_work);
>  }
>  
>  /*
> -- 
> 2.9.4
> 
We free memory here. Therefore it is time to switch to our
own workqueue with WQ_MEM_RECLAIM | WQ_UNBOUND flags.

--
Uladzislau Rezki

