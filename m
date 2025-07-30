Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD36C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 14:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA3F6B008A; Wed, 30 Jul 2025 10:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9866B0092; Wed, 30 Jul 2025 10:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A998E6B0098; Wed, 30 Jul 2025 10:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9AB516B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:10:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 192FEC01DD
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:10:17 +0000 (UTC)
X-FDA: 83721115674.15.E4EC108
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id CB9F240002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:10:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b5nMs5zt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753884614; a=rsa-sha256;
	cv=none;
	b=IhR14CYsFUzb/qjr31K+RecdY4pGkwgVqQ0hUvQ3+WbOtNEyVXdJar+aDH6NGqnE/mOgq/
	t31DVWmVbl8DsrRVyuqmoDxbSr+y+J7GIgGwTPRwVPidBxrrtglazah1I89FAfy2uiXoHG
	4pl7Gq7PkYXH+um0srLOpraw0/phVGE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b5nMs5zt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753884614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gnZ654VJktjY7DlJyw7K20uF9HlUxbvhJdrYHHl0LaA=;
	b=asDPJHOhHH5YaA8e0i6YmdHKBTFrPv0DQfcfdsvNgaZDWx1EFYKdzrssQ/iJUWOYfhvRTh
	b3aTreb6J9zGmVh98wqN88Xw/w4H9W2+ZFWsrpNCv3988HeTz7UIDZ9pW2ieA+BdyfzqKT
	8ptMzvwB4zpmTVP4FZ1Jon+R+HCXEQM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753884614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gnZ654VJktjY7DlJyw7K20uF9HlUxbvhJdrYHHl0LaA=;
	b=b5nMs5zt27oxg80sO/x1jJ7II4kJm/IdtwYJfhN1pPyblh6AVCbJeTYsA7xjMKYyYsq7BG
	DHuDFxoFB23QyvBVMNi57HTgNxdqUG9V3F1LZWBXKK81UbfTvttNQL13je5Hj5NSocWjma
	Dxkhvf4phruPI9gZY/Cz7GgwLmwg8zY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-K9bUFRONN2ypURmtyMoqqg-1; Wed, 30 Jul 2025 10:10:13 -0400
X-MC-Unique: K9bUFRONN2ypURmtyMoqqg-1
X-Mimecast-MFC-AGG-ID: K9bUFRONN2ypURmtyMoqqg_1753884612
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ab7fb9c2d3so80700351cf.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:10:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753884612; x=1754489412;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gnZ654VJktjY7DlJyw7K20uF9HlUxbvhJdrYHHl0LaA=;
        b=W2dNjb8k380li3Bt2wRY2vvaUTsgFp2BK/GTDG3SgFv4vtm8julSf8KFrLJzUZbTkZ
         PT1zIHcLQXwhuQtF6j1/BK5evTif77rD9bh70SMufbPQNOrPTTX+frY7GY+OWwEAR915
         ixmLwm6CrE0P+Edj3fNYZUp9Y6WYav50FRd6J2+xSonliHTayUFINUiNQJ4b5uIYgQMD
         ObGianIwPmuj+KsAjaZAhlIIIFU47YFGpySyXy+PeoC/k4/gwYYOZg0cGER+OuOssxc9
         g5JCY5StBOWCXBuoDjx847gg59wAGtQnym1vd2un1DTkFxIeS4e+K+3yBAU9wrtcnbJF
         aXrg==
X-Forwarded-Encrypted: i=1; AJvYcCVswU+K5MxFp4gAPWotS8eGMiwJkOjVhWIJu74uVfFTEN2U+WpE6GMojTHRtLGfQmKRiWhLFihAlw==@kvack.org
X-Gm-Message-State: AOJu0YwSjdhBpuiXnOBOhKd2zFhacN+vayC2RQvOkK5PK4DZeJtl/ZG3
	yH/gf8XphiDNAeQrb8yeidSuGqQl4y0IUJp7XiMYuLMpaRE3GrwjhCUpdUr3O9vI2pn6577huhg
	j8MVK183/lpd5xqla8t+q3QmN4yWJsHwyjoI0JpiC2xUdfkxB4uq15/tSiGNM+Hjznw==
X-Gm-Gg: ASbGncvsQhBHiXm5qDsKLrGtAiyCqyoHz91MYD33QqAoKAON7/E7jnOpDLzQT4Qjfei
	syNF/+gG1ANkUl9vDW0mlvvKZ4a+/kLNKZX1VnsTANdS+pyReVN+0kQC2wE9KEsQrzeM8IZ7xgi
	llo8bOxQevaC9IQxJIj0IuPxfnCP5pvZ8IOVYx8NAej3wJDk+zpdkszysfXAjq+ubKHdXjSvPyK
	XGwQtSOYh3o77p+AihEx4h2b2AbsSbmNPjtVRNXNwUzVy7rmVAxQrs+woxtERrcssLVRfb7M92B
	kAk28UdjjfPclt28DlOoSdW664DmxJ/puLPei8yb35tI9sroY4ah9qU4fvL3zA==
X-Received: by 2002:ac8:5856:0:b0:4ab:801d:90b8 with SMTP id d75a77b69052e-4aedbc3c248mr59348511cf.32.1753884611813;
        Wed, 30 Jul 2025 07:10:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRI0a4WBkLYn70H72HNhtziWoHC5rtdHpSwJbmWuGXwrUwXU1BeUaWjWUTF/B/xcEp5ALnHA==
X-Received: by 2002:ac8:5856:0:b0:4ab:801d:90b8 with SMTP id d75a77b69052e-4aedbc3c248mr59347531cf.32.1753884611189;
        Wed, 30 Jul 2025 07:10:11 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ae99573cbesm67000691cf.30.2025.07.30.07.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 07:10:10 -0700 (PDT)
Message-ID: <72485de0-d05e-4421-9b47-3449778d278b@redhat.com>
Date: Wed, 30 Jul 2025 16:10:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 16/29] mm/show_mem: Annotate static information
 into Kmemdump
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-17-eugen.hristev@linaro.org>
 <7ecaae9e-a088-4c1b-9caf-6a006a756544@redhat.com>
 <9843578b-2adb-4f6f-b3c1-99dac003e2bf@linaro.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <9843578b-2adb-4f6f-b3c1-99dac003e2bf@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X8ffgY6kxkvJTybvH8iJ8Bpq0JAmoIr5YVVVEGn0trM_1753884612
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wbbrwfyy6x4gzwxzrn8m81uqkktmh3cz
X-Rspam-User: 
X-Rspamd-Queue-Id: CB9F240002
X-Rspamd-Server: rspam02
X-HE-Tag: 1753884614-138430
X-HE-Meta: U2FsdGVkX19E/daN+LAbc1EYxPC0fOhDaAPzNS1pOhdxXba9tFr3UMH91IVhizVISPk80dZyPrwBCOEqAzaj3uMTnbX7ToxCV2FeovZGNYitoz+FEQL0QxgYiyeLqJDOk16rg500mP7WDpZ90Toy8eW2pgs4+UirHrMEY4q3Vq6mOytI9ESOAGx/XHv1t0RJricotCQZHVNhnA9GPl+aJmZrl8k/exsrvYkNavbjweZ2gHeIiBPvipyZsfxrihKaaCw/hhRIeFoF/DWMtZHcIQS7SUHFcLaw1++xzUNuJXFvBwAI8yl9YfIqEC4ub91/M+Xvuigj2BVpK7KDwr6cqfvrwhYmCfICtorbJkrU7DRPBUDjuPaNzG+Ydnt7mwO5GuQ1kxzDin9SmjNbeVk2pyNurJ96XH3CxUt4Ticx53la9wizNS2DV6p28lkUpLFw+gKlokXlOM2snrZa/TDnF1DhssjjNXnqHrVzMOCSRV8VRnoXhdSzPqSaEQJsWnd828lJjhgJL5AYHpYqdL55v9QNKKbHsTjEpiYdfgG70+SUjSNe2RwSvNetKOr/rMzv7fCPSNw1B0sCn01+YDxnGf6s4VdCRGNc3SgVYGrPElynF70t7g3wkL5a/FGxnfXLCbTRKaftxxA7mK0izWvxHSvUygPgaS5mXVAC4ZfOmcvdJE6l40WPfb8EAN/GN7G16rXQMtOdI4U0xv7QBE2rSUlD6H7ZVK85bFQDW2a5WU+YAQAQJTnXn035HKoHU9BYv0y0LijT3pK4R+QbcPvoKOwmnBGl73m+KBn+go/7D5PqGMe60CPn/h9bPEC3nuU+PSIudRYLOeRVbyR9UOzuHLnxgvkYgJsyqiadc0U+TzvEuIhPp5iI3EZpnEKzCXimjQeDryiAHAPoKzcZc79CZR10BbvIJ419OF96c+WiCWBke0JuuzuMV9kSnMi4WU9aVQijsPmkEjkOzGwHE9c
 LPa6GEUO
 BCxrpCOBM0BXjloZrIqEEhnuwtTH1VrJv3gmGHIZQfHMX7sm/gaLpSxqU7Bcc+JNc+BbLEu+O3xJRWXYPKQxMKzGUolHLoGo/juaa3HsVkH2u0uV5eygEuj2FSPZTEVshsWfNZFbdHN9MKwBlAPIs63IPvKS0nqutjuOifwXRSMAh/tzjeh9qeWQOlQSdlRbPqSQFc2BpyqkiPjVMqyVBIySISN5saQ/XK41yj80yC7YFkrsdMhBDJ7DgHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.07.25 16:04, Eugen Hristev wrote:
> 
> 
> On 7/30/25 16:55, David Hildenbrand wrote:
>> On 24.07.25 15:54, Eugen Hristev wrote:
>>> Annotate vital static information into kmemdump:
>>>    - _totalram_pages
>>>
>>> Information on these variables is stored into dedicated kmemdump section.
>>>
>>> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
>>> ---
>>>    mm/show_mem.c | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/show_mem.c b/mm/show_mem.c
>>> index 41999e94a56d..93a5dc041ae1 100644
>>> --- a/mm/show_mem.c
>>> +++ b/mm/show_mem.c
>>> @@ -14,12 +14,14 @@
>>>    #include <linux/mmzone.h>
>>>    #include <linux/swap.h>
>>>    #include <linux/vmstat.h>
>>> +#include <linux/kmemdump.h>
>>>    
>>>    #include "internal.h"
>>>    #include "swap.h"
>>>    
>>>    atomic_long_t _totalram_pages __read_mostly;
>>>    EXPORT_SYMBOL(_totalram_pages);
>>> +KMEMDUMP_VAR_CORE(_totalram_pages, sizeof(_totalram_pages));
>>
>> Tagging these variables that way is really rather ... controversial.
>>
>> As these are exported globals, isn't there a way to have a list of what
>> to include and what not somewhere else?
>>
>> Not sure if any of that would win a beauty price, though.
>>
> 
> Annotating the variable was suggested here :
> 
> https://lore.kernel.org/lkml/87h61wn2qq.ffs@tglx/
> 
> It does not win a beauty prize but it's simple and efficient at least.
> Do you think it would be better to gather all the annotations for the
> globals in a single place ?

See my other mail regarding VMCOREINFO.

-- 
Cheers,

David / dhildenb


