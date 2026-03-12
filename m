Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 886C9FED2C3
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 03:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D139D6B0088; Wed, 11 Mar 2026 23:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE2A6B0089; Wed, 11 Mar 2026 23:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B96A86B008A; Wed, 11 Mar 2026 23:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ACEA46B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:31:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47FB4BAB6D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:31:18 +0000 (UTC)
X-FDA: 84535985436.10.9045651
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	by imf29.hostedemail.com (Postfix) with ESMTP id 76130120004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:31:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WLd3olhz;
	spf=pass (imf29.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773286276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AL8nEFmYbr0Vo7ZxbIIIA5WrHWg/oaxX1oMLgJ1GQQU=;
	b=ol9PKSWhgo52yj+1Xv4Mpv1mC7q9pMa1HMTxyPcPXmtgH11ZpHRLFjE/y2wUmRUVEge9Al
	hsM6DYV60BLNpXdy5PxxT9LJUnrRnYV0u7N31e5bS4i7NNtkx0R3w2x6RrWDXLjvzNnjU/
	FLzZsTdgEnh/M7Is1+Y5uJHaX4poYOE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WLd3olhz;
	spf=pass (imf29.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773286276; a=rsa-sha256;
	cv=none;
	b=scS0jw1c0XmZJAQLvaOyhTKN4naT4M4kwbA18v4lmYSv88ndZc9LdVjfg88Pm55B3DQTFO
	vEe+Idqjg/mc1G2nz8ay08o8WGjmFFgaRh69GH1T/fcFRZLJTTRMbWNVI9LJcd3A0fIeTL
	O1llmiCJyteZlfzJ11mzAM1OVirkGZ4=
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-c2af7d09533so380300a12.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773286275; x=1773891075; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AL8nEFmYbr0Vo7ZxbIIIA5WrHWg/oaxX1oMLgJ1GQQU=;
        b=WLd3olhzXMwCr4y7mCTCwVBxK9f5y6ffe2sdNgJxdCXdiusv/S5Et0l0NTQM+2WQXe
         zOU/fPussytenY0+cOxhcYY5Mvmm+6wddRy/KBanyMNRprehBnG0QqqYyjjYhsz9x54p
         AyJyA/ZjPkQajGUMTZZwVr4esVF8ucxotaFyBFy9m6A0xXwTez4zm46ZweXvzDAvAJJy
         4iJmxG40GHjYyD8E9Wd86JsGHoUDJtgr2PjT/vdzLo5kBDVqpvEUNHcAVPFJzd8/Ulc8
         JizyfWGUdBatEiYF0JimJ95Ngf2q8KCgtJxWcdDUdzXQkdJN7auKv/FYEKCc7qBgvw6J
         Eu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773286275; x=1773891075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AL8nEFmYbr0Vo7ZxbIIIA5WrHWg/oaxX1oMLgJ1GQQU=;
        b=CNkAmpfvTt6Xg7TbufaVxbnnSA/VzpcenLlJr70wEMeh2LdJQ1DTmyOT1PQHdJleqR
         u1yCHq9cDodBep/Yl++p6NQHTEp4aAsYEsrT4gonDMjGuut9FHkiEnxiadWFu68ndPuk
         ju7M0qdo/pO281ChZymqKLWgJRgkgKkrzWPAPECXrzVy4poT1oomWAhlh0vwtDkOSQtK
         5J1BI+j6/sjfWUa5yp5Gx4AZfAc4yj9NRFDJR4IuzEN2f7EAbWv3985WPr94mmAc/GWQ
         T+k7POiwAe0Ea4pirdGotxVKN7TlbxyTWSV/7EfuXSPZVTgvIZTzsPAQV3MaVp269bmZ
         P0Sg==
X-Forwarded-Encrypted: i=1; AJvYcCW3Yqjub3OS9NuflArTOx31DI3BdMViDNRWJxfB3FPfoPTamnyu66naR8Zboq/xH1v8fV3i/fDU1w==@kvack.org
X-Gm-Message-State: AOJu0YwsvME/ZSbacX3KKMh84RLxFw+0fCCuO2dZa4Q1BFVtk+m42nDx
	hCN4J1Xa2wVnaFc6mUV5let3F/glXcD8IkZTZxgZIRMmMBvvphlu0AJ+
X-Gm-Gg: ATEYQzz50c++fLO0nNJ0tVmUFsbsFanV0BivVHHTwUSwXIO/mGq4yr29v2RX+fLZ2cb
	1/hI3DHpUOvv+zpsHXlkjI3q6fEaxJZOQNIrMqZ7O79sPviJkM3Ym0rvt237S8gpIAY7O/9+mfJ
	vKk0l2RcX0xe5NqoPgG69ESpXHKJLpdrnBFLl3wdZDACd6YVq4KfDLtAR69IuZv+jumMx54rH42
	J2TRvxVoTDFOwzplVFGXCg9T2es2Q1IfrBi3ADzxtNGHMUMyVmgmUp2ld0u4BvG+WjAmblggDiN
	BsOWjkroU91MRPtt6L6WydTyQ7b1+fYUO82mG9N/b/nFKA4+rIPPHqeaMQNf2SO/mF+cOXae4wk
	GIzTi79JexI78HWuCXcHmXgkzYZuApNW9j/LIQoz1SUp14LBifww8EKKvsMylswGKUPvIQpGnvF
	J5xYdUVetmo93re6fRRHQuGiXkyt6++Vz91yMbWrLQ3iU+2+S4uA==
X-Received: by 2002:a05:6a20:9183:b0:398:8321:7499 with SMTP id adf61e73a8af0-398c60b41camr4402926637.37.1773286275256;
        Wed, 11 Mar 2026 20:31:15 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.213])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73cdf0e498sm3542770a12.3.2026.03.11.20.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 20:31:14 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: vbabka@kernel.org
Cc: akpm@linux-foundation.org,
	cl@gentwo.org,
	hao.li@linux.dev,
	harry.yoo@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	wangqing7171@gmail.com
Subject: Re: [PATCH] slab: remove alloc_full_sheaf()
Date: Thu, 12 Mar 2026 11:31:05 +0800
Message-Id: <20260312033105.593829-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260311-b4-slab-remove-alloc_full_sheaf-v1-1-c4c5bb587ae5@kernel.org>
References: <20260311-b4-slab-remove-alloc_full_sheaf-v1-1-c4c5bb587ae5@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 76130120004
X-Stat-Signature: ydn7oz716m537iwuqi637hda8pny4pdz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773286276-809788
X-HE-Meta: U2FsdGVkX1/U2ojcqRza3XTNAU6Tv6xtyQzqyhJK3xC9bDWzuLpGf0RZyswFMULVdWNoTUVTzEiztH7S3gZE3IqWtRIoM4r8Cu2wyTviOMD4Mm1hTHJbViUp9M/G/RJlKg+61jQUIag82UroHvHevRUW2vegX6jhcYFN5hu+c8AXciiBbFj6teAIog+dWj/47qFIRNJlMvam73WERhqRtGXPSry2ScY4jwqrdOYTcImBBAo3IEv3raHvQ9pDpLbJIjVRdFRQ1UmOiapWjhdXoGxuUojx/WLj7D6/7znolF5riFNlyuo077IPBPdmhSRpOa9wc8S3Z9GCg+JolPCO2q7tIVLY3yZd+Eyz2TOXc6Nn6FcEUYRvPKYA6I3lHY4TyQNBqLvMVWvuHeDMVjjcix11wF39OjnN4SWNc0U1qm4CbblyTZQYk3+Wwu/rPUT/XtthKTIlZOOu5iTD0samsLUAEz405BFoISLjiXCadzomZ9e06iMVtTpEZS8RvVVO8MYBD2K4j+/RnpVaZzXx67JEEtpt4Xasb2uguAIVB1iZBgmtSSQ5UIIL6hs8VbPBdwWsfVZaVt+SBeIteIAtaeJmcPAp5r0RWOPz28j3M23OJtpHpIENlxdkw7wiCxfs5GwxX8k7SUsthAYdB/edepMnJW69En3SweCCEKrMkuSYJUwa6+UIQXc4f00jWC52E7rVUTOuKY67IMy74wz1z+OJ5om2pyX4X6ydeO0MFRPC/E/l6A9vt8Pkp4cIdI9lvgCRr1D+j2USgoFpNX02m4/PW+j8eEuLhpcpCJetuz8QV7EdXlgUCyq2yIL0Kp+Y4w7i2zT2NUofFdtzGl5kUGUayLpuWKRHqwMhsG35F9f1hD1l8URGNzgQVyCp0yGIrJLYr9xll2udZgwTJr6VKudoK/GqYhzMnolu9zdet+teDS1usualGE8+UMT3R/ih1MAqXyCMCMvYlktQ8k6
 dGZq8Aiu
 2V44IWg8lgk9I9iYvZ8Sch3G41Yx4BH02a6VYpVkdR73ncrUCVV/1QsBh2Mrx9E9EKTIe9dKcKG5/zYHrjzAhOMGiN7HoOyahjNXyk6RRFjoVDrRaEXGkWLgu7rnZNKL1Dwao9Q3RuMMl/JxJMGCMbgfn1206i70DmcJyxiXx8BvTyNxJ4VJki03gP8J89iDwQc4YUb4U7/SlzwnnfrQACrVdR0u7VKzSF8RPbje+gJTKMzSnBRhlENK1KcSx6Lv4BMdqcQM9r13YHSTElEPotc9NQzgqvNb0UrD30iSCDgkI6wg8spalrnqnRMQOj/5QnJffP9rydG9waFQlokzVGudHtyUsjOrT08rGxalM95HHjZFQbXVFseBAzRsA1gqk49E/GVPZIlwtVFW3U9ZCpsVFPCfmrk1UhJPJzZbKHNyojcX5rpAiwCMT2e9ZRmTsQsp6WwI7z7jhz9poPCy8n4ZSB33gOSqx6VNKeHVQK4UzxCnh+7XaS9/byLgrE4vauWtKvqQZdB47NTS9LFAP7rj+ZEbC6nqNtpRk+29w1hXgDTSHFhMwojw7Jo+MJnRjt84T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 at 02:22, "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> -	if (!full)
> +	if (refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
> +		/*
> +		 * we must be very low on memory so don't bother
> +		 * with the barn
> +		 */
> +		sheaf_flush_unused(s, empty);
> +		free_empty_sheaf(s, empty);
> +
>  		return NULL;
> +	}
> +
> +	full = empty;
> +	empty = NULL;

'empty = NULL' is meaningless since 'empty' is not used after here.

>  
>  	if (!local_trylock(&s->cpu_sheaves->lock))
>  		goto barn_put;
>  	pcs = this_cpu_ptr(s->cpu_sheaves);
>  
>  	/*
> -	 * If we are returning empty sheaf, we either got it from the
> -	 * barn or had to allocate one. If we are returning a full
> -	 * sheaf, it's due to racing or being migrated to a different
> -	 * cpu. Breaching the barn's sheaf limits should be thus rare
> -	 * enough so just ignore them to simplify the recovery.
> +	 * If we put any empty or full sheaf to the barn below, it's due to
> +	 * racing or being migrated to a different cpu. Breaching the barn's
> +	 * sheaf limits should be thus rare enough so just ignore them to
> +	 * simplify the recovery.
>  	 */
>  
>  	if (pcs->main->size == 0) {

LGTM.

Reviewed-by: Qing Wang <wangqing7171@gmail.com>

--
Cheers,
Qing

