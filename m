Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8A8FF3C9A8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EA016B0088; Tue, 24 Feb 2026 11:15:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DB56B0089; Tue, 24 Feb 2026 11:15:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 046086B008A; Tue, 24 Feb 2026 11:15:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E28816B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:15:23 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 963001C132
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:15:23 +0000 (UTC)
X-FDA: 84479850126.08.F9A1172
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id CC493C001A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:15:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=azNAiacH;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771949721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7C5H4/OwPYzGEXQFCeNH92XDs0pnzdqmQLlD/9U5c7g=;
	b=dD8FHIv3WZCFICFqomJd5q18sHSk3Q9aXaxleEIjgvfCi5e7lx3Kd8r9z+IsU4kK1gkuNB
	mA8V2IQagEF9FTUcHykNfviyXoiGyBUrOXsSVIHUElgXJyf41nZ+rvO0iPViBMuv/3ETwz
	Ttd657gLr0Xz5n1LrmaWPHiuW2LCKn8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771949721; a=rsa-sha256;
	cv=none;
	b=ETlpUU+pLE/FnFbnb7FldK9vO5acALucMC8y9sXFM9+QWK3dQcV28Spye2ZTnisHp59Twm
	t1lYT4B4eqgrl/12qj9d4QTQuWBKIqfVTJ6d0qdp7s948mfW7I6YKA5gliqRZwtviYRYvz
	BF+yvglZ8Fj1a+ZJhd6dr7q18kVnxDc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=azNAiacH;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B7136111B;
	Tue, 24 Feb 2026 16:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F13C19422;
	Tue, 24 Feb 2026 16:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771949720;
	bh=e8ui64+5y6ni0ao76yPSNCWiKuk4eYNlPnlFLGkLqgY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=azNAiacH9BhxTQimtBeqHMlpeQUoZsEpZLXn1YICn7l1qNRc0bXw5ZNXNvZEkNaKF
	 ed6DxGSDyfjlPR3zJDNbyYWTqNxfL18tLHVtVEwFI+P1lW7mbE9iTt7JX7bFvBfEzw
	 u4yubE0NpU2te77jLFp8tJVkbnaaXq8PNNgc7izpO8wCyMVZ3pvs56y/OYpGPU9P6i
	 C8isb7MYNNEhb3OLQrorD5VSHPFCAkawZ54RMSFH4HrLVON5NqY985UkHrhwBc88iC
	 Hzj3ZK1tDD/AZIC4D17+0ABtjvdTgSfaTCrwm5aSTiP/6VdqN0O5CEhEPCrLM2LLIw
	 dO3fnO0y4xC3g==
Message-ID: <c1b6f8eb-602b-4306-ad60-7a181fd94a45@kernel.org>
Date: Tue, 24 Feb 2026 17:15:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
To: Audra Mitchell <audra@redhat.com>, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260218184210.206466-1-audra@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260218184210.206466-1-audra@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CC493C001A
X-Stat-Signature: qopffio9iywao4wx6nn3oeikusgd3f5d
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771949721-833781
X-HE-Meta: U2FsdGVkX1+/fOksNpiJ+Vf4QDpmB0lUqAsy80pOjmXorTzqomkHpZ9yAByj7p+WZvdW0mLt3cfjVuy7uEKrYiXyuQ7sCLY/cArxk3ATqG9JM92Qy6zpgW4by6evebaOppT4tLVEVQl2MyMYclDUq224XBxRFhEqA8rfzX+Y/Y3Vdj0cXMi1BVQtlC+Dih6fTLfebgUVUwJK34a52pNp6foggOzytPOrwEjHCHNLLNURsN++XpYiHT0DNzUjLMb6+mWAMkumyxtTGURW0QIlAoSyWhRPHdq4x4Oy8GZqhEfs1tsveWE0kwJkg1QJsAp2PmoY+4O6NQD+wo4vX+hMuBGHK2eqgmDrd/2LLfAexBkB7K3Qdc36j2CrkMFnyAvUzUSf9h53kGTbb9NMvxK82uRjiyEThNBsiSCWNTP47zuNXTz2co/t3oZEgRsMUZBpCnIQX6OYIW3a1wEJlURiqNF7dmjI0u9Ck1UUoGNyOZzNBIubd8QnXZlVxEBe17X33yUgpxxN82eR/pZcxcC8GcFuVGbmvzb+hYq+r5ulhqPDXt5H+4aTWXNdqt6SEmyTImAtHKq+awEkKoCAGcIfCvdPblKglfkZeKGRAUHDR94jzoghDLiNwZ3V6DUKO+hP03TDlTry8GUQvveFQkBZRQZpnZ1swO//06jFvS1I3zT2qnUQi9X4kHIqXwJk0pYMPAighVErivyDLqX8QYyDHUI9shpBknCSXkHzinEMT4yHSzlE86meH3Bt1hPsgUeoZcjCZCSCQnTDd41y6/eMbCYIDgq7PhcXXJh8glDqxB9XSw/Wl+SuIGNHU2Q2pj8e50zQ+j/kA9f699Qvwz1zM7FQhPl6TkiU5Lm90RZpwhpVyFIuW5YMS5gppWkYztPm0uTNDqUdyhqNz2OT0LW7VZnce/ekPXybQe7q+CloWsvoqjf/98xV6V5+0rFgcNE6AQ6G3gzNznQMq1nVWf/
 xFLjC8SD
 lPPf8f2fHSJ5gtI7CgVTMUpAh4YS3fakht/4qfnnALO7zMlx+jKCsKcMi48U/krzIoNZ8JJpWCi/c5XywRhjLbLFIVvhjGkOXClj9d+4zxMVh0bwuSk/xuyDDsexrc5RwaLC5atcuqMmZrZtPNdnfZqLPLftrQZBoi+VgBv2yQ1S0RAAQHPQL1q6TOtPvO5+AlfY2KnARI6+F0mCWUn6j50E3cIy/fQJLu9gnDUSpBWbcMEY04Jn8zjhO5YdLbVh8wvOTY4MYy08s4HgrtyaxRnXHtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 19:42, Audra Mitchell wrote:
> On architectures with separate user address space, such as s390 or
> those without an MMU, the call to __access_ok will return true.

Where is this __access_ok() you mention here? Somewhere in
fs/proc/task_mmu.c?

> The soft-dirty test attempts to check if the PAGEMAP_SCAN feature
> is supported by providing an invalid address and expecting
> __access_ok to return false, thus throwing an EFAULT error on return.

Where in the soft-dirty test is that triggered?

I'm wondering whether the soft-dirty test should be adjusted, but I did
not yet understand from where this behavior is triggered.

> Because of this assumption, this check will always fail for the
> architectures aforementioned. Update the supported check to handle
> the return being zero for these types of cases.

It would be great to include the output of an actual test case
(soft-dirty?) that is affected by this before/after your change (likely
on s390x where it seems to trigger).

Do we have a Fixes: tag?

> 
> Signed-off-by: Audra Mitchell <audra@redhat.com>
> ---
>  tools/testing/selftests/mm/vm_util.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index d954bf91afd5..3bb7d322101c 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -77,10 +77,8 @@ static bool pagemap_scan_supported(int fd, char *start)
>  
>  	/* Provide an invalid address in order to trigger EFAULT. */
>  	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
> -	if (ret == 0)
> -		ksft_exit_fail_msg("PAGEMAP_SCAN succeeded unexpectedly\n");
>  
> -	supported = errno == EFAULT;
> +	supported = (ret == 0) || (errno == EFAULT);
>  
>  	return supported;
>  }


-- 
Cheers,

David

