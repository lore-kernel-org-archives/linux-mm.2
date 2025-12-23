Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE543E6F079
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 09:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7846B0089; Tue, 23 Dec 2025 04:45:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8CA6B008A; Tue, 23 Dec 2025 04:45:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1706B008C; Tue, 23 Dec 2025 04:45:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE016B0089
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:45:18 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13A4B160570
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:45:18 +0000 (UTC)
X-FDA: 84250252716.23.96D40F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 925F6C000C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:45:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5rSmj0E;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766483116; a=rsa-sha256;
	cv=none;
	b=1ZMUMpiyzMt4+xqK9iy9q8SGxJcJ1K9u7+Dtby0MPGXmgTcKYbGr8kPxncGs3mfFpXhEzQ
	u8anfOD9TkGqP1Nl1FK/ByJz2tLouCkwcgCYuY9PmIp5SkG+9QowSIpQ6Q4MBFL1Nd0vI8
	sl5fHZRZoeBQXTE0aAdV9qGT1uipBLI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5rSmj0E;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766483116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kP4UQKZof9b3iY+9oFO5PIB2T9eFRPnGkM5v3gTi54=;
	b=BlA3K4mXS+INLF9FgM0StbrV8PZbm2kPa74OUr5LQ5a6qVkF2F+xtCPYPPQ1dd8jORncL8
	EcOdhfbtHQhbkwU7r5optraVOaxqC1kkdaynfq4aXkICLnItoZdgXC84mNzMV9JWcLeada
	9qE+lZjtOGEolZDYL+AWPj+PemptQPk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2035E600AE;
	Tue, 23 Dec 2025 09:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C103C113D0;
	Tue, 23 Dec 2025 09:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766483115;
	bh=pduBI4X/Mk1ek2LX7TGThg8Kkc2him1nGwwQ3ckU+6w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i5rSmj0EYfHS7GUR4EvivixR0KO99ndYmxPHDxE3+RdoG4NmfdXmHvWvLdFqtLa3J
	 amk8iYzwJR5KuaJJ+ZpA0vpgc+uTv21oghiqJt4Fl3BEb0TDo2MAhLwoFGBpi6MDwg
	 FV8hafq0oO0wAinH27bRxrI85B2Kho+oMulz9enBtUMb/AcWokDZEyyCbL6WF7yM4X
	 P4+sBVQc6J+wEKyIiWS+VaGB4jHUhr6+XJ80N+b8A/yOJyg4Y077FCDkS8OLwHydsF
	 iWTLdspIMxp7FRks206B5xqXSzzffjkAWI6boPOF48IYoh9S0UsJPCCiFBZAR2RuE8
	 3FM/p4zVg020w==
Message-ID: <961095cd-59d2-454a-9b97-493d12f296a1@kernel.org>
Date: Tue, 23 Dec 2025 10:45:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/fadvise: validate offset in generic_fadvise
To: klourencodev@gmail.com, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, Kevin Lourenco <k.lourenco@criteo.com>
References: <20251222141817.13335-1-klourencodev@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251222141817.13335-1-klourencodev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 925F6C000C
X-Rspamd-Server: rspam04
X-Stat-Signature: 1xq76ay6xn6a7rdrixb6ek1r5mmdoodn
X-HE-Tag: 1766483116-257217
X-HE-Meta: U2FsdGVkX19WjqQlOKYkE21wOTzUtUtUrBXRRJpThp+uDRp9p6lz8ku0i6cIpNXet99Uzb+Y8aKaCh+L8Cz21StcIHRH3edMO87+RyRLJEK+x10zUGRALo1OWkl8MgjFp7SYR2eLUf1HqFP9DC4+1w3umQt7gWjIsC1WzxF6Kw7suIk8hDDsyWQYM4QDTIAb/X2m9au2RwB5Rp2rzjrNy1kWTNhrshrADOLYe2pf71sS8PIIQYeffXgntuEoNkxbJS9bdY0HuTiXy8XovgMl4CBN9eFJqrzHpoRDTN5S8IAuC1OpC1J2Ey377Hs+JGTrhRDBiNNmnHmEph+6xHMnpYB/YkgpaMO4T3nkizMxDrzmc2mU4kuzUHP8GEnbHVu5eRrAk4hTo5XJnnEvnXlGt1b6FHlAqW99zdL1RDySypVdvhkAcDWW+OcyRayu9MzTZ5nEpzTWQXGu6Pix8brjLV0rJ2szZ+x4M9qI/pqz0Op0tIqblj/z+w1K1R3LgnuWaOKCAu81gD4yh54sAbwDMt+KEOZpr+KkFjGTuaja/rtO6NRzyZyLy9AZ05DggXQYEIQ6e2RMMcZmSP6QAa/5zt/xNruLkekiHQUH+xPD6CVtGpkRhy1MEWSoUHLZ66evaI5NJ8ntx/JKGB70zhRwkwHioXjsot3uB1OcZ1z1rkZauSiWc9/PGXPw++1D4EfFoAjbaMToJCupsdr2tS8ZngtUnYS/jr9gEmwEbjZX2J6jw8nf4zJuWPvuxSQYxMvuro0bNOjw66bXXXGBInqUvK+mXdPQuPJSghk5QiXx7jk2JuzEIB4cQITaOVTzLa8US4IvXtduMshXWFAtW1WYtzq3cvMAoLJyoPY5/JfiF1YOVQLcspHAPLeGj8t0mE2voa/h1tM0mO358nD3JqcbNJQ/M1cVkS6J1Y6/HIYYgv9WMy4K/EuF2gmplK8EP74+mgQ+YM4Dz3iP0vcUSML
 w26cltES
 pSXiW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000019, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/22/25 15:18, klourencodev@gmail.com wrote:
> From: Kevin Lourenco <klourencodev@gmail.com>
> 
> When converted to (u64) for page calculations, a negative offset
> can produce extremely large page indices. This may lead to issues in certain advice modes (excessive readahead or
> cache invalidation)
> 
> offsets are normally non-negative, but the API does not guarantee this. Since 'len' is already
> validated, checking 'offset' here is reasonable to prevent potential system instability.

Hi,

we tend to break lines as 72 chars in the patch description. I assume 
Andrew will fix that up or already did it :)

> 
> Signed-off-by: Kevin Lourenco <k.lourenco@criteo.com>
> ---
>   mm/fadvise.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/fadvise.c b/mm/fadvise.c
> index 67028e30aa91..b63fe21416ff 100644
> --- a/mm/fadvise.c
> +++ b/mm/fadvise.c
> @@ -43,7 +43,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>   		return -ESPIPE;
>   
>   	mapping = file->f_mapping;
> -	if (!mapping || len < 0)
> +	if (!mapping || len < 0 || offset < 0)
>   		return -EINVAL;
>   
>   	bdi = inode_to_bdi(mapping->host);

The man page of fadvise64()/posix_madvise() is a bit unclear. It doesn't 
really specify what's supposed to happen on negative size or offset.

Staring at test cases in LTP, we seem to have:

* Check the value that posix_fadvise returns for wrong ADVISE value
* Check the value that posix_fadvise returns for wrong file descriptor
* Check the value that posix_fadvise returns for wrong ADVISE value
* Check the value that posix_fadvise returns for pipe descriptor

And we primarily only seem to test what's documented in the man page to 
fail.

Which raises the questions:
(1) Could we accidentally break some users out there?
(2) Should we update the man page to document what is supposed to happen
     with negative size or offset.

-- 
Cheers

David

