Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39008CFA469
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 01:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ACAD6B0023; Thu, 20 Nov 2025 20:56:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95CE06B0026; Thu, 20 Nov 2025 20:56:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A916B0029; Thu, 20 Nov 2025 20:56:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7CADD6B0023
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:56:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 229F458DD3
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:56:22 +0000 (UTC)
X-FDA: 84132949404.28.2B066AD
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D08F20008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:56:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PlYxF3ap;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763690180; a=rsa-sha256;
	cv=none;
	b=BgP674zvDuRJciNTR4Hc6HdV0QbKR/8EbqlFX6mSJujj/s+luOL76OaULGXIRfrJ32Hv0r
	2u+klKLdYvXIMTquPEPvpdqb3khOs8ZW/hPK6e+LB7qhxu07O9ECY6kbC8sFCQ1HoJ3/Zc
	4KsoA+z624LkDHFCHRJRLBjcmfcuM0s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PlYxF3ap;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763690180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OViwcIPHyPF5+8ML/I7+PMGnT0G2LOCHMTt/vHjdb20=;
	b=lyg49HIO1B18wUiWoNp8svThzIP+nVXaiACTJ6g2+GYML0uy5xMrjGqEt7RFzkUQNxjZf9
	QdLDnsUKzd2BHvdBiGWTjaSOBfLut/CJ3pgek6/uGU3hyR08+YRwa1Chadb4k69Q1mmgXG
	kue1YwElIxGN3i8nXcUDDbSO5F2+VHA=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so1327671b3a.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763690179; x=1764294979; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OViwcIPHyPF5+8ML/I7+PMGnT0G2LOCHMTt/vHjdb20=;
        b=PlYxF3apDFbg8slw7xCs/Cy25rLfO3Rj4tk4fs3gEjL2mO9sXlVoVGH9mWin09HN8l
         GIPd8+IDfjbVnZFPBDziasYPKQr3dxosqqTNISf2VmQnK4YzYzW8ycodRb+ZnmujvCP5
         L3mbMUBVATl4GvfqP5LxbaR3c0VRzXmLDEGYg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763690179; x=1764294979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OViwcIPHyPF5+8ML/I7+PMGnT0G2LOCHMTt/vHjdb20=;
        b=sIC1iOONEvHlwaj6c2SAQ4yeixyf76ktFvXrgTBuyZXhimtBNiqg7kBfMb8Bwlu7EB
         RKt/YyiHPbHY5wOxkLhdDCI78cYsLdDfV4Jn5Wq+dqK61/QXjM3ypPgqVNQ2hjGYDyFM
         dYD0iHaiuYFGD0jeLHII87lKUrql3HKHkaQvtaXHrftOIkTUYSxehelRQJXuSzD/DuGx
         cFcqTyyljH8YGmUVaqeENIbQwY2wybyi7kv1Y2sINavZO4xZ6SK3zLi+u7dfYGY9L7or
         6pg0zyZhByVDhUTpUEEaojPAUrqFLzbCMXLnV7NtU9hR8k/er51tooFuQnKLQNt1ThcV
         2HLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhxVoN1LVrgdP9OemE/dWXjacKECCloYNjitsGEw8yy4bcxIERJJMDKdFELzqEce8v60tj2NYFgA==@kvack.org
X-Gm-Message-State: AOJu0YwWjgJAudM0LQ0O29lMKK13cNSpuC8UH9BNvrat8SLljzzi33ag
	brZBeg8vcul2iBGww3NRltgwH0ms31J2XRLyuNuMLqKqO/A61AFTGtDqPwXr6u2aRw==
X-Gm-Gg: ASbGnctkJPaIOeCpJyIq1fLu97J2/LjyM9y5GtcsfXv6emqd/uLDInkQX+fDqftdQE9
	cVho1R12ygXPHDDofUZxiIW1EqU6wEuia2HjEOYPlNnyDQKXBY4lARo5XpngA5idzhceIxqJL6I
	Jh2AZfRtwpSOVG0STuBrML+Pp1EBCS5iUrGMLYpUpz9xim55W42YZWLZroCHXscTN3okB+HHk1M
	t+yGrc45EAkn5T3k0Cg8CCZu5G9a9+4R6XHlNNrRLmkPpxCrS3FFn5sY7mA28B9fk8D5X38J6rT
	3Lbe5FYzo2yFdKqdG3uf7pm2NHXuq7DUwRtw4PqglWvP6fu2Qvw0QCB9nwgW1eW0/zGvRwLLVAM
	cAmR1WRyqVEfQlbLNKGTYECNki2micvivy65DVtiHt4cYZwARfuofXG7V3N+SyZG+um+v6RNoFz
	lr4LgoiZX6jH0Nri0=
X-Google-Smtp-Source: AGHT+IGgE/KyAZL4wFe5YItWnpbOY1jW/qmnO0UUZOBfVTAHxChcoU8SYw4n2gxRVkYRqbrmyHSZew==
X-Received: by 2002:a05:6a20:2448:b0:345:e30f:d6da with SMTP id adf61e73a8af0-36150f059e2mr471179637.37.1763690179156;
        Thu, 20 Nov 2025 17:56:19 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:6762:7dba:8487:43a1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3ed379558sm4096703b3a.25.2025.11.20.17.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 17:56:18 -0800 (PST)
Date: Fri, 21 Nov 2025 10:56:14 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Brian Geffon <bgeffon@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, Richard Chang <richardycc@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Subject: Re: [RFC PATCHv5 2/6] zram: add writeback batch size device attr
Message-ID: <ajejtr7lff3dcvjrxgp7k3q3rykhjmxboxggldulhkinuqw6iy@pmbo2isvhf4q>
References: <20251120152126.3126298-1-senozhatsky@chromium.org>
 <20251120152126.3126298-3-senozhatsky@chromium.org>
 <CADyq12ypYai3Q2QntCjvp26U_J3xWpO4J_DSV+UwCqLFinkcGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyq12ypYai3Q2QntCjvp26U_J3xWpO4J_DSV+UwCqLFinkcGg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3D08F20008
X-Stat-Signature: tq3mmhcb7q183d1hqzkdxbzygksps8bt
X-HE-Tag: 1763690180-622361
X-HE-Meta: U2FsdGVkX1/9L9P7V3OFHCm9zDasDPgX+P58epdhsybRzDa7zze5061U2T36aEPAfeJHxzT4T6GTlELuObN1DDBA1TBlvZp1hrVGxHrQqqYq1hnxf/+vpGjZd2XGU4Gdku8bxs5JhHrHHPF6ytbt+gddmGONV4vt98YD2Wv5YN0zyBfqK3xrZLIeSo4S9KdHp6sIZuzbJ2PYGonS15rHBOAdg1966e1EPuxJLJSx8OjQKQmXmhUDtDsBifbG3F28Dn4Vk3TN331amWAbBSBuphAphTitf7WUg5vsXY+h3SE8ZaVbILNfRkr/IUdxWmkBoKJxHL77UiGjo4gtDItYDTx3HkaZA/tfs47EdLI41UOAPao1+TZ6EXe7WOfxJ/cipptsG+beuU5Lwu+b8EyvmN871iY8R3tM0URAnNDws6V+mZzMnQaVgVHkneV9ulSQXBboItCnSLrqqFkHF1RqyEftI0t7D2CDNM2WsXUQ4i6ywenXyR6bojv0/ZnaV3OQ/0cuyaeBuL5bGAa2B2lE+RW3zoCEHGaDWjWAqLgUnZTNg97ldBfd6W6juVFQF5/Qbij5i5/3iLcxTzzPEOa5GRum4eUrYM4ltVD4ZExG8iNhSmXxsdzdLA65UwOu156Drr3YRMITy1rlQJCU21XzW/aKZJYHr9F1DsLOKEQFgAZp63mxpMXM2a3FJuh9FqXWjaDwcT+y3C/lEW/eZak/ADiQF0aGp7gJ2gfNZijTcMDLsl7ziLbko7AvZPFR8OlfRLgBqOsfl2dusjzPAW7jegi8L6gmh97WMWXU5j61zJagpqoCm70Bzaoi/bi8dGYnuW3CKugvN5h+py+N4GxedJIOiQa7ug/VueqCY+yZ745CEAiwMw7Yh5FgsL4ERWRHBj+O/KycefaYN9P7coOa0Gp5xBCYYCebrNdfs2iz7KHDmNaF+Gf1NOVJAhsceCMPPt1n2dmEnBEcX6lnZlK
 IyW1eiSb
 aq6yD/7ZhhkPss6MJz0dG8m0HkWI4K6DMzZ1VKMEYozVgs+ae2GOs0ccchPb+MQ0AW42l3+iDeJB5w+oSwYKd/oJPwCMJLaslELeABNT5cLUuOgka3F1XjQVxyIyHMdWVMFM8fbQPp6aRBedZ6ER63HiY3z0MVM8gFSb2L60kgNwFNPgrpVj355u4Hq73EBeD/QelNGrbgS1Aqc1jgw3iIVta2wL/EQnDN/d+3OL+tYtHUbxXCT9B1cZXQZ7yES7lq/EiJ1qVGWEECBw51LE7K2XDM/h6Pwbb/ja1nWEpt3nPYou+aM8t/xPeZzqYd/iI/UsrE0hniDVmNyXEIFjPohbP/P0EY6HOGvclGp0mqBQCdJQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/20 10:57), Brian Geffon wrote:
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index 37c1416ac902..7904159e9226 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -588,6 +588,42 @@ static ssize_t writeback_limit_show(struct device *dev,
> >         return sysfs_emit(buf, "%llu\n", val);
> >  }
> >
> > +static ssize_t writeback_batch_size_store(struct device *dev,
> > +                                         struct device_attribute *attr,
> > +                                         const char *buf, size_t len)
> > +{
> > +       struct zram *zram = dev_to_zram(dev);
> > +       u32 val;
> > +       ssize_t ret = -EINVAL;
> > +
> > +       if (kstrtouint(buf, 10, &val))
> > +               return ret;
> > +
> > +       if (!val)
> > +               val = 1;
> 
> IMO a value of 0 for the batch size doesn't make sense, -EINVAL?

Ack.

