Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A68B5CCFA1E
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 09:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E881A8E0005; Wed, 12 Nov 2025 04:51:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38CA8E0002; Wed, 12 Nov 2025 04:51:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E568E0005; Wed, 12 Nov 2025 04:51:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C44208E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:51:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FD8512D048
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:51:17 +0000 (UTC)
X-FDA: 84101486994.14.A204C0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4B3FDC000B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:51:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cGF0bBQ5;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762941075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CAJa9W3VI9OuEv7/qMBL0f9nyMqovTpBV8OIF7uksmc=;
	b=uJSoVai/Skre63Ls+5lFXUWkCuteoOdSYlh4inMisdoQ7WAzz4g/5JU0dLupEPooa3UOwn
	bHJ3a1J5gMgVgt9btvdOgSWu3OCMcEsDMu1hD4r3zgV5ZMQmtcojQXlxCk/7Y7APtwpqIm
	UodsAyTGy+b7Oz+KPXVRu7mgHc9bzO4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762941075; a=rsa-sha256;
	cv=none;
	b=CIrJoh7CH+8Pm5f2s1t8u9hvqd8lK/NEi1JWXXSurPgTRQmLIteXKT0Hsh09lbXObrdym1
	Hy8+jaMx40c2+31ReJKDXo7s/gv6OkLvLyLJo9PHSdR/r1wK2kohcqVR+7qSS0GtPZWIcm
	fKmIhouxW2A+MnSIROlV+DodBZBacSs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cGF0bBQ5;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FAFD40890;
	Wed, 12 Nov 2025 09:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A205DC4CEF7;
	Wed, 12 Nov 2025 09:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762941073;
	bh=5DNNIM5JOi3pB9R75Cu9kw/Z1+FNw7/8QVM0PNSGv8U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cGF0bBQ5POHNgluCLqf1ESBgAEJqHROfJwHuFD4B6zmrjJgnMU9n+Gz4XX0D3zSrR
	 +ZRdm8hKsqyq1zYytBgQROhLkGiznpz0fEC25iRRJXnmO+VFMyYmcCf1Hw4ywl1NiU
	 rdTVDfI5JKLeQ2eMlnF+qDKl+KH1qGeBJ4dO7EpdAx7MbeGZLcdgTeH9c/OwfP893k
	 BQtVJJfph1nAiiWXG47QXZM6ZVctOgsF++eqV9X2ecapCmJROoya6dTLrglophQM1k
	 7H2rYbMLHjRR1S4maWi04YHY3Tt1+S2BpjNzWvmRikHk5vuhzqYxOWmwYKpMqNVO0f
	 q+Lg8Z+SUD+Wg==
Message-ID: <04e8e813-b43b-423e-8ad9-fb13ac953055@kernel.org>
Date: Wed, 12 Nov 2025 10:51:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: continue to collapse on SCAN_PMD_NONE
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251112020031.25350-1-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251112020031.25350-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n7999pzq8f9su16poj59pskazfzegyo3
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B3FDC000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1762941075-763055
X-HE-Meta: U2FsdGVkX19xFdXlKhQrZIh4DS3tsXBHz0X8vCxtkNWFUWYSMtGYEeJsEJqWTQPDnj0ts93kxl9x5S6L6MyLxDhC2I7cKq78OyGdkBRcfJ0Ytwy8rMEGV6wM1J6WPu3q4mzXooyKWDDcBS52RpVwRZ2wHUK2Y6gZgNMqbYdZIKMQiGEAyDp0PQo8P4+f4JO0mNO371vPLWi472GZW8/HzgmkRrP8Z1/iNpBjytsZYzIHxfjkFJgdyMknG5Z4JoUCCvj9HsdiVdcnNLvkhWDXeg9VjVoRsCZVB5FtAP7Pan6eNi7+G61ahirKM0GXWKCUXmSLiQix3xmoF6GKJYelodefYMDjH7MOqWmEQPFNJQ9brKAlCFv1Od2oJrvBBSa1o+jUo6NsnCCpYo8q+xhy/KEOTl7szl/BSTyhE2cOpkqFiybn3QRtIpDK+C/Yoset3LVQrCEJVS9J66cmbYKC2XRhP/EYC7htnQ5D6+5t3iN+b6j/H87+2m4APrCypdbcicvGKJaaDnj72IQreG4VuGK9SGgt7AFiu3CsINZVL5cDvDW1vnUzq/OyVN4377xBVuA+u1AQHOJZ5MH5tlFwLlXeCYrqRcSyZUDvCWjRMpMJe2mitwfTJ05HyTvfgDSvUSOtFk2gJrP/kKgbnGe2n+dfZT4iEZN7vbQ2XaIwFfMVvqp5FSp3zMAz7U/CMn6fMlVV3gT3A8S2UbR66tgtqBrMOVL0faOc7a6TDNHY0wupQ832F3eYwLvE+ngoeGpW7EhrYssjkxix3dnpg4qiiRSbS/2JQHSFvrWD97yacEgQ/6xVYMVdHI1Tulls6JjejUA/kxpS8Gga5VG6TXrYhyYvFe1FvjoZZJ/UZ4A+6JmbRdr8wYit4RjUKZnJpmU5LdbkLNlbBNicOvWw3+cqHq9TtzL4XORyLCo1XYniwdS2xjCsMwO53ujzuwMvxx/D5/sbDZJP5WU3raCPR30
 4xDvCOsO
 Dn4+m0Xqs40CSII7VFM3DgEQhraAqE2a7JS3QN4jzRBjMt//8AgrndriJrjauq9NSLy6xWUT5qBGFce7RIAORh7pj1H2vxEDWl7IXm5oW1sFmlf0NdPUcLrq2WshODUshmX2LFqc+Qihd5J62ojflGxGrnBwPH55Cchz4DdF0XCHfx8b9Sf4e+Sou1X5Q0VS5F4JNtxwWe57ATd7OiHWya+iPPUPS+qv7qP/tjj369j8wkaIREVBQjMS4ShDCT2vj5Z4bA0njlF/rGXR2Kag6iUxpGGgQExofnGjDNqDMFFfc6iwmk0PRyVDx3agkeDee6SjGpvXWSNGEg4xOOhpG30oqv/hNbmQ1eusqCAppYusT41UIi4al/1oiTZrjYT3XjPkas1ZnTNBxwk9yGK73YPyyeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.11.25 03:00, Wei Yang wrote:
> SCAN_PMD_NONE means current pmd is empty, but we can still continue
> collapse next pmd range.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>   mm/khugepaged.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7e8cb181d5bd..4c2217076ad3 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2835,6 +2835,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   			goto handle_result;
>   		/* Whitelisted set of results where continuing OK */
>   		case SCAN_PMD_NULL:
> +		case SCAN_PMD_NONE:
>   		case SCAN_PTE_NON_PRESENT:
>   		case SCAN_PTE_UFFD_WP:
>   		case SCAN_LACK_REFERENCED_PAGE:

Looks ok to me.

I am really confused about PMD_NONE vs. PMD_NULL.

Is my understanding correct, hat with your patch we can just merge both 
into a single NO_PMD_TABLE or sth. like that?

-- 
Cheers

David

