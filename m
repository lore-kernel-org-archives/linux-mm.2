Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7D5EB7ED2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 04:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 446846B0089; Wed,  4 Mar 2026 23:32:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0BA6B008A; Wed,  4 Mar 2026 23:32:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D6A6B008C; Wed,  4 Mar 2026 23:32:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 20CCE6B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 23:32:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6B751407B9
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:32:01 +0000 (UTC)
X-FDA: 84510736842.10.4F1ED18
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id BAE6840006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:31:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=myUWpI7d;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of jthoughton@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772685119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07AH0O8rOQrtYR1vEgFaL79Z/GhmvxKal7S6yeZHNhg=;
	b=b6GasyAyg26CCTzS1NjdgcaONUTUvB1tYhflMpn1FmKwhS/hLEBC+uxWCR5HnLaZPhUJw9
	GIyYjpejdHtGIEfc12Ij0Ava9kKfORk+l8LUhNgrmwl0lIp3g5M7u/uUhmCzuBQW5zyAHR
	zaOOqgiZaC+of2VVQiWMzFjVVGzZROg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772685119; a=rsa-sha256;
	cv=pass;
	b=7+0WcPKbVpusO1Mh8/IY81Ls1uwQpYOKFbf9/evYN/D7I7VmqU3s5ww6/sInjXflQREtQP
	Vl8eigAYCEyqmdBYO+9hpDhtserx8kot1vRB712Wl/bs2Tt2eteCitfUurH8rh5F8oN3MN
	Wu7r/ruD4dpkto6B8QoNNdPoW0myev0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=myUWpI7d;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of jthoughton@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-660d2e4846cso2139049a12.2
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 20:31:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772685118; cv=none;
        d=google.com; s=arc-20240605;
        b=ZGqiQByB8RoAnuJy30YFrgHogjAbbE7+mj/2BeAhcG/yX8TSlz7tdzZAXY9yHXmdN0
         f4BZ/N4PsxGE6sTZ2gIse8lhKsGMmshoMKguI2Dz46hw7kQO5REWb4e5WuQ+kgWPS2gd
         KY0/o4m5X2zfYP0vmha1JwCQtGtl8qUa9adwNeVTdimTvst37LViNJIfr5lWw29sOtjr
         8cMgNie3hF9Vvjn91KFJQnVbX/yhugpDXnaay0kX6yXlM4A9yr3D4xVFIITz/0f0983F
         wzTwkLq1eA/cS0rcH/LL8sJdJoplKE/OGhNFGdU30e6bF5QuRYe5SZ3XymY9uc0uWZ8S
         dmCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=07AH0O8rOQrtYR1vEgFaL79Z/GhmvxKal7S6yeZHNhg=;
        fh=aHI3dzrzfKDTDZOZVVuhgGN4bcCx7ddy4my8XihT4s4=;
        b=ZlvOOsHpp10N3Hjy59QbbwLTN2GBSGOW+4OM/qUK4as3vCI03P5YwarWFpG062f/O4
         wylVxpZ6XHgIRri6rdR56kJVyqs0WE2G14D4DDAzN0izefoOry7Fu4dc0po7q2HIMFML
         +AkgSi6RV5l6oFdZ/66YO7yBRUqY1CKgCcSUZbCmCHLQODJoNbkNlxl70U76IoSKfVuo
         +3t+gZgQI0K9+ry3WwqtFzto/CdH9Y1ujgZZNw+w/fU8dyyRgd7C0aFOvUijPzN1Y/vF
         LlrxJyUWGiWnLftP/xIvoCmu+js0rOrdAAMtB0kl9t+3g0AUijLbozF1v8BnLwHQCtGQ
         DxZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772685118; x=1773289918; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=07AH0O8rOQrtYR1vEgFaL79Z/GhmvxKal7S6yeZHNhg=;
        b=myUWpI7dQ5q/DR8o+vcD+InvmurGldIRkGVArkkRRWnGOouEbvlGt24y9QE0GGf46r
         atI2J5ufJAGK5sSJ6HSp9zmo8VcwF3ozFcJ7+HalCL+/KMAkKaC5z9sKrDNJv3fWkuyJ
         zRKOyD1/TlEXW+7EEivpsicJ+ihtOJ1KCyyZoLSWC/Ma/mtDvMz6GpELq8aJlxSYGS6I
         gZiHViKr4NJyzvNSEXjbE7zhGr9/LkU8rOWLUU6BdxYdG3w4TqX9NuMa68Q305b6GkM0
         Knv5PskCAb1tKn+yH/FV3XHxu+v8+2mrdz9m+gNuPn9hLq04P4uK0NPgg9YG2q/gtwN1
         pvqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772685118; x=1773289918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=07AH0O8rOQrtYR1vEgFaL79Z/GhmvxKal7S6yeZHNhg=;
        b=jOZOtgSok3JCie1vDbeH5FnJafLwSshPBT3IGw4pEkvED6+6lbXYwAzUdhUCSYoypA
         S9Pt+cvRrdTb/S8j8gv7Hvun5DW5m0OXIs4EWD/dcDJdGa/+7ZeaxQoGcoDKVkCPmpL6
         6TyzFKHKGRF95sFEl75wApx/uYXltkwYX3oZQ2Rl+zvnFqEroHDjqaHOD9ZDPTL33qBb
         Z6wxD0tQmlXh3m4E+3kpV/tv9WDWcWLWCZHPpPakXu+b8hvvegMWUT+wKEQNjax/A395
         n9EZ3gzsvKLkuGVK6EydXeUrNp2hfcPAgWuL3XHVriqGNtZRKXmCTW2v/bR2aZCBo9wa
         I4qg==
X-Forwarded-Encrypted: i=1; AJvYcCUXy8DT1e4Mod07eHgYKQ5V2mr1HQCLnoRHiDGA7EPIcgiRDVkmoQdefmv9Yhg2NXGQ/mtGwipK6w==@kvack.org
X-Gm-Message-State: AOJu0YzAzo8UDWRzNOE+oVTHxFDbMXKVjVeAzVLxnACij8WGIoMXynOx
	9dcI6euX4IGa+7BE4U6xT23i3BUIpRDItnF+tE7oN+w8uxYuWYZ0DDrPfCquUMcGM2mMk6cLf9P
	XWEfrk8pQUQJu0aVi+uBmUtCmIZYOX0I1ksEnoeY9
X-Gm-Gg: ATEYQzxY0BY6nqW0nADk6OXfpoCnaPcvLe5Tg3ZLp8FnsJoj67B3LwWDs2GtARdFHa+
	gqunMhiq5VBjxeWTvUOcIi8rfkRrvHvXenY9QgAShcPsEbR2Y5g21Xwmm6xx0aV5wDxAcH6Icgw
	E7HTgNh97C6npNb5RwbxYbx7w5WN6tKzaT9lch4/2jUJU9gpfQKXmaS8s4JApTQJnBmnrn/cAql
	Pb1gJrP+9vKf8k6wC0uutHDrNFdh/hTjy0aIU/oKsOjScLi33wkiLHBIHQDZ205bmmSQWrcHrAY
	s/x6kUP9Y/O6VBINhtKfVeLgAiwcRUbGach7Gy0ijvMvwyPaxlpwr/fyWqt9qPvX/6N9xQ==
X-Received: by 2002:a17:906:208f:b0:b94:898:7bd2 with SMTP id
 a640c23a62f3a-b940898a1f9mr26074666b.39.1772685117464; Wed, 04 Mar 2026
 20:31:57 -0800 (PST)
MIME-Version: 1.0
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
 <CADrL8HXaTz-TS9rYiQkZ6NoRWhHm0t4Tv0t=TtDXS4purLnDJg@mail.gmail.com> <aadTuvCBxiVimDZA@box>
In-Reply-To: <aadTuvCBxiVimDZA@box>
From: James Houghton <jthoughton@google.com>
Date: Wed, 4 Mar 2026 20:31:20 -0800
X-Gm-Features: AaiRm53dJeRWd8Nji1GYa5e5Z900_RBsGxiHxN9h3vB4MZepaklzjxRsMiu3r_c
Message-ID: <CADrL8HUHQDta2mv4TG=f3nYPx5-S5nrywGxQwx78KSe67yjYVw@mail.gmail.com>
Subject: Re: [PATCH] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
To: Piotr Jaroszynski <pjaroszynski@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>, Breno Leitao <leitao@debian.org>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 6t87sngzwtyq39ma8bj1319h7rttqr1r
X-Rspamd-Queue-Id: BAE6840006
X-Rspamd-Server: rspam03
X-HE-Tag: 1772685119-703878
X-HE-Meta: U2FsdGVkX19bGhuZbhu+j03rqX09V++GSAMJ6fa8g1qNgCK7kHc3mGNJWAGXbh/ZKBwO7ITH9FzQ0+un0AOcQb/TWJ8/Mi3PsZl0PHvfYknhzA3REK0jzXwwojqP7XjOWZfDdOtI8XRsGK4oFOk7EHcPIV4jdnbkRXrMIYTja8X6XkVoyAmSuz4TD04Y3IBHNpgB4jCBuLLojcPqQMaxrcVAo8wBxgwPi1MISpZ9bthoRWPsMMNsTWvRx5ca67uNJxRelNkg/nYt9k/dWiMwDRTPUDd6lqmTsrkOmoXpij5C0/Xa8y0ePmf2Qr1VXUOf4r0IXxHSj5HkMN3D1O8zMvrTLgpZ34qSOil7PZjppGOj0fpIXJd/9BqryYbMJUoZb9o1IgdZKusC1x0E9s4fd10knqsuCbdf4jKch0lOXrheEy66b9CFvgITXUE4GquY6nvAq/JIBL2Tw8JwAAjElw7oxqycIceDh9QgEKSGj+KWNy/L726UEvuBNJHF27snZ/3CN8gv8hJLSjXbD2xNOorwPWcjByL8HhIkgcnlVWNAY80q8pNkNJTNcXJSxduUoHGt7U6dHDD49m3JlvV9IMyenR+RzGnGdNZZYhj77puNryGRe0L1WpIoaPR0tZ52Mrrn3ioFxRUrCXz5kXvM73AFP72P+Te4hVyIK7/O/qxo1/G0A7ymdWJPcE5U5OTbzpLUj/vhmVQMzlvXqzQCuYdcdTldKqI5MFbOU4IywyIj5P+JLcRIA6WM3/Rg0fherErLswhVlwvdBNiBmU+JV4jqF+UewlIWb47DDQ3nf/LRC5UZx5G7++/62ucaeYilRX2X3YCdHvIB9M8Y5XlFe0HpFfS1HnWV/21O953gOMicLvsPhq3Fzzao4wa4ALDA0PsGX1wUBiPm7kEptbdL1+1NuRD6QzwqSLJ0PNCKn86Jmc29kS1R3Tb/0tmKuK9mveqHLOuxOcYoj6BoHLT
 vahfVmLo
 PfEjz014s+frK34EpWFKEO7YEI9VzEReQ6Gvb3TUBKsgrr6miS3+8ylabVLL1dgm2k6yFLM+WH/2e0d2v9En6A4Vf+vB7MZxt5TJ7kbMFhfeurEWwtWMRlalMiHxHv290Sl+5diQGvcOAIXNkfjzZxNosFLiZBmAlFUIqEKIU7MWFJkI+0V5PRUsrkRc+H6S3NydWV6L9MZ1dwKtQkh7Vr9pFt/e5rhSuNGO9d5cJLdWiDm0ib9jMruSMx4wVnH8HD1S/yHVtbSiGbQLxIIRUdI/BzEvb33jxZ1suQXJau8LOZf/ptMoX4+IZngq0TCHIqkoiAjQ0dvfN8QHjfHWmgRPCAx6hAeEagsric52lG0yzztklD9oEKGOthAc9BVX3kuB38NDfI2d/M69qyEsT7+8Zu+Ky4kBbCZ0Zk8m3xiPfGMUD+0Q5Th2eQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 1:40=E2=80=AFPM Piotr Jaroszynski
<pjaroszynski@nvidia.com> wrote:
>
> On Mon, Mar 02, 2026 at 11:19:46PM -0800, James Houghton wrote:
> > This is similar (sort of) to a HugeTLB page fault loop I stumbled upon
> > a while ago[1]. (I wonder if there have been more cases like this.)
>
> I see that your commit 3c0696076aad ("arm64: mm: Always make sw-dirty
> PTEs hw-dirty in pte_modify") from that discussion was picked up and
> it's very relevant for the hugetlb exposure question. With your patch,
> do we have a guarantee that sw-dirty implies hw-dirty in all cases? If
> yes, then there should be no exposure for that path. But it still makes
> sense to make it more explicit.

At the time, I was unsure that the patch made it *impossible* for
Linux to ever write sw-dirty hw-clean PTEs, but, after that patch,
such a write would have to somehow avoid pte_modify(). That seems
unlikely; that was satisfactory for me at the time.

I thought (and still think) that explicitly fixing the HugeTLB path
would be a good idea. I think that patch wasn't taken because it
wasn't necessary to fix the bug I was staring at.

So if you want to take the patch to the HugeTLB path[2] or improve it
in a v2 here, please do!

Thanks!

[2] https://lore.kernel.org/all/20231204172646.2541916-2-jthoughton@google.=
com/

> > [1] https://lore.kernel.org/all/20231204172646.2541916-1-jthoughton@goo=
gle.com

