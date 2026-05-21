Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32D68CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3E06B0096; Thu, 21 May 2026 13:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874856B009D; Thu, 21 May 2026 13:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78ACC6B009F; Thu, 21 May 2026 13:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6769D6B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:57:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D8331C04C5
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:57:52 +0000 (UTC)
X-FDA: 84792185184.16.BFFD081
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 69D73180004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:57:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hI0bHGIc;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779386270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSg+nGWk8GPf9iWHEueYvLqEM2Vxl0dwdaE30hzKrbQ=;
	b=uqRBu7NOzPhqDWy6PCL/5ehKoN+B7wXUraCtKXKXqtScffaiRQ4lV3SUJx7rVTMBKOvwc3
	PLIA6F5Mn61aKGzSTTKtZUrtJ0bxBaV1vJ0+2gpa3nqhQdY28Bp+YT0kkWlPazIJMz461A
	KGz8tO1ooRI7whgvijPsd1uCGD0kRGs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hI0bHGIc;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779386270; a=rsa-sha256;
	cv=none;
	b=iEyX5lRVNcpf+ZCG6cIPWmhLizRJ+GKRBfkhID46wo2+XE+pR2Fp2aqdFWp2BFGtnEx2Ca
	ZBKSTj0uaPWlhkZDRk29AKaFOYqs9WeGqzaWW4Pj0JhqOYJSjyjYEmnYMyXkH33STXUfmv
	Bl1AxQYsq/AYD6TMtLf4BrQsKUrpCK0=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8cac189e516so32118546d6.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 10:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779386269; x=1779991069; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HSg+nGWk8GPf9iWHEueYvLqEM2Vxl0dwdaE30hzKrbQ=;
        b=hI0bHGIcSFs1pEx70ZXM3vIg4iEYTLZvVyTYSF0pCQuE/Sz8Gm1uVCd5M46CAXxxPJ
         NF/dKbhFmzDKZBbjoAD04l6DxqlAbvelSTV3MlXqeB+wZYMMoC09UXqUrbuxlQLCqURS
         PGU6S1ih9siloS7piOJs8w5OB0KSXq7QSoQ5bciOEg1s/W+zUMgWTe9lV/PkKg6F4JQ5
         N2Qdwsq1d+LDlG449ATOwg9/haLICT0uQPfm8Ufyuyq96XE/j/PWbas7sWLz9gwmEa7o
         PvMj2ZI8TxEDnJ2Mkv/pKHv15aMvR71WsYTN8cqOtotydtKV5V+F5UATefQ/8b43LR5S
         VVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779386269; x=1779991069;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HSg+nGWk8GPf9iWHEueYvLqEM2Vxl0dwdaE30hzKrbQ=;
        b=l67sKj1uoBHJPnoec12q4dBDjZFcnxU4Z5FJ7PCREmAp4ehI1hxzf/7gnNh13Ejt84
         n2M68VkpgthJs6OlTCnTCsNAd8YJuQeHTWIXQobkk2p1S6hQAhOIlpi7ULNkMqXCdqF5
         9nmcfNmu5oZr1ctwj20CJATxL+hASCNGWJmdFQg4MfoFP5dtCA2NZz2sYQxw1fFcVus+
         cImUf6OUGlKnLskItOfTL3Ckdm3qeSR51byJRXPcYifXYQqUqeq8aQOpKG3+5Yxjqbij
         PLaxFKY5fYFGNadUXknfEEboklmR0kpTAWY9gPA3L8fSKGWHzyhuq5TuaURPxCDOC12I
         H/Jw==
X-Forwarded-Encrypted: i=1; AFNElJ/ospSpUcYZxPE2M50HlkhyyMPtiEEkAG7byHZ1zcOBTdfHIIHkCDJw5VOi2tldf66DjVwKaDfNAA==@kvack.org
X-Gm-Message-State: AOJu0Yy3uhCfkSCojWUubdIKA7xdDWX96p+Pirj27IauAWwZdJFkbkgJ
	JydVQICQYTzEw496Fa9ZAgZXBoaHGBlIUa005jm6Xtgl6Qx4vs4JHetJROSC4DF69eVL0KpHabj
	yoTm7
X-Gm-Gg: Acq92OEkdGFXJ5y3p7wetpCAUTcq25OBrlSfL42mnD4UurFUCmE1TKt55U6Ra46JDb3
	rKzKTD3fO8+Tut0KZsLSrp5L2Z15Cop/qly/PHfpvbiLjSJPu47I0PjVcbG0Y4IPRceze4syu2d
	9TcCATu7JsvNn28lPO4I4cexBtmE+aPsT8Fhj3yoMAm+2dQxogDofQfBYxFncj/2Ab5evsVsYwO
	5hsY19Af1bQFXCB5bJI8e3MACecAj+P0yVqlC72BuWLaTC6Tep2nos1B1U9wLrveFuNaMOAqYgk
	Q291Yz/p20PTezjgVZ51sIT2tWavBpFFJwphqksflQFfrONfGmROcblTgS+LzoFokS1OvyFa1fn
	xcOYI4DaieOjY/YCk/coYYkVwi+BzmsGrV238/rrqn/Ed2/RfhNJfPjZCmZwE4m7hPNJcDITNoY
	yJha5jccht6drOJjy606FV4yrhIYSeYbihNtf8FF6JQxQjC9N1hC8=
X-Received: by 2002:a05:6214:501c:b0:8ba:b699:9e54 with SMTP id 6a1803df08f44-8cc7b5f1a7amr5338246d6.47.1779386269340;
        Thu, 21 May 2026 10:57:49 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc781b3611sm13231686d6.26.2026.05.21.10.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 10:57:48 -0700 (PDT)
Date: Thu, 21 May 2026 17:57:47 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	pasha.tatashin@soleen.com, pratyush@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] liveupdate: document systemd support
Message-ID: <ag9Hj5j4OFRn1G8c@plex>
References: <20260519152957.548119-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519152957.548119-1-luca.boccassi@gmail.com>
X-Stat-Signature: nito71fwo6toeza18ofkxd6rh6iq8fe8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69D73180004
X-HE-Tag: 1779386270-146961
X-HE-Meta: U2FsdGVkX180BAzd7WUmkuk/gtARnRh+oQ4MeHcfVvcQdUuZ/n9VQrk76fCZksWz/lf6ZatN+E0JRNMClgKzlNKEa9ekdKcZbkXLOzSQ1BW/tl/dG2lw5TfIp1TV2t8vJyK99l+VWGbZqmA2SSYCClN2FzPEO7zGkcpdTzO6LW2pWDmEsdgSEJhmfi4zn9bX62B+uZK9D67fWqIcc1KDGlIKBHi/DbmdPiHacwdtb+LurOQiMmUT1o/RWhUUjzBQi7tOVr4DCr800yQfmxjTLrOyOUq7fQcb8Zi5Qnw88b1Chv1QUmGlKSP69JEq964WDktFQVMX2B4ejq1qTQWTNvRFxrviRNAq5aygCZ/wDroB4o/bPfLu1yzJtm7J2IeppTiD0rdjMLbCDZHYdHjlRF4r67LGF1f7/kHPTNwok0aX0LHg47BsOfuWi3UdkOTt0C9eMWIIozL91NpPUxggeDiEr+CucjIl9vkNsog12epi6BoqBM3MSs4CihAV5KuQJpPQzGv+HSS59VSfYMW63snuHgh/zdbpA4g/APjmbCV7f6KIK5OHOhOtNxRagOnJUwtY931Z5xI2Si1dxE1E/DId1Mu717zwIK+4eZDj7tAlFgPgdC83qW78y8pEt3butQtlWjOinVNChZkQseEReQ9JB5/MXkwsm0kY5/L5QtDVVwwekpyLMbfICp4y7HIVIkow6Zd9Glx/rgaGcgZP+t2DvCBZprPILpdP+7UwTqfz1a/zEpTv5+QglB3s98VS43/9IZ+GxDMmvxlpbJHtkRck/gtLQUE4xtTQhQNi3GiVps24SoCSpvU/xx0W8AmulOHI2WOqi/E9j6DsapPwnnuqtGmXq90my9VpxRq/mwBPksBGfZiru02AT6WyWD6+ga7vf8Y9/B9BeN6C92DSY4Nmd62JP075EkXbiinsKvTdlyoUkLyUcqU6sJ6+q0WQDS1vkav2S1NHSuKAgWL
 wu6T5brn
 TAxdmJdPzUB1jeEmGAHvke926PUgippaXORg/YU7sYlE+4nR+DLcfpZeztS6Ml4vg9oxygvJFMyvlo4bcPbNIyOIZbZ+9W1SB/+FKy/AX0DpQz5gp2fo+1CvI3E1yxjhFdZb5tdbu51cOLT/8cokOOP/XCwdMIDc929MYO6910z7huRtJzWriTI9xhsFfd9BjZ45q5kQgTC5plzQbYQC0amevBh/cCFgXg0oo5LPcEaK0bo84o+m/yHqKM94WPJiC7vWjsrtpc0/DMOohsMmuLOUepJ/LMddzjKdrGf4XZXDX8mWWMNZntyQ4Z3QFBpnu2Yw/9aAQ4CU9SdsMSFlOdhvFYWkYIHMoxA0DpFQyX+6yNWJTx2dS9XeFfi/ssp9ltd0By/3PwUoYhC0EKp89ebd2DWh1+drzegOz5dx5YMH1nF9UifWk+u87P6YbMyPocUXlJ04t+jroQwSytR21JKSQfIqJoeNZY6GEq0K5T3aGzBxN9OAanmQ+YZezn6YsPl1t7aRsWO1g9e6pAGgGp7rtRZmPw6M/bWK7P8Lm7+YbmD7RpavdVJEmmiT9RsN5+vPWOGlYz+7u8PqtYw4gdiLpwdpPGFf4KYOQ1oiWuYu5il/dWcViq65QiONmW/IbFdp9PweSryKmUStBX1OwA9erJoyPX71aRv+KHZ4n8UjsTfs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-19 16:28, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> systemd v261 will add native support for LUO via the file descriptor
> store mechanism. Add a brief paragraph in the LUO userspace documentation
> page to inform users.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> ---
> NOTE: the external links will mention LUO after the next release is
>       published, which should happen within ~4 weeks
> 
>  Documentation/userspace-api/liveupdate.rst | 23 ++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
> index 41c0473e4f16..f6efc32fb40b 100644
> --- a/Documentation/userspace-api/liveupdate.rst
> +++ b/Documentation/userspace-api/liveupdate.rst
> @@ -14,6 +14,29 @@ ioctl uAPI
>  ===========
>  .. kernel-doc:: include/uapi/linux/liveupdate.h
>  
> +Userspace Integration
> +=====================
> +
> +systemd (since version v261) uses LUO to preserve its per-service file
> +descriptor store across a kexec-based live update. Services opt in by setting
> +``FileDescriptorStoreMax=`` and ``FileDescriptorStorePreserve=`` in their unit,
> +and push file descriptors with a name into the store via
> +``sd_pid_notify_with_fds(... "FDSTORE=1\nFDNAME=foo")``.
> +
> +Services may also create their own LUO sessions (via ``/dev/liveupdate``) and
> +push the resulting session fds into their file descriptor store like any other
> +fd. systemd detects such session fds and handles them accordingly, and
> +hands the re-retrieved session fd back to the service after kexec, using the
> +existing file descriptor store service interface.
> +
> +For details, see:
> +
> +- `File Descriptor Store <https://systemd.io/FILE_DESCRIPTOR_STORE/>`_
> +- `systemd.service(5) FileDescriptorStorePreserve=
> +  <https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html#FileDescriptorStorePreserve=>`_
> +- `sd_pid_notify_with_fds(3)
> +  <https://www.freedesktop.org/software/systemd/man/latest/sd_pid_notify_with_fds.html>`_
> +

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

>  See Also
>  ========
>  
> -- 
> 2.47.3
> 

