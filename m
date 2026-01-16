Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F4AD47CD6
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1F26B0088; Fri, 16 Jan 2026 05:57:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6559F6B0089; Fri, 16 Jan 2026 05:57:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561566B008A; Fri, 16 Jan 2026 05:57:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 472E56B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:57:48 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E55D61A01A3
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:57:47 +0000 (UTC)
X-FDA: 84337526574.21.38A7217
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1FAB31C0009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:57:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="n1olQ8/h";
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768561066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vW0TpIjbhwfQUllBuEBNpE1pi9wMTmbrHAs2dLrQhWg=;
	b=YS2UQbx1uwBi3eguVGU96WUcm3KdB8XMf1ekoJ+K2L+7w6mcMx0WPd0aY6EZyCU/VdrI4Y
	pUH3/6BO0x+f+TDo3+zLvXzhataN02M6Urj+GfDQWSMFM1wG6M3ecrEpwQpWuPkoie6AaY
	WpWN9YIbKQ4F2eZJv/r80Qu7oY81be0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="n1olQ8/h";
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768561066; a=rsa-sha256;
	cv=none;
	b=B3MxBs4u2d8wiYlPCjvYg39RqEAopS4dChd8Tt0WRZYOA/ABT6a7RPNfafkBhNPt45AqMU
	zee8D4bixcNxq5L+coeuEI8CR8+6SYtw6eQD/YhXGUF3m5unqgD5iVc2a+64kiUbBW6VO7
	CroeFX+KxzLZcXx/1R9+/5em/L5M03E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C8AE601B4
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C7CC2BCB2
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768561064;
	bh=chqBt1DErgWHAKraD9dL0AwQEhVOgew+10hoOyNQZeU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=n1olQ8/hcXoA48JVCso5/h4Zd3NM8nAurSoLsjFrXB8ghKy5EyoWTDsLc5FiBchTE
	 GYYWNI6K2AQhFi6EGxPLycIYeYHOTNfAnGPEMpnBYg0PIddD8sqYtIpOWVoqBQ6FUf
	 paopBHme+/9sTzQmDCGHvgICoLrOskvbDO7kqtjujmDCm7OUZZAOPHj0gVgSNJohT8
	 kQ4vI+Cli/RmkqmnnReRvCh7sYD7yx7/nUGmVEikDLTvL700VgfXRLVKopveKlRlwf
	 Q8jNdAgdMP5dYTWe7IN77a9Oq0Os1rLWyCeipKcFKrgxTnC8YR92eqpzhjz+cXqyu/
	 S+7aNAHLIky6g==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-790948758c1so18083757b3.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:57:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVMjqwV6gKjAhmjvJTWb8BA1pXl0iRWpMbgUnemqC+MWARDj0Fy4OWpWOzeC4bOFaZkwCfzU9Tuog==@kvack.org
X-Gm-Message-State: AOJu0Yywrsl/YT+1Oi92GfTpyjNLDs6qSbF/2iwtUvi0noOQe4QngVgW
	mpCzVVFuvyc1l6m7hHL4ERMl1lsHvqvcqSc5XnK0aMsHkEU6E8R7i0kacluzUOsvpYpWc9xPdeG
	9pyF1fn3EUCdKxKV+xSN2pVUJjIkCe+BviH024YbUHg==
X-Received: by 2002:a05:690c:7288:b0:789:2be7:aec3 with SMTP id
 00721157ae682-793c5394166mr20601787b3.35.1768561064074; Fri, 16 Jan 2026
 02:57:44 -0800 (PST)
MIME-Version: 1.0
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
 <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com> <CAMgjq7AUz10uETVm8ozDWcB3XohkOqf0i33KGrAquvEVvfp5cg@mail.gmail.com>
 <20260114142921.1b47d27a3bb22b41ed0c5526@linux-foundation.org>
In-Reply-To: <20260114142921.1b47d27a3bb22b41ed0c5526@linux-foundation.org>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 16 Jan 2026 02:57:32 -0800
X-Gmail-Original-Message-ID: <CACePvbWTFmH2xyt+F62EfF0ASwrt7ojmfTktjkKov6TDmXDHcg@mail.gmail.com>
X-Gm-Features: AZwV_Qjp3HLup9eysx6hmj3CZ8ot9WjmM2Y5yq7MdmC5LjFWC_OH-ze-o9xpG1w
Message-ID: <CACePvbWTFmH2xyt+F62EfF0ASwrt7ojmfTktjkKov6TDmXDHcg@mail.gmail.com>
Subject: Re: [PATCH v5 14/19] mm, swap: cleanup swap entry management workflow
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, "Rafael J. Wysocki (Intel)" <rafael@kernel.org>, Chris Mason <clm@meta.com>, 
	Yi Lai <yi1.lai@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kie99eyrwa79w3nhztqjefk9nbqn6yqi
X-Rspamd-Queue-Id: 1FAB31C0009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768561065-801819
X-HE-Meta: U2FsdGVkX1+1z0QAq/j/3sM3y6uSfsbuKXvVS5nF2nZXvEHqqEOLwKnp3nwVEDrhST1u7KyCU1R2ZA/wxJrtXT8nOE+uE5yo+BVrNJK8SYbYeU07RF9CKqxSDxq/boaNJ4HTbJot7r4vqlxQmTZ6h/f5o97BDRQtmQ2RFzj69njy7Sgf/p6E6x4abGTx0rInl172IlCVVAutXsIZLEYOY/4tmGEKIYrarLH3QFxt7sJwKKdBiDGeYAog94j41SyoLdAfc5ovIYadLLk3M7Awm2TKtYe2to+F5pJ3G32g3oTQYrXPdpK0DaH/W0BoEKhYp8YuA6i6woU8Tdo6tAAfF4BUNB4aK+AJe6snKjfh+cH/jGsvGe6XBbo7sjAskfueO4LQOyhzM7wIIjl2S0eMXS/M2w7rfVIff3kTixa/fhZ/OOid6VshZkNoHpGnYpNR3ejJ/3kNyiXA3cdOMBSwroi1xPd4NX+RbeW9NpeKrcoL97dRa5Ud33+MrEMEkE/yaIcj2EeHaB0edIYSZhokgaX1uHPz9u8vA8+el94aEwg3nGPZbamwe/mR1Yp5GoH3MklxousROaujQFArTQOxRwtFItlfoX1sRv30jqepAJnZ2OwHU2luZKv6iF1w/EBk9Ly/aBg88H0WoXxKLBEOb68bTfXkN/XfJlWbpNtRE3PVZQB38jJow1Sge+WZUNPRzlWeVyHrfXqfjL69vErgQYppFI+VwXt+sIYhW/IBOKmcbxppp7yCODFTRa/LWH1RqQLPLWR5dRhdiz0JybJbnu6WnTb6APTZOeaA0ZxuHjjfnKhvTneWUhWFqwEeP2SJAfuhYBsOSdd/u/xqfgSsLMM3/VldA6c4jCWw/cdP91PAZ045kchbRVLEjustmMHNYG9oYG/rAz2ssskuJR08OskmAxJhqPjPSEWpIsZOyvoztXPlrPGwzRab4Negt03MEInYGAFIPGiiuJtTjsG
 hHq85ltu
 M0HjTFXGtCA5pM38x26myCAV7RGPr7O8GISdAoJEY/sY7Z77Iu3Jok6+GwFgAecPVRQGYPqvNU11GwBqGh7LpUgl742aEx9ONtKmhhs/fx91P+c+fdoG9DGIZfyp7mtGpvNaGwmjg9sMCJXgTeAi/iQl6M5XAACqnu2L0Y5+MBahAVMuDaLzkUEVGId8CXFtFuJ/kGG/hK0E0LxWTmP/g42MC5gyGym3QXoHg08IG7tNS/n5safKVgnzhoOCwDUw7DJUbyi5fcNOLbFaL43qrE9CEAeM5514ybDAmp2yIlZgIRP6yCjE1li5jiGZHoQddTBmQLYIv9n2WgRccsouAxlRrEL5gFIDKgiRYgg/Bo/6WofFr37eV6q3aTpNJgYFynv2fAQ8nFJNryC88LvsVFmiPcWBOto4eqsYuFK1d2b56CPoSk6BUXPAn/q1cFykh/fCNv1DdoMgqxBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 2:29=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 15 Jan 2026 00:53:41 +0800 Kairui Song <ryncsn@gmail.com> wrote:
>
> > Is it convenient for you to squash this attached fix into this patch?
>
> Done, below
>
> > That's the two issues from Chris Mason and Lai Yi combined in a clean
> > to apply format, only 3 lines change.
>
> Let's cc them!
>
> > There might be minor conflict by removing the WARN_ON in two following
> > patches, but should be easy to resolve. I can send a v6 if that's
> > troublesome.
>
> All fixed up, thanks.
>
>
> From: Kairui Song <kasong@tencent.com>
> Subject: mm, swap: fix locking and leaking with hibernation snapshot rele=
asing
> Date: Thu, 15 Jan 2026 00:15:27 +0800
>
> fix leak, per Chris Mason.  Remove WARN_ON, per Lai Yi

That is a great catch. Thanks.

>
> Link: https://lkml.kernel.org/r/CAMgjq7AUz10uETVm8ozDWcB3XohkOqf0i33KGrAq=
uvEVvfp5cg@mail.gmail.com
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Cc: Lai Yi <yi1.lai@linux.intel.com>
> Cc: Chris Mason <clm@fb.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

That small fix looks good to me.

Chris

