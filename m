Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8424CCEBF93
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 06:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6B38E000A; Mon, 17 Nov 2025 01:57:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE868E0002; Mon, 17 Nov 2025 01:57:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FADA8E000A; Mon, 17 Nov 2025 01:57:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE428E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 01:57:53 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E3A671A0BF8
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:57:52 +0000 (UTC)
X-FDA: 84119193984.25.CBAAE03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EB4F9140002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:57:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgEn9zes;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763362671; a=rsa-sha256;
	cv=none;
	b=DBRE0l4tmOli2WrXpXshMqwGCP0qMjsRK9TXgQkMpb+26hzBShOgcthHoIh/9Z1SGqds8d
	CdlZFvu3chdzDHMQjUZGFiDKZp7bFKXh03FeFTrsALpYGHqxsWRGFaymx1YjCFS6mnSBZR
	0GgS/yUvc81aDaibyLsd7nRBfdQWyC0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgEn9zes;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763362671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJojd+yHHb22iFQkkceWLmDQfdkENpWFJdPZtgzdX/E=;
	b=GrFMVMBOkT7loO/iVrKr5HAbocaga13I9Ex1sRQkGO0gzr0QqI+pEAKYAehUApyNPU1dt+
	mFgVzGU8uF2TBcOGCkL7zCBbdkxd1fZlhAp+FLBMfngodV6iwbKxMzJNGOZoYw+SlIt1n0
	Ol2Y/EOJFQgjEXFlqmgJ6xXxBG1Bpdg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABE5743D3C
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9B8C2BCB2
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763362669;
	bh=QFHJjbWXgZ5FLJu59KKPwWK2r2/tZ86nN8Ql1jm9c1k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TgEn9zesgIRCkrmyUN3w5JmDr4gYs1GGuRuGQO48gd4V4EjRN6C5Msq0MIsDUo6Rq
	 2T0q2HNtfFmfieLN040ZdcCSB4+kjAMkf3BfT7kLJM0ij0ZRLTTd0t2LhfRgXhvOTX
	 wUcRiqerY+vy9iUWThAl5jGFg4WLdGNLtkeJfhPgcrg7QanuH9wVDDqgpx+sPiuM4B
	 NP1xZcNj6i/hm/oI70m2A8SVfKRtW2hkYh24UkzuvtIqPyIGW1tt5nLb1JnJbnurn2
	 r3gVqYVpX/Xkq0ye5fGg+mH7BgewPI9K2xfGVaCysRYj+fSoLu6K1b2/YWeOqGRcAp
	 b4D8ocqGafeBw==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b737c6c13e1so277094166b.3
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 22:57:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW5dcPrdAiXUuCb+LjoahXzxBoYQwyes+L9alqVCVTBwbBLp3/vFmcjx1LbFTOdoxsGT8sFdTbCQA==@kvack.org
X-Gm-Message-State: AOJu0YxeF7B5qlFd+5HbuYm7HJ9CSUdy25db4TDKgMu6anqNS8Qb/gYy
	8lDL30cpXQKZy41zImplxtTzqN/FfaQ7xvyCIsRnXlcE7WIzxmjrxC+60IgY1pYazKtriyOD3nd
	d0WOL6pDzeuFVat1w/ooHayKd9hQi7/U=
X-Google-Smtp-Source: AGHT+IGu0YWlJyZo9sBFqmWx/8Hh3O0yFNJjWzg2iDkfq3nhyb14i7bYZtnnHW6QkMeJqt8H8KA79+YcCaKiwhmN4Fo=
X-Received: by 2002:a17:906:6a08:b0:b72:599:5385 with SMTP id
 a640c23a62f3a-b7367bab9e7mr1170101566b.61.1763362668048; Sun, 16 Nov 2025
 22:57:48 -0800 (PST)
MIME-Version: 1.0
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <146b5a0207052b38d04caac6b20756a61c2189b3.1763117269.git.zhengqi.arch@bytedance.com>
 <CAAhV-H6HL+mXeuLqgo5BOVBB0_GHTUmn7_7NTzdUpLX7NbuQ5w@mail.gmail.com> <8fbeb3e8-7c30-46f6-a0a4-289efbf45ac0@linux.dev>
In-Reply-To: <8fbeb3e8-7c30-46f6-a0a4-289efbf45ac0@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 17 Nov 2025 14:57:47 +0800
X-Gmail-Original-Message-ID: <CAAhV-H73vNhjZqsDq0KGJD_PC2LtM39XAG-aZtvE=tphrQ8dJA@mail.gmail.com>
X-Gm-Features: AWmQ_bmXPoa2u3pjJaGT_1E1BSy8DLhNHegRD0EaZ-4w9eHZIwpki4fOuwGYKs4
Message-ID: <CAAhV-H73vNhjZqsDq0KGJD_PC2LtM39XAG-aZtvE=tphrQ8dJA@mail.gmail.com>
Subject: Re: [PATCH 3/7] loongarch: mm: enable MMU_GATHER_RCU_TABLE_FREE
To: Qi Zheng <qi.zheng@linux.dev>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, 
	peterz@infradead.org, dev.jain@arm.com, akpm@linux-foundation.org, 
	david@redhat.com, ioworker0@gmail.com, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>, 
	WANG Xuerui <kernel@xen0n.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB4F9140002
X-Stat-Signature: jc355qj13k8a4sjnfzsiu8myyht5d9j9
X-HE-Tag: 1763362670-459917
X-HE-Meta: U2FsdGVkX1/mvqu5iiY1szR1/ZjS8gYSipo0n0K/5AYvdK8nvmkjK629aKVj1na2fOHnapIIP+Hyzy4cafFJw0d+arEb6gReZZCwtLLR6BbdfEXkeCO7jNmMV9b+IEyLsVVVRRRY/b7npgCuHPU5KBVWET4YVW9l+X2GDFOZ+J1kg617dlFaCP/x/fzFs2ge0ym5i4vkJv/TZrLyaneWuWyVjMqYmbjHmo5S/sb3D4ZdFxnfio2heqqg22AHW+SeKTStu4fpCOSIOa2lMwz1qJKxaZJCuIBVj7oGewfKnnrz++IqAW/iMFVUa8oUcKjumD3wgbco6CWzdRp+k6WIFE6s3TEHeBSe9YRO79i8MrPsnJrD9ecKUaX+QNxNA2UI95kQZIHrZJsr/YxhQf5vEsoocItfheGXoCiTsl6ezM58mTI5k1V7r1HEh9iVGp55kVoZFA99a0ZeyrdX9liYFgY9VyhArfhS3OF/Dk4ZKzEjgokFU+TgOhZODNpHlLoc3wLdEQrFtVLzLDWpH1abUYn90ZcrOJI2iKSsE0DtxuYPsqeTM5JRloynPu9iwGRR4LrV+tqq9hotsvf1PIuuq9bBRkHCguGxZ5EpvAupwhvkS9uLgjET4hcL9xQkIyhRXLgSi2QYnokATrfvttluurWE5msl/O1UTX8h0Hz7NJMW2yWFVKeNd4e6qBCu7pnCj0Nv22MrnNGswiFcaDpDOFEu9qiqz9b6xWFrOrSfaJ2x9zxCYrkaFZiYdqTqyBirGSdGZvad2atu6hgJIppk1ATYgGZa6w2htV+h1REQojdJh2sVglAtj6wbXwSu6rK1l0AW8t5tBPyK0c5dVhN3ux2OnEljwPmKXIA+3vFiitUVYjltturjdbbvs3bV92DdH6ZCiWFoMGucCS5hpRCri89HjJNwt3k71x+MBrR7GVmfDbYTnYKogOzHaGCrZmjcwtJcWKwP4AeWiFFUGQW
 8iHuzUIc
 IqEOff56+uOzZlx+Zg1+VpKst9IGzZDIjitCUrup4Q7WzqRADqrAv6IEgpoAqYGXP010UxW6omhTUXsB0qr68jVhoxgssz9c7Wh4Z0JOAMw/GeQw/H5SOWNQZKytuJ9RPFc4k1JNVgKJEzwEl8em10zibzRW2qCAXidHFklwBVy9moUc1p98vAh/wOtV4SuDsTCfdsy65EQq+Io51nJ0znL+yg1YsLzJ1rDo5tTHT3eEZ13ptg29hI40CEEtZOFh4365ZuxyYGQiUJeR/rbE5OSGvXlAB8dWjHW92AwhuRbQMuS03Qs4j516lNutaNidEV71VJcSpbCA13TA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 2:42=E2=80=AFPM Qi Zheng <qi.zheng@linux.dev> wrote=
:
>
> Hi Huacai,
>
> On 11/14/25 10:17 PM, Huacai Chen wrote:
> > Hi, Qi Zheng,
>
> [...]
>
> >>
> >> -#define __pmd_free_tlb(tlb, x, addr)   pmd_free((tlb)->mm, x)
> >> +#define __pmd_free_tlb(tlb, x, addr)   \
> >> +       tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
> > I think we can define it in one line.
>
> Do we need to change __pte_free_tlb() to a single-line format
> as well?
Yes, there is no 80 columns limit now.

Huacai

>
> Thanks,
> Qi
>
>
> >>
>
>

