Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 394FFCAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 07:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736CC8E000A; Mon, 22 Sep 2025 03:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E76E8E0001; Mon, 22 Sep 2025 03:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD0E8E000A; Mon, 22 Sep 2025 03:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6DD8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:52:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E0EFF11A5DE
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 07:51:59 +0000 (UTC)
X-FDA: 83916117558.04.5580910
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 483E014000A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 07:51:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lttz7FnV;
	spf=pass (imf09.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758527518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDel7pcF11Oq6yCh9tIpX43vHF5ddtSDLUzVljmeUyU=;
	b=ga+nPyxLY1a+A9Y43Xvin1Gj2ANaHiyfNvdUSD4GpTFYRTTuPKN9+Z/rJcphDeHYPsyQx1
	tLIUyqpew5bPyjGlx1ioo+uvEGh3NzEexN8MIJYPszU1CntiZ4Li0SQ8Qyci5LeyU75VgZ
	7Cy20zhyqXZtO1gZKxec1ZCKwJm+8yI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lttz7FnV;
	spf=pass (imf09.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758527518; a=rsa-sha256;
	cv=none;
	b=GIljXpAE7wCWoG/zSyFQxqrVFITfeprJs/FbnXju1trp6VXeNhn0rDAgEvvpQmRnau3cRR
	PpHetUUnJZwcS+/fifJMUDfOkErZGI2y85xkCpS6ySSB4TiFDdb49u1FuyFUt7xb5C998D
	ljOFRlYu+18I8LOAu9QF5TU0jllOmGE=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7761578340dso4817003b3a.3
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 00:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758527516; x=1759132316; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UDel7pcF11Oq6yCh9tIpX43vHF5ddtSDLUzVljmeUyU=;
        b=lttz7FnVxk2wgmwBFn3IMVKRyi5u3c1tL0iOgYQ6TEZt4umzzcYCdzEIOhNRv9V9r+
         wOT7DrJh3HZL6zFD5JMBDJ6DqdlTfsCqaV3RQVyYGW5eblKEXDBHh/W7p2Um/Vz5uhDu
         lS2qs2tYLEEl4kZW5ZQfCA3p/0YwTpm5gcekyfcAprqDDzjbpyxoPVlXzlCSnijPNRqu
         8IFnLcBN5FmPagJ83M9gXhY6k7dQjPmTan0itRJhYe3tBFjLTWQNXkHUC3qaYRijLjxb
         qZ9Hz7506bJLrTrAFloqH0f8bcSn+rGSbTk8AT4bTcKt4AwalsLua7wZXO0PwvRjr+H5
         UoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758527516; x=1759132316;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UDel7pcF11Oq6yCh9tIpX43vHF5ddtSDLUzVljmeUyU=;
        b=wj7Jg85q3wtHCqMjC//gwcY7tua68+vOtJzbeRHSoqsDnVAAF8+cxXqytk2cWqSZW2
         bcJLMOHryCsFvuTrzeBJOS8YgTk9oTGPW/O+iM8DYxblmVODX4KTN5MeO5jCgZ7HsfGg
         lvyVJE1eKZSLLEa6Jq1mTzquLRSM1f82UTiNGCOxRCwcGVG0theFx42YvzjODnZTymC7
         IvrcpB+G7eTvOkxbjJDBe9GUAHVjEdCKBleNwsOiJzBnblZdb/HhILbdmCkV5uzDN4Cu
         iWUow+G6jfyhpn44Z2v+w8ViM+5k8MyweJ30Vz+mMvWYC8VKrq92dAHEGzUys3EW/fty
         GAfA==
X-Forwarded-Encrypted: i=1; AJvYcCXHUZVIeawY0HU8fO9PNbkAi1kwjCAO8vv1j/HCt0FNjINbg5O35Y6rXH17CdqLOdpcTcXlu+91Sw==@kvack.org
X-Gm-Message-State: AOJu0YzDInwgqnXyIX9EzoU/DujmN2RJXefZmuybeJObtAFybMtQaXJE
	zAg7E8nxra4ib8jaw2+lmFeRDk+tBDeQI/aHYVesNGSmuP0an4ZsA7V/w05lDGZ5M0M=
X-Gm-Gg: ASbGncuIpFOs8Mrm3dHQn9LMmNjQOivbKeWi+FQ09eo5gdcUXuslITyPMEt7qRDAjPf
	XdDjDeGmnG/uEk3qQkhEmkHbHN/g0lfcR2rgc0pQDqdoQ6pAxCT0tex92Wo2/3a2cIqPsRTYLD6
	MbE/CywNdRRSgyUdgKh7AZL8QajYiwa7G6TtKrVwaAkZZDxrUG1h3YJGavE2sP++JT99IxE0uWG
	ajRvlQjbnUsq6KubXM6RMk9FTN5dwQYxcsqSpf3UUFjFhlBgn95iIzBebdOx8Eds6Nr90kP8hbe
	XE805F55GA+J35qEV8X466O42i4gvoz3TyUJ77V2m23f7h+FEWXjrp0joSCRAIW6bMXZfjdaeqy
	1z6BBdN7GfsSuIamIgffqdg9ikQT5eJRTKnVh5ZSP2XEGR7nMvVk=
X-Google-Smtp-Source: AGHT+IFvNwMFCIWEKmfCSKTgy3OoaxHXYVww5vD36PPLuuFVpvLur2RM9yIrNxaf8MVuw+PgrnqE8Q==
X-Received: by 2002:a05:6a00:114e:b0:771:ead8:dcdb with SMTP id d2e1a72fcca58-77e4d31e124mr13772451b3a.8.1758527516015;
        Mon, 22 Sep 2025 00:51:56 -0700 (PDT)
Received: from [100.82.90.25] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f315029c0sm3020093b3a.47.2025.09.22.00.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 00:51:55 -0700 (PDT)
Message-ID: <7d76e5ce-22c7-4b9c-bb23-d0ccbe22b745@bytedance.com>
Date: Mon, 22 Sep 2025 15:51:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] reparent the THP split queue
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@redhat.com,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Harry Yoo <harry.yoo@oracle.com>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
 <svcphrpkfw66t6e4y5uso4zbt2qmgpplazeobnhikukopcz76l@ugqmwtplkbfj>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <svcphrpkfw66t6e4y5uso4zbt2qmgpplazeobnhikukopcz76l@ugqmwtplkbfj>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 483E014000A
X-Rspamd-Server: rspam05
X-Stat-Signature: 3skd79f4qn5ot1iek8ywnberbkjips3w
X-Rspam-User: 
X-HE-Tag: 1758527517-649138
X-HE-Meta: U2FsdGVkX1+YbB3MciBkJ7MyAOLeHmUes1dPVamejd1FvjbG6iXXq4Qj5stCPQgjKoFMclewXzp+DeZqtZfsLf+PiUMlFnvig8xEYKG/LNLBLZO8XP/ztPDnHGyrLXPwnTEHpRv6MNibiYcZVwsb8Pdtb2Wcuco7Nx18bfhr/5iQ0YF2DymEjJa4+i7BdDmdMgpilANsqEgujMydMzm2kfiP9b7gS6sjGdR8EDGNgipRTx4OFmCuAcEDJw+LNcigY027aXupPNgRuEaIBfcgMeKBVOvkw3BnM+V3h9voOv8ssDXo3tbyMs5PVDfQpi+lxtmFUcFDvrD1/038aP0bibQl373zFKM50p67x2NOefEn1tF40lZJTzgX3XxBjS3DQLJtuy1r1ZV0XvR1LF6W0KZRSm8ASOfZ+KEsbINUfeHbFJ/525cZSkMNe/GUynEw0B4bAUoV+bt0p/OxttSsPgFppTA1EKFoTioxOXv+yZiJ2EnH27U9A4OuYzu/mspjW2b9j9gTkXUrrFnnP7vT/jOqKzwaqOpaX0yePFwkgKo8pQU9YC74VMQ2aggUZmW/RD4q2+DylEX0GH7dVyvdQgywF34dcbV8Kt5he2lp6bzryLy3MUc7fZkp2uk/7/DCPSGVcGp5qZbOKiCBXz1W79TnfGVEG6nuKe6W4nRnYNcEXSRG5bci6wVTbBfnbeUb8WWOmTXP+BZM1AkLK9whVET+lMWqHjnmerBWZ8UbIE1mrpZdJ4oRuuURczPHoK34tCCXLJv8NiiWHN0TSYJgbb7poPvU1rJ5wGHJ9SWI6TFl+rJfN+PP8zUwI/ITV6ovaCtJOyvuuD7NSrRhCbrpkk5gkIXpbWCx+P9N34pFgN6NtcykXgtw31bLaoF2eua8sQaM6ezxeB+n//roL5VV57whLl8mjGFKqPCa1iK0prWQ/vg2RGwpq8XWNqrb62agI40QGOjzeFk1EZ/D7d9
 g1b7tlnz
 UaVAEu2/2Vd1pfQtW3xsiLL/lbULHu9Hg+dBWI8pY/8AcXd1mSybwjsk5wpiXNLIbWCw074ViP0XPB3eJV0Ff9lcDgZxvQMzqUpgaxtIifqvJ2ZSPiYDaJyIn+dNDx97aQy4jDkIDG8oCpDq1lBj9goz+94Qq0cZHx8y0VQwnGfMTsyq59dVC9hSjckygs4dzLZrJeIxuQmOYGQ2tzczcJcKFIHy/i/MyhhbPVT9C92xjryaBAcHjpy0vhoMcPCLrhxdHq6EhvRTAjhWB7RZqHJMS1MkB+9s0JB5YzuMUsYk2tIjBeDgcigdcRFJR1nWPBl5vlIvG7IPffwnOWWpPGbcPxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel,

On 9/20/25 5:33 AM, Shakeel Butt wrote:
> Hi Qi,
> 
> On Fri, Sep 19, 2025 at 11:46:31AM +0800, Qi Zheng wrote:
>> Hi all,
>>
>> In the future, we will reparent LRU folios during memcg offline to eliminate
>> dying memory cgroups,
> 
> Will you be driving this reparent LRU effort or will Muchun be driving
> it? I think it is really important work and I would really like to get
> this upstreamed sooner than later.

I will work with Muchun to drive it. And we are also discussing some
solutions for adapting MGLRU with Harry Yoo (private email).

Oh, I forgot to cc Harry in this series.

+cc Harry Yoo.

Thanks,
Qi

> 
> thanks,
> Shakeel


