Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11C7C531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 09:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1BA36B0162; Thu, 23 Jul 2026 05:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC436B0163; Thu, 23 Jul 2026 05:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E20E6B0164; Thu, 23 Jul 2026 05:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 601826B0162
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:37:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C5998403DC
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:37:55 +0000 (UTC)
X-FDA: 85019539710.23.60C07C6
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id E67D7140007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:37:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EEYQ03Dw;
	spf=pass (imf26.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784799473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPUgpb0frsnp1JVUTki2lmBuU8fGYW5E1pXwN+DTdbc=;
	b=g+oIvhGd34lmm+21ryF4gSnyEFOpzMJKh+ufnk8A9Zmd4uxpoNaRDwd9/VoZe+zN8dYrDJ
	jnngtGFOZx39onrLgGS0WuEJjlO+GnrTWdFMxrn2uEtEFYYk4xTkboCBwl/Lca0Y2Ta/OT
	oIRtsILEUqa6wxjb+NRAL8WOKQvEe/0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784799473;
	b=qzfDyGKf3iO+u+o/o4PisOYYwOIl2E6Ms4XX4rPqs8GKJzK5CHQ/lkJK0vIgkUcMc6FFGJ
	nRwijaUEfwRQ90te/6+ac0mlwF7WdqjEbhtGfgM2F3VChDmSXuGsZfhkXQKtQrsFwCwjZT
	+FudBRGLdzZgE9uqHzjBShk4A1J/n8E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EEYQ03Dw;
	spf=pass (imf26.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8487214ad2bso587609b3a.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784799473; x=1785404273; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oPUgpb0frsnp1JVUTki2lmBuU8fGYW5E1pXwN+DTdbc=;
        b=EEYQ03Dw+MCXPLLR0rO/BXqiQdF/JyUCVTDscPvDQVv+Xc12Tf02oFKhNoXFw6vhxW
         rREGQdD9B8DIvDOsGLmsAawm21S5l0L676j/ERV3C5+T2Yqc+E3QC0Jp1tDFaBDPoAeY
         2ODz3m28JWyttK1TQ2gk31vkTESIUeyf8PpUARJp5RBSJ+fixzzXXEGhLLQoLu9z+i38
         mhSHchC0wIt0Hz8gdXEtuzPgx6QSotI5HXGtwoTh5PQL6eR5p/QLud+eybge87J0+zsx
         G8T49hhGpwBvar0stNjFRrMdlShhhVYvAEWP+kW6Cb7F9YJdlTlSmFn9thgmmTnnRKkH
         eYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784799473; x=1785404273;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oPUgpb0frsnp1JVUTki2lmBuU8fGYW5E1pXwN+DTdbc=;
        b=Jiqxezbr+OHsU1Tz426k1dSmlY5IjAKj3OG/OiPYBWbKewhKwc6t2UWldVk1iOmBz/
         69l48qBWdzARGWr9wHE2KNivCIqMGPIrZTu+4s4bz6Pduobq1TPkff1avYf37j6lbhtD
         IfSKr7S7tMi1Z8cO7cQXq1j2fWWsblGIUUeboQWtkXB8n6WY+qd1uhpjv/yHrAZBfOGd
         1KVbHiCgt2A91zBdBFCPyHD91tHSSZGda8T1eee35XdPCqb1lv3eSbGcLd5jgCBQrKr0
         AC5HxMee08KdI/cjeSZqqJgBJlh237LJOXGdO5VMaUvyJZ0QQrbnOn/sI3gw7KdmPxw/
         OsfA==
X-Forwarded-Encrypted: i=1; AHgh+RoEyVd4Iwpsly1RkEZBcI5s1Larub9ZM1v8S/PiwYYsMUF3i2zOaW7U2sUdBt8PUs+RzrVMVFUgcg==@kvack.org
X-Gm-Message-State: AOJu0YwvhNTdc4iBhfFBsoCCkbCUC7fBPdRx7pIVTZZ8SGRt2aCIHXVD
	fuTLpPq7gPRcfqJHjno8GXMnfRkLba8urkxwcmQuvYnBsUaXVDgyRKv9
X-Gm-Gg: AR+sD10+MtWY48uUbk68z3ORWVOCxNGATSLEcpAb6nPyMRKtJEywSNoyygWEe11T7bn
	vFlPDb9bQywG4H8N9Vr/+JyYfkp9jRWFP2Y4gJqGh842wpF9XknN99voTJ1ZPest7oI7+pFRoO0
	HoU29EMAK5uyS4DqNghlNPmD6aUjE748aU1RgIuEpoW39bLx0mpG/XgdVEj7wZOMdWhKAJm7lz3
	Snxnx5+rELMWshvlvF/RmQGP0JJi2calb3HCt+LL4FNyITieB/bHhhnrbvPOsPR5h5EiVvn5yrl
	mDbXcMZoUkU21ogzEE5iOmgZ55rOAjKtgX3ytHgF9GgTlD1JXPZQT4ovKeD1J7/iWmJmdjoKdNw
	a3qzQulITVgfTN9BXd6LfrJ7a3xm8cuFANHEq7owbZ1yl6iegutDhQPP+sojkuLBZe1NxjFZn76
	VyBsxmgqIKKHwMVhrLvnplkrG6k3QmaYNTwmw+shusgbCzuKUo
X-Received: by 2002:a05:6a00:409a:b0:847:8650:69cd with SMTP id d2e1a72fcca58-84e2bd889a5mr3035099b3a.33.1784799472690;
        Thu, 23 Jul 2026 02:37:52 -0700 (PDT)
Received: from li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com ([106.51.160.24])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e175d4133sm2738565b3a.50.2026.07.23.02.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 02:37:51 -0700 (PDT)
Date: Thu, 23 Jul 2026 15:07:42 +0530
From: Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
To: Gou Hao <gouhao@uniontech.com>
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, 
	tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, bharat@chelsio.com, 
	jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, ynorov@nvidia.com, 
	namcao@linutronix.de, sshegde@linux.ibm.com, nilay@linux.ibm.com, kees@kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
Subject: Re: [PATCH 1/4] powerpc/xive: remove dead NULL check after
 GFP_NOFAIL allocation
Message-ID: <amHgkkMT4nrWLSka@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com>
References: <20260723081813.176792-1-gouhao@uniontech.com>
 <20260723081813.176792-2-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723081813.176792-2-gouhao@uniontech.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E67D7140007
X-Stat-Signature: armxdzhsrrueenuedmxci9bfbr6ijisy
X-HE-Tag: 1784799473-980863
X-HE-Meta: U2FsdGVkX1/9AUR4KOtGU4CBg4hFZNEDq6vszRzWa9LiT3vHablOs7XBrKzUASdP/0F1yOTaeio0fG5okYizVvxKoqQsFGSaJ13oOoys3wvC1NEgeZED9v5QAAuy/CNKpSm6XznuSAWvnEDrAZAxi1qURY1ygu/wV85dwa76smOdBQSzE5JpnZAai6Rsol07KAOH142Q4GUAzfCYZ7TlnANW2dz417QVokVP0cMGUGaEKA7urNv8WwtDpIennsekXFZD8oDI/rxltcDM/SaBsrQkftDZbx0zf406i4zJ7D3EfXeiRRpzqZ2qOtvuXMfJPtBCUTwib6EQb2MYU+DO5dCslwG1p4FE5LYIlBMioDVJe6Mo0kt9GTd+Ftcta+qN16q2RHqrOu4Ac8ZSHeI8FxceutZqsujQFLCQp01Rlj92Nh8RgrkGBcDsZDnZkXZIJR/50jC2O7pVDBYCb35Fr/X138mWno1oYo8I473wgpNgQUlhZYQjyS5kCYp40WZyK+Dqdnm5jpyzGu5SxxpO6KZP1AxaYyIE5lbp9m+obd/SrVEJt21tzZ1V5kAs2S+rBGVnQbxnASqGgO0aU+nGCvAPdiMMBsZ0SwILYNqHG/Tor7p6Woz39OEqJnR5I9VukGnhkNe80FBdM5/I/Trj9vzQLDy5zNftGLWWLp0rOKTFxjx2o0f1z83ZS+AIG+slFSLDbecEQARPxdBE3NkX74ksPvHmWQpFWJSc1+o3dII9MlsR0H/lnt9l2UnVlI/YtiVfBl03pfN4mQzXhHuOxlC6gCwRfKiV+2WxTtVJGpfLt4OksKtv7c/cOKRLRFk9IjXq5nAzk9w4Jqxjfr66nat1uZ9r+F60lcvYZh9aDn0JAq44BGPD77sJbtC3fbwjT8cV8FIidVSGcNntTACw8Pl105G1k4BKftSob8aFExLqvwmq9RlbRPqsHQNXl34IPSsTfkbyw/aHnRlgNwu
 ZlRZgLBI
 Ti1nRh2omf2523WrB0FRcGL320kRlAGuChjSEw3J2cS37Oi89FFn8MvWMjitFitCWxu9492tsO3hWWsQx5yHdZb50mGdYGyqkYySgTzlvhpiPYUb+XUy3TCG8gIXhGXbpe9fPxY7lKpI5T+NhyGmJFxYOkotLBZL3bhD3tncGwKZ0KDGPVpHiZEz+SqcjScNY8GgAiAc2LsCPLiYDuyAhR5yRPTUK5+//fB42ykkuBwNeR6MUsB4cLBlHi1NmEGFfkiDTyQJSW5lfAJ74oy2OZmIwRXSPjCFOYyOph/ip6QYddK8yCczux0xuY2pJm10dv3ZQWAd+VCl8BNTl+VMiG3dxqtEHzh9umuwXgE36zjbNaesdVLBUWxl7AqoBrGts8B+9F0QH10knfZg8ZXf6G6SCGK6b0vRL6oLnmVZCbkBa9/dIzRLqHU94fXRP27IA7nBi4cxm9/IhSVgw54c62ps9Ca9TMspp3MLxrsMr2U3Nkn5nhFArw3uldA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 04:18:10PM +0800, Gou Hao wrote:
> kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
> subsequent NULL check is unreachable dead code. Remove it.
> 
> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> ---
>  arch/powerpc/sysdev/xive/common.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index dadd1f46ec93..79d7854259cb 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -1134,9 +1134,6 @@ static int __init xive_init_ipis(void)
>  
>  	xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
>  				 GFP_KERNEL | __GFP_NOFAIL);
> -	if (!xive_ipis)
> -		goto out_free_domain;
This will be an unused label after this.

Regards,
Mukesh
> -
>  	for_each_node(node) {
>  		struct xive_ipi_desc *xid = &xive_ipis[node];
>  		struct xive_ipi_alloc_info info = { node };
> -- 
> 2.20.1
> 

