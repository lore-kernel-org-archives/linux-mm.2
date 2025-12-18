Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4912D711CC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 23:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D986B0089; Thu, 18 Dec 2025 18:39:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200FE6B008A; Thu, 18 Dec 2025 18:39:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E6F6B008C; Thu, 18 Dec 2025 18:39:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F06D26B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:39:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90C1E140361
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:39:20 +0000 (UTC)
X-FDA: 84234210480.26.6B399E7
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf17.hostedemail.com (Postfix) with ESMTP id BB28C4000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:39:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X1oXmx3O;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766101158; a=rsa-sha256;
	cv=none;
	b=NZYHUjlUvDSQP2URQrp70gVHJfCGmnl1CZEXwwvT9Cf8uv4dZe7D1b5r9jpAuJeW5iDciE
	qERKj0Yf3eCgRXOq8j6+azAhc9r6l/kbQSZGkjA6yw88rs/xGPDcy2PXdcTFs7jStT7j5B
	msQDUDCjDVB9gKQcUskEr8mMfQ7Uai0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X1oXmx3O;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766101158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6CkT2RsOi/M5LFRuOsJlToUIGbnJ3gyuSS5jGiR0BU=;
	b=7//aB9UBZpCZfYEMcUpXc2a9viFtFjxqnx/I72Pec/54JNxQ1lmSCxJb8agXMjd/ZanL7M
	30qgz0TljIcO+97EX1VHXr8StMstlMo8u+Pdk3pjHqy4SxEIiqWnAFW/1RvJbqnmeS1+E1
	tSkP9J1iRfP1oYP4cZ0Zhym7c2pfm2U=
Date: Thu, 18 Dec 2025 15:39:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766101151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r6CkT2RsOi/M5LFRuOsJlToUIGbnJ3gyuSS5jGiR0BU=;
	b=X1oXmx3O15V+dVt0RbBo6pG1IMyg7ztn3Lv6fY3552mlFV2Qwan7UM9z149Md4RCfUnJUg
	9u4TdsdTByH/1nKtmbfNi5m4EvtF4/Om9a8TV8d+YTp/X+DN048WWFGmFPXEd9rSkoJU6/
	MpOBs9M2wjg9ZlbhDiIsCQv3vH1t5OE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 04/28] mm: vmscan: prepare for the refactoring the
 move_folios_to_lru()
Message-ID: <ujk7ths3jerzngbbm34xmzpv63osdk6pgnsvpl2q3qbxo4sbpd@a7pxeekhknbs>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <4a7ca63e3d872b7e4d117cf4e2696486772facb6.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a7ca63e3d872b7e4d117cf4e2696486772facb6.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BB28C4000B
X-Stat-Signature: kfk3go3mesxoy9w5di8nzh7enio4iddd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766101158-632467
X-HE-Meta: U2FsdGVkX1/bHgFDK79jGfmsDx96DvBNVvgEK2tunwyxKfTjaE1oW3betgFdMwRwZk5hGDKAKGybzGBTnagRb1fkePOw7kQwk5dfmOj96WyMgAw9vGhUXXailsDeT06yj7zyUd/UcLzVv+zlV2w5/m0Rce+O5tN4HQ8P9ASGYjJQYk23twc+A1vmzbzd1DLgRICVXDIOEA5XDMsEzSHVn++ZDkGQsd3plChyPIPEh+U99ES8z/c5Etw/+pJuZw8ykuoBOvxcHex7wI2fx29K/RZAemex4udQ0XGcsUGW+MsIhIICrhI1xCSY1RcCozWPO22jvVORdIIUySgwCkuHCEMdHXLw6AvsEBIbPgGuB7QB9kgXFKsFhJjpFMdbyV8cCu4L4KdGe7VUZXUj1Im0nsF84w/Dd/z36gm1dUPvqFgtSoWVqGzjeCRQXTFba8TPq/v2CcKYmj1iJK1bJzpxywZM5bts/4CRNKZ/q6GiulLs6m/C6qOVR4NLX3O8znnbWfT20WzckLMmRcNWgeIta27QMG5a4shhb+PHrN52Kf6XitXUOgyo8NuH7pyNRoE422U36kbpKDnZR92N/AZfkfYkJ0uTJXVeSUvs8hC2f4ydaumUMJZyK1DgzjhS0EyIGVJZbMP+gV5ACfqdRecObsRteKHu0z5+77bhvBm/vJKM4vyEk3wK1k63/AN5G7We/qwldKn3Q+EDFHwJWi3SmNK/1GtHJDWrlaMUfP8wUoVx8ds3a994APlZkfei0R9dIvPY+jjNKMRtgK2m1uQn3KKTmyyHfo6xm75X1pRpPpXVxnZ4rYaECnOv7UkAp90cKBFrFK2GudX1dkH1ohzIppc5Xhlh4eZQqKJG8YGjAvLSUOAW2y0s3GxjozIohlQWjRnEx8qJdSkbwXSX7bf5hM9zEhnzJkP+UqC0SZ8i/2oSDHRuFbydQyS5XnERgYdNSfRpu1SveknG06eyk77
 tJi7t1w5
 PiQnaeNJ0fWm9ttMJCyFOzmKfA7g/V2U3r6KqbXH5rgs5qgVW6eZEH0na5zKPZ9cD4IFU9+cJXuWtBJi0WCUDv03fPxmdU7us6fUZGbqJ+Xiojty3S4QjH2WyDhBonlDEK1+T2seJOT5p9qLY1vlzwJa0r9idkYZEwdq+Vv/6roFMQd7UpsJFvydKaWCrh98rEl1kcPkX0YqXrijrYt0fyEILOIjIWEp3Wco8abo7wk/F/9R0uGJJwTNBFPGfAwUsiqxOMYWDhxCBMlOtRG4d+m1U/B8fgcy0uQF1uZ6NEvu8nvGSQsBhrt+7lgbWyIFY5uyllyhhc5/Ot3CNqOZPejRcpI+fjVTMw0cRtYJ7fV/ULx0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:28PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> After refactoring the move_folios_to_lru(), its caller no longer needs to
> hold the lruvec lock, the disabling IRQ is only for __count_vm_events()
> and __mod_node_page_state().
> 
> On the PREEMPT_RT kernel, the local_irq_disable() cannot be used. To
> avoid using local_irq_disable() and reduce the critical section of
> disabling IRQ, make all callers of move_folios_to_lru() use IRQ-safed
> count_vm_events() and mod_node_page_state().
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

