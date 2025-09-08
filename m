Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 393DFCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96FB48E0007; Mon,  8 Sep 2025 11:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947738E0003; Mon,  8 Sep 2025 11:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884D58E0007; Mon,  8 Sep 2025 11:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 775FA8E0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:02:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 432821A01B7
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:02:04 +0000 (UTC)
X-FDA: 83866398168.19.371F403
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 54646180016
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:02:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t+IHncyA;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757343722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2gx526aV9m3uDMDNrG3WNU85BtxcRV9FoEMF+vVlmKY=;
	b=zTRPkp3jgCRb1mNCCNxJBYyXiNTSibv87qobu8lqeT4jv94OrX57gO4o+ITdN2/RjL0oLY
	DRkLbFKzaKFUqr85nRbP6lMAXrtdIvksHhSgqelQwcYKrof1L5+FKOy4Y/ZG5Pt9ZDHEqI
	L5hVVMsXBeSH76ymZEJ0tf8oVRPecVQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757343722; a=rsa-sha256;
	cv=none;
	b=AczBrwzE9WulFaNG1JsYoCZcCVJ/4ImaUdh14mfQjLLl2OeqYK2oIEKxZBaBYohSIKL3YD
	4A4CaeBuk9UmeZdpQKCA9WckutdWbSSJqDkqcKbj12ikNBktkBZt5oXMC3j0ZMJpMxku1Y
	3073K0IRBxEf85MVgq8F7zAYE9N5Luc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t+IHncyA;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A17BF60145
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5062DC4CEF5
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757343721;
	bh=OM1OnbaCgtCJHQx8TjEqp20e7QRXP/rperJMzvdyHJk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=t+IHncyAt99nsaBlpRj5ClL+DBgHDhjRApzY1W2mNG5Nhm0qqqbNnm+pk9K1YF/zw
	 KDab1+gLRhxOVBZUYOlP2dO5aiRy7IdayqvEunDj0ihLrD3n92vfVUHepBqaR0hZjl
	 EmPvHqY5g8HTk33PapRve6SVvfyvIlCGbRygHVeB25033RdxRS+iyx1Pa6wGM2r85y
	 CbbX49t4lxFTQrBl90e0QpwG2VB3doEsA3efpj/xCqzaXZ4/Fkz6WPo1GsB7e9B9yF
	 qfexhXX2mBJIrVCumMuy7XmkNhkqiwV4c7YnyaWdvOqdNajzLJmcaqYtvl1K1mWSuY
	 +/8U30RB82fOw==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-723ad237d1eso40423617b3.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:02:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWV0qXemN3DRPp3e1awdmWIbLVPaCD3mVbz9dKqltr+gvL0dICZ/HRMrsnueev60/nVLes53o30eQ==@kvack.org
X-Gm-Message-State: AOJu0YwGVd5D275jPtARSyzPd80wxLbWi5D4mHPQHCdz6GPAu3meXa+w
	bQ9GJP8uexUTtAFdj0D2lG5+mCHpxrPw9ZyjfCHS0F+yr7ILGoFEfOGbkGtmriBl+nuO9LBTG5l
	o0qAarZOncGEwlzwCYNjoCgi7yciVGMy+/RmJIv3M/Q==
X-Google-Smtp-Source: AGHT+IHWbXOCSB5y6ER64K0ZmM5y11hkhIk4ACM6eQQ+BVtQgZ3qMKAziLcIoqDNeTbp/CE9+BjYyloFcWxkmFw5I8E=
X-Received: by 2002:a05:690c:7691:b0:729:afb7:2a2b with SMTP id
 00721157ae682-729afb74a58mr34955597b3.46.1757343720607; Mon, 08 Sep 2025
 08:02:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-2-ryncsn@gmail.com>
 <aL7NrhGw5ftOXUZs@MiWiFi-R3L-srv>
In-Reply-To: <aL7NrhGw5ftOXUZs@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 8 Sep 2025 08:01:48 -0700
X-Gmail-Original-Message-ID: <CACePvbXi3Avsic62fMdhLaDfiq4LS_t8-wbm9yQnEkScoxYO-g@mail.gmail.com>
X-Gm-Features: Ac12FXwmTYW_a0Q3ghO_ME29Wz56bBlZ-2vE9ttlwiVb8HKkdfVHMJ78txT5mGw
Message-ID: <CACePvbXi3Avsic62fMdhLaDfiq4LS_t8-wbm9yQnEkScoxYO-g@mail.gmail.com>
Subject: Re: [PATCH v2 01/15] docs/mm: add document for swap table
To: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 54646180016
X-Stat-Signature: doyhcyfkxedpt1pbj9ad9dkt717szrt1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757343722-118059
X-HE-Meta: U2FsdGVkX1+OMvKU6c2qRwHtZ99E4afe+bMaHzmO1r4JFTrrOn7OFlp8cE7y2U2xDWws/JPkOkL7m7jnMwqQIZHUi/lHqv4NtJDvTw07zyq6tW6agXXuMv+GR3MwCfosGq4t/WLs/9lx7SJFfqqP/HZ2JFcxlvUKvbMtUCow9RnS7ljGgJUP8BoqXWEGGuD1KAKojat8b2xu8B1ycdudRgbHHufmVPS2kNjD4pOjA+xUNZvaog0BrHdFgLJw3OPKvckZHwB+8Dp7tnLnV8127rBRL+RSTfOgvY6LRl2CvGlP5fGZSzzkzEBkI8FHIkSrigsK3LV39PSFI0dHxPIaOGDFmrfKfljDbQPO8A94fj+/p4q1VrjmXndQDa1pwWGeDNSVRKRA075Vhk8IyVdlNc2cNaoWdeJKyaBqRz3FIgXpaS54swwsmeEYJ3Zn6RiCOZDcjRETVhNTbMLOmCz9nOzFCrH4SSdqaidSeEfjOizlD2AGGLIo839XVyGOs/L3LWt6kHY2NG6snmmm7OI6QTI237Flv6zUxrsBst/Sgs+IdPchHXcG8CTAmRZdVRFpsoJ8XxwnhCQChncc6cGUJ3L1IkO7IFaUMk7YdYxs76IlVGfUildfBZ53fK4eaXNh7r748gssnLWqvRq9ffmy6ahT6hwxz96WRCOczdYEhTuWUiJuX6B6DM7M4mVAIGNtkKcFxQPIhnp4EZIt7jUZ7urkBdKHIiiGeJyXcSyvxY76gGCsCza7oCi+02HOiiYs6QexSZT2hMVH0+pVgr4JvY22S9nHUDRqKjAnN1PXJnQfcgbmnQSegRItbfa3PiQ9yUSixMcQfvAsTtYE1rz+x+8TtiNgonAdXSoCdf7bZQZ7C8x8gs426V/AYoBcw/ZKyeztdALFqqmKdbuO+WPJwsYbZNK5hrEr71XgzZky8SRKg1IlapC4FyJlnRa8S9I/c7h8SspfmIn7KK23NUS
 LYm1JmjN
 I6S1wjgpOw9h7vvFPf5vwKRd8OFS8wQpM01G73wtnBQsLBUuSJETZCoygdaKTAYSVIII6iBQhTlkOj3fjiViXvS15CqjuONgN/jbWj5OjqhANFgkD42jzMQEtmBi7DXCHYiURw64sA2hRvOeeKxoeIQi2LE0QFLnbrzUpcPZBZnU3lLD849dgySccg/YIRLwmZfUUPj7XpXwkrF1IjMsMwPKq+7qCR+bMLTC+Zv07xuRSKdXFDZC1PeQYXukwrdQ7wsygmMuEv1psqKgpw5lYRBJwd51lTNfYTywqhOMq9tVwfGs4VSyeuHeCDR0+XvGLV3zNrPlhcUK/3nhfZytJbOAxDogtnnm6H7f26U//5dImhsnxiYydFp5L4IWh9mwl72GWk6oWXvPV7Qw8zFxmXQnOTC6o2G8mVle7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 5:36=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> On 09/06/25 at 03:13am, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > From: Chris Li <chrisl@kernel.org>
>
> 'From author <authorkernel.org>' can only be one person, and the co-autho=
r
> should be specified by "Co-developed-by:" and "Signed-off-by:"?

That is the artifact of sending another person's patch in a series.
The first "From" is from the email header sender. The second "from" is
the real author of the patch. Just like an IP tunnel packet there is
another inner IP packet wrapped in the outer IP packet.

I think that is all normal and did not violate the kernel rules. When
I include Kairui's patch in my swap allocator series. The same thing
happened there on Kairui's patch. In the end the git will know enough
who is the real author, because those patches are  outputted by git
anyway.

Chris

