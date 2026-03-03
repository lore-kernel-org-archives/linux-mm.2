Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2911BEA4E18
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 04:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0696B0005; Mon,  2 Mar 2026 23:01:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54DDA6B0088; Mon,  2 Mar 2026 23:01:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459F26B0089; Mon,  2 Mar 2026 23:01:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33C286B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 23:01:36 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B304A59813
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:01:35 +0000 (UTC)
X-FDA: 84503402550.17.ADB536C
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id DC572A0007
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:01:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RyIuvuDu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772510494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBGmF2s+SBlpG4pIc5F6jycqjWcB52xkmfpfhl7IPaY=;
	b=E15eky7YBMBRd9g+K9lz9yfJeB6bXkQFb/gk1/gjhs0olKXku4Twn7oz7ABqPdp58pwjcx
	6UncpEZu2IN9I690jV4F9tw8LcizwW8JfNdWMb1g2Jpw1lgGVVunsavlefuWjsIy0xH04e
	ZPQyLcYBLcN0q7aaFQtJDrvu56A2XqE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772510494; a=rsa-sha256;
	cv=none;
	b=BS0BBFCj4NNTLLIxA9R7nHDxfPoMkxUpKPtFWho9H544At5ALSN36VZT/OWkeBvU2a6mSq
	xdfPsItwxBNAlqDe7AmUewU/EXIQY184YJ1kgKFDxVS8uSfZoKluEjRBrsE8rP/Gq5Zb1M
	vay0r/EJ1lZNsjx6ojXByYlGdkCNYts=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RyIuvuDu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Mon, 2 Mar 2026 20:01:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772510491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hBGmF2s+SBlpG4pIc5F6jycqjWcB52xkmfpfhl7IPaY=;
	b=RyIuvuDuMThd4LbXF0ndsQw3dQna3mugcwnPflVjtV8ftPXbFGG/ezqLhplhFvmjA1yW3d
	Vbx9Xx1uEQe1PUFvClc1YAfep/On97EoSQifdLMkD7n2d1S0VoAQfDTVt42FoDG18QjGLD
	BcCzOPQP/oFzL8rhEN0Y04McZ7hFA4Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/3] cgroup: add lockless fast-path checks to
 cgroup_file_notify()
Message-ID: <aaZbz6FWxJ97kdNu@linux.dev>
References: <20260228142018.3178529-1-shakeel.butt@linux.dev>
 <20260228142018.3178529-3-shakeel.butt@linux.dev>
 <40c77bba-0862-4422-b23e-2a10cd01c728@huaweicloud.com>
 <aaW2feETIF7I65i1@linux.dev>
 <aaXB0A7eTbyZ4wA_@linux.dev>
 <372e0d67-ab3f-427f-970d-5d1c7cb68c92@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <372e0d67-ab3f-427f-970d-5d1c7cb68c92@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DC572A0007
X-Stat-Signature: syop9hj6uoenkxeywonpm7xwyqmfpui3
X-Rspam-User: 
X-HE-Tag: 1772510493-770073
X-HE-Meta: U2FsdGVkX1+9/nhYfdtz4wxEjTiW1UoXt4cqXnwLe+22j+grOLgDsFarQP6h3Oq4bGAgsvNeWbYylRklzqOhUKklzpZrilVH7qN6dfQ2owStVpt4JcW28x4hOuu2+8sg5API4rN237/e+A1MXhF+XdWdBfnj+CDRJ4FMl3hBmbbygChWWV3XLd0q63UEqxsd5Ism1WFUs3tvtTawcjyR9RiPeBu+HgITbVo0GwK3HkNtnUkx4vXoKB9+fhZbVOnEvGkeOpm83EVIfMxxsId+czLmZZsSlBwk2hIi4u6/QenubonJZDOhKVmIOq3TL1li5oZL38fchDK8mG0gXTzH7AAekhUqZtxQIdHddyYNfoLbEv4seFTW4CRv9Mfwj7IoNUfCCeegid1wvM83YnIeG/oV3mDrFNDWWy4qqWFVuJ6EK1f3XbEqXXTLUBBr8LTnuQGhhOjAmsDoxPrDftRadyzzFrck+DgujWf6wHwDeZtb3Jw74rW85qBLcmUb1OEmRMsMEk5nbvZWFJp9CT8ICodLypKLuwU87Dq6uG3Z8jW6Kz/OzYHfP9lH6tjbcfyFRwKbzyKxSALuvbxDqUOaIN3+5NwafhKJ2Ndk9C1qOEvNiseVx8hseh7zzF6RPbX2Mrj6g9eujXIH8nKqY0rTl8z3vxzYHRK7vqj/6J5tMLkIXslGgyP5HtuvZehT0L7XpwaV1UDVAGM4Ym784DwymVinS4xyxDT3NoPhOu9aSnV1LZyBXIJtSSsjivRvvIRKjouct3N6x1metXI+FtCJDHISTUclJEte8HRqXmEQL3fZco/SqfzX+RZJYNnQZvVjCQqNAGoUKj29Z1weIoUredPpXvIuU9WBNipp+X9/MuUPIMv5/Qns7DzssD7WjLIZsr/BSSwgemtnXAMJYROa4MCNmZA4a7oZ25wsAGrVT6Hb8LLis7dPxfwGdVc5RBXeZ6Soa5ksWfT90qn6IzF
 VBuRVy4P
 icZJXBZVnuyEdxLjhA937zraUxwCNWhJX3ipUAo+sidOsclpNzAPFTBBx5d2JZAP81U/0jpco7ULkH4lP9LJwR7WAI/mM4WFSJ0gnpx9ZswmhPlOFqwu5u/R0R+0X/UKGBDp1Gn8HHGP/EPuKPBGKN5K/jBxjE3PtqIDRJbJpUyF/uQAxZy5OrrxSoV35CIFENjdH9E009NafZ0j/bIbsBWEAHyyEbQtDDB/zV/mgFybvyIjjoWRh1ClTOdKYImEa28Kp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:18:17AM +0800, Chen Ridong wrote:
> 
> 
[...]
> > @@ -4689,6 +4689,12 @@ void cgroup_file_notify(struct cgroup_file *cfile)
> >  	unsigned long flags;
> >  	struct kernfs_node *kn = NULL;
> >  
> > +	if (!READ_ONCE(cfile->kn))
> > +		return;
> > +
> > +	if (timer_pending(&cfile->notify_timer))
> > +		return;
> > +
> 
> The added timer_pending() check seems problematic. According to the function's
> comment, callers must ensure serialization with other timer operations. Here
> we're checking timer_pending() locklessly, which means we might:
> 

That comment seems outdated. Check the commit 90c018942c2ba ("timer: Use
hlist_unhashed_lockless() in timer_pending()").

> 1. See an inconsistent state if another CPU is concurrently modifying the timer
> 

It will not see inconsistent state but it can see stale state which is totally
fine. At worst we will take the lock and recheck but we will never miss the
notifications.

> 2. Race with del_timer() or mod_timer() from other contexts
> 
> >  	spin_lock_irqsave(&cgroup_file_kn_lock, flags);
> >  	if (cfile->kn) {
> >  		unsigned long last = cfile->notified_at;
> 
> -- 
> Best regards,
> Ridong
> 

