Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E206CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92BFC8E0008; Thu,  2 Oct 2025 03:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903B38E0002; Thu,  2 Oct 2025 03:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819BE8E0008; Thu,  2 Oct 2025 03:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E23C8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:25:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02A70C0386
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:25:44 +0000 (UTC)
X-FDA: 83952339450.22.7077C48
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 212E21C0006
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:25:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jPdxIqOP;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759389942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c4xIEgg73HiwWMLp7GOfj//rAKG412fVdAUGiIOFvVo=;
	b=RENSCt/KGeIQ2AMSXOE53A+WiOMw1xOPA86WfSivH4cTpJ+NdBCppZ1DMO/dkelvQzXf3/
	Tc98dOv+o+qgiUEB8kw79zwiAImIiKWY78BORNR8lCtgv+oXvhEsfquGfuBzEma8aPP/Uu
	bLtjWZ+WPZUjFFy3Xl8JMqlyGGU8N7I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jPdxIqOP;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759389942; a=rsa-sha256;
	cv=none;
	b=HXnMOQAmDrMhAk7ocOUeGPovCq6YcF1f7lr3T8xy8xkdFW+siEIz2AfjX4YHBP5TcuzzYW
	gEQyWoFCXQ8zRpV9GP/8FvbselpAuM3uA4n+Mq09krtaMtzlb3UQDMlRqgw1mY/in/lemY
	0my3ow69eeiU/pAsOSZEtnwlkaEZex8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759389940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c4xIEgg73HiwWMLp7GOfj//rAKG412fVdAUGiIOFvVo=;
	b=jPdxIqOPs8TmIPN9VnFin9k/CDk+q4rahjGsw6giTkmMpwq5L9/j9APcmNNbTqUlBuj4tO
	XDUehejBLiGwVIGsVzmxtIDQaDTzvVIJGLM57VxJu53WXDoFbb3jmp5PfSrDRezFQ9fc1a
	Ff3QemXZt0iyJoWKJzWKJX3pUq0xoP4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-iGKjJuwUO3Cmx5lgB4Nvcw-1; Thu, 02 Oct 2025 03:25:39 -0400
X-MC-Unique: iGKjJuwUO3Cmx5lgB4Nvcw-1
X-Mimecast-MFC-AGG-ID: iGKjJuwUO3Cmx5lgB4Nvcw_1759389938
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3f7b5c27d41so612829f8f.0
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:25:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759389938; x=1759994738;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c4xIEgg73HiwWMLp7GOfj//rAKG412fVdAUGiIOFvVo=;
        b=q/r8IewQrxLo8fK+5cGEf5gk+WI7QTfu58ZZLjjkWAe245qg12xbH4LS40VeMXr2VS
         JANW8DJTxGTM2Oz3eIV6Y3tVelfgPOyoHqE8bKYv7Bd6xsZwGQ1imqcl6zie30ktrEI7
         avxoM0t7t3H1XxxZzRBWznwJ56pLpoJPmhs6Y73SZru1fJB2FUTPEUAU7IswllKzdbeB
         Y2oRZgTHxRTy60J56wdJYaj1OjDLoQBX2MzuZtjFdbay4hAql9DnpOzWVLwSvi2cwZ+A
         UR3Zbg4sjq51yMfGp0S2jmFPHd6VCKEMUfU6bZmT/pT4Zp1zPl3I9AyzbtGTk+RB43fJ
         GsBA==
X-Forwarded-Encrypted: i=1; AJvYcCWILwU86ci2LWxYkQA3+KoUw12PZoiVF5K/0d+eDfe2xzCbWec34YvtUzhIwK/cgw9cMLwY05f29Q==@kvack.org
X-Gm-Message-State: AOJu0Yx6/qVwOrMWgUXgsxEyIwkuKuFMO8fAHSXJS6s3rGrSjyuamHyC
	hCBD15k7SY4vlBLZ/ZxDDYyYERFWE0TDNhpdi9ofgG1JHDwfndziAyXtqy+gZoXJMj1wSAvwJyf
	FWeasWmPN52TEcxyITp8Kj1N3abOU7Lyqkk3kSYbEHVhVWfy8nTYU
X-Gm-Gg: ASbGncu3Le5Otht2ZqL9vdLKVxT5wzvsHe5qn9+nhjKQyC28UlVCxyz/wLNH+OTvtRA
	yxAYEA/GCPkL2xs0+mvxM2X99LEde6vWPSLNCj55nUgxG1jbOGDznWKXvJGD2zxKdvN+Q1vlpIL
	vG+q4dv9Rewigr3Lx550/zRrTeVfqngmRzCNEyNfJCKhdUkE5yAaJ3mOc8yFw/zr6qDTZ8nGZKt
	etwxlcjKXPunK+R8hc1pABZVgcpMDIk0I5yHGxb/lP0ZX7aWhpKmlI3iMWuL90tOaEBfaUEWXo/
	B+Vo+urx73YurBcyvdyL+7yZuGnLGdzobOJN5zdedHQbG3nuEoZ0wQyX+v23115TVYUtG2M7NAa
	3bIakZBnl
X-Received: by 2002:a05:6000:2010:b0:414:c2e8:a739 with SMTP id ffacd0b85a97d-4255d2bca04mr1474100f8f.31.1759389938010;
        Thu, 02 Oct 2025 00:25:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNuBjmSyWl0STGKz3jAGnCdlEY5ESG4JKemsoi3Wwx/R4rsYUPytBl7gz7zm2+UlaW/QHtHQ==
X-Received: by 2002:a05:6000:2010:b0:414:c2e8:a739 with SMTP id ffacd0b85a97d-4255d2bca04mr1474080f8f.31.1759389937505;
        Thu, 02 Oct 2025 00:25:37 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f4ccesm2253063f8f.59.2025.10.02.00.25.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 00:25:36 -0700 (PDT)
Message-ID: <7eeb2a80-a73f-42b9-9f69-e2fe9fb824e5@redhat.com>
Date: Thu, 2 Oct 2025 09:25:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: jane.chu@oracle.com,
 syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, kernel@pankajraghav.com, linmiaohe@huawei.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org,
 nao.horiguchi@gmail.com, syzkaller-bugs@googlegroups.com, ziy@nvidia.com
References: <68dcb33a.a00a0220.102ee.0053.GAE@google.com>
 <2afee6bb-b2f0-4a86-ba8c-d33b0b477473@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <2afee6bb-b2f0-4a86-ba8c-d33b0b477473@oracle.com>
X-Mimecast-Spam-Score: 1
X-Mimecast-MFC-PROC-ID: LymWFeuJiv609uyQKEDOSQgunTjUey1Rw6QvRJ92qWU_1759389938
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 212E21C0006
X-Stat-Signature: tfstir7o3t5z693kkzohz518aock5zss
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759389940-862469
X-HE-Meta: U2FsdGVkX1+5/GsO5mUPZcxLx66l8KdwrRVlKB3GSH+cB68mVLmQj0+IPOpzXodOeVTs9OwHekv1gJMWTAL+R6HlE/q6yNwxLdxubgg2dxVoPamrVjbfilJGq+m0pylNEugAuBXOkIK20a5TFvSFrvxqfmv/w79ClqXNjtzl2GJUbKR4LOS+yehVVmsoX961C1/BNIP6PHBSBX/P7vD2aPhlJR3NFfx80XMqKHTao21f22qhPwS9Jm2Rqxq3//+q2wwjCaoend9ZX7G9UrinjWFYF6INh8DBKc+sWvfyWDFeziyusv0dVt7zZu2ArfmorZQxKSnHLP9knbIAeEOEvWOPTo2mwTDSnigPUsIA8X+YNXkogp0yO/mf3XZ1amD50qtxv4Wvbg1hBRZNlxHFHAC54aSTiVq1XAFlshybTrgenMAo/L7BasIHpLlw2U9mXam/OIH46qkDOWCFKJUePCdnyGkzR5IcAcB4zevUllA/W8EyPJTGR/BhybEC5ldBCf6wXk6IT91D0NWrL9AABuR3ULOGyJg94ql1SSs6VXncrVE4NPHgog1UXirEV5XE+V4dtaGhDEs28ELSK+eao5wNZYUb6tlErkPVnqLmf1kJCqEDx3ujdtGhucRX0pYH1KBwL+LWe/I2nzmg9wuh6UXcyvjq5utvrTvFv8GLNUaO6PaDG5fWJvuZkdcpbDlnE8a1QCaOJe/K6JnIvr2nXUfKqyeCSl+06JO8/iQ1iV3sSx644gD2LtWJxl41UwjHh2pmbGRCngseWV+rmpLedFGsi8E2aodx3+8pdkPGL6JUHBglS3vmu1RekKghNX5umAHci6KN1U45o7KUOZONHopLe5wWm2ySG8KzIPJLtrXJyUrKyEIDDzd4OM/+q+VV7pXPl4yc73gu9NDMMH1KHuoVuNhxxz/Zdtv0Y6W74LAPFbgX8vj8i6629VGYVxFRd4c+D3txk+iW1dZori1
 tcmwkhjp
 GEwY0KBjdap0Mq48zMRjwtV4z8A5atL80GQhJkvQ7MY1rTVUpXK+p0JhhmLwQPvN3YRgZeoZH9HVdC3QndA9iMl2EVOnZNf3I4emrUPnbyiQMerI16WXaAaKVHFACs1x4gagBlMACAovzwBqXkcp63KdyfELL2AYjpsUVWu0obztud5a6l6gwgAhbW4lHag/QCcBO+5jLpYjj8jUjZLqdAAk7MlCdcEeFWZVtg7oM3fuV0ih8hAvaSjeNJeXn+SKIdvb+B2nWK4yod/VHFMEQCt0MZwbjskfOWANE3nTM8OgCCxSFm5Cl4p8kSoANfxpil2biNscrSbZDsjAItd/TIix4HyV6IZhvAZH9S07LbxHrU0rDn2x4sQ+PdWiNwGYNvbNgV6zYwXuSEnZn9APxX7wVdtyjPRdRMf6EObbAivrSKS8YhfAQJwsFHyKuHo4dGHt6TIYVxHQyRgmh50HtMK7DBHbLSeyBpCB0MWkLmnRZcm8mCdxo3npGUI8DOd07yVbBlJxFXlaNpIVX8bl03uOOP/8NF5y8R6UCppUi+K3wH8zKHLH8rCz/9jr/UCZiFIOP8Pi2JXxnxRMOb6zZ9lhlVtZ+aRK3UE4OwSv6pEjUpYnZut51d/5V+082KT/yBlnEMpTsN0IjOLqB/rUOTai3aFyEJb0v1oEM4eBz8hq6BUVlEG5ymGF2OhXEQX4krHlI6ypQK/s6YUzu7PhsJM7a+bM4JyquVUgKGBvcn3oc8FvidOERhFCBExQggrjDjVgyuGFnA2ayYMTboEVCY1meOUbjHhw9hRJF98HyAUgauj/oM4yYxm//jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.10.25 01:58, jane.chu@oracle.com wrote:
> Hi, Zi Yan,
> 
> On 9/30/2025 9:51 PM, syzbot wrote:
>> Hello,
>>
>> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
>> lost connection to test machine
>>
>>
>>
>> Tested on:
>>
>> commit:         d8795075 mm/huge_memory: do not change split_huge_page..
>> git tree:       https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-for-kernelci
>> console output: https://syzkaller.appspot.com/x/log.txt?x=17ce96e2580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=714d45b6135c308e
>> dashboard link: https://syzkaller.appspot.com/bug?extid=e6367ea2fdab6ed46056
>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>> userspace arch: arm64
>>
>> Note: no patches were applied.
>>
> 
> My hunch is that
>      https://github.com/x-y-z/linux-dev.git
> fix_split_page_min_order-for-kernelci
> alone is not enough.  Perhaps on ARM64, the page cache pages of
> /dev/nullb0 in the test case are probably with min_order > 0, therefore
> THP split fails, as the console message show:
> [  200.378989][T18221] Memory failure: 0x124d30: recovery action for
> unsplit thp: Failed
> 
> With lots of poisoned THP pages stuck in the page cache, OOM could
> trigger too soon.
> 
> I think it's worth to try add the additional changes I suggested earlier -
> https://lore.kernel.org/lkml/7577871f-06be-492d-b6d7-8404d7a045e0@oracle.com/

I think that makes sense in this case. I earlier said that I don't think 
even splitting makes sense in this case, but as you say we can actually 
at least allow for reclaiming the remainder of the folio.

Even though we cannot proceed in handling the remaining large folio 
later on.

-- 
Cheers

David / dhildenb


