Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDCFAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17B776B00F4; Mon, 13 Jul 2026 12:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1504B6B00F9; Mon, 13 Jul 2026 12:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F7D6B00F4; Mon, 13 Jul 2026 12:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4AF66B00F4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:26:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63F8C1A01C4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:08:38 +0000 (UTC)
X-FDA: 84984085116.26.A73006D
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2F8EC40002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:08:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=QcjuKIwC;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf27.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783955316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bi9qlU8nFWGfauPcGhxB44CMzNrIyZ7W0UY5AXEndUE=;
	b=BqyELNkA6tpSDBGtocFmkbtw8EmCh4WdxKOqELUmUVzPoCIL7n0PL0Et8IZr5mb/CuAgbN
	faf4LXJtEOo17T+MR1lMSCvU6ufIUXhFVTEmC2aAE9PuKWpVNB9v8kwM5CMEpsPSu2d7DB
	FMAXOenEaNxLpSOW+m96qlyiVAVC1Ys=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=QcjuKIwC;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf27.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783955316;
	b=c34fQeYrzjHHoKqmB3QXQoGB5MNXKSybxQtzNTPiovOBiZ7iYkR32PZkAH8cO8XCxr90CQ
	CpqpzIBHq9gfORLT7pG70KJXoSqVAbX4C5KHyYgXHhURnSdLpYwmU+vou8cr4k8mCRVSR7
	SuJMaR4SpV4REb2wG6ufmynBjOCsBRI=
X-KPN-MessageId: b78b5c73-7ecc-11f1-8f54-005056992ed3
Received: from mta.kpnmail.nl (unknown [10.31.161.188])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id b78b5c73-7ecc-11f1-8f54-005056992ed3;
	Mon, 13 Jul 2026 17:08:34 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.189])
	by mta.kpnmail.nl (Halon) with ESMTP
	id b78a21c4-7ecc-11f1-9b0c-00505699693e;
	Mon, 13 Jul 2026 17:08:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=bi9qlU8nFWGfauPcGhxB44CMzNrIyZ7W0UY5AXEndUE=;
	b=QcjuKIwCfkR8kGJI9lOqksMLoq9Gf2VuRhHwC8hjZQu9rc6LCeHikMd3P7iCVoRtNTa9TbpDlqoVO
	 NXED7fp/rp6lronYnt57osGKIkZ/bysG1YJyee1Aym4uy7N7q88n60syQ03waWOn7HQsfMx5T3Fpq3
	 +qW/X7OokLwiGGphAy+VpOxHSdutVlWfJyQ3qWioxNuHJ36T6FUNDFV3h8H+x540b9E2Fqd/ea5h5w
	 iDo9RoVKgAhBei+jxJkItrmiWIdO2ptUonKC9FVtdwAQKYd0A3gOjnsjUF9aNDgVbGDvEMzolt96IS
	 72px4S+MdYuLGu0YqrnFWsp5CvxWRhg==
X-KPN-MID: 33|QzMzZCuH7XDnURVDbtXPDo2/eYn/QpAbfssaKBTu2uFoegWElrXqonjhEpVvLfe
 7qSUOVleETqYhsYJtg9AjARdNKn2C+inwtqNc+umwohk=
X-CMASSUN: 33|T1zfVBcLR4FjE4IA5fiWzvAQH62e5E5Yx3CRNRXHwjPo1BIESGBW6fL8TcLCuJO
 QomJbLesE5yAt0cBsMRQjlA==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh04 (cpxoxapps-mh04.personalcloud.so.kpn.org [10.128.135.210])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id b77f2cc1-7ecc-11f1-8edb-00505699eff2;
	Mon, 13 Jul 2026 17:08:34 +0200 (CEST)
Date: Mon, 13 Jul 2026 17:08:34 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Message-ID: <208270655.874218.1783955314215@kpc.webmail.kpnmail.nl>
Subject: Re: [PATCH v3 11/24] binfmt_misc: use print_hex_dump_debug() for
 the register debug output
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Originating-IP: 178.229.242.209
X-Rspamd-Queue-Id: 2F8EC40002
X-Stat-Signature: c1yy5pdjd8puy894hpdaqjwewejhty5k
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783955316-3428
X-HE-Meta: U2FsdGVkX1/+Ul0v6/KehFAGV44l77UTsEENKcuy1oPe3cJlQHLgB+UomeLcw2vUBqK7b0Q6JfLs1W3U7iiAX1JowWGDiDV8eTEjy7T0U2r0qF8EM7OAo3amKdmmYm5Uq1tqkdC9xiTyGojMu1wPAJnvVGZKZXj3hVV60AjAE/LOAaWgS+oUh/ENqRAI682ED9faGX9WMoUIZMPUrgrr8WJ44qr7hFZQhPq9iWdhnQgXBXoO6p+9yTjtcdkBqT03SuMEpAcfZ8Zsh5kd5WD67FSKlabs3N0yTjEwwGk9MUdhJZozhVYyLjqojPnd2fEU5hrAI8E/1S1BdTK8YLjvy+76MS/+i3McmQPSiXd6icBi/rX/PaJRv7XCfTny+1gc+IrXApvD3Br0zYI9L8UhBySAmanLGrOYbyEhMz7My7BfYfr1rfdhmuH/b4nC/PIs4FOFRtUYikD2VjFVVbNPw8alHrz2ud0xV9mNTfVYC6n905OHoQzWHObsdeVbOxMd45hkCyWXw7X/M8PbgIuT5AytDMlmG4uKCao2Gzn7R/oz1+vwCCUhUywvR4/ZNNK1g4aeOk2nB5/OXWzzKntsNxPsGsYNbDYVNY52+x9A11D1t80dwJi/UoCdcIPuwSBeMnvJqdiLZUqjwQwAi5NPPb0Usi1DOd4fuH59W0avKLGRix8Dt3n/+wkyr1rph+U2vE5k+DVkqrZ0sJN/p1wG0+tpl9R+zvWkRO6U7dbQn3t/DYV8AH7+w0paUdir+tUFaAS5u1Y8IsFLUElVVXSxtHHOtu17GHD4IOgnqSmePEw+EoX5n8bdq8fS7Eg1PyKdQVPk6UDzaeA1rmMWIMciisJ/cFdwE+MM6/LBqZxYHVXf7w3nIqvfROQCV0o92OSrdZbtM6p++Xm1dKFOh6220w2kzgVKjTHfMx5+RYZAqeRHEKhVEyFzAcptfgNPGHkW4/4aoZIS3TMYY5T/Lvr
 utGWa6tt
 /rWsIFUrHWqV1MGYdJrle72Bl++I+6lkmbZiKdvqjg8OGQX3k6jXBWXIxrhfwOA5HYXZrGni2d0HPcjJpKGi+yAUCedbSfttjzrfzSVu7ye87+yh03OgOs9AdGMdzTa5nnOWJB7dxiWVMlCjkZhtCT4thVy1K+1kaiIXVkttjyau8t+w6swGRoqflgWLgxokSE8ppPOl8eMSflpQCdZw/vwsobgH+k1hPWkufrvpcKqLr6YbzJ6AJiA76dp+ZSBALPzjkgVy3mcOBc+G4HsSyjitz1H8QXn3Qislk21sQRrlwaAOzmjAsTqDB3JkgSMAPVTpwPiv/GIWNXBm8ESB75epRiYEJrn6lZdOkFjwBb2w/z+CMlgXLGhgPT9mricvUfWGldyWumsIBqBNTVionJ+xWgANaHYwdsRABFUDXKVwkVPpjerXpU3sKS8cqo4m/tOUMJiy00SnIe3rNpNa9YwCyIdaTTXJZYwkhAYopepSZXbs7QeS1IM8XLqww9GZLf8Do3F057l0gdaqOsM4ImhU9YqGUULZ32WYPGsP3mtBLl17H0CzSMP3KqvEniqtHbJlv6mt4H+3Atcw=
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

You might use pr_fmt() instead of KBUILD_MODNAME to stay consistent, but
that's a very minor point only.

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

Good, this addresses some of the worst nesting in this function as
well.

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

