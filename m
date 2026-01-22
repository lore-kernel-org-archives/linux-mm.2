Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB1FAC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 10:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D6086B013A; Thu, 22 Jan 2026 05:23:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4166B013B; Thu, 22 Jan 2026 05:23:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2E36B013C; Thu, 22 Jan 2026 05:23:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6CFC16B013A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:23:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3E29C03FF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:23:24 +0000 (UTC)
X-FDA: 84359212728.12.8B22F91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 260B980007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:23:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f9A2yDif;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769077403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8baty6keMhMUDZEZ/HySgtZbwD+Eaq2dG2O7a86KuYo=;
	b=ImrmR6bvZqurzSIDpMiXAr2JarcylNBWc4wpDP3yyWjq8cKsb+F4zl3geZOlrJ+mEHnkHd
	QydMlxZjd+CVwZjiwE7D1posNnui/DzQzmMt+bk+IR43wam1o4KvmPXXs7Rml+mDEL+wA+
	Z5O6ctKnWzpOvaxkhLqqjNzW6IwPm2Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f9A2yDif;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769077403; a=rsa-sha256;
	cv=none;
	b=X1gV9PCT1Lq7WJOk+9bWBJK415yDoMSSwNVVnWK9tAkNRyehSo23knvdAEurEzD2Jzsh9d
	tUJRZCFUYXnrwuC1uM3npMH+k0T8DrojnPBTOyxGViQrL3QPmtMS3ky5hBJQsD4G/41oXv
	4RNGaOR863ngQGbEP8k1LeDwQcyqs3o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 720AE600C3;
	Thu, 22 Jan 2026 10:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3463AC116C6;
	Thu, 22 Jan 2026 10:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769077402;
	bh=0te499sdFFCQEZXIav3Juo25FvmqHOPhfdLK4InvpvY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=f9A2yDifc9zaJDGikz+SPpBGjANGZ4ZtYGk9NJnIjH1Xhs6PV/U1QQxa4KvrGTQQn
	 okMz3uRIwBrZRTJoWDuhfOScqMTBWMVB0i6QB/mCDQDzT8QwInJ+E5+y/uWJspAjdm
	 OYMX6nw1k3adDJWMx9VzX2VUN7uEnv4gTTDkvpLHmEHhQyKUfD1znHPns4zX95E/wv
	 8ppBdCUsPUUkBoTR+Fj3t54GAIUrJuGBXEdkuk03fB44t/BUNWZOpDSC6GRFuVxH4o
	 OOpWTLsceSevIae0ARyA9C3rEPmchP8AGB7yd3WVbRp7hJAizg7HNWjNfKcaUnp69B
	 QnMgNHfAtmNLw==
From: Pratyush Yadav <pratyush@kernel.org>
To: ranxiaokai627@163.com
Cc: akpm@linux-foundation.org,  graf@amazon.com,  kent.overstreet@linux.dev,
  kexec@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  pasha.tatashin@soleen.com,  pratyush@kernel.org,
  ran.xiaokai@zte.com.cn,  rppt@kernel.org,  surenb@google.com
Subject: Re: [PATCH v3] kho: init alloc tags when restoring pages from
 reserved memory
In-Reply-To: <20260122042506.175897-1-ranxiaokai627@163.com> (ranxiaokai's
	message of "Thu, 22 Jan 2026 04:25:06 +0000")
References: <20260121120804.d1334ea0cc66b4a6de691cbf@linux-foundation.org>
	<20260122042506.175897-1-ranxiaokai627@163.com>
Date: Thu, 22 Jan 2026 10:23:18 +0000
Message-ID: <2vxzqzriaquh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Stat-Signature: mj7pqokerk45bkxtrfu4kqekan7yeaoy
X-Rspam-User: 
X-Rspamd-Queue-Id: 260B980007
X-HE-Tag: 1769077402-435604
X-HE-Meta: U2FsdGVkX1+ix1+jvHqy1eyCZ2L6HHFmAkZu7+EAz1Yz4lsMA00g9Y+nrCxXrxzJ7bN02Tnbco3Eff1WlfZjHZ8L09+JeBUqC3/tsOM6oTQHrem/rzXeMUsSIMOgYQRrIAPTiWRikxGKvM/bpa72hH6jueKf9+YZOKMwC8YrEB+58pNhu1aBfSqdlDO52ZrBAhXJtokBfEPbDFFLLFHC1SJ9vM1+yNE7Qj0tHx/pAk+eaIEf4trheMpVMQ72bSRuTXxEjLFw/GWCcTL6lJPFnbrROGr9CNG1gpsaDfN5M4P/A83H33BO8Ox1Ynt42V3emGkHKvI5WONe7hvawb+cucsO1ds8brfCnI/RO5W++M0CnKN2mfUEMQeXbjzNyqD85NBP5esb1792yYtQOlnCcZJtjak/BxYIlfUnyNfYD/2Q4TXeA+Qow7LcMmY2KLPd1RZhs3X2xTt1w5yQ0rWwMDm+SxBSH0BPYx1KfBX4HQJUeGwjnxYnAZHz8p33U2d54ELRqXRORHM2Vm/utMO/MDd9L7Fxe44kG1oEJjcNSrG8XST/jv8fk1KWc/dnVbSt9Z4l8eGMqidNEpW9vYs57KAVTxdEUrsEwuLQhw/FBDqBMNJXuMX2mcZk8SY5VeWs/7ItB1wcErnAhyUrT/JHoEzKkS8HTUcCoAzu0eM1bFVEPRkUsyIjZ/VuKu6OyWfyHQa60YFISA70DVKC5YTOd8BJfLUWpMgxQPtJ7e16d2QM/m5oU4jXLa337jivndLD5hHGqmTHm96KQeNx+48rQ0LWHEyeuBYPauqB/SxAHPOoEgzqJgx/ny/IcR/YKRj1KsmbakW6zea1saH1EnZnMtBWGvh/oaYD1yvZZsvgz3yzM3f2YC6LuxURkPsvgFxVTKXSoxHUdIa1lIVmxo2/YwHVmKF+94+0i4T7sjnJXTKigtoKIR3eTyJ+HKmq8Msu0VyNgvEQUSRoUQueIRe
 IX5eWu3X
 lsPTQVVzcP64g5UamfhEhymJlbcplTYBXsHl/llc9OeZiWOw0tZ1huzFhkzzK4xWJjRrGNHgQX0BTXsLf3rVF4duUU+TBhrz8UZCFUWBEZbyilQm0yXwNOy+JM+FhBlr5Rhrfr30sqnzipiSjhPMo9Uq+b7pgYdD49QH9lRd9eWxkDk4vOeg7rQr5ZBs5JLZGfvNx129H3vQVbP6V9K+5pApjj5xK4DmDHYKbxmgbx6oyrPuto/N9AkYt+jo6oKV2xf7G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ran,

On Thu, Jan 22 2026, ranxiaokai627@163.com wrote:

>>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>>> 
>>> Memblock pages (including reserved memory) should have their allocation
>>> tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
>>> released to the page allocator. When kho restores pages through
>>> kho_restore_page(), missing this call causes mismatched
>>> allocation/deallocation tracking and below warning message:
>>> 
>>> alloc_tag was not set
>>> WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, CPU#1: swapper/0/1
>>> RIP: 0010:___free_pages+0xb8/0x260
>>>  kho_restore_vmalloc+0x187/0x2e0
>>>  kho_test_init+0x3c4/0xa30
>>>  do_one_initcall+0x62/0x2b0
>>>  kernel_init_freeable+0x25b/0x480
>>>  kernel_init+0x1a/0x1c0
>>>  ret_from_fork+0x2d1/0x360
>>> 
>>> Add missing clear_page_tag_ref() annotation in kho_restore_page() to
>>> fix this.
>>> 
>>> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>>> ---
>>> It is based on linux-next 20260120. I dont konw whether this base is ok ?
>>
>>It's awkward.
>>
>>Your v2 patch was based on Linus mainline.  This is appropriate, as the
>>patch should be sent to Linus soon and it has cc:stable, so -stable
>>maintainers will try to backport it into earlier kernels.
>>
>>However your v3 patch is dependent upon other material ("kho: simplify
>>page initialization in kho_restore_page()") which is scheduled for
>>6.20(?)-rc1.
>
> I think i misunderstood Pratyush's last reply:
> "I suggested a re-roll of this patch based on top of my cleanup patches
> [1], since I think with those the end result is a bit nicer."

I was giving context to Andrew about the whole thing.

I thought it was a good idea when I suggested it to you, but at the time
I didn't think that this will go in the hotfixes branch. If it goes in
hotfixes, it doesn't make sense to base it on a series for the next
kernel.

Sorry for the confusion.

>
>>For a prompt, backportable merge it's best to base the fix on latest
>>Linus mainline, please.
>>
>>You didn't actually describe why v3 is different from v2.  If the
>>v2->v3 changes are just nice-to-have then let's redo those and base
>>them on linux-next in the usual fashion.
>
>>Unless I'm missing something, your well-reviewed, decently-tested v2
>>patch remains suitable for upstreaming during 6.18-rcX
>
> v2 version just fixed the folio case(compound page), but didn't fix the
> contiguous order 0 pages case. So i think it is better to send a v3 version
> base on lastest Linus tree and drop the v2 version.

Yep, that would be the idea. Resend the changes fixing both compound and
non-compound cases on top of Linus' tree and ignore my "simplify page
initialization" series.

And then I can later resend my series on top of your patch.

-- 
Regards,
Pratyush Yadav

