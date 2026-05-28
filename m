Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3DD6CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 11:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D117E6B0088; Thu, 28 May 2026 07:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8B66B008A; Thu, 28 May 2026 07:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26AA6B008C; Thu, 28 May 2026 07:04:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2DC26B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:04:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73E6C8EED3
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:04:13 +0000 (UTC)
X-FDA: 84816544386.16.F317FDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 90FE8C000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:04:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YAxJ7AXP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779966251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MwFyBKCNZLeDFd9n41BQ9P6ZG/9hatchCSvbrPdytME=;
	b=4e8hdIi5GzxPdnZ7EeWYwBN/rTVWiJVzRoBnizrzoq/h0sGZlx4rNhHCDAhAsjS4vQ7w7p
	L4xkqriYLHuXjzTHHpS/iFL6GNPeRl8StRNKhF8AK2DuvxQ7c5jOM9J/BNmo2Jb949FFlC
	GyP8ubV9FX3mOgZ5s3NIPc4A0Umo/GI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YAxJ7AXP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779966251; a=rsa-sha256;
	cv=none;
	b=Liq/rWrderc4v11jB/DOylX9FIxQSu4NXPgO/g824Y9LEcYUWG/vBtVZdKtV5zmOA9NTtI
	ZrMYJV6VyMPakP46KCMm27z5UTJR6WJhK/9/BuT1byGr2FmtveFP817bY7+IU9a2HHyLbM
	uBrT8rK28DDdg1QQhX5kZCDhDXjMuOc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE57B436AB
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CC31F00A3E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779966250;
	bh=MwFyBKCNZLeDFd9n41BQ9P6ZG/9hatchCSvbrPdytME=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YAxJ7AXP+WXgC1h3dxOnEWZLnXnE5I6hCmlzvwRq97Zl7Sws3AbgZq7mRwFYqbPze
	 La3xy42vSkehCWEKYoUrohGOlyx0vvWQ6sEawheBSF9TZhiSqo22OaZl6w63+zPuGa
	 nl/sBiOPDe5pjJq8R75/xiprEb5koo1lx7ei9W8oZy6hq1mTc+HOI1PcbLc3cUzllB
	 f3ONRVPpdMHT2nD/Aa1Fyubl1xX3ScprdE5W/rkb2Z/a9NQtKxuSWyWUNaMdcjaNq3
	 JRpBmEY9lbS+229yGJLtlCQpOBChGRKs9Kq7JYivX+OB+e4fhmaqjdWG5PKNtmuOsZ
	 DqCY4X27XfkRA==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-90caad2e944so1282162685a.2
        for <linux-mm@kvack.org>; Thu, 28 May 2026 04:04:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+u9NkhqFH63sxetzPVznFPWVhH1wr8mJpq9iD6+9LyVwg1wVphgMNOYlK9XS2yptemqzu4Dc+08Q==@kvack.org
X-Gm-Message-State: AOJu0YycT30DUZ7ZRsUw7LX7cjppQvwfTVL/c7kFxKR3T6biwP0Mr12v
	33gIUGGFHB0a+WA9qIBZ0UXZZnyyMDb6F96fJCNODtiu3ZYJw8Dai8YVLXMb+jmI4fMIoH3Vmt4
	agLQp2/GIX/3kWV5rInLSdADqMARf70I=
X-Received: by 2002:a05:620a:319c:b0:914:db40:9be8 with SMTP id
 af79cd13be357-914db409fffmr2461384785a.50.1779966249940; Thu, 28 May 2026
 04:04:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260527085622.1298437-1-zhaoyang.huang@unisoc.com>
 <CAGsJ_4zVu=XooHPzOVtNRV8iV0CEKM0rBwqUBBxfoxiZS-g4-g@mail.gmail.com> <CAGWkznGmDtr9-PaH2+2kbrpe-YZ7w70HpzyH2fzE5u-3MZ+ouQ@mail.gmail.com>
In-Reply-To: <CAGWkznGmDtr9-PaH2+2kbrpe-YZ7w70HpzyH2fzE5u-3MZ+ouQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 28 May 2026 19:03:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z_XfenEXQi_2dKLzrU3nBx1RnD6fvEuwgY=P6a2Ka0TA@mail.gmail.com>
X-Gm-Features: AVHnY4JXo_53JgjVCO4L4M4Phn6V3bFk5Z9XfeTCIm3H2uD0PTW2GB8VUhO06hg
Message-ID: <CAGsJ_4z_XfenEXQi_2dKLzrU3nBx1RnD6fvEuwgY=P6a2Ka0TA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/mglru: improve positive_ctrl_err for low refault samples
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 90FE8C000C
X-Stat-Signature: 5r95yfkng3n8nkaj74j6jt19pi4xpa1w
X-Rspam-User: 
X-HE-Tag: 1779966251-832322
X-HE-Meta: U2FsdGVkX1+jMhffhrESirTS0wnjpzOjR3+p910HrSiDNvf07QQI5rANAPVblN4ZfNZZ1OGD8oejXgGmGUWLl7fgprzfVygxI5cmQ5kXGCMqIsGF1tJ4cXpENTp6kb9lsA8itxIIvkMZD8diDIGcGsHP/sXcV1RIxlnwrYqlzSAoHoSRzS7wcaJC3xbCkYuV8epppSO6cuTVMCuvTgjYpJIuCt04xPwiLrWAGLPX4biX3iQCtbA/Ma7zywYZ89DUwRcgYlpQUZtOFUI84ZQKqj+hBoFgxvHixGUT+ksQoHzy7FPKoLH8R4LbbtHG7xbSUGUx9e1TdoE4v2RIlPhXR3bmcuRXciH/xubT+efHRTk9MVgFjPIbwauXZHU3oc+r02RicFKOSFNje54VD2FlPIWLnwmxgmoEfg0Mwg5dHjm18bBXka0i3ixD5PqgBSKquSC1aAt9LrVlG7i2e1nZYebat6dCsLCxIAPitCTnvdep29aaCtNK+kHUqnWu07abwEgZWAX4tTpXctXzypUJkXFSwIieGJCUk53VntLOhhzxQxKl3TSKAf18PFC4xXqLsKzi9hq0y7ubDXJkJNoWtFlZry0DSigpPROSyWJ+n72ExDBlj2aFtcWdEChAinkrx69Mddruc1XoIMKHS5JumBCLS7yMdT2QdfoUqnoJHdPQo0wZAUPvng9TPxnsqPLLbTns6j9xcXja+0uw7SJcr7+3Nst0R3PRIITskZQrhM6X4jfBEbwM+cyu/LzohlD1iFz3RmUCJhlmYQSRFj1MmFaO63//Uu+isYcHhVQkFVvMbYP7k9y5RUMmYejnU231JZp4xusGP7WU7MHUu8cAGRM/cntLL/DnGdWt7mNVHPbLU62851qbP2NoiW15OzywrAPwJBC0dwBR2AYSo/6kOvzY+aCgyuPBygFpX7lUddrP8ZyrqRaLVbW0H7dGCbL6Jb3ekbaeWulPYn0Y5GQ
 vJzYokHA
 f45Ke/13b6OedQNgpf25UJohh/Zv1IQgvNPB9EPq9QiU8c2ZnCv2GUFTGPShsjiwZBpltjS/sKuHUe3SM59gTGTlpUcGAoyh0cC1Ri7PXBs4vzpKB8s8TRVDm6CQmfiPDwCHFkpagOgYjneMOo9436vKFQObJToolxWHiNtk/VzkmvSB2JGXiP2j7Y8Ujhb9W4F32z+ySrorYGpTdkPm2WZdMoad3cD5Zk8xQBPFEaDsEmzUI00q0TmUfSRdOjzbRBQswGj/nzzyZHkTatZEm3aHAlNh1fyEBr0KY+dF8eZdCVJn9LFfAeQYhZB9Hvjp0ldVkzcueQ3b7qOsiyEO0iIj+p1HXuaA9BaGk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 5:36=E2=80=AFPM Zhaoyang Huang <huangzhaoyang@gmail=
.com> wrote:
[...]
> > I assume the new algorithm and the above comment were generated
> > by AI. Could you rephrase them in more human-understandable
> > language?
> The code is originally by myself and updated by AI. The main idea is
> ignoring the PID things(refault rate) when no enoufh refault count
> generated.
> >

OK. Could we have more data describing the user-level
problem this fixes?

