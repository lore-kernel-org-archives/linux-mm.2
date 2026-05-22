Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 629BCCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F416B0092; Fri, 22 May 2026 09:48:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66DE6B00A7; Fri, 22 May 2026 09:48:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3A36B00A9; Fri, 22 May 2026 09:48:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 889936B0092
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:48:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1CD3F1209BD
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:48:51 +0000 (UTC)
X-FDA: 84795186462.01.645158D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2377740008
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:48:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fssRPY20;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779457729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAdkVdHYlcySFUBOB9d60INI0VTqn7iPCNrUckiEfSA=;
	b=TxuRDaPqZikViL4h+Pw2r0OC3kXiCoeCUkj6898QDiM+NOrWEdo7NRbiNdAqP1BK/RnO1X
	6VWW+tUmxN1o0C7rs1dZXntqGir+0DLrJRk5i3fHjezi5NIa2gax/FfwupDSWx3forwix+
	qdiaUhz+E4/ros9dwO9l8zhpoaRy5l4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fssRPY20;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779457729; a=rsa-sha256;
	cv=none;
	b=0zHpVfDWTsa6bHRggvgbP6RIsR3fl+tBQvINRu6hFn7HKYElUNnafvwcpokfatr5gTigKf
	0+g5P/GleK/PwuXbGnFVmgPgGnFaQBdJZVhfKULxo9A8/zzlFtCL325Jc/z+RPfzW/ajCB
	x6M03nvfVZJNTuVPA3gA4KFn2B29UO4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07DF4444E2
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC561F01561
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779457727;
	bh=XAdkVdHYlcySFUBOB9d60INI0VTqn7iPCNrUckiEfSA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fssRPY20Dyxz/cYAZdo1qxjF95zNf6DPwfqO4+J6MWEGH93cmB3q0+MsnYtIf4mOu
	 yb2F/LO4bgXDVVZtWJM+4ct2qMqAk527UXL9PHuTUlPYGw8oHZlNwVpv2sEzAnkcrW
	 rYoPk72XF8cMrkAdvU+bjT79H8QBrkkrFnU3POv8SQ9y83JqXAiA2qGn+LwaCE7CbH
	 mydY4KMHGknk/wbzPm/k4VXT2aMv/tt5hKvMmQYuGoY0PrpI9XAnuVQcyxvRoLuNWj
	 8uaBe6X3EksWrohYip6eKCS7TiRDlXSyUEYD1+I0+oxJ/3PXuXltrCZPf7+nmrAZEo
	 4IW9Ggc3VmhZA==
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-95d439bd3a5so1813238241.3
        for <linux-mm@kvack.org>; Fri, 22 May 2026 06:48:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+EDQWREu8Lh10CDjE76RDB8t9FTqUOAiKmOrD/9UI6jDDzKZMFu0dHSVvM8hIQTaksBp0Z03gBiQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0XrNrgNLnCJQmtCYRlkznurPL+TjMnoEYrDfrAsKzgJr7uW7A
	Tg2CubLhElqT28nBVdiyFge5GjFotVyU6Wee+oWA70gGNBBGL9zJbOtGOrQIUzOIU7ls8WqPTIR
	bBh9FUh9FbmDnflV1I9RqeJxGbTqgPAg=
X-Received: by 2002:a05:6102:3f8e:b0:607:97b7:c283 with SMTP id
 ada2fe7eead31-67c7fff0701mr1602325137.14.1779457727053; Fri, 22 May 2026
 06:48:47 -0700 (PDT)
MIME-Version: 1.0
References: <ag4kj84EcKqamdB-@casper.infradead.org> <20260522023305.98223-1-baohua@kernel.org>
 <ahBVh4NM2uoyhPNm@casper.infradead.org> <CAGsJ_4zQuJx1reJxgV387Gh0AqWF0KdoFn9KahQ1BNLPRm57TQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zQuJx1reJxgV387Gh0AqWF0KdoFn9KahQ1BNLPRm57TQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 22 May 2026 21:48:35 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zrm3sCp8Uz0Gh+sAwRcdtNF8rDLqX250sFVG3rZy9HNw@mail.gmail.com>
X-Gm-Features: AVHnY4Kzckk2STAPsRlCTXxCXlI9-5Kzu1EhehIrviADTgZ0pSseIwikwC-HrOY
Message-ID: <CAGsJ_4zrm3sCp8Uz0Gh+sAwRcdtNF8rDLqX250sFVG3rZy9HNw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, bhe@redhat.com, chentao@kylinos.cn, 
	chrisl@kernel.org, david@kernel.org, jack@suse.cz, kasong@tencent.com, 
	kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	liyangouwen1@oppo.com, ljs@kernel.org, loongarch@lists.linux.dev, 
	mhocko@suse.com, nphamcs@gmail.com, nzzhao@126.com, pfalcato@suse.de, 
	rppt@kernel.org, shikemeng@huaweicloud.com, surenb@google.com, 
	vbabka@kernel.org, wanglian@kylinos.cn, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rywgd9fsokegb4ir7y3159uzxahpsba6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2377740008
X-HE-Tag: 1779457728-72669
X-HE-Meta: U2FsdGVkX18UtB3pp0zf6mkiQBPy1WMszHXgSbH9kcDYFw++mzsITDYGzO0wXFk93uxYlkRjCDzls0v2vsS1Y6+GrtsstaQX4w9W+dVyCw+37Dji3XNWcZ6MN9TLNH7LuzA1eoD1ION0sXrrIc5DRbMvms/sXNra3HtRC5QfVNZv/tGV9ZH8w15GUjgYB8aRkLkgpA48f3cUt/B6aLPWCD3E4/lfJdBpN6EmMMHWz+m5xTMWjhctRCEjfFvfe4kW3ijPh3bFf/TL1n/jMIMTM2eVRTIMGeuIyaqQJa2nh5KL1PcEonVhkroMAK7xpW1nIpM/HOH6AV0ADbasehZ7CPkBJrk+WIXCajydMbFhk7gch9NJNMpB1cxLsX/y3mlnfIO4aEUbRRqPz4ZkkkSjS7ZzeJs9RRUbFn2dNq08Lu/rDDeYmMsGD7xJAFmpAFEMp6/eo5NW7p0Ydq7+jQXfRpK5vRRZX1AHp4klJhnnhNsASuPetc/H5n6o4Y4secMjIcIY0dnl9wp4W8PfRawEgxEESkDynawCQH2xFOG2Z4zfSJOavMuEeOrEjyOEysKb991mPJwXWH6XqqwBXuxqo4W0k7Bdx+c7I5bEjkoHp729AJ29Vjj1EPEps1dJ11lyvvfF1FhPaYRZigpb/UKo3Lvj/tnJqZItWCU0IPKAijXQfCLaqmM+pVkdab62bGX1d/WYaNHNMPuZJ00HoYMOsXJITnICH6FwBkAXNCKaOdTsahik8XmuUSkZHC2dMYnR8lBf8ecWbIznSETGpBFVBnU2azt+BpWS/Q4ZFaK/9vqmOm37fWE/qcAxCBZc5ixJVDWElf2R446eL6rA4e8uoo4nffORlLSLHbmMAU+lXIyiDaQkk2WAHNa1o1DnETjP61k/ncVCzMiNWIJY1fDTZiVFnw7RsoY/OiOUSW+AVSWykAgXIbQH6MW42zKiMDEssb56bk4VyMLgoqNdydm
 bygf/QnL
 pNb5uZpTDitPgPONaJH5BJ02fGGU0XVMfiVWtFeVsIaSnlbcSI6ojl+7AKp/Rcz/PSvO1mZp6p8+nwYfROhPh66nR8pMnCF93fyVEFDO37j65GVEQpIGaaW/7GF7Tcx8x/IkKJc2jgMMYaCsn6EMS4GzmhbTFMncEYpV3ngnt8n6zbdzbZ2hvMcRQn5m5jrKwg9OEjRuJhQN791I+voXtwqDA4/04UPSKsxSfsNQB5XGpK00SUdklXPZBjzRA6iqnggCn45wBCBiQZx/EYjFBS+wUGaSZ40iVVvGbatxLrJC9Y6Upx2zGZHKinrxGcEV5DviFmB9yHlMCXBN3JD6AqhcJ1hMN70KRIz0/BaIxXG5FvHwxU76mIGmAhEH96VjXd5U5Mc8Y/DuYULsLxUsZ4Z7TbMY/7tqvrSHqjwO/17pIQlYN1TTumlck1KjmCYozjEMiGCp1JvgD1gwOmGcBYEt3nJ+8oaMxpJzxXHMwjParTKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 9:36=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Fri, May 22, 2026 at 9:09=E2=80=AFPM Matthew Wilcox <willy@infradead.o=
rg> wrote:
> >
> > On Fri, May 22, 2026 at 10:33:05AM +0800, Barry Song (Xiaomi) wrote:
> > > need to touch `filemap.c` at all (probably because you are already
> > > maintaining `filemap.c` perfectly):
> >
> > I'm going to give you one chance to apologise for that.
>
> Apologies if my wording caused any misunderstanding.
> That was not my intention at all.
>
> What I meant is that filemap.c already has a very
> solid design.
>
> For memory.c, I had to touch several places for the
> blacklist; otherwise, the kernel would hang.
>
> But for filemap.c, I basically didn't need to touch
> anything, and preliminary testing shows no issues after
> moving it from the whitelist to the blacklist. This is

Sorry, I feel I may be causing some misunderstanding
again.

By "whitelist", I mean I used to allow certain cases
to use per-vma retry.

By "blacklist", I mean I am now moving to disallow
certain cases from using per-vma retry.

Right now, I have to add several cases in memory.c
to the blacklist; otherwise, the kernel would hang.

But it seems that everything in filemap.c is fine so
far based on testing.

I'm not sure if I've explained things clearly. Please
let me know if anything is still unclear or insufficient.

