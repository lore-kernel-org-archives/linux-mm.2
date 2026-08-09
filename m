Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31187C5AC80
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 05:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C84496B010D; Sun,  9 Aug 2026 01:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5B4F6B010F; Sun,  9 Aug 2026 01:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70A86B0110; Sun,  9 Aug 2026 01:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91BF56B010D
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 01:52:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C660C04B1
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 05:52:28 +0000 (UTC)
X-FDA: 85080661176.02.08C7E3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 85832160009
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 05:52:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PxWrxtKE;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786254746;
	b=CTGH+wMikyr0LhdolHg16mH0vla80N57dj2i7IBY0Y/XUE7czpR87Pn7HRStqaGKWxWLg5
	td7WszbUlAmPJr2WkoQHUYoV0+OLyDrG7XN9LQjPSZR4bxbVF58e5k6ysOMBHJU8BIcVdj
	a+aucgtZUE844Xz9aOaaijSCFJf488A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PxWrxtKE;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786254746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rYXKoqqwOYghyOT0q3H1eZIzDiHK6OZjWUPUxJ0IzY=;
	b=cczzVrY4bMGJDGbM58PqXGWaSq7COfZXtMYv0+5MxuvDnAs3vy1kl6ykiJXPxgq3IZ2zus
	zPQ1DHSAB4aCXVQyuWzfX43ZcknoXm0ohQrWnKbqRjHOrrV0e0LunGEs44Yc34YGXwIt34
	U8CxpAdhDtICtNBCezv5NDdF2b5dp14=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8BC060008;
	Sun,  9 Aug 2026 05:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFCB1F000E9;
	Sun,  9 Aug 2026 05:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786254745;
	bh=8rYXKoqqwOYghyOT0q3H1eZIzDiHK6OZjWUPUxJ0IzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PxWrxtKEOcIk8xovN6ETBz1GSnJ1HubTBMk3+A1ZpeSwQWQSzlr03Qif+RN1OBWMB
	 8+WYjwK8riaGCZN4baibIyBF+kHcnyY3hbT6DumNgUY/8ARbzL8XSgUfavmp5oQZzx
	 Gd62OYE1AMiBx1l1HB9VkXJmMTF1aAG9EYu9UB7bHuJIOCAxhazTAaWpwx4ux0YYrl
	 z1uuSPaMjdu7WyGoOfuB/ZRDDN/jLvH+DJX7WJhvGye7SHjxCEhNGaV4WGvDQTvxBy
	 u3VD6r6ISBTptWH8CfmqKpjm7yXvKtSfr/BOcC6Afxt1/Y31MV3DJyKv0/TuSzbrvs
	 7aXfXF9YqE3ug==
Date: Sun, 9 Aug 2026 08:52:21 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Henry Elderman <henry.elderman.edu@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Henry Elderman <henry.elderman.edu+linux@gmail.com>
Subject: Re: [PATCH] mm/execmem: fix fallback_end description in kernel-doc
Message-ID: <angVlQGTvKecf-sP@kernel.org>
References: <20260807091958.4735-1-henry.elderman.edu+linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807091958.4735-1-henry.elderman.edu+linux@gmail.com>
X-Rspamd-Queue-Id: 85832160009
X-Stat-Signature: jpbfzgzibtgfc5sndnensku9qt9d3jwx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786254746-822875
X-HE-Meta: U2FsdGVkX1/reb2zHo+kct5XCRr44Vtry6UVTzGV2wWusqdjxl86AWWMbAXphy7WyBoM8tI6H1QtuiRNnwdi317bk20KwZRC7WBHxU5xSfSRlByiycswzo+KuhEC7qyC3ONHMITn6AqXr5h1IklIi2u6F5LwMBUM3mWqqRp7ICpXBk3aUgNsaJtdqxXf73TGcwVpyHBgHqIoOdwolVdZ9iHytvLG4EtbcHD23ZwzfzmSyMTO0az7nL0iEPMkyFEF7T6DH7ZHg5bYlGj82ppfjwfBEDYiWwHvIUaqwJWWJsIC4T1JmZCYNEaVqQgKzzqPNgRL/H9xepgyGLdqE+1RJZT0tlEM8zXov9q6MZl4nRJ6ic6c1Dgx79Zbel51G3ofKikUQiX12fqzuIZ41qlwICSLeVR6C1NBVOKXrT1pvFrQ1VJdIdnYQisRi9dYi1V+WGGeoi+e0Baj6kIO9vyTGNOdlMPeD6wQZ3MdtTRQIevcixt59Dkha4rldvrMrzHky4QFUBAGZpe3HCLvSgIfC+Dz8WtpcBIYjHPJPsJUTiimdCBfHgtIQ7VBFf7xqTsFMAGNI7HgoETuYuifx5GQDNejINUBHkuNmQEyx9Hau0KC97SmnWV7uGpzqbWnMn9b9Ul36oGBb9RIXVIUG4A154sH1iI9D2u1nPVtzaSL8nmTkgdsoMWJnCcw0/VFHjJ5UjzUr7OADGjUQyY11KKG+1KCEmEQ4Pems3ZEEJr9qF3m4IpJyyMsfcwiSY2yQPL81EB20Q4z8TzWQGXMJhp0I5VfwGlrwhSCOhzbPlutlwzTtbDbeSdPpEpZZm0eALvwo/snxIQyhbwNP6a16c9+8yZsuzZqLaXFS/BYHs87l9yBkkDbeVapHyG1wFOOe5Wa6lTVNTZtNcGSRMo2q3x63SWltBpoV3LoBCJSUwhBp55dlbMvs5D1ZVe3/SOJGZOa29CAxf08hs5qhTKLjnU
 vpClez1C
 YW4rrnrVibi6z+CRxWlunH7Ho9H0vJNoS15PHgfyoVxkeIH59wodkAFn2mRa8AUfiGc3Ow6KRmGVEBW+icAF+eBj8Bp3Vn1LRxhMo/EFF7UCP4E4iverJ+sR5ZWqYEfVn4Erw1NspOjFqNi0Vd9H5ojtjt5z35ST5KLxtjPyxLAKxmiaN+S2RZbuzkDu93die8rnRd3J4tlFXvSAjAuSYyG+5EZI6xtpoTRyQtEutc3Dddf83fefi7cnes9g3HjkZF2mTnnJMAVtk8HImblcqGsXi+TKB4o0g547gCbmsC9HNogLVItbXFJ7dN6mh0IwBmeFHqoB1yYSsdm2u9leWE9pUAJuh24y1cDq8xHgtaG12MtYMXWwqO57KYV7+LhoBpcrs7Fo7EhGsBAcdN5EM8KIsfzfHEG8gjdg7l+OyQhmYAe+9tH0gg+5gksFcqUj2sKdFNs63fwH9JzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 11:19:58AM +0200, Henry Elderman wrote:
> The kernel-doc for struct execmem_range incorrectly describes @fallback_end
> as "start". Correct it to "end".
> 
> Signed-off-by: Henry Elderman <henry.elderman.edu+linux@gmail.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/execmem.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/execmem.h b/include/linux/execmem.h
> index 7de229134..1bd34925d 100644
> --- a/include/linux/execmem.h
> +++ b/include/linux/execmem.h
> @@ -89,7 +89,7 @@ static inline int execmem_restore_rox(void *ptr, size_t size) { return 0; }
>   * @end:	address space end (inclusive)
>   * @fallback_start: start of the secondary address space range for fallback
>   *                  allocations on architectures that require it
> - * @fallback_end:   start of the secondary address space (inclusive)
> + * @fallback_end:   end of the secondary address space (inclusive)
>   * @pgprot:	permissions for memory in this address space
>   * @alignment:	alignment required for text allocations
>   * @flags:	options for memory allocations for this range
> -- 
> 2.51.0
> 

-- 
Sincerely yours,
Mike.

