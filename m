Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA13C61DBD
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 03:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96CE96B008C; Wed, 26 Aug 2026 23:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DA96B0092; Wed, 26 Aug 2026 23:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80D3B6B0095; Wed, 26 Aug 2026 23:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E7CA6B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:32:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B673F1A018A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:32:22 +0000 (UTC)
X-FDA: 85145626524.10.C513401
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E8F45C0002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:32:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VSM0sYi8;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787801541;
	b=J/jf6r/kEhpRwHlBi2QvTxxoBw0mSfdZbulw7B1mDxO+o6l9v7NDwTSQ+dvg9KNlNxY9lL
	piaFwVE3StdW8gxpy8pHt3PDCjPo5hR9kBiCjdwWnR0whiyrkop5k3j/RN+LQxpEO7PKBR
	GK2wCXWBDmIkrgBjTeR8yieRGFJ58/Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VSM0sYi8;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787801541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWOHS8TyoHKRTLSUkAPNBR3Q6pJ9KdiACWk7PEG8wK8=;
	b=xNaCdTtFY1m2PQS9KvD0WkNqqnt1fKMxqWpRvxw35j+2PQ3oVX9I+zGsDGhsswiWgcEDSj
	SG18UkkOO1kh80tb2RvHwd3F7D7YNsCs6oVEgwPVQSxBY0C+WJ/wsjFcmr31e79GPWhxhG
	2NAD8kWKE0id4HK48kP26KYemP7e5gk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC0FE41AE2;
	Thu, 27 Aug 2026 03:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BB41F000E9;
	Thu, 27 Aug 2026 03:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787801539;
	bh=jWOHS8TyoHKRTLSUkAPNBR3Q6pJ9KdiACWk7PEG8wK8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VSM0sYi89j9wTZPXhMBkh+2yj/ZPg8EGm/LmhBtuDnlDDN+l5MhYPn5/hqK8QXJOq
	 MJZxD8aTPUDmGjsAlCbWggyZuD/gx6KKbsl3thtlrqCvynOVDhToKdZsCVpsQzxfbs
	 4adVCLvL5h0lyuEf9gg0mGy0aaUIzNV9NXvfInNM=
Date: Wed, 26 Aug 2026 20:32:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chengfeng Ye <nicoyip.dev@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Hugh Dickins <hughd@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/ksm: mark migration stores with WRITE_ONCE()
Message-Id: <20260826203218.a8690c6bdeb7504ee7fd9ad5@linux-foundation.org>
In-Reply-To: <20260824112433.191301-1-nicoyip.dev@gmail.com>
References: <20260824112433.191301-1-nicoyip.dev@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E8F45C0002
X-Stat-Signature: eezq3pioyaxhipxgyiaxxgbnsgcia7n1
X-HE-Tag: 1787801540-25096
X-HE-Meta: U2FsdGVkX18TkyCq9nQX0tc8Jdv1D4iJtl6L/FFf/DR7DRkukPuJMmMwEjoVnPWxJfOgrMfVqt1MlWizTDJSaOGptzg9xLK4AOFEn/X4E3Uu83sGHUU74s1tbPrIARw3mmNL4fsiG1c8JBiF9Fcja09Ye8udWrJ0D7VSQSE8EbNpncY11bSSrBA6nzPUHr5++vHqJR0CT5LxhTajLC/Zxpepv4qAHAmJ9hOJa99KUwhWVlS4tfURODiTM3MsI90SvU7/5rNfJp6zO1lQsCZPmQZl9zK0IGGvZzTCiBeR1u1qu7vOeXDNpOXOA2Ncwt9HvylHtkh33h/B7r7dNbx/rhe7EE1f9inAsqkpZ1cGzyhAD7fuS5ZuLjkLfDBgiWpGL07rN6oYgbX3neofp6WceKQ9NJlw7wU5+J2HuAs1DvqmGtnd+nY3IfyzEARRhaL4ywTiHObgO4R3jqRKdHZhwBqJlhGBGPBeRKWbPIMDUKxAEr/68gUjSceOguPJ43TILBljeqVhkmMtwahdr0sgA19npkjATs9IsN1VrNXAe9JvzdfsqM2Ar5Wdt7t25Z1gMg6OqoOlVvAaTjSHELowvHLzOH6x6KfcgJ9Vw1+fdnNRB4VTUE6Smm6rqaQvxvu8OSaIMSBDAALnONX6jJecxbT51ufeWLEZzYkcKJQ1k8AZ7ZhsyqrK+W6lWzaa/N4t6hedKjHVW2iL4gEihITJZb0leJN6PzetbzQj+Hh3xG1V9IYEqKPycmMXnFtqQ+D8AcTZMBt1QZLVim2MhF6iSWygCtfcfPVnBOfVJorUXGQb0Zr88gVVBfP1oA3wudMVleOdv68PrXP+4mVPIHxPjBkEai/qnEg3wt2jgvwJv2xBew57kfg8KkCy+HYrFQDtm39snI+hvsQ4AIfN1rvlKiWSE6G8igH8VltOyA0JDhEterHLbxQYcJPK6PSu4ovN1dm1XajyO+MlgXHswu8
 TPm2YwF+
 lzxO1Og9ZybA+wAXxah/ph63p2J2tOUu3L4Nj0Ncv7VXLQ2TaOXZqEJFXrp6vsr2A2i66WFgMCLH9RHJ8RaG0eFvF9hs6Ajx9uoJjZHHt1cQC5/ihxcL6De92VLCTSuuhM0VnSCkrsqrxSVydHYNRJa/lnv+A0hMRf4Wn86y6lT202KM4KsVOl//BMEIaxtNnfjXn1iBnLcXcqSSdYZdGY22fnnSBAM66Kq98PnhpM84WTzUWWr6Jg+JVUkQw2h13Oe8JrcdD+aXjlx7gOVHdLEhF7O+ML5ZCsv8O8KSfBXN7MN5exQHOZofI81ODNpfR8cDSsTnp9kzbomzuJISRmlybMNvKfvQ/1mS8r4ZnKOTIAAFx72lPRuzbILU3zvn0k7KDtk1Nhm0jw1jJQ9zmSraDV9BLnHdODo0eZPzFAQoGmYjkpufsFe0s5x04P853KjdrvcoCy1vrVD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Aug 2026 19:24:33 +0800 Chengfeng Ye <nicoyip.dev@gmail.com> wrote:

> ksm_get_folio() deliberately samples stable_node->kpfn and
> folio->mapping without taking the folio lock because the KSM folio may be
> migrated concurrently.  folio_migrate_ksm() updates the same state using
> plain assignments.
> 
> The reader can load the old kpfn, then the migrator can store the new kpfn,
> execute smp_wmb(), and clear the old folio's mapping before the reader
> checks that mapping.  Thus the initial kpfn load can overlap its update and
> the subsequent mapping load can overlap the clear, with no common lock.
> This leaves marked READ_ONCE() accesses racing with plain stores.
> 
> The kernel reported:
> 
>   BUG: KCSAN: data-race in folio_migrate_ksm / ksm_get_folio
>
> ...
>
> Use WRITE_ONCE() for both stores to pair them with the existing lockless
> reads.  This preserves the existing smp_wmb()/smp_rmb() migration protocol
> and control flow while preventing compiler transformations of the shared
> accesses.
> 

As usual, AI review looked at the surrounding code and went
nuts.  Please check?

	https://sashiko.dev/#/patchset/20260824112433.191301-1-nicoyip.dev@gmail.com

I don't think any of these are truly pertinent to your fix (which I shall
apply), but maybe while you're in there and all fired up ;)

Thanks!

