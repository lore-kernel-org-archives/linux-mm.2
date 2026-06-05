Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A0BDCD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DB6E6B0098; Fri,  5 Jun 2026 13:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3176B009B; Fri,  5 Jun 2026 13:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9546B009D; Fri,  5 Jun 2026 13:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77AB86B0098
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:49:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20915C13B9
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:49:53 +0000 (UTC)
X-FDA: 84846597066.10.5825D70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5B7FD4000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:49:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ot0TX+03;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780681791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LwGtvOXKAGZrSsdtQYxVodblsUwtKRfClda98rWcRDc=;
	b=F3VxG5zElJEdLAY8twcKYorlDb44FbkQ9wOkpZhmiMTKV/f4Qm4crr7iJsS7PUir3yenC8
	yCmrqIJPVtXmk1STs2jjfyHzHRo/y+bxrn2J/MZQ4JnZxJeRaWa2u0xR1DfUxjoOvOM/7F
	SMifr1Dy79YQx5EvGECHrhvrWILKGeY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ot0TX+03;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780681791;
	b=Xf4IJQmPwct3gSqeToRw3pH05vBbO/9FlMBl77iF/mO+4K/JzMSCfiXikCoyIoDNBqo0os
	MajYB08eDk7dQpbRsgMvpbLUPpEMveqd5dQIM2g2Gkl4EQ2VR49Z3RqgiZSBBxfZ7B2Srr
	oMgu2xqZRLF67eppl2Sp5rvkIrlZjvk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D2014601DD;
	Fri,  5 Jun 2026 17:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434EC1F00893;
	Fri,  5 Jun 2026 17:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780681790;
	bh=LwGtvOXKAGZrSsdtQYxVodblsUwtKRfClda98rWcRDc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ot0TX+03yOgzXrp8V7VE9CTLkYrkd0ZBlLgBbzx8SovkOxfR8IJChQWDsXmPsJcIH
	 yUuy6/rCRZHxamblQ217ZHj1seYnsi1jdhHzJU8HR2QNJgJbuGbb6vxLx5B+8Hgs5Z
	 v7lzYET7aRBhNj0yL1kz7VrcnGdSmYYf3Vzit6lWUVXAfYdqJ9GMKcio+8D1S6n2Os
	 Qn25r5M9g94b5zudlxshPinbuuabMmzLeM1lJJWXluq0lUtJTBnaynQ9gFATakZN5H
	 sYfzw3/dGyKrzU+JhcgzHVkL/S9aG6JvP2AEUotwxX9/6/mKI9UrKHbh64kevzHXPf
	 2DjJHK2bGFBZw==
Message-ID: <44b12ede-1e16-47f5-9051-27fa4ea34236@kernel.org>
Date: Fri, 5 Jun 2026 19:49:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v19 12/14] mm/khugepaged: avoid unnecessary
 mTHP collapse attempts
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 Usama Arif <usama.arif@linux.dev>
References: <20260605161422.213817-1-npache@redhat.com>
 <20260605161422.213817-13-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260605161422.213817-13-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5B7FD4000A
X-Rspam-User: 
X-Stat-Signature: trbabdzurqubd1cmwa11qeh8xazmumo4
X-Rspamd-Server: rspam09
X-HE-Tag: 1780681791-754761
X-HE-Meta: U2FsdGVkX18wJxEjbPiaeVlwQcKXPsSuwUTHqrEEwMxYSwaGGs5lzSHysJTWpyoFvdY4w4dZk2XI+A/bU8cSNS2svYsXppfDMxRUAUGJ2Xjc3+wZ+doSLUNmnsVH/bhkP/HkP4WPewIJ9VjX+rflnWR+8Gjbr3XD55shnKS4psHfG07Q7ayLg8JhCjkeuYj6B44dWTn9+sC0OMlksJba0bfXmqsF0r1x/f+JOpAIBLOhlEx2Bef24ulCWNDu9qyJZxr+knc/gJXUt7HqtewQit04Fb5MpCmho4+Bv/8nUcGEQZrWipiqo4dq6Xbju6PihN7e3yUj5JOk9PMgLc+VAiIlrKFELL1TxbFuspnmDKsRgVgJTrYnhskiWYZQkSfjn1A3iLzIfHy0zVFp3xdMLkPkjeLEqeQjcf0Pt6JgCu+BHYPTTdZVzdF41FMcWdxHah/mG3oPG44qJivOurnxYLmyqDAbsRV+bvnFLoM81SVVKHYc/a7etQVb2h9oje+3iB19n0lpK7jF8eqLVdb2K7YiFYP37lp7XO10v/5+LPEeFgbaxl7BwRAIPkNu6M1WCoZ9XUk9+tIjqr/gt3x5oyVsEbSN1FMnq6ErkgGmk0kOHHUdeE+Ob/M4a45mHPaTkCpJI3AlX6jmF8ZAXlRFeIShZH7iKmhf6u9+g/mzoO5W9nXXXgG0yQECKCmgD7cyNoEqzYRBGRG/23gnphk9fkOHoVvP6PcDjPOV9nG30uFI1Gk54N7C8P33zvC0tx0kPBSQgP3u145YjwdM4+Baco3qt4/dYikTaHPA9F0lynRUXXFpEW8x32NZ+Sis86ETtXJ8ylC0ZXMs0yJhhhYBTBG1qz/QWKiiYCZLx37cvyj6QbdIUj3dib93quzZv+T6F4MZ2Mic0e4a2t+fHfgRf0ZFQr9+6jcJ7ve26YpcGrpf+TLpQJ1iF68wS0YlVj0iNCk78QpeuhmgquSxDt6
 z2JtXzdt
 DVbKU/bma4XmiVfxrV892zLamOCqWq6cXr/5ikB3AY1MyV+lF0mYx8nmpTlp/DT/1C8D405VweatmKG/WEFrA5m/wpYkkSY8AWC2RYDWVI82aOo9o42AitXr88o1sjTKA+uyIbbO99haJIMumHgZEbIEPShkJF6SstPiZXZUfLfLgssIBgWUNt4PKIIIeuez3fhkZUFBHRo1GbJtNrdQAX/z7GWpUJrtuYqXz7gpL53upxQOmTA23a8n0JqJS+R7xCp0EcWvBROobFkA7qvOaKtdFdUelIO0i3JWZIchARlFjVvZoovHP1nX4MQmkJSdFndoyfBpDQZ7lwQmmhgNMN+Xq79uROADPHzE/jIIIAplkNN/uYFRaka2zDYPyPFsVZbvfd0sr/qkfn4c0IYE8JlqCMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 18:14, Nico Pache wrote:
> There are cases where, if an attempted collapse fails, all subsequent
> orders are guaranteed to also fail. Avoid these collapse attempts by
> bailing out early.
> 
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 430047316f43..7de92b28dd30 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1499,6 +1499,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>  			collapse_address = address + offset * PAGE_SIZE;
>  			ret = collapse_huge_page(mm, collapse_address, referenced,
>  						 unmapped, cc, order);
> +

Unrelated to this patch, but not the end of the world :)

-- 
Cheers,

David

