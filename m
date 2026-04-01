Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A5910F6FBF
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A7C6B0005; Wed,  1 Apr 2026 11:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB5A6B0088; Wed,  1 Apr 2026 11:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1C06B0089; Wed,  1 Apr 2026 11:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2A66B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:52:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BEF5416097D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:52:57 +0000 (UTC)
X-FDA: 84610430394.25.03EFC43
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1073318000E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:52:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="PabF1i/o"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775058776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xpk2KqHsKd8WkdQw/hVd0mcmOtkvgHESF7Hs9H3tAtg=;
	b=qe4NEDgzL4AIiCt3nenMxVw9OJNSSTjiutBmRPCQRAj5ZAZqI3OlfmGlvkwGSqg2gvmhdF
	6P/PmIsUAYdxWGlk3SVLiPJOL3J/yf0wX4vkFfT0l9WSEgez5qiejqP6t2nxboPzOMiHbD
	jvnhNTFB6ibOqXrUOtaNhetnwR/4P3Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="PabF1i/o";
	spf=none (imf06.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775058776; a=rsa-sha256;
	cv=none;
	b=KsxKuSvW0dEMu8QhcYpdm1Nu7QVetH6ffCwyk6TNDB+kHUbk88TPZQ4bTBQMPYCNS8klPP
	u82NNmJb1oDOuP3Q8Yh6RFz2CPIMOaP12STgMUsRsTJTZicBBdSsQ96dcVmMxvvsFiueS/
	Osnl827ikWeu7rLo4gZYlzXjqo2IzTg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Xpk2KqHsKd8WkdQw/hVd0mcmOtkvgHESF7Hs9H3tAtg=; b=PabF1i/o+ZJiHqJ+M/BVARG8ZC
	xJK+r/BlIFxBeexlys85rDUFrrTRjg8xRIcVMJSnTBw42KKu31nLD20u+E2JWBAH7AxLIoXOA11+M
	lZUbAv0zDsU3rFPCu6iDYDbLegbUdQS8k45f0LsNmUPiSd1SsbHl57cPp/k0lZiWdJLiuzkMln9hw
	IL9Plu9r3sL0uI/dGhEEdYwL6/5rP+0xLY0Sm3Bht9j1A8ycZ/Mx/78osTpZVUa4N3yrNWz1WBFoy
	MWNqeW/4XQdwD2n/IqmjWFHj1cD5HQEacj73cFeC0rtnH4C7n+/6Zdd70UVtq8GdhTvVIQpld/JhV
	e3Rmbd6w==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7xs9-0035ru-2w;
	Wed, 01 Apr 2026 15:52:48 +0000
Date: Wed, 1 Apr 2026 08:52:43 -0700
From: Breno Leitao <leitao@debian.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org, 
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <ac0_KvfNV4DDa0uj@gmail.com>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <20260401152343.3294686-1-usama.arif@linux.dev>
 <ac08dcv31J5_lAHs@gmail.com>
 <8ede5e20-9309-4d1a-8f12-13603fd92014@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ede5e20-9309-4d1a-8f12-13603fd92014@linux.dev>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: 1073318000E
X-Stat-Signature: cay4qi73ek6746oiwrx7c433uujiboo8
X-Rspamd-Server: rspam06
X-HE-Tag: 1775058775-259507
X-HE-Meta: U2FsdGVkX1+7iZ0TFypZ0uD9kJSqCfUbX6Kf6XJ1UBdzy+VUVbhIYso57knqDPb2i517BXvXi38ELb60UR9GdemHyqBagPaSCNzYhBbfRcZfxFtOIl+0Uv+vpeYDLoAPpFFZnFZplmAWflfPNrPX2rscaEkavRiBy8f7KU7ETsnlIDuyinwhoboQV+1uJv5nPwn7mXm3VBytnUl90IDHEZf4T43rO1u962MtDwLivHBN+J3l4doXb02pUvBd7ultK6T5TuafLQmLLAkQ/jpWN+kp9/G8RT15gbwzapOW7D/Q5Vgj80Jqho9g4BCRDHplmb7qYzmLk/fbJBwI79TTjPBqE+RfWbODQeSKaVZbEhFVaSyH5L3Nl/MxyzUwxM+Sx93sFjf3lcs6FYJ9r58WHjloQpxa64y8s7CEOIBJY8L9h63zyzvTr+6I+kbVEuqYmsc/0SMo4OenbannxsPP+j3qUmB6nGVCvdhj1GG3qT34uJxp+azuNqiedHAlPiprXzpDfjIZKTJ9mVJj75zwTyFI/cA3+yTbR9mXcp8vkWlv7ehPswik90HDnZidsCVWnt385GZsYUeICj7cBdc4tGVj2/M52dSijbfdPcZDDB8vPjykwbPQdcGC0g7zAqijjPf6jhTYWefHqiGPFaAVQH8+KLbC3zhmkXUEa0+oaCHgc/ISRaXMf+SyQJFfhjX8XGy8MqjHQAKi7KHM7TC1pr7zBoTc6aJ7htlQPZAeHWZasW0y8UZIbisB7MeM3taVacGRjnm3sgllJGxQ4OvxB5Ix3J/gvvR/EFOB7YZtqw7/MGB+k0OsG2fF4EV7/OnJg4sgzX09r5K7mpXyq0QNE3SdzEaawZna8rSk0TGDmRUek+X/8PIa2mWSJHdYY5+jaL6EAuzsQ6e7CIInzvybEVW30GsvvMW1Qq6GPycf/J9NR2S1wfb9bFoPK3E9G6CwRQan6iZBqnfpSMEcPjr
 oPrQ+isx
 Ipee3oa+Z9FmOLrqQtCcSsD6zMsa3t9fWtWStATotOVxLx1PuuiN2x7amkE5GzY2n0LIKws1R4qFHcgti3HWFHlh5pzWFFY8tzO0OlRRBYC1a8V+X+O1CcSUMgvTc/IkgryzRMjuu0+ec3AQqVBgU/JaXoGF+bEbQvDVMMfSfYbPMVUuzjq2vPngjXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 04:50:03PM +0100, Usama Arif wrote:
> >>
> >> This is awesome! Maybe this needs to be done to vmstat_shepherd() as well?
> >>
> >> vmstat_shepherd() still queues work with delay 0 on all CPUs that
> >> need_update() in its for_each_online_cpu() loop:
> >>
> >>       if (!delayed_work_pending(dw) && need_update(cpu))
> >>           queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
> >>
> >> So when the shepherd fires, it kicks all dormant CPUs' vmstat workers
> >> simultaneously.
> >>
> >> Under sustained memory pressure on a large system, I think the shepherd
> >> fires every sysctl_stat_interval and could re-trigger the same lock
> >> contention?
> > 
> > Good point - incorporating similar spreading logic in vmstat_shepherd()
> > would indeed address the simultaneous queueing issue you've described.
> > 
> > Should I include this in a v2 of this patch, or would you prefer it as
> > a separate follow-up patch?
> 
> I think it can be a separate follow-up patch, but no strong preference.

Thanks!

I will send a follow-up patch soon.
--breno

