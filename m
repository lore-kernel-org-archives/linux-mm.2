Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC92710FCAC0
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 18:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575D86B0088; Wed,  1 Apr 2026 14:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526E96B0089; Wed,  1 Apr 2026 14:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4157C6B008A; Wed,  1 Apr 2026 14:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE846B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:50:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D4321A01D2
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:50:27 +0000 (UTC)
X-FDA: 84610877694.26.67D10F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9E251140007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:50:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=czA3AYEf;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775069425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jj19y4++qUtDh4UsJVdE8XVNxu8TxpKvDRYluipqUXc=;
	b=8Q05NOvOQl9QCHuc8bBw3QpdzQPDGRifL06waRlBLWBYzqIX2xC16h71aiifk4B7pJ4p5T
	CoTvZpDRnwThbFOwZeV8hVZhFZxT3UnnExoYVCo/YlYq1YkKeA9Mj7l/YItlQCZarzOD/d
	5o0siQ570zhfuN6Jn4hHkNd+nmk2COg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=czA3AYEf;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775069425; a=rsa-sha256;
	cv=none;
	b=SrLk0kcurE480mWT8TCnsg47t/meLlWyBJ8vxw9WFEdI5SSzXNTmZz40LiyhoMdioze6tq
	JNTXVJRh0g+7luXRgVOhCX9MIeKL2E0ZfjzeT1spc90hsqHu3cguM0NZopMSpVRVHbLZPM
	aUxCKGhbmSn6gk7bzMIsav2AXkazyKk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62B6E44140;
	Wed,  1 Apr 2026 18:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9DCC4CEF7;
	Wed,  1 Apr 2026 18:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775069424;
	bh=yFr+6pN+gSthtYPUMkPOCzx9pN9VnMpe50u0D+mLClI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=czA3AYEfwyQu2qQtrMZzAfTt3fC4ZfeWDW/pgS2GYNMXZuj+8+RelkDDMQfreIG3N
	 9ucAmD4ylt+cctWrnbj2YXaMe24h1JJ9/k1ob1TAJyn4GspIJnwF6yLtYWwfWsHvTZ
	 KUEz8RWcUudc/Ik9LTx/JGQa9E3TCjoef5RK9RsDykN5UlOcWrFed4h6uc3bgiXHPu
	 CQ2nHuWGzvzBy8araAnLDYKiAJ9umbxE24yppx5qf4suOA6UftYEUueaT8l87AEPEP
	 nMYq+DpbccZVugR0RvUZy+IqxuAyrfQWT9IQMhxDF6GgZ1L5Xd2bZFX7baGn/eS8E/
	 kHegycPmozc/A==
Message-ID: <a34fd3a9-91ca-4ff5-8a45-151101022c6f@kernel.org>
Date: Wed, 1 Apr 2026 20:50:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable 1/1] mm: fix deferred split queue races during
 migration
To: Usama Arif <usama.arif@linux.dev>, Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, richard.weiyang@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kartikey406@gmail.com,
 syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20260401162855.146945-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260401162855.146945-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: tqjrpghdjagtnam8bos13pq5ejomjngh
X-Rspamd-Queue-Id: 9E251140007
X-Rspamd-Server: rspam09
X-HE-Tag: 1775069425-331808
X-HE-Meta: U2FsdGVkX189MCS6JZti4enn2pvqDFOhHZvcho8BSmYFgoax2URIG8M6UJzeHsjTW2lEnZumvm3sF1WX/4rEDRDw5Vjn75+iPEHhJGqhwvoFJ0aa5d4SAHyiSvJK+KannadbsScRh4LWjkv6MGZ0nOgyumEbjdChupNNW1X24sjjBFpu3c9wyUfwNVIKdd73vFuadMHpJHfa3pCL6DvOaGA/eEIygg5zsXS2697+sw/ra6K3G/iuFv8j6AubZ9/OWI1/+AuBzl0AKGTqXvttGAm3JA6Rv47gZ6tdr4XUx883LmOHS2bWCEJir4yFij3xXXtv+BpMmCfhW56oUNUbpUiG97fMW/0tDSlnJFzfPvHirxml5kyapDX5VA0o5q0CNc4j5i0MGk3XGxA7CTpdi/pJbqHrGOv7nZXbh9JNh0SXiaHqL4eN6jRkbME/f6OXiI0pYbaXIFn1TQUamww/A3NkNwFiXlqX9yICkE8qvI5OmqTN13hrnMeY/0siGsDKvxlmRLypWo1NO/sIW22jc2o0bHsth9JBw88HMyAVzZMmt3/pH+xgtagG3fJBCeHfj0obwBM0iLE+4SCnWPBnAallXjWd2RVUFtOlaZ4l5wFUhFsvgx0SatSBHcwSCEBvninoQJbOJmiSLl1avggppt6dIkgCpnaJak/p6tI4C6MMjI332qrKLFshB1cNRT2tLAb2OWm90FjVsrmieDvUOqaK+NnLPV/BQBqwLf/pB44XcuuPrC1xEuBHc+1UHgklEHhwcBLG+ERAj1rnLNZJN+9dWbKc7yxjb7yw857j/Qaieh/5aPmVybSaMvlsLILfzNb1YfqvA7ZCGU6ynQGIZPufEN987c0aTjM8ldbyfZ5xxpl0ddVaEAVKug7PlcdlKIk7CFOrV1RBVdcwqpzWWPPrBfzkcwINfTm7qs3Jv126KGHhB3O294G3wGjae4rshk/IfNKgnbHAnP6pTBZ
 UuGzITLS
 OQ2lRGnp0aRd/+GMXawRkO9RPYBnMFdmmcVieFWEDc8h1AaFWcwxnvlOSe24BAICJERhYvPDt/yFPZH35h4O/vgWT6XA0n2GkV7EImrluYaj/RbEgsnWewtfblt0XbWXmPDmaKdjwUJghw3SP/qKCI7ipAXbwBYcXABsFsNw/w0PCTI/lfOqvvAdBNumPW6CV0xCMfc1P2VN9bV7nI1ec/kgJhMFoxTGiYFlR2jXi45Y9n6Dd2YL502hZVllEwLN9YR86FNoAoPxhj31y2XKBae9vQkCZfnd+3VBrmYJoO6rao0Suf5uFkRVNIJKTSbBEIficqcgcYBxeNInpnXxJ1Y/gL394cHmyj3f30FUAMiqgMqZgtPBo/IoergD4YLNW55sL23odg0FX7VgaB3oyCi0No+JUrT7PrQDlFTpIH2jU1si0POOCmQNlzD/B6z3jJeox/Ocoaxuj41HBOX2W+sJ3jp6LVaD9Yp7u7k7LAoh2Zi+sDSJrCHYQCOndLYFt8JIGImHgOk0dQv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 18:28, Usama Arif wrote:
> On Wed,  1 Apr 2026 21:10:32 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> 
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> migrate_folio_move() records the deferred split queue state from src and
>> replays it on dst. Replaying it after remove_migration_ptes(src, dst, 0)
>> makes dst visible before it is requeued, so a concurrent rmap-removal path
>> can mark dst partially mapped and trip the WARN in deferred_split_folio().
>>
>> Move the requeue before remove_migration_ptes() so dst is back on the
>> deferred split queue before it becomes visible again.
>>
>> Because migration still holds dst locked at that point, teach
>> deferred_split_scan() to requeue a folio when folio_trylock() fails.
>> Otherwise a fully mapped underused folio can be dequeued by the shrinker
>> and silently lost from split_queue.
>>
>> Link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
>> Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
>> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
>> Closes: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
>> Cc: <stable@vger.kernel.org>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>
>> [ Backport note ]
>> This patch is a follow-up fix for 8a8ca142a488 ("mm: migrate: requeue
>> destination folio on deferred split queue"), which is currently only in
>> mm-stable, and should be backported together with it.
>>
>> Credit for this fix goes to David, thanks!
>>
>>  mm/huge_memory.c | 12 +++++++-----
>>  mm/migrate.c     | 18 +++++++++---------
>>  2 files changed, 16 insertions(+), 14 deletions(-)
>>
> 
> 
> Thanks for the fix! And sorry for introducing the bug in
> migrate_folio_move() :)
> 
> So I am happy with the migrate_folio_move() change, it makes sense.
> 
> The goto next if folio is locked in deferred_split_scan() was actually
> on purpose. The reasoning was that if the folio is locked, we consider
> it as in use by someone and therefore we shouldnt split it. Eventhough
> thp_underused() does a zero-filled check, the whole point of the shrinker
> was to split THPs that are "not in use", and in my mind, locked folio
> is a folio in use. So not sure about that change..
That is a questionable assessment. It's about checking whether folios
are *underused* not, if they are used, by whoever in the system (e.g.,
migration).

Just take a look when anonymous folios are actually locked :)

So the original locked handling here is just bogus.

-- 
Cheers,

David

