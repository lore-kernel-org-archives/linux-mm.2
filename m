Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3880F94CA9
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 19:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419F56B0089; Tue, 21 Apr 2026 15:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CBAB6B008A; Tue, 21 Apr 2026 15:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BC9C6B008C; Tue, 21 Apr 2026 15:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19C096B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:47:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A8296E6226
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:47:03 +0000 (UTC)
X-FDA: 84683596326.13.D4DA7B0
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 981592000E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:47:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oIvgqvF9;
	spf=pass (imf03.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776800821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rpo02j8/66VoDG/NLu/upMgvf+nWTnCg0I+kiKS+Djg=;
	b=Udu71SOJZgz656nZoga+2ZYyGVPsL5TDeRyjZIbC6xHPP4mMF48b0GlwZaDcp+BDi3Ljzv
	Xa8BzFSCl1koZGdiImFtuCU+re2mBndg4xteowvSqPG0LPr0du3HHHAmjSdJVHfsBXrZC5
	vUQW8+foWv2xRI+x8yKVzD2HRBTVEdE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oIvgqvF9;
	spf=pass (imf03.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776800821; a=rsa-sha256;
	cv=pass;
	b=D5AAMwZCCE9yypsZUmGmuFI1K9+xEisDookMrhCYae/GiPY9m/5RTNW8TjlB1/TePMszq8
	M5NflUjBsOaWn3+W50zQGu4gquOBUTf+TSabhrQvncw8cjvprXTy5nODyDK7R2i3D0FdzG
	nly8TUs1M0ZKfMHOQJDmRLoIW6frDkA=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67179ed133dso5207764a12.2
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:47:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776800820; cv=none;
        d=google.com; s=arc-20240605;
        b=A/FY7kJfPUDWY/gaauKNYPryRKjeOA4mK1o43dpnwuJpCpOEKZQ71en0eA38fIAeWb
         T8BfKyFerA0MB4AmW3aOtClMKR0EPb6DP4EaEn7R24IkWTVoG7FR2sIB3Oz331EeYx61
         HXkZNCvPnlajz2rnMc1X4T05ro+0zOiEo/WhkVLeM2aBAYxAmEPMt0raiR7JMsQPT4NV
         yVGS1KwAibBcV0rXdnEmAL8RWpj9wkH161O3nmsuQ0F3EOOq5Brx1McGnqXAQAg8Xjgl
         BtkP1Kd6zLn+pG7L/5OjRKXIylHqIsmdr22jHEAQ643f/ngf+mkEYdi7y9CRiRU8G3bN
         Da+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rpo02j8/66VoDG/NLu/upMgvf+nWTnCg0I+kiKS+Djg=;
        fh=nq+rPghRVhf0kxcxs9KWeNeVMTXw4foOCEAHByqeQ2c=;
        b=XiKF22IFAADzakx4UzT75nE77ybZLcBVkPJO3rc9iuzPldnfdqUd3CRMdmleeT+GOZ
         PpaJotx0F2QH4uMe7189ZqJu4xv+zupresxfMS8OcXnef7tuaXfkHClPZYAXvXaIyyaI
         V62IGYbOZsq9JF0FVfDHaRxOgaNbPvFnmb+lUR/Z2kDu7YuqCgaBCPBjWrmuN6j8BImj
         3M0sGVDufmeu/u1RMTGF++DCCTaEGmQO4qpmi7juSLjK0dEUGu1ifjOohtBJ5HhGaSag
         Qjy/PYau3tboGVqslYAXYgXlZYUk3YlmrsLkf1s2xwtmP5hhx9jVfnnbLxj3RRl2elJ6
         SnsQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776800820; x=1777405620; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rpo02j8/66VoDG/NLu/upMgvf+nWTnCg0I+kiKS+Djg=;
        b=oIvgqvF9Q6R0vJyvDcZzkeBbAQvFdrx9a3GxkIjcYOLdERy28M+NUjGHtsd4FvEl2i
         bmyQoP14E1cAVb1XkZ+cSqMGGooBGMKgl1I08ZobROHWbt5IPdMqkatiPerzm9EPhT4x
         xXYj1LeyuiqwBEaMpKfNF/rrnlLu/954u00xL+JDueVfGifQRsWxcGLkRd5DZYMQAtlw
         aM2wB5Rzz6wC9AZ7i3+LfuRlk/DuAIc6Sy6WOhIBAk77hLIwYjcRlE83h2yCQ7I1o1pK
         8m1JB7mBG2KkXR6u07xO2aTEJ0bHnsj6artCX/keZdUl3qcZc3ReM9ZMUuWdXwrN/9tg
         j9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776800820; x=1777405620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rpo02j8/66VoDG/NLu/upMgvf+nWTnCg0I+kiKS+Djg=;
        b=F9c7rYnimWH4sirSMeNFqyWML1RxUFy1G7iPgl8NWuNttwl3j/MU14HYc0BHIFHW2r
         ZafE5M7X/D5OHjSQ4Vsc/G8bccJ2/X5S1p5wNq38stKjQki8fwa3rCq7j5tD2VInqNqC
         5o5Nj0mEz26wTVL5+sZ5pjeTUGuvtAFM2HA1EAoBeEush7+3mdeaFo/v4qWvNlP99Z4L
         Rp+rrFqizPO1osLhrjDlxcztsosqUZ2s0ko9cU0yGNtKOeZRPH6M4PF/1DALhTyCvzA6
         O3O28g1XTRq9gcm4SaDeYjZhlDEKSzc/Qi+to3o9Lsmj8RQ98HG0guL8IpdfE4z3T5W4
         JfhA==
X-Gm-Message-State: AOJu0YzV8Ys4pHvPwfb5n/Q5d3T6te51/ro7EOPKyrVWMgX0XhLzoyur
	twf0t20EobrbT/7saSi5106V7K1unEqoIBr4IGgxdF8fmg/+XoVoHtbUYAfZx/S+vYSoh+AnE8c
	8R3ONdwX02xOthFVumDADzxjTXHRdlXE=
X-Gm-Gg: AeBDieth+8kXQpeYnidCMqCyAmqm+jcj4oHJ80kWKEybEjXM3ypmmg7SHRO/2iGyp/K
	+B8r+QnLFfYK2KhRWBkfbCWQNRH8PPMuHXWsxkfxEtfs3NOzh9fFIQm8+afa+LvLb0Fi3C6QODp
	v7mP7neDl7hRcOXpL7rdvsdWWwG3R5GTwfkZ/0+QCYXMM1V7LLYZUBMgAJPbAvgUgey5MqooMHV
	cLIYIPBRuH79gXo2KEGmb4pR22UcNdg3JnadWFjU1R3jfO1pP9Etjybj+Vnlm/+gYGgdP/LUV4r
	9JUqMJhJ8oFxOWBzv8CyTUsmAa0VaA2LG4jwaf97mZrGoUeh
X-Received: by 2002:aa7:c917:0:b0:672:f3e:1475 with SMTP id
 4fb4d7f45d1cf-672bfda7c43mr6538765a12.12.1776800819653; Tue, 21 Apr 2026
 12:46:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260421020932.3212532-1-liuyibin@hygon.cn>
In-Reply-To: <20260421020932.3212532-1-liuyibin@hygon.cn>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Tue, 21 Apr 2026 21:46:47 +0200
X-Gm-Features: AQROBzChDJKcwP6MAVoTX03Ymo0fD3gy_UdcVi9TLYI0MQXJstPEsw0AMSmG01M
Message-ID: <CAGudoHHki3gv-HXXMALePDoC+tmao4oWcYgCo9kXNDkEhW4E4g@mail.gmail.com>
Subject: Re: [PATCH] mm: Add RWH_RMAP_EXCLUDE flag to exclude files from rmap sharing
To: Yibin Liu <liuyibin@hygon.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, wujianyong@hygon.cn, 
	huangsj@hygon.cn, zhongyuan@hygon.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cdh7gymgbic5mny3nib3tqzy88d14r5w
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 981592000E
X-HE-Tag: 1776800821-842179
X-HE-Meta: U2FsdGVkX19ZzwwIY+JDMI4hQ2qNpoLq6GcYRPgWPqTWmXvvYAAfrNM2SmFTmiVNLeA5Cy0A60jl7My3wDgjRPUCPmJlDJeLTwoXWDkGERvRzypxyyp6CbhLTVYdXGWZ685PqhTqyWBILydwgMKORWNVQMRpuaQuJwKzBO1ygdYoPy/OscgekTONa2PZlfg7qFG+3a+E3ceXjehGy3/Q/K5WB3jcBrIKWY0qNg5PW9GlWtj/OrWiTS7ujc8lehHvsZ+CoN7nCi0Ou4wVSA4kxgcCvJDU6qAmfHDdz7dBZPSrx8loEyWc8rG+4jSaNDM2ccHaYoZ23NTU2tOjFRdQL5wzJxG74W3OZ5Cjwvd6u/WpjyiSi5WshjjLuaXwRGG/hzcI0qqHJhi8B4BJ8kuvoLh41tzmg1FM0A2N00VUyf2m9f0KOPw/cBgpkeJ+NXl1jih34SJh3UVfjlVt3+VK5Q2u/pTU7+5TvBY7NaiqD+0yJ0b2QzO+NJvPNA6qLvRHZoL4jzzSovvBFClfghY2PVxIPKEFUMtGmER8Tycq/8re0soFKOMWwCVddZNxObIu9d5HbVCyGcr/Dkj/gLHy093CW9ceLavvNnhVAG5IcjXDrRpkLsxPufiXW11Zpdh2QK9q06nAEiGo58XJGlSmho2moCRs1t/rXf/yOIdU/4MUSP7/JF6RMaHb8j0jtUMGo17jWXcr1D0+ahIKRheZcxCHZnk1oVSNgSzgHCNUeP86uvqSkv+QQJMup+iXj1R1RgyPDP2j63IZiqH1Z/IhzRXXmVWuOJASqYL2iNgE4zGGLDx7mObAEGcvJ9AcrbMqL1+q55BIkfdXQ/5Qb5dsUxeDZoAefJ5nEW8R20oxGTLqOBWet9Pq7RgIab14WFHo3gMXcf7ri2olvSEQLMWLUlXsGNl6ld9KydA4sxSm4AKImUb2oNTVpDDnLdLsQhcS5Ie9x9/OmIorFcewcq8
 SyflIRXz
 bWQ5VYjz/7DlaoF+xSN/OmZIqrV0gSc26BY+giNDiUTpuOabINxwlFdWNvwknRnzqZnVwLbUtGalMjS46FMH38NfaLfwH+ny5RRPBNInLPZf34U3XB3VLE+XRgYznOKPVC8pgDFHcUcb/5L1t52tzjqy+0lslGdQHlvDrzbu2ItTwx+3jWJEP9K4A/p3onEGEiyZ9IrfiIQIpFy3ue7sp1IXW3pOOJBrDHQgR1mkuhkvqYi/pEGMJy7SlbiN9XkFNWpTbRXwJK7TYMeGfmoe8qGnlaHY1+uCYlb9Ddegictej0VtjGSngwYXUe0joPg6tbLEq6MBDjBFMLIZD06xml90KYfRfM0Vl4nKUjs0k4Bay4G5YK04SuBx97jvnZIrRz3jkjRxnFgfDkS6rV9A109u0y6wVtVe+B9YSFSh9cBTwAtq4RbLCivOGftu12+JtlPv9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 4:11=E2=80=AFAM Yibin Liu <liuyibin@hygon.cn> wrote=
:
>
> UnixBench execl/shellscript (dynamically linked binaries) at 64+ cores ar=
e
> bottlenecked on the i_mmap_rwsem semaphore due to heavy vma insert/remove
> operations on the i_mmap tree, where libc.so.6 is the most frequent,
> followed by ld-linux-x86-64.so.2 and the test executable itself.
>
> This patch marks such files to skip rmap operations, avoiding frequent
> interval tree insert/remove that cause i_mmap_rwsem lock contention.
> The downside is these files can no longer be reclaimed (along with compac=
t
> and ksm), but since they are small and resident anyway, it's acceptable.
> When all mapping processes exit, files can still be reclaimed normally.
>
> Performance testing shows ~80% improvement in UnixBench execl/shellscript
> scores on Hygon 7490, AMD zen4 9754 and Intel emerald rapids platform.
>

The other responders have been a little harsh and despite raising
valid points I don't think they gave a proper review.

The bigger picture is that the problematic rwsem is taken several
times during fork + exec + exit cycle. Normally you end up with 5
distinct mappings per binary/so, each created with a separate lock
acquire.

Some time ago I patched exit to batch processing, leaving 1 acquire in
that codepath. fork can and should be patched in a similar vein, but I
don't know if unixbench runs it in this benchmark (i.e., real
workloads certainly suffer from it, I don't know if this particular
bench includes that aspect). This is on top of forking itself being
avoidable should the kernel grow a better interface for executing
binaries.

This leaves us with mapping creation on exec. This problem is
unfixable without introduction of better APIs for userspace, which
constitutes quite a challenge.

The end result is the absolutely horrible case of multiple acquires of
the same lock per iteration.

One common idea how to reduce contention boils down to shortening lock
hold time. This has very limited effect in face of the aforementioned
multiple acquires and is at best a stop gap -- no matter what, the
ceiling is dictated by the extra acquires and it is incredibly low.

Your patch keeps the problematic acquire pattern intact and while the
80% win might sound encouraging, the end result is still severely
underperforming even a state where the lock is taken once in total
during exec.

Besides that, the internally-visible side effect of non-functional
rmap is pretty bad (and thus e.g., truncate) is pretty bad in its own
right, but let's ignore it. The primary problem here is that the patch
exposes a mechanism for userspace to dictate this in the first place.
Even ignoring the question of who should be using it and when, the
real solution to the problem would be confined to the kernel. Suppose
this patch lands and such a solution is implemented later -- now the
kernel is stuck having to support a now-useless (if not outright
harmful) feature.

What will fix the problem is sharding the state in some capacity,
provided no unfixable stopgap shows up.

Any other approach is putting small bandaids on it and can be a
consideration only if the decentralizing locking is proven too
problematic.

Pedro apparently volunteered to do the work, so I think we can wait to
see what he is going to end up cooking.

I hope this helps.

