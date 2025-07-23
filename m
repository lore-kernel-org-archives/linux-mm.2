Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDCDC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85EEE8E0003; Wed, 23 Jul 2025 04:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836C38E0001; Wed, 23 Jul 2025 04:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725198E0003; Wed, 23 Jul 2025 04:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5ECEC8E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:42:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 130FB59D70
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:42:56 +0000 (UTC)
X-FDA: 83694889152.12.38CC865
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9C9A840007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:42:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gOcwdH3U;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753260173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m016PQtjMJzQ3lrJfsjEi3M2oL5CSEZidrlqlSJ10Cg=;
	b=gN+ygFem1gGSCtveDCO4Qb4k74LEUMmzyTmAYUiz9BpmY53wGJO3ezUdIxGsmQHp7WA6oE
	owZXLii6aoJfGUMIq9NzL7FR7b6TlmJLkSSHC5oJMrHvw6lsoMHn61ZU1pATER9PioWamj
	LhpwGP/x3MHZ6T0bNA8cstV3m1AZAdc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gOcwdH3U;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753260173; a=rsa-sha256;
	cv=none;
	b=Qt98NDsW+9r2KuMMDN+UsPblebQ22vFFg1Uf9FpLsUI9GtMhWMnvT7Oa5G5x4XKV6Gw65L
	Vdgbz+0OvoeVOwjtWo3by5ZqfwtveBM0xvvDv9OoFrceRpkD1/hvcL9IuR58xGexPAVPJl
	XfJVEa9Yxixv15x6cSBVHR+iqU9HJAQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753260172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=m016PQtjMJzQ3lrJfsjEi3M2oL5CSEZidrlqlSJ10Cg=;
	b=gOcwdH3UtkC/Tr48y7wUsePuTmWJFIdqVj5pO/K7oMdSZ8rgdFZrgvQa5SG4dR79CP+eJF
	84ZlsM5nJzpjAGLQVuHwiH82kdSGQgSwknx2lEDRo7Cg8w2TqytBI244Bo863WykODS+yr
	Hlzaz2MTtf62ozWR21cp+Y6PMsO5/fY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-Z5HRKBY2MEOWuu-v6hKe8A-1; Wed, 23 Jul 2025 04:42:51 -0400
X-MC-Unique: Z5HRKBY2MEOWuu-v6hKe8A-1
X-Mimecast-MFC-AGG-ID: Z5HRKBY2MEOWuu-v6hKe8A_1753260170
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a50816cc58so2366851f8f.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:42:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753260170; x=1753864970;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m016PQtjMJzQ3lrJfsjEi3M2oL5CSEZidrlqlSJ10Cg=;
        b=E8UatX5/1KCDzghjqkM+Wg2Htcud3KiWRgsyLd72zw00kG7MNP6L2XcqzlkfiTlXfo
         CX1Gq6yFwxILzcHpcadSTsOFVxXGpFvu5BV8TalSFRuzb7kNfIJCxpGqlJ8gvbSeVlMI
         3cDP3+p5QTd15kHqBKvUr/wWibs1lTLvDq4JuLvmBQoSBrBUm94yBC3HJI3SvtUMvELO
         kM9U9yZq+5uH4Adx4h9NM/bPnXdplv/5TEVGmUMc/uuw95Kku4lBmH3+1uBNBg1tZXtZ
         R/CwfYH/eP/GKP1gCsH1kqBe+pzWPk1E++xda5NK+HzzeZw0NYgGlquDC8eS6vGGvbNV
         tbEw==
X-Forwarded-Encrypted: i=1; AJvYcCX3Xvuf+A5DQsrpuuFO1waoM+o/Ih2eEOPHCFHZ8UVBI4CS2IgiWoZTEmxnovO+uNYv4ZTzcQh6oQ==@kvack.org
X-Gm-Message-State: AOJu0Yx37iwtpymDtFx7BVT1UUC3Tnf4GvQvDuZ76isDrruYF8a/i+E6
	1g8HQppD0nwleEsLjXOb+ecq0s3si6g0VMlz3B34jxTxuXUyqawNBpz6GMC0rbBZ68577qbBhQP
	HkrP40N5xqaAsCEVx2e1Oa5QRse2QigsVY4t/YVSznP/jnMjIkaEg
X-Gm-Gg: ASbGncue0qk7npKL109NCO+ihAC6Y91EXiJCXs4h5uoBBy/xkqnFPDFtVHzYSAV5Jl6
	s87JrQwiVjsgBUwQ/2Rt8/OfUF3tpHn3xbemcoft3kGJTvcY6eLsr8k6aozHgraUVzM7BasFVJi
	oHbmPSd+Le2HtSH+3SenneeSd0OkC05UyGYCA+yiNIFYyhYA+OogykUTpqook2Q/+X4dVIiBLlX
	ogwHbr5uAl2VyvtFpJjpuMFQyhKC7okmx+qo4ooTVxQkPEEOzzHYngARYWSfYDWTR/3FZzXUP+y
	afjj2V8n11rymxudcodoexDxnU8INAasUo5UZQFJ4lp17Cq6G9KgYDTkhokOkmAapOCu0giEm5l
	NovHPrrfEX+A4vzLzHrUUqbnzXs2GBU4Rr3STZhG3wgaehEIH8cRdM18lwHUuR0Cgzao=
X-Received: by 2002:a5d:5846:0:b0:3a4:ea40:4d3f with SMTP id ffacd0b85a97d-3b768f27a57mr1700477f8f.53.1753260170193;
        Wed, 23 Jul 2025 01:42:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7ZThA85cZ+jlGeXWrNpkYeEIN7qUStmMhxE36AHwH/9cQLh4aUBociBhsllms9KBUpc3hww==
X-Received: by 2002:a5d:5846:0:b0:3a4:ea40:4d3f with SMTP id ffacd0b85a97d-3b768f27a57mr1700427f8f.53.1753260169656;
        Wed, 23 Jul 2025 01:42:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45863a35298sm30650555e9.1.2025.07.23.01.42.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 01:42:49 -0700 (PDT)
Message-ID: <8dd1e8f6-f96d-4d36-ac2a-c258ac842f75@redhat.com>
Date: Wed, 23 Jul 2025 10:42:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add stack trace when bad rss-counter state is
 detected
From: David Hildenbrand <david@redhat.com>
To: Xuanye Liu <liuqiye2025@163.com>, Kees Cook <kees@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250723072350.1742071-1-liuqiye2025@163.com>
 <202507230031.52B5C2B53@keescook>
 <c7a32d87-efbd-47bd-9a18-9eb51e441a7f@163.com>
 <119c3422-0bb1-4806-b81c-ccf1c7aeba4d@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <119c3422-0bb1-4806-b81c-ccf1c7aeba4d@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5tAUans-JEA_dPy3DOkxrUJkX4mw1sAsQ3_UTr9KfjM_1753260170
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C9A840007
X-Rspamd-Server: rspam06
X-Stat-Signature: dekctw9umdmogiqj5ebxwogwmwrzs8m4
X-HE-Tag: 1753260173-583082
X-HE-Meta: U2FsdGVkX18JLN1bM3+70AgctMB5ZQmn3iROch78hdYpsgBBk9b/79c/8B4HA9V5aN1gxAUu2FKZ98GoU/TZz5N6+hhB1oFALdw2fhn8d37/zjvFUnuPX+ylvF79cWrPEncIuBwfziWltUC0P4E7CyZ5pbOpCMk4zSK5HW/B/mYegPgx3Oddo+qPiBHgbJnNQ65qRmboBVevfPVFLnvRG38w0BuVo+Fpg3AByiedmORXQMYNzIWGrFwk4Q5hMbMBqTneifbjuXtYnBGzEMrIARYvJaSly513Z8JSJVmmU/FxvMSVkzU7q6Z4O56jQonl2886Tr3abMCeosgzkEGrV4lp7877zpvaMnurc83O53QhWf6JRfAt2Lc9bEuNBXCK6jKTnw+M57XDc9WKn7YBirrcZZW1etkyxg+WFl6Mc/EW31LE1rhcqI6tGNhoRuhOgF6krJYYI78qgjQW2PizmmiWy5xT3I9j54CLnbZuCpLAIX9Phkw842Dk07HrK2vfDwAcC77AbgoHd6Xi3iISAAHcWCmZ6ytB07sQMcu1vaI+M1o36+G4vMT0YjIb/MDU5VwfmsKCHf+J3VvJ3Y9/amwun1gPPn7XMIHpz3+XdkFQyzooiy7h2PRt57GMAzn5gjRPKiNL899usox0Xrsf3NPwH8WvkoUGvBu9+poZM3KRj+XQvsSbN/z4c8Nwb5wuSlBiK9Ws0mH6WxfKBaxTi8J6Vwgg3ZDFBj2YFs+aCxydEAz8RnfzVLqAI9XHnwPeJR3a5mSu1fZ++Yvd05iyrXKRpU4N44Mrv03lAsi5tP+O93rvbLpUvZZ8GZHAXvMXmSWLFAtEpK0HCyNfaJGyaq/I0uODNyjk9bWX5pJwd+KHSChVMqmjEDMDAY3PFdMn4r/tW3pTzG2UAwY1bMQZM19wU/Y9jXe7hqYjFb3dWvrpk10WJpvU591QYzKZgL/geQ4Bxn8CmNUWw1gNcz4
 vR4g65aK
 hG3wlgSgzFa+RAbno+h/2Wep5+StudXTPao8FLk+lt6n/DZ9QeEY/bifn0GrNp9eNSqOGR3kf47SI3yuOUBOsdZxzFR9FOTIfgY2g0mlKRi0RUvfvcvdCY+B4IHSlsTg8EQEK/hP42tWDPOoOxh9eE1RdlwJ7J2Tea3woi7XlaKFtpTqIZwmvFJUKDcwewulmYauoONYK9h33lNDFDIa/eyQhgAd7Rm0+DXVKL44k8FqWK44xhdjB+JfWbo+OiSNL3Ix6o6kfEgiQrJBS62wzY71j8OiZQjG1CVwZ8ZrubeVBklozk3qqdQacgdt5HWvRfPN4Iu1Jd0tMSRyZ5Cj0gVxgLPOm7Gi5Oi5J/y0m3H482DVoqd7FTTePfORvsnvT9v5fDzsBUVtMM+ZvEmpDA0PVc6zf/F16Cfbdl5LByFSCjHWSn5LR7T74WqkxpWG2BeXCuCQwMcB2hMhF30/X2oQlbfv2Uu+amb228FM+USEk8V4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.07.25 10:05, David Hildenbrand wrote:
> On 23.07.25 09:45, Xuanye Liu wrote:
>>
>> 在 2025/7/23 15:31, Kees Cook 写道:
>>> On Wed, Jul 23, 2025 at 03:23:49PM +0800, Xuanye Liu wrote:
>>>> The check_mm() function verifies the correctness of rss counters in
>>>> struct mm_struct. Currently, it only prints an alert when a bad
>>>> rss-counter state is detected, but lacks sufficient context for
>>>> debugging.
>>>>
>>>> This patch adds a dump_stack() call to provide a stack trace when
>>>> the rss-counter state is invalid. This helps developers identify
>>>> where the corrupted mm_struct is being checked and trace the
>>>> underlying cause of the inconsistency.
>>> Why not just convert the pr_alert to a WARN?
>> Good idea! I'll gather more feedback from others and then update to v2.
> 
> Makes sense to me.

After discussion this with Lorenzo off-list, isn't the stack completely 
misleading/useless in that case?

Whatever caused the RSS counter mismatch (e.g., unmapped the wrong 
pages, missed to unmap pages) quite possibly happened in different 
context, way way earlier.

Why would you think the stack trace would be of any value when 
destroying an MM (__mmdrop)?

Having that said, I really hate these "pr_*("BUG: ...") with passion. 
Probably we'd want to invoke the panic_on_warn machinery, because 
something unexpected happened.

-- 
Cheers,

David / dhildenb


