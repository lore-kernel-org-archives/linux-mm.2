Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF867C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 15:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9A76B008C; Sat, 25 Jul 2026 11:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687306B0092; Sat, 25 Jul 2026 11:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598EE6B0095; Sat, 25 Jul 2026 11:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 262A66B008C
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:42:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BCDE1602ED
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:42:21 +0000 (UTC)
X-FDA: 85027715682.26.6B3F78C
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5CDD41C0002
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:42:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=ifIAvxqX;
	spf=pass (imf18.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.170 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784994139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFH6L6TDEG8NMLi73+H0H0u9v9NQ3v3cVv7BpAPvt0E=;
	b=fBubOaFmG0wnOElnQsjM0cFlxpWeV1Qbl4KVkLLBKcUX72aPzbkeOSV+/R8Od370IGkWIS
	3w1KOjjIVemHCasGEjQCr+uYIvzAwSakqcyd47qDLHqpVmDtY8okEsCMoFwq9N5KsMlCcF
	zVTVnokkV1n2ZinEFcmAsupjrFZNkWY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784994139;
	b=pJUFcGQVdzp0bkwtCMNs1jiK4pN9FbD0wbahC6w89iwf0rJ3wfIurNXUuyHD3lh8PBlXs9
	jvX4k58etr0xokvcFTByHE9GdNOVd2A4VgaMC+pbX8wpqkqAd9skUzkBCG0U8oM4fIugb8
	ZPNARMdtovJqbS4TeFe1HB2zHvEFcOA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=ifIAvxqX;
	spf=pass (imf18.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.170 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
X-KPN-MessageId: 6a1bcd6e-883f-11f1-83b3-005056ab378f
Received: from smtp.kpnmail.nl (unknown [10.31.155.37])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 6a1bcd6e-883f-11f1-83b3-005056ab378f;
	Sat, 25 Jul 2026 17:42:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=aFH6L6TDEG8NMLi73+H0H0u9v9NQ3v3cVv7BpAPvt0E=;
	b=ifIAvxqXTZqj+/DvB5kbWy16jxjv62/RjZY4DJtqMn6xYp/bINP7LLzNviWXSW2a2xazWAoBBkJtA
	 1Wi2A/xwtEeKjFdMpL8hmxJ+nSSwdQ3HYivl+QKT3vohoWjpAmb7az+t1PllzOiT0jEzeljLho0+UC
	 qMWwaUOzQlDLGNaPL3y3UbMmqoCXnkggHK3Q+9t9MZbqkN372a2Rah0F4bcjqFDStw2DQLUio6oCX/
	 Jnan5H5ohSW5q23sTGpxYK25PMr/4NLHGK4YB5XSKg/2mRtkZhWwbX6IZ/PbSR4qjhmh8qMcOO63O3
	 peS928BA2ima+hf275FlSKlmmMkYUYA==
X-KPN-MID: 33|dH2tP463fCT0O+caNWDM/in+Ldj6cpgfqLQQBoT+2Pm8u7vRKRaDFJq2/grCWpR
 hzCAOe7ZQvmL5Pl9KcIa4iR4eQmm8CBluEEsCjAA69KI=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|LLpRSe7cTKJnryiIwk0Cfvus/MgiK/i1gjAA3uPyXWeXv+sKgjqYbU618imsgNg
 Ah8MAUOuW2+rMODbXZdCzhg==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 69d930f0-883f-11f1-9226-005056ab1411;
	Sat, 25 Jul 2026 17:42:16 +0200 (CEST)
Date: Sat, 25 Jul 2026 17:42:15 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 11/24] binfmt_misc: use print_hex_dump_debug() for the
 register debug output
Message-ID: <amTZTrd-dp9rS4to@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-11-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-11-a162f7cb58d6@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CDD41C0002
X-Stat-Signature: mutqbqtggz7ztrxo7drdxy8aoupj4otd
X-Rspam-User: 
X-HE-Tag: 1784994139-19575
X-HE-Meta: U2FsdGVkX1/ggzRJLnP0yQUhyR9q5Re+z/gxvOOQlyICD30kwngaUUnOTHHXVdkgMj88I7g3kRNyvat8LMqe8XTAnvnVQzoSibP3H75lppUcUQUB1CZ78qeZfIEiFQjfB09uahFhT/iWPYnjYNtbrugWBx2q8mAsVPhnacympKVIEy/bCvPWpWV14cGLbTeVh6P556bPx4kPH9gszryLH7O5sSvUYdl4cIsQxJi/BxPNK0k2pYK/yCGdpWCpmTehMgbXyVc3Gt8k6SKtwP03gP2IkCUBloOz52bba12C5QG0tJt7OG2EK5HimKsBQMNuppRhtrk3vM4Ce6Lz14J+/rk5xNXi+fma0GdYkoWjvOodPEAd7ESyT9oZj8imnF7zlK5N6gRhp3y/QhtXsoYlpzMbRs3NHqbOMIyOdZWLGz9IXAlwy6//pDcsbALTsGIqesyfyLEuM3f0UW0Cf+Uwc4wkR7ODZsV78UPrhwLit5LlnE/vfMQTEavqxcMtvHiYyZF2SFzxwCO/3yEnTJyXFOxCp7snzHVL2H4M2xPoiD0yArCNawc6l7EfZcpk14YH7y++NPdWbhAD3iqa4vm1lEB0nXbZ5ImWYVRPsxz0FtoCvAn14V/zt9WpIFfNH+j+AwAxAOjgnJQwoAv8bPr8XBYoJ7ZkWaJvYO8cH+K3U4DtEFWFgeUpeI7trFM71Fmz05M3S+Qju5O4RJxrQ4EG+F8/bavQCDdIZvDagJmxw+2EhqUJ9n91koiO9k8wwr/FRpYCLOCKg7xmXz2SSuclTEwMt3mbeh9rcdui1lLs2BrwpAtgmEl3KlzlFZFj9E8jm0+cPi55Osza8aSdsavVNwy5Tv1rc+w3uZ8aFq2vEAazBUvFmvH9V9JvTthFrTqBA9+K2hN2joJNPnE8m6tC0OB7NlocZXrhMf5Sy4zFubkl4CFYfY3qQgWkAMVrhQwqRX4G41eQG7/q+pNzhh4
 EqA59Z8H
 U30N9w+6cb1yuZhAO5iwAdV/CvN+gw198thydMgGEURT8sPlstIjILv59v5/AMF4vmnxp8hpf6BgiYEZLITvCWPJ12h0YUj56gDvmqawxlc0K075U8jXIRBxlLDSrvzVjT1Z9n9+u6f1XzbAaHMTNpOFFaXEgmLx6W05z0lXo2n+Ih/hvkxCGayMsrgP11jDuQB4gZxRJBXASAo5IRBce2HKJFhyerbiNgIcAatlmH54RlpgclteUMTPKETSO/g7oLKrtNy2kzJ0x0r57tNlldAyxuj4rXUMOsRKVw7fcrPnnZwYtHiuXwsQ8U9SAwWxwvA51rOvUQfsXxdSi17tCTVD/lripbZVIsIqbsB42vwiSjuxZ1KeeOkiaspzEpLNxUQyjjTtHSkkvbrwSr8nHDaAuaMsvV7LV9kWe4EC/vA25G64/s7a5jTCdauQhgCEjGU5jP7Ogj1fv8a4Nif9n0VFPNKjob1ZWztFyOxgFOvzIANZPZmNHR+++YGNOO3Df3a1PkLL+U0bDgewMysrw3UaZsLPqETT8z+GYWcGW2dlzw7ExjSm2+NemmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:12AM +0200, Christian Brauner wrote:
> The hex dumps in create_entry() are compiled out unless someone edits
> the file to define DEBUG while the pr_debug() calls right next to
> them are dynamic-debug aware. Switch the dumps to
> print_hex_dump_debug() which follows the same rules as pr_debug() so
> the register parsing debug output is uniformly controlled through
> dynamic debug, and remove the USE_DEBUG machinery.
> 
> Drop the magic[masked] dump instead of converting it: it printed the
> bitwise AND of two buffers dumped right above it and required a
> temporary allocation on every registration just to recompute what
> the reader can derive from the magic and mask dumps directly.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 52 +++++++++++++++-------------------------------------
>  1 file changed, 15 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 96f9ac752511..252e1f2a8347 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -32,12 +32,6 @@
>  
>  #include "internal.h"
>  
> -#ifdef DEBUG
> -# define USE_DEBUG 1
> -#else
> -# define USE_DEBUG 0
> -#endif
> -
>  /* Entry status and match type bit numbers. */
>  enum binfmt_misc_entry_bits {
>  	MISC_FMT_ENABLED_BIT	= 0,
> @@ -460,10 +454,9 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
>  			goto einval;
>  		if (!e->magic[0])
>  			goto einval;
> -		if (USE_DEBUG)
> -			print_hex_dump_bytes(
> -				KBUILD_MODNAME ": register: magic[raw]: ",
> -				DUMP_PREFIX_NONE, e->magic, p - e->magic);
> +		print_hex_dump_debug(
> +			KBUILD_MODNAME ": register: magic[raw]: ",
> +			DUMP_PREFIX_NONE, 16, 1, e->magic, p - e->magic, true);
>  
>  		/* Parse the 'mask' field. */
>  		e->mask = p;
> @@ -473,10 +466,12 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
>  		if (!e->mask[0]) {
>  			e->mask = NULL;
>  			pr_debug("register:  mask[raw]: none\n");
> -		} else if (USE_DEBUG)
> -			print_hex_dump_bytes(
> +		} else {
> +			print_hex_dump_debug(
>  				KBUILD_MODNAME ": register:  mask[raw]: ",
> -				DUMP_PREFIX_NONE, e->mask, p - e->mask);
> +				DUMP_PREFIX_NONE, 16, 1, e->mask, p - e->mask,
> +				true);
> +		}
>  
>  		/*
>  		 * Decode the magic & mask fields.
> @@ -492,30 +487,13 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
>  		    BINPRM_BUF_SIZE - e->size < e->offset)
>  			goto einval;
>  		pr_debug("register: magic/mask length: %i\n", e->size);
> -		if (USE_DEBUG) {
> -			print_hex_dump_bytes(
> -				KBUILD_MODNAME ": register: magic[decoded]: ",
> -				DUMP_PREFIX_NONE, e->magic, e->size);
> -
> -			if (e->mask) {
> -				int i;
> -				char *masked = kmalloc(e->size, GFP_KERNEL_ACCOUNT);
> -
> -				print_hex_dump_bytes(
> -					KBUILD_MODNAME ": register:  mask[decoded]: ",
> -					DUMP_PREFIX_NONE, e->mask, e->size);
> -
> -				if (masked) {
> -					for (i = 0; i < e->size; ++i)
> -						masked[i] = e->magic[i] & e->mask[i];
> -					print_hex_dump_bytes(
> -						KBUILD_MODNAME ": register:  magic[masked]: ",
> -						DUMP_PREFIX_NONE, masked, e->size);
> -
> -					kfree(masked);
> -				}
> -			}
> -		}
> +		print_hex_dump_debug(
> +			KBUILD_MODNAME ": register: magic[decoded]: ",
> +			DUMP_PREFIX_NONE, 16, 1, e->magic, e->size, true);
> +		if (e->mask)
> +			print_hex_dump_debug(
> +				KBUILD_MODNAME ": register:  mask[decoded]: ",
> +				DUMP_PREFIX_NONE, 16, 1, e->mask, e->size, true);
>  	} else {
>  		/* Handle the 'E' (extension) format. */
>  
> 
> -- 
> 2.53.0
> 

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

