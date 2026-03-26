Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 760EA10A88FB
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9D056B0088; Thu, 26 Mar 2026 14:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E776B0089; Thu, 26 Mar 2026 14:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C642E6B008A; Thu, 26 Mar 2026 14:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4EB26B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:04:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E3F413C3E7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:04:40 +0000 (UTC)
X-FDA: 84588989520.20.D882681
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7AE64C0003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:04:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="t1v9tK/9";
	spf=pass (imf22.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774548278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQ89K3+y398sEmLbnjakuqThw5BZANxnbksEnP28xmg=;
	b=vbMRaVQpAA9zzqVv7CFzbq1/h7ThpY5kD1aHGuzI7rZSx6pUSIBJ9RndyqCsFicVnqQ84G
	hHiLYMLlVXUKjRZlrj3Tk2NOIt/sZz+s7qglv4xEKm0/I4+1qfoA76F8XfIp8usomD0Wti
	2cH9hSB8CvwzSUYKo2GPGkg5VwZ8/oc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774548278; a=rsa-sha256;
	cv=none;
	b=FjvdHcgCo3dVH9FlkHww7foylq4Ipg8mLey2iLjn15b3XHrFyBPU1Hl1TWhQB9Jf1wl++E
	LATowBeHC0zFICYUgGgqWDtaEpJ6STMyfXkDR9Syc3n02zhppFpZHkhFUO6Sg1tAatvVP6
	Gz0kR5Uo7XL8BiVnz+0iBsn4+VAHw/k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="t1v9tK/9";
	spf=pass (imf22.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id CBBCFBDE69;
	Thu, 26 Mar 2026 18:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774548277;
	bh=ZQ89K3+y398sEmLbnjakuqThw5BZANxnbksEnP28xmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=t1v9tK/94swMaUS3fnPB05FlcegFzlUOc917qnpf7c93a/ApEFIEGrj7S91rfWeI1
	 IFVl5fj2Lq/lXn2+R2+OXoywe4Rq6MLBG2GQskQTe42FW/ibqBPE5zEuuJrQ6/tKAN
	 MuSutIbxMucS08vl9D8ABkaOJDii1X+oDCJD4Y5I=
Date: Thu, 26 Mar 2026 18:04:35 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Message-ID: <acV1M3AcRqCVmIYh@shell.ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
 <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
 <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
X-Rspamd-Queue-Id: 7AE64C0003
X-Stat-Signature: 8hf1eco57j359hyp6h78sef3twadbu6u
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774548278-456682
X-HE-Meta: U2FsdGVkX1+DDyCtlYU5hkvRlRd1T0XRQe9mwYUUthhbDo73l4bMQf1oEWWOH31o1lc+cRX/jvCTKsM9hv/q3nrnf1QsQZrDpa0YbaG7aK83TTLWD9pBrGJjtgmnZGfCCTRkBPhBDppLonZrMwswwTW9otKJ/S1d8jwFWpA96dMrXOGf7+FwDnq+JmjCzsSLRpR3KFe4rG4sUyv2nEyPMRde2uqv+GN+CF7O4lZGNI6Ehn0ccR/NUiKGcT/cI7UQGxz1yX5ePv8SgmmMdE+U0bIzpqWQc7I0v+6K4ZIEAL/e1/E0KpdsdbgeERgqNADeMkB7V7LvRbEM5iPgd+k3pc5bmtiFrYkyI48aLVu3EJMNZsfcSbdU/WpAJc6b8ySa62zQa2ZuYmg78pP7BQyGCw/vC1KISTiEr0wJCjsSn+eneIWddznHPw8R5XN9PZMn1wX2hNSjHLSueDJpLfrG15qx/CYSYlYlxcHZ9NOLTRN2cyjpYvUaov/z0s9hlKnlU5XOj8gWu1lJYXxhO9Z5fyZ5BA1C5YhpV5Us7BJJ4fj3DFPYORHNwRz+5HCXfb2eWevvGa+S580xZNFmz8ZjRSRRMV5XVTyTyYD4/rSjbEjB77AI/vA+rAPdzWfoWlztO2a3xg0QBsX4j+2Yw3VTeLIx4GvMVCmEzrOP5VFa/vj//w3W945VzQUFsEkaxcrcTnlnGxCgY1WlH/+KdwLyr/+YIuznJPYU5ZFZZtYaQO1aEONLp5/9Ac/0SBkxiCo8A4sKR94Zbl7moNC2zLYlE6JYkr725TJ8rTvhNZJO62IvboS3zxmxMBXUWWoJluo0Dabwc2ibC1xcfbpYVYD0bAaIeZp1w5zSaA7SU2/rsjgA9zfZC2sQnleJZvULnZE3bIrUMGjLaH+8E1vIvOwX2dUZ6Ds43tXwbr52o6sr5+2GfP9I4IK9Zya5hoocgUTIoB+GQxePDtqx6hSYKHq
 kc29yzbp
 pDF03onNJ3zUD1RSZtVF83qWc8KYAy7YiQHMOanYOPqhFMiGs8ZtXYEsu49o/iOs90cZ36D3zFAWu/B3W1KwSJODHYuZoTVwy7+WXZ60iAuC/n6M+d5DKixEyl3kEDr3HjMDzIZBPnxI5ixcKj0FOJ4nd2QVSvsJXiTMymvpsyWNX9BYA9W+qIT9+V1PE0unECmSdAeNHSyCLavswpkaBW2nGPHHiR3Ig1cGvF6C2olFCVTI1rBe8IhK7uktwl23UwSzryxHbzi2MNh/5RPI2fTh1qvdjUPdA5JOK8H3sG0BuTAWx8mzO28TTfThVXTKiL5efJAqhKum8TaGbxxlkPnuhDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 09:53:36AM -0800, Andrew Morton wrote:
> On Fri,  6 Mar 2026 16:05:35 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > Use the newly introduced zone_lock_irqsave lock guard in
> > reserve_highatomic_pageblock() to replace the explicit lock/unlock and
> > goto out_unlock pattern with automatic scope-based cleanup.
> > 
> > ...
> >
> > -	zone_lock_irqsave(zone, flags);
> > +	guard(zone_lock_irqsave)(zone);
> 
> guard() is cute, but this patch adds a little overhead - defconfig
> page_alloc.o text increases by 32 bytes, presumably all in
> reserve_highatomic_pageblock().  More instructions, larger cache
> footprint.
> 
> So we're adding a little overhead to every user's Linux machine for all
> time.  In return for which the developers get a little convenience and
> maintainability.
> 
> Is it worth it?

Hi Andrew,

Before respinning this series, I wanted to check if it's worth pursuing.

At the time you noted the text size increase and questioned whether the
trade-off makes sense. Since then, the guard infrastructure was fixed by
Peter, so the code generation situation has improved.

The main benefit of the series is still simplifying control flow in
these functions (removing multiple unlock paths, gotos, etc.).

Would you be open to this direction if the overhead is negligible, or
would you prefer to avoid this kind of transformation regardless?

I can also limit the series to only the more complex cases if that
helps.

