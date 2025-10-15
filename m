Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11128CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 16:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9E28E001F; Wed, 15 Oct 2025 12:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1C08E0005; Wed, 15 Oct 2025 12:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6998E001F; Wed, 15 Oct 2025 12:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 258658E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:36:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8D95C0121
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:36:08 +0000 (UTC)
X-FDA: 84000900816.27.B9C8B5C
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id C352C4000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:36:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CU1P3gxx;
	spf=pass (imf17.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760546166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pkn+CqkssDx8H+vXeI6R3v2XcqWE9l2NOxynVDwDTlI=;
	b=0UynUDX7NHVaEdgtT+2k0IsTUCYhAfGRHxb0oai0d9wLVhuuHYJrjp01myY+zM2Ifh1kkc
	omBD0bgq9/6H8EqwjPcoxJkDEpBtu3mwvWH95ydRt0U8fPKvQfn3y3fsA+uHRN9atpuwCq
	p9DvxeW3s8wYad/S+DbRyy24Tb7yL7M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CU1P3gxx;
	spf=pass (imf17.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760546166; a=rsa-sha256;
	cv=none;
	b=b2a72A+kWcyTNLJcwdE+0EzvsTw8MsEczQ/lubeiD0VaTPO4CJCDQrSGrLpgi9K9cuH+BU
	Oi20glcJYVaptwDL73VyWlJKv81A27iM8/R8pSJKfXMZs8WNJkp6F5JYk9Z0YEuoOqTOGE
	6BamrSvBMD+RujWHjbHhoFlpCCb53bU=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-33b9df47d7dso350447a91.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760546165; x=1761150965; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pkn+CqkssDx8H+vXeI6R3v2XcqWE9l2NOxynVDwDTlI=;
        b=CU1P3gxxKfzALa5hAZ4cA684T+mo8W6oWCzf8wmaov+WsE56OLXQho6LsmO3+NFFJg
         g/wjzi6VOmfgPTqC5Hjtl4hGzv/2ixn/HVhamDM7aDMOjyhofW7opBGPVZddeZZtm0vo
         SH3wqfCihb/kTxi8/VDrfHSsnVY/Xatjl3dYf9nH1a5V3VIaIer3o2KIlEoSk7GUJanY
         iANrBB03CQXOvNjHySoNHfJAewr7AJl96nuUHYia3Fzy4YgQ0KgnuwPio85DXSqe/k3E
         iVh8IKTyxiZWsf+mUoLkYsEXcKtn2G59eM7MGrE2f6YhkGVkgAWgfMK5a9P0kmFG/C8f
         ZMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760546165; x=1761150965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pkn+CqkssDx8H+vXeI6R3v2XcqWE9l2NOxynVDwDTlI=;
        b=pM5yv+s2/ypUdf8qEo5MjoCWIwyaAPY1qsS+kadFCc6CDzDIQK0OwwbQJYxaCkwOQK
         Z/4pC+GWn397ZsyJGowEb+jD4pl7nbWwlZCYD0XfYjkIo9G3DXE6QB2c5CD8KyEQgpSI
         KrZl2R1QumfantGIY49Zn1KxhhScq74jQSSfGBcw0tMTD0L2iupM7cSGnFhkBkTrzqr/
         Ghm5MrqrtCeAzxqJsmVkc7KJkOFBlC/xF6xN6OoFFfnuBbXHur3C1uIemk1u10sGFJ1Z
         ilg/m1ygK8889/EVmVcJW8s3WmRCporfp3bRx4TYHHST/ZJGnU8b1xbtH8sVrOeNOXHa
         3/pA==
X-Forwarded-Encrypted: i=1; AJvYcCWRiy6vfq9WW/kkmfyfAQcyIdc85K0wLOjHrPYsMQ41CJb9rjxiFN641iGwqtNzTlauqRVVCWTM1w==@kvack.org
X-Gm-Message-State: AOJu0YyCVYr2GsbzcsSiTy0XH6VuRFqSVeRM6WUSvk17/x/Gd7Q2UTOS
	U6mebmFXm/wW+6xrdVdMqxIBZPIkpB+Hj63oJMuTmjlVGqWgrjTAsuq8h1egeDQTWIjwld8Tdus
	kNvJg6If48W1aL5TssdwtbObwUr/OSKI=
X-Gm-Gg: ASbGnctIv+88fQJe5WtB1SNfleSgqHuXOwqEaK27FrIRZhsB838F55STjNAaivLKYRh
	zJAjK6TGtc9MMcpMibBjVWpMXmouQDUzJIqMIK2V5y2fRxJcvaFTpmB5nbNuQDK6qqbw4GtRudE
	FJYc9bZ49vsa7P885hJoPFmkOJbaFfHdtq7Wbn9n3U2UOtDAMnZvMLiFwZX30pczBjSujhjtCom
	KkmCyzuAsWpyZlWxKv2ChFWYVwvoE2viNJqMlnRiJ7CAKq6WLFuBB/ADauzmiQ=
X-Google-Smtp-Source: AGHT+IFGNrAI2dq3NSrRL0OcSYM4Z5okAFYQKhuh27ccqKymPLtZeC7L6zTwS+qJQzu1LIvsGty8JwB7F48ezlC7tv0=
X-Received: by 2002:a17:90b:3ec6:b0:339:ec9c:b26d with SMTP id
 98e67ed59e1d1-33b510f8488mr41389554a91.8.1760546165323; Wed, 15 Oct 2025
 09:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <20251015141716.887-1-laoar.shao@gmail.com> <20251015141716.887-7-laoar.shao@gmail.com>
In-Reply-To: <20251015141716.887-7-laoar.shao@gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 15 Oct 2025 09:35:52 -0700
X-Gm-Features: AS18NWADyZQhCWHApHI8yY-s9dj0g7hVHDNjJ__LLzs5iWjWLcNDNGLGYWesqlU
Message-ID: <CAEf4BzZYk+LyR0WTQ+TinEqC0Av8MuO-tKxqhEFbOw=Gu+D_gQ@mail.gmail.com>
Subject: Re: [RFC PATCH v10 mm-new 6/9] bpf: mark mm->owner as __safe_rcu_or_null
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, tj@kernel.org, lance.yang@linux.dev, 
	rdunlap@infradead.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8t7y64xkioyiu4wr4d5o9dqpujyztd6u
X-Rspamd-Queue-Id: C352C4000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760546166-96893
X-HE-Meta: U2FsdGVkX1/BgWeDsLHOLE7qUeoHZ8ZMgosquw5M3H8cHjq9eKor4OW1rAIVeTZTA8W78K2aoFfNUVlQlR4s1Yp8bIHaxPX2u4mroEC/75LX7URwsadRcDWTy8MPIZj2qticpA1atXbg5DQ8/dQhqdNTFTJG7d9uGuSc3U/Sx8F4NKTulF8/jyaWVaFFq3QHR0O3odfW9RI2RxfY0xVwffbs/rB3hQdxAUtOvC7wS1e/JKd1gdQ/DYJGfxsN9Ehol/jIVTkwhHUyNoHwSO4OtCyiuv4V4LB+yLzND5diHVlE5TVeloXll5OCf+cNoEwI9TRG4/fRTxOAxYvqrBXTlpt5cH1o15grmpxPgjohzVpOFo/Kz6AB2dRgFqLmkDU1we3zldNBSPWT4gaP8SWjQT4er3VbLCr3cs7FSWglDwqsTUvRFqrcsJ71icuAtyB/xfch3b3tR0i012ruDfbYLmAAS2DgJEQUvh4RQohos6rQNlLNXcJ6z8bum5ol6NachnO/e1MEllcppNaAS/X3pkr4YVKtTwxn0YG8gHMN/GTxxmBkaOb3xb6QbvzWRB4dyMoCFqQyWfa+SX+esOkVBMatjGAJIisfjuioymDIvjxZyKuy9VDF1AQll56cROSnc/tl42xGhX7vhzk/vJcDybmxAQUSU9MYOAzITqDel+ZcPyNeDW2w1SeoZ+zXPQ21g2uXeatTvlY8XAnxi7ikehEjjYL9chIzZrEzbCl7pfThb+UVFgA62a03gB5bGjnwebUG08ddBLb9e2Qjw+SkvUja2sfi/wvcjv7d+nVFoMJdyezzODkE3kyqdFxh48VvJeYWPAHcmHElRLj7woDkdn1tggYw+mXETS55Eo1Xj4VSCq4Kwh5kH5PvOJFyEjpYZvWhfLS54M9iNFGmTO8gv2QQXUGX+WfzHzCoWApMkuGcNyTsq0vobRDxf+3YRezJQPUb82mD3G3XuADoOKp
 PInn61NN
 lItGAlY/kRc83iP9HyNSOu2wdOBqV1td85+MkuQqvVXSpUj3y7Zt83BUMUclG/7QJpV3F0djLyGWHgWKMyRnbeSsW9B6DM2PJ4RTC8cqPeVP+vTx2l5rqXjCaC8YmY2MevVpMOT2aLDXMFav9YmAZYYCfGma3BjuV8+pmwLjtjIjan4k4+1RAcUfEDhmWcNORTpvp9sr2+lHSLEFg6wfXkM+ZwwDHTSUxKJqPN0oQ9DpqY/mg/0xCysGhG0Y6FKfWsGcJMxTcqCO+5asZPSytT5oGkaJ0xBgoL/Aok6G1wRynY6BcchjsPRlnnqDIoLUJwQZnQN9XGvx1Ih91dj6Y540j1dz6f8UlSx39aHgi3LjP3SRSAGBa+T0sdZ676s05NiOlh0Csmq5EcjyJ+XYjE4T1p4j5Ki54ZczrlhDcrPHyZnH0JUmHvZWrHokALCh6y3ZBjGUL15PkIhVovjP0doNlo57g2N0eMmFR3CvEMGG1r4an6cElKmWzETdS9R07rVEMY0j9lePe84Nx+TQAyTo/dfmMxW6Jn/Ur
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 7:18=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> When CONFIG_MEMCG is enabled, we can access mm->owner under RCU. The
> owner can be NULL. With this change, BPF helpers can safely access
> mm->owner to retrieve the associated task from the mm. We can then make
> policy decision based on the task attribute.
>
> The typical use case is as follows,
>
>   bpf_rcu_read_lock(); // rcu lock must be held for rcu trusted field
>   @owner =3D @mm->owner; // mm_struct::owner is rcu trusted or null
>   if (!@owner)
>       goto out;
>
>   /* Do something based on the task attribute */
>
> out:
>   bpf_rcu_read_unlock();
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  kernel/bpf/verifier.c | 3 +++
>  1 file changed, 3 insertions(+)
>

I thought you were going to send this and next patches outside of your
thp patch set to land them sooner, as they don't have dependency on
the rest of the patches and are useful on their own?

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index c4f69a9e9af6..d400e18ee31e 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7123,6 +7123,9 @@ BTF_TYPE_SAFE_RCU(struct cgroup_subsys_state) {
>  /* RCU trusted: these fields are trusted in RCU CS and can be NULL */
>  BTF_TYPE_SAFE_RCU_OR_NULL(struct mm_struct) {
>         struct file __rcu *exe_file;
> +#ifdef CONFIG_MEMCG
> +       struct task_struct __rcu *owner;
> +#endif
>  };
>
>  /* skb->sk, req->sk are not RCU protected, but we mark them as such
> --
> 2.47.3
>

