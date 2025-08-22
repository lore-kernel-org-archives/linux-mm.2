Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 561E3CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485366B00DA; Fri, 22 Aug 2025 05:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45B846B00DC; Fri, 22 Aug 2025 05:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398B56B00DD; Fri, 22 Aug 2025 05:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25B346B00DA
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:29:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF1BFC06DD
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:29:26 +0000 (UTC)
X-FDA: 83803870332.15.5818473
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id AFD4880011
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:29:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lPbSOnfH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755854964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+EnH/VSEGlluJ4BD0faCMmagpwL1mCpFcxo1StPT+Ao=;
	b=sWNgVqc+m846MzW64dJs0BIx2oYjckwxnOjDHhRsnL+P5yu0+KRWfyVyq4+Te+8vfstL7P
	F3fglXNWd4j9xClvYPrkRmkhxhYSy5LLpmygRlDtGYOYsddNvGScmn922n9UP4aQBf4+a1
	GG9KrmWExpU113TCafRJciDH8cjrpq0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lPbSOnfH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755854964; a=rsa-sha256;
	cv=none;
	b=rBh5fIoZd4lmtv08kPniZlfZYl49DwlLXj3ORggEq5Wk++kunNy+6vaFHRekJvu67fQx3f
	C8+2bjsnX/N0s9NS4WMxaXQKa6uA816JD+UNPZhPctcznHKh/pHRFCE2ynChQARMQPJ5ie
	Fd23viruV9Hiwk7+zXMq/ymBha0faFQ=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45a1b0ce15fso1926005e9.3
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755854963; x=1756459763; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+EnH/VSEGlluJ4BD0faCMmagpwL1mCpFcxo1StPT+Ao=;
        b=lPbSOnfHyoHUQuh5Aftmo306KD1s5LcjHWy96bsob4R8K5U2+E9JeK5cqLM9VH6cHe
         Se8f40TE8pT7Jpmijgd9Zc9QiwETsq1aPrivDPW2Q4ovqFMYXDM3wkOG3cyFp/TcDOM0
         Oj0KjWknJgh3IW9O0B1YsCHZD019/g9G3W8u3/AsD0WeprQVpnxRSbrSEUykxW/J5mzO
         1BqWvEKLvFV5oEL/3DEI7fT4u7dS8S6afqMLtFRwyy7TupiYenmPNgNaTxFXjucBTPS6
         eRzSTnoWxuqSlc5EQLhhEqa/yvXWWbwDlgbs6YEN2Mf3dCTGfPxkqdwa6iAv/w4DYMOb
         lViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755854963; x=1756459763;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+EnH/VSEGlluJ4BD0faCMmagpwL1mCpFcxo1StPT+Ao=;
        b=CwfEkU66D31dEcUFiMveCw+pBQ/gV8UikSyYTACvlnhyXWbOa83G36r4mAAxRtm4F1
         pvZyX2K/uDbIoLnD+/Va56OsKTfauWuNhwLyvLUGeHGk4h7qtL1xlvA0PqBsMz5wtHbA
         d8CRMHvMIEiOZ7WF/+p2aKAmlB6AvrAQfdW53hrRMD2KYLN7FJ29gfn5nzi7t7ByJ7ac
         O8COCWPunZLX+hA+UEGokiONJIdx0cj6d3vRwC/IuEealAiXzaralkm/1Ifc6TokZDbi
         LHjD0PuxJJOoxPpc0C2pMawq+vIty1LJgrBSA599yLktgE+djgqC1TsGBEKnpbzYHD2V
         +erg==
X-Forwarded-Encrypted: i=1; AJvYcCWmSZj+bghRXTx70xFlklmOhnDqANy9fCkWokS/bAiSwt13OqRVIBEsHQeveaBc+rGSXfGLrMEWCQ==@kvack.org
X-Gm-Message-State: AOJu0YwlBWqGudr6073OhdBt45GhdaFva9grOBxrUMOok9REKv4v/9f9
	l2KqkOYVvTfpLRABns7qwif5m6WGru5XOvWkYYdmDJ7UOCm11Z99sg90
X-Gm-Gg: ASbGnctpx59kdbhSuBDeazeg8TQp6KNkzCE7zY5dekouJ/Hzof4sAS7sa3FVeArn+Fr
	vp4biZH4+i2HMJCs1GdeKtTDx8ArXN4VC9Mvwlv5V4c55UA87E5d+qeZ+gePbXKRBKV7T3aQ6H9
	207Kv1t8EBPbHNpEr3LYvAcb8lV1PU9/3OwzaxOkAQJjgcaJEfL8ODIK//ToAkBTBJgm+71N6qG
	PI6iTo+Fwb2fnHGL79GCxj+zRfakZ3mS1Zfzq3YsPp5XeV/wOAdoRtjGj/VhC28SjxrZfbRAcfx
	4vdnAIUAH6tjgFEkyD/xGbYwbhwluvL4/TjuME8qnhAB/t+Fjh+NJ+jW+z0fbi8LuygrFbF3yRC
	21IaJsd2sd4B1Wq1NczF2dK06YXPHA5F1Xdcvqv1bApA1Hr/dxGun0eXbTnnNxSxLHECi74ZSxQ
	9YjoMhs5gi
X-Google-Smtp-Source: AGHT+IEeFhCgKs//0TYPpq0tr4htOV8qx42B9wgXqgLJ+zxDdcN5KH4lqW/B9Qr2BTax1Xm0EqzTVg==
X-Received: by 2002:a05:600c:3ba7:b0:456:7cf:5268 with SMTP id 5b1f17b1804b1-45b517ca4bfmr8096065e9.4.1755854962861;
        Fri, 22 Aug 2025 02:29:22 -0700 (PDT)
Received: from [192.168.100.6] ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b50dc40b7sm31644325e9.2.2025.08.22.02.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 02:29:22 -0700 (PDT)
Message-ID: <e5ef25e7-e4bd-40d4-9f0a-f1d4c1c8acbe@gmail.com>
Date: Fri, 22 Aug 2025 13:29:18 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [PATCH 0/3] memcg, writeback: Don't wait writeback
 completion
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-mm@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 axboe@kernel.dk, tj@kernel.org
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <24119aa3-f6ef-4467-80a0-475989e19625@gmail.com>
 <CAHSKhtch+eT2ehQ5weRGEJwTj1sw0vo0_4Tu=bfBuSsHXGm3ZQ@mail.gmail.com>
Content-Language: en-US
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
In-Reply-To: <CAHSKhtch+eT2ehQ5weRGEJwTj1sw0vo0_4Tu=bfBuSsHXGm3ZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AFD4880011
X-Stat-Signature: xkeqx6e8aqr5ck5i9tkosxhgq9qct4my
X-Rspam-User: 
X-HE-Tag: 1755854964-640768
X-HE-Meta: U2FsdGVkX19Nh7ZoKMIJU8g1Gc0jajXFuUjwiekM7/49/PDkxFs91GafV5aoSnYJeQtizk/pyMPTO7fcFEULMjMibNEoRDNNEjiNl7kf8pPfW5bsGonMq2Tg1pO6jNpCF+X2QoUylO9dy0YyfA9T4pBcILcgeqb5hMmfTcx/7BABkHwt8IFhzm2QaqFrJeFtKLvbNLL1POw2/VD6JqwQs3C2k2sNG3rAhLMHVUpbmE9zpAX//DgfWqg/RF1ISwV9FA+2+OWiPb9KhNJX1u+r2AKREXmk1srXFGzoliIluMVRNN9nwb0ezLT/eA/h+U6RuPTwjwzCW1jv4138/t4YsZ4WcXBERhDCAyphDQdaEZfDUUyUkt7sGmEYchfD1KGoquHyRxeearZ1JX0cfXAV5He44YD7Cjpezm4DPYbUMsL+S12iOOvsEt1WtiAXfJnjtAqmUNgijpb72MbMcGhEkpduYBplMJLf3sqfVawzLBh+M/XiWgcqHewojgjbKFi4b8GcjsF6emQgO00AzN+1XAyuVGShRkZ3r+U7kgFAcj4jMIlQGHvTvHKd7j+CXqjOuATrE9sq56pvNyoFY6TREv3+3XNoCzrnf/dLI31LKuk6xSGEWQmq4ypKB2o7rISJmlU8lMo3PvWLRWdW3ADnqREizFz2MFV/zn9Q+rGGlUMSck0TR47jWIl0zoUXzqZiiW/b/88WL4CdoXo5AYwPUohAwY5NWA8Qddz31d8AXNx9aiDtBILseu0sCS98EMUJNBrA3gCnlQ86M8CD9W2nj9hVU2C/vPLeWZNofDB83gfos60J0olTQCneQVzkjzOY3gutOz9wQ+PS4GcwspxdkcYB2Nn49GG2xqaGfvTwj72QMiB+/zI6vsPw9MAjyguUtJ4a9w4782DV6gMo9092SO5nFLImVQaNtfWt8pQ09bA50FX8F8s5icsKbjostOFYI0uH0MdLCdnk/QyN6+i
 gV5UnEE3
 fo2Lr/SfoQkB4Hnx6R2euQkBflB/hN8f7N9YBUEe1vCiXCvRktcp/a32mAd5hyAaXs/AAT5xjDScPomRB/+VXtC+7Vcid5RG8gOEpEVZ0UBvJ+imgsG+DI2+AZYHeiP+6PhpiQduZgda95aKFDL6jqS2g/pbpnBr15hlRqcqjfiVKr3mXVsRNVVNivdUfKNB2dKl2w0ZGnLGBVmdZ174Lh40cSDiunOvxKuenkU97orJKh8xeD6768jyZlWweysEYcKxxJjVyF+958vW6OMThzfOto6BYEep6Z789zGdfhOFmAk1L745QwDntVsH0NJTtTcHS0MXg8TMUygQZ1Bou5jY1YbkDCeW66gqf6GTHmqOdDFpHSrwFTQco7obI7cQcZAIsv7Tfl8C6q9Ck42ba0YQ2u5R/m3+xgT7a5r+U0E5s6pvulabQ8XLVv2vpsv7x7odNu2+TSH7LzVYKt17QeLeQ0hiXh9roHr67nKBMnnhEe5A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


`memory.stat:writeback` already gives you the exact real-time count of 
pages still waiting to finish write-back for that cgroup, and it is 
updated atomically in the hot path (`set_page_writeback()` / 
`end_page_writeback()`). Reading it is just an `atomic_long_read()` (or 
per-cpu equivalent), so the extra CPU cost of exposing it is essentially 
zero. I was thinking that extra additional info would help us

Thanks,
Giorgi

On 8/21/2025 6:37 AM, Julian Sun wrote:
> Hi, thanks for your review.
> 
> On Wed, Aug 20, 2025 at 8:17 PM Giorgi Tchankvetadze
> <giorgitchankvetadze1997@gmail.com> wrote:
>>
>> Could we add wb_pending_pages to memory.events?
>> Very cheap and useful.
>> A single atomic counter is already kept internally; exposing it is one
>> line in memcontrol.c plus one line in the ABI doc.
> 
> Not sure what do you mean by wb_pending_pages? Another counter besides
> existing MEMCG_LOW MEMCG_HIGH MEMCG_MAX, etc.? And AFAIK there's no
> pending pages in this patch set. Could you give more details?
> 
> Thanks,
>>
>>
>> On 8/20/2025 3:19 PM, Julian Sun wrote:
>>> This patch series aims to eliminate task hangs in mem_cgroup_css_free()
>>> caused by calling wb_wait_for_completion().
>>> This is because there may be a large number of writeback tasks in the
>>> foreign memcg, involving millions of pages, and the situation is
>>> exacerbated by WBT rate limiting—potentially leading to task hangs
>>> lasting several hours.
>>>
>>> Patch 1 is preparatory work and involves no functional changes.
>>> Patch 2 implements the automatic release of wb_completion.
>>> Patch 3 removes wb_wait_for_completion() from mem_cgroup_css_free().
>>>
>>>
>>> Julian Sun (3):
>>>     writeback: Rename wb_writeback_work->auto_free to free_work.
>>>     writeback: Add wb_writeback_work->free_done
>>>     memcg: Don't wait writeback completion when release memcg.
>>>
>>>    fs/fs-writeback.c                | 22 ++++++++++++++--------
>>>    include/linux/backing-dev-defs.h |  6 ++++++
>>>    include/linux/memcontrol.h       |  2 +-
>>>    mm/memcontrol.c                  | 29 ++++++++++++++++++++---------
>>>    4 files changed, 41 insertions(+), 18 deletions(-)
>>>
>>


