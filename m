Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B7E3E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 08:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 873516B008A; Sun, 21 Dec 2025 03:46:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821086B008C; Sun, 21 Dec 2025 03:46:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74DE96B0092; Sun, 21 Dec 2025 03:46:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61BD96B008A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 03:46:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5FDE5B2EA
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:46:23 +0000 (UTC)
X-FDA: 84242846646.23.9D6FD55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 07A35C0008
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:46:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kl3xf14C;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766306782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYxEc9krZ12pY/RLI9cMcNSePPCwe49ZWZGFHO4VZ/s=;
	b=PSbK1QhB4xLkY+1k4rjzemDdMelB3CRf2ZGfy8wIpVzUtojJSLBcg8caYn7bTA6knYiWu9
	4ENtetpvceF6doVbV7J93jX1APPq+PaRuJZCOxqRKIadTWYBOPGBfD31dIImi9t8hmsrX0
	RVC2MFcqwr4kfJUMCQNajK2ddSLX+z8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766306782; a=rsa-sha256;
	cv=none;
	b=V3ARAUdhQKNkruRvy4BxY/Fiy8kYqFgp/KFfJI9cbfySYKZp9hF0J5lCMJxK12ckc4DwqS
	53wHmP4qAiTidJUjk/5egki5TVXU3bSw04bphojy8THGCl6NSygcZjKBZvfDprBZYOeZiR
	lfhGHh5yrgP6Z2SiHVC5TrkztRNieQU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kl3xf14C;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F0E540A02;
	Sun, 21 Dec 2025 08:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCCEC4CEFB;
	Sun, 21 Dec 2025 08:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766306781;
	bh=C/lFhvRpPUcNkUM6h2eXqKL+1YFxypTZXcHMoqeNcYI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Kl3xf14CY+PpQ2TO+0BSMolEDYozSQLJ869XFNw/O6Tze1rtIvDiYb6xBx4hzPytB
	 hjR4h1dPWeNntcGydCCMiikxfcdTs0L6qKGIs8mSRkR0xcwtAXNiblJD6IN64EYkd/
	 c6FM3S6rAsdjX7sLNi1y2LpBrwsoZgeNJLC5W0iQG3hfkcOxe1T65ipSVneqvOimQH
	 rGFu88IRwf/tUpIG/+gqt9qP7qwPkNAbLKTuQmP2qcGH0nCGUXGHnBXg0PlZAJ8hXo
	 mtzWJye9X5EyYPel9ndMfyJ24AZU8G9q3nJlACHwth80o++jYV+amTaSQbK7kMVEs4
	 CVsc4UWrJ0BUw==
Message-ID: <b9bd0f8c-9c61-48b4-a927-6742afe0e999@kernel.org>
Date: Sun, 21 Dec 2025 09:46:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: fix pte_unmap_unlock of wrong address in
 break_ksm_pmd_entry
To: Sasha Levin <sashal@kernel.org>, akpm@linux-foundation.org
Cc: xu.xin16@zte.com.cn, chengming.zhou@linux.dev, pedrodemargomes@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251220202926.318366-1-sashal@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251220202926.318366-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f87dw4qbk6yro1x4twkgn9uyzm98w4xs
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 07A35C0008
X-Rspam-User: 
X-HE-Tag: 1766306781-6049
X-HE-Meta: U2FsdGVkX19LkIWmWx9aD4ARNEmo6bbzBaIlXOe8Um3qORK3gfeMmUE3KHD/aONueyWQ90sqQWPV4uMbN/6OgXk6fohHz0KZ8wKR03mCqQyUsQyJu6QcWFFD003Cj/Lu8XPyt9Zdu7I5j9GoZGcnmzQilxaZQkESoXCAu+lSTRbaeOff4ZBYAy5r3tiPo8hKL8Wv4Uw0v74l7J+RylfSF7U6WlCMpPMgJJ5KbZkxK2YK/i/JiOXuS9nLBwNhKv++umKeGZEaTV82CBTTdRFBGueNp5hN2kA5TEpMo919bvPZkxh+OK7Dt7znF9AyIJ5iKPIPheFpmIlCsPI/514+KXX5xMXEAdKdsbulYk0PFQULnzPtdJboz7jIlZtjXR6yk0iZFChyVq7mOiKNn8ZD4ly4ValA5FMFxXmo9TNz4YQDq7/Ee88EgHuloG6StbJbk3Dk5fPDkNpCyLt2XWTs1qWa8EASQ7dTSF+bqF5ZWcqPEGVWr2G21WEZMgkt7eawjqobUutiZbBZujTutTuNVWQaKBXHP0dIcvxl7HqtzrQYVtT3Hx1HzfE8lrJk+tH5yG4eHwWJpKwb6cUpR/zQEsZ+n987NnaaZscLL55HKUd/k28zG6JxPnfqCebWfcv7i85pYspg8iME5pt9G1FL8jhxwZdxAgkvPaMfX5ySqBC00lBQqfQLwiSN2Pp2NFNl2NmfZ1qqLP+PXVSs6aD5mbzuy3CPyz7m6xgMh0jVdlW+I2ZIUN30dzLNd1ndmM5Dei78aw1oik1ZDuvj3dyRcFbYYEoaW9FuK40pwo0rPTVSKo5CgOcRY4LnLP7hbi+htqmQ4opJ52mA1n1JPcF4hqrrCFkhpRM11GjLA3cqvScs4GzisufNekt1GpXIFEqOlkW9Qg0SbGnd/gLo274zourGcWjF2ADTkW5gDJJPWhh2euzuRgMX1q8xCuW/fkQZTTVM2u0+cigKOlP8joz
 Y6cgC/xm
 jSKRCxf3wKQ9RoIM74E4Yyc2reSL+y57lYBMS2aTehWSqn89o7TpnZNCGSzYG8v1efh3deL0LgnAKC/jOJ/e63bpXMMm3vRQpJqWetjONnjyxt6wq28EV3uh/FMDPKiRkSKvmqW0EjgKhHDQxTfPnknC3GfkSkEp767FZ6on9UDZ/B2ZJmKy2KPhCHhkMIBMXPJFbNRr/3pC15DcOZ/sbgXG8VLkHMJJecmBK7+pLWYtpFKx91emEByPmo6PEsSg+GVKYbAzqNNTuGZypz/Jb/Z0f5Q/dYNkkug+BfddGljbdE1CLnaZnRVy+U9ntonUgSUh5Qx95qAg1jPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/20/25 21:29, Sasha Levin wrote:
> On ARM32 with HIGHMEM/HIGHPTE, break_ksm_pmd_entry() triggers a BUG
> during KSM unmerging because pte_unmap_unlock() is passed a pointer
> that may be beyond the mapped PTE page.
> 
> The issue occurs when the PTE iteration loop completes without finding
> a KSM page. After the loop, 'ptep' has been incremented past the last
> PTE entry. On ARM32 LPAE with 512 PTEs per page (512 * 8 = 4096 bytes),
> this means ptep points to the next page, outside the kmap'd region.
> 
> When pte_unmap_unlock(ptep, ptl) calls kunmap_local(ptep), it unmaps
> the wrong page address, leaving the original kmap slot still mapped.
> The next kmap_local then finds this slot unexpectedly occupied:
> 
>    WARNING: mm/highmem.c:622 kunmap_local_indexed  (address mismatch)
>    kernel BUG at mm/highmem.c:564  __kmap_local_pfn_prot  (slot not empty)
> 
> Fix this by passing start_ptep to pte_unmap_unlock(), which always
> points within the originally mapped PTE page.
> 
> Reproducer: Run LTP ksm03 test on ARM32 with HIGHMEM enabled. The test
> triggers KSM merging followed by unmerging (writing 0 then 2 to
> /sys/kernel/mm/ksm/run), which exercises break_ksm_pmd_entry().
> 
> Fixes: 5d4939fc2258 ("ksm: perform a range-walk in break_ksm")
> Assisted-by: claude-opus-4-5-20251101
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   mm/ksm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index cfc182255c7b..2d89a7c8b4eb 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -650,7 +650,7 @@ static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long en
>   		}
>   	}
>   out_unlock:
> -	pte_unmap_unlock(ptep, ptl);
> +	pte_unmap_unlock(start_ptep, ptl);
>   	return found;
>   }
>   

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

