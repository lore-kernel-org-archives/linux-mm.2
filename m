Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85456C98338
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 18:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280FA6B0088; Sun, 27 Sep 2026 14:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2320A6B008A; Sun, 27 Sep 2026 14:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1229D6B008C; Sun, 27 Sep 2026 14:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0DDD6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 14:35:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55735120A9D
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:35:22 +0000 (UTC)
X-FDA: 85260394884.29.33CAABA
Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	by imf06.hostedemail.com (Postfix) with ESMTP id 89074180003
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:35:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FH/G9r7c";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790534120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3btJEsbUCZDnVE9CRXhr6o73+2IGPLa/zULNpIdkJ4=;
	b=wBnNF14i3gvVdqniNHyI5Ne/Pl9y1kQlpvINNYKwwCvmmIb0YNUCs2FX4mt2UT89Z5wnDk
	ytqml/Cqf9/ZkMzA1zyZTL0jDYQLyG+xwJynLlOOqNnKfwW0mVPOn3erKsvjrM3RDpWqLJ
	8aWuPaC/eYHzKc5SFJ9t8zMltDoENYg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FH/G9r7c";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790534120;
	b=hneAHj5a8GOb7UlF4PWEh+GSYAns+Ylvfh41VjfOcebC3dx9fplZnOZF/EwJp3Cw+yPa8Z
	+sqtkiqBs12RSAN/22qQ0S4XOV/0SnhEEjVSZrArwm+bb7SUHw8//Z/B01jnO7Ax292R+F
	rUWkNZ9JxwXyddib9wKsWyLAirErTiY=
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48879d4fd8aso1302193f8f.2
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 11:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790534119; x=1791138919; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d3btJEsbUCZDnVE9CRXhr6o73+2IGPLa/zULNpIdkJ4=;
        b=FH/G9r7cwCwmFZU2oY5duf7xVY6g0Ou2j9CSloqIk3b6lyO74oUGhcFYVdH5Y61sC9
         O3caWuUCuuLxvAZxH+IKTR5kJWrY2psV9bobzCt2DYMEi9d9ZcXueQTJiM+T4RlJ/lyl
         rwvmyq1hhxLG35SuagKOkl6wcTHZQQfJbNmzXef20VMWBXmfMF3MupHfykxkPnNclQ/v
         xx3UXPSycJNa+kVnhGJOtolRkltNCyUR+YYh23ypcQ8vfVSp6c5PrY5D1c/v9fSCe9Sf
         1uzOG6woiMEn3UUB2+fZPe1oFY9oVu++VzTRuIwR9kgEx8lbKi8jk0QAjXDDG8QpOZ8s
         XuhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790534119; x=1791138919;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d3btJEsbUCZDnVE9CRXhr6o73+2IGPLa/zULNpIdkJ4=;
        b=TXhs6C9+9F1vwvAlv+VOLONHgt08p9C2BvXBAJGzYtaxDU4ijzputruvX2WAkOGBg4
         LgdKbuf5F08B4anMWskJZ9uj8s19sBkvTjsqhYBx7QX35AUzTD0XTDMClnR/pNH3mE2+
         lYbCShVPtGgCp0ZDLSqLTxsZ2zfIXHKoLNOepn4z+R1ptlmzal0VofF35Gun9GNzqjsB
         zdnmh9uJExh1A11W9wKOcf1V8zaCwcN/ti3VOZsSGOTfdQULI4Uvzimmn8Z9bg6Ut2VN
         EaOSIh5gM3HSlGCXCfCyIdIVSdwxwsLfr9oXzLg/1Q8GCvDi1Mw9uey6xtk3nCk6SHA9
         Ah4w==
X-Forwarded-Encrypted: i=1; AKwUvBwpOaCp3vRRITwcpKV2DU1GqS146JmSCzgmCn1jkPnSNAwdelgnXW7EMVLGnJqdlvilzLLXWz1EjQ==@kvack.org
X-Gm-Message-State: AFq9FYIaAQezwDZIZ99iy5jeRoUxl1uA2rxH0hOFxU7XGelyC6eE19JM
	JoUk894y5RI9MEOShzYsjDaSHbJs8J3EiRFAktf4duOoqLoEItzSn7au
X-Gm-Gg: AYBFou0XPmeB+Uc2LFVCXOivh84tN1Mdyjf7ic26306iSItqtfcr31aIxxSCDK4qwMo
	liGhulkCHQVAMm07NXYst6UgG3p/DWJpDB/3WgBcXGqHh4Iux9/TRWwd7G3l5rOk0Gjf4jzx/aH
	6BzjRxf+VgQVMdUMDSkgBONZGFvtmucPEl+x339nkzgPBCA+QT98ugpVYgnjyCSZFPsUlHdwet/
	DdV6Nmzv1TmVCq1KyObCY2qOWlmFAgYdxl4bEOgx9w4HNAO1sp7qp7VvkGsUdcSO3aL8jt+xVb2
	AL9LNMsN3c7YsOSL82rdVF9UYsAx0jSdBVFBcDN8x2F61opBHXmJ9JUEqMur8Lsu09maVXZiCnv
	SMud2/xg+Or5NPFVtrEz9rju0A6AZeufrXpqyckBGKqQLcXQsX13XJidIYFKPvR/JaLpU7YY7xy
	napWbSkJA9682wxpuDtfGPjnmsz0qRwjcPu/rIaKyrx38Q/ET/foGbcCXXYUJQjeaXThbV5vOlF
	1x/1Vv88OXyLmgDxyOpExgYhOZYPA/65XAkyfpymhGMpg9yxW73wH5lOD4IQXRfdflpm6AiNPA3
	rYbQH7LJTk2blkzjhMAqT/eM5W3PUXm11VKRtL388yTYN2CUJqqESTRsHdVYQ1srsdstZ3QwWtD
	yFwM=
X-Received: by 2002:a05:6000:490b:b0:487:27f6:a4ce with SMTP id ffacd0b85a97d-488828c8ad6mr10111964f8f.30.1790534118745;
        Sun, 27 Sep 2026 11:35:18 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-b2e6-5301-2072-0420-f831-ed4e.310.pool.telefonica.de. [2a02:3100:b2e6:5301:2072:420:f831:ed4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-489bd7b1df0sm1001928f8f.31.2026.09.27.11.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 11:35:18 -0700 (PDT)
Date: Sun, 27 Sep 2026 20:35:16 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] sh: mm: fix hugetlb on SH-4
Message-ID: <arlhcX870kV0DBO2@gmail.com>
References: <20260926183904.76186-1-kmehltretter@gmail.com>
 <9b75aa51e19f9c0f5c97ac02cfc0948ab5bbf279.camel@physik.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b75aa51e19f9c0f5c97ac02cfc0948ab5bbf279.camel@physik.fu-berlin.de>
X-Stat-Signature: ynd54pnmkhattip9jhcsoyzi3cfb9qjg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 89074180003
X-HE-Tag: 1790534120-390826
X-HE-Meta: U2FsdGVkX19+loZ16fMBFGC/UTdKB4QgaxhKyp7LaPmG3M8jwjlAKuwrQb0BrUnaUvrkeoJ7WYzXepI5qpVIAuB5j7CXn84lVzSLQDlEAyXRLTmI20xelMSaE7pcq+XXYFoGI2JmWbfliqPJZu2M3OrrJFog1qrD7eT5DRj4B837o4HmRchoD6XWFoBhMxJZKrBInSi28SAvVZsUBm7MaSZRar2anDywkwaMK8Zlb0nF9m63ZxgqNCwXRHEGg24FKUcmCaCBT3vkft/KFu2JOXL8Qhx71HGU088IbXoqdK7POU7I68DpyIBE4moTk9ePSPo1pi1gZhpG+Kwcqi7kmIcJbU83O/3ZUFxC1UHQeT5BwjOyRqPBLI4PD8HWv9AQEsh9Ql8jMe2gSThsCyU9KBN+QDLc5LCGf2Jy9qpcvCZ6enPa4HV+wY7EsO0jhVOrCfi8/HZmDe8swJDaBfCw40BL0ieGePEXA/4+TqIIvPvDvPGi/JhpAEg+Mh6lsOJpjavub6DtVlgiSAni9czEMy5xqkQ5clQbtjXXTkU+R/ChxjQAnAWqTNqT4AjYuKtjqGKAZBc32OFbzKjGLbXrSeR3KKjY7MatO4NlvJ2pKwsWEm6WHDhId0+Hm4Lg/KqRCcoC6Mg2XbKw18dZO00xcvzGWTHcE2IgOLsNFDVx+pije5OGpJMH8GU3ySycTdnXi6Yi+bmEdxaPve4FaCraQtSTa0Orb1MJWpswDnLhL4AiLL5NTFNqczL6R7DT82u+MBymdb+Qy++OS8ooIfTyAmne9JalHBCLz4R9GWyPK5bQt4hAqDQIhE9R6VJUI19YAS4+HGLUTgQ2JAsKYggH4EYMZ7q1AJ+5LcUmH9EyfHCjHgGp/OOP0nZgC9H/VRca7GhB0tl2U+t+bXFgoWymYITEwgeC3LhxdKT6NQXhdhwpfM2oEJLafa2IeQkDTvSrgxCD2IVzxenwdM240aO
 75wVoH0i
 2L2P4NmHRb7bCpYLoAE+uffNzQ3lVa9xFwr4jI9wobfr7k85OUEW9zFohmg59XPj6iXppVd/4+BN77Jg82mkG4p6AfAMIdSziTtMku90V/LVzpI/kAtMHINoxZvsO57fNGkfyZg9UHqt4eMHjWbqKc6ZvFXJo3OfTpWGKHQ0IDvUX6wbiBgp5Nc2+pPQVDlTW97kTajnf1q8I7od2KrrfkewRzNXzKx5MZ+cTglJ+PkzHKl8YPYMGP5uUAn8O/V9t/wuLzCEn36Tfk9Q7U5hvDNNUIBZDEEJ7NwV/F6zjnIkIf9bTPmlMYPokbvcklsmY7i4mclpUXCkV/igcdRPDp5mpwZYeQkMevIJ38sRLPgs7bNS/p53PkL7IedzoUBAbQloBnPIaQPDIKVV4caffz6u7bDLUTSEx+pSlahnIhAXSE0XqhaaDBo775zat+4hUCfDrVnvq1ELk4T6gM8IN7eFp2d+A7gQCIqtB6KXc7unWewuP3ph+5B4G7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 08:43:45PM +0100, John Paul Adrian Glaubitz wrote:
> Thanks for the patch! This should definitely be tested on real hardware
> and I think it's a good reason to test this on my SH7785LCR which wouldn't
> boot on anything newer than 6.5.0.
> 

Hi Adrian,

Testing with real hardware is very cool! Maybe I will get some SH
hardware myself one day. For now you've motivated me to do a QEMU SuperH
fork with more features, with a lot of help from my LLM agent:

https://github.com/kmehltretter82/qemu-superh

I will send some bug fix patches based on it soon, hopefully also fixing
your 6.5 problem. I believe it is an old heap overflow in the SH intc
code that only started to crash when sh7785lcr_defconfig switched from
SLAB to SLUB in 6.5.

Karl

