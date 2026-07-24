Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77341C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 19:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC806B007B; Fri, 24 Jul 2026 15:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D4A6B0088; Fri, 24 Jul 2026 15:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24CDF6B008A; Fri, 24 Jul 2026 15:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7AF06B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:33:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6ADAEA0209
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:33:20 +0000 (UTC)
X-FDA: 85024668960.23.4529394
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id AAAF380010
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:33:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mrV4McV+;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784921598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+yfvATMic+BKWVIuLG5IXdNvMRF1eXhPJ57UEleZO0=;
	b=gP+TUn1loZFerKiI9SBFHrdSEM8q12O+/cxICBs/AfdIsCLCtFA7kRfQq7oULjP4lT1p2O
	gTHH3GMoqhJf094LvuN8mF5U3YEv62fPdVQ/T8m7TwfW4sBmRnyIgZIQkhKloGHBZG/v21
	iBDU+jyN6op6kUw1ubp7wxcoT7RPdBs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784921598;
	b=oaScCCw88DokLX6iGtacjkcE/vzKvaJCIVyY8X0dvgJHclg+H9Iivfdbe1rFAKTF/FjcxD
	ngXzW4rWzbKojNEio1lOBoufXe0Zoi0DkoWhNuCv3u/Tzu8Pf2bDzbAGThvsWoYDHFSfE8
	NSmfa17+aqibhiCp302g4ISD5SuQPzs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mrV4McV+;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB27B600AD;
	Fri, 24 Jul 2026 19:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECB01F000E9;
	Fri, 24 Jul 2026 19:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784921597;
	bh=g+yfvATMic+BKWVIuLG5IXdNvMRF1eXhPJ57UEleZO0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mrV4McV++LYBPA2wdOWIMD6CTMowhIozatGOKP7LRSh0b0IpmwMLUuLlICDbf2Erl
	 ON75QTafujLOA/kI8YDCs4NJS4bcHlC5UusZqRKmFgVa9jr3ErS/TJCcphmpHfY5DO
	 0LoNMtI7QRP8q6Pt3ftH7lxMkuMA2SB7ez0HculzHzwxZ6Zm4b7WM81a8GTsgtoqmj
	 Zdtg0FnrZjdYwg/Y9WN2Om4nDFxM6RbjVxbx/UNGwOsnZttCpHzlVvh5Cwq8+Es+5a
	 AHtIzcTNY1A7R7Gl7Rnaq8jvcTb5Ehfz0oXARYu5GugmBEL1X5t1eqdw7Eu1j+S2Aw
	 upd5w/RTVZR1g==
Message-ID: <10c60511-c841-4bd8-aa5f-0d826b676533@kernel.org>
Date: Fri, 24 Jul 2026 21:33:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: Extract non-swap page handling to
 do_non_swap_page()
To: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
References: <20260723030752.16979-1-hongfu.li@linux.dev>
 <20260723030752.16979-3-hongfu.li@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260723030752.16979-3-hongfu.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AAAF380010
X-Stat-Signature: 3g94rp13fs4x5wbf739r6aybcdpa51nu
X-Rspam-User: 
X-HE-Tag: 1784921598-908880
X-HE-Meta: U2FsdGVkX1/pCau1oBSZhJq8QRouKzWLbt77BDMOoNGFSzJTBIrPyc6HGfU6ORFBykED4BZHJfq842kUlUkE6muMe4bR7UCQQAqeVjqYFPnUl3wLgShNBN7De8Il2vaScqyVOK8q0BsPMYsT7sm+kipomHEeDocyy3CDwHb1+mYd3hJ2k0fYM8DvpmuszmfUQeK2pJrKVT9o1wtbNz9Y3+FgNLUWeFcxye168XKCJxI8FuxOJodBwx7Sx/YFLcPNOG1MXK/mdfH5NPPr9NIcIP+11P7AIIXKmOc3MjH3RrqnSFAyRGsz+MakIuHXJGoxz9cXMMmYI/LWVFQZRnA3rfIwV6fc1ZWrUE5TmvzOnm0D1Zh6huBTZGsHhPx/ohIN3U50md/qC9u3G9XKKUNbADKLoAPvqPw3SUfq/wGYFZ0LYA6vSzvnU4aOVSPcTMXHQ+asuZ7lgSysM0V9nP84dzQ8WeBDa3PZAztdsbMSL0iLoWPclHNWdzP8xX8RaOrvLU9AZvMsvQenKLMVXdiIGZNZm4ROCTj3cqQJUu3tFROZmlECmKehOP+ZZ67gISMg5gjlO9n/3k1H+5Tp69DtUYZxyLtr6iy12fA0WvNTEnKkyA5SlVlcdyMQMsYMdf1JZ5QOcEQdBxeLqythdWfQ/66KLGaabrMdadGpmgAkTGgFf1/ChkG4CPJKm5J6h5mVGENz74wcAZHQ1yV+dDWVIgkDrN5NvJVID8fPVS9OBUBOhgXJUM8ly2qd7kss0csDW+MdJj+7OKl2xjJQMsJSojOats4nbh2A8Quq6uCpIfYJqYxpd5/Il2He3wA6nWnfLlj80gKQiVdwliXosDXGx16E4/ry82jJ1qERh3PP8StZN+mnNOQmYXzxDsILTUqZ+2EoQoHxZWy4edTuPSvTzrkEF6yO45k3IO1SIIg/QUR+cIKn61hn+6w+ZiT899OdmiFFnZDFm6RKV9yfWsE
 uFbhxtG+
 rrcdRLCcGOhl6wWJUE+16/exNRamzpgod8ELYae5dp1a+Ejyab9Kc9aEp3FCATicpt32qLZ7sSE8ZGaejYluewO9l9lzLvknEqU+I8+XEFwHHyfW/zTE3urisa1kJSm1RADDxnMO+Jc6t1U7q/sS2o8N3dLreHL9piLwBHYp9vDLd6VtJWEtms+jt8mamRUiC+277bH7a26BXSNMWQnBRDFe7F8PuSmp767uhZ9z4ceez/PjzJ2dZPA/viSmM69E4Jj8xG+GhvaA59FrGO8gdVURIeAolnKTKIJpRLzvPO5I6uNByt433j0kX2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/26 05:07, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Factor non-swap entry logic out of bloated do_swap_page() to simplify
> the main swap fault flow and improve readability.
> 
> The new do_non_swap_page() handles migration, device private/exclusive,
> hwpoison, marker and bad PTE entries.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  mm/memory.c | 120 ++++++++++++++++++++++++++++++----------------------
>  1 file changed, 69 insertions(+), 51 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ae521baa8c84..50d8e92aef91 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4815,6 +4815,74 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
>  	} while (--nr_pages);
>  }
>  
> +static vm_fault_t do_non_swap_page(struct vm_fault *vmf)

We're handling softleaf entries that are not swap entries.

do_nonswap_softleaf() or sth like that would be better than talking about "page"
if there is not even a page.

But actually it should be the other way around:

do_softleaf_entry() [currently do_swap_page]
   ... non-swap entries
   do_swap_entry()

Or sth like that. Then, maybe in the future, we can just move do_swap_entry()
out of memory.c

So we're factoring the wrong thing out in this patch.

-- 
Cheers,

David

