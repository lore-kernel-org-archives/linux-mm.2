Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DA6606A331
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 19:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bwcuv0xv
Received: by kanga.kvack.org (Postfix)
	id 00A446B06D7; Thu, 19 Nov 2026 14:55:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23A06B06D8; Thu, 19 Nov 2026 14:55:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60F66B06E9; Thu, 19 Nov 2026 14:55:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1F156B06D7
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:55:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39B03A0C1A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:55:22 +0000 (UTC)
X-FDA: 85452922884.25.9A21528
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3A2EC18000E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:55:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bwcuv0xv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795118120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35s+RMNvlfl/wiJfPyx4Nh4RZH0S+Tc8JWi1QrqJwTA=;
	b=BvGdH8t//JSnwX2EQMGhKN1+YQ4Nvm17/lEmYTi13pVzLRPI+/hGn16QgIzlZdqPH9Gz68
	4RbPPqSqlWi6Xbzi862v48zbimcjvlKfDZSqhL9gueXSvxIjo5jS7GKxtVIks23KC36caJ
	zv9mHU3wuGy1kwGI4VMFBM6zUqdOVf0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bwcuv0xv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795118120;
	b=YElfbk3+FiW3XCl2o0v25tUQooHxPQ8asDRuknJgMQ8FgXRrxt/ClvY4QQejghKGF+ULnU
	clf4QRBgfQ8fdMtfFu8ZQyQfJyIr1kZEGg8NcWEdwYmSx4kJWMyGpJYB3fPKa3MuJmDx/h
	Jp9dbOjjKHWEhJfBS2W2SwanHuQh61I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59E1C4735D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D35C1F00926
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795118119;
	bh=35s+RMNvlfl/wiJfPyx4Nh4RZH0S+Tc8JWi1QrqJwTA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Bwcuv0xvRWIZi0iYptvepnDwZsox/yEKND3FagGiMz4tuatld5NR4iRI+8W9N2ZUY
	 C3CkKdCwjqXPHZ3ku7AkcFUb0oiBRttzNvLjp2qVhtvOMgli6e3ByYme5p54WYXg2u
	 XvkwmKZP0Y/cp/3W4Y0jDKmCcC/Cenq720CsDvD2GGdD8WSvzxSpmOLrQ+nGXOFe8v
	 T2FELSOM0/n6zKzOqb7myBaSAlf5G6h4HfJL2tZsmEB9kIrOeo42tlycrwEbXvpiZi
	 Y9n/ZZDk2gDrNrMfoSkARti5z5FAn42P0yAs0ix9tS0AA9nUj3c+fWbfn2BmCvXCKc
	 y0BgpyRoFo68Q==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-9211efaca89so2805976d6.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:55:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFTjIMN6bQmviBzvysOmAmkCLgbcpTuYtd9+i6eMJ4+zL/mMsfoqagf56i9iL6++nP31Q7Soh0LRw==@kvack.org
X-Gm-Message-State: APuU4Z9zfLLGouC+GKOwuLXB9yx4YKxbiMp41eHrxiFvJJVxAjLtLUZ+
	04coDqFMAL3/tm1YKF0dkyOefzBjkj+5cD6DQNsPsaYcNm32TvyzfneQCnjVIzG/DwuqBf8Iqrx
	9FJliSYK3/Ed2girtomDyAdfArw5Cpo8=
X-Received: by 2002:a05:620a:7113:b0:949:569a:a3fa with SMTP id
 af79cd13be357-949ba9b82f4mr119511485a.25.1795118118560; Thu, 19 Nov 2026
 11:55:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116081403.216452-1-max.kellermann@ionos.com>
 <20261116081403.216452-2-max.kellermann@ionos.com> <sashiko-outbox-218403@kernel.org>
In-Reply-To: <sashiko-outbox-218403@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 20 Nov 2026 03:55:04 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xFy98uy8bdM0Oc2jo70+8qRMWZPxVLEH=OrR1PHWvArA@mail.gmail.com>
X-Gm-Features: AclHuK9Qup0UNXttQIZa-5UUXq9oMnVeJ8Iy2VNwgLrdULffcmF_q6zw6AuOpWA
Message-ID: <CAGsJ_4xFy98uy8bdM0Oc2jo70+8qRMWZPxVLEH=OrR1PHWvArA@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] include/linux/rculist_nulls: add hlist_nulls_add_behind_rcu()
To: sashiko-reviews@lists.linux.dev
Cc: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	baolin.wang@linux.alibaba.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hannes@cmpxchg.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6isxdr4whuqpe3yds5maxs44zqsuij7o
X-Rspamd-Queue-Id: 3A2EC18000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795118120-239790
X-HE-Meta: U2FsdGVkX1+vtcI8phh60uRhnxJCSCiVmskmhk89vDF6iD0EQZGSgGRulTYW6TKgV1onOJqEUIQic3aBvpsFysgkBthF4tictof71ypyeZPwqA2xyk6dvNlkTi7KeGy/8ACadxnkTdvTxqXKpTYicgkk70a0yWDFHLDTK+zqCCqC3evtodFNFTDuUxR9wgQIkkrIh252CfOLa/52KSLtLyfnQCdsOB76Chr5I049cLOcg4EhtSASKPNrDEbOW1jhiBrc/D68hWx0YBf7q9b2uPomuTV5+VlMNM2kDSGCLstpFf5ywVgRshrpI2B1onrRcOiMLPXbupIVuuCQVBpTVOreKJ66RR3BXboRJ+Dff9FIhmegtSgUMnpBdMsFJVR3qttvKVgkWsY4i5UVqjku294/AUB5ttWmDadoMLswKhTLoyw4jiBEAK2UOUXnx+QbjKWeeal8Ggry16xx1jLQWWWBMWkVd28S6mJ9Ofqi2WDnsYdUz0B+UG1k0LnLPB9Lx5aDx47A+Pt3np164kAmxuf0pR3G3P75ZDr1T8qL5jMsZxytDSktt7F5xJ253Hat1ydTfcqF0RTCCpCJUtT/Jnn++nakVMXRwIC33gUNGpJOCvXxlASRs01Aj6uNjSGqWHgHySWfZ+2iHsqCKjbdQ7mgbM+RADyAy6giPbCTCkJKalPJt7v8va77E8Bj7quSBmB5SPwuwd65Z3rIE6bDE2eLh/Vm0lZowiwaiFlrYk0rqMB38JbNqZLSpx7toDmEBw5/57+xuzlbU1S9SVwoeyfCCA7WT10XqVqq3V4FgfDkdIE6V4ontZIiTIN5SFKvXJ6HJEOg1CxhrMsTVwHjB+oi4I3krEYSmzyQZ6Y04fcN1Uvs1+fd8pDf9Yh6K/5SS9sBLcc1jP+AsSnwWFpwEyNAblEE+YAU0U2zTvcc3lqi7WIFJiWpFTDrJtKyX5qKVEuqXReRlseGVsLnOqA
 9LY+2uTf
 7F9YmyTAIEOQ0jcZ6wRRO9k2chK4pvSRM3MTJIDmPvRl23hz8FUpVM+1CROSvyUl4rmJokdZwzsbSXfh/M9QxcWGv3rLNtVoKRoYmRREHeo4XeWZjlBqr2HJnBR4lzVnrRYcXVmhnu2B35yEPIfR4Jb/8vhsjXMlRmMjYiHg/G+woLcvx66XFoBgEdIPKtn7fV3TZ9RMJvCjXAOJO0FFoKe25qqL7Yrz57qqjg3eOPtpHYsLogT1ooF6s/m78/Y2LtdbVCVvE/mQCd2FwbruMWzypJH7d1YuJurdo/g/IeRBfDj/ih+9DS+7gnHGJq/y96wOPPkL7KkWS+CtBE2VFZBFFZMOSvZFRewipu/GvSFzdJYPPzjU1zRdRBrFpWcJNN22vrYvFIsMvUrKj0I4RHDeWC+vjBUMTAj9M/khaXMtBOM/fuGNSI8gXlH13+kFoGMtzXg9iiWsNdytnRsRkFFgzhZO2s/5A/2dw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 4:14=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] rculist_nulls: commit message mismatches
>   hlist_nulls_add_behind_last_rcu()
> --
>
> commit 8be860a8b1d9e4863e4165df073c841c355f9d25
> Author: Max Kellermann <max.kellermann@ionos.com>
>
> > include/linux/rculist_nulls: add hlist_nulls_add_behind_rcu()
> >
> > Move some code from hlist_nulls_add_tail_rcu() to the new function
> > hlist_nulls_add_behind_rcu() for callers that already know the last
> > node of an `hlist_nulls` list, to allow constant-time appends.
> >
> > Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
>
> [Severity: Low]
> The commit subject and message refer to hlist_nulls_add_behind_rcu(),
> whereas the helper added by the patch is named
> hlist_nulls_add_behind_last_rcu().

With the commit message fixed,

Reviewed-by: Barry Song <baohua@kernel.org>

I recall that Paul also gave his Reviewed-by tag earlier. Should we
pick it up as well?

https://lore.kernel.org/linux-mm/7037ee68-5dcb-46ed-a73f-ed6ea58915f4@paulm=
ck-laptop/

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116081403.21=
6452-1-max.kellermann@ionos.com?part=3D1

