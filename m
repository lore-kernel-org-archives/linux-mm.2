Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 243D2C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3296B008A; Mon, 31 Aug 2026 06:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B4A6B008C; Mon, 31 Aug 2026 06:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB09A6B0092; Mon, 31 Aug 2026 06:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A07026B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:06:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3E22140462
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:06:51 +0000 (UTC)
X-FDA: 85161135822.03.6D3AAE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1D3F620007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:06:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DATBspxv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788170810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTCa3x1+NLElVZAzpXp0yBo3FBCgVkxgyOn4AqetuYc=;
	b=OjR19qiqyfvjAeiilrbEY0z93R9oO4Fq87g17JEF4YASdwwcYxqnbARMYHAVFKw/nwEbg9
	sF09/iMIL8PCd7GErW2o03/pMeLGYn/ftzsrKJDmuCVI16uQJ2hINXNlzllvMII63x69oR
	3oJXlcxmRFRzvB1nGfYq1VmZa1Yt0BQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DATBspxv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788170810;
	b=swBmO4zTHiiVL4KgnWnffQg5R6j/yqK9ul4gTaK/TQqrXp+UIn4D7Y4eM0dsUTxjKUZ7Gl
	FX7CZ9jYU6rvBjFNk2t09PovzRxT0ejclsU1jAOjgJJw9yBPciU/+6ym91KbXkZ5B0fZ9G
	81dym0fP19EOeiamymGMqLmEXeBBTME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69ECE6020C;
	Mon, 31 Aug 2026 10:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D741F000E9;
	Mon, 31 Aug 2026 10:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788170809;
	bh=rTCa3x1+NLElVZAzpXp0yBo3FBCgVkxgyOn4AqetuYc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DATBspxvVs8agfsX5YhOCluh8TkwJHWyMCd4BSL1dTeYmEDfDsaCxZEJjDKrjKvOz
	 +RF2NtLVrHEoSP3sc2RhlhoVs4Jo9HPzeIrhYcM8vAO2iDokd5nUHDsTlGtd5ePScf
	 t76hAjtpxb7lZqcYvcun9GWkZpg+Ka+cC/yeXhBJUVRbpoVhrMnVuUuuBRXSbrnOT/
	 4KqA0KoPyzsh+d5qhNIhDMGqzRXy5I6/qP6i2cWOUIoqEOb3O00cg2MbPu6go4uRut
	 hSsH0kjGDEbsNwSnaemTYucOGQRHcltY6KgDJ0PUWzIMU0VmLUoZ07EEP1lOVeNagK
	 fK9VMEfu6YK1g==
Message-ID: <3d3c124b-04ae-49bf-8bbd-684b412f0a1c@kernel.org>
Date: Mon, 31 Aug 2026 12:06:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/slab_common: reject zero object_size before
 calculate_alignment
Content-Language: en-US
To: Longlong Xia <xialonglong2025@163.com>, harry@kernel.org,
 akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Longlong Xia <xialonglong@kylinos.cn>
References: <20260826015506.3178758-1-xialonglong2025@163.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260826015506.3178758-1-xialonglong2025@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s1umzbswk6x6f1yenwcggsz1m7951d9k
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1D3F620007
X-Rspam-User: 
X-HE-Tag: 1788170809-829182
X-HE-Meta: U2FsdGVkX18J+XNzcTC9QJ9k51dcWRV5n6CuzNJK1j6NQAsx2JbSXki2sw04bUF6lWIPqvB0QdXr00MlPXeUqQnseeeZWvaqvLJSTvzUcqm9I7tuPExsjiXwzgkcgk61ModLHmv1z5IJlsQkbn/WBnyyNIDoTN6eK4pBuTLuPysf43iLACUG3vRkPjm5TPGcE+DGsBfh2v8sPnV7QUaJNiTeITPkLwjBW4fHfGxp8SJDZT5Le68O+IQv6cHnds4622Tdd3/6evPTU1ywh8G8BKVguRLw8XSDMIz14Ca4YLDUdK5pMAg81GTQ/xZ1aLFPtRFwNQp9A8jf5dpuzkh1ou8cSGWzIb94bess1Vuh9Eb6UNFlEZSIcPjRw3N3U5A9+en80mfOrSwVnEHNxxl7EE0W7VlWJzoBURGdDiEH5GjMesTAFUpbRQO9c9SrYwonAR26ej4o1kt7YTQTTOM2/DmZQz1nkMsu/xJaIXSq+MOHW7jOk9q/oFWGY4wmPuud3F+IvYv8/57ZBkvBjdjlLhl+7LKeeeTLzBbo7u+sKNJT9ZETHVMZ/QBcOHj4PsoMHy+9agyCOsaz3XK5wXpqzaveVKwI2yghZd7DFb5Y/N8KzLr0VN8LghxHcaoBc6lh/jZpEr1ermWlRJU51YjMrE2eGyG5Mc4AMj23H6uenMks3/E4X0sUFnpli/wZsqj6fnhjXikLkHqtTnIOqT4RgRp4q4I0/GbPWkeBaUK4rCvGVX88v5zyNemSIxmevzdeQajYtgdvbrsZZKDdoksqP3tzSwmimQ+pMbMUhleCxgaQrZ/VQ9t0uSgG0/JPQ8eozDkiMJfmHjyNrH3wsb8Xi0zOlIOxAdMTS+yH6daPE8URiWGMjLPe5rsgEmbCIr1xqsCaEw+5EoiMfgOhhXVCTVwviK4n6T5yT2ppNLNWSI0z0K1qFpB4kRFKLX1+FZajrTJJObwt1LG7x8v3C1Z
 CMbhDrVl
 Ewf/sx2nlarBdMZnx7N5Sq6xXwqFq4vnys4mCjdjjaGOKs2/9UBWN3jpLB1oB2bBKJ9Hy8DvB0+ZbVOZ2ciX5LeUPWhJlBj+FQiD5pLQd8FEnFakeWXrRUYXtaGW0vNeKkgPN2b+Yqax91QZcMmL1/uF23Cv8oeyrIwcv72/DpzvA3h9dy7WbJOUN6OcYbCBN7btGDwaOO0Z+G2l7EIF/oFSOcvqm3fUwV9ZlWuZ2kl/r4Q01CcaE8FTgPfZJZPm4gBpoAg9gYZuX7jf/bk1qno774yf4rO2R//4N7xaWr/SDhYwvFzwLsIvvOXUfIf9Cp5VspaNnRUmc6OmKJEE4yXZ1TJYpCEpb4jha
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 03:55, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> calculate_alignment() with SLAB_HWCACHE_ALIGN halves ralign in a
> while (size <= ralign / 2) loop. When size is 0, ralign eventually
> reaches 0 and the condition stays true indefinitely, hanging the
> kernel.
> 
> kmem_cache_sanity_check() rejected size > KMALLOC_MAX_SIZE but not
> size == 0. Add !size to the check so a 0-size kmem_cache_create() is
> caught on CONFIG_DEBUG_VM builds, where it can be diagnosed when it
> surfaces.
> 
> Suggested-by: Hao Li <hao.li@linux.dev>
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

Applied to mm/slab.git slab/for-next, thanks.

I however support Harry's suggestion wrt (not) adressing theoretical issues
like this going forward.

> ---
> Changes in v2:
> - Drop the !object_size check in __kmem_cache_create_args() that v1
>   added to the always-compiled path, and keep the guard only in the
>   debug-only kmem_cache_sanity_check(), as suggested by Hao Li.
> 
> Link: https://lore.kernel.org/all/20260824092454.1693745-1-xialonglong2025@163.com/
> ---
>  mm/slab_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 95ddbab290d4..e205a99d85cf 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -102,7 +102,7 @@ static bool kmem_cache_is_duplicate_name(const char *name)
>  
>  static int kmem_cache_sanity_check(const char *name, unsigned int size)
>  {
> -	if (!name || in_interrupt() || size > KMALLOC_MAX_SIZE) {
> +	if (!name || in_interrupt() || !size || size > KMALLOC_MAX_SIZE) {
>  		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
>  		return -EINVAL;
>  	}


