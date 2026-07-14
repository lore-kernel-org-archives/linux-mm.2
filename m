Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A4DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70B76B0005; Mon, 13 Jul 2026 21:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21456B0088; Mon, 13 Jul 2026 21:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37206B008A; Mon, 13 Jul 2026 21:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 979E06B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:06:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D2E31A0241
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:06:47 +0000 (UTC)
X-FDA: 84985592454.20.0450BCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6494F20005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:06:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GV04D+oK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783991205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=heDN1w+P2ZOkGHQu58UmVn/+xWTRXKb6cnPdnT9clG4=;
	b=UI+SwSNjiF5dgZepM1lgDZkMojxJF+cWk15P/U5sxb60AlTGw1ZFv8NwT5yCYD4DgmkF8S
	ZUIFeskop/m0RLNMYORXDu47BtQR8eNqVe6CJfViqQN5WR87Nu24CrQTx2VYTpS59d/SFJ
	hRF5jRdHe1cO4esuhOuI836DLUwXpfA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GV04D+oK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783991205;
	b=mQGy6969kQUQJ+ScvbN7MMq3DIx5/gOBXphn+GZ/mTwBWrve1DNfABPryAaJ28gdUWAlL/
	YCCxHncY48xJczR2+A0Y1KUyxniaYwdBBkGhZKhpKNTD3sPbP22nZP4TB4yHoNrvuGfIGU
	9zruQvK4krx9b4/o3B8zdvDPoDaoHhU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D944C601D9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890AA1F00ADB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783991204;
	bh=heDN1w+P2ZOkGHQu58UmVn/+xWTRXKb6cnPdnT9clG4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GV04D+oKUjwOl4+I7+9tnunhfmX+DDjdZ7CX++3V9SLPOONWYCrqUvrjyPjLmrPeD
	 GgUGd89mIhQBo6aryx2OqUoxbVWnc8gGUpHt+4l7SiBWO5jVbkG/KSDnd5OaXzNbCh
	 D+B9eutSsdl2UxVGHK2A1g4AXdP0P3Hx/1GOBO0AH8+aGfs1Ngvp4amgJbtkxRKt/x
	 v+o6geARFfI5Vy82xWkaCdCBEKGkLLT1XOtEvjxopEg/UHEgex6LHOY/NtmKy0aC41
	 252uLYpmUwYEAUgzVvb1Vc/0nRy8QQww32JlglD287f+hr89KzPZiC1yc8oziicTOF
	 5kJEhN1J4s7WA==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92c7a0a701aso239442185a.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:06:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp34uG506LNlc/Q9eqmEZpqQyn5EOpCqY7pxnEKbFgHLn/0a4rSYQak4ZLyYyLkLrJzVNtsoeqmzw==@kvack.org
X-Gm-Message-State: AOJu0YwOCjZA8dAJhdvo71Eo0p+FAVfCKScK5fafedLcob1jeEqFGLTx
	3V/5KxDUqpZroqQZG+kDr/U3kVy8M/a4xAWBLMeD0bO1eYoN0o6IBfdzw0xOdru0t+yyHNYThpR
	p5r/pCC99A3ZasJZFq2ehR+DoI8vJkoA=
X-Received: by 2002:a05:620a:370b:b0:92e:7733:e3ac with SMTP id
 af79cd13be357-93083c636fdmr149900485a.20.1783991203793; Mon, 13 Jul 2026
 18:06:43 -0700 (PDT)
MIME-Version: 1.0
References: <alUNQrCzt6Las0PP@lucifer> <20260714084111267LYR6nswASLSX-jLwxQh4w@zte.com.cn>
In-Reply-To: <20260714084111267LYR6nswASLSX-jLwxQh4w@zte.com.cn>
From: Barry Song <baohua@kernel.org>
Date: Tue, 14 Jul 2026 09:06:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yO51R48_ewcsds9myUcQVC6LX1XU1PJvoJff7yDejs9g@mail.gmail.com>
X-Gm-Features: AUfX_mwzaWtNNsWuqkKhmomynNpkOsJym7IgnbgTpSx32l5ci8STrT-Ql2ukrBg
Message-ID: <CAGsJ_4yO51R48_ewcsds9myUcQVC6LX1XU1PJvoJff7yDejs9g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/mm_slot.h: clean up macro parameter names in
 mm_slot_lookup() and mm_slot_insert()
To: xu.xin16@zte.com.cn
Cc: ljs@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, lance.yang@linux.dev, 
	usama.arif@linux.dev, chengming.zhou@linux.dev, qi.zheng@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, wang.yaxin@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6494F20005
X-Stat-Signature: hbr8tfwcabn5yjxxbk49q98dhi74ipu3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783991205-899595
X-HE-Meta: U2FsdGVkX1/27zQlQgAcZBRwPKNxP1ux9pCgR//Mpw+Py6+36+ASCiE97X6JKnafurzuU+Ku5pm9/aY4eboJchkhPx/f0oH1vzlViQgbVvZR6gQ+YFz8AKXM3Hsv8YiMOa44ZzG4phE0Ugj94RfeGXEAtMUgxF0IR7lehRDfmkicd+etnOT/fhKiIoHNcojQhyDkbVrPvhCPu2MhxCsvd6XREJXIrSGA2aZ0H0KkhJKE7Q6WN6bvlNLsuwA+yU1bpRHa9/jVrTO+InV+auvPTAegCJC0pLaP7YjMUfMrvnlygVcyvRMlvP634YOuHwfg/WwwBn9lE6SL9iBXJPhrkJgx80+yZ5ggMRYgpuJ4wtXuNZZ51wl+eivK3Qwr0EVK8YJN+Yz9ysxmWTn49seDbXzNcObCyFztbfD5kZyoot9kaQhok7tHGGnpjLZIrCO9U8GknMpmbceTwHeWOP9MiJWA3aWqfnCiA6NkO1w9LDFnI71W8H2IGqXGX6jOhrrQCQqIWzEY5wFX/SDeOTgXVlEBUDAYxGuG1kHo7hlY/FoJoH1Vpo8mcp8isL5K6ZmQ0tofPHEc6Im6uB5u46NaWkqfqXeWA8TuT9qs7X/sH6PJNf3shgUONg8Ds1kUPPiOad/Gl7Nx8ZBM3rsNakK4Zl1qKUna995ILApHxPMiYTrv4p/sPDlnhu2U5ya5HnIA1y6LeCEvrySsTCf+maokvs+rUEXeubda9XI1npeDzrsAVkn6tHS+sqkpUjowN8F40WZaeossOTyoI36a9nEUu/VrAgD+tppxc8xKhZel0zEExhg+xLtee1GP/DQEnicqngA2AEzsUriKt2EeXY/0sFy+wnxY1m4vEhMay+QTgmgWujP1ak3FjCb/vdbVywBT9xU/4bBRkKdVhVD3acgxGEtMFtRzRdVghcqNFv3XqubJFHarCjRZMCdQVirwh5OXdUA4fX0WGU9zrT5jkpK
 IdhU0kZk
 xCGVs3n0oTWo5+mhC/W7UuPjkJ2FbChdTZbnotY9j5wC2VJegwMqnoRvtm96MMMGUXEpJS2Y7nI/FXYvxxiGJbjoAB6ZVChMFXVMsJ+aqnu4dOyVLsOjwQZM7nASUqefcpmIC5466mimitdm7LM6wL1JS5BsU0QrA2B0sSUEF00orAs6CT9Dyt7BhXXhPr4wdfoeyzCA5v26fvNr8fFcgelAr4j3hpXMxg+igLDSnd5X4N18faYXl3ChWxb+ePpJ2aXPunKGqzmVHcW3rRkVI+INDSNC12M0iIO9t0FJaKchrhPpdvpyLGJCD2/MGe9yg/xpSYtdrStMou+mqLfmsY3XuwG5xzcUJgBT3bxmPoG7t+vlQs7H4N9K17CDufQSTarIe8aBj/3nFvSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 8:41=E2=80=AFAM <xu.xin16@zte.com.cn> wrote:
>
> > Hmm not sure I suggested adding a comment to explain it...  or removing=
 the
> > prefix _ from the existing macros :P
>
> Maybe I misunderstood it.
>
> >
> > > Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> >
> > Honestly I don't think this is really adding much, but I guess adding t=
he
> > comment can't hurt.
>
> Agreed.
>
> Regardless, adding a comment to explain why these have to be macros would=
 be
> better. Would it be okay if I send a new patch that merely adds the comme=
nt,
> without removing the underscore prefixes from the existing macros?
>

Yep, I would vote for this, because otherwise someone else might
try to make it static inline again in the future.

Best Regards
Barry

