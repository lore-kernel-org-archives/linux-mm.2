Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9329EE6B66
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 22:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF456B008A; Fri,  6 Feb 2026 17:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6F36B0092; Fri,  6 Feb 2026 17:06:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEDF46B0093; Fri,  6 Feb 2026 17:06:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAA456B008A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:06:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5287FD5B26
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:06:29 +0000 (UTC)
X-FDA: 84415416498.28.3E47BB4
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf06.hostedemail.com (Postfix) with ESMTP id D62B3180011
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:06:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=f7JDhqA8;
	spf=pass (imf06.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770415588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfqc+l4dyoDL2n2OdQ0v2fn/+SQhgq6smOmD7uWZA6k=;
	b=Dl1Q1OxICdZba3Lt6Ixvrn1xv3nLHezbJfHrXm+nvNFEbD4xt383VcJRwpQ7j10eR7b25D
	+Ust/hGoUQIWO8yZhAVimhUG1YxZNHVrDVYmNdipBpB5mOoerktyhLDlwvFhqgzEHGxhFR
	wHrKsgv3toXezSXC3feOHqrTBp1zsZM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=f7JDhqA8;
	spf=pass (imf06.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770415588; a=rsa-sha256;
	cv=none;
	b=4k6Nx3IckdKfaLxGMzl0LPIKKbOPlsrSMrnp2DXLGIIDeqRZ1+UZyu/CMmOO/f/ZRMNoK9
	NGgJEjeAYhSZZRo1tAX1xL6eYpkqIvK/tGEnTGBZ1YMwSKSLCDoEH+Jj/pH3ucH0O27wtM
	XV+F9QjEohuvdBb5ZAuBn/+v932t/e8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1770415585;
	bh=0ms3/Jxex9AmT1zDq8VfFE4zQD5zB3PK6GtE9pjSjFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f7JDhqA8E/GKyiN5O6Nc5+kweuaZmOkfhRb3N1XBQhk44tf6sQ6ioWU//8NEHQxqD
	 kOsbUHZ6hf+lSzuW9Hk3OnfvzPWUc7g/hRYYjwGgsEAsl2ozyKaq7cmVClKRwx95Ui
	 ZPosWRbf8+ruPP2RQyqrOjQB0oZyiZlZVEnO9NFM=
Date: Fri, 6 Feb 2026 23:06:24 +0100
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Jordan Richards <jordanrichards@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Jason Miu <jasonmiu@google.com>, 
	David Matlack <dmatlack@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/liveupdate: add end to end test
 infrastructure and scripts
Message-ID: <98e953ed-616c-4684-a8e1-87195349ef4c@t-8ch.de>
References: <20260205222329.2419035-1-jordanrichards@google.com>
 <20260205222329.2419035-3-jordanrichards@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205222329.2419035-3-jordanrichards@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D62B3180011
X-Stat-Signature: o8g6fmjokj1oho9oemuem5pbzr1ke9hk
X-Rspam-User: 
X-HE-Tag: 1770415587-252114
X-HE-Meta: U2FsdGVkX18hzuzX7XAhku3p+X4rMcOMZHxdSLQkvFvrHXPCUsBE32wmXSvpRfW2RINrcSc8rmG9jl+aFu128wCFqozNonZQXBvvSJtaEWd/rQyOAsTFnr0LuO3vgHDZoUwg2DO00oj7jDjh9RlDk48E/BngvSftwjtGa/Z/mn5Q5V0s+yi76cAR2rhwNM4d6UYQb83Lm7aJANw9Cp5J0SassFfmppHletNlsh2RtbYOSiTZZxG+Eo+Xofvr2p60CxAl+MQb9VtkscsZB1lbnWvrE+nhgLMZCuSqWqU0V+R5FyxcA3X7xfNYYfoeorf5079AbwBWF9kzPSXcmrtFFB2bf0/e5LcqviTNh4zJ8UxO/uZlg9JBwNUgzcwkARHVYOLdpg0WjQt9NDYEzd5MSJ7www6xPZ0QRfJcYXLucdRyFPlPf2jTCF/gxTzUDs+QmJeKROSAIcE5089E5TAt2XP1/JhKsNJ4U07JrKr3HMyNXR2YSmgxz3QaNqkZFRCUZ/XPHeBCqffA+GyKaFJ1ubOaXDwP1buU4WuJ8lefCzGwvGXBmHF4acOYHcO1vckIYLdQKq9GihQnetSjiQ691bltXAstOEJ9dI4+Gu9dZe9U0kZrujDszXPBpNN0G5DbklWrvCEpHeA/ruZ0fz7wUy7sB1EBeHKMZa84hHsOrqyny2eaeDdNWT3KMNVA9poRBcApECcYPOA+6GDTpfWQ/0/Gct4DkpUTGHY6obBXkT7l++i6GFep98IttjuzRzJNlwxWNSHnyjGgybLUvU3CzvNHRY7/Bsr5s12Ixo1VUWlvojyhOn7w8P89EPc6GyGdJLv1x9i2OSc0GsbcqJ8KTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-05 22:23:29+0000, Jordan Richards wrote:
> From: Pasha Tatashin <pasha.tatashin@soleen.com>

(...)

> diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
> index 3c8721c505df..100dc0f69f37 100644
> --- a/tools/testing/selftests/liveupdate/luo_test_utils.c
> +++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
> @@ -20,9 +20,14 @@
>  #include <sys/stat.h>
>  #include <errno.h>
>  #include <stdarg.h>
> +#include <linux/unistd.h>
>  
>  #include "luo_test_utils.h"
>  
> +#ifdef NOLIBC
> +#include <sys.h>
> +#endif

This should not be necessary.
I am actively trying to get rid of the checks for the NOLIBC macro.

> +
>  int luo_open_device(void)
>  {
>  	return open(LUO_DEVICE, O_RDWR);

(...)

> @@ -45,8 +50,8 @@ int luo_retrieve_session(int luo_fd, const char *name)
>  {
>  	struct liveupdate_ioctl_retrieve_session arg = { .size = sizeof(arg) };
>  
> -	snprintf((char *)arg.name, LIVEUPDATE_SESSION_NAME_LENGTH, "%.*s",
> -		 LIVEUPDATE_SESSION_NAME_LENGTH - 1, name);
> +	strncpy((char *)arg.name, name, LIVEUPDATE_SESSION_NAME_LENGTH);
> +	arg.name[LIVEUPDATE_SESSION_NAME_LENGTH - 1] = '\0';

FWIW we are currently working on "%.*s" support.

>  
>  	if (ioctl(luo_fd, LIVEUPDATE_IOCTL_RETRIEVE_SESSION, &arg) < 0)
>  		return -errno;

(...)

