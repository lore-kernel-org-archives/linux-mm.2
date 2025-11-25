Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD3AD0EE3D
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 21:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512AD6B000D; Tue, 25 Nov 2025 16:31:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB7B6B000E; Tue, 25 Nov 2025 16:31:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA916B0010; Tue, 25 Nov 2025 16:31:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24B2D6B000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:31:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2FDA1A0A7D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 21:31:34 +0000 (UTC)
X-FDA: 84150426108.08.081EC85
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 70C0840017
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 21:31:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=RdBMuFsM;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764106292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRUHdC1aRlmDgOnI/JdXNf4e5VYwEVqBwWqeAqYvNgA=;
	b=RiZr9T40Vyxyf3qF6aJwmzXz0OHWe+d4wfS71Jx3M2VeQHUAIpuLW1jazpiVcm91ysc/vQ
	KGKU22YSvx5wD3dlvEWI7ffez1eyOsrC8sUC+g8jrXR6RETPatTT5tE/rPSF8UfQrqVwxs
	BWeYcwxBRP9oq0VpA/7GfRyKacqzfjc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=RdBMuFsM;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764106292; a=rsa-sha256;
	cv=none;
	b=dpIIV2ftlSxLdY/wImIPwZeOBQExCzPV1r4XANb5haYx7JrqQv2lgaZmBjFNyhRfBKhADG
	ne8l4geEiunbXv4cmpF/QNedgd+oAEttnquPTutBE/k+B6pi7YG+Z1OUegGdN82f4+pUo0
	jjWVbi4jMCFkAV5UEDXq1bU+f+NDgmo=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b2d7c38352so26673585a.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764106291; x=1764711091; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lRUHdC1aRlmDgOnI/JdXNf4e5VYwEVqBwWqeAqYvNgA=;
        b=RdBMuFsMfSThytJeOSjxOCb790iqs9OJwxkisBDhZYF/028QUMkMnnF8MsqpZJbcjj
         Xvvyi3KqmUrGP70jebbwHHpZVxEbGzKA+1JRcQd0qY+nr/qD+9RxZs8eRb2jVXqLNOv/
         Ba2M4p5o0bEVh5aVcP+0MrUqvT/xqoZE498yfOGQeNCa7jyT9dayWtedosxrNAuTdBlm
         Rd4EvkO8empUTTNyX3t/brNLutD4n7B/I6fBzLJ0x2s88Jb08yfyE4vLRxESoYpGLhbN
         lD6e93kIWDKuYuTstudEOUOcbxI8CN/6j/IBuNLR3PwuCCpBiG51r7MuaRrNfdeMrSS5
         stuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764106291; x=1764711091;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lRUHdC1aRlmDgOnI/JdXNf4e5VYwEVqBwWqeAqYvNgA=;
        b=GyvOD6KRTTAOrGcHbLb6WsNMQ197+z5i4YE2iIx/nPddFDjRCjFfSFTrLI2ezdUsiD
         C9/Xb88Zh8OvH3TtF7pIE92bvZoKtg7QXWwxU6J1nEmCzycTH7mBqv4ShBVg33DH9B1D
         Q4+SNQdVGcurlF0QfpXAnb/+U2yUsUAgN/RvL1txc9Jt38+7lYzlD0vHUzco4y1g58BB
         Ee9BeQ/z2/M3CShbD/LEU2U6keJBaibhRaFYDZ0RGIbPDg5Ah+1zjzefrFbPwaixPdrh
         7u2D/Rq7+0kQVyPEOHD9pjq/J5iLZ83nHRFzXOeiyZPBSBu0QQcGjQpy4nv+B8IxmnEi
         oPTQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2u5qdenS03iFGLoNmoYZxHou1Q7HacfpC7Uh68w/a08HGiozYprgv/tocXHH+EBJeeyvW20N7Jw==@kvack.org
X-Gm-Message-State: AOJu0YzQ4QWpHma6MmQBFXBqqOA1Lz0b/YaBkqE504yIP4EmjATHjNeD
	iDAVcR0xgkXJ5lwP4w5X328qXLpps1+t02bZF/zeiNN4WbJGklUj2Gp+W9jZLJ7rJ90=
X-Gm-Gg: ASbGncsjo+q0RvewqtgPzqRRq0kH7kQklF2ONyl/FgQRrr2QuGBf8fsoZt6o9U+LvDf
	Fyg2VgEoi8vCDcD66udKXj1iqKVdlMyHlMbb71ZhqVmya7tJ02bb6jTITIwAEcQVEqs4gqRo4dS
	EVPAR3KbFIUyAn4xSQ/UhGBexKVOGZpg9jFngIsKwHvrjlLwTus53wugHqUtYtsYd3g5AutwZEC
	HDOD1BnggKuKr/tiUWnfBfjmgmyF48GRS0y2Lw+rILsNTsQ0H4ZVtcNneAZf+0Oip578/bm40Ld
	RjvAyhpq0/UY6Pi7Y/rtEuRInvW+awcpzpEc4ol99XoY+2bPZzklKrQdIdZXrZQA22qhEKKQxEy
	ipA9JgeD3ya9gAXrRePtEB65hRnFIeKfbF2D7iFeFUvWQJJjfRNiq2gPmT35HIhKZmQhG+9DDSB
	fAhKCjAPNCbw==
X-Google-Smtp-Source: AGHT+IESFDhYjWwPyHUj5ojId09JBhGC/7vdROiobNKajXEcUJDzyX88Qm6INxXjo9NZYRx2Stetzg==
X-Received: by 2002:a05:620a:2943:b0:8b2:9b48:605e with SMTP id af79cd13be357-8b32af2fdf4mr2704623985a.38.1764106291386;
        Tue, 25 Nov 2025 13:31:31 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b3294321dcsm1234154185a.13.2025.11.25.13.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 13:31:30 -0800 (PST)
Date: Tue, 25 Nov 2025 16:31:26 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pratmal@google.com,
	sweettea@google.com, gthelen@google.com, weixugc@google.com
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
Message-ID: <20251125213126.GB135004@cmpxchg.org>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
 <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org>
 <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
 <20251124193258.GB476776@cmpxchg.org>
 <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 70C0840017
X-Stat-Signature: nwy7eh3dg5mqtcudqq834ia75o7woqpp
X-Rspam-User: 
X-HE-Tag: 1764106292-550968
X-HE-Meta: U2FsdGVkX19Rs3+IUD0OQxhe2vwpHXSZ38OIiyI4HrOP1Qg0FSBCq22PZ1LZhYiXEQ4S3eSqApuSXEDFa2CocqQYODB8qrYL5AaI4pzVteCshUZbHxrPQtVRFC+zNstsz4uS42NIq/rPEKIKMbp4wiCw478iHe6LtzUSK4p4FcDplROcgr5u98KFc6EpvKu+OITdNQcMVp3tBZAARKoDo3NoI7iP4v5dK8S40/xCS4wGBSdpm+hYxBinNIMDrfDxSrU5uFcz5vwT3ACOiGflTFz2tAgeejBg8/gnm/bJJtcu3J3xyJFnVvWfUK/v0aqCsahcdqGY76tTy0Ji0AFuPuVpF5sTYOw9HrnB69NRx0VUl0D4UPtFXjTCk4nyypP/tkwhRrrX3MDUhMKypkU4/FWUmTykFKv2e5B1Myhf1h7dbnoxAyti5QCOc2uU2DS3T6hm08LMHq/YB+Ge1jePkzD2pRuQ7TTRtJ3scQ7gb2T5pLV2JK/vQSUxXs5cfa3OAC09FXiD+/0ULZK0m2bFqpy10GoMxznayw2jsQuZqB4/5an9Jyd+IiqZRIa0JjgC7vZXWaes5zpn7SDwIyUJV55bQhSYSVSxRZvtPVx8F5kjMrRzm4G8ajJuho/fQGtAEIDynGouWZ4zSBiK3lhO+oXkADOoL3XsG1MNiuDtOX2xIVJ3/mFyHgIa4PEBXRgm5KSZgiRxAsJarhgCRHSscIHUHdkdsvMZkHXPWWktgGHm4h6E7RG1DB5al5H2UjHJ/BMQMRzvtu0/CRfFGVxb+PNbbNOmgSJFkGx+gctdqfhbwRjL/Jxy4HNHBNigV1sOfqEDk95TMXnRWY0vtUBd4cZhHfP+upp434OHhPMijyFFr4PPtmnA4HvUl7Rt2nearQKO8p9NVXPGNj2BLCAb7bfJyOqIpzm3hs2lA7AhzLY8PCBtGPAAWNRR8zMjUIz/GaN6O5EQyQpiS7Bano1
 Fezvx4bR
 GWKRcN66s2nKw+olt1857R/45gsGYTFjnEzvDuTxCpnTCleeslHbYCwYRhzQEBhTIXGSm90IkFI0O8nO5VoQ6DdE4XC5SO1oXR4wBQhfHTpic3CitjrNh4u9TRlFl68vcgQdcu6RrovHN4VDuSBqoQx2RXYe/526o5j4mPzOw0sA+mkcNp0PhEHJhHFzxwjb3OqiMpbedz+3e2PtzmuFDU8PpmEHEljVlwrdBhC8nvwSB9dCgDSzyDjCmhr4HAL1N3rggzZzNBrxDnG9M4a0srJCdNeUYMwYgZPZyX+c4MlGrPuLt/gdKxQKecOn5H/RYMx4PFsoTnOUaCGdjwQ/IfbafByW/IJqSbcYMm2RxULZNjSowe+sqiE8t4jI4QxDhqNwNjUIIfXhYxXb9nkBgNry41mCFWOvelHt3wf/b38dLL40PFpTnETD29trbN6rxsBYhGOaJueXtmqbg7ekPO2WZfbRQ5LjseFMOTiZ1eX4tLtL2iBCWbZMCRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 11:27:04PM +0400, Chris Li wrote:
> On Mon, Nov 24, 2025 at 11:33 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > > Do you have a link to that proposal?
> > >
> > > My 2024 LSF swap pony talk already has a mechanism to redirect page
> > > cache swap entries to different physical locations.
> > > That can also work for redirecting swap entries in different swapfiles.
> > >
> > > https://lore.kernel.org/linux-mm/CANeU7QnPsTouKxdK2QO8Opho6dh1qMGTox2e5kFOV8jKoEJwig@mail.gmail.com/
> >
> > I looked through your slides and the LWN article, but it's very hard
> > for me to find answers to my questions in there.
> 
> Naturally, the slide is only intended to cover what is in the current
> swap table may be phase VII.
> But it does have the physical location pointer consideration.
> 
> > In your proposal, let's say you have a swp_entry_t in the page
> > table. What does it describe, and what are the data structures to get
> > from this key to user data in the following scenarios:
> 
> Please keep in mind that I don't have every detail design laid out. I
> follow the first principles that redirect a swap entry page should
> only take an additional 4 byte per swap entry. VS blow up the swap
> entry size by something like 24 bytes?

Nhat can lay this out in more detail, but there isn't much new stuff
in the virtual swap descriptor. It's mostly just a consolidation of
state we currently track elsewhere - swap count, swapcache pointer,
cgroup ownership etc.

The actual indirection is just a word for the backend type,offset.

That indirection is the tradeoff for swapped pages. In turn you're
getting back all that other stuff for swap slots that *aren't*
currently used. This is a win for the vast majority of users.

Since you mentioned first principles - the dynamically sized swap
space is also much more suitable for compressed pools, which are the
dominant form of swap setups nowadays. Again a win for the majority.

And the worst-case is reasonable. I don't see the giant gulf you seem
to see there. I don't know where it's supposed to be coming from.

