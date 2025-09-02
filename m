Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E357CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 22:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8E26B0008; Tue,  2 Sep 2025 18:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663B76B000C; Tue,  2 Sep 2025 18:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550CD6B000D; Tue,  2 Sep 2025 18:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3016B0008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 18:30:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9352F58E84
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:30:20 +0000 (UTC)
X-FDA: 83845755000.26.CA911DE
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6E73220005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:30:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dFpU6ost;
	spf=pass (imf03.hostedemail.com: domain of martin.lau@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756852219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WcMClNKqF89fyusNx4KAf+ldD0MkJVJrNd35mLcgadc=;
	b=VOvHlw+kf+IfK6+6kq2o93MJskerp08eNacXKTV3gkzNfrdYErCxDCzmQtxM0fycbcJxpr
	+F/uKtQ2DVDp72Rw3LvH3sKUWtOZO4Elet6XmgYGZw0SVef2D86wH0TNB62jb4l+xd/j+4
	zEnS8WZdyNdAns29YWE2QVuNVifx4uA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dFpU6ost;
	spf=pass (imf03.hostedemail.com: domain of martin.lau@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756852219; a=rsa-sha256;
	cv=none;
	b=c1555DQ9Gjm2lxJxVAjTB3mdU1DGV3tXOUaBcCZpfoN8wS1atVkrOPY30xMtGyafcQkalD
	Q4LwKRV1c+8ntlU7DqfjsMnNK1vNWa/naqGXZWXdy7Alrvu6h6lazWpG8YwS3WHBgnurxn
	uH+Qyd/sn62Y0uvpwY8jL98ITeFGOYc=
Message-ID: <a76ad1e9-07d5-4ba1-83e4-22fe36a32df0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756852216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WcMClNKqF89fyusNx4KAf+ldD0MkJVJrNd35mLcgadc=;
	b=dFpU6ostNV6afKRbkI0/nNZ1eh0g4spiTyWoAwtlLsAPG6maCYx9BakMeKrqvtwODdfMoG
	VYQQmhW5IsWl6KjdaRxwnX1U3SYA7577sVMqDFWS/RPsPxZtC4eqdoIpdKX1J77+IZaV2g
	6KbVL82VHMnNa3lv2S59vqH/3DiDG/0=
Date: Tue, 2 Sep 2025 15:30:04 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, linux-mm <linux-mm@kvack.org>,
 bpf <bpf@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Matt Bobrowski <mattbobrowski@google.com>, Song Liu <song@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev>
 <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev> <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
 <87wm6rwd4d.fsf@linux.dev> <ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
 <CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
 <87iki0n4lm.fsf@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <87iki0n4lm.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6E73220005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bbuttcr64ncwt889o3u6je5okk5cgha4
X-HE-Tag: 1756852218-491595
X-HE-Meta: U2FsdGVkX1+KoXHXK/o1VNcTw63AdPJP0wOR736+Inz62Igbl+1p8K/SpoqQZeMadZBCr+oouSkXcSl8PJMm14XhetwUP6bdC18/b6ouOcmdj3REh5UrnrII9F1tZjrhCX0PfxuNSd0uvL8vfv1nFf1m5G5/O7X0tEfpd5VQF8Hfn+yGdOGhFjYaYfPNQbX5VkhzLTOIGnq4wUwaIZWasN+0Y7XxTgIyjpl/u8sFcbqP8NdnQCcW4wTF1joAnQsOxFYRee3tHpBLNdMO1RrPwyf/7GobQWF98D0tNT9wtO0NxWS6rhzBD0iTKHNDqbW3bpHSMWx2KmeCE17QyZ2I0HvPAfRcJiYc0hVJeCx8w2EYPk85fPv7x0K9ubjtvYKpsRQeSPcPhtrd6MKf/+iFHFlagn0xpDQWsKwOWRmR3G6r/t9EeRT5tdJe65tHaNCWkGnA5zk8LZWtmGjqFbH7MFWC5+jGUg3CvdU6kl7CzwwvI7ICpnxhZGefYTlIc/FzlRM7jHziSSta1xgC4Bl8j5mdmUkj5Qt4lBGxReDoxCUHi3Ex8Q02ZkYPVfn/FIDoZc5eiC3ka+88fnZ2V4F2SJiMv4Bm9ctOG5868Gdn+ZJYqYmx32HszoydY18jRbM7sbrqnmhu63kfGSPpCn4w6n4puNOJmrtrJjoS3Mng+g7cBi3gK324QRrTvGv7eM1UzpQxfgqYTo9yIToeUmh0H3Wgccl05keajBluyBGPahpXdppkepKH3z0LNY57uj/pw7JDoWJ5Q8q22HbHk7tipPjrozlFTiiibThNRG1EuY0yqnGW7K5ImPS8/7gQmiBmGGd/XLr+m/bR83IV/Z+7NZqwiOVzFZihFvNh1bO4b8xdmUiyJ2qmP/5gfjfvQemmFKZ67dEVh5U+YAJI1BmO+rsqvRINWk99Jw/tu9YdVMnpim2MrqgTCtl6rdK+iOyvkwbKegKs35XriPOQFnw
 0+wE2308
 ebqMZapK59+SQMVP7qTecvEiAgNPgZjpQZzhKZ48LG0X5h02LbFX7Le3q8BrV4uTZEuKoLwZDAIezp6eWiMjIQXUFVoXrMp7v+BRHU7+7kSfvl5cMNZfj+BelsqzVMj1NpaG/bRfg9cmOsk0qjrdEKQcVkSrrk2Cv8IiFU8/goAuYHK/R1Ye4h3If+sxycZHxerD5qXoh9aHBsGEauPEFhHJxKJ+oprsE8h6Uox3cYI10qFVUXazgjzPSQdVhBD/dOvWwC0o4nyp3q4KLK57E8g8fxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/25 10:31 AM, Roman Gushchin wrote:
> Btw, what's the right way to attach struct ops to a cgroup, if there is
> one? Add a cgroup_id field to the struct and use it in the .reg()

Adding a cgroup id/fd field to the struct bpf_oom_ops will be hard to attach the 
same bpf_oom_ops to multiple cgroups.

> callback? Or there is something better?

There is a link_create.target_fd in the "union bpf_attr". The 
cgroup_bpf_link_attach() is using it as cgroup fd. May be it can be used here 
also. This will limit it to link attach only. Meaning the 
SEC(".struct_ops.link") is supported but not the older SEC(".struct_ops"). I 
think this should be fine.


