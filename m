Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9548DE9381C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 05:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17076B0089; Mon, 13 Apr 2026 01:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE8F6B008A; Mon, 13 Apr 2026 01:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03FF6B0092; Mon, 13 Apr 2026 01:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AF68A6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 01:36:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 392628CAF7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:36:35 +0000 (UTC)
X-FDA: 84652422750.09.523D3F7
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6150E1C0005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:36:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mTaw6PJ8;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776058593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/X2QfEAZrHNubsDZK1Rva+fNiB1w8v4TMc0y0Ptc/zQ=;
	b=ZuxBVFg97OkMbE3wplRaz+4+tHtJE3EffcL7c/pVDSmOD6hVKwdVZqSpKT2Cgax2O9Tz6C
	bQy5bm9U/RxQTl6ZfUUwc+jM/m+8WNT1HvaCkh6bQbXoxwSf3w7Haxa7IVRuQMdr8tex0P
	J0B1JjwiNpa4yPgpl9BvU+aTLTvCMzs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776058593; a=rsa-sha256;
	cv=none;
	b=rqtALF5HKD2/9Nu6J1Sf80pB2AZN1Lf3TCkSbwm4ZlXIZlcLrocwsgzHLoc/8TAdQ3TRgt
	rIqHKLHNjeIKFB69l6PDAKGDOcutAnGqnnHVcwigKsyG95oNrmD4Tdosipkf06F9V/5dmN
	4TJ8mG49kfDjYhvKOXyNyLjCyQ4z6+A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mTaw6PJ8;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8dfb9139008so95106885a.1
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776058592; x=1776663392; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/X2QfEAZrHNubsDZK1Rva+fNiB1w8v4TMc0y0Ptc/zQ=;
        b=mTaw6PJ8txOHYOsSk1dPEXgzNA1IIpNrLL6TgBv0RWCC/+ztnL/t5lCAoK+sbh/pB3
         Nf3o90QeBFdz4ObnaJQZ98p5m53sMmTUQOAI9Z2XDIxnX2Yx+SLiu3QSGPnAB2mFu8e4
         EF5LXxAxFUMM2hGkZUmgiDQ2xOih9PHnkuNK8kcMf6eCuYJNOeIEN+5dx+SagyOSOYRP
         8mct5v4L6s9fcO0EIIPd69//rCbEWgQXHgb3yToKvfE4wx6Nuc5YZ1GJXnsaw3uARM3W
         RT1gEy5fVLjlBwPoLqRWnhi/GUlKramp0ySeq5irimJtVQYRvxlRVgd/+Dgxr6OSreGY
         Mkbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776058592; x=1776663392;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/X2QfEAZrHNubsDZK1Rva+fNiB1w8v4TMc0y0Ptc/zQ=;
        b=RCvKjveRV+tjkOge9k5hGbaGxBzThkhNPRF0O0a7WS/zG2dyPZIKM0w/ZFhlRKw9Hm
         EWQpkoameXm9QoIcTwCPw/ZvM5qVuA33+/h/jrXHS3ZLSfSFD108Eo6PJhjNzI7QNPU6
         YU99zVmh4OgS46+F0eKWFvGEj4+3HclNyPD+1Rn2l2R1qI7ZhzHtJvXmFDA+sXKhNano
         Yd4htHfxiq3aNCn6aUAgBsBfUBZVgWLjYstM9p/01unAkg4v1KaMQZc+U2eFDkHHbvJH
         xRkoo2xk1lFxsVmALWwnMgZ16PFFNJBOaSEpV4HrKeb+HO8qyZwScneH9w0xa1y3iyGc
         xGjg==
X-Gm-Message-State: AOJu0YxqTTH85fR7r+5f3BW/KzxYx7qrD2RwO7HwwcaaNt2GaQgOKCio
	tKGF8dFxSIUvpEMEnDPaUiGBev0YTZY0GGOUDU2Hk/nzMsIsWy+kpC6Y5vFbWKCvHo0=
X-Gm-Gg: AeBDievo9Jd0DlB8voyj3wbMXDlIh2C4UTBhBqSlTg2yODiyFGxtYenzg65/utc4Hxm
	fg+RgXZqgP2wsY4KYh440V81d3TsWWiWkCt1Y2YmCrkZBl6KYF5TpKdvtwFGHbp1vOCbNR6cdhM
	MI5fNH8ooUEaSzauBXqc+Dneg8qAXf4IydD0P0FFhr76ZT9XZhbUMWAipRAJ4X683TQ1nJR3vdW
	56t1/9/okQ4zoHLxID6XbmFiw6q4eW5u+zV2MWQMK7su/lvV+cKZYN6SSze+2OWQ9Io4DAd/5+t
	NvqO6FVGaAAMawT4V+CxlpmMPfzUtV34IbJatNPgOvlNOQA09yagM8XyYgJkF5lJQCP2mZBya2b
	pYzVoKzfLebvWzveL1nMMbHHctAF4SSxCtrExJr/BpOdD9otNkIpQeAjQHNkTQLrE0YvBNj3Nyx
	JFoPipBJdPtf0EjcPpNvCN0lyftGwg87/fnPlxHApxP5gCJ9IH469MdcheRkcx++NbI7bX0ar8n
	FiuaCWgHj7C
X-Received: by 2002:a05:620a:4013:b0:8d7:4f7c:873b with SMTP id af79cd13be357-8ddcdbe3c79mr1768071585a.14.1776058592318;
        Sun, 12 Apr 2026 22:36:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8aca9f7e0b0sm25350806d6.11.2026.04.12.22.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 22:36:31 -0700 (PDT)
Date: Mon, 13 Apr 2026 01:36:29 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	rppt@kernel.org, peterx@redhat.com, surenb@google.com,
	aarcange@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: preserve write protection across UFFDIO_MOVE
Message-ID: <adyA3X2k1GdzxOEZ@gourry-fedora-PF4VCD3F>
References: <20260409152822.1073083-1-gourry@gourry.net>
 <20260412111807.42c3edf86d19528d7cb1bb7b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260412111807.42c3edf86d19528d7cb1bb7b@linux-foundation.org>
X-Rspamd-Queue-Id: 6150E1C0005
X-Stat-Signature: kewsejuz5pr49razoktdxwjkk943bdzj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776058593-613621
X-HE-Meta: U2FsdGVkX1/U0a1L76Ooiza8DH08d9uwQi5TRzdTH1OHkmqwU1ClVUpPD8WhYy1sIrzJuMmVmwdj3HzTTBs9Cp6aZ06oT9JIEsnN5wwEeHxvrcZykAY/9wd2/MlUN5ASKtHhbgOY+4gZD+F1y4gUQVLT6amja8jNlVvK4yaAUzghP9vibgenJIZ4f+Ema3ttjwwAGATmIZJpNH19lVCA6qfmAtoVFhJAlgykB6e1imYr/tGBxAytBWetwVWnNSomV/lOZv4K5p2pRJF2KK1scy8KohsuX9FXaILiKfMBh28D1TnDjdX98gTf0wAtMABDgbUtti3bbSkHC04yMGwPnoge9x8waOpiK1gF1Zi6DlmtKxW4pda20AH1cgl20nGVg0b1RIz4RJER4xGluBy4TnmM/EY+ry6k6nA77bPJ9CoPaa08B7bDBMkp6HMRIfcSlxZ7C0ny1QqJvFCXut3YEt6Xz3sou9SOFazo7sVH/dBNkRWS+fjkn6wUNJNLNR5gi8htjBMxMPPOqfWMSVBjPl6KG1dMS8reJr1GJHbz8mRkF38v2O00GAywbeHZ/KT2rUHZLuvwqp2RQmolsSoJU2yfgAMHE66Z0F8tFdZG8y59/TnVLdlm6KBebsDZ7CezPD8Qh2Er1TutQ/KSUDzk7+ZqVuR/Ew/1Fz9QkC8+PIIaL6s4poEA3wnrlUhsH4m3zwxAi2N5OccBkkEVt/ajh1Tt4U8Rsg5JMn9Zb8Zc7jFqgb/aW9BLY2KG72OpglMb5qr/ZofBQYwicUvAv3ig2sQyZ9FB0n2bcxO8VToFRABPZ01U66gq7JKtNWi0WKz/qfYApnC5rYGGMfFpDLHc1R/0ahVnegDRS5cF2rmyKQf+6cYDOXm/QMTxrclOJzGkmxW+dDUHeg388QyRW8J5MID6nEYXxcJUBE9/2JpuGbPl9NtWVqtzbFeTEz2a16KtFpoOs13c+Xc2/peKY3t
 en4YubKx
 x8uhiWdcLyx64R0dpmgkgofmXgddniKDPIwOOhpRS0c0MK4xx6oxksNXJhkZ6FkAPGGR5N6jPxzL6LPiBDYbIgDhPLlvFr8cnXW20m+fAhm4PbE/7BRYcG8IiXNc6Rmy7baaK44qrCszfXwoeqQW/n8c7iXQndlUomK25mAZBFIRnlpsQtWFO6T6HuKaoZmY8HXgwUEuQIFeBkNdrStkfnlOBF2MtEFfAN6WCPma5PPcYqMKUBMEbQu2uhicW+aXLZEXIXryYSPYUSXl1w7HpEUfEzGi4TE9X+M88RNdHDAFcPKTYQg7H+BVyBrXHqp60aJxdgFbV3ly7ejfJswmFnOdoj6tSuZjGLi2o21GONIdp+zOiNdq2u3T98yo7lFDWUOQ4uOX5EDMiKws9A2Pk9BWKG5Wv10QSiyHAuHpY8vM4H6HST70hMhAVrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 12, 2026 at 11:18:07AM -0700, Andrew Morton wrote:
> On Thu,  9 Apr 2026 11:28:22 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > move_present_ptes() unconditionally makes the destination PTE writable,
> > dropping uffd-wp write-protection from the source PTE.
> > 
> > The original intent was to follow mremap() behavior, but mremap()'s
> > move_ptes() preserves the source write state unconditionally.
> > 
> > Modify uffd to preserve the source write state and check the uffd-wp
> > condition of the source before setting writable on the destination.
> 
> Please can we have a description of the userspace-visible impact of the
> bug.
>

Simply:

  UFFDIO_MOVE silently drops write protection from the source PTE when
  moving pages to a destination, leading to missing write-protect faults
  after the page has been moved.

I ran into this while futzing around with some user space management of
VM memory, and expecting a move to continue firing WP faults after.

But Sashiko actually made a useful (though obtuse) observation which
has made me realize _MOVE is actually ambiguous on what to do with
source region UFFD modes.

> > +		if (pte_uffd_wp(orig_src_pte))
> > +			orig_dst_pte = pte_mkuffd_wp(orig_dst_pte);

This line assumes the destination must have intended to be WP, and the
the result is essentially stale uffd wp bits in the opposite case (a
user not intending to carry over WP now carries it over).

tl;dr: this is more of a semantic change than I'd intended, and the
existing tests did not catch it.

The correct solution here is to make a UFFDIO_MOVE_MODE_WP flag to copy
the UFFDIO_COPY_MODE_WP pattern.  Otherwise:

> (presently wondering if this is backward compatible)

Yes, you're right to wonder - this does break backward compatibilty.

Will come back around with UFFDIO_MOVE_MODE_WP.

~Gregory

