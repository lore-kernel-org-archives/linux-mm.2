Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD36CCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34C138E003C; Fri, 17 Oct 2025 04:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323418E0016; Fri, 17 Oct 2025 04:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260228E003C; Fri, 17 Oct 2025 04:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 137F98E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:10:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2C5B1A0598
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:10:16 +0000 (UTC)
X-FDA: 84006883632.21.2EED54B
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf02.hostedemail.com (Postfix) with ESMTP id D261F80005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:10:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IxHrI8yk;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760688614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4g7Sz/sJFHpZPMFxNijrb3z0sAlp2EIUfkGGeOKoiE=;
	b=g+GWaod5RjfFE37q5LdY7mgnI0KUGMi+zVnotLuTI84hdix31iADtTrzOu3lvKKKDYUWMK
	EY31Z7gtH//WF8muDvNbw3QupQcTvwQ+KKgS494P1XxA4z35IssMN7bagW+GwB+k+P9gSW
	+tr+hUum7IGbFru3pDFq6MkekxwuRYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760688614; a=rsa-sha256;
	cv=none;
	b=kQLv2SX6B/AUFf56zF7X5lwM381Tv55jR89MzU0xS8QK0kTCRg+Eh8NRHzAWBy6L8hMe1r
	QeDVYC5oD/DF4OhRA5EMK0OxoMxxiBxo7CdBMa92DzSw8sNUknxrkyuZRqrj9SmbHcpDqS
	j3m9PyR3zdO8x4PzLIO5nyPvu6SvBEk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IxHrI8yk;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760688609; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=N4g7Sz/sJFHpZPMFxNijrb3z0sAlp2EIUfkGGeOKoiE=;
	b=IxHrI8yko2v5XfoiRyf6kJCqcYvmG1C5r1xkTnEnZn2958nkgwfjAsJnrAnJ0ZHIPwjsWUjYv61EYAZla9ihWTnFTkKNLX/Rm2+STy6E/Vj3GV/kpchg4+jD7dRXk7rpd0i3ktghQdS2IeA9VD23ytfb53DBveja4u/K2zf5BmA=
Received: from 30.221.146.57(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WqPArJo_1760688606 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Oct 2025 16:10:07 +0800
Message-ID: <cdd47a33-d0c5-4e7d-a210-fb3236e6749c@linux.alibaba.com>
Date: Fri, 17 Oct 2025 16:10:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: guard is_zero_pfn() calls with
 pte_present()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251016033643.10848-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251016033643.10848-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: imfj3urhscma6hefbz5iscn4r6o1u3kx
X-Rspam-User: 
X-Rspamd-Queue-Id: D261F80005
X-HE-Tag: 1760688613-935164
X-HE-Meta: U2FsdGVkX19X59BuV340zcg88z3j5IWro5/n9S79DEImMI+5UtUqjJm89nS/s2fAmULSW/Sd1nQlGwh06qEZOUEWtGG23E2r34HqOVchtrfsIeuEu8FYYsxJ53r45XFI84Te8J2+g4qMfUmhvGNX94FhzIa0NMWfm8Ffk62u4ZB+VhN7RFtYnJ7s9K8J8wMH8NTykhDSPFCpBUFMA/LA86UHgPt3M6y1L8oiJjMBZy87CMdQVIGm51YAr0iW45oNyQwA23592rVjwOV/Eavf6ddMAxijf+3vM6WeMWpMi/2mUPWHJTgz9IBc5+KK/MvCLgTXCgDHveVo6/+lTD+UsPygkv7QcBufdkFUN0xtTalua77ZRNv72EuaUixY/FcvO/5NWOKQCdDufxhce4VF8yQuzrmxPTRxKJC1cASlgK8tvIZCTRrnSv142W/vAWvHz88dVacyOwknUHXzQX4HK72atOC9wqyY+RHuwO6h0zX6merO9SaS1yVM7782u1YiFzuYKhDVXWBwojeEXyd+gn73C+M1OBr8m+al1tS0TEartRDgxZ0LVsMRay3FSZEBX0UcTTS6TzcV0m4zydEYFs6fNJY5zWpkTS9i+BhnhltxF+IjFixerpDtZaVuHI5NNqKc8B9G6wsDqpy6P7dWk+V5CDrE/Egs5m6sL3mLfwnlvccY28zH1AppEJh45rYHyvtOmnkGZfbQ2MENKstHYxNYKpnT/LUeG4Riwu4tWrh2+y4fn+2OUbnCZx0yslBNuvuOlkg9wEU0NADIw7G2+uynmE37s7yp01GxxW7vGHPdPCxh84tD8fKo11NpeggugAt/X+T8p6ZcmQTg+YrXvX5J/a/gljPfgJHN0O1eg21H0wrS8GCMpCwZbo6NaFe25X2RFf9KcgZqFmxXEC+juYZ9sh+HKxHQKt5VLhhXe7BeurBuwWE9g6D5im0CzcexUCY0iFDUAgbhWurhRir
 2BQGba2J
 Uw/npel0xvveJWrczhAJWEbhxgPCGelPlhpzyvNCBdUCGLaA0TGMYrfty4FRATnaYsYJGJNV5/SECuKEx73+Kt+drokRhn60l5qwT52ixvwRImWtLENEjUjOuwzVphuNggi6+a+L+5I206jMhqsSFi+xYwF+xI4xe5leJ+SIUoT0AccDhP7sl07WeD9SuXh80O06N6IR92K6C8vKF2kx1HGFCZpqETjL1dden/5AXgevGfeiPMFLt7oWPjxXg6ViNRd/8+xJ4qv6pPM9N4hXnCRTfK1ffTnCQFwTAtK/r8ylt83AetzvTwpl1qyCE6pT6z3mN/pPi8k1cA8YjiOgO1EfhCQsoyWrRMBm28KJY/6DudYtns8SmOTOAwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/16 11:36, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> A non-present entry, like a swap PTE, contains completely different data
> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
> non-present entry, it will spit out a junk PFN.
> 
> What if that junk PFN happens to match the zeropage's PFN by sheer
> chance? While really unlikely, this would be really bad if it did.
> 
> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
> in khugepaged.c are properly guarded by a pte_present() check.
> 
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


