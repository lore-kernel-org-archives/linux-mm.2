Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76AA4C531FC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF8F6B00A0; Fri, 24 Jul 2026 06:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6FC6B00A1; Fri, 24 Jul 2026 06:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390A56B00A2; Fri, 24 Jul 2026 06:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 074B36B00A0
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:22:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AC741402F2
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:22:14 +0000 (UTC)
X-FDA: 85023280188.08.555ED36
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id AC5AD4000A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:22:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fb+lMHDO;
	spf=pass (imf17.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjEtanJscU+kRHtICYaoHdn0dLIQ0TxUX75oiJzMbAk=;
	b=yMW1X8woZeztxpUYYbtsxZn3087mRqXiq7mdZ9uI5QLlwBZ2RCdvXIpXq7x2zNq+HwLB0n
	Lp+hBrDam4RqgwUhM8f7qwn5FvVGBH/btgE8tyV3/M8LpHaLE0qE1MKuaja4n+99uib8cY
	EYLl2ExqRd3dIIh0pKwdIiPUh3GKE2k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fb+lMHDO;
	spf=pass (imf17.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888532;
	b=i9fIeYIAKrY/un/LTO/hRzveNjIi/U9BYR8bg7r4xfNMa2xyg2kX/PMcVN/pDCHzVp47wr
	05juwV26fAvXZfPul8Rw7kL3F1TjsFnagQBQB7pIWJHXc4Wb25JX6eaHi00+HFtywqAcg5
	LDzPQKlzAgDx67ut4fA7ku7nVsiQDhw=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84830c774a0so190473b3a.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784888531; x=1785493331; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PjEtanJscU+kRHtICYaoHdn0dLIQ0TxUX75oiJzMbAk=;
        b=fb+lMHDOAuL8y5pnOjlNlV19d0Ag6KWQiiA/li/Hk2rEGiCOaT0ZJvhBzQuN6e/pGl
         GmDJJ2d0RWWejiMSjyMd5r7EN0E/dUI/1Fe0FpJSeCQ6F5YYXZZ1hfFa/7F2U47XTT9H
         hsEythGZZnvvm33/ZFDhodpEVxgj1l87s3Nb8a4WbZ/miedYnV1Zgu9tNiF8U6b3PhsW
         3+jmLdarHtsQ37+Os/DYrfn1DQi65qRoxENceXCIcz79/teNow43anXZpgovZxp5rkza
         T0ORs++QgcLhXYz4bsTj0bV2YTaBbY6NeJ+UAj+PLF9jZ+P3rQuAN7kYd/yyzIonDa5R
         E60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784888531; x=1785493331;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PjEtanJscU+kRHtICYaoHdn0dLIQ0TxUX75oiJzMbAk=;
        b=T/1T6gPCPrNtiP+23N7DVeWn8dQOCzWwQaAdq8McQjSTSXynqnkwZO6C2qgUB5XeZh
         7nRUoRvh58f5JGHM4d28Zb0sxJ8C5c0M5yaJFXOmZujE+s3QrBkQXJSj+JTl5gHn1bp+
         trtR4DaDZeo1zmleYDtE8ly6q7dIeVeDBed0A0g7UjZPtCYDJtbb7SFYqC990nANttF7
         6d+b5cLo4pHCsAk/ocGdTP+R+ChCfK4WCZ8FWg7ZpuQF6GrpYG4wnj1r1Ytybsu5hTCs
         S3POGX5+kMFswuKIAdSt1+w6lwUw4D6gEvKbU5PQYTcGD5PgKg2s1LqYsPAAWyKtQauA
         fL/A==
X-Forwarded-Encrypted: i=1; AHgh+RpPh60IX6iJjJZzZMgp73fhWMpkUclMlg9xfsTFfTjUf1crN375/zG0qWFc6aXIf7KWKMSDjW9Xsw==@kvack.org
X-Gm-Message-State: AOJu0Ywl7qZC6H3SUwluAb269RG8Ah174szkwm2bLQW4WRUrvZ8bQ6JD
	aGGoWKkWfxi/vQNZ9U7bEpjjGX4q5QPt3yPIz7JSBe7LhnIQzyzKjzv5
X-Gm-Gg: AR+sD10PEXnIl9W7i3xoig4Viv2zh5bgRIPeHSuIAmRCoUVSCcEn3f9RO2H6zoR+0fx
	arKlFaG/8VxmH1etn0QVMrHxdnRo8LstPDTFvTmKQcecJLyTWD+MFrJOdmLZyvEab7x0UM8a6uq
	QlsHXeROWQcUfDRsiZvpkNBqoAXgtEnniKzAgPIRfLvPG95jmJV3ZdLAxqVgXUKzKx15fsvet9d
	Suq8diAOPR2/MrgTDHrxffT+GdA+Dx5hk/5Uaw+bgYk2NcY1XfyjSGhK5bp+oSTUAjrQDwo7gQz
	U2q0qaAwq1RfndjmPzC1oTlvvXLDTJjzce04oz0JAYJdrDSEYO9Fa0iKY0SbfOxOo4kRFyigHKB
	htiZI9owwzUzcOZw4TIOxKcYPlXqH9EDC+Kc6Do2nPWQ4zdcC/lrgslBiE1ppQQnbV5VRyy9V6K
	gQXHFeyQ+sbEKKODGbWyeJew==
X-Received: by 2002:a05:6a00:ab83:b0:848:65fa:542 with SMTP id d2e1a72fcca58-84e2bbba2b5mr7126501b3a.53.1784888531583;
        Fri, 24 Jul 2026 03:22:11 -0700 (PDT)
Received: from [10.125.192.96] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17573c0esm4486650b3a.38.2026.07.24.03.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 03:22:11 -0700 (PDT)
Message-ID: <2e61a4e1-20ed-4fe0-158c-5a9d060ce01a@gmail.com>
Date: Fri, 24 Jul 2026 18:22:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v2 0/2] mm/zswap: Fixes and improves the zswap global
 shrinker
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, nphamcs@gmail.com,
 tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev,
 muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717181839.c94d0335ccef0084707d3d85@linux-foundation.org>
 <CAO9r8zOrXqsEaCEJUUAxbAhhN_OQb8ejogeUa6k8hX_JV8hxxw@mail.gmail.com>
 <20260717214031.8b22e9a37ea3b0c564b466f0@linux-foundation.org>
 <7dbde343-fbbf-6a1d-1785-ebf9f5a04f6b@gmail.com>
 <0a96b7ec-0d8d-2abd-afaa-739c562bc985@gmail.com>
 <CAO9r8zO6AsdZZWoYibAj6urMxgM3eq4bg9JDhr443UZONPF_6Q@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zO6AsdZZWoYibAj6urMxgM3eq4bg9JDhr443UZONPF_6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC5AD4000A
X-Stat-Signature: ts97iapnpj7wrgtxqh3ia9fzbaps5f7b
X-HE-Tag: 1784888532-726037
X-HE-Meta: U2FsdGVkX1/CJkhlaE4ueqglde810/InCKMCvPtM7+qIVua7UW/kjnbdsOp1q5LnpIP4w/viB9kHJBibdfEojI1Kr+05stsVCoSwkALwpKQbo4LByNC58Fk7DexkP1F+yqgTohB2XFeuQxz0BVBB12QiVgJiPSqdvB+r79h5Zib45Gtj3tGcmKLzvTZIH3Kq4VBf8KiMhPGT4OwqENWDqcMB0f9dSYebivTj9p3bfR/ufKhU5d2JQxM4lPf/GnT8RKhxB06gZKyKeyXQGyNWzkCbEnxKwghBgObRrp3tA4nxSUsRKMTXLE/8QCdH416f/jjGplnqXB7vn21+jks7DJy8UlnjUIJW2wPdcxxWvQSadxVx4vHkuv30JukIatXwbhnGI81hRvad9DSwDnbTG+GsRlKUUc6XSFB1HrWPlGCFgcvDIWH4A8rn6lJ88dEggam/4O1US/1okaPxTCoVNy0qnknmpNbkynXsowxpXaOGxCAs4pOrGCap0kDgh1fcbjsqzrixyNnzXDafk0xKUTO/0DVOzWn18IrThLuM/vCrPCUxlimc6rLuh8gGHCUtbVUpzohPjsDSXcIxjy7ZnABMnw0rowRpgxTUJ0Z5IQSu83hXeSkO9SPE50MmlVW8/CfQPSbk6YI54ZIsy4YycVXjIJV4Soe4FarOiAUvBaLkMZp7alIpn3EjIWu995pxnAmTejGWqJq5J6xVZsi+a032S8ndq6odArDnfuoimfTtSylH95Tp8OPvtitymyIv0vyPcFI42TI7RebWgj/qK00Qr3I2M6HKlfjbT6oVZUyBYpX6pd0UHsT1RUoMFgTQWKXkKbSsh9xekOGO1Hwfo4taLn5TkP0Qq8wOjygT+Gj3vRxH2bOxaiyBFV0Z/H/MX3cdN87DmXgTyu7Ey1WX9E7+b8QRxhN1aq0Idxt8qViYnxW+rRkua4NSP4hrZPevxu7jwAZL4MqReYDOQKN
 afldR0uU
 oM8lxgsv25K95aoSAH7TVSobPS0G8R+npQC4dPHXeO/DpN0gJlaOhTYKrgG0f3NzdsZsZ4L8/W35/l8cSO63RNfAbPrO5P5nDlb0reYVPI+4rEsIqOZxUbJiBGXdj29hVJfLqiI8jMjNt6tz3zUFcCl+YmBXScMtmkfv2nSB1DPrFYmUmighofdlT7rY5XM7uReWzujtAuiGQqWi7MMLTUj4ATMYearYv4c1kT5HPyZi4DszagKxZMQ1FZwEDyjJNf+em7Hyp77jvxFDtTv0TjLGjNvXQkEN2vatWg7cZtlLaDntjvCOVVZvfVYg6FwqiUF0GzhMMa19fdr/dNDdJbnpKPcgEhh2ecrW0PrIwZMZgKfgpSLb5lkN7Pz5Qs/tFODUMiG3XDaz0HcIC3QR0Kmkds+7/6HiktKK3WLlTFQq12IE6LaiVAhnBLUiLCAFoNN1AxaZI4BjSgg2Vv0iyVH+Z4OK9r0yK07UBWIEJJRS8RHqrAPJofV6o8e2e/UWGnjJV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/23 12:49, Yosry Ahmed wrote:
> On Wed, Jul 22, 2026 at 6:21 PM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>>
>>
>> On 2026/7/20 09:26, Hao Jia wrote:
>>>
>>>
>>> On 2026/7/18 12:40, Andrew Morton wrote:
>>>> On Fri, 17 Jul 2026 18:28:04 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
>>>>
>>>>>>
>>>>>> The [1/2] changelog lacks a description of how the flaw impacts users.
>>>>>> Please describe this fully and maintain that info within the
>>>>>> changelogging.  This info helps -stable maintainers and others
>>>>>> understand why we're proposing a backport and helps myself and others
>>>>>> with timing decisions.
>>>>>
>>>>> The first line in the changelog should be sufficient imo: "Zswap
>>>>> writeback on hitting the pool limit is broken when memory cgroup is
>>>>> disabled"
>>>>
>>>> "broken"?  Perhaps this means "fails to occur".
>>>>
>>>> But what is the userspace-visible impact?  IOW, why are we proposing a
>>>> backport?
>>>>
>>>
>>> Perhaps the first paragraph of the commit1 message could be modified as
>>> follows? I have added a description of the issues that occur without
>>> this patch.
>>>
>>
>> Hi Andrew, Yosry, and Nhat,
>> Any thoughts on this change?
> 
> I would front load the user impact in the first paragraph:
> 
> Zswap writeback when the global pool limit is hit fails when memory
> cgroups are disabled. The pool remains full until it is organically
> drained by swapins or memory freeing, leading to zswap store failures
> and pages bypassing getting written directly to the backing swap device,
> causing LRU inversion (hotter pages with higher fault latency).
> 
> ...

Will done.

Thanks,
Hao

