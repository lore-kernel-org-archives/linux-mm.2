Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5680610A62FF
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99F526B00BA; Thu, 26 Mar 2026 22:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976F06B00BC; Thu, 26 Mar 2026 22:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D316B00C0; Thu, 26 Mar 2026 22:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 751206B00BA
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:43:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D663C477C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:43:10 +0000 (UTC)
X-FDA: 84590296140.09.A03BC45
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf01.hostedemail.com (Postfix) with ESMTP id 01BBD40007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:43:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ptL4Ik+K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774579387; a=rsa-sha256;
	cv=none;
	b=nVZpZVLgiurFrrblMJQcx7e7eJRPGgPqS0ycqWLx75TQP41L8D22E52kXqMvTG7hnWxDgE
	UtXNyyKSIprYrqWrukOdF8gGwUIDZ5nPQ2VSokc7Yud7wGpdAvAjeXWDugAcyZfleb/9VF
	E4WlKYMxn7U/pOYRacsrUdUQ8MIqm8s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ptL4Ik+K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774579387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xjJ66u8oHnnbIM3Y1792Vd9Y/++lXVLGo/e8j2zXnT4=;
	b=AscTM473uEYBnMcisZZaxM+B+XKbNO1ckbul1lMCmuFhWyzuQlLrslaqvB1YTPuFG3NLyy
	qsCC23M+W3a9JbTrJKiCnAKDGEoeCBtwR9XVZSTW0Yo9SOVahVN93HyBxZRm9/ZBcjFyZ7
	pxabSFE2DjUvffrzlshOdbk57zzNGsk=
Message-ID: <0cf08b3f-6fed-41c4-8728-c925e8a55f29@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774579385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjJ66u8oHnnbIM3Y1792Vd9Y/++lXVLGo/e8j2zXnT4=;
	b=ptL4Ik+KebH+WA8Qn4tD0wdWMGwkND0pb/0QxMeIqWlT2PSB1stK0uZgtU6z7Csslty0So
	nRvvBoUHwHXC7dpz0xfswuAABFuPzIHbTjeSS5xXcly4P2pd6jQSwzF2CR1K4O+5DKs7Oh
	iX+A7SzREiXy/PPsoFm2qqBCWtKg4+U=
Date: Fri, 27 Mar 2026 10:42:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 4/4] mm: memcontrol: fix unexpected massive positive
 number in memcg_state_val_in_pages()
To: Andrew Morton <akpm@linux-foundation.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Harry Yoo (Oracle)" <harry@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <e19052a28a7b604c012bfdfc900fd09543976284.1774447069.git.zhengqi.arch@bytedance.com>
 <54c2b09c-84f8-4118-96a6-acc13ca2f245@lucifer.local>
 <b6462703-9744-409e-a770-b9a7ca5fa198@linux.dev>
 <9ee51ac2-c87c-44f6-b983-44ac9007cb35@lucifer.local>
 <20260326170622.8fa7ca34d1425c241525bd41@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260326170622.8fa7ca34d1425c241525bd41@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sptshtcaz5w9jya4kys74gp63a6i5rgw
X-Rspamd-Queue-Id: 01BBD40007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774579386-138328
X-HE-Meta: U2FsdGVkX180LTITXZ+tnPnV2w5yXc6Vchvu4isixocwuAV0xmKaAA501nrs5uO1RusdnfOXYNPV5NkZPZFLoycnfJI/S5BsiBF3Q0HdtTJRdrWrB0IMI1rJUyJFH7QAe2p/ByH0lx07NJVNB6kSmtFbagToU+uAuat7FR2wSvavUcM76gY68xn+OALiM1QrSt3/tV7FW5eg7OKAE6lTrz2Sy6ESvHrMajuxVT4xC1SWylKk3Ty2eCqSBAHYoT74aEK9Hbpsl+XPlo/4iEEQVaGla5yKFNiQVHkYqyXDez/NpL8j6NmmVCwfreQQDbfzn6m8drLkVJpDE28yDIYrTC6ZxkJ7ZOK4xN/V7RMQeK5VhEi45PHGIvfkFbvP358e+5lh8ENl1SFOU3Oyf6WCg7/nRqHq8XHOm/WQT0ven0VaAYDSJpPi2Ad0ba+8VUvBGQqySw95zOnRCK/xE9twFKVv0gW1SHN3HVDJ+87fOfNRiukmeyJBYvby2KZvIGKdgnf92/HXh2NnfOQMkIcKKS7AD9mvgU6sBLLY60E7vztRoVe7SuINd8x/FB/sVxemZ7+ERnYuS5/KJRcmM/jO4n/NFHaqd+MAoN96FSdHj9U6As4jJ9YtLKNOXFMDInJdIMGmlknrF2bmgdOTQkYO5pMqtJLPpsa3CLBWBbO5maqyB6QQVUmqlR4F7r8Ov5KKEQX6y1ezv8fwSAs+tWzJ2nQX7Lpxc6rCTLTKs4xhplAG5k1x4hF8Hn4/OfaBsGFPTzEVIFlkDstp4h00t+7TSFVpi5YENjRKyI7ko69sjPlAEAK6qXKniRuR6rX6W4Os5RTNq8xdr35nNHMiWNKS/k+gkWqCY8pMyjlRHjYaq8uAVlJDPDWzmdas8Oi/JJjWMWW1ECcv+EFXxUahVgmr+5haRmz1VyNrioAr4C3LaBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/27/26 8:06 AM, Andrew Morton wrote:
> On Thu, 26 Mar 2026 09:38:02 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> 
>>>
>>> If Andrew needs me to merge this patchset into "[PATCH v6 00/33] Eliminate
>>> Dying Memory Cgroup" [1], then I will develop and send v7.
>>>
>>> [1].
>>> https://lore.kernel.org/all/cover.1772711148.git.zhengqi.arch@bytedance.com/
>>
>> Oh that's your series too :)
>>
>> That would be ideal unless that's already in mm-stable, as the series ordering
>> will give us strict ordering on patches.
>>
>> Anyway let's wait for Andrew on that!
> 
> <trying to catch up here>
> 
> Gee, I'd rather not churn that 33 patch series.  Could of course do so

Agree.

> in the normal fashion, if that's considered particularly desirable.
> 
> As I understand it, Qi will be preparing a v3 and I should stage that
> ahead of "Eliminate ..." to avoid a bisection hole?
> 
> If so, that works.
> 
> <checks>
> 
> Well dang, this series ("fix unexpected type conversions and potential
> overflows") is at least textually dependent on "Eliminate ...".
> 
> Options:
> 
> a) Redo this "fix unexpected ..." series on top of "Eliminate ..."
>     and tolerate the bisection hole (easiest).

 From my personal perspective, I prefer this approach. The issues fixed
by this patchset aren't too critical; it's just that the counter might
overflow (and only with CONFIG_MEMCG_V1). If it can be included in
v7.1-rcX along with "Eliminate ...", I think it's acceptable.

Thanks,
Qi

> 
>     Am I correct in believing that the concern here is a runtime
>     bisection hole?  And that the bug is pretty unlikely to hit even if
>     our unlucky bisector happens to hit that hole?  If so, we can live
>     with that, surely.  Every darn hotfix we do creates a runtime
>     bisecton hole!
> 
> b) Redo this series on top of mm-stable or mainline or whatever then
>     I stage this series ahead of "Eliminate ..." and fix up the merge
>     issues (probably OK)
> 
> c) Qi redoes everything as a single series.  That's OK.
> 
> If we choose c) then please lmk and I'll drop both series to give Qi a
> clean run at mm-unstable.
> 


