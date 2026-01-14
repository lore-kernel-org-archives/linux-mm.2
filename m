Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24418D29FEA
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BAE26B0088; Wed, 14 Jan 2026 06:52:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8680E6B0095; Wed, 14 Jan 2026 06:52:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774A86B0098; Wed, 14 Jan 2026 06:52:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6684D6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:52:33 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13DF9140498
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:52:33 +0000 (UTC)
X-FDA: 84330406986.22.C088AD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5A90720004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:52:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UxU3OWR9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768391551; a=rsa-sha256;
	cv=none;
	b=r4gv+VZ7V+jvWDdLRaVamIcR4TnXAWsMS2sugydRkmamFI+Y9pcrS6YboHZJHe4UHMYE0M
	CyLt/xqG8GOZnWhvBCQdjMWbCBFhrNotdMk441Jp//AzSvPC6y4kFnMRqmQ2N/tNaOwncJ
	7RgYoDE42oGxmuAnZou2fc2ncNrirt4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UxU3OWR9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768391551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srlfL4EAmrVBIHfNs27efwouxlLCsobOT7w34ftuLNM=;
	b=MnrP020PNnsYCI/rIJ5Gi+HialyVBwWCfVwuIGUO7dGbj89K1Cv8Jq6BF8qVWthf8MKdHo
	eNa2BApnoQtABMWLEDw3gxYzZQML6ty1Nikqj73yCMiconSNfueAX/C+qGMLTENVd0CUIa
	n0fw84a0vBD5O4qJeCnNsNhOWpTQBCQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 566AE60051;
	Wed, 14 Jan 2026 11:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8111EC4CEF7;
	Wed, 14 Jan 2026 11:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768391550;
	bh=33vRWlOtTN4R1C92KxnbvJrI9lpg6dDHrsl7EwUhX5g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UxU3OWR9lM9H/IeeN8bFNrCiPZzq0kmr7iy+t0ZZ590kRerb9L6su0qZTtB6m9WVk
	 eXxXNjUp9VxtfqT9LCfZEEmyTm1FqO2W8bibGyDlLEEfhcp5zp2Kc6dhEGKWzP/0vu
	 OqTaNSygdpoHm4XXe7ZcHMScYs5AQw12cDkDKK8kGKjWJDPdLeBwE+JenUfZDvQgzO
	 r5j37ycCbyWrHJU3OdvmaGCdGUSQJOTIP2VHnp73nOI3HFA3xBM7NIqKfoLLopwAXO
	 Fqw90yB1p8E5z2fjXvorUdr50mtJyrEOd0CHiTpzArOKKfG5hL3P6SnrurNyENXPY6
	 EvkmncE6ozHmw==
Message-ID: <c80d4095-a72c-4830-883e-93ed18600a2b@kernel.org>
Date: Wed, 14 Jan 2026 12:52:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v4 6/6] mm: khugepaged: set to next mm direct when
 mm has MMF_DISABLE_THP_COMPLETELY
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-7-yanglincheng@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260111121909.8410-7-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5A90720004
X-Stat-Signature: x1791cdws3io99gt161jwa4s7r3wn8ay
X-Rspam-User: 
X-HE-Tag: 1768391551-818178
X-HE-Meta: U2FsdGVkX1826me+wfKiUN5Q9AL+xz/Pm0QHNyuPxBQ8FxHk7i1u9VhENqcxOFEkik0vFKAg+WJ8wVmHDYgwxcLMTeax819q69WdF0vklYFWfCO4UkwnJsDNSZ1phjzD621KybLpz2coQjDBmO9hA8OUCP4dW5epTp9iPKsOxcf4oRgYfJgFfSjRJByYX/+ZZZlj2ZACgGFyzlfkbT9Y4vt7tLBMhVVgmoloJqngD8q0SOVZm7SbRcLsbaTVaIawGFgqR7s1+zFY1VizGnu+k6srV3BXj6orMnqgZ+Vlmvp4olT6wdIaLckjNTSPb3AsWmlTpKYZr32IK6OI2U1yL/5tlfxV9+wh1Nud5i3R1vA1Qa93GMEehFm+Yue3P4DL5X9QiKGH99Zc9CwPwhvmiZUHqxc6S7WOrSUszWF8RhmH4fEnuLeGH3S59NGlt6hq4QDzV4GWhLGM7PYSY8xMVaOmOAiPMAOnoQ0CnYKFfe6tv8N+0iu5wy5Pv3reHeCTiC8WragnFyMiPOYzkXdmm2RKIhEK4EPlDdOrZD/x9KHV34cAzuR5o40sVbgOQF4yI/V0bsmq1gam1Uh4z3aH/Cwm/NnPxPZGOg2MvmLGjq5+aCb5lppywiaYJlXS/+/XCPgep318BKoN9urpvQgifqjGdMJ1464BBblQdL2uFK6QrWRtCK4/CXawpcfJy2sL8ILO4IrmJd1obY9pyFs72ziMq/2JALvnMPBy1xmImMRWi7t9VKHk6e28n/VqsDx3mOAIWPzsr2WdNJZUjUtw8j2ikqYeWaREn5Qe4RpfVMlYSVS0Ggi5O4LVqwV4fK6Bw6TkKwIHlvnZJ+XT3OnMNDGW2+VswWOScy8iqzM01IT9SuRa3lsXFZ1AxPJktriJDXSAytvIatIndg2/CvR+NcLv1ARMaLgqjaA431bHwLyh3Fcvp0BBX3ICJjfGaAivqwsgXgcmHtZKqtvUBm6
 wlvNwjd6
 EdtmrKcy2FnYe7wKq6TuV0BIU4mWHEUrObm8ppor6t0fKlCCK5RpbuXZOwg6B59BX2ZVSDm5oVnju2DcKV/Oa7F765urlLTgZbvWUMWJvUnFQLQwbAIPxX0D69yj5UGDuQh6JkBok1RlHRyW7XhpXSlEa7JfTFosyolKy3esKhQ2sQVDuBsyyNMthY7lQ/U/aOlQtIQ+ixgysHg+Hv+KwerTLWbJOQtJsKMWOdU4XKoWDKgHI4iDj2AozLQvFNy8C4NpNiA89mh7z8jc45YOsvhzF/LIhZB2zB5Oo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/11/26 13:19, Vernon Yang wrote:
> When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
> scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
> reduce redundant operation.
> 
> Without this patch, entering khugepaged_scan_mm_slot() next time, we
> will set khugepaged_scan.mm_slot to the next mm_slot.
> 
> With this patch, we will directly set khugepaged_scan.mm_slot to the
> next mm_slot.
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   mm/khugepaged.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8a7008760566..4c055d6c2717 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2566,7 +2566,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>   	 * Release the current mm_slot if this mm is about to die, or
>   	 * if we scanned all vmas of this mm.
>   	 */
> -	if (hpage_collapse_test_exit(mm) || !vma) {
> +	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>   		/*
>   		 * Make sure that if mm_users is reaching zero while
>   		 * khugepaged runs here, khugepaged_exit will find

collect_mm_slot() should do the right thing when disabled and just keep 
it on the list.

So this LGTM

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

