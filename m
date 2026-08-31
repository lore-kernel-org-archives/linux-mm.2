Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FA24C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 23:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE706B0095; Mon, 31 Aug 2026 19:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785FA6B0096; Mon, 31 Aug 2026 19:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B8F6B0098; Mon, 31 Aug 2026 19:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 430AB6B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:29:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 082DA1A0296
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:29:25 +0000 (UTC)
X-FDA: 85163158290.13.587EB24
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3707A16000B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:29:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dpCiRqaP;
	spf=pass (imf08.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788218963;
	b=H9kb/Q3/b9qiGu/5GlNG5H/EgCd/UFkFtNfJo2ygLh2SW49QjZokPJ1sK3bkYfsE6j0J27
	8Nqb7Ycw98e6388yY+xavW6zdZoe00/6CZlGDGi8Abl4b74YfT+M+5PASyPnBDUdiy9fuy
	JfdxFTsB+oX8xDE8FpVE0uqCATAdEUg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dpCiRqaP;
	spf=pass (imf08.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788218963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/n3fvUgG6MbykCjQ/yhTPU59M7rXcCUC3WVx+XsgKas=;
	b=2Q0zYIIOxiMR+O2UUZgfRSqaRLJ+ty2K6wV135kZWcjp185RLpAjvrSzun33uYCGoghLBt
	WGyq7Mc7m7krDMLSmYIWSIjZ7zL26dbc+IYm9YRSMy61AA2T0HfgA9E5lrL/nmmUKCu6C7
	2NnLyz1LSmLcLu/rkd0KTHear5mUlJY=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cede6375caso49885ad.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788218962; x=1788823762; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/n3fvUgG6MbykCjQ/yhTPU59M7rXcCUC3WVx+XsgKas=;
        b=dpCiRqaPLjBXFNJUhPJKBrOetV89zT52YQEd3CP9znKN174wR0XQSOuyqES+jmV7ZW
         O+OA84a5CEY7bpr0dUxR4SudJq6m1LorLdhsfsqHnVyGP6G/eGY6+zZntVI5AMnpZ9Pt
         hPOg830mxotRyRGNlkO65BuSn4uwuhLle1DzDsiwGo8p0A3T+kizEBaOOOjAMgQKIdYL
         FylJ/hEkWf0sFZw0K4fMnt3X5s6RcuXuGBXcuJCQ7SLe3aCR4xA1xYvQtkwMEEwFqGIY
         DhKfsmsqcLCk4dA7GPIqeKPYruoPs2L7wJ8hLUTWHvZR9uAINq2G1GKJh8Cr9NlTPeC7
         mFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788218962; x=1788823762;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/n3fvUgG6MbykCjQ/yhTPU59M7rXcCUC3WVx+XsgKas=;
        b=mMC1QA5IXhChjWPNOQKzqoN7mY7j5zY6RTORofO5ZbkrciWKZjnPAJ3mTFG5FW8sq9
         tgHOfsB7Uak3EtfJzcytrHwr+le/hAAz4zRK53pKRvJCqyD6BrEuHoFV7VG4gyNdCPie
         1Z5N4JL9m9ySJD4UvxbC2b9tLqD14d1MhtdnZPMAzCJJ/7jdtMcnUxeOweqcOY0nryQ5
         HXsDBea+6H77X3UBgmzL8LxzwJKvse4UYCwxG1sdjZI0aM8QPkxmi+YGHcj2YxFUfncD
         bR8qeOMDWnXv+WD7i0LWLTal6F6ziRJfavf1KoZ7vywqmKOpGMqguR/Cwjbaqnhwsln1
         zKiw==
X-Forwarded-Encrypted: i=1; AKwUvBwboZuw1EvIrV08mVXCMI6AM1CoM5LNZQoHm9UJ/mkOQr1k4yMqFOJquG+pyU17okLmpusRl2wdOw==@kvack.org
X-Gm-Message-State: AFuF++k/6j2F+rqTFh8H6hCdbOn1a0yDvD8ZmYzt0eesBOz/ca36wR64
	72mTVt0rNdnzMMu40Vz3EXPNTaFyyjQmIcX44J4IE/7AVXSWB+rbqILdj9Mg5+XELg==
X-Gm-Gg: AYBFou0y9wb0ioJ1bd7EMJgu4L+omfY+zYiLnNKmfXZDXS2wOtN0OSqshuDflfSU7ki
	N6pBkqD4vH1/XOuo6BT7Q0ACETKiRH0HPAvV3ZkFyzfz6p4lSgUBHYvtRNE24QuKBfPYUhtEWgZ
	y4f7NzLqzSQiveyHvJ4gFahDExYX/W3o3tt31OEKZG0w4bjxB4bxpapkTLGRbE9r+dqNsI769c7
	ENiLGk5QBsoo7HTiKtUF2RT6PdXNqZyR3JD/hV1HAD5+Q/ILl0MS3rnKItRTX432dZr8oBgEQor
	bZUMtDgW4irFdLQOR9NIr2ERmCga6FkBz6kiNajWYWII6TqdWxtQ+mKvzoqortJnW850QWmzHIm
	ejT0tgFMTrIuALbT3ra5RWdFVeNdl5G+WH7w0ATIdFl/6qcn9sFeKOu4YOYSORYI7M+QU05Z/gw
	3LFOhvRPjfjlH2JDUkv34PmVAJwuQzneWmmWm8DpDAkI91RoIjsoKJv04e+MVEVErU1oGK7SEFH
	Q+dbjQ5luM8ELqmTXuhvXPLbpo8Q7feJ2MHOhveIeZZAmU1/UPYHRA20XT57mkRMoCdUWVwWANu
	/ByuUewxjKQNMAlwsw==
X-Received: by 2002:a17:903:2290:b0:2c7:f688:f22f with SMTP id d9443c01a7336-2d959ba8671mr1247175ad.13.1788218961331;
        Mon, 31 Aug 2026 16:29:21 -0700 (PDT)
Received: from google.com (193.67.125.34.bc.googleusercontent.com. [34.125.67.193])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85be6377472sm154420b3a.19.2026.08.31.16.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 16:29:20 -0700 (PDT)
Date: Mon, 31 Aug 2026 23:29:16 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com,
	ljs@kernel.org, david@redhat.com, willy@infradead.org,
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com,
	arve@android.com, christian@brauner.io, tkjos@android.com,
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v6 0/5] mm: Unconditional per-VMA locks and cleanups
Message-ID: <apYOTPIBTsuQKUXE@google.com>
References: <20260813193433.3318288-1-surenb@google.com>
 <20260829185625.f5ee1b2931818843a78af88d@linux-foundation.org>
 <apVhzM2501wSiGGg@google.com>
 <apX_r59k4e-XiI-C@google.com>
 <CAJuCfpEDgdC=N8__Ye1xP8rZtUwWrGhKhJ9Qnn0hdV+u5r+hJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEDgdC=N8__Ye1xP8rZtUwWrGhKhJ9Qnn0hdV+u5r+hJA@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 8g6rm7p4yurjds51kgph9yqak4uwcxxx
X-Rspamd-Queue-Id: 3707A16000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1788218963-788855
X-HE-Meta: U2FsdGVkX19iUVcYDzcFRtcPDMi0aeNaXdnWL40e05bJ/e4TYL65cmWJ+LMK0A7ZPaMGuL+GepkewP8YIVaG/2SmsCRQs5DaAOTy5TJ9vLMkV8tPJ0qURf//hkoo+E108Zvvikk+56ACfEIRIgLvYz/sVJ405I4PlBr1N+xHccC05uZcnr/kq9Nz0z1Vj11195CetyoSLmyJ/lYMTOCWvfO8ZEpTVcV1piB+A4RgE7+6KB9y9zUmOUguUGNhbQhqZXAN5fZ+GhE0hy/LdMG6Yxb2SAgpvqnHGMz0Vmd+jqX4cXQ1QGQkYtWCXAmITZ40XwPwx2N+0WyhAeFqgoUNabGv2PJByConR2UUFr31uRWXADTTdwWucDtgS6ViTO4I2cqxEWxyiICkftkZ/RSvdtXEyNxWlMLg1eZEkgUrCTryKMuEBzpcushAYdK2PNmEQPznomKsjR89Gb7vogyGC+VkWtkjsqORWIOSLmey6GYL3GamSNfi7F9M07eqQGJlNvVlIxujpoPHdf15HDqDL4LoA8d6341SEX3YqbBkPdgJVMQzbH11zz9TyNm2FluYoMXwPTylX/l+WUcGatb7M/TA4h8hvQOwN7yyptt08Gc3UmYYUmiPA0xlvbmjI9rtAwG/tmlm44yxlbxpe1+LoleUdlAnkc5GrV/dvRw/4DBuJG8ZfqY2ITrhY3rIzK3WGEvuWCggocGYSmZACjBEIVVbcjXt/V0C5hHXbvhXFuw//w+G7g+IyFRO/tOCmbplJU6vFpE4NLSFl3XubXnoEd3sOceQYyVqyL7drYN2BvBp1Ksk+mjjZi2tyGyUlyms/Xp8t2u9JmdZ1ulI4oq12qC9E9e3KBw/hxDYKecoQKofaC/1PJWugk6f6qsK93BuBuViqjTS1RwL/CMLA0s/mqYzDictzS3fgJEO4+kW0ELAkh0Y0s86Ien4/CxE+Rf9dfGCm7Cp6l/CGZPgTRg
 WiKypbgj
 7JyOjvlm7MHw/xoLM4Ca8FdUXFTHizFG7ck901UeGWHv7sCuBIUn0+ASpGtvqAH/LHTeuS0q/7U8ebtDDy9a3jWJPyHB5Y3DPhJf3e6FhECfQF60UdG63FmvgzqfgBSTLLxFsyVI77n1iRJs19n0RDk/gBAtQYZ4ikHOFVCFtByH95e4WYt9HKAB1zdG4M9WvW5mG5m0jNBnjZ6/ATAh+KnTg+Q+aenGFdMFwU8W/7YneawuVFPUaVlF/453p++T6sKgmSL6JA95JuFvS7bFq9NYfp3u0xpgTmUAWB5Q9WV0lVRhD34S8d2+Aq39LrZvST7AjGfIII/CKiEtQ/8KYN0QOl47cvrsWmSdztqFOk07cKK98qW0oxAYquSdb7vytibIRlrKroYV17P/sgVrn/Fm3PzgfzG/q+VPHtsP0U2Bl8asZf2qSDnK9ufRmfmCBCkmNfMNAXu+r8QCbBciNowvR80OkmCMGBwP3ai+uXVD1YKK/netTxNoTB2yOy0+fUtfb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 04:19:39PM -0700, Suren Baghdasaryan wrote:
> On Mon, Aug 31, 2026 at 3:27 PM Carlos Llamas <cmllamas@google.com> wrote:
> >
> > On Mon, Aug 31, 2026 at 11:13:16AM +0000, Alice Ryhl wrote:
> > > On Sat, Aug 29, 2026 at 06:56:25PM -0700, Andrew Morton wrote:
> > > > On Thu, 13 Aug 2026 12:34:28 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> > > >
> > > > > v2 version of this patchset [1] was written by Dave Hansen and per his
> > > > > request, I'm taking over this series.
> > > > >
> > > > > tl;dr: Make per-VMA locks available in all configs. Simplify some
> > > > > of the per-VMA lock users now that they can rely on them being
> > > > > always available.
> > > >
> > > > It's been 2+ weeks so perhaps a refresh-and-remind would be helpful.
> > > >
> > > > But it applies well enough and is adequately reviewed so I put it in
> > > > there for testing, thanks.
> > > >
> > > > AI review might have found a couple of pre-existing binder bugs:
> > > >
> > > >     https://sashiko.dev/#/patchset/20260813193433.3318288-1-surenb@google.com
> > > >
> > > > and a small rusty thing which you might wish to attend to.
> > >
> > > The binder bug is not actually a bug. When using VM_MIXEDMAP and
> > > vm_insert_page(), the vma takes a refcount on the page, so there is no
> > > use-after-free even if free_page() is invoked without removing it from
> > > the vma.
> >
> > Exactly! I agree the refcount on the page would prevent the UAF.
> >
> > However, we should still reject mremap() because this leaves the page in
> > limbo since it is not given back to the shrinker and also binder can't
> > make use of it anymore. I'll send out a patch to fix this.
> 
> Ok. Should that block this series or it will apply over it?

The issue is pre-exiting and unrelated to this series. So I'll take care
of this separately. Thanks!


