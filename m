Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6787BF557FE
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 10:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93CD16B00C5; Mon, 20 Apr 2026 06:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3A56B00C6; Mon, 20 Apr 2026 06:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B176B00C7; Mon, 20 Apr 2026 06:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63F336B00C5
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:35:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D65B9C2FF7
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:35:20 +0000 (UTC)
X-FDA: 84678577200.25.22C8E60
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id E0102180009
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:35:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="iZVc/1PB";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776681319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EhFTYSJbTduTmCqbp6TqKqpfuADrxHXJGk645MsU9c0=;
	b=CvZHlY5i6CTM7ZflgxSxNt/fQcNpeUzdguVFpkBvV9vmPzBiJ7nMj/VAQcYKuJVDtcgokD
	SQbxNyM0Bi8wPvFtwFTkJTF5MGtb+GFuZcpXpPrJCljH/tNJqEuCpAmkYD11r7rnggN/5s
	xFQGWOnbEnQMz1MuYXajWzEW4nKwPYg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="iZVc/1PB";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776681319; a=rsa-sha256;
	cv=none;
	b=rP0tY+HZqFgndS4JJd9Zem2P12VQQzF6V0IJ0CRJc+bl2T+hGgoex9dmDqbs2Aj849zACn
	UxuImyX/6iozlTYjBZ1FLPqqnHRX+JLqebtLZKeq4gf1XcNwmT+am+MR7LF0miFOydhfnJ
	tJz+4DPBnMtwzATQYtVGUov/UcSnOkk=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a40502e63bso2800570e87.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776681317; x=1777286117; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EhFTYSJbTduTmCqbp6TqKqpfuADrxHXJGk645MsU9c0=;
        b=iZVc/1PB3O5FCPr0ou/Z23f4wgvgwI7kwOW8ZeRjFoxBMJrMeRTF3dm+Ry+93ieJ21
         dSUb2cI5i5bVU1ly/lgk8t85q/Hs7f+78tgiFQX2uA3BDaiZm0DxshEoLRim2BZWJja2
         KIKcxCNuB1E0ZNyWZ3wN73Wmth874V2IYAIcrKQUzx5pKysSb17hN5V2X/k1zMarps9E
         r7uPqGfYwVmYVVXBUr9AiuKccmgme8l2bjfg5CuIb9hrZWkN7XHAiFBxnoXaCiSh+as0
         isym9dwAadEOvU2EXP6gT50quCH+R6w6qHKKUL1ycnJDFYdkXCReG1VnQx2k/Vm1bctU
         oGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776681317; x=1777286117;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EhFTYSJbTduTmCqbp6TqKqpfuADrxHXJGk645MsU9c0=;
        b=FNHP5w7ypBo+NPKyVAjxH/KKFUJhIjOpmX5kZjzh/rIg7GWnz9NaRTBCDdlzXvp154
         IbSFbWqjAgUcUitDzohrfXH0Jl54kNRAekxyVet5A54DX7X2z4101hHPrZkgDmarTTot
         0pD/TzIQocgxkH1j6Eq4VQc24NT1RKwgDUwnEX/Rxy+eqHsNfnkfxmzgrGGj1km0r6p3
         GI7I1s5f5EVvK6tfMHdbzb9mLYYzRwT76efSYnh80GgVi4dOz4piBnS07Yq3439oAUl7
         SMzSJ4WWwSPZOvwui0zmpgRYbx/RUkeE81fi/t+kXGFO4OpFlA+NhiN2IrwJ4VICv7RZ
         9mWA==
X-Forwarded-Encrypted: i=1; AFNElJ9g2ba6yWFtcvnpZ5Bgvu0LCs6g1lj13gTC4k9vzlJqB3zynvY52Tsgd0lFfIN0OI5J2422us8VMg==@kvack.org
X-Gm-Message-State: AOJu0YyCdLHNX/Aj+fOKv8hdWhedXtVoD0QkvX3CaH653k9pkaz76gUk
	MNQaaiqq/umIdEkc7aTz1ugd/y+nP7yexGFr/NXmQNI8CKM5+mYh6Jde
X-Gm-Gg: AeBDieujAb1jeaNLk5s6tAXxfriJ7+rrgEgI0Jmk1+0tkhDNwSizCCMdSukAL66j5vJ
	VzzAIFrQdJOyYDz6pNocUhp/8ejjrNV/tyUCIc4HhZRwOpHMp/eTGwuw/3GLqA+fzK95E81YEeq
	bUL0zWEvq3QQ3TCZGTYvNifnUuT3KaFQzO2TXSBXafm850RI6pngFoItNvbyiePX9epZqLrboms
	rN7Pf0oqWGLxJRKzJsGlktIaUBB7uTT8zgHIcpTZS+Vr2VM/R+8pglmADMl6QeL32KINaklvcpH
	8K5io1rlVwakUWB+X88WDkEDGnx/GDr8zBCb0Vu3sGEKotqV+r7FOor8pFL85w6MbZ/sSYEBG8K
	Dry7jVniJTEplPVgRY2U3WIrUKSdRGKCxupDOvcwGtJeIvK3jTJjk496pEI7AmS3yy6X7OufdlQ
	U=
X-Received: by 2002:a05:6512:154b:20b0:5a3:ff44:f01b with SMTP id 2adb3069b0e04-5a4172e3131mr2660645e87.34.1776681316695;
        Mon, 20 Apr 2026 03:35:16 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4185bc672sm2933276e87.34.2026.04.20.03.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 03:35:16 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 20 Apr 2026 12:35:14 +0200
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Uladzislau Rezki <urezki@gmail.com>, Alice Ryhl <aliceryhl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v10 0/4] mm/vmalloc: free unused pages on vrealloc()
 shrink
Message-ID: <aeYBYqPSEJRC8mjh@milan>
References: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
 <7d16f260-ffd0-4e45-b66e-9e7f71332466@zohomail.in>
 <ad5yE0sgV1HJsyaC@google.com>
 <ad_cpqx38LtQPlX8@milan>
 <85a9f419-7f1e-41a0-9e8e-67aae7a1b0fe@zohomail.in>
 <aeJs4jmco7BGCNHq@milan>
 <20d2e9f5-9b4a-477d-b3a0-5a268364d70f@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20d2e9f5-9b4a-477d-b3a0-5a268364d70f@zohomail.in>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E0102180009
X-Stat-Signature: qjbexufoikz8wbi8dkwfzsiaadbfxtcd
X-Rspam-User: 
X-HE-Tag: 1776681318-751833
X-HE-Meta: U2FsdGVkX1+GG0yM1fY98UIxQpUg/ZLOV2FpQpcY3ZDNd4ztEjnPKHmq2limg4aj68mXqFuL46gceioYZx8Up++zcSUJ59g8/157VleLMs/y2ERpWM9Szq7Uxp/uea6S46bkZwfD0Vt7z00jDCwUBzcHZ3Xf51m3cuezbtruAFW37d1fWwzwHvuA1MqXdlZWVnP/QBW3ViyohVJRrA8hrb9ZQFJ3A4Rnq+jzvs4CdCUb3ubkAzWrwFDSa63qwBfRfGLuto490oQZTmNEWsP++KH5vjBqzSF059VLcOZm9VAvIC/Lzuu5/PxXNlTavcPAigITlYdx+eNc51jkiloEWQEJPwgpHyFeY+oxxrOGHTIJyAKvIlaIsOQ0evbvAnGNfjhdUhcj7Hoe3gOn/qa0P/wBQjSSd7ppvoIM7408YblXJETugfi606P7ssG1cp5X0G5HRQBJ2bnidMKzjgtYoKiozEXSjums9KqNwbmMwpeD2Hr1npTfccfZGq5jYTogztu/+j4Hyg4dzCh0Cv1JDa68Z7VaE9Jdewa1NjV8nShIFsGTSLhbgx6uk4QPHHxcx95x8C8/XIr5+yAmmnm0fM1D1ONqhdN/zgZLuf849TxOShhz6cGzhvilD27MlUEMVCQMygrAla1ozjLwYO3qgPr2zoirb5+lrhxXSaBdft3eXzzmtfOBmfS3nnwxxtEic4OSfDoUDIGw/Z5qvHwU/b7GcUmB5qK33xPA2IHv2P8JXDVzv6wspfBr+45CQwb70zEnaUSed0p7HM6V16GCAnLrWc6p3uIPuiasVl5/4+m7lrfJy6771qta/dNViezKb0oiU5D+bkw+RCul0uyWytJYJQ9tZSqsPKxqg8+zeA0Eyn9jgYHTNGVkwaE9+/dVFTQAQ2uEm9J64O2AzDNXKfJGdXd5kzaT6JPd2xA/wsTnnt4TR1jIAluvPmSAie240OFGUfwdWvfXj2vgzL6
 dSJSy+Q5
 6gPJFA2dCpXzYTrysmNXwhu1M8h0ZGF1wYBdr4v3wTZjAjtzp7Wfw4CltX66MtCvK9x+FXIdLERciBrMzGqktCK4E3vYGY2QQxj9rsZgdwg4dYZU5ky3xYHONjiCwrya/4TWjLl1IPEg2xI9TNhcix/pVxE9dahybr3q5Gu+B6w4ElYFunW/Z9Tt2VhZKzqZ/G484dRV+E1bv98iBH0EdOADMdjucFXSgk7BDeqX7Dq7op3aeEUYQcPJsJuWCwP66b80WL/20A8qvprHEJ/xqkhldiYRuiT+5OVHsNDzG4lwGGfBk84g3AB7LjcV87wDmWEPYGfYZAzfju1mKrHHs6Sxu2/dhl67res64NQDRQzn/zikYJh1SfuNhPp+P9LKfwdH4u5f6CIqXisndoIFGeorEkYFhvptL/4CBMfo/PcJdKgD/WiXApSEQuVRUKhi4d8aBbmCgFG2K7yq09w48mcWfuwtCLzYoIpMd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 11:04:21PM +0530, Shivam Kalra wrote:
> On 17/04/26 22:54, Uladzislau Rezki wrote:
> > I have some questions to clarify.
> > 
> > Why should we use min()?
> > Checking vm->nr_pages, can it be 0?
> > 
> > Can we just do:
> > 
> > if (vm)
> >    /* Can not use get_vm_area_size() because of realloc(). */
> >    size = vm->nr_pages << PAGE_SHIFT;
> > else
> >    size = va_size(va);
> > 
> > or i am missing something?
> > 
> > Thanks!
> > 
> > --
> > Uladzislau Rezki
> I honestly don't know much about the usage
> of this function, so wanted to be cautious.
> 
> 1. We can skip the usage of min though.
> 2. Do need (size_t) for overflow issue
> 
> I can include this simple version with size_t,
> let me know your thoughts.
>
<snip>
if (vm)
   /*
    * Use the actual number of mapped pages, since realloc()
    * may shrink the mapping and area->size may be outdated.
    */
    size = vm->nr_pages << PAGE_SHIFT;
else
    size = va_size(va);
<snip>

As for the cast to size_t, i think it is unnecessary. An overflow
can occur in either case. So let's keep it simple :)

--
Uladzislau Rezki



