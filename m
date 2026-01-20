Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF38D2629A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 19:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1329B6B049F; Tue, 20 Jan 2026 14:53:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1099E6B04A0; Tue, 20 Jan 2026 14:53:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0404D6B04A1; Tue, 20 Jan 2026 14:53:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E66BB6B049F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:53:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 582251AF575
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 19:53:26 +0000 (UTC)
X-FDA: 84353391612.12.0096D9A
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8421B120002
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 19:53:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IsZfov6L;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768938804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DT7f+nwKNVqRHxBLOEjBQ8JdR4wJCXmuunwEQyjFXwk=;
	b=MGjnfkZW6+cgcwd8434LmCuVKQxOFHBKrFV9NS74seUE3PRZjOW2yTnLN+wIKLj7ljqM0E
	xBeyPz4g6DHS8mpVj4ogQV8A4miDa0tTVqw1qTUQH8Mz8HhJ2z9dhNXuClG1cO/s97ISvJ
	Un7Hj+EZ+HqOmRwKtKTPECGrN8W+Kfo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IsZfov6L;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768938804; a=rsa-sha256;
	cv=none;
	b=U4km8obklt26Aevosc8dKKFF889WMSv2BNLaS6Ma35/aH8ynmGMHnrD6jc6C0QuUoRYpyY
	cyULiho4R5LjrcRMtni6iGRxjGgf73LzYKx6COtlQxOYYqDsMufc9qpjTkh2XtvqHaiy1a
	Gjpo8nX7CBfE+BuwiNN+11oFz7kTxi8=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8946f12b1cfso3446016d6.0
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768938803; x=1769543603; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DT7f+nwKNVqRHxBLOEjBQ8JdR4wJCXmuunwEQyjFXwk=;
        b=IsZfov6LyEC3EvVxkcmEf5fiJ2WF1iWxJl/bO94H0r+HY3DfgwPE6gWxWfXIibFKRf
         3B+TNfJRIGSbWzgWyZ9CFcRKXneP1K+yL636zvQMSlYZuyXIAEKL1YC7UGyo4bDYK1zc
         Qqq6JkizA+QuJcNsmZK/d4DAkAQ9YsnPbV0zKw4xfm0HWok2dfEMd9W6oEgV/yiYb0+8
         ifW0G+J/lJRDbAYKNkaLTXMY6xd3dwVhzpghCg8YCepqy0Klg3GEKBtDJDrqeZubvUkm
         /6TvWSOTxKT6fo1vCHx1MAVnVgJa6ilRJdbxr5xWg63+yUdjpcm4euz2Tq5jghSHA+2H
         bpkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768938803; x=1769543603;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DT7f+nwKNVqRHxBLOEjBQ8JdR4wJCXmuunwEQyjFXwk=;
        b=JhhRpUnUaNXXl8Vu7uK2zTVSXWa/CBWeh0nUGlh/jkMqC6vIjeNgj/+J6xppTxu3rc
         tcWcwnY8ZkrIQp1uSrj96CaXGUuzO0Vi3yQZdS+XnwMgCaK7hHoNVyrqt8k03AiWEcin
         LDX5ZuVMsm3tZYwD6V78EJUnqt9FzbgX0uih0nyU6h07cK1HuEDl+ogHuHR+iEcw5XoL
         quuKumv5vp0JX/T3XXBxbK3/CZ2uXEK36ybIb5nHAxMSLgK5AMHvzOTDMBTokZyp2bpj
         nSHS2r+X2gXCY0rVxc5P1RC/jOZ6WRc8aK9odbhcHZ2NBmSkGrZYc0Z0+aGv3fA37uOj
         kKZw==
X-Forwarded-Encrypted: i=1; AJvYcCXoV39QSnkwo/Yxx85L9hbiJ2iHoGvAm23SxGFZ5QtSJ7ICWg33nIqEsoYTXpuuG99SbYq26zX8Pg==@kvack.org
X-Gm-Message-State: AOJu0Yxki6ImAsG9YIbwtspyAmERqGUC9yCEPfa65kf892UeO0JXlcWG
	2a1fko5MOIyXs+MYYpKOS/W5gYwub0EIc7s4azA5sHLgee8RdVitKWyHE34A0xinTZM=
X-Gm-Gg: AZuq6aJIcCsyVouC0nf+g8ccAR1oQVFovbcOBnattdtokljSOjbCWQparsKaxDsb2by
	kBPvqb0BK3JlnDYqZMCtFZI0+7OTiokYi5ji9cgJpbvdz6/DtD1al5lrZi0eOlUS8dnSiL0t/bc
	cVXkNHY4RMxAGmOgR0JYHSeNGb+ocduFkatTKZMRibFz5zBSZaJ2+odp7hxB6SP/Qzvm9IOgOu9
	MzEsrG+qVPRocUyQYCjaZUetCmt1oNqJQ/2N0/YJrUmpkcqIH+6XVI6xKbqdPI5VbbQ8//6DlD1
	0gNC22EQJJZPcYboEvKwjHBqeA99XLN+MlQxeaGvEo2F0vSzjtjBiiCGKbUV5YgCT3qgCFSucIm
	rdOE/dZV4VlS2T7rgLbQr0Gwq2MT+ofZOxRu9KKDtaLRc6jCO14TjctO1deC7sMLxb5fBRwRR5u
	xVzPZJZqB5nhYzAzRg/81+mZbgjAKHW0ZQDRZTkCoSPEIaF6kr+KvtBwf01u9IunSlLi6DFAqas
	XqMEx5y
X-Received: by 2002:a05:6214:258c:b0:882:3759:9158 with SMTP id 6a1803df08f44-8942dda46camr231992556d6.61.1768938803293;
        Tue, 20 Jan 2026 11:53:23 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e6ad6ffsm110202716d6.27.2026.01.20.11.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 11:53:22 -0800 (PST)
Date: Tue, 20 Jan 2026 14:52:50 -0500
From: Gregory Price <gourry@gourry.net>
To: David Laight <david.laight.linux@gmail.com>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
	ankur.a.arora@oracle.com, dan.j.williams@intel.com,
	dave@stgolabs.net, david@kernel.org, fvdl@google.com,
	joao.m.martins@oracle.com, jonathan.cameron@huawei.com,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mhocko@suse.com, mjguzik@gmail.com,
	muchun.song@linux.dev, osalvador@suse.de, raghavendra.kt@amd.com,
	wangzhou1@hisilicon.com, zhanjie9@hisilicon.com
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
Message-ID: <aW_dEjSr4E4N5Fn7@gourry-fedora-PF4VCD3F>
References: <20260120094744.5d92e34a@pumpkin>
 <20260120103949.7673-1-lizhe.67@bytedance.com>
 <aW_G66HeWLbyiPHs@gourry-fedora-PF4VCD3F>
 <20260120193027.3d160211@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120193027.3d160211@pumpkin>
X-Stat-Signature: 7mi6hudapr3kezem5rythdc39z3tocd1
X-Rspam-User: 
X-Rspamd-Queue-Id: 8421B120002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768938804-124137
X-HE-Meta: U2FsdGVkX18SUHdGlRbJalEjJhK/sFPP0Q2II1K8kZP15D4tbivkvdxPisC28vEL2OJ1y2AD2ZMHuBHLiZOu8udiwOsOrS77XBavy0Y2Ot31jUuF0qWYXFzNxWP/SWufzwGvrd4IPAbqg45Ju2+k/CuBBpvKac1QZ8tELG36dNjB8fmKygvFD4i+O+KLyKca2vWvCv8PJl2ZqTTgfOt4LiIx0UVqsIwAworh3j3Gj8/mIdfUrAhIgKT3HjZKkEC/SYkgg4na8CY398GeWiIq9IgHi2j76+LokgKTLdoWozkNypZmHg6StJ/BbkMPz/eT1odelLqz477yKTIkwmoSs7kv1CTT+2LAyTUF42z+KVQJOzOeQrxG3OM4f32155/wnrqQb/K0u2lxJM4NJI8PaNeM1WaJy6d3En3TkWsf/NJHtr/GBSZB4egxLebKFSdsk/3GzMMu63SzYtnL75UCNUVf9NqHIBXSYm+y24h5TJswrT1D3PhnJ5Fon0Ktx/U/jxI0/Prbg8cA9mB6z56IalAEXFF2nFrnfSlaxFL17xk0T4kTG26tVX9mEHEY//W2ZRw2mOWPbR6JYoPndLDEK4rqHtPgM564xbxp0A0JMZO2H7ZK0jKLOrj/FYPDMFME9EOh6QDhoBomfcMi7Z7dLz0aGbepsYGOlIiWqOGtPAegVycODW1ytI1N+B/no6LLeRHdmIyDrNZ3xGTsJkSMOpTxXjqDvqBmsrR6Vs/IqicOsyngMtUaTGbDuvAmxJNdKo0WUjtnzNc+9wGj/YirO9zcbcKRC0zijOoBAlnmXErPL/hJxVybynyJXxBP+ErCK9B15PRBteDLmiaDprbkUB5MXO9nnkHNi+jjRsMfPop3CJlXN6zsPzWvHmWkE24KD7kbxTvr4AkaWdfBi+hnM1FLFV0e3wZ9P8OgMXrLbIERFQdC8G2NzEFmwe++X34LUanykgm/cjFmlL7M+r2
 brc2zVHM
 3CnQYA8ab8jH4bfgwZh/nXhPWmc2i6Ju9wXNEiBTgiCGriniPO13RIP4/6L8PRkpEvjiTiIOnISbRw29Tqt3ikmDQKwPyt7JYNfyaMWU9t5hecCfHvl75cEB+js/GV6ysY585rlYUT944FFbkB1NpeHjDZ8SSqneXcuoFQiSzUVLUckl8uyDSHa3cUkX6/qcuT1cHWXC3acBCxrER071/v0LOIgSaiNdt4cNStgFn7Bx7ej64+s1iOcg3NwPtTH8u58Cxy4p+BFTa9ppbcC+8x93E2aC+KZEYBsfF6ngfFy09YcK5qYZUptB1o1YNswwFHkaGJljWvCibeULe4T6YVqVCU7g6ESCRh9fmPGIPxnrVcsorWSLfommIdHJzEIK0ymUuLVn7BA3MUplA4ZOms1z1xQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 07:30:27PM +0000, David Laight wrote:
> > /* Run programs in serial */
> > sh:  program_a && program_b
> > 
> > in zero_on_alloc():
> > 	program_a eats zero(10) cost on startup
> > 	program_b eats zero(5) cost on startup
> > 	Overall zero(15) cost to start program_b
> > 
> > in zero_on_free()
> > 	program_a eats zero(10) cost on startup
> 
> Do you get that cost? - wont all the unused memory be zeros.
> 

If program_a was the first to access, wouldn't it have had to zero it?

> > But just trivially, starting from the base case of no pages being
> > zeroed, you're just injecting an additional zero(X) cost if program_a()
> > consumes more hugepages than program_b().
> 
> I'd consider a different test:
> 	for c in $(jot 1 1000); do program_a; done
> 
> Regardless of whether you zero on alloc or free all the zeroing is in line.
> Move it to a low priority thread (that uses a non-aggressive loop) and
> there will be reasonable chance of there being pre-zeroed pages available.
> (Most DMA is far too aggressive...)
> 
> If you zero on free it might also be a waste of time.
> Maybe the memory is next used to read data from a disk file.
> 

Right, both points here being that it's heuristic-y, it only applies in
certain scenarios and trying to optimize for one probably hurts another.

~Gregory

