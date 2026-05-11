Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3ABBCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 354BC6B00C4; Mon, 11 May 2026 07:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32CA06B00C6; Mon, 11 May 2026 07:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2429C6B00C7; Mon, 11 May 2026 07:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 12CF06B00C4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:59:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2288120681
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:59:14 +0000 (UTC)
X-FDA: 84754993428.01.BC1271C
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id DDE9C8000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:59:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H6E4yrx9;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778500753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=btlqUdi0qGhMKZ3fIin3gDvxyyqT63yde/F745AE8nE=;
	b=K4WY0IxgvnjDsy+q+iVxHZTG6Z6vg54gXkES+QrmJZWzsUqjssgC+0oN/C5Fxp5NoQ84Qy
	0GPGSGOQ/CHofW5WmyeP/EiaowfRiePBxqZrJ0wLWSHc4yhlPXgcJcLYJerSqvJYXX1Mi/
	14BCr5rUHqi+xwBw2DbPx166U+r3ovg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H6E4yrx9;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778500753; a=rsa-sha256;
	cv=none;
	b=Zz+Nr2PcUF0l5htTb9XljlsiiYGretMRD5nAI6LlGgX63rPz96eKh9m5P3SpEoUJWD1beA
	AsNWbhd7UpWmT63riQxZfx0JxFTW4ps/eILzh78azVfC4A/spO/aiX0VqURiS111Pd0GhD
	oFpre/8T4iJD8p5zH8zBD2qNZxbr/vg=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-44e1860558fso2734460f8f.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 04:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778500751; x=1779105551; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=btlqUdi0qGhMKZ3fIin3gDvxyyqT63yde/F745AE8nE=;
        b=H6E4yrx9Y8kAwGKiXqKtTnM6U34qRi51WPjb96NwBPIDvseP7E2yobHFEQ2opaO0+n
         zrCkEzuo9nEx8YQgoxUcVUPeeNwsMmeKGl2T2/HEWn5RGZvs1YPPpYd7Co9rk4j6WM/L
         R6/+vZdb02iYgWAsdQMYLBGZrm+zKIx+E2DcoAHKqW5zB4w9xoqG4CUUL8XegrBPkKYx
         +Xq6wNhFSAmB0ee/ubZi5ykvbOp/E05ukk3WkT9+lE/FhaRCrs1k1rYlL56CLplNn/hL
         I8Sna9ruoAwPXVxKeRRYCLU19DMNNjype72T7jAL1RsVppoA7NyJUtp7vbktNu0BFna2
         rhhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778500751; x=1779105551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=btlqUdi0qGhMKZ3fIin3gDvxyyqT63yde/F745AE8nE=;
        b=Hzqmud7unHbn5j8wMn/eHKQxZ3Z+vB/1FsmcI1UjEhTRl1QZhye+pT7k/kd5unmu1O
         St1q61zLJr94lbU9tuvICSDbsu47EdTj5hZVQAZmJVrA32dsHuHaefE8O8FhD3L5TXQ9
         d5/sMTa1lUzSGiMQMpckIq/r7/tfBKF2pJgtF+ay8s41kmk15ABg+v4/aZdXd2GSmKoi
         v8fuQD60VW3y1w5UkJbfJfZ6zpJi0VcmDPeyMzwie7U4VHrP16+WSM8cQmxoGg6stywb
         YC8Nkg7Ysy2a7MXPkBCq6cjSboScSrH0Aem4ezhhwiAjCjX1qYHHgBBX7McILdgtY+t7
         1loA==
X-Forwarded-Encrypted: i=1; AFNElJ9ueWnnsIe8OOguxg/1rOktqVqq9sm5ggM41q5VlMCasBKOQBlc7218NydTZsdYgDfRd9WslDcMZA==@kvack.org
X-Gm-Message-State: AOJu0YwKHrit1+l6AvrPXCWZiGiJ4QM+5gOFr7ENmGPVVsPXuA9f+BrL
	V8x9XPSE896kYI0x1wOxfNAsTznbMVmlkKL6hmqkyaPBWb7sNAcMwlGR
X-Gm-Gg: Acq92OGOVc/ne+mOgWsyEgOhBTW/f8lZY0txOyBNy1FM2Kx4GVbFAsKFqq6WziU8NuJ
	S1LKakP83Ok16geopY9riqe/VnfJlTeue9xZTteql4aUY9roNTkDTzGsOu0LC6QdovKJsRSJMYG
	t5uokyuV34B/C9t9Xj2HojC4oecLg/T11W5jep448FnnpGoemEE3ZNAoW8ir6RUOaUT/9QTsORv
	9zkWCMQQNixoc/FZV5691CbrMmwQ60G7AiEA4vPWZ7LoSKDYjnua6QWZ4kkO9xJ6vsJkQ0vGupB
	dESvmbJnPf5tK6vpjRe7e9jTCynuPskb3iRNIP28zh0PT4lXagqDCzAcTOnkMErJCwSHkreHPR+
	1eAAMpOqlmMZmBxl4yjJQKPwR+iWVq6nArtpjSssCT1betzNZCpRFFKkSPfIpox7KtymBfwynOd
	i/PhV0gx/T1SedvwYn29ANyV54/UMF/AmsG/65fyeWaO/AIzOwXpNVaCz8tB1ZQivP+ig8Bfq8G
	69uQxayAmUq
X-Received: by 2002:a5d:588e:0:b0:43d:184:8aa2 with SMTP id ffacd0b85a97d-4546140b235mr21067301f8f.16.1778500750944;
        Mon, 11 May 2026 04:59:10 -0700 (PDT)
Received: from fedora ([185.193.234.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491bae13csm24580060f8f.29.2026.05.11.04.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 04:59:10 -0700 (PDT)
Date: Mon, 11 May 2026 12:59:08 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org,
	mkoutny@suse.com, shuah@kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: check malloc return value in
 alloc_anon functions
Message-ID: <agHEjG7_fHMAnQrw@fedora>
References: <20260511021615.1768623-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511021615.1768623-1-lihongfu@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: DDE9C8000A
X-Rspamd-Server: rspam06
X-Stat-Signature: pxtjy1ed6pzbbw7pwksh6pemheksh1dh
X-HE-Tag: 1778500752-395238
X-HE-Meta: U2FsdGVkX1/vsf9KuxKEAzKSRt7FZx5lgAS2fLdzu1fDJWBIi5okHZ6lmoIrTZ+ZDuml/jHbjfyOBuB1Y+vziFXwRqd6LZxiVrXveRFmQUJ82vuEw4ddLdVJ2KXfahBkuPwi/jCaKJgHELi9Fa9KKr4S22rtbiJQaHe9YeAB/VQzyQiO9kGmh0CrisctmIWJpp8BnFrChb4n316nBilOruiPLNlNtec5sJhQYvHAQToTHlSDAtBI9ee3PXYz6OSjRawNxe7SeAZPjF3uNBp7c6hCCNEquMGDpsXO8RK9xzBSHf2jwv/elxA9XvLIq5CJKu7QAvnKAdVuKI2rzzbgGc1aGR+VUotXXA2HCimlpdNNXAhXp2yjI6ASDbHyiNktJR8O2TyrkJVnDa7YuxtNbrwWmMg+sk/IUjDioX4Wm6fUOe0jkPC+zOLLZouciJz6o3bqLjuX8ZIAcahdsK3a7VYR2YSUFipX24el6Lf+q/jU3RXTz8GuGhTEmZUerqX3i2WuwKRTqjHU+Wg1zQyHLn/WobAdrqn/6hbjY5HDOrg/P1Vh+ITJxSOsu4pPKy2mcU1RfCEpQQ5kNDs1+Jkkk+D4UXFR9qpt8117/vQONusttAUegEyrHAhK7tFmeMt0lJEKLfiDqsw2mxlWOXwe+SbZJlc8Wafww4aJaRPWmG4xFQxnn0LScIB9J1t8qerSlR8MoMDBePI/O7Q7kAKOotlQzVhFy4TbeL4/bvM19ijxPnVpbZ1zSscQdpNFj+I9zrb9ahMH6SVQ1uLXZeptmret9JSF9yQijucbbBRNN7kAMTBSs5ZSyhUkKJudEhyJGvFZ2IVeJqZH+0Ep38yo6HXqfkoP9V4SnIRxPHy6zzraytvWo5GTiALwKwLpnAbUqWiPu9jT2YJN/SpLZpUXJmiWtON0N6PD0FkLWzHb2zE0PFNKVR28Vx+xzUmAyApJSoSKmigWwd7V8TkNckl
 m3NNtuEU
 10txAjfmFzAYtF9bJl8QWqEfTXvpKlGgJP5XeuXMrn0YYmTgVqOv8tVdVDiUOt8dpb4SQxAHdbRywVc1Esk1F6PEtGCMXShI4LiTk/E0OZWSQBEW6npy2zVzc+UO1iipjCWTA/WrXubAYKHBY3nGcvZDuVGjisWmv1i8Vb2hQis8aFUJTn85Zsbzg35J8TLoPvXGaLuEg0g/Loohbxok168JDsH5EqQLBqh09aZMkngveBIuaumDI1XGzzdg8NtLlK1R3uQcnPDuncAUP4MPVG52lia48Z4zdmNbV7dvii4IVhKj6PZ5Z9oTS47JCEtAw/XeXd7mOwWgxHxxGrylrg+wHKEsDqOeyvYnmFsWHXncpYqwwEiTE/1ZkMPsmkNCGjCatMK0RGa6KIBQEs6Uo+qfEA70gctvcIA0J0prP3YTv8WkGMDxdZfUI3meZhlq+rdt8ERkIAaGgJWW/fzr8NxTfDHGJDLGP/lkk9M3ETYSMnPW+mFNZwGHuovOdrEmZD8I7EW2rRueqrmvO3xJkL9AMVLCgcphnH055
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:16:15AM +0800, Hongfu Li wrote:
> The alloc_anon() function calls malloc() without checking for a NULL
> return. If memory allocation fails, a NULL pointer dereference will
> occur when accessing the buffer.
> 
> Add proper error handling to return -1 when malloc() fails in all
> four alloc_anon variants:
> - alloc_anon()

Just a nit, It looks like the below already have proper error handling.

> - alloc_anon_50M_check()
> - alloc_anon_noexit()
> - alloc_anon_50M_check_swap()
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  tools/testing/selftests/cgroup/test_memcontrol.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index b43da9bc20c4..8ef9c99a82eb 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -61,6 +61,11 @@ int alloc_anon(const char *cgroup, void *arg)
>  	char *buf, *ptr;
>  
>  	buf = malloc(size);
> +	if (buf == NULL) {
> +		fprintf(stderr, "malloc() failed\n");
> +		return -1;
> +	}
> +
>  	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
>  		*ptr = 0;

Every malloc() call in this file has this same pattern. Maybe we'd be
better off making it a helper function?

Either way:
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>

