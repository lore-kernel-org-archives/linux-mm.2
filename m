Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28752C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409C96B00DC; Thu,  3 Sep 2026 05:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E14C6B00DD; Thu,  3 Sep 2026 05:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7D76B00DF; Thu,  3 Sep 2026 05:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 100B76B00DC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:53:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71CD4C0201
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:53:45 +0000 (UTC)
X-FDA: 85171989210.28.9A2085C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9029B180007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:53:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NLq3ID7q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788429223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n1/oASmskaKb4TsNyOYMfthg/1r5aRlEXI5W1jIUH+s=;
	b=OJoH5zIazrI5cXmTNKu+TjRWDRgJSEFLf/1Wb04jIqGhJZM1ra08wpqBif2zLIrxYKy3hn
	fSkF2w4e62kWZ818JDH+WCbpsyK//uj2HCIDRhalXojQm5yRPYws7vxMBM+S0jaIUws/o9
	qmbbJAIkjMWrynZo+GUpt52YrjIHldg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NLq3ID7q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788429223;
	b=5iQcy5tNKOEwWzN83JpoE20GcRhdpbmtG0L9XKhEfY+5uOQrUPKO6Z4WsFQG+sxawJ1BAr
	/pUKuYlmxehmvwR2pd+sb/CZU79zJPHwPjoHNxPFG2KN1QWBNwd6vC0H1xFys3ZU5tPFId
	oHZoDKwIDhxIHIR81RdFYevf7q2z0Ek=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A639143CE6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D93E1F00ACA
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788429222;
	bh=n1/oASmskaKb4TsNyOYMfthg/1r5aRlEXI5W1jIUH+s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NLq3ID7qomrpEicl7Svgl27Pfcm1MOzPSQq+TmuZOZulKLCHi2DolCibki9OBqnS/
	 Mc9zagXCHlPCwo8srvdflY6bs653i7/+NQ84V7IWpW05xYpW4mMewG0mdLg+tTq5w6
	 fJbBUS1J6SD6ajHrlboMRyPO4UvGCntbRSVslDcDz6ioU6DzqxLH/h1TncwOgaH2jp
	 Tlq0EYigqggrWW4K1u2RN9z62GLO0tgzynP53kVI1uQh/Cycif+rgkL3H8WCFughD2
	 SvdYmnbMzWU9+zrktu07Rs3sZwZXXg17isk2+wpjqPuCK5gLM1/npTGTsDgBbUryAF
	 uVRZJeevzhyWA==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-9377f717879so147432185a.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 02:53:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx46YWOTDfu2RT52bhCPJaEOChV3zxBg8orbXEQg0VwUX9XyCIxU3VMEPmOm4bAt8pyXMC4IFLCgQ==@kvack.org
X-Gm-Message-State: AFuF++nhVHiGsl1bXFdJKjScI8iPUs/xcqYUHfCdmPLPdFVipY5haWoe
	q4ipS1VxNsDDSh5Oy0wEDEar7Xivl+X4mpoBoUUp/avwX7h40pF+iT/HXQB7HiK3fLJEUMe/LZB
	pBWisuD6u132+7yKE8RBxUma4I4X8B2g=
X-Received: by 2002:a05:620a:5ee1:b0:939:6de9:4cff with SMTP id
 af79cd13be357-9396de96ebbmr435711985a.45.1788429221948; Thu, 03 Sep 2026
 02:53:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260903092200.88910-1-christosskarlos.kernel@gmail.com>
In-Reply-To: <20260903092200.88910-1-christosskarlos.kernel@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 3 Sep 2026 17:53:30 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yym2=iQdG0O8VZAAt-peB+0hoBUMf8rjpA966V6p0TGQ@mail.gmail.com>
X-Gm-Features: AcwNN1UMw0DE17Op2qfHPQ76NzPZzsK2TCPKbbNYcvIiaGvhscL5UNOsV5_q-9M
Message-ID: <CAGsJ_4yym2=iQdG0O8VZAAt-peB+0hoBUMf8rjpA966V6p0TGQ@mail.gmail.com>
Subject: Re: [PATCH] mm/huge_memory: fix various coding style warnings
To: Christos Skarlos <christosskarlos.kernel@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8di6gfm1nay63ft8symzzm463pb9d1td
X-Rspamd-Queue-Id: 9029B180007
X-HE-Tag: 1788429223-191484
X-HE-Meta: U2FsdGVkX18VBBYU8AKXWWqAvDmwEXRFVL0XlPI8L0ID6GWoer9Fwj1NQf+1q4w9ELXBz0ebckuM0Y/ZDUOGCAFGjKjrVj2lc+Vn2d3vN8tZuXV78jhdVaFvr/ZcNemC6JkSwlXOkKZa8keW/HXBTgGmn0Ujmx3E70SYqOFhgURCAcmXlWXK1vMejYzxWuLHzcO6jl5hX1+7F+mV804G2Ml75XKko0AekTn6J8OgPiF3L3KePs4Kzq2aZygwU+fW511s7GVgEL+e2xPGjXioLfdsqtkpL2RHDixBBK3FO/iy2+9xUogwP3ryMqqXp0W7bb2Cnlytoq/LWRkE9MOY72LFtU0znj2x8T9NJOn5X9ZOx7/vj8WWMBl/bJcC4hWFFu2+Vtu5vyEcf4wqzFc+AufHGmIzgtOLPEFMSRoUqZvFrW82ebQyu+J+2zZWZHTfPtwKowR+ToO0om9ooxLTERXT/h2qiNxy8s5XrwoAEHslt+RwVbOL18D33BWgJSjcAko0DfS6oFmrWw2T4VGumrVBsrG6vAEMXfw4CK8DT7iVqMrnepMu/hbCgU+z2Wh5CChF3OTKq0WMWeoXWUDbdttgNQ1kyUCUfCYreS2nYIWPUVm1i7qqMd6J3kt782BVkbHLfUwex/k76jtIw3E3zJTvZ6Cg46a9cQAimjLfxF0GtSMdc6rKZpyPQvmDf9W6OnMi6G6UCJnOVKelUmLsGyw7H/8PJtd5veX4UlnF4oYem8eUhag1Uo3Q8ypFo3jLi2nwYb5BUP8TLIqvcFXnPdmeJ26mmPmigqm0chnoVogLmMf/7eLm6Yc9cUDHb/Dp6PefrwQLYx5TWJffXZU6Rz9CM0TzmiP5vQ7u1f14ugz7UG1Qj4Qrz4arA0fZ8J5THVNohmcDyD75nFbQExhcDroLFSfFErehxKiSIsPY2SRPxw7C5AAsf2GpA1aEcXwbTu56EcKe6CQxDM0+D5m
 MWkzrhTW
 4iGu1331q3XK72+/q+HnESuaJV3o5dTZnZZspkuseAzct7iLbcweDASRT9CsanixrEG5AqZyUx6Nlhf/+8Y7OGW4rd7bEqkvVZWNvu+VWgD8dA1fn3G3G1SWOQUXmSkNQ/NjtqyjoUGkMfnQuDeuNb9ZwhL5IbLvTcyMowzHy7w8cbCTqzMctFbt/eLAFf/wbb22aruGBtcPr2apO19iHPRZdewKn2auZYRB0IV+12bA9I/T3U2bbRgY/ay/7g5wJ1rHNef8Pm+YMuyWXUSN+4KIJ2Fu5684JfJSAxuMtNF8d6CA8HIH3cgs6OYuxemBi6eWNEo9ZzWMZUCyqgecKOmuOTeE4i40Q2DP6Bs06eSCECKwhw6nprwXZTF8IkP5Whq2xkKyvs+yK2zAhbyhypxdnbEC6xvKTVEYwQfjH5yD2rUjjM9Rf3CKQ8EWiFhKdbAsZ2UZTDEi3MdY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 5:25=E2=80=AFPM Christos Skarlos
<christosskarlos.kernel@gmail.com> wrote:
>
> Resolve coding style issues flagged by checkpatch.pl Specifically:
> - Add missing blank lines after variable declarations.
> - Remove unnecessary braces {} for a single statement block.
>
> No functional changes are introduced.
>
> Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
> ---

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

