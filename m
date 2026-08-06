Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8357FC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA466B0096; Thu,  6 Aug 2026 12:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C8C6B009E; Thu,  6 Aug 2026 12:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83BE16B00A2; Thu,  6 Aug 2026 12:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 604BB6B0096
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:50:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E881F120172
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:50:42 +0000 (UTC)
X-FDA: 85071433524.19.4AE1CCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 45B05C000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:50:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HG06fDnf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786035041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUl6lNqnz54sltgDCL6el7ouDLirFAV6NA5eHu+t6hM=;
	b=mCFVi4S2UIdy2IdCUCvjNVUippnVis6DRR082WippPIkaOFLKkNCzeo+7aD6AZ9Y5TV6ME
	TUx5gr9+hfBc97d7UkRkzIrByY69YCDDWmvROdVV2NncpIw1N069zIxVghhm0d8yu18W2z
	G5YsP72LT5DYpu95eo8lMhgI5BB4SB4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HG06fDnf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786035041;
	b=zXk9BVbsElrD94KWjciWyORVC2d7xCIg9g1o3c9Gkp+eEUalHmtTAqNRqR/CUQDBaF7oZy
	9MG9F6towjGFIC3cQYh4q3NgB0Mb7dXHHqu2I/gRrWh1iEEcOjbmaXMrG+moe9qkiAzFYF
	LXbDL363LwIksb6dB5RrHqhNvOoBLCY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AA1E413AF;
	Thu,  6 Aug 2026 16:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F4F1F000E9;
	Thu,  6 Aug 2026 16:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786035040;
	bh=lUl6lNqnz54sltgDCL6el7ouDLirFAV6NA5eHu+t6hM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HG06fDnfmZeAApxcQA4GWV6CFauD2aXPrUDntD3cSbZDHV6QrN0SrBghox6vLUbDq
	 NpuiOzzwCnAW2nGkYvZZ3awyA8kgdqqtmqsP2cARb04/ywignq2wsfc0Mo3ptmIj4w
	 l4GnKoHQw6KS0ZC4pXgHMgVxUg4aHdRz/prq0YxQhtw4zHrebYKINpgYtgqYKetgIs
	 afit71uGXv04BMQkj+qpQNi7alAWdgA2pL4Sc6DCOSDBsuKfUv9wF9b9H1cf7D6eW+
	 X4ff3VkOb7i/AHrLeQJiaqEc/pw/H5hbQfvc8JNQkKaSMdr225YEgH9iOPpuZZrcqK
	 0y0PRW2ROTN1w==
Date: Thu, 6 Aug 2026 17:50:23 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Subject: AI slop (was Re: [PATCH] mm/huge_memory: let special huge VMAs
 bypass the THP) policy check
Message-ID: <anS6hcgMkEJocbDJ@lucifer>
References: <20260805055544.1568534-1-clg@redhat.com>
 <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org>
 <anSZpAjt84Pn7O_b@lucifer>
 <5b7e84f5-2007-458c-910f-7a6e1e3d3eab@redhat.com>
 <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
 <20260806164517.GA140051@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806164517.GA140051@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: ojrkidheqb8errpgpa3dg34jow7ohisc
X-Rspamd-Queue-Id: 45B05C000C
X-HE-Tag: 1786035041-696955
X-HE-Meta: U2FsdGVkX1/3OIgUVlMSGoh6LBZfD3KZTNVkGiUHEV0VJQpHPQ/J893N0M2Dwiv2NxbJADv8UbIV4IHtOlvfG5nSXJF2uRXC62FAQz36ttARcdCDHBeRhc35CWsF5qjyz8mbmuTaad9hNxjbrJfXqSXdIYimkmEKhHltkLSghP46IMneHr6OjbgeoNCwxruu5reEpEGtZw7mnVS/3hepYBNoKuWTD82RwOklE1qf0ZibmjMA4ywdVx+mqc3NstekjQ2Z6QZuKzpttn2+wE/WhhheDKNyVvSVhEP6VHH+MZi3Hcm/ro28NbcA++urQmPjVrJOqlixck4Wd31SM7RqIpkTlRMOUdYneGcaQ5g4L1uWJe/7ola0wDPbshRFatwBWb0fPFutxpQq3kkoA0AatZY68fDWk+kSH77iFR2a8p+HyVR6dxsX9l3Rxwfh3Bj8vmTeLe9b4VoGsTdE8FpFq7CFGbJAJEWANOy+XHhcZ60y5j4hRml8VPQ7mT9C0egEbc8ugXa3HinONplwmJTq6LdoLZANBMnJc7gNVUtK87mLmtEqtfuV1WWziouGrL8qS7WrW5DsL0PWfhFAidpAMCifH2hrKZrjm3yFUyXdj0QJjE2EmGFKNgv9xmkZDppN2iwlWGxkzpRtDPhS+J8cXzp9oTWCfOUOeYgWsbeDF7rjBlQ+FVzzNSVjMrAjP4Ox66UZvndD43R4coykYcgXyQ4itHo+zsCND/iJlJ96jWLFOJTDsnDTVghEv0QCEhFiPQa4f3DZLsXSASgV7pH7JKI1xEAw4Nv/ZUjlY5Sb5pL1EOkY3c6yiGvNzDQkIp5+fnS7Nu7n5Ix8YeQOq2Cy8K+hSv8DdETSBgmCBeRytsiz+yr8T2kf3Fb+93D0o1Ar2dxnX0wLeIBvf7hM1GP88M1rsbGCAWeiPVRJkoJhnt3hNPiSfvVUOsd0zGnC1ss7yGL+SZhAI//JNBAWyI5
 8WokET1y
 k+2eBHjIYPx8rFe7IKym6lMv4u7orgiGDBo2yBhXKjeokSsCi9ggJHDQZCf4hO9fZFWF44Y1BMt0NIFGvps3G936VYWNd8scMScBC3h8aSP0AuRmZapSFkQuCITQi3aGEvHijfvMh0DNN+6Cxz2l3An7+OjD7wkhIhP9XEeU5ZHGoSywyvDURhK9RKhkTO90Qo4gtKGxuXAIA6/BHrw0fImWgZbHPWCefHAaOBlThLWXETxSWCk2qhhnK0KdJ5F6wKzh8JO4LXHpHMYPIVwHWDcBpitignNoWA/7fHTdH1fTyk9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc some people to make it clear this is a general point not aimed at
anybody in particular.

On Thu, Aug 06, 2026 at 01:45:17PM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 06, 2026 at 04:47:07PM +0200, David Hildenbrand (Arm) wrote:
> > Just to be clear: Unchecked AI slop in any form is making my life
> > worse every day.
>
> I think eveyone's life who contributes reguarly to the kernel.. The
> only ones who seem to benifit are people doing drive by patches!

And they shouldn't - we should make sure that nobody doing this can
benefit.

This is why I've revised my 'I will never take somebody's patch from them
and do it myself' policy.

If you do AI slop I will ALWAYS do this (if your AI has found a real issue
and if I am able to without burning out) or just say no and push it to a
TODO.

>
> There is so much more harder work on the maintainer side, and it is
> now even harder to get patches picked up on the submitter side.

Yup it's all awful.

>
> Yet responsible use of AI seems genuinely helpful and quality improving :\

Yes and I use it daily. It's really helpful when kept on a short leash...

We're going to have to move to a trust model eventually IMO where random
new people just don't get to apply anything until they build trust with
smaller changes (and with measures for established people who start
sloppping).

It sucks but it's the only workable solution IMO.

>
> Jason

--
Cheers, Lorenzo

