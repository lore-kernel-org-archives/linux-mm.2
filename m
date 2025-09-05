Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14B04CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 21:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8678E0011; Fri,  5 Sep 2025 17:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658BC8E0001; Fri,  5 Sep 2025 17:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595D78E0011; Fri,  5 Sep 2025 17:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 444588E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:35:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D40B416035F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:35:10 +0000 (UTC)
X-FDA: 83856502380.21.1458F0F
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1F60340006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:35:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UiHjw1EN;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757108109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrQKavBU+8BmecuzRiyEZQztOguoe+vmV+LZaMwWF5I=;
	b=p+G7Hcl0MYNQzgVdkDhRhj1AV+a0yKpFtM9XOyRqiYqxJNiieaBYFolAye3j2SlPijJ/9c
	vfvSZa0TGRPmz1zY4Tjtm7JwUgEYTlo/v6wolKOzv48vXWi70zWaaWP6gg5WVrRgp2ed0L
	sVhS5TujCDAMTahSJ+h+ZtQyTO9qY5Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UiHjw1EN;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757108109; a=rsa-sha256;
	cv=none;
	b=lY/ZVBtObZ7XsWR14JV7H2e0G7zmabNfp9uw3fxUjOGzD4CM7LQTuc5C890/VEM9pFwywH
	hmUERWFGs7H9+NXGEt+7dpOZLOYebHTm8sOTbunVil29An4W1AZLCVyFXEB6pD5KpgBrGq
	KvFqrA+Dz+ZoILWTDYXnpu75Rdn6+Ps=
Date: Fri, 5 Sep 2025 14:35:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757108107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jrQKavBU+8BmecuzRiyEZQztOguoe+vmV+LZaMwWF5I=;
	b=UiHjw1EN6zSseiXPwP5jOU+PMDzIc5lDRuJklr0LtbxbOnKRv0OBc74hK64Q7ZYoIvXBaO
	Wq623BrT+QGhpDBcPFFbmUD1vf/VtKJXe0/D/S08x24NNwQ8Rcs0a9N0q+UI1Z5a+LddBJ
	+imMdsHZoN3p2RWEu0H8/Rrt9ZN4kkQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Peilin Ye <yepeilin@google.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Message-ID: <uattgslnbiit2yhz5hzh6g7mc4g4nnbkqospnjuqikzliskyo4@z5i66op4jhdp>
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
 <87y0qsa95d.fsf@linux.dev>
 <aLtVTo-Egnqdjxi2@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLtVTo-Egnqdjxi2@slm.duckdns.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1edrznbcrib4dw3tkabswcfrufrsmo6e
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F60340006
X-Rspamd-Server: rspam05
X-HE-Tag: 1757108108-748670
X-HE-Meta: U2FsdGVkX182CQvNDrzaaoBJ+OiAdJP96fLxIy5ER8yJ8WcejFVEllK9FdBa5HqivOhnX8emqmb/5zw590TNlwRRekmpSKLnIJMyTZrRd6SKPc0kP8NsuOMORDIy3Rt7Z04aWlOAtZNsSyg2GPDjEefPq81xlYqxdpQSJbgIDI/mAexyx9h71GRYcwRXXn4ORvYgHeeivROxBfqwlWLhpUYwEOuMopC0kvl8nl3gYa97bi3bSYRvuOnqWSjBZlQbIpNshU5QX/N7p0XjLkfTo6Gf952v38LX0s8vIsmYyAsobv7Z+o/HzAXf8tvni9eV32EOrH6UUyckk+lfZRZIOoLiY7fi2Y/PCu+CV8l/tzX063whFw4TG8fPNkIV+nQdwOPBZNfKwx3yhlcRDim8Ztcb6WY0u8y1jayE5cqDTkljapEC9NKoeWeCAvwmDZcFGGU9crK/IdRCTOSBLlOQ3Gg1Jk6gXGuEK8pMYGYbhZTM5fuVHZMfHweKIn6IoEpXabPWC6SMz+6fY58yTOMMxsEVO/f1la2ez/YXpTSkYQtWpbnXh7xH4n8ZDcfQmwh2RCB5TRrnA+IGtd1saCte6ytgrUUmm8w6SLmBao4vu1W9UjJlB+LSnrm1R1kJdF1l+C/cqS+YrXxUQLkr9OYuTSLvFR1PkrTqH+D8FO9orZOwLTFwTV07W2XwMjUv4Dc2hHi1qVr0UOmam+R5WoieWNdSUxOQDEYncEOow992VUXSki1JPD862EVjM+zaXbIkfzbKK3OtF7MKUR4p/iYskkzFyXwSDCuQ7D1aP89P/KtONeiopZ0+khdkSkfGWMGtfChcmu2lasFTOZlG/iFFCSHITbcv5ak6fMCDvB1pDjuC733Gxqdhy/xE5FMyUj4uSgZ6UuZ58xJd3CvwUqVVKLY9U/fLnCVsMj1lAVKRZrc1FCVQrxmG6XbdUCBfesnnHHfLhdj6J32iSodrkpg
 Qn9NcC1d
 hiF6EtXBlOXb4I0N7Tx7+AYXO3G9oi/zwNOM6wH1X1Xv8+Tl+YQZxaPDVYCMpnwzMZ+8YaRNx1TLxjauSgOTD0mzmzyfRn0/QcIn5TX3Em+bOTwyFKLsjYj1bIHyr8htIhN1PLlSA6Vo127I8qnn1J/B8RkXb5LQFKnCwFlOpRuHWbYDzKSVftf/s/YtzzGnNKWVI3Lf8Hws0GIJVEYxBKVCXQqsOf1UYw3KvoWgJypOC7SPTXBT8MkGXEunt8czI2ou8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 11:25:34AM -1000, Tejun Heo wrote:
> On Fri, Sep 05, 2025 at 02:20:46PM -0700, Roman Gushchin wrote:
> > Shakeel Butt <shakeel.butt@linux.dev> writes:
> > 
> > > Generally memcg charging is allowed from all the contexts including NMI
> > > where even spinning on spinlock can cause locking issues. However one
> > > call chain was missed during the addition of memcg charging from any
> > > context support. That is try_charge_memcg() -> memcg_memory_event() ->
> > > cgroup_file_notify().
> > >
> > > The possible function call tree under cgroup_file_notify() can acquire
> > > many different spin locks in spinning mode. Some of them are
> > > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> > > just skip cgroup_file_notify() from memcg charging if the context does
> > > not allow spinning.
> > 
> > Hmm, what about OOM events? Losing something like MEMCG_LOW doesn't look
> > like a bit deal, but OOM events can be way more important.
> > 
> > Should we instead preserve the event (e.g. as a pending_event_mask) and
> > raise it on the next occasion / from a different context?
> 
> Maybe punt with an irq_work?

Oh good suggestion, I will check irq_work as well. Though I think that
can be a followup work.

