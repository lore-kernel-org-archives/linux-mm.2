Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4808EFEEF33
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 13:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A56D6B009E; Tue,  7 Apr 2026 09:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D566B009F; Tue,  7 Apr 2026 09:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9A36B00A0; Tue,  7 Apr 2026 09:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0CB696B009E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:00:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 525EB16080A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:00:22 +0000 (UTC)
X-FDA: 84631768284.07.E0F370F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 77F5040020
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:00:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ALLPTejs;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775566820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1FBI+wtuHGT0zPtkQAGQzN9vj5bi2AjmiJ3d0GKJZs=;
	b=1R1xY27ICAGFoP97A5/BPU4p/vif3ES2bvj0jIX4+0kpmICvzDaBC7pqKWGOsbIlUut1ap
	kidQhNQx5xAtAbXwM+S875hNXIcsXRTSJZq92oKHwLpqjqls6kWg+Dj+49hdJOD4AwAlgB
	y020HHVva9OycFfqY9gM2n7I01C1cR4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ALLPTejs;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775566820; a=rsa-sha256;
	cv=none;
	b=w9yWP4ANbkB4XSx6pFQirD8EcnYJbM8GzCs+qvic9T5/LWnINeU7t/jiqEmZYZq24vFJWE
	UA6+VXHe8iOrHMOL510W+QpkRSLPejfq12hBTbpbmICyBHIzX4adfrYtBcr1MrKXhqw3JH
	AqiN5bHoD9ipwIpBKJRTjCra1DLw4pI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B8E2F600CB;
	Tue,  7 Apr 2026 13:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F93C116C6;
	Tue,  7 Apr 2026 13:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775566819;
	bh=9g/6ivrb0RmDwR1PLMYmA4o5ry8IP2rIJPVEZipn8ms=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ALLPTejsosvRriKbnB0ft7zoKwKMrNmPb9R7yn9v4aqH6tALqAm59I/a0idyPZzZY
	 p0r3OE8wsv2cwLzpJkH6MkDcj8ubu4/Lor5PmhZpS7SWeQg/QesdCpek6WJcKOMWaB
	 wIWFQDp6vXIuNYzDDQ3atwxN/DLZ7LrMg0J/MKeXDrGH5CHQmk8SMXZEE3rZ74zNhs
	 oWalmvV5KEDqe893ikKqLdd0Y/VT1TuoKEuAJzm4GJYT5qOPUMgLNxwDbTlCV7feHu
	 LPWJMWFXqGKgAzDGdFze7n1MHuyTNh20mLKMK9NYA+F8MuNK5AAkNlBwh270IvLq7q
	 h+SP5S92+rFpw==
Message-ID: <ba56af16-c326-4abe-b1e5-3eb5015e14d7@kernel.org>
Date: Tue, 7 Apr 2026 15:00:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: proc: document ProtectionKey in smaps
Content-Language: en-US
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yury Khrustalev <yury.khrustalev@arm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260407125133.564182-1-kevin.brodsky@arm.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260407125133.564182-1-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77F5040020
X-Stat-Signature: 1gi3brnsjb8mzuaf1rq17rdh6mofwjb4
X-Rspam-User: 
X-HE-Tag: 1775566820-888860
X-HE-Meta: U2FsdGVkX1/E/BG9XpZ+zZAcoT0KwqYtS7cm2Wansdz5/THvkAasaGRIlF5xPS8Dg+BTPcMkLDQ+ElaKVM7SJchoLasdmzAl1bJ3Dcf7KH04AsL0JC/okdQA86u/yTXcLdn27NRFrOQqcCtO7AuJ0LyI81MjYtNtPRDGfmEpF2JEDw0nrr8QAovr2iqxfBQM45jeEfPFVPbwBkZvU2gLsZ5Q+sekAFXYfIPkPzRBeauzke7KLZn1medp+v303fuAyXu0fBrbWZh+A2ylrzMa5brAINOUeQPIJhf3MBxChXs92rdmpmTk9QsP2IErmeEFyrQNZyEEF6oVI6Dl9oM9AVjuV33JVt8CqLY5+UbTd/j38VE1THgANO3rAaS2Pb3E9FO/oPoEJX8s2vUiVdtl7PZq43CADVmK/eptrmyKvJ7bWy1UUCxUGhUJzd67jld4iY7LnY7AlaWXrYgBzSyekuFy780Q3LToux0l1vMnKVnCZxivRgpb6ILEPJCNr6bEWycNhXFxKTunlV5wuoZxy4FIephbqAwFuI2pi1+HJ7XUykmL/zIqCU6tbR5YMtSOrJ+acbseGccMk/rJRcdCtLhglmhm6asF0ljhViDgwhSSvyyu3Twa167rH2VS8pKhpfpBZNZWfs6w29wZM5Uf2hh58Vr3+1vgsCxVrumrfkNMs37X/Ccw0HrOmgjVSHZRjxfInBeealMDmXlQ9VmCXymkWf+xNKBQ4rAvpLh8KqX0/rWpMGbB/VjDXsQMnZSDA+XFp5v5IbDxTb0uIA/AzzlUAbDhIdusCFX4dJqtd4t+qh0IPdVD73IEtB0GhGOSNdddARIRPQ4L6VxybIz0tj3jW51ZYXNkP6VfiDv3JzUb4JlyeRGqnN2w0Vhhh9Nk5zIa6Q3l16b7CnE4C9GdWC7aQLC93XIvLooRV0xb/icQcIv/aOLLr43TmYw8KInusuQ3tZlylN8eH7Yg4ax
 TMlYeYap
 t0RTODFmFhpHiE7n7XeA2vkV+fYd6Hxf8PG3HIWE9muXF1c/dl507vL3YyRKiLWe3wf6NFH7b+WC74eyjJQoutNfTZhG0i8nrwOZVLJ516GG6OjsXxyVuCwqt5zrdM55wDMbFzzGoIVeXh+AaKG2wBOEem0x0Leg/bExBTiMyXXA+WuD4it33GDmBU66bRITO338ue5R1j6r+JAOmc3Xq0UIqSPOJHgCeiuOFoGPDJpZnCcxwFEmobSIKqL736Fu9am7JeAGRDFA8XfmHYDYEWDuzB4Y9FQ78J5lts1S8ygecn/K4BTCs8rDLo9pMrF26OpHlfNL/X/73S4UaponDg86RIJlolJ0hMsyhGSCEv7QbHypXEqS39Stj38Xq7rN2EhmMSHcJ8jjxztQjbtMA0QRj37sRMpQwjrCNU2y/a2zEoHjLTcyhve3CbUP0y1BrWJ+g3zjAYdsOd0RMVXp76CvjQt+o8gNGEY9/TfLtN++HauPEzW4SCMoeMMj43epg4/LzuBEfz+BoyD0AzD4ZGQFKXE9kWwyLG+1x7O5cHUQF+LyyFzoG4/94hg16zH6n8wwy96wNCyh57jZna71rKEtkGSEWdHDYnEhY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 14:51, Kevin Brodsky wrote:
> The ProtectionKey entry was added in v4.9; back then it was
> x86-specific, but it now lives in generic code and applies to all
> architectures supporting pkeys (currently x86, power, arm64).
> 
> Time to document it: add a paragraph to proc.rst about the
> ProtectionKey entry.
> 
> Reported-by: Yury Khrustalev <yury.khrustalev@arm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  Documentation/filesystems/proc.rst | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index b0c0d1b45b99..d673cad7dbe4 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -549,6 +549,10 @@ does not take into account swapped out page of underlying shmem objects.
>  naturally aligned THP pages of any currently enabled size. 1 if true, 0
>  otherwise.
>  
> +If both the kernel and the system support protection keys (pkeys),
> +"ProtectionKey" indicates the memory protection key associated with the
> +virtual memory area.
> +
>  "VmFlags" field deserves a separate description. This member represents the
>  kernel flags associated with the particular virtual memory area in two letter
>  encoded manner. The codes are the following:


