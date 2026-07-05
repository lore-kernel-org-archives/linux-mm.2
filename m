Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F09E0C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 09:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2A536B00A0; Sun,  5 Jul 2026 05:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A022D6B00A1; Sun,  5 Jul 2026 05:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917FE6B00A2; Sun,  5 Jul 2026 05:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1FA6B00A0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 05:17:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C4B2D1C3B13
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 09:17:18 +0000 (UTC)
X-FDA: 84954169356.20.D149196
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 416D2A0002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 09:17:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VAuLMVEY;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783243037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1IpFmqExRpxSV8z6aiknhr9wo+Fgy2npUiahXkL8Phs=;
	b=rdx0k9dB2uWYflpz5E4Wu07TeER0aRt0IhA7Qi5OsN9XGOJW/V9HkrQuazZm7ZXqeOiZ4W
	nyY9LrTgxhjJGQe7Iw6c2Hy8o4x8I48W23iD2Es0THOmuzaR1l0kL/UCAA+f5xKFlqtQyW
	ZmuV/r5/2m+BIh0sHRW9njw+YvPqiNs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VAuLMVEY;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783243037;
	b=CAj6WYPoNEWYs1628e+SyaMI74GvRqUJvu3Z6iEYRYQhiNmiNUQAuOelF4UwpRCpE34ftD
	b5+ALgKj2qiidry3awsXiMQZ0sjZcxEJtJFi9sszPfycL0D4LkC6mNOD6zvT6H3hfgOAmw
	rlfY4bFp3Ya+2TSGtS+31P4h31OzhU8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B49CB60052;
	Sun,  5 Jul 2026 09:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECCA1F000E9;
	Sun,  5 Jul 2026 09:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783243036;
	bh=1IpFmqExRpxSV8z6aiknhr9wo+Fgy2npUiahXkL8Phs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VAuLMVEYo8TwyvMl9BuOQPRB8oVu13Q6owOStv6lFC4TRCjV/ZLuPxa0tKU1hDIrm
	 dg0gtaUkMbqbt3L33a/kicGqU8qnEB6cIM7O7oNdp7bjX1G9WeY5A+ZSE6EHTz/Cw9
	 sJT5d2OYfC5uER6oS/xOGKE9YEBlWcEsVKmFD8+DHMBh5Hd/wQlSdcmDatHc+a3H15
	 ZVteBAdSETEBoTA9RUGpWhRrObCrMcdw3A179vqyQGUim7qjXlf4OwPDQ/xVitAKRc
	 JNqjYRA2Oc+uqjByXkfY4k2DIEvZLWMOcjg1z98kKf9ymkVARtX+dpeiOJN4xK7ppo
	 tm37/JOtOf5FQ==
Date: Sun, 5 Jul 2026 12:17:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Anuradha Weeraman <anuradha@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid shadowing global mem_map in
 sparse_init_one_section()
Message-ID: <akohFqkKncFzoupL@kernel.org>
References: <aklP82yPNq5lA2Na@riviera.anuradha.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aklP82yPNq5lA2Na@riviera.anuradha.dev>
X-Stat-Signature: rkhwmn63g8ruwkes8s44xq3nyj5udfxs
X-Rspamd-Queue-Id: 416D2A0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783243037-974155
X-HE-Meta: U2FsdGVkX19AH/IzqtzpFBTfZmatmKgwxoyCPhXpTNjI0No1ludhuk4iqsLGYu1ZZT+cF+VGECmjfr5ngBNoCTqZKpFeDPKfZPjwmCPLWraFUxygw2Kj7jO9nn/VlyYJdfN72R3o1oNHAHptPdBfzjz17ctjjkqFcCxeVsq+zxPxeyyMd1ooET7WrYNlZT7xJZQ+0HgpW6+E8+q7/I/489cg9o0PqI23FOYEzVK0ryK3KQVlp6gcqbbfdlC98WoD488ZspU+xkF3RHNFEwUBOJ0qyss2kaoqljMA+bW0TNNVcq9It7e9zmy9CR5xDHnvQ8ALfZNv2k2o70AP25Su0GQUhiCXxK+4oSprI5YdUa336cr+uGZitB1slMc4Y9N2cvaBr7myeqVFUcrf6Y3fonEyatbpZpCiWpKJXFD2VNqrewCuh3iob1f4beDcQYeH/Z6Ly7NCqlbskkIGe8RFtcNnXCkHAIgvw5iuIjcfgkh77v9oyvkmxfidgzV3e5kT61X4BK/Y+3Vdqx9wTVPFW93OGltzRFvL95k6lx8pkHTq/mVPnLWzmsAF9CtVt3QcawcYd2330y1G9VdSs7OqbWGGbuhLv1WNTk8WFz95xUoByfgAuteyRaHKzkcPufyQoZVykr761a0vk3Itm0CrkM1WfhV4m6kXknMpPf8ShkfdY0IJZV9sXthtOd7ipboIocFW8ZDf3Ks9UqrryKT3kUV4kVVvqYHdfgGkkA3DX3MVrC9Wc0ZSNMi6fCp3EXHhkSuX4mrQaUqAPm8qAShDOGD6yBAm2KbeuR+Ymcuoiw/679oU2yeyCEsdr+uxH8ZLOvXo7pC3uVsDprMztJZNgCT6BS82BKhZ4q3SJrvtQy3pOABXrU6+OtJKlg/g6SK7nPNl1J9mqIGhrXWB3eKwIBT6oe6KnZIEk1vVJgtfJ/RIW9ZQq3uinhoUrvph3931kX49m4l8mhrNtGsz9pM
 JwQjmMSW
 Mfdv4lxbYmVPwjH8775QiyyIJgFFPBm4PQftn5kydDjNLUQbjRDJ+DtWysmVdRmZkboNL2WsZQSBwWRgnS77XmmMIK3YfO6mC07cD3WMFPhs5RRJw+i0Uj/wbxT5QY7WER3Lj9ecG9RJ3ZPTnG8+ZrfsyQL2n3nJLl6BuTB/IicQ1Vw/cd+HiTYwpEudGBjUCd+1eXQ0Rm/job0cQAQmdLF6bAuLcWph0ceCOwPev6BdVkI9H2vQbyWdOvQczB1TmBND9+rpsar8J1Aur9Irmmj0ViQxibYgTyXdNENyDshrFJJ14s3LoLPjC3dLsBYaO/qKO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 04, 2026 at 11:54:51PM +0530, Anuradha Weeraman wrote:
> With W=2, sparse_init_one_section() warns because its mem_map parameter
> shadows the global mem_map declaration in linux/mmzone.h.
> 
> Rename it to section_mem_map to make that scope explicit and avoid the
> shadowing warning.

I suspect that the comment in mmzone.h saying that mem_map is must be
declared for SPARSEMEM is stale and it can be guarded by #ifdef
CONFIG_FLATMEM which will be a more correct fix.
 
> No functional change.
> 
> Signed-off-by: Anuradha Weeraman <anuradha@debian.org>
> ---
>  mm/internal.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a2..4943def97167 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -957,7 +957,7 @@ void sparse_init(void);
>  int sparse_index_init(unsigned long section_nr, int nid);
>  
>  static inline void sparse_init_one_section(struct mem_section *ms,
> -		unsigned long pnum, struct page *mem_map,
> +		unsigned long pnum, struct page *section_mem_map,
>  		struct mem_section_usage *usage, unsigned long flags)
>  {
>  	unsigned long coded_mem_map;
> @@ -969,7 +969,7 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>  	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
>  	 * from the page pointer to obtain the PFN.
>  	 */
> -	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
> +	coded_mem_map = (unsigned long)(section_mem_map - section_nr_to_pfn(pnum));
>  	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
>  
>  	ms->section_mem_map &= ~SECTION_MAP_MASK;
> -- 
> 2.53.0
> 
> 

-- 
Sincerely yours,
Mike.

