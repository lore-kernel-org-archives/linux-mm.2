Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58F6FCD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80B516B0005; Thu,  4 Jun 2026 10:52:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BBDA6B0088; Thu,  4 Jun 2026 10:52:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1A56B008A; Thu,  4 Jun 2026 10:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58DEE6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:52:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1DD740130
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:52:09 +0000 (UTC)
X-FDA: 84842520378.26.A974D7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A86B114001F
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:52:00 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780584720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1mkL9UUB9HEOZh19mh72msfL8GRHgkp0ndyBf0CZDY=;
	b=eA7QsaG3kmFjjpb2ENV9C6pUT7ZvY2sS18Zse+O8fT46qpp6ORIzCuHUBKH3YJ0d4DtPKR
	9MUfQ5q1Jz6+Z8MHGCw5UrwRSgLqeBLyXZcd2DnGVgOaYmUNA4KacUbXf2/mAvK3aXZopy
	6W7Nvh0bXoFQ1aAFE0mn+C4yJwidfhg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780584720;
	b=ZHmVRCncTjvJtNf6f4lXKP9j7pZ2aRDH7ahDoNmXWsDkdVfedQWnnvVa5d6Xjcf09+0U4U
	rNFiQA/kBAKgZ9S4V7Y+I7RyVWipF+dqagyB2hlF9lTCX7UdBHN8NnT3T7bpSvC3Ntr7B4
	/eFKDu4C5clXA/+uskgUSqLtZou1vHI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F7/U626L";
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C550940AF1;
	Thu,  4 Jun 2026 14:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF85B1F00893;
	Thu,  4 Jun 2026 14:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780584719;
	bh=Q1mkL9UUB9HEOZh19mh72msfL8GRHgkp0ndyBf0CZDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F7/U626LxyQ16yuoPx6eY8++Sefv01TALOSO+kTk5eMLpBEsTGmBj14JsTBV2aOJO
	 HTDepSCZbgeUCbDKQ/L48iQEjVMsbkUmr8FHRYsE6Zy3+7frhl+QkrzXAW568ZtlWw
	 USnozrHRRmVEzLWbjm9vdyXAinwaEbtZbqWbw8UbNaMe4Gen095/d4IAykIUrT6W0M
	 aUi4fEjbpgZm7tgB5RUZ8zGaoz9cuIA3cscf0+Qk72225aQ37XWBGI9sZwbQYdLxpT
	 p0obyacP9BNelILGkVGP5+bmu7ar88Vt8g1jDrNWjVawEJMgOFE7Mgv4clHtmfCKYN
	 RsB7C7+rez6sQ==
Date: Thu, 4 Jun 2026 16:51:53 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>, Karsten Desler <kdesler@soohrt.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] arch,x86: Skip setting align_offset for hugetlb mappings
Message-ID: <aiGRCdKXdusBu2tU@localhost.localdomain>
References: <20260601125015.216110-1-osalvador@suse.de>
 <53b599ef-0f16-44d9-bfda-a5a751649193@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53b599ef-0f16-44d9-bfda-a5a751649193@intel.com>
X-HE-Tag: 1780584720-319984
X-HE-Meta: U2FsdGVkX19N0B7FJWAZsTI5G0n39pmEq0PDhPwCHDkR8WhTQXqfbOOXHQaD8FPVtPxKSnjpwA4eVQ+nRPamUH+3Spoo1NYX4s9X6r7USvCrbY+4nDCy2Kfo9m97DUPYli1NxwNtFPolTtYzy6Rt4Ck2aD1Lt1qq5E39epCpuqP2dj52t+VGU5YJJWDgBAn/f5487fZkzitUpZRQOZIUv8SQO4F45wOB8b2aX6k0XGLrAx/vTmj+lSxAe8qGEr4eRAd5otFFd9dePPLN6VzJv02O45okESzs+da6xxgQktK67B62Iu4FS3ijHnT3yXLmuc8Lf7Vcc5mkiUoDiSQ+CqYYJov3OzYxaqmiB9DlAj0o2QLcKnCVWAD9ZkaPDw6IWRHXRs5FBKTLO5Xc3K5Z3xDWMwaXcsXY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 01:25:12PM -0700, Dave Hansen wrote:
> Oscar, even if the real fix involves a couple of patches, can we please
> see that, first? Then, we can go back and make an informed decision
> about hacks versus proper fixes.

Fix sits here [1].
It is quite straightforward, is arch-agnostic and I can confirm it fixes
the AMD regression.
It is part of a 8-patch series [2] (#1 is the fix and follow up are
cleanups).

I shall send it once I confirm that some more tests pass.

[1] https://github.com/leberus/linux/commit/fd6ac9d2af4d0acd27c6b2a840a6d9e6ad4bc4a6
[2] https://github.com/leberus/linux/ hugetlb-refactor-mask-align
 

-- 
Oscar Salvador
SUSE Labs

