Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1670CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 06:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A398E0038; Fri, 24 Oct 2025 02:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D898E0002; Fri, 24 Oct 2025 02:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5A3D8E0038; Fri, 24 Oct 2025 02:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D464A8E0002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 02:50:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81083160D58
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:50:54 +0000 (UTC)
X-FDA: 84032085228.11.B9ECADE
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf17.hostedemail.com (Postfix) with ESMTP id 64AC540003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:50:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=b+s+tCLw;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761288652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cTVHW40Zh+ZcYW36HL4c/rT2R0nqusYCaOB5DUxW5hs=;
	b=pWW+4JikOBOBP/jVZiUAixsNeaoF1VyETad+2ICfggPpd9dYZslOqvOgOOgyL5gbRUEgxv
	ET1boeoVrS32zgvNocpNKtd2wxzM62vHa0PbwvsmEtI8oETMWRPtcWOGVhQCbgXSPceMqq
	hjc3hTp56Gb2I0ysTemcWb8w7ZzDtS4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=b+s+tCLw;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761288652; a=rsa-sha256;
	cv=none;
	b=wUI1svDbkpO856IE26dXbAGAnaWgl8DaiMuieWZ37RPK5KJgi1xrJdLawebX17D6iXDtAY
	WVllVW2D/teQW+/FLUcG/4s4x/boBrnGqwbzybKAig9d7lG7XAS/fa9vUV1+CJkib+K2qk
	Slmu0kCwFU1Hm5iNB2LBTg9LjxPzvJI=
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-471075c0a18so18757845e9.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 23:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761288651; x=1761893451; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cTVHW40Zh+ZcYW36HL4c/rT2R0nqusYCaOB5DUxW5hs=;
        b=b+s+tCLwyB7pkVXBOvL9OVHGo/Zib4FUtSJmx34N/Ybu8ter1Jv4oCOCmTYJppe1ld
         xkK585BzbKNfvJxEqarQpej/5oIH0i2nCgA5sr9geBvc9V4lnVZUnVuWdEE7lgKirLPr
         gSgXlZKqa5zSNCtKDb2IHEU/yBzqHoWcSohcNfWnToB/t1BGnChoida7buTtovR0MBej
         xYm+l9++tByN/YelOVVjK810WX7kPqhezdnZ6evxwOkIiwnaQ2LfJJB4Fzul/uREJZoM
         t68K6zzmm/6obx5A9PbO5RPwte9vyPVQiyQtVt5dvo1o43Io0qqfkQ+0aaqhde2QJdQz
         XOXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761288651; x=1761893451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cTVHW40Zh+ZcYW36HL4c/rT2R0nqusYCaOB5DUxW5hs=;
        b=rVOqhufkZG5xCcCrCjJrDz4AWUGuh6OolkuLnefkuUnVsowZmEsFF44RIbHxAv2Rfo
         Z0QSVuILQmIk4JxUUp7Zdzc3fXtTx87DS6EdZ3vLsypUlYafor5LBHUAwsz4GZFtQbJh
         1DIoJPAsNQNUD5zu7xRbaBCHFHlMCTJ4TQKOY1uhoxm4L3rtvJTjwETwOINv3b9vjqI8
         0JdxZ2O76kkD+TUX0DXi7Z02T2VAIhfbo6Ruv2KA8jFoNvWd/iPiTG/+EOcRgjf2Tnmy
         W3YGWQOxHJY/z9mQEuyv6zXKzWveaGXie5kbuyyNxvPaxDHON7/DKLJgETD6MODQhESC
         fxCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwpSoODBIoDWYhhK8cZMtJi/kj0mAtzo0zvx008LHWmZ6uowwrx7dOJPlx2KZEz3royOu/XDtG3Q==@kvack.org
X-Gm-Message-State: AOJu0YweA1BfTnkKLyP4zWAKQsnbmdFwLwUfHnIfKKUUwbt0UkwMKDee
	Q2LQXk6JRkNh/J0zNhqYCQ8Vr2kuNczgKMIsho1sNth3o8dhcf4iT5mY6vHOR+WCA2g=
X-Gm-Gg: ASbGncsX0wKXb0EGJ5a/rVU+7Hpvri7K5UOL8r/SYVoJylILWdDBvY1H40i0UjBOgtz
	sIwiI7ObRJTT2/YDCHGCtJ67diG/5GlhNk5YvJKu34mL0YeX33q2uo0OC9lwmLhEA5IzbCr5kp+
	p5+Krhj2Xw9D+zqwmB15H57/1TU7pGZeQokJOnZmfDMvSUKL5alU38MsqUvVK04itP6IRCqf+JS
	XrubP6HF/LEobFZzc1Jnb5iATxZXawjMNHsO3L4r6VgLg60YxQL7dW+EK+7ku+0U4Zo+BGmT5zh
	WkzKAc2tyIemNgoNpRPHLQGqIEORCbw4s16EKw6Vcmf85XEuYWBOy6qNZ6901piMPdbZhKhUyfc
	NmXtiIfjkVDm8ZK/ay9f774w9OgTpj+7QSuvP89TXwHzWQU1bT0zJrDVNF6+eJGQtD9oO4cGeDG
	HRg/8GkNQdAx0=
X-Google-Smtp-Source: AGHT+IG6AHY5dkgO0Q5DKGmqzwIVnALLho0wguGOP10IdFFJoATiZ5dycE/1wRVFF3VxetAiLmfC9Q==
X-Received: by 2002:a05:600c:3b03:b0:471:6f4:602a with SMTP id 5b1f17b1804b1-471179068f6mr191913555e9.23.1761288650660;
        Thu, 23 Oct 2025 23:50:50 -0700 (PDT)
Received: from localhost (109-81-19-73.rct.o2.cz. [109.81.19.73])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c427f685sm135434275e9.2.2025.10.23.23.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 23:50:50 -0700 (PDT)
Date: Fri, 24 Oct 2025 08:50:49 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: manually uninline __memcg_memory_event
Message-ID: <aPshyb6okUnRMZQL@tiehlicka>
References: <20251021234425.1885471-1-shakeel.butt@linux.dev>
 <aPorFhxQc7K5iLZc@tiehlicka>
 <jnzfiyojjwvrj3eemqmpigfyjxucdqe44fjy36nxkly6urtn7u@a6pfcppla3r6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jnzfiyojjwvrj3eemqmpigfyjxucdqe44fjy36nxkly6urtn7u@a6pfcppla3r6>
X-Rspamd-Queue-Id: 64AC540003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: d8x6d4tt8ojgqfgtmyypwtdxjnkyekcp
X-HE-Tag: 1761288652-630570
X-HE-Meta: U2FsdGVkX1+IvkUVohMzl4EaBS9Risif8c7vxzBWSMTYIIDEMaNUjLkg1/zIsiWCtl9ZDvQwEvGjWHVk2QplaoITC4VWUzXwpfjGX8zrVD5bPZxaTcSLyZ/UmENRHR3Y6WpG1gcSPAYHg/vxV2Nbnf9dnpmyE/LpNvkP8JYh6NJmwkhyBol6sym/YN0SP4sf5Rn7lQkKKgN1KFVnCfss/feFggKsHSfTrARqWHnY4cA4SxE5Azg2K+5hBWPJfBEETns/M+lN+cmU5zF6+jIPk6csAvmaisU++OflLYmps1u06zEacRq8obdwlntYpiEoEut90fPzA6BceiVKIs9uzRl/dsCYEK9G7zkF6/EHegdgRFzSSV7xZd/wP8Ts6jZal0Sokbrju7S90HBOJLcJ+C2OzgJewvYrcnVWmjBQavHIar9FzdLzD5ZuP1hAXbzooTxrUCwjRodmUbp5Qawid692ZrP5JmhAFTieFlLfGZV7bysPMqmwfD1m4ejV7Q4tqRZrJ0IrTaGu3ZIDRDcCxZlE2K/6nW/c5ATCWUA+1KHxWueS66PKpYDkDLVdXw1WQ7DdF1aiIbRYg+n6hoeAQ9e8SwBqb3vA/NPGGsAmUC/y5TQPZlWbwXTx/Fg5dMWqx4F6jNq7GnAAINUNgGmE+nRmOjjbxu5LundrTdG6oCmC5AQJja4eVObQrCKPS/bOI8R4IqA0ATqguc6kcMTWoZ5AhjUMb2a2mIjy6d0sbhe6iuoPmOEY2F5BK3T5vwjuFTkJJjbk9Dg86lGcWQdhD83XCVH/B1yxZM6w/Nqa5V9ltNYfvPB7RLgqxkzRajuPoqqU4WWi2VnjqXVHQRVIwHkeeR6yoEi8i4oMjs8LM/znk2+N+7va3h+ouji1l9kEmxgv85S1QfCizGlREJjT5RYf7vSm6oM49t3o05D+ub/uWeGX6C427apXELvoS0AO1qzsH/PsZ4WP0muWs7N
 Y8T5Hns0
 0+FtrKd1p1ke+CUHjWXNgJr2eXN++Hdy3OxJEsC60TX/bGud+o1PntgF9Ezpmlr+o58FmEEBySdg5V43vVYZn+xr0so2faWquUHrA7z0SOpW+JAHs5khIRW/xPu4fhq4WhtPoKYmJx+GP/gNk+p8uuRJUXGDpTfsMn5ROk+6P+LgexN5ndvJYmyiGuBkjEF+vqs0DpapkaFi+Wfd4Zz9eDlSRQ4jAFHSIK2j8SIqIL+4rRzjNnuew84k5zpCWzXntX5vCO1S4989NiXE6IKvqQ6W1YhgKG637QPsAbiXA29PeKDi17XRK8O7dlwDDCaOzu7THKpHldbyRU2HBRrkgAc/vTJBJEBx4IwANl8JNNO9frFOg+hcU8Y61T5Bas38zHBr5CmS8N8GOpZZecTiDix1ePg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 23-10-25 14:35:05, Shakeel Butt wrote:
> On Thu, Oct 23, 2025 at 03:18:14PM +0200, Michal Hocko wrote:
[...]
> > As the only user is in tree should we make that EXPORT_SYMBOL_GPL
> > instead?
> 
> I just followed the file convention i.e. all other exports in
> memcontrol.c are like that. I would keep this as is unless you have
> strong opinion otherwise.

OK

-- 
Michal Hocko
SUSE Labs

