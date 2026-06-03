Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0328FCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587AD6B008C; Wed,  3 Jun 2026 07:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55FA26B0092; Wed,  3 Jun 2026 07:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F8C6B0093; Wed,  3 Jun 2026 07:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 304E86B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:22:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E7EAA1202F5
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:22:49 +0000 (UTC)
X-FDA: 84838364058.05.3C92DA3
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0AF6E1C0007
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:22:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ImG96+Vu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780485768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lZSbyRe0Cm9MsW0vFwS1Xzmiqu2z6riqDTx2v5DdObE=;
	b=XNX0DwR/P+sciJhMBXS2tTRvGBrWA/Gs/ukeWE9dArTz84akAtosS4iIsAzNq4vv8KBc5g
	Ig4EXCWr/vbtDB6HQwj0ylZ6nIeJ0cH5d1B6zPn9rm2IxpNq4Y1Ycv6F56cYMe6hyCyPMv
	Ab0Fpy25c/ssMHJBB8oa5cYiEylBb68=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ImG96+Vu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780485768;
	b=et/ghLzZhnIaENy7UwUz/1/MCnKS0JT0KXObgrNLY8ts5hTim4GGqTKIsdU/GGM5kM7DPS
	e05qkRlWxxQgsrr9MvhcQlCEJIbsgLWqLDu95rCyCo4Y0nfEGLWmCOmMZ4cIXv6z1b04wP
	KMp4mfwAtAUwHdyy/3q9eTzU/stQJYU=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36d5fd50d20so3080653a91.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 04:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780485767; x=1781090567; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lZSbyRe0Cm9MsW0vFwS1Xzmiqu2z6riqDTx2v5DdObE=;
        b=ImG96+VuNOQx7p6NKXAPpXv1yPY6YAvXG5xp/nEgr7U9Qyecq3p/XVG02kS1kobeCy
         m7W8x+VYyBKAMPS0JfsYCLxkTCyBMAbU5pstuZqy5zgbwfUdzVG1iYMtH1drB1kK4T1E
         w6RVxkv3a+7yTwPMXU98wADLZjU32lSO3fpSGGJRt5Dg7GDSCndzVQvf4l4OIpNTP+O7
         1T712CiDKe/dz2oMW9+jED/Mz8Wo1On6nh/3Te1dqd8JS+A1XMYjFL2hWyPRbeqHl9cU
         KIXCq6fCFhs3aBo8UIsZ/XzdxwLov+F/EvvM/zv0sl40c/DeeWQ0r1lKP/Gi3OkcPgTK
         1Bsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780485767; x=1781090567;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lZSbyRe0Cm9MsW0vFwS1Xzmiqu2z6riqDTx2v5DdObE=;
        b=j1LDYp8/cggYf38Uwkd7Rie1+k8wWqWFuGR6SF3Jvue8BG2XdslHnCDNLcnmyJPI9P
         D7puH+wqCRZyGXXf2TFmapzKcu2w1ASDv4QusH2RMEmkgk2aM0Y41OkxkBN+WWyZ0SwG
         isxoOE4YHDjXzMZhr0MI6LvX56n9pvV2iAt6Q71BKpcsZ6psirEGuDHsHIsKwTlpM6sP
         qqcoOmnfsSMBMrWOZEfLgX6P4AyMA+6b0xOk+LaNIUAjuoHVEQt/Zs6EU7R6xC2vqGHu
         8E4wmxBs0f3qc6kOPBo9Mw53TbVIyBBThPpkJGzihUk4Kol53HdsLpDrTAUkr81OtqrT
         K4jg==
X-Forwarded-Encrypted: i=1; AFNElJ9WhjFDD8MlG+WU5APH+X3FkZ7jARChPtB2AB+Vmo6jE2zDthLuOtWb5S/4qpVD6if4VAOEKGcaOg==@kvack.org
X-Gm-Message-State: AOJu0Ywx1XIHWiNofHmuHMwjqxSaUJWPV6gt64u3k4suezw2WOTnWdNk
	DIf2uSRCVJgWW1d6wJHJKmpKJN0IzPes7LPGUfnPlycORSsXPw93wN+o
X-Gm-Gg: Acq92OEKLMFYlAhSx5glHaaW0opx3MO0u3X2beX0/6WOSyYH4+/YbLIg+nKHwO9o1Fm
	swrUMjRJUs2CkuXmHPLONBwljUtWWkSlZodZBc4y+E7/jlgwOluno2Xz0txKB8/NBv1lchs+Jlg
	fmcDIw6SRAO5OqgTVPa/a6qf0QI8swhuW2v4SNy7lNCbJeM817dd+lNgdvPZPXTqUxCvCfIigIx
	tNEGTy9rxP8pfymFGNbvRxF/AEak0YVug8aCkDg+UhmgbuXkyZqS+uUtPkkcde01eNhf3u51+an
	BpaqG1u8dXO+3yW71nwkCbN7B6b8yCdSmQlFHxcMriCMI4Nw2mVCVjT8CxJCIeAlUYxxQvooBns
	wC6PD22mWkwL9iwkTpgQ/TbXg0eCAtPcml2VAbjTBnhOvd5ay4Er7vDXBbrLKq4FyJl6nmENtkL
	t2Zloc1+WNf/o/pCHjqCy5zKmwW3/JaMljxcBqMPJMnxIspNO2sKO7S1zdbFu7GdVL
X-Received: by 2002:a17:90b:4b47:b0:366:5c38:fd61 with SMTP id 98e67ed59e1d1-36e32f1676amr2884302a91.12.1780485766827;
        Wed, 03 Jun 2026 04:22:46 -0700 (PDT)
Received: from [10.125.192.75] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36e6b904c88sm802459a91.0.2026.06.03.04.22.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 04:22:46 -0700 (PDT)
Message-ID: <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
Date: Wed, 3 Jun 2026 19:22:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com>
 <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <aho_VtLCmIRsNyvO@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0AF6E1C0007
X-Stat-Signature: a7qo3s48yqgxgkbpc8igng3dkdei3n3n
X-Rspam-User: 
X-HE-Tag: 1780485767-788755
X-HE-Meta: U2FsdGVkX1/HQzFSoQu6Tv/nu9Iout5MnNXMKTLVM3DJY73UxY3GIJUHt7Fi01xaLmBfaaFEgUnnrr78T/SZtVxubruAE3b7ouNhhf4aQjy/dgdrb8sDf7k5SXWqrfLKQGnLiO9VJ363/Hbm/WcE0WMQQO21QDf7rMcsfhUW11LQX7wWz7xO+cERvbQrI26ySELghIyMDQnG5RnzO/QnmwFhLiDqwdWxG0xxe8vmlC1ebaGJ6Ohb60l83mdqpiiipcWMeDfgTUsUMo6nE1SC+ScWffnN/tlYGawmdXHprFp5ewpg7rY0pE46N3tOP30o1MiDI5rfxA1veoUxGRSZnRv0SFq9DZH5lM/8Fri5OwV/wFTQiTv8qi8GLk0GfRBylEI/un8wcZQeqGstBF97gc9cvcFx5lyPFRJYrd51KaIKH+C+ulmoOdXk11NWo+ARShQqcs2n9CAXphl6z50bgR/8Rd45s5KV+yzjptzLdw3QfJlIjkARpIqVXEyjW64cB0RU+yYEIzwomrQA5C0eImKvCiyiQf/kV0nQlV3pfELzAHQaXEf4vC6Z8u0JsogRzpSfPsUmy/YqDD3hh4TWxjvSWRnmzCe05+a5/Y0/DkbMWcDLbsL83WrlaoUt7osNAT+/ZCHTeTJD2Xdc8rICLrEnT9A5mZHZFX+jCyJtk01Fhk9uv4NGOMF5OuHDrZWar0eDeu5XcLVPHNp0Yn7+AvUOloe8TmjMb3uw22LP3ma91SDUfFrVxiF5Gix4xnmNGT6kTxQo+EeFtnzM5cDSX3OFkuv+7oEfdXZnQQI5UWW80dyZUmMB1SCrlb2gZgPTPxPyROYxOszJm/97X5uOVTUsnheKOH6zXv+OpW+cqCyHiCIhwJ7ejy7KqirqDHkEHXDmdIG5UIolO8zE6t1H5tBmNdHyHnow2Yl6ke19AClvqCg3I4Nq/WQTtS/N2YtNoXqCBo/NgZb9Ecczp4M
 guiPa5M1
 s2qKAiXL8SuvCRIODGuxrOaz1zbkLHJ4temr3kQZ0ps4TseX7PHbK2LRggBugmHOVDJA889eQ5ZE+AAO812yzXYYJIfg7fr4rJvTRPmfvFPihlRGCxEpUZnu2fxxyzfqHeQNbif8BRuMx8ytou/ugIxuyTtLLEl7lPLQK9jfpGPZIJ8zPVfo+CCHctv8d6sGLMdlzun+/+TwkYGnJEnDvvqUhp4a2QY+xBu7I5mGPCzb8fO7HAiYmqKqIM8Zpm6Wg48pIYfouY5YxNIEXmNm1B9fMyYMXa7hrYMsy7+pLY+kuCiFxq8olXtp1iX4+UkCp9EM/5A1pijvOpaHmZIlR4+kkIYUG304MccD5Hb0rXsEAka9ONjB0nbqg+iCkl19RvIhsZq6/C0DyUQr6lAN8iFmZ99pfTlok4n2rKpbGApj+l5ZjBRBJHVOr7VwnkYkONLZnpVdhisYJ8uNgxE25KOqCsLn4jDfMbad4sMJoIkIhfRj/4NduMfyeaR18dICAt3O0b4wx1tSArfGmx0mLa10rOx79p70T4rvJadA/uSMsKZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/30 09:40, Yosry Ahmed wrote:
> On Fri, May 29, 2026 at 12:58:09PM -0700, Nhat Pham wrote:
>> On Tue, May 26, 2026 at 4:46 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>>
>>> From: Hao Jia <jiahao1@lixiang.com>
>>>
>>> Zswap currently writes back pages to backing swap reactively, triggered
>>> either by the shrinker or when the pool reaches its size limit. There is
>>> no mechanism to control the amount of writeback for a specific memory
>>> cgroup. However, users may want to proactively write back zswap pages,
>>> e.g., to free up memory for other applications or to prepare for
>>> memory-intensive workloads.
>>>
>>> Introduce a "zswap_writeback_only" key to the memory.reclaim cgroup
>>> interface. When specified, this key bypasses standard memory reclaim
>>> and exclusively performs proactive zswap writeback up to the requested
>>> budget. If omitted, the default reclaim behavior remains unchanged.
>>>
>>> Example usage:
>>>    # Write back 100MB of pages from zswap to the backing swap
>>>    echo "100M zswap_writeback_only" > memory.reclaim
>>
>> Hmmm, so this 100MB is the pre-compression size? i.e if this 100 MB
>> compresses to 25 MB, then you're only freeing 25 MB?
>>
>> I'm ok-ish with this, but can you document it?
> 
> That's a good point. I think pre-compressed size doesn't make sense to
> be honest. We should care about how much memory we are actually trying
> to save by doing writeback here.
> 
> The pre-compressed size is only useful in determining the blast radius,
> how many actual pages are going to have slower page faults now. But
> then, I don't think there's a reasonable way for userspace to decide
> that.
> 
> I understand passing in the compressed size is tricky because we need to
> keep track of the size of the compressed pages we end up writing back,
> but it should be doable.

Agreed. Using pre-compressed size is probably easier to implement. IIRC, 
interfaces like ZRAM writeback_limit are also calculated using the 
pre-compressed size.

I'll clarify this in the documentation in the next version.

> 
> If we really want pre-compressed size here, then yes we need to make it
> very clear, and I vote that we use a separate interface in this case
> because memory.reclaim having different meanings for the amount of
> memory written to it is extremely counter-intuitive.
> 
Agree. This would indeed break the semantics of memory.reclaim. I will 
use a separate interface for proactive writeback in the next version.

Thanks，
Hao
>>
>> The rest seems solid to me, FWIW. I'll defer to Johannes and Yosry for
>> opinions on zswap-only proactive reclaim.

