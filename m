Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11122D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 205BB6B0307; Thu, 22 Jan 2026 13:34:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2E76B0308; Thu, 22 Jan 2026 13:34:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5586B0309; Thu, 22 Jan 2026 13:34:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA6686B0307
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:34:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5100C1C9C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:34:58 +0000 (UTC)
X-FDA: 84360451476.08.C575B73
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id F0C81160008
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:34:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FgscWsjk;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769106897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mq5VJmqRAo0xyjSAtScAIcpCkrPE7TyUs2+qpNnChkY=;
	b=Xmv6ebqKOhRe1IL20Ek35ztpuGask34rG8z6lhojPIX7qIh/DzKJiXemVZ+WGm/QrflGPf
	/1TEGYmRXVNmXvEBgKlrbszzat/jLAlOyjLj5x3m9C3BqXiRfKXZsbuRro7AxM4zJUJWrD
	SzGtdC83GYQagPMRhMIQsjYzYRNrcVw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FgscWsjk;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769106897; a=rsa-sha256;
	cv=none;
	b=poXyPTel7L6o/H/OCsOnlWuF2yHtlYPAgFjJaqzGF7U/Cyq8Kf7lX6F/GG0jV89xiHnGml
	VbNw+M1Jr5h4ev3BwrfkLCNfDjkVDPsVkuiVP+EE/pcWsOIOPuMU1yZ2mDTyWvfVr55/zK
	XkypXrUDdKBGSV6Fk1SCDrSVj3juISo=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-640d4f2f13dso1393379d50.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769106896; x=1769711696; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mq5VJmqRAo0xyjSAtScAIcpCkrPE7TyUs2+qpNnChkY=;
        b=FgscWsjk7j2DSmHC5bQ3XS8W+d0nWEsaSeMSmVqaM7ICWSZXDbwhxPFeMVe1yDuwUc
         zPU57YZpUMpjnLVcy4h0gxvAfT4jul/GrClmDJtugbEismIRJ9ea4EncucHXcQhX1+8+
         VK8xF8FsQnHp50hcmVwXDlIEks6yfpiCfarqW/YFJyT3HvUDZIDL8QH1syGO9gdOmgGc
         AaXaPXXsC5MdXQC7CcQT3bHii5zsG0BKD9Jjec0qirXRXI9ynwOntbk0vhShNrJLjVb3
         jHFxKCEr92U4k9VZmsXNdHxLBcM3CCDwUhckb+NRm9ijiRpqQFxjLrEQDdAgdS0ZOzGe
         AWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769106896; x=1769711696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mq5VJmqRAo0xyjSAtScAIcpCkrPE7TyUs2+qpNnChkY=;
        b=DSr+TpqTMwfxTMCTJzQzNI7vdg4TgFosXJcUvE61G97PxT9BOKFCU7g+BrCw6qkpSD
         4TLLNPbLAcxQQ0PjYbsz6kWsxwGPgR247ALUfoPYFvEUw5CV5M3iznPlBiPVneG2tepP
         qUvDK680/9pTMJcXUqASTFHlMG4VwzwgueESXYnyavbLkUeJ75ThkR27kihlTHzu3ByL
         W6j8ZMxclQK8lLtURzFf5/ValTgIf3SEq2jdUkMWRtFHeCick6dP65zWZVYW4i2dW+Wr
         qNpIGQ6c98yGgmi8vCAOE9qQq/Kr0h3+navdHhf9DWMBMnZMRCJ39QwnHesZ6GXqMoYl
         ow0A==
X-Forwarded-Encrypted: i=1; AJvYcCX2XetpJIPUiET3kxbQb1MUBDnPWewBS/5ef5pLxxzVT9t+9AHYxxDbFDPNee/hQqEhBKgjSnUtzw==@kvack.org
X-Gm-Message-State: AOJu0YxiYSlgrw9WzUNmQnsCzSYZSJrY9gmGQajakOey5IXA37/6dEwU
	T0OUPY2ysMwJ9AjjSr0Js+aVfp9VbpVPREODs6ePH/KWujQtS0dCzKXj
X-Gm-Gg: AZuq6aLdE/o4clwUwEvclwsvYoQTuam0VldS/jl0WKfQxffg+Td+Y9LpqLvfRU7avJ0
	OsWqxzWKvV1Cv8esNzQhrQEd2/lMLe2i4v9HcEIfqLZ1+e+AAnBkfoBYuVjWpjf2WFjVwVtOOaQ
	odFInYIoVUSKBvDUrozVBNXfwDa8oYA6C1mrs0akVtfy2Z6WU9qPIrHWdFnFgbVl8RympLH4ao9
	yuLEFzcvShEHrrgDpFI49Bg8LM+8ZY+fY0ccCZ/FoOXchpf0Zfy39as4CNTKGNtM6dk0IWGiwUF
	ZSuyNL1ry9kqISgXossCFmpc58AWEJBoAI+sCyJ9jx3E7j8WPkef9ycqqMyxYkudWNGFv9lHcE6
	/XEhTqvwhMZ0OxjtV4iRITPTx2Kc9qsNQIiIbV2per8lWd2ECk8HFBxRQTDl4kJgay8Z05NiHuV
	jddwRyTilrrA==
X-Received: by 2002:a05:690e:13c3:b0:644:71e8:cd02 with SMTP id 956f58d0204a3-6495be6c0aamr352932d50.4.1769106895892;
        Thu, 22 Jan 2026 10:34:55 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:47::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-649170bebaesm9858332d50.21.2026.01.22.10.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 10:34:55 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	bingjiao@google.com,
	jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough free memory in the lower memory tier
Date: Thu, 22 Jan 2026 13:34:53 -0500
Message-ID: <20260122183453.2619156-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yt46617pfj9r93piafwq8jefsti1yj5x
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F0C81160008
X-HE-Tag: 1769106896-456924
X-HE-Meta: U2FsdGVkX19HDwNO6Ryn0gTWr9OF0tGXAPiBKf+fOlRdyUsUxG7Q/AjQrvhh48CctDUrgqcVTe8QY+Inuhb5Xa/WHQv0zDLCmZwEni6NdLXoZ1OsXBMkq1x8ZvpgSx+YkOePDnUGf33w7rDkMMjAin7tV+Kp4lmsZAXuBCS1j9XICjwm1nua4fe80sTsa7irNdKEKV/4lSkejwa1uh7tDGi0qs3AuwU8KC6BHQC/TWEJJcWlXDJihh4cjSNbR/A8iJXfIJfpXO3K0a84OeW945MMoR3Xgk2B6MefSbBqMj6onuix98XxioPYmldztBtCa8oRFw1Xmg878Qq7AZGe/eZWaFLM5tTVJGqQwOPzd1cb7BJfW77qCKjfd1qOkAYt64u6TBSd5Sp1p4kSiCRN+dKgrsBOpHtZh6UHMkrJ1FDLOwHriQXVXvG+lCq+ra2UBzVVpoZfJU/KHWUxdUCMNKw5logR4cydTWew2zOczNJ664QjG/sdZ/bhxisgrNYGb6LNSWM6nahjnBaQPt0LU1Xt3E0+sfxeLRj0V9db8FZ1R9a32iRn75DWsGsfCbKg0rmmgUEe35ely0kSKbPMzdJOa8ejUwIxcgSTvf+efgpieeyCfZ3hO922sQQsmU5sjnUedKG+kFCWWPsh7uSEe/j7Y1d0Od/m0UekpCDdrXPPabvhbVOGJCWyeRmuaAvbV4W4qtrWV1PMiTgDb7XDbnrJ0C8l6VeHmDeYkrQ8TWYnVw6wmVd/ZtDhZbdT2KDKCu8O4jMuv4OZlS5D6mka2RSFT9mzZQXLXf3J67I6jJKj+Tn4atRxBR15wNQaS/AibZHuox1EAtPajkR/QI43eDu2VQKpZpKtIJz6oJfB9aSIkms1dGzLd8BFez2NoMOLYS26sMzkmpzD2DYSCUw+z+H7Uu57mH6xjFw5qt6QuICQ3WMQsi6uJaFO0tzMrXO1mwSb4xnmRyyl6nG3aVb
 aM+pMa55
 mRhg5p3PCN41wBBkr5B/aOr+Yt/PcH7ZEAGdwIKqRdRblmVk9HENA0awTCIzVpzA1fOIHNtyl/OoxQUixyL4bNoL3F5ZPbUdm56bD4kv5pFIYKW1mBapSd3y9hNkSN9McraacH921CNOwgkdWpeY9bQ0snWdavGPRlg9NdQ8m+68UBzscEhUA35dI2160K5IFjIGy5obJWkJN0NQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Akinobu,

I hope you are doing well! First of all, sorry for the late review on the
series. I have a few questions about the problem itself, and how it is being
triggered.

> > > On systems with multiple memory-tiers consisting of DRAM and CXL memory,
> > > the OOM killer is not invoked properly.
> > >
> > > Here's the command to reproduce:
> > >
> > > $ sudo swapoff -a
> > > $ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
> > >     --memrate-rd-mbs 1 --memrate-wr-mbs 1
> > >
> > > The memory usage is the number of workers specified with the --memrate
> > > option multiplied by the buffer size specified with the --memrate-bytes
> > > option, so please adjust it so that it exceeds the total size of the
> > > installed DRAM and CXL memory.
> > >
> > > If swap is disabled, you can usually expect the OOM killer to terminate
> > > the stress-ng process when memory usage approaches the installed memory
> > > size.
> > >
> > > However, if multiple memory-tiers exist (multiple
> > > /sys/devices/virtual/memory_tiering/memory_tier<N> directories exist) and
> > > /sys/kernel/mm/numa/demotion_enabled is true, the OOM killer will not be
> > > invoked and the system will become inoperable, regardless of whether MGLRU
> > > is enabled or not.
> > >
> > > This issue can be reproduced using NUMA emulation even on systems with
> > > only DRAM.  You can create two-fake memory-tiers by booting a single-node
> > > system with "numa=fake=2 numa_emulation.adistance=576,704" kernel
> > > parameters.

[...snip...]
 
> can_demote() is called from four places.
> I tried modifying the patch to change the behavior only when can_demote()
> is called from shrink_folio_list(), but the problem was not fixed
> (oom did not occur).
> 
> Similarly, changing the behavior of can_demote() when called from
> can_reclaim_anon_pages(), shrink_folio_list(), and can_age_anon_pages(),
> but not when called from get_swappiness(), did not fix the problem either
> (oom did not occur).
> 
> Conversely, changing the behavior only when called from get_swappiness(),
> but not changing the behavior of can_reclaim_anon_pages(),
> shrink_folio_list(), and can_age_anon_pages(), fixed the problem
> (oom did occur).
> 
> Therefore, it appears that the behavior of get_swappiness() is important
> in this issue.

This is quite mysterious.

Especially because get_swappiness() is an MGLRU exclusive function, I find
it quite strange that the issue you mention above occurs regardless of whether
MGLRU is enabled or disabled. With MGLRU disabled, did you see the same hangs
as before? Were these hangs similarly fixed by modifying the callsite in
get_swappiness?

On a separate note, I feel a bit uncomfortable for making this the default
setting, regardless of whether there is swap space or not. Just as it is
easy to create a degenerate scenario where all memory is unreclaimable
and the system starts going into (wasteful) reclaim on the lower tiers,
it is equally easy to create a scenario where all memory is very easily
reclaimable (say, clean pagecache) and we OOM without making any attempt to
free up memory on the lower tiers.

Reality is likely somewhere in between. And from my perspective, as long as
we have some amount of easily reclaimable memory, I don't think immediately
OOMing will be helpful for the system (and even if none of the memory is
easily reclaimable, we should still try doing something before killing).

> > > The reason for this issue is that memory allocations do not directly
> > > trigger the oom-killer, assuming that if the target node has an underlying
> > > memory tier, it can always be reclaimed by demotion.

This patch enforces that the opposite of this assumption is true; that even
if a target node has an underlying memory tier, it can never be reclaimed by
demotion.

Certainly for systems with swap and some compression methods (z{ram, swap}),
this new enforcement could be harmful to the system. What do you think?

Again, sorry for the late review. I hope you have a great day!
Joshua

