Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB796106FD69
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 03:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48B8A6B0088; Thu, 12 Mar 2026 23:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4636F6B0089; Thu, 12 Mar 2026 23:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36FE16B008A; Thu, 12 Mar 2026 23:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 272E06B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:05:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ACE88C2562
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:05:24 +0000 (UTC)
X-FDA: 84539548968.26.91893A4
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id AF00D8000C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:05:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HXiw9+8W;
	spf=pass (imf02.hostedemail.com: domain of seven.yi.lee@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=seven.yi.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773371122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMiD7iuuQ6RwrA9DHEwvWHHs17Gv5D7sbQEPQSKpbdQ=;
	b=wXvbLwZ3Ka7ASBBsIrOUOR1TW9V6mxYCWzSJJWrMdeEv7A8utD1tI/TofI82Cv1O8o1wX4
	boPKQ5ykpTgCZOAduzBZ/lRR3rLcMAQ45vx8nMkqmUVHxxtYzN6Wvpy2JRsGBfxa7+zu8+
	f4/Rpttgi0peLMPruO3ROvH+HQURriU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773371122; a=rsa-sha256;
	cv=none;
	b=EgDNqkkeSD3hAquY1/Re+gX6mMsy52Jrpc8OXmn30g41KgEyCLwvRTLK0Pnxt6lUa7VXFK
	UrfeSK96IeEA4gZV3Uk2/Z3fjOmtFrbGOTG0kAJ6gJ4hIFRsiS/s3Ah0spXe9VZcm14ZWZ
	d9zrC2jQpnjgHVc9aLnLRkQM7pSD/mQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HXiw9+8W;
	spf=pass (imf02.hostedemail.com: domain of seven.yi.lee@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=seven.yi.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ae4d48dc2fso8524835ad.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773371121; x=1773975921; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YMiD7iuuQ6RwrA9DHEwvWHHs17Gv5D7sbQEPQSKpbdQ=;
        b=HXiw9+8Wzb6TdIMr23qeZTCegsBDqC9Bxj81Vzuo/7aSG76rIeVijQN3I+eEGSMnhD
         ScqYA1z7DHdT4H7bR6DUAgA4MTUDcwv8nIYvDJKndgxBDpl2l39BfXg7yckAFILD8r6l
         M7lMBwsJoNY0Hig6n+eWy5yHa9VsCaEQq3Hf4c8FDQ11nZMLEiyz8YH5LfeN1fipj+so
         qjxCnJePTHhJ1hrpCJZXlqHIcLDtrnJyfW2luEWPcu+JSAyzncaFEp1bZlzjAgPflK5a
         WE8tAtZuPLGCNJtOotxyE6l37hMXNpW0gIVuEeIAW8yuVNE1MNlfsOALBEjm0+7yd/kB
         cixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773371121; x=1773975921;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YMiD7iuuQ6RwrA9DHEwvWHHs17Gv5D7sbQEPQSKpbdQ=;
        b=i1OYYmixIwUTu+UZIUfi00n9kksSsyr7eWpbFk//B+BNqzG8MZ4uJHcVqklKei8705
         sD9GnKrg5gHqip6+VMU7/+9tdYXv/RQ0tqLAjoap7EFowQERHRPbMU1ptcCU9VGK3LyF
         22IBa4/f9sfJ5/q7DnbyGrDxwZV7ZU5OWhTaBlqMBiAxaX8von7+y0LXN/Mar4m+sMUz
         03giTcFu9HdwlrM39Gemlb6rLlEqHkB87DbSdVW0sTZ6FPxxXlHJZ0wmBKkNFbYDOOG9
         Bg/LIhJCGla9Pr6LXnJm0I04zElvIEeGU65Yq0VW7UIoTjE14BrVzwhdOr15OlFX5kHL
         0HHg==
X-Forwarded-Encrypted: i=1; AJvYcCWCk9l09qaMyxURGOOIhCNaMdl5zB8Pv7vH51oNv+Hu/R6ELd5XLOvdtdIQY0LAwVUVZXgiLm/4bw==@kvack.org
X-Gm-Message-State: AOJu0Yz5Qfs8ufGFfRqL67pie4dQeprbm0Chtp8QkGreZOBjCBV61JsB
	bodxStU+Q+20GR/6C93tsliXc/aGV137DGqUldiS3F0ouYd7My94EKPM
X-Gm-Gg: ATEYQzwDGRmTowwFjClyzlh6PfVqJldXqUFWV6suSecI0r/QsmZ+/2uPAzfQUHIyjuQ
	tiHzpE4HEtUcd9+fbdZH7tbz61u4JxKcpi35DJFUUCauVKsA7JVAli3AYY3FmCriKje85B0G77S
	s51FRXOcP4/fW6prteHWLJ1gaamWguZ67NcMfiU9QwcSmH7wto/x1HaqcluiWhpWJfqgfRhbe20
	0J3B5fuUUMYyT+l/5zM+C+mXN5ID7PEosFXX5T3+ahy7CN495SIn3ltP7JOw7WPbXrhu7krZvIZ
	q1C19yidJ2GFb+1wNTmVsRKxYZRAQicnfsvFUxeeJeFKQN6bgnnApVFgDnSdLKXPQsCpBiZKLQW
	kfm5WVmK0pUcyjKwKGX0ae9Su7IQ+o929pPGfsG4z3I0kxeNpEWWoBin18NT3a1C89kXCEsatq3
	4U9rVT0ACGnftANO7ZSFePUzG1MjZJ1v8yNHiJS0oKhxvA20OHlEGBmPYn22HtXcE69iJkze8wS
	g==
X-Received: by 2002:a17:903:1a2e:b0:2a0:de4f:c99 with SMTP id d9443c01a7336-2aeca96723cmr15904725ad.9.1773371121407;
        Thu, 12 Mar 2026 20:05:21 -0700 (PDT)
Received: from [192.168.123.240] (n11212047001.netvigator.com. [112.120.47.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece56c388sm5610335ad.11.2026.03.12.20.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 20:05:21 -0700 (PDT)
Message-ID: <8315168c-0557-445b-aa86-174d9902e2e1@gmail.com>
Date: Fri, 13 Mar 2026 11:05:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempolicy: add sysfs interface to override NUMA node
 bandwidth
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, dan.j.williams@intel.com,
 ying.huang@linux.alibaba.com, linux-mm@kvack.org, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, dave.jiang@intel.com
References: <20260312091207.2016518-1-seven.yi.lee@gmail.com>
 <20260312115825.000045af@huawei.com>
Content-Language: en-US
From: Yee Li <seven.yi.lee@gmail.com>
In-Reply-To: <20260312115825.000045af@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z3ihcmnakdoggppubsisbkdf44wgwkrb
X-Rspam-User: 
X-Rspamd-Queue-Id: AF00D8000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1773371122-879039
X-HE-Meta: U2FsdGVkX19LevBcIU+1Q48ntXU5p43lCB6cHSQc5NFcH7wXNImoBJ+xSm+Tjnyul1+2qujCKnDaoExalXIbTle5C1t+5K9icxTwN3a7KlAkP4a3UbchSuQPOh4Bfguy+f/qj9XnIRWLuIlKaEU/okTNtS68XpLHvVnOtiq8Enckpluc/0rhNR4HfUdJVB51O2pUPA0e6yjwO43z+1nw9sUSD9dau65N3mWlEXwLTfVztyabJoDgZGDvaaJOwDRVNEbmqhsFEJ0522/tp4UTkJJthFZz20/xyfyTz+UHDbjrjsjG1zb6+gJrApjNDatSaxoA0nEuDFXEpJcdPR7ptoSvg6EDUVGJnVCD+aW//jbsKwdesrjVlCUyYshtU8ECkO/B2mXPd9Ch/i6PJe4gbG+xg0zjMs9LjX5YBAEz7jnf5RVkWdOPJQd+W46ZnWhMuASb00QDka6FH1CTzndGCnE8lhZLmKJx0R2zAfp8dWIm5LDIR9o2MjaO2J49l1lzl9SwDlKD9YEnHFx7kPxzcLO/5PVJxI2ZPCiCcswoITBzckO4zzg6XJg6NSXElfdGBgQlVGeeZnL/y6b8f0yESifW2L2WJUk0fIWyZJLpGvU0xPIP2/nwV5OvOlSeUV8u/iPPx+bgMhvOXBwjd3/G5XckyHbi/3p3o8ckguKKShIjEhqfmLgmUeWnbHFFAL84EDjuAKojkKgH4NDu++ftGGODKo73OuWB4UwWzaENECh9LfypkSTct/m+EOCiAp22kzjmE+2Qvxhts9rUim/zTr+2w9LwPkvs9qByFAI+dU/el3F0CI5J8YB38IUM3wN2CZf647cyo8xpu7YD4ODWO0t61sALWwu4pfmt9YPp8HQPZV2fJkl9HrMn6j39jqVd7ymiw7fGC3zeIoOjIX1BzNb0coWfYP6zVAKXwsa1KnE73hjspnfr1s99XL7taP+wAmCbQvAJtbR5EQ5gtJa
 d+abftf8
 ETw6JbVAK8agWgFyNIaEcNQoDDP4UIxlQZL0z6gU09okI0mQPD2A7tEpsl1F+viiMnVErL9VGYGYCimUYzI6bXqt48UPunSarv2b2gTOpxQ3rKVl+0gJiSxx3gQZ1KaFhPrjdv0M0Zioc9XWMhTKwBAclCelJE3ktNT9gKY9lki5dU5ek2tkzi+eJ7sPs5Kktompk8BIYCAGI2Gfw2QHBxgETRgqve4mUIQwLd23Da53hRrOuXX5mb/NGuYPAJOZ4MzJ3rT2x5y+ArUF23IyQnrOLEq2iIZiNDARB6NIEfJ6AJgfQvr6zz2usAOGJLDPwpZYZqx4UCazRVhJvbPaVrgddLHteWhxEeUWbNALvLq4xGyKsqsayEY00ny59WWE6rLDknUMm1/K9jkyOjZiSe22uw3r++lzPW93SXMa/vJuXB7mXF7/wUGKeNmDSbvdYsNUDkJZXsZpEh8gJx9keyM2pc14ynjibhKjx3o1SzeiymWdLSouq9wKbL5YW5rmnIPxkd4anC44Co7WDg1ww22+TuIceCQ3lwLVaWfAoXIA96MzlBJ5VUEd9/DE5ak6S0O/yLuhd0jOyZe3GERpLOXJUBwqNEvustukpDkvrFGGAnGajAanh+312AyNavknTqtJ4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jonathan,

Thanks for the review.

> As I note below, I'm not convinced this is the best layer to be injecting
> data at if we want a debug interface that allows us to reflect real
> hardware.  Might be the sort of patch that is useful outside the tree though
> so thanks for sharing it!

Perhaps a small tool to compute weights from the desired bandwidth
would be a better approach.

> If it was an SRAT (for GPs) / HMAT issue I'd suggest table injection is
> an adequate way to do testing and debug.
> 
> CDAT is trickier, but maybe we should be thinking about a debug path to inject
> that as well - similar to what we do for ACPI tables.
> 
>  From my point of view I'd rather see debug / testing interfaces that test the
> whole flow rather than just this top layer control.
> 
> However, I can see this is a useful patch for developers. But if you
> are developing debugging bandwidth-aware memory policies, I'm going to assume
> you don't mind building a kernel and adding this patch to make your life
> easier!
> 
> So to me, useful tool but I'm not 'yet' convinced it should be upstream.

You are right, table injection is likely the better approach.
During early hardware development the platform is often unstable, and
firmware may not be able to report it accurately. Letting the OS handle
debugging and evaluate the results can make experimentation easier.

And, thank you for checking the code.

