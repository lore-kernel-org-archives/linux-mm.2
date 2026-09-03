Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66A59C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48FDE6B00B8; Thu,  3 Sep 2026 05:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4405F6B00BC; Thu,  3 Sep 2026 05:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309856B00BD; Thu,  3 Sep 2026 05:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F373F6B00B8
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:21:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CE0DC0481
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:21:03 +0000 (UTC)
X-FDA: 85171906806.07.14FB0E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id AD1D920007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:21:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mT78I1gF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788427261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R58VpJgoXa38uUjUSX0dFmlVfqjdjenKtXhLCcCh34E=;
	b=pkGeATiuS25fEXWd//sFUzNOpC191Ch6y1CqWmyrjtx6Bxl/QQaWuc16VAU3QVpdJ1Fepf
	JCoj3lxM9w17arGhGrmHL+N6t6+h3tvfdq1upBQdkG2qdTJYDrwVKKfp0R2Gn62XVerr0/
	Or365Ofzjji1z1q/IiS87zXNExOhTrw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788427261;
	b=J3ByCcR2kdJyrQMyYZcjEJ3pqc6XMiM83CNHbRlfrC9Squi+X4BgSdVIaTwBx/gWXG+X09
	2Bf8E840kmL2ZP+0b+NFi06xEaHQTG2MeQLi2bAifUe/548lFtPr4i46nV4+GqSrwFxtp5
	72DbegTCwqQjG0WQXGf7cMKOa7BzsB8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mT78I1gF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D4CE600D4;
	Thu,  3 Sep 2026 09:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F011F00A3A;
	Thu,  3 Sep 2026 09:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788427260;
	bh=R58VpJgoXa38uUjUSX0dFmlVfqjdjenKtXhLCcCh34E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mT78I1gFIY4l4WwOgJH7IieNz0sn6nIuBxmmWb3IyS/Mic/VyR47jeWT0UemhLBUa
	 lRbZdGhDE2zSzr7DaWqqQLtoGUQfdKckmB/8wBvY5rWRi4ed0Wn+HCJuTQl3uDx/zm
	 3a1con5c7Eb8RkywRL2qLIFxohlyLZvZpntWOzWcIqNDf4vHwtOXM3D7rblgOnvvja
	 sSme+E9Kv/MA4YfeqImXUQpOxNsfMxLKND+i49gTTDw1ieTM2cycEnWKeRlHUIOZfR
	 IMAH8aGv9LL60jzFAH81CjVa4mrqHve3323I9WwMeV4ItZ/ijS3UyCzDhc2bOIypsF
	 h2BdPR38VizVg==
Date: Thu, 3 Sep 2026 12:20:47 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, usama.arif@linux.dev,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, kas@kernel.org,
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	peterz@infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
Message-ID: <apk775HfHg_DXpiW@kernel.org>
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
 <5026dbec-0b71-4408-a78a-484a4b8e77dd@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5026dbec-0b71-4408-a78a-484a4b8e77dd@intel.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AD1D920007
X-Stat-Signature: 4ewomntikidxbytyx3t7otua1zwxosxx
X-Rspam-User: 
X-HE-Tag: 1788427261-518822
X-HE-Meta: U2FsdGVkX19/7vx0NKjO61pnIqVknu4zXPtO198hETSIercNlLKAWbFJZP3yBfEDDWAhvy0IRBlbNRFpzhUED2rk5LWMzUcwwgvHbWq4HaRsILiqBHXPcF1TpALiH38sF62B2+fFsLDiZAEzJIFBQrxI/bLI59OFEprxIRawA2JkUcj+qd83rE887NaNUDMsEjqxhY8yNhio7spwkAWXP/Su8pOSy9jYX22IrJu6ekvKhIVipHqTZBY8PCY/o3wF6tvMB204MjE97g0IBQUGO194IAGh1e8PAExeYW2u3MHcOA9pEWfY/Wsu7oAFiWs93lF71msRrSXe3A29ixfaQ35MpiFqTwrhVeK/S7hvmvijcSxjZdv/xgxgRLnUByyDNA8TBXvBV0zAWKk21bj5Ug7Ff86jpNv1pPyTl718dMcm8zLN/CSmXIfYZJygvs53+QR76QW4I/Xm7yl1HlPP8nD4Ljma4PwNrgf4DIGcw42c+NJBAaFLJtMZw+zA0eKGpATuP4SidJUJq0fmHaUyaCFnmll6IqwIDda0MFJPr7xm+ndrXGwtBZ4TQ8eCwKLp/zZghgnwd5cMiAClvysBGC1VMnPmh6ESSfCJZ0jHXwZjDH39rPsNvRtTBftkuNfawpL98i3rhuKIXjSDpMEDikheZKYMjiJAjxfyMm+iCrBmcdedTBFRxsvx1wKVrQizJUkjy7t9JA0wLhNIlTTezSabGcMC7ktMIC2TygZEPjuvzIUvZQtLc8AfsHdH7FWMfimOHRyEce+CrQTfbmcVLinL7YWklacsHEeys6oXRdgFQrb9TplPa0xhRdBKfRHcFYGaZ/9He7RQ0+DwkbIg1t2qWEj9p3F3nve2lEyBmiT1Z+xaMdy8FLu0kiC+04gu6j8J+yPU8L9KRJdvjqNbti6+DYXVGTnc52GdbIU9SuKmZAkJX6uAQtUHYfo9r5Cw//a/mJuQlS6znV0rkeM
 Uf96Xrka
 UFZFVetiDpU6HYZTuByo0fbDZ/IAqDZr1qia8D/5kAh9xbslqdwwbk2+qhV0lg2MRB4MEmRXSiXNSqRdiOrRBIFai+FyZ05IfK+0bi5cVS3vLBv3TasJaNJb9F/Fuo5JI+U6owtzoMpuUAJvSa5mqgfs+OQ5/OT0jeioiZWMVJOODQuSBgyzBfCLMQY5RTNQU1ZhBE2WcJ3B7sscFcpadrJ3H1EOE0xd52oakq0CkD03+VRx0OH3JqKR0SF5xnk0u51R/p8s1upHwUfjuLBkI9lzPI7kXZy9tF1R/qYc7LuIgzX113tnAFOjcTRK9vWs3y302y+Of9u9YNz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dave,

On Wed, Sep 02, 2026 at 01:59:15PM -0700, Dave Hansen wrote:
> On 9/1/26 08:18, Xueyuan Chen wrote:
> > +static inline int set_direct_map_ro(struct page *page, unsigned int nr)
> > +{
> > +	return 0;
> > +}
> 
> I still really think the stub here needs to return an error *or* the
> thing needs to just be void and tell folks that they can't know whether
> it worked or not.

All other stubs return 0 here when an arch does not support set_direct_map.
I'm for keeping them all consistent and fixing that technical debt as a
whole rather than creating a one-off here.

-- 
Sincerely yours,
Mike.

