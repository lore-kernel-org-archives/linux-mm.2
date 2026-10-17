Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7326CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 17:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88E016B0088; Sat, 17 Oct 2026 13:12:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F146B008A; Sat, 17 Oct 2026 13:12:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E116B008C; Sat, 17 Oct 2026 13:12:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49DAF6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 13:12:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6CA7A034D
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 17:12:08 +0000 (UTC)
X-FDA: 85332761136.22.6C235F6
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id DEFB0100002
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 17:12:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=seYo85+J;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=lrizzo@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792257126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQ0S3+GvPqkyCnzw3WaiERWE0gQzxysyRgtfYYbHNSY=;
	b=TNmH4xFXFvotD9IWfUG1xLSRMBCRIsVm5rkeyGBnY8GPurOonOxIJxNUj+qHZwwDMtwD3X
	L2sxjOJ65p++bX0KJM4HY47Lv8Z+ZpDue5EUpGwi/jGykhqBS29Rc6aRlktIxrDzFQBDv3
	lFJa2Wzfqy2ZTeJBZRP+5UUGQ7tGHR0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=seYo85+J;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=lrizzo@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792257126;
	b=F3vIAfnBHIuM+Ylxds6d+Ou2Nx0ESNzCTRsU5RYBXjPey6fdZ4XaxfXmIjYPsyi8TkBKNe
	Af4FTWdSB3qCOMGjt0k5yaa/W2D4o4hQas8dj3gj3lVCW71TKkyjLhnEGLB0ZPH3wOfi9u
	CgeXPUcV8ozS2kuXEfS7r5z349zwbcU=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so24845ad.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:12:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792257126; cv=none;
        d=google.com; s=arc-20260327;
        b=gZeXY5pl/THEFl65bEyjw2ndz0AU6U+qLibU4FmZr9J+Je1DVuw+4DRWzGgGbkTBM4
         Kn2ev3SkR3qeiOip+VKV/c6rdcjfgCVc6jRvsdMeb7T2E8ViALzizqy7iGuIOoF3VcUr
         CTMR38/cpGusKiADTkiESZOKB0tXeILeQzFpn5Wdn1KZaweyibc/QqIasnDfoJXc4Msp
         IXZ88s60/q94PD9LZYMaP6+UahRwhi+sOFfMO6/gTFW6FvymgReBtGUT4COVTzOIrXMb
         33PODl6aO+seVKBo65bv5iL3jiUcu90XbZaamOEsIFPMN4N4h4k+WE8Cf2If4Ok8Hp7u
         VMbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TQ0S3+GvPqkyCnzw3WaiERWE0gQzxysyRgtfYYbHNSY=;
        fh=b/HeXeWSkKhrBTcNfZwCJT0S8SkvqNwb6uMI2ok9tU8=;
        b=QgIwikr+GL5O96ev9IJruC47dKUnRUDwIRBMEUO2aDUBs6yjaXW4jsZWHSHrnJkY06
         Q2/ANbuzTxJUbs51kDaJDO00JFCElWNf4PlkKf1a8zpuM+gkPSGnuCaELqZcuWYRxprJ
         SKjyNUuqcGWQcmKEiwDyyPN3/FSDGNEepYETiwA1zPMY3aUlOfAQKKlYG7dAAv+NX8Yl
         +Vt2p/v6OjlZRsAxxdG1mXWJDqT7Sovz+ahxdzmKS9ppdIPsQ5SC/2V1HEeOTV13kBlh
         gA4Yu7gTfeiqSjNeoD0cZxd6l5+NUP8huee9ikLDWbwuRfbR3chcfKYf+iDBGJr9ZlLZ
         ykSA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792257126; x=1792861926; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TQ0S3+GvPqkyCnzw3WaiERWE0gQzxysyRgtfYYbHNSY=;
        b=seYo85+Jynx/hcJzMMG1qfTLahUiR0HGWBCErYASaEnr635DqbyUoB9kSZM2HqoxJ1
         HYsap64d2S3Xn5kwuTp5ECe0LhA4WAIKGKL2ptJimDNcHf1duwfNBW08/8RLmlm5M7PI
         N/YS2BXjG+NcgROL7F950fw5W+692ro2J0xaOjdE4nhMm5CoHwieCQ+WJnZMULuJ2MIQ
         W2DtjFJgOKNs9CwvED43JDqRWHwCxyF5tSBXtbBEgI0blq6JeJ2i5nLfVDCQjlfjee1r
         n97R905tH8ZWAa2ZdjVmd6zrN6rKop74VGw6T3/jeCve4J4VjGCOunO7niEdliKNZYc0
         kI4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792257126; x=1792861926;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TQ0S3+GvPqkyCnzw3WaiERWE0gQzxysyRgtfYYbHNSY=;
        b=LG1PrmH5bm8Scs9QyhgjesYvl+0FjFj731tXjbk8DnuvqnOfUsr8Irx0lpBoROweR3
         LiFuqmYPDgzTPIOIzA9lKlkAotbTPpdnmf29EbAt0DnXJi8D2h2LxZv3uCWCYvm5/6kV
         VhY/KsBGESDW0nskgd2XDV3XXYsXF/gyEQYqyWOtGceQm8nfc9URrwcEhIm76ExWvZIQ
         w1tR4fnyjsJoBiM3Ok+47IHf91BvmqWJQu/kFq+U8BoBd3wPxJBtyfkoLdJy0ykWRyLZ
         rSsowF1BbridWrtg6mSAQx5Hq3Yibc6mWkArBOlR4+0D+wEEona/r2dwmo7ks3DOdTld
         4URg==
X-Forwarded-Encrypted: i=1; AKwUvBxxRDmPxDL5ifxHw4NInc6hNujA98He5rW7oquLJ9I7br25G+QvCm+o+pVLajKmug7GqJR/WtuzKg==@kvack.org
X-Gm-Message-State: AFq9FYL4GbDAYogKNNzlbDr/l4c/Z8vFWEBfdYneQvXs7L8KGlhxlq8J
	GBLk/wP24qP0coPgPIKXhNTCZHGdSzVeKm8JDqUwp39vfmYio0nimpI1z35X2wRcsXKRfnoYCma
	90SjnOVGW2zE3b5VAv8o7eWNTh7kNmA6wK/AQXGWO
X-Gm-Gg: AYBFou06Y6w0HITPZx36Ub1fxNiNjrl3/f+uSmylyQskq+hw6limLeoFw8T/p0OVRDA
	Gv5tL/t0V6ymlg5Gyu3p3fOB5thFsE19njj1C+Q/yWUA5+fbZHApydmB/8ejMWFHdm3KYh3XWTs
	zZocRFOUeePcFkvzot3YQ4Zs1clgq+fpKU8c04cO3/0i3p4yLZi16afzrKXTmwA9vlAyLOJ9Cyc
	eOUzYGov4FhywGV0PQqKZw14GzMhHDqC26a8wYqsFFFxS4KYGvZbH6q9lHm1Vc3deFYnjmyveiC
	hffgr9ijlAGjicwxlSzB+g10UlhAAP3kRfjgWKmDZ/slBceBgEnPitp4
X-Received: by 2002:a17:903:144e:b0:2e3:981:4cc4 with SMTP id
 d9443c01a7336-2e9b3252cdbmr3330175ad.9.1792257125060; Sat, 17 Oct 2026
 10:12:05 -0700 (PDT)
MIME-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com> <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com> <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org>
In-Reply-To: <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org>
From: Luigi Rizzo <lrizzo@google.com>
Date: Sat, 17 Oct 2026 19:11:28 +0200
X-Gm-Features: AclHuK8222c3YwWa2EndazmJS8Umg9HTADwML-hsKq06OdSigMokkN9A-iBy5wE
Message-ID: <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DEFB0100002
X-Stat-Signature: 55sct8ca859ezofy98tquojzu9dekfur
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792257126-185177
X-HE-Meta: U2FsdGVkX1+mFxlKySQ055sk99ZuVi7rvlFohPx2JWWDZVjGk633zOnWeBMrokSBfZoKGCBa1jWywMR1PKDLrTOx9K4mXRBG9l7Nq4i367Hgx+vgqwjI0qBocDnuFLCwGvgOfIazVwhO01OlbRlr8oC7KCkd6GR4gyrXvN7ee0zP6QaPghxqDVViEErJaIpzMYq3JTa8hTOt6H/JX1etPBmq4fTkdTa6T14o/tlTNUrtOZ/OOoN9HK3vYd6W9WOaTtfewSuef5QZQn2lcEW8Inb/+mHz0QBdJTsS4v6XyYrFiUDyZlTcO5Mc8tRLljKFuq1o5DSNwNw7JkrMK762MN3dWzYl48j/bzce8B2KBnLNWVluhc6kvcY0YNqkkJP9oEdfvCld/LVYbcUeO/hvi3GockvmEecfX1L2aq7A4wSJoHj2qTjUoOxAqyusucGBIWbOFcFp2Dfv2kC7nyNXnQ7h0qj15I4+NbUquKHYh60CqWT5+ZHI2KcD/zEROIpUvoIV/v3PlDIPGciSA5nC4n+neHVlM3DgUN3gZWH4fHg9nmtFXN3Ib4HAVX/18TIPfO5uWhr+zjGa3yIM2sIHPyCKQOz0fp7gnEJViZFyoy3Pme140UiusuRDjIRtyOX0Cabbaa4fO1ZjGuHEW/+Sso+g+Kr99WJmR5x1jgov5XOfsqiYcMOcCmIXWOT+jHY9OBg3hy9wcAbdQx0q12qS2oEJx+ri0u4gzKQHtAk8iI25SbiMd8IdTEAPr+FkC9mh+zkDov/Jg1qM/dkRn3xoGJU7cXksQD0q8XVixOGzfh4sEVUTD4faUnxE6zVrHtI/kIpi9gCTbepszrLAbB0k1z8TNS2OQu8ty4HN/Kx55jOi6opcROfAebI4UVFQUZbbz8vxJcSTs2GxAuVnTydcBDsITF3iZ/btu1CzZ5r0+8LCdn05SU1Z2eaYNCsh/UNfk2ph2ncgLRjpBxf6qD7
 TtXrMF/Q
 7TIjE71f88uJLA2nTCdG9GAOOHAJfCp60cqO1239Fw3VaAhI5O3wbQqX08biM+RwoRCkTxeZuyjVgbu1SAux7iS3OYu6vIH/WPylNBwRLYz4XlWdFDqUQB1tX8J6RnWMyqmCg7lX99kLYcta4Tmer0+8MfC2HsJiTvfcWiERphU+jNJs/ZKia5ZRNwrkrW3EU4V0TRIzAeYlRFPfWUeugJj5O/BHeFoWavmi+nVBEHvpny7wRtDcuItdCVjiQBz7IO0N/kJRL7YHMkTLzC2ExfXwR4jzwb2aLHOOlu1NIHjI88riPipZnL192mN/JR2EnDYUdtu5S9KFX4ZZ0qV5Rgrs/qA30PjfLaSv1feXN8dm/HQc57wv7LZRvnnE/aJK1yvtt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 9:44=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/12/26 16:45, Luigi Rizzo wrote:
> > On Mon, Oct 12, 2026 at 3:51=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 10/3/26 23:22, Luigi Rizzo wrote:
> >>> Here is a subsystem called DMA_PMD on which I would like feedback on
> >>> architecture, possible enhancements, or kernel components that could =
be
> >>> reused to avoid duplication.
> >>
> >> Here is a feedback to a subsystem called DMA_PMD ;)
> >>
> >> Why is basing this on PMDs (and embedding it in the name) the right ap=
proach?
> >>
> >> On architctures with large PMDs (512 MiB on arm64 with 64k), would we =
really
> >> want to use 512 MiB pages, or rather something smaller (e.g., 2 MiB) t=
hat might
> >> possibly also have TLB benefits (cont-pte)?
> >
> > I had to call it something... an earlier prototype used the name IOMMU_=
2M,
> > but I didn't want to suggest that the design was limited to 2M (it is n=
ot).
> >
> > Aside from the name, the _current_ prototype restricts to 2M allocation=
s,
> > exactly because too large units are expensive and wasteful.
> >
> > In the code, decoupling the allocation size from the PMD size is trivia=
l.
>
> Yeah, we should do that.
>
> We should probably just find a way to describe that this is a POOL that f=
ocuses
> on physical contiguity in some configured granularity.

Before embarking in a global renaming, I would like to get opinions on
acceptable alternative names (possibly with a short prefix usable for
identifiers in the code). I could think of the following

DMA_PMAP (for PreMapped or Persistent Mapped)
or, ahemm...
DMA_PISA (Pooled IOMMU Superpage Allocator)
both using dmap_ for internal name prefixes

Other suggestions ?

cheers
luigi

