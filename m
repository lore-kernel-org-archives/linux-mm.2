Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5CAFCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 15:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D53C8E0007; Tue, 16 Sep 2025 11:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486048E0002; Tue, 16 Sep 2025 11:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2EE8E0007; Tue, 16 Sep 2025 11:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA558E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:23:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2B3114010C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:23:18 +0000 (UTC)
X-FDA: 83895482076.28.26DB560
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id B163F14000B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:23:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XqIE64E4;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758036196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nuSVLC68nX8Z52Tryz9BLSU3qdeaRF6+fP5+6ZIUdA=;
	b=lxIhTMA5iGdBVRGLCUMejCuiRq/oaOFVJ2KfqeTSMjJUgJZcO4ut5EMw7y56GTmMWifUBC
	e/Vkscb6vliSeLWypcCfSX9rxTmhUYTXgXlhaK8c2mpPo/g+b2yGz2ce7fU04eWz9Y+Y60
	W/e8K5bU04KEv0JxtPEqVYD2wKBRjWo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XqIE64E4;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758036196; a=rsa-sha256;
	cv=none;
	b=cmjtv5l0UssR6QpxsrIm81frJQPeX0DUmbdyfFso2daBrZYzZ2qoXenlOfjbiG2ky5is07
	XecebChK6rb2sjsXgyzRJhxC41NRZdmiBIZRZy2FPwpXKoh9mRV1TT0nQgiX4p5+2TC1z7
	mbbeGoHpDOUdpQB72koy1rbltUQV8Nk=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-336b88c5362so56856741fa.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758036195; x=1758640995; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/nuSVLC68nX8Z52Tryz9BLSU3qdeaRF6+fP5+6ZIUdA=;
        b=XqIE64E43HQsIrFqrxlpqYkvMEL+kPPmZeRfoDtrKsbkbiNQ+rfoWTgDTEzoLPif4D
         790l6weHkBTJIk1Gtx3tQEWZoLimi2SBPRa7FKjFI2HYw0sggpYJAiLBUhpmt+KCPvoI
         2+/8Uxd60PNiDOQAQkZIVi63sXtU5yxMW4KGplydPq8uekf4Z4tO5AXo2taK/8IINTDf
         J6yhi8ZexlQylSIMOxgHKEg8NN0A1/DuOYkVyuhhWYfEeKlkT9plJYiGAaS86UIrx65D
         gOVd/vSPMWxvntVstX8jQhUmbWmqCD0P8jB4CsXBn7k/8fYfeROGb3Q8J3YomBbQ9NA3
         Mtdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758036195; x=1758640995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/nuSVLC68nX8Z52Tryz9BLSU3qdeaRF6+fP5+6ZIUdA=;
        b=wmkGTWYxn9Us3WfiWhVAN2GnN6R14OdOD53kXnUOa4Jg/t/TXU/6ERlg0d9v+0TjVk
         +16LrrYYBlbs1FBCbLjxZADu9GiQfwAphIM4cOX+wuXsOlpWEej7lLevIDptWc8lF9ue
         vQU26jRB7tbn+CYxSvrswQYboU6NN8lWFbJ3rer3ZScShFIP1kuicRorNYpOVsqDyItj
         gkZU16q0DOqvoqvMu43Stox/C0q+Ct3xG6Viu2HC1x/5fS5owZm79iI+WxS84arlt8Cf
         UF8M/+nPMRIjdJQqD3nQwI38K2ot7HqP6jI1yl6OjwgE4eq2Mt5i50Ez0swq3bvhx/UL
         Wh0A==
X-Forwarded-Encrypted: i=1; AJvYcCXtpKftCcfxp2BmzwuHqBjmuooPhUMIBxRoBbRvdsa1hhLND8+pS9b9Ni9lYTqJ8+ermINsscCCwA==@kvack.org
X-Gm-Message-State: AOJu0YyzBpvW4f7YHS/zDLr0EUO938h4IA3N995vvdPzy1XBX/iBrX3Y
	soXeEsYAV+rffnwGZBKLz8PNN0JsTe4B8GViYcpOu3FJXICVHVBlIqM+
X-Gm-Gg: ASbGncve9SjLtRMZcg4GMnym7MK52GEFxWfD7/EuahWxMtb53QMDKgyg3hygvDGlrUy
	Lj+Rljn1sQ9N87q9+Mri7m8xAShRPFLncHJsZ5L7Mmuyoo7NsZK2TDv/5gJKNEkumOZ0bgkbLk7
	WmkKuGtSG8aPIhAw8V8SufBW64IdZ6fXDd0wTzuTMlXREcVo+UWdwloY/g6dfLdvyvZm0Pkr2xE
	vbk0Zg/qhQwdhkPkzlsKnSiyhtaZryPq3c8hoXLKL7FG4mImijjw94n4MvIAD59HOMH1dLJEXUV
	DWDz1eQ4LWdfMdq2DDFiddhMzA8zqBxYsqOu46wipciZ/t57mSdM0/OiFJtIz2hOAw==
X-Google-Smtp-Source: AGHT+IHB4r5cBNsmY9gvwcEAPOYB1cQlVCkB6XSDMxPrU8k2LqqAODvmkpEHD11QK026BXiH3iN/YQ==
X-Received: by 2002:a05:651c:3245:20b0:336:e176:cd3c with SMTP id 38308e7fff4ca-351403ed5aamr39716711fa.38.1758036194420;
        Tue, 16 Sep 2025 08:23:14 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-350a153c10fsm31333581fa.3.2025.09.16.08.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 08:23:13 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 16 Sep 2025 17:23:12 +0200
To: Michal Hocko <mhocko@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 09/10] mm: Skip might_alloc() warnings when
 PF_MEMALLOC is set
Message-ID: <aMmA4Fnvpd9Szyq2@milan>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-10-urezki@gmail.com>
 <aMhKAnO1MmkKHTO-@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMhKAnO1MmkKHTO-@tiehlicka>
X-Rspamd-Queue-Id: B163F14000B
X-Rspamd-Server: rspam05
X-Stat-Signature: pdky1tu9sg4qnunyj43trkq5fe9amxj6
X-Rspam-User: 
X-HE-Tag: 1758036196-625336
X-HE-Meta: U2FsdGVkX1+gDwhlEccPuOmVy999h1fxlIGBQNZxLIe2838QpI+LmaAChlzQqcx3DkXZnOTNkD3YY34MjZZxKM/PgDIM0IZf9+3HsrtmRP46Tr9nUvfimaP+psULhwBISEi7MLTB3+ocBLvcwwiCL6yOvMUlywyZUejQS0tis1pJ+ATfS5PhucVCQOHIPMqT4bu888mq4TkaZSs/L+N27lUgpkxCRyZYtEytSaxbkiHto10G2MfgbDTQXAGld8OiusesrarAReYLWLfX7uMmISVuVjCkR2gZ1eTZrG6fTK0kPhJSw8EKx+m6lOR5ckdVcwUFEFk6/BQFm8Ewoqq0Bml9aiunZfPeP77iPqOEabUxmMv9BJBD66ne5VYPrfRksi9V09qTOzZAkwBkWk3CnXUEoiQdSCWFokCL4CpP2vBM8AOPNR0EmbC5QB3d5DRWGPPp0B1Y66XX50uZwGnRTvjfkrO1HgnXnP+2XbJE4w6Cv0PjZBv2aHKhitgPBNAO9pcHvRaWzKcVRToBlPd35Ia+6JHj4/nYIVc00nnY4J6V0FT46gIPMa31/7dJnuIuuRFTq7FKQ+7FWIFQMXBMkAnlpYUwFnunrEpqqZ1ldHG3N5RU+/PyxFP5sAI+gJ3X3eqhNZIblkshYrsnBu3Jbx1bG+lRDAo5ST4QowdMe7dVBPU0PtUZE5mhn2re7rUbR2ze6x4/KCnx/vn2gXaIVMjuZ+gZweBagKzuUaPkuo2mIXiLcieVg0490c/bbQDtqPEzkhSfRrSzSPf4IpHEMgLBbr+mHVMNQ5FnvGYU148mDqHiU6VN9SIoq118Y1t/PLf/jxOC2yKsWKhAEfjIsp9Bp8Z0YH5yuBBoX+sm4RgwLEAQTW+LbW4mdSZqvAhYbULLeCOs9gqBs0cp/4y2GucZ7S15oI56bZxYXTm1aYwqFQZt0Li2TSkIMyTvtr5D8GJ2KfPllnjNaYxqa7T
 4Fv9yWkm
 s8DtV6fq6G7niHO8X7xfSKE4hG9fP6y9UK3FaaAgMvLADraL3Vh1CfsaAvNaIMgVEnLrELNdlkwdBeJ4CntEoLiWTGYaPn2GbA7wt62yzjY99IwOiq8uKQWAydfNKYYPyC+zqTP9nL5AmbGo53IZMuLk/8qqIWehsZDhtT+7xjGPLQNMlKJMAw6fwIrDEmcmY4uXBwvxxfbKovFk0rLQ4rpebZ+YEVObO0/sb/9bPCK7QFy4njVCjFFqM7cey7+bHJLInuNp4lcI76qb3I+i1qlRxQ6yQTbOo76bG8Y2yeCjFvknbG+KKmeFIojOb4nYiosoCfYZIRNi2HtxbamLIfz1R5Cn7I0R6MDKXHNAeEeSXNHI34J+qWT7yKgk1OQb61fdPb/YnPx+2T7MgHB8dDJrcDNSWlfDvs8Ewj6r3/keUrQXnSZcNGKtiqBQWRrjfar5aoiK+SyFp/GftdhnI4H/P20wDdpYkVVO+ACh2UB57EaGyZXCqCegkk9HWuqNf/C2GsOC/KblhqLywBal9adIXrG/xiS7MGYjhzl4uPQ642ekz2wM6By/wgz2HUzIdEJ09
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 07:16:50PM +0200, Michal Hocko wrote:
> On Mon 15-09-25 15:40:39, Uladzislau Rezki wrote:
> > might_alloc() catches invalid blocking allocations in contexts
> > where sleeping is not allowed.
> > 
> > However when PF_MEMALLOC is set, the page allocator already skips
> > reclaim and other blocking paths. In such cases, a blocking gfp_mask
> > does not actually lead to blocking, so triggering might_alloc() splats
> > is misleading.
> > 
> > Adjust might_alloc() to skip warnings when the current task has
> > PF_MEMALLOC set, matching the allocator's actual blocking behaviour.
> > 
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> I would probably just bail out early for PF_MEMALLOC to not meddle with
> might_sleep_if condition as it seems to read better but I do not insist.
> Acked-by: Michal Hocko <mhocko@suse.com>
>
Thank you, i will apply it and place the check into separate "if"
condition.

--
Uladzislau Rezki

