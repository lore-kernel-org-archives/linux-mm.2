Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB631C9EC9A
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 16:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E16C6B0005; Mon, 12 Jan 2026 11:03:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E936B0088; Mon, 12 Jan 2026 11:03:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07B396B00A7; Mon, 12 Jan 2026 11:03:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EA86D6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:03:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDBD68C182
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:03:26 +0000 (UTC)
X-FDA: 84323781612.02.55B41C3
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf30.hostedemail.com (Postfix) with ESMTP id 006B480012
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:03:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=bu1YsJAy;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="9WFRO/Jf";
	spf=pass (imf30.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768233805; a=rsa-sha256;
	cv=none;
	b=uCeXTow1NxHwPL+r0h9rdiT0i4B0xUdL38vY1gKaqBhPLz7ywB384CtDpFY/xNKPwOl14n
	6SUSdmxuC8Oe9cr/LT2N0OWbqgcKYatXkvHb5vdkCSiXs5BTYy0F+s/YsHM7YP/+UgDoP8
	vcsADWd76zyUqk4AMIR5GNHYYLMty+U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=bu1YsJAy;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="9WFRO/Jf";
	spf=pass (imf30.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768233805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=you+Prysa3+e+CjaYB+FaeigBAe5mJGLl/kBRCHGxe4=;
	b=kMCkHMCzbzww9/nh2n2NIo5z4bZr7mXIw+BF/UBUMIzGzk+8usKsp0skwJJfAPABaowICg
	Um2wn4gojTo6nQCzz+qFTo5Do2Kc4PkWUPHm1i1Tl/K2MR5lJn6i/MG2e48R83yXTZ66eV
	1Un+N4WX9v54mIFF5h4Y8URu1KOl6vk=
Date: Mon, 12 Jan 2026 17:03:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1768233802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=you+Prysa3+e+CjaYB+FaeigBAe5mJGLl/kBRCHGxe4=;
	b=bu1YsJAyHq5GsJ+D43WKjuvJejHEqCmG/Q6DNilgYOrnpnfZmXCDkMvM9LWKBaGFjoP86n
	bjtbneiqjEkUZHjFoyE/maii+z8fYRjV6alYjvVu9gtGUWzj3uKLgyzjdHsBPsUc1SulbM
	ZXfb0gqX0YtXwnLDLVSvOUO5qK6BR6ggDi1xFA6cDXrqn6Ttwj3X47ciccusS723ECQ5az
	0qWHko+jTSHXdz03dSqPxjbtb5GB3k4Hn8OzLynOFbUXOLoCne4Dp/BZ88cCCrL5bLWxBI
	Vcr0bPWNqdT8m3M+fHIDagcsxYf5pcFCI2SrQNtMuv8st4rn7iXtrrV8SdBT0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1768233802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=you+Prysa3+e+CjaYB+FaeigBAe5mJGLl/kBRCHGxe4=;
	b=9WFRO/Jfmaus/17npdGjbfulZllUah41yftAdCLefQ7UwtrMYu+fHVUzlDUlfq2FvsVYVf
	LCB3AiNfHkvkGmCA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: add basic double free check
Message-ID: <20260112160321.kCh3NHWV@linutronix.de>
References: <20251220002737.84100-1-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251220002737.84100-1-dennis@kernel.org>
X-Stat-Signature: u8itso16c6t9g7yc9q4byzqt5ex47uon
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 006B480012
X-Rspam-User: 
X-HE-Tag: 1768233804-386
X-HE-Meta: U2FsdGVkX1/Ic4kIgNzwGaxIOm6yG6/eYkGwdM8P/naNsEtJPJkv30STWUmt//aV1+kSF4W7As0IvEThM/PJjxHNzSo2xs4kglR6MyTnRofj9tgSUF2YUsAJ8Nqu9tLR8MH4pfTQcs6woXP2EKPHZwi4vYH5fF/rq5wmNSdajUIWW0DYwjLbLmglE4+S8VgWhnKcgXMVouMSQ0ysW/bk98aMtmWVAx1HR6hd3YINAUK3hD/I1WhNlpYKDEHGUOA0gwtC3zI0J9lq3RAHzdSURYRAIk6wxJyXiKuu9+Vrl6lKZBfod+KR8fqwktonsMJkD9no3kUVAfu3GBb3VY5EVxwJxNzcyevfiNKCGBMpI0Vz857S3vX55XysfV2LLlOl1Ux6JWN2gazuMp2ndHJ9KAvR62lVd2Oc8uBBXg0F/jBSdXGY4R+/Tzar1MI5DstovkvkXOkk1Ur5tDYL0CqNg7qtVT3vvSNy65HB1e3sSMjK3UVYUAOF4p5X1YcX8CTZq7p7m3/2eBLQKIKk7kPW2wRhjUfbZ3DkAuOSQUcqNEFvi9V5CygXGHpfstzt79pcnNnxii81Fy5clA2TTFqnagWBuS+RQ/qs84CuyOl+31p62TAO/zOIO7EtVUBGHYeSXMpTjbxzpmVeZCCKkpQleoizn4PKivnXEQns1ILmF+PsSRcHSM62IeLMHAtJNNmziM5MNZC2VeeojL1oRtl+khIgNXXva1i314yWWXhCWLzn0ewpJV3lxlVvfudQ3y7z/CVgAfmRwXq2V4d+aaDNrpMJ8XK9uuv9nI4FzE17njZ5/CD/l7z84dfkjoRr6wOnm7MnJbL5UMpIu25IN2PgK4TibBzwc4LHskvqMkpJAlvlQhGbLLHbo9FM1w0J54YydOHGtU82qxMUzWdBWSp+YqDz6myiHZNCcdfX5vyPbg9G5kOrin4uMFMNlatHY2my7pxpKbkChV9FCqbc3fr
 SB7g4vmG
 6wQ+SdgCq079vzNLoPHo6GhvbUW0EHnmyhuA0vUdPoa53D78Qo3R5vEcrmOFwmkDzdBalpe0NTkRvKKw1hBOY//GVRlR8xGkl9sy89rSY+HYqmcG+9z5BBJYIxMBz7dydipJATti0YwqFQaL4HG7eZUJK7Ur5NLsRVD/Yek5s5wWtDosr5FLt7c8Dctg0e/C38sO7yBqvkiqxAC7gqEURflL+lQB33Cj/+t/Ld4Dww9R5Cpw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-19 16:27:37 [-0800], Dennis Zhou wrote:
> This adds a basic double free check by validating the first bit of the
> allocation in alloc_map and bound_map are set. If the alloc_map bit is
> not set, then this means the area is currently unallocated. If the
> bound_map bit is not set, then we are not freeing from the beginning of
> the allocation.
> 
> This is a respin of [1] adding the requested changes from me and
> Christoph.

Thank you.

> [1] https://lore.kernel.org/linux-mm/20250904143514.Yk6Ap-jy@linutronix.de/
> 

Sebastian

