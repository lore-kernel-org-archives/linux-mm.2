Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11DE8C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244F76B0098; Mon, 14 Sep 2026 03:48:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6246B0099; Mon, 14 Sep 2026 03:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10DAB6B009B; Mon, 14 Sep 2026 03:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E36E86B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:48:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2FCA716121A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:48:37 +0000 (UTC)
X-FDA: 85211590674.26.B1DD035
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8F43610000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:48:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QfXpuBAZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789372115;
	b=1m6kDn9s3v44AEFDfvUGzGSjX8PsUC27cNf1M3HdulqWvwwVFGEBjQ+/MYYcwR+kG79yJr
	2HiznhpQP/tNQ3LprmZmEoEcZqlCScu3GjmV+v0BD3aR+CQMuYwfazlDiYnXxTDesvAJIX
	qfFMYRwjcBlP1fsE1GXzfKlEipvy6EI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QfXpuBAZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789372115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mxlnDynYYTzpX8hgcfRULDUhaAGoaZuLLRZriqsKtRU=;
	b=G64ZWmOFOcJSrZfypaN8j5Kp2T9IPQFvOgZO6Y6p8gpVMNWKXmc99uFMq/VJZly/hdt6DY
	LLyv1kNzIShoZBfInJMoskuNVlUR9ao2s9g+/ExGyOFr6Wwf9l4DxkekUTL4mdLsJpLc4n
	4ufO/KHNlHtqLAa39sfCMwKfE1PusJ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D554601F9;
	Mon, 14 Sep 2026 07:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC0B1F00898;
	Mon, 14 Sep 2026 07:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789372114;
	bh=mxlnDynYYTzpX8hgcfRULDUhaAGoaZuLLRZriqsKtRU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=QfXpuBAZsOXfWUwnFNXpOGxWqTSDLO01wvC3N/7vd1dC5Gkv5rxpsOtkrm1v1qk5s
	 YHqpigsAv1/f1RUg9nkHwCoPA998l9XsxL/MKCNTb39E0XXM/uqpp94Ow0df3DIB1W
	 z289LU+/hLhnvCvJF6VcF4PnQCkhx47CxeNF8r5v+dddAXlSgk7p51PmTm5esbd/iM
	 /v8B066Wo4MFfdbYYdhyVAkVqcWRm0TP0bmoLME1E/FGklu/ZO3znAv1zeUOInFU7c
	 B+oPdfCDuqtuviwkhFX2E3MyhcvWqYa8MgoD1gGHOeSkW2iBnqeYU6E81/KVuv7Vor
	 3iWrdauituXWQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 07/11] mm/sparse-vmemmap: move vmemmap optimization
 helpers to a public header
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260911050228.58884-8-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
 <20260911050228.58884-8-songmuchun@bytedance.com>
Date: Mon, 14 Sep 2026 10:48:14 +0300
Message-Id: <178937209457.4188640.17073524319809876525.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8F43610000A
X-Stat-Signature: wdarh35adoojekw6wfodxtzutgae8uec
X-HE-Tag: 1789372115-837616
X-HE-Meta: U2FsdGVkX19A0GznUMrRnm8IXEb+x9t9BmTkpiAwPruIDiFS9+NeX1bCvub4KU5yf62X2BsqzIAqJ47Jc+UhKsMmnLRHAmBEGRxj4a7EalIUZMCU2pYghObI3gj9Mwl3H1RpWd5vz+f4GZtaijIn7UOHSRK0ePQjGdN0ONAGF+yLMwPCsPBpJMkyB9Ry8CQ440Jnp4tsgRteOkvXbj5pj6omhJOdtT4jzQYJZZQ+Do2MFwwk7GbugQAxUDx3etqV6n2SC/X+AWqJSnz3tBNyAUfrmR3D2ix8Ir+BYrQIdyaJrLO8jldl4Wff8ExFgXHGKbo/0008Ig0bn9Xp4jOamFiYISt1IoGfkft/xHXreV2aeaWxlyWB2B+Ju3fn9YpxA/LJSAXhFAfklW7PnAohAtz3dUXaxJZ+0QpVFJ/Rnqb0H89PPgq13DDLfiZHe82Q0YaV+C8qxnlQm53Hln/0tGv1h8zyZiJY0aZsZsovnAL2ibOxFycIadeA1mGTC+NKNOg40G4TUKpWO35dUMLI7myPTVARAJD+gLzhyGzMNCuZjpRN3mEDmZ6Ff6M68WCaN6xmrUON6U5ug0PnTVIM0FsEZC/lXEqJFfv/BdjSq/sKOw2HniZc1Pexnqhb6XnCZrsYlSS8Q5WnoGNzSpqxnUXeqOaqYje2NSiSM/1PeAT8mPKYKZAD3au08Q/rudEqSipkf2tvGVe6mtz3c1IexTh9oFBGxvquR+C4RNWYePEwrUeGFFSST2dtlc9uQXNcbt+U7hkYLpEwOAU9OQG2r/fwXUaiYDBJf/F9xXAgPEcyTSsphFN/uw8ENUEwH6VTS59ZOw1IEKJFOFOuSM1CshZe1Bx0NuB9bjc3I+cw3jx3XLdRgvHhhohI5Y8ZinUZkvbHt2ul9olQX5UrXNeN9/fUAz0PHKmdJ+25L5qi0R107dhHVkeSrkxlRCWITpWPxIiz6+GLqOm+jTBADVl
 9eoWWU+J
 7rb4Oe99wW6jh7Ypd9j7jNJE/7vvNmlL+4A+Tzea3/0mIe9Av49/UoxpLspV+SFAQzOMEDiJqN5BfLQvUOL80+8CrMiQXcMVpEU5GLz23JmB9GL1JWyfbvC+a82dzT3+9xSCp6HRGbQcCseUmPtSk35E8La7g1B6m4K//jvtfXkyRTLYDEz282HoI8IFFwNvCBvFIsVIylj6Al63Jd4Rf5rA2tjbuRagtzIkIdt76nIwWM0QQUXNKHiIMW97/WjTYe7nHCxEQ0iY7+6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 13:02:24 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> The vmemmap optimization helpers currently live in mm/sparse.h,
> which is an internal MM header. That works for MM code, but
> prevents powerpc from using the same interfaces without including a
> private header.
> 
> Move the declarations and inline helpers to
> include/linux/vmemmap-optimization.h. This is a preparatory change for
> powerpc, which has its own vmemmap optimization implementation and needs
> to use the common vmemmap optimization interfaces from architecture code.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


