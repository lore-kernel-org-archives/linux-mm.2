Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46360CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904658E000C; Thu,  4 Sep 2025 02:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4BC8E0002; Thu,  4 Sep 2025 02:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77CDF8E000C; Thu,  4 Sep 2025 02:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60BA28E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:38:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8383160A42
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:38:58 +0000 (UTC)
X-FDA: 83850615156.25.55A0560
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id A650840002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:38:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QeoahpyV;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756967936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40Z8U8FYm63hOytZFsIyiHCS34GyMGG+MWJKFpyeOIM=;
	b=wd72vm1v7TS8uFkIzX9/6VXKRpS5voMpWcU4xCBaQxFndq60qBMM14fVsbAUC8yTDAUr+d
	aZiYMcQW9J0HYkN+DLEdM9zy09wMsZyXUyw5wDl/+Dr0RvjqlekuKZA+DGuOGjShBIreUw
	u0V5DZmMmdPJ8+APW6xJyvf5yvMYCv4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756967936; a=rsa-sha256;
	cv=none;
	b=payhaXQD+iNILBLZvPDS2pv4O60rHpz0Y5BnUxXlTeXB/HlBhTunYTIa6p4s9RMqxBG4c1
	7Jo+AGuj+Cajw/P6NfavK97QJHZ1SKJYB2NroRwWHW712U3v5qbWYDXRNRmQ8lYAfMBkEF
	v8j/zffZmM6CFrvrY8Byn3q7hwIEHt4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QeoahpyV;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756967935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=40Z8U8FYm63hOytZFsIyiHCS34GyMGG+MWJKFpyeOIM=;
	b=QeoahpyV1+aNTJtG8fVAA1SVEttAGuVLP2BlsFRcVttPVLyMVXujNsEeT4i7Rxss3uql2E
	T5r2iLFmoj7atDU1bDzuaqfU2kv2tlHh5faB7P2PuA14xpMOV+yQBzRcXgzSfVPe3QOmsC
	6DAAO2NgNZfbrDJfv98SYjtfUfL02Dw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-_3OfDqmoM9acmvVpRh6tCQ-1; Thu, 04 Sep 2025 02:38:52 -0400
X-MC-Unique: _3OfDqmoM9acmvVpRh6tCQ-1
X-Mimecast-MFC-AGG-ID: _3OfDqmoM9acmvVpRh6tCQ_1756967931
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b467f5173so4905535e9.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 23:38:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756967931; x=1757572731;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=40Z8U8FYm63hOytZFsIyiHCS34GyMGG+MWJKFpyeOIM=;
        b=RPngwRn7xiSKQt4EoytyVCEwEACDrJMhoP4cAbYhe3mwd3w+EI4HjFAHDeFqbvug6J
         sXlCj0ipsxlmpfqZLBK3wAHURXtIR6LWmopS4B655xEkCUHIDPaD1vGZyzMa5wIGxFQm
         MIgJg1Uwv8KcwjaRaWGPN9nDq84NmNIQ9lrsOrCJHmOE7UxDY3oxx9wOcaN4Eqenrnjx
         3iEkeJSNiODxMuLa8bk24GFe/DKREsyHJhpkV5IBe0Vi6PGHjerhPN8OqzfMbJiTuV8d
         P7bl8SK4hk3D7SY1w89tQkNGDQ+2vJoYfhvR8j2SD8BDMNd4HfyYcm3Q3P4xpzOdlD6k
         2WbQ==
X-Gm-Message-State: AOJu0YwWlDveNFEyIgZw9bcU1HO3aShTqVNSF3ymnFcSomsFpSGceGhM
	AV778+2mCjIwE3nRCDTesPegGrtBL67/92WU/9GCDmRYQNnk4cGyCw0CA24cxT89aUmnSuUbOid
	PA9jB5my//MoTWqKrH2bfvq5nCMkxJPkfqxnWGcGPwNYHmngyYYXnCmRca5ab
X-Gm-Gg: ASbGncthR7Ach8mWu5v1fIlXvdeAWlIL+o0c2mVX9OpYDn6a8UdISa7XY7TgY+iuVLL
	KzlPWq9m5pc8cPfIUMEWpNO2a6FN6mnyENopQtnN4wKr49+38kh+XzXxZCwHyFJS7ZICGPAN16O
	zzjUSqTEO7AdIUsFvXAl1LhQzNRIbghzwv2chJt0g+9lOhQ0zomQl4H/iWk/BkWPho1iWOwmfFt
	SOVByQJNVINSxOBNjZv3+vpAf+/JVQe2d92dFyZP2AP7EipLDHaXofEzqRSuvcblOgQzmL6wj7R
	GulOcYBc/enidK956uNSCT20xJBitva9Lu4VhtzLTN+Gs5AKB0lMltRw46d7c7Fx8xuQJYth5fm
	UTEdRA1dANtaVEjXeMvwiAvg3fIFzutYKLEehK/G48SNuuMdBR7HEAG0mLTLiOIHB
X-Received: by 2002:a05:600c:3556:b0:45b:8822:d6c4 with SMTP id 5b1f17b1804b1-45b88321ca0mr137720215e9.33.1756967931108;
        Wed, 03 Sep 2025 23:38:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4fbUuLgTZZ7JLLGMEzoqz2HZIPqkmpwKL8Svwx4GbQWyjvTjQ1L7Otc3gHyD/LyUPfk7JPQ==
X-Received: by 2002:a05:600c:3556:b0:45b:8822:d6c4 with SMTP id 5b1f17b1804b1-45b88321ca0mr137719985e9.33.1756967930648;
        Wed, 03 Sep 2025 23:38:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9a6ecfafsm106759595e9.21.2025.09.03.23.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 23:38:50 -0700 (PDT)
Message-ID: <92bfeeed-41b4-47f1-894d-ad003b4714b6@redhat.com>
Date: Thu, 4 Sep 2025 08:38:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix kernel stack tagging for certain configs
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Kees Cook <kees@kernel.org>,
 kernel test robot <lkp@intel.com>, Dan Carpenter <dan.carpenter@linaro.org>
References: <20250902175903.1124555-1-vishal.moola@gmail.com>
 <f41383c3-913a-489a-82e6-d2c8d5519eed@redhat.com> <aLdOLQLjt-A1DBGi@fedora>
 <b0ed22cd-ebf9-41f7-b5fb-6fb078db593e@redhat.com> <aLiFK8sIgbfiK-v2@fedora>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLiFK8sIgbfiK-v2@fedora>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cKqHOhStYNqPQKlEgTpHZ096c0QYaak60hNOHZvgoZQ_1756967931
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A650840002
X-Stat-Signature: d6h6ewo7dysgxyx1b8bu8f36m5dt6cqq
X-Rspam-User: 
X-HE-Tag: 1756967936-836458
X-HE-Meta: U2FsdGVkX1/hUuxfgz0RrSpd2Ajzbheu0HeVkadcp1Wj6RE/yfoSgOwiFGkY9RFocvpr9gud1xy/RVKssnziF6zypSBTBwTAGryn7TprgnE3UzJfttHTIzOj27S4BzDUw10ahEmiMiqhe7guez0a8KaFY7dttdNQVzVBCDDg1Q9mZrqgzgnE4/cDib5NWG3AtsG9I5F/jSrn0vIEyJPZ+tUw/9uC2w1rpGQYHWfdFc3Z/yq7SNR/8IwkizWY3+rJiSoU1695Qr4GgdlXF/2IHhDGP3e//7iPLMdIPNxHFxuf1E1HtRDNCK+VtLHwv3eGX0AIGdAnAcjs8IaoLKL7ykL5r/OcCXJ5zTcNF0QtXBDc0uyq0WnblkN1LXtQQ/fnDHhGF7KtqDpCT4T49/a4Mlyi+XW4GKNRndjPVQSijfzPKFMGnbZVP1xkc7js1AMyCoRwl1/FWIfi4f49Qk6Mss4mruy1+3f9xMJi/bU2c+Jm0CGmESBxb66HP93GiaNmxkQtE6OSEiB/DuyzBPKULRw6gmI63+yav6Mog+tDPy2DDDA/mquF+hCpzkQMm5QUFEwuzfB+VN8blKttKs2V7AzW3JSAwiNp9stSUh0uGOoyVzelKCM0rUooJXjksd4IMXzktzoqOkCiz7knASg2o48FgWRrrYzVZSF0jLpkzepjXx3MCMuke4SYvjTaecTIEDYhpWBtLTTsG4mAZrwNbYCLpBpOnfEB2fL3Syk/VKajA/QHSFLU+z7jw01/XxKczPbm5AE6lxODF6qFe+dx3t9tOEWGTmXmNcrEXZ3OEaKeocqm/np1UiVdLdRjMa/LZp/4NwaDACp2G/hRVIWW9kdH4+M6y0b4ZWbhPoE+SSFF0zV1CYpgNiX5aaLfLzTbD/zKZgSaT6zPUKfsA6GIReIdVoKKjPevzpMHNhUsvWLHzz11aUiZ4XOWDuORTuC9rqzC1vNonFwdp+9jjnT
 PwpkoWvG
 JpPd17vMBmBUNm+2EuBgrR6KRQbkp4eooGiy5w1qR2wDtG01YlL7fYbt0K9VfOkjytMqfarhzCXevVna5vsYvgNS8aCutULHcA9NkavcGbfsK88c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 20:12, Vishal Moola (Oracle) wrote:
> On Wed, Sep 03, 2025 at 09:46:44AM +0200, David Hildenbrand wrote:
>> On 02.09.25 22:06, Vishal Moola (Oracle) wrote:
>>> On Tue, Sep 02, 2025 at 08:23:06PM +0200, David Hildenbrand wrote:
>>>> On 02.09.25 19:59, Vishal Moola (Oracle) wrote:
>>>>> Commit 4ef905bda61f ("mm: tag kernel stack pages") began marking pages
>>>>> that were being used for the kernel stack.
>>>>>
>>>>> There are 3 cases where kernel pages are allocated for kernel stacks:
>>>>> CONFIG_VMAP_STACK, THREAD_SIZE >= PAGE_SIZE, THREAD_SIZE < PAGE_SIZE.
>>>>> These cases use vmalloc(), alloc_pages() and kmem_cache_alloc()
>>>>> respectively.
>>>>>
>>>>> In the first 2 cases, THREAD_SIZE / PAGE_SIZE will always be greater
>>>>> than 0, and pages are tagged as expected. In the third case,
>>>>> THREAD_SIZE / PAGE_SIZE evaluates to 0 and doesn't tag any pages at all.
>>>>> This meant that in those configs, the stack tagging was a no-op, and led
>>>>> to smatch build warnings.
>>>>>
>>>>> We definitely have at least 1 page we want tagged at this point, so fix
>>>>> it by using a do {} while loop instead of a for loop.
>>>>>
>>>>> Fixes: 4ef905bda61f ("mm: tag kernel stack pages")
>>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>>> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
>>>>> Closes: https://lore.kernel.org/r/202508300929.TrRovUMu-lkp@intel.com/
>>>>> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
>>>>> ---
>>>>
>>>> You sent the patch on August 20 and I replied on August 21.
>>>>
>>>> I did not receive any reply so far.
>>>
>>> Ah sorry, I didn't mean to miss your reply.
>>>
>>> I can't find your reply in my inboxes so I definitely missed it somehow.
>>> I'll go find it and respond.
>>
>> I had a mail server config issue on one day last month (sending @redhat.com
>> through kernel.org :) ), let me check if that was on that problematic day
>> and it might have went straight into your spam folder due to dkim mismatch.
>>
>> So the mailing list did not reject it:
>>
>> https://lore.kernel.org/all/96148baf-f008-449b-988b-ea4f07d18528@redhat.com/
>>
>> And yes, indeed, it was on that problemtic day, and there is:
>>
>> 	Received: from smtp.kernel.org
>>
>> So, problem on my side. Willy already replied, but let me resend that mail.
>>
>>>
>>>> And now I realize that this patch is not upstream yet and the commit id not
>>>> stable. So the Fixes/Closes etc. do not really apply.
>>>
>>> Gotcha.
>>
>> If there are bigger changes it usually makes sense to send a v2, or a simple
>> fixup as reply to the original patch (I prefer as inline reply).
> 
> Ok I'll keep that in mind for the future :). My mail client loves
> attaching the fixup patches as additional files, but I'll find a workflow
> for inlining them.

Oh, I really just format-patch, gedit to then copy and paste.

Just be careful if your mail client wraps at 80 chars as default. I have 
Thunderbird plugin where I can easily toggle that (Toggle Line Wrap).

-- 
Cheers

David / dhildenb


