Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9900DCAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 12:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3E3D8E0017; Wed, 17 Sep 2025 08:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16368E0013; Wed, 17 Sep 2025 08:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2BAE8E0017; Wed, 17 Sep 2025 08:48:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0B398E0013
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:48:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9903F85F01
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:48:22 +0000 (UTC)
X-FDA: 83898720444.28.AE8D8E6
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 79DD81C0014
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:48:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NVynGvNN;
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758113301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzoJJTaUHkHZHToYowEQCZnMPpDM4R66Ou5zGDbIBXA=;
	b=7C46EvUx6UE2RQCERvJAhYwxS/LXkKZ5al4HbmjGI8lSKHKSufUz7osctVb1Mn6lO/y7XB
	MZ7gYSgqY05086A9mGwj9DrXabYnG6fRZucYEY/ZxfyzoZDeR1iUCngYHKkGCnKSVglABG
	qTCSWFT826seregXoc4JEHR4/smS8EM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NVynGvNN;
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758113301; a=rsa-sha256;
	cv=none;
	b=rzr8FKKreSs8H1ZmnkrWy0VaiHLUOi8V3mHi5r7A07eGbyD4ENbcmJtQk0QiQvfhVjfGOH
	pI2PtH/PdJEvBLwixVGlcPO/sCjyFzzf+sS3DL3ViTEfhKdvAHSyZEZ1ygZD18DPTdvT5Y
	D39+6n+2LVWa0aFHyFe7It8rxAR78tA=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-62f1987d4b2so7977932a12.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758113299; x=1758718099; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzoJJTaUHkHZHToYowEQCZnMPpDM4R66Ou5zGDbIBXA=;
        b=NVynGvNNJeXf+1sOwQZDYS9bF197VGLCJOGgZ2LFze0iDpW24fXlDWlO/3XVMpcCMr
         Q8u9qq39nOx4I0t6bmioBBQLV2c1Ab3boC483l6hS8T9+SGhQb9LFEXuUJcjbn3bCi8K
         1BbnskkRCFGTNR0nh2ZtuEWYUn6aGLNYn6qSQvCLcNdGuo22mSDu+KtRAZdwTQRTLHJG
         H5n7Nop7IYLN4m71L5HHkpKmtkRQjAhlk5fw/lC27eoGN0Qyt7XDzls1lj6TLTumDhOO
         3+PGvPLMse52s+onkeGkIiYCR5XOFWgCUmFtebYszek5KmsFmLXL2wIHBvdujZCyCisc
         +vWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758113299; x=1758718099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mzoJJTaUHkHZHToYowEQCZnMPpDM4R66Ou5zGDbIBXA=;
        b=JbwYO5xcwbjgwPLp6ieMfRhOwRUQ5EKR3gk1kTqd8lJOA50U2DSavaIJrZTAo/EJs6
         JZ6Y/GwKbgMWke/UTqPvDYFFawbUuk4KSAsfsqLdIzDT1x/qbWAAgBRlcA8N72ZHtxKk
         8rf0b/jU1PzXVM/9fWLXcVs8BL1AOvebzphLPt4KvKTWAHEYq6p+clpZWFKpA0NOroNe
         BqDjilHmZ7veBg2HQg6cCPQHNHoVigCTZ9DMXID5G/+t26OrtQPstqpbbad/0hL6qL+h
         j6f9q5S773ymtDHW8+PUsVXZHlq0hUVptmmdTyNkzGO1hUakMHvmM7VwtbJIn8zYEGu4
         l5Dg==
X-Forwarded-Encrypted: i=1; AJvYcCXXDBFRTUZpb3alQdzan963UQh0m14v15cTd8m8i/6Pv1kPhzXAOdqPT1W6MHmyNqBMuoUbrYiz9g==@kvack.org
X-Gm-Message-State: AOJu0YxWQDMgAxf3KLenNX6BMEnKit1IA1brwas7BI3IVuDeYjS8IaHV
	d0F2A2WApUAJs/KuNYhCItcDxw/tfOzbrOTbG/qL9JBN/zh3Q5Exs1Rl58QOtNLJYwXoXljv6O5
	iQPDY+eCraoM+DNdHJYfmx8mppjn/gDpFnIM+WdJK7g==
X-Gm-Gg: ASbGnctifgWZR53xrhqyMBK7f+RUbbgr/U86s+j6/jVzI+gXpiDloLcEJX4DBYfX8rW
	JK2BZ7Gs2wc8gVy8iYbiItXNyd6VTtv0LzFBPn1QfpMBD7Py9AFIYrbyRwTfdNh7vgwiinMtr/W
	YSq9WHkHKHJ7a9PrjoMgboUxjnP8yUavBXd6b+NdtOpRmPhumXbzqWEIACP169/JRcdwjra6XpR
	eUV0Is1L1yWvZHarG4mmmXBCMcKfFhPUtDC
X-Google-Smtp-Source: AGHT+IGxLydLDJb0VdYSaq6Lk+OQ4q1aEqSqriHtwbCsy+e8WDZN7b+TQjeMCOhaF7PVT8Bkog08GU6BKCkdGttIS0I=
X-Received: by 2002:a17:907:3e27:b0:b09:6ff1:e65d with SMTP id
 a640c23a62f3a-b1bc2778d71mr257244066b.61.1758113298807; Wed, 17 Sep 2025
 05:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com> <CAKPOu+_B=0G-csXEw2OshD6ZJm0+Ex9dRNf6bHpVuQFgBB7-Zw@mail.gmail.com>
In-Reply-To: <CAKPOu+_B=0G-csXEw2OshD6ZJm0+Ex9dRNf6bHpVuQFgBB7-Zw@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 14:48:07 +0200
X-Gm-Features: AS18NWBvdouXUe1Mvci0ghTgQgjd6tzI9CRI7bVed8MohvrSsbtpRmVZImWkHk8
Message-ID: <CAKPOu+-xr+nQuzfjtQCgZCqPtec=8uQiz29H5+5AeFzTbp=1rw@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 79DD81C0014
X-Rspamd-Server: rspam05
X-Stat-Signature: 6wfi78zsao5cggid8wsxdrgtzg6u5f17
X-Rspam-User: 
X-HE-Tag: 1758113300-696214
X-HE-Meta: U2FsdGVkX1/Zm6F0+s+Zqzkfh/v5C+6g9MfsH36S4e96lcS6MHwkADEBbMOW8TmBQH7L4tafmfZrusd3boYrjXOEHWTV33Ec/v2e03jDYaEvJDdh9ywtSFSSD4MejhcuQDCjbib6tgJ/nEvr5T0xK7Lq1BbQ0J78UTpefYigCEDVu6IRh+A+s6weUfdRqpoWdPNhxLCuYne64Z5k2mga/VKM1v1jKx208bZrKbD1FUrtgzQ+VL760MvOr9otpYNYwwAfk/DLtRc9bk05XTh1qHtU1ZCzCVC7XyXUDNEbp2y0JIWZmo3LOV88Y0uzJ86NlU8pJwi7qtqcYNC6uNV0hclsWucqcKIfd8wIx1px5fgrEU1PHR8bHtG/wYaaLjoPay36VStfPMfg9xauSVBZPaT9qKdeGtHwk9kL52bnx8BGNjzTO3/LzttgmG9u3IJ8EwVsYxt5P20xLt5qKt8QTFSLRZlRKxnEleEfEwfRop5bzxrhvBwX81sT5f8UNiWkQ4Ltc/XSeDMSapHUgVyKvZ5+Eyp3T9i2oe3QYiPU21prmRJoTjVJ272tBg9BxlD8yD4n/e5Z7ltbMSG1C4+TRyoyVDaXjRwyZ+5fCgcN7nr7yPK2z+dMHN5tqMrMzNWmTgvTZjeo5E7ZGRMQcyxZH5z/4koxSxVL9seWNS6pDlmxybMFxPgFecyOseuyg5K/VMMKsI26l4kAjXPq+3Gq8b7me8NifOtS/LOwfiqjivhi3ZhHrmqM5Yn3ORNpxRvxRO/0YXJ5UHV5AcIO24djnHlaRPHLKQWlQMhrYAKXvIPBJN31C3arDJNbR1S1i3Ba2nLvR0HZwIa87tXJVbcwywQVdlQYmS++gEltRTCpvbwmcIozplyj/6JXGE1eMkixQ/aNBgjY8vxE3g35gPW6Sw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 11:20=E2=80=AFAM Max Kellermann
<max.kellermann@ionos.com> wrote:
> I had already started writing exactly this, very similar to your
> sketch.

I just submitted the patch, and it was even simpler than my first
draft, because I could use the existing work_struct in ceph_inode_info
and donate the inode reference to it.
I'd welcome your opinion on this approach.

