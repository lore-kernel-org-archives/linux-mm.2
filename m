Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CECFCECD9B5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 23:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D479E6B008A; Thu,  5 Feb 2026 18:11:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFEEC6B0092; Thu,  5 Feb 2026 18:11:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28046B0093; Thu,  5 Feb 2026 18:11:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC5646B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 18:11:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E67F1C613
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 23:11:00 +0000 (UTC)
X-FDA: 84411950280.22.23E7F78
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F3904000F
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 23:10:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jLn3vjp7;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770333058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNQbtNTj5xONF/FlzgjMO0/Jn5YLGFU3yCoER5lhWcI=;
	b=DfH4SBXNt0zOBm+H3USyygsp1i29MU2FHe6pfZmrAdylshXBGbgqwz9lQo6y/4BGxQxMJT
	RGGLby6/E6jFEFwuFKv0YBFeRWzngTttMNWr2SJFhRNSNLbkUMp0fNKkNDZkkcDYS1/6J4
	aUyNXgqxEjLeiDPRULgLhUe9SJO9VJ0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jLn3vjp7;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770333058; a=rsa-sha256;
	cv=none;
	b=TlJWzXwTsFa3uphzuGEywaHyBUUoCrl6YUolz0EszAE6p2frTM2oOsiwxXeoBd0qUHDpcI
	H953ARYW0984qj4JfHhQnMbojT+lyRtY4RqCGWgMC+Z+ApVkNB4h31av+vjjrJHpxEXuZ8
	Za2vcl5Ur6r9ipKLWJphZ2AUydXFEI4=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89473dca8aaso1357876d6.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 15:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770333057; x=1770937857; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wNQbtNTj5xONF/FlzgjMO0/Jn5YLGFU3yCoER5lhWcI=;
        b=jLn3vjp7znDTFQj1XQpopK3+ry7L2Cudg0j5tXX6CkI4Jl/fvzs0TCQ5tgTuGt/B0h
         kseySQx2LTyArUcshRwPYyGnIWCvYPYib9JOFoOW3XuNEnyArtaJ4zFgvroprdL823jG
         AVonSrFRaZULmeoNi0sOBhbS2GOqmVE70g3WfrNgX34ybtqcUbx/s5gKa4tIaCvvdRTm
         MQf224T46XdU+KzVXNuKQSeNcE7qBhkW9Xr57ZpuF0SwsrAARZtxhtDCsZuzK+GRotK4
         0DuYrxbF/ao/6QrJ4oG4btDIM2y4eqL9kOrJ3GpzqdEDjEW45m9pEVJOuu8PzOO9xn/b
         5/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770333057; x=1770937857;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wNQbtNTj5xONF/FlzgjMO0/Jn5YLGFU3yCoER5lhWcI=;
        b=e9QO5qr3IX3Z0/1iqbq560NKw+jBVLYMiZCkIHTiXqfd60oADIk9ZbqyjG+hSTxy+f
         dqIlvLk/1lTZ3jkzeUCvmn4VNSHCcPlAXTXGudeK21cRQKotKw0cNGbyahB0Q0aAIyhy
         gH0LNKggLjpKivufDZU38AU0kQoecbJgV8omIychVxe1gNCiDHqGQX3HRGyO1g7M9LAF
         w4q1cqwDfhaAkC4K9FXsaflJKmjwoL9k6bILYa7Z12Z3h8x+c7UCvk5vkySJQZCt1Fd2
         JU++ewN4JyrQMQlYDwryEZQ2f4DUfLuYc03sVtzzFblfhrwtwhb3Zr3zPOJ7F4M92AF4
         oSlw==
X-Forwarded-Encrypted: i=1; AJvYcCWCPzbrb3xSKy42lQSYs3BUWyvBEwQffaI6Q+yutsTK3Ly7Tu3+coJfmBfKnlEqvTAc0u5GfepMFw==@kvack.org
X-Gm-Message-State: AOJu0YyvKV10QdKQ6mOtnrJtBm7xAjVsjQzq0lfdvVVoyPFhYt/bUBtY
	Hf/o464LP04pb2hWGfp4c1SV6UnulRsb1E8lJlTC1eF7wRm74FHYn2Hse+/2fcjeJZ8=
X-Gm-Gg: AZuq6aJaI/JVu+/RJFE4KRau74r/7aLmN9Uhx1PxwRv3EoQ0zl/OzSjIy7/ju4U4fcM
	67gRaPF0OWsr0VRPjcx5gjxFncu9Cqei/s4R7B/m+dUgW29R5qvbi9ojH6mNTymy88FPj5S8gA/
	Ibn/bzYqCpUOfQw8AlmUDrIM3bPs5bO+fLxGFGj/Unj4sZdpvPT8pi3U+Hwo8t/+8yJfCk7VFAf
	I5gzJOVXrHBhhtGqK4UFVk52dF6C8HkhdpgWlt0J/clo5ZmBiPGFq38Vs9UFrkoK8xxUrY7ccol
	8C5bWHOpVNKPGWuh6KABYPla07CX1bq3eidR/km7bR5QK7PAbva6e9ahG1LlAHyxscF94QQyRd5
	1b4/jVrgI4hT93iei1u7EfAHs27i82+3ulVFdJgt05thw9IQTLGwU/4dXN5R8TE/i7m6BPmUIlY
	Tomh2aWLk6C+FZqHQ06kGvmfIMRdMfHlaVGbSU7puZkl7CTlLA+8LpGLbB+FkN52uo0Bssvg==
X-Received: by 2002:a05:620a:bc5:b0:8bb:26db:e22f with SMTP id af79cd13be357-8caef7e1ca2mr107313385a.30.1770333057461;
        Thu, 05 Feb 2026 15:10:57 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8953c075fc3sm5353626d6.51.2026.02.05.15.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 15:10:57 -0800 (PST)
Date: Thu, 5 Feb 2026 18:10:55 -0500
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cui Chao <cuichao1753@phytium.com.cn>, dan.j.williams@intel.com,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Mike Rapoport <rppt@kernel.org>,
	Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-ID: <aYUjf0OrD8f_bJCy@gourry-fedora-PF4VCD3F>
References: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
 <20260106031042.1606729-2-cuichao1753@phytium.com.cn>
 <20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
 <9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
 <20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
 <696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
 <2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
 <aXOl9CN_66HywIjZ@gourry-fedora-PF4VCD3F>
 <a90bc6f2-105c-4ffc-99d9-4fa5eaa79c45@phytium.com.cn>
 <20260205145842.efb90572a902ae4c481e6ef6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205145842.efb90572a902ae4c481e6ef6@linux-foundation.org>
X-Stat-Signature: 5utuykp1q85wi85wsw66fosmb7k4t9cu
X-Rspamd-Queue-Id: 6F3904000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770333058-459119
X-HE-Meta: U2FsdGVkX1+MdE2HNwD64jcrZIGtg0Ow1egAM9QMCsItypdEUbKgAzw60dE5O39sM3ztA+1KG+SByQZ6k45GUhXMoiqsAyX0UN367H7Y8DZB9bLJCaeYUyxd4prq3P+LsSQ5srESRociguDODGrv0Sf58aD8cloGbHFo45g8dSfvVa+jILLhD5YcL2V72cQHqctgUE4BLjZ93RkqF9JxQ+6dziaXWwWM4jo9G7RnRC5qNSYTXzToxN6w47OSl+WsTdTz7H84B7ZvDMJe+2LhpSjS0d+EvsZQgiAIHIvM1Z0LmPAwC7f+UuqKjzPMMPD1h32LGpJgYsdG2+w+j0V2V0RLxfTPFg7e1TRzCGxuMNhLMeOPm9AfMOsG0NsUH0r9cJibBpTrfN9wuk9ajFMlxRS42f9Mdn6HnELSgdG3OA19RClI1Cu/4AooYpX//ENvFug83hbfrJkaOFppV65+CC1Usd1gUCiZUuWM7hCtxM2GXTfZuW1a6uav56Xhxb82zaiPs89fl+NjV2XaISB6vR/I9N7oFvOEu3GlQz61g3wTmOR6RzkB/BIvHyK6LaaJXPsEyvxfkBIDU6DvU8y9XslKUf1B0X5OnE9km/jPhb1Gcy5YTVrWbDc+XshFsai5n5iD0Xp8KDf5kgwwIDCcfNNTH5Tp5iODi0h0rfFhbRmvmc7X1luAEFWhCL+FVFnjPVRTmhnWfbUfOvZudaBwFwc+jreSjx5bcfhoTABwYSf09nE6k+AxSgIgypVcBOynZG5wUE2pSqUyaXIZNg0SccOT2C/gOYajY2s6X2S5Ml0NYF3fBuZS0Qb9g5363CumvQ9VBDBtP2czKfoKUbO8ROUXF3kCKfr6/WMATy02phUjGXZSxBb91o4e40Uz4CGvAWwwLYgrh9oeE8KphUbrJZQ7gnc5f59S7K/9pJobBrlnzahU4gGvh0n1pTyAWIu4zKgGUEWBsDYPweg67xV
 EN/RXGhh
 fi4oiVlG2SAgJzDBqnhXZqQMQM9vc2CfhmArZOx+Xh5R/wUwslNFxJmHrnXknUV5qC2TSBcJ6cUwP8xvPuum0H4l3cfWko+bn77mkuSKxLW8Elm5UKY6JlVBCkpnInB40n73oBBWYM2mfykEmYtK5bkDmUvmpcr3XIxtbk6BgrQRtaBkIH6AwcZPjZN4NtXvWXrtLT+TyJ469Frjv6vfHX3GrBiSuohZwQAnPg1rl8GnH7yGzUoRIFI73hhS0ZKqy+i/Q303kCsRSJ/KbQ8Ae/k5G3DcV7OymsyAUASOruEYjZ70cga9iR24IFANjeeHEUV0zeqJb1bzJpJIOvC3dJ+fzSXcAz4hokMDIAPku7yB+udUfSq7pn2awVS4IbEPqI/uLGgrN5AYKpCQKJFcPs6rGfbT9k6Tker8KjODrBT2mfuCnh2V7FKQLKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 02:58:42PM -0800, Andrew Morton wrote:
> On Mon, 26 Jan 2026 17:06:52 +0800 Cui Chao <cuichao1753@phytium.com.cn> wrote:
> 
> > > All that said, this does look harmless, and seems reasonable - but the
> > > changelog should reflect what the hardware is doing above.
> > This issue was discovered on the QEMU platform. I need to apologize for 
> > my earlier imprecise statement (claiming it was hardware instead of 
> > QEMU). My core point at the time was to emphasize that this is a problem 
> > in the general code path when facing this scenario, not a QEMU-specific 
> > emulation issue, and therefore it could theoretically affect real 
> > hardware as well. I apologize for any confusion this may have caused.
> 
> This patch doesn't sounds very urgent.  Perhaps we should do a v3 with
> updated changelog and handle that in the next -rc cycle?

Mostly QEMU just needs to add SRAT entries associated with the
CEDT/CFMWS it adds.

A system providing a CEDT/CFMWS entry without an SRAT entry is arguably
bad BIOS.

But yeah, this is not urgent.

~Gregory

