Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7EEEC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 06:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380436B007B; Mon, 27 Jul 2026 02:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3310D6B0088; Mon, 27 Jul 2026 02:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221A76B008A; Mon, 27 Jul 2026 02:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D780A6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 02:16:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A1EF1C0DED
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:16:54 +0000 (UTC)
X-FDA: 85033548348.23.1CB9C7A
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 83BA5A000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:16:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bmFlTvdd;
	spf=pass (imf25.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785133012;
	b=xtmRAOfbT+OOOdIW+FnNKJCGAdqF/v3er8LCtocSp6w57nDuPpzOKeANzfKaRS9Rik9Gyw
	10vVku1FmQjOGyMIOoS9ArhLbDakh+Ysunah4xSVhPkfgErJXn1F0fLUQ+i+xUG14gjXQ1
	ijBSSNruu2Cxxm7ETSKRrAZEzlWeMPk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bmFlTvdd;
	spf=pass (imf25.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785133012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkvd3GaxfP8zwg2THjBwEOUnMuoDnas1hdLWEj3iqG8=;
	b=MkmF9hVDjyCubk6iuwWDvzVA35qZVDLAwii3cjNTSQXiP45ehr1+1Q2yQeFuL3zREx39SB
	kP8Jl8iMUKZhNZ1vfBsOs40GroUXpVzSgFr6aeFTHCHw9r57NtTdFZW8wJMnq9debHm3Dd
	iIxvMzqxUSjnrlGmNGxdL++2P9BA4lQ=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84862b0d5f8so1737744b3a.3
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 23:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785133011; x=1785737811; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xkvd3GaxfP8zwg2THjBwEOUnMuoDnas1hdLWEj3iqG8=;
        b=bmFlTvddJmZP6cv8F7Hxjlabh9zLuQ8tsrWZ4djwEhvSH/mr+FlwUvxZArma05Ck+n
         H0d3CeGqa09HL1obdxws2+eIjTmWGxOUQUD56W2qyiPpIU2/0KKK/Yn/s7wpPduYskDO
         DUGZiY9+yq8BQKk1YRBSC8HUL3fosMEHDRhKGd6MGgSuPOnH4pXbATjYct0CThh/lCiM
         k4tXFn2kPLxb1giGxpl5ZHw3LP0EWsNdEdk2gxd9w6lSoaLV2RGnZYeMywyskzGi3D5Y
         NA0KQ0jXUaB7W13uK/kdjsbFfAFgWqCZ0SR1LJHpWDckFZgXUBejwHsSWIcjIrcOYz3b
         F4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785133011; x=1785737811;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xkvd3GaxfP8zwg2THjBwEOUnMuoDnas1hdLWEj3iqG8=;
        b=sdGSma3TiyPQR2naISIMokQyIZHLMMwEYrTkhJ8Cw15oM8Pga5fSWDv9wpE4CGhy8P
         c95wdb8KdugWUvhvoDWqVLcr6cskm8v1XRRKy5XIB4WetWRPOWs649cS3R4QNNaQlSCQ
         y+TSgkgGtlK3gis/thtYgN5pvUsiCWn4oBAm8IrCj+Bstv2NUY5SnUg4+cHwdkvq+wql
         OicPfQy13p/KP1IoTlyW5UBnrNfZCIfI2YJt36o6+cjLUrVDT/utJQ16VMveIYgMQqYF
         Qd9PCxaTmJTlQ+KpLO7NA1p8/l9D3EB4izYkjBhPesZg+B+LcALLV9gI7B+Ai94AfOKs
         2Nfg==
X-Forwarded-Encrypted: i=1; AHgh+RobrREuA2WQMAEskxmzs6gbVj/P07TYSgYGMiGQi4GBfrtOK3vRO+7fPNwrPf1a/mHiNVY7xAc7mA==@kvack.org
X-Gm-Message-State: AOJu0Yx2LUPm4pCXSKmHqEwzipPGpuHC/bDnLjEDn8Z34k2w8MHt9DND
	XKCtD6GyxIfz3M31IjqQzqBGX86nFTHCC15+150j4csm7UjA5aF/NVxX
X-Gm-Gg: AR+sD13xLE0PmUskulF7jGEqVc+Fpg9FqIllukzs8eIermnPvoxfhapzuEAy10BpflY
	xl85MJabN+ChYJ6t3biDe3NvNVamFw+JLzoGBwIUbUCUx4gpVCITlm+rbXVnheZRnY7AGosZSTi
	dDEfRxFNWDlNP6VIWA1a4eKYXpmOi0YKtgJoWDp0/fj0Qxu1qAr0iseG8h0D8m870AKSZuIYiOx
	pL+buvIFKN6z4U7EQjK0T4TBz0VrnTGt/WHq/3Z5/qQFyhWT77nzpnDXg0dugrXGCBWfx/jJUhq
	tIz3J+rfrXIIJyxT8fQXbvifkU4GiKwERPEEW/UPxOqcLtyPilrIffWbr4S3hknLsAbqhkP9y/c
	Hw2uITli6ZWkpaFrOXcDpGlgpJbfEY8iY4GscvEt4sfIM2hrv2cwo4AG0l3e/SX/lZDEzeUiAD2
	hubdhFl5YkrXLKPYDWHy7ArvhQNd5nC5AL4DQWv27ImE9qDg==
X-Received: by 2002:a05:6a00:4ac8:b0:84e:1db7:2f86 with SMTP id d2e1a72fcca58-84e59572bddmr5479084b3a.49.1785133011409;
        Sun, 26 Jul 2026 23:16:51 -0700 (PDT)
Received: from li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com ([129.41.58.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5343a9c6sm2607131b3a.51.2026.07.26.23.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 23:16:51 -0700 (PDT)
Date: Mon, 27 Jul 2026 11:46:42 +0530
From: Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
To: Gou Hao <gouhao@uniontech.com>
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, 
	tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, bharat@chelsio.com, 
	jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, namcao@linutronix.de, 
	ynorov@nvidia.com, sshegde@linux.ibm.com, nilay@linux.ibm.com, clg@kaod.org, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
Subject: Re: [PATCH v2 1/6] powerpc/xive: remove dead NULL check after
 GFP_NOFAIL allocation
Message-ID: <amb3uArRk2MlHRuc@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
 <20260724022851.466017-2-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724022851.466017-2-gouhao@uniontech.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 83BA5A000C
X-Stat-Signature: 3jicc8udp1jo5sku771kh37eur74eq4i
X-Rspam-User: 
X-HE-Tag: 1785133012-756209
X-HE-Meta: U2FsdGVkX1+pJJDhmUzjlvHh9wdYfyqjEj1Qf4fLVaxj+BMRB2s2Hk8Jsp+xF7lZWTqZtvC21imNBGQcYgJ3SJ1AqGjDH5+SCl2XiI5zDeVLzRo/idN3qY7aDzDQiG7cB9+eZQiMIe6tBKsSOXJ2nZlazVmmAfsj4102DmolTQ4zrB6dtGICpkPIv+BPvr12XknWRlPHpM+yVTRmb4v9YcqBPmU1WtljG0Qq2X9Q99QCVU/OgI2DpKtFufwWQICZaYo40OKMxi+VIRkkaTmeDnT1jDY0w3eWqvEU6+zTzf9xl5AHHeEsu7Ln+CVY5Gs13wgVsisF2wNvjd9i2h+7y4lgV0rb2BzUA5L0RQR35v1dpk1wlWRYJXng5zMjYcGS9kc4WcP7rmFOzoovz/KVEVWgmWzj8wMOUgQ+6A4+l3Q5CTgPXxpA4F+Jo51yP3gfsq2AVPmX7r/n7F05aAmScvrfwszK1uVIsG/2gO1zxg7YeFAvf0nkH61YWmPeB9FhPAGcdtB5+delUZ89IMsg2WLmF072CsUsR2Aigba01xe+tMHURZ31y3FfaC/75EFEp1O4tJlebSBTwcEH/T9XKJL+MaRajUZ9LEIEo2eV3/E3ocbEZX9MnJragYbkwLTqqjiZoB7rUsAcnXzn5B6lxcotd4D4b3Cj67ogTobdaoVmn5A6fxqiJR8D5G7KteGiQKfdXu/95QXvLK++WwxgFC8PZeZ0uC1Q8Arlf/xVhabaBazcBdhXNp/Z0D6Ha3ravXzS0hlKOUzozhut96vVHHh3/IsEpHz7DEb1mMOTRWLoNHRcEfC+VapL0A0KH4R1dnZ4/j3IDcnidxybGJ/qjxb+shEWSigTxH2UCe2HeFWr37RDs0gH356NvP/hDN6QdSC+TUMWtAJ9KLdj1rxo4NUA6usduiex0+LMixilEhpVBv/ZZuKbXYPRljrv7li5M2/Lb70VxPRRo5H6WQp
 8b2FcF0Q
 3gED7yJBt1ZtQ2/cgfXGltFmVf7WIN+QKjVm3akyyfu5rVGGbH2ol+k2O22YzXKo51UdQ8lvHL95KGx5bI9/BgzXivdoTLgwmswTsjWPLFfPF0A8AxK23w3QVzuNWT/mqulghl58M2evc0dnjxG7lTjPozKZCwWKVwaYU4sulSxnsi6o3yFD9gnVR0I20HL0hqN0e42dJRCtPrUuj5syCGTjIUGlScfBimp5J/3Cj2bjjKrWrNsL3kfJWCv/aMe3TwIG04/ztIKaFFdRW2UX4V3U+0bthSJwty6anEyBOJlktTbHncA5kDAmFUhx4T8aQX6QYvsq2cVGVwVI9AbzpFAbjtPioRzEXSKdHBAWn1OAzu6afPYFDHHk7nXNOxEyuWFOgxO2Y1no9EAGCamAYjCaPDJnqP3lRvRxR4ctNnnkFVKI4XctpvezzGPnf6IxyO+qSl7wD5J/FS84MFZzad6DX1raA35XWvCB9gU5jgyBIAtEGZ83F5d4Nuj+yg85j8T9/9xoe9+gmC8lw78MIEnIicw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 10:28:46AM +0800, Gou Hao wrote:
> kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
> subsequent NULL check is unreachable dead code. Remove it.
> 
> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
> Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
> ---
>  arch/powerpc/sysdev/xive/common.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index dadd1f46ec939..f2904a5c2b7bf 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -1134,9 +1134,6 @@ static int __init xive_init_ipis(void)
>  
>  	xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
>  				 GFP_KERNEL | __GFP_NOFAIL);
> -	if (!xive_ipis)
> -		goto out_free_domain;
> -
>  	for_each_node(node) {
>  		struct xive_ipi_desc *xid = &xive_ipis[node];
>  		struct xive_ipi_alloc_info info = { node };
> @@ -1158,7 +1155,7 @@ static int __init xive_init_ipis(void)
>  
>  out_free_xive_ipis:
>  	kfree(xive_ipis);
> -out_free_domain:
> +	xive_ipis = NULL;
>  	irq_domain_remove(ipi_domain);
>  out_free_fwnode:
>  	irq_domain_free_fwnode(fwnode);
> -- 
> 2.20.1
> 
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>

