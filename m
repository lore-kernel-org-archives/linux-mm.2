Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85AC9C44501
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 22:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0996B009D; Tue,  7 Jul 2026 18:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562B46B009E; Tue,  7 Jul 2026 18:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4518A6B009F; Tue,  7 Jul 2026 18:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12BFC6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:18:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 833B5168D57
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:18:00 +0000 (UTC)
X-FDA: 84963394320.01.8EA63F3
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id 91FE316000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:17:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="gJhkjSK/";
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783462678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKVmuDGdAmRQlt0M8u1BboB4FYx2Pt1l++bC+gaSkkA=;
	b=0LtMU4g3dwLvZoqgh7erT3byAOW+EyHK207reyEk2Q8HVfRHN6tUigSJOB3Kd0+5KlIYY/
	QzTuJXe8mAofZmTsHxVJV7Lo1K/hE0UmIJh+1Fdesys0xUOxnq64MiCRgJvyTz/jRwmHtU
	vaAoy+5VQXIY7Sknj3L3Ka9up53Di54=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783462678;
	b=E18HuZbVl3cS32+G/eGP+QPtFtmnnNQjVZROjUcd2RrL071aeC9FtJP1aQN1Kbx8eo8goP
	J6MLHdN8JuL+Wij2VXtVAGC8XxiLRFP6MXoHRsA7z1Rizh8Ln7d1/nhcax4y5lD7o8p39Z
	cOcO2qJEiig/b1Ry35XbyAK/bED6qEQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="gJhkjSK/";
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-474303f3c72so32149f8f.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 15:17:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783462677; cv=none;
        d=google.com; s=arc-20260327;
        b=OBijIZtTU4zIjIszdcEcuUQhVEmy66Z1Yg3wbg65WErkrgHSDefZ8OAIjnSWyYz1Sr
         hXPSG+jepCiMvbiFeSSc1Nw4ozQD992YH6v3zfXfXkEvToxf597H5ldjlnRoL20YBrJ3
         f73JjVhvltst8/yYrrXZ6oKcNSaFtiZ75OkKyVyY2V6ArvvV1dwt/c6hFtPaBnyBKyO6
         eRe5BlWBXKDBRWX1YnQRruwDzLUFWZZCRIidVzp0AjukymFggBFFz3po0TqU6pb8wUzk
         pLi2MfB7VKt3sn2mcRT4XX1J+dILuMbtI5sZHmdrr9QEJmKttiLss76VtdiD0KVWQdfl
         y0eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iKVmuDGdAmRQlt0M8u1BboB4FYx2Pt1l++bC+gaSkkA=;
        fh=Z4VwI8tmKUwDmscSpFcGoT3Qwu8ZGXRHAn3iCx5ATYo=;
        b=rN31URjcAsVDKI7BkO4Ocgt11yS1JpWzeOtW8tg1JTew6nhwhcjbHJB/iXi7XomHkX
         qyYCtMTOJFWUH7+QQ9ZQzx7M7NFf5HnMv3RKvS5XdbztBuvmqJO0ssYHQpsI1K9x92TP
         bBVN3YpEcKzINVQZJktQ/tUhPeDQCVBXKENx9EaJeysOFgTLqGkSLNeImuKoXcF4HscZ
         HwWmmjFMear1IVuMNYPfUY/tY39q3NZRudi3tY2iAiW2bN4KLxMT8//qMI6T7zg+PNvc
         K6BeAdDiBmKK+VYaIGzViXTBroC6XySNW1dyj7KAfK2bOF3kEo/cEbyLFRnk0IQih0n5
         nRSQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783462677; x=1784067477; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iKVmuDGdAmRQlt0M8u1BboB4FYx2Pt1l++bC+gaSkkA=;
        b=gJhkjSK/9WyjMBCyYdjEbTXruiLMCDd1CeIRpUOTuR2JGLuCZnENR1303+Wwy2EDUs
         KeznO63/mbvttEKvAnE0tibUzfjjxiWusNfOQqPpSUAeL1rg1JiGFkkb5bTPlJmZV0PO
         w7YatMnox1b5SnWhKVapOQMduIRrjMMZXIXXvcH49BRm4+9NDYMz7Aw2LmmWEHx3b1rN
         x1pMo2hl2034UNcdH8U2JUBxDHFaRXh3dbcrXwUJh99Wtu5DlmRIjAAZNZ3595QrBKfJ
         3we5LNGa1rFNoQbdSsDh4SDCXTLDPJImpe8vAHkX7wIu7cFn/USfT7QmXZCMVbOQ4J5y
         tMBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783462677; x=1784067477;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iKVmuDGdAmRQlt0M8u1BboB4FYx2Pt1l++bC+gaSkkA=;
        b=rx63CFCQDppHgcmpHul6N/9Ax7F8uiLyy1km1jJusXLD5Atk2oPnGiN8K0IJUQjmUu
         5z3ONkgIbN6CkBQ0xXrD4LNghmdZpVlQ8xfZv16jCRFlfQWvQvB8Vjb1HNsXaL2dzvWY
         7q+iw66qyZqzMpH9AkhyFzgAis5iEk1lbyoCGCLjp5D/ylnxo0NFIx8/m98S9dtkT72K
         7/fF3CCaH5nkp8sjgEU2xnVENdGXAZ0zCDG+pB3Y1+rDrBn8kusGktNYQYXqQPVwK2Y/
         X0JKQElPNOkOOhcc3cjs7PIwwP7qE8AGGzl/IrPvBTQp+GlV0bC45ouwvTf5nGtZTsLE
         HjQQ==
X-Forwarded-Encrypted: i=1; AHgh+RoYfNSkraDAo2ZOZVGcSjHjWHmDT4h08uebwIBg8hbQPfu7b2H712IFBR4NR6xtGO5ZB7TeGLF5og==@kvack.org
X-Gm-Message-State: AOJu0YxBSDyYX/1pBfwr3qRhyY4bQGhZjai6lC4GjhEXwEtfCJlreQGL
	T8Tk5B7DquSmfnsQVJNVa8VHNVEoxtE/O/QpaIZySAP2FbMHymvBEjkbI2s0xKQTPnz8dQsmT+E
	w1QKAOlNT0j/elh6skc0HD2liGkBdFt0=
X-Gm-Gg: AfdE7cn5AGwyE46UJD3qbMnseLicitDqe2LMyy/SPsiP3HLC3Y9XCxBt+uP8MEt3yKd
	oeVZ3VV0r57DasaFzcEp+sO5vjYNfBsG74c7nZQT1THXA+OUG/0nkJAcqH2nUXUmbbCfkE3a/1V
	4rFIlTFBaRiGizzn5Hpw6IVgjQ+5n2crSlcINXkPd6xLN6qKiAivFfMTF1PnNmi0Pf7WrCiUj1w
	m/MAGy+VT943R3fpDO5k59Xzq+jlPD4bqkW/y8szUoNZB+asDTeH5q0tdARHg4tfLVurXLkO+QM
	Jg9bZxqI+p6X5iCZNuUNAIXAlSuLunUR3Nw9Xps=
X-Received: by 2002:a5d:4112:0:b0:475:f100:3603 with SMTP id
 ffacd0b85a97d-47de6699433mr6674858f8f.50.1783462676816; Tue, 07 Jul 2026
 15:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260707073215.72183-1-baoquan.he@linux.dev> <CAKEwX=OuikFwr-miW+HKfnk6djMU8ehiTQPnfchFCyVcfefDLg@mail.gmail.com>
 <CAO9r8zO-RwWH8Xuub48FD6i+o0GSiwEkmWtyY9TfhF1gNx51Bw@mail.gmail.com>
In-Reply-To: <CAO9r8zO-RwWH8Xuub48FD6i+o0GSiwEkmWtyY9TfhF1gNx51Bw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 7 Jul 2026 15:17:44 -0700
X-Gm-Features: AVVi8CfLSXAGLb6BXSKH137TebniS890UmlTONF1mpnq6FDGxT_ENoj5hf0ba4Y
Message-ID: <CAKEwX=MG1rxNB5bPD622h2CuXD5svV-AjbHMZwdb-Ws4h5_D_g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] mm: store zswap entries in swap table (Pointer entry)
To: Yosry Ahmed <yosry@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91FE316000B
X-Stat-Signature: azc475wc6q7sojiqf3m5y6d1ns3aqwg4
X-HE-Tag: 1783462678-293440
X-HE-Meta: U2FsdGVkX19AVjq4BWJONrfHJF2VZAXbUzQ+CdCFSWP6xNTqvBD7jzr++/62FECPBpRNgHZtgMQNeaG9r9ZxtNH2+25qLNsyKSuuja+se2CKUJlBvJyl49vHiVDnZg6nvM3/vBow1L94K9Q47JpEoSoGqH/1fsbVMI+QZTUdkNLzOj1S77HvHaPMJnVJ6DasmgInlSxx36loYOHdp0g6UkBsQT+4WK44+6OFyPDrQ9vDUuOnBYX7LJOW49l8QuAKeulE+T85ZnrIMEsGUtteatLzqsEYP6bUooAhkyhLeuWU9AePiDuFQWC2M4aiXKrfQaOnA4On4lF7yU2/5bw92buAVhbZboRUn8AblcA/Gv61g4e7ip1MYdN5XmFm5RXOe5iHpf2j6yPgTJjQ4q3PfdPu5ng4x5r1dkA9XZCd5YRy5FSC+Fy8ugJfZnQYVXRWapRN60nIE8sJkfoQIDA691t6M+iCBKdHqe01bKdJhR8H//6kRIq+BHwz4IoWBsORdSZekyox3viXvMoZIf+sPk+a4xwgSdEv1z2+hFo+SX207y/Oa/FHY6sfysywnYaScRGIOfa+2d/e6cKtZakd/dm2d301DrVTh1pHDQn0AripuTl0E7JkQ5ofR14VF4T73MPAvMV29DqT5oB+fovkMP3p8rvDGx8MWWwnfQgRfd+hqXBJ+jYB1gJ9qpp7QF2fxag7w1lj+4eKBcfDT0shXUHbcqx1uNFdvs+9JhaApjlmWTjpAM5AU5098pqP+2PyF6tUvVTMEcVPCqwno0EnK6DM/XSQL6bDCZBMs6R8RJuwFUXz5L8tYph0iDZEUMB2WZBtuniLw4gv+Y0/9IXf/Rl+53Spi51QlRRkdgnM0cJsEr5TjG+RiC+HkSt0J2AnMKzeDJybNEZ6NXWzFzc0NJaWDzH0QiwNFkEfk9tBkxMytlr2HWbBqkOWrCyWQiP/3yLIREdeGv31Huno4XV
 lYLTQxPa
 D9qLfF3+rxGRSq93ZgZpxqA0HeE/YcnHg/NCgPgs60IOBxdaIvgTGHXoYLQpeVHmM+KqgZC1NAdrM/YhXnhsAA5doe/26rQqc6IlB/K0qYGbgRcBIXh4BTXT1BmkeDBSbUC5JhaJhb/x5DDVfmSvWfdXpqV/Ix8J4lWLIMH5yF7KHXA4Brb18MEKHdjnntASqRhBHG/i5I69cISoCXlQkRibp7fQQmoJXHG6S0QsapElaXpu7P0BCtOr9fIiuhzOcnIi1oRQEf47oNaKUcAq51jVlXNAhmmlmU4qOlKvLsXn5Afs5FbMizi0NHxnL4KtKZziEdtq91gSla3meLYZW5fiy1ljtPwadLIXKPXFaGugwXqviRzzBEaXHKz/f0Po9mlM6ucp2OcWU4gJXLnmMkwKopXl5eeo41zaQweKmOK+eLnhp/xp6+SBbUSnwGLmge7QS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 12:49=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Jul 7, 2026 at 12:28=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Tue, Jul 7, 2026 at 12:32=E2=80=AFAM Baoquan He <baoquan.he@linux.de=
v> wrote:
> > >
> > > Currently zswap uses a per-swap-device xarray to map swap offsets to
> > > zswap_entry pointers. This introduces an additional tree walk on ever=
y
> > > zswap entry access.
> > >
> > > This series replaces the xarray with a "Pointer" entry type stored
> > > directly in the swap cluster table. The new swp_tb_t variant embeds
> > > a zswap_entry pointer plus a entry count, eliminating the xarray and
> > > its lookup overhead entirely.
> > >
> >
> > Have you had the chance to review the virtual swap work (latest
> > version in [1])? At a first glance, it bears a lot of similarity to
> > this.
> >
> > We're envisioning this to be the future architecture for zswap :) Is
> > there anything that is missing that would satisfy your use case too?
> >
> > [1]: https://lore.kernel.org/all/20260612193738.2183968-1-nphamcs@gmail=
.com/
>
> Yeah this doubles down on the dependency of zswap on a swapfile being
> present, but I guess the goal is for this to be complimented by your
> other series to add ghost swapfile support. This was discussed at
> length, and we don't really want to have a user-facing ghost/virtual
> swapfile concept, at least not for now. Nhat's latest proposal is
> essentially a ghost/virtual swapfile implementation that is
> transparent to userspace, AFAICT.
>
> As Nhat mentioned, if there are deficiencies in his proposal that are
> addressed by yours, I think the most productive way forward is to
> start a discussion (here or on Nhat's proposal) to figure out the best
> way forward for everyone.

Now that I have taken another look at the other series too, I realized
that these 2 are really a big patch series, split into two. Vswap also
merges the zswap tree into the swap table infrastructure, and the code
paths are actually *simpler*: a lot of the swap-cache/swap refcounting
logic remains unchanged, whether the swap entry mapped to PTE belongs
to a virtual or physical swapfile.

With this new design:

1. Metadata can now live in struct zswap entry, if the swapfile is
zswap ghost swapfile.

2. You need to move the metadata around if you need to do zswap writeback.

It seems rather misleading to claim that the ghost zswap swapfile
design is simpler, when a lot of the complexity involved in this layer
merging is hidden in this optimization patch series.

If you're concerned about the xarray overhead, I'm willing to consider
the vmalloc array data structure. You can then graft the other
optimization in this series on to the vswap work.

