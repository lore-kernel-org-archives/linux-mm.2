Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E01CCA490
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 22:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3946B0088; Fri, 16 Oct 2026 18:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A54F6B008A; Fri, 16 Oct 2026 18:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA736B008C; Fri, 16 Oct 2026 18:55:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A04A6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:55:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BEF68019F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:55:43 +0000 (UTC)
X-FDA: 85329998166.29.AAD22A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6D39C40005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:55:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drmmTrUJ;
	spf=pass (imf17.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792191341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+fjZAA8UGKYXICmEmHMmO2IajMcg2qwTMJzf+lYDvo=;
	b=E97AKGr4VRUBHI8k5VFr6IVjejgOgzcWgjuN4gxt1gnzMqPZealXfPL/yR8k2iWky8KTR6
	XZDSn9J+mrcuWxzlKZcyR2snxwcY40r7aNwfrx0LyIWKKFDJttWsZd7hv99NX2gs9E292e
	JydiN72E4X06xQbC733KOdGmfpYQqkw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792191341;
	b=gk/rLOYsAmmYDfBXX9MANCnEp/dUzNuIccXuQnx9vHv3Qfq4vKSYzt118Orgh9JoZmPOro
	yykWbkVxjqFx4w8KYUJ1juuQyJ4TTFVbKDeO7keOob9QROmCAPcT4Q3MoE9vHd1FaLViOY
	5qwlQOasgfN8S9P6JKrKT9i6oxL41RE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drmmTrUJ;
	spf=pass (imf17.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99BB541788;
	Fri, 16 Oct 2026 22:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D411F000C4;
	Fri, 16 Oct 2026 22:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792191340;
	bh=r+fjZAA8UGKYXICmEmHMmO2IajMcg2qwTMJzf+lYDvo=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=drmmTrUJ8iWi865TABSjtQJ9sJU0X1ucWOZmcbbFlVromL4oRSkfQnK+vqE2SGeHU
	 ANYRmOXzK0XCc74VOaBQOj0uYXzU2MWSShhuzhgDcUNw3lobZ15xl0SPVG7K5OhHVh
	 DOiS+M8n01gTzcOAo7DNt7Tm6P70gsnjwF/zdnPm1VMzTqcDBCneVdwYKPF6I7bZ/G
	 9QHUCYt41VoxCuQABUNzjja3lz9arKIVLgLNd6AimShaLvDw4Due7NWo+Xoy8niIjL
	 12McuF8dO36y2gwjxSja1Nt1AM8ih46v+w7JplqmyiGmb4HC89Q7YUukk8D51P6hWU
	 4YdShyNew+6Zg==
Date: Sat, 17 Oct 2026 00:54:33 +0200 (CEST)
From: Imre Kaloz <kaloz@kernel.org>
To: Harry Yoo <harry@kernel.org>
cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
    Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, Jann Horn <jannh@google.com>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
    "Jose A . Perez de Azpillaga" <azpijr@gmail.com>
Subject: Re: [PATCH v2] mm/slab: sample slab_state once in
 kmem_cache_destroy()
In-Reply-To: <atDCYwNfKW3m6YXh@thinkstation>
Message-ID: <ff8d44d0-d27f-2766-85e9-ce91b8e8e944@kernel.org>
References: <20261014150844.8536-1-kaloz@kernel.org> <d966f16a-a2be-48c7-b31a-a2c7d3ef6d5c@kernel.org> <atDCYwNfKW3m6YXh@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D39C40005
X-Rspamd-Server: rspam08
X-Stat-Signature: b1o7gy8a5u7hukhspgh98wexexkygx7d
X-HE-Tag: 1792191341-364547
X-HE-Meta: U2FsdGVkX18kHEAXQyDOEIDui3v37I6/gOl0eFK8AjDPgFTnGEkdJv40y5D4HkJrzr2TEQ4TKMn00JiAtRMn4EFlcoZIoiZ3ZyWzWaIHokNHYs/nHYjuma7XUIZMiXe3pfne/MnjtA+LLlNeZ3bE2UN88VFaM1+pt1zLrlprPfBJDpkDZ4mPSwscv9YmUfrh8K0IS9V4D4UEfMIlPOuCXzCZsdA/wyz+ufhkz642eAADgpcUxYAdBSN8i41gfh5ibem4V/0SX0ytf1tlK/eV6OLtCvubc6bJRYmYeuZgULii3Hz9qXD6QBKRkx6lsekBB+wqlGTS5C1PT5J5N930pVui8cRCVoQfrJqKBvAyWZUOpVOZIJDM5ZtWcBwU6iPOdP0JBALOyI9RVngFL+s5FjzXvhtljoOflh9HPuuQOTOvez7zO9JJhCsER/N5DkxV/yIEC1mw8hA1PNqizSveFAbCMsj2Gh5+31VMIfzXggWpfdSyloq+MbTcjtKySyd9daTMH00WicQn2bqWxw5PTZZsYtJ/WPE2M2uYqYRz3QplFRZIb5R/tChLjkd/fXV3fl7V66CK2IVUvaGSoPKrp0kPSo1rzG/3AkMgUrY/Ge6hjP7zblucqseaG4NufOPMhSIC+k+cHonXYBDQWr43IftOtBVoZIXuGugTS4HGGroghs+Yhw2iLziE7F3JYEzTDk0zsAyMO+myU/2FhJR3G/T2pjP2Bq0PqX1FK4v7V5mCRq6ChkgOG1ZgVcqUa1agtlHLfsDHVCAdYruuOig1IBEgAZmzCkjB3wAYUnkkwHTz2aqDuVH1mfwX/ujwNuf79Aje5Kcze9ClXoJ6N28T74m5fGSUWuS9zdV4gN2L95+ZtVyqpZCXXu90lVGkZxqrcm+mS8RjoTTfcQW5Mz+JmLtEU53SvyeHEQjr6fmTpHJc1lNrCW2s5dmnnRYYLUjtVdior9hdApScCLrIY0B
 29yrA3r1
 bcqVY3VwFCNjq4nR19DuZGhB9eAecgqQzZiXZJ4CWBX3XOUXUoVtwU9cRucqqXhcybZx+HxFkDE1h2I0MGiCMK3/XS8pZzooKOI9nGbDXWJ3TljYCIXWUBL953QEsx+UuHCfYi7tYcSmOgjV0wd86ESFjOjjQmrMD/4DNdNidzd3cr6t4yOwLapPwAZqVtyX29QaGy4wN04oTNcIlu9cwXrODeG+JF3pHjWkQO0AVFGrawSUGZpe9s2u6IZnegCBGjNxmYq5aLOM885CKtJBgudw+aUM/k2eJHtmDjVVbBa9i0f8iLQ5vDeBsqPilJELA/5B4wIijqGGxVow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On Thu, 15 Oct 2026, Harry Yoo wrote:

> On Thu, Oct 15, 2026 at 09:21:43AM +0200, Vlastimil Babka (SUSE) wrote:
>> On 10/14/26 17:08, Imre Kaloz wrote:
>>> kmem_cache_release() tests slab_state >= FULL after kmem_cache_destroy()
>>> has dropped slab_mutex and unlinked the cache, and for a
>>> SLAB_TYPESAFE_BY_RCU cache after rcu_barrier(). If slab_late_init() runs
>>> before that test it sets slab_state to FULL but skips the unlinked cache,
>>> which never got a sysfs entry, so sysfs_slab_release() calls kobject_put()
>>> on a kobject that was never initialized:
>>>
>>>   WARNING: lib/kobject.c:734 at kobject_put+0x64/0x2c0, CPU#1: kworker/u8:3/55
>>>   kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_put() is being called.
>>>   refcount_t: underflow; use-after-free.
>>>   kobject_put+0x64/0x2c0
>>>   sysfs_slab_release+0xc/0x20
>>>   kmem_cache_destroy+0x104/0x1e0
>>>   bioset_exit+0x13c/0x1e0
>>>   disk_release+0x54/0x140
>>>   put_disk+0x18/0x40
>>>   floppy_async_init+0xbec/0xd10
>>>
>>> The release-time test has run outside slab_mutex since at least v4.4 for
>>> SLAB_TYPESAFE_BY_RCU caches, and since v6.0 for the others. Since v6.12
>>> the unlink-time test in kmem_cache_destroy() is a separate read of its
>>> own, also after mutex_unlock(), so the two can disagree. Both tests ask
>>
>> It would be useful to mention the commits here along with the versions. Also
>> this suggests 3 commits but there's only 2 in Fixes.
>
> Agreed.
>
> At second look I think we should improve the changelog a bit....
> And the history of this race is really... messy.
>
> I'll just rewrite this part a little bit with specific commits and
> add Fixes: tags for each commit that introduced for re-introduced
> the commit, along with some history so that people* can decide whether
> they* should pick this up.
>
> *who may maintain downstream stable Linux kernels
>
>>> the unlink-time test in kmem_cache_destroy() is a separate read of its
>>> own, also after mutex_unlock(), so the two can disagree.
>
> This part is unnecessary because reading slab_state outside
> slab_mutex is what we should fix. As long as it's read under
> slab_mutex, reading it once or twice doesn't really matter.
>
> (See full changelog at the end of this email)
>
>> I would guess the 6.0 change is not a crucial one?
>
> Uh, I thought the Fixes: was 6.0 one, not 6.12 one :/
>
>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> Thanks!
>
> So... below is my suggestion. What do you think?

<snip>

Looks good to me, thanks for untangling all of that history.


Best,
Imre


