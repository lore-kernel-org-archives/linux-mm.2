Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA2C7CA0FF6
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 22:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 101996B0022; Thu, 28 Aug 2025 18:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1EC6B002C; Thu, 28 Aug 2025 18:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09B56B002D; Thu, 28 Aug 2025 18:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E30656B0022
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 18:54:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80E8884281
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:54:16 +0000 (UTC)
X-FDA: 83827671312.24.1BA1E63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id AE50680008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:54:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="L1f61/R9";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756421654; a=rsa-sha256;
	cv=none;
	b=hsEnaA9nZ87Rj58Ix58ulhDPdvJeeBFNDenpzYWsTpsz8SgGjauCfrW3asku+vZGkGatXM
	8rEDhrY7GM17+hj0WIUQwHgXWQqdY45Da7uvLut1T4CEIiSnEH8kofhtC9wgQhMGFNyJ7x
	JmtoH46QM+68ld0DF/cexzxiLP2XwN0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="L1f61/R9";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756421654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RpOFovYpKAcWit8m/s+OB2ghIwxnF4opUhTmKKJStrQ=;
	b=8XHDYb8Dlo4ZLkhDbGY2WNKf870TAFXz8BsdrN8bZx2+OO7FqAQ7LDwFIbFyRPfKvpnhCF
	M400umgrufIiyy2XtDPKyquma58L8b3e8+TbZhMr3exoNniO3Jzho9tQwwO/gOFRHSwHbS
	44uAR7tM8/i3hg9eWIch0Np5t7gfrGk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50EA540825;
	Thu, 28 Aug 2025 22:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6E3C4CEEB;
	Thu, 28 Aug 2025 22:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756421653;
	bh=2+UzjJF2BlEl8nA15jThQAGkqhW2IMETJx5lsJ1gMK4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=L1f61/R9NWDd46wsfh3wOnq5DAyDH1ultA74tABD9myh4H3YI7/pC6Qmnh9NvqvEL
	 GM3tAXqIrrO9F1VaWGcXa7y5OdCe/japCYCzgUASGPbCeUQIkwbb7jeqQpEy6JmW+F
	 qTNFK/FCMZNPGCwq9NU3g/7VQt4xYczY/vAy2OFo=
Date: Thu, 28 Aug 2025 15:54:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Brendan Jackman <jackmanb@google.com>, Ujwal Kundur
 <ujwal.kundur@gmail.com>, peterx@redhat.com, david@redhat.com,
 lorenzo.stoakes@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, Muhammad
 Usama Anjum <usama.anjum@collabora.com>
Subject: Re: [PATCH v7 1/1] selftests/mm/uffd: Refactor non-composite global
 vars into struct
Message-Id: <20250828155412.2b1b2095125428af24896af5@linux-foundation.org>
In-Reply-To: <kd6uteyd4vzlnbdwzjydwd7hoqyxewc5fx24z5sq7svmtoa3oo@n57xyeu3vtyy>
References: <20250817065211.855-1-ujwal.kundur@gmail.com>
	<DCE2EJ3KWX3K.1Y198FHBV8UG7@google.com>
	<kd6uteyd4vzlnbdwzjydwd7hoqyxewc5fx24z5sq7svmtoa3oo@n57xyeu3vtyy>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: AE50680008
X-Stat-Signature: yd1ygjprg9dhki4igwsrw8c9nt5qyrka
X-HE-Tag: 1756421654-225603
X-HE-Meta: U2FsdGVkX1/fm6K9gAv9CKdZ4PX6TkLVtTQ4Y+pMg44+nDGfU8xvmBu35L6qTGvo4r9iwXAtcDomICvtYnKRyjhfR60hw/gzZdlk/6mgW0l69AqW3/ozhCixwXcCn/MMM4QToj9LKmvPItx8PKyKc79BCNHKqtmxy8RXvhmyIl6w3vnhenKX4Nx5ou6Ym5ohizaxvLQTqsQojqqMVKpQLIdd3CUnKRigyz/Wy/ncV+wmGS9xgzFmrfdJYaEDHYWVXXE1ailGz5bxYSa0HIiJ32x2dmyHqlS8lffUD1xdtffn43i8AC8z5LTFBSroJvtbkw/QQKzXxF8MEQmFiqTLOuqSjD9ds+gNtiaGxCq4ms/Y6uNj1HpEq9nX4yC79qQpHgcOZBjDj00vGmTH677VJPJXn76n+uGaGnu5KLvF8qZZEk5qRVNG65nzTydsMz4B61Z7AsxmGMRKXMyRYmo1+MsbEbCV4l9lhBxa6QiqF5m8R0X5HVdUMSM896GG1zQTYCTxpgeqDUYmOiSwlrjacafIlSbs0z0KDctIJS+uhXymkmLAW6PulDCSGpY3THNRe1iOj3A6PPUOxklpM9miscAoM67tHFlhqEb+J/yE/H3SEtJSRCSJNuTlAo48BRk9HJ/BCcI8xXOJqbF6bQKcHcbpytVZkazU6Qo4zh0gE91JNRyZQbdpxTqRyUPKpgHh6Q37rJi08u7oxnQDgInEzkARAnB/MDeKeNfh4gzJ75pifoy9fsdiyEVPmD4IsWHs1M9RjS7nm1+ihvLRVFQF7PxVj76r4lBdNI0YeknkVt99EaEanQIJxR00Q7F/URPeHVXe/koNJQr7nkSTEbDTpzRx+qkB2XN+N5xMDDrZ1q74YGe/auiDsXhObKlb/yRLFPjy5qQRDr1vEjikNEOwGYDVxpfD/zPe9mumTsF+c15dvCUBEvqovHCJtqzRXMzXjDs2JsFcX9tCcmFBbya
 L3Iee2uD
 SoKQdIKGWgVVRqTwW9TjOnEVOG5/psFSwHLRlyrt/0UcRGVHiwKqJLUtENyAYoBnufJZoQXBdsLzfikknoxakjSEgCa0P0Iq4NgW4CP3xH90oGB3wViH1M3V5jHu7F0Kw4n+h8G8eRiB+tuoNIn/7DDim9KOYbqyqMus5PcVPQ2r/IiqyRaSgiopoItIw7xZSxnZ6VZ0k31KLlBFDxp0UIrf2FKr5xvdaaGAjuaYqhPkVJ30Qtwug3aDHH/uljCSsIbwcvi87b8MRolMw8mpdW4iZjO+QXR1DbvzL3FbD+VtdFK8qD19ah8PV9EvTvm1RukVtsXcIa1td/QMJZHkuTnw/V3dnVBipPwBgN4hh+9Thw0QmTmaeSiiIroSeuM2qA6iKEPqyGzd7nqkY1S7cSsRusiseckUPUJNpnkBjFxqCWe7IvGJeeI3uLGgPLgqcjJJ9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 Aug 2025 14:49:37 -0400 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> * Brendan Jackman <jackmanb@google.com> [250828 08:37]:
> > On Sun Aug 17, 2025 at 6:52 AM UTC, Ujwal Kundur wrote:
> > > -static void noop_alias_mapping(__u64 __unused *start, size_t __unused len,
> > > -			       unsigned long __unused offset)
> > > +static void noop_alias_mapping(uffd_global_test_opts_t *gopts, __u64 __unused *start,
> > > +			       size_t __unused len, unsigned long __unused offset)
> > 
> > After a rebase this is now falling afoul of the -Wunused-parameter added
> > here:
> > 
> > https://lore.kernel.org/all/20250731160132.1795351-5-usama.anjum@collabora.com/T/#m0449dc0d6a5ac3b1f71f7182c13b6829e1b444cf
> > 
> > I really don't think we want that flag, I'll comment on that thread, but
> > just as an FYI here too.
> 
> I was under the impression that it was decided to drop that flag,
> otherwise I would have also spoken up about it.

err, yes, I thought I'd dropped that.

No -Wunused-parameter, please.

The v2 series needs work and a v3 series is expected so I'll drop the
v2 series "selftests/mm: Add compiler flags and fix found warnings".


