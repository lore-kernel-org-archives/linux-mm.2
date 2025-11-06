Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F65BCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 06:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55F68E0008; Thu,  6 Nov 2025 01:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D768E0002; Thu,  6 Nov 2025 01:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943288E0008; Thu,  6 Nov 2025 01:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8047C8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:42:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10A39BA45B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:42:11 +0000 (UTC)
X-FDA: 84079237662.22.00D0C2B
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3B83940009
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:42:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=hUMNU3ks;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf04.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762411329; a=rsa-sha256;
	cv=none;
	b=t9trM8ayU69ma94htBcjUldmxCdijPoiQ/Ycl8Cj0jsl8pi26sb4eSm/EwSke54MCT5ndE
	1C9odCr8PVx0/bn6dK7kiz7Cit9qNTwuaCrMRE4acDryBf6bPKdFoCbVdaqHDmwNfcAr5R
	B4GmSg3A7b78Nmu0kzUQ48xGm/GDsEs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=hUMNU3ks;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf04.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762411329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TL19hVOz4D0kxYhklrn7cfeF0qsMbESAPz4b68jgXaw=;
	b=WXbVqOBoUQzCNaDb4Sczd05m/nx108PFyAPafJiM93nr6iWHsSbetVgui3ylAO93zsTR19
	hbirCScVHrb6d5ZXfoy38CcwErgOPQZaJGRfEPvwRjUYXpa53bpwdyj8wSamnRjSQ22NcF
	p7i+q3xIxon82vhAWfHuJO1t56gwA/g=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29555415c5fso8380135ad.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 22:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762411328; x=1763016128; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TL19hVOz4D0kxYhklrn7cfeF0qsMbESAPz4b68jgXaw=;
        b=hUMNU3ksGWXkImgZnKeEcAIhOzo3nnP9Q+qZuHA0/CvFwSeQu5glor0f3l3n4eyx8B
         jGOjQgCRZE2Y7eV7dej7tDTUCsz86D2ucaAuRPyU8USq2+yy/pDfFZfYIJ8D3AYpz/jK
         dE9I2WiFiRew0HRKeTA7sY9N33DVaW6p6QeDSJJnWD+9TAJ7nSetFMlfhZzttY5wczVB
         TLNFgTYPplBXlEo1xLdc1J8kg0/vxK0yfO6dd0Otv/Cng8K/RZLU71cFuMsadrI+z4tm
         nhIJFwIs8zXlBy1nJNOP9BwUkFGpwkbFIaomgOA52CM5RMCqMjoZWtNbv/RoSYljr0It
         nAuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762411328; x=1763016128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TL19hVOz4D0kxYhklrn7cfeF0qsMbESAPz4b68jgXaw=;
        b=jqTgycAv7sL3M+Xb9rh3KKksNQIzRe0tDuar3hdRUJldl33+g6/bxc+Bpid4937fTq
         BBqrZDdW29HdZhbyk8nfr5lOmAmC8lZqcqgWwOpu90BsIwzhh8AwpuzvqpMdk1FbyHp5
         UDpvqkjAEVrFVyprJAHOm8RJZCkvvQOj8kRiGeiYj6X8Wqi3UqG3HWtTVI/gQ7tZgEsW
         IrXiPDRkreY+PvM9M5ElaV9dr8wCuh4SkFpv18mLADGS6Ntz9eZ2mrrsPSC4yxqFR4hR
         5oePZvjx755zHgCNmoon1CUqEV6sMkxtDJ4a6/nBIfvli72KQzPBIsWDQAhD1+60v7AD
         Q2NA==
X-Forwarded-Encrypted: i=1; AJvYcCW/9dO4tigWh0sy7p4VIq9KCzAYrm/kPCAtppk72K6FhdD+3pIszK5eWVfMOaLMnQV8YDwaPNvTCA==@kvack.org
X-Gm-Message-State: AOJu0YyCncpAPzEUSYsOkyNtUaTKRJoAHi8vo9ECE3smWkySmcCi/eBR
	Ab76TqHAT9I9kUc1qxk/NEZdbN9xg9R+Zz+2Zl/akCXsZnAjWNBgsnCh4Bc5Wk4JVTs=
X-Gm-Gg: ASbGncv4Y+GHlnIjqYUVvQIJrFSi63yRO5Af4EoJqih576JOWZH2JlnbqV+1r1Hzm62
	UeKc47f+wwquiA73U6eMYa/qnadgyazW5syYdB7s3hWVQRpjx7dOEVB68QgkUP/UD2Sx33oib90
	oxxTIyNmdb3MZSktq3tkfRGuGqtioCd4acGV5og1wooMcBpluwwQcuXvKDxz+PdwqnSeOfe4GYn
	nBNHOnEOWlvWwYGpuRr/e4DO2ARDy5YU2+QqK3lpP86Jzoe03QWpXeS3KrXPpl5WKf1jw8SoyAr
	5qZe1YZ3gb3SX/N3NL6jfiZnvr1lDtTFiQSYlL+QtatgpVMLjNG3+b1lmcwxVi+CbnIJmf1Wa/6
	I0TFr+bNUryQfPmAWMRVxY4dv9ZClbuIz4rfVrEQNcxaw3MWWcaj3+MsbGq4XmES68TvpiqpOFm
	DkC9ojgwAml0QtKA==
X-Google-Smtp-Source: AGHT+IHUkyt8WCcqdVjY6Gz4mADuanTmzresjnwoIZFRGAhN7gntziMCQomA+rIkuthn7tqcXJO81w==
X-Received: by 2002:a17:902:e5c5:b0:28d:18d3:46ca with SMTP id d9443c01a7336-2962adb62f9mr95573365ad.49.1762411327911;
        Wed, 05 Nov 2025 22:42:07 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651ccc19asm16080265ad.104.2025.11.05.22.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 22:42:07 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: inwardvessel@gmail.com
Cc: akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	jack@suse.cz,
	joel.granados@kernel.org,
	kyle.meyer@hpe.com,
	lance.yang@linux.dev,
	laoar.shao@gmail.com,
	leon.huangfu@shopee.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mclapinski@google.com,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry.ahmed@linux.dev
Subject: Re: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
Date: Thu,  6 Nov 2025 14:42:00 +0800
Message-ID: <20251106064200.64198-1-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <c704e7d9-5bc9-43e6-98cf-d28c592b0f3b@gmail.com>
References: <c704e7d9-5bc9-43e6-98cf-d28c592b0f3b@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3B83940009
X-Stat-Signature: z3ji49ycp4rbkpag6dkxmixwauj5euu4
X-Rspam-User: 
X-HE-Tag: 1762411329-896716
X-HE-Meta: U2FsdGVkX1+0WmN0sYajXVRCQZChWlAqrHH+5j2CQfbnPZV7IpgMybBDub/ww92yR15n0hpnrGqN4L813oFtd4ZB/YfMCl012lf0EQa666WfTImagglXhYp1fYTUdh8GVvcRNXcnySYSKs/kQS2gIezy/H4uTlrf7auhVxz7viMUEbEBZj3MMrC3pHkA7mER1ZNr2lJl9IY0XzaifoGzoI2zXg+CC6P4RQg3lgtLVgrai2qqOhRt6Nc/o42v5i1UTBFbul6kHT3qjXSZTSmSpCFVOoiVJWyxF49gqylA6XJ2j2WLn/cOxM+Jg8ITEnrKay3uXHEifMFLWVpT8b7i1yKPLo72yZcwDnIQhaSY+uFmyyV95P/VkyLtG0/SV7U2YnHWsXSYTKh6hDVTAU7eZJY5YRWopE5ghobaA4T/gwDxXHDh6hYph+McuZs0JbZIUCKmfEGAaJ5koKDajeh+OT37h+3tdb+vFa8SXY+Xj3zFYr6q/Cjp1MoPizNEWqyW0DhvvfH3UbG+LlORLRsjgGpMpLIxSlqTnN8pM+OFE/JkQmQ26HdFoqkX0b1KcdrdHEC2oT1NpFrchc3lFnMmui7COxk4jdhC4WNVD92EYwkizv5xEdvJPDZyU2kUFgOkpY/aDrJutGutnznR5MWlE5n9h13tpMgtsKZiU8353y8SgOqHXvgOdk7uTts+bh4L445j0F+v776/f32mVbD9b1U6js6pZr4nasfHi5m4yR6/COKxfE2vHmnXk8JIV3bNFzOXfsKLfxFGmE31CpXZ7C5594V4S0yVBYhtlL+B+j4A2Vlp74mIYr+Ccxj9crVvskhDiPG0MTs77Ti48QjydmI9cKvAWEkk/uD8xaiLegvjbWD53I5sOEfQQTtn2CAqzoqsRJGVk5WCB/cL++8+3DGAoyKhq443xxJY13jxSsOgQR4nkNeWP7Gq1tUMp3tFRivtznAFDqIbn55+oy/
 yc1NMIxb
 lmpf3Kp5fBtfRu4urEjY8cbG0Pn7tIA29MNBlp/nPv1TTM70owo89ZL0ZZ1kNBrs3d7Nam6HwJnAFVrwmYJCLefgKIaFDTTbmfczz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On 11/5/25 7:30 PM, Leon Huang Fu wrote:
>> On Thu, Nov 6, 2025 at 9:19 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>>
>>> +Yosry, JP
>>>
>>> On Wed, Nov 05, 2025 at 03:49:16PM +0800, Leon Huang Fu wrote:
>>>> On high-core count systems, memory cgroup statistics can become stale
>>>> due to per-CPU caching and deferred aggregation. Monitoring tools and
>>>> management applications sometimes need guaranteed up-to-date statistics
>>>> at specific points in time to make accurate decisions.
>>>
>>> Can you explain a bit more on your environment where you are seeing
>>> stale stats? More specifically, how often the management applications
>>> are reading the memcg stats and if these applications are reading memcg
>>> stats for each nodes of the cgroup tree.
>>>
>>> We force flush all the memcg stats at root level every 2 seconds but it
>>> seems like that is not enough for your case. I am fine with an explicit
>>> way for users to flush the memcg stats. In that way only users who want
>>> to has to pay for the flush cost.
>>>
>>
>> Thanks for the feedback. I encountered this issue while running the LTP
>> memcontrol02 test case [1] on a 256-core server with the 6.6.y kernel on XFS,
>> where it consistently failed.
>>
>> I was aware that Yosry had improved the memory statistics refresh mechanism
>> in "mm: memcg: subtree stats flushing and thresholds" [2], so I attempted to
>> backport that patchset to 6.6.y [3]. However, even on the 6.15.0-061500-generic
>> kernel with those improvements, the test still fails intermittently on XFS.
>>
>
>I'm not against this change, but it might be worth testing on a 6.16 or
>later kernel. There were some changes that could affect your
>measurements. One is that flushing was isolated to individual subsystems
>[0] and the other is that updating stats became lockless [1].
>
>[0]
>https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/kernel/cgroup/rstat.c?h=v6.18-rc4&id=5da3bfa029d6809e192d112f39fca4dbe0137aaf
>[1]
>https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/kernel/cgroup/rstat.c?h=v6.18-rc4&id=36df6e3dbd7e7b074e55fec080012184e2fa3a46

Thanks for the suggestion! I've tested on kernel 6.17.7-061707-generic and
the results show the problem has actually gotten worse compared to
6.15.0-061500-generic.

Test results (100 runs each on the LTP memcontrol02 test scenario):

Kernel 6.15.0-061500-generic:
- Failures: 2/100 runs
- Failure rate: 2%

Kernel 6.17.7-061707-generic:
- Failures: 25/100 runs
- Failure rate: 25%

The increased failure rate with the newer kernel suggests that the lockless
stats updates and subsystem isolation changes, while improving performance,
may have reduced the implicit synchronization that was helping mask the
staleness issue in some cases.

This reinforces the need for an explicit flush mechanism (memory.stat_refresh)
to give users control when they need guaranteed up-to-date statistics.

Thanks,
Leon

