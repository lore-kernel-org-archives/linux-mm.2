Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA2FC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 06:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA1966B0093; Wed, 29 Jul 2026 02:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78CD6B0095; Wed, 29 Jul 2026 02:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68676B0096; Wed, 29 Jul 2026 02:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA306B0093
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:44:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C715A1923
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:44:20 +0000 (UTC)
X-FDA: 85040875080.15.C38D83C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6FA3E40005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:44:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=loIXZJfl;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785307458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldGQUsjYrxEBwTwWI+op/VKzxrwKI//CVrrdRcahUdU=;
	b=HzE1NS+ZGbd/eyEwwz9lu8I661fwB1Lqkk6WU2IcpKl/oOieRa3N/ZhF0cw64LdWHLt+07
	qoaTbvFxpzINIpTPPbLuTtmwn1+2uRvXFJwe8g0YSHYEzO4L3mjRDAnWA3SfBG5R9K6g1d
	dPq7gP0HhyXXWG/2tN5IDmbQ3WtvZ7c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785307458;
	b=lvHLnAblV81pAIatUlbqMrPvKNHul1m7ofPDoGXUXhkPASbIkKJow4bgu10HjpCKQyINsh
	upknSeAqXmKqMOeyFSUiZXFlhcgFik1gPNOTTT/f+mdeuE8q6GqORKSL3+iHkQxXgo+Cud
	F/wpmOyzTDHk3hTog40DWdQtiakLYH4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=loIXZJfl;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE79B414EC;
	Wed, 29 Jul 2026 06:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260121F000E9;
	Wed, 29 Jul 2026 06:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785307457;
	bh=ldGQUsjYrxEBwTwWI+op/VKzxrwKI//CVrrdRcahUdU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=loIXZJflGiBOwQl4bznvAE1zFqhML2+VHtuRbeldozABwEaQ7ESO7qM+KJ+lNHiDQ
	 Fow4c8/tIJgYvtlmgTBqAONC9TOKrvUrYOdtS+F8MTo0k1EszVf8h5u1BtJsWkBeof
	 oEmdMet1MsvTjUq7ffO+p09BBR3FeLgwR+PbQaOHSUTmmH+l5XVkjDc+asw2RfPNuj
	 RC5UxpFFLFLiZAh/fZNCn4PfOQcvBqKjdotgQ77aHsasbaOJpdRmdKeo/RlPOgjMaA
	 /KBcbRv+j8cgYPuneL99fL02ByXiSBYqAREjZ8Ch8So4TTp+yBomd6PaajqevF0DO1
	 2Uc4MLigKCokg==
Message-ID: <37c40d62-51e2-45b4-9837-a4b96d1640b3@kernel.org>
Date: Wed, 29 Jul 2026 08:44:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix huge zero folio publication race
To: xueyuan.chen@vivo.com, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
 Xueyuan Chen <xueyuan.chen21@gmail.com>
References: <4ee89c27873fb4d9e598f8a5cfe71d700ecf894e.1785300563.git.xueyuan.chen@vivo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4ee89c27873fb4d9e598f8a5cfe71d700ecf894e.1785300563.git.xueyuan.chen@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6FA3E40005
X-Stat-Signature: xdpcap5y4arpip35n5qr6cdgq18cadkq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785307458-394107
X-HE-Meta: U2FsdGVkX19yeVY14OzzhZV7jnzkEcAmXGod+WVDhWOO7uFAk0COvPPqX3wE+h6ppvwECQcR3+sgzfrXNhlYqIz9pELRpTehG8ea9NjiADk6qT9hbAfpv6c2fQguj6IlR40s0e1mMRPUJr1q6GiN6XxiZb46tqGs+dYem6mbhCCaRiZgzt3I5QAQ1mgWpAAph7R0N3O8TTK2/HzYS0lVssFW+X4yDIS3cHFZbEQsODw1N61GoEhYvIxDppbHNsHpgGsLdxRbUwOvl1sOH3VW4/m4NAkMzOMe0pIadJUMrCO6O/SSFCnvLsFgkStBSTkimSrS6BoVwkt7+2kESWNkJpBseWelIM5yY9mQAcEF2oNjhoMJ0gubxU3hjXfPgqxNTo43AYh9SJJ9j++Mln0ZTvxMh66DP66oXJR5zaKJMzrp4lSZf0ORp9wk7e8lMrXdi+UEGl9+ONPH31vlV2hYVxlo7Xo5rDIWbKRTJzUFdart1IzI9WE+zfUsMjc7XYefQw2jfohfZHf+Jr8vMFZK3LwL4vpo5u6GG01IcPBu3lbuJMx8/n6ZtfgqwXlRahKairtajcSjgJsFKchCtGclQAgtHKNTXFwq1OY55V0NIqV2w83nYMhFxeqoqwwhZ2+ZtX/I9bR272cPeM1NF3nD2jWCd/ZxhMddgkd8mh+8wuGoul7Edy9lNwgiFWIPFiPcPiq1jK39us/01JFRjuOpx219tTPfjx/1AEtWV85ZdUfT9b0HuW9S40Rimy86QuQG5UceRPvq352THCPoZtgvDH8OJW4stecRKIsuB6BPU8RJbSLdR318b5WAAEWxlJeje2fzs486AL4fgYpTcOHz1pJxYlRRB4xOBL5m8qVOfjZJPR9/JomoIAKMqBVHJo1SV6fCUz1sGYF6us6N5+rH+Asjc8JXZOz2B56eD8ZLXT98r+jmnBOQv5PpczESCmePpR1qcmkKpHFBtvEocot
 5FOnpK9+
 y38owMmCst2+KM7HcLX3pxEHtcT4a5MIxVM0aPhBb2OabiatbNursV/OIcG+yIK3OXBK8bzL8WMuYq44FcALXMqP4DdG2DviSDJbANAOZyThWmGXkVhm5Jv2gST4KBZMaMr2n5pJPjPhVvLLZTZcUA0vEF5BBYJ9Kcwon8+xRM30ungYu+HYpoWKw83Lmu8uYvUnhgJ2Fm0Q8o5V2wZSgfIJOn7ztHvpska0qQ+WJq/U1swdY20DulyxvXAMVgYSAmZWC/0d/t0kunWN3liQhgWnrFmXy3ONYEuzYOCE5DKA3iJnB98c1H0W2JOecu3YG6BOWzBRsSs7rYrJZFmYYk2e1RZSg/PGwx19Lw+Wrxp5waDepJODGxI4V+t5nq49q2hd0A1NU1RGsPsE+gxCziE2yH8Y7arRuYpUJGZi0waVq1Wo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 06:50, xueyuan.chen@vivo.com wrote:
> From: Xueyuan Chen <xueyuan.chen@vivo.com>
> 
> get_huge_zero_folio() uses huge_zero_refcount as the publication gate for
> lockless users. However, it publishes huge_zero_folio with cmpxchg()
> before storing huge_zero_pfn and initializes the refcount with an unordered
> atomic_set().
> 
> On weakly ordered systems, a racing atomic_inc_not_zero() can observe the
> nonzero refcount without observing the huge_zero_pfn store.
> is_huge_zero_pmd() can then misidentify a huge zero PMD as a regular
> anonymous THP. The write-protect fault path may consequently mark the
> global huge zero folio anonymous, exclusive and writable.
> 
> Use atomic_set_release() to publish the initialized folio and PFN. A
> successful atomic_inc_not_zero() is fully ordered, so a reader that obtains
> a reference also observes the state published before the refcount became
> nonzero.
> 
> Fixes: 97ae17497e99 ("thp: implement refcounting for huge zero page")
> Cc: stable@vger.kernel.org
> Signed-off-by: Xueyuan Chen <xueyuan.chen@vivo.com>
> ---
>  mm/huge_memory.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 032702a4637b..6c74d0375377 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -245,8 +245,11 @@ static bool get_huge_zero_folio(void)
>  	}
>  	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
>  
> -	/* We take additional reference here. It will be put back by shrinker */
> -	atomic_set(&huge_zero_refcount, 2);
> +	/*
> +	 * Publish the folio and PFN before making them available to lockless
> +	 * users. Pairs with a successful atomic_inc_not_zero() above.
> +	 */
> +	atomic_set_release(&huge_zero_refcount, 2);
>  	preempt_enable();
>  	count_vm_event(THP_ZERO_PAGE_ALLOC);
>  	return true;

https://lore.kernel.org/r/20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org


-- 
Cheers,

David

