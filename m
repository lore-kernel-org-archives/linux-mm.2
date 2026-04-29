Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F40FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 08:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7076B0088; Wed, 29 Apr 2026 04:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581386B008A; Wed, 29 Apr 2026 04:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449CA6B008C; Wed, 29 Apr 2026 04:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB346B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:55:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8C87120758
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:55:31 +0000 (UTC)
X-FDA: 84710984862.06.C5700D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id EDA1CA000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:55:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HBQ+lea/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777452930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/sSoYCJ2qsyMbietd6v7wzJ6lohiA0fUmkJWlRdqqRk=;
	b=cqubirfq650zSyjlQ41VzD5xtwVYKALxPYI1gOJRjWtI90c60MHp9HQ8SwErEnLhEypEBJ
	2OcEiP8S8gZsevHQM5tlcHPHYnX1mrFB3zc0pgpoqJcuoy5y7deW+Cp2sYFXAYgn04sjLc
	G7RBPxqcSIiBokjwMVwh1uiegyG4/3g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777452930; a=rsa-sha256;
	cv=none;
	b=yibIwKyNuHybMaq2kfqYkP7vdMoZ6KzU66LQsJoVxqGCcGX8TpFw06CmQZg+La+xpI6gWB
	VZznlHytylm7mIGYC13ZnVVR19IUOnxMiQtX8kHhWDPSQYr6LBTktHYfiKeeU3RHeZZrBZ
	Em+ZR3gS0M6X8KwsYVpcS9IPqYguiXo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HBQ+lea/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 45B5860018;
	Wed, 29 Apr 2026 08:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA99C19425;
	Wed, 29 Apr 2026 08:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777452929;
	bh=BYAsnMF2Q55jJ642xlk+wrPGoiz62bmXpwIrT3ZZNS4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HBQ+lea/rcWyMyjYxlVolA7RNQ0wNGKl2KxlA4SrA63WSTuSaGYpS/3/MQ4E8HsNO
	 BPqCSZyVWNKJJxWhEXuDCUFOICc2F/ZlKoNMsqJW20VhdSKANlhDuhNelRnbKDmiHf
	 sTx3mMCM+m4hI+oOmn9NaPZ6OFNWTLxor3apdkGCCGf+XjXBVJIACuYYtrn79TCSSt
	 CilBb13JbIDnbq9MxVu/HNU5GjJQk3T8rzp96xWZs2j33PZHjtZZoiN64bOLbo1uEx
	 EiaDapt7QYd3ckEbyRrWh/vqK+jWl62wY+gDKzVw8Ubt9AK+m+/GNXvK5dqCqlkwKi
	 9C11E3XJ2esnw==
Message-ID: <e5a06ee7-0916-44af-a90c-7ff7cf1397c8@kernel.org>
Date: Wed, 29 Apr 2026 10:55:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
To: Minchan Kim <minchan@kernel.org>, Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
 hca@linux.ibm.com, linux-s390@vger.kernel.org, brauner@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, timmurray@google.com
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-3-minchan@kernel.org> <aesg-sj6_VmXyqxb@tiehlicka>
 <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com> <ae8NT0tLt7eBmH6j@tiehlicka>
 <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
 <ae-Zu-VAzAA7SdLa@tiehlicka> <ae_roPR64e6sY_fN@google.com>
 <afBaJLLFigkdszov@tiehlicka> <afFco71vwmpQy3pk@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afFco71vwmpQy3pk@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EDA1CA000E
X-Stat-Signature: t88rn8cifi4cao8pfcs3yhtgwwxqmgp6
X-Rspam-User: 
X-HE-Tag: 1777452929-696298
X-HE-Meta: U2FsdGVkX19ttGqLVoYmz9zroH08Q8dsNwa/s7FIHOC5thzwXXDaOFIm0QKpu4wq+fRH8Vy568Noa+QyybK2OWysgIa9PZLhS3PN7i6D1/ONj00+p7U5afxKIPsxtOmY/S0V68aEX4aux+/j9uFy14XeOvWMTrsSc3KWSdMHHWMqoccThngzO8k5Bb4cq7IqWwzldeqxlNWEoNtfg2L7oScV5/r8906wD9Kesjki5xDvk5+cehxhsMmsZY/FGN/mmg/rHhFLpqh8aGtK/ISA4ufrWq/uetc95dINaID4XPiRuettFtXqt4hOxjiOXbl4n7HPgn7zZ1K7/WFdgGXDHWp9XuMPwJNzBU4kAVY92azK1Iw8KAFCzDibenGhwOQ0UCy9OZLnWuIj8PmVCYQ+JAXacRGrPQgB3Qfdd0xpHsw165Ugt3EpW/Kei/0nargvJWV7c8SfXK47NWn+9K+F+AQ/XO8YqeZV+Mfu2iUYzW2A7tYaOBydMfMdXKTs9V0Rsbzx0rL9SRc0PgYcIraeJw022KTLcJVdFJtZm+PBK0IM+OABdW58DUxcHh1/J0fw+vVSulxAMkXmEVKpNZ2QTHFFL73nu09ipLcODed8b5Kg7mUpTAmnc50QVVEO9k0QEwgCJV2bygK2Y2whIfGyXi0n6Uy2njzjK+/EUVjUY+HmHGsdefeMxoUju8YV6WnZyEDjncIIeSTrE0jZWUKkd8tRU9soaEu5M6uZayGv3Om6Pm2VmN21l1jKlL8agvUNfIyL4zDlrJ/znOJy5/xR7TviY7fHqA44xtg0k2z+hpTcQOyNJF3cKj0sY4Jzd+kiqOtTOukD0POT+MJmyn17es2/BunI1+uPV2eddH45aC0UPCNRGsLQ9hXXKf6H5WzKV1F7MERAzF7tF5Dj7ie4/ami5l7D47YGK6ZYzlBChMtjYcOpGJFz1gGsbgTURGIWaoTmgpNlXy4zTnI5X8f
 eOXEHR1f
 gEbWWK1h28sq+LjQuDF+KVqgYYSLc8HcdwY62fTvnDk1Q/t0VIQZtc4J6fkJdE5p5X6DCownY28d0WbSFGRW7GGUZO0sB8VQiH40CaPyRlXV0SuLRaesip94q1qkurZQ2Y5X53dDNIKMfSsgSjCtEum76aOlVv8+gaAVc4kTQZH4ucpGgPfjeAlRrhtfbmw4BEFWuUec50kWApUPnaTa3Ofubtm+1eZCKyicNw7fBR60j5Bi9bxq5qutdXHoekMTLu5aIQr+A1ur65L/XOGr24x2C0zC7DUfVXROalGQWkpXP5yroyE/4PM1GgKvMUKbH9b0sI7qQzQNgxrDE73FTsPh+dQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  
> -static bool __oom_reap_task_mm(struct mm_struct *mm)
> +static bool __oom_reap_task_mm(struct mm_struct *mm, bool try_evict_file_folios)
>  {
>  	struct vm_area_struct *vma;
>  	bool ret = true;
> @@ -556,12 +556,14 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  						mm, vma->vm_start,
>  						vma->vm_end);
>  			tlb_gather_mmu(&tlb, mm);
> +			tlb.try_evict_file_folios = try_evict_file_folios;
> +			struct zap_details details = { .ignore_access = try_evict_file_folios };
>  			if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
>  				tlb_finish_mmu(&tlb);
>  				ret = false;
>  				continue;
>  			}
> -			unmap_page_range(&tlb, vma, range.start, range.end, NULL);
> +			unmap_page_range(&tlb, vma, range.start, range.end, &details);
>  			mmu_notifier_invalidate_range_end(&range);


This API was changed in the meantime into zap_vma_for_reaping(), and I do not
want to pass details on the new interface. If so, zap_vma_for_reaping() would
handle that internally I guess.

-- 
Cheers,

David

