Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60B710ED678
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1554A6B0096; Fri, 27 Mar 2026 09:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D096B0098; Fri, 27 Mar 2026 09:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A806B0099; Fri, 27 Mar 2026 09:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBBA66B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:22:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C5071A0AA7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:22:46 +0000 (UTC)
X-FDA: 84591907932.02.FAFC927
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E615F2000C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:22:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ex/9UeCU";
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774617764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vsjYVMqb5g+nmWqlJUqESf0hXzZUYFP3gQ3eri/+E84=;
	b=zr597g/xrSmKDHUajPiLHivsIrustCgOuCjErDBPdDaaCnIxVUlM3LNgBiXzij149iXl8V
	H6zwkSVtGrhhRahjOJ5W7TTtA8T9zPdFv2kAkqVRoY5LkCkZnRPPa093grIVQxlh0U1UYM
	sU2ULFUvJOYSw9y7cnDY+mq5hoH5rQw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774617764; a=rsa-sha256;
	cv=none;
	b=yR0wyYDl2xV/d6IvoigJES1t3IrM3H9YPfRVm+3DpBw7XR8muGHEzdT0FwHtvqqf2tERXG
	nI4k8drFhFFMl0rcwVxWfXAJ5Ob8RG1IZdlATq1wZRayP/IzBLHaKdRIcEh7FEXinoE7k1
	cbLSpggL3WB97boxjXsCbOiJX/76bsQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ex/9UeCU";
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2170460134;
	Fri, 27 Mar 2026 13:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0ABC19423;
	Fri, 27 Mar 2026 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774617763;
	bh=tv/lTBUdqefxHqpzY+3tzMiQfVgyoSc1pxMuer+8knE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ex/9UeCUI5A4vHqDeaj7WE4aTtoQ44HxUcfQ3tNiith9MHs1L3QiN+Hjv9gjJ24vh
	 noYiJjDkCb4SZZ7Sbz8ivKYX2s3woo4drq4CT8zZJa3zmfBcB5BXnqE+udbUIEgHiT
	 o3zvpDFSkiuJA+N65GiGsx98CCmTjpb8pa2nw734m1b6XZAi4T0qNSQPSGT1vyZf2o
	 qKlMtChFR5OL5qUkxy8Lo9DbUHxZTuOmrxTJ/GVcWxZS/5lWly9ngnM3K/pGUbAAo3
	 +NR1bbukSNIL6u/NtzoDKuozdVz6cG3DujCx8T6s+w3/5Un4jZc0jo/5bCNYROYQmA
	 9vRBEabfzWk/Q==
Message-ID: <4d2d94c7-68f1-4f9f-93d7-9002c05ba6e3@kernel.org>
Date: Fri, 27 Mar 2026 14:22:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/mseal: update VMA end correctly on merge
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Jeff Xu <jeffxu@chromium.org>, David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 antonius <bluedragonsec2023@gmail.com>
References: <20260327090640.146308-1-ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260327090640.146308-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 1uxoqo91cowzdxc7djrkfmy19msqjndg
X-Rspamd-Queue-Id: E615F2000C
X-Rspam-User: 
X-HE-Tag: 1774617764-940235
X-HE-Meta: U2FsdGVkX1/GEwdwPPNxJmLHF35N58WeyoIvxiI7aDzJ3YrF10+orlTFYAeuq4fjgechUNqXu382yd9WDj8/M/x74vQ2u9oFTQlXx59pLsFGnDkAA2hqovw6sXpdTRqbw85irmRgE24pMxg96wE6bU+tTpPXi78nm8VWcWdvNwiYGpwtvxYKtTocqNps1sC4L05Mbp3U1ST0hUEIblwD4IJQpn8Ty8GiRoE9ocJRpdIc0reNofm2k/6sOLprU7wEWTqWjExPOS6uJ+g8xsF66fkKoHqYoqZMhlJqNDez50j12/LhIP+P+sYkLkR7UHSve7Ck1NPSBYvN37rxNAls779RtvmmcujDnj0jzmlM0KY2uEBGcsT7WpKnqAYe35RIOJlxlcj/6pTRldtiWRjaFiA0vT1uc1dJ7As4aglLCe0b6cWLTmXJNjJviKjM1XPm4+d9VR3SM4RdJU1YuXZKwDcip4bh7jWBchgWsUb2SzqyGANWJ1/V2md5zMEH3pXMX4/+wmquDEELCzp/8R99eHJNa4GpOiZWyS1GzOLTR6mrLHHB8e7AybQFKpM+uHa8Nl3MoQqlei30it0YPABo7pqzTyr2rdERxMcTgcXSvsTvd9ZWSWZqh6s41RKE3D1LQnQtaohDzv6mEH5nMnaxlRhmx2FqP5EuqFlmPIhfEyAtmUd5rbGOSUnYPcv5k4shi4B1f5tjVHiWAPy/nzVnStEHQTpo7Xeb+DaF9MMMkWLPQyCXz74/rNc0dG5NWu5DmMvmR/AsYMyo7Wzz42j99VJk1bQ7zBe0ROJCTVZBuux3WyeO8zTJFv30Sll66epvtZlxyaIMAnjxTrZmpbA3vqXz1pXsbP0vS7QhB/ChE4jHqPoqJEvfILjUVscmYGWEqqW0bUjaPXZ/D4fjat6QI6o3nXzBG32Z2JLZthVgVMnEjJp+R4X8+rvH5M+fWg9wiaOQG4NmAjV/0SXr61t
 x5m6zNwv
 MMh9MQfhsDHSTVFPhkfGLA/U2Y1loA7/H1hXk2W1RhNHv4ewhm3a/N064h/Ec/GuUQuojMhhmBZ2vAC59pDr9/QQJAKklW58ycs2lAMvlDQ+AK0liCQCE2Ozm+WiPmgthbqS6H8Crk0XKEo2PHChvTJSXCSEoM2x5x9CABRgyAcR2J+JItI8p1shW+4J1byyEfeomVhsd6X/5+JRnFismqEW+iPMAmKoyJ7qisALRLw/QOf1XxMY1U2pRTYXAN4z/TeLBumSh3et8+b/P3jY07/48FuSbyOznCCVf3jIssAyzyrMYTD7KYXfaHUJPLuAOPNSx9vYCAB+D2XvfSYq1NFTccdlsQTNcA9i/WwJIExt13so=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 10:06, Lorenzo Stoakes (Oracle) wrote:
> Previously we stored the end of the current VMA in curr_end, and then upon
> iterating to the next VMA updated curr_start to curr_end to advance to the
> next VMA.
> 
> However, this doesn't take into account the fact that a VMA might be
> updated due to a merge by vma_modify_flags(), which can result in curr_end
> being stale and thus, upon setting curr_start to curr_end, ending up with
> an incorrect curr_start on the next iteration.
> 
> Resolve the issue by setting curr_end to vma->vm_end unconditionally to
> ensure this value remains updated should this occur.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Fixes: 6c2da14ae1e0 ("mm/mseal: rework mseal apply logic")
> Cc: <stable@vger.kernel.org>
> Reported-by: Antonius <antonius@bluedragonsec.com>
> Closes: https://lore.kernel.org/linux-mm/CAK8a0jyHXqBpt8Xe8v9SNDbnRiwz7OthA8SKY=NLRY7smPEP3Q@mail.gmail.com/

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> ---
>  mm/mseal.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mseal.c b/mm/mseal.c
> index 316b5e1dec78..2d72a15d8ea1 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -66,7 +66,7 @@ static int mseal_apply(struct mm_struct *mm,
>  		prev = vma;
> 
>  	for_each_vma_range(vmi, vma, end) {
> -		const unsigned long curr_end = MIN(vma->vm_end, end);
> +		unsigned long curr_end = MIN(vma->vm_end, end);
> 
>  		if (!(vma->vm_flags & VM_SEALED)) {
>  			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
> @@ -76,6 +76,7 @@ static int mseal_apply(struct mm_struct *mm,
>  			if (IS_ERR(vma))
>  				return PTR_ERR(vma);
>  			vm_flags_set(vma, VM_SEALED);
> +			curr_end = vma->vm_end; /* Merge may have updated. */
>  		}
> 
>  		prev = vma;
> --
> 2.53.0


