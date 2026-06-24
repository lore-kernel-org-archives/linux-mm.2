Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D683BCDB47C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 10:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871B86B0088; Wed, 24 Jun 2026 06:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823056B008A; Wed, 24 Jun 2026 06:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738C96B008C; Wed, 24 Jun 2026 06:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 405336B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:13:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFF671C1E39
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:13:27 +0000 (UTC)
X-FDA: 84914394054.03.98797CA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id C544540003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:13:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Z3rd5C4c;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782296006;
	b=GjFG1Ff1X+9XOKvIlYu4+sNT46/+SB9mDDjGtSYEGIcOvp7nW4Garxjqht+UM2nSo9uv/g
	OLH9RvtE3ooD7RKljgk0Ngg7iVKob9/MKsWu/N4XXN78SYONBnVJroYrdZgbyAoV4crrct
	HvvuxaROgJXqHBI1jDoGnrFrSqg0M7o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782296006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wlEPLoJQOQed+1gDV14mOLpfO+e0bUjLDpVN/NLv8WE=;
	b=ZV/JyQIqXOMC6GIlGJ2XyoEvRBBOyNzigFij+BApdNjQvXBM+FjTZNRqxsVM5RnRb6q/7c
	PCTzZa66JZJiQk7EW7tX1aMJEXb+GjSyiZr1SUeG2Fhi42ZRFVRxSJNwdp7mnklIGPoGns
	bt6S6Wt82NMHxU8v/D0uc4QnAR3gLzc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Z3rd5C4c;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1BCC263D;
	Wed, 24 Jun 2026 03:13:19 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACA203F62B;
	Wed, 24 Jun 2026 03:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782296004; bh=uDGgmQDxNB5JYlaT2W9AeNfXuRBseXPEq1ddL/s6olI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z3rd5C4ccsWlusx04iTq9HGAvhuHiSLcLfmO5Bt2mHkpKF1D2QV8IgBUSUPxMUdNy
	 wFImr9R3SZPkZUe3+FTodWcm2mIUfbmY+0AHWx0cFbzgsisTTbsI7aeHbH/EsTwmy2
	 wMSachgYq0ul5YZJB7FD1hkHS3nTHbtoFVxLdEo8=
Date: Wed, 24 Jun 2026 11:13:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>, ryabinin.a.a@gmail.com,
	akpm@linux-foundation.org, corbet@lwn.net, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, kaleshsingh@google.com,
	21cnbao@gmail.com, david@kernel.org, will@kernel.org
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
Message-ID: <ajutu4JC6KRo46dv@arm.com>
References: <20260612044425.763060-1-dev.jain@arm.com>
 <b1502a60-09a1-4699-886b-93d041de7023@kernel.org>
 <ajVByfkLbetzA8bB@arm.com>
 <2208123f-8a51-483b-aa93-c35d8d053d25@kernel.org>
 <ajltLd6FQg1aMge_@arm.com>
 <78d97371-b477-4230-8690-ac870a7bab3b@arm.com>
 <ajq-Ukmd9NBruhr5@arm.com>
 <f5927785-d5d3-4e64-bbac-220d40718a1f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5927785-d5d3-4e64-bbac-220d40718a1f@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C544540003
X-Stat-Signature: 6ws597yrrokag5q9rxk9rggnmyfqt7uq
X-HE-Tag: 1782296005-511425
X-HE-Meta: U2FsdGVkX1/A9AL2px11xk6Ot9wpymY5QEH1eo6IvsME/2fMTv00t7aw+svaUmxCwZup5UX923u/UojrElSucunhc1my13uDQy+nGXNjLJPW0pXc/BBCbtYvDyoJt3sV4Ov7nj4DDhzQ6NiEbz2ObZkkXCKg7sJW01U74hgrjVAY7m8Qg3O6uIyh8DhmAjQOp2hGCSgF971hyzXggj8B5R3AdsnBMeQs4iowZqxfT/tCFI5sAlVLQmIAXL3w9mUwHDQFPEZCqfVjMQ+O5M/f/Z/xHRSPXISQTjN0dUR+1J05cPVMjyclEgV+FpCjcyAEHHRuFetsrlISi0dLbBO1xPRd4vAUGPl5dxJ8GsaKdx6WpQFYqszN1/5nrLWA03BtqH7DmRHHprdO6//L3sJuzuvT8mhY2+u6CgnSxH9Cr6F+vIqZyPF7vQDb12XmpDg4q0Zp/Zio14rkIvfJ0JKFDEf8g9zIGLwYaoGCDVc6U32jHf9nMu1kE0zazsLVKTpWcJmyZzBhBYRqydgihGSkpspkhCil9JN5fb5jVWYMFnh9NhpqY8mQo67DbyAUxf06Mgr8+7QHtrU4NuYBM/pEua4evTf78yQyMloGduF9UjZUWqbVkLO8psx8eLTdCQ90dxlpRg8vWHmfQfTm5VWw6wrZqIL9wkFHWg53xFwHoLl8/g59VPr5lONJWqlELeXVVnelWreVPkQDQFTgx3eaMYavPJV/t0LMizS1ita598SkeEzgerIePHxLGQN31ae9YAR2pHfZKfYbN13mgrwN0Q1wlPNhRl8ZCfFxhvZfHzF2Gr/9m6lRH/EjFlZDZyOOq1bpNz+SsICEhOkkn259VvFfspHx8qxzWQRsAMCudZV+oSh3rl5JmWKwCgOUaB+fp4y3qxqHZ6K252Nd6MnPbHNrs/JWY9tChErLNiyzuE8Fk7CXSTXszpQ88pf5av0J/HYYMxKieZr0TwBhRBt
 +BRVTsEe
 gaVlANpjfx+GvngpMadz1P9DfpLnaOiSLcBC5iFL6aWlnQmDuYJm37AxZ+RMDky3Kg1AQDVMHL3FqmvZ2nEx6WsUr2QPJe9zdp1E86+pJWxR2mwGAlmszJUZ+VmGxT0wpjXQHkDEpaIBHduB2K30iWGRxmxqpnfuBr0hjwJNnH97WnDfHHlk2/vkyc/dfUi8BVtf1E4bI2oagvnGWvoK61HDznHk5DA/kM7Ck0gp+vF2cvWjdbScprQWmUNj3C+qQKdU4vp6YXrSXThkVYgPjpMwp2XRGxR7AsYcMUw8mdUYr+sXV/BWxR8O/t8mkDSkMeaoHskNM3w/62f3iX4fKIuU8NVSDFAZgB+mU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 09:44:49AM +0530, Dev Jain wrote:
> Anyhow someone needs to first test the current patchset to get some
> numbers, we would be wasting time on this if no one gets an improvement.

I agree. Something like iperf3 would be interesting, lots of skb
allocations.

-- 
Catalin

