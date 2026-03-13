Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0D81106FD87
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 06:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E371F6B0005; Fri, 13 Mar 2026 02:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E9D6B0088; Fri, 13 Mar 2026 02:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44DB6B0089; Fri, 13 Mar 2026 02:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF7876B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:34:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44E0B8C572
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:34:59 +0000 (UTC)
X-FDA: 84540077118.09.C313BF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6CDCF80003
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:34:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZYZpciPZ;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773383697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hP2MZ2cU92XBFFH3E10K2WslEqfEtW3X4XUIOgjyBa0=;
	b=deQVJ6mZYIiZch0zUqugbmlzWxyyp4ZfhxZCdXckYmTJmvu7QLulxkxRj/AX8F22m16c83
	hG0PGqzkm2FZV2fWq0zP08TG8kjksIhX1GipLCXBPD9ZUupS+LM0sDIfk8OwEiYiWS/U5N
	XJBsEz9UiVhApujBdrFqqcx6oyPUonI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773383697; a=rsa-sha256;
	cv=none;
	b=TIDRy50LqyW5oNxsTlC8q/s+cxpsw8G2f7l6CGmJlYNjmymiQ6k5iV/9mcyP3PIVyPIkG0
	NgiGsaXe6EL/1ZBPOjnVtZAskGFOHCdVSnOdSVAuqY5KpxZjXCqaZHaNINkPkvIri34LYP
	NyaabzElMQXPQ1Dv4YmRNDwHb3AXnZ0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZYZpciPZ;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E1924018A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B71C19424
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773383696;
	bh=Q0wVQHhsmNqM24Qtw9M0BntfWCp5kq7h5Pk/AhbueeI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZYZpciPZUCP7DFkzMawgbl+7hjxu+d4KbtYEqLuY5RZofb4b+oRQoW7OnYKvi080v
	 r13iKoXUJ2Uy41wp5O7Nh3/++b4mtFuXFYge0GsC2zgugE95otf2/2H2GO2KVP0LEG
	 9q1m21WROtAtw4FYPKI1UQSVPzxT48UuhhOpFuQG8gU/tXuSblvhbCAHqkzOB+1VNt
	 a2Y2xfivFST5Q33zm8AQ0Q3lS0cqu/+MBaiknO2mmmp6Ef7NAm1CnzKEnjSCYHgz6f
	 v/jWoe3i41OEVZNZcQLK8ul4w4IUHZfv/r08w7Jew7GWskyhimH643jBxdCvr3rrob
	 EJUYV1roqbtPQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b96d784828bso274108966b.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:34:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXzjZAdDo/HkPo/1QH2jtIWXWsFsRMXYj8sPHpApX0yBuFFmhKoNqxWvrToM+oCr4DP+ql+ze7fcw==@kvack.org
X-Gm-Message-State: AOJu0YxNyi3LwSa1zSPVQcOnRqoSVsogjglHkqGY07U4Fs2qVl/864tP
	dg2//wlVRl4zjfqm5A16NrOWEFdpq8ZU98hHUY7Kw2uVUciGh/cwqcpUGFrVeZVa86MpVqr3tSR
	TeZtXLrJiWNjJABS+cz0FIAZLHN/MmHM=
X-Received: by 2002:a17:907:7389:b0:b96:ee7e:a65d with SMTP id
 a640c23a62f3a-b976538221fmr83259566b.58.1773383694832; Thu, 12 Mar 2026
 23:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260313043532.103987-1-liwang@redhat.com>
In-Reply-To: <20260313043532.103987-1-liwang@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 12 Mar 2026 23:34:41 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMsbVHKnCzfQcdtomRMWTNFgTGY4XALxwm+i9m1SUPPvg@mail.gmail.com>
X-Gm-Features: AaiRm52d_LSDbxu5r_s7A_TjYxa-WyeCVfUKwcqT9K0KvGU83T161Inpfc6nrB8
Message-ID: <CAO9r8zMsbVHKnCzfQcdtomRMWTNFgTGY4XALxwm+i9m1SUPPvg@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
To: Li Wang <liwang@redhat.com>
Cc: yosryahmed@google.com, nphamcs@gmail.com, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6CDCF80003
X-Stat-Signature: sngind6ssa57t5qojbw13c7nrddgrnh6
X-Rspam-User: 
X-HE-Tag: 1773383697-552405
X-HE-Meta: U2FsdGVkX18SFpNz8oRIWUC/2ZnxvYWcglVvb4Rx+/TAj43YX2HRcYnmKfeKGhnzmfhuzCyESTy0WwVLrHQXCXkgj1mi2oebvI9pnWadiUg4gwz16Qi9tSz2nUxp05xBs+InvBr3v0RKa9RpsB6fPJ8cSTqMvxdKhlXoL+qHK2Xwzbq3mS1BPd0kX8bqEkp8c6NlS6w9E3d6jE54c8AtqeHyMPkCqdMQSgtUBJKZTsVap4+e/T4rBtNHZ/8+eHyQijWoOqonRmyswi9krzlSifLsgeGwLrncPys4Bo2XPeU6GR27ilHIoZ2gjlpuce30W43a2VrETNIWC/Uw3jo6tqpHxDP0OeDbwnLMMKF2rrH41uM25tHVKjSLDalYQpkTPzauiMUveS/dN4bFCNp2isWPp7VvMlIV1T3z9ieOvFBrzuzX85OGL1CBpKqW0X++LrFvUjqmxsDcgszpVlpBUagvRJpJCyNxk7cLMVdqp6kN0YCNskpZ786lMmgo2g4+0KwLQDaY1dWKVW3cOjNzBLOgIgVMY20k5BKyMmHXYJp8I2y5Jc4bDE+zGH8ivJT5a0x/827/YtmOkUZYRYUj2vfyCuqUf9t5oEKH/pNaLt0897nyYPRgPGdbQahJBkjU/sm+JLN9mIC3e+pf1r+0/BApIUacw/TuSw53HPHx+TxX/y6pRoKxkBqlgi6bDeN7/3BWQEiDNIis3BmVelsEXZZhODBR/IXafUtX2YBgtk82Ie/0vWmsgiG/BhysVBgR4Fyoegk7hRPfO0SHlDh+MLuMOvI9LInBmstA1m32r/80S4fn1+TKtQDBElMJSdw1aaYbHImStK1rRkbJpgy1zlzykJ22aVdY1uO0ARhvoQ8uzd0rozYYFiJmBMq83f7x2vRiaBQlIk5KiQuJR8wca0LAtwigYkwRrhmuz24VFSI5u1DY/92Xpr56ZRi+/n2mUCtpLpiegRfNEuws8eA
 y9xwwhNY
 v6bycEqsfC7zyBEaqs61zsPOD45/IkSmKRaXX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
> index 64ebc3f3f203..e69d845d3592 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -589,9 +589,21 @@ struct zswap_test {
>  };
>  #undef T
>
> -static bool zswap_configured(void)
> +static void check_zswap_enabled(void)
>  {
> -       return access("/sys/module/zswap", F_OK) == 0;
> +       char value[2];

Please wait for discussions on the previous version to conclude and
give people a little bit of time to respond before sending the next
version.

I think this can just be be:

    char value;
    ...

    if (read_text(.., &value, sizeof(value)) < 0)

> +
> +       if (access("/sys/module/zswap", F_OK))
> +               ksft_exit_skip("zswap isn't configured\n");
> +
> +       if (read_text("/sys/module/zswap/parameters/enabled", value,
> +                                               sizeof(value)) <= 0)
> +               ksft_exit_fail_msg("Failed to read "
> +                               "/sys/module/zswap/parameters/enabled\n");
> +
> +       if (value[0] == 'N')
> +               ksft_exit_skip("zswap is disabled (hint: echo 1 > "
> +                               "/sys/module/zswap/parameters/enabled)\n");
>  }
>
>  int main(int argc, char **argv)
> @@ -604,8 +616,7 @@ int main(int argc, char **argv)
>         if (cg_find_unified_root(root, sizeof(root), NULL))
>                 ksft_exit_skip("cgroup v2 isn't mounted\n");
>
> -       if (!zswap_configured())
> -               ksft_exit_skip("zswap isn't configured\n");
> +       check_zswap_enabled();
>
>         /*
>          * Check that memory controller is available:
> --
> 2.53.0
>
>

