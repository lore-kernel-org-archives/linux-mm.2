Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9556AFF885A
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 02:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F42206B00A2; Tue, 28 Apr 2026 22:48:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECBBB6B00A3; Tue, 28 Apr 2026 22:48:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA486B00A4; Tue, 28 Apr 2026 22:48:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C82796B00A2
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:48:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 66838140671
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:48:45 +0000 (UTC)
X-FDA: 84710060610.21.E3729F0
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf15.hostedemail.com (Postfix) with ESMTP id A2748A0003
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:48:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aoBRpeHb;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777430923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uiMWZCTeAOPUrZJ5+1IQsZdUyxFEVinUAq4pUHwGoUs=;
	b=RVelDtpHseZG17q8moF/LlAe0jmdJpP0wFuRFr/tNmPRNDD/Ys8HMSING7vyZTkYdxgKyF
	2bklAJtnoRXbNPZrF3/9U+AzX3qIFj7EZ86fUgbSM1wrzTnDwfbpiPH24qvzs2NB6OBbFa
	9kse3z5k7J0Rw6qxeElUOkLgmxQMPNs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aoBRpeHb;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777430923; a=rsa-sha256;
	cv=none;
	b=p5ksAhV7bMmO657zswtL7s+T2S/QklLWcV5YCdnQtyZYEDxrbXQKRwBJrrQ+HiUELekTGM
	7qQPMfubmhMlioN5FuNPSyxnsfhZBqkhNMeropkMGcBJMfYkOBq8pP58L5ktaf2FXuu554
	mM5FsrJl88KX7cbBgyKORSCOu/okPGk=
Message-ID: <ea4b2fcc-25e4-42ae-9d3e-5fe7d86ed7fa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777430921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uiMWZCTeAOPUrZJ5+1IQsZdUyxFEVinUAq4pUHwGoUs=;
	b=aoBRpeHboqK1C9r6RmublLyhyIrTONH3Jiry0/y/FTwvTxj5hf7xvfUTNAlqHqnsU2+cKh
	oEF5/o4rq6PRlBk42L0TBnNpeYXqcHBHAmYC/beOU1JzMYX297j77/H7GdIjSK07FuXu77
	BU1LR6tTSDRk5Np61JNZ5LTYN77/Ryw=
Date: Wed, 29 Apr 2026 10:48:34 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: memcontrol: fix rcu unbalance in
 get_non_dying_memcg_end()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, yosry@kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <20260428103108.45719-1-qi.zheng@linux.dev>
 <20260428151253.bdfb08401ebb74c438df0e52@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260428151253.bdfb08401ebb74c438df0e52@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: A2748A0003
X-Rspamd-Server: rspam06
X-Stat-Signature: 8u4sgtjnfc8ier4y7w1u5ddyct6p7w1j
X-HE-Tag: 1777430923-79506
X-HE-Meta: U2FsdGVkX1+1aw41qNi7jOM25UtYbvexUCqCsH14VNeuxvFyZbtsokB5nZiuK5p2xX0LFUtkTtX/TfEnPpnlQOx9+M51Xa8TFRHarSp6TX4N8MYcUPmp7KnVNm5857DcFpPC83HhFB3vIp2WL6PewqXgL3GnOBgtcCMV9OD/NgWpXfk/dtx3n75nQmgYEkxIyPavbxvIy0k8ytEhPTYhZQizpzOtwnZLfi7U8alx08p3YGqPHg7gDUVMyeshQNLxSwHuJby4BrT+nbz9JFkh4SFLlj4w3b/si6NbzRXzj7NZhWwIvxRMTlMctx098A+fbhemuR7XE/6XjFy4xLeqiJbRQxkIq51DWntQyJmy2stb24shlvuBXK4h5ZfEPEa7gqrYyQbRp1kh8x1TrJ8bWZlSwqCDaLD7D16mnRPPECyvrmR2fVYfFU0GRjyVlAz8+4HNodpftl7M6GOH18mfi4IXZY4Bx77lA0kVHYlNTQyZLMdb5vyC2XD54n7dUxt3mAo+KsEdebJPCIRzTC4ePnxUt4y2jkBhtIq7qPKPuOzex0HkQtKc9EcgjC7X2aIGOL3lpUZLgCXXNA21ZgLq5+bVSvlc5iCraJQCB6oSwA9ZP5w/nGaNW0S8RVnTBMl5aYASlRahLbR/pdgx6gnAHEO06ImoKvTxn3XSdUAJo2ECzj5T38egKQp0L/XLHyr4mNDIballONbyFaSo3GJyPIn36+9rY+A0kN1wklCZnX5iLBBXVb9vNQogm4RWdzpdXSVmfScQJPjZ3UlGHLkLErx1XXeoF5+KE57ICCspG4OrB+BEE2yEAn+EAwjdJYWJ6UiikfsveoRTc9eZmyo25kaB+TRdHs0HtFLsDaVbj615ncrLqhOmfd79uPowyJ9BJXwymRRrFpDMpcj5QWjxzG7hkKekKsKcth3oHhPA3B328TShTv8AJe7Jb2l+MU2siR0b7CA+1jpD9/BkeVD
 xJXb3sEH
 qCldcm7t7kqneCrIq2hXpnPXET3/wftKzZ5nUwGJvrZ0x56o013FSKMtwu4lvKvQho/msI4ZzlJ8XPoBOEwbmZKQT0iaFEMYcBJLnByywo+L8PRdjLdTOnVJP2ts0d8BcXSYuiy2gA0lkHBIlL8XmD3R7bZS/c+7KlTxE51z09lZWYgEou8E3m9pOUO6H9InFtYC5SxdobmKQUeoOMwRvYwwR8Ts28XzdWlBtRAINjpjJSW0kRya7EcHH2vjLPnePxEQ8pwOpnNDozVPCnw/DebUsWJ1tWwGJxJa91+l1geSWOP1vzOuTNynVn8e/71WN6Td7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 6:12 AM, Andrew Morton wrote:
> On Tue, 28 Apr 2026 18:31:08 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> Currently, get_non_dying_memcg_start() and get_non_dying_memcg_end() both
>> evaluate cgroup_subsys_on_dfl(memory_cgrp_subsys) independently to
>> determine whether to acquire or release the RCU read lock.
> 
> Sashiko review
> (https://sashiko.dev/#/patchset/20260428103108.45719-1-qi.zheng@linux.dev)
> is correct.
> 
> mm/memcontrol.c: In function 'mod_memcg_state':
> mm/memcontrol.c:881:9: error: 'rcu_locked' is used uninitialized [-Werror=uninitialized]
>    881 |         get_non_dying_memcg_end(rcu_locked);
>        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> mm/memcontrol.c:874:14: note: 'rcu_locked' was declared here
>    874 |         bool rcu_locked;
>        |              ^~~~~~~~~~
> In function 'mod_memcg_lruvec_state',
>      inlined from 'mod_lruvec_state' at mm/memcontrol.c:973:3:
> mm/memcontrol.c:952:9: error: 'rcu_locked' is used uninitialized [-Werror=uninitialized]
>    952 |         get_non_dying_memcg_end(rcu_locked);
>        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> mm/memcontrol.c:944:14: note: 'rcu_locked' was declared here
>    944 |         bool rcu_locked;
>        |              ^~~~~~~~~~
> In function 'mod_memcg_state',
>      inlined from 'mem_cgroup_sk_uncharge' at mm/memcontrol.c:5392:2:
> mm/memcontrol.c:881:9: error: 'rcu_locked' is used uninitialized [-Werror=uninitialized]
>    881 |         get_non_dying_memcg_end(rcu_locked);
>        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> mm/memcontrol.c:874:14: note: 'rcu_locked' was declared here
>    874 |         bool rcu_locked;
>        |              ^~~~~~~~~~

In v1, I explicitly set rcu_locked in get_non_dying_memcg_start() to
avoid the uninitialized warning. However, I noticed that even if I drop
it, the warning doesn't actually trigger -- probably due to some GCC
optimiztions.

Anyway, let's explicitly initialize rcu_locked in both
mod_memcg_state() and mod_memcg_lruvec_state(). Will do it in v3.

Thanks!



