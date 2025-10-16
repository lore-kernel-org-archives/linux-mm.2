Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2A5ECCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 09:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB588E0007; Thu, 16 Oct 2025 05:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36CC68E0002; Thu, 16 Oct 2025 05:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9F58E0007; Thu, 16 Oct 2025 05:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16A1E8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:33:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1148B7A41
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 09:33:15 +0000 (UTC)
X-FDA: 84003463950.21.F68A5D9
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9D35F180008
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 09:33:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZaRMTR9W;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760607193;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHMRuj/15syb74fDu1791nFi8BMeOt6zd/hpHr/6Rq4=;
	b=BmqyKdIADHTVVzUVMRfv1a6JcLsoedFf1U9kiQpQXY12xNul2VvCRgWSq+OrGngcSWN/Al
	eGb20HS+rog9MXXR81NqfR6FdXLMzbPmNwYIpbdy2/cMMuY7gT9VtxTHJujMf0LoB90IYv
	7+B8to2+6ZFKvLcprnI9M/nY+OaK6B8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZaRMTR9W;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760607193; a=rsa-sha256;
	cv=none;
	b=m3kMeW+Sc94G25Xga1++FziIVR3zEgiGoM7GoLfjZSJbSrmLV1rlqUQl6A70trnjgvwycx
	38xp+phTMNa77dP34Q+g4LnHP85evk6rq/ZQRpXRrfiiAlrWce72TGJN/tCinD3oswqS9b
	9EEYr9Kb0Lb2BNY4dPMAiYOo1RM2SMQ=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b3e9d633b78so119516466b.1
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760607192; x=1761211992; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pHMRuj/15syb74fDu1791nFi8BMeOt6zd/hpHr/6Rq4=;
        b=ZaRMTR9WOwySd9EGkj+Ti9L7pM/Dfa1gp7icTnbiBRX0Vx/wJnz9t+olyXqBTGnYKu
         KKDW82i+luDEzeAAJVRVcrYprXtG27wJ3pJM2XXr28SUhq3lP6ZC/f/J+gFO9P1Cp4k9
         x/EcSyVlmxnDQwOAJ8wvyVtjzgCxXSvjBQwPmqkTK2/6uTrmTTJLHiLR/S202hVj1DZY
         G4ypasQiYHObGtXQRG/Dk03v2jaaSeKG/1IvWF8j1ELthDZhSz7lnImmv3NPrEzmGR4W
         Fl/42mutc/KjE5lw1ctmpFbWhKyF5VLtdIgyXCtIJj+T6kFxsDPrEPxPgn5LMCx8dd40
         R6Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760607192; x=1761211992;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pHMRuj/15syb74fDu1791nFi8BMeOt6zd/hpHr/6Rq4=;
        b=bqmSAVkGBtoEfNt9o4Cknuh0xBrCUQeVV9KzUNTVC1vMnIQQWEY8mKz5GDvGrtpfBA
         SqSsIQ3/lkgRqnGJZ8l1hXkyMmz5vJsIMonbDSgHO5OMWrATlxW6sg51NsFNNog/+Ht+
         i7lC93ywhDPO17LD9Yl+OMhU5cgfVEPJ+nDZLzWNsyz6JT0QWq7zfqNQdulminR9+pbx
         9DLRvvBNc5wbwIRINGDmq3vO37hnUuG5cu7BSXovjDgRrCI6M6EBtH26qfj2Rt27G7EN
         unJY7JrbbfV/og9jsKzxMsCkhOk6CHepBrJRdVM+APC7PUoV32HiUar2u7V+D4YUBf1b
         Fvvg==
X-Forwarded-Encrypted: i=1; AJvYcCWkxb5ZRtaQklqqVosVKkQqRWOgEm/T1aqOMKEb3VryTS1+3AAdXH4OKyGqOSMUKGb+T42oBDeM/g==@kvack.org
X-Gm-Message-State: AOJu0YwT8JS/MrhgBzu7hb6LcRYhpImtHUVW6vbZR26SyYJqAoSoOst7
	gcMjMr3iM/WN966XXSuU6khkwZC53e7zpb8IY22FTPDuHxo//z6Wuop5
X-Gm-Gg: ASbGncsRR/5gbPQPqkNXv9fiSopzwwfVfDqdJh/8eEqExpZNdZJaN+tdjmjDHZVsn8D
	As70Ky4UdBpkGPtIAXm7g3xOZBGjTyRpP9KgIZNjgf6+/IqWsexLnnRErjIuz5bBwQzZe5n4Sk0
	3YArQKDoKdek9eH8R51pRwHn8BXweJo95zELoPvOVWjVoHH8Yg/BmpBE2Ig9U+kOyM+6+LthzZP
	g6Qi5ZYQe564PUdn0IKGHWUWfFojLmUGJV1gwJwKzkPPkDDUSowJOmNCVYrEK6WZxKkPT3HUZUT
	xy7Zs26BfUjmxEOa5L6lPpFnvq+PbEneuzv8lXQ7oR96kD/vNEQbNC90mExEMmzlAFEzXrnp7Qy
	wb4blGeuBVXg1m3PCdC+pM22LBT6+WelqpNWpUHWwNQxdE2QnoKPucj1SP2Ov5faLXsqPzxCGpS
	6+55EodSg6LA==
X-Google-Smtp-Source: AGHT+IEYm86dPzeRxAUlI721i6XxvlHj7KPkjjQbYDNxh+Ekxpv1GeqtK7/vX/7AtTiWdLiudoge7g==
X-Received: by 2002:a17:907:c718:b0:b53:f93f:bf59 with SMTP id a640c23a62f3a-b60552bdca5mr370747366b.29.1760607191779;
        Thu, 16 Oct 2025 02:33:11 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5cb965dde9sm475741266b.4.2025.10.16.02.33.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Oct 2025 02:33:11 -0700 (PDT)
Date: Thu, 16 Oct 2025 09:33:10 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: guard is_zero_pfn() calls with
 pte_present()
Message-ID: <20251016093310.rilvenglgnr65ojq@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251016033643.10848-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016033643.10848-1-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9D35F180008
X-Stat-Signature: ifyf14fkqaucagks3pmhtw13jxsaojwp
X-Rspam-User: 
X-HE-Tag: 1760607193-430276
X-HE-Meta: U2FsdGVkX19oEx/0i3s20PiOwp1/IP4dK0iLYWCYe9mkrpjpCGsB4U0m9InbC4tK1I3FtSIJRx1a+4PxJOGimVRdyimzIJgXxfZKHV+ik45ZKJeIgCMfK8mz2GeYLR2NoxUDjbT/Z+R50xQcBY9IQhWMZ7AxzkhPwFingyU4G+N0k9q7hUmI/1376JVp0QjKCQCFv/OihbhVRRDg2RWXTAg08Tm73zT3hhRGxXS+2NdSxaUJjsTfLLeo4ByV1Km/6kaqwnGQhL7X8rHsOCEzuYAT/USNJcCW+6K+glCr3wLEqwhPCJVaJfCWanw4rKDLrcRnRiUmq/3jb5yaVaU6FEG3Nl9ySbtvTPZ8/SvNAgTz3u8f1SkrJYo51eGNlcEjc540Cz/ri0XnwiBGPg1SMxFanKR65Z0r9oADKx8EaNEGzJ0ddm7ziUm07C6vLkp+gUfmejnQwu+3XziV+kEMqi1oS0ktvb02khZ9NPljIozYZpt3KBXLXcyp1rOWF8Qeb8jXnPdcFraLk/fWrYvj4x23bSlEw5BzgJDiRCbD2DL4bAww/Ctwe+OyQOvpiA9xUTLQV86AbeBJagRL3gpeqi9lIKpSPB/fEmJyHYX6ppuiGw2gzO0IP9LzNiKGx04M0kdVMBfFh5WiUv728Ug+KJKLjBwdczCAjVYxWlTW43oWOUoj/pMJDodeKlaACkJwKrwaLhZe8JJN0L3H/SUGp5PZd3rjzKaR1ymcS4C2GmcF3feWKYQjb0B9CPnuXyNLHT1yTfrgv6ZZ4n/LSTnDlerq5jKVAh7uhgnkmZP3uONfGIvhd+IaQNOILuEGvBVRVwSQX+EE9Y+BfEXQTv8hJ8gmy3q3MsWoE5bTAD7kXQ4+n9yJBNHm3itUg79B9Zb4FCuGHMyrzPr+AJbu9ak2zRkaiMcukWdynOaSVtzl1M4gqRei0k/SdjPY/afdQPqC6M03tdalvzIzYWgKN6o
 knFyaCKb
 GCox838k61b6SPjc7Gq5hl14J8Lb8vSD/M79wjpVxFLwTLCOP1L5DwfA1RIwO9+73G1KO3NkAKZvTJlgziN2SXN//MaWVkKpLvgEkHefEiFjU0OpEo7stiDD5DNP17Aa24iV7wkZq3I+GnEu/kfwvY9WOW3lcXG/kmuJVLw2y7oYDVLAG7+HhWmSZXS1/8yZ9VNliDlvQ7X44tDV1xqbynkGVN77YDqyljLysu8FLglyXZMU/yzU/HR/xYeEKPcSWX+O5uQmGCTkqDZjJn11vC4Yo3vh2fLkvtk47XntwxOWI8XsOTKnTrZ/duXRbIvrzNeyyDFBybBk6gWlIU1h2zG5n8YupGUh0QylXdG9HxGs5N7F9A5u15U08CHP1gzd0C2TGrBb8X9yBZcRKRrkaRv+YAWz8Us2N8n2DX9n6C2rmbMUp69JfQk2AnTkVw/SWsCgegoNyTc79+aT1LTvkfQQfVoTIM1iidR84LvGcbh+XvfIQTrMsVfaNFbJMAG6KGn74PJdKJyqlYLurdj7Mc1zpTnw3yshFkcu0XE0xBk7U1FUNde1hIgmv6uViisGWTz6JI+bd8Y7gGfOqUzhveU3EPeIE4DB+onlUtcvscNGMjsRNY/8R/uF7NXrl87jdXXfUrXsNqKOoeTfYl+XMGTUcXXQdRAflte4Aygz1oGG+JgcRVruYS2nKQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 11:36:43AM +0800, Lance Yang wrote:
>From: Lance Yang <lance.yang@linux.dev>
>
>A non-present entry, like a swap PTE, contains completely different data
>(swap type and offset). pte_pfn() doesn't know this, so if we feed it a
>non-present entry, it will spit out a junk PFN.
>
>What if that junk PFN happens to match the zeropage's PFN by sheer
>chance? While really unlikely, this would be really bad if it did.
>
>So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
>in khugepaged.c are properly guarded by a pte_present() check.
>

Does it more like to guard pte_pfn() with pte_present()?

-- 
Wei Yang
Help you, Help me

