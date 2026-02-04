Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84E33EA7944
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 19:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905936B0089; Wed,  4 Feb 2026 14:36:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFB36B0092; Wed,  4 Feb 2026 14:36:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787E36B0093; Wed,  4 Feb 2026 14:36:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68B216B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:36:25 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 22D2D1A029C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:36:25 +0000 (UTC)
X-FDA: 84407780730.02.67A3633
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 47E0240004
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:36:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R34k9rUv;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770233783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YRUU45In97m+8Zj962olCaawafRcbFMwUnQUo0fPHuQ=;
	b=ZDrHvH/d8fX53WjBS25j9NxbHoL2MoS98sUrHHHkseVqSIiaJf3iRHaeMuNChCyrj7RCEQ
	WnRKRn+nNcCEtRT0YCuR9LmWUnAcH9YkVYXGYOvecBPIbZvcHSaTSxcckzW8fITKtBV9cp
	byxq7FYXZMAhOL8naWYDR7V/AflWFHc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R34k9rUv;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770233783; a=rsa-sha256;
	cv=none;
	b=FJTz3z4uCPfi/DhoP8GLkeEG7FXggemw7GnOMiG5KgEIMg4Aoh8pdGQiw4mJjn/e1Mho7x
	jwUtOiUEkBxk9n5YKjEgXyKpGoF0nJgoFqvzxkMf0jK6RfWAFq6w5NdevSALd582nx2HlT
	0MJNKo8CpApbXBYPfMnJMWcEfxMJmuo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A9FF60018;
	Wed,  4 Feb 2026 19:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92C9C4CEF7;
	Wed,  4 Feb 2026 19:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770233782;
	bh=QU3jrWsGIuZ9o2iKsCUnTMZ1BLOu3kxDvnNgU0Q6PbY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R34k9rUvrSuNHWvpokBkg5c1iGffIx40UJz0bBuQO2uqidy8D5Hh3vxwD5PzHVfsj
	 nW28jOkm5TfKDV8kT/dm/8hvYVaYLD1NzPsq0XGiDQxGKrd7PSLYlBrWPSSFKOyY+C
	 pZ5bJ0VmHcqmagN/VlHHdmWW35iw8X7sYJ1lWiPet4wje/wnx6Pt53yjKx/KhxdMTZ
	 ZR0y+BDzRVipQ8sPc/y/ess5IJ2zydaSQzhYI1Jh9xlKATMpYq8fneH2wj75r8ZEwv
	 VfH0BZRyG/Xim/MxAfcZ7LuwlFJiRxfO6edj5Yp5bGsbRLMDoVHNZ0TVSCXHSGwtUa
	 q3uQPohPCSEFA==
Message-ID: <d3f4456d-f2e1-4d8f-aa92-77ccd1606d59@kernel.org>
Date: Wed, 4 Feb 2026 20:36:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, riel@surriel.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, harry.yoo@oracle.com, jannh@google.com, ziy@nvidia.com,
 gavinguo@igalia.com, baolin.wang@linux.alibaba.com
Cc: linux-mm@kvack.org, Lance Yang <lance.yang@linux.dev>,
 stable@vger.kernel.org
References: <20260204004219.6524-1-richard.weiyang@gmail.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260204004219.6524-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 47E0240004
X-Stat-Signature: 6mzf1bj9qq3xms6z8zbc44goqkpc1fqj
X-Rspam-User: 
X-HE-Tag: 1770233783-109962
X-HE-Meta: U2FsdGVkX1+wiTDvJ9W3KSlKRFN/i7Gt621Hw5bpemBvZlAlx27TZFGTB83x3U3g7oNY7GqV388PnHhB3AiMticub8b1av0sUd915itGYQRTyyk34Wkqj19yrlKS+k/3CSaPtjhVOyyO2bCZ9dE2LX8Sm14xo1y8qAqpvvPFgHkT00aGARQqrW8jMUjGYQ9HzWyg+xoBDXEPY1lC5MrKcmT6IRZU/utQkVs9IYccUFpR+EqbQfYNi7NUv11/hm589nnfviVKqqyR3EIsZJslWH0Ms5vxDusEe6uFuXgf4T+bDmNyhcL6zaBVII74CWf7ez6fDI0UXjhdPOSOFP5WvnqJHNbjJT5wE3xo5GzYyiekZAZK1S8m0wEiG0ITRwHmK2ttr5TarBS9QwM/zOPnjVg31uwakfSFalqfGHIG8snVncDsJcnrdUgMHP4GPEo6/1qKSPMuz0+wx0LJ5hiTwHrJqy8Ecatkx1aiokTmwAd+8A2ilvoiQF+FDg0de1lXTRqP8wLcX7SK1sCkaqc4nS+wWstZV7WKVOUd9f7Q/MoMeJ6gIKpQu0m63zEaV5eG7UtzZi7xeypayXU9BXnQhKxLV4eLfd6fh4HreB020MfyvK/ivjBYEzq5BiqRRM4kfBDHUJ88eDzTHznGzTrNf7wQo9b7gzO03jU4pP2yJgxSG7PL+Y/xQKvK2py781quPDqfKNOeTwmit/Cy5ogPDsreFy5PkHS3kP4V3kdFUCMGRsFqWrG8DQYu2bj9+XcDknuqeSVlQxhW/yiEnBrQYF4ikWsSxn5lTvSF2Tc+25CERLbdk58rG0NWy1yPV+yHpor5Y/LnN52R52xUhfqMx2lFJ/A/6bJKhYZxKCskqVh4HpbcQo9hYg+byvTRTsB0W1Xp5SbLXRo25HJTLT3XTtdUGAvjXNeIsMd66qKp5+jthY4fsIMj6yo+vfVe0wais4j9bOKuEWptHuNbhja
 R2ozIlet
 YHzeFxmUDjlcZ44Bm27fUjRMXBS45cldgDnbo3bFgmjlfk+RVT0AvnxnsBjXvgDvySaq9Ri2OWJ7PNR4UayxTql+/jqGFQtrd1vI2n/ZUJpboRNsDT3LQEKNGpuZ6qYu4ZZ5SXP+hgz5okFSm38ODk4xtTCDpOEha41avyOk63jl9ISkq4c+j6GvtM7uRsnn8IAcaYPxoh2Smp0QBR2jBGvcDfz18jTkiZVmjsAlRdcW3g6AEtZOP0CiDLjlrwecm05iO0/86ttG6SJ5WFaSot5o3PJRYvZXEu7XeGSsMImPG8EE/Db2C8OItLDOXyTv2o5DaoOEuMqn14JLtEc0XFsYu15iFdY0WYgQvqu8phJNW8c8OHqVQjkuJnGdea5gkLiQIDqVtgHNZvsnCht/xVaNitINjpWujVa8/X6oUzyymnobbOH2ic5Dja6lBwHO0edKzqTfy74ekJoPw78dXdCJKYBmqG1m1Yu7frvDFSDrjMLXf52ZB4BXGkzTG4k6RdU5hADUs7yBpIA7k57RFm1dsbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for the late reply. I saw that I was CCed in v1 but I am only now 
catching up with mails ... slowly but steadily.

> Without the above commit, we can successfully split to order 0.
> With the above commit, the folio is still a large folio.
> 
> The reason is the above commit return false after split pmd
> unconditionally in the first process and break try_to_migrate().
> 
> The tricky thing in above reproduce method is current debugfs interface
> leverage function split_huge_pages_pid(), which will iterate the whole
> pmd range and do folio split on each base page address. This means it
> will try 512 times, and each time split one pmd from pmd mapped to pte
> mapped thp. If there are less than 512 shared mapped process,
> the folio is still split successfully at last. But in real world, we
> usually try it for once.

Ah, that explains magic number 513.

> 
> This patch fixes this by restart page_vma_mapped_walk() after
> split_huge_pmd_locked(). Because split_huge_pmd_locked() may fall back to
> (freeze = false) if folio_try_share_anon_rmap_pmd() fails and the PMD is
> just split instead of split to migration entry. 

Right, but folio_try_share_anon_rmap_pmd() should never fail on the 
folios that have already been shared? (above you write that it is shared 
with 512 children)

The only case where  folio_try_share_anon_rmap_pmd() could fail would be 
if the folio would not be shared, and there would only be a single PMD 
then, so there is nothing you can do -> abort.

Returning "false" from try_to_migrate_one() is the real issue, as it 
makes rmap_walk_anon() to just stop -> abort the walk.


So I suspect v1 was actually sufficient, or what am I missing where the 
restart would actually be required?


(maybe we should get rid of the usage of booleans here at some point, an 
enum like abort/continue would have been much clearer)

> Restart
> page_vma_mapped_walk() and let try_to_migrate_one() try on each PTE
> again and fail try_to_migrate() early if it fails.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
> Cc: Gavin Guo <gavinguo@igalia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: <stable@vger.kernel.org>
> 
> ---
> v2:
>    * restart page_vma_mapped_walk() after split_huge_pmd_locked()
> ---
>   mm/rmap.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 618df3385c8b..5b853ec8901d 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2446,11 +2446,16 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>   			__maybe_unused pmd_t pmdval;
>   
>   			if (flags & TTU_SPLIT_HUGE_PMD) {
> +				/*
> +				 * After split_huge_pmd_locked(), restart the
> +				 * walk to detect PageAnonExclusive handling
> +				 * failure in __split_huge_pmd_locked().
> +				 */
>   				split_huge_pmd_locked(vma, pvmw.address,
>   						      pvmw.pmd, true);
> -				ret = false;
> -				page_vma_mapped_walk_done(&pvmw);
> -				break;
> +				flags &= ~TTU_SPLIT_HUGE_PMD;
> +				page_vma_mapped_walk_restart(&pvmw);
> +				continue;
>   			}

The change looks more consistent to what we have in try_to_unmap().

But the explanation above is not quite right I think. And consequently 
the comment above as well.

PAE being set implies "single PMD" -> unshared.

-- 
Cheers,

David

