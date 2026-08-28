Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A4A2C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4846B008C; Thu, 27 Aug 2026 23:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7550E6B0092; Thu, 27 Aug 2026 23:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66A656B0095; Thu, 27 Aug 2026 23:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CFBA6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:22:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEC8F140330
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:22:51 +0000 (UTC)
X-FDA: 85149231342.16.41185A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D84EF1A0005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:22:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XWLJLsUC;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787887370;
	b=2Phb6WZfsNK56vsFfExzSiHByF39zamI7bU460B6NmMTYsIa39AvJLfpfdZLHgUeJqpTiI
	FJqoTMtgrgyeACHCblfXAu59lTae+TvabAYdoKkvCdbZus/EClNd7vzf30knVMgbqiJ4tG
	PyA25h5zSGT4J2OuTKEWX1U/PKrS4kI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XWLJLsUC;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787887370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2rIqjHXEHIXM1/7XBYn0i1tnPA1wSPEhavY57zxMC4=;
	b=G+ompEGqHMHRqFcyt1EYqeMKycgSPSQTI15USeIKL4kIlz75L48sIMTwGZb8MvX/HdCTnK
	3IMVuoXe9AgWpzb3xzFRnKrNscLiYD62BraTP67tkq71YOmQad5uTcemGi6f+mULfWhoCJ
	90gEo47Miy9s5uwJcLPq6cEZB6iGW1U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B336343AD4
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946BF1F00A3F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787887368;
	bh=Q2rIqjHXEHIXM1/7XBYn0i1tnPA1wSPEhavY57zxMC4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XWLJLsUCyt/mi1UexhRrGi2Ygje5PLuZAhLARUvOZZ9LfihTY6XGdKyKURi9HBtwt
	 OVT2H2hYc21C7YnMycNu8Qbi9IYtmAn0IsT6Wtmq50x+06whCoqmjJ/mc8tGYBqloG
	 HaCVAWxpwKjdB2f5pSjDEKk+Ffc5ewj72FVek/lCKzxfN4TeSRfuE8xILfFvnEBcBJ
	 cDSlnwkZHpqZ+ymv01IV6mXiQJlEfcgoIouZyy9xMOPbF80g6ynhEaHizfIGbZisuc
	 EdTxmXM8wqDSuMnt1QAyjVojhMnJTkEmA9n+WFCpLAegQ0R4bSpFuxfpFUIWcvgrsN
	 CxRDGraWT3Jww==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8fcc43c48f7so7570946d6.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:22:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RokXghp4/BEa11YiVBye3VqhsZequgVKNWM33X03jLFrpsBZOyEHOZiQvVBa9QLdwdofMCsfbsH+A==@kvack.org
X-Gm-Message-State: AFuF++mgKYdZd+5+S4nWavW38qJvJJ3CAcfzp4uQGb3TkH5r0Bkl4+EE
	edSQHZ2EPUnUooQ2XBzXdDzuBfq06W3SLbJwzNYrAX54V3eSrpti30soBu8LCNVrZhPKkw6aEIa
	pc5C9IH/eTNr48KSluNn+tNV6VSnVwwo=
X-Received: by 2002:a05:6214:e84:b0:90a:3c0e:a686 with SMTP id
 6a1803df08f44-90ce0e75afamr47565626d6.8.1787887367953; Thu, 27 Aug 2026
 20:22:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260820045603.68809-1-baohua@kernel.org> <20260820045603.68809-2-baohua@kernel.org>
 <apD9QqyFGRoGxyZA@fedora>
In-Reply-To: <apD9QqyFGRoGxyZA@fedora>
From: Barry Song <baohua@kernel.org>
Date: Fri, 28 Aug 2026 11:22:36 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w_c2mf6X7PXHc7W4+jQ57un+eewfh9K1dXha29Hw12rg@mail.gmail.com>
X-Gm-Features: AcwNN1UoQm-6s632B-aENk04GESXEsjpOWWCttgK-XNaJ8utFIu10DT_GtcbU5g
Message-ID: <CAGsJ_4w_c2mf6X7PXHc7W4+jQ57un+eewfh9K1dXha29Hw12rg@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/mglru: improve readability of isolate_folios()
To: Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: qrx5g4gtqh95zw618uchhhhtx89k5i19
X-Rspamd-Queue-Id: D84EF1A0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1787887369-575483
X-HE-Meta: U2FsdGVkX18G3AS9iuA4xaqac85TAYLG4fgPG/9WxK6fo891clV4bX7jEDZTPZfZosFn95ApBzSYg9YSdLMzJ0vk/tFQO05lENlb8BX26MADnDMzogNG0pS3CPstodpPf0L6QvZMd7GKTL5dcn/BZs+mrlBf48Pr0+0qGIo3VKeUSfvN++WbjS+h354jCKIeb8atDcU8dsI+WSMURWECByaGbgDxexwuDBDxt+hCdXmaRLyMaQqk5xiX3e5xg4PvzjnRmGgbBg0bfYjgcKW4N0K/GNObHk5HF3GRixiTq0nvi3D4IYbADD+rXDAWZ5jkqXMGv0MVdIHtQJNtO+xnq54O44h1Tta30k4yZanpNIHsQ1zEkFSJvuHhntkXJl5YcUvxug7BI1MufyvwsVXolRbwhd5mFCE/zrTEPxxZWd7cgPoZZSv44CiB/uLzeM9rq0x0wyKbpSDMWllZ6kdy+954X3Kq+prKtoeNi3IPZHK6ycT0Va7to353cZPDaRc5+6Sn9YWMVaSwYgNWl4mtkt0AykB0wyERe4jjTRAml8yikumNHd7zazvHFNotxZYksxF3du1wzwWH3fuuXEu9O5dJQskVj/tGnTJxsAI1xBNDAv8r4PGFKokX7WeYf+nX+u8uLFt5ZeIAsn5MlNbSFP47HVwP4FFq+/+vVL1DCOGnCTOvPNPN3SLXaw7GTzQiXz4Kd9ezV1R13DU1OuyMe/dVtfhDD+0dm7qBRiF0hY/EVzNUTsaFtw76dnPy66t9TsmxHrKTOxxZxRQgJTV7WsdsNvHbuzelBhL54ExjMpvq/T5PPJyPLLIysme1+3nAB1U936OR6Dw59rYWh6mCY+viYil+W/4A/JH3leiHgScJWMhQ8eVJViUtnXxr77yruFRUGZM86Z9ic5zp2wjxKuVu7n1r+MzB4Sp0pZTYwFpPHIKPT1LW3GjsZZcnSRtxjZQq7adb3e2cFuEbkCX
 ap/Bakx/
 XM/FtYemZ5y9Ylo7gEp+OL9rotQ182gzLYK08YkkDM92EYHHPhH/XqkEg2tEt8hAQBgVg/C+bjVFwwbwM3fFJ/bpTJooORMPG1C+hLy1hFoetdDxkBBiPGu2gVZCjCTd2IPyY9Hr1XJKpNjYakjI8MAMyduhj/IcuVTxUjNBGDEe0QEhhcS+2S/A63FgaaLCfYIFUwjE2fAcBc6BBy7xxW956gXVXaOVAY5i0xMYCdcWnpqVMc5UeeMydhNn0V8J6Q4iY023uaX+yVHZ63qyuaiCUsW0qyOyTlyb8YJ6eLdWM84w9DKRHBJOpLzUIb1YmhfRgiBAmANd1ug4jrJE8uQbQeGSsiIuvOdHCfKA3Ogp1UyFSvNvzC9M3AP3VBXGMsr9mZUl04HESi54kCWTqVzJxEttHLsWU1MY+3/gnAbvOpzV6u719ztkltfhsT/k0uimF1vQV0UThqco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 11:15=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> On 08/20/26 at 12:56pm, Barry Song (Xiaomi) wrote:
> > From: Ridong Chen <chenridong@xiaomi.com>
> >
> > The for_each_evictable_type() loop in isolate_folios()
> > is misleading: it does not actually iterate over each
> > evictable type. Instead, get_type_to_scan() selects the
> > type to scan, while the iterator `i` merely bounds the
> > number of attempts.
> >
> > Make the fallback behavior explicit in the code and remove the
> > opaque for_each_evictable_type(i, swappiness).
> >
> > Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/vmscan.c | 46 ++++++++++++++++++++++++++--------------------
> >  1 file changed, 26 insertions(+), 20 deletions(-)
>
> The subject doens't reflect the truth. This patch changes the behaviour,
> but not improve readability of isolate_folios() only.
>
> I also noticed the confusion of isolate_folios() implementation, and made
> a patch to only change the local variable and added code comment to
> explain it in my local branch. Surely refactorying is also good.
>
> +        * Scan at most one type per evictable type (anon/file), starting=
 with
> +        * the type get_type_to_scan() picked as statistically colder.
> +        *
> +        * After a scan:
> +        *  - isolated > 0:  got folios, record the type and return.
> +        *  - scanned =3D=3D 0:  the type is empty; fall back to the othe=
r type.
> +        *  - otherwise:     the type has folios but all were hot (or los=
t an
> +        *                   isolate race); retry the same type rather th=
an
> +        *                   switch, so positive_ctrl_err()'s refault
> +        *                   statistics stay unbiased.
> +        */
>
> While in Ridong's patch, the 3rd case disappeared. It doesn't rescan with
> the original type as the old code is doing, but return directly.
>

right, the 3rd case comes back in patch 3/3:
https://lore.kernel.org/linux-mm/20260820045603.68809-4-baohua@kernel.org/

so i guess we can rename patch 1/3?

Best Regards
Barry

