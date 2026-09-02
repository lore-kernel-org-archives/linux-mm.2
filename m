Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC986C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA0E6B00A1; Wed,  2 Sep 2026 10:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91796B00B9; Wed,  2 Sep 2026 10:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA86D6B00BC; Wed,  2 Sep 2026 10:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B94586B00A1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:05:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D77A80217
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:05:02 +0000 (UTC)
X-FDA: 85168993644.03.FB7D659
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8866520006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:05:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EAsNlzLt;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788357900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Why+id/p3RNpzcV3QpTHawTDpT4ABQ4KUVboBTGGWGA=;
	b=iI2O2csq+Zc5abtS58rqSp+kjpXago+m1JtCUivYdVLMJFaOWLm12bH1GJJYn92+RLl13k
	annRD0JB1InhQhxKtw3KD5EIS6nmNP4WPUi/s9f8Wsi0hYUC1sv8+XJuyMRwdq4IUXGfP/
	421YTpzqKmd7hP37R84xUgi/w/GYm9Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788357900;
	b=uGZ9FEQWv3y0WDesqS1ESOQbefGCAR9kV0eJU0K2Vzzuz1LyuPSlY7fT+aOkDTsseCV+W1
	TqDr8MwNBqeonHG3qx4C1Zttz0kQoX/vBUmFv8gvbVnDJO+eiSShLJtsFmdzQFSGcv4f3E
	4Tpl/dtnXsGUlrroA1R2czEHAF7CF9E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EAsNlzLt;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-90e95a18c92so16371596d6.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 07:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788357899; x=1788962699; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Why+id/p3RNpzcV3QpTHawTDpT4ABQ4KUVboBTGGWGA=;
        b=EAsNlzLtqXLF/Zyw5zyjr0J2ElQDMAdiII5ejzwu5mOOdXsw2E/2bPmpWtvgZzayfy
         I0NIqGILf5pRE4xsiVSkJg2Qh2ZmYXxnFDRSYVeM/0Hve0Bvp7MLgJ+ttly7tE2A/Wic
         QqU8fUmMrUFiFlLLzUuuMsNgzL1ga2VRiHQpIVPP4tNGhwVVw8TAZ9WdkiRl4zBuRvzF
         B0iMFE/6A2XoQPbh989NdPyWipXhd6zrVS/6FnU6sNhPrupfv7L4GkIMY5GOyaqjhVMx
         MidNXHt9reAY9qwzOogdEZZHZA2GIx0He9AJe50zFxeRCrYH2XoHeD5Hkn1vXpCHUVrB
         jEwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788357899; x=1788962699;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Why+id/p3RNpzcV3QpTHawTDpT4ABQ4KUVboBTGGWGA=;
        b=cpZce3LYtAED5GeXSZBtQpUQs7IGis9M4tyCeCKB9RmPoIr3sa4WCvDwubo+RqLetG
         QOXfJrDmfRuURYwtCQdve7oh+EiCaTq96uHj3D9fms94LkeVxOpfkFW7QAoHEBooQsUI
         J+aW8lb+9JtmBkHYAPzOmepCW+JIZ9xE49LWRvHRKkwMuSdoxV6s/5XAudukmh+2Xulq
         hQ/NRgW9UX41ttyUMttbUfaQU6pYaCzIkP2HV3z/zvQ9UubMJT9aSIRxe6Yrruh1GwEQ
         F2JRVcr0B8GzCcNmLArGQTD5xH8yuTJ6Zd/SqSpeWU11Zft//I4zwX6LyvkJU4AiP5U0
         2Ekw==
X-Forwarded-Encrypted: i=1; AKwUvBxC2o1Yr0bMEMrLd9e/jYA1MthwbHysgRrXjDs0YBTZpXGimJS/7YFG3y1ZBW1xbbb5DXVZZIIFuQ==@kvack.org
X-Gm-Message-State: AFuF++njAH6jQHTAA7lcMV9sWp7cNdVfAFwbmjfxDoKb1uQov8ODAEfn
	6LtRmY2sytT9h/J6u4I88WiF3vlccHO4B2cT5JBtyjFgW8Rs9RFYFtGHay5+120u1Q0=
X-Gm-Gg: AYBFou0/iolmtl8aNaU79zRn3I4PZQas8YUPkqJ1BMtPMkxe/HpI3zEcC+J0KXhEOnf
	jYSL0WThDTJfKgI/beTcc1gmDKcseaDRK8pqomzkisL2tjSy9ga0eqwhCubWufF7y9adQufVB/S
	gK9gpBesWwsIMClpou2SaWKXLxL5XTQA0ryZ5oj2Rj56NBU5TbT4s7LvCaonuF0cuP4e526dcyJ
	bL5tNpFpBTthfqqmWlnGI+2SuuwDZj3Nu8k+exd3TCgEHyvEd9c6qwI1fII1Z5VUETwY8SYTIWX
	WJqIDV88AR+PVf6w/Dg+xLnQ6+L1JVI4nVfE/n69J4OHaYlPOgupZD639/hDah2Jv6nz0E04Rok
	Yc/ooDxk0iokIdzof9XZdjyGpXGxgSlMoT/eInqQn4EGdk/nHoA0ZQEBTyYswI+dGK71tEBTuqU
	acEbqxhZS68cq9SDOo5EoYgCF/23uLpv4dO8XDqpGh7ujp6g8mBqZRH089jya/J1a46sp6Cy0Va
	t5vtaxzY43zCAnnwE2McB7tqBS7hPX6MAf7r2bxz8nl
X-Received: by 2002:a05:6214:b6a:b0:907:bfc0:781e with SMTP id 6a1803df08f44-90eca3d4856mr65248836d6.30.1788357899289;
        Wed, 02 Sep 2026 07:04:59 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec7ffdsm18809156d6.25.2026.09.02.07.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 07:04:58 -0700 (PDT)
Date: Wed, 2 Sep 2026 10:04:57 -0400
From: Gregory Price <gourry@gourry.net>
To: Liu Jing <liujing@cmss.chinamobile.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mempolicy: fix div-by-zero in alloc_pages_bulk_interleave
Message-ID: <apgrrQM5cFWRA4HR@gourry-fedora-PF4VCD3F>
References: <20260902090245.16411-1-liujing@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902090245.16411-1-liujing@cmss.chinamobile.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8866520006
X-Stat-Signature: xwb7bd8ptra9g4e3bbdkqqsw8cagsmtp
X-Rspam-User: 
X-HE-Tag: 1788357900-679157
X-HE-Meta: U2FsdGVkX18usQRaLrpKe/wRhlE6/GAXiaYLmZ/KpNZq9cyhPTwOtp9nlTxia7g9OH2qLyBAbDmYhGpDE6uIrMhgLLhz11DXqcN5YMBQozSbr49mSJX6CRyH3hMT8uzE8aoqiL5OKXOZ+EBd9Bcy2JTUyeKE/YBIUJvdj+MmntEfjy/tRtQ1o2XdjHNO1X6mge29V8cHOWo3U3Bydkg2mn5k45rf/y5ThK5vlFx2/WRCzpUgMipMJGozEZS50o7ojD1wX+6Qyzsbq9FbWaW8lSXT9YFsRNJ7bkvKJm9cE/1Wg1EzWaVyiHBpXP/qfRgPlaRGiy9Ox97EiWvwdep6JnxynUwIOFAklrFNqaalNH3dDj+TvmWABRgRoSUNbAMF7nHCSdTFAldikCHEn80nzWXgI0QXrWcCJsZmEJ0KGJ8xAELIXcUtXLjZamBAh/wBVjcRQxJmBy7oF8sm2CnCortIrI1vhBYjd6QIR5XHweOKc5NVNaLCH4kjSRVaMY7crxtHjfHwsZbkEd9U2lg5BjyaTRe5o4NdRT54fBq4H+DTxsYhQwSQ+9/0LJNMhaAFEOwFb0ziITy7aNCGVjFKgJX4S8K6NE6o2SOeV0a/3426ajwC8npxvf0QlfXkZ2am1GQOfYUx2eum04YtvYLZgQ1tmE+LeHIRywbBuzT2xX4KrhgG5l35vuiA82X0p1LWxXHdvAwf2CNOpuQ8UrWm9yblqzKcEEi7EXdeAicuj0bc5l+uxnVY4Lm23e9dqtu/6daswAKThfyETRrc9iTGxW2CV4SZuv53R6JEJrVmqSKgtP/qXGGnIU7TLzgtFApjYKJhonslKxR4mg/C4JTGHXNWFQtt6fR+27hIlRLFKrWX/M005iK5fn+DZV5JRQOhQwSP5fd6Nmo7tqxeKRVNZi+jBftIqaYoh8Ni+BnGS9i3NkjmKNPQG+QM2PmpmbrtP4dtvd9VMloUSOlAjeJ
 YPrV1qbF
 Hm2hcHAk1Snwm7N/QfEjog7CNhRD5DkAHVWP57ZtSfMHtRzNkY0g+4ch5WkXFpeyumu4qjuOZ042tO8WSQmN5DRGjiN3lFJ9md2hARBOT/DMpIvmRg35Aqb/8N5TM4t25deozjBedhEDKiCMLbAamkBXR2GzSANFKFkQClA/jyWcAJNPf5E2SqFW/AaXE0xAkd/hcU8z62VzSPwvXZMZG5d38v5Iey6YA4zxv3L/0nzOn0ZApnXq9TUf1KJxX04MX3AsE13KNY+N0vKtKwmWjQ/QuU+xeE9ePdxSK/KWzxzoouYOleB/dV9eb7Eall+gcQSBmNx8RMSvVYUzulRaOTCyjASfeFYvIwfdiC/3sghsvmvnwj4wMVrBUalVUQ2CAcwdupukJFVPoz3MV5P9FfzNKFSAlhe1VU/rXqN5pfK+xytY53J3NZmEuSlqMeDblKqOATbmCEhhLCZUbD9xpL4VxLyHtrsLMgGO2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 05:02:45PM +0800, Liu Jing wrote:
> In alloc_pages_bulk_interleave(), nodes_weight(pol->nodes) may return
> 0 if all nodes in the policy mask have been offlined at runtime. The
> subsequent division "nr_pages / nodes" triggers a divide-by-zero
> panic.
> 

now i'm positive this is LLM produced without understanding the
component.

A policy cannot have an empty nodemask, it can either
1) have no nodemask (default policy), or
2) be perceived as empty during a torn-read during a policy remap event

If you are running LLMs to search for surface level bugs and try to
hot-fix them without taking time to understand the underlying component,
please at least:

1) tell us that
2) generate reproducers

these "quick fixes" based on surface level observations are going to hide
real bugs and just degrade the overall state of the system.

> Add a zero check returning 0 (no pages allocated) when the nodemask
> is empty, consistent with the guard in
> alloc_pages_bulk_weighted_interleave().
> 
> Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
> ---
>  mm/mempolicy.c | 3 +++
>  1 file changed, 3 insertion(+), 0 deletion(-)
> 
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2600,6 +2600,9 @@
>  	unsigned long total_allocated = 0;
>  
>  	nodes = nodes_weight(pol->nodes);
> +	if (!nodes)
> +		return 0;
> +
>  	nr_pages_per_node = nr_pages / nodes;
>  	delta = nr_pages - nodes * nr_pages_per_node;
>  
> 
> --
> 2.43.0
> 
> 

