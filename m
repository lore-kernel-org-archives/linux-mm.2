Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97B9F46446
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3976B017F; Mon, 16 Mar 2026 06:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27DA16B0180; Mon, 16 Mar 2026 06:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169146B0181; Mon, 16 Mar 2026 06:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 036056B017F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:25:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5B26C075F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:25:03 +0000 (UTC)
X-FDA: 84551543286.22.B7C7C71
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id BC5DFA000C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:25:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=acMu5xuq;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf25.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.53 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773656701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=76TTQfOSNM1rz7a9CKO2GjO22jbs8CcvWq2eCabFfvY=;
	b=tRNvz5GF6TYOfGJ7A2szJOGLO+geoENaO1ErQ0By59R7lBnpDra6SKQNqrzlVPYslOzPG2
	AVfHNT7ogc31iCUtA6vx4FpQ76VdMn2F/vY4JG6hvu0yx1nT3FA3NLJ9sijqD0bo895rCT
	6eoxmY4vs0VFvzmscceqxwuZWr7HVBo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=acMu5xuq;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf25.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.53 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773656701; a=rsa-sha256;
	cv=none;
	b=VW2QepbusDH0W2C+cestF9KiQ/uqCeLdBwDFl2elFy/YocYwrFsZLcJQ3InbmU1xBHDQEX
	DsNhxGddHhgzN+In4oFhESaiyjZhCSSeINx2Y1K0W/KjmJ8GBg+kBdAHUiz5YYJkO5LKi4
	pBbl+QzaDei2qz+aKFMzy5dVUYcKkQw=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4853fd7b59aso26552745e9.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773656700; x=1774261500; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=76TTQfOSNM1rz7a9CKO2GjO22jbs8CcvWq2eCabFfvY=;
        b=acMu5xuqghX5nsmC9gLb/S6FjPz3ZesirrasG9oQgoHkwbAQsTZVJQuPIRU81ssIaK
         +8h07f7Q3HlzVCs6FsZgey4FJEZWKq0/JAVv7Fnwxjzw2fdxmFF2+iSXJab2SSPgxf9r
         wdT+MDyj7pA+hh3PdnvEUZ3isvSlPzy/znV/RWeXjrqfTQ2LntzzT21/TgvboaSzCzNo
         jljmf810Jz76FDPk0hUO4hlQeKR9MrU4HubZDzC+UDW988Gs5pxbUQdFOagw95BMZqeX
         MQUMA6RjhBubjlfYpWvw28945FeMSpt+4WJz3X0Wx4SCsf9+NwBngBcF/yVqk+La6wPf
         w+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773656700; x=1774261500;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=76TTQfOSNM1rz7a9CKO2GjO22jbs8CcvWq2eCabFfvY=;
        b=eH1pSI58dYfLYuq2371GCgtx2QhgEd1QWTUFBk66QwnhDJgA6O97UIv99gbL4I4o5n
         58LwgkT7wqoEUb4t0xS/B+6UC0D4Y95bpoHSudH8VDfZ1F1SiCHxM1SlXBoRD6LqimKE
         JU+PmhOA9JyPuLvoRRObQiF+Ai2bp0UF6A17lDs+J7M/NDG8TgoLU/UXIlx2nCEAIALa
         N5Dt7xcVB0PZhgzkLyqRUDUvQX3/lctarp4JmQA2Yl0ju9yvvNgYPXw1doTwmf1fd8cI
         iuTveAf5c078JOzIYaqzkS9XJoj1jR67Iyua7InY7qGm/xJ3sZ3RytavSKgzzOgUANO4
         hPeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKEhtoyWWSJFd0UEu7OwEPVqsxFurvgY0JHnm/4Hjrh/axLoO0UU0VBQ775a7RIS8mwc8T4HZ6/g==@kvack.org
X-Gm-Message-State: AOJu0YyhM1BCndheVt9EBlxdcUQbBhswtUbmb7RPxuImf5jaFnDL+DwG
	/yvrjw6uWQ7QlC7Su+nPrPoBQPi+GHw/gnfnTHLKtQL2Lf7/KocyUsVdF7tGGo4gW9A=
X-Gm-Gg: ATEYQzzUtoRgyYzd3wxtOyfR3P500alLGzL1+jyuOkcDgs0kH2TkByXCYEMI+xOQ4F5
	c2kzUQ9EdMRniDiy0znvuQdBBhZ9rIWS0j+wIPOh65Cx6VytxoMYCpunSGUwOnsj/I7PKBpCkgM
	FBMkgAkacX9HoP9tCslp5sZrp7mv6+8dPOy0r4tSd/IyGpX52L1bfrOHNbuBD80EM+/oILbq2K1
	39WphJ/vfhRoRYMbWLxFtYT58k2qYvlGp0wqJ0ZkMvf4xjIgpmBFh0lL4TiTOrdovCDscjhQt7X
	hcRatiZV0ZXpnQv+NAfhQ6OA9De8Jp+uM+veuNA2DNYHL1AljvPRthYorzCC7sBn3pyMCRRrtXE
	GvNsE7my5nYhDPkJYZG7XewXWT6IS8zxocrcrc+PYhNX1vUvDx6nEq3YyafdIHlqc3L+cH354Vq
	Xmeg1Y2a83fpoIFIJAS5IhEI8SNq7TpH4=
X-Received: by 2002:a05:600c:4e4a:b0:485:4135:5c92 with SMTP id 5b1f17b1804b1-4855649360amr208565725e9.0.1773656699914;
        Mon, 16 Mar 2026 03:24:59 -0700 (PDT)
Received: from [192.168.0.34] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48557777105sm149727875e9.4.2026.03.16.03.24.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 03:24:59 -0700 (PDT)
Message-ID: <3af521bd-e03b-4e8c-a972-6b0b1c54e2d9@linaro.org>
Date: Mon, 16 Mar 2026 12:24:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/25] printk: Register information into meminspect
To: John Ogness <john.ogness@linutronix.de>,
 Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner
 <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
 linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
 <20260311-minidump-v2-v2-20-f91cedc6f99e@oss.qualcomm.com>
 <87pl54f70l.fsf@jogness.linutronix.de>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <87pl54f70l.fsf@jogness.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC5DFA000C
X-Stat-Signature: z5wmgxz66eerqn3yrotfsy5ufn436mbb
X-Rspam-User: 
X-HE-Tag: 1773656701-735358
X-HE-Meta: U2FsdGVkX1/rHMkeMBemzJeqNWsfscOk2tYn+VShZ5WSb1WcRofMBKdusxKUvPvW2ZU1/CvWtkjSpaPjWbxqYWx9fUpA/cklOnTzlaaSiZiDz2y6l2+C+KrASk7hFY1LO59EqzABIIeAXBTmlSlMWOvKrkVr7GD1CEc4khUnnc8PJ+8VLna2CE1uAg3JGteR2PCCqeAWk+0t0Ay2bHuAU6nOZ9e/LPnk8qQqwitH2y+itcg0Vh8q6t+m6PcYe5zEv/vhhr4w9YbIuAkOakyYXmXj6y7WFgzGWbLzzGwfyDvHayep/zNWVRw1++sOCuricXRoVbF83CWSRVdGsR9MStyNsZBcvl2r2gjrs8s5cTg3xrBxSE9iR+GUtFRzMVutsuU2dkw/C2bu5+g846vASCFClH30CZanrZPHG5LAgGN8I05XueOziz15lgL/U97Ovk7hzg6Ic+24NC5S7Cxy64es7W0L/Qk5qgozg0EMFvq+qUVYQku5s6WBujwB8R9S17XR9eVD1b9coKuXnPPSt6m0R2xI59awa8Rpn/syrbfBT9KUS8qUJXxXz9Pi0ApJW+j9Z2v/MXKh8vmqJ+pHyvWpjhdjQCfHEqpJcXQ/TjIEZP3tHRt5M+7Elcl+u2RMzZuQjrK+N7AQVJaH8PGWh49iGcyDNDqAO79B+9tfGYhsLpoScUbwlzliRLDK5a22DslaaDc+gTMhdua4GvNLf9XEIeQRh15w4GnF3XuUaOlv/6PRz2QfpIp1eOM95CwbfcJR71Nutrrv3zRdiCB94gBPbguSWCdcx9nxLPn0WBguprjOd97wnCD7LTdsQxOGW75zx97DpbO4d1kshO875a855p6tyBh2NGt0ZG5rAtTMYRNb31cvyXOmiTpBVzVQwK3beBqzTmv6BXvOieHvOPHnqxL07ETdKTNPJLC8+AQpl7ODNsq6a275zZOii8Bwj3O5HBpaPU/BTxFqWNw
 Ev6QjtH5
 f91KR0jgcw3ZZ59kgb0sGICA1pcwJyqjA3Eo8d7Gw3Dn8PIPs2BAXJc+S/THiVk5+Ph/9+5ldL/SiyBbMNIGL97nqPPAibvMgzxsFoWAi/B9VdWK9BjkJ+mXbVH4nNl1sJaYlq6/FTU/s3aE9faxKiu/GYETplIUDCdZ1a8dh6l8wyjfrpMq+ljXrdnWk2crrXzHUd47frrDo7EAw0VhVlhPMxWWeL8CsOfa9DlI2zvpK00NxLSyjONPCAmnEewFFy5XHIghMUk4JW+JbqCJmTInC6VFIVHXy1rAYG3UG9CnTgawWi+YiYKHCcXz0fi5sENIUrCDymQkU/NnDOPuHyNOtmreo+GKpxok6kAr2YVtRCTqCjRPIzVRR6xU/c8fi7XGJ/sLpnfJd9A2r+C4cM8HpWQyaE/h6MuuBqiMXmiuB0I1XuRgCFJnKLUgZrORbGEubeGAw9i9axAZ3WYrTAmwVTSeU44P7lg6+AjdOHuS2hug9RohW3+VrliJIM3NSf8iHhyinUM0uePfknECLzXWDtz2MHDul6dd8GHTSD0X1ykDDXoVGnJwJm/cV3SfmHvpTnVH8/OHMsgr9g5DyzrhC8bl5mU6DxA15auOiyyMxZ44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/16/26 11:39, John Ogness wrote:
> On 2026-03-11, Mukesh Ojha <mukesh.ojha@oss.qualcomm.com> wrote:
>> Annotate vital static, dynamic information into meminspect for debugging
>>
>> Static:
>>  - prb_descs
>>  - prb_infos
>>  - prb
>>  - prb_data
>>  - printk_rb_static
>>  - printk_rb_dynamic
> 
> FYI: vmcore also exports the symbol "clear_seq". It is not required if
> you are interested in reading _everything_ in the buffer. But it may be
> interesting if you want to mirror vmcore tool features.

Thank you for your review and suggestion. One of the key points of
meminspect is to be easy to use by the kernel developer. E.g. to be easy
to add another symbol, like `clear_seq` for a particular use case.
So, someone wanting to make use of it, can easily add it.
The purpose of the initial submission would be to have a basic use case
working, and show it as an example for everyone.
If you would like to detail about the features you mention, it could be
interesting to try them and see if it would work with a meminspect dump.

Eugen
> 
>> Dynamic:
>>  - new_descs
>>  - new_infos
>>  - new_log_buf
>>
>> meminspect uses a different API to annotate variables for inspection,
>> and information about these variables is stored in the inspection table.
>>
>> Reviewed-by: Petr Mladek <pmladek@suse.com>
>> Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
>> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
>> Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> 
> Reviewed-by: John Ogness <john.ogness@linutronix.de>


