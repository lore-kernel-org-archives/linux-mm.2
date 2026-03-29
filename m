Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A0510D1495
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 03:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C61266B008C; Sat, 28 Mar 2026 23:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38A46B0095; Sat, 28 Mar 2026 23:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75036B0096; Sat, 28 Mar 2026 23:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A6B4A6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 23:20:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC5811A035A
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 03:20:58 +0000 (UTC)
X-FDA: 84597648996.08.871D175
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5395714000E
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 03:20:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOrl0YH9;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774754457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJjUinnPFfXol1bAHXd8odIBgjAlNsUj5csXY9CXKAk=;
	b=MQXNiGaSJBJ58pNQSj6Tu4jyo7pL8qJZe/dUxbErg1dSj3N7qngnkZHogmha+fuakBblk7
	6oa0Mdw7IHUVtzGtDOIGWCPkkLU8Yiq285umIurxP/bAEC2xlNAOM9wH6mTBqChRnhI4w2
	ywjOotj+WlA9fBpgDo2Js8i4yqfX8B8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774754457; a=rsa-sha256;
	cv=none;
	b=s2lIDF4vsKeJ27jTwcpFTjO2Rr4i5gTvPoujuFCAKlPNPsNFP8JR7aER6/bWk7HFVMwaA4
	D+/aqCympeINWT+EpPw4QW51Vzlbf6Niruh1reNMzbH1d7IV5LhXdzpOxauTouEES95yBA
	91ge4pALogZiFZPWQr3nYven3WKbt4w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOrl0YH9;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 39B5E40946;
	Sun, 29 Mar 2026 03:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0284C116C6;
	Sun, 29 Mar 2026 03:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774754456;
	bh=piAqIhYDF/cuSRB4j6MpAtXLnQgECdf1z6Mkz3i4rhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOrl0YH99aD5bDVnGy2oGyWYyNFxNwvun/2UQfVFTfNc3d9GiKPzYJWdQv8B0wIHC
	 uyj82oMyrNQumci0xX/dDa2J25cj94XJw0yfr9qlaKRqwzNgR8uz0fU7xcFEIF6mzs
	 UyUmGwkmLMkjUI1GXi/uEHxFMDdI8fyoH+6LOM/lQ6+jeuWu4GZskXYb5z2xpQYmzF
	 lPeUPkFU9ZoCSDzi0h4j9VRHfQdXUy3GTN8kB5qDipStfEjxBjM6e2g+XCMRp7S6l4
	 wz81eZ/JNH57rzZ5onH/z3jbSjIiSfKA/DMjUsQP6GNLF2HCTCgcKKqglYF3AEwtVR
	 hQ6AwOW0SY1nw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Sat, 28 Mar 2026 20:20:54 -0700
Message-ID: <20260329032054.2443-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328184319.13176-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ashhx8nruek5dbzbna1eq5dfaei7bj1s
X-Rspamd-Queue-Id: 5395714000E
X-Rspam-User: 
X-HE-Tag: 1774754457-456703
X-HE-Meta: U2FsdGVkX19XtWR46Q2j43YV9kcrU19Aa34/0HFETdKBQe1Ucue0rWwZpyyhrS9KVLpWGNsUlHjwT10axWba6ayXnrZMOnl2p2+Dax7/UMfegYhM7GS5NgeNLZjd4nBpFZKhfhdUOj6ekVHM8hQ6g8nI02gAnMQzN72oMDk5rg1csmU1W5egQqjmhRe7dCgI3nwmwcy+OuGzegiNwXjlfnXAXpOORoRFMzTGZeOIxO+IskM1sRrqQpHA0Gb7y3mqexkZxX/kLrqS0J7M4miAGhPhHn+ZbYEdzQnMSeun2PrC0oERZBqVZ4OpzE3ssNRfbfVdgUceDwY4ODrOt+YhMjFjffztdzEM3zDl/kKlgvicJgLprjdXh5aZdK9rs7VBIhJw3xWXoHys9ovwl/LC8MKbuik8jirWL85+YuNRdFVcVSpbl/siMwOrUeZbOmX7v6xQcDC8x2TvudwkzTFUh7YrHe1Fugomx40F/M8uI7lr5/6TUsI/+tUiOeGdqEuHqDOyfZWW22+zK+m6U/msQft7EWQ9QTGD8dGKNUWG3K4EbHusIVNBzjtaS1nr3ogjdorAxdTaCFD8607S3G9CKzthuiphf6jp9r5TOfdSuQ7rh6xDKrrC6hQwSsEb2JqSPV1ijISIKJ2zm0d4BxrKhN7C+swl/HNH4t7ISOU34Z7zKZVCeYPF35+Fx/enJEKIvfzJSY73W52EVq22WWwZM1ngBlRL7iXVG5Lr/aGiZuPf96I4poFFimirLAp0rYyT64BPq51EtjwvIiHICY95kiGpevUAaU2fQ50VsVOyw0+QCD0nQLsfnukUerBkNHGDvuefMSeI2vi8uJYk770ZPmzEL6BPKWzVmMI6X2dlqjtNjy9f/7ohb0gkmVuP7w3fzry/Icw6Kxq6kFaa9JjSb31XzQxrJqtuK6sMzusuId8mLujZOiuJZWduEM48ttZhfg0oiIr4tJW5pcA1V+o
 ulg/jbi6
 PWPS8uRjkfPHrRNVifNi9Ny8DJ2sHMOo3SexP39H1f1vPAzEXHNtdKn+GiqGYoQle1JnwwZ5gkZFUyNruaYK/hvBiDZ1VflKr35mYFwwjTQVP4pb4XWRbGIfb7piapL5Fxmf23viPQaK8KYOGueLrjZsd4yDtHT74GA5rRuhLV9JeRgw1Rszf8TdpVvc1IQ5NiNJR3UR+G70PDqaBkFfJkS1JGWWGSBtfrhDfYQxyct/fx748UsUVczldLTTaNpmiQV14n7fYGpM1C7EbwZ1m9lLqsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 02:43:19 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> > Liew, I suggeted two options before.  But you are skipping providing your
> > opinion to those, and adding yet more options.  That makes me difficult to
> > follow the conversation.  Could you please answer to my suggestions and make a
> > consensus about those, first?
> 
> Apologize if my previous email was unclear. Let me directly address your
> two suggestion.
> 
> 1. DAMON_SYSFS Type [1]:
>    I fully agree with this. Centralizing the validation in
>    damon_commit_ctx() is the right approach to avoid "whack-a-mole"
>    problem. This is exactly what I am proposing.

Thank you for clarifying this.  Thanks to that I can show where you are coming
from.  You are misunderstanding what I'm suggesting.  I should have explained
it in more detail.  With this option, I'm not suggesting to update
damon_copmmit_ctx() but the callers, in a way similar to that for DAMON_SYSFS.

> 
> 2. Adding a simple check on existing validation logic (in callers?) [2]:
>    While this is simpler to implement, I prefer avoiding it for the
>    "whack-a-mole".

I suggested option 1 as a way to avoid "whack-a-mole".  I didn't suggest
updting damon_commit_ctx() as the way.

But, the given problem is clear and local.  Validation of addr_unit in
DAMON_RECLAIM and DAMON_LRU_SORT.  There is no problem in DAMON_SYSFS.  So I'd
prefer simpler appraoch on local callers that having problem.

In future, we can make centuralized appraoch, in a way somewhat similar to what
DAMON_SYSFS is doing.  But that's somewhat we can think in future.  For a given
problem, let's fix it first.

> 
> So, to clarify, I choose your first option (centralized check), and I
> believe my "Option 2" is the simple way to implement it.
> 
> Does ths align with your expectation? If so, I will proceed with this
> approach.

So, no, I think we were misunderstanding each other, and I think I understand
you more now, thanks to your clarification.  Also, please don't hesitate at
asking more questions to me if any of my suggestion is unclear.

In short, for this given specific issue, I'd prefer the option 2.  Is this
clear?


Thanks,
SJ

[...]

