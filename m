Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B244D715E3
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 10:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 567506B05A6; Sat, 24 Jan 2026 05:49:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E736B05A8; Sat, 24 Jan 2026 05:49:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475296B05A9; Sat, 24 Jan 2026 05:49:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 328816B05A6
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 05:49:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C38711A0260
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 10:49:05 +0000 (UTC)
X-FDA: 84366535050.22.64DA3D4
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id D8E2F1A0005
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 10:49:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ekXpAKU3;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769251744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PcVibjw4mjDgQQhM+5ORM6LTnO2Adlw+9ruZjnxFQfI=;
	b=AqhS2YjRJJKH7iGmecO4GBVGfDh8RvyptWudEfgEmLqO/wof9oeAd7yj70ZrTTdz/d+rBu
	ECQFQMd3as2u4BYRWz4/3HO/i8HqGjVfsGnjPdGk97JNtcL2fIPhTRAh4EGW56+w2Eu8Wd
	eoDsJY0gNZQQMK4z2Myyns9xMUz0Wqs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ekXpAKU3;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769251744; a=rsa-sha256;
	cv=none;
	b=TQs/HxCJYE+y4t/rNc4x6LkojElkduU6Uk+FNjuzgEO5cqFfP8pLfGnCco9QR2kuGtULBz
	cY499uEw61qAX3oTyChmvsIv6YyOBn2bJrPMcdopOluTjHC1lpDJcw8XsslkfLChhSmkCY
	JbGWKlmntOwvuwBKEXezPMfGo3IIDsc=
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-385baa8afaaso25841121fa.2
        for <linux-mm@kvack.org>; Sat, 24 Jan 2026 02:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769251742; x=1769856542; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PcVibjw4mjDgQQhM+5ORM6LTnO2Adlw+9ruZjnxFQfI=;
        b=ekXpAKU3OBtBfwjJtFDOHMgnwC9UHBc7ZWupgngN6jeiR1PgmYNnl/g7tWCLUtvh7d
         rNswshisiL4sJuU7pFVOcsT3NCpf8toEq88KLYxpQM6adJpeKkijzGEIYXlk8PX8bmTF
         w7oOvt+YIdruwCezmS7egRw5ExgOYUFg/Q3HRPFiA6vhrBy4QdSwkpHsRcvphZTryOfz
         X87+ECKBg0xY6SbvRVxGYmsxjw/X7ZEVJW4e4ZDYBYUu2GB1UAs5BGoYtkfDtjneKmUb
         JB7bgl1DOM+CqTq0j2312s007jB+no/jift6o4V6roLWsHKG4ZC6d1n3ufG5ysVJv5B5
         0kXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769251742; x=1769856542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PcVibjw4mjDgQQhM+5ORM6LTnO2Adlw+9ruZjnxFQfI=;
        b=s98Go5x8F1RVrCtwZBF3Xw+VCociSBMxoiTEIVKJlqaQIsCpve2ESZXTHdQodGy3rL
         a+wGjedipI8emA/oRkU+6gaUPIVrGMIdXrYa09e9f0XeAGhivVOlsAUv0h6EwIJse1kD
         s8lQhiy4DNkPhH5l+D4LJxwv1CeMdfkOKC8s8JApVi0Ij7ujAlOPMzkbI51ozftUfxj6
         TFYYbcECYNtrH2CUu1D9oJy02Rfxzu/3fyAN61tbLR8F5L9QpGKkkZHbOUhTTKBYaVAD
         7NIHe3rbzLgZahRzPRAMh5g5nJMjuKMkb2if2c8cD+eC8aSmbmadQJOLYpQ2GLP3hx3+
         bdGA==
X-Forwarded-Encrypted: i=1; AJvYcCXUGCRq1CfXsKSXDASegT9wZOko3VeWMcE5wE/UWCdDujHTGn+cStMMcf9KoGygb85g/pJVKZqPwg==@kvack.org
X-Gm-Message-State: AOJu0YyyFXiPrvPp92J0oLr6D7Lg+ZkOl3zy8WawB0dCRZU9q3CKkVzt
	tKW8YUXcD1Qhid9rvQPDXiJWpSD5JlMCuGyGZJS2xuyOT2RxM6jfFQ+H
X-Gm-Gg: AZuq6aLSi88F2JG/hX8UpwSCyQWWtiE9MCEwKd5XDuXxbqFDmOkk525TeSC+g0AQl9m
	jk/tKWQLAC/lBMFbE9xr1WpciEZsDWEXV0a+m8tgwdZPIxQZoEU9BgaSZGMSPMzR7xxLWw4P7lQ
	/R85fYHVPZMwSpzCH333OTw7CAlvmSi8hm9UdJ4WimQjzkeYb2SOPV0aW/OG/r8n2PVg9/yQmui
	3wTK+bVHWPI1/FBOfFRxf4zy6tBAgheHifQZj8A4H8HqD4AP8BA2n2SkEIZRC8GL72zU0VvGQZt
	A7cU6RZpJ1KgsYhtCYz6QPLJNk+3Mq9KUtmkdLHD0xoqrAvkm98EeyZea5Jt1gWCWAorI9t+paG
	paTAuPHuAHBz/qzdyk60AMyL4toskpYZWJMW8TzuCBLbH1Qn07UM=
X-Received: by 2002:a05:651c:1a0c:b0:385:c21f:37e3 with SMTP id 38308e7fff4ca-385e1b715dcmr15798421fa.19.1769251741385;
        Sat, 24 Jan 2026 02:49:01 -0800 (PST)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-385da1ab6acsm11193501fa.40.2026.01.24.02.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jan 2026 02:49:00 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Sat, 24 Jan 2026 11:48:59 +0100
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 2/3] mm: vmalloc: export find_vm_area()
Message-ID: <aXSjm1DXm6yP62tD@pc636>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260124093505.GA98529@j66a10360.sqa.eu95>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D8E2F1A0005
X-Stat-Signature: 5zi86eoskfymkyk4rze9gcer68fj6y8y
X-Rspam-User: 
X-HE-Tag: 1769251743-518627
X-HE-Meta: U2FsdGVkX1/3RINSPvHjmw6xKb8MU34nFbhy59W9E2EaWLhdekKXmPVYT92BdSNx0/Bff8Q0bVZr+53lQYAZ3Ohou2Vr/uRwaZ8CQrhkgl7YcIxDNsrjEWMO0Qrc7Hley3DYdxrnSfgAdtJZJkqkGeGb5//K54mvgloYCrDj7fBISEJlIZ2Rq0SI80CGR+E0cRbzzoAtaUhahE5zcqx8G9IFuwYhrbKKLjr2eI7HZ0MLtqVSbUImLt4JCAxe/CwkRSNEGWF5mjL8o7pdEGvND8jVTI6EfG3Wd7M3rqbSPM2bnmS6AmJqQa6LIPCPLcfQDzAsbiCNGe+iZFJU5EpyQzemcxl/rK1aofh28CIHgjwd+5gsTBdoyqfR1McNuWmRnKU4QIIxPj2nGmRjDpKhlN0GkzoQNHJjJZjXNhItpJCHd0yUCQE4ZuVstELvHcSxK90Wk1o13q2U6GROlUI8wEZRZnwQiSb/NTfkoy9IuH0WbdY7H2dU4PKMaJQSxKpju7T7CPo6K5/a39acWF/A2Jljtscw4s7m+cT6MQ0F89o9zAmk97B5gqmS2TKzFiOqN3w2jfd5yNNuYfxgBawjwkt0aaGjwrTgVVpLyP+9EJ2weWgJ2iOb9yHzi4m7JudIquHrxN844rxjNo9oAnlh0DWdKWLVzvLlp3EtA2QiECpi+2tEDHNUfsZEFNi5+JWt+xZZwmsuaqNQdV2T6vDJ+WQFOzQJ3GA+lN3TLFe8LAK+HV0VzcqTBZoCIs5TbaTLaTHLgMRfN2A5aYZVR2RuRRtViPMgP386LCPguaBGnNVv3GueFZrV1AaGL3UBG+dLFmTPENPvPmCLuJsxuQ/zXgkyzMDYQrC0Jmo7R1jh8V0lfEgP2AGhLRpzkpE/dAA3bRwfyFMj7pV9QN3l+RSBNaDFqJcP+PqldOOZT95+IOdvrfduA4BjkucTLA7KY6q/eMf1VecN7fs3WWVwvTO
 ZWN/hpC4
 BH71ql92MbFf22Rqix+6pT4uaqyW838gwUQqPuKNpq3LBggIrq53fXJ0j9yZPyyU9o3YLLelEOHkryOA62Z+AS0d1uXF1k4qj7xf8m9RTvglUqLFfxlaqD2EEklyofiO984UDamiHKq1u4pDJNbGNAblVyrxNuF/ugDkS0PDPlr1H0epEMqjvMES4SR8R7DfThMMIBi74930GOVApOIg/rYEZ0n0Xfyi4nJ6FpHOhMUT74gjLl7ZCSimRNwvwKcUjDjtOjTBCTKuc5E9s3eXEe+NRXVixTI+0QF4+r6j9OdiXn4HzwkZpwpaJS8uLFymWWQTlZWv4eOcC6ZJe8v+quCq+ko3eGHJGnJC7qS6O9IsncwOwdbYPWR7W6eAEpV4fe2BBx5KKVlwBQTXqidiPG5ERdMRpNY51PV0s3YNt2UgBDDwXCErwYjNSV8b1Ic0Vz3FF0lD4gfpvVMA1zg163Dl+vulIBnPzNVgBIHWNbniqf2jKjpsUhJZ0g3CFiz2KPsxAKH/ccyNDLZDHydw2mD5mgE9co58YAKe3O+/+rHp533M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, D. Wythe!

> On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> > On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > > find_vm_area() provides a way to find the vm_struct associated with a
> > > virtual address. Export this symbol to modules so that modularized
> > > subsystems can perform lookups on vmalloc addresses.
> > > 
> > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > > ---
> > >  mm/vmalloc.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index ecbac900c35f..3eb9fe761c34 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> > >  
> > >  	return va->vm;
> > >  }
> > > +EXPORT_SYMBOL_GPL(find_vm_area);
> > >  
> > This is internal. We can not just export it.
> > 
> > --
> > Uladzislau Rezki
> 
> Hi Uladzislau,
> 
> Thank you for the feedback. I agree that we should avoid exposing
> internal implementation details like struct vm_struct to external
> subsystems.
> 
> Following Christoph's suggestion, I'm planning to encapsulate the page
> order lookup into a minimal helper instead:
> 
> unsigned int vmalloc_page_order(const void *addr){
> 	struct vm_struct *vm;
>  	vm = find_vm_area(addr);
> 	return vm ? vm->page_order : 0;
> }
> EXPORT_SYMBOL_GPL(vmalloc_page_order);
> 
> Does this approach look reasonable to you? It would keep the vm_struct
> layout private while satisfying the optimization needs of SMC.
> 
Could you please clarify why you need info about page_order? I have not
looked at your second patch.

Thanks!

--
Uladzislau Rezki

