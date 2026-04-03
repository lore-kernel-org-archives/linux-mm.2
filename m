Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E066E85388
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 18:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3326B008A; Fri,  3 Apr 2026 14:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 694086B008C; Fri,  3 Apr 2026 14:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9996B0092; Fri,  3 Apr 2026 14:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7AC6B008A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:16:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7712160764
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:16:09 +0000 (UTC)
X-FDA: 84618048858.01.ED097FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1CE8D1A0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:16:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o3RXEiMg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775240168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2SCnKq2VNy4JSJO8bnY9wpwXsHCjt+iTiAQmJnIU1uw=;
	b=NyNY2BWm+CADWciX/9BFIR8skKJCLPdjriOwZCuiPdd+I9u7QnmvBqwnhpNn/ArFr5NqMk
	DKucrr5fZJT8zq/vbnGkKm6b5fW1dmq6gme6p7NPp4lAfHNPMDBfOMte0ky/ofQtGA122S
	3i2lvSp/tLyOihLRpQOeWjYZoVF6QDY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775240168; a=rsa-sha256;
	cv=none;
	b=6JfQakIKX+NISX61fIJKlRfhrNi9rhUOEfuIH8mZSVYb2SaoG807RITWh7V6/pI4+FYcKK
	KlrS8V5S0w47wJQr4V2XSPk9nKCUzu2oDaLFrkS1uuGL2ZBzN8g+65o3J6mWfrDALOr+1N
	OdoiQ1pE9HFUU+p/t7InHqRybLukXIY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o3RXEiMg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5238360008;
	Fri,  3 Apr 2026 18:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F2CC4CEF7;
	Fri,  3 Apr 2026 18:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775240167;
	bh=PLP02BG5+c9aTRdm58m6RZdsHrEiiual31fU2vIRkAk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=o3RXEiMgc5eUpDjqetREj6DXQ1IYlHqSlmCAL4gCs52oqS0DDNRDuOGPL2W/RJsh4
	 JULwBjNW0jsdqunEdKsHU4P5KCNYxkfn2YIZY90EeJt+PZZl6+CefVg9xVoDrG5F7V
	 /iSBskLLo7yFWNB963KbJvcujlin3y4msdEWMU8cuetvqxOmdD34I8oFhnAkasl9R6
	 bbLps9jRxXirHDYpsKnQGknufwDL8BwC4NlxQ4hM2zCdlcNDd0ibWbhAZ6ckIBqhqK
	 +oi0Mdf4BhIN2feJh35AHWfwO1FPxud85Dfunvc/PTiRyS/46xWcUD22NftzSWzKCK
	 v9otScNhlyLyg==
Message-ID: <7c040e17-cd08-4f56-87b6-bfd612d87e40@kernel.org>
Date: Fri, 3 Apr 2026 20:16:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: fix mmap errno value when MAP_DROPPABLE is not
 supported
Content-Language: en-US
To: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com,
 shuah@kernel.org
References: <20260402235933.10588-1-anthony.yznaga@oracle.com>
 <20260402235933.10588-2-anthony.yznaga@oracle.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260402235933.10588-2-anthony.yznaga@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1CE8D1A0005
X-Stat-Signature: ef1qnaghsa6w8wwjzmbsfa5arjaqe33s
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775240168-528963
X-HE-Meta: U2FsdGVkX1/dsX0tQbEzAWzfJFoy9fOF55Zj5UGMzLgga62prB6/Ptom0p5TNQt0UDymlaeZ/PZmbkwQH1lP0TdgGVFO7Ye8gCo7Ix1GQneV2BJzGqOb180+X/T29rApImc3/e5jKCbuOzFAWH3gyDfiF6eb4nO4BSyva1Ij82OfaUQYPx9U3LyVlDu1omfRbQk6gaFwnKPmGVtHiu1MOg2WkaPE24M7Wvb2fzK20R2ieToAzyYl55WdeRInwC8+qCc4tlvwRRzinWqYquykQhq1uP6zTpEEY0LxDb1/o5mms6mqj54r2bWI4Ac7mBCzf4GrmKkZYyNNbjqqyMKPS4o3sgLOiomqtem+H/v1MiozqcPwfd/FcJT/AWyuUTnbdlmwViVy9RQQc+AxNavsnuYeilbzM+3oxyL7rwUYfif1EDfDogB4eMFUJlKZc87cA6ooVJuOMgVjPrghju0j0fFdoEQEl86Ss65jY2sE8U/flapSjx+hxQw58gZsfLNoxrZULQtQG+kfAi6opzH6L92Xsl81L4/62DUAUUUYCC8nuWr0P/goG/7GWDflb2bEZf4ntB1LPC1ggFnJAe1oGVxVWvRaGN4Qw0A9NUv2ho0rbYB3WT1ZSeMS+3fDOGs7vpapNrOHW+0iEHeiO6hQ6uWU7pK4S0EkwlWVNVYNDsXVMmGV0VuDohuUrYLOzVsFnx0PB46bNTTwVgwWI9z2ATVccDxq+nGRFcGpV0EeqH5uZXy3hI3/jQeoc5H+2fv53tt/8+IsXmbcj6MS/9fQ842ObrYdd6jHDYjrnYTxSvjMV+ydI02E6kBEVGoaTYaKEdpOPoJl/Ed7cMpgoYEwIVb+vTBvwTZxIHZMGakMai6A8BKr30z5mWsNwMOY+5dLzZDeUQtByzKqCayv0S2IRjAFBv2rFnyTSPgPHE0/Qsg2BWHADHnqA2/+Ax5PWYWQu8FAyc23pai0Zibg17a
 c8PJcvh+
 PJ+zGwPb9X9dSGoaB5UMwLUTtTXQSHu0FP8bJjqc3wZTtIt6N/41KJWISH0QUYTzS5aA5X02R4hkRospQ1FUsxiB9FxMdFhXRfyYF/hyajMEpQqVA8wRAKD6bS1QsupyyE6Ou7lOCA7p9LgZznNgRq8QIN92cxgoDbXGjgA7mw6o3zx8SK6zrz5prsTwCEk/n8VAKUNC/u1Lt2ef1OYy04bS5U0IqT/c11qw1nHfQlZ7G+vdYffxUH1M04XpdH1TrFf9hIVQ8IRMpS8ETUJ/D/d2fFBGAG6dz6xv3zKPSXRwKDddQne2sFx4mwjGkGYBSFtch/zd0Kp1VaJ3Bxug1JMG0f7oyx1lopls6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/3/26 01:59, Anthony Yznaga wrote:
> On configs where MAP_DROPPABLE is not supported (currently any 32-bit
> config except for PPC32), mmap fails with errno set to ENOTSUPP.
> However, ENOTSUPP is not a standard error value that userspace knows
> about. The acceptable userspace-visible errno to use is EOPNOTSUPP.
> checkpatch.pl has a warning to this effect.
> 
> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


> ---
>  mm/mmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 5754d1c36462..2311ae7c2ff4 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -504,7 +504,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  			break;
>  		case MAP_DROPPABLE:
>  			if (VM_DROPPABLE == VM_NONE)
> -				return -ENOTSUPP;
> +				return -EOPNOTSUPP;
>  			/*
>  			 * A locked or stack area makes no sense to be droppable.
>  			 *


