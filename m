Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA25CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D96F6B0005; Wed, 13 May 2026 04:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A456B008A; Wed, 13 May 2026 04:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1F46B008C; Wed, 13 May 2026 04:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E92876B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:23:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B22FBC273D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:23:21 +0000 (UTC)
X-FDA: 84761707002.18.22B8D66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 13D74C0002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:23:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DRb5CgSX;
	spf=pass (imf22.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778660600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhk9YwjZGvF4vfOPwJa6hePwtO+1WhIoHAcKuymqUqI=;
	b=6uPlEeyAoqrSGiAirG00UFq+EY+KKmdDp4zG9uQxiFxBm+DxKa27BIniBtlD7PLdv72LHb
	lAGgg9h4cayEyBLD5MaXsD/r32oBbvTI3EnIeB42BF8bNNWTUxPK37mT8lLFp6fpNE3iaJ
	RjBW8D7b5XABXr1t+sqRly1tN7W2imA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DRb5CgSX;
	spf=pass (imf22.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778660600; a=rsa-sha256;
	cv=none;
	b=b1VwIldZrD5OA5kFrafXQ4TGZcBWEf4+XfJnUUuAWHhf1T7qciG3tVVkHuyLLfiVhUez5J
	KZ9xPeQ+kyNy8isUXwU7aDPcKRrShB/ww5JVXWeBQEqpcIYfQq9egpa9CG8khspjUV5Dmd
	LQtQj7t3AyWP9ADFlnngvu1wycC+Vpk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DFA80418C4;
	Wed, 13 May 2026 08:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D367C2BCB7;
	Wed, 13 May 2026 08:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778660598;
	bh=SuUym0zLsNO3NXPX2d2YX36lG2MP2GSoYRRs5OYn48I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DRb5CgSXJVFnImbAzQqZCZCcwtgYQEw4dEf2oZNaSl8f9BldFWf3dqEu6szwChb7a
	 Nl5F8NIFubdniAjqsqWVJhRW5m3pWMbxDyppBHio8HDffUahTY4TCSHoD9xm6S27ZM
	 0hBPUtWEy/jUbKGs+UwJhjZcL4ltxJ5FLwtjGubpsNXBgbAKawwB5COX83W1XPWbWQ
	 YC7oRJ5fjQ55lHnd4cWc1DyTiMsDliCsbsnU2w/BJfNKAiPLoquK9yy5ijbhoVS2Ne
	 xFkUxq/IL4vb7BA8NchKDxYMlC/X6Kmnu6R1bFLOxLEvwT/VHAwBNRfJsSG2hUv2Mn
	 PoUAtfLKlLXzg==
Date: Wed, 13 May 2026 01:23:16 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hongling Zeng <zenghongling@kylinos.cn>, dennis@kernel.org,
	tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org,
	kernel@vger.kernel.org, zhongling0719@126.com
Subject: Re: [PATCH RESEND v2] mm/percpu-internal.h: optimise pcpu_chunk
 struct to save  memory
Message-ID: <agQ09KxgiBWayuGJ@palisades.local>
References: <20260511070309.44044-1-zenghongling@kylinos.cn>
 <20260512150340.c8ae97f9299918a1f12f3e7d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512150340.c8ae97f9299918a1f12f3e7d@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 13D74C0002
X-Stat-Signature: yfnfd5z7wts3yphmgqutzndke7ic65rb
X-HE-Tag: 1778660599-827967
X-HE-Meta: U2FsdGVkX18Zx95YF+fiumlJR9TgQSisZ8Ioar2qAuvDsHFkV2fW/nV8QrWxw4gR/N9JVvck5WrSfBdOUF9l2k+Uo+iwCQ7GLuTgcgfYHQ9hjZZ+4ZUHXDDHqwYy3Kfja78Qhj/rsWcMXPPGJJogGH/nIGqPqqQWBbpS538eEb42JVfl/3DX1ZgEdivxYMHPMtbkl0W6cctOa83CvSpDVYKb+HWv0JZfgOjN6++5Jq+oe7s/P3w167kHJlcbrL7vuNpHw1MSys6O8ReT5jURupAJJnWRSw0UdySOJGTzZXHeCqSLBbKiRtfDFjy4Pq5U+gVNUbg3jssbTT7Xe97KZguJOqbMJS03JkxzPjTkjBNs2ycdw6WVR2j+cLVcqEEwAN/mXLbfFV6I08Hfd1WPV+xquyAz1EBeDeN4PUJoNtj/Omwo0LV3WD2PbrQPE8z0PBIhaUhA7EAcSaRY+Uz2hMuCT870ocC+nhQrZL4WNmEB/zrQe5lZJwanMQ4vwZzT9lAbw92f5AhnK+aAn5+S/UnOOSLORIYE5RZVfnD8hba9jdw8RbduLlECBDjqSGjeILV28iEAsftkm6K3K/IFGl84VnQAuXB4sVWfaLI73cCF9rtlq6ltRxgn0X86TIwb8lX/Wo4mVOvSxI+6lUTstm6+4Rob5mynj4k0yNm/eSS28z8hEXDtDgGad5OhvVsXKhzbhHWzaJm8mPKuBoxteAT6ohbHVbwj8Gso/uKqEhSICxoI1UFmKefprhtOTK3hDnAF8Z2OIH9vusNh4JGnR9ormNoQ0plWNcA7bhsqQFm3zGunbEs6pUUF3aZZ0CifqX94hgIWp4DYFS/R1zxD2bKrKl0cCUlTyXNR5XpU9HQEXefgjqpkwFt69kRNS18rm4ZLB92UnpCv2cg+zE4NN7lDmMgL7AbqzL1uqA7MmetKHXvcgsAzsDkrxyzB51E3znvJSorJ3LjZEDNs4Vz
 Vb4mJPwa
 ci2n4J3xx7RFN1YpJWQvHullgySRhdTbOKNNQScreJfUJHoo6k/rwtlzrDHFDk41aQk8RHj/fJziiRAt92UN/Jh0TkfnKKauOIUdVT49fldF/TgqZr0ucCJvXmTkzP0Qul0X4EeLrKMXYdtcoYOspxFLPewOaWKLQ+mQJJlOYhwq5E6BXe/b2Yu7YqlCw9tWscYYTT+qtiIc7TZE5B458YqRGrnizhoUWuhGE/SzFFRHUWGicRefNt7fOjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Tue, May 12, 2026 at 03:03:40PM -0700, Andrew Morton wrote:
> On Mon, 11 May 2026 15:03:09 +0800 Hongling Zeng <zenghongling@kylinos.cn> wrote:
> 
> > Using pahole, we can see that there are some padding holes
> > in the current pcpu_chunk structure,Adjusting the layout of pcpu_chunk
> > can reduce these holes,decreasing its size from 192 bytes to 128 bytes
> > and eliminating a wasted cache line.
> > 
> > With allmodconfig (CONFIG_PERCPU_STATS + NEED_PCPUOBJ_EXT)
> > Before:
> >  /* size: 256, cachelines: 4, members: 19 */
> > 
> > After:
> >  /* size: 192, cachelines: 3, members: 19 */
> 
> Thanks, I'll add this to mm.git for testing, but I'm not planning on
> taking it further until Dennis has taken a look.
> 

Sorry, I thought we took care of this one prior before. This is per
chunk metadata, so it won't save much. That being said it doesn't hurt.

Acked-by: Dennis Zhou <dennis@kernel.org>

I'm thinking about the other percpu series now.

Thanks,
Dennis

