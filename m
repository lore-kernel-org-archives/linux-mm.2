Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFAE5CAC59F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 23:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159E98E008E; Wed, 17 Sep 2025 19:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10AC48E006B; Wed, 17 Sep 2025 19:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3BF98E008E; Wed, 17 Sep 2025 19:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBBEF8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:38:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C7BBC06ED
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:38:08 +0000 (UTC)
X-FDA: 83900357856.16.C9D1FBC
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9F46910000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:38:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lg0d0A9m;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758152286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5xOsOuE7mqFHBoN0AADm8mFAldkd/OpLs/yDFgnsng=;
	b=HdfTMQH/IGxm3krE16BVui8XrXMEljx78F/uKhzx5imxCdQ7MgiA8JtSqLqdb7kaER6R20
	JkVM8OmWZ0ivpbG6v8otSxQ/rwekgoiDBq9OYePQzU2eEuHbNag0FmsKZpizN3eU1pxqCj
	nIDpt2nfiuvvUroX1PZHYvFqjfHgNKo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lg0d0A9m;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758152286; a=rsa-sha256;
	cv=none;
	b=H0QnXEMtEg3+ZAeewS2tWOjZOPo8AiVeDQ0kd2iym1RBBZrLmX3wiKIj839dQ5aWIRwf3C
	eIGn2Qfngx0LY0H/bDeAM3EXEErWGnb0HOSLANLDRuXAPjv91+1WD03fNXtO9sfsZgLPvL
	o792Z0AZzlEt9ikDq8Ii05SDGxAP0Ug=
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-54a35d4d2ccso127473e0c.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758152286; x=1758757086; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5xOsOuE7mqFHBoN0AADm8mFAldkd/OpLs/yDFgnsng=;
        b=Lg0d0A9mbzpY3y+W8/YIsmPa7rZF257e0RYWgmjII4FQXk2ZbOgKcdyU6vGZSh0tTF
         9Jjnat8zvkWPeMv57j+2/8Spv2+2Ij05KGTyG0vqExKufkt0iGL0v1pXMGPPjAd5Raz5
         k80uECsn1/1FskaW8/N7opsNT6WQEPi7jzF6EiuP+X1jVNjQ5SxO4Ef7JkCdF74OBRGc
         WtfbPcV2rBJjXeAl0o6S9M2SRMlb1D1q/DhobkbWODOHzjsVNtZMcwQSsOCLksK+93eX
         xmBQ0QYdVgwsLP62fpJz7nHNhgPvRDNuzI8rjtz0d2/MJh9xiip5/JXKxH0MlIjv97y2
         1A9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758152286; x=1758757086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J5xOsOuE7mqFHBoN0AADm8mFAldkd/OpLs/yDFgnsng=;
        b=BZVlBlOwiGtE37zsK03Q12opFX5ScC82zCOJZiOEYY1+WFvHnPzv0LawCR+Cy6zIt1
         b1zqx0ZXcV20GZ348w9+s3LwR5wQPZKukwChboMPGwG9YwPApG7sp0koGO3vwO0EKQvl
         x5ytXPpnu7kEjJl0o1Zl9KAc9IflM/zjWejnIXqqgY9R5ngd8jm4nC0seDjFHHSkRNlR
         2/DO2D9gfBrnojjmYEbuYETwSE8UABwgkTV6hLiOrDfkLqT0H+IKQSeQXR7X0LPrHvHA
         VVzGlU6qv19MfKFixDvQXlB7S7Cc4snGuPmW9/K+rETkaCNutpbWdJ948i68EOltIO/C
         sjtQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDBPhjNcCsl9Y6ENFYuQc5Wxiql0KsNz4zG1trB3QKxnLrdBEnWTSGDWzx9yflEvMsN58EFS8FsA==@kvack.org
X-Gm-Message-State: AOJu0YxiqrUHhLJgOopfahG3ZZNHI0oJu+ue4SNce08fqRE4ZFMC8nO7
	G/dTK1odO85thxUKfaqxA3B22kM1Id9spBXzviOcmsT+du1bRAPvuyGYcVHEpwjRwKAq0JnanMo
	y1w1nHgyMB5Z3pWVBOFAAk35wfU0hxdg=
X-Gm-Gg: ASbGncu0o2NyhkY3IST35Ue16vgS1l67AsC/FtBwuOiWuZqXKOzdEeBqPRIJ7ldgDms
	JwQeqqehSjU05axkQEiJjNUZ0JLBath4zWmbRHfR0gYL8wm1Jxk5S2KuqNzGj/0GbuE30NvOfZD
	OoIiVC7GIAM8F2hG//TTwcmc1SQhk2tWYDGUa/pXUk6u5xtIzSX4rM280MjAnK3t+ntNZAf124A
	zTTJZjNcvGE6XgPFjn/swJWN5VmHXsPBtT90jgx2gF9+Wo25ghTNl/SHPKb12CEgTTK3z0=
X-Google-Smtp-Source: AGHT+IGuqRn72jg+dK+mDqGoNA+LUSb6AsSThdLpogcwx40T2F6VAgrf5kHi3x1xlQcu937+V7+9oMNPzX+vYBPG/lE=
X-Received: by 2002:a05:6122:1d56:b0:544:90b1:1a with SMTP id
 71dfb90a1353d-54a60a7a22dmr1414035e0c.13.1758152285466; Wed, 17 Sep 2025
 16:38:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
 <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
 <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com>
 <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com>
 <CAGsJ_4yhDU_WVfEybDhGE-WF5+w-fak1-F8jqbAQ-Qw1+qWkaw@mail.gmail.com> <CACePvbUabb+L6Z9Nb-41fLR-FMhj--cDWSbnXtCj3rpqXModiQ@mail.gmail.com>
In-Reply-To: <CACePvbUabb+L6Z9Nb-41fLR-FMhj--cDWSbnXtCj3rpqXModiQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 18 Sep 2025 07:37:50 +0800
X-Gm-Features: AS18NWBcPj9Qd_aVSIjWDbzxxGvwYyUsh2BZYSK1JiFlFC7naijW-G7wdpR2M18
Message-ID: <CAGsJ_4y8yTX48ESHKgLNCvM1M1_gY9uGnD4qiz8n+gD47Zd1Hg@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
To: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9F46910000C
X-Stat-Signature: xpk44q6oi8xim6fmbwjujty6ir3jrkqk
X-HE-Tag: 1758152286-375150
X-HE-Meta: U2FsdGVkX1+VPmW232SxIPfw7P0WXk3/MN4QUCSxefKvYQ+mhe5YXdMIx3pJryByygharuBGeFKbcX7rXkeqgNvFd7MfI5qJRMRqLDj1PuB8GRqaVbgJxLYCRADigwJFbjhLCEa/qH2+q7MQPVcu1B3Hkt9cB9np6wVoV491huldiCWrH5EdwgT3eI2YxiQ5s3kq+lkXJ+17oNfDX3qMiuvCQTcdb3/2m5fA29AvldIAIqRCP6ja+LtbmYbsUYarCQZ4JuwDITUuv7Y/FG4RSvneG9PyIv1sC6yz1tRgw6+mjBDOCzlF+H2PTTG82FNA/oqAlQM8ZGD0/93LIyFCqeRqJt63LGVvlWQ8lB7JMICM8ekQttKeVfXUeSfbtueACOgGOCfFgPH/0VNm8dLHbB+jwimDipoPuDgxW0nZ5KFnsX0Py3QFOq4NHqvgJvs+9E0i9Blttso8rGqMMqMOzb3E3vSGTAWklkuLu85bi6/k2I204xGqucRxTKHF4oeqbYNYTBUUsvCspc9S43lbRYU1O+yChZp+Fxa/vuYmOdiyXOQ8ntOHmKABwFwRZPo+LPkxq3mLGousLs7ubWt8pc8yq3ok6KGG5ufHYfxpKxiwBdRZcuxeq1dd9lBLr9Zpmd+1ZSzghcKjNfhdAhlkBHFZ3WaHxWJDTgU7pqzRORBgZy3k5MCqraK4ftEp1z3e9C2ygy+wlcvUIu0URpEmpeLImXGE3zN3599Ze5YmL++ZsCB5zIVONwytsLUDfYpbMOZp3BZvJbZSm0afFocPVWnrXuRC67AyN8W71AjCtiz0Weg/QccIf2nrTTorfd1mbH0xzff108s9fZ6yFdLC29COJG/02SvE1JsU5mk9yLa8y6UQ17MlVpnYv0caS64jNjlL9DECGuzxm5b2dxE9if+OMOHbaw9aovL/Na+IwmTEXO/X5AxrDK3fCDg8dC6Vg6BcPd9tCQ1H5NZOVCC
 ZGtSV4gd
 TGkQw/0jVq1z3YjcWc7ZKf7xxrpv21L3FgucfzNu4x8Ai3fmJN4NqI5+2JruLftci0Syya0w68fogVgwO0Hkoxmgjqvaxf4BFQ2YDEsucXxUAiJD+xIuDvFqpi27+EUZN/zmq9TSkc/Gn5UFDwW9FByt1uYxcjFdcPMQRR32m1WEiTwBup61FBImhRhFzjP88nBVMry9TyldndVLRneKo+1AD+/pwHGYd7C0hRvwaXYuuM+Y7gfuWQqBYLmTb5UONRLzRUEVAahYKyM9FEKWsmcDj5m2phXhJqA58XQlFWegesXPAonmjS1jJEYKo1JCf6JZsUvBBQmutK9NPheLJX8s12cLUE8ns+81oA0wn79+yfWs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > This approach still seems to work, so the 32-bit system appears to be
> > the only exception. However, I=E2=80=99m not entirely sure that your de=
scription
> > of =E2=80=9Cthe second last level=E2=80=9D is correct. I believe it ref=
ers to the PTE,
> > which corresponds to the last level, not the second-to-last.
> > In other words, how do you define the second-to-last level page table?
>
> The second-to-last level page table page holds the PMD. The last level
> page table holds PTE.
> Cluster size is HPAGE_PMD_NR =3D 1<<HPAGE_PMD_ORDER
> I was thinking of a PMD entry but the actual page table page it points
> to is the last level.
> That is a good catch. Let me see how to fix it.
>
> What I am trying to say is that, swap table size should match to the
> PTE page table page size which determines the cluster size. An
> alternative to understanding the swap table is that swap table is a
> shadow PTE page table containing the shadow PTE matching to the page
> that gets swapped out to the swapfile. It is arranged in the swapfile
> swap offset order. The intuition is simple once you find the right
> angle to view it. However it might be a mouthful to explain.
>
> I am fine with removing it, on the other hand it removes the only bit
> of secret sauce which I try to give the reader a glimpse of my
> intuition of the swap table.

Perhaps you could describe the swap table as similar to a PTE page table
representing the swap cache mapping.
That is correct for most 32-bit and 64-bit systems,
but not for every machine.

The only exception is a 32-bit system with a 64-bit physical address
(Large Physical Address Extension, LPAE), which uses a 4 KB PTE table
but a 2 KB swap table because the pointer is 32 bit while each page
table entry is 64 bit.

Maybe we can simply say that the number of entries in the swap table
is the same as in a PTE page table?

>
> Thanks for catching that.
>
> Chris

Thanks
Barry

