Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52843EB3637
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFED46B0142; Mon,  2 Mar 2026 16:11:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAC226B0146; Mon,  2 Mar 2026 16:11:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983ED6B015E; Mon,  2 Mar 2026 16:11:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8683F6B0142
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:11:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2604814031F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:11:57 +0000 (UTC)
X-FDA: 84502370274.06.370C15E
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 28692100005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:11:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KOLF7MJc;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772485915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5+jA3CXQpEXRAS2r/eSJI0gTM7njymSlY8pnF8yFb4=;
	b=F/7Lx8MVqK/wzdp6Un2d8eIRuT96tidm58mQj6m+iK+gDUK1pldtxWaOgiWScH2GW4vC/q
	k2j1G+i8e+NCJtipmtrX9KTFK7bb5xCWQFs6X72amAXwWNs36D3q8WDDQmPJJ+HpUj3J0F
	tMlhG3gzwLMuBxbJSqbqEL2r5B0cY9c=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KOLF7MJc;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772485915; a=rsa-sha256;
	cv=pass;
	b=3gWO7jeK6XykJhQKIXlXSjACHF9XqeaLTk/4Ylx4o8wppjiw0UZzCOTI8TmzGg7CV2egT6
	iKdUcHNnmD74yj3KbIMIDPfM7RUo6S1+IfQlCR148xCKBGX6mGLqxrPagw/pLAG1Y+6a4F
	uL/Is7PMV49hZwj3exZHilnK4FoTkXw=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-439b97a8a8cso1306184f8f.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 13:11:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772485913; cv=none;
        d=google.com; s=arc-20240605;
        b=Cfy58BiYbkoUrwHbIBpkzxS4cGzjDNXchhki46qE6OUMrSIIfd+UacPjc07AHtQHft
         qonKajySyn/gR8APZOikzpmC3VBwYEmEMT//0QOndA5i1mM6OwGURF7avn8VKnl63oIA
         pS4+HtmvXCs3/a51Mz7dPxD8BVw76Pc/ICbk3JcHobPUYjQPeBLhRiT62EWBEDUaLn9K
         LV+hxM6uDVR1d5u/OPnJ3YdalucNPGhNk4ea24d42uj5uiexDvRhErxLhLCkrdEw9Ndt
         09PAzXNJwn9moKX8ZolM6pAZBtwXSYWGdLzUnN44RkYfvaUG3GVo9SOUKrQDY/gNPRwH
         /XnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k5+jA3CXQpEXRAS2r/eSJI0gTM7njymSlY8pnF8yFb4=;
        fh=O+CE7iRGKkb/ak1ZvvOjbFXXY/p362zF6Vta9wjv9FU=;
        b=O9xAUVdDOfpUFjBCYRyWyrhxOB4qKlm+vgs/vi4vv7e6ne5yh8LLQH5pbvoTBvUu3s
         3Xw0nx91lP99YIdvuZ2sBh/hIbgPsZxZt6xEXr8zt6vfpTIoS1dpqkGuXDzwcOmIgnJl
         SnS6cs1fy9tdpuJbxqKS/6c5qFcbg1Nh00cTJDAR992FWoc2RcXkVBz345vj5JJgkfto
         19YmIqa4XC18WzyL4GIB38Fta1BSJklcodpsd9EoxUc1L7vK91V6lLZKedNLXT/qVd7W
         R3EhJ+0pEu3DSbemNVA0pbXl3seyWFonqsqogI+ZTbMpPwRTxjT6kJcBrOopycs/mx1u
         YfOA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772485913; x=1773090713; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k5+jA3CXQpEXRAS2r/eSJI0gTM7njymSlY8pnF8yFb4=;
        b=KOLF7MJcwxzszh4TftvLai2L4I2j3S3joG/CcdDHkqO+/Msz3O6ZBIg0a1r40CWQK4
         P/xI0FYnUhWoJLSTBmLAKOuQfUKHo3CObI0U8raXu3ssxI0cduPML5Ul5BfSzthyZEw4
         Q33fljpupBSMVnRX/hrP/9H6CGcdu5GpQgrSk8wvDOAnApu/JAuawx8510ikA/6bxqRb
         lp31P4HG6w7sJEivn4bMTgfDG1IxMb95AVBPhFApyc3RXevo6CP7OCHzW1mO8niVssdW
         Rsd9W5M8gHLzgwuZgpdNCjaIg4YX/6msm8P83TRbrxtZ9EpEPbC9Z2WKKzmq5rNmzayJ
         ldZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772485913; x=1773090713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k5+jA3CXQpEXRAS2r/eSJI0gTM7njymSlY8pnF8yFb4=;
        b=Zdyxf6bpPni3eo76wif05T5IBPUj2nfwT0a6a7EAsXgauVXTxTsdPaHal8eud4HkUK
         +Q4qEW9jBxtj4eQpd9tkPpyYWonpk2VV3UDMNNcjQFwizbhV7Fch7lSo571cvP0enEmm
         JyFKfqjXBqXzzZPgS7pd3Dn55wSJn1DebY21O+MXk/MgB0wrElKqFaGSYtSDSgW7mw8T
         ccI2SmVFKRPNYkOx8NWcKKt4Pj0D+rCeyzbeJQrlXI6spD/SyoGb2lW5nL/KBVgISoZ1
         E7CKt63G4eGdBtZxsiPk+1RmQeU5KgO8dOXxzg32BVOtm8eKoGorvjMjSEG8L2IrrN3Z
         LMIw==
X-Gm-Message-State: AOJu0YySoBym53GIM9lml9VAUBXKxuTWNA5p14zhjZP07g2sz3WHKSDS
	oJ88jrKnpUF6khZEAWTTZ5NtVnjg8/pcXg1oOCl1vGrbrlsIPRNdH8VHqXcvo4J3oVbkewBet+C
	iRBUYqnzmZCeKeCzCv6kMA+FbFN6uRnY=
X-Gm-Gg: ATEYQzyEPkNFoHgaHqrtN1/bZRkj02zCM5ovTvM5mw17MuHgQYWEfG3Y9vkXhoH8TbT
	CwX9y/Fy1YTJw3cCHizU/JNlGB4M3z4jfwW/j/KrTQj1QB8cOwVw0dgz541QLOg4HQox4QT0EEz
	2VjAo7XRvdCaGemlSyqjSArcyz6Nfm+fC+ySwM70jYSZWXmy8G3VujSQ1gUxW6IeCTZ0sgYYC8v
	GgVKAmyWH/FvaeU56MHqL2QWF7dum4efNkhHvHUizPhhOwp7IUFxgXWGIQHBkIJ36SSttBxC+Qq
	pgnGyFg0FQr+F9MQxC8iypFQRqoxuAUvUL8vZEA=
X-Received: by 2002:a05:6000:290a:b0:439:b788:73ab with SMTP id
 ffacd0b85a97d-439b7887911mr8563536f8f.49.1772485913440; Mon, 02 Mar 2026
 13:11:53 -0800 (PST)
MIME-Version: 1.0
References: <20260302104016.163542-1-bhe@redhat.com> <20260302104016.163542-4-bhe@redhat.com>
In-Reply-To: <20260302104016.163542-4-bhe@redhat.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 2 Mar 2026 13:11:42 -0800
X-Gm-Features: AaiRm50jifHOteLbk-yxzgby0E1DXWENLtDa4RmbKyZB6C3HNYhl1n2bnTjlMuQ
Message-ID: <CAKEwX=MnjmMRyc9_gvrDanKCMZ+KfSApb_Whmf-f2pkrL-RDMA@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 28692100005
X-Rspamd-Server: rspam08
X-Stat-Signature: gmpwmawjazhhx1egtk1gsxnz6sag69g7
X-HE-Tag: 1772485914-323103
X-HE-Meta: U2FsdGVkX1/ZWodYQdM17zVabPaWLvXKdsq/ivsqu4y0eDBA2WZ3/uS/XyPXCfhhPQ3d7TmLhTu065FRjDjFCBe4aDjo9IglG46pNJVc381L0+4zoIlClF5ubcdo3wAgjHePlfhmnEoiBlWEJDDZrJ8FabdksZErzxmJb2KHaqZ2BeLdpywYosG4YyH7uEsHrJExYJwz3tA9wBgPqAY2CeHn0uDolF7iVNE+yCrAPcCVnbSVSQLC6SneNbJQHF6+rnLS4zxptZi/DY6H96vy61DOEiGlDPVexoFTEBtDhLxW6Na27ocfglvTMsNmpwMR2cYchnMLecS+Bujco5rM48uFtDbzr393kcdx1MX6/jd9Ui+uc1wWGflhm7P8YMjBZDuDuQ82B+uiATUNOtRY+rlfEoDOy/mBTJ1Ce1uvOMyzKdccfP1psv7/IjPs1KDjrlzDi3CIWR5wDdpsrVqiz1X/p5s3gMlt+rkg0jdBROkZSuk4LJTh1Dc5H+9rJ62w31dDAoBj6f+CRcdu0URyuGvaxhTrLNBJjInOxgYZClXZy2sZn4b1IA31bbOuFXUBB6PoIW7/da4aQ55GtMPZuP7pVWC6O8kB4cvokqrNBL+x7YtHB4gegduu6evW1WYsgyae3yIJInnc+HoKhAY6SbT17H0TMd1fgScH0PIpK3vYLPiH9vosXG9ZG3mZeCBR3XLOxOzrRUZGauO9ODc9/7VDBM+mEkJd+nVVrz9nE5RzouJmuvY39FvTttXy0e32uAHVJtPWULRoYLHwJRxa3GLogRxXLipCh8Qdsri2nDx6QhPWpZnObhtFZSooBq1hKvel4iG5E3ZCZTaOPL1RW0GlInmEWYSFW1uZ0uFbp8hmP7IfOydjp/BUxZaTN9CQPIoVnnbbNxK9WdBJfyk3/zWO6p0DisDNF5bf5Hsy4chupOFtcGwAVArUHdwp/pKnngTuC3YMNb+V4Ecmgz4
 oFX23Ycv
 XR9fMPdz6jwGt+Hp9ZxfUlvCUTlFvwXBFuytcBh2y6vR3GGQnALBEx4f7ch+2ArVl/ntOs/gQPfW9g+YkylhjzWWveUOc10J+qnE73zQeogJ7RzJbb97GO3IrJPTi3qddCbYB7RByPC1hQT3pDTHAtOJSbXWUWqtqvbG8WwVTcpRV3NmrVkFgG6tbJrqBkx/hFdwZEB+Eg5HxcEUpYpAJuh9FAoSo7LQ9AVVWLZHURcXMdQKzKD2JYsuP8TKEXS8FvP8jM8s2huHIiVKnvyCsBgDda4VQYF0AqXoxSP9MbIPONc4qagDelxqfu/4oCdsjYOe396h+Dn+468aTd4MhOANYeLEkMZ6hG+34ovreYfEb0cS1EidWN9CRoQmk39FpghC6Cbe3r7i+9+N384sKVe4TeipeDoghqXne3Qz7LvaM2fVzoFik0S7V3Tl7adb3WrXpzUBVNr/+abQ4yg+JRA/Lq5QUWpfZzzrx/EtSIhFQgEi/S6nsppFfy5A8EIGkQI92S4mGUiMnu3wIURWi+5nWrXXryLu7Rf6dvJpw9CNIwxhdxhWmidLapfRE5GLly06Mje5QXg+sgsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 2:40=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> All these swap_writepage_* functions are hanlding passed in folio, but
> not page. And this renaming make them consistent with the their
> counterpart swap_read_folio_* functions.
>
> Signed-off-by: Baoquan He <bhe@redhat.com>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

