Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E422410BA43D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CA056B009E; Fri, 27 Mar 2026 04:27:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A656B009F; Fri, 27 Mar 2026 04:27:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7326B00A7; Fri, 27 Mar 2026 04:27:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DDBD6B009E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:27:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE5CDE1686
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:27:21 +0000 (UTC)
X-FDA: 84591163482.22.FC77B69
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id E6BFA14000D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:27:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OJjWBVqX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774600040; a=rsa-sha256;
	cv=none;
	b=ijlPtFMUiPuP8z2Iuh8EwwxvcZtzSceg3nKHHYsjsQCFs0whGr6WKlBg5foNKseslJTub+
	BpLSjWTkMIavX06RkhP8sDESugZ+MignC7lruyX1o5X5aMHKxc+3G0E0lkFEimuxwms9Au
	XjdG16XLT4CTXRksXIdX+MoJxP4TSoY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OJjWBVqX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774600039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zFEQbGpayE+Pr5tEfSyFKldUTAWitnPQ4DLSjCOmEc=;
	b=DyJTlwjTIM1cl2zhcvPwmNDGTB9VRd3jmFHPuaLviaj2PQ3U+mhaMP8/X8I/hkKjE1a7eI
	WK2T/p2sVRk7LH4mzwhfWJ0Q7+q466y0m6lpXSgdESmAJimrqmi8KmFvggrGx/YjwW4DvD
	n1/+2vzYNyvCkzCX64AD/pZ2cZvm8SU=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b04e6a989eso11732085ad.3
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774600039; x=1775204839; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5zFEQbGpayE+Pr5tEfSyFKldUTAWitnPQ4DLSjCOmEc=;
        b=OJjWBVqXzf6ZWzcD74kvMS2rqQZ9GbOQeuSB9AR8P8+9i5mL1tpFigZzyJttJ+WBLH
         7yLEgJN6AcX0ESDYBb0YvtrNAeUJ6japm4YTZhhdVfPepNY52iI3No4OxrZvipcZ9LDD
         Aqvy1t7stuVfbb6gLxQzd5f8illosctffG7g0XH6jdvV60MRe49QWIh6wjzdDVClWIzs
         McHoeWxJOENEAJW5tpPwYI8U3WMw5uc2eLBR89b9MH5OZ7VYKM3+GIMdqubMNyXsVUWZ
         klX/zk8nZ6d5iYV2QoEJI3jGbvX9YloYr/HcRdlA6MNXg30yhW1wc0iVk/GVqU7qx7Id
         ZoAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774600039; x=1775204839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5zFEQbGpayE+Pr5tEfSyFKldUTAWitnPQ4DLSjCOmEc=;
        b=bOHKgs7HDC+dYoHjl4/wgKCzIOBOx7BcrfG7Mcl3RTLZdpjUpnHLjt2uX93wC17TEL
         uiZ0+s8rdo4UyK+z1QyDnEat5HP7UpZhjAiKvxcY2yDLskDz9x1PgoCCPmuI8gr6iKfh
         APKNa2IWRUh2jXdLxU1TOauLkmdLaR8O9cbJTzM6qM7GTyhI2I+RUK1/U3olMfSFuAxD
         OnUrZOxdSE4QlplEEClI6Y1nj517ckr6z9aDb+lTh+OifgOO4yZeoKYKpx43uA0nBJry
         8z1Ow9Omkl2I+DlTDd069/3xYNAu+5bzv55iLrXOanzyQIqfhX3lXIAXIE06Qm9/m/9X
         KeOA==
X-Forwarded-Encrypted: i=1; AJvYcCXuR/X65SKyNa4z+gCPDHWzlHPgNr1YNoSWb/Sm9LhJd2chKvMRWAhWiC5kl8fj7cIhyuY5xerfOw==@kvack.org
X-Gm-Message-State: AOJu0YyD7hUuT++MEtPIYXWzaGqSuFL8Nx0sgoHltnN8d1fVDpWs3cD0
	V5JPae/fGtyTNW7AiFvr67zji3d1ak/OSTXReCOevDZaIYYxucGOWBw3
X-Gm-Gg: ATEYQzwvq19AaCtTrUw5Hs5QSiDiYJiQnw/v0GbQbsnBwYVEsxjEYTc4vGamDVF8jny
	ReUpVQN0WqiXusjqr5nk5Zd1KTOlz+jZyADaBQGMYao0FbUaTO9eKJfeQNrb5GqQQjCL6aThi2y
	Sa49WOTpwiQn4xP1KMR3g5z83h1s0mvn3wcV0/jiTahoktnhvL0Kjkxq+Ktqe+l383AIWuJcU6p
	bB2qf6Uyt58UCMGEuglzTysRB6w/SBkfBUZW3rtglhSnR3M9CvnIC/YQOpkHjwiowdbkcj6d8Ky
	+HjH8MT6vn43rY11cYhXNJphwVvJSm2FmZQuesvh+asiWYYga3E5Ldmqk9XjkFR3I7yATGcwuaF
	DIeYnqPHWlvE4jvD8LbI8tnac5AW6HiG0KnZR0aEJe/vw6Jyhgkoyk6dqv0374xikrV5/qKRHym
	agkdWOlUEb5G1sjcX4Tobbuj30pZuIZnCn2RFutA==
X-Received: by 2002:a17:903:46cd:b0:2ae:8253:1452 with SMTP id d9443c01a7336-2b0cdc1f89bmr19842335ad.11.1774600038586;
        Fri, 27 Mar 2026 01:27:18 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc8a89basm53150415ad.56.2026.03.27.01.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 01:27:17 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: (sashiko review) [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Fri, 27 Mar 2026 16:27:14 +0800
Message-ID: <20260327082714.83540-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327081131.80608-1-aethernet65535@gmail.com>
References: <20260327081131.80608-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E6BFA14000D
X-Stat-Signature: wjjs33iw95cy3drgb4fkbkz89xqhc17k
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774600039-927712
X-HE-Meta: U2FsdGVkX1/lc83yqGeVtY06hg0ijl1u0AvGPeYUmJb9hBjk7YczsKj46Yx4VgSbMRMKRXoTWwITbwurukfSk8YTpbV7s3gjaIePk9r5904wzSfIOIRv0GQFfUHliCwjWJx3q8Y2sQBQ+DWX2HfTrpyf0yuV8EF4M0KNH9H+iGssIstTaMLIhu1A0VVX1LBuK/9iQbFPbdTZJ0KkrtHWNaHxfsaxOFv8pYiCR8a193Xu/DFwPc3xp98WWcdAp32SzcipSUcV+en11EwE8KuECxREBPb0yj1O2U+1AD7m8g7Iwq1w26w3g0pB0/5Qe+4W4+DEC5b1nKEdIM6/RIp97FZmPHn2MMu3L0ZYMVWswRMT9KycFQsEQpyrdhVHA3PPNM48I2zCCru/STxh/te43UocdGis09xOh1WxRf+cqYDNiDt0mw2Jd7W3V/Q470d4LfBTjtJinn/guxx96hJiJWHjhBNxfKQrZeTLFOl5/ilmKrn9lWbIEzR1l6dklS/G+M+kgTyTvmzYIwpJsWKYRUAGiINt8awdU8UzKyIbau1atNThoY5/UorzWSk1tijZL/1qAQHHpnbIRSbVF0pJag/oeqRaB7VNQBOhStSCoqoDHuGyev3RB3dbJHruDy12l62LVlvVHvhec9x802CG6vrqJzGsP/5j83M7Uxn6ojoVfdf0ezJA6ZGsflIzSG0yQRAYje7VOd1M32no4+yM+d729RLAkonkuMg4hBtgcwyY+K52Nub8WlCJg+xCVRifeeUI0Up9Tsc4l2kiMxyTMrx2+PUNN69WxkhBNV5nHMNm/6EJuAFWKINUlbshc7KJUhxYMq2o9/IbTZ7GpKt37yhejtd2GIJ11w2unX+QIwIKnZU860N0QUAoYESFL5PdJsskAC8HSXkReVQZTmKI8u7Rw0Dq6+MzstDkoK7U6AymvA+JnXxEFbn8lr2f74w6JqYNAFlI44LNchbS73n
 lc1FIQOJ
 fb6mIucPjW43r1y+1kxx14sVldru489nl86F/2dfwT4Z6O/iTXGNd6+XLOqrzFBP3tZQmg+aIjmbymncAgeUDNp6VSBtGa6bPO8SCjb3PXAM1yHUwraIKSaQ8JEL/Z/ZTTV0pOA96ttKm8pGOmAchsmH6elix51zFhd6qmoBlNDxNBFA+RbBjkSh9jalgpV7BYq6TYMFk3QDEHccHafQR9CVYmikXX4Yf86lN2heF1+2e/vvSaBinbnE6RKzbTt4CTF0LHANLbrCKAlkVb93miaSGl/UfgPX3mkYXUfm6V036sEo7VWxNlGCbKd4gB/qEstBlDzQqHKzBuZkU1lUM8k9wbWH3W8XBmEns4xnXxVPJjfSz0XJwSNlThW98xzUhKO5+pQeoANCjSN4rJHorqZddAQ/MM+/9O5w/7k73y0sdmUKNh+FsoEWpl/KKe10nPYfSwtrndmfGpRnuVkPTUxZSqBYSg9nc40eJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> [...]
> > @@ -1330,6 +1330,8 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
> >  	dst->maybe_corrupted = true;
> >  	if (!is_power_of_2(src->min_region_sz))
> >  		return -EINVAL;
> > +	if (!src->addr_unit || !is_power_of_2(src->addr_unit))
> 
> This isn't a bug, but is the !src->addr_unit check needed here?
> 
> Looking at is_power_of_2(), it already evaluates to false for an input
> of zero, so the compound condition could perhaps be simplified to just
> !is_power_of_2(src->addr_unit).

You are right. Futhermore, addr_unit_store() also prevents 'addr_unit'
from being 0.

Best regards,
Rui Yan

