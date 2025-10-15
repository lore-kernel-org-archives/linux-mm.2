Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE30ACCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27C928E0042; Wed, 15 Oct 2025 10:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254278E000A; Wed, 15 Oct 2025 10:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A6B8E0042; Wed, 15 Oct 2025 10:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F23A78E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:23:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A9D4256433
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:23:08 +0000 (UTC)
X-FDA: 84000565656.09.8A22A1C
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id CB33A180009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:23:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ND1Ax6Pb;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760538186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PAtt6LJWXf75EYio9dz/gTvlM96/DYgKuXEluISNUPw=;
	b=ezLo43s4QMK+ULGrDMyUlQgujEA+obNBCrliZM9JSdDoZ8+6uECu4bIGrpqQ3dScl/XnFf
	7YDRIELVIdphsyb6VQsHt7z3UcsuWvsuLNXaA/rFDrLNx+vYz8/Ts2+qVGjvzKsEtNemI5
	/zRIPPUyvpKGnXLj9DFRVpcxZ3+S+Zo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ND1Ax6Pb;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760538186; a=rsa-sha256;
	cv=none;
	b=GDfFpFqJadhNW4MAVenj2sy6f0XDNoNxPLXwmCwQQBV2X+zZlk9y9HLsvcc0WCJIJNgAIL
	QoBWC1UE6vF3yMGklvwA4LkC6PKwRa5DnjvwD7zx2km1F7gfr+aBRU4ty0tXWrzbx4/01K
	tMc6NPYb4pBmN46qFiPFF0ReaDMrSP0=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63bad3cd668so5821136a12.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760538185; x=1761142985; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PAtt6LJWXf75EYio9dz/gTvlM96/DYgKuXEluISNUPw=;
        b=ND1Ax6PbwDKq9nA8WDXZ3DvyPlFlngT8sqJiqCiKbU20reQ2n8xmRnDczURcrikjYL
         4wRKnlp0fsZEsnANoksWPhE99Ypuw7EkcpSriLrNtodzCYaZsn2/MywwApi16QsNZEsB
         uKiYkIkAoE+RCFUAoe5UoIHt54l8JkNm0HFnDayU8uTmDGsG8Lk1NRJKGTTyzeqv+bN0
         0Mf4dK+tKl4NPtbBZL6TQW9DJWR18oQN//3OIQrWgFR+LY1rpA0ju46JVpAN/0BhZdRp
         DoM0CcCFpT6XSEYxSV+UQOpSJ01qc5rDYGIRVv9BaDXVta0P72hIIem4VYzCyhlpnRcR
         b55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760538185; x=1761142985;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PAtt6LJWXf75EYio9dz/gTvlM96/DYgKuXEluISNUPw=;
        b=q9XbOMHOsMBkHPEOOpBrWHbkPHTgMHbg+64Bspghahav6zXyJEAXbQTz0aDo/lvM+E
         poIFxsYRADu2uu124/SvZBEjOSuRqW4abyA978qz2JXSwAEsdFW6Wlu6lU0xKDtIv9lx
         i0QGF+CPCs2zTmNhQzwH3ag+azNGdABelKVs35kICZLC7vW3zbvscc/VS3teh9Thcb+F
         iYDhOoGFpwQwo1GoV38uqj583ZLMmDM2z4fOCdw20brMxleAAefaCgkeLzDMGI5ESyPw
         aAbJNKrBpjZUB2Pu+QanRQGXkxViDTBUcMSFVKWF1q314u+mHHATM231tzw0jZx+b3DG
         DKwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVhTY1tEnVKtoM5z36j5QHP+N4L+AcocsgZe/mDw8K3ams22GeRmXHU1M3gKlZUXqiSJ5TaX9ioA==@kvack.org
X-Gm-Message-State: AOJu0YzFtFyx1HVCXhtQ5b9PybMD8inZ4wp+44im1ltxwiJYp3h5SDgH
	lEUUPIWX42l++nBDhKfbH2YqIBiA96WY2sgdIzOaIX0h+EKBTChn/G800r0kVTYVHCZn6idVCVp
	l288rG8Tay19CL0V8exLsfy3bPFVfBmQErAAwjjH9eA==
X-Gm-Gg: ASbGncu6wVuAnc16klaloax3eqAkig6FjsgOubK5owd8BTUTeDCQTHK2WwZ3Fzuol0t
	3EMzZmAc81ZSnXUn2LTmZfVoPOsCf8ZTSVoKqsIJd+rgkWMbu4GgE21aWm67KAx/KcNHJV51mTG
	8xa8+3DPfbgse8olXrRAY4mjK1vfgx5sm/TpdZA0gV4CgUL4clnpolsIejxFgjW6oiXoVILfIe+
	qP+y8FK4kinYohgAnvj494bUSsLskI0Ew==
X-Google-Smtp-Source: AGHT+IHt07hyRkueoFkR4F0w+xF9Gbyc+PiDwaAgXzfFVpNxzbBZcK46A+MFwX9oxnYBoVi3/21yDow56czseXIBw9E=
X-Received: by 2002:a05:6402:27ca:b0:639:4e0b:2724 with SMTP id
 4fb4d7f45d1cf-639d5c31fbfmr28772103a12.24.1760538185250; Wed, 15 Oct 2025
 07:23:05 -0700 (PDT)
MIME-Version: 1.0
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-3-pasha.tatashin@soleen.com> <mafs0v7kgjoxq.fsf@kernel.org>
In-Reply-To: <mafs0v7kgjoxq.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 15 Oct 2025 10:22:28 -0400
X-Gm-Features: AS18NWArNFoBhagluGBh83EOX5thK2VCtA_UuHBzGdmFvoOqbuMsR--L8cHX_oM
Message-ID: <CA+CK2bAHk2JnQwfA0fJo1qmcwoO_9eeG5_DSL_6OC+-pyT=7Jg@mail.gmail.com>
Subject: Re: [PATCH 2/2] liveupdate: kho: allocate metadata directly from the
 buddy allocator
To: Pratyush Yadav <pratyush@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com, 
	glider@google.com, elver@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CB33A180009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xis1m9ofzuwkyhbcj1tykdgyhyiopjn6
X-HE-Tag: 1760538186-537169
X-HE-Meta: U2FsdGVkX1+syTMeZWhuevej8mhzXvXnj0zr0QRJiNQsSX/b9XDkz/rOtU2AWoDT3beRMSx7c+kv+18RfqQdF1zqYV4+oEbCx/r5PakMt9qKWJbWPXNA7yqRcxG0pJaUK+LDBw1MvnbEKXHrMcPJB8TnvdPWYmWkZld4Tpk9XSB3+mWzd3GcaJUSKLgup/3E3kjgqJLWZZ/Gy3Zn2MuBR4Nn01XjFDgluAlU8s9zwoVH8vRQSm21dMnwoyhwjbzLepKjSq4xBNIociJkykuLXGWeQxapfsAWhKTEWK99+o3f66kmVmiNFFqeT1NdGwKLtHOf/L8jxNLl/nIbrTftQ3CKisgMk0RzsPJrE21fNtN3k6dY6pkwXAoti6BNrrPubK8WMgwlURtjn7kuRQvSc9QTitQzzhQVgn2LJGYsa3Nw4hIpGiAfFkqqci5L7FeheYsB4HZ7vfeOTBJPAFqBjNTK4TPtNycmXLH+ip1FWT25k5fhDszY4WA+Gxu+XFwlV0qLt2tNyvd4sNLYMO0c6anZf7tYTKHhzSt9ASpONu2z+0t3YOkh1zVhlFCH1PnIcx4MtwyQz8yRI7sm6qmMN2RfQ/R/7lFmvmfVJvzJewh1exQ3gP0/LKFHDf26qEoeIP10BwayghsJMcJCWHz3UB7Xtg5EU2WpJXVL+kA9AtZuuxcBDKIct0qqE6+d7UTjfD7nzrCaSch+C1KopF4ywQasG0qnseNDKSFFdYPhZG/qyKz3tPH/S5wD9V6AoFBY+axK6tF1XkTSdSjrOQ3DvD5mn/engjgrI4RRLRQ45gjYaoAp3wSA6ceOnwD3UhZv2bHEd17sa52jT0Y/mZwrX7ad0/kZVAcKK5E19xRDjy49q7Zjop8LfVw1J3P1hFM53nZkC/jVs29XfLq22zJp8UsULg+UV57DKgNAjtquSoUhXMXXTsgSiTehZF5riyezhdR0vTIMWIyz5otJ5cd
 l1+6EXKf
 crlMdswJBYGt7TDXX1c/wMC5rIxGFiuFbknve7cMKcUI+iWzhWFB+dN8FhuiiK2d9FAVkOpdg5yLxfskj/QAyPDsu3yledDgFutGcUu2xA0Y58q7xzTsCzze/SK8K0+WmxdFonwPxitrflLpXJ5AAtCGOq8ot/iiHSjmullzxalz0kn+4YoQ1ODh7x+6vHgOiPgFOxN5itptENgoZBfSgTNXVlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > As part of this change, the metadata bitmap size is increased from 512
> > bytes to PAGE_SIZE to align with the page-based allocations from the
> > buddy system.
>
> The implication of this change is that preservation metadata becomes
> less memory-efficient when preserved pages are sparse. Mainly because if
> only one bit is set in the bitmap, now 4k bytes of memory is used
> instead of 512 bytes.
>
> It is hard to say what difference this makes in practice without
> sampling real workloads, but perhaps still worth mentioning in the
> commit message?

Forgot to reply to the other part:

I agree, however, I suspect the implication is going to be minimal, it
is strange to preserve fragmented state and expect a fast reboot. Most
likely, we are going to be optimizing the preservation pools, such as
using 1G order pages for guest memory.

Also, we are moving toward preserving 4K bitmaps as part of the
Stateless KHO patch series, so I think we will make this change
anyway, as part of this fix or as part of transitioning to radix-tree
stateless KHO.


> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Thank you.
Pasha

