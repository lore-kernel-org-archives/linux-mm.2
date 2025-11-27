Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFAB8D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 21:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111FA6B000E; Thu, 27 Nov 2025 16:31:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088666B0088; Thu, 27 Nov 2025 16:31:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9586B008A; Thu, 27 Nov 2025 16:31:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D876A6B0062
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:31:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F7741602DD
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:31:07 +0000 (UTC)
X-FDA: 84157682574.04.CF18C54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id BF4A5100013
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:31:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Odhu/0s4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764279065; a=rsa-sha256;
	cv=none;
	b=JtKZWdsfUXQnJU07Mm1WmkCeueZYgSBp8xV9OIvjvkA7AOymG69zFUx5yog5+HMSH9vKpk
	6/liSrlrKfqatsT+wYV9uRqyWV1CXbpSPDUxMyGkt/uXhgtYVG/lQ20AxvxFcsYJYGsIB+
	XphhWI4h5tMdhV8c2eiVQeC1Eg3lizU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Odhu/0s4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764279065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOqVOPLh1B9rsmAXIqlzAvwF0XR4gu5Z7M6WFTR+M3Q=;
	b=pz4uamikrK/j05XvJfpYYDLkyeA/MYaeaHxOrcJ8gRzdp9lR0l1KUwLpdm39gDJx34M0DY
	xV6EIF39QfgznIC3mrIh9MOjPUwAw3OQtH1daf3UDz8dwVQXyaa70N25mBsB440J/UyL8C
	vqoz0WcJL3wdkKVtzlFLaWW7u1ti7t4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8407740620;
	Thu, 27 Nov 2025 21:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841CCC4CEF8;
	Thu, 27 Nov 2025 21:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764279064;
	bh=ywbAAzd9Kp7GEcrsxuGuM12fYx11Cs7LW5tYL+saSPw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Odhu/0s4Ls+k/BbLn0GUp1ajsRCOtvnD2Gsb61UNpir+QhSghK5KfbFPHa8PAiDi/
	 0/KZ5N5Rv6Y+aubd380RjJVmgeerBLpFbk05KEjdBJrcTR7fuUm3EpbjrZxmp+VecH
	 RIuUqmD+GixOUpsqLgZG9UlRg3hCV4gENdFqnRQ+ZWJy8n48j9WW6bKyBAAes46h98
	 r14CWVLH7pmo2t2zWHEd4/CR7/DxK6iPNTdlDF+JlFtrOue2HS7pfikfi2XSvHRFEP
	 grLkQ6wikItmBVu9HybulG7JB6s6/i3+gAufCN3DqwJ4s7+0c5vmm0F4w0scPqKGqC
	 VUCFv1hohURIg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  rppt@kernel.org,
  kas@kernel.org,  changyuanl@google.com,  graf@amazon.com,
  leitao@debian.org,  thevlad@meta.com,  pratyush@kernel.org,
  dave.hansen@linux.intel.com,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/memblock: only mark/clear KHO scratch memory
 when needed
In-Reply-To: <56673a9c-a4c9-4962-baec-2d4483af3cfa@gmail.com> (Usama Arif's
	message of "Thu, 27 Nov 2025 21:04:58 +0000")
References: <20251127203724.3177621-1-usamaarif642@gmail.com>
	<20251127203724.3177621-3-usamaarif642@gmail.com>
	<20251127125539.98b2f148c6225f1cb7c9d045@linux-foundation.org>
	<56673a9c-a4c9-4962-baec-2d4483af3cfa@gmail.com>
Date: Thu, 27 Nov 2025 22:30:57 +0100
Message-ID: <86bjknyxgu.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BF4A5100013
X-Stat-Signature: 4ojq55msw3ctp4mftk4qdh5gwoaph9m9
X-Rspam-User: 
X-HE-Tag: 1764279065-194533
X-HE-Meta: U2FsdGVkX1+R4Os+58Ru8wAyjofeamInVOG4bgTGTbdwrpds86FfZeYrJV0GWaynNd33V2pLYEI58boTgbpvNBV5cdRaA4a8Z+vsBCfEEMLK77C6L7Bg5ZdxX53IzOOd9J+CSNzpAiWCjC5+bxEc8dpIbeq9viDfF600gyhmmdWJ14oLacwlKSnI8k6xTw7EhyYWDxVj6clnDdWseiZC0bmzJRpaqO/k01Fw7Ss/DSzAB1VOp9KZbaMKxSnpsdGen4+7WNDhIrlNuLiGi/noVzFgB0KViFCKBd9dIJbxP8YXKuljoCt2THFKrPHmb9xBwx6C3OwFI/ydqoHQq/KOZAVkqvh9rBrWzYQDiqu5Kcb3vn4J8ZzqklvM1G5ev8RQjI1tflpYKoJozvwPvky14bCiVjx+uJzT5LlQYRLCWxkoxZYH4p9jjSGMubyb4I4STOYXrITmhmEXVL4TDquzabP8pM4YJPnhmDgq3VOtA1JsK5pzgk57R+9rrcvcTiWkKqcT6lRUkC8Ucx2hNQKeyTOJ/38ACoGpGT1x5D6O1lekq/rT7BwJaMke+4imLjLDyhvdWUih09RXRzANYKRxvoZFWGhiMB5j9EOYvkXYMmv6+8tHDns3svHTy1YsBDXyG1Fo6GF4fi7paw65OOKvsev6ylZ8wsPX+U5NnSaHEagS6hHsvaIob+L/2jf/mRCMCgmTLhkafnn6TY6fJCMStmm+7H347VILB4lbFR4va6ZZzAFufBqcaFFqVXIWAA9182TW9ksWd6awIhr3WV5T2uAmi1UInhBth8Vxr2kG5HRSyUApV4elY7f4MIOzgXQffTv22cMV/4Zj3ASwhbZlqSLZ4j3yFLU6BO0rIoJ0vBZfFGiAwXeKfN9oZ2hAhoB7UKTl+4ayDnc+9LShkRogmgE8rAzTabfIqNY8griEj6OzSBLh4G8m63Xpt+zRo4lDGFHuai/o7EPASbpKYdL
 9I9sgKkb
 pxMG79nbvPuyF8pZQ8+N8pp2iVqEOsUnPCHexkotkRSVhxyhN5sZkxVgHfjGxcHqJFjWMKi021KBCVjByKUN/RVtK2wAsfEvCR+hRwiKW5XJrTt296+1jaeGfww9OS/ybirtLXnEhPT52uVA2MiOTrYpn+BwNWEh4bXYVQwd35RV0RVknQrmVZv7tz56Kwif+qqp4Sm6GOpcgHHpogJJdyrYyGNmS2AM781Ib
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27 2025, Usama Arif wrote:

> On 27/11/2025 20:55, Andrew Morton wrote:
>> On Thu, 27 Nov 2025 20:33:20 +0000 Usama Arif <usamaarif642@gmail.com> wrote:
>> 
>>> The scratch memory for kexec handover is used to bootstrap the
>>> kexec'ed kernel. It is only needed when CONFIG_KEXEC_HANDOVER
>>> is enabled and only if it is a KHO boot. Add checks to prevent
>>> marking a KHO scratch region unless needed.
>> 
>> What effect does this change have?  Lessened memory consumption,
>> presumably.  Of what magnitude and for what time period?
>
> For some context, this came out of https://lore.kernel.org/all/ba690e06-c2a1-4d2e-9428-9ca2ea9f2b86@gmail.com/
> (I should have probably added that in the commit message..)
> We are experiencing several warnings a day in meta fleet due to a warning introduced
> in that patch. We dont have CONFIG_KEXEC_HANDOVER enabled in the fleet. The IMA memory
> seems to conincide with the 1st MB, but as Mike pointed out they are different arrays
> so this scratch memory is likely not a cause of the warnings. But it is not useful (and
> was a bit confusing) seeing KHO scratch memory being marked even when KHO is disabled.

Yeah, it is not yet clear if this is really the root cause for your
issue.

>
> The imapct is as you said, but its only marked for a very short period of time.
> I think a better reason for this patch is just to not mark the memory at all when KHO
> is disabled (or not in use) for clarity.

Yeah, I don't think it will have much of a difference in practice, but I
do think it is a good correctness fix. Marking the lower 1M as scratch
is a hack to get around the limitations with KHO, and we should not be
doing that when KHO isn't involved.

-- 
Regards,
Pratyush Yadav

