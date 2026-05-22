Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C00C5CD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 09:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347F16B0098; Fri, 22 May 2026 05:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F426B0099; Fri, 22 May 2026 05:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C9C6B009B; Fri, 22 May 2026 05:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 150EF6B0098
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:06:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA0C61408F5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:06:53 +0000 (UTC)
X-FDA: 84794475906.03.9AF8A46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4569618000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:06:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AHh9Mvku;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779440812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3c05gl0H/GpWSA6qaxgxfypMYcQADyQffOHZBAKPcvc=;
	b=Yq6j4yJi1l6W716dH3z12UuKHT9G6x5rdcT/cR1qW8KOCR8KFs0qWTLj510lSwqgoA3j7g
	w/oONNOY83gR4hxSv8QDVBY5SniqvxD5+7eqiSpmxP9amzNldwLLPaxWoLS8YrY2vMkhsB
	ML5tEjeqpGGdcNLbpd3EH+whT/VrohA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AHh9Mvku;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779440812; a=rsa-sha256;
	cv=none;
	b=N8bp6231ex4cpIGqhWXR7cvKkVeNzAsEswwIEVM01U9ml78UXOZZW4q+9uDo/HZqLS/v+Q
	gwyObkjp64bsHp1ZpO7KMT0GtAcPfHgyQohPyi6yCecqDFCECqh4mrIj2InKmvl/6vzrCw
	jJ5GryQkobyHvqi3mfVETZtB3ORBEEs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6DBB60136;
	Fri, 22 May 2026 09:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701E21F0155D;
	Fri, 22 May 2026 09:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779440809;
	bh=3c05gl0H/GpWSA6qaxgxfypMYcQADyQffOHZBAKPcvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AHh9Mvku4Tnd8U5EQXKfG07xtqXD/gmOXK6xZTxiIvJAiMFkn1FNVmOhV3MWPz75/
	 IV9zCMOtUNQoilLVACbSZK+6EbGvqrV5e1yPfiLurnr2w835AOHAnwWn2FeYnpdyPC
	 fhxUWLFapRiDSRH2XCyrWgKKh58W3k075AIgm7/R4TgvNhK5wwhclvtlNGngiQjS3a
	 8cPy7dmRejgOL+ZiWJjl6IzW4cEoNz5h+OsGrMMS+AA8hglPmkdWuQ+LPZzi5AbFJI
	 epMFfBExLfqLf6f4l8USRqpiRmVtZyXHsW2kjK3jYOy5jDOEQO77z5X28B5fJPEHYd
	 LKQBvrIrMTVsw==
Date: Fri, 22 May 2026 10:06:42 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 2/2] irqchip/gic-v3-its: Use GFP_ATOMIC_RT gfp flag in
 allocate_vpe_l1_table()
Message-ID: <ahAcWjiPbf-V554w@lucifer>
References: <20260520204628.933654-1-longman@redhat.com>
 <20260520204628.933654-2-longman@redhat.com>
 <861pf3x3hc.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861pf3x3hc.wl-maz@kernel.org>
X-Stat-Signature: 96gwfejguh878rxsbwqeg133qgn5f8qe
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4569618000A
X-Rspam-User: 
X-HE-Tag: 1779440812-195280
X-HE-Meta: U2FsdGVkX19abeXBEgLFOaw4/87yR1zwbe7RygWKmDJP6VheYhUsmN72Zbjo3CBpxVdkojxMZsHY1YzXRDILcQ3Zp0sG200J2Pi2nZ/zzcsSGcpJQWZXD1UQw0vvnnJDpNQaQQUpNjfSuNen1uR1cVQWMti2dOGhQBYOPQsJUHyaMzL4tQTKpVh0/qnjEclI4VeYB5UR0G6OtwCpp+w/n9I3FmnIOeKGV618f/ktmF1G0aJ5/KyFPaBEAsN9B37ZKeyl/8EcJigop4tkhGu8GPLayJgLnJXCQQnjptftaJX4dDtPYh/l2guWxtK0Ld3VOmt5zEFu6otk3NS/T+PRujPVlBTMwz2kpkZxWzdPOC7mYjWhHzLuDBQgUICq/LJhmr31/t1sqCszNJwr+XLTYYejdos0E/VFxgUkChS2IID7uJDnrCeW9o2ggWynsl1Bpe60zOzQG8QEAQ2lcDcmJGiw6k+HUcqjZy+A8o+v1QbrthgvUYwlAj7iqFa2DrWWdHOVyttTWg4CsAkQE0SBxn7QSVjOGca4bSeRvgK85iquGsDY23BdAgn1K9SAoH8gSXx+nItKmuBwLLZ84Opo4fyqkQG0coL5hGPmIi/85gg79sqeUilhy8UgQmKTfPbHfSS6Ks2qXoTyP9g9vd8QWl5h5mO0+McZiGmmfnuVboxnZoamfyqlvKZ5mi7AkMNIdiFU9Mf0Pviyc98rWtrAa6lbkxJ8uwDT1fugR4nWxYEmoRnuwoT70r7DZZNivblgiCQApACZzdi1tnSAxacPl+DdzzUZ7dzdf7FQDg9wgAbabSLmNNl2/swt4zQs8KaCVQER2pVceJXAU4zELJiixfHZShSIHVhDyj/mQNJELIk6WBgtnBHsOUapr7rVKPDzHKSeLq3UY2f9kWviJ02QW3CJJpTBrAHrdbzgEN68x8eHME7GStH85eF4fVODxNofIeBqR5Ca/wqFdLEqw/o
 5NXSHali
 p7xTa3UFReQ7fJk812wmGEMGC3AXdsEqe+ukRGK5WydGI0qHJEa1JB4BCJVuqzIyy4zDku5IH99/77krzmC/ReSTKdScqL1isfUSffaSRcyOfGEJ7dI/Vo9HmmouThTJy8jcNxMiLjVp+TN5rSAbdXXVKvHScJrM3tHmdKeZ0ikrnOkwzde9S5k2OeUwXELLOHQUmpc02RJ0CtSwJPXF/oCr5Avx5zQO4s0qoRci019MZfdGlnrxaEFtAT1HaoK1G4SLdQGunB6k09MPEZTRy4sODQ6Pn5wafsNoWAwg5Mjakp4fXRKVZcgWfhWfXdzK5VUeU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 09:17:35AM +0100, Marc Zyngier wrote:
> On Wed, 20 May 2026 21:46:28 +0100,
> Waiman Long <longman@redhat.com> wrote:
> >
> > A longer term solution is to defer the allocation to a later stage of the
> > hotplug pipeline where interrupt isn't disabled.
>
> And that's what needs doing. Not papering over this in a bizarre way.
> I proposed a potential solution a few months back, but didn't get a
> chance to work on it. If you have the bandwidth, that's the way to go.
>
> But papering over this issue this way seems like a bad case of short
> term and unsustainable hack.

Yes, agreed. It really smacks of trying the fix the problem at the wrong level
of abstraction.

>
> Thanks,
>
> 	M.
>
> --
> Without deviation from the norm, progress is not possible.

Cheers, Lorenzo

