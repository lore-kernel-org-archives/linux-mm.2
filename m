Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1D8FC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 05:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991236B008A; Fri, 18 Sep 2026 01:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93C2C6B008C; Fri, 18 Sep 2026 01:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A486B0092; Fri, 18 Sep 2026 01:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB1A6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:45:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD284C053C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:45:46 +0000 (UTC)
X-FDA: 85225796292.14.378C663
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 145174000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:45:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGzlyAgD;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789710345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZIBQYdIkUIAuzb3c6Yftyghs4HLNorlFCx2qvx3BqI=;
	b=RyLaLr+1Kpr2WGQ5wVvmwv8TgM7s+pBVDp4dcfR7Bv3QFCSmIpPhDPlXoTCfWW6BFfPsp1
	gR5b5ZMVZJ9PNgMXGwGo/wfmJQyV8JS3nXcErZV+UBxUivJsiPeVGMhIeRQkGNaRL+r+8A
	7pDa1scGITV90F6v8NzL127koXpExF0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789710345;
	b=7CMP9CeaMmIgcef0K5oXve2x3Ae2AxbwtNCgDHDXNF7/kaycbbP4/K4NFN+hy/b7V8VmLp
	KB6Ax9HaqgK5TySLq7p/WKAXkeuSes4xk3iQXHCVo+MIfOp1/hDn4vQG6SGq/mGTyUNzd5
	dxoh9js0xp6+Nvv+02JFsSBSlgmS4pM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGzlyAgD;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F4156053C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:45:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB621F008A3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789710344;
	bh=tZIBQYdIkUIAuzb3c6Yftyghs4HLNorlFCx2qvx3BqI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IGzlyAgD5iCGTIAwfOZCRmAvZgLKKhKgnpxCzV6AaVy5VpNIeXJHRznv4261V4RD1
	 P+rc0RyTn3gLXrafh6fGhL2wNnN2DNxiujRfGvHXPImPlZ3Rq0gNsZpVmydyb45d/4
	 5AreMdB+Ig85mAN4h2+5fo7zhElIlp/y0H5oAJg/GlyjtZMOZ/d8joRoSfPEgZfHaZ
	 TNBbiVFoG/GzqWerMJPbDs8wr1nJ7TjHTzOW8nfx0NDAewSaL2PbqvXXufzDVqKP7Q
	 qOIGxfFNTVWEkvBcfYf+wWs5cTfsDYOItUG7LkFRZ9c2Rkkhxaa5WkRdvgeIvfYYQb
	 S9XX0cUt1mGfg==
Received: by mail-qk2-f38.google.com with SMTP id af79cd13be357-939109fafddso25582685a.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:45:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxVrDaLtU/v6IBOPJn5xVR8rAz56QmaJvzxazbbo9z4ON3u0b7R9fp4pgydvwcWd2pNjlUkMtxpQA==@kvack.org
X-Gm-Message-State: AFuF++kW5stHNZ1USOubOo95LuO2tgAvoC35t6BUzrtq21LlNKDwdWst
	iTn9uDWNZQFrj2OajHZgNzWmRs4cdxP1v40ndboO5XE99ifZltLOt9McsT9ROmzovKD8Jk+muMP
	rOjbY/gHJosFoef4kZXvjfkpig8mr/II=
X-Received: by 2002:a05:620a:4047:b0:93b:d7d7:8739 with SMTP id
 af79cd13be357-93bdc7abb16mr192170885a.46.1789710343466; Thu, 17 Sep 2026
 22:45:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com> <eeb806b057f2097a4d8d2edcb9ccf850aad8f38d.1789701677.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <eeb806b057f2097a4d8d2edcb9ccf850aad8f38d.1789701677.git.baolin.wang@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 18 Sep 2026 13:45:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wRWYx8QkBNQqLUDwcBr014dErSqj4mmwL6u+3w7U2QPA@mail.gmail.com>
X-Gm-Features: AcwNN1U4ukXCswakzGtSkgTbKuubC_WAgMbaEn_3U3tuvbZJPBNgMp1ALv2pB_M
Message-ID: <CAGsJ_4wRWYx8QkBNQqLUDwcBr014dErSqj4mmwL6u+3w7U2QPA@mail.gmail.com>
Subject: Re: [PATCH 03/12] mm: shmem: don't expose 'deny' and 'force' via the
 kernel command line
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, david@kernel.org, 
	ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	usama.arif@linux.dev, kas@kernel.org, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qhcgnt4jrrxhmrq1wz7x5ogbcw5hq5zn
X-Rspam-User: 
X-Rspamd-Queue-Id: 145174000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789710344-982963
X-HE-Meta: U2FsdGVkX1+GhufF7P7GhLzIsdwWaEvJSdx7d+KDVF/7Oe7nBlGwotYJTzir1+J3TsDSFJozVti6wfqdStpinJZEn4+5c0dRsz2BjsjZNbfcm9KQgFZj8mGLlGhLBJX3lsSA8JShMM01tauKeES/tWO4PEzPHCq3KyKAnjgkkvQKgASXSIEZOtfSHsOcPssLGGcWOV2nZvJWnf3jWN13OwrQvcYSSxQjjm/TkCwk2zT3AIsoF08WLraO3WY5CvIoZXHy148OfxBuCnoHXQYe+Li/CJppJG0BRvFZsbUL8VmVnTGG5K/UJer/I2g704/nIcsGgMfTLsqyhBYJrRTRWPy1aVlKDjhRWs1rI4QRU9v2WrVybWSjzIZ0dQ1X9rudGYiFycSnffpjlL1mPZU+UbseCzZtOaIbI/CgRC+9qtM4ye9n2VLyp7XpV1KQFEKYJhC+XQT7+SaHpwnz8tipEwC9043KkYGolM0Ve7LEfH2oOXn7fvgjVDA+71oENjqA5mpwlKVDP4i4pIjHEu8UvjvdytELlWe/tSltTj8JunzXAgLEsGvIm+oARIQWvSrXOX45NRx3iA0wGZAWNchiOLoULsNUh1yhIXMe0iPyvHVC/keBxrC/U6iQQBTn1iHKbZiiWVbTspeEFxt7pi6PHEfuAGLXw6bI7JL+WHYU1AOzexEu6L1lw+SYtwz4rLdlvHWTqdelWUaRxWLfu5JmDMWRUyK62ntFKRm16ZpJvPCe4PA/icVyfgY33GOzaTZ58oPvgJTEaS/fNi26/zXtJiE8OqFqInQkGxdF2qeifDzWFvuSlP4e/X4khuAXEXjZy84kROul4otzoQ5BV+Pb/GLUZZWUxawearYv1Q6UlNigsFzwVjSwBIksmyYkCNmzIt+icTtVBybRBds5ccAFuHRlRvNPTi/a3uCeCGl6VATjEoemHmWCH5Yym+/gFsYYcaWKDwBT7mPtKqF+6sP
 o3Od/X4l
 HspuHFHnLZmfsWaDoeTDycljfnybC3MtzOTVaJp7s2JqvGGinjhTJ8NkAhyZapcd3O07w2ZhtZPkMUXUaHvUsinko+tGtnpAA1RKPXOwCX+EUdBw7Ddfoan7bNswk77BNKPJrGjMUJZr9ijJ7j6WzUAriluY2EVCE/f9Si6pLcK/XnPvCSHCNiAIqt1/zdNVhy3pmQass5l6SopwgVOy52d09ur9MgGTnxemQjRedOJ1VOWjR6PFVYp85j8ISeBkwb/wIJ8k6mfXo3XMIfvXDAe3IXrjOJYMcp7I28jv5VADK+r/pnScXeEJJFEdQoBt9Z/5sFICyrIYJH6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 11:58=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Based on the previous discussion with Lorenzo[1], the 'deny' and 'force'
> options are testing-only configurations and shouldn't be exposed via the
> shmem kernel command line.
>
> So drop these debug options from the shmem kernel command line and update
> the documentation to make this clear.

If it is a debug option, it should not be exposed through sysfs :-)

Maybe we could rephrase this to say that it can only be switched at
runtime through the `shmem_enabled` sysfs interface?

>
> [1] https://lore.kernel.org/all/6e4aae7b-2c71-4109-945c-6481efde3636@linu=
x.alibaba.com/
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
[...]
> +static int shmem_parse_huge(const char *str, bool skip_deny_force)
>  {

The name is a bit weird. What about `allow_deny_force`?

>         int huge;
>
> @@ -683,9 +683,9 @@ static int shmem_parse_huge(const char *str)
>                 huge =3D SHMEM_HUGE_WITHIN_SIZE;
>         else if (!strcmp(str, "advise"))
>                 huge =3D SHMEM_HUGE_ADVISE;
> -       else if (!strcmp(str, "deny"))
> +       else if (!strcmp(str, "deny") && !skip_deny_force)
>                 huge =3D SHMEM_HUGE_DENY;
> -       else if (!strcmp(str, "force"))
> +       else if (!strcmp(str, "force") && !skip_deny_force)
>                 huge =3D SHMEM_HUGE_FORCE;
>         else
>                 return -EINVAL;
> @@ -5680,7 +5680,7 @@ static ssize_t shmem_enabled_store(struct kobject *=
kobj,
>         if (count && tmp[count - 1] =3D=3D '\n')
>                 tmp[count - 1] =3D '\0';
>
> -       huge =3D shmem_parse_huge(tmp);
> +       huge =3D shmem_parse_huge(tmp, /*skip_deny_force=3D*/false);

/*allow_deny_force=3D*/true

>         if (huge =3D=3D -EINVAL)
>                 return huge;
>
> @@ -5807,7 +5807,7 @@ static int __init setup_transparent_hugepage_shmem(=
char *str)
>  {
>         int huge;
>
> -       huge =3D shmem_parse_huge(str);
> +       huge =3D shmem_parse_huge(str, /*skip_deny_force=3D*/true);

/*allow_deny_force=3D*/false

>         if (huge =3D=3D -EINVAL) {
>                 pr_warn("transparent_hugepage_shmem=3D cannot parse, igno=
red\n");
>                 return huge;
> @@ -5822,7 +5822,7 @@ static int __init setup_transparent_hugepage_tmpfs(=
char *str)
>  {
>         int huge;
>
> -       huge =3D shmem_parse_huge(str);
> +       huge =3D shmem_parse_huge(str, /*skip_deny_force=3D*/true);

/*allow_deny_force=3D*/false

>         if (huge < 0) {
>                 pr_warn("transparent_hugepage_tmpfs=3D cannot parse, igno=
red\n");
>                 return huge;
> --
> 2.47.3
>

Best Regards
Barry

