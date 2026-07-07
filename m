Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D9EEC44501
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBC8C6B00BD; Tue,  7 Jul 2026 04:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45F66B00BF; Tue,  7 Jul 2026 04:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E71A6B00C0; Tue,  7 Jul 2026 04:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75FDC6B00BD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:28:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0686EC1CCA
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:28:43 +0000 (UTC)
X-FDA: 84961304526.12.A57F5B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 64B40180005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:28:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=avLOoc6C;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N77zMmBboDh9Nu37LAGHb5ZOl7VeRMGQwkLWZG8ZIM8=;
	b=QbMtbG/M7O6CN14ZzMPi5OL17qzRsSVb7fCPr3mV7eIfBrSGGqxvtecwXYQdYpnAAZdIcu
	ApYItSogQKoIimjtmI8rfHdUuOlO/6pQ13XCXw8man+91T2/gf5ospRQ4yn1fm0Ensu74h
	sHGUMdo37ZeQQDRcHa4VFoOZrV5u268=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=avLOoc6C;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412921;
	b=8TOH3kxzBNXRPnI5citcX4m3FZKiNkabSCZ9R8HLs+SbHaMdOutIcakbyUx3fKUAOme+sh
	HjSwGu1CoM2ingyhUhxdgvJE8WouRQlVqyUB2jwJOv2fsmwTUDtUPosutqllAMI2CtQYzH
	6LXNfWBzYXuOz3wLaXtFJQWgjcPJHtI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 067FE618AC;
	Tue,  7 Jul 2026 08:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646BD1F000E9;
	Tue,  7 Jul 2026 08:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783412920;
	bh=N77zMmBboDh9Nu37LAGHb5ZOl7VeRMGQwkLWZG8ZIM8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=avLOoc6CNA7Sdt2c27xf32aadrrjoziceuNEjkmLnw1wW5/k7FOpSTWmxNOzDLEgh
	 TCL/ccSG3jVCEW8vWe/mAL6k7vGnGJPSsoo6izUjxKd/rTQB/fwP3WgKOdm8/jIpSg
	 7nffJbQHiZL/n+7f8oIwMZZCemo6eCD6eFeZJ8t9xHMhwO9sCi8o0Ux3AnQZFcmeCK
	 BKpGb0W9m7zEJg9Yq5v/vcmns5MulQ5oFeRnsf5bu0+rVoP0jtjZRIUgrrsXaUg6oa
	 7t2sdzmFFQhUhRuaX3RUoEanjBpj5EAUT+YcK7W2RkRdWZyJY/nr3Uxl9GavcUBF3u
	 SnZKIkrTZoeLQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH 2/4] kho: Detect preserved page types
From: Mike Rapoport <rppt@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260703020832.1731864-3-praan@google.com>
References: <20260703020832.1731864-1-praan@google.com>
 <20260703020832.1731864-3-praan@google.com>
Date: Tue, 07 Jul 2026 11:28:28 +0300
Message-Id: <178341290876.3292146.918384529988808795.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64B40180005
X-Stat-Signature: cuqgj8qbgzhtswofoybc73aytdaag5hp
X-HE-Tag: 1783412921-888355
X-HE-Meta: U2FsdGVkX191ccRaP/d8BS8E+Gia598aPVhd1jYdn4/ZsHux4Q6nQSkmAJVvM4rJg1MHRTGE/D40sbVfg7xj0mPMibkk5x67ibusHTdi4AUESrvp1vlQoeHT7sttunsNyLFU1g09cL84hhYeUKCcnyYkKhAYMgsF3L9BTs+VL6DjomqFNP2fnXcVZ+ZWMUhXHy7xDoDP975c4KKCaPkbNxciyyul3trlHi7MHwHQmqQqy6aLXBG5yQXk+9uSTEh/qA1rRMv/Aah6SV7zv0TlfKLUnLvjyBS4x+CUpD6hcJ708x/P7/k3Yd6X4gWdo7+5yWHhQxCTC7dGRo7ifa0On7wDpRNeSTxDfltXBG48rh03bMdwh7FQT+11yH6bo8LJzoOrEtDmRc35uYm50SZmgPLO5vHp/2KsIjOGF5ty1HBesSuf1xn/WwE70PxXC8hMtpmiVQHMpKtpcCB/8aoC1ESeDoxEIxiNHDfalUhSwJR6q9+yBDWREMYXiTB9DRVclSmFvQmR6OjXOXiTmGsaai7hL1W6eh/NWhoEaddr1yaRlJ9XInT7myswAEjRf7A0x5aB7/1vDkHpnA5qntyjFcQvd9i0teMOZLGgUcvjhxTFbMoQfpe46InpZC6ghBieXORtwHltXHd1iTmHszumJxWw4wV1NTkajIsYAhCc7sNXZEHt175mMPKHpMBYnpe5SPjWRmPBJHVTysQ5iE2pewe05GuRFhvbpPn+08sgKL2FXZkv0XZWHnEnjoi2j+uA25mnQvVtViSX/GfThMfEliMZhFEOa0HyjsDK7CdW00R2zD4l4qTirtfGs2cs1t0FcVFpVHzjf2Y0FTT98f+OHXWeMk5Mh4t+3c0ncSOcsSN8Puvq21dA5Iv0Bm1xwWB2/Io/OkEFLUakqSyJ7AxeOUbGTCctSmpsMYm8O1xVo8BKl1qNrMGrkIwQhwIRmwtjmCiZfiKfPQO44c7BIFN
 +wyjtTAq
 nFNFAbWY3h0qG+Jdzpc/DIW+CTv31I/SsvHGC1wAmizzYktduT2yam1XLL5YNfJ8DZLBretCtZkzq3tT9uZL0ZdXu5u4O3SQlGQ7uXYJltqQ+oDBYaeQWVvbY0+KvRb0fs6p42AFSHtkY1VjWCKyGsseOnH97jwuzmCe/iy40K0aF4xaCNG/jJJVuZDSXzRCA1Z5nZ9RS4P5FVTJ6uWz6V3lxW2vy4Mz7ACpeRpNGE8hNAg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Detect page types in kho_preserve_pages() by peeking into the refcount
> of the second page in each block of order > 0. If the second page has
> a non-zero reference count, it indicates that the block has been split.
> Otherwise, treated it as a contiguous, unsplit block.
> 
> Since the page type is now part of the radix tree key, update the
> unpreserve path to use the same detection logic to ensure it can
> correctly locate and delete existing entries.
> 
> Signed-off-by: Pranjal Shrivastava <praan@google.com>
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index f829ffdd00f45..d6e81f72fe5de 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -918,15 +918,29 @@ static unsigned int __kho_preserve_pages_order(unsigned long start_pfn,
>  	return order;
>  }
>  
> +static bool kho_is_page_split(unsigned long pfn, unsigned int order)

You can return enum kho_page_type here directly (and rename the function
accordingly).

-- 
Sincerely yours,
Mike.


