Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5A7CCD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 21:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4846B0005; Thu,  4 Jun 2026 17:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A53F6B0088; Thu,  4 Jun 2026 17:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894346B008A; Thu,  4 Jun 2026 17:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7844E6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 17:43:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3FC911C0A3E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 21:43:13 +0000 (UTC)
X-FDA: 84843556266.19.A0BE57C
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0FF794000F
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 21:43:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=bQ6IYMTx;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780609391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0rKRLQ7b0xQkDszK4kB86a8NKDdPGLBrBut9iuJxEs=;
	b=5s0fBWQ2yirsS9ZID2XHC4zoFPgpt9qPW9DK6PvfZMHuIYFinbC7HATioKJhVn8+J8C2H1
	h5uNQaOwYRtZDDM4a3GkIvT17eRamZLGR41FHlrPqsOv9CmX6jxPxRP1xBDOQCRNIVh5ho
	uhd5JD+bZGkJxu2Nuh2+WpMM4mCeUTQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=bQ6IYMTx;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780609391;
	b=g9TVpPU/NPNFXv421apA0e7D7LmXmL3+bT9+oxlxYCKHL7gXMbnGuKIpSY9fNkJyogSx4w
	nTVM1Rt5kNamt5HgJ1FE0WAFg0/ndtfZvZ/2XucvdD0nmn2wb+JHJxH6rseuL/05DRapzM
	LsLxgF19feSQWSNxnsL2zr4r8fHelsc=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bf1141c26ecso179342766b.0
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 14:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780609389; x=1781214189; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C0rKRLQ7b0xQkDszK4kB86a8NKDdPGLBrBut9iuJxEs=;
        b=bQ6IYMTxazuY8r1XDmtD3rsyqm8tsn+vtPryxr0QgyF4AB3qNwuASg0jFYrWeoSBqv
         jgbM/UhInoMqOYubciBQLiJyfvGVQna+lVNqNuBcAciQ5y00XY9yxWbNSLxBiJT334I4
         3LTzsz26mE4Du+X/1Us1LMv3aQ9EAyuT5GB0M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780609389; x=1781214189;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0rKRLQ7b0xQkDszK4kB86a8NKDdPGLBrBut9iuJxEs=;
        b=IJu7vSwyn6P69dnagVnfwGTbjKWGqLUkyfnnvDkmVU3CnPUnJjEqfCDlV0+3FrUwI7
         ZXVaa0cBtWE+GX9wJFqdPmFALmM1chJjQ67MdorudRhe7Ew78mq1naZAO0czXOuNa0ku
         3M8UcYO4UED1Ov01Lv00orwoHwZHiDAL2JaQzFdVO+74q5QQaQTzDa5CRcx/nWnCCKta
         9rcaxm/ZcHsw+G8UhmE8hDj7lUbVnxh7tb9DOLmKAogGf788oZ3kvxigrjs2k5zqA2Hb
         Xacwq/8G34CNgSjnNSRqF3RH8rg8kBqDsf9NQ880Aczo/qm73clGhAzXh8R1yhjwu21K
         WagQ==
X-Forwarded-Encrypted: i=1; AFNElJ9BRV5zxU6+RKpLVwBVco+4zLjrPbVGLsfCm8Sd55N2lTkjnYtagc3ZNgckZIkcb1r4brG8HPPiHw==@kvack.org
X-Gm-Message-State: AOJu0YweITJxX8sc807bPB8OZpHdUPwVN7uYHiPKqG0uG3M3EOU6jsRx
	MM7Z0mb8H+fUzLE8gfX0vFcBTaXgJqTlHaWbEdtqX2LV1867NL9xyMgHbEAFFsldP6oIKjBodiO
	dQ2ePsTliMg==
X-Gm-Gg: Acq92OGbxh5HXZtLW34exhnwzsCK9sMQNL2znisF2tfNnsdoIy+FyOTj/6WCGiWpoVr
	X7pt1WWSmSMCEqBU3UX0cGRC9Zeac8lW9I1KB/8f+88CDESjkgorV5mcNomjvgXye9mgZ2Tc5+x
	ZKTeN8z8TZCFwZ0uPEs+dj5kHnGHzIR71bw4dRZVgj6VVpp9ynQxpjBEZzs/PewujYo79MGBJMd
	k7m1DlU0IJPCf/ET84o6D4zHZ1lTsqpUivLFLzxKV02pi3ZSkL1GdyPP0aA2ryPgI4hiouarRB5
	Mo1WgBbiUu4r/qOz7TdjlRSyDk3YqX+szYShcSLSgCLMOP7c899AZwiytPSz/CpwKO9JN2yGiNd
	XelTN+hYyDFQtokx9gflhewydHCbc4QcLROH47fgZRBIwgDZAtrSAhYVT1caCOihGeZasbd3ipE
	+zSJG30E65DmiAZ7DegQeIj7xn3Gek5ntBW96JK90VW51Im2IrzC4575MCVzV0/TNdqM7DFPipx
	rjKmVCbSqK9xbP7TWkIgQ==
X-Received: by 2002:a17:907:72d6:b0:bee:776f:4ed3 with SMTP id a640c23a62f3a-bf37283c90amr23543566b.33.1780609389017;
        Thu, 04 Jun 2026 14:43:09 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf05177150esm358995266b.5.2026.06.04.14.43.08
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 14:43:08 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bec449d0af2so143661066b.2
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 14:43:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9Vis3q1ZPB9jNunwohuiqo+XU58RF04TUzpTncY5mS3+k9YLCB3jOLh8rl1PJQ8Hd7w1MpN5VqDw==@kvack.org
X-Received: by 2002:a17:907:a03:b0:be2:dd37:facd with SMTP id
 a640c23a62f3a-bf370e6211cmr21551966b.20.1780609388179; Thu, 04 Jun 2026
 14:43:08 -0700 (PDT)
MIME-Version: 1.0
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
 <20260603211736.755139-1-safinaskar@gmail.com> <20260604100609.6b37f500@pumpkin>
 <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
 <20260604183829.63c35fd9@pumpkin> <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
 <20260604223216.73468830@pumpkin>
In-Reply-To: <20260604223216.73468830@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Jun 2026 14:42:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
X-Gm-Features: AVVi8CfSQTIVkCCY1e0qHuDIqCVA2aM8un_0a9-AOfB95snGVQXFlgTgq5lonE8
Message-ID: <CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: David Laight <david.laight.linux@gmail.com>
Cc: Askar Safin <safinaskar@gmail.com>, metze@samba.org, akpm@linux-foundation.org, 
	axboe@kernel.dk, brauner@kernel.org, david@kernel.org, dhowells@redhat.com, 
	hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0FF794000F
X-Stat-Signature: 5fuj6ek5fko86hjqk5gq11hbpemo93ee
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780609390-710223
X-HE-Meta: U2FsdGVkX1/sM4kLe6iRCMMjoNvJaajXyAOQ23wv/BJXCGo1pzNoR84ohGM2E6PWYPKgi0mSmAGSA852LCLgKIYWjMchLqD26YulT0m1Et3hRY975qsgN01rXXCQO7vG69OMOQ5mGGKhSVGkUxMINz1jj+Ek/L9rBkVJFHNqVDRCSBsQO9xN2ol7RpCPxaxpNr+rN/r2+VmSj+TplWjm9oiET8V13aSy5z6fjGkJu1wYGH+0C8bYUQg+jjOTfSoYnVftJHJ9/h84rhnvUwn8fitzT2ZH5nwAJCox5p2N5dz/luNrZT4iYcpE7qZZ+LCJn6P5pdVOYRN5axuXVpLA3beqO8NLIsRxvQZ1EJS8kMtpsd5iZ/HIRtzIKf38w6ZvhjWxas/eN8MvAxCt2kTfS0qZ2UPvdosdub6A+YJaN/zekxD98lwEw1Fw/iE3qgZ8ULeTUMUCZrIqkMZ0KnPjK6D5XqbIbhClnMRaAo4zVGtBNRYxY7mrYortiQV57ZsVwD2k9hAo2O8BEsbKPHU759nbNn2EIP1C1aFnAdz3mkmjFbEn8ubDfrjtP4vvgJSCtkaCf4V2GdV/MWkgh3wwxfCUv551aduwZ+HO7ZJO1DzLJERlbv64Hbt815NmqoOp7T3fkrLdZa9Pm3El+wxSBWe/90TNGMF4gZ2lMy+GuuEBJ4OjI5raasrDlT2HVpyUz/NumIMLNl4ZEMB7OxQyN2L1PTO9h199MqU0oRO6z1yPHmsb07leFK4It9PoRgWDi7VON5rabJJAyPg/wasy7RvBVb6iNzBL8VqdUysT7mTiSiSUEpfIAZ1l7h+KgzFNd13oSm8IMDUAs04tLGB7IksSo6zIg9b2cqR4hLQqYee8/Bin1xE3JMKFrCDSU9YK1VayJvieT49LZbo5Iw+W9pRFeYJz/AEvi2tuSFxI6F/S/pn+QE8yVUCuHobjMJSi2hC2BullLld4LtiCGSm
 WBixpWsl
 DC8j0uu6/oL2jf72O5iiLgQhqwG08APvvKUMPPxhO6o9uHARYLhbRQt+YBJYrerOc+IJkgeHRZg5itvADDYm3jzYSqwhe+C+MEdC4LWyZDRH9da1y4pkCeyuTlBxz9yCXa+7r3xobi464+Z9x1TOLXTr1gAbWmgXgPjzDARkAuCFjXbsqm7VjOvf/Q31BM5CulikEA6VaRreIUxunW2tkCuoFx7Ip/jXIXc0+bK0xY7glABA6sGCAm+Nj3A734ZZapA+Ya5MXCwikgA56wnMLpxVD9Tx171D84RBV/iM0WyF0hKwGNVesbq4CAVac37bdzmrsfzHK1g7iKcpTkshmGpWk8Fj1tk1taOBHYeXNdUM+hEEAyaDpiDCS5JI9QvybF5mRFq3t9KrSIoCDySvK6fQsOcugsSV3Z6aahHv4lxLwRiRpfnS7oK74Vs61/DwdSW/NGINkf0sHNc+B0lgHWnjvEP7nGjs261BgEWAlWu4LVrdZI6mAuI1xNNWytH+sn06iKTY5h4Kb+9b3QVVcKM3C0da9XEYpYOv0TIXu3R/q+QkPU8fsVMzFtgYjmkuvjlt9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 at 14:32, David Laight <david.laight.linux@gmail.com> wrote:
>
> I think riscv might sign extend 32bit values in 64bit registers.
> x86 and arm both zero extend.

That's different.

x86 really doesn't *care*. If the caller zero-extends or leaves high
bits set randomly, according to the x86 ABI that's perfectly fine: the
callee will only care about the low 32 bits. So the high bits are
simply not relevant for the ABI.

The Powerpc ABI makes the the sign extension part of the calling conventions.

So if a caller doesn't sign extend a 32-bit value, the result is
random behavior - if you pass some function an 'int' argument, the
function may end up looking at bit 63 to see if it's negative (except
IBM calls it "bit 0" because they have to be different from everybody
else)

            Linus

