Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 151ACCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 16:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CCF38E0092; Thu,  9 Oct 2025 12:59:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4B88E002C; Thu,  9 Oct 2025 12:59:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1E78E0092; Thu,  9 Oct 2025 12:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E19F8E002C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:59:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 965DB1DFF05
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 16:59:09 +0000 (UTC)
X-FDA: 83979186018.11.8CF7CC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9804340002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 16:59:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HFy0BiUA;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760029147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLSQ0K/pLTdtK27NkFALUck9U04H89xohh1g/mgRQZQ=;
	b=0zTxITrYdn33D1TfH/9kanepDQWm9kmfXphvNysjbbpcaIPhf+AG4hKn/rmlFVcySov3PK
	YT/h5SNCcMWXAIMa+dXCsHIfaTBNzL7II7DmA2OzdkADTPkSU6rBSW2ZEb9N9EUPcK1ycp
	VdvjMfSzYgrU3lZsmHs+ynK/lDkDNZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760029147; a=rsa-sha256;
	cv=none;
	b=Zxi5P2pCGZH4PSj9kqrFWKZedb4DZqjakUlI6ZqhNUYuZQl8ngqVn1GGTxSA2dBnP+A3Af
	8DinOluXtXrJZY7gllwALfiJBY3Oexb/Ty3bTGsTtlkqadkfTiyoBl+IeoEirxNHEJ+t08
	hlTPhBDUsQwFtdvHYKZHqFS7vXhreA0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HFy0BiUA;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DD0C48E84
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 16:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F33AC116C6
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760029146;
	bh=CLSQ0K/pLTdtK27NkFALUck9U04H89xohh1g/mgRQZQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HFy0BiUAEb792UHr+KKcwGwtAGRmrfbemFlZCU+k4XS5wlnVjMZv2xrX4/X9DEvSg
	 kNkbeVpmLGCMA7MOAS3dj0y0C69dtOg8d+09IiJlK1cC/Hpom0AC2lPCEbjXlGRJoh
	 FRcJokCsIsqHpenYjenuqDKB9wyyWX7jFQZJKvSXsGTWPOJDJy+3kbdTpMxKxHb1pV
	 +63pxXRIkVRTH3W0k0xjAnr5X2lql2Bt/Qho2uooeMZ39TtQ0wthcrjGqsibT3f1O7
	 fllAD92vMfGXEO/F6wDqhfBaiF4GxZCrqUF7wsXxuZm/zmi4hGQJIQFVjWHT1BTPAJ
	 2OvCJa01xFKQA==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-6353e91a04aso1218630d50.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 09:59:06 -0700 (PDT)
X-Gm-Message-State: AOJu0YxjA2gKZHbCG7biQD69MPg85J0tlMQ5weK1wKKXgfVYBK53i5+R
	kvCawzKGW/PqFpY4vKsRuG6pRC1Bkog3B1pjRCIW3yBq1sYrxWYlZAQTL0lNy7NNMsoDBvzBVOA
	+/v1Uzbuem7YiU4siF/f3eLlqvjZOsOQIr3asJPSpMw==
X-Google-Smtp-Source: AGHT+IHffrf2jdG0QubzZATUWq8z8rbvrILuS+Eblsz4HD6FLfr71YRpOlhUg8xiRz9k6e+kvaVSAVqTtaw/5eyGFSA=
X-Received: by 2002:a05:690c:316:b0:721:6b2e:a08a with SMTP id
 00721157ae682-780e16d29f5mr148880807b3.37.1760029145245; Thu, 09 Oct 2025
 09:59:05 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com>
 <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com> <CAMgjq7BE_TsmykMQvLMAEheCwgepQMb-X__TG-H7+CUVP3ttYg@mail.gmail.com>
In-Reply-To: <CAMgjq7BE_TsmykMQvLMAEheCwgepQMb-X__TG-H7+CUVP3ttYg@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 9 Oct 2025 09:58:54 -0700
X-Gmail-Original-Message-ID: <CACePvbWPsThncr+24sxCLNcd3Ez=6PhynFCKqcye2ivm92vvcw@mail.gmail.com>
X-Gm-Features: AS18NWD95dMyjMznCaDzO3lAf_mZ-rJKOi7LjVF3_Z64i5I6bxDpoRB8gK224v4
Message-ID: <CACePvbWPsThncr+24sxCLNcd3Ez=6PhynFCKqcye2ivm92vvcw@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm, swap: do not perform synchronous discard during allocation
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: mnn4b7a95zz8z8bjbq9k4c7ih8pm7dsr
X-Rspam-User: 
X-Rspamd-Queue-Id: 9804340002
X-HE-Tag: 1760029147-640572
X-HE-Meta: U2FsdGVkX181BWX3jVJZCkYinBTJ7/8AlJzO2E3AlUXDKvN0/Cwj2QzncoRaDVDJ1txWbuFexPLXhHf4jxxmb9ZDrlwtobgettmZl/qlSo+FxsfZ99bocfJOMEt9Qzc/rO7hrxu6CDcFw2KNZBFBZUKhX4Qzw62bPZYB+lEv5TCzN1Rl8aB3gajxrrvWFqhqw0508C4hnyZp1ueHEYzTihoDiwMlgm029UsTC0PAPyF6eL1y7hGhDtKmYAgMI7eyzcY8nRVMcUx8/oWdey69nEc9rDjaaKhlhcsZlmDt02bRO7oRCP/JzSHvlIjimQ91OtaYH5s3xSDWj4Ut5hcK8bm82D39AmcF8wCvvykNzRqHr7Yq5WwRmAyVEqU/QKfYs48e0pw2b8Dj4EtthQf7PevV1Prru03WNZIYh9CSH0FKKcMlsiv7vy7onhObDLHg2ZIEg1G3Ynn9uJut1dA9jQ6/n5cxpKUNxQFFJpARJQCPhBHAJJaWQ03uvo02RD0bl98N8RK920j1u862zU9JPWlr7zQ2hyYaK7TQ8HQ+L/qp/8I68q3yTc7yvWkC78Id3FCqz+K9mQHpzeTrhJdf5RRtpGkOb2QXHUQskCDIP461Ew1QRZX2riWTEYB9U23FihmnbT33CyXZCxhuHQjsmIrnh1jsrRcCLiEVKiqw0UYbA2wB95EixJUkd/A2OFlItRcGLl1+LAfhuRpq4gt1AJoRuw3kTe7mjClSMLJBMbTk+iZ2mublJ62FiOiOO7rOPb5K1Dlnla2sHWINOCnvcq46k4/LgkIPscRteKLsx24W8oLzi8lRIxCjbcW2v/vbskwT2L+GsBjwz6ZkA8wD7eEJce3MB00P7bQjCY5vRruF+KcNQiwWWI7IbMbBSGyfEsZn6GeWW46unQyEBoKIwL3Dl1GSa3g4tfxGpMohMBJzF1ghta0H03F4OceDbrbgGlqRbcaAMZpYTNONTAA
 paf2GGg1
 X/yloyUuFELAwSjMCxTLIrusBb+7gujolp390aXHmhT8CCiCQj6knIpqmxLAaa+jvNi9FZsLmzaUr7HvU2u5+2is/TPvbAEUCObw57fswqztaxYzf26P0eu3FRlQU9ddahfJr9xS0ZqOkX1RcTeNoGlDMzpT1UaWT2GSNL4OD/3VwACRBZZAWZdJs3tKAKh0c3K0LJr9ood5Z1nxmOeQ1YhI1K00m/VjVdlTyvz3IfXzlGWuq4dPEUY8faVs1jINowksRyJVEYZjz1Ek1RxCQc4px2ehu4mqiT5FZLxnG2WN0ABsVmrkVryK3WsQqik/iNhsY6oGz85w/3KU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 8:33=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Thu, Oct 9, 2025 at 5:10=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
> > I suggest the allocation here detects there is a discard pending and
> > running out of free blocks. Return there and indicate the need to
> > discard. The caller performs the discard without holding the lock,
> > similar to what you do with the order =3D=3D 0 case.
>
> Thanks for the suggestion. Right, that sounds even better. My initial
> though was that maybe we can just remove this discard completely since
> it rarely helps, and if the SSD is really that slow, OOM under heavy

Your argument is that cases happen very rarely. I agree with you on
that. The follow up question is that, if that rare case does happen,
are we doing the best we can in that situation? The V1 patch is not
doing the best as we can, it is pretty much I don't care about the
discard much, just ignore it unless order 0 failing forces our hand.
As far as I can tell, properly handling that having discard pending
condition is not much more complicated than your V1 patch, it might be
even simpler because you don't have that order 0 failing logic any
more.

> pressure might even be an acceptable behaviour. But to make it safer,
> I made it do discard only when order 0 is failing so the code is
> simpler.
>
> Let me sent a V2 to handle the discard carefully to reduce potential impa=
ct.

Great. Looking forward to it.

BTW, In the caller retry loop, the caller can retry the very swap
device that has discard just perform on it, it does not need to retry
from the very first swap device. In that regard, it is also a better
behavior than V1 or even existing discard behavior, which waits for
all devices to discard.

Chris

