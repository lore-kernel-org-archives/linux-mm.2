Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B0F2CEFCE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 17:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF63B6B0005; Tue,  6 Jan 2026 12:54:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA4666B0088; Tue,  6 Jan 2026 12:54:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0056B008A; Tue,  6 Jan 2026 12:54:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC78F6B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:54:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42B551AB5D8
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:54:55 +0000 (UTC)
X-FDA: 84302289750.26.36E1F89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3AA231A0004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:54:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rWtodjAM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767722093; a=rsa-sha256;
	cv=none;
	b=uUVn8xBSadzRmQ2k+uioSwlcCf2EXT/5gdCDQygeLeLtez3T6VmrcSPwQqt1rKBH/pzxuy
	ApgZJB0MjgYVcPE8YDjzmry7f0bWfpT1Ex9tHeaUejchWoVgbLcxXYrktS4FRGyio+c4+j
	UFeZVBZLtYy0HYpwZ+VOXC57jbPHk/I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rWtodjAM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767722093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3dIuZFRjgDFlW51LoZADH2ZoeovtFoXctOU67zoqhc=;
	b=ss7bOshwM7sTYAUFeHcoNXypduSzl4huU6N8nI9HEOYExIESa6bH2HJl1obja4kAkRg9oy
	MaLsbq8L4iS1g/NGLwkalK7KPKGG66NLSNqZU6U+lOkouHfTsZBVNgcXVA+VBBoAc+GaFW
	6G+jxOjbmMbXhZ2VRGTwa7CY1DgvvlU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D22A60007;
	Tue,  6 Jan 2026 17:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39ABC116C6;
	Tue,  6 Jan 2026 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767722092;
	bh=v2sDP0QArV+gbzzixJfSSBn0r6oALTCxT9HXYbfR9k8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rWtodjAMlxnZe+ay7i47Un1eMblNV0jNUO4l7ZFdY1AKQPkYueQEvjvoj2xIcNH8F
	 LJHoaJRLY0oyqLUEVDDzijkrCHyH/F0yHheIDx/TkvmL8D+cVOTAmAAYl2t75Dmjde
	 sIrG268Ydfr8+Mm87IxSNmU8yVdvGRII7sBxapjguupEDrG0hnUuILpBIiYsfV/R/c
	 WEqqWsakmqnUurdVp1qz/n3ijAIu4QB40fvbVKJasoRY5Hyuh0c0EGvxAIvKY6cfJS
	 YwIZ2OltZy3Cu4bJZoxNIqcUw4WcGccp1l5RYmGemuRbc8ImU+3mu5y0p055Y7MeOf
	 T7q+bXPZXFa5w==
Message-ID: <01ebe0c6-6135-4937-a758-93a5fc78d7fe@kernel.org>
Date: Tue, 6 Jan 2026 18:54:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.cz>, Joanne Koong <joannelkoong@gmail.com>,
 akpm@linux-foundation.org, linux-mm@kvack.org,
 athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, carnil@debian.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com>
 <ypyumqgv5p7dnxmq34q33keb6kzqnp66r33gtbm4pglgdmhma6@3oleltql2qgp>
 <616c2e51-ff69-4ef9-9637-41f3ff8691dd@kernel.org>
 <CAJfpeguBuHBGUq45bOFvypsyd8XXekLKycRBGO1eeqLxz3L0eA@mail.gmail.com>
 <238ef4ab-7ea3-442a-a344-a683dd64f818@kernel.org>
 <CAJfpegvUP5MK-xB2=djmGo4iYzmsn9LLWV3ZJXFbyyft_LsA_Q@mail.gmail.com>
 <c39232ea-8cf0-45e6-9a5a-e2abae60134c@kernel.org>
 <CAJfpegt0Bp5qNFPS0KsAZeU62vw4CqHv+1d53CmEOV45r-Rj0Q@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <CAJfpegt0Bp5qNFPS0KsAZeU62vw4CqHv+1d53CmEOV45r-Rj0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3AA231A0004
X-Stat-Signature: 1w7w1g1i5c3mmgjckcbmf9ct4zzjhyz9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767722093-705951
X-HE-Meta: U2FsdGVkX1+MFkTsjGoiBjJOPHn+gPn3KSi+YqVMLNxXg+MSdQPssPf8ZvZUC3NV85jQ0+EfQs02TN65R9OcgLwjvPSGQP/pE9f7jbAJr24951F6XiVyynvIWHZzwz4O3RcpEV+OfIDh5NUjHHmnVQyEYpo9Wt7OX7nEq9Prt3WFyYf2FaVdbPDmqZIY/VvsiQgG6egvv6VD/RTUMg9j83Fhss8HQg5xW6tLO5SfoEbhiP0Nf83X4hMIYysTvLbRR83zemLtnLcdQeFA62i2h7lSUlcq7ha+4s6mMoAqvOzZgPvyqsTpMB9MLCvc+vhzpILmvbHHE/IEn7NkJ83ykiURTExT5WGhi/Y/C3u7wTYTR78IbUZBPr5pjDYG4nLn4hn3DU+EowAxxNBTo7myzN/g5mw6HDo5IJl2bGLuZBvyKIM3FkRP1UWGNUyLwBtnAY98afAc98t6nOO3OxGxTK92arNfZmaJhGf0PPSKcCwl+z27isyK8zmZABgokru2mrI+UuWufwr7g+S5enuUXDUZru8HzibbE4MqFdtCzjs0Pdlc1rIIn87CG3I/ttsrReB4rP+x6c0lre+xBvi9PIVzCzZ1usxouoRut/zkHhoeMzB+xIRsJvfh1SYbxIXsZ9gA8pBvVNBezKjURD6OsvfrKkBScLJyWxDumW41iY8IDwiPXzm9QCWeDJRK5Fy6V6W+WVP9qblb1YireSl97nxZH75L+F3v/ENIw7XTIhiEDEXekkIOqindFfnXbAaxybamjkXs10DqUGJ9fjjzplGPm8Z2zL7iC+dJTqL7v/KKrbsRd2teHTaUZW0P/l4b5E14ko72hypReUK+YDtOMGCarjXy7vuv13nA000ZUzgBtGpTzO3V67YwqnWzYMqjVQwfFHbjNFErAyd0RWpuE/vts1QIL7bMiH8/2Jv7H5tV4WpoCoVs7JKqIj21u6VGdyZ/CChYD1cXsbU3mVz
 0LNAeVex
 UtrSZduD0T8Fc4RkLMD0PIs0UkukzOpB5dx1opXgcRye8Pf75cbED8ha5iY/iy3RhKDWqMVv7Bz+3jTxULYfNRZQg1JMTggC7sEanuO0pYQcD1cMWl/UVF1nLPve2RGz238Gf2SeJldrQysJTq1QhaIKLawRNqWSbPpDIn/wRzu95D4PI5rVmYY6vv9cHyMp4p72KhUAgC5ycN9kMzmpZnA03LPx8sxfZxgg2dEVoe3gByU+dYGRUYq2lmH8gYRwT9DzTTPYOfdDW/C6bzY07wgeqo+/DyWxVPn5vIvbyKZuMvjsqaIUA9Im8P+S/Bz54Bwgdb/GRkdzofCk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 17:05, Miklos Szeredi wrote:
> On Tue, 6 Jan 2026 at 16:41, David Hildenbrand (Red Hat)
> <david@kernel.org> wrote:
> 
>> I assume the usual suspects, including mm/memory-failure.c.
>>
>> memory_failure() not only contains a folio_wait_writeback() but also a
>> folio_lock(), so twice the fun :)
> 
> As long as it's run from a workqueue it shouldn't affect the rest of
> the system, right?  The wq thread will consume a nontrivial amount of
> resources, I suppose, so it would be better to implement those waits
> asynchronously.

Good question. I know that memory_failure() can be triggered out of 
various context, but I never traced it back to its origin.

-- 
Cheers

David

