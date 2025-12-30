Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32264E95A8E
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 20:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846756B0088; Tue, 30 Dec 2025 15:03:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4236B0089; Tue, 30 Dec 2025 15:03:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700596B008A; Tue, 30 Dec 2025 15:03:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7036B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:03:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8FD05867F
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:03:32 +0000 (UTC)
X-FDA: 84277212264.09.1348AE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0DC6D16000E
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:03:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T5Yy14uU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767125011; a=rsa-sha256;
	cv=none;
	b=6fbKVE48/rzCnv9kQyGcOQITvVrAE1pqogm7pVgRk8LJ6KQiw7gil8/Es6coL06tx7bgo9
	jfW3GAaDPTsK2EjCNBBB6zXVg4G3eJ+UMmWujhkblFQAuDr4dJyuV8rNwWNebqlxM8NTUZ
	1it1hvbXLAKB0tV7RCLHB54qyGXbPkQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T5Yy14uU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767125011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ctDtZSn4FSVNJvdKcxW0l/G62OR9jzVRl84PV6BGZ6w=;
	b=3aLkmHfUrFqCxXtw8qerHatTfWxIVR9K9SNvhOsae+GgFA0y+RFA8hhxciKkacdJdJRrD/
	rwPr3PN53QCy+ZcKJ3Brdc5WgvQOMVtjoG7E1L8wgS6CSUn4l3xTUfB9/3t2U0OAeIl27z
	8kTdOeOC3goSx0ofjCWl2xP8M/JE50E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7364A60017;
	Tue, 30 Dec 2025 20:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8953EC4CEFB;
	Tue, 30 Dec 2025 20:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767125010;
	bh=YNrIbUP7Yffo+oKA8DDjbWGcIaKo1esvkxdt3/Xo/rQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T5Yy14uUiNSsjiuB+9o3RPsKtquQhXgDfEMhk+ej9eErBOlvcxx22btCUTR3XjYDS
	 Hdqc2pfYqgRU/OGN8CprBtdjhzSVvyEv75PAX19+L00BiN4Z0+V0Fe/7I0DqlejP3G
	 RKIm6MUDGRvsK260R7dZDnlDKi056bYlCuidXK55vWwsm0PegOlP3hiDJih4NeP+5D
	 6atO6yffLPRR1Dqj9lJljukEKNHAp4H1IKrpPi7l2ejVGO2DU115RaiEZlroMCz8Ug
	 Iwmv7e+WHsAmiv6gCQBiUXcjs8h4jLt03n0vQStZnbWNstw6NytwToJZoTWpltSISD
	 qAqVqMeyDvcJg==
Message-ID: <f47b6192-2115-4f4b-82ae-dd66e65f4340@kernel.org>
Date: Tue, 30 Dec 2025 21:03:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: khugepaged: set to next mm direct when mm has
 MMF_DISABLE_THP_COMPLETELY
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, richard.weiyang@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
 <20251229055151.54887-5-yanglincheng@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251229055151.54887-5-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0DC6D16000E
X-Rspamd-Server: rspam03
X-Stat-Signature: sgf7ch9i7hgyzyqgosq7g1q3xr4jjob8
X-Rspam-User: 
X-HE-Tag: 1767125010-871873
X-HE-Meta: U2FsdGVkX19FqsaVhWGO8xNesEWO5zCZ7FBup2HqYbgo434JaWjbnpNyxiT7muLHwrUehaPUQdXzOCfLWQIqn33RW89hH1GlMhx3VxF0niAyZsS8pK4yVYS2qOmHO+yfk7AtWPSSTBs4wyBqzPdrJCl3iPmdpGPGAEDWBjYZOWM667hVAI0/ZdGcr/PQmnjdPWNAjibCa/y84dQ4aOdFRYZDueWAKzXQr/+kfcCZ8n5+hIEqcgsxLRXUKluo+zyxQJT76H3QGZShpjDeGjgKl9nfE+svhFYUtEVs1VppTZjDGA+Nb0FHaUKhOTveZWkrNxO7IhtxBjv8GjfMbJcH/3rttiFBs2Lomp6KTLnuxFK9I3Q5AotJOOWLzqhbiuCEoQPf46cyolIItLlLVf/7ccNM8sEohEOmzi7/csGM9UlMhTseg4NXhTTeu22kbQvVFOrG7vvljcHRhRo5njFiKfAJ+PjJMIfeiboymx/ClXH4HBDCh2UcEiKdyIDA2UCvo9KSH0gpoQYcfjkbtCBp+xssHG4QJScyeFkXABKdlpXYn/Y3E7j3GJfHwnjm4Afhf0Mcd/ngyT0gbNpK4oXJss8eXK9+dncXKI6pI3B7DH+9/1TyAQZ5UeNuqDuR7bbI9PCkiBoZRJF0k0ys2jehFRdf48I073RbVtxtqjv6wXWqCrY5cbqLtJtbxWE9KMUgY75fdMciM7TYJ1xNiq2qlAapTxrZUU7qojE0eFfWGF1wO7CsoSx4Z7oiryualxlZTxj14BAdJz7HV07mGliynvOL/A0Y7T2o6d3xjUTnqJXIwN0Sp7NuBG+xcMPyiMwJV1UuQALGlOyeLHWk3OsnH4WYqyWRmqVs1ejvJDr4fqULtotawZZfy59LG1XRI0/CqVoIUwTnvgI7U1DGriqZQGjrEKX6/lyaeRGe3Ald2F4w/3UfJx1Je1Rpyw7JdxcOZk5nIDbjbDpaw24a96t
 mTUOQW/U
 g+PL1ZzQ2Cz5jPkGh62S+M8mqrc1MUbzvWRbMJXEmQhm3FbzO70F9/wtx1on0Ka082AJ82Cs90PpL19C7ga2jw2zafnjdgZ+GAmnQJesiMUyztQji7KFhLucVDbmuPnLrm1dnUlKo1L2GtVqptcAGWR+muooPFg+lkLuKcJ8cJpADlAB0TrIem7FmkeIQB7j2CPs0Ie5BhA2Eqehzp9arVEcGrcvj3j0AhNk4xrxYb9n9KrNPLY1PyG3u2A9Z5xt6WHh6n4XJBuyzYnyBFGAJl/o57TOuewxamCm/+JbscxcZsSWJYdZZf2D4mhk5szV21k0WwNWhZav46bzE26/sG1fMXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/29/25 06:51, Vernon Yang wrote:
> When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
> scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
> reduce redundant operation.
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   mm/khugepaged.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 2b3685b195f5..72be87ef384b 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2439,6 +2439,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   
>   		cond_resched();
>   		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
> +			vma = NULL;
>   			progress++;
>   			break;
>   		}

I don't understand why we need changes at all.

The code is

	mm = slot->mm;
	/*
	 * Don't wait for semaphore (to avoid long wait times).  Just move to
	 * the next mm on the list.
	 */
	vma = NULL;
	if (unlikely(!mmap_read_trylock(mm)))
		goto breakouterloop_mmap_lock;

	progress++;
	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
		goto breakouterloop;

	...

So we'll go straight to breakouterloop with vma=NULL.

Do you want to optimize for skipping the MM if the flag gets toggled
while we are scanning that MM?

Is that really something we should be worrying about?

Also, why can't we simply do a

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386f..af8481d4b0f4e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2516,7 +2516,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
          * Release the current mm_slot if this mm is about to die, or
          * if we scanned all vmas of this mm.
          */
-       if (hpage_collapse_test_exit(mm) || !vma) {
+       if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
                 /*
                  * Make sure that if mm_users is reaching zero while
                  * khugepaged runs here, khugepaged_exit will find


-- 
Cheers

David

