Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38242FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 09:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DB26B0005; Mon, 27 Apr 2026 05:51:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7036B0088; Mon, 27 Apr 2026 05:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6AB6B008A; Mon, 27 Apr 2026 05:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9716B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:51:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDE26850F4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:51:42 +0000 (UTC)
X-FDA: 84703868844.09.DDBFA4F
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3970920005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:51:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=dJ5FQ6tW;
	spf=pass (imf13.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777283501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U24W61a/YNqgXNzTblTVizxNJMBlhwv2QrqYIkMe9VQ=;
	b=yyIV0PHqfew2eJWMpPa0eRTJ+TuiY6NjxJxw9jcmxGONd92xLJyzvKpzdNtHcUqb7tqinO
	1QMoxaDYB4fBY9H+1EBUCgbYxFSvBfapgOW3jVCeD2cQjj/vzCFkK3JtKw/FUKg0ftxift
	E+BOFhBiC47c3D+2rIeiDeiH8d/yJmA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=dJ5FQ6tW;
	spf=pass (imf13.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777283501; a=rsa-sha256;
	cv=none;
	b=1AML0pfiWjmBNQBbB8dKSXOtfpJyd3hxdxIzup+Zg69I8D2HbL5Oh5+OjdAcLmNThhBjh4
	ZTuSqPN797oA89duMoVm54E52VVtWCAtJTkTMTiWBMXejEHnVL4C0SOyVe+zHf5V83LHsi
	Gz9k6WXftQYGpdRaQFgLTf527Q3ZJTg=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net D2FA542B3D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1777283499; bh=U24W61a/YNqgXNzTblTVizxNJMBlhwv2QrqYIkMe9VQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=dJ5FQ6tWKgyAF6jjFtQ4OOOm4xXHPG9W6DpztzKlFulKnALB/vCJHqDaL6vYOEa6v
	 KoKEFzsJSm7fiDeXLA/0jqRZEEcgAKJyCz9IS1R0WDpTtWhOxYUWVq8oHMPHj9JgVw
	 UY/kP8z82suf68ewf3WON44ZRJ9WhRXgLd/pkLo9kjZvCLpIPjujNSmyk4jPAAQSSR
	 xUdmlsL8Z3tED1QPpjrTep5ax5O7hR77R+9QHlYUMBR7GTKUkd28hlevSrtwoxqRbz
	 3ThM6Sn+HELH9tMzOURezCwLo5TXZts0lYuNWDdudpymU47qsa1WQlE1hl43GbOnfK
	 EuxaekXVzq/cg==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id D2FA542B3D;
	Mon, 27 Apr 2026 09:51:38 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Manuel Ebner <manuelebner@mailbox.org>, Shuah Khan
 <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, Kees Cook
 <kees@kernel.org>, linux-kernel@vger.kernel.org
Cc: workflows@vger.kernel.org, linux-mm@kvack.org, Geert Uytterhoeven
 <geert@linux-m68k.org>, Manuel Ebner <manuelebner@mailbox.org>
Subject: Re: [PATCH v3 3/3] Documentation: deprecated.rst: kmalloc-family:
 mark argument as optional
In-Reply-To: <20260424175740.258522-2-manuelebner@mailbox.org>
References: <20260424174743.257951-2-manuelebner@mailbox.org>
 <20260424175740.258522-2-manuelebner@mailbox.org>
Date: Mon, 27 Apr 2026 03:51:35 -0600
Message-ID: <871pg0ras8.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: gmpx65zr9nonoktuja39hstax7f1foj7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3970920005
X-Rspam-User: 
X-HE-Tag: 1777283501-363243
X-HE-Meta: U2FsdGVkX18e7/6DlxFRkr1Fn/4YqOSl0MnN2qtk7mBehcoPtbw6Q7d/2lxEgx5BRzbG5fWtrYzuLv9hnAX2sKmRN2PwPI3dAw6ljaqpsRzFiqjcVuESnfa6fPDQFX6+FXANJUYEYtFzc0EJ4OAXepH/BCQ9cRAiwayT6xrD9NjA2SI6VJqLSI+6ZAYfxSlPYdGJkoI/1DaRJYr+lgyr3nnPcXje6fWGzPUF4RAaformOr5W0V/LnZ92KQrDp8nSVICO+a2pgoxb05372ZVlcc61p2JqAE7dAxJhKkuFeYwKll7xYrG05b01UUZ40GEfU0k4ErJITqhCHGdNqWZeGqojIIwJ6SFf0y7hUhmN6HTeIgcrrv5sh4z6Wi/+8NnDnfFye1PlsTb6Kgb+GwKeUkA5AhebBs+Fc/GNiRLtahScolcRlyZwuS6rm5tGJMnmwZo9kanNF2GTLa+6J6T+4FTAgHwpJqEzHHQt/dzewhgtVTup2cGQLLJQTGBwTNQiDFpWufuzliar+NoGTWoNlKUL3xsgcRMdiAGf585j7vh1BcM/n/RoIPR7EfCuA3DJrQRWQthaqpWH+0S02ka++CXeg5Eglx8Jvo1vYYn5QYrabVvZFIq67M/a0V7/LNOLW/jSYRUfdnZ9O1mwjgm4dISpaQSvb/jV471845hy9LjkZ+Ot5Le1LJAWO6l1HlcfxJkmltvurvrj5RgWrz+VP0fybbL50LAJdUojV+1KMPML4J/He+WPejEA90bq3HbpsKzFsjA6ql/OPndgoj8fH2PwLb7OhS5fJ9gUlCRzSjGiN6mzI/Ce0L/dHJQ5XnEBxnCiETfMYCEz/lq/1Z8OYzI7vBioGCPFJgqeR7uCkm5JhVotuJYxyT/x31PgsG2aYuMGDA9DDdQEhyVDCZbN14Cbr4dIY31592JQxXP74+3+xq38ku3togs+v3s2efDCvy0M+4hZ39E4bfDjF65
 n2VbwguS
 NYCL1uzMN9Vg9B0/gb9ycClgHbSoUhg4p+CEwAGR0lfK7ujAL/7NlInWHxNXWGrU3yEZst2cM3rgyv7MYUNcXGdxi2vHZpBdYIFRBXW7rPUw5T9NdevmeZDWMJAFyQd16tKYkL6WyHAZ1vud4ebpgMLhv1pIlSdKdWXDkgwG4A2dBnYiDnfdRhc9yaPFZIPonBjathttvgAvIYICpwRA6WJR3588wGyhzUc+rvPzM+KLXWxj9Cv16LdXST/MpRxmnEZvwveiXLQWIjwPi0p5GCqXtRTXZxipfcYNq3Quc1m3bBtTg/aG/6VMZ/sECu3fkmfIt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Manuel Ebner <manuelebner@mailbox.org> writes:

> put the optional argument (gfp) in square brackets
> add whitespace for readability
>
> eg. ptr = kmalloc_obj(*ptr, gfp);
>  -> ptr = kmalloc_obj(*ptr [, gfp] );
>
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> ---
>  Documentation/process/deprecated.rst | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
> index fed56864d036..b431993fd08e 100644
> --- a/Documentation/process/deprecated.rst
> +++ b/Documentation/process/deprecated.rst
> @@ -392,12 +392,12 @@ allocations. For example, these open coded assignments::
>  
>  become, respectively::
>  
> -	ptr = kmalloc_obj(*ptr, gfp);
> -	ptr = kzalloc_obj(*ptr, gfp);
> -	ptr = kmalloc_objs(*ptr, count, gfp);
> -	ptr = kzalloc_objs(*ptr, count, gfp);
> -	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
> -	__auto_type ptr = kmalloc_obj(struct foo, gfp);
> +	ptr = kmalloc_obj(*ptr [, gfp] );
> +	ptr = kzalloc_obj(*ptr [, gfp] );
> +	ptr = kmalloc_objs(*ptr, count [, gfp] );
> +	ptr = kzalloc_objs(*ptr, count [, gfp] );
> +	ptr = kmalloc_flex(*ptr, flex_member, count [, gfp] );
> +	__auto_type ptr = kmalloc_obj(struct foo [, gfp] );
>  

Marking the GFP argument as optional is fine, but the documentation
should surely say what the default is.

There are, of course, other kmalloc()-related entries in that file that
could use an update, but that is a job for another time, I guess.

Thanks,

jon

