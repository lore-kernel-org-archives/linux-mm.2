Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD451099B35
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA13F6B011D; Fri, 20 Mar 2026 15:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51EF6B0123; Fri, 20 Mar 2026 15:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67F26B0124; Fri, 20 Mar 2026 15:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A86296B011D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:07:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FD15C196A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:07:44 +0000 (UTC)
X-FDA: 84567375648.10.01F9004
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5D4732000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:07:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=prxrI6QV;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774033662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdU8PRNWZj5x+JmLzZ+T8IEck3EtXRtZnFNwzGdWh6s=;
	b=wRmYQvQt/ZRv+VzX7/M+ddQrbxMWaGn1dKSnW3DYucmytGcHmjWiywg8MSk30697Y4pS6U
	PpP86tQjmOxD/W/77CbpBOq2iMwL9P0vUNuBNkrd2E1DCLr2DRHbys34+FYbazmwlQ/LB0
	gquBbj5hOm53Ym5kv1bs+lj+WlqyPIY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=prxrI6QV;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774033662; a=rsa-sha256;
	cv=none;
	b=iho0S9yYMRBO7ak9i1Yf7O+D251QjgQI8hSvlBlq61UF//erJ/6XwQkzgwSgEzlAMGmuqG
	aGfryB84RMqJNZqlEHuEKROzvLMC+PHjhCdoLivjRfZmWOaQsT/4qYKBKtmgK116/wbXiC
	Yb0Jt3DBvCs+oyrJnFPJ+XmANxtKa2E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 624A842A09;
	Fri, 20 Mar 2026 19:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1646C4CEF7;
	Fri, 20 Mar 2026 19:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774033661;
	bh=Yooz8jcbCajwp3f1Eq2+lyBrRvTbOuBB2ZolCkflxFY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=prxrI6QVywyF1spuGDD1fJQ8UpkSkloRCG8PG+bFh7/OCLFk2DR6fkjw9InAJNok2
	 XV+/9tPD3BSFoeWBUTA+snAtdPgfjsmq64ieWksuYg4+9R4WOaX4htjw2Cb8vBLRTd
	 MofiTsF4Aj0PrpOCplcqt3UWHLKcw3UMsgvGBhElslSKXBuRuLpI2Lma/ZRQTH60ac
	 FMstYniWnoR+9vEuDR+d5PJRPhJyWGIn4W+PzrIwavmzXMw39R9SQ3/QScy1tYFtlt
	 9dHpTOradV2O9/9GsOk3vLHDRAlYS6iK5WSTEaQtmt3WlZ1PhwTMVJmM16wAkNXe0i
	 rGN72UassgTiw==
Message-ID: <6e58d40b-d0c2-46cc-9ab6-f3b1fe5ab40b@kernel.org>
Date: Fri, 20 Mar 2026 20:07:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/14] mm/sparse: move memory hotplug bits to
 sparse-vmemmap.c
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-15-david@kernel.org>
 <c880bda9-486c-41ab-b8f2-f0329392bbf6@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c880bda9-486c-41ab-b8f2-f0329392bbf6@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5D4732000C
X-Stat-Signature: 55e1acca6weyicgca9m3orn91gmh4mz9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774033662-147411
X-HE-Meta: U2FsdGVkX1/cWwnydzjpt0bUHjTi0hZZbivAVLg8pdRFAsUx6AA9L4EuLi2MoNBo1tzPF73J6gtBq53AUm9b9L/zbS8XC7u+UjeRCRl2Y2Ttt9sJYfZEKiBl2zjsWtzhUBPLG575+cenpaHtKC44maiGLI0Q8XOkeUKkheayl1Xh3v4CRZZM+g4w86Z8tKFpPXqu1zLMoJ9mFboto9sGcFJT/kdPaCDDpFbqNzXa3lNQM48DLmIM6l8Ke87YP0eUoXLiCYfyw5BAW0j/d6JrjM5XeLMyi0eN6i2nslcVDfs6rjdzXIUDAPPNvUzCpbKpc5nYu3KwTZQwPjwpx/rp6/Arje6bDRtd4KDd6Djfb+bQu1QZ5UWPyiTEdYdA6tO3wR4VjcyiYESjWT7RrS5D4Yc6P80wpaEEu3fXw3HoEkexKqP84F3tZj/bg2n3rqOQAgEqjxs8cin1cTN2HvJOZBasxXyaSt6Uy9s+Rii35FVWg1/YkRcVykm1CQ3+EEhuQRStJbMwEgvYeHHd2hVmPQPZ9fppgOOWaTOEa0Lv1Zui+Pou0udLXIqIL+Lu6rfLOKUN07vM1zFYzIaV5vAw6qL+RZw6mkWmFrPGDcXlYDduC2A2W8FPc5dH6adX2VsnVi3hhmEfirQdQ7gBPYVgz2NKhbvKyvgDUNNxqBfkXFckVvq0pWGkzqswhiAbRreoRpoAeySDrQ7EgrBwkljYqdCEWRgEiy7hIro0QJ3D0NoPtUJ5iXk9RG81OUgmiIAecrnpG6550N9HKteBUxEcyUUOTe73VbNHSAc+vEyxq3HSWx2QE2HTiWVqqkdcpXEnW3Bj5H8i4XjiSR7d+PT1pgcrkyKfWQs4+nxAky9Fa+YD2hu1i1x6fl8FK8gGKCgeTahq0+mBbwZ38LliO05HyApa6+fE4EotM9oVB4UkOGYzntL58fYapKvz+2XK+1tqCt++VVE8VqJ2Ko5Aufn
 2O/ZX3Bk
 gCrD0m0blRy/hLeZogba/qEa6Rleh7MPpx3Hf1spQuwMhgCHc/0NRmEXj0HwZ4bMGhG6DwO/XUk6ZR7QN5MTU/auyhcMF8c7w6KlLteapN92Stup8SiMqb/gesW/nyt4T50I+3ORIVregpvBqKp+yexRJZeTLFX8Fkyf6Sf/5fY5fhAWlDos0p7UnauKDGD3jy0g0aMJualKgMPFvB8UBM3Pd3iPzw9PSyVBndfAONDftRi86aOwbnMS937RrtCJJFOQHwhGLpbg7D0WNVYLZRJcMEj9yewcua+Lb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 21:09, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 17, 2026 at 05:56:52PM +0100, David Hildenbrand (Arm) wrote:
>> Let's move all memory hoptplug related code to sparse-vmemmap.c.
>>
>> We only have to expose sparse_index_init(). While at it, drop the
>> definition of sparse_index_init() for !CONFIG_SPARSEMEM, which is unused,
>> and place the declaration in internal.h.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Looking through this it looks like it is just a code move modulo the other bits
> you metion, overall very nice cleanup, so let me hotplug my:

:)

> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> 
> Into this review!
> 
> OK I've actually cringed terribly at the puns here and maybe I'm cured for life
> from doing that again ;)

Never say never ;)

Thanks!

-- 
Cheers,

David

