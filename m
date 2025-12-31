Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1305EE57C8
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 02:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145416B0089; Tue, 30 Dec 2025 21:51:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127046B008A; Tue, 30 Dec 2025 21:51:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0324B6B008C; Tue, 30 Dec 2025 21:51:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5C4E6B0089
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:51:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF3EDC1D84
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:51:17 +0000 (UTC)
X-FDA: 84278239794.29.3F3A94D
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id B26FE100002
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:51:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G53L+2We;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767149475; a=rsa-sha256;
	cv=none;
	b=Y7XZti3U68zmfQ9Wk22BQoCbGJCr9AYAkWZ9lvMZ18UznkraEuu3sb9Sk5ci3F8y1k0t11
	Nt7Ehh5fLY+Al/G86+UbjLPuqnPR6Y/YaB+yuCvBqNqS2H6VJtoIqkaBFx/ULyNs2KAbJh
	0Dk4jidamvpTBx3Jvc2sM9KWje0ZuVI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G53L+2We;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767149475;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmlhgLzDihwQXJKjPLEsbonM6eB7pTCajPhK6zvZfAY=;
	b=Bbpt3SgQ86I+Cq7MuKiLWCadvqsF7v9d+uk9C5IoyFoYtERSoN3U4yJBf/P2o113QsE8Fm
	ru+KMmfmB7KRYVjvOfJTrnrr50yRRjwgsxUqVYPTpirvyeKeCSrrqdQ/sPOXSkNvY5SuFX
	nc/2WDBOtUgv7EFjNx6LMirX51T8G8Y=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b76b5afdf04so1575932566b.1
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767149474; x=1767754274; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EmlhgLzDihwQXJKjPLEsbonM6eB7pTCajPhK6zvZfAY=;
        b=G53L+2Wesktw8eKyz+bNGOe4OxXIfgcAkmwPbN0bYri+dLnVxUDLc8mFmS39W6yGUv
         natEO19TqWbbJK61C3iD/hY1sxzhWeZhC4SQPfrr5FgqpX3QcpuE4H0xm1dSV6QX4mwp
         mhA0r9azsWZ2+/IQYiVa7SlEgSW5o1Ks3FcudvyBAjQw1azCX/807/8fr2j9EnMYim/c
         MzQ7d4YpuUYp4j8oP/RhywuWsVhavTA/O3SG9c7bTQj8yXa6VzyyhmBC8/mHb7uyXSfQ
         5VAK/i7s6+za8UkvqjRAGHA9b/Lx2buQHHTF789sitXYs8vDNlPGm8/zCamNPo3eIjbu
         rBLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767149474; x=1767754274;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EmlhgLzDihwQXJKjPLEsbonM6eB7pTCajPhK6zvZfAY=;
        b=sC4DSimDCTpqSjbHEPJe/rNYzMnDao7Cn0qUe+mkDsjmmkYsIq+mTD8bR1HyFUCU7W
         w5SNKR+et/RoLud8IL58VuedyaXwBFAWksitOIN6LOV146pmf50fvqEJ9HqSnb5c/9pH
         xO6PTh83d20QxFzZklIvEyYqIzDORRNc6azh9KG6KAecyHEWYWNK4Mmspx2rgHEPInOw
         i8FAKAOTqOiX0Hrgij5Apr/V1e1bv8kiLtymjcalw7ojA6uXbbCzBsZV/VlJhSv4vA0S
         7NZSYqIMoYbzpxCfI8GFkl9sRfJOBmLbuWH2piqdCnN6afFJUxSvVN9xkg78YoFNxey8
         OPQA==
X-Forwarded-Encrypted: i=1; AJvYcCWMdbi5jbCtwSjLsA6iq8BrZwmLiX2vViGlK96MRKvvwX00Z3jW+v/YPbE2Kp6bHm/qYTr+UzkORA==@kvack.org
X-Gm-Message-State: AOJu0YwK6ovERKe4HbhW2/C8PGpHQnG6wvMX+SfgnVS9T6o0AHmycnWE
	s7b6OpmsYOEiV0Ss8RXFUwUk4zZLVRQixj7OjKccozeao3+WioMw8EoC
X-Gm-Gg: AY/fxX4cWf21mNwutP3ywFBAJDUivjT3arx+svNA+gNdtD+4NgfcJhHEFBfNC5fQvm4
	dftAKMs2CMnIXTXbiCsINDVfT1fY7y9UOVMijSFk6fE+Vf9t4Ot1FflREUDNtVuoKEzT9IxiOrL
	ByP/50IhmXFzw1tpfmLaai3TCJPmiIT+OMgVsQnBaex7YMyeVoUFLpEkvLq+YwCnaPx1fg8DFiR
	wAIImRgMmfWtG3WzS5lc/oVVPndMZQP03k73ml4bWsGWXBOVemCPY3Zap3tHUO1BQjWs9DWTqjE
	m7GvaXZ1E/RJSIsczFhKEV+j4fBeV//wT+JrNR8xz02q3sCcd78omcg5rMTNMgOwSh3Y8xhqLZ9
	/uXqF0Io9neHKDHF0jFgT+ir+sniEAjPnniAlFwN6hz+TwLudrfkDGLCxgMyrgCqALHDTdj/HiN
	Hfi9l4QD3CGZe8HDcifeK/
X-Google-Smtp-Source: AGHT+IGVcLZdqj6eNaasrn746ipTYI7fDfRCvu0V+Z1Q5bofYsJUvEoTAObsuEDApPDu/anBTFxEKA==
X-Received: by 2002:a17:906:5a68:b0:b83:9751:4334 with SMTP id a640c23a62f3a-b839751755fmr285999566b.50.1767149473783;
        Tue, 30 Dec 2025 18:51:13 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037f511fesm3867530466b.65.2025.12.30.18.51.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Dec 2025 18:51:13 -0800 (PST)
Date: Wed, 31 Dec 2025 02:51:12 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, richard.weiyang@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v2 4/4] mm: khugepaged: set to next mm direct when mm has
 MMF_DISABLE_THP_COMPLETELY
Message-ID: <20251231025112.uzlgrs3dgbyzul2x@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
 <20251229055151.54887-5-yanglincheng@kylinos.cn>
 <f47b6192-2115-4f4b-82ae-dd66e65f4340@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f47b6192-2115-4f4b-82ae-dd66e65f4340@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B26FE100002
X-Stat-Signature: f5ayetztcy1ysgnrnz4hcps4nqrqykhy
X-HE-Tag: 1767149475-871028
X-HE-Meta: U2FsdGVkX1+s4IGtLgdI/1Khvi5of/XslCkvqXuiuherPPR2rZo0i6rJRpJAW9rMeTOZ4fNp1n5zW4ioZeJhJTttbmdKHSkpn1jGAASeatwpDHCgUozIeSPGxoWsc6KpqqAPbxiOaDFTSeanerU/LAoW0cxfJcnHt5SzDpvNIsRtCzSZ5kS62/OYmhdf6HQ/JB6d6O3SVFhDpD9p1gHJo7ZbgD75/LdeMCRPKUW3e3J8aneUy8IkCPNvuj8e5yEY0ebDJcb0Drl4WTJGkHd1V7RPHSTcb9utsiSd+nXr0ZcdlVFEzponHCnrapSADdlxacdvsvQz9Vbdx7NjJVibg0UR2Xry+DV6m47PgWABWouYjlrCZljRfUruZ9SiphXkty8kN2O8jtMAttlnEisHTKzGAwxBlDJZ8KhMe6/87sP/5TJ8iX00AZi1Y1yndl5ZIcMQaNXt9Bu/kR4GoaROgPe1O9dnDHzJFWcGZ45pwG4Spmqa+MLmq94CMdZFuiUUhEJ3xKXVS2+e+cIsRS1NyP6fRSFiwRylSl1XQe5gDJ718Mo5eZdkIqUEiqtQ6gESlhHHFLOqNjGh9c4mDrTWA5hW9PuVhCHp6FZ8bvvxHZV3PMuyhUj4eyyZuU3wAQh+EcTy20TgztFLSNjz84rdR40eHpkwBS41a4wtLyUWKUadVoJ/oOlN7hjEFPi84kVCApcED9icxG3NRqpkrqNMn02/M61FB/gWwQTcMKAKAyMkbSRcZC2bUkrGy4vGSpRw0HC9Vs1yuiU3MwuOcsLpuiqHjXM3GblJxq0LKnmGA45KtyUV5u7+gtLHhhA0I8LtUYqhOIkjd4WEKX4zYm8232lsj79Vzha9AEfsOgDhnVgNJY7c9T6wtqmpVp5y2gaW7G8wfcA+SWIWXFT75K0a+sjch/B8e07PiV7xjiMIhDybbckxYVt/n4t8MLqCK4Z/X4QOQ7Qv0wow1gBn8Dx
 UWapcu8s
 g/Js1NykZCtjCezcaKiob3Ph4RD7FU+DrCbmE2U3HAcqw9dmLytwD1080rkSurqztKg+uoYeoYWJP5puVw1L0ZV3pB7GXgIGFQs8V3lheW/puXl08rXISBLgj8pJ5D98lBULt4pEv46M0rDAWcM8FerBbuvSpfed9JgBVumg1jtYsS1RfuxcFUDSJFrznrJ/f8/PafFfJsvE0PYW+a/3YFcLb5mhwjPtZm35qzSp+L+XwNug2/k+FAwy3FMuw3d9d6gnUB0s0StKooFXOc5Ng/57sA/ZYb3XJoFMdZP85LE2eHyNFJ/5OkeruOyDx6BPCge4z/PIfYBp2XytMOR0SwZ+m4F9wdNS0vVBNmqa3DTFDqJWAP6QWRHeKkv+I41ta5XlIFAqrX3AekuypHkabOG4IvzRDjNE4GtnwrM5TeVBWmByjTN5wnMSjNTIvhomLwoA0hb885SMZlw1+eXn9zbVQZqZgO/YSQ6c/QmWtA4VlmdubytaB0aLciF7rbmyDevcqWei9PJGOIpORzxrlC/q94HzyiblLMJHlHHXUJxjYAvaTTDjLXSd2b34H6Gk4rlG9S0+eY2ZR+pYuLU2ezrLoSuFMbi13/EQnY+rTM+6FWggdfP2Ac6WRKTvNNfCVU89iHM1ZADyeHK2FC/l6KGgwzZ843Wa40/dMYKD6ve4XrFg6lU90tlKo9II4kmoFn3wtcd/TD9IclZMXfrpAZTkNOSdecG/HyMdawA4qYWysA0GBk5s3EOX/zxwCPFNIfeuc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 09:03:23PM +0100, David Hildenbrand (Red Hat) wrote:
>On 12/29/25 06:51, Vernon Yang wrote:
>> When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
>> scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
>> reduce redundant operation.
>> 
>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>> ---
>>   mm/khugepaged.c | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 2b3685b195f5..72be87ef384b 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2439,6 +2439,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>   		cond_resched();
>>   		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
>> +			vma = NULL;
>>   			progress++;
>>   			break;
>>   		}
>
>I don't understand why we need changes at all.
>
>The code is
>
>	mm = slot->mm;
>	/*
>	 * Don't wait for semaphore (to avoid long wait times).  Just move to
>	 * the next mm on the list.
>	 */
>	vma = NULL;
>	if (unlikely(!mmap_read_trylock(mm)))
>		goto breakouterloop_mmap_lock;
>
>	progress++;
>	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>		goto breakouterloop;
>
>	...
>
>So we'll go straight to breakouterloop with vma=NULL.
>
>Do you want to optimize for skipping the MM if the flag gets toggled
>while we are scanning that MM?
>
>Is that really something we should be worrying about?
>
>Also, why can't we simply do a
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 97d1b2824386f..af8481d4b0f4e 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -2516,7 +2516,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>         * Release the current mm_slot if this mm is about to die, or
>         * if we scanned all vmas of this mm.
>         */
>-       if (hpage_collapse_test_exit(mm) || !vma) {
>+       if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>                /*
>                 * Make sure that if mm_users is reaching zero while
>                 * khugepaged runs here, khugepaged_exit will find
>

This one looks better.

But the sad thing is we can't remove this mm from scan list, since user may
toggle this flag later.

>
>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

