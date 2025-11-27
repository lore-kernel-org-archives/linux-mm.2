Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D3D5D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 21:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE306B0010; Thu, 27 Nov 2025 16:05:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5646B0024; Thu, 27 Nov 2025 16:05:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402526B0092; Thu, 27 Nov 2025 16:05:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32DAA6B0010
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:05:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0F64C02D3
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:05:03 +0000 (UTC)
X-FDA: 84157616886.12.4B7E367
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id D8162A0018
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:05:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aOXubpVL;
	spf=pass (imf25.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764277502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBBvxgyZWifINMkz9fV/+cWWMFnJEc+vKoCkegTc0aA=;
	b=M5F2H5HxUbhnRzD9uqORbtyyz+7xGTJtE1Zq0NQ+kEtZrXaLiJwXH3ijPVP7k1aHu1G7B4
	hjpSJpH5j9ycC20ZhzusZbKbu6ZIDZ5iDrUPewd0n0bYT1TFwgrW1lnCG2YIcmTu2gOkKC
	3Ck6i15zjToxi1m1WGx4WcFisGqsZ38=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764277502; a=rsa-sha256;
	cv=none;
	b=do0F5EV1T/DZPv6pTKYQMXUr2QqPc3RPMQAYdMHxkIIsZ7YJa/ttjdtefUxr4zq01kTiHu
	8gHjYwYioabWVzwpXazVOQvEi8irnchVJIo5R2+z57S1jDhp4ztvTXJzb/HuZbs3Srifgr
	MRTblIS5ewVpPVJZZNbUxpXDii+buWo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aOXubpVL;
	spf=pass (imf25.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477b5e0323bso13108795e9.0
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 13:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764277500; x=1764882300; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RBBvxgyZWifINMkz9fV/+cWWMFnJEc+vKoCkegTc0aA=;
        b=aOXubpVL9UgbmqMDnfExPI8sowPrIYfGz4q60vE4Q49bt5GFiFtwVk7LyTAYXjH2k6
         L/zUs/TsYA+WcIBdMe4ekmK36o71r7aCA9Ha1IsCgpdXjnk2ReuVugwdUYRzVI1I319M
         thcuMFF59di5OsXICqxU4qZbTwONK2xTnTsmUWisNQaJ18bEAn4S53YX0bzO9opNSazM
         G5VfRloVnzvqay9qZkG4/+B7VBspZ4eysKY5KaN0960BrekfGAPwmze9CQvqfj1EpC8Y
         2/CiewGtuLVMdMK517q4/jV94ah7nMsiE176iXin2YccKiHcO1blXbEPA7x9lcCDrs4Z
         IDwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764277500; x=1764882300;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RBBvxgyZWifINMkz9fV/+cWWMFnJEc+vKoCkegTc0aA=;
        b=CNZOeth3N4/ty/54jiC356HXVGHBcXdlvYZVx5bbvOkz8NpoB14LwE5fUeZQX5nT/K
         sMvo1lDkmWTsuAGipTWHRMe+vVHQcrwPbzNng0s/MAMHaEMzUAMsDxOk3qVk9lFmWS+K
         WQiDcYnR6aUYfIlBvXDpVHRYIH7sor7VgS5lXHumN4vnSkGLKWJAbU8SCKeZ/a+uXMKl
         07QQixM1hMniAii2eC3pJ4/aFPLCxRZcL1DpfIHegQrtEEWecZUaAlFlYIjr0JR5IwBA
         /Bke44gkt0Mw0B3a61HUE2K/UpfjeEyeflfehkT8Nc/qsmZLBFer7W8MIOka2CcBhNM3
         L8Pw==
X-Forwarded-Encrypted: i=1; AJvYcCXyRLsKIN7r/1KyWkk5+ERmS+zayeYriaJ3UjvS7PeABoDHpEZl6V+033uowXPaaSd5e14NyVc9KQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0Pmoyw2DFBFyv5AlkgHcEzWICtB2xdSic/C0bvegFH9kuPxiO
	y/XvJkSgKhC1QYSrf8qEZx73Run/W72W8wLK/y5J5KOL7jetFxM3SlUI
X-Gm-Gg: ASbGncsgEoOrWlvem1uUtAmsSuZhqxJlDnHCb2FWZJJg+ViktCAMu3CRhMXSXHEPje7
	Tqu5u5mzuoOMDKsrwK/bCbeQN7g4Bk7GVPyIn2dW43jWbwusndQnxKJLMA3Ou6tZirfKRbX98zD
	OyXuR/nrxKAXBOgpzH3wvv6YnWfshEyXpru3CM6gS9kKh7gUyJsAdT39CCXbmzI1ewgRbyGqDYx
	8/P0cbqRxYkAZprSfaF0T+W3h1zp3UvbUCXQQgG2AAvR82Sae0ddbhwUkk8DRamNcYtWjPqMM41
	v0tTnk2u9yaIpPqlWgbA+jh8Hso+EnAP9inx0J4d8CmOMR3dViCBeQZj5oRCRje08MtOhx6W/Ii
	xBASzZLMwbb4FQxPdBZqZ96WN5UGXo/DLrudAYc31Ju9T6va7CuWnwKWxM1vE3LxMQwvl2FxIVW
	7l2MQ58nS9OmC6K67nQaQwJ6ZCXevgmSLgVdEq6aPbVFau2mwt91qBaSMPd7mQgMsiQUyg4CbXH
	eBSYjHLBPF8
X-Google-Smtp-Source: AGHT+IGb0ks6/klyin7qZnbtX5/7Tp1pDDxVcoRkIeVZ2ynIDtL+0fVbk8+RYn93h0Y99LtD+Bn/rw==
X-Received: by 2002:a05:600c:4eca:b0:46f:a2ba:581f with SMTP id 5b1f17b1804b1-477c0540a68mr282815585e9.16.1764277499988;
        Thu, 27 Nov 2025 13:04:59 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e750:1800:450:cba3:aec3:a1fd? ([2a02:6b6f:e750:1800:450:cba3:aec3:a1fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4790adc6f7bsm122263015e9.2.2025.11.27.13.04.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 13:04:59 -0800 (PST)
Message-ID: <56673a9c-a4c9-4962-baec-2d4483af3cfa@gmail.com>
Date: Thu, 27 Nov 2025 21:04:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/memblock: only mark/clear KHO scratch memory
 when needed
Content-Language: en-GB
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rppt@kernel.org, kas@kernel.org, changyuanl@google.com, graf@amazon.com,
 leitao@debian.org, thevlad@meta.com, pratyush@kernel.org,
 dave.hansen@linux.intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20251127203724.3177621-1-usamaarif642@gmail.com>
 <20251127203724.3177621-3-usamaarif642@gmail.com>
 <20251127125539.98b2f148c6225f1cb7c9d045@linux-foundation.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20251127125539.98b2f148c6225f1cb7c9d045@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: nas4yitgethr9kxto5nezhk96wpq8n1f
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D8162A0018
X-HE-Tag: 1764277501-949897
X-HE-Meta: U2FsdGVkX1+UxQzduJbDHn9qqMzdFwIBdD/wAfUxw+pYkY5cKh+PAVz6SswemMBqR64ZA5aeXv6uLZsOGlRAmQ+GtSfGke7MH20We4iC64KkWp8LxT/kNlTHdOPnCw5NbTTxm4kvtuwFumBd/V/rdi2kjsah4cnHqweB1QiBPCLKV1C6J7oInLsfYZYRSOzVKan2Z4LIyJAHq7D0I2xebETIB+a/walsK/hcufdCA1rVTBX1W9NdsU+LM0KVu0XgyKORE1dKMRN6Z/TbLkYJA0tNuTwP2jt2QmKuHN+nLDSXVEUtMQc2X8LdlQE1t93Wk5RA2zxzWUwiG0j7GskU4ZF8gQcGpY4+tsYdpIXoc6Ve+EJy5M8p1P4eh/p0y14InScD8+ei5eLua/5PeeZwbUP6DjDltk86pjJDQwLRTyGWbg+YuOdN6sgK2Ew4+i2+rQbUvu1rKKdmsC9OivLMH0GFhe9eTUHH1qkXPfpbbYvyaKnxhefnIJ5YcsY7XgSEeyUmgHqMXNu7YIfjVj7nrWu7/BPfrbJ76Cpu0PVa0qXxbbmQXQBrlIvKQRp+d54WFYfUYjE+EHJ4a8e2JUWLdoqNKokFKVmaQIFzXow3nUKdgnRrZH3zouoCPID24CnlvybmSj2VzpxS2R0Q4QIQ4mTEaDZkksAllRnVCiBMbUu7ogeF6UNEs5nBGIuyBkh97fUeW3xLVT8xYHrgL8tUcbGIVqTdhNgilmTJU9y4KZL7mQPVukehFhjBqldA1co74di12jw7OExgkZyFpN2Ggp+HrYkmO+FvP04AHzXs28wxXK31thXuRJdFAcZoBvPWAGkoOJIRHDjcQigDUDvocPCUmkCN71xfZQopqQnhuq9511WBbYMwDjJVKdINhO7eKTSt7/tWZqxKUGiDN2St7jxQqPjPWukCjeoHNe6dhBFfu9loA7/FHPFJVothgt1W6ene8BKUGWBhRkZvIWu
 sfrVgwWL
 SRhiRm2OSs8bK6jwSJDc48FDJkxSDQ5coIjAlV3zAzKEZZQpKCBRjtyicf9f2mfr+LN3sQ5ydf+7s00Xgay1lX5h/gcx/6ks3nhNauo9pJYXU6Zj92/KJiRXTwWcKXxbdPZiX2Z2JuWx3bJ4dZuJRsnSyeKIZ2sMm+JZpOOZDkR1TqQtceJeImiz7dryJWn+90b4O+WdXYKOa8UAmapQBqeh69ALZw68umqYzpj3aUrafDfgIBQV7vs5euwSXE8R0FjnVnZfJ9Gr1mIeFGcrrO5poMbLUWk/zDrr5b4LQ8GlmWBbIJBdh9gMlROWnSnr5zRn7/YTA8au4Qavcey9o6qUUifvDhBS/420YUslcQR7QhBTPzQSB0cNS8mjZK3W/GatfB15Lf7kDF5Q6KRJ+o3g3m86R+P5LeLdssfaKcjn27mP2MWBSbPvRA1JYGzBoRQlsmcyURlqMXXELK3S/N1bkD9f9X1Edtnxt9dm4MHryTFamfkY66GgXueLv7k385qmo0sbBU75E7rY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/11/2025 20:55, Andrew Morton wrote:
> On Thu, 27 Nov 2025 20:33:20 +0000 Usama Arif <usamaarif642@gmail.com> wrote:
> 
>> The scratch memory for kexec handover is used to bootstrap the
>> kexec'ed kernel. It is only needed when CONFIG_KEXEC_HANDOVER
>> is enabled and only if it is a KHO boot. Add checks to prevent
>> marking a KHO scratch region unless needed.
> 
> What effect does this change have?  Lessened memory consumption,
> presumably.  Of what magnitude and for what time period?

For some context, this came out of https://lore.kernel.org/all/ba690e06-c2a1-4d2e-9428-9ca2ea9f2b86@gmail.com/
(I should have probably added that in the commit message..)
We are experiencing several warnings a day in meta fleet due to a warning introduced
in that patch. We dont have CONFIG_KEXEC_HANDOVER enabled in the fleet. The IMA memory
seems to conincide with the 1st MB, but as Mike pointed out they are different arrays
so this scratch memory is likely not a cause of the warnings. But it is not useful (and
was a bit confusing) seeing KHO scratch memory being marked even when KHO is disabled.

The imapct is as you said, but its only marked for a very short period of time.
I think a better reason for this patch is just to not mark the memory at all when KHO
is disabled (or not in use) for clarity.

