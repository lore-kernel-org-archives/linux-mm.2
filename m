Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 980DDC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A5D66B00A9; Wed,  5 Aug 2026 05:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D3E6B00AB; Wed,  5 Aug 2026 05:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894A66B00AC; Wed,  5 Aug 2026 05:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69D0B6B00A9
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:33:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 078F41203D9
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:33:05 +0000 (UTC)
X-FDA: 85066701930.10.90B7D43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 71CBE180008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:33:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TV3NVZ7u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785922383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bNSPhkhNPtYmenXs8cu1O3USEwCw/cTE1SHV8zst2nE=;
	b=6kxRwcPxqw0GcbQeZDLn+PSFgtxxk5GHEogqItWEo0OmDbvW8Ut2fFW1ILWAhoKVcvW4aR
	sz+aPxG1qJJMEngPpRyiMYXLao0M+CvRHfQdvJxtAJ+h+tKkywMDjn6+hpRgPI0VRA6Zgo
	e0et2YfIhQ+IJVMu6pIvbkXNPQP0Vy0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TV3NVZ7u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785922383;
	b=TZPqttmUk6qTEEgYUBFctL9SZcIRcihFn1TsnBvbsNMT+L+zZ7UqUbp+cPWLbnWviaHYGm
	JwM05NRf6+jJVFYHzlpL03xkj5H9q1ev2x7RYlthgakJDnLyjcscDTM1LuPRL8t09BB09/
	9qJE/827r/Lvf2e0fE9mTXlJ+S/YS9U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5C1160A69;
	Wed,  5 Aug 2026 09:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEFE1F00A3D;
	Wed,  5 Aug 2026 09:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785922382;
	bh=bNSPhkhNPtYmenXs8cu1O3USEwCw/cTE1SHV8zst2nE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TV3NVZ7uKlrVLrToMH2tDsWTEHRFY5dWnRdkGbjl5U35va7uDOisS+AFKKW8SyIwX
	 cuOt+FNdVWls4WRPl4MybnzUGH3lJL9Gl/UO2uIc3ESpQs2axolz7FsBaZ20aCNg4z
	 izQut7pCFWc9Kyt2ug3ZdxWypPGdOxHB35nNrmhQL0RwQC2ls59mSr8AoO9leu76vr
	 Meu09tg9W6HOwuotlY0zBG3yWlj8UF5PjGFd6myIOa1COB/DGr7ens+E2z2aa+ONeu
	 asAm3ROH9B26sg05DV9+mOJx2yHoE9pxJv2l9eJ2G4A8dpZ3x6yZ91B/9iZkiVBgs6
	 y1nXAajFDBt0Q==
Date: Wed, 5 Aug 2026 10:32:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: dayou5941@163.com
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, Li Youhong <liyouhong@kylinos.cn>, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory-failure: fix concurrent access issue in
 min_order_for_split()
Message-ID: <anMDGv1p05wKlMyq@lucifer>
References: <20260805084224.2597547-1-dayou5941@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805084224.2597547-1-dayou5941@163.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 71CBE180008
X-Stat-Signature: rpptmuieeai6fduz4djd46r3oqb7pfk6
X-Rspam-User: 
X-HE-Tag: 1785922383-475092
X-HE-Meta: U2FsdGVkX18qDll/gPFKmATgwb8PTTF6T9ZIs/Kmu+SAFjqzrhM8UcClY9OyvwzGEGYoKlLRLr+pGO30GIpPPmJeJBujLP8nG8PhfHY73rwby2dAXG6U8Yz7F6f004qVu/hR6j+k9LyvSVIQwbFpJOejem+VNU38qD9TndSGsgqHu5gVVzE/dYPKCE1Bigt1yZbjF3oNcrBbFs4xVzuOIOwSNlOf7wLem+0Dzw5VWO12UJeC32A+BHRsmKv5VsGQhXoO9ewMjRUBcDOBnAnwvfF30umoD60H0dFzQePt6ztaUNS+Jbk2P5Yw0459SDcWr8iF0dfrNIysFLGBLSw5P3lNU0Exoz3m4bislrWQ5sasP8+5pCa6fvNHyj37USx81r2ue4dZmgkX3jAqr1ia/COhzMymGLdC0Lls6Nm/s0pfe08Dge0dbX4Zl0J0thmDySEc2Yf5d20Yu3L7fZqx0p23G7s9v+k85GStsX9junbdZ0ERTZVm1WFJWeQCI0jthn2Sh+fygIyrotvGah77LOYBdwxVQ44sXgMUnZEXc1SqsDq4JpIXrRk/ZknFr4TEu9jAjNjWpQdy3wexLVHY1NkGMVBfwlHu8y7HZhLdM4n2fPXcnXU60ORlQ0vFlAPAfLQ0HccmRkDkDyQ0uQ/C5YEG2qaeN8lbZajcreE4wcGxx0QR4JgtQrOnrAnllo7IEL086i6UNr7/3QxDjOvE4BBzcYMtxsS7rZ1Ox8iarqIo8VjxoK6xy5KcIiMdaiYCDNTdeijDLieVtPMrJet9iSOi0KwP3U2JZx3inJSTo59Ujm23cjuEuV1qXd4LCxtA6Q5CTWNqJSTF8jf9tLoW4R3956cH5+s2mu+UIuk0G5fFy366gbXwOHg5YcDBe6MpzgFHfVe5cB/rUUsyEC9NtgK+mkoKTd4Mk17C9PDLxqnY2PUkaCYRCZFonZXPPNNOhiDUm9nHJDoBLIRgxgn
 03xirzOL
 4k10Ai7IfblgBlciBfb4OXkVgIvWbga3FupKPnreR9tA+kJ2kTNris0fRWn/W8KYqfuKnuMEqDdfvi+eADN04u35Pagb+Xdci9qbhkr7/xnnsfbgXaw5B7TUr7JZRA1vE2jhpAfwms6i9zQ6j/tcI46JG5EGa5sVqaSfMK1/jwZM8c3K0PmdL88NHQouI/tPJ632MtEkkW7VOkpI2IQDoqCi9UodSwUsEZib16mfTcpRcC7+0yHgWXOMRAbKIZrOoryabO/8rcO6h2vtj7ftZbVR/n0heuqtWLhVpVSaRhqqFmgTnMckAmaBoQQYbM7xMBwMC8ti2L018aM3axg+n8qAiPKb7bh8X8Vbznh6h2iiMU9wYOLwHH/hrSTffd8OkkBKluPQPl/ZMVKa4QeNmJQS/hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please stop sending series so quickly :)

Leave at least a day between new revisions.

There's review on the v2 that is outstanding.

So engage in discussions there and wait until tomorrow before sending v4.

Thanks!

On Wed, Aug 05, 2026 at 04:42:24PM +0800, dayou5941@163.com wrote:
> From: Li Youhong <liyouhong@kylinos.cn>
>
> min_order_for_split() accesses folio->mapping without proper
> synchronization. While the compiler typically caches the value
> in a register making a NULL deref unlikely in practice, the
> real issue is that the callers in memory-failure.c do not hold
> the folio lock at the time of the call:
>
> - memory_failure() explicitly drops the folio lock before calling
>   min_order_for_split().
> - soft_offline_in_use_page() has not yet acquired the folio lock
>   when calling min_order_for_split().
>
> This means the value of folio->mapping may be modified by a
> truncate or invalidate operation while min_order_for_split() is
> executing, leading to a torn read or use of a stale mapping value.
>
> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260803060001.800638-1-dayou5941@163.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
> ---
> v2:
> - Dropped the approach of caching folio->mapping inside min_order_for_split() in favor of adding the folio lock at the callers.
> - Added VM_WARN_ON_ONCE_FOLIO() in min_order_for_split().
> - Updated the commit message to clarify that the real issue is the callers not holding the folio lock, rather than a TOCTOU race.
>   v1: https://lore.kernel.org/all/20260804035828.2684059-1-dayou5941@163.com/
>
> v3:
> - Fix author name and Signed-off-by format as requested by Greg.
>   v2: https://lore.kernel.org/all/20260805072625.2437636-1-dayou5941@163.com/
> ---
>  mm/huge_memory.c    |  2 ++
>  mm/memory-failure.c | 12 ++++++++++--
>  2 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 58cabe6af33d..e3f16dadc1d4 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4300,6 +4300,8 @@ int folio_split(struct folio *folio, unsigned int new_order,
>   */
>  unsigned int min_order_for_split(struct folio *folio)
>  {
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +
>  	if (folio_test_anon(folio))
>  		return 0;
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 3b1e6946821b..7391524b5046 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2437,12 +2437,17 @@ int memory_failure(unsigned long pfn, int flags)
>  		res = -EOPNOTSUPP;
>  		goto unlock_mutex;
>  	}
> +
>  	folio_unlock(folio);
>
>  	if (folio_test_large(folio)) {
> -		const int new_order = min_order_for_split(folio);
> +		const int new_order;
>  		int err;
>
> +		folio_lock(folio);
> +		new_order = min_order_for_split(folio);
> +		folio_unlock(folio);
> +
>  		/*
>  		 * The flag must be set after the refcount is bumped
>  		 * otherwise it may race with THP split.
> @@ -2796,8 +2801,11 @@ static int soft_offline_in_use_page(struct page *page)
>  	};
>
>  	if (!huge && folio_test_large(folio)) {
> -		const int new_order = min_order_for_split(folio);
> +		const int new_order;
>
> +		folio_lock(folio);
> +		new_order = min_order_for_split(folio);
> +		folio_unlock(folio);
>  		/*
>  		 * If new_order (target split order) is not 0, do not split the
>  		 * folio at all to retain the still accessible large folio.
> --
> 2.25.1
>

--
Cheers, Lorenzo

