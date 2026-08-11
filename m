Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 964CDC5CFD9
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 10:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6D36B008A; Tue, 11 Aug 2026 06:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9587F6B008C; Tue, 11 Aug 2026 06:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86DD26B009B; Tue, 11 Aug 2026 06:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60CEE6B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:27:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E6F0F1C1024
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:27:13 +0000 (UTC)
X-FDA: 85088611146.28.6CBF212
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3A8F580010
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:27:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oaG9JOuX;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786444032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kXXh8PYIfsaZmMaidvXBBrRKRtqDnrYuD5GOCyydIk=;
	b=AxbUdjf+oPplhqTvZVSWgOSkmQPwzIKB4o2RBMVFbpGKmTdSF/f13WxubpDHM373aCJ7c4
	HKOTih5EIjwNE3UwlhpbmE8ScbQCNB7cPhg9/A+83dV8wMoDv20+pJLo1Uug2neeLI15cs
	qgIA4N+PA15q1tq0C0caazbmvHf3kQI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786444032;
	b=hJGCJ4nF9cYhFGbvD9G8ncLJ5JPDy3dnCElSiIXfu6Q2WAAqMyAXGzDjhrQufRyc9Nd4AQ
	Q49X14lSOrgGAIqF/OwMRqWSaILbE7AIso151xvjlYF/rsAM0SGO2CzQHXtD+8GbQ7Cz2y
	wrDpooz0BQvE26ToWCE+pijoHEFBnvU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oaG9JOuX;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76DEF40BEB;
	Tue, 11 Aug 2026 10:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C69E1F000E9;
	Tue, 11 Aug 2026 10:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786444031;
	bh=1kXXh8PYIfsaZmMaidvXBBrRKRtqDnrYuD5GOCyydIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oaG9JOuX/0vcBfIckuFTx0W15YPUcXCkJnkcQjMIbr0AOcvnRtL0pLoDIAript9S5
	 fvsQp8kNlISsYrcm5UCUZ4SUOLxshJUgfj26E8vKd2lAx74cQDzRVPevMviHGIMdVv
	 EgJjlP6Wz0Ayg7/ts/UeqsCKHQESAC+awlHAHhcpRnWTStKseu8NMxYTkE8R/VTz4v
	 GakfJG9VtthV8QjjqYYAeOBe2uBY3IDnsjz/PmL1jmZkHj3Kr9VTBdMU6Qay7ioC2Q
	 G9+2+aCFeO8ej69JItG0DCUlPp/k2q9njH+oEzPqW42l3pEdl6LV6pkscYGwajURgk
	 JocxcWXRiS5GQ==
Date: Tue, 11 Aug 2026 13:27:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] kho: support preserving high-order non-compound
 pages
Message-ID: <anr4-F-e5_vHEar8@kernel.org>
References: <20260803113944.3694290-1-praan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803113944.3694290-1-praan@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3A8F580010
X-Stat-Signature: 8857mircu7abgmgof6hm3wwirje3eqjj
X-Rspam-User: 
X-HE-Tag: 1786444032-76943
X-HE-Meta: U2FsdGVkX189AOk8PQWOcW7unBcC4QUNgr8GK17sZoO1plNonYe11VXz7hT0QzthpxBCzsuSnmoA3XXAKWm7jO0v5IlHtAHSgGE4jJn4GT28msx9pQcHR39p57+2wA3j9/MSDEP+9iFAeuPB91Hqz1i73Bw2XZOFbwD92wTzp+WBSFlSmAryKNq+WAzJ0PjLDllxBnhQVIqwp5rHV1UH1jEdLWYk992O542j2XWgzc7goLN2z2Fl/xZfKt0p6AjcMVvlx19qXrnI0OGejnTItH5vjmhnNaaUAED+PmQr2KAJ5iLLMVf/OJiqDC7BG8I5Dm031PZRvxUNxRT37npy1Cw3IMplf/9fawgRPr1+unazkFbMMSG/9NvFZ43zXXnkQfbBMBHsFxUuxoVjD43WxjXGX3ze1WWuUTYT5JRzZDp5YNo0dPU3IH31H7ypX3UQ95pqESJBV0RXi1/hf1aC8agoHOU/jdDvSy4IKYeJn0bVu8EcdDDYMXNEyJ7COPeqGgU4GYY7Wuld3cuKJ99o03657l0kdFZueoUFXMiS0N3bmjxTP6wRYKdZNh842FJDc2qrRAWLLaKLj2pu0a3SN3ZkC/QdKI1zNnVAYYyYHx7F16GvR8GXWvk9Js3+eA8Up3SAyMyNSKxld4w+zr1shEq6EF7nec42icST1kCiKNcVEmwErxx7x3gesFcEIHo3WjZcZekSopeixpwpW//WOvqYjijQJ8XZ23ctrpULZTGda03YVCJLI69SSnzqLqjXg3I1SxvbYD3Z6HTiMmdpPaMTCA3PlH43vhPyzdr+YCxFW9+nqiexui/Ii9V8l8i8c7Sb6Kl+t+steYUQZi3Q4eZtZMzQlt39jbL9itN6nuZ+xsuN6lrP5w4xfgU4YCGHrP5lCVAqyFy93SwY1o5+Rmv60h8b+YQWykelhUvWM0JyNbRObGwvpdmY0zh5KaLUEm57JvcchWZ1VWtylPy
 H1+uBnnK
 yXd4BTUUBr9mFCs9hDYXPkldBbpbuVm8hJw7fL+QJhrRDOnOQjwKSWxoSBZIq7nmN/Perc0aBsT9mKwTfMxpPoVX7RB9aMl8ZBWgD0MbpZNkGmgctQVOHqYEfK257ZDGypixceyxx5B7hDroIlwppP/2SVcIosAYvDokXZ/9Hr5RLvqRZsEkIpqMb/pXxusf4XYimWTUc6GoWe+WSBnL1Y7LTQVEbu8/pJ3ez8Otvy4oug/QQan4Kd1fm9B17qf9La2C0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pranjal,

On Mon, Aug 03, 2026 at 11:39:41AM +0000, Pranjal Shrivastava wrote:
> Introduction
> ============
> This series is required for the ongoing effort to preserve DMA allocations
> across KHO [1]. It addresses a fundamental mismatch between the current KHO
> restoration logic and the physical reality of high-order buddy allocations.

I skimmed through the patches, they look fine to me before the in-depth
review :)

But we are really close to the merge window, so we'll anyway need to
reiterate after v7.3-rc1.
 
> The Problem
> ===========
> The current KHO restore implementation treats all multi-page blocks as
> split pages during restoration. Specifically, kho_restore_pages()
> initializes every 4KB sub-page with a refcount of 1.
> 
> However, many kernel subsystems, most notably the DMA allocator (via
> dma_alloc_coherent), frequently return high-order non-compound pages.
> In this state, only the head page carries a refcount of 1, while
> all tail pages have a refcount of 0.

This hints that these patches could be a part of the DMA preservation
series, unless you expect other users of the new API.

Generally, we don't merge new APIs without the users and if DMA
preservation is the only user, it's better to fold these two patches there.

-- 
Sincerely yours,
Mike.

