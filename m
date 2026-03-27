Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2489610BA435
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 834A76B00C4; Fri, 27 Mar 2026 04:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80BA66B00C5; Fri, 27 Mar 2026 04:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748DB6B00C6; Fri, 27 Mar 2026 04:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 65DC56B00C4
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:11:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1576B5E0C4
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:11:39 +0000 (UTC)
X-FDA: 84591123918.30.DF69F8F
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 37B214000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:11:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K2FJXNdM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774599097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPhsZJNBjym7EHwKD82OuY+Kr/tp7KmnERPUIythgCU=;
	b=B2+u9jg266Oqt/ukW97C0sUSJtXhVMmiKPcHMo0BSRtU1oMoKkyNxRWkWHWudBYwhpXlHE
	r1Fp28IicbZJQVKzgip+3KDliEvd29KhcthTm0aQxPS2XK88fxca6/OIVUC+drE7hX8F2J
	ZfPh2E7mQsqCUm+x8Cog6CkyOREi8FA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774599097; a=rsa-sha256;
	cv=none;
	b=JJ/d86rfixbanrHj/3fyKM0LbQgYjhYFjsW1ggU/SYBV+AitIciETyjSFAu4BcSRlmQ9tu
	w1q6xun5165vJbGEYm1lub6E61tRnDHOV1k0a2o3M0T3n2jM19FB1bmplRoCCcs8thFjxW
	aVESamcM14haKxKmI7emTZc6QKUQM78=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K2FJXNdM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c6dd5b01e14so783745a12.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774599096; x=1775203896; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CPhsZJNBjym7EHwKD82OuY+Kr/tp7KmnERPUIythgCU=;
        b=K2FJXNdMiTsw0DEj0tXMZ9pcjfoJsKX25JU+cS7V/uW+7u8GcRhLK4x8vkAXEIDmHH
         K5QtZdwrTWmKEszNAfl7v9a8s17W48WZ4215+kTsRNxPIJXg3OLV3QN7Nf8/JMwE3KzT
         gQkhFxFgz3bWSGaaCXoOoEA7nmZ8dA+K0B8BPHY4ue9ZWbfRKICxJCFV0WKPi7//+R60
         cSDZTXDo8MzYdyMXXYl6dVR0YoYSxpMD0SUCDcR51HzD000dFLiXy7j0EchSmb7kS/Fx
         ZtW6aP3EzqL1ValQ33ZRMsasKayu6BZ8u3fq8wvRMLCkCsnkGxcC9w0QXEdHd1z0Hfhs
         4+hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774599096; x=1775203896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CPhsZJNBjym7EHwKD82OuY+Kr/tp7KmnERPUIythgCU=;
        b=gPYCOwlLh5clM8DpnNH4QLyJwFs43jEP2p6MISBS+KtoZWgG0dgBy5Q2vJ5qY/hX7W
         /nBUJCPoEbx9KvvYVgt34zraCKH3Dy7pXmdzInPNeZi5KlvxiIBevoP6gQjhMcSrLDCJ
         jNviPm/tzVL1M5fHaFEVcUJ4bOAxfaUhirMM01E9U05J1v/016Iiz7LvMWK788MXqEgz
         BhWWn9FYAjA1+Afwe7myqiq1Mbjn2zCJNFbXaZvx8JaUSr2+pnkdXJBw2f7ivyjXOIr3
         +RUTYQgxMqEtHQb79CDdfRhHID0GXTJAdqtrlAeYzeH7G0E4SYk4WonVpa93II7X6OSw
         PUkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOJIYZtlEZHj6P58hdcF4EED1DiRn0xCRG4bIeNQa2/t3GJP2kpBey0ypk2UAvONjDW9lL+D/Zqg==@kvack.org
X-Gm-Message-State: AOJu0YybqR5xXE13LNlQUx8eHPVoVO4HRes3B1NUjhOzWe2i+X8gtY2A
	hJdmdSueeXUpBzTx+ftJ9C//9v6azKkuSeNJa66v2m418Qxh2qBAQ4zB
X-Gm-Gg: ATEYQzyDs1512xUOiqcQ24a6wdNgYp2+0KEz/UjbeXznxtTt4oAsXW3339VSk5Hpr3t
	fxdNaoRC+I3xuBUhuw1uA/Ngf47AphY63aZq/6aZAA5nkk1Hk2ejGtuLCLBaAHIPbaB4kUKsRv3
	Nby4+XnCyPQ2P+5rjilZLncXrcqWNtpzVgT2RR8fgHn3tolqnJ+n+/zMKsYFXNc69fM5iCVvzYQ
	nShYmIHxI2m+PF31rTmgH0s5mwM9Y65ApbJh0W34nR32u2ksIPFSVMxWbT9xcy14TiXS/TQQaBB
	6JJDqdHx8uFxYItnpGC+UhiqHCC1VabYbB9lPAPJcvAayhSrmDwBIo0ZN2p2XPq+oz8ytYeRaWF
	IsAaHYaYq8EwZ+/yadS5tHp2Uplh0fmLivrez+UGU1H2daULSwkhFn22/Y4SSyfEvxFr3VKcOwt
	x7C8x2tygDZLJ9e08KydK26HMYHEU=
X-Received: by 2002:a17:902:d541:b0:2ae:4cb8:484a with SMTP id d9443c01a7336-2b0cdcaa6d7mr18954505ad.17.1774599095798;
        Fri, 27 Mar 2026 01:11:35 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc8e97f0sm51175195ad.67.2026.03.27.01.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 01:11:34 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: (sashiko review) [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Fri, 27 Mar 2026 16:11:31 +0800
Message-ID: <20260327081131.80608-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327062627.66426-1-aethernet65535@gmail.com>
References: <20260327062627.66426-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 37B214000F
X-Stat-Signature: 1i9zpp87348hnhujtmjasjrkw9zcz61b
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774599096-800102
X-HE-Meta: U2FsdGVkX1+2G5kl+Fh/l/sRicBu6JYqhcuXdySm1Wier+k35W2KlHApR9iRBtgtmMb2aFt9YsdaBEI27KZbnEJ+k7n0L2hXQF/wG6qzCJwYS+7ob/EXZQ4uuE4TkCdY8MQhzeqpAYj4z27gOwqgrDA7mIBRzkMQ5xr06xxX66SyZAiacFyMiJL29WKpYcEM+DhLlDOu6Jjxh4MlVisv84b1MS8KdoGTuF+t4fc7SjR/h9eQV5C0yOhgtKof5/KjQbaIO/GcdGB/CNoX6OdLPcIOL1f3KWinoUcHU/pPeG4TwjB8ZDMCKtmP6DI81yiBmuwSQhOg2y/IzzlDMBNhVEw49qWxjXgrhk0ZskS3zbx+O3k9Ax3MfAx8u2lRO5zpspads6D5K1LdDHg5n6jTiWAcESmYfvWROGTLz2U/aT52rO046HQc59iqIck07/NM2xZWHrhDmWoKE6hNS38cAeNktHdaxmCATTh14zZYXAVb++oXCOUu2ncRlTbLXXMs4cJmDlKxx6Wm2DdfrG0zbr4u5MW/QMx4VSCzJlg9NrFSvTPpUkLecS09bA8chwGBOP8cWZtbTzn3fw8d437f/uWA56UOKEy7+JbL9Pbd7o5sB4Zc9VON6wkWP9klXW91nkuywWYzaMj+iWIL7sc0SBdSm3g9mXCHL8MRG17ufv/0+aumep9OhrHn+hOmucCcx1L+qS7hehQMPTXhgp20aWybsS6cJar7SK1Hn6fs5zou7MbSUntHNZw9iIEV1f0voCWurnEiij37gmimCLHfLrN7S5m/ZDNaBQv0IQ2oLWMm461KFcoieXFvkXxWB6CkBXCYKm42FwdOe/dXXaD/mY0IcX2fnOLl125OHFUTOIa3RgzSykEd+/9f1FBYnztoKEcLNyPDkXDVxuTh6VHWARd6Bt44teaLt94dIr2D2bKZoNApmK+A9RBMyZ7o5twkBjPk/ZxF/Z3XVegKH4k
 lVyIl0MK
 3qmmEHLcilwfq3YjL4GlMoE7bQmbaylXLGlSNvLMJwO6eutaJcBoR9l87ixeHVB49GC2BJU4Dj7NXt40KWVWENpD8YUz/phT8HgQGN3y84hbCtx8wDZOVwRbdTvA26J7u1vzhxS1wXhxvuDnpStp7/6GTya+5sl5Lt9hrs3KCwC8wwx48JtWAkKQnU+rc4JAGdtZfhTupDelMStskTdqUgzMI2fnOgsYABJiPNCtUm9FD+IfN6Xwr0Sk2iUm4pJYRzCrnZPBa5pu1aAe4P1iE9NmOfUbq3TcQGu75K2zT3kHQdvAVf7ZWK5+Jy/XMXWrDYAZYmqGulnStLNY8gmaOSF2aMXSXzQuqwuz6IzQRncdJKbaZkYHCdS2Ynf3sAqwbVicf3Pb6C+Y084Ih0yFOzGpf4PADG1dxrP0Gv4XpVuCc02oae2zgkOQ2YaKOBWn+QI5gXhQKcNjgkGsD30QGwPF+u85Jb35rjRebgB001yGXK3ex8SY/EuMWu4NvTxrvI6ZheF8QKzd7FRQcGcESCuKl0Z2GxO02mzCesqoT3aO/xnS9WG0NgpkYhd+qtuRsL3Je
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260327062627.66426-1-aethernet65535@gmail.com
# start of sashiko.dev inline review
commit ceb9522e072d53117ff67157d6f0be7d35919759
Author: Liew Rui Yan <aethernet65535@gmail.com>

mm/damon: validate addr_unit to be power of 2

This commit adds a validation check in damon_commit_ctx() to ensure
addr_unit is a power of 2. This prevents kdamond from exiting
unexpectedly during parameter application when given invalid inputs.

Link: https://lore.kernel.org/20260325025317.86571-1-sj@kernel.org

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index db6c67e52d2b..6bad85a47a79 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -1330,6 +1330,8 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
>  	dst->maybe_corrupted = true;
>  	if (!is_power_of_2(src->min_region_sz))
>  		return -EINVAL;
> +	if (!src->addr_unit || !is_power_of_2(src->addr_unit))

This isn't a bug, but is the !src->addr_unit check needed here?

Looking at is_power_of_2(), it already evaluates to false for an input
of zero, so the compound condition could perhaps be simplified to just
!is_power_of_2(src->addr_unit).

> +		return -EINVAL;
>  
>  	err = damon_commit_schemes(dst, src);
>  	if (err)


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260327062627.66426-1-aethernet65535@gmail.com
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260327062627.66426-1-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

